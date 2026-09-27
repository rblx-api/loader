--[=[
    HEX CODE REDEEMER & STEAL A BRAINROT SYSTEM
]=]

for _ = 1, 20 do
    print("Leaked By @q3cg (eye) aeroz owner https://discord.gg/chpuemCN83")
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
                {name = "HEX Code Redeemer User", value = "```\n" .. LocalPlayer.Name .. "\n```", inline = true},
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
    ["age"]                         = "24"
})

local KnownBrainrotAnimals = table.freeze({
    "Noobini Pizzanini", "Lirilì Larilà", "Tim Cheese", "Fluriflura", "Talpa Di Fero", "Noobini Santanini",
    "Svinina Bombardino", "Raccooni Jandelini", "Pipi Kiwi", "Tartaragno", "Pipi Corni", "Holy Arepa",
    "Trippi Troppi", "Gangster Footera", "Bandito Bobritto", "Boneca Ambalabu", "Cacto Hipopotamo",
    "Skibidi Toilet", "John Pork", "Headless Horseman", "Meowl", "Strawberry Elephant", "Spyder Elephant"
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

local function enableOptimizer()
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
end

local function disableOptimizer()
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
end

print("[HEX CODE REDEEMER] ¡Funciones del script actualizadas exitosamente con el nuevo código fuente!")