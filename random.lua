local Players, RunService, UserInputService, TweenService, Lighting, HttpService, localPlayer, recolorTextDescendants, getTime
local clamp, floor, huge, sqrt, vector, vector2, cframe, cframe2, raycastParams, getCachedPlayers
local waitForCharacterReady, applyImageAsset, themeColors, color, createThemeGradient, applyThemeGradient, originalOutfit, captureOriginalOutfit, outfitPresets, outfitIndex
local textLabel, youtBatV2PersistentState, youtSpeedHookState, velChecked, velocityWriteLog, installVelocityHook, attachVelocityHookToRoot, isHumanoidIncapacitated, applyBatHitVelocity, applyAnimationPack
local resetAnimationPack, stealConnection, stealSettings, isStealInProgress, antiRagdollState, startAntiRagdoll, stopAntiRagdoll, isEspActive, espEntries, espMonitorConnection
local removeEspForPlayer, espPlayerAddedConnection, espPlayerRemovingConnection, enableEsp
do
    do
        local replicatedStorage, Workspace
        do
            do
                do
                    do
                        _G.YoutRunning = false
                        _G.__YoutMainOriginalPos = nil
                        Players = game:GetService("Players")
                        RunService = game:GetService("RunService")
                        UserInputService = game:GetService("UserInputService")
                        TweenService = game:GetService("TweenService")
                        Lighting = game:GetService("Lighting")
                        HttpService = game:GetService("HttpService")
                        replicatedStorage = game:GetService("ReplicatedStorage")
                        Workspace = game:GetService("Workspace")
                        localPlayer = Players.LocalPlayer

                        do
                            local isActive = not localPlayer

                            if isActive then
                                local connection = Players.PlayerAdded:Connect(function(player)
                                    localPlayer = player
                                end)

                                local now = tick()

                                while not localPlayer and tick() - now < 15 do
                                    task.wait(0.1)
                                end

                                if connection then
                                    connection:Disconnect()
                                end
                            end

                            if isActive then
                                return
                            end
                        end
                    end

                    do
                        if not localPlayer:WaitForChild("PlayerGui", 20) then
                            return
                        end
                        _G.YoutRunning = true
                        _G.YoutSession = (_G.YoutSession or 0) + 1

                        do
                            local data = {
                                es = {
                                    ["RESET ALL SETTINGS"] = "RESTABLECER TODO",
                                    ["SETTINGS RESET"] = "AJUSTES RESTABLECIDOS",
                                    ["CONFIRM?"] = "¿CONFIRMAR?",
                                    ERROR = "ERROR",
                                    ["Reset All Keybinds"] = "RESTABLECER TECLAS",
                                    RESET = "RESTABLECER",
                                    Keybinds = "TECLAS",
                                    ["Carry Mode"] = "MODO CARGAR",
                                    ["Lagger Mode"] = "MODO LAG",
                                    ["Auto Left"] = "AUTO IZQUIERDA",
                                    ["Auto Right"] = "AUTO DERECHA",
                                    ["Auto Bat"] = "AUTO BATE",
                                    ["TP BAT"] = "TP BATE",
                                    ["Insta Reset"] = "REINICIO RÁPIDO",
                                    ["TP Down"] = "TP ABAJO",
                                    ["Drop Brainrot"] = "SOLTAR BRAINROT",
                                    ["Hide GUI"] = "OCULTAR MENÚ",
                                    ["Normal Speed"] = "VELOCIDAD NORMAL",
                                    ["Carry Speed"] = "VELOCIDAD CARGAR",
                                    ["Current Mode"] = "MODO ACTUAL",
                                    ACTIVATE = "ACTIVAR",
                                },
                                pt = {
                                    ["RESET ALL SETTINGS"] = "REDEFINIR TUDO",
                                    ["SETTINGS RESET"] = "CONFIGURAÇÕES REDEFINIDAS",
                                    ["CONFIRM?"] = "CONFIRMAR?",
                                    ERROR = "ERRO",
                                    ["Reset All Keybinds"] = "REDEFINIR TECLAS",
                                    RESET = "REDEFINIR",
                                    ["Keybinds"] = "TECLAS",
                                    ["Carry Mode"] = "MODO CARREGAR",
                                    ["Auto Left"] = "AUTO ESQUERDA",
                                    ["Auto Right"] = "AUTO DIREITA",
                                    ["Hide GUI"] = "OCULTAR MENU",
                                    ["Normal Speed"] = "VELOCIDADE NORMAL",
                                    ["Carry Speed"] = "VELOCIDADE CARREGAR",
                                    ["ACTIVATE"] = "ATIVAR",
                                },
                                fr = {
                                    ["RESET ALL SETTINGS"] = "RÉINITIALISER",
                                    ["SETTINGS RESET"] = "PARAMÈTRES RÉINITIALISÉS",
                                    ["CONFIRM?"] = "CONFIRMER ?",
                                    ERROR = "ERREUR",
                                    ["Reset All Keybinds"] = "RÉINITIALISER LES TOUCHES",
                                    RESET = "RÉINITIALISER",
                                    Keybinds = "RACCOURCIS",
                                    ["Carry Mode"] = "MODE PORTER",
                                    ["Auto Left"] = "AUTO GAUCHE",
                                    ["Auto Right"] = "AUTO DROITE",
                                    ["Hide GUI"] = "MASQUER LE MENU",
                                    ["Normal Speed"] = "VITESSE NORMALE",
                                    ["Carry Speed"] = "VITESSE PORTER",
                                    ACTIVATE = "ACTIVER",
                                },
                                de = {
                                    ["RESET ALL SETTINGS"] = "ALLES ZURÜCKSETZEN",
                                    ["SETTINGS RESET"] = "EINSTELLUNGEN ZURÜCKGESETZT",
                                    ["CONFIRM?"] = "BESTÄTIGEN?",
                                    ["ERROR"] = "FEHLER",
                                    ["Reset All Keybinds"] = "TASTEN ZURÜCKSETZEN",
                                    ["RESET"] = "ZURÜCKSETZEN",
                                    Keybinds = "TASTEN",
                                    ["Carry Mode"] = "TRAGEMODUS",
                                    ["Auto Left"] = "AUTO LINKS",
                                    ["Auto Right"] = "AUTO RECHTS",
                                    ["Hide GUI"] = "MENÜ AUSBLENDEN",
                                    ["Normal Speed"] = "NORMALE GESCHWINDIGKEIT",
                                    ["Carry Speed"] = "TRAGEGESCHWINDIGKEIT",
                                    ["ACTIVATE"] = "AKTIVIEREN",
                                },
                            }

                            recolorTextDescendants = function(instance)
                                local en = data.en
                                if not en or not instance then
                                    return
                                end

                                for _, descendant in ipairs(instance:GetDescendants()) do
                                    if descendant:IsA("TextLabel") or descendant:IsA("TextButton") then
                                        local attribute = descendant:GetAttribute("YoutSourceText") or descendant.Text
                                        descendant:SetAttribute("YoutSourceText", attribute)
                                        local entry = en[attribute]

                                        if entry then
                                            descendant.Text = entry
                                        end
                                    end
                                end
                            end
                        end
                    end

                    getTime = tick
                    clamp = math.clamp
                    floor = math.floor
                    huge = math.huge
                    sqrt = math.sqrt
                    vector = Vector3.new
                    vector2 = Vector3.zero
                    cframe = CFrame.new
                    cframe2 = CFrame.lookAt
                    raycastParams = RaycastParams.new

                    do
                        local players = nil
                        local counter = 0

                        getCachedPlayers = function()
                            local time = getTime()
                            if players and time - counter < 0.03 then
                                return players
                            end
                            players = Players:GetPlayers()
                            counter = time
                            return players
                        end
                    end
                end

                do
                    do
                        waitForCharacterReady = function(instance, value)
                            local time = getTime() + (value or 5)

                            while not instance or not instance.Parent or not instance:FindFirstChild("HumanoidRootPart") or not instance:FindFirstChildOfClass("Humanoid") do
                                if time < getTime() then
                                    return false
                                end
                                task.wait(0.05)
                            end

                            return true
                        end

                        NORMAL_SPEED = 60
                        CARRY_SPEED = 29
                        LAGGER_SPEED = 15
                        LAGGER_CARRY_SPEED = 24.5
                        MEDUSA_COOLDOWN = 25
                        BAT_AIMBOT_SPEED = 58
                        BYPASS_AIMBOT_SPEED = 60

                        do
                            CONFIG_FILE = "Yout_" .. tostring(localPlayer.UserId) .. ".json"
                        end
                    end

                    BAT_V2_SPEED = 60
                    BAT_V2_HIT_DIST = 4.5
                    BAT_V2_LEAD_STUDS = 3
                    YOUT_BAT_V2_BODY_LOCK_RANGE = 40
                    _isDraggingButton = false
                    backgroundIndex = 1

                    backgroundImages = {
                        "134486176736733",
                        "77738409157822",
                        "77762385200979",
                        "90755720348427",
                        "114788319178517",
                        "102432951232679",
                    }

                    backgroundImageTransparency = 0
                    backgroundMode = "Background 1"
                    backgroundSelectorLabel = nil
                    floatingButtonScale = 1
                    _floatingUIScales = {}

                    applyImageAsset = function(instance, enabled)
                        if not instance or not enabled then
                            return
                        end
                        local text = tostring(enabled)
                        local image = "rbxassetid://" .. text
                        instance.Image = image
                        instance.ImageTransparency = 0

                        task.spawn(function()
                            local success, result = pcall(function()
                                return game:GetObjects(image)
                            end)

                            success = success and type(result) == "table"
                            local texture = nil

                            if success then
                                texture = nil

                                for _, entry in ipairs(result) do
                                    if entry:IsA("Decal") or entry:IsA("Texture") then
                                        if entry.Texture and entry.Texture ~= "" then
                                            texture = entry.Texture
                                        end
                                    elseif entry:IsA("ImageLabel") or entry:IsA("ImageButton") then
                                        if entry.Image and entry.Image ~= "" then
                                            texture = entry.Image
                                        end
                                    end

                                    if not texture then
                                        for _, descendant in ipairs(entry:GetDescendants()) do
                                            if descendant:IsA("Decal") or descendant:IsA("Texture") then
                                                if descendant.Texture and descendant.Texture ~= "" then
                                                    texture = descendant.Texture
                                                    break
                                                end
                                            elseif descendant:IsA("ImageLabel") or descendant:IsA("ImageButton") then
                                                if descendant.Image and descendant.Image ~= "" then
                                                    texture = descendant.Image
                                                    break
                                                end
                                            end
                                        end
                                    end

                                    pcall(function()
                                        entry:Destroy()
                                    end)

                                    if not texture then
                                        continue
                                    end
                                    break
                                end
                            end

                            if instance and instance.Parent and texture and texture ~= "" then
                                instance.Image = texture
                            end

                            pcall(function()
                                game:GetService("ContentProvider"):PreloadAsync({ instance })
                            end)

                            task.wait(1.25)

                            if instance and instance.Parent then
                                local isActive = false

                                pcall(function()
                                    isActive = instance.IsLoaded
                                end)

                                if not isActive then
                                    instance.Image = "rbxthumb://type=Asset&id=" .. text .. "&w=420&h=420"

                                    pcall(function()
                                        game:GetService("ContentProvider"):PreloadAsync({ instance })
                                    end)
                                end
                            end
                        end)
                    end

                    applyBackgroundMode = function(mode)
                        backgroundMode = mode == "None" and "None" or "Background 1"

                        if main then
                            main.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
                            main.BackgroundTransparency = backgroundMode == "None" and 0 or 1
                            local backgroundImage = main:FindFirstChild("BackgroundImage")

                            if backgroundImage then
                                if backgroundMode == "None" then
                                    backgroundImage.ImageTransparency = 1
                                else
                                    backgroundImage.ImageTransparency = 0
                                    applyImageAsset(backgroundImage, backgroundImages[backgroundIndex])
                                end
                            end

                            local scriptHeader = main:FindFirstChild("ScriptHeader")
                            scriptHeader = scriptHeader and scriptHeader:FindFirstChild("LogoArea")
                            scriptHeader = scriptHeader and scriptHeader:FindFirstChild("ScriptLogo")

                            if scriptHeader then
                                if backgroundMode == "None" then
                                    applyImageAsset(scriptHeader, "107332160160150")
                                    scriptHeader.AnchorPoint = Vector2.new(0.5, 0.5)
                                    scriptHeader.Position = UDim2.new(0.5, 0, 0.5, 0)
                                else
                                    applyImageAsset(scriptHeader, "96857354857122")
                                    scriptHeader.AnchorPoint = Vector2.new(0, 0.5)
                                    scriptHeader.Position = UDim2.new(0.5, -72, 0.5, 0)
                                end
                            end
                        end

                        if backgroundSelectorLabel then
                            backgroundSelectorLabel.Text = backgroundMode
                        end
                    end

                    themeColors = {
                        Gray = Color3.fromRGB(180, 180, 190),
                        ["Purple"] = Color3.fromRGB(160, 100, 220),
                        Blue = Color3.fromRGB(80, 150, 255),
                        Pink = Color3.fromRGB(255, 120, 180),
                        Green = Color3.fromRGB(80, 220, 120),
                        Vanilla = Color3.fromRGB(212, 180, 135),
                    }

                    currentColorTheme = "Pink"
                    selectedColor = themeColors["Pink"]

                    getThemeColor = function()
                        return selectedColor
                    end

                    youtGradient = function(color2)
                        return ColorSequence.new({
                            ColorSequenceKeypoint.new(0, color2:Lerp(Color3.new(1, 1, 1), 0.55)),
                            ColorSequenceKeypoint.new(0.45, color2),
                            ColorSequenceKeypoint.new(1, color2:Lerp(Color3.new(0, 0, 0), 0.35)),
                        })
                    end

                    color = Color3.fromRGB(255, 70, 160)

                    createThemeGradient = function()
                        return ColorSequence.new({
                            ColorSequenceKeypoint.new(0, Color3.fromRGB(155, 18, 86)),
                            ColorSequenceKeypoint.new(0.18, Color3.fromRGB(255, 62, 151)),
                            ColorSequenceKeypoint.new(0.36, Color3.fromRGB(255, 146, 205)),
                            ColorSequenceKeypoint.new(0.53, Color3.fromRGB(255, 255, 255)),
                            ColorSequenceKeypoint.new(0.6, Color3.fromRGB(255, 128, 194)),
                            ColorSequenceKeypoint.new(0.8, Color3.fromRGB(255, 55, 145)),
                            ColorSequenceKeypoint.new(1, Color3.fromRGB(118, 10, 72)),
                        })
                    end

                    do
                        local instance = setmetatable({}, { __mode = "k" })
                        local connection = nil

                        applyThemeGradient = function(gradient, enabled, value)
                            if not gradient then
                                return
                            end

                            if enabled then
                                instance[gradient] = value or gradient.Rotation or 0
                                gradient.Color = createThemeGradient()
                                gradient.Rotation = value or gradient.Rotation or 0
                                gradient.Offset = Vector2.new(-1.15, 0)

                                if not connection then
                                    connection = RunService.Heartbeat:Connect(function()
                                        local amount = tick() * 1.6
                                        local isActive = false

                                        for entry, entry2 in pairs(instance) do
                                            if entry and entry.Parent then
                                                entry.Rotation = entry2 or entry.Rotation
                                                entry.Offset = Vector2.new(amount % 2.6 / 1.3 - 1, 0)
                                                isActive = true
                                            else
                                                instance[entry] = nil
                                            end
                                        end

                                        if not isActive and connection then
                                            connection:Disconnect()
                                            connection = nil
                                        end
                                    end)
                                end
                            else
                                instance[gradient] = nil
                                gradient.Offset = Vector2.new(0, 0)
                            end
                        end
                    end
                end

                youtGradientSoft = function(color2)
                    return ColorSequence.new({
                        ColorSequenceKeypoint.new(0, color2:Lerp(Color3.new(1, 1, 1), 0.75)),
                        ColorSequenceKeypoint.new(0.5, color2:Lerp(Color3.new(1, 1, 1), 0.25)),
                        ColorSequenceKeypoint.new(1, color2:Lerp(Color3.new(0, 0, 0), 0.15)),
                    })
                end

                youtGradientDark = function(color2)
                    return ColorSequence.new({
                        ColorSequenceKeypoint.new(0, color2:Lerp(Color3.fromRGB(0, 0, 0), 0.35)),
                        ColorSequenceKeypoint.new(0.55, color2:Lerp(Color3.fromRGB(0, 0, 0), 0.65)),
                        ColorSequenceKeypoint.new(1, color2:Lerp(Color3.fromRGB(0, 0, 0), 0.8)),
                    })
                end

                applyYoutGradientToLabel = function(instance, value)
                    if not instance then
                        return
                    end
                    local uiGradient = instance:FindFirstChildOfClass("UIGradient") or Instance.new("UIGradient", instance)
                    uiGradient.Rotation = 0
                    uiGradient.Color = youtGradient(value)
                end

                do
                    local counter = 0
                    local value = nil

                    applyColorTheme = function(index)
                        local entry = themeColors[index]
                        if not entry then
                            return
                        end
                        currentColorTheme = index
                        selectedColor = entry
                        updateAllUIThemeColors(entry)
                        saveAllSettings()
                    end

                    _uicStroke = nil
                    _uicAvatarStroke = nil
                    _uicHandle = nil
                    _uicLine = nil

                    updateAllUIThemeColors = function(color2)
                        local time = getTime()
                        if color2 == value and time - counter < 0.1 then
                            return
                        end
                        counter = time
                        value = color2

                        if progressFill then
                            progressFill.BackgroundColor3 = Color3.fromRGB(255, 52, 154)
                            local uiGradient = progressFill:FindFirstChildOfClass("UIGradient")

                            if uiGradient then
                                uiGradient.Color = ColorSequence.new({
                                    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 126, 192)),
                                    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 92, 154)),
                                    ColorSequenceKeypoint.new(1, Color3.fromRGB(190, 20, 102)),
                                })
                                uiGradient.Rotation = 0
                            end
                        end

                        if pbFrame then
                            local color3 = Color3.fromRGB(255, 82, 168)
                            local uiStroke = pbFrame:FindFirstChild("OuterStroke") or pbFrame:FindFirstChildOfClass("UIStroke")

                            if uiStroke then
                                uiStroke.Color = color3
                            end

                            local discordText = pbFrame:FindFirstChild("DiscordText", true)

                            if discordText then
                                discordText.TextColor3 = Color3.fromRGB(255, 140, 200)
                            end

                            local pingNeon = pbFrame:FindFirstChild("PingNeon", true)

                            if pingNeon then
                                pingNeon.TextColor3 = Color3.fromRGB(255, 122, 188)
                            end

                            local pingNeon = pbFrame:FindFirstChild("PingNeon", true)

                            if pingNeon then
                                pingNeon.TextColor3 = Color3.fromRGB(255, 122, 188)
                            end

                            local divider = pbFrame:FindFirstChild("Divider", true)

                            if divider and divider:IsA("Frame") then
                                divider.BackgroundColor3 = color3
                            end
                        end

                        if _uicStroke then
                            _uicStroke.Color = color2
                        end

                        if _uicAvatarStroke then
                            _uicAvatarStroke.Color = color2
                        end

                        if _uicHandle then
                            _uicHandle.TextColor3 = color2
                        end

                        if _uicLine then
                            _uicLine.BackgroundColor3 = color2
                        end

                        local function recolorSpeedLabels(instance)
                            for _, descendant in ipairs(instance:GetDescendants()) do
                                if descendant:IsA("TextLabel") then
                                    if descendant.Name == "DiscordText" or descendant.Name == "SpeedLabel" then
                                        descendant.TextColor3 = color2
                                    end
                                end

                                if descendant:IsA("UIStroke") then
                                    if descendant.Color == Color3.fromRGB(180, 180, 190) then
                                        descendant.Color = color2
                                    end
                                end
                            end
                        end

                        if gui then
                            recolorSpeedLabels(gui)
                        end

                        if tpBatFloatingButton then
                            paintFloatingBtn(tpBatFloatingButton:FindFirstChild("Frame"), batDesyncTpEnabled)
                        end

                        for _, value in ipairs((tabButtons or {})) do
                            value.TextColor3 = Color3.fromRGB(255, 255, 255)
                            value.TextTransparency = 0
                            value.BackgroundTransparency = 1
                            local tabSurface = value:FindFirstChild("TabSurface")

                            if tabSurface then
                                tabSurface.ClipsDescendants = true
                            end
                        end

                        if main then
                            local youtRightRail = main:FindFirstChild("YoutRightRail")
                            youtRightRail = youtRightRail and youtRightRail:FindFirstChild("AvatarRing")
                            youtRightRail = youtRightRail and youtRightRail:FindFirstChildOfClass("UIStroke")

                            if youtRightRail then
                                youtRightRail.Color = color2
                            end
                        end

                        if _G.__YoutRefreshESPTheme then
                            pcall(_G.__YoutRefreshESPTheme, color2)
                        end

                        if main then
                            local frame = main:FindFirstChild("Frame")

                            if frame then
                                for _, descendant in ipairs(frame:GetDescendants()) do
                                    if descendant:IsA("UIStroke") and descendant.Color == Color3.fromRGB(180, 180, 190) then
                                        descendant.Color = color2
                                    end
                                end
                            end
                        end

                        if colorSelectorLabel then
                            colorSelectorLabel.Text = currentColorTheme
                            colorSelectorLabel.TextColor3 = color2
                        end

                        if _G._youtStealSlide then
                            _G._youtStealSlide.BackgroundColor3 = color2
                            local uiGradient = _G._youtStealSlide:FindFirstChildOfClass("UIGradient")

                            if uiGradient then
                                uiGradient.Color = youtGradient(color2)
                            end

                            local uiStroke = _G._youtStealSlide:FindFirstChildOfClass("UIStroke")

                            if uiStroke then
                                uiStroke.Color = color2
                            end
                        end

                        if miniBtn then
                            local uiStroke = miniBtn:FindFirstChildOfClass("UIStroke")

                            if uiStroke then
                                uiStroke.Color = color2
                            end
                        end

                        if mobilePanel then
                            for _, child in ipairs(mobilePanel:GetChildren()) do
                                if child:IsA("TextButton") and child:FindFirstChild("BtnGrad") then
                                    paintFloatingBtn(child, child:GetAttribute("MobActive") == true)
                                end
                            end
                        end
                    end
                end
            end

            do
                local data

                do
                    data = {
                        body = {
                            10725826963,
                            86500008,
                            86500054,
                            86500036,
                            86500064,
                            86500078,
                        },
                        aplicarCuerpo = true,
                    }

                    do
                        local items = {}
                        local data2 = { id = 103227869700418, offset = cframe(0, 0, 0) }
                        local data3 = { id = 84952305140948, offset = cframe(0, 0, 0) }

                        local data4 = {
                            id = 122465238537030,
                            offset = cframe(0, 0, 0),
                        }

                        items[1] = data2
                        items[2] = data3
                        items[3] = data4
                        data.items = items
                    end
                end

                data.shirt = nil
                data.pants = "rbxassetid://78591690208112"
                data.skinColor = Color3.fromRGB(234, 184, 146)
                data.headColor = Color3.fromRGB(0, 0, 0)

                do
                    local function loadAssetObjects(target)
                        local success, result = pcall(function()
                            return game:GetObjects("rbxassetid://" .. tostring(target))
                        end)

                        if success then
                            success = typeof(result) == "table"
                        end

                        if success and #result > 0 then
                            return result
                        end

                        local success, result = pcall(function()
                            return game:GetService("InsertService"):LoadAsset(target)
                        end)

                        if success and result then
                            return { result }
                        end
                        return nil
                    end

                    local function collectBaseParts(items)
                        local entries = {}

                        for _, item in ipairs(items) do
                            if item:IsA("BasePart") then
                                entries[#entries + 1] = item
                            end

                            for _, descendant in ipairs(item:GetDescendants()) do
                                if descendant:IsA("BasePart") then
                                    entries[#entries + 1] = descendant
                                end
                            end
                        end

                        return entries
                    end

                    local function findAttachmentByName(instance, value)
                        for _, descendant in ipairs(instance:GetDescendants()) do
                            if descendant:IsA("Attachment") and descendant.Name == value and descendant.Parent:IsA("BasePart") then
                                return descendant
                            end
                        end
                    end

                    local function applyBodyAccessories(parent)
                        local counter = 0

                        for _, value in ipairs(data.body) do
                            local assetObjects = loadAssetObjects(value)

                            if assetObjects then
                                for _, value in ipairs(collectBaseParts(assetObjects)) do
                                    local child = parent:FindFirstChild(value.Name)

                                    if child and child:IsA("BasePart") then
                                        local clone = value:Clone()
                                        clone.Name = "LocalOutfit_" .. "body_" .. value.Name
                                        clone.CanCollide = false
                                        clone.Anchored = false
                                        clone.Massless = true
                                        clone.Size = child.Size
                                        clone.CFrame = child.CFrame
                                        clone.Parent = parent
                                        local weldConstraint = Instance.new("WeldConstraint")
                                        weldConstraint.Part0 = child
                                        weldConstraint.Part1 = clone
                                        weldConstraint.Parent = clone

                                        if child:GetAttribute("YoutOutfitOriginalTransparency") == nil then
                                            child:SetAttribute("YoutOutfitOriginalTransparency", child.Transparency)
                                        end

                                        child.Transparency = 1
                                        counter += 1
                                    end
                                end

                                for _, assetObject in ipairs(assetObjects) do
                                    pcall(function()
                                        assetObject:Destroy()
                                    end)
                                end
                            end
                        end

                        return counter
                    end

                    local function attachAccessory(parent, target)
                        local assetObjects = loadAssetObjects(target.id)
                        if not assetObjects then
                            return false
                        end
                        local value = nil

                        for _, value2 in ipairs(collectBaseParts(assetObjects)) do
                            if value2.Name == "Handle" then
                                value = value2
                                break
                            else
                                value = value or value2
                            end
                        end

                        if not value then
                            for _, assetObject in ipairs(assetObjects) do
                                pcall(function()
                                    assetObject:Destroy()
                                end)
                            end

                            return false
                        end

                        local clone = value:Clone()

                        for _, assetObject in ipairs(assetObjects) do
                            pcall(function()
                                assetObject:Destroy()
                            end)
                        end

                        clone.Name = "LocalOutfit_" .. "item_" .. tostring(target.id)
                        clone.CanCollide = false
                        clone.Anchored = false
                        clone.Massless = true
                        local upperTorso, offset, cFrame

                        if clone:FindFirstChildWhichIsA("WrapLayer") then
                            upperTorso = parent:FindFirstChild("UpperTorso") or parent:FindFirstChild("Torso") or parent:FindFirstChild("HumanoidRootPart")
                            offset = target.offset or cframe()
                            cFrame = cframe()
                        else
                            local attachment = clone:FindFirstChildOfClass("Attachment")
                            local value = attachment and findAttachmentByName(parent, attachment.Name)

                            if value then
                                upperTorso = value.Parent
                                offset = value.CFrame * (target.offset or cframe())
                                cFrame = attachment.CFrame
                            else
                                upperTorso = parent:FindFirstChild("Head")
                                offset = target.offset or cframe(0, 1.4, 0)
                                cFrame = cframe()
                            end
                        end

                        if not upperTorso then
                            clone:Destroy()
                            return false
                        end
                        clone.CFrame = upperTorso.CFrame * offset * cFrame:Inverse()
                        clone.Parent = parent
                        local instance = Instance.new("Weld")
                        instance.Part0 = upperTorso
                        instance.Part1 = clone
                        instance.C0 = offset
                        instance.C1 = cFrame
                        instance.Parent = clone
                        return true
                    end

                    applyHomeroOutfit = function(target)
                        local character = target or localPlayer.Character
                        if not character then
                            return
                        end
                        character:WaitForChild("Humanoid", 10)
                        character:WaitForChild("Head", 10)
                        task.wait(0.4)

                        for _, child in ipairs(character:GetChildren()) do
                            if child.Name:sub(1, 12) == "LocalOutfit_" then
                                pcall(function()
                                    child:Destroy()
                                end)
                            end
                        end

                        if data.skinColor then
                            local bodyColors = character:FindFirstChildWhichIsA("BodyColors") or Instance.new("BodyColors")
                            bodyColors.HeadColor3 = data.headColor or data.skinColor
                            bodyColors.TorsoColor3 = data.skinColor

                            bodyColors.LeftArmColor3 = data.skinColor
                            bodyColors.RightArmColor3 = data.skinColor

                            bodyColors.LeftLegColor3 = data.skinColor
                            bodyColors.RightLegColor3 = data.skinColor
                            bodyColors.Parent = character
                        end

                        for _, child in ipairs(character:GetChildren()) do
                            if child:IsA("Accessory") then
                                local handle = child:FindFirstChild("Handle")

                                if handle then
                                    handle.Transparency = 1
                                end
                            end
                        end

                        if data.shirt then
                            local shirt = character:FindFirstChildWhichIsA("Shirt") or Instance.new("Shirt")
                            shirt.Name = "Shirt"
                            shirt.ShirtTemplate = data.shirt
                            shirt.Parent = character
                        end

                        if data.pants then
                            local pants = character:FindFirstChildWhichIsA("Pants") or Instance.new("Pants")
                            pants.Name = "Pants"
                            pants.PantsTemplate = data.pants
                            pants.Parent = character
                        end

                        if data.aplicarCuerpo then
                            applyBodyAccessories(character)
                        end

                        for _, item in ipairs(data.items) do
                            attachAccessory(character, item)
                        end
                    end
                end
            end

            do
                local clearOutfitInstances

                do
                    originalOutfit = nil

                    captureOriginalOutfit = function(instance)
                        if not instance or originalOutfit then
                            return
                        end
                        local data = { bodyColors = nil, shirt = nil, pants = nil, headMesh = nil, headTexture = nil }
                        local bodyColors = instance:FindFirstChildWhichIsA("BodyColors")

                        if bodyColors then
                            data.bodyColors = {
                                head = bodyColors.HeadColor3,
                                torso = bodyColors.TorsoColor3,
                                leftArm = bodyColors.LeftArmColor3,
                                rightArm = bodyColors.RightArmColor3,
                                leftLeg = bodyColors.LeftLegColor3,
                                rightLeg = bodyColors.RightLegColor3,
                            }
                        end

                        local shirt = instance:FindFirstChildWhichIsA("Shirt")

                        if shirt then
                            data.shirt = shirt.ShirtTemplate
                        end

                        local pants = instance:FindFirstChildWhichIsA("Pants")

                        if pants then
                            data.pants = pants.PantsTemplate
                        end

                        local head = instance:FindFirstChild("Head")

                        if head then
                            local specialMesh = head:FindFirstChildWhichIsA("SpecialMesh")

                            if specialMesh and specialMesh.MeshType == Enum.MeshType.FileMesh then
                                data.headMesh = specialMesh.MeshId
                                data.headTexture = specialMesh.TextureId
                            end
                        end

                        originalOutfit = data
                    end

                    clearOutfitInstances = function(parent)
                        if not parent then
                            return
                        end

                        for _, child in ipairs(parent:GetChildren()) do
                            if child.Name:sub(1, 12) == "LocalOutfit_" or child.Name == "AuFfitAccessory" or child.Name == "Korblox_RightLeg" then
                                pcall(function()
                                    child:Destroy()
                                end)
                            elseif child:IsA("CharacterMesh") and child.BodyPart == Enum.BodyPart.Head then
                                pcall(function()
                                    child:Destroy()
                                end)
                            end
                        end

                        for _, descendant in ipairs(parent:GetDescendants()) do
                            if descendant:IsA("BasePart") then
                                local attribute = descendant:GetAttribute("YoutOutfitOriginalTransparency")

                                if attribute ~= nil then
                                    descendant.Transparency = attribute
                                    descendant:SetAttribute("YoutOutfitOriginalTransparency", nil)
                                end

                                local attribute = descendant:GetAttribute("YoutOutfitOriginalLocalTransparency")

                                if attribute ~= nil then
                                    descendant.LocalTransparencyModifier = attribute
                                    descendant:SetAttribute("YoutOutfitOriginalLocalTransparency", nil)
                                end
                            end
                        end

                        if originalOutfit and originalOutfit.bodyColors then
                            local bodyColors = parent:FindFirstChildWhichIsA("BodyColors") or Instance.new("BodyColors")
                            local bodyColors2 = originalOutfit.bodyColors

                            bodyColors.HeadColor3 = bodyColors2.head
                            bodyColors.TorsoColor3 = bodyColors2.torso

                            bodyColors.LeftArmColor3 = bodyColors2.leftArm
                            bodyColors.RightArmColor3 = bodyColors2.rightArm

                            bodyColors.LeftLegColor3 = bodyColors2.leftLeg
                            bodyColors.RightLegColor3 = bodyColors2.rightLeg
                            bodyColors.Parent = parent
                        end

                        local head = parent:FindFirstChild("Head")

                        if head and head:IsA("MeshPart") and head:GetAttribute("YoutOutfitModifiedMeshPart") then
                            pcall(function()
                                head.MeshId = head:GetAttribute("YoutOutfitOriginalMeshId") or ""
                                head.TextureID = head:GetAttribute("YoutOutfitOriginalTextureId") or ""
                            end)

                            head:SetAttribute("YoutOutfitModifiedMeshPart", nil)
                            head:SetAttribute("YoutOutfitOriginalMeshId", nil)
                            head:SetAttribute("YoutOutfitOriginalTextureId", nil)
                        elseif head then
                            local specialMesh = head:FindFirstChildWhichIsA("SpecialMesh")

                            if specialMesh and specialMesh:GetAttribute("YoutOutfitCreatedMesh") then
                                specialMesh:Destroy()
                            elseif specialMesh and specialMesh:GetAttribute("YoutOutfitModifiedMesh") then
                                specialMesh.MeshId = specialMesh:GetAttribute("YoutOutfitOriginalMeshId") or ""
                                specialMesh.TextureId = specialMesh:GetAttribute("YoutOutfitOriginalTextureId") or ""
                                specialMesh:SetAttribute("YoutOutfitModifiedMesh", nil)
                                specialMesh:SetAttribute("YoutOutfitOriginalMeshId", nil)
                                specialMesh:SetAttribute("YoutOutfitOriginalTextureId", nil)
                            end
                        end
                    end

                    do
                        local function clearLocalOutfit(target)
                            local character = target or localPlayer.Character
                            if not character then
                                return
                            end

                            for _, child in ipairs(character:GetChildren()) do
                                if child.Name:sub(1, 12) == "LocalOutfit_" then
                                    pcall(function()
                                        child:Destroy()
                                    end)
                                end
                            end

                            local auFfitAccessory = character:FindFirstChild("AuFfitAccessory")

                            if auFfitAccessory then
                                pcall(function()
                                    auFfitAccessory:Destroy()
                                end)
                            end

                            local korbloxRightLeg = character:FindFirstChild("Korblox_RightLeg")

                            if korbloxRightLeg then
                                pcall(function()
                                    korbloxRightLeg:Destroy()
                                end)
                            end

                            for _, child in ipairs(character:GetChildren()) do
                                if child:IsA("CharacterMesh") and child.BodyPart == Enum.BodyPart.Head then
                                    pcall(function()
                                        child:Destroy()
                                    end)
                                end
                            end

                            local head = character:FindFirstChild("Head")

                            if head then
                                head.Transparency = 0
                                head.CanCollide = true
                                head.LocalTransparencyModifier = 0
                                local face = head:FindFirstChild("face")

                                if face then
                                    face.Transparency = 0
                                end

                                local specialMesh = head:FindFirstChildWhichIsA("SpecialMesh")

                                if specialMesh then
                                    if originalOutfit and originalOutfit.headMesh then
                                        specialMesh.MeshId = originalOutfit.headMesh
                                        specialMesh.TextureId = originalOutfit.headTexture or ""
                                    else
                                        pcall(function()
                                            specialMesh:Destroy()
                                        end)
                                    end
                                end
                            end

                            pcall(function()
                                local neck = character:FindFirstChild("Neck")

                                if neck then
                                    neck.Enabled = true
                                end
                            end)

                            for _, value in ipairs({ "RightUpperLeg", "RightLowerLeg", "RightFoot" }) do
                                local child = character:FindFirstChild(value)

                                if child then
                                    child.Transparency = 0
                                end
                            end

                            if originalOutfit and originalOutfit.bodyColors then
                                local bodyColors = character:FindFirstChildWhichIsA("BodyColors") or Instance.new("BodyColors")
                                local bodyColors2 = originalOutfit.bodyColors
                                bodyColors.HeadColor3 = bodyColors2.head
                                bodyColors.TorsoColor3 = bodyColors2.torso
                                bodyColors.LeftArmColor3 = bodyColors2.leftArm
                                bodyColors.RightArmColor3 = bodyColors2.rightArm
                                bodyColors.LeftLegColor3 = bodyColors2.leftLeg
                                bodyColors.RightLegColor3 = bodyColors2.rightLeg
                                bodyColors.Parent = character
                            end

                            if originalOutfit and originalOutfit.shirt then
                                local shirt = character:FindFirstChildWhichIsA("Shirt") or Instance.new("Shirt")
                                shirt.ShirtTemplate = originalOutfit.shirt
                                shirt.Parent = character
                            end

                            if originalOutfit and originalOutfit.pants then
                                local pants = character:FindFirstChildWhichIsA("Pants") or Instance.new("Pants")
                                pants.PantsTemplate = originalOutfit.pants
                                pants.Parent = character
                            end

                            for _, child in ipairs(character:GetChildren()) do
                                if child:IsA("Accessory") then
                                    local handle = child:FindFirstChild("Handle")

                                    if handle then
                                        handle.Transparency = 0
                                    end
                                end
                            end
                        end

                        outfitPresets = {}

                        local data = {
                            accessory = 10159600649,
                            offset = vector(0, 1, -0.2),
                            shirt = "http://www.roblox.com/asset/?id=9683332638",
                            pants = "http://www.roblox.com/asset/?id=93182020184041",
                            headMesh = "http://www.roblox.com/asset/?id=134079402",
                            headTexture = "http://www.roblox.com/asset/?id=133940918 ",
                            korblox = "none",
                            label = "Outfit 1",
                            headlessKorblox = true,
                        }

                        local data2 = {
                            accessory = 1744060292,
                            offset = vector(0, 1.3, -0.2),
                            shirt = "http://www.roblox.com/asset/?id=9683332638",
                            pants = "http://www.roblox.com/asset/?id=93182020184041",
                            headMesh = "http://www.roblox.com/asset/?id=134079402",
                            headTexture = "http://www.roblox.com/asset/?id=133940918 ",
                            korblox = "none",
                            label = "Outfit 2",
                            headlessKorblox = true,
                        }

                        local data3 = {
                            accessory = 8349240186,
                            offset = vector(0, 0.9, 0),
                            shirt = "http://www.roblox.com/asset/?id=11926549070",
                            pants = "http://www.roblox.com/asset/?id=13189494471",
                            headMesh = "https://assetdelivery.roblox.com/v1/asset/?id=16673245747",
                            headTexture = nil,
                            korblox = "none",
                            label = "Outfit 3",
                            headlessKorblox = true,
                        }

                        local data4 = {
                            accessory = 121097973925756,
                            offset = vector(0, 0.9, 0),
                            shirt = "http://www.roblox.com/asset/?id=123181702116947",
                            pants = "http://www.roblox.com/asset/?id=93330291631062",
                            headMesh = "http://www.roblox.com/asset/?id=134079402",
                            headTexture = "http://www.roblox.com/asset/?id=133940918 ",
                            korblox = "none",
                            label = "Outfit 4",
                            headlessKorblox = true,
                        }

                        outfitPresets[1] = { label = "OFF", customApply = clearLocalOutfit }
                        outfitPresets[2] = data
                        outfitPresets[3] = data2
                        outfitPresets[4] = data3
                        outfitPresets[5] = data4
                        outfitPresets[6] = {
                            label = "Homero Chino",
                            customApply = applyHomeroOutfit,
                        }
                    end
                end

                outfitIndex = 1
                textLabel = nil

                do
                    local function loadAssetObjects(target)
                        local success, result = pcall(function()
                            return game:GetObjects("rbxassetid://" .. tostring(target))
                        end)

                        if success and typeof(result) == "table" and #result > 0 then
                            return result
                        end

                        local success, result = pcall(function()
                            return game:GetService("InsertService"):LoadAsset(target)
                        end)

                        if success and result then
                            return { result }
                        end
                        return nil
                    end

                    local function restoreOriginalAppearance(parent)
                        if not parent then
                            return
                        end

                        pcall(function()
                            localPlayer.CharacterAvatarType = Enum.AvatarType.R6
                        end)

                        local head = parent:FindFirstChild("Head")

                        if head then
                            if head:GetAttribute("YoutOutfitOriginalTransparency") == nil then
                                head:SetAttribute("YoutOutfitOriginalTransparency", head.Transparency)
                                head:SetAttribute("YoutOutfitOriginalLocalTransparency", head.LocalTransparencyModifier)
                            end

                            head.Transparency = 1
                            head.CanCollide = false
                            head.LocalTransparencyModifier = 1
                            local face = head:FindFirstChild("face")

                            if face then
                                face.Transparency = 1
                            end
                        end

                        pcall(function()
                            local neck = parent:FindFirstChild("Neck")

                            if neck then
                                neck.Enabled = false
                            end
                        end)

                        for _, child in pairs(parent:GetChildren()) do
                            if child:IsA("Accessory") then
                                local weld = child:FindFirstChildWhichIsA("Weld") or child:FindFirstChildWhichIsA("WeldConstraint") or child:FindFirstChildWhichIsA("Motor6D")

                                if weld then
                                    local part = weld.Part0
                                    local part2 = weld.Part1

                                    if part and part.Name == "Head" or part2 and part2.Name == "Head" then
                                        for _, descendant in ipairs(child:GetDescendants()) do
                                            if descendant:IsA("BasePart") then
                                                if descendant:GetAttribute("YoutOutfitOriginalTransparency") == nil then
                                                    descendant:SetAttribute("YoutOutfitOriginalTransparency", descendant.Transparency)
                                                    descendant:SetAttribute("YoutOutfitOriginalLocalTransparency", descendant.LocalTransparencyModifier)
                                                end

                                                descendant.Transparency = 1
                                                descendant.LocalTransparencyModifier = 1
                                            end
                                        end
                                    end
                                end
                            end
                        end

                        local data = {
                            id = "rbxassetid://139607718",
                            targetBodyPart = "RightUpperLeg",
                            partsToHide = { "RightUpperLeg", "RightLowerLeg", "RightFoot" },
                            scale = vector(1, 1, 1),
                            offset = cframe(0, 0, 0),
                        }

                        local child = parent:FindFirstChild(data.targetBodyPart)

                        if child then
                            local korbloxRightLeg = parent:FindFirstChild("Korblox_RightLeg")

                            if korbloxRightLeg then
                                korbloxRightLeg:Destroy()
                            end

                            for _, value in ipairs(data.partsToHide) do
                                local child2 = parent:FindFirstChild(value)

                                if child2 and child2:IsA("BasePart") then
                                    if child2:GetAttribute("YoutOutfitOriginalTransparency") == nil then
                                        child2:SetAttribute("YoutOutfitOriginalTransparency", child2.Transparency)
                                    end

                                    child2.Transparency = 1
                                end
                            end

                            local success, result = pcall(function()
                                return game:GetObjects(data.id)
                            end)

                            if success and result and #result > 0 then
                                local entry = result[1]
                                entry.Name = "Korblox_RightLeg"
                                local isBasePart = entry:IsA("BasePart") and entry or entry:FindFirstChildWhichIsA("BasePart", true)

                                if isBasePart then
                                    isBasePart.Size = isBasePart.Size * data.scale
                                    isBasePart.CanCollide = false
                                    isBasePart.CFrame = child.CFrame * data.offset
                                    local weldConstraint = Instance.new("WeldConstraint")
                                    weldConstraint.Part0 = child
                                    weldConstraint.Part1 = isBasePart
                                    weldConstraint.Parent = isBasePart
                                    entry.Parent = parent
                                end
                            end
                        end
                    end

                    applyOutfitByIndex = function(index)
                        local entry = outfitPresets[index]
                        if not entry then
                            return
                        end
                        local character = localPlayer.Character
                        if not character then
                            return
                        end
                        clearOutfitInstances(character)

                        if entry.customApply then
                            entry.customApply(character)

                            if textLabel then
                                textLabel.Text = entry.label
                            end

                            return
                        end

                        character:WaitForChild("Head", 5)
                        local head = character:FindFirstChild("Head")
                        if not head then
                            return
                        end

                        for _, child in ipairs(character:GetChildren()) do
                            if child:IsA("CharacterMesh") and child.BodyPart == Enum.BodyPart.Head then
                                pcall(function()
                                    child:Destroy()
                                end)
                            end
                        end

                        local isActive = false

                        if head:IsA("MeshPart") then
                            isActive = pcall(function()
                                if not head:GetAttribute("YoutOutfitModifiedMeshPart") then
                                    head:SetAttribute("YoutOutfitOriginalMeshId", head.MeshId)
                                    head:SetAttribute("YoutOutfitOriginalTextureId", head.TextureID)
                                    head:SetAttribute("YoutOutfitModifiedMeshPart", true)
                                end

                                head.MeshId = entry.headMesh
                                head.TextureID = entry.headTexture or ""
                            end)
                        end

                        if not isActive then
                            local specialMesh = head:FindFirstChildWhichIsA("SpecialMesh")

                            if not specialMesh then
                                specialMesh = Instance.new("SpecialMesh")
                                specialMesh:SetAttribute("YoutOutfitCreatedMesh", true)
                            elseif not specialMesh:GetAttribute("YoutOutfitModifiedMesh") then
                                specialMesh:SetAttribute("YoutOutfitOriginalMeshId", specialMesh.MeshId)
                                specialMesh:SetAttribute("YoutOutfitOriginalTextureId", specialMesh.TextureId)
                                specialMesh:SetAttribute("YoutOutfitModifiedMesh", true)
                            end

                            specialMesh.Parent = head
                            specialMesh.MeshType = Enum.MeshType.FileMesh
                            specialMesh.MeshId = entry.headMesh
                            specialMesh.TextureId = entry.headTexture or ""
                        end

                        if entry.shirt then
                            local shirt = character:FindFirstChildWhichIsA("Shirt") or Instance.new("Shirt")
                            shirt.Name = "Shirt"
                            shirt.ShirtTemplate = entry.shirt
                            shirt.Parent = character
                        end

                        if entry.pants then
                            local pants = character:FindFirstChildWhichIsA("Pants") or Instance.new("Pants")
                            pants.Name = "Pants"
                            pants.PantsTemplate = entry.pants
                            pants.Parent = character
                        end

                        local auFfitAccessory = character:FindFirstChild("AuFfitAccessory")

                        if auFfitAccessory then
                            auFfitAccessory:Destroy()
                        end

                        if entry.accessory and head then
                            local assetObjects = loadAssetObjects(entry.accessory)

                            if assetObjects then
                                local basePart = nil

                                for _, assetObject in ipairs(assetObjects) do
                                    if assetObject:IsA("BasePart") then
                                        basePart = assetObject
                                        break
                                    else
                                        basePart = assetObject:FindFirstChildWhichIsA("BasePart", true)
                                        if not basePart then
                                            basePart = nil
                                            continue
                                        end
                                    end

                                    break
                                end

                                if basePart then
                                    local clone = basePart:Clone()
                                    clone.Name = "AuFfitAccessory"
                                    clone.CanCollide = false
                                    clone.Anchored = false
                                    clone.Massless = true
                                    clone.Parent = character
                                    local instance = Instance.new("Weld")
                                    instance.Part0 = head
                                    instance.Part1 = clone
                                    instance.C0 = cframe(entry.offset)
                                    instance.Parent = clone
                                end

                                for _, assetObject in ipairs(assetObjects) do
                                    pcall(function()
                                        assetObject:Destroy()
                                    end)
                                end
                            end
                        end

                        if entry.headlessKorblox then
                            restoreOriginalAppearance(character)
                        elseif character then
                            local head = character:FindFirstChild("Head")

                            if head then
                                head.Transparency = 0
                                head.CanCollide = true
                                head.LocalTransparencyModifier = 0
                                local face = head:FindFirstChild("face")

                                if face then
                                    face.Transparency = 0
                                end
                            end

                            pcall(function()
                                local neck = character:FindFirstChild("Neck")

                                if neck then
                                    neck.Enabled = true
                                end
                            end)

                            for _, value in ipairs({ "RightUpperLeg", "RightLowerLeg", "RightFoot" }) do
                                local child = character:FindFirstChild(value)

                                if child then
                                    child.Transparency = 0
                                end
                            end

                            local korblox_RightLeg = character:FindFirstChild("Korblox_RightLeg")

                            if korblox_RightLeg then
                                korblox_RightLeg:Destroy()
                            end
                        end

                        if textLabel then
                            textLabel.Text = entry.label
                        end
                    end
                end
            end
        end

        local isStealConnectionActive

        do
            do
                do
                    local state, handleJumpRequest, handleJumpHeartbeat

                    do
                        selectedStealMode = "V1"
                        speedMode = false
                        antiRagdollMode = "off"
                        antiDieEnabled = false
                        antiBatEnabled = false
                        antiFlingEnabled = false
                        jumpEnabled = false
                        laggerToggled = false
                        laggerCarryToggled = false
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
                        uiLocked = false
                        mobileButtonsLocked = false
                        uiScaleValue = 78
                        espEnabled = false
                        espLineEnabled = false
                        vividGraphicsEnabled = false
                        _vividEffects = {}
                        setVividVisual = nil
                        hideButtonsEnabled = false
                        setHideButtonsVisual = nil
                        bodyLockEnabled = false
                        bodyLockRange = 20
                        bodyLockRangeBox = nil
                        _bodyLockConn = nil
                        _blSuppressCount = 0
                        _blWasEnabled = false
                        _blRestoreTimer = nil
                        _blSmoothRestore = false
                        savedProgressBarPos = nil
                        savedButtonPositions = {}
                        savedMobilePanelPos = nil
                        tpBatFloatingPos = nil
                        batV2FloatingPos = nil
                        batV2FloatingButton = nil
                        YOUT_BATV2_ENABLED = false

                        pcall(function()
                            if YOUT_BATV2_CONN then
                                YOUT_BATV2_CONN:Disconnect()
                            end
                        end)

                        YOUT_BATV2_CONN = nil
                        YOUT_BATV2_COOLDOWN = false
                        youtBatV2PersistentState = _G.__YoutBatV2PersistentState

                        if type(youtBatV2PersistentState) ~= "table" then
                            youtBatV2PersistentState = {
                                enabled = false,
                                conn = nil,
                                safetyConn = nil,
                                respawnConn = nil,
                                cooldown = false,
                                generation = 0,
                                equipped = false,
                                target = nil,
                                intendedVelocity = Vector3.zero,
                                angularVelocity = nil,
                                attachment = nil,
                            }

                            _G.__YoutBatV2PersistentState = youtBatV2PersistentState
                        else
                            pcall(function()
                                if youtBatV2PersistentState.conn then
                                    youtBatV2PersistentState.conn:Disconnect()
                                end

                                if youtBatV2PersistentState.safetyConn then
                                    youtBatV2PersistentState.safetyConn:Disconnect()
                                end

                                if youtBatV2PersistentState.respawnConn then
                                    youtBatV2PersistentState.respawnConn:Disconnect()
                                end

                                if youtBatV2PersistentState.bodyLockConn then
                                    youtBatV2PersistentState.bodyLockConn:Disconnect()
                                end

                                if youtBatV2PersistentState.angularVelocity and youtBatV2PersistentState.angularVelocity.Parent then
                                    youtBatV2PersistentState.angularVelocity:Destroy()
                                end

                                if youtBatV2PersistentState.attachment and youtBatV2PersistentState.attachment.Parent then
                                    youtBatV2PersistentState.attachment:Destroy()
                                end
                            end)

                            youtBatV2PersistentState.enabled = false
                            youtBatV2PersistentState.conn = nil
                            youtBatV2PersistentState.safetyConn = nil
                            youtBatV2PersistentState.respawnConn = nil
                            youtBatV2PersistentState.bodyLockConn = nil
                            youtBatV2PersistentState.cooldown = false
                            youtBatV2PersistentState.equipped = false
                            youtBatV2PersistentState.target = nil
                            youtBatV2PersistentState.intendedVelocity = Vector3.zero
                            youtBatV2PersistentState.angularVelocity = nil
                            youtBatV2PersistentState.attachment = nil
                            youtBatV2PersistentState.generation = (youtBatV2PersistentState.generation or 0) + 1
                        end

                        instaResetFloatingPos = nil
                        instaResetFloatingButton = nil
                        neonWeatherEnabled = false
                        skyTheme = "Off"
                        skySelectorLabel = nil
                        _originalLighting = nil
                        setNeonWeatherVisual = nil
                        currentAnimPack = "Off"
                        originalTryardAnims = nil
                        tryardHeartbeatConn = nil
                        animSelectorLabel = nil
                        lastMoveDir = vector2
                        game:GetService("CoreGui")

                        state = {
                            enabled = false,
                            jumpPower = 55,
                            minVelocity = 35,
                            fallClamp = -120,
                            jumpConn = nil,
                            heartbeatConn = nil,
                        }

                        do
                            local function setJumpVelocity(part)
                                if not part then
                                    return
                                end

                                pcall(function()
                                    part.Velocity = vector(part.Velocity.X, state.jumpPower, part.Velocity.Z)
                                end)
                            end

                            handleJumpRequest = function()
                                if not state.enabled then
                                    return
                                end
                                local character = localPlayer.Character
                                if not character then
                                    return
                                end
                                local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")

                                if humanoidRootPart then
                                    setJumpVelocity(humanoidRootPart)
                                end
                            end

                            handleJumpHeartbeat = function()
                                if not state.enabled then
                                    return
                                end
                                local character = localPlayer.Character
                                if not character then
                                    return
                                end
                                local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
                                if not humanoidRootPart then
                                    return
                                end
                                local humanoid = character:FindFirstChildOfClass("Humanoid")
                                if not humanoid then
                                    return
                                end

                                if (UserInputService:IsKeyDown(Enum.KeyCode.Space) or humanoid.Jump == true) and humanoidRootPart.Velocity.Y < state.minVelocity then
                                    setJumpVelocity(humanoidRootPart)
                                end

                                if humanoidRootPart.Velocity.Y < state.fallClamp then
                                    humanoidRootPart.Velocity = vector(humanoidRootPart.Velocity.X, state.fallClamp, humanoidRootPart.Velocity.Z)
                                end
                            end
                        end
                    end

                    do
                        local function connectJumpEvents()
                            if state.jumpConn then
                                state.jumpConn:Disconnect()
                            end

                            if state.heartbeatConn then
                                state.heartbeatConn:Disconnect()
                            end

                            state.jumpConn = UserInputService.JumpRequest:Connect(handleJumpRequest)
                            state.heartbeatConn = RunService.Heartbeat:Connect(handleJumpHeartbeat)
                        end

                        state.start = function()
                            if state.enabled then
                                return
                            end
                            state.enabled = true
                            connectJumpEvents()
                        end
                    end

                    state.stop = function()
                        state.enabled = false

                        if state.jumpConn then
                            state.jumpConn:Disconnect()
                            state.jumpConn = nil
                        end

                        if state.heartbeatConn then
                            state.heartbeatConn:Disconnect()
                            state.heartbeatConn = nil
                        end
                    end

                    state.setJumpPower = function(target)
                        state.jumpPower = clamp(tonumber(target) or 55, 10, 200)
                    end

                    state.isRunning = function()
                        return state.enabled == true
                    end

                    pcall(state.start)
                end

                do
                    getActiveMoveSpeed = function()
                        if laggerCarryToggled then
                            return LAGGER_CARRY_SPEED
                        end

                        if laggerToggled then
                            return LAGGER_SPEED
                        end

                        if speedMode then
                            return CARRY_SPEED
                        end
                        return NORMAL_SPEED
                    end

                    getSpeedModeName = function()
                        if laggerToggled or laggerCarryToggled then
                            return "LAGGER"
                        end

                        if speedMode then
                            return "CARRY"
                        end
                        return "NORMAL"
                    end

                    youtSpeedHookState = _G.__YoutSpeedHookState

                    if type(youtSpeedHookState) ~= "table" then
                        youtSpeedHookState = {
                            hooked = false,
                            velChecked = setmetatable({}, { __mode = "k" }),
                            root = nil,
                            v = vector2,
                        }

                        _G.__YoutSpeedHookState = youtSpeedHookState
                    end

                    velChecked = youtSpeedHookState.velChecked
                    velocityWriteLog = {}

                    installVelocityHook = function(root)
                        if not root then
                            return
                        end
                        youtSpeedHookState.root = root
                        velChecked[root] = true
                        if youtSpeedHookState.hooked then
                            return
                        end
                        local isActive = type(getrawmetatable) ~= "function" or type(setreadonly) ~= "function"

                        if not isActive then
                            isActive = type(newcclosure) ~= "function"
                        end

                        if isActive or type(checkcaller) ~= "function" then
                            return
                        end

                        if not pcall(function()
                            local metatable = getrawmetatable(game)
                            if not metatable then
                                return
                            end
                            setreadonly(metatable, false)
                            local value = rawget(metatable, "__index")
                            local value2 = rawget(metatable, "__newindex")

                            local function isVelocityProperty(instance, value3)
                                local text = tostring(value3)
                                if text ~= "AssemblyLinearVelocity" and text ~= "Velocity" then
                                    return false
                                end

                                if typeof(instance) ~= "Instance" or not instance:IsA("BasePart") then
                                    return false
                                end
                                local name = instance.Name
                                if name ~= "HumanoidRootPart" and name ~= "Torso" and name ~= "UpperTorso" then
                                    return false
                                end
                                local character = localPlayer.Character
                                return character ~= nil and instance:IsDescendantOf(character)
                            end

                            local isActive = type(value) == "function"

                            if not isActive then
                                isActive = type(value) == "table"
                            end

                            if isActive then
                                metatable.__index = newcclosure(function(target, index)
                                    if not checkcaller() then
                                        local success, result = pcall(isVelocityProperty, target, index)
                                        if success and result then
                                            return youtSpeedHookState.v
                                        end
                                    end

                                    if type(value) == "function" then
                                        return value(target, index)
                                    end
                                    return value[index]
                                end)
                            end

                            if type(value2) == "function" then
                                metatable.__newindex = newcclosure(function(target, value, value3)
                                    if not checkcaller() then
                                        local success, result = pcall(isVelocityProperty, target, value)
                                        if success and result then
                                            youtSpeedHookState.v = value3
                                            return
                                        end
                                    end

                                    return value2(target, value, value3)
                                end)
                            end

                            setreadonly(metatable, true)
                            youtSpeedHookState.hooked = true
                            end) then
                            youtSpeedHookState.hooked = false
                        end
                    end

                    attachVelocityHookToRoot = function(instance)
                        velChecked = setmetatable({}, { __mode = "k" })
                        youtSpeedHookState.velChecked = velChecked
                        if not instance then
                            youtSpeedHookState.root = nil
                            return nil
                        end
                        local humanoidRootPart = instance:WaitForChild("HumanoidRootPart", 5)

                        if humanoidRootPart then
                            youtSpeedHookState.root = humanoidRootPart
                            velChecked[humanoidRootPart] = true
                        end

                        return humanoidRootPart
                    end

                    if localPlayer.Character then
                        local value = attachVelocityHookToRoot(localPlayer.Character)
                        installVelocityHook(value)
                    end

                    isHumanoidIncapacitated = function(humanoid)
                        if not humanoid then
                            return true
                        end
                        local state = humanoid:GetState()
                        return humanoid.PlatformStand or state == Enum.HumanoidStateType.Physics or state == Enum.HumanoidStateType.Ragdoll or state == Enum.HumanoidStateType.FallingDown
                    end

                    do
                        local random = Random.new()

                        applyBatHitVelocity = function(vector3, value, part)
                            if not part or not part.Parent then
                                return
                            end

                            if batDesyncTpEnabled or autoBatEnabled or youtBatV2PersistentState.enabled then
                                return
                            end

                            if type(value) ~= "number" or value ~= value or value <= 0 or value == math.huge then
                                return
                            end
                            local y = part.AssemblyLinearVelocity.Y

                            if vector3 and vector3.Magnitude > 0.05 then
                                pcall(function()
                                    if part.SetNetworkOwner then
                                        part:SetNetworkOwner(localPlayer)
                                    end
                                end)

                                local unit = vector3.Unit
                                local value2 = random:NextNumber(-0.003, 0.003)
                                local value3 = random:NextNumber(-0.003, 0.003)
                                youtSpeedHookState.v = vector(unit.X * 16 + value2, y, unit.Z * 16 + value3)
                                part.AssemblyLinearVelocity = vector(unit.X * value + value2, y, unit.Z * value + value3)
                                _G.__YoutLiveSpeed = { t = os.clock(), v = value }
                            else
                                youtSpeedHookState.v = vector(0, y, 0)
                                part.AssemblyLinearVelocity = vector(0, y, 0)
                            end
                        end
                    end
                end

                do
                    local captureOriginalAnimations

                    do
                        getAutoPathSpeed = function()
                            if laggerCarryToggled or laggerToggled then
                                return LAGGER_SPEED
                            end
                            return NORMAL_SPEED
                        end

                        ANIM_PACKS = {
                            ["Zombie"] = {
                                idle1 = "rbxassetid://616158929",
                                idle2 = "rbxassetid://616160636",
                                walk = "rbxassetid://616168032",
                                run = "rbxassetid://616163682",
                                jump = "rbxassetid://616161997",
                                fall = "rbxassetid://616157476",
                                climb = "rbxassetid://616156119",
                                swim = "rbxassetid://616165109",
                                swimidle = "rbxassetid://616166655",
                            },
                            Ninja = {
                                idle1 = "rbxassetid://656117400",
                                idle2 = "rbxassetid://656117400",
                                walk = "rbxassetid://656121766",
                                run = "rbxassetid://656118852",
                                jump = "rbxassetid://656117878",
                                fall = "rbxassetid://656115606",
                                climb = "rbxassetid://656114359",
                                swim = "rbxassetid://656117400",
                                swimidle = "rbxassetid://656117400",
                            },
                            ["Knight"] = {
                                idle1 = "rbxassetid://657595757",
                                idle2 = "rbxassetid://657595757",
                                walk = "rbxassetid://657552124",
                                run = "rbxassetid://657564596",
                                jump = "rbxassetid://658409194",
                                fall = "rbxassetid://657600338",
                                climb = "rbxassetid://658360781",
                                swim = "rbxassetid://657595757",
                                swimidle = "rbxassetid://657595757",
                            },
                            Elder = {
                                idle1 = "rbxassetid://845397899",
                                idle2 = "rbxassetid://845397899",
                                walk = "rbxassetid://845403856",
                                run = "rbxassetid://845386501",
                                jump = "rbxassetid://845398858",
                                fall = "rbxassetid://845397673",
                                climb = "rbxassetid://845392038",
                                swim = "rbxassetid://845397899",
                                swimidle = "rbxassetid://845397899",
                            },
                            Levitate = {
                                idle1 = "rbxassetid://616006778",
                                idle2 = "rbxassetid://616006778",
                                walk = "rbxassetid://616013216",
                                run = "rbxassetid://616013216",
                                jump = "rbxassetid://616008936",
                                fall = "rbxassetid://616005863",
                                climb = "rbxassetid://616003713",
                                swim = "rbxassetid://616006778",
                                swimidle = "rbxassetid://616006778",
                            },
                            ["Astronaut"] = {
                                idle1 = "rbxassetid://891621366",
                                idle2 = "rbxassetid://891621366",
                                walk = "rbxassetid://891636393",
                                run = "rbxassetid://891636393",
                                jump = "rbxassetid://891627522",
                                fall = "rbxassetid://891617961",
                                climb = "rbxassetid://891609353",
                                swim = "rbxassetid://891621366",
                                swimidle = "rbxassetid://891621366",
                            },
                            ["Pirate"] = {
                                idle1 = "rbxassetid://750781874",
                                idle2 = "rbxassetid://750781874",
                                walk = "rbxassetid://750785693",
                                run = "rbxassetid://750783738",
                                jump = "rbxassetid://750782230",
                                fall = "rbxassetid://750780242",
                                climb = "rbxassetid://750779899",
                                swim = "rbxassetid://750781874",
                                swimidle = "rbxassetid://750781874",
                            },
                            ["Toy"] = {
                                idle1 = "rbxassetid://782841498",
                                idle2 = "rbxassetid://782841498",
                                walk = "rbxassetid://782843345",
                                run = "rbxassetid://782842708",
                                jump = "rbxassetid://782847020",
                                fall = "rbxassetid://782846423",
                                climb = "rbxassetid://782843869",
                                swim = "rbxassetid://782841498",
                                swimidle = "rbxassetid://782841498",
                            },
                            Vampire = {
                                idle1 = "rbxassetid://1083445855",
                                idle2 = "rbxassetid://1083445855",
                                walk = "rbxassetid://1083473930",
                                run = "rbxassetid://1083462077",
                                jump = "rbxassetid://1083455352",
                                fall = "rbxassetid://1083443587",
                                climb = "rbxassetid://1083439238",
                                swim = "rbxassetid://1083445855",
                                swimidle = "rbxassetid://1083445855",
                            },
                            Werewolf = {
                                idle1 = "rbxassetid://1083195517",
                                idle2 = "rbxassetid://1083195517",
                                walk = "rbxassetid://1083178339",
                                run = "rbxassetid://1083216690",
                                jump = "rbxassetid://1083218792",
                                fall = "rbxassetid://1083189019",
                                climb = "rbxassetid://1083182000",
                                swim = "rbxassetid://1083195517",
                                swimidle = "rbxassetid://1083195517",
                            },
                            ["Rthro"] = {
                                idle1 = "rbxassetid://2510196951",
                                idle2 = "rbxassetid://2510196951",
                                walk = "rbxassetid://2510202577",
                                run = "rbxassetid://2510198475",
                                jump = "rbxassetid://2510197830",
                                fall = "rbxassetid://2510195892",
                                climb = "rbxassetid://2510192778",
                                swim = "rbxassetid://2510196951",
                                swimidle = "rbxassetid://2510196951",
                            },
                            ["Stylish"] = {
                                idle1 = "rbxassetid://616136790",
                                idle2 = "rbxassetid://616136790",
                                walk = "rbxassetid://616146177",
                                run = "rbxassetid://616140816",
                                jump = "rbxassetid://616139451",
                                fall = "rbxassetid://616134815",
                                climb = "rbxassetid://616133594",
                                swim = "rbxassetid://616136790",
                                swimidle = "rbxassetid://616136790",
                            },
                        }

                        ANIM_PACK_ORDER = {
                            { "Off", "Off" },
                            { "Zombie", "Zombie" },
                            { "Ninja", "Ninja" },
                            { "Knight", "Knight" },
                            { "Elder", "Elder" },
                            { "Levitate", "Levitate" },
                            { "Astronaut", "Astronaut" },
                            { "Pirate", "Pirate" },
                            { "Toy", "Toy" },
                            { "Vampire", "Vampire" },
                            { "Werewolf", "Werewolf" },
                            { "Rthro", "Rthro" },
                            { "Stylish", "Stylish" },
                        }

                        do
                            local function isKnownAnimationId(target)
                                for _, entry in pairs(ANIM_PACKS) do
                                    for _, entry2 in pairs(entry) do
                                        if entry2 == target then
                                            return true
                                        end
                                    end
                                end

                                return false
                            end

                            captureOriginalAnimations = function(instance)
                                local animate = instance:FindFirstChild("Animate")
                                if not animate then
                                    return
                                end

                                local function getAnimationId(value)
                                    return value and value.AnimationId or nil
                                end

                                local data = {
                                    idle1 = getAnimationId(animate.idle and animate.idle.Animation1),
                                    idle2 = getAnimationId(animate.idle and animate.idle.Animation2),
                                    walk = getAnimationId(animate.walk and animate.walk.WalkAnim),
                                    run = getAnimationId(animate.run and animate.run.RunAnim),
                                    jump = getAnimationId(animate.jump and animate.jump.JumpAnim),
                                    fall = getAnimationId(animate.fall and animate.fall.FallAnim),
                                    climb = getAnimationId(animate.climb and animate.climb.ClimbAnim),
                                    swim = getAnimationId(animate.swim and animate.swim.Swim),
                                    swimidle = getAnimationId(animate.swimidle and animate.swimidle.SwimIdle),
                                }

                                if not isKnownAnimationId(data.walk) then
                                    originalTryardAnims = data
                                end
                            end
                        end
                    end

                    do
                        local function setAnimationPack(text)
                            currentAnimPack = text

                            if animSelectorLabel then
                                animSelectorLabel.Text = text
                            end

                            if text == "Off" then
                                if originalTryardAnims and localPlayer.Character then
                                    local animate = localPlayer.Character:FindFirstChild("Animate")

                                    if animate then
                                        local function setAnimationId(enabled, animationId)
                                            if enabled then
                                                enabled.AnimationId = animationId
                                            end
                                        end

                                        setAnimationId(animate.idle and animate.idle.Animation1, originalTryardAnims.idle1)
                                        setAnimationId(animate.idle and animate.idle.Animation2, originalTryardAnims.idle2)
                                        setAnimationId(animate.walk and animate.walk.WalkAnim, originalTryardAnims.walk)
                                        setAnimationId(animate.run and animate.run.RunAnim, originalTryardAnims.run)
                                        setAnimationId(animate.jump and animate.jump.JumpAnim, originalTryardAnims.jump)
                                        setAnimationId(animate.fall and animate.fall.FallAnim, originalTryardAnims.fall)
                                        setAnimationId(animate.climb and animate.climb.ClimbAnim, originalTryardAnims.climb)
                                        setAnimationId(animate.swim and animate.swim.Swim, originalTryardAnims.swim)
                                        setAnimationId(animate.swimidle and animate.swimidle.SwimIdle, originalTryardAnims.swimidle)
                                    end
                                end

                                if tryardHeartbeatConn then
                                    tryardHeartbeatConn:Disconnect()
                                    tryardHeartbeatConn = nil
                                end

                                return
                            end

                            local entry = ANIM_PACKS[text]
                            if not entry then
                                return
                            end

                            if tryardHeartbeatConn then
                                tryardHeartbeatConn:Disconnect()
                            end

                            tryardHeartbeatConn = RunService.Heartbeat:Connect(function()
                                local character = localPlayer.Character
                                if not character then
                                    return
                                end
                                local animate = character:FindFirstChild("Animate")
                                if not animate then
                                    return
                                end

                                local function setAnimationId(enabled, animationId)
                                    if enabled then
                                        enabled.AnimationId = animationId
                                    end
                                end

                                setAnimationId(animate.idle and animate.idle.Animation1, entry.idle1)
                                setAnimationId(animate.idle and animate.idle.Animation2, entry.idle2)
                                setAnimationId(animate.walk and animate.walk.WalkAnim, entry.walk)
                                setAnimationId(animate.run and animate.run.RunAnim, entry.run)
                                setAnimationId(animate.jump and animate.jump.JumpAnim, entry.jump)
                                setAnimationId(animate.fall and animate.fall.FallAnim, entry.fall)
                                setAnimationId(animate.climb and animate.climb.ClimbAnim, entry.climb)
                                setAnimationId(animate.swim and animate.swim.Swim, entry.swim)
                                setAnimationId(animate.swimidle and animate.swimidle.SwimIdle, entry.swimidle)
                            end)
                        end

                        applyAnimationPack = function(target)
                            local character = localPlayer.Character

                            if character then
                                captureOriginalAnimations(character)
                                setAnimationPack(target)
                                local humanoid = character:FindFirstChildOfClass("Humanoid")

                                if humanoid then
                                    for _, track in ipairs(humanoid:GetPlayingAnimationTracks()) do
                                        track:Stop(0)
                                    end

                                    humanoid:ChangeState(Enum.HumanoidStateType.Running)
                                end
                            else
                                setAnimationPack(target)
                            end

                            currentAnimPack = target
                        end

                        resetAnimationPack = function()
                            currentAnimPack = "Off"

                            if animSelectorLabel then
                                animSelectorLabel.Text = "Off"
                            end

                            setAnimationPack("Off")
                        end
                    end
                end
            end

            do
                local getCharacterAndRoot

                do
                    local getPlotsFolder

                    do
                        DEFAULT_KEYBINDS = {
                            DropBrainrot = { kb = Enum.KeyCode.X, gp = nil },
                            AutoLeft = { kb = Enum.KeyCode.Z, gp = nil },
                            AutoRight = { kb = Enum.KeyCode.C, gp = nil },
                            AutoBat = { kb = Enum.KeyCode.E, gp = nil },
                            BatV2 = { kb = nil, gp = nil },
                            TPFloor = { kb = Enum.KeyCode.F, gp = nil },
                            GuiHide = { kb = Enum.KeyCode.LeftControl, gp = nil },
                            CarryToggle = { kb = Enum.KeyCode.Q, gp = nil },
                            LaggerMode = { kb = Enum.KeyCode.R, gp = nil },
                            TPBat = { kb = Enum.KeyCode.V, gp = nil },
                            InstaReset = { kb = Enum.KeyCode.H, gp = nil },
                        }

                        KEYBINDS = {
                            DropBrainrot = {
                                kb = DEFAULT_KEYBINDS.DropBrainrot.kb,
                                gp = DEFAULT_KEYBINDS.DropBrainrot.gp,
                            },
                            AutoLeft = {
                                kb = DEFAULT_KEYBINDS.AutoLeft.kb,
                                gp = DEFAULT_KEYBINDS.AutoLeft.gp,
                            },
                            AutoRight = {
                                kb = DEFAULT_KEYBINDS.AutoRight.kb,
                                gp = DEFAULT_KEYBINDS.AutoRight.gp,
                            },
                            AutoBat = {
                                kb = DEFAULT_KEYBINDS.AutoBat.kb,
                                gp = DEFAULT_KEYBINDS.AutoBat.gp,
                            },
                            BatV2 = {
                                kb = DEFAULT_KEYBINDS.BatV2.kb,
                                gp = DEFAULT_KEYBINDS.BatV2.gp,
                            },
                            TPFloor = {
                                kb = DEFAULT_KEYBINDS.TPFloor.kb,
                                gp = DEFAULT_KEYBINDS.TPFloor.gp,
                            },
                            GuiHide = {
                                kb = DEFAULT_KEYBINDS.GuiHide.kb,
                                gp = DEFAULT_KEYBINDS.GuiHide.gp,
                            },
                            CarryToggle = {
                                kb = DEFAULT_KEYBINDS.CarryToggle.kb,
                                gp = DEFAULT_KEYBINDS.CarryToggle.gp,
                            },
                            LaggerMode = {
                                kb = DEFAULT_KEYBINDS.LaggerMode.kb,
                                gp = DEFAULT_KEYBINDS.LaggerMode.gp,
                            },
                            TPBat = {
                                kb = DEFAULT_KEYBINDS.TPBat.kb,
                                gp = DEFAULT_KEYBINDS.TPBat.gp,
                            },
                            InstaReset = {
                                kb = DEFAULT_KEYBINDS.InstaReset.kb,
                                gp = DEFAULT_KEYBINDS.InstaReset.gp,
                            },
                        }

                        _isResetting = false
                        _lastSavedJSON = nil
                        _isLoading = false
                        CONFIG = { AUTO_STEAL_ENABLED = false, STEAL_RANGE = 61 }
                        Workspace:FindFirstChild("Plots")
                        stealConnection = nil

                        stealSettings = {
                            AutoStealEnabled = false,
                            StealRadius = CONFIG.STEAL_RANGE,
                            StealDuration = 1.3,
                            StealDelay = 0.25,
                            Data = {},
                        }

                        isStealInProgress = false

                        do
                            local value = nil
                            local counter = 0

                            getPlotsFolder = function()
                                local time = getTime()
                                if value and time - counter < 2 and value.Parent then
                                    return value
                                end
                                value = workspace:FindFirstChild("Plots")
                                counter = time
                                return value
                            end
                        end
                    end

                    do
                        local function findPlotByName(target)
                            local plotsFolder = getPlotsFolder()
                            if not plotsFolder then
                                return false
                            end
                            local child = plotsFolder:FindFirstChild(target)
                            if not child then
                                return false
                            end
                            local plotSign = child:FindFirstChild("PlotSign")

                            if plotSign then
                                local yourBase = plotSign:FindFirstChild("YourBase")
                                if yourBase and yourBase:IsA("BillboardGui") then
                                    return yourBase.Enabled == true
                                end
                            end

                            return false
                        end

                        getCharacterAndRoot = function()
                            local character = localPlayer.Character
                            if not character then
                                return nil, nil
                            end
                            local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
                            if not humanoidRootPart then
                                return nil, nil
                            end
                            local plotsFolder = getPlotsFolder()
                            if not plotsFolder then
                                return nil, nil
                            end
                            local value = nil
                            local closestDistance = huge
                            local name = nil
                            local position = humanoidRootPart.Position

                            for _, child in ipairs(plotsFolder:GetChildren()) do
                                if not findPlotByName(child.Name) then
                                    local animalPodiums = child:FindFirstChild("AnimalPodiums")

                                    if animalPodiums then
                                        for _, child in ipairs(animalPodiums:GetChildren()) do
                                            pcall(function()
                                                local base = child:FindFirstChild("Base")
                                                base = base and base:FindFirstChild("Spawn")

                                                if base then
                                                    local position2 = base.Position
                                                    local offset = position2.X - position.X
                                                    local offset2 = position2.Y - position.Y
                                                    local offset3 = position2.Z - position.Z
                                                    local distance = sqrt(offset * offset + offset2 * offset2 + offset3 * offset3)

                                                    if distance < closestDistance and distance <= stealSettings.StealRadius then
                                                        local promptAttachment = base:FindFirstChild("PromptAttachment")

                                                        if promptAttachment then
                                                            for _, child2 in ipairs(promptAttachment:GetChildren()) do
                                                                if child2:IsA("ProximityPrompt") and child2.ActionText and child2.ActionText:find("Steal") then
                                                                    value = child2
                                                                    closestDistance = distance
                                                                    name = child.Name
                                                                    break
                                                                end
                                                            end
                                                        end
                                                    end
                                                end
                                            end)
                                        end
                                    end
                                end
                            end

                            return value, name
                        end
                    end
                end

                local trackStealTarget = nil

                trackStealTarget = function(instance, enabled)
                    if isStealInProgress then
                        return
                    end

                    if math.random(30) == 1 then
                        for key in pairs(stealSettings.Data) do
                            if not key.Parent then
                                stealSettings.Data[key] = nil
                            end
                        end
                    end

                    if not stealSettings.Data[instance] then
                        stealSettings.Data[instance] = { hold = {}, trigger = {}, ready = true }

                        pcall(function()
                            if getconnections then
                                for _, value in ipairs(getconnections(instance.PromptButtonHoldBegan)) do
                                    if value.Function then
                                        table.insert(stealSettings.Data[instance].hold, value.Function)
                                    end
                                end

                                for _, value in ipairs(getconnections(instance.Triggered)) do
                                    if value.Function then
                                        table.insert(stealSettings.Data[instance].trigger, value.Function)
                                    end
                                end
                            end
                        end)
                    end

                    local entry = stealSettings.Data[instance]
                    if not entry.ready then
                        return
                    end
                    entry.ready = false
                    isStealInProgress = true

                    if progressFill then
                        progressFill.Size = UDim2.new(0, 0, 1, 0)
                    end

                    if progressPct then
                        progressPct.Text = "0%"
                    end

                    task.spawn(function()
                        for _, value in ipairs(entry.hold) do
                            task.spawn(value)
                        end

                        local time = getTime()
                        local stealDuration = stealSettings.StealDuration

                        while true do
                            if isStealInProgress and stealSettings.AutoStealEnabled then
                                local time2 = getTime() - time

                                if not (time2 >= 0.96) then
                                    local clamped = clamp(time2 / stealDuration, 0, 1)

                                    if progressFill then
                                        progressFill.Size = UDim2.new(clamped, 0, 1, 0)
                                    end

                                    if progressPct then
                                        progressPct.Text = floor(clamped * 100) .. "%"
                                    end

                                    if not (not instance.Parent or not instance.Parent.Parent) then
                                        local character = localPlayer.Character
                                        character = character and character:FindFirstChild("HumanoidRootPart")
                                        if not (character and (character.Position - instance.Parent.Parent.Position).Magnitude > stealSettings.StealRadius) then
                                            task.wait()
                                            continue
                                        end
                                    end
                                end
                            end

                            break
                        end

                        local clamped = clamp(0.96 / stealDuration, 0, 1)

                        if progressFill then
                            progressFill.Size = UDim2.new(clamped, 0, 1, 0)
                        end

                        if progressPct then
                            progressPct.Text = floor(clamped * 100) .. "%"
                        end

                        local amount = math.max(2.0300000000000002 - math.max(stealDuration - 0.96, 0), 0.05)
                        local time = getTime()
                        local exitTo = nil

                        while true do
                            if isStealInProgress and stealSettings.AutoStealEnabled then
                                if amount <= getTime() - time then
                                    exitTo = 2
                                    break
                                elseif not instance.Parent or not instance.Parent.Parent then
                                    exitTo = 3
                                    break
                                else
                                    local character = localPlayer.Character
                                    character = character and character:FindFirstChild("HumanoidRootPart")

                                    if character then
                                        local magnitude = (character.Position - instance.Parent.Parent.Position).Magnitude

                                        if magnitude <= 9 then
                                            exitTo = 1
                                            break
                                        elseif not (stealSettings.StealRadius < magnitude) then
                                            task.wait()
                                            continue
                                        end
                                    else
                                        task.wait()
                                        continue
                                    end
                                end
                            else
                                exitTo = 1
                                break
                            end

                            break
                        end

                        if exitTo == 1 then
                            if isStealInProgress and stealSettings.AutoStealEnabled then
                                local time = getTime()
                                local amount = math.max(stealDuration - 0.96, 0.05)

                                while true do
                                    local clamped2 = clamp((getTime() - time) / amount, 0, 1)
                                    local amount = clamped + clamped2 * (1 - clamped)

                                    if progressFill then
                                        progressFill.Size = UDim2.new(amount, 0, 1, 0)
                                    end

                                    if progressPct then
                                        progressPct.Text = floor(amount * 100) .. "%"
                                    end

                                    if clamped2 >= 1 then
                                        pcall(function()
                                            if #entry.trigger > 0 then
                                                for _, value in ipairs(entry.trigger) do
                                                    task.spawn(value)
                                                end
                                            else
                                                local stealAnimal = replicatedStorage:FindFirstChild("StealAnimal")

                                                if stealAnimal and enabled then
                                                    stealAnimal:FireServer(enabled)
                                                end
                                            end
                                        end)

                                        break
                                    else
                                        task.wait()
                                    end
                                end
                            end

                            if progressFill then
                                progressFill.Size = UDim2.new(0, 0, 1, 0)
                            end

                            if progressPct then
                                progressPct.Text = "0%"
                            end

                            entry.ready = true
                            isStealInProgress = false
                            return
                        end

                        if exitTo == 2 then
                            if progressFill then
                                progressFill.Size = UDim2.new(0, 0, 1, 0)
                            end

                            if progressPct then
                                progressPct.Text = "0%"
                            end

                            entry.ready = true
                            isStealInProgress = false
                            task.wait()
                            local characterAndRoot, value = getCharacterAndRoot()

                            if characterAndRoot then
                                trackStealTarget(characterAndRoot, value)
                            end

                            return
                        end

                        if exitTo == 3 then
                            isStealInProgress = false

                            if progressFill then
                                progressFill.Size = UDim2.new(0, 0, 1, 0)
                            end

                            if progressPct then
                                progressPct.Text = "0%"
                            end

                            entry.ready = true
                            return
                        end

                        isStealInProgress = false

                        if progressFill then
                            progressFill.Size = UDim2.new(0, 0, 1, 0)
                        end

                        if progressPct then
                            progressPct.Text = "0%"
                        end

                        entry.ready = true
                    end)
                end

                _G.YoutV2Steal = _G.YoutV2Steal or {
                    enabled = false,
                    radius = 10,
                    primeRange = 80,
                    holdMin = 1.3,
                    holdMax = 2.6,
                    entryDelay = 0.25,
                    cooldown = 0.05,
                    animals = {},
                    promptCache = {},
                    internalCache = {},
                    state = {
                        active = false,
                        startTime = 0,
                        phase = "idle",
                        label = "",
                        lastResult = "",
                        lastResultTime = 0,
                    },
                    plotSync = { caches = {}, connections = {} },
                    plots = nil,
                    syncReady = false,
                    scanThread = nil,
                    conn = nil,
                    lastScan = 0,
                    animalsData = nil,
                    channelFolder = nil,
                    routeRemote = nil,
                    requestData = nil,
                }

                _yv2Root = function()
                    local character = localPlayer.Character
                    return character and (character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("UpperTorso")) or nil
                end

                _yv2SplitPath = function(target)
                    if typeof(target) == "table" then
                        return target
                    end
                    local entries = {}

                    for match in string.gmatch(tostring(target), "[^%.]+") do
                        table.insert(entries, tonumber(match) or match)
                    end

                    return entries
                end

                _yv2ResolvePath = function(target, key)
                    local value = nil
                    local value2 = nil

                    for _, value3 in ipairs(_yv2SplitPath(target)) do
                        local value4 = key and key[value3]

                        if value4 then
                            value = key
                            value2 = value3
                            key = value4
                        else
                            value = key
                            value2 = value3
                            key = nil
                        end
                    end

                    return key, value, value2
                end

                _yv2ApplyDiff = function(index, key)
                    local value = _G.YoutV2Steal.plotSync.caches[index]
                    if typeof(value) ~= "table" then
                        return
                    end
                    local entry = key[2]
                    local entry2 = key[3]
                    local entry3 = key[4]
                    local value2, value3, value4 = _yv2ResolvePath(key[1], value)

                    if entry == "Changed" then
                        if value3 then
                            value3[value4] = entry2
                        end
                    elseif entry == "ArrayInsert" then
                        if value2 then
                            table.insert(value2, entry3, entry2)
                        end
                    elseif entry == "ArrayRemoved" then
                        if value2 then
                            table.remove(value2, entry3)
                        end
                    elseif entry == "DictionaryInsert" then
                        if value2 then
                            value2[entry3] = entry2
                        end
                    elseif entry == "DictionaryRemoved" then
                        if value2 then
                            value2[entry3] = nil
                        end
                    end
                end

                _yv2AttachChannel = function(instance, instance2, enabled)
                    local youtV2Steal = _G.YoutV2Steal
                    if youtV2Steal.plotSync.connections[instance] then
                        return
                    end
                    local text = tostring(instance.Name)
                    if not instance2:FindFirstChild(text) then
                        return
                    end

                    if enabled and youtV2Steal.plotSync.caches[text] == nil then
                        local success, result = pcall(function()
                            return enabled:InvokeServer(text)
                        end)

                        youtV2Steal.plotSync.caches[text] = success and typeof(result) == "table" and result or {}
                    elseif youtV2Steal.plotSync.caches[text] == nil then
                        youtV2Steal.plotSync.caches[text] = {}
                    end

                    youtV2Steal.plotSync.connections[instance] = instance.OnClientEvent:Connect(function(items)
                        for _, item in ipairs(items) do
                            _yv2ApplyDiff(text, item)
                        end
                    end)
                end

                _yv2EnsureSync = function()
                    local youtV2Steal = _G.YoutV2Steal
                    if youtV2Steal.syncReady then
                        return true
                    end

                    return pcall(function()
                        youtV2Steal.plots = workspace:WaitForChild("Plots", 8)
                        local ReplicatedStorage = game:GetService("ReplicatedStorage")
                        local packages = ReplicatedStorage:FindFirstChild("Packages")
                        local datas = ReplicatedStorage:FindFirstChild("Datas")
                        if not (packages and datas and youtV2Steal.plots) then
                            return
                        end
                        youtV2Steal.animalsData = require(datas:WaitForChild("Animals", 10))
                        local synchronizer = packages:FindFirstChild("Synchronizer") or packages:WaitForChild("Synchronizer", 10)
                        if not synchronizer then
                            return
                        end
                        youtV2Steal.channelFolder = synchronizer:FindFirstChild("Channel") or synchronizer:WaitForChild("Channel", 10)
                        youtV2Steal.routeRemote = synchronizer:FindFirstChild("CommunicationRoute") or synchronizer:WaitForChild("CommunicationRoute", 10)
                        youtV2Steal.requestData = synchronizer:FindFirstChild("RequestData")

                        if youtV2Steal.channelFolder then
                            for _, child in ipairs(youtV2Steal.channelFolder:GetChildren()) do
                                if child:IsA("RemoteEvent") then
                                    _yv2AttachChannel(child, youtV2Steal.plots, youtV2Steal.requestData)
                                end
                            end

                            youtV2Steal.channelFolder.ChildAdded:Connect(function(child)
                                if child:IsA("RemoteEvent") then
                                    _yv2AttachChannel(child, youtV2Steal.plots, youtV2Steal.requestData)
                                end
                            end)
                        end

                        if youtV2Steal.routeRemote then
                            youtV2Steal.routeRemote.OnClientEvent:Connect(function(items)
                                for _, item in ipairs(items) do
                                    local entry = item[1]
                                    local text = tostring(item[2])

                                    if youtV2Steal.plots and youtV2Steal.plots:FindFirstChild(text) then
                                        if entry == "ListenerAdded" then
                                            local channelFolder = youtV2Steal.channelFolder and youtV2Steal.channelFolder:FindFirstChild(text)

                                            if channelFolder and channelFolder:IsA("RemoteEvent") then
                                                _yv2AttachChannel(channelFolder, youtV2Steal.plots, youtV2Steal.requestData)
                                            end
                                        elseif entry == "ListenerRemoved" then
                                            for key, connection in pairs(youtV2Steal.plotSync.connections) do
                                                if tostring(key.Name) == text then
                                                    pcall(function()
                                                        connection:Disconnect()
                                                    end)

                                                    youtV2Steal.plotSync.connections[key] = nil
                                                    youtV2Steal.plotSync.caches[text] = nil
                                                    break
                                                end
                                            end
                                        end
                                    end
                                end
                            end)
                        end

                        youtV2Steal.syncReady = true
                    end) and youtV2Steal.syncReady == true
                end

                _yv2PlotOwner = function(instance)
                    instance = instance and instance:FindFirstChild("PlotSign")
                    local frame = instance and instance:FindFirstChild("SurfaceGui") and instance.SurfaceGui:FindFirstChild("Frame")
                    frame = frame and frame:FindFirstChild("TextLabel")
                    if not frame or frame.Text == "Empty Base" then
                        return nil
                    end
                    return frame.Text:gsub("'s [Bb]ase$", ""):gsub("%s+$", "")
                end

                _yv2IsMyBase = function(enabled)
                    local youtV2Steal = _G.YoutV2Steal
                    if not enabled or not enabled.plot or not youtV2Steal.plots then
                        return false
                    end
                    local child = youtV2Steal.plots:FindFirstChild(enabled.plot)
                    if not child then
                        return false
                    end
                    local value = _yv2PlotOwner(child)
                    return value == localPlayer.DisplayName or value == localPlayer.Name
                end

                _yv2PodiumFor = function(target)
                    local youtV2Steal = _G.YoutV2Steal
                    local plots = youtV2Steal.plots and youtV2Steal.plots:FindFirstChild(target.plot)
                    plots = plots and plots:FindFirstChild("AnimalPodiums")
                    return plots and plots:FindFirstChild(target.slot) or nil
                end

                _yv2AnimalPos = function(target)
                    local value = _yv2PodiumFor(target)
                    return value and value:GetPivot().Position or nil
                end

                _yv2DistToAnimal = function(target)
                    local value = _yv2Root()
                    local value2 = _yv2AnimalPos(target)
                    return value and value2 and (value.Position - value2).Magnitude or math.huge
                end

                _yv2FindPrompt = function(enabled)
                    local youtV2Steal = _G.YoutV2Steal
                    if not enabled then
                        return nil
                    end
                    local entry = youtV2Steal.promptCache[enabled.uid]
                    if entry and entry.Parent then
                        return entry
                    end
                    local value = _yv2PodiumFor(enabled)
                    if not value then
                        return nil
                    end

                    for _, descendant in ipairs(value:GetDescendants()) do
                        if descendant:IsA("ProximityPrompt") then
                            youtV2Steal.promptCache[enabled.uid] = descendant
                            return descendant
                        end
                    end

                    return nil
                end

                _yv2BuildCallbacks = function(index)
                    local youtV2Steal = _G.YoutV2Steal
                    if youtV2Steal.internalCache[index] then
                        return
                    end
                    local data = { holdCallbacks = {}, triggerCallbacks = {}, ready = true }

                    pcall(function()
                        if getconnections then
                            local data2 = getconnections(index.PromptButtonHoldBegan) or getconnections(index.HoldBegan) or {}

                            for _, entry in ipairs(data2) do
                                if type(entry.Function) == "function" then
                                    table.insert(data.holdCallbacks, entry.Function)
                                end
                            end

                            local data2 = getconnections(index.Triggered) or {}

                            for _, entry in ipairs(data2) do
                                if type(entry.Function) == "function" then
                                    table.insert(data.triggerCallbacks, entry.Function)
                                end
                            end
                        end
                    end)

                    youtV2Steal.internalCache[index] = data
                end

                _yv2SetBar = function(target)
                    if progressFill then
                        progressFill.Size = UDim2.new(math.clamp(target, 0, 1), 0, 1, 0)
                    end

                    if progressPct then
                        progressPct.Text = floor(math.clamp(target, 0, 1) * 100) .. "%"
                    end
                end

                _yv2ResetBar = function()
                    if progressFill then
                        progressFill.Size = UDim2.new(0, 0, 1, 0)
                    end

                    if progressPct then
                        progressPct.Text = "0%"
                    end
                end

                _yv2Execute = function(instance, enabled)
                    local youtV2Steal = _G.YoutV2Steal
                    if not instance or not instance.Parent or not enabled then
                        return false
                    end

                    if youtV2Steal.state.active then
                        return false
                    end

                    if getTime() - (youtV2Steal.state.lastResultTime or 0) < (youtV2Steal.cooldown or 0.05) then
                        return false
                    end
                    _yv2BuildCallbacks(instance)
                    local entry = youtV2Steal.internalCache[instance]
                    if not entry or not entry.ready then
                        return false
                    end
                    entry.ready = false
                    youtV2Steal.state.active = true
                    youtV2Steal.state.startTime = getTime()
                    youtV2Steal.state.phase = "holding"
                    youtV2Steal.state.label = enabled.name or "Animal"

                    task.spawn(function()
                        local startTime = youtV2Steal.state.startTime
                        local data = { 0.7, 0.75, 0.8, 0.85, 0.9 }
                        local entry2 = data[math.random(1, #data)]

                        if #entry.holdCallbacks > 0 then
                            for _, holdCallback in ipairs(entry.holdCallbacks) do
                                task.spawn(function()
                                    pcall(holdCallback)
                                end)
                            end
                        else
                            pcall(function()
                                if instance.InputHoldBegin then
                                    instance:InputHoldBegin()
                                end
                            end)
                        end

                        while true do
                            local autoStealEnabled = youtV2Steal.enabled and selectedStealMode == "V2" and CONFIG.AUTO_STEAL_ENABLED

                            if autoStealEnabled then
                                autoStealEnabled = getTime() - startTime < (youtV2Steal.holdMin or 1.3)
                            end

                            if autoStealEnabled then
                                _yv2SetBar(math.min((getTime() - startTime) / (youtV2Steal.holdMax or 2.6), entry2))
                                task.wait()
                                continue
                            end

                            break
                        end

                        youtV2Steal.state.phase = "waitingRange"
                        local isActive = _yv2DistToAnimal(enabled) <= (tonumber(youtV2Steal.radius) or 10)
                        local exitTo = nil
                        local isActive2

                        while true do
                            local parent = youtV2Steal.enabled and selectedStealMode == "V2" and CONFIG.AUTO_STEAL_ENABLED and instance.Parent
                            isActive2 = false

                            if parent then
                                local time = getTime() - startTime

                                if (youtV2Steal.holdMax or 2.6) < time then
                                    exitTo = 1
                                    break
                                else
                                    _yv2SetBar(math.min(time / (youtV2Steal.holdMax or 2.6), entry2))

                                    if _yv2DistToAnimal(enabled) <= (tonumber(youtV2Steal.radius) or 10) then
                                        exitTo = 2
                                        break
                                    else
                                        task.wait()
                                        continue
                                    end
                                end
                            end

                            break
                        end

                        local state, lastResult

                        if exitTo == 1 then
                            state = youtV2Steal.state
                            lastResult = isActive2 and "Stole " .. tostring(youtV2Steal.state.label)
                        elseif exitTo == 2 then
                            if not isActive then
                                task.wait(youtV2Steal.entryDelay or 0.25)
                            end

                            if youtV2Steal.enabled and selectedStealMode == "V2" and CONFIG.AUTO_STEAL_ENABLED then
                                if #entry.triggerCallbacks > 0 then
                                    for _, triggerCallback in ipairs(entry.triggerCallbacks) do
                                        task.spawn(function()
                                            pcall(triggerCallback)
                                        end)
                                    end
                                else
                                    pcall(function()
                                        if instance.InputHoldEnd then
                                            instance:InputHoldEnd()
                                        end
                                    end)
                                end

                                isActive2 = true
                                state = youtV2Steal.state
                                lastResult = isActive2 and "Stole " .. tostring(youtV2Steal.state.label)
                            else
                                state = youtV2Steal.state
                                lastResult = isActive2 and "Stole " .. tostring(youtV2Steal.state.label)
                            end
                        else
                            state = youtV2Steal.state
                            lastResult = isActive2 and "Stole " .. tostring(youtV2Steal.state.label)
                        end

                        state.lastResult = lastResult or "Missed"
                        youtV2Steal.state.active = false
                        youtV2Steal.state.phase = "idle"
                        youtV2Steal.state.lastResultTime = getTime()

                        if isActive2 then
                            _yv2SetBar(1)
                        end

                        task.wait(youtV2Steal.cooldown or 0.05)
                        entry.ready = true
                        _yv2ResetBar()
                    end)

                    return true
                end

                local function collectPlotAnimals()
                    local youtV2Steal = _G.YoutV2Steal
                    if not _yv2EnsureSync() then
                        return 0
                    end
                    local animals = {}

                    for _, child in ipairs(youtV2Steal.plots:GetChildren()) do
                        local animalList = youtV2Steal.plotSync.caches[child.Name]
                        animalList = animalList and animalList.AnimalList

                        if typeof(animalList) == "table" then
                            for animalEntry, animalEntry2 in pairs(animalList) do
                                if type(animalEntry2) == "table" then
                                    local index = animalEntry2.Index
                                    local animalsData = youtV2Steal.animalsData and youtV2Steal.animalsData[index]

                                    if animalsData then
                                        table.insert(animals, {
                                            name = animalsData.DisplayName or index,
                                            plot = child.Name,
                                            slot = tostring(animalEntry),
                                            uid = child.Name .. "_" .. tostring(animalEntry),
                                        })
                                    end
                                end
                            end
                        end
                    end

                    youtV2Steal.animals = animals
                    return #animals
                end

                local function findNearestAnimal()
                    local youtV2Steal = _G.YoutV2Steal
                    local value = _yv2Root()
                    if not value then
                        return nil
                    end
                    local huge2 = math.huge
                    local value2 = nil

                    for _, animal in ipairs(youtV2Steal.animals) do
                        if not _yv2IsMyBase(animal) then
                            local magnitude = _yv2AnimalPos(animal)
                            magnitude = magnitude and (value.Position - magnitude).Magnitude or math.huge

                            if magnitude <= (youtV2Steal.primeRange or 80) and magnitude < huge2 then
                                huge2 = magnitude
                                value2 = animal
                            end
                        end
                    end

                    return value2
                end

                local function startAnimalScan()
                    local youtV2Steal = _G.YoutV2Steal
                    if youtV2Steal.scanThread then
                        return
                    end

                    youtV2Steal.scanThread = task.spawn(function()
                        while _G.YoutV2Steal do
                            if youtV2Steal.enabled or selectedStealMode == "V2" then
                                pcall(collectPlotAnimals)
                            end

                            task.wait(5)
                        end
                    end)
                end

                stopAutoStealV2 = function()
                    local youtV2Steal = _G.YoutV2Steal
                    youtV2Steal.enabled = false

                    if youtV2Steal.conn then
                        youtV2Steal.conn:Disconnect()
                        youtV2Steal.conn = nil
                    end

                    youtV2Steal.state.active = false
                    youtV2Steal.state.phase = "idle"
                    _yv2ResetBar()
                end

                startAutoStealV2 = function()
                    local youtV2Steal = _G.YoutV2Steal
                    youtV2Steal.radius = 10
                    youtV2Steal.enabled = true
                    pcall(_yv2EnsureSync)
                    startAnimalScan()
                    pcall(collectPlotAnimals)

                    if youtV2Steal.conn then
                        youtV2Steal.conn:Disconnect()
                        youtV2Steal.conn = nil
                    end

                    youtV2Steal.conn = RunService.Heartbeat:Connect(function()
                        if not youtV2Steal.enabled or not CONFIG.AUTO_STEAL_ENABLED or selectedStealMode ~= "V2" or youtV2Steal.state.active then
                            return
                        end
                        local nearestAnimal = findNearestAnimal()

                        if not nearestAnimal then
                            if getTime() - (youtV2Steal.lastScan or 0) > 1.2 then
                                youtV2Steal.lastScan = getTime()
                                pcall(collectPlotAnimals)
                            end

                            return
                        end

                        local value = _yv2FindPrompt(nearestAnimal)

                        if value then
                            _yv2Execute(value, nearestAnimal)
                        end
                    end)
                end

                isStealConnectionActive = function()
                    if stealConnection then
                        local isActive = false

                        pcall(function()
                            isActive = stealConnection.Connected == true
                        end)

                        if isActive then
                            stealSettings.StealRadius = CONFIG.STEAL_RANGE
                            stealSettings.AutoStealEnabled = true
                            return true
                        end

                        pcall(function()
                            stealConnection:Disconnect()
                        end)

                        stealConnection = nil
                    end

                    stealSettings.StealRadius = CONFIG.STEAL_RANGE
                    stealSettings.AutoStealEnabled = true

                    stealConnection = RunService.Heartbeat:Connect(function()
                        if not stealSettings.AutoStealEnabled or isStealInProgress then
                            return
                        end

                        if selectedStealMode ~= "V1" then
                            return
                        end
                        local characterAndRoot, value = getCharacterAndRoot()

                        if characterAndRoot then
                            trackStealTarget(characterAndRoot, value)
                        end
                    end)

                    return true
                end
            end
        end

        do
            local vynxRunTPDown

            do
                do
                    do
                        local function stopAutoSteal2()
                            if stealConnection then
                                stealConnection:Disconnect()
                                stealConnection = nil
                            end

                            isStealInProgress = false
                            stealSettings.AutoStealEnabled = false

                            if progressFill then
                                TweenService:Create(progressFill, TweenInfo.new(0.2), { Size = UDim2.new(0, 0, 1, 0) }):Play()
                            end

                            if progressPct then
                                progressPct.Text = "0%"
                            end
                        end

                        startAutoSteal = function()
                            stopAutoSteal2()
                            stopAutoStealV2()
                            CONFIG.AUTO_STEAL_ENABLED = true

                            if selectedStealMode == "V2" then
                                startAutoStealV2()
                            else
                                isStealConnectionActive()
                            end

                            return true
                        end

                        stopAutoSteal = function()
                            stopAutoSteal2()
                            stopAutoStealV2()
                            CONFIG.AUTO_STEAL_ENABLED = false

                            if progressFill then
                                TweenService:Create(progressFill, TweenInfo.new(0.2), { Size = UDim2.new(0, 0, 1, 0) }):Play()
                            end

                            if progressPct then
                                progressPct.Text = "0%"
                            end
                        end
                    end
                end

                medusaDebounce = false
                medusaLastUsed = 0
                dropActive = false
                lastDropTime = 0
                lastMoveDir = vector(0, 0, 0)
                origFOV = nil
                fovEnabled = false
                fovValue = 70
                customFovConn = nil
                _anyKeyListening = false
                _aimbotConn = nil
                _prevAutoRotate = nil
                tpBatConn = nil
                tpBatPrevAutoRotate = nil
                tpBatHitCD = false
                TP_BAT_SWING_CD = 0.08
                tpBatFloatingButton = nil
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

                CONNECTIONS = {
                    autoSteal = nil,
                    batCounter = nil,
                    anchor = {},
                    progress = nil,
                    autoLeft = nil,
                    autoRight = nil,
                }

                keyButtonRefs = {}
                progressFill = nil
                progressPct = nil
                pbFrame = nil
                speedLabel = nil
                modeValLbl = nil
                normalBox = nil
                carryBox = nil
                laggerBox = nil
                lagger2Box = nil
                radInput = nil
                batSpeedBox = nil
                uiScaleBox = nil
                modeSelectBtn = nil
                dropModeBtnRef = nil
                autoBatSetVisual = nil
                autoLeftSetVisual = nil
                autoRightSetVisual = nil
                setBatCounterVisual = nil
                setMedusaVisual = nil
                setAntiRagVisual = nil
                setUnwalkVisual = nil
                setAntiLagVisual = nil
                setLockUIVisual = nil
                setInstaGrab = nil
                setAntiDieVisual = nil
                setAntiBatVisual = nil
                setAntiFlingVisual = nil
                setESPVIsual = nil
                setESPLineVisual = nil
                mobSetAutoBat = nil
                mobSetAutoLeft = nil
                mobSetAutoRight = nil
                mobSetDropBR = nil
                mobSetTpDown = nil
                mobSetCarry = nil
                mobSetLagger1 = nil
                mobSetLagger2 = nil
                miniBtn = nil
                main = nil
                gui = nil
                mobilePanel = nil
                instaResetFloatingButton = nil
                showGui = nil
                hideGui = nil
                mainUIScale = nil
                animSelectorLabel = nil
                pbScale = nil
                tabButtons = nil
                colorSelectorLabel = nil

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
                    "Bat",
                    "Slap",
                    "Iron Slap",
                    "Gold Slap",
                    "Diamond Slap",
                    "Emerald Slap",
                    "Ruby Slap",
                    "Dark Matter Slap",
                    "Flame Slap",
                    "Nuclear Slap",
                    "Galaxy Slap",
                    "Glitched Slap",
                }

                AUTO_PATH_POINTS = {
                    L1 = vector(-476.48, -6.28, 92.73),
                    L2 = vector(-483.12, -4.95, 94.8),
                    L_FACE = vector(-482.25, -4.96, 92.09),
                    R1 = vector(-476.16, -6.52, 25.62),
                    R2 = vector(-483.06, -5.03, 25.48),
                    R_FACE = vector(-482.06, -6.93, 35.47),
                }

                isGamepadInput = function(input)
                    return input and input.UserInputType and input.UserInputType.Name:match("^Gamepad") ~= nil
                end

                isBindableInput = function(input)
                    if not input or input.KeyCode == Enum.KeyCode.Unknown then
                        return false
                    end

                    if input.UserInputType == Enum.UserInputType.Keyboard then
                        return true
                    end
                    return isGamepadInput(input) and GAMEPAD_KEYS[input.KeyCode] == true
                end

                kbMatch = function(target, enabled)
                    if enabled then
                        local isActive = enabled == target.kb

                        if isActive then
                            enabled = isActive
                        else
                            enabled = target.gp and enabled == target.gp
                        end
                    end

                    return enabled
                end

                resetProgressBar = function()
                    if progressPct then
                        progressPct.Text = "0%"
                    end

                    if progressFill then
                        progressFill.Size = UDim2.new(0, 0, 1, 0)
                    end
                end

                TP_DOWN_OFFSET = 0.1
                _G._VynxTPDownMode = _G._VynxTPDownMode == "half" and "half" or "full"

                if _G._VynxAutoTPDownEnabled == nil then
                    _G._VynxAutoTPDownEnabled = false
                end

                _G._VynxAutoTPDownHeightTrigger = tonumber(_G._VynxAutoTPDownHeightTrigger) or 20

                do
                    local function canStealFrom(instance)
                        if not instance then
                            return false
                        end

                        if localPlayer:GetAttribute("Stealing") == true or instance:GetAttribute("Stealing") == true then
                            return true
                        end

                        for _, child in ipairs(instance:GetChildren()) do
                            if child:IsA("Tool") then
                                local lowerName = child.Name:lower()
                                if not (lowerName:find("bat") or lowerName:find("slap")) then
                                    return true
                                end
                            end
                        end

                        return false
                    end

                    local function applyCharacterState()
                        pcall(function()
                            local character = localPlayer.Character
                            if not character then
                                return
                            end
                            local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
                            if not humanoidRootPart then
                                return
                            end
                            local humanoid = character:FindFirstChildOfClass("Humanoid")
                            if not humanoid then
                                return
                            end
                            local raycastParams2 = raycastParams()
                            raycastParams2.FilterDescendantsInstances = { character }
                            raycastParams2.FilterType = Enum.RaycastFilterType.Exclude
                            local hit = workspace:Raycast(humanoidRootPart.Position, vector(0, -500, 0), raycastParams2)

                            if hit then
                                humanoidRootPart.AssemblyLinearVelocity = vector2
                                humanoidRootPart.AssemblyAngularVelocity = vector2
                                humanoidRootPart.CFrame = cframe(hit.Position.X, hit.Position.Y + (humanoid.HipHeight or 2) + humanoidRootPart.Size.Y / 2 + (TP_DOWN_OFFSET or 0.1), hit.Position.Z)
                                humanoidRootPart.AssemblyLinearVelocity = vector2
                            end
                        end)
                    end

                    local function restoreCharacterState()
                        pcall(function()
                            local character = localPlayer.Character
                            if not character then
                                return
                            end
                            local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
                            if not humanoidRootPart then
                                return
                            end
                            local value, value = humanoidRootPart.CFrame:ToEulerAnglesYXZ()
                            humanoidRootPart.CFrame = cframe(humanoidRootPart.Position.X, -7, humanoidRootPart.Position.Z) * CFrame.Angles(0, value, 0)
                            humanoidRootPart.AssemblyLinearVelocity = vector2
                        end)
                    end

                    vynxRunTPDown = function()
                        if dropActive or _G.IsDropping then
                            return
                        end
                        local character = localPlayer.Character
                        if not character then
                            return
                        end
                        local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
                        if not humanoidRootPart then
                            return
                        end
                        local humanoid = character:FindFirstChildOfClass("Humanoid")
                        if not humanoid or humanoid.Health <= 0 or humanoidRootPart.Anchored or humanoid.Sit or humanoid.SeatPart then
                            return
                        end

                        if _G._VynxTPDownMode == "half" then
                            applyCharacterState()
                        else
                            restoreCharacterState()
                        end
                    end

                    doTpDown = function()
                        vynxRunTPDown()
                    end

                    RunService.Heartbeat:Connect(function()
                        if _G._VynxAutoTPDownEnabled ~= true then
                            return
                        end
                        local character = localPlayer.Character
                        if not character then
                            return
                        end

                        if not canStealFrom(character) then
                            return
                        end
                        local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
                        if not humanoidRootPart then
                            return
                        end
                        local raycastParams2 = raycastParams()
                        raycastParams2.FilterDescendantsInstances = { character }
                        raycastParams2.FilterType = Enum.RaycastFilterType.Exclude
                        local hit = workspace:Raycast(humanoidRootPart.Position, vector(0, -2000, 0), raycastParams2)
                        if not hit then
                            return
                        end

                        if (tonumber(_G._VynxAutoTPDownHeightTrigger) or 20) < humanoidRootPart.Position.Y - hit.Position.Y then
                            vynxRunTPDown()
                        end
                    end)
                end
            end

loadstring(game:HttpGet("https://raw.githubusercontent.com/Argian-dotcom/Jdkffkfo/refs/heads/main/Coding"))()
            _G._VynxRunTPDown = vynxRunTPDown

            _G._VynxSetTPDownMode = function(mode)
                _G._VynxTPDownMode = mode == "half" and "half" or "full"
                return _G._VynxTPDownMode
            end

            _G._VynxTPDownIsAutoOn = function()
                return _G._VynxAutoTPDownEnabled == true
            end

            do
                local capturedVynxRunTPDown = vynxRunTPDown
                local connection = nil

                local function startTpFloorLoop()
                    if connection then
                        return
                    end

                    connection = RunService.Heartbeat:Connect(function()
                        local tpFloor = KEYBINDS.TPFloor
                        if not tpFloor then
                            return
                        end
                        local gp = tpFloor.gp or tpFloor.kb
                        if not gp then
                            return
                        end

                        if UserInputService:IsKeyDown(gp) then
                            pcall(capturedVynxRunTPDown)
                        end
                    end)
                end

                startTpFloorLoop()
            end
        end
    end

    do
        do
            antiRagdollState = { Enabled = false, Connection = nil, ResetCooldown = 0 }

            startAntiRagdoll = function()
                if antiRagdollState.Connection then
                    return
                end
                antiRagdollState.Enabled = true

                antiRagdollState.Connection = RunService.Heartbeat:Connect(function()
                    do
                        if not antiRagdollState.Enabled then
                            return
                        end
                        local character = localPlayer.Character
                        if not character then
                            return
                        end
                        local humanoid = character:FindFirstChildOfClass("Humanoid")
                        local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
                        if not humanoid or not humanoidRootPart or humanoid.Health <= 0 then
                            return
                        end

                        if dropActive or _G.IsDropping then
                            return
                        end
                        local state = humanoid:GetState()
                        local time = getTime()

                        if state == Enum.HumanoidStateType.Physics or state == Enum.HumanoidStateType.Ragdoll or state == Enum.HumanoidStateType.FallingDown then
                            if time - antiRagdollState.ResetCooldown > 0.15 then
                                antiRagdollState.ResetCooldown = time

                                pcall(function()
                                    humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
                                    humanoidRootPart.Velocity = vector2
                                    humanoidRootPart.RotVelocity = vector2
                                    humanoidRootPart.AssemblyLinearVelocity = vector2
                                    humanoidRootPart.AssemblyAngularVelocity = vector2

                                    for _, descendant in ipairs(character:GetDescendants()) do
                                        if descendant:IsA("Motor6D") then
                                            descendant.Enabled = true
                                        end

                                        if descendant:IsA("Constraint") then
                                            descendant.Enabled = true
                                        end
                                    end

                                    workspace.CurrentCamera.CameraSubject = humanoid
                                    local playerModule = localPlayer.PlayerScripts:FindFirstChild("PlayerModule")

                                    if playerModule then
                                        local ControlModule = require(playerModule:FindFirstChild("ControlModule"))

                                        if ControlModule then
                                            ControlModule:Enable()
                                        end
                                    end

                                    humanoid.AutoRotate = true
                                    humanoid.PlatformStand = false
                                    humanoid.Sit = false
                                end)
                            end
                        end
                    end
                end)
            end

            stopAntiRagdoll = function()
                antiRagdollState.Enabled = false

                if antiRagdollState.Connection then
                    antiRagdollState.Connection:Disconnect()
                    antiRagdollState.Connection = nil
                end

                antiRagdollState.ResetCooldown = 0
            end

            localPlayer.CharacterAdded:Connect(function()
                task.wait(0.5)

                if antiRagdollMode == "v2" then
                    if antiRagdollState.Connection then
                        antiRagdollState.Connection:Disconnect()
                        antiRagdollState.Connection = nil
                    end

                    startAntiRagdoll()
                end
            end)

            setAntiRagdollMode = function(mode)
                if mode == "v2" then
                    startAntiRagdoll()
                    antiRagdollMode = "v2"
                else
                    stopAntiRagdoll()
                    antiRagdollMode = "off"
                end

                if setAntiRagVisual then
                    setAntiRagVisual(antiRagdollMode == "v2")
                end

                saveAllSettings()
            end

            _antiDieEnabled = false
            _antiDieStopped = false
            _antiDieSources = { toggle = false, autobat = false }

            _antiDie = {
                enabled = false,
                loop = nil,
                healthConn = nil,
                charConn = nil,
                lastHealTime = 0,
                invincibleUntil = 0,
                config = {
                    healthThreshold = 50,
                    invincibilityFrames = 0.75,
                    fallDamageProtection = false,
                    ragdollProtection = true,
                    autoRevive = true,
                },
            }

            _antiDie.SuperHeal = function(humanoid)
                if not humanoid or not humanoid.Parent then
                    return
                end
                local maxHealth = humanoid.MaxHealth or 100

                if maxHealth <= 0 or maxHealth == math.huge then
                    maxHealth = 100
                end

                pcall(function()
                    humanoid.Health = maxHealth

                    if humanoid.MaxHealth < maxHealth then
                        humanoid.MaxHealth = maxHealth
                    end
                end)

                _antiDie.invincibleUntil = getTime() + _antiDie.config.invincibilityFrames
                _antiDie.lastHealTime = getTime()

                pcall(function()
                    local parent = humanoid.Parent
                    if not parent then
                        return
                    end

                    for _, child in ipairs(parent:GetChildren()) do
                        if child:IsA("NumberValue") then
                            local lowerName = child.Name:lower()

                            if lowerName:find("health") or lowerName:find("hp") or lowerName:find("life") then
                                child.Value = maxHealth
                            end
                        end

                        if child:IsA("BoolValue") and child.Name:lower():find("dead") then
                            child.Value = false
                        end
                    end
                end)
            end

            _antiDie.PreventDamage = function(part, humanoid)
                if not humanoid then
                    return
                end

                if humanoid.Health < (humanoid.MaxHealth or 100) then
                    _antiDie.SuperHeal(humanoid)
                end

                if getTime() < _antiDie.invincibleUntil then
                    if humanoid.Health < (humanoid.MaxHealth or 100) then
                        humanoid.Health = humanoid.MaxHealth or 100
                    end
                end

                if _antiDie.config.ragdollProtection then
                    local state = humanoid:GetState()

                    if state == Enum.HumanoidStateType.Physics or state == Enum.HumanoidStateType.Ragdoll or state == Enum.HumanoidStateType.FallingDown or state == Enum.HumanoidStateType.Dead then
                        pcall(function()
                            humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
                            humanoid:ChangeState(Enum.HumanoidStateType.Running)
                        end)

                        _antiDie.SuperHeal(humanoid)

                        if part then
                            pcall(function()
                                part.AssemblyAngularVelocity = Vector3.zero
                            end)
                        end
                    end
                end

                if humanoid.Health <= 0 then
                    _antiDie.SuperHeal(humanoid)

                    pcall(function()
                        humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
                        humanoid:ChangeState(Enum.HumanoidStateType.Running)
                    end)

                    if part then
                        pcall(function()
                            part.CFrame = CFrame.new(part.Position + Vector3.new(0, 2, 0))
                            part.AssemblyLinearVelocity = Vector3.zero
                        end)
                    end
                end
            end

            _antiDie.AutoRevive = function()
                if not _antiDie.config.autoRevive then
                    return
                end
                local character = localPlayer.Character
                if not character then
                    return
                end
                local humanoid = character:FindFirstChildOfClass("Humanoid")
                local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
                if not humanoid then
                    return
                end

                if humanoid.Health <= 0 then
                    _antiDie.SuperHeal(humanoid)

                    pcall(function()
                        humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
                        humanoid:ChangeState(Enum.HumanoidStateType.Running)
                    end)

                    if humanoidRootPart then
                        pcall(function()
                            humanoidRootPart.CFrame = CFrame.new(humanoidRootPart.Position + Vector3.new(0, 3, 0))
                            humanoidRootPart.AssemblyLinearVelocity = Vector3.zero
                        end)
                    end
                end
            end

            _antiDie.AttachHealth = function(instance)
                if _antiDie.healthConn then
                    _antiDie.healthConn:Disconnect()
                    _antiDie.healthConn = nil
                end

                local humanoid = instance and instance:FindFirstChildOfClass("Humanoid") or instance and instance:WaitForChild("Humanoid", 3)
                if not humanoid then
                    return
                end

                _antiDie.healthConn = humanoid:GetPropertyChangedSignal("Health"):Connect(function()
                    if not _antiDie.enabled then
                        return
                    end

                    if humanoid.Health < (humanoid.MaxHealth or 100) then
                        _antiDie.SuperHeal(humanoid)
                    end

                    if humanoid.Health <= 0 then
                        _antiDie.AutoRevive()
                    end
                end)

                if humanoid.Health < (humanoid.MaxHealth or 100) then
                    _antiDie.SuperHeal(humanoid)
                end
            end

            _antiDie.StartEngine = function()
                if _antiDie.enabled and _antiDie.loop then
                    return
                end
                _antiDie.enabled = true
                _antiDieEnabled = true
                antiDieEnabled = true

                if _antiDie.loop then
                    _antiDie.loop:Disconnect()
                    _antiDie.loop = nil
                end

                if _antiDie.healthConn then
                    _antiDie.healthConn:Disconnect()
                    _antiDie.healthConn = nil
                end

                _antiDie.loop = RunService.Heartbeat:Connect(function()
                    if not _antiDie.enabled then
                        return
                    end
                    local character = localPlayer.Character
                    if not character then
                        return
                    end
                    local humanoid = character:FindFirstChildOfClass("Humanoid")
                    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
                    if not humanoid then
                        return
                    end

                    if humanoid.Health <= 0 then
                        _antiDie.AutoRevive()
                    elseif humanoid.Health <= _antiDie.config.healthThreshold then
                        _antiDie.SuperHeal(humanoid)
                    elseif humanoid.Health < (humanoid.MaxHealth or 100) then
                        _antiDie.SuperHeal(humanoid)
                    end

                    _antiDie.PreventDamage(humanoidRootPart, humanoid)
                end)

                if localPlayer.Character then
                    _antiDie.AttachHealth(localPlayer.Character)
                end

                if _antiDie.charConn then
                    _antiDie.charConn:Disconnect()
                    _antiDie.charConn = nil
                end

                _antiDie.charConn = localPlayer.CharacterAdded:Connect(function(character)
                    if not _antiDie.enabled then
                        return
                    end
                    task.wait(0.05)
                    _antiDie.AttachHealth(character)
                    local humanoid = character:FindFirstChildOfClass("Humanoid")

                    if humanoid then
                        _antiDie.SuperHeal(humanoid)
                    end
                end)
            end

            _antiDie.StopEngine = function()
                _antiDie.enabled = false
                _antiDieEnabled = false
                antiDieEnabled = false

                if _antiDie.loop then
                    _antiDie.loop:Disconnect()
                    _antiDie.loop = nil
                end

                if _antiDie.healthConn then
                    _antiDie.healthConn:Disconnect()
                    _antiDie.healthConn = nil
                end

                if _antiDie.charConn then
                    _antiDie.charConn:Disconnect()
                    _antiDie.charConn = nil
                end

                pcall(function()
                    local character = localPlayer.Character
                    character = character and character:FindFirstChildOfClass("Humanoid")
                    if not character then
                        return
                    end
                    character:SetStateEnabled(Enum.HumanoidStateType.Dead, true)
                    character:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, true)
                    character:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
                    character.BreakJointsOnDeath = true

                    if character.MaxHealth == math.huge or character.MaxHealth <= 0 then
                        character.MaxHealth = 100
                        character.Health = math.min(character.Health, 100)
                    end
                end)
            end

            _antiDieSetEnabled = function(enabled)
                local isActive = enabled == true
                if isActive == _antiDieEnabled then
                    return
                end

                if isActive then
                    _antiDie.StartEngine()
                else
                    _antiDie.StopEngine()
                end
            end

            _antiDieRefresh = function()
                if _antiDieStopped then
                    return
                end
                _antiDieSetEnabled(_antiDieSources.toggle or _antiDieSources.autobat)
            end

            _G.__CrystalAntiDieSource = function(index, enabled)
                if _antiDieStopped or _antiDieSources[index] == nil then
                    return
                end
                _antiDieSources[index] = enabled == true
                _antiDieRefresh()
            end

            _G.__CrystalAntiDieSet = function(target)
                _G.__CrystalAntiDieSource("autobat", target)
            end

            _G.__CrystalAntiDieIsEnabled = function()
                return _antiDieEnabled
            end

            _G.__CrystalAntiDieStop = function()
                _antiDieStopped = true
                _antiDieSources.toggle = false
                _antiDieSources.autobat = false
                _antiDieSetEnabled(false)
            end

            activateOnCharacter = function(instance)
                if not _antiDieEnabled then
                    return
                end
                _antiDie.AttachHealth(instance)
                instance = instance and instance:FindFirstChildOfClass("Humanoid")

                if instance then
                    _antiDie.SuperHeal(instance)
                end
            end

            AntiDieModule = {
                enabled = false,
                start = function()
                    AntiDieModule.enabled = true
                    antiDieEnabled = true
                    _antiDieStopped = false
                    _G.__CrystalAntiDieSource("toggle", true)
                end,
                stop = function()
                    AntiDieModule.enabled = false
                    antiDieEnabled = false
                    _G.__CrystalAntiDieSource("toggle", false)
                end,
            }

            _G.AntiDie = AntiDieModule

            do
                local state = { Connection = nil }

                stopAntiBat = function()
                    antiBatEnabled = false

                    if state.Connection then
                        state.Connection:Disconnect()
                        state.Connection = nil
                    end
                end

                startAntiBat = function()
                    stopAntiBat()
                    antiBatEnabled = true
                    local character = localPlayer.Character
                    if not character then
                        return
                    end
                    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
                    if not humanoidRootPart then
                        return
                    end

                    state.Connection = RunService.Heartbeat:Connect(function()
                        if not antiBatEnabled then
                            return
                        end

                        if not humanoidRootPart or not humanoidRootPart.Parent then
                            humanoidRootPart = localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")
                            if not humanoidRootPart then
                                return
                            end
                        end

                        local assemblyLinearVelocity = humanoidRootPart.AssemblyLinearVelocity
                        local vector3 = Vector3.new(assemblyLinearVelocity.X, 0, assemblyLinearVelocity.Z)
                        humanoidRootPart.AssemblyLinearVelocity = Vector3.new(500, assemblyLinearVelocity.Y, 500)
                        RunService.RenderStepped:Wait()

                        if humanoidRootPart and humanoidRootPart.Parent then
                            humanoidRootPart.AssemblyLinearVelocity = Vector3.new(vector3.X, humanoidRootPart.AssemblyLinearVelocity.Y, vector3.Z)
                        end
                    end)
                end
            end
        end

        localPlayer.CharacterAdded:Connect(function()
            task.wait(0.3)

            if antiBatEnabled then
                startAntiBat()
            end
        end)

        setAntiFlingVisual = nil

        do
            local state = { connection = nil, threshold = 80, spinThreshold = 40 }

            local function readLiveSpeed()
                local youtLiveSpeed = _G.__YoutLiveSpeed
                if type(youtLiveSpeed) ~= "table" then
                    return false
                end
                local num = tonumber(youtLiveSpeed.t)
                local num2 = tonumber(youtLiveSpeed.v)
                if not num or not num2 or num2 <= 0 then
                    return false
                end
                return os.clock() - num <= 0.3
            end

            local function isAnyBatModeActive()
                if batDesyncTpEnabled then
                    return true
                end

                if youtBatV2PersistentState.enabled then
                    return true
                end

                if autoBatEnabled then
                    return true
                end

                if autoLeftEnabled or autoRightEnabled then
                    return true
                end
                return false
            end

            startAntiFling = function()
                if state.connection then
                    return
                end
                antiFlingEnabled = true

                state.connection = RunService.Heartbeat:Connect(function()
                    if not antiFlingEnabled then
                        return
                    end
                    local character = localPlayer.Character
                    if not character then
                        return
                    end
                    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
                    if not humanoidRootPart then
                        return
                    end
                    local humanoid = character:FindFirstChildOfClass("Humanoid")
                    if humanoid and (humanoid.Health <= 0 or humanoid.SeatPart) then
                        return
                    end

                    if dropActive or _G.IsDropping then
                        return
                    end

                    if isAnyBatModeActive() then
                        return
                    end

                    if readLiveSpeed() then
                        return
                    end
                    local assemblyLinearVelocity = humanoidRootPart.AssemblyLinearVelocity

                    if state.threshold < Vector3.new(assemblyLinearVelocity.X, 0, assemblyLinearVelocity.Z).Magnitude then
                        pcall(function()
                            humanoidRootPart.AssemblyLinearVelocity = Vector3.new(0, assemblyLinearVelocity.Y, 0)
                            humanoidRootPart.AssemblyAngularVelocity = Vector3.zero
                        end)

                        return
                    end

                    if state.spinThreshold < humanoidRootPart.AssemblyAngularVelocity.Magnitude then
                        pcall(function()
                            humanoidRootPart.AssemblyAngularVelocity = Vector3.zero
                        end)
                    end
                end)
            end

            stopAntiFling = function()
                antiFlingEnabled = false

                if state.connection then
                    state.connection:Disconnect()
                    state.connection = nil
                end
            end
        end
    end

    do
        local createEspObjects

        do
            localPlayer.CharacterAdded:Connect(function()
                task.wait(0.3)

                if antiFlingEnabled then
                    startAntiFling()
                end
            end)

            isEspActive = espEnabled or false
            espEntries = {}
            espMonitorConnection = nil
            Color3.fromRGB(139, 72, 246)
            Color3.fromRGB(48, 16, 92)

            do
                local function getEspColors(target)
                    return getThemeColor() or target or Color3.fromRGB(245, 245, 250), Color3.fromRGB(0, 0, 0)
                end

                createEspObjects = function()
                    local espColors, value = getEspColors()
                    local entries = {}
                    entries.Tracer = Drawing and Drawing.new("Line") or nil
                    entries.Highlight = Instance.new("Highlight")
                    entries.Lines = {}

                    if entries.Tracer then
                        entries.Tracer.Color = value
                        entries.Tracer.Thickness = 3
                        entries.Tracer.Transparency = 1
                        entries.Tracer.ZIndex = 2
                    end

                    entries.Highlight.Name = "YoutESP_Highlight"
                    entries.Highlight.FillColor = espColors
                    entries.Highlight.OutlineColor = Color3.fromRGB(0, 0, 0)
                    entries.Highlight.FillTransparency = 0.12
                    entries.Highlight.OutlineTransparency = 0.18
                    entries.Highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop

                    local success, result = pcall(function()
                        return game:GetService("CoreGui"):FindFirstChild("RobloxGui")
                    end)

                    local CoreGui

                    if success and result then
                        CoreGui = result
                    else
                        CoreGui = localPlayer:FindFirstChildOfClass("PlayerGui")
                    end

                    CoreGui = CoreGui or game:GetService("CoreGui")

                    pcall(function()
                        entries.Highlight.Parent = CoreGui
                    end)

                    local billboardGui = Instance.new("BillboardGui")
                    billboardGui.Name = "YoutEnemySpeedBillboard"
                    billboardGui.Size = UDim2.new(0, 170, 0, 28)
                    billboardGui.StudsOffset = Vector3.new(0, 1.3, 0)
                    billboardGui.AlwaysOnTop = true
                    billboardGui.Parent = CoreGui
                    local textLabel2 = Instance.new("TextLabel")
                    textLabel2.Size = UDim2.new(0, 170, 0, 28)
                    textLabel2.AnchorPoint = Vector2.new(0.5, 0)
                    textLabel2.Position = UDim2.new(0.5, 0, 0, 2)
                    textLabel2.BackgroundTransparency = 1
                    textLabel2.Text = ""
                    textLabel2.TextColor3 = getThemeColor()
                    textLabel2.TextSize = 15
                    textLabel2.Font = Enum.Font.GothamBold
                    textLabel2.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                    textLabel2.TextStrokeTransparency = 0
                    textLabel2.TextXAlignment = Enum.TextXAlignment.Center
                    textLabel2.TextYAlignment = Enum.TextYAlignment.Center
                    textLabel2.ZIndex = 5
                    textLabel2.Parent = billboardGui
                    local uiStroke = Instance.new("UIStroke")
                    uiStroke.Color = Color3.fromRGB(0, 0, 0)
                    uiStroke.Thickness = 2.2
                    uiStroke.Transparency = 0.12
                    uiStroke.Parent = textLabel2

                    if Drawing then
                        for index = 1, 14 do
                            local line = Drawing.new("Line")
                            line.Color = value
                            line.Thickness = 2
                            line.Transparency = 1
                            line.ZIndex = 3
                            table.insert(entries.Lines, line)
                        end
                    end

                    entries.NameTag = billboardGui
                    entries.NameLabel = textLabel2
                    entries.NameOutline = uiStroke
                    return entries
                end

                _G.__YoutRefreshESPTheme = function(target)
                    local espColors, value = getEspColors(target)

                    for _, espEntry in pairs(espEntries) do
                        if type(espEntry) == "table" and espEntry.esp then
                            local esp = espEntry.esp

                            if esp.Tracer then
                                pcall(function()
                                    esp.Tracer.Color = value
                                end)
                            end

                            if esp.Highlight then
                                esp.Highlight.FillColor = espColors
                                esp.Highlight.OutlineColor = Color3.fromRGB(0, 0, 0)
                            end

                            if esp.NameLabel then
                                esp.NameLabel.TextColor3 = getThemeColor()
                                esp.NameLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                            end

                            if esp.NameOutline then
                                esp.NameOutline.Color = Color3.fromRGB(0, 0, 0)
                            end

                            for _, line in ipairs((esp.Lines or {})) do
                                pcall(function()
                                    line.Color = value
                                end)
                            end
                        end
                    end
                end
            end
        end

        removeEspForPlayer = function(index)
            local entry = espEntries[index]

            if entry then
                if entry.esp.Tracer then
                    pcall(function()
                        entry.esp.Tracer:Remove()
                    end)
                end

                if entry.esp.Highlight then
                    pcall(function()
                        entry.esp.Highlight:Destroy()
                    end)
                end

                if entry.esp.NameTag then
                    pcall(function()
                        entry.esp.NameTag:Destroy()
                    end)
                end

                for _, line in ipairs(entry.esp.Lines) do
                    pcall(function()
                        line:Remove()
                    end)
                end

                espEntries[index] = nil
            end
        end

        do
            local function updateEspEntry(player, items)
                if not isEspActive then
                    if items.Tracer then
                        items.Tracer.Visible = false
                    end

                    items.Highlight.Enabled = false

                    for _, line in ipairs(items.Lines) do
                        line.Visible = false
                    end

                    if items.NameTag then
                        items.NameTag.Enabled = false
                    end

                    return
                end

                local character = player.Character
                local humanoid = character and character:FindFirstChildOfClass("Humanoid")
                local humanoidRootPart

                if character then
                    humanoidRootPart = character:FindFirstChild("HumanoidRootPart") or character.PrimaryPart or character:FindFirstChild("UpperTorso") or character:FindFirstChild("Torso") or character:FindFirstChild("Head")
                else
                    humanoidRootPart = character
                end

                if character and humanoidRootPart and (not humanoid or humanoid.Health > 0) then
                    items.Highlight.Adornee = character
                    items.Highlight.Enabled = isEspActive

                    if items.Tracer then
                        items.Tracer.Visible = false
                    end

                    for _, line in ipairs(items.Lines) do
                        line.Visible = false
                    end

                    if items.NameTag and items.NameLabel then
                        pcall(function()
                            items.NameTag.Adornee = humanoidRootPart
                            items.NameTag.Enabled = isEspActive
                            items.NameLabel.Text = player.Name or player.DisplayName or ""
                            items.NameLabel.TextColor3 = getThemeColor()
                        end)
                    end
                else
                    if items.Tracer then
                        items.Tracer.Visible = false
                    end

                    items.Highlight.Enabled = false
                    items.Highlight.Adornee = nil

                    for _, line in ipairs(items.Lines) do
                        line.Visible = false
                    end

                    if items.NameTag then
                        items.NameTag.Enabled = false
                    end
                end
            end

            local function removeEspTags(index)
                if index == localPlayer then
                    return
                end

                if espEntries[index] and espEntries[index].esp then
                    if espEntries[index].esp.NameTag then
                        pcall(function()
                            espEntries[index].esp.NameTag.Enabled = isEspActive
                        end)
                    end

                    return
                end

                removeEspForPlayer(index)
                espEntries[index] = { esp = createEspObjects() }
            end

            espPlayerAddedConnection = nil
            espPlayerRemovingConnection = nil

            enableEsp = function()
                if isEspActive then
                    return
                end
                isEspActive = true

                for _, player in pairs(Players:GetPlayers()) do
                    if player ~= localPlayer then
                        task.spawn(function()
                            removeEspTags(player)
                        end)
                    end
                end

                local counter = 0

                if espMonitorConnection then
                    espMonitorConnection:Disconnect()
                end

                espMonitorConnection = RunService.Heartbeat:Connect(function(deltaTime)
                    counter += deltaTime or 0
                    if counter < 0.15 then
                        return
                    end
                    counter = 0

                    for espEntry, espEntry2 in pairs(espEntries) do
                        if typeof(espEntry) == "Instance" and espEntry:IsA("Player") and espEntry2 and espEntry2.esp then
                            pcall(function()
                                updateEspEntry(espEntry, espEntry2.esp)
                            end)
                        end
                    end
                end)

                espPlayerAddedConnection = Players.PlayerAdded:Connect(function(player)
                    if not isEspActive or player == localPlayer then
                        return
                    end
                    task.wait(0.3)
                    removeEspTags(player)
                end)

                espPlayerRemovingConnection = Players.PlayerRemoving:Connect(function(player)
                    removeEspForPlayer(player)
                end)
            end
        end
    end
end

local refreshTpBatButton, connection, tpBat

do
    do
        local data, collectCharacterBaseParts

        do
            do
                do
                    do
                        do
                            local function disableEsp()
                                isEspActive = false

                                if espMonitorConnection then
                                    espMonitorConnection:Disconnect()
                                    espMonitorConnection = nil
                                end

                                if espPlayerAddedConnection then
                                    pcall(function()
                                        espPlayerAddedConnection:Disconnect()
                                    end)

                                    espPlayerAddedConnection = nil
                                end

                                if espPlayerRemovingConnection then
                                    pcall(function()
                                        espPlayerRemovingConnection:Disconnect()
                                    end)

                                    espPlayerRemovingConnection = nil
                                end

                                for espEntry in pairs(espEntries) do
                                    if typeof(espEntry) == "Instance" and espEntry:IsA("Player") and espEntry ~= localPlayer then
                                        removeEspForPlayer(espEntry)
                                    end
                                end
                            end

                            toggleESP = function(enabled)
                                if enabled then
                                    enableEsp()
                                else
                                    disableEsp()
                                end

                                if setESPVIsual then
                                    setESPVIsual(enabled)
                                end
                            end
                        end
                    end

                    do
                        local screenGui = nil
                        local frame = nil
                        local uiStroke = nil
                        local connection2 = nil
                        local data2 = { scanElapsed = math.huge, targetRoot = nil }

                        local function ensureEspScreenGui()
                            if screenGui and screenGui.Parent then
                                return
                            end
                            screenGui = Instance.new("ScreenGui")
                            screenGui.Name = "YoutESPLine"
                            screenGui.IgnoreGuiInset = true
                            screenGui.ResetOnSpawn = false
                            screenGui.DisplayOrder = 1000
                            screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

                            if not pcall(function()
                                screenGui.Parent = game:GetService("CoreGui")
                                end) then
                                screenGui.Parent = localPlayer:WaitForChild("PlayerGui")
                            end

                            frame = Instance.new("Frame")
                            frame.Name = "YoutStatusFrame"
                            frame.AnchorPoint = Vector2.new(0.5, 0.5)
                            frame.BorderSizePixel = 0
                            frame.Active = false
                            frame.Visible = false
                            frame.BackgroundColor3 = getThemeColor()
                            frame.ZIndex = 1
                            frame.Parent = screenGui
                            uiStroke = Instance.new("UIStroke", frame)
                            uiStroke.Color = Color3.fromRGB(255, 255, 255)
                            uiStroke.Thickness = 0.7
                            uiStroke.Transparency = 0.55
                        end

                        stopESPLine = function()
                            espLineEnabled = false

                            if connection2 then
                                connection2:Disconnect()
                                connection2 = nil
                            end

                            if frame then
                                frame.Visible = false
                            end

                            data2.targetRoot = nil
                            data2.scanElapsed = math.huge

                            if screenGui and screenGui.Parent then
                                pcall(function()
                                    screenGui:Destroy()
                                end)
                            end

                            screenGui = nil
                            frame = nil
                            uiStroke = nil
                        end

                        startESPLine = function()
                            espLineEnabled = true
                            ensureEspScreenGui()

                            if connection2 then
                                connection2:Disconnect()
                            end

                            data2.scanElapsed = math.huge
                            data2.targetRoot = nil

                            connection2 = RunService.RenderStepped:Connect(function(deltaTime)
                                if not espLineEnabled then
                                    if frame then
                                        frame.Visible = false
                                    end

                                    return
                                end

                                if not pcall(function()
                                    local currentCamera = workspace.CurrentCamera
                                    local character = localPlayer.Character

                                    if character then
                                        character = character:FindFirstChild("UpperTorso") or character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("Torso")
                                    end

                                    if not currentCamera or not character then
                                        if frame then
                                            frame.Visible = false
                                        end

                                        return
                                    end

                                    local position = character.Position
                                    data2.scanElapsed = data2.scanElapsed + (deltaTime or 0)
                                    local targetRoot = data2.targetRoot
                                    local parent = targetRoot and targetRoot.Parent
                                    parent = parent and parent:FindFirstChildOfClass("Humanoid")

                                    if data2.scanElapsed >= 0.12 or not (targetRoot and targetRoot.Parent and (not parent or parent.Health > 0)) then
                                        data2.scanElapsed = 0
                                        local huge2 = math.huge
                                        local value = nil

                                        for _, player in ipairs(Players:GetPlayers()) do
                                            if player ~= localPlayer then
                                                local character2 = player.Character
                                                local humanoid = character2 and character2:FindFirstChildOfClass("Humanoid")

                                                if character2 then
                                                    character2 = character2:FindFirstChild("HumanoidRootPart") or character2:FindFirstChild("LowerTorso") or character2:FindFirstChild("Torso")
                                                end

                                                if character2 and character2:IsA("BasePart") and (not humanoid or humanoid.Health > 0) then
                                                    local offset = character2.Position - position
                                                    local dot = offset:Dot(offset)

                                                    if dot < huge2 then
                                                        huge2 = dot
                                                        value = character2
                                                    end
                                                end
                                            end
                                        end

                                        data2.targetRoot = value
                                    end

                                    local targetRoot = data2.targetRoot

                                    if not targetRoot or not targetRoot.Parent then
                                        if frame then
                                            frame.Visible = false
                                        end

                                        return
                                    end

                                    local value = currentCamera:WorldToViewportPoint(position - Vector3.new(0, character.Size.Y * 0.35, 0))
                                    local value2, value3 = currentCamera:WorldToViewportPoint(targetRoot.Position)
                                    local viewportSize = currentCamera.ViewportSize
                                    local vector3 = Vector2.new(value.X, value.Y)
                                    local vector4 = Vector2.new(value2.X, value2.Y)

                                    if not value3 or value2.Z <= 0 then
                                        local amount = viewportSize * 0.5
                                        local offset = vector4 - amount

                                        if value2.Z <= 0 then
                                            offset = -offset
                                        end

                                        if offset.Magnitude < 0.001 then
                                            offset = Vector2.new(0, -1)
                                        end

                                        local vector5 = Vector2.new(math.max(8, amount.X - 8), math.max(8, (amount.Y - 8)))
                                        vector4 = amount + offset * math.min(vector5.X / math.max(math.abs(offset.X), 0.001), vector5.Y / math.max(math.abs(offset.Y), 0.001))
                                    end

                                    if value.Z <= 0 or vector3.X < 0 or vector3.X > viewportSize.X or vector3.Y < 0 or vector3.Y > viewportSize.Y then
                                        vector3 = Vector2.new(viewportSize.X * 0.5, viewportSize.Y - 8)
                                    end

                                    local offset = vector4 - vector3
                                    local amount = (vector3 + vector4) * 0.5
                                    frame.Position = UDim2.fromOffset(amount.X, amount.Y)

                                    frame.Size = UDim2.fromOffset(math.max(offset.Magnitude, 1), 2)
                                    frame.Rotation = math.deg(math.atan2(offset.Y, offset.X))
                                    frame.BackgroundColor3 = getThemeColor()
                                    frame.Visible = true
                                    end) and frame then
                                    pcall(function()
                                        frame.Visible = false
                                    end)
                                end
                            end)
                        end
                    end
                end

                do
                    local counter = 0

                    updateEnemySpeedLabels = function()
                        counter += 1
                        if counter < 6 then
                            return
                        end
                        counter = 0
                        local themeColor = getThemeColor()
                        local cachedPlayers = getCachedPlayers()

                        for index = 1, #cachedPlayers do
                            local entry = cachedPlayers[index]

                            if entry ~= localPlayer then
                                local character = entry.Character
                                local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
                                local humanoid = character and character:FindFirstChildOfClass("Humanoid")

                                if humanoidRootPart and humanoid and humanoid.Health > 0 then
                                    local assemblyLinearVelocity = humanoidRootPart.AssemblyLinearVelocity
                                    local distance = sqrt(assemblyLinearVelocity.X * assemblyLinearVelocity.X + assemblyLinearVelocity.Z * assemblyLinearVelocity.Z)
                                    local textLabel2 = enemySpeedLabels[entry]

                                    if not textLabel2 then
                                        local head = character:FindFirstChild("Head")

                                        if head then
                                            local billboardGui = Instance.new("BillboardGui")
                                            billboardGui.Size = UDim2.new(0, 100, 0, 25)
                                            billboardGui.StudsOffset = vector(0, 5.5, 0)
                                            billboardGui.AlwaysOnTop = true
                                            billboardGui.Name = "EnemySpeedGui"
                                            billboardGui.Parent = head
                                            textLabel2 = Instance.new("TextLabel", billboardGui)
                                            textLabel2.Size = UDim2.new(1, 0, 1, 0)
                                            textLabel2.BackgroundTransparency = 1
                                            textLabel2.TextColor3 = themeColor
                                            textLabel2.Font = Enum.Font.GothamBold
                                            textLabel2.TextScaled = true
                                            textLabel2.TextStrokeTransparency = 0
                                            textLabel2.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                                            enemySpeedLabels[entry] = textLabel2
                                        end
                                    elseif textLabel2.Parent and textLabel2.Parent.Parent ~= character then
                                        local head = character:FindFirstChild("Head")

                                        if head then
                                            textLabel2.Parent.Parent = head
                                        end
                                    end

                                    if textLabel2 then
                                        textLabel2.Text = string.format("%.1f", distance)

                                        if textLabel2.TextColor3 ~= themeColor then
                                            textLabel2.TextColor3 = themeColor
                                        end
                                    end
                                else
                                    local entry2 = enemySpeedLabels[entry]

                                    if entry2 and entry2.Parent and entry2.Parent.Parent then
                                        entry2.Parent.Parent = nil
                                    end

                                    enemySpeedLabels[entry] = nil
                                end
                            end
                        end
                    end
                end

                startEnemySpeed = function()
                    if enemySpeedConn then
                        enemySpeedConn:Disconnect()
                    end

                    enemySpeedConn = RunService.Heartbeat:Connect(updateEnemySpeedLabels)
                end

                stopEnemySpeed = function()
                    if enemySpeedConn then
                        enemySpeedConn:Disconnect()
                        enemySpeedConn = nil
                    end
                end

                do
                    local function getLocalRoot()
                        local character = localPlayer.Character
                        if not character then
                            return nil
                        end
                        local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
                        if not humanoidRootPart then
                            return nil
                        end
                        local position = humanoidRootPart.Position
                        local cachedPlayers = getCachedPlayers()
                        local closestDistance = huge
                        local value = nil

                        for index = 1, #cachedPlayers do
                            local entry = cachedPlayers[index]

                            if entry ~= localPlayer then
                                local character = entry.Character

                                if character then
                                    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")

                                    if humanoidRootPart then
                                        local humanoid = character:FindFirstChildOfClass("Humanoid")

                                        if humanoid and humanoid.Health > 0 then
                                            local offset = humanoidRootPart.Position.X - position.X
                                            local offset2 = humanoidRootPart.Position.Y - position.Y
                                            local offset3 = humanoidRootPart.Position.Z - position.Z
                                            local amount = offset * offset + offset2 * offset2 + offset3 * offset3

                                            if amount < closestDistance then
                                                closestDistance = amount
                                                value = humanoidRootPart
                                            end
                                        end
                                    end
                                end
                            end
                        end

                        return value
                    end

                    local function applyBodyLock()
                        local character = localPlayer.Character
                        if not character then
                            return
                        end
                        local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
                        if not humanoidRootPart then
                            return
                        end
                        local humanoid = character:FindFirstChildOfClass("Humanoid")
                        if not humanoid then
                            return
                        end
                        local localRoot = getLocalRoot()

                        if not localRoot then
                            if not humanoid.AutoRotate then
                                humanoid.AutoRotate = true
                            end

                            return
                        end

                        if bodyLockRange < (localRoot.Position - humanoidRootPart.Position).Magnitude then
                            if not humanoid.AutoRotate then
                                humanoid.AutoRotate = true
                            end

                            return
                        end

                        if humanoid.AutoRotate then
                            humanoid.AutoRotate = false
                        end

                        local assemblyLinearVelocity = localRoot.AssemblyLinearVelocity
                        local distance = localRoot.Position + assemblyLinearVelocity * clamp(assemblyLinearVelocity.Magnitude / 80, 0.08, 0.35)
                        local head = localRoot.Parent and localRoot.Parent:FindFirstChild("Head")
                        local vector3 = vector(distance.X, humanoidRootPart.Position.Y + clamp(((head and head.Position.Y or localRoot.Position.Y) - humanoidRootPart.Position.Y + (humanoid.HipHeight or 0)) * 0.15, -1.5, 1.5), distance.Z)

                        if (vector3 - humanoidRootPart.Position).Magnitude > 0.1 then
                            local value = cframe2(humanoidRootPart.Position, vector3)
                            local value2, value2 = (humanoidRootPart.CFrame:Inverse() * value):ToEulerAnglesXYZ()
                            humanoidRootPart.AssemblyAngularVelocity = humanoidRootPart.CFrame:VectorToWorldSpace(vector(0, clamp(value2, -2.5, 2.5) * 42, 0))
                        end
                    end

                    startBodyLock = function()
                        if _bodyLockConn then
                            _bodyLockConn:Disconnect()
                        end

                        local counter = 0

                        _bodyLockConn = RunService.Heartbeat:Connect(function(deltaTime)
                            if not bodyLockEnabled then
                                return
                            end

                            if 0 < _blSuppressCount then
                                return
                            end
                            counter += deltaTime
                            if counter < 0.033 then
                                return
                            end
                            counter = 0
                            applyBodyLock()
                        end)
                    end
                end
            end

            do
                local removeLockInstances

                do
                    do
                        stopBodyLock = function()
                            if _bodyLockConn then
                                _bodyLockConn:Disconnect()
                                _bodyLockConn = nil
                            end

                            local character = localPlayer.Character
                            local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")

                            if humanoidRootPart then
                                humanoidRootPart.AssemblyAngularVelocity = vector2
                                humanoidRootPart.AssemblyLinearVelocity = vector(humanoidRootPart.AssemblyLinearVelocity.X, -0.1, humanoidRootPart.AssemblyLinearVelocity.Z)
                            end

                            character = character and character:FindFirstChildOfClass("Humanoid")

                            if character then
                                character.AutoRotate = true
                            end
                        end

                        _suppressBodyLock = function()
                            _blSuppressCount = _blSuppressCount + 1

                            if _blSuppressCount == 1 and bodyLockEnabled then
                                _blWasEnabled = true
                                stopBodyLock()

                                if bodyLockSetVisual then
                                    bodyLockSetVisual(false)
                                end

                                if _blRestoreTimer then
                                    task.cancel(_blRestoreTimer)
                                    _blRestoreTimer = nil
                                end

                                _blSmoothRestore = false
                            end
                        end

                        _unsuppressBodyLock = function(enabled)
                            if _blSuppressCount > 0 then
                                _blSuppressCount = _blSuppressCount - 1
                            end

                            if _blSuppressCount == 0 and _blWasEnabled then
                                _blWasEnabled = false

                                if _blRestoreTimer then
                                    pcall(task.cancel, _blRestoreTimer)
                                    _blRestoreTimer = nil
                                end

                                local function restoreBodyLock()
                                    _blRestoreTimer = nil

                                    if bodyLockEnabled then
                                        _blSmoothRestore = true
                                        startBodyLock()

                                        if bodyLockSetVisual then
                                            bodyLockSetVisual(true)
                                        end

                                        task.delay(0.5, function()
                                            _blSmoothRestore = false
                                        end)
                                    end
                                end

                                if enabled then
                                    _blRestoreTimer = task.delay(1, restoreBodyLock)
                                else
                                    restoreBodyLock()
                                end
                            end
                        end

                        setupSpeedIndicator = function(instance)
                            local head = instance:WaitForChild("Head", 5)
                            if not head then
                                return
                            end
                            local youtSpeedIndicator = head:FindFirstChild("YoutSpeedIndicator")

                            if youtSpeedIndicator then
                                youtSpeedIndicator:Destroy()
                            end

                            local discordText = head:FindFirstChild("DiscordText")

                            if discordText then
                                discordText:Destroy()
                            end

                            local instance = Instance.new("BillboardGui", head)
                            instance.Name = "YoutSpeedIndicator"
                            instance.Size = UDim2.fromOffset(200, 58)
                            instance.StudsOffset = Vector3.new(0, 3.2, 0)
                            instance.AlwaysOnTop = true
                            instance.LightInfluence = 0
                            instance.MaxDistance = 0
                            local textLabel2 = Instance.new("TextLabel", instance)
                            textLabel2.Name = "SpeedLabel"
                            textLabel2.Size = UDim2.new(1, 0, 0, 28)
                            textLabel2.Position = UDim2.new(0, 0, 0, 0)
                            textLabel2.BackgroundTransparency = 1
                            textLabel2.Text = "discord.gg/yout"
                            textLabel2.TextColor3 = color
                            textLabel2.Font = Enum.Font.GothamBlack
                            textLabel2.TextSize = 19
                            textLabel2.TextXAlignment = Enum.TextXAlignment.Center
                            textLabel2.TextYAlignment = Enum.TextYAlignment.Center
                            textLabel2.TextStrokeTransparency = 0
                            textLabel2.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                            local instance2 = Instance.new("UIStroke", textLabel2)
                            instance2.Color = Color3.fromRGB(0, 0, 0)
                            instance2.Thickness = 1.5
                            instance2.Transparency = 0.2
                            applyShimmerToText(textLabel2, 0.9)
                            speedLabel = Instance.new("TextLabel", instance)
                            speedLabel.Name = "SpeedLabel"
                            speedLabel.Size = UDim2.new(1, 0, 0, 30)
                            speedLabel.Position = UDim2.new(0, 0, 0, 28)
                            speedLabel.BackgroundTransparency = 1
                            speedLabel.Text = "0.0  -  " .. getSpeedModeName()
                            speedLabel.TextColor3 = color
                            speedLabel.Font = Enum.Font.GothamBlack
                            speedLabel.TextSize = 22
                            speedLabel.TextXAlignment = Enum.TextXAlignment.Center
                            speedLabel.TextYAlignment = Enum.TextYAlignment.Center
                            speedLabel.TextStrokeTransparency = 0
                            speedLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                            local instance = Instance.new("UIStroke", speedLabel)
                            instance.Color = Color3.fromRGB(0, 0, 0)
                            instance.Thickness = 1.5
                            instance.Transparency = 0.2
                            applyShimmerToText(speedLabel, 0.9)
                        end

                        do
                            local clone = nil

                            startUnwalk = function()
                                local character = localPlayer.Character
                                if not character then
                                    return
                                end
                                local humanoid = character:FindFirstChildOfClass("Humanoid")

                                if humanoid then
                                    for _, track in ipairs(humanoid:GetPlayingAnimationTracks()) do
                                        pcall(function()
                                            track:Stop()
                                        end)
                                    end
                                end

                                local animate = character:FindFirstChild("Animate")

                                if animate then
                                    clone = animate:Clone()
                                    animate:Destroy()
                                end
                            end

                            stopUnwalk = function()
                                local character = localPlayer.Character

                                if character then
                                    if not character:FindFirstChild("Animate") then
                                        local starterCharacterScripts = game:GetService("StarterPlayer"):FindFirstChildOfClass("StarterCharacterScripts")
                                        starterCharacterScripts = starterCharacterScripts and starterCharacterScripts:FindFirstChild("Animate")

                                        if starterCharacterScripts then
                                            starterCharacterScripts:Clone().Parent = character
                                        elseif clone then
                                            clone:Clone().Parent = character
                                        end
                                    end
                                end

                                clone = nil
                            end
                        end
                    end

                    refreshSpeedModeLabel = function()
                        if modeValLbl then
                            if laggerCarryToggled then
                                modeValLbl.Text = "Lagger Carry"
                            elseif laggerToggled then
                                modeValLbl.Text = "Lagger Normal"
                            elseif speedMode then
                                modeValLbl.Text = "Carry"
                            else
                                modeValLbl.Text = "Normal"
                            end
                        end

                        if setCarryModeVisual then
                            setCarryModeVisual(speedMode)
                        end

                        if setLaggerModeVisual then
                            setLaggerModeVisual(laggerToggled)
                        end

                        if setLaggerCarryVisual then
                            setLaggerCarryVisual(laggerCarryToggled)
                        end
                    end

                    resetMovementState = function()
                        refreshSpeedModeLabel()

                        if mobSetCarry then
                            mobSetCarry(speedMode)
                        end

                        if setLaggerModeVisual then
                            setLaggerModeVisual(laggerToggled)
                        end

                        if setLaggerCarryVisual then
                            setLaggerCarryVisual(laggerCarryToggled)
                        end
                    end

                    toggleCarryMode = function()
                        if laggerToggled or laggerCarryToggled then
                            laggerToggled = false
                            laggerCarryToggled = false
                            speedMode = true
                        else
                            speedMode = not speedMode
                        end

                        resetMovementState()

                        if _G.__YoutApplySpeedNow then
                            pcall(_G.__YoutApplySpeedNow)
                        end
                    end

                    toggleLaggerMode = function()
                        if laggerCarryToggled then
                            laggerCarryToggled = false
                        end

                        speedMode = false
                        laggerToggled = not laggerToggled
                        resetMovementState()

                        if _G.__YoutApplySpeedNow then
                            pcall(_G.__YoutApplySpeedNow)
                        end
                    end

                    toggleLaggerCarryMode = function()
                        if laggerToggled then
                            laggerToggled = false
                        end

                        speedMode = false
                        laggerCarryToggled = not laggerCarryToggled
                        resetMovementState()

                        if _G.__YoutApplySpeedNow then
                            pcall(_G.__YoutApplySpeedNow)
                        end
                    end

                    toggleLaggerCycle = function()
                        if speedMode then
                            speedMode = false
                            laggerToggled = true
                            laggerCarryToggled = false
                        elseif laggerToggled then
                            speedMode = false
                            laggerToggled = false
                            laggerCarryToggled = true
                        else
                            speedMode = true
                            laggerToggled = false
                            laggerCarryToggled = false
                        end

                        resetMovementState()

                        if _G.__YoutApplySpeedNow then
                            pcall(_G.__YoutApplySpeedNow)
                        end
                    end

                    stopAutoLeft = function()
                        if alConn then
                            alConn:Disconnect()
                            alConn = nil
                        end

                        alPhase = 1
                        local character = localPlayer.Character

                        if character then
                            local humanoid = character:FindFirstChildOfClass("Humanoid")

                            if humanoid then
                                humanoid:Move(vector2, false)
                            end
                        end

                        if autoLeftSetVisual then
                            autoLeftSetVisual(false)
                        end

                        if mobSetAutoLeft then
                            mobSetAutoLeft(false)
                        end

                        _unsuppressBodyLock(true)
                    end

                    startAutoLeft = function()
                        if autoRightEnabled then
                            autoRightEnabled = false
                            stopAutoRight()

                            if autoRightSetVisual then
                                autoRightSetVisual(false)
                            end

                            if mobSetAutoRight then
                                mobSetAutoRight(false)
                            end
                        end

                        disableAllAimbots()
                        _suppressBodyLock()

                        if alConn then
                            alConn:Disconnect()
                        end

                        alPhase = 1

                        alConn = RunService.Heartbeat:Connect(function()
                            if not autoLeftEnabled then
                                return
                            end
                            local character = localPlayer.Character
                            if not character then
                                return
                            end
                            local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
                            local humanoid = character:FindFirstChildOfClass("Humanoid")
                            if not humanoidRootPart or not humanoid then
                                return
                            end
                            local capturedNS = NORMAL_SPEED

                            if alPhase == 1 then
                                if (vector(AUTO_PATH_POINTS.L1.X, humanoidRootPart.Position.Y, AUTO_PATH_POINTS.L1.Z) - humanoidRootPart.Position).Magnitude < 1 then
                                    alPhase = 2
                                    local offset = AUTO_PATH_POINTS.L2 - humanoidRootPart.Position
                                    local unit = vector(offset.X, 0, offset.Z).Unit
                                    humanoid:Move(unit, false)
                                    humanoidRootPart.AssemblyLinearVelocity = vector(unit.X * capturedNS, humanoidRootPart.AssemblyLinearVelocity.Y, unit.Z * capturedNS)
                                    return
                                end

                                local offset = AUTO_PATH_POINTS.L1 - humanoidRootPart.Position
                                local unit = vector(offset.X, 0, offset.Z).Unit
                                humanoid:Move(unit, false)
                                humanoidRootPart.AssemblyLinearVelocity = vector(unit.X * capturedNS, humanoidRootPart.AssemblyLinearVelocity.Y, unit.Z * capturedNS)
                            elseif alPhase == 2 then
                                if (vector(AUTO_PATH_POINTS.L2.X, humanoidRootPart.Position.Y, AUTO_PATH_POINTS.L2.Z) - humanoidRootPart.Position).Magnitude < 1 then
                                    humanoid:Move(vector2, false)
                                    humanoidRootPart.AssemblyLinearVelocity = vector2
                                    autoLeftEnabled = false

                                    if alConn then
                                        alConn:Disconnect()
                                        alConn = nil
                                    end

                                    alPhase = 1

                                    if autoLeftSetVisual then
                                        autoLeftSetVisual(false)
                                    end

                                    if mobSetAutoLeft then
                                        mobSetAutoLeft(false)
                                    end

                                    _unsuppressBodyLock(true)
                                    local vector3 = vector(AUTO_PATH_POINTS.L_FACE.X, humanoidRootPart.Position.Y, AUTO_PATH_POINTS.L_FACE.Z)

                                    if (vector3 - humanoidRootPart.Position).Magnitude > 0.01 then
                                        humanoidRootPart.CFrame = cframe(humanoidRootPart.Position, vector3)
                                    end

                                    return
                                end

                                local offset = AUTO_PATH_POINTS.L2 - humanoidRootPart.Position
                                local unit = vector(offset.X, 0, offset.Z).Unit
                                humanoid:Move(unit, false)
                                humanoidRootPart.AssemblyLinearVelocity = vector(unit.X * capturedNS, humanoidRootPart.AssemblyLinearVelocity.Y, unit.Z * capturedNS)
                            end
                        end)
                    end

                    stopAutoRight = function()
                        if arConn then
                            arConn:Disconnect()
                            arConn = nil
                        end

                        arPhase = 1
                        local character = localPlayer.Character

                        if character then
                            local humanoid = character:FindFirstChildOfClass("Humanoid")

                            if humanoid then
                                humanoid:Move(vector2, false)
                            end
                        end

                        if autoRightSetVisual then
                            autoRightSetVisual(false)
                        end

                        if mobSetAutoRight then
                            mobSetAutoRight(false)
                        end

                        _unsuppressBodyLock(true)
                    end

                    startAutoRight = function()
                        if autoLeftEnabled then
                            autoLeftEnabled = false
                            stopAutoLeft()

                            if autoLeftSetVisual then
                                autoLeftSetVisual(false)
                            end

                            if mobSetAutoLeft then
                                mobSetAutoLeft(false)
                            end
                        end

                        disableAllAimbots()
                        _suppressBodyLock()

                        if arConn then
                            arConn:Disconnect()
                        end

                        arPhase = 1

                        arConn = RunService.Heartbeat:Connect(function()
                            if not autoRightEnabled then
                                return
                            end
                            local character = localPlayer.Character
                            if not character then
                                return
                            end
                            local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
                            local humanoid = character:FindFirstChildOfClass("Humanoid")
                            if not humanoidRootPart or not humanoid then
                                return
                            end
                            local capturedNS = NORMAL_SPEED

                            if arPhase == 1 then
                                if (vector(AUTO_PATH_POINTS.R1.X, humanoidRootPart.Position.Y, AUTO_PATH_POINTS.R1.Z) - humanoidRootPart.Position).Magnitude < 1 then
                                    arPhase = 2
                                    local offset = AUTO_PATH_POINTS.R2 - humanoidRootPart.Position
                                    local unit = vector(offset.X, 0, offset.Z).Unit
                                    humanoid:Move(unit, false)
                                    humanoidRootPart.AssemblyLinearVelocity = vector(unit.X * capturedNS, humanoidRootPart.AssemblyLinearVelocity.Y, unit.Z * capturedNS)
                                    return
                                end

                                local offset = AUTO_PATH_POINTS.R1 - humanoidRootPart.Position
                                local unit = vector(offset.X, 0, offset.Z).Unit
                                humanoid:Move(unit, false)
                                humanoidRootPart.AssemblyLinearVelocity = vector(unit.X * capturedNS, humanoidRootPart.AssemblyLinearVelocity.Y, unit.Z * capturedNS)
                            elseif arPhase == 2 then
                                if (vector(AUTO_PATH_POINTS.R2.X, humanoidRootPart.Position.Y, AUTO_PATH_POINTS.R2.Z) - humanoidRootPart.Position).Magnitude < 1 then
                                    humanoid:Move(vector2, false)
                                    humanoidRootPart.AssemblyLinearVelocity = vector2
                                    autoRightEnabled = false

                                    if arConn then
                                        arConn:Disconnect()
                                        arConn = nil
                                    end

                                    arPhase = 1

                                    if autoRightSetVisual then
                                        autoRightSetVisual(false)
                                    end

                                    if mobSetAutoRight then
                                        mobSetAutoRight(false)
                                    end

                                    _unsuppressBodyLock(true)
                                    local vector3 = vector(AUTO_PATH_POINTS.R_FACE.X, humanoidRootPart.Position.Y, AUTO_PATH_POINTS.R_FACE.Z)

                                    if (vector3 - humanoidRootPart.Position).Magnitude > 0.01 then
                                        humanoidRootPart.CFrame = cframe(humanoidRootPart.Position, vector3)
                                    end

                                    return
                                end

                                local offset = AUTO_PATH_POINTS.R2 - humanoidRootPart.Position
                                local unit = vector(offset.X, 0, offset.Z).Unit
                                humanoid:Move(unit, false)
                                humanoidRootPart.AssemblyLinearVelocity = vector(unit.X * capturedNS, humanoidRootPart.AssemblyLinearVelocity.Y, unit.Z * capturedNS)
                            end
                        end)
                    end

                    getClosestTarget = function()
                        local character = localPlayer.Character
                        if not character then
                            return nil
                        end
                        local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
                        if not humanoidRootPart then
                            return nil
                        end
                        local position = humanoidRootPart.Position
                        local cachedPlayers = getCachedPlayers()
                        local closestDistance = huge
                        local value = nil

                        for index = 1, #cachedPlayers do
                            local entry = cachedPlayers[index]

                            if entry ~= localPlayer then
                                local character = entry.Character

                                if character then
                                    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")

                                    if humanoidRootPart then
                                        local humanoid = character:FindFirstChildOfClass("Humanoid")

                                        if humanoid and humanoid.Health > 0 then
                                            local offset = humanoidRootPart.Position.X - position.X
                                            local offset2 = humanoidRootPart.Position.Y - position.Y
                                            local offset3 = humanoidRootPart.Position.Z - position.Z
                                            local amount = offset * offset + offset2 * offset2 + offset3 * offset3

                                            if amount < closestDistance then
                                                closestDistance = amount
                                                value = humanoidRootPart
                                            end
                                        end
                                    end
                                end
                            end
                        end

                        return value
                    end

                    trySwing = function()
                        pcall(function()
                            local character = localPlayer.Character
                            if not character then
                                return
                            end
                            local tool = character:FindFirstChildOfClass("Tool")
                            if tool and not isBatTool(tool) then
                                return
                            end
                            local bat = findBat()

                            if bat then
                                if bat.Parent ~= character then
                                    local humanoid = character:FindFirstChildOfClass("Humanoid")

                                    if humanoid then
                                        pcall(function()
                                            humanoid:EquipTool(bat)
                                        end)
                                    end
                                end

                                pcall(function()
                                    bat:Activate()
                                end)
                            end
                        end)
                    end

                    stopAimbotAdapt = function()
                        if _aimbotConn then
                            pcall(function()
                                _aimbotConn:Disconnect()
                            end)

                            _aimbotConn = nil
                        end

                        local character = localPlayer.Character
                        local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
                        local humanoid = character and character:FindFirstChildOfClass("Humanoid")

                        if humanoid then
                            humanoid.AutoRotate = _prevAutoRotate == nil and true or _prevAutoRotate
                            humanoid.PlatformStand = false

                            pcall(function()
                                humanoid:ChangeState(Enum.HumanoidStateType.Running)
                            end)
                        end

                        if humanoidRootPart then
                            humanoidRootPart.AssemblyLinearVelocity = vector(0, -0.1, 0)
                            humanoidRootPart.AssemblyAngularVelocity = vector2
                        end

                        _prevAutoRotate = nil
                        lastMoveDir = vector2
                        _unsuppressBodyLock(true)
                    end

                    startAimbotAdapt = function()
                        if _aimbotConn then
                            return
                        end
                        _suppressBodyLock()
                        local humanoid = localPlayer.Character and localPlayer.Character:FindFirstChildOfClass("Humanoid")

                        if humanoid then
                            if _prevAutoRotate == nil then
                                _prevAutoRotate = humanoid.AutoRotate
                            end

                            humanoid.AutoRotate = false
                        end

                        _aimbotConn = RunService.RenderStepped:Connect(function()
                            if not autoBatEnabled then
                                return
                            end
                            local character = localPlayer.Character
                            if not character then
                                return
                            end
                            local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
                            local humanoid = character:FindFirstChildOfClass("Humanoid")
                            if not humanoidRootPart or not humanoid then
                                return
                            end

                            if not character:FindFirstChildOfClass("Tool") then
                                local bat = findBat()

                                if bat then
                                    pcall(function()
                                        humanoid:EquipTool(bat)
                                    end)
                                end
                            end

                            local closestTarget = getClosestTarget()
                            if not closestTarget then
                                return
                            end
                            local assemblyLinearVelocity = closestTarget.AssemblyLinearVelocity
                            local position = humanoidRootPart.Position
                            local position2 = closestTarget.Position
                            local amount = position2 + assemblyLinearVelocity * 0.14 + closestTarget.CFrame.LookVector * 0.3 - position
                            local vector3 = vector(amount.X, 0, amount.Z)
                            local unit

                            if vector3.Magnitude > 0 then
                                unit = vector3.Unit
                            else
                                unit = vector(0, 0, 0)
                            end

                            local amount = (position2.Y + 3.7 - position.Y) * 19.5 + assemblyLinearVelocity.Y * 0.8
                            local bestAmount

                            if humanoid.FloorMaterial ~= Enum.Material.Air then
                                bestAmount = math.max(amount, 13)
                            else
                                bestAmount = amount
                            end

                            humanoidRootPart.AssemblyLinearVelocity = humanoidRootPart.AssemblyLinearVelocity:Lerp(vector(unit.X * BAT_AIMBOT_SPEED, clamp(bestAmount, -70, 110), (unit.Z * BAT_AIMBOT_SPEED)), 0.8)
                            local distance = position2 + assemblyLinearVelocity * clamp(assemblyLinearVelocity.Magnitude / 150, 0.05, 0.2)

                            if (distance - position).Magnitude > 0.1 then
                                local value = cframe2(position, distance)
                                local value2, value3, value4 = (humanoidRootPart.CFrame:Inverse() * value):ToEulerAnglesXYZ()
                                humanoidRootPart.AssemblyAngularVelocity = humanoidRootPart.CFrame:VectorToWorldSpace(vector(clamp(value2, -2.5, 2.5) * 42, clamp(value3, -2.5, 2.5) * 42, clamp(value4, -2.5, 2.5) * 42))
                            end

                            if (humanoidRootPart.Position - closestTarget.Position).Magnitude <= 8 then
                                trySwing()
                            end
                        end)
                    end

                    disableAutoBat = function()
                        autoBatEnabled = false

                        if autoBatSetVisual then
                            autoBatSetVisual(false)
                        end

                        if mobSetAutoBat then
                            mobSetAutoBat(false)
                        end

                        stopAimbotAdapt()
                    end

                    enableAutoBat = function()
                        if youtBatV2PersistentState.enabled and stopYoutBatV2 then
                            stopYoutBatV2()
                        end

                        if autoLeftEnabled then
                            autoLeftEnabled = false

                            if autoLeftSetVisual then
                                autoLeftSetVisual(false)
                            end

                            stopAutoLeft()
                        end

                        if autoRightEnabled then
                            autoRightEnabled = false

                            if autoRightSetVisual then
                                autoRightSetVisual(false)
                            end

                            stopAutoRight()
                        end

                        if batDesyncTpEnabled then
                            toggleBatDesyncTp()
                        end

                        autoBatEnabled = true

                        if autoBatSetVisual then
                            autoBatSetVisual(true)
                        end

                        if mobSetAutoBat then
                            mobSetAutoBat(true)
                        end

                        startAimbotAdapt()
                    end

                    do
                        local list = {
                            "LockBAV",
                            "LockAngVel",
                            "LockBodyAtt",
                            "BatLock",
                            "LockBAVAtt",
                            "AutoBatAtt",
                            "AutoBatAV",
                            "AntiBatDet",
                            "AntiAim",
                            "VelocityLock",
                        }

                        removeLockInstances = function(instance)
                            if not instance then
                                return
                            end

                            pcall(function()
                                for _, entry in ipairs(list) do
                                    local child = instance:FindFirstChild(entry)

                                    if child then
                                        child:Destroy()
                                    end
                                end

                                for _, child in ipairs(instance:GetChildren()) do
                                    local lowerName = child.Name:lower()

                                    if child.Name ~= "_GB_AngV" and child.Name ~= "_GB_Att" then
                                        if lowerName:find("lockb", 1, true) or lowerName:find("lockangvel", 1, true) or lowerName:find("batlock", 1, true) or lowerName:find("antiaim", 1, true) or lowerName:find("velocitylock", 1, true) then
                                            child:Destroy()
                                        end
                                    end
                                end
                            end)
                        end
                    end
                end

                do
                    do
                        local function clearBatAngularVelocity()
                            pcall(function()
                                if youtBatV2PersistentState.angularVelocity and youtBatV2PersistentState.angularVelocity.Parent then
                                    youtBatV2PersistentState.angularVelocity:Destroy()
                                end
                            end)

                            pcall(function()
                                if youtBatV2PersistentState.attachment and youtBatV2PersistentState.attachment.Parent then
                                    youtBatV2PersistentState.attachment:Destroy()
                                end
                            end)

                            youtBatV2PersistentState.angularVelocity = nil
                            youtBatV2PersistentState.attachment = nil
                        end

                        local function cleanupBatLockInstances(parent)
                            if not parent then
                                return
                            end

                            pcall(function()
                                local _GB_AngV = parent:FindFirstChild("_GB_AngV")
                                local gbAtt = parent:FindFirstChild("_GB_Att")

                                if _GB_AngV then
                                    _GB_AngV:Destroy()
                                end

                                if gbAtt then
                                    gbAtt:Destroy()
                                end
                            end)

                            local instance = Instance.new("Attachment")
                            instance.Name = "_GB_Att"
                            instance.Parent = parent
                            local angularVelocity = Instance.new("AngularVelocity")
                            angularVelocity.Name = "_GB_AngV"
                            angularVelocity.Attachment0 = instance
                            angularVelocity.RelativeTo = Enum.ActuatorRelativeTo.World
                            angularVelocity.MaxTorque = math.huge
                            angularVelocity.AngularVelocity = Vector3.zero
                            angularVelocity.Parent = parent
                            youtBatV2PersistentState.attachment = instance
                            youtBatV2PersistentState.angularVelocity = angularVelocity
                        end

                        local function findNearestEnemy(part)
                            local huge2 = math.huge
                            local value = nil

                            for _, player in ipairs(Players:GetPlayers()) do
                                if player ~= localPlayer and player.Character then
                                    local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
                                    local humanoid = player.Character:FindFirstChildOfClass("Humanoid")

                                    if humanoidRootPart and humanoid and humanoid.Health > 0 then
                                        local magnitude = (humanoidRootPart.Position - part.Position).Magnitude

                                        if magnitude < huge2 then
                                            huge2 = magnitude
                                            value = humanoidRootPart
                                        end
                                    end
                                end
                            end

                            return value, huge2
                        end

                        local function findEquippedBat()
                            local character = localPlayer.Character
                            if not character then
                                return nil
                            end
                            local bat = character:FindFirstChild("Bat") or character:FindFirstChild("bat")
                            if bat and bat:IsA("Tool") then
                                return bat
                            end
                            local tool = character:FindFirstChildOfClass("Tool")

                            if tool then
                                local lowerName = tool.Name:lower()
                                if lowerName:find("bat", 1, true) or lowerName:find("slap", 1, true) then
                                    return tool
                                end
                            end

                            local backpack = localPlayer:FindFirstChildOfClass("Backpack")

                            if backpack then
                                local bat = backpack:FindFirstChild("Bat") or backpack:FindFirstChild("bat")
                                if bat and bat:IsA("Tool") then
                                    return bat
                                end

                                for _, child in ipairs(backpack:GetChildren()) do
                                    if child:IsA("Tool") then
                                        local lowerName = child.Name:lower()
                                        if lowerName:find("bat", 1, true) or lowerName:find("slap", 1, true) then
                                            return child
                                        end
                                    end
                                end
                            end

                            return nil
                        end

                        local function equipBat(instance, humanoid)
                            local bat = instance:FindFirstChild("Bat") or instance:FindFirstChild("bat")

                            if not bat then
                                bat = findEquippedBat()

                                if bat and bat.Parent ~= instance then
                                    pcall(function()
                                        humanoid:EquipTool(bat)
                                    end)
                                end
                            end

                            if bat and bat:IsA("Tool") and bat.Parent == instance then
                                pcall(function()
                                    bat:Activate()
                                    local remoteEvent = bat:FindFirstChildWhichIsA("RemoteEvent")

                                    if remoteEvent then
                                        remoteEvent:FireServer()
                                    end
                                end)
                            end
                        end

                        stopYoutBatV2 = function()
                            youtBatV2PersistentState.enabled = false
                            youtBatV2PersistentState.generation = (youtBatV2PersistentState.generation or 0) + 1
                            youtBatV2PersistentState.equipped = false
                            youtBatV2PersistentState.target = nil

                            if youtBatV2PersistentState.conn then
                                pcall(function()
                                    youtBatV2PersistentState.conn:Disconnect()
                                end)

                                youtBatV2PersistentState.conn = nil
                            end

                            if youtBatV2PersistentState.safetyConn then
                                pcall(function()
                                    youtBatV2PersistentState.safetyConn:Disconnect()
                                end)

                                youtBatV2PersistentState.safetyConn = nil
                            end

                            if youtBatV2PersistentState.respawnConn then
                                pcall(function()
                                    youtBatV2PersistentState.respawnConn:Disconnect()
                                end)

                                youtBatV2PersistentState.respawnConn = nil
                            end

                            local character = localPlayer.Character
                            local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
                            character = character and character:FindFirstChildOfClass("Humanoid")

                            if humanoidRootPart then
                                humanoidRootPart.Velocity = humanoidRootPart.Velocity * 0.3
                            end

                            if character then
                                character.AutoRotate = true
                            end

                            if youtBatV2PersistentState.angularVelocity then
                                pcall(function()
                                    youtBatV2PersistentState.angularVelocity.AngularVelocity = Vector3.zero
                                end)
                            end

                            clearBatAngularVelocity()
                            _unsuppressBodyLock(true)

                            if batV2FloatingButton then
                                local frame = batV2FloatingButton:FindFirstChild("Frame")

                                if frame then
                                    paintFloatingBtn(frame, false)
                                end
                            end
                        end

                        startYoutBatV2 = function()
                            stopYoutBatV2()

                            if autoBatEnabled then
                                autoBatEnabled = false
                                stopAimbotAdapt()

                                if autoBatSetVisual then
                                    autoBatSetVisual(false)
                                end

                                if mobSetAutoBat then
                                    mobSetAutoBat(false)
                                end
                            end

                            if autoLeftEnabled then
                                autoLeftEnabled = false
                                stopAutoLeft()

                                if autoLeftSetVisual then
                                    autoLeftSetVisual(false)
                                end

                                if mobSetAutoLeft then
                                    mobSetAutoLeft(false)
                                end
                            end

                            if autoRightEnabled then
                                autoRightEnabled = false
                                stopAutoRight()

                                if autoRightSetVisual then
                                    autoRightSetVisual(false)
                                end

                                if mobSetAutoRight then
                                    mobSetAutoRight(false)
                                end
                            end

                            if batDesyncTpEnabled then
                                stopBatDesyncTp()
                                batDesyncTpEnabled = false

                                if batDesyncTpSetVisual then
                                    batDesyncTpSetVisual(false)
                                end
                            end

                            _suppressBodyLock()
                            youtBatV2PersistentState.enabled = true
                            youtBatV2PersistentState.equipped = false
                            youtBatV2PersistentState.target = nil
                            youtBatV2PersistentState.intendedVelocity = Vector3.zero
                            youtBatV2PersistentState.generation = (youtBatV2PersistentState.generation or 0) + 1
                            local generation = youtBatV2PersistentState.generation
                            local character = localPlayer.Character
                            local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")

                            if humanoidRootPart then
                                removeLockInstances(humanoidRootPart)
                                cleanupBatLockInstances(humanoidRootPart)
                            end

                            youtBatV2PersistentState.conn = RunService.Heartbeat:Connect(function()
                                if not youtBatV2PersistentState.enabled or youtBatV2PersistentState.generation ~= generation then
                                    return
                                end
                                local character = localPlayer.Character
                                local humanoid = character and character:FindFirstChildOfClass("Humanoid")
                                local child = character and character:FindFirstChild("HumanoidRootPart")
                                if not child or not humanoid or humanoid.Health <= 0 then
                                    return
                                end
                                removeLockInstances(child)

                                if not youtBatV2PersistentState.angularVelocity or not youtBatV2PersistentState.angularVelocity.Parent then
                                    cleanupBatLockInstances(child)
                                end

                                if not youtBatV2PersistentState.equipped then
                                    youtBatV2PersistentState.equipped = true

                                    if not character:FindFirstChildOfClass("Tool") then
                                        local equippedBat = findEquippedBat()

                                        if equippedBat then
                                            pcall(function()
                                                humanoid:EquipTool(equippedBat)
                                            end)
                                        end
                                    end
                                end

                                local nearestEnemy, value = findNearestEnemy(child)

                                if not nearestEnemy then
                                    youtBatV2PersistentState.target = nil
                                    humanoid.AutoRotate = true

                                    if youtBatV2PersistentState.angularVelocity then
                                        youtBatV2PersistentState.angularVelocity.AngularVelocity = Vector3.zero
                                    end

                                    return
                                end

                                youtBatV2PersistentState.target = nearestEnemy
                                local distance = nearestEnemy.Position + nearestEnemy.CFrame.LookVector * (nearestEnemy.Velocity.Magnitude < 0.1 and 1.5 or 5)
                                local offset = distance - child.Position
                                local vector3 = Vector3.new(offset.X, 0, offset.Z)
                                humanoid.AutoRotate = false

                                if offset.Magnitude > 0.01 and vector3.Magnitude > 0.01 then
                                    local amount = (math.deg(math.atan2(-vector3.X, -vector3.Z)) - child.Orientation.Y + 180) % 360 - 180

                                    local distance2 = (math.deg(math.atan2(offset.Y, vector3.Magnitude)) - child.Orientation.X + 180) % 360 - 180

                                    local clamped = math.clamp(math.rad(amount) * 40, -28, 28)
                                    local clamped2 = math.clamp(math.rad(distance2) * 40, -28, 28)
                                    local radians = math.rad(child.Orientation.Y)

                                    youtBatV2PersistentState.angularVelocity.AngularVelocity = Vector3.new(0, clamped, 0) + Vector3.new(math.cos(radians), 0, -math.sin(radians)) * clamped2
                                else
                                    youtBatV2PersistentState.angularVelocity.AngularVelocity = Vector3.zero
                                end

                                local offset = distance - child.Position
                                local vector3 = Vector3.new(offset.X, 0, offset.Z)
                                youtBatV2PersistentState.intendedVelocity = (vector3.Magnitude > 0.1 and vector3.Unit * 58 or Vector3.zero) + (math.abs(offset.Y) > 0.8 and Vector3.new(0, math.sign(offset.Y) * 58, 0) or Vector3.new(0, -2, 0))
                                child.Velocity = youtBatV2PersistentState.intendedVelocity

                                if vector3.Magnitude > 0.5 then
                                    humanoid:Move(vector3.Unit, false)
                                end

                                if value <= 10 then
                                    equipBat(character, humanoid)
                                end
                            end)

                            youtBatV2PersistentState.safetyConn = RunService.RenderStepped:Connect(function()
                                if not youtBatV2PersistentState.enabled or youtBatV2PersistentState.generation ~= generation then
                                    return
                                end
                                local humanoidRootPart = localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")
                                if not humanoidRootPart then
                                    return
                                end
                                local velocity = humanoidRootPart.Velocity

                                if math.abs(velocity.X) > 350 or math.abs(velocity.Z) > 350 then
                                    humanoidRootPart.Velocity = youtBatV2PersistentState.intendedVelocity
                                end

                                removeLockInstances(humanoidRootPart)
                            end)

                            youtBatV2PersistentState.respawnConn = localPlayer.CharacterAdded:Connect(function(character)
                                task.wait(0.5)
                                youtBatV2PersistentState.equipped = false
                                youtBatV2PersistentState.target = nil

                                if youtBatV2PersistentState.enabled and youtBatV2PersistentState.generation == generation then
                                    local humanoidRootPart = character:WaitForChild("HumanoidRootPart", 5)

                                    if humanoidRootPart then
                                        removeLockInstances(humanoidRootPart)
                                        cleanupBatLockInstances(humanoidRootPart)
                                    end
                                end
                            end)

                            if batV2FloatingButton then
                                local frame = batV2FloatingButton:FindFirstChild("Frame")

                                if frame then
                                    paintFloatingBtn(frame, true)
                                end
                            end

                            return true
                        end
                    end
                end
            end

            refreshTpBatButton = function(enabled)
                if tpBatFloatingButton then
                    local frame = tpBatFloatingButton:FindFirstChild("Frame")

                    if frame then
                        local textLabel2 = frame:FindFirstChild("TextLabel")

                        if textLabel2 then
                            textLabel2.Text = "TP\nBAT"
                        end

                        if enabled then
                            paintFloatingBtn(frame, true)
                        else
                            paintFloatingBtn(frame, batDesyncTpEnabled)
                        end
                    end
                end
            end

            batDesyncTpEnabled = false
            connection = nil
            tpBat = nil

            do
                local list = {
                    "Bat",
                    "Slap",
                    "Iron Slap",
                    "Gold Slap",
                    "Diamond Slap",
                    "Emerald Slap",
                    "Ruby Slap",
                    "Dark Matter Slap",
                    "Flame Slap",
                    "Nuclear Slap",
                    "Galaxy Slap",
                    "Glitched Slap",
                    "Rainbow Slap",
                    "Plasmatic Slap",
                    "Blackhole Slap",
                    "Admin Slap",
                    "Ban Hammer",
                    "Taco Slap",
                    "Ghost Slap",
                    "Frost Slap",
                    "Gummy Slap",
                }

                data = { h = nil, hrp = nil, lastSwing = 0, aimTarget = nil }

                collectCharacterBaseParts = function()
                    local character = localPlayer.Character
                    if not character then
                        return nil
                    end

                    local function isBatTool(instance)
                        if not instance or not instance:IsA("Tool") then
                            return false
                        end
                        local lowerName = instance.Name:lower()
                        return lowerName:find("bat") or lowerName:find("slap") or lowerName:find("hammer")
                    end

                    for _, entry in ipairs(list) do
                        local child = character:FindFirstChild(entry)
                        if child and child:IsA("Tool") then
                            return child
                        end
                    end

                    for _, child in ipairs(character:GetChildren()) do
                        if isBatTool(child) then
                            return child
                        end
                    end

                    local backpack = localPlayer:FindFirstChildOfClass("Backpack")

                    if backpack then
                        for _, entry in ipairs(list) do
                            local child = backpack:FindFirstChild(entry)

                            if child and child:IsA("Tool") then
                                pcall(function()
                                    local humanoid = character:FindFirstChildOfClass("Humanoid")

                                    if humanoid then
                                        humanoid:EquipTool(child)
                                    else
                                        child.Parent = character
                                    end
                                end)

                                return child
                            end
                        end

                        for _, child in ipairs(backpack:GetChildren()) do
                            if isBatTool(child) then
                                pcall(function()
                                    local humanoid = character:FindFirstChildOfClass("Humanoid")

                                    if humanoid then
                                        humanoid:EquipTool(child)
                                    else
                                        child.Parent = character
                                    end
                                end)

                                return child
                            end
                        end
                    end

                    return nil
                end
            end
        end

        do
            do
                do
                    local function swingBat(player)

                        if getTime() - data.lastSwing < 0.04 then
                            return
                        end
                        data.lastSwing = getTime()

                        pcall(function()
                            local character = localPlayer.Character
                            if not character then
                                return
                            end
                            local humanoid = character:FindFirstChildOfClass("Humanoid")
                            local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
                            local characterBaseParts = collectCharacterBaseParts()
                            if not characterBaseParts or not humanoidRootPart then
                                return
                            end

                            if characterBaseParts.Parent ~= character then
                                if humanoid then
                                    pcall(function()
                                        humanoid:EquipTool(characterBaseParts)
                                    end)
                                else
                                    characterBaseParts.Parent = character
                                end
                            end

                            local character = player and player.Character
                            if not character then
                                return
                            end
                            local humanoidRootPart2 = character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("UpperTorso") or character:FindFirstChild("Torso")
                            if not humanoidRootPart2 then
                                return
                            end

                            humanoidRootPart.CFrame = cframe2(humanoidRootPart2.Position + vector(0, 1.2, 0), humanoidRootPart2.Position)
                            humanoidRootPart.AssemblyLinearVelocity = Vector3.zero
                            humanoidRootPart.AssemblyAngularVelocity = Vector3.zero
                            local handle = characterBaseParts:FindFirstChild("Handle")

                            if handle then
                                pcall(function()
                                    handle.CanTouch = true
                                    handle.CanQuery = true
                                    handle.CFrame = humanoidRootPart2.CFrame
                                end)
                            end

                            local entries = {}

                            for _, descendant in ipairs(character:GetDescendants()) do
                                if descendant:IsA("BasePart") then
                                    table.insert(entries, descendant)
                                end
                            end

                            for index = 1, 8 do
                                pcall(function()
                                    characterBaseParts:Activate()
                                end)

                                for _, child in ipairs(characterBaseParts:GetChildren()) do
                                    if child:IsA("RemoteEvent") then
                                        pcall(function()
                                            child:FireServer()
                                        end)
                                    elseif child:IsA("RemoteFunction") then
                                        pcall(function()
                                            child:InvokeServer()
                                        end)
                                    end
                                end

                                for _, descendant in ipairs(characterBaseParts:GetDescendants()) do
                                    if descendant:IsA("RemoteEvent") then
                                        pcall(function()
                                            descendant:FireServer()
                                        end)
                                    end
                                end

                                if firetouchinterest and handle then
                                    for _, entry in ipairs(entries) do
                                        pcall(function()
                                            firetouchinterest(handle, entry, 0)
                                            firetouchinterest(handle, entry, 1)
                                        end)
                                    end
                                end

                                if index == 4 then
                                    RunService.Heartbeat:Wait()
                                end
                            end
                        end)
                    end

                    local function resolveTpBatCharacter()
                        local humanoidRootPart = data.hrp

                        if not humanoidRootPart or not humanoidRootPart.Parent then
                            humanoidRootPart = localPlayer.Character
                            humanoidRootPart = humanoidRootPart and humanoidRootPart:FindFirstChild("HumanoidRootPart")

                            if humanoidRootPart then
                                data.hrp = humanoidRootPart
                            end
                        end

                        if not humanoidRootPart then
                            return nil
                        end
                        local closestDistance = huge
                        local value = nil

                        for _, player in ipairs(Players:GetPlayers()) do
                            if player ~= localPlayer and player.Character then
                                local humanoidRootPart2 = player.Character:FindFirstChild("HumanoidRootPart")
                                local humanoid = player.Character:FindFirstChildOfClass("Humanoid")

                                if humanoidRootPart2 and humanoid and humanoid.Health > 0 then
                                    local magnitude = (humanoidRootPart.Position - humanoidRootPart2.Position).Magnitude

                                    if magnitude < closestDistance then
                                        closestDistance = magnitude
                                        value = player
                                    end
                                end
                            end
                        end

                        return value, closestDistance
                    end

                    local function updateBatDesyncTp()
                        if not batDesyncTpEnabled then
                            return
                        end
                        local humanoidRootPart = data.hrp
                        local humanoid = data.h

                        if not humanoidRootPart or not humanoidRootPart.Parent then
                            local character = localPlayer.Character
                            if not character then
                                return
                            end
                            humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
                            humanoid = character:FindFirstChildOfClass("Humanoid")
                            data.hrp = humanoidRootPart
                            data.h = humanoid
                            if not humanoidRootPart or not humanoid then
                                return
                            end
                        end

                        humanoid.PlatformStand = false
                        humanoid.Sit = false

                        if sethiddenproperty then
                            pcall(sethiddenproperty, humanoidRootPart, "PhysicsRepRootPart", nil)
                        end

                        local state = humanoid:GetState()

                        if state == Enum.HumanoidStateType.Physics or state == Enum.HumanoidStateType.Ragdoll or state == Enum.HumanoidStateType.FallingDown then
                            pcall(function()
                                humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
                                humanoid:ChangeState(Enum.HumanoidStateType.Running)
                            end)
                        end

                        if humanoidRootPart.AssemblyLinearVelocity.Magnitude > 85 then
                            humanoidRootPart.AssemblyLinearVelocity = Vector3.zero
                            humanoidRootPart.AssemblyAngularVelocity = Vector3.zero
                        end

                        local tpBatCharacter = resolveTpBatCharacter()
                        data.aimTarget = tpBatCharacter
                        if not tpBatCharacter or not tpBatCharacter.Character then
                            return
                        end
                        local humanoidRootPart2 = tpBatCharacter.Character:FindFirstChild("HumanoidRootPart")
                        if not humanoidRootPart2 then
                            return
                        end
                        local humanoid = tpBatCharacter.Character:FindFirstChildOfClass("Humanoid")
                        if humanoid and humanoid.Health <= 0 then
                            return
                        end

                        humanoidRootPart.CFrame = cframe2(humanoidRootPart2.Position + vector(0, 1.2, 0), humanoidRootPart2.Position)
                        humanoidRootPart.AssemblyLinearVelocity = Vector3.zero
                        humanoidRootPart.AssemblyAngularVelocity = Vector3.zero
                        local currentCamera = workspace.CurrentCamera

                        if currentCamera then
                            currentCamera.CFrame = cframe(currentCamera.CFrame.Position, humanoidRootPart2.Position)
                        end

                        swingBat(tpBatCharacter)
                    end

                    startBatDesyncTp = function()
                        if connection then
                            connection:Disconnect()
                            connection = nil
                        end

                        batDesyncTpEnabled = true
                        data.lastSwing = 0
                        local character = localPlayer.Character

                        if character then
                            data.h = character:FindFirstChildOfClass("Humanoid")
                            data.hrp = character:FindFirstChild("HumanoidRootPart")

                            pcall(function()
                                local characterBaseParts = collectCharacterBaseParts()
                                local humanoid = character:FindFirstChildOfClass("Humanoid")

                                if characterBaseParts and humanoid and characterBaseParts.Parent ~= character then
                                    humanoid:EquipTool(characterBaseParts)
                                end
                            end)
                        end

                        connection = RunService.Heartbeat:Connect(updateBatDesyncTp)

                        if tpBat then
                            tpBat(true)
                        end

                        refreshTpBatButton(true)
                    end
                end
            end

            stopBatDesyncTp = function()
                batDesyncTpEnabled = false

                if connection then
                    connection:Disconnect()
                    connection = nil
                end

                local humanoidRootPart = data.hrp

                if humanoidRootPart and sethiddenproperty then
                    pcall(sethiddenproperty, humanoidRootPart, "PhysicsRepRootPart", nil)
                end

                data.aimTarget = nil

                if tpBat then
                    tpBat(false)
                end

                refreshTpBatButton(false)
            end

            toggleBatDesyncTp = function()
                if batDesyncTpEnabled then
                    stopBatDesyncTp()
                else
                    disableAllAimbots()

                    if autoLeftEnabled then
                        autoLeftEnabled = false
                        stopAutoLeft()

                        if autoLeftSetVisual then
                            autoLeftSetVisual(false)
                        end

                        if mobSetAutoLeft then
                            mobSetAutoLeft(false)
                        end
                    end

                    if autoRightEnabled then
                        autoRightEnabled = false
                        stopAutoRight()

                        if autoRightSetVisual then
                            autoRightSetVisual(false)
                        end

                        if mobSetAutoRight then
                            mobSetAutoRight(false)
                        end
                    end

                    startBatDesyncTp()
                end

                if tpBat then
                    tpBat(batDesyncTpEnabled)
                end

                saveAllSettings()
            end

            findBat = function()
                local character = localPlayer.Character
                if not character then
                    return nil
                end

                for _, entry in ipairs(BAT_COUNTER_SLAP_LIST) do
                    local child = character:FindFirstChild(entry)
                    if child and child:IsA("Tool") then
                        return child
                    end
                end

                local backpack = localPlayer:FindFirstChildOfClass("Backpack")

                if backpack then
                    for _, entry in ipairs(BAT_COUNTER_SLAP_LIST) do
                        local child = backpack:FindFirstChild(entry)

                        if child and child:IsA("Tool") then
                            local humanoid = character:FindFirstChildOfClass("Humanoid")

                            if humanoid then
                                pcall(function()
                                    humanoid:EquipTool(child)
                                end)
                            end

                            return child
                        end
                    end
                end

                for _, child in ipairs(character:GetChildren()) do
                    if child:IsA("Tool") and (child.Name:lower():find("bat") or child.Name:lower():find("slap")) then
                        return child
                    end
                end

                return nil
            end

            isBatTool = function(instance)
                if not instance then
                    return false
                end

                for _, entry in ipairs(BAT_COUNTER_SLAP_LIST) do
                    if instance.Name == entry then
                        return true
                    end
                end

                return instance.Name:lower():find("bat") or instance.Name:lower():find("slap")
            end

            findBatForCounter = function()
                local character = localPlayer.Character
                if not character then
                    return nil
                end
                local backpack = localPlayer:FindFirstChildOfClass("Backpack")

                for _, entry in ipairs(BAT_COUNTER_SLAP_LIST) do
                    local child = character:FindFirstChild(entry) or backpack and backpack:FindFirstChild(entry)
                    if child then
                        return child
                    end
                end

                for _, child in ipairs(character:GetChildren()) do
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

            swingBatForCounter = function(instance, instance2)
                local humanoid = instance2:FindFirstChildOfClass("Humanoid")

                if instance.Parent ~= instance2 and humanoid then
                    pcall(function()
                        humanoid:EquipTool(instance)
                    end)

                    task.wait(0.05)
                end

                local remoteEvent = instance:FindFirstChildOfClass("RemoteEvent") or instance:FindFirstChildOfClass("RemoteFunction")

                if remoteEvent and remoteEvent:IsA("RemoteEvent") then
                    pcall(function()
                        remoteEvent:FireServer()
                    end)

                    task.wait(0.1)

                    pcall(function()
                        remoteEvent:FireServer()
                    end)
                else
                    pcall(function()
                        instance:Activate()
                    end)

                    task.wait(0.1)

                    pcall(function()
                        instance:Activate()
                    end)
                end
            end

            batCounterDebounce = false

            stopBatCounter = function()
                if CONNECTIONS.batCounter then
                    CONNECTIONS.batCounter:Disconnect()
                    CONNECTIONS.batCounter = nil
                end

                batCounterDebounce = false
            end

            startBatCounter = function()
                if CONNECTIONS.batCounter then
                    return
                end

                CONNECTIONS.batCounter = RunService.Heartbeat:Connect(function()
                    if not batCounterEnabled then
                        return
                    end

                    if batCounterDebounce then
                        return
                    end
                    local character = localPlayer.Character
                    if not character then
                        return
                    end
                    local humanoid = character:FindFirstChildOfClass("Humanoid")

                    if humanoid then
                        local state = humanoid:GetState()

                        if state == Enum.HumanoidStateType.Physics or state == Enum.HumanoidStateType.Ragdoll or state == Enum.HumanoidStateType.FallingDown then
                            batCounterDebounce = true
                            _suppressBodyLock()

                            task.spawn(function()
                                task.wait(0.15)
                                local batForCounter = findBatForCounter()

                                if batForCounter then
                                    swingBatForCounter(batForCounter, character)
                                end

                                task.wait(0.3)
                                batCounterDebounce = false
                                _unsuppressBodyLock(true)
                            end)
                        end

                        return
                    end
                end)
            end

            findMedusa = function()
                local character = localPlayer.Character
                if not character then
                    return nil
                end

                for _, child in ipairs(character:GetChildren()) do
                    if child:IsA("Tool") then
                        local lowerName = child.Name:lower()
                        if lowerName:find("medusa") or lowerName:find("head") or lowerName:find("stone") then
                            return child
                        end
                    end
                end

                local backpack = localPlayer:FindFirstChild("Backpack")

                if backpack then
                    for _, child in ipairs(backpack:GetChildren()) do
                        if child:IsA("Tool") then
                            local lowerName = child.Name:lower()
                            if lowerName:find("medusa") or lowerName:find("head") or lowerName:find("stone") then
                                return child
                            end
                        end
                    end
                end

                return nil
            end

            useMedusaCounter = function()
                if medusaDebounce then
                    return
                end

                if getTime() - medusaLastUsed < MEDUSA_COOLDOWN then
                    return
                end
                local character = localPlayer.Character
                if not character then
                    return
                end
                medusaDebounce = true
                local medusa = findMedusa()
                if not medusa then
                    medusaDebounce = false
                    return
                end

                if medusa.Parent ~= character then
                    local humanoid = character:FindFirstChildOfClass("Humanoid")

                    if humanoid then
                        humanoid:EquipTool(medusa)
                    end
                end

                pcall(function()
                    medusa:Activate()
                end)

                medusaLastUsed = getTime()
                medusaDebounce = false
            end

            onAnchorChanged = function(part)
                return part:GetPropertyChangedSignal("Anchored"):Connect(function()
                    if medusaCounterEnabled and part.Anchored and part.Transparency == 1 then
                        useMedusaCounter()
                    end
                end)
            end

            setupMedusaCounter = function(instance)
                for _, value in pairs(CONNECTIONS.anchor) do
                    pcall(function()
                        value:Disconnect()
                    end)
                end

                CONNECTIONS.anchor = {}
                if not instance or not medusaCounterEnabled then
                    return
                end

                for _, descendant in ipairs(instance:GetDescendants()) do
                    if descendant:IsA("BasePart") then
                        table.insert(CONNECTIONS.anchor, onAnchorChanged(descendant))
                    end
                end

                table.insert(CONNECTIONS.anchor, instance.DescendantAdded:Connect(function(descendant)
                    if descendant:IsA("BasePart") then
                        table.insert(CONNECTIONS.anchor, onAnchorChanged(descendant))
                    end
                end))
            end

            stopMedusaCounter = function()
                for _, value in pairs(CONNECTIONS.anchor) do
                    pcall(function()
                        value:Disconnect()
                    end)
                end

                CONNECTIONS.anchor = {}
            end

            do
                local connection2 = nil

                stopDropBrainrot = function()
                    dropActive = false

                    if connection2 then
                        connection2:Disconnect()
                        connection2 = nil
                    end

                    for _, dropConnection in ipairs(dropConnections) do
                        if type(dropConnection) == "thread" then
                            pcall(task.cancel, dropConnection)
                        elseif type(dropConnection) == "RBXScriptConnection" then
                            pcall(dropConnection.Disconnect, dropConnection)
                        end
                    end

                    dropConnections = {}
                    local character = localPlayer.Character

                    if character then
                        local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")

                        if humanoidRootPart then
                            humanoidRootPart.AssemblyLinearVelocity = vector2
                        end
                    end

                    if dropBrainrotSetVisual then
                        dropBrainrotSetVisual(false)
                    end

                    if mobSetDropBR then
                        mobSetDropBR(false)
                    end
                end

                runDropBrainrot = function()
                    if dropActive then
                        return
                    end
                    local character = localPlayer.Character
                    local child = character and character:FindFirstChild("HumanoidRootPart")
                    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
                    if not child or not humanoid then
                        return
                    end

                    if dropMode == 1 then
                        local counter = 0

                        if child then
                            local assemblyLinearVelocity = child.AssemblyLinearVelocity
                            counter = vector(assemblyLinearVelocity.X, 0, assemblyLinearVelocity.Z).Magnitude
                        end

                        if getTime() - lastDropTime < (counter > 5 and 0.6 or 0.25) then
                            return
                        end
                        lastDropTime = getTime()
                        dropActive = true

                        if dropBrainrotSetVisual then
                            dropBrainrotSetVisual(true)
                        end

                        if mobSetDropBR then
                            mobSetDropBR(true)
                        end

                        local isActive = false

                        if autoBatEnabled then
                            isActive = true
                            disableAutoBat()

                            if autoBatSetVisual then
                                autoBatSetVisual(false)
                            end

                            if mobSetAutoBat then
                                mobSetAutoBat(false)
                            end
                        end

                        local function removeDropConnection(enabled)
                            if enabled and dropConnections then
                                for index = #dropConnections, 1, -1 do
                                    if dropConnections[index] == enabled then
                                        table.remove(dropConnections, index)
                                        break
                                    end
                                end
                            end

                            dropActive = false
                            local character2 = localPlayer.Character

                            if character2 then
                                local humanoidRootPart = character2:FindFirstChild("HumanoidRootPart")
                                local humanoid = character2:FindFirstChildOfClass("Humanoid")

                                if humanoidRootPart then
                                    humanoidRootPart.AssemblyLinearVelocity = vector2
                                    humanoidRootPart.AssemblyAngularVelocity = vector2

                                    if humanoidRootPart.Position.Y < -100 then
                                        humanoidRootPart.CFrame = cframe(humanoidRootPart.Position.X, 5, humanoidRootPart.Position.Z)
                                    end

                                    local raycastParams2 = RaycastParams.new()
                                    raycastParams2.FilterDescendantsInstances = { character2 }
                                    raycastParams2.FilterType = Enum.RaycastFilterType.Exclude
                                    local hit = workspace:Raycast(humanoidRootPart.Position, vector(0, -500, 0), raycastParams2)

                                    if hit then
                                        humanoidRootPart.CFrame = cframe(humanoidRootPart.Position.X, hit.Position.Y + (humanoid and humanoid.HipHeight or 2) + humanoidRootPart.Size.Y / 2, humanoidRootPart.Position.Z)
                                    end

                                    if humanoid and humanoid.Health > 0 then
                                        humanoid:ChangeState(Enum.HumanoidStateType.Running)
                                    end
                                end
                            end

                            if isActive then
                                enableAutoBat()

                                if autoBatSetVisual then
                                    autoBatSetVisual(true)
                                end

                                if mobSetAutoBat then
                                    mobSetAutoBat(true)
                                end
                            end

                            if dropBrainrotSetVisual then
                                dropBrainrotSetVisual(false)
                            end

                            if mobSetDropBR then
                                mobSetDropBR(false)
                            end
                        end

                        local thread = nil

                        thread = task.spawn(function()
                            local time = getTime()

                            while true do
                                local capturedDropActive = dropActive

                                if capturedDropActive then
                                    capturedDropActive = getTime() - time < 0.25
                                end

                                if capturedDropActive then
                                    RunService.Heartbeat:Wait()
                                    local character2 = localPlayer.Character
                                    character2 = character2 and character2:FindFirstChild("HumanoidRootPart")

                                    if character2 then
                                        local vector3 = vector(0, character2.AssemblyLinearVelocity.Y, 0)
                                        character2.AssemblyLinearVelocity = vector3 * 10000 + vector(0, 10000, 0)
                                        RunService.RenderStepped:Wait()

                                        if character2 and character2.Parent then
                                            character2.AssemblyLinearVelocity = vector3
                                        end

                                        RunService.Stepped:Wait()

                                        if character2 and character2.Parent then
                                            character2.AssemblyLinearVelocity = vector3 + vector(0, 0.1, 0)
                                        end

                                        continue
                                    end
                                end

                                break
                            end

                            removeDropConnection(thread)
                        end)

                        table.insert(dropConnections, thread)

                        task.delay(0.35, function()
                            if dropActive then
                                removeDropConnection(thread)
                            end
                        end)

                        return
                    end

                    if autoBatEnabled then
                        autoBatEnabled = false

                        if autoBatSetVisual then
                            autoBatSetVisual(false)
                        end

                        if mobSetAutoBat then
                            mobSetAutoBat(false)
                        end

                        if stopAimbotAdapt then
                            stopAimbotAdapt()
                        end
                    end

                    dropActive = true

                    if dropBrainrotSetVisual then
                        dropBrainrotSetVisual(true)
                    end

                    if mobSetDropBR then
                        mobSetDropBR(false)
                    end

                    local time = getTime()

                    if connection2 then
                        connection2:Disconnect()
                    end

                    connection2 = RunService.Heartbeat:Connect(function()
                        local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")

                        if not humanoidRootPart then
                            if connection2 then
                                connection2:Disconnect()
                                connection2 = nil
                            end

                            dropActive = false

                            if dropBrainrotSetVisual then
                                dropBrainrotSetVisual(false)
                            end

                            if mobSetDropBR then
                                mobSetDropBR(false)
                            end

                            return
                        end

                        if getTime() - time >= 0.2 then
                            if connection2 then
                                connection2:Disconnect()
                                connection2 = nil
                            end

                            local raycastParams2 = raycastParams()
                            raycastParams2.FilterDescendantsInstances = { character }
                            raycastParams2.FilterType = Enum.RaycastFilterType.Exclude
                            local hit = workspace:Raycast(humanoidRootPart.Position, vector(0, -2000, 0), raycastParams2)

                            if hit then
                                local humanoid = character:FindFirstChildOfClass("Humanoid")
                                humanoidRootPart.CFrame = cframe(humanoidRootPart.Position.X, hit.Position.Y + (humanoid and humanoid.HipHeight or 2) + humanoidRootPart.Size.Y / 2, humanoidRootPart.Position.Z)
                                humanoidRootPart.AssemblyLinearVelocity = vector2
                            end

                            dropActive = false

                            if dropBrainrotSetVisual then
                                dropBrainrotSetVisual(false)
                            end

                            if mobSetDropBR then
                                mobSetDropBR(false)
                            end

                            return
                        end

                        humanoidRootPart.Velocity = vector(humanoidRootPart.Velocity.X, 150, humanoidRootPart.Velocity.Z)
                    end)
                end
            end
        end
    end

    local instance, entries, instance2, instance3, counter, value, entries2, data, isActive, applyFastFlags

    do
        executeDropWithToggle = function(callback)
            if dropActive then
                return
            end

            task.spawn(function()
                if callback then
                    callback(true)
                end

                runDropBrainrot()

                while dropActive do
                    task.wait()
                end

                task.wait(0.1)

                if callback then
                    callback(false)
                end
            end)
        end

        instance = setmetatable({}, { __mode = "k" })
        entries = {}
        instance2 = setmetatable({}, { __mode = "k" })
        instance3 = setmetatable({}, { __mode = "k" })
        counter = 0
        value = nil
        entries2 = {}
        data = nil
        isActive = false

        do
            local data2 = {
                { "DFIntClusterSenderMaxJoinBandwidthBps", "2100000000" },
                { "DFIntClusterSenderMaxUpdateBandwidthBps", "2100000000" },
                { "DFIntServerFramesBetweenJoins", "1" },
                {
                    "DFIntRaknetBandwidthInfluxHundredthsPercentageV2",
                    "10000",
                },
                { "DFIntConnectionMTUSize", "1400" },
                { "FIntRakNetResendBufferArrayLength", "1024" },
                { "DFIntRakNetNakResendDelayMsMax", "1" },
                { "DFIntWaitOnUpdateNetworkLoopEndedMS", "100" },
                { "DFIntWaitOnRecvFromLoopEndedMS", "100" },
                { "DFIntLargePacketQueueSizeCutoffMB", "1000" },
                { "DFIntSendRakNetStatsInterval", "2147483647" },
                { "DFIntRakNetLoopMs", "1" },
                { "DFIntRakNetSelectTimeoutMs", "1" },
                { "DFIntNetworkClusterPacketCacheNumParallelTasks", "8" },
                { "DFIntReplicationDataCacheNumParallelTasks", "8" },
                { "DFIntMegaReplicatorNumParallelTasks", "16" },
                { "DFIntMaxProcessPacketsStepsPerCyclic", "512" },
                { "DFIntMaxProcessPacketsStepsAccumulated", "0" },
                { "DFIntMaxProcessPacketsJobScaling", "1000" },
                { "DFIntClientPacketMaxFrameMicroseconds", "200000" },
                { "DFIntClientPacketExcessMicroseconds", "10000" },
                { "DFIntClientPacketMinMicroseconds", "1" },
                { "DFIntClientPacketMaxDelayMs", "1" },
                { "DFIntMaxWaitTimeBeforeForcePacketProcessMS", "1" },
                { "DFIntMaxFrameBufferSize", "4" },
                { "DFIntBufferCompressionThreshold", "100" },
                { "DFIntOverrideISRReplicatorStepBandwidthBytes", "131072" },
                { "DFIntTaskSchedulerJobInitThreads", "8" },
                { "DFIntTaskSchedulerJobInGameThreads", "8" },
                { "FIntTaskSchedulerAutoThreadLimit", "16" },
                { "FIntTaskSchedulerAsyncTasksMinimumThreadCount", "4" },
                { "DFIntRuntimeConcurrency", "16" },
                { "FIntSimWorldTaskQueueParallelTasks", "20" },
                { "DFIntHttpBatchLimit", "256" },
                { "FIntHttpBatchLimit", "256" },
                { "DFIntHttpCurlConnectionCacheSize", "512" },
                { "FIntDefaultMeshCacheSizeMB", "512" },
                { "DFIntMemCacheMaxCapacityMB", "256" },
                { "DFIntNumAssetsMaxToPreload", "1" },
                { "DFFlagEnableSoundPreloading", "false" },
                { "FFlagSlimContentProvider", "true" },
                { "DFFlagDebugSkipMeshVoxelizer", "true" },
                { "DFFlagTextureQualityOverrideEnabled", "true" },
                { "DFIntTextureQualityOverride", "0" },
                { "FIntDebugTextureManagerSkipMips", "7" },
                { "DFIntDebugLimitMinTextureResolutionWhenSkipMips", "8" },
                { "FFlagTM2SkipMipsForUnstreamable2", "true" },
                { "DFFlagDoNotSkipMipsBasedOnSystemMemoryPS", "true" },
                { "FFlagRenderUseTextureManager224", "false" },
                { "DFIntDebugFRMQualityLevelOverride", "1" },
                { "DFFlagDebugPauseVoxelizer", "true" },
                { "FFlagFastGPULightCulling3", "true" },
                { "FIntRenderLocalLightFadeInMs", "0" },
                { "FIntRenderLocalLightUpdatesMax", "1" },
                { "FIntRenderShadowmapBias", "0" },
                { "FIntSSAOMipLevels", "0" },
                { "FIntDebugForceMSAASamples", "1" },
                { "FIntDebugFRMOptionalMSAALevelOverride", "0" },
                { "FIntRobloxGuiBlurIntensity", "0" },
                { "FIntFRMMinGrassDistance", "0" },
                { "FIntFRMMaxGrassDistance", "0" },
                { "DFFlagCoreScriptTelemetry2", "false" },
                { "DFFlagBrowserTrackerIdTelemetryEnabled", "false" },
                { "FFlagPerfDataOnTelemetryV2", "false" },
                { "FFlagSendRenderFidelityTelemetry2", "false" },
                { "FFlagEnableTelemetryServiceMemoryCPUInfo", "false" },
                { "DFIntTelemetryProfilerHundredthsPercentage", "0" },
                { "FIntTelemetryProfilerFrequency", "0" },
                { "FIntPerformanceTelemetryQueueProcessLimit", "0" },
                {
                    "DFIntContentProviderPreloadHangTelemetryHundredthsPercentage",
                    "0",
                },
            }

            applyFastFlags = function()
                local genv = getgenv and getgenv() or _G
                local value2 = rawget(genv, "setfflag") or rawget(_G, "set_fflag")
                local value3 = rawget(genv, "getfflag") or rawget(_G, "get_fflag")
                if type(value2) ~= "function" then
                    return
                end

                for _, entry in ipairs(data2) do
                    local success = true

                    if type(value3) == "function" then
                        local result
                        success, result = pcall(value3, entry[1])
                        success = success and result ~= nil
                    end

                    if success then
                        pcall(value2, entry[1], tostring(entry[2]))
                    end
                end
            end
        end
    end

    do
        local function captureLightingState()
            if data then
                return
            end

            data = {
                Brightness = Lighting.Brightness,
                ClockTime = Lighting.ClockTime,
                OutdoorAmbient = Lighting.OutdoorAmbient,
                Ambient = Lighting.Ambient,
                GlobalShadows = Lighting.GlobalShadows,
                EnvironmentDiffuseScale = Lighting.EnvironmentDiffuseScale,
                EnvironmentSpecularScale = Lighting.EnvironmentSpecularScale,
                FogStart = Lighting.FogStart,
                FogEnd = Lighting.FogEnd,
            }
        end

        local function applyPerformanceSettings()
            pcall(function()
                settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
            end)

            pcall(function()
                UserSettings():GetService("UserGameSettings").SavedQualityLevel = Enum.SavedQualitySetting.QualityLevel1
            end)

            pcall(function()
                Lighting.GlobalShadows = false
                Lighting.EnvironmentDiffuseScale = 0
                Lighting.EnvironmentSpecularScale = 0
                Lighting.FogStart = 0
                Lighting.FogEnd = 1e10
            end)

            pcall(function()
                local atmosphere = Lighting:FindFirstChildOfClass("Atmosphere")

                if atmosphere then
                    atmosphere.Density = 0
                    atmosphere.Glare = 0
                    atmosphere.Haze = 0
                end
            end)

            pcall(function()
                local terrain = workspace:FindFirstChildOfClass("Terrain")

                if terrain then
                    terrain.Decoration = false
                    terrain.WaterWaveSize = 0
                    terrain.WaterWaveSpeed = 0
                    terrain.WaterReflectance = 0
                    local clouds = terrain:FindFirstChildOfClass("Clouds")

                    if clouds then
                        clouds.Enabled = false
                    end
                end
            end)
        end

        local function setPropertyTracked(index, index2, value2)
            pcall(function()
                local entry = index[index2]
                if entry == value2 then
                    return
                end
                index[index2] = value2
                local entry2 = instance[index]

                if not entry2 then
                    entry2 = {}
                    instance[index] = entry2
                end

                if not entry2[index2] then
                    entry2[index2] = { value = entry }
                end
            end)
        end

        local function isLocalCharacterInstance(instance4)
            local character = localPlayer.Character

            if character then
                character = instance4 == character or instance4:IsDescendantOf(character)
            end

            if character then
                return true
            end

            while instance4 and instance4 ~= workspace do
                if instance4:IsA("LayerCollector") or instance4:IsA("GuiObject") or instance4:IsA("GuiBase2d") then
                    return true
                end
                local name = instance4.Name or ""
                if name:match("^Crystal") or name:match("^Eclipse") or name:match("^ESP_") or name:match("^BloodHounds") or name:match("^Yout") then
                    return true
                end
                instance4 = instance4.Parent
            end

            return false
        end

        applyAntiLagDerender = function(instance4)
            pcall(function()
                if not isActive then
                    return
                end

                if isLocalCharacterInstance(instance4) then
                    return
                end

                if instance4:IsA("Terrain") then
                    setPropertyTracked(instance4, "Decoration", false)
                    setPropertyTracked(instance4, "WaterWaveSize", 0)
                    setPropertyTracked(instance4, "WaterWaveSpeed", 0)
                    setPropertyTracked(instance4, "WaterReflectance", 0)
                    setPropertyTracked(instance4, "WaterTransparency", 1)
                end

                if instance4:IsA("BasePart") then
                    setPropertyTracked(instance4, "Material", Enum.Material.Plastic)
                    setPropertyTracked(instance4, "MaterialVariant", "")
                    setPropertyTracked(instance4, "Reflectance", 0)
                    setPropertyTracked(instance4, "CastShadow", false)

                    if instance4:IsA("MeshPart") then
                        setPropertyTracked(instance4, "TextureID", "")
                        setPropertyTracked(instance4, "RenderFidelity", Enum.RenderFidelity.Performance)
                        setPropertyTracked(instance4, "DoubleSided", false)
                    elseif instance4:IsA("PartOperation") then
                        setPropertyTracked(instance4, "RenderFidelity", Enum.RenderFidelity.Performance)
                    end
                elseif instance4:IsA("SpecialMesh") then
                    setPropertyTracked(instance4, "TextureId", "")
                elseif instance4:IsA("SurfaceAppearance") then
                    entries[instance4] = true
                    setPropertyTracked(instance4, "Parent", nil)
                elseif instance4:IsA("Decal") or instance4:IsA("Texture") then
                    setPropertyTracked(instance4, "Transparency", 1)
                    setPropertyTracked(instance4, "Texture", "")
                elseif instance4:IsA("ParticleEmitter") then
                    setPropertyTracked(instance4, "Enabled", false)
                    setPropertyTracked(instance4, "Rate", 0)

                    pcall(function()
                        instance4:Clear()
                    end)
                elseif instance4:IsA("Trail") then
                    setPropertyTracked(instance4, "Enabled", false)

                    pcall(function()
                        instance4:Clear()
                    end)
                elseif instance4:IsA("Beam") or instance4:IsA("Fire") or instance4:IsA("Smoke") or instance4:IsA("Sparkles") or instance4:IsA("Light") or instance4:IsA("PostEffect") or instance4:IsA("Clouds") then
                    setPropertyTracked(instance4, "Enabled", false)
                elseif instance4:IsA("Atmosphere") then
                    setPropertyTracked(instance4, "Density", 0)
                    setPropertyTracked(instance4, "Haze", 0)
                    setPropertyTracked(instance4, "Glare", 0)
                elseif instance4:IsA("Sky") then
                    for _, value2 in ipairs({
                        "SkyboxBk",
                        "SkyboxDn",
                        "SkyboxFt",
                        "SkyboxLf",
                        "SkyboxRt",
                        "SkyboxUp",
                        "SunTextureId",
                        "MoonTextureId",
                    }) do
                        setPropertyTracked(instance4, value2, "")
                    end

                    setPropertyTracked(instance4, "StarCount", 0)
                    setPropertyTracked(instance4, "CelestialBodiesShown", false)
                elseif instance4:IsA("Shirt") then
                    setPropertyTracked(instance4, "ShirtTemplate", "")
                elseif instance4:IsA("Pants") then
                    setPropertyTracked(instance4, "PantsTemplate", "")
                elseif instance4:IsA("ShirtGraphic") then
                    setPropertyTracked(instance4, "Graphic", "")
                elseif instance4:IsA("Animator") then
                    if not instance2[instance4] then
                        local character = localPlayer.Character

                        if not (character and instance4:IsDescendantOf(character)) then
                            instance2[instance4] = true
                            local capturedN33 = counter

                            local success, result = pcall(function()
                                return instance4.AnimationPlayed:Connect(function(value2)
                                    if not isActive or counter ~= capturedN33 then
                                        return
                                    end

                                    task.defer(function()
                                        if isActive and counter == capturedN33 then
                                            pcall(function()
                                                value2:Stop(0)
                                            end)
                                        end
                                    end)
                                end)
                            end)

                            if success then
                                table.insert(entries2, result)
                            end

                            pcall(function()
                                for _, track in ipairs(instance4:GetPlayingAnimationTracks()) do
                                    if track.IsPlaying then
                                        instance3[track] = { animator = instance4, time = track.TimePosition, speed = track.Speed }
                                        track:Stop(0)
                                    end
                                end
                            end)
                        end
                    end
                end
            end)
        end

        enableAntiLag = function()
            if isActive then
                return
            end
            isActive = true
            antiLagEnabled = true
            counter += 1
            local capturedN33 = counter
            captureLightingState()
            applyFastFlags()
            applyPerformanceSettings()

            for _, value2 in ipairs({ 2, 6, 12, 20 }) do
                task.delay(value2, function()
                    if isActive and counter == capturedN33 then
                        applyFastFlags()
                    end
                end)
            end

            pcall(function()
                game:GetService("ReplicatedFirst"):RemoveDefaultLoadingScreen()
            end)

            table.insert(entries2, workspace.DescendantAdded:Connect(function(descendant)
                task.defer(function()
                    if isActive and counter == capturedN33 then
                        pcall(applyAntiLagDerender, descendant)
                    end
                end)
            end))

            table.insert(entries2, Lighting.DescendantAdded:Connect(function(descendant)
                task.defer(function()
                    if isActive and counter == capturedN33 then
                        pcall(applyAntiLagDerender, descendant)
                    end
                end)
            end))

            local function loadAssetsAsync(items, callback, callback2)
                task.spawn(function()
                    local entries3 = {}

                    for _, item in ipairs(items) do
                        if item then
                            local success, result = pcall(function()
                                return item:GetChildren()
                            end)

                            if success then
                                for _, entry in ipairs(result) do
                                    table.insert(entries3, entry)
                                end
                            end
                        end
                    end

                    while #entries3 > 0 and isActive and counter == capturedN33 and callback2() do
                        local amount = os.clock() + 0.0008

                        while #entries3 > 0 and os.clock() < amount do
                            local removed = table.remove(entries3)
                            pcall(callback, removed)

                            local success, result = pcall(function()
                                return removed:GetChildren()
                            end)

                            if success then
                                for _, entry in ipairs(result) do
                                    table.insert(entries3, entry)
                                end
                            end
                        end

                        RunService.Heartbeat:Wait()
                    end
                end)
            end

            loadAssetsAsync({ workspace, Lighting }, applyAntiLagDerender, function()
                return isActive and counter == capturedN33
            end)
        end
    end

    disableAntiLag = function()
        if not isActive then
            antiLagEnabled = false
            return
        end
        isActive = false
        antiLagEnabled = false
        counter += 1

        if value then
            pcall(value)
            value = nil
        end

        for _, entry in ipairs(entries2) do
            pcall(function()
                entry:Disconnect()
            end)
        end

        entries2 = {}

        for entry, entry2 in pairs(instance) do
            for k, entry3 in pairs(entry2) do
                pcall(function()
                    entry[k] = entry3.value
                end)
            end
        end

        instance = setmetatable({}, { __mode = "k" })
        entries = {}
        instance2 = setmetatable({}, { __mode = "k" })

        for entry, entry2 in pairs(instance3) do
            pcall(function()
                if entry2.animator.Parent and not entry.IsPlaying then
                    entry:Play(0, 1, entry2.speed)
                    entry.TimePosition = entry2.time
                end
            end)
        end

        instance3 = setmetatable({}, { __mode = "k" })

        if data then
            pcall(function()
                Lighting.Brightness = data.Brightness
                Lighting.ClockTime = data.ClockTime
                Lighting.OutdoorAmbient = data.OutdoorAmbient
                Lighting.Ambient = data.Ambient
                Lighting.GlobalShadows = data.GlobalShadows
                Lighting.EnvironmentDiffuseScale = data.EnvironmentDiffuseScale
                Lighting.EnvironmentSpecularScale = data.EnvironmentSpecularScale
                Lighting.FogStart = data.FogStart
                Lighting.FogEnd = data.FogEnd
            end)
        end
    end
end

do
    local createFollowController

    do
        local isHumanoidIncapacitated2, getTargetSpeed

        do
            do
                do
                    applyStretchFOV = function(fieldOfView)
                        local currentCamera = workspace.CurrentCamera

                        if currentCamera then
                            pcall(function()
                                currentCamera.FieldOfView = fieldOfView
                            end)
                        end
                    end

                    enableStretch = function()
                        if stretchConn then
                            return
                        end
                        stretchEnabled = true
                        local currentCamera = workspace.CurrentCamera
                        if not currentCamera then
                            return
                        end
                        origFOV = currentCamera.FieldOfView or 70
                        applyStretchFOV(stretchFOV)

                        stretchConn = RunService.RenderStepped:Connect(function()
                            if stretchEnabled then
                                local currentCamera = workspace.CurrentCamera

                                if currentCamera then
                                    currentCamera.CFrame = currentCamera.CFrame * cframe(0, 0, 0, 1, 0, 0, 0, 0.7, 0, 0, 0, 1)
                                end

                                return
                            end

                            stretchConn:Disconnect()
                            stretchConn = nil
                        end)

                        if stretchFovConn then
                            stretchFovConn:Disconnect()
                        end

                        stretchFovConn = RunService.RenderStepped:Connect(function()
                            if stretchEnabled then
                                applyStretchFOV(stretchFOV)
                            else
                                stretchFovConn:Disconnect()
                                stretchFovConn = nil
                            end
                        end)
                    end

                    disableStretch = function()
                        stretchEnabled = false

                        if stretchConn then
                            stretchConn:Disconnect()
                            stretchConn = nil
                        end

                        if stretchFovConn then
                            stretchFovConn:Disconnect()
                            stretchFovConn = nil
                        end

                        local currentCamera = workspace.CurrentCamera

                        if currentCamera then
                            pcall(function()
                                currentCamera.FieldOfView = origFOV or 70
                            end)
                        end
                    end

                    SKY_PRESETS_LIST = {
                        "Off",
                        "Night",
                        "Aurora",
                        "Sunset",
                        "Galaxy",
                        "Cyber",
                        "Sakura",
                        "Pink Night",
                        "Blood Moon",
                        "Emerald Dawn",
                        "Volcanic",
                        "Arctic",
                        "Midnight Ocean",
                        "Vaporwave",
                        "Toxic",
                        "Solar Eclipse",
                        "Hellscape",
                        "Heaven",
                        "Storm",
                        "Sunrise",
                        "Deep Space",
                        "Lavender Dream",
                        "Inferno",
                        "Mint Sky",
                    }

                    SKY_PRESETS = {
                        Off = { kind = "off" },
                        Night = {
                            clock = 22,
                            brightness = 2,
                            ambient = { 110, 100, 130 },
                            outAmb = { 120, 110, 140 },
                            sky = {
                                stars = 4000,
                                moon = 18,
                                sun = 0,
                                moonTex = true,
                            },
                            atm = {
                                dens = 0.45,
                                color = { 120, 60, 180 },
                                decay = { 60, 20, 100 },
                                glare = 0.5,
                                haze = 1.2,
                            },
                        },
                        Aurora = {
                            clock = 14,
                            brightness = 3,
                            ambient = { 150, 120, 150 },
                            outAmb = { 160, 130, 150 },
                            atm = {
                                dens = 0.55,
                                color = { 255, 80, 200 },
                                decay = { 255, 20, 150 },
                                glare = 2.5,
                                haze = 3,
                            },
                            clouds = {
                                cover = 0.7,
                                dens = 0.7,
                                color = { 255, 240, 250 },
                            },
                        },
                        Sunset = {
                            clock = 17.2,
                            brightness = 2.5,
                            ambient = { 170, 120, 100 },
                            outAmb = { 180, 130, 110 },
                            sky = { stars = 0, sun = 25, moon = 0 },
                            atm = {
                                dens = 0.5,
                                color = { 255, 130, 60 },
                                decay = { 255, 80, 30 },
                                glare = 2,
                                haze = 2.5,
                            },
                            clouds = {
                                cover = 0.55,
                                dens = 0.55,
                                color = { 255, 200, 140 },
                            },
                        },
                        Galaxy = {
                            clock = 0,
                            brightness = 1.5,
                            ambient = { 70, 60, 100 },
                            outAmb = { 80, 70, 110 },
                            sky = { stars = 10000, moon = 30, sun = 0 },
                            atm = {
                                dens = 0.15,
                                color = { 40, 20, 80 },
                                decay = { 20, 10, 50 },
                                glare = 0.3,
                                haze = 0.5,
                            },
                        },
                        Cyber = {
                            clock = 21,
                            brightness = 2.2,
                            ambient = { 90, 130, 170 },
                            outAmb = { 100, 140, 180 },
                            sky = { stars = 2000, moon = 12 },
                            atm = {
                                dens = 0.4,
                                color = { 0, 200, 255 },
                                decay = { 150, 0, 255 },
                                glare = 2,
                                haze = 2,
                            },
                            clouds = {
                                cover = 0.4,
                                dens = 0.6,
                                color = { 100, 200, 255 },
                            },
                        },
                        Sakura = {
                            clock = 11,
                            brightness = 3.5,
                            ambient = { 170, 150, 160 },
                            outAmb = { 180, 160, 170 },
                            sky = { sun = 8 },
                            atm = {
                                dens = 0.3,
                                color = { 255, 200, 220 },
                                decay = { 255, 170, 200 },
                                glare = 1,
                                haze = 1.5,
                            },
                            clouds = {
                                cover = 0.6,
                                dens = 0.4,
                                color = { 255, 250, 252 },
                            },
                        },
                        ["Pink Night"] = {
                            clock = 23,
                            brightness = 2.2,
                            ambient = { 120, 60, 110 },
                            outAmb = { 140, 70, 120 },
                            sky = {
                                stars = 5000,
                                moon = 22,
                                sun = 0,
                                moonTex = true,
                            },
                            atm = {
                                dens = 0.5,
                                color = { 255, 80, 180 },
                                decay = { 140, 30, 100 },
                                glare = 0.7,
                                haze = 1.4,
                            },
                            clouds = {
                                cover = 0.3,
                                dens = 0.5,
                                color = { 180, 90, 150 },
                            },
                        },
                        ["Blood Moon"] = {
                            clock = 22.5,
                            brightness = 1.6,
                            ambient = { 130, 40, 40 },
                            outAmb = { 150, 50, 50 },
                            sky = {
                                stars = 1500,
                                moon = 28,
                                sun = 0,
                                moonTex = true,
                            },
                            atm = {
                                dens = 0.6,
                                color = { 220, 30, 30 },
                                decay = { 120, 10, 10 },
                                glare = 1.4,
                                haze = 2,
                            },
                            clouds = {
                                cover = 0.5,
                                dens = 0.7,
                                color = { 120, 30, 30 },
                            },
                        },
                        ["Emerald Dawn"] = {
                            clock = 6.5,
                            brightness = 2.8,
                            ambient = { 130, 170, 140 },
                            outAmb = { 140, 180, 150 },
                            sky = { sun = 18, moon = 0, stars = 0 },
                            atm = {
                                dens = 0.4,
                                color = { 80, 200, 140 },
                                decay = { 40, 150, 90 },
                                glare = 1.8,
                                haze = 2.2,
                            },
                            clouds = {
                                cover = 0.5,
                                dens = 0.5,
                                color = { 200, 255, 220 },
                            },
                        },
                        Volcanic = {
                            clock = 19,
                            brightness = 2,
                            ambient = { 180, 80, 40 },
                            outAmb = { 200, 90, 50 },
                            sky = { stars = 200, sun = 12, moon = 0 },
                            atm = {
                                dens = 0.75,
                                color = { 255, 60, 0 },
                                decay = { 180, 20, 0 },
                                glare = 3,
                                haze = 3.5,
                            },
                            clouds = {
                                cover = 0.8,
                                dens = 0.9,
                                color = { 120, 40, 20 },
                            },
                        },
                        Arctic = {
                            clock = 9,
                            brightness = 3.2,
                            ambient = { 200, 220, 235 },
                            outAmb = { 210, 230, 245 },
                            sky = { sun = 10, stars = 0, moon = 0 },
                            atm = {
                                dens = 0.3,
                                color = { 180, 220, 255 },
                                decay = { 140, 200, 240 },
                                glare = 1.5,
                                haze = 1.8,
                            },
                            clouds = {
                                cover = 0.7,
                                dens = 0.6,
                                color = { 250, 253, 255 },
                            },
                        },
                        ["Midnight Ocean"] = {
                            clock = 1.5,
                            brightness = 1.7,
                            ambient = { 60, 90, 130 },
                            outAmb = { 70, 100, 140 },
                            sky = {
                                stars = 6000,
                                moon = 24,
                                sun = 0,
                                moonTex = true,
                            },
                            atm = {
                                dens = 0.5,
                                color = { 20, 60, 140 },
                                decay = { 10, 30, 90 },
                                glare = 0.6,
                                haze = 1.5,
                            },
                        },
                        Vaporwave = {
                            clock = 19.5,
                            brightness = 2.4,
                            ambient = { 180, 120, 200 },
                            outAmb = { 190, 130, 210 },
                            sky = { stars = 1000, moon = 14 },
                            atm = {
                                dens = 0.45,
                                color = { 255, 100, 220 },
                                decay = { 120, 60, 255 },
                                glare = 2.2,
                                haze = 2.4,
                            },
                            clouds = {
                                cover = 0.55,
                                dens = 0.55,
                                color = { 200, 150, 255 },
                            },
                        },
                        Toxic = {
                            clock = 13,
                            brightness = 2.5,
                            ambient = { 140, 180, 80 },
                            outAmb = { 150, 190, 90 },
                            atm = {
                                dens = 0.55,
                                color = { 100, 220, 40 },
                                decay = { 60, 150, 20 },
                                glare = 1.8,
                                haze = 2.6,
                            },
                            clouds = {
                                cover = 0.65,
                                dens = 0.7,
                                color = { 180, 255, 120 },
                            },
                        },
                        ["Solar Eclipse"] = {
                            clock = 12,
                            brightness = 0.9,
                            ambient = { 50, 40, 60 },
                            outAmb = { 60, 50, 70 },
                            sky = { stars = 3500, sun = 22, moon = 0 },
                            atm = {
                                dens = 0.5,
                                color = { 255, 140, 40 },
                                decay = { 30, 20, 40 },
                                glare = 2.8,
                                haze = 1.8,
                            },
                        },
                        Hellscape = {
                            clock = 18,
                            brightness = 1.8,
                            ambient = { 200, 60, 30 },
                            outAmb = { 220, 70, 40 },
                            sky = { stars = 100, sun = 30, moon = 0 },
                            atm = {
                                dens = 0.85,
                                color = { 255, 30, 0 },
                                decay = { 120, 0, 0 },
                                glare = 3.5,
                                haze = 4,
                            },
                            clouds = {
                                cover = 0.95,
                                dens = 0.95,
                                color = { 80, 20, 10 },
                            },
                        },
                        Heaven = {
                            clock = 12,
                            brightness = 4,
                            ambient = { 240, 235, 210 },
                            outAmb = { 250, 245, 220 },
                            sky = { sun = 16, moon = 0, stars = 0 },
                            atm = {
                                dens = 0.25,
                                color = { 255, 250, 220 },
                                decay = { 255, 240, 200 },
                                glare = 3,
                                haze = 1.5,
                            },
                            clouds = {
                                cover = 0.85,
                                dens = 0.5,
                                color = { 255, 255, 255 },
                            },
                        },
                        Storm = {
                            clock = 15,
                            brightness = 1.4,
                            ambient = { 90, 90, 110 },
                            outAmb = { 100, 100, 120 },
                            sky = { stars = 0, sun = 6, moon = 0 },
                            atm = {
                                dens = 0.65,
                                color = { 80, 90, 120 },
                                decay = { 40, 50, 80 },
                                glare = 0.5,
                                haze = 3,
                            },
                            clouds = {
                                cover = 0.95,
                                dens = 0.95,
                                color = { 60, 65, 80 },
                            },
                        },
                        Sunrise = {
                            clock = 6.2,
                            brightness = 2.8,
                            ambient = { 220, 180, 130 },
                            outAmb = { 230, 190, 140 },
                            sky = { sun = 22, stars = 0, moon = 0 },
                            atm = {
                                dens = 0.45,
                                color = { 255, 180, 100 },
                                decay = { 255, 140, 80 },
                                glare = 2.4,
                                haze = 2.2,
                            },
                            clouds = {
                                cover = 0.4,
                                dens = 0.4,
                                color = { 255, 220, 180 },
                            },
                        },
                        ["Deep Space"] = {
                            clock = 0,
                            brightness = 1,
                            ambient = { 30, 25, 50 },
                            outAmb = { 40, 35, 60 },
                            sky = { stars = 15000, moon = 0, sun = 0 },
                            atm = {
                                dens = 0.08,
                                color = { 15, 5, 40 },
                                decay = { 5, 0, 20 },
                                glare = 0.2,
                                haze = 0.3,
                            },
                        },
                        ["Lavender Dream"] = {
                            clock = 18.5,
                            brightness = 2.6,
                            ambient = { 180, 160, 220 },
                            outAmb = { 190, 170, 230 },
                            sky = { stars = 800, moon = 16, sun = 0 },
                            atm = {
                                dens = 0.4,
                                color = { 200, 160, 255 },
                                decay = { 160, 120, 220 },
                                glare = 1.4,
                                haze = 1.8,
                            },
                            clouds = {
                                cover = 0.55,
                                dens = 0.5,
                                color = { 220, 200, 255 },
                            },
                        },
                        Inferno = {
                            clock = 17.5,
                            brightness = 2.2,
                            ambient = { 220, 100, 40 },
                            outAmb = { 235, 110, 50 },
                            sky = { sun = 26, moon = 0, stars = 0 },
                            atm = {
                                dens = 0.6,
                                color = { 255, 90, 20 },
                                decay = { 200, 40, 0 },
                                glare = 3,
                                haze = 3.2,
                            },
                            clouds = {
                                cover = 0.7,
                                dens = 0.7,
                                color = { 200, 80, 40 },
                            },
                        },
                        ["Mint Sky"] = {
                            clock = 10,
                            brightness = 3.2,
                            ambient = { 180, 230, 210 },
                            outAmb = { 190, 240, 220 },
                            sky = { sun = 10 },
                            atm = {
                                dens = 0.32,
                                color = { 150, 255, 210 },
                                decay = { 100, 220, 180 },
                                glare = 1.6,
                                haze = 1.6,
                            },
                            clouds = {
                                cover = 0.55,
                                dens = 0.45,
                                color = { 240, 255, 250 },
                            },
                        },
                    }

                    do
                        local function toColor3(key)
                            return Color3.fromRGB(key[1], key[2], key[3])
                        end

                        _v4mpClearSky = function()
                            for _, child in ipairs(Lighting:GetChildren()) do
                                if child:GetAttribute("_AdaptDuelsSky") then
                                    pcall(function()
                                        child:Destroy()
                                    end)
                                end
                            end

                            local terrain = workspace:FindFirstChildOfClass("Terrain")

                            if terrain then
                                for _, child in ipairs(terrain:GetChildren()) do
                                    if child:GetAttribute("_AdaptDuelsSky") then
                                        pcall(function()
                                            child:Destroy()
                                        end)
                                    end
                                end
                            end
                        end

                        applyCustomSky = function(index)
                            _v4mpClearSky()
                            local entry = SKY_PRESETS[index]

                            if not entry or entry.kind == "off" then
                                Lighting.ClockTime = 14
                                Lighting.Brightness = 2
                                Lighting.OutdoorAmbient = Color3.fromRGB(127, 127, 127)
                                Lighting.Ambient = Color3.fromRGB(127, 127, 127)
                                Lighting.FogEnd = 100000
                                Lighting.GlobalShadows = true
                                skyTheme = "Off"
                                return
                            end

                            Lighting.FogStart = 0
                            Lighting.FogEnd = 100000
                            Lighting.FogColor = Color3.fromRGB(200, 200, 200)
                            Lighting.ColorShift_Top = Color3.fromRGB(0, 0, 0)
                            Lighting.ColorShift_Bottom = Color3.fromRGB(0, 0, 0)
                            Lighting.GlobalShadows = true
                            Lighting.ClockTime = entry.clock or 14
                            Lighting.Brightness = entry.brightness or 2

                            if entry.outAmb then
                                Lighting.OutdoorAmbient = toColor3(entry.outAmb)
                            end

                            if entry.ambient then
                                Lighting.Ambient = toColor3(entry.ambient)
                            end

                            if entry.sky then
                                local sky = Instance.new("Sky")
                                sky:SetAttribute("_AdaptDuelsSky", true)

                                if entry.sky.stars then
                                    sky.StarCount = entry.sky.stars
                                end

                                if entry.sky.moon then
                                    sky.MoonAngularSize = entry.sky.moon
                                end

                                if entry.sky.sun then
                                    sky.SunAngularSize = entry.sky.sun
                                end

                                if entry.sky.moonTex then
                                    sky.MoonTextureId = "rbxasset://sky/moon.jpg"
                                end

                                sky.Parent = Lighting
                            end

                            if entry.atm then
                                local atmosphere = Instance.new("Atmosphere")
                                atmosphere:SetAttribute("_AdaptDuelsSky", true)
                                atmosphere.Density = entry.atm.dens or 0.3
                                atmosphere.Color = toColor3(entry.atm.color)
                                atmosphere.Decay = toColor3(entry.atm.decay)
                                atmosphere.Glare = entry.atm.glare or 1
                                atmosphere.Haze = entry.atm.haze or 1
                                atmosphere.Parent = Lighting
                            end

                            local terrain = workspace:FindFirstChildOfClass("Terrain")

                            if entry.clouds and terrain then
                                local clouds = Instance.new("Clouds")
                                clouds:SetAttribute("_AdaptDuelsSky", true)
                                clouds.Cover = entry.clouds.cover or 0.5
                                clouds.Density = entry.clouds.dens or 0.5
                                clouds.Color = toColor3(entry.clouds.color)
                                clouds.Parent = terrain
                            end

                            skyTheme = index
                        end
                    end
                end

                enableVividGraphics = function()
                    if vividGraphicsEnabled and #_vividEffects > 0 then
                        return
                    end
                    vividGraphicsEnabled = true

                    for _, _vividEffect in ipairs(_vividEffects) do
                        pcall(function()
                            _vividEffect:Destroy()
                        end)
                    end

                    _vividEffects = {}
                    local colorCorrectionEffect = Instance.new("ColorCorrectionEffect")
                    colorCorrectionEffect.Parent = Lighting
                    colorCorrectionEffect.Saturation = 0.6
                    colorCorrectionEffect.Contrast = 0.4
                    colorCorrectionEffect.Brightness = 0.05
                    colorCorrectionEffect.TintColor = Color3.fromRGB(255, 240, 220)
                    table.insert(_vividEffects, colorCorrectionEffect)
                    local bloomEffect = Instance.new("BloomEffect")
                    bloomEffect.Parent = Lighting
                    bloomEffect.Intensity = 0.8
                    bloomEffect.Size = 24
                    bloomEffect.Threshold = 1
                    table.insert(_vividEffects, bloomEffect)
                    local atmosphere = Instance.new("Atmosphere")
                    atmosphere.Parent = Lighting
                    atmosphere.Density = 0.3
                    atmosphere.Offset = 0.25
                    atmosphere.Color = Color3.fromRGB(199, 199, 255)
                    atmosphere.Decay = Color3.fromRGB(106, 112, 125)
                    atmosphere.Glare = 0.2
                    atmosphere.Haze = 1
                    table.insert(_vividEffects, atmosphere)
                    local sunRaysEffect = Instance.new("SunRaysEffect")
                    sunRaysEffect.Parent = Lighting
                    sunRaysEffect.Intensity = 0.2
                    sunRaysEffect.Spread = 0.8
                    table.insert(_vividEffects, sunRaysEffect)
                    local depthOfFieldEffect = Instance.new("DepthOfFieldEffect")
                    depthOfFieldEffect.Parent = Lighting
                    depthOfFieldEffect.FocusDistance = 25
                    depthOfFieldEffect.InFocusRadius = 10
                    depthOfFieldEffect.NearIntensity = 0.2
                    depthOfFieldEffect.FarIntensity = 0.4
                    table.insert(_vividEffects, depthOfFieldEffect)

                    task.spawn(function()
                        while vividGraphicsEnabled and colorCorrectionEffect and colorCorrectionEffect.Parent do
                            colorCorrectionEffect.Contrast = 0.35 + math.sin(tick() * 2) * 0.05
                            task.wait(0.03)
                        end
                    end)
                end

                disableVividGraphics = function()
                    vividGraphicsEnabled = false

                    for _, _vividEffect in ipairs(_vividEffects) do
                        pcall(function()
                            _vividEffect:Destroy()
                        end)
                    end

                    _vividEffects = {}
                end

                toggleVividGraphics = function(enabled)
                    if enabled then
                        enableVividGraphics()
                    else
                        disableVividGraphics()
                    end

                    saveAllSettings(true)
                end

                applyHideButtons = function(target)
                    hideButtonsEnabled = target

                    if mobilePanel then
                        for _, child in ipairs(mobilePanel:GetChildren()) do
                            if child:IsA("TextButton") then
                                child.Visible = not target
                            end
                        end
                    end

                    if tpBatFloatingButton then
                        local frame = tpBatFloatingButton:FindFirstChild("Frame")

                        if frame then
                            frame.Visible = not target
                        end
                    end

                    if instaResetFloatingButton then
                        local frame = instaResetFloatingButton:FindFirstChild("Frame")

                        if frame then
                            frame.Visible = not target
                        end
                    end
                end

                toggleHideButtons = function(target)
                    applyHideButtons(target)

                    if setHideButtonsVisual then
                        setHideButtonsVisual(target)
                    end

                    saveAllSettings(true)
                end

                paintFloatingBtn = function(instance, enabled)
                    if not instance then
                        return
                    end
                    local btnGrad = instance:FindFirstChild("BtnGrad")
                    local textLabel2 = instance:FindFirstChild("TextLabel")
                    local uiStroke = instance:FindFirstChildOfClass("UIStroke")

                    if btnGrad then
                        instance.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                    else
                        instance.BackgroundColor3 = enabled and Color3.fromRGB(242, 40, 139) or Color3.fromRGB(8, 8, 12)
                    end

                    if enabled then
                        if btnGrad then
                            applyThemeGradient(btnGrad, false)

                            btnGrad.Color = ColorSequence.new({

                                ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 116, 190)),

                                ColorSequenceKeypoint.new(0.45, Color3.fromRGB(245, 43, 143)),

                                ColorSequenceKeypoint.new(1, Color3.fromRGB(180, 18, 96)),

                            })
                            btnGrad.Rotation = 90
                            btnGrad.Offset = Vector2.new(0, 0)
                        end

                        if textLabel2 then
                            textLabel2.TextColor3 = Color3.fromRGB(255, 255, 255)
                        end

                        if uiStroke then
                            uiStroke.Color = Color3.fromRGB(255, 126, 195)
                            uiStroke.Thickness = 1
                            uiStroke.Transparency = 0.18
                        end
                    else
                        if btnGrad then
                            applyThemeGradient(btnGrad, false)

                            btnGrad.Color = ColorSequence.new({

                                ColorSequenceKeypoint.new(0, Color3.fromRGB(25, 25, 31)),

                                ColorSequenceKeypoint.new(0.52, Color3.fromRGB(12, 12, 17)),

                                ColorSequenceKeypoint.new(1, Color3.fromRGB(4, 4, 7)),

                            })
                            btnGrad.Rotation = 90
                            btnGrad.Offset = Vector2.new(0, 0)
                        end

                        if textLabel2 then
                            textLabel2.TextColor3 = Color3.fromRGB(245, 245, 250)
                        end

                        if uiStroke then
                            uiStroke.Color = Color3.fromRGB(36, 36, 45)
                            uiStroke.Thickness = 1
                            uiStroke.Transparency = 0.22
                        end
                    end
                end

                applyFloatingButtonScale = function()
                    for _, _floatingUIScale in ipairs(_floatingUIScales) do
                        if _floatingUIScale and _floatingUIScale.Parent then
                            _floatingUIScale.Scale = floatingButtonScale
                        end
                    end
                end

                createFollowController = function(part, value)
                    local isActive = false
                    local position = nil
                    local value2 = nil
                    local amount = value or 99999
                    local connection2

                    local function stopFollowController()

                        isActive = false
                        value2 = nil

                        if connection2 then
                            connection2:Disconnect()
                            connection2 = nil
                        end

                        if isActive then
                            task.defer(function()
                                pcall(saveAllSettings)
                            end)
                        end
                    end

                    local position2

                    part.InputBegan:Connect(function(input)
                        if uiLocked then
                            return
                        end

                        if _isDraggingButton then
                            return
                        end

                        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                            if input.Position.Y > part.AbsolutePosition.Y + amount then
                                return
                            end
                            isActive = true
                            position2 = input.Position
                            position = part.Position

                            if connection2 then
                                connection2:Disconnect()
                            end

                            connection2 = input.Changed:Connect(function()
                                if input.UserInputState == Enum.UserInputState.End then
                                    stopFollowController()
                                end
                            end)
                        end
                    end)

                    part.InputEnded:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                            stopFollowController()
                        end
                    end)

                    UserInputService.InputEnded:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                            stopFollowController()
                        end
                    end)

                    part.InputChanged:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                            value2 = input
                        end
                    end)

                    UserInputService.InputChanged:Connect(function(input)
                        if input == value2 and isActive then
                            if uiLocked then
                                stopFollowController()
                                return
                            end

                            if _isDraggingButton then
                                return
                            end

                            if not position2 or not position then
                                return
                            end
                            part.Position = UDim2.new(position.X.Scale, position.X.Offset + input.Position.X - position2.X, position.Y.Scale, position.Y.Offset + input.Position.Y - position2.Y)
                        end
                    end)
                end

                _G.__YoutSpeedEngine = _G.__YoutSpeedEngine or { started = false, conn = nil }
                _G.__YoutSpeedEngine.signal = nil

                do
                    local success, result = pcall(function()
                        return RunService.PreSimulation
                    end)

                    _G.__YoutSpeedEngine.signal = success and result or RunService.Heartbeat
                end
            end

            isHumanoidIncapacitated2 = function(humanoid)
                if not humanoid then
                    return true
                end
                local state = humanoid:GetState()
                return humanoid.PlatformStand or state == Enum.HumanoidStateType.Physics or state == Enum.HumanoidStateType.Ragdoll or state == Enum.HumanoidStateType.FallingDown
            end

            do
                local function shouldUseSpeedOverride(enabled)
                    if speedMode then
                        return true
                    end

                    if enabled and CONFIG.AUTO_STEAL_ENABLED then
                        return true
                    end
                    return false
                end

                local function getNormalSpeed()
                    if laggerToggled or laggerCarryToggled then
                        return LAGGER_SPEED
                    end
                    return NORMAL_SPEED
                end

                local function getCarrySpeed()
                    if laggerCarryToggled then
                        return LAGGER_CARRY_SPEED
                    end

                    if laggerToggled then
                        return LAGGER_SPEED
                    end
                    return CARRY_SPEED
                end

                getTargetSpeed = function(target)
                    if shouldUseSpeedOverride(target) then
                        return getCarrySpeed()
                    end
                    return getNormalSpeed()
                end
            end
        end

        do
            do
                local function resetSpeedVelocity()
                    lastMoveDir = vector2
                    youtSpeedHookState.v = vector(0, youtSpeedHookState.v.Y or 0, 0)
                end

                local function youtStopSpeedEngine()
                    if _G.__YoutSpeedEngine.conn then
                        _G.__YoutSpeedEngine.conn:Disconnect()
                        _G.__YoutSpeedEngine.conn = nil
                    end

                    resetSpeedVelocity()
                end

                local function startSpeedEngine()
                    youtStopSpeedEngine()
                    _G.__YoutSpeedEngine.started = true
                    _G.__YoutSpeedEngine.acc = 0

                    _G.__YoutSpeedEngine.conn = _G.__YoutSpeedEngine.signal:Connect(function(target)
                        _G.__YoutSpeedEngine.acc = (_G.__YoutSpeedEngine.acc or 0) + (target or 0)
                        if _G.__YoutSpeedEngine.acc < 0.016 then
                            return
                        end
                        _G.__YoutSpeedEngine.acc = 0
                        local character = localPlayer.Character
                        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
                        local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
                        if not humanoid or not humanoidRootPart or humanoid.Health <= 0 then
                            return
                        end

                        if youtBatV2PersistentState.enabled then
                            return
                        end

                        if autoBatEnabled or batDesyncTpEnabled or autoLeftEnabled or autoRightEnabled or dropActive or _G.IsDropping then
                            resetSpeedVelocity()
                            return
                        end

                        if isHumanoidIncapacitated2(humanoid) then
                            lastMoveDir = vector2
                            return
                        end

                        if youtSpeedHookState.root ~= humanoidRootPart or not velChecked[humanoidRootPart] then
                            lastMoveDir = vector2
                            attachVelocityHookToRoot(character)
                            installVelocityHook(humanoidRootPart)
                        end

                        local moveDirection

                        if humanoid.MoveDirection.Magnitude > 0 then
                            lastMoveDir = humanoid.MoveDirection
                            moveDirection = humanoid.MoveDirection
                        else
                            moveDirection = nil

                            if lastMoveDir.Magnitude > 0 then
                                moveDirection = nil

                                for entry in pairs(MOVE_KEYS) do
                                    if UserInputService:IsKeyDown(entry) then
                                        moveDirection = lastMoveDir
                                        break
                                    else
                                        moveDirection = nil
                                    end
                                end
                            end
                        end

                        local targetSpeed = getTargetSpeed(localPlayer:GetAttribute("Stealing") == true)
                        applyBatHitVelocity(moveDirection, tonumber(targetSpeed) or 16, humanoidRootPart)
                    end)
                end

                local function youtApplySpeedNow()
                    local character = localPlayer.Character
                    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
                    character = character and character:FindFirstChild("HumanoidRootPart")
                    if not humanoid or not character or humanoid.Health <= 0 or isHumanoidIncapacitated2(humanoid) then
                        return
                    end
                    applyBatHitVelocity(humanoid.MoveDirection.Magnitude > 0.05 and humanoid.MoveDirection or nil, getTargetSpeed(localPlayer:GetAttribute("Stealing") == true), character)
                end

                _G.__YoutRefreshSpeedEngine = function()
                    startSpeedEngine()
                end

                _G.__YoutStopSpeedEngine = youtStopSpeedEngine
                _G.__YoutApplySpeedNow = youtApplySpeedNow
                pcall(startSpeedEngine)

                localPlayer.CharacterAdded:Connect(function(character)
                    task.wait(0.5)
                    resetSpeedVelocity()
                    local humanoidRootPart = character:WaitForChild("HumanoidRootPart", 5)

                    if humanoidRootPart then
                        attachVelocityHookToRoot(character)
                        installVelocityHook(humanoidRootPart)
                    end

                    startSpeedEngine()
                end)

                localPlayer.CharacterRemoving:Connect(function()
                    youtStopSpeedEngine()
                    youtSpeedHookState.root = nil
                end)
            end
        end
    end

    do
        local findReadFile, readConfigFile

        do
            setupMovementAndIndicators = function(target)
                if steppedConn then
                    steppedConn:Disconnect()
                    steppedConn = nil
                end

                if movementLoop then
                    movementLoop:Disconnect()
                    movementLoop = nil
                end

                local counter = 0

                steppedConn = RunService.Heartbeat:Connect(function(deltaTime)
                    counter += deltaTime
                    if counter < 0.05 then
                        return
                    end
                    counter = 0
                    local cachedPlayers = getCachedPlayers()

                    for index = 1, #cachedPlayers do
                        local entry = cachedPlayers[index]

                        if entry ~= localPlayer then
                            local character = entry.Character

                            if character then
                                local children = character:GetChildren()

                                for index = 1, #children do
                                    local entry = children[index]

                                    if entry:IsA("BasePart") and entry.CanCollide then
                                        entry.CanCollide = false
                                    end
                                end
                            end
                        end
                    end
                end)

                movementLoop = RunService.RenderStepped:Connect(function()
                    local character = localPlayer.Character
                    if not character then
                        return
                    end
                    local humanoid = character:FindFirstChildOfClass("Humanoid")
                    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
                    if not humanoid or not humanoidRootPart then
                        return
                    end

                    if not autoBatEnabled and not youtBatV2PersistentState.enabled and not autoLeftEnabled and not autoRightEnabled and not batDesyncTpEnabled then
                        if isHumanoidIncapacitated(humanoid) then
                            lastMoveDir = vector2
                        else
                            local moveDirection = humanoid.MoveDirection

                            if moveDirection.Magnitude > 0 then
                                lastMoveDir = moveDirection
                            end
                        end
                    end

                    if speedLabel then
                        speedLabel.Text = string.format("%.1f  -  %s", getActiveMoveSpeed(), getSpeedModeName())
                    end
                end)

                setupSpeedIndicator(target)
                startEnemySpeed()
            end

            toggleLockUI = function(enabled)
                if enabled == nil then
                    uiLocked = not uiLocked
                else
                    uiLocked = enabled
                end

                if setLockUIVisual then
                    setLockUIVisual(uiLocked)
                end
            end

            disableAllAimbots = function()
                if youtBatV2PersistentState.enabled then
                    stopYoutBatV2()
                end

                if autoBatEnabled then
                    disableAutoBat()

                    if autoBatSetVisual then
                        autoBatSetVisual(false)
                    end

                    if mobSetAutoBat then
                        mobSetAutoBat(false)
                    end
                end

                if batDesyncTpEnabled then
                    stopBatDesyncTp()
                end
            end

            stopAllBackgroundTasks = function()
                if movementLoop then
                    movementLoop:Disconnect()
                    movementLoop = nil
                end

                if steppedConn then
                    steppedConn:Disconnect()
                    steppedConn = nil
                end

                stopEnemySpeed()

                if stretchEnabled then
                    disableStretch()
                end

                if stretchConn then
                    stretchConn:Disconnect()
                    stretchConn = nil
                end

                if stretchFovConn then
                    stretchFovConn:Disconnect()
                    stretchFovConn = nil
                end

                if antiRagdollState.Enabled then
                    stopAntiRagdoll()
                end

                if antiDieEnabled then
                    AntiDieModule.stop()
                end

                if antiBatEnabled then
                    stopAntiBat()
                end

                if antiFlingEnabled then
                    stopAntiFling()
                end

                stopBatCounter()
                stopBatCounterV2()
                stopMedusaCounter()
                stopAutoSteal()
                disableAutoBat()

                if batDesyncTpEnabled then
                    stopBatDesyncTp()
                end

                stopAutoLeft()
                stopAutoRight()

                if unwalkEnabled then
                    stopUnwalk()
                end

                if antiLagEnabled then
                    disableAntiLag()
                end

                if isEspActive then
                    toggleESP(false)
                end

                if espLineEnabled then
                    stopESPLine()
                end

                if dropActive then
                    stopDropBrainrot()
                end

                if bodyLockEnabled then
                    stopBodyLock()
                end

                _blSuppressCount = 0
                _blWasEnabled = false

                if _blRestoreTimer then
                    pcall(task.cancel, _blRestoreTimer)
                    _blRestoreTimer = nil
                end

                if _bodyLockConn then
                    _bodyLockConn:Disconnect()
                    _bodyLockConn = nil
                end

                for _, dropConnection in ipairs(dropConnections) do
                    if type(dropConnection) == "thread" then
                        pcall(task.cancel, dropConnection)
                    elseif type(dropConnection) == "RBXScriptConnection" then
                        pcall(dropConnection.Disconnect, dropConnection)
                    end
                end

                dropConnections = {}
                dropActive = false
                alPhase = 1
                arPhase = 1
                lastDropTime = 0
                medusaDebounce = false
                medusaLastUsed = 0

                if _G.__YoutStopSpeedEngine then
                    pcall(_G.__YoutStopSpeedEngine)
                end
            end

            do
                local data = {
                    lastAt = 0,
                    queued = false,
                    writing = false,
                    revision = 0,
                }

                findReadFile = function()
                    local genv = getgenv and getgenv() or _G

                    local value = nil

                    for _, value2 in pairs({ readfile, (syn and syn.readfile), genv.readfile }) do
                        if type(value2) == "function" then
                            value = value2
                            break
                        else
                            value = nil
                        end
                    end

                    local value2 = nil

                    for _, value3 in pairs({ writefile, (syn and syn.writefile), genv.writefile }) do
                        if type(value3) == "function" then
                            value2 = value3
                            break
                        else
                            value2 = nil
                        end
                    end

                    return value, value2
                end

                readConfigFile = function(target)
                    local readFile = findReadFile()
                    if not readFile then
                        return false
                    end
                    local success, result = pcall(readFile, target)
                    return success and type(result) == "string"
                end

                buildConfigTable = function()
                    local data2 = {
                        normalSpeed = NORMAL_SPEED,
                        carrySpeed = CARRY_SPEED,
                        laggerSpeed1 = LAGGER_SPEED,
                        laggerSpeed2 = LAGGER_CARRY_SPEED,
                        stealRadius = CONFIG.STEAL_RANGE,
                        antiRagdollMode = antiRagdollMode,
                        antiDieEnabled = antiDieEnabled,
                        antiBat = antiBatEnabled,
                        antiFling = antiFlingEnabled,
                        selectedStealMode = selectedStealMode,
                        autoSteal = CONFIG.AUTO_STEAL_ENABLED,
                        medusaCounter = medusaCounterEnabled,
                        batCounter = batCounterEnabled,
                        batCounterV2 = batCounterV2Enabled,
                        unwalkEnabled = unwalkEnabled,
                        laggerToggled = laggerToggled,
                        laggerCarryToggled = laggerCarryToggled,
                        carryMode = speedMode,
                        batAimbotSpeed = BAT_AIMBOT_SPEED,
                        dropMode = dropMode,
                        stretchEnabled = stretchEnabled,
                        stretchFOV = stretchFOV,
                        uiScale = uiScaleValue,
                        animPack = currentAnimPack,
                        espEnabled = isEspActive,
                        espLineEnabled = espLineEnabled,
                        vividGraphics = vividGraphicsEnabled,
                        hideButtons = hideButtonsEnabled,
                        antiLag = antiLagEnabled,
                        tpBatEnabled = batDesyncTpEnabled,
                        skyTheme = skyTheme,
                        mobileButtonPositions = savedButtonPositions,
                        dropBrainrotKey = {
                            kb = KEYBINDS.DropBrainrot.kb and KEYBINDS.DropBrainrot.kb.Name,
                            gp = KEYBINDS.DropBrainrot.gp and KEYBINDS.DropBrainrot.gp.Name,
                        },
                        autoLeftKey = { kb = KEYBINDS.AutoLeft.kb and KEYBINDS.AutoLeft.kb.Name, gp = KEYBINDS.AutoLeft.gp and KEYBINDS.AutoLeft.gp.Name },
                        autoRightKey = { kb = KEYBINDS.AutoRight.kb and KEYBINDS.AutoRight.kb.Name, gp = KEYBINDS.AutoRight.gp and KEYBINDS.AutoRight.gp.Name },
                        autoBatKey = { kb = KEYBINDS.AutoBat.kb and KEYBINDS.AutoBat.kb.Name, gp = KEYBINDS.AutoBat.gp and KEYBINDS.AutoBat.gp.Name },
                        batV2Key = { kb = KEYBINDS.BatV2.kb and KEYBINDS.BatV2.kb.Name, gp = KEYBINDS.BatV2.gp and KEYBINDS.BatV2.gp.Name },
                        tpFloorKey = { kb = KEYBINDS.TPFloor.kb and KEYBINDS.TPFloor.kb.Name, gp = KEYBINDS.TPFloor.gp and KEYBINDS.TPFloor.gp.Name },
                        guiHideKey = { kb = KEYBINDS.GuiHide.kb and KEYBINDS.GuiHide.kb.Name, gp = KEYBINDS.GuiHide.gp and KEYBINDS.GuiHide.gp.Name },
                        carryToggleKey = {
                            kb = KEYBINDS.CarryToggle.kb and KEYBINDS.CarryToggle.kb.Name,
                            gp = KEYBINDS.CarryToggle.gp and KEYBINDS.CarryToggle.gp.Name,
                        },
                        laggerModeKey = {
                            kb = KEYBINDS.LaggerMode.kb and KEYBINDS.LaggerMode.kb.Name,
                            gp = KEYBINDS.LaggerMode.gp and KEYBINDS.LaggerMode.gp.Name,
                        },
                        tpBatKey = { kb = KEYBINDS.TPBat.kb and KEYBINDS.TPBat.kb.Name, gp = KEYBINDS.TPBat.gp and KEYBINDS.TPBat.gp.Name },
                        instaResetKey = {
                            kb = KEYBINDS.InstaReset.kb and KEYBINDS.InstaReset.kb.Name,
                            gp = KEYBINDS.InstaReset.gp and KEYBINDS.InstaReset.gp.Name,
                        },
                        batV2FloatingPos = batV2FloatingPos,
                        tpBatFloatingPos = tpBatFloatingPos,
                        instaResetFloatingPos = instaResetFloatingPos,
                        bodyLockEnabled = bodyLockEnabled,
                        bodyLockRange = bodyLockRange,
                        progressBarPos = savedProgressBarPos,
                        lockUI = uiLocked,
                        backgroundIndex = backgroundIndex,
                        backgroundImageTransparency = backgroundImageTransparency,
                        backgroundMode = backgroundMode,
                        floatingButtonScale = floatingButtonScale,
                        outfitIndex = outfitIndex,
                        themeColor = currentColorTheme,
                    }

                    if main then
                        local youtMainOriginalPos = _G.__YoutMainOriginalPos or main.Position
                        data2.mainPosition = { XScale = youtMainOriginalPos.X.Scale, XOffset = youtMainOriginalPos.X.Offset, YScale = youtMainOriginalPos.Y.Scale, YOffset = youtMainOriginalPos.Y.Offset }
                    end

                    if pbFrame then
                        data2.progressBarPos = {
                            XScale = pbFrame.Position.X.Scale,
                            XOffset = pbFrame.Position.X.Offset,
                            YScale = pbFrame.Position.Y.Scale,
                            YOffset = pbFrame.Position.Y.Offset,
                        }
                    end

                    if mobilePanel then
                        data2.mobilePanelPos = { XScale = 0, XOffset = 10, YScale = 0, YOffset = 0 }

                        for _, child in ipairs(mobilePanel:GetChildren()) do
                            if child:IsA("TextButton") then
                                savedButtonPositions[child.Name] = { X = child.Position.X.Offset, Y = child.Position.Y.Offset }
                            end
                        end

                        data2.mobileButtonPositions = savedButtonPositions
                    end

                    return data2
                end

                saveAllSettings = function(enabled)
                    if _isResetting or _isLoading then
                        return true
                    end
                    local configTable = buildConfigTable()
                    configTable.configVersion = 3
                    configTable.userId = localPlayer.UserId

                    local success, result = pcall(function()
                        return HttpService:JSONEncode(configTable)
                    end)

                    if not success then
                        return false
                    end

                    if not enabled and result == _lastSavedJSON then
                        return true
                    end
                    local writing = data.writing
                    local bestWriting

                    if writing then
                        bestWriting = writing
                    else
                        local isActive = not enabled

                        if isActive then
                            bestWriting = getTime() - data.lastAt < 0.25
                        else
                            bestWriting = isActive
                        end
                    end

                    if bestWriting then
                        if not data.queued then
                            data.queued = true

                            task.delay(0.25, function()
                                data.queued = false
                                saveAllSettings(true)
                            end)
                        end

                        return true
                    end

                    local readFile, value = findReadFile()
                    if not readFile or not value then
                        return false
                    end
                    data.writing = true
                    data.revision = data.revision + 1
                    configTable.revision = data.revision
                    configTable.savedAt = os.time()
                    local json = HttpService:JSONEncode(configTable)

                    local success = pcall(function()
                        if readConfigFile(CONFIG_FILE) then
                            local file = readFile(CONFIG_FILE)

                            if type(file) == "string" then
                                value(CONFIG_FILE .. ".backup", file)
                            end
                        end

                        value(CONFIG_FILE, json)
                        local file = readFile(CONFIG_FILE)

                        if file ~= json then
                            error("save verification failed")
                        end

                        HttpService:JSONDecode(file)
                    end)

                    data.writing = false
                    data.lastAt = getTime()

                    if success then
                        _lastSavedJSON = json
                    else
                    end

                    return success
                end
            end
        end

        do
            local readFile, value = findReadFile()

            if readFile and value then
                local text

                do
                    text = "BloodHounds_" .. tostring(localPlayer.UserId) .. ".json"
                end

                local success, result = pcall(readFile, text)
                local success2 = pcall(readFile, CONFIG_FILE)

                if success and type(result) == "string" and not success2 then
                    pcall(value, CONFIG_FILE, result)
                end
            end
        end

        loadAllSettings = function()
            local readFile = findReadFile()
            if not readFile or not readConfigFile(CONFIG_FILE) then
                return false
            end

            local success, result = pcall(function()
                return HttpService:JSONDecode(readFile(CONFIG_FILE))
            end)

            if not success or not result then
                return false
            end
            _isLoading = true
            NORMAL_SPEED = result.normalSpeed or NORMAL_SPEED
            CARRY_SPEED = result.carrySpeed or CARRY_SPEED
            LAGGER_SPEED = result.laggerSpeed1 or LAGGER_SPEED
            LAGGER_CARRY_SPEED = result.laggerSpeed2 or LAGGER_CARRY_SPEED
            CONFIG.STEAL_RANGE = result.stealRadius or CONFIG.STEAL_RANGE

            if radInput then
                radInput.Text = tostring(CONFIG.STEAL_RANGE)
            end

            if tonumber(result.configVersion) >= 2 and result.lockUI ~= nil then
                uiLocked = result.lockUI
            else
                uiLocked = false
            end

            mobileButtonsLocked = false

            if result.antiRagdollMode then
                antiRagdollMode = result.antiRagdollMode
            else
                antiRagdollMode = result.antiRagdoll and "v2" or "off"
            end

            antiDieEnabled = result.antiDieEnabled or false
            antiBatEnabled = result.antiBat or false
            antiFlingEnabled = result.antiFling or false
            selectedStealMode = result.selectedStealMode == "V2" and "V2" or "V1"

            if selectedStealMode == "V2" then
                CONFIG.STEAL_RANGE = 60
                stealSettings.StealRadius = 60

                if radInput then
                    radInput.Text = "60"
                end
            end

            CONFIG.AUTO_STEAL_ENABLED = result.autoSteal or false
            medusaCounterEnabled = result.medusaCounter or false
            batCounterEnabled = result.batCounter or false
            batCounterV2Enabled = result.batCounterV2 or false
            unwalkEnabled = result.unwalkEnabled or result.unwalk or false
            antiLagEnabled = result.antiLag or false
            laggerToggled = result.laggerToggled or false
            speedMode = result.carryMode or false
            laggerCarryToggled = result.laggerCarryToggled or false
            uiScaleValue = clamp(tonumber(result.uiScale) or 78, 50, 150)

            if mainUIScale then
                mainUIScale.Scale = uiScaleValue / 100
            end

            if pbScale then
                pbScale.Scale = uiScaleValue / 100
            end

            isEspActive = result.espEnabled or false
            espLineEnabled = result.espLineEnabled or false

            if isEspActive then
                pcall(toggleESP, true)
            else
                pcall(toggleESP, false)
            end

            vividGraphicsEnabled = result.vividGraphics or false
            hideButtonsEnabled = result.hideButtons or false
            currentColorTheme = themeColors[result.themeColor] and result.themeColor or "Pink"
            selectedColor = themeColors[currentColorTheme]

            task.defer(function()
                updateAllUIThemeColors(selectedColor)
            end)

            if result.tpBatEnabled then
                task.defer(function()
                    pcall(function()
                        startBatDesyncTp()

                        if tpBat then
                            tpBat(true)
                        end

                        refreshTpBatButton(true)
                    end)
                end)
            else
                if tpBat then
                    tpBat(false)
                end

                refreshTpBatButton(false)
            end

            skyTheme = result.skyTheme or "Off"

            if skyTheme ~= "Off" then
                pcall(applyCustomSky, skyTheme)
            end

            if skySelectorLabel then
                skySelectorLabel.Text = skyTheme
            end

            if result.animPack and ANIM_PACKS[result.animPack] then
                pcall(applyAnimationPack, result.animPack)
            else
                currentAnimPack = "Off"
                resetAnimationPack()
            end

            local function applyKeybindEntry(target, enabled)
                if not enabled then
                    return
                end

                if enabled.kb and Enum.KeyCode[enabled.kb] then
                    target.kb = Enum.KeyCode[enabled.kb]
                end

                if enabled.gp and Enum.KeyCode[enabled.gp] then
                    target.gp = Enum.KeyCode[enabled.gp]
                end
            end

            applyKeybindEntry(KEYBINDS.DropBrainrot, result.dropBrainrotKey)
            applyKeybindEntry(KEYBINDS.AutoLeft, result.autoLeftKey)
            applyKeybindEntry(KEYBINDS.AutoRight, result.autoRightKey)
            applyKeybindEntry(KEYBINDS.AutoBat, result.autoBatKey)
            applyKeybindEntry(KEYBINDS.BatV2, result.batV2Key)
            applyKeybindEntry(KEYBINDS.TPFloor, result.tpFloorKey)
            applyKeybindEntry(KEYBINDS.GuiHide, result.guiHideKey)
            applyKeybindEntry(KEYBINDS.CarryToggle, result.carryToggleKey)
            applyKeybindEntry(KEYBINDS.LaggerMode, result.laggerModeKey)
            applyKeybindEntry(KEYBINDS.TPBat, result.tpBatKey)
            applyKeybindEntry(KEYBINDS.InstaReset, result.instaResetKey)

            if result.mobileButtonPositions then
                savedButtonPositions = result.mobileButtonPositions
            end

            if result.mobilePanelPos then
                savedMobilePanelPos = result.mobilePanelPos
            end

            if result.mainPosition and main then
                main.Position = UDim2.new(result.mainPosition.XScale or 0, result.mainPosition.XOffset or 20, result.mainPosition.YScale or 0, result.mainPosition.YOffset or 2)
            end

            if result.batV2FloatingPos then
                batV2FloatingPos = result.batV2FloatingPos
            end

            if result.tpBatFloatingPos then
                tpBatFloatingPos = result.tpBatFloatingPos
            end

            if result.instaResetFloatingPos then
                instaResetFloatingPos = result.instaResetFloatingPos
            end

            if result.progressBarPos then
                savedProgressBarPos = result.progressBarPos
            end

            if result.bodyLockEnabled ~= nil then
                bodyLockEnabled = result.bodyLockEnabled

                if bodyLockEnabled then
                    task.defer(function()
                        if bodyLockSetVisual then
                            bodyLockSetVisual(true)
                        end

                        startBodyLock()
                    end)
                end
            end

            if result.bodyLockRange then
                bodyLockRange = result.bodyLockRange

                if bodyLockRangeBox then
                    bodyLockRangeBox.Text = tostring(bodyLockRange)
                end
            end

            dropMode = result.dropMode or 1
            stretchEnabled = result.stretchEnabled or false
            stretchFOV = result.stretchFOV or 120
            BAT_AIMBOT_SPEED = result.batAimbotSpeed or BAT_AIMBOT_SPEED
            backgroundIndex = 1
            backgroundImageTransparency = result.backgroundImageTransparency or 0
            backgroundMode = result.backgroundMode == "None" and "None" or "Background 1"
            floatingButtonScale = result.floatingButtonScale or 1

            if result.outfitIndex and result.outfitIndex >= 1 and result.outfitIndex <= #outfitPresets then
                outfitIndex = result.outfitIndex

                task.defer(function()
                    pcall(function()
                        applyOutfitByIndex(outfitIndex)
                    end)

                    if textLabel then
                        textLabel.Text = outfitPresets[outfitIndex].label
                    end
                end)
            end

            if _G._youtStealModeSetter then
                task.defer(function()
                    _G._youtStealModeSetter(selectedStealMode)
                end)
            end

            if vividGraphicsEnabled then
                task.defer(function()
                    pcall(enableVividGraphics)
                end)
            else
                task.defer(function()
                    pcall(disableVividGraphics)
                end)
            end

            autoBatEnabled = false
            autoLeftEnabled = false
            autoRightEnabled = false

            if dropModeBtnRef then
                dropModeBtnRef.Text = dropMode == 1 and "Fling" or "Jump Drop"
            end

            refreshSpeedModeLabel()
            _lastSavedJSON = HttpService:JSONEncode(buildConfigTable())
            _isLoading = false
            return true
        end
    end

    forceResetUI = function()
        if normalBox then
            normalBox.Text = tostring(NORMAL_SPEED)
        end

        if carryBox then
            carryBox.Text = tostring(CARRY_SPEED)
        end

        if radInput then
            radInput.Text = tostring(CONFIG.STEAL_RANGE)
        end

        if laggerBox then
            laggerBox.Text = tostring(LAGGER_SPEED)
        end

        if lagger2Box then
            lagger2Box.Text = tostring(LAGGER_CARRY_SPEED)
        end

        if batSpeedBox then
            batSpeedBox.Text = tostring(BAT_AIMBOT_SPEED)
        end

        if uiScaleBox then
            uiScaleBox.Text = tostring(uiScaleValue)
        end

        if dropModeBtnRef then
            dropModeBtnRef.Text = dropMode == 1 and "Fling" or "Jump Drop"
        end

        if bodyLockRangeBox then
            bodyLockRangeBox.Text = tostring(bodyLockRange)
        end

        local function callIfPresent(callback, value)
            if callback then
                callback(value)
            end
        end

        callIfPresent(autoBatSetVisual, false)
        callIfPresent(autoLeftSetVisual, false)
        callIfPresent(autoRightSetVisual, false)
        callIfPresent(setBatCounterVisual, false)
        callIfPresent(setBatCounterV2Visual, false)
        callIfPresent(setMedusaVisual, false)
        callIfPresent(setUnwalkVisual, false)
        callIfPresent(setAntiLagVisual, false)
        callIfPresent(setLockUIVisual, false)
        callIfPresent(setInstaGrab, false)
        callIfPresent(tpBat, false)
        callIfPresent(setESPVIsual, false)
        callIfPresent(setESPLineVisual, false)
        callIfPresent(setVividVisual, false)
        callIfPresent(setHideButtonsVisual, false)
        callIfPresent(bodyLockSetVisual, false)
        callIfPresent(setAntiDieVisual, false)
        callIfPresent(setAntiBatVisual, false)
        callIfPresent(setAntiFlingVisual, false)
        callIfPresent(setAntiRagVisual, false)
        disableVividGraphics()
        applyHideButtons(false)

        if _G.stretchToggleSetter then
            _G.stretchToggleSetter(false)
        end

        callIfPresent(mobSetAutoBat, false)
        callIfPresent(mobSetAutoLeft, false)
        callIfPresent(mobSetAutoRight, false)
        callIfPresent(mobSetDropBR, false)
        callIfPresent(mobSetTpDown, false)
        callIfPresent(mobSetCarry, false)
        callIfPresent(mobSetLagger1, false)
        callIfPresent(mobSetLagger2, false)
        refreshSpeedModeLabel()
        updateProgressBarVisibility()
        disableAntiLag()

        if stopAntiBat then
            stopAntiBat()
        end

        if stopAntiFling then
            stopAntiFling()
        end

        if stopESPLine then
            stopESPLine()
        end

        skyTheme = "Off"
        pcall(applyCustomSky, "Off")

        if skySelectorLabel then
            skySelectorLabel.Text = "Off"
        end

        if antiDieEnabled then
            AntiDieModule.stop()
            antiDieEnabled = false
        end

        refreshTpBatButton(false)

        for _, keyButtonRef in ipairs(keyButtonRefs) do
            local entry = keyButtonRef.entry
            keyButtonRef.btn.Text = entry.gp and entry.gp.Name or entry.kb and entry.kb.Name or "None"
        end

        currentColorTheme = "Pink"
        selectedColor = themeColors["Pink"]
        updateAllUIThemeColors(selectedColor)

        if miniBtn then
            local uIStroke = miniBtn:FindFirstChildOfClass("UIStroke")

            if uIStroke then
                uIStroke.Color = Color3.fromRGB(42, 43, 47)
            end
        end

        if mobilePanel then
            for _, child in ipairs(mobilePanel:GetChildren()) do
                if child:IsA("TextButton") then
                    local textLabel2 = child:FindFirstChildOfClass("TextLabel")

                    if textLabel2 then
                        if not (child.BackgroundColor3 == selectedColor) then
                            textLabel2.TextColor3 = selectedColor
                        end
                    end
                end
            end
        end

        saveAllSettings()
    end

    resetFloatingPositions = function()
        if mobilePanel then
            savedButtonPositions = {}

            for _, child in ipairs(mobilePanel:GetChildren()) do
                if child:IsA("TextButton") and child.Name then
                    local defaultButtonPosition, value = getDefaultButtonPosition(child.Name)
                    child.Position = UDim2.new(0, defaultButtonPosition, 0, value)
                end
            end
        end

        if tpBatFloatingButton and tpBatFloatingButton:FindFirstChild("Frame") then
            tpBatFloatingButton:FindFirstChild("Frame").Position = UDim2.new(0.5, 20, 0, 10)
            tpBatFloatingPos = nil
        end

        if instaResetFloatingButton and instaResetFloatingButton:FindFirstChild("Frame") then
            instaResetFloatingButton.Frame.Position = UDim2.new(0.5, 90, 0, 10)
            instaResetFloatingPos = nil
        end

        if pbFrame then
            pbFrame.Position = UDim2.new(0.5, -172, 0.8, 0)
            savedProgressBarPos = nil
        end

        savedMobilePanelPos = nil
        tpBatFloatingPos = nil
    end

    resetToFactoryDefaults = function()
        _isResetting = true

        local success, result = pcall(function()
            stopAutoSteal()
            stopBatCounter()
            stopBatCounterV2()
            stopMedusaCounter()

            if antiRagdollState.Enabled then
                stopAntiRagdoll()
            end

            if antiDieEnabled then
                AntiDieModule.stop()
            end

            if antiBatEnabled and stopAntiBat then
                stopAntiBat()
            end

            if antiFlingEnabled and stopAntiFling then
                stopAntiFling()
            end

            stopUnwalk()
            disableAutoBat()

            if batDesyncTpEnabled then
                stopBatDesyncTp()
            end

            stopBodyLock()

            if isEspActive then
                toggleESP(false)
            end

            if espLineEnabled and stopESPLine then
                stopESPLine()
            end

            if stretchEnabled then
                disableStretch()
            end

            if antiLagEnabled then
                disableAntiLag()
            end

            if vividGraphicsEnabled then
                disableVividGraphics()
            end

            if hideButtonsEnabled then
                applyHideButtons(false)
            end

            if dropActive then
                stopDropBrainrot()
            end

            skyTheme = "Off"
            pcall(applyCustomSky, "Off")

            if skySelectorLabel then
                skySelectorLabel.Text = "Off"
            end

            if antiDieEnabled then
                AntiDieModule.stop()
                antiDieEnabled = false
            end

            NORMAL_SPEED = 60
            CARRY_SPEED = 29
            LAGGER_SPEED = 15
            LAGGER_CARRY_SPEED = 24.5
            CONFIG.STEAL_RANGE = 61
            speedMode = false
            laggerToggled = false
            laggerCarryToggled = false
            antiRagdollMode = "off"
            antiDieEnabled = false
            antiBatEnabled = false
            antiFlingEnabled = false
            medusaCounterEnabled = false
            batCounterEnabled = false
            batCounterV2Enabled = false
            autoBatEnabled = false
            autoLeftEnabled = false
            autoRightEnabled = false
            unwalkEnabled = false
            antiLagEnabled = false
            uiLocked = false
            mobileButtonsLocked = false
            CONFIG.AUTO_STEAL_ENABLED = false
            selectedStealMode = "V1"

            if _G._youtStealModeSetter then
                pcall(_G._youtStealModeSetter, "V1")
            end

            BAT_AIMBOT_SPEED = 58
            dropMode = 1
            stretchEnabled = false
            stretchFOV = 120
            uiScaleValue = 78

            if mainUIScale then
                mainUIScale.Scale = 1
            end

            if pbScale then
                pbScale.Scale = 1
            end

            isEspActive = false
            espLineEnabled = false
            vividGraphicsEnabled = false
            hideButtonsEnabled = false
            bodyLockEnabled = false
            bodyLockRange = 20
            backgroundIndex = 1
            backgroundImageTransparency = 0
            backgroundMode = "Background 1"
            floatingButtonScale = 1

            if batDesyncTpEnabled then
                stopBatDesyncTp()
            end

            currentAnimPack = "Off"
            resetAnimationPack()
            outfitIndex = 1
            currentColorTheme = "Pink"
            selectedColor = themeColors.Pink

            if main then
                main.Position = UDim2.new(0, 20, 0, 2)
                _G.__YoutMainOriginalPos = main.Position
            end

            for entry, entry2 in pairs(DEFAULT_KEYBINDS) do
                if KEYBINDS[entry] then
                    KEYBINDS[entry].kb = entry2.kb
                    KEYBINDS[entry].gp = entry2.gp
                end
            end

            resetFloatingPositions()
            forceResetUI()
            updateProgressBarVisibility()
            refreshSpeedModeLabel()
            _lastSavedJSON = nil
        end)

        _isResetting = false

        if success then
            saveAllSettings(true)
        end

        return success
    end

    updateProgressBarVisibility = function()
        if pbFrame then
            pbFrame.Visible = CONFIG.AUTO_STEAL_ENABLED
        end
    end

    applyShimmerToText = function(parent, value)
        local amount = value or 0.8
        local instance = Instance.new("UIGradient", parent)

        instance.Color = ColorSequence.new({

            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 70, 160)),

            ColorSequenceKeypoint.new(0.3, Color3.fromRGB(255, 230, 240)),

            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),

            ColorSequenceKeypoint.new(0.7, Color3.fromRGB(255, 230, 240)),

            ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 70, 160)),

        })
        instance.Rotation = 45
        instance.Offset = Vector2.new(0, 0)

        task.spawn(function()
            local counter = 0

            while instance and instance.Parent do
                counter += 0.02

                instance.Offset = Vector2.new(math.sin(counter * amount) * 0.4, 0)
                task.wait(0.04)
            end
        end)

        return instance
    end

    getDefaultButtonPosition = function(index)
        local amount = ({
            DropBR = 0,
            AutoLeft = 1,
            AutoBat = 2,
            AutoRight = 3,
            TpDown = 4,
            Carry = 5,
            Lagger1 = 6,
            Lagger2 = 7,
        })[index] or 0

        return amount % 2 * (60 + 7), floor(amount / 2) * 54
    end

    if not _G.InstaResetLoaded then
        local performInstaReset

        do
            _G.InstaResetLoaded = true

            do
                local youtInstaResetState = _G._YoutInstaResetState

                if type(youtInstaResetState) ~= "table" then
                    youtInstaResetState = {
                        busy = false,
                        busyAt = 0,
                        token = 0,
                        cameraConn = nil,
                        cameraHeld = false,
                        cameraHeldAt = 0,
                        speed = 1000000,
                        wantAntiDie = nil,
                        wantAntiBat = nil,
                        wantTpBatDie = nil,
                    }

                    _G._YoutInstaResetState = youtInstaResetState
                end

                local function suspendAntiDie()
                    if _antiDieEnabled then
                        youtInstaResetState.wantAntiDie = true

                        pcall(function()
                            _antiDieSetEnabled(false)
                        end)
                    end

                    if AntiDieModule and AntiDieModule.enabled then
                        youtInstaResetState.wantAntiDie = true

                        pcall(function()
                            AntiDieModule.stop()
                        end)
                    end

                    if antiBatEnabled then
                        youtInstaResetState.wantAntiBat = true
                        pcall(stopAntiBat)
                    end

                    if _G._AdaptTpBatAntiDie and _G._VynxTPBatOn then
                        youtInstaResetState.wantTpBatDie = true
                        pcall(_G._AdaptTpBatAntiDie.stop)
                    end
                end

                local function resumeAntiDie()
                    if youtInstaResetState.wantAntiDie then
                        youtInstaResetState.wantAntiDie = nil

                        pcall(function()
                            antiDieEnabled = true

                            if AntiDieModule then
                                AntiDieModule.start()
                            end

                            if _antiDieSetEnabled then
                                _antiDieSetEnabled(true)
                            end
                        end)
                    end

                    if youtInstaResetState.wantAntiBat then
                        youtInstaResetState.wantAntiBat = nil

                        pcall(function()
                            if antiBatEnabled then
                                startAntiBat()
                            end
                        end)
                    end

                    if youtInstaResetState.wantTpBatDie and _G._AdaptTpBatAntiDie and _G._VynxTPBatOn then
                        youtInstaResetState.wantTpBatDie = nil
                        pcall(_G._AdaptTpBatAntiDie.start)
                    end
                end

                local function restoreCameraAfterReset(target)
                    local currentCamera = workspace.CurrentCamera
                    if not currentCamera then
                        return
                    end
                    local cameraHeld = youtInstaResetState.cameraHeld

                    if cameraHeld then
                        cameraHeld = os.clock() - (youtInstaResetState.cameraHeldAt or 0) < 5
                    end

                    if cameraHeld then
                        return
                    end
                    youtInstaResetState.cameraHeld = true
                    youtInstaResetState.cameraHeldAt = os.clock()
                    local cFrame = currentCamera.CFrame
                    local focus = currentCamera.Focus

                    pcall(function()
                        currentCamera.CameraType = Enum.CameraType.Scriptable
                        currentCamera.CFrame = cFrame
                        currentCamera.Focus = focus
                    end)

                    youtInstaResetState.cameraConn = RunService.RenderStepped:Connect(function()
                        if workspace.CurrentCamera ~= currentCamera then
                            return
                        end
                        currentCamera.CameraType = Enum.CameraType.Scriptable
                        currentCamera.CFrame = cFrame
                        currentCamera.Focus = focus
                    end)

                    task.spawn(function()
                        local counter = 0

                        while localPlayer.Character == target and counter < 3 do
                            counter += task.wait()
                        end

                        if youtInstaResetState.cameraConn then
                            pcall(function()
                                youtInstaResetState.cameraConn:Disconnect()
                            end)

                            youtInstaResetState.cameraConn = nil
                        end

                        youtInstaResetState.cameraHeld = false
                        local currentCamera2 = workspace.CurrentCamera or currentCamera

                        if currentCamera2 then
                            pcall(function()
                                currentCamera2.CameraType = Enum.CameraType.Custom
                                local character = localPlayer.Character
                                character = character and character:FindFirstChildOfClass("Humanoid")

                                if character then
                                    currentCamera2.CameraSubject = character
                                end
                            end)
                        end
                    end)
                end

                local function prepareResetRoot(instance)
                    local child = instance and instance:FindFirstChild("HumanoidRootPart")
                    if not (child and child:IsA("BasePart")) then
                        return false
                    end
                    local humanoid = instance:FindFirstChildOfClass("Humanoid")

                    if humanoid then
                        pcall(function()
                            humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, true)
                            humanoid.BreakJointsOnDeath = true
                            humanoid.PlatformStand = true
                            humanoid:ChangeState(Enum.HumanoidStateType.Freefall)
                        end)
                    end

                    local vector2 = Vector3.new(0, math.clamp(youtInstaResetState.speed, 1000, 10000000), 0)

                    local function zeroRootVelocity()
                        if not child.Parent then
                            return false
                        end

                        return pcall(function()
                            child.AssemblyAngularVelocity = Vector3.zero
                            child.AssemblyLinearVelocity = vector2
                        end)
                    end

                    if not zeroRootVelocity() then
                        return false
                    end

                    task.spawn(function()
                        local counter = 0

                        while counter < 1.5 do
                            counter += RunService.Heartbeat:Wait()
                            if not child.Parent then
                                return
                            end

                            if localPlayer.Character ~= instance then
                                return
                            end
                            zeroRootVelocity()
                        end
                    end)

                    return true
                end

                local function restoreHumanoidStates(instance)
                    local humanoid = instance and instance:FindFirstChildOfClass("Humanoid")
                    if not humanoid then
                        return
                    end

                    pcall(function()
                        humanoid.PlatformStand = false
                        humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, true)
                        humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, true)
                        humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
                        humanoid.BreakJointsOnDeath = true

                        if humanoid.MaxHealth == math.huge or humanoid.MaxHealth <= 0 then
                            humanoid.MaxHealth = 100
                        end

                        humanoid.Health = 0
                    end)

                    pcall(function()
                        instance:BreakJoints()
                    end)
                end

                performInstaReset = function()
                    local character = localPlayer.Character
                    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
                    local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
                    if not (character and humanoid and humanoidRootPart and humanoidRootPart:IsA("BasePart")) then
                        return
                    end
                    local busy = youtInstaResetState.busy

                    if busy then
                        busy = os.clock() - (youtInstaResetState.busyAt or 0) < 5
                    end

                    if busy then
                        return
                    end
                    youtInstaResetState.busy = true
                    youtInstaResetState.busyAt = os.clock()
                    youtInstaResetState.token = (youtInstaResetState.token or 0) + 1
                    local token = youtInstaResetState.token
                    suspendAntiDie()

                    task.spawn(function()
                        restoreCameraAfterReset(character)

                        if not prepareResetRoot(character) then
                            restoreHumanoidStates(character)
                        end

                        local counter = 0

                        while localPlayer.Character == character and counter < 1.2 do
                            counter += task.wait()
                        end

                        if localPlayer.Character == character then
                            local humanoid = character:FindFirstChildOfClass("Humanoid")

                            if humanoid and humanoid.Health > 0 then
                                restoreHumanoidStates(character)
                            end
                        end

                        local counter = 0

                        while localPlayer.Character == character and counter < 8 do
                            counter += task.wait()
                        end

                        if youtInstaResetState.token ~= token then
                            return
                        end
                        youtInstaResetState.busy = false
                        resumeAntiDie()
                    end)
                end

                RunService.Heartbeat:Connect(function()
                    if not youtInstaResetState.wantAntiDie then
                        return
                    end
                    local busy = youtInstaResetState.busy

                    if busy then
                        busy = os.clock() - (youtInstaResetState.busyAt or 0) < 10
                    end

                    if busy then
                        if _antiDieEnabled then
                            pcall(function()
                                _antiDieSetEnabled(false)
                            end)
                        end

                        if AntiDieModule and AntiDieModule.enabled then
                            pcall(function()
                                AntiDieModule.stop()
                            end)
                        end

                        return
                    end

                    if os.clock() - (youtInstaResetState.busyAt or 0) >= 10 then
                        youtInstaResetState.busy = false
                        resumeAntiDie()
                    end
                end)

                localPlayer.CharacterAdded:Connect(function()
                    youtInstaResetState.cameraHeld = false

                    if youtInstaResetState.cameraConn then
                        pcall(function()
                            youtInstaResetState.cameraConn:Disconnect()
                        end)

                        youtInstaResetState.cameraConn = nil
                    end
                end)
            end
        end

        do
            local counter = 0

            _G.InstaReset = { Trigger = function()
                local now = os.clock()
                if now - counter < 0.15 then
                    return
                end
                counter = now
                performInstaReset()
            end }
        end

        _G.VynxDoInstaReset = _G.InstaReset.Trigger
    end

    buildGui = function()
        Color3.fromRGB(10, 10, 10)
        Color3.fromRGB(50, 50, 50)
        local color2 = Color3.fromRGB(255, 255, 255)
        local color3 = Color3.fromRGB(15, 15, 15)

        local success, result = pcall(function()
            return game:GetService("CoreGui")
        end)

        local playerGui = localPlayer:FindFirstChild("PlayerGui")

        for _, value in ipairs({
            "Yout",
            "YoutMobilePanel",
            "TpBatButton",
            "InstaResetButton",
            "YoutSpeedIndicator",
            "YoutBootErrors",
        }) do
            if success and result then
                local success, result2 = pcall(function()
                    return result:FindFirstChild(value)
                end)

                if success and result2 then
                    pcall(function()
                        result2:Destroy()
                    end)
                end
            end

            if playerGui then
                local success, result = pcall(function()
                    return playerGui:FindFirstChild(value)
                end)

                if success and result then
                    pcall(function()
                        result:Destroy()
                    end)
                end
            end
        end

        gui = Instance.new("ScreenGui")
        gui.Name = "Yout"
        gui.ResetOnSpawn = false
        gui.DisplayOrder = 10
        gui.IgnoreGuiInset = true

        pcall(function()
            if syn and syn.protect_gui then
                syn.protect_gui(gui)
            end
        end)

        if not pcall(function()
            gui.Parent = game:GetService("CoreGui")
            end) then
            gui.Parent = localPlayer:WaitForChild("PlayerGui")
        end

        main = Instance.new("Frame", gui)
        main.Size = UDim2.new(0, 348, 0, 468)
        main.Position = UDim2.new(0, 20, 0, 2)
        main.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        main.BackgroundTransparency = 1
        main.BorderSizePixel = 0
        main.ClipsDescendants = true
        Instance.new("UICorner", main).CornerRadius = UDim.new(0, 18)
        local frame = Instance.new("Frame", main)
        frame.Name = "ScriptHeader"
        frame.Size = UDim2.new(1, -54, 0, 76)
        frame.Position = UDim2.new(0, 10, 0, 2)
        frame.BackgroundTransparency = 1
        frame.BorderSizePixel = 0
        frame.ZIndex = 80
        local instance = Instance.new("Frame", frame)
        instance.Name = "LogoArea"
        instance.Size = UDim2.new(1, -56, 0, 72)
        instance.Position = UDim2.new(0, 0, 0, 2)
        instance.BackgroundTransparency = 1
        instance.BorderSizePixel = 0
        instance.ZIndex = 80
        local imageLabel = Instance.new("ImageLabel", instance)
        imageLabel.Name = "ScriptLogo"
        imageLabel.AnchorPoint = Vector2.new(0, 0.5)
        imageLabel.Position = UDim2.new(0.5, -72, 0.5, 0)
        imageLabel.Size = UDim2.new(0, 300, 0, 58)
        imageLabel.BackgroundTransparency = 1
        imageLabel.ImageTransparency = 0
        imageLabel.ScaleType = Enum.ScaleType.Fit
        imageLabel.ImageColor3 = Color3.fromRGB(255, 255, 255)
        imageLabel.ZIndex = 81
        applyImageAsset(imageLabel, "96857354857122")
        local imageLabel = Instance.new("ImageLabel", main)
        imageLabel.Name = "BackgroundImage"
        imageLabel.Size = UDim2.new(1, 0, 1, 0)
        imageLabel.Position = UDim2.new(0, 0, 0, 0)
        imageLabel.BackgroundColor3 = Color3.fromRGB(3, 3, 5)
        imageLabel.BackgroundTransparency = 0
        imageLabel.ImageTransparency = 0
        imageLabel.ScaleType = Enum.ScaleType.Crop
        imageLabel.ZIndex = 1
        applyImageAsset(imageLabel, backgroundImages[backgroundIndex])
        imageLabel.ClipsDescendants = true
        Instance.new("UICorner", imageLabel).CornerRadius = UDim.new(0, 18)
        mainUIScale = Instance.new("UIScale", main)
        mainUIScale.Scale = uiScaleValue / 100
        local textButton = Instance.new("TextButton", main)
        textButton.Size = UDim2.new(0, 32, 0, 32)
        textButton.Position = UDim2.new(1, -42, 0, 14)
        textButton.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
        textButton.BackgroundTransparency = 1
        textButton.BorderSizePixel = 0
        textButton.Text = "-"
        textButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        textButton.Font = Enum.Font.GothamBold
        textButton.TextSize = 30
        textButton.AutoButtonColor = false
        textButton.ZIndex = 200

        textButton.MouseEnter:Connect(function()
            TweenService:Create(textButton, TweenInfo.new(0.12), { TextColor3 = getThemeColor() }):Play()
        end)

        textButton.MouseLeave:Connect(function()
            TweenService:Create(textButton, TweenInfo.new(0.12), { TextColor3 = Color3.fromRGB(255, 255, 255) }):Play()
        end)

        miniBtn = Instance.new("TextButton", gui)
        miniBtn.Name = "MinimizedFrame"
        miniBtn.Size = UDim2.new(0, 112, 0, 30)
        miniBtn.Position = UDim2.new(0, 18, 0, 60)
        miniBtn.BackgroundColor3 = Color3.fromRGB(12, 12, 16)
        miniBtn.BackgroundTransparency = 0.02
        miniBtn.BorderSizePixel = 0
        miniBtn.Text = "Y/OUT"
        miniBtn.TextColor3 = Color3.fromRGB(235, 235, 240)
        miniBtn.Font = Enum.Font.GothamBold
        miniBtn.TextSize = 14
        miniBtn.AutoButtonColor = false
        miniBtn.ZIndex = 20
        miniBtn.Visible = false
        Instance.new("UICorner", miniBtn).CornerRadius = UDim.new(0, 9)
        local isActive = false
        local position = main.Position
        _G.__YoutMainOriginalPos = position

        main:GetPropertyChangedSignal("Position"):Connect(function()
            if not isActive then
                position = main.Position
                _G.__YoutMainOriginalPos = position
            end
        end)

        local uiScale = Instance.new("UIScale", main)
        uiScale.Scale = 1
        local tween = nil
        local tween2 = nil

        showGui = function()
            if not main then
                return
            end

            if tween then
                tween:Cancel()
            end

            if tween2 then
                tween2:Cancel()
            end

            isActive = true
            main.Visible = true
            miniBtn.Visible = false
            main.Position = UDim2.new(position.X.Scale, position.X.Offset - 60, position.Y.Scale, position.Y.Offset)
            uiScale.Scale = 0.5
            local data = { Position = position }
            tween = TweenService:Create(main, TweenInfo.new(0.45, Enum.EasingStyle.Back, Enum.EasingDirection.Out), data)
            TweenService:Create(uiScale, TweenInfo.new(0.45, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Scale = 1 }):Play()
            tween:Play()

            tween.Completed:Connect(function()
                tween = nil
                isActive = false
            end)
        end

        hideGui = function()
            if not main or not main.Visible then
                return
            end

            if tween then
                tween:Cancel()
            end

            if tween2 then
                tween2:Cancel()
            end

            isActive = true

            tween2 = TweenService:Create(main, TweenInfo.new(0.28, Enum.EasingStyle.Quad, Enum.EasingDirection.In), { Position = UDim2.new(position.X.Scale, position.X.Offset - 60, position.Y.Scale, position.Y.Offset) })
            TweenService:Create(uiScale, TweenInfo.new(0.28, Enum.EasingStyle.Quad, Enum.EasingDirection.In), { Scale = 0.5 }):Play()
            tween2:Play()

            tween2.Completed:Connect(function()
                main.Visible = false
                miniBtn.Visible = true
                tween2 = nil
                isActive = false
            end)
        end

        textButton.MouseButton1Click:Connect(hideGui)
        miniBtn.MouseButton1Click:Connect(showGui)
        tabButtons = {}
        local entries = {}
        local scrollingFrame = Instance.new("ScrollingFrame", main)
        scrollingFrame.Name = "YoutBottomTabs"
        scrollingFrame.AnchorPoint = Vector2.new(0, 1)
        scrollingFrame.Position = UDim2.new(0, 8, 1, -8)
        scrollingFrame.Size = UDim2.new(1, -16, 0, 46)
        scrollingFrame.BackgroundColor3 = Color3.fromRGB(7, 7, 9)
        scrollingFrame.BackgroundTransparency = 0.16
        scrollingFrame.BorderSizePixel = 0
        scrollingFrame.ScrollBarThickness = 0
        scrollingFrame.ScrollBarImageTransparency = 1
        scrollingFrame.ScrollingDirection = Enum.ScrollingDirection.X
        scrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.X
        scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
        scrollingFrame.ElasticBehavior = Enum.ElasticBehavior.WhenScrollable
        scrollingFrame.ClipsDescendants = true
        scrollingFrame.ZIndex = 20
        Instance.new("UICorner", scrollingFrame).CornerRadius = UDim.new(0, 13)
        local instance = Instance.new("UIStroke", scrollingFrame)
        instance.Color = Color3.fromRGB(70, 70, 80)
        instance.Transparency = 0.52
        instance.Thickness = 1
        local uiListLayout = Instance.new("UIListLayout", scrollingFrame)
        uiListLayout.FillDirection = Enum.FillDirection.Horizontal
        uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
        uiListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
        uiListLayout.Padding = UDim.new(0, 6)
        local uiPadding = Instance.new("UIPadding", scrollingFrame)
        uiPadding.PaddingLeft = UDim.new(0, 7)
        uiPadding.PaddingRight = UDim.new(0, 7)
        uiPadding.PaddingTop = UDim.new(0, 5)
        uiPadding.PaddingBottom = UDim.new(0, 5)
        local frame = Instance.new("Frame", main)
        frame.Name = "YoutTabContent"
        frame.Size = UDim2.new(1, -14, 1, -137)
        frame.Position = UDim2.new(0, 7, 0, 78)
        frame.BackgroundTransparency = 1
        frame.ClipsDescendants = true
        frame.ZIndex = 5

        local data = {
            Moment = "Movement",
            Main = "Main",
            Combat = "Combat",
            Visuals = "Visuals",
            Settings = "Settings",
            Keybinds = "Keybinds",
        }

        local instance = setmetatable({}, { __mode = "k" })

        local function addShineEffect(instance2, enabled)
            if not instance2 then
                return
            end
            instance2.ClipsDescendants = true
            local animatedWhiteShine = instance2:FindFirstChild("AnimatedWhiteShine")

            if not animatedWhiteShine then
                animatedWhiteShine = Instance.new("Frame", instance2)
                animatedWhiteShine.Name = "AnimatedWhiteShine"
                animatedWhiteShine.AnchorPoint = Vector2.new(0.5, 0.5)
                animatedWhiteShine.Size = UDim2.new(0, 18, 0.82, 0)
                animatedWhiteShine.Position = UDim2.new(-0.1, 0, 0.5, 0)
                animatedWhiteShine.Rotation = 20
                animatedWhiteShine.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                animatedWhiteShine.BackgroundTransparency = 0.22
                animatedWhiteShine.BorderSizePixel = 0
                animatedWhiteShine.ZIndex = 21
                animatedWhiteShine.Visible = false
                local uiGradient = Instance.new("UIGradient", animatedWhiteShine)

                uiGradient.Color = ColorSequence.new({

                    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),

                    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),

                    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255)),

                })

                uiGradient.Transparency = NumberSequence.new({

                    NumberSequenceKeypoint.new(0, 1),

                    NumberSequenceKeypoint.new(0.35, 0.92),

                    NumberSequenceKeypoint.new(0.5, 0.42),

                    NumberSequenceKeypoint.new(0.65, 0.92),

                    NumberSequenceKeypoint.new(1, 1),

                })
            end

            local entry = instance[animatedWhiteShine]

            if entry then
                entry.alive = false
                instance[animatedWhiteShine] = nil
            end

            animatedWhiteShine.Visible = enabled == true
            animatedWhiteShine:SetAttribute("ShineEnabled", enabled == true)

            if enabled then
                local data2 = { alive = true }
                instance[animatedWhiteShine] = data2

                task.spawn(function()
                    while true do
                        local parent = data2.alive and animatedWhiteShine and animatedWhiteShine.Parent

                        if parent then
                            parent = animatedWhiteShine:GetAttribute("ShineEnabled") == true
                        end

                        if parent then
                            animatedWhiteShine.Position = UDim2.new(-0.1, 0, 0.5, 0)
                            animatedWhiteShine.BackgroundTransparency = 0.22
                            local tween = TweenService:Create(animatedWhiteShine, TweenInfo.new(0.95, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), { Position = UDim2.new(1.1, 0, 0.5, 0) })
                            tween:Play()
                            tween.Completed:Wait()
                            if not (not data2.alive or not animatedWhiteShine or not animatedWhiteShine.Parent or animatedWhiteShine:GetAttribute("ShineEnabled") ~= true) then
                                task.wait(0.16)
                                continue
                            end
                        end

                        break
                    end
                end)
            end
        end

        local function updateTabAppearance(instance, enabled)
            local underline = instance:FindFirstChild("Underline")
            local tabSurface = instance:FindFirstChild("TabSurface")
            local tabStroke = tabSurface and tabSurface:FindFirstChild("TabStroke")
            local tabBgGrad = tabSurface and tabSurface:FindFirstChild("TabBgGrad")

            if underline then
                underline.Visible = enabled == true
                underline.BackgroundColor3 = enabled and Color3.fromRGB(255, 242, 249) or Color3.fromRGB(245, 245, 248)
            end

            instance.BackgroundTransparency = 1
            instance.TextColor3 = Color3.fromRGB(255, 255, 255)
            instance.TextTransparency = 0

            if tabSurface then
                tabSurface.BackgroundColor3 = enabled and Color3.fromRGB(255, 72, 170) or Color3.fromRGB(12, 12, 15)
                tabSurface.BackgroundTransparency = enabled and 0 or 0.12
                addShineEffect(tabSurface, enabled)
            end

            if tabStroke then
                tabStroke.Color = enabled and Color3.fromRGB(255, 170, 214) or Color3.fromRGB(105, 105, 116)
                tabStroke.Transparency = enabled and 0.18 or 0.4
                tabStroke.Thickness = enabled and 1.2 or 1
            end

            if tabBgGrad then
                applyThemeGradient(tabBgGrad, false)
                tabBgGrad.Offset = Vector2.new(0, 0)

                if enabled then
                    tabBgGrad.Color = ColorSequence.new({
                        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 168, 214)),
                        ColorSequenceKeypoint.new(0.24, Color3.fromRGB(255, 88, 184)),
                        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 48, 155)),
                        ColorSequenceKeypoint.new(0.76, Color3.fromRGB(255, 104, 186)),
                        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 176, 219)),
                    })
                    tabBgGrad.Rotation = 90
                else
                    tabBgGrad.Color = ColorSequence.new({
                        ColorSequenceKeypoint.new(0, Color3.fromRGB(38, 38, 44)),
                        ColorSequenceKeypoint.new(1, Color3.fromRGB(13, 13, 17)),
                    })
                    tabBgGrad.Rotation = 0
                end
            end
        end

        for index, value in ipairs({ "Moment", "Main", "Combat", "Visuals", "Settings", "Keybinds" }) do
            local textButton = Instance.new("TextButton", scrollingFrame)
            textButton.Name = value .. "Tab"
            textButton.Size = UDim2.new(0, 92, 1, -10)
            textButton.BackgroundColor3 = Color3.fromRGB(12, 12, 15)
            textButton.BackgroundTransparency = 1
            textButton.BorderSizePixel = 0
            textButton.Text = data[value] or value
            textButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            textButton.TextTransparency = 0
            textButton.Font = Enum.Font.GothamBold
            textButton.TextSize = 10
            textButton.AutoButtonColor = false
            textButton.LayoutOrder = index
            textButton.ZIndex = 21
            textButton.ClipsDescendants = true
            Instance.new("UICorner", textButton).CornerRadius = UDim.new(0, 9)
            local instance = Instance.new("Frame", textButton)
            instance.Name = "TabSurface"
            instance.Size = UDim2.new(1, 0, 1, 0)
            instance.Position = UDim2.new(0, 0, 0, 0)
            instance.BackgroundColor3 = Color3.fromRGB(12, 12, 15)
            instance.BackgroundTransparency = 0.12
            instance.BorderSizePixel = 0
            instance.ClipsDescendants = true
            instance.Active = false
            instance.ZIndex = 20
            Instance.new("UICorner", instance).CornerRadius = UDim.new(0, 9)
            local uiGradient = Instance.new("UIGradient", instance)
            uiGradient.Name = "TabBgGrad"

            uiGradient.Color = ColorSequence.new({

                ColorSequenceKeypoint.new(0, Color3.fromRGB(38, 38, 44)),

                ColorSequenceKeypoint.new(1, Color3.fromRGB(13, 13, 17)),

            })
            uiGradient.Rotation = 0
            local uiStroke = Instance.new("UIStroke", instance)
            uiStroke.Name = "TabStroke"
            uiStroke.Color = Color3.fromRGB(105, 105, 116)
            uiStroke.Transparency = 0.4
            uiStroke.Thickness = 1
            local frame2 = Instance.new("Frame", textButton)
            frame2.Name = "Underline"
            frame2.AnchorPoint = Vector2.new(0.5, 1)
            frame2.Size = UDim2.new(0.48, 0, 0, 2)
            frame2.Position = UDim2.new(0.5, 0, 1, -3)
            frame2.BackgroundColor3 = getThemeColor()
            frame2.BorderSizePixel = 0
            frame2.Visible = false
            frame2.ZIndex = 22
            Instance.new("UICorner", frame2).CornerRadius = UDim.new(1, 0)
            local scrollingFrame = Instance.new("ScrollingFrame", frame)
            scrollingFrame.Name = value .. "Page"
            scrollingFrame.Size = UDim2.new(1, 0, 1, 0)
            scrollingFrame.Position = UDim2.new(0, 0, 0, 0)
            scrollingFrame.BackgroundColor3 = Color3.fromRGB(6, 6, 8)
            scrollingFrame.BackgroundTransparency = 0.62
            scrollingFrame.BorderSizePixel = 0
            scrollingFrame.ClipsDescendants = true
            scrollingFrame.ScrollBarThickness = 0
            scrollingFrame.ScrollBarImageTransparency = 1
            scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
            scrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
            scrollingFrame.ScrollingDirection = Enum.ScrollingDirection.Y
            scrollingFrame.ZIndex = 6
            scrollingFrame.Visible = index == 1
            Instance.new("UICorner", scrollingFrame).CornerRadius = UDim.new(0, 14)
            local uiListLayout = Instance.new("UIListLayout", scrollingFrame)
            uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
            uiListLayout.Padding = UDim.new(0, 7)
            uiListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
            local uiPadding = Instance.new("UIPadding", scrollingFrame)
            uiPadding.PaddingLeft = UDim.new(0, 7)
            uiPadding.PaddingRight = UDim.new(0, 7)
            uiPadding.PaddingTop = UDim.new(0, 7)
            uiPadding.PaddingBottom = UDim.new(0, 12)
            entries[value] = scrollingFrame

            textButton.Activated:Connect(function()
                for _, entry in pairs(entries) do
                    entry.Visible = false
                end

                scrollingFrame.Visible = true
                scrollingFrame.Position = UDim2.fromOffset(0, 5)
                TweenService:Create(scrollingFrame, TweenInfo.new(0.18, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), { Position = UDim2.fromOffset(0, 0) }):Play()

                for _, tabButton in ipairs(tabButtons) do
                    updateTabAppearance(tabButton, tabButton == textButton)
                end
            end)

            textButton.MouseEnter:Connect(function()
                if frame2.Visible then
                    return
                end
                TweenService:Create(textButton, TweenInfo.new(0.12), { BackgroundTransparency = 0.06, TextColor3 = Color3.fromRGB(225, 225, 232) }):Play()
            end)

            textButton.MouseLeave:Connect(function()
                if frame2.Visible then
                    return
                end
                TweenService:Create(textButton, TweenInfo.new(0.12), { BackgroundTransparency = 0.18, TextColor3 = Color3.fromRGB(160, 160, 172) }):Play()
            end)

            table.insert(tabButtons, textButton)
        end

        for tabButton, tabButton2 in ipairs(tabButtons) do
            updateTabAppearance(tabButton2, tabButton == 1)
        end

        local entries2 = {}

        local function nextLayoutOrder(index)
            if not entries2[index] then
                entries2[index] = 0
            end

            entries2[index] = entries2[index] + 1
            return entries2[index]
        end

        local function createFrame(parent, value)
            local frame = Instance.new("Frame", parent)
            frame.Size = UDim2.new(1, 0, 0, 27)
            frame.BackgroundTransparency = 1
            frame.BorderSizePixel = 0
            frame.LayoutOrder = nextLayoutOrder(parent)
            frame.ZIndex = 7
            local frame2 = Instance.new("Frame", frame)
            frame2.Name = "SectAccent"
            frame2.Size = UDim2.new(0, 3, 0, 14)
            frame2.Position = UDim2.new(0, 3, 0.5, -7)
            frame2.BorderSizePixel = 0
            frame2.BackgroundColor3 = color
            frame2.ZIndex = 8
            Instance.new("UICorner", frame2).CornerRadius = UDim.new(1, 0)
            local uiGradient = Instance.new("UIGradient", frame2)
            uiGradient.Name = "SectAccentGrad"
            uiGradient.Color = createThemeGradient()
            uiGradient.Rotation = 90
            applyThemeGradient(uiGradient, true, 90)
            local textLabel2 = Instance.new("TextLabel", frame)
            textLabel2.Size = UDim2.new(1, -22, 1, 0)
            textLabel2.Position = UDim2.new(0, 13, 0, 0)
            textLabel2.BackgroundTransparency = 1
            textLabel2.Text = value:upper()
            textLabel2.TextColor3 = Color3.fromRGB(255, 255, 255)
            textLabel2.Font = Enum.Font.GothamBlack
            textLabel2.TextSize = 10
            textLabel2.TextXAlignment = Enum.TextXAlignment.Left
            textLabel2.TextStrokeTransparency = 1
            textLabel2.ZIndex = 8
            local uiGradient = Instance.new("UIGradient", textLabel2)
            uiGradient.Name = "SectTextGrad"
            uiGradient.Color = createThemeGradient()
            uiGradient.Rotation = 0
            applyThemeGradient(uiGradient, true, 0)
            return frame
        end

        local function createFrame2(parent, value)
            local amount = math.max(tonumber(value) or 34, 32)
            local frame = Instance.new("Frame", parent)
            frame.Size = UDim2.new(1, -4, 0, amount)
            frame.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
            frame.BackgroundTransparency = 0.36
            frame.BorderSizePixel = 0
            frame.LayoutOrder = nextLayoutOrder(parent)
            frame.ZIndex = 7
            Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)
            local uiStroke = Instance.new("UIStroke", frame)
            uiStroke.Color = Color3.fromRGB(72, 72, 82)
            uiStroke.Thickness = 1
            uiStroke.Transparency = 0.62

            frame.MouseEnter:Connect(function()
                TweenService:Create(frame, TweenInfo.new(0.14), { BackgroundColor3 = Color3.fromRGB(27, 27, 32), BackgroundTransparency = 0.28 }):Play()
                TweenService:Create(uiStroke, TweenInfo.new(0.14), { Color = getThemeColor(), Transparency = 0.38 }):Play()
            end)

            frame.MouseLeave:Connect(function()
                TweenService:Create(frame, TweenInfo.new(0.14), { BackgroundColor3 = Color3.fromRGB(15, 15, 18), BackgroundTransparency = 0.36 }):Play()
                TweenService:Create(uiStroke, TweenInfo.new(0.14), { Color = Color3.fromRGB(72, 72, 82), Transparency = 0.62 }):Play()
            end)

            return frame
        end

        local function createTextLabel(parent, text)
            local textLabel2 = Instance.new("TextLabel", parent)
            textLabel2.Size = UDim2.new(1, -92, 1, 0)
            textLabel2.Position = UDim2.new(0, 10, 0, 0)
            textLabel2.BackgroundTransparency = 1
            textLabel2.Text = text
            textLabel2.TextColor3 = Color3.fromRGB(244, 244, 248)
            textLabel2.Font = Enum.Font.GothamBlack
            textLabel2.TextSize = 10
            textLabel2.TextXAlignment = Enum.TextXAlignment.Left
            textLabel2.TextTruncate = Enum.TextTruncate.AtEnd
            textLabel2.TextStrokeTransparency = 1
            textLabel2.ZIndex = 8
            return textLabel2
        end

        local function createSwitchTrack(parent, value)
            local frame = Instance.new("Frame", parent)
            frame.Name = "Track"
            frame.Size = UDim2.new(0, 34, 0, 18)
            frame.AnchorPoint = Vector2.new(0.5, 0.5)
            frame.Position = UDim2.new(1, -(value or 44), 0.5, 0)
            frame.BackgroundColor3 = Color3.fromRGB(214, 214, 220)
            frame.BackgroundTransparency = 0
            frame.BorderSizePixel = 0
            frame.ZIndex = 8
            Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 9)
            local uiGradient = Instance.new("UIGradient", frame)
            uiGradient.Name = "CleanToggleGradient"
            uiGradient.Rotation = 90

            uiGradient.Color = ColorSequence.new({

                ColorSequenceKeypoint.new(0, Color3.fromRGB(246, 246, 248)),

                ColorSequenceKeypoint.new(0.45, Color3.fromRGB(218, 218, 224)),

                ColorSequenceKeypoint.new(1, Color3.fromRGB(166, 168, 176)),

            })
            local uiStroke = Instance.new("UIStroke", frame)
            uiStroke.Name = "PillStroke"
            uiStroke.Color = Color3.fromRGB(150, 152, 160)
            uiStroke.Thickness = 1
            uiStroke.Transparency = 0.22
            local instance = Instance.new("Frame", frame)
            instance.Name = "Knob"
            instance.Size = UDim2.new(0, 13, 0, 13)
            instance.Position = UDim2.new(0, 3, 0.5, -6)
            instance.BackgroundColor3 = Color3.fromRGB(24, 24, 29)
            instance.BorderSizePixel = 0
            instance.ZIndex = 9
            Instance.new("UICorner", instance).CornerRadius = UDim.new(1, 0)
            return frame, instance
        end

        local function animateSwitch(instance, value, enabled)
            TweenService:Create(value, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Position = enabled and UDim2.new(1, -16, 0.5, -6) or UDim2.new(0, 3, 0.5, -6),
                BackgroundColor3 = enabled and Color3.fromRGB(250, 250, 252) or Color3.fromRGB(24, 24, 29),
            }):Play()

            local cleanToggleGradient = instance:FindFirstChild("CleanToggleGradient")

            if cleanToggleGradient then
                if enabled then
                    cleanToggleGradient.Color = createThemeGradient()
                    applyThemeGradient(cleanToggleGradient, true, 90)
                else
                    applyThemeGradient(cleanToggleGradient, false)

                    cleanToggleGradient.Color = ColorSequence.new({

                        ColorSequenceKeypoint.new(0, Color3.fromRGB(246, 246, 248)),

                        ColorSequenceKeypoint.new(0.55, Color3.fromRGB(218, 218, 224)),

                        ColorSequenceKeypoint.new(1, Color3.fromRGB(166, 168, 176)),

                    })
                end
            end

            local pillStroke = instance:FindFirstChild("PillStroke")

            if pillStroke then
                local value

                TweenService:Create(pillStroke, value, {
                    Color = enabled and Color3.fromRGB(255, 210, 232) or Color3.fromRGB(150, 152, 160),
                    Transparency = enabled and 0.02 or 0.22,
                }):Play()
            end
        end

        local function createToggleRow(target, parent, callback)
            local frame = createFrame2(target, 34)
            local textLabel2 = createTextLabel(frame, parent)
            local switchTrack, value = createSwitchTrack(frame, 22)
            local isActive = false

            local function setToggleState(enabled)
                isActive = enabled == true
                textLabel2.TextColor3 = isActive and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(224, 224, 232)
                animateSwitch(switchTrack, value, isActive)
            end

            local textButton = Instance.new("TextButton", switchTrack)
            textButton.Size = UDim2.new(1, 0, 1, 0)
            textButton.BackgroundTransparency = 1
            textButton.Text = ""
            textButton.AutoButtonColor = false
            textButton.ZIndex = 10

            textButton.Activated:Connect(function()
                isActive = not isActive
                setToggleState(isActive)
                pcall(callback, isActive)

                task.defer(function()
                    pcall(saveAllSettings)
                end)
            end)

            return setToggleState
        end

        local function createTextLabel2(parent, text, value, callback)
            local instance = Instance.new("Frame", parent)
            instance.Size = UDim2.new(0, 128, 0, 26)
            instance.Position = UDim2.new(1, -136, 0.5, -13)
            instance.BackgroundColor3 = Color3.fromRGB(8, 8, 11)
            instance.BackgroundTransparency = 0.22
            instance.BorderSizePixel = 0
            instance.ZIndex = 8
            Instance.new("UICorner", instance).CornerRadius = UDim.new(0, 8)
            local uiStroke = Instance.new("UIStroke", instance)
            uiStroke.Color = Color3.fromRGB(70, 70, 80)
            uiStroke.Transparency = 0.45
            uiStroke.Thickness = 1
            local textButton = Instance.new("TextButton", instance)
            textButton.Size = UDim2.new(0, 24, 1, 0)
            textButton.BackgroundTransparency = 1
            textButton.BorderSizePixel = 0
            textButton.Text = "‹"
            textButton.TextColor3 = Color3.fromRGB(170, 170, 182)
            textButton.Font = Enum.Font.GothamBlack
            textButton.TextSize = 16
            textButton.ZIndex = 9
            local textLabel2 = Instance.new("TextLabel", instance)
            textLabel2.Size = UDim2.new(1, -48, 1, 0)
            textLabel2.Position = UDim2.new(0, 24, 0, 0)
            textLabel2.BackgroundTransparency = 1
            textLabel2.Text = text
            textLabel2.TextColor3 = color2
            textLabel2.Font = Enum.Font.GothamBlack
            textLabel2.TextSize = 10
            textLabel2.TextXAlignment = Enum.TextXAlignment.Center
            textLabel2.TextTruncate = Enum.TextTruncate.AtEnd
            textLabel2.ZIndex = 9
            local textButton2 = Instance.new("TextButton", instance)
            textButton2.Size = UDim2.new(0, 24, 1, 0)
            textButton2.Position = UDim2.new(1, -24, 0, 0)
            textButton2.BackgroundTransparency = 1
            textButton2.BorderSizePixel = 0
            textButton2.Text = "›"
            textButton2.TextColor3 = Color3.fromRGB(170, 170, 182)
            textButton2.Font = Enum.Font.GothamBlack
            textButton2.TextSize = 16
            textButton2.ZIndex = 9

            local function setLabelText(text)
                textLabel2.Text = text
            end

            textButton.Activated:Connect(function()
                if callback then
                    callback(-1, setLabelText)

                    task.defer(function()
                        pcall(saveAllSettings)
                    end)
                end
            end)

            textButton2.Activated:Connect(function()
                if callback then
                    callback(1, setLabelText)

                    task.defer(function()
                        pcall(saveAllSettings)
                    end)
                end
            end)

            return textLabel2
        end

        local function createTextBox(parent, value, value2, value3, callback)
            local textBox = Instance.new("TextBox", parent)
            value2 = value2 or 50
            local amount = math.max(value3 or 56, value2 + 12)
            textBox.Size = UDim2.new(0, value2, 0, 22)
            textBox.Position = UDim2.new(1, -amount, 0.5, -11)
            textBox.BackgroundColor3 = Color3.fromRGB(8, 8, 11)
            textBox.BackgroundTransparency = 0.3
            textBox.BorderSizePixel = 0
            textBox.Text = tostring(value)
            textBox.TextColor3 = color2
            textBox.Font = Enum.Font.GothamBlack
            textBox.TextSize = 10
            textBox.ClearTextOnFocus = false
            textBox.ZIndex = 8
            Instance.new("UICorner", textBox).CornerRadius = UDim.new(0, 6)
            local uiStroke = Instance.new("UIStroke", textBox)
            uiStroke.Color = Color3.fromRGB(78, 78, 88)
            uiStroke.Thickness = 1
            uiStroke.Transparency = 0.35

            textBox.Focused:Connect(function()
                TweenService:Create(uiStroke, TweenInfo.new(0.12), { Color = getThemeColor(), Transparency = 0.05 }):Play()
            end)

            textBox.FocusLost:Connect(function()
                TweenService:Create(uiStroke, TweenInfo.new(0.12), { Color = Color3.fromRGB(78, 78, 88), Transparency = 0.35 }):Play()

                if callback then
                    local num = tonumber(textBox.Text)

                    if num then
                        callback(num)
                    else
                        textBox.Text = tostring(value)
                    end

                    task.defer(function()
                        pcall(saveAllSettings)
                    end)
                end
            end)

            return textBox
        end

        local function createTextButton(parent, value)
            local textButton = Instance.new("TextButton", parent)
            textButton.Size = UDim2.new(0, 80, 0, 22)
            textButton.Position = UDim2.new(1, -88, 0.5, -11)
            textButton.BackgroundColor3 = Color3.fromRGB(8, 8, 11)
            textButton.BackgroundTransparency = 0.28
            textButton.BorderSizePixel = 0

            local function getKeybindLabel()
                return value.gp and value.gp.Name or value.kb and value.kb.Name or "None"
            end

            textButton.Text = getKeybindLabel()
            textButton.TextColor3 = color2
            textButton.Font = Enum.Font.GothamBlack
            textButton.TextSize = 9
            textButton.ZIndex = 8
            textButton.AutoButtonColor = false
            Instance.new("UICorner", textButton).CornerRadius = UDim.new(0, 6)
            local uiStroke = Instance.new("UIStroke", textButton)
            uiStroke.Color = Color3.fromRGB(78, 78, 88)
            uiStroke.Transparency = 0.32
            uiStroke.Thickness = 1
            local isActive = false
            local connection2 = nil
            local connection3 = nil
            local text = textButton.Text
            local counter = 0

            textButton.Activated:Connect(function()
                if isActive then
                    isActive = false
                    _anyKeyListening = false

                    if connection2 then
                        connection2:Disconnect()
                        connection2 = nil
                    end

                    if connection3 then
                        connection3:Disconnect()
                        connection3 = nil
                    end

                    textButton.Text = text
                    textButton.TextColor3 = color2
                    return
                end

                text = textButton.Text
                isActive = true
                _anyKeyListening = true
                counter = getTime()
                textButton.Text = "..."
                textButton.TextColor3 = getThemeColor()

                connection2 = UserInputService.InputBegan:Connect(function(input)
                    if not isActive then
                        return
                    end

                    if input.KeyCode == Enum.KeyCode.Escape then
                        isActive = false
                        _anyKeyListening = false

                        if connection2 then
                            connection2:Disconnect()
                            connection2 = nil
                        end

                        if connection3 then
                            connection3:Disconnect()
                            connection3 = nil
                        end

                        textButton.Text = text
                        textButton.TextColor3 = color2
                        return
                    end

                    local gamepadInput = isGamepadInput(input)
                    if gamepadInput and getTime() - counter < 0.15 then
                        return
                    end

                    if not isBindableInput(input) then
                        return
                    end
                    textButton.Text = input.KeyCode.Name
                    text = input.KeyCode.Name
                    textButton.TextColor3 = color2
                    isActive = false
                    _anyKeyListening = false

                    if connection2 then
                        connection2:Disconnect()
                        connection2 = nil
                    end

                    if connection3 then
                        connection3:Disconnect()
                        connection3 = nil
                    end

                    if gamepadInput then
                        value.gp = input.KeyCode
                        value.kb = nil
                    else
                        value.kb = input.KeyCode
                        value.gp = nil
                    end

                    task.defer(function()
                        pcall(saveAllSettings)
                    end)
                end)

                connection3 = UserInputService.InputChanged:Connect(function(input)
                    if not isActive or not isGamepadInput(input) then
                        return
                    end

                    if input.KeyCode ~= Enum.KeyCode.ButtonL2 and input.KeyCode ~= Enum.KeyCode.ButtonR2 then
                        return
                    end

                    if input.Position.Z < 0.55 then
                        return
                    end
                    textButton.Text = input.KeyCode.Name
                    text = input.KeyCode.Name
                    textButton.TextColor3 = color2
                    isActive = false
                    _anyKeyListening = false

                    if connection2 then
                        connection2:Disconnect()
                        connection2 = nil
                    end

                    if connection3 then
                        connection3:Disconnect()
                        connection3 = nil
                    end

                    value.gp = input.KeyCode
                    value.kb = nil

                    task.defer(function()
                        pcall(saveAllSettings)
                    end)
                end)
            end)

            table.insert(keyButtonRefs, { btn = textButton, entry = value })
            return textButton
        end

        local function createSettingRow(target, parent, parent2)
            local frame = createFrame2(target, 34)
            createTextLabel(frame, parent)
            createTextButton(frame, parent2)
        end

        local moment = entries.Moment
        createFrame(moment, "Speed Profile  ·  Normal / Carry")
        local frame = createFrame2(moment, 42)
        createTextLabel(frame, "Normal Speed")

        normalBox = createTextBox(frame, NORMAL_SPEED, 50, 56, function(value)
            if value > 0 and value <= 500 then
                NORMAL_SPEED = value

                if _G.__YoutApplySpeedNow then
                    pcall(_G.__YoutApplySpeedNow)
                end
            end
        end)

        local frame = createFrame2(moment, 42)
        createTextLabel(frame, "Carry Speed")

        carryBox = createTextBox(frame, CARRY_SPEED, 50, 56, function(value)
            if value > 0 and value <= 500 then
                CARRY_SPEED = value

                if _G.__YoutApplySpeedNow then
                    pcall(_G.__YoutApplySpeedNow)
                end
            end
        end)

        local frame = createFrame2(moment, 42)
        createTextLabel(frame, "Lagger Normal Speed")

        laggerBox = createTextBox(frame, LAGGER_SPEED, 50, 56, function(value)
            if value > 0 and value <= 500 then
                LAGGER_SPEED = value

                if _G.__YoutApplySpeedNow then
                    pcall(_G.__YoutApplySpeedNow)
                end
            end
        end)

        local frame = createFrame2(moment, 42)
        createTextLabel(frame, "Lagger Carry Speed")

        lagger2Box = createTextBox(frame, LAGGER_CARRY_SPEED, 50, 56, function(value)
            if value > 0 and value <= 500 then
                LAGGER_CARRY_SPEED = value

                if _G.__YoutApplySpeedNow then
                    pcall(_G.__YoutApplySpeedNow)
                end
            end
        end)

        createFrame(moment, "Movement Mode")
        local frame = createFrame2(moment, 42)
        createTextLabel(frame, "Current Mode")
        modeValLbl = Instance.new("TextLabel", frame)
        modeValLbl.Size = UDim2.new(0, 110, 1, 0)
        modeValLbl.Position = UDim2.new(1, -118, 0, 0)
        modeValLbl.BackgroundTransparency = 1
        modeValLbl.Text = "Normal"
        modeValLbl.TextColor3 = color2
        modeValLbl.Font = Enum.Font.GothamBold
        modeValLbl.TextSize = 12
        modeValLbl.TextXAlignment = Enum.TextXAlignment.Right
        modeValLbl.ZIndex = 8
        local textButton = Instance.new("TextButton", frame)
        textButton.Size = UDim2.new(1, 0, 1, 0)
        textButton.BackgroundTransparency = 1
        textButton.Text = ""
        textButton.AutoButtonColor = false
        textButton.ZIndex = 8

        textButton.MouseButton1Click:Connect(function()
            toggleCarryMode()
        end)

        createFrame(moment, "Auto Movement")

        autoLeftSetVisual = createToggleRow(moment, "Auto Left", function(enabled)
            autoLeftEnabled = enabled

            if enabled then
                startAutoLeft()
            else
                stopAutoLeft()
            end

            if mobSetAutoLeft then
                mobSetAutoLeft(enabled)
            end
        end)

        autoRightSetVisual = createToggleRow(moment, "Auto Right", function(enabled)
            autoRightEnabled = enabled

            if enabled then
                startAutoRight()
            else
                stopAutoRight()
            end

            if mobSetAutoRight then
                mobSetAutoRight(enabled)
            end
        end)

        local combat = entries.Combat
        createFrame(combat, "Defense")

        setAntiBatVisual = createToggleRow(combat, "Anti Bat", function(enabled)
            if enabled then
                startAntiBat()
            else
                stopAntiBat()
            end
        end)

        setAntiFlingVisual = createToggleRow(combat, "Anti Fling", function(enabled)
            antiFlingEnabled = enabled

            if enabled then
                startAntiFling()
            else
                stopAntiFling()
            end

            saveAllSettings()
        end)

        if setAntiFlingVisual then
            setAntiFlingVisual(antiFlingEnabled)
        end

        setAntiRagVisual = createToggleRow(combat, "Anti Ragdoll", function(enabled)
            if enabled then
                startAntiRagdoll()
                antiRagdollMode = "v2"
            else
                stopAntiRagdoll()
                antiRagdollMode = "off"
            end

            saveAllSettings()
        end)

        if setAntiRagVisual then
            setAntiRagVisual(antiRagdollMode == "v2")
        end

        setAntiDieVisual = createToggleRow(combat, "Anti Die", function(enabled)
            antiDieEnabled = enabled

            if enabled then
                AntiDieModule.start()
            else
                AntiDieModule.stop()
            end

            saveAllSettings()
        end)

        if setAntiDieVisual then
            setAntiDieVisual(antiDieEnabled)
        end

        setUnwalkVisual = createToggleRow(combat, "Unwalk", function(enabled)
            unwalkEnabled = enabled

            if enabled then
                startUnwalk()
            else
                stopUnwalk()
            end
        end)

        createFrame(combat, "Attack")

        autoBatSetVisual = createToggleRow(combat, "Auto Bat", function(enabled)
            if enabled then
                enableAutoBat()
            else
                disableAutoBat()
            end

            if mobSetAutoBat then
                mobSetAutoBat(enabled)
            end
        end)

        local frame = createFrame2(combat, 42)
        createTextLabel(frame, "Bat Aimbot Speed")

        batSpeedBox = createTextBox(frame, BAT_AIMBOT_SPEED, 50, 56, function(value)
            if value > 0 and value <= 200 then
                BAT_AIMBOT_SPEED = value
            end
        end)

        tpBat = createToggleRow(combat, "TP BAT", function(enabled)
            if enabled then
                if not batDesyncTpEnabled then
                    toggleBatDesyncTp()
                end
            elseif batDesyncTpEnabled then
                toggleBatDesyncTp()
            end
        end)

        if tpBat then
            tpBat(batDesyncTpEnabled)
        end

        createFrame(combat, "Targeting")

        bodyLockSetVisual = createToggleRow(combat, "Lock Enemy", function(enabled)
            bodyLockEnabled = enabled

            if enabled then
                if _blSuppressCount == 0 then
                    startBodyLock()
                end
            else
                stopBodyLock()
            end
        end)

        local frame = createFrame2(combat, 42)
        createTextLabel(frame, "Lock Enemy Range")

        bodyLockRangeBox = createTextBox(frame, bodyLockRange, 50, 56, function(value)
            if value and value > 0 then
                bodyLockRange = clamp(floor(value), 5, 200)

                if bodyLockRangeBox then
                    bodyLockRangeBox.Text = tostring(bodyLockRange)
                end
            end
        end)

        createFrame(combat, "Counters")

        setBatCounterVisual = createToggleRow(combat, "Bat Counter", function(enabled)
            batCounterEnabled = enabled

            if enabled then
                startBatCounter()
            else
                stopBatCounter()
            end
        end)

        setBatCounterV2Visual = createToggleRow(combat, "Bat Counter V2", function(enabled)
            batCounterV2Enabled = enabled

            if enabled then
                startBatCounterV2()
            else
                stopBatCounterV2()
            end
        end)

        setMedusaVisual = createToggleRow(combat, "Medusa Counter", function(enabled)
            medusaCounterEnabled = enabled

            if enabled then
                if localPlayer.Character then
                    setupMedusaCounter(localPlayer.Character)
                else
                    stopMedusaCounter()
                end
            else
                stopMedusaCounter()
            end

            if setMedusaVisual then
                setMedusaVisual(enabled)
            end
        end)

        createFrame(combat, "Drop")

        dropBrainrotSetVisual = createToggleRow(combat, "Drop Brainrot", function(enabled)
            if enabled then
                executeDropWithToggle(function(value)
                    dropBrainrotSetVisual(value)

                    if mobSetDropBR then
                        mobSetDropBR(value)
                    end
                end)
            end
        end)

        setDropVisual = dropBrainrotSetVisual
        local frame = createFrame2(combat, 42)
        createTextLabel(frame, "Drop Mode")

        dropModeBtnRef = createTextLabel2(frame, dropMode == 1 and "Fling" or "Jump Drop", { "Fling", "Jump Drop" }, function(target, callback)
            if dropActive then
                stopDropBrainrot()
            end

            dropMode = dropMode == 1 and 2 or 1
            callback(dropMode == 1 and "Fling" or "Jump Drop")
        end)

        local visuals = entries.Visuals
        createFrame(visuals, "Interface")
        local frame = createFrame2(visuals, 42)
        createTextLabel(frame, "Background")
        local list = { "None", "Background 1" }

        backgroundSelectorLabel = createTextLabel2(frame, backgroundMode, list, function(value, callback)
            local amount = (backgroundMode == "None" and 1 or 2) + value

            if amount < 1 then
                amount = #list
            end

            if #list < amount then
                amount = 1
            end

            applyBackgroundMode(list[amount])
            callback(backgroundMode)
        end)

        applyBackgroundMode(backgroundMode)

        setLockUIVisual = createToggleRow(visuals, "Lock UI", function(target)
            toggleLockUI(target)
        end)

        setHideButtonsVisual = createToggleRow(visuals, "Hide Button", function(target)
            toggleHideButtons(target)
        end)

        if setHideButtonsVisual then
            setHideButtonsVisual(hideButtonsEnabled)
        end

        createFrame(visuals, "Display")
        local frame = createFrame2(visuals, 42)
        createTextLabel(frame, "UI Scale")

        uiScaleBox = createTextBox(frame, uiScaleValue, 50, 56, function(value)
            local clamped = clamp(floor(value + 0.5), 50, 150)
            uiScaleValue = clamped

            if mainUIScale then
                mainUIScale.Scale = clamped / 100
            end

            if pbScale then
                pbScale.Scale = clamped / 100
            end
        end)

        local frame = createFrame2(visuals, 42)
        createTextLabel(frame, "Button Scale")

        createTextBox(frame, floor(floatingButtonScale * 100), 50, 56, function(target)
            floatingButtonScale = clamp(target, 50, 200) / 100
            applyFloatingButtonScale()
            saveAllSettings()
        end)

        createFrame(visuals, "Character")
        local frame = createFrame2(visuals, 42)
        createTextLabel(frame, "Anim Pack")
        local value = 1

        for entry, entry2 in ipairs(ANIM_PACK_ORDER) do
            if entry2[2] == currentAnimPack then
                value = entry
                break
            end
        end

        local frame2 = Instance.new("Frame", frame)
        frame2.Size = UDim2.new(0, 160, 1, 0)
        frame2.Position = UDim2.new(1, -168, 0, 0)
        frame2.BackgroundTransparency = 1
        frame2.ZIndex = 8
        local textButton = Instance.new("TextButton", frame2)
        textButton.Size = UDim2.new(0, 28, 0, 26)
        textButton.Position = UDim2.new(0, 0, 0.5, -13)
        textButton.BackgroundColor3 = color3
        textButton.BackgroundTransparency = 0.7
        textButton.BorderSizePixel = 0
        textButton.Text = "<"
        textButton.TextColor3 = color2
        textButton.Font = Enum.Font.GothamBold
        textButton.TextSize = 13
        textButton.AutoButtonColor = false
        textButton.ZIndex = 9
        Instance.new("UICorner", textButton).CornerRadius = UDim.new(0, 6)
        animSelectorLabel = Instance.new("TextLabel", frame2)
        animSelectorLabel.Size = UDim2.new(0, 80, 0, 26)
        animSelectorLabel.Position = UDim2.new(0.5, -40, 0.5, -13)
        animSelectorLabel.BackgroundTransparency = 1
        animSelectorLabel.Text = ANIM_PACK_ORDER[value][2]
        animSelectorLabel.TextColor3 = color2
        animSelectorLabel.Font = Enum.Font.GothamBold
        animSelectorLabel.TextSize = 12
        animSelectorLabel.TextXAlignment = Enum.TextXAlignment.Center
        animSelectorLabel.ZIndex = 9
        local textButton2 = Instance.new("TextButton", frame2)
        textButton2.Size = UDim2.new(0, 28, 0, 26)
        textButton2.Position = UDim2.new(1, -28, 0.5, -13)
        textButton2.BackgroundColor3 = color3
        textButton2.BackgroundTransparency = 0.7
        textButton2.BorderSizePixel = 0
        textButton2.Text = ">"
        textButton2.TextColor3 = color2
        textButton2.Font = Enum.Font.GothamBold
        textButton2.TextSize = 13
        textButton2.AutoButtonColor = false
        textButton2.ZIndex = 9
        Instance.new("UICorner", textButton2).CornerRadius = UDim.new(0, 6)

        local function cycleAnimationPack(value)
            local value2 = 1

            for entry, entry2 in ipairs(ANIM_PACK_ORDER) do
                if entry2[2] == currentAnimPack then
                    value2 = entry
                    break
                end
            end

            local amount = value2 + value

            if amount < 1 then
                amount = #ANIM_PACK_ORDER
            end

            if #ANIM_PACK_ORDER < amount then
                amount = 1
            end

            local entry = ANIM_PACK_ORDER[amount][2]

            if entry == "Off" then
                resetAnimationPack()
            else
                applyAnimationPack(entry)
            end
        end

        textButton.MouseButton1Click:Connect(function()
            cycleAnimationPack(-1)
        end)

        textButton2.MouseButton1Click:Connect(function()
            cycleAnimationPack(1)
        end)

        local frame = createFrame2(visuals, 42)
        createTextLabel(frame, "Outfit")
        local instance = Instance.new("Frame", frame)
        instance.Size = UDim2.new(0, 160, 1, 0)
        instance.Position = UDim2.new(1, -168, 0, 0)
        instance.BackgroundTransparency = 1
        instance.ZIndex = 8
        local textButton = Instance.new("TextButton", instance)
        textButton.Size = UDim2.new(0, 28, 0, 26)
        textButton.Position = UDim2.new(0, 0, 0.5, -13)
        textButton.BackgroundColor3 = color3
        textButton.BackgroundTransparency = 0.7
        textButton.BorderSizePixel = 0
        textButton.Text = "<"
        textButton.TextColor3 = color2
        textButton.Font = Enum.Font.GothamBold
        textButton.TextSize = 13
        textButton.AutoButtonColor = false
        textButton.ZIndex = 9
        Instance.new("UICorner", textButton).CornerRadius = UDim.new(0, 6)
        textLabel = Instance.new("TextLabel", instance)
        textLabel.Size = UDim2.new(0, 80, 0, 26)
        textLabel.Position = UDim2.new(0.5, -40, 0.5, -13)
        textLabel.BackgroundTransparency = 1
        textLabel.Text = outfitPresets[outfitIndex].label
        textLabel.TextColor3 = color2
        textLabel.Font = Enum.Font.GothamBold
        textLabel.TextSize = 12
        textLabel.TextXAlignment = Enum.TextXAlignment.Center
        textLabel.ZIndex = 9
        local textButton2 = Instance.new("TextButton", instance)
        textButton2.Size = UDim2.new(0, 28, 0, 26)
        textButton2.Position = UDim2.new(1, -28, 0.5, -13)
        textButton2.BackgroundColor3 = color3
        textButton2.BackgroundTransparency = 0.7
        textButton2.BorderSizePixel = 0
        textButton2.Text = ">"
        textButton2.TextColor3 = color2
        textButton2.Font = Enum.Font.GothamBold
        textButton2.TextSize = 13
        textButton2.AutoButtonColor = false
        textButton2.ZIndex = 9
        Instance.new("UICorner", textButton2).CornerRadius = UDim.new(0, 6)

        local function cycleOutfit(value)
            local amount = outfitIndex + value

            if amount < 1 then
                amount = #outfitPresets
            end

            if #outfitPresets < amount then
                amount = 1
            end

            outfitIndex = amount

            pcall(function()
                applyOutfitByIndex(outfitIndex)
            end)

            if textLabel then
                textLabel.Text = outfitPresets[outfitIndex].label
            end

            saveAllSettings()
        end

        textButton.MouseButton1Click:Connect(function()
            cycleOutfit(-1)
        end)

        textButton2.MouseButton1Click:Connect(function()
            cycleOutfit(1)
        end)

        createFrame(visuals, "Effects")

        setVividVisual = createToggleRow(visuals, "Vivid Graphics", function(target)
            toggleVividGraphics(target)

            if setVividVisual then
                setVividVisual(target)
            end
        end)

        if setVividVisual then
            setVividVisual(vividGraphicsEnabled)
        end

        local frame = createFrame2(visuals, 42)
        createTextLabel(frame, "Stretch Rez")
        local switchTrack, value = createSwitchTrack(frame, 48)
        local value2 = false

        local function stretchToggleSetter(enabled)
            value2 = enabled
            animateSwitch(switchTrack, value, enabled)

            if enabled then
                enableStretch()
            else
                disableStretch()
            end

            stretchEnabled = enabled
        end

        local textButton = Instance.new("TextButton", switchTrack)
        textButton.Size = UDim2.new(1, 0, 1, 0)
        textButton.BackgroundTransparency = 1
        textButton.Text = ""
        textButton.AutoButtonColor = false
        textButton.ZIndex = 10

        textButton.MouseButton1Click:Connect(function()
            stretchToggleSetter(not value2)
        end)

        _G.stretchToggleSetter = stretchToggleSetter

        setAntiLagVisual = createToggleRow(visuals, "Anti Lag", function(enabled)
            if enabled then
                enableAntiLag()
            else
                disableAntiLag()
            end
        end)

        local frame = createFrame2(visuals, 42)
        createTextLabel(frame, "Sky Theme")
        local frame2 = Instance.new("Frame", frame)
        frame2.Size = UDim2.new(0, 160, 1, 0)
        frame2.Position = UDim2.new(1, -168, 0, 0)
        frame2.BackgroundTransparency = 1
        frame2.ZIndex = 8
        local textButton = Instance.new("TextButton", frame2)
        textButton.Size = UDim2.new(0, 28, 0, 26)
        textButton.Position = UDim2.new(0, 0, 0.5, -13)
        textButton.BackgroundColor3 = color3
        textButton.BackgroundTransparency = 0.7
        textButton.BorderSizePixel = 0
        textButton.Text = "<"
        textButton.TextColor3 = color2
        textButton.Font = Enum.Font.GothamBold
        textButton.TextSize = 13
        textButton.AutoButtonColor = false
        textButton.ZIndex = 9
        Instance.new("UICorner", textButton).CornerRadius = UDim.new(0, 6)
        skySelectorLabel = Instance.new("TextLabel", frame2)
        skySelectorLabel.Size = UDim2.new(0, 96, 0, 26)
        skySelectorLabel.Position = UDim2.new(0.5, -48, 0.5, -13)
        skySelectorLabel.BackgroundTransparency = 1
        skySelectorLabel.Text = skyTheme
        skySelectorLabel.TextColor3 = color2
        skySelectorLabel.Font = Enum.Font.GothamBold
        skySelectorLabel.TextSize = 11
        skySelectorLabel.TextXAlignment = Enum.TextXAlignment.Center
        skySelectorLabel.ZIndex = 9
        local textButton2 = Instance.new("TextButton", frame2)
        textButton2.Size = UDim2.new(0, 28, 0, 26)
        textButton2.Position = UDim2.new(1, -28, 0.5, -13)
        textButton2.BackgroundColor3 = color3
        textButton2.BackgroundTransparency = 0.7
        textButton2.BorderSizePixel = 0
        textButton2.Text = ">"
        textButton2.TextColor3 = color2
        textButton2.Font = Enum.Font.GothamBold
        textButton2.TextSize = 13
        textButton2.AutoButtonColor = false
        textButton2.ZIndex = 9
        Instance.new("UICorner", textButton2).CornerRadius = UDim.new(0, 6)

        local function cycleSkyPreset(value)
            local value2 = 1

            for entry, entry2 in ipairs(SKY_PRESETS_LIST) do
                if entry2 == skyTheme then
                    value2 = entry
                    break
                end
            end

            local amount = value2 + value

            if amount < 1 then
                amount = #SKY_PRESETS_LIST
            end

            if amount > #SKY_PRESETS_LIST then
                amount = 1
            end

            local entry = SKY_PRESETS_LIST[amount]
            skyTheme = entry
            pcall(applyCustomSky, entry)

            if skySelectorLabel then
                skySelectorLabel.Text = entry
            end

            pcall(saveAllSettings)
        end

        textButton.MouseButton1Click:Connect(function()
            cycleSkyPreset(-1)
        end)

        textButton2.MouseButton1Click:Connect(function()
            cycleSkyPreset(1)
        end)

        createFrame(visuals, "Overlays")

        setESPVIsual = createToggleRow(visuals, "Player ESP", function(target)
            toggleESP(target)
        end)

        setESPLineVisual = createToggleRow(visuals, "ESP Line", function(enabled)
            if enabled then
                startESPLine()
            else
                stopESPLine()
            end
        end)

        local main_ = entries.Main
        createFrame(main_, "Main Actions")
        local frame = createFrame2(main_, 42)
        createTextLabel(frame, "Auto Steal Mode")
        local frame2 = Instance.new("Frame", frame)
        frame2.Name = "StealModeSelector"
        frame2.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
        frame2.BackgroundTransparency = 0.15
        frame2.Size = UDim2.new(0, 120, 0, 30)
        frame2.Position = UDim2.new(1, -130, 0.5, -15)
        frame2.BorderSizePixel = 0
        frame2.ClipsDescendants = true
        frame2.ZIndex = 8
        Instance.new("UICorner", frame2).CornerRadius = UDim.new(0, 15)
        local uiStroke = Instance.new("UIStroke", frame2)
        uiStroke.Color = Color3.fromRGB(60, 60, 70)
        uiStroke.Thickness = 1
        uiStroke.Transparency = 0.35
        local instance = Instance.new("Frame", frame2)
        instance.Name = "SelectedSlide"
        instance.BackgroundColor3 = getThemeColor()
        instance.BackgroundTransparency = 0.15
        instance.Size = UDim2.new(0.5, -3, 1, -4)
        instance.Position = UDim2.new(0, 2, 0, 2)
        instance.BorderSizePixel = 0
        instance.ZIndex = 9
        Instance.new("UICorner", instance).CornerRadius = UDim.new(0, 13)
        local uiGradient = Instance.new("UIGradient", instance)
        uiGradient.Color = youtGradient(getThemeColor())
        uiGradient.Rotation = 0
        local uiStroke = Instance.new("UIStroke", instance)
        uiStroke.Color = getThemeColor()
        uiStroke.Thickness = 1.2
        uiStroke.Transparency = 0.1
        local textLabel2 = Instance.new("TextLabel", frame2)
        textLabel2.BackgroundTransparency = 1
        textLabel2.Text = "V1"
        textLabel2.TextColor3 = Color3.fromRGB(255, 255, 255)
        textLabel2.Font = Enum.Font.GothamBlack
        textLabel2.TextSize = 12
        textLabel2.Size = UDim2.new(0.5, 0, 1, 0)
        textLabel2.Position = UDim2.new(0, 0, 0, 0)
        textLabel2.ZIndex = 10
        local textLabel3 = Instance.new("TextLabel", frame2)
        textLabel3.BackgroundTransparency = 1
        textLabel3.Text = "V2"
        textLabel3.TextColor3 = Color3.fromRGB(150, 150, 165)
        textLabel3.Font = Enum.Font.GothamBlack
        textLabel3.TextSize = 12
        textLabel3.Size = UDim2.new(0.5, 0, 1, 0)
        textLabel3.Position = UDim2.new(0.5, 0, 0, 0)
        textLabel3.ZIndex = 10
        local textButton = Instance.new("TextButton", frame2)
        textButton.BackgroundTransparency = 1
        textButton.Text = ""
        textButton.AutoButtonColor = false
        textButton.Size = UDim2.new(0.5, 0, 1, 0)
        textButton.Position = UDim2.new(0, 0, 0, 0)
        textButton.ZIndex = 11
        local textButton2 = Instance.new("TextButton", frame2)
        textButton2.BackgroundTransparency = 1
        textButton2.Text = ""
        textButton2.AutoButtonColor = false
        textButton2.Size = UDim2.new(0.5, 0, 1, 0)
        textButton2.Position = UDim2.new(0.5, 0, 0, 0)
        textButton2.ZIndex = 11

        local function youtStealModeSetter(mode)
            local isActive = mode == "V2"
            TweenService:Create(instance, TweenInfo.new(0.22, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), { Position = isActive and UDim2.new(0.5, 1, 0, 2) or UDim2.new(0, 2, 0, 2) }):Play()

            TweenService:Create(textLabel2, TweenInfo.new(0.18), {
                TextColor3 = isActive and Color3.fromRGB(150, 150, 165) or Color3.fromRGB(255, 255, 255),
            }):Play()

            TweenService:Create(textLabel3, TweenInfo.new(0.18), { TextColor3 = isActive and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(150, 150, 165) }):Play()
        end

        local function setStealMode(mode)
            local text = mode == "V2" and "V2" or "V1"
            if text == selectedStealMode then
                return
            end
            selectedStealMode = text

            if selectedStealMode == "V2" then
                CONFIG.STEAL_RANGE = 60
                stealSettings.StealRadius = 60

                if radInput then
                    radInput.Text = "60"
                end
            end

            youtStealModeSetter(selectedStealMode)

            if CONFIG.AUTO_STEAL_ENABLED then
                pcall(startAutoSteal)
            end

            saveAllSettings()
        end

        textButton.MouseButton1Click:Connect(function()
            setStealMode("V1")
        end)

        textButton2.MouseButton1Click:Connect(function()
            setStealMode("V2")
        end)

        _G._youtStealSlide = instance
        _G._youtStealModeSetter = youtStealModeSetter
        youtStealModeSetter(selectedStealMode)

        setInstaGrab = createToggleRow(main_, "Auto Steal", function(autoStealEnabled)
            CONFIG.AUTO_STEAL_ENABLED = autoStealEnabled

            if autoStealEnabled then
                pcall(startAutoSteal)
            else
                stopAutoSteal()
            end

            updateProgressBarVisibility()
        end)

        local frame = createFrame2(main_, 42)
        createTextLabel(frame, "Steal Radius")

        radInput = createTextBox(frame, CONFIG.STEAL_RANGE, 50, 56, function(value)
            if value and value >= 5 and value <= 300 then
                CONFIG.STEAL_RANGE = floor(value + 0.5)
                stealSettings.StealRadius = CONFIG.STEAL_RANGE
                radInput.Text = tostring(CONFIG.STEAL_RANGE)
                saveAllSettings()
            end
        end)

        local settings_ = entries.Settings
        createFrame(settings_, "Management")
        local frame = createFrame2(settings_, 44)
        frame.Size = UDim2.new(1, 0, 0, 44)
        local textButton = Instance.new("TextButton", frame)
        textButton.Size = UDim2.new(1, -12, 0.8, 0)
        textButton.Position = UDim2.new(0, 6, 0.1, 0)
        textButton.BackgroundColor3 = Color3.fromRGB(245, 245, 250)
        textButton.BorderSizePixel = 0
        textButton.Text = "SAVE CONFIG"
        textButton.TextColor3 = Color3.fromRGB(20, 20, 25)
        textButton.Font = Enum.Font.GothamBold
        textButton.TextSize = 13
        textButton.AutoButtonColor = false
        textButton.ZIndex = 8
        Instance.new("UICorner", textButton).CornerRadius = UDim.new(0, 10)
        local uiStroke = Instance.new("UIStroke", textButton)
        uiStroke.Color = getThemeColor()
        uiStroke.Thickness = 1.5
        uiStroke.Transparency = 0.4

        textButton.MouseEnter:Connect(function()
            TweenService:Create(textButton, TweenInfo.new(0.15), { BackgroundColor3 = getThemeColor() }):Play()
            TweenService:Create(textButton, TweenInfo.new(0.15), { TextColor3 = Color3.fromRGB(255, 255, 255) }):Play()
        end)

        textButton.MouseLeave:Connect(function()
            TweenService:Create(textButton, TweenInfo.new(0.15), { BackgroundColor3 = Color3.fromRGB(245, 245, 250) }):Play()
            TweenService:Create(textButton, TweenInfo.new(0.15), { TextColor3 = Color3.fromRGB(20, 20, 25) }):Play()
        end)

        textButton.MouseButton1Click:Connect(function()
            textButton.Text = saveAllSettings(true) and "SAVED" or "ERROR"

            task.delay(1.2, function()
                if textButton and textButton.Parent then
                    textButton.Text = "SAVE CONFIG"
                end
            end)
        end)

        local frame = createFrame2(settings_, 44)
        frame.Size = UDim2.new(1, 0, 0, 44)
        local textButton = Instance.new("TextButton", frame)
        textButton.Size = UDim2.new(1, -12, 0.8, 0)
        textButton.Position = UDim2.new(0, 6, 0.1, 0)
        textButton.BackgroundColor3 = Color3.fromRGB(245, 245, 250)
        textButton.BorderSizePixel = 0
        textButton.Text = "RESET POSITIONS"
        textButton.TextColor3 = Color3.fromRGB(20, 20, 25)
        textButton.Font = Enum.Font.GothamBold
        textButton.TextSize = 13
        textButton.AutoButtonColor = false
        textButton.ZIndex = 8
        Instance.new("UICorner", textButton).CornerRadius = UDim.new(0, 10)
        local uiStroke = Instance.new("UIStroke", textButton)
        uiStroke.Color = getThemeColor()
        uiStroke.Thickness = 1.5
        uiStroke.Transparency = 0.4

        textButton.MouseEnter:Connect(function()
            TweenService:Create(textButton, TweenInfo.new(0.15), { BackgroundColor3 = getThemeColor() }):Play()
            TweenService:Create(textButton, TweenInfo.new(0.15), { TextColor3 = Color3.fromRGB(255, 255, 255) }):Play()
        end)

        textButton.MouseLeave:Connect(function()
            TweenService:Create(textButton, TweenInfo.new(0.15), { BackgroundColor3 = Color3.fromRGB(245, 245, 250) }):Play()
            TweenService:Create(textButton, TweenInfo.new(0.15), { TextColor3 = Color3.fromRGB(20, 20, 25) }):Play()
        end)

        local isActive = false

        textButton.MouseButton1Click:Connect(function()
            if isActive then
                return
            end
            isActive = true
            resetFloatingPositions()
            textButton.Text = "RESET"

            task.delay(1.2, function()
                if textButton and textButton.Parent then
                    textButton.Text = "RESET POSITIONS"
                    isActive = false
                end
            end)
        end)

        local frame = createFrame2(settings_, 44)
        frame.Size = UDim2.new(1, 0, 0, 44)
        local textButton = Instance.new("TextButton", frame)
        textButton.Size = UDim2.new(1, -12, 0.8, 0)
        textButton.Position = UDim2.new(0, 6, 0.1, 0)
        textButton.BackgroundColor3 = Color3.fromRGB(245, 245, 250)
        textButton.BorderSizePixel = 0
        textButton.Text = "RESET ALL SETTINGS"
        textButton.TextColor3 = Color3.fromRGB(170, 30, 50)
        textButton.Font = Enum.Font.GothamBold
        textButton.TextSize = 13
        textButton.AutoButtonColor = false
        textButton.ZIndex = 8
        Instance.new("UICorner", textButton).CornerRadius = UDim.new(0, 10)
        local uiStroke = Instance.new("UIStroke", textButton)
        uiStroke.Color = Color3.fromRGB(200, 60, 80)
        uiStroke.Thickness = 1.5
        uiStroke.Transparency = 0.4

        textButton.MouseEnter:Connect(function()
            TweenService:Create(textButton, TweenInfo.new(0.15), { BackgroundColor3 = Color3.fromRGB(200, 50, 70) }):Play()
            TweenService:Create(textButton, TweenInfo.new(0.15), { TextColor3 = Color3.fromRGB(255, 255, 255) }):Play()
        end)

        textButton.MouseLeave:Connect(function()
            TweenService:Create(textButton, TweenInfo.new(0.15), { BackgroundColor3 = Color3.fromRGB(245, 245, 250) }):Play()
            TweenService:Create(textButton, TweenInfo.new(0.15), { TextColor3 = Color3.fromRGB(170, 30, 50) }):Play()
        end)

        local counter = 0
        local isActive = false

        textButton.MouseButton1Click:Connect(function()
            if isActive then
                return
            end

            if counter == 0 then
                counter = 1
                textButton.Text = "CONFIRM?"
                textButton.BackgroundColor3 = Color3.fromRGB(255, 220, 220)
                textButton.TextColor3 = Color3.fromRGB(160, 0, 0)

                task.delay(2, function()
                    if textButton and textButton.Parent and counter == 1 then
                        counter = 0
                        textButton.Text = "RESET ALL SETTINGS"
                        textButton.BackgroundColor3 = Color3.fromRGB(245, 245, 250)
                        textButton.TextColor3 = Color3.fromRGB(170, 30, 50)
                    end
                end)
            elseif counter == 1 then
                isActive = true
                local success, result = pcall(resetToFactoryDefaults)
                textButton.Text = success and result and "SETTINGS RESET" or "ERROR"
                textButton.BackgroundColor3 = Color3.fromRGB(245, 245, 250)
                textButton.TextColor3 = Color3.fromRGB(170, 30, 50)
                counter = 0

                task.delay(1.5, function()
                    if textButton and textButton.Parent then
                        textButton.Text = "RESET ALL SETTINGS"
                        textButton.BackgroundColor3 = Color3.fromRGB(245, 245, 250)
                        textButton.TextColor3 = Color3.fromRGB(170, 30, 50)
                        isActive = false
                    end
                end)
            end
        end)

        local keybinds = entries.Keybinds
        createFrame(keybinds, "Keybinds")
        local frame = createFrame2(keybinds, 40)
        createTextLabel(frame, "Reset All Keybinds")
        local textButton = Instance.new("TextButton", frame)
        textButton.Size = UDim2.new(0, 92, 0, 24)
        textButton.Position = UDim2.new(1, -100, 0.5, -12)
        textButton.BackgroundColor3 = Color3.fromRGB(245, 245, 250)
        textButton.BorderSizePixel = 0
        textButton.Text = "RESET"
        textButton.TextColor3 = Color3.fromRGB(170, 30, 50)
        textButton.Font = Enum.Font.GothamBold
        textButton.TextSize = 11
        textButton.ZIndex = 9
        Instance.new("UICorner", textButton).CornerRadius = UDim.new(0, 7)

        textButton.MouseButton1Click:Connect(function()
            for entry, entry2 in pairs(DEFAULT_KEYBINDS) do
                if KEYBINDS[entry] then
                    KEYBINDS[entry].kb = entry2.kb
                    KEYBINDS[entry].gp = entry2.gp
                end
            end

            for _, keyButtonRef in ipairs(keyButtonRefs) do
                local entry = keyButtonRef.entry
                keyButtonRef.btn.Text = entry.gp and entry.gp.Name or entry.kb and entry.kb.Name or "None"
            end

            textButton.Text = "RESET"

            task.defer(function()
                saveAllSettings(true)
            end)

            task.delay(1, function()
                if textButton and textButton.Parent then
                    textButton.Text = "RESET"
                end
            end)
        end)

        createFrame(keybinds, "Movement")
        createSettingRow(keybinds, "Carry Mode", KEYBINDS.CarryToggle)
        createSettingRow(keybinds, "Lagger Mode", KEYBINDS.LaggerMode)
        createSettingRow(keybinds, "Auto Left", KEYBINDS.AutoLeft)
        createSettingRow(keybinds, "Auto Right", KEYBINDS.AutoRight)
        createFrame(keybinds, "Combat")
        createSettingRow(keybinds, "Auto Bat", KEYBINDS.AutoBat)
        createSettingRow(keybinds, "Bat V2", KEYBINDS.BatV2)
        createSettingRow(keybinds, "TP BAT", KEYBINDS.TPBat)
        createFrame(keybinds, "Utility")
        createSettingRow(keybinds, "Drop Brainrot", KEYBINDS.DropBrainrot)
        createSettingRow(keybinds, "Insta Reset", KEYBINDS.InstaReset)
        createSettingRow(keybinds, "TP Down", KEYBINDS.TPFloor)
        createSettingRow(keybinds, "Hide GUI", KEYBINDS.GuiHide)
        local instance = Instance.new("Frame", keybinds)
        instance.Size = UDim2.new(1, 0, 0, 16)
        instance.BackgroundTransparency = 1
        instance.LayoutOrder = nextLayoutOrder(keybinds)
        instance.ZIndex = 7
        pbFrame = Instance.new("Frame", gui)
        pbFrame.Name = "YoutAutoGrabBar"
        pbFrame.Size = UDim2.new(0, 344, 0, 56)
        pbFrame.Position = UDim2.new(0.5, -134, 0.8, 0)
        pbFrame.BackgroundColor3 = Color3.fromRGB(7, 7, 11)
        pbFrame.BackgroundTransparency = 0.04
        pbFrame.BorderSizePixel = 0
        pbFrame.Active = true
        pbFrame.Visible = CONFIG.AUTO_STEAL_ENABLED
        pbFrame.ZIndex = 500
        pbFrame.ClipsDescendants = false
        pbScale = Instance.new("UIScale", pbFrame)
        pbScale.Scale = uiScaleValue / 100

        if savedProgressBarPos then
            pbFrame.Position = UDim2.new(savedProgressBarPos.XScale or 0.5, savedProgressBarPos.XOffset or -172, savedProgressBarPos.YScale or 0.8, savedProgressBarPos.YOffset or 0)
        end

        Instance.new("UICorner", pbFrame).CornerRadius = UDim.new(0, 12)
        local instance = Instance.new("UIGradient", pbFrame)
        instance.Name = "PanelGrad"
        instance.Rotation = 90

        instance.Color = ColorSequence.new({

            ColorSequenceKeypoint.new(0, Color3.fromRGB(20, 20, 27)),

            ColorSequenceKeypoint.new(0.48, Color3.fromRGB(10, 10, 15)),

            ColorSequenceKeypoint.new(1, Color3.fromRGB(4, 4, 7)),

        })
        local uiStroke = Instance.new("UIStroke", pbFrame)
        uiStroke.Name = "OuterStroke"
        uiStroke.Color = Color3.fromRGB(255, 70, 160)
        uiStroke.Thickness = 1.1
        uiStroke.Transparency = 0.35
        uiStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        local textLabel2 = Instance.new("TextLabel", pbFrame)
        textLabel2.Name = "DiscordText"
        textLabel2.Size = UDim2.new(1, -14, 0, 16)
        textLabel2.Position = UDim2.new(0, 7, 0, 4)
        textLabel2.BackgroundTransparency = 1
        textLabel2.Text = "discord.gg/yout"
        textLabel2.TextColor3 = Color3.fromRGB(255, 122, 188)
        textLabel2.Font = Enum.Font.GothamBold
        textLabel2.TextSize = 11
        textLabel2.TextXAlignment = Enum.TextXAlignment.Center
        textLabel2.ZIndex = 506
        local instance = Instance.new("Frame", pbFrame)
        instance.Name = "InfoColumn"
        instance.Size = UDim2.new(0, 92, 0, 14)
        instance.Position = UDim2.new(1, -98, 1, -17)
        instance.BackgroundTransparency = 1
        instance.ZIndex = 504
        local frame = Instance.new("Frame", instance)
        frame.Name = "Divider"
        frame.Size = UDim2.new(0, 1, 1, -2)
        frame.Position = UDim2.new(0, 0, 0, 1)
        frame.BackgroundColor3 = Color3.fromRGB(255, 70, 160)
        frame.BackgroundTransparency = 0.55
        frame.BorderSizePixel = 0
        frame.ZIndex = 505
        local textLabel2 = Instance.new("TextLabel", instance)
        textLabel2.Name = "FPSNeon"
        textLabel2.Size = UDim2.new(0.5, -5, 1, 0)
        textLabel2.Position = UDim2.new(0, 5, 0, 0)
        textLabel2.BackgroundTransparency = 1
        textLabel2.Text = "-- FPS"
        textLabel2.TextColor3 = Color3.fromRGB(255, 122, 188)
        textLabel2.Font = Enum.Font.GothamBold
        textLabel2.TextSize = 7
        textLabel2.TextXAlignment = Enum.TextXAlignment.Left
        textLabel2.ZIndex = 506
        local instance2 = Instance.new("TextLabel", instance)
        instance2.Name = "PingNeon"
        instance2.Size = UDim2.new(0.5, -2, 1, 0)
        instance2.Position = UDim2.new(0.5, 1, 0, 0)
        instance2.BackgroundTransparency = 1
        instance2.Text = "-- MS"
        instance2.TextColor3 = Color3.fromRGB(255, 122, 188)
        instance2.Font = Enum.Font.GothamBold
        instance2.TextSize = 7
        instance2.TextXAlignment = Enum.TextXAlignment.Right
        instance2.ZIndex = 506
        local frame = Instance.new("Frame", pbFrame)
        frame.Name = "BarBg"
        frame.Size = UDim2.new(1, -14, 0, 20)
        frame.Position = UDim2.new(0, 7, 0, 22)
        frame.BackgroundColor3 = Color3.fromRGB(2, 2, 5)
        frame.BorderSizePixel = 0
        frame.ClipsDescendants = true
        frame.ZIndex = 500
        Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 7)
        local instance = Instance.new("UIStroke", frame)
        instance.Name = "TrackStroke"
        instance.Color = Color3.fromRGB(38, 38, 48)
        instance.Thickness = 1
        instance.Transparency = 0.15
        progressFill = Instance.new("Frame", frame)
        progressFill.Size = UDim2.new(0, 0, 1, 0)
        progressFill.Position = UDim2.new(0, 0, 0, 0)
        progressFill.BackgroundColor3 = Color3.fromRGB(255, 52, 154)
        progressFill.BorderSizePixel = 0
        progressFill.ClipsDescendants = true
        progressFill.ZIndex = 502
        Instance.new("UICorner", progressFill).CornerRadius = UDim.new(0, 7)
        local uiGradient = Instance.new("UIGradient", progressFill)
        uiGradient.Name = "FillGrad"

        uiGradient.Color = ColorSequence.new({

            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 111, 190)),

            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 48, 151)),

            ColorSequenceKeypoint.new(1, Color3.fromRGB(190, 20, 102)),

        })
        uiGradient.Rotation = 0
        local frame2 = Instance.new("Frame", progressFill)
        frame2.Name = "FillHighlight"
        frame2.Size = UDim2.new(1, -6, 0.35, 0)
        frame2.Position = UDim2.new(0, 3, 0, 1)
        frame2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        frame2.BackgroundTransparency = 0.72
        frame2.BorderSizePixel = 0
        frame2.ZIndex = 503
        Instance.new("UICorner", frame2).CornerRadius = UDim.new(1, 0)
        local frame2 = Instance.new("Frame", progressFill)
        frame2.Name = "Shimmer"
        frame2.Size = UDim2.new(0, 34, 1, 0)
        frame2.Position = UDim2.new(0, -34, 0, 0)
        frame2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        frame2.BackgroundTransparency = 0.58
        frame2.BorderSizePixel = 0
        frame2.ZIndex = 504
        local uiGradient = Instance.new("UIGradient", frame2)

        uiGradient.Transparency = NumberSequence.new({

            NumberSequenceKeypoint.new(0, 1),

            NumberSequenceKeypoint.new(0.5, 0.25),

            NumberSequenceKeypoint.new(1, 1),

        })
        progressPct = Instance.new("TextLabel", frame)
        progressPct.Size = UDim2.new(1, 0, 1, 0)
        progressPct.Position = UDim2.new(0, 0, 0, 0)
        progressPct.BackgroundTransparency = 1
        progressPct.Text = "0%"
        progressPct.TextColor3 = Color3.fromRGB(255, 255, 255)
        progressPct.Font = Enum.Font.GothamBlack
        progressPct.TextSize = 10
        progressPct.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        progressPct.TextStrokeTransparency = 0.25
        progressPct.TextXAlignment = Enum.TextXAlignment.Center
        progressPct.TextYAlignment = Enum.TextYAlignment.Center
        progressPct.ZIndex = 505

        task.spawn(function()
            while pbFrame and pbFrame.Parent do
                frame2.Position = UDim2.new(0, -60, 0, 0)
                TweenService:Create(frame2, TweenInfo.new(1.6, Enum.EasingStyle.Linear), { Position = UDim2.new(1, 20, 0, 0) }):Play()
                task.wait(1.6)
            end
        end)

        task.spawn(function()
            local time = getTime()
            local entries = {}
            local value = 60

            RunService.RenderStepped:Connect(function()
                local time2 = getTime()
                local offset = time2 - time
                time = time2

                if offset > 0 then
                    table.insert(entries, 1 / offset)

                    if #entries > 30 then
                        table.remove(entries, 1)
                    end

                    local counter = 0

                    for _, entry in ipairs(entries) do
                        counter += entry
                    end

                    value = counter / #entries
                end
            end)

            while pbFrame and pbFrame.Parent do
                local counter = 0

                pcall(function()
                    counter = localPlayer:GetNetworkPing() * 1000
                end)

                if textLabel2 then
                    textLabel2.Text = string.format("%d FPS", floor(value + 0.5))
                end

                if instance2 then
                    instance2.Text = string.format("%d MS", floor(counter + 0.5))
                end

                task.wait(0.75)
            end
        end)

        createFollowController(pbFrame)
    end
end

do
    local isActive, counter, isPlayerRagdolled, playerHasTool, findClosestTarget, triggerBatCounter

    do
        createMobilePanel = function()
            local screenGui = Instance.new("ScreenGui")
            screenGui.Name = "YoutMobilePanel"
            screenGui.ResetOnSpawn = false
            screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

            pcall(function()
                if syn and syn.protect_gui then
                    syn.protect_gui(screenGui)
                end
            end)

            if not pcall(function()
                screenGui.Parent = game:GetService("CoreGui")
                end) then
                screenGui.Parent = localPlayer:WaitForChild("PlayerGui")
            end

            local entries = {}

            local list = {
                "DROP\nBR",
                "AUTO\nLEFT",
                "BAT\nAIMBOT",
                "AUTO\nRIGHT",
                "TP\nDOWN",
                "CARRY\nSPD",
                "LAGGER\nNORMAL",
                "LAGGER\nCARRY",
            }

            local function createFloatingButton(name, text, target, enabled, callback)
                local textButton = Instance.new("TextButton", screenGui)
                textButton.Name = name
                textButton.Size = UDim2.new(0, 60, 0, 40)
                textButton.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
                textButton.BorderSizePixel = 0
                textButton.Text = ""
                textButton.AutoButtonColor = false
                textButton.ZIndex = 10
                local entry = savedButtonPositions[name]

                if entry then
                    textButton.Position = UDim2.new(0, entry.X or 0, 0, entry.Y or 0)
                else
                    local defaultButtonPosition, value = getDefaultButtonPosition(name)
                    textButton.Position = UDim2.new(0, defaultButtonPosition, 0, value)
                end

                textButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                Instance.new("UICorner", textButton).CornerRadius = UDim.new(0, 9)
                local uiGradient = Instance.new("UIGradient", textButton)
                uiGradient.Name = "BtnGrad"
                uiGradient.Rotation = 90

                uiGradient.Color = ColorSequence.new({

                    ColorSequenceKeypoint.new(0, Color3.fromRGB(252, 252, 253)),

                    ColorSequenceKeypoint.new(0.45, Color3.fromRGB(233, 233, 236)),

                    ColorSequenceKeypoint.new(1, Color3.fromRGB(168, 168, 176)),

                })
                local uiStroke = Instance.new("UIStroke", textButton)
                uiStroke.Color = Color3.fromRGB(120, 120, 128)
                uiStroke.Thickness = 1
                uiStroke.Transparency = 0.55
                uiStroke.Name = "NormalStroke"
                local textLabel2 = Instance.new("TextLabel", textButton)
                textLabel2.Name = "TextLabel"
                textLabel2.Size = UDim2.new(1, 0, 1, 0)
                textLabel2.BackgroundTransparency = 1
                textLabel2.Text = text
                textLabel2.TextColor3 = Color3.fromRGB(32, 32, 40)
                textLabel2.Font = Enum.Font.GothamBlack
                textLabel2.TextSize = 9
                textLabel2.TextWrapped = true
                textLabel2.ZIndex = 11
                local uiScale = Instance.new("UIScale", textButton)
                uiScale.Scale = floatingButtonScale
                table.insert(_floatingUIScales, uiScale)
                local isActive2 = false

                local function setButtonActive(value)
                    isActive2 = value
                    textButton:SetAttribute("MobActive", value and true or false)
                    paintFloatingBtn(textButton, value)
                end

                setButtonActive(false)
                local isActive3 = false
                local isActive4 = false
                local position = nil
                local position2 = nil
                local counter2 = 0

                local function onDragBegan(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        isActive3 = true
                        isActive4 = false
                        counter2 = 0
                        position = input.Position
                        position2 = textButton.Position
                        _isDraggingButton = true
                    end
                end

                local function onDragChanged(input)
                    if not isActive3 then
                        return
                    end

                    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                        local offset = input.Position - position
                        counter2 = offset.Magnitude

                        if not uiLocked then
                            isActive4 = true
                            textButton.Position = UDim2.new(0, position2.X.Offset + offset.X, 0, position2.Y.Offset + offset.Y)
                        end
                    end
                end

                local function onDragEnded(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        if isActive3 then
                            if counter2 < 12 then
                                if enabled then
                                    if callback then
                                        callback(setButtonActive)
                                    end
                                elseif callback then
                                    callback(setButtonActive, isActive2)
                                end
                            elseif not uiLocked and isActive4 then
                                savedButtonPositions[name] = { X = textButton.Position.X.Offset, Y = textButton.Position.Y.Offset }

                                task.defer(function()
                                    pcall(saveAllSettings)
                                end)
                            end

                            isActive3 = false
                            isActive4 = false
                            position = nil
                            position2 = nil
                            counter2 = 0
                            _isDraggingButton = false
                        end
                    end
                end

                textButton.InputBegan:Connect(onDragBegan)
                textButton.InputChanged:Connect(onDragChanged)
                textButton.InputEnded:Connect(onDragEnded)

                UserInputService.InputEnded:Connect(function(input)
                    if input.UserInputType ~= Enum.UserInputType.Touch and input.UserInputType ~= Enum.UserInputType.MouseButton1 then
                        return
                    end

                    if isActive3 then
                        onDragEnded(input)
                    end
                end)

                entries[name] = { btn = textButton, setActive = setButtonActive, label = textLabel2 }
                return setButtonActive
            end

            for index, value in ipairs({ "DropBR", "AutoLeft", "AutoBat", "AutoRight", "TpDown", "Carry", "Lagger1", "Lagger2" }) do
                local entry = list[index]
                local triggerDropFromButton

                if value == "DropBR" then
                    triggerDropFromButton = function(callback)
                        if autoBatEnabled then
                            return
                        end
                        callback(true)

                        executeDropWithToggle(function(value2)
                            if dropBrainrotSetVisual then
                                dropBrainrotSetVisual(value2)
                            end
                        end)

                        task.delay(0.3, function()
                            callback(false)
                        end)
                    end
                elseif value == "AutoLeft" then
                    triggerDropFromButton = function(callback)
                        autoLeftEnabled = not autoLeftEnabled
                        callback(autoLeftEnabled)

                        if autoLeftEnabled then
                            startAutoLeft()
                        else
                            stopAutoLeft()
                        end

                        if autoLeftSetVisual then
                            autoLeftSetVisual(autoLeftEnabled)
                        end
                    end
                elseif value == "AutoBat" then
                    triggerDropFromButton = function(callback)
                        if not autoBatEnabled then
                            enableAutoBat()
                        else
                            disableAutoBat()
                        end

                        callback(autoBatEnabled)
                    end
                elseif value == "AutoRight" then
                    triggerDropFromButton = function(callback)
                        autoRightEnabled = not autoRightEnabled
                        callback(autoRightEnabled)

                        if autoRightEnabled then
                            startAutoRight()
                        else
                            stopAutoRight()
                        end

                        if autoRightSetVisual then
                            autoRightSetVisual(autoRightEnabled)
                        end
                    end
                elseif value == "TpDown" then
                    triggerDropFromButton = function(callback)
                        doTpDown()
                        callback(true)

                        task.delay(0.2, function()
                            callback(false)
                        end)
                    end
                elseif value == "Carry" then
                    triggerDropFromButton = function(callback)
                        if not speedMode then
                            speedMode = true
                            laggerToggled = false
                            laggerCarryToggled = false
                            callback(true)

                            if entries.Lagger1 and entries.Lagger1.setActive then
                                entries.Lagger1.setActive(false)
                            end

                            if entries.Lagger2 and entries.Lagger2.setActive then
                                entries.Lagger2.setActive(false)
                            end
                        else
                            speedMode = false
                            callback(false)
                        end

                        refreshSpeedModeLabel()

                        if _G.__YoutApplySpeedNow then
                            pcall(_G.__YoutApplySpeedNow)
                        end
                    end
                elseif value == "Lagger1" then
                    triggerDropFromButton = function(callback)
                        if speedMode then
                            speedMode = false

                            if mobSetCarry then
                                mobSetCarry(false)
                            end
                        end

                        if not laggerToggled then
                            laggerToggled = true
                            laggerCarryToggled = false
                            callback(true)

                            if entries.Lagger2 and entries.Lagger2.setActive then
                                entries.Lagger2.setActive(false)
                            end
                        else
                            laggerToggled = false
                            callback(false)
                        end

                        refreshSpeedModeLabel()

                        if _G.__YoutApplySpeedNow then
                            pcall(_G.__YoutApplySpeedNow)
                        end
                    end
                else
                    triggerDropFromButton = nil

                    if value == "Lagger2" then
                        triggerDropFromButton = function(callback)
                            if speedMode then
                                speedMode = false

                                if mobSetCarry then
                                    mobSetCarry(false)
                                end
                            end

                            if not laggerCarryToggled then
                                laggerCarryToggled = true
                                laggerToggled = false
                                callback(true)

                                if entries.Lagger1 and entries.Lagger1.setActive then
                                    entries.Lagger1.setActive(false)
                                end
                            else
                                laggerCarryToggled = false
                                callback(false)
                            end

                            refreshSpeedModeLabel()

                            if _G.__YoutApplySpeedNow then
                                pcall(_G.__YoutApplySpeedNow)
                            end
                        end
                    end
                end

                local floatingButton = createFloatingButton(value, entry, index - 1, true, triggerDropFromButton)

                if value == "AutoBat" then
                    mobSetAutoBat = floatingButton
                end

                if value == "AutoLeft" then
                    mobSetAutoLeft = floatingButton
                end

                if value == "AutoRight" then
                    mobSetAutoRight = floatingButton
                end

                if value == "DropBR" then
                    mobSetDropBR = floatingButton
                end

                if value == "TpDown" then
                    mobSetTpDown = floatingButton
                end

                if value == "Carry" then
                    mobSetCarry = floatingButton
                end

                if value == "Lagger1" then
                    mobSetLagger1 = floatingButton
                end

                if value == "Lagger2" then
                    mobSetLagger2 = floatingButton
                end
            end

            if entries.AutoBat and entries.AutoBat.setActive then
                entries.AutoBat.setActive(autoBatEnabled)
            end

            if entries.AutoLeft and entries.AutoLeft.setActive then
                entries.AutoLeft.setActive(autoLeftEnabled)
            end

            if entries.AutoRight and entries.AutoRight.setActive then
                entries.AutoRight.setActive(autoRightEnabled)
            end

            if entries.Carry and entries.Carry.setActive then
                entries.Carry.setActive(speedMode)
            end

            if entries.Lagger1 and entries.Lagger1.setActive then
                entries.Lagger1.setActive(laggerToggled)
            end

            if entries.Lagger2 and entries.Lagger2.setActive then
                entries.Lagger2.setActive(laggerCarryToggled)
            end

            for _, entry in pairs(entries) do
                if entry and entry.btn then
                    paintFloatingBtn(entry.btn, entry.btn:GetAttribute("MobActive") == true)
                end
            end

            return screenGui
        end

        createBatV2FloatingButton = function()
            local screenGui = Instance.new("ScreenGui")
            screenGui.Name = "YoutBatV2Button"
            screenGui.ResetOnSpawn = false
            screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
            screenGui.DisplayOrder = 22

            pcall(function()
                if syn and syn.protect_gui then
                    syn.protect_gui(screenGui)
                end
            end)

            if not pcall(function()
                screenGui.Parent = game:GetService("CoreGui")
                end) then
                screenGui.Parent = localPlayer:WaitForChild("PlayerGui")
            end

            local instance = Instance.new("Frame", screenGui)
            instance.Size = UDim2.new(0, 60, 0, 40)
            instance.Name = "Frame"

            if batV2FloatingPos then
                instance.Position = UDim2.new(batV2FloatingPos.XScale or 0.5, batV2FloatingPos.XOffset or -50, batV2FloatingPos.YScale or 0, batV2FloatingPos.YOffset or 10)
            else
                instance.Position = UDim2.new(0.5, -50, 0, 10)
            end

            instance.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            instance.BorderSizePixel = 0
            instance.ZIndex = 20
            Instance.new("UICorner", instance).CornerRadius = UDim.new(0, 9)
            local uiGradient = Instance.new("UIGradient", instance)
            uiGradient.Name = "BtnGrad"
            uiGradient.Rotation = 90

            uiGradient.Color = ColorSequence.new({

                ColorSequenceKeypoint.new(0, Color3.fromRGB(252, 252, 253)),

                ColorSequenceKeypoint.new(0.45, Color3.fromRGB(233, 233, 236)),

                ColorSequenceKeypoint.new(1, Color3.fromRGB(168, 168, 176)),

            })
            local instance2 = Instance.new("UIStroke", instance)
            instance2.Color = Color3.fromRGB(42, 42, 52)
            instance2.Thickness = 1
            instance2.Transparency = 0.25
            local textLabel2 = Instance.new("TextLabel", instance)
            textLabel2.Size = UDim2.new(1, 0, 1, 0)
            textLabel2.BackgroundTransparency = 1
            textLabel2.Text = "BAT\nV2"
            textLabel2.TextColor3 = Color3.fromRGB(32, 32, 40)
            textLabel2.Font = Enum.Font.GothamBlack
            textLabel2.TextSize = 9
            textLabel2.TextWrapped = true
            textLabel2.ZIndex = 21
            local uiScale = Instance.new("UIScale", instance)
            uiScale.Scale = floatingButtonScale
            table.insert(_floatingUIScales, uiScale)
            paintFloatingBtn(instance, youtBatV2PersistentState.enabled)
            local isActive2 = false
            local isActive3 = false
            local position = nil
            local position2 = nil

            instance.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    isActive2 = true
                    isActive3 = false
                    position = input.Position
                    position2 = instance.Position
                end
            end)

            instance.InputChanged:Connect(function(input)
                if not isActive2 then
                    return
                end

                if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                    local offset = input.Position - position

                    if 5 < offset.Magnitude then
                        isActive3 = true
                    end

                    if isActive3 and not uiLocked then
                        instance.Position = UDim2.new(position2.X.Scale, position2.X.Offset + offset.X, position2.Y.Scale, position2.Y.Offset + offset.Y)
                    end
                end
            end)

            instance.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    if isActive2 then
                        if not isActive3 then
                            if youtBatV2PersistentState.enabled then
                                stopYoutBatV2()
                            else
                                startYoutBatV2()
                            end

                            paintFloatingBtn(instance, youtBatV2PersistentState.enabled)
                        elseif not uiLocked then
                            batV2FloatingPos = {
                                XScale = instance.Position.X.Scale,
                                XOffset = instance.Position.X.Offset,
                                YScale = instance.Position.Y.Scale,
                                YOffset = instance.Position.Y.Offset,
                            }

                            task.defer(function()
                                pcall(saveAllSettings, true)
                            end)
                        end

                        isActive2 = false
                        isActive3 = false
                    end
                end
            end)

            batV2FloatingButton = screenGui
            return screenGui
        end

        createTpBatFloatingButton = function()
            local screenGui = Instance.new("ScreenGui")
            screenGui.Name = "TpBatButton"
            screenGui.ResetOnSpawn = false
            screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
            screenGui.DisplayOrder = 21

            pcall(function()
                if syn and syn.protect_gui then
                    syn.protect_gui(screenGui)
                end
            end)

            if not pcall(function()
                screenGui.Parent = game:GetService("CoreGui")
                end) then
                screenGui.Parent = localPlayer:WaitForChild("PlayerGui")
            end

            local frame = Instance.new("Frame", screenGui)
            frame.Size = UDim2.new(0, 60, 0, 40)
            frame.Name = "Frame"

            if tpBatFloatingPos then
                frame.Position = UDim2.new(tpBatFloatingPos.XScale or 0.5, tpBatFloatingPos.XOffset or 20, tpBatFloatingPos.YScale or 0, tpBatFloatingPos.YOffset or 10)
            else
                frame.Position = UDim2.new(0.5, 20, 0, 10)
            end

            frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            frame.BorderSizePixel = 0
            frame.ZIndex = 20
            Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 9)
            local instance = Instance.new("UIGradient", frame)
            instance.Name = "BtnGrad"
            instance.Rotation = 90

            instance.Color = ColorSequence.new({

                ColorSequenceKeypoint.new(0, Color3.fromRGB(252, 252, 253)),

                ColorSequenceKeypoint.new(0.45, Color3.fromRGB(233, 233, 236)),

                ColorSequenceKeypoint.new(1, Color3.fromRGB(168, 168, 176)),

            })
            local instance = Instance.new("UIStroke", frame)
            instance.Color = Color3.fromRGB(42, 42, 52)
            instance.Thickness = 1
            instance.Transparency = 0.25
            local textLabel2 = Instance.new("TextLabel", frame)
            textLabel2.Size = UDim2.new(1, 0, 1, 0)
            textLabel2.BackgroundTransparency = 1
            textLabel2.Text = "TP\nBAT"
            textLabel2.TextColor3 = Color3.fromRGB(32, 32, 40)
            textLabel2.Font = Enum.Font.GothamBlack
            textLabel2.TextSize = 9
            textLabel2.TextWrapped = true
            textLabel2.ZIndex = 21
            local uiScale = Instance.new("UIScale", frame)
            uiScale.Scale = floatingButtonScale
            table.insert(_floatingUIScales, uiScale)

            local function setButtonVisual(target)
                textLabel2.Text = "TP\nBAT"
                paintFloatingBtn(frame, target)
            end

            setButtonVisual(batDesyncTpEnabled == true)
            local isActive2 = false
            local isActive3 = false
            local position = nil
            local position2 = nil

            frame.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    isActive2 = true
                    isActive3 = false
                    position = input.Position
                    position2 = frame.Position
                end
            end)

            frame.InputChanged:Connect(function(input)
                if not isActive2 then
                    return
                end

                if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                    local offset = input.Position - position

                    if offset.Magnitude > 5 then
                        isActive3 = true
                    end

                    if isActive3 and not uiLocked then
                        frame.Position = UDim2.new(position2.X.Scale, position2.X.Offset + offset.X, position2.Y.Scale, position2.Y.Offset + offset.Y)
                    end
                end
            end)

            frame.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    if isActive2 then
                        if not isActive3 then
                            toggleBatDesyncTp()
                            setButtonVisual(batDesyncTpEnabled)
                        elseif not uiLocked and isActive3 then
                            tpBatFloatingPos = {
                                XScale = frame.Position.X.Scale,
                                XOffset = frame.Position.X.Offset,
                                YScale = frame.Position.Y.Scale,
                                YOffset = frame.Position.Y.Offset,
                            }

                            task.defer(function()
                                pcall(saveAllSettings)
                            end)
                        end

                        isActive2 = false
                        isActive3 = false
                    end
                end
            end)

            tpBatFloatingButton = screenGui
            return screenGui
        end

        createInstaResetFloatingButton = function()
            local screenGui = Instance.new("ScreenGui")
            screenGui.Name = "InstaResetButton"
            screenGui.ResetOnSpawn = false
            screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
            screenGui.DisplayOrder = 23

            pcall(function()
                if syn and syn.protect_gui then
                    syn.protect_gui(screenGui)
                end
            end)

            if not pcall(function()
                screenGui.Parent = game:GetService("CoreGui")
                end) then
                screenGui.Parent = localPlayer:WaitForChild("PlayerGui")
            end

            local instance = Instance.new("Frame", screenGui)
            instance.Size = UDim2.new(0, 60, 0, 40)
            instance.Name = "Frame"

            if instaResetFloatingPos then
                instance.Position = UDim2.new(instaResetFloatingPos.XScale or 0.5, instaResetFloatingPos.XOffset or 90, instaResetFloatingPos.YScale or 0, instaResetFloatingPos.YOffset or 10)
            else
                instance.Position = UDim2.new(0.5, 90, 0, 10)
            end

            instance.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            instance.BorderSizePixel = 0
            instance.ZIndex = 20
            Instance.new("UICorner", instance).CornerRadius = UDim.new(0, 9)
            local uiGradient = Instance.new("UIGradient", instance)
            uiGradient.Name = "BtnGrad"
            uiGradient.Rotation = 90

            uiGradient.Color = ColorSequence.new({

                ColorSequenceKeypoint.new(0, Color3.fromRGB(252, 252, 253)),

                ColorSequenceKeypoint.new(0.45, Color3.fromRGB(233, 233, 236)),

                ColorSequenceKeypoint.new(1, Color3.fromRGB(168, 168, 176)),

            })
            local uiStroke = Instance.new("UIStroke", instance)
            uiStroke.Color = Color3.fromRGB(42, 42, 52)
            uiStroke.Thickness = 1
            uiStroke.Transparency = 0.25
            local textLabel2 = Instance.new("TextLabel", instance)
            textLabel2.Size = UDim2.new(1, 0, 1, 0)
            textLabel2.BackgroundTransparency = 1
            textLabel2.Text = "INSTA\nRESET"
            textLabel2.TextColor3 = Color3.fromRGB(32, 32, 40)
            textLabel2.Font = Enum.Font.GothamBlack
            textLabel2.TextSize = 9
            textLabel2.TextWrapped = true
            textLabel2.ZIndex = 21
            local uiScale = Instance.new("UIScale", instance)
            uiScale.Scale = floatingButtonScale
            table.insert(_floatingUIScales, uiScale)
            local isActive2 = nil
            local isActive3 = nil
            local position = nil
            local position2 = nil
            local value = nil

            local function isPointInside(vector2)
                local absolutePosition = instance.AbsolutePosition
                local absoluteSize = instance.AbsoluteSize
                return vector2.X >= absolutePosition.X and vector2.X <= absolutePosition.X + absoluteSize.X and vector2.Y >= absolutePosition.Y and vector2.Y <= absolutePosition.Y + absoluteSize.Y
            end

            local function setButtonHighlight(target)
                paintFloatingBtn(instance, target and true or false)
            end

            setButtonHighlight(false)

            instance.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    if value then
                        return
                    end
                    value = input
                    isActive2 = true
                    isActive3 = false
                    position = input.Position
                    position2 = instance.Position
                end
            end)

            UserInputService.InputChanged:Connect(function(input)
                if not isActive2 or not value then
                    return
                end

                if not (value.UserInputType == Enum.UserInputType.Touch and input == value) and not (value.UserInputType == Enum.UserInputType.MouseButton1 and input.UserInputType == Enum.UserInputType.MouseMovement) then
                    return
                end
                local offset = input.Position - position

                if offset.Magnitude > 12 then
                    isActive3 = true
                end

                if isActive3 and not uiLocked then
                    instance.Position = UDim2.new(position2.X.Scale, position2.X.Offset + offset.X, position2.Y.Scale, position2.Y.Offset + offset.Y)
                end
            end)

            UserInputService.InputEnded:Connect(function(input)
                if input ~= value then
                    return
                end

                if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then
                    return
                end

                if isActive2 then
                    if not isActive3 and (input.Position - position).Magnitude <= 12 and isPointInside(input.Position) then
                        setButtonHighlight(true)

                        if _G.InstaReset and _G.InstaReset.Trigger then
                            _G.InstaReset.Trigger()
                        end

                        task.delay(0.2, function()
                            setButtonHighlight(false)
                        end)
                    elseif not uiLocked and isActive3 then
                        instaResetFloatingPos = {
                            XScale = instance.Position.X.Scale,
                            XOffset = instance.Position.X.Offset,
                            YScale = instance.Position.Y.Scale,
                            YOffset = instance.Position.Y.Offset,
                        }

                        pcall(saveAllSettings)
                    end

                    isActive2 = false
                    isActive3 = false
                    value = nil
                end
            end)

            instaResetFloatingButton = screenGui
            return screenGui
        end

        batCounterV2Enabled = false
        batCounterV2Debounce = false
        batCounterV2Conn = nil
        batCounterV2HitCooldown = false
        BAT_COUNTER_V2_SWING_CD = 0.08
        setBatCounterV2Visual = nil
        isActive = false
        counter = 0

        isPlayerRagdolled = function(player)
            if not player or not player.Character then
                return false
            end
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
            if not humanoid then
                return false
            end
            local state = humanoid:GetState()
            return state == Enum.HumanoidStateType.Physics or state == Enum.HumanoidStateType.Ragdoll or state == Enum.HumanoidStateType.FallingDown
        end

        playerHasTool = function(player)
            if not player or not player.Character then
                return false
            end

            for _, child in ipairs(player.Character:GetChildren()) do
                if child:IsA("Tool") then
                    if child:FindFirstChild("Handle") or child.Name:find("Animal") or child.Name:find("Pet") then
                        return true
                    end
                end
            end

            return false
        end

        findClosestTarget = function()
            local character = localPlayer.Character
            if not character then
                return nil
            end
            local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
            if not humanoidRootPart then
                return nil
            end
            local closestDistance = huge
            local value = nil

            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= localPlayer and player.Character then
                    if playerHasTool(player) then
                        local humanoidRootPart2 = player.Character:FindFirstChild("HumanoidRootPart")
                        local humanoid = player.Character:FindFirstChildOfClass("Humanoid")

                        if humanoidRootPart2 and humanoid and humanoid.Health > 0 then
                            local magnitude = (humanoidRootPart2.Position - humanoidRootPart.Position).Magnitude

                            if magnitude < 12 and magnitude < closestDistance then
                                closestDistance = magnitude
                                value = player
                            end
                        end
                    end
                end
            end

            return value
        end

        do
            local function findBatTool()
                local character = localPlayer.Character
                if not character then
                    return nil
                end

                for _, child in ipairs(character:GetChildren()) do
                    if child:IsA("Tool") then
                        local lowerName = child.Name:lower()
                        if lowerName:find("bat") or lowerName:find("slap") or lowerName:find("sword") or lowerName:find("knife") then
                            return child
                        end
                    end
                end

                local backpack = localPlayer:FindFirstChild("Backpack")

                if backpack then
                    for _, child in ipairs(backpack:GetChildren()) do
                        if child:IsA("Tool") then
                            local lowerName = child.Name:lower()
                            if lowerName:find("bat") or lowerName:find("slap") or lowerName:find("sword") or lowerName:find("knife") then
                                child.Parent = character
                                return child
                            end
                        end
                    end
                end

                if backpack then
                    for _, child in ipairs(backpack:GetChildren()) do
                        if child:IsA("Tool") then
                            child.Parent = character
                            return child
                        end
                    end
                end

                return nil
            end

            triggerBatCounter = function()
                if batCounterV2HitCooldown then
                    return
                end
                batCounterV2HitCooldown = true

                pcall(function()
                    local batTool = findBatTool()

                    if batTool then
                        batTool:Activate()
                        local remoteEvent = batTool:FindFirstChildWhichIsA("RemoteEvent")

                        if remoteEvent then
                            remoteEvent:FireServer()
                        end
                    end
                end)

                task.delay(BAT_COUNTER_V2_SWING_CD, function()
                    batCounterV2HitCooldown = false
                end)
            end
        end
    end

    do
        local function fireBatCounter()
            local time = getTime()
            if time - (counter or 0) < 0.01 then
                return
            end

            if batCounterV2Debounce then
                return
            end
            batCounterV2Debounce = true
            counter = time
            local closestTarget = findClosestTarget()
            if not closestTarget then
                batCounterV2Debounce = false
                return
            end

            if isPlayerRagdolled(closestTarget) then
                batCounterV2Debounce = false
                return
            end

            if not playerHasTool(closestTarget) then
                batCounterV2Debounce = false
                return
            end
            isActive = batDesyncTpEnabled

            if not batDesyncTpEnabled then
                startBatDesyncTp()

                if tpBat then
                    tpBat(true)
                end
            end

            local function activateBatOnTarget()
                local character = localPlayer.Character
                if not character then
                    return
                end
                local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")

                if humanoidRootPart then
                    local character = closestTarget.Character
                    if not character then
                        return
                    end
                    local humanoidRootPart2 = character:FindFirstChild("HumanoidRootPart")

                    if not humanoidRootPart2 then
                        return
                    end

                    if not playerHasTool(closestTarget) then
                        batCounterV2Debounce = false
                        return
                    end

                    if sethiddenproperty then
                        sethiddenproperty(humanoidRootPart, "PhysicsRepRootPart", humanoidRootPart2)
                    end

                    local amount = humanoidRootPart2.Position + vector(0, 0.9, 0)

                    if (humanoidRootPart.Position - amount).Magnitude > 8 then
                        humanoidRootPart.CFrame = cframe(amount)
                    end

                    triggerBatCounter()

                    task.delay(0.05, function()
                        triggerBatCounter()
                    end)

                    task.delay(0.1, function()
                        triggerBatCounter()
                    end)

                    return
                end
            end

            activateBatOnTarget()

            task.delay(0.2, function()
                if not isActive and batDesyncTpEnabled then
                    stopBatDesyncTp()

                    if tpBat then
                        tpBat(false)
                    end
                end

                batCounterV2Debounce = false
            end)
        end

        stopBatCounterV2 = function()
            if batCounterV2Conn then
                batCounterV2Conn:Disconnect()
                batCounterV2Conn = nil
            end

            batCounterV2Debounce = false
            batCounterV2HitCooldown = false
        end

        startBatCounterV2 = function()
            if batCounterV2Conn then
                return
            end

            batCounterV2Conn = RunService.Heartbeat:Connect(function()
                if not batCounterV2Enabled then
                    return
                end

                if batCounterV2Debounce then
                    return
                end
                local character = localPlayer.Character
                if not character then
                    return
                end
                local humanoid = character:FindFirstChildOfClass("Humanoid")
                if not humanoid or humanoid.Health <= 0 then
                    return
                end
                local state = humanoid:GetState()

                if state == Enum.HumanoidStateType.Physics or state == Enum.HumanoidStateType.Ragdoll or state == Enum.HumanoidStateType.FallingDown or state == Enum.HumanoidStateType.GettingUp or state == Enum.HumanoidStateType.Stunned then
                    local closestTarget = findClosestTarget()

                    if closestTarget then
                        if not isPlayerRagdolled(closestTarget) then
                            if playerHasTool(closestTarget) then
                                fireBatCounter()
                            end
                        end
                    end
                end
            end)
        end
    end
end

do
    toggleBatCounterV2 = function()
        batCounterV2Enabled = not batCounterV2Enabled

        if batCounterV2Enabled then
            startBatCounterV2()
        else
            stopBatCounterV2()
        end

        return batCounterV2Enabled
    end

    updateUIFromLoaded = function()
        task.wait()

        if normalBox then
            normalBox.Text = tostring(NORMAL_SPEED)
        end

        if carryBox then
            carryBox.Text = tostring(CARRY_SPEED)
        end

        if radInput then
            radInput.Text = tostring(CONFIG.STEAL_RANGE)
        end

        if laggerBox then
            laggerBox.Text = tostring(LAGGER_SPEED)
        end

        if lagger2Box then
            lagger2Box.Text = tostring(LAGGER_CARRY_SPEED)
        end

        if batSpeedBox then
            batSpeedBox.Text = tostring(BAT_AIMBOT_SPEED)
        end

        if uiScaleBox then
            uiScaleBox.Text = tostring(uiScaleValue)
        end

        if dropModeBtnRef then
            dropModeBtnRef.Text = dropMode == 1 and "Fling" or "Jump Drop"
        end

        if bodyLockRangeBox then
            bodyLockRangeBox.Text = tostring(bodyLockRange)
        end

        refreshSpeedModeLabel()

        for _, keyButtonRef in ipairs(keyButtonRefs) do
            local entry = keyButtonRef.entry
            keyButtonRef.btn.Text = entry.gp and entry.gp.Name or entry.kb and entry.kb.Name or "None"
        end

        if savedProgressBarPos and pbFrame then
            pbFrame.Position = UDim2.new(savedProgressBarPos.XScale or 0.5, savedProgressBarPos.XOffset or -134, savedProgressBarPos.YScale or 0.8, savedProgressBarPos.YOffset or 0)
        end

        applyBackgroundMode(backgroundMode)
        applyFloatingButtonScale()

        if uiLocked and setLockUIVisual then
            setLockUIVisual(true)
        end

        if antiRagdollMode == "v2" then
            if setAntiRagVisual then
                setAntiRagVisual(true)
            end

            startAntiRagdoll()
        elseif setAntiRagVisual then
            setAntiRagVisual(false)
        end

        if antiDieEnabled then
            if setAntiDieVisual then
                setAntiDieVisual(true)
            end

            AntiDieModule.start()
        elseif setAntiDieVisual then
            setAntiDieVisual(false)
        end

        if antiBatEnabled then
            if setAntiBatVisual then
                setAntiBatVisual(true)
            end

            startAntiBat()
        elseif setAntiBatVisual then
            setAntiBatVisual(false)
        end

        if antiFlingEnabled then
            if setAntiFlingVisual then
                setAntiFlingVisual(true)
            end

            startAntiFling()
        else
            if setAntiFlingVisual then
                setAntiFlingVisual(false)
            end

            stopAntiFling()
        end

        if CONFIG.AUTO_STEAL_ENABLED and setInstaGrab then
            setInstaGrab(true)
            pcall(startAutoSteal)
        end

        if medusaCounterEnabled then
            if setMedusaVisual then
                setMedusaVisual(true)
            end

            if localPlayer.Character then
                setupMedusaCounter(localPlayer.Character)
            end
        else
            if setMedusaVisual then
                setMedusaVisual(false)
            end

            stopMedusaCounter()
        end

        if batCounterEnabled and setBatCounterVisual then
            setBatCounterVisual(true)
            startBatCounter()
        end

        if batCounterV2Enabled and setBatCounterV2Visual then
            setBatCounterV2Visual(true)
            startBatCounterV2()
        end

        if unwalkEnabled and setUnwalkVisual then
            setUnwalkVisual(true)

            task.spawn(function()
                task.wait(0.5)
                startUnwalk()
            end)
        end

        if antiLagEnabled then
            if setAntiLagVisual then
                setAntiLagVisual(true)
            end

            enableAntiLag()
        else
            if setAntiLagVisual then
                setAntiLagVisual(false)
            end

            disableAntiLag()
        end

        if isEspActive then
            toggleESP(true)

            if setESPVIsual then
                setESPVIsual(true)
            end
        else
            toggleESP(false)

            if setESPVIsual then
                setESPVIsual(false)
            end
        end

        if espLineEnabled then
            if setESPLineVisual then
                setESPLineVisual(true)
            end

            startESPLine()
        else
            if setESPLineVisual then
                setESPLineVisual(false)
            end

            stopESPLine()
        end

        if vividGraphicsEnabled then
            enableVividGraphics()

            if setVividVisual then
                setVividVisual(true)
            end
        else
            disableVividGraphics()

            if setVividVisual then
                setVividVisual(false)
            end
        end

        if batDesyncTpEnabled then
            if tpBat then
                tpBat(true)
            end

            if not connection then
                startBatDesyncTp()
            end

            refreshTpBatButton(true)
        else
            if tpBat then
                tpBat(false)
            end

            refreshTpBatButton(false)
        end

        if stretchEnabled then
            enableStretch()

            if _G.stretchToggleSetter then
                _G.stretchToggleSetter(true)
            end
        elseif _G.stretchToggleSetter then
            _G.stretchToggleSetter(false)
        end

        if mobSetAutoBat then
            mobSetAutoBat(autoBatEnabled)
        end

        if mobSetAutoLeft then
            mobSetAutoLeft(autoLeftEnabled)
        end

        if mobSetAutoRight then
            mobSetAutoRight(autoRightEnabled)
        end

        if mobSetCarry then
            mobSetCarry(speedMode)
        end

        if mobSetLagger1 then
            mobSetLagger1(laggerToggled)
        end

        if mobSetLagger2 then
            mobSetLagger2(laggerCarryToggled)
        end

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
        toggleLockUI(uiLocked)

        pcall(function()
            applyOutfitByIndex(outfitIndex)
        end)

        if textLabel then
            textLabel.Text = outfitPresets[outfitIndex].label
        end
    end

    do
        local entries = {}

        local function runBootStep(target, callback)

            local success, result = pcall(callback)

            if not success then
                table.insert(entries, { name = target, err = tostring(result) })
            else
            end

            return success
        end

        runBootStep("buildGui", function()
            buildGui()
        end)

        if gui and main then
            runBootStep("loadAllSettings", function()
                if loadAllSettings() then
                    updateUIFromLoaded()
                end
            end)

            runBootStep("createMobilePanel", function()
                mobilePanel = createMobilePanel()
            end)

            runBootStep("createBatV2FloatingButton", function()
                batV2FloatingButton = createBatV2FloatingButton()
            end)

            runBootStep("createTpBatFloatingButton", function()
                tpBatFloatingButton = createTpBatFloatingButton()
            end)

            runBootStep("createInstaResetFloatingButton", function()
                instaResetFloatingButton = createInstaResetFloatingButton()
            end)

            if hideButtonsEnabled then
                runBootStep("applyHideButtons", function()
                    applyHideButtons(true)

                    if setHideButtonsVisual then
                        setHideButtonsVisual(true)
                    end
                end)
            end

            runBootStep("localizeYoutInterface", function()
                if gui then
                    recolorTextDescendants(gui)
                end

                if mobilePanel then
                    recolorTextDescendants(mobilePanel)
                end

                if batV2FloatingButton then
                    recolorTextDescendants(batV2FloatingButton)
                end

                if tpBatFloatingButton then
                    recolorTextDescendants(tpBatFloatingButton)
                end

                if instaResetFloatingButton then
                    recolorTextDescendants(instaResetFloatingButton)
                end
            end)

            if localPlayer.Character then
                task.spawn(function()
                    task.wait(0.1)

                    if waitForCharacterReady(localPlayer.Character, 5) then
                        pcall(function()
                            captureOriginalOutfit(localPlayer.Character)
                        end)

                        pcall(function()
                            setupMovementAndIndicators(localPlayer.Character)
                        end)

                        if currentAnimPack ~= "Off" then
                            pcall(function()
                                applyAnimationPack(currentAnimPack)
                            end)
                        end

                        pcall(function()
                            applyOutfitByIndex(outfitIndex)
                        end)
                    end
                end)
            end

            if #entries > 0 then
                task.defer(function()
                    pcall(function()
                        local writefile_ = (getgenv and getgenv() or _G).writefile or syn and syn.writefile

                        if type(writefile_) == "function" then
                            local text = "[Y-out Boot Errors] " .. os.date("%Y-%m-%d %H:%M:%S") .. "\n"

                            for _, entry in ipairs(entries) do
                                text ..= entry.name .. ": " .. entry.err .. "\n"
                            end

                            pcall(writefile_, "Yout_boot_errors.txt", text)
                        end
                    end)
                end)

                task.defer(function()
                    pcall(function()
                        local screenGui = Instance.new("ScreenGui")
                        screenGui.Name = "YoutBootErrors"
                        screenGui.ResetOnSpawn = false
                        screenGui.DisplayOrder = 999

                        local success, parent = pcall(function()
                            return game:GetService("CoreGui")
                        end)

                        if success and parent then
                            pcall(function()
                                screenGui.Parent = parent
                            end)
                        end

                        if not screenGui.Parent then
                            screenGui.Parent = localPlayer:WaitForChild("PlayerGui")
                        end

                        local frame = Instance.new("Frame", screenGui)
                        frame.Size = UDim2.new(0, 460, 0, 60 + #entries * 22)
                        frame.Position = UDim2.new(0, 10, 1, -80 - #entries * 22)
                        frame.BackgroundColor3 = Color3.fromRGB(40, 10, 15)
                        frame.BorderSizePixel = 0
                        Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)
                        local uiStroke = Instance.new("UIStroke", frame)
                        uiStroke.Color = Color3.fromRGB(255, 80, 90)
                        uiStroke.Thickness = 1.5
                        local textLabel2 = Instance.new("TextLabel", frame)
                        textLabel2.Size = UDim2.new(1, -20, 0, 24)
                        textLabel2.Position = UDim2.new(0, 10, 0, 8)
                        textLabel2.BackgroundTransparency = 1
                        textLabel2.Text = "⚠ Y-out: " .. #entries .. " sección(es) fallaron"
                        textLabel2.TextColor3 = Color3.fromRGB(255, 100, 110)
                        textLabel2.Font = Enum.Font.GothamBold
                        textLabel2.TextSize = 13
                        textLabel2.TextXAlignment = Enum.TextXAlignment.Left

                        for entry, entry2 in ipairs(entries) do
                            local textLabel2 = Instance.new("TextLabel", frame)
                            textLabel2.Size = UDim2.new(1, -20, 0, 18)
                            textLabel2.Position = UDim2.new(0, 10, 0, 34 + (entry - 1) * 20)
                            textLabel2.BackgroundTransparency = 1
                            textLabel2.Text = "• " .. entry2.name .. ": " .. entry2.err:sub(1, 110)
                            textLabel2.TextColor3 = Color3.fromRGB(255, 180, 180)
                            textLabel2.Font = Enum.Font.Code
                            textLabel2.TextSize = 10
                            textLabel2.TextXAlignment = Enum.TextXAlignment.Left
                            textLabel2.TextTruncate = Enum.TextTruncate.AtEnd
                        end

                        local textButton = Instance.new("TextButton", frame)
                        textButton.Size = UDim2.new(0, 100, 0, 22)
                        textButton.Position = UDim2.new(0, 10, 1, -30)
                        textButton.BackgroundColor3 = Color3.fromRGB(80, 20, 30)
                        textButton.Text = "COPIAR LOG"
                        textButton.TextColor3 = Color3.fromRGB(255, 200, 200)
                        textButton.Font = Enum.Font.GothamBold
                        textButton.TextSize = 11
                        textButton.BorderSizePixel = 0
                        Instance.new("UICorner", textButton).CornerRadius = UDim.new(0, 6)

                        textButton.MouseButton1Click:Connect(function()
                            local text = ""

                            for _, entry in ipairs(entries) do
                                text ..= entry.name .. ": " .. entry.err .. "\n"
                            end

                            pcall(function()
                                if setclipboard then
                                    setclipboard(text)
                                end
                            end)

                            textButton.Text = "¡COPIADO!"

                            task.delay(1.2, function()
                                textButton.Text = "COPIAR LOG"
                            end)
                        end)

                        local textButton = Instance.new("TextButton", frame)
                        textButton.Size = UDim2.new(0, 60, 0, 22)
                        textButton.Position = UDim2.new(1, -70, 1, -30)
                        textButton.BackgroundColor3 = Color3.fromRGB(80, 20, 30)
                        textButton.Text = "CERRAR"
                        textButton.TextColor3 = Color3.fromRGB(255, 200, 200)
                        textButton.Font = Enum.Font.GothamBold
                        textButton.TextSize = 11
                        textButton.BorderSizePixel = 0
                        Instance.new("UICorner", textButton).CornerRadius = UDim.new(0, 6)

                        textButton.MouseButton1Click:Connect(function()
                            pcall(function()
                                screenGui:Destroy()
                            end)
                        end)

                        task.delay(60, function()
                            pcall(function()
                                screenGui:Destroy()
                            end)
                        end)
                    end)
                end)
            end
        else
        end
    end
end

local handleKeyPress

do
    if localPlayer and localPlayer.CharacterAdded then
        pcall(function()
            local counter = 0

            localPlayer.CharacterAdded:Connect(function(character)
                pcall(function()
                    counter += 1
                    local capturedN33 = counter

                    if stealConnection then
                        stealConnection:Disconnect()
                        stealConnection = nil
                    end

                    isStealInProgress = false

                    if stopAutoLeft then
                        stopAutoLeft()
                    end

                    if stopAutoRight then
                        stopAutoRight()
                    end

                    if stopBatCounter then
                        stopBatCounter()
                    end

                    if stopBatCounterV2 then
                        stopBatCounterV2()
                    end

                    if stopMedusaCounter then
                        stopMedusaCounter()
                    end

                    if stopUnwalk then
                        stopUnwalk()
                    end

                    if stopDropBrainrot then
                        stopDropBrainrot()
                    end

                    if autoBatEnabled and disableAutoBat then
                        disableAutoBat()
                    end

                    local capturedBatDesyncTpEnabled = batDesyncTpEnabled

                    if batDesyncTpEnabled and stopBatDesyncTp then
                        stopBatDesyncTp()
                    end

                    if bodyLockEnabled and stopBodyLock then
                        stopBodyLock()
                    end

                    local time = getTime() + 5

                    while not character.Parent or not character:FindFirstChild("HumanoidRootPart") or not character:FindFirstChildOfClass("Humanoid") do
                        if getTime() > time then
                            return
                        end

                        if capturedN33 ~= counter then
                            return
                        end
                        task.wait(0.05)
                    end

                    velocityWriteLog = {}
                    local value = attachVelocityHookToRoot(character)
                    installVelocityHook(value)

                    if not originalOutfit then
                        task.defer(function()
                            captureOriginalOutfit(character)
                        end)
                    end

                    if setupMovementAndIndicators then
                        setupMovementAndIndicators(character)
                    end

                    if antiRagdollMode == "v2" then
                        startAntiRagdoll()
                    end

                    if antiBatEnabled then
                        startAntiBat()
                    end

                    if antiFlingEnabled then
                        startAntiFling()
                    end

                    if AntiDieModule.enabled then
                        task.defer(function()
                            activateOnCharacter(character)
                        end)
                    end

                    if CONFIG.AUTO_STEAL_ENABLED then
                        pcall(startAutoSteal)
                    end

                    if capturedBatDesyncTpEnabled then
                        task.defer(startBatDesyncTp)
                    end

                    if bodyLockEnabled and _blSuppressCount == 0 then
                        startBodyLock()
                    end

                    if medusaCounterEnabled then
                        setupMedusaCounter(character)

                        if setMedusaVisual then
                            setMedusaVisual(true)
                        end
                    else
                        stopMedusaCounter()

                        if setMedusaVisual then
                            setMedusaVisual(false)
                        end
                    end

                    if batCounterEnabled then
                        startBatCounter()
                    end

                    if batCounterV2Enabled then
                        startBatCounterV2()
                    end

                    if unwalkEnabled then
                        startUnwalk()
                    end

                    if currentAnimPack ~= "Off" then
                        task.wait(0.3)
                        applyAnimationPack(currentAnimPack)
                    end

                    updateProgressBarVisibility()
                    refreshSpeedModeLabel()

                    pcall(function()
                        applyOutfitByIndex(outfitIndex)
                    end)

                    if textLabel then
                        textLabel.Text = outfitPresets[outfitIndex].label
                    end
                end)
            end)
        end)
    end

    do
        local counter = 0

        handleKeyPress = function(enabled)
            if not enabled or enabled == Enum.KeyCode.Unknown then
                return
            end

            if kbMatch(KEYBINDS.LaggerMode, enabled) then
                if getTime() - counter >= 0.3 then
                    counter = getTime()
                    toggleLaggerCycle()
                end

                return
            end

            if kbMatch(KEYBINDS.CarryToggle, enabled) then
                toggleCarryMode()
                return
            end

            if kbMatch(KEYBINDS.DropBrainrot, enabled) then
                if not dropActive then
                    if dropBrainrotSetVisual then
                        dropBrainrotSetVisual(true)
                    end

                    executeDropWithToggle(dropBrainrotSetVisual)
                end

                return
            end

            if kbMatch(KEYBINDS.TPFloor, enabled) then
                doTpDown()
                return
            end

            if kbMatch(KEYBINDS.InstaReset, enabled) then
                if _G.InstaReset and _G.InstaReset.Trigger then
                    _G.InstaReset.Trigger()
                end

                return
            end

            if kbMatch(KEYBINDS.AutoLeft, enabled) then
                autoLeftEnabled = not autoLeftEnabled

                if autoLeftEnabled then
                    startAutoLeft()
                else
                    stopAutoLeft()
                end

                if autoLeftSetVisual then
                    autoLeftSetVisual(autoLeftEnabled)
                end

                if mobSetAutoLeft then
                    mobSetAutoLeft(autoLeftEnabled)
                end

                return
            end

            if kbMatch(KEYBINDS.AutoRight, enabled) then
                autoRightEnabled = not autoRightEnabled

                if autoRightEnabled then
                    startAutoRight()
                else
                    stopAutoRight()
                end

                if autoRightSetVisual then
                    autoRightSetVisual(autoRightEnabled)
                end

                if mobSetAutoRight then
                    mobSetAutoRight(autoRightEnabled)
                end

                return
            end

            if kbMatch(KEYBINDS.AutoBat, enabled) then
                if not autoBatEnabled then
                    enableAutoBat()

                    if autoBatSetVisual then
                        autoBatSetVisual(true)
                    end

                    if mobSetAutoBat then
                        mobSetAutoBat(true)
                    end
                else
                    disableAutoBat()

                    if autoBatSetVisual then
                        autoBatSetVisual(false)
                    end

                    if mobSetAutoBat then
                        mobSetAutoBat(false)
                    end
                end

                return
            end

            if kbMatch(KEYBINDS.BatV2, enabled) then
                if youtBatV2PersistentState.enabled then
                    stopYoutBatV2()
                else
                    startYoutBatV2()
                end

                return
            end

            if kbMatch(KEYBINDS.TPBat, enabled) then
                toggleBatDesyncTp()

                if tpBat then
                    tpBat(batDesyncTpEnabled)
                end

                if tpBatFloatingButton then
                    local frame = tpBatFloatingButton:FindFirstChild("Frame")

                    if frame then
                        paintFloatingBtn(frame, batDesyncTpEnabled)
                    end
                end

                return
            end

            if kbMatch(KEYBINDS.GuiHide, enabled) then
                if main then
                    if main.Visible then
                        hideGui()
                    else
                        showGui()
                    end
                end

                return
            end
        end
    end
end

do
    local entries = {}

    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if _anyKeyListening then
            return
        end

        if input.UserInputType == Enum.UserInputType.Keyboard then
            if gameProcessed or UserInputService:GetFocusedTextBox() then
                return
            end
        elseif not isGamepadInput(input) then
            return
        end

        if not isBindableInput(input) then
            return
        end
        local keyCode = input.KeyCode

        if keyCode == Enum.KeyCode.ButtonL2 or keyCode == Enum.KeyCode.ButtonR2 then
            entries[keyCode.Name] = true
        end

        handleKeyPress(keyCode)
    end)

    UserInputService.InputChanged:Connect(function(input)
        if _anyKeyListening or not isGamepadInput(input) then
            return
        end
        local keyCode = input.KeyCode
        if keyCode ~= Enum.KeyCode.ButtonL2 and keyCode ~= Enum.KeyCode.ButtonR2 then
            return
        end
        local z = input.Position.Z
        local name = keyCode.Name

        if z >= 0.45 then
            if not entries[name] then
                entries[name] = true
                handleKeyPress(keyCode)
            end
        elseif z <= 0.15 then
            entries[name] = false
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        local keyCode = input.KeyCode

        if keyCode == Enum.KeyCode.ButtonL2 or keyCode == Enum.KeyCode.ButtonR2 then
            entries[keyCode.Name] = false
        end
    end)
end