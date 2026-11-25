if _G.YoutRunning then
    warn("[Y-out] Instancia previa detectada. Se recomienda rejoin si hay comportamiento errático.")
end
_G.YoutRunning = false
_G.__YoutMainOriginalPos = nil

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
    warn("[Y-out] LocalPlayer no disponible en 15s. Abortando.")
    return
end

local pgui = LP:WaitForChild("PlayerGui", 20)
if not pgui then
    warn("[Y-out] PlayerGui no cargó en 20s. Abortando.")
    return
end

local camera = Workspace.CurrentCamera

_G.YoutRunning = true
_G.YoutSession = (_G.YoutSession or 0) + 1
local _mySession = _G.YoutSession

local YOUT_LANGUAGE = "en"

local YOUT_TRANSLATIONS = {
    es = { ["RESET ALL SETTINGS"]="RESTABLECER TODO", ["SETTINGS RESET"]="AJUSTES RESTABLECIDOS", ["CONFIRM?"]="¿CONFIRMAR?", ["ERROR"]="ERROR", ["Reset All Keybinds"]="RESTABLECER TECLAS", ["RESET"]="RESTABLECER", ["Keybinds"]="TECLAS", ["Carry Mode"]="MODO CARGAR", ["Lagger Mode"]="MODO LAG", ["Auto Left"]="AUTO IZQUIERDA", ["Auto Right"]="AUTO DERECHA", ["Auto Bat"]="AUTO BATE", ["TP BAT"]="TP BATE", ["Insta Reset"]="REINICIO RÁPIDO", ["TP Down"]="TP ABAJO", ["Drop Brainrot"]="SOLTAR BRAINROT", ["Hide GUI"]="OCULTAR MENÚ", ["Normal Speed"]="VELOCIDAD NORMAL", ["Carry Speed"]="VELOCIDAD CARGAR", ["Current Mode"]="MODO ACTUAL", ["ACTIVATE"]="ACTIVAR" },
    pt = { ["RESET ALL SETTINGS"]="REDEFINIR TUDO", ["SETTINGS RESET"]="CONFIGURAÇÕES REDEFINIDAS", ["CONFIRM?"]="CONFIRMAR?", ["ERROR"]="ERRO", ["Reset All Keybinds"]="REDEFINIR TECLAS", ["RESET"]="REDEFINIR", ["Keybinds"]="TECLAS", ["Carry Mode"]="MODO CARREGAR", ["Auto Left"]="AUTO ESQUERDA", ["Auto Right"]="AUTO DIREITA", ["Hide GUI"]="OCULTAR MENU", ["Normal Speed"]="VELOCIDADE NORMAL", ["Carry Speed"]="VELOCIDADE CARREGAR", ["ACTIVATE"]="ATIVAR" },
    fr = { ["RESET ALL SETTINGS"]="RÉINITIALISER", ["SETTINGS RESET"]="PARAMÈTRES RÉINITIALISÉS", ["CONFIRM?"]="CONFIRMER ?", ["ERROR"]="ERREUR", ["Reset All Keybinds"]="RÉINITIALISER LES TOUCHES", ["RESET"]="RÉINITIALISER", ["Keybinds"]="RACCOURCIS", ["Carry Mode"]="MODE PORTER", ["Auto Left"]="AUTO GAUCHE", ["Auto Right"]="AUTO DROITE", ["Hide GUI"]="MASQUER LE MENU", ["Normal Speed"]="VITESSE NORMALE", ["Carry Speed"]="VITESSE PORTER", ["ACTIVATE"]="ACTIVER" },
    de = { ["RESET ALL SETTINGS"]="ALLES ZURÜCKSETZEN", ["SETTINGS RESET"]="EINSTELLUNGEN ZURÜCKGESETZT", ["CONFIRM?"]="BESTÄTIGEN?", ["ERROR"]="FEHLER", ["Reset All Keybinds"]="TASTEN ZURÜCKSETZEN", ["RESET"]="ZURÜCKSETZEN", ["Keybinds"]="TASTEN", ["Carry Mode"]="TRAGEMODUS", ["Auto Left"]="AUTO LINKS", ["Auto Right"]="AUTO RECHTS", ["Hide GUI"]="MENÜ AUSBLENDEN", ["Normal Speed"]="NORMALE GESCHWINDIGKEIT", ["Carry Speed"]="TRAGEGESCHWINDIGKEIT", ["ACTIVATE"]="AKTIVIEREN" },
}

local function localizeYoutInterface(root)
    local dictionary = YOUT_TRANSLATIONS[YOUT_LANGUAGE]
    if not dictionary or not root then return end
    for _, object in ipairs(root:GetDescendants()) do
        if object:IsA("TextLabel") or object:IsA("TextButton") then
            local source = object:GetAttribute("YoutSourceText") or object.Text
            object:SetAttribute("YoutSourceText", source)
            local translated = dictionary[source]
            if translated then object.Text = translated end
        end
    end
end

local function youtTranslate(source)
    local dictionary = YOUT_TRANSLATIONS[YOUT_LANGUAGE]
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
CONFIG_FILE = "Yout_" .. tostring(LP.UserId) .. ".json"
BAT_V2_SPEED = 60
BAT_V2_HIT_DIST = 4.5
BAT_V2_LEAD_STUDS = 6.4
YOUT_BAT_V2_BODY_LOCK_RANGE = 40
_isDraggingButton = false

backgroundIndex = 1
-- Fondo FEAR X BLESS: imagen indicada para el menú de configuración.
-- Se repite en ambos espacios para que el selector no cambie a otra imagen.
local FEAR_MENU_BACKGROUND_ASSET = "89981724365525"
backgroundImages = {
    FEAR_MENU_BACKGROUND_ASSET,
    FEAR_MENU_BACKGROUND_ASSET,
}

backgroundImageTransparency = 0
backgroundMode = "Background 1"
backgroundSelectorLabel = nil
floatingButtonScale = 1
_floatingUIScales = {}
floatingButtonStyle = 2 -- 1 = forma original redondeada, 2 = cuadrada (por defecto)

YOUT_USE_BG_IMAGE = false -- true = vuelve a mostrar la imagen de fondo FEAR
local function setYoutAssetImage(guiObject, assetId)
    if not guiObject or not guiObject.Parent or not assetId then return end
    local direct = "rbxassetid://" .. tostring(assetId)
    guiObject.Image = direct
    guiObject.ImageTransparency = (guiObject.Name == "BackgroundImage" and not YOUT_USE_BG_IMAGE) and 1 or 0
    guiObject.ScaleType = Enum.ScaleType.Fit
    -- Preload the original asset; do not replace it with a low-resolution thumbnail.
    task.spawn(function()
        if not guiObject or not guiObject.Parent then return end
        pcall(function()
            game:GetService("ContentProvider"):PreloadAsync({guiObject})
        end)
    end)
end

function applyBackgroundMode(mode)
    -- El fondo indicado queda fijo: no se permite ocultarlo ni cambiarlo.
    backgroundMode = "Background 1"
    backgroundIndex = 1

    if main then
        main.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        main.BackgroundTransparency = 1
        local bgImage = main:FindFirstChild("BackgroundImage")
        if bgImage then
            bgImage.Visible = true
            bgImage.Size = UDim2.new(1, 0, 1, 0)
            bgImage.Position = UDim2.new(0, 0, 0, 0)
            bgImage.ImageTransparency = YOUT_USE_BG_IMAGE and 0 or 1
            bgImage.ScaleType = Enum.ScaleType.Fit
            setYoutAssetImage(bgImage, FEAR_MENU_BACKGROUND_ASSET)
        end
    end

    if backgroundSelectorLabel then
        backgroundSelectorLabel.Text = "FEAR X BLESS"
    end
end

-- ============ PALETA AZUL CLARO + NEGRO ============
local COLOR_THEMES = {
    ["Light Blue"] = Color3.fromRGB(125, 205, 250),
    ["Sky Blue"] = Color3.fromRGB(105, 190, 245),
    ["Ice Blue"] = Color3.fromRGB(165, 225, 255),
}

currentColorTheme = "Light Blue"
selectedColor = COLOR_THEMES["Light Blue"]

function getThemeColor() return selectedColor end

function youtGradient(c)
    return ColorSequence.new({
        ColorSequenceKeypoint.new(0.00, c:Lerp(Color3.new(1,1,1), 0.45)),
        ColorSequenceKeypoint.new(0.45, c),
        ColorSequenceKeypoint.new(1.00, c:Lerp(Color3.new(0,0,0), 0.45)),
    })
end

local ACTIVE_PINK = Color3.fromRGB(105, 190, 245)

local function activePinkShine()
    return ColorSequence.new({
        ColorSequenceKeypoint.new(0.00, Color3.fromRGB(45, 10, 80)),
        ColorSequenceKeypoint.new(0.20, Color3.fromRGB(90, 30, 160)),
        ColorSequenceKeypoint.new(0.40, Color3.fromRGB(160, 70, 230)),
        ColorSequenceKeypoint.new(0.50, Color3.fromRGB(230, 180, 255)),
        ColorSequenceKeypoint.new(0.60, Color3.fromRGB(160, 70, 230)),
        ColorSequenceKeypoint.new(0.80, Color3.fromRGB(90, 30, 160)),
        ColorSequenceKeypoint.new(1.00, Color3.fromRGB(45, 10, 80)),
    })
end

local ACTIVE_SHINE_GRADS = setmetatable({}, { __mode = "k" })
local _activeShineHeartbeat = nil

local function setAnimatedActiveShine(grad, enabled, rotation)
    if not grad then return end
    if enabled then
        ACTIVE_SHINE_GRADS[grad] = rotation or grad.Rotation or 0
        grad.Color = activePinkShine()
        grad.Rotation = rotation or grad.Rotation or 45
        grad.Offset = Vector2.new(-1.2, -1.2)
        if not _activeShineHeartbeat then
            _activeShineHeartbeat = RunService.Heartbeat:Connect(function()
                local t = tick() * 1.4
                local live = false
                for g, rot in pairs(ACTIVE_SHINE_GRADS) do
                    if g and g.Parent then
                        live = true
                        g.Rotation = rot or g.Rotation
                        local p = ((t % 2.8) / 1.4) - 1.0
                        g.Offset = Vector2.new(p, p)
                    else
                        ACTIVE_SHINE_GRADS[g] = nil
                    end
                end
                if not live and _activeShineHeartbeat then
                    _activeShineHeartbeat:Disconnect()
                    _activeShineHeartbeat = nil
                end
            end)
        end
    else
        ACTIVE_SHINE_GRADS[grad] = nil
        grad.Offset = Vector2.new(0, 0)
    end
end

function youtGradientSoft(c)
    return ColorSequence.new({
        ColorSequenceKeypoint.new(0.00, c:Lerp(Color3.new(1,1,1), 0.75)),
        ColorSequenceKeypoint.new(0.50, c:Lerp(Color3.new(1,1,1), 0.25)),
        ColorSequenceKeypoint.new(1.00, c:Lerp(Color3.new(0,0,0), 0.15)),
    })
end

function youtGradientDark(c)
    return ColorSequence.new({
        ColorSequenceKeypoint.new(0.00, c:Lerp(Color3.fromRGB(0,0,0), 0.35)),
        ColorSequenceKeypoint.new(0.55, c:Lerp(Color3.fromRGB(0,0,0), 0.65)),
        ColorSequenceKeypoint.new(1.00, c:Lerp(Color3.fromRGB(0,0,0), 0.80)),
    })
end

function applyYoutGradientToLabel(label, c)
    if not label then return end
    local grad = label:FindFirstChildOfClass("UIGradient")
    if not grad then grad = Instance.new("UIGradient", label) end
    grad.Rotation = 0
    grad.Color = youtGradient(c)
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
        progressFill.BackgroundColor3 = Color3.fromRGB(105, 190, 245)
        local grad = progressFill:FindFirstChildOfClass("UIGradient")
        if grad then
            grad.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0.00, Color3.fromRGB(190, 230, 255)),
                ColorSequenceKeypoint.new(0.50, Color3.fromRGB(105, 190, 245)),
                ColorSequenceKeypoint.new(1.00, Color3.fromRGB(55, 125, 180)),
            })
            grad.Rotation = 0
        end
    end
    if pbFrame then
        local violet = Color3.fromRGB(105, 190, 245)
        local border = pbFrame:FindFirstChild("OuterStroke") or pbFrame:FindFirstChildOfClass("UIStroke")
        if border then border.Color = violet end
        local title = pbFrame:FindFirstChild("DiscordText", true)
        if title then title.TextColor3 = Color3.fromRGB(195, 230, 255) end
        local fpsNeon = pbFrame:FindFirstChild("FPSNeon", true)
        if fpsNeon then fpsNeon.TextColor3 = Color3.fromRGB(165, 220, 255) end
        local pingNeon = pbFrame:FindFirstChild("PingNeon", true)
        if pingNeon then pingNeon.TextColor3 = Color3.fromRGB(165, 220, 255) end
        local divider = pbFrame:FindFirstChild("Divider", true)
        if divider and divider:IsA("Frame") then divider.BackgroundColor3 = violet end
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
    for _, tab in ipairs(tabButtons or {}) do
        tab.TextColor3 = Color3.fromRGB(255,255,255)
        tab.TextTransparency = 0
        tab.BackgroundTransparency = 1
        local surface = tab:FindFirstChild("TabSurface")
        if surface then surface.ClipsDescendants = true end
    end
    if main then
        local rail = main:FindFirstChild("YoutRightRail")
        local ring = rail and rail:FindFirstChild("AvatarRing")
        local ringStroke = ring and ring:FindFirstChildOfClass("UIStroke")
        if ringStroke then ringStroke.Color = color end
    end
    if _G.__YoutRefreshESPTheme then pcall(_G.__YoutRefreshESPTheme, color) end
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

    if _G._youtStealSlide then
        _G._youtStealSlide.BackgroundColor3 = Color3.fromRGB(105, 185, 240)
        local sg = _G._youtStealSlide:FindFirstChildOfClass("UIGradient")
        if sg then sg.Color = activePinkShine() end
        local ss = _G._youtStealSlide:FindFirstChildOfClass("UIStroke")
        if ss then ss.Color = Color3.fromRGB(145, 215, 255) end
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
    local ok, res = pcall(function() return game:GetObjects("rbxassetid://" .. tostring(id)) end)
    if ok and typeof(res) == "table" and #res > 0 then return res end
    ok, res = pcall(function() return game:GetService("InsertService"):LoadAsset(id) end)
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
        if p:IsA("Attachment") and p.Name == name and p.Parent:IsA("BasePart") then return p end
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
                    c.CanCollide = false; c.Anchored = false; c.Massless = true
                    c.Size = orig.Size; c.CFrame = orig.CFrame; c.Parent = char
                    local w = Instance.new("WeldConstraint")
                    w.Part0 = orig; w.Part1 = c; w.Parent = c
                    if orig:GetAttribute("YoutOutfitOriginalTransparency") == nil then
                        orig:SetAttribute("YoutOutfitOriginalTransparency", orig.Transparency)
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
    H.CanCollide = false; H.Anchored = false; H.Massless = true
    local wrap = H:FindFirstChildWhichIsA("WrapLayer")
    local target, c0, c1
    if wrap then
        target = char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso") or char:FindFirstChild("HumanoidRootPart")
        c0 = entry.offset or _CFnew(); c1 = _CFnew()
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
    w.Part0 = target; w.Part1 = H; w.C0 = c0; w.C1 = c1; w.Parent = H
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
        s.Name = "Shirt"; s.ShirtTemplate = HOMERO_CFG.shirt; s.Parent = char
    end
    if HOMERO_CFG.pants then
        local p = char:FindFirstChildWhichIsA("Pants") or Instance.new("Pants")
        p.Name = "Pants"; p.PantsTemplate = HOMERO_CFG.pants; p.Parent = char
    end
    if HOMERO_CFG.aplicarCuerpo then applyBody(char) end
    for _, e in ipairs(HOMERO_CFG.items) do attachItem(char, e) end
end

local _originalAppearance = nil

local function captureOriginalAppearance(char)
    if not char or _originalAppearance then return end
    local data = { bodyColors = nil, shirt = nil, pants = nil, headMesh = nil, headTexture = nil }
    local bc = char:FindFirstChildWhichIsA("BodyColors")
    if bc then
        data.bodyColors = {
            head = bc.HeadColor3, torso = bc.TorsoColor3,
            leftArm = bc.LeftArmColor3, rightArm = bc.RightArmColor3,
            leftLeg = bc.LeftLegColor3, rightLeg = bc.RightLegColor3,
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
            data.headMesh = sm.MeshId; data.headTexture = sm.TextureId
        end
    end
    _originalAppearance = data
end

local function clearPreviousOutfitAssets(char)
    if not char then return end
    for _, child in ipairs(char:GetChildren()) do
        if child.Name:sub(1, #TAG) == TAG
        or child.Name == "AuFfitAccessory"
        or child.Name == "Korblox_RightLeg"
        or child.Name == "Korblox_LeftLeg" then
            pcall(function() child:Destroy() end)
        elseif child:IsA("CharacterMesh") and child.BodyPart == Enum.BodyPart.Head then
            pcall(function() child:Destroy() end)
        end
    end
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            local oT = part:GetAttribute("YoutOutfitOriginalTransparency")
            if oT ~= nil then
                part.Transparency = oT
                part:SetAttribute("YoutOutfitOriginalTransparency", nil)
            end
            local oLT = part:GetAttribute("YoutOutfitOriginalLocalTransparency")
            if oLT ~= nil then
                part.LocalTransparencyModifier = oLT
                part:SetAttribute("YoutOutfitOriginalLocalTransparency", nil)
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
    if head and head:IsA("MeshPart") and head:GetAttribute("YoutOutfitModifiedMeshPart") then
        pcall(function()
            head.MeshId = head:GetAttribute("YoutOutfitOriginalMeshId") or ""
            head.TextureID = head:GetAttribute("YoutOutfitOriginalTextureId") or ""
        end)
        head:SetAttribute("YoutOutfitModifiedMeshPart", nil)
        head:SetAttribute("YoutOutfitOriginalMeshId", nil)
        head:SetAttribute("YoutOutfitOriginalTextureId", nil)
    elseif head then
        local sm = head:FindFirstChildWhichIsA("SpecialMesh")
        if sm and sm:GetAttribute("YoutOutfitCreatedMesh") then sm:Destroy()
        elseif sm and sm:GetAttribute("YoutOutfitModifiedMesh") then
            sm.MeshId = sm:GetAttribute("YoutOutfitOriginalMeshId") or ""
            sm.TextureId = sm:GetAttribute("YoutOutfitOriginalTextureId") or ""
            sm:SetAttribute("YoutOutfitModifiedMesh", nil)
            sm:SetAttribute("YoutOutfitOriginalMeshId", nil)
            sm:SetAttribute("YoutOutfitOriginalTextureId", nil)
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
    local oldKorbloxR = char:FindFirstChild("Korblox_RightLeg")
    if oldKorbloxR then pcall(function() oldKorbloxR:Destroy() end) end
    local oldKorbloxL = char:FindFirstChild("Korblox_LeftLeg")
    if oldKorbloxL then pcall(function() oldKorbloxL:Destroy() end) end
    for _, d in ipairs(char:GetChildren()) do
        if d:IsA("CharacterMesh") and d.BodyPart == Enum.BodyPart.Head then
            pcall(function() d:Destroy() end)
        end
    end
    local head = char:FindFirstChild("Head")
    if head then
        head.Transparency = 0; head.CanCollide = true; head.LocalTransparencyModifier = 0
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
    for _, partName in ipairs({"RightUpperLeg", "RightLowerLeg", "RightFoot", "LeftUpperLeg", "LeftLowerLeg", "LeftFoot"}) do
        local limb = char:FindFirstChild(partName)
        if limb then limb.Transparency = 0 end
    end
    if _originalAppearance and _originalAppearance.bodyColors then
        local bc = char:FindFirstChildWhichIsA("BodyColors") or Instance.new("BodyColors")
        local o = _originalAppearance.bodyColors
        bc.HeadColor3 = o.head; bc.TorsoColor3 = o.torso
        bc.LeftArmColor3 = o.leftArm; bc.RightArmColor3 = o.rightArm
        bc.LeftLegColor3 = o.leftLeg; bc.RightLegColor3 = o.rightLeg
        bc.Parent = char
    end
    if _originalAppearance and _originalAppearance.shirt then
        local s = char:FindFirstChildWhichIsA("Shirt") or Instance.new("Shirt")
        s.ShirtTemplate = _originalAppearance.shirt; s.Parent = char
    end
    if _originalAppearance and _originalAppearance.pants then
        local p = char:FindFirstChildWhichIsA("Pants") or Instance.new("Pants")
        p.PantsTemplate = _originalAppearance.pants; p.Parent = char
    end
    for _, a in ipairs(char:GetChildren()) do
        if a:IsA("Accessory") then
            local h = a:FindFirstChild("Handle")
            if h then h.Transparency = 0 end
        end
    end
end

-- ============ OUTFITS (Store 1, Store 2, Homero) ============
local OUTFITS = {
    { label = "OFF", customApply = applyNoOutfit },
    {
        accessory = 134121637145513,
        offset = _V3new(0.0000, 0.3000, 0.0000),
        headMesh = "rbxassetid://97775534287645",
        headTexture = "http://www.roblox.com/asset/?id=85261384027747",
        shirt = "http://www.roblox.com/asset/?id=5340654651",
        pants = nil,
        label = "Store 1",
    },
    {
        accessory = 123800647409495,
        offset = _V3new(0.0000, 1.4000, -0.1000),
        headMesh = "rbxassetid://113112170498124",
        headTexture = "rbxassetid://139035320790806",
        shirt = "http://www.roblox.com/asset/?id=104075024263435",
        pants = "http://www.roblox.com/asset/?id=9164888166",
        label = "Store 2",
    },
    { label = "Homero Chino", customApply = applyHomeroOutfit },
}
local currentOutfitIndex = 1
local outfitSelectorLabel = nil

-- ============ MODIFICADORES GLOBALES DE OUTFIT ============
OUTFIT_HEADLESS = OUTFIT_HEADLESS or false
OUTFIT_KORBLOX   = OUTFIT_KORBLOX or "none"   -- "none" | "left" | "right" | "both"
setOutfitHeadlessVisual = nil
setOutfitKorbloxVisual  = nil

-- =====================================================================
-- [KATANA] BAT SKINS — Estado y lógica aislada
-- =====================================================================
BAT_SKIN_LIST = { "None", "Katana" }
currentBatSkin = "None"
batSkinSelectorLabel = nil
_batSkinWatcherConn = nil
_batSkinApplyCooldown = 0
_batSkinState = _G.__YoutBatSkinState
if type(_batSkinState) ~= "table" then
    _batSkinState = { applying = false, lastCheck = 0, lastTool = nil }
    _G.__YoutBatSkinState = _batSkinState
end

-- =====================================================================
-- KATANA - Lógica aislada (bat skin)
-- =====================================================================
do
    local Skins_Players = game:GetService("Players")
    local Skins_LP = Skins_Players.LocalPlayer

    local State = {
        OriginalKatanaTemplate = nil,
        ExactTemplates = {},
        ExactTemplateSearched = {},
        ExactAssetIds = { KATANA = "" },
        Original = {},
    }

    local SKIN_SOUND_IDS = { KATANA = "rbxassetid://111808555599832" }

    local function setPartSafe(part)
        if not part or not part:IsA("BasePart") then return end
        part.Anchored = false
        part.CanCollide = false
        part.CanTouch = false
        part.CanQuery = false
        part.Massless = true
    end

    local function weldToHandle(part, handle)
        if not part or not handle or not part:IsA("BasePart") or not handle:IsA("BasePart") then return end
        setPartSafe(part)
        local weld = Instance.new("WeldConstraint")
        weld.Name = "FlowerSkin_AssetWeld"
        weld.Part0 = handle
        weld.Part1 = part
        weld.Parent = part
    end

    local function findBatTool()
        local character = Skins_LP.Character
        if character then
            local tool = character:FindFirstChild("Bat")
            if tool and tool:IsA("Tool") then return tool end
        end
        local backpack = Skins_LP:FindFirstChildOfClass("Backpack")
        if backpack then
            local tool = backpack:FindFirstChild("Bat")
            if tool and tool:IsA("Tool") then return tool end
        end
        return nil
    end

    local function rememberOriginal(tool)
        if not tool then return end
        local handle = tool:FindFirstChild("Handle")
        local slash = tool:FindFirstChild("Slash")
        State.Original[tool] = State.Original[tool] or {}
        local original = State.Original[tool]
        if handle and handle:IsA("BasePart") and not original.Handle then
            original.Handle = {
                Transparency = handle.Transparency,
                LocalTransparencyModifier = handle.LocalTransparencyModifier,
                CastShadow = handle.CastShadow,
            }
        end
        if slash and slash:IsA("Sound") and not original.SlashSoundId then
            original.SlashSoundId = slash.SoundId
        end
    end

    local function hideOriginalHandle(tool, hidden)
        local handle = tool and tool:FindFirstChild("Handle")
        if not handle or not handle:IsA("BasePart") then return end
        rememberOriginal(tool)
        if hidden then
            handle.LocalTransparencyModifier = 1
            handle.Transparency = 1
            handle.CastShadow = false
        else
            local original = State.Original[tool] and State.Original[tool].Handle
            handle.LocalTransparencyModifier = original and original.LocalTransparencyModifier or 0
            handle.Transparency = original and original.Transparency or 0
            handle.CastShadow = original and original.CastShadow
            if handle.CastShadow == nil then handle.CastShadow = true end
        end
    end

    local function setSlashSound(tool, soundId)
        rememberOriginal(tool)
        local slash = tool and tool:FindFirstChild("Slash")
        if slash and slash:IsA("Sound") then
            slash.SoundId = soundId or ((State.Original[tool] and State.Original[tool].SlashSoundId) or slash.SoundId)
        end
    end

    local function removeSkin(tool)
        if not tool then return end
        local oldFolder = tool:FindFirstChild("FlowerSkin_KatanaRealistic")
        if oldFolder then oldFolder:Destroy() end
        local oldLoose = tool:FindFirstChild("FlowerSkin_AssetKatana")
        if oldLoose then oldLoose:Destroy() end
        hideOriginalHandle(tool, false)
        setSlashSound(tool, nil)
    end

    local COLORS = {
        red = Color3.new(0.784314, 0, 0),
        red2 = Color3.new(1, 0.392157, 0.392157),
        gold = Color3.new(1, 0.72549, 0.196078),
    }

    local function addRedVFX(parentPart)
        if not parentPart or not parentPart:IsA("BasePart") then return end
        local existing = parentPart:FindFirstChild("FlowerSkin_ExtraRedVFX")
        if existing then existing:Destroy() end
        local top = Instance.new("Attachment")
        top.Name = "FlowerSkin_ExtraRedVFX"
        top.Position = Vector3.new(0, parentPart.Size.Y * 0.5, 0)
        top.Parent = parentPart
        local bottom = Instance.new("Attachment")
        bottom.Name = "FlowerSkin_ExtraRedVFX_End"
        bottom.Position = Vector3.new(0, -parentPart.Size.Y * 0.5, 0)
        bottom.Parent = parentPart
        local trail = Instance.new("Trail")
        trail.Name = "FlowerSkin_ExtraRedVFX"
        trail.Attachment0 = top
        trail.Attachment1 = bottom
        trail.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, COLORS.red2),
            ColorSequenceKeypoint.new(1, Color3.new(0.54902, 0, 0)),
        })
        trail.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.35),
            NumberSequenceKeypoint.new(1, 1),
        })
        trail.Lifetime = 0.18
        trail.LightEmission = 0.55
        trail.Parent = parentPart
        local emitter = Instance.new("ParticleEmitter")
        emitter.Name = "FlowerSkin_ExtraRedVFX"
        emitter.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.new(0.784314, 0, 0)),
            ColorSequenceKeypoint.new(1, COLORS.red2),
        })
        emitter.LightEmission = 0.55
        emitter.Rate = 14
        emitter.Lifetime = NumberRange.new(0.25, 0.45)
        emitter.Speed = NumberRange.new(0.2, 0.7)
        emitter.SpreadAngle = Vector2.new(12, 12)
        emitter.Size = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.08),
            NumberSequenceKeypoint.new(1, 0),
        })
        emitter.Texture = "rbxasset://textures/particles/sparkles_main.dds"
        emitter.Parent = parentPart
    end

    local function captureKatanaTemplate()
        if State.OriginalKatanaTemplate then return end
        local function scan(container)
            if not container then return end
            local bat = container:FindFirstChild("Bat")
            if not bat then return end
            local folder = bat:FindFirstChild("FlowerSkin_KatanaRealistic")
            local asset = folder and folder:FindFirstChild("FlowerSkin_AssetKatana")
            if asset then State.OriginalKatanaTemplate = asset:Clone() end
        end
        scan(Skins_LP:FindFirstChildOfClass("Backpack"))
        scan(Skins_LP.Character)
    end

    local EXACT_TEMPLATE_NAMES_KATANA = {
        "FlowerSkin_AssetKatana", "Katana", "FlowerSkin_KatanaRealistic",
    }

    local function isScriptObject(inst)
        return inst:IsA("Script") or inst:IsA("LocalScript") or inst:IsA("ModuleScript")
    end

    local function stripScripts(root)
        if not root then return end
        if isScriptObject(root) then root:Destroy() return end
        for _, inst in ipairs(root:GetDescendants()) do
            if isScriptObject(inst) then inst:Destroy() end
        end
    end

    local function hasAnyBasePart(root)
        if not root then return false end
        if root:IsA("BasePart") then return true end
        return root:FindFirstChildWhichIsA("BasePart", true) ~= nil
    end

    local function isGeneratedProxy(root)
        local ok, value = pcall(function()
            return root:GetAttribute("CursedBatSkinsGenerated")
        end)
        return ok and value == true
    end

    local function usableTemplate(root)
        if not root or isGeneratedProxy(root) then return nil end
        if root:IsA("Model") or root:IsA("Tool") or root:IsA("Folder") or root:IsA("BasePart") then
            if hasAnyBasePart(root) then return root end
        end
        return nil
    end

    local function findUsableNamed(root, names)
        if not root then return nil end
        for _, name in ipairs(names) do
            if root.Name == name then
                local direct = usableTemplate(root)
                if direct then return direct end
            end
        end
        for _, name in ipairs(names) do
            local found = root:FindFirstChild(name, true)
            local usable = usableTemplate(found)
            if usable then return usable end
        end
        return nil
    end

    local function assetTextFromId(assetId)
        local raw = tostring(assetId or ""):gsub("%s+", "")
        if raw == "" then return nil end
        if raw:match("^rbxassetid://") or raw:match("^rbxasset://") then return raw end
        if raw:match("^%d+$") then return "rbxassetid://" .. raw end
        return raw
    end

    local function loadExactTemplateFromAssetId()
        local assetText = assetTextFromId(State.ExactAssetIds.KATANA)
        if not assetText then return nil end
        local loaded = {}
        pcall(function() loaded = game:GetObjects(assetText) end)
        if #loaded == 0 then
            local id = tostring(assetText):match("(%d+)")
            if id then
                pcall(function()
                    table.insert(loaded, game:GetService("InsertService"):LoadAsset(tonumber(id)))
                end)
            end
        end
        for _, root in ipairs(loaded) do
            local exact = findUsableNamed(root, EXACT_TEMPLATE_NAMES_KATANA) or usableTemplate(root)
            if exact then
                local clone = exact:Clone()
                stripScripts(clone)
                return clone
            end
        end
        return nil
    end

    local function findExactTemplateInGame()
        local containers = {
            Skins_LP.Character,
            Skins_LP:FindFirstChildOfClass("Backpack"),
            game:GetService("ReplicatedStorage"),
            game:GetService("Lighting"),
            workspace,
        }
        for _, container in ipairs(containers) do
            local source = findUsableNamed(container, EXACT_TEMPLATE_NAMES_KATANA)
            if source then
                local clone = source:Clone()
                stripScripts(clone)
                return clone
            end
        end
        return nil
    end

    local function getExactTemplate()
        if State.OriginalKatanaTemplate then return State.OriginalKatanaTemplate end
        if State.ExactTemplates.KATANA then return State.ExactTemplates.KATANA end
        if State.ExactTemplateSearched.KATANA then return nil end
        State.ExactTemplateSearched.KATANA = true
        local loaded = loadExactTemplateFromAssetId() or findExactTemplateInGame()
        if loaded then State.ExactTemplates.KATANA = loaded end
        return loaded
    end

    local function containerToModel(clone, folder)
        if clone:IsA("Model") then
            clone.Name = "FlowerSkin_AssetKatana"
            clone.Parent = folder
            return clone
        end
        if clone:IsA("BasePart") then
            local model = Instance.new("Model")
            model.Name = "FlowerSkin_AssetKatana"
            model.Parent = folder
            clone.Parent = model
            return model
        end
        if clone:IsA("Tool") or clone:IsA("Folder") then
            local nested = clone:FindFirstChild("FlowerSkin_AssetKatana")
                or clone:FindFirstChildWhichIsA("Model")
                or clone:FindFirstChildWhichIsA("BasePart")
            if nested and nested.Parent == clone then
                nested.Parent = nil
                clone:Destroy()
                return containerToModel(nested, folder)
            end
            local model = Instance.new("Model")
            model.Name = "FlowerSkin_AssetKatana"
            model.Parent = folder
            for _, child in ipairs(clone:GetChildren()) do
                if not isScriptObject(child) then child.Parent = model end
            end
            clone:Destroy()
            return model
        end
        return nil
    end

    local function applyExactMesh(tool, skinName)
        local handle = tool and tool:FindFirstChild("Handle")
        if not handle or not handle:IsA("BasePart") then return false end
        local template = getExactTemplate(skinName)
        if not template then return false end
        local folder = Instance.new("Folder")
        folder.Name = "FlowerSkin_KatanaRealistic"
        folder.Parent = tool
        local model = containerToModel(template:Clone(), folder)
        if not model or not hasAnyBasePart(model) then
            folder:Destroy()
            return false
        end
        stripScripts(model)
        pcall(function() model:SetAttribute("CursedBatSkinsExactMesh", true) end)
        local firstPart = nil
        for _, inst in ipairs(model:GetDescendants()) do
            if inst:IsA("BasePart") then
                firstPart = firstPart or inst
                setPartSafe(inst)
            end
        end
        if not firstPart then
            folder:Destroy()
            return false
        end
        if model:IsA("Model") then
            model.PrimaryPart = model.PrimaryPart or firstPart
            pcall(function() model:PivotTo(handle.CFrame) end)
        end
        for _, inst in ipairs(model:GetDescendants()) do
            if inst:IsA("BasePart") then weldToHandle(inst, handle) end
        end
        local vfxPart = model:FindFirstChild("SharpParts", true)
            or model:FindFirstChild("WeaponPart", true)
            or model:FindFirstChild("Handle", true)
            or firstPart
        if vfxPart and not vfxPart:FindFirstChild("FlowerSkin_ExtraRedVFX") then
            addRedVFX(vfxPart)
        end
        return true
    end

    local function newPart(parent, name, size, offset, color, material)
        local part = Instance.new("Part")
        part.Name = name
        part.Size = size
        part.Color = color
        part.Material = material or Enum.Material.Neon
        part.TopSurface = Enum.SurfaceType.Smooth
        part.BottomSurface = Enum.SurfaceType.Smooth
        setPartSafe(part)
        part.Parent = parent
        return part, offset or CFrame.identity
    end

    local function buildProxyKatana(tool)
        local handle = tool and tool:FindFirstChild("Handle")
        if not handle or not handle:IsA("BasePart") then return nil end
        local folder = Instance.new("Folder")
        folder.Name = "FlowerSkin_KatanaRealistic"
        folder.Parent = tool
        local model = Instance.new("Model")
        model.Name = "FlowerSkin_AssetKatana"
        model:SetAttribute("CursedBatSkinsGenerated", true)
        model.Parent = folder
        local parts = {}
        local function add(name, size, offset, color, material)
            local part, cfOffset = newPart(model, name, size, offset, color, material)
            part.CFrame = handle.CFrame * cfOffset
            weldToHandle(part, handle)
            table.insert(parts, part)
            return part
        end
        add("Handle2", Vector3.new(0.22, 1.0, 0.22), CFrame.new(0, -0.85, 0), Color3.new(0.04, 0.04, 0.045), Enum.Material.Metal)
        local sharp = add("SharpParts", Vector3.new(0.22, 3.35, 0.12), CFrame.new(0, 1.05, 0), COLORS.red2, Enum.Material.Neon)
        add("WeaponPart", Vector3.new(0.3, 2.7, 0.08), CFrame.new(0.08, 1.15, 0), COLORS.red, Enum.Material.Neon)
        add("NeonAccent", Vector3.new(0.75, 0.12, 0.42), CFrame.new(0, -0.28, 0), COLORS.gold, Enum.Material.Neon)
        addRedVFX(sharp)
        model.PrimaryPart = parts[1]
        return model
    end

    local function applyTemplateKatana(tool)
        local handle = tool and tool:FindFirstChild("Handle")
        if not handle or not State.OriginalKatanaTemplate then return false end
        local folder = Instance.new("Folder")
        folder.Name = "FlowerSkin_KatanaRealistic"
        folder.Parent = tool
        local clone = State.OriginalKatanaTemplate:Clone()
        clone.Name = "FlowerSkin_AssetKatana"
        clone.Parent = folder
        for _, inst in ipairs(clone:GetDescendants()) do
            if inst:IsA("BasePart") then
                setPartSafe(inst)
                pcall(function() inst.CFrame = handle.CFrame end)
                weldToHandle(inst, handle)
            elseif inst:IsA("Script") or inst:IsA("LocalScript") then
                inst:Destroy()
            end
        end
        pcall(function()
            local _, size = clone:GetBoundingBox()
            local target = math.max(handle.Size.Y, 1)
            local current = math.max(size.Y, 1)
            clone:ScaleTo(math.clamp(target / current * 2.4, 0.35, 2.5))
            clone:PivotTo(handle.CFrame)
        end)
        local sharp = clone:FindFirstChild("SharpParts", true) or clone:FindFirstChildWhichIsA("BasePart", true)
        addRedVFX(sharp)
        return true
    end

    local function applyKatanaSkin()
        captureKatanaTemplate()
        local tool = findBatTool()
        if not tool then return false, "Bat tool not found" end
        rememberOriginal(tool)
        removeSkin(tool)
        hideOriginalHandle(tool, true)
        setSlashSound(tool, SKIN_SOUND_IDS.KATANA)
        if State.OriginalKatanaTemplate then
            applyTemplateKatana(tool)
        elseif not applyExactMesh(tool, "KATANA") then
            buildProxyKatana(tool)
        end
        local handle = tool:FindFirstChild("Handle")
        if handle then
            local fire = handle:FindFirstChildOfClass("Fire") or handle:FindFirstChild("Fire")
            if fire and fire:IsA("Fire") then
                fire.Enabled = true
                fire.Color = COLORS.red
                fire.SecondaryColor = COLORS.red2
            end
        end
        return true
    end

    _G.CursedBatSkins_Katana = {
        SetExactAssetId = function(assetId)
            State.ExactAssetIds.KATANA = tostring(assetId or "")
            State.ExactTemplateSearched.KATANA = nil
            State.ExactTemplates.KATANA = nil
            return true
        end,
        SetExactTemplate = function(instance)
            local usable = usableTemplate(instance)
            if not usable then
                return false, "template needs a Model/Tool/Folder/BasePart with BaseParts"
            end
            State.ExactTemplates.KATANA = usable:Clone()
            State.ExactTemplateSearched.KATANA = true
            stripScripts(State.ExactTemplates.KATANA)
            return true
        end,
        Apply = applyKatanaSkin,
        Clear = function()
            local tool = findBatTool()
            if tool then removeSkin(tool) end
        end,
    }
end

-- [KATANA] Wrapper de estado para el menú
local function applyCurrentBatSkin()
    if currentBatSkin == "None" then
        if _G.CursedBatSkins_Katana then
            pcall(function() _G.CursedBatSkins_Katana.Clear() end)
        end
        return
    end
    if currentBatSkin == "Katana" and _G.CursedBatSkins_Katana then
        pcall(function() _G.CursedBatSkins_Katana.Apply() end)
    end
end

local function startBatSkinWatcher()
    if _batSkinWatcherConn then _batSkinWatcherConn:Disconnect() end
    _batSkinWatcherConn = RunService.Heartbeat:Connect(function()
        if currentBatSkin == "None" then return end
        if _batSkinState.applying then return end
        local now = _tick()
        if now - _batSkinState.lastCheck < 0.5 then return end
        _batSkinState.lastCheck = now
        local char = LP.Character
        if not char then return end
        local tool = char:FindFirstChild("Bat")
        if tool and tool:IsA("Tool") then
            if not tool:FindFirstChild("FlowerSkin_KatanaRealistic") then
                _batSkinState.applying = true
                applyCurrentBatSkin()
                _batSkinState.applying = false
            end
        end
    end)
end

local function stopBatSkinWatcher()
    if _batSkinWatcherConn then
        _batSkinWatcherConn:Disconnect()
        _batSkinWatcherConn = nil
    end
end

function setBatSkin(skinName)
    local valid = false
    for _, v in ipairs(BAT_SKIN_LIST) do
        if v == skinName then valid = true break end
    end
    if not valid then skinName = "None" end
    currentBatSkin = skinName
    if batSkinSelectorLabel then batSkinSelectorLabel.Text = currentBatSkin end
    if currentBatSkin == "None" then
        stopBatSkinWatcher()
        if _G.CursedBatSkins_Katana then
            pcall(function() _G.CursedBatSkins_Katana.Clear() end)
        end
    else
        startBatSkinWatcher()
        pcall(applyCurrentBatSkin)
    end
    if not _isLoading and not _isResetting then
        pcall(saveAllSettings)
    end
end

-- =====================================================================
-- [FIN KATANA]
-- =====================================================================

local function loadObjectsStd(id)
    local ok, res = pcall(function() return game:GetObjects("rbxassetid://" .. tostring(id)) end)
    if ok and typeof(res) == "table" and #res > 0 then return res end
    ok, res = pcall(function() return game:GetService("InsertService"):LoadAsset(id) end)
    if ok and res then return {res} end
    return nil
end

local function applyHeadlessToChar(char)
    if not char then return end
    pcall(function() LP.CharacterAvatarType = Enum.AvatarType.R6 end)
    local head = char:FindFirstChild("Head")
    if head then
        if head:GetAttribute("YoutOutfitOriginalTransparency") == nil then
            head:SetAttribute("YoutOutfitOriginalTransparency", head.Transparency)
            head:SetAttribute("YoutOutfitOriginalLocalTransparency", head.LocalTransparencyModifier)
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
                            if part:GetAttribute("YoutOutfitOriginalTransparency") == nil then
                                part:SetAttribute("YoutOutfitOriginalTransparency", part.Transparency)
                                part:SetAttribute("YoutOutfitOriginalLocalTransparency", part.LocalTransparencyModifier)
                            end
                            part.Transparency = 1
                            part.LocalTransparencyModifier = 1
                        end
                    end
                end
            end
        end
    end
end

local function applyKorbloxToChar(char, side)
    if not char then return end
    side = side or "right"

    local korbloxId = (side == "left") and "rbxassetid://139607625" or "rbxassetid://139607718"
    local targetBodyPart = (side == "left") and "LeftUpperLeg" or "RightUpperLeg"
    local partsToHide = (side == "left")
        and {"LeftUpperLeg", "LeftLowerLeg", "LeftFoot"}
        or  {"RightUpperLeg", "RightLowerLeg", "RightFoot"}
    local assetName = (side == "left") and "Korblox_LeftLeg" or "Korblox_RightLeg"

    local targetPart = char:FindFirstChild(targetBodyPart)
    if not targetPart then return end

    local oldAsset = char:FindFirstChild(assetName)
    if oldAsset then oldAsset:Destroy() end

    for _, partName in ipairs(partsToHide) do
        local limb = char:FindFirstChild(partName)
        if limb and limb:IsA("BasePart") then
            if limb:GetAttribute("YoutOutfitOriginalTransparency") == nil then
                limb:SetAttribute("YoutOutfitOriginalTransparency", limb.Transparency)
            end
            limb.Transparency = 1
        end
    end

    local success, objects = pcall(function() return game:GetObjects(korbloxId) end)
    if success and objects and #objects > 0 then
        local assetModel = objects[1]
        assetModel.Name = assetName
        local mainMesh = assetModel:IsA("BasePart") and assetModel or assetModel:FindFirstChildWhichIsA("BasePart", true)
        if mainMesh then
            mainMesh.CanCollide = false
            mainMesh.CFrame = targetPart.CFrame
            local weld = Instance.new("WeldConstraint")
            weld.Part0 = targetPart
            weld.Part1 = mainMesh
            weld.Parent = mainMesh
            assetModel.Parent = char
        end
    end
end

local function applyOutfitModifiers(char)
    if not char then return end

    for _, name in ipairs({"Korblox_LeftLeg", "Korblox_RightLeg"}) do
        local old = char:FindFirstChild(name)
        if old then old:Destroy() end
    end

    if OUTFIT_HEADLESS then
        pcall(applyHeadlessToChar, char)
    end

    if OUTFIT_KORBLOX == "both" then
        pcall(applyKorbloxToChar, char, "left")
        pcall(applyKorbloxToChar, char, "right")
    elseif OUTFIT_KORBLOX == "left" then
        pcall(applyKorbloxToChar, char, "left")
    elseif OUTFIT_KORBLOX == "right" then
        pcall(applyKorbloxToChar, char, "right")
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
        applyOutfitModifiers(char)
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
            if not head:GetAttribute("YoutOutfitModifiedMeshPart") then
                head:SetAttribute("YoutOutfitOriginalMeshId", head.MeshId)
                head:SetAttribute("YoutOutfitOriginalTextureId", head.TextureID)
                head:SetAttribute("YoutOutfitModifiedMeshPart", true)
            end
            head.MeshId = cfg.headMesh
            head.TextureID = cfg.headTexture or ""
        end)
    end
    if not done then
        local sm = head:FindFirstChildWhichIsA("SpecialMesh")
        if not sm then
            sm = Instance.new("SpecialMesh")
            sm:SetAttribute("YoutOutfitCreatedMesh", true)
        elseif not sm:GetAttribute("YoutOutfitModifiedMesh") then
            sm:SetAttribute("YoutOutfitOriginalMeshId", sm.MeshId)
            sm:SetAttribute("YoutOutfitOriginalTextureId", sm.TextureId)
            sm:SetAttribute("YoutOutfitModifiedMesh", true)
        end
        sm.Parent = head
        sm.MeshType = Enum.MeshType.FileMesh
        sm.MeshId = cfg.headMesh
        sm.TextureId = cfg.headTexture or ""
    end
    if cfg.shirt then
        local s = char:FindFirstChildWhichIsA("Shirt") or Instance.new("Shirt")
        s.Name = "Shirt"; s.ShirtTemplate = cfg.shirt; s.Parent = char
    end
    if cfg.pants then
        local p = char:FindFirstChildWhichIsA("Pants") or Instance.new("Pants")
        p.Name = "Pants"; p.PantsTemplate = cfg.pants; p.Parent = char
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
                h.CanCollide = false; h.Anchored = false; h.Massless = true
                h.Parent = char
                local weld = Instance.new("Weld")
                weld.Part0 = head; weld.Part1 = h
                weld.C0 = _CFnew(cfg.offset); weld.Parent = h
            end
            for _, o in ipairs(objs) do pcall(function() o:Destroy() end) end
        end
    end

    applyOutfitModifiers(char)

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
    if YOUT_BATV2_CONN then YOUT_BATV2_CONN:Disconnect() end
end)
YOUT_BATV2_CONN = nil
YOUT_BATV2_COOLDOWN = false
local _YOUT_BATV2_STATE = _G.__YoutBatV2PersistentState
if type(_YOUT_BATV2_STATE) ~= "table" then
    _YOUT_BATV2_STATE = {
        enabled = false, conn = nil, safetyConn = nil, respawnConn = nil,
        cooldown = false, generation = 0, equipped = false, target = nil,
        intendedVelocity = Vector3.zero, angularVelocity = nil, attachment = nil,
    }
    _G.__YoutBatV2PersistentState = _YOUT_BATV2_STATE
else
    pcall(function()
        if _YOUT_BATV2_STATE.conn then _YOUT_BATV2_STATE.conn:Disconnect() end
        if _YOUT_BATV2_STATE.safetyConn then _YOUT_BATV2_STATE.safetyConn:Disconnect() end
        if _YOUT_BATV2_STATE.respawnConn then _YOUT_BATV2_STATE.respawnConn:Disconnect() end
        if _YOUT_BATV2_STATE.bodyLockConn then _YOUT_BATV2_STATE.bodyLockConn:Disconnect() end
        if _YOUT_BATV2_STATE.angularVelocity and _YOUT_BATV2_STATE.angularVelocity.Parent then
            _YOUT_BATV2_STATE.angularVelocity:Destroy()
        end
        if _YOUT_BATV2_STATE.attachment and _YOUT_BATV2_STATE.attachment.Parent then
            _YOUT_BATV2_STATE.attachment:Destroy()
        end
    end)
    _YOUT_BATV2_STATE.enabled = false
    _YOUT_BATV2_STATE.conn = nil
    _YOUT_BATV2_STATE.safetyConn = nil
    _YOUT_BATV2_STATE.respawnConn = nil
    _YOUT_BATV2_STATE.bodyLockConn = nil
    _YOUT_BATV2_STATE.cooldown = false
    _YOUT_BATV2_STATE.equipped = false
    _YOUT_BATV2_STATE.target = nil
    _YOUT_BATV2_STATE.intendedVelocity = Vector3.zero
    _YOUT_BATV2_STATE.angularVelocity = nil
    _YOUT_BATV2_STATE.attachment = nil
    _YOUT_BATV2_STATE.generation = (_YOUT_BATV2_STATE.generation or 0) + 1
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

local _s2VelState = _G.__YoutSpeedHookState
if type(_s2VelState) ~= "table" then
    _s2VelState = {
        hooked = false,
        velChecked = setmetatable({}, { __mode = "k" }),
        root = nil,
        v = _V3zero,
    }
    _G.__YoutSpeedHookState = _s2VelState
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

local _youtVelRng = Random.new()

local function _applyVelocitySpeed(dir, speed, hrp)
    if not hrp or not hrp.Parent then return end
    if batDesyncTpEnabled or autoBatEnabled or _YOUT_BATV2_STATE.enabled then return end
    if type(speed) ~= "number" or speed ~= speed or speed <= 0 or speed == math.huge then return end
    local verticalVelocity = hrp.AssemblyLinearVelocity.Y
    if dir and dir.Magnitude > 0.05 then
        pcall(function()
            if hrp.SetNetworkOwner then hrp:SetNetworkOwner(LP) end
        end)
        local unit = dir.Unit
        local jx = _youtVelRng:NextNumber(-0.003, 0.003)
        local jz = _youtVelRng:NextNumber(-0.003, 0.003)
        _s2VelState.v = _V3new(unit.X * 16 + jx, verticalVelocity, unit.Z * 16 + jz)
        hrp.AssemblyLinearVelocity = _V3new(unit.X * speed + jx, verticalVelocity, unit.Z * speed + jz)
        _G.__YoutLiveSpeed = { t = os.clock(), v = speed }
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
    BatV2        = {kb = nil, gp = nil},
    TPFloor      = {kb = Enum.KeyCode.F, gp = nil},
    GuiHide      = {kb = Enum.KeyCode.LeftControl, gp = nil},
    CarryToggle  = {kb = Enum.KeyCode.Q, gp = nil},
    LaggerMode   = {kb = Enum.KeyCode.R, gp = nil},
    TPBat        = {kb = Enum.KeyCode.V, gp = nil},
    InstaReset   = {kb = Enum.KeyCode.H, gp = nil},
}

KB = {
    DropBrainrot = {kb = DEFAULT_KB.DropBrainrot.kb, gp = DEFAULT_KB.DropBrainrot.gp},
    AutoLeft     = {kb = DEFAULT_KB.AutoLeft.kb, gp = DEFAULT_KB.AutoLeft.gp},
    AutoRight    = {kb = DEFAULT_KB.AutoRight.kb, gp = DEFAULT_KB.AutoRight.gp},
    AutoBat      = {kb = DEFAULT_KB.AutoBat.kb, gp = DEFAULT_KB.AutoBat.gp},
    BatV2        = {kb = DEFAULT_KB.BatV2.kb, gp = DEFAULT_KB.BatV2.gp},
    TPFloor      = {kb = DEFAULT_KB.TPFloor.kb, gp = DEFAULT_KB.TPFloor.gp},
    GuiHide      = {kb = DEFAULT_KB.GuiHide.kb, gp = DEFAULT_KB.GuiHide.gp},
    CarryToggle  = {kb = DEFAULT_KB.CarryToggle.kb, gp = DEFAULT_KB.CarryToggle.gp},
    LaggerMode   = {kb = DEFAULT_KB.LaggerMode.kb, gp = DEFAULT_KB.LaggerMode.gp},
    TPBat        = {kb = DEFAULT_KB.TPBat.kb, gp = DEFAULT_KB.TPBat.gp},
    InstaReset   = {kb = DEFAULT_KB.InstaReset.kb, gp = DEFAULT_KB.InstaReset.gp},
}

_isResetting = false
_lastSavedJSON = nil
_isLoading = false

CONFIG = { AUTO_STEAL_ENABLED = false, STEAL_RANGE = 61 }

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
        if yb and yb:IsA("BillboardGui") then return yb.Enabled == true end
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
                if hrp and (hrp.Position - prompt.Parent.Parent.Position).Magnitude > Steal.StealRadius then break end
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
                    if dist <= autoGrabSetDelayRadius then break
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

_G.YoutV2Steal = _G.YoutV2Steal or {
    enabled = false, radius = 10, primeRange = 80, holdMin = 1.3, holdMax = 2.6,
    entryDelay = 0.25, cooldown = 0.05,
    animals = {}, promptCache = {}, internalCache = {},
    state = {active = false, startTime = 0, phase = "idle", label = "", lastResult = "", lastResultTime = 0},
    plotSync = {caches = {}, connections = {}}, plots = nil, syncReady = false,
    scanThread = nil, conn = nil, lastScan = 0,
    animalsData = nil, channelFolder = nil, routeRemote = nil, requestData = nil
}

function _yv2Root()
    local c = LP.Character
    return c and (c:FindFirstChild("HumanoidRootPart") or c:FindFirstChild("UpperTorso")) or nil
end

function _yv2SplitPath(path)
    if typeof(path) == "table" then return path end
    local out = {}
    for p in string.gmatch(tostring(path), "[^%.]+") do table.insert(out, tonumber(p) or p) end
    return out
end

function _yv2ResolvePath(path, root)
    local cur, par, key = root, nil, nil
    for _, p in ipairs(_yv2SplitPath(path)) do
        par = cur; key = p; cur = cur and cur[p] or nil
    end
    return cur, par, key
end

function _yv2ApplyDiff(channelName, packet)
    local cache = _G.YoutV2Steal.plotSync.caches[channelName]
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

function _yv2AttachChannel(remote, plots, requestData)
    local A = _G.YoutV2Steal
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

function _yv2EnsureSync()
    local A = _G.YoutV2Steal
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

function _yv2PlotOwner(plot)
    local sign = plot and plot:FindFirstChild("PlotSign")
    local frame = sign and sign:FindFirstChild("SurfaceGui") and sign.SurfaceGui:FindFirstChild("Frame")
    local label = frame and frame:FindFirstChild("TextLabel")
    if not label or label.Text == "Empty Base" then return nil end
    return label.Text:gsub("'s [Bb]ase$", ""):gsub("%s+$", "")
end

function _yv2IsMyBase(animalData)
    local A = _G.YoutV2Steal
    if not animalData or not animalData.plot or not A.plots then return false end
    local plot = A.plots:FindFirstChild(animalData.plot)
    if not plot then return false end
    local owner = _yv2PlotOwner(plot)
    return owner == LP.DisplayName or owner == LP.Name
end

function _yv2PodiumFor(animalData)
    local A = _G.YoutV2Steal
    local plot = A.plots and A.plots:FindFirstChild(animalData.plot)
    local pds = plot and plot:FindFirstChild("AnimalPodiums")
    return pds and pds:FindFirstChild(animalData.slot) or nil
end

function _yv2AnimalPos(animalData)
    local pod = _yv2PodiumFor(animalData)
    return pod and pod:GetPivot().Position or nil
end

function _yv2DistToAnimal(animalData)
    local root = _yv2Root()
    local pos = _yv2AnimalPos(animalData)
    return root and pos and (root.Position - pos).Magnitude or math.huge
end

function _yv2FindPrompt(animalData)
    local A = _G.YoutV2Steal
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

function _yv2BuildCallbacks(prompt)
    local A = _G.YoutV2Steal
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

function _yv2SetBar(p)
    if progressFill then progressFill.Size = UDim2.new(math.clamp(p, 0, 1), 0, 1, 0) end
    if progressPct then progressPct.Text = _floor(math.clamp(p, 0, 1) * 100) .. "%" end
end

function _yv2ResetBar()
    if progressFill then progressFill.Size = UDim2.new(0, 0, 1, 0) end
    if progressPct then progressPct.Text = "0%" end
end

function _yv2Execute(prompt, animalData)
    local A = _G.YoutV2Steal
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
    local A = _G.YoutV2Steal
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
    local A = _G.YoutV2Steal
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
    local A = _G.YoutV2Steal
    if A.scanThread then return end
    A.scanThread = task.spawn(function()
        while _G.YoutV2Steal do
            if A.enabled or selectedStealMode == "V2" then pcall(_yv2ScanAllPlots) end
            task.wait(5)
        end
    end)
end

function stopAutoStealV2()
    local A = _G.YoutV2Steal
    A.enabled = false
    if A.conn then A.conn:Disconnect() A.conn = nil end
    A.state.active = false
    A.state.phase = "idle"
    _yv2ResetBar()
end

function startAutoStealV2()
    local A = _G.YoutV2Steal
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
    if root.Position.Y - hit.Position.Y > trigger then executeTPDown() end
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
        if UIS:IsKeyDown(kc) then pcall(_tpDownTick) end
    end)
end
startTpDownHold()

local AntiRagdollV2 = { Enabled = false, Connection = nil, ResetCooldown = 0 }

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
        if hum.Health < (hum.MaxHealth or 100) then hum.Health = hum.MaxHealth or 100 end
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
            if root then pcall(function() root.AssemblyAngularVelocity = Vector3.zero end) end
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
    if enabled then _antiDie.StartEngine() else _antiDie.StopEngine() end
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

setAntiFlingVisual = nil

local _antiFlingState = { connection = nil, threshold = 80, spinThreshold = 40 }
local _ANTI_FLING_DRIVE_GRACE = 0.3

local function _afHubSpeedLive()
    local live = _G.__YoutLiveSpeed
    if type(live) ~= "table" then return false end
    local stamp, speed = tonumber(live.t), tonumber(live.v)
    if not stamp or not speed or speed <= 0 then return false end
    return (os.clock() - stamp) <= _ANTI_FLING_DRIVE_GRACE
end

local function _afOwnMoverActive()
    if batDesyncTpEnabled then return true end
    if _YOUT_BATV2_STATE.enabled then return true end
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

local espEnabled = espEnabled or false
local espActivePlayers = {}
local espLoopConn = nil
local Camera = workspace.CurrentCamera
local GUI2_ESP_COLOR = Color3.fromRGB(105, 190, 245)
local GUI2_ESP_TEXT_STROKE = Color3.fromRGB(30, 8, 50)

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
    esp.Highlight.Name = "YoutESP_Highlight"
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
    nameBillboard.Name = "YoutESP_Name"
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
    nameLabel.Font = Enum.Font.FredokaOne
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

_G.__YoutRefreshESPTheme = function(accent, outlineColor)
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

local _espLineGui = nil
local _espLineFrame = nil
local _espLineOutline = nil
local _espLineConn = nil
local _espLineState = { scanElapsed = math.huge, targetRoot = nil }

local function ensureESPLineGui()
    if _espLineGui and _espLineGui.Parent then return end
    _espLineGui = Instance.new("ScreenGui")
    _espLineGui.Name = "YoutESPLine"
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
        if not ok and _espLineFrame then pcall(function() _espLineFrame.Visible = false end) end
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
                        tl.Font = Enum.Font.FredokaOne
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
    if _blSuppressCount > 0 then _blSuppressCount = _blSuppressCount - 1 end
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
        if delayed then _blRestoreTimer = task.delay(1, restore) else restore() end
    end
end

function setupSpeedIndicator(char)
    local head = char:WaitForChild("Head", 5)
    if not head then return end
    local oldBB = head:FindFirstChild("YoutSpeedIndicator")
    if oldBB then oldBB:Destroy() end
    local oldDiscord = head:FindFirstChild("DiscordText")
    if oldDiscord then oldDiscord:Destroy() end
    local bb = Instance.new("BillboardGui", head)
    bb.Name = "YoutSpeedIndicator"
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
    discordLabel.Text = "discord.gg/fearhub"
    discordLabel.TextColor3 = ACTIVE_PINK
    discordLabel.Font = Enum.Font.FredokaOne
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
    speedLabel.TextColor3 = ACTIVE_PINK
    speedLabel.Font = Enum.Font.FredokaOne
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

function refreshOutfitModifierVisuals()
    if setOutfitHeadlessVisual then
        setOutfitHeadlessVisual(OUTFIT_HEADLESS and "On" or "Off")
    end
    if setOutfitKorbloxVisual then
        local lbl = "None"
        if OUTFIT_KORBLOX == "left" then lbl = "Left"
        elseif OUTFIT_KORBLOX == "right" then lbl = "Right"
        elseif OUTFIT_KORBLOX == "both" then lbl = "Both" end
        setOutfitKorbloxVisual(lbl)
    end
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
    if _G.__YoutApplySpeedNow then pcall(_G.__YoutApplySpeedNow) end
end

function toggleLaggerMode()
    if laggerCarryToggled then laggerCarryToggled = false end
    speedMode = false; laggerToggled = not laggerToggled
    resetMovementState()
    if _G.__YoutApplySpeedNow then pcall(_G.__YoutApplySpeedNow) end
end
function toggleLaggerCarryMode()
    if laggerToggled then laggerToggled = false end
    speedMode = false; laggerCarryToggled = not laggerCarryToggled
    resetMovementState()
    if _G.__YoutApplySpeedNow then pcall(_G.__YoutApplySpeedNow) end
end

function toggleLaggerCycle()
    if speedMode then
        speedMode = false; laggerToggled = true; laggerCarryToggled = false
    elseif laggerToggled then
        speedMode = false; laggerToggled = false; laggerCarryToggled = true
    else
        speedMode = true; laggerToggled = false; laggerCarryToggled = false
    end
    resetMovementState()
    if _G.__YoutApplySpeedNow then pcall(_G.__YoutApplySpeedNow) end
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
    if _YOUT_BATV2_STATE.enabled and stopYoutBatV2 then stopYoutBatV2() end
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

local _YOUT_BYPASS_REMOVE = {
    "LockBAV", "LockAngVel", "LockBodyAtt", "BatLock", "LockBAVAtt",
    "AutoBatAtt", "AutoBatAV", "AntiBatDet", "AntiAim", "VelocityLock",
}

local function _YOUT_BYPASS_CLEAN_LOCKS(root)
    if not root then return end
    pcall(function()
        for _, name in ipairs(_YOUT_BYPASS_REMOVE) do
            local obj = root:FindFirstChild(name)
            if obj then obj:Destroy() end
        end
        for _, child in ipairs(root:GetChildren()) do
            local n = child.Name:lower()
            if child.Name ~= "_GB_AngV" and child.Name ~= "_GB_Att" then
                if n:find("lockb", 1, true) or n:find("lockangv", 1, true)
                or n:find("batlock", 1, true) or n:find("antiaim", 1, true)
                or n:find("velocitylock", 1, true) then
                    child:Destroy()
                end
            end
        end
    end)
end

local function _YOUT_BYPASS_DESTROY_ROTATOR()
    pcall(function()
        if _YOUT_BATV2_STATE.angularVelocity and _YOUT_BATV2_STATE.angularVelocity.Parent then
            _YOUT_BATV2_STATE.angularVelocity:Destroy()
        end
    end)
    pcall(function()
        if _YOUT_BATV2_STATE.attachment and _YOUT_BATV2_STATE.attachment.Parent then
            _YOUT_BATV2_STATE.attachment:Destroy()
        end
    end)
    _YOUT_BATV2_STATE.angularVelocity = nil
    _YOUT_BATV2_STATE.attachment = nil
end

local function _YOUT_BYPASS_CREATE_ROTATOR(root)
    if not root then return end
    pcall(function()
        local oldAv = root:FindFirstChild("_GB_AngV")
        local oldAtt = root:FindFirstChild("_GB_Att")
        if oldAv then oldAv:Destroy() end
        if oldAtt then oldAtt:Destroy() end
    end)
    local attachment = Instance.new("Attachment")
    attachment.Name = "_GB_Att"
    attachment.Parent = root
    local angularVelocity = Instance.new("AngularVelocity")
    angularVelocity.Name = "_GB_AngV"
    angularVelocity.Attachment0 = attachment
    angularVelocity.RelativeTo = Enum.ActuatorRelativeTo.World
    angularVelocity.MaxTorque = math.huge
    angularVelocity.AngularVelocity = Vector3.zero
    angularVelocity.Parent = root
    _YOUT_BATV2_STATE.attachment = attachment
    _YOUT_BATV2_STATE.angularVelocity = angularVelocity
end

local function _YOUT_BYPASS_CLOSEST(root)
    local closest = nil
    local closestDistance = math.huge
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LP and player.Character then
            local targetRoot = player.Character:FindFirstChild("HumanoidRootPart")
            local targetHumanoid = player.Character:FindFirstChildOfClass("Humanoid")
            if targetRoot and targetHumanoid and targetHumanoid.Health > 0 then
                local distance = (targetRoot.Position - root.Position).Magnitude
                if distance < closestDistance then
                    closestDistance = distance
                    closest = targetRoot
                end
            end
        end
    end
    return closest, closestDistance
end

local function _YOUT_BYPASS_FIND_BAT()
    local character = LP.Character
    if not character then return nil end
    local bat = character:FindFirstChild("Bat") or character:FindFirstChild("bat")
    if bat and bat:IsA("Tool") then return bat end
    local equipped = character:FindFirstChildOfClass("Tool")
    if equipped then
        local n = equipped.Name:lower()
        if n:find("bat", 1, true) or n:find("slap", 1, true) then return equipped end
    end
    local backpack = LP:FindFirstChildOfClass("Backpack")
    if backpack then
        local direct = backpack:FindFirstChild("Bat") or backpack:FindFirstChild("bat")
        if direct and direct:IsA("Tool") then return direct end
        for _, tool in ipairs(backpack:GetChildren()) do
            if tool:IsA("Tool") then
                local n = tool.Name:lower()
                if n:find("bat", 1, true) or n:find("slap", 1, true) then return tool end
            end
        end
    end
    return nil
end

local function _YOUT_BYPASS_SWING(character, humanoid)
    local bat = character:FindFirstChild("Bat") or character:FindFirstChild("bat")
    if not bat then
        bat = _YOUT_BYPASS_FIND_BAT()
        if bat and bat.Parent ~= character then
            pcall(function() humanoid:EquipTool(bat) end)
        end
    end
    if bat and bat:IsA("Tool") and bat.Parent == character then
        pcall(function()
            bat:Activate()
            local remoteEvent = bat:FindFirstChildWhichIsA("RemoteEvent")
            if remoteEvent then remoteEvent:FireServer() end
        end)
    end
end

function stopYoutBatV2()
    _YOUT_BATV2_STATE.enabled = false
    _YOUT_BATV2_STATE.generation = (_YOUT_BATV2_STATE.generation or 0) + 1
    _YOUT_BATV2_STATE.equipped = false
    _YOUT_BATV2_STATE.target = nil
    if _YOUT_BATV2_STATE.conn then
        pcall(function() _YOUT_BATV2_STATE.conn:Disconnect() end)
        _YOUT_BATV2_STATE.conn = nil
    end
    if _YOUT_BATV2_STATE.safetyConn then
        pcall(function() _YOUT_BATV2_STATE.safetyConn:Disconnect() end)
        _YOUT_BATV2_STATE.safetyConn = nil
    end
    if _YOUT_BATV2_STATE.respawnConn then
        pcall(function() _YOUT_BATV2_STATE.respawnConn:Disconnect() end)
        _YOUT_BATV2_STATE.respawnConn = nil
    end
    local character = LP.Character
    local root = character and character:FindFirstChild("HumanoidRootPart")
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    if root then root.Velocity = root.Velocity * 0.3 end
    if humanoid then humanoid.AutoRotate = true end
    if _YOUT_BATV2_STATE.angularVelocity then
        pcall(function() _YOUT_BATV2_STATE.angularVelocity.AngularVelocity = Vector3.zero end)
    end
    _YOUT_BYPASS_DESTROY_ROTATOR()
    _unsuppressBodyLock(true)
    if batV2FloatingButton then
        local frame = batV2FloatingButton:FindFirstChild("Frame")
        if frame then paintFloatingBtn(frame, false) end
    end
end

function startYoutBatV2()
    stopYoutBatV2()
    if autoBatEnabled then
        autoBatEnabled = false
        stopAimbotAdapt()
        if autoBatSetVisual then autoBatSetVisual(false) end
        if mobSetAutoBat then mobSetAutoBat(false) end
    end
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
    if batDesyncTpEnabled then
        stopBatDesyncTp()
        batDesyncTpEnabled = false
        if batDesyncTpSetVisual then batDesyncTpSetVisual(false) end
    end
    _suppressBodyLock()
    _YOUT_BATV2_STATE.enabled = true
    _YOUT_BATV2_STATE.equipped = false
    _YOUT_BATV2_STATE.target = nil
    _YOUT_BATV2_STATE.intendedVelocity = Vector3.zero
    _YOUT_BATV2_STATE.generation = (_YOUT_BATV2_STATE.generation or 0) + 1
    local generation = _YOUT_BATV2_STATE.generation
    local character = LP.Character
    local root = character and character:FindFirstChild("HumanoidRootPart")
    if root then
        _YOUT_BYPASS_CLEAN_LOCKS(root)
        _YOUT_BYPASS_CREATE_ROTATOR(root)
    end
    _YOUT_BATV2_STATE.conn = RunService.Heartbeat:Connect(function()
        if not _YOUT_BATV2_STATE.enabled or _YOUT_BATV2_STATE.generation ~= generation then return end
        local character2 = LP.Character
        local humanoid = character2 and character2:FindFirstChildOfClass("Humanoid")
        local root2 = character2 and character2:FindFirstChild("HumanoidRootPart")
        if not root2 or not humanoid or humanoid.Health <= 0 then return end
        _YOUT_BYPASS_CLEAN_LOCKS(root2)
        if not _YOUT_BATV2_STATE.angularVelocity or not _YOUT_BATV2_STATE.angularVelocity.Parent then
            _YOUT_BYPASS_CREATE_ROTATOR(root2)
        end
        if not _YOUT_BATV2_STATE.equipped then
            _YOUT_BATV2_STATE.equipped = true
            if not character2:FindFirstChildOfClass("Tool") then
                local bat = _YOUT_BYPASS_FIND_BAT()
                if bat then pcall(function() humanoid:EquipTool(bat) end) end
            end
        end
        local target, distance = _YOUT_BYPASS_CLOSEST(root2)
        if not target then
            _YOUT_BATV2_STATE.target = nil
            humanoid.AutoRotate = true
            if _YOUT_BATV2_STATE.angularVelocity then
                _YOUT_BATV2_STATE.angularVelocity.AngularVelocity = Vector3.zero
            end
            return
        end
        _YOUT_BATV2_STATE.target = target
        local aimPoint = target.Position + target.CFrame.LookVector * (target.Velocity.Magnitude < 0.1 and 1.5 or 5)
        local delta = aimPoint - root2.Position
        local flat = Vector3.new(delta.X, 0, delta.Z)
        humanoid.AutoRotate = false
        if delta.Magnitude > 0.01 and flat.Magnitude > 0.01 then
            local currentYaw = root2.Orientation.Y
            local yawError = (math.deg(math.atan2(-flat.X, -flat.Z)) - currentYaw + 180) % 360 - 180
            local currentPitch = root2.Orientation.X
            local pitchError = (math.deg(math.atan2(delta.Y, flat.Magnitude)) - currentPitch + 180) % 360 - 180
            local yawVelocity = math.clamp(math.rad(yawError) * 40, -28, 28)
            local pitchVelocity = math.clamp(math.rad(pitchError) * 40, -28, 28)
            local yawRad = math.rad(root2.Orientation.Y)
            local pitchAxis = Vector3.new(math.cos(yawRad), 0, -math.sin(yawRad))
            _YOUT_BATV2_STATE.angularVelocity.AngularVelocity = Vector3.new(0, yawVelocity, 0) + pitchAxis * pitchVelocity
        else
            _YOUT_BATV2_STATE.angularVelocity.AngularVelocity = Vector3.zero
        end
        local moveDelta = aimPoint - root2.Position
        local horizontal = Vector3.new(moveDelta.X, 0, moveDelta.Z)
        _YOUT_BATV2_STATE.intendedVelocity = (horizontal.Magnitude > 0.1 and horizontal.Unit * 58 or Vector3.zero) + (math.abs(moveDelta.Y) > 0.8 and Vector3.new(0, math.sign(moveDelta.Y) * 58, 0) or Vector3.new(0, -2, 0))
        root2.Velocity = _YOUT_BATV2_STATE.intendedVelocity
        if horizontal.Magnitude > 0.5 then humanoid:Move(horizontal.Unit, false) end
        if distance <= 10 then _YOUT_BYPASS_SWING(character2, humanoid) end
    end)
    _YOUT_BATV2_STATE.safetyConn = RunService.RenderStepped:Connect(function()
        if not _YOUT_BATV2_STATE.enabled or _YOUT_BATV2_STATE.generation ~= generation then return end
        local root2 = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
        if not root2 then return end
        local velocity = root2.Velocity
        if math.abs(velocity.X) > 350 or math.abs(velocity.Z) > 350 then
            root2.Velocity = _YOUT_BATV2_STATE.intendedVelocity
        end
        _YOUT_BYPASS_CLEAN_LOCKS(root2)
    end)
    _YOUT_BATV2_STATE.respawnConn = LP.CharacterAdded:Connect(function(newCharacter)
        task.wait(0.5)
        _YOUT_BATV2_STATE.equipped = false
        _YOUT_BATV2_STATE.target = nil
        if _YOUT_BATV2_STATE.enabled and _YOUT_BATV2_STATE.generation == generation then
            local newRoot = newCharacter:WaitForChild("HumanoidRootPart", 5)
            if newRoot then
                _YOUT_BYPASS_CLEAN_LOCKS(newRoot)
                _YOUT_BYPASS_CREATE_ROTATOR(newRoot)
            end
        end
    end)
    if batV2FloatingButton then
        local frame = batV2FloatingButton:FindFirstChild("Frame")
        if frame then paintFloatingBtn(frame, true) end
    end
    return true
end

local function updateTpBatButtonWithAntiDie(state)
    if tpBatFloatingButton then
        local btnFrame = tpBatFloatingButton:FindFirstChild("Frame")
        if btnFrame then
            local label = btnFrame:FindFirstChild("TextLabel")
            if label then label.Text = "TP\nBAT" end
            if state then paintFloatingBtn(btnFrame, true)
            else paintFloatingBtn(btnFrame, batDesyncTpEnabled) end
        end
    end
end

batDesyncTpEnabled = false
local batDesyncTpConn = nil
local batDesyncTpSetVisual = nil
local _tpBatUnwalkForced = false

local TEST_TPBAT_NAMES = {
    "Bat","Slap","Iron Slap","Gold Slap","Diamond Slap",
    "Emerald Slap","Ruby Slap","Dark Matter Slap","Flame Slap",
    "Nuclear Slap","Galaxy Slap","Glitched Slap","Rainbow Slap",
    "Plasmatic Slap","Plasma Slap","Admin Slap","Ban Hammer",
    "Taco Slap","Ghost Slap","Frost Slap","Thunder Slap"
}

local testTPBatState = { h = nil, hrp = nil, lastSwing = 0, aimTarget = nil }

local function testTPBatGetBat()
    local char = LP.Character
    if not char then return nil end
    local function isBatTool(t)
        if not t or not t:IsA("Tool") then return false end
        local n = t.Name:lower()
        return n:find("bat") or n:find("slap") or n:find("hammer")
    end
    for _, name in ipairs(TEST_TPBAT_NAMES) do
        local tool = char:FindFirstChild(name)
        if tool and tool:IsA("Tool") then return tool end
    end
    for _, t in ipairs(char:GetChildren()) do
        if isBatTool(t) then return t end
    end
    local bp = LP:FindFirstChildOfClass("Backpack")
    if bp then
        for _, name in ipairs(TEST_TPBAT_NAMES) do
            local tool = bp:FindFirstChild(name)
            if tool and tool:IsA("Tool") then
                pcall(function()
                    local hum = char:FindFirstChildOfClass("Humanoid")
                    if hum then hum:EquipTool(tool) else tool.Parent = char end
                end)
                return tool
            end
        end
        for _, t in ipairs(bp:GetChildren()) do
            if isBatTool(t) then
                pcall(function()
                    local hum = char:FindFirstChildOfClass("Humanoid")
                    if hum then hum:EquipTool(t) else t.Parent = char end
                end)
                return t
            end
        end
    end
    return nil
end

local function testTPBatTrySwing(targetPlayer)
    if _tick() - testTPBatState.lastSwing < 0.04 then return end
    testTPBatState.lastSwing = _tick()
    pcall(function()
        local char = LP.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        local meRoot = char:FindFirstChild("HumanoidRootPart")
        local bat = testTPBatGetBat()
        if not bat or not meRoot then return end
        if bat.Parent ~= char then
            if hum then pcall(function() hum:EquipTool(bat) end)
            else bat.Parent = char end
        end
        local tChar = targetPlayer and targetPlayer.Character
        if not tChar then return end
        local tRoot = tChar:FindFirstChild("HumanoidRootPart") or tChar:FindFirstChild("UpperTorso") or tChar:FindFirstChild("Torso")
        if not tRoot then return end
        local pos = tRoot.Position + _V3new(0, 1.2, 0)
        meRoot.CFrame = _CFlookAt(pos, tRoot.Position)
        meRoot.AssemblyLinearVelocity = Vector3.zero
        meRoot.AssemblyAngularVelocity = Vector3.zero
        local handle = bat:FindFirstChild("Handle")
        if handle then
            pcall(function()
                handle.CanTouch = true
                handle.CanQuery = true
                handle.CFrame = tRoot.CFrame
            end)
        end
        local parts = {}
        for _, d in ipairs(tChar:GetDescendants()) do
            if d:IsA("BasePart") then table.insert(parts, d) end
        end
        for i = 1, 8 do
            pcall(function() bat:Activate() end)
            for _, child in ipairs(bat:GetChildren()) do
                if child:IsA("RemoteEvent") then pcall(function() child:FireServer() end)
                elseif child:IsA("RemoteFunction") then pcall(function() child:InvokeServer() end) end
            end
            for _, rem in ipairs(bat:GetDescendants()) do
                if rem:IsA("RemoteEvent") then pcall(function() rem:FireServer() end) end
            end
            if firetouchinterest and handle then
                for _, part in ipairs(parts) do
                    pcall(function()
                        firetouchinterest(handle, part, 0)
                        firetouchinterest(handle, part, 1)
                    end)
                end
            end
            if i == 4 then RunService.Heartbeat:Wait() end
        end
    end)
end

local function testTPBatClosest()
    local hrp = testTPBatState.hrp
    if not hrp or not hrp.Parent then
        local c = LP.Character
        hrp = c and c:FindFirstChild("HumanoidRootPart")
        if hrp then testTPBatState.hrp = hrp end
    end
    if not hrp then return nil end
    local closest, bestDist = nil, _huge
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LP and player.Character then
            local root = player.Character:FindFirstChild("HumanoidRootPart")
            local hum = player.Character:FindFirstChildOfClass("Humanoid")
            if root and hum and hum.Health > 0 then
                local dist = (hrp.Position - root.Position).Magnitude
                if dist < bestDist then bestDist = dist; closest = player end
            end
        end
    end
    return closest, bestDist
end

local function testTPBatHeartbeat()
    if not batDesyncTpEnabled then return end
    local meRoot = testTPBatState.hrp
    local meHum = testTPBatState.h
    if not meRoot or not meRoot.Parent then
        local c = LP.Character
        if not c then return end
        meRoot = c:FindFirstChild("HumanoidRootPart")
        meHum = c:FindFirstChildOfClass("Humanoid")
        testTPBatState.hrp = meRoot
        testTPBatState.h = meHum
        if not meRoot or not meHum then return end
    end
    meHum.PlatformStand = false
    meHum.Sit = false
    if sethiddenproperty then pcall(sethiddenproperty, meRoot, "PhysicsRepRootPart", nil) end
    local st = meHum:GetState()
    if st == Enum.HumanoidStateType.Physics or st == Enum.HumanoidStateType.Ragdoll or st == Enum.HumanoidStateType.FallingDown then
        pcall(function()
            meHum:ChangeState(Enum.HumanoidStateType.GettingUp)
            meHum:ChangeState(Enum.HumanoidStateType.Running)
        end)
    end
    local myV = meRoot.AssemblyLinearVelocity
    if myV.Magnitude > 85 then
        meRoot.AssemblyLinearVelocity = Vector3.zero
        meRoot.AssemblyAngularVelocity = Vector3.zero
    end
    local target = testTPBatClosest()
    testTPBatState.aimTarget = target
    if not target or not target.Character then return end
    local targetRoot = target.Character:FindFirstChild("HumanoidRootPart")
    if not targetRoot then return end
    local tHum = target.Character:FindFirstChildOfClass("Humanoid")
    if tHum and tHum.Health <= 0 then return end
    local pos = targetRoot.Position + _V3new(0, 1.2, 0)
    meRoot.CFrame = _CFlookAt(pos, targetRoot.Position)
    meRoot.AssemblyLinearVelocity = Vector3.zero
    meRoot.AssemblyAngularVelocity = Vector3.zero
    local cam = workspace.CurrentCamera
    if cam then cam.CFrame = _CFnew(cam.CFrame.Position, targetRoot.Position) end
    testTPBatTrySwing(target)
end

function startBatDesyncTp()
    if batDesyncTpConn then batDesyncTpConn:Disconnect(); batDesyncTpConn = nil end
    batDesyncTpEnabled = true
    testTPBatState.lastSwing = 0
    local char = LP.Character
    if char then
        testTPBatState.h = char:FindFirstChildOfClass("Humanoid")
        testTPBatState.hrp = char:FindFirstChild("HumanoidRootPart")
        pcall(function()
            local bat = testTPBatGetBat()
            local hum = char:FindFirstChildOfClass("Humanoid")
            if bat and hum and bat.Parent ~= char then hum:EquipTool(bat) end
        end)
    end
    batDesyncTpConn = RunService.Heartbeat:Connect(testTPBatHeartbeat)
    if batDesyncTpSetVisual then batDesyncTpSetVisual(true) end
    updateTpBatButtonWithAntiDie(true)
end

function stopBatDesyncTp()
    batDesyncTpEnabled = false
    if batDesyncTpConn then batDesyncTpConn:Disconnect(); batDesyncTpConn = nil end
    local meRoot = testTPBatState.hrp
    if meRoot and sethiddenproperty then pcall(sethiddenproperty, meRoot, "PhysicsRepRootPart", nil) end
    testTPBatState.aimTarget = nil
    if batDesyncTpSetVisual then batDesyncTpSetVisual(false) end
    updateTpBatButtonWithAntiDie(false)
end

function toggleBatDesyncTp()
    if batDesyncTpEnabled then
        stopBatDesyncTp()
    else
        disableAllAimbots()
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
        startBatDesyncTp()
    end
    if batDesyncTpSetVisual then batDesyncTpSetVisual(batDesyncTpEnabled) end
    saveAllSettings()
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
        if ch:IsA("Tool") and (ch.Name:lower():find("bat") or ch.Name:lower():find("slap")) then return ch end
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
        if child:IsA("Tool") and (child.Name:lower():find("bat") or child.Name:lower():find("slap")) then return child end
    end
    if backpack then
        for _, child in ipairs(backpack:GetChildren()) do
            if child:IsA("Tool") and (child.Name:lower():find("bat") or child.Name:lower():find("slap")) then return child end
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
    if _dropConn then _dropConn:Disconnect(); _dropConn = nil end
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
                        table.remove(dropConnections, i); break
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
                    if r.Position.Y < -100 then r.CFrame = _CFnew(r.Position.X, 5, r.Position.Z) end
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
        Brightness = Lighting.Brightness, ClockTime = Lighting.ClockTime,
        OutdoorAmbient = Lighting.OutdoorAmbient, Ambient = Lighting.Ambient,
        GlobalShadows = Lighting.GlobalShadows,
        EnvironmentDiffuseScale = Lighting.EnvironmentDiffuseScale,
        EnvironmentSpecularScale = Lighting.EnvironmentSpecularScale,
        FogStart = Lighting.FogStart, FogEnd = Lighting.FogEnd,
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
            atmosphere.Density = 0; atmosphere.Glare = 0; atmosphere.Haze = 0
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
            or name:match("^BloodHounds") or name:match("^Yout") then
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

    -- Perfil liviano y reversible: evita recorrer todo Workspace,
    -- desactivar animaciones de otros jugadores o borrar texturas.
    _alSaveLighting()

    _alChange(Lighting, "GlobalShadows", false)
    _alChange(Lighting, "EnvironmentDiffuseScale", 0)
    _alChange(Lighting, "EnvironmentSpecularScale", 0)

    local terrain = workspace:FindFirstChildOfClass("Terrain")
    if terrain then
        _alChange(terrain, "Decoration", false)
        _alChange(terrain, "WaterWaveSize", 0)
        _alChange(terrain, "WaterWaveSpeed", 0)
        _alChange(terrain, "WaterReflectance", 0)
        local terrainClouds = terrain:FindFirstChildOfClass("Clouds")
        if terrainClouds then _alChange(terrainClouds, "Enabled", false) end
    end

    -- Solo efectos de postprocesado bajo Lighting; no toca GUIs ni personajes.
    for _, effect in ipairs(Lighting:GetChildren()) do
        if effect:IsA("PostEffect") then
            _alChange(effect, "Enabled", false)
        elseif effect:IsA("Atmosphere") then
            _alChange(effect, "Density", 0)
            _alChange(effect, "Haze", 0)
            _alChange(effect, "Glare", 0)
        elseif effect:IsA("Clouds") then
            _alChange(effect, "Enabled", false)
        end
    end
end

function disableAntiLag()
    if not _alRunning then antiLagEnabled = false; return end
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

SKY_PRESETS_LIST = {"Off","Night","Aurora","Sunset","Galaxy","Cyber","Sakura","Pink Night","Blood Moon","Emerald Dawn","Volcanic","Arctic","Midnight Ocean","Vaporwave","Toxic","Solar Eclipse","Hellscape","Heaven","Storm","Sunrise","Deep Space","Lavender Dream","Inferno","Mint Sky"}

SKY_PRESETS = {
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
    for _, eff in ipairs(_vividEffects) do pcall(function() eff:Destroy() end) end
    _vividEffects = {}
    local color = Instance.new("ColorCorrectionEffect")
    color.Parent = Lighting
    color.Saturation = 0.6; color.Contrast = 0.4; color.Brightness = 0.05
    color.TintColor = Color3.fromRGB(220, 242, 255)
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
    for _, eff in ipairs(_vividEffects) do pcall(function() eff:Destroy() end) end
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
            if child:IsA("TextButton") then child.Visible = not state end
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
    if bg then
        btnFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    else
        btnFrame.BackgroundColor3 = active
            and Color3.fromRGB(105, 185, 240)
            or Color3.fromRGB(0, 0, 0)
    end
    if active then
        if bg then
            setAnimatedActiveShine(bg, true, 45)
            bg.Rotation = 45
            bg.Offset = Vector2.new(0, 0)
        end
        if label then label.TextColor3 = Color3.fromRGB(255, 255, 255) end
        if stroke then
            stroke.Color = Color3.fromRGB(145, 215, 255)
            stroke.Thickness = 1.2
            stroke.Transparency = 0.1
        end
    else
        if bg then
            setAnimatedActiveShine(bg, false)
            bg.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0.00, Color3.fromRGB(145, 215, 255)),
                ColorSequenceKeypoint.new(0.52, Color3.fromRGB(95, 175, 235)),
                ColorSequenceKeypoint.new(1.00, Color3.fromRGB(55, 125, 180)),
            })
            bg.Rotation = 90
            bg.Offset = Vector2.new(0, 0)
        end
        if label then label.TextColor3 = Color3.fromRGB(195, 230, 255) end
        if stroke then
            stroke.Color = Color3.fromRGB(55, 125, 175)
            stroke.Thickness = 1
            stroke.Transparency = 0.15
        end
    end
end

function applyFloatingButtonScale()
    for _, uiScale in ipairs(_floatingUIScales) do
        if uiScale and uiScale.Parent then uiScale.Scale = floatingButtonScale end
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
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then stopDrag() end
    end)
    UIS.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then stopDrag() end
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

_G.__YoutSpeedEngine = _G.__YoutSpeedEngine or { started = false, conn = nil }
_G.__YoutSpeedEngine.signal = nil
do
    local _ok, _sig = pcall(function() return RunService.PreSimulation end)
    _G.__YoutSpeedEngine.signal = (_ok and _sig) or RunService.Heartbeat
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
    if _G.__YoutSpeedEngine.conn then
        _G.__YoutSpeedEngine.conn:Disconnect()
        _G.__YoutSpeedEngine.conn = nil
    end
    _spd_resetMovement()
end

local function _spd_start()
    _spd_stop()
    _G.__YoutSpeedEngine.started = true
    _G.__YoutSpeedEngine.acc = 0
    _G.__YoutSpeedEngine.conn = _G.__YoutSpeedEngine.signal:Connect(function(dt)
        _G.__YoutSpeedEngine.acc = (_G.__YoutSpeedEngine.acc or 0) + (dt or 0)
        if _G.__YoutSpeedEngine.acc < 0.016 then return end
        _G.__YoutSpeedEngine.acc = 0
        local character = LP.Character
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        local root = character and character:FindFirstChild("HumanoidRootPart")
        if not humanoid or not root or humanoid.Health <= 0 then return end
        if _YOUT_BATV2_STATE.enabled then return end
        if autoBatEnabled or batDesyncTpEnabled or autoLeftEnabled or autoRightEnabled or dropActive or _G.IsDropping then
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

local function _spd_refresh() _spd_start() end

_G.__YoutRefreshSpeedEngine = _spd_refresh
_G.__YoutStopSpeedEngine = _spd_stop
_G.__YoutApplySpeedNow = _spd_applyNow

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
                        if part:IsA("BasePart") and part.CanCollide then part.CanCollide = false end
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
        if not autoBatEnabled and not _YOUT_BATV2_STATE.enabled and not autoLeftEnabled and not autoRightEnabled and not batDesyncTpEnabled then
            if _isRagdollState(hum) then
                lastMoveDir = _V3zero
            else
                local md = hum.MoveDirection
                if md.Magnitude > 0 then lastMoveDir = md end
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
    if _YOUT_BATV2_STATE.enabled then stopYoutBatV2() end
    if autoBatEnabled then
        disableAutoBat()
        if autoBatSetVisual then autoBatSetVisual(false) end
        if mobSetAutoBat then mobSetAutoBat(false) end
    end
    if batDesyncTpEnabled then stopBatDesyncTp() end
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
    stopMedusaCounter()
    stopAutoSteal()
    disableAutoBat()
    if batDesyncTpEnabled then stopBatDesyncTp() end
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
    if _G.__YoutStopSpeedEngine then pcall(_G.__YoutStopSpeedEngine) end
end

local _youtSaveState = {lastAt = 0, queued = false, writing = false, revision = 0}
local function resolveYoutFileApi()
    local env = (getgenv and getgenv()) or _G
    local readCandidates = {readfile, syn and syn.readfile, env.readfile}
    local writeCandidates = {writefile, syn and syn.writefile, env.writefile}
    local readFn, writeFn
    for _, fn in pairs(readCandidates) do if type(fn) == "function" then readFn = fn; break end end
    for _, fn in pairs(writeCandidates) do if type(fn) == "function" then writeFn = fn; break end end
    return readFn, writeFn
end

local function youtFileExists(path)
    local readFn = resolveYoutFileApi()
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
        antiBat = antiBatEnabled, antiFling = antiFlingEnabled,
        selectedStealMode = selectedStealMode,
        autoSteal = CONFIG.AUTO_STEAL_ENABLED,
        medusaCounter = medusaCounterEnabled, batCounter = batCounterEnabled,
        unwalkEnabled = unwalkEnabled,
        laggerToggled = laggerToggled, laggerCarryToggled = laggerCarryToggled,
        carryMode = speedMode, batAimbotSpeed = BAT_AIMBOT_SPEED,
        dropMode = dropMode, stretchEnabled = stretchEnabled, stretchFOV = stretchFOV,
        uiScale = uiScaleValue, buttonStyle = floatingButtonStyle, animPack = currentAnimPack,
        espEnabled = espEnabled, espLineEnabled = espLineEnabled,
        vividGraphics = vividGraphicsEnabled, hideButtons = hideButtonsEnabled,
        antiLag = antiLagEnabled, tpBatEnabled = batDesyncTpEnabled,
        skyTheme = skyTheme, mobileButtonPositions = savedButtonPositions,
        dropBrainrotKey = {kb = KB.DropBrainrot.kb and KB.DropBrainrot.kb.Name, gp = KB.DropBrainrot.gp and KB.DropBrainrot.gp.Name},
        autoLeftKey = {kb = KB.AutoLeft.kb and KB.AutoLeft.kb.Name, gp = KB.AutoLeft.gp and KB.AutoLeft.gp.Name},
        autoRightKey = {kb = KB.AutoRight.kb and KB.AutoRight.kb.Name, gp = KB.AutoRight.gp and KB.AutoRight.gp.Name},
        autoBatKey = {kb = KB.AutoBat.kb and KB.AutoBat.kb.Name, gp = KB.AutoBat.gp and KB.AutoBat.gp.Name},
        batV2Key = {kb = KB.BatV2.kb and KB.BatV2.kb.Name, gp = KB.BatV2.gp and KB.BatV2.gp.Name},
        tpFloorKey = {kb = KB.TPFloor.kb and KB.TPFloor.kb.Name, gp = KB.TPFloor.gp and KB.TPFloor.gp.Name},
        guiHideKey = {kb = KB.GuiHide.kb and KB.GuiHide.kb.Name, gp = KB.GuiHide.gp and KB.GuiHide.gp.Name},
        carryToggleKey = {kb = KB.CarryToggle.kb and KB.CarryToggle.kb.Name, gp = KB.CarryToggle.gp and KB.CarryToggle.gp.Name},
        laggerModeKey = {kb = KB.LaggerMode.kb and KB.LaggerMode.kb.Name, gp = KB.LaggerMode.gp and KB.LaggerMode.gp.Name},
        tpBatKey = {kb = KB.TPBat.kb and KB.TPBat.kb.Name, gp = KB.TPBat.gp and KB.TPBat.gp.Name},
        instaResetKey = {kb = KB.InstaReset.kb and KB.InstaReset.kb.Name, gp = KB.InstaReset.gp and KB.InstaReset.gp.Name},
        batV2FloatingPos = batV2FloatingPos, tpBatFloatingPos = tpBatFloatingPos,
        instaResetFloatingPos = instaResetFloatingPos,
        bodyLockEnabled = bodyLockEnabled, bodyLockRange = bodyLockRange,
        progressBarPos = savedProgressBarPos, lockUI = uiLocked,
        backgroundIndex = backgroundIndex, backgroundImageTransparency = backgroundImageTransparency,
        backgroundMode = backgroundMode, floatingButtonScale = floatingButtonScale,
        outfitIndex = currentOutfitIndex,
        outfitHeadless = OUTFIT_HEADLESS,
        outfitKorblox = OUTFIT_KORBLOX,
        themeColor = currentColorTheme,
        batSkin = currentBatSkin, -- [KATANA]
    }
    if main then
        local basePos = _G.__YoutMainOriginalPos or main.Position
        config.mainPosition = {
            XScale = basePos.X.Scale, XOffset = basePos.X.Offset,
            YScale = basePos.Y.Scale, YOffset = basePos.Y.Offset,
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
    config.configVersion = 3
    config.userId = LP.UserId
    local encodedOk, json = pcall(function() return HS:JSONEncode(config) end)
    if not encodedOk then return false end
    if not force and json == _lastSavedJSON then return true end
    if _youtSaveState.writing or (not force and _tick() - _youtSaveState.lastAt < 0.25) then
        if not _youtSaveState.queued then
            _youtSaveState.queued = true
            task.delay(0.25, function()
                _youtSaveState.queued = false
                saveAllSettings(true)
            end)
        end
        return true
    end
    local readFn, writeFn = resolveYoutFileApi()
    if not readFn or not writeFn then warn("[Y-out Save] Executor file API is unavailable."); return false end
    _youtSaveState.writing = true
    _youtSaveState.revision = _youtSaveState.revision + 1
    config.revision = _youtSaveState.revision
    config.savedAt = os.time()
    json = HS:JSONEncode(config)
    local ok = pcall(function()
        if youtFileExists(CONFIG_FILE) then
            local previous = readFn(CONFIG_FILE)
            if type(previous) == "string" then writeFn(CONFIG_FILE .. ".backup", previous) end
        end
        writeFn(CONFIG_FILE, json)
        local readBack = readFn(CONFIG_FILE)
        if readBack ~= json then error("save verification failed") end
        HS:JSONDecode(readBack)
    end)
    _youtSaveState.writing = false
    _youtSaveState.lastAt = _tick()
    if ok then _lastSavedJSON = json else warn("[Y-out Save] Write or verification failed.") end
    return ok
end

do
    local readFn, writeFn = resolveYoutFileApi()
    if readFn and writeFn then
        local oldPath = "BloodHounds_" .. tostring(LP.UserId) .. ".json"
        local okOld, old = pcall(readFn, oldPath)
        local okNew, _ = pcall(readFn, CONFIG_FILE)
        if okOld and type(old) == "string" and not okNew then
            pcall(writeFn, CONFIG_FILE, old)
            warn("[Yout] Config migrada de " .. oldPath .. " a " .. CONFIG_FILE)
        end
    end
end

function loadAllSettings()
    local readFn = resolveYoutFileApi()
    if not readFn or not youtFileExists(CONFIG_FILE) then return false end
    local success, data = pcall(function() return HS:JSONDecode(readFn(CONFIG_FILE)) end)
    if not success or not data then return false end
    _isLoading = true
    NS = data.normalSpeed or NS
    CS = data.carrySpeed or CS
    LAGGER_SPEED = data.laggerSpeed1 or LAGGER_SPEED
    LAGGER_CARRY_SPEED = data.laggerSpeed2 or LAGGER_CARRY_SPEED
    CONFIG.STEAL_RANGE = data.stealRadius or CONFIG.STEAL_RANGE
    if radInput then radInput.Text = tostring(CONFIG.STEAL_RANGE) end
    if tonumber(data.configVersion) >= 2 and data.lockUI ~= nil then uiLocked = data.lockUI
    else uiLocked = false end
    mobileButtonsLocked = false
    if data.antiRagdollMode then antiRagdollMode = data.antiRagdollMode
    else antiRagdollMode = data.antiRagdoll and "v2" or "off" end
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
    unwalkEnabled = data.unwalkEnabled or data.unwalk or false
    antiLagEnabled = data.antiLag or false
    laggerToggled = data.laggerToggled or false
    speedMode = data.carryMode or false
    laggerCarryToggled = data.laggerCarryToggled or false
    floatingButtonStyle = (tonumber(data.buttonStyle) == 1) and 1 or 2
    uiScaleValue = _clamp(tonumber(data.uiScale) or 78, 50, 150)
    if mainUIScale then mainUIScale.Scale = uiScaleValue / 100 end
    if pbScale then pbScale.Scale = uiScaleValue / 100 end
    espEnabled = data.espEnabled or false
    espLineEnabled = data.espLineEnabled or false
    if espEnabled then pcall(toggleESP, true) else pcall(toggleESP, false) end
    vividGraphicsEnabled = data.vividGraphics or false
    hideButtonsEnabled = data.hideButtons or false
    currentColorTheme = COLOR_THEMES[data.themeColor] and data.themeColor or "Light Blue"
    selectedColor = COLOR_THEMES[currentColorTheme]
    task.defer(function() updateAllUIThemeColors(selectedColor) end)
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
    lk(KB.BatV2, data.batV2Key)
    lk(KB.TPFloor, data.tpFloorKey)
    lk(KB.GuiHide, data.guiHideKey)
    lk(KB.CarryToggle, data.carryToggleKey)
    lk(KB.LaggerMode, data.laggerModeKey)
    lk(KB.TPBat, data.tpBatKey)
    lk(KB.InstaReset, data.instaResetKey)
    if data.mobileButtonPositions then savedButtonPositions = data.mobileButtonPositions end
    if data.mobilePanelPos then savedMobilePanelPos = data.mobilePanelPos end
    if data.mainPosition and main then
        main.Position = UDim2.new(data.mainPosition.XScale or 0, data.mainPosition.XOffset or 20, data.mainPosition.YScale or 0, data.mainPosition.YOffset or 2)
    end
    if data.batV2FloatingPos then batV2FloatingPos = data.batV2FloatingPos end
    if data.tpBatFloatingPos then tpBatFloatingPos = data.tpBatFloatingPos end
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
    if data.backgroundMode then
        if data.backgroundMode == "None" then
            backgroundMode = "None"
        elseif data.backgroundMode == "Background 2" then
            backgroundMode = "Background 2"
            backgroundIndex = 2
        else
            backgroundMode = "Background 1"
            backgroundIndex = 1
        end
    end
    backgroundImageTransparency = data.backgroundImageTransparency or 0
    floatingButtonScale = data.floatingButtonScale or 1
    if data.outfitIndex and data.outfitIndex >= 1 and data.outfitIndex <= #OUTFITS then
        currentOutfitIndex = data.outfitIndex
        task.defer(function()
            pcall(function() applyOutfitByIndex(currentOutfitIndex) end)
            if outfitSelectorLabel then outfitSelectorLabel.Text = OUTFITS[currentOutfitIndex].label end
        end)
    end
    if data.outfitHeadless ~= nil then
        OUTFIT_HEADLESS = data.outfitHeadless == true
    end
    if data.outfitKorblox then
        local k = tostring(data.outfitKorblox)
        if k == "left" or k == "right" or k == "both" then
            OUTFIT_KORBLOX = k
        else
            OUTFIT_KORBLOX = "none"
        end
    end
    -- [KATANA] cargar bat skin persistido
    if data.batSkin then
        currentBatSkin = data.batSkin
        if batSkinSelectorLabel then batSkinSelectorLabel.Text = currentBatSkin end
        task.defer(function() pcall(setBatSkin, currentBatSkin) end)
    end
    if _G._youtStealModeSetter then
        task.defer(function() _G._youtStealModeSetter(selectedStealMode) end)
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
    safeSet(setMedusaVisual, false)
    safeSet(setUnwalkVisual, false)
    safeSet(setAntiLagVisual, false)
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
    if antiDieEnabled then AntiDieModule.stop(); antiDieEnabled = false end
    updateTpBatButtonWithAntiDie(false)
    for _, ref in ipairs(keyButtonRefs) do
        local entry = ref.entry
        local label = (entry.gp and entry.gp.Name) or (entry.kb and entry.kb.Name) or "None"
        ref.btn.Text = label
    end
    currentColorTheme = "Light Blue"
    selectedColor = COLOR_THEMES["Light Blue"]
    updateAllUIThemeColors(selectedColor)
    OUTFIT_HEADLESS = false
    OUTFIT_KORBLOX = "none"
    if setOutfitHeadlessVisual then setOutfitHeadlessVisual("Off") end
    if setOutfitKorbloxVisual then setOutfitKorbloxVisual("None") end
    -- [KATANA]
    if batSkinSelectorLabel then batSkinSelectorLabel.Text = currentBatSkin end
    if miniBtn then
        local stroke = miniBtn:FindFirstChildOfClass("UIStroke")
        if stroke then stroke.Color = Color3.fromRGB(55, 125, 175) end
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
        pbFrame.Position = UDim2.new(0.5, -172, 0.80, 0)
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
        medusaCounterEnabled = false; batCounterEnabled = false
        autoBatEnabled = false; autoLeftEnabled = false; autoRightEnabled = false
        unwalkEnabled = false; antiLagEnabled = false
        uiLocked = false; mobileButtonsLocked = false
        CONFIG.AUTO_STEAL_ENABLED = false
        selectedStealMode = "V1"
        if _G._youtStealModeSetter then pcall(_G._youtStealModeSetter, "V1") end
        BAT_AIMBOT_SPEED = 58
        dropMode = 1; stretchEnabled = false; stretchFOV = 120
        uiScaleValue = 78
        if mainUIScale then mainUIScale.Scale = 1 end
        if pbScale then pbScale.Scale = 1 end
        espEnabled = false; espLineEnabled = false; vividGraphicsEnabled = false; hideButtonsEnabled = false
        bodyLockEnabled = false; bodyLockRange = 20
        backgroundIndex = 1; backgroundImageTransparency = 0; backgroundMode = "Background 1"
        floatingButtonScale = 1
        if batDesyncTpEnabled then stopBatDesyncTp() end
        currentAnimPack = "Off"; stopAnimPack()
        currentOutfitIndex = 1
        OUTFIT_HEADLESS = false
        OUTFIT_KORBLOX = "none"
        -- [KATANA]
        currentBatSkin = "None"
        if batSkinSelectorLabel then batSkinSelectorLabel.Text = "None" end
        pcall(stopBatSkinWatcher)
        if _G.CursedBatSkins_Katana then pcall(function() _G.CursedBatSkins_Katana.Clear() end) end
        currentColorTheme = "Light Blue"; selectedColor = COLOR_THEMES["Light Blue"]
        if main then main.Position = UDim2.new(0, 20, 0, 2); _G.__YoutMainOriginalPos = main.Position end
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
    local grad = Instance.new("UIGradient", obj)
    grad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0,   Color3.fromRGB(105, 190, 245)),
        ColorSequenceKeypoint.new(0.3, Color3.fromRGB(185, 230, 255)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 235, 255)),
        ColorSequenceKeypoint.new(0.7, Color3.fromRGB(185, 230, 255)),
        ColorSequenceKeypoint.new(1,   Color3.fromRGB(105, 190, 245)),
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
    local BTN_W, BTN_H = 60, 40
    local GAP = 7
    local orderMap = { DropBR = 0, AutoLeft = 1, AutoBat = 2, AutoRight = 3, TpDown = 4, Carry = 5, Lagger1 = 6, Lagger2 = 7 }
    local order = orderMap[btnName] or 0
    local row = _floor(order / 2)
    local col = order % 2
    return col * (BTN_W + GAP), row * (BTN_H + GAP + 7)
end

do
    if not _G.InstaResetLoaded then
        _G.InstaResetLoaded = true
        local state = _G._YoutInstaResetState
        if type(state) ~= "table" then
            state = {
                busy = false, busyAt = 0, token = 0,
                cameraConn = nil, cameraHeld = false, cameraHeldAt = 0,
                speed = 1000000,
                wantAntiDie = nil, wantAntiBat = nil, wantTpBatDie = nil,
            }
            _G._YoutInstaResetState = state
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
            if not (character and hum and root and root:IsA("BasePart")) then return end
            if state.busy and (os.clock() - (state.busyAt or 0)) < 5 then return end
            state.busy = true
            state.busyAt = os.clock()
            state.token = (state.token or 0) + 1
            local myToken = state.token
            suspendGuards()
            task.spawn(function()
                holdCamera(character)
                if not flingUp(character) then hardKill(character) end
                local elapsed = 0
                while LP.Character == character and elapsed < FALLBACK do
                    elapsed = elapsed + task.wait()
                end
                if LP.Character == character then
                    local hum2 = character:FindFirstChildOfClass("Humanoid")
                    if hum2 and hum2.Health > 0 then hardKill(character) end
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
    local WHITE = Color3.fromRGB(255,255,255)
    local INP = Color3.fromRGB(65, 105, 225)
    -- Paleta del menú (sin negro). Cambia aquí los colores si quieres otro tono.
    local UIC = {
        PANEL = Color3.fromRGB(236, 242, 252),
        ROW   = Color3.fromRGB(214, 228, 248),
        INNER = Color3.fromRGB(196, 214, 242),
        BLUE  = Color3.fromRGB(65, 105, 225),
        GRAY  = Color3.fromRGB(140, 146, 158), -- color al tocar / activar un botón
        RED   = Color3.fromRGB(220, 75, 95),
        TXT   = Color3.fromRGB(35, 50, 90),
        MUTED = Color3.fromRGB(120, 135, 170),
    }
    local GUI_W, GUI_H = 348, 540
    local GUI_NAMES = {"Yout", "YoutMobilePanel", "TpBatButton", "InstaResetButton", "YoutSpeedIndicator", "YoutBootErrors"}
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
    gui.Name = "FEAR_X_BLESS"
    gui.ResetOnSpawn = false
    gui.DisplayOrder = 10
    gui.IgnoreGuiInset = true
    pcall(function() if syn and syn.protect_gui then syn.protect_gui(gui) end end)
    local guiOk = pcall(function() gui.Parent = game:GetService("CoreGui") end)
    if not guiOk then gui.Parent = LP:WaitForChild("PlayerGui") end

    main = Instance.new("Frame", gui)
    main.Size = UDim2.new(0, GUI_W, 0, GUI_H)
    main.Position = UDim2.new(0, 20, 0, 2)
    main.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    main.BackgroundTransparency = 1
    main.BorderSizePixel = 0
    main.ClipsDescendants = true
    Instance.new("UICorner", main).CornerRadius = UDim.new(0, 16)

    local fearTitle = Instance.new("TextLabel", main)
    fearTitle.Name = "FearXBlessTitle"
    fearTitle.Size = UDim2.new(1, -82, 0, 34)
    fearTitle.Position = UDim2.new(0, 14, 0, 10)
    fearTitle.BackgroundTransparency = 1
    fearTitle.Text = "FEAR"
    fearTitle.TextColor3 = Color3.fromRGB(35, 50, 90)
    fearTitle.Font = Enum.Font.GothamBold
    fearTitle.TextSize = 21
    fearTitle.TextXAlignment = Enum.TextXAlignment.Left
    fearTitle.ZIndex = 200
    fearTitle.Visible = false

    local bgImage = Instance.new("ImageLabel", main)
    bgImage.Name = "BackgroundImage"
    bgImage.Size = UDim2.new(1, 0, 1, 0)
    bgImage.Position = UDim2.new(0, 0, 0, 0)
    bgImage.BackgroundColor3 = UIC.PANEL
    bgImage.BackgroundTransparency = 0
    bgImage.ImageTransparency = 0
    -- Fit conserva la imagen completa (incluidos título, personaje y efectos).
    bgImage.ScaleType = Enum.ScaleType.Fit
    bgImage.ZIndex = 1
    setYoutAssetImage(bgImage, backgroundImages[backgroundIndex])
    bgImage.ClipsDescendants = true
    Instance.new("UICorner", bgImage).CornerRadius = UDim.new(0, 16)

    mainUIScale = Instance.new("UIScale", main)
    mainUIScale.Scale = uiScaleValue / 100

    local closeBtn = Instance.new("TextButton", main)
    closeBtn.Size = UDim2.new(0, 38, 0, 38)
    closeBtn.Position = UDim2.new(1, -50, 0, 12)
    closeBtn.BackgroundColor3 = UIC.RED
    closeBtn.BackgroundTransparency = 0
    closeBtn.BorderSizePixel = 0
    closeBtn.Text = "X"
    closeBtn.TextColor3 = WHITE
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextSize = 18
    closeBtn.AutoButtonColor = false
    closeBtn.ZIndex = 200
    Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 10)

    closeBtn.MouseEnter:Connect(function()
        TS:Create(closeBtn, TweenInfo.new(0.12), {BackgroundColor3 = Color3.fromRGB(235, 100, 118)}):Play()
    end)
    closeBtn.MouseLeave:Connect(function()
        TS:Create(closeBtn, TweenInfo.new(0.12), {BackgroundColor3 = UIC.RED}):Play()
    end)
    closeBtn.MouseButton1Down:Connect(function() closeBtn.BackgroundColor3 = UIC.GRAY end)

    do -- encabezado: avatar, nombre, @usuario e insignia
        local avatar = Instance.new("ImageLabel", main)
        avatar.Name = "HeaderAvatar"
        avatar.Size = UDim2.new(0, 50, 0, 50)
        avatar.Position = UDim2.new(0, 14, 0, 10)
        avatar.BackgroundColor3 = UIC.INNER
        avatar.BorderSizePixel = 0
        avatar.ZIndex = 200
        Instance.new("UICorner", avatar).CornerRadius = UDim.new(1, 0)
        task.spawn(function()
            local okThumb, img = pcall(function()
                return Players:GetUserThumbnailAsync(LP.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
            end)
            if okThumb and img and avatar.Parent then avatar.Image = img end
        end)

        local nameLbl = Instance.new("TextLabel", main)
        nameLbl.Name = "HeaderName"
        nameLbl.Size = UDim2.new(1, -140, 0, 22)
        nameLbl.Position = UDim2.new(0, 74, 0, 8)
        nameLbl.BackgroundTransparency = 1
        nameLbl.Text = LP.DisplayName
        nameLbl.TextColor3 = UIC.TXT
        nameLbl.Font = Enum.Font.GothamBold
        nameLbl.TextSize = 16
        nameLbl.TextXAlignment = Enum.TextXAlignment.Left
        nameLbl.TextTruncate = Enum.TextTruncate.AtEnd
        nameLbl.ZIndex = 200

        local userLbl = Instance.new("TextLabel", main)
        userLbl.Name = "HeaderUser"
        userLbl.Size = UDim2.new(1, -140, 0, 14)
        userLbl.Position = UDim2.new(0, 74, 0, 30)
        userLbl.BackgroundTransparency = 1
        userLbl.Text = "@" .. LP.Name
        userLbl.TextColor3 = UIC.MUTED
        userLbl.Font = Enum.Font.Gotham
        userLbl.TextSize = 10
        userLbl.TextXAlignment = Enum.TextXAlignment.Left
        userLbl.TextTruncate = Enum.TextTruncate.AtEnd
        userLbl.ZIndex = 200

        local badge = Instance.new("TextLabel", main)
        badge.Name = "HeaderBadge"
        badge.Size = UDim2.new(0, 104, 0, 18)
        badge.Position = UDim2.new(0, 74, 0, 46)
        badge.BackgroundColor3 = UIC.ROW
        badge.BorderSizePixel = 0
        badge.Text = "FEAR X BLESS"
        badge.TextColor3 = UIC.BLUE
        badge.Font = Enum.Font.GothamBold
        badge.TextSize = 9
        badge.ZIndex = 200
        Instance.new("UICorner", badge).CornerRadius = UDim.new(1, 0)
    end
    miniBtn = Instance.new("TextButton", gui)
    miniBtn.Name = "MinimizedFrame"
    -- Barra de acceso al menú más grande y cómoda para tocar en móvil
    miniBtn.Size = UDim2.new(0, 132, 0, 36)
    miniBtn.Position = UDim2.new(0, 18, 0, 60)
    miniBtn.BackgroundColor3 = UIC.BLUE
    miniBtn.BackgroundTransparency = 0.02
    miniBtn.BorderSizePixel = 0
    miniBtn.Text = "FEAR X BLESS"
    miniBtn.TextColor3 = WHITE
    miniBtn.Font = Enum.Font.GothamBold
    miniBtn.TextSize = 14
    miniBtn.TextXAlignment = Enum.TextXAlignment.Center
    miniBtn.AutoButtonColor = false
    miniBtn.ZIndex = 20
    miniBtn.Visible = false
    miniBtn.ClipsDescendants = true
    Instance.new("UICorner", miniBtn).CornerRadius = UDim.new(0, 9)

    -- Línea blanca que atraviesa el centro del texto y vuelve al mismo lado.
    local menuTextSweep = Instance.new("Frame")
    menuTextSweep.Name = "WhiteTextSweep"
    menuTextSweep.AnchorPoint = Vector2.new(0, 0.5)
    menuTextSweep.Position = UDim2.new(-0.38, 0, 0.5, 0)
    menuTextSweep.Size = UDim2.new(0.38, 0, 0, 2)
    menuTextSweep.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    menuTextSweep.BackgroundTransparency = 0.04
    menuTextSweep.BorderSizePixel = 0
    menuTextSweep.ZIndex = 22
    menuTextSweep.Parent = miniBtn

    task.spawn(function()
        while miniBtn and miniBtn.Parent and menuTextSweep and menuTextSweep.Parent do
            menuTextSweep.Position = UDim2.new(-0.38, 0, 0.5, 0)
            local forward = TS:Create(
                menuTextSweep,
                TweenInfo.new(1.15, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
                {Position = UDim2.new(1.02, 0, 0.5, 0)}
            )
            forward:Play()
            forward.Completed:Wait()
            if not menuTextSweep or not menuTextSweep.Parent then break end
            local backward = TS:Create(
                menuTextSweep,
                TweenInfo.new(1.15, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
                {Position = UDim2.new(-0.38, 0, 0.5, 0)}
            )
            backward:Play()
            backward.Completed:Wait()
            task.wait(0.12)
        end
    end)

    local _mainAnimating = false
    local mainOriginalPos = main.Position
    _G.__YoutMainOriginalPos = mainOriginalPos
    main:GetPropertyChangedSignal("Position"):Connect(function()
        if not _mainAnimating then
            mainOriginalPos = main.Position
            _G.__YoutMainOriginalPos = mainOriginalPos
        end
    end)

    local animScale = Instance.new("UIScale", main)
    animScale.Scale = 1
    local _openTween, _closeTween = nil, nil

    showGui = function()
        if not main then return end
        if _openTween then _openTween:Cancel() end
        if _closeTween then _closeTween:Cancel() end
        -- Cada vez que se abre el menú, restaurar el fondo FEAR X BLESS.
        backgroundMode = "Background 1"
        backgroundIndex = 1
        main.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        main.BackgroundTransparency = 1
        local fearMenuBg = main:FindFirstChild("BackgroundImage")
        if fearMenuBg then
            fearMenuBg.Visible = true
            fearMenuBg.Size = UDim2.new(1, 0, 1, 0)
            fearMenuBg.Position = UDim2.new(0, 0, 0, 0)
            fearMenuBg.ImageTransparency = YOUT_USE_BG_IMAGE and 0 or 1
            fearMenuBg.ScaleType = Enum.ScaleType.Fit
            setYoutAssetImage(fearMenuBg, FEAR_MENU_BACKGROUND_ASSET)
        end
        if backgroundSelectorLabel then
            backgroundSelectorLabel.Text = backgroundMode
        end
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

    local tabs = {"Moment", "Main", "Combat", "Visuals", "Settings", "Keybinds"}
    tabButtons = {}
    local contentPages = {}

    local bottomNav = Instance.new("ScrollingFrame", main)
    bottomNav.Name = "YoutTopTabs"
    bottomNav.AnchorPoint = Vector2.new(0, 0)
    bottomNav.Position = UDim2.new(0, 8, 0, 72)
    bottomNav.Size = UDim2.new(1, -16, 0, 40)
    bottomNav.BackgroundColor3 = Color3.fromRGB(196, 214, 242)
    bottomNav.BackgroundTransparency = 0.16
    bottomNav.BorderSizePixel = 0
    bottomNav.ScrollBarThickness = 0
    bottomNav.ScrollBarImageTransparency = 1
    bottomNav.ScrollingDirection = Enum.ScrollingDirection.X
    bottomNav.AutomaticCanvasSize = Enum.AutomaticSize.X
    bottomNav.CanvasSize = UDim2.new(0, 0, 0, 0)
    bottomNav.ElasticBehavior = Enum.ElasticBehavior.WhenScrollable
    bottomNav.ClipsDescendants = true
    bottomNav.ZIndex = 20
    Instance.new("UICorner", bottomNav).CornerRadius = UDim.new(0, 11)

    local navStroke = Instance.new("UIStroke", bottomNav)
    navStroke.Color = Color3.fromRGB(160, 188, 230)
    navStroke.Transparency = 0.52
    navStroke.Thickness = 1

    local navLayout = Instance.new("UIListLayout", bottomNav)
    navLayout.FillDirection = Enum.FillDirection.Horizontal
    navLayout.SortOrder = Enum.SortOrder.LayoutOrder
    navLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    navLayout.Padding = UDim.new(0, 6)

    local navPadding = Instance.new("UIPadding", bottomNav)
    navPadding.PaddingLeft = UDim.new(0, 7)
    navPadding.PaddingRight = UDim.new(0, 7)
    navPadding.PaddingTop = UDim.new(0, 5)
    navPadding.PaddingBottom = UDim.new(0, 5)

    local tabContent = Instance.new("Frame", main)
    tabContent.Name = "YoutTabContent"
    tabContent.Size = UDim2.new(1, -14, 1, -128)
    tabContent.Position = UDim2.new(0, 7, 0, 120)
    tabContent.BackgroundTransparency = 1
    tabContent.ClipsDescendants = true
    tabContent.ZIndex = 5

    local tabDisplayNames = {
        Moment = "Movement", Main = "Main", Combat = "Combat",
        Visuals = "Visuals", Settings = "Settings", Keybinds = "Keybinds",
    }

    local TAB_SHINE_LOOPS = setmetatable({}, { __mode = "k" })

    local function setTabShine(surface, enabled)
        if not surface then return end
        surface.ClipsDescendants = true
        local shine = surface:FindFirstChild("AnimatedWhiteShine")
        if not shine then
            shine = Instance.new("Frame", surface)
            shine.Name = "AnimatedWhiteShine"
            shine.AnchorPoint = Vector2.new(0.5, 0.5)
            shine.Size = UDim2.new(0, 18, 0.82, 0)
            shine.Position = UDim2.new(-0.10, 0, 0.5, 0)
            shine.Rotation = 20
            shine.BackgroundColor3 = Color3.fromRGB(255,255,255)
            shine.BackgroundTransparency = 0.22
            shine.BorderSizePixel = 0
            shine.ZIndex = 21
            shine.Visible = false
            Instance.new("UICorner", shine).CornerRadius = UDim.new(0, 4)
            local sg = Instance.new("UIGradient", shine)
            sg.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255,255,255)),
                ColorSequenceKeypoint.new(0.50, Color3.fromRGB(255,255,255)),
                ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255,255,255)),
            })
            sg.Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0.00, 1),
                NumberSequenceKeypoint.new(0.35, 0.92),
                NumberSequenceKeypoint.new(0.50, 0.42),
                NumberSequenceKeypoint.new(0.65, 0.92),
                NumberSequenceKeypoint.new(1.00, 1),
            })
        end
        local loop = TAB_SHINE_LOOPS[shine]
        if loop then
            loop.alive = false
            TAB_SHINE_LOOPS[shine] = nil
        end
        shine.Visible = enabled == true
        shine:SetAttribute("ShineEnabled", enabled == true)
        if enabled then
            local state = { alive = true }
            TAB_SHINE_LOOPS[shine] = state
            task.spawn(function()
                while state.alive and shine and shine.Parent and shine:GetAttribute("ShineEnabled") == true do
                    shine.Position = UDim2.new(-0.10, 0, 0.5, 0)
                    shine.BackgroundTransparency = 0.22
                    local tw = TS:Create(shine, TweenInfo.new(0.95, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {
                        Position = UDim2.new(1.10, 0, 0.5, 0)
                    })
                    tw:Play()
                    tw.Completed:Wait()
                    if not state.alive or not shine or not shine.Parent or shine:GetAttribute("ShineEnabled") ~= true then break end
                    task.wait(0.16)
                end
            end)
        end
    end

    local function styleTab(btn, active)
        local edge = btn:FindFirstChild("Underline")
        local surface = btn:FindFirstChild("TabSurface")
        local stroke = surface and surface:FindFirstChild("TabStroke")
        local grad = surface and surface:FindFirstChild("TabBgGrad")
        if edge then
            edge.Visible = active == true
            edge.BackgroundColor3 = active and Color3.fromRGB(120, 160, 240) or Color3.fromRGB(160, 188, 230)
        end
        btn.BackgroundTransparency = 1
        btn.TextColor3 = active and WHITE or UIC.TXT
        btn.TextTransparency = 0
        if surface then
            surface.BackgroundColor3 = active and Color3.fromRGB(65, 105, 225) or Color3.fromRGB(205, 220, 245)
            surface.BackgroundTransparency = active and 0.00 or 0.12
            setTabShine(surface, active)
        end
        if stroke then
            stroke.Color = active and Color3.fromRGB(110, 150, 240) or Color3.fromRGB(160, 188, 230)
            stroke.Transparency = active and 0.18 or 0.40
            stroke.Thickness = active and 1.2 or 1
        end
        if grad then
            setAnimatedActiveShine(grad, false)
            grad.Offset = Vector2.new(0,0)
            if active then
                grad.Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0.00, Color3.fromRGB(120, 160, 240)),
                    ColorSequenceKeypoint.new(0.24, Color3.fromRGB(85, 125, 230)),
                    ColorSequenceKeypoint.new(0.50, Color3.fromRGB(65, 105, 225)),
                    ColorSequenceKeypoint.new(0.76, Color3.fromRGB(85, 125, 230)),
                    ColorSequenceKeypoint.new(1.00, Color3.fromRGB(120, 160, 240)),
                })
                grad.Rotation = 90
            else
                grad.Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0.00, Color3.fromRGB(205, 220, 245)),
                    ColorSequenceKeypoint.new(1.00, Color3.fromRGB(214, 228, 248)),
                })
                grad.Rotation = 0
            end
        end
    end

    for i, name in ipairs(tabs) do
        local btn = Instance.new("TextButton", bottomNav)
        btn.Name = name .. "Tab"
        btn.Size = UDim2.new(0, 92, 1, -10)
        btn.BackgroundColor3 = Color3.fromRGB(205, 220, 245)
        btn.BackgroundTransparency = 1
        btn.BorderSizePixel = 0
        btn.Text = tabDisplayNames[name] or name
        btn.TextColor3 = UIC.TXT
        btn.TextTransparency = 0
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 11
        btn.AutoButtonColor = false
        btn.LayoutOrder = i
        btn.ZIndex = 21
        btn.ClipsDescendants = true
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)

        local surface = Instance.new("Frame", btn)
        surface.Name = "TabSurface"
        surface.Size = UDim2.new(1,0,1,0)
        surface.Position = UDim2.new(0,0,0,0)
        surface.BackgroundColor3 = Color3.fromRGB(205, 220, 245)
        surface.BackgroundTransparency = 0.12
        surface.BorderSizePixel = 0
        surface.ClipsDescendants = true
        surface.Active = false
        surface.ZIndex = 20
        Instance.new("UICorner", surface).CornerRadius = UDim.new(0, 8)

        local grad = Instance.new("UIGradient", surface)
        grad.Name = "TabBgGrad"
        grad.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0.00, Color3.fromRGB(205, 220, 245)),
            ColorSequenceKeypoint.new(1.00, Color3.fromRGB(214, 228, 248)),
        })
        grad.Rotation = 0

        local stroke = Instance.new("UIStroke", surface)
        stroke.Name = "TabStroke"
        stroke.Color = Color3.fromRGB(160, 188, 230)
        stroke.Transparency = 0.40
        stroke.Thickness = 1

        local edge = Instance.new("Frame", btn)
        edge.Name = "Underline"
        edge.AnchorPoint = Vector2.new(0.5, 1)
        edge.Size = UDim2.new(0.48, 0, 0, 2)
        edge.Position = UDim2.new(0.5, 0, 1, -3)
        edge.BackgroundColor3 = getThemeColor()
        edge.BorderSizePixel = 0
        edge.Visible = false
        edge.ZIndex = 22
        Instance.new("UICorner", edge).CornerRadius = UDim.new(1, 0)

        local page = Instance.new("ScrollingFrame", tabContent)
        page.Name = name .. "Page"
        page.Size = UDim2.new(1, 0, 1, 0)
        page.Position = UDim2.new(0, 0, 0, 0)
        page.BackgroundColor3 = Color3.fromRGB(196, 214, 242)
        page.BackgroundTransparency = 1
        page.BorderSizePixel = 0
        page.ClipsDescendants = true
        page.ScrollBarThickness = 0
        page.ScrollBarImageTransparency = 1
        page.CanvasSize = UDim2.new(0, 0, 0, 0)
        page.AutomaticCanvasSize = Enum.AutomaticSize.Y
        page.ScrollingDirection = Enum.ScrollingDirection.Y
        page.ZIndex = 6
        page.Visible = (i == 1)
        Instance.new("UICorner", page).CornerRadius = UDim.new(0, 11)

        local layout = Instance.new("UIListLayout", page)
        layout.SortOrder = Enum.SortOrder.LayoutOrder
        layout.Padding = UDim.new(0, 7)
        layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

        local padding = Instance.new("UIPadding", page)
        padding.PaddingLeft = UDim.new(0, 7)
        padding.PaddingRight = UDim.new(0, 7)
        padding.PaddingTop = UDim.new(0, 7)
        padding.PaddingBottom = UDim.new(0, 12)

        contentPages[name] = page

        btn.Activated:Connect(function()
            for _, pg in pairs(contentPages) do pg.Visible = false end
            page.Visible = true
            page.Position = UDim2.fromOffset(0, 5)
            TS:Create(page, TweenInfo.new(0.18, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Position = UDim2.fromOffset(0,0)}):Play()
            for _, b in ipairs(tabButtons) do styleTab(b, b == btn) end
        end)

        btn.MouseEnter:Connect(function()
            if edge.Visible then return end
            TS:Create(btn, TweenInfo.new(0.12), {BackgroundTransparency = 0.06, TextColor3 = Color3.fromRGB(35, 50, 90)}):Play()
        end)
        btn.MouseLeave:Connect(function()
            if edge.Visible then return end
            TS:Create(btn, TweenInfo.new(0.12), {BackgroundTransparency = 0.18, TextColor3 = Color3.fromRGB(35, 50, 90)}):Play()
        end)

        table.insert(tabButtons, btn)
    end

    for i, btn in ipairs(tabButtons) do styleTab(btn, i == 1) end

    local pageCounters = {}

    local function getNextOrder(page)
        if not pageCounters[page] then pageCounters[page] = 0 end
        pageCounters[page] = pageCounters[page] + 1
        return pageCounters[page]
    end

    local function mkSect(page, txt)
        local f = Instance.new("Frame", page)
        f.Size = UDim2.new(1, 0, 0, 27)
        f.BackgroundTransparency = 1
        f.BorderSizePixel = 0
        f.LayoutOrder = getNextOrder(page)
        f.ZIndex = 7

        local accent = Instance.new("Frame", f)
        accent.Name = "SectAccent"
        accent.Size = UDim2.new(0, 9, 0, 9)
        accent.Position = UDim2.new(0, 5, 0.5, -4)
        accent.BackgroundColor3 = UIC.BLUE
        accent.BorderSizePixel = 0
        accent.Rotation = 45
        accent.ZIndex = 8
        Instance.new("UICorner", accent).CornerRadius = UDim.new(0, 3)

        local l = Instance.new("TextLabel", f)
        l.Size = UDim2.new(1, -22, 1, 0)
        l.Position = UDim2.new(0, 19, 0, 0)
        l.BackgroundTransparency = 1
        l.Text = txt:upper()
        l.TextColor3 = UIC.BLUE
        l.Font = Enum.Font.GothamBold
        l.TextSize = 11
        l.TextXAlignment = Enum.TextXAlignment.Left
        l.TextStrokeTransparency = 1
        l.ZIndex = 8


        local line = Instance.new("Frame", f)
        line.Size = UDim2.new(0.35, 0, 0, 1)
        line.AnchorPoint = Vector2.new(1, 0.5)
        line.Position = UDim2.new(1, -4, 0.5, 0)
        line.BackgroundColor3 = Color3.fromRGB(160, 188, 230)
        line.BorderSizePixel = 0
        line.ZIndex = 8
        Instance.new("UICorner", line).CornerRadius = UDim.new(1, 0)
        return f
    end

    local function mkRow(page, h)
        h = math.max(tonumber(h) or 34, 32)
        local f = Instance.new("Frame", page)
        f.Size = UDim2.new(1, -4, 0, h)
        f.BackgroundColor3 = UIC.ROW
        f.BackgroundTransparency = 0
        f.BorderSizePixel = 0
        f.LayoutOrder = getNextOrder(page)
        f.ZIndex = 7
        Instance.new("UICorner", f).CornerRadius = UDim.new(0, 12)
        return f
    end

    local function mkLabel(row, txt)
        local l = Instance.new("TextLabel", row)
        l.Size = UDim2.new(1, -92, 1, 0)
        l.Position = UDim2.new(0, 14, 0, 0)
        l.BackgroundTransparency = 1
        l.Text = txt
        l.TextColor3 = UIC.TXT
        l.Font = Enum.Font.GothamBold
        l.TextSize = 13
        l.TextXAlignment = Enum.TextXAlignment.Left
        l.TextTruncate = Enum.TextTruncate.AtEnd
        l.TextStrokeTransparency = 1
        l.ZIndex = 8
        return l
    end

    -- Botón ancho azul (como en la foto). Al tocarlo / activarlo se pone gris.
    local function mkToggle(page, txt, cb)
        local btn = Instance.new("TextButton", page)
        btn.Name = "ToggleButton"
        btn.Size = UDim2.new(1, -4, 0, 42)
        btn.BackgroundColor3 = UIC.BLUE
        btn.BorderSizePixel = 0
        btn.Text = txt
        btn.TextColor3 = WHITE
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 14
        btn.AutoButtonColor = false
        btn.LayoutOrder = getNextOrder(page)
        btn.ZIndex = 7
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 12)

        local on = false
        local pressed = false
        local function paint()
            TS:Create(btn, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                BackgroundColor3 = (on or pressed) and UIC.GRAY or UIC.BLUE,
            }):Play()
        end
        local function sv(s)
            on = s == true
            paint()
        end
        btn.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                pressed = true
                paint()
            end
        end)
        btn.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                pressed = false
                paint()
            end
        end)
        btn.Activated:Connect(function()
            on = not on
            paint()
            pcall(cb, on)
            task.defer(function() pcall(saveAllSettings) end)
        end)
        return sv
    end

    local function mkPill(row, offset)
        local pill = Instance.new("Frame", row)
        pill.Name = "Track"
        pill.Size = UDim2.new(0, 28, 0, 28)
        pill.AnchorPoint = Vector2.new(0.5, 0.5)
        pill.Position = UDim2.new(1, -(offset or 44), 0.5, 0)
        pill.BackgroundColor3 = Color3.fromRGB(196, 214, 242)
        pill.BorderSizePixel = 0
        pill.ZIndex = 8
        Instance.new("UICorner", pill).CornerRadius = UDim.new(0, 8)
        local stroke = Instance.new("UIStroke", pill)
        stroke.Name = "PillStroke"
        stroke.Color = Color3.fromRGB(160, 188, 230)
        stroke.Thickness = 1
        stroke.Transparency = 0.4
        local dot = Instance.new("Frame", pill)
        dot.Name = "Knob"
        dot.Size = UDim2.new(1, 0, 1, 0)
        dot.Position = UDim2.new(0, 0, 0, 0)
        dot.BackgroundColor3 = Color3.fromRGB(65, 105, 225)
        dot.BorderSizePixel = 0
        dot.BackgroundTransparency = 1
        dot.ZIndex = 9
        Instance.new("UICorner", dot).CornerRadius = UDim.new(0, 8)
        return pill, dot
    end

    local function animPill(pill, dot, on)
        local info = TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        TS:Create(dot, info, {BackgroundTransparency = on and 0 or 1}):Play()
        local stroke = pill:FindFirstChild("PillStroke")
        if stroke then
            TS:Create(stroke, info, {Color = on and Color3.fromRGB(110, 150, 240) or Color3.fromRGB(160, 188, 230), Transparency = on and 0 or 0.4}):Play()
        end
    end

    local function mkSelector(parent, default, options, cb)
        local segW = 56
        local totalW = #options * segW
        local container = Instance.new("Frame", parent)
        container.Name = "SegmentedControl"
        container.Size = UDim2.new(0, totalW, 0, 28)
        container.Position = UDim2.new(1, -(totalW + 8), 0.5, -14)
        container.BackgroundColor3 = Color3.fromRGB(196, 214, 242)
        container.BorderSizePixel = 0
        container.ZIndex = 8
        container.ClipsDescendants = true
        Instance.new("UICorner", container).CornerRadius = UDim.new(0, 9)

        local outerStroke = Instance.new("UIStroke", container)
        outerStroke.Color = Color3.fromRGB(160, 188, 230)
        outerStroke.Thickness = 1
        outerStroke.Transparency = 0.4

        local layout = Instance.new("UIListLayout", container)
        layout.FillDirection = Enum.FillDirection.Horizontal
        layout.SortOrder = Enum.SortOrder.LayoutOrder
        layout.Padding = UDim.new(0, 0)

        local segments = {}
        local currentIndex = 1
        for i, opt in ipairs(options) do
            if opt == default then currentIndex = i end
        end

        local function updateVisuals()
            for i, seg in ipairs(segments) do
                local isActive = (i == currentIndex)
                TS:Create(seg.bg, TweenInfo.new(0.18, Enum.EasingStyle.Quint), {
                    BackgroundColor3 = isActive and Color3.fromRGB(65, 105, 225) or Color3.fromRGB(214, 228, 248)
                }):Play()
                TS:Create(seg.label, TweenInfo.new(0.15), {
                    TextColor3 = isActive and Color3.fromRGB(255, 245, 255) or Color3.fromRGB(95, 115, 165)
                }):Play()
                if seg.fillGrad then
                    setAnimatedActiveShine(seg.fillGrad, isActive, 45)
                end
            end
        end

        for i, opt in ipairs(options) do
            local seg = Instance.new("TextButton", container)
            seg.Name = "Seg" .. i
            seg.Size = UDim2.new(0, segW, 1, 0)
            seg.BackgroundColor3 = Color3.fromRGB(214, 228, 248)
            seg.BorderSizePixel = 0
            seg.Text = ""
            seg.AutoButtonColor = false
            seg.LayoutOrder = i
            seg.ZIndex = 9
            seg.ClipsDescendants = true
            Instance.new("UICorner", seg).CornerRadius = UDim.new(0, 8)

            local segGrad = Instance.new("UIGradient", seg)
            segGrad.Color = ColorSequence.new(Color3.fromRGB(214, 228, 248))
            segGrad.Rotation = 45

            local lbl = Instance.new("TextLabel", seg)
            lbl.Size = UDim2.new(1, 0, 1, 0)
            lbl.BackgroundTransparency = 1
            lbl.Text = opt
            lbl.TextColor3 = Color3.fromRGB(95, 115, 165)
            lbl.Font = Enum.Font.GothamBold
            lbl.TextSize = 10
            lbl.TextXAlignment = Enum.TextXAlignment.Center
            lbl.TextYAlignment = Enum.TextYAlignment.Center
            lbl.ZIndex = 10

            if i < #options then
                local divider = Instance.new("Frame", seg)
                divider.Size = UDim2.new(0, 1, 0.5, 0)
                divider.Position = UDim2.new(1, -1, 0.5, 0)
                divider.AnchorPoint = Vector2.new(0, 0.5)
                divider.BackgroundColor3 = Color3.fromRGB(160, 188, 230)
                divider.BorderSizePixel = 0
                divider.ZIndex = 10
                Instance.new("UICorner", divider).CornerRadius = UDim.new(1, 0)
            end

            table.insert(segments, {bg = seg, label = lbl, btn = seg, fillGrad = segGrad})

            seg.MouseButton1Click:Connect(function()
                if i == currentIndex then return end
                local oldIdx = currentIndex
                currentIndex = i
                updateVisuals()
                if cb then
                    local delta = i - oldIdx
                    cb(delta, function() end)
                end
                task.defer(function() pcall(saveAllSettings) end)
            end)
            seg.MouseEnter:Connect(function()
                if i == currentIndex then return end
                TS:Create(seg, TweenInfo.new(0.12), {BackgroundColor3 = Color3.fromRGB(198, 216, 244)}):Play()
            end)
            seg.MouseLeave:Connect(function()
                if i == currentIndex then return end
                TS:Create(seg, TweenInfo.new(0.12), {BackgroundColor3 = Color3.fromRGB(214, 228, 248)}):Play()
            end)
        end

        updateVisuals()

        local proxyLabel = Instance.new("TextLabel", container)
        proxyLabel.Size = UDim2.new(0, 0, 0, 0)
        proxyLabel.Visible = false
        proxyLabel.Text = default
        proxyLabel.ZIndex = 1
        proxyLabel:GetPropertyChangedSignal("Text"):Connect(function()
            for i, opt in ipairs(options) do
                if opt == proxyLabel.Text then
                    currentIndex = i
                    updateVisuals()
                    break
                end
            end
        end)
        return proxyLabel
    end

    local function mkBox(parent, default, w, xOff, cb)
        local tb = Instance.new("TextBox", parent)
        local bw = w or 50
        local xo = math.max(xOff or 56, bw + 12)
        tb.Size = UDim2.new(0, bw, 0, 22)
        tb.Position = UDim2.new(1, -xo, 0.5, -11)
        tb.BackgroundColor3 = Color3.fromRGB(196, 214, 242)
        tb.BackgroundTransparency = 0.30
        tb.BorderSizePixel = 0
        tb.Text = tostring(default)
        tb.TextColor3 = UIC.TXT
        tb.Font = Enum.Font.GothamBold
        tb.TextSize = 11
        tb.ClearTextOnFocus = false
        tb.ZIndex = 8
        Instance.new("UICorner", tb).CornerRadius = UDim.new(0, 7)
        local bs = Instance.new("UIStroke", tb)
        bs.Color = Color3.fromRGB(160, 188, 230)
        bs.Thickness = 1
        bs.Transparency = 0.35
        tb.Focused:Connect(function() TS:Create(bs, TweenInfo.new(0.12), {Color = getThemeColor(), Transparency = 0.05}):Play() end)
        tb.FocusLost:Connect(function()
            TS:Create(bs, TweenInfo.new(0.12), {Color = Color3.fromRGB(160, 188, 230), Transparency = 0.35}):Play()
            if cb then
                local n = tonumber(tb.Text)
                if n then cb(n) else tb.Text = tostring(default) end
                task.defer(function() pcall(saveAllSettings) end)
            end
        end)
        return tb
    end

    local function mkKeyButton(parent, kbEntry)
        local btn = Instance.new("TextButton", parent)
        btn.Size = UDim2.new(0, 54, 0, 28)
        btn.Position = UDim2.new(0, 8, 0.5, -14)
        btn.BackgroundColor3 = UIC.BLUE
        btn.BackgroundTransparency = 0
        btn.BorderSizePixel = 0
        local function getLabel() return (kbEntry.gp and kbEntry.gp.Name) or (kbEntry.kb and kbEntry.kb.Name) or "None" end
        btn.Text = getLabel()
        btn.TextColor3 = WHITE
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 10
        btn.ZIndex = 8
        btn.AutoButtonColor = false
        btn.TextTruncate = Enum.TextTruncate.AtEnd
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 9)
        btn.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                btn.BackgroundColor3 = UIC.GRAY
            end
        end)
        btn.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                btn.BackgroundColor3 = UIC.BLUE
            end
        end)
        local bs = Instance.new("UIStroke", btn)
        bs.Color = Color3.fromRGB(160, 188, 230)
        bs.Transparency = 1
        bs.Thickness = 1
        local li = false; local lc; local lc2; local pv = btn.Text; local listenStart = 0
        btn.Activated:Connect(function()
            if li then li = false; _anyKeyListening = false; if lc then lc:Disconnect(); lc = nil end; if lc2 then lc2:Disconnect(); lc2 = nil end; btn.Text = pv; btn.TextColor3 = WHITE; return end
            pv = btn.Text; li = true; _anyKeyListening = true; listenStart = _tick(); btn.Text = "..."; btn.TextColor3 = getThemeColor()
            lc = UIS.InputBegan:Connect(function(inp)
                if not li then return end
                if inp.KeyCode == Enum.KeyCode.Escape then li = false; _anyKeyListening = false; if lc then lc:Disconnect(); lc = nil end; if lc2 then lc2:Disconnect(); lc2 = nil end; btn.Text = pv; btn.TextColor3 = WHITE; return end
                local isGp = isGamepadInput(inp)
                if isGp and _tick()-listenStart < 0.15 then return end
                if not isBindableInput(inp) then return end
                btn.Text = inp.KeyCode.Name; pv = inp.KeyCode.Name; btn.TextColor3 = WHITE
                li = false; _anyKeyListening = false; if lc then lc:Disconnect(); lc = nil end; if lc2 then lc2:Disconnect(); lc2 = nil end
                if isGp then kbEntry.gp = inp.KeyCode; kbEntry.kb = nil else kbEntry.kb = inp.KeyCode; kbEntry.gp = nil end
                task.defer(function() pcall(saveAllSettings) end)
            end)
            lc2 = UIS.InputChanged:Connect(function(inp)
                if not li or not isGamepadInput(inp) then return end
                if inp.KeyCode ~= Enum.KeyCode.ButtonL2 and inp.KeyCode ~= Enum.KeyCode.ButtonR2 then return end
                if inp.Position.Z < 0.45 then return end
                btn.Text = inp.KeyCode.Name; pv = inp.KeyCode.Name; btn.TextColor3 = WHITE
                li = false; _anyKeyListening = false; if lc then lc:Disconnect(); lc = nil end; if lc2 then lc2:Disconnect(); lc2 = nil end
                kbEntry.gp = inp.KeyCode; kbEntry.kb = nil
                task.defer(function() pcall(saveAllSettings) end)
            end)
        end)
        table.insert(keyButtonRefs, {btn = btn, entry = kbEntry})
        return btn
    end

    local function addKeybindRow(page, labelText, kbEntry)
        local row = mkRow(page, 40)
        local keyLbl = mkLabel(row, labelText)
        keyLbl.Position = UDim2.new(0, 72, 0, 0)
        keyLbl.Size = UDim2.new(1, -80, 1, 0)
        mkKeyButton(row, kbEntry)
    end

    local speedPage = contentPages["Moment"]

    mkSect(speedPage, "Speed Profile  ·  Normal / Carry")
    do local row = mkRow(speedPage, 42); mkLabel(row, "Normal Speed"); normalBox = mkBox(row, NS, 50, 56, function(v) if v > 0 and v <= 500 then NS = v; if _G.__YoutApplySpeedNow then pcall(_G.__YoutApplySpeedNow) end end end) end
    do local row = mkRow(speedPage, 42); mkLabel(row, "Carry Speed"); carryBox = mkBox(row, CS, 50, 56, function(v) if v > 0 and v <= 500 then CS = v; if _G.__YoutApplySpeedNow then pcall(_G.__YoutApplySpeedNow) end end end) end
    do local row = mkRow(speedPage, 42); mkLabel(row, "Lagger Normal"); laggerBox = mkBox(row, LAGGER_SPEED, 50, 56, function(v) if v > 0 and v <= 500 then LAGGER_SPEED = v; if _G.__YoutApplySpeedNow then pcall(_G.__YoutApplySpeedNow) end end end) end
    do local row = mkRow(speedPage, 42); mkLabel(row, "Lagger Carry"); lagger2Box = mkBox(row, LAGGER_CARRY_SPEED, 50, 56, function(v) if v > 0 and v <= 500 then LAGGER_CARRY_SPEED = v; if _G.__YoutApplySpeedNow then pcall(_G.__YoutApplySpeedNow) end end end) end

    mkSect(speedPage, "Movement Mode")
    do
        local row = mkRow(speedPage, 42)
        mkLabel(row, "Current Mode")
        modeValLbl = Instance.new("TextLabel", row)
        modeValLbl.Size = UDim2.new(0, 110, 1, 0)
        modeValLbl.Position = UDim2.new(1, -118, 0, 0)
        modeValLbl.BackgroundTransparency = 1
        modeValLbl.Text = "Normal"
        modeValLbl.TextColor3 = UIC.TXT
        modeValLbl.Font = Enum.Font.GothamBold
        modeValLbl.TextSize = 13
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
    do local row = mkRow(combatPage, 42); mkLabel(row, "Bat Aimbot SP"); batSpeedBox = mkBox(row, BAT_AIMBOT_SPEED, 50, 56, function(v) if v > 0 and v <= 200 then BAT_AIMBOT_SPEED = v end end) end
    batDesyncTpSetVisual = mkToggle(combatPage, "TP BAT", function(on)
        if on then if not batDesyncTpEnabled then toggleBatDesyncTp() end else if batDesyncTpEnabled then toggleBatDesyncTp() end end
    end)
    if batDesyncTpSetVisual then batDesyncTpSetVisual(batDesyncTpEnabled) end

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

    local visualPage = contentPages["Visuals"]
    mkSect(visualPage, "Interface")
    do
        local row = mkRow(visualPage, 42)
        mkLabel(row, "Background")
        local options = {"Background 1"}
        backgroundSelectorLabel = mkSelector(row, backgroundMode, options, function(direction, updateLabel)
            local current = 1
            for i, opt in ipairs(options) do
                if opt == backgroundMode then current = i; break end
            end
            local nextIndex = current + direction
            if nextIndex < 1 then nextIndex = #options end
            if nextIndex > #options then nextIndex = 1 end
            applyBackgroundMode(options[nextIndex])
            updateLabel(backgroundMode)
        end)
        applyBackgroundMode(backgroundMode)
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
        Instance.new("UICorner", leftBtn).CornerRadius = UDim.new(0, 7)
        animSelectorLabel = Instance.new("TextLabel", container)
        animSelectorLabel.Size = UDim2.new(0, 80, 0, 26)
        animSelectorLabel.Position = UDim2.new(0.5, -40, 0.5, -13)
        animSelectorLabel.BackgroundTransparency = 1
        animSelectorLabel.Text = ANIM_PACK_ORDER[currentIndex][2]
        animSelectorLabel.TextColor3 = UIC.TXT
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
        Instance.new("UICorner", rightBtn).CornerRadius = UDim.new(0, 7)
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
        Instance.new("UICorner", leftBtn).CornerRadius = UDim.new(0, 7)
        outfitSelectorLabel = Instance.new("TextLabel", container)
        outfitSelectorLabel.Size = UDim2.new(0, 80, 0, 26)
        outfitSelectorLabel.Position = UDim2.new(0.5, -40, 0.5, -13)
        outfitSelectorLabel.BackgroundTransparency = 1
        outfitSelectorLabel.Text = OUTFITS[currentOutfitIndex].label
        outfitSelectorLabel.TextColor3 = UIC.TXT
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
        Instance.new("UICorner", rightBtn).CornerRadius = UDim.new(0, 7)
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

    -- ===== [KATANA] Bat Skin selector =====
    do
        local row = mkRow(visualPage, 42)
        mkLabel(row, "Bat Skin")
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
        Instance.new("UICorner", leftBtn).CornerRadius = UDim.new(0, 7)
        batSkinSelectorLabel = Instance.new("TextLabel", container)
        batSkinSelectorLabel.Size = UDim2.new(0, 96, 0, 26)
        batSkinSelectorLabel.Position = UDim2.new(0.5, -48, 0.5, -13)
        batSkinSelectorLabel.BackgroundTransparency = 1
        batSkinSelectorLabel.Text = currentBatSkin
        batSkinSelectorLabel.TextColor3 = UIC.TXT
        batSkinSelectorLabel.Font = Enum.Font.GothamBold
        batSkinSelectorLabel.TextSize = 12
        batSkinSelectorLabel.TextXAlignment = Enum.TextXAlignment.Center
        batSkinSelectorLabel.ZIndex = 9
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
        Instance.new("UICorner", rightBtn).CornerRadius = UDim.new(0, 7)
        local function updateBatSkinSelector(direction)
            local idx = 1
            for i, name in ipairs(BAT_SKIN_LIST) do
                if name == currentBatSkin then idx = i break end
            end
            local newIdx = idx + direction
            if newIdx < 1 then newIdx = #BAT_SKIN_LIST end
            if newIdx > #BAT_SKIN_LIST then newIdx = 1 end
            setBatSkin(BAT_SKIN_LIST[newIdx])
        end
        leftBtn.MouseButton1Click:Connect(function() updateBatSkinSelector(-1) end)
        rightBtn.MouseButton1Click:Connect(function() updateBatSkinSelector(1) end)
    end
    -- ===== [/KATANA] =====

    do
        local row = mkRow(visualPage, 42)
        mkLabel(row, "Headless")
        local options = {"Off", "On"}
        setOutfitHeadlessVisual = mkSelector(row, OUTFIT_HEADLESS and "On" or "Off", options, function(direction, updateLabel)
            local current = OUTFIT_HEADLESS and 2 or 1
            local nextIndex = current + direction
            if nextIndex < 1 then nextIndex = #options end
            if nextIndex > #options then nextIndex = 1 end
            OUTFIT_HEADLESS = (options[nextIndex] == "On")
            updateLabel(options[nextIndex])
            pcall(function() applyOutfitByIndex(currentOutfitIndex) end)
            pcall(saveAllSettings)
        end)
    end

    do
        local row = mkRow(visualPage, 42)
        mkLabel(row, "Korblox")
        local options = {"None", "Left", "Right", "Both"}
        local defaultLabel = "None"
        if OUTFIT_KORBLOX == "left" then defaultLabel = "Left"
        elseif OUTFIT_KORBLOX == "right" then defaultLabel = "Right"
        elseif OUTFIT_KORBLOX == "both" then defaultLabel = "Both" end
        setOutfitKorbloxVisual = mkSelector(row, defaultLabel, options, function(direction, updateLabel)
            local current = 1
            for i, opt in ipairs(options) do
                local cur = "None"
                if OUTFIT_KORBLOX == "left" then cur = "Left"
                elseif OUTFIT_KORBLOX == "right" then cur = "Right"
                elseif OUTFIT_KORBLOX == "both" then cur = "Both" end
                if opt == cur then current = i; break end
            end
            local nextIndex = current + direction
            if nextIndex < 1 then nextIndex = #options end
            if nextIndex > #options then nextIndex = 1 end
            local chosen = options[nextIndex]
            if chosen == "None" then OUTFIT_KORBLOX = "none"
            elseif chosen == "Left" then OUTFIT_KORBLOX = "left"
            elseif chosen == "Right" then OUTFIT_KORBLOX = "right"
            elseif chosen == "Both" then OUTFIT_KORBLOX = "both" end
            updateLabel(chosen)
            pcall(function() applyOutfitByIndex(currentOutfitIndex) end)
            pcall(saveAllSettings)
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
        Instance.new("UICorner", leftBtn).CornerRadius = UDim.new(0, 7)
        skySelectorLabel = Instance.new("TextLabel", container)
        skySelectorLabel.Size = UDim2.new(0, 96, 0, 26)
        skySelectorLabel.Position = UDim2.new(0.5, -48, 0.5, -13)
        skySelectorLabel.BackgroundTransparency = 1
        skySelectorLabel.Text = skyTheme
        skySelectorLabel.TextColor3 = UIC.TXT
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
        Instance.new("UICorner", rightBtn).CornerRadius = UDim.new(0, 7)
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

    mkSect(visualPage, "Overlays")
    setESPVIsual = mkToggle(visualPage, "Player ESP", function(on) toggleESP(on) end)
    setESPLineVisual = mkToggle(visualPage, "ESP Line", function(on)
        if on then startESPLine() else stopESPLine() end
    end)

    mkSect(visualPage, "Botones")
    do
        local row = mkRow(visualPage, 42)
        mkLabel(row, "Forma de botones")
        local options = {"Botones 1", "Botones 2"}
        mkSelector(row, floatingButtonStyle == 2 and "Botones 2" or "Botones 1", options, function(direction, updateLabel)
            floatingButtonStyle = floatingButtonStyle == 1 and 2 or 1
            local square = floatingButtonStyle == 2
            local function applyCorner(frame, activeAttr)
                if not frame or not frame.Parent then return end
                local corner = frame:FindFirstChildOfClass("UICorner")
                if corner then corner.CornerRadius = UDim.new(0, square and 0 or 9) end
                frame:SetAttribute("YoutButtonStyle", floatingButtonStyle)
                if square and not frame:GetAttribute(activeAttr or "MobActive") then
                    frame.BackgroundColor3 = Color3.fromRGB(65, 105, 225)
                    local stroke = frame:FindFirstChildOfClass("UIStroke")
                    if stroke then stroke.Color = Color3.fromRGB(120, 160, 240); stroke.Transparency = 0.12 end
                    local grad = frame:FindFirstChild("BtnGrad")
                    if grad then grad.Color = ColorSequence.new(Color3.fromRGB(85, 125, 230), Color3.fromRGB(65, 105, 225)) end
                else
                    local isActive = frame:GetAttribute(activeAttr or "MobActive") == true
                    if activeAttr == nil then
                        isActive = frame:GetAttribute("MobActive") == true
                    end
                    paintFloatingBtn(frame, isActive)
                end
            end
            for _, info in pairs(_G.__YoutFloatingButtons or {}) do
                local btn = info and info.btn
                if btn then applyCorner(btn, "MobActive") end
            end
            -- Bat V2 / TP Bat / Insta Reset
            local extraFrames = {}
            if batV2FloatingButton then table.insert(extraFrames, batV2FloatingButton:FindFirstChild("Frame")) end
            if tpBatFloatingButton then table.insert(extraFrames, tpBatFloatingButton:FindFirstChild("Frame")) end
            if instaResetFloatingButton then table.insert(extraFrames, instaResetFloatingButton:FindFirstChild("Frame")) end
            for _, frame in ipairs(extraFrames) do
                if frame then
                    local corner = frame:FindFirstChildOfClass("UICorner")
                    if corner then corner.CornerRadius = UDim.new(0, square and 0 or 9) end
                    -- repaint keeping current active state if known
                    local active = false
                    if frame.Parent and frame.Parent.Name == "YoutBatV2Button" and _YOUT_BATV2_STATE then
                        active = _YOUT_BATV2_STATE.enabled and true or false
                    elseif frame.Parent and frame.Parent.Name == "TpBatButton" then
                        active = batDesyncTpEnabled and true or false
                    end
                    paintFloatingBtn(frame, active)
                end
            end
            updateLabel(square and "Botones 2" or "Botones 1")
            pcall(saveAllSettings)
        end)
    end

    local configPage = contentPages["Main"]
    mkSect(configPage, "Main Actions")

    do
        local row = mkRow(configPage, 42)
        mkLabel(row, "Auto Steal Mode")
        local holder = Instance.new("Frame", row)
        holder.Name = "StealModeSelector"
        holder.BackgroundColor3 = Color3.fromRGB(196, 214, 242)
        holder.BackgroundTransparency = 0.15
        holder.Size = UDim2.new(0, 120, 0, 30)
        holder.Position = UDim2.new(1, -130, 0.5, -15)
        holder.BorderSizePixel = 0
        holder.ClipsDescendants = true
        holder.ZIndex = 8
        Instance.new("UICorner", holder).CornerRadius = UDim.new(0, 9)

        local holderStroke = Instance.new("UIStroke", holder)
        holderStroke.Color = Color3.fromRGB(160, 188, 230)
        holderStroke.Thickness = 1
        holderStroke.Transparency = 0.35

        local slide = Instance.new("Frame", holder)
        slide.Name = "SelectedSlide"
        slide.BackgroundColor3 = Color3.fromRGB(65, 105, 225)
        slide.BackgroundTransparency = 0.15
        slide.Size = UDim2.new(0.5, -3, 1, -4)
        slide.Position = UDim2.new(0, 2, 0, 2)
        slide.BorderSizePixel = 0
        slide.ZIndex = 9
        Instance.new("UICorner", slide).CornerRadius = UDim.new(0, 8)

        local slideGrad = Instance.new("UIGradient", slide)
        slideGrad.Color = youtGradient(Color3.fromRGB(65, 105, 225))
        slideGrad.Rotation = 0

        local slideStroke = Instance.new("UIStroke", slide)
        slideStroke.Color = Color3.fromRGB(110, 150, 240)
        slideStroke.Thickness = 1.2
        slideStroke.Transparency = 0.1

        local v1Text = Instance.new("TextLabel", holder)
        v1Text.BackgroundTransparency = 1
        v1Text.Text = "V1"
        v1Text.TextColor3 = Color3.fromRGB(35, 50, 90)
        v1Text.Font = Enum.Font.GothamBold
        v1Text.TextSize = 13
        v1Text.Size = UDim2.new(0.5, 0, 1, 0)
        v1Text.Position = UDim2.new(0, 0, 0, 0)
        v1Text.ZIndex = 10

        local v2Text = Instance.new("TextLabel", holder)
        v2Text.BackgroundTransparency = 1
        v2Text.Text = "V2"
        v2Text.TextColor3 = Color3.fromRGB(95, 115, 165)
        v2Text.Font = Enum.Font.GothamBold
        v2Text.TextSize = 13
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
                TextColor3 = onV2 and Color3.fromRGB(95, 115, 165) or Color3.fromRGB(35, 50, 90)
            }):Play()
            TS:Create(v2Text, TweenInfo.new(0.18), {
                TextColor3 = onV2 and Color3.fromRGB(35, 50, 90) or Color3.fromRGB(95, 115, 165)
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
            if CONFIG.AUTO_STEAL_ENABLED then pcall(startAutoSteal) end
            saveAllSettings()
        end

        v1Click.MouseButton1Click:Connect(function() changeMode("V1") end)
        v2Click.MouseButton1Click:Connect(function() changeMode("V2") end)

        _G._youtStealSlide = slide
        _G._youtStealModeSetter = setStealModeVisual
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

    configPage = contentPages["Settings"]
    mkSect(configPage, "Management")
    do
        local row = mkRow(configPage, 44)
        row.Size = UDim2.new(1, 0, 0, 44)
        local saveBtn = Instance.new("TextButton", row)
        saveBtn.Size = UDim2.new(1, -12, 0.8, 0)
        saveBtn.Position = UDim2.new(0, 6, 0.1, 0)
        saveBtn.BackgroundColor3 = Color3.fromRGB(205, 220, 245)
        saveBtn.BorderSizePixel = 0
        saveBtn.Text = "SAVE CONFIG"
        saveBtn.TextColor3 = Color3.fromRGB(35, 50, 90)
        saveBtn.Font = Enum.Font.GothamBold
        saveBtn.TextSize = 14
        saveBtn.AutoButtonColor = false
        saveBtn.ZIndex = 8
        Instance.new("UICorner", saveBtn).CornerRadius = UDim.new(0, 8)
        local saveStroke = Instance.new("UIStroke", saveBtn)
        saveStroke.Color = getThemeColor()
        saveStroke.Thickness = 1.5
        saveStroke.Transparency = 0.4
        saveBtn.MouseEnter:Connect(function()
            TS:Create(saveBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(65, 105, 225)}):Play()
            TS:Create(saveBtn, TweenInfo.new(0.15), {TextColor3 = Color3.fromRGB(255,255,255)}):Play()
        end)
        saveBtn.MouseLeave:Connect(function()
            TS:Create(saveBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(205, 220, 245)}):Play()
            TS:Create(saveBtn, TweenInfo.new(0.15), {TextColor3 = Color3.fromRGB(35, 50, 90)}):Play()
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
        resetPosBtn.BackgroundColor3 = Color3.fromRGB(205, 220, 245)
        resetPosBtn.BorderSizePixel = 0
        resetPosBtn.Text = "RESET POSITIONS"
        resetPosBtn.TextColor3 = Color3.fromRGB(35, 50, 90)
        resetPosBtn.Font = Enum.Font.GothamBold
        resetPosBtn.TextSize = 14
        resetPosBtn.AutoButtonColor = false
        resetPosBtn.ZIndex = 8
        Instance.new("UICorner", resetPosBtn).CornerRadius = UDim.new(0, 8)
        local resetStroke = Instance.new("UIStroke", resetPosBtn)
        resetStroke.Color = getThemeColor()
        resetStroke.Thickness = 1.5
        resetStroke.Transparency = 0.4
        resetPosBtn.MouseEnter:Connect(function()
            TS:Create(resetPosBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(65, 105, 225)}):Play()
            TS:Create(resetPosBtn, TweenInfo.new(0.15), {TextColor3 = Color3.fromRGB(255,255,255)}):Play()
        end)
        resetPosBtn.MouseLeave:Connect(function()
            TS:Create(resetPosBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(205, 220, 245)}):Play()
            TS:Create(resetPosBtn, TweenInfo.new(0.15), {TextColor3 = Color3.fromRGB(35, 50, 90)}):Play()
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
        delBtn.BackgroundColor3 = Color3.fromRGB(205, 220, 245)
        delBtn.BorderSizePixel = 0
        delBtn.Text = "RESET ALL SETTINGS"
        delBtn.TextColor3 = Color3.fromRGB(35, 50, 90)
        delBtn.Font = Enum.Font.GothamBold
        delBtn.TextSize = 14
        delBtn.AutoButtonColor = false
        delBtn.ZIndex = 8
        Instance.new("UICorner", delBtn).CornerRadius = UDim.new(0, 8)
        local delStroke = Instance.new("UIStroke", delBtn)
        delStroke.Color = Color3.fromRGB(65, 105, 225)
        delStroke.Thickness = 1.5
        delStroke.Transparency = 0.4
        delBtn.MouseEnter:Connect(function()
            TS:Create(delBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(140, 146, 158)}):Play()
            TS:Create(delBtn, TweenInfo.new(0.15), {TextColor3 = Color3.fromRGB(255,255,255)}):Play()
        end)
        delBtn.MouseLeave:Connect(function()
            TS:Create(delBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(205, 220, 245)}):Play()
            TS:Create(delBtn, TweenInfo.new(0.15), {TextColor3 = Color3.fromRGB(35, 50, 90)}):Play()
        end)
        local deleteState = 0
        local originalDeleteText = "RESET ALL SETTINGS"
        local delDebounce = false
        delBtn.MouseButton1Click:Connect(function()
            if delDebounce then return end
            if deleteState == 0 then
                deleteState = 1
                delBtn.Text = "CONFIRM?"
                delBtn.BackgroundColor3 = Color3.fromRGB(120, 126, 138)
                delBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
                task.delay(2, function()
                    if delBtn and delBtn.Parent and deleteState == 1 then
                        deleteState = 0
                        delBtn.Text = originalDeleteText
                        delBtn.BackgroundColor3 = Color3.fromRGB(205, 220, 245)
                        delBtn.TextColor3 = Color3.fromRGB(35, 50, 90)
                    end
                end)
            elseif deleteState == 1 then
                delDebounce = true
                local invoked, success = pcall(resetToFactoryDefaults)
                success = invoked and success
                delBtn.Text = success and "SETTINGS RESET" or "ERROR"
                delBtn.BackgroundColor3 = Color3.fromRGB(205, 220, 245)
                delBtn.TextColor3 = Color3.fromRGB(35, 50, 90)
                deleteState = 0
                task.delay(1.5, function()
                    if delBtn and delBtn.Parent then
                        delBtn.Text = originalDeleteText
                        delBtn.BackgroundColor3 = Color3.fromRGB(205, 220, 245)
                        delBtn.TextColor3 = Color3.fromRGB(35, 50, 90)
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
        resetBtn.BackgroundColor3 = Color3.fromRGB(205, 220, 245)
        resetBtn.BorderSizePixel = 0
        resetBtn.Text = "RESET"
        resetBtn.TextColor3 = Color3.fromRGB(35, 50, 90)
        resetBtn.Font = Enum.Font.GothamBold
        resetBtn.TextSize = 12
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
    addKeybindRow(keyPage, "Bat V2", KB.BatV2)
    addKeybindRow(keyPage, "TP BAT", KB.TPBat)

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

    pbFrame = Instance.new("Frame", gui)
    pbFrame.Name = "YoutAutoGrabBar"
    pbFrame.Size = UDim2.new(0, 344, 0, 56)
    pbFrame.Position = UDim2.new(0.5, -134, 0.80, 0)
    pbFrame.BackgroundColor3 = Color3.fromRGB(5, 20, 32)
    pbFrame.BackgroundTransparency = 0.04
    pbFrame.BorderSizePixel = 0
    pbFrame.Active = true
    pbFrame.Visible = CONFIG.AUTO_STEAL_ENABLED
    pbFrame.ZIndex = 500
    pbFrame.ClipsDescendants = false
    Instance.new("UICorner", pbFrame).CornerRadius = UDim.new(0, 12)

    pbScale = Instance.new("UIScale", pbFrame)
    pbScale.Scale = uiScaleValue / 100

    if savedProgressBarPos then
        pbFrame.Position = UDim2.new(
            savedProgressBarPos.XScale or 0.5,
            savedProgressBarPos.XOffset or -172,
            savedProgressBarPos.YScale or 0.80,
            savedProgressBarPos.YOffset or 0
        )
    end

    local pbPanelGrad = Instance.new("UIGradient", pbFrame)
    pbPanelGrad.Name = "PanelGrad"
    pbPanelGrad.Rotation = 90
    pbPanelGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0.00, Color3.fromRGB(18, 45, 68)),
        ColorSequenceKeypoint.new(0.48, Color3.fromRGB(7, 22, 38)),
        ColorSequenceKeypoint.new(1.00, Color3.fromRGB(5, 2, 12)),
    })

    local pbOuterStroke = Instance.new("UIStroke", pbFrame)
    pbOuterStroke.Name = "OuterStroke"
    pbOuterStroke.Color = Color3.fromRGB(105, 190, 245)
    pbOuterStroke.Thickness = 1.1
    pbOuterStroke.Transparency = 0.35
    pbOuterStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

    local progressTitle = Instance.new("TextLabel", pbFrame)
    progressTitle.Name = "DiscordText"
    progressTitle.Size = UDim2.new(1, -14, 0, 16)
    progressTitle.Position = UDim2.new(0, 7, 0, 4)
    progressTitle.BackgroundTransparency = 1
    progressTitle.Text = "discord.gg/fearhub"
    progressTitle.TextColor3 = Color3.fromRGB(195, 230, 255)
    progressTitle.Font = Enum.Font.FredokaOne
    progressTitle.TextSize = 12
    progressTitle.TextXAlignment = Enum.TextXAlignment.Center
    progressTitle.ZIndex = 506

    local pbTopRow = Instance.new("Frame", pbFrame)
    pbTopRow.Name = "InfoColumn"
    pbTopRow.Size = UDim2.new(0, 92, 0, 14)
    pbTopRow.Position = UDim2.new(1, -98, 1, -17)
    pbTopRow.BackgroundTransparency = 1
    pbTopRow.ZIndex = 504

    local pbDivider = Instance.new("Frame", pbTopRow)
    pbDivider.Name = "Divider"
    pbDivider.Size = UDim2.new(0, 1, 1, -2)
    pbDivider.Position = UDim2.new(0, 0, 0, 1)
    pbDivider.BackgroundColor3 = Color3.fromRGB(105, 190, 245)
    pbDivider.BackgroundTransparency = 0.55
    pbDivider.BorderSizePixel = 0
    pbDivider.ZIndex = 505

    local fpsNeon = Instance.new("TextLabel", pbTopRow)
    fpsNeon.Name = "FPSNeon"
    fpsNeon.Size = UDim2.new(0.5, -5, 1, 0)
    fpsNeon.Position = UDim2.new(0, 5, 0, 0)
    fpsNeon.BackgroundTransparency = 1
    fpsNeon.Text = "-- FPS"
    fpsNeon.TextColor3 = Color3.fromRGB(165, 220, 255)
    fpsNeon.Font = Enum.Font.FredokaOne
    fpsNeon.TextSize = 8
    fpsNeon.TextXAlignment = Enum.TextXAlignment.Left
    fpsNeon.ZIndex = 506

    local pingNeon = Instance.new("TextLabel", pbTopRow)
    pingNeon.Name = "PingNeon"
    pingNeon.Size = UDim2.new(0.5, -2, 1, 0)
    pingNeon.Position = UDim2.new(0.5, 1, 0, 0)
    pingNeon.BackgroundTransparency = 1
    pingNeon.Text = "-- MS"
    pingNeon.TextColor3 = Color3.fromRGB(165, 220, 255)
    pingNeon.Font = Enum.Font.FredokaOne
    pingNeon.TextSize = 8
    pingNeon.TextXAlignment = Enum.TextXAlignment.Right
    pingNeon.ZIndex = 506

    local pbBarBg = Instance.new("Frame", pbFrame)
    pbBarBg.Name = "BarBg"
    pbBarBg.Size = UDim2.new(1, -14, 0, 20)
    pbBarBg.Position = UDim2.new(0, 7, 0, 22)
    pbBarBg.BackgroundColor3 = Color3.fromRGB(3, 1, 6)
    pbBarBg.BorderSizePixel = 0
    pbBarBg.ClipsDescendants = true
    pbBarBg.ZIndex = 500
    Instance.new("UICorner", pbBarBg).CornerRadius = UDim.new(0, 8)

    local trackStroke = Instance.new("UIStroke", pbBarBg)
    trackStroke.Name = "TrackStroke"
    trackStroke.Color = Color3.fromRGB(55, 125, 175)
    trackStroke.Thickness = 1
    trackStroke.Transparency = 0.15

    progressFill = Instance.new("Frame", pbBarBg)
    progressFill.Size = UDim2.new(0, 0, 1, 0)
    progressFill.Position = UDim2.new(0, 0, 0, 0)
    progressFill.BackgroundColor3 = Color3.fromRGB(105, 190, 245)
    progressFill.BorderSizePixel = 0
    progressFill.ClipsDescendants = true
    progressFill.ZIndex = 502
    Instance.new("UICorner", progressFill).CornerRadius = UDim.new(0, 8)

    local fillGrad = Instance.new("UIGradient", progressFill)
    fillGrad.Name = "FillGrad"
    fillGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0.00, Color3.fromRGB(190, 230, 255)),
        ColorSequenceKeypoint.new(0.50, Color3.fromRGB(105, 190, 245)),
        ColorSequenceKeypoint.new(1.00, Color3.fromRGB(55, 125, 180)),
    })
    fillGrad.Rotation = 0

    local fillHighlight = Instance.new("Frame", progressFill)
    fillHighlight.Name = "FillHighlight"
    fillHighlight.Size = UDim2.new(1, -6, 0.35, 0)
    fillHighlight.Position = UDim2.new(0, 3, 0, 1)
    fillHighlight.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    fillHighlight.BackgroundTransparency = 0.72
    fillHighlight.BorderSizePixel = 0
    fillHighlight.ZIndex = 503
    Instance.new("UICorner", fillHighlight).CornerRadius = UDim.new(1, 0)

    local shimmer = Instance.new("Frame", progressFill)
    shimmer.Name = "Shimmer"
    shimmer.Size = UDim2.new(0, 34, 1, 0)
    shimmer.Position = UDim2.new(0, -34, 0, 0)
    shimmer.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    shimmer.BackgroundTransparency = 0.58
    shimmer.BorderSizePixel = 0
    shimmer.ZIndex = 504
    Instance.new("UICorner", shimmer).CornerRadius = UDim.new(1, 0)

    local shimmerGrad = Instance.new("UIGradient", shimmer)
    shimmerGrad.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0.00, 1),
        NumberSequenceKeypoint.new(0.50, 0.25),
        NumberSequenceKeypoint.new(1.00, 1),
    })

    progressPct = Instance.new("TextLabel", pbBarBg)
    progressPct.Size = UDim2.new(1, 0, 1, 0)
    progressPct.Position = UDim2.new(0, 0, 0, 0)
    progressPct.BackgroundTransparency = 1
    progressPct.Text = "0%"
    progressPct.TextColor3 = Color3.fromRGB(245, 235, 255)
    progressPct.Font = Enum.Font.FredokaOne
    progressPct.TextSize = 11
    progressPct.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    progressPct.TextStrokeTransparency = 0.25
    progressPct.TextXAlignment = Enum.TextXAlignment.Center
    progressPct.TextYAlignment = Enum.TextYAlignment.Center
    progressPct.ZIndex = 505

    task.spawn(function()
        while pbFrame and pbFrame.Parent do
            shimmer.Position = UDim2.new(0, -60, 0, 0)
            TS:Create(shimmer, TweenInfo.new(1.6, Enum.EasingStyle.Linear), {
                Position = UDim2.new(1, 20, 0, 0)
            }):Play()
            task.wait(1.6)
        end
    end)

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

function createMobilePanel()
    local panel = Instance.new("ScreenGui")
    panel.Name = "YoutMobilePanel"
    panel.ResetOnSpawn = false
    panel.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    pcall(function() if syn and syn.protect_gui then syn.protect_gui(panel) end end)
    local okPanel = pcall(function() panel.Parent = game:GetService("CoreGui") end)
    if not okPanel then panel.Parent = LP:WaitForChild("PlayerGui") end

    local BTN_W, BTN_H = 60, 40
    local buttons = {}
    _G.__YoutFloatingButtons = buttons
    local buttonNames = {"DropBR", "AutoLeft", "AutoBat", "AutoRight", "TpDown", "Carry", "Lagger1", "Lagger2"}
    local buttonTexts = {"DROP\nBR", "AUTO\nLEFT", "BAT\nAIMBOT", "AUTO\nRIGHT", "TP\nDOWN", "CARRY\nSPD", "LAGGER\nNORMAL", "LAGGER\nCARRY"}

    local function createButton(name, text, order, isToggle, callback)
        local btn = Instance.new("TextButton", panel)
        btn.Name = name
        btn.Size = UDim2.new(0, BTN_W, 0, BTN_H)
        btn.BackgroundColor3 = Color3.fromRGB(0,0,0)
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
        local buttonCorner = Instance.new("UICorner", btn)
        buttonCorner.CornerRadius = UDim.new(0, floatingButtonStyle == 2 and 0 or 9)
        btn:SetAttribute("YoutButtonStyle", floatingButtonStyle)

        local bgGrad = Instance.new("UIGradient", btn)
        bgGrad.Name = "BtnGrad"
        bgGrad.Rotation = 90
        bgGrad.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0.00, Color3.fromRGB(20, 8, 35)),
            ColorSequenceKeypoint.new(0.45, Color3.fromRGB(7, 22, 35)),
            ColorSequenceKeypoint.new(1.00, Color3.fromRGB(0, 0, 0)),
        })

        local stroke = Instance.new("UIStroke", btn)
        stroke.Color = Color3.fromRGB(55, 125, 175)
        stroke.Thickness = 1
        stroke.Transparency = 0.55
        stroke.Name = "NormalStroke"

        local label = Instance.new("TextLabel", btn)
        label.Name = "TextLabel"
        label.Size = UDim2.new(1, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.Text = text
        label.TextColor3 = Color3.fromRGB(195, 230, 255)
        label.Font = Enum.Font.FredokaOne
        label.TextSize = 10
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
        btn:SetAttribute("YoutButtonStyle", floatingButtonStyle)
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
                if _G.__YoutApplySpeedNow then pcall(_G.__YoutApplySpeedNow) end
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
                if _G.__YoutApplySpeedNow then pcall(_G.__YoutApplySpeedNow) end
            end
        elseif name == "Lagger2" then
            callback = function(setActive)
                if speedMode then speedMode = false; if mobSetCarry then mobSetCarry(false) end end
                if not laggerCarryToggled then
                    laggerCarryToggled = true; laggerToggled = false; setActive(true)
                    if buttons.Lagger1 and buttons.Lagger1.setActive then buttons.Lagger1.setActive(false) end
                else
                    laggerCarryToggled = false; setActive(false)
                end
                refreshSpeedModeLabel()
                if _G.__YoutApplySpeedNow then pcall(_G.__YoutApplySpeedNow) end
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
    for _, info in pairs(buttons) do
        if info and info.btn then
            paintFloatingBtn(info.btn, info.btn:GetAttribute("MobActive") == true)
        end
    end
    return panel
end

function createBatV2FloatingButton()
    local panel = Instance.new("ScreenGui")
    panel.Name = "YoutBatV2Button"
    panel.ResetOnSpawn = false
    panel.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    panel.DisplayOrder = 22
    pcall(function() if syn and syn.protect_gui then syn.protect_gui(panel) end end)
    local okPanel = pcall(function() panel.Parent = game:GetService("CoreGui") end)
    if not okPanel then panel.Parent = LP:WaitForChild("PlayerGui") end
    local btnFrame = Instance.new("Frame", panel)
    btnFrame.Size = UDim2.new(0, 60, 0, 40)
    btnFrame.Name = "Frame"
    if batV2FloatingPos then
        btnFrame.Position = UDim2.new(
            batV2FloatingPos.XScale or 0.5,
            batV2FloatingPos.XOffset or -50,
            batV2FloatingPos.YScale or 0,
            batV2FloatingPos.YOffset or 10
        )
    else
        btnFrame.Position = UDim2.new(0.5, -50, 0, 10)
    end
    btnFrame.BackgroundColor3 = Color3.fromRGB(255,255,255)
    btnFrame.BorderSizePixel = 0
    btnFrame.ZIndex = 20
    Instance.new("UICorner", btnFrame).CornerRadius = UDim.new(0, floatingButtonStyle == 2 and 0 or 9)
    local bgGrad = Instance.new("UIGradient", btnFrame)
    bgGrad.Name = "BtnGrad"
    bgGrad.Rotation = 90
    bgGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0.00, Color3.fromRGB(20, 8, 35)),
        ColorSequenceKeypoint.new(0.45, Color3.fromRGB(7, 22, 35)),
        ColorSequenceKeypoint.new(1.00, Color3.fromRGB(0, 0, 0)),
    })
    local shapeStroke = Instance.new("UIStroke", btnFrame)
    shapeStroke.Color = Color3.fromRGB(55, 125, 175)
    shapeStroke.Thickness = 1
    shapeStroke.Transparency = 0.25
    local label = Instance.new("TextLabel", btnFrame)
    label.Size = UDim2.new(1,0,1,0)
    label.BackgroundTransparency = 1
    label.Text = "BAT\nV2"
    label.TextColor3 = Color3.fromRGB(195, 230, 255)
    label.Font = Enum.Font.FredokaOne
    label.TextSize = 10
    label.TextWrapped = true
    label.ZIndex = 21
    local uiScale = Instance.new("UIScale", btnFrame)
    uiScale.Scale = floatingButtonScale
    table.insert(_floatingUIScales, uiScale)
    paintFloatingBtn(btnFrame, _YOUT_BATV2_STATE.enabled)
    local dragging = false
    local hasMoved = false
    local dragStart, startPos
    btnFrame.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            hasMoved = false
            dragStart = inp.Position
            startPos = btnFrame.Position
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
                    if _YOUT_BATV2_STATE.enabled then stopYoutBatV2() else startYoutBatV2() end
                    paintFloatingBtn(btnFrame, _YOUT_BATV2_STATE.enabled)
                elseif not uiLocked then
                    batV2FloatingPos = {
                        XScale = btnFrame.Position.X.Scale,
                        XOffset = btnFrame.Position.X.Offset,
                        YScale = btnFrame.Position.Y.Scale,
                        YOffset = btnFrame.Position.Y.Offset
                    }
                    task.defer(function() pcall(saveAllSettings, true) end)
                end
                dragging = false
                hasMoved = false
            end
        end
    end)
    batV2FloatingButton = panel
    return panel
end

function createTpBatFloatingButton()
    local panel = Instance.new("ScreenGui")
    panel.Name = "TpBatButton"
    panel.ResetOnSpawn = false
    panel.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    panel.DisplayOrder = 21
    pcall(function() if syn and syn.protect_gui then syn.protect_gui(panel) end end)
    local okPanel = pcall(function() panel.Parent = game:GetService("CoreGui") end)
    if not okPanel then panel.Parent = LP:WaitForChild("PlayerGui") end
    local btnFrame = Instance.new("Frame", panel)
    btnFrame.Size = UDim2.new(0, 60, 0, 40)
    btnFrame.Name = "Frame"
    if tpBatFloatingPos then
        btnFrame.Position = UDim2.new(tpBatFloatingPos.XScale or 0.5, tpBatFloatingPos.XOffset or 20, tpBatFloatingPos.YScale or 0, tpBatFloatingPos.YOffset or 10)
    else
        btnFrame.Position = UDim2.new(0.5, 20, 0, 10)
    end
    btnFrame.BackgroundColor3 = Color3.fromRGB(255,255,255)
    btnFrame.BorderSizePixel = 0
    btnFrame.ZIndex = 20
    Instance.new("UICorner", btnFrame).CornerRadius = UDim.new(0, floatingButtonStyle == 2 and 0 or 9)
    local bgGrad = Instance.new("UIGradient", btnFrame)
    bgGrad.Name = "BtnGrad"
    bgGrad.Rotation = 90
    bgGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0.00, Color3.fromRGB(20, 8, 35)),
        ColorSequenceKeypoint.new(0.45, Color3.fromRGB(7, 22, 35)),
        ColorSequenceKeypoint.new(1.00, Color3.fromRGB(0, 0, 0)),
    })
    local shapeStroke = Instance.new("UIStroke", btnFrame)
    shapeStroke.Color = Color3.fromRGB(55, 125, 175)
    shapeStroke.Thickness = 1
    shapeStroke.Transparency = 0.25
    local label = Instance.new("TextLabel", btnFrame)
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = "TP\nBAT"
    label.TextColor3 = Color3.fromRGB(195, 230, 255)
    label.Font = Enum.Font.FredokaOne
    label.TextSize = 10
    label.TextWrapped = true
    label.ZIndex = 21
    local uiScale = Instance.new("UIScale", btnFrame)
    uiScale.Scale = floatingButtonScale
    table.insert(_floatingUIScales, uiScale)
    local function setActive(state)
        label.Text = "TP\nBAT"
        paintFloatingBtn(btnFrame, state)
    end
    setActive(batDesyncTpEnabled == true)
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
    tpBatFloatingButton = panel
    return panel
end

function createInstaResetFloatingButton()
    local panel = Instance.new("ScreenGui")
    panel.Name = "InstaResetButton"
    panel.ResetOnSpawn = false
    panel.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    panel.DisplayOrder = 23
    pcall(function() if syn and syn.protect_gui then syn.protect_gui(panel) end end)
    local okPanel = pcall(function() panel.Parent = game:GetService("CoreGui") end)
    if not okPanel then panel.Parent = LP:WaitForChild("PlayerGui") end
    local btnFrame = Instance.new("Frame", panel)
    btnFrame.Size = UDim2.new(0, 60, 0, 40)
    btnFrame.Name = "Frame"
    if instaResetFloatingPos then
        btnFrame.Position = UDim2.new(instaResetFloatingPos.XScale or 0.5, instaResetFloatingPos.XOffset or 90, instaResetFloatingPos.YScale or 0, instaResetFloatingPos.YOffset or 10)
    else
        btnFrame.Position = UDim2.new(0.5, 90, 0, 10)
    end
    btnFrame.BackgroundColor3 = Color3.fromRGB(255,255,255)
    btnFrame.BorderSizePixel = 0
    btnFrame.ZIndex = 20
    Instance.new("UICorner", btnFrame).CornerRadius = UDim.new(0, floatingButtonStyle == 2 and 0 or 9)
    local bgGrad = Instance.new("UIGradient", btnFrame)
    bgGrad.Name = "BtnGrad"
    bgGrad.Rotation = 90
    bgGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0.00, Color3.fromRGB(20, 8, 35)),
        ColorSequenceKeypoint.new(0.45, Color3.fromRGB(7, 22, 35)),
        ColorSequenceKeypoint.new(1.00, Color3.fromRGB(0, 0, 0)),
    })
    local shapeStroke = Instance.new("UIStroke", btnFrame)
    shapeStroke.Color = Color3.fromRGB(55, 125, 175)
    shapeStroke.Thickness = 1
    shapeStroke.Transparency = 0.25
    local label = Instance.new("TextLabel", btnFrame)
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = "INSTA\nRESET"
    label.TextColor3 = Color3.fromRGB(195, 230, 255)
    label.Font = Enum.Font.FredokaOne
    label.TextSize = 10
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
        paintFloatingBtn(btnFrame, state and true or false)
    end
    setActive(false)
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
    instaResetFloatingButton = panel
    return panel
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
        pbFrame.Position = UDim2.new(savedProgressBarPos.XScale or 0.5, savedProgressBarPos.XOffset or -134, savedProgressBarPos.YScale or 0.80, savedProgressBarPos.YOffset or 0)
    end
    applyBackgroundMode(backgroundMode)
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
    pcall(refreshOutfitModifierVisuals)
    -- [KATANA] re-aplicar bat skin si corresponde
    if currentBatSkin and currentBatSkin ~= "None" then
        task.defer(function() pcall(setBatSkin, currentBatSkin) end)
    end
end

local _bootErrors = {}

local function _bootSection(name, fn)
    print("[Y-out Boot] Iniciando:", name)
    local ok, err = pcall(fn)
    if not ok then
        print("[Y-out Boot] FALLÓ:", name, tostring(err))
        table.insert(_bootErrors, {name = name, err = tostring(err)})
        warn("[Y-out Boot] Error en '" .. name .. "': " .. tostring(err))
    else
        print("[Y-out Boot] OK:", name)
    end
    return ok
end

_bootSection("buildGui", function() buildGui() end)

if gui and main then
    _bootSection("loadAllSettings", function()
        if loadAllSettings() then updateUIFromLoaded() end
    end)
    _bootSection("createMobilePanel", function() MobilePanel = createMobilePanel() end)
    _bootSection("createBatV2FloatingButton", function() batV2FloatingButton = createBatV2FloatingButton() end)
    _bootSection("createTpBatFloatingButton", function() tpBatFloatingButton = createTpBatFloatingButton() end)
    _bootSection("createInstaResetFloatingButton", function() instaResetFloatingButton = createInstaResetFloatingButton() end)
    if hideButtonsEnabled then
        _bootSection("applyHideButtons", function()
            applyHideButtons(true)
            if setHideButtonsVisual then setHideButtonsVisual(true) end
        end)
    end
    _bootSection("localizeYoutInterface", function()
        if gui then localizeYoutInterface(gui) end
        if MobilePanel then localizeYoutInterface(MobilePanel) end
        if batV2FloatingButton then localizeYoutInterface(batV2FloatingButton) end
        if tpBatFloatingButton then localizeYoutInterface(tpBatFloatingButton) end
        if instaResetFloatingButton then localizeYoutInterface(instaResetFloatingButton) end
    end)
    if LP.Character then
        task.spawn(function()
            task.wait(0.1)
            if waitForCharReady(LP.Character, 5) then
                pcall(function() captureOriginalAppearance(LP.Character) end)
                pcall(function() setupMovementAndIndicators(LP.Character) end)
                if currentAnimPack ~= "Off" then pcall(function() startAnimPack(currentAnimPack) end) end
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
                    local log = "[Y-out Boot Errors] " .. os.date("%Y-%m-%d %H:%M:%S") .. "\n"
                    for _, e in ipairs(_bootErrors) do log = log .. e.name .. ": " .. e.err .. "\n" end
                    pcall(writeFn, "Yout_boot_errors.txt", log)
                    warn("[Y-out] Errores escritos a Yout_boot_errors.txt")
                end
            end)
        end)
    end
else
    warn("[Y-out Boot] Fatal: buildGui falló.")
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
                if stopMedusaCounter then stopMedusaCounter() end
                if not _tpBatUnwalkForced and stopUnwalk then stopUnwalk() end
                if stopDropBrainrot then stopDropBrainrot() end
                if autoBatEnabled and disableAutoBat then disableAutoBat() end
                local _tpBatRespawnWanted = batDesyncTpEnabled
                if batDesyncTpEnabled and stopBatDesyncTp then stopBatDesyncTp() end
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
                if _tpBatRespawnWanted then task.defer(startBatDesyncTp) end
                if bodyLockEnabled and _blSuppressCount == 0 then startBodyLock() end
                if medusaCounterEnabled then
                    setupMedusaCounter(char)
                    if setMedusaVisual then setMedusaVisual(true) end
                else
                    stopMedusaCounter()
                    if setMedusaVisual then setMedusaVisual(false) end
                end
                if batCounterEnabled then startBatCounter() end
                if unwalkEnabled and not _tpBatUnwalkForced then startUnwalk() end
                if currentAnimPack ~= "Off" then task.wait(0.3); startAnimPack(currentAnimPack) end
                updateProgressBarVisibility()
                refreshSpeedModeLabel()
                pcall(function() applyOutfitByIndex(currentOutfitIndex) end)
                if outfitSelectorLabel then outfitSelectorLabel.Text = OUTFITS[currentOutfitIndex].label end
                -- [KATANA] re-aplicar bat skin tras respawn
                if currentBatSkin ~= "None" then
                    task.delay(0.6, function()
                        if currentBatSkin ~= "None" then
                            pcall(applyCurrentBatSkin)
                        end
                    end)
                end
            end)
        end)
    end)
end

local lastLaggerToggle = 0
local LAGGER_COOLDOWN = 0.3

local function runTest20Keybind(kc)
    if not kc or kc == Enum.KeyCode.Unknown then return end
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
    if kbMatch(KB.BatV2, kc) then
        if _YOUT_BATV2_STATE.enabled then stopYoutBatV2() else startYoutBatV2() end
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
    if kbMatch(KB.GuiHide, kc) then
        if main then
            if main.Visible then hideGui() else showGui() end
        end
        return
    end
end

local _test20TriggerHeld = {}

UIS.InputBegan:Connect(function(input, gpe)
    if _anyKeyListening then return end
    if input.UserInputType == Enum.UserInputType.Keyboard then
        if gpe or UIS:GetFocusedTextBox() then return end
    elseif not isGamepadInput(input) then
        return
    end
    if not isBindableInput(input) then return end
    local kc = input.KeyCode
    if kc == Enum.KeyCode.ButtonL2 or kc == Enum.KeyCode.ButtonR2 then
        _test20TriggerHeld[kc.Name] = true
    end
    runTest20Keybind(kc)
end)

UIS.InputChanged:Connect(function(input)
    if _anyKeyListening or not isGamepadInput(input) then return end
    local kc = input.KeyCode
    if kc ~= Enum.KeyCode.ButtonL2 and kc ~= Enum.KeyCode.ButtonR2 then return end
    local z = input.Position.Z
    local name = kc.Name
    if z >= 0.45 then
        if not _test20TriggerHeld[name] then
            _test20TriggerHeld[name] = true
            runTest20Keybind(kc)
        end
    elseif z <= 0.15 then
        _test20TriggerHeld[name] = false
    end
end)

UIS.InputEnded:Connect(function(input)
    local kc = input.KeyCode
    if kc == Enum.KeyCode.ButtonL2 or kc == Enum.KeyCode.ButtonR2 then
        _test20TriggerHeld[kc.Name] = false
    end
end)

-- ============ FEAR X BLESS INTRO (adaptada de la segunda source) ============
-- ================================================================
-- XLU0 DUELS INTRO (standalone)
-- ================================================================
local Players          = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService     = game:GetService("TweenService")
local RunService       = game:GetService("RunService")
local SoundService     = game:GetService("SoundService")
local HttpService      = game:GetService("HttpService")

local LP        = Players.LocalPlayer
local PlayerGui = LP:WaitForChild("PlayerGui")
local IntroParent = (gui and gui.Parent) or PlayerGui
local Main = main
local MiniFrame = miniBtn
local FULL_MAIN_SIZE = Main and Main.Size or UDim2.new(0, 348, 0, 468)

local Xlu0AutoMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

-- Theme (used to tint Toji pieces + intro title sweep)
_G.Xlu0ThemeColors = _G.Xlu0ThemeColors or {
    PURPLE = Color3.fromRGB(207, 159, 255),
    BLUE   = Color3.fromRGB(58, 128, 245),
    RED    = Color3.fromRGB(232, 52, 68),
    PINK   = Color3.fromRGB(255, 105, 180),
    YELLOW = Color3.fromRGB(255, 214, 0),
    GREY   = Color3.fromRGB(90, 90, 90),
    WHITE  = Color3.fromRGB(255, 255, 255),
    FOREST = Color3.fromRGB(46, 139, 87),
}
_G.Xlu0ThemeName = _G.Xlu0ThemeName or "WHITE"


-- ---------------- INTRO MUSIC SYSTEM ----------------
selectedIntroMusic = 4
_introEnabled = (_introEnabled ~= false)

INTRO_MUSIC_OPTIONS = INTRO_MUSIC_OPTIONS or {
    {name="Song 1", url="https://files.catbox.moe/mzvrir.mp3", file="Xlu0DuelsIntroSong_1.mp3"},
    {name="Song 2", url="https://files.catbox.moe/2a7jyx.mp3", file="Xlu0DuelsIntroSong_2.mp3"},
    {name="Song 3", url="https://files.catbox.moe/rcgr9f.mp3", file="Xlu0DuelsIntroSong_3.mp3"},
    {name="Song 4", url="https://files.catbox.moe/iknfuh.mp3", file="Xlu0DuelsIntroSong_4.mp3"},
    {name="Song 5", url="https://files.catbox.moe/6eigoh.mp3", file="Xlu0DuelsIntroSong_5.mp3"},
    {name="Song 6", url="https://files.catbox.moe/dvjtjk.mp3", file="Xlu0DuelsIntroSong_6.mp3"},
    {name="Song 7", url="https://files.catbox.moe/iyw1cb.mp3", file="Xlu0DuelsIntroSong_7.mp3"},
}

introPreviewSound    = nil
introPlaybackSound   = nil
introPreviewToken    = 0
introPlaybackToken   = 0
introSongCache       = introSongCache or {}
introSongDownloading = introSongDownloading or {}

function _safeNotify(msg)
    -- no-op stub (was used by original UI)
end

function stopIntroPreview()
    introPreviewToken = introPreviewToken + 1
    if introPreviewSound then
        pcall(function() introPreviewSound:Stop() end)
        pcall(function() introPreviewSound:Destroy() end)
        introPreviewSound = nil
    end
end

function stopIntroPlayback()
    introPlaybackToken = introPlaybackToken + 1
    if introPlaybackSound then
        pcall(function() introPlaybackSound:Stop() end)
        pcall(function() introPlaybackSound:Destroy() end)
        introPlaybackSound = nil
    end
end

function cacheIntroSong(option, allowDownload)
    if not option or not option.url or option.url == "" then return nil end
    if not (writefile and getcustomasset) then return nil end

    local fileName = option.file or ("Xlu0DuelsIntroSong_" .. tostring(option.name or "song") .. ".mp3")

    local function loadExisting()
        if introSongCache[fileName] then return introSongCache[fileName] end
        local hasFile = false
        pcall(function() hasFile = isfile and isfile(fileName) end)
        if hasFile then
            local ok = pcall(function() introSongCache[fileName] = getcustomasset(fileName) end)
            if ok and introSongCache[fileName] then return introSongCache[fileName] end
        end
        return nil
    end

    local cached = loadExisting()
    if cached then return cached end
    if allowDownload == false then return nil end

    if introSongDownloading[fileName] then
        local waitStart = tick()
        while introSongDownloading[fileName] and tick() - waitStart < 12 do task.wait(0.05) end
        cached = loadExisting()
        if cached then return cached end
    end

    introSongDownloading[fileName] = true
    local ok = pcall(function()
        local data = game:HttpGet(option.url)
        if data and #data > 0 then
            writefile(fileName, data)
            introSongCache[fileName] = getcustomasset(fileName)
        end
    end)
    introSongDownloading[fileName] = nil

    if ok and introSongCache[fileName] then return introSongCache[fileName] end
    return loadExisting()
end

function preloadIntroSongs()
    task.spawn(function()
        cacheIntroSong(INTRO_MUSIC_OPTIONS[selectedIntroMusic], true)
        for _, option in ipairs(INTRO_MUSIC_OPTIONS) do
            if option ~= INTRO_MUSIC_OPTIONS[selectedIntroMusic] then
                cacheIntroSong(option, true)
                task.wait(0.05)
            end
        end
    end)
end

function makeIntroSoundFromId(soundId, name, parent)
    if not soundId then return nil end
    local sound = Instance.new("Sound")
    sound.Name = name or "Xlu0DuelsIntroMusic"
    sound.Volume = 0.65
    sound.Looped = false
    sound.SoundId = soundId
    sound.Parent = parent or SoundService
    return sound
end

function createIntroSound(option, fileName, parent, allowDownload)
    if not option then return nil end
    local soundId = cacheIntroSong(option, allowDownload)
    if not soundId then return nil end
    return makeIntroSoundFromId(soundId, fileName, parent)
end

function playIntroMusic()
    stopIntroPreview()
    stopIntroPlayback()
    if not _introEnabled then return end
    local option = INTRO_MUSIC_OPTIONS[selectedIntroMusic]
    if not option then return end
    local token = introPlaybackToken
    task.spawn(function()
        local sound = createIntroSound(option, "Xlu0DuelsIntroMusic_" .. tostring(token), SoundService, true)
        if token ~= introPlaybackToken or not _introEnabled then
            if sound then pcall(function() sound:Destroy() end) end
            return
        end
        introPlaybackSound = sound
        if not sound then _safeNotify("SONG FAILED"); return end
        sound.TimePosition = 0
        local loadStart = tick()
        while sound and not sound.IsLoaded and tick() - loadStart < 10 do task.wait(0.05) end
        pcall(function() sound:Play() end)
        task.delay(15, function() if token == introPlaybackToken then stopIntroPlayback() end end)
    end)
end

preloadIntroSongs()

-- ---------------- INTRO ANIMATION ----------------
_G.__Xlu0DuelsRunIntro = function()
    if not Main or not Main.Parent then return end
    local introGuiParent = IntroParent
    local origSize = FULL_MAIN_SIZE
    local wasMinimizedBeforeIntro = (_G.__Xlu0DuelsMinimized == true)

    -- Keep the intro as the only visible interface until it finishes.
    local hiddenInterfaceStates = {}
    local hiddenBillboardStates = {}
    local fearInterfaceNames = {
        FEAR_X_BLESS = true,
        YoutMobilePanel = true,
        YoutBatV2Button = true,
        TpBatButton = true,
        InstaResetButton = true,
        YoutESPLine = true,
    }
    local function hideOtherInterfaces()
        local roots = {game:GetService("CoreGui"), PlayerGui}
        local seen = {}
        for _, root in ipairs(roots) do
            if root and not seen[root] then
                seen[root] = true
                for _, obj in ipairs(root:GetChildren()) do
                    if obj:IsA("ScreenGui") and fearInterfaceNames[obj.Name] then
                        hiddenInterfaceStates[obj] = obj.Enabled
                        obj.Enabled = false
                    end
                end
            end
        end
        local character = LP.Character
        if character then
            for _, obj in ipairs(character:GetDescendants()) do
                if obj:IsA("BillboardGui") then
                    hiddenBillboardStates[obj] = obj.Enabled
                    obj.Enabled = false
                end
            end
        end
    end
    local function restoreOtherInterfaces()
        for obj, wasEnabled in pairs(hiddenInterfaceStates) do
            if obj and obj.Parent then pcall(function() obj.Enabled = wasEnabled end) end
        end
        for obj, wasEnabled in pairs(hiddenBillboardStates) do
            if obj and obj.Parent then pcall(function() obj.Enabled = wasEnabled end) end
        end
        table.clear(hiddenInterfaceStates)
        table.clear(hiddenBillboardStates)
    end

    if not _introEnabled then
        restoreOtherInterfaces()
        stopIntroPlayback()
        stopIntroPreview()
        Main.Size = origSize
        Main.Visible = not wasMinimizedBeforeIntro
        MiniFrame.Visible = wasMinimizedBeforeIntro
        return
    end

    hideOtherInterfaces()
    playIntroMusic()
    Main.Visible = false
    MiniFrame.Visible = false
    Main.Size = UDim2.new(0, 0, 0, 0)

    task.spawn(function()
        local DARKER_BG    = Color3.fromRGB(5, 5, 8)
        local WHITE        = Color3.fromRGB(255, 255, 255)
        local TRAIL_COLOR  = Color3.fromRGB(205, 215, 235)

        local function applyProps(inst, props)
            for k, v in pairs(props) do
                if k ~= "Parent" then inst[k] = v end
            end
            if props.Parent then inst.Parent = props.Parent end
            return inst
        end

        local function new(class, props)
            return applyProps(Instance.new(class), props)
        end

        local function tween(obj, duration, props, style, dir)
            local info = TweenInfo.new(duration, style or Enum.EasingStyle.Quad, dir or Enum.EasingDirection.Out)
            local t = TweenService:Create(obj, info, props)
            t:Play()
            return t
        end

        local IntroGui = new("ScreenGui", {
            Name = "Xlu0DuelsIntro",
            IgnoreGuiInset = true,
            ResetOnSpawn = false,
            DisplayOrder = 100,
            ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
            Parent = introGuiParent,
        })

        local AdaptIntro = new("Frame", {
            Name = "AdaptIntro",
            ZIndex = 1000,
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundColor3 = DARKER_BG,
            BackgroundTransparency = 0.5,
            BorderSizePixel = 0,
            Parent = IntroGui,
        })

        -- Toji Cutout Stage
        local TojiCutoutStage = new("Frame", {
            Name = "TojiCutoutStage",
            Visible = false,
            ZIndex = 1000,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.new(0.5, 0, 0.5, 0),
            Size = Xlu0AutoMobile and UDim2.new(0.62, 0, 0.62, 0) or UDim2.new(0.72, 0, 0.72, 0),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Rotation = -2,
            Parent = AdaptIntro,
        })
        new("UIScale", {Parent = TojiCutoutStage})

        new("ImageLabel", {
            Name = "TojiPantsWhiteFill",
            ZIndex = 998,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.new(0.5, 0, 0.5, 0),
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            Image = "rbxassetid://82757811555212",
            ImageTransparency = 1,
            ScaleType = Enum.ScaleType.Fit,
            Parent = TojiCutoutStage,
        })

        local tojiPieceImages = {
            "rbxassetid://130451097419605",
            "rbxassetid://129030262345273",
            "rbxassetid://76292842640935",
            "rbxassetid://82757811555212",
            "rbxassetid://92910922537368",
            "rbxassetid://105960347086002",
            "rbxassetid://116720305084998",
            "rbxassetid://90341354549871",
            "rbxassetid://72399600208480",
            "rbxassetid://81834484116440",
        }

        local seamOffsets = {
            {x = -1, y = 0},
            {x = 1,  y = 0},
            {x = 0,  y = -1},
            {x = 0,  y = 1},
        }

        for i, imageId in ipairs(tojiPieceImages) do
            for j, offset in ipairs(seamOffsets) do
                new("ImageLabel", {
                    Name = "TojiSeamFill" .. i,
                    ZIndex = 999,
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Position = UDim2.new(0.5, offset.x, 0.5, offset.y),
                    Size = UDim2.new(1, 0, 1, 0),
                    BackgroundTransparency = 1,
                    Image = imageId,
                    ImageColor3 = DARKER_BG,
                    ImageTransparency = 1,
                    ScaleType = Enum.ScaleType.Fit,
                    Parent = TojiCutoutStage,
                })
            end

            new("ImageLabel", {
                Name = "TojiPiece" .. i,
                ZIndex = 1000,
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.new(0.5, 0, 0.5, 0),
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 1,
                Image = imageId,
                ImageColor3 = (_G.Xlu0ThemeColors and _G.Xlu0ThemeColors[_G.Xlu0ThemeName]) or WHITE,
                ImageTransparency = 1,
                ScaleType = Enum.ScaleType.Fit,
                Parent = TojiCutoutStage,
            })

            if i == 2 then
                local shine = new("ImageLabel", {
                    Name = "TojiSwordShine",
                    ZIndex = 1001,
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Position = UDim2.new(0.5, 0, 0.5, 0),
                    Size = UDim2.new(1, 0, 1, 0),
                    BackgroundTransparency = 1,
                    Image = imageId,
                    ImageColor3 = (_G.Xlu0ThemeColors and _G.Xlu0ThemeColors[_G.Xlu0ThemeName]) or WHITE,
                    ImageTransparency = 1,
                    ScaleType = Enum.ScaleType.Fit,
                    Parent = TojiCutoutStage,
                })
                new("UIGradient", {
                    Rotation = -25,
                    Transparency = NumberSequence.new({
                        NumberSequenceKeypoint.new(0, 1, 0),
                        NumberSequenceKeypoint.new(0.5, 0.14, 0),
                        NumberSequenceKeypoint.new(1, 1, 0),
                    }),
                    Parent = shine,
                })
            end

            if i == 6 then
                for k = 1, 4 do
                    new("ImageLabel", {
                        Name = "TojiMovingHandWhiteFill" .. (k > 1 and k or ""),
                        ZIndex = 998,
                        AnchorPoint = Vector2.new(0.5, 0.5),
                        Position = UDim2.new(0.5, seamOffsets[k].x, 0.5, seamOffsets[k].y),
                        Size = UDim2.new(1, 0, 1, 0),
                        BackgroundTransparency = 1,
                        Image = imageId,
                        ImageColor3 = WHITE,
                        ImageTransparency = 1,
                        ScaleType = Enum.ScaleType.Fit,
                        Parent = TojiCutoutStage,
                    })
                end
            end
        end

        local IntroTitle = new("TextLabel", {
            Name = "IntroTitle",
            ZIndex = 1002,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.new(0.5, 0, 0.42, 0),
            Size = UDim2.new(0, 430, 0, 90),
            BackgroundTransparency = 1,
            Text = "FEAR X BLESS",
            TextColor3 = WHITE,
            TextStrokeColor3 = Color3.fromRGB(0, 0, 0),
            TextStrokeTransparency = 0.5,
            Font = Enum.Font.Arcade,
            TextSize = 54,
            TextXAlignment = Enum.TextXAlignment.Center,
            Parent = AdaptIntro,
        })

        local IntroTitleSweep = IntroTitle:Clone()
        IntroTitleSweep.Name = "IntroTitleSweep"
        IntroTitleSweep.TextColor3 = (_G.Xlu0ThemeColors and _G.Xlu0ThemeColors[_G.Xlu0ThemeName]) or WHITE
        IntroTitleSweep.TextTransparency = 0
        IntroTitleSweep.TextStrokeTransparency = 1
        IntroTitleSweep.ZIndex = IntroTitle.ZIndex + 1
        IntroTitleSweep.Parent = AdaptIntro
        _G.Xlu0IntroTitleSweep = IntroTitleSweep

        local IntroSweepGradient = Instance.new("UIGradient")
        IntroSweepGradient.Rotation = 12
        IntroSweepGradient.Offset = Vector2.new(-1.25, 0)
        IntroSweepGradient.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0.00, 1),
            NumberSequenceKeypoint.new(0.42, 1),
            NumberSequenceKeypoint.new(0.50, 0.08),
            NumberSequenceKeypoint.new(0.58, 1),
            NumberSequenceKeypoint.new(1.00, 1)
        })
        IntroSweepGradient.Parent = IntroTitleSweep

        task.spawn(function()
            while IntroTitleSweep and IntroTitleSweep.Parent do
                IntroSweepGradient.Offset = Vector2.new(-1.25, 0)
                local sweepTween = TweenService:Create(
                    IntroSweepGradient,
                    TweenInfo.new(1.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
                    {Offset = Vector2.new(1.25, 0)}
                )
                sweepTween:Play()
                sweepTween.Completed:Wait()
                task.wait(0.8)
            end
        end)

        new("TextLabel", {
            Name = "TapAnywhereShadow",
            ZIndex = 1002,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.new(0.5, 3, 0.42, 61),
            Size = UDim2.new(0, 300, 0, 38),
            BackgroundTransparency = 1,
            Text = "SKIP INTRO",
            TextColor3 = Color3.fromRGB(0, 0, 0),
            TextTransparency = 0.18,
            TextSize = 18,
            Font = Enum.Font.GothamBlack,
            Parent = AdaptIntro,
        })

        local TapAnywhereLabel = new("TextLabel", {
            Name = "TapAnywhere",
            ZIndex = 1003,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.new(0.5, 0, 0.42, 58),
            Size = UDim2.new(0, 300, 0, 38),
            BackgroundTransparency = 1,
            Text = "SKIP INTRO",
            TextColor3 = WHITE,
            TextStrokeColor3 = Color3.fromRGB(0, 0, 0),
            TextStrokeTransparency = 0.45,
            TextSize = 18,
            Font = Enum.Font.GothamBlack,
            Parent = AdaptIntro,
        })

        new("TextLabel", {
            Name = "DiscordInviteShadow",
            ZIndex = 1002,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.new(0.5, 3, 0.42, 85),
            Size = UDim2.new(0, 250, 0, 34),
            BackgroundTransparency = 1,
            Text = "discord.gg/fearhub",
            TextColor3 = Color3.fromRGB(0, 0, 0),
            TextTransparency = 0.2,
            TextSize = 16,
            Font = Enum.Font.GothamBlack,
            Parent = AdaptIntro,
        })

        local DiscordInviteLabel = new("TextLabel", {
            Name = "DiscordInvite",
            ZIndex = 1003,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.new(0.5, 0, 0.42, 82),
            Size = UDim2.new(0, 250, 0, 34),
            BackgroundTransparency = 1,
            Text = "discord.gg/fearhub",
            TextColor3 = WHITE,
            TextStrokeColor3 = Color3.fromRGB(0, 0, 0),
            TextStrokeTransparency = 0.5,
            TextSize = 16,
            Font = Enum.Font.GothamBlack,
            Parent = AdaptIntro,
        })

        -- Device scaling for intro text
        local introTextScaleValue = Xlu0AutoMobile and 0.82 or 1.00
        for _, obj in ipairs({IntroTitle, IntroTitleSweep, TapAnywhereLabel, DiscordInviteLabel}) do
            local sc = Instance.new("UIScale")
            sc.Name = "Xlu0AutoDeviceScale"
            sc.Scale = introTextScaleValue
            sc.Parent = obj
        end
        for _, shadowName in ipairs({"TapAnywhereShadow", "DiscordInviteShadow"}) do
            local sh = AdaptIntro:FindFirstChild(shadowName)
            if sh then
                local sc = Instance.new("UIScale")
                sc.Name = "Xlu0AutoDeviceScale"
                sc.Scale = introTextScaleValue
                sc.Parent = sh
            end
        end

        -- Tap catcher
        local TapCatcher = new("TextButton", {
            Name = "TapCatcher",
            ZIndex = 1004,
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            Text = "",
            AutoButtonColor = false,
            Parent = AdaptIntro,
        })

        local introSkipped = false
        local TapAnywhere = AdaptIntro:FindFirstChild("TapAnywhere")

        local function skipIntro()
            if introSkipped then return end
            introSkipped = true
            stopIntroPlayback()

            _G.Xlu0IntroTitleSweep = nil
            tween(AdaptIntro, 0.4, {BackgroundTransparency = 1})
            for _, child in ipairs(AdaptIntro:GetChildren()) do
                if child:IsA("ImageLabel") then
                    tween(child, 0.3, {ImageTransparency = 1})
                elseif child:IsA("TextLabel") then
                    tween(child, 0.3, {TextTransparency = 1})
                elseif child:IsA("Frame") then
                    tween(child, 0.3, {BackgroundTransparency = 1})
                    for _, sub in ipairs(child:GetDescendants()) do
                        if sub:IsA("ImageLabel") then tween(sub, 0.3, {ImageTransparency = 1}) end
                        if sub:IsA("TextLabel") then tween(sub, 0.3, {TextTransparency = 1}) end
                    end
                end
            end

            task.delay(0.45, function()
                restoreOtherInterfaces()
                Main.Visible = true
                MiniFrame.Visible = false
                Main.Size = UDim2.new(0, 0, 0, 0)
                pcall(function()
                    TweenService:Create(Main, TweenInfo.new(0.7, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = origSize}):Play()
                end)
                if IntroGui then IntroGui:Destroy() end
            end)
        end

        TapCatcher.MouseButton1Click:Connect(skipIntro)

        task.spawn(function()
            task.wait(0.2)
            if introSkipped then return end

            task.wait(0.6)
            if introSkipped then return end

            TojiCutoutStage.Visible = true
            local tojiScale = TojiCutoutStage:FindFirstChild("UIScale")
            if tojiScale then
                tojiScale.Scale = 0.78
                tween(tojiScale, 0.6, {Scale = 1}, Enum.EasingStyle.Back)
            end

            local pieceOffsets = {
                {-42, -26, -10}, {38, -34, 9}, {-34, 18, -7}, {30, 28, 8},
                {-48, 6, -11}, {46, 10, 10}, {-25, 38, -6}, {28, 42, 7},
                {-18, -44, -5}, {20, -38, 5},
            }

            for i = 1, 10 do
                if introSkipped then return end
                local data = pieceOffsets[i]
                local piece = TojiCutoutStage:FindFirstChild("TojiPiece" .. i)

                if piece then
                    piece.Position = UDim2.new(0.5, data[1], 0.5, data[2])
                    piece.Rotation = data[3]
                    piece.ImageTransparency = 1
                    tween(piece, 0.42, {
                        Position = UDim2.new(0.5, 0, 0.5, 0),
                        Rotation = 0,
                        ImageTransparency = 0,
                    }, Enum.EasingStyle.Back)
                end

                for _, child in ipairs(TojiCutoutStage:GetChildren()) do
                    if child.Name == "TojiSeamFill" .. i then
                        child.Position = UDim2.new(0.5, data[1], 0.5, data[2])
                        child.Rotation = data[3]
                        child.ImageTransparency = 1
                        tween(child, 0.42, {
                            Position = UDim2.new(0.5, 0, 0.5, 0),
                            Rotation = 0,
                            ImageTransparency = 0,
                        }, Enum.EasingStyle.Back)
                    end
                end
                task.wait(0.065)
            end

            tween(tojiScale, 0.16, {Scale = 1.06}, Enum.EasingStyle.Quad)
            task.wait(0.16)
            tween(tojiScale, 0.24, {Scale = 1}, Enum.EasingStyle.Back)

            task.spawn(function()
                while not introSkipped and TojiCutoutStage.Parent do
                    tween(TojiCutoutStage, 1.15, {
                        Rotation = 0.8,
                        Position = UDim2.new(0.5, 0, 0.5, -5),
                    }, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
                    task.wait(1.15)
                    if introSkipped or not TojiCutoutStage.Parent then return end
                    tween(TojiCutoutStage, 1.15, {
                        Rotation = -0.8,
                        Position = UDim2.new(0.5, 0, 0.5, 5),
                    }, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
                    task.wait(1.15)
                end
            end)

            task.wait(0.3)
            if introSkipped then return end

            local shine = TojiCutoutStage:FindFirstChild("TojiSwordShine")
            if shine then
                tween(shine, 0.4, {ImageTransparency = 0.2})
                task.wait(0.3)
                if not introSkipped then
                    tween(shine, 0.3, {ImageTransparency = 0.7})
                end
            end

            task.wait(0.5)
            if introSkipped then return end

            task.spawn(function()
                while not introSkipped do
                    tween(TapAnywhere, 0.8, {TextTransparency = 0.5})
                    task.wait(0.8)
                    if introSkipped then return end
                    tween(TapAnywhere, 0.8, {TextTransparency = 0})
                    task.wait(0.8)
                end
            end)

            task.wait(6)
            if not introSkipped then skipIntro() end
        end)
    end)
end

_G.__Xlu0DuelsRunIntro()