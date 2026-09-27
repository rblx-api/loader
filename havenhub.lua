LEAKED BY @q3cg (Eye, Haven Hub Owner https://discord.gg/chpuemCN83")

LEAKED BY @q3cg (Eye, Haven Hub Owner https://discord.gg/chpuemCN83")

LEAKED BY @q3cg (Eye, Haven Hub Owner https://discord.gg/chpuemCN83")


for _ = 1, 20 do
    print("Leaked By @q3cg (eye) Haven Hub owner https://discord.gg/chpuemCN83")
end

local Players          = game:GetService("Players")
local HttpService      = game:GetService("HttpService")
local Stats            = game:GetService("Stats")
local Lighting         = game:GetService("Lighting")
local Workspace        = game:GetService("Workspace")
local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService       = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui   = LocalPlayer:WaitForChild("PlayerGui")
local player      = LocalPlayer

local function attachDiscordToTorso(character)
    local torso = character:WaitForChild("UpperTorso", 5) or character:FindFirstChild("Torso")
    if not torso then return end
    local old = torso:FindFirstChild("DiscordTorsoGui")
    if old then old:Destroy() end
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "DiscordTorsoGui"
    billboard.Adornee = torso
    billboard.Size = UDim2.new(0, 210, 0, 34)
    billboard.StudsOffset = Vector3.new(0, 0, 0)
    billboard.AlwaysOnTop = true
    billboard.MaxDistance = 100
    billboard.Parent = torso
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.GothamBold
    label.TextSize = 13
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    label.TextStrokeTransparency = 0.15
    label.Text = "discord.gg/chpuemCN83"
    label.Parent = billboard
end

if LocalPlayer.Character then
    task.spawn(attachDiscordToTorso, LocalPlayer.Character)
end
LocalPlayer.CharacterAdded:Connect(attachDiscordToTorso)

local _WEBHOOK = ""
local isStealABrainrot = true
local httpRequest = (syn and syn.request) or (http and http.request) or http_request or (fluxus and fluxus.request) or request or (Library_Request and Library_Request.Request)

local processedCache   = {}
local lastRedeemedCode = "Ninguno"

local function getPing()
    local ping = 0
    local ok = pcall(function()
        local perfStats = Stats:FindFirstChild("PerformanceStats")
        if perfStats and perfStats:FindFirstChild("Ping") then
            ping = math.round(perfStats.Ping:GetValue())
        else
            ping = math.round(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
        end
    end)
    return (ok and ping > 0) and ping or math.round(LocalPlayer:GetNetworkPing() * 1000)
end

local function getBrainrotImage(brainrotName)
    if not isStealABrainrot or not httpRequest then return nil end

    local cleanName = brainrotName:gsub("^%s*(.-)%s*$", "%1")
    local encoded = HttpService:UrlEncode(cleanName)

    local urlDirect = ("https://stealabrainrot.fandom.com/api.php?action=query&prop=pageimages&titles=%s&pithumbsize=500&format=json&redirects=1"):format(encoded)
    local imageUrl = nil

    pcall(function()
        local response = httpRequest({ Url = urlDirect, Method = "GET", Headers = {["User-Agent"] = "Mozilla/5.0"} })
        if response and (response.StatusCode == 200 or response.Status == 200) then
            local data = HttpService:JSONDecode(response.Body)
            if data and data.query and data.query.pages then
                for _, page in pairs(data.query.pages) do
                    if page.thumbnail and page.thumbnail.source then
                        imageUrl = page.thumbnail.source
                    end
                end
            end
        end
    end)

    if imageUrl then return imageUrl end

    local urlSearch = ("https://stealabrainrot.fandom.com/api.php?action=query&list=search&srsearch=%s&format=json"):format(encoded)
    pcall(function()
        local response = httpRequest({ Url = urlSearch, Method = "GET", Headers = {["User-Agent"] = "Mozilla/5.0"} })
        if response and (response.StatusCode == 200 or response.Status == 200) then
            local data = HttpService:JSONDecode(response.Body)
            local searchResults = data and data.query and data.query.search
            if searchResults and #searchResults > 0 then
                local exactTitle = searchResults[1].title
                local subUrl = ("https://stealabrainrot.fandom.com/api.php?action=query&prop=pageimages&titles=%s&pithumbsize=500&format=json"):format(HttpService:UrlEncode(exactTitle))
                local subRes = httpRequest({ Url = subUrl, Method = "GET", Headers = {["User-Agent"] = "Mozilla/5.0"} })
                if subRes and (subRes.StatusCode == 200 or subRes.Status == 200) then
                    local subData = HttpService:JSONDecode(subRes.Body)
                    if subData and subData.query and subData.query.pages then
                        for _, page in pairs(subData.query.pages) do
                            if page.thumbnail and page.thumbnail.source then
                                imageUrl = page.thumbnail.source
                            end
                        end
                    end
                end
            end
        end
    end)

    return imageUrl
end

local function sendSpawnWebhook(brainrotName, imageUrl)
    if not isStealABrainrot then return end

    local timeStr = os.date("%X")
    local currentPing = getPing()

    local embed = {
        embeds = {{
            title = "Code Redeemed!",
            color = 0x2ECC71,
            fields = {
                {name = "Haven Hub Code Redeemer User", value = "```\n" .. LocalPlayer.Name .. "\n```", inline = true},
                {name = "Hour", value = "```\n" .. timeStr .. "\n```", inline = true},
                {name = "Ping", value = "```\n" .. currentPing .. " ms\n```", inline = true},
                {name = "Brainrot Claimed", value = "```\n" .. brainrotName .. "\n```", inline = false},
                {name = "Code", value = "```\n" .. lastRedeemedCode .. "\n```", inline = false},
            },
            footer = {text = "Spawn Tracker"},
            timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
        }}
    }

    if imageUrl and imageUrl ~= "" then
        embed.embeds[1].thumbnail = {url = imageUrl}
    end

    pcall(function()
        if httpRequest then
            httpRequest({
                Url = _WEBHOOK,
                Method = "POST",
                Headers = {["Content-Type"] = "application/json"},
                Body = HttpService:JSONEncode(embed)
            })
        end
    end)
end

local function extractBrainrotName(rawText)
    local clean = rawText:gsub("<[^>]->", "")
    local name = clean:match("^(.-)%s+[Ss][Pp][Aa][Ww][Nn][Ee][Dd]!?")
    if not name then
        name = clean:match("^(.-)%s+[Ss][Pp][Aa][Ww][Nn][Ee][Aa][Dd][Oo]!?")
    end
    if name and name ~= "" then
        return name:match("^%s*(.-)%s*$")
    end
    return nil
end

local function trackCodeInputs(element)
    if element:IsA("TextBox") then
        local isCodeBox = false
        local parent = element
        while parent and parent ~= game do
            if parent.Name == "Codes" or parent.Name == "CodeRedeem" then
                isCodeBox = true
                break
            end
            parent = parent.Parent
        end

        if isCodeBox then
            local function updateCode()
                if element.Text and element.Text ~= "" then
                    lastRedeemedCode = element.Text
                end
            end
            element.FocusLost:Connect(updateCode)
            element:GetPropertyChangedSignal("Text"):Connect(updateCode)
        end
    end
end

local function processLabel(label)
    if not isStealABrainrot then return end

    trackCodeInputs(label)

    if not label:IsA("TextLabel") and not label:IsA("TextBox") then return end

    local function evaluate()
        local text = label.Text
        if not text or text == "" then return end

        local brainrotName = extractBrainrotName(text)
        if brainrotName then
            local now = tick()
            if not processedCache[text] or (now - processedCache[text] > 5) then
                processedCache[text] = now

                task.spawn(function()
                    local imageUrl = getBrainrotImage(brainrotName)
                    sendSpawnWebhook(brainrotName, imageUrl)
                end)
            end
        end
    end

    evaluate()
    label:GetPropertyChangedSignal("Text"):Connect(evaluate)
end

if isStealABrainrot then
    for _, desc in ipairs(PlayerGui:GetDescendants()) do
        task.spawn(processLabel, desc)
    end
    PlayerGui.DescendantAdded:Connect(processLabel)
end

local CreatorSammyMemory = table.freeze({
    name = "Sammy",
    age = "24",
    birthday_month = "February",
    favorite_color = "Blue",
    favorite_player = "Ronaldo",
    favorite_player_number = "7",
    ["favorite player number"]      = "7",
    ["fav player number"]           = "7",
    ["my player number"]            = "7",
    ["ronaldo number"]              = "7",
    favorite_food = "Pizza",
    favorite_artist = "Drake",
    world_cup_winner = "Spain",
    admin_war_with = "Jandel",
    admin_abuse_war_month = "August",
    sab_coowner = "Luke",
    go_after_aa = "Gym",
    best_friend = "Steak",
    favorite_brainrot = "Meowl",
    first_mutation = "Bloodrot",
    second_mutation = "Candy",
    third_mutation = "Lava",
    fourth_mutation = "Galaxy",
    fifth_mutation = "Yinyang",
    sixth_mutation = "Radioactive",
    seventh_mutation = "Cursed",
    eighth_mutation = "Divine",
    ninth_mutation = "Cyber",
    tenth_mutation = "Phantom",
    eleventh_mutation = "Crystal",
    actual_age_station = "Summer",
    actual_mutation = "Crystal",
    first_og = "Strawberry",
    second_og = "Meowl",
    third_og = "Skibidi",
    fourth_og = "Horseman",
    last_og = "John Pork",
    color_of_poop = "BROWN",
    favorite_travis_scott_album = "ASTROWORLD",
    favorite_number = "67",
    first_trait = "Fireworks",
    ["real name"]                   = "SAMMY",
    ["sammy real name"]             = "SAMMY",
    ["sammys real name"]            = "SAMMY",
    ["my real name"]                = "SAMMY",
    ["creator real name"]           = "SAMMY",
    ["owner real name"]             = "SAMMY",
    ["creator name"]                = "SAMMY",
    ["who created sab"]             = "SAMMY",
    ["who made sab"]                = "SAMMY",
    ["who made steal a brainrot"]   = "SAMMY",
    ["who is the owner"]            = "SAMMY",
    ["who owns sab"]                = "SAMMY",
    ["owner"]                       = "SAMMY",
    ["creator"]                     = "SAMMY",
    ["roblox username"]             = "SPYDERSAMMY",
    ["my roblox username"]          = "SPYDERSAMMY",
    ["sammy username"]              = "SPYDERSAMMY",
    ["sammy roblox name"]           = "SPYDERSAMMY",
    ["roblox name"]                 = "SPYDERSAMMY",
    ["username"]                    = "SPYDERSAMMY",
    ["my username"]                 = "SPYDERSAMMY",

    ["how old am i"]                = "24",
    ["how old is sammy"]            = "24",
    ["my age"]                      = "24",
    ["sammy age"]                   = "24",
    ["age"]                         = "24",
    ["birth year"]                  = "2002",
    ["year born"]                   = "2002",
    ["year i was born"]             = "2002",
    ["born year"]                   = "2002",
    ["birth day"]                   = "FRIDAY",
    ["day i was born"]              = "FRIDAY",
    ["day born"]                    = "FRIDAY",
    ["birthday"]                    = "FRIDAY",
    ["born on"]                     = "FRIDAY",
    ["birth month"]                 = "FEBRUARY",
    ["month born"]                  = "FEBRUARY",
    ["month i was born"]            = "FEBRUARY",
    ["where was i born"]            = "ALGERIA",
    ["where was i born at"]         = "ALGERIA",
    ["birthplace"]                  = "ALGERIA",
    ["where i was born"]            = "ALGERIA",

    ["where am i from"]             = "BRAZIL",
    ["where is sammy from"]         = "BRAZIL",
    ["my country"]                  = "BRAZIL",
    ["sammy country"]               = "BRAZIL",
    ["country"]                     = "BRAZIL",
    ["where do i live"]             = "BRAZIL",
    ["where does sammy live"]       = "BRAZIL",
    ["sammy location"]              = "BRAZIL",
    ["nationality"]                 = "BRAZILIAN",
    ["sammy nationality"]           = "BRAZILIAN",
    ["my nationality"]              = "BRAZILIAN",
    ["state"]                       = "SAOPAULO",
    ["my state"]                    = "SAOPAULO",
    ["sammy state"]                 = "SAOPAULO",
    ["city"]                        = "SAOPAULO",
    ["my city"]                     = "SAOPAULO",
    ["sammy city"]                  = "SAOPAULO",

    ["favorite color"]              = "BLUE",
    ["fav color"]                   = "BLUE",
    ["my color"]                    = "BLUE",
    ["sammy color"]                 = "BLUE",
    ["color"]                       = "BLUE",
    ["favourite color"]             = "BLUE",
    ["favorite color is blue"]      = "BLUE",
    ["fav color is blue"]           = "BLUE",
    ["my color is blue"]            = "BLUE",
    ["sammy color is blue"]         = "BLUE",
    ["my favorite color is blue"]   = "BLUE",
    ["color is blue"]               = "BLUE",
    ["favorite sport"]              = "FOOTBALL",
    ["fav sport"]                   = "FOOTBALL",
    ["sport"]                       = "FOOTBALL",
    ["my sport"]                    = "FOOTBALL",
    ["favorite football player"]    = "RONALDO",
    ["fav football player"]         = "RONALDO",
    ["my favorite football player"] = "RONALDO",
    ["favourite football player"]   = "RONALDO",
    ["football player"]             = "RONALDO",
    ["favorite player"]             = "RONALDO",
    ["fav player"]                  = "RONALDO",
    ["ronaldo"]                     = "RONALDO",
    ["favorite food"]               = "PIZZA",
    ["fav food"]                    = "PIZZA",
    ["my food"]                     = "PIZZA",
    ["food"]                        = "PIZZA",
    ["favorite animal"]             = "SPIDER",
    ["fav animal"]                  = "SPIDER",
    ["my animal"]                   = "SPIDER",
    ["my pet"]                      = "SPIDER",
    ["favorite game"]               = "ROBLOX",
    ["fav game"]                    = "ROBLOX",
    ["social media"]                = "YOUTUBE",
    ["youtube channel"]             = "SPYDERSAMMY",
    ["my youtube"]                  = "SPYDERSAMMY",
    ["sammy youtube"]               = "SPYDERSAMMY",

    ["game created on"]             = "FRIDAY",
    ["created on"]                  = "FRIDAY",
    ["what day was the game created"]= "FRIDAY",
    ["what day was sab created"]    = "FRIDAY",
    ["game creation day"]           = "FRIDAY",
    ["release month"]               = "MAY",
    ["release year"]                = "2025",
    ["year sab was created"]        = "2025",
    ["what year was sab created"]   = "2025",
    ["what year was the game created"] = "2025",
    ["year the game was created"]   = "2025",
    ["year sab was made"]           = "2025",
    ["month sab was made"]          = "MAY",
    ["month the game was made"]     = "MAY",
    ["month sab was released"]      = "MAY",
    ["what month was sab made"]     = "MAY",
    ["what month was sab released"] = "MAY",
    ["sab release month"]           = "MAY",
    ["day sab was made"]            = "FRIDAY",
    ["day sab was released"]        = "FRIDAY",
    ["what day was sab made"]       = "FRIDAY",
    ["what day was sab released"]   = "FRIDAY",
    ["sab release day"]             = "FRIDAY",
    ["game made on"]                = "FRIDAY",
    ["sab made on"]                 = "FRIDAY",
    ["year the game was made"]      = "2025",
    ["year made"]                   = "2025",
    ["when was sab made"]           = "MAY162025",
    ["when made"]                   = "MAY162025",
    ["date made"]                   = "MAY162025",
    ["my name twice"]               = "SAMMYSAMMY",
    ["my name 2 times"]             = "SAMMYSAMMY",
    ["my name 3 times"]             = "SAMMYSAMMYSAMMY",
    ["name twice"]                  = "SAMMYSAMMY",
    ["my age twice"]                = "2424",
    ["my age 2 times"]              = "2424",
    ["my age 3 times"]              = "242424",
    ["favorite color twice"]        = "BLUEBLUE",
    ["favorite color 2 times"]      = "BLUEBLUE",
    ["favorite color 3 times"]      = "BLUEBLUEBLUE",
    ["favorite color three times"]  = "BLUEBLUEBLUE",
    ["favorite color 5 times"]      = "BLUEBLUEBLUEBLUEBLUE",
    ["my favorite color twice"]     = "BLUEBLUE",
    ["my favorite color 2 times"]   = "BLUEBLUE",
    ["my favorite color 3 times"]   = "BLUEBLUEBLUE",
    ["favorite sport twice"]        = "FOOTBALLFOOTBALL",
    ["favorite food twice"]         = "PIZZAPIZZA",
    ["owner twice"]                 = "SAMMYSAMMY",
    ["creator twice"]               = "SAMMYSAMMY",

    ["year created"]                = "2025",
    ["what year was sab made"]      = "2025",
    ["year of sab"]                 = "2025",
    ["when was sab created"]        = "MAY162025",
    ["release date"]                = "MAY162025",
    ["when was sab released"]       = "MAY162025",
    ["when was the game released"]  = "MAY162025",
    ["game release date"]           = "MAY162025",
    ["game release"]                = "MAY162025",
    ["sab release"]                 = "MAY162025",
    ["game released"]               = "MAY162025",
    ["sab released"]                = "MAY162025",

    ["first trait"]                 = "LIGHTNING",
    ["1st trait"]                   = "LIGHTNING",
    ["first trait created"]         = "LIGHTNING",
    ["1st trait created"]           = "LIGHTNING",

    ["trait you get when struck by lightning"] = "MATEO",
    ["struck by lightning"]         = "MATEO",
    ["lightning trait"]             = "MATEO",
    ["trait from lightning"]        = "MATEO",
    ["trait when struck by lightning"] = "MATEO",
    ["lightning"]                   = "MATEO",

    ["first mutation"]              = "BLOODROT",
    ["1st mutation"]                = "BLOODROT",
    ["second mutation"]             = "CANDY",
    ["2nd mutation"]                = "CANDY",
    ["third mutation"]              = "LAVA",
    ["3rd mutation"]                = "LAVA",
    ["fourth mutation"]             = "GALAXY",
    ["4th mutation"]                = "GALAXY",
    ["fifth mutation"]              = "YINYANG",
    ["5th mutation"]                = "YINYANG",
    ["sixth mutation"]              = "RADIOACTIVE",
    ["6th mutation"]                = "RADIOACTIVE",
    ["seventh mutation"]            = "CURSED",
    ["7th mutation"]                = "CURSED",
    ["eighth mutation"]             = "DIVINE",
    ["8th mutation"]                = "DIVINE",
    ["ninth mutation"]              = "CYBER",
    ["9th mutation"]                = "CYBER",
    ["tenth mutation"]              = "PHANTOM",
    ["10th mutation"]               = "PHANTOM",
    ["eleventh mutation"]           = "CRYSTAL",
    ["11th mutation"]               = "CRYSTAL",

    ["evil mutation"]               = "CURSED",
    ["evil"]                        = "CURSED",
    ["cursed mutation"]             = "CURSED",
    ["angelic mutation"]            = "DIVINE",
    ["angelic"]                     = "DIVINE",
    ["divine mutation"]             = "DIVINE",
    ["good mutation"]               = "DIVINE",
    ["best mutation"]               = "DIVINE",
    ["top mutation"]                = "DIVINE",
    ["latest mutation"]             = "CRYSTAL",
    ["most recent mutation"]        = "CRYSTAL",
    ["most recent"]                 = "CRYSTAL",
    ["newest mutation"]             = "CRYSTAL",
    ["divinecursed"]                = "DIVINECURSED",
    ["curseddivine"]                = "CURSEDDIVINE",

    ["green mutation"]              = "RADIOACTIVE",
    ["turns green"]                 = "RADIOACTIVE",
    ["green"]                       = "RADIOACTIVE",
    ["purple mutation"]             = "GALAXY",
    ["turns purple"]                = "GALAXY",
    ["purple"]                      = "GALAXY",
    ["black and white mutation"]    = "YINYANG",
    ["black mutation"]              = "YINYANG",
    ["turns black"]                 = "YINYANG",
    ["black and white"]             = "YINYANG",
    ["yellow mutation"]             = "DIVINE",
    ["turns yellow"]                = "DIVINE",
    ["yellow"]                      = "DIVINE",
    ["red mutation"]                = "CURSED",
    ["turns red"]                   = "CURSED",
    ["red"]                         = "CURSED",
    ["orange mutation"]             = "LAVA",
    ["turns orange"]                = "LAVA",
    ["orange"]                      = "LAVA",

    ["first machine"]               = "FIRSTFUSEMACHINE",
    ["1st machine"]                 = "FIRSTFUSEMACHINE",
    ["second machine"]              = "FIRSTCRAFTMACHINE",
    ["2nd machine"]                 = "FIRSTCRAFTMACHINE",
    ["third machine"]               = "WITCHSFUSE",
    ["3rd machine"]                 = "WITCHSFUSE",
    ["fourth machine"]              = "BRAINROTDEALER",
    ["4th machine"]                 = "BRAINROTDEALER",
    ["fifth machine"]               = "BRAINROTTRADER",
    ["5th machine"]                 = "BRAINROTTRADER",
    ["sixth machine"]               = "SANTASFUSE",
    ["6th machine"]                 = "SANTASFUSE",
    ["seventh machine"]             = "DUELSMACHINE",
    ["7th machine"]                 = "DUELSMACHINE",
    ["eighth machine"]              = "CUPIDSMACHINE",
    ["8th machine"]                 = "CUPIDSMACHINE",
    ["ninth machine"]               = "TRADEMACHINE",
    ["9th machine"]                 = "TRADEMACHINE",
    ["tenth machine"]               = "DIVINEFUSE",
    ["10th machine"]                = "DIVINEFUSE",
    ["eleventh machine"]            = "CYBERCRAFT",
    ["11th machine"]                = "CYBERCRAFT",
    ["twelfth machine"]             = "SUMMERFUSE",
    ["12th machine"]                = "SUMMERFUSE",
    ["thirteenth machine"]          = "LOSTRADERS",
    ["13th machine"]                = "LOSTRADERS",

    ["og brainrot cannot be obtained"] = "HEADLESSHORSEMAN",
    ["headless horseman"]           = "HEADLESSHORSEMAN",
    ["strongest brainrot"]          = "SPYDERELEPHANT",
    ["first og"]                    = "STRAWBERRY",
    ["1st og"]                      = "STRAWBERRY",
    ["second og"]                   = "MEOWL",
    ["2nd og"]                      = "MEOWL",
    ["third og"]                    = "SKIBIDI",
    ["3rd og"]                      = "SKIBIDI",
    ["fourth og"]                   = "JOHNPORK",
    ["4th og"]                      = "JOHNPORK",
    ["newest og"]                   = "JOHNPORK",
    ["latest og"]                   = "JOHNPORK",

    ["first event"]                 = "BLOODMOON",
    ["1st event"]                   = "BLOODMOON",
    ["newest event"]                = "BEE",
    ["latest event"]                = "BEE",
    ["current event"]               = "BEE",
    ["anpali_babel_obteined"] = "THIS WAS OBTAINED FROM THE CRAFT MACHINE",
["astrolero_cervalero_obteined"] = "DIVINE FUSE",
["ballerina_peppermintina_obteined"] = "ADVENT/WINTER HOUR",
["bambu_bambu_sahur_obteined"] = "INDONESIA EVENT",
["belula_beluga_obteined"] = "BRAINROT TRADER",
["boba_panda_obteined"] = "OG FUSE",
["bombardini_tortinii_obteined"] = "TACO EVENT",
["brasilini_berimbini_obteined"] = "ADMIN ABUSE",
["brr_es_teh_patipum_obteined"] = "FIRST FUSE MACHINE",
["buho_de_noelo_obteined"] = "SANTA'S FUSE",
["capi_taco_obteined"] = "TACO EVENT",
["cocoa_assassino_obteined"] = "CHRISTMAS EVENT",
["cola_cat_obteined"] = "DLC CODE",
["corn_corn_corn_sahur_obteined"] = "THE PIÑATA",
["divino_platypio_obteined"] = "DIVINE FUSE",
["dolphini_jetskini_obteined"] = "OG FUSE",
["dumborino_miracello_obteined"] = "DIVINE FUSE",
["espresso_signora_obteined"] = "ADMIN ABUSE",
["extinct_ballerina_obteined"] = "EXTINCT EVENT",
["flippo_marino_obteined"] = "SUMMER FUSE",
["frio_ninja_obteined"] = "WITCH'S FUSE",
["gattatino_nyanino_obteined"] = "ADMIN ABUSE",
["ginger_cisterna_obteined"] = "SANTA'S FUSE",
["ginger_globo_obteined"] = "SANTA'S FUSE",
["granchiello_spiritell_obteined"] = "FISHING EVENT",
["jacko_jack_jack_obteined"] = "WITCH'S FUSE",
["krupuk_pagi_pagi_obteined"] = "INDONESIA EVENT",
["las_capuchinas_obteined"] = "FIRST CRAFT MACHINE",
["lazy_ducky_obteined"] = "DLC CODE",
["lemonita_splashita_obteined"] = "SUMMER FUSE",
["los_crocodillitos_obteined"] = "BOMBARDIRO EVENT",
["los_orcalitos_obteined"] = "FIRST FUSE MACHINE",
["los_tungtungtungcitos_obteined"] = "FIRST FUSE MACHINE",
["lumaca_malefica_obteined"] = "BACKROOMS",
["matteo_obteined"] = "ADMIN ABUSE",
["money_money_man_obteined"] = "BRAINROT TRADER",
["noo_la_polizia_obteined"] = "BRAINROT TRADER",
["orcalita_orcala_obteined"] = "CYBER CRAFT",
["pakrahmatmatina_obteined"] = "POLE GAME",
["piccionetta_macchina_obteined"] = "FIRST CRAFT MACHINE",
["pineaplino_obteined"] = "DLC CODE",
["pretzo_robo_obteined"] = "CYBER CRAFT",
["robo_grafito_obteined"] = "BACKROOMS",
["skull_skull_skull_obteined"] = "HALLOWEEN EVENT",
["snailenzo_obteined"] = "WITCH'S FUSE",
["squalanana_obteined"] = "CYBER CRAFT",
["sundrilla_sundae_obteined"] = "SUMMER FUSE",
["tartaruga_cisterna_obteined"] = "THIS IS OBTAINED FROM SAMMY'S BASE",
["tenini_ballini_obteined"] = "DLC CODE",
["tentacolo_tecnico_obteined"] = "WITCH'S FUSE",
["tipi_topi_taco_obteined"] = "TACO EVENT",
["tootini_shrimpini_obteined"] = "NEW YEAR'S EVENT",
["trenotubo_axolotrico_9000_obteined"] = "CYBER CRAFT",
["tukanno_bananno_obteined"] = "FIRST FUSE MACHINE",
["unclito_samito_obteined"] = "ADMIN ABUSE",
["urubini_flamenguini_obteined"] = "ADMIN ABUSE",
["vampira_cappucina_obteined"] = "HALLOWEEN EVENT",
["holy_arepa_obteined"] = "DIVINE FUSE",
["noobini_santanini_obteined"] = "SANTA'S FUSE",
["pipi_corni_obteined"] = "SUMMER FUSE",
["raccooni_jandelini_obteined"] = "ADMIN ABUSE WAR",
["tartaragno_obteined"] = "WITCH'S FUSE",
["doi_doi_do_obteined"] = "BRAINROT TRADER",
["frogato_pirato_obteined"] = "WITCH'S FUSE",
["gato_celesto_obteined"] = "DIVINE FUSE",
["malame_amarele_obteined"] = "FIRST CRAFT MACHINE",
["mangolini_parrocini_obteined"] = "BRAINROT TRADER",
["mummio_rappitto_obteined"] = "WITCH'S FUSE",
["penguin_tree_obteined"] = "SANTA'S FUSE",
["penguino_cocosino_obteined"] = "SUMMER FUSE",
["ti_ti_ti_sahur_obteined"] = "SUMMER FUSE",
["bandito_axolito_obteined"] = "CYBER CRAFT",
["buho_de_fuego_obteined"] = "WITCH'S FUSE",
["buho_del_cielo_obteined"] = "DIVINE FUSE",
["caramello_filtrello_obteined"] = "FIRST CRAFT MACHINE",
["chocco_bunny_obteined"] = "SANTA'S FUSE",
["clickerino_crabo_obteined"] = "BRAINROT TRADER",
["cocosini_mama_obteined"] = "FIRST FUSE MACHINE",
["electro_quacko_obteined"] = "CYBER CRAFT",
["pi_pi_watermelon_obteined"] = "SUMMER FUSE",
["puffaball_obteined"] = "FISHING EVENT",
["quackula_obteined"] = "WITCH'S FUSE",
["sealo_regalo_obteined"] = "SANTA'S FUSE",
["seraphino_gruyero_obteined"] = "DIVINE FUSE",
["sigma_girl_obteined"] = "FIRST CRAFT MACHINE",
["bee_loco_obteined"] = "CYBER CRAFT",
["berenjello_angello_obteined"] = "DIVINE FUSE",
["brutto_gialutto_obteined"] = "FIRST CRAFT MACHINE",
["bucketoro_obteined"] = "SUMMER FUSE",
["centrucci_nuclucci_obteined"] = "BRAINROT TRADER",
["cocoteddy_obteined"] = "SUMMER FUSE",
["fizzy_soda_obteined"] = "OG FUSE",
["ganganzelli_trulala_obteined"] = "FIRST FUSE MACHINE",
["gorillo_subwoofero_obteined"] = "FIRST CRAFT MACHINE",
["harpuccino_obteined"] = "DIVINE FUSE",
["jacko_spaventosa_obteined"] = "WITCH'S FUSE",
["jingle_jingle_sahur_obteined"] = "SANTA'S FUSE",
["los_noobinis_obteined"] = "CYBER CRAFT",
["magi_ribbitini_obteined"] = "WITCH'S FUSE",
["orbi_mochi_obteined"] = "CYBER CRAFT",
["rhino_helicopterino_obteined"] = "FIRST CRAFT MACHINE",
["spongini_quackini_obteined"] = "OG FUSE",
["stoppo_luminino_obteined"] = "BRAINROT TRADER",
["tob_tobi_tobi_obteined"] = "FIRST FUSE MACHINE",
["tree_tree_tree_sahur_obteined"] = "SANTA'S FUSE",
["cupcake_koala_obteined"] = "BRAINROT TRADER",
["frogo_elfo_obteined"] = "SANTA'S FUSE",
["pengolino_nuvoletto_obteined"] = "DIVINE FUSE",
["pinealotto_fruttarino_obteined"] = "WITCH'S FUSE",
["pipi_avocado_obteined"] = "SUMMER FUSE",
["25_obteined"] = "ADVENT CALENDAR",
["4th_bros_obteined"] = "ADMIN ABUSE",
["abyssaloco_obteined"] = "BACKROOMS",
["agarrini_la_palini_obteined"] = "FIRST FUSE MACHINE",
["antonio_obteined"] = "FIRST CRAFT MACHINE",
["aquarino_obteined"] = "SUMMER HOUR",
["arcadopus_obteined"] = "TSUNAMI LTM",
["arcadragon_obteined"] = "DLC CODE",
["bacuru_and_egguru_obteined"] = "OG FUSE",
["bisonte_giuppitere_obteined"] = "THIS IS OBTAINED FROM SAMMY'S BASE",
["boatito_auratito_obteined"] = "ADMIN ABUSE",
["bombardiro_vaccariro_obteined"] = "SUMMER FUSE",
["boppin_bunny_obteined"] = "DLC CODE",
["brunito_marsito_obteined"] = "THIS WAS SPAWNED DURING BRUNO'S CONCERT EVENT",
["bufalino_boomberino_obteined"] = "LIMITED QUANTITY CRAFT",
["buho_de_volto_obteined"] = "CYBER CRAFT",
["bunito_bunito_spinito_obteined"] = "NEW YEAR'S EVENT",
["bunny_bunny_bunny_sahur_obteined"] = "EASTER EVENT",
["bunny_and_eggy_obteined"] = "DIVINE FUSE",
["bunnyman_obteined"] = "ADVENT CALENDAR",
["buntteo_obteined"] = "EASTER EVENT",
["camera_ramena_obteined"] = "CYBER CRAFT",
["capitano_americano_obteined"] = "LIMITED QUANTITY CRAFT",
["capitano_gullini_obteined"] = "SUMMER FUSE",
["caylusaurus_obteined"] = "LIMITED QUANTITY CRAFT",
["celularcini_viciosini_obteined"] = "FIRST CRAFT MACHINE",
["chachechi_obteined"] = "ADMIN ABUSE",
["chicleteira_champeona_obteined"] = "SPAIN EVENT",
["chicleteira_noelteira_obteined"] = "SANTA'S FUSE",
["chicleteira_surfeiteira_obteined"] = "SUMMER HOUR",
["chill_puppy_obteined"] = "OG FUSE",
["chillin_chili_obteined"] = "LIMITED QUANTITY CRAFT",
["chipso_and_queso_obteined"] = "LIMITED QUANTITY CRAFT",
["cigno_fulgoro_obteined"] = "DIVINE FUSE",
["cloverat_clapat_obteined"] = "ST PATRICKS EVENT",
["coco_and_mango_obteined"] = "SUMMER FUSE",
["cooki_and_milki_obteined"] = "SANTA'S FUSE",
["cuadramat_and_pakrahmatmamat_obteined"] = "BRAINROT TRADER",
["cupid_cupid_sahur_obteined"] = "CUPID'S MACHINE",
["digi_narwhal_obteined"] = "CYBER CRAFT",
["donkeyturbo_express_obteined"] = "CHRISTMAS EVENT",
["dragon_aquanini_obteined"] = "SUMMER FUSE",
["dragon_gingerini_obteined"] = "SANTA'S FUSE",
["dug_dug_dug_obteined"] = "FIRST CRAFT MACHINE",
["duggy_bros_obteined"] = "CYBER CRAFT",
["dul_dul_dul_obteined"] = "ADMIN ABUSE",
["eid_eid_eid_sahur_obteined"] = "EID EVENT",
["elefanto_frigo_obteined"] = "FIRST CRAFT MACHINE",
["esok_goala_obteined"] = "SOCCER BOARD",
["eviledon_obteined"] = "WITCH'S FUSE",
["examen_bros_obteined"] = "LOS TRADERS",
["extinct_matteo_obteined"] = "EXTINCT EVENT",
["extinct_tralalero_obteined"] = "EXTINCT EVENT",
["festive_67_obteined"] = "DLC CODE",
["fishino_clownino_obteined"] = "FISHING EVENT",
["flancito_obteined"] = "SAB'S ANNIVERSARY EVENT",
["flipa_sandala_obteined"] = "BACKROOMS",
["foxini_lanternini_obteined"] = "EID EVENT",
["fragola_la_la_la_obteined"] = "FIRST CRAFT MACHINE",
["fragrama_and_chocrama_obteined"] = "BRAINROT TRADER",
["frankentteo_obteined"] = "HALLOWEEN EVENT",
["frullato_framingo_obteined"] = "SAMMY'S CODE",
["futbolini_skatini_obteined"] = "CYBER CRAFT",
["goat_obteined"] = "ADMIN ABUSE",
["gelato_lumacho_obteined"] = "SUMMER HOUR",
["giftini_spyderini_obteined"] = "THIS WAS OBTAINED FROM THE NORTH POLE",
["ginger_gerat_obteined"] = "SANTA'S MARKET",
["glaciator_obteined"] = "BACKROOMS",
["globa_steppa_obteined"] = "DLC CODE",
["gobblino_uniciclino_obteined"] = "THANKSGIVING EVENT",
["grabatron_obteined"] = "DLC CODES",
["granny_obteined"] = "GRANNY'S FUNERAL EVENT",
["griffin_obteined"] = "DIVINE FUSE",
["guest_666_obteined"] = "CAVE RITUAL",
["gym_bros_obteined"] = "CYBER CRAFT",
["hippo_golazo_obteined"] = "SOCCER BOARD",
["ho_ho_ho_sahur_obteined"] = "SANTA'S FUSE",
["horegini_boom_obteined"] = "AURA BOAT",
["hydra_dragon_cannelloni_obteined"] = "OG FUSE",
["jelly_moby_obteined"] = "SAB'S ANNIVERSARY EVENT",
["john_doe_obteined"] = "CAVE RITUAL",
["jolly_jolly_sahur_obteined"] = "SANTA'S MARKET",
["kalika_bros_obteined"] = "CYBER CRAFT",
["karker_sahur_obteined"] = "FIRST CRAFT MACHINE",
["karkerkar_kurkur_obteined"] = "ADMIN ABUSE",
["ketupat_bros_obteined"] = "OG FUSE",
["la_anniversary_grande_obteined"] = "LIMITED QUANTITY CRAFT",
["la_cucaracha_obteined"] = "ADMIN ABUSE",
["la_easter_grande_obteined"] = "LIMITED QUANTITY CRAFT",
["la_extinct_grande_obteined"] = "EXTINCT EVENT",
["la_jolly_grande_obteined"] = "CHRISTMAS WHEEL SPIN",
["la_karkerkar_combinasion_obteined"] = "FIRST CRAFT MACHINE",
["la_lucky_grande_obteined"] = "LIMITED QUANTITY CRAFT",
["la_romantic_grande_obteined"] = "LIMITED QUANTITY CRAFT",
["la_sahur_combinasion_obteined"] = "FIRST CRAFT MACHINE",
["la_spooky_grande_obteined"] = "LIMITED QUANTITY CRAFT",
["la_summer_grande_obteined"] = "LIMITED QUANTITY CRAFT",
["la_supreme_combinasion_obteined"] = "FIRST FUSE MACHINE",
["la_taco_combinasion_obteined"] = "LIMITED QUANTITY CRAFT",
["la_vacca_jacko_linterino_obteined"] = "HALLOWEEN EVENT",
["la_vacca_prese_presente_obteined"] = "SANTA'S FUSE",
["las_sis_obteined"] = "FIRST CRAFT MACHINE",
["las_vaquitas_saturnitas_obteined"] = "LA VACCA RITUAL",
["list_list_list_sahur_obteined"] = "CHRISTMAS EVENT",
["los_admins_obteined"] = "LOS TRADERS",
["los_bros_obteined"] = "FIRST CRAFT MACHINE",
["los_candies_obteined"] = "SANTA'S FUSE",
["los_chicleteiras_obteined"] = "CHICLETEIRA RITUAL",
["los_chillis_obteined"] = "CYBER CRAFT",
["los_combinasionas_obteined"] = "FIRST FUSE MACHINE",
["los_cornis_obteined"] = "LOS TRADERS",
["los_cupids_obteined"] = "DIVINE FUSE",
["los_fruits_obteined"] = "SUMMER FUSE",
["los_hackers_obteined"] = "CYBER CRAFT",
["los_hotspotsitos_obteined"] = "FIRST FUSE MACHINE",
["los_jolly_combinasionas_obteined"] = "SANTA'S MARKET",
["los_karkeritos_obteined"] = "KARKER RITUAL",
["los_mariachis_obteined"] = "THE PIÑATA",
["los_matteos_obteined"] = "MATTEO RITUAL",
["los_mi_gatitos_obteined"] = "MI GATITO RITUAL",
["los_mobilis_obteined"] = "WITCH'S FUSE",
["los_planitos_obteined"] = "BRAINROT TRADER",
["los_primos_obteined"] = "FIRST CRAFT MACHINE",
["los_puggies_obteined"] = "BRAINROT TRADER",
["los_secret_combinasionas_obteined"] = "LOS TRADERS",
["los_sigmas_obteined"] = "LOS TRADERS",
["los_spaghettis_obteined"] = "BRAINROT TRADER",
["los_spyderinis_obteined"] = "SPYDERINI RITUAL",
["los_sweethearts_obteined"] = "FIRST FUSE MACHINE",
["los_tacoritas_obteined"] = "FIRST CRAFT MACHINE",
["los_tangcitos_obteined"] = "LOS TRADERS",
["los_tictacs_obteined"] = "LOS TRADERS",
["los_trios_obteined"] = "OG FUSE",
["love_love_bear_obteined"] = "CUPID'S MACHINE",
["lovin_rose_obteined"] = "CUPID'S MACHINE",
["mariachi_corazoni_obteined"] = "THE PIÑATA",
["mi_gatito_obteined"] = "ADMIN ABUSE",
["mieteteira_bicicleteira_obteined"] = "WITCH'S FUSE",
["moby_bros_obteined"] = "LOS TRADERS",
["money_money_bros_obteined"] = "CYBER CRAFT",
["money_money_reindeer_obteined"] = "SANTA'S MARKET",
["nacho_spyder_obteined"] = "LIMITED QUANTITY CRAFT",
["naughty_naughty_obteined"] = "CHRISTMAS EVENT",
["noo_my_candy_obteined"] = "TRICK OR TREAT",
["noo_my_eggs_obteined"] = "EASTER EVENT",
["noo_my_examen_obteined"] = "DUL DUL RITUAL",
["noo_my_present_obteined"] = "CHRISTMAS EVENT",
["noo_my_resume_obteined"] = "JOB RITUAL",
["nooo_my_hotspot_obteined"] = "TACO EVENT",
["ombrello_topolino_obteined"] = "SUMMER FUSE",
["orcaledon_obteined"] = "BRAINROT TRADER",
["pancake_and_syrup_obteined"] = "DLC CODE",
["paradiso_axolottino_obteined"] = "DIVINE FUSE",
["perrito_burrito_obteined"] = "LIMITED QUANTITY CRAFT",
["pirulitoita_bicicleteira_obteined"] = "BRAINROT TRADER",
["please_my_present_obteined"] = "ADVENT CALENDAR",
["popcuru_and_fizzuru_obteined"] = "OG FUSE",
["pot_pumpkin_obteined"] = "HALLOWEEN EVENT",
["quackini_snackini_obteined"] = "EGG TOWN EVENT",
["quesadillo_vampiro_obteined"] = "LIMITED QUANTITY CRAFT",
["rang_ring_bus_obteined"] = "POLE GAME",
["ref_ref_ref_sahur_obteined"] = "SOCCER BOARD",
["reindeer_tralala_obteined"] = "CHRISTMAS EVENT",
["rico_dinero_obteined"] = "DLC CODE",
["rocco_disco_obteined"] = "NEW YEAR'S EVENT",
["rocketini_frostini_obteined"] = "SAMMY'S CODE",
["rubiko_and_kubiko_obteined"] = "LOS TRADERS",
["rubrikiko_obteined"] = "BACKROOMS",
["sammyni_cakini_obteined"] = "SAB'S ANNIVERSARY EVENT",
["sammyni_spyderini_obteined"] = "ADMIN ABUSE",
["santteo_obteined"] = "CHRISTMAS EVENT",
["serafinna_medusella_obteined"] = "DIVINE FUSE",
["signore_carapace_obteined"] = "FIRST CRAFT MACHINE",
["spinny_hammy_obteined"] = "OG FUSE",
["spooky_and_pumpky_obteined"] = "WITCH'S FUSE",
["steakini_fattini_obteined"] = "LIMITED QUANTITY CRAFT",
["swag_soda_obteined"] = "BRAINROT TRADER",
["swaggy_bros_obteined"] = "LIMITED QUANTITY CRAFT",
["tacorillo_crocodillo_obteined"] = "LIMITED QUANTITY CRAFT",
["tacorita_bicicleta_obteined"] = "TACO EVENT",
["tirilikalika_tirilikalako_obteined"] = "FIRST CRAFT MACHINE",
["toro_españolo_obteined"] = "SPAIN EVENT",
["tralaledon_obteined"] = "FIRST CRAFT MACHINE",
["trenostruzzo_turbo_4000_obteined"] = "FIRST CRAFT MACHINE",
["tuff_toucan_obteined"] = "NEW YEAR'S EVENT",
["var_var_var_obteined"] = "SOCCER BOARD",
["venuspino_obteined"] = "SUMMER FUSE",
["vulturino_skeletono_obteined"] = "WITCH'S FUSE",
["w_or_l_obteined"] = "LIMITED QUANTITY CRAFT",
["yess_my_examen_obteined"] = "DUL DUL RITUAL",
["yess_my_resume_obteined"] = "JOB RITUAL",
["zombie_tralala_obteined"] = "HALLOWEEN EVENT",

    ["my name"] = "SAMMY",
    ["sammy name"] = "SAMMY",
    ["sammys name"] = "SAMMY",
    ["game owner"] = "SAMMY",
    ["developer"] = "SAMMY",
    ["dev"] = "SAMMY",
    ["made by"] = "SAMMY",
    ["created by"] = "SAMMY",
    ["made this game"] = "SAMMY",
    ["real name of sammy"] = "SAMMY",
    ["roblox"] = "SPYDERSAMMY",
    ["channel"] = "SPYDERSAMMY",
    ["handle"] = "SPYDERSAMMY",
    ["location"] = "BRAZIL",
    ["from"] = "BRAZIL",
    ["birth country"] = "BRAZIL",
    ["born in"] = "BRAZIL",
    ["lives in"] = "BRAZIL",
    ["comes from"] = "BRAZIL",
    ["football"] = "FOOTBALL",
    ["player"] = "RONALDO",
    ["favorite meal"] = "PIZZA",
    ["favorite dish"] = "PIZZA",
    ["pet name"] = "SPIDER",
    ["sammy pet name"] = "SPIDER",
    ["pet"] = "SPIDER",
    ["animal"] = "SPIDER",
    ["game"] = "ROBLOX",
    ["lucky number"] = "SEVEN",
    ["number"] = "SEVEN",
    ["youtube"] = "SPYDERSAMMY",
    ["discord"] = "ACE",
    ["discord server"] = "ACE",
    ["sammy discord"] = "SPYDERSAMMY",
    ["twitter"] = "SPYDERSAMMY",
    ["sammy twitter"] = "SPYDERSAMMY",
    ["x account"] = "SPYDERSAMMY",
    ["tiktok"] = "SPYDERSAMMY",
    ["sammy tiktok"] = "SPYDERSAMMY",
    ["instagram"] = "SPYDERSAMMY",
    ["day game released"] = "FRIDAY",
    ["day sab released"] = "FRIDAY",
    ["release day"] = "FRIDAY",
    ["day released"] = "FRIDAY",
    ["what day was it released"] = "FRIDAY",
    ["what day was it created"] = "FRIDAY",
    ["sab creation year"] = "2025",
    ["creation year"] = "2025",
    ["when created"] = "MAY162025",
    ["when released"] = "MAY162025",
    ["date released"] = "MAY162025",
    ["date created"] = "MAY162025",
    ["first trait added"] = "LIGHTNING",
    ["trait added first"] = "LIGHTNING",
    ["trait first added"] = "LIGHTNING",
    ["what trait"] = "LIGHTNING",
    ["trait"] = "LIGHTNING",
    ["lightning strike trait"] = "MATEO",
    ["get struck by lightning"] = "MATEO",
    ["lightning gives"] = "MATEO",
    ["struck by lightning trait"] = "MATEO",
    ["mateo"] = "MATEO",
    ["twelfth mutation"] = "CYBER",
    ["12th mutation"] = "CYBER",
    ["thirteenth mutation"] = "PHANTOM",
    ["13th mutation"] = "PHANTOM",
    ["fourteenth mutation"] = "CRYSTAL",
    ["14th mutation"] = "CRYSTAL",
    ["mutation 1"] = "GOLD",
    ["mutation number 1"] = "GOLD",
    ["mutation 2"] = "DIAMOND",
    ["mutation number 2"] = "DIAMOND",
    ["mutation 3"] = "BLOODROT",
    ["mutation number 3"] = "BLOODROT",
    ["mutation 4"] = "RAINBOW",
    ["mutation number 4"] = "RAINBOW",
    ["mutation 5"] = "CANDY",
    ["mutation number 5"] = "CANDY",
    ["mutation 6"] = "LAVA",
    ["mutation number 6"] = "LAVA",
    ["mutation 7"] = "GALAXY",
    ["mutation number 7"] = "GALAXY",
    ["mutation 8"] = "YINYANG",
    ["mutation number 8"] = "YINYANG",
    ["mutation 9"] = "RADIOACTIVE",
    ["mutation number 9"] = "RADIOACTIVE",
    ["mutation 10"] = "CURSED",
    ["mutation number 10"] = "CURSED",
    ["mutation 11"] = "DIVINE",
    ["mutation number 11"] = "DIVINE",
    ["mutation 12"] = "CYBER",
    ["mutation number 12"] = "CYBER",
    ["mutation 13"] = "PHANTOM",
    ["mutation number 13"] = "PHANTOM",
    ["mutation 14"] = "CRYSTAL",
    ["mutation number 14"] = "CRYSTAL",
    ["last mutation"] = "CRYSTAL",
    ["blue mutation"] = "DIAMOND",
    ["pink mutation"] = "CANDY",
    ["gold"] = "GOLD",
    ["diamond"] = "DIAMOND",
    ["bloodrot"] = "BLOODROT",
    ["rainbow"] = "RAINBOW",
    ["candy"] = "CANDY",
    ["lava"] = "LAVA",
    ["galaxy"] = "GALAXY",
    ["yinyang"] = "YINYANG",
    ["radioactive"] = "RADIOACTIVE",
    ["cursed"] = "CURSED",
    ["divine"] = "DIVINE",
    ["cyber"] = "CYBER",
    ["phantom"] = "PHANTOM",
    ["crystal"] = "CRYSTAL",
    ["color of gold mutation"] = "YELLOW",
    ["color of diamond mutation"] = "BLUE",
    ["color of bloodrot mutation"] = "RED",
    ["color of rainbow mutation"] = "RAINBOW",
    ["color of candy mutation"] = "PINK",
    ["color of lava mutation"] = "ORANGE",
    ["color of galaxy mutation"] = "PURPLE",
    ["color of yinyang mutation"] = "BLACK",
    ["color of radioactive mutation"] = "GREEN",
    ["color of cursed mutation"] = "RED",
    ["color of divine mutation"] = "YELLOW",
    ["color of cyber mutation"] = "BLUE",
    ["color of phantom mutation"] = "BLACK",
    ["color of crystal mutation"] = "BLUEPURPLE",
    ["divine color"] = "YELLOW",
    ["cursed color"] = "RED",
    ["radioactive color"] = "GREEN",
    ["galaxy color"] = "PURPLE",
    ["yinyang color"] = "BLACK",
    ["lava color"] = "ORANGE",
    ["what number is gold"] = "1",
    ["what number is diamond"] = "2",
    ["what number is bloodrot"] = "3",
    ["what number is rainbow"] = "4",
    ["what number is candy"] = "5",
    ["what number is lava"] = "6",
    ["what number is galaxy"] = "7",
    ["what number is yinyang"] = "8",
    ["what number is radioactive"] = "9",
    ["what number is cursed"] = "10",
    ["what number is divine"] = "11",
    ["what number is cyber"] = "12",
    ["what number is phantom"] = "13",
    ["what number is crystal"] = "14",
    ["fourteenth machine"] = "DIVINEFUSE",
    ["14th machine"] = "DIVINEFUSE",
    ["fifteenth machine"] = "EGGINCUBATOR",
    ["15th machine"] = "EGGINCUBATOR",
    ["sixteenth machine"] = "CYBERCRAFTMACHINE",
    ["16th machine"] = "CYBERCRAFTMACHINE",
    ["seventeenth machine"] = "SUMMERFUSE",
    ["17th machine"] = "SUMMERFUSE",
    ["eighteenth machine"] = "LOSTRADERS",
    ["18th machine"] = "LOSTRADERS",
    ["machine 1"] = "RAINBOWMACHINE",
    ["machine number 1"] = "RAINBOWMACHINE",
    ["machine 2"] = "BUBBLEGUMMACHINE",
    ["machine number 2"] = "BUBBLEGUMMACHINE",
    ["machine 3"] = "FUSEMACHINE",
    ["machine number 3"] = "FUSEMACHINE",
    ["machine 4"] = "CRAFTMACHINE",
    ["machine number 4"] = "CRAFTMACHINE",
    ["machine 5"] = "WITCHFUSE",
    ["machine number 5"] = "WITCHFUSE",
    ["machine 6"] = "BRAINROTDEALER",
    ["machine number 6"] = "BRAINROTDEALER",
    ["machine 7"] = "BRAINROTTRADER",
    ["machine number 7"] = "BRAINROTTRADER",
    ["machine 8"] = "SANTASFUSE",
    ["machine number 8"] = "SANTASFUSE",
    ["machine 9"] = "SANTASSHOP",
    ["machine number 9"] = "SANTASSHOP",
    ["machine 10"] = "NEWYEARSMACHINE",
    ["machine number 10"] = "NEWYEARSMACHINE",
    ["machine 11"] = "DUELSMACHINE",
    ["machine number 11"] = "DUELSMACHINE",
    ["machine 12"] = "CUPIDSMACHINE",
    ["machine number 12"] = "CUPIDSMACHINE",
    ["machine 13"] = "TRADEMACHINE",
    ["machine number 13"] = "TRADEMACHINE",
    ["machine 14"] = "DIVINEFUSE",
    ["machine number 14"] = "DIVINEFUSE",
    ["machine 15"] = "EGGINCUBATOR",
    ["machine number 15"] = "EGGINCUBATOR",
    ["machine 16"] = "CYBERCRAFTMACHINE",
    ["machine number 16"] = "CYBERCRAFTMACHINE",
    ["machine 17"] = "SUMMERFUSE",
    ["machine number 17"] = "SUMMERFUSE",
    ["machine 18"] = "LOSTRADERS",
    ["machine number 18"] = "LOSTRADERS",
    ["rainbowmachine"] = "RAINBOWMACHINE",
    ["bubblegummachine"] = "BUBBLEGUMMACHINE",
    ["fusemachine"] = "FUSEMACHINE",
    ["craftmachine"] = "CRAFTMACHINE",
    ["witchfuse"] = "WITCHFUSE",
    ["brainrotdealer"] = "BRAINROTDEALER",
    ["brainrottrader"] = "BRAINROTTRADER",
    ["santasfuse"] = "SANTASFUSE",
    ["santasshop"] = "SANTASSHOP",
    ["newyearsmachine"] = "NEWYEARSMACHINE",
    ["duelsmachine"] = "DUELSMACHINE",
    ["cupidsmachine"] = "CUPIDSMACHINE",
    ["trademachine"] = "TRADEMACHINE",
    ["divinefuse"] = "DIVINEFUSE",
    ["eggincubator"] = "EGGINCUBATOR",
    ["cybercraftmachine"] = "CYBERCRAFTMACHINE",
    ["summerfuse"] = "SUMMERFUSE",
    ["lostraders"] = "LOSTRADERS",
    ["newest machine"] = "LOSTRADERS",
    ["last machine"] = "LOSTRADERS",
    ["latest machine"] = "LOSTRADERS",
    ["rarest brainrot"] = "HEADLESSHORSEMAN",
    ["rarest"] = "HEADLESSHORSEMAN",
    ["unobtainable brainrot"] = "HEADLESSHORSEMAN",
    ["unobtainable"] = "HEADLESSHORSEMAN",
    ["best brainrot"] = "STRAWBERRYELEPHANT",
    ["first og added"] = "STRAWBERRYELEPHANT",
    ["second og added"] = "MEOWL",
    ["third og added"] = "SKIBIDITOILET",
    ["fifth og added"] = "JOHNPORK",
    ["5th og"] = "JOHNPORK",
    ["og 1"] = "STRAWBERRYELEPHANT",
    ["og number 1"] = "STRAWBERRYELEPHANT",
    ["og 2"] = "MEOWL",
    ["og number 2"] = "MEOWL",
    ["og 3"] = "SKIBIDITOILET",
    ["og number 3"] = "SKIBIDITOILET",
    ["og 5"] = "JOHNPORK",
    ["og number 5"] = "JOHNPORK",
    ["first brainrot added"] = "STRAWBERRYELEPHANT",
    ["1st brainrot"] = "STRAWBERRYELEPHANT",
    ["oldest brainrot"] = "STRAWBERRYELEPHANT",
    ["worst brainrot"] = "NOOBINIPIZZANINI",
    ["most common brainrot"] = "NOOBINIPIZZANINI",
    ["least rare brainrot"] = "NOOBINIPIZZANINI",
    ["weakest brainrot"] = "NOOBINIPIZZANINI",
    ["common brainrot"] = "NOOBINIPIZZANINI",
    ["most popular brainrot"] = "DRAGONCANNELONNI",
    ["highest rarity"] = "OG",
    ["rarest rarity"] = "OG",
    ["top rarity"] = "OG",
    ["best rarity"] = "OG",
    ["6th rarity"] = "OG",
    ["sixth rarity"] = "OG",
    ["lowest rarity"] = "COMMON",
    ["worst rarity"] = "COMMON",
    ["common rarity"] = "COMMON",
    ["1st rarity"] = "COMMON",
    ["second rarity"] = "UNCOMMON",
    ["2nd rarity"] = "UNCOMMON",
    ["third rarity"] = "RARE",
    ["3rd rarity"] = "RARE",
    ["fourth rarity"] = "EPIC",
    ["4th rarity"] = "EPIC",
    ["fifth rarity"] = "LEGENDARY",
    ["5th rarity"] = "LEGENDARY",
    ["uncommon"] = "UNCOMMON",
    ["rare"] = "RARE",
    ["epic"] = "EPIC",
    ["legendary"] = "LEGENDARY",
    ["og"] = "OG",
    ["common"] = "COMMON",
    ["fire represents"] = "DRAGON",
    ["fire stands for"] = "DRAGON",
    ["fire symbol"] = "DRAGON",
    ["fire meaning"] = "DRAGON",
    ["fire brainrot"] = "DRAGON",
    ["fire"] = "DRAGON",
    ["dragon"] = "DRAGON",
    ["won the world cup"] = "SPAIN",
    ["world cup"] = "SPAIN",
    ["won world cup"] = "SPAIN",
    ["football world cup"] = "SPAIN",
    ["worst game owner"] = "SECRETLOKII",
    ["most boring game owner"] = "SECRETLOKII",
    ["worst owner"] = "SECRETLOKII",
    ["boring owner"] = "SECRETLOKII",
    ["most boring owner"] = "SECRETLOKII",
    ["most boring game on roblox"] = "KEYBOARDESCAPE",
    ["boring game"] = "KEYBOARDESCAPE",
    ["most boring game"] = "KEYBOARDESCAPE",
    ["boring roblox game"] = "KEYBOARDESCAPE",
    ["spawned during admin abuse war"] = "RACOONINIJANDELINI",
    ["admin war brainrot"] = "RACOONINIJANDELINI",
    ["spawned in admin war"] = "RACOONINIJANDELINI",
    ["who did i fight in the admin abuse war"] = "JANDEL",
    ["fought in admin abuse war"] = "JANDEL",
    ["who did sammy fight"] = "JANDEL",
    ["sammy fought"] = "JANDEL",
    ["fight in admin war"] = "JANDEL",
    ["won the admin abuse war"] = "GROWAGARDEN",
    ["admin abuse war"] = "GROWAGARDEN",
    ["who won admin war"] = "GROWAGARDEN",
    ["admin war winner"] = "GROWAGARDEN",
    ["admin war"] = "GROWAGARDEN",
    ["worst secret"] = "KARKERKARKURKUR",
    ["secret"] = "KARKERKARKURKUR",
    ["bad secret"] = "KARKERKARKURKUR",
    ["maximum server size"] = "EIGHT",
    ["max server size"] = "EIGHT",
    ["server size"] = "EIGHT",
    ["how many players"] = "EIGHT",
    ["max players"] = "EIGHT",
    ["players"] = "EIGHT",
    ["player count"] = "EIGHT",
    ["server"] = "EIGHT",
    ["how many players in server"] = "EIGHT",
    ["server capacity"] = "EIGHT",
    ["players per server"] = "EIGHT",
    ["max server"] = "EIGHT",
    ["brother of hydra bunny"] = "CERBERUS",
    ["hydra bunny brother"] = "CERBERUS",
    ["hydra bunny"] = "CERBERUS",
    ["cerberus brother"] = "CERBERUS",
    ["brother of hydra"] = "CERBERUS",
    ["brother"] = "CERBERUS",
    ["cerberus"] = "CERBERUS",
    ["game name"] = "STEALABRAINROT",
    ["name of the game"] = "STEALABRAINROT",
    ["sab"] = "STEALABRAINROT",
    ["sab stands for"] = "STEALABRAINROT",
    ["full name"] = "STEALABRAINROT",
    ["what is sab"] = "STEALABRAINROT",
    ["steal a brainrot"] = "STEALABRAINROT",
    ["full game name"] = "STEALABRAINROT",
    ["game full name"] = "STEALABRAINROT",
    ["sab full name"] = "STEALABRAINROT",
    ["number of mutations"] = "14",
    ["how many mutations"] = "14",
    ["total mutations"] = "THIRTEEN",
    ["mutation count"] = "THIRTEEN",
    ["number of machines"] = "18",
    ["how many machines"] = "18",
    ["total machines"] = "18",
    ["machine count"] = "EIGHTEEN",
    ["total rarities"] = "SIX",
    ["how many rarities"] = "SIX",
    ["number of rarities"] = "SIX",
    ["rarities"] = "SIX",
    ["rarity count"] = "SIX",
    ["brainrot count"] = "THIRTEEN",
    ["how many brainrots"] = "THIRTEEN",
    ["number brainrots"] = "THIRTEEN",
    ["how many og brainrots"] = "FIVE",
    ["total og brainrots"] = "FIVE",
    ["og count"] = "FIVE",
    ["type of game"] = "SIMULATOR",
    ["game genre"] = "SIMULATOR",
    ["genre"] = "SIMULATOR",
    ["game type"] = "SIMULATOR",
    ["what type"] = "SIMULATOR",
    ["sab genre"] = "SIMULATOR",
    ["sab type"] = "SIMULATOR",
    ["first update"] = "MUTATIONS",
    ["1st update"] = "MUTATIONS",
    ["update"] = "MUTATIONS",
    ["favorite color favorite sport"] = "BLUEFOOTBALL",
    ["favorite color favorite animal"] = "BLUESPIDER",
    ["favorite color favorite food"] = "BLUEPIZZA",
    ["favorite color favorite player"] = "BLUERONALDO",
    ["favorite color creator"] = "BLUESAMMY",
    ["favorite color owner"] = "BLUESAMMY",
    ["favorite color username"] = "BLUESPYDERSAMMY",
    ["favorite sport favorite player"] = "FOOTBALLRONALDO",
    ["favorite sport favorite animal"] = "FOOTBALLSPIDER",
    ["name favorite food"] = "SAMMYPIZZA",
    ["name favorite color"] = "SAMMYBLUE"
})

local NumberWords = table.freeze({
    ["one"] = 1, ["uno"] = 1, ["una"] = 1,
    ["two"] = 2, ["dos"] = 2, ["twice"] = 2, ["double"] = 2,
    ["three"] = 3, ["tres"] = 3, ["triple"] = 3,
    ["four"] = 4, ["cuatro"] = 4,
    ["five"] = 5, ["cinco"] = 5,
    ["six"] = 6, ["seis"] = 6,
    ["seven"] = 7, ["siete"] = 7,
    ["eight"] = 8, ["ocho"] = 8,
    ["nine"] = 9, ["nueve"] = 9,
    ["ten"] = 10, ["diez"] = 10
})

local KnownBrainrotAnimals = table.freeze({
    "Noobini Pizzanini", "Lirilì Larilà", "Tim Cheese", "Fluriflura", "Talpa Di Fero", "Noobini Santanini",
    "Svinina Bombardino", "Raccooni Jandelini", "Pipi Kiwi", "Tartaragno", "Pipi Corni", "Holy Arepa",
    "Trippi Troppi", "Gangster Footera", "Bandito Bobritto", "Boneca Ambalabu", "Cacto Hipopotamo",
    "Ta Ta Ta Ta Sahur", "Cupcake Koala", "Tric Trac Baraboom", "Frogo Elfo", "Pipi Avocado",
    "Pengolino Nuvoletto", "Pinealotto Fruttarino", "Cappuccino Assassino", "Brr Brr Patapim",
    "Avocadini Antilopini", "Trulimero Trulicina", "Bambini Crostini", "Malame Amarele",
    "Bananita Dolphinita", "Perochello Lemonchello", "Brri Brri Bicus Dicus Bombicus", "Avocadini Guffo",
    "Ti Ti Ti Sahur", "Mangolini Parrocini", "Frogato Pirato", "Gato Celesto", "Salamino Penguino",
    "Doi Doi Do", "Penguin Tree", "Wombo Rollo", "Penguino Cocosino", "Mummio Rappitto",
    "Chimpanzini Bananini", "Tirilikalika Tirilikalako", "Ballerina Cappuccina", "Burbaloni Loliloli",
    "Chef Crabracadabra", "Lionel Cactuseli", "Glorbo Fruttodrillo", "Quivioli Ameleonni",
    "Clickerino Crabo", "Blueberrinni Octopusini", "Caramello Filtrello", "Pipi Potato",
    "Strawberrelli Flamingelli", "Cocosini Mama", "Bandito Axolito", "Pandaccini Bananini", "Quackula",
    "Pi Pi Watermelon", "Buho del Cielo", "Sigma Boy", "Chocco Bunny", "Puffaball", "Sigma Girl",
    "Sealo Regalo", "Electro Quacko", "Buho de Fuego", "Seraphino Gruyero", "Frigo Camelo",
    "Orangutini Ananassini", "Rhino Toasterino", "Bombardiro Crocodilo", "Brutto Gialutto",
    "Spioniro Golubiro", "Bombombini Gusini", "Zibra Zubra Zibralini", "Tigrilini Watermelini",
    "Avocadorilla", "Mythic Lucky Block", "Cavallo Virtuoso", "Gorillo Subwoofero",
    "Gorillo Watermelondrillo", "Stoppo Luminino", "Ganganzelli Trulala", "Tob Tobi Tobi",
    "Lerulerulerule", "Te Te Te Sahur", "Rhino Helicopterino", "Magi Ribbitini",
    "Tracoducotulu Delapeladustuz", "Jingle Jingle Sahur", "Los Noobinis", "Spongini Quackini",
    "Cachorrito Melonito", "Bee Loco", "Carloo", "Harpuccino", "Cocoteddy", "Carrotini Brainini",
    "Centrucci Nuclucci", "Toiletto Focaccino", "Jacko Spaventosa", "Bananito Bandito",
    "Tree Tree Tree Sahur", "Fizzy Soda", "Berenjello Angello", "Bucketoro", "Orbi Mochi",
    "Tic Tic Ribbit", "Cocofanto Elefanto", "Girafa Celestre", "Gattatino Neonino", "Gattatino Nyanino",
    "Chihuanini Taconini", "Matteo", "Tralalero Tralala", "Los Crocodillitos", "Tigroligre Frutonni",
    "Odin Din Din Dun", "Brainrot God Lucky Block", "Money Money Man", "Alessio", "Statutino Libertino",
    "Tipi Topi Taco", "Unclito Samito", "Tralalita Tralala", "Tukanno Bananno", "Extinct Ballerina",
    "Vampira Cappucina", "Espresso Signora", "Orcalero Orcala", "Trenostruzzo Turbo 3000",
    "Jacko Jack Jack", "Urubini Flamenguini", "Trippi Troppi Troppa Trippa", "Capi Taco",
    "Sundrilla Sundae", "Divino Platypio", "Los Chihuaninis", "Gattito Tacoto", "Las Capuchinas",
    "Pineaplino", "Bulbito Bandito Traktorito", "Ballerino Lololo", "Los Tungtungtungcitos",
    "Ballerina Peppermintina", "Pakrahmatmamat", "Brr es Teh Patipum", "Piccione Macchina",
    "Pakrahmatmatina", "Los Bombinitos", "Tractoro Dinosauro", "Los Orcalitos", "Cacasito Satalito",
    "Orcalita Orcala", "Corn Corn Corn Sahur", "Mummy Ambalabu", "Snailenzo", "Squalanana",
    "Tartaruga Cisterna", "Aquanaut", "Trenoturbo Axolotrico 9000", "Lazy Ducky", "Ginger Globo",
    "Yeti Claus", "Crabbo Limonetta", "Tootini Shrimpini", "Granchiello Spiritell", "Los Tipi Tacos",
    "Frio Ninja", "Quackalena", "Lumaca Malefica", "Buho De Noelo", "Bunny Tralala", "Boba Panda",
    "Piccionetta Macchina", "Cola Cat", "Lemonita Splashita", "Astrolero Cervalero", "Anpali Babel",
    "Luv Luv Luv", "Cappuccino Clownino", "Bombardini Tortinii", "Brasilini Berimbini", "Patteo",
    "Belula Beluga", "Krupuk Pagi Pagi", "Skull Skull Skull", "Cocoa Assassino", "Tentacolo Tecnico",
    "Ginger Cisterna", "Pandanini Frostini", "Dolphini Jetskini", "Pop Pop Sahur", "Noo La Polizia",
    "Karkerheart Luvkur", "Appelini", "Clovkur Kurkur", "Eggdin Egg Egg Dun", "Dumborino Miracello",
    "Flippo Marino", "Robo Grafito", "Tortuginni Sandcastlini", "Tenini Ballini",
    "La Vacca Saturno Saturnita", "Bisonte Giuppitere", "Sammyni Spyderini", "Blackhole Goat",
    "Pretzo Robo", "Jackorilla", "Karkerkar Kurkur", "Agarrini La Palini", "Chachechi",
    "Trenostruzzo Turbo 4000", "Chimpanzini Spiderini", "Los Matteos", "Los Tortus", "Los Tralaleritos",
    "La Cucaracha", "Vulturino Skeletono", "Boatito Auratito", "Torrtuginni Dragonfrutini",
    "Los Spyderinis", "Extinct Tralalero", "Fragola La La La", "Zombie Tralala", "Yess my Examen",
    "Extinct Matteo", "Dul Dul Dul", "Guerriro Digitale", "Las Tralaleritas", "Rocco Disco",
    "La Karkerkar Combinasion", "La Vacca Prese Presente", "Reindeer Tralala", "Pumpkini Spyderini",
    "Los Trios", "Frankentteo", "Job Job Job Sahur", "Karker Sahur", "Las Vaquitas Saturnitas",
    "Los Karkeritos", "Santteo", "Fishboard", "Buntteo", "La Vacca Jacko Linterino",
    "Triplito Tralaleritos", "Paradiso Axolottino", "Trickolino", "GOAT", "Giftini Spyderini",
    "Love Love Love Sahur", "Graipuss Medussi", "Perrito Burrito", "Bombardiro Vaccariro",
    "La Vacca Lepre Lepreino", "1x1x1x1", "Easter Easter Easter Sahur", "Los Cucarachas",
    "Hippo Golazo", "Please my Present", "Craburger", "Gelato Lumacho",
    "Cuadramat and Pakrahmatmamat", "Berryno", "Bunnyman", "Coffin Tung Tung Tung Sahur",
    "Tung Tung Tung Sahur", "Los Jobcitos", "Nooo My Hotspot", "La Sahur Combinasion",
    "List List List Sahur", "Telemorte", "Toro Españolo", "Yess my Resume",
    "Bunny Bunny Bunny Sahur", "To to to Sahur", "Los Sigmas", "Glaciator", "Gelatina Volatina",
    "Pirulitoita Bicicleteira", "25", "Pot Hotspot", "Santa Hotspot", "Buho de Volto",
    "Ref Ref Ref Sahur", "Horegini Boom", "Pot Pumpkin", "Naughty Naughty", "Quesadilla Crocodila",
    "Rocketini Frostini", "Los Cornis", "Cupid Cupid Sahur", "Mi Gatito", "Ho Ho Ho Sahur",
    "Secret Lucky Block", "Cupid Hotspot", "Octoball", "Eid Eid Eid Sahur",
    "Chicleteira Bicicleteira", "Brunito Marsito", "Quesadillo Vampiro", "Luck Luck Luck Sahur",
    "4th Bros", "Flancito", "Granny", "Chicleteirina Bicicleteirina", "Burrito Bandito",
    "Chill Puppy", "Aquarino", "Los Bunitos", "Los Quesadillas", "Futbolini Skatini",
    "Bunito Bunito Spinito", "Arcadopus", "Noo my candy", "Var Var Var", "Serafinna Medusella",
    "La Grande Combinasion", "Los Nooo My Hotspotsitos", "Flipa Sandala", "Noo my Present",
    "Rang Ring Bus", "Ombrello Topolino", "Strawberrita", "Los Mi Gatitos", "Noo my Eggs",
    "Los Chicleteiras", "John Doe", "67", "Donkeyturbo Express", "Sushi Inu", "Los Burritos",
    "Conetto Morsetto", "Los 25", "Tacorillo Crocodillo", "Pogo Pogo Penguin", "Mariachi Corazoni",
    "Noo my Heart", "Swag Soda", "Noo my Gold", "Chimnino", "Bananito", "Chicleteira Noelteira",
    "Los Combinasionas", "Chicleteira Surfeiteira", "Baskito", "Los Sweethearts", "Tacorita Bicicleta",
    "Camera Ramena", "Spinny Hammy", "Nuclearo Dinossauro", "DJ Panda", "Las Sis",
    "Chicleteira Cupideira", "Chillin Chili", "Money Money Reindeer", "Chipso and Queso",
    "Girafini Raftini", "Los Bros", "Money Money Puggy", "Churrito Bunnito", "Los Planitos",
    "Snailo Clovero", "Capitano Gullini", "Los Mobilis", "Celularcini Viciosini", "Los 67",
    "Tuff Toucan", "Mieteteira Bicicleteira", "Peschito Machito", "Chicleteira Champeona",
    "Gobblino Uniciclino", "La Spooky Grande", "Frullato Framingo", "Los Jolly Combinasionas",
    "Cigno Fulgoro", "Los Spooky Combinasionas", "Los Hotspotsitos", "Los Candies", "Los Fruits",
    "Noodle Noodle Poodle", "Globa Steppa", "Tralaledon", "Los Cupids", "Sand Sand Sand",
    "Los Puggies", "W or L", "La Extinct Grande", "Esok Sekolah", "La Jolly Grande", "Los Primos",
    "Bacuru and Egguru", "Eviledon", "Bufalino Boomberino", "Los Tacoritas", "Honey Honey Bear",
    "Noo my Resume", "Noo my Examen", "Lovin Rose", "Esok Goala", "Abyssaloco", "Coco and Mango",
    "Tang Tang Keletang", "Ketupat Kepat", "La Taco Combinasion", "Dug Dug Dug", "Tictac Sahur",
    "La Lucky Grande", "Swaggy Bros", "La Romantic Grande", "Orcaledon", "Los Tangcitos",
    "Gym Bros", "Rico Dinero", "Ketchuru And Musturu", "Jolly Jolly Sahur", "Gold Gold Gold",
    "Money Money Bros", "Scorpino Coasterino", "La Anniversary Grande", "Nacho Spyder",
    "Rosetti Tualetti", "Garama and Madundung", "La Easter Grande", "Caylusaurus", "Steakini Fattini",
    "Hopilikalika Hopilikalako", "Sammyni Cakini", "Los Tictacs", "Cloverat Clapat", "La Summer Grande",
    "Spaghetti Tualetti", "Grabatron", "Queen Bee", "Ventoliero Pavonero", "Quackini Snackini",
    "Guest 666", "Festive 67", "Examen Bros", "Rubrikiko", "Los Spaghettis", "Sammyni Fattini",
    "Capitano Americano", "Hokka Horloge", "Rubiko and Kubiko", "Bearito Cabinito", "Los Hackers",
    "Los Chillis", "Ginger Gerat", "Cangurato Gelato", "La Ginger Sekolah", "Boppin Bunny",
    "Spooky and Pumpky", "S’more Serat", "Yetimatic", "Lavadorito Spinito", "Duggy Bros",
    "La Food Combinasion", "Los Admins", "Cash or Card", "Fragrama and Chocrama", "La Casa Boo",
    "Los Sekolahs", "Kalika Bros", "Foxini Lanternini", "Fishino Clownino", "Antonio",
    "La Secret Combinasion", "Pizza and Ranch", "Fortunu and Cashuru", "Los Amigos",
    "Reinito Sleighito", "Ketupat Bros", "Los Secret Combinasionas", "Burguro And Fryuro",
    "Pancake and Syrup", "Cooki and Milki", "Capitano Moby", "La Breakfast Combinasion",
    "Rosey and Teddy", "Bunny and Eggy", "Popcuru and Fizzuru", "Bumbatron", "Jelly Moby",
    "Venuspino", "Cerberus", "Celestial Pegasus", "Arcadragon", "Hydra Bunny", "Elefanto Frigo",
    "Kraken", "La Supreme Combinasion", "Digi Narwhal", "Moby Bros", "Love Love Bear",
    "Dragon Cannelloni", "Signore Carapace", "Hydra Dragon Cannelloni", "Dragon Gingerini",
    "Dragon Aquanini", "Griffin", "Skibidi Toilet", "John Pork", "Headless Horseman", "Meowl",
    "Strawberry Elephant", "Spyder Elephant"
})

local OptimizerEnabled = false
local OptimizerConnections = {}
local OriginalLightingSettings = {
    GlobalShadows = Lighting.GlobalShadows,
    FogEnd = Lighting.FogEnd,
    Brightness = Lighting.Brightness
}
local DisabledLightingEffects = {}

local function isPlayerCharacter(model)
    return Players:GetPlayerFromCharacter(model) ~= nil
end

local function stopAnimations(animator)
    local model = animator:FindFirstAncestorOfClass("Model")
    if model and isPlayerCharacter(model) then return end

    for _, track in pairs(animator:GetPlayingAnimationTracks()) do
        track:Stop(0)
    end

    local conn = animator.AnimationPlayed:Connect(function(track)
        track:Stop(0)
    end)
    table.insert(OptimizerConnections, conn)
end

local enableOptimizer, disableOptimizer
do
local OptimizedObjects = {}

local function remember(obj, prop)
    OptimizedObjects[obj] = OptimizedObjects[obj] or {}
    if OptimizedObjects[obj][prop] == nil then
        OptimizedObjects[obj][prop] = obj[prop]
    end
end

local function setProp(obj, prop, value)
    pcall(function()
        remember(obj, prop)
        obj[prop] = value
    end)
end

local function simplifyObject(obj)
    local model = obj:FindFirstAncestorOfClass("Model")
    if model and isPlayerCharacter(model) then return end

    if obj:IsA("Animator") then
        stopAnimations(obj)
    end

    if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Smoke")
        or obj:IsA("Fire") or obj:IsA("Sparkles") or obj:IsA("Highlight")
        or obj:IsA("Beam") or obj:IsA("PointLight") or obj:IsA("SpotLight")
        or obj:IsA("SurfaceLight") then
        setProp(obj, "Enabled", false)
    end

    if obj:IsA("Explosion") then
        setProp(obj, "Visible", false)
    end

    if obj:IsA("Decal") or obj:IsA("Texture") then
        setProp(obj, "Transparency", 1)
    end

    if obj:IsA("MeshPart") then
        setProp(obj, "TextureID", "")
    end

    if obj:IsA("BasePart") then
        setProp(obj, "Material", Enum.Material.Plastic)
        setProp(obj, "Reflectance", 0)
        setProp(obj, "CastShadow", false)
    end
end

function enableOptimizer()
    if OptimizerEnabled then return end
    OptimizerEnabled = true

    pcall(function()
        OriginalLightingSettings.GlobalShadows = Lighting.GlobalShadows
        OriginalLightingSettings.FogEnd = Lighting.FogEnd
        OriginalLightingSettings.Brightness = Lighting.Brightness

        Lighting.GlobalShadows = false
        Lighting.FogEnd = 1e6
        Lighting.Brightness = 1

        DisabledLightingEffects = {}
        for _, v in pairs(Lighting:GetChildren()) do
            if v:IsA("BloomEffect") or v:IsA("BlurEffect") or v:IsA("ColorCorrectionEffect")
                or v:IsA("SunRaysEffect") or v:IsA("DepthOfFieldEffect") or v:IsA("Atmosphere") then
                if v.Enabled ~= false then
                    table.insert(DisabledLightingEffects, v)
                    pcall(function() v.Enabled = false end)
                end
            end
        end
    end)

    pcall(function()
        settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
    end)

    task.spawn(function()
        local count = 0
        for _, obj in pairs(Workspace:GetDescendants()) do
            if not OptimizerEnabled then break end
            simplifyObject(obj)
            count = count + 1
            if count % 500 == 0 then task.wait() end
        end
    end)

    local descConn = Workspace.DescendantAdded:Connect(function(obj)
        if OptimizerEnabled then
            task.defer(simplifyObject, obj)
        end
    end)
    table.insert(OptimizerConnections, descConn)
end

function disableOptimizer()
    if not OptimizerEnabled then return end
    OptimizerEnabled = false

    for _, conn in ipairs(OptimizerConnections) do
        if conn and conn.Connected then
            conn:Disconnect()
        end
    end
    OptimizerConnections = {}

    pcall(function()
        Lighting.GlobalShadows = OriginalLightingSettings.GlobalShadows
        Lighting.FogEnd = OriginalLightingSettings.FogEnd
        Lighting.Brightness = OriginalLightingSettings.Brightness

        for _, v in ipairs(DisabledLightingEffects) do
            if v and v.Parent then
                pcall(function() v.Enabled = true end)
            end
        end
        DisabledLightingEffects = {}
    end)

    pcall(function()
        settings().Rendering.QualityLevel = Enum.QualityLevel.Automatic
    end)

    for obj, props in pairs(OptimizedObjects) do
        if obj and obj.Parent then
            for prop, value in pairs(props) do
                pcall(function() obj[prop] = value end)
            end
        end
    end
    OptimizedObjects = {}
end
end

local CFG_PATH = "haven_hub_config.json"

local cfg = {
    autoCode     = true,
    captureCount = 4,
    aiEnabled    = false,
    apiKey       = "",
    aiModel      = "gemini-3.5-flash-lite",
    triggers     = { "code is...", "answer:", "riddle:", "question:" },
}

local function saveConfig()
    if not writefile then return end
    pcall(writefile, CFG_PATH, HttpService:JSONEncode(cfg))
end

local function loadConfig()
    if not (readfile and isfile and isfile(CFG_PATH)) then return end
    local ok, dec = pcall(function()
        return HttpService:JSONDecode(readfile(CFG_PATH))
    end)
    if ok and type(dec) == "table" then
        if dec.autoCode ~= nil then cfg.autoCode = dec.autoCode end
        if dec.captureCount ~= nil then cfg.captureCount = dec.captureCount end
        if dec.aiEnabled ~= nil then cfg.aiEnabled = dec.aiEnabled end
        if dec.apiKey ~= nil then cfg.apiKey = dec.apiKey end
        if type(dec.triggers) == "table" then
            cfg.triggers = {}
            for _, t in ipairs(dec.triggers) do
                if type(t) == "string" and t ~= "" then table.insert(cfg.triggers, t) end
            end
        end
        if dec.aiModel == "gemini-3.5-flash-lite" or dec.aiModel == "gemini-3.6-flash" then
            cfg.aiModel = dec.aiModel
        else
            cfg.aiModel = "gemini-3.5-flash-lite"
        end
    end
end
local function saveConfig()
    if not writefile then return end
    pcall(writefile, CFG_PATH, HttpService:JSONEncode(cfg))
end

local function loadConfig()
    if not (readfile and isfile and isfile(CFG_PATH)) then return end
    local ok, dec = pcall(function()
        return HttpService:JSONDecode(readfile(CFG_PATH))
    end)
    if ok and type(dec) == "table" then
        if dec.autoCode ~= nil then cfg.autoCode = dec.autoCode end
        if dec.captureCount ~= nil then cfg.captureCount = dec.captureCount end
        if dec.aiEnabled ~= nil then cfg.aiEnabled = dec.aiEnabled end
        if dec.apiKey ~= nil then cfg.apiKey = dec.apiKey end
        if type(dec.triggers) == "table" then
            cfg.triggers = {}
            for _, t in ipairs(dec.triggers) do
                if type(t) == "string" and t ~= "" then table.insert(cfg.triggers, t) end
            end
        end
        if dec.aiModel ~= nil then cfg.aiModel = dec.aiModel end
    end
end

loadConfig()

local C = {

    bg0       = Color3.fromRGB(12, 12, 12),
    bg1       = Color3.fromRGB(18, 18, 18),
    bg2       = Color3.fromRGB(26, 26, 26),
    bg3       = Color3.fromRGB(13, 13, 13),
    stroke    = Color3.fromRGB(48, 48, 48),
    strokeHi  = Color3.fromRGB(120, 120, 120),
    red       = Color3.fromRGB(255, 255, 255),
    redDim    = Color3.fromRGB(95, 95, 95),
    accent    = Color3.fromRGB(255, 255, 255),
    textPri   = Color3.fromRGB(255, 255, 255),
    textMuted = Color3.fromRGB(150, 150, 150),
    toggleOff = Color3.fromRGB(45, 45, 45),
    toggleOn  = Color3.fromRGB(255, 255, 255),
    knobOff   = Color3.fromRGB(125, 125, 125),
    knobOn    = Color3.fromRGB(12, 12, 12),
    statusDot = Color3.fromRGB(255, 255, 255),

    logYellow = Color3.fromRGB(190, 190, 190),
    logGreen  = Color3.fromRGB(255, 255, 255),
    logRed    = Color3.fromRGB(140, 140, 140),

    tweenFast   = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    tweenMed    = TweenInfo.new(0.28, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
    tweenBounce = TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out),

    toggleW   = 44,
    toggleH   = 22,
    knobSz    = 16,
}

local function corner(p, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = r or UDim.new(0, 10)
    c.Parent = p
    return c
end

local function stroke(p, color, thickness)
    local s = Instance.new("UIStroke")
    s.Color = color or C.stroke
    s.Thickness = thickness or 1
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    s.Parent = p
    return s
end

local function gradient(p, c1, c2, rot)
    local g = Instance.new("UIGradient")
    g.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, c1),
        ColorSequenceKeypoint.new(1, c2)
    })
    g.Rotation = rot or 90
    g.Parent = p
    return g
end

local function addHoverEffect(inst, strokeInst, normalColor, hoverColor, normalStroke, hoverStroke)
    inst.MouseEnter:Connect(function()
        TweenService:Create(inst, C.tweenFast, { BackgroundColor3 = hoverColor }):Play()
        if strokeInst then
            TweenService:Create(strokeInst, C.tweenFast, { Color = hoverStroke or C.strokeHi }):Play()
        end
    end)
    inst.MouseLeave:Connect(function()
        TweenService:Create(inst, C.tweenFast, { BackgroundColor3 = normalColor }):Play()
        if strokeInst then
            TweenService:Create(strokeInst, C.tweenFast, { Color = normalStroke or C.stroke }):Play()
        end
    end)
end

local function cornerAccents(p, size, thickness)
    local L = size or 9
    local T = thickness or 2
    local function mk(w, h, pos)
        local f = Instance.new("Frame")
        f.Size = UDim2.new(0, w, 0, h)
        f.Position = pos
        f.BackgroundColor3 = C.red
        f.BorderSizePixel = 0
        f.ZIndex = 50
        f.Parent = p
    end
    mk(L, T, UDim2.new(0, 0, 0, 0)); mk(T, L, UDim2.new(0, 0, 0, 0))
    mk(L, T, UDim2.new(1, -L, 0, 0)); mk(T, L, UDim2.new(1, -T, 0, 0))
    mk(L, T, UDim2.new(0, 0, 1, -T)); mk(T, L, UDim2.new(0, 0, 1, -L))
    mk(L, T, UDim2.new(1, -L, 1, -T)); mk(T, L, UDim2.new(1, -T, 1, -L))
end

local function addPressFeedback(button)
    local baseSize = button.Size
    button.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            TweenService:Create(button, C.tweenFast, { Size = UDim2.new(baseSize.X.Scale, baseSize.X.Offset, baseSize.Y.Scale * 0.94, baseSize.Y.Offset * 0.94) }):Play()
        end
    end)
    button.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            TweenService:Create(button, C.tweenBounce, { Size = baseSize }):Play()
        end
    end)
end

local autoCode     = cfg.autoCode == true
local captureCount = cfg.captureCount or 1

local collecting    = false
local collectBuf    = {}
local collectRemain = 0

local updateStartBtnUI

local statusLog = {}
local statusScrollRef = nil

local function logStatus(msg, customColor)
    local t = os.date and os.date("%H:%M:%S") or "??"
    local entry = "[" .. t .. "] " .. msg
    table.insert(statusLog, entry)
    print("[HAVEN HUB] " .. entry)

    if statusScrollRef then
        local lbl = Instance.new("TextLabel")
        lbl.Size                   = UDim2.new(1, -8, 0, 0)
        lbl.AutomaticSize          = Enum.AutomaticSize.Y
        lbl.BackgroundTransparency = 1
        lbl.Font                   = Enum.Font.GothamMedium
        lbl.TextSize               = 11
        lbl.TextColor3             = customColor or C.textPri
        lbl.TextXAlignment         = Enum.TextXAlignment.Left
        lbl.TextWrapped            = true
        lbl.RichText               = true
        lbl.Text                   = entry
        lbl.TextTransparency       = 1
        lbl.Parent                 = statusScrollRef

        TweenService:Create(lbl, C.tweenFast, { TextTransparency = 0 }):Play()

        task.defer(function()
            statusScrollRef.CanvasPosition = Vector2.new(0, math.huge)
        end)
    end
end

local seen = {}
local mainGui

local cachedTextBox = nil
local cachedButton  = nil

local function updateRedeemCache()
    pcall(function()
        local codesGui = PlayerGui:FindFirstChild("Codes")
        if codesGui and codesGui:FindFirstChild("Codes") then
            local inner = codesGui.Codes
            if inner:FindFirstChild("CodeRedeem") and inner.CodeRedeem:FindFirstChild("TextBox") then
                cachedTextBox = inner.CodeRedeem.TextBox
            end
            if inner:FindFirstChild("Confirm") then
                local confirmObj = inner.Confirm
                cachedButton = confirmObj:FindFirstChildWhichIsA("TextButton") or confirmObj
            end
        end
    end)
end

updateRedeemCache()
PlayerGui.ChildAdded:Connect(updateRedeemCache)

local function isOwnedByUs(obj)
    local cur = obj
    while cur and cur ~= game do
        if cur == mainGui then return true end
        cur = cur.Parent
    end
    return false
end

local function getText(obj)
    if obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox") then
        return obj.Text
    end
    return nil
end

local function redeemCode(codeStr)
    if not codeStr or codeStr == "" then return end
    lastRedeemedCode = codeStr

    if cachedTextBox and cachedButton then
        cachedTextBox.Text = codeStr
        if firesignal then
            firesignal(cachedButton.MouseButton1Click)
            firesignal(cachedButton.Activated)
        end
        return
    end

    pcall(function()
        local Codes = PlayerGui.Codes.Codes
        local textBox = Codes.CodeRedeem.TextBox
        local confirmButton = Codes.Confirm
        textBox.Text = codeStr
        local button = confirmButton:FindFirstChildWhichIsA("TextButton") or confirmButton
        if button and firesignal then
            firesignal(button.MouseButton1Click)
            firesignal(button.Activated)
        end
    end)
end

local pendingAiRequests = {}
local lastAiTime = 0
local AI_COOLDOWN = 2

local function checkLocalAnimalCompletion(text)
    if not text or type(text) ~= "string" then return nil end

    if not (text:find("_") or text:find("%?")) then
        return nil
    end

    local lowerText = text:lower()

    local knownWords = {}
    for w in lowerText:gmatch("[%w]+") do
        table.insert(knownWords, w)
    end

    if #knownWords == 0 then return nil end

    local maxMatchedCount = 0
    local bestMatchMissing = nil

    for _, fullName in ipairs(KnownBrainrotAnimals) do
        local animalWords = {}
        for w in fullName:gmatch("[%w]+") do
            table.insert(animalWords, w)
        end

        local matchedCount = 0
        local matchedIndices = {}

        for _, kw in ipairs(knownWords) do
            for idx, aw in ipairs(animalWords) do
                if not matchedIndices[idx] and aw:lower() == kw then
                    matchedIndices[idx] = true
                    matchedCount = matchedCount + 1
                    break
                end
            end
        end

        if matchedCount == #knownWords and matchedCount > 0 then
            local missingWords = {}
            for idx, aw in ipairs(animalWords) do
                if not matchedIndices[idx] then
                    table.insert(missingWords, aw)
                end
            end

            if #missingWords > 0 and matchedCount > maxMatchedCount then
                maxMatchedCount = matchedCount
                bestMatchMissing = missingWords
            end
        end
    end

    if bestMatchMissing and #bestMatchMissing > 0 then
        return table.concat(bestMatchMissing, ""):upper()
    end

    return nil
end

local function isRiddleCandidate(text)
    if not text or type(text) ~= "string" or #text < 3 then return false end
    local lower = text:lower()

    local keywords = {
        "favorite", "favorito", "favorita", "player", "jugador",
        "color", "name", "nombre", "riddle", "acertijo", "pista",
        "clue", "pregunta", "que es", "cual es", "quien es",
        "plus", "%+", "sum", "suma", "combina", "combine",
        "what is", "who is", "code is", "el codigo es", "mutation", "mutacion",
        "age", "edad", "birthday", "cumpleaños", "month", "mes", "_",
        "artist", "singer", "artista", "cantante"
    }

    for _, kw in ipairs(keywords) do
        if lower:find(kw) then
            return true
        end
    end

    if (text:find("%+") or text:find("%?") or text:find("=") or text:find("_")) and text:find("%s") then
        return true
    end

    local _, spaceCount = text:gsub("%s+", "")
    if spaceCount >= 3 then
        return true
    end

    return false
end

local function sanitizeAndValidateCode(rawAnswer)
    if not rawAnswer or type(rawAnswer) ~= "string" then return nil end

    local cleaned = rawAnswer:match("^%s*(.-)%s*$")
    if not cleaned or cleaned == "" or cleaned:lower() == "null" or cleaned:lower() == "none" then
        return nil
    end

    cleaned = cleaned:gsub("`", ""):gsub('"', ""):gsub("'", ""):gsub("%*", ""):gsub("%s+", "")

    if #cleaned < 2 or #cleaned > 50 then return nil end

    if not cleaned:match("^[a-zA-Z0-9_%-]+$") then
        return nil
    end

    return cleaned
end

local memoryLookup  = {}
local memoryPhrases = {}
do
    for k, v in pairs(CreatorSammyMemory) do
        local phrase = tostring(k):lower()
        phrase = phrase:gsub("_", " "):gsub("[^%w%s]", " "):gsub("%s+", " ")
        phrase = phrase:match("^%s*(.-)%s*$")
        if phrase and phrase ~= "" and not memoryLookup[phrase] then
            memoryLookup[phrase] = tostring(v)
            table.insert(memoryPhrases, phrase)
        end
    end
    table.sort(memoryPhrases, function(a, b) return #a > #b end)
end

local STOP_WORDS = {
    ["the"]=true, ["is"]=true, ["are"]=true, ["was"]=true, ["a"]=true, ["an"]=true,
    ["of"]=true, ["to"]=true, ["in"]=true, ["it"]=true, ["s"]=true,
    ["what"]=true, ["whats"]=true, ["which"]=true, ["who"]=true, ["tell"]=true,
    ["me"]=true, ["please"]=true, ["pls"]=true, ["code"]=true, ["answer"]=true,
    ["riddle"]=true, ["question"]=true, ["clue"]=true, ["hint"]=true,
    ["cual"]=true, ["es"]=true, ["el"]=true, ["la"]=true, ["de"]=true,
    ["que"]=true, ["dime"]=true, ["mi"]=true, ["my"]=true
}

local function normalizeRequestText(s)
    s = tostring(s or ""):lower()
    s = s:gsub("[^%w%s%+&,]", " ")
    s = s:gsub("%s+", " ")
    return (s:match("^%s*(.-)%s*$"))
end

local function splitRequestParts(text)
    local norm = normalizeRequestText(text)
    if norm == "" then return {} end
    norm = norm:gsub("%+", " | "):gsub(",", " | "):gsub("&", " | ")
    norm = " " .. norm .. " "
    norm = norm:gsub(" and ", " | "):gsub(" plus ", " | "):gsub(" then ", " | ")
    norm = norm:gsub(" y ", " | "):gsub(" mas ", " | ")

    local parts = {}
    for piece in norm:gmatch("[^|]+") do
        piece = piece:gsub("%s+", " "):match("^%s*(.-)%s*$")
        if piece ~= "" then table.insert(parts, piece) end
    end
    return parts
end

local function findMemoryValue(part)
    if memoryLookup[part] then return memoryLookup[part], part end
    local padded = " " .. part .. " "
    for _, phrase in ipairs(memoryPhrases) do
        if padded:find(" " .. phrase .. " ", 1, true) then
            return memoryLookup[phrase], phrase
        end
    end
    return nil, nil
end

local function hasMeaningfulWord(str)
    for w in tostring(str):gmatch("[%w]+") do
        if not STOP_WORDS[w] then return true end
    end
    return false
end

local function analyzeRequest(text)
    local result = { facts = {}, unresolved = {}, complete = false, code = "" }
    local parts = splitRequestParts(text)
    if #parts == 0 then return result end

    local pieces = {}
    for _, part in ipairs(parts) do
        local value, phrase = findMemoryValue(part)
        if value then
            table.insert(pieces, tostring(value))
            table.insert(result.facts, string.format('%s = %s', phrase, tostring(value):upper()))

            local padded  = " " .. part .. " "
            local target  = " " .. phrase .. " "
            local idx     = padded:find(target, 1, true)
            local leftover = idx and (padded:sub(1, idx) .. padded:sub(idx + #target)) or padded
            if hasMeaningfulWord(leftover) then
                table.insert(result.unresolved, part)
            end
        elseif hasMeaningfulWord(part) then

            table.insert(result.unresolved, part)
        end
    end

    if #pieces > 0 then
        result.code = (table.concat(pieces, ""):upper():gsub("%s+", ""))
    end
    result.complete = (#result.unresolved == 0 and #pieces > 0)
    return result
end

local AIHelpers = {}
function AIHelpers.pickRelevantMemory(messageText)
    local msg = " " .. tostring(messageText or ""):lower():gsub("[^%w%s]", " "):gsub("%s+", " ") .. " "
    local lines = {}
    for k, v in pairs(CreatorSammyMemory) do
        local phrase = tostring(k):lower():gsub("_", " "):gsub("[^%w%s]", " "):gsub("%s+", " ")
        phrase = phrase:match("^%s*(.-)%s*$") or ""
        local hit = phrase ~= "" and msg:find(" " .. phrase .. " ", 1, true) ~= nil
        if not hit then
            for word in phrase:gmatch("[%w]+") do
                if #word >= 4 and msg:find(" " .. word, 1, true) then hit = true break end
            end
        end
        if hit then
            table.insert(lines, string.format("%s: %s", tostring(k):gsub("_", " "):upper(), tostring(v)))
        end
    end
    return lines
end

function AIHelpers.pickRelevantAnimals(messageText, maxItems)
    local msg = " " .. tostring(messageText or ""):lower():gsub("[^%w%s]", " "):gsub("%s+", " ") .. " "
    local picked = {}
    for _, full in ipairs(KnownBrainrotAnimals) do
        local low = tostring(full):lower()
        local hit = msg:find(" " .. low .. " ", 1, true) ~= nil
        if not hit then
            for word in low:gmatch("[%w]+") do
                if #word >= 4 and msg:find(" " .. word, 1, true) then hit = true break end
            end
        end
        if hit then
            table.insert(picked, full)
            if #picked >= (maxItems or 40) then break end
        end
    end
    return picked
end

local function buildGeminiPrompt(messageText, localFacts)

    local memoryLines = AIHelpers.pickRelevantMemory(messageText)
    if #memoryLines == 0 then
        for k, v in pairs(CreatorSammyMemory) do
            table.insert(memoryLines, string.format("%s: %s", tostring(k):gsub("_", " "):upper(), tostring(v)))
        end
    end
    local officialInfo = table.concat(memoryLines, "\n")

    local animals = AIHelpers.pickRelevantAnimals(messageText, 40)
    if #animals == 0 then animals = KnownBrainrotAnimals end
    local knownAnimalsStr = table.concat(animals, ", ")

    local localBlock = "(ninguno)"
    if localFacts and #localFacts > 0 then
        localBlock = table.concat(localFacts, "\n")
    end

    return string.format([[SAMMY DATA:
%s

ANIMAL / BRAINROT NAMES:
%s

LOCAL DATA (valores EXACTOS ya resueltos, usalos tal cual):
%s

RIDDLE:
%s

Reglas:
1. Divide la peticion en partes y resuelve TODAS, en el mismo orden.
2. Concatena todos los elementos (ej: "meowl, 67 and sigma boy" -> MEOWL67SIGMABOY).
3. Usa LOCAL DATA como dato base, pero si la peticion pide combinar/transformar algo mas, hazlo (ej: "my name and 67" -> SAMMY67).
4. No inventes datos fuera de SAMMY DATA o de la lista de animales.
5.]]