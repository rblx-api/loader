-- A previous copy could set this flag and then stop while waiting for a
-- game-specific object. Clear that stale state so a fixed copy can start.
if _G.EliteFamilyRunning then
    warn("[ELITE FAMILY] Instancia previa detectada. Se recomienda rejoin si hay comportamiento errático.")
end
_G.EliteFamilyRunning = false
_G.__EliteFamilyMainOriginalPos = nil

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local TS = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local HS = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local LP = Players.LocalPlayer
if not LP then
    local _lpConn
    _lpConn = Players.PlayerAdded:Connect(function(p) LP = p end)
    local _t0 = tick()
    while not LP and tick() - _t0 < 15 do task.wait(0.1) end
    if _lpConn then _lpConn:Disconnect() end
end
if not LP then
    warn("[ELITE FAMILY] LocalPlayer no disponible en 15s. Abortando.")
    return
end

local pgui = LP:WaitForChild("PlayerGui", 20)
if not pgui then
    warn("[ELITE FAMILY] PlayerGui no cargó en 20s. Abortando.")
    return
end

-- Intro estilo PRIME VACA (animación + música + SKIP)
local function playEliteFamilyIntro()
    local parent = pgui
    if not parent then
        _G.EliteFamilyIntroFinished = true
        return
    end

    pcall(function()
        for _, n in ipairs({
            "VioletGifIntroVertical","RubyGifIntroVertical","BlessVSGifIntroVertical",
            "IrishGifIntroVertical","SoulHubIntro","BlessVSIntro","PrimeVacaIntro","EliteFamilyIntro"
        }) do
            local old = parent:FindFirstChild(n)
            if old then old:Destroy() end
        end
    end)

    local INTRO_MUSIC_URL = "https://files.catbox.moe/4inuat.mp3"
    local MUSIC_FILE = "AmbitiousHubIntroSong1.mp3"

    local introGui = Instance.new("ScreenGui")
    introGui.Name = "EliteFamilyIntro"
    introGui.ResetOnSpawn = false
    introGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    introGui.DisplayOrder = 2147483647
    introGui.IgnoreGuiInset = true
    introGui.Parent = parent

    local bg = Instance.new("Frame", introGui)
    bg.Size = UDim2.new(1, 0, 1, 0)
    bg.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    bg.BorderSizePixel = 0
    bg.ZIndex = 1

    local skipBtn = Instance.new("TextButton", introGui)
    skipBtn.AnchorPoint = Vector2.new(1, 0)
    skipBtn.Position = UDim2.new(1, -16, 0, 16)
    skipBtn.Size = UDim2.new(0, 88, 0, 30)
    skipBtn.BackgroundColor3 = Color3.fromRGB(12, 18, 32)
    skipBtn.BackgroundTransparency = 0.15
    skipBtn.BorderSizePixel = 0
    skipBtn.Text = "SKIP >>"
    skipBtn.TextColor3 = Color3.fromRGB(180, 210, 255)
    skipBtn.TextSize = 12
    skipBtn.Font = Enum.Font.GothamBold
    skipBtn.AutoButtonColor = false
    skipBtn.ZIndex = 80
    Instance.new("UICorner", skipBtn).CornerRadius = UDim.new(0, 8)
    local skipStroke = Instance.new("UIStroke", skipBtn)
    skipStroke.Color = Color3.fromRGB(80, 140, 255)
    skipStroke.Thickness = 1
    skipStroke.Transparency = 0.35

    local function mkLine(yScale, transparency)
        local line = Instance.new("Frame", bg)
        line.AnchorPoint = Vector2.new(0.5, 0.5)
        line.Position = UDim2.new(0.5, 0, yScale, 0)
        line.Size = UDim2.new(0, 0, 0, 2)
        line.BackgroundColor3 = Color3.fromRGB(60, 120, 255)
        line.BackgroundTransparency = transparency or 0.15
        line.BorderSizePixel = 0
        line.ZIndex = 5
        return line
    end
    local lineTop = mkLine(0.42, 0.2)
    local lineMidL = mkLine(0.5, 0.1)
    local lineMidR = mkLine(0.5, 0.1)
    lineMidL.AnchorPoint = Vector2.new(1, 0.5)
    lineMidL.Position = UDim2.new(0.48, 0, 0.5, 0)
    lineMidR.AnchorPoint = Vector2.new(0, 0.5)
    lineMidR.Position = UDim2.new(0.52, 0, 0.5, 0)

    local function mkText(txt, size)
        local lbl = Instance.new("TextLabel", bg)
        lbl.AnchorPoint = Vector2.new(0.5, 0.5)
        lbl.Position = UDim2.new(0.5, 0, 0.5, 0)
        lbl.Size = UDim2.new(0.92, 0, 0, size + 20)
        lbl.BackgroundTransparency = 1
        lbl.Text = txt
        lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
        lbl.TextTransparency = 1
        lbl.Font = Enum.Font.GothamBlack
        lbl.TextSize = size
        lbl.TextScaled = false
        lbl.ZIndex = 20
        local st = Instance.new("UIStroke", lbl)
        st.Color = Color3.fromRGB(30, 80, 200)
        st.Thickness = 2.5
        st.Transparency = 1
        return lbl, st
    end

    local qLabel, qStroke = mkText("LUCK. VS IS GOOD??", 52)
    local noLabel, noStroke = mkText("NO!", 64)
    local brandLabel, brandStroke = mkText("ELITE FAMILY", 58)

    local introCompleteEvent = Instance.new("BindableEvent")
    local introActive = true
    local introSound = nil

    local function finishIntro()
        if not introActive then return end
        introActive = false
        if introSound then
            pcall(function()
                TS:Create(introSound, TweenInfo.new(0.3), {Volume = 0}):Play()
            end)
            task.delay(0.35, function()
                pcall(function() introSound:Stop(); introSound:Destroy() end)
            end)
        end
        pcall(function() introGui:Destroy() end)
        introCompleteEvent:Fire()
        _G.EliteFamilyIntroFinished = true
    end
    skipBtn.MouseButton1Click:Connect(finishIntro)

    -- Música intro (igual que PRIME VACA)
    task.spawn(function()
        local env = (getgenv and getgenv()) or _G
        local getAsset = env.getcustomasset or getcustomasset or (syn and syn.getcustomasset)
        local writeFn = env.writefile or writefile or (syn and syn.writefile)
        local hasFile = env.isfile or isfile or (syn and syn.isfile)
        local asset
        if writeFn and getAsset then
            local needDownload = true
            if hasFile then
                local okHas = pcall(function() needDownload = not hasFile(MUSIC_FILE) end)
                if not okHas then needDownload = true end
            end
            if needDownload then
                local ok, data = pcall(function() return game:HttpGet(INTRO_MUSIC_URL) end)
                if ok and data then pcall(function() writeFn(MUSIC_FILE, data) end) end
            end
            local okA, a = pcall(function() return getAsset(MUSIC_FILE) end)
            if okA then asset = a end
        end
        if not asset or not introActive then return end
        local snd = Instance.new("Sound")
        snd.Name = "EliteFamilyPrimeIntroMusic"
        snd.SoundId = asset
        snd.Volume = 0.85
        snd.Looped = false
        snd.Parent = game:GetService("SoundService")
        introSound = snd
        pcall(function() snd:Play() end)
    end)

    -- Secuencia de animación (PRIME VACA)
    task.spawn(function()
        task.wait(0.25)
        if not introActive then return end

        -- Expandir líneas
        TS:Create(lineTop, TweenInfo.new(0.55, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
            Size = UDim2.new(0.35, 0, 0, 2)
        }):Play()
        TS:Create(lineMidL, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
            Size = UDim2.new(0.18, 0, 0, 2)
        }):Play()
        TS:Create(lineMidR, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
            Size = UDim2.new(0.18, 0, 0, 2)
        }):Play()
        task.wait(0.45)
        if not introActive then return end

        -- "LUCK. VS IS GOOD??"
        TS:Create(qLabel, TweenInfo.new(0.45, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {TextTransparency = 0}):Play()
        TS:Create(qStroke, TweenInfo.new(0.4), {Transparency = 0.15}):Play()
        task.wait(1.35)
        if not introActive then return end

        TS:Create(qLabel, TweenInfo.new(0.22), {TextTransparency = 1}):Play()
        TS:Create(qStroke, TweenInfo.new(0.22), {Transparency = 1}):Play()
        task.wait(0.28)
        if not introActive then return end

        -- "NO!"
        TS:Create(noLabel, TweenInfo.new(0.28, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {TextTransparency = 0}):Play()
        TS:Create(noStroke, TweenInfo.new(0.25), {Transparency = 0.1}):Play()
        task.wait(0.95)
        if not introActive then return end

        TS:Create(noLabel, TweenInfo.new(0.2), {TextTransparency = 1}):Play()
        TS:Create(noStroke, TweenInfo.new(0.2), {Transparency = 1}):Play()
        task.wait(0.25)
        if not introActive then return end

        -- "ELITE FAMILY"
        brandLabel.TextColor3 = Color3.fromRGB(90, 150, 255)
        TS:Create(brandLabel, TweenInfo.new(0.55, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {TextTransparency = 0}):Play()
        TS:Create(brandStroke, TweenInfo.new(0.5), {Transparency = 0.2}):Play()
        TS:Create(lineMidL, TweenInfo.new(0.4), {Size = UDim2.new(0.22, 0, 0, 2)}):Play()
        TS:Create(lineMidR, TweenInfo.new(0.4), {Size = UDim2.new(0.22, 0, 0, 2)}):Play()
        task.wait(2.4)
        if not introActive then return end

        TS:Create(brandLabel, TweenInfo.new(0.45), {TextTransparency = 1}):Play()
        TS:Create(brandStroke, TweenInfo.new(0.4), {Transparency = 1}):Play()
        TS:Create(lineTop, TweenInfo.new(0.4), {BackgroundTransparency = 1}):Play()
        TS:Create(lineMidL, TweenInfo.new(0.4), {BackgroundTransparency = 1}):Play()
        TS:Create(lineMidR, TweenInfo.new(0.4), {BackgroundTransparency = 1}):Play()
        TS:Create(bg, TweenInfo.new(0.55), {BackgroundTransparency = 1}):Play()
        task.wait(0.6)
        finishIntro()
    end)

    -- Timeout de seguridad
    task.delay(12, function()
        if introActive then finishIntro() end
    end)

    introCompleteEvent.Event:Wait()
    pcall(function() introCompleteEvent:Destroy() end)
end

_G.EliteFamilyIntroFinished = false
task.spawn(playEliteFamilyIntro)
local camera = Workspace.CurrentCamera

_G.EliteFamilyRunning = true
_G.EliteFamilySession = (_G.EliteFamilySession or 0) + 1
local _mySession = _G.EliteFamilySession

local ELITE_LANGUAGE = "en"

local ELITE_TRANSLATIONS = {
    es = { ["RESET ALL SETTINGS"]="RESTABLECER TODO", ["SETTINGS RESET"]="AJUSTES RESTABLECIDOS", ["CONFIRM?"]="¿CONFIRMAR?", ["ERROR"]="ERROR", ["Reset All Keybinds"]="RESTABLECER TECLAS", ["RESET"]="RESTABLECER", ["Keybinds"]="TECLAS", ["Carry Mode"]="MODO CARGAR", ["Lagger Mode"]="MODO LAG", ["Auto Left"]="AUTO IZQUIERDA", ["Auto Right"]="AUTO DERECHA", ["Auto Bat"]="AUTO BATE", ["TP BAT"]="TP BATE", ["Insta Reset"]="REINICIO RÁPIDO", ["TP Down"]="TP ABAJO", ["Drop Brainrot"]="SOLTAR BRAINROT", ["Hide GUI"]="OCULTAR MENÚ", ["Normal Speed"]="VELOCIDAD NORMAL", ["Carry Speed"]="VELOCIDAD CARGAR", ["Current Mode"]="MODO ACTUAL", ["ACTIVATE"]="ACTIVAR" },
    pt = { ["RESET ALL SETTINGS"]="REDEFINIR TUDO", ["SETTINGS RESET"]="CONFIGURAÇÕES REDEFINIDAS", ["CONFIRM?"]="CONFIRMAR?", ["ERROR"]="ERRO", ["Reset All Keybinds"]="REDEFINIR TECLAS", ["RESET"]="REDEFINIR", ["Keybinds"]="TECLAS", ["Carry Mode"]="MODO CARREGAR", ["Auto Left"]="AUTO ESQUERDA", ["Auto Right"]="AUTO DIREITA", ["Hide GUI"]="OCULTAR MENU", ["Normal Speed"]="VELOCIDADE NORMAL", ["Carry Speed"]="VELOCIDADE CARREGAR", ["ACTIVATE"]="ATIVAR" },
    fr = { ["RESET ALL SETTINGS"]="RÉINITIALISER", ["SETTINGS RESET"]="PARAMÈTRES RÉINITIALISÉS", ["CONFIRM?"]="CONFIRMER ?", ["ERROR"]="ERREUR", ["Reset All Keybinds"]="RÉINITIALISER LES TOUCHES", ["RESET"]="RÉINITIALISER", ["Keybinds"]="RACCOURCIS", ["Carry Mode"]="MODE PORTER", ["Auto Left"]="AUTO GAUCHE", ["Auto Right"]="AUTO DROITE", ["Hide GUI"]="MASQUER LE MENU", ["Normal Speed"]="VITESSE NORMALE", ["Carry Speed"]="VITESSE PORTER", ["ACTIVATE"]="ACTIVER" },
    de = { ["RESET ALL SETTINGS"]="ALLES ZURÜCKSETZEN", ["SETTINGS RESET"]="EINSTELLUNGEN ZURÜCKGESETZT", ["CONFIRM?"]="BESTÄTIGEN?", ["ERROR"]="FEHLER", ["Reset All Keybinds"]="TASTEN ZURÜCKSETZEN", ["RESET"]="ZURÜCKSETZEN", ["Keybinds"]="TASTEN", ["Carry Mode"]="TRAGEMODUS", ["Auto Left"]="AUTO LINKS", ["Auto Right"]="AUTO RECHTS", ["Hide GUI"]="MENÜ AUSBLENDEN", ["Normal Speed"]="NORMALE GESCHWINDIGKEIT", ["Carry Speed"]="TRAGEGESCHWINDIGKEIT", ["ACTIVATE"]="AKTIVIEREN" },
}

local function localizeEliteFamilyInterface(root)
    local dictionary = ELITE_TRANSLATIONS[ELITE_LANGUAGE]
    if not dictionary or not root then return end
    for _, object in ipairs(root:GetDescendants()) do
        if object:IsA("TextLabel") or object:IsA("TextButton") then
            local source = object:GetAttribute("EliteSourceText") or object.Text
            object:SetAttribute("EliteSourceText", source)
            local translated = dictionary[source]
            if translated then object.Text = translated end
        end
    end
end

local function eliteTranslate(source)
    local dictionary = ELITE_TRANSLATIONS[ELITE_LANGUAGE]
    return (dictionary and dictionary[source]) or source
end

local _tick          = tick
local _clamp         = math.clamp
local _floor         = math.floor
local _abs           = math.abs
local _huge          = math.huge
local _sqrt          = math.sqrt
local _V3new         = Vector3.new
local _V3zero        = Vector3.zero
local _CFnew         = CFrame.new
local _CFlookAt      = CFrame.lookAt
local _RayParams_new = RaycastParams.new

local _GetPlayersCached
do
    local cache, cacheTime = nil, 0
    _GetPlayersCached = function()
        local now = _tick()
        if cache and now - cacheTime < 0.03 then return cache end
        cache = Players:GetPlayers()
        cacheTime = now
        return cache
    end
end

local function waitForCharReady(char, timeout)
    timeout = timeout or 5
    local deadline = _tick() + timeout
    while (not char) or (not char.Parent)
          or (not char:FindFirstChild("HumanoidRootPart"))
          or (not char:FindFirstChildOfClass("Humanoid")) do
        if _tick() > deadline then return false end
        task.wait(0.05)
    end
    return true
end

NS = 60
CS = 29
LAGGER_SPEED = 15
LAGGER_CARRY_SPEED = 24.5
MEDUSA_COOLDOWN = 25
BAT_AIMBOT_SPEED = 58
BYPASS_AIMBOT_SPEED = 60
CONFIG_FILE = "EliteFamily_" .. tostring(LP.UserId) .. ".json"
BAT_V2_HIT_DIST = 4.5
_isDraggingButton = false

backgroundIndex = 1
backgroundImages = {
    "79611797115410",  -- Elite Family original
    "129700697019613", -- Dacia Hub default
    "108697485255882", -- Dacia Hub 2
    "71211662493854",  -- Dacia Hub 3
    "118953269416540", -- Dacia Hub 4
    "76582249427748",  -- 404 Family bg 1
    "136208130767349",  -- 404 Family bg 2
    "126793180958099",  -- 404 Family bg 3
    "105542572852370",  -- 404 Family bg 4
    "128997600029394",  -- 404 Family bg 5
    "99420703803809",  -- 404 Family bg 6
    "117186687504218",  -- 404 Family bg 7
    "123015462349687",  -- 404 Family bg 8
    "111195293067618",  -- 404 Family bg 9
    "133619037676439",  -- 404 Family bg 10
    "116985758139639",  -- 404 Family bg 11
    "132062039944824",  -- 404 Family bg 12
    "139571679676131",  -- 404 Family bg 13
    "70418952815837",  -- 404 Family bg 14
}

backgroundImageTransparency = 0
backgroundMode = "Background 1"
backgroundSelectorLabel = nil
buttonBgIndex = 1
buttonBgImages = {
    "79611797115410",  -- Elite Family original
    "129700697019613", -- Dacia Hub default
    "108697485255882", -- Dacia Hub 2
    "71211662493854",  -- Dacia Hub 3
    "118953269416540", -- Dacia Hub 4
    "76582249427748",  -- 404 Family bg 1
    "136208130767349",  -- 404 Family bg 2
    "126793180958099",  -- 404 Family bg 3
    "105542572852370",  -- 404 Family bg 4
    "128997600029394",  -- 404 Family bg 5
    "99420703803809",  -- 404 Family bg 6
    "117186687504218",  -- 404 Family bg 7
    "123015462349687",  -- 404 Family bg 8
    "111195293067618",  -- 404 Family bg 9
    "133619037676439",  -- 404 Family bg 10
    "116985758139639",  -- 404 Family bg 11
    "132062039944824",  -- 404 Family bg 12
    "139571679676131",  -- 404 Family bg 13
    "70418952815837",  -- 404 Family bg 14
}
buttonBgMode = "Background 1"
buttonBgSelectorLabel = nil
floatingButtonScale = 1
_floatingUIScales = {}

function applyBackgroundMode(mode)
    if mode == "None" then
        backgroundMode = "None"
    else
        local n = tonumber(tostring(mode):match("%d+"))
        if not n or n < 1 then n = backgroundIndex or 1 end
        if n > #backgroundImages then n = #backgroundImages end
        if n < 1 then n = 1 end
        backgroundIndex = n
        backgroundMode = "Background " .. tostring(n)
    end
    if type(backgroundImageTransparency) ~= "number" then
        backgroundImageTransparency = 0
    end
    if main then
        main.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        local bgImage = main:FindFirstChild("BackgroundImage")
        if not bgImage then
            bgImage = Instance.new("ImageLabel")
            bgImage.Name = "BackgroundImage"
            bgImage.Size = UDim2.new(1, 0, 1, 0)
            bgImage.Position = UDim2.new(0, 0, 0, 0)
            bgImage.BackgroundTransparency = 1
            bgImage.ScaleType = Enum.ScaleType.Crop
            bgImage.ZIndex = 0
            bgImage.ClipsDescendants = true
            Instance.new("UICorner", bgImage).CornerRadius = UDim.new(0, 14)
            bgImage.Parent = main
        end
        -- Soft veil over art (create once)
        local bgVeil = main:FindFirstChild("BgVeil")
        if not bgVeil then
            bgVeil = Instance.new("Frame")
            bgVeil.Name = "BgVeil"
            bgVeil.Size = UDim2.new(1, 0, 1, 0)
            bgVeil.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
            bgVeil.BackgroundTransparency = 0.35
            bgVeil.BorderSizePixel = 0
            bgVeil.ZIndex = 2
            Instance.new("UICorner", bgVeil).CornerRadius = UDim.new(0, 14)
            local veilGrad = Instance.new("UIGradient", bgVeil)
            veilGrad.Rotation = 90
            veilGrad.Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0.00, 0.15),
                NumberSequenceKeypoint.new(0.35, 0.45),
                NumberSequenceKeypoint.new(1.00, 0.05),
            })
            bgVeil.Parent = main
        end
        if backgroundMode == "None" then
            main.BackgroundTransparency = 0
            bgImage.Image = ""
            bgImage.ImageTransparency = 1
            bgImage.Visible = false
            bgVeil.Visible = false
        else
            local aid = backgroundImages[backgroundIndex]
            if aid and tostring(aid) ~= "" then
                main.BackgroundTransparency = 1
                bgImage.Visible = true
                bgImage.Image = "rbxassetid://" .. tostring(aid)
                bgImage.ImageTransparency = (type(backgroundImageTransparency) == "number") and backgroundImageTransparency or 0.15
                bgImage.ScaleType = Enum.ScaleType.Crop
                bgImage.ZIndex = 1
                bgVeil.Visible = true
            else
                main.BackgroundTransparency = 0
                bgImage.Image = ""
                bgImage.ImageTransparency = 1
                bgImage.Visible = false
                bgVeil.Visible = false
                backgroundMode = "None"
            end
        end
    end
    if backgroundSelectorLabel then backgroundSelectorLabel.Text = backgroundMode end
end


function applyButtonBackgroundMode(mode)
    if mode == "None" then
        buttonBgMode = "None"
    else
        local n = tonumber(tostring(mode):match("%d+"))
        if not n or n < 1 then n = buttonBgIndex or 1 end
        if n > #buttonBgImages then n = #buttonBgImages end
        if n < 1 then n = 1 end
        buttonBgIndex = n
        buttonBgMode = "Background " .. tostring(n)
    end
    if buttonBgSelectorLabel then buttonBgSelectorLabel.Text = buttonBgMode end
    if refreshAllButtonBackgrounds then pcall(refreshAllButtonBackgrounds) end
    -- Re-pintar para que el gradiente no tape la imagen
    if MobilePanel then
        for _, btn in ipairs(MobilePanel:GetChildren()) do
            if btn:IsA("TextButton") then
                paintFloatingBtn(btn, btn:GetAttribute("MobActive") == true)
            end
        end
    end
    if tpBatFloatingButton then
        local fr = tpBatFloatingButton:FindFirstChild("Frame")
        if fr then paintFloatingBtn(fr, batDesyncTpEnabled) end
    end
    if batV2FloatingButton then
        local fr = batV2FloatingButton:FindFirstChild("Frame")
        if fr then paintFloatingBtn(fr, autoBatV2Enabled) end
    end
    if instaResetFloatingButton then
        local fr = instaResetFloatingButton:FindFirstChild("Frame")
        if fr then paintFloatingBtn(fr, false) end
    end
end

local COLOR_THEMES = {
    -- Elite Family
    ["Gray"] = Color3.fromRGB(180, 180, 190),
    ["Neon"] = Color3.fromRGB(20, 55, 120),
    ["Vanilla"] = Color3.fromRGB(212, 180, 135),
    -- Dacia Hub colours
    ["White"] = Color3.fromRGB(255, 255, 255),
    ["Red"] = Color3.fromRGB(255, 60, 60),
    ["Orange"] = Color3.fromRGB(255, 145, 30),
    ["Yellow"] = Color3.fromRGB(255, 230, 30),
    ["Green"] = Color3.fromRGB(60, 230, 90),
    ["Cyan"] = Color3.fromRGB(30, 220, 220),
    ["Blue"] = Color3.fromRGB(60, 130, 255),
    ["Purple"] = Color3.fromRGB(170, 80, 255),
    ["Pink"] = Color3.fromRGB(255, 100, 200),
    ["Black"] = Color3.fromRGB(150, 150, 160),
}
-- Stable cycle order for the Theme Color selector
local COLOR_THEME_ORDER = {
    "Neon", "Gray", "Vanilla", "White", "Red", "Orange", "Yellow",
    "Green", "Cyan", "Blue", "Purple", "Pink", "Black",
}

currentColorTheme = "Neon"
selectedColor = COLOR_THEMES["Neon"]

function getThemeColor() return selectedColor end

function eliteGradient(c)
    return ColorSequence.new({
        ColorSequenceKeypoint.new(0.00, c:Lerp(Color3.new(1,1,1), 0.55)),
        ColorSequenceKeypoint.new(0.45, c),
        ColorSequenceKeypoint.new(1.00, c:Lerp(Color3.new(0,0,0), 0.35)),
    })
end

function eliteGradientSoft(c)
    return ColorSequence.new({
        ColorSequenceKeypoint.new(0.00, c:Lerp(Color3.new(1,1,1), 0.75)),
        ColorSequenceKeypoint.new(0.50, c:Lerp(Color3.new(1,1,1), 0.25)),
        ColorSequenceKeypoint.new(1.00, c:Lerp(Color3.new(0,0,0), 0.15)),
    })
end

function eliteGradientDark(c)
    return ColorSequence.new({
        ColorSequenceKeypoint.new(0.00, c:Lerp(Color3.fromRGB(0,0,0), 0.35)),
        ColorSequenceKeypoint.new(0.55, c:Lerp(Color3.fromRGB(0,0,0), 0.65)),
        ColorSequenceKeypoint.new(1.00, c:Lerp(Color3.fromRGB(0,0,0), 0.80)),
    })
end

function applyEliteGradientToLabel(label, c)
    if not label then return end
    local grad = label:FindFirstChildOfClass("UIGradient")
    if not grad then
        grad = Instance.new("UIGradient", label)
    end
    grad.Rotation = 0
    grad.Color = eliteGradient(c)
end

local _lastThemeUpdate = 0
local _lastThemeColor = nil

function applyColorTheme(themeName)
    local color = COLOR_THEMES[themeName]
    if not color then return end
    currentColorTheme = themeName
    selectedColor = color
    updateAllUIThemeColors(color)
    saveAllSettings()
end

_uicStroke = nil
_uicAvatarStroke = nil
_uicHandle = nil
_uicLine = nil

function updateAllUIThemeColors(color)
    local now = _tick()
    if color == _lastThemeColor and now - _lastThemeUpdate < 0.1 then return end
    _lastThemeUpdate = now
    _lastThemeColor = color

    if progressFill then
        progressFill.BackgroundColor3 = color
        local grad = progressFill:FindFirstChildOfClass("UIGradient")
        if grad then
            grad.Color = eliteGradient(color)
            grad.Rotation = 0
        end
    end
    if pbFrame then
        local border = pbFrame:FindFirstChild("OuterStroke") or pbFrame:FindFirstChildOfClass("UIStroke")
        if border then border.Color = color end
        local fpsNeon = pbFrame:FindFirstChild("FPSNeon", true)
        if fpsNeon then fpsNeon.TextColor3 = color end
        local pingNeon = pbFrame:FindFirstChild("PingNeon", true)
        if pingNeon then pingNeon.TextColor3 = color end
        local divider = pbFrame:FindFirstChild("Divider", true)
        if divider and divider:IsA("Frame") then divider.BackgroundColor3 = color end
    end

    if _uicStroke then _uicStroke.Color = color end
    if _uicAvatarStroke then _uicAvatarStroke.Color = color end
    if _uicHandle then _uicHandle.TextColor3 = color end
    if _uicLine then _uicLine.BackgroundColor3 = color end

    local function searchAndUpdateText(parent)
        for _, child in ipairs(parent:GetDescendants()) do
            if child:IsA("TextLabel") then
                if child.Name == "DiscordText" or child.Name == "SpeedLabel" then
                    child.TextColor3 = color
                end
            end
            if child:IsA("UIStroke") then
                if child.Color == Color3.fromRGB(180, 180, 190) then child.Color = color end
            end
        end
    end
    if gui then searchAndUpdateText(gui) end
    if tpBatFloatingButton then
        paintFloatingBtn(tpBatFloatingButton:FindFirstChild("Frame"), batDesyncTpEnabled)
    end
    if batV2FloatingButton then
        paintFloatingBtn(batV2FloatingButton:FindFirstChild("Frame"), autoBatV2Enabled)
    end
    for _, tab in ipairs(tabButtons or {}) do
        local isActive = tab:FindFirstChild("Underline") and tab.Underline.Visible
        if isActive then
            tab.TextColor3 = Color3.fromRGB(245, 245, 255)
            tab.BackgroundColor3 = color
            tab.BackgroundTransparency = 0.15
            local tg = tab:FindFirstChild("TabBgGrad")
            if tg then tg.Color = eliteGradient(color) end
        else
            tab.TextColor3 = Color3.fromRGB(150, 150, 165)
            tab.BackgroundColor3 = Color3.fromRGB(26, 26, 34)
            tab.BackgroundTransparency = 1
        end
        local ul = tab:FindFirstChild("Underline")
        if ul then ul.BackgroundColor3 = color end
        local s = tab:FindFirstChild("TabStroke")
        if s then s.Color = color end
    end
    if _G.__EliteFamilyRefreshESPTheme then pcall(_G.__EliteFamilyRefreshESPTheme, color) end
    if main then
        local titleFrame = main:FindFirstChild("Frame")
        if titleFrame then
            for _, child in ipairs(titleFrame:GetDescendants()) do
                if child:IsA("UIStroke") and child.Color == Color3.fromRGB(180, 180, 190) then
                    child.Color = color
                end
            end
        end
    end
    if colorSelectorLabel then
        colorSelectorLabel.Text = currentColorTheme
        colorSelectorLabel.TextColor3 = color
    end

    if _G._eliteStealSlide then
        _G._eliteStealSlide.BackgroundColor3 = color
        local sg = _G._eliteStealSlide:FindFirstChildOfClass("UIGradient")
        if sg then sg.Color = eliteGradient(color) end
        local ss = _G._eliteStealSlide:FindFirstChildOfClass("UIStroke")
        if ss then ss.Color = color end
    end

    if miniBtn then
        local stroke = miniBtn:FindFirstChildOfClass("UIStroke")
        if stroke then stroke.Color = color end
    end

    if MobilePanel then
        for _, btn in ipairs(MobilePanel:GetChildren()) do
            if btn:IsA("TextButton") and btn:FindFirstChild("BtnGrad") then
                paintFloatingBtn(btn, btn:GetAttribute("MobActive") == true)
            end
        end
    end
end

local HOMERO_CFG = {
    body = { 10725826963, 86500008, 86500054, 86500036, 86500064, 86500078 },
    aplicarCuerpo = true,
    items = {
        { id = 103227869700418, offset = _CFnew(0,0,0) },
        { id = 84952305140948,   offset = _CFnew(0,0,0) },
        { id = 122465238537030,  offset = _CFnew(0,0,0) },
    },
    shirt = nil,
    pants = "rbxassetid://78591690208112",
    skinColor = Color3.fromRGB(234,184,146),
    headColor = Color3.fromRGB(0,0,0),
}

local TAG = "LocalOutfit_"

local function loadObjects(id)
    local ok, res = pcall(function()
        return game:GetObjects("rbxassetid://" .. tostring(id))
    end)
    if ok and typeof(res) == "table" and #res > 0 then return res end
    ok, res = pcall(function()
        return game:GetService("InsertService"):LoadAsset(id)
    end)
    if ok and res then return { res } end
    return nil
end

local function collectParts(objs)
    local out = {}
    for _, o in ipairs(objs) do
        if o:IsA("BasePart") then out[#out + 1] = o end
        for _, d in ipairs(o:GetDescendants()) do
            if d:IsA("BasePart") then out[#out + 1] = d end
        end
    end
    return out
end

local function findAtt(char, name)
    for _, p in ipairs(char:GetDescendants()) do
        if p:IsA("Attachment") and p.Name == name and p.Parent:IsA("BasePart") then
            return p
        end
    end
end

local function applyBody(char)
    local total = 0
    for _, id in ipairs(HOMERO_CFG.body) do
        local objs = loadObjects(id)
        if objs then
            for _, mp in ipairs(collectParts(objs)) do
                local orig = char:FindFirstChild(mp.Name)
                if orig and orig:IsA("BasePart") then
                    local c = mp:Clone()
                    c.Name = TAG .. "body_" .. mp.Name
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
                    if orig:GetAttribute("EliteOutfitOriginalTransparency") == nil then
                        orig:SetAttribute("EliteOutfitOriginalTransparency", orig.Transparency)
                    end
                    orig.Transparency = 1
                    total = total + 1
                end
            end
            for _, o in ipairs(objs) do pcall(function() o:Destroy() end) end
        end
    end
    return total
end

local function attachItem(char, entry)
    local objs = loadObjects(entry.id)
    if not objs then return false end

    local handle
    for _, p in ipairs(collectParts(objs)) do
        if p.Name == "Handle" then handle = p; break end
        if not handle then handle = p end
    end
    if not handle then
        for _, o in ipairs(objs) do pcall(function() o:Destroy() end) end
        return false
    end

    local H = handle:Clone()
    for _, o in ipairs(objs) do pcall(function() o:Destroy() end) end

    H.Name = TAG .. "item_" .. tostring(entry.id)
    H.CanCollide = false
    H.Anchored = false
    H.Massless = true

    local wrap = H:FindFirstChildWhichIsA("WrapLayer")
    local target, c0, c1

    if wrap then
        target = char:FindFirstChild("UpperTorso")
              or char:FindFirstChild("Torso")
              or char:FindFirstChild("HumanoidRootPart")
        c0 = entry.offset or _CFnew()
        c1 = _CFnew()
    else
        local hAtt = H:FindFirstChildOfClass("Attachment")
        local bAtt = hAtt and findAtt(char, hAtt.Name)
        if bAtt then
            target = bAtt.Parent
            c0 = bAtt.CFrame * (entry.offset or _CFnew())
            c1 = hAtt.CFrame
        else
            target = char:FindFirstChild("Head")
            c0 = entry.offset or _CFnew(0, 1.4, 0)
            c1 = _CFnew()
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

function applyHomeroOutfit(char)
    if not char then char = LP.Character end
    if not char then return end
    char:WaitForChild("Humanoid", 10)
    char:WaitForChild("Head", 10)
    task.wait(0.4)

    for _, d in ipairs(char:GetChildren()) do
        if d.Name:sub(1, #TAG) == TAG then pcall(function() d:Destroy() end) end
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
    if HOMERO_CFG.aplicarCuerpo then applyBody(char) end
    for _, e in ipairs(HOMERO_CFG.items) do attachItem(char, e) end
end

local _originalAppearance = nil

local function captureOriginalAppearance(char)
    if not char or _originalAppearance then return end
    local data = {
        bodyColors = nil,
        shirt = nil,
        pants = nil,
        headMesh = nil,
        headTexture = nil,
    }
    local bc = char:FindFirstChildWhichIsA("BodyColors")
    if bc then
        data.bodyColors = {
            head = bc.HeadColor3,
            torso = bc.TorsoColor3,
            leftArm = bc.LeftArmColor3,
            rightArm = bc.RightArmColor3,
            leftLeg = bc.LeftLegColor3,
            rightLeg = bc.RightLegColor3,
        }
    end
    local sh = char:FindFirstChildWhichIsA("Shirt")
    if sh then data.shirt = sh.ShirtTemplate end
    local pa = char:FindFirstChildWhichIsA("Pants")
    if pa then data.pants = pa.PantsTemplate end
    local head = char:FindFirstChild("Head")
    if head then
        local sm = head:FindFirstChildWhichIsA("SpecialMesh")
        if sm and sm.MeshType == Enum.MeshType.FileMesh then
            data.headMesh = sm.MeshId
            data.headTexture = sm.TextureId
        end
    end
    _originalAppearance = data
end

local function clearPreviousOutfitAssets(char)
    if not char then return end
    for _, child in ipairs(char:GetChildren()) do
        if child.Name:sub(1, #TAG) == TAG
        or child.Name == "AuFfitAccessory"
        or child.Name == "Korblox_RightLeg" then
            pcall(function() child:Destroy() end)
        elseif child:IsA("CharacterMesh") and child.BodyPart == Enum.BodyPart.Head then
            pcall(function() child:Destroy() end)
        end
    end
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            local originalTransparency = part:GetAttribute("EliteOutfitOriginalTransparency")
            if originalTransparency ~= nil then
                part.Transparency = originalTransparency
                part:SetAttribute("EliteOutfitOriginalTransparency", nil)
            end
            local originalLocalTransparency = part:GetAttribute("EliteOutfitOriginalLocalTransparency")
            if originalLocalTransparency ~= nil then
                part.LocalTransparencyModifier = originalLocalTransparency
                part:SetAttribute("EliteOutfitOriginalLocalTransparency", nil)
            end
        end
    end
    if _originalAppearance and _originalAppearance.bodyColors then
        local bc = char:FindFirstChildWhichIsA("BodyColors") or Instance.new("BodyColors")
        local o = _originalAppearance.bodyColors
        bc.HeadColor3, bc.TorsoColor3 = o.head, o.torso
        bc.LeftArmColor3, bc.RightArmColor3 = o.leftArm, o.rightArm
        bc.LeftLegColor3, bc.RightLegColor3 = o.leftLeg, o.rightLeg
        bc.Parent = char
    end
    local head = char:FindFirstChild("Head")
    if head and head:IsA("MeshPart") and head:GetAttribute("EliteOutfitModifiedMeshPart") then
        pcall(function()
            head.MeshId = head:GetAttribute("EliteOutfitOriginalMeshId") or ""
            head.TextureID = head:GetAttribute("EliteOutfitOriginalTextureId") or ""
        end)
        head:SetAttribute("EliteOutfitModifiedMeshPart", nil)
        head:SetAttribute("EliteOutfitOriginalMeshId", nil)
        head:SetAttribute("EliteOutfitOriginalTextureId", nil)
    elseif head then
        local specialMesh = head:FindFirstChildWhichIsA("SpecialMesh")
        if specialMesh and specialMesh:GetAttribute("EliteOutfitCreatedMesh") then
            specialMesh:Destroy()
        elseif specialMesh and specialMesh:GetAttribute("EliteOutfitModifiedMesh") then
            specialMesh.MeshId = specialMesh:GetAttribute("EliteOutfitOriginalMeshId") or ""
            specialMesh.TextureId = specialMesh:GetAttribute("EliteOutfitOriginalTextureId") or ""
            specialMesh:SetAttribute("EliteOutfitModifiedMesh", nil)
            specialMesh:SetAttribute("EliteOutfitOriginalMeshId", nil)
            specialMesh:SetAttribute("EliteOutfitOriginalTextureId", nil)
        end
    end
end

local function applyNoOutfit(char)
    if not char then char = LP.Character end
    if not char then return end
    for _, d in ipairs(char:GetChildren()) do
        if d.Name:sub(1, #TAG) == TAG then pcall(function() d:Destroy() end) end
    end
    local oldAcc = char:FindFirstChild("AuFfitAccessory")
    if oldAcc then pcall(function() oldAcc:Destroy() end) end
    local oldKorblox = char:FindFirstChild("Korblox_RightLeg")
    if oldKorblox then pcall(function() oldKorblox:Destroy() end) end
    for _, d in ipairs(char:GetChildren()) do
        if d:IsA("CharacterMesh") and d.BodyPart == Enum.BodyPart.Head then
            pcall(function() d:Destroy() end)
        end
    end
    local head = char:FindFirstChild("Head")
    if head then
        head.Transparency = 0
        head.CanCollide = true
        head.LocalTransparencyModifier = 0
        local face = head:FindFirstChild("face")
        if face then face.Transparency = 0 end
        local sm = head:FindFirstChildWhichIsA("SpecialMesh")
        if sm then
            if _originalAppearance and _originalAppearance.headMesh then
                sm.MeshId = _originalAppearance.headMesh
                sm.TextureId = _originalAppearance.headTexture or ""
            else
                pcall(function() sm:Destroy() end)
            end
        end
    end
    pcall(function()
        local neck = char:FindFirstChild("Neck")
        if neck then neck.Enabled = true end
    end)
    for _, partName in ipairs({"RightUpperLeg", "RightLowerLeg", "RightFoot"}) do
        local limb = char:FindFirstChild(partName)
        if limb then limb.Transparency = 0 end
    end
    if _originalAppearance and _originalAppearance.bodyColors then
        local bc = char:FindFirstChildWhichIsA("BodyColors") or Instance.new("BodyColors")
        local o = _originalAppearance.bodyColors
        bc.HeadColor3 = o.head
        bc.TorsoColor3 = o.torso
        bc.LeftArmColor3 = o.leftArm
        bc.RightArmColor3 = o.rightArm
        bc.LeftLegColor3 = o.leftLeg
        bc.RightLegColor3 = o.rightLeg
        bc.Parent = char
    end
    if _originalAppearance and _originalAppearance.shirt then
        local s = char:FindFirstChildWhichIsA("Shirt") or Instance.new("Shirt")
        s.ShirtTemplate = _originalAppearance.shirt
        s.Parent = char
    end
    if _originalAppearance and _originalAppearance.pants then
        local p = char:FindFirstChildWhichIsA("Pants") or Instance.new("Pants")
        p.PantsTemplate = _originalAppearance.pants
        p.Parent = char
    end
    for _, a in ipairs(char:GetChildren()) do
        if a:IsA("Accessory") then
            local h = a:FindFirstChild("Handle")
            if h then h.Transparency = 0 end
        end
    end
end

local OUTFITS = {
    { label = "OFF", customApply = applyNoOutfit },
    { accessory = 10159600649, offset = _V3new(0, 1, -0.2), shirt = "http://www.roblox.com/asset/?id=9683332638", pants = "http://www.roblox.com/asset/?id=93182020184041", headMesh = "http://www.roblox.com/asset/?id=134079402", headTexture = "http://www.roblox.com/asset/?id=133940918 ", korblox = "none", label = "Outfit 1", headlessKorblox = true },
    { accessory = 1744060292, offset = _V3new(0, 1.3, -0.2), shirt = "http://www.roblox.com/asset/?id=9683332638", pants = "http://www.roblox.com/asset/?id=93182020184041", headMesh = "http://www.roblox.com/asset/?id=134079402", headTexture = "http://www.roblox.com/asset/?id=133940918 ", korblox = "none", label = "Outfit 2", headlessKorblox = true },
    { accessory = 8349240186, offset = _V3new(0, 0.9, 0), shirt = "http://www.roblox.com/asset/?id=11926549070", pants = "http://www.roblox.com/asset/?id=13189494471", headMesh = "https://assetdelivery.roblox.com/v1/asset/?id=16673245747", headTexture = nil, korblox = "none", label = "Outfit 3", headlessKorblox = true },
    { accessory = 121097973925756, offset = _V3new(0, 0.9, 0), shirt = "http://www.roblox.com/asset/?id=123181702116947", pants = "http://www.roblox.com/asset/?id=93330291631062", headMesh = "http://www.roblox.com/asset/?id=134079402", headTexture = "http://www.roblox.com/asset/?id=133940918 ", korblox = "none", label = "Outfit 4", headlessKorblox = true },
    { label = "Homero Chino", customApply = applyHomeroOutfit },
}
local currentOutfitIndex = 1
local outfitSelectorLabel = nil

local function loadObjectsStd(id)
    local ok, res = pcall(function() return game:GetObjects("rbxassetid://" .. tostring(id)) end)
    if ok and typeof(res) == "table" and #res > 0 then return res end
    ok, res = pcall(function() return game:GetService("InsertService"):LoadAsset(id) end)
    if ok and res then return {res} end
    return nil
end

local function applyHeadlessKorblox(char)
    if not char then return end
    pcall(function() LP.CharacterAvatarType = Enum.AvatarType.R6 end)
    local head = char:FindFirstChild("Head")
    if head then
        if head:GetAttribute("EliteOutfitOriginalTransparency") == nil then
            head:SetAttribute("EliteOutfitOriginalTransparency", head.Transparency)
            head:SetAttribute("EliteOutfitOriginalLocalTransparency", head.LocalTransparencyModifier)
        end
        head.Transparency = 1
        head.CanCollide = false
        head.LocalTransparencyModifier = 1
        local face = head:FindFirstChild("face")
        if face then face.Transparency = 1 end
    end
    pcall(function()
        local neck = char:FindFirstChild("Neck")
        if neck then neck.Enabled = false end
    end)
    for _, v in pairs(char:GetChildren()) do
        if v:IsA("Accessory") then
            local w = v:FindFirstChildWhichIsA("Weld") or v:FindFirstChildWhichIsA("WeldConstraint") or v:FindFirstChildWhichIsA("Motor6D")
            if w then
                local p0, p1 = w.Part0, w.Part1
                if (p0 and p0.Name == "Head") or (p1 and p1.Name == "Head") then
                    for _, part in ipairs(v:GetDescendants()) do
                        if part:IsA("BasePart") then
                            if part:GetAttribute("EliteOutfitOriginalTransparency") == nil then
                                part:SetAttribute("EliteOutfitOriginalTransparency", part.Transparency)
                                part:SetAttribute("EliteOutfitOriginalLocalTransparency", part.LocalTransparencyModifier)
                            end
                            part.Transparency = 1
                            part.LocalTransparencyModifier = 1
                        end
                    end
                end
            end
        end
    end
    local rightLegConfig = { id = "rbxassetid://139607718", targetBodyPart = "RightUpperLeg", partsToHide = {"RightUpperLeg", "RightLowerLeg", "RightFoot"}, scale = _V3new(1, 1, 1), offset = _CFnew(0, 0, 0) }
    local targetPart = char:FindFirstChild(rightLegConfig.targetBodyPart)
    if targetPart then
        local oldAsset = char:FindFirstChild("Korblox_RightLeg")
        if oldAsset then oldAsset:Destroy() end
        for _, partName in ipairs(rightLegConfig.partsToHide) do
            local limb = char:FindFirstChild(partName)
            if limb and limb:IsA("BasePart") then
                if limb:GetAttribute("EliteOutfitOriginalTransparency") == nil then
                    limb:SetAttribute("EliteOutfitOriginalTransparency", limb.Transparency)
                end
                limb.Transparency = 1
            end
        end
        local success, objects = pcall(function() return game:GetObjects(rightLegConfig.id) end)
        if success and objects and #objects > 0 then
            local assetModel = objects[1]
            assetModel.Name = "Korblox_RightLeg"
            local mainMesh = assetModel:IsA("BasePart") and assetModel or assetModel:FindFirstChildWhichIsA("BasePart", true)
            if mainMesh then
                mainMesh.Size = mainMesh.Size * rightLegConfig.scale
                mainMesh.CanCollide = false
                mainMesh.CFrame = targetPart.CFrame * rightLegConfig.offset
                local weld = Instance.new("WeldConstraint")
                weld.Part0 = targetPart
                weld.Part1 = mainMesh
                weld.Parent = mainMesh
                assetModel.Parent = char
            end
        end
    end
end

function applyOutfitByIndex(index)
    local cfg = OUTFITS[index]
    if not cfg then return end
    local char = LP.Character
    if not char then return end
    clearPreviousOutfitAssets(char)
    if cfg.customApply then
        cfg.customApply(char)
        if outfitSelectorLabel then outfitSelectorLabel.Text = cfg.label end
        return
    end
    char:WaitForChild("Head", 5)
    local head = char:FindFirstChild("Head")
    if not head then return end
    for _, d in ipairs(char:GetChildren()) do
        if d:IsA("CharacterMesh") and d.BodyPart == Enum.BodyPart.Head then
            pcall(function() d:Destroy() end)
        end
    end
    local done = false
    if head:IsA("MeshPart") then
        done = pcall(function()
            if not head:GetAttribute("EliteOutfitModifiedMeshPart") then
                head:SetAttribute("EliteOutfitOriginalMeshId", head.MeshId)
                head:SetAttribute("EliteOutfitOriginalTextureId", head.TextureID)
                head:SetAttribute("EliteOutfitModifiedMeshPart", true)
            end
            head.MeshId = cfg.headMesh
            head.TextureID = cfg.headTexture or ""
        end)
    end
    if not done then
        local sm = head:FindFirstChildWhichIsA("SpecialMesh")
        if not sm then
            sm = Instance.new("SpecialMesh")
            sm:SetAttribute("EliteOutfitCreatedMesh", true)
        elseif not sm:GetAttribute("EliteOutfitModifiedMesh") then
            sm:SetAttribute("EliteOutfitOriginalMeshId", sm.MeshId)
            sm:SetAttribute("EliteOutfitOriginalTextureId", sm.TextureId)
            sm:SetAttribute("EliteOutfitModifiedMesh", true)
        end
        sm.Parent = head
        sm.MeshType = Enum.MeshType.FileMesh
        sm.MeshId = cfg.headMesh
        sm.TextureId = cfg.headTexture or ""
    end
    if cfg.shirt then
        local s = char:FindFirstChildWhichIsA("Shirt") or Instance.new("Shirt")
        s.Name = "Shirt"
        s.ShirtTemplate = cfg.shirt
        s.Parent = char
    end
    if cfg.pants then
        local p = char:FindFirstChildWhichIsA("Pants") or Instance.new("Pants")
        p.Name = "Pants"
        p.PantsTemplate = cfg.pants
        p.Parent = char
    end
    local old = char:FindFirstChild("AuFfitAccessory")
    if old then old:Destroy() end
    if cfg.accessory and head then
        local objs = loadObjectsStd(cfg.accessory)
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
                weld.C0 = _CFnew(cfg.offset)
                weld.Parent = h
            end
            for _, o in ipairs(objs) do pcall(function() o:Destroy() end) end
        end
    end
    if cfg.headlessKorblox then
        applyHeadlessKorblox(char)
    else
        if char then
            local head2 = char:FindFirstChild("Head")
            if head2 then
                head2.Transparency = 0
                head2.CanCollide = true
                head2.LocalTransparencyModifier = 0
                local face2 = head2:FindFirstChild("face")
                if face2 then face2.Transparency = 0 end
            end
            pcall(function()
                local neck = char:FindFirstChild("Neck")
                if neck then neck.Enabled = true end
            end)
            for _, partName in ipairs({"RightUpperLeg", "RightLowerLeg", "RightFoot"}) do
                local limb = char:FindFirstChild(partName)
                if limb then limb.Transparency = 0 end
            end
            local oldKorblox = char:FindFirstChild("Korblox_RightLeg")
            if oldKorblox then oldKorblox:Destroy() end
        end
    end
    if outfitSelectorLabel then outfitSelectorLabel.Text = cfg.label end
end

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
customSoundsEnabled = false
setCustomSoundsVisual = nil
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
instaResetFloatingPos = nil
batV2FloatingPos = nil
batV2FloatingButton = nil

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
autoBatV2SetVisual = nil
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

lastMoveDir = _V3zero

local CoreGui = game:GetService("CoreGui")

local InfiniteJump = { enabled = false, jumpPower = 55, minVelocity = 35, fallClamp = -120, jumpConn = nil, heartbeatConn = nil }

local function applyJump(root)
    if not root then return end
    pcall(function()
        root.Velocity = _V3new(root.Velocity.X, InfiniteJump.jumpPower, root.Velocity.Z)
    end)
end

local function onJumpRequest()
    if not InfiniteJump.enabled then return end
    local char = LP.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if root then applyJump(root) end
end

local function onHeartbeat()
    if not InfiniteJump.enabled then return end
    local char = LP.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    local jumpHeld = UIS:IsKeyDown(Enum.KeyCode.Space) or (hum.Jump == true)
    if jumpHeld and root.Velocity.Y < InfiniteJump.minVelocity then
        applyJump(root)
    end
    if root.Velocity.Y < InfiniteJump.fallClamp then
        root.Velocity = _V3new(root.Velocity.X, InfiniteJump.fallClamp, root.Velocity.Z)
    end
end

local function connectEvents()
    if InfiniteJump.jumpConn then InfiniteJump.jumpConn:Disconnect() end
    if InfiniteJump.heartbeatConn then InfiniteJump.heartbeatConn:Disconnect() end
    InfiniteJump.jumpConn = UIS.JumpRequest:Connect(onJumpRequest)
    InfiniteJump.heartbeatConn = RunService.Heartbeat:Connect(onHeartbeat)
end

function InfiniteJump.start()
    if InfiniteJump.enabled then return end
    InfiniteJump.enabled = true
    connectEvents()
end

function InfiniteJump.stop()
    InfiniteJump.enabled = false
    if InfiniteJump.jumpConn then InfiniteJump.jumpConn:Disconnect(); InfiniteJump.jumpConn = nil end
    if InfiniteJump.heartbeatConn then InfiniteJump.heartbeatConn:Disconnect(); InfiniteJump.heartbeatConn = nil end
end

function InfiniteJump.setJumpPower(power)
    power = tonumber(power) or 55
    InfiniteJump.jumpPower = _clamp(power, 10, 200)
end

function InfiniteJump.isRunning() return InfiniteJump.enabled == true end

pcall(InfiniteJump.start)

function getActiveMoveSpeed()
    if laggerCarryToggled then return LAGGER_CARRY_SPEED
    elseif laggerToggled then return LAGGER_SPEED
    elseif speedMode then return CS
    else return NS end
end

function getSpeedModeName()
    if laggerToggled or laggerCarryToggled then return "LAGGER"
    elseif speedMode then return "CARRY"
    else return "NORMAL" end
end

-- =====================================================================
-- [FIX SPEED VIOLETTE] VELOCITY HOOK
-- Ahora instala DOS hooks sobre el metatable de game:
--   __index:    devuelve _s2VelState.v (velocidad fake) a contexto externo
--   __newindex: captura escrituras externas sin aplicarlas
-- Además usa un storage compartido en _s2VelState.v para el valor visible.
-- =====================================================================
local _s2VelState = _G.__EliteFamilySpeedHookState
if type(_s2VelState) ~= "table" then
    _s2VelState = {
        hooked = false,
        velChecked = setmetatable({}, { __mode = "k" }),
        root = nil,
        v = _V3zero,
    }
    _G.__EliteFamilySpeedHookState = _s2VelState
end
local _velChecked = _s2VelState.velChecked
local _hookedVelParts = {}

local _hookVelSupported = nil
local function _hookVelHRP(hrp)
    if not hrp then return end
    _s2VelState.root = hrp
    _velChecked[hrp] = true
    if _s2VelState.hooked then return end
    if type(getrawmetatable) ~= "function" or type(setreadonly) ~= "function"
       or type(newcclosure) ~= "function" or type(checkcaller) ~= "function" then
        return
    end
    local ok = pcall(function()
        local mt = getrawmetatable(game)
        if not mt then return end

        setreadonly(mt, false)

        local originalIndex = rawget(mt, "__index")
        local originalNewIndex = rawget(mt, "__newindex")

        local function isOurRoot(t, k)
            local tk = tostring(k)
            if tk ~= "AssemblyLinearVelocity" and tk ~= "Velocity" then return false end
            if typeof(t) ~= "Instance" or not t:IsA("BasePart") then return false end
            local tn = t.Name
            if tn ~= "HumanoidRootPart" and tn ~= "Torso" and tn ~= "UpperTorso" then return false end
            local char = LP.Character
            return char ~= nil and t:IsDescendantOf(char)
        end

        if type(originalIndex) == "function" or type(originalIndex) == "table" then
            local replacementIndex = newcclosure(function(self, key)
                if not checkcaller() then
                    local good, mine = pcall(isOurRoot, self, key)
                    if good and mine then return _s2VelState.v end
                end
                if type(originalIndex) == "function" then
                    return originalIndex(self, key)
                else
                    return originalIndex[key]
                end
            end)
            mt.__index = replacementIndex
        end

        if type(originalNewIndex) == "function" then
            local replacementNewIndex = newcclosure(function(self, key, value)
                if not checkcaller() then
                    local good, mine = pcall(isOurRoot, self, key)
                    if good and mine then
                        _s2VelState.v = value
                        return
                    end
                end
                return originalNewIndex(self, key, value)
            end)
            mt.__newindex = replacementNewIndex
        end

        setreadonly(mt, true)
        _s2VelState.hooked = true
    end)
    if not ok then _s2VelState.hooked = false end
end

local function _setupVelChecked(char)
    _velChecked = setmetatable({}, { __mode = "k" })
    _s2VelState.velChecked = _velChecked
    if not char then _s2VelState.root = nil; return nil end
    local hrp = char:WaitForChild("HumanoidRootPart", 5)
    if hrp then
        _s2VelState.root = hrp
        _velChecked[hrp] = true
    end
    return hrp
end

if LP.Character then
    local _hrp0 = _setupVelChecked(LP.Character)
    _hookVelHRP(_hrp0)
end

local function _isRagdollState(hum)
    if not hum then return true end
    local st = hum:GetState()
    return hum.PlatformStand
        or st == Enum.HumanoidStateType.Physics
        or st == Enum.HumanoidStateType.Ragdoll
        or st == Enum.HumanoidStateType.FallingDown
end

-- [FIX SPEED VIOLETTE] aplica velocidad con jitter + oculta la real al juego.
-- El juego verá _s2VelState.v = 16 (fake). Nosotros aplicamos la real en
-- AssemblyLinearVelocity directamente (checkcaller bypass).
local _eliteVelRng = Random.new()

local function _applyVelocitySpeed(dir, speed, hrp)
    if not hrp or not hrp.Parent then return end
    if batDesyncTpEnabled or autoBatEnabled or autoBatV2Enabled then return end
    if type(speed) ~= "number" or speed ~= speed or speed <= 0 or speed == math.huge then return end

    local verticalVelocity = hrp.AssemblyLinearVelocity.Y

    if dir and dir.Magnitude > 0.05 then
        pcall(function()
            if hrp.SetNetworkOwner then hrp:SetNetworkOwner(LP) end
        end)
        local unit = dir.Unit
        local jx = _eliteVelRng:NextNumber(-0.003, 0.003)
        local jz = _eliteVelRng:NextNumber(-0.003, 0.003)

        -- Velocidad falsa que el juego verá cuando consulte desde código externo
        _s2VelState.v = _V3new(unit.X * 16 + jx, verticalVelocity, unit.Z * 16 + jz)

        -- Velocidad real aplicada directamente al root (checkcaller=true)
        hrp.AssemblyLinearVelocity = _V3new(unit.X * speed + jx, verticalVelocity, unit.Z * speed + jz)
        -- Marca de "live speed" para que el Anti Fling no cancele nuestra propia velocidad
        _G.__EliteFamilyLiveSpeed = { t = os.clock(), v = speed }
    else
        _s2VelState.v = _V3new(0, verticalVelocity, 0)
        hrp.AssemblyLinearVelocity = _V3new(0, verticalVelocity, 0)
    end
end

function getAutoPathSpeed()
    if laggerCarryToggled or laggerToggled then return LAGGER_SPEED end
    return NS
end

ANIM_PACKS = {
    ["Zombie"] = { idle1="rbxassetid://616158929", idle2="rbxassetid://616160636", walk="rbxassetid://616168032", run="rbxassetid://616163682", jump="rbxassetid://616161997", fall="rbxassetid://616157476", climb="rbxassetid://616156119", swim="rbxassetid://616165109", swimidle="rbxassetid://616166655" },
    ["Ninja"] = { idle1="rbxassetid://656117400", idle2="rbxassetid://656117400", walk="rbxassetid://656121766", run="rbxassetid://656118852", jump="rbxassetid://656117878", fall="rbxassetid://656115606", climb="rbxassetid://656114359", swim="rbxassetid://656117400", swimidle="rbxassetid://656117400" },
    ["Knight"] = { idle1="rbxassetid://657595757", idle2="rbxassetid://657595757", walk="rbxassetid://657552124", run="rbxassetid://657564596", jump="rbxassetid://658409194", fall="rbxassetid://657600338", climb="rbxassetid://658360781", swim="rbxassetid://657595757", swimidle="rbxassetid://657595757" },
    ["Elder"] = { idle1="rbxassetid://845397899", idle2="rbxassetid://845397899", walk="rbxassetid://845403856", run="rbxassetid://845386501", jump="rbxassetid://845398858", fall="rbxassetid://845397673", climb="rbxassetid://845392038", swim="rbxassetid://845397899", swimidle="rbxassetid://845397899" },
    ["Levitate"] = { idle1="rbxassetid://616006778", idle2="rbxassetid://616006778", walk="rbxassetid://616013216", run="rbxassetid://616013216", jump="rbxassetid://616008936", fall="rbxassetid://616005863", climb="rbxassetid://616003713", swim="rbxassetid://616006778", swimidle="rbxassetid://616006778" },
    ["Astronaut"] = { idle1="rbxassetid://891621366", idle2="rbxassetid://891621366", walk="rbxassetid://891636393", run="rbxassetid://891636393", jump="rbxassetid://891627522", fall="rbxassetid://891617961", climb="rbxassetid://891609353", swim="rbxassetid://891621366", swimidle="rbxassetid://891621366" },
    ["Pirate"] = { idle1="rbxassetid://750781874", idle2="rbxassetid://750781874", walk="rbxassetid://750785693", run="rbxassetid://750783738", jump="rbxassetid://750782230", fall="rbxassetid://750780242", climb="rbxassetid://750779899", swim="rbxassetid://750781874", swimidle="rbxassetid://750781874" },
    ["Toy"] = { idle1="rbxassetid://782841498", idle2="rbxassetid://782841498", walk="rbxassetid://782843345", run="rbxassetid://782842708", jump="rbxassetid://782847020", fall="rbxassetid://782846423", climb="rbxassetid://782843869", swim="rbxassetid://782841498", swimidle="rbxassetid://782841498" },
    ["Vampire"] = { idle1="rbxassetid://1083445855", idle2="rbxassetid://1083445855", walk="rbxassetid://1083473930", run="rbxassetid://1083462077", jump="rbxassetid://1083455352", fall="rbxassetid://1083443587", climb="rbxassetid://1083439238", swim="rbxassetid://1083445855", swimidle="rbxassetid://1083445855" },
    ["Werewolf"] = { idle1="rbxassetid://1083195517", idle2="rbxassetid://1083195517", walk="rbxassetid://1083178339", run="rbxassetid://1083216690", jump="rbxassetid://1083218792", fall="rbxassetid://1083189019", climb="rbxassetid://1083182000", swim="rbxassetid://1083195517", swimidle="rbxassetid://1083195517" },
    ["Rthro"] = { idle1="rbxassetid://2510196951", idle2="rbxassetid://2510196951", walk="rbxassetid://2510202577", run="rbxassetid://2510198475", jump="rbxassetid://2510197830", fall="rbxassetid://2510195892", climb="rbxassetid://2510192778", swim="rbxassetid://2510196951", swimidle="rbxassetid://2510196951" },
    ["Stylish"] = { idle1="rbxassetid://616136790", idle2="rbxassetid://616136790", walk="rbxassetid://616146177", run="rbxassetid://616140816", jump="rbxassetid://616139451", fall="rbxassetid://616134815", climb="rbxassetid://616133594", swim="rbxassetid://616136790", swimidle="rbxassetid://616136790" },
}

ANIM_PACK_ORDER = {{"Off", "Off"}, {"Zombie", "Zombie"}, {"Ninja", "Ninja"}, {"Knight", "Knight"}, {"Elder", "Elder"}, {"Levitate", "Levitate"}, {"Astronaut", "Astronaut"}, {"Pirate", "Pirate"}, {"Toy", "Toy"}, {"Vampire", "Vampire"}, {"Werewolf", "Werewolf"}, {"Rthro", "Rthro"}, {"Stylish", "Stylish"}}

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
        walk  = g(animate.walk and animate.walk.WalkAnim),
        run   = g(animate.run  and animate.run.RunAnim),
        jump  = g(animate.jump and animate.jump.JumpAnim),
        fall  = g(animate.fall and animate.fall.FallAnim),
        climb = g(animate.climb and animate.climb.ClimbAnim),
        swim  = g(animate.swim and animate.swim.Swim),
        swimidle = g(animate.swimidle and animate.swimidle.SwimIdle),
    }
    if not isPackAnim(ids.walk) then originalTryardAnims = ids end
end

local function applyAnimPack(packName)
    currentAnimPack = packName
    if animSelectorLabel then animSelectorLabel.Text = packName end
    if packName == "Off" then
        if originalTryardAnims and LP.Character then
            local animate = LP.Character:FindFirstChild("Animate")
            if animate then
                local function s(obj,id) if obj then obj.AnimationId = id end end
                s(animate.idle and animate.idle.Animation1, originalTryardAnims.idle1)
                s(animate.idle and animate.idle.Animation2, originalTryardAnims.idle2)
                s(animate.walk and animate.walk.WalkAnim, originalTryardAnims.walk)
                s(animate.run  and animate.run.RunAnim,   originalTryardAnims.run)
                s(animate.jump and animate.jump.JumpAnim, originalTryardAnims.jump)
                s(animate.fall and animate.fall.FallAnim, originalTryardAnims.fall)
                s(animate.climb and animate.climb.ClimbAnim, originalTryardAnims.climb)
                s(animate.swim and animate.swim.Swim, originalTryardAnims.swim)
                s(animate.swimidle and animate.swimidle.SwimIdle, originalTryardAnims.swimidle)
            end
        end
        if tryardHeartbeatConn then tryardHeartbeatConn:Disconnect(); tryardHeartbeatConn = nil end
        return
    end
    local pack = ANIM_PACKS[packName]
    if not pack then return end
    if tryardHeartbeatConn then tryardHeartbeatConn:Disconnect() end
    tryardHeartbeatConn = RunService.Heartbeat:Connect(function()
        local c = LP.Character
        if not c then return end
        local animate = c:FindFirstChild("Animate")
        if not animate then return end
        local function s(obj,id) if obj then obj.AnimationId = id end end
        s(animate.idle and animate.idle.Animation1, pack.idle1)
        s(animate.idle and animate.idle.Animation2, pack.idle2)
        s(animate.walk and animate.walk.WalkAnim, pack.walk)
        s(animate.run  and animate.run.RunAnim,   pack.run)
        s(animate.jump and animate.jump.JumpAnim, pack.jump)
        s(animate.fall and animate.fall.FallAnim, pack.fall)
        s(animate.climb and animate.climb.ClimbAnim, pack.climb)
        s(animate.swim and animate.swim.Swim, pack.swim)
        s(animate.swimidle and animate.swimidle.SwimIdle, pack.swimidle)
    end)
end

local function startAnimPack(packName)
    local char = LP.Character
    if char then
        saveOriginalAnims(char)
        applyAnimPack(packName)
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            for _, track in ipairs(hum:GetPlayingAnimationTracks()) do track:Stop(0) end
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
    AutoLeft     = {kb = Enum.KeyCode.Z, gp = nil},
    AutoRight    = {kb = Enum.KeyCode.C, gp = nil},
    AutoBat      = {kb = Enum.KeyCode.E, gp = nil},
    TPFloor      = {kb = Enum.KeyCode.F, gp = nil},
    GuiHide      = {kb = Enum.KeyCode.LeftControl, gp = nil},
    CarryToggle  = {kb = Enum.KeyCode.Q, gp = nil},
    LaggerMode   = {kb = Enum.KeyCode.R, gp = nil},
    TPBat        = {kb = Enum.KeyCode.V, gp = nil},
    BatV2        = {kb = Enum.KeyCode.N, gp = nil},
    InstaReset   = {kb = Enum.KeyCode.H, gp = nil},
}

KB = {
    DropBrainrot = {kb = DEFAULT_KB.DropBrainrot.kb, gp = DEFAULT_KB.DropBrainrot.gp},
    AutoLeft     = {kb = DEFAULT_KB.AutoLeft.kb, gp = DEFAULT_KB.AutoLeft.gp},
    AutoRight    = {kb = DEFAULT_KB.AutoRight.kb, gp = DEFAULT_KB.AutoRight.gp},
    AutoBat      = {kb = DEFAULT_KB.AutoBat.kb, gp = DEFAULT_KB.AutoBat.gp},
    TPFloor      = {kb = DEFAULT_KB.TPFloor.kb, gp = DEFAULT_KB.TPFloor.gp},
    GuiHide      = {kb = DEFAULT_KB.GuiHide.kb, gp = DEFAULT_KB.GuiHide.gp},
    CarryToggle  = {kb = DEFAULT_KB.CarryToggle.kb, gp = DEFAULT_KB.CarryToggle.gp},
    LaggerMode   = {kb = DEFAULT_KB.LaggerMode.kb, gp = DEFAULT_KB.LaggerMode.gp},
    TPBat        = {kb = DEFAULT_KB.TPBat.kb, gp = DEFAULT_KB.TPBat.gp},
    BatV2        = {kb = DEFAULT_KB.BatV2.kb, gp = DEFAULT_KB.BatV2.gp},
    InstaReset   = {kb = DEFAULT_KB.InstaReset.kb, gp = DEFAULT_KB.InstaReset.gp},
}

_isResetting = false
_lastSavedJSON = nil
_isLoading = false

CONFIG = { AUTO_STEAL_ENABLED = false, STEAL_RANGE = 61 } -- AutoSteal alineado con 404 (radius 61, duration 1.3)

local plots = Workspace:FindFirstChild("Plots")
local stealConnection = nil

local Steal = { AutoStealEnabled = false, StealRadius = CONFIG.STEAL_RANGE, StealDuration = 1.3, StealDelay = 0.25, Data = {} }

local isStealing = false
local autoGrabSetDelayRadius = 9
local autoGrabStopTime = 0.96
local autoGrabStopEnabled = true

local _plotsCache = nil
local _plotsCacheTime = 0
local function getPlotsRoot()
    local now = _tick()
    if _plotsCache and now - _plotsCacheTime < 2 and _plotsCache.Parent then
        return _plotsCache
    end
    _plotsCache = workspace:FindFirstChild("Plots")
    _plotsCacheTime = now
    return _plotsCache
end

local function isMyPlotByName(plotName)
    local plotsRoot = getPlotsRoot()
    if not plotsRoot then return false end
    local plot = plotsRoot:FindFirstChild(plotName)
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

local function findNearestPrompt()
    local char = LP.Character
    if not char then return nil, nil end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return nil, nil end
    local plotsRoot = getPlotsRoot()
    if not plotsRoot then return nil, nil end
    local nearestPrompt, nearestDist, nearestName = nil, _huge, nil
    local rpos = root.Position
    for _, plot in ipairs(plotsRoot:GetChildren()) do
        if isMyPlotByName(plot.Name) then continue end
        local pods = plot:FindFirstChild("AnimalPodiums")
        if not pods then continue end
        for _, pod in ipairs(pods:GetChildren()) do
            pcall(function()
                local base = pod:FindFirstChild("Base")
                local spawn = base and base:FindFirstChild("Spawn")
                if spawn then
                    local sp = spawn.Position
                    local dx = sp.X - rpos.X
                    local dy = sp.Y - rpos.Y
                    local dz = sp.Z - rpos.Z
                    local dist = _sqrt(dx*dx + dy*dy + dz*dz)
                    if dist < nearestDist and dist <= Steal.StealRadius then
                        local att = spawn:FindFirstChild("PromptAttachment")
                        if att then
                            for _, child in ipairs(att:GetChildren()) do
                                if child:IsA("ProximityPrompt") and child.ActionText and child.ActionText:find("Steal") then
                                    nearestPrompt = child
                                    nearestDist = dist
                                    nearestName = pod.Name
                                    break
                                end
                            end
                        end
                    end
                end
            end)
        end
    end
    return nearestPrompt, nearestName
end

local function executeSteal(prompt, podName)
    if isStealing then return end
    if math.random(30) == 1 then
        for p in pairs(Steal.Data) do
            if not p.Parent then Steal.Data[p] = nil end
        end
    end
    if not Steal.Data[prompt] then
        Steal.Data[prompt] = { hold = {}, trigger = {}, ready = true }
        pcall(function()
            if getconnections then
                for _, c in ipairs(getconnections(prompt.PromptButtonHoldBegan)) do
                    if c.Function then table.insert(Steal.Data[prompt].hold, c.Function) end
                end
                for _, c in ipairs(getconnections(prompt.Triggered)) do
                    if c.Function then table.insert(Steal.Data[prompt].trigger, c.Function) end
                end
            end
        end)
    end
    local data = Steal.Data[prompt]
    if not data.ready then return end
    data.ready = false
    isStealing = true

    if progressFill then progressFill.Size = UDim2.new(0, 0, 1, 0) end
    if progressPct then progressPct.Text = "0%" end

    task.spawn(function()
        for _, f in ipairs(data.hold) do task.spawn(f) end

        local startTime = _tick()
        local duration = Steal.StealDuration
        local promptFired = false

        if autoGrabStopEnabled then
            while isStealing and Steal.AutoStealEnabled do
                local elapsed = _tick() - startTime
                if elapsed >= autoGrabStopTime then break end
                local progress = _clamp(elapsed / duration, 0, 1)
                if progressFill then progressFill.Size = UDim2.new(progress, 0, 1, 0) end
                if progressPct then progressPct.Text = _floor(progress * 100) .. "%" end
                if not prompt.Parent or not prompt.Parent.Parent then break end
                local char = LP.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if hrp and (hrp.Position - prompt.Parent.Parent.Position).Magnitude > Steal.StealRadius then
                    break
                end
                task.wait()
            end

            local stopProgress = _clamp(autoGrabStopTime / duration, 0, 1)
            if progressFill then progressFill.Size = UDim2.new(stopProgress, 0, 1, 0) end
            if progressPct then progressPct.Text = _floor(stopProgress * 100) .. "%" end

            local phase2Timeout = math.max(2.99 - autoGrabStopTime - math.max(duration - autoGrabStopTime, 0), 0.05)
            local phase2Start = _tick()

            while isStealing and Steal.AutoStealEnabled do
                if _tick() - phase2Start >= phase2Timeout then
                    if progressFill then progressFill.Size = UDim2.new(0, 0, 1, 0) end
                    if progressPct then progressPct.Text = "0%" end
                    data.ready = true
                    isStealing = false
                    task.wait()
                    local newPrompt, newName = findNearestPrompt()
                    if newPrompt then executeSteal(newPrompt, newName) end
                    return
                end
                if not prompt.Parent or not prompt.Parent.Parent then
                    isStealing = false
                    if progressFill then progressFill.Size = UDim2.new(0, 0, 1, 0) end
                    if progressPct then progressPct.Text = "0%" end
                    data.ready = true
                    return
                end
                local char = LP.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local dist = (hrp.Position - prompt.Parent.Parent.Position).Magnitude
                    if dist <= autoGrabSetDelayRadius then
                        break
                    elseif dist > Steal.StealRadius then
                        isStealing = false
                        if progressFill then progressFill.Size = UDim2.new(0, 0, 1, 0) end
                        if progressPct then progressPct.Text = "0%" end
                        data.ready = true
                        return
                    end
                end
                task.wait()
            end

            if isStealing and Steal.AutoStealEnabled then
                local fillStart = _tick()
                local fillDuration = math.max(duration - autoGrabStopTime, 0.05)
                while true do
                    local fp = _clamp((_tick() - fillStart) / fillDuration, 0, 1)
                    local totalProgress = stopProgress + fp * (1 - stopProgress)
                    if progressFill then progressFill.Size = UDim2.new(totalProgress, 0, 1, 0) end
                    if progressPct then progressPct.Text = _floor(totalProgress * 100) .. "%" end
                    if fp >= 1 and not promptFired then
                        promptFired = true
                        pcall(function()
                            if #data.trigger > 0 then
                                for _, f in ipairs(data.trigger) do task.spawn(f) end
                            else
                                local remote = ReplicatedStorage:FindFirstChild("StealAnimal")
                                if remote and podName then remote:FireServer(podName) end
                            end
                        end)
                        break
                    end
                    task.wait()
                end
            end
        else
            while isStealing and Steal.AutoStealEnabled do
                local elapsed = _tick() - startTime
                local progress = _clamp(elapsed / duration, 0, 1)
                if progressFill then progressFill.Size = UDim2.new(progress, 0, 1, 0) end
                if progressPct then progressPct.Text = _floor(progress * 100) .. "%" end
                if not prompt.Parent or not prompt.Parent.Parent then break end
                local char = LP.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if hrp and (hrp.Position - prompt.Parent.Parent.Position).Magnitude > Steal.StealRadius then break end
                if elapsed >= duration and not promptFired then
                    promptFired = true
                    pcall(function()
                        if #data.trigger > 0 then
                            for _, f in ipairs(data.trigger) do task.spawn(f) end
                        else
                            local remote = ReplicatedStorage:FindFirstChild("StealAnimal")
                            if remote and podName then remote:FireServer(podName) end
                        end
                    end)
                    break
                end
                task.wait()
            end
        end

        if progressFill then progressFill.Size = UDim2.new(0, 0, 1, 0) end
        if progressPct then progressPct.Text = "0%" end
        data.ready = true
        isStealing = false
    end)
end

-- =====================================================================
-- AUTO STEAL V2
-- =====================================================================
_G.EliteFamilyV2Steal = _G.EliteFamilyV2Steal or {
    enabled = false, radius = 10, primeRange = 80, holdMin = 1.3, holdMax = 2.6,
    entryDelay = 0.25, cooldown = 0.05,
    animals = {}, promptCache = {}, internalCache = {},
    state = {active = false, startTime = 0, phase = "idle", label = "", lastResult = "", lastResultTime = 0},
    plotSync = {caches = {}, connections = {}}, plots = nil, syncReady = false,
    scanThread = nil, conn = nil, lastScan = 0,
    animalsData = nil, channelFolder = nil, routeRemote = nil, requestData = nil
}

local function _yv2Root()
    local c = LP.Character
    return c and (c:FindFirstChild("HumanoidRootPart") or c:FindFirstChild("UpperTorso")) or nil
end

local function _yv2SplitPath(path)
    if typeof(path) == "table" then return path end
    local out = {}
    for p in string.gmatch(tostring(path), "[^%.]+") do table.insert(out, tonumber(p) or p) end
    return out
end

local function _yv2ResolvePath(path, root)
    local cur, par, key = root, nil, nil
    for _, p in ipairs(_yv2SplitPath(path)) do
        par = cur; key = p; cur = cur and cur[p] or nil
    end
    return cur, par, key
end

local function _yv2ApplyDiff(channelName, packet)
    local cache = _G.EliteFamilyV2Steal.plotSync.caches[channelName]
    if typeof(cache) ~= "table" then return end
    local path, action, a, b = packet[1], packet[2], packet[3], packet[4]
    local cur, par, key = _yv2ResolvePath(path, cache)
    if action == "Changed" then
        if par then par[key] = a end
    elseif action == "ArrayInsert" then
        if cur then table.insert(cur, b, a) end
    elseif action == "ArrayRemoved" then
        if cur then table.remove(cur, b) end
    elseif action == "DictionaryInsert" then
        if cur then cur[b] = a end
    elseif action == "DictionaryRemoved" then
        if cur then cur[b] = nil end
    end
end

local function _yv2AttachChannel(remote, plots, requestData)
    local A = _G.EliteFamilyV2Steal
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
        for _, packet in ipairs(queue) do _yv2ApplyDiff(channelName, packet) end
    end)
end

local function _yv2EnsureSync()
    local A = _G.EliteFamilyV2Steal
    if A.syncReady then return true end
    local ok = pcall(function()
        A.plots = workspace:WaitForChild("Plots", 8)
        local rs = game:GetService("ReplicatedStorage")
        local pkgs = rs:FindFirstChild("Packages")
        local datas = rs:FindFirstChild("Datas")
        if not (pkgs and datas and A.plots) then return end
        A.animalsData = require(datas:WaitForChild("Animals", 10))
        local sync = pkgs:FindFirstChild("Synchronizer") or pkgs:WaitForChild("Synchronizer", 10)
        if not sync then return end
        A.channelFolder = sync:FindFirstChild("Channel") or sync:WaitForChild("Channel", 10)
        A.routeRemote = sync:FindFirstChild("CommunicationRoute") or sync:WaitForChild("CommunicationRoute", 10)
        A.requestData = sync:FindFirstChild("RequestData")
        if A.channelFolder then
            for _, child in ipairs(A.channelFolder:GetChildren()) do
                if child:IsA("RemoteEvent") then _yv2AttachChannel(child, A.plots, A.requestData) end
            end
            A.channelFolder.ChildAdded:Connect(function(child)
                if child:IsA("RemoteEvent") then _yv2AttachChannel(child, A.plots, A.requestData) end
            end)
        end
        if A.routeRemote then
            A.routeRemote.OnClientEvent:Connect(function(actions)
                for _, action in ipairs(actions) do
                    local kind, cn = action[1], tostring(action[2])
                    if A.plots and A.plots:FindFirstChild(cn) then
                        if kind == "ListenerAdded" then
                            local r = A.channelFolder and A.channelFolder:FindFirstChild(cn)
                            if r and r:IsA("RemoteEvent") then _yv2AttachChannel(r, A.plots, A.requestData) end
                        elseif kind == "ListenerRemoved" then
                            for remote, conn in pairs(A.plotSync.connections) do
                                if tostring(remote.Name) == cn then
                                    pcall(function() conn:Disconnect() end)
                                    A.plotSync.connections[remote] = nil
                                    A.plotSync.caches[cn] = nil
                                    break
                                end
                            end
                        end
                    end
                end
            end)
        end
        A.syncReady = true
    end)
    return ok and A.syncReady == true
end

local function _yv2PlotOwner(plot)
    local sign = plot and plot:FindFirstChild("PlotSign")
    local frame = sign and sign:FindFirstChild("SurfaceGui") and sign.SurfaceGui:FindFirstChild("Frame")
    local label = frame and frame:FindFirstChild("TextLabel")
    if not label or label.Text == "Empty Base" then return nil end
    return label.Text:gsub("'s [Bb]ase$", ""):gsub("%s+$", "")
end

local function _yv2IsMyBase(animalData)
    local A = _G.EliteFamilyV2Steal
    if not animalData or not animalData.plot or not A.plots then return false end
    local plot = A.plots:FindFirstChild(animalData.plot)
    if not plot then return false end
    local owner = _yv2PlotOwner(plot)
    return owner == LP.DisplayName or owner == LP.Name
end

local function _yv2PodiumFor(animalData)
    local A = _G.EliteFamilyV2Steal
    local plot = A.plots and A.plots:FindFirstChild(animalData.plot)
    local pds = plot and plot:FindFirstChild("AnimalPodiums")
    return pds and pds:FindFirstChild(animalData.slot) or nil
end

local function _yv2AnimalPos(animalData)
    local pod = _yv2PodiumFor(animalData)
    return pod and pod:GetPivot().Position or nil
end

local function _yv2DistToAnimal(animalData)
    local root = _yv2Root()
    local pos = _yv2AnimalPos(animalData)
    return root and pos and (root.Position - pos).Magnitude or math.huge
end

local function _yv2FindPrompt(animalData)
    local A = _G.EliteFamilyV2Steal
    if not animalData then return nil end
    local cached = A.promptCache[animalData.uid]
    if cached and cached.Parent then return cached end
    local pod = _yv2PodiumFor(animalData)
    if not pod then return nil end
    for _, p in ipairs(pod:GetDescendants()) do
        if p:IsA("ProximityPrompt") then A.promptCache[animalData.uid] = p return p end
    end
    return nil
end

local function _yv2BuildCallbacks(prompt)
    local A = _G.EliteFamilyV2Steal
    if A.internalCache[prompt] then return end
    local data = {holdCallbacks = {}, triggerCallbacks = {}, ready = true}
    pcall(function()
        if getconnections then
            local holds = getconnections(prompt.PromptButtonHoldBegan) or getconnections(prompt.HoldBegan) or {}
            for _, c in ipairs(holds) do
                if type(c.Function) == "function" then table.insert(data.holdCallbacks, c.Function) end
            end
            local triggers = getconnections(prompt.Triggered) or {}
            for _, c in ipairs(triggers) do
                if type(c.Function) == "function" then table.insert(data.triggerCallbacks, c.Function) end
            end
        end
    end)
    A.internalCache[prompt] = data
end

local function _yv2SetBar(p)
    if progressFill then progressFill.Size = UDim2.new(math.clamp(p, 0, 1), 0, 1, 0) end
    if progressPct then progressPct.Text = _floor(math.clamp(p, 0, 1) * 100) .. "%" end
end

local function _yv2ResetBar()
    if progressFill then progressFill.Size = UDim2.new(0, 0, 1, 0) end
    if progressPct then progressPct.Text = "0%" end
end

local function _yv2Execute(prompt, animalData)
    local A = _G.EliteFamilyV2Steal
    if not prompt or not prompt.Parent or not animalData then return false end
    if A.state.active then return false end
    if _tick() - (A.state.lastResultTime or 0) < (A.cooldown or 0.05) then return false end
    _yv2BuildCallbacks(prompt)
    local data = A.internalCache[prompt]
    if not data or not data.ready then return false end
    data.ready = false
    A.state.active = true
    A.state.startTime = _tick()
    A.state.phase = "holding"
    A.state.label = animalData.name or "Animal"
    task.spawn(function()
        local t0 = A.state.startTime
        local stops = {0.70, 0.75, 0.80, 0.85, 0.90}
        local SEMI_STOP = stops[math.random(1, #stops)]
        if #data.holdCallbacks > 0 then
            for _, fn in ipairs(data.holdCallbacks) do task.spawn(function() pcall(fn) end) end
        else
            pcall(function() if prompt.InputHoldBegin then prompt:InputHoldBegin() end end)
        end
        while A.enabled and selectedStealMode == "V2" and CONFIG.AUTO_STEAL_ENABLED and _tick() - t0 < (A.holdMin or 1.3) do
            local rawP = (_tick() - t0) / (A.holdMax or 2.6)
            _yv2SetBar(math.min(rawP, SEMI_STOP))
            task.wait()
        end
        A.state.phase = "waitingRange"
        local alreadyInRange = _yv2DistToAnimal(animalData) <= (tonumber(A.radius) or 10)
        local fired = false
        while A.enabled and selectedStealMode == "V2" and CONFIG.AUTO_STEAL_ENABLED and prompt.Parent do
            local elapsed = _tick() - t0
            if elapsed > (A.holdMax or 2.6) then break end
            local rawP2 = elapsed / (A.holdMax or 2.6)
            _yv2SetBar(math.min(rawP2, SEMI_STOP))
            if _yv2DistToAnimal(animalData) <= (tonumber(A.radius) or 10) then
                if not alreadyInRange then task.wait(A.entryDelay or 0.25) end
                if A.enabled and selectedStealMode == "V2" and CONFIG.AUTO_STEAL_ENABLED then
                    if #data.triggerCallbacks > 0 then
                        for _, fn in ipairs(data.triggerCallbacks) do task.spawn(function() pcall(fn) end) end
                    else
                        pcall(function() if prompt.InputHoldEnd then prompt:InputHoldEnd() end end)
                    end
                    fired = true
                end
                break
            end
            task.wait()
        end
        A.state.lastResult = fired and ("Stole " .. tostring(A.state.label)) or "Missed"
        A.state.active = false
        A.state.phase = "idle"
        A.state.lastResultTime = _tick()
        if fired then _yv2SetBar(1) end
        task.wait(A.cooldown or 0.05)
        data.ready = true
        _yv2ResetBar()
    end)
    return true
end

local function _yv2ScanAllPlots()
    local A = _G.EliteFamilyV2Steal
    if not _yv2EnsureSync() then return 0 end
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
                            uid = plot.Name .. "_" .. tostring(slot)
                        })
                    end
                end
            end
        end
    end
    A.animals = newCache
    return #newCache
end

local function _yv2PickClosest()
    local A = _G.EliteFamilyV2Steal
    local root = _yv2Root()
    if not root then return nil end
    local best, bestDist = nil, math.huge
    for _, data in ipairs(A.animals) do
        if not _yv2IsMyBase(data) then
            local pos = _yv2AnimalPos(data)
            local dist = pos and (root.Position - pos).Magnitude or math.huge
            if dist <= (A.primeRange or 80) and dist < bestDist then
                best, bestDist = data, dist
            end
        end
    end
    return best
end

local function _yv2EnsureScanThread()
    local A = _G.EliteFamilyV2Steal
    if A.scanThread then return end
    A.scanThread = task.spawn(function()
        while _G.EliteFamilyV2Steal do
            if A.enabled or selectedStealMode == "V2" then pcall(_yv2ScanAllPlots) end
            task.wait(5)
        end
    end)
end

function stopAutoStealV2()
    local A = _G.EliteFamilyV2Steal
    A.enabled = false
    if A.conn then A.conn:Disconnect() A.conn = nil end
    A.state.active = false
    A.state.phase = "idle"
    _yv2ResetBar()
end

function startAutoStealV2()
    local A = _G.EliteFamilyV2Steal
    A.radius = 10
    A.enabled = true
    pcall(_yv2EnsureSync)
    _yv2EnsureScanThread()
    pcall(_yv2ScanAllPlots)
    if A.conn then A.conn:Disconnect() A.conn = nil end
    A.conn = RunService.Heartbeat:Connect(function()
        if not A.enabled or not CONFIG.AUTO_STEAL_ENABLED or selectedStealMode ~= "V2" or A.state.active then return end
        local target = _yv2PickClosest()
        if not target then
            if _tick() - (A.lastScan or 0) > 1.2 then
                A.lastScan = _tick()
                pcall(_yv2ScanAllPlots)
            end
            return
        end
        local prompt = _yv2FindPrompt(target)
        if prompt then _yv2Execute(prompt, target) end
    end)
end

local function _startAutoStealV1()
    if stealConnection then
        local connected = false
        pcall(function() connected = stealConnection.Connected == true end)
        if connected then
            Steal.StealRadius = CONFIG.STEAL_RANGE
            Steal.AutoStealEnabled = true
            return true
        end
        pcall(function() stealConnection:Disconnect() end)
        stealConnection = nil
    end
    Steal.StealRadius = CONFIG.STEAL_RANGE
    Steal.AutoStealEnabled = true
    stealConnection = RunService.Heartbeat:Connect(function()
        if not Steal.AutoStealEnabled or isStealing then return end
        if selectedStealMode ~= "V1" then return end
        local p, n = findNearestPrompt()
        if p then executeSteal(p, n) end
    end)
    return true
end

local function _stopAutoStealV1()
    if stealConnection then
        stealConnection:Disconnect()
        stealConnection = nil
    end
    isStealing = false
    Steal.AutoStealEnabled = false
    if progressFill then
        TS:Create(progressFill, TweenInfo.new(0.2), { Size = UDim2.new(0, 0, 1, 0) }):Play()
    end
    if progressPct then progressPct.Text = "0%" end
end

function startAutoSteal()
    _stopAutoStealV1()
    stopAutoStealV2()
    CONFIG.AUTO_STEAL_ENABLED = true
    if selectedStealMode == "V2" then
        startAutoStealV2()
    else
        _startAutoStealV1()
    end
    return true
end

function stopAutoSteal()
    _stopAutoStealV1()
    stopAutoStealV2()
    CONFIG.AUTO_STEAL_ENABLED = false
    if progressFill then
        TS:Create(progressFill, TweenInfo.new(0.2), { Size = UDim2.new(0, 0, 1, 0) }):Play()
    end
    if progressPct then progressPct.Text = "0%" end
end

medusaDebounce = false
medusaLastUsed = 0
dropActive = false
lastDropTime = 0
lastMoveDir = _V3new(0,0,0)
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
Conns = {autoSteal = nil, batCounter = nil, anchor = {}, progress = nil, autoLeft = nil, autoRight = nil}
keyButtonRefs = {}
progressFill = nil
progressPct = nil
pbFrame = nil
speedLabel = nil
modeValLbl = nil
normalBox, carryBox, laggerBox, lagger2Box, radInput, batSpeedBox, uiScaleBox = nil, nil, nil, nil, nil, nil, nil
modeSelectBtn, dropModeBtnRef = nil, nil
autoBatSetVisual, autoLeftSetVisual, autoRightSetVisual, setBatCounterVisual, setMedusaVisual = nil, nil, nil, nil, nil
setAntiRagVisual, setUnwalkVisual, setAntiLagVisual, setLockUIVisual, setInstaGrab = nil, nil, nil, nil, nil
setAntiDieVisual = nil
setAntiBatVisual = nil
setAntiFlingVisual = nil
setESPVIsual = nil
setESPLineVisual = nil
mobSetAutoBat, mobSetAutoLeft, mobSetAutoRight, mobSetDropBR, mobSetTpDown, mobSetCarry, mobSetLagger1, mobSetLagger2 = nil, nil, nil, nil, nil, nil, nil, nil
miniBtn, main, gui = nil, nil, nil
MobilePanel = nil
instaResetFloatingButton = nil
showGui = nil
hideGui = nil
mainUIScale = nil
animSelectorLabel = nil
pbScale = nil
tabButtons = nil
colorSelectorLabel = nil

GAMEPAD_KEYS = {
    [Enum.KeyCode.ButtonA] = true, [Enum.KeyCode.ButtonB] = true,
    [Enum.KeyCode.ButtonX] = true, [Enum.KeyCode.ButtonY] = true,
    [Enum.KeyCode.ButtonL1] = true, [Enum.KeyCode.ButtonR1] = true,
    [Enum.KeyCode.ButtonL2] = true, [Enum.KeyCode.ButtonR2] = true,
    [Enum.KeyCode.ButtonL3] = true, [Enum.KeyCode.ButtonR3] = true,
    [Enum.KeyCode.ButtonStart] = true, [Enum.KeyCode.ButtonSelect] = true,
    [Enum.KeyCode.DPadUp] = true, [Enum.KeyCode.DPadDown] = true,
    [Enum.KeyCode.DPadLeft] = true, [Enum.KeyCode.DPadRight] = true,
}

MOVE_KEYS = {
    [Enum.KeyCode.W] = true, [Enum.KeyCode.A] = true,
    [Enum.KeyCode.S] = true, [Enum.KeyCode.D] = true,
    [Enum.KeyCode.Up] = true, [Enum.KeyCode.Left] = true,
    [Enum.KeyCode.Down] = true, [Enum.KeyCode.Right] = true,
}

BAT_COUNTER_SLAP_LIST = {
    "Bat", "Slap", "Iron Slap", "Gold Slap", "Diamond Slap",
    "Emerald Slap", "Ruby Slap", "Dark Matter Slap", "Flame Slap",
    "Nuclear Slap", "Galaxy Slap", "Glitched Slap"
}

AP = {
    L1 = _V3new(-476.48, -6.28, 92.73),
    L2 = _V3new(-483.12, -4.95, 94.80),
    L_FACE = _V3new(-482.25, -4.96, 92.09),
    R1 = _V3new(-476.16, -6.52, 25.62),
    R2 = _V3new(-483.06, -5.03, 25.48),
    R_FACE = _V3new(-482.06, -6.93, 35.47),
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

-- =====================================================================
-- TP DOWN
-- =====================================================================
TP_DOWN_OFFSET = 0.1
_G._VynxTPDownMode = (_G._VynxTPDownMode == "half") and "half" or "full"
if _G._VynxAutoTPDownEnabled == nil then _G._VynxAutoTPDownEnabled = false end
_G._VynxAutoTPDownHeightTrigger = tonumber(_G._VynxAutoTPDownHeightTrigger) or 20

local function _tpIsCarryingBrainrot(char)
    if not char then return false end
    if LP:GetAttribute("Stealing") == true or char:GetAttribute("Stealing") == true then
        return true
    end
    for _, child in ipairs(char:GetChildren()) do
        if child:IsA("Tool") then
            local n = child.Name:lower()
            if not (n:find("bat") or n:find("slap")) then return true end
        end
    end
    return false
end

local function _runTPDownHalf()
    pcall(function()
        local c = LP.Character
        if not c then return end
        local hrp = c:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        local hum = c:FindFirstChildOfClass("Humanoid")
        if not hum then return end
        local rp = _RayParams_new()
        rp.FilterDescendantsInstances = {c}
        rp.FilterType = Enum.RaycastFilterType.Exclude
        local hit = workspace:Raycast(hrp.Position, _V3new(0, -500, 0), rp)
        if hit then
            hrp.AssemblyLinearVelocity = _V3zero
            hrp.AssemblyAngularVelocity = _V3zero
            local hh = hum.HipHeight or 2
            local hy = hrp.Size.Y / 2
            hrp.CFrame = _CFnew(hit.Position.X, hit.Position.Y + hh + hy + (TP_DOWN_OFFSET or 0.1), hit.Position.Z)
            hrp.AssemblyLinearVelocity = _V3zero
        end
    end)
end

local function _runTPDownFull()
    pcall(function()
        local c = LP.Character
        if not c then return end
        local hrp = c:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        local _, yaw = hrp.CFrame:ToEulerAnglesYXZ()
        hrp.CFrame = _CFnew(hrp.Position.X, -7.00, hrp.Position.Z) * CFrame.Angles(0, yaw, 0)
        hrp.AssemblyLinearVelocity = _V3zero
    end)
end

local function executeTPDown()
    if dropActive or _G.IsDropping then return end
    local char = LP.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum or hum.Health <= 0 or hrp.Anchored or hum.Sit or hum.SeatPart then return end
    if _G._VynxTPDownMode == "half" then
        _runTPDownHalf()
    else
        _runTPDownFull()
    end
end

function doTpDown()
    executeTPDown()
end

local _tpAutoConn = RunService.Heartbeat:Connect(function()
    if _G._VynxAutoTPDownEnabled ~= true then return end
    local char = LP.Character
    if not char then return end
    if not _tpIsCarryingBrainrot(char) then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    local rp = _RayParams_new()
    rp.FilterDescendantsInstances = {char}
    rp.FilterType = Enum.RaycastFilterType.Exclude
    local hit = workspace:Raycast(root.Position, _V3new(0, -2000, 0), rp)
    if not hit then return end
    local trigger = tonumber(_G._VynxAutoTPDownHeightTrigger) or 20
    if root.Position.Y - hit.Position.Y > trigger then
        executeTPDown()
    end
end)

_G._VynxRunTPDown = executeTPDown
_G._VynxSetTPDownMode = function(m)
    _G._VynxTPDownMode = (m == "half") and "half" or "full"
    return _G._VynxTPDownMode
end
_G._VynxTPDownIsAutoOn = function() return _G._VynxAutoTPDownEnabled == true end

local _tpDownTick = executeTPDown

local _tpDownHoldConn = nil
local function startTpDownHold()
    if _tpDownHoldConn then return end
    _tpDownHoldConn = RunService.Heartbeat:Connect(function()
        local entry = KB.TPFloor
        if not entry then return end
        local kc = entry.gp or entry.kb
        if not kc then return end
        if UIS:IsKeyDown(kc) then
            pcall(_tpDownTick)
        end
    end)
end
startTpDownHold()

-- =====================================================================
-- ANTI RAGDOLL
-- =====================================================================
local AntiRagdollV2 = {
    Enabled = false,
    Connection = nil,
    ResetCooldown = 0,
}

local function startAntiRagdollV2()
    if AntiRagdollV2.Connection then return end
    AntiRagdollV2.Enabled = true
    AntiRagdollV2.Connection = RunService.Heartbeat:Connect(function()
        if not AntiRagdollV2.Enabled then return end
        local char = LP.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        local root = char:FindFirstChild("HumanoidRootPart")
        if not hum or not root or hum.Health <= 0 then return end
        if dropActive or _G.IsDropping then return end
        local state = hum:GetState()
        local now = _tick()
        if state == Enum.HumanoidStateType.Physics or
           state == Enum.HumanoidStateType.Ragdoll or
           state == Enum.HumanoidStateType.FallingDown then
            if now - AntiRagdollV2.ResetCooldown > 0.15 then
                AntiRagdollV2.ResetCooldown = now
                pcall(function()
                    hum:ChangeState(Enum.HumanoidStateType.GettingUp)
                    root.Velocity = _V3zero
                    root.RotVelocity = _V3zero
                    root.AssemblyLinearVelocity = _V3zero
                    root.AssemblyAngularVelocity = _V3zero
                    for _, obj in ipairs(char:GetDescendants()) do
                        if obj:IsA("Motor6D") then obj.Enabled = true end
                        if obj:IsA("Constraint") then obj.Enabled = true end
                    end
                    workspace.CurrentCamera.CameraSubject = hum
                    local PM = LP.PlayerScripts:FindFirstChild("PlayerModule")
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

local function stopAntiRagdollV2()
    AntiRagdollV2.Enabled = false
    if AntiRagdollV2.Connection then
        AntiRagdollV2.Connection:Disconnect()
        AntiRagdollV2.Connection = nil
    end
    AntiRagdollV2.ResetCooldown = 0
end

LP.CharacterAdded:Connect(function()
    task.wait(0.5)
    if antiRagdollMode == "v2" then
        if AntiRagdollV2.Connection then
            AntiRagdollV2.Connection:Disconnect()
            AntiRagdollV2.Connection = nil
        end
        startAntiRagdollV2()
    end
end)

function setAntiRagdollMode(mode)
    if mode == "v2" then
        startAntiRagdollV2()
        antiRagdollMode = "v2"
    else
        stopAntiRagdollV2()
        antiRagdollMode = "off"
    end
    if setAntiRagVisual then setAntiRagVisual(antiRagdollMode == "v2") end
    saveAllSettings()
end

-- =====================================================================
-- [FIX ANTI DIE VIOLETTE v2]
-- =====================================================================
_antiDieEnabled = false
_antiDieStopped = false
_antiDieSources = { toggle = false, autobat = false }

_antiDie = {
    enabled = false, loop = nil, healthConn = nil, charConn = nil,
    lastHealTime = 0, invincibleUntil = 0,
    config = {
        healthThreshold = 50,
        invincibilityFrames = 0.75,
        fallDamageProtection = false,
        ragdollProtection = true,
        autoRevive = true,
    },
}

function _antiDie.SuperHeal(hum)
    if not hum or not hum.Parent then return end
    local maxHealth = hum.MaxHealth or 100
    if maxHealth <= 0 or maxHealth == math.huge then maxHealth = 100 end
    pcall(function()
        hum.Health = maxHealth
        if hum.MaxHealth < maxHealth then hum.MaxHealth = maxHealth end
    end)
    _antiDie.invincibleUntil = _tick() + _antiDie.config.invincibilityFrames
    _antiDie.lastHealTime = _tick()
    pcall(function()
        local char = hum.Parent
        if not char then return end
        for _, child in ipairs(char:GetChildren()) do
            if child:IsA("NumberValue") then
                local name = child.Name:lower()
                if name:find("health") or name:find("hp") or name:find("life") then
                    child.Value = maxHealth
                end
            end
            if child:IsA("BoolValue") and child.Name:lower():find("dead") then
                child.Value = false
            end
        end
    end)
end

function _antiDie.PreventDamage(root, hum)
    if not hum then return end
    if hum.Health < (hum.MaxHealth or 100) then _antiDie.SuperHeal(hum) end
    if _tick() < _antiDie.invincibleUntil then
        if hum.Health < (hum.MaxHealth or 100) then
            hum.Health = hum.MaxHealth or 100
        end
    end
    if _antiDie.config.ragdollProtection then
        local state = hum:GetState()
        if state == Enum.HumanoidStateType.Physics or
           state == Enum.HumanoidStateType.Ragdoll or
           state == Enum.HumanoidStateType.FallingDown or
           state == Enum.HumanoidStateType.Dead then
            pcall(function()
                hum:ChangeState(Enum.HumanoidStateType.GettingUp)
                hum:ChangeState(Enum.HumanoidStateType.Running)
            end)
            _antiDie.SuperHeal(hum)
            if root then
                pcall(function() root.AssemblyAngularVelocity = Vector3.zero end)
            end
        end
    end
    if hum.Health <= 0 then
        _antiDie.SuperHeal(hum)
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

function _antiDie.AutoRevive()
    if not _antiDie.config.autoRevive then return end
    local char = LP.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local root = char:FindFirstChild("HumanoidRootPart")
    if not hum then return end
    if hum.Health <= 0 then
        _antiDie.SuperHeal(hum)
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
end

function _antiDie.AttachHealth(char)
    if _antiDie.healthConn then _antiDie.healthConn:Disconnect(); _antiDie.healthConn = nil end
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not hum then hum = char and char:WaitForChild("Humanoid", 3) end
    if not hum then return end
    _antiDie.healthConn = hum:GetPropertyChangedSignal("Health"):Connect(function()
        if not _antiDie.enabled then return end
        if hum.Health < (hum.MaxHealth or 100) then _antiDie.SuperHeal(hum) end
        if hum.Health <= 0 then _antiDie.AutoRevive() end
    end)
    if hum.Health < (hum.MaxHealth or 100) then _antiDie.SuperHeal(hum) end
end

function _antiDie.StartEngine()
    if _antiDie.enabled and _antiDie.loop then return end
    _antiDie.enabled = true
    _antiDieEnabled = true
    antiDieEnabled = true
    if _antiDie.loop then _antiDie.loop:Disconnect(); _antiDie.loop = nil end
    if _antiDie.healthConn then _antiDie.healthConn:Disconnect(); _antiDie.healthConn = nil end
    _antiDie.loop = RunService.Heartbeat:Connect(function()
        if not _antiDie.enabled then return end
        local char = LP.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        local root = char:FindFirstChild("HumanoidRootPart")
        if not hum then return end
        if hum.Health <= 0 then _antiDie.AutoRevive()
        elseif hum.Health <= _antiDie.config.healthThreshold then _antiDie.SuperHeal(hum)
        elseif hum.Health < (hum.MaxHealth or 100) then _antiDie.SuperHeal(hum) end
        _antiDie.PreventDamage(root, hum)
    end)
    if LP.Character then _antiDie.AttachHealth(LP.Character) end
    if _antiDie.charConn then _antiDie.charConn:Disconnect(); _antiDie.charConn = nil end
    _antiDie.charConn = LP.CharacterAdded:Connect(function(char)
        if not _antiDie.enabled then return end
        task.wait(0.05)
        _antiDie.AttachHealth(char)
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then _antiDie.SuperHeal(hum) end
    end)
end

function _antiDie.StopEngine()
    _antiDie.enabled = false
    _antiDieEnabled = false
    antiDieEnabled = false
    if _antiDie.loop then _antiDie.loop:Disconnect(); _antiDie.loop = nil end
    if _antiDie.healthConn then _antiDie.healthConn:Disconnect(); _antiDie.healthConn = nil end
    if _antiDie.charConn then _antiDie.charConn:Disconnect(); _antiDie.charConn = nil end
    pcall(function()
        local char = LP.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if not hum then return end
        hum:SetStateEnabled(Enum.HumanoidStateType.Dead, true)
        hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, true)
        hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
        hum.BreakJointsOnDeath = true
        if hum.MaxHealth == math.huge or hum.MaxHealth <= 0 then
            hum.MaxHealth = 100
            hum.Health = math.min(hum.Health, 100)
        end
    end)
end

function _antiDieSetEnabled(enabled)
    enabled = enabled == true
    if enabled == _antiDieEnabled then return end
    if enabled then
        _antiDie.StartEngine()
    else
        _antiDie.StopEngine()
    end
end

function _antiDieRefresh()
    if _antiDieStopped then return end
    local manual = _antiDieSources.toggle
    _antiDieSetEnabled(manual or _antiDieSources.autobat)
end

_G.__CrystalAntiDieSource = function(source, enabled)
    if _antiDieStopped or _antiDieSources[source] == nil then return end
    _antiDieSources[source] = enabled == true
    _antiDieRefresh()
end

_G.__CrystalAntiDieSet = function(enabled)
    _G.__CrystalAntiDieSource("autobat", enabled)
end

_G.__CrystalAntiDieIsEnabled = function() return _antiDieEnabled end
_G.__CrystalAntiDieStop = function()
    _antiDieStopped = true
    _antiDieSources.toggle = false
    _antiDieSources.autobat = false
    _antiDieSetEnabled(false)
end

function activateOnCharacter(char)
    if not _antiDieEnabled then return end
    _antiDie.AttachHealth(char)
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if hum then _antiDie.SuperHeal(hum) end
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

-- =====================================================================
-- BAT SKINS (ported from Cleanbyprinted)
    katanaSkinEnabled = false
    do
        local function createKatanaSkinController()
            local katanaPlayersService = game:GetService("Players")
            local katanaInsertService = game:GetService("InsertService")
            local katanaLighting = game:GetService("Lighting")
            local katanaReplicatedStorage = game:GetService("ReplicatedStorage")
            local katanaPlayer = katanaPlayersService.LocalPlayer
            local katanaColors = {
                red = Color3.new(0.784314, 0, 0),
                red2 = Color3.new(1, 0, 0.392157),
                gold = Color3.new(1, 0.843137, 0),
            }
            local katanaState = {
                Skin = "KATANA",
                SkinOrder = {
                    "KATANA",
                    "NONE",
                },
                LastBat = nil,
                LastAppliedSkin = nil,
                OriginalKatanaTemplate = nil,
                ExactTemplates = {},
                ExactTemplateSearched = {},
                ExactAssetIds = {
                    KATANA = "",
                },
                Original = {},
            }
            local function findBat()
                local character = katanaPlayer.Character
                if character then
                    local bat = character:FindFirstChild("Bat")
                    if bat and bat:IsA("Tool") then
                        return bat
                    end
                end
                local backpack = katanaPlayer:FindFirstChildOfClass("Backpack")
                if backpack then
                    local bat = backpack:FindFirstChild("Bat")
                    if bat and bat:IsA("Tool") then
                        return bat
                    end
                end
                return nil
            end
            local function configureVisualPart(part)
                if not part or not part:IsA("BasePart") then
                    return
                end
                part.Anchored = false
                part.CanCollide = false
                part.CanTouch = false
                part.CanQuery = false
                part.Massless = true
            end
            local function weldToHandle(part1, part0)
                if not part1 or not part0 or not part1:IsA("BasePart") or not part0:IsA("BasePart") then
                    return
                end
                configureVisualPart(part1)
                local weldConstraint = Instance.new("WeldConstraint")
                weldConstraint.Name = "FlowerSkin_AssetWeld"
                weldConstraint.Part0 = part0
                weldConstraint.Part1 = part1
                weldConstraint.Parent = part1
            end
            local function cacheOriginalBatState(batTool)
                if not batTool then
                    return
                end
                local handle = batTool:FindFirstChild("Handle")
                local slash = batTool:FindFirstChild("Slash")
                katanaState.Original[batTool] = katanaState.Original[batTool] or {}
                local originalState = katanaState.Original[batTool]
                if handle and handle:IsA("BasePart") and not originalState.Handle then
                    originalState.Handle = {
                        Transparency = handle.Transparency,
                        LocalTransparencyModifier = handle.LocalTransparencyModifier,
                        CastShadow = handle.CastShadow,
                    }
                end
                if slash and slash:IsA("Sound") and not originalState.SlashSoundId then
                    originalState.SlashSoundId = slash.SoundId
                end
            end
            local function captureOriginalKatanaTemplate()
                if katanaState.OriginalKatanaTemplate then
                    return
                end
                local function scanContainer(container)
                    if not container then
                        return
                    end
                    local bat = container:FindFirstChild("Bat")
                    if not bat then
                        return
                    end
                    local flowerSkinKatanaRealistic = bat:FindFirstChild("FlowerSkin_KatanaRealistic")
                    flowerSkinKatanaRealistic = flowerSkinKatanaRealistic
                        and flowerSkinKatanaRealistic:FindFirstChild("FlowerSkin_AssetKatana")
                    if flowerSkinKatanaRealistic then
                        katanaState.OriginalKatanaTemplate = flowerSkinKatanaRealistic:Clone()
                    end
                end
                scanContainer(katanaPlayer:FindFirstChildOfClass("Backpack"))
                scanContainer(katanaPlayer.Character)
            end
            local function setBatHandleHidden(batTool, hidden)
                local handle523 = batTool and batTool:FindFirstChild("Handle")
                if not handle523 or not handle523:IsA("BasePart") then
                    return
                end
                cacheOriginalBatState(batTool)
                if hidden then
                    handle523.LocalTransparencyModifier = 1
                    handle523.Transparency = 1
                    handle523.CastShadow = false
                else
                    local handle = katanaState.Original[batTool] and katanaState.Original[batTool].Handle
                    handle523.LocalTransparencyModifier = handle and handle.LocalTransparencyModifier or 0
                    handle523.Transparency = handle and handle.Transparency or 0
                    handle523.CastShadow = handle and handle.CastShadow
                    if handle523.CastShadow == nil then
                        handle523.CastShadow = true
                    end
                end
            end
            local function setBatSlashSound(batTool, soundId)
                cacheOriginalBatState(batTool)
                local slash = batTool and batTool:FindFirstChild("Slash")
                if slash and slash:IsA("Sound") then
                    if not soundId then
                        soundId = katanaState.Original[batTool] and katanaState.Original[batTool].SlashSoundId
                            or slash.SoundId
                    end
                    slash.SoundId = soundId
                end
            end
            local function restoreOriginalBatVisual(batTool)
                if not batTool then
                    return
                end
                local flowerSkinKatanaRealistic = batTool:FindFirstChild("FlowerSkin_KatanaRealistic")
                if flowerSkinKatanaRealistic then
                    flowerSkinKatanaRealistic:Destroy()
                end
                local flowerSkinAssetKatana = batTool:FindFirstChild("FlowerSkin_AssetKatana")
                if flowerSkinAssetKatana then
                    flowerSkinAssetKatana:Destroy()
                end
                setBatHandleHidden(batTool, false)
                setBatSlashSound(batTool, nil)
            end
            local function addKatanaRedEffects(parent)
                if not parent or not parent:IsA("BasePart") then
                    return
                end
                local fictionHubSpeedIndicator = parent:FindFirstChild("FictionHubSpeedIndicator")
                if fictionHubSpeedIndicator then
                    fictionHubSpeedIndicator:Destroy()
                end
                local topAttachment = Instance.new("Attachment")
                topAttachment.Name = "FlowerSkin_ExtraRedVFX"
                topAttachment.Position = Vector3.new(0, parent.Size.Y * 0.5, 0)
                topAttachment.Parent = parent
                local bottomAttachment = Instance.new("Attachment")
                bottomAttachment.Name = "FlowerSkin_ExtraRedVFX_End"
                bottomAttachment.Position = Vector3.new(0, -parent.Size.Y * 0.5, 0)
                bottomAttachment.Parent = parent
                local trail = Instance.new("Trail")
                trail.Name = "FlowerSkin_ExtraRedVFX"
                trail.Attachment0 = topAttachment
                trail.Attachment1 = bottomAttachment
                trail.Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, katanaColors.red2),
                    ColorSequenceKeypoint.new(1, Color3.new(0.54902, 0, 0)),
                })
                trail.Transparency = NumberSequence.new({
                    NumberSequenceKeypoint.new(0, 0.35),
                    NumberSequenceKeypoint.new(1, 1),
                })
                trail.Lifetime = 0.18
                trail.LightEmission = 0.55
                trail.Parent = parent
                local particleEmitter = Instance.new("ParticleEmitter")
                particleEmitter.Name = "FlowerSkin_ExtraRedVFX"
                local red2 = katanaColors.red2
                particleEmitter.Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Color3.new(0.784314, 0, 0)),
                    ColorSequenceKeypoint.new(1, red2),
                })
                particleEmitter.LightEmission = 0.55
                particleEmitter.Rate = 14
                particleEmitter.Lifetime = NumberRange.new(0.3, 0.45)
                particleEmitter.Speed = NumberRange.new(0.2, 0.7)
                particleEmitter.SpreadAngle = Vector2.new(12, 12)
                particleEmitter.Size = NumberSequence.new({
                    NumberSequenceKeypoint.new(0, 0.08),
                    NumberSequenceKeypoint.new(1, 0),
                })
                particleEmitter.Texture = "rbxasset://textures/particles/sparkles_main.dds"
                particleEmitter.Parent = parent
            end
            local function createKatanaPart(parent, name, size, cframeOffset, color, material)
                local part = Instance.new("Part")
                part.Name = name
                part.Size = size
                part.Color = color
                part.Material = material or Enum.Material.Neon
                part.TopSurface = Enum.SurfaceType.Smooth
                part.BottomSurface = Enum.SurfaceType.Smooth
                configureVisualPart(part)
                part.Parent = parent
                return part, cframeOffset or CFrame.identity
            end
            local katanaCandidateNames = {
                KATANA = {
                    "FlowerSkin_AssetKatana",
                    "Katana",
                    "FlowerSkin_KatanaRealistic",
                },
            }
            local function isScriptInstance(instance)
                return instance:IsA("Script") or instance:IsA("LocalScript") or instance:IsA("ModuleScript")
            end
            local function removeScripts(root)
                if not root then
                    return
                end
                if isScriptInstance(root) then
                    root:Destroy()
                    return
                end
                for _, descendant in ipairs(root:GetDescendants()) do
                    if isScriptInstance(descendant) then
                        descendant:Destroy()
                    end
                end
            end
            local function hasBasePart(candidate)
                if not candidate then
                    return false
                end
                if candidate:IsA("BasePart") then
                    return true
                end
                return candidate:FindFirstChildWhichIsA("BasePart", true) ~= nil
            end
            local function isGeneratedSkin(candidate)
                local ok, result = pcall(function()
                    return candidate:GetAttribute("CursedBatSkinsGenerated")
                end)
                return ok and result == true
            end
            local function validateSkinCandidate(candidate)
                if not candidate or isGeneratedSkin(candidate) then
                    return nil
                end
                if
                    candidate:IsA("Model")
                    or candidate:IsA("Tool")
                    or candidate:IsA("Accessory")
                    or candidate:IsA("BasePart")
                then
                    if hasBasePart(candidate) then
                        return candidate
                    end
                end
                return nil
            end
            local function findNamedSkinCandidate(root, candidateNames)
                if not root then
                    return nil
                end
                for _, entry in ipairs(candidateNames) do
                    if root.Name ~= entry then
                        continue
                    end
                    local candidate = validateSkinCandidate(root)
                    if candidate then
                        return candidate
                    end
                end
                for _, candidateName in ipairs(candidateNames) do
                    local instance = root:FindFirstChild(candidateName, true)
                    local validatedCandidate = validateSkinCandidate(instance)
                    if validatedCandidate then
                        return validatedCandidate
                    end
                end
                return nil
            end
            local function normalizeAssetId(assetId)
                local normalizedId = tostring(assetId or ""):gsub("%s+", "")
                if normalizedId == "" then
                    return nil
                end
                if normalizedId:match("^rbxassetid://") or normalizedId:match("^rbxasset://") then
                    return normalizedId
                end
                if normalizedId:match("^%d+$") then
                    return "rbxassetid://" .. normalizedId
                end
                return normalizedId
            end
            local function loadAssetSkinTemplate(skinName)
                local assetUri = normalizeAssetId(katanaState.ExactAssetIds[skinName])
                if not assetUri then
                    return nil
                end
                local loadedAssets = {}
                pcall(function()
                    loadedAssets = game:GetObjects(assetUri)
                end)
                if #loadedAssets == 0 then
                    local match = tostring(assetUri):match("(%d+)")
                    if match then
                        pcall(function()
                            table.insert(loadedAssets, katanaInsertService:LoadAsset(tonumber(match)))
                        end)
                    end
                end
                local candidateNames = katanaCandidateNames[skinName] or {}
                for _, entry in ipairs(loadedAssets) do
                    local candidate = findNamedSkinCandidate(entry, candidateNames) or validateSkinCandidate(entry)
                    if candidate then
                        local clone = candidate:Clone()
                        removeScripts(clone)
                        return clone
                    end
                end
                return nil
            end
            local function findExistingSkinTemplate(skinName)
                local candidateNames = katanaCandidateNames[skinName]
                if not candidateNames then
                    return nil
                end
                local searchRoots = {}
                local character = katanaPlayer.Character
                local backpack = katanaPlayer:FindFirstChildOfClass("Backpack")
                local workspaceRoot = workspace
                local lightingRoot = katanaLighting
                searchRoots[1] = character
                searchRoots[2] = backpack
                searchRoots[3] = katanaReplicatedStorage
                searchRoots[4] = lightingRoot
                searchRoots[5] = workspaceRoot
                for _, entry in ipairs(searchRoots) do
                    local candidate = findNamedSkinCandidate(entry, candidateNames)
                    if candidate then
                        local clone = candidate:Clone()
                        removeScripts(clone)
                        return clone
                    end
                end
                return nil
            end
            local function getSkinTemplate(skinName)
                if skinName == "KATANA" and katanaState.OriginalKatanaTemplate then
                    return katanaState.OriginalKatanaTemplate
                end
                if katanaState.ExactTemplates[skinName] then
                    return katanaState.ExactTemplates[skinName]
                end
                if katanaState.ExactTemplateSearched[skinName] then
                    return nil
                end
                katanaState.ExactTemplateSearched[skinName] = true
                local template = loadAssetSkinTemplate(skinName) or findExistingSkinTemplate(skinName)
                if template then
                    katanaState.ExactTemplates[skinName] = template
                end
                return template
            end
            local normalizeSkinModel = nil
            normalizeSkinModel = function(source, parent)
                if source:IsA("Model") then
                    source.Name = "FlowerSkin_AssetKatana"
                    source.Parent = parent
                    return source
                end
                if source:IsA("BasePart") then
                    local model = Instance.new("Model")
                    model.Name = "FlowerSkin_AssetKatana"
                    model.Parent = parent
                    source.Parent = model
                    return model
                end
                if source:IsA("Tool") or source:IsA("Folder") then
                    local flowerSkinAssetKatana = source:FindFirstChild("FlowerSkin_AssetKatana")
                        or source:FindFirstChildWhichIsA("Model")
                        or source:FindFirstChildWhichIsA("BasePart")
                    if flowerSkinAssetKatana and flowerSkinAssetKatana.Parent == source then
                        flowerSkinAssetKatana.Parent = nil
                        source:Destroy()
                        return normalizeSkinModel(flowerSkinAssetKatana, parent)
                    end
                    local model = Instance.new("Model")
                    model.Name = "FlowerSkin_AssetKatana"
                    model.Parent = parent
                    for _, child in ipairs(source:GetChildren()) do
                        if not isScriptInstance(child) then
                            child.Parent = model
                        end
                    end
                    source:Destroy()
                    return model
                end
                return nil
            end
            local function applyExactSkinTemplate(batTool, skinName)
                local handle = batTool and batTool:FindFirstChild("Handle")
                if not handle or not handle:IsA("BasePart") then
                    return false
                end
                local template = getSkinTemplate(skinName)
                if not template then
                    return false
                end
                local folder = Instance.new("Folder")
                folder.Name = "FlowerSkin_KatanaRealistic"
                folder.Parent = batTool
                local skinModel = normalizeSkinModel(template:Clone(), folder)
                if not skinModel or not hasBasePart(skinModel) then
                    folder:Destroy()
                    return false
                end
                removeScripts(skinModel)
                pcall(function()
                    skinModel:SetAttribute("CursedBatSkinsExactMesh", true)
                end)
                local firstPart = nil
                for _, descendant in ipairs(skinModel:GetDescendants()) do
                    if descendant:IsA("BasePart") then
                        firstPart = firstPart or descendant
                        configureVisualPart(descendant)
                    end
                end
                if not firstPart then
                    folder:Destroy()
                    return false
                end
                if skinModel:IsA("Model") then
                    skinModel.PrimaryPart = skinModel.PrimaryPart or firstPart
                    pcall(function()
                        skinModel:PivotTo(handle.CFrame)
                    end)
                end
                for _, descendant in ipairs(skinModel:GetDescendants()) do
                    if descendant:IsA("BasePart") then
                        weldToHandle(descendant, handle)
                    end
                end
                local weaponPart = skinModel:FindFirstChild("SharpParts", true)
                    or skinModel:FindFirstChild("WeaponPart", true)
                    or skinModel:FindFirstChild("Handle", true)
                    or firstPart
                if weaponPart and not weaponPart:FindFirstChild("FlowerSkin_ExtraRedVFX") then
                    addKatanaRedEffects(weaponPart)
                end
                return true
            end
            local function createProceduralKatana(batTool, skinName)
                local handle = batTool and batTool:FindFirstChild("Handle")
                if not handle or not handle:IsA("BasePart") then
                    return nil
                end
                local folder = Instance.new("Folder")
                folder.Name = "FlowerSkin_KatanaRealistic"
                folder.Parent = batTool
                local model = Instance.new("Model")
                model.Name = "FlowerSkin_AssetKatana"
                model:SetAttribute("CursedBatSkinsGenerated", true)
                model.Parent = folder
                local createdParts = {}
                local function createPart(name, size, cframeOffset, color, material)
                    local part, offset = createKatanaPart(model, name, size, cframeOffset, color, material)
                    part.CFrame = handle.CFrame * offset
                    weldToHandle(part, handle)
                    table.insert(createdParts, part)
                    return part
                end
                if skinName == "KATANA" then
                    local metal = Enum.Material.Metal
                    createPart(
                        "Handle2",
                        Vector3.new(0.22, 1, 0.22),
                        CFrame.new(0, -0.48, 0),
                        Color3.new(0.176471, 0.176471, 0.045),
                        metal
                    )
                    local red2 = katanaColors.red2
                    local neon = Enum.Material.Neon
                    local sharpParts =
                        createPart("SharpParts", Vector3.new(0.18, 2.4, 0.12), CFrame.new(0, 1.05, 0), red2, neon)
                    local red = katanaColors.red
                    local neon2 = Enum.Material.Neon
                    createPart("WeaponPart", Vector3.new(0.3, 2.7, 0.08), CFrame.new(0.08, 1.15, 0), red, neon2)
                    local gold = katanaColors.gold
                    local neon3 = Enum.Material.Neon
                    createPart("GoldAccent", Vector3.new(0.5, 0.12, 0.08), CFrame.new(0, -0.28, 0), gold, neon3)
                    addKatanaRedEffects(sharpParts)
                end
                model.PrimaryPart = createdParts[1]
                return model
            end
            local slashSoundIds = {
                KATANA = "rbxassetid://111808555599832",
            }
            return {
                State = katanaState,
                ApplySkin = function(skinName)
                    captureOriginalKatanaTemplate()
                    local lastBat = findBat()
                    if not lastBat then
                        katanaState.LastBat = nil
                        katanaState.LastAppliedSkin = nil
                        return false
                    end
                    cacheOriginalBatState(lastBat)
                    restoreOriginalBatVisual(lastBat)
                    if skinName == "NONE" then
                        katanaState.LastBat = lastBat
                        katanaState.LastAppliedSkin = skinName
                        return true
                    end
                    setBatHandleHidden(lastBat, true)
                    setBatSlashSound(lastBat, slashSoundIds[skinName])
                    if not applyExactSkinTemplate(lastBat, skinName) then
                        createProceduralKatana(lastBat, skinName)
                    end
                    local handle = lastBat:FindFirstChild("Handle")
                    if handle then
                        local fire = handle:FindFirstChildOfClass("Fire") or handle:FindFirstChild("Fire")
                        if fire and fire:IsA("Fire") then
                            fire.Enabled = true
                            fire.Color = katanaColors.red
                            fire.SecondaryColor = katanaColors.red2
                        end
                    end
                    katanaState.LastBat = lastBat
                    katanaState.LastAppliedSkin = skinName
                    return true
                end,
                SetExactAssetId = function(assetId)
                    katanaState.ExactAssetIds.KATANA = tostring(assetId or "")
                    katanaState.ExactTemplateSearched.KATANA = nil
                    katanaState.ExactTemplates.KATANA = nil
                end,
            }
        end
        katanaSkinController = createKatanaSkinController()
    end
    _G.CursedBatKatana = katanaSkinController
    task.spawn(function()
        while true do
            if katanaSkinEnabled then
                local character = LP.Character
                local bat = nil
                if character then
                    bat = character:FindFirstChild("Bat")
                    local isTool = bat and bat:IsA("Tool")
                    if not isTool then
                        bat = nil
                    end
                end
                local needsSkinRefresh
                if not bat then
                    local backpack = LP:FindFirstChildOfClass("Backpack")
                    if backpack then
                        local bat2 = backpack:FindFirstChild("Bat")
                        if bat2 and bat2:IsA("Tool") then
                            needsSkinRefresh = bat2
                        else
                            needsSkinRefresh = bat
                        end
                    else
                        needsSkinRefresh = bat
                    end
                else
                    needsSkinRefresh = bat
                end
                needsSkinRefresh = needsSkinRefresh
                    and (
                        needsSkinRefresh ~= katanaSkinController.State.LastBat
                        or katanaSkinController.State.LastAppliedSkin ~= "KATANA"
                    )
                if needsSkinRefresh then
                    pcall(function()
                        katanaSkinController.ApplySkin("KATANA")
                    end)
                end
            end
            task.wait(0.5)
        end
    end)
    minecraftBatSkinEnabled = false
    minecraftBatSkinColorMode = "Default"
    MinecraftBatSetVisual = nil
    MinecraftBatColorSelector = nil
    do
        local function createMinecraftBatController()
            local batGripOffset = _CFnew(-0.18, -0.52, -0.2)
            local batGripRotation = CFrame.Angles(0.78539816339744828, 0, 0.087266462599716474)
            local minecraftBatColors = {
                ["Default"] = nil,
                ["Abyss Blue"] = Color3.fromRGB(0, 40, 150),
                ["Venom Green"] = Color3.fromRGB(20, 85, 50),
                ["Royal Gold"] = Color3.fromRGB(255, 200, 0),
                ["Velvet Rose"] = Color3.fromRGB(220, 20, 100),
                ["Crimson Night"] = Color3.fromRGB(90, 0, 20),
            }
            local minecraftBatState = {
                enabled = false,
                colorMode = "Default",
                cachedVisualPart = nil,
                rgbConnection = nil,
            }
            local ok, result = pcall(function()
                return game:GetObjects("rbxassetid://18566246244")
            end)
            if ok and result and #result > 0 then
                local assetRoot = result[1]
                minecraftBatState.cachedVisualPart = assetRoot:IsA("BasePart") and assetRoot
                    or assetRoot:FindFirstChildWhichIsA("BasePart", true)
            end
            local function setPartColor(part, color)
                if not part or not color then
                    return
                end
                part.Color = color
                if part:IsA("UnionOperation") then
                    pcall(function()
                        part.UsePartColor = true
                    end)
                end
                local specialMesh = part:FindFirstChildWhichIsA("SpecialMesh")
                if specialMesh then
                    specialMesh.VertexColor = Vector3.new(color.R, color.G, color.B)
                end
            end
            local function findBat()
                local character = LP.Character
                if character then
                    local bat = character:FindFirstChild("Bat")
                    if bat and bat:IsA("Tool") then
                        return bat
                    end
                end
                local backpack = LP:FindFirstChildOfClass("Backpack")
                if backpack then
                    local bat = backpack:FindFirstChild("Bat")
                    if bat and bat:IsA("Tool") then
                        return bat
                    end
                end
                return nil
            end
            local function restoreBatVisual(batTool)
                if not batTool then
                    return
                end
                local customUnionVisual = batTool:FindFirstChild("CustomUnionVisual")
                if customUnionVisual then
                    pcall(function()
                        customUnionVisual:Destroy()
                    end)
                end
                local handle = batTool:FindFirstChild("Handle")
                if handle then
                    handle.Transparency = 0
                    for _, child in ipairs(handle:GetChildren()) do
                        if child:IsA("SpecialMesh") or child:IsA("Mesh") or child:IsA("Decal") then
                            pcall(function()
                                child.Transparency = 0
                            end)
                        end
                    end
                end
            end
            local function applyMinecraftBatVisual(batTool)
                if not batTool or batTool.Name ~= "Bat" or not minecraftBatState.cachedVisualPart then
                    return
                end
                local handle = batTool:WaitForChild("Handle", 2)
                if not handle then
                    return
                end
                local oldVisual = batTool:FindFirstChild("CustomUnionVisual")
                if oldVisual then
                    oldVisual:Destroy()
                end
                handle.Transparency = 1
                for _, child in ipairs(handle:GetChildren()) do
                    if child:IsA("SpecialMesh") or child:IsA("Mesh") or child:IsA("Decal") then
                        pcall(function()
                            child.Transparency = 1
                        end)
                    end
                end
                local visualPart = minecraftBatState.cachedVisualPart:Clone()
                visualPart.Name = "CustomUnionVisual"
                visualPart.CanCollide = false
                visualPart.Massless = true
                visualPart.Anchored = false
                local scaleModel = Instance.new("Model")
                visualPart.Parent = scaleModel
                scaleModel.PrimaryPart = visualPart
                pcall(function()
                    scaleModel:ScaleTo(2)
                end)
                visualPart.Parent = nil
                scaleModel:Destroy()
                if minecraftBatState.colorMode == "RGB" then
                    setPartColor(visualPart, Color3.fromHSV(tick() % 3 / 3, 1, 1))
                elseif minecraftBatColors[minecraftBatState.colorMode] then
                    setPartColor(visualPart, minecraftBatColors[minecraftBatState.colorMode])
                end
                for _, child in ipairs(visualPart:GetChildren()) do
                    if child:IsA("Weld") or child:IsA("WeldConstraint") then
                        child:Destroy()
                    end
                end
                visualPart.CFrame = handle.CFrame * batGripOffset * batGripRotation
                visualPart.Parent = batTool
                local weld = Instance.new("WeldConstraint")
                weld.Part0 = handle
                weld.Part1 = visualPart
                weld.Parent = visualPart
            end
            local function startRgbCycle()
                if minecraftBatState.rgbConnection then
                    return
                end
                minecraftBatState.rgbConnection = RunService.RenderStepped:Connect(function()
                    if not minecraftBatState.enabled or minecraftBatState.colorMode ~= "RGB" then
                        return
                    end
                    local currentBat = findBat()
                    if not currentBat then
                        return
                    end
                    local customVisual = currentBat:FindFirstChild("CustomUnionVisual")
                    if customVisual then
                        setPartColor(customVisual, Color3.fromHSV(tick() % 3 / 3, 1, 1))
                    end
                end)
            end
            local function stopRgbCycle()
                if minecraftBatState.rgbConnection then
                    minecraftBatState.rgbConnection:Disconnect()
                    minecraftBatState.rgbConnection = nil
                end
            end
            return {
                State = minecraftBatState,
                Colors = minecraftBatColors,
                FindBat = findBat,
                Apply = function()
                    if not minecraftBatState.enabled then
                        return
                    end
                    local batTool = findBat()
                    if batTool then
                        applyMinecraftBatVisual(batTool)
                    end
                    if minecraftBatState.colorMode == "RGB" then
                        startRgbCycle()
                    end
                end,
                Remove = function()
                    stopRgbCycle()
                    local character = LP.Character
                    if character then
                        local bat = character:FindFirstChild("Bat")
                        if bat then
                            restoreBatVisual(bat)
                        end
                    end
                    local backpack = LP:FindFirstChildOfClass("Backpack")
                    if backpack then
                        local bat = backpack:FindFirstChild("Bat")
                        if bat then
                            restoreBatVisual(bat)
                        end
                    end
                end,
                SetColorMode = function(colorMode)
                    minecraftBatState.colorMode = colorMode
                    if not minecraftBatState.enabled then
                        return
                    end
                    if colorMode == "RGB" then
                        startRgbCycle()
                    else
                        stopRgbCycle()
                    end
                    local batTool = findBat()
                    if batTool then
                        applyMinecraftBatVisual(batTool)
                    end
                end,
            }
        end
        minecraftBatSkinController = createMinecraftBatController()
    end
    task.spawn(function()
        while true do
            if minecraftBatSkinEnabled then
                minecraftBatSkinController.State.enabled = true
                local currentBat = minecraftBatSkinController.FindBat()
                if currentBat and not currentBat:FindFirstChild("CustomUnionVisual") then
                    pcall(minecraftBatSkinController.Apply)
                end
            else
                minecraftBatSkinController.State.enabled = false
            end
            task.wait(0.5)
        end
    end)

-- ANTI BAT (lógica portada desde Violette)
-- Reemplaza la versión previa de ELITE FAMILY que usaba root.Velocity y que
-- también recuperaba del ragdoll. Ahora sólo aplica el pulso de
-- AssemblyLinearVelocity (500, y, 500) y espera un RenderStepped para
-- restaurar el componente horizontal. La recuperación de ragdoll queda
-- exclusivamente a cargo del toggle "Anti Ragdoll".
-- =====================================================================
local AntiBat = { Connection = nil }

function stopAntiBat()
    antiBatEnabled = false
    if AntiBat.Connection then
        AntiBat.Connection:Disconnect()
        AntiBat.Connection = nil
    end
end

function startAntiBat()
    stopAntiBat()
    antiBatEnabled = true

    local char = LP.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end

    AntiBat.Connection = RunService.Heartbeat:Connect(function()
        if not antiBatEnabled then return end

        if not root or not root.Parent then
            root = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
            if not root then return end
        end

        local vel  = root.AssemblyLinearVelocity
        local flat = Vector3.new(vel.X, 0, vel.Z)

        root.AssemblyLinearVelocity = Vector3.new(500, vel.Y, 500)
        RunService.RenderStepped:Wait()
        if root and root.Parent then
            local y2 = root.AssemblyLinearVelocity.Y
            root.AssemblyLinearVelocity = Vector3.new(flat.X, y2, flat.Z)
        end
    end)
end

LP.CharacterAdded:Connect(function()
    task.wait(0.3)
    if antiBatEnabled then startAntiBat() end
end)

-- =====================================================================
-- ANTI FLING (lógica portada desde Violette)
-- Cancela velocidades horizontales anómalas (>80 studs/s) y rotaciones
-- extremas (>40 rad/s) que no provienen del propio hub.
-- Ignora: drop activo, aimbots/paths activos, y velocidad propia reciente.
-- =====================================================================
setAntiFlingVisual = nil

local _antiFlingState = {
    connection    = nil,
    threshold     = 80,
    spinThreshold = 40,
}
local _ANTI_FLING_DRIVE_GRACE = 0.3

local function _afHubSpeedLive()
    local live = _G.__EliteFamilyLiveSpeed
    if type(live) ~= "table" then return false end
    local stamp, speed = tonumber(live.t), tonumber(live.v)
    if not stamp or not speed or speed <= 0 then return false end
    return (os.clock() - stamp) <= _ANTI_FLING_DRIVE_GRACE
end

local function _afOwnMoverActive()
    -- Si estamos usando TPBat/Desync, el CFrame salta y no queremos cancelar
    if batDesyncTpEnabled then return true end
    -- Aimbot y auto-path usan velocidades que podrían confundirse con fling
    if autoBatEnabled then return true end
    if autoLeftEnabled or autoRightEnabled then return true end
    return false
end

function startAntiFling()
    if _antiFlingState.connection then return end
    antiFlingEnabled = true
    _antiFlingState.connection = RunService.Heartbeat:Connect(function()
        if not antiFlingEnabled then return end
        local character = LP.Character
        if not character then return end
        local root = character:FindFirstChild("HumanoidRootPart")
        if not root then return end
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid and (humanoid.Health <= 0 or humanoid.SeatPart) then return end

        -- Guardas: no pisar nuestras propias acciones
        if dropActive or _G.IsDropping then return end
        if _afOwnMoverActive() then return end
        if _afHubSpeedLive() then return end

        local velocity = root.AssemblyLinearVelocity
        local flat = Vector3.new(velocity.X, 0, velocity.Z)

        if flat.Magnitude > _antiFlingState.threshold then
            pcall(function()
                root.AssemblyLinearVelocity = Vector3.new(0, velocity.Y, 0)
                root.AssemblyAngularVelocity = Vector3.zero
            end)
            return
        end
        if root.AssemblyAngularVelocity.Magnitude > _antiFlingState.spinThreshold then
            pcall(function() root.AssemblyAngularVelocity = Vector3.zero end)
        end
    end)
end

function stopAntiFling()
    antiFlingEnabled = false
    if _antiFlingState.connection then
        _antiFlingState.connection:Disconnect()
        _antiFlingState.connection = nil
    end
end

LP.CharacterAdded:Connect(function()
    task.wait(0.3)
    if antiFlingEnabled then startAntiFling() end
end)

-- =====================================================================
-- ESP
-- =====================================================================
local espEnabled = espEnabled or false
local espActivePlayers = {}
local espLoopConn = nil
local Camera = workspace.CurrentCamera
local GUI2_ESP_COLOR = Color3.fromRGB(139, 72, 246)
local GUI2_ESP_TEXT_STROKE = Color3.fromRGB(48, 16, 92)

local function getESPThemeColors(accent)
    local c = getThemeColor() or accent or Color3.fromRGB(245, 245, 250)
    return c, Color3.fromRGB(0, 0, 0)
end

local function createESP()
    local currentFill, currentLine = getESPThemeColors()
    local esp = {
        Tracer = Drawing and Drawing.new("Line") or nil,
        Highlight = Instance.new("Highlight"),
        Lines = {},
    }
    if esp.Tracer then
        esp.Tracer.Color = currentLine
        esp.Tracer.Thickness = 3
        esp.Tracer.Transparency = 1
        esp.Tracer.ZIndex = 2
    end

    esp.Highlight.Name = "EliteFamilyESP_Highlight"
    esp.Highlight.FillColor = currentFill
    esp.Highlight.OutlineColor = Color3.fromRGB(0, 0, 0)
    esp.Highlight.FillTransparency = 0.12
    esp.Highlight.OutlineTransparency = 0.18
    esp.Highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop

    local parentGui
    local ok, robGui = pcall(function() return game:GetService("CoreGui"):FindFirstChild("RobloxGui") end)
    if ok and robGui then parentGui = robGui else parentGui = LP:FindFirstChildOfClass("PlayerGui") end
    if not parentGui then parentGui = game:GetService("CoreGui") end
    pcall(function() esp.Highlight.Parent = parentGui end)

    local nameBillboard = Instance.new("BillboardGui")
    nameBillboard.Name = "EliteFamilyESP_Name"
    nameBillboard.Size = UDim2.new(0, 170, 0, 28)
    nameBillboard.StudsOffset = Vector3.new(0, 1.3, 0)
    nameBillboard.AlwaysOnTop = true
    nameBillboard.Parent = parentGui

    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(0, 170, 0, 28)
    nameLabel.AnchorPoint = Vector2.new(0.5, 0)
    nameLabel.Position = UDim2.new(0.5, 0, 0, 2)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = ""
    nameLabel.TextColor3 = getThemeColor()
    nameLabel.TextSize = 15
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    nameLabel.TextStrokeTransparency = 0
    nameLabel.TextXAlignment = Enum.TextXAlignment.Center
    nameLabel.TextYAlignment = Enum.TextYAlignment.Center
    nameLabel.ZIndex = 5
    nameLabel.Parent = nameBillboard

    local nameOutline = Instance.new("UIStroke")
    nameOutline.Color = Color3.fromRGB(0, 0, 0)
    nameOutline.Thickness = 2.2
    nameOutline.Transparency = 0.12
    nameOutline.Parent = nameLabel

    if Drawing then
        for i = 1, 14 do
            local line = Drawing.new("Line")
            line.Color = currentLine
            line.Thickness = 2
            line.Transparency = 1
            line.ZIndex = 3
            table.insert(esp.Lines, line)
        end
    end

    esp.NameTag = nameBillboard
    esp.NameLabel = nameLabel
    esp.NameOutline = nameOutline
    return esp
end

_G.__EliteFamilyRefreshESPTheme = function(accent, outlineColor)
    local fillColor, lineColor = getESPThemeColors(accent)
    for _, data in pairs(espActivePlayers) do
        if type(data) == "table" and data.esp then
            local esp = data.esp
            if esp.Tracer then pcall(function() esp.Tracer.Color = lineColor end) end
            if esp.Highlight then
                esp.Highlight.FillColor = fillColor
                esp.Highlight.OutlineColor = Color3.fromRGB(0, 0, 0)
            end
            if esp.NameLabel then
                esp.NameLabel.TextColor3 = getThemeColor()
                esp.NameLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
            end
            if esp.NameOutline then esp.NameOutline.Color = Color3.fromRGB(0, 0, 0) end
            for _, line in ipairs(esp.Lines or {}) do pcall(function() line.Color = lineColor end) end
        end
    end
end

local function removeESP(plr)
    local data = espActivePlayers[plr]
    if data then
        if data.esp.Tracer then pcall(function() data.esp.Tracer:Remove() end) end
        if data.esp.Highlight then pcall(function() data.esp.Highlight:Destroy() end) end
        if data.esp.NameTag then pcall(function() data.esp.NameTag:Destroy() end) end
        for _, line in ipairs(data.esp.Lines) do
            pcall(function() line:Remove() end)
        end
        espActivePlayers[plr] = nil
    end
end

local function updateESP(plr, esp)
    if not espEnabled then
        if esp.Tracer then esp.Tracer.Visible = false end
        esp.Highlight.Enabled = false
        for _, line in ipairs(esp.Lines) do line.Visible = false end
        if esp.NameTag then esp.NameTag.Enabled = false end
        return
    end

    local character = plr.Character
    local hum = character and character:FindFirstChildOfClass("Humanoid")
    local trackPart = character and (
        character:FindFirstChild("HumanoidRootPart")
        or character.PrimaryPart
        or character:FindFirstChild("UpperTorso")
        or character:FindFirstChild("Torso")
        or character:FindFirstChild("Head")
    )

    if character and trackPart and (not hum or hum.Health > 0) then
        esp.Highlight.Adornee = character
        esp.Highlight.Enabled = espEnabled
        if esp.Tracer then esp.Tracer.Visible = false end
        for _, line in ipairs(esp.Lines) do line.Visible = false end

        if esp.NameTag and esp.NameLabel then
            pcall(function()
                esp.NameTag.Adornee = trackPart
                esp.NameTag.Enabled = espEnabled
                esp.NameLabel.Text = plr.Name or plr.DisplayName or ""
                esp.NameLabel.TextColor3 = getThemeColor()
            end)
        end
    else
        if esp.Tracer then esp.Tracer.Visible = false end
        esp.Highlight.Enabled = false
        esp.Highlight.Adornee = nil
        for _, line in ipairs(esp.Lines) do line.Visible = false end
        if esp.NameTag then esp.NameTag.Enabled = false end
    end
end

local function createESPForPlayer(plr)
    if plr == LP then return end
    if espActivePlayers[plr] and espActivePlayers[plr].esp then
        if espActivePlayers[plr].esp.NameTag then
            pcall(function() espActivePlayers[plr].esp.NameTag.Enabled = espEnabled end)
        end
        return
    end
    removeESP(plr)
    local esp = createESP()
    espActivePlayers[plr] = { esp = esp }
end

local espJoinConn, espLeaveConn
local function enableESP()
    if espEnabled then return end
    espEnabled = true
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LP then task.spawn(function() createESPForPlayer(plr) end) end
    end
    local espAccumulator = 0
    if espLoopConn then espLoopConn:Disconnect() end
    espLoopConn = RunService.Heartbeat:Connect(function(dt)
        espAccumulator = espAccumulator + (dt or 0)
        if espAccumulator < 0.15 then return end
        espAccumulator = 0
        for plr, data in pairs(espActivePlayers) do
            if typeof(plr) == "Instance" and plr:IsA("Player") and data and data.esp then
                pcall(function() updateESP(plr, data.esp) end)
            end
        end
    end)
    espJoinConn = Players.PlayerAdded:Connect(function(plr)
        if not espEnabled or plr == LP then return end
        task.wait(0.3)
        createESPForPlayer(plr)
    end)
    espLeaveConn = Players.PlayerRemoving:Connect(function(plr) removeESP(plr) end)
end

local function disableESP()
    espEnabled = false
    if espLoopConn then espLoopConn:Disconnect(); espLoopConn = nil end
    if espJoinConn then pcall(function() espJoinConn:Disconnect() end); espJoinConn = nil end
    if espLeaveConn then pcall(function() espLeaveConn:Disconnect() end); espLeaveConn = nil end
    for plr in pairs(espActivePlayers) do
        if typeof(plr) == "Instance" and plr:IsA("Player") and plr ~= LP then removeESP(plr) end
    end
end

function toggleESP(on)
    if on then enableESP() else disableESP() end
    if setESPVIsual then setESPVIsual(on) end
end

-- =====================================================================
-- ESP LINE
-- =====================================================================
local _espLineGui = nil
local _espLineFrame = nil
local _espLineOutline = nil
local _espLineConn = nil
local _espLineState = { scanElapsed = math.huge, targetRoot = nil }

local function ensureESPLineGui()
    if _espLineGui and _espLineGui.Parent then return end
    _espLineGui = Instance.new("ScreenGui")
    _espLineGui.Name = "EliteFamilyESPLine"
    _espLineGui.IgnoreGuiInset = true
    _espLineGui.ResetOnSpawn = false
    _espLineGui.DisplayOrder = 1000
    _espLineGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    local okP = pcall(function() _espLineGui.Parent = game:GetService("CoreGui") end)
    if not okP then _espLineGui.Parent = LP:WaitForChild("PlayerGui") end

    _espLineFrame = Instance.new("Frame")
    _espLineFrame.Name = "ESPLine"
    _espLineFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    _espLineFrame.BorderSizePixel = 0
    _espLineFrame.Active = false
    _espLineFrame.Visible = false
    _espLineFrame.BackgroundColor3 = getThemeColor()
    _espLineFrame.ZIndex = 1
    _espLineFrame.Parent = _espLineGui

    _espLineOutline = Instance.new("UIStroke", _espLineFrame)
    _espLineOutline.Color = Color3.fromRGB(255, 255, 255)
    _espLineOutline.Thickness = 0.7
    _espLineOutline.Transparency = 0.45
end

function stopESPLine()
    espLineEnabled = false
    if _espLineConn then _espLineConn:Disconnect(); _espLineConn = nil end
    if _espLineFrame then _espLineFrame.Visible = false end
    _espLineState.targetRoot = nil
    _espLineState.scanElapsed = math.huge
    if _espLineGui and _espLineGui.Parent then
        pcall(function() _espLineGui:Destroy() end)
    end
    _espLineGui = nil
    _espLineFrame = nil
    _espLineOutline = nil
end

function startESPLine()
    espLineEnabled = true
    ensureESPLineGui()
    if _espLineConn then _espLineConn:Disconnect() end
    _espLineState.scanElapsed = math.huge
    _espLineState.targetRoot = nil

    _espLineConn = RunService.RenderStepped:Connect(function(dt)
        if not espLineEnabled then
            if _espLineFrame then _espLineFrame.Visible = false end
            return
        end
        local ok = pcall(function()
            local activeCamera = workspace.CurrentCamera
            local myChar = LP.Character
            local myRoot = myChar and (myChar:FindFirstChild("LowerTorso") or myChar:FindFirstChild("HumanoidRootPart") or myChar:FindFirstChild("Torso"))
            if not activeCamera or not myRoot then
                if _espLineFrame then _espLineFrame.Visible = false end
                return
            end

            local myPosition = myRoot.Position
            _espLineState.scanElapsed = _espLineState.scanElapsed + (dt or 0)
            local cachedRoot = _espLineState.targetRoot
            local cachedCharacter = cachedRoot and cachedRoot.Parent
            local cachedHumanoid = cachedCharacter and cachedCharacter:FindFirstChildOfClass("Humanoid")
            local cachedValid = cachedRoot and cachedRoot.Parent and (not cachedHumanoid or cachedHumanoid.Health > 0)
            if _espLineState.scanElapsed >= 0.12 or not cachedValid then
                _espLineState.scanElapsed = 0
                local closestRoot, closestDistanceSq = nil, math.huge
                for _, otherPlayer in ipairs(Players:GetPlayers()) do
                    if otherPlayer ~= LP then
                        local character = otherPlayer.Character
                        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
                        local root = character and (character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("LowerTorso") or character:FindFirstChild("Torso"))
                        if root and root:IsA("BasePart") and (not humanoid or humanoid.Health > 0) then
                            local delta = root.Position - myPosition
                            local distanceSq = delta:Dot(delta)
                            if distanceSq < closestDistanceSq then
                                closestRoot, closestDistanceSq = root, distanceSq
                            end
                        end
                    end
                end
                _espLineState.targetRoot = closestRoot
            end

            local closestRoot = _espLineState.targetRoot
            if not closestRoot or not closestRoot.Parent then
                if _espLineFrame then _espLineFrame.Visible = false end
                return
            end
            local closestPosition = closestRoot.Position

            local from = activeCamera:WorldToViewportPoint(myPosition - Vector3.new(0, myRoot.Size.Y * 0.35, 0))
            local to, targetOnScreen = activeCamera:WorldToViewportPoint(closestPosition)
            local viewport = activeCamera.ViewportSize
            local fromPoint = Vector2.new(from.X, from.Y)
            local targetPoint = Vector2.new(to.X, to.Y)

            if not targetOnScreen or to.Z <= 0 then
                local center = viewport * 0.5
                local direction = targetPoint - center
                if to.Z <= 0 then direction = -direction end
                if direction.Magnitude < 0.001 then direction = Vector2.new(0, -1) end
                local limit = Vector2.new(math.max(8, center.X - 8), math.max(8, center.Y - 8))
                local scaleX = limit.X / math.max(math.abs(direction.X), 0.001)
                local scaleY = limit.Y / math.max(math.abs(direction.Y), 0.001)
                targetPoint = center + direction * math.min(scaleX, scaleY)
            end

            if from.Z <= 0 or fromPoint.X < 0 or fromPoint.X > viewport.X or fromPoint.Y < 0 or fromPoint.Y > viewport.Y then
                fromPoint = Vector2.new(viewport.X * 0.5, viewport.Y - 8)
            end

            local delta = targetPoint - fromPoint
            local midpoint = (fromPoint + targetPoint) * 0.5
            _espLineFrame.Position = UDim2.fromOffset(midpoint.X, midpoint.Y)
            _espLineFrame.Size = UDim2.fromOffset(math.max(delta.Magnitude, 1), 2)
            _espLineFrame.Rotation = math.deg(math.atan2(delta.Y, delta.X))
            _espLineFrame.BackgroundColor3 = getThemeColor()
            _espLineFrame.Visible = true
        end)
        if not ok and _espLineFrame then
            pcall(function() _espLineFrame.Visible = false end)
        end
    end)
end

local _enemySpeedAcc = 0
function updateEnemySpeedLabels()
    _enemySpeedAcc = _enemySpeedAcc + 1
    if _enemySpeedAcc < 6 then return end
    _enemySpeedAcc = 0
    local color = getThemeColor()
    local players = _GetPlayersCached()
    for i = 1, #players do
        local player = players[i]
        if player ~= LP then
            local char = player.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if hrp and hum and hum.Health > 0 then
                local v = hrp.AssemblyLinearVelocity
                local speed = _sqrt(v.X*v.X + v.Z*v.Z)
                local label = enemySpeedLabels[player]
                if not label then
                    local head = char:FindFirstChild("Head")
                    if head then
                        local bb = Instance.new("BillboardGui")
                        bb.Size = UDim2.new(0, 100, 0, 25)
                        bb.StudsOffset = _V3new(0, 5.5, 0)
                        bb.AlwaysOnTop = true
                        bb.Name = "EnemySpeedGui"
                        bb.Parent = head
                        local tl = Instance.new("TextLabel", bb)
                        tl.Size = UDim2.new(1, 0, 1, 0)
                        tl.BackgroundTransparency = 1
                        tl.TextColor3 = color
                        tl.Font = Enum.Font.GothamBold
                        tl.TextScaled = true
                        tl.TextStrokeTransparency = 0
                        tl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                        enemySpeedLabels[player] = tl
                        label = tl
                    end
                elseif label.Parent and label.Parent.Parent ~= char then
                    local head = char:FindFirstChild("Head")
                    if head then label.Parent.Parent = head end
                end
                if label then
                    label.Text = string.format("%.1f", speed)
                    if label.TextColor3 ~= color then label.TextColor3 = color end
                end
            else
                local label = enemySpeedLabels[player]
                if label and label.Parent and label.Parent.Parent then label.Parent.Parent = nil end
                enemySpeedLabels[player] = nil
            end
        end
    end
end

function startEnemySpeed()
    if enemySpeedConn then enemySpeedConn:Disconnect() end
    enemySpeedConn = RunService.Heartbeat:Connect(updateEnemySpeedLabels)
end

function stopEnemySpeed()
    if enemySpeedConn then enemySpeedConn:Disconnect(); enemySpeedConn = nil end
end

local function getClosestTargetBody()
    local char = LP.Character
    if not char then return nil end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return nil end
    local rpos = root.Position
    local closest, minDist = nil, _huge
    local plist = _GetPlayersCached()
    for i = 1, #plist do
        local plr = plist[i]
        if plr ~= LP then
            local c = plr.Character
            if c then
                local tRoot = c:FindFirstChild("HumanoidRootPart")
                if tRoot then
                    local hum = c:FindFirstChildOfClass("Humanoid")
                    if hum and hum.Health > 0 then
                        local dx = tRoot.Position.X - rpos.X
                        local dy = tRoot.Position.Y - rpos.Y
                        local dz = tRoot.Position.Z - rpos.Z
                        local d = dx*dx + dy*dy + dz*dz
                        if d < minDist then minDist = d; closest = tRoot end
                    end
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
    local predictTime = _clamp(speed3 / 80, 0.08, 0.35)
    local predictedPos = target.Position + targetVel * predictTime
    local targetHead = target.Parent and target.Parent:FindFirstChild("Head")
    local targetHeight = targetHead and targetHead.Position.Y or target.Position.Y
    local myHeight = root.Position.Y + (hum.HipHeight or 0)
    local heightDiff = targetHeight - myHeight
    local verticalCorrection = _clamp(heightDiff * 0.15, -1.5, 1.5)
    local flatTarget = _V3new(predictedPos.X, root.Position.Y + verticalCorrection, predictedPos.Z)
    local toPredict = flatTarget - root.Position
    if toPredict.Magnitude > 0.1 then
        local goalCF = _CFlookAt(root.Position, flatTarget)
        local diffCF = root.CFrame:Inverse() * goalCF
        local _, ry, _ = diffCF:ToEulerAnglesXYZ()
        ry = _clamp(ry, -2.5, 2.5)
        root.AssemblyAngularVelocity = root.CFrame:VectorToWorldSpace(_V3new(0, ry * 42, 0))
    end
end

function startBodyLock()
    if _bodyLockConn then _bodyLockConn:Disconnect() end
    local acc = 0
    _bodyLockConn = RunService.Heartbeat:Connect(function(dt)
        if not bodyLockEnabled then return end
        if _blSuppressCount > 0 then return end
        acc = acc + dt
        if acc < 0.033 then return end
        acc = 0
        _bodyLockTick()
    end)
end

function stopBodyLock()
    if _bodyLockConn then
        _bodyLockConn:Disconnect()
        _bodyLockConn = nil
    end
    local c = LP.Character
    local root = c and c:FindFirstChild("HumanoidRootPart")
    if root then
        root.AssemblyAngularVelocity = _V3zero
        root.AssemblyLinearVelocity = _V3new(root.AssemblyLinearVelocity.X, -0.1, root.AssemblyLinearVelocity.Z)
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
        if _blRestoreTimer then
            task.cancel(_blRestoreTimer)
            _blRestoreTimer = nil
        end
        _blSmoothRestore = false
    end
end

function _unsuppressBodyLock(delayed)
    if _blSuppressCount > 0 then
        _blSuppressCount = _blSuppressCount - 1
    end
    if _blSuppressCount == 0 and _blWasEnabled then
        _blWasEnabled = false
        if _blRestoreTimer then
            pcall(task.cancel, _blRestoreTimer)
            _blRestoreTimer = nil
        end
        local function restore()
            _blRestoreTimer = nil
            if bodyLockEnabled then
                _blSmoothRestore = true
                startBodyLock()
                if bodyLockSetVisual then bodyLockSetVisual(true) end
                task.delay(0.5, function() _blSmoothRestore = false end)
            end
        end
        if delayed then
            _blRestoreTimer = task.delay(1, restore)
        else
            restore()
        end
    end
end

function setupSpeedIndicator(char)
    local head = char:WaitForChild("Head", 5)
    if not head then return end
    local oldBB = head:FindFirstChild("EliteFamilySpeedIndicator")
    if oldBB then oldBB:Destroy() end
    local oldDiscord = head:FindFirstChild("DiscordText")
    if oldDiscord then oldDiscord:Destroy() end

    local bb = Instance.new("BillboardGui", head)
    bb.Name = "EliteFamilySpeedIndicator"
    bb.Size = UDim2.fromOffset(200, 58)
    bb.StudsOffset = Vector3.new(0, 3.2, 0)
    bb.AlwaysOnTop = true
    bb.LightInfluence = 0
    bb.MaxDistance = 0

    local discordLabel = Instance.new("TextLabel", bb)
    discordLabel.Name = "DiscordText"
    discordLabel.Size = UDim2.new(1, 0, 0, 28)
    discordLabel.Position = UDim2.new(0, 0, 0, 0)
    discordLabel.BackgroundTransparency = 1
    discordLabel.Text = "ELITE FAMILY"
    discordLabel.TextColor3 = getThemeColor()
    discordLabel.Font = Enum.Font.GothamBlack
    discordLabel.TextSize = 19
    discordLabel.TextXAlignment = Enum.TextXAlignment.Center
    discordLabel.TextYAlignment = Enum.TextYAlignment.Center
    discordLabel.TextStrokeTransparency = 0
    discordLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    local dlStroke = Instance.new("UIStroke", discordLabel)
    dlStroke.Color = Color3.fromRGB(0, 0, 0)
    dlStroke.Thickness = 1.5
    dlStroke.Transparency = 0.2
    applyShimmerToText(discordLabel, 0.9)

    speedLabel = Instance.new("TextLabel", bb)
    speedLabel.Name = "SpeedLabel"
    speedLabel.Size = UDim2.new(1, 0, 0, 30)
    speedLabel.Position = UDim2.new(0, 0, 0, 28)
    speedLabel.BackgroundTransparency = 1
    speedLabel.Text = "0.0  -  " .. getSpeedModeName()
    speedLabel.TextColor3 = getThemeColor()
    speedLabel.Font = Enum.Font.GothamBlack
    speedLabel.TextSize = 22
    speedLabel.TextXAlignment = Enum.TextXAlignment.Center
    speedLabel.TextYAlignment = Enum.TextYAlignment.Center
    speedLabel.TextStrokeTransparency = 0
    speedLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    local slStroke = Instance.new("UIStroke", speedLabel)
    slStroke.Color = Color3.fromRGB(0, 0, 0)
    slStroke.Thickness = 1.5
    slStroke.Transparency = 0.2
    applyShimmerToText(speedLabel, 0.9)
end

local unwalkSavedAnimate = nil

function startUnwalk()
    local c = LP.Character
    if not c then return end
    local hum = c:FindFirstChildOfClass("Humanoid")
    if hum then
        for _, t in ipairs(hum:GetPlayingAnimationTracks()) do pcall(function() t:Stop() end) end
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
        if laggerCarryToggled then modeValLbl.Text = "Lagger Carry"
        elseif laggerToggled then modeValLbl.Text = "Lagger Normal"
        elseif speedMode then modeValLbl.Text = "Carry"
        else modeValLbl.Text = "Normal" end
    end
    if setCarryModeVisual then setCarryModeVisual(speedMode) end
    if setLaggerModeVisual then setLaggerModeVisual(laggerToggled) end
    if setLaggerCarryVisual then setLaggerCarryVisual(laggerCarryToggled) end
end

function resetMovementState()
    refreshSpeedModeLabel()
    if mobSetCarry then mobSetCarry(speedMode) end
    if setLaggerModeVisual then setLaggerModeVisual(laggerToggled) end
    if setLaggerCarryVisual then setLaggerCarryVisual(laggerCarryToggled) end
end

function toggleCarryMode()
    if laggerToggled or laggerCarryToggled then
        laggerToggled = false; laggerCarryToggled = false; speedMode = true
    else speedMode = not speedMode end
    resetMovementState()
    if _G.__EliteFamilyApplySpeedNow then pcall(_G.__EliteFamilyApplySpeedNow) end
end

function toggleLaggerMode()
    if laggerCarryToggled then laggerCarryToggled = false end
    speedMode = false; laggerToggled = not laggerToggled
    resetMovementState()
    if _G.__EliteFamilyApplySpeedNow then pcall(_G.__EliteFamilyApplySpeedNow) end
end
function toggleLaggerCarryMode()
    if laggerToggled then laggerToggled = false end
    speedMode = false; laggerCarryToggled = not laggerCarryToggled
    resetMovementState()
    if _G.__EliteFamilyApplySpeedNow then pcall(_G.__EliteFamilyApplySpeedNow) end
end

function toggleLaggerCycle()
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
    if _G.__EliteFamilyApplySpeedNow then pcall(_G.__EliteFamilyApplySpeedNow) end
end

function stopAutoLeft()
    if alConn then alConn:Disconnect(); alConn = nil end
    alPhase = 1
    local char = LP.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then hum:Move(_V3zero, false) end
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
            local tgt = _V3new(AP.L1.X, root.Position.Y, AP.L1.Z)
            if (tgt - root.Position).Magnitude < 1 then
                alPhase = 2
                local d = AP.L2 - root.Position
                local mv = _V3new(d.X, 0, d.Z).Unit
                hum:Move(mv, false)
                root.AssemblyLinearVelocity = _V3new(mv.X * spd, root.AssemblyLinearVelocity.Y, mv.Z * spd)
                return
            end
            local d = AP.L1 - root.Position
            local mv = _V3new(d.X, 0, d.Z).Unit
            hum:Move(mv, false)
            root.AssemblyLinearVelocity = _V3new(mv.X * spd, root.AssemblyLinearVelocity.Y, mv.Z * spd)
        elseif alPhase == 2 then
            local tgt = _V3new(AP.L2.X, root.Position.Y, AP.L2.Z)
            if (tgt - root.Position).Magnitude < 1 then
                hum:Move(_V3zero, false)
                root.AssemblyLinearVelocity = _V3zero
                autoLeftEnabled = false
                if alConn then alConn:Disconnect(); alConn = nil end
                alPhase = 1
                if autoLeftSetVisual then autoLeftSetVisual(false) end
                if mobSetAutoLeft then mobSetAutoLeft(false) end
                _unsuppressBodyLock(true)
                local facePos = _V3new(AP.L_FACE.X, root.Position.Y, AP.L_FACE.Z)
                if (facePos - root.Position).Magnitude > 0.01 then
                    root.CFrame = _CFnew(root.Position, facePos)
                end
                return
            end
            local d = AP.L2 - root.Position
            local mv = _V3new(d.X, 0, d.Z).Unit
            hum:Move(mv, false)
            root.AssemblyLinearVelocity = _V3new(mv.X * spd, root.AssemblyLinearVelocity.Y, mv.Z * spd)
        end
    end)
end

function stopAutoRight()
    if arConn then arConn:Disconnect(); arConn = nil end
    arPhase = 1
    local char = LP.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then hum:Move(_V3zero, false) end
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
            local tgt = _V3new(AP.R1.X, root.Position.Y, AP.R1.Z)
            if (tgt - root.Position).Magnitude < 1 then
                arPhase = 2
                local d = AP.R2 - root.Position
                local mv = _V3new(d.X, 0, d.Z).Unit
                hum:Move(mv, false)
                root.AssemblyLinearVelocity = _V3new(mv.X * spd, root.AssemblyLinearVelocity.Y, mv.Z * spd)
                return
            end
            local d = AP.R1 - root.Position
            local mv = _V3new(d.X, 0, d.Z).Unit
            hum:Move(mv, false)
            root.AssemblyLinearVelocity = _V3new(mv.X * spd, root.AssemblyLinearVelocity.Y, mv.Z * spd)
        elseif arPhase == 2 then
            local tgt = _V3new(AP.R2.X, root.Position.Y, AP.R2.Z)
            if (tgt - root.Position).Magnitude < 1 then
                hum:Move(_V3zero, false)
                root.AssemblyLinearVelocity = _V3zero
                autoRightEnabled = false
                if arConn then arConn:Disconnect(); arConn = nil end
                arPhase = 1
                if autoRightSetVisual then autoRightSetVisual(false) end
                if mobSetAutoRight then mobSetAutoRight(false) end
                _unsuppressBodyLock(true)
                local facePos = _V3new(AP.R_FACE.X, root.Position.Y, AP.R_FACE.Z)
                if (facePos - root.Position).Magnitude > 0.01 then
                    root.CFrame = _CFnew(root.Position, facePos)
                end
                return
            end
            local d = AP.R2 - root.Position
            local mv = _V3new(d.X, 0, d.Z).Unit
            hum:Move(mv, false)
            root.AssemblyLinearVelocity = _V3new(mv.X * spd, root.AssemblyLinearVelocity.Y, mv.Z * spd)
        end
    end)
end

function getClosestTarget()
    local char = LP.Character
    if not char then return nil end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return nil end
    local rpos = root.Position
    local closest, minDist = nil, _huge
    local plist = _GetPlayersCached()
    for i = 1, #plist do
        local plr = plist[i]
        if plr ~= LP then
            local c = plr.Character
            if c then
                local tRoot = c:FindFirstChild("HumanoidRootPart")
                if tRoot then
                    local hum = c:FindFirstChildOfClass("Humanoid")
                    if hum and hum.Health > 0 then
                        local dx = tRoot.Position.X - rpos.X
                        local dy = tRoot.Position.Y - rpos.Y
                        local dz = tRoot.Position.Z - rpos.Z
                        local d = dx*dx + dy*dy + dz*dz
                        if d < minDist then minDist = d; closest = tRoot end
                    end
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
        root.AssemblyLinearVelocity = _V3new(0, -0.1, 0)
        root.AssemblyAngularVelocity = _V3zero
    end
    _prevAutoRotate = nil
    lastMoveDir = _V3zero
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
            if bat then pcall(function() hum:EquipTool(bat) end) end
        end
        local target = getClosestTarget()
        if not target then return end
        local targetVel = target.AssemblyLinearVelocity
        local myPos = root.Position
        local targetPos = target.Position
        local predictPos = targetPos + targetVel * 0.14
        predictPos = predictPos + target.CFrame.LookVector * 0.3
        local direction = predictPos - myPos
        local flatDir = _V3new(direction.X, 0, direction.Z)
        if flatDir.Magnitude > 0 then flatDir = flatDir.Unit else flatDir = _V3new(0,0,0) end
        local desiredHeight = targetPos.Y + 3.7
        local yVel = (desiredHeight - myPos.Y) * 19.5 + targetVel.Y * 0.8
        if hum.FloorMaterial ~= Enum.Material.Air then yVel = math.max(yVel, 13) end
        yVel = _clamp(yVel, -70, 110)
        local desiredVel = _V3new(flatDir.X * BAT_AIMBOT_SPEED, yVel, flatDir.Z * BAT_AIMBOT_SPEED)
        root.AssemblyLinearVelocity = root.AssemblyLinearVelocity:Lerp(desiredVel, 0.8)
        local speed3 = targetVel.Magnitude
        local predictTime = _clamp(speed3 / 150, 0.05, 0.2)
        local predictedPos = targetPos + targetVel * predictTime
        local toPredict = predictedPos - myPos
        if toPredict.Magnitude > 0.1 then
            local goalCF = _CFlookAt(myPos, predictedPos)
            local diffCF = root.CFrame:Inverse() * goalCF
            local rx, ry, rz = diffCF:ToEulerAnglesXYZ()
            rx = _clamp(rx, -2.5, 2.5)
            ry = _clamp(ry, -2.5, 2.5)
            rz = _clamp(rz, -2.5, 2.5)
            root.AssemblyAngularVelocity = root.CFrame:VectorToWorldSpace(_V3new(rx * 42, ry * 42, rz * 42))
        end
        local distToTarget = (root.Position - target.Position).Magnitude
        if distToTarget <= 8 then trySwing() end
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
    if batDesyncTpEnabled then toggleBatDesyncTp() end
    autoBatEnabled = true
    if autoBatSetVisual then autoBatSetVisual(true) end
    if mobSetAutoBat then mobSetAutoBat(true) end
    startAimbotAdapt()
end


local function updateTpBatButtonWithAntiDie(state)
    if tpBatFloatingButton then
        local btnFrame = tpBatFloatingButton:FindFirstChild("Frame")
        if btnFrame then
            local label = btnFrame:FindFirstChild("TextLabel")
            if state then
                paintFloatingBtn(btnFrame, true)
                if label then label.Text = "TP\nBAT" end
            else
                if label then label.Text = "TP\nBAT" end
                paintFloatingBtn(btnFrame, batDesyncTpEnabled)
            end
        end
    end
end

local batDesyncTpEnabled = false
local batDesyncTpConn = nil
local batDesyncTpSetVisual = nil
local hittingCooldownDesync = false
local _tpBatUnwalkForced = false

local function getBatDesync()
    local char = LP.Character
    if not char then return nil end
    local tool = char:FindFirstChild("Bat")
    if tool then return tool end
    local bp2 = LP:FindFirstChild("Backpack")
    if bp2 then
        tool = bp2:FindFirstChild("Bat")
        if tool then
            tool.Parent = char
            return tool
        end
    end
    return nil
end

local function tryHitBatDesync()
    if hittingCooldownDesync then return end
    hittingCooldownDesync = true
    pcall(function()
        local bat = getBatDesync()
        if bat then
            bat:Activate()
            local ev = bat:FindFirstChildWhichIsA("RemoteEvent")
            if ev then ev:FireServer() end
        end
    end)
    task.delay(0.08, function() hittingCooldownDesync = false end)
end

local function getClosestPlayerDesync()
    local char = LP.Character
    if not char then return nil, _huge end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil, _huge end
    local hpos = hrp.Position
    local cp, cd = nil, _huge
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LP and p.Character then
            local tr = p.Character:FindFirstChild("HumanoidRootPart")
            if tr then
                local d = (hpos - tr.Position).Magnitude
                if d < cd then cd = d; cp = p end
            end
        end
    end
    return cp, cd
end

-- [ELITE] Marcador azul de ultima posicion
do
    local ELITE_MARKER_DISTANCE   = 3
    local ELITE_MIN_X, ELITE_MAX_X = -536.2, -422
    local ELITE_MIN_Y, ELITE_MAX_Y = -10,    75
    local ELITE_MIN_Z, ELITE_MAX_Z = -71.8, 192.9
    local ELITE_GROUND_Y          = -7
    local ELITE_LOOKBACK          = 0.2
    local ELITE_SAMPLE_INTERVAL   = 1 / 60

    local markerState = {
        markerLocked = false,
        markerTarget = nil,
        lastMarker   = nil,
        samples      = {},
        accumulator  = 0,
    }

    local function isInsideAllowedArea(pos)
        if not pos then return false end
        return pos.X >= ELITE_MIN_X and pos.X <= ELITE_MAX_X
           and pos.Y >= ELITE_MIN_Y and pos.Y <= ELITE_MAX_Y
           and pos.Z >= ELITE_MIN_Z and pos.Z <= ELITE_MAX_Z
    end

    local function finiteVector(v)
        return v ~= nil
            and v.X == v.X and v.Y == v.Y and v.Z == v.Z
            and math.abs(v.X) < 1e7
            and math.abs(v.Y) < 1e7
            and math.abs(v.Z) < 1e7
    end

    local function hideMarkerVisuals(marker)
        if not marker then return end
        pcall(function()
            marker.Transparency = 1
            local s = marker:FindFirstChild("AlwaysOnTopSphere")
            if s then s.Visible = false end
            local h = marker:FindFirstChild("LastPositionHighlight")
            if h then h.Enabled = false end
            local b = marker:FindFirstChild("LastPositionLabel")
            if b then b.Enabled = false end
        end)
    end

    local function clearLastMarker()
        markerState.markerLocked = false
        if markerState.lastMarker then
            hideMarkerVisuals(markerState.lastMarker)
        end
    end

    local function getLastMarkerCFrame()
        local marker = markerState.lastMarker
        if not (markerState.markerLocked and marker and marker.Parent and marker.Transparency < 1) then
            return nil
        end
        local tracked = markerState.markerTarget
        local trackedRoot = tracked and tracked.Character
                             and tracked.Character:FindFirstChild("HumanoidRootPart")
        if trackedRoot and isInsideAllowedArea(trackedRoot.Position) then
            clearLastMarker()
            return nil
        end
        local myChar = LP.Character
        local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
        if not myRoot then return marker.CFrame end
        local away = Vector3.new(
            myRoot.Position.X - marker.Position.X, 0,
            myRoot.Position.Z - marker.Position.Z
        )
        if away.Magnitude <= 0.05 then
            local look = marker.CFrame.LookVector
            away = Vector3.new(-look.X, 0, -look.Z)
        end
        if away.Magnitude <= 0.05 then away = Vector3.new(0, 0, 1) end
        local teleportPos = marker.Position + away.Unit * ELITE_MARKER_DISTANCE
        local flat = Vector3.new(
            marker.Position.X - teleportPos.X, 0,
            marker.Position.Z - teleportPos.Z
        )
        if flat.Magnitude > 0.05 then
            return _CFlookAt(teleportPos, teleportPos + flat.Unit)
        end
        return _CFnew(teleportPos)
    end

    local function createOrUpdateMarker(targetCFrame)
        if markerState.markerLocked then return end
        local tracked = markerState.markerTarget
        if not tracked or tracked.Parent ~= Players then return end
        local char = tracked.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        local hum  = char and char:FindFirstChildOfClass("Humanoid")
        if not root or not hum or hum.Health <= 0 then return end
        if not finiteVector(root.Position) then return end
        if isInsideAllowedArea(root.Position) then return end
        if not targetCFrame or not isInsideAllowedArea(targetCFrame.Position) then return end

        local groundCF = _CFnew(
            targetCFrame.Position.X,
            ELITE_GROUND_Y,
            targetCFrame.Position.Z
        ) * targetCFrame.Rotation

        local marker = markerState.lastMarker
        if not marker or not marker.Parent then
            marker = Instance.new("Part")
            marker.Name         = "EliteFamilyTPBatLastPosition"
            marker.Shape        = Enum.PartType.Ball
            marker.Size         = Vector3.new(3, 3, 3)
            marker.Color        = Color3.fromRGB(0, 110, 255)
            marker.Material     = Enum.Material.Neon
            marker.Anchored     = true
            marker.CanCollide   = false
            marker.CanTouch     = false
            marker.CanQuery     = false
            marker.CastShadow   = false
            marker.Parent       = Workspace

            local overlay = Instance.new("SphereHandleAdornment")
            overlay.Name        = "AlwaysOnTopSphere"
            overlay.Adornee     = marker
            overlay.Radius      = 1.55
            overlay.Color3      = Color3.fromRGB(0, 125, 255)
            overlay.Transparency = 0.05
            overlay.AlwaysOnTop = true
            overlay.Visible     = true
            overlay.ZIndex      = 10
            overlay.Parent      = marker

            local hl = Instance.new("Highlight")
            hl.Name = "LastPositionHighlight"
            hl.Adornee = marker
            hl.FillColor = Color3.fromRGB(0, 110, 255)
            hl.FillTransparency = 0.15
            hl.OutlineColor = Color3.fromRGB(120, 200, 255)
            hl.OutlineTransparency = 0
            hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            hl.Enabled = true
            hl.Parent = marker

            local bb = Instance.new("BillboardGui")
            bb.Name = "LastPositionLabel"
            bb.Size = UDim2.new(0, 110, 0, 20)
            bb.StudsOffset = Vector3.new(0, 2.1, 0)
            bb.AlwaysOnTop = true
            bb.Adornee = marker
            bb.Parent = marker

            local lbl = Instance.new("TextLabel")
            lbl.Name = "Text"
            lbl.Size = UDim2.fromScale(1, 1)
            lbl.BackgroundTransparency = 1
            lbl.Text = "ultima posicion"
            lbl.TextColor3 = Color3.fromRGB(220, 235, 255)
            lbl.TextStrokeColor3 = Color3.fromRGB(0, 35, 90)
            lbl.TextStrokeTransparency = 0.25
            lbl.TextSize = 11
            lbl.Font = Enum.Font.GothamMedium
            lbl.Parent = bb

            markerState.lastMarker = marker
        end

        marker.Transparency = 0
        local s = marker:FindFirstChild("AlwaysOnTopSphere");      if s then s.Visible = true end
        local h = marker:FindFirstChild("LastPositionHighlight");  if h then h.Enabled = true end
        local b = marker:FindFirstChild("LastPositionLabel");      if b then b.Enabled = true end
        marker.CFrame = groundCF
        markerState.markerLocked = true
    end

    local function snapshotBeforeExit(history, now)
        if not history or #history == 0 then return nil end
        local cutoff = now - ELITE_LOOKBACK
        local selected
        for _, entry in ipairs(history) do
            if entry.time <= cutoff then selected = entry else break end
        end
        return selected or history[1]
    end

    local function pickClosestEnemy(myRoot)
        local closest, bestDistSq = nil, _huge
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LP and plr.Character then
                local r = plr.Character:FindFirstChild("HumanoidRootPart")
                local h = plr.Character:FindFirstChildOfClass("Humanoid")
                if r and h and h.Health > 0 and finiteVector(r.Position) then
                    local d = (r.Position - myRoot.Position).Magnitude
                    if d < bestDistSq then closest = plr; bestDistSq = d end
                end
            end
        end
        return closest
    end

    local function monitorLastTarget()
        local myChar = LP.Character
        local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
        if not myRoot then return end

        local tracked = markerState.markerTarget
        if tracked and tracked.Parent == Players then
            local char = tracked.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            local hum  = char and char:FindFirstChildOfClass("Humanoid")
            local sample = markerState.samples[tracked] or {}
            markerState.samples[tracked] = sample

            if root and hum and hum.Health > 0 and finiteVector(root.Position) then
                if isInsideAllowedArea(root.Position) then
                    local now = _tick()
                    if markerState.markerLocked then sample.history = {} end
                    sample.history = sample.history or {}
                    table.insert(sample.history, { time = now, safeCFrame = root.CFrame })
                    while sample.history[1]
                        and now - sample.history[1].time > (ELITE_LOOKBACK + 0.25) do
                        table.remove(sample.history, 1)
                    end
                    sample.safeCFrame = root.CFrame
                    if markerState.markerLocked then clearLastMarker() end
                else
                    local snap = snapshotBeforeExit(sample.history, _tick())
                    createOrUpdateMarker((snap and snap.safeCFrame) or sample.safeCFrame)
                end
            end

            if (hum and hum.Health <= 0) or (not root and not sample.safeCFrame) then
                markerState.markerTarget = nil
                clearLastMarker()
            else
                return
            end
        end

        local closest = pickClosestEnemy(myRoot)
        if closest then
            markerState.markerTarget = closest
            local r = closest.Character:FindFirstChild("HumanoidRootPart")
            if r then
                local sample = markerState.samples[closest] or {}
                markerState.samples[closest] = sample
                sample.safeCFrame = r.CFrame
                sample.history = { { time = _tick(), safeCFrame = r.CFrame } }
            end
        end
    end

    local monitorConn = RunService.Heartbeat:Connect(function(dt)
        markerState.accumulator = markerState.accumulator + (dt or 0)
        if markerState.accumulator < ELITE_SAMPLE_INTERVAL then return end
        markerState.accumulator = markerState.accumulator % ELITE_SAMPLE_INTERVAL
        pcall(monitorLastTarget)
    end)

    _G.EliteFamilyGetLastMarkerCFrame = getLastMarkerCFrame
    _G.EliteFamilyClearLastMarker     = clearLastMarker
    _G.EliteFamilyMarkerConn          = monitorConn

    LP.CharacterAdded:Connect(function()
        clearLastMarker()
        markerState.markerTarget = nil
        markerState.samples      = {}
    end)
end

local function batDesyncTpUpdate()
    if not batDesyncTpEnabled then
        stopBatDesyncTp()
        return
    end
    local char = LP.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    local target = getClosestPlayerDesync()
    if target and target.Character then
        local tr = target.Character:FindFirstChild("HumanoidRootPart")
        if tr then
            if sethiddenproperty then
                pcall(function()
                    sethiddenproperty(hrp, "PhysicsRepRootPart", tr)
                end)
            end

            local targetPos = tr.Position + _V3new(0, 0.9, 0)
            if (hrp.Position - targetPos).Magnitude > 8 then
                hrp.CFrame = _CFnew(targetPos)
            end

            local cam = workspace.CurrentCamera
            if cam then
                cam.CFrame = _CFnew(cam.CFrame.Position, tr.Position)
            end

            tryHitBatDesync()
        end
    end
end

function startBatDesyncTp()
    if batDesyncTpConn then return end
    if not unwalkEnabled then
        startUnwalk()
        unwalkEnabled = true
        _tpBatUnwalkForced = true
        if setUnwalkVisual then setUnwalkVisual(true) end
    end
    batDesyncTpEnabled = true
    batDesyncTpConn = RunService.Heartbeat:Connect(batDesyncTpUpdate)
    if batDesyncTpSetVisual then batDesyncTpSetVisual(true) end
    updateTpBatButtonWithAntiDie(true)
end

function stopBatDesyncTp()
    if batDesyncTpConn then
        batDesyncTpConn:Disconnect()
        batDesyncTpConn = nil
    end
    batDesyncTpEnabled = false
    if _tpBatUnwalkForced then
        stopUnwalk()
        unwalkEnabled = false
        _tpBatUnwalkForced = false
        if setUnwalkVisual then setUnwalkVisual(false) end
    end
    if batDesyncTpSetVisual then batDesyncTpSetVisual(false) end
    updateTpBatButtonWithAntiDie(false)
end

function toggleBatDesyncTp()
    if batDesyncTpEnabled then
        stopBatDesyncTp()
        updateTpBatButtonWithAntiDie(false)
    else
        disableAllAimbots()
        if autoLeftEnabled then
            autoLeftEnabled = false; stopAutoLeft()
            if autoLeftSetVisual then autoLeftSetVisual(false) end
            if mobSetAutoLeft then mobSetAutoLeft(false) end
        end
        if autoRightEnabled then
            autoRightEnabled = false; stopAutoRight()
            if autoRightSetVisual then autoRightSetVisual(false) end
            if mobSetAutoRight then mobSetAutoRight(false) end
        end
        startBatDesyncTp()
        updateTpBatButtonWithAntiDie(true)
    end
    if batDesyncTpSetVisual then batDesyncTpSetVisual(batDesyncTpEnabled) end
    saveAllSettings()
end

-- ============================================================
-- BAT V2 AIMBOT (from Clean / BloodHounds)
-- ============================================================
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
    if not hrp then return nil, _huge end
    local hpos = hrp.Position
    local closest, bestDist = nil, _huge
    local plist = _GetPlayersCached()
    for i = 1, #plist do
        local p = plist[i]
        if p ~= LP then
            local c = p.Character
            if c then
                local tr = c:FindFirstChild("HumanoidRootPart")
                local ph = c:FindFirstChildOfClass("Humanoid")
                if tr and ph and ph.Health > 0 then
                    local dx = hpos.X - tr.Position.X
                    local dy = hpos.Y - tr.Position.Y
                    local dz = hpos.Z - tr.Position.Z
                    local d = _sqrt(dx*dx + dy*dy + dz*dz)
                    if d < bestDist then bestDist = d; closest = p end
                end
            end
        end
    end
    return closest, bestDist
end

local function tryHitBatV2()
    if autoBatV2HitCooldown or not autoBatV2SwingEnabled then return end
    autoBatV2HitCooldown = true
    local char = LP.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        local tool = findAnyToolV2()
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
                local offset = moveDir * AUTO_BAT_V2_DIST + _V3new(0, AUTO_BAT_V2_HEIGHT + AUTO_BAT_V2_V_OFF, 0)
                local desiredPos = targetRoot.Position + offset
                local toTarget = desiredPos - root.Position
                if toTarget.Magnitude > 0.5 then
                    local moveVec = toTarget.Unit * AUTO_BAT_V2_SPEED
                    root.AssemblyLinearVelocity = _V3new(moveVec.X, moveVec.Y, moveVec.Z)
                else
                    root.AssemblyLinearVelocity = root.AssemblyLinearVelocity * 0.95
                    if root.AssemblyLinearVelocity.Magnitude < 1 then
                        root.AssemblyLinearVelocity = _V3zero
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
                root.AssemblyLinearVelocity = _V3zero
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
        root.AssemblyLinearVelocity = _V3zero
    end
    autoBatV2HitCooldown = false
end

function enableBatV2()
    if autoBatV2Enabled then return end
    if autoBatEnabled then disableAutoBat() end
    if batDesyncTpEnabled then toggleBatDesyncTp() end
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
        if btnFrame then paintFloatingBtn(btnFrame, true) end
    end
end

function disableBatV2()
    if not autoBatV2Enabled then return end
    autoBatV2Enabled = false
    stopBatV2Aimbot()
    if autoBatV2SetVisual then autoBatV2SetVisual(false) end
    if batV2FloatingButton then
        local btnFrame = batV2FloatingButton:FindFirstChild("Frame")
        if btnFrame then paintFloatingBtn(btnFrame, false) end
    end
end

function toggleBatV2()
    if autoBatV2Enabled then disableBatV2()
    else enableBatV2() end
end

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

batCounterDebounce = false

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
                if bat then swingBatForCounter(bat, character) end
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
            if n:find("medusa") or n:find("head") or n:find("stone") then return t end
        end
    end
    local bp = LP:FindFirstChild("Backpack")
    if bp then
        for _, t in ipairs(bp:GetChildren()) do
            if t:IsA("Tool") then
                local n = t.Name:lower()
                if n:find("medusa") or n:find("head") or n:find("stone") then return t end
            end
        end
    end
    return nil
end

function useMedusaCounter()
    if medusaDebounce then return end
    if _tick() - medusaLastUsed < MEDUSA_COOLDOWN then return end
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
    medusaLastUsed = _tick()
    medusaDebounce = false
end

function onAnchorChanged(part)
    return part:GetPropertyChangedSignal("Anchored"):Connect(function()
        if medusaCounterEnabled and part.Anchored and part.Transparency == 1 then useMedusaCounter() end
    end)
end

function setupMedusaCounter(char)
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

local DROP_ASCEND_DURATION = 0.2
local DROP_ASCEND_SPEED = 150
local _dropConn = nil

function stopDropBrainrot()
    dropActive = false
    if _dropConn then
        _dropConn:Disconnect()
        _dropConn = nil
    end
    for _, t in ipairs(dropConnections) do
        if type(t) == "thread" then pcall(task.cancel, t)
        elseif type(t) == "RBXScriptConnection" then pcall(t.Disconnect, t) end
    end
    dropConnections = {}
    local c = LP.Character
    if c then
        local root = c:FindFirstChild("HumanoidRootPart")
        if root then root.AssemblyLinearVelocity = _V3zero end
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
            speedH = _V3new(vel.X, 0, vel.Z).Magnitude
        end
        local cooldown = (speedH > 5) and 0.6 or 0.25
        if _tick() - lastDropTime < cooldown then return end
        lastDropTime = _tick()
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
                    r.AssemblyLinearVelocity = _V3zero
                    r.AssemblyAngularVelocity = _V3zero
                    if r.Position.Y < -100 then
                        r.CFrame = _CFnew(r.Position.X, 5, r.Position.Z)
                    end
                    local rp = RaycastParams.new()
                    rp.FilterDescendantsInstances = {c}
                    rp.FilterType = Enum.RaycastFilterType.Exclude
                    local rr = workspace:Raycast(r.Position, _V3new(0, -2000, 0), rp)
                    if rr then
                        local off = (h and h.HipHeight or 2) + (r.Size.Y / 2)
                        r.CFrame = _CFnew(r.Position.X, rr.Position.Y + off, r.Position.Z)
                    end
                    if h and h.Health > 0 then h:ChangeState(Enum.HumanoidStateType.Running) end
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
            local startTime = _tick()
            while dropActive and (_tick() - startTime) < 0.25 do
                RunService.Heartbeat:Wait()
                local c = LP.Character
                local r = c and c:FindFirstChild("HumanoidRootPart")
                if not r then break end
                local vel = r.AssemblyLinearVelocity
                vel = _V3new(0, vel.Y, 0)
                r.AssemblyLinearVelocity = vel * 10000 + _V3new(0, 10000, 0)
                RunService.RenderStepped:Wait()
                if r and r.Parent then r.AssemblyLinearVelocity = vel end
                RunService.Stepped:Wait()
                if r and r.Parent then r.AssemblyLinearVelocity = vel + _V3new(0, 0.1, 0) end
            end
            finishDrop(flingThread)
        end)
        table.insert(dropConnections, flingThread)
        task.delay(0.35, function()
            if dropActive then finishDrop(flingThread) end
        end)
        return
    end

    if autoBatEnabled then
        autoBatEnabled = false
        if autoBatSetVisual then autoBatSetVisual(false) end
        if mobSetAutoBat then mobSetAutoBat(false) end
        if stopAimbotAdapt then stopAimbotAdapt() end
    end
    dropActive = true
    if dropBrainrotSetVisual then dropBrainrotSetVisual(true) end
    if mobSetDropBR then mobSetDropBR(false) end
    local t0 = _tick()
    if _dropConn then _dropConn:Disconnect() end
    _dropConn = RunService.Heartbeat:Connect(function()
        local r = char and char:FindFirstChild("HumanoidRootPart")
        if not r then
            if _dropConn then _dropConn:Disconnect(); _dropConn = nil end
            dropActive = false
            if dropBrainrotSetVisual then dropBrainrotSetVisual(false) end
            if mobSetDropBR then mobSetDropBR(false) end
            return
        end
        if _tick() - t0 >= DROP_ASCEND_DURATION then
            if _dropConn then _dropConn:Disconnect(); _dropConn = nil end
            local rp = _RayParams_new()
            rp.FilterDescendantsInstances = {char}
            rp.FilterType = Enum.RaycastFilterType.Exclude
            local rr = workspace:Raycast(r.Position, _V3new(0, -2000, 0), rp)
            if rr then
                local hum2 = char:FindFirstChildOfClass("Humanoid")
                local off = ((hum2 and hum2.HipHeight) or 2) + (r.Size.Y / 2)
                r.CFrame = _CFnew(r.Position.X, rr.Position.Y + off, r.Position.Z)
                r.AssemblyLinearVelocity = _V3zero
            end
            dropActive = false
            if dropBrainrotSetVisual then dropBrainrotSetVisual(false) end
            if mobSetDropBR then mobSetDropBR(false) end
            return
        end
        r.Velocity = _V3new(r.Velocity.X, DROP_ASCEND_SPEED, r.Velocity.Z)
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

-- =====================================================================
-- ANTI LAG ULTRA
-- =====================================================================
local _alSaved = setmetatable({}, { __mode = "k" })
local _alDetached = {}
local _alAnimators = setmetatable({}, { __mode = "k" })
local _alStoppedTracks = setmetatable({}, { __mode = "k" })
local _alGeneration = 0
local _alScanCancel = nil
local _alConns = {}
local _alLightOrig = nil
local _alRunning = false

local AL_LOW_FLAGS = {
    {"DFIntClusterSenderMaxJoinBandwidthBps", "2100000000"},
    {"DFIntClusterSenderMaxUpdateBandwidthBps", "2100000000"},
    {"DFIntServerFramesBetweenJoins", "1"},
    {"DFIntRaknetBandwidthInfluxHundredthsPercentageV2", "10000"},
    {"DFIntConnectionMTUSize", "1400"},
    {"FIntRakNetResendBufferArrayLength", "1024"},
    {"DFIntRakNetNakResendDelayMsMax", "1"},
    {"DFIntWaitOnUpdateNetworkLoopEndedMS", "100"},
    {"DFIntWaitOnRecvFromLoopEndedMS", "100"},
    {"DFIntLargePacketQueueSizeCutoffMB", "1000"},
    {"DFIntSendRakNetStatsInterval", "2147483647"},
    {"DFIntRakNetLoopMs", "1"},
    {"DFIntRakNetSelectTimeoutMs", "1"},
    {"DFIntNetworkClusterPacketCacheNumParallelTasks", "8"},
    {"DFIntReplicationDataCacheNumParallelTasks", "8"},
    {"DFIntMegaReplicatorNumParallelTasks", "16"},
    {"DFIntMaxProcessPacketsStepsPerCyclic", "512"},
    {"DFIntMaxProcessPacketsStepsAccumulated", "0"},
    {"DFIntMaxProcessPacketsJobScaling", "1000"},
    {"DFIntClientPacketMaxFrameMicroseconds", "200000"},
    {"DFIntClientPacketExcessMicroseconds", "10000"},
    {"DFIntClientPacketMinMicroseconds", "1"},
    {"DFIntClientPacketMaxDelayMs", "1"},
    {"DFIntMaxWaitTimeBeforeForcePacketProcessMS", "1"},
    {"DFIntMaxFrameBufferSize", "4"},
    {"DFIntBufferCompressionThreshold", "100"},
    {"DFIntOverrideISRReplicatorStepBandwidthBytes", "131072"},
    {"DFIntTaskSchedulerJobInitThreads", "8"},
    {"DFIntTaskSchedulerJobInGameThreads", "8"},
    {"FIntTaskSchedulerAutoThreadLimit", "16"},
    {"FIntTaskSchedulerAsyncTasksMinimumThreadCount", "4"},
    {"DFIntRuntimeConcurrency", "16"},
    {"FIntSimWorldTaskQueueParallelTasks", "20"},
    {"DFIntHttpBatchLimit", "256"},
    {"FIntHttpBatchLimit", "256"},
    {"DFIntHttpCurlConnectionCacheSize", "512"},
    {"FIntDefaultMeshCacheSizeMB", "512"},
    {"DFIntMemCacheMaxCapacityMB", "256"},
    {"DFIntNumAssetsMaxToPreload", "1"},
    {"DFFlagEnableSoundPreloading", "false"},
    {"FFlagSlimContentProvider", "true"},
    {"DFFlagDebugSkipMeshVoxelizer", "true"},
    {"DFFlagTextureQualityOverrideEnabled", "true"},
    {"DFIntTextureQualityOverride", "0"},
    {"FIntDebugTextureManagerSkipMips", "7"},
    {"DFIntDebugLimitMinTextureResolutionWhenSkipMips", "8"},
    {"FFlagTM2SkipMipsForUnstreamable2", "true"},
    {"DFFlagDoNotSkipMipsBasedOnSystemMemoryPS", "true"},
    {"FFlagRenderUseTextureManager224", "false"},
    {"DFIntDebugFRMQualityLevelOverride", "1"},
    {"DFFlagDebugPauseVoxelizer", "true"},
    {"FFlagFastGPULightCulling3", "true"},
    {"FIntRenderLocalLightFadeInMs", "0"},
    {"FIntRenderLocalLightUpdatesMax", "1"},
    {"FIntRenderShadowmapBias", "0"},
    {"FIntSSAOMipLevels", "0"},
    {"FIntDebugForceMSAASamples", "1"},
    {"FIntDebugFRMOptionalMSAALevelOverride", "0"},
    {"FIntRobloxGuiBlurIntensity", "0"},
    {"FIntFRMMinGrassDistance", "0"},
    {"FIntFRMMaxGrassDistance", "0"},
    {"DFFlagCoreScriptTelemetry2", "false"},
    {"DFFlagBrowserTrackerIdTelemetryEnabled", "false"},
    {"FFlagPerfDataOnTelemetryV2", "false"},
    {"FFlagSendRenderFidelityTelemetry2", "false"},
    {"FFlagEnableTelemetryServiceMemoryCPUInfo", "false"},
    {"DFIntTelemetryProfilerHundredthsPercentage", "0"},
    {"FIntTelemetryProfilerFrequency", "0"},
    {"FIntPerformanceTelemetryQueueProcessLimit", "0"},
    {"DFIntContentProviderPreloadHangTelemetryHundredthsPercentage", "0"},
}

local function _alApplyLowFlags()
    local env = (getgenv and getgenv()) or _G
    local setter = rawget(env, "setfflag") or rawget(_G, "set_fflag")
    local getter = rawget(env, "getfflag") or rawget(_G, "get_fflag")
    if type(setter) ~= "function" then return end
    for _, flag in ipairs(AL_LOW_FLAGS) do
        local canSet = true
        if type(getter) == "function" then
            local ok, current = pcall(getter, flag[1])
            canSet = ok and current ~= nil
        end
        if canSet then pcall(setter, flag[1], tostring(flag[2])) end
    end
end

local function _alSaveLighting()
    if _alLightOrig then return end
    _alLightOrig = {
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

local function _alApplyLowPermanentSettings()
    pcall(function() settings().Rendering.QualityLevel = Enum.QualityLevel.Level01 end)
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
            if clouds then clouds.Enabled = false end
        end
    end)
end

local function _alChange(object, property, value)
    pcall(function()
        local original = object[property]
        if original == value then return end
        object[property] = value
        local bucket = _alSaved[object]
        if not bucket then bucket = {}; _alSaved[object] = bucket end
        if not bucket[property] then bucket[property] = { value = original } end
    end)
end

local function _alIsProtectedVisual(object)
    local char = LP.Character
    if char and (object == char or object:IsDescendantOf(char)) then return true end
    local parent = object
    while parent and parent ~= workspace do
        if parent:IsA("LayerCollector") or parent:IsA("GuiObject") or parent:IsA("GuiBase2d") then
            return true
        end
        local name = parent.Name or ""
        if name:match("^Crystal") or name:match("^Eclipse") or name:match("^ESP_")
            or name:match("^BloodHounds") or name:match("^EliteFamily") then
            return true
        end
        parent = parent.Parent
    end
    return false
end

function applyAntiLagDerender(obj)
    pcall(function()
        if not _alRunning then return end
        if _alIsProtectedVisual(obj) then return end

        if obj:IsA("Terrain") then
            _alChange(obj, "Decoration", false)
            _alChange(obj, "WaterWaveSize", 0)
            _alChange(obj, "WaterWaveSpeed", 0)
            _alChange(obj, "WaterReflectance", 0)
            _alChange(obj, "WaterTransparency", 1)
        end
        if obj:IsA("BasePart") then
            _alChange(obj, "Material", Enum.Material.Plastic)
            _alChange(obj, "MaterialVariant", "")
            _alChange(obj, "Reflectance", 0)
            _alChange(obj, "CastShadow", false)
            if obj:IsA("MeshPart") then
                _alChange(obj, "TextureID", "")
                _alChange(obj, "RenderFidelity", Enum.RenderFidelity.Performance)
                _alChange(obj, "DoubleSided", false)
            elseif obj:IsA("PartOperation") then
                _alChange(obj, "RenderFidelity", Enum.RenderFidelity.Performance)
            end
        elseif obj:IsA("SpecialMesh") then
            _alChange(obj, "TextureId", "")
        elseif obj:IsA("SurfaceAppearance") then
            _alDetached[obj] = true
            _alChange(obj, "Parent", nil)
        elseif obj:IsA("Decal") or obj:IsA("Texture") then
            _alChange(obj, "Transparency", 1)
            _alChange(obj, "Texture", "")
        elseif obj:IsA("ParticleEmitter") then
            _alChange(obj, "Enabled", false)
            _alChange(obj, "Rate", 0)
            pcall(function() obj:Clear() end)
        elseif obj:IsA("Trail") then
            _alChange(obj, "Enabled", false)
            pcall(function() obj:Clear() end)
        elseif obj:IsA("Beam") or obj:IsA("Fire") or obj:IsA("Smoke")
            or obj:IsA("Sparkles") or obj:IsA("Light") or obj:IsA("PostEffect")
            or obj:IsA("Clouds") then
            _alChange(obj, "Enabled", false)
        elseif obj:IsA("Atmosphere") then
            _alChange(obj, "Density", 0)
            _alChange(obj, "Haze", 0)
            _alChange(obj, "Glare", 0)
        elseif obj:IsA("Sky") then
            for _, face in ipairs({"SkyboxBk","SkyboxDn","SkyboxFt","SkyboxLf","SkyboxRt","SkyboxUp","SunTextureId","MoonTextureId"}) do
                _alChange(obj, face, "")
            end
            _alChange(obj, "StarCount", 0)
            _alChange(obj, "CelestialBodiesShown", false)
        elseif obj:IsA("Shirt") then
            _alChange(obj, "ShirtTemplate", "")
        elseif obj:IsA("Pants") then
            _alChange(obj, "PantsTemplate", "")
        elseif obj:IsA("ShirtGraphic") then
            _alChange(obj, "Graphic", "")
        elseif obj:IsA("Animator") then
            if not _alAnimators[obj] then
                local char = LP.Character
                if not (char and obj:IsDescendantOf(char)) then
                    _alAnimators[obj] = true
                    local token = _alGeneration
                    local ok, conn = pcall(function()
                        return obj.AnimationPlayed:Connect(function(track)
                            if not _alRunning or _alGeneration ~= token then return end
                            task.defer(function()
                                if _alRunning and _alGeneration == token then
                                    pcall(function() track:Stop(0) end)
                                end
                            end)
                        end)
                    end)
                    if ok then table.insert(_alConns, conn) end
                    pcall(function()
                        for _, track in ipairs(obj:GetPlayingAnimationTracks()) do
                            if track.IsPlaying then
                                _alStoppedTracks[track] = {
                                    animator = obj,
                                    time = track.TimePosition,
                                    speed = track.Speed,
                                }
                                track:Stop(0)
                            end
                        end
                    end)
                end
            end
        end
    end)
end

function enableAntiLag()
    if _alRunning then return end
    _alRunning = true
    antiLagEnabled = true
    _alGeneration = _alGeneration + 1
    local token = _alGeneration

    _alSaveLighting()
    _alApplyLowFlags()
    _alApplyLowPermanentSettings()

    for _, delaySeconds in ipairs({2, 6, 12, 20}) do
        task.delay(delaySeconds, function()
            if _alRunning and _alGeneration == token then
                _alApplyLowFlags()
            end
        end)
    end

    pcall(function() game:GetService("ReplicatedFirst"):RemoveDefaultLoadingScreen() end)

    table.insert(_alConns, workspace.DescendantAdded:Connect(function(obj)
        task.defer(function()
            if _alRunning and _alGeneration == token then
                pcall(applyAntiLagDerender, obj)
            end
        end)
    end))
    table.insert(_alConns, Lighting.DescendantAdded:Connect(function(obj)
        task.defer(function()
            if _alRunning and _alGeneration == token then
                pcall(applyAntiLagDerender, obj)
            end
        end)
    end))

    local function walkBatched(roots, apply, shouldContinue)
        task.spawn(function()
            local pending = {}
            for _, root in ipairs(roots) do
                if root then
                    local ok, children = pcall(function() return root:GetChildren() end)
                    if ok then for _, c in ipairs(children) do table.insert(pending, c) end end
                end
            end
            while #pending > 0 and _alRunning and _alGeneration == token and shouldContinue() do
                local deadline = os.clock() + 0.0008
                while #pending > 0 and os.clock() < deadline do
                    local obj = table.remove(pending)
                    pcall(apply, obj)
                    local ok, children = pcall(function() return obj:GetChildren() end)
                    if ok then for _, c in ipairs(children) do table.insert(pending, c) end end
                end
                RunService.Heartbeat:Wait()
            end
        end)
    end

    walkBatched({workspace, Lighting}, applyAntiLagDerender, function()
        return _alRunning and _alGeneration == token
    end)
end

function disableAntiLag()
    if not _alRunning then
        antiLagEnabled = false
        return
    end
    _alRunning = false
    antiLagEnabled = false
    _alGeneration = _alGeneration + 1

    if _alScanCancel then pcall(_alScanCancel); _alScanCancel = nil end

    for _, conn in ipairs(_alConns) do pcall(function() conn:Disconnect() end) end
    _alConns = {}

    for object, properties in pairs(_alSaved) do
        for property, original in pairs(properties) do
            pcall(function() object[property] = original.value end)
        end
    end
    _alSaved = setmetatable({}, { __mode = "k" })
    _alDetached = {}
    _alAnimators = setmetatable({}, { __mode = "k" })

    for track, state in pairs(_alStoppedTracks) do
        pcall(function()
            if state.animator.Parent and not track.IsPlaying then
                track:Play(0, 1, state.speed)
                track.TimePosition = state.time
            end
        end)
    end
    _alStoppedTracks = setmetatable({}, { __mode = "k" })

    if _alLightOrig then
        pcall(function()
            Lighting.Brightness = _alLightOrig.Brightness
            Lighting.ClockTime = _alLightOrig.ClockTime
            Lighting.OutdoorAmbient = _alLightOrig.OutdoorAmbient
            Lighting.Ambient = _alLightOrig.Ambient
            Lighting.GlobalShadows = _alLightOrig.GlobalShadows
            Lighting.EnvironmentDiffuseScale = _alLightOrig.EnvironmentDiffuseScale
            Lighting.EnvironmentSpecularScale = _alLightOrig.EnvironmentSpecularScale
            Lighting.FogStart = _alLightOrig.FogStart
            Lighting.FogEnd = _alLightOrig.FogEnd
        end)
    end
end


-- ============================================================
-- CUSTOM SOUNDS (from Nike Duels / Ambitious)
-- Bat -> katana slash   |   Medusa -> gunshot
-- Mutes original tool sounds and plays custom ones.
-- ============================================================
do
    local SOUNDS = {
        Bat    = { id = "rbxassetid://5713085119", skip = 0.2 },
        Medusa = { id = "rbxassetid://3102797479", doublePlay = true, delay = 0.5 },
    }

    local CT_ITEMS = {
        { key = "Bat",    match = function(n) n = n:lower(); return n:find("bat") ~= nil or n:find("slap") ~= nil end },
        { key = "Medusa", match = function(n) return n:lower():find("medusa") ~= nil end },
    }

    local function matchItem(inst)
        if not (inst:IsA("Tool") or inst:IsA("Model") or inst:IsA("Accessory") or inst:IsA("BasePart")) then
            return nil
        end
        for _, item in ipairs(CT_ITEMS) do
            if item.match(inst.Name) then return item end
        end
        return nil
    end

    local hooked = setmetatable({}, { __mode = "k" })
    local enabled = false
    local tracked = setmetatable({}, { __mode = "k" })
    local watchers = setmetatable({}, { __mode = "k" })
    local pendingHandle = setmetatable({}, { __mode = "k" })
    local teardown

    local function playCustom(entry)
        local cs = entry.sound
        if not cs or not cs.Parent then return end
        local d = entry.data
        if entry.timer then
            pcall(task.cancel, entry.timer)
            entry.timer = nil
        end
        pcall(function()
            cs:Stop()
            cs.TimePosition = d.skip or 0
            cs.Volume = 1
            cs:Play()
        end)
        if d.doublePlay and d.delay then
            entry.timer = task.delay(d.delay, function()
                entry.timer = nil
                if not enabled then return end
                if cs and cs.Parent then
                    pcall(function()
                        cs:Stop()
                        cs.TimePosition = d.skip or 0
                        cs.Volume = 1
                        cs:Play()
                    end)
                end
            end)
        end
    end

    local function hookSound(entry, snd)
        if not snd:IsA("Sound") then return end
        if snd.Name == "CustomSound" then return end
        if hooked[snd] then return end
        if entry.muted[snd] ~= nil then return end

        entry.muted[snd] = snd.Volume
        hooked[snd] = true

        local function trigger()
            if not enabled then return end
            if snd.Playing or snd.TimePosition > 0 then
                pcall(function()
                    snd.Volume = 0
                    snd:Stop()
                end)
                playCustom(entry)
            end
        end

        local c1 = snd:GetPropertyChangedSignal("Playing"):Connect(trigger)
        local c2 = snd:GetPropertyChangedSignal("TimePosition"):Connect(trigger)
        table.insert(entry.conns, c1)
        table.insert(entry.conns, c2)

        local c3
        c3 = snd.AncestryChanged:Connect(function(_, parent)
            if parent then return end
            pcall(function() c1:Disconnect() end)
            pcall(function() c2:Disconnect() end)
            pcall(function() c3:Disconnect() end)
            hooked[snd] = nil
            entry.muted[snd] = nil
            if entry.timer then
                pcall(task.cancel, entry.timer)
                entry.timer = nil
            end
        end)
        table.insert(entry.conns, c3)

        if snd.Playing then trigger() end
    end

    local function setupTool(tool)
        if tracked[tool] then return end
        local item = matchItem(tool)
        if not item then return end
        local data = SOUNDS[item.key]
        if not data then return end

        local handle = tool:FindFirstChild("Handle")
        if not handle then
            if pendingHandle[tool] then return end
            local c
            c = tool.ChildAdded:Connect(function(child)
                if child.Name == "Handle" then
                    pcall(function() c:Disconnect() end)
                    pendingHandle[tool] = nil
                    if enabled then setupTool(tool) end
                end
            end)
            pendingHandle[tool] = c
            return
        end

        local old = handle:FindFirstChild("CustomSound")
        if old then pcall(function() old:Destroy() end) end

        local cs = Instance.new("Sound")
        cs.Name = "CustomSound"
        cs.SoundId = data.id
        cs.Volume = 1
        cs.Looped = false
        cs.RollOffMode = Enum.RollOffMode.Inverse
        cs.MaxDistance = 1000
        cs.MinDistance = 1000
        cs.Parent = handle

        local entry = { sound = cs, data = data, conns = {}, muted = {} }
        tracked[tool] = entry

        for _, d in ipairs(tool:GetDescendants()) do hookSound(entry, d) end

        table.insert(entry.conns, tool.DescendantAdded:Connect(function(d)
            if tracked[tool] then hookSound(entry, d) end
        end))
        table.insert(entry.conns, tool.AncestryChanged:Connect(function(_, parent)
            if not parent then teardown(tool) end
        end))
    end

    function teardown(tool)
        local entry = tracked[tool]
        if not entry then return end
        if entry.timer then
            pcall(task.cancel, entry.timer)
            entry.timer = nil
        end
        for _, conn in ipairs(entry.conns) do pcall(function() conn:Disconnect() end) end
        if entry.sound then pcall(function() entry.sound:Destroy() end) end
        for snd, vol in pairs(entry.muted) do
            hooked[snd] = nil
            if snd and snd.Parent then pcall(function() snd.Volume = vol end) end
        end
        tracked[tool] = nil
    end

    local function tryRegister(inst)
        if not enabled then return end
        if inst:IsA("Tool") and matchItem(inst) then setupTool(inst) end
    end

    local function unwatch(container)
        local conns = watchers[container]
        if not conns then return end
        for _, c in ipairs(conns) do pcall(function() c:Disconnect() end) end
        watchers[container] = nil
    end

    local function watch(container)
        if not container or watchers[container] then return end
        watchers[container] = { container.ChildAdded:Connect(tryRegister) }
        for _, child in ipairs(container:GetChildren()) do tryRegister(child) end
    end

    local function watchAll()
        if not LP then return end
        watch(LP:FindFirstChildOfClass("Backpack"))
        watch(LP.Character)
    end

    if LP then
        LP.ChildAdded:Connect(function(child)
            if enabled and child:IsA("Backpack") then watch(child) end
        end)
        LP.CharacterAdded:Connect(function(char)
            for tool in pairs(tracked) do teardown(tool) end
            for _, c in pairs(pendingHandle) do pcall(function() c:Disconnect() end) end
            table.clear(pendingHandle)
            for container in pairs(watchers) do unwatch(container) end
            if not enabled then return end
            watch(char)
            task.defer(function()
                if enabled then watchAll() end
            end)
        end)
    end

    task.spawn(function()
        while true do
            task.wait(2)
            if not enabled then continue end
            for tool in pairs(tracked) do
                if not tool.Parent then teardown(tool) end
            end
            for tool, c in pairs(pendingHandle) do
                if not tool.Parent then
                    pcall(function() c:Disconnect() end)
                    pendingHandle[tool] = nil
                end
            end
            for container in pairs(watchers) do
                if not container.Parent then unwatch(container) end
            end
        end
    end)

    _G.EliteFamilyCustomSounds = {
        setEnabled = function(on)
            on = on and true or false
            enabled = on
            customSoundsEnabled = on
            if on then
                watchAll()
            else
                for tool in pairs(tracked) do teardown(tool) end
                for _, c in pairs(pendingHandle) do pcall(function() c:Disconnect() end) end
                table.clear(pendingHandle)
                for container in pairs(watchers) do unwatch(container) end
            end
        end,
        isEnabled = function() return enabled end,
    }
end



-- ============================================================
-- MUSIC PLAYER (songs from Nike Duels / Ambitious Hub)
-- ============================================================
do
    local SoundService = game:GetService("SoundService")
    local TweenService = game:GetService("TweenService")

    ELITE_MUSIC_OPTIONS = {

  -- === 404 Family playlist (Musica + Sound) ===
  {name="Traigo mi Cuerno el lirikario", url="https://files.catbox.moe/9encfb.mp3", file="404_cuerno_lirikario.mp3", volume=0.85},
  {name="El chiricuazo v3", url="https://files.catbox.moe/jxie7x.mp3", file="404_chiricuazo_v3.mp3", volume=0.85},
  {name="El de la R", url="https://files.catbox.moe/z71nw9.mp3", file="404_el_de_la_r.mp3", volume=0.85},
  {name="La maña music", url="https://files.catbox.moe/7qa0i4.mp3", file="404_la_mana.mp3", volume=0.85},
  {name="Aqui seguimos", url="https://files.catbox.moe/ih03mg.mp3", file="404_aqui_seguimos.mp3", volume=0.85},
  {name="El trueno", url="https://files.catbox.moe/1erzv2.mp3", file="404_el_trueno.mp3", volume=0.85},
  {name="Mujer de piedra", url="https://files.catbox.moe/9yjej5.mp3", file="404_mujer_piedra.mp3", volume=0.85},
  {name="Jefe mencho", url="https://files.catbox.moe/fe9yxr.mp3", file="404_jefe_mencho.mp3", volume=0.85},
  {name="El contra tijerina v2", url="https://files.catbox.moe/05y33r.mp3", file="404_contra_tijerina.mp3", volume=0.85},
  {name="Doma", url="https://files.catbox.moe/mkwawe.mp3", file="404_doma.mp3", volume=0.85},
  {name="Lo que hay x aqui", url="https://files.catbox.moe/66nnop.mp3", file="404_lo_que_hay.mp3", volume=0.85},
  {name="Ebrio de Amor", url="https://files.catbox.moe/8leyi2.mp3", file="404_ebrio_amor.mp3", volume=0.85},
  {name="Mi radio y Mi cuerno", url="https://files.catbox.moe/vpvrt5.mp3", file="404_mi_radio.mp3", volume=0.85},
  {name="Furia blanca", url="https://files.catbox.moe/s5nxvp.mp3", file="404_furia_blanca.mp3", volume=0.85},
  {name="Belanova", url="https://files.catbox.moe/a9plsn.mp3", file="404_belanova.mp3", volume=0.85},
  {name="Culpable tu", url="https://files.catbox.moe/2o7npd.mp3", file="404_culpable_tu.mp3", volume=0.85},
  {name="Cumbia la Ksquiza", url="https://files.catbox.moe/fulmex.mp3", file="404_cumbia_ksquiza.mp3", volume=0.85},
  {name="La diestra", url="https://files.catbox.moe/zr98e5.mp3", file="404_la_diestra.mp3", volume=0.85},
  {name="Borro Cassette", url="https://files.catbox.moe/nabpiz.mp3", file="404_borro_cassette.mp3", volume=0.85},
  {name="Cuando no era cantante", url="https://files.catbox.moe/go56j6.mp3", file="404_cuando_no_era.mp3", volume=0.85},
  {name="Noches Frías", url="https://files.catbox.moe/hvsrir.mp3", file="404_noches_frias.mp3", volume=0.85},
  {name="La plena", url="https://files.catbox.moe/fv1c91.mp3", file="404_la_plena.mp3", volume=0.85},
  {name="Bipolar (peso pluma)", url="https://files.catbox.moe/wplf2q.mp3", file="404_bipolar.mp3", volume=0.85},
  {name="Webazon", url="https://files.catbox.moe/jit8ei.mp3", file="404_webazon.mp3", volume=0.85},
  {name="Di que si", url="https://files.catbox.moe/y3yr75.mp3", file="404_di_que_si.mp3", volume=0.85},
  {name="Me la avente", url="https://files.catbox.moe/z5oxpg.mp3", file="404_me_la_avente.mp3", volume=0.85},
  {name="Antonio aguilar - hijo desobediente", url="https://files.catbox.moe/dpwv18.mp3", file="404_hijo_desobediente.mp3", volume=0.85},
  {name="Mi Pasado Y Mi Presente", url="https://files.catbox.moe/9bbmoa.mp3", file="404_mi_pasado.mp3", volume=0.85},
  {name="Bad bonny callaita", url="https://files.catbox.moe/q17vjg.mp3", file="404_callaita.mp3", volume=0.85},
  {name="inspírate vol 7", url="https://files.catbox.moe/hmuaty.mp3", file="404_inspirate_vol7.mp3", volume=0.85},
  {name="Ni por favor (lefty sm)", url="https://files.catbox.moe/e27idr.mp3", file="404_ni_por_favor.mp3", volume=0.85},
  {name="Ondeado v2", url="https://files.catbox.moe/7b79ys.mp3", file="404_ondeado_v2.mp3", volume=0.85},
  {name="Quien te entiende", url="https://files.catbox.moe/ybf5u6.mp3", file="404_quien_te_entiende.mp3", volume=0.85},
  {name="Con tus besos - Eslabon Armando", url="https://files.catbox.moe/2evdys.mp3", file="404_con_tus_besos.mp3", volume=0.85},
  {name="Aura Isxwn", url="https://files.catbox.moe/n2po3t.mp3", file="404_aura_isxwn.mp3", volume=0.85},
  {name="Let it show", url="https://files.catbox.moe/an2x44.mp3", file="404_let_it_show.mp3", volume=0.85},
  {name="Still Think About You", url="https://files.catbox.moe/n6lxff.mp3", file="404_still_think.mp3", volume=0.85},
  {name="Alok Alan walker", url="https://files.catbox.moe/5e9jqa.mp3", file="404_alok_alan.mp3", volume=0.85},
  -- === Original Elite / Ambitious / Ninja ===
  {name="Gelato", url="https://files.catbox.moe/sospih.mp3", file="AmbitiousHubMusic1.mp3"},
  {name="Meant To Be", url="https://files.catbox.moe/smt6l8.mp3", file="AmbitiousHubMusic2.mp3"},
  {name="Beccaria San Vittore RMX", url="https://files.catbox.moe/2r8auq.mp3", file="AmbitiousHubMusic3.mp3"},
  {name="The Box", url="https://files.catbox.moe/yumqjl.mp3", file="AmbitiousHubMusic4.mp3"},
  {name="Mu Ammar Gheddafi RMX", url="https://files.catbox.moe/qcuden.mp3", file="AmbitiousHubMusic5.mp3"},
  {name="Marocchino RMX", url="https://files.catbox.moe/iyav31.mp3", file="AmbitiousHubMusic6.mp3"},
  {name="Gotham Mashup", url="https://files.catbox.moe/7eof36.mp3", file="AmbitiousHubMusic7.mp3"},
  {name="Goosebumps", url="https://files.catbox.moe/6wqcck.mp3", file="AmbitiousHubMusic8.mp3"},
  {name="Houdini", url="https://files.catbox.moe/gsuxur.mp3", file="AmbitiousHubMusic9.mp3"},
  {name="Magnolia", url="https://files.catbox.moe/ursllw.mp3", file="AmbitiousHubMusic10.mp3"},
  {name="Redemption RMX", url="https://files.catbox.moe/kjxkv7.mp3", file="AmbitiousHubMusic11.mp3"},
  {name="Evicted RMX", url="https://files.catbox.moe/s28bh5.mp3", file="AmbitiousHubMusic12.mp3"},
  {name="Lyfe RMX", url="https://files.catbox.moe/8hciqx.mp3", file="AmbitiousHubMusic13.mp3"},
  {name="No Refunds RMX", url="https://files.catbox.moe/uz9hot.mp3", file="AmbitiousHubMusic14.mp3"},
  {name="8 AM In Manny RMX", url="https://files.catbox.moe/xh4t0r.mp3", file="AmbitiousHubMusic15.mp3"},
  {name="Us Vs Them RMX", url="https://files.catbox.moe/po5fbj.mp3", file="AmbitiousHubMusic16.mp3"},
  {name="Reflection 2 RMX", url="https://files.catbox.moe/kcst57.mp3", file="AmbitiousHubMusic17.mp3"},
  {name="I Know You Care RMX", url="https://files.catbox.moe/c2en1v.mp3", file="AmbitiousHubMusic18.mp3"},
  {name="Bubblegum RMX", url="https://files.catbox.moe/8xf15k.mp3", file="AmbitiousHubMusic19.mp3"},
  {name="Cream RMX", url="https://files.catbox.moe/yfhgqz.mp3", file="AmbitiousHubMusic20.mp3"},
  {name="Panzerknacker.wav", url="https://files.catbox.moe/izcvhm.mp3", file="AmbitiousHubMusic21.mp3"},
  {name="Freaked Out", url="https://files.catbox.moe/dyt2ja.mp3", file="AmbitiousHubMusic22.mp3"},
  {name="Scam Likely", url="https://files.catbox.moe/pr85mz.mp3", file="AmbitiousHubMusic23.mp3"},
  {name="Pure Cocaine", url="https://files.catbox.moe/dvjtjk.mp3", file="AmbitiousHubMusic24.mp3"},
  {name="Tesla", url="https://files.catbox.moe/n85fch.mp3", file="AmbitiousHubMusic25.mp3"},
  {name="Piazza Di Spaccio 2 RMX", url="https://files.catbox.moe/0ompvn.mp3", file="AmbitiousHubMusic26.mp3"},
  {name="Benef RMX", url="https://files.catbox.moe/swcqe5.mp3", file="AmbitiousHubMusic27.mp3"},
  {name="Accavallato RMX", url="https://files.catbox.moe/pme01q.mp3", file="AmbitiousHubMusic28.mp3"},
  {name="Hd RMX", url="https://files.catbox.moe/oa3ylr.mp3", file="AmbitiousHubMusic29.mp3"},
  {name="Vyzee", url="https://files.catbox.moe/gmxz02.mp3", file="AmbitiousHubMusic30.mp3"},
  {name="Addiction", url="https://files.catbox.moe/unkq06.mp3", file="AmbitiousHubMusic31.mp3"},
  {name="America RMX", url="https://files.catbox.moe/k09ioc.mp3", file="AmbitiousHubMusic32.mp3"},
  {name="Sprinter", url="https://files.catbox.moe/0gyb73.mp3", file="AmbitiousHubMusic33.mp3"},
  {name="Band4Band", url="https://files.catbox.moe/47dehm.mp3", file="AmbitiousHubMusic34.mp3"},
  {name="Doja RMX", url="https://files.catbox.moe/8ze5d8.mp3", file="AmbitiousHubMusic35.mp3"},
  {name="Opinel RMX", url="https://files.catbox.moe/hf6pdq.mp3", file="AmbitiousHubMusic36.mp3"},
  {name="Vrp RMX", url="https://files.catbox.moe/hjzkbu.mp3", file="AmbitiousHubMusic37.mp3"},
  {name="Tarantelle RMX", url="https://files.catbox.moe/0e9jwg.mp3", file="AmbitiousHubMusic38.mp3"},
  {name="Hood RMX", url="https://files.catbox.moe/raewna.mp3", file="AmbitiousHubMusic39.mp3"},
  {name="Mask RMX", url="https://files.catbox.moe/ghqz2q.mp3", file="AmbitiousHubMusic40.mp3"},
  {name="Spinnin RMX", url="https://files.catbox.moe/r9achz.mp3", file="AmbitiousHubMusic41.mp3"},
  {name="Dnd RMX", url="https://files.catbox.moe/1d83ju.mp3", file="AmbitiousHubMusic42.mp3"},
  {name="Xnx RMX", url="https://files.catbox.moe/a2e54o.mp3", file="AmbitiousHubMusic43.mp3"},
  {name="Hypebae RMX", url="https://files.catbox.moe/oj6hix.mp3", file="AmbitiousHubMusic44.mp3"},
  {name="Mercedes Nero RMX", url="https://h.uguu.se/dCgHArHt.mp3", file="AmbitiousHubMusic45.mp3", rev=2},
  {name="Dissenatori RMX", url="https://files.catbox.moe/fbjq0w.mp3", file="AmbitiousHubMusic46.mp3"},
  {name="British RMX", url="https://files.catbox.moe/jn9mmr.mp3", file="AmbitiousHubMusic47.mp3"},
  {name="Go Go Jack RMX", url="https://files.catbox.moe/u31krk.mp3", file="AmbitiousHubMusic48.mp3"},
  {name="Darkmoney RMX", url="https://files.catbox.moe/rz4mzu.mp3", file="AmbitiousHubMusic49.mp3"},
  {name="Ghetto RMX", url="https://files.catbox.moe/omj56p.mp3", file="AmbitiousHubMusic50.mp3"},
  {name="Copacabana RMX", url="https://files.catbox.moe/g43412.mp3", file="AmbitiousHubMusic51.mp3"},
  {name="Tuff Song", url="https://files.catbox.moe/rvf2vy.mp3", file="ninja_tuffsong.mp3", volume=0.75},
  {name="orula", url="https://files.catbox.moe/v20ko9.mp3", file="ninja_orula.mp3", volume=0.85},
  {name="X.O.X.O", url="https://files.catbox.moe/jghp0f.mp3", file="ninja_xoxo.mp3", volume=0.75},
  {name="beretta", url="https://file.garden/algLafWA1jk8WMfK/Beretta%20-%20video%20oficial(MP3_160K).mp3", file="ninja_beretta.mp3", volume=0.75, startAt=10},
  {name="to the O", url="https://file.garden/algLafWA1jk8WMfK/King%20Von%20-%20Took%20Her%20To%20The%20O%20(Lyrics)(MP3_160K).mp3", file="ninja_to_the_o.mp3", volume=0.75},
  {name="LAJA", url="https://file.garden/algLafWA1jk8WMfK/LAJA%20-%20NADIE%20TA%20FRIO%20(Letra)(MP3_160K).mp3", file="ninja_laja.mp3", volume=0.75},
  {name="HORA 0", url="https://file.garden/algLafWA1jk8WMfK/Myke%20Towers%20-%20HORA%20CERO%20(Lyrics)(MP3_160K).mp3", file="ninja_hora_0.mp3", volume=0.75},
  {name="Lucid Dreams", url="https://file.garden/algLafWA1jk8WMfK/Lucid%20Dreams%20-%20Clean%20-%20Juice%20WRLD(MP3_160K).mp3", file="ninja_lucid_dreams.mp3", volume=0.75},
  {name="WARE", url="https://files.catbox.moe/p2pp91.mp3", file="ninja_ware.mp3", volume=0.75},
  {name="WOW", url="https://files.catbox.moe/14rdtj.mp3", file="ninja_wow.mp3", volume=0.75},
  {name="Seteadora", url="https://files.catbox.moe/94olvv.mp3", file="ninja_seteadora.mp3", volume=0.75},
  {name="aparente", assetId="rbxassetid://99570200535378", volume=0.75},
    }

    ELITE_INTRO_MUSIC_OPTIONS = {

  {name="Song 1", url="https://files.catbox.moe/4inuat.mp3", file="AmbitiousHubIntroSong1.mp3"},
  {name="Song 2", url="https://files.catbox.moe/nyyijv.mp3", file="AmbitiousHubIntroSong2.mp3"},
  {name="Song 3", url="https://files.catbox.moe/bumu1r.mp3", file="AmbitiousHubIntroSong3.mp3"},
  {name="Song 4", url="https://files.catbox.moe/fvms23.mp3", file="AmbitiousHubIntroSong4.mp3"},
  {name="Song 5", url="https://files.catbox.moe/jkbi33.mp3", file="AmbitiousHubIntroSong5.mp3"},
  {name="Song 6", url="https://files.catbox.moe/rweyqn.mp3", file="AmbitiousHubIntroSong6.mp3"},
  {name="Song 7", url="https://files.catbox.moe/m735rs.mp3", file="AmbitiousHubIntroSong7.mp3"},
    }

    selectedMusicSong = selectedMusicSong or 1
    musicPlayerVolume = musicPlayerVolume or 1
    musicPlayerSpeed = musicPlayerSpeed or 1
    musicAutoPlayNext = musicAutoPlayNext == true
    musicShuffleEnabled = musicShuffleEnabled == true
    musicLoopEnabled = musicLoopEnabled == true
    _musicPlayerSound = nil
    _musicPlayerToken = 0
    musicSongCache = musicSongCache or {}
    musicSongDownloading = musicSongDownloading or {}
    musicRevCleaned = musicRevCleaned or {}
    _G.EliteMusicRefreshUI = nil

    local function refreshUI()
        if _G.EliteMusicRefreshUI then pcall(_G.EliteMusicRefreshUI) end
    end

    function getMusicSongName()
        local opt = ELITE_MUSIC_OPTIONS[selectedMusicSong]
        return opt and opt.name or "No Song"
    end

    function musicRandomIndex()
        local total = #ELITE_MUSIC_OPTIONS
        if total <= 1 then return 1 end
        local r = math.random(1, total - 1)
        if r >= selectedMusicSong then r = r + 1 end
        return r
    end

    local function cacheMusicSong(option, allowDownload)
        if not option then return nil end
        if option.assetId and option.assetId ~= "" then return option.assetId end
        if not option.url or option.url == "" then return nil end
        local writeFn = writefile or (syn and syn.writefile)
        local getAsset = getcustomasset or (syn and syn.getcustomasset)
        local hasFileFn = isfile or (syn and syn.isfile)
        local delFn = delfile or (syn and syn.delfile)
        if not (writeFn and getAsset) then return nil end

        local baseName = option.file or ("EliteFamilyMusic_" .. tostring(option.name or "song") .. ".mp3")
        local rev = math.max(math.floor(tonumber(option.rev) or 1), 1)
        local stem = baseName:gsub("%.mp3$", "")
        local fileName = (rev > 1) and (stem .. "_r" .. rev .. ".mp3") or baseName

        if rev > 1 and not musicRevCleaned[baseName] then
            musicRevCleaned[baseName] = true
            for r = 1, rev - 1 do
                local oldName = (r > 1) and (stem .. "_r" .. r .. ".mp3") or baseName
                musicSongCache[oldName] = nil
                pcall(function()
                    if hasFileFn and hasFileFn(oldName) and delFn then delFn(oldName) end
                end)
            end
        end

        local function loadExisting()
            if musicSongCache[fileName] then return musicSongCache[fileName] end
            local hasFile = false
            pcall(function() hasFile = hasFileFn and hasFileFn(fileName) end)
            if hasFile then
                local ok = pcall(function() musicSongCache[fileName] = getAsset(fileName) end)
                if ok and musicSongCache[fileName] then return musicSongCache[fileName] end
            end
            return nil
        end

        local cached = loadExisting()
        if cached then return cached end
        if allowDownload == false then return nil end
        if musicSongDownloading[fileName] then
            local waitStart = tick()
            while musicSongDownloading[fileName] and tick() - waitStart < 15 do task.wait(0.05) end
            cached = loadExisting()
            if cached then return cached end
        end
        musicSongDownloading[fileName] = true
        local ok = pcall(function()
            local data = game:HttpGet(option.url)
            if data and #data > 0 then
                writeFn(fileName, data)
                musicSongCache[fileName] = getAsset(fileName)
            end
        end)
        musicSongDownloading[fileName] = nil
        if ok and musicSongCache[fileName] then return musicSongCache[fileName] end
        return loadExisting()
    end

    local function createMusicSound(option, name)
        if not option then return nil end
        local soundId = cacheMusicSong(option, true)
        if not soundId then return nil end
        local sound = Instance.new("Sound")
        sound.Name = name or "EliteFamilyMusicPlayer"
        sound.Volume = option.volume or musicPlayerVolume
        sound.PlaybackSpeed = musicPlayerSpeed
        sound.Looped = false
        sound.SoundId = soundId
        sound.Parent = SoundService
        if option.startAt then
            pcall(function() sound.TimePosition = option.startAt end)
        end
        return sound
    end

    local function fadeOutMusicSound(sound, dur)
        if not sound then return end
        dur = dur or 1.5
        pcall(function()
            TweenService:Create(sound, TweenInfo.new(dur, Enum.EasingStyle.Linear), {Volume = 0}):Play()
        end)
        task.delay(dur + 0.1, function()
            pcall(function()
                if sound and sound.Parent then
                    sound:Stop()
                    sound:Destroy()
                end
            end)
        end)
    end

    function stopMusicPlayback(fade)
        _musicPlayerToken = _musicPlayerToken + 1
        local sound = _musicPlayerSound
        _musicPlayerSound = nil
        if sound then
            if fade == false then
                pcall(function() sound:Stop(); sound:Destroy() end)
            else
                fadeOutMusicSound(sound, 1.5)
            end
        end
        refreshUI()
    end

    function playMusicSong(index)
        index = tonumber(index) or selectedMusicSong
        local total = #ELITE_MUSIC_OPTIONS
        if total <= 0 then return end
        if index < 1 then index = total end
        if index > total then index = 1 end
        if not ELITE_MUSIC_OPTIONS[index] then return end
        selectedMusicSong = index
        stopMusicPlayback(true)
        local token = _musicPlayerToken
        refreshUI()
        task.spawn(function()
            local option = ELITE_MUSIC_OPTIONS[index]
            local sound = createMusicSound(option, "EliteFamilyMusicPlayer_" .. tostring(token))
            if token ~= _musicPlayerToken then
                if sound then pcall(function() sound:Destroy() end) end
                return
            end
            if not sound then return end
            sound.Volume = option.volume or musicPlayerVolume
            sound.PlaybackSpeed = musicPlayerSpeed
            if not option.startAt then sound.TimePosition = 0 end
            _musicPlayerSound = sound
            local loadStart = tick()
            while sound and sound.Parent and not sound.IsLoaded and tick() - loadStart < 15 do task.wait(0.05) end
            if token ~= _musicPlayerToken then
                pcall(function() if sound and sound.Parent then sound:Destroy() end end)
                return
            end
            pcall(function() sound:Play() end)
            refreshUI()

            local endedConn
            endedConn = sound.Ended:Connect(function()
                if endedConn then pcall(function() endedConn:Disconnect() end) end
                if token ~= _musicPlayerToken then return end
                if musicLoopEnabled then
                    playMusicSong(selectedMusicSong)
                elseif musicShuffleEnabled then
                    playMusicSong(musicRandomIndex())
                elseif musicAutoPlayNext then
                    playMusicSong(selectedMusicSong + 1)
                else
                    stopMusicPlayback(false)
                end
            end)

            task.spawn(function()
                while token == _musicPlayerToken and sound and sound.Parent do
                    local len = sound.TimeLength
                    if len and len > 1 then
                        local remaining = len - sound.TimePosition
                        if remaining <= 1.6 and sound.IsPlaying and sound:GetAttribute("_efFaded") ~= true then
                            sound:SetAttribute("_efFaded", true)
                            local d = math.clamp(remaining - 0.05, 0.2, 1.5)
                            pcall(function()
                                TweenService:Create(sound, TweenInfo.new(d, Enum.EasingStyle.Linear), {Volume = 0}):Play()
                            end)
                        end
                    end
                    task.wait(0.1)
                end
            end)
        end)
        pcall(function() if saveAllSettings then saveAllSettings() end end)
    end

    function toggleMusicPause()
        local sound = _musicPlayerSound
        if not sound or not sound.Parent then
            playMusicSong(selectedMusicSong)
            return
        end
        if sound.IsPlaying then
            pcall(function() sound:Pause() end)
        else
            pcall(function() sound:Resume() end)
        end
        refreshUI()
    end

    function musicNextSong()
        if musicShuffleEnabled then
            playMusicSong(musicRandomIndex())
        else
            playMusicSong(selectedMusicSong + 1)
        end
    end

    function musicPrevSong()
        if musicShuffleEnabled then
            playMusicSong(musicRandomIndex())
        else
            playMusicSong(selectedMusicSong - 1)
        end
    end

    function musicSeek(delta)
        local sound = _musicPlayerSound
        if not sound or not sound.Parent then return end
        local len = sound.TimeLength or 0
        local sp = tonumber(musicPlayerSpeed) or 1
        if sp <= 0 then sp = 1 end
        local newPos = sound.TimePosition + ((tonumber(delta) or 0) * sp)
        if newPos < 0 then newPos = 0 end
        if len > 0 and newPos > (len - 0.2) then newPos = math.max(len - 0.2, 0) end
        pcall(function() sound.TimePosition = newPos end)
        if len > 0 and (len - newPos) > 1.8 then
            pcall(function()
                sound:SetAttribute("_efFaded", false)
                sound.Volume = musicPlayerVolume
            end)
        end
        refreshUI()
    end

    function setMusicSpeed(v)
        v = math.clamp(math.floor((tonumber(v) or 1) * 10 + 0.5) / 10, 0.1, 2)
        musicPlayerSpeed = v
        local sound = _musicPlayerSound
        if sound and sound.Parent then
            pcall(function() sound.PlaybackSpeed = v end)
        end
        pcall(function() if saveAllSettings then saveAllSettings() end end)
        refreshUI()
    end

    function setMusicVolume(v)
        v = math.clamp(math.floor((tonumber(v) or 1) * 100 + 0.5) / 100, 0, 2)
        musicPlayerVolume = v
        local sound = _musicPlayerSound
        if sound and sound.Parent and sound:GetAttribute("_efFaded") ~= true then
            pcall(function() sound.Volume = v end)
        end
        pcall(function() if saveAllSettings then saveAllSettings() end end)
        refreshUI()
    end

    function isMusicPlaying()
        local sound = _musicPlayerSound
        return sound and sound.Parent and sound.IsPlaying == true
    end

    _G.EliteFamilyMusic = {
        play = playMusicSong,
        stop = stopMusicPlayback,
        pause = toggleMusicPause,
        next = musicNextSong,
        prev = musicPrevSong,
        seek = musicSeek,
        setVolume = setMusicVolume,
        setSpeed = setMusicSpeed,
        getName = getMusicSongName,
        isPlaying = isMusicPlaying,
        options = ELITE_MUSIC_OPTIONS,
        introOptions = ELITE_INTRO_MUSIC_OPTIONS,
    }
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
        if c then c.CFrame = c.CFrame * _CFnew(0,0,0,1,0,0,0,0.7,0,0,0,1) end
    end)
    if stretchFovConn then stretchFovConn:Disconnect() end
    stretchFovConn = RunService.RenderStepped:Connect(function()
        if stretchEnabled then applyStretchFOV(stretchFOV)
        else stretchFovConn:Disconnect(); stretchFovConn = nil end
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
        Brightness = Lighting.Brightness, ClockTime = Lighting.ClockTime,
        OutdoorAmbient = Lighting.OutdoorAmbient, GlobalShadows = Lighting.GlobalShadows,
        FogEnd = Lighting.FogEnd, FogStart = Lighting.FogStart,
        FogColor = Lighting.FogColor, Ambient = Lighting.Ambient,
        ColorCorrection = nil, Bloom = nil,
    }
    for _, e in ipairs(Lighting:GetChildren()) do
        if e:IsA("ColorCorrectionEffect") then
            _originalLighting.ColorCorrection = { Enabled = e.Enabled, Brightness = e.Brightness, Contrast = e.Contrast, Saturation = e.Saturation, TintColor = e.TintColor }
        elseif e:IsA("BloomEffect") then
            _originalLighting.Bloom = { Enabled = e.Enabled, Intensity = e.Intensity, Size = e.Size, Threshold = e.Threshold }
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
            cc.Enabled = old.ColorCorrection.Enabled; cc.Brightness = old.ColorCorrection.Brightness
            cc.Contrast = old.ColorCorrection.Contrast; cc.Saturation = old.ColorCorrection.Saturation
            cc.TintColor = old.ColorCorrection.TintColor
        end
    end
    if old.Bloom then
        local bloom = Lighting:FindFirstChildOfClass("BloomEffect")
        if bloom then
            bloom.Enabled = old.Bloom.Enabled; bloom.Intensity = old.Bloom.Intensity
            bloom.Size = old.Bloom.Size; bloom.Threshold = old.Bloom.Threshold
        end
    end
end

SKY_PRESETS_LIST = {"Off","Night","Aurora","Sunset","Galaxy","Cyber","Sakura","Neon Night","Blood Moon","Emerald Dawn","Volcanic","Arctic","Midnight Ocean","Vaporwave","Toxic","Solar Eclipse","Hellscape","Heaven","Storm","Sunrise","Deep Space","Lavender Dream","Inferno","Mint Sky"}

SKY_PRESETS = {
    ["Off"]={kind="off"},
    ["Night"]={clock=22,brightness=2,ambient={110,100,130},outAmb={120,110,140},sky={stars=4000,moon=18,sun=0,moonTex=true},atm={dens=0.45,color={120,60,180},decay={60,20,100},glare=0.5,haze=1.2}},
    ["Aurora"]={clock=14,brightness=3,ambient={150,120,150},outAmb={160,130,150},atm={dens=0.55,color={255,80,200},decay={255,20,150},glare=2.5,haze=3},clouds={cover=0.7,dens=0.7,color={255,240,250}}},
    ["Sunset"]={clock=17.2,brightness=2.5,ambient={170,120,100},outAmb={180,130,110},sky={stars=0,sun=25,moon=0},atm={dens=0.5,color={255,130,60},decay={255,80,30},glare=2,haze=2.5},clouds={cover=0.55,dens=0.55,color={255,200,140}}},
    ["Galaxy"]={clock=0,brightness=1.5,ambient={70,60,100},outAmb={80,70,110},sky={stars=10000,moon=30,sun=0},atm={dens=0.15,color={40,20,80},decay={20,10,50},glare=0.3,haze=0.5}},
    ["Cyber"]={clock=21,brightness=2.2,ambient={90,130,170},outAmb={100,140,180},sky={stars=2000,moon=12},atm={dens=0.4,color={0,200,255},decay={150,0,255},glare=2,haze=2},clouds={cover=0.4,dens=0.6,color={100,200,255}}},
    ["Sakura"]={clock=11,brightness=3.5,ambient={170,150,160},outAmb={180,160,170},sky={sun=8},atm={dens=0.3,color={255,200,220},decay={255,170,200},glare=1,haze=1.5},clouds={cover=0.6,dens=0.4,color={255,250,252}}},
    ["Neon Night"]={clock=23,brightness=2.2,ambient={40,120,70},outAmb={50,140,80},sky={stars=5000,moon=22,sun=0,moonTex=true},atm={dens=0.5,color={50,255,120},decay={20,140,60},glare=0.7,haze=1.4},clouds={cover=0.3,dens=0.5,color={90,180,120}}},
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

local function _vC3(t) return Color3.fromRGB(t[1], t[2], t[3]) end

function _v4mpClearSky()
    for _, child in ipairs(Lighting:GetChildren()) do
        if child:GetAttribute("_AdaptDuelsSky") then
            pcall(function() child:Destroy() end)
        end
    end
    local terrain = workspace:FindFirstChildOfClass("Terrain")
    if terrain then
        for _, child in ipairs(terrain:GetChildren()) do
            if child:GetAttribute("_AdaptDuelsSky") then
                pcall(function() child:Destroy() end)
            end
        end
    end
end

function applyCustomSky(mode)
    _v4mpClearSky()
    local preset = SKY_PRESETS[mode]
    if not preset or preset.kind == "off" then
        Lighting.ClockTime = 14
        Lighting.Brightness = 2
        Lighting.OutdoorAmbient = Color3.fromRGB(127,127,127)
        Lighting.Ambient = Color3.fromRGB(127,127,127)
        Lighting.FogEnd = 100000
        Lighting.GlobalShadows = true
        skyTheme = "Off"
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
    if preset.outAmb then Lighting.OutdoorAmbient = _vC3(preset.outAmb) end
    if preset.ambient then Lighting.Ambient = _vC3(preset.ambient) end
    if preset.sky then
        local skyInst = Instance.new("Sky")
        skyInst:SetAttribute("_AdaptDuelsSky", true)
        if preset.sky.stars then skyInst.StarCount = preset.sky.stars end
        if preset.sky.moon then skyInst.MoonAngularSize = preset.sky.moon end
        if preset.sky.sun then skyInst.SunAngularSize = preset.sky.sun end
        if preset.sky.moonTex then skyInst.MoonTextureId = "rbxasset://sky/moon.jpg" end
        skyInst.Parent = Lighting
    end
    if preset.atm then
        local atm = Instance.new("Atmosphere")
        atm:SetAttribute("_AdaptDuelsSky", true)
        atm.Density = preset.atm.dens or 0.3
        atm.Color = _vC3(preset.atm.color)
        atm.Decay = _vC3(preset.atm.decay)
        atm.Glare = preset.atm.glare or 1
        atm.Haze = preset.atm.haze or 1
        atm.Parent = Lighting
    end
    local terrain = workspace:FindFirstChildOfClass("Terrain")
    if preset.clouds and terrain then
        local clouds = Instance.new("Clouds")
        clouds:SetAttribute("_AdaptDuelsSky", true)
        clouds.Cover = preset.clouds.cover or 0.5
        clouds.Density = preset.clouds.dens or 0.5
        clouds.Color = _vC3(preset.clouds.color)
        clouds.Parent = terrain
    end
    skyTheme = mode
end

function enableVividGraphics()
    if vividGraphicsEnabled and #_vividEffects > 0 then return end
    vividGraphicsEnabled = true
    for _, eff in ipairs(_vividEffects) do
        pcall(function() eff:Destroy() end)
    end
    _vividEffects = {}
    local color = Instance.new("ColorCorrectionEffect")
    color.Parent = Lighting
    color.Saturation = 0.6; color.Contrast = 0.4; color.Brightness = 0.05
    color.TintColor = Color3.fromRGB(255, 240, 220)
    table.insert(_vividEffects, color)
    local bloom = Instance.new("BloomEffect")
    bloom.Parent = Lighting
    bloom.Intensity = 0.8; bloom.Size = 24; bloom.Threshold = 1
    table.insert(_vividEffects, bloom)
    local atmosphere = Instance.new("Atmosphere")
    atmosphere.Parent = Lighting
    atmosphere.Density = 0.3; atmosphere.Offset = 0.25
    atmosphere.Color = Color3.fromRGB(199, 199, 255)
    atmosphere.Decay = Color3.fromRGB(106, 112, 125)
    atmosphere.Glare = 0.2; atmosphere.Haze = 1
    table.insert(_vividEffects, atmosphere)
    local sun = Instance.new("SunRaysEffect")
    sun.Parent = Lighting
    sun.Intensity = 0.2; sun.Spread = 0.8
    table.insert(_vividEffects, sun)
    local dof = Instance.new("DepthOfFieldEffect")
    dof.Parent = Lighting
    dof.FocusDistance = 25; dof.InFocusRadius = 10
    dof.NearIntensity = 0.2; dof.FarIntensity = 0.4
    table.insert(_vividEffects, dof)
    task.spawn(function()
        while vividGraphicsEnabled and color and color.Parent do
            color.Contrast = 0.35 + math.sin(tick() * 2) * 0.05
            task.wait(0.03)
        end
    end)
end

function disableVividGraphics()
    vividGraphicsEnabled = false
    for _, eff in ipairs(_vividEffects) do
        pcall(function() eff:Destroy() end)
    end
    _vividEffects = {}
end

function toggleVividGraphics(on)
    if on then enableVividGraphics() else disableVividGraphics() end
    saveAllSettings(true)
end

function applyHideButtons(state)
    hideButtonsEnabled = state
    if MobilePanel then
        for _, child in ipairs(MobilePanel:GetChildren()) do
            if child:IsA("TextButton") then
                child.Visible = not state
            end
        end
    end
    if tpBatFloatingButton then
        local frame = tpBatFloatingButton:FindFirstChild("Frame")
        if frame then frame.Visible = not state end
    end
    if instaResetFloatingButton then
        local frame = instaResetFloatingButton:FindFirstChild("Frame")
        if frame then frame.Visible = not state end
    end
end

function toggleHideButtons(on)
    applyHideButtons(on)
    if setHideButtonsVisual then setHideButtonsVisual(on) end
    saveAllSettings(true)
end

function paintFloatingBtn(btnFrame, active)
    if not btnFrame then return end
    local bg = btnFrame:FindFirstChild("BtnGrad")
    local label = btnFrame:FindFirstChild("TextLabel")
    local stroke = btnFrame:FindFirstChildOfClass("UIStroke")
    local img = btnFrame:FindFirstChild("BtnBgImage")
    local hasImg = (buttonBgMode ~= "None") and img and img.Visible and img.Image ~= ""
    -- ON = Theme Color seleccionado | OFF = blanco/gris
    local theme = (type(getThemeColor) == "function" and getThemeColor()) or selectedColor or Color3.fromRGB(170, 80, 255)
    local ON_TOP = theme:Lerp(Color3.new(1, 1, 1), 0.35)
    local ON_MID = theme
    local ON_BOT = theme:Lerp(Color3.new(0, 0, 0), 0.35)
    -- Contraste de texto: si el tema es muy claro, texto oscuro
    local lum = theme.R * 0.299 + theme.G * 0.587 + theme.B * 0.114
    local onText = (lum > 0.72) and Color3.fromRGB(20, 20, 28) or Color3.fromRGB(255, 255, 255)
    if active then
        btnFrame.BackgroundColor3 = ON_MID
        btnFrame.BackgroundTransparency = hasImg and 0.40 or 0
        if bg then
            bg.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0.00, ON_TOP),
                ColorSequenceKeypoint.new(0.45, ON_MID),
                ColorSequenceKeypoint.new(1.00, ON_BOT),
            })
            if hasImg then
                bg.Transparency = NumberSequence.new({
                    NumberSequenceKeypoint.new(0, 0.35),
                    NumberSequenceKeypoint.new(1, 0.35),
                })
            else
                bg.Transparency = NumberSequence.new({
                    NumberSequenceKeypoint.new(0, 0),
                    NumberSequenceKeypoint.new(1, 0),
                })
            end
        end
        if label then label.TextColor3 = onText end
        if btnFrame:IsA("TextButton") then btnFrame.TextColor3 = onText end
        if stroke then
            stroke.Color = theme
            stroke.Thickness = 1.8
            stroke.Transparency = 0.1
        end
        if img then
            img.ImageTransparency = 0.12
            img.Visible = (buttonBgMode ~= "None")
            img.ZIndex = (btnFrame.ZIndex or 10) + 1
        end
        local veil = btnFrame:FindFirstChild("BtnBgVeil")
        if veil then
            veil.Visible = hasImg
            veil.BackgroundColor3 = theme:Lerp(Color3.new(0, 0, 0), 0.55)
            veil.BackgroundTransparency = hasImg and 0.50 or 1
            veil.ZIndex = (btnFrame.ZIndex or 10) + 2
        end
    else
        btnFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        btnFrame.BackgroundTransparency = hasImg and 0.55 or 0
        if bg then
            bg.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0.00, Color3.fromRGB(252, 252, 253)),
                ColorSequenceKeypoint.new(0.45, Color3.fromRGB(233, 233, 236)),
                ColorSequenceKeypoint.new(1.00, Color3.fromRGB(168, 168, 176)),
            })
            if hasImg then
                bg.Transparency = NumberSequence.new({
                    NumberSequenceKeypoint.new(0, 0.5),
                    NumberSequenceKeypoint.new(1, 0.5),
                })
            else
                bg.Transparency = NumberSequence.new({
                    NumberSequenceKeypoint.new(0, 0),
                    NumberSequenceKeypoint.new(1, 0),
                })
            end
        end
        if label then
            label.TextColor3 = hasImg and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(32, 32, 40)
        end
        if btnFrame:IsA("TextButton") then
            btnFrame.TextColor3 = hasImg and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(32, 32, 40)
        end
        if stroke then
            stroke.Color = Color3.fromRGB(120, 120, 128)
            stroke.Thickness = 1
            stroke.Transparency = 0.55
        end
        if img then
            img.ImageTransparency = 0.12
            img.Visible = (buttonBgMode ~= "None")
            img.ZIndex = (btnFrame.ZIndex or 10) + 1
        end
        local veil = btnFrame:FindFirstChild("BtnBgVeil")
        if veil then
            veil.Visible = hasImg
            veil.BackgroundColor3 = Color3.fromRGB(8, 6, 14)
            veil.BackgroundTransparency = hasImg and 0.45 or 1
            veil.ZIndex = (btnFrame.ZIndex or 10) + 2
        end
    end
    if label then
        label.ZIndex = (btnFrame.ZIndex or 10) + 3
        if active then
            label.TextColor3 = onText
        elseif hasImg then
            label.TextColor3 = Color3.fromRGB(255, 255, 255)
        else
            label.TextColor3 = Color3.fromRGB(32, 32, 40)
        end
    end
end

function applyFloatingButtonScale()
    for _, uiScale in ipairs(_floatingUIScales) do
        if uiScale and uiScale.Parent then
            uiScale.Scale = floatingButtonScale
        end
    end
end

local function drag(f, dragZoneHeight)
    local dn, ds, sp, di = false, nil, nil, nil
    local endConn = nil
    local zone = dragZoneHeight or 99999
    local function stopDrag()
        local wasDragging = dn
        dn = false
        di = nil
        if endConn then
            endConn:Disconnect()
            endConn = nil
        end
        if wasDragging then task.defer(function() pcall(saveAllSettings) end) end
    end
    f.InputBegan:Connect(function(i)
        if uiLocked then return end
        if _isDraggingButton then return end
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            local framePos = f.AbsolutePosition
            if i.Position.Y > framePos.Y + zone then return end
            dn = true; ds = i.Position; sp = f.Position
            if endConn then endConn:Disconnect() end
            endConn = i.Changed:Connect(function()
                if i.UserInputState == Enum.UserInputState.End then stopDrag() end
            end)
        end
    end)
    f.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            stopDrag()
        end
    end)
    UIS.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            stopDrag()
        end
    end)
    f.InputChanged:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch then di = i end
    end)
    UIS.InputChanged:Connect(function(i)
        if i == di and dn then
            if uiLocked then stopDrag(); return end
            if _isDraggingButton then return end
            if not ds or not sp then return end
            local nX = sp.X.Offset + (i.Position.X - ds.X)
            local nY = sp.Y.Offset + (i.Position.Y - ds.Y)
            f.Position = UDim2.new(sp.X.Scale, nX, sp.Y.Scale, nY)
        end
    end)
end

-- =====================================================================
-- [FIX SPEED VIOLETTE] SPEED ENGINE
-- Evento: PreSimulation (pre-física)
-- SetNetworkOwner por frame con movimiento
-- Jitter aleatorio para no ser detectado por patrones
-- Acumulador de 16ms
-- =====================================================================
_G.__EliteFamilySpeedEngine = _G.__EliteFamilySpeedEngine or { started = false, conn = nil }
_G.__EliteFamilySpeedEngine.signal = nil
do
    local _ok, _sig = pcall(function() return RunService.PreSimulation end)
    _G.__EliteFamilySpeedEngine.signal = (_ok and _sig) or RunService.Heartbeat
end

local function _spd_isRagdollState(hum)
    if not hum then return true end
    local st = hum:GetState()
    return hum.PlatformStand or st == Enum.HumanoidStateType.Physics
        or st == Enum.HumanoidStateType.Ragdoll or st == Enum.HumanoidStateType.FallingDown
end

local function _spd_shouldUseStealSpeed(isStealing)
    if speedMode then return true end
    if isStealing and CONFIG.AUTO_STEAL_ENABLED then return true end
    return false
end

local function _spd_getSelectedBoostSpeed()
    if laggerToggled or laggerCarryToggled then return LAGGER_SPEED end
    return NS
end

local function _spd_getSelectedStealSpeed()
    if laggerCarryToggled then return LAGGER_CARRY_SPEED end
    if laggerToggled then return LAGGER_SPEED end
    return CS
end

local function _spd_getTargetSpeed(isStealing)
    if _spd_shouldUseStealSpeed(isStealing) then return _spd_getSelectedStealSpeed() end
    return _spd_getSelectedBoostSpeed()
end

local function _spd_resetMovement()
    lastMoveDir = _V3zero
    _s2VelState.v = _V3new(0, _s2VelState.v.Y or 0, 0)
end

local function _spd_stop()
    if _G.__EliteFamilySpeedEngine.conn then
        _G.__EliteFamilySpeedEngine.conn:Disconnect()
        _G.__EliteFamilySpeedEngine.conn = nil
    end
    _spd_resetMovement()
end

local function _spd_start()
    _spd_stop()
    _G.__EliteFamilySpeedEngine.started = true
    _G.__EliteFamilySpeedEngine.acc = 0

    _G.__EliteFamilySpeedEngine.conn = _G.__EliteFamilySpeedEngine.signal:Connect(function(dt)
        _G.__EliteFamilySpeedEngine.acc = (_G.__EliteFamilySpeedEngine.acc or 0) + (dt or 0)
        if _G.__EliteFamilySpeedEngine.acc < 0.016 then return end
        _G.__EliteFamilySpeedEngine.acc = 0

        local character = LP.Character
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        local root = character and character:FindFirstChild("HumanoidRootPart")
        if not humanoid or not root or humanoid.Health <= 0 then return end
        if autoBatEnabled or batDesyncTpEnabled
           or autoLeftEnabled or autoRightEnabled
           or dropActive or _G.IsDropping then
            _spd_resetMovement()
            return
        end
        if _spd_isRagdollState(humanoid) then
            lastMoveDir = _V3zero
            return
        end
        if _s2VelState.root ~= root or not _velChecked[root] then
            lastMoveDir = _V3zero
            _setupVelChecked(character)
            _hookVelHRP(root)
        end
        local direction
        if humanoid.MoveDirection.Magnitude > 0 then
            lastMoveDir = humanoid.MoveDirection
            direction = humanoid.MoveDirection
        elseif lastMoveDir.Magnitude > 0 then
            for key in pairs(MOVE_KEYS) do
                if UIS:IsKeyDown(key) then
                    direction = lastMoveDir
                    break
                end
            end
        end
        local selectedSpeed = _spd_getTargetSpeed(LP:GetAttribute("Stealing") == true)
        _applyVelocitySpeed(direction, tonumber(selectedSpeed) or 16, root)
    end)
end

local function _spd_applyNow()
    local character = LP.Character
    local hum = character and character:FindFirstChildOfClass("Humanoid")
    local root = character and character:FindFirstChild("HumanoidRootPart")
    if not hum or not root or hum.Health <= 0 or _spd_isRagdollState(hum) then return end
    local direction = hum.MoveDirection.Magnitude > 0.05 and hum.MoveDirection or nil
    _applyVelocitySpeed(direction, _spd_getTargetSpeed(LP:GetAttribute("Stealing") == true), root)
end

local function _spd_refresh()
    _spd_start()
end

_G.__EliteFamilyRefreshSpeedEngine = _spd_refresh
_G.__EliteFamilyStopSpeedEngine = _spd_stop
_G.__EliteFamilyApplySpeedNow = _spd_applyNow

pcall(_spd_start)

LP.CharacterAdded:Connect(function(character)
    task.wait(0.5)
    _spd_resetMovement()
    local root = character:WaitForChild("HumanoidRootPart", 5)
    if root then _setupVelChecked(character); _hookVelHRP(root) end
    _spd_start()
end)
LP.CharacterRemoving:Connect(function()
    _spd_stop()
    _s2VelState.root = nil
end)

function setupMovementAndIndicators(char)
    if steppedConn then steppedConn:Disconnect(); steppedConn = nil end
    if movementLoop then movementLoop:Disconnect(); movementLoop = nil end

    local ccAcc = 0
    steppedConn = RunService.Heartbeat:Connect(function(dt)
        ccAcc = ccAcc + dt
        if ccAcc < 0.05 then return end
        ccAcc = 0
        local plist = _GetPlayersCached()
        for i = 1, #plist do
            local p = plist[i]
            if p ~= LP then
                local ch = p.Character
                if ch then
                    local parts = ch:GetChildren()
                    for j = 1, #parts do
                        local part = parts[j]
                        if part:IsA("BasePart") and part.CanCollide then
                            part.CanCollide = false
                        end
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
        if not autoBatEnabled and not autoLeftEnabled and not autoRightEnabled
           and not batDesyncTpEnabled then
            if _isRagdollState(hum) then
                lastMoveDir = _V3zero
            else
                local md = hum.MoveDirection
                if md.Magnitude > 0 then
                    lastMoveDir = md
                end
            end
        end
        if speedLabel then
            local displaySpeed = getActiveMoveSpeed()
            speedLabel.Text = string.format("%.1f  -  %s", displaySpeed, getSpeedModeName())
        end
    end)
    setupSpeedIndicator(char)
    startEnemySpeed()
end

function toggleLockUI(state)
    if state == nil then uiLocked = not uiLocked else uiLocked = state end
    if setLockUIVisual then setLockUIVisual(uiLocked) end
end

function disableAllAimbots()
    if autoBatEnabled then
        disableAutoBat()
        if autoBatSetVisual then autoBatSetVisual(false) end
        if mobSetAutoBat then mobSetAutoBat(false) end
    end
    if batDesyncTpEnabled then stopBatDesyncTp() end
    if autoBatV2Enabled then
        disableBatV2()
        if autoBatV2SetVisual then autoBatV2SetVisual(false) end
        if batV2FloatingButton then
            local btnFrame = batV2FloatingButton:FindFirstChild("Frame")
            if btnFrame then paintFloatingBtn(btnFrame, false) end
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
    if AntiRagdollV2.Enabled then stopAntiRagdollV2() end
    if antiDieEnabled then AntiDieModule.stop() end
    if antiBatEnabled then stopAntiBat() end
    if antiFlingEnabled then stopAntiFling() end
    stopBatCounter()
    stopBatCounterV2()
    stopMedusaCounter()
    stopAutoSteal()
    disableAutoBat()
    if batDesyncTpEnabled then stopBatDesyncTp() end
    if autoBatV2Enabled then disableBatV2() end
    if katanaSkinEnabled then
        katanaSkinEnabled = false
        pcall(function() katanaSkinController.ApplySkin("NONE") end)
    end
    if minecraftBatSkinEnabled then
        minecraftBatSkinEnabled = false
        minecraftBatSkinController.State.enabled = false
        pcall(minecraftBatSkinController.Remove)
    end
    stopAutoLeft()
    stopAutoRight()
    if unwalkEnabled and not _tpBatUnwalkForced then stopUnwalk() end
    if antiLagEnabled then disableAntiLag() end
    if espEnabled then toggleESP(false) end
    if espLineEnabled then stopESPLine() end
    if dropActive then stopDropBrainrot() end
    if bodyLockEnabled then stopBodyLock() end
    _blSuppressCount = 0
    _blWasEnabled = false
    if _blRestoreTimer then pcall(task.cancel, _blRestoreTimer); _blRestoreTimer = nil end
    if _bodyLockConn then _bodyLockConn:Disconnect(); _bodyLockConn = nil end
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
    if _G.__EliteFamilyStopSpeedEngine then pcall(_G.__EliteFamilyStopSpeedEngine) end
end

local _eliteSaveState = {lastAt = 0, queued = false, writing = false, revision = 0}
local function resolveEliteFamilyFileApi()
    local env = (getgenv and getgenv()) or _G
    local readCandidates = {readfile, syn and syn.readfile, env.readfile}
    local writeCandidates = {writefile, syn and syn.writefile, env.writefile}
    local readFn, writeFn
    for _, fn in pairs(readCandidates) do if type(fn) == "function" then readFn = fn; break end end
    for _, fn in pairs(writeCandidates) do if type(fn) == "function" then writeFn = fn; break end end
    return readFn, writeFn
end

local function eliteFileExists(path)
    local readFn = resolveEliteFamilyFileApi()
    if not readFn then return false end
    local ok, data = pcall(readFn, path)
    return ok and type(data) == "string"
end

function buildConfigTable()
    local config = {
        normalSpeed = NS, carrySpeed = CS,
        laggerSpeed1 = LAGGER_SPEED, laggerSpeed2 = LAGGER_CARRY_SPEED,
        stealRadius = CONFIG.STEAL_RANGE,
        antiRagdollMode = antiRagdollMode, antiDieEnabled = antiDieEnabled,
        antiBat = antiBatEnabled,
        antiFling = antiFlingEnabled,
        selectedStealMode = selectedStealMode,
        autoSteal = CONFIG.AUTO_STEAL_ENABLED,
        medusaCounter = medusaCounterEnabled, batCounter = batCounterEnabled,
        batCounterV2 = batCounterV2Enabled, unwalkEnabled = unwalkEnabled,
        laggerToggled = laggerToggled, laggerCarryToggled = laggerCarryToggled,
        carryMode = speedMode, batAimbotSpeed = BAT_AIMBOT_SPEED,
        dropMode = dropMode, stretchEnabled = stretchEnabled, stretchFOV = stretchFOV,
        uiScale = uiScaleValue, animPack = currentAnimPack,
        espEnabled = espEnabled,
        espLineEnabled = espLineEnabled,
        vividGraphics = vividGraphicsEnabled,
        hideButtons = hideButtonsEnabled,
        antiLag = antiLagEnabled, customSounds = customSoundsEnabled, tpBatEnabled = batDesyncTpEnabled, autoBatV2Enabled = autoBatV2Enabled, selectedMusicSong = selectedMusicSong, musicPlayerVolume = musicPlayerVolume, musicPlayerSpeed = musicPlayerSpeed, musicLoopEnabled = musicLoopEnabled, musicShuffleEnabled = musicShuffleEnabled, musicAutoPlayNext = musicAutoPlayNext,
        skyTheme = skyTheme, mobileButtonPositions = savedButtonPositions,
        dropBrainrotKey = {kb = KB.DropBrainrot.kb and KB.DropBrainrot.kb.Name, gp = KB.DropBrainrot.gp and KB.DropBrainrot.gp.Name},
        autoLeftKey = {kb = KB.AutoLeft.kb and KB.AutoLeft.kb.Name, gp = KB.AutoLeft.gp and KB.AutoLeft.gp.Name},
        autoRightKey = {kb = KB.AutoRight.kb and KB.AutoRight.kb.Name, gp = KB.AutoRight.gp and KB.AutoRight.gp.Name},
        autoBatKey = {kb = KB.AutoBat.kb and KB.AutoBat.kb.Name, gp = KB.AutoBat.gp and KB.AutoBat.gp.Name},
        tpFloorKey = {kb = KB.TPFloor.kb and KB.TPFloor.kb.Name, gp = KB.TPFloor.gp and KB.TPFloor.gp.Name},
        guiHideKey = {kb = KB.GuiHide.kb and KB.GuiHide.kb.Name, gp = KB.GuiHide.gp and KB.GuiHide.gp.Name},
        carryToggleKey = {kb = KB.CarryToggle.kb and KB.CarryToggle.kb.Name, gp = KB.CarryToggle.gp and KB.CarryToggle.gp.Name},
        laggerModeKey = {kb = KB.LaggerMode.kb and KB.LaggerMode.kb.Name, gp = KB.LaggerMode.gp and KB.LaggerMode.gp.Name},
        tpBatKey = {kb = KB.TPBat.kb and KB.TPBat.kb.Name, gp = KB.TPBat.gp and KB.TPBat.gp.Name},
        batV2Key = {kb = KB.BatV2.kb and KB.BatV2.kb.Name, gp = KB.BatV2.gp and KB.BatV2.gp.Name},
        instaResetKey = {kb = KB.InstaReset.kb and KB.InstaReset.kb.Name, gp = KB.InstaReset.gp and KB.InstaReset.gp.Name},
        tpBatFloatingPos = tpBatFloatingPos, batV2FloatingPos = batV2FloatingPos, instaResetFloatingPos = instaResetFloatingPos,
        bodyLockEnabled = bodyLockEnabled, bodyLockRange = bodyLockRange,
        progressBarPos = savedProgressBarPos, lockUI = uiLocked,
        backgroundIndex = backgroundIndex,
        backgroundImageTransparency = backgroundImageTransparency,
        backgroundMode = backgroundMode,
        buttonBgIndex = buttonBgIndex,
        buttonBgMode = buttonBgMode,
        floatingButtonScale = floatingButtonScale,
        outfitIndex = currentOutfitIndex, themeColor = currentColorTheme,
        katanaSkinEnabled = katanaSkinEnabled,
        minecraftBatSkinEnabled = minecraftBatSkinEnabled,
        minecraftBatSkinColorMode = minecraftBatSkinColorMode,
    }
    if main then
        local basePos = _G.__EliteFamilyMainOriginalPos or main.Position
        config.mainPosition = {
            XScale = basePos.X.Scale,
            XOffset = basePos.X.Offset,
            YScale = basePos.Y.Scale,
            YOffset = basePos.Y.Offset,
        }
    end
    if pbFrame then
        config.progressBarPos = {XScale = pbFrame.Position.X.Scale, XOffset = pbFrame.Position.X.Offset, YScale = pbFrame.Position.Y.Scale, YOffset = pbFrame.Position.Y.Offset}
    end
    if MobilePanel then
        config.mobilePanelPos = {XScale = 0, XOffset = 10, YScale = 0, YOffset = 0}
        for _, btn in ipairs(MobilePanel:GetChildren()) do
            if btn:IsA("TextButton") then
                savedButtonPositions[btn.Name] = {X = btn.Position.X.Offset, Y = btn.Position.Y.Offset}
            end
        end
        config.mobileButtonPositions = savedButtonPositions
    end
    return config
end

function saveAllSettings(force)
    if _isResetting or _isLoading then return true end
    local config = buildConfigTable()
    config.configVersion = 2
    config.userId = LP.UserId
    local encodedOk, json = pcall(function() return HS:JSONEncode(config) end)
    if not encodedOk then return false end
    if not force and json == _lastSavedJSON then return true end
    if _eliteSaveState.writing or (not force and _tick() - _eliteSaveState.lastAt < 0.25) then
        if not _eliteSaveState.queued then
            _eliteSaveState.queued = true
            task.delay(0.25, function()
                _eliteSaveState.queued = false
                saveAllSettings(true)
            end)
        end
        return true
    end
    local readFn, writeFn = resolveEliteFamilyFileApi()
    if not readFn or not writeFn then
        warn("[ELITE FAMILY Save] Executor file API is unavailable.")
        return false
    end
    _eliteSaveState.writing = true
    _eliteSaveState.revision = _eliteSaveState.revision + 1
    config.revision = _eliteSaveState.revision
    config.savedAt = os.time()
    json = HS:JSONEncode(config)
    local ok = pcall(function()
        if eliteFileExists(CONFIG_FILE) then
            local previous = readFn(CONFIG_FILE)
            if type(previous) == "string" then writeFn(CONFIG_FILE .. ".backup", previous) end
        end
        writeFn(CONFIG_FILE, json)
        local readBack = readFn(CONFIG_FILE)
        if readBack ~= json then error("save verification failed") end
        HS:JSONDecode(readBack)
    end)
    _eliteSaveState.writing = false
    _eliteSaveState.lastAt = _tick()
    if ok then _lastSavedJSON = json else warn("[ELITE FAMILY Save] Write or verification failed.") end
    return ok
end

do
    local readFn, writeFn = resolveEliteFamilyFileApi()
    if readFn and writeFn then
        local oldPath = "BloodHounds_" .. tostring(LP.UserId) .. ".json"
        local okOld, old = pcall(readFn, oldPath)
        local okNew, _ = pcall(readFn, CONFIG_FILE)
        if okOld and type(old) == "string" and not okNew then
            pcall(writeFn, CONFIG_FILE, old)
            warn("[ELITE FAMILY] Config migrada de " .. oldPath .. " a " .. CONFIG_FILE)
        end
    end
end

function loadAllSettings()
    local readFn = resolveEliteFamilyFileApi()
    if not readFn or not eliteFileExists(CONFIG_FILE) then return false end
    local success, data = pcall(function() return HS:JSONDecode(readFn(CONFIG_FILE)) end)
    if not success or not data then return false end
    _isLoading = true
    NS = data.normalSpeed or NS
    CS = data.carrySpeed or CS
    LAGGER_SPEED = data.laggerSpeed1 or LAGGER_SPEED
    LAGGER_CARRY_SPEED = data.laggerSpeed2 or LAGGER_CARRY_SPEED
    CONFIG.STEAL_RANGE = data.stealRadius or CONFIG.STEAL_RANGE
    if radInput then radInput.Text = tostring(CONFIG.STEAL_RANGE) end
    if tonumber(data.configVersion) >= 2 and data.lockUI ~= nil then
        uiLocked = data.lockUI
    else
        uiLocked = false
    end
    mobileButtonsLocked = false
    if data.antiRagdollMode then
        antiRagdollMode = data.antiRagdollMode
    else
        antiRagdollMode = data.antiRagdoll and "v2" or "off"
    end
    antiDieEnabled = data.antiDieEnabled or false
    antiBatEnabled = data.antiBat or false
    antiFlingEnabled = data.antiFling or false
    selectedStealMode = (data.selectedStealMode == "V2") and "V2" or "V1"
    if selectedStealMode == "V2" then
        CONFIG.STEAL_RANGE = 60
        Steal.StealRadius = 60
        if radInput then radInput.Text = "60" end
    end
    CONFIG.AUTO_STEAL_ENABLED = data.autoSteal or false
    medusaCounterEnabled = data.medusaCounter or false
    batCounterEnabled = data.batCounter or false
    batCounterV2Enabled = data.batCounterV2 or false
    unwalkEnabled = data.unwalkEnabled or data.unwalk or false
    antiLagEnabled = data.antiLag or false
    customSoundsEnabled = data.customSounds or false
    selectedMusicSong = math.max(1, tonumber(data.selectedMusicSong) or 1)
    musicPlayerVolume = tonumber(data.musicPlayerVolume) or musicPlayerVolume or 1
    musicPlayerSpeed = tonumber(data.musicPlayerSpeed) or musicPlayerSpeed or 1
    musicLoopEnabled = data.musicLoopEnabled == true
    musicShuffleEnabled = data.musicShuffleEnabled == true
    musicAutoPlayNext = data.musicAutoPlayNext == true
    laggerToggled = data.laggerToggled or false
    speedMode = data.carryMode or false
    laggerCarryToggled = data.laggerCarryToggled or false
    uiScaleValue = _clamp(tonumber(data.uiScale) or 78, 50, 150)
    if mainUIScale then mainUIScale.Scale = uiScaleValue / 100 end
    if pbScale then pbScale.Scale = uiScaleValue / 100 end
    espEnabled = data.espEnabled or false
    espLineEnabled = data.espLineEnabled or false
    if espEnabled then pcall(toggleESP, true) else pcall(toggleESP, false) end

    vividGraphicsEnabled = data.vividGraphics or false
    hideButtonsEnabled = data.hideButtons or false
    katanaSkinEnabled = data.katanaSkinEnabled == true
    minecraftBatSkinEnabled = data.minecraftBatSkinEnabled == true
    minecraftBatSkinColorMode = data.minecraftBatSkinColorMode or "Default"

    do
        local tc = data.themeColor
        if tc == "Pink" then tc = "Neon" end
        currentColorTheme = COLOR_THEMES[tc] and tc or "Neon"
        selectedColor = COLOR_THEMES[currentColorTheme]
    end
    task.defer(function() updateAllUIThemeColors(selectedColor) end)

    autoBatV2Enabled = data.autoBatV2Enabled or false
    local tpBatStateLoaded = data.tpBatEnabled or false
    if tpBatStateLoaded then
        task.defer(function()
            pcall(function()
                startBatDesyncTp()
                if batDesyncTpSetVisual then batDesyncTpSetVisual(true) end
                updateTpBatButtonWithAntiDie(true)
            end)
        end)
    else
        if batDesyncTpSetVisual then batDesyncTpSetVisual(false) end
        updateTpBatButtonWithAntiDie(false)
    end
    skyTheme = data.skyTheme or "Off"
    if skyTheme ~= "Off" then pcall(applyCustomSky, skyTheme) end
    if skySelectorLabel then skySelectorLabel.Text = skyTheme end
    if data.animPack and ANIM_PACKS[data.animPack] then
        pcall(startAnimPack, data.animPack)
    else
        currentAnimPack = "Off"
        stopAnimPack()
    end
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
    lk(KB.GuiHide, data.guiHideKey)
    lk(KB.CarryToggle, data.carryToggleKey)
    lk(KB.LaggerMode, data.laggerModeKey)
    lk(KB.TPBat, data.tpBatKey)
    lk(KB.BatV2, data.batV2Key)
    lk(KB.InstaReset, data.instaResetKey)
    if data.mobileButtonPositions then savedButtonPositions = data.mobileButtonPositions end
    if data.mobilePanelPos then savedMobilePanelPos = data.mobilePanelPos end
    if data.mainPosition and main then
        main.Position = UDim2.new(data.mainPosition.XScale or 0, data.mainPosition.XOffset or 20, data.mainPosition.YScale or 0, data.mainPosition.YOffset or 2)
    end
    if data.tpBatFloatingPos then tpBatFloatingPos = data.tpBatFloatingPos end
    if data.batV2FloatingPos then batV2FloatingPos = data.batV2FloatingPos end
    if data.instaResetFloatingPos then instaResetFloatingPos = data.instaResetFloatingPos end
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
    dropMode = data.dropMode or 1
    stretchEnabled = data.stretchEnabled or false
    stretchFOV = data.stretchFOV or 120
    BAT_AIMBOT_SPEED = data.batAimbotSpeed or BAT_AIMBOT_SPEED
    backgroundIndex = data.backgroundIndex or 1
    backgroundImageTransparency = (type(data.backgroundImageTransparency) == "number") and data.backgroundImageTransparency or 0
    do
        local bm = data.backgroundMode
        if bm == "None" then
            backgroundMode = "None"
        else
            local n = tonumber(tostring(bm or ""):match("%d+")) or tonumber(data.backgroundIndex) or 1
            if n < 1 then n = 1 end
            if n > #backgroundImages then n = #backgroundImages end
            backgroundIndex = n
            backgroundMode = "Background " .. tostring(n)
            if backgroundImageTransparency == nil or backgroundImageTransparency >= 0.99 then
                backgroundImageTransparency = 0
            end
        end
    end
    do
        local bm = data.buttonBgMode
        if bm == "None" then
            buttonBgMode = "None"
        else
            local n = tonumber(tostring(bm or ""):match("%d+")) or tonumber(data.buttonBgIndex) or 1
            if n < 1 then n = 1 end
            if n > #buttonBgImages then n = #buttonBgImages end
            buttonBgIndex = n
            buttonBgMode = "Background " .. tostring(n)
        end
        if buttonBgSelectorLabel then buttonBgSelectorLabel.Text = buttonBgMode end
        if applyButtonBackgroundMode then pcall(applyButtonBackgroundMode, buttonBgMode) end
        if refreshAllButtonBackgrounds then pcall(refreshAllButtonBackgrounds) end
    end
    floatingButtonScale = data.floatingButtonScale or 1
    if data.outfitIndex and data.outfitIndex >= 1 and data.outfitIndex <= #OUTFITS then
        currentOutfitIndex = data.outfitIndex
        task.defer(function()
            pcall(function() applyOutfitByIndex(currentOutfitIndex) end)
            if outfitSelectorLabel then
                outfitSelectorLabel.Text = OUTFITS[currentOutfitIndex].label
            end
        end)
    end
    if _G._eliteStealModeSetter then
        task.defer(function() _G._eliteStealModeSetter(selectedStealMode) end)
    end
    if vividGraphicsEnabled then
        task.defer(function() pcall(enableVividGraphics) end)
    else
        task.defer(function() pcall(disableVividGraphics) end)
    end
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
    if laggerBox then laggerBox.Text = tostring(LAGGER_SPEED) end
    if lagger2Box then lagger2Box.Text = tostring(LAGGER_CARRY_SPEED) end
    if batSpeedBox then batSpeedBox.Text = tostring(BAT_AIMBOT_SPEED) end
    if uiScaleBox then uiScaleBox.Text = tostring(uiScaleValue) end
    if dropModeBtnRef then dropModeBtnRef.Text = dropMode == 1 and "Fling" or "Jump Drop" end
    if bodyLockRangeBox then bodyLockRangeBox.Text = tostring(bodyLockRange) end
    local function safeSet(fn, val) if fn then fn(val) end end
    safeSet(autoBatSetVisual, false)
    safeSet(autoLeftSetVisual, false)
    safeSet(autoRightSetVisual, false)
    safeSet(setBatCounterVisual, false)
    safeSet(setBatCounterV2Visual, false)
    safeSet(setMedusaVisual, false)
    safeSet(setUnwalkVisual, false)
    safeSet(setAntiLagVisual, false)
    safeSet(setCustomSoundsVisual, false)
    if _G.EliteFamilyCustomSounds then pcall(function() _G.EliteFamilyCustomSounds.setEnabled(false) end) end
    customSoundsEnabled = false
    safeSet(setLockUIVisual, false)
    safeSet(setInstaGrab, false)
    safeSet(batDesyncTpSetVisual, false)
    safeSet(setESPVIsual, false)
    safeSet(setESPLineVisual, false)
    safeSet(setVividVisual, false)
    safeSet(setHideButtonsVisual, false)
    safeSet(bodyLockSetVisual, false)
    safeSet(setAntiDieVisual, false)
    safeSet(setAntiBatVisual, false)
    safeSet(setAntiFlingVisual, false)
    safeSet(setAntiRagVisual, false)
    disableVividGraphics()
    applyHideButtons(false)
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
    if stopAntiBat then stopAntiBat() end
    if stopAntiFling then stopAntiFling() end
    if stopESPLine then stopESPLine() end
    skyTheme = "Off"
    pcall(applyCustomSky, "Off")
    if skySelectorLabel then skySelectorLabel.Text = "Off" end
    if antiDieEnabled then
        AntiDieModule.stop()
        antiDieEnabled = false
    end
    updateTpBatButtonWithAntiDie(false)
    for _, ref in ipairs(keyButtonRefs) do
        local entry = ref.entry
        local label = (entry.gp and entry.gp.Name) or (entry.kb and entry.kb.Name) or "None"
        ref.btn.Text = label
    end
    currentColorTheme = "Neon"
    selectedColor = COLOR_THEMES["Neon"]
    updateAllUIThemeColors(selectedColor)
    if miniBtn then
        local stroke = miniBtn:FindFirstChildOfClass("UIStroke")
        if stroke then stroke.Color = Color3.fromRGB(42, 43, 47) end
    end
    if MobilePanel then
        for _, btn in ipairs(MobilePanel:GetChildren()) do
            if btn:IsA("TextButton") then
                local label = btn:FindFirstChildOfClass("TextLabel")
                if label then
                    local isActive = btn.BackgroundColor3 == selectedColor
                    if not isActive then label.TextColor3 = selectedColor end
                end
            end
        end
    end
    saveAllSettings()
end

function resetFloatingPositions()
    if MobilePanel then
        savedButtonPositions = {}
        for _, btn in ipairs(MobilePanel:GetChildren()) do
            if btn:IsA("TextButton") and btn.Name then
                local defX, defY = getDefaultButtonPosition(btn.Name)
                btn.Position = UDim2.new(0, defX, 0, defY)
            end
        end
    end
    if tpBatFloatingButton and tpBatFloatingButton:FindFirstChild("Frame") then
        local btnFrame = tpBatFloatingButton:FindFirstChild("Frame")
        btnFrame.Position = UDim2.new(0.5, 20, 0, 10)
        tpBatFloatingPos = nil
    end
    if instaResetFloatingButton and instaResetFloatingButton:FindFirstChild("Frame") then
        instaResetFloatingButton.Frame.Position = UDim2.new(0.5, 90, 0, 10)
        instaResetFloatingPos = nil
    end
    if pbFrame then
        pbFrame.Position = UDim2.new(0.5, -160, 0.80, 0)
        savedProgressBarPos = nil
    end
    savedMobilePanelPos = nil
    tpBatFloatingPos = nil
end

function resetToFactoryDefaults()
    _isResetting = true
    local ok, err = pcall(function()
        stopAutoSteal()
        stopBatCounter()
        stopBatCounterV2()
        stopMedusaCounter()
        if AntiRagdollV2.Enabled then stopAntiRagdollV2() end
        if antiDieEnabled then AntiDieModule.stop() end
        if antiBatEnabled and stopAntiBat then stopAntiBat() end
        if antiFlingEnabled and stopAntiFling then stopAntiFling() end
        stopUnwalk()
        disableAutoBat()
        if batDesyncTpEnabled then stopBatDesyncTp() end
        stopBodyLock()
        if espEnabled then toggleESP(false) end
        if espLineEnabled and stopESPLine then stopESPLine() end
        if stretchEnabled then disableStretch() end
        if antiLagEnabled then disableAntiLag() end
        if vividGraphicsEnabled then disableVividGraphics() end
        if hideButtonsEnabled then applyHideButtons(false) end
        if dropActive then stopDropBrainrot() end
        skyTheme = "Off"
        pcall(applyCustomSky, "Off")
        if skySelectorLabel then skySelectorLabel.Text = "Off" end
        if antiDieEnabled then AntiDieModule.stop(); antiDieEnabled = false end
        NS = 60; CS = 29; LAGGER_SPEED = 15; LAGGER_CARRY_SPEED = 24.5
        CONFIG.STEAL_RANGE = 61
        speedMode = false; laggerToggled = false; laggerCarryToggled = false
        antiRagdollMode = "off"; antiDieEnabled = false
        antiBatEnabled = false
        antiFlingEnabled = false
        medusaCounterEnabled = false; batCounterEnabled = false; batCounterV2Enabled = false
        autoBatEnabled = false; autoLeftEnabled = false; autoRightEnabled = false
        katanaSkinEnabled = false
        pcall(function() katanaSkinController.ApplySkin("NONE") end)
        minecraftBatSkinEnabled = false
        minecraftBatSkinColorMode = "Default"
        minecraftBatSkinController.State.enabled = false
        pcall(minecraftBatSkinController.Remove)
        if MinecraftBatColorSelector then MinecraftBatColorSelector.Text = "Default" end
        if MinecraftBatSetVisual then MinecraftBatSetVisual(false) end
        unwalkEnabled = false; antiLagEnabled = false
        uiLocked = false; mobileButtonsLocked = false
        CONFIG.AUTO_STEAL_ENABLED = false
        selectedStealMode = "V1"
        if _G._eliteStealModeSetter then pcall(_G._eliteStealModeSetter, "V1") end
        BAT_AIMBOT_SPEED = 58
        dropMode = 1; stretchEnabled = false; stretchFOV = 120
        uiScaleValue = 78
        if mainUIScale then mainUIScale.Scale = 1 end
        if pbScale then pbScale.Scale = 1 end
        espEnabled = false; espLineEnabled = false; vividGraphicsEnabled = false; hideButtonsEnabled = false
        bodyLockEnabled = false; bodyLockRange = 20
        backgroundIndex = 1; backgroundImageTransparency = 0; backgroundMode = "Background 1"
        buttonBgIndex = 1; buttonBgMode = "Background 1"
        if buttonBgSelectorLabel then buttonBgSelectorLabel.Text = buttonBgMode end
        if refreshAllButtonBackgrounds then pcall(refreshAllButtonBackgrounds) end
        floatingButtonScale = 1
        if batDesyncTpEnabled then stopBatDesyncTp() end
        currentAnimPack = "Off"; stopAnimPack()
        currentOutfitIndex = 1
        currentColorTheme = "Neon"; selectedColor = COLOR_THEMES["Neon"]
        if main then main.Position = UDim2.new(0, 20, 0, 2); _G.__EliteFamilyMainOriginalPos = main.Position end
        for key, val in pairs(DEFAULT_KB) do
            if KB[key] then KB[key].kb = val.kb; KB[key].gp = val.gp end
        end
        resetFloatingPositions()
        forceResetUI()
        updateProgressBarVisibility()
        refreshSpeedModeLabel()
        _lastSavedJSON = nil
    end)
    _isResetting = false
    if not ok then warn("[resetToFactoryDefaults]", err) end
    if ok then saveAllSettings(true) end
    return ok
end

function updateProgressBarVisibility()
    if pbFrame then pbFrame.Visible = CONFIG.AUTO_STEAL_ENABLED end
end

function applyShimmerToText(obj, speed)
    speed = speed or 0.8
    local color = getThemeColor()
    local grad = Instance.new("UIGradient", obj)
    grad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, color),
        ColorSequenceKeypoint.new(0.3, Color3.fromRGB(200,200,200)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255,255,255)),
        ColorSequenceKeypoint.new(0.7, Color3.fromRGB(200,200,200)),
        ColorSequenceKeypoint.new(1, color),
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
    local orderMap = { DropBR = 0, AutoLeft = 1, AutoBat = 2, AutoRight = 3, TpDown = 4, Carry = 5, Lagger1 = 6, Lagger2 = 7 }
    local order = orderMap[btnName] or 0
    local row = _floor(order / 2)
    local col = order % 2
    return col * (BTN_W + GAP), row * (BTN_H + GAP + 10)
end

-- [FIX INSTA RESET VIOLETTE]
do
    if not _G.InstaResetLoaded then
        _G.InstaResetLoaded = true

        local state = _G._EliteFamilyInstaResetState
        if type(state) ~= "table" then
            state = {
                busy = false, busyAt = 0,
                token = 0,
                cameraConn = nil, cameraHeld = false, cameraHeldAt = 0,
                speed = 1000000,
                wantAntiDie = nil,
                wantAntiBat = nil,
                wantTpBatDie = nil,
            }
            _G._EliteFamilyInstaResetState = state
        end

        local HOLD_TIME   = 1.5
        local FALLBACK    = 1.2
        local WAIT_RESPAWN = 8

        local function suspendGuards()
            if _antiDieEnabled then
                state.wantAntiDie = true
                pcall(function() _antiDieSetEnabled(false) end)
            end
            if AntiDieModule and AntiDieModule.enabled then
                state.wantAntiDie = true
                pcall(function() AntiDieModule.stop() end)
            end
            if antiBatEnabled then
                state.wantAntiBat = true
                pcall(stopAntiBat)
            end
            if _G._AdaptTpBatAntiDie and _G._VynxTPBatOn then
                state.wantTpBatDie = true
                pcall(_G._AdaptTpBatAntiDie.stop)
            end
        end

        local function restoreGuards()
            if state.wantAntiDie then
                state.wantAntiDie = nil
                pcall(function()
                    antiDieEnabled = true
                    if AntiDieModule then AntiDieModule.start() end
                    if _antiDieSetEnabled then _antiDieSetEnabled(true) end
                end)
            end
            if state.wantAntiBat then
                state.wantAntiBat = nil
                pcall(function() if antiBatEnabled then startAntiBat() end end)
            end
            if state.wantTpBatDie and _G._AdaptTpBatAntiDie and _G._VynxTPBatOn then
                state.wantTpBatDie = nil
                pcall(_G._AdaptTpBatAntiDie.start)
            end
        end

        local function holdCamera(oldChar)
            local cam = workspace.CurrentCamera
            if not cam then return end
            if state.cameraHeld and (os.clock() - (state.cameraHeldAt or 0)) < 5 then return end
            state.cameraHeld = true
            state.cameraHeldAt = os.clock()
            local heldCFrame, heldFocus = cam.CFrame, cam.Focus

            pcall(function()
                cam.CameraType = Enum.CameraType.Scriptable
                cam.CFrame = heldCFrame
                cam.Focus = heldFocus
            end)

            state.cameraConn = RunService.RenderStepped:Connect(function()
                if workspace.CurrentCamera ~= cam then return end
                cam.CameraType = Enum.CameraType.Scriptable
                cam.CFrame = heldCFrame
                cam.Focus = heldFocus
            end)

            task.spawn(function()
                local elapsed = 0
                while LP.Character == oldChar and elapsed < 3 do
                    elapsed = elapsed + task.wait()
                end
                if state.cameraConn then
                    pcall(function() state.cameraConn:Disconnect() end)
                    state.cameraConn = nil
                end
                state.cameraHeld = false
                local newCam = workspace.CurrentCamera or cam
                if newCam then
                    pcall(function()
                        newCam.CameraType = Enum.CameraType.Custom
                        local newChar = LP.Character
                        local hum = newChar and newChar:FindFirstChildOfClass("Humanoid")
                        if hum then newCam.CameraSubject = hum end
                    end)
                end
            end)
        end

        local function flingUp(character)
            local root = character and character:FindFirstChild("HumanoidRootPart")
            if not (root and root:IsA("BasePart")) then return false end
            local hum = character:FindFirstChildOfClass("Humanoid")
            if hum then
                pcall(function()
                    hum:SetStateEnabled(Enum.HumanoidStateType.Dead, true)
                    hum.BreakJointsOnDeath = true
                    hum.PlatformStand = true
                    hum:ChangeState(Enum.HumanoidStateType.Freefall)
                end)
            end
            local vel = Vector3.new(0, math.clamp(state.speed, 1000, 10000000), 0)
            local function pulse()
                if not root.Parent then return false end
                return pcall(function()
                    root.AssemblyAngularVelocity = Vector3.zero
                    root.AssemblyLinearVelocity = vel
                end)
            end
            if not pulse() then return false end
            task.spawn(function()
                local elapsed = 0
                while elapsed < HOLD_TIME do
                    elapsed = elapsed + RunService.Heartbeat:Wait()
                    if not root.Parent then return end
                    if LP.Character ~= character then return end
                    pulse()
                end
            end)
            return true
        end

        local function hardKill(character)
            local hum = character and character:FindFirstChildOfClass("Humanoid")
            if not hum then return end
            pcall(function()
                hum.PlatformStand = false
                hum:SetStateEnabled(Enum.HumanoidStateType.Dead, true)
                hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, true)
                hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
                hum.BreakJointsOnDeath = true
                if hum.MaxHealth == math.huge or hum.MaxHealth <= 0 then hum.MaxHealth = 100 end
                hum.Health = 0
            end)
            pcall(function() character:BreakJoints() end)
        end

        local function doReset()
            local character = LP.Character
            local hum = character and character:FindFirstChildOfClass("Humanoid")
            local root = character and character:FindFirstChild("HumanoidRootPart")
            if not (character and hum and root and root:IsA("BasePart")) then
                return
            end
            if state.busy and (os.clock() - (state.busyAt or 0)) < 5 then return end

            state.busy = true
            state.busyAt = os.clock()
            state.token = (state.token or 0) + 1
            local myToken = state.token

            suspendGuards()

            task.spawn(function()
                holdCamera(character)

                if not flingUp(character) then
                    hardKill(character)
                end

                local elapsed = 0
                while LP.Character == character and elapsed < FALLBACK do
                    elapsed = elapsed + task.wait()
                end
                if LP.Character == character then
                    local hum2 = character:FindFirstChildOfClass("Humanoid")
                    if hum2 and hum2.Health > 0 then
                        hardKill(character)
                    end
                end

                local waited = 0
                while LP.Character == character and waited < WAIT_RESPAWN do
                    waited = waited + task.wait()
                end

                if state.token ~= myToken then return end
                state.busy = false
                restoreGuards()
            end)
        end

        RunService.Heartbeat:Connect(function()
            if not state.wantAntiDie then return end
            if state.busy and (os.clock() - (state.busyAt or 0)) < 10 then
                if _antiDieEnabled then pcall(function() _antiDieSetEnabled(false) end) end
                if AntiDieModule and AntiDieModule.enabled then pcall(function() AntiDieModule.stop() end) end
                return
            end
            if (os.clock() - (state.busyAt or 0)) >= 10 then
                state.busy = false
                restoreGuards()
            end
        end)

        LP.CharacterAdded:Connect(function()
            state.cameraHeld = false
            if state.cameraConn then
                pcall(function() state.cameraConn:Disconnect() end)
                state.cameraConn = nil
            end
        end)

        local _lastRequest = 0
        _G.InstaReset = {
            Trigger = function()
                local now = os.clock()
                if now - _lastRequest < 0.15 then return end
                _lastRequest = now
                doReset()
            end,
        }
        _G.VynxDoInstaReset = _G.InstaReset.Trigger
    end
end

function buildGui()
    local ROW_BG = Color3.fromRGB(10, 10, 12)
    local ROW_BORDER = Color3.fromRGB(50, 50, 58)
    local WHITE = Color3.fromRGB(255, 255, 255)
    local INP = Color3.fromRGB(15, 15, 18)
    local GUI_W, GUI_H = 330, 500

    local GUI_NAMES = {"EliteFamily", "EliteFamilyMobilePanel", "TpBatButton", "InstaResetButton",
                       "EliteFamilySpeedIndicator", "EliteFamilyBootErrors",
                       -- cleanup legacy Yout names
                       "Yout", "YoutMobilePanel", "YoutAutoGrabBar", "YoutBootErrors",
                       "YoutESP_Highlight", "YoutESP_Name", "YoutESPLine", "YoutSpeedIndicator"}

    local _okCg, _coreGui = pcall(function() return game:GetService("CoreGui") end)
    local _pgOld = LP:FindFirstChild("PlayerGui")
    for _, n in ipairs(GUI_NAMES) do
        if _okCg and _coreGui then
            local okFind, oldCg = pcall(function() return _coreGui:FindFirstChild(n) end)
            if okFind and oldCg then pcall(function() oldCg:Destroy() end) end
        end
        if _pgOld then
            local okFind2, o = pcall(function() return _pgOld:FindFirstChild(n) end)
            if okFind2 and o then pcall(function() o:Destroy() end) end
        end
    end

    gui = Instance.new("ScreenGui")
    gui.Name = "EliteFamily"
    gui.ResetOnSpawn = false
    gui.DisplayOrder = 10
    gui.IgnoreGuiInset = true
    pcall(function() if syn and syn.protect_gui then syn.protect_gui(gui) end end)
    local guiOk = pcall(function() gui.Parent = game:GetService("CoreGui") end)
    if not guiOk then gui.Parent = LP:WaitForChild("PlayerGui") end
    -- Ocultar menú principal mientras corre la intro (también si se hace SKIP)
    if not _G.EliteFamilyIntroFinished then
        gui.Enabled = false
    end

    main = Instance.new("Frame", gui)
    main.Size = UDim2.new(0, GUI_W, 0, GUI_H)
    main.Position = UDim2.new(0, 20, 0, 8)
    main.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    main.BackgroundTransparency = 0
    main.BorderSizePixel = 0
    main.ClipsDescendants = true
    Instance.new("UICorner", main).CornerRadius = UDim.new(0, 16)
    local mainStroke = Instance.new("UIStroke", main)
    mainStroke.Color = Color3.fromRGB(45, 45, 55)
    mainStroke.Thickness = 1
    mainStroke.Transparency = 0.4

    local scriptHeader = Instance.new("Frame", main)
    scriptHeader.Name = "ScriptHeader"
    scriptHeader.Size = UDim2.new(1, -20, 0, 52)
    scriptHeader.Position = UDim2.new(0, 10, 0, 4)
    scriptHeader.BackgroundTransparency = 1
    scriptHeader.BorderSizePixel = 0
    scriptHeader.ZIndex = 8
    Instance.new("UICorner", scriptHeader).CornerRadius = UDim.new(0, 12)

    local scriptLogo = Instance.new("ImageLabel", scriptHeader)
    scriptLogo.Name = "ScriptLogo"
    scriptLogo.AnchorPoint = Vector2.new(0.5, 0.5)
    scriptLogo.Position = UDim2.new(0.5, 0, 0.5, 0)
    scriptLogo.Size = UDim2.new(1, 0, 1, 0)
    scriptLogo.BackgroundTransparency = 1
    scriptLogo.Image = ""
    scriptLogo.ScaleType = Enum.ScaleType.Crop
    scriptLogo.ZIndex = 9
    scriptLogo.Visible = false

    local titleLabel = Instance.new("TextLabel", scriptHeader)
    titleLabel.Name = "EliteFamilyTitle"
    titleLabel.Size = UDim2.new(1, -40, 1, 0)
    titleLabel.Position = UDim2.new(0, 10, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = "ELITE FAMILY"
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.Font = Enum.Font.GothamBlack
    titleLabel.TextSize = 24
    titleLabel.TextXAlignment = Enum.TextXAlignment.Center
    titleLabel.TextYAlignment = Enum.TextYAlignment.Center
    titleLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    titleLabel.TextStrokeTransparency = 0.45
    titleLabel.ZIndex = 10
    local titleStroke = Instance.new("UIStroke", titleLabel)
    titleStroke.Color = getThemeColor()
    titleStroke.Thickness = 1.2
    titleStroke.Transparency = 0.4

    local bgImage = Instance.new("ImageLabel", main)
    bgImage.Name = "BackgroundImage"
    bgImage.Size = UDim2.new(1, 0, 1, 0)
    bgImage.Position = UDim2.new(0, 0, 0, 0)
    bgImage.BackgroundTransparency = 1
    bgImage.Visible = true
    local _initAid = backgroundImages[backgroundIndex] or backgroundImages[1]
    bgImage.Image = (_initAid and _initAid ~= "") and ("rbxassetid://" .. tostring(_initAid)) or ""
    bgImage.ImageTransparency = 0
    bgImage.ScaleType = Enum.ScaleType.Crop
    bgImage.ZIndex = 1
    bgImage.ClipsDescendants = true
    Instance.new("UICorner", bgImage).CornerRadius = UDim.new(0, 18)
    if backgroundMode ~= "None" and _initAid and _initAid ~= "" then
        main.BackgroundTransparency = 1
    end

    mainUIScale = Instance.new("UIScale", main)
    mainUIScale.Scale = uiScaleValue / 100

    local closeBtn = Instance.new("TextButton", main)
    closeBtn.Size = UDim2.new(0, 32, 0, 32)
    closeBtn.Position = UDim2.new(1, -42, 0, 8)
    closeBtn.BackgroundColor3 = Color3.fromRGB(30,30,35)
    closeBtn.BackgroundTransparency = 1
    closeBtn.BorderSizePixel = 0
    closeBtn.Text = "-"
    closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextSize = 30
    closeBtn.AutoButtonColor = false
    closeBtn.ZIndex = 200

    closeBtn.MouseEnter:Connect(function()
        TS:Create(closeBtn, TweenInfo.new(0.12), {TextColor3 = getThemeColor()}):Play()
    end)
    closeBtn.MouseLeave:Connect(function()
        TS:Create(closeBtn, TweenInfo.new(0.12), {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
    end)

    miniBtn = Instance.new("TextButton", gui)
    miniBtn.Name = "MinimizedFrame"
    miniBtn.Size = UDim2.new(0, 160, 0, 40)
    miniBtn.Position = UDim2.new(0, 18, 0, 60)
    miniBtn.BackgroundColor3 = Color3.fromRGB(12, 12, 16)
    miniBtn.BackgroundTransparency = 0.02
    miniBtn.BorderSizePixel = 0
    miniBtn.Text = "● ELITE FAMILY"
    miniBtn.TextColor3 = Color3.fromRGB(20, 55, 120)
    miniBtn.Font = Enum.Font.GothamBold
    miniBtn.TextSize = 14
    miniBtn.AutoButtonColor = false
    miniBtn.ZIndex = 20
    miniBtn.Visible = false
    Instance.new("UICorner", miniBtn).CornerRadius = UDim.new(0, 16)

    local _mainAnimating = false
    local mainOriginalPos = main.Position
    _G.__EliteFamilyMainOriginalPos = mainOriginalPos
    main:GetPropertyChangedSignal("Position"):Connect(function()
        if not _mainAnimating then
            mainOriginalPos = main.Position
            _G.__EliteFamilyMainOriginalPos = mainOriginalPos
        end
    end)

    local animScale = Instance.new("UIScale", main)
    animScale.Scale = 1
    local _openTween, _closeTween = nil, nil

    showGui = function()
        if not main then return end
        if _openTween then _openTween:Cancel() end
        if _closeTween then _closeTween:Cancel() end
        _mainAnimating = true
        main.Visible = true
        miniBtn.Visible = false
        main.Position = UDim2.new(mainOriginalPos.X.Scale, mainOriginalPos.X.Offset - 60, mainOriginalPos.Y.Scale, mainOriginalPos.Y.Offset)
        animScale.Scale = 0.5
        local info = TweenInfo.new(0.45, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        _openTween = TS:Create(main, info, {Position = mainOriginalPos})
        TS:Create(animScale, TweenInfo.new(0.45, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Scale = 1}):Play()
        _openTween:Play()
        _openTween.Completed:Connect(function()
            _openTween = nil
            _mainAnimating = false
        end)
    end

    hideGui = function()
        if not main or not main.Visible then return end
        if _openTween then _openTween:Cancel() end
        if _closeTween then _closeTween:Cancel() end
        _mainAnimating = true
        local targetPos = UDim2.new(mainOriginalPos.X.Scale, mainOriginalPos.X.Offset - 60, mainOriginalPos.Y.Scale, mainOriginalPos.Y.Offset)
        local info = TweenInfo.new(0.28, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
        _closeTween = TS:Create(main, info, {Position = targetPos})
        TS:Create(animScale, TweenInfo.new(0.28, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Scale = 0.5}):Play()
        _closeTween:Play()
        _closeTween.Completed:Connect(function()
            main.Visible = false
            miniBtn.Visible = true
            _closeTween = nil
            _mainAnimating = false
        end)
    end

    closeBtn.MouseButton1Click:Connect(hideGui)
    miniBtn.MouseButton1Click:Connect(showGui)

    local tabBar = Instance.new("Frame", main)
    tabBar.Name = "TabBar"
    tabBar.Size = UDim2.new(1, -8, 0, 38)
    tabBar.Position = UDim2.new(0, 4, 0, 56)
    tabBar.BackgroundTransparency = 1
    tabBar.ZIndex = 10

    local tabLayout = Instance.new("UIListLayout", tabBar)
    tabLayout.FillDirection = Enum.FillDirection.Horizontal
    tabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    tabLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    tabLayout.Padding = UDim.new(0, 3)

    local tabContent = Instance.new("Frame", main)
    tabContent.Size = UDim2.new(1, 0, 1, -100)
    tabContent.Position = UDim2.new(0, 0, 0, 98)
    tabContent.BackgroundTransparency = 1
    tabContent.ClipsDescendants = true
    tabContent.ZIndex = 5

    local tabs = {"Speed", "Combat", "Visual", "Config", "Keybinds"}
    tabButtons = {}
    local contentPages = {}

    for i, name in ipairs(tabs) do
        local btn = Instance.new("TextButton", tabBar)
        btn.Size = UDim2.new(0, 62, 1, -6)
        btn.BackgroundColor3 = Color3.fromRGB(26, 26, 34)
        btn.BackgroundTransparency = 1
        btn.BorderSizePixel = 0
        btn.Text = name
        btn.TextColor3 = Color3.fromRGB(150, 150, 165)
        btn.Font = Enum.Font.GothamBlack
        btn.TextSize = 13
        btn.AutoButtonColor = false
        btn.ZIndex = 11
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)

        local tabBgGrad = Instance.new("UIGradient", btn)
        tabBgGrad.Name = "TabBgGrad"
        tabBgGrad.Color = eliteGradient(getThemeColor())
        tabBgGrad.Rotation = 0

        local tabStroke = Instance.new("UIStroke", btn)
        tabStroke.Name = "TabStroke"
        tabStroke.Color = getThemeColor()
        tabStroke.Thickness = 1.5
        tabStroke.Transparency = 1

        local underline = Instance.new("Frame", btn)
        underline.Name = "Underline"
        underline.Size = UDim2.new(0, 34, 0, 3)
        underline.Position = UDim2.new(0.5, 0, 1, -3)
        underline.AnchorPoint = Vector2.new(0.5, 0)
        underline.BackgroundColor3 = getThemeColor()
        underline.BorderSizePixel = 0
        underline.Visible = false
        underline.ZIndex = 12
        Instance.new("UICorner", underline).CornerRadius = UDim.new(1, 0)

        local page = Instance.new("ScrollingFrame", tabContent)
        page.Size = UDim2.new(1, 0, 1, 0)
        page.Position = UDim2.new(0, 0, 0, 0)
        page.BackgroundTransparency = 1
        page.BorderSizePixel = 0
        page.ClipsDescendants = true
        page.ScrollBarThickness = 3
        page.ScrollBarImageColor3 = getThemeColor()
        page.ScrollBarImageTransparency = 0.3
        page.CanvasSize = UDim2.new(0, 0, 0, 0)
        page.AutomaticCanvasSize = Enum.AutomaticSize.Y
        page.ScrollingDirection = Enum.ScrollingDirection.Y
        page.ZIndex = 6
        page.Visible = (i == 1)

        local layout = Instance.new("UIListLayout", page)
        layout.SortOrder = Enum.SortOrder.LayoutOrder
        layout.Padding = UDim.new(0, 6)
        layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

        local padding = Instance.new("UIPadding", page)
        padding.PaddingLeft = UDim.new(0, 8)
        padding.PaddingRight = UDim.new(0, 8)
        padding.PaddingTop = UDim.new(0, 6)
        padding.PaddingBottom = UDim.new(0, 20)

        contentPages[name] = page

        btn.MouseButton1Click:Connect(function()
            for _, pg2 in pairs(contentPages) do pg2.Visible = false end
            page.Visible = true
            for _, b in ipairs(tabButtons) do
                local ul = b:FindFirstChild("Underline")
                if ul then ul.Visible = false end
                local bs = b:FindFirstChild("TabStroke")
                TS:Create(b, TweenInfo.new(0.2, Enum.EasingStyle.Quint), {
                    BackgroundTransparency = 1,
                    BackgroundColor3 = Color3.fromRGB(26, 26, 34),
                    TextColor3 = Color3.fromRGB(150, 150, 165)
                }):Play()
                if bs then TS:Create(bs, TweenInfo.new(0.2), {Transparency = 1}):Play() end
            end
            local ul = btn:FindFirstChild("Underline")
            if ul then ul.Visible = true end
            local bs = btn:FindFirstChild("TabStroke")
            TS:Create(btn, TweenInfo.new(0.22, Enum.EasingStyle.Quint), {
                BackgroundTransparency = 0.15,
                BackgroundColor3 = getThemeColor(),
                TextColor3 = Color3.fromRGB(245, 245, 255)
            }):Play()
            if bs then TS:Create(bs, TweenInfo.new(0.22), {Transparency = 0.3}):Play() end
        end)

        btn.MouseEnter:Connect(function()
            if btn:FindFirstChild("Underline") and btn.Underline.Visible then return end
            TS:Create(btn, TweenInfo.new(0.15), {
                BackgroundTransparency = 0.55,
                TextColor3 = Color3.fromRGB(215, 215, 230)
            }):Play()
        end)
        btn.MouseLeave:Connect(function()
            if btn:FindFirstChild("Underline") and btn.Underline.Visible then return end
            TS:Create(btn, TweenInfo.new(0.15), {
                BackgroundTransparency = 1,
                TextColor3 = Color3.fromRGB(150, 150, 165)
            }):Play()
        end)

        table.insert(tabButtons, btn)
    end

    if tabButtons[1] then
        local ul = tabButtons[1]:FindFirstChild("Underline")
        if ul then ul.Visible = true end
        tabButtons[1].BackgroundColor3 = getThemeColor()
        tabButtons[1].BackgroundTransparency = 0.15
        tabButtons[1].TextColor3 = Color3.fromRGB(245, 245, 255)
        local bs = tabButtons[1]:FindFirstChild("TabStroke")
        if bs then bs.Transparency = 0.3 end
    end

    local pageCounters = {}

    local function getNextOrder(page)
        if not pageCounters[page] then pageCounters[page] = 0 end
        pageCounters[page] = pageCounters[page] + 1
        return pageCounters[page]
    end

    local function mkSect(page, txt)
        local f = Instance.new("Frame", page)
        f.Size = UDim2.new(1, 0, 0, 30)
        f.BackgroundTransparency = 1
        f.BorderSizePixel = 0
        f.LayoutOrder = getNextOrder(page)
        f.ZIndex = 7

        local accent = Instance.new("Frame", f)
        accent.Name = "SectAccent"
        accent.Size = UDim2.new(0, 3, 0, 15)
        accent.Position = UDim2.new(0, 5, 0.5, -7)
        accent.AnchorPoint = Vector2.new(0, 0.5)
        accent.BackgroundColor3 = getThemeColor()
        accent.BorderSizePixel = 0
        accent.ZIndex = 8
        Instance.new("UICorner", accent).CornerRadius = UDim.new(1, 0)
        local accentGrad = Instance.new("UIGradient", accent)
        accentGrad.Color = eliteGradient(getThemeColor())
        accentGrad.Rotation = 90

        local l = Instance.new("TextLabel", f)
        l.Size = UDim2.new(0.5, -24, 1, 0)
        l.Position = UDim2.new(0, 14, 0, 0)
        l.BackgroundTransparency = 1
        l.Text = txt:upper()
        l.TextColor3 = Color3.fromRGB(235, 235, 245)
        l.Font = Enum.Font.GothamBlack
        l.TextSize = 11
        l.TextXAlignment = Enum.TextXAlignment.Left
        l.TextStrokeColor3 = Color3.fromRGB(0,0,0)
        l.TextStrokeTransparency = 0.55
        l.ZIndex = 8

        local line = Instance.new("Frame", f)
        line.Name = "SectLine"
        line.Size = UDim2.new(0, 110, 0, 1)
        line.Position = UDim2.new(1, -6, 0.5, 0)
        line.AnchorPoint = Vector2.new(1, 0.5)
        line.BackgroundColor3 = getThemeColor()
        line.BorderSizePixel = 0
        line.ZIndex = 8
        local lineGrad = Instance.new("UIGradient", line)
        lineGrad.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0.00, 0.45),
            NumberSequenceKeypoint.new(1.00, 1.00),
        })

        return f
    end

    local function mkRow(page, h)
        local f = Instance.new("Frame", page)
        f.Size = UDim2.new(1, -10, 0, h or 42)
        f.BackgroundColor3 = ROW_BG
        f.BackgroundTransparency = 0.28
        f.BorderSizePixel = 0
        f.LayoutOrder = getNextOrder(page)
        f.ZIndex = 7
        Instance.new("UICorner", f).CornerRadius = UDim.new(0, 10)
        local st = Instance.new("UIStroke", f)
        st.Color = ROW_BORDER
        st.Thickness = 1
        st.Transparency = 0.55
        return f
    end

    local function mkLabel(row, txt)
        local l = Instance.new("TextLabel", row)
        l.Size = UDim2.new(0.55, 0, 1, 0)
        l.Position = UDim2.new(0, 12, 0, 0)
        l.BackgroundTransparency = 1
        l.Text = txt
        l.TextColor3 = Color3.fromRGB(240, 240, 250)
        l.Font = Enum.Font.GothamBold
        l.TextSize = 14
        l.TextXAlignment = Enum.TextXAlignment.Left
        l.TextTruncate = Enum.TextTruncate.AtEnd
        l.TextStrokeColor3 = Color3.fromRGB(0,0,0)
        l.TextStrokeTransparency = 0.5
        l.ZIndex = 8
        return l
    end

    -- Click sound for toggles (no circle)
    local function playToggleSound(on)
        pcall(function()
            local snd = Instance.new("Sound")
            snd.SoundId = on and "rbxassetid://6895079853" or "rbxassetid://6895079281"
            snd.Volume = 0.55
            snd.PlaybackSpeed = on and 1.05 or 0.92
            snd.Parent = game:GetService("SoundService")
            snd:Play()
            task.delay(1.2, function() pcall(function() snd:Destroy() end) end)
        end)
    end

    -- Rectangular ON/OFF indicator (NO circle/knob)
    local function mkPill(row, offset)
        local pill = Instance.new("TextButton", row)
        pill.Name = "Track"
        pill.Size = UDim2.new(0, 52, 0, 24)
        pill.AnchorPoint = Vector2.new(1, 0.5)
        pill.Position = UDim2.new(1, -14, 0.5, 0)
        pill.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
        pill.BackgroundTransparency = 0.15
        pill.BorderSizePixel = 0
        pill.Text = "OFF"
        pill.TextColor3 = Color3.fromRGB(190, 190, 200)
        pill.Font = Enum.Font.GothamBold
        pill.TextSize = 11
        pill.AutoButtonColor = false
        pill.ZIndex = 9
        Instance.new("UICorner", pill).CornerRadius = UDim.new(0, 6)
        local st = Instance.new("UIStroke", pill)
        st.Name = "TrackStroke"
        st.Color = Color3.fromRGB(90, 90, 105)
        st.Thickness = 1
        st.Transparency = 0.45
        return pill, pill
    end

    local function animPill(pill, _dot, on)
        local st = pill:FindFirstChild("TrackStroke")
        local fadeInfo = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        TS:Create(pill, fadeInfo, {
            BackgroundColor3 = on and getThemeColor() or Color3.fromRGB(45, 45, 55),
            BackgroundTransparency = on and 0 or 0.15,
        }):Play()
        if st then
            TS:Create(st, fadeInfo, {
                Color = on and getThemeColor() or Color3.fromRGB(90, 90, 105),
                Transparency = on and 0.15 or 0.45,
            }):Play()
        end
        pill.Text = on and "ON" or "OFF"
        -- Contraste de texto
        local theme = getThemeColor()
        local lum = theme.R * 0.299 + theme.G * 0.587 + theme.B * 0.114
        if on then
            pill.TextColor3 = (lum > 0.72) and Color3.fromRGB(20, 20, 28) or Color3.fromRGB(255, 255, 255)
        else
            pill.TextColor3 = Color3.fromRGB(190, 190, 200)
        end
    end

    local function mkToggle(page, txt, cb)
        local row = mkRow(page, 42)
        mkLabel(row, txt)
        local pill, dot = mkPill(row, 62)
        local on = false
        local function sv(s)
            on = s
            animPill(pill, dot, s)
        end
        pill.MouseButton1Click:Connect(function()
            on = not on
            sv(on)
            playToggleSound(on)
            pcall(cb, on)
            task.defer(function() pcall(saveAllSettings) end)
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
        leftBtn.Font = Enum.Font.GothamBold
        leftBtn.TextSize = 13
        leftBtn.AutoButtonColor = false
        leftBtn.ZIndex = 9
        Instance.new("UICorner", leftBtn).CornerRadius = UDim.new(0, 6)
        local label = Instance.new("TextLabel", container)
        label.Size = UDim2.new(0, 80, 0, 26)
        label.Position = UDim2.new(0.5, -40, 0.5, -13)
        label.BackgroundTransparency = 1
        label.Text = default
        label.TextColor3 = WHITE
        label.Font = Enum.Font.GothamBold
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
        rightBtn.Font = Enum.Font.GothamBold
        rightBtn.TextSize = 13
        rightBtn.AutoButtonColor = false
        rightBtn.ZIndex = 9
        Instance.new("UICorner", rightBtn).CornerRadius = UDim.new(0, 6)
        local function updateLabel(newText) label.Text = newText end
        leftBtn.MouseButton1Click:Connect(function()
            if cb then cb(-1, updateLabel); task.defer(function() pcall(saveAllSettings) end) end
        end)
        rightBtn.MouseButton1Click:Connect(function()
            if cb then cb(1, updateLabel); task.defer(function() pcall(saveAllSettings) end) end
        end)
        return label
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
        tb.Focused:Connect(function() TS:Create(bs, TweenInfo.new(0.12), {Color = getThemeColor(), Transparency = 0}):Play() end)
        tb.FocusLost:Connect(function()
            TS:Create(bs, TweenInfo.new(0.12), {Color = ROW_BORDER, Transparency = 0.25}):Play()
            if cb then
                local n = tonumber(tb.Text)
                if n then cb(n) else tb.Text = tostring(default) end
                task.defer(function() saveAllSettings() end)
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
        local function getLabel() return (kbEntry.gp and kbEntry.gp.Name) or (kbEntry.kb and kbEntry.kb.Name) or "None" end
        btn.Text = getLabel()
        btn.TextColor3 = WHITE
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 9
        btn.ZIndex = 8
        btn.AutoButtonColor = false
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
        local bs = Instance.new("UIStroke", btn)
        bs.Color = ROW_BORDER
        bs.Thickness = 1
        local li = false; local lc; local pv = btn.Text; local listenStart = 0
        btn.Activated:Connect(function()
            if li then li = false; _anyKeyListening = false; if lc then lc:Disconnect(); lc = nil end; btn.Text = pv; btn.TextColor3 = WHITE; return end
            pv = btn.Text; li = true; _anyKeyListening = true; listenStart = _tick(); btn.Text = "..."; btn.TextColor3 = WHITE
            lc = UIS.InputBegan:Connect(function(inp)
                if not li then return end
                if inp.KeyCode == Enum.KeyCode.Escape then li = false; _anyKeyListening = false; if lc then lc:Disconnect(); lc = nil end; btn.Text = pv; btn.TextColor3 = WHITE; return end
                local isGp = isGamepadInput(inp)
                if isGp and _tick()-listenStart < 0.15 then return end
                if not isBindableInput(inp) then return end
                btn.Text = inp.KeyCode.Name; pv = inp.KeyCode.Name; btn.TextColor3 = WHITE
                li = false; _anyKeyListening = false; if lc then lc:Disconnect(); lc = nil end
                if isGp then kbEntry.gp = inp.KeyCode; kbEntry.kb = nil else kbEntry.kb = inp.KeyCode; kbEntry.gp = nil end
                task.defer(function() saveAllSettings() end)
            end)
        end)
        table.insert(keyButtonRefs, {btn = btn, entry = kbEntry})
        return btn
    end

    local function addKeybindRow(page, labelText, kbEntry)
        local row = mkRow(page, 40)
        mkLabel(row, labelText)
        mkKeyButton(row, kbEntry)
    end

    local speedPage = contentPages["Speed"]

    mkSect(speedPage, "Movement Speeds")
    do local row = mkRow(speedPage, 42); mkLabel(row, "Normal Speed"); normalBox = mkBox(row, NS, 50, 56, function(v) if v > 0 and v <= 500 then NS = v; if _G.__EliteFamilyApplySpeedNow then pcall(_G.__EliteFamilyApplySpeedNow) end end end) end
    do local row = mkRow(speedPage, 42); mkLabel(row, "Carry Speed"); carryBox = mkBox(row, CS, 50, 56, function(v) if v > 0 and v <= 500 then CS = v; if _G.__EliteFamilyApplySpeedNow then pcall(_G.__EliteFamilyApplySpeedNow) end end end) end
    do local row = mkRow(speedPage, 42); mkLabel(row, "Lagger Normal Speed"); laggerBox = mkBox(row, LAGGER_SPEED, 50, 56, function(v) if v > 0 and v <= 500 then LAGGER_SPEED = v; if _G.__EliteFamilyApplySpeedNow then pcall(_G.__EliteFamilyApplySpeedNow) end end end) end
    do local row = mkRow(speedPage, 42); mkLabel(row, "Lagger Carry Speed"); lagger2Box = mkBox(row, LAGGER_CARRY_SPEED, 50, 56, function(v) if v > 0 and v <= 500 then LAGGER_CARRY_SPEED = v; if _G.__EliteFamilyApplySpeedNow then pcall(_G.__EliteFamilyApplySpeedNow) end end end) end

    mkSect(speedPage, "Active Mode")
    do
        local row = mkRow(speedPage, 42)
        mkLabel(row, "Current Mode")
        modeValLbl = Instance.new("TextLabel", row)
        modeValLbl.Size = UDim2.new(0, 110, 1, 0)
        modeValLbl.Position = UDim2.new(1, -118, 0, 0)
        modeValLbl.BackgroundTransparency = 1
        modeValLbl.Text = "Normal"
        modeValLbl.TextColor3 = WHITE
        modeValLbl.Font = Enum.Font.GothamBold
        modeValLbl.TextSize = 12
        modeValLbl.TextXAlignment = Enum.TextXAlignment.Right
        modeValLbl.ZIndex = 8
        local clk = Instance.new("TextButton", row)
        clk.Size = UDim2.new(1,0,1,0)
        clk.BackgroundTransparency = 1
        clk.Text = ""
        clk.AutoButtonColor = false
        clk.ZIndex = 8
        clk.MouseButton1Click:Connect(function() toggleCarryMode() end)
    end

    mkSect(speedPage, "Auto Movement")
    autoLeftSetVisual = mkToggle(speedPage, "Auto Left", function(on)
        autoLeftEnabled = on
        if on then startAutoLeft() else stopAutoLeft() end
        if mobSetAutoLeft then mobSetAutoLeft(on) end
    end)
    autoRightSetVisual = mkToggle(speedPage, "Auto Right", function(on)
        autoRightEnabled = on
        if on then startAutoRight() else stopAutoRight() end
        if mobSetAutoRight then mobSetAutoRight(on) end
    end)

    local combatPage = contentPages["Combat"]

    mkSect(combatPage, "Defense")
    setAntiBatVisual = mkToggle(combatPage, "Anti Bat", function(on)
        if on then startAntiBat() else stopAntiBat() end
    end)
    setAntiFlingVisual = mkToggle(combatPage, "Anti Fling", function(on)
        antiFlingEnabled = on
        if on then startAntiFling() else stopAntiFling() end
        saveAllSettings()
    end)
    if setAntiFlingVisual then setAntiFlingVisual(antiFlingEnabled) end
    setAntiRagVisual = mkToggle(combatPage, "Anti Ragdoll", function(on)
        if on then startAntiRagdollV2(); antiRagdollMode = "v2" else stopAntiRagdollV2(); antiRagdollMode = "off" end
        saveAllSettings()
    end)
    if setAntiRagVisual then setAntiRagVisual(antiRagdollMode == "v2") end

    setAntiDieVisual = mkToggle(combatPage, "Anti Die", function(on)
        antiDieEnabled = on
        if on then AntiDieModule.start() else AntiDieModule.stop() end
        saveAllSettings()
    end)
    if setAntiDieVisual then setAntiDieVisual(antiDieEnabled) end

    setUnwalkVisual = mkToggle(combatPage, "Unwalk", function(on)
        unwalkEnabled = on
        if on then startUnwalk() else stopUnwalk() end
    end)

    mkSect(combatPage, "Attack")
    autoBatSetVisual = mkToggle(combatPage, "Auto Bat", function(on)
        if on then enableAutoBat() else disableAutoBat() end
        if mobSetAutoBat then mobSetAutoBat(on) end
    end)
    do local row = mkRow(combatPage, 42); mkLabel(row, "Bat Aimbot Speed"); batSpeedBox = mkBox(row, BAT_AIMBOT_SPEED, 50, 56, function(v) if v > 0 and v <= 200 then BAT_AIMBOT_SPEED = v end end) end
    batDesyncTpSetVisual = mkToggle(combatPage, "TP BAT", function(on)
        if on then if not batDesyncTpEnabled then toggleBatDesyncTp() end else if batDesyncTpEnabled then toggleBatDesyncTp() end end
    end)
    if batDesyncTpSetVisual then batDesyncTpSetVisual(batDesyncTpEnabled) end
    autoBatV2SetVisual = mkToggle(combatPage, "Bat V2", function(on)
        if on then
            if not autoBatV2Enabled then enableBatV2() end
        else
            if autoBatV2Enabled then disableBatV2() end
        end
    end)
    if autoBatV2SetVisual then autoBatV2SetVisual(autoBatV2Enabled) end

    mkSect(combatPage, "Targeting")
    bodyLockSetVisual = mkToggle(combatPage, "Lock Enemy", function(on)
        bodyLockEnabled = on
        if on then
            if _blSuppressCount == 0 then startBodyLock() end
        else
            stopBodyLock()
        end
    end)
    do
        local row = mkRow(combatPage, 42)
        mkLabel(row, "Lock Enemy Range")
        bodyLockRangeBox = mkBox(row, bodyLockRange, 50, 56, function(v)
            if v and v > 0 then
                bodyLockRange = _clamp(_floor(v), 5, 200)
                if bodyLockRangeBox then bodyLockRangeBox.Text = tostring(bodyLockRange) end
            end
        end)
    end

    mkSect(combatPage, "Counters")
    setBatCounterVisual = mkToggle(combatPage, "Bat Counter", function(on)
        batCounterEnabled = on
        if on then startBatCounter() else stopBatCounter() end
    end)
    setBatCounterV2Visual = mkToggle(combatPage, "Bat Counter V2", function(on)
        batCounterV2Enabled = on
        if on then startBatCounterV2() else stopBatCounterV2() end
    end)
    setMedusaVisual = mkToggle(combatPage, "Medusa Counter", function(on)
        medusaCounterEnabled = on
        if on then
            if LP.Character then setupMedusaCounter(LP.Character) else stopMedusaCounter() end
        else
            stopMedusaCounter()
        end
        if setMedusaVisual then setMedusaVisual(on) end
    end)

    mkSect(combatPage, "Drop")
    dropBrainrotSetVisual = mkToggle(combatPage, "Drop Brainrot", function(on)
        if on then
            executeDropWithToggle(function(v)
                dropBrainrotSetVisual(v)
                if mobSetDropBR then mobSetDropBR(v) end
            end)
        end
    end)
    setDropVisual = dropBrainrotSetVisual
    do
        local row = mkRow(combatPage, 42)
        mkLabel(row, "Drop Mode")
        dropModeBtnRef = mkSelector(row, dropMode == 1 and "Fling" or "Jump Drop", {"Fling", "Jump Drop"}, function(dir, update)
            if dropActive then stopDropBrainrot() end
            dropMode = dropMode == 1 and 2 or 1
            update(dropMode == 1 and "Fling" or "Jump Drop")
        end)
    end

    local visualPage = contentPages["Visual"]

    mkSect(visualPage, "Interface")
    do
        local row = mkRow(visualPage, 42)
        mkLabel(row, "Background")
        local options = {"None"}
        for i = 1, #backgroundImages do
            options[#options + 1] = "Background " .. tostring(i)
        end
        backgroundSelectorLabel = mkSelector(row, backgroundMode, options, function(direction, updateLabel)
            local current = 1
            for i, name in ipairs(options) do
                if name == backgroundMode then current = i; break end
            end
            local nextIndex = current + direction
            if nextIndex < 1 then nextIndex = #options end
            if nextIndex > #options then nextIndex = 1 end
            applyBackgroundMode(options[nextIndex])
            updateLabel(backgroundMode)
            saveAllSettings()
        end)
        applyBackgroundMode(backgroundMode)
    end
    do
        local row = mkRow(visualPage, 42)
        mkLabel(row, "Theme Color")
        local options = COLOR_THEME_ORDER
        colorSelectorLabel = mkSelector(row, currentColorTheme, options, function(direction, updateLabel)
            local current = 1
            for i, name in ipairs(options) do
                if name == currentColorTheme then current = i; break end
            end
            local nextIndex = current + direction
            if nextIndex < 1 then nextIndex = #options end
            if nextIndex > #options then nextIndex = 1 end
            applyColorTheme(options[nextIndex])
            updateLabel(currentColorTheme)
            if colorSelectorLabel then
                colorSelectorLabel.TextColor3 = selectedColor
            end
            saveAllSettings()
        end)
        if colorSelectorLabel then
            colorSelectorLabel.Text = currentColorTheme
            colorSelectorLabel.TextColor3 = selectedColor
        end
    end

    mkSect(visualPage, "Buttons")
    do
        local row = mkRow(visualPage, 42)
        mkLabel(row, "Button Image")
        local options = {"None"}
        for i = 1, #buttonBgImages do
            options[#options + 1] = "Background " .. tostring(i)
        end
        buttonBgSelectorLabel = mkSelector(row, buttonBgMode, options, function(direction, updateLabel)
            local current = 1
            for i, name in ipairs(options) do
                if name == buttonBgMode then current = i; break end
            end
            local nextIndex = current + direction
            if nextIndex < 1 then nextIndex = #options end
            if nextIndex > #options then nextIndex = 1 end
            applyButtonBackgroundMode(options[nextIndex])
            updateLabel(buttonBgMode)
            saveAllSettings()
        end)
        applyButtonBackgroundMode(buttonBgMode)
    end
    setLockUIVisual = mkToggle(visualPage, "Lock UI", function(on) toggleLockUI(on) end)
    setHideButtonsVisual = mkToggle(visualPage, "Hide Button", function(on) toggleHideButtons(on) end)
    if setHideButtonsVisual then setHideButtonsVisual(hideButtonsEnabled) end

    mkSect(visualPage, "Display")
    do
        local row = mkRow(visualPage, 42)
        mkLabel(row, "UI Scale")
        uiScaleBox = mkBox(row, uiScaleValue, 50, 56, function(v)
            local n = _clamp(_floor(v+0.5), 50, 150)
            uiScaleValue = n
            if mainUIScale then mainUIScale.Scale = n/100 end
            if pbScale then pbScale.Scale = n/100 end
        end)
    end
    do
        local row = mkRow(visualPage, 42)
        mkLabel(row, "Button Scale")
        local box = mkBox(row, _floor(floatingButtonScale * 100), 50, 56, function(v)
            local val = _clamp(v, 50, 200)
            floatingButtonScale = val / 100
            applyFloatingButtonScale()
            saveAllSettings()
        end)
    end

    mkSect(visualPage, "Character")
    do
        local row = mkRow(visualPage, 42)
        mkLabel(row, "Anim Pack")
        local currentIndex = 1
        for i, entry in ipairs(ANIM_PACK_ORDER) do
            if entry[2] == currentAnimPack then currentIndex = i; break end
        end
        local container = Instance.new("Frame", row)
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
        leftBtn.Font = Enum.Font.GothamBold
        leftBtn.TextSize = 13
        leftBtn.AutoButtonColor = false
        leftBtn.ZIndex = 9
        Instance.new("UICorner", leftBtn).CornerRadius = UDim.new(0, 6)
        animSelectorLabel = Instance.new("TextLabel", container)
        animSelectorLabel.Size = UDim2.new(0, 80, 0, 26)
        animSelectorLabel.Position = UDim2.new(0.5, -40, 0.5, -13)
        animSelectorLabel.BackgroundTransparency = 1
        animSelectorLabel.Text = ANIM_PACK_ORDER[currentIndex][2]
        animSelectorLabel.TextColor3 = WHITE
        animSelectorLabel.Font = Enum.Font.GothamBold
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
        rightBtn.Font = Enum.Font.GothamBold
        rightBtn.TextSize = 13
        rightBtn.AutoButtonColor = false
        rightBtn.ZIndex = 9
        Instance.new("UICorner", rightBtn).CornerRadius = UDim.new(0, 6)
        local function updateAnimSelector(direction)
            local idx = 1
            for i, entry in ipairs(ANIM_PACK_ORDER) do
                if entry[2] == currentAnimPack then idx = i; break end
            end
            local newIdx = idx + direction
            if newIdx < 1 then newIdx = #ANIM_PACK_ORDER end
            if newIdx > #ANIM_PACK_ORDER then newIdx = 1 end
            local packName = ANIM_PACK_ORDER[newIdx][2]
            if packName == "Off" then stopAnimPack() else startAnimPack(packName) end
        end
        leftBtn.MouseButton1Click:Connect(function() updateAnimSelector(-1) end)
        rightBtn.MouseButton1Click:Connect(function() updateAnimSelector(1) end)
    end
    do
        local row = mkRow(visualPage, 42)
        mkLabel(row, "Outfit")
        local container = Instance.new("Frame", row)
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
        leftBtn.Font = Enum.Font.GothamBold
        leftBtn.TextSize = 13
        leftBtn.AutoButtonColor = false
        leftBtn.ZIndex = 9
        Instance.new("UICorner", leftBtn).CornerRadius = UDim.new(0, 6)
        outfitSelectorLabel = Instance.new("TextLabel", container)
        outfitSelectorLabel.Size = UDim2.new(0, 80, 0, 26)
        outfitSelectorLabel.Position = UDim2.new(0.5, -40, 0.5, -13)
        outfitSelectorLabel.BackgroundTransparency = 1
        outfitSelectorLabel.Text = OUTFITS[currentOutfitIndex].label
        outfitSelectorLabel.TextColor3 = WHITE
        outfitSelectorLabel.Font = Enum.Font.GothamBold
        outfitSelectorLabel.TextSize = 12
        outfitSelectorLabel.TextXAlignment = Enum.TextXAlignment.Center
        outfitSelectorLabel.ZIndex = 9
        local rightBtn = Instance.new("TextButton", container)
        rightBtn.Size = UDim2.new(0, 28, 0, 26)
        rightBtn.Position = UDim2.new(1, -28, 0.5, -13)
        rightBtn.BackgroundColor3 = INP
        rightBtn.BackgroundTransparency = 0.7
        rightBtn.BorderSizePixel = 0
        rightBtn.Text = ">"
        rightBtn.TextColor3 = WHITE
        rightBtn.Font = Enum.Font.GothamBold
        rightBtn.TextSize = 13
        rightBtn.AutoButtonColor = false
        rightBtn.ZIndex = 9
        Instance.new("UICorner", rightBtn).CornerRadius = UDim.new(0, 6)
        local function updateOutfit(direction)
            local newIdx = currentOutfitIndex + direction
            if newIdx < 1 then newIdx = #OUTFITS end
            if newIdx > #OUTFITS then newIdx = 1 end
            currentOutfitIndex = newIdx
            pcall(function() applyOutfitByIndex(currentOutfitIndex) end)
            if outfitSelectorLabel then outfitSelectorLabel.Text = OUTFITS[currentOutfitIndex].label end
            saveAllSettings()
        end
        leftBtn.MouseButton1Click:Connect(function() updateOutfit(-1) end)
        rightBtn.MouseButton1Click:Connect(function() updateOutfit(1) end)
    end

    mkSect(visualPage, "Bat Skins")
    local batSkinToggle = mkToggle(visualPage, "Katana Bat", function(on)
        katanaSkinEnabled = on
        if on then
            pcall(function() katanaSkinController.ApplySkin("KATANA") end)
        else
            pcall(function() katanaSkinController.ApplySkin("NONE") end)
        end
        saveAllSettings()
    end)
    if batSkinToggle then batSkinToggle(katanaSkinEnabled) end

    MinecraftBatSetVisual = mkToggle(visualPage, "Minecraft Bat", function(on)
        minecraftBatSkinEnabled = on
        minecraftBatSkinController.State.enabled = on
        if on then pcall(minecraftBatSkinController.Apply) else pcall(minecraftBatSkinController.Remove) end
        saveAllSettings()
    end)
    if MinecraftBatSetVisual then MinecraftBatSetVisual(minecraftBatSkinEnabled) end

    do
        local row = mkRow(visualPage, 42)
        mkLabel(row, "MC Bat Color")
        local colorOptions = {"Default", "Abyss Blue", "Venom Green", "Royal Gold", "Velvet Rose", "Crimson Night", "RGB"}
        MinecraftBatColorSelector = mkSelector(row, minecraftBatSkinColorMode, colorOptions, function(direction, updateLabel)
            local current = 1
            for i, option in ipairs(colorOptions) do
                if option == minecraftBatSkinColorMode then current = i; break end
            end
            local nextIndex = current + direction
            if nextIndex < 1 then nextIndex = #colorOptions end
            if nextIndex > #colorOptions then nextIndex = 1 end
            minecraftBatSkinColorMode = colorOptions[nextIndex]
            updateLabel(minecraftBatSkinColorMode)
            minecraftBatSkinController.SetColorMode(minecraftBatSkinColorMode)
            saveAllSettings()
        end)
    end

    mkSect(visualPage, "Effects")
    setVividVisual = mkToggle(visualPage, "Vivid Graphics", function(on)
        toggleVividGraphics(on)
        if setVividVisual then setVividVisual(on) end
    end)
    if setVividVisual then setVividVisual(vividGraphicsEnabled) end
    do
        local row = mkRow(visualPage, 42)
        mkLabel(row, "Stretch Rez")
        local stretchPill, stretchDot = mkPill(row, 48)
        local stretchOn = false
        local function setStretch(s)
            stretchOn = s
            animPill(stretchPill, stretchDot, s)
            if s then enableStretch() else disableStretch() end
            stretchEnabled = s
        end
        local stretchClk = Instance.new("TextButton", stretchPill)
        stretchClk.Size = UDim2.new(1,0,1,0)
        stretchClk.BackgroundTransparency = 1
        stretchClk.Text = ""
        stretchClk.AutoButtonColor = false
        stretchClk.ZIndex = 10
        stretchClk.MouseButton1Click:Connect(function() setStretch(not stretchOn) end)
        _G.stretchToggleSetter = setStretch
    end
    setAntiLagVisual = mkToggle(visualPage, "Anti Lag", function(on)
        if on then enableAntiLag() else disableAntiLag() end
    end)
    setCustomSoundsVisual = mkToggle(visualPage, "Custom Sounds", function(on)
        if _G.EliteFamilyCustomSounds then
            _G.EliteFamilyCustomSounds.setEnabled(on)
        else
            customSoundsEnabled = on
        end
    end)
    if setCustomSoundsVisual then setCustomSoundsVisual(customSoundsEnabled == true) end

    -- ===================== MUSIC PLAYER =====================
    mkSect(visualPage, "Music")
    do
        local songLabel
        local statusLabel
        local volLabel
        local spdLabel

        local function fmtTime(sec)
            sec = math.max(0, math.floor(tonumber(sec) or 0))
            local m = math.floor(sec / 60)
            local s = sec % 60
            return string.format("%d:%02d", m, s)
        end

        local function refreshMusicUI()
            if songLabel then
                local n = getMusicSongName and getMusicSongName() or "No Song"
                local idx = tonumber(selectedMusicSong) or 1
                local total = ELITE_MUSIC_OPTIONS and #ELITE_MUSIC_OPTIONS or 0
                songLabel.Text = string.format("%d/%d  %s", idx, total, n)
            end
            if statusLabel then
                local sound = _musicPlayerSound
                if sound and sound.Parent then
                    local pos = sound.TimePosition or 0
                    local len = sound.TimeLength or 0
                    local state = sound.IsPlaying and "PLAYING" or "PAUSED"
                    statusLabel.Text = state .. "  " .. fmtTime(pos) .. " / " .. fmtTime(len)
                else
                    statusLabel.Text = "STOPPED"
                end
            end
            if volLabel then
                volLabel.Text = string.format("Vol %.0f%%", (tonumber(musicPlayerVolume) or 1) * 100)
            end
            if spdLabel then
                spdLabel.Text = string.format("Spd %.1fx", tonumber(musicPlayerSpeed) or 1)
            end
        end
        _G.EliteMusicRefreshUI = refreshMusicUI

        -- Song selector row
        do
            local row = mkRow(visualPage, 42)
            mkLabel(row, "Song")
            local container = Instance.new("Frame", row)
            container.Size = UDim2.new(0, 210, 1, 0)
            container.Position = UDim2.new(1, -218, 0, 0)
            container.BackgroundTransparency = 1
            container.ZIndex = 8

            local prev = Instance.new("TextButton", container)
            prev.Size = UDim2.new(0, 28, 0, 28)
            prev.Position = UDim2.new(0, 0, 0.5, -14)
            prev.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
            prev.Text = "<"
            prev.TextColor3 = Color3.fromRGB(230, 230, 240)
            prev.Font = Enum.Font.GothamBold
            prev.TextSize = 14
            prev.BorderSizePixel = 0
            prev.ZIndex = 9
            Instance.new("UICorner", prev).CornerRadius = UDim.new(0, 6)

            songLabel = Instance.new("TextLabel", container)
            songLabel.Size = UDim2.new(1, -64, 1, 0)
            songLabel.Position = UDim2.new(0, 32, 0, 0)
            songLabel.BackgroundTransparency = 1
            songLabel.TextColor3 = Color3.fromRGB(220, 220, 230)
            songLabel.Font = Enum.Font.GothamBold
            songLabel.TextSize = 11
            songLabel.TextTruncate = Enum.TextTruncate.AtEnd
            songLabel.ZIndex = 9

            local nxt = Instance.new("TextButton", container)
            nxt.Size = UDim2.new(0, 28, 0, 28)
            nxt.Position = UDim2.new(1, -28, 0.5, -14)
            nxt.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
            nxt.Text = ">"
            nxt.TextColor3 = Color3.fromRGB(230, 230, 240)
            nxt.Font = Enum.Font.GothamBold
            nxt.TextSize = 14
            nxt.BorderSizePixel = 0
            nxt.ZIndex = 9
            Instance.new("UICorner", nxt).CornerRadius = UDim.new(0, 6)

            prev.MouseButton1Click:Connect(function()
                if musicPrevSong then musicPrevSong() else
                    selectedMusicSong = math.max(1, (selectedMusicSong or 1) - 1)
                    if playMusicSong then playMusicSong(selectedMusicSong) end
                end
                refreshMusicUI()
            end)
            nxt.MouseButton1Click:Connect(function()
                if musicNextSong then musicNextSong() else
                    selectedMusicSong = (selectedMusicSong or 1) + 1
                    if playMusicSong then playMusicSong(selectedMusicSong) end
                end
                refreshMusicUI()
            end)
        end

        -- Status
        do
            local row = mkRow(visualPage, 36)
            statusLabel = Instance.new("TextLabel", row)
            statusLabel.Size = UDim2.new(1, -16, 1, 0)
            statusLabel.Position = UDim2.new(0, 8, 0, 0)
            statusLabel.BackgroundTransparency = 1
            statusLabel.TextColor3 = Color3.fromRGB(160, 160, 175)
            statusLabel.Font = Enum.Font.Gotham
            statusLabel.TextSize = 11
            statusLabel.TextXAlignment = Enum.TextXAlignment.Left
            statusLabel.ZIndex = 8
        end

        -- Controls: Play / Stop / -10s / +10s
        do
            local row = mkRow(visualPage, 42)
            mkLabel(row, "Controls")
            local container = Instance.new("Frame", row)
            container.Size = UDim2.new(0, 210, 1, 0)
            container.Position = UDim2.new(1, -218, 0, 0)
            container.BackgroundTransparency = 1
            container.ZIndex = 8

            local function mkBtn(text, x, w, cb)
                local b = Instance.new("TextButton", container)
                b.Size = UDim2.new(0, w, 0, 28)
                b.Position = UDim2.new(0, x, 0.5, -14)
                b.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
                b.Text = text
                b.TextColor3 = Color3.fromRGB(230, 230, 240)
                b.Font = Enum.Font.GothamBold
                b.TextSize = 10
                b.BorderSizePixel = 0
                b.ZIndex = 9
                Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
                b.MouseButton1Click:Connect(function() pcall(cb); refreshMusicUI() end)
                return b
            end
            mkBtn("PLAY", 0, 48, function()
                if toggleMusicPause then toggleMusicPause() elseif playMusicSong then playMusicSong(selectedMusicSong) end
            end)
            mkBtn("STOP", 52, 48, function()
                if stopMusicPlayback then stopMusicPlayback(true) end
            end)
            mkBtn("-10s", 104, 48, function()
                if musicSeek then musicSeek(-10) end
            end)
            mkBtn("+10s", 156, 48, function()
                if musicSeek then musicSeek(10) end
            end)
        end

        -- Volume
        do
            local row = mkRow(visualPage, 42)
            mkLabel(row, "Volume")
            local container = Instance.new("Frame", row)
            container.Size = UDim2.new(0, 160, 1, 0)
            container.Position = UDim2.new(1, -168, 0, 0)
            container.BackgroundTransparency = 1
            container.ZIndex = 8
            local minus = Instance.new("TextButton", container)
            minus.Size = UDim2.new(0, 28, 0, 28)
            minus.Position = UDim2.new(0, 0, 0.5, -14)
            minus.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
            minus.Text = "-"
            minus.TextColor3 = Color3.fromRGB(230, 230, 240)
            minus.Font = Enum.Font.GothamBold
            minus.TextSize = 14
            minus.BorderSizePixel = 0
            Instance.new("UICorner", minus).CornerRadius = UDim.new(0, 6)
            volLabel = Instance.new("TextLabel", container)
            volLabel.Size = UDim2.new(1, -64, 1, 0)
            volLabel.Position = UDim2.new(0, 32, 0, 0)
            volLabel.BackgroundTransparency = 1
            volLabel.TextColor3 = Color3.fromRGB(220, 220, 230)
            volLabel.Font = Enum.Font.GothamBold
            volLabel.TextSize = 12
            local plus = Instance.new("TextButton", container)
            plus.Size = UDim2.new(0, 28, 0, 28)
            plus.Position = UDim2.new(1, -28, 0.5, -14)
            plus.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
            plus.Text = "+"
            plus.TextColor3 = Color3.fromRGB(230, 230, 240)
            plus.Font = Enum.Font.GothamBold
            plus.TextSize = 14
            plus.BorderSizePixel = 0
            Instance.new("UICorner", plus).CornerRadius = UDim.new(0, 6)
            minus.MouseButton1Click:Connect(function()
                if setMusicVolume then setMusicVolume((musicPlayerVolume or 1) - 0.1) end
                refreshMusicUI()
            end)
            plus.MouseButton1Click:Connect(function()
                if setMusicVolume then setMusicVolume((musicPlayerVolume or 1) + 0.1) end
                refreshMusicUI()
            end)
        end

        -- Speed
        do
            local row = mkRow(visualPage, 42)
            mkLabel(row, "Speed")
            local container = Instance.new("Frame", row)
            container.Size = UDim2.new(0, 160, 1, 0)
            container.Position = UDim2.new(1, -168, 0, 0)
            container.BackgroundTransparency = 1
            container.ZIndex = 8
            local minus = Instance.new("TextButton", container)
            minus.Size = UDim2.new(0, 28, 0, 28)
            minus.Position = UDim2.new(0, 0, 0.5, -14)
            minus.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
            minus.Text = "-"
            minus.TextColor3 = Color3.fromRGB(230, 230, 240)
            minus.Font = Enum.Font.GothamBold
            minus.TextSize = 14
            minus.BorderSizePixel = 0
            Instance.new("UICorner", minus).CornerRadius = UDim.new(0, 6)
            spdLabel = Instance.new("TextLabel", container)
            spdLabel.Size = UDim2.new(1, -64, 1, 0)
            spdLabel.Position = UDim2.new(0, 32, 0, 0)
            spdLabel.BackgroundTransparency = 1
            spdLabel.TextColor3 = Color3.fromRGB(220, 220, 230)
            spdLabel.Font = Enum.Font.GothamBold
            spdLabel.TextSize = 12
            local plus = Instance.new("TextButton", container)
            plus.Size = UDim2.new(0, 28, 0, 28)
            plus.Position = UDim2.new(1, -28, 0.5, -14)
            plus.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
            plus.Text = "+"
            plus.TextColor3 = Color3.fromRGB(230, 230, 240)
            plus.Font = Enum.Font.GothamBold
            plus.TextSize = 14
            plus.BorderSizePixel = 0
            Instance.new("UICorner", plus).CornerRadius = UDim.new(0, 6)
            minus.MouseButton1Click:Connect(function()
                if setMusicSpeed then setMusicSpeed((musicPlayerSpeed or 1) - 0.1) end
                refreshMusicUI()
            end)
            plus.MouseButton1Click:Connect(function()
                if setMusicSpeed then setMusicSpeed((musicPlayerSpeed or 1) + 0.1) end
                refreshMusicUI()
            end)
        end

        -- Loop / Shuffle / Auto Next
        local function modeToggle(label, get, set)
            return mkToggle(visualPage, label, function(on)
                set(on)
                pcall(function() if saveAllSettings then saveAllSettings() end end)
                refreshMusicUI()
            end)
        end
        local setLoopVis = modeToggle("Loop", function() return musicLoopEnabled end, function(on) musicLoopEnabled = on end)
        local setShufVis = modeToggle("Shuffle", function() return musicShuffleEnabled end, function(on) musicShuffleEnabled = on end)
        local setAutoVis = modeToggle("Auto Next", function() return musicAutoPlayNext end, function(on) musicAutoPlayNext = on end)
        if setLoopVis then setLoopVis(musicLoopEnabled == true) end
        if setShufVis then setShufVis(musicShuffleEnabled == true) end
        if setAutoVis then setAutoVis(musicAutoPlayNext == true) end

        -- live status ticker
        task.spawn(function()
            while true do
                task.wait(0.5)
                if _G.EliteMusicRefreshUI then pcall(_G.EliteMusicRefreshUI) end
            end
        end)

        refreshMusicUI()
    end
    do
        local row = mkRow(visualPage, 42)
        mkLabel(row, "Sky Theme")
        local container = Instance.new("Frame", row)
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
        leftBtn.Font = Enum.Font.GothamBold
        leftBtn.TextSize = 13
        leftBtn.AutoButtonColor = false
        leftBtn.ZIndex = 9
        Instance.new("UICorner", leftBtn).CornerRadius = UDim.new(0, 6)
        skySelectorLabel = Instance.new("TextLabel", container)
        skySelectorLabel.Size = UDim2.new(0, 96, 0, 26)
        skySelectorLabel.Position = UDim2.new(0.5, -48, 0.5, -13)
        skySelectorLabel.BackgroundTransparency = 1
        skySelectorLabel.Text = skyTheme
        skySelectorLabel.TextColor3 = WHITE
        skySelectorLabel.Font = Enum.Font.GothamBold
        skySelectorLabel.TextSize = 11
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
        rightBtn.Font = Enum.Font.GothamBold
        rightBtn.TextSize = 13
        rightBtn.AutoButtonColor = false
        rightBtn.ZIndex = 9
        Instance.new("UICorner", rightBtn).CornerRadius = UDim.new(0, 6)
        local function updateSkySelector(direction)
            local idx = 1
            for i, name in ipairs(SKY_PRESETS_LIST) do
                if name == skyTheme then idx = i; break end
            end
            local newIdx = idx + direction
            if newIdx < 1 then newIdx = #SKY_PRESETS_LIST end
            if newIdx > #SKY_PRESETS_LIST then newIdx = 1 end
            local name = SKY_PRESETS_LIST[newIdx]
            skyTheme = name
            pcall(applyCustomSky, name)
            if skySelectorLabel then skySelectorLabel.Text = name end
            pcall(saveAllSettings)
        end
        leftBtn.MouseButton1Click:Connect(function() updateSkySelector(-1) end)
        rightBtn.MouseButton1Click:Connect(function() updateSkySelector(1) end)
    end

    mkSect(visualPage, "Panels")
    do
        local row = mkRow(visualPage, 42)
        mkLabel(row, "Elite Ping Lagger")
        local btn = Instance.new("TextButton", row)
        btn.Size = UDim2.new(0, 70, 0, 26)
        btn.Position = UDim2.new(1, -80, 0.5, -13)
        btn.BackgroundColor3 = Color3.fromRGB(20, 40, 70)
        btn.BorderSizePixel = 0
        btn.Text = "OPEN"
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 11
        btn.AutoButtonColor = false
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
        btn.MouseButton1Click:Connect(function()
            if _G.ElitePingLagger and _G.ElitePingLagger.Open then _G.ElitePingLagger.Open() end
        end)
    end
    do
        local row = mkRow(visualPage, 42)
        mkLabel(row, "Elite Bypass")
        local btn = Instance.new("TextButton", row)
        btn.Size = UDim2.new(0, 70, 0, 26)
        btn.Position = UDim2.new(1, -80, 0.5, -13)
        btn.BackgroundColor3 = Color3.fromRGB(20, 40, 70)
        btn.BorderSizePixel = 0
        btn.Text = "OPEN"
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 11
        btn.AutoButtonColor = false
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
        btn.MouseButton1Click:Connect(function()
            if _G.EliteBypass and _G.EliteBypass.Open then _G.EliteBypass.Open() end
        end)
    end
    mkSect(visualPage, "Overlays")
    setESPVIsual = mkToggle(visualPage, "Player ESP", function(on) toggleESP(on) end)
    setESPLineVisual = mkToggle(visualPage, "ESP Line", function(on)
        if on then startESPLine() else stopESPLine() end
    end)

    local configPage = contentPages["Config"]

    mkSect(configPage, "Automation")

    do
        local row = mkRow(configPage, 42)
        mkLabel(row, "Auto Steal Mode")

        local holder = Instance.new("Frame", row)
        holder.Name = "StealModeSelector"
        holder.BackgroundColor3 = Color3.fromRGB(15,15,20)
        holder.BackgroundTransparency = 0.15
        holder.Size = UDim2.new(0, 120, 0, 30)
        holder.Position = UDim2.new(1, -130, 0.5, -15)
        holder.BorderSizePixel = 0
        holder.ClipsDescendants = true
        holder.ZIndex = 8
        Instance.new("UICorner", holder).CornerRadius = UDim.new(0, 15)

        local holderStroke = Instance.new("UIStroke", holder)
        holderStroke.Color = Color3.fromRGB(60,60,70)
        holderStroke.Thickness = 1
        holderStroke.Transparency = 0.35

        local slide = Instance.new("Frame", holder)
        slide.Name = "SelectedSlide"
        slide.BackgroundColor3 = getThemeColor()
        slide.BackgroundTransparency = 0.15
        slide.Size = UDim2.new(0.5, -3, 1, -4)
        slide.Position = UDim2.new(0, 2, 0, 2)
        slide.BorderSizePixel = 0
        slide.ZIndex = 9
        Instance.new("UICorner", slide).CornerRadius = UDim.new(0, 13)

        local slideGrad = Instance.new("UIGradient", slide)
        slideGrad.Color = eliteGradient(getThemeColor())
        slideGrad.Rotation = 0

        local slideStroke = Instance.new("UIStroke", slide)
        slideStroke.Color = getThemeColor()
        slideStroke.Thickness = 1.2
        slideStroke.Transparency = 0.1

        local v1Text = Instance.new("TextLabel", holder)
        v1Text.BackgroundTransparency = 1
        v1Text.Text = "V1"
        v1Text.TextColor3 = Color3.fromRGB(255,255,255)
        v1Text.Font = Enum.Font.GothamBlack
        v1Text.TextSize = 12
        v1Text.Size = UDim2.new(0.5, 0, 1, 0)
        v1Text.Position = UDim2.new(0, 0, 0, 0)
        v1Text.ZIndex = 10

        local v2Text = Instance.new("TextLabel", holder)
        v2Text.BackgroundTransparency = 1
        v2Text.Text = "V2"
        v2Text.TextColor3 = Color3.fromRGB(150,150,165)
        v2Text.Font = Enum.Font.GothamBlack
        v2Text.TextSize = 12
        v2Text.Size = UDim2.new(0.5, 0, 1, 0)
        v2Text.Position = UDim2.new(0.5, 0, 0, 0)
        v2Text.ZIndex = 10

        local v1Click = Instance.new("TextButton", holder)
        v1Click.BackgroundTransparency = 1
        v1Click.Text = ""
        v1Click.AutoButtonColor = false
        v1Click.Size = UDim2.new(0.5, 0, 1, 0)
        v1Click.Position = UDim2.new(0, 0, 0, 0)
        v1Click.ZIndex = 11

        local v2Click = Instance.new("TextButton", holder)
        v2Click.BackgroundTransparency = 1
        v2Click.Text = ""
        v2Click.AutoButtonColor = false
        v2Click.Size = UDim2.new(0.5, 0, 1, 0)
        v2Click.Position = UDim2.new(0.5, 0, 0, 0)
        v2Click.ZIndex = 11

        local function setStealModeVisual(mode)
            local onV2 = (mode == "V2")
            TS:Create(slide, TweenInfo.new(0.22, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                Position = onV2 and UDim2.new(0.5, 1, 0, 2) or UDim2.new(0, 2, 0, 2)
            }):Play()
            TS:Create(v1Text, TweenInfo.new(0.18), {
                TextColor3 = onV2 and Color3.fromRGB(150,150,165) or Color3.fromRGB(255,255,255)
            }):Play()
            TS:Create(v2Text, TweenInfo.new(0.18), {
                TextColor3 = onV2 and Color3.fromRGB(255,255,255) or Color3.fromRGB(150,150,165)
            }):Play()
        end

        local function changeMode(mode)
            local newMode = (mode == "V2") and "V2" or "V1"
            if newMode == selectedStealMode then return end
            selectedStealMode = newMode
            if selectedStealMode == "V2" then
                CONFIG.STEAL_RANGE = 60
                Steal.StealRadius = 60
                if radInput then radInput.Text = "60" end
            end
            setStealModeVisual(selectedStealMode)
            if CONFIG.AUTO_STEAL_ENABLED then
                pcall(startAutoSteal)
            end
            saveAllSettings()
        end

        v1Click.MouseButton1Click:Connect(function() changeMode("V1") end)
        v2Click.MouseButton1Click:Connect(function() changeMode("V2") end)

        _G._eliteStealSlide = slide
        _G._eliteStealModeSetter = setStealModeVisual

        setStealModeVisual(selectedStealMode)
    end

    setInstaGrab = mkToggle(configPage, "Auto Steal", function(on)
        CONFIG.AUTO_STEAL_ENABLED = on
        if on then pcall(startAutoSteal) else stopAutoSteal() end
        updateProgressBarVisibility()
    end)
    do
        local row = mkRow(configPage, 42)
        mkLabel(row, "Steal Radius")
        radInput = mkBox(row, CONFIG.STEAL_RANGE, 50, 56, function(v)
            if v and v >= 5 and v <= 300 then
                CONFIG.STEAL_RANGE = _floor(v+0.5)
                Steal.StealRadius = CONFIG.STEAL_RANGE
                radInput.Text = tostring(CONFIG.STEAL_RANGE)
                saveAllSettings()
            end
        end)
    end

    mkSect(configPage, "Management")
    do
        local row = mkRow(configPage, 44)
        row.Size = UDim2.new(1, 0, 0, 44)
        local saveBtn = Instance.new("TextButton", row)
        saveBtn.Size = UDim2.new(1, -12, 0.8, 0)
        saveBtn.Position = UDim2.new(0, 6, 0.1, 0)
        saveBtn.BackgroundColor3 = Color3.fromRGB(245, 245, 250)
        saveBtn.BorderSizePixel = 0
        saveBtn.Text = "SAVE CONFIG"
        saveBtn.TextColor3 = Color3.fromRGB(20, 20, 25)
        saveBtn.Font = Enum.Font.GothamBold
        saveBtn.TextSize = 13
        saveBtn.AutoButtonColor = false
        saveBtn.ZIndex = 8
        Instance.new("UICorner", saveBtn).CornerRadius = UDim.new(0, 10)
        local saveStroke = Instance.new("UIStroke", saveBtn)
        saveStroke.Color = getThemeColor()
        saveStroke.Thickness = 1.5
        saveStroke.Transparency = 0.4
        saveBtn.MouseEnter:Connect(function()
            TS:Create(saveBtn, TweenInfo.new(0.15), {BackgroundColor3 = getThemeColor()}):Play()
            TS:Create(saveBtn, TweenInfo.new(0.15), {TextColor3 = Color3.fromRGB(255,255,255)}):Play()
        end)
        saveBtn.MouseLeave:Connect(function()
            TS:Create(saveBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(245, 245, 250)}):Play()
            TS:Create(saveBtn, TweenInfo.new(0.15), {TextColor3 = Color3.fromRGB(20, 20, 25)}):Play()
        end)
        saveBtn.MouseButton1Click:Connect(function()
            local ok = saveAllSettings(true)
            saveBtn.Text = ok and "SAVED" or "ERROR"
            task.delay(1.2, function()
                if saveBtn and saveBtn.Parent then saveBtn.Text = "SAVE CONFIG" end
            end)
        end)
    end
    do
        local row = mkRow(configPage, 44)
        row.Size = UDim2.new(1, 0, 0, 44)
        local resetPosBtn = Instance.new("TextButton", row)
        resetPosBtn.Size = UDim2.new(1, -12, 0.8, 0)
        resetPosBtn.Position = UDim2.new(0, 6, 0.1, 0)
        resetPosBtn.BackgroundColor3 = Color3.fromRGB(245, 245, 250)
        resetPosBtn.BorderSizePixel = 0
        resetPosBtn.Text = "RESET POSITIONS"
        resetPosBtn.TextColor3 = Color3.fromRGB(20, 20, 25)
        resetPosBtn.Font = Enum.Font.GothamBold
        resetPosBtn.TextSize = 13
        resetPosBtn.AutoButtonColor = false
        resetPosBtn.ZIndex = 8
        Instance.new("UICorner", resetPosBtn).CornerRadius = UDim.new(0, 10)
        local resetStroke = Instance.new("UIStroke", resetPosBtn)
        resetStroke.Color = getThemeColor()
        resetStroke.Thickness = 1.5
        resetStroke.Transparency = 0.4
        resetPosBtn.MouseEnter:Connect(function()
            TS:Create(resetPosBtn, TweenInfo.new(0.15), {BackgroundColor3 = getThemeColor()}):Play()
            TS:Create(resetPosBtn, TweenInfo.new(0.15), {TextColor3 = Color3.fromRGB(255,255,255)}):Play()
        end)
        resetPosBtn.MouseLeave:Connect(function()
            TS:Create(resetPosBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(245, 245, 250)}):Play()
            TS:Create(resetPosBtn, TweenInfo.new(0.15), {TextColor3 = Color3.fromRGB(20, 20, 25)}):Play()
        end)
        local resetDebounce = false
        resetPosBtn.MouseButton1Click:Connect(function()
            if resetDebounce then return end
            resetDebounce = true
            resetFloatingPositions()
            resetPosBtn.Text = "RESET"
            task.delay(1.2, function()
                if resetPosBtn and resetPosBtn.Parent then
                    resetPosBtn.Text = "RESET POSITIONS"
                    resetDebounce = false
                end
            end)
        end)
    end
    do
        local row = mkRow(configPage, 44)
        row.Size = UDim2.new(1, 0, 0, 44)
        local delBtn = Instance.new("TextButton", row)
        delBtn.Size = UDim2.new(1, -12, 0.8, 0)
        delBtn.Position = UDim2.new(0, 6, 0.1, 0)
        delBtn.BackgroundColor3 = Color3.fromRGB(245, 245, 250)
        delBtn.BorderSizePixel = 0
        delBtn.Text = "RESET ALL SETTINGS"
        delBtn.TextColor3 = Color3.fromRGB(170, 30, 50)
        delBtn.Font = Enum.Font.GothamBold
        delBtn.TextSize = 13
        delBtn.AutoButtonColor = false
        delBtn.ZIndex = 8
        Instance.new("UICorner", delBtn).CornerRadius = UDim.new(0, 10)
        local delStroke = Instance.new("UIStroke", delBtn)
        delStroke.Color = Color3.fromRGB(200, 60, 80)
        delStroke.Thickness = 1.5
        delStroke.Transparency = 0.4
        delBtn.MouseEnter:Connect(function()
            TS:Create(delBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(200, 50, 70)}):Play()
            TS:Create(delBtn, TweenInfo.new(0.15), {TextColor3 = Color3.fromRGB(255,255,255)}):Play()
        end)
        delBtn.MouseLeave:Connect(function()
            TS:Create(delBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(245, 245, 250)}):Play()
            TS:Create(delBtn, TweenInfo.new(0.15), {TextColor3 = Color3.fromRGB(170, 30, 50)}):Play()
        end)
        local deleteState = 0
        local originalDeleteText = "RESET ALL SETTINGS"
        local delDebounce = false
        delBtn.MouseButton1Click:Connect(function()
            if delDebounce then return end
            if deleteState == 0 then
                deleteState = 1
                delBtn.Text = "CONFIRM?"
                delBtn.BackgroundColor3 = Color3.fromRGB(255, 220, 220)
                delBtn.TextColor3 = Color3.fromRGB(160, 0, 0)
                task.delay(2, function()
                    if delBtn and delBtn.Parent and deleteState == 1 then
                        deleteState = 0
                        delBtn.Text = originalDeleteText
                        delBtn.BackgroundColor3 = Color3.fromRGB(245, 245, 250)
                        delBtn.TextColor3 = Color3.fromRGB(170, 30, 50)
                    end
                end)
            elseif deleteState == 1 then
                delDebounce = true
                local invoked, success = pcall(resetToFactoryDefaults)
                success = invoked and success
                delBtn.Text = success and "SETTINGS RESET" or "ERROR"
                delBtn.BackgroundColor3 = Color3.fromRGB(245, 245, 250)
                delBtn.TextColor3 = Color3.fromRGB(170, 30, 50)
                deleteState = 0
                task.delay(1.5, function()
                    if delBtn and delBtn.Parent then
                        delBtn.Text = originalDeleteText
                        delBtn.BackgroundColor3 = Color3.fromRGB(245, 245, 250)
                        delBtn.TextColor3 = Color3.fromRGB(170, 30, 50)
                        delDebounce = false
                    end
                end)
            end
        end)
    end

    local keyPage = contentPages["Keybinds"]
    mkSect(keyPage, "Keybinds")
    do
        local resetRow = mkRow(keyPage, 40)
        mkLabel(resetRow, "Reset All Keybinds")
        local resetBtn = Instance.new("TextButton", resetRow)
        resetBtn.Size = UDim2.new(0, 92, 0, 24)
        resetBtn.Position = UDim2.new(1, -100, 0.5, -12)
        resetBtn.BackgroundColor3 = Color3.fromRGB(245, 245, 250)
        resetBtn.BorderSizePixel = 0
        resetBtn.Text = "RESET"
        resetBtn.TextColor3 = Color3.fromRGB(170, 30, 50)
        resetBtn.Font = Enum.Font.GothamBold
        resetBtn.TextSize = 11
        resetBtn.ZIndex = 9
        Instance.new("UICorner", resetBtn).CornerRadius = UDim.new(0, 7)
        resetBtn.MouseButton1Click:Connect(function()
            for key, value in pairs(DEFAULT_KB) do
                if KB[key] then KB[key].kb = value.kb; KB[key].gp = value.gp end
            end
            for _, ref in ipairs(keyButtonRefs) do
                local entry = ref.entry
                ref.btn.Text = (entry.gp and entry.gp.Name) or (entry.kb and entry.kb.Name) or "None"
            end
            resetBtn.Text = "RESET"
            task.defer(function() saveAllSettings(true) end)
            task.delay(1, function()
                if resetBtn and resetBtn.Parent then resetBtn.Text = "RESET" end
            end)
        end)
    end

    mkSect(keyPage, "Movement")
    addKeybindRow(keyPage, "Carry Mode", KB.CarryToggle)
    addKeybindRow(keyPage, "Lagger Mode", KB.LaggerMode)
    addKeybindRow(keyPage, "Auto Left", KB.AutoLeft)
    addKeybindRow(keyPage, "Auto Right", KB.AutoRight)

    mkSect(keyPage, "Combat")
    addKeybindRow(keyPage, "Auto Bat", KB.AutoBat)
    addKeybindRow(keyPage, "TP BAT", KB.TPBat)
    addKeybindRow(keyPage, "Bat V2", KB.BatV2)

    mkSect(keyPage, "Utility")
    addKeybindRow(keyPage, "Drop Brainrot", KB.DropBrainrot)
    addKeybindRow(keyPage, "Insta Reset", KB.InstaReset)
    addKeybindRow(keyPage, "TP Down", KB.TPFloor)
    addKeybindRow(keyPage, "Hide GUI", KB.GuiHide)

    local spacer = Instance.new("Frame", keyPage)
    spacer.Size = UDim2.new(1, 0, 0, 16)
    spacer.BackgroundTransparency = 1
    spacer.LayoutOrder = getNextOrder(keyPage)
    spacer.ZIndex = 7

    -- ================================================================
    -- PROGRESS BAR (rediseñada)
    -- ================================================================
    pbFrame = Instance.new("Frame", gui)
    pbFrame.Name = "EliteFamilyAutoGrabBar"
    pbFrame.Size = UDim2.new(0, 320, 0, 48)
    pbFrame.Position = UDim2.new(0.5, -160, 0.80, 0)
    pbFrame.BackgroundColor3 = Color3.fromRGB(14, 14, 20)
    pbFrame.BackgroundTransparency = 0
    pbFrame.BorderSizePixel = 0
    pbFrame.Active = true
    pbFrame.Visible = CONFIG.AUTO_STEAL_ENABLED
    pbFrame.ZIndex = 500
    pbFrame.ClipsDescendants = false

    pbScale = Instance.new("UIScale", pbFrame)
    pbScale.Scale = uiScaleValue / 100

    if savedProgressBarPos then
        pbFrame.Position = UDim2.new(
            savedProgressBarPos.XScale or 0.5,
            savedProgressBarPos.XOffset or -160,
            savedProgressBarPos.YScale or 0.80,
            savedProgressBarPos.YOffset or 0
        )
    end

    -- Rounded panel
    Instance.new("UICorner", pbFrame).CornerRadius = UDim.new(0, 16)

    -- Glassy panel gradient
    local pbPanelGrad = Instance.new("UIGradient", pbFrame)
    pbPanelGrad.Name = "PanelGrad"
    pbPanelGrad.Rotation = 90
    pbPanelGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0.00, Color3.fromRGB(36, 36, 46)),
        ColorSequenceKeypoint.new(0.55, Color3.fromRGB(18, 18, 26)),
        ColorSequenceKeypoint.new(1.00, Color3.fromRGB(10, 10, 16)),
    })

    -- Soft theme stroke
    local pbOuterStroke = Instance.new("UIStroke", pbFrame)
    pbOuterStroke.Name = "OuterStroke"
    pbOuterStroke.Color = getThemeColor()
    pbOuterStroke.Thickness = 1.4
    pbOuterStroke.Transparency = 0.4
    pbOuterStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

    -- Top glassy highlight strip
    local pbTopShine = Instance.new("Frame", pbFrame)
    pbTopShine.Name = "TopShine"
    pbTopShine.Size = UDim2.new(1, -18, 0, 1)
    pbTopShine.Position = UDim2.new(0, 9, 0, 1)
    pbTopShine.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    pbTopShine.BackgroundTransparency = 0.88
    pbTopShine.BorderSizePixel = 0
    pbTopShine.ZIndex = 501

    -- Right-side info column (divider + FPS + Ping)
    local pbTopRow = Instance.new("Frame", pbFrame)
    pbTopRow.Name = "InfoColumn"
    pbTopRow.Size = UDim2.new(0, 86, 1, -10)
    pbTopRow.Position = UDim2.new(1, -88, 0, 5)
    pbTopRow.BackgroundTransparency = 1
    pbTopRow.ZIndex = 504

    local pbDivider = Instance.new("Frame", pbTopRow)
    pbDivider.Name = "Divider"
    pbDivider.Size = UDim2.new(0, 1, 1, -8)
    pbDivider.Position = UDim2.new(0, 0, 0, 4)
    pbDivider.BackgroundColor3 = getThemeColor()
    pbDivider.BackgroundTransparency = 0.55
    pbDivider.BorderSizePixel = 0
    pbDivider.ZIndex = 505
    Instance.new("UICorner", pbDivider).CornerRadius = UDim.new(1, 0)

    local fpsNeon = Instance.new("TextLabel", pbTopRow)
    fpsNeon.Name = "FPSNeon"
    fpsNeon.Size = UDim2.new(1, -12, 0, 14)
    fpsNeon.Position = UDim2.new(0, 12, 0, 8)
    fpsNeon.BackgroundTransparency = 1
    fpsNeon.Text = "-- FPS"
    fpsNeon.TextColor3 = getThemeColor()
    fpsNeon.Font = Enum.Font.GothamBold
    fpsNeon.TextSize = 10
    fpsNeon.TextXAlignment = Enum.TextXAlignment.Left
    fpsNeon.ZIndex = 506

    local pingNeon = Instance.new("TextLabel", pbTopRow)
    pingNeon.Name = "PingNeon"
    pingNeon.Size = UDim2.new(1, -12, 0, 14)
    pingNeon.Position = UDim2.new(0, 12, 0, 24)
    pingNeon.BackgroundTransparency = 1
    pingNeon.Text = "-- MS"
    pingNeon.TextColor3 = getThemeColor()
    pingNeon.Font = Enum.Font.GothamBold
    pingNeon.TextSize = 10
    pingNeon.TextXAlignment = Enum.TextXAlignment.Left
    pingNeon.ZIndex = 506

    -- Inner track
    local pbBarBg = Instance.new("Frame", pbFrame)
    pbBarBg.Name = "BarBg"
    pbBarBg.Size = UDim2.new(1, -98, 1, -16)
    pbBarBg.Position = UDim2.new(0, 8, 0, 8)
    pbBarBg.BackgroundColor3 = Color3.fromRGB(6, 6, 10)
    pbBarBg.BorderSizePixel = 0
    pbBarBg.ClipsDescendants = true
    pbBarBg.ZIndex = 500
    Instance.new("UICorner", pbBarBg).CornerRadius = UDim.new(1, 0)

    local trackStroke = Instance.new("UIStroke", pbBarBg)
    trackStroke.Name = "TrackStroke"
    trackStroke.Color = Color3.fromRGB(0, 0, 0)
    trackStroke.Thickness = 1
    trackStroke.Transparency = 0.35

    -- Fill
    progressFill = Instance.new("Frame", pbBarBg)
    progressFill.Size = UDim2.new(0, 0, 1, 0)
    progressFill.Position = UDim2.new(0, 0, 0, 0)
    progressFill.BackgroundColor3 = getThemeColor()
    progressFill.BorderSizePixel = 0
    progressFill.ClipsDescendants = true
    progressFill.ZIndex = 502
    Instance.new("UICorner", progressFill).CornerRadius = UDim.new(1, 0)

    local fillGrad = Instance.new("UIGradient", progressFill)
    fillGrad.Name = "FillGrad"
    fillGrad.Color = eliteGradient(getThemeColor())
    fillGrad.Rotation = 0

    -- Glassy highlight on top of the fill
    local fillHighlight = Instance.new("Frame", progressFill)
    fillHighlight.Name = "FillHighlight"
    fillHighlight.Size = UDim2.new(1, -8, 0.42, 0)
    fillHighlight.Position = UDim2.new(0, 4, 0, 2)
    fillHighlight.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    fillHighlight.BackgroundTransparency = 0.78
    fillHighlight.BorderSizePixel = 0
    fillHighlight.ZIndex = 503
    Instance.new("UICorner", fillHighlight).CornerRadius = UDim.new(1, 0)

    -- Shimmer sweep inside fill
    local shimmer = Instance.new("Frame", progressFill)
    shimmer.Name = "Shimmer"
    shimmer.Size = UDim2.new(0, 48, 1, 0)
    shimmer.Position = UDim2.new(0, -48, 0, 0)
    shimmer.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    shimmer.BackgroundTransparency = 0.55
    shimmer.BorderSizePixel = 0
    shimmer.ZIndex = 504
    local shimmerGrad = Instance.new("UIGradient", shimmer)
    shimmerGrad.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0.00, 1),
        NumberSequenceKeypoint.new(0.50, 0.25),
        NumberSequenceKeypoint.new(1.00, 1),
    })

    -- Percentage label centered over the track
    progressPct = Instance.new("TextLabel", pbBarBg)
    progressPct.Size = UDim2.new(1, -14, 1, 0)
    progressPct.Position = UDim2.new(0, 7, 0, 0)
    progressPct.BackgroundTransparency = 1
    progressPct.Text = "0%"
    progressPct.TextColor3 = Color3.fromRGB(240, 240, 250)
    progressPct.Font = Enum.Font.GothamBold
    progressPct.TextSize = 11
    progressPct.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    progressPct.TextStrokeTransparency = 0.35
    progressPct.TextXAlignment = Enum.TextXAlignment.Center
    progressPct.TextYAlignment = Enum.TextYAlignment.Center
    progressPct.ZIndex = 505

    -- Shimmer animation loop
    task.spawn(function()
        while pbFrame and pbFrame.Parent do
            shimmer.Position = UDim2.new(0, -60, 0, 0)
            TS:Create(shimmer, TweenInfo.new(1.6, Enum.EasingStyle.Linear), {
                Position = UDim2.new(1, 20, 0, 0)
            }):Play()
            task.wait(1.6)
        end
    end)

    -- FPS / Ping updater
    task.spawn(function()
        local lastFrame = _tick()
        local fpsSamples = {}
        local fpsAvg = 60
        RunService.RenderStepped:Connect(function()
            local now = _tick()
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
        while pbFrame and pbFrame.Parent do
            local ping = 0
            pcall(function() ping = LP:GetNetworkPing() * 1000 end)
            if fpsNeon then fpsNeon.Text = string.format("%d FPS", _floor(fpsAvg + 0.5)) end
            if pingNeon then pingNeon.Text = string.format("%d MS", _floor(ping + 0.5)) end
            task.wait(0.75)
        end
    end)

    drag(pbFrame)
end


function attachBtnBackgroundImage(parent)
    if not parent then return end
    local zBase = parent.ZIndex or 10
    local img = parent:FindFirstChild("BtnBgImage")
    if not img then
        img = Instance.new("ImageLabel")
        img.Name = "BtnBgImage"
        img.Size = UDim2.new(1, 0, 1, 0)
        img.Position = UDim2.new(0, 0, 0, 0)
        img.BackgroundTransparency = 1
        img.ScaleType = Enum.ScaleType.Crop
        img.ZIndex = zBase + 1
        img.ClipsDescendants = true
        local corner = Instance.new("UICorner", img)
        corner.CornerRadius = UDim.new(0, 12)
        img.Parent = parent
    end
    -- Soft dark veil so text stays readable over a clear image
    local veil = parent:FindFirstChild("BtnBgVeil")
    if not veil then
        veil = Instance.new("Frame")
        veil.Name = "BtnBgVeil"
        veil.Size = UDim2.new(1, 0, 1, 0)
        veil.BackgroundColor3 = Color3.fromRGB(8, 6, 14)
        veil.BackgroundTransparency = 1
        veil.BorderSizePixel = 0
        veil.ZIndex = zBase + 2
        local vc = Instance.new("UICorner", veil)
        vc.CornerRadius = UDim.new(0, 12)
        veil.Parent = parent
    end
    local function ensureTextStroke(obj)
        if not obj then return end
        if obj:FindFirstChild("BtnTextStroke") then return end
        local ts = Instance.new("UIStroke")
        ts.Name = "BtnTextStroke"
        ts.Color = Color3.fromRGB(0, 0, 0)
        ts.Thickness = 1.5
        ts.Transparency = 0.2
        ts.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual
        ts.Parent = obj
    end
    local label = parent:FindFirstChild("TextLabel")
    if label then
        label.ZIndex = zBase + 3
        ensureTextStroke(label)
    end
    -- Mobile panel buttons are TextButtons with Text directly
    if parent:IsA("TextButton") then
        ensureTextStroke(parent)
    end
    local aid = buttonBgImages[buttonBgIndex]
    if buttonBgMode ~= "None" and aid and tostring(aid) ~= "" then
        img.Image = "rbxassetid://" .. tostring(aid)
        img.ImageTransparency = 0.12 -- clearer / prettier image
        img.Visible = true
        veil.BackgroundTransparency = 0.45
        veil.Visible = true
        if parent:IsA("GuiObject") then
            parent.BackgroundTransparency = 0.55
        end
        local grad = parent:FindFirstChild("BtnGrad")
        if grad and grad:IsA("UIGradient") then
            grad.Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0.72),
                NumberSequenceKeypoint.new(1, 0.72),
            })
        end
    else
        img.Image = ""
        img.Visible = false
        veil.Visible = false
        veil.BackgroundTransparency = 1
        if parent:IsA("GuiObject") then
            parent.BackgroundTransparency = 0
        end
        local grad = parent:FindFirstChild("BtnGrad")
        if grad and grad:IsA("UIGradient") then
            grad.Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0),
                NumberSequenceKeypoint.new(1, 0),
            })
        end
    end
    return img
end

function refreshAllButtonBackgrounds()
    if MobilePanel then
        for _, btn in ipairs(MobilePanel:GetChildren()) do
            if btn:IsA("TextButton") then attachBtnBackgroundImage(btn) end
        end
    end
    for _, panel in ipairs({tpBatFloatingButton, batV2FloatingButton, instaResetFloatingButton}) do
        if panel then
            local fr = panel:FindFirstChild("Frame")
            if fr then attachBtnBackgroundImage(fr) end
        end
    end
end

function waitIntroThenEnable(gui)
    if not gui then return end
    gui.Enabled = false
    task.spawn(function()
        local t0 = os.clock()
        while not _G.EliteFamilyIntroFinished and (os.clock() - t0) < 15 do
            task.wait(0.05)
        end
        -- Solo mostrar si la intro ya terminó (incluye SKIP)
        if gui and gui.Parent and _G.EliteFamilyIntroFinished then
            gui.Enabled = true
        end
    end)
end

function hideAllUIForIntro()
    if gui then pcall(function() gui.Enabled = false end) end
    if MobilePanel then pcall(function() MobilePanel.Enabled = false end) end
    if tpBatFloatingButton then pcall(function() tpBatFloatingButton.Enabled = false end) end
    if batV2FloatingButton then pcall(function() batV2FloatingButton.Enabled = false end) end
    if instaResetFloatingButton then pcall(function() instaResetFloatingButton.Enabled = false end) end
end

function showAllUIAfterIntro()
    if gui then pcall(function() gui.Enabled = true end) end
    if MobilePanel then pcall(function() MobilePanel.Enabled = true end) end
    if tpBatFloatingButton then pcall(function() tpBatFloatingButton.Enabled = true end) end
    if batV2FloatingButton then pcall(function() batV2FloatingButton.Enabled = true end) end
    if instaResetFloatingButton then pcall(function() instaResetFloatingButton.Enabled = true end) end
end

function scheduleRevealAfterIntro()
    task.spawn(function()
        hideAllUIForIntro()
        local t0 = os.clock()
        while not _G.EliteFamilyIntroFinished and (os.clock() - t0) < 15 do
            task.wait(0.05)
        end
        showAllUIAfterIntro()
    end)
end

function createMobilePanel()
    local panel = Instance.new("ScreenGui")
    panel.Name = "EliteFamilyMobilePanel"
    panel.ResetOnSpawn = false
    panel.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    panel.Enabled = false
    pcall(function() if syn and syn.protect_gui then syn.protect_gui(panel) end end)
    local okPanel = pcall(function() panel.Parent = game:GetService("CoreGui") end)
    if not okPanel then panel.Parent = LP:WaitForChild("PlayerGui") end

    local BTN_W, BTN_H = 60, 60
    local buttons = {}
    local buttonNames = {"DropBR", "AutoLeft", "AutoBat", "AutoRight", "TpDown", "Carry", "Lagger1", "Lagger2"}
    local buttonTexts = {"DROP\nBR", "AUTO\nLEFT", "BAT\nAIMBOT", "AUTO\nRIGHT", "TP\nDOWN", "CARRY\nSPD", "LAGGER\n1", "LAGGER\n2"}

    local function createButton(name, text, order, isToggle, callback)
        local btn = Instance.new("TextButton", panel)
        btn.Name = name
        btn.Size = UDim2.new(0, BTN_W, 0, BTN_H)
        btn.BackgroundColor3 = Color3.fromRGB(10,10,10)
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

        btn.BackgroundColor3 = Color3.fromRGB(255,255,255)
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 12)
        attachBtnBackgroundImage(btn)

        local bgGrad = Instance.new("UIGradient", btn)
        bgGrad.Name = "BtnGrad"
        bgGrad.Rotation = 90
        bgGrad.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0.00, Color3.fromRGB(252,252,253)),
            ColorSequenceKeypoint.new(0.45, Color3.fromRGB(233,233,236)),
            ColorSequenceKeypoint.new(1.00, Color3.fromRGB(168,168,176)),
        })

        local stroke = Instance.new("UIStroke", btn)
        stroke.Color = Color3.fromRGB(120,120,128)
        stroke.Thickness = 1
        stroke.Transparency = 0.55
        stroke.Name = "NormalStroke"

        local label = Instance.new("TextLabel", btn)
        label.Name = "TextLabel"
        label.Size = UDim2.new(1, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.Text = text
        label.TextColor3 = Color3.fromRGB(32,32,40)
        label.Font = Enum.Font.GothamBlack
        label.TextSize = 11
        label.TextWrapped = true
        label.ZIndex = 11

        local uiScale = Instance.new("UIScale", btn)
        uiScale.Scale = floatingButtonScale
        table.insert(_floatingUIScales, uiScale)

        local active = false
        local function setActive(state)
            active = state
            btn:SetAttribute("MobActive", state and true or false)
            paintFloatingBtn(btn, state)
        end
        setActive(false)

        local dragging = false
        local hasMoved = false
        local dragStart = nil
        local startPos = nil
        local movedDistance = 0

        local function onInputBegan(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true; hasMoved = false; movedDistance = 0
                dragStart = input.Position; startPos = btn.Position
                _isDraggingButton = true
            end
        end

        local function onInputChanged(input)
            if not dragging then return end
            if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                local delta = input.Position - dragStart
                movedDistance = delta.Magnitude
                if not uiLocked then
                    hasMoved = true
                    btn.Position = UDim2.new(0, startPos.X.Offset + delta.X, 0, startPos.Y.Offset + delta.Y)
                end
            end
        end

        local function onInputEnded(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                if dragging then
                    if movedDistance < 12 then
                        if isToggle then
                            if callback then callback(setActive) end
                        else
                            if callback then callback(setActive, active) end
                        end
                    elseif not uiLocked and hasMoved then
                        savedButtonPositions[name] = {X = btn.Position.X.Offset, Y = btn.Position.Y.Offset}
                        task.defer(function() pcall(saveAllSettings) end)
                    end
                    dragging = false; hasMoved = false
                    dragStart = nil; startPos = nil; movedDistance = 0
                    _isDraggingButton = false
                end
            end
        end

        btn.InputBegan:Connect(onInputBegan)
        btn.InputChanged:Connect(onInputChanged)
        btn.InputEnded:Connect(onInputEnded)

        UIS.InputEnded:Connect(function(inp)
            if inp.UserInputType ~= Enum.UserInputType.Touch
               and inp.UserInputType ~= Enum.UserInputType.MouseButton1 then return end
            if dragging then onInputEnded(inp) end
        end)

        buttons[name] = {btn = btn, setActive = setActive, label = label}
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
            end
        elseif name == "AutoBat" then
            callback = function(setActive)
                if not autoBatEnabled then enableAutoBat() else disableAutoBat() end
                setActive(autoBatEnabled)
            end
        elseif name == "AutoRight" then
            callback = function(setActive)
                autoRightEnabled = not autoRightEnabled
                setActive(autoRightEnabled)
                if autoRightEnabled then startAutoRight() else stopAutoRight() end
                if autoRightSetVisual then autoRightSetVisual(autoRightEnabled) end
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
                    speedMode = true; laggerToggled = false; laggerCarryToggled = false; setActive(true)
                    if buttons.Lagger1 and buttons.Lagger1.setActive then buttons.Lagger1.setActive(false) end
                    if buttons.Lagger2 and buttons.Lagger2.setActive then buttons.Lagger2.setActive(false) end
                else
                    speedMode = false; setActive(false)
                end
                refreshSpeedModeLabel()
                if _G.__EliteFamilyApplySpeedNow then pcall(_G.__EliteFamilyApplySpeedNow) end
            end
        elseif name == "Lagger1" then
            callback = function(setActive)
                if speedMode then speedMode = false; if mobSetCarry then mobSetCarry(false) end end
                if not laggerToggled then
                    laggerToggled = true; laggerCarryToggled = false; setActive(true)
                    if buttons.Lagger2 and buttons.Lagger2.setActive then buttons.Lagger2.setActive(false) end
                else
                    laggerToggled = false; setActive(false)
                end
                refreshSpeedModeLabel()
                if _G.__EliteFamilyApplySpeedNow then pcall(_G.__EliteFamilyApplySpeedNow) end
            end
        elseif name == "Lagger2" then
            callback = function(setActive)
                if speedMode then speedMode = false; if mobSetCarry then mobSetCarry(false) end end
                if not laggerCarryToggled then
                    laggerCarryToggled = true; laggerToggled = false; setActive(true)
                    if buttons.Lagger1 and buttons.Lagger1.setActive then buttons.Lagger1.setActive(false) end
                else
                    laggerToggled = false; setActive(false)
                end
                refreshSpeedModeLabel()
                if _G.__EliteFamilyApplySpeedNow then pcall(_G.__EliteFamilyApplySpeedNow) end
            end
        end
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
    if buttons.Lagger1 and buttons.Lagger1.setActive then buttons.Lagger1.setActive(laggerToggled) end
    if buttons.Lagger2 and buttons.Lagger2.setActive then buttons.Lagger2.setActive(laggerCarryToggled) end

    waitIntroThenEnable(panel)
    return panel
end

function createTpBatFloatingButton()
    local panel = Instance.new("ScreenGui")
    panel.Name = "TpBatButton"
    panel.ResetOnSpawn = false
    panel.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    panel.DisplayOrder = 21
    panel.Enabled = false
    pcall(function() if syn and syn.protect_gui then syn.protect_gui(panel) end end)
    local okPanel = pcall(function() panel.Parent = game:GetService("CoreGui") end)
    if not okPanel then panel.Parent = LP:WaitForChild("PlayerGui") end

    local btnFrame = Instance.new("Frame", panel)
    btnFrame.Size = UDim2.new(0, 60, 0, 60)
    btnFrame.Name = "Frame"
    if tpBatFloatingPos then
        btnFrame.Position = UDim2.new(tpBatFloatingPos.XScale or 0.5, tpBatFloatingPos.XOffset or 20, tpBatFloatingPos.YScale or 0, tpBatFloatingPos.YOffset or 10)
    else
        btnFrame.Position = UDim2.new(0.5, 20, 0, 10)
    end
    btnFrame.BackgroundColor3 = Color3.fromRGB(255,255,255)
    btnFrame.BorderSizePixel = 0
    btnFrame.ZIndex = 20
    Instance.new("UICorner", btnFrame).CornerRadius = UDim.new(0, 12)
    attachBtnBackgroundImage(btnFrame)
    local bgGrad = Instance.new("UIGradient", btnFrame)
    bgGrad.Name = "BtnGrad"
    bgGrad.Rotation = 90
    bgGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0.00, Color3.fromRGB(252,252,253)),
        ColorSequenceKeypoint.new(0.45, Color3.fromRGB(233,233,236)),
        ColorSequenceKeypoint.new(1.00, Color3.fromRGB(168,168,176)),
    })

    local label = Instance.new("TextLabel", btnFrame)
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = "TP\nBAT"
    label.TextColor3 = Color3.fromRGB(32,32,40)
    label.Font = Enum.Font.GothamBlack
    label.TextSize = 11
    label.TextWrapped = true
    label.ZIndex = 21

    local uiScale = Instance.new("UIScale", btnFrame)
    uiScale.Scale = floatingButtonScale
    table.insert(_floatingUIScales, uiScale)

    local function setActive(state)
        label.Text = "TP\nBAT"
        paintFloatingBtn(btnFrame, state)
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
                    toggleBatDesyncTp()
                    setActive(batDesyncTpEnabled)
                elseif not uiLocked and hasMoved then
                    tpBatFloatingPos = {XScale = btnFrame.Position.X.Scale, XOffset = btnFrame.Position.X.Offset, YScale = btnFrame.Position.Y.Scale, YOffset = btnFrame.Position.Y.Offset}
                    task.defer(function() pcall(saveAllSettings) end)
                end
                dragging = false; hasMoved = false
            end
        end
    end)

    waitIntroThenEnable(panel)
    tpBatFloatingButton = panel
    return panel
end


function createBatV2FloatingButton()
    local panel = Instance.new("ScreenGui")
    panel.Name = "BatV2Button"
    panel.ResetOnSpawn = false
    panel.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    panel.DisplayOrder = 22
    panel.Enabled = false
    pcall(function() if syn and syn.protect_gui then syn.protect_gui(panel) end end)
    local okPanel = pcall(function() panel.Parent = game:GetService("CoreGui") end)
    if not okPanel then panel.Parent = LP:WaitForChild("PlayerGui") end

    local btnFrame = Instance.new("Frame", panel)
    btnFrame.Size = UDim2.new(0, 60, 0, 60)
    btnFrame.Name = "Frame"
    if batV2FloatingPos then
        btnFrame.Position = UDim2.new(batV2FloatingPos.XScale or 0.5,
                                      batV2FloatingPos.XOffset or -50,
                                      batV2FloatingPos.YScale or 0,
                                      batV2FloatingPos.YOffset or 10)
    else
        btnFrame.Position = UDim2.new(0.5, -50, 0, 10)
    end
    btnFrame.BackgroundColor3 = Color3.fromRGB(255,255,255)
    btnFrame.BackgroundTransparency = 0
    btnFrame.BorderSizePixel = 0
    btnFrame.ZIndex = 20
    Instance.new("UICorner", btnFrame).CornerRadius = UDim.new(0, 12)
    attachBtnBackgroundImage(btnFrame)

    local bgGrad = Instance.new("UIGradient", btnFrame)
    bgGrad.Name = "BtnGrad"
    bgGrad.Rotation = 90
    bgGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0.00, Color3.fromRGB(252,252,253)),
        ColorSequenceKeypoint.new(0.45, Color3.fromRGB(233,233,236)),
        ColorSequenceKeypoint.new(1.00, Color3.fromRGB(168,168,176)),
    })

    local stroke = Instance.new("UIStroke", btnFrame)
    stroke.Color = Color3.fromRGB(120,120,128)
    stroke.Thickness = 1
    stroke.Transparency = 0.55

    local label = Instance.new("TextLabel", btnFrame)
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = "BAT\nV2"
    label.TextColor3 = Color3.fromRGB(32,32,40)
    label.Font = Enum.Font.GothamBlack
    label.TextSize = 11
    label.TextWrapped = true
    label.ZIndex = 21

    local uiScale = Instance.new("UIScale", btnFrame)
    uiScale.Scale = floatingButtonScale
    table.insert(_floatingUIScales, uiScale)

    local function setActive(state)
        paintFloatingBtn(btnFrame, state)
    end

    local dragging = false
    local hasMoved = false
    local dragStart, startPos
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
                btnFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
                                              startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end
        end
    end)
    btnFrame.InputEnded:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
            if dragging then
                if not hasMoved then
                    toggleBatV2()
                    setActive(autoBatV2Enabled)
                elseif not uiLocked and hasMoved then
                    batV2FloatingPos = {
                        XScale = btnFrame.Position.X.Scale,
                        XOffset = btnFrame.Position.X.Offset,
                        YScale = btnFrame.Position.Y.Scale,
                        YOffset = btnFrame.Position.Y.Offset
                    }
                    task.defer(function() pcall(saveAllSettings) end)
                end
                dragging = false; hasMoved = false
            end
        end
    end)

    setActive(autoBatV2Enabled)
    waitIntroThenEnable(panel)
    batV2FloatingButton = panel
    return panel
end

function createInstaResetFloatingButton()
    local panel = Instance.new("ScreenGui")
    panel.Name = "InstaResetButton"
    panel.ResetOnSpawn = false
    panel.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    panel.DisplayOrder = 23
    panel.Enabled = false
    pcall(function() if syn and syn.protect_gui then syn.protect_gui(panel) end end)
    local okPanel = pcall(function() panel.Parent = game:GetService("CoreGui") end)
    if not okPanel then panel.Parent = LP:WaitForChild("PlayerGui") end

    local btnFrame = Instance.new("Frame", panel)
    btnFrame.Size = UDim2.new(0, 60, 0, 60)
    btnFrame.Name = "Frame"
    if instaResetFloatingPos then
        btnFrame.Position = UDim2.new(instaResetFloatingPos.XScale or 0.5, instaResetFloatingPos.XOffset or 90, instaResetFloatingPos.YScale or 0, instaResetFloatingPos.YOffset or 10)
    else
        btnFrame.Position = UDim2.new(0.5, 90, 0, 10)
    end
    btnFrame.BackgroundColor3 = Color3.fromRGB(255,255,255)
    btnFrame.BorderSizePixel = 0
    btnFrame.ZIndex = 20
    Instance.new("UICorner", btnFrame).CornerRadius = UDim.new(0, 12)
    attachBtnBackgroundImage(btnFrame)

    local bgGrad = Instance.new("UIGradient", btnFrame)
    bgGrad.Name = "BtnGrad"
    bgGrad.Rotation = 90
    bgGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0.00, Color3.fromRGB(252,252,253)),
        ColorSequenceKeypoint.new(0.45, Color3.fromRGB(233,233,236)),
        ColorSequenceKeypoint.new(1.00, Color3.fromRGB(168,168,176)),
    })

    local label = Instance.new("TextLabel", btnFrame)
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = "INSTA\nRESET"
    label.TextColor3 = Color3.fromRGB(32,32,40)
    label.Font = Enum.Font.GothamBlack
    label.TextSize = 11
    label.TextWrapped = true
    label.ZIndex = 21

    local uiScale = Instance.new("UIScale", btnFrame)
    uiScale.Scale = floatingButtonScale
    table.insert(_floatingUIScales, uiScale)

    local dragging, hasMoved, dragStart, startPos, activeInput
    local RESET_TAP_THRESHOLD = 12

    local function pointInside(pos)
        local ap = btnFrame.AbsolutePosition
        local as = btnFrame.AbsoluteSize
        return pos.X >= ap.X and pos.X <= ap.X + as.X and pos.Y >= ap.Y and pos.Y <= ap.Y + as.Y
    end

    local function setActive(state)
        if state then
            TS:Create(btnFrame, TweenInfo.new(0.05), {BackgroundColor3 = Color3.fromRGB(255,255,255)}):Play()
            TS:Create(label, TweenInfo.new(0.05), {TextColor3 = Color3.fromRGB(0,0,0)}):Play()
        else
            paintFloatingBtn(btnFrame, false)
        end
    end

    btnFrame.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
            if activeInput then return end
            activeInput = inp
            dragging = true; hasMoved = false
            dragStart = inp.Position; startPos = btnFrame.Position
        end
    end)

    UIS.InputChanged:Connect(function(inp)
        if not dragging or not activeInput then return end
        local isTouchMove = activeInput.UserInputType == Enum.UserInputType.Touch and inp == activeInput
        local isMouseMove = activeInput.UserInputType == Enum.UserInputType.MouseButton1 and inp.UserInputType == Enum.UserInputType.MouseMovement
        if not isTouchMove and not isMouseMove then return end
        local delta = inp.Position - dragStart
        if delta.Magnitude > RESET_TAP_THRESHOLD then hasMoved = true end
        if hasMoved and not uiLocked then
            btnFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    UIS.InputEnded:Connect(function(inp)
        if inp ~= activeInput then return end
        if inp.UserInputType ~= Enum.UserInputType.MouseButton1 and inp.UserInputType ~= Enum.UserInputType.Touch then return end
        if dragging then
            local delta = inp.Position - dragStart
            local validTap = not hasMoved and delta.Magnitude <= RESET_TAP_THRESHOLD and pointInside(inp.Position)
            if validTap then
                setActive(true)
                if _G.InstaReset and _G.InstaReset.Trigger then _G.InstaReset.Trigger() end
                task.delay(0.2, function() setActive(false) end)
            elseif not uiLocked and hasMoved then
                instaResetFloatingPos = {XScale = btnFrame.Position.X.Scale, XOffset = btnFrame.Position.X.Offset, YScale = btnFrame.Position.Y.Scale, YOffset = btnFrame.Position.Y.Offset}
                pcall(saveAllSettings)
            end
            dragging = false; hasMoved = false
            activeInput = nil
        end
    end)

    waitIntroThenEnable(panel)
    instaResetFloatingButton = panel
    return panel
end

batCounterV2Enabled = false
batCounterV2Debounce = false
batCounterV2Conn = nil
batCounterV2HitCooldown = false
BAT_COUNTER_V2_SWING_CD = 0.08
setBatCounterV2Visual = nil

local _batCounterV2OriginalTpState = false
local _batCounterV2SuppressCount = 0
local _lastBatCounterV2Time = 0
local _batCounterV2Cooldown = 0.01

local function isPlayerRagdolled(player)
    if not player or not player.Character then return false end
    local hum = player.Character:FindFirstChildOfClass("Humanoid")
    if not hum then return false end
    local state = hum:GetState()
    return state == Enum.HumanoidStateType.Physics or state == Enum.HumanoidStateType.Ragdoll or state == Enum.HumanoidStateType.FallingDown
end

local function hasAnimalEquipped(player)
    if not player or not player.Character then return false end
    for _, child in ipairs(player.Character:GetChildren()) do
        if child:IsA("Tool") then
            if child:FindFirstChild("Handle") or child.Name:find("Animal") or child.Name:find("Pet") then return true end
        end
    end
    return false
end

local function getAttackingPlayerWithAnimal()
    local myChar = LP.Character
    if not myChar then return nil end
    local myRoot = myChar:FindFirstChild("HumanoidRootPart")
    if not myRoot then return nil end
    local closest, minDist = nil, _huge
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LP and plr.Character then
            if not hasAnimalEquipped(plr) then continue end
            local tRoot = plr.Character:FindFirstChild("HumanoidRootPart")
            local hum = plr.Character:FindFirstChildOfClass("Humanoid")
            if tRoot and hum and hum.Health > 0 then
                local dist = (tRoot.Position - myRoot.Position).Magnitude
                if dist < 12 and dist < minDist then
                    minDist = dist; closest = plr
                end
            end
        end
    end
    return closest
end

local function getBatV2Counter()
    local char = LP.Character
    if not char then return nil end
    for _, child in ipairs(char:GetChildren()) do
        if child:IsA("Tool") then
            local name = child.Name:lower()
            if name:find("bat") or name:find("slap") or name:find("sword") or name:find("knife") then return child end
        end
    end
    local bp = LP:FindFirstChild("Backpack")
    if bp then
        for _, child in ipairs(bp:GetChildren()) do
            if child:IsA("Tool") then
                local name = child.Name:lower()
                if name:find("bat") or name:find("slap") or name:find("sword") or name:find("knife") then
                    child.Parent = char
                    return child
                end
            end
        end
    end
    if bp then
        for _, child in ipairs(bp:GetChildren()) do
            if child:IsA("Tool") then child.Parent = char; return child end
        end
    end
    return nil
end

local function tryHitBatCounterV2()
    if batCounterV2HitCooldown then return end
    batCounterV2HitCooldown = true
    pcall(function()
        local bat = getBatV2Counter()
        if bat then
            bat:Activate()
            local ev = bat:FindFirstChildWhichIsA("RemoteEvent")
            if ev then ev:FireServer() end
        end
    end)
    task.delay(BAT_COUNTER_V2_SWING_CD, function() batCounterV2HitCooldown = false end)
end

local function executeBatCounterV2()
    local now = _tick()
    if now - (_lastBatCounterV2Time or 0) < (_batCounterV2Cooldown or 0.01) then return end
    if batCounterV2Debounce then return end
    batCounterV2Debounce = true
    _lastBatCounterV2Time = now
    local attacker = getAttackingPlayerWithAnimal()
    if not attacker then batCounterV2Debounce = false; return end
    if isPlayerRagdolled(attacker) then batCounterV2Debounce = false; return end
    if not hasAnimalEquipped(attacker) then batCounterV2Debounce = false; return end
    _batCounterV2OriginalTpState = batDesyncTpEnabled
    local tpWasEnabled = batDesyncTpEnabled
    if not tpWasEnabled then
        startBatDesyncTp()
        if batDesyncTpSetVisual then batDesyncTpSetVisual(true) end
    end
    local function doCounterHit()
        local char = LP.Character
        if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        local attChar = attacker.Character
        if not attChar then return end
        local attRoot = attChar:FindFirstChild("HumanoidRootPart")
        if not attRoot then return end
        if not hasAnimalEquipped(attacker) then batCounterV2Debounce = false; return end
        if sethiddenproperty then sethiddenproperty(hrp, "PhysicsRepRootPart", attRoot) end
        local targetPos = attRoot.Position + _V3new(0, 0.9, 0)
        if (hrp.Position - targetPos).Magnitude > 8 then hrp.CFrame = _CFnew(targetPos) end
        tryHitBatCounterV2()
        task.delay(0.05, function() tryHitBatCounterV2() end)
        task.delay(0.1, function() tryHitBatCounterV2() end)
    end
    doCounterHit()
    task.delay(0.2, function()
        if not _batCounterV2OriginalTpState and batDesyncTpEnabled then
            stopBatDesyncTp()
            if batDesyncTpSetVisual then batDesyncTpSetVisual(false) end
        end
        batCounterV2Debounce = false
    end)
end

function stopBatCounterV2()
    if batCounterV2Conn then
        batCounterV2Conn:Disconnect()
        batCounterV2Conn = nil
    end
    batCounterV2Debounce = false
    batCounterV2HitCooldown = false
end

function startBatCounterV2()
    if batCounterV2Conn then return end
    batCounterV2Conn = RunService.Heartbeat:Connect(function()
        if not batCounterV2Enabled then return end
        if batCounterV2Debounce then return end
        local character = LP.Character
        if not character then return end
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if not humanoid or humanoid.Health <= 0 then return end
        local state = humanoid:GetState()
        local isBeingAttacked = state == Enum.HumanoidStateType.Physics or
                               state == Enum.HumanoidStateType.Ragdoll or
                               state == Enum.HumanoidStateType.FallingDown or
                               state == Enum.HumanoidStateType.GettingUp or
                               state == Enum.HumanoidStateType.Stunned
        if isBeingAttacked then
            local attacker = getAttackingPlayerWithAnimal()
            if attacker then
                if not isPlayerRagdolled(attacker) then
                    if hasAnimalEquipped(attacker) then
                        executeBatCounterV2()
                    end
                end
            end
        end
    end)
end

function toggleBatCounterV2()
    batCounterV2Enabled = not batCounterV2Enabled
    if batCounterV2Enabled then startBatCounterV2() else stopBatCounterV2() end
    return batCounterV2Enabled
end

function updateUIFromLoaded()
    task.wait()
    if normalBox then normalBox.Text = tostring(NS) end
    if carryBox then carryBox.Text = tostring(CS) end
    if radInput then radInput.Text = tostring(CONFIG.STEAL_RANGE) end
    if laggerBox then laggerBox.Text = tostring(LAGGER_SPEED) end
    if lagger2Box then lagger2Box.Text = tostring(LAGGER_CARRY_SPEED) end
    if batSpeedBox then batSpeedBox.Text = tostring(BAT_AIMBOT_SPEED) end
    if uiScaleBox then uiScaleBox.Text = tostring(uiScaleValue) end
    if dropModeBtnRef then dropModeBtnRef.Text = dropMode == 1 and "Fling" or "Jump Drop" end
    if bodyLockRangeBox then bodyLockRangeBox.Text = tostring(bodyLockRange) end
    refreshSpeedModeLabel()

    for _, ref in ipairs(keyButtonRefs) do
        local entry = ref.entry
        local label = (entry.gp and entry.gp.Name) or (entry.kb and entry.kb.Name) or "None"
        ref.btn.Text = label
    end

    if savedProgressBarPos and pbFrame then
        pbFrame.Position = UDim2.new(savedProgressBarPos.XScale or 0.5, savedProgressBarPos.XOffset or -160, savedProgressBarPos.YScale or 0.80, savedProgressBarPos.YOffset or 0)
    end

    if backgroundMode ~= "None" and (not backgroundImageTransparency or backgroundImageTransparency >= 0.99) then
        backgroundImageTransparency = 0
    end
    applyBackgroundMode(backgroundMode)
    if applyButtonBackgroundMode then pcall(applyButtonBackgroundMode, buttonBgMode) end
    applyFloatingButtonScale()

    if uiLocked and setLockUIVisual then setLockUIVisual(true) end

    if antiRagdollMode == "v2" then
        if setAntiRagVisual then setAntiRagVisual(true) end
        startAntiRagdollV2()
    else
        if setAntiRagVisual then setAntiRagVisual(false) end
    end

    if antiDieEnabled then
        if setAntiDieVisual then setAntiDieVisual(true) end
        AntiDieModule.start()
    else
        if setAntiDieVisual then setAntiDieVisual(false) end
    end

    if antiBatEnabled then
        if setAntiBatVisual then setAntiBatVisual(true) end
        startAntiBat()
    else
        if setAntiBatVisual then setAntiBatVisual(false) end
    end

    if antiFlingEnabled then
        if setAntiFlingVisual then setAntiFlingVisual(true) end
        startAntiFling()
    else
        if setAntiFlingVisual then setAntiFlingVisual(false) end
        stopAntiFling()
    end

    if CONFIG.AUTO_STEAL_ENABLED and setInstaGrab then setInstaGrab(true); pcall(startAutoSteal) end

    if medusaCounterEnabled then
        if setMedusaVisual then setMedusaVisual(true) end
        if LP.Character then setupMedusaCounter(LP.Character) end
    else
        if setMedusaVisual then setMedusaVisual(false) end
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
        task.spawn(function() task.wait(0.5); startUnwalk() end)
    end
    if antiLagEnabled then
        if setAntiLagVisual then setAntiLagVisual(true) end
        enableAntiLag()
    else
        if setAntiLagVisual then setAntiLagVisual(false) end
        disableAntiLag()
    end
    if customSoundsEnabled then
        if setCustomSoundsVisual then setCustomSoundsVisual(true) end
        if _G.EliteFamilyCustomSounds then _G.EliteFamilyCustomSounds.setEnabled(true) end
    else
        if setCustomSoundsVisual then setCustomSoundsVisual(false) end
        if _G.EliteFamilyCustomSounds then _G.EliteFamilyCustomSounds.setEnabled(false) end
    end
    if espEnabled then
        toggleESP(true)
        if setESPVIsual then setESPVIsual(true) end
    else
        toggleESP(false)
        if setESPVIsual then setESPVIsual(false) end
    end
    if espLineEnabled then
        if setESPLineVisual then setESPLineVisual(true) end
        startESPLine()
    else
        if setESPLineVisual then setESPLineVisual(false) end
        stopESPLine()
    end

    if vividGraphicsEnabled then
        enableVividGraphics()
        if setVividVisual then setVividVisual(true) end
    else
        disableVividGraphics()
        if setVividVisual then setVividVisual(false) end
    end

    if batDesyncTpEnabled then
        if batDesyncTpSetVisual then batDesyncTpSetVisual(true) end
        if not batDesyncTpConn then startBatDesyncTp() end
        updateTpBatButtonWithAntiDie(true)
    else
        if batDesyncTpSetVisual then batDesyncTpSetVisual(false) end
        updateTpBatButtonWithAntiDie(false)
    end

    if autoBatV2Enabled then
        if autoBatV2SetVisual then autoBatV2SetVisual(true) end
        if not _batV2Conn then startBatV2Aimbot() end
        if batV2FloatingButton then
            local btnFrame = batV2FloatingButton:FindFirstChild("Frame")
            if btnFrame then paintFloatingBtn(btnFrame, true) end
        end
    else
        if autoBatV2SetVisual then autoBatV2SetVisual(false) end
        if batV2FloatingButton then
            local btnFrame = batV2FloatingButton:FindFirstChild("Frame")
            if btnFrame then paintFloatingBtn(btnFrame, false) end
        end
    end

    if stretchEnabled then
        enableStretch()
        if _G.stretchToggleSetter then _G.stretchToggleSetter(true) end
    else
        if _G.stretchToggleSetter then _G.stretchToggleSetter(false) end
    end

    if mobSetAutoBat then mobSetAutoBat(autoBatEnabled) end
    if mobSetAutoLeft then mobSetAutoLeft(autoLeftEnabled) end
    if mobSetAutoRight then mobSetAutoRight(autoRightEnabled) end
    if mobSetCarry then mobSetCarry(speedMode) end
    if mobSetLagger1 then mobSetLagger1(laggerToggled) end
    if mobSetLagger2 then mobSetLagger2(laggerCarryToggled) end

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

    pcall(function() applyOutfitByIndex(currentOutfitIndex) end)
    if outfitSelectorLabel then outfitSelectorLabel.Text = OUTFITS[currentOutfitIndex].label end
    if katanaSkinEnabled then
        task.defer(function() pcall(function() katanaSkinController.ApplySkin("KATANA") end) end)
    end
    if minecraftBatSkinEnabled then
        minecraftBatSkinController.State.enabled = true
        minecraftBatSkinController.SetColorMode(minecraftBatSkinColorMode)
        task.defer(function() pcall(minecraftBatSkinController.Apply) end)
    end
end



-- ============================================================
-- ELITE PING LAGGER + ELITE BYPASS (panels inspired by Bubble Hub)
-- ============================================================
do
    local HttpService = game:GetService("HttpService")
    local TweenService = game:GetService("TweenService")
    local RunService = game:GetService("RunService")
    local UIS = game:GetService("UserInputService")
    local CoreGui = game:GetService("CoreGui")

    local function parentGui(gui)
        pcall(function() if syn and syn.protect_gui then syn.protect_gui(gui) end end)
        local ok = pcall(function() gui.Parent = CoreGui end)
        if not ok then gui.Parent = LP:WaitForChild("PlayerGui") end
    end

    local function corner(obj, r)
        local c = Instance.new("UICorner")
        c.CornerRadius = UDim.new(0, r or 10)
        c.Parent = obj
        return c
    end

    local function stroke(obj, col, th, tr)
        local s = Instance.new("UIStroke")
        s.Color = col or Color3.fromRGB(80, 140, 255)
        s.Thickness = th or 1.2
        s.Transparency = tr or 0.35
        s.Parent = obj
        return s
    end

    local function makeDraggable(frame)
        local dragging, start, startPos
        frame.InputBegan:Connect(function(input)
            if uiLocked then return end
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                start = input.Position
                startPos = frame.Position
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then dragging = false end
                end)
            end
        end)
        UIS.InputChanged:Connect(function(input)
            if not dragging then return end
            if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                local d = input.Position - start
                frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
            end
        end)
    end

    -- --------------- ELITE PING LAGGER ---------------
    local lagState = {
        enabled = false,
        lowEnd = false,
        power = 40,
        conn = nil,
        lowConn = nil,
    }

    local function stopMainLag()
        if lagState.conn then pcall(function() lagState.conn:Disconnect() end); lagState.conn = nil end
        lagState.enabled = false
        pcall(function() game:GetService("NetworkClient"):SetOutgoingKBPSLimit(math.huge) end)
    end

    local function stopLowEndLag()
        if lagState.lowConn then pcall(function() lagState.lowConn:Disconnect() end); lagState.lowConn = nil end
        lagState.lowEnd = false
        pcall(function() game:GetService("NetworkClient"):SetOutgoingKBPSLimit(math.huge) end)
    end

    local function startMainLag()
        stopLowEndLag()
        stopMainLag()
        lagState.enabled = true
        local power = math.clamp(tonumber(lagState.power) or 40, 5, 200)
        -- Lower outgoing bandwidth creates artificial lag spikes
        pcall(function() game:GetService("NetworkClient"):SetOutgoingKBPSLimit(math.max(1, math.floor(80 / power * 10))) end)
        lagState.conn = RunService.Heartbeat:Connect(function()
            if not lagState.enabled then return end
            local char = LP.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            if not root then return end
            -- Micro stutter proportional to power
            if tick() % (0.08 + (200 - power) * 0.001) < 0.02 then
                pcall(function()
                    root.AssemblyLinearVelocity = root.AssemblyLinearVelocity * (1 - power * 0.002)
                end)
            end
        end)
    end

    local function startLowEndLag()
        stopMainLag()
        stopLowEndLag()
        lagState.lowEnd = true
        pcall(function() game:GetService("NetworkClient"):SetOutgoingKBPSLimit(2) end)
        lagState.lowConn = RunService.Heartbeat:Connect(function()
            if not lagState.lowEnd then return end
            pcall(function() game:GetService("NetworkClient"):SetOutgoingKBPSLimit(2) end)
        end)
    end

    local lagGui, lagMain, lagStatusLbl, lagPowerBox

    local function refreshLagVisual()
        if lagStatusLbl then
            if lagState.enabled then
                lagStatusLbl.Text = "STATUS: LAG ON"
                lagStatusLbl.TextColor3 = Color3.fromRGB(120, 255, 140)
            elseif lagState.lowEnd then
                lagStatusLbl.Text = "STATUS: LOW-END ON"
                lagStatusLbl.TextColor3 = Color3.fromRGB(255, 210, 90)
            else
                lagStatusLbl.Text = "STATUS: OFF"
                lagStatusLbl.TextColor3 = Color3.fromRGB(180, 190, 210)
            end
        end
    end

    local function buildElitePingLagger()
        pcall(function()
            local old = CoreGui:FindFirstChild("ElitePingLaggerGUI")
            if old then old:Destroy() end
            local pg = LP:FindFirstChild("PlayerGui")
            if pg then local o = pg:FindFirstChild("ElitePingLaggerGUI"); if o then o:Destroy() end end
        end)

        lagGui = Instance.new("ScreenGui")
        lagGui.Name = "ElitePingLaggerGUI"
        lagGui.ResetOnSpawn = false
        lagGui.IgnoreGuiInset = true
        lagGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        lagGui.DisplayOrder = 50
        parentGui(lagGui)

        lagMain = Instance.new("Frame", lagGui)
        lagMain.Name = "MainFrame"
        lagMain.Size = UDim2.fromOffset(300, 250)
        lagMain.Position = UDim2.new(0.5, -150, 0.5, -125)
        lagMain.BackgroundColor3 = Color3.fromRGB(8, 12, 22)
        lagMain.BorderSizePixel = 0
        lagMain.Visible = false
        corner(lagMain, 12)
        stroke(lagMain, Color3.fromRGB(70, 130, 255), 1.3, 0.25)
        makeDraggable(lagMain)

        local title = Instance.new("TextLabel", lagMain)
        title.Size = UDim2.new(1, -40, 0, 34)
        title.Position = UDim2.new(0, 12, 0, 6)
        title.BackgroundTransparency = 1
        title.Text = "ELITE PING LAGGER"
        title.TextColor3 = Color3.fromRGB(200, 230, 255)
        title.Font = Enum.Font.GothamBlack
        title.TextSize = 16
        title.TextXAlignment = Enum.TextXAlignment.Left

        local close = Instance.new("TextButton", lagMain)
        close.Size = UDim2.fromOffset(28, 28)
        close.Position = UDim2.new(1, -34, 0, 6)
        close.BackgroundTransparency = 1
        close.Text = "×"
        close.TextColor3 = Color3.fromRGB(200, 210, 230)
        close.Font = Enum.Font.GothamBold
        close.TextSize = 20
        close.MouseButton1Click:Connect(function() lagMain.Visible = false end)

        lagStatusLbl = Instance.new("TextLabel", lagMain)
        lagStatusLbl.Size = UDim2.new(1, -24, 0, 22)
        lagStatusLbl.Position = UDim2.new(0, 12, 0, 42)
        lagStatusLbl.BackgroundTransparency = 1
        lagStatusLbl.Text = "STATUS: OFF"
        lagStatusLbl.TextColor3 = Color3.fromRGB(180, 190, 210)
        lagStatusLbl.Font = Enum.Font.GothamBold
        lagStatusLbl.TextSize = 12
        lagStatusLbl.TextXAlignment = Enum.TextXAlignment.Left

        local function mkBtn(text, y, cb)
            local b = Instance.new("TextButton", lagMain)
            b.Size = UDim2.new(1, -24, 0, 32)
            b.Position = UDim2.new(0, 12, 0, y)
            b.BackgroundColor3 = Color3.fromRGB(18, 32, 58)
            b.BorderSizePixel = 0
            b.Text = text
            b.TextColor3 = Color3.fromRGB(230, 240, 255)
            b.Font = Enum.Font.GothamBold
            b.TextSize = 13
            b.AutoButtonColor = false
            corner(b, 8)
            stroke(b, Color3.fromRGB(60, 110, 200), 1, 0.4)
            b.MouseButton1Click:Connect(cb)
            return b
        end

        mkBtn("TOGGLE LAG", 70, function()
            if lagState.enabled then stopMainLag() else startMainLag() end
            refreshLagVisual()
        end)
        mkBtn("TOGGLE LOW-END", 108, function()
            if lagState.lowEnd then stopLowEndLag() else startLowEndLag() end
            refreshLagVisual()
        end)

        local powerRow = Instance.new("Frame", lagMain)
        powerRow.Size = UDim2.new(1, -24, 0, 32)
        powerRow.Position = UDim2.new(0, 12, 0, 150)
        powerRow.BackgroundTransparency = 1
        local pl = Instance.new("TextLabel", powerRow)
        pl.Size = UDim2.new(0.5, 0, 1, 0)
        pl.BackgroundTransparency = 1
        pl.Text = "Power"
        pl.TextColor3 = Color3.fromRGB(200, 210, 230)
        pl.Font = Enum.Font.GothamBold
        pl.TextSize = 13
        pl.TextXAlignment = Enum.TextXAlignment.Left
        lagPowerBox = Instance.new("TextBox", powerRow)
        lagPowerBox.Size = UDim2.new(0, 70, 0, 26)
        lagPowerBox.Position = UDim2.new(1, -70, 0.5, -13)
        lagPowerBox.BackgroundColor3 = Color3.fromRGB(14, 24, 44)
        lagPowerBox.BorderSizePixel = 0
        lagPowerBox.Text = tostring(lagState.power)
        lagPowerBox.TextColor3 = Color3.fromRGB(255, 255, 255)
        lagPowerBox.Font = Enum.Font.GothamBold
        lagPowerBox.TextSize = 12
        lagPowerBox.ClearTextOnFocus = false
        corner(lagPowerBox, 6)
        lagPowerBox.FocusLost:Connect(function()
            local n = tonumber(lagPowerBox.Text)
            if n then
                lagState.power = math.clamp(math.floor(n), 5, 200)
                lagPowerBox.Text = tostring(lagState.power)
                if lagState.enabled then startMainLag() end
            else
                lagPowerBox.Text = tostring(lagState.power)
            end
        end)

        mkBtn("STOP ALL", 192, function()
            stopMainLag(); stopLowEndLag(); refreshLagVisual()
        end)

        refreshLagVisual()
    end

    -- --------------- ELITE BYPASS ---------------
    local bypState = {
        enabled = false,
        autoSteal = false,
        power = 150000,
        version = "V1",
        mode = "PC",
        conn = nil,
        stealConn = nil,
    }

    local function stopBypass()
        if bypState.conn then pcall(function() bypState.conn:Disconnect() end); bypState.conn = nil end
        bypState.enabled = false
    end

    local function startBypass()
        stopBypass()
        bypState.enabled = true
        local power = math.clamp(tonumber(bypState.power) or 150000, 10000, 300000)
        bypState.conn = RunService.Heartbeat:Connect(function()
            if not bypState.enabled then return end
            local char = LP.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            if not root then return end
            -- Depth / desync impulse (Bubble-style high power)
            pcall(function()
                if bypState.version == "V2" then
                    root.AssemblyLinearVelocity = root.AssemblyLinearVelocity + Vector3.new(0, -math.min(power / 5000, 40), 0)
                else
                    if sethiddenproperty then
                        sethiddenproperty(root, "NetworkIsSleeping", false)
                    end
                    local v = root.AssemblyLinearVelocity
                    root.AssemblyLinearVelocity = Vector3.new(v.X, math.clamp(v.Y - (power / 80000), -120, 120), v.Z)
                end
            end)
        end)
    end

    local bypGui, bypMain, bypStatusLbl, bypPowerBox, bypVerBtn, bypAutoBtn

    local function refreshBypVisual()
        if bypStatusLbl then
            bypStatusLbl.Text = bypState.enabled and "STATUS: BYPASS ON" or "STATUS: OFF"
            bypStatusLbl.TextColor3 = bypState.enabled and Color3.fromRGB(120, 255, 140) or Color3.fromRGB(180, 190, 210)
        end
        if bypVerBtn then bypVerBtn.Text = "VERSION: " .. bypState.version end
        if bypAutoBtn then
            bypAutoBtn.Text = bypState.autoSteal and "AUTO ON STEAL: ON" or "AUTO ON STEAL: OFF"
        end
    end

    local function buildEliteBypass()
        pcall(function()
            local old = CoreGui:FindFirstChild("EliteBypassGUI")
            if old then old:Destroy() end
            local pg = LP:FindFirstChild("PlayerGui")
            if pg then local o = pg:FindFirstChild("EliteBypassGUI"); if o then o:Destroy() end end
        end)

        bypGui = Instance.new("ScreenGui")
        bypGui.Name = "EliteBypassGUI"
        bypGui.ResetOnSpawn = false
        bypGui.IgnoreGuiInset = true
        bypGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        bypGui.DisplayOrder = 51
        parentGui(bypGui)

        bypMain = Instance.new("Frame", bypGui)
        bypMain.Name = "MainFrame"
        bypMain.Size = UDim2.fromOffset(300, 230)
        bypMain.Position = UDim2.new(0.5, -150, 0.35, -80)
        bypMain.BackgroundColor3 = Color3.fromRGB(9, 24, 52)
        bypMain.BorderSizePixel = 0
        bypMain.Visible = false
        corner(bypMain, 12)
        stroke(bypMain, Color3.fromRGB(100, 180, 255), 1.3, 0.25)
        makeDraggable(bypMain)

        local title = Instance.new("TextLabel", bypMain)
        title.Size = UDim2.new(1, -40, 0, 34)
        title.Position = UDim2.new(0, 12, 0, 6)
        title.BackgroundTransparency = 1
        title.Text = "ELITE BYPASS"
        title.TextColor3 = Color3.fromRGB(200, 230, 255)
        title.Font = Enum.Font.GothamBlack
        title.TextSize = 16
        title.TextXAlignment = Enum.TextXAlignment.Left

        local close = Instance.new("TextButton", bypMain)
        close.Size = UDim2.fromOffset(28, 28)
        close.Position = UDim2.new(1, -34, 0, 6)
        close.BackgroundTransparency = 1
        close.Text = "×"
        close.TextColor3 = Color3.fromRGB(200, 210, 230)
        close.Font = Enum.Font.GothamBold
        close.TextSize = 20
        close.MouseButton1Click:Connect(function() bypMain.Visible = false end)

        bypStatusLbl = Instance.new("TextLabel", bypMain)
        bypStatusLbl.Size = UDim2.new(1, -24, 0, 22)
        bypStatusLbl.Position = UDim2.new(0, 12, 0, 40)
        bypStatusLbl.BackgroundTransparency = 1
        bypStatusLbl.Text = "STATUS: OFF"
        bypStatusLbl.TextColor3 = Color3.fromRGB(180, 190, 210)
        bypStatusLbl.Font = Enum.Font.GothamBold
        bypStatusLbl.TextSize = 12
        bypStatusLbl.TextXAlignment = Enum.TextXAlignment.Left

        local function mkBtn(text, y, cb)
            local b = Instance.new("TextButton", bypMain)
            b.Size = UDim2.new(1, -24, 0, 30)
            b.Position = UDim2.new(0, 12, 0, y)
            b.BackgroundColor3 = Color3.fromRGB(16, 40, 78)
            b.BorderSizePixel = 0
            b.Text = text
            b.TextColor3 = Color3.fromRGB(230, 240, 255)
            b.Font = Enum.Font.GothamBold
            b.TextSize = 12
            b.AutoButtonColor = false
            corner(b, 8)
            stroke(b, Color3.fromRGB(70, 140, 230), 1, 0.4)
            b.MouseButton1Click:Connect(cb)
            return b
        end

        mkBtn("TOGGLE BYPASS", 68, function()
            if bypState.enabled then stopBypass() else startBypass() end
            refreshBypVisual()
        end)

        bypAutoBtn = mkBtn("AUTO ON STEAL: OFF", 104, function()
            bypState.autoSteal = not bypState.autoSteal
            refreshBypVisual()
        end)

        bypVerBtn = mkBtn("VERSION: V1", 140, function()
            bypState.version = bypState.version == "V1" and "V2" or "V1"
            if bypState.enabled then startBypass() end
            refreshBypVisual()
        end)

        local powerRow = Instance.new("Frame", bypMain)
        powerRow.Size = UDim2.new(1, -24, 0, 30)
        powerRow.Position = UDim2.new(0, 12, 0, 178)
        powerRow.BackgroundTransparency = 1
        local pl = Instance.new("TextLabel", powerRow)
        pl.Size = UDim2.new(0.5, 0, 1, 0)
        pl.BackgroundTransparency = 1
        pl.Text = "Power"
        pl.TextColor3 = Color3.fromRGB(200, 210, 230)
        pl.Font = Enum.Font.GothamBold
        pl.TextSize = 13
        pl.TextXAlignment = Enum.TextXAlignment.Left
        bypPowerBox = Instance.new("TextBox", powerRow)
        bypPowerBox.Size = UDim2.new(0, 90, 0, 26)
        bypPowerBox.Position = UDim2.new(1, -90, 0.5, -13)
        bypPowerBox.BackgroundColor3 = Color3.fromRGB(14, 28, 55)
        bypPowerBox.BorderSizePixel = 0
        bypPowerBox.Text = tostring(bypState.power)
        bypPowerBox.TextColor3 = Color3.fromRGB(255, 255, 255)
        bypPowerBox.Font = Enum.Font.GothamBold
        bypPowerBox.TextSize = 12
        bypPowerBox.ClearTextOnFocus = false
        corner(bypPowerBox, 6)
        bypPowerBox.FocusLost:Connect(function()
            local n = tonumber(bypPowerBox.Text)
            if n then
                bypState.power = math.clamp(math.floor(n), 10000, 300000)
                bypPowerBox.Text = tostring(bypState.power)
                if bypState.enabled then startBypass() end
            else
                bypPowerBox.Text = tostring(bypState.power)
            end
        end)

        refreshBypVisual()
    end

    -- Public API
    _G.ElitePingLagger = {
        Open = function()
            if not lagMain then buildElitePingLagger() end
            lagMain.Visible = true
        end,
        ToggleVisible = function()
            if not lagMain then buildElitePingLagger() end
            lagMain.Visible = not lagMain.Visible
        end,
        SetEnabled = function(on)
            if on then startMainLag() else stopMainLag() end
            refreshLagVisual()
        end,
        Stop = function() stopMainLag(); stopLowEndLag(); refreshLagVisual() end,
        IsEnabled = function() return lagState.enabled end,
    }

    _G.EliteBypass = {
        Open = function()
            if not bypMain then buildEliteBypass() end
            bypMain.Visible = true
        end,
        ToggleVisible = function()
            if not bypMain then buildEliteBypass() end
            bypMain.Visible = not bypMain.Visible
        end,
        SetBypass = function(on)
            if on then startBypass() else stopBypass() end
            refreshBypVisual()
        end,
        Stop = function() stopBypass(); refreshBypVisual() end,
        IsEnabled = function() return bypState.enabled end,
        SetAutoOnSteal = function(on) bypState.autoSteal = on == true; refreshBypVisual() end,
    }

    -- Build panels at startup (hidden)
    task.defer(function()
        pcall(buildElitePingLagger)
        pcall(buildEliteBypass)
    end)

    -- Auto-on-steal watcher for bypass
    task.spawn(function()
        while task.wait(0.15) do
            if not bypState.autoSteal then continue end
            local stealing = (_G.isStealing == true) or (CONFIG and CONFIG.AUTO_STEAL_ENABLED and _G.StealBar)
            -- If auto steal active flag exists in this hub
            if type(isStealing) == "boolean" and isStealing then
                if not bypState.enabled then startBypass(); refreshBypVisual() end
            end
        end
    end)
end



-- ============================================================
-- ANTI E01 (from 404 Family) — floating head countdown when carrying
-- ============================================================
do
    local wasCarrying = false
    local currentUI = nil
    local currentUpdater = nil
    local antiE01Enabled = true

    local function isCarryingBrainrot()
        local char = LP.Character
        if not char then return false end
        for _, child in pairs(char:GetChildren()) do
            local name = child.Name:lower()
            if name:find("brainrot") or name:find("brain") or name:find("animal")
                or name:find("carry") or name:find("stolen") or name:find("held")
                or name:find("steal") then
                return true
            end
        end
        for attrName, attrValue in pairs(char:GetAttributes()) do
            local name = attrName:lower()
            if (name:find("carrying") or name:find("carry") or name:find("stealing")
                or name:find("isstealing") or name:find("hasbrainrot")) and attrValue == true then
                return true
            end
        end
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        if humanoid and humanoid.WalkSpeed > 0 and humanoid.WalkSpeed <= 25 and humanoid.WalkSpeed ~= 16 then
            return true
        end
        return false
    end

    local function startE01HeadCountdown()
        if currentUpdater then
            pcall(function() currentUpdater:Disconnect() end)
            currentUpdater = nil
        end
        if currentUI then
            pcall(function() currentUI:Destroy() end)
            currentUI = nil
        end

        local screenGui = Instance.new("ScreenGui")
        screenGui.Name = "EliteFamily_E01_Warning"
        screenGui.ResetOnSpawn = false
        screenGui.IgnoreGuiInset = true
        screenGui.DisplayOrder = 100
        screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        local parented = pcall(function()
            screenGui.Parent = game:GetService("CoreGui")
        end)
        if not parented then
            screenGui.Parent = LP:WaitForChild("PlayerGui")
        end
        currentUI = screenGui

        local frame = Instance.new("Frame")
        frame.Name = "E01Billboard"
        frame.Size = UDim2.new(0, 180, 0, 50)
        frame.Position = UDim2.new(0.5, -90, 0.5, -60)
        frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        frame.BackgroundTransparency = 0.3
        frame.BorderSizePixel = 0
        frame.Visible = false
        frame.ZIndex = 5
        frame.Parent = screenGui
        Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)

        local stroke = Instance.new("UIStroke")
        stroke.Color = Color3.fromRGB(255, 70, 70)
        stroke.Thickness = 1.5
        stroke.Transparency = 0.15
        stroke.Parent = frame

        local title = Instance.new("TextLabel")
        title.Size = UDim2.new(1, -8, 0, 25)
        title.Position = UDim2.new(0, 4, 0, 3)
        title.BackgroundTransparency = 1
        title.Text = "E01 WARNING"
        title.TextColor3 = Color3.fromRGB(255, 255, 255)
        title.Font = Enum.Font.GothamBlack
        title.TextSize = 14
        title.TextXAlignment = Enum.TextXAlignment.Center
        title.TextYAlignment = Enum.TextYAlignment.Center
        title.ZIndex = 6
        title.Parent = frame

        local subText = Instance.new("TextLabel")
        subText.Size = UDim2.new(1, -8, 0, 16)
        subText.Position = UDim2.new(0, 4, 0, 27)
        subText.BackgroundTransparency = 1
        subText.Text = "Stay out of their base: 3.00s"
        subText.TextColor3 = Color3.fromRGB(255, 200, 0)
        subText.Font = Enum.Font.GothamBold
        subText.TextSize = 9
        subText.TextXAlignment = Enum.TextXAlignment.Center
        subText.TextYAlignment = Enum.TextYAlignment.Center
        subText.TextTruncate = Enum.TextTruncate.AtEnd
        subText.ZIndex = 6
        subText.Parent = frame

        local progressBar = Instance.new("Frame")
        progressBar.Name = "Progress"
        progressBar.Size = UDim2.new(0, 0, 0, 3)
        progressBar.Position = UDim2.new(0, 0, 1, -3)
        progressBar.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
        progressBar.BorderSizePixel = 0
        progressBar.ZIndex = 7
        progressBar.Parent = frame
        Instance.new("UICorner", progressBar).CornerRadius = UDim.new(0, 2)

        local duration = 3.0
        local startTime = tick()
        local safeShownAt = nil
        local connection

        connection = RunService.RenderStepped:Connect(function()
            if currentUI ~= screenGui or not screenGui.Parent or not frame.Parent then
                if connection then connection:Disconnect() end
                if currentUpdater == connection then currentUpdater = nil end
                return
            end

            local character = LP.Character
            local head = character and character:FindFirstChild("Head")
            local cam = workspace.CurrentCamera
            if not head or not cam then
                frame.Visible = false
                return
            end

            local screenPosition, onScreen = cam:WorldToScreenPoint(head.Position)
            if not onScreen then
                frame.Visible = false
            else
                frame.Position = UDim2.new(
                    0,
                    screenPosition.X - frame.AbsoluteSize.X / 2,
                    0,
                    screenPosition.Y - frame.AbsoluteSize.Y - 8
                )
                frame.Visible = true
            end

            local elapsed = tick() - startTime
            local remaining = math.max(0, duration - elapsed)
            local progress = math.clamp(elapsed / duration, 0, 1)
            progressBar.Size = UDim2.new(progress, 0, 0, 3)

            if elapsed < duration then
                local color = (progress < 0.5) and Color3.fromRGB(255, 60, 60) or Color3.fromRGB(255, 190, 0)
                stroke.Color = color
                progressBar.BackgroundColor3 = color
                subText.Text = string.format("Stay out of their base: %.2fs", remaining)
                subText.TextColor3 = Color3.fromRGB(255, 200, 0)
            elseif not safeShownAt then
                safeShownAt = tick()
                title.Text = "E01 SAFE"
                subText.Text = "You can steal now"
                subText.TextColor3 = Color3.fromRGB(100, 255, 120)
                stroke.Color = Color3.fromRGB(100, 255, 120)
                progressBar.BackgroundColor3 = Color3.fromRGB(100, 255, 120)
                progressBar.Size = UDim2.new(1, 0, 0, 3)
                TS:Create(frame, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                    Size = UDim2.new(0, 190, 0, 54),
                }):Play()
            elseif tick() - safeShownAt >= 3 then
                if connection then connection:Disconnect() end
                if currentUpdater == connection then currentUpdater = nil end
                if currentUI == screenGui then
                    screenGui:Destroy()
                    currentUI = nil
                end
            end
        end)
        currentUpdater = connection
    end

    task.spawn(function()
        while task.wait(0.1) do
            if antiE01Enabled then
                local currentlyCarrying = isCarryingBrainrot()
                if not wasCarrying and currentlyCarrying then
                    startE01HeadCountdown()
                end
                wasCarrying = currentlyCarrying
            else
                wasCarrying = false
            end
        end
    end)

    _G.EliteFamilyAntiE01 = {
        SetEnabled = function(on) antiE01Enabled = on == true end,
        IsEnabled = function() return antiE01Enabled end,
    }
end


-- =====================================================================
-- ARRANQUE BLINDADO
-- =====================================================================
local _bootErrors = {}

local function _bootSection(name, fn)
    print("[ELITE FAMILY Boot] Iniciando:", name)
    local ok, err = pcall(fn)
    if not ok then
        print("[ELITE FAMILY Boot] FALLÓ:", name, tostring(err))
        table.insert(_bootErrors, {name = name, err = tostring(err)})
        warn("[ELITE FAMILY Boot] Error en '" .. name .. "': " .. tostring(err))
    else
        print("[ELITE FAMILY Boot] OK:", name)
    end
    return ok
end

_bootSection("buildGui", function()
    buildGui()
end)

if gui and main then
    _bootSection("loadAllSettings", function()
        if loadAllSettings() then
            updateUIFromLoaded()
        end
    end)

    _bootSection("createMobilePanel", function()
        MobilePanel = createMobilePanel()
    end)

    _bootSection("createTpBatFloatingButton", function()
        tpBatFloatingButton = createTpBatFloatingButton()
    end)

    _bootSection("createBatV2FloatingButton", function()
        batV2FloatingButton = createBatV2FloatingButton()
    end)

    _bootSection("createInstaResetFloatingButton", function()
        instaResetFloatingButton = createInstaResetFloatingButton()
    end)

    -- Durante la intro: solo se ve la intro. Al terminar o SKIP se muestran botones/menú.
    _bootSection("scheduleRevealAfterIntro", function()
        scheduleRevealAfterIntro()
    end)

    if hideButtonsEnabled then
        _bootSection("applyHideButtons", function()
            applyHideButtons(true)
            if setHideButtonsVisual then setHideButtonsVisual(true) end
        end)
    end

    _bootSection("localizeEliteFamilyInterface", function()
        if gui then localizeEliteFamilyInterface(gui) end
        if MobilePanel then localizeEliteFamilyInterface(MobilePanel) end
        if tpBatFloatingButton then localizeEliteFamilyInterface(tpBatFloatingButton) end
        if batV2FloatingButton then localizeEliteFamilyInterface(batV2FloatingButton) end
        if instaResetFloatingButton then localizeEliteFamilyInterface(instaResetFloatingButton) end
    end)

    if LP.Character then
        task.spawn(function()
            task.wait(0.1)
            if waitForCharReady(LP.Character, 5) then
                pcall(function() captureOriginalAppearance(LP.Character) end)
                pcall(function() setupMovementAndIndicators(LP.Character) end)
                if currentAnimPack ~= "Off" then
                    pcall(function() startAnimPack(currentAnimPack) end)
                end
                pcall(function() applyOutfitByIndex(currentOutfitIndex) end)
            end
        end)
    end

    if #_bootErrors > 0 then
        task.defer(function()
            pcall(function()
                local env = (getgenv and getgenv()) or _G
                local writeFn = env.writefile or (syn and syn.writefile)
                if type(writeFn) == "function" then
                    local log = "[ELITE FAMILY Boot Errors] " .. os.date("%Y-%m-%d %H:%M:%S") .. "\n"
                    for _, e in ipairs(_bootErrors) do
                        log = log .. e.name .. ": " .. e.err .. "\n"
                    end
                    pcall(writeFn, "EliteFamily_boot_errors.txt", log)
                    warn("[ELITE FAMILY] Errores escritos a EliteFamily_boot_errors.txt")
                end
            end)
        end)

        task.defer(function()
            pcall(function()
                local errGui = Instance.new("ScreenGui")
                errGui.Name = "EliteFamilyBootErrors"
                errGui.ResetOnSpawn = false
                errGui.DisplayOrder = 999
                local okCg, cg = pcall(function() return game:GetService("CoreGui") end)
                if okCg and cg then
                    pcall(function() errGui.Parent = cg end)
                end
                if not errGui.Parent then errGui.Parent = LP:WaitForChild("PlayerGui") end

                local frame = Instance.new("Frame", errGui)
                frame.Size = UDim2.new(0, 460, 0, 60 + #_bootErrors * 22)
                frame.Position = UDim2.new(0, 10, 1, -80 - #_bootErrors * 22)
                frame.BackgroundColor3 = Color3.fromRGB(40, 10, 15)
                frame.BorderSizePixel = 0
                Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)
                local stroke = Instance.new("UIStroke", frame)
                stroke.Color = Color3.fromRGB(255, 80, 90)
                stroke.Thickness = 1.5

                local title = Instance.new("TextLabel", frame)
                title.Size = UDim2.new(1, -20, 0, 24)
                title.Position = UDim2.new(0, 10, 0, 8)
                title.BackgroundTransparency = 1
                title.Text = "⚠ ELITE FAMILY: " .. #_bootErrors .. " sección(es) fallaron"
                title.TextColor3 = Color3.fromRGB(255, 100, 110)
                title.Font = Enum.Font.GothamBold
                title.TextSize = 13
                title.TextXAlignment = Enum.TextXAlignment.Left

                for i, e in ipairs(_bootErrors) do
                    local lbl = Instance.new("TextLabel", frame)
                    lbl.Size = UDim2.new(1, -20, 0, 18)
                    lbl.Position = UDim2.new(0, 10, 0, 34 + (i - 1) * 20)
                    lbl.BackgroundTransparency = 1
                    lbl.Text = "• " .. e.name .. ": " .. e.err:sub(1, 110)
                    lbl.TextColor3 = Color3.fromRGB(255, 180, 180)
                    lbl.Font = Enum.Font.Code
                    lbl.TextSize = 10
                    lbl.TextXAlignment = Enum.TextXAlignment.Left
                    lbl.TextTruncate = Enum.TextTruncate.AtEnd
                end

                local copyBtn = Instance.new("TextButton", frame)
                copyBtn.Size = UDim2.new(0, 100, 0, 22)
                copyBtn.Position = UDim2.new(0, 10, 1, -30)
                copyBtn.BackgroundColor3 = Color3.fromRGB(80, 20, 30)
                copyBtn.Text = "COPIAR LOG"
                copyBtn.TextColor3 = Color3.fromRGB(255, 200, 200)
                copyBtn.Font = Enum.Font.GothamBold
                copyBtn.TextSize = 11
                copyBtn.BorderSizePixel = 0
                Instance.new("UICorner", copyBtn).CornerRadius = UDim.new(0, 6)
                copyBtn.MouseButton1Click:Connect(function()
                    local buf = ""
                    for _, e in ipairs(_bootErrors) do
                        buf = buf .. e.name .. ": " .. e.err .. "\n"
                    end
                    pcall(function()
                        if setclipboard then setclipboard(buf) end
                    end)
                    copyBtn.Text = "¡COPIADO!"
                    task.delay(1.2, function() copyBtn.Text = "COPIAR LOG" end)
                end)

                local closeBtn = Instance.new("TextButton", frame)
                closeBtn.Size = UDim2.new(0, 60, 0, 22)
                closeBtn.Position = UDim2.new(1, -70, 1, -30)
                closeBtn.BackgroundColor3 = Color3.fromRGB(80, 20, 30)
                closeBtn.Text = "CERRAR"
                closeBtn.TextColor3 = Color3.fromRGB(255, 200, 200)
                closeBtn.Font = Enum.Font.GothamBold
                closeBtn.TextSize = 11
                closeBtn.BorderSizePixel = 0
                Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 6)
                closeBtn.MouseButton1Click:Connect(function()
                    pcall(function() errGui:Destroy() end)
                end)

                task.delay(60, function()
                    pcall(function() errGui:Destroy() end)
                end)
            end)
        end)
    end
else
    warn("[ELITE FAMILY Boot] Fatal: buildGui falló. El script no puede continuar.")
end

if LP and LP.CharacterAdded then
    pcall(function()
        local _respawnQueue = 0
        LP.CharacterAdded:Connect(function(char)
            pcall(function()
                _respawnQueue = _respawnQueue + 1
                local myId = _respawnQueue

                if stealConnection then stealConnection:Disconnect(); stealConnection = nil end
                isStealing = false
                if stopAutoLeft then stopAutoLeft() end
                if stopAutoRight then stopAutoRight() end
                if stopBatCounter then stopBatCounter() end
                if stopBatCounterV2 then stopBatCounterV2() end
                if stopMedusaCounter then stopMedusaCounter() end
                if not _tpBatUnwalkForced and stopUnwalk then stopUnwalk() end
                if stopDropBrainrot then stopDropBrainrot() end
                if autoBatEnabled and disableAutoBat then disableAutoBat() end
                if batDesyncTpEnabled and stopBatDesyncTp then stopBatDesyncTp() end
                if autoBatV2Enabled and disableBatV2 then disableBatV2() end
                if bodyLockEnabled and stopBodyLock then stopBodyLock() end

                local deadline = _tick() + 5
                while (not char.Parent) or (not char:FindFirstChild("HumanoidRootPart")) or (not char:FindFirstChildOfClass("Humanoid")) do
                    if _tick() > deadline then return end
                    if myId ~= _respawnQueue then return end
                    task.wait(0.05)
                end

                _hookedVelParts = {}
                local _hrpRespawn = _setupVelChecked(char)
                _hookVelHRP(_hrpRespawn)

                if not _originalAppearance then task.defer(function() captureOriginalAppearance(char) end) end
                if setupMovementAndIndicators then setupMovementAndIndicators(char) end
                if antiRagdollMode == "v2" then startAntiRagdollV2() end
                if antiBatEnabled then startAntiBat() end
                if antiFlingEnabled then startAntiFling() end
                if AntiDieModule.enabled then task.defer(function() activateOnCharacter(char) end) end
                if CONFIG.AUTO_STEAL_ENABLED then pcall(startAutoSteal) end
                if batDesyncTpEnabled then task.defer(startBatDesyncTp) end
                if autoBatV2Enabled then task.defer(function() enableBatV2() end) end
                if bodyLockEnabled and _blSuppressCount == 0 then startBodyLock() end

                if medusaCounterEnabled then
                    setupMedusaCounter(char)
                    if setMedusaVisual then setMedusaVisual(true) end
                else
                    stopMedusaCounter()
                    if setMedusaVisual then setMedusaVisual(false) end
                end

                if batCounterEnabled then startBatCounter() end
                if batCounterV2Enabled then startBatCounterV2() end
                if unwalkEnabled and not _tpBatUnwalkForced then startUnwalk() end
                if currentAnimPack ~= "Off" then task.wait(0.3); startAnimPack(currentAnimPack) end

                updateProgressBarVisibility()
                refreshSpeedModeLabel()

                pcall(function() applyOutfitByIndex(currentOutfitIndex) end)
                if outfitSelectorLabel then outfitSelectorLabel.Text = OUTFITS[currentOutfitIndex].label end
            end)
        end)
    end)
end

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
        if _tick() - lastLaggerToggle >= LAGGER_COOLDOWN then
            lastLaggerToggle = _tick()
            toggleLaggerCycle()
        end
        return
    end
    if kbMatch(KB.CarryToggle, kc) then toggleCarryMode(); return end
    if kbMatch(KB.DropBrainrot, kc) then
        if not dropActive then
            if dropBrainrotSetVisual then dropBrainrotSetVisual(true) end
            executeDropWithToggle(dropBrainrotSetVisual)
        end
        return
    end
    if kbMatch(KB.TPFloor, kc) then doTpDown(); return end
    if kbMatch(KB.InstaReset, kc) then
        if _G.InstaReset and _G.InstaReset.Trigger then _G.InstaReset.Trigger() end
        return
    end
    if kbMatch(KB.AutoLeft, kc) then
        autoLeftEnabled = not autoLeftEnabled
        if autoLeftEnabled then startAutoLeft() else stopAutoLeft() end
        if autoLeftSetVisual then autoLeftSetVisual(autoLeftEnabled) end
        if mobSetAutoLeft then mobSetAutoLeft(autoLeftEnabled) end
        return
    end
    if kbMatch(KB.AutoRight, kc) then
        autoRightEnabled = not autoRightEnabled
        if autoRightEnabled then startAutoRight() else stopAutoRight() end
        if autoRightSetVisual then autoRightSetVisual(autoRightEnabled) end
        if mobSetAutoRight then mobSetAutoRight(autoRightEnabled) end
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
        return
    end
    if kbMatch(KB.TPBat, kc) then
        toggleBatDesyncTp()
        if batDesyncTpSetVisual then batDesyncTpSetVisual(batDesyncTpEnabled) end
        if tpBatFloatingButton then
            local btnFrame = tpBatFloatingButton:FindFirstChild("Frame")
            if btnFrame then paintFloatingBtn(btnFrame, batDesyncTpEnabled) end
        end
        return
    end
    if kbMatch(KB.BatV2, kc) then
        toggleBatV2()
        if autoBatV2SetVisual then autoBatV2SetVisual(autoBatV2Enabled) end
        if batV2FloatingButton then
            local btnFrame = batV2FloatingButton:FindFirstChild("Frame")
            if btnFrame then paintFloatingBtn(btnFrame, autoBatV2Enabled) end
        end
        return
    end
    if kbMatch(KB.GuiHide, kc) then
        if main then
            if main.Visible then hideGui() else showGui() end
        end
        return
    end
end)