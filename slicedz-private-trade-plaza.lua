local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local function getHui()
    return gethui and gethui() or game:GetService("CoreGui")
end

local request_ = syn and syn.request or http and http.request or http_request or request
local setClipboard = setclipboard or toclipboard or function() end
local identifyExecutor = identifyexecutor

local CONFIG_FOLDER = "SlicedzConvincer"
local CONFIG_FILE = CONFIG_FOLDER .. "/config.json"
local HOPS_FILE = CONFIG_FOLDER .. "/hops.json"

local function ensureFolder()
    pcall(function()
        if type(makefolder) == "function" then
            if type(isfolder) == "function" then
                if not isfolder(CONFIG_FOLDER) then
                    makefolder(CONFIG_FOLDER)
                end
            else
                makefolder(CONFIG_FOLDER)
            end
        end
    end)
end

local settings = {
    myLang = "en",
    theirLang = "auto",
    presets = {},
    translatorOn = true,
    pos = { x = 0.03, y = 0.12 },
    priorityList = {},
    autoHop = false,
    hopTier = "Normal",
    hopDelay = 2,
    alertSound = true,
    alertSoundId = "rbxassetid://6518811702",
    showAvatars = true,
    beamToBase = true,
}

pcall(function()
    if type(isfile) == "function" and isfile(CONFIG_FILE) then
        local ok, result = pcall(function()
            return HttpService:JSONDecode(readfile(CONFIG_FILE))
        end)
        if ok and type(result) == "table" then
            for k, v in pairs(result) do
                settings[k] = v
            end
        end
    end
end)

local function saveConfig()
    if type(writefile) ~= "function" then
        return
    end
    ensureFolder()
    pcall(function()
        writefile(CONFIG_FILE, HttpService:JSONEncode(settings))
    end)
end

local hopData = { hoppedServers = {} }

pcall(function()
    if type(isfile) == "function" and isfile(HOPS_FILE) then
        local ok, result = pcall(function()
            return HttpService:JSONDecode(readfile(HOPS_FILE))
        end)
        if ok and type(result) == "table" and type(result.hoppedServers) == "table" then
            hopData.hoppedServers = result.hoppedServers
        end
    end
end)

local function saveHops()
    if type(writefile) ~= "function" then
        return
    end
    ensureFolder()
    pcall(function()
        writefile(HOPS_FILE, HttpService:JSONEncode(hopData))
    end)
end

local LANGUAGES = {
    { code = "en", name = "English" },
    { code = "es", name = "Spanish" },
    { code = "pt", name = "Portuguese" },
    { code = "fr", name = "French" },
    { code = "de", name = "German" },
    { code = "it", name = "Italian" },
    { code = "ru", name = "Russian" },
    { code = "tr", name = "Turkish" },
    { code = "pl", name = "Polish" },
    { code = "nl", name = "Dutch" },
    { code = "ar", name = "Arabic" },
    { code = "id", name = "Indonesian" },
    { code = "vi", name = "Vietnamese" },
    { code = "th", name = "Thai" },
    { code = "ja", name = "Japanese" },
    { code = "ko", name = "Korean" },
    { code = "zh-CN", name = "Chinese (Simplified)" },
    { code = "zh-TW", name = "Chinese (Traditional)" },
    { code = "hi", name = "Hindi" },
    { code = "bn", name = "Bengali" },
    { code = "ur", name = "Urdu" },
    { code = "pa", name = "Punjabi" },
    { code = "ta", name = "Tamil" },
    { code = "te", name = "Telugu" },
    { code = "mr", name = "Marathi" },
    { code = "gu", name = "Gujarati" },
    { code = "ml", name = "Malayalam" },
    { code = "kn", name = "Kannada" },
    { code = "fil", name = "Filipino" },
    { code = "ms", name = "Malay" },
    { code = "fa", name = "Persian" },
    { code = "he", name = "Hebrew" },
    { code = "uk", name = "Ukrainian" },
    { code = "sv", name = "Swedish" },
    { code = "no", name = "Norwegian" },
    { code = "da", name = "Danish" },
    { code = "fi", name = "Finnish" },
    { code = "cs", name = "Czech" },
    { code = "sk", name = "Slovak" },
    { code = "el", name = "Greek" },
    { code = "hu", name = "Hungarian" },
    { code = "ro", name = "Romanian" },
    { code = "bg", name = "Bulgarian" },
    { code = "hr", name = "Croatian" },
    { code = "sr", name = "Serbian" },
    { code = "sl", name = "Slovenian" },
    { code = "lt", name = "Lithuanian" },
    { code = "lv", name = "Latvian" },
    { code = "et", name = "Estonian" },
    { code = "af", name = "Afrikaans" },
    { code = "sw", name = "Swahili" },
    { code = "ca", name = "Catalan" },
    { code = "gl", name = "Galician" },
    { code = "is", name = "Icelandic" },
    { code = "ga", name = "Irish" },
    { code = "cy", name = "Welsh" },
    { code = "sq", name = "Albanian" },
    { code = "mk", name = "Macedonian" },
    { code = "bs", name = "Bosnian" },
    { code = "ka", name = "Georgian" },
    { code = "hy", name = "Armenian" },
    { code = "kk", name = "Kazakh" },
    { code = "uz", name = "Uzbek" },
    { code = "mn", name = "Mongolian" },
    { code = "ne", name = "Nepali" },
    { code = "si", name = "Sinhala" },
    { code = "km", name = "Khmer" },
    { code = "lo", name = "Lao" },
    { code = "my", name = "Burmese" },
    { code = "am", name = "Amharic" },
    { code = "yo", name = "Yoruba" },
    { code = "ig", name = "Igbo" },
    { code = "ha", name = "Hausa" },
    { code = "zu", name = "Zulu" },
    { code = "haw", name = "Hawaiian" },
    { code = "mi", name = "Maori" },
    { code = "la", name = "Latin" },
    { code = "eo", name = "Esperanto" },
    { code = "be", name = "Belarusian" },
    { code = "bs", name = "Bosnian" },
    { code = "eu", name = "Basque" },
    { code = "ceb", name = "Cebuano" },
    { code = "ny", name = "Chichewa" },
    { code = "co", name = "Corsican" },
    { code = "fy", name = "Frisian" },
    { code = "gd", name = "Scots Gaelic" },
    { code = "ht", name = "Haitian Creole" },
    { code = "hmn", name = "Hmong" },
    { code = "ig", name = "Igbo" },
    { code = "jw", name = "Javanese" },
    { code = "ky", name = "Kyrgyz" },
    { code = "lb", name = "Luxembourgish" },
    { code = "mg", name = "Malagasy" },
    { code = "mt", name = "Maltese" },
    { code = "or", name = "Odia" },
    { code = "ps", name = "Pashto" },
    { code = "sm", name = "Samoan" },
    { code = "sn", name = "Shona" },
    { code = "sd", name = "Sindhi" },
    { code = "so", name = "Somali" },
    { code = "st", name = "Sesotho" },
    { code = "su", name = "Sundanese" },
    { code = "tg", name = "Tajik" },
    { code = "tt", name = "Tatar" },
    { code = "tk", name = "Turkmen" },
    { code = "ug", name = "Uyghur" },
    { code = "xh", name = "Xhosa" },
    { code = "yi", name = "Yiddish" },
    { code = "as", name = "Assamese" },
    { code = "ay", name = "Aymara" },
    { code = "bm", name = "Bambara" },
    { code = "bho", name = "Bhojpuri" },
    { code = "dv", name = "Dhivehi" },
    { code = "doi", name = "Dogri" },
    { code = "ee", name = "Ewe" },
    { code = "gn", name = "Guarani" },
    { code = "ilo", name = "Ilocano" },
    { code = "kri", name = "Krio" },
    { code = "gom", name = "Konkani" },
    { code = "ckb", name = "Kurdish (Sorani)" },
    { code = "ln", name = "Lingala" },
    { code = "lg", name = "Luganda" },
    { code = "mai", name = "Maithili" },
    { code = "mni-Mtei", name = "Meiteilon" },
    { code = "lus", name = "Mizo" },
    { code = "om", name = "Oromo" },
    { code = "qu", name = "Quechua" },
    { code = "sa", name = "Sanskrit" },
    { code = "nso", name = "Sepedi" },
    { code = "ti", name = "Tigrinya" },
    { code = "ts", name = "Tsonga" },
    { code = "ak", name = "Twi" },
}

local langNames = {}
for _, lang in ipairs(LANGUAGES) do
    langNames[lang.code] = lang.name
end

local function langDisplay(code)
    if not code or code == "" or code == "auto" then
        return "—"
    end
    return langNames[code] or code:upper()
end

local COLORS = {
    BG = Color3.fromRGB(24, 13, 14),
    SURF = Color3.fromRGB(42, 20, 22),
    SURF2 = Color3.fromRGB(58, 24, 28),
    TEXT = Color3.fromRGB(238, 238, 238),
    DIM = Color3.fromRGB(205, 110, 110),
    ACCENT = Color3.fromRGB(230, 72, 72),
    ACCENT2 = Color3.fromRGB(190, 44, 58),
    STROKE = Color3.fromRGB(215, 70, 70),
    GREEN1 = Color3.fromRGB(22, 100, 66),
    GREEN2 = Color3.fromRGB(26, 150, 105),
    GREEN_STROKE = Color3.fromRGB(70, 200, 132),
    OFF_BG = Color3.fromRGB(62, 26, 28),
    OFF_TEXT = Color3.fromRGB(180, 95, 95),
    BLUE = Color3.fromRGB(90, 150, 235),
}

local function createCorner(parent, radius)
    local corner = Instance.new("UICorner", parent)
    corner.CornerRadius = UDim.new(0, radius or 8)
    return corner
end

local function createStroke(parent, color, thickness, transparency)
    local stroke = Instance.new("UIStroke", parent)
    stroke.Color = color or COLORS.STROKE
    stroke.Thickness = thickness or 1
    stroke.Transparency = transparency or 0.4
    return stroke
end

local function tween(obj, duration, props)
    TweenService:Create(obj, TweenInfo.new(duration or 0.14, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), props):Play()
end

local function createImageLabel(parent)
    local img = Instance.new("ImageLabel", parent)
    img.AnchorPoint = Vector2.new(0.5, 0.5)
    img.Position = UDim2.new(0.5, 0, 0.5, 2)
    img.Size = UDim2.new(1, 26, 1, 26)
    img.BackgroundTransparency = 1
    img.Image = "rbxassetid://6014261993"
    img.ImageColor3 = Color3.new(0, 0, 0)
    img.ImageTransparency = 0.72
    img.ScaleType = Enum.ScaleType.Slice
    img.SliceCenter = Rect.new(49, 49, 450, 450)
    img.ZIndex = 0
    return img
end

local function createButton(parent, text, opts)
    opts = opts or {}
    local btn = Instance.new("TextButton", parent)
    btn.AutoButtonColor = false
    btn.BackgroundColor3 = opts.color or COLORS.ACCENT2
    btn.BorderSizePixel = 0
    btn.Text = text
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = opts.textSize or 11
    btn.TextColor3 = COLORS.TEXT
    createCorner(btn, opts.radius or 8)
    local stroke = createStroke(btn, opts.stroke or COLORS.ACCENT, 1, opts.strokeT or 0.35)
    btn.MouseButton1Down:Connect(function()
        tween(btn, 0.1, { BackgroundColor3 = opts.press or COLORS.ACCENT })
    end)
    btn.MouseButton1Up:Connect(function()
        tween(btn, 0.14, { BackgroundColor3 = opts.color or COLORS.ACCENT2 })
    end)
    return btn, stroke
end

local function notify(title, text, duration)
    pcall(function()
        local hui = getHui()
        local existing = hui:FindFirstChild("SlcConvToast")
        if existing then
            existing:Destroy()
        end
        local gui = Instance.new("ScreenGui")
        gui.Name = "SlcConvToast"
        gui.ResetOnSpawn = false
        gui.DisplayOrder = 1000000
        gui.Parent = hui
        local frame = Instance.new("Frame", gui)
        frame.Size = UDim2.new(0, 300, 0, 56)
        frame.Position = UDim2.new(0.5, -150, 0, 80)
        frame.BackgroundColor3 = Color3.fromRGB(20, 12, 12)
        frame.BackgroundTransparency = 1
        frame.BorderSizePixel = 0
        createCorner(frame, 9)
        local stroke = Instance.new("UIStroke", frame)
        stroke.Thickness = 1
        stroke.Color = COLORS.ACCENT
        stroke.Transparency = 1
        local accentBar = Instance.new("Frame", frame)
        accentBar.Size = UDim2.new(0, 3, 1, -12)
        accentBar.Position = UDim2.new(0, 8, 0, 6)
        accentBar.BackgroundColor3 = COLORS.ACCENT
        accentBar.BorderSizePixel = 0
        accentBar.BackgroundTransparency = 1
        createCorner(accentBar, 0)
        local titleLbl = Instance.new("TextLabel", frame)
        titleLbl.Size = UDim2.new(1, -22, 0, 18)
        titleLbl.Position = UDim2.new(0, 16, 0, 8)
        titleLbl.BackgroundTransparency = 1
        titleLbl.Text = tostring(title):upper()
        titleLbl.Font = Enum.Font.GothamBlack
        titleLbl.TextSize = 12
        titleLbl.TextColor3 = COLORS.ACCENT
        titleLbl.TextXAlignment = Enum.TextXAlignment.Left
        titleLbl.TextTransparency = 1
        local bodyLbl = Instance.new("TextLabel", frame)
        bodyLbl.Size = UDim2.new(1, -22, 0, 16)
        bodyLbl.Position = UDim2.new(0, 16, 0, 29)
        bodyLbl.BackgroundTransparency = 1
        bodyLbl.Text = tostring(text)
        bodyLbl.Font = Enum.Font.GothamMedium
        bodyLbl.TextSize = 11
        bodyLbl.TextColor3 = COLORS.DIM
        bodyLbl.TextXAlignment = Enum.TextXAlignment.Left
        bodyLbl.TextTransparency = 1
        local ti = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        TweenService:Create(frame, ti, { BackgroundTransparency = 0.05 }):Play()
        TweenService:Create(stroke, ti, { Transparency = 0.3 }):Play()
        TweenService:Create(accentBar, ti, { BackgroundTransparency = 0 }):Play()
        TweenService:Create(titleLbl, ti, { TextTransparency = 0 }):Play()
        TweenService:Create(bodyLbl, ti, { TextTransparency = 0 }):Play()
        task.delay(duration or 2.5, function()
            if not gui.Parent then return end
            local ti2 = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
            TweenService:Create(frame, ti2, { BackgroundTransparency = 1 }):Play()
            TweenService:Create(stroke, ti2, { Transparency = 1 }):Play()
            TweenService:Create(accentBar, ti2, { BackgroundTransparency = 1 }):Play()
            TweenService:Create(titleLbl, ti2, { TextTransparency = 1 }):Play()
            local tw = TweenService:Create(bodyLbl, ti2, { TextTransparency = 1 })
            tw:Play()
            tw.Completed:Wait()
            if gui.Parent then
                gui:Destroy()
            end
        end)
    end)
end

local function playAlert()
    if not settings.alertSound then return end
    pcall(function()
        local sound = Instance.new("Sound")
        sound.SoundId = settings.alertSoundId or "rbxassetid://6518811702"
        sound.Volume = 0.5
        sound.Parent = getHui()
        sound:Play()
        game:GetService("Debris"):AddItem(sound, 4)
    end)
end

local AnimalData = {}
local MutationData = {}
local TraitData = {}
local RarityData = {}
local GameData = nil
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SharedAnimals = nil
local Synchronizer = nil

pcall(function()
    local Animals = require(ReplicatedStorage.Datas.Animals)
    for k, v in pairs(Animals) do
        AnimalData[k] = v
    end
end)

pcall(function()
    local Mutations = require(ReplicatedStorage.Datas.Mutations)
    for k, v in pairs(Mutations) do
        MutationData[k] = v
    end
end)

pcall(function()
    local Traits = require(ReplicatedStorage.Datas.Traits)
    for k, v in pairs(Traits) do
        TraitData[k] = v
    end
end)

pcall(function()
    local Rarities = require(ReplicatedStorage.Datas.Rarities)
    for k, v in pairs(Rarities) do
        RarityData[k] = v
    end
end)

pcall(function()
    GameData = require(ReplicatedStorage.Datas.Game)
end)

pcall(function()
    SharedAnimals = require(ReplicatedStorage.Shared.Animals)
end)

pcall(function()
    Synchronizer = require(ReplicatedStorage.Packages.Synchronizer)
end)

local function calcGeneration(index, mutation, traits)
    local animal = AnimalData[index]
    if not animal then return 0 end
    local gen = animal.Generation
    if not gen then
        gen = animal.Price * (GameData and GameData.Game and GameData.Game.AnimalGanerationModifier or 0)
    end
    local mult = 1
    local sleepy = false
    if traits then
        for _, t in pairs(traits) do
            local trait = TraitData[t]
            if trait then
                if t ~= "Sleepy" then
                    mult += trait.MultiplierModifier or 0
                else
                    sleepy = true
                end
            end
        end
    end
    local mutMult = 1
    if mutation and MutationData[mutation] then
        mutMult = 1 + (MutationData[mutation].Modifier or 0)
    end
    local total = gen * mutMult * mult
    if sleepy then
        total *= 0.5
    end
    return math.round(total)
end

local function formatNumber(n)
    n = tonumber(n) or 0
    if n >= 1e12 then return string.format("%.1fT", n / 1e12) end
    if n >= 1e9 then return string.format("%.1fB", n / 1e9) end
    if n >= 1e6 then return string.format("%.1fM", n / 1e6) end
    if n >= 1e3 then return string.format("%.1fK", n / 1e3) end
    return tostring(math.floor(n))
end

local function findPlot(playerName)
    local plots = workspace:FindFirstChild("Plots")
    if not plots then return nil end
    for _, child in ipairs(plots:GetChildren()) do
        local ok, result = pcall(function()
            return Synchronizer:GetTableFromChannel(child.Name)
        end)
        if ok and type(result) == "table" and result.Owner then
            local ownerName = typeof(result.Owner) == "Instance" and result.Owner.Name or tostring(result.Owner)
            if ownerName == playerName then
                return child.Name, result
            end
        end
    end
    return nil
end

local function getSecretTraders()
    local results = {}
    local plots = workspace:FindFirstChild("Plots")
    if not plots then return results end
    local secretRarities = { Secret = true, OG = true }
    for _, child in ipairs(plots:GetChildren()) do
        local ok, result = pcall(function()
            return Synchronizer:GetTableFromChannel(child.Name)
        end)
        if ok and type(result) == "table" and type(result.AnimalList) == "table" then
            local owner = result.Owner
            local name = typeof(owner) == "Instance" and owner.Name or tostring(owner)
            if name ~= LocalPlayer.Name and name ~= LocalPlayer.DisplayName then
                for _, animal in ipairs(result.AnimalList) do
                    local data = AnimalData[animal.Index]
                    if data and secretRarities[tostring(data.Rarity)] then
                        table.insert(results, {
                            player = name,
                            playerObj = typeof(owner) == "Instance" and owner or Players:FindFirstChild(name),
                            index = animal.Index,
                            mutation = animal.Mutation and animal.Mutation ~= "None" and animal.Mutation or nil,
                            gen = calcGeneration(animal.Index, animal.Mutation, animal.Traits),
                            uuid = animal.UUID,
                            rarity = tostring(data.Rarity),
                        })
                    end
                end
            end
        end
    end
    table.sort(results, function(a, b) return a.gen > b.gen end)
    return results
end

local function groupTraders()
    local flat = getSecretTraders()
    local grouped = {}
    for _, item in ipairs(flat) do
        local entry = grouped[item.player]
        if not entry then
            entry = { player = item.player, playerObj = item.playerObj, items = {}, topGen = 0, totalGen = 0 }
            grouped[item.player] = entry
        end
        table.insert(entry.items, item)
        if entry.topGen < item.gen then entry.topGen = item.gen end
        entry.totalGen += item.gen
    end
    local list = {}
    for _, entry in pairs(grouped) do
        table.sort(entry.items, function(a, b) return a.gen > b.gen end)
        table.insert(list, entry)
    end
    table.sort(list, function(a, b) return a.totalGen > b.totalGen end)
    return list
end

local function getPriorityInServer()
    if not settings.priorityList or #settings.priorityList == 0 then return nil end
    local set = {}
    for _, v in ipairs(settings.priorityList) do
        set[tostring(v):lower()] = true
    end
    local plots = workspace:FindFirstChild("Plots")
    if not plots then return nil end
    for _, child in ipairs(plots:GetChildren()) do
        local ok, result = pcall(function()
            return Synchronizer:GetTableFromChannel(child.Name)
        end)
        if ok and type(result) == "table" and type(result.AnimalList) == "table" then
            for _, animal in ipairs(result.AnimalList) do
                if type(animal) == "table" and animal.Index and animal.Index ~= "Empty" then
                    if set[tostring(animal.Index):lower()] then
                        return typeof(result.Owner) == "Instance" and result.Owner.Name or tostring(result.Owner), animal.Index
                    end
                end
            end
        end
    end
    return nil
end

local function getPlaceIdForTier(tier)
    local serverData = nil
    pcall(function()
        serverData = require(ReplicatedStorage.Datas.ServerData)
    end)
    if not serverData then return game.PlaceId end
    if tier == "Pro" then return serverData.TradePlazaProPlaceId end
    if tier == "OG" then return serverData.TradePlazaOgPlaceId end
    return serverData.TradePlazaPlaceId
end

local function getServerList()
    local list = {}
    local pg = LocalPlayer:FindFirstChild("PlayerGui")
    pg = pg and pg:FindFirstChild("TradePlazaServerBrowser")
    local container = pg and pg:FindFirstChild("ScrollingFrame", true)
    if not container then return list end
    for _, child in ipairs(container:GetChildren()) do
        if child:IsA("GuiObject") and #child.Name >= 28 then
            local name = child.Name
            local hopped = hopData.hoppedServers[name]
            local skip = false
            if hopped then
                skip = os.time() - hopped < 600
            end
            if name ~= tostring(game.JobId) and not skip then
                local players = 0
                local maxPlayers = 28
                local txt = child:FindFirstChild("Players")
                if txt then
                    players = tonumber(txt.Text:match("(%d+)")) or 0
                    maxPlayers = tonumber(txt.Text:match("/(%d+)")) or 28
                end
                table.insert(list, { jobId = name, players = players, maxPlayers = maxPlayers })
            end
        end
    end
    return list
end

local function hopServer(tier)
    tier = tier or settings.hopTier or "Normal"
    local placeId = getPlaceIdForTier(tier)
    if not placeId or placeId == 0 then
        notify("HOP FAILED", tier .. " tier unavailable")
        return false
    end
    pcall(function()
        hopData.hoppedServers[tostring(game.JobId)] = os.time()
    end)
    saveHops()
    local servers = getServerList()
    if #servers > 0 then
        table.sort(servers, function(a, b) return a.players < b.players end)
        for _, srv in ipairs(servers) do
            if srv.players < srv.maxPlayers then
                notify("HOPPING", "joining a new server...", 3)
                if pcall(function()
                    TeleportService:TeleportToPlaceInstance(placeId, srv.jobId, LocalPlayer)
                end) then
                    return true
                end
                hopData.hoppedServers[srv.jobId] = os.time()
            end
        end
        saveHops()
    end
    notify("HOPPING", "joining a new " .. tier .. " server...", 3)
    local ok, err = pcall(function()
        TeleportService:Teleport(placeId, LocalPlayer)
    end)
    if not ok then
        notify("HOP FAILED", tostring(err):sub(1, 60))
        return false
    end
    return true
end

local function sendTradeRequest(target, callback)
    callback = callback or function() end
    local function findPrompt(playerName)
        local plots = workspace:FindFirstChild("Plots")
        if not plots then return nil end
        for _, child in ipairs(plots:GetChildren()) do
            local ok, result = pcall(function()
                return Synchronizer:GetTableFromChannel(child.Name)
            end)
            if ok and type(result) == "table" and result.Owner then
                local ownerName = typeof(result.Owner) == "Instance" and result.Owner.Name or tostring(result.Owner)
                if ownerName == playerName then
                    for _, d in ipairs(child:GetDescendants()) do
                        if d:IsA("ProximityPrompt") and d.ActionText == "SEND TRADE" then
                            return d
                        end
                    end
                end
            end
        end
        return nil
    end
    local name = typeof(target) == "Instance" and target.Name or type(target) == "table" and target.Name or tostring(target)
    local prompt = findPrompt(name)
    if not prompt then return callback("error", "not in server") end
    if not prompt.Enabled then return callback("error", "unavailable") end
    if type(fireproximityprompt) ~= "function" then
        return callback("no_remote", "executor missing fireproximityprompt")
    end
    if not pcall(function() fireproximityprompt(prompt) end) then
        return callback("error", "failed")
    end
    local done = false
    local function watchNotification(timeout, cb)
        local pg = LocalPlayer:FindFirstChild("PlayerGui")
        pg = pg and pg:FindFirstChild("Notification")
        pg = pg and pg:FindFirstChild("Notification")
        if not pg then return cb(nil) end
        local found = false
        local conn
        local function check(lbl)
            if found or not lbl:IsA("TextLabel") then return end
            local text = lbl.Text
            if type(text) ~= "string" then return end
            local clean = (tostring(text):gsub("<[^>]+>", ""))
            if #clean > 1 and clean ~= "Notification" then
                found = true
                if conn then conn:Disconnect() end
                cb(clean)
            end
        end
        conn = pg.ChildAdded:Connect(function(child)
            task.wait(0.1)
            check(child)
        end)
        task.delay(timeout, function()
            if not found then
                found = true
                if conn then conn:Disconnect() end
                cb(nil)
            end
        end)
    end
    watchNotification(1.5, function(msg)
        if done then return end
        done = true
        if not msg then return callback("no_response", nil) end
        local lower = msg:lower()
        if lower:find("request sent") or lower:find("sent to") or lower:find("trade") then
            callback("sent", nil)
        else
            callback("error", msg)
        end
    end)
end

local function sendChatMessage(text)
    if not text or text == "" then return false end
    local pg = LocalPlayer:FindFirstChild("PlayerGui")
    if not pg then return false end
    local chat = pg:FindFirstChild("Chat")
    chat = chat and chat:FindFirstChild("Chat")
    chat = chat and chat:FindFirstChild("Chat")
    local box = nil
    for _, name in ipairs({ "NormalChat", "RestrictedChat" }) do
        local cb = chat and chat:FindFirstChild(name)
        cb = cb and cb:FindFirstChild("ChatBox")
        cb = cb and cb:FindFirstChildWhichIsA("TextBox")
        if cb then box = cb break end
    end
    if not box then return false end
    return (pcall(function()
        box.Text = text
        if type(firesignal) == "function" then
            firesignal(box.FocusLost, true, Enum.KeyCode.Return)
        else
            box:CaptureFocus()
            local vim = game:GetService("VirtualInputManager")
            vim:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
            vim:SendKeyEvent(false, Enum.KeyCode.Return, true, game)
        end
    end))
end

local function translateText(text, targetLang, sourceLang, noCache)
    if not text or text == "" or not request_ then return text end
    sourceLang = sourceLang or "auto"
    local baseUrl = "https://aigjenuuzqbsuqvxvomm.supabase.co/functions/v1/translate"
    if baseUrl:find("YOUR%-WORKER") or baseUrl:find("YOUR%-PROJECT") then
        local url = ("https://clients5.google.com/translate_a/t?client=dict-chrome-ex&sl=%s&tl=%s&q=%s"):format(sourceLang, targetLang, HttpService:UrlEncode(text))
        local ok, result = pcall(function()
            return request_({ Url = url, Method = "GET", Headers = { ["User-Agent"] = "Mozilla/5.0" } })
        end)
        if not ok or not result then return text end
        local body = result.Body or result.body
        if not body then return text end
        local ok2, data = pcall(function() return HttpService:JSONDecode(body) end)
        if not ok2 or type(data) ~= "table" then return text end
        local t = data[1]
        if type(t) == "table" then
            text = type(t[1]) == "string" and t[1] ~= "" and t[1] or text
            return text, type(t[2]) == "string" and t[2] or sourceLang
        end
        if type(t) == "string" then return t, sourceLang end
        return text, sourceLang
    end
    local url = baseUrl:gsub("/+$", "")
    local body = HttpService:JSONEncode({ q = text, sl = sourceLang, tl = targetLang, rm = noCache and "1" or "0" })
    local ok, result = pcall(function()
        return request_({ Url = url, Method = "POST", Headers = { ["Content-Type"] = "application/json" }, Body = body })
    end)
    if not ok or not result then return text, sourceLang end
    local respBody = result.Body or result.body
    if not respBody then return text, sourceLang end
    local ok2, data = pcall(function() return HttpService:JSONDecode(respBody) end)
    if not ok2 or type(data) ~= "table" or not data.t then return text, sourceLang end
    return data.t, data.d or sourceLang
end

local function translateRealtime(text, targetLang, sourceLang)
    return translateText(text, targetLang, sourceLang, true)
end

local function getTradePartner()
    local pg = LocalPlayer:FindFirstChild("PlayerGui")
    if not pg then return nil end
    local tlt = pg:FindFirstChild("TradeLiveTrade")
    if not tlt then return nil end
    local inner = tlt:FindFirstChild("TradeLiveTrade")
    inner = inner and inner:FindFirstChild("Other")
    inner = inner and inner:FindFirstChild("Username")
    if inner and inner:IsA("TextLabel") then
        return tostring(inner.Text):match("@([%w_]+)")
    end
    return nil
end

local function getNotificationText(timeout, callback)
    local pg = LocalPlayer:FindFirstChild("PlayerGui")
    pg = pg and pg:FindFirstChild("Notification")
    pg = pg and pg:FindFirstChild("Notification")
    if not pg then callback(nil) return end
    local done = false
    local conn
    local function check(lbl)
        if done or not lbl:IsA("TextLabel") then return end
        local text = lbl.Text
        if type(text) ~= "string" then return end
        local clean = (tostring(text):gsub("<[^>]+>", ""))
        if #clean > 1 and clean ~= "Notification" then
            done = true
            if conn then conn:Disconnect() end
            callback(clean)
        end
    end
    conn = pg.ChildAdded:Connect(function(child)
        task.wait(0.1)
        check(child)
    end)
    task.delay(timeout, function()
        if not done then
            done = true
            if conn then conn:Disconnect() end
            callback(nil)
        end
    end)
end

local ESP = {
    owner = nil,
    hl = nil,
    beam = nil,
    att0 = nil,
    att1 = nil,
    conn = nil,
}

local function clearESP()
    if ESP.conn then ESP.conn:Disconnect() ESP.conn = nil end
    for _, k in ipairs({ "hl", "beam", "att0", "att1" }) do
        if ESP[k] then
            pcall(function() ESP[k]:Destroy() end)
            ESP[k] = nil
        end
    end
    ESP.owner = nil
end

local function beamToBase(owner)
    if not settings.beamToBase then
        notify("BEAM", "enable Beam to base in settings")
        return false
    end
    if ESP.owner == owner then
        clearESP()
        return false
    end
    clearESP()
    local plotName = findPlot(owner)
    local plots = workspace:FindFirstChild("Plots")
    local plot = plots and plotName and plots:FindFirstChild(plotName)
    if not plot then
        notify("BEAM", "base not found")
        return false
    end
    local char = LocalPlayer.Character
    char = char and char:FindFirstChild("HumanoidRootPart")
    if not char then return false end
    if setthreadidentity then pcall(setthreadidentity, 8) end
    ESP.owner = owner
    local hl = Instance.new("Highlight")
    hl.FillColor = COLORS.ACCENT
    hl.FillTransparency = 0.85
    hl.OutlineColor = COLORS.ACCENT
    hl.OutlineTransparency = 0.15
    hl.Adornee = plot
    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    hl.Parent = plot
    ESP.hl = hl
    local spawn = plot:FindFirstChild("Spawn") or plot:FindFirstChildWhichIsA("BasePart", true)
    if spawn then
        local att = Instance.new("Attachment")
        att.Parent = spawn
        att.WorldPosition = spawn.Position + Vector3.new(0, 3, 0)
        local att2 = Instance.new("Attachment")
        att2.Parent = char
        local beam = Instance.new("Beam")
        beam.Attachment0 = att
        beam.Attachment1 = att2
        beam.Color = ColorSequence.new(COLORS.ACCENT)
        beam.Width0 = 0.5
        beam.Width1 = 0.7
        beam.FaceCamera = true
        beam.LightEmission = 1
        beam.Transparency = NumberSequence.new(0.3)
        beam.Parent = att
        ESP.att0 = att
        ESP.att1 = att2
        ESP.beam = beam
    end
    ESP.conn = plot.AncestryChanged:Connect(function()
        if not plot:IsDescendantOf(workspace) then
            clearESP()
        end
    end)
    notify("BEAM", "tracking " .. owner .. "'s base", 2)
    return true
end

local function getBaseViewer(playerName)
    local plotName, data = findPlot(playerName)
    local plots = workspace:FindFirstChild("Plots")
    local plot = plots and plotName and plots:FindFirstChild(plotName)
    local animalList = {}
    if type(data) == "table" and type(data.AnimalList) == "table" then
        animalList = data.AnimalList
    end
    return plot, animalList
end

local function buildBaseViewer()
    local hui = getHui()
    pcall(function()
        local old = hui:FindFirstChild("SlicedzBaseViewer")
        if old then old:Destroy() end
    end)
    local gui = Instance.new("ScreenGui")
    gui.Name = "SlicedzBaseViewer"
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    gui.DisplayOrder = 999998
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.Parent = hui
    local panel = Instance.new("Frame", gui)
    panel.Name = "BasePanel"
    panel.Size = UDim2.fromOffset(680, 620)
    panel.AnchorPoint = Vector2.new(0.5, 0.5)
    panel.Position = UDim2.fromScale(0.5, 0.5)
    panel.BackgroundColor3 = COLORS.BG
    panel.BorderSizePixel = 0
    panel.Visible = false
    panel.ZIndex = 60
    createCorner(panel, 16)
    createStroke(panel, COLORS.STROKE, 1.4, 0.38)
    createImageLabel(panel)
    local header = Instance.new("Frame", panel)
    header.Size = UDim2.new(1, 0, 0, 44)
    header.BackgroundTransparency = 1
    header.ZIndex = 61
    local title = Instance.new("TextLabel", header)
    title.Size = UDim2.new(1, -56, 0, 30)
    title.Position = UDim2.fromOffset(18, 12)
    title.BackgroundTransparency = 1
    title.Font = Enum.Font.GothamBlack
    title.Text = "THEIR BASE"
    title.TextSize = 16
    title.TextColor3 = COLORS.TEXT
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.ZIndex = 61
    local bar = Instance.new("Frame", header)
    bar.Position = UDim2.fromOffset(18, 40)
    bar.Size = UDim2.fromOffset(130, 3)
    bar.BackgroundColor3 = COLORS.ACCENT
    bar.BorderSizePixel = 0
    bar.ZIndex = 61
    createCorner(bar, 1)
    local closeBtn = createButton(header, "X", { color = COLORS.SURF2, press = COLORS.ACCENT2, stroke = COLORS.STROKE, strokeT = 0.5, textSize = 13 })
    closeBtn.Size = UDim2.fromOffset(36, 36)
    closeBtn.Position = UDim2.new(1, -46, 0, 8)
    closeBtn.ZIndex = 61
    closeBtn.MouseButton1Click:Connect(function()
        panel.Visible = false
    end)
    local viewportFrame = Instance.new("ViewportFrame", panel)
    viewportFrame.Size = UDim2.new(1, -28, 1, -104)
    viewportFrame.Position = UDim2.fromOffset(14, 52)
    viewportFrame.BackgroundColor3 = Color3.fromRGB(160, 205, 245)
    viewportFrame.BorderSizePixel = 0
    viewportFrame.ClipsDescendants = true
    viewportFrame.ZIndex = 61
    createCorner(viewportFrame, 12)
    createStroke(viewportFrame, COLORS.STROKE, 1, 0.5)
    local gradient = Instance.new("UIGradient", viewportFrame)
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(135, 190, 240)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(205, 230, 250)),
    })
    gradient.Rotation = 90
    local worldModel = Instance.new("WorldModel")
    worldModel.Parent = viewportFrame
    local camera = Instance.new("Camera", viewportFrame)
    viewportFrame.CurrentCamera = camera
    local overlay = Instance.new("Frame", viewportFrame)
    overlay.Size = UDim2.fromScale(1, 1)
    overlay.BackgroundTransparency = 1
    overlay.ZIndex = 63
    overlay.ClipsDescendants = true
    local floorLabel = Instance.new("TextLabel", viewportFrame)
    floorLabel.Size = UDim2.fromOffset(90, 30)
    floorLabel.Position = UDim2.fromOffset(14, 14)
    floorLabel.BackgroundColor3 = Color3.fromRGB(18, 10, 12)
    floorLabel.BackgroundTransparency = 0.25
    floorLabel.Font = Enum.Font.GothamBlack
    floorLabel.Text = "FLOOR 1"
    floorLabel.TextSize = 17
    floorLabel.TextColor3 = COLORS.TEXT
    floorLabel.ZIndex = 62
    createCorner(floorLabel, 8)
    createStroke(floorLabel, COLORS.ACCENT, 0.5, 0.3)
    local infoLabel = Instance.new("TextLabel", viewportFrame)
    infoLabel.Size = UDim2.new(1, -20, 0, 22)
    infoLabel.Position = UDim2.new(0, 10, 1, -26)
    infoLabel.BackgroundTransparency = 1
    infoLabel.Font = Enum.Font.GothamBold
    infoLabel.Text = ""
    infoLabel.TextSize = 12
    infoLabel.TextColor3 = COLORS.TEXT
    infoLabel.ZIndex = 62
    return {
        gui = gui,
        panel = panel,
        viewport = viewportFrame,
        worldModel = worldModel,
        camera = camera,
        overlay = overlay,
        floorLabel = floorLabel,
        infoLabel = infoLabel,
    }
end

local baseViewer = buildBaseViewer()

local function buildBaseFloor(floor, animalList)
    local oldModel = baseViewer.worldModel
    baseViewer.worldModel = Instance.new("WorldModel")
    local model = baseViewer.worldModel
    local floorParts = {
        [1] = {
            { size = Vector3.new(45, 2, 16), pos = Vector3.new(-14.95, -5.51, -37.32), rot = CFrame.Angles(0, -1.5707963267948966, 0) },
            { size = Vector3.new(45, 1, 16), pos = Vector3.new(14.05, -5.51, -37.32), rot = CFrame.Angles(0, -1.5707963267948966, 0) },
            { size = Vector3.new(10, 11, 1), pos = Vector3.new(-0.45, -6.01, -12.32), rot = CFrame.Angles(1.5707963267948966, 0, -1.5707963267948966), carpet = true },
            { size = Vector3.new(48, 14, 2), pos = Vector3.new(-0.45, -5.51, -35.82), rot = CFrame.Angles(1.5707963267948966, 0, -1.5707963267948966), carpet = true },
            { size = Vector3.new(50, 1, 2), pos = Vector3.new(-6.45, -5.51, -36.82), rot = CFrame.Angles(1.5707963267948966, 0, -1.5707963267948966), studFloor = true },
            { size = Vector3.new(50, 1, 16), pos = Vector3.new(5.55, -5.51, -36.82), rot = CFrame.Angles(1.5707963267948966, 0, -1.5707963267948966), studFloor = true },
        },
        [2] = {
            { size = Vector3.new(45, 45, 2), pos = Vector3.new(-0.45, 12.49, -37.32), rot = CFrame.Angles(1.5707963267948966, 0, -1.5707963267948966) },
        },
        [3] = {
            { size = Vector3.new(45, 17, 2), pos = Vector3.new(-14.45, 29.49, -37.32), rot = CFrame.Angles(1.5707963267948966, 0, -1.5707963267948966) },
            { size = Vector3.new(45, 12, 2), pos = Vector3.new(13.55, 29.49, -37.32), rot = CFrame.Angles(1.5707963267948966, 0, -1.5707963267948966) },
            { size = Vector3.new(31, 14, 2), pos = Vector3.new(-0.45, 29.49, -30.32), rot = CFrame.Angles(1.5707963267948966, 0, -1.5707963267948966) },
        },
    }
    local yOff = ({ -2.509, 15.491, 32.491 })[floor] or 0
    for _, part in ipairs(floorParts[floor] or {}) do
        local p = Instance.new("Part")
        p.Anchored = true
        p.CanCollide = false
        p.CanQuery = false
        p.CanTouch = false
        p.CastShadow = false
        p.Material = Enum.Material.SmoothPlastic
        p.Color = part.carpet and Color3.fromRGB(196, 35, 28) or part.studFloor and Color3.fromRGB(91, 93, 105) or Color3.fromRGB(99, 95, 98)
        p.Size = part.size
        p.CFrame = CFrame.new(part.pos.X, part.pos.Y - yOff, part.pos.Z) * part.rot
        p.Parent = model
    end
    local slotPositions = {
        { -18.954, -2.509, -21.346, -90 },
        { -18.954, -2.509, -28.846, -90 },
        { -18.954, -2.509, -36.346, -90 },
        { -18.954, -2.509, -43.846, -90 },
        { -18.954, -2.509, -51.346, -90 },
        { 18.081, -2.509, -51.346, 90 },
        { 18.081, -2.509, -43.846, 90 },
        { 18.081, -2.509, -36.346, 90 },
        { 18.081, -2.509, -28.846, 90 },
        { 18.081, -2.509, -21.346, 90 },
        { -18.954, 15.491, -21.346, -90 },
        { -18.954, 15.491, -28.846, -90 },
        { -18.954, 15.491, -36.346, -90 },
        { -18.954, 15.491, -43.846, -90 },
        { -18.954, 15.491, -51.346, -90 },
        { 17.926, 15.491, -21.37, 90 },
        { 18.081, 15.491, -28.87, 90 },
        { 18.081, 15.491, -36.37, 90 },
        { -18.954, 32.491, -23.346, -90 },
        { -18.954, 32.491, -30.846, -90 },
        { -18.954, 32.491, -38.346, -90 },
        { -18.954, 32.491, -45.846, -90 },
        { -18.954, 32.491, -53.346, -90 },
        { 18.017, 32.491, -23.321, 90 },
        { 18.017, 32.491, -30.821, 90 },
        { 18.017, 32.491, -38.321, 90 },
        { 18.017, 32.491, -45.821, 90 },
        { 18.017, 32.491, -53.321, 90 },
    }
    local labels = {}
    for i = 1, 28 do
        local startIdx = (floor - 1) * 10 + 1
        local endIdx = floor * 10
        if floor == 2 then startIdx = 11 endIdx = 18 end
        if floor == 3 then startIdx = 19 endIdx = 28 end
        if i >= startIdx and i <= endIdx then
            local slot = slotPositions[i]
            if slot then
                local cframe = CFrame.new(slot[1], slot[2] - yOff, slot[3]) * CFrame.Angles(0, math.rad(slot[4]), 0)
                for _, pad in ipairs({
                    { size = Vector3.new(4, 0.25, 4), color = Color3.fromRGB(104, 108, 121), yOff = -0.125, top = Enum.SurfaceType.Smooth },
                    { size = Vector3.new(6, 1, 6), color = Color3.fromRGB(69, 69, 68), yOff = -1.88, top = Enum.SurfaceType.Studs },
                }) do
                    local p = Instance.new("Part")
                    p.Anchored = true
                    p.CanCollide = false
                    p.CanQuery = false
                    p.CanTouch = false
                    p.CastShadow = false
                    p.Material = Enum.Material.Plastic
                    p.Size = pad.size
                    p.Color = pad.color
                    p.TopSurface = pad.top
                    p.CFrame = cframe * CFrame.new(0, pad.yOff, 0)
                    p.Parent = model
                end
                table.insert(labels, { world = (cframe * CFrame.new(0, 2.5, 0)).Position, kind = "slot", text = tostring(i) })
                local animal = animalList[i]
                local isEmpty = animal == "Empty" or type(animal) == "table" and animal.Index == "Empty" or type(animal) ~= "table"
                if animal and not isEmpty then
                    local index = animal.Index
                    local mutation = animal.Mutation and animal.Mutation ~= "None" and animal.Mutation ~= "" and animal.Mutation or nil
                    local model2 = nil
                    if SharedAnimals and SharedAnimals.GetAnimatedModel then
                        local ok, result = pcall(function()
                            return SharedAnimals:GetAnimatedModel(index, mutation, animal.Traits or {})
                        end)
                        if ok and typeof(result) == "Instance" then
                            model2 = result
                        end
                    end
                    if not model2 then
                        local cached = baseViewer.worldModel:FindFirstChild(index)
                        if cached then model2 = cached:Clone() end
                    end
                    if model2 then
                        for _, d in ipairs(model2:GetDescendants()) do
                            if d:IsA("Script") or d:IsA("LocalScript") then d:Destroy() end
                        end
                        local pivot = cframe * CFrame.new(0, -1.5, 0)
                        for _, d in ipairs(model2:GetDescendants()) do
                            if d:IsA("BasePart") then d.Anchored = true end
                        end
                        pcall(function() model2:PivotTo(pivot) end)
                        model2.Parent = model
                        local animalData = AnimalData[index]
                        local rarity = animalData and tostring(animalData.Rarity) or nil
                        local rarityInfo = rarity and RarityData[rarity]
                        local color = rarityInfo and rarityInfo.Color or Color3.new(1, 1, 1)
                        table.insert(labels, {
                            track = model2,
                            trackYOffset = 3,
                            world = (pivot * CFrame.new(0, 3, 0)).Position,
                            kind = "overhead",
                            name = index,
                            gen = "$" .. formatNumber(calcGeneration(index, mutation, animal.Traits)) .. "/s",
                            mutation = mutation,
                            rarity = rarity,
                            rarityColor = color,
                            index = index,
                            traits = animal.Traits,
                        })
                    end
                end
            end
        end
    end
    model.Parent = baseViewer.viewport
    if oldModel then
        pcall(function() oldModel:Destroy() end)
    end
    baseViewer.floorLabel.Text = "FLOOR " .. floor
    baseViewer.labels = labels
    return labels
end

local function renderBaseLabels()
    if not baseViewer.panel.Visible then return end
    local labels = baseViewer.labels or {}
    local overlay = baseViewer.overlay
    local camera = baseViewer.camera
    if not camera then return end
    for _, child in ipairs(overlay:GetChildren()) do
        if child:IsA("Frame") then child:Destroy() end
    end
    local viewportSize = baseViewer.viewport.AbsoluteSize
    local camCFrame = camera.CFrame
    local fov = camera.FieldOfView
    for _, label in ipairs(labels) do
        local worldPos = label.world
        if label.track and label.track.Parent then
            local ok, pivot = pcall(function() return label.track:GetPivot() end)
            if ok then
                worldPos = (pivot * CFrame.new(0, label.trackYOffset or 0, 0)).Position
            end
        end
        local screenPos, depth = nil, nil
        do
            local objSpace = camCFrame:PointToObjectSpace(worldPos)
            if objSpace.Z < 0 then
                local aspect = viewportSize.X / viewportSize.Y
                local tan = math.tan(math.rad(fov) / 2)
                screenPos = Vector2.new((objSpace.X / -objSpace.Z / tan * aspect * 0.5 + 0.5) * viewportSize.X, (1 - objSpace.Y / -objSpace.Z / tan * 0.5 + 0.5) * viewportSize.Y)
                depth = -objSpace.Z
            end
        end
        if screenPos and depth then
            local frame = Instance.new("Frame", overlay)
            frame.BackgroundTransparency = 1
            frame.ZIndex = 63
            frame.AnchorPoint = Vector2.new(0.5, 1)
            if label.kind == "slot" then
                frame.Size = UDim2.fromOffset(34, 30)
                frame.Position = UDim2.fromOffset(screenPos.X, screenPos.Y)
                local inner = Instance.new("Frame", frame)
                inner.Size = UDim2.fromScale(1, 1)
                inner.BackgroundColor3 = Color3.fromRGB(10, 10, 12)
                inner.BackgroundTransparency = 0.4
                inner.BorderSizePixel = 0
                inner.ZIndex = 63
                createCorner(inner, 8)
                local stroke = Instance.new("UIStroke", inner)
                stroke.Color = COLORS.ACCENT
                stroke.Thickness = 2
                stroke.Transparency = 0.4
                local txt = Instance.new("TextLabel", inner)
                txt.Size = UDim2.fromScale(1, 1)
                txt.BackgroundTransparency = 1
                txt.Text = label.text
                txt.Font = Enum.Font.GothamBlack
                txt.TextSize = 15
                txt.TextColor3 = Color3.new(1, 1, 1)
                txt.ZIndex = 64
            else
                frame.Size = UDim2.fromOffset(150, 66)
                frame.Position = UDim2.fromOffset(screenPos.X, screenPos.Y)
                local layout = Instance.new("UIListLayout", frame)
                layout.SortOrder = Enum.SortOrder.LayoutOrder
                layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
                layout.VerticalAlignment = Enum.VerticalAlignment.Bottom
                local function addText(text, order, size, color)
                    local tl = Instance.new("TextLabel", frame)
                    tl.Size = UDim2.new(1, 0, 0, size or 14)
                    tl.BackgroundTransparency = 1
                    tl.Font = Enum.Font.GothamBold
                    tl.Text = text
                    tl.TextSize = size or 14
                    tl.TextColor3 = color or Color3.new(1, 1, 1)
                    tl.LayoutOrder = order
                    Instance.new("UIStroke", tl)
                end
                if label.mutation then addText(label.mutation, 0, 13, COLORS.ACCENT) end
                addText(label.name, 1, 15, Color3.new(0, 1, 1))
                if label.rarity then addText(label.rarity, 2, 13, label.rarityColor or Color3.new(1, 0, 0)) end
                addText(label.gen, 3, 14, Color3.fromRGB(255, 247, 0))
            end
        end
    end
end

local function showBaseViewer(playerName)
    local plot, animalList = getBaseViewer(playerName)
    if not plot then
        notify("BASE", "base not found")
        return
    end
    local floorsPresent = {}
    local podiums = plot:FindFirstChild("AnimalPodiums")
    if podiums then
        for _, child in ipairs(podiums:GetChildren()) do
            local num = tonumber(child.Name)
            if num then
                floorsPresent[num <= 10 and 1 or num <= 18 and 2 or 3] = true
            end
        end
    end
    for i = 1, 28 do
        local animal = animalList[i]
        if type(animal) == "table" and animal.Index and animal.Index ~= "Empty" then
            floorsPresent[i <= 10 and 1 or i <= 18 and 2 or 3] = true
        end
    end
    local present = {}
    for i = 1, 3 do
        if floorsPresent[i] then table.insert(present, i) end
    end
    local selected = present[1] or 1
    baseViewer.currentFloor = selected
    baseViewer.currentAnimalList = animalList
    baseViewer.presentFloors = present
    baseViewer.viewport.Visible = true
    baseViewer.panel.Visible = true
    baseViewer.camera.CFrame = CFrame.lookAt(Vector3.new(0, 31, 10), Vector3.new(0, 4, -37))
    baseViewer.camera.FieldOfView = 60
    buildBaseFloor(selected, animalList)
    renderBaseLabels()
end

local function createTabButton(parent, id, text, order)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(0.25, -3, 1, 0)
    btn.LayoutOrder = order
    btn.AutoButtonColor = false
    btn.BackgroundColor3 = COLORS.SURF
    btn.Text = text
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 10
    btn.TextColor3 = COLORS.OFF_TEXT
    btn.ZIndex = 3
    createCorner(btn, 8)
    return btn
end

local function buildUI()
    local hui = getHui()
    pcall(function()
        local old = hui:FindFirstChild("SlicedzConvincer")
        if old then old:Destroy() end
    end)
    pcall(function()
        local pg = LocalPlayer:FindFirstChildOfClass("PlayerGui")
        local old = pg and pg:FindFirstChild("SlicedzBaseViewer")
        if old then old:Destroy() end
    end)
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "SlicedzConvincer"
    screenGui.ResetOnSpawn = false
    screenGui.IgnoreGuiInset = true
    screenGui.DisplayOrder = 999999
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.Parent = hui
    local main = Instance.new("Frame", screenGui)
    main.Size = UDim2.fromOffset(370, 510)
    main.Position = UDim2.new(settings.pos.x, 0, settings.pos.y, 0)
    main.BackgroundColor3 = COLORS.BG
    main.BorderSizePixel = 0
    createCorner(main, 16)
    createStroke(main, COLORS.STROKE, 1.4, 0.38)
    createImageLabel(main)
    local grad = Instance.new("UIGradient", main)
    grad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(40, 20, 28)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(24, 12, 13)),
    })
    grad.Rotation = 90
    local header = Instance.new("Frame", main)
    header.Size = UDim2.new(1, 0, 0, 48)
    header.BackgroundTransparency = 1
    header.ZIndex = 2
    local dot = Instance.new("Frame", header)
    dot.Size = UDim2.fromOffset(8, 8)
    dot.Position = UDim2.fromOffset(16, 20)
    dot.BackgroundColor3 = COLORS.ACCENT
    dot.BorderSizePixel = 0
    createCorner(dot, 4)
    dot.ZIndex = 2
    local title = Instance.new("TextLabel", header)
    title.Size = UDim2.new(1, -60, 0, 26)
    title.Position = UDim2.fromOffset(32, 12)
    title.BackgroundTransparency = 1
    title.Font = Enum.Font.GothamBlack
    title.Text = "SLICEDZ CONVINCER"
    title.TextSize = 17
    title.TextColor3 = COLORS.TEXT
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.ZIndex = 2
    local underline = Instance.new("Frame", header)
    underline.Position = UDim2.fromOffset(32, 40)
    underline.Size = UDim2.fromOffset(160, 2)
    underline.BackgroundColor3 = COLORS.ACCENT
    underline.BorderSizePixel = 0
    underline.ZIndex = 2
    createCorner(underline, 1)
    local dragging = false
    local dragStart = nil
    local startPos = nil
    header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = main.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                    settings.pos = { x = main.Position.X.Scale, y = main.Position.Y.Scale }
                    saveConfig()
                end
            end)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    local tabBar = Instance.new("Frame", main)
    tabBar.Size = UDim2.new(1, -24, 0, 30)
    tabBar.Position = UDim2.fromOffset(12, 54)
    tabBar.BackgroundColor3 = COLORS.SURF
    tabBar.BorderSizePixel = 0
    tabBar.ZIndex = 2
    createCorner(tabBar, 10)
    createStroke(tabBar, COLORS.STROKE, 1, 0.55)
    local tabLayout = Instance.new("UIListLayout", tabBar)
    tabLayout.FillDirection = Enum.FillDirection.Horizontal
    tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    local tabPadding = Instance.new("UIPadding", tabBar)
    tabPadding.PaddingLeft = UDim.new(0, 4)
    tabPadding.PaddingRight = UDim.new(0, 4)
    tabPadding.PaddingTop = UDim.new(0, 4)
    tabPadding.PaddingBottom = UDim.new(0, 4)
    local tabs = {}
    local pages = {}
    local function switchTab(id)
        for k, page in pairs(pages) do
            page.Visible = k == id
        end
        for k, btn in pairs(tabs) do
            tween(btn, 0.14, { BackgroundColor3 = k == id and COLORS.ACCENT2 or COLORS.SURF })
            btn.TextColor3 = k == id and COLORS.TEXT or COLORS.OFF_TEXT
        end
    end
    local function addTab(id, text, order)
        local btn = createTabButton(tabBar, id, text, order)
        btn.MouseButton1Click:Connect(function() switchTab(id) end)
        tabs[id] = btn
    end
    addTab("list", "TRADERS", 1)
    addTab("chat", "TRANSLATE", 2)
    addTab("presets", "PRESETS", 3)
    addTab("settings", "SETTINGS", 4)
    local content = Instance.new("Frame", main)
    content.Size = UDim2.new(1, -24, 1, -126)
    content.Position = UDim2.fromOffset(12, 98)
    content.BackgroundTransparency = 1
    content.ZIndex = 2
    local signature = Instance.new("TextLabel", main)
    signature.Name = "SlicedzSig"
    signature.AnchorPoint = Vector2.new(0.5, 1)
    signature.Position = UDim2.new(0.5, 0, 1, -7)
    signature.Size = UDim2.new(1, -40, 0, 22)
    signature.BackgroundTransparency = 1
    signature.Font = Enum.Font.GothamBlack
    signature.Text = "discord.gg/pubmethod"
    signature.TextSize = 12
    signature.TextColor3 = Color3.new(1, 1, 1)
    signature.ZIndex = 3
    signature.TextStrokeColor3 = Color3.fromRGB(60, 10, 14)
    signature.TextStrokeTransparency = 0.35
    local sigGrad = Instance.new("UIGradient", signature)
    sigGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(230, 50, 60)),
        ColorSequenceKeypoint.new(0.4, Color3.fromRGB(255, 120, 130)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(0.6, Color3.fromRGB(230, 21, 130)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(230, 50, 60)),
    })
    task.spawn(function()
        local t0 = tick()
        while signature and signature.Parent do
            sigGrad.Offset = Vector2.new((tick() - t0) * 0.45 % 2 - 1, 0)
            task.wait()
        end
    end)
    local listPage = Instance.new("Frame", content)
    listPage.Size = UDim2.fromScale(1, 1)
    listPage.BackgroundTransparency = 1
    pages.list = listPage
    local searchBox = Instance.new("TextBox", listPage)
    searchBox.Size = UDim2.new(1, 0, 0, 30)
    searchBox.Position = UDim2.fromOffset(0, 0)
    searchBox.BackgroundColor3 = COLORS.SURF
    searchBox.Text = ""
    searchBox.PlaceholderText = "search player or brainrot…"
    searchBox.PlaceholderColor3 = COLORS.OFF_TEXT
    searchBox.Font = Enum.Font.GothamMedium
    searchBox.TextSize = 12
    searchBox.TextColor3 = COLORS.TEXT
    searchBox.TextXAlignment = Enum.TextXAlignment.Left
    searchBox.ClearTextOnFocus = false
    searchBox.ZIndex = 3
    createCorner(searchBox, 9)
    createStroke(searchBox, COLORS.STROKE, 1, 0.5)
    local searchPadding = Instance.new("UIPadding", searchBox)
    searchPadding.PaddingLeft = UDim.new(0, 10)
    searchPadding.PaddingRight = UDim.new(0, 30)
    local searchIcon = Instance.new("ImageLabel", searchBox)
    searchIcon.Size = UDim2.fromOffset(15, 15)
    searchIcon.Position = UDim2.new(1, -24, 0.5, -7)
    searchIcon.BackgroundTransparency = 1
    searchIcon.Image = "rbxassetid://3926305904"
    searchIcon.ImageRectOffset = Vector2.new(964, 324)
    searchIcon.ImageRectSize = Vector2.new(36, 36)
    searchIcon.ImageColor3 = COLORS.DIM
    searchIcon.ZIndex = 4
    local traderList = Instance.new("ScrollingFrame", listPage)
    traderList.Size = UDim2.new(1, 0, 1, -38)
    traderList.Position = UDim2.fromOffset(0, 38)
    traderList.BackgroundTransparency = 1
    traderList.BorderSizePixel = 0
    traderList.ScrollBarThickness = 4
    traderList.ScrollBarImageColor3 = COLORS.ACCENT
    traderList.CanvasSize = UDim2.new(0, 0, 0, 0)
    traderList.AutomaticCanvasSize = Enum.AutomaticSize.Y
    local listPadding = Instance.new("UIPadding", traderList)
    listPadding.PaddingLeft = UDim.new(0, 2)
    listPadding.PaddingRight = UDim.new(0, 8)
    listPadding.PaddingTop = UDim.new(0, 1)
    local listLayout = Instance.new("UIListLayout", traderList)
    listLayout.Padding = UDim.new(0, 8)
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    local searchQuery = ""
    local lastSignature = ""
    local function refreshList()
        local traders = groupTraders()
        local query = (searchQuery or ""):lower():gsub("^%s+", ""):gsub("%s+$", "")
        local filtered
        if query == "" then
            filtered = traders
        else
            filtered = {}
            for _, entry in ipairs(traders) do
                local match = entry.player:lower():find(query, 1, true) ~= nil
                if not match then
                    for _, item in ipairs(entry.items) do
                        if item.index:lower():find(query, 1, true) or item.mutation and item.mutation:lower():find(query, 1, true) or item.rarity:lower():find(query, 1, true) then
                            match = true
                            break
                        end
                    end
                end
                if match then table.insert(filtered, entry) end
            end
        end
        local sig = query .. "~"
        for _, entry in ipairs(filtered) do
            sig = sig .. entry.player .. #entry.items .. math.floor(entry.totalGen) .. "|"
        end
        if sig == lastSignature then return end
        lastSignature = sig
        for _, child in ipairs(traderList:GetChildren()) do
            if child:IsA("Frame") then child:Destroy() end
        end
        if #filtered == 0 then
            local empty = Instance.new("Frame", traderList)
            empty.Size = UDim2.new(1, 0, 0, 80)
            empty.BackgroundTransparency = 1
            local lbl = Instance.new("TextLabel", empty)
            lbl.Size = UDim2.fromScale(1, 1)
            lbl.BackgroundTransparency = 1
            lbl.Font = Enum.Font.GothamMedium
            lbl.TextSize = 12
            lbl.TextColor3 = COLORS.OFF_TEXT
            lbl.TextWrapped = true
            lbl.Text = query ~= "" and "no matches for \"" .. query .. "\"" or "no Secret/OG traders found."
            return
        end
        for i, entry in ipairs(filtered) do
            local row = Instance.new("Frame", traderList)
            row.Size = UDim2.new(1, 0, 0, 54)
            row.BackgroundTransparency = 1
            row.BorderSizePixel = 0
            row.LayoutOrder = i
            row.ClipsDescendants = true
            row.Name = "P_" .. i
            local card = Instance.new("Frame", row)
            card.Size = UDim2.new(1, -4, 0, 52)
            card.Position = UDim2.fromOffset(2, 1)
            card.BackgroundColor3 = COLORS.SURF
            card.BorderSizePixel = 0
            createCorner(card, 10)
            local cardStroke = createStroke(card, COLORS.STROKE, 1, 0.6)
            local rank = Instance.new("TextLabel", card)
            rank.Size = UDim2.fromOffset(20, 54)
            rank.Position = UDim2.fromOffset(2, 0)
            rank.BackgroundTransparency = 1
            rank.Font = Enum.Font.GothamBlack
            rank.Text = "#" .. i
            rank.TextSize = 10
            rank.TextColor3 = COLORS.ACCENT
            local nameX = 34
            if settings.showAvatars then
                local avatar = Instance.new("ImageLabel", card)
                avatar.Size = UDim2.fromOffset(36, 36)
                avatar.Position = UDim2.fromOffset(24, 8)
                avatar.BackgroundColor3 = COLORS.SURF2
                avatar.BorderSizePixel = 0
                createCorner(avatar, 18)
                avatar.ZIndex = 3
                task.spawn(function()
                    local userId = nil
                    if entry.playerObj and entry.playerObj.UserId then
                        userId = entry.playerObj.UserId
                    else
                        pcall(function() userId = Players:GetUserIdFromNameAsync(entry.player) end)
                    end
                    if userId then
                        local ok, image = pcall(function()
                            return Players:GetUserThumbnailAsync(userId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48)
                        end)
                        if ok and image and avatar.Parent then
                            avatar.Image = image
                        end
                    end
                end)
                nameX = 68
            end
            local nameLbl = Instance.new("TextLabel", card)
            nameLbl.Size = UDim2.new(1, -(nameX + 50), 0, 18)
            nameLbl.Position = UDim2.fromOffset(nameX, 8)
            nameLbl.BackgroundTransparency = 1
            nameLbl.Font = Enum.Font.GothamBold
            nameLbl.Text = entry.player
            nameLbl.TextSize = 13
            nameLbl.TextColor3 = COLORS.TEXT
            nameLbl.TextXAlignment = Enum.TextXAlignment.Left
            nameLbl.TextTruncate = Enum.TextTruncate.AtEnd
            local beamArea = Instance.new("TextButton", card)
            beamArea.Size = UDim2.new(1, -118, 1, 0)
            beamArea.Position = UDim2.fromOffset(0, 0)
            beamArea.BackgroundTransparency = 1
            beamArea.Text = ""
            beamArea.ZIndex = 1
            beamArea.AutoButtonColor = false
            local function setBeamHighlight(on)
                if cardStroke then
                    tween(cardStroke, 0.15, { Transparency = on and 0.15 or 0.6, Color = on and COLORS.ACCENT or COLORS.STROKE })
                end
            end
            setBeamHighlight(ESP and ESP.owner == entry.player)
            beamArea.MouseButton1Click:Connect(function()
                setBeamHighlight(beamToBase(entry.player))
            end)
            local infoLbl = Instance.new("TextLabel", card)
            infoLbl.Size = UDim2.new(1, -(nameX + 50), 0, 14)
            infoLbl.Position = UDim2.fromOffset(nameX, 26)
            infoLbl.BackgroundTransparency = 1
            infoLbl.Font = Enum.Font.GothamBold
            infoLbl.Text = #entry.items .. " • total $" .. formatNumber(entry.totalGen) .. "/s"
            infoLbl.TextSize = 10
            infoLbl.TextColor3 = COLORS.GREEN_STROKE
            infoLbl.TextXAlignment = Enum.TextXAlignment.Left
            local tradeBtn = createButton(card, "TRADE", { textSize = 11 })
            tradeBtn.Size = UDim2.fromOffset(62, 34)
            tradeBtn.Position = UDim2.new(1, -114, 0.5, -17)
            tradeBtn.MouseButton1Click:Connect(function()
                tradeBtn.Text = "..."
                tween(tradeBtn, 0.1, { BackgroundColor3 = COLORS.ACCENT2 })
                task.spawn(function()
                    sendTradeRequest(entry.playerObj or Players:FindFirstChild(entry.player), function(status)
                        if setthreadidentity then pcall(setthreadidentity, 8) end
                        local text, color
                        if status == "sent" then
                            text = "SENT"
                            color = Color3.fromRGB(40, 190, 110)
                        elseif status == "no_remote" then
                            text = "RETRY"
                            color = Color3.fromRGB(120, 80, 30)
                        else
                            text = "FAIL"
                            color = Color3.fromRGB(120, 40, 40)
                        end
                        pcall(function()
                            tradeBtn.Text = text
                            tween(tradeBtn, 0.1, { BackgroundColor3 = color })
                        end)
                    end)
                    task.delay(2.2, function()
                        if tradeBtn.Parent then
                            tradeBtn.Text = "TRADE"
                            tween(tradeBtn, 0.1, { BackgroundColor3 = COLORS.ACCENT })
                        end
                    end)
                end)
            end)
            local expandBtn = createButton(card, "v", { color = COLORS.SURF2, press = COLORS.ACCENT2, stroke = COLORS.STROKE, strokeT = 0.5, textSize = 13 })
            expandBtn.Size = UDim2.fromOffset(34, 34)
            expandBtn.Position = UDim2.new(1, -46, 0.5, -17)
            local itemsFrame = Instance.new("Frame", row)
            itemsFrame.Size = UDim2.new(1, 0, 0, 0)
            itemsFrame.Position = UDim2.fromOffset(0, 54)
            itemsFrame.BackgroundTransparency = 1
            itemsFrame.BorderSizePixel = 0
            itemsFrame.ClipsDescendants = true
            local itemsLayout = Instance.new("UIListLayout", itemsFrame)
            itemsLayout.Padding = UDim.new(0, 6)
            itemsLayout.SortOrder = Enum.SortOrder.LayoutOrder
            local itemsPad = Instance.new("UIPadding", itemsFrame)
            itemsPad.PaddingTop = UDim.new(0, 6)
            itemsPad.PaddingLeft = UDim.new(0, 16)
            itemsPad.PaddingRight = UDim.new(0, 2)
            for i2, item in ipairs(entry.items) do
                local itemRow = Instance.new("Frame", itemsFrame)
                itemRow.Size = UDim2.new(1, 0, 0, 42)
                itemRow.LayoutOrder = i2
                itemRow.BackgroundColor3 = COLORS.SURF2
                itemRow.BorderSizePixel = 0
                createCorner(itemRow, 8)
                createStroke(itemRow, COLORS.STROKE, 1, 0.7)
                local itemName = Instance.new("TextLabel", itemRow)
                itemName.Size = UDim2.new(1, -14, 0, 18)
                itemName.Position = UDim2.fromOffset(10, 4)
                itemName.BackgroundTransparency = 1
                itemName.Font = Enum.Font.GothamBold
                itemName.RichText = true
                local mutText = item.mutation and ("  <font color=\"#%s\">%s</font>"):format(item.mutation and MutationData[item.mutation] and MutationData[item.mutation].MainColor or "FF4444", item.mutation) or ""
                itemName.Text = item.index .. mutText
                itemName.TextSize = 12
                itemName.TextColor3 = COLORS.TEXT
                itemName.TextXAlignment = Enum.TextXAlignment.Left
                itemName.TextTruncate = Enum.TextTruncate.AtEnd
                local itemInfo = Instance.new("TextLabel", itemRow)
                itemInfo.Size = UDim2.new(1, -14, 0, 14)
                itemInfo.Position = UDim2.fromOffset(10, 24)
                itemInfo.BackgroundTransparency = 1
                itemInfo.Font = Enum.Font.GothamBold
                itemInfo.Text = "$" .. formatNumber(item.gen) .. "/s  •  " .. item.rarity
                itemInfo.TextSize = 10
                itemInfo.TextColor3 = COLORS.GREEN_STROKE
                itemInfo.TextXAlignment = Enum.TextXAlignment.Left
            end
            local itemsHeight = #entry.items * 48 + 12 + 6
            local expanded = false
            local function setExpanded(on, instant)
                expanded = on
                expandBtn.Text = on and "^" or "v"
                local h = on and itemsHeight or 0
                local rowH = 54 + h
                if instant then
                    itemsFrame.Size = UDim2.new(1, 0, 0, h)
                    row.Size = UDim2.new(1, 0, 0, rowH)
                    return
                end
                TweenService:Create(itemsFrame, TweenInfo.new(0.22, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), { Size = UDim2.new(1, 0, 0, h) }):Play()
                TweenService:Create(row, TweenInfo.new(0.22, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), { Size = UDim2.new(1, 0, 0, rowH) }):Play()
            end
            expandBtn.MouseButton1Click:Connect(function()
                setExpanded(not expanded)
            end)
            card.MouseEnter:Connect(function()
                tween(card, 0.12, { BackgroundColor3 = Color3.fromRGB(34, 14, 14) })
            end)
            card.MouseLeave:Connect(function()
                tween(card, 0.12, { BackgroundColor3 = COLORS.SURF })
            end)
        end
    end
    searchBox:GetPropertyChangedSignal("Text"):Connect(function()
        searchQuery = searchBox.Text
        lastSignature = ""
        pcall(refreshList)
    end)
    task.spawn(function()
        while screenGui.Parent do
            pcall(refreshList)
            task.wait(2)
        end
    end)
    local chatPage = Instance.new("Frame", content)
    chatPage.Size = UDim2.fromScale(1, 1)
    chatPage.BackgroundTransparency = 1
    chatPage.Visible = false
    pages.chat = chatPage
    local langBar = Instance.new("Frame", chatPage)
    langBar.Size = UDim2.new(1, 0, 0, 44)
    langBar.BackgroundTransparency = 1
    langBar.ZIndex = 5
    local myLangBtn = Instance.new("TextButton", langBar)
    myLangBtn.Size = UDim2.new(0.5, -5, 1, 0)
    myLangBtn.AutoButtonColor = false
    myLangBtn.BackgroundColor3 = COLORS.SURF2
    myLangBtn.Text = ""
    myLangBtn.ZIndex = 6
    createCorner(myLangBtn, 10)
    createStroke(myLangBtn, COLORS.STROKE, 1, 0.5)
    local myLangLbl = Instance.new("TextLabel", myLangBtn)
    myLangLbl.Size = UDim2.new(1, -16, 0, 14)
    myLangLbl.Position = UDim2.fromOffset(12, 6)
    myLangLbl.BackgroundTransparency = 1
    myLangLbl.Font = Enum.Font.GothamBold
    myLangLbl.Text = "MY LANGUAGE"
    myLangLbl.TextSize = 9
    myLangLbl.TextColor3 = COLORS.DIM
    myLangLbl.TextXAlignment = Enum.TextXAlignment.Left
    myLangLbl.ZIndex = 7
    local myLangValue = Instance.new("TextLabel", myLangBtn)
    myLangValue.Size = UDim2.new(1, -30, 0, 18)
    myLangValue.Position = UDim2.fromOffset(12, 21)
    myLangValue.BackgroundTransparency = 1
    myLangValue.Font = Enum.Font.GothamBlack
    myLangValue.Text = langDisplay(settings.myLang)
    myLangValue.TextSize = 13
    myLangValue.TextColor3 = COLORS.TEXT
    myLangValue.TextXAlignment = Enum.TextXAlignment.Left
    myLangValue.ZIndex = 6
    local myLangArrow = Instance.new("TextLabel", myLangBtn)
    myLangArrow.Size = UDim2.new(0, 18, 1, 0)
    myLangArrow.Position = UDim2.new(1, -22, 0, 0)
    myLangArrow.BackgroundTransparency = 1
    myLangArrow.Font = Enum.Font.GothamBold
    myLangArrow.Text = "v"
    myLangArrow.TextSize = 12
    myLangArrow.TextColor3 = COLORS.DIM
    myLangArrow.ZIndex = 7
    local theirLangFrame = Instance.new("Frame", langBar)
    theirLangFrame.Size = UDim2.new(0.5, -5, 1, 0)
    theirLangFrame.Position = UDim2.new(0.5, 5, 0, 0)
    theirLangFrame.BackgroundColor3 = COLORS.SURF
    theirLangFrame.ZIndex = 5
    createCorner(theirLangFrame, 10)
    createStroke(theirLangFrame, COLORS.STROKE, 1, 0.5)
    local theirLangTitle = Instance.new("TextLabel", theirLangFrame)
    theirLangTitle.Size = UDim2.new(1, -16, 0, 14)
    theirLangTitle.Position = UDim2.fromOffset(12, 6)
    theirLangTitle.BackgroundTransparency = 1
    theirLangTitle.Font = Enum.Font.GothamBold
    theirLangTitle.Text = "THEIR LANGUAGE"
    theirLangTitle.TextSize = 9
    theirLangTitle.TextColor3 = COLORS.DIM
    theirLangTitle.TextXAlignment = Enum.TextXAlignment.Left
    theirLangTitle.ZIndex = 5
    local theirLangValue = Instance.new("TextLabel", theirLangFrame)
    theirLangValue.Size = UDim2.new(1, -24, 0, 18)
    theirLangValue.Position = UDim2.fromOffset(12, 21)
    theirLangValue.BackgroundTransparency = 1
    theirLangValue.Font = Enum.Font.GothamBlack
    theirLangValue.Text = langDisplay(settings.theirLang)
    theirLangValue.TextSize = 13
    theirLangValue.TextColor3 = COLORS.TEXT
    theirLangValue.TextXAlignment = Enum.TextXAlignment.Left
    theirLangValue.ZIndex = 5
    local autoTag = Instance.new("TextLabel", theirLangFrame)
    autoTag.Size = UDim2.new(0, 34, 0, 14)
    autoTag.Position = UDim2.new(1, -40, 0, 6)
    autoTag.BackgroundTransparency = 1
    autoTag.Font = Enum.Font.GothamBold
    autoTag.Text = "AUTO"
    autoTag.TextSize = 8
    autoTag.TextColor3 = COLORS.GREEN_STROKE
    autoTag.TextXAlignment = Enum.TextXAlignment.Right
    autoTag.ZIndex = 5
    local translateToggle = Instance.new("TextButton", chatPage)
    translateToggle.Size = UDim2.new(1, 0, 0, 28)
    translateToggle.Position = UDim2.fromOffset(0, 50)
    translateToggle.BackgroundColor3 = settings.translatorOn and COLORS.GREEN1 or COLORS.SURF2
    translateToggle.AutoButtonColor = false
    translateToggle.Text = settings.translatorOn and "AUTO-TRANSLATE INCOMING  •  ON" or "AUTO-TRANSLATE INCOMING  •  OFF"
    translateToggle.Font = Enum.Font.GothamBold
    translateToggle.TextSize = 11
    translateToggle.TextColor3 = settings.translatorOn and COLORS.TEXT or COLORS.OFF_TEXT
    translateToggle.ZIndex = 5
    createCorner(translateToggle, 10)
    local translateToggleStroke = createStroke(translateToggle, settings.translatorOn and COLORS.GREEN_STROKE or COLORS.STROKE, 1, 0.5)
    translateToggle.MouseButton1Click:Connect(function()
        settings.translatorOn = not settings.translatorOn
        saveConfig()
        translateToggle.Text = settings.translatorOn and "AUTO-TRANSLATE INCOMING  •  ON" or "AUTO-TRANSLATE INCOMING  •  OFF"
        tween(translateToggle, 0.1, { BackgroundColor3 = settings.translatorOn and COLORS.GREEN1 or COLORS.SURF2 })
        translateToggle.TextColor3 = settings.translatorOn and COLORS.TEXT or COLORS.OFF_TEXT
        translateToggleStroke.Color = settings.translatorOn and COLORS.GREEN_STROKE or COLORS.STROKE
    end)
    local langDropdown = Instance.new("Frame", chatPage)
    langDropdown.Size = UDim2.new(0.5, -5, 0, 0)
    langDropdown.Position = UDim2.fromOffset(0, 46)
    langDropdown.BackgroundColor3 = COLORS.SURF
    langDropdown.BorderSizePixel = 0
    langDropdown.Visible = false
    langDropdown.ClipsDescendants = true
    langDropdown.ZIndex = 30
    createCorner(langDropdown, 10)
    createStroke(langDropdown, COLORS.STROKE, 1, 0.35)
    local langScroll = Instance.new("ScrollingFrame", langDropdown)
    langScroll.Size = UDim2.fromScale(1, 1)
    langScroll.BackgroundTransparency = 1
    langScroll.BorderSizePixel = 0
    langScroll.ScrollBarThickness = 3
    langScroll.ScrollBarImageColor3 = COLORS.ACCENT
    langScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    langScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    langScroll.ZIndex = 31
    local langScrollLayout = Instance.new("UIListLayout", langScroll)
    langScrollLayout.Padding = UDim.new(0, 3)
    langScrollLayout.SortOrder = Enum.SortOrder.LayoutOrder
    local langScrollPad = Instance.new("UIPadding", langScroll)
    langScrollPad.PaddingTop = UDim.new(0, 4)
    langScrollPad.PaddingBottom = UDim.new(0, 4)
    langScrollPad.PaddingLeft = UDim.new(0, 4)
    langScrollPad.PaddingRight = UDim.new(0, 4)
    local langOpen = false
    for i, lang in ipairs(LANGUAGES) do
        local btn = Instance.new("TextButton", langScroll)
        btn.Size = UDim2.new(1, -2, 0, 28)
        btn.LayoutOrder = i
        btn.AutoButtonColor = false
        btn.BackgroundColor3 = COLORS.SURF2
        btn.Text = ""
        btn.ZIndex = 32
        createCorner(btn, 8)
        local lbl = Instance.new("TextLabel", btn)
        lbl.Size = UDim2.new(1, -20, 1, 0)
        lbl.Position = UDim2.fromOffset(10, 0)
        lbl.BackgroundTransparency = 1
        lbl.Font = Enum.Font.GothamMedium
        lbl.Text = lang.name
        lbl.TextSize = 12
        lbl.TextColor3 = COLORS.TEXT
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.ZIndex = 32
        if lang.code == settings.myLang then
            local check = Instance.new("TextLabel", btn)
            check.Size = UDim2.new(0, 20, 1, 0)
            check.Position = UDim2.new(1, -24, 0, 0)
            check.BackgroundTransparency = 1
            check.Font = Enum.Font.GothamBold
            check.Text = "•"
            check.TextSize = 16
            check.TextColor3 = COLORS.ACCENT
            check.ZIndex = 32
        end
        btn.MouseEnter:Connect(function()
            tween(btn, 0.1, { BackgroundColor3 = COLORS.ACCENT2 })
        end)
        btn.MouseLeave:Connect(function()
            tween(btn, 0.1, { BackgroundColor3 = COLORS.SURF2 })
        end)
        btn.MouseButton1Click:Connect(function()
            settings.myLang = lang.code
            saveConfig()
            myLangValue.Text = lang.name
            langOpen = false
            langDropdown.Visible = false
            myLangArrow.Text = "v"
        end)
    end
    myLangBtn.MouseButton1Click:Connect(function()
        langOpen = not langOpen
        if langOpen then
            langDropdown.Visible = true
            myLangArrow.Text = "^"
            langDropdown.Size = UDim2.new(0.5, -5, 0, 0)
            tween(langDropdown, 0.16, { Size = UDim2.new(0.5, -5, 0, 190) })
        else
            myLangArrow.Text = "v"
            local tw = TweenService:Create(langDropdown, TweenInfo.new(0.14, Enum.EasingStyle.Quad), { Size = UDim2.new(0.5, -5, 0, 0) })
            tw:Play()
            tw.Completed:Connect(function()
                if not langOpen then langDropdown.Visible = false end
            end)
        end
    end)
    local translatedScroll = Instance.new("ScrollingFrame", chatPage)
    translatedScroll.Size = UDim2.new(1, 0, 1, -232)
    translatedScroll.Position = UDim2.fromOffset(0, 86)
    translatedScroll.BackgroundColor3 = COLORS.SURF
    translatedScroll.BorderSizePixel = 0
    translatedScroll.ScrollBarThickness = 4
    translatedScroll.ScrollBarImageColor3 = COLORS.ACCENT
    translatedScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    translatedScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    createCorner(translatedScroll, 10)
    createStroke(translatedScroll, COLORS.STROKE, 1, 0.6)
    local tsPad = Instance.new("UIPadding", translatedScroll)
    tsPad.PaddingLeft = UDim.new(0, 8)
    tsPad.PaddingRight = UDim.new(0, 8)
    tsPad.PaddingTop = UDim.new(0, 8)
    tsPad.PaddingBottom = UDim.new(0, 8)
    local tsLayout = Instance.new("UIListLayout", translatedScroll)
    tsLayout.Padding = UDim.new(0, 6)
    tsLayout.SortOrder = Enum.SortOrder.LayoutOrder
    local emptyHint = Instance.new("TextLabel", translatedScroll)
    emptyHint.Size = UDim2.new(1, 0, 0, 40)
    emptyHint.BackgroundTransparency = 1
    emptyHint.Font = Enum.Font.Gotham
    emptyHint.Text = "their messages appear here, translated"
    emptyHint.TextSize = 11
    emptyHint.TextColor3 = COLORS.OFF_TEXT
    emptyHint.TextWrapped = true
    local msgOrder = 0
    local function clearChat()
        for _, child in ipairs(translatedScroll:GetChildren()) do
            if child:IsA("Frame") then child:Destroy() end
        end
        emptyHint.Visible = true
        msgOrder = 0
        settings.theirLang = "auto"
        theirLangValue.Text = langDisplay("auto")
    end
    local function addTranslatedMessage(original, translated)
        emptyHint.Visible = false
        msgOrder += 1
        local frame = Instance.new("Frame", translatedScroll)
        frame.Size = UDim2.new(1, 0, 0, 0)
        frame.AutomaticSize = Enum.AutomaticSize.Y
        frame.BackgroundColor3 = COLORS.SURF2
        frame.BorderSizePixel = 0
        frame.LayoutOrder = msgOrder
        createCorner(frame, 10)
        createStroke(frame, COLORS.STROKE, 1, 0.7)
        local pad = Instance.new("UIPadding", frame)
        pad.PaddingLeft = UDim.new(0, 8)
        pad.PaddingRight = UDim.new(0, 8)
        pad.PaddingTop = UDim.new(0, 6)
        pad.PaddingBottom = UDim.new(0, 6)
        local layout = Instance.new("UIListLayout", frame)
        layout.Padding = UDim.new(0, 2)
        layout.SortOrder = Enum.SortOrder.LayoutOrder
        local translatedLbl = Instance.new("TextLabel", frame)
        translatedLbl.Size = UDim2.new(1, 0, 0, 0)
        translatedLbl.AutomaticSize = Enum.AutomaticSize.Y
        translatedLbl.BackgroundTransparency = 1
        translatedLbl.Font = Enum.Font.GothamBold
        translatedLbl.Text = translated
        translatedLbl.TextSize = 12
        translatedLbl.TextColor3 = COLORS.TEXT
        translatedLbl.TextXAlignment = Enum.TextXAlignment.Left
        translatedLbl.TextWrapped = true
        translatedLbl.LayoutOrder = 1
        local originalLbl = Instance.new("TextLabel", frame)
        originalLbl.Size = UDim2.new(1, 0, 0, 0)
        originalLbl.AutomaticSize = Enum.AutomaticSize.Y
        originalLbl.BackgroundTransparency = 1
        originalLbl.Font = Enum.Font.Gotham
        originalLbl.Text = original
        originalLbl.TextSize = 10
        originalLbl.TextColor3 = COLORS.OFF_TEXT
        originalLbl.TextXAlignment = Enum.TextXAlignment.Left
        originalLbl.TextWrapped = true
        originalLbl.LayoutOrder = 2
        task.defer(function()
            translatedScroll.CanvasPosition = Vector2.new(0, translatedScroll.AbsoluteCanvasSize.Y)
        end)
    end
    local inputFrame = Instance.new("Frame", chatPage)
    inputFrame.Size = UDim2.new(1, 0, 0, 138)
    inputFrame.Position = UDim2.new(0, 0, 1, -138)
    inputFrame.BackgroundTransparency = 1
    local replyBox = Instance.new("TextBox", inputFrame)
    replyBox.Size = UDim2.new(1, 0, 0, 42)
    replyBox.Position = UDim2.fromOffset(0, 0)
    replyBox.BackgroundColor3 = COLORS.SURF
    replyBox.Text = ""
    replyBox.PlaceholderText = "type your reply…"
    replyBox.PlaceholderColor3 = COLORS.OFF_TEXT
    replyBox.Font = Enum.Font.Gotham
    replyBox.TextSize = 12
    replyBox.TextColor3 = COLORS.TEXT
    replyBox.TextWrapped = true
    replyBox.MultiLine = true
    replyBox.TextXAlignment = Enum.TextXAlignment.Left
    replyBox.TextYAlignment = Enum.TextYAlignment.Top
    replyBox.ClearTextOnFocus = false
    replyBox.ClipsDescendants = true
    createCorner(replyBox, 10)
    createStroke(replyBox, COLORS.STROKE, 1, 0.55)
    local replyPad = Instance.new("UIPadding", replyBox)
    replyPad.PaddingLeft = UDim.new(0, 10)
    replyPad.PaddingTop = UDim.new(0, 7)
    replyPad.PaddingRight = UDim.new(0, 10)
    replyPad.PaddingBottom = UDim.new(0, 6)
    local previewBox = Instance.new("TextLabel", inputFrame)
    previewBox.Size = UDim2.new(1, 0, 0, 42)
    previewBox.Position = UDim2.fromOffset(0, 48)
    previewBox.BackgroundColor3 = COLORS.SURF2
    previewBox.Text = ""
    previewBox.Font = Enum.Font.GothamMedium
    previewBox.TextSize = 11
    previewBox.TextColor3 = COLORS.TEXT
    previewBox.TextWrapped = true
    previewBox.TextXAlignment = Enum.TextXAlignment.Left
    previewBox.TextYAlignment = Enum.TextYAlignment.Top
    createCorner(previewBox, 10)
    createStroke(previewBox, COLORS.STROKE, 1, 0.6)
    local previewPad = Instance.new("UIPadding", previewBox)
    previewPad.PaddingLeft = UDim.new(0, 10)
    previewPad.PaddingRight = UDim.new(0, 10)
    previewPad.PaddingTop = UDim.new(0, 6)
    previewPad.PaddingBottom = UDim.new(0, 6)
    local willSendTag = Instance.new("TextLabel", previewBox)
    willSendTag.Size = UDim2.new(0, 70, 0, 12)
    willSendTag.Position = UDim2.new(1, -80, 0, 4)
    willSendTag.BackgroundTransparency = 1
    willSendTag.Font = Enum.Font.GothamBold
    willSendTag.Text = "WILL SEND"
    willSendTag.TextSize = 10
    willSendTag.TextColor3 = COLORS.GREEN_STROKE
    willSendTag.TextXAlignment = Enum.TextXAlignment.Right
    willSendTag.Visible = false
    local previewHint = Instance.new("TextLabel", previewBox)
    previewHint.Size = UDim2.fromScale(1, 1)
    previewHint.BackgroundTransparency = 1
    previewHint.Font = Enum.Font.Gotham
    previewHint.Text = "translated preview appears here…"
    previewHint.TextSize = 11
    previewHint.TextColor3 = COLORS.OFF_TEXT
    previewHint.TextXAlignment = Enum.TextXAlignment.Left
    previewHint.TextYAlignment = Enum.TextYAlignment.Top
    local actionRow = Instance.new("Frame", inputFrame)
    actionRow.Size = UDim2.new(1, 0, 0, 32)
    actionRow.Position = UDim2.fromOffset(0, 96)
    actionRow.BackgroundTransparency = 1
    local actionLayout = Instance.new("UIListLayout", actionRow)
    actionLayout.FillDirection = Enum.FillDirection.Horizontal
    actionLayout.Padding = UDim.new(0, 6)
    actionLayout.SortOrder = Enum.SortOrder.LayoutOrder
    local translateBtn = createButton(actionRow, "TRANSLATE", { textSize = 12 })
    translateBtn.Size = UDim2.new(0.4, -4, 1, 0)
    translateBtn.LayoutOrder = 1
    local copyBtn = createButton(actionRow, "COPY", { color = COLORS.SURF2, press = COLORS.ACCENT2, stroke = COLORS.STROKE, strokeT = 0.5, textSize = 12 })
    copyBtn.Size = UDim2.new(0.3, -4, 1, 0)
    copyBtn.LayoutOrder = 2
    local sendBtn = createButton(actionRow, "SEND", { textSize = 12 })
    sendBtn.Size = UDim2.new(0.3, -4, 1, 0)
    sendBtn.LayoutOrder = 3
    local translatedText = ""
    translateBtn.MouseButton1Click:Connect(function()
        local text = replyBox.Text
        if text == "" then return end
        translateBtn.Text = "..."
        task.spawn(function()
            local target = settings.theirLang
            local result = text
            if target and target ~= "" and target ~= "auto" then
                result = translateRealtime(text, target, settings.myLang) or text
            end
            translatedText = result
            previewHint.Visible = false
            willSendTag.Visible = true
            previewBox.Text = result
            translateBtn.Text = "TRANSLATE"
        end)
    end)
    copyBtn.MouseButton1Click:Connect(function()
        local text = translatedText ~= "" and translatedText or replyBox.Text
        if text == "" then return end
        pcall(function() setClipboard(text) end)
        copyBtn.Text = "OK"
        task.delay(1, function()
            if copyBtn.Parent then copyBtn.Text = "COPY" end
        end)
    end)
    sendBtn.MouseButton1Click:Connect(function()
        local text = translatedText ~= "" and translatedText or replyBox.Text
        if text == "" then return end
        sendBtn.Text = "..."
        task.spawn(function()
            local ok = sendChatMessage(text)
            sendBtn.Text = ok and "SENT" or "FAIL"
            if ok then
                replyBox.Text = ""
                previewBox.Text = ""
                previewHint.Visible = true
                willSendTag.Visible = false
                translatedText = ""
            end
            task.delay(1.5, function()
                if sendBtn.Parent then sendBtn.Text = "SEND" end
            end)
        end)
    end)
    local presetsPage = Instance.new("Frame", content)
    presetsPage.Size = UDim2.fromScale(1, 1)
    presetsPage.BackgroundTransparency = 1
    presetsPage.Visible = false
    pages.presets = presetsPage
    local presetInput = Instance.new("TextBox", presetsPage)
    presetInput.Size = UDim2.new(1, 0, 0, 42)
    presetInput.Position = UDim2.fromOffset(0, 0)
    presetInput.BackgroundColor3 = COLORS.SURF
    presetInput.Text = ""
    presetInput.PlaceholderText = "write a preset message…"
    presetInput.PlaceholderColor3 = COLORS.OFF_TEXT
    presetInput.Font = Enum.Font.Gotham
    presetInput.TextSize = 12
    presetInput.TextColor3 = COLORS.TEXT
    presetInput.TextWrapped = true
    presetInput.TextXAlignment = Enum.TextXAlignment.Left
    presetInput.TextYAlignment = Enum.TextYAlignment.Top
    presetInput.ClearTextOnFocus = false
    createCorner(presetInput, 10)
    createStroke(presetInput, COLORS.STROKE, 1, 0.55)
    local presetPad = Instance.new("UIPadding", presetInput)
    presetPad.PaddingLeft = UDim.new(0, 10)
    presetPad.PaddingTop = UDim.new(0, 6)
    presetPad.PaddingRight = UDim.new(0, 10)
    local addPresetBtn = createButton(presetsPage, "+ ADD PRESET", { textSize = 12 })
    addPresetBtn.Size = UDim2.new(1, 0, 0, 28)
    addPresetBtn.Position = UDim2.fromOffset(0, 48)
    local presetScroll = Instance.new("ScrollingFrame", presetsPage)
    presetScroll.Size = UDim2.new(1, 0, 1, -86)
    presetScroll.Position = UDim2.fromOffset(0, 84)
    presetScroll.BackgroundTransparency = 1
    presetScroll.BorderSizePixel = 0
    presetScroll.ScrollBarThickness = 4
    presetScroll.ScrollBarImageColor3 = COLORS.ACCENT
    presetScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    presetScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    local presetScrollPad = Instance.new("UIPadding", presetScroll)
    presetScrollPad.PaddingRight = UDim.new(0, 6)
    presetScrollPad.PaddingTop = UDim.new(0, 1)
    local presetScrollLayout = Instance.new("UIListLayout", presetScroll)
    presetScrollLayout.Padding = UDim.new(0, 8)
    presetScrollLayout.SortOrder = Enum.SortOrder.LayoutOrder
    local editingIndex = nil
    local function refreshPresets()
        for _, child in ipairs(presetScroll:GetChildren()) do
            if child:IsA("Frame") then child:Destroy() end
        end
        for i, preset in ipairs(settings.presets) do
            local row = Instance.new("Frame", presetScroll)
            row.Size = UDim2.new(1, 0, 0, 64)
            row.BackgroundColor3 = COLORS.SURF
            row.BorderSizePixel = 0
            row.LayoutOrder = i
            createCorner(row, 11)
            createStroke(row, COLORS.STROKE, 1, 0.55)
            local inner = Instance.new("Frame", row)
            inner.Size = UDim2.new(1, -20, 1, -16)
            inner.Position = UDim2.fromOffset(10, 8)
            inner.BackgroundTransparency = 1
            local txt = Instance.new("TextLabel", inner)
            txt.Size = UDim2.new(1, 0, 0, 20)
            txt.Position = UDim2.fromOffset(0, 0)
            txt.BackgroundTransparency = 1
            txt.Font = Enum.Font.GothamMedium
            txt.Text = preset
            txt.TextSize = 12
            txt.TextColor3 = COLORS.TEXT
            txt.TextXAlignment = Enum.TextXAlignment.Left
            txt.TextTruncate = Enum.TextTruncate.AtEnd
            local btns = Instance.new("Frame", inner)
            btns.Size = UDim2.new(1, 0, 0, 20)
            btns.Position = UDim2.new(0, 0, 1, -20)
            btns.BackgroundTransparency = 1
            local bLayout = Instance.new("UIListLayout", btns)
            bLayout.FillDirection = Enum.FillDirection.Horizontal
            bLayout.Padding = UDim.new(0, 6)
            bLayout.SortOrder = Enum.SortOrder.LayoutOrder
            local function smallBtn(text, order, opts)
                opts = opts or { color = COLORS.SURF2, press = COLORS.ACCENT2, stroke = COLORS.STROKE, strokeT = 0.5 }
                local b = createButton(btns, text, { color = opts.color, press = opts.press, stroke = opts.stroke, strokeT = opts.strokeT, radius = 6, textSize = 10 })
                b.Size = UDim2.new(0.25, -4.5, 1, 0)
                b.LayoutOrder = order
                return b
            end
            local sendP = smallBtn("SEND", 1, { color = COLORS.ACCENT2, press = COLORS.ACCENT, stroke = COLORS.ACCENT, strokeT = 0.35 })
            local copyP = smallBtn("COPY", 2)
            local editP = smallBtn("EDIT", 3)
            local delP = smallBtn("DEL", 4, { color = Color3.fromRGB(90, 28, 28), press = Color3.fromRGB(120, 40, 40), stroke = Color3.fromRGB(160, 60, 60), strokeT = 0.4 })
            sendP.MouseButton1Click:Connect(function()
                task.spawn(function()
                    local target = settings.theirLang
                    local msg = preset
                    if target and target ~= "" and target ~= "auto" and target ~= settings.myLang then
                        local result = translateRealtime(preset, target, settings.myLang)
                        if result and result ~= "" then msg = result end
                    end
                    sendP.Text = sendChatMessage(msg) and "SENT" or "FAIL"
                    task.delay(1, function()
                        if sendP.Parent then sendP.Text = "SEND" end
                    end)
                end)
            end)
            copyP.MouseButton1Click:Connect(function()
                pcall(function() setClipboard(preset) end)
                copyP.Text = "OK"
                task.delay(1, function()
                    if copyP.Parent then copyP.Text = "COPY" end
                end)
            end)
            editP.MouseButton1Click:Connect(function()
                presetInput.Text = preset
                editingIndex = i
                addPresetBtn.Text = "SAVE EDIT"
            end)
            delP.MouseButton1Click:Connect(function()
                table.remove(settings.presets, i)
                saveConfig()
                refreshPresets()
            end)
        end
    end
    addPresetBtn.MouseButton1Click:Connect(function()
        local text = presetInput.Text
        if text == "" then return end
        if editingIndex then
            settings.presets[editingIndex] = text
            editingIndex = nil
            addPresetBtn.Text = "+ ADD PRESET"
        else
            table.insert(settings.presets, text)
        end
        presetInput.Text = ""
        saveConfig()
        refreshPresets()
    end)
    refreshPresets()
    local settingsPage = Instance.new("Frame", content)
    settingsPage.Size = UDim2.fromScale(1, 1)
    settingsPage.BackgroundTransparency = 1
    settingsPage.Visible = false
    pages.settings = settingsPage
    local settingsScroll = Instance.new("ScrollingFrame", settingsPage)
    settingsScroll.Size = UDim2.fromScale(1, 1)
    settingsScroll.BackgroundTransparency = 1
    settingsScroll.BorderSizePixel = 0
    settingsScroll.ScrollBarThickness = 4
    settingsScroll.ScrollBarImageColor3 = COLORS.ACCENT
    settingsScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    settingsScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    local settingsPad = Instance.new("UIPadding", settingsScroll)
    settingsPad.PaddingRight = UDim.new(0, 6)
    settingsPad.PaddingBottom = UDim.new(0, 12)
    local settingsLayout = Instance.new("UIListLayout", settingsScroll)
    settingsLayout.Padding = UDim.new(0, 7)
    settingsLayout.SortOrder = Enum.SortOrder.LayoutOrder
    local function addSection(text, order, small)
        local frame = Instance.new("Frame", settingsScroll)
        frame.Size = UDim2.new(1, 0, 0, small and 24 or 34)
        frame.LayoutOrder = order
        frame.BackgroundTransparency = 1
        local lbl = Instance.new("TextLabel", frame)
        lbl.Size = UDim2.new(1, 0, 0, 16)
        lbl.Position = UDim2.new(0, 2, 1, -18)
        lbl.BackgroundTransparency = 1
        lbl.Text = text
        lbl.Font = Enum.Font.GothamBlack
        lbl.TextSize = 11
        lbl.TextColor3 = COLORS.ACCENT
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        local bar = Instance.new("Frame", frame)
        bar.Size = UDim2.new(1, 0, 0, 1)
        bar.Position = UDim2.new(0, 0, 1, -1)
        bar.BackgroundColor3 = COLORS.STROKE
        bar.BackgroundTransparency = 0.6
        bar.BorderSizePixel = 0
    end
    local function addToggle(text, key, order, onChange)
        local btn = Instance.new("TextButton", settingsScroll)
        btn.Size = UDim2.new(1, 0, 0, 36)
        btn.LayoutOrder = order
        btn.AutoButtonColor = false
        btn.BackgroundColor3 = COLORS.SURF
        btn.Text = ""
        btn.ZIndex = 5
        createCorner(btn, 9)
        createStroke(btn, COLORS.STROKE, 1, 0.55)
        local lbl = Instance.new("TextLabel", btn)
        lbl.Size = UDim2.new(1, -64, 1, 0)
        lbl.Position = UDim2.fromOffset(14, 0)
        lbl.BackgroundTransparency = 1
        lbl.Text = text
        lbl.Font = Enum.Font.GothamMedium
        lbl.TextSize = 12
        lbl.TextColor3 = COLORS.TEXT
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.ZIndex = 5
        local track = Instance.new("Frame", btn)
        track.Size = UDim2.fromOffset(42, 22)
        track.Position = UDim2.new(1, -54, 0.5, -11)
        track.BackgroundColor3 = settings[key] and COLORS.GREEN1 or COLORS.SURF2
        track.ZIndex = 6
        createCorner(track, 11)
        local knob = Instance.new("Frame", track)
        knob.Size = UDim2.fromOffset(16, 16)
        knob.ZIndex = 7
        createCorner(knob, 8)
        knob.BackgroundColor3 = settings[key] and COLORS.GREEN_STROKE or COLORS.OFF_TEXT
        knob.Position = settings[key] and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)
        btn.MouseButton1Click:Connect(function()
            settings[key] = not settings[key]
            tween(track, 0.1, { BackgroundColor3 = settings[key] and COLORS.GREEN1 or COLORS.SURF2 })
            tween(knob, 0.1, {
                Position = settings[key] and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8),
                BackgroundColor3 = settings[key] and COLORS.GREEN_STROKE or COLORS.OFF_TEXT,
            })
            saveConfig()
            if onChange then onChange() end
        end)
        return btn
    end
    addSection("SERVER HOPPING", 1, true)
    addToggle("Auto-hop until priority", "autoHop", 2)
    local tierLabel = Instance.new("TextLabel", settingsScroll)
    tierLabel.Size = UDim2.new(1, 0, 0, 14)
    tierLabel.LayoutOrder = 3
    tierLabel.BackgroundTransparency = 1
    tierLabel.Text = "Hop tier"
    tierLabel.Font = Enum.Font.GothamMedium
    tierLabel.TextSize = 11
    tierLabel.TextColor3 = COLORS.OFF_TEXT
    tierLabel.TextXAlignment = Enum.TextXAlignment.Left
    local tierRow = Instance.new("Frame", settingsScroll)
    tierRow.Size = UDim2.new(1, 0, 0, 30)
    tierRow.LayoutOrder = 4
    tierRow.BackgroundTransparency = 1
    local tierLayout = Instance.new("UIListLayout", tierRow)
    tierLayout.FillDirection = Enum.FillDirection.Horizontal
    tierLayout.Padding = UDim.new(0, 6)
    tierLayout.SortOrder = Enum.SortOrder.LayoutOrder
    local tierButtons = {}
    for i, tier in ipairs({ "Normal", "Pro", "OG" }) do
        local b = Instance.new("TextButton", tierRow)
        b.Size = UDim2.new(0.3333, -4, 1, 0)
        b.LayoutOrder = i
        b.AutoButtonColor = false
        b.Text = tier
        b.Font = Enum.Font.GothamBold
        b.TextSize = 12
        createCorner(b, 8)
        b.BackgroundColor3 = settings.hopTier == tier and COLORS.ACCENT2 or COLORS.SURF2
        b.TextColor3 = settings.hopTier == tier and COLORS.TEXT or COLORS.OFF_TEXT
        createStroke(b, settings.hopTier == tier and COLORS.ACCENT or COLORS.STROKE, 1, 0.5)
        tierButtons[tier] = b
        b.MouseButton1Click:Connect(function()
            settings.hopTier = tier
            saveConfig()
            for k, btn in pairs(tierButtons) do
                tween(btn, 0.1, { BackgroundColor3 = k == tier and COLORS.ACCENT2 or COLORS.SURF2 })
                btn.TextColor3 = k == tier and COLORS.TEXT or COLORS.OFF_TEXT
                local s = btn:FindFirstChildWhichIsA("UIStroke")
                if s then s.Color = k == tier and COLORS.ACCENT or COLORS.STROKE end
            end
        end)
    end
    local hopNow = createButton(settingsScroll, "HOP NOW", { textSize = 12 })
    hopNow.Size = UDim2.new(1, 0, 0, 34)
    hopNow.LayoutOrder = 5
    hopNow.MouseButton1Click:Connect(function()
        hopServer(settings.hopTier)
    end)
    addSection("ALERTS", 10)
    addToggle("Alert sound on priority", "alertSound", 11)
    addSection("DISPLAY", 20)
    addToggle("Show player avatars", "showAvatars", 21, function()
        lastSignature = ""
    end)
    addToggle("Beam to trader's base", "beamToBase", 22)
    addSection("PRIORITY BRAINROTS", 30)
    local priorityInput = Instance.new("TextBox", settingsScroll)
    priorityInput.Size = UDim2.new(1, 0, 0, 34)
    priorityInput.LayoutOrder = 31
    priorityInput.BackgroundColor3 = COLORS.SURF
    priorityInput.Text = ""
    priorityInput.PlaceholderText = "search a brainrot to add..."
    priorityInput.PlaceholderColor3 = COLORS.OFF_TEXT
    priorityInput.Font = Enum.Font.GothamMedium
    priorityInput.TextSize = 12
    priorityInput.TextColor3 = COLORS.TEXT
    priorityInput.TextXAlignment = Enum.TextXAlignment.Left
    priorityInput.ClearTextOnFocus = false
    createCorner(priorityInput, 8)
    createStroke(priorityInput, COLORS.STROKE, 1, 0.5)
    local priorityPad = Instance.new("UIPadding", priorityInput)
    priorityPad.PaddingLeft = UDim.new(0, 12)
    local suggestionFrame = Instance.new("Frame", settingsScroll)
    suggestionFrame.Size = UDim2.new(1, 0, 0, 0)
    suggestionFrame.LayoutOrder = 32
    suggestionFrame.BackgroundTransparency = 1
    suggestionFrame.AutomaticSize = Enum.AutomaticSize.Y
    local sugLayout = Instance.new("UIListLayout", suggestionFrame)
    sugLayout.Padding = UDim.new(0, 4)
    local priorityListLabel = Instance.new("TextLabel", settingsScroll)
    priorityListLabel.Size = UDim2.new(1, 0, 0, 16)
    priorityListLabel.LayoutOrder = 33
    priorityListLabel.BackgroundTransparency = 1
    priorityListLabel.Text = "YOUR LIST"
    priorityListLabel.Font = Enum.Font.GothamBold
    priorityListLabel.TextSize = 10
    priorityListLabel.TextColor3 = COLORS.OFF_TEXT
    priorityListLabel.TextXAlignment = Enum.TextXAlignment.Left
    local priorityListFrame = Instance.new("Frame", settingsScroll)
    priorityListFrame.Size = UDim2.new(1, 0, 0, 0)
    priorityListFrame.LayoutOrder = 34
    priorityListFrame.BackgroundTransparency = 1
    priorityListFrame.AutomaticSize = Enum.AutomaticSize.Y
    local plLayout = Instance.new("UIListLayout", priorityListFrame)
    plLayout.Padding = UDim.new(0, 4)
    local function isPriority(name)
        for _, v in ipairs(settings.priorityList) do
            if v == name then return true end
        end
        return false
    end
    local function refreshPriorityList()
        priorityListLabel.Text = "YOUR LIST  (" .. #settings.priorityList .. ")"
        for _, child in ipairs(priorityListFrame:GetChildren()) do
            if child:IsA("Frame") then child:Destroy() end
        end
        for i, name in ipairs(settings.priorityList) do
            local frame = Instance.new("Frame", priorityListFrame)
            frame.Size = UDim2.new(1, 0, 0, 30)
            frame.BackgroundColor3 = COLORS.SURF2
            createCorner(frame, 8)
            createStroke(frame, COLORS.STROKE, 1, 0.7)
            local lbl = Instance.new("TextLabel", frame)
            lbl.Size = UDim2.new(1, -30, 1, 0)
            lbl.Position = UDim2.fromOffset(8, 0)
            lbl.BackgroundTransparency = 1
            lbl.Text = name
            lbl.Font = Enum.Font.GothamMedium
            lbl.TextSize = 11
            lbl.TextColor3 = COLORS.TEXT
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.TextTruncate = Enum.TextTruncate.AtEnd
            local del = Instance.new("TextButton", frame)
            del.Size = UDim2.fromOffset(22, 22)
            del.Position = UDim2.new(1, -25, 0.5, -11)
            del.AutoButtonColor = false
            del.BackgroundColor3 = COLORS.ACCENT2
            del.Text = "x"
            del.Font = Enum.Font.GothamBold
            del.TextSize = 12
            del.TextColor3 = COLORS.TEXT
            createCorner(del, 6)
            del.MouseButton1Click:Connect(function()
                table.remove(settings.priorityList, i)
                saveConfig()
                refreshPriorityList()
            end)
        end
    end
    local function refreshSuggestions()
        for _, child in ipairs(suggestionFrame:GetChildren()) do
            if child:IsA("TextButton") then child:Destroy() end
        end
        local query = priorityInput.Text:lower():gsub("^%s+", ""):gsub("%s+$", "")
        if query == "" then return end
        local count = 0
        for name, data in pairs(AnimalData) do
            if type(data) == "table" and data.Rarity and not isPriority(name) then
                if name:lower():find(query, 1, true) then
                    count += 1
                    local btn = Instance.new("TextButton", suggestionFrame)
                    btn.Size = UDim2.new(1, 0, 0, 28)
                    btn.AutoButtonColor = false
                    btn.BackgroundColor3 = COLORS.SURF
                    btn.Text = "+ " .. name .. "  (" .. data.Rarity .. ")"
                    btn.Font = Enum.Font.GothamMedium
                    btn.TextSize = 11
                    btn.TextColor3 = COLORS.TEXT
                    btn.TextXAlignment = Enum.TextXAlignment.Left
                    createCorner(btn, 6)
                    local pad = Instance.new("UIPadding", btn)
                    pad.PaddingLeft = UDim.new(0, 8)
                    btn.MouseButton1Click:Connect(function()
                        table.insert(settings.priorityList, name)
                        saveConfig()
                        priorityInput.Text = ""
                        refreshSuggestions()
                        refreshPriorityList()
                    end)
                    if count >= 8 then break end
                end
            end
        end
    end
    priorityInput:GetPropertyChangedSignal("Text"):Connect(refreshSuggestions)
    refreshPriorityList()
    switchTab("list")
    task.spawn(function()
        task.wait(4)
        while screenGui.Parent do
            if settings.autoHop and settings.priorityList and #settings.priorityList > 0 then
                local owner, animal = getPriorityInServer()
                if animal then
                    notify("PRIORITY FOUND", animal .. (owner and " @ " .. owner or ""), 8)
                    playAlert()
                    settings.autoHop = false
                    saveConfig()
                    if owner and settings.beamToBase then
                        task.wait(0.3)
                        pcall(function() beamToBase(owner) end)
                    end
                    break
                else
                    for k, t in pairs(hopData.hoppedServers) do
                        if os.time() - t > 600 then
                            hopData.hoppedServers[k] = nil
                        end
                    end
                    saveHops()
                    notify("HOPPING", "no priority here — searching...", 3)
                    task.wait(settings.hopDelay or 2)
                    hopServer(settings.hopTier)
                    task.wait(4)
                    task.wait(6)
                end
            else
                task.wait(6)
            end
        end
    end)
    task.spawn(function()
        local pg = LocalPlayer:WaitForChild("PlayerGui", 30)
        if not pg then return end
        local function processChat(scroll)
            local messages = {}
            for _, child in ipairs(scroll:GetChildren()) do
                if child:IsA("Frame") and child.Name:find("^Message") then
                    local lbl = child:FindFirstChild("Label", true)
                    lbl = lbl and lbl.Text
                    if type(lbl) == "string" and #lbl >= 2 and lbl ~= "Template" then
                        table.insert(messages, { text = lbl, theirs = true })
                    end
                end
            end
            return messages
        end
        local function hookScroll(scroll)
            local lastCount = 0
            local function update()
                local msgs = processChat(scroll)
                if #msgs < lastCount then
                    lastCount = 0
                end
                for i = lastCount + 1, #msgs do
                    local msg = msgs[i]
                    if msg.theirs and settings.translatorOn then
                        task.spawn(function()
                            local translated, detected = translateRealtime(msg.text, settings.myLang, "auto")
                            local wordCount = 0
                            for _ in tostring(msg.text):gmatch("%S+") do wordCount += 1 end
                            local weight = math.clamp(wordCount, 1, 8)
                            if detected and detected ~= "" and detected ~= "auto" then
                                settings.theirLang = detected
                                theirLangValue.Text = langDisplay(detected)
                                saveConfig()
                            end
                            addTranslatedMessage(msg.text, translated and translated ~= msg.text and translated or msg.text)
                        end)
                    end
                end
                lastCount = #msgs
            end
            update()
            scroll.ChildAdded:Connect(function()
                task.defer(update)
            end)
            scroll.ChildRemoved:Connect(function()
                task.defer(function()
                    local msgs = processChat(scroll)
                    if #msgs < lastCount then lastCount = #msgs end
                end)
            end)
        end
        local function hookTrade(trade)
            task.spawn(function()
                local inner = trade:WaitForChild("TradeLiveTrade", 5) or trade
                local chat = inner:FindFirstChild("Chat")
                if not chat then
                    inner.ChildAdded:Connect(function(child)
                        if child.Name == "Chat" then
                            for _, name in ipairs({ "NormalChat", "RestrictedChat" }) do
                                local scroll = child:WaitForChild(name, 5)
                                scroll = scroll and scroll:WaitForChild("ScrollingFrame", 5)
                                if scroll then hookScroll(scroll) end
                            end
                        end
                    end)
                    return
                end
                for _, name in ipairs({ "NormalChat", "RestrictedChat" }) do
                    local scroll = chat:FindFirstChild(name)
                    scroll = scroll and scroll:FindFirstChild("ScrollingFrame")
                    if scroll then hookScroll(scroll) end
                end
            end)
        end
        local tlt = pg:FindFirstChild("TradeLiveTrade")
        if tlt then hookTrade(tlt) end
        pg.ChildAdded:Connect(function(child)
            if child.Name == "TradeLiveTrade" then
                task.defer(function() hookTrade(child) end)
            end
        end)
    end)
    local tradeWatcherActive = false
    local lastTradePartner = nil
    task.spawn(function()
        local pg = LocalPlayer:WaitForChild("PlayerGui", 30)
        if not pg then return end
        local function isTradeOpen()
            local tlt = pg:FindFirstChild("TradeLiveTrade")
            if not tlt then return false end
            if tlt.Enabled == false then return false end
            local inner = tlt:FindFirstChild("TradeLiveTrade")
            if inner and inner:IsA("GuiObject") then return inner.Visible end
            return tlt.Enabled
        end
        local wasOpen = false
        while screenGui.Parent do
            local open = isTradeOpen()
            if open and not wasOpen then
                pcall(clearChat)
                replyBox.Text = ""
                previewBox.Text = ""
                previewHint.Visible = true
                willSendTag.Visible = false
                translatedText = ""
                lastTradePartner = getTradePartner()
                if lastTradePartner and findPlot(lastTradePartner) then
                    pcall(function()
                        local pg2 = LocalPlayer:FindFirstChild("PlayerGui")
                        local tlt = pg2 and pg2:FindFirstChild("TradeLiveTrade")
                        tlt = tlt and tlt:FindFirstChild("TradeLiveTrade")
                        local header = tlt and tlt:FindFirstChild("Header")
                        if header then
                            local old = header:FindFirstChild("SlicedzShowBase")
                            if old then old:Destroy() end
                            local old2 = header:FindFirstChild("SlicedzFriend")
                            if old2 then old2:Destroy() end
                            local btn = Instance.new("ImageButton", header)
                            btn.Name = "SlicedzShowBase"
                            btn.AnchorPoint = Vector2.new(1, 0.5)
                            btn.Size = UDim2.new(0.155, 0, 0.62, 0)
                            btn.Position = UDim2.new(0.775, 0, 0.5, 0)
                            btn.ZIndex = (header.ZIndex or 1) + 5
                            btn.AutoButtonColor = false
                            btn.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
                            btn.ImageTransparency = 1
                            btn.BackgroundColor3 = Color3.fromRGB(64, 120, 196)
                            btn.BorderSizePixel = 0
                            local stroke = Instance.new("UIStroke", btn)
                            stroke.Color = Color3.new(0, 0, 0)
                            stroke.Thickness = 1.41
                            createCorner(btn, 6)
                            local txt = Instance.new("TextLabel", btn)
                            txt.Name = "Txt"
                            txt.BackgroundTransparency = 1
                            txt.Size = UDim2.new(0.92, 0, 0.72, 0)
                            txt.AnchorPoint = Vector2.new(0.5, 0.5)
                            txt.Position = UDim2.fromScale(0.5, 0.5)
                            txt.Font = Enum.Font.GothamBold
                            txt.Text = "SHOW BASE"
                            txt.TextScaled = true
                            txt.TextColor3 = Color3.new(1, 1, 1)
                            txt.ZIndex = btn.ZIndex + 1
                            btn.MouseButton1Click:Connect(function()
                                if not lastTradePartner then return end
                                if baseViewer.panel.Visible then
                                    baseViewer.panel.Visible = false
                                else
                                    showBaseViewer(lastTradePartner)
                                end
                            end)
                            btn.MouseButton1Down:Connect(function()
                                tween(btn, 0.1, { BackgroundColor3 = Color3.fromRGB(46, 92, 158) })
                            end)
                            btn.MouseButton1Up:Connect(function()
                                tween(btn, 0.12, { BackgroundColor3 = Color3.fromRGB(64, 120, 196) })
                            end)
                        end
                    end)
                end
            elseif not open and wasOpen then
                pcall(clearChat)
                replyBox.Text = ""
                previewBox.Text = ""
                previewHint.Visible = true
                willSendTag.Visible = false
                translatedText = ""
                lastTradePartner = nil
                baseViewer.panel.Visible = false
                pcall(function()
                    local pg2 = LocalPlayer:FindFirstChild("PlayerGui")
                    local tlt = pg2 and pg2:FindFirstChild("TradeLiveTrade")
                    tlt = tlt and tlt:FindFirstChild("TradeLiveTrade")
                    local header = tlt and tlt:FindFirstChild("Header")
                    if header then
                        local a = header:FindFirstChild("SlicedzShowBase")
                        if a then a:Destroy() end
                        local b = header:FindFirstChild("SlicedzFriend")
                        if b then b:Destroy() end
                    end
                end)
            end
            wasOpen = open
            task.wait(0.5)
        end
    end)
end

buildUI()

local function onBaseViewerMouseWheel(input)
    if not baseViewer.panel.Visible then return end
    if input.UserInputType == Enum.UserInputType.MouseWheel then
        local mouse = UserInputService:GetMouseLocation()
        local absPos = baseViewer.viewport.AbsolutePosition
        local absSize = baseViewer.viewport.AbsoluteSize
        if mouse.X >= absPos.X and mouse.X <= absPos.X + absSize.X and mouse.Y >= absPos.Y and mouse.Y <= absPos.Y + absSize.Y then
            local camPos = baseViewer.camera.CFrame.Position
            local target = Vector3.new(0, 4, -37)
            local dir = camPos - target
            local mag = dir.Magnitude
            if mag > 0 then
                baseViewer.camera.CFrame = CFrame.lookAt(target + dir.Unit * math.clamp(mag - input.Position.Z * 4, 14, 90), target)
            end
        end
    end
end

UserInputService.InputChanged:Connect(onBaseViewerMouseWheel)

RunService.RenderStepped:Connect(function()
    if baseViewer.panel.Visible then
        renderBaseLabels()
    end
end)