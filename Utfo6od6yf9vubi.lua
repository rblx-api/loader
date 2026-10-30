do
    local _ge = (type(getgenv) == "function" and getgenv()) or _G
    local _seen = {}
    for _, env in ipairs({ _G, _ge }) do
        local fn = env.__LustUninstall
        if type(fn) == "function" and not _seen[fn] then
            _seen[fn] = true
            pcall(fn)
        end
    end
end
_G.__LustConns = {}
_LustOn = function(signal, fn)
    local c = signal:Connect(fn)
    local t = _G.__LustConns
    if #t > 400 then
        for i = #t, 1, -1 do if not t[i].Connected then table.remove(t, i) end end
    end
    t[#t + 1] = c
    return c
end
_G.LustRunning = false
_G.__LustMainOriginalPos = nil
_G.__LustDropInProgress = false
_G.IsDropping = false

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local TS = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local HS = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local RFT_EXCLUDE =
    (Enum.RaycastFilterType and Enum.RaycastFilterType.Exclude)
    or (Enum.RaycastFilterType and Enum.RaycastFilterType.Blacklist)

local LP = Players.LocalPlayer
if not LP then
    local _lpConn
    _lpConn = _LustOn(Players.PlayerAdded, function(p) LP = p end)
    local _t0 = tick()
    while not LP and tick() - _t0 < 15 do task.wait(0.1) end
    if _lpConn then _lpConn:Disconnect() end
end
if not LP then return end

local pgui = LP:WaitForChild("PlayerGui", 20)
if not pgui then return end

local camera = Workspace.CurrentCamera
_G.LustRunning = true
_G.LustSession = (_G.LustSession or 0) + 1
local _LUST_GE = (type(getgenv) == "function" and getgenv()) or _G
_LUST_GE.__LustSessionId = (_LUST_GE.__LustSessionId or 0) + 1
local _MY_SESSION = _LUST_GE.__LustSessionId
local function _lustSessionAlive() return _LUST_GE.__LustSessionId == _MY_SESSION end
_lustBootDone = false

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

local CoreGui = game:GetService("CoreGui")

-- ===========================================================================
-- [FIX B] Limpieza de GUIs propios SOLO por nombre exacto.
-- Antes se destruía cualquier ScreenGui/BillboardGui cuyo nombre empezara con
-- "lust" (l:sub(1,4)=="lust"), lo cual mataba scripts externos como
-- "Lust Bypass" de otros módulos. Ahora solo borra nombres propios exactos.
-- ===========================================================================
do
    local NAMES = {
        ["lust hub"]           = true,
        ["lustmobilepanel"]    = true,
        ["instaresetbutton"]   = true,
        ["lustesp"]            = true,
        ["lustespline"]        = true,
        ["lustspeedindicator"] = true,
        ["lustbooterrors"]     = true,
    }

    local function nuke(parent)
        if not parent then return end
        local okc, kids = pcall(function() return parent:GetChildren() end)
        if not okc then return end
        for _, o in ipairs(kids) do
            local okn, nm = pcall(function() return o.Name end)
            if okn and type(nm) == "string" then
                if NAMES[nm:lower()] and (o:IsA("ScreenGui") or o:IsA("BillboardGui")) then
                    pcall(function() o:Destroy() end)
                end
            end
        end
    end

    nuke(CoreGui)
    nuke(pgui)
    if type(gethui) == "function" then
        local okh, hui = pcall(gethui)
        if okh then nuke(hui) end
    end
end

LUST_LANGUAGE = "en"
LUST_TRANSLATIONS = {
    es = { ["RESET ALL SETTINGS"]="RESTABLECER TODO", ["SETTINGS RESET"]="AJUSTES RESTABLECIDOS", ["CONFIRM?"]="¿CONFIRMAR?", ["ERROR"]="ERROR", ["Reset All Keybinds"]="RESTABLECER TECLAS", ["RESET"]="RESTABLECER", ["Keybinds"]="TECLAS", ["Carry Mode"]="MODO CARGAR", ["Lagger Mode"]="MODO LAG", ["Auto Left"]="AUTO IZQUIERDA", ["Auto Right"]="AUTO DERECHA", ["Auto Bat"]="AUTO BATE", ["Insta Reset"]="REINICIO RÁPIDO", ["TP Down"]="TP ABAJO", ["Drop Brainrot"]="SOLTAR BRAINROT", ["Normal Speed"]="VELOCIDAD NORMAL", ["Carry Speed"]="VELOCIDAD CARGAR", ["Current Mode"]="MODO ACTUAL", ["ACTIVATE"]="ACTIVAR", ["Pause Mode"]="MODO PAUSA", ["Steal"]="ROBO" },
    pt = { ["RESET ALL SETTINGS"]="REDEFINIR TUDO", ["SETTINGS RESET"]="CONFIGURAÇÕES REDEFINIDAS", ["CONFIRM?"]="CONFIRMAR?", ["ERROR"]="ERRO", ["Reset All Keybinds"]="REDEFINIR TECLAS", ["RESET"]="REDEFINIR", ["Keybinds"]="TECLAS", ["Carry Mode"]="MODO CARREGAR", ["Auto Left"]="AUTO ESQUERDA", ["Auto Right"]="AUTO DIREITA", ["Normal Speed"]="VELOCIDADE NORMAL", ["Carry Speed"]="VELOCIDADE CARREGAR", ["ACTIVATE"]="ATIVAR", ["Pause Mode"]="MODO PAUSA", ["Steal"]="ROUBO" },
    fr = { ["RESET ALL SETTINGS"]="RÉINITIALISER", ["SETTINGS RESET"]="PARAMÈTRES RÉINITIALISÉS", ["CONFIRM?"]="CONFIRMER ?", ["ERROR"]="ERREUR", ["Reset All Keybinds"]="RÉINITIALISER LES TOUCHES", ["RESET"]="RÉINITIALISER", ["Keybinds"]="RACCOURCIS", ["Carry Mode"]="MODE PORTER", ["Auto Left"]="AUTO GAUCHE", ["Auto Right"]="AUTO DROITE", ["Normal Speed"]="VITESSE NORMALE", ["Carry Speed"]="VITESSE PORTER", ["ACTIVATE"]="ACTIVER", ["Pause Mode"]="MODE PAUSE", ["Steal"]="VOL" },
    de = { ["RESET ALL SETTINGS"]="ALLES ZURÜCKSETZEN", ["SETTINGS RESET"]="EINSTELLUNGEN ZURÜCKGESETZT", ["CONFIRM?"]="BESTÄTIGEN?", ["ERROR"]="FEHLER", ["Reset All Keybinds"]="TASTEN ZURÜCKSETZEN", ["RESET"]="ZURÜCKSETZEN", ["Keybinds"]="TASTEN", ["Carry Mode"]="TRAGEMODUS", ["Auto Left"]="AUTO LINKS", ["Auto Right"]="AUTO RECHTS", ["Normal Speed"]="NORMALE GESCHWINDIGKEIT", ["Carry Speed"]="TRAGEGESCHWINDIGKEIT", ["ACTIVATE"]="AKTIVIEREN", ["Pause Mode"]="PAUSENMODUS", ["Steal"]="STEHLEN" },
}

function localizeLustInterface(root)
    local dictionary = LUST_TRANSLATIONS[LUST_LANGUAGE]
    if not dictionary or not root then return end
    for _, object in ipairs(root:GetDescendants()) do
        if object:IsA("TextLabel") or object:IsA("TextButton") then
            local source = object:GetAttribute("LustSourceText") or object.Text
            object:SetAttribute("LustSourceText", source)
            local translated = dictionary[source]
            if translated then object.Text = translated end
        end
    end
end

function lustTranslate(source)
    local dictionary = LUST_TRANSLATIONS[LUST_LANGUAGE]
    return (dictionary and dictionary[source]) or source
end

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

function waitForCharReady(char, timeout)
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
AIMBOT_LAGGER_SPEED = 30
CONFIG_FILE = "Lust_" .. tostring(LP.UserId) .. "_v8.json"
LUST_CONFIG_VERSION = 8
_isDraggingButton = false

floatingButtonScale = 1
_floatingUIScales = {}

COLOR_THEMES = {
    ["White"]   = Color3.fromRGB(245, 245, 252),
    ["Gray"]    = Color3.fromRGB(180, 180, 190),
    ["Purple"]  = Color3.fromRGB(160, 100, 220),
    ["Blue"]    = Color3.fromRGB(80, 150, 255),
    ["Green"]   = Color3.fromRGB(80, 220, 120),
    ["Vanilla"] = Color3.fromRGB(212, 180, 135),
}
currentColorTheme = "White"
selectedColor = COLOR_THEMES["White"]

function getThemeColor() return selectedColor end

function lustGradient(c)
    return ColorSequence.new({
        ColorSequenceKeypoint.new(0.00, c:Lerp(Color3.fromRGB(100,100,110), 0.40)),
        ColorSequenceKeypoint.new(0.45, c),
        ColorSequenceKeypoint.new(1.00, c:Lerp(Color3.fromRGB(50,50,60), 0.35)),
    })
end

function applyLustGradientToLabel(label, c)
    if not label then return end
    local grad = label:FindFirstChildOfClass("UIGradient")
    if not grad then grad = Instance.new("UIGradient", label) end
    grad.Rotation = 0
    grad.Color = lustGradient(c)
end

_lastThemeUpdate = 0
_lastThemeColor = nil

function updateAllUIThemeColors(color)
    local now = _tick()
    if color == _lastThemeColor and now - _lastThemeUpdate < 0.1 then return end
    _lastThemeUpdate = now
    _lastThemeColor = color
    if progressFill then
        progressFill.BackgroundColor3 = color
        local grad = progressFill:FindFirstChild("LustStealFillGradient") or progressFill:FindFirstChildOfClass("UIGradient")
        if grad then
            local dark = color:Lerp(Color3.new(0,0,0), 0.55)
            local light = color:Lerp(Color3.new(1,1,1), 0.34)
            grad.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0.00, dark),
                ColorSequenceKeypoint.new(0.38, color),
                ColorSequenceKeypoint.new(0.68, light),
                ColorSequenceKeypoint.new(1.00, dark),
            })
            grad.Rotation = -10
        end
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
    for _, tab in ipairs(tabButtons or {}) do
        local ul = tab:FindFirstChild("Underline")
        local isActive = ul and ul.Visible
        tab.BackgroundTransparency = 1
        tab.TextColor3 = isActive and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(122, 122, 130)
        if ul then ul.BackgroundColor3 = color end
    end
    if _G.__LustRefreshESPTheme then pcall(_G.__LustRefreshESPTheme, color) end
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
    if miniBtn then
        local logo = miniBtn:FindFirstChild("MinLogo")
        if logo then
            logo.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            logo.BackgroundTransparency = 0
        end
        local glow = miniBtn:FindFirstChild("MinGlow")
        if glow then glow.Color = lustGradient(color) end
    end
    if MobilePanel then
        for _, btn in ipairs(MobilePanel:GetChildren()) do
            if btn:IsA("TextButton") then
                local isActive = btn:GetAttribute("MobActive") == true
                local bg     = btn:FindFirstChild("BtnBG", true)
                local glow   = btn:FindFirstChild("BtnGlow", true)
                local shine  = btn:FindFirstChild("BtnShine", true)
                local stroke = btn:FindFirstChildOfClass("UIStroke")
                local label  = btn:FindFirstChild("BtnLabel", true)
                local tint = Color3.fromRGB(255, 255, 255)
                if bg then
                    bg.BackgroundColor3 = tint
                    bg.BackgroundTransparency = 0
                    bg.ImageColor3 = isActive and tint:Lerp(Color3.new(0,0,0), 0.82) or tint
                end
                if glow then
                    glow.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                    glow.BackgroundTransparency = isActive and 0 or 1
                    glow.ImageTransparency = 1
                end
                if shine then
                    shine.Enabled = isActive
                    shine.Rotation = 90
                end
                if stroke then stroke.Transparency = 1 end
                if label then
                    if isActive then
                        label.TextColor3 = Color3.fromRGB(20, 20, 30)
                    else
                        label.TextColor3 = Color3.fromRGB(255, 255, 255)
                    end
                end
            end
        end
    end
end

TAG = "LocalOutfit_"

function loadObjects(id)
    local ok, res = pcall(function() return game:GetObjects("rbxassetid://" .. tostring(id)) end)
    if ok and typeof(res) == "table" and #res > 0 then return res end
    ok, res = pcall(function() return game:GetService("InsertService"):LoadAsset(id) end)
    if ok and res then return { res } end
    return nil
end

_originalAppearance = nil

function captureOriginalAppearance(char)
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
            data.headMesh = sm.MeshId
            data.headTexture = sm.TextureId
        end
    end
    _originalAppearance = data
end

LUST_OUTFIT_PRESETS = {
    LUST = { 10928435480, 6913613757, 9683332649 },
    RED = {
        107377896731216, 215718515, 82831174733357, 122851471549264,
        139051312584295, 124572458012582, 105029428205930,
    },
    BLUE = { 76059443, 74891470, 1180433861, 8781331764, 8682542843 },
    GALAXY = {
        82831174733357, 139051312584295, 107062966543626, 71184246276344,
        111383282415116, 78289009309744, 71017311084699,
    },
}
LUST_OUTFIT_BUNDLES = { 263995361762992 }
_lustOutfitBackup = nil
_lustOutfitBackupChar = nil
_lustBundleCache = {}

function _lustOutfitAssetList(presetName)
    local preset = LUST_OUTFIT_PRESETS[presetName or "LUST"] or LUST_OUTFIT_PRESETS.LUST
    local list = {}
    for _, id in ipairs(preset) do list[#list + 1] = id end
    for _, bid in ipairs(LUST_OUTFIT_BUNDLES) do
        local items = _lustBundleCache[bid]
        if not items then
            items = {}
            local ok, res = pcall(function() return game:GetService("AssetService"):GetBundleDetailsAsync(bid) end)
            if ok and res and type(res.Items) == "table" then
                for _, it in ipairs(res.Items) do
                    if it.Type == "Asset" and tonumber(it.Id) then items[#items + 1] = tonumber(it.Id) end
                end
            end
            _lustBundleCache[bid] = items
        end
        for _, id in ipairs(items) do list[#list + 1] = id end
    end
    return list
end

function _lustSetHead(char, hidden)
    local head = char and char:FindFirstChild("Head")
    if not head then return end
    local t = hidden and 1 or 0
    head.Transparency = t
    head.LocalTransparencyModifier = t
    for _, c in ipairs(head:GetChildren()) do
        if c:IsA("Decal") or c:IsA("Texture") or c:IsA("BasePart") then
            c.Transparency = t
            if c:IsA("BasePart") then c.LocalTransparencyModifier = t end
        end
    end
end

function _lustRestoreLeg(char)
    if not char then return end
    local k = char:FindFirstChild("LustKorblox_RightLeg")
    if k then pcall(function() k:Destroy() end) end
    for _, n in ipairs({"RightUpperLeg", "RightLowerLeg", "RightFoot"}) do
        local l = char:FindFirstChild(n)
        if l and l:IsA("BasePart") then l.Transparency = 0; l.LocalTransparencyModifier = 0 end
    end
end

function _lustClearOutfit(char)
    if not char then return end
    local wasApplied = char:GetAttribute("LustOutfit") == true
    for _, c in ipairs(char:GetChildren()) do
        if c:GetAttribute("LustSkin") then pcall(function() c:Destroy() end) end
    end
    if not wasApplied then return end
    char:SetAttribute("LustOutfit", nil)
    _lustSetHead(char, false)
    _lustRestoreLeg(char)
    if _lustOutfitBackup and _lustOutfitBackupChar == char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        for _, obj in ipairs(_lustOutfitBackup) do
            local c = obj:Clone()
            if c:IsA("Accessory") and hum then
                pcall(function() hum:AddAccessory(c) end)
                if c.Parent ~= char then c.Parent = char end
            else
                for _, ch in ipairs(char:GetChildren()) do
                    if ch.ClassName == c.ClassName and not ch:IsA("Accessory") then ch:Destroy() end
                end
                c.Parent = char
            end
        end
    end
    _lustOutfitBackup = nil
    _lustOutfitBackupChar = nil
end

function _lustAttachAccessory(char, hum, acc)
    acc:SetAttribute("LustSkin", true)
    pcall(function() hum:AddAccessory(acc) end)
    if acc.Parent ~= char then acc.Parent = char end
    local handle = acc:FindFirstChild("Handle")
    if not handle or not handle:IsA("BasePart") or handle:FindFirstChild("AccessoryWeld") then return end
    local att = handle:FindFirstChildWhichIsA("Attachment")
    if not att then return end
    local body
    for _, d in ipairs(char:GetDescendants()) do
        if d:IsA("Attachment") and d.Name == att.Name and not d:IsDescendantOf(acc) then body = d; break end
    end
    local part = body and body.Parent
    if part and part:IsA("BasePart") then
        handle.Anchored = false; handle.CanCollide = false; handle.CanTouch = false
        handle.CanQuery = false; handle.Massless = true
        handle.CFrame = part.CFrame * body.CFrame * att.CFrame:Inverse()
        local w = Instance.new("WeldConstraint")
        w.Name = "LustAccessoryWeld"
        w.Part0 = part; w.Part1 = handle; w.Parent = handle
    end
end

function applyLustOutfit(char, presetName)
    if not char then char = LP.Character end
    if not char then return end
    local hum = char:WaitForChild("Humanoid", 10)
    char:WaitForChild("Head", 10)
    if not hum then return end
    if _lustOutfitBackupChar ~= char then
        _lustOutfitBackup = {}
        _lustOutfitBackupChar = char
        for _, c in ipairs(char:GetChildren()) do
            if (c:IsA("Accessory") or c:IsA("Shirt") or c:IsA("Pants") or c:IsA("ShirtGraphic")) and not c:GetAttribute("LustSkin") then
                local ok, cl = pcall(function() return c:Clone() end)
                if ok and cl then _lustOutfitBackup[#_lustOutfitBackup + 1] = cl end
            end
        end
    end
    for _, c in ipairs(char:GetChildren()) do
        if (c:IsA("Accessory") or c:IsA("Shirt") or c:IsA("Pants") or c:IsA("ShirtGraphic")) and not c:GetAttribute("LustSkin") then
            c.Parent = nil
        end
    end
    char:SetAttribute("LustOutfit", true)
    for _, id in ipairs(_lustOutfitAssetList(presetName)) do
        local objs = loadObjects(id)
        if objs then
            for _, o in ipairs(objs) do
                local found = {}
                if o:IsA("Accessory") or o:IsA("Shirt") or o:IsA("Pants") or o:IsA("ShirtGraphic") then
                    found[1] = o
                else
                    for _, d in ipairs(o:GetDescendants()) do
                        if d:IsA("Accessory") or d:IsA("Shirt") or d:IsA("Pants") or d:IsA("ShirtGraphic") then found[#found + 1] = d end
                    end
                end
                for _, item in ipairs(found) do
                    local cl = item:Clone()
                    cl:SetAttribute("LustSkin", true)
                    if cl:IsA("Accessory") then
                        _lustAttachAccessory(char, hum, cl)
                    else
                        for _, ch in ipairs(char:GetChildren()) do
                            if ch.ClassName == cl.ClassName then ch:Destroy() end
                        end
                        cl.Parent = char
                    end
                end
                pcall(function() o:Destroy() end)
            end
        end
    end
    _lustSetHead(char, true)
    local ru = char:FindFirstChild("RightUpperLeg")
    if ru then
        local ok, res = pcall(function() return game:GetObjects("rbxassetid://139607718") end)
        if ok and res and res[1] then
            local k = res[1]
            k.Name = "LustKorblox_RightLeg"
            k:SetAttribute("LustSkin", true)
            local bp = k:IsA("BasePart") and k or k:FindFirstChildWhichIsA("BasePart", true)
            if bp then
                for _, n in ipairs({"RightUpperLeg", "RightLowerLeg", "RightFoot"}) do
                    local l = char:FindFirstChild(n)
                    if l and l:IsA("BasePart") then l.Transparency = 1; l.LocalTransparencyModifier = 1 end
                end
                bp.Anchored = false; bp.CanCollide = false; bp.CanTouch = false
                bp.CanQuery = false; bp.Massless = true
                bp.CFrame = ru.CFrame
                local w = Instance.new("WeldConstraint")
                w.Name = "LustKorbloxWeld"
                w.Part0 = ru; w.Part1 = bp; w.Parent = bp
                k.Parent = char
            else
                k:Destroy()
            end
        end
    end
end

-- ═══════════════════════════════════════════════════════════════════
-- STRIP / RESTORE DE ACCESORIOS PARA OUTFITS ESTÁNDAR
-- ═══════════════════════════════════════════════════════════════════
_standardOutfitBackup = nil
_standardOutfitBackupChar = nil

function _stripStandardAccessories(char)
    if not char then return end
    if _standardOutfitBackupChar ~= char then
        _standardOutfitBackup = {}
        _standardOutfitBackupChar = char
        for _, c in ipairs(char:GetChildren()) do
            if (c:IsA("Accessory") or c:IsA("ShirtGraphic") or c:IsA("HairAccessory") or c:IsA("Hat"))
                and not c:GetAttribute("LustStandardOutfit") then
                local ok, cl = pcall(function() return c:Clone() end)
                if ok and cl then _standardOutfitBackup[#_standardOutfitBackup + 1] = cl end
            end
        end
    end
    for _, c in ipairs(char:GetChildren()) do
        if (c:IsA("Accessory") or c:IsA("ShirtGraphic"))
            and not c:GetAttribute("LustStandardOutfit") then
            c.Parent = nil
        end
    end
    local head = char:FindFirstChild("Head")
    if head then
        local face = head:FindFirstChild("face")
        if face then
            if face:GetAttribute("LustStandardFaceOrig") == nil then
                face:SetAttribute("LustStandardFaceOrig", face.Transparency)
            end
            face.Transparency = 1
        end
    end
end

function _restoreStandardAccessories(char)
    if not char then return end
    local head = char:FindFirstChild("Head")
    if head then
        local face = head:FindFirstChild("face")
        if face and face:GetAttribute("LustStandardFaceOrig") ~= nil then
            face.Transparency = face:GetAttribute("LustStandardFaceOrig")
            face:SetAttribute("LustStandardFaceOrig", nil)
        end
    end
    for _, c in ipairs(char:GetChildren()) do
        if c:GetAttribute("LustStandardOutfit") then pcall(function() c:Destroy() end) end
    end
    if _standardOutfitBackup and _standardOutfitBackupChar == char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        for _, obj in ipairs(_standardOutfitBackup) do
            local c = obj:Clone()
            if c:IsA("Accessory") and hum then
                pcall(function() hum:AddAccessory(c) end)
                if c.Parent ~= char then c.Parent = char end
            else
                c.Parent = char
            end
        end
    end
    _standardOutfitBackup = nil
    _standardOutfitBackupChar = nil
end

function clearPreviousOutfitAssets(char)
    if not char then return end
    pcall(_restoreStandardAccessories, char)
    pcall(_lustClearOutfit, char)
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
            local o1 = part:GetAttribute("LustOutfitOriginalTransparency")
            if o1 ~= nil then
                part.Transparency = o1
                part:SetAttribute("LustOutfitOriginalTransparency", nil)
            end
            local o2 = part:GetAttribute("LustOutfitOriginalLocalTransparency")
            if o2 ~= nil then
                part.LocalTransparencyModifier = o2
                part:SetAttribute("LustOutfitOriginalLocalTransparency", nil)
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
    if head and head:IsA("MeshPart") and head:GetAttribute("LustOutfitModifiedMeshPart") then
        pcall(function()
            head.MeshId = head:GetAttribute("LustOutfitOriginalMeshId") or ""
            head.TextureID = head:GetAttribute("LustOutfitOriginalTextureId") or ""
        end)
        head:SetAttribute("LustOutfitModifiedMeshPart", nil)
        head:SetAttribute("LustOutfitOriginalMeshId", nil)
        head:SetAttribute("LustOutfitOriginalTextureId", nil)
    elseif head then
        local specialMesh = head:FindFirstChildWhichIsA("SpecialMesh")
        if specialMesh and specialMesh:GetAttribute("LustOutfitCreatedMesh") then
            specialMesh:Destroy()
        elseif specialMesh and specialMesh:GetAttribute("LustOutfitModifiedMesh") then
            specialMesh.MeshId = specialMesh:GetAttribute("LustOutfitOriginalMeshId") or ""
            specialMesh.TextureId = specialMesh:GetAttribute("LustOutfitOriginalTextureId") or ""
            specialMesh:SetAttribute("LustOutfitModifiedMesh", nil)
            specialMesh:SetAttribute("LustOutfitOriginalMeshId", nil)
            specialMesh:SetAttribute("LustOutfitOriginalTextureId", nil)
        end
    end
end

function applyNoOutfit(char)
    if not char then char = LP.Character end
    if not char then return end
    pcall(_restoreStandardAccessories, char)
    for _, d in ipairs(char:GetChildren()) do
        if d.Name:sub(1, #TAG) == TAG then pcall(function() d:Destroy() end) end
    end
    local oldAcc = char:FindFirstChild("AuFfitAccessory"); if oldAcc then pcall(function() oldAcc:Destroy() end) end
    local oldKorblox = char:FindFirstChild("Korblox_RightLeg"); if oldKorblox then pcall(function() oldKorblox:Destroy() end) end
    for _, d in ipairs(char:GetChildren()) do
        if d:IsA("CharacterMesh") and d.BodyPart == Enum.BodyPart.Head then
            pcall(function() d:Destroy() end)
        end
    end
    local head = char:FindFirstChild("Head")
    if head then
        head.Transparency = 0; head.CanCollide = true; head.LocalTransparencyModifier = 0
        local face = head:FindFirstChild("face"); if face then face.Transparency = 0 end
        local sm = head:FindFirstChildWhichIsA("SpecialMesh")
        if sm then
            if _originalAppearance and _originalAppearance.headMesh then
                sm.MeshId = _originalAppearance.headMesh
                sm.TextureId = _originalAppearance.headTexture or ""
            else pcall(function() sm:Destroy() end) end
        end
    end
    pcall(function()
        local neck = char:FindFirstChild("Neck"); if neck then neck.Enabled = true end
    end)
    for _, partName in ipairs({"RightUpperLeg", "RightLowerLeg", "RightFoot"}) do
        local limb = char:FindFirstChild(partName); if limb then limb.Transparency = 0 end
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
            local h = a:FindFirstChild("Handle"); if h then h.Transparency = 0 end
        end
    end
end

OUTFITS = {
    { label = "OFF", customApply = applyNoOutfit },
    { accessory = 10159600649,     offset = _V3new(0, 1, -0.2),   shirt = "http://www.roblox.com/asset/?id=9683332638",     pants = "http://www.roblox.com/asset/?id=93182020184041", headMesh = "http://www.roblox.com/asset/?id=134079402", headTexture = "http://www.roblox.com/asset/?id=133940918", korblox = "none", label = "SHADOW",   headlessKorblox = true },
    { accessory = 1744060292,      offset = _V3new(0, 1.3, -0.2), shirt = "http://www.roblox.com/asset/?id=9683332638",     pants = "http://www.roblox.com/asset/?id=93182020184041", headMesh = "http://www.roblox.com/asset/?id=134079402", headTexture = "http://www.roblox.com/asset/?id=133940918", korblox = "none", label = "CRIMSON",  headlessKorblox = true },
    { accessory = 8349240186,      offset = _V3new(0, 0.9, 0),    shirt = "http://www.roblox.com/asset/?id=11926549070",    pants = "http://www.roblox.com/asset/?id=13189494471",    headMesh = "https://assetdelivery.roblox.com/v1/asset/?id=16673245747", headTexture = nil, korblox = "none", label = "MIDNIGHT", headlessKorblox = true },
    { accessory = 121097973925756, offset = _V3new(0, 0.9, 0),    shirt = "http://www.roblox.com/asset/?id=123181702116947", pants = "http://www.roblox.com/asset/?id=93330291631062", headMesh = "http://www.roblox.com/asset/?id=134079402", headTexture = "http://www.roblox.com/asset/?id=133940918", korblox = "none", label = "OBSIDIAN", headlessKorblox = true },
    { label = "PHANTOM", customApply = function(c) applyLustOutfit(c, "LUST")  end },
    { label = "COSMIC",  customApply = function(c) applyLustOutfit(c, "GALAXY") end },
}
currentOutfitIndex = 1
outfitSelectorLabel = nil

function loadObjectsStd(id)
    local ok, res = pcall(function() return game:GetObjects("rbxassetid://" .. tostring(id)) end)
    if ok and typeof(res) == "table" and #res > 0 then return res end
    ok, res = pcall(function() return game:GetService("InsertService"):LoadAsset(id) end)
    if ok and res then return {res} end
    return nil
end

function applyHeadlessKorblox(char)
    if not char then return end
    pcall(function() LP.CharacterAvatarType = Enum.AvatarType.R6 end)
    local head = char:FindFirstChild("Head")
    if head then
        if head:GetAttribute("LustOutfitOriginalTransparency") == nil then
            head:SetAttribute("LustOutfitOriginalTransparency", head.Transparency)
            head:SetAttribute("LustOutfitOriginalLocalTransparency", head.LocalTransparencyModifier)
        end
        head.Transparency = 1; head.CanCollide = false; head.LocalTransparencyModifier = 1
        local face = head:FindFirstChild("face"); if face then face.Transparency = 1 end
    end
    pcall(function()
        local neck = char:FindFirstChild("Neck"); if neck then neck.Enabled = false end
    end)
    for _, v in pairs(char:GetChildren()) do
        if v:IsA("Accessory") then
            local w = v:FindFirstChildWhichIsA("Weld") or v:FindFirstChildWhichIsA("WeldConstraint") or v:FindFirstChildWhichIsA("Motor6D")
            if w then
                local p0, p1 = w.Part0, w.Part1
                if (p0 and p0.Name == "Head") or (p1 and p1.Name == "Head") then
                    for _, part in ipairs(v:GetDescendants()) do
                        if part:IsA("BasePart") then
                            if part:GetAttribute("LustOutfitOriginalTransparency") == nil then
                                part:SetAttribute("LustOutfitOriginalTransparency", part.Transparency)
                                part:SetAttribute("LustOutfitOriginalLocalTransparency", part.LocalTransparencyModifier)
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
        local oldAsset = char:FindFirstChild("Korblox_RightLeg"); if oldAsset then oldAsset:Destroy() end
        for _, partName in ipairs(rightLegConfig.partsToHide) do
            local limb = char:FindFirstChild(partName)
            if limb and limb:IsA("BasePart") then
                if limb:GetAttribute("LustOutfitOriginalTransparency") == nil then
                    limb:SetAttribute("LustOutfitOriginalTransparency", limb.Transparency)
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
                weld.Part0 = targetPart; weld.Part1 = mainMesh; weld.Parent = mainMesh
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
    _stripStandardAccessories(char)
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
            if not head:GetAttribute("LustOutfitModifiedMeshPart") then
                head:SetAttribute("LustOutfitOriginalMeshId", head.MeshId)
                head:SetAttribute("LustOutfitOriginalTextureId", head.TextureID)
                head:SetAttribute("LustOutfitModifiedMeshPart", true)
            end
            head.MeshId = cfg.headMesh
            head.TextureID = cfg.headTexture or ""
        end)
    end
    if not done then
        local sm = head:FindFirstChildWhichIsA("SpecialMesh")
        if not sm then
            sm = Instance.new("SpecialMesh")
            sm:SetAttribute("LustOutfitCreatedMesh", true)
        elseif not sm:GetAttribute("LustOutfitModifiedMesh") then
            sm:SetAttribute("LustOutfitOriginalMeshId", sm.MeshId)
            sm:SetAttribute("LustOutfitOriginalTextureId", sm.TextureId)
            sm:SetAttribute("LustOutfitModifiedMesh", true)
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
    local old = char:FindFirstChild("AuFfitAccessory"); if old then old:Destroy() end
    if cfg.accessory and head then
        local objs = loadObjectsStd(cfg.accessory)
        if objs then
            local handle
            for _, o in ipairs(objs) do
                if o:IsA("BasePart") then handle = o; break end
                local f = o:FindFirstChildWhichIsA("BasePart", true); if f then handle = f; break end
            end
            if handle then
                local h = handle:Clone()
                h.Name = "AuFfitAccessory"; h.CanCollide = false; h.Anchored = false; h.Massless = true
                h.Parent = char
                local weld = Instance.new("Weld")
                weld.Part0 = head; weld.Part1 = h
                weld.C0 = _CFnew(cfg.offset); weld.Parent = h
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
                head2.Transparency = 0; head2.CanCollide = true; head2.LocalTransparencyModifier = 0
                local face2 = head2:FindFirstChild("face"); if face2 then face2.Transparency = 0 end
            end
            pcall(function()
                local neck = char:FindFirstChild("Neck"); if neck then neck.Enabled = true end
            end)
            for _, partName in ipairs({"RightUpperLeg", "RightLowerLeg", "RightFoot"}) do
                local limb = char:FindFirstChild(partName); if limb then limb.Transparency = 0 end
            end
            local oldKorblox = char:FindFirstChild("Korblox_RightLeg"); if oldKorblox then oldKorblox:Destroy() end
        end
    end
    if outfitSelectorLabel then outfitSelectorLabel.Text = cfg.label end
end

speedMode = false
autoCarryEnabled = false
autoCarryMode = "Normal"
antiRagdollMode = "off"
antiDieEnabled = false
jumpEnabled = false
laggerToggled = false
laggerCarryToggled = false
medusaCounterEnabled = false
batCounterEnabled = false
unwalkEnabled = false
autoPlayEnabled = false
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

saturationEnabled = false
_colorCorrectionEffect = nil
setSaturationVisual = nil

hideButtonsEnabled = false
setHideButtonsVisual = nil
hideButtonFlags = {}
savedMainMenuPos = nil

bodyLockEnabled = false
bodyLockRange = 20
bodyLockRangeBox = nil
_bodyLockConn = nil
_blSuppressCount = 0
_blWasEnabled = false
_blRestoreTimer = nil
_blSmoothRestore = false

mirrorTPEnabled = false
mirrorTPSetVisual = nil

savedProgressBarPos = nil
savedButtonPositions = {}
savedMobilePanelPos = nil
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

_G.__LustInfJumpEnabled = false
_G._LustInfJumpMode = "HOLD"

do
    _LustOn(UIS.JumpRequest, function()
        if not _G.__LustInfJumpEnabled then return end
        local char = LP.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if not root then return end
        local vel = root.Velocity
        root.Velocity = Vector3.new(vel.X, 55, vel.Z)
    end)

    _LustOn(UIS.InputBegan, function(input)
        if input.UserInputType ~= Enum.UserInputType.Keyboard then return end
        if input.KeyCode ~= Enum.KeyCode.Space then return end
        if UIS:GetFocusedTextBox() then return end
        task.delay(0.2, function()
            if _G.__LustInfJumpEnabled and UIS:IsKeyDown(Enum.KeyCode.Space) then
                local char = LP.Character
                local root = char and char:FindFirstChild("HumanoidRootPart")
                if root then
                    local vel = root.Velocity
                    root.Velocity = Vector3.new(vel.X, 50, vel.Z)
                end
            end
        end)
    end)

    _LustOn(RunService.Heartbeat, function()
        if not _G.__LustInfJumpEnabled then return end
        if _G._LustInfJumpMode ~= "HOLD" then return end
        local char = LP.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if not root then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if (UIS:IsKeyDown(Enum.KeyCode.Space) or (hum and hum.Jump == true)) and root.Velocity.Y < 30 then
            local vel = root.Velocity
            root.Velocity = Vector3.new(vel.X, 50, vel.Z)
        end
        if root.Velocity.Y < -120 then
            local vel = root.Velocity
            root.Velocity = Vector3.new(vel.X, -40, vel.Z)
        end
    end)
end

InfiniteJump = {
    enabled = false,
    jumpPower = 55,
    minVelocity = 30,
    fallClamp = -40,
    jumpConn = nil,
    heartbeatConn = nil,
}
function InfiniteJump.start()
    if _G.__LustInfJumpEnabled then return end
    _G.__LustInfJumpEnabled = true
    InfiniteJump.enabled = true
end
function InfiniteJump.stop()
    _G.__LustInfJumpEnabled = false
    InfiniteJump.enabled = false
end
function InfiniteJump.isRunning() return _G.__LustInfJumpEnabled == true end
function InfiniteJump.setJumpPower() end
pcall(InfiniteJump.start)

fn34 = function(arg)
    if arg then InfiniteJump.start() else InfiniteJump.stop() end
end

do
    local old = rawget(_G, "__LustFloat")
    if type(old) == "table" then
        local wasOn = old.running == true or old.conn ~= nil
        old.running = false
        old.cycleToken = (old.cycleToken or 0) + 1
        if old.thread then pcall(task.cancel, old.thread); old.thread = nil end
        if old.conn then pcall(function() old.conn:Disconnect() end); old.conn = nil end
        if wasOn then
            if type(old.groundTP) == "function" then pcall(old.groundTP)
            elseif type(doTpDown) == "function" then pcall(doTpDown) end
        end
    end
end

_G.__LustFloat = {
    RISE         = 17,
    RATE         = 55,
    CYCLE        = 2.5,
    PAUSE        = 0.5,
    SAMPLE       = 0.08,
    PIT_MARGIN   = 15,
    conn         = nil,
    thread       = nil,
    running      = false,
    locked       = false,
    targetY      = nil,
    baseY        = nil,
    baseGround   = nil,
    safeValid    = false,
    safeX        = 0,
    safeZ        = 0,
    safeY        = 0,
    respawnToken = 0,
    cycleToken   = 0,
    _params      = nil,
}

function _G.__LustFloat.getHRP()
    local c = LP.Character
    if not c then return nil, nil end
    return c:FindFirstChild("HumanoidRootPart"), c:FindFirstChildOfClass("Humanoid")
end

function _G.__LustFloat.arm()
    local f = _G.__LustAntiDieArm
    if f then pcall(f) end
end
function _G.__LustFloat.release()
    local f = _G.__LustAntiDieRelease
    if f then pcall(f) end
end

-- Busca el suelo real debajo del personaje (ignora jugadores, partes sin colision y NPCs).
function _G.__LustFloat.findGround(char, hrp)
    local FLOAT = _G.__LustFloat
    local params = FLOAT._params
    if not params then
        params = RaycastParams.new()
        if RFT_EXCLUDE then params.FilterType = RFT_EXCLUDE end
        params.IgnoreWater = true
        pcall(function() params.RespectCanCollide = true end)
        FLOAT._params = params
    end
    local filter = { char }
    local plist = _GetPlayersCached()
    for i = 1, #plist do
        local plr = plist[i]
        if plr ~= LP and plr.Character then filter[#filter + 1] = plr.Character end
    end
    local half = hrp.Size.Y * 0.5
    if half <= 0 then half = 1 end
    local origin = hrp.Position
    local startY = origin.Y - half - 0.1
    for _ = 1, 6 do
        params.FilterDescendantsInstances = filter
        local res = Workspace:Raycast(Vector3.new(origin.X, startY, origin.Z), Vector3.new(0, -1000, 0), params)
        if not res then return nil, half end
        local part = res.Instance
        if part and part:IsA("BasePart") and part.CanCollide then
            local model = part:FindFirstAncestorOfClass("Model")
            if not (model and model:FindFirstChildOfClass("Humanoid")) then
                return res.Position.Y, half
            end
        end
        if part then filter[#filter + 1] = part end
        startY = res.Position.Y - 0.05
    end
    return nil, half
end

function _G.__LustFloat.isSafeGround(g)
    local FLOAT = _G.__LustFloat
    if not g then return false end
    if FLOAT.baseGround and g < FLOAT.baseGround - FLOAT.PIT_MARGIN then return false end
    return true
end

function _G.__LustFloat.groundTP()
    local FLOAT = _G.__LustFloat
    local char = LP.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum or hum.Health <= 0 then return end

    local pos = hrp.Position
    local x, z = pos.X, pos.Z
    local groundY, half
    pcall(function() groundY, half = FLOAT.findGround(char, hrp) end)

    -- Si termina el ciclo fuera del mapa (o sobre un vacio), vuelve al ultimo punto con suelo.
    local relocated = false
    if not FLOAT.isSafeGround(groundY) and FLOAT.safeValid then
        x, z, groundY = FLOAT.safeX, FLOAT.safeZ, FLOAT.safeY
        relocated = true
    end

    local targetY
    if groundY then
        half = half or math.max(hrp.Size.Y * 0.5, 1)
        local off = half * 3
        if hum.RigType ~= Enum.HumanoidRigType.R6 then
            off = half + (hum.HipHeight or (half * 2))
        end
        if off ~= off or off < 1 or off > 12 then off = half * 3 end
        targetY = groundY + off + 0.15
    elseif FLOAT.baseY then
        targetY = FLOAT.baseY
    end

    if targetY and targetY == targetY and targetY > -400 then
        pcall(function()
            if not relocated and pos.Y - targetY < 0.5 then
                hrp.AssemblyLinearVelocity = Vector3.zero
                return
            end
            hrp.CFrame = CFrame.new(x, targetY, z) * hrp.CFrame.Rotation
            hrp.AssemblyLinearVelocity = Vector3.zero
            hrp.AssemblyAngularVelocity = Vector3.zero
        end)
        local AB = _lustAimbot
        if AB and AB.onTeleport then pcall(AB.onTeleport) end
    end
end

function _G.__LustFloat.startLoop()
    local FLOAT = _G.__LustFloat
    if FLOAT.conn then return end
    FLOAT.locked = false
    FLOAT.targetY = nil

    local char0 = LP.Character
    local root0 = char0 and char0:FindFirstChild("HumanoidRootPart")
    local hum0 = char0 and char0:FindFirstChildOfClass("Humanoid")
    if hum0 then
        pcall(function() hum0:ChangeState(Enum.HumanoidStateType.Freefall) end)
    end

    -- Punto seguro inicial: el suelo bajo el personaje al empezar a flotar.
    FLOAT.safeValid = false
    FLOAT.baseGround = nil
    if char0 and root0 then
        local ok, g = pcall(FLOAT.findGround, char0, root0)
        if ok and g then
            FLOAT.baseGround = g
            FLOAT.safeX, FLOAT.safeZ, FLOAT.safeY = root0.Position.X, root0.Position.Z, g
            FLOAT.safeValid = true
        end
    end

    local cChar, cRoot, cHum = nil, nil, nil
    local sampleT = 0
    FLOAT.conn = _LustOn(RunService.Heartbeat, function(dt)
        local char = LP.Character
        if char ~= cChar or not cRoot or not cRoot.Parent then
            cChar = char
            cRoot = char and char:FindFirstChild("HumanoidRootPart") or nil
            cHum  = char and char:FindFirstChildOfClass("Humanoid") or nil
        end
        if not cRoot or not cHum or cHum.Health <= 0 then return end

        local cf  = cRoot.CFrame
        local pos = cf.Position
        local vel = cRoot.AssemblyLinearVelocity

        sampleT = sampleT + dt
        if sampleT >= FLOAT.SAMPLE then
            sampleT = 0
            local ok, g = pcall(FLOAT.findGround, cChar, cRoot)
            if ok and FLOAT.isSafeGround(g) then
                FLOAT.safeX, FLOAT.safeZ, FLOAT.safeY = pos.X, pos.Z, g
                FLOAT.safeValid = true
            elseif ok and FLOAT.safeValid then
                -- Se salio del mapa a velocidad alta: vuelve al ultimo punto con suelo.
                pos = Vector3.new(FLOAT.safeX, pos.Y, FLOAT.safeZ)
                vel = Vector3.new(0, vel.Y, 0)
            end
        end

        if not FLOAT.targetY then
            FLOAT.baseY   = pos.Y
            FLOAT.targetY = pos.Y + FLOAT.RISE
        end
        local y = FLOAT.targetY
        if not FLOAT.locked then
            y = math.min(pos.Y + FLOAT.RATE * dt, FLOAT.targetY)
            if y >= FLOAT.targetY then FLOAT.locked = true end
        end
        cRoot.CFrame = CFrame.new(pos.X, y, pos.Z) * cf.Rotation
        cRoot.AssemblyLinearVelocity = Vector3.new(vel.X, 0, vel.Z)
    end)
end

function _G.__LustFloat.stopLoop(tpDown)
    local FLOAT = _G.__LustFloat
    if FLOAT.conn then
        pcall(function() FLOAT.conn:Disconnect() end)
        FLOAT.conn = nil
    end
    if tpDown then
        pcall(FLOAT.groundTP)
    end
end

function _G.__LustFloat.waitGrounded(timeout)
    local FLOAT = _G.__LustFloat
    local deadline = os.clock() + (timeout or 3)
    while os.clock() < deadline do
        if not FLOAT.running then return end
        local hrp, hum = FLOAT.getHRP()
        if not hrp or not hum then return end
        if hum.Health <= 0 then return end
        if hum.FloorMaterial ~= Enum.Material.Air then
            task.wait(FLOAT.PAUSE)
            return
        end
        RunService.Heartbeat:Wait()
    end
end

function _G.__LustFloat.spawnCycle()
    local FLOAT = _G.__LustFloat
    if FLOAT.thread then pcall(task.cancel, FLOAT.thread); FLOAT.thread = nil end
    FLOAT.cycleToken = FLOAT.cycleToken + 1
    local token = FLOAT.cycleToken
    FLOAT.thread = task.spawn(function()
        while FLOAT.running and FLOAT.cycleToken == token do
            task.wait(FLOAT.CYCLE)
            if not FLOAT.running or FLOAT.cycleToken ~= token then break end
            FLOAT.stopLoop(true)
            FLOAT.waitGrounded(3)
            if not FLOAT.running or FLOAT.cycleToken ~= token then break end
            FLOAT.startLoop()
        end
    end)
end

function _G.__LustFloat.enable()
    local FLOAT = _G.__LustFloat
    if FLOAT.running then return end
    FLOAT.running = true
    FLOAT.arm()
    if not FLOAT.running then return end
    FLOAT.startLoop()
    FLOAT.spawnCycle()
end

function _G.__LustFloat.disable()
    local FLOAT = _G.__LustFloat
    if not FLOAT.running then return end
    FLOAT.running = false
    FLOAT.cycleToken = FLOAT.cycleToken + 1
    if FLOAT.thread then
        pcall(task.cancel, FLOAT.thread)
        FLOAT.thread = nil
    end
    FLOAT.stopLoop(true)
    FLOAT.safeValid = false
    FLOAT.baseGround = nil
    FLOAT.release()
end

function _G.__LustFloatToggle()
    local F = _G.__LustFloat
    if F.running then F.disable() else F.enable() end
    if _G.__LustFloatSetVisual then pcall(_G.__LustFloatSetVisual, F.running) end
    if mobSetFloat then pcall(mobSetFloat, F.running) end
    task.defer(function() pcall(saveAllSettings) end)
end

function _G.__LustFloatIsRunning()
    return _G.__LustFloat.running == true
end

_LustOn(LP.CharacterAdded, function(char)
    local FLOAT = _G.__LustFloat
    if not FLOAT.running then return end
    FLOAT.cycleToken = FLOAT.cycleToken + 1
    if FLOAT.thread then pcall(task.cancel, FLOAT.thread); FLOAT.thread = nil end
    if FLOAT.conn then pcall(function() FLOAT.conn:Disconnect() end); FLOAT.conn = nil end
    FLOAT.safeValid = false
    FLOAT.baseGround = nil
    FLOAT.respawnToken = (FLOAT.respawnToken or 0) + 1
    local token = FLOAT.respawnToken

    local hrp = char:WaitForChild("HumanoidRootPart", 5)
    local hum = char:WaitForChild("Humanoid", 5)
    if not hrp or not hum then return end
    task.wait(0.3)
    if not FLOAT.running or FLOAT.respawnToken ~= token then return end

    FLOAT.arm()
    local deadline = os.clock() + 3
    while os.clock() < deadline and FLOAT.running and FLOAT.respawnToken == token do
        if hum.Health <= 0 then return end
        if hum.FloorMaterial ~= Enum.Material.Air then break end
        RunService.Heartbeat:Wait()
    end
    if not FLOAT.running or FLOAT.respawnToken ~= token then return end
    if LP.Character ~= char then return end
    FLOAT.startLoop()
    FLOAT.spawnCycle()
end)

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

_s2VelState = _G.__LustSpeedHookState
if type(_s2VelState) ~= "table" then
    _s2VelState = { hooked = false, velChecked = setmetatable({}, { __mode = "k" }), root = nil, v = _V3zero }
    _G.__LustSpeedHookState = _s2VelState
end
_velChecked = _s2VelState.velChecked
_hookedVelParts = setmetatable({}, { __mode = "k" })
_hookVelSupported = nil

-- SPOOF DE VELOCIDAD: copia de fn56 de Hook (hook de __index/__newindex sobre el HRP).
-- Unica diferencia: el "vector" de Hook vive en _s2VelState.v para que los demas
-- modulos de Lust (Auto Play, Aimbot...) sigan escribiendo el mismo valor falso.
function _hookVelHRP(humanoidRootPart)
    if not humanoidRootPart then return end
    _s2VelState.root = humanoidRootPart
    _velChecked[humanoidRootPart] = true
    if _hookedVelParts[humanoidRootPart] then return end
    _hookedVelParts[humanoidRootPart] = true
    local installed = pcall(function()
        local mt = getrawmetatable(humanoidRootPart)
        setreadonly(mt, false)
        local Theme = mt.__index
        local newindex = mt.__newindex

        mt.__index = newcclosure(function(arg, arg2)
            if arg == humanoidRootPart and (arg2 == "AssemblyLinearVelocity" or arg2 == "Velocity") then
                local ok, result = pcall(checkcaller)
                if ok and result then
                    local ok2, result2 = pcall(Theme, arg, arg2)
                    if ok2 then
                        return result2
                    end
                elseif Config == nil or Config.speedEnabled ~= false then
                    return _s2VelState.v
                end
            end
            local ok, result = pcall(Theme, arg, arg2)
            if ok then
                return result
            end
            return _s2VelState.v
        end)

        mt.__newindex = newcclosure(function(arg, arg2, arg3)
            if arg == humanoidRootPart and (arg2 == "AssemblyLinearVelocity" or arg2 == "Velocity") then
                local ok, result = pcall(checkcaller)
                if ok and result then
                    if pcall(newindex, arg, arg2, arg3) then
                        return
                    end
                elseif Config == nil or Config.speedEnabled ~= false then
                    _s2VelState.v = arg3
                    return
                end
            end
            pcall(newindex, arg, arg2, arg3)
        end)
    end)
    if installed then _s2VelState.hooked = true end
end

function _setupVelChecked(char)
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

function _isRagdollState(hum)
    if not hum then return true end
    local st = hum:GetState()
    return hum.PlatformStand
        or st == Enum.HumanoidStateType.Physics
        or st == Enum.HumanoidStateType.Ragdoll
        or st == Enum.HumanoidStateType.FallingDown
end

_LustMove = { smoothed = Vector2.zero, lastMagnitude = 0, stepToken = 0, stepTarget = nil, stepExpires = 0, root = nil }
_LustMoveParams = RaycastParams.new()
_LustMoveParams.FilterType = RFT_EXCLUDE
_LustMoveParams.IgnoreWater = true
pcall(function() _LustMoveParams.RespectCanCollide = true end)

function _mvPulseVertical(part, tag, lineVel, duration)
    if not part or not part.Parent then return end
    local attName, lvName = tag .. "Attachment", tag .. "LinearVelocity"
    local att = part:FindFirstChild(attName)
    if not att then
        att = Instance.new("Attachment")
        att.Name = attName
        att.Parent = part
    end
    local lv = part:FindFirstChild(lvName)
    if not lv then
        lv = Instance.new("LinearVelocity")
        lv.Name = lvName
        lv.Attachment0 = att
        lv.RelativeTo = Enum.ActuatorRelativeTo.World
        lv.VelocityConstraintMode = Enum.VelocityConstraintMode.Line
        lv.LineDirection = Vector3.new(0, 1, 0)
        lv.ForceLimitsEnabled = false
        lv.Parent = part
    end
    local stamp = os.clock()
    lv:SetAttribute("LustPulse", stamp)
    lv.LineVelocity = lineVel or 0
    lv.Enabled = true
    task.delay(duration or 0.12, function()
        if not lv.Parent or lv:GetAttribute("LustPulse") ~= stamp then return end
        pcall(function() lv:Destroy() end)
        if att.Parent then pcall(function() att:Destroy() end) end
    end)
end

function _mvClearStep(root)
    _LustMove.stepToken = _LustMove.stepToken + 1
    _LustMove.stepTarget = nil
    _LustMove.stepExpires = 0
    if not root then return end
    local lv = root:FindFirstChild("LustSpeedStepLinearVelocity")
    if lv then pcall(function() lv:Destroy() end) end
    local att = root:FindFirstChild("LustSpeedStepAttachment")
    if att then pcall(function() att:Destroy() end) end
end

function _mvCheckRoof(root, dt)
    if not root or not root.Parent then return false end
    if autoBatEnabled or dropActive or _G.IsDropping then return false end
    local vy = math.max(root.AssemblyLinearVelocity.Y, 0)
    if vy <= 0.25 then return false end
    _LustMoveParams.FilterDescendantsInstances = { root.Parent }
    local step = math.clamp(dt or 1/60, 1/240, 1/15)
    if not workspace:Raycast(root.Position, Vector3.new(0, 3.05 + math.min(vy * step, 0.9), 0), _LustMoveParams) then
        return false
    end
    _mvClearStep(root)
    _mvPulseVertical(root, "LustRoofGuard", 0, 0.14)
    return true
end

function _mvRequestStep(root, targetY)
    if not root or not root.Parent or not targetY or targetY <= root.Position.Y + 0.05 then return end
    local m, now = _LustMove, os.clock()
    if m.stepTarget and m.root == root and now < m.stepExpires then
        m.stepTarget = math.max(m.stepTarget, targetY)
        m.stepExpires = math.max(m.stepExpires, now + 0.32)
        return
    end
    _mvClearStep(root)
    m.root = root
    m.stepTarget = targetY
    m.stepExpires = now + 0.32
    local token = m.stepToken
    task.spawn(function()
        while m.stepToken == token and root.Parent and root.Parent == LP.Character and os.clock() < m.stepExpires do
            local rise = (m.stepTarget or root.Position.Y) - root.Position.Y
            if rise <= 0.05 then break end
            _LustMoveParams.FilterDescendantsInstances = { root.Parent }
            if workspace:Raycast(root.Position, Vector3.new(0, 3.05 + math.min(rise, 2.35), 0), _LustMoveParams) then break end
            local att = root:FindFirstChild("LustSpeedStepAttachment")
            if not att then
                att = Instance.new("Attachment")
                att.Name = "LustSpeedStepAttachment"
                att.Parent = root
            end
            local lv = root:FindFirstChild("LustSpeedStepLinearVelocity")
            if not lv then
                lv = Instance.new("LinearVelocity")
                lv.Name = "LustSpeedStepLinearVelocity"
                lv.Attachment0 = att
                lv.RelativeTo = Enum.ActuatorRelativeTo.World
                lv.VelocityConstraintMode = Enum.VelocityConstraintMode.Line
                lv.LineDirection = Vector3.new(0, 1, 0)
                lv.ForceLimitsEnabled = false
                lv.Parent = root
            end
            lv.LineVelocity = math.clamp(rise * 11, 7, 17)
            lv.Enabled = true
            RunService.Heartbeat:Wait()
        end
        if m.stepToken == token then _mvClearStep(root) end
    end)
end

function _mvWalkableStep(root, hum, vec, dist, radius)
    if not hum or not root or not root.Parent or not vec or vec.Magnitude < 0.01 then return false end
    _LustMoveParams.FilterDescendantsInstances = { root.Parent }
    local ground = workspace:Raycast(root.Position, Vector3.new(0, -7, 0), _LustMoveParams)
    if not ground or ground.Normal.Y < 0.45 then return false end
    local maxStep = math.clamp((hum.HipHeight or 2) + 0.25, 1.35, 2.35)
    local probe = root.Position + vec.Unit * (radius + math.min(dist, 0.65) + 0.08)
    local ahead = workspace:Raycast(
        Vector3.new(probe.X, ground.Position.Y + maxStep + 0.25, probe.Z),
        Vector3.new(0, -maxStep - 0.45, 0),
        _LustMoveParams
    )
    if not ahead or ahead.Normal.Y < 0.55 then return false end
    local rise = ahead.Position.Y - ground.Position.Y
    if rise > 0.05 and rise <= maxStep then
        return true, ahead.Position.Y + (hum.HipHeight or 2) + root.Size.Y * 0.5 + 0.06
    end
    return false
end

function _mvResolveHorizontal(root, hum, desired, dt)
    local vector = Vector3.new(desired.X, 0, desired.Z)
    if vector.Magnitude < 0.01 then return vector, false, false end
    _LustMoveParams.FilterDescendantsInstances = { root.Parent }
    local speedMag = vector.Magnitude
    local step = math.clamp(math.max(dt or 1/60, 1/90), 1/90, 1/15)
    local radius = math.clamp(math.max(root.Size.X, root.Size.Z) * 0.5, 0.9, 1)
    local canStep, stepY = _mvWalkableStep(root, hum, vector, vector.Magnitude * step, radius)
    if canStep then _mvRequestStep(root, stepY) end
    local slid, firstNormal, stuck = false, nil, false
    for _ = 1, 2 do
        if vector.Magnitude < 0.02 then break end
        local travel = vector.Magnitude * step
        local hit
        if not pcall(function()
            hit = workspace:Spherecast(root.Position, radius, vector.Unit * (travel + 0.03), _LustMoveParams)
        end) then
            hit = workspace:Raycast(root.Position, vector.Unit * (travel + radius + 0.03), _LustMoveParams)
        end
        if not hit then break end
        local slopeCos = math.cos(math.rad(math.clamp(hum and hum.MaxSlopeAngle or 45, 0, 89)))
        if hit.Normal.Y >= slopeCos then break end
        local canStep2, stepY2 = _mvWalkableStep(root, hum, vector, travel, radius)
        if canStep2 then _mvRequestStep(root, stepY2); break end
        local n = Vector3.new(hit.Normal.X, 0, hit.Normal.Z)
        if n.Magnitude < 0.05 then break end
        n = n.Unit
        local d = vector:Dot(n)
        if d >= 0 then break end
        slid = true
        local before = vector
        if firstNormal and firstNormal:Dot(n) < 0.55 then
            vector, stuck = Vector3.zero, true
            break
        end
        firstNormal = firstNormal or n
        local slide = before - n * d
        local room = math.max((hit.Distance or 0) - 0.03, 0)
        vector = slide - n * math.min(-d, room / step)
    end
    if vector.Magnitude < 0.04 then vector = Vector3.zero end
    if vector.Magnitude > speedMag then vector = vector.Unit * speedMag end
    return vector, slid, stuck
end

function _mvSetLV(root, x, z, dt)
    if not root or not root.Parent then return end
    _LustMove.root = root
    local y = root.AssemblyLinearVelocity.Y
    local vec = Vector3.new(x or 0, 0, z or 0)
    local lastJump = _G.__LustLastJumpTime
    local fakeY
    if lastJump and os.clock() - lastJump < 0.15 then fakeY = 0
    elseif math.abs(y) > 20 then fakeY = math.clamp(y, -20, 20)
    else fakeY = y end
    if vec.Magnitude > 0.05 then
        local u = vec.Unit
        local fm = math.min(vec.Magnitude, 16)
        _s2VelState.v = Vector3.new(u.X * fm, fakeY, u.Z * fm)
        root.AssemblyLinearVelocity = Vector3.new(vec.X, y, vec.Z)
        _G.__LustLiveSpeed = { t = os.clock(), v = vec.Magnitude }
    else
        _s2VelState.v = Vector3.new(0, fakeY, 0)
    end
end

function _mvClear()
    _mvClearStep(_LustMove.root)
    _s2VelState.v = Vector3.new(0, 0, 0)
    _LustMove.smoothed = Vector2.zero
    _LustMove.lastMagnitude = 0
    _LustMove.root = nil
end

function _applyVelocitySpeed(dir, speed, hrp, dt)
    if not hrp or not hrp.Parent then return end
    if autoBatEnabled then return end
    if type(speed) ~= "number" or speed ~= speed or speed <= 0 or speed == math.huge then return end
    if dir and dir.Magnitude > 0.05 then
        local flat = Vector3.new(dir.X, 0, dir.Z)
        if flat.Magnitude <= 0.001 then return end
        local unit = flat.Unit
        local desired = Vector3.new(unit.X * speed, 0, unit.Z * speed)
        local char = LP.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        local ok, res = pcall(_mvResolveHorizontal, hrp, hum, desired, dt)
        if ok and typeof(res) == "Vector3" then desired = res end
        _mvSetLV(hrp, desired.X, desired.Z, dt)
    else
        _mvSetLV(hrp, 0, 0, dt)
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
    ["Tryhard"] = { idle1="rbxassetid://133806214992291", idle2="rbxassetid://94970088341563", walk="rbxassetid://707897309", run="rbxassetid://707861613", jump="rbxassetid://116936326516985", fall="rbxassetid://116936326516985", climb="rbxassetid://116936326516985", swim="rbxassetid://116936326516985", swimidle="rbxassetid://116936326516985" },
}
ANIM_PACK_ORDER = {{"Off", "Off"}, {"Zombie", "Zombie"}, {"Ninja", "Ninja"}, {"Knight", "Knight"}, {"Elder", "Elder"}, {"Levitate", "Levitate"}, {"Astronaut", "Astronaut"}, {"Pirate", "Pirate"}, {"Toy", "Toy"}, {"Vampire", "Vampire"}, {"Werewolf", "Werewolf"}, {"Rthro", "Rthro"}, {"Stylish", "Stylish"}, {"Tryhard", "Tryhard"}}

function isPackAnim(id)
    for _, pack in pairs(ANIM_PACKS) do
        for _, v in pairs(pack) do if v == id then return true end end
    end
    return false
end

function saveOriginalAnims(char)
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

function applyAnimPack(packName)
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
    local pack = ANIM_PACKS[packName]; if not pack then return end
    if tryardHeartbeatConn then tryardHeartbeatConn:Disconnect() end
    tryardHeartbeatConn = _LustOn(RunService.Heartbeat, function()
        local c = LP.Character; if not c then return end
        local animate = c:FindFirstChild("Animate"); if not animate then return end
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

function startAnimPack(packName)
    local char = LP.Character
    if char then
        saveOriginalAnims(char)
        applyAnimPack(packName)
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            for _, track in ipairs(hum:GetPlayingAnimationTracks()) do track:Stop(0) end
            hum:ChangeState(Enum.HumanoidStateType.Running)
        end
    else applyAnimPack(packName) end
    currentAnimPack = packName
end

function stopAnimPack()
    currentAnimPack = "Off"
    if animSelectorLabel then animSelectorLabel.Text = "Off" end
    applyAnimPack("Off")
end

DEFAULT_KB = {
    DropBrainrot = {kb = Enum.KeyCode.X,           gp = nil},
    AutoPlay     = {kb = Enum.KeyCode.Z,           gp = nil},
    AutoBat      = {kb = Enum.KeyCode.E,           gp = nil},
    TPFloor      = {kb = Enum.KeyCode.F,           gp = nil},
    CarryToggle  = {kb = Enum.KeyCode.Q,           gp = nil},
    LaggerMode   = {kb = Enum.KeyCode.R,           gp = nil},
    InstaReset   = {kb = Enum.KeyCode.H,           gp = nil},
    Float        = {kb = Enum.KeyCode.B,           gp = nil},
}
KB = {
    DropBrainrot = {kb = DEFAULT_KB.DropBrainrot.kb, gp = DEFAULT_KB.DropBrainrot.gp},
    AutoPlay     = {kb = DEFAULT_KB.AutoPlay.kb,     gp = DEFAULT_KB.AutoPlay.gp},
    AutoBat      = {kb = DEFAULT_KB.AutoBat.kb,      gp = DEFAULT_KB.AutoBat.gp},
    TPFloor      = {kb = DEFAULT_KB.TPFloor.kb,      gp = DEFAULT_KB.TPFloor.gp},
    CarryToggle  = {kb = DEFAULT_KB.CarryToggle.kb,  gp = DEFAULT_KB.CarryToggle.gp},
    LaggerMode   = {kb = DEFAULT_KB.LaggerMode.kb,   gp = DEFAULT_KB.LaggerMode.gp},
    InstaReset   = {kb = DEFAULT_KB.InstaReset.kb,   gp = DEFAULT_KB.InstaReset.gp},
    Float        = {kb = DEFAULT_KB.Float.kb,        gp = DEFAULT_KB.Float.gp},
}
_isResetting = false
_lastSavedJSON = nil
_isLoading = false
CONFIG = { AUTO_STEAL_ENABLED = false, STEAL_RANGE = 60 }
plots = Workspace:FindFirstChild("Plots")

LustSteal = {
    StealRadius = 60,
    StealDuration = 1.3,
    NormalStealPausePercent = 75,
    Data = {},
    autoStealConn = nil,
    nextScan = 0,
    lastNormalSteal = 0,
    lastTargetData = nil,
    lastPrompt = nil,
    lastTargetBasePos = nil,
}
NormalPauseOptions = { 70, 75, 80, 85, 90, 95, 100 }

function normalizeNormalPausePercent(v)
    local n = tonumber(v) or 75
    local best = NormalPauseOptions[1]
    local bestDiff = math.huge
    for _, opt in ipairs(NormalPauseOptions) do
        local d = math.abs(n - opt)
        if d < bestDiff then bestDiff = d; best = opt end
    end
    return best
end

autoGrabSetDelayRadius = 6

StealState = { active = false, startTime = 0, phase = "idle", label = "", lastResult = "", lastResultTime = 0 }
_G.__LustStealToken = 0
Steal = { AutoStealEnabled = false, Data = {} }
isStealing = false
stealConnection = nil

function getPlotsRoot() return workspace:FindFirstChild("Plots") end

function isMyPlotByName(plotName)
    local plotsRoot = getPlotsRoot(); if not plotsRoot then return false end
    local plot = plotsRoot:FindFirstChild(plotName); if not plot then return false end
    local sign = plot:FindFirstChild("PlotSign")
    if sign then
        local yb = sign:FindFirstChild("YourBase")
        if yb and yb:IsA("BillboardGui") then return yb.Enabled == true end
    end
    return false
end

function findNearestPrompt()
    local char = LP.Character; if not char then return nil, nil, nil end
    local root = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso")
    if not root then return nil, nil, nil end
    local plotsRoot = getPlotsRoot(); if not plotsRoot then return nil, nil, nil end
    local nearestData, nearestPrompt, nearestDist = nil, nil, math.huge
    local rpos = root.Position
    local maxDist = LustSteal.StealRadius
    for _, plot in ipairs(plotsRoot:GetChildren()) do
        if not isMyPlotByName(plot.Name) then
            local pods = plot:FindFirstChild("AnimalPodiums")
            if pods then
                for _, pod in ipairs(pods:GetChildren()) do
                    local base = pod:FindFirstChild("Base")
                    local spawn = base and base:FindFirstChild("Spawn")
                    if spawn then
                        local sp = spawn.Position
                        local dist = (sp - rpos).Magnitude
                        if dist < nearestDist and dist <= maxDist then
                            local att = spawn:FindFirstChild("PromptAttachment")
                            if att then
                                for _, child in ipairs(att:GetChildren()) do
                                    if child:IsA("ProximityPrompt")
                                       and tostring(child.ActionText):find("Steal") then
                                        nearestData = { name = pod.Name, plot = plot.Name, slot = pod.Name, worldPosition = sp, uid = plot.Name .. "_" .. pod.Name }
                                        nearestPrompt = child
                                        nearestDist = dist
                                        break
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    return nearestData, nearestPrompt, nearestDist
end

function _stealDistance(prompt, fallbackPos)
    local c = LP.Character
    local root = c and (c:FindFirstChild("HumanoidRootPart") or c:FindFirstChild("Torso"))
    if not root then return nil end
    if not prompt or not prompt.Parent then return nil end
    local wp
    local parent = prompt.Parent
    local depth = 0
    while parent and parent ~= workspace and depth < 8 do
        if parent:IsA("Attachment") then wp = parent.WorldPosition; break end
        if parent:IsA("BasePart") then wp = parent.Position; break end
        parent = parent.Parent
        depth = depth + 1
    end
    if not wp then wp = fallbackPos end
    if not wp then return nil end
    local d = root.Position - wp
    return Vector3.new(d.X, 0, d.Z).Magnitude
end

function _prepareStealData(prompt)
    if LustSteal.Data[prompt] then return LustSteal.Data[prompt] end
    local data = { holdCallbacks = {}, triggerCallbacks = {}, ready = true }
    if getconnections then
        local ok, res = pcall(getconnections, prompt.PromptButtonHoldBegan)
        if ok and type(res) == "table" then
            for _, c in ipairs(res) do
                if type(c.Function) == "function" then table.insert(data.holdCallbacks, c.Function) end
            end
        end
        local ok2, res2 = pcall(getconnections, prompt.Triggered)
        if ok2 and type(res2) == "table" then
            for _, c in ipairs(res2) do
                if type(c.Function) == "function" then table.insert(data.triggerCallbacks, c.Function) end
            end
        end
    end
    LustSteal.Data[prompt] = data
    return data
end

function executeSteal(prompt, podName, data)
    if not prompt or not prompt.Parent then return false end
    local cfg = LustSteal.Data[prompt]
    if not cfg or not cfg.ready then return false end
    if StealState.active then return false end
    if _tick() - (LustSteal.lastNormalSteal or 0) < 0.08 then return false end

    cfg.ready = false
    isStealing = true
    StealState.active = true
    StealState.startTime = _tick()
    StealState.phase = "filling"
    StealState.label = podName or "Animal"

    LustSteal.lastNormalSteal = _tick()
    _G.__LustStealToken = (_G.__LustStealToken or 0) + 1
    local token = _G.__LustStealToken

    local startTime = _tick()
    local pausePercent = normalizeNormalPausePercent(LustSteal.NormalStealPausePercent)
    local pauseTime = 1.3 * pausePercent / 100

    local barFrame = progressFill
    local barPct   = progressPct
    local pauseAccum = 0
    local pausePhaseStart = nil

    if barFrame then barFrame.Size = UDim2.new(0, 0, 1, 0) end
    if barPct then barPct.Text = "0%" end

    local function isValid()
        return _G.__LustStealToken == token
           and StealState.active
           and Steal.AutoStealEnabled
           and prompt.Parent ~= nil
           and _G.__LustStealRagdollPaused ~= true
    end

    local function _abortSteal()
        if _G.__LustStealToken == token then
            StealState.active = false
            StealState.phase = "idle"
            isStealing = false
        end
        if barFrame then barFrame.Size = UDim2.new(0, 0, 1, 0) end
        if barPct then barPct.Text = "0%" end
    end

    local function finalize(result, fired)
        StealState.lastResult = result
        StealState.lastResultTime = _tick()
        StealState.active = false
        StealState.phase = "idle"
        isStealing = false
        cfg.ready = true
        if _G.__LustStealToken ~= token then return end
        if fired then
            pcall(function() if _G.AutoCarrySpeed and _G.AutoCarrySpeed.WatchPickup then _G.AutoCarrySpeed.WatchPickup(1.25) end end)
            if barFrame then barFrame.Size = UDim2.new(1, 0, 1, 0) end
            if barPct then barPct.Text = "100%" end
        else
            if barFrame then barFrame.Size = UDim2.new(0, 0, 1, 0) end
            if barPct then barPct.Text = "0%" end
        end
    end

    local progressConn = nil
    if barFrame then
        progressConn = _LustOn(RunService.Heartbeat, function()
            if not isValid() then
                if progressConn then progressConn:Disconnect(); progressConn = nil end
                return
            end
            local ref = pausePhaseStart
            local elapsed = (ref or _tick()) - startTime - pauseAccum
            local prog = _clamp(elapsed / 1.3, 0, 1)
            barFrame.Size = UDim2.new(prog, 0, 1, 0)
            if barPct then barPct.Text = _floor(prog * 100) .. "%" end
        end)
    end

    task.spawn(function()
        pcall(function() prompt.HoldDuration = 0 end)
        for _, f in ipairs(cfg.holdCallbacks) do task.spawn(f) end

        while isValid() and _tick() - startTime < pauseTime do
            local dist = _stealDistance(prompt, data and data.worldPosition)
            if dist and dist <= LustSteal.StealRadius then
                task.wait()
            else
                break
            end
        end

        if not isValid() then
            if progressConn then progressConn:Disconnect(); progressConn = nil end
            cfg.ready = true
            _abortSteal()
            return
        end

        if barFrame then barFrame.Size = UDim2.new(pausePercent / 100, 0, 1, 0) end
        if barPct then barPct.Text = _floor(pausePercent) .. "%" end
        StealState.phase = "waiting"
        pausePhaseStart = _tick()

        local phase2Timeout = math.max(2.99 - pauseTime - math.max(1.3 - pauseTime, 0), 0.05)
        local phase2Start = _tick()

        while isValid() do
            if phase2Timeout <= _tick() - phase2Start then
                if progressConn then progressConn:Disconnect(); progressConn = nil end
                finalize("Missed: " .. tostring(StealState.label), false); return
            end
            local dist = _stealDistance(prompt, data and data.worldPosition)
            if not dist or dist > LustSteal.StealRadius then
                if progressConn then progressConn:Disconnect(); progressConn = nil end
                finalize("Missed (far): " .. tostring(StealState.label), false); return
            end
            if dist <= autoGrabSetDelayRadius then
                if pausePhaseStart then
                    pauseAccum = pauseAccum + (_tick() - pausePhaseStart)
                    pausePhaseStart = nil
                end
                break
            end
            task.wait()
        end

        if not isValid() then
            if progressConn then progressConn:Disconnect(); progressConn = nil end
            cfg.ready = true
            _abortSteal()
            return
        end

        StealState.phase = "finishing"
        local phase3Start = _tick()
        local fillDuration = math.max(1.3 - pauseTime, 0.05)
        while isValid() and (_tick() - phase3Start) < fillDuration do task.wait() end

        if isValid() then
            pcall(function()
                for _, f in ipairs(cfg.triggerCallbacks) do task.spawn(f) end
                local stealAnimal = ReplicatedStorage:FindFirstChild("StealAnimal")
                if stealAnimal and podName then stealAnimal:FireServer(podName) end
                if prompt then prompt:Fire() end
            end)
            if progressConn then progressConn:Disconnect(); progressConn = nil end
            finalize("Stole " .. tostring(StealState.label), true)
        else
            if progressConn then progressConn:Disconnect(); progressConn = nil end
            cfg.ready = true
            _abortSteal()
        end
    end)
    return true
end

LustRagdollPause = { active = false, token = 0, humConn = nil, charConn = nil, humanoid = nil }
_G.__LustStealRagdollPaused = false

function _isHumanoidRagdolled(hum)
    if not hum then return false end
    local st = hum:GetState()
    return st == Enum.HumanoidStateType.Physics or st == Enum.HumanoidStateType.Ragdoll
end

function _onLustRagdollDetected()
    if not Steal.AutoStealEnabled then return end
    LustRagdollPause.token = LustRagdollPause.token + 1
    local myToken = LustRagdollPause.token
    _G.__LustStealRagdollPaused = true
    LustRagdollPause.active = true
    _G.__LustStealToken = (_G.__LustStealToken or 0) + 1
    StealState.active = false
    StealState.phase = "paused"
    isStealing = false
    if progressFill then progressFill.Size = UDim2.new(0, 0, 1, 0) end
    if progressPct then progressPct.Text = "0%" end
    task.delay(1.45, function()
        if LustRagdollPause.token ~= myToken then return end
        LustRagdollPause.active = false
        _G.__LustStealRagdollPaused = false
        for _, d in pairs(LustSteal.Data) do d.ready = true end
    end)
end

function _startLustRagdollWatcher()
    if LustRagdollPause.charConn then LustRagdollPause.charConn:Disconnect(); LustRagdollPause.charConn = nil end
    if LustRagdollPause.humConn then LustRagdollPause.humConn:Disconnect(); LustRagdollPause.humConn = nil end
    local function attachChar(char)
        if not char then return end
        if LustRagdollPause.humConn then LustRagdollPause.humConn:Disconnect(); LustRagdollPause.humConn = nil end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hum then return end
        LustRagdollPause.humanoid = hum
        LustRagdollPause.humConn = hum.StateChanged:Connect(function(_, newState)
            if newState == Enum.HumanoidStateType.Physics or newState == Enum.HumanoidStateType.Ragdoll then
                _onLustRagdollDetected()
            end
        end)
    end
    if LP.Character then attachChar(LP.Character) end
    LustRagdollPause.charConn = _LustOn(LP.CharacterAdded, function(char)
        task.wait(0.2); attachChar(char)
    end)
end

function _stopLustRagdollWatcher()
    if LustRagdollPause.humConn then LustRagdollPause.humConn:Disconnect(); LustRagdollPause.humConn = nil end
    if LustRagdollPause.charConn then LustRagdollPause.charConn:Disconnect(); LustRagdollPause.charConn = nil end
    LustRagdollPause.humanoid = nil
    LustRagdollPause.active = false
    LustRagdollPause.token = LustRagdollPause.token + 1
    _G.__LustStealRagdollPaused = false
end

function _startAutoStealV1()
    if stealConnection then
        local connected = false
        pcall(function() connected = stealConnection.Connected == true end)
        if connected then Steal.AutoStealEnabled = true; return true end
        pcall(function() stealConnection:Disconnect() end)
        stealConnection = nil
    end
    Steal.AutoStealEnabled = true
    pcall(function()
        local plotsRoot = workspace:FindFirstChild("Plots")
        if plotsRoot then
            for _, d in ipairs(plotsRoot:GetDescendants()) do
                if d:IsA("ProximityPrompt") then pcall(function() d.HoldDuration = 0 end) end
            end
        end
    end)
    stealConnection = _LustOn(RunService.Heartbeat, function()
        if not Steal.AutoStealEnabled then return end
        if _G.__LustStealRagdollPaused == true then return end
        if StealState.active then return end
        if _tick() < (LustSteal.nextScan or 0) then return end
        LustSteal.nextScan = _tick() + 0.08

        local cachedData = LustSteal.lastTargetData
        local cachedPrompt = LustSteal.lastPrompt
        local targetData = cachedData

        if cachedData then
            if not cachedPrompt or not cachedPrompt.Parent then
                LustSteal.lastTargetData = nil
                LustSteal.lastPrompt = nil
                targetData = nil
            else
                targetData = cachedData
            end
        end

        local magnitude
        if targetData then
            local c = LP.Character
            local root = c and (c:FindFirstChild("HumanoidRootPart") or c:FindFirstChild("Torso"))
            magnitude = (root and targetData.worldPosition)
                and (root.Position - targetData.worldPosition).Magnitude
                or math.huge
        else
            local data, prompt, dist = findNearestPrompt()
            targetData = data; cachedPrompt = prompt; magnitude = dist or math.huge
        end

        if not targetData then return end
        if LustSteal.StealRadius < magnitude then
            if LustSteal.lastTargetData == targetData then LustSteal.lastTargetData = nil end
            return
        end

        if not cachedPrompt or not cachedPrompt.Parent then
            local plotsRoot = getPlotsRoot()
            if plotsRoot then
                local p = plotsRoot:FindFirstChild(targetData.plot)
                if p then
                    local pods = p:FindFirstChild("AnimalPodiums")
                    if pods then
                        local pod = pods:FindFirstChild(targetData.slot)
                        if pod then
                            local base = pod:FindFirstChild("Base")
                            local spawn = base and base:FindFirstChild("Spawn")
                            if spawn then
                                local att = spawn:FindFirstChild("PromptAttachment")
                                if att then
                                    for _, c in ipairs(att:GetChildren()) do
                                        if c:IsA("ProximityPrompt") then cachedPrompt = c; break end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end

        if not cachedPrompt then return end
        LustSteal.lastTargetData = targetData
        LustSteal.lastPrompt = cachedPrompt
        _prepareStealData(cachedPrompt)
        executeSteal(cachedPrompt, targetData.name, targetData)
    end)
    return true
end

function _stopAutoStealV1()
    if stealConnection then stealConnection:Disconnect(); stealConnection = nil end
    _G.__LustStealToken = (_G.__LustStealToken or 0) + 1
    isStealing = false
    Steal.AutoStealEnabled = false
    StealState.active = false
    StealState.phase = "idle"
    LustSteal.lastTargetData = nil
    LustSteal.lastPrompt = nil
    LustSteal._deadSince = nil
    if progressFill then TS:Create(progressFill, TweenInfo.new(0.2), { Size = UDim2.new(0, 0, 1, 0) }):Play() end
    if progressPct then progressPct.Text = "0%" end
end

_LustOn(RunService.Heartbeat, function()
    if not StealState.active then
        LustSteal._deadSince = nil
        return
    end
    local prompt = LustSteal.lastPrompt
    local alive = prompt and prompt.Parent ~= nil
    local now = _tick()
    if not alive then
        LustSteal._deadSince = LustSteal._deadSince or now
        if now - LustSteal._deadSince > 0.4 then
            StealState.active = false
            StealState.phase = "idle"
            isStealing = false
            _G.__LustStealToken = (_G.__LustStealToken or 0) + 1
            LustSteal.lastPrompt = nil
            LustSteal.lastTargetData = nil
            LustSteal._deadSince = nil
            for _, d in pairs(LustSteal.Data) do d.ready = true end
            if progressFill then progressFill.Size = UDim2.new(0, 0, 1, 0) end
            if progressPct then progressPct.Text = "0%" end
        end
    else
        LustSteal._deadSince = nil
    end
end)

function startAutoSteal()
    _stopAutoStealV1()
    CONFIG.AUTO_STEAL_ENABLED = true
    _startAutoStealV1()
    _startLustRagdollWatcher()
    return true
end

function stopAutoSteal()
    _stopAutoStealV1()
    _stopLustRagdollWatcher()
    CONFIG.AUTO_STEAL_ENABLED = false
end

function doTpDown()
    local character = LP.Character
    if not character then return end
    local hrp = character:FindFirstChild("HumanoidRootPart")
    local hum = character:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum then return end
    pcall(function()
        local _, yaw = hrp.CFrame:ToEulerAnglesYXZ()
        hrp.CFrame = CFrame.new(hrp.Position.X, -7, hrp.Position.Z) * CFrame.Angles(0, yaw, 0)
        hrp.Velocity = Vector3.zero
        hrp.AssemblyLinearVelocity = Vector3.zero
        hrp.AssemblyAngularVelocity = Vector3.zero
    end)
    local AB = _lustAimbot
    if AB and AB.onTeleport then pcall(AB.onTeleport) end
end

tpDownAutoEnabled = false
tpDownAutoHeight  = 10
tpDownAutoThread  = nil

function startTpDownAuto()
    if tpDownAutoThread then pcall(task.cancel, tpDownAutoThread); tpDownAutoThread = nil end
    tpDownAutoEnabled = true
    tpDownAutoThread = task.spawn(function()
        while tpDownAutoEnabled do
            task.wait(0.15)
            local char = LP.Character
            if char and not autoPlayEnabled and not autoBatEnabled
               and not dropActive and not _G.IsDropping
               and not (Config and Config._instaResetInProgress) then
                local hrp  = char:FindFirstChild("HumanoidRootPart")
                local hum  = char:FindFirstChildOfClass("Humanoid")
                if hrp and hum then
                    if hum.FloorMaterial == Enum.Material.Air then
                        if hrp.Position.Y >= tpDownAutoHeight then doTpDown() end
                    end
                end
            end
        end
    end)
end

function stopTpDownAuto()
    tpDownAutoEnabled = false
    if tpDownAutoThread then pcall(task.cancel, tpDownAutoThread); tpDownAutoThread = nil end
end

_G._VynxRunTPDown = doTpDown
function _startAutoTPDown() startTpDownAuto() end
function _stopAutoTPDown()  stopTpDownAuto()  end

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

enemySpeedConn = nil
movementLoop = nil
steppedConn = nil
infJumpConn = nil
stretchConn = nil
stretchFovConn = nil
antiLagDescConn = nil
medusaResetConns = {}
dropConnections = {}
enemySpeedLabels = {}
Conns = {autoSteal = nil, batCounter = nil, anchor = {}, progress = nil}
keyButtonRefs = {}
progressFill = nil
progressPct = nil
pbFrame = nil
stealBarScaleObj = nil
speedLabel = nil
modeValLbl = nil
normalBox, carryBox, laggerBox, lagger2Box, radInput, batSpeedBox, uiScaleBox = nil, nil, nil, nil, nil, nil, nil
buttonScaleBox = nil
modeSelectBtn, dropModeBtnRef = nil, nil
_dropModeSel, _dropSyncing = nil, false
function syncDropModeUI()
    if not _dropModeSel then return end
    _dropSyncing = true
    pcall(_dropModeSel.setByValue, dropMode == 1 and "Fling" or "Jump Drop", true)
    _dropSyncing = false
end
autoBatSetVisual, autoPlaySetVisual, setBatCounterVisual, setMedusaVisual = nil, nil, nil, nil
setAntiRagVisual, setUnwalkVisual, setAntiLagVisual, setLockUIVisual, setInstaGrab = nil, nil, nil, nil, nil
setAntiDieVisual = nil
setESPVIsual = nil
setESPLineVisual = nil
mobSetAutoBat, mobSetAutoPlay, mobSetDropBR, mobSetTpDown, mobSetCarry, mobSetLagger1, mobSetLagger2, mobSetFloat = nil, nil, nil, nil, nil, nil, nil, nil
miniBtn, main, gui = nil, nil, nil
MobilePanel = nil
instaResetFloatingButton = nil
showGui = nil
hideGui = nil
mainUIScale = nil
animSelectorLabel = nil
tabButtons = nil
colorSelectorLabel = nil

GAMEPAD_KEYS = {}
do
    local okGamepad = pcall(function()
        local K = Enum.KeyCode
        GAMEPAD_KEYS[K.ButtonA] = true
        GAMEPAD_KEYS[K.ButtonB] = true
        GAMEPAD_KEYS[K.ButtonX] = true
        GAMEPAD_KEYS[K.ButtonY] = true
        GAMEPAD_KEYS[K.ButtonL1] = true
        GAMEPAD_KEYS[K.ButtonR1] = true
        GAMEPAD_KEYS[K.ButtonL2] = true
        GAMEPAD_KEYS[K.ButtonR2] = true
        GAMEPAD_KEYS[K.ButtonL3] = true
        GAMEPAD_KEYS[K.ButtonR3] = true
        GAMEPAD_KEYS[K.ButtonStart] = true
        GAMEPAD_KEYS[K.ButtonSelect] = true
        GAMEPAD_KEYS[K.DPadUp] = true
        GAMEPAD_KEYS[K.DPadDown] = true
        GAMEPAD_KEYS[K.DPadLeft] = true
        GAMEPAD_KEYS[K.DPadRight] = true
    end)
    if not okGamepad then GAMEPAD_KEYS = {} end
end
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
    L1 = _V3new(-476.48, -6.28, 94.87),
    L2 = _V3new(-483.12, -6.46, 25.13),
    R1 = _V3new(-483.12, -6.52, 25.62),
    R2 = _V3new(-483.06, -5.03, 25.48),
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

function applySaturation(arg)
    saturationEnabled = arg and true or false
    if not _colorCorrectionEffect or not _colorCorrectionEffect.Parent then
        _colorCorrectionEffect = Instance.new("ColorCorrectionEffect")
        _colorCorrectionEffect.Name = "LustSaturation"
        _colorCorrectionEffect:SetAttribute("_LustVividEffect", true)
        _colorCorrectionEffect.Parent = Lighting
    end
    _colorCorrectionEffect.Enabled    = saturationEnabled
    _colorCorrectionEffect.Saturation = saturationEnabled and 1    or 0
    _colorCorrectionEffect.Contrast   = saturationEnabled and 0.18 or 0
    _colorCorrectionEffect.Brightness = saturationEnabled and 0.1  or 0
end

function enableVividGraphics()  applySaturation(true)  end
function disableVividGraphics() applySaturation(false) end
function toggleVividGraphics(on)
    applySaturation(on)
    if setSaturationVisual then setSaturationVisual(on == true) end
    saveAllSettings(true)
end

_G.LustBaseXRayEnabled      = _G.LustBaseXRayEnabled == true
_G.LustBaseXRayTransparency = math.clamp(tonumber(_G.LustBaseXRayTransparency) or 0.5, 0, 1)
_G.LustBaseXRayState = _G.LustBaseXRayState or { saved = {}, conns = {}, run = 0 }

do
    local st = _G.LustBaseXRayState
    local NAMES = { "Base","PlotSign","FriendPanel","Cash","Laser",
                    "Decorations","Skin","Unlock","Purchases" }

    local function paint(inst, alpha, run)
        if not inst or run ~= st.run then return end
        local function go(o)
            if o:IsA("BasePart") or o:IsA("Decal") or o:IsA("Texture") then
                if st.saved[o] == nil then st.saved[o] = o.Transparency end
                if st.saved[o] < 1 then
                    o.Transparency = st.saved[o] + (1 - st.saved[o]) * alpha
                end
            end
        end
        go(inst)
        for _, d in ipairs(inst:GetDescendants()) do go(d) end
    end

    local function hookPlot(plot, run)
        if not plot or run ~= st.run then return end
        for _, n in ipairs(NAMES) do
            local c = plot:FindFirstChild(n)
            if c then
                paint(c, math.clamp(tonumber(_G.LustBaseXRayTransparency) or 0.5, 0, 1), run)
                table.insert(st.conns, c.DescendantAdded:Connect(function(d)
                    paint(d, math.clamp(tonumber(_G.LustBaseXRayTransparency) or 0.5, 0, 1), run)
                end))
            end
        end
        table.insert(st.conns, plot.ChildAdded:Connect(function(ch)
            if run ~= st.run then return end
            if table.find(NAMES, ch.Name) then paint(ch, 0.5, run) end
        end))
    end

    _G.LustSetBaseXRay = function(on)
        _G.LustBaseXRayEnabled = on == true
        st.run = st.run + 1
        for _, c in ipairs(st.conns) do pcall(function() c:Disconnect() end) end
        st.conns = {}

        if not _G.LustBaseXRayEnabled then
            local saved = st.saved
            st.saved = {}
            for k, v in pairs(saved) do
                pcall(function()
                    if k and k.Parent then k.Transparency = v end
                end)
            end
            return
        end

        local run = st.run
        local plots = workspace:FindFirstChild("Plots")
        if not plots then return end
        for _, p in ipairs(plots:GetChildren()) do hookPlot(p, run) end
        table.insert(st.conns, plots.ChildAdded:Connect(function(p)
            task.wait(0.15)
            hookPlot(p, run)
        end))
    end
end

antiRagdollController = {}
do
    local data = {
        active = false,
        isBoosting = false,
        cachedChar = nil,
        ragdollConnections = {},
        _lastBoostTime = 0,
        gen = 0,
    }
    local function disconnectAllV1()
        for _, c in ipairs(data.ragdollConnections) do
            pcall(function() c:Disconnect() end)
        end
        data.ragdollConnections = {}
    end
    local function cacheCharacterV1()
        local character = LP.Character
        if not character then return false end
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        local hrp = character:FindFirstChild("HumanoidRootPart")
        if not humanoid or not hrp then return false end
        data.cachedChar = { character = character, humanoid = humanoid, root = hrp }
        return true
    end
    local function isRagdolledV1()
        if not data.cachedChar or not data.cachedChar.humanoid then return false end
        local humanoid = data.cachedChar.humanoid
        if not humanoid.Parent then return false end
        return ({
            [Enum.HumanoidStateType.Physics] = true,
            [Enum.HumanoidStateType.Ragdoll] = true,
            [Enum.HumanoidStateType.FallingDown] = true,
        })[humanoid:GetState()] or false
    end
    local function forceExitRagdollV1()
        if not data.cachedChar or not data.cachedChar.humanoid or not data.cachedChar.root then return end
        local humanoid = data.cachedChar.humanoid
        local root = data.cachedChar.root
        if not humanoid.Parent or not root.Parent then return end
        pcall(function() LP:SetAttribute("RagdollEndTime", workspace:GetServerTimeNow()) end)
        for _, d in ipairs(data.cachedChar.character:GetDescendants()) do
            local kill = d:IsA("BallSocketConstraint")
                or (d:IsA("Attachment") and d.Name:find("RagdollAttachment") ~= nil)
            if kill then pcall(function() d:Destroy() end) end
        end
        local speed = getActiveMoveSpeed()
        if not data.isBoosting then
            data.isBoosting = true
            data._lastBoostTime = _tick()
        end
        pcall(function() humanoid.WalkSpeed = speed end)
        if humanoid.Health > 0 then
            pcall(function() humanoid:ChangeState(Enum.HumanoidStateType.Running) end)
        end
        pcall(function() root.Anchored = false end)
    end
    local function loopV1(myGen)
        while data.active and data.gen == myGen do
            task.wait(0.05)
            if not (data.active and data.gen == myGen) then break end
            if dropActive or _G.IsDropping then

            elseif isRagdolledV1() then
                forceExitRagdollV1()
            elseif data.isBoosting then
                if _tick() - (data._lastBoostTime or 0) > 0.35 or not isRagdolledV1() then
                    data.isBoosting = false
                    if data.cachedChar and data.cachedChar.humanoid then
                        pcall(function() data.cachedChar.humanoid.WalkSpeed = getActiveMoveSpeed() end)
                    end
                end
            end
        end
    end
    antiRagdollController.start = function()
        if data.active then return true end
        antiRagdollController.stop()
        if not cacheCharacterV1() then return false end
        data.gen = data.gen + 1
        local myGen = data.gen
        data.active = true
        data.isBoosting = false
        table.insert(data.ragdollConnections, _LustOn(RunService.RenderStepped, function()
            local cam = workspace.CurrentCamera
            if cam and data.cachedChar and data.cachedChar.humanoid then
                cam.CameraSubject = data.cachedChar.humanoid
            end
        end))
        table.insert(data.ragdollConnections, _LustOn(LP.CharacterAdded, function()
            data.isBoosting = false
            task.wait(0.5)
            if data.active and data.gen == myGen then cacheCharacterV1() end
        end))
        task.spawn(loopV1, myGen)
        return true
    end
    antiRagdollController.stop = function()
        data.gen = data.gen + 1
        data.active = false
        if data.isBoosting and data.cachedChar and data.cachedChar.humanoid then
            pcall(function() data.cachedChar.humanoid.WalkSpeed = getActiveMoveSpeed() end)
        end
        data.isBoosting = false
        disconnectAllV1()
        data.cachedChar = nil
    end
    antiRagdollController.isRunning = function() return data.active end
end

AntiRagdollV2 = { Enabled = false, Connection = nil, ResetCooldown = 0 }

function startAntiRagdollV2()
    if AntiRagdollV2.Connection then return end
    AntiRagdollV2.Enabled = true
    AntiRagdollV2.Connection = _LustOn(RunService.Heartbeat, function()
        if not AntiRagdollV2.Enabled then return end
        local character = LP.Character
        if not character then return end
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        local root = character:FindFirstChild("HumanoidRootPart")
        if not humanoid or not root then return end
        if humanoid.Health <= 0 or humanoid:GetState() == Enum.HumanoidStateType.Dead then return end
        if dropActive or _G.IsDropping then return end
        local state = humanoid:GetState()
        local now = _tick()
        if state == Enum.HumanoidStateType.Physics
           or state == Enum.HumanoidStateType.Ragdoll
           or state == Enum.HumanoidStateType.FallingDown then
            if now - AntiRagdollV2.ResetCooldown > 0.15 then
                AntiRagdollV2.ResetCooldown = now
                pcall(function()
                    if humanoid:GetState() == Enum.HumanoidStateType.GettingUp then return end
                    if humanoid.Health <= 0 or humanoid:GetState() == Enum.HumanoidStateType.Dead then return end
                    humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
                    root.Velocity = _V3zero
                    root.RotVelocity = _V3zero
                    root.AssemblyLinearVelocity = _V3zero
                    root.AssemblyAngularVelocity = _V3zero
                    for _, d in ipairs(character:GetDescendants()) do
                        if d:IsA("Motor6D") then d.Enabled = true end
                        if d:IsA("Constraint") then d.Enabled = true end
                    end
                    workspace.CurrentCamera.CameraSubject = humanoid
                    local PM = LP.PlayerScripts:FindFirstChild("PlayerModule")
                    if PM then
                        local CM = require(PM:FindFirstChild("ControlModule"))
                        if CM then CM:Enable() end
                    end
                    humanoid.AutoRotate = true
                    humanoid.PlatformStand = false
                    humanoid.Sit = false
                end)
            end
        end
    end)
end

function stopAntiRagdollV2()
    AntiRagdollV2.Enabled = false
    if AntiRagdollV2.Connection then AntiRagdollV2.Connection:Disconnect(); AntiRagdollV2.Connection = nil end
    AntiRagdollV2.ResetCooldown = 0
end

_antiRagLastOn = _antiRagLastOn or "v2"
ANTIRAG_NAMES = { v1 = "Purge", v2 = "Recover" }
_antiRagSel = nil
_antiRagSyncing = false

function stopAntiRagdollAll()
    pcall(antiRagdollController.stop)
    pcall(stopAntiRagdollV2)
end

function applyAntiRagdollMode(mode)
    if mode ~= "v1" and mode ~= "v2" then mode = "off" end
    stopAntiRagdollAll()
    antiRagdollMode = mode
    if mode == "v1" then
        antiRagdollController.start()
    elseif mode == "v2" then
        startAntiRagdollV2()
    end
    if mode ~= "off" then _antiRagLastOn = mode end
end

function antiRagdollIsRunning()
    if antiRagdollMode == "v1" then return antiRagdollController.isRunning() end
    if antiRagdollMode == "v2" then return AntiRagdollV2.Connection ~= nil end
    return false
end

function antiRagdollSyncUI()
    if setAntiRagVisual then setAntiRagVisual(antiRagdollMode ~= "off") end
    if _antiRagSel then
        _antiRagSyncing = true
        pcall(_antiRagSel.setByValue, ANTIRAG_NAMES[_antiRagLastOn] or ANTIRAG_NAMES.v2, true)
        _antiRagSyncing = false
    end
end

function setAntiRagdollMode(mode)
    applyAntiRagdollMode(mode)
    antiRagdollSyncUI()
    saveAllSettings()
end

_LustOn(LP.CharacterAdded, function()
    task.wait(0.5)
    if antiRagdollMode ~= "off" then applyAntiRagdollMode(antiRagdollMode) end
end)

antiDieEnabled      = false
_antiDieEnabled     = false
_antiDieStopped     = false
_antiDieUserPref    = false
_antiDieSources     = { toggle = false, autobat = false, float = false }

local antiDieConnections   = {}
local antiDieCharAddedConn = nil
local _antiDieInvincibleUntil = 0
local _antiDieHeartbeatConn   = nil

_antiDieConfig = {
    healthThreshold     = 25,
    invincibilityFrames = 0.5,
    blockDeadState      = true,
    blockDamageEvents   = true,
    autoRepairCharacter = true,
}

local function _antiDieSuperHeal(hum)
    if not hum or not hum.Parent then return end
    if tick() < _antiDieInvincibleUntil then return end
    local maxHP = hum.MaxHealth or 100
    hum.Health = maxHP
    _antiDieInvincibleUntil = tick() + _antiDieConfig.invincibilityFrames
    pcall(function()
        local char = hum.Parent
        if not char then return end
        for _, child in ipairs(char:GetChildren()) do
            if child:IsA("NumberValue") then
                local n = child.Name:lower()
                if n:find("health") or n:find("hp") or n:find("life") then
                    child.Value = maxHP
                end
            end
            if child:IsA("BoolValue") and child.Name:lower():find("dead") then
                child.Value = false
            end
        end
    end)
end

local function _antiDieRepairCharacter(char)
    if not char then return end
    if not char.Parent then return end
    local hum  = char:FindFirstChildOfClass("Humanoid")
    local root = char:FindFirstChild("HumanoidRootPart")
    if not hum or not root then return end
    if hum.RigType ~= Enum.HumanoidRigType.R6 then return end
    local needed = {"Head","Torso","Left Arm","Right Arm","Left Leg","Right Leg"}
    for _, partName in ipairs(needed) do
        if not char:FindFirstChild(partName) then
            local p = Instance.new("Part")
            p.Name        = partName
            p.Size        = Vector3.new(2, 1, 1)
            p.Transparency = 1
            p.CanCollide  = false
            p.CanTouch    = false
            p.CanQuery    = false
            p.Massless    = true
            p.Anchored    = false
            p.Material    = Enum.Material.SmoothPlastic
            p.CFrame      = root.CFrame + Vector3.new(0, 2, 0)
            p.Parent      = char
            local m       = Instance.new("Motor6D")
            m.Part0       = root
            m.Part1       = p
            m.Parent      = p
        end
    end
end

local function _antiDieBlockDamage(hum, conns)
    pcall(function()
        local orig = hum.TakeDamage
        hum.TakeDamage = function(self, amount)
            if amount and amount > 0 then
                _antiDieSuperHeal(hum)
                return
            end
            return orig(self, amount)
        end
    end)
    pcall(function()
        table.insert(conns, hum.Damage:Connect(function(amount)
            if amount and amount > 0 then
                _antiDieSuperHeal(hum)
            end
        end))
    end)
end

local function applyGodMode(character)
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then
        humanoid = character:WaitForChild("Humanoid", 5)
        if not humanoid then return end
    end

    local conns = {}
    local _godTasks = {}
    if antiDieConnections[character] then return end
    antiDieConnections[character] = {conns = conns, tasks = _godTasks}
    local function _spawnGodTask(fn)
        local t = task.spawn(fn)
        table.insert(_godTasks, t)
    end
    local function _addConn(c)
        table.insert(conns, c)
        return c
    end

    local root = character:FindFirstChild("HumanoidRootPart")
    if not root then
        root = Instance.new("Part")
        root.Name        = "HumanoidRootPart"
        root.Size        = Vector3.new(2, 1, 1)
        root.Transparency = 1
        root.CanCollide  = false
        root.Anchored    = false
        root.Parent      = character
        pcall(function() humanoid:SetRootPart(root) end)
    end

    humanoid.BreakJointsOnDeath = false
    humanoid.RequiresNeck       = false

    local healthScript = character:FindFirstChild("Health")
    if healthScript then healthScript:Destroy() end

    if not character:FindFirstChild("ForceField") then
        local ff = Instance.new("ForceField")
        ff.Visible = false
        ff.Parent  = character
    end

    if _antiDieConfig.blockDeadState then
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
    end
    humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
    humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
    pcall(function() humanoid:SetStateEnabled(Enum.HumanoidStateType.GettingUp, false) end)

    _addConn(humanoid.StateChanged:Connect(function(_, newState)
        if newState == Enum.HumanoidStateType.Dead
        or newState == Enum.HumanoidStateType.Ragdoll
        or newState == Enum.HumanoidStateType.FallingDown then
            humanoid:ChangeState(Enum.HumanoidStateType.Running)
        end
    end))

    _addConn(humanoid:GetPropertyChangedSignal("Health"):Connect(function()
        if humanoid.Health <= 0 or humanoid.Health <= _antiDieConfig.healthThreshold then
            _antiDieSuperHeal(humanoid)
        end
        if humanoid.Health > humanoid.MaxHealth then
            humanoid.Health = humanoid.MaxHealth
        end
    end))

    _addConn(humanoid.Died:Connect(function()
        task.wait(0.05)
        if humanoid and humanoid.Parent then
            _antiDieSuperHeal(humanoid)
        end
    end))

    _addConn(humanoid:GetPropertyChangedSignal("MaxHealth"):Connect(function()
        if humanoid.MaxHealth < 100 then
            humanoid.MaxHealth = 100
        end
        if humanoid.Health > humanoid.MaxHealth then
            humanoid.Health = humanoid.MaxHealth
        end
        if humanoid.Health <= 0 then
            _antiDieSuperHeal(humanoid)
        end
    end))

    if _antiDieConfig.blockDamageEvents then
        _antiDieBlockDamage(humanoid, conns)
    end

    _addConn(humanoid:GetPropertyChangedSignal("BreakJointsOnDeath"):Connect(function()
        if humanoid.BreakJointsOnDeath == true then
            humanoid.BreakJointsOnDeath = false
        end
    end))

    pcall(function() humanoid.BreakJoints = function() end end)
    pcall(function() character.BreakJoints = function() end end)

    local function _protectJoint(desc)
        if not desc:IsA("Motor6D") then return end
        _addConn(desc.AncestryChanged:Connect(function(_, parent)
            if parent then return end
            if not character.Parent or not antiDieEnabled then return end
            local hm = character:FindFirstChildOfClass("Humanoid")
            if not hm or hm.Health <= 0 then return end
            local p0, p1 = desc.Part0, desc.Part1
            if not p0 or not p1 then return end
            if not p0:IsDescendantOf(character) or not p1:IsDescendantOf(character) then return end
            task.defer(function()
                if not character.Parent or not p0.Parent or not p1.Parent then return end
                for _, other in ipairs(p0:GetChildren()) do
                    if other:IsA("Motor6D") and other.Part0 == p0 and other.Part1 == p1 then return end
                end
                for _, other in ipairs(p1:GetChildren()) do
                    if other:IsA("Motor6D") and other.Part0 == p0 and other.Part1 == p1 then return end
                end
                pcall(function()
                    local clone = desc:Clone()
                    clone.Part0 = p0
                    clone.Part1 = p1
                    clone.Parent = p0
                end)
            end)
        end))
    end
    for _, desc in pairs(character:GetDescendants()) do
        _protectJoint(desc)
    end
    _addConn(character.DescendantAdded:Connect(_protectJoint))

    for _, part in pairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            _addConn(part.Touched:Connect(function(hit)
                if hit and hit.Parent then
                    if Players:GetPlayerFromCharacter(hit.Parent) or Players:GetPlayerFromCharacter(hit.Parent.Parent) then return end
                    local hn = string.lower(hit.Name)
                    if hn:find("kill") or hn:find("damage") or hn:find("lava")
                    or hn:find("fire") or hn:find("spike") then
                        pcall(function()
                            hit.CanTouch = false
                            local ti = hit:FindFirstChild("TouchInterest")
                            if ti then ti:Destroy() end
                        end)
                    end
                end
            end))
        end
    end

    _addConn(character.ChildAdded:Connect(function(child)
        task.defer(function()
        if not child.Parent then return end
        if child:IsA("Explosion") or child:IsA("Fire") or child:IsA("Smoke") then
            child:Destroy()
        end
        if child:IsA("Tool") then
            for _, p in pairs(child:GetDescendants()) do
                if p:IsA("BasePart") then
                    p.CanTouch = false
                    local ti = p:FindFirstChild("TouchInterest")
                    if ti then ti:Destroy() end
                end
            end
        end
        end)
    end))

    local _criticalParts = {"Head","UpperTorso","Torso","HumanoidRootPart",
                            "LeftArm","RightArm","LeftLeg","RightLeg",
                            "Left Arm","Right Arm","Left Leg","Right Leg"}
    _addConn(character.ChildRemoved:Connect(function(child)
        if not character.Parent or not antiDieEnabled then return end
        if child.Name == "HumanoidRootPart" then
            local newRoot = Instance.new("Part")
            newRoot.Name        = "HumanoidRootPart"
            newRoot.Size        = Vector3.new(2, 1, 1)
            newRoot.Transparency = 1
            newRoot.CanCollide  = false
            newRoot.Anchored    = false
            newRoot.CFrame      = CFrame.new(character:GetPivot().Position)
            newRoot.Parent      = character
            root = newRoot
            pcall(function() humanoid.RootPart = root end)
        end
        for _, nm in ipairs(_criticalParts) do
            if child.Name == nm then
                task.wait(0.05)
                _antiDieSuperHeal(humanoid)
                _antiDieRepairCharacter(character)
                break
            end
        end
    end))

    if _antiDieConfig.autoRepairCharacter then
        _antiDieRepairCharacter(character)
    end

    -- Un solo bucle de mantenimiento (antes eran 3 hilos: 0.1s / 1s / 2s).
    _spawnGodTask(function()
        local tick2 = 0
        while character and character.Parent and antiDieEnabled do
            task.wait(0.1)
            if not antiDieEnabled then break end
            pcall(function()
                if humanoid.Health < humanoid.MaxHealth then
                    _antiDieSuperHeal(humanoid)
                end
                if humanoid.BreakJointsOnDeath == true then
                    humanoid.BreakJointsOnDeath = false
                end
                if humanoid.RequiresNeck == true then
                    humanoid.RequiresNeck = false
                end
                if _antiDieConfig.blockDeadState then
                    humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
                end
                if not character:FindFirstChild("ForceField") then
                    local nff = Instance.new("ForceField")
                    nff.Visible = false
                    nff.Parent  = character
                end
            end)
            tick2 = tick2 + 1
            if tick2 >= 20 then
                tick2 = 0
                pcall(function()
                    humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
                    humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
                    if _antiDieConfig.autoRepairCharacter then
                        _antiDieRepairCharacter(character)
                    end
                end)
            end
        end
    end)

    _antiDieSuperHeal(humanoid)
end

local function startAntiDie(silent)
    if next(antiDieConnections) ~= nil or antiDieCharAddedConn then
        antiDieEnabled  = true
        _antiDieEnabled = true
        return
    end

    antiDieEnabled  = true
    _antiDieEnabled = true

    if not _antiDieHeartbeatConn then
        _antiDieHeartbeatConn = _LustOn(RunService.Heartbeat, function()
            if not antiDieEnabled then return end
            local char = LP.Character
            if not char then return end
            local hum = char:FindFirstChildOfClass("Humanoid")
            if not hum then return end
            if hum.Health <= 0 or hum.Health <= _antiDieConfig.healthThreshold then
                _antiDieSuperHeal(hum)
            end
        end)
    end

    if LP.Character then
        applyGodMode(LP.Character)
    end

    antiDieCharAddedConn = _LustOn(LP.CharacterAdded, function(newChar)
        task.wait(0.1)
        for ch, entry in pairs(antiDieConnections) do
            if ch ~= newChar and not ch.Parent then
                local list = (type(entry) == "table" and entry.conns) or {}
                for _, c in ipairs(list) do pcall(function() c:Disconnect() end) end
                if type(entry) == "table" and entry.tasks then
                    for _, t in ipairs(entry.tasks) do pcall(function() task.cancel(t) end) end
                end
                antiDieConnections[ch] = nil
            end
        end
        if antiDieEnabled then
            applyGodMode(newChar)
        end
    end)

    if not silent then
        if setAntiDieVisual then setAntiDieVisual(true) end
        saveAllSettings()
    end
end

local function stopAntiDie(silent)
    antiDieEnabled  = false
    _antiDieEnabled = false

    if _antiDieHeartbeatConn then
        _antiDieHeartbeatConn:Disconnect()
        _antiDieHeartbeatConn = nil
    end

    for character, entry in pairs(antiDieConnections) do
        local connList = (type(entry) == "table" and entry.conns) or entry
        if connList then
            for _, conn in ipairs(connList) do
                pcall(function() conn:Disconnect() end)
            end
        end
        if type(entry) == "table" and entry.tasks then
            for _, t in ipairs(entry.tasks) do
                pcall(function() task.cancel(t) end)
            end
        end
        pcall(function()
            local hum = character:FindFirstChildOfClass("Humanoid")
            if hum then
                hum:SetStateEnabled(Enum.HumanoidStateType.Dead, true)
                hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, true)
                hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
                pcall(function() hum:SetStateEnabled(Enum.HumanoidStateType.GettingUp, true) end)
                hum.BreakJointsOnDeath = true
                hum.RequiresNeck       = true
            end
        end)
        pcall(function()
            local ff = character:FindFirstChildOfClass("ForceField")
            if ff then ff:Destroy() end
        end)
    end
    antiDieConnections = {}

    if antiDieCharAddedConn then
        antiDieCharAddedConn:Disconnect()
        antiDieCharAddedConn = nil
    end

    local char = LP.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            pcall(function()
                hum:SetStateEnabled(Enum.HumanoidStateType.Dead, true)
                hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, true)
                hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
                pcall(function() hum:SetStateEnabled(Enum.HumanoidStateType.GettingUp, true) end)
                hum.BreakJointsOnDeath = true
                hum.RequiresNeck       = true
            end)
        end
        pcall(function()
            local ff = char:FindFirstChildOfClass("ForceField")
            if ff then ff:Destroy() end
        end)
    end

    _antiDieInvincibleUntil = 0

    if not silent then
        if setAntiDieVisual then setAntiDieVisual(false) end
        saveAllSettings()
    end
end

function _antiDieSetEnabled(enabled)
    enabled = enabled == true
    local running = antiDieCharAddedConn ~= nil
    if enabled == running then
        antiDieEnabled  = enabled
        _antiDieEnabled = enabled
        return
    end
    _antiDieEnabled = enabled
    if enabled then startAntiDie(true) else stopAntiDie(true) end
end

function _antiDieRefresh()
    if _antiDieStopped then return end
    _antiDieSetEnabled(_antiDieSources.toggle or _antiDieSources.autobat or _antiDieSources.float)
end

_G.__CrystalAntiDieSource = function(source, enabled)
    if _antiDieStopped or _antiDieSources[source] == nil then return end
    _antiDieSources[source] = enabled == true
    _antiDieRefresh()
end
_G.__CrystalAntiDieSet = function(enabled) _G.__CrystalAntiDieSource("autobat", enabled) end
_G.__CrystalAntiDieIsEnabled = function() return antiDieEnabled == true end
_G.__CrystalAntiDieStop = function()
    _antiDieStopped = true
    _antiDieSources.toggle = false
    _antiDieSources.autobat = false
    _antiDieSources.float = false
    _antiDieSetEnabled(false)
end

function activateOnCharacter(char)
    if not antiDieEnabled then return end
    applyGodMode(char)
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if hum then _antiDieSuperHeal(hum) end
end

AntiDieModule = {
    enabled = false,
    start = function()
        AntiDieModule.enabled = true
        _antiDieStopped = false
        _G.__CrystalAntiDieSource("toggle", true)
    end,
    stop = function()
        AntiDieModule.enabled = false
        _G.__CrystalAntiDieSource("toggle", false)
    end,
}
_G.AntiDie = AntiDieModule

function _G.__LustAntiDieArm(timeout)
    if _antiDieStopped then return false end
    _antiDieSources.float = true
    _antiDieRefresh()
    local function armed()
        if not antiDieEnabled then return false end
        local c = LP.Character
        if not c then return true end
        return antiDieConnections[c] ~= nil
    end
    if armed() then return true end
    if LP.Character then pcall(applyGodMode, LP.Character) end
    local deadline = os.clock() + (tonumber(timeout) or 0.5)
    while os.clock() < deadline do
        if armed() then return true end
        RunService.Heartbeat:Wait()
    end
    return armed()
end

function _G.__LustAntiDieRelease(delay)
    task.delay(tonumber(delay) or 1.5, function()
        local F = _G.__LustFloat
        if F and F.running then return end
        _antiDieSources.float = false
        pcall(_antiDieRefresh)
    end)
end

espEnabled = espEnabled or false
espActivePlayers = {}
espLoopConn = nil
Camera = workspace.CurrentCamera
GUI2_ESP_COLOR = Color3.fromRGB(139, 72, 246)
GUI2_ESP_TEXT_STROKE = Color3.fromRGB(48, 16, 92)

function getESPThemeColors(accent)
    local c = getThemeColor() or accent or Color3.fromRGB(245, 245, 250)
    return c, Color3.fromRGB(0, 0, 0)
end

function createESP()
    local currentFill, currentLine = getESPThemeColors()
    local esp = { Tracer = Drawing and Drawing.new("Line") or nil, Highlight = Instance.new("Highlight"), Lines = {} }
    if esp.Tracer then
        esp.Tracer.Color = currentLine; esp.Tracer.Thickness = 3; esp.Tracer.Transparency = 1; esp.Tracer.ZIndex = 2
    end
    esp.Highlight.Name = "LustESP_Highlight"
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
    nameBillboard.Name = "LustESP_Name"
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
            line.Color = currentLine; line.Thickness = 2; line.Transparency = 1; line.ZIndex = 3
            table.insert(esp.Lines, line)
        end
    end
    esp.NameTag = nameBillboard
    esp.NameLabel = nameLabel
    esp.NameOutline = nameOutline
    return esp
end

_G.__LustRefreshESPTheme = function(accent, outlineColor)
    local fillColor, lineColor = getESPThemeColors(accent)
    for _, data in pairs(espActivePlayers) do
        if type(data) == "table" and data.esp then
            local esp = data.esp
            if esp.Tracer then pcall(function() esp.Tracer.Color = lineColor end) end
            if esp.Highlight then esp.Highlight.FillColor = fillColor; esp.Highlight.OutlineColor = Color3.fromRGB(0, 0, 0) end
            if esp.NameLabel then
                esp.NameLabel.TextColor3 = getThemeColor()
                esp.NameLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
            end
            if esp.NameOutline then esp.NameOutline.Color = Color3.fromRGB(0, 0, 0) end
            for _, line in ipairs(esp.Lines or {}) do pcall(function() line.Color = lineColor end) end
        end
    end
end

function removeESP(plr)
    local data = espActivePlayers[plr]
    if data then
        if data.esp.Tracer then pcall(function() data.esp.Tracer:Remove() end) end
        if data.esp.Highlight then pcall(function() data.esp.Highlight:Destroy() end) end
        if data.esp.NameTag then pcall(function() data.esp.NameTag:Destroy() end) end
        for _, line in ipairs(data.esp.Lines) do pcall(function() line:Remove() end) end
        espActivePlayers[plr] = nil
    end
end

function updateESP(plr, esp)
    if not espEnabled then
        if esp.Tracer then esp.Tracer.Visible = false end
        esp.Highlight.Enabled = false
        for _, line in ipairs(esp.Lines) do line.Visible = false end
        if esp.NameTag then esp.NameTag.Enabled = false end
        return
    end
    local character = plr.Character
    local hum = character and character:FindFirstChildOfClass("Humanoid")
    local trackPart = character and (character:FindFirstChild("HumanoidRootPart") or character.PrimaryPart or character:FindFirstChild("UpperTorso") or character:FindFirstChild("Torso") or character:FindFirstChild("Head"))
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

function createESPForPlayer(plr)
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

espJoinConn, espLeaveConn = nil, nil

function enableESP()
    if espEnabled then return end
    espEnabled = true
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LP then task.spawn(function() createESPForPlayer(plr) end) end
    end
    local espAccumulator = 0
    if espLoopConn then espLoopConn:Disconnect() end
    espLoopConn = _LustOn(RunService.Heartbeat, function(dt)
        espAccumulator = espAccumulator + (dt or 0)
        if espAccumulator < 0.033 then return end
        espAccumulator = 0
        for plr, data in pairs(espActivePlayers) do
            if typeof(plr) == "Instance" and plr:IsA("Player") and data and data.esp then
                pcall(function() updateESP(plr, data.esp) end)
            end
        end
    end)
    espJoinConn = _LustOn(Players.PlayerAdded, function(plr)
        if not espEnabled or plr == LP then return end
        task.wait(0.3)
        createESPForPlayer(plr)
    end)
    espLeaveConn = _LustOn(Players.PlayerRemoving, function(plr) removeESP(plr) end)
end

function disableESP()
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

_espLineGui = nil; _espLineFrame = nil; _espLineOutline = nil; _espLineConn = nil
_espLineState = { scanElapsed = math.huge, targetRoot = nil }

function ensureESPLineGui()
    if _espLineGui and _espLineGui.Parent then return end
    _espLineGui = Instance.new("ScreenGui")
    _espLineGui.Name = "LustESPLine"
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
    if _espLineGui and _espLineGui.Parent then pcall(function() _espLineGui:Destroy() end) end
    _espLineGui = nil; _espLineFrame = nil; _espLineOutline = nil
end

function startESPLine()
    espLineEnabled = true
    ensureESPLineGui()
    if _espLineConn then _espLineConn:Disconnect() end
    _espLineState.scanElapsed = math.huge
    _espLineState.targetRoot = nil
    _espLineConn = _LustOn(RunService.RenderStepped, function(dt)
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
            if _espLineState.scanElapsed >= 0.05 or not cachedValid then
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
                            if distanceSq < closestDistanceSq then closestRoot, closestDistanceSq = root, distanceSq end
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

_enemySpeedAcc = 0

function updateEnemySpeedLabels()
    _enemySpeedAcc = _enemySpeedAcc + 1
    if _enemySpeedAcc < 2 then return end
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
    enemySpeedConn = _LustOn(RunService.Heartbeat, updateEnemySpeedLabels)
end

function stopEnemySpeed()
    if enemySpeedConn then enemySpeedConn:Disconnect(); enemySpeedConn = nil end
end

function getClosestTargetBody()
    local char = LP.Character; if not char then return nil end
    local root = char:FindFirstChild("HumanoidRootPart"); if not root then return nil end
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

function _bodyLockTick()
    local char = LP.Character; if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart"); if not root then return end
    local hum = char:FindFirstChildOfClass("Humanoid"); if not hum then return end
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
    _bodyLockConn = _LustOn(RunService.Heartbeat, function(dt)
        if not bodyLockEnabled then return end
        if _blSuppressCount > 0 then return end
        acc = acc + dt
        if acc < 0.033 then return end
        acc = 0
        _bodyLockTick()
    end)
end

function stopBodyLock()
    if _bodyLockConn then _bodyLockConn:Disconnect(); _bodyLockConn = nil end
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
        if _blRestoreTimer then task.cancel(_blRestoreTimer); _blRestoreTimer = nil end
        _blSmoothRestore = false
    end
end

function _unsuppressBodyLock(delayed)
    if _blSuppressCount > 0 then _blSuppressCount = _blSuppressCount - 1 end
    if _blSuppressCount == 0 and _blWasEnabled then
        _blWasEnabled = false
        if _blRestoreTimer then pcall(task.cancel, _blRestoreTimer); _blRestoreTimer = nil end
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
    local head = char:WaitForChild("Head", 5); if not head then return end
    local oldBB = head:FindFirstChild("LustSpeedIndicator"); if oldBB then oldBB:Destroy() end
    local oldDiscord = head:FindFirstChild("DiscordText"); if oldDiscord then oldDiscord:Destroy() end
    local bb = Instance.new("BillboardGui", head)
    bb.Name = "LustSpeedIndicator"
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
    discordLabel.Text = "discord.gg/lusthub"
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

unwalkSavedAnimate = nil

function startUnwalk()
    local c = LP.Character; if not c then return end
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
            if starterAnim then starterAnim:Clone().Parent = c
            elseif unwalkSavedAnimate then unwalkSavedAnimate:Clone().Parent = c end
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
    if mobSetCarry then mobSetCarry(speedMode) end
    if mobSetLagger1 then mobSetLagger1(laggerToggled) end
    if mobSetLagger2 then mobSetLagger2(laggerCarryToggled) end
end

function resetMovementState()
    refreshSpeedModeLabel()
end

function toggleCarryMode()
    if laggerToggled or laggerCarryToggled then
        laggerToggled = false; laggerCarryToggled = false; speedMode = true
    else speedMode = not speedMode end
    resetMovementState()
    if _G.__LustApplySpeedNow then pcall(_G.__LustApplySpeedNow) end
    task.defer(function() pcall(saveAllSettings) end)
end

function toggleLaggerMode()
    if laggerCarryToggled then laggerCarryToggled = false end
    speedMode = false; laggerToggled = not laggerToggled
    resetMovementState()
    if _G.__LustApplySpeedNow then pcall(_G.__LustApplySpeedNow) end
    task.defer(function() pcall(saveAllSettings) end)
end

function toggleLaggerCarryMode()
    if laggerToggled then laggerToggled = false end
    speedMode = false; laggerCarryToggled = not laggerCarryToggled
    resetMovementState()
    if _G.__LustApplySpeedNow then pcall(_G.__LustApplySpeedNow) end
    task.defer(function() pcall(saveAllSettings) end)
end

function toggleLaggerCycle()
    if speedMode then speedMode = false; laggerToggled = true; laggerCarryToggled = false
    elseif laggerToggled then speedMode = false; laggerToggled = false; laggerCarryToggled = true
    else speedMode = true; laggerToggled = false; laggerCarryToggled = false end
    resetMovementState()
    if _G.__LustApplySpeedNow then pcall(_G.__LustApplySpeedNow) end
    task.defer(function() pcall(saveAllSettings) end)
end


-- ===================== AUTO CARRY (portado de Lust Hub) =====================
-- Normal = cambia a Carry al agarrar un brainrot | Lagger = cambia a Lagger Carry
do
    local ac = { applied = false, waiting = false, watchUntil = 0, graceUntil = 0, savedMode = nil, stealWasActive = false }

    local function currentMode()
        if laggerCarryToggled then return "Lagger Carry" end
        if laggerToggled then return "Lagger" end
        if speedMode then return "Carry" end
        return "Normal"
    end

    local function setMode(lagger, carry, laggerCarry)
        laggerCarryToggled = laggerCarry == true
        laggerToggled = (lagger == true) and not laggerCarryToggled
        speedMode = (carry == true) and not laggerCarryToggled and not laggerToggled
        if refreshSpeedModeLabel then pcall(refreshSpeedModeLabel) end
        if _G.__LustApplySpeedNow then pcall(_G.__LustApplySpeedNow) end
    end

    local function isWeaponName(name)
        local s = tostring(name or ""):lower()
        return s:find("bat", 1, true) or s:find("slap", 1, true) or s:find("medusa", 1, true)
            or s:find("head", 1, true) or s:find("stone", 1, true)
    end

    local function isCarrying()
        local character = LP.Character
        if not character then return false end
        for _, nm in ipairs({ "Carrying", "IsCarrying", "Grabbed", "Holding", "StealHold", "HasGrab" }) do
            local obj = character:FindFirstChild(nm, true)
            local val = false
            if obj then
                if obj:IsA("BoolValue") then val = obj.Value
                elseif obj:IsA("ObjectValue") then val = obj.Value ~= nil
                elseif obj:IsA("StringValue") then val = obj.Value ~= "" end
            end
            if val then return true end
        end
        for _, child in ipairs(character:GetChildren()) do
            local n = child.Name:lower()
            if child:IsA("Model") and child:FindFirstChildWhichIsA("BasePart", true) then
                if (child:FindFirstChildOfClass("Humanoid") and child:FindFirstChild("HumanoidRootPart"))
                    or n:find("brainrot") or n:find("animal") or n:find("carry")
                    or n:find("grab") or n:find("steal") then
                    return true
                end
            elseif child:IsA("Tool") and not isWeaponName(child.Name) then
                return true
            end
        end
        return false
    end

    local function apply()
        ac.waiting = false
        ac.watchUntil = 0
        if not ac.applied then ac.savedMode = currentMode() end
        ac.applied = true
        ac.graceUntil = _tick() + 0.75
        if autoCarryMode == "Lagger" then setMode(false, false, true)
        else setMode(false, true, false) end
    end

    local function restore()
        if not ac.applied and not ac.waiting then return end
        local applied, saved = ac.applied, ac.savedMode
        ac.applied = false; ac.waiting = false
        ac.watchUntil = 0; ac.graceUntil = 0; ac.savedMode = nil
        if not applied then return end
        if saved == "Lagger Carry" then setMode(false, false, true)
        elseif saved == "Lagger" then setMode(true, false, false)
        elseif saved == "Carry" then setMode(false, true, false)
        else setMode(false, false, false) end
    end

    local function watch(t)
        if not autoCarryEnabled then return end
        ac.waiting = true
        ac.watchUntil = _tick() + (t or 1.25)
    end

    _G.AutoCarrySpeed = { WatchPickup = watch, Restore = restore }
    _G.__LustAutoCarryRestore = restore
    _G.__LustAutoCarryReapply = function() if ac.applied then apply() end end

    _LustOn(RunService.RenderStepped, function()
        if not autoCarryEnabled then
            restore()
            return
        end
        local character = LP.Character
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        local root = character and character:FindFirstChild("HumanoidRootPart")
        if not character or not humanoid or not root then
            restore()
            ac.stealWasActive = false
            return
        end

        local st = humanoid:GetState()
        local bad = st == Enum.HumanoidStateType.Physics
            or st == Enum.HumanoidStateType.Ragdoll
            or st == Enum.HumanoidStateType.FallingDown
            or st == Enum.HumanoidStateType.Dead
        local stealing = LP:GetAttribute("Stealing") == true or character:GetAttribute("Stealing") == true
        local carrying = isCarrying()

        if stealing and not ac.stealWasActive then
            ac.stealWasActive = true
            apply()
        elseif not stealing then
            ac.stealWasActive = false
        end

        if ac.waiting then
            if bad or _tick() > ac.watchUntil then
                ac.waiting = false
                ac.watchUntil = 0
            elseif carrying then
                apply()
            end
        end

        if carrying and not ac.applied then apply() end

        if ac.applied then
            local release
            if bad then release = true
            else release = _tick() > ac.graceUntil and not carrying and not stealing end
            if release then restore() end
        end
    end)
end
-- ===================== FIN AUTO CARRY =====================

Config = Config or {}
Config.autoPlayVersion = "V1"
Config.autoPlayMode    = Config.autoPlayMode or "full"
Config.speedMethod     = "V1"
Config.v2UseCarry      = false
Config.stealToggled    = false
Config.isStealing      = false
Config._instaResetInProgress = false

local _apTbl49 = {
    _V3new(-475.86, -7,   91.97),
    _V3new(-485.83, -7,   97.37),
    _V3new(-475.86, -7,   91.97),
    _V3new(-476.35, -7,   27.88),
    _V3new(-477.09, -7,   19.85),
}
local _apTbl50 = {
    _V3new(-475.84, -7,   28.81),
    _V3new(-486.04, -7,   23.32),
    _V3new(-475.51, -7,   29.01),
    _V3new(-476.43, -7,   91.61),
    _V3new(-476.27, -7,   98.86),
}
local _apTbl51 = { _V3new(-476.48, -6.28, 92.73), _V3new(-483.12, -4.95, 94.8) }
local _apTbl52 = { _V3new(-476.16, -6.52, 25.62), _V3new(-483.06, -5.03, 25.48) }
-- Semi = rutas de Auto Left / Auto Right de Lust Hub
local _apSemiL = { _V3new(-476.48, -6.28, 92.73), _V3new(-483.12, -4.95, 94.8) }
local _apSemiR = { _V3new(-476.16, -6.28, 23.41), _V3new(-483.12, -5.03, 25.48) }
local _apSemiFaceL = _V3new(-482.25, -6.93, 92.09)
local _apSemiFaceR = _V3new(-482.06, -6.93, 35.47)
local function _apIsSemi() return Config.autoPlayMode == "semi" or Config.autoPlayMode == "half" end

local _apFlag11, _apStr4, _apN19, _apFlag13, _apV44, _apConn, _apThread4, _apFlag12, _apNow2
local _apCharConn
_apFlag11, _apStr4, _apN19, _apFlag13, _apV44 = false, "none", 1, false, nil
_apConn, _apThread4, _apFlag12, _apNow2, _apCharConn = nil, nil, false, nil, nil

local function _apDetectSide()
    local plotsRoot = workspace:FindFirstChild("Plots")
    if not plotsRoot then return "left" end
    for _, child in ipairs(plotsRoot:GetChildren()) do
        local sign = child:FindFirstChild("PlotSign")
        local yb   = sign and sign:FindFirstChild("YourBase")
        if yb and yb:IsA("BillboardGui") and yb.Enabled then
            local tgt = child:FindFirstChild("AnimalTarget", true)
            local pos = tgt and tgt.Position
            if not pos then
                local dhb = child:FindFirstChild("DeliveryHitbox")
                pos = dhb and dhb.Position
            end
            if pos and _apTbl49[1] and _apTbl50[1] then
                return (pos - _apTbl49[1]).Magnitude <= (pos - _apTbl50[1]).Magnitude and "left" or "right"
            end
            local pivotPos
            if typeof(child.GetPivot) == "function" then
                pcall(function() local p = child:GetPivot(); if p then pivotPos = p.Position end end)
            end
            if pivotPos then return pivotPos.Z >= 60 and "right" or "left" end
            local c = LP.Character
            local h = c and c:FindFirstChild("HumanoidRootPart")
            return (h and h.Position.Z >= 60) and "right" or "left"
        end
    end
    return "left"
end

function vxGetStealSpeed()
    if laggerCarryToggled then return LAGGER_CARRY_SPEED end
    if laggerToggled then return LAGGER_SPEED end
    if speedMode then return CS end
    return NS
end

local function _apApplySpeed(idx)
    _apFlag13 = (Config.autoPlayMode == "full") and (idx >= 2)
end

local function _apResolveSpeed()
    if _apIsSemi() then
        if laggerToggled or laggerCarryToggled then return LAGGER_SPEED end
        return NS
    end
    local autoAct = Config._isAutoplayActive and Config._isAutoplayActive()
    if autoAct and not _apFlag13 then
        return NS
    end
    if laggerCarryToggled then return LAGGER_CARRY_SPEED end
    if laggerToggled then return LAGGER_SPEED end
    if speedMode then return CS end
    return NS
end

function stopAutoPlay(arg)
    _apFlag13 = false
    if not arg then
        _apFlag12 = true
        if _apThread4 then pcall(task.cancel, _apThread4) end
        _apThread4 = task.delay(0.08, function() _apFlag12 = false end)
    end
    local wasActive = _apFlag11
    _apFlag11, _apStr4, _apN19 = false, "none", 1
    if _apConn then _apConn:Disconnect(); _apConn = nil end
    if _apCharConn then _apCharConn:Disconnect(); _apCharConn = nil end
    if wasActive then
        local c = LP.Character
        local hrp = c and c:FindFirstChild("HumanoidRootPart")
        local hum = c and c:FindFirstChildOfClass("Humanoid")
        if hum then pcall(function() hum:Move(_V3zero, false) end) end
        if hrp then
            pcall(function()
                _mvSetLV(hrp, 0, 0, 1/60)
                local v = hrp.AssemblyLinearVelocity
                hrp.AssemblyLinearVelocity = _V3new(0, v.Y, 0)
                lastMoveDir = _V3zero
            end)
        end
        -- Sin restos: escalones, velocidad falsa y estado de movimiento del auto play.
        pcall(_mvClear)
        if hum then pcall(function() hum.AutoRotate = true end) end
        if hrp then
            pcall(function()
                local st = hrp:FindFirstChild("LustSpeedStepLinearVelocity"); if st then st:Destroy() end
                local sa = hrp:FindFirstChild("LustSpeedStepAttachment"); if sa then sa:Destroy() end
            end)
        end
    end
    if arg then return end
    autoPlayEnabled = false
    if autoPlaySetVisual then autoPlaySetVisual(false) end
    if mobSetAutoPlay then mobSetAutoPlay(false) end
    task.defer(function() pcall(saveAllSettings) end)
end

function startAutoPlay(arg, arg2)
    if _apFlag12 then
        if _apThread4 then pcall(task.cancel, _apThread4); _apThread4 = nil end
        _apFlag12 = false
    end
    _apFlag12 = true
    if _apThread4 then pcall(task.cancel, _apThread4) end
    _apThread4 = task.delay(0.08, function() _apFlag12 = false end)
    if _apFlag11 then stopAutoPlay(true) end

    arg2 = arg or (_apDetectSide() == "left" and "right" or "left")
    _apV44, _apStr4, _apN19, _apFlag13, _apFlag11 = arg2, arg2, 1, false, true
    _apNow2 = nil

    if _apConn then _apConn:Disconnect() end
    _apConn = _LustOn(RunService.Heartbeat, function(dt)
        if Config._instaResetInProgress then return end
        if not _apFlag11 then return end
        if autoBatEnabled then
            pcall(_mvClear); return
        end
        if dropActive or _G.IsDropping then return end
        local isSemi = _apIsSemi()
        local path   = (_apStr4 == "left") and _apTbl49 or _apTbl50
        if isSemi then path = (_apStr4 == "left") and _apSemiL or _apSemiR end
        local wp = path[_apN19]
        if not wp then return end

        local char = LP.Character
        if not char then
            _apNow2 = _apNow2 or os.clock()
            if os.clock() - _apNow2 > 5 then stopAutoPlay() end
            return
        end
        _apNow2 = nil
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        local hum  = char:FindFirstChildOfClass("Humanoid")
        if isSemi and hum then
            local hs = hum:GetState()
            if hum.PlatformStand or hs == Enum.HumanoidStateType.Physics
                or hs == Enum.HumanoidStateType.Ragdoll or hs == Enum.HumanoidStateType.FallingDown then
                pcall(function() hum:Move(_V3zero, false) end)
                return
            end
        end
        local pos  = hrp.Position
        local tgt  = _V3new(wp.X, 0, wp.Z)
        local cur  = _V3new(pos.X, 0, pos.Z)
        local d    = (tgt - cur).Magnitude
        local hvel = _V3new(hrp.AssemblyLinearVelocity.X, 0, hrp.AssemblyLinearVelocity.Z)

        if d <= 1.1 and (hvel.Magnitude < 28 or d <= 0.4) then
            _mvSetLV(hrp, 0, 0, dt)
            if hum then pcall(function() hum:Move(_V3zero, false) end) end
            _apApplySpeed(_apN19)
            if _apN19 >= #path then
                local sideNow = _apStr4
                stopAutoPlay()
                if isSemi then
                    local face = (sideNow == "left") and _apSemiFaceL or _apSemiFaceR
                    pcall(function()
                        local p = hrp.Position
                        local look = _V3new(face.X, p.Y, face.Z)
                        if (look - p).Magnitude > 0.5 then hrp.CFrame = CFrame.new(p, look) end
                    end)
                end
                return
            end
            _apN19 = _apN19 + 1
        else
            local dir = tgt - cur
            if dir.Magnitude > 0.001 then dir = dir.Unit end
            local spd = _apResolveSpeed()
            if d < 1.5 then spd = spd * _clamp(d / 1.5, 0.6, 1) end
            if hum then
                pcall(function()
                    hum.AutoRotate = true
                    hum:Move(_V3new(dir.X, 0, dir.Z), false)
                end)
            end
            _mvSetLV(hrp, dir.X * spd, dir.Z * spd, dt)
        end
    end)

    autoPlayEnabled = true
    if autoPlaySetVisual then autoPlaySetVisual(true) end
    if mobSetAutoPlay then mobSetAutoPlay(true) end

    if _apCharConn then _apCharConn:Disconnect() end
    _apCharConn = _LustOn(LP.CharacterAdded, function()
        task.wait(0.5)
        if _apFlag11 then startAutoPlay(_apV44) end
    end)

    task.defer(function() pcall(saveAllSettings) end)
end

function Config._isAutoplayActive()
    return _apFlag11 == true
end

Config.autoPlayRestart = function()
    if _apFlag11 then startAutoPlay(_apV44) end
end

function toggleAutoPlay()
    if Config._isAutoplayActive() then
        stopAutoPlay()
    else
        startAutoPlay()
    end
end

function getClosestTarget()
    local char = LP.Character; if not char then return nil end
    local root = char:FindFirstChild("HumanoidRootPart"); if not root then return nil end
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
        local char = LP.Character; if not char then return end
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

if autoSwingEnabled == nil then autoSwingEnabled = true end
_lustAimbot = _lustAimbot or {
    conn = nil,
    attachmentName = "LustAimbotMoveAttachment",
    moverName = "LustAimbotMoveVelocity",
    minForce = 1000000,
    maxForce = 50000000,
    lustPred = {},
}

function _lustAimbot.getBat()
    local char = LP.Character
    if not char then return nil end
    for _, child in ipairs(char:GetChildren()) do
        local n = child.Name:lower()
        if child:IsA("Tool") and (n:find("bat") or n:find("slap")) then return child end
    end
    local backpack = LP:FindFirstChildOfClass("Backpack")
    if backpack then
        for _, child in ipairs(backpack:GetChildren()) do
            local n = child.Name:lower()
            if child:IsA("Tool") and (n:find("bat") or n:find("slap")) then return child end
        end
    end
    return nil
end

_lustAimbot.lustPred     = setmetatable({}, { __mode = "k" })
_lustAimbot.currentTarget = nil
_lustAimbot._lv           = nil
_lustAimbot._att          = nil
_lustAimbot._forceSpeed   = nil
_lustAimbot._lastSwing    = 0
_lustAimbot._ping         = 0.05
_lustAimbot._pingAt       = 0
_lustAimbot._remotes      = setmetatable({}, { __mode = "k" })

-- Elige el objetivo mas cercano, pero con histeresis para que no cambie de enemigo cada frame.
function _lustAimbot.nearestTarget(fromHRP)
    local self = _lustAimbot
    local from = fromHRP.Position
    local cur, curD = self.currentTarget, nil
    if cur and cur.Parent then
        local chum = cur.Parent:FindFirstChildOfClass("Humanoid")
        if chum and chum.Health > 0 then
            local d = cur.Position - from
            curD = d.X * d.X + d.Y * d.Y + d.Z * d.Z
        else
            cur = nil
        end
    else
        cur = nil
    end
    local best, bestHRP = _huge, nil
    local plist = _GetPlayersCached()
    for i = 1, #plist do
        local plr = plist[i]
        if plr ~= LP then
            local c = plr.Character
            local hrp = c and c:FindFirstChild("HumanoidRootPart")
            if hrp then
                local hum = c:FindFirstChildOfClass("Humanoid")
                if hum and hum.Health > 0 then
                    local d = hrp.Position - from
                    local d2 = d.X * d.X + d.Y * d.Y + d.Z * d.Z
                    if d2 < best then best, bestHRP = d2, hrp end
                end
            end
        end
    end
    if cur and curD and bestHRP ~= cur and best >= curD * 0.64 then
        bestHRP = cur
    end
    self.currentTarget = bestHRP
    return bestHRP
end

function _lustAimbot.clearMover(root)
    root = root or (LP.Character and LP.Character:FindFirstChild("HumanoidRootPart"))
    _lustAimbot._lv, _lustAimbot._att, _lustAimbot._forceSpeed = nil, nil, nil
    if not root then return end
    local lv  = root:FindFirstChild(_lustAimbot.moverName)
    local att = root:FindFirstChild(_lustAimbot.attachmentName)
    if lv  and lv:IsA("LinearVelocity") then lv:Destroy() end
    if att and att:IsA("Attachment")    then att:Destroy() end
end

function _lustAimbot.ensureMover(parent, speed)
    local self = _lustAimbot
    local lv, att = self._lv, self._att
    if not (lv and att and lv.Parent == parent and att.Parent == parent) then
        att = parent:FindFirstChild(self.attachmentName)
        if att and not att:IsA("Attachment") then att:Destroy(); att = nil end
        if not att then
            att = Instance.new("Attachment")
            att.Name = self.attachmentName
            att.Parent = parent
        end
        lv = parent:FindFirstChild(self.moverName)
        if not lv or not lv:IsA("LinearVelocity") then
            if lv then lv:Destroy() end
            lv = Instance.new("LinearVelocity")
            lv.Name = self.moverName
            lv.Attachment0 = att
            lv.RelativeTo = Enum.ActuatorRelativeTo.World
            lv.VelocityConstraintMode = Enum.VelocityConstraintMode.Vector
            lv.ForceLimitsEnabled = true
            lv.ForceLimitMode = Enum.ForceLimitMode.PerAxis
            lv.VectorVelocity = Vector3.zero
            lv.Parent = parent
        else
            lv.Attachment0 = att
        end
        self._lv, self._att, self._forceSpeed = lv, att, nil
    end
    if self._forceSpeed ~= speed then
        self._forceSpeed = speed
        local force = math.clamp(parent.AssemblyMass * math.max(speed * 260, 8000), self.minForce, self.maxForce)
        lv.MaxAxesForce = Vector3.new(force, force, force)
    end
    if not lv.Enabled then lv.Enabled = true end
    return lv
end

function _lustAimbot.applyMove(root, velVec, speed, dt)
    local lv = _lustAimbot.ensureMover(root, speed)
    lv.VectorVelocity = lv.VectorVelocity:Lerp(velVec, 0.8)
    _s2VelState.v = Vector3.new(math.clamp(velVec.X, -16, 16), root.AssemblyLinearVelocity.Y, math.clamp(velVec.Z, -16, 16))
end

-- Tras un TP propio (Float, TP Down, Mirror TP) se corta la inercia del aimbot.
function _lustAimbot.onTeleport()
    local lv = _lustAimbot._lv
    if lv and lv.Parent then lv.VectorVelocity = Vector3.zero end
    _lustAimbot.currentTarget = nil
end

function _lustAimbot.resetMotion()
    local char = LP.Character
    local hrp  = char and char:FindFirstChild("HumanoidRootPart")
    local hum  = char and char:FindFirstChildOfClass("Humanoid")
    if hrp then
        _lustAimbot.clearMover(hrp)
        hrp.Anchored = false
        hrp.AssemblyLinearVelocity  = Vector3.zero
        hrp.AssemblyAngularVelocity = Vector3.zero
        _s2VelState.v = Vector3.zero
        if sethiddenproperty then pcall(sethiddenproperty, hrp, "PhysicsRepRootPart", nil) end
        local look = hrp.CFrame.LookVector
        local flat = Vector3.new(look.X, 0, look.Z)
        if flat.Magnitude > 0.01 then flat = flat.Unit else flat = Vector3.new(0, 0, -1) end
        hrp.CFrame = CFrame.lookAt(hrp.Position, hrp.Position + flat)
    end
    if hum then
        hum.AutoRotate  = true
        hum.PlatformStand = false
        pcall(function() hum:Move(Vector3.zero, false) end)
        pcall(function() hum:ChangeState(Enum.HumanoidStateType.Running) end)
    end
end

-- Velocidad estimada del objetivo: mezcla la velocidad medida (posicion entre frames)
-- con la replicada, y suaviza mas rapido cuando el enemigo cambia de direccion.
function _lustAimbot.trackTarget(target, now)
    local preds = _lustAimbot.lustPred
    local tPos  = target.Position
    local entry = preds[target]
    if not entry then
        entry = { pos = tPos, time = now, vel = Vector3.zero }
        preds[target] = entry
        return entry.vel
    end
    local dtS = now - entry.time
    if dtS < 1 / 240 then return entry.vel end
    local jump = (tPos - entry.pos).Magnitude
    if dtS > 0.25 or jump > 45 then
        entry.pos, entry.time, entry.vel = tPos, now, Vector3.zero
        return entry.vel
    end
    local raw = (tPos - entry.pos) / dtS
    if raw.Magnitude > 90 then raw = raw.Unit * 90 end
    local vel = raw
    local rep = target.AssemblyLinearVelocity
    local repMag = rep.Magnitude
    if repMag > 1 and repMag < 120 then
        if raw.Magnitude < 0.5 or (rep - raw).Magnitude < math.max(raw.Magnitude * 0.6, 6) then
            vel = raw:Lerp(rep, 0.3)
        end
    end
    local alpha = 0.35
    local old = entry.vel
    if old.Magnitude > 4 and vel.Magnitude > 4 and old.Unit:Dot(vel.Unit) < 0.3 then
        alpha = 0.75
    end
    entry.vel  = old:Lerp(vel, alpha)
    entry.pos  = tPos
    entry.time = now
    return entry.vel
end

function _lustAimbot.update(dt)
    if not autoBatEnabled then return end
    local self = _lustAimbot
    local char = LP.Character
    local hrp  = char and char:FindFirstChild("HumanoidRootPart")
    local hum  = char and char:FindFirstChildOfClass("Humanoid")
    if not char or not hrp or not hum or hum.Health <= 0 then return end
    local target = self.nearestTarget(hrp)
    if not target then
        hum.AutoRotate = true
        hrp.AssemblyAngularVelocity = Vector3.zero
        self.clearMover(hrp)
        return
    end
    local speed = math.clamp(
        laggerToggled and AIMBOT_LAGGER_SPEED or BAT_AIMBOT_SPEED,
        1, 500
    )
    hum.AutoRotate = false
    local now = os.clock()

    if now - self._pingAt > 0.5 then
        self._pingAt = now
        local okp, p = pcall(LP.GetNetworkPing, LP)
        if okp and type(p) == "number" then self._ping = math.clamp(p, 0, 0.4) end
    end

    local tPos      = target.Position
    local estVel    = self.trackTarget(target, now)
    local targetVel = Vector3.new(estVel.X, estVel.Y * 0.4, estVel.Z)
    local dist      = (tPos - hrp.Position).Magnitude
    local lead      = _clamp(dist / math.max(speed, 20) * 0.5 + self._ping * 0.75, 0.04, 0.3)
    lead = lead * math.min(1, targetVel.Magnitude / 5) * math.min(1, dist / 8 + 0.35)
    local disp = targetVel * lead
    if disp.Magnitude > 14 then disp = disp.Unit * 14 end
    local aimPoint  = tPos + disp + Vector3.new(0, 1, 0)

    local diff      = aimPoint - hrp.Position
    local diffUnit  = diff.Magnitude > 0.01 and diff.Unit or Vector3.zero
    local flatDiff  = Vector3.new(diff.X, 0, diff.Z)
    if diff.Magnitude > 0.01 and flatDiff.Magnitude > 0.01 then
        local yawErr   = (math.deg(math.atan2(-flatDiff.X, -flatDiff.Z)) - hrp.Orientation.Y + 180) % 360 - 180
        local pitchErr = (math.deg(math.atan2(diff.Y, flatDiff.Magnitude)) - hrp.Orientation.X + 180) % 360 - 180
        local yawRad   = math.clamp(math.rad(yawErr)   * 40, -28, 28)
        local pitchRad = math.clamp(math.rad(pitchErr) * 40, -28, 28)
        local yawFacing = math.rad(hrp.Orientation.Y)
        local facingVec = Vector3.new(math.cos(yawFacing), 0, -math.sin(yawFacing))
        hrp.AssemblyAngularVelocity = Vector3.new(0, yawRad, 0) + facingVec * pitchRad
    else
        hrp.AssemblyAngularVelocity = Vector3.zero
    end
    local aboveDiff  = aimPoint + diffUnit * 2.8 + Vector3.new(0, 4.75, 0) - hrp.Position
    local flatAbove  = Vector3.new(aboveDiff.X, 0, aboveDiff.Z)
    local moveVec    = flatAbove.Magnitude > 0.1 and (flatAbove.Unit * speed) or Vector3.zero
    local vertVec    = math.abs(aboveDiff.Y) > 0.1
        and Vector3.new(0, math.sign(aboveDiff.Y) * 52, 0)
        or  Vector3.new(0, -2, 0)
    self.applyMove(hrp, moveVec + vertVec, speed, dt)
    if flatAbove.Magnitude > 0.5 then hum:Move(flatAbove.Unit, false) end
    if autoSwingEnabled then
        _autoSwingStrike(char)
    end
end

-- ═══════════════════════════════════════════════════════════════════
-- AUTO SWING (un solo emisor, con limite de frecuencia)
-- ═══════════════════════════════════════════════════════════════════
AUTO_SWING_BURST      = 2
AUTO_SWING_INTERVAL   = 0.05
_autoSwingFastThread  = nil

function _autoSwingFire(bat)
    if not bat or not bat.Parent then return end
    pcall(bat.Activate, bat)
    local remotes = _lustAimbot._remotes
    local remote = remotes[bat]
    if remote == nil or (remote and not remote.Parent) then
        remote = bat:FindFirstChildWhichIsA("RemoteEvent") or false
        remotes[bat] = remote
    end
    if remote then pcall(remote.FireServer, remote) end
end

function _autoSwingStrike(char)
    if not char then return end
    local now = os.clock()
    if now - _lustAimbot._lastSwing < AUTO_SWING_INTERVAL then return end
    _lustAimbot._lastSwing = now
    local bat = _lustAimbot.getBat()
    if not bat or bat.Parent ~= char then return end
    for _ = 1, AUTO_SWING_BURST do
        _autoSwingFire(bat)
    end
end

function startFastAutoSwing()
    _lustAimbot._lastSwing = 0
end

function stopFastAutoSwing()
    _autoSwingFastThread = nil
end

function startAimbotLust()
    if _lustAimbot.conn then return end
    _suppressBodyLock()
    local hum0 = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
    if hum0 then
        if _prevAutoRotate == nil then _prevAutoRotate = hum0.AutoRotate end
        hum0.AutoRotate = false
    end
    _lustAimbot.lustPred = setmetatable({}, { __mode = "k" }); _lustAimbot.currentTarget = nil
    do
        local char0 = LP.Character
        if char0 and hum0 and not char0:FindFirstChildOfClass("Tool") then
            local b0 = _lustAimbot.getBat()
            if b0 and b0.Parent ~= char0 then pcall(function() hum0:EquipTool(b0) end) end
        end
    end
    pcall(_mvClear)
    _lustAimbot.clearMover()
    _lustAimbot.conn = _LustOn(RunService.RenderStepped, _lustAimbot.update)
end

function stopAimbotLust()
    if _lustAimbot.conn then _lustAimbot.conn:Disconnect(); _lustAimbot.conn = nil end
    _lustAimbot.lustPred = setmetatable({}, { __mode = "k" }); _lustAimbot.currentTarget = nil
    _lustAimbot.resetMotion()
    local char = LP.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local hum  = char and char:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.AutoRotate = (_prevAutoRotate == nil) and true or _prevAutoRotate
        hum.PlatformStand = false
        pcall(function() hum:ChangeState(Enum.HumanoidStateType.Running) end)
    end
    if root then
        root.AssemblyLinearVelocity  = Vector3.new(0, -0.1, 0)
        root.AssemblyAngularVelocity = Vector3.zero
    end
    _prevAutoRotate = nil
    lastMoveDir = Vector3.zero
    _unsuppressBodyLock(true)
end

function disableAutoBat()
    autoBatEnabled = false
    if autoBatSetVisual then autoBatSetVisual(false) end
    if mobSetAutoBat then mobSetAutoBat(false) end
    stopAimbotLust()
    stopFastAutoSwing()
    task.defer(function() pcall(saveAllSettings) end)
end

function enableAutoBat()
    if autoPlayEnabled then
        stopAutoPlay()
    end
    autoBatEnabled = true
    if autoBatSetVisual then autoBatSetVisual(true) end
    if mobSetAutoBat then mobSetAutoBat(true) end
    startAimbotLust()
    startFastAutoSwing()
    task.defer(function() pcall(saveAllSettings) end)
end

function disableAllAimbots()
    if autoBatEnabled then disableAutoBat() end
end

function findBat()
    local char = LP.Character; if not char then return nil end
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

local batApi = { Enabled = false, Connection = nil }
if _G.LustBatCounter and type(_G.LustBatCounter.Stop) == "function" then pcall(_G.LustBatCounter.Stop) end
_G._VezyBatCounterOn = false
local batDebounce = false
local batLastTrigger = 0
local BAT_TRIGGER_COOLDOWN = 0.1
local BAT_NAMES = { "Bat", "Slap", "Iron Slap", "Gold Slap", "Diamond Slap", "Emerald Slap", "Ruby Slap", "Dark Matter Slap", "Flame Slap", "Nuclear Slap", "Galaxy Slap", "Glitched Slap" }

local function batFind()
    local char = LP.Character
    if not char then return nil end
    local backpack = LP:FindFirstChildOfClass("Backpack")
    for _, name in ipairs(BAT_NAMES) do
        local tool = char:FindFirstChild(name) or (backpack and backpack:FindFirstChild(name))
        if tool then return tool end
    end
    for _, tool in ipairs(char:GetChildren()) do
        if tool:IsA("Tool") and tool.Name:lower():find("bat") then return tool end
    end
    if backpack then
        for _, tool in ipairs(backpack:GetChildren()) do
            if tool:IsA("Tool") and tool.Name:lower():find("bat") then return tool end
        end
    end
    return nil
end

local function batNearest(fromPosition)
    local best, bestDistance = nil, math.huge
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LP and player.Character then
            local root = player.Character:FindFirstChild("HumanoidRootPart")
            local hum = player.Character:FindFirstChildOfClass("Humanoid")
            if root and hum and hum.Health > 0 then
                local distance = (root.Position - fromPosition).Magnitude
                if distance < bestDistance then bestDistance = distance; best = player end
            end
        end
    end
    return best
end

local function batTrigger()
    if not batApi.Enabled or batDebounce then return end
    local now = os.clock()
    if now - batLastTrigger < BAT_TRIGGER_COOLDOWN then return end
    batDebounce = true
    batLastTrigger = now
    task.spawn(function()
        local char = LP.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if not char or not root or not hum then batDebounce = false; return end
        local victim = batNearest(root.Position)
        if not victim then batDebounce = false; return end
        local tool = batFind()
        if tool then
            if tool.Parent ~= char then pcall(function() hum:EquipTool(tool) end) end
            task.wait(0.02)
        end
        char = LP.Character
        root = char and char:FindFirstChild("HumanoidRootPart")
        hum = char and char:FindFirstChildOfClass("Humanoid")
        local victimChar = victim.Character
        local victimRoot = victimChar and victimChar:FindFirstChild("HumanoidRootPart")
        if not char or not root or not hum or not victimRoot then batDebounce = false; return end
        hum.AutoRotate = false
        local victimPosition = victimRoot.Position
        local lookAt = Vector3.new(victimPosition.X, root.Position.Y, victimPosition.Z)
        if (lookAt - root.Position).Magnitude > 0.001 then
            pcall(function()
                root.RotVelocity = Vector3.zero
                root.AssemblyAngularVelocity = Vector3.zero
                root.CFrame = CFrame.lookAt(root.Position, lookAt)
            end)
        end
        task.wait(0.03)
        local swing = batFind()
        if swing and swing.Parent == char then
            pcall(function()
                swing:Activate()
                local remote = swing:FindFirstChildWhichIsA("RemoteEvent")
                if remote then remote:FireServer() end
            end)
        end
        task.wait(0.2)
        if root and root.Parent then
            root.RotVelocity = Vector3.zero
            root.AssemblyAngularVelocity = Vector3.zero
        end
        if hum and hum.Parent and not (autoBatEnabled == true or _G._VezyBatAimbotOn == true) then hum.AutoRotate = true end
        batDebounce = false
    end)
end

function batApi.Start()
    batApi.Enabled = true
    if batApi.Connection then return end
    local wasRagdolled = false
    batApi.Connection = _LustOn(RunService.Heartbeat, function()
        if not batApi.Enabled then wasRagdolled = false; return end
        local char = LP.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if not hum then wasRagdolled = false; return end
        local ragdolled = hum:GetState() == Enum.HumanoidStateType.Physics
        if ragdolled and not wasRagdolled and not batDebounce then batTrigger() end
        wasRagdolled = ragdolled
    end)
end
function batApi.Stop()
    batApi.Enabled = false
    batDebounce = false
    if batApi.Connection then batApi.Connection:Disconnect(); batApi.Connection = nil end
end
function batApi.SetEnabled(on) if on then batApi.Start() else batApi.Stop() end end

function startBatCounter()
    batCounterEnabled = true
    _G._VezyBatCounterOn = true
    if BC then BC.enabled = true end
    if batApi.Connection then
        pcall(function() batApi.Connection:Disconnect() end)
        batApi.Connection = nil
    end
    batApi.Enabled = false
    batDebounce = false
    batApi.Start()
end
function stopBatCounter()
    batCounterEnabled = false
    _G._VezyBatCounterOn = false
    if BC then BC.enabled = false end
    batApi.Stop()
end

_G.VezyStartBatCounter = startBatCounter
_G.VezyStopBatCounter  = stopBatCounter
_G.LustBatCounter       = batApi

function findMedusa()
    local c = LP.Character; if not c then return nil end
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
    local c = LP.Character; if not c then return end
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
        if part:IsA("BasePart") then table.insert(Conns.anchor, onAnchorChanged(part)) end
    end
    table.insert(Conns.anchor, char.DescendantAdded:Connect(function(part)
        if part:IsA("BasePart") then table.insert(Conns.anchor, onAnchorChanged(part)) end
    end))
end

function stopMedusaCounter()
    for _, c in pairs(Conns.anchor) do pcall(function() c:Disconnect() end) end
    Conns.anchor = {}
end

DROP_ASCEND_DURATION = 0.2
DROP_ASCEND_SPEED = 150
_dropConn = nil

function stopDropBrainrot()
    dropActive = false
    _G.IsDropping = false
    _G.__LustDropInProgress = false
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

local function setDropState(v)
    _G.IsDropping = v
    _G.__LustDropInProgress = v
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
                    if dropConnections[i] == threadRef then table.remove(dropConnections, i) break end
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
                    rp.FilterType = RFT_EXCLUDE
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
        task.delay(0.35, function() if dropActive then finishDrop(flingThread) end end)
        return
    end

    if autoBatEnabled then
        autoBatEnabled = false
        if autoBatSetVisual then autoBatSetVisual(false) end
        if mobSetAutoBat then mobSetAutoBat(false) end
        if stopAimbotLust then stopAimbotLust() end
    end

    dropActive = true
    setDropState(true)
    if dropBrainrotSetVisual then dropBrainrotSetVisual(true) end
    if mobSetDropBR then mobSetDropBR(false) end

    local DROP_DURATION = 0.18
    local DROP_VELOCITY = 155

    local dropRayParams = _G.__LustDropRayParams
    if not dropRayParams then
        dropRayParams = RaycastParams.new()
        dropRayParams.FilterType = RFT_EXCLUDE
        dropRayParams.RespectCanCollide = true
        _G.__LustDropRayParams = dropRayParams
    end

    dropRayParams.FilterDescendantsInstances = { char }
    local hit = workspace:Raycast(
        root.Position + Vector3.new(0, 0.35, 0),
        Vector3.new(0, -2000, 0),
        dropRayParams
    )
    if not hit then
        dropActive = false
        setDropState(false)
        if dropBrainrotSetVisual then dropBrainrotSetVisual(false) end
        if mobSetDropBR then mobSetDropBR(false) end
        return
    end

    _G.__LustDropToken = (_G.__LustDropToken or 0) + 1
    local dropToken = _G.__LustDropToken
    local rotation = root.CFrame.Rotation
    local startX = root.Position.X
    local startZ = root.Position.Z
    local startTime = _tick()

    if _dropConn then _dropConn:Disconnect(); _dropConn = nil end
    _dropConn = _LustOn(RunService.Heartbeat, function()
        local character2 = LP.Character
        local root2 = character2 and character2:FindFirstChild("HumanoidRootPart")
        local hum2 = character2 and character2:FindFirstChildOfClass("Humanoid")

        if _G.__LustDropToken ~= dropToken
           or not root2 or not hum2
           or hum2.Health <= 0
           or not dropActive then
            if _dropConn then _dropConn:Disconnect(); _dropConn = nil end
            dropActive = false
            setDropState(false)
            if dropBrainrotSetVisual then dropBrainrotSetVisual(false) end
            if mobSetDropBR then mobSetDropBR(false) end
            return
        end

        if _tick() - startTime >= DROP_DURATION then
            if _dropConn then _dropConn:Disconnect(); _dropConn = nil end
            pcall(function()
                dropRayParams.FilterDescendantsInstances = { character2 }
                local hit2 = workspace:Raycast(
                    root2.Position + Vector3.new(0, 0.35, 0),
                    Vector3.new(0, -2000, 0),
                    dropRayParams
                ) or hit
                if hit2 then
                    root2.CFrame = CFrame.new(
                        startX,
                        hit2.Position.Y + hum2.HipHeight + root2.Size.Y * 0.5 + 0.2,
                        startZ
                    ) * rotation
                    root2.AssemblyLinearVelocity = Vector3.zero
                    root2.AssemblyAngularVelocity = Vector3.zero
                end
            end)
            dropActive = false
            setDropState(false)
            if dropBrainrotSetVisual then dropBrainrotSetVisual(false) end
            if mobSetDropBR then mobSetDropBR(false) end
            return
        end

        root2.AssemblyLinearVelocity = Vector3.new(0, DROP_VELOCITY, 0)
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

_alConns = {}
_alLoop = nil
_alWhitelist = {}
_alMapWhitelist = {}
_antiLagApplying = false

function _alAdd(tbl, inst) if inst then tbl[inst] = true end end

function _alFindPath(...)
    local parts = {...}
    local current = workspace
    for _, name in ipairs(parts) do
        current = current:FindFirstChild(name)
        if not current then return nil end
    end
    return current
end

function _alRebuildWhitelist()
    _alWhitelist = {}; _alMapWhitelist = {}
    _alAdd(_alWhitelist, workspace:FindFirstChild("Camera"))
    _alAdd(_alWhitelist, workspace:FindFirstChild("Terrain"))
    _alAdd(_alWhitelist, workspace:FindFirstChild("Debris"))
    _alAdd(_alWhitelist, workspace:FindFirstChild("Plots"))
    _alAdd(_alWhitelist, workspace:FindFirstChild("RenderedMovingAnimals"))
    _alAdd(_alWhitelist, _alFindPath("Map"))
    _alAdd(_alMapWhitelist, _alFindPath("Map", "WallModels"))
    _alAdd(_alMapWhitelist, _alFindPath("Map", "__StreamCheck_DontDelete"))
    _alAdd(_alMapWhitelist, _alFindPath("Map", "Carpet"))
    _alAdd(_alMapWhitelist, _alFindPath("Map", "Ground"))
    _alAdd(_alMapWhitelist, _alFindPath("Map", "Ground_Left"))
    _alAdd(_alMapWhitelist, _alFindPath("Map", "Ground_Right"))
end

function _alIsProtected(inst)
    local char = LP.Character
    if char and (inst == char or inst:IsDescendantOf(char)) then return true end
    local backpack = LP:FindFirstChildOfClass("Backpack")
    if backpack and (inst == backpack or inst:IsDescendantOf(backpack)) then return true end
    local ok, result = pcall(function()
        local parent = inst
        while parent and parent ~= workspace and parent ~= game do
            if parent:GetAttribute("LustESP") == true then return true end
            if parent:GetAttribute("LustGhostBody") == true then return true end
            if type(parent.Name) == "string" and parent.Name:match("^Lust") then return true end
            parent = parent.Parent
        end
        return false
    end)
    if ok and result then return true end
    local rma = workspace:FindFirstChild("RenderedMovingAnimals")
    if rma and (inst == rma or inst:IsDescendantOf(rma)) then return true end
    result, ok = pcall(function()
        local parent = inst
        while parent and parent ~= workspace and parent ~= game do
            if parent:FindFirstChildOfClass("Humanoid") then return true end
            if parent:IsA("Model") and parent:FindFirstChildOfClass("AnimationController") then return true end
            parent = parent.Parent
        end
        return false
    end)
    if result and ok then return true end
    ok, result = pcall(function()
        local hrp = char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("UpperTorso"))
        if not hrp then return false end
        if inst:IsA("Model") then
            local pp = inst.PrimaryPart or inst:FindFirstChildOfClass("BasePart")
            if pp and (hrp.Position - pp.Position).Magnitude <= 10 then return true end
        end
        return false
    end)
    if ok and result then return true end
    return false
end

function _alIsUUID(str)
    return str:match("^%x%x%x%x%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%x%x%x%x%x%x%x%x$") ~= nil
end

function _alRemoveAnimControllers()
    for i, inst in ipairs(workspace:GetDescendants()) do
        if not antiLagEnabled then return end
        if not _alIsProtected(inst) and inst:IsA("AnimationController") then
            pcall(function() inst:Destroy() end)
        end
        if i % 160 == 0 then RunService.Heartbeat:Wait() end
    end
end

function _alRemoveVisuals()
    for i, inst in ipairs(workspace:GetDescendants()) do
        if not antiLagEnabled then return end
        if i % 160 == 0 then RunService.Heartbeat:Wait() end
        if _alIsProtected(inst) then continue end
        pcall(function()
            if inst:IsA("Texture") or inst:IsA("Decal") or inst:IsA("SurfaceAppearance") then
                inst:Destroy()
            elseif inst:IsA("SpecialMesh") then
                inst.TextureId = ""
            elseif inst:IsA("MeshPart") then
                inst.TextureID = ""; inst.CastShadow = false
            elseif inst:IsA("ParticleEmitter") or inst:IsA("Trail") or inst:IsA("Beam")
                or inst:IsA("Fire") or inst:IsA("Smoke") or inst:IsA("Sparkles")
                or inst:IsA("Highlight") or inst:IsA("Explosion")
                or inst:IsA("PointLight") or inst:IsA("SpotLight") or inst:IsA("SurfaceLight") then
                inst:Destroy()
            elseif inst:IsA("BasePart") then
                inst.CastShadow = false
                inst.Material = Enum.Material.Plastic
                inst.MaterialVariant = ""
                inst.Reflectance = 0
            end
        end)
    end
end

function _alHasSound(inst)
    if inst:IsA("Sound") or inst:IsA("SoundGroup") then return true end
    return inst:FindFirstChildOfClass("Sound", true) ~= nil
        or inst:FindFirstChildOfClass("SoundGroup", true) ~= nil
end

function _alCleanMap()
    local map = workspace:FindFirstChild("Map"); if not map then return end
    for _, child in ipairs(map:GetChildren()) do
        if not _alMapWhitelist[child] and not _alHasSound(child) and not _alIsProtected(child) then
            pcall(function() child:Destroy() end)
        end
    end
end

function _alCleanWorkspace()
    _alRebuildWhitelist()
    for _, child in ipairs(workspace:GetChildren()) do
        if not _alWhitelist[child] then
            if not _alIsUUID(child.Name)
                and not Players:FindFirstChild(child.Name)
                and not _alIsProtected(child)
                and not _alHasSound(child) then
                pcall(function() child:Destroy() end)
            end
        end
    end
    _alCleanMap()
end

function _alCleanLighting()
    for _, child in ipairs(Lighting:GetChildren()) do
        if child:GetAttribute("_LustVividEffect") then continue end
        if child.Name == "LustSaturation" then continue end
        if child:GetAttribute("_LustSky") then continue end
        if child:IsA("Sky") or child:IsA("Atmosphere") or child:IsA("Clouds") then continue end
        if child:IsA("PostEffect") then pcall(function() child:Destroy() end) end
    end
end

function enableAntiLag()
    antiLagEnabled = true
    _antiLagApplying = true
    _alRemoveAnimControllers()
    if not antiLagEnabled then _antiLagApplying = false; return end
    _alRemoveVisuals()
    if not antiLagEnabled then _antiLagApplying = false; return end
    _alCleanWorkspace()
    _alCleanLighting()
    for _, conn in pairs(_alConns) do pcall(function() conn:Disconnect() end) end
    _alConns = {}
    table.insert(_alConns, _LustOn(workspace.DescendantAdded, function(d)
        if not antiLagEnabled then return end
        if _alIsProtected(d) then return end
        task.defer(function()
            if _alIsProtected(d) then return end
            pcall(function()
                if d:IsA("Texture") or d:IsA("Decal") or d:IsA("SurfaceAppearance")
                    or d:IsA("ParticleEmitter") or d:IsA("Trail") or d:IsA("Beam")
                    or d:IsA("Fire") or d:IsA("Smoke") or d:IsA("Sparkles")
                    or d:IsA("Highlight") or d:IsA("AnimationController") then
                    d:Destroy()
                elseif d:IsA("SpecialMesh") then d.TextureId = ""
                elseif d:IsA("MeshPart") then d.TextureID = ""; d.CastShadow = false
                elseif d:IsA("BasePart") then
                    d.CastShadow = false; d.Material = Enum.Material.Plastic
                    d.MaterialVariant = ""; d.Reflectance = 0
                end
            end)
        end)
    end))
    table.insert(_alConns, _LustOn(Lighting.DescendantAdded, function(d)
        if not antiLagEnabled then return end
        if d:GetAttribute("_LustVividEffect") then return end
        if d.Name == "LustSaturation" then return end
        if d:GetAttribute("_LustSky") then return end
        if d:IsA("Sky") or d:IsA("Atmosphere") or d:IsA("Clouds") then return end
        if d:IsA("PostEffect") then pcall(function() d:Destroy() end) end
    end))
    local matService = game:GetService("MaterialService")
    table.insert(_alConns, _LustOn(matService.DescendantAdded, function(d)
        if not antiLagEnabled then return end
        if _alIsProtected(d) then return end
        pcall(function() d:Destroy() end)
    end))
    if _alLoop then pcall(task.cancel, _alLoop) end
    _alLoop = task.spawn(function()
        while antiLagEnabled do
            task.wait(2)
            if antiLagEnabled then
                pcall(_alCleanWorkspace)
                pcall(_alCleanLighting)
            end
        end
    end)
    _antiLagApplying = false
end

function disableAntiLag()
    antiLagEnabled = false
    _antiLagApplying = false
    for _, conn in pairs(_alConns) do pcall(function() conn:Disconnect() end) end
    _alConns = {}
    if _alLoop then pcall(task.cancel, _alLoop); _alLoop = nil end
end

function applyStretchFOV(val)
    local cam = workspace.CurrentCamera
    if cam then pcall(function() cam.FieldOfView = val end) end
end

function enableStretch()
    if stretchConn then return end
    stretchEnabled = true
    local cam = workspace.CurrentCamera; if not cam then return end
    origFOV = cam.FieldOfView or 70
    applyStretchFOV(stretchFOV)
    stretchConn = _LustOn(RunService.RenderStepped, function()
        if not stretchEnabled then stretchConn:Disconnect(); stretchConn = nil; return end
        local c = workspace.CurrentCamera
        if c then c.CFrame = c.CFrame * _CFnew(0,0,0,1,0,0,0,0.7,0,0,0,1) end
    end)
    if stretchFovConn then stretchFovConn:Disconnect() end
    stretchFovConn = _LustOn(RunService.RenderStepped, function()
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

SKY_PRESETS_LIST = {"Off","Night","Aurora","Sunset","Galaxy","Cyber","Sakura","Blood Moon","Emerald Dawn","Volcanic","Arctic","Midnight Ocean","Vaporwave","Toxic","Solar Eclipse","Hellscape","Heaven","Storm","Sunrise","Deep Space","Lavender Dream","Inferno","Mint Sky"}
SKY_PRESETS = {
    ["Off"]={kind="off"},
    ["Night"]={clock=22,brightness=2,ambient={110,100,130},outAmb={120,110,140},sky={stars=4000,moon=18,sun=0,moonTex=true},atm={dens=0.45,color={120,60,180},decay={60,20,100},glare=0.5,haze=1.2}},
    ["Aurora"]={clock=14,brightness=3,ambient={150,120,150},outAmb={160,130,150},atm={dens=0.55,color={160,140,180},decay={140,110,150},glare=2.5,haze=3},clouds={cover=0.7,dens=0.7,color={180,170,190}}},
    ["Sunset"]={clock=17.2,brightness=2.5,ambient={170,120,100},outAmb={180,130,110},sky={stars=0,sun=25,moon=0},atm={dens=0.5,color={255,130,60},decay={255,80,30},glare=2,haze=2.5},clouds={cover=0.55,dens=0.55,color={255,200,140}}},
    ["Galaxy"]={clock=0,brightness=1.5,ambient={70,60,100},outAmb={80,70,110},sky={stars=10000,moon=30,sun=0},atm={dens=0.15,color={40,20,80},decay={20,10,50},glare=0.3,haze=0.5}},
    ["Cyber"]={clock=21,brightness=2.2,ambient={90,130,170},outAmb={100,140,180},sky={stars=2000,moon=12},atm={dens=0.4,color={0,200,255},decay={150,0,255},glare=2,haze=2},clouds={cover=0.4,dens=0.6,color={100,200,255}}},
    ["Sakura"]={clock=11,brightness=3.5,ambient={170,150,160},outAmb={180,160,170},sky={sun=8},atm={dens=0.3,color={180,160,180},decay={160,140,160},glare=1,haze=1.5},clouds={cover=0.6,dens=0.4,color={190,180,200}}},
    ["Blood Moon"]={clock=22.5,brightness=1.6,ambient={130,40,40},outAmb={150,50,50},sky={stars=1500,moon=28,sun=0,moonTex=true},atm={dens=0.6,color={220,30,30},decay={120,10,10},glare=1.4,haze=2},clouds={cover=0.5,dens=0.7,color={120,30,30}}},
    ["Emerald Dawn"]={clock=6.5,brightness=2.8,ambient={130,170,140},outAmb={140,180,150},sky={sun=18,moon=0,stars=0},atm={dens=0.4,color={80,200,140},decay={40,150,90},glare=1.8,haze=2.2},clouds={cover=0.5,dens=0.5,color={200,255,220}}},
    ["Volcanic"]={clock=19,brightness=2,ambient={180,80,40},outAmb={200,90,50},sky={stars=200,sun=12,moon=0},atm={dens=0.75,color={255,60,0},decay={180,20,0},glare=3,haze=3.5},clouds={cover=0.8,dens=0.9,color={120,40,20}}},
    ["Arctic"]={clock=9,brightness=3.2,ambient={200,220,235},outAmb={210,230,245},sky={sun=10,stars=0,moon=0},atm={dens=0.3,color={180,220,255},decay={140,200,240},glare=1.5,haze=1.8},clouds={cover=0.7,dens=0.6,color={250,253,255}}},
    ["Midnight Ocean"]={clock=1.5,brightness=1.7,ambient={60,90,130},outAmb={70,100,140},sky={stars=6000,moon=24,sun=0,moonTex=true},atm={dens=0.5,color={20,60,140},decay={10,30,90},glare=0.6,haze=1.5}},
    ["Vaporwave"]={clock=19.5,brightness=2.4,ambient={160,160,170},outAmb={170,170,180},sky={stars=1000,moon=14},atm={dens=0.45,color={160,160,180},decay={120,120,150},glare=2.2,haze=2.4},clouds={cover=0.55,dens=0.55,color={170,170,190}}},
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

function _vC3(t) return Color3.fromRGB(t[1], t[2], t[3]) end

function _v4mpClearSky()
    for _, child in ipairs(Lighting:GetChildren()) do
        if child:GetAttribute("_LustSky") then pcall(function() child:Destroy() end) end
    end
    local terrain = workspace:FindFirstChildOfClass("Terrain")
    if terrain then
        for _, child in ipairs(terrain:GetChildren()) do
            if child:GetAttribute("_LustSky") then pcall(function() child:Destroy() end) end
        end
    end
end

function applyCustomSky(mode)
    _v4mpClearSky()
    local preset = SKY_PRESETS[mode]
    if not preset or preset.kind == "off" then
        Lighting.ClockTime = 14; Lighting.Brightness = 2
        Lighting.OutdoorAmbient = Color3.fromRGB(127,127,127)
        Lighting.Ambient = Color3.fromRGB(127,127,127)
        Lighting.FogEnd = 100000; Lighting.GlobalShadows = true
        skyTheme = "Off"; return
    end
    Lighting.FogStart = 0; Lighting.FogEnd = 100000
    Lighting.FogColor = Color3.fromRGB(200,200,200)
    Lighting.ColorShift_Top = Color3.fromRGB(0,0,0)
    Lighting.ColorShift_Bottom = Color3.fromRGB(0,0,0)
    Lighting.GlobalShadows = true
    Lighting.ClockTime = preset.clock or 14
    Lighting.Brightness = preset.brightness or 2
    if preset.outAmb then Lighting.OutdoorAmbient = _vC3(preset.outAmb) end
    if preset.ambient then Lighting.Ambient = _vC3(preset.ambient) end
    if preset.sky then
        local skyInst = Instance.new("Sky"); skyInst:SetAttribute("_LustSky", true)
        if preset.sky.stars then skyInst.StarCount = preset.sky.stars end
        if preset.sky.moon then skyInst.MoonAngularSize = preset.sky.moon end
        if preset.sky.sun then skyInst.SunAngularSize = preset.sky.sun end
        if preset.sky.moonTex then skyInst.MoonTextureId = "rbxasset://sky/moon.jpg" end
        skyInst.Parent = Lighting
    end
    if preset.atm then
        local atm = Instance.new("Atmosphere"); atm:SetAttribute("_LustSky", true)
        atm.Density = preset.atm.dens or 0.3
        atm.Color = _vC3(preset.atm.color); atm.Decay = _vC3(preset.atm.decay)
        atm.Glare = preset.atm.glare or 1; atm.Haze = preset.atm.haze or 1
        atm.Parent = Lighting
    end
    local terrain = workspace:FindFirstChildOfClass("Terrain")
    if preset.clouds and terrain then
        local clouds = Instance.new("Clouds"); clouds:SetAttribute("_LustSky", true)
        clouds.Cover = preset.clouds.cover or 0.5
        clouds.Density = preset.clouds.dens or 0.5
        clouds.Color = _vC3(preset.clouds.color)
        clouds.Parent = terrain
    end
    skyTheme = mode
end

function applyHideButtons(state)
    if state ~= nil then hideButtonsEnabled = state end
    local function hides(name)
        return hideButtonsEnabled == true and hideButtonFlags[name] ~= false
    end
    if MobilePanel then
        for _, child in ipairs(MobilePanel:GetChildren()) do
            if child:IsA("TextButton") then child.Visible = not hides(child.Name) end
        end
    end
    if instaResetFloatingButton then
        local frame = instaResetFloatingButton:FindFirstChild("Frame")
        if frame then frame.Visible = not hides("InstaReset") end
    end
end

function toggleHideButtons(on)
    applyHideButtons(on)
    if setHideButtonsVisual then setHideButtonsVisual(on) end
    saveAllSettings(true)
end

function applyFloatingButtonScale()
    for _, uiScale in ipairs(_floatingUIScales) do
        if uiScale and uiScale.Parent then uiScale.Scale = floatingButtonScale end
    end
end

_lustDragShared = _lustDragShared or { active = nil }

do
    local S = _lustDragShared
    if not S.endedConn then
        S.endedConn = _LustOn(UIS.InputEnded, function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1
               or i.UserInputType == Enum.UserInputType.Touch then
                local a = S.active
                if a and a.onEnd then a.onEnd() end
            end
        end)
    end
    if not S.changedConn then
        S.changedConn = _LustOn(UIS.InputChanged, function(i)
            local a = S.active
            if not a then return end
            if a.di and i == a.di and a.dn then
                if uiLocked then a.onEnd(); return end
                if _isDraggingButton then return end
                if not a.ds or not a.sp then return end
                local nX = a.sp.X.Offset + (i.Position.X - a.ds.X)
                local nY = a.sp.Y.Offset + (i.Position.Y - a.ds.Y)
                a.frame.Position = UDim2.new(a.sp.X.Scale, nX, a.sp.Y.Scale, nY)
            end
        end)
    end
end

function drag(f, dragZoneHeight)
    local S = _lustDragShared
    local state = { frame = f, dn = false, ds = nil, sp = nil, di = nil }
    local endConn = nil
    local zoneRaw = dragZoneHeight or 99999
    local function stopDrag()
        local wasDragging = state.dn
        state.dn = false; state.di = nil
        if endConn then endConn:Disconnect(); endConn = nil end
        if S.active == state then S.active = nil end
        if wasDragging then task.defer(function() pcall(saveAllSettings) end) end
    end
    state.onEnd = stopDrag

    f.InputBegan:Connect(function(i)
        if uiLocked then return end
        if _isDraggingButton then return end
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            local framePos = f.AbsolutePosition
            local zone = (type(zoneRaw) == "function") and zoneRaw() or zoneRaw
            if i.Position.Y > framePos.Y + zone then return end
            state.dn = true; state.ds = i.Position; state.sp = f.Position
            S.active = state
            if endConn then endConn:Disconnect() end
            endConn = i.Changed:Connect(function()
                if i.UserInputState == Enum.UserInputState.End then stopDrag() end
            end)
        end
    end)
    f.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then stopDrag() end
    end)
    f.InputChanged:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch then state.di = i end
    end)
end

_G.__LustSpeedEngine = _G.__LustSpeedEngine or { started = false, conn = nil }
_G.__LustSpeedEngine.signal = nil
do
    local _ok, _sig = pcall(function() return RunService.PreSimulation end)
    _G.__LustSpeedEngine.signal = (_ok and _sig) or RunService.Heartbeat
end

function _spd_isRagdollState(hum)
    if not hum then return true end
    local st = hum:GetState()
    return hum.PlatformStand or st == Enum.HumanoidStateType.Physics
        or st == Enum.HumanoidStateType.Ragdoll or st == Enum.HumanoidStateType.FallingDown
end

function _spd_shouldUseStealSpeed(isStealing)
    if speedMode then return true end
    return false
end

function _spd_getSelectedBoostSpeed()
    if laggerCarryToggled then return LAGGER_CARRY_SPEED end
    if laggerToggled then return LAGGER_SPEED end
    return NS
end

function _spd_getSelectedStealSpeed()
    if laggerCarryToggled then return LAGGER_CARRY_SPEED end
    if laggerToggled then return LAGGER_SPEED end
    return CS
end

function _spd_getTargetSpeed(isStealing)
    if Config._isAutoplayActive and Config._isAutoplayActive() then
        return _apResolveSpeed and _apResolveSpeed() or NS
    end
    if _spd_shouldUseStealSpeed(isStealing) then return _spd_getSelectedStealSpeed() end
    return _spd_getSelectedBoostSpeed()
end

function _spd_resetMovement()
    lastMoveDir = _V3zero
    pcall(_mvClearStep, _LustMove.root)
    _LustMove.smoothed = Vector2.zero
    _LustMove.lastMagnitude = 0
    _s2VelState.v = _V3new(0, _s2VelState.v.Y or 0, 0)
end

function _spd_stop()
    if _G.__LustSpeedEngine.conn then _G.__LustSpeedEngine.conn:Disconnect(); _G.__LustSpeedEngine.conn = nil end
    if _G.__LustSpeedEngine.gravConn then pcall(function() _G.__LustSpeedEngine.gravConn:Disconnect() end); _G.__LustSpeedEngine.gravConn = nil end
    _spd_resetMovement()
end

-- ======================================================================
-- MOTOR DE MOVIMIENTO (portado de Hook): PreSimulation + esquivo de paredes
-- ======================================================================
_spdRayParams = RaycastParams.new()
_spdRayParams.FilterType = Enum.RaycastFilterType.Exclude
_spdRayParams.IgnoreWater = true
pcall(function() _spdRayParams.RespectCanCollide = true end)

-- Igual que fn57 de Hook: si hay una pared delante, desliza la direccion a lo largo de ella.
function _spd_wallSlide(root, char, dir, speed)
    local ok, result = pcall(function()
        local filter = { char }
        for _, pl in ipairs(Players:GetPlayers()) do
            if pl ~= LP and pl.Character then filter[#filter + 1] = pl.Character end
        end
        _spdRayParams.FilterDescendantsInstances = filter
        return workspace:Raycast(root.Position, dir * (3 + math.min(speed or 60, 150) * 0.035), _spdRayParams)
    end)
    if not ok or not result then return dir end
    if result.Position.Y < root.Position.Y - 1.2 then return dir end
    local normal = result.Normal
    local nx, nz = normal.X, normal.Z
    local nl = math.sqrt(nx * nx + nz * nz)
    if nl < 0.05 then return dir end
    local ux, uz = nx / nl, nz / nl
    local dot = dir.X * ux + dir.Z * uz
    if dot >= 0 then return dir end
    local sx = dir.X - ux * dot
    local sz = dir.Z - uz * dot
    local sl = math.sqrt(sx * sx + sz * sz)
    if sl < 0.15 then return Vector3.zero end
    return Vector3.new(sx / sl, 0, sz / sl)
end

-- Rescate de caida al vacio (fn40 de Hook, parte de movimiento): baja un raycast,
-- salta partes transparentes/sin colision/personajes y te deja sobre el suelo.
_spdRescueRunning = false
function _spd_voidRescue()
    if _spdRescueRunning then return end
    _spdRescueRunning = true
    pcall(function()
        local character = LP.Character
        local root = character and character:FindFirstChild("HumanoidRootPart")
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        if not root or not humanoid then return end
        local pos = root.Position
        if pos.X ~= pos.X or pos.Y ~= pos.Y or pos.Z ~= pos.Z
           or math.abs(pos.X) > 1000000 or math.abs(pos.Y) > 1000000 or math.abs(pos.Z) > 1000000 then
            if tick() - (_G.__LustRescueAt or 0) > 5 then
                _G.__LustRescueAt = tick()
                pcall(function() LP:LoadCharacter() end)
            end
            return
        end
        local x, z = pos.X, pos.Z
        local rp = RaycastParams.new()
        rp.FilterType = Enum.RaycastFilterType.Exclude
        rp.IgnoreWater = true
        local filter = { character }
        for _, pl in ipairs(Players:GetPlayers()) do
            if pl ~= LP and pl.Character then filter[#filter + 1] = pl.Character end
        end
        rp.FilterDescendantsInstances = filter
        local origin = Vector3.new(x, pos.Y, z)
        local y = nil
        for _ = 1, 15 do
            local hit = workspace:Raycast(origin, Vector3.new(0, -3000, 0), rp)
            y = nil
            if not hit then break end
            local inst = hit.Instance
            local parent, model = inst, nil
            for _ = 1, 6 do
                if not parent or parent == workspace then break end
                if parent:IsA("Model") and parent:FindFirstChildOfClass("Humanoid") then model = parent; break end
                parent = parent.Parent
            end
            if inst.Transparency >= 0.9 or inst.CanCollide == false or model then
                filter[#filter + 1] = model or inst
                rp.FilterDescendantsInstances = filter
                origin = hit.Position - Vector3.new(0, 0.2, 0)
            else
                y = hit.Position.Y
                break
            end
        end
        if not y then return end
        local vx, vz = root.AssemblyLinearVelocity.X, root.AssemblyLinearVelocity.Z
        if vx ~= vx then vx = 0 end
        if vz ~= vz then vz = 0 end
        local okS, sp = pcall(_spd_getTargetSpeed, false)
        local cap = math.max(okS and sp or 60, 40)
        local mag = math.sqrt(vx * vx + vz * vz)
        if mag > cap and mag > 0 then vx = vx / mag * cap; vz = vz / mag * cap end
        root.CFrame = CFrame.new(x, y + 2.8, z)
        root.AssemblyLinearVelocity = Vector3.new(vx, 0, vz)
        root.AssemblyAngularVelocity = Vector3.zero
        pcall(function()
            root.Velocity = Vector3.new(vx, 0, vz)
            root.RotVelocity = Vector3.zero
        end)
        pcall(function()
            humanoid.PlatformStand = false
            humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
        end)
    end)
    _spdRescueRunning = false
end

-- Un paso del motor (identico a la logica de PreSimulation de Hook).
function _spd_step(humanoid, root, character)
    if root.Position.Y < -20 then
        _spd_voidRescue()
        return
    end
    local speed = tonumber(_spd_getTargetSpeed(false)) or 0
    speed = math.clamp(speed, 0, 10000)
    -- Velocidad ~16 (caminar normal): no se toca la velocidad
    if speed >= 15.5 and speed <= 16.5 then
        if _s2VelState.v ~= Vector3.zero then _s2VelState.v = Vector3.zero end
        return
    end
    local md = humanoid.MoveDirection
    local mag = md.Magnitude
    if mag > 0.05 then
        local y = root.AssemblyLinearVelocity.Y
        if y ~= y then y = 0 end
        y = math.clamp(y, -80, 80)
        local dir = _spd_wallSlide(root, character, Vector3.new(md.X / mag, 0, md.Z / mag), speed)
        if dir.Magnitude < 0.05 then
            _s2VelState.v = Vector3.new(0, y, 0)
            root.AssemblyLinearVelocity = Vector3.new(0, y, 0)
        else
            _s2VelState.v = Vector3.new(dir.X * 20, y, dir.Z * 16)
            root.AssemblyLinearVelocity = Vector3.new(dir.X * speed, y, dir.Z * speed)
        end
    elseif _s2VelState.v ~= Vector3.zero then
        _s2VelState.v = Vector3.zero
    end
end

function _spd_start()
    _spd_stop()
    _G.__LustSpeedEngine.started = true
    local _spdCacheChar, _spdCacheHum, _spdCacheRoot = nil, nil, nil
    local _spdSuppressed = false
    -- Guardia de gravedad (como Hook)
    pcall(function()
        if workspace.Gravity > 300 then workspace.Gravity = 196.2 end
        _G.__LustSpeedEngine.gravConn = workspace:GetPropertyChangedSignal("Gravity"):Connect(function()
            if workspace.Gravity > 300 then workspace.Gravity = 196.2 end
        end)
    end)
    _G.__LustSpeedEngine.conn = _LustOn(_G.__LustSpeedEngine.signal or RunService.Heartbeat, function()
        local character = LP.Character
        if not character then return end
        if character ~= _spdCacheChar then
            _spdCacheChar = character
            _spdCacheHum  = character:FindFirstChildOfClass("Humanoid")
            _spdCacheRoot = character:FindFirstChild("HumanoidRootPart")
        end
        local humanoid, root = _spdCacheHum, _spdCacheRoot
        if not humanoid or not humanoid.Parent then
            _spdCacheHum = character:FindFirstChildOfClass("Humanoid"); humanoid = _spdCacheHum
        end
        if not root or not root.Parent then
            _spdCacheRoot = character:FindFirstChild("HumanoidRootPart"); root = _spdCacheRoot
        end
        if not humanoid or not root then return end
        if humanoid.Health <= 0 then return end
        if autoBatEnabled or dropActive or _G.IsDropping or autoPlayEnabled
           or (Config and Config._instaResetInProgress) then
            -- Otro modulo controla el movimiento: se limpia UNA vez.
            if not _spdSuppressed then
                _spdSuppressed = true
                _spd_resetMovement()
            end
            return
        end
        _spdSuppressed = false
        _spd_step(humanoid, root, character)
    end)
end

function _spd_applyNow()
    if autoBatEnabled or autoPlayEnabled or dropActive or _G.IsDropping
       or (Config and Config._instaResetInProgress) then return end
    local character = LP.Character
    local hum = character and character:FindFirstChildOfClass("Humanoid")
    local root = character and character:FindFirstChild("HumanoidRootPart")
    if not hum or not root or hum.Health <= 0 then return end
    _spd_step(hum, root, character)
end

function _spd_refresh() _spd_start() end
_G.__LustRefreshSpeedEngine = _spd_refresh
_G.__LustStopSpeedEngine = _spd_stop
_G.__LustApplySpeedNow = _spd_applyNow
pcall(_spd_start)

_LustOn(LP.CharacterAdded, function(character)
    task.wait(0.1)
    _spd_resetMovement()
    local root = character:WaitForChild("HumanoidRootPart", 5)
    if root then _setupVelChecked(character); _hookVelHRP(root) end
    _spd_start()
end)
_LustOn(LP.CharacterRemoving, function()
    _spd_stop()
    _s2VelState.root = nil
end)

_ncConns = _ncConns or {}

function setupMovementAndIndicators(char)
    if steppedConn then steppedConn:Disconnect(); steppedConn = nil end
    if movementLoop then movementLoop:Disconnect(); movementLoop = nil end
    for _, c in ipairs(_ncConns) do pcall(function() c:Disconnect() end) end
    _ncConns = {}
    local ncCache = setmetatable({}, {__mode = "k"})
    local function ncRegister(ch)
        local entry = ncCache[ch]
        if entry then return entry end
        local list = {}
        for _, d in ipairs(ch:GetDescendants()) do
            if d:IsA("BasePart") then list[#list + 1] = d end
        end
        entry = { list = list }
        local c = ch.DescendantAdded:Connect(function(d)
            if d:IsA("BasePart") then
                list[#list + 1] = d
                d.CanCollide = false
            end
        end)
        _ncConns[#_ncConns + 1] = c
        ncCache[ch] = entry
        return entry
    end
    steppedConn = _LustOn(RunService.Stepped, function()
        local plist = _GetPlayersCached()
        for i = 1, #plist do
            local p = plist[i]
            if p ~= LP then
                local ch = p.Character
                if ch and ch.Parent then
                    local list = ncRegister(ch).list
                    local j = 1
                    while j <= #list do
                        local part = list[j]
                        if part.Parent then
                            if part.CanCollide then part.CanCollide = false end
                            j = j + 1
                        else
                            list[j] = list[#list]
                            list[#list] = nil
                        end
                    end
                end
            end
        end
    end)
    movementLoop = _LustOn(RunService.RenderStepped, function()
        local char2 = LP.Character; if not char2 then return end
        local hum = char2:FindFirstChildOfClass("Humanoid")
        local hrp = char2:FindFirstChild("HumanoidRootPart")
        if not hum or not hrp then return end
        if not autoBatEnabled and not autoPlayEnabled then
            if _isRagdollState(hum) then lastMoveDir = _V3zero
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
    if setLockUIVisual then setLockUIVisual(state) end
end

function stopAllBackgroundTasks()
    if movementLoop then movementLoop:Disconnect(); movementLoop = nil end
    if steppedConn then steppedConn:Disconnect(); steppedConn = nil end
    stopEnemySpeed()
    if stretchEnabled then disableStretch() end
    if stretchConn then stretchConn:Disconnect(); stretchConn = nil end
    if stretchFovConn then stretchFovConn:Disconnect(); stretchFovConn = nil end
    pcall(stopAntiRagdollAll)
    if antiDieEnabled then AntiDieModule.stop() end
    stopBatCounter()
    stopMedusaCounter()
    stopAutoSteal()
    disableAutoBat()
    if stopAutoPlay and _apFlag11 then stopAutoPlay() end
    if unwalkEnabled then stopUnwalk() end
    if antiLagEnabled then disableAntiLag() end
    if espEnabled then toggleESP(false) end
    if espLineEnabled then stopESPLine() end
    if dropActive then stopDropBrainrot() end
    if bodyLockEnabled then stopBodyLock() end
    if _G.__LustFloat and _G.__LustFloat.running then _G.__LustFloat.disable() end
    _blSuppressCount = 0; _blWasEnabled = false
    if _blRestoreTimer then pcall(task.cancel, _blRestoreTimer); _blRestoreTimer = nil end
    if _bodyLockConn then _bodyLockConn:Disconnect(); _bodyLockConn = nil end
    for _, t in ipairs(dropConnections) do
        if type(t) == "thread" then pcall(task.cancel, t)
        elseif type(t) == "RBXScriptConnection" then pcall(t.Disconnect, t) end
    end
    dropConnections = {}
    dropActive = false
    lastDropTime = 0
    medusaDebounce = false
    medusaLastUsed = 0
    if _G.__LustStopSpeedEngine then pcall(_G.__LustStopSpeedEngine) end
end


function _lustGetFullFileAPI()
    local env = (getgenv and getgenv()) or _G
    local direct = { readfile = readfile, writefile = writefile, delfile = delfile, isfile = isfile }
    local function pick(name)
        local f = direct[name]
        if type(f) == "function" then return f end
        local okg, g = pcall(function() return env[name] end)
        if okg and type(g) == "function" then return g end
        local oks, sy = pcall(function() return syn and syn[name] end)
        if oks and type(sy) == "function" then return sy end
        return nil
    end
    return pick("readfile"), pick("writefile"), pick("delfile"), pick("isfile")
end

function resolveLustFileApi()
    local r, w = _lustGetFullFileAPI()
    return r, w
end

function lustFileExists(path)
    local readFn, _, _, isFileFn = _lustGetFullFileAPI()
    if type(isFileFn) == "function" then
        local ok, res = pcall(isFileFn, path)
        if ok then return res == true end
    end
    if type(readFn) ~= "function" then return false end
    local ok, data = pcall(readFn, path)
    return ok and type(data) == "string" and #data > 0
end

function _lustReadJson(path)
    local readFn = _lustGetFullFileAPI()
    if type(readFn) ~= "function" or not lustFileExists(path) then return nil end
    local ok, raw = pcall(readFn, path)
    if not ok or type(raw) ~= "string" or #raw == 0 then return nil end
    local okJ, data = pcall(function() return HS:JSONDecode(raw) end)
    if okJ and type(data) == "table" then return data end
    return nil
end

function _lustPurgeConfig()
    local _, _, delFn = _lustGetFullFileAPI()
    if type(delFn) == "function" and lustFileExists(CONFIG_FILE) then pcall(delFn, CONFIG_FILE) end
end

function buildConfigTable()
    local config = {
        configVersion = LUST_CONFIG_VERSION,
        userId = LP.UserId,
        normalSpeed = NS, carrySpeed = CS,
        laggerSpeed1 = LAGGER_SPEED, laggerSpeed2 = LAGGER_CARRY_SPEED,
        stealRadius = CONFIG.STEAL_RANGE,
        normalStealPausePercent = LustSteal.NormalStealPausePercent,
        antiRagdollMode = antiRagdollMode, antiRagdollSel = _antiRagLastOn, antiDieEnabled = (_antiDieUserPref == true),
        autoSteal = CONFIG.AUTO_STEAL_ENABLED,
        medusaCounter = medusaCounterEnabled, batCounter = batCounterEnabled,
        unwalkEnabled = unwalkEnabled,
        laggerToggled = laggerToggled, laggerCarryToggled = laggerCarryToggled,
        carryMode = speedMode, batAimbotSpeed = BAT_AIMBOT_SPEED,
        dropMode = dropMode, stretchEnabled = stretchEnabled, stretchFOV = stretchFOV,
        uiScale = uiScaleValue, animPack = currentAnimPack,
        espEnabled = espEnabled, espLineEnabled = espLineEnabled,
        saturationEnabled = saturationEnabled,
        baseXRayEnabled = _G.LustBaseXRayEnabled,
        baseXRayTransparency = _G.LustBaseXRayTransparency,
        hideButtons = hideButtonsEnabled,
        antiLag = antiLagEnabled,
        skyTheme = skyTheme, mobileButtonPositions = savedButtonPositions,
        dropBrainrotKey = {kb = KB.DropBrainrot.kb and KB.DropBrainrot.kb.Name, gp = KB.DropBrainrot.gp and KB.DropBrainrot.gp.Name},
        autoPlayKey = {kb = KB.AutoPlay.kb and KB.AutoPlay.kb.Name, gp = KB.AutoPlay.gp and KB.AutoPlay.gp.Name},
        autoBatKey = {kb = KB.AutoBat.kb and KB.AutoBat.kb.Name, gp = KB.AutoBat.gp and KB.AutoBat.gp.Name},
        tpFloorKey = {kb = KB.TPFloor.kb and KB.TPFloor.kb.Name, gp = KB.TPFloor.gp and KB.TPFloor.gp.Name},
        carryToggleKey = {kb = KB.CarryToggle.kb and KB.CarryToggle.kb.Name, gp = KB.CarryToggle.gp and KB.CarryToggle.gp.Name},
        laggerModeKey = {kb = KB.LaggerMode.kb and KB.LaggerMode.kb.Name, gp = KB.LaggerMode.gp and KB.LaggerMode.gp.Name},
        instaResetKey = {kb = KB.InstaReset.kb and KB.InstaReset.kb.Name, gp = KB.InstaReset.gp and KB.InstaReset.gp.Name},
        floatKey = {kb = KB.Float and KB.Float.kb and KB.Float.kb.Name, gp = KB.Float and KB.Float.gp and KB.Float.gp.Name},
        instaResetFloatingPos = instaResetFloatingPos,
        bodyLockEnabled = bodyLockEnabled, bodyLockRange = bodyLockRange,
        progressBarPos = savedProgressBarPos, lockUI = uiLocked,
        floatingButtonScale = floatingButtonScale,
        outfitIndex = currentOutfitIndex, outfitLabel = OUTFITS[currentOutfitIndex] and OUTFITS[currentOutfitIndex].label, themeColor = currentColorTheme,
        tpDownAutoEnabled = tpDownAutoEnabled,
        tpDownAutoHeight  = tpDownAutoHeight,
        mirrorTP = _G.LustMirrorTPDownEnabled,
        autoSwing = autoSwingEnabled ~= false,
        autoPlayVersion = Config.autoPlayVersion,
        autoPlayMode    = Config.autoPlayMode,
        floatEnabled    = (_G.__LustFloat and _G.__LustFloat.running) or false,
        autoCarryEnabled = autoCarryEnabled == true,
        autoCarryMode    = autoCarryMode,
    }
    config.hideButtonFlags = hideButtonFlags
    do
        local mp = _G.__LustMainOriginalPos or (main and main.Position)
        if mp then config.mainMenuPos = { X = mp.X.Offset, Y = mp.Y.Offset } end
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
    if not _lustSessionAlive() then return true end
    if not _lustBootDone or _isResetting or _isLoading then return false end
    local _, writeFn = _lustGetFullFileAPI()
    if type(writeFn) ~= "function" then return false end
    local okEnc, json = pcall(function() return HS:JSONEncode(buildConfigTable()) end)
    if not okEnc then return false end
    if not force and json == _lastSavedJSON then return true end
    local ok = pcall(writeFn, CONFIG_FILE, json)
    if ok then _lastSavedJSON = json end
    return ok
end

function loadAllSettings()
    local data
    for _ = 1, 3 do
        data = _lustReadJson(CONFIG_FILE)
        if data then break end
        if not lustFileExists(CONFIG_FILE) then return false end
        task.wait(0.2)
    end
    if not data then return false end
    data.configVersion = tonumber(data.configVersion) or 0
    _isLoading = true
    pcall(function()
        NS = data.normalSpeed or NS
        CS = data.carrySpeed or CS
        LAGGER_SPEED = data.laggerSpeed1 or LAGGER_SPEED
        LAGGER_CARRY_SPEED = data.laggerSpeed2 or LAGGER_CARRY_SPEED
        CONFIG.STEAL_RANGE = data.stealRadius or CONFIG.STEAL_RANGE
        LustSteal.StealRadius = CONFIG.STEAL_RANGE
        if data.normalStealPausePercent then
            LustSteal.NormalStealPausePercent = normalizeNormalPausePercent(data.normalStealPausePercent)
            if _G.__LustSetNormalPauseSelector then
                task.defer(function() _G.__LustSetNormalPauseSelector(LustSteal.NormalStealPausePercent, true) end)
            end
        end
        if radInput then radInput.Text = tostring(CONFIG.STEAL_RANGE) end
        if tonumber(data.configVersion) >= 2 and data.lockUI ~= nil then uiLocked = data.lockUI
        else uiLocked = false end
        mobileButtonsLocked = false
        local m = data.antiRagdollMode
        if m ~= "off" and m ~= "v1" and m ~= "v2" then m = data.antiRagdoll and "v2" or "off" end
        antiRagdollMode = m
        local sel = data.antiRagdollSel
        if sel ~= "v1" and sel ~= "v2" then sel = (m ~= "off") and m or "v2" end
        _antiRagLastOn = sel
    end)
    pcall(function()
        antiDieEnabled = data.antiDieEnabled or false
        _antiDieUserPref = antiDieEnabled
        CONFIG.AUTO_STEAL_ENABLED = data.autoSteal or false
        medusaCounterEnabled = data.medusaCounter or false
        batCounterEnabled = data.batCounter or false
        unwalkEnabled = data.unwalkEnabled or data.unwalk or false
        antiLagEnabled = data.antiLag or false
        laggerToggled = data.laggerToggled or false
        speedMode = data.carryMode or false
        laggerCarryToggled = data.laggerCarryToggled or false
        uiScaleValue = _clamp(tonumber(data.uiScale) or 78, 50, 150)
        if mainUIScale then mainUIScale.Scale = uiScaleValue / 100 end
        if stealBarScaleObj then stealBarScaleObj.Scale = uiScaleValue / 100 end
    end)
    pcall(function()
        espEnabled = data.espEnabled or false
        espLineEnabled = data.espLineEnabled or false
        if espEnabled then pcall(toggleESP, true) else pcall(toggleESP, false) end
    end)
    pcall(function()
        saturationEnabled = data.saturationEnabled or false
        _G.LustBaseXRayEnabled = data.baseXRayEnabled == true
        _G.LustBaseXRayTransparency = math.clamp(tonumber(data.baseXRayTransparency) or 0.5, 0, 1)
        if _G.LustBaseXRayEnabled and _G.LustSetBaseXRay then
            task.defer(function() pcall(_G.LustSetBaseXRay, true) end)
        end
        if _G.__LustXRaySetVisual then pcall(_G.__LustXRaySetVisual, _G.LustBaseXRayEnabled == true) end
        hideButtonsEnabled = data.hideButtons or false
        if type(data.hideButtonFlags) == "table" then
            hideButtonFlags = {}
            for k, v in pairs(data.hideButtonFlags) do
                if type(k) == "string" and v == false then hideButtonFlags[k] = false end
            end
        end
        if _G.__LustHideFlagsRefresh then pcall(_G.__LustHideFlagsRefresh) end
        if type(data.mainMenuPos) == "table" and tonumber(data.mainMenuPos.X) and tonumber(data.mainMenuPos.Y) then
            savedMainMenuPos = { X = tonumber(data.mainMenuPos.X), Y = tonumber(data.mainMenuPos.Y) }
            if main then main.Position = UDim2.new(0, savedMainMenuPos.X, 0, savedMainMenuPos.Y) end
        end
        local savedTheme = data.themeColor
        if savedTheme and COLOR_THEMES[savedTheme] then currentColorTheme = savedTheme
        else currentColorTheme = "White" end
        selectedColor = COLOR_THEMES[currentColorTheme]
        task.defer(function() updateAllUIThemeColors(selectedColor) end)
        skyTheme = data.skyTheme or "Off"
        if skyTheme ~= "Off" then pcall(applyCustomSky, skyTheme) end
        if skySelectorLabel then skySelectorLabel.Text = skyTheme end
        if data.animPack and ANIM_PACKS[data.animPack] then pcall(startAnimPack, data.animPack)
        else currentAnimPack = "Off"; stopAnimPack() end
    end)
    pcall(function()
        local function lk(e, d)
            if not d then return end
            if d.kb and Enum.KeyCode[d.kb] then e.kb = Enum.KeyCode[d.kb] end
            if d.gp and Enum.KeyCode[d.gp] then e.gp = Enum.KeyCode[d.gp] end
        end
        lk(KB.DropBrainrot, data.dropBrainrotKey)
        lk(KB.AutoPlay, data.autoPlayKey)
        lk(KB.AutoBat, data.autoBatKey)
        lk(KB.TPFloor, data.tpFloorKey)
        lk(KB.CarryToggle, data.carryToggleKey)
        lk(KB.LaggerMode, data.laggerModeKey)
        lk(KB.InstaReset, data.instaResetKey)
        lk(KB.Float, data.floatKey)
        if data.mobileButtonPositions then savedButtonPositions = data.mobileButtonPositions end
        if data.mobilePanelPos then savedMobilePanelPos = data.mobilePanelPos end
        if data.instaResetFloatingPos then instaResetFloatingPos = data.instaResetFloatingPos end
        if data.progressBarPos then savedProgressBarPos = data.progressBarPos end
    end)
    pcall(function()
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
        if data.tpDownAutoEnabled ~= nil then tpDownAutoEnabled = data.tpDownAutoEnabled end
        if data.autoCarryEnabled ~= nil then autoCarryEnabled = data.autoCarryEnabled == true end
        if data.autoCarryMode == "Lagger" or data.autoCarryMode == "Normal" then autoCarryMode = data.autoCarryMode end
        if _G.__LustAutoCarryRefresh then pcall(_G.__LustAutoCarryRefresh) end
        if data.tpDownAutoHeight then tpDownAutoHeight = data.tpDownAutoHeight end
        dropMode = data.dropMode or 1
        stretchEnabled = data.stretchEnabled or false
        stretchFOV = data.stretchFOV or 120
        BAT_AIMBOT_SPEED = data.batAimbotSpeed or BAT_AIMBOT_SPEED
        floatingButtonScale = data.floatingButtonScale or 1
        _G.LustMirrorTPDownEnabled = data.mirrorTP == true
        if data.autoSwing ~= nil then autoSwingEnabled = data.autoSwing == true end
        if _G.LustSetMirrorTPDown then pcall(_G.LustSetMirrorTPDown, _G.LustMirrorTPDownEnabled) end
        if data.autoPlayVersion then Config.autoPlayVersion = data.autoPlayVersion end
        if data.autoPlayMode    then Config.autoPlayMode    = data.autoPlayMode    end
        if Config.autoPlayMode == "half" then Config.autoPlayMode = "semi" end
        if Config.autoPlayMode ~= "semi" then Config.autoPlayMode = "full" end
        if _G.__LustAutoPlayRefresh then pcall(_G.__LustAutoPlayRefresh) end
    end)
    pcall(function()
        local _savedOutfit = data.outfitIndex
        if data.outfitLabel then
            for i, o in ipairs(OUTFITS) do if o.label == data.outfitLabel then _savedOutfit = i; break end end
        end
        if _savedOutfit and _savedOutfit >= 1 and _savedOutfit <= #OUTFITS then
            currentOutfitIndex = _savedOutfit
            task.defer(function()
                pcall(function() applyOutfitByIndex(currentOutfitIndex) end)
                if outfitSelectorLabel then outfitSelectorLabel.Text = OUTFITS[currentOutfitIndex].label end
            end)
        end
        if saturationEnabled then task.defer(function() pcall(applySaturation, true) end)
        else task.defer(function() pcall(applySaturation, false) end) end
    end)
    pcall(function()
        autoBatEnabled = false
        autoPlayEnabled = false
        if syncDropModeUI then syncDropModeUI() end
        refreshSpeedModeLabel()
        if _G.__LustFloat and _G.__LustFloat.running then _G.__LustFloat.disable() end
        if _G.__LustFloatSetVisual then pcall(_G.__LustFloatSetVisual, false) end
        if mobSetFloat then pcall(mobSetFloat, false) end
        if data.floatEnabled then
            task.defer(function()
                pcall(function() _G.__LustFloat.enable() end)
                if _G.__LustFloatSetVisual then pcall(_G.__LustFloatSetVisual, true) end
                if mobSetFloat then pcall(mobSetFloat, true) end
            end)
        end
    end)
    _isLoading = false
    _lastSavedJSON = nil
    task.defer(function() pcall(saveAllSettings, true) end)
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
    if buttonScaleBox then buttonScaleBox.Text = tostring(_floor(floatingButtonScale * 100 + 0.5)) end
    if syncDropModeUI then syncDropModeUI() end
    if bodyLockRangeBox then bodyLockRangeBox.Text = tostring(bodyLockRange) end
    local function safeSet(fn, val) if fn then fn(val) end end
    safeSet(autoBatSetVisual, false); safeSet(autoPlaySetVisual, false)
    safeSet(setBatCounterVisual, false); safeSet(setMedusaVisual, false); safeSet(setUnwalkVisual, false)
    safeSet(setAntiLagVisual, false); safeSet(setLockUIVisual, false); safeSet(setInstaGrab, false)
    safeSet(setESPVIsual, false); safeSet(setESPLineVisual, false)
    safeSet(setSaturationVisual, false)
    safeSet(setHideButtonsVisual, false); safeSet(bodyLockSetVisual, false)
    safeSet(setAntiDieVisual, false); safeSet(setAntiRagVisual, false)
    _antiRagLastOn = "v2"
    if _antiRagSel then
        _antiRagSyncing = true
        pcall(_antiRagSel.setByValue, ANTIRAG_NAMES.v2, true)
        _antiRagSyncing = false
    end
    safeSet(mirrorTPSetVisual, false)
    safeSet(_G.__LustXRaySetVisual, false)
    safeSet(_G.__LustSwingSetVisual, true)
    safeSet(_G.__LustTpDownSetVisual, false)
    if _G.LustSetMirrorTPDown then pcall(_G.LustSetMirrorTPDown, false) end
    safeSet(_G.__LustFloatSetVisual, false)
    if _G.__LustFloat and _G.__LustFloat.running then _G.__LustFloat.disable() end
    disableVividGraphics()
    if _G.LustSetBaseXRay then pcall(_G.LustSetBaseXRay, false) end
    hideButtonFlags = {}
    if _G.__LustHideFlagsRefresh then pcall(_G.__LustHideFlagsRefresh) end
    applyHideButtons(false)
    savedMainMenuPos = nil
    if main then main.Position = UDim2.new(0, 20, 0, 2) end
    if _G.stretchToggleSetter then _G.stretchToggleSetter(false) end
    safeSet(mobSetAutoBat, false); safeSet(mobSetAutoPlay, false)
    safeSet(mobSetDropBR, false); safeSet(mobSetTpDown, false); safeSet(mobSetCarry, false)
    safeSet(mobSetLagger1, false); safeSet(mobSetLagger2, false); safeSet(mobSetFloat, false)
    refreshSpeedModeLabel()
    updateProgressBarVisibility()
    disableAntiLag()
    if stopESPLine then stopESPLine() end
    skyTheme = "Off"
    pcall(applyCustomSky, "Off")
    if skySelectorLabel then skySelectorLabel.Text = "Off" end
    if antiDieEnabled then AntiDieModule.stop(); antiDieEnabled = false end
    _antiDieUserPref = false
    for _, ref in ipairs(keyButtonRefs) do
        local entry = ref.entry
        local label = (entry.gp and entry.gp.Name) or (entry.kb and entry.kb.Name) or "None"
        ref.btn.Text = label
    end
    currentColorTheme = "White"
    selectedColor = COLOR_THEMES["White"]
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
    local cam = workspace.CurrentCamera
    local vpW = (cam and cam.ViewportSize.X) or 1920
    if MobilePanel then
        savedButtonPositions = {}
        for _, btn in ipairs(MobilePanel:GetChildren()) do
            if btn:IsA("TextButton") and btn.Name then
                local defX, defY = getDefaultButtonPosition(btn.Name)
                btn.Position = UDim2.new(0, defX, 0, defY)
            end
        end
    end
    if instaResetFloatingButton and instaResetFloatingButton:FindFirstChild("Frame") then
        instaResetFloatingButton.Frame.Position = UDim2.new(0, vpW - 80, 0, 6)
        instaResetFloatingPos = nil
    end
    if pbFrame then
        pbFrame.Position = UDim2.new(0.5, 0, 1, -52)
        savedProgressBarPos = nil
    end
    savedMobilePanelPos = nil
end

function resetToFactoryDefaults()
    _isResetting = true
    local ok, err = pcall(function()
        stopAutoSteal(); stopBatCounter(); stopMedusaCounter()
        pcall(stopAntiRagdollAll)
        if antiDieEnabled then AntiDieModule.stop() end
        stopUnwalk(); disableAutoBat()
        if Config._isAutoplayActive and Config._isAutoplayActive() then stopAutoPlay() end
        stopBodyLock()
        if espEnabled then toggleESP(false) end
        if espLineEnabled and stopESPLine then stopESPLine() end
        if stretchEnabled then disableStretch() end
        if antiLagEnabled then disableAntiLag() end
        if saturationEnabled then applySaturation(false) end
        if _G.LustSetBaseXRay then pcall(_G.LustSetBaseXRay, false) end
        if hideButtonsEnabled then applyHideButtons(false) end
        if dropActive then stopDropBrainrot() end
        if _G.__LustFloat and _G.__LustFloat.running then _G.__LustFloat.disable() end
        _G.LustMirrorTPDownEnabled = false
        if _G.LustSetMirrorTPDown then pcall(_G.LustSetMirrorTPDown, false) end
        skyTheme = "Off"
        pcall(applyCustomSky, "Off")
        if skySelectorLabel then skySelectorLabel.Text = "Off" end
        NS = 60; CS = 29; LAGGER_SPEED = 15; LAGGER_CARRY_SPEED = 24.5
        CONFIG.STEAL_RANGE = 60
        LustSteal.StealRadius = 60
        LustSteal.NormalStealPausePercent = 75
        if _G.__LustSetNormalPauseSelector then _G.__LustSetNormalPauseSelector(75, true) end
        speedMode = false; laggerToggled = false; laggerCarryToggled = false
        autoCarryEnabled = false; autoCarryMode = "Normal"
        if _G.__LustAutoCarryRestore then pcall(_G.__LustAutoCarryRestore) end
        if _G.__LustAutoCarryRefresh then pcall(_G.__LustAutoCarryRefresh) end
        antiRagdollMode = "off"; antiDieEnabled = false; _antiDieUserPref = false
        medusaCounterEnabled = false; batCounterEnabled = false
        autoBatEnabled = false; autoPlayEnabled = false
        Config.autoPlayMode = "full"
        if _G.__LustAutoPlayRefresh then pcall(_G.__LustAutoPlayRefresh) end
        unwalkEnabled = false; antiLagEnabled = false
        uiLocked = false; mobileButtonsLocked = false
        CONFIG.AUTO_STEAL_ENABLED = false
        BAT_AIMBOT_SPEED = 58
        dropMode = 1; stretchEnabled = false; stretchFOV = 120
        uiScaleValue = 78
        tpDownAutoEnabled = false
        tpDownAutoHeight = 10
        if mainUIScale then mainUIScale.Scale = 1 end
        if stealBarScaleObj then stealBarScaleObj.Scale = 1 end
        espEnabled = false; espLineEnabled = false; hideButtonsEnabled = false
        hideButtonFlags = {}
        saturationEnabled = false
        bodyLockEnabled = false; bodyLockRange = 20
        autoSwingEnabled = true
        floatingButtonScale = 1
        currentAnimPack = "Off"; stopAnimPack()
        currentOutfitIndex = 1
        currentColorTheme = "White"; selectedColor = COLOR_THEMES["White"]
        if main then main.Position = UDim2.new(0, 20, 0, 2); _G.__LustMainOriginalPos = main.Position end
        for key, val in pairs(DEFAULT_KB) do
            if KB[key] then KB[key].kb = val.kb; KB[key].gp = val.gp end
        end
        resetFloatingPositions()
        forceResetUI()
        updateProgressBarVisibility()
        refreshSpeedModeLabel()
        _lustPurgeConfig()
        _lastSavedJSON = nil
    end)
    _isResetting = false
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
            t = t + 0.05
            grad.Offset = Vector2.new(math.sin(t * speed) * 0.4, 0)
            task.wait(0.02)
        end
    end)
    return grad
end

function getDefaultButtonPosition(btnName)
    local BTN_W, BTN_H = 52, 52
    local GAP = 10
    local orderMap = { DropBR = 0, AutoPlay = 1, AutoBat = 2, TpDown = 3, Carry = 4, Lagger1 = 5, Lagger2 = 6, Float = 7 }
    local order = orderMap[btnName] or 0
    local row = _floor(order / 2)
    local col = order % 2
    local cam = workspace.CurrentCamera
    local vpW = (cam and cam.ViewportSize.X) or 1920
    local x = vpW - 72 - col * (BTN_W + GAP)
    local y = 30 + row * (BTN_H + GAP + 8)
    return x, y
end

do
    if not _G.LustInstaResetLoaded then
        _G.LustInstaResetLoaded = true
        local state = _G._LustInstaResetState
        if type(state) ~= "table" then
            state = { busy = false, busyAt = 0, token = 0, cameraConn = nil, cameraHeld = false, cameraHeldAt = 0, speed = 1000000, wantAntiDie = nil }
            _G._LustInstaResetState = state
        end
        local HOLD_TIME = 1.5
        local FALLBACK = 1.2
        local WAIT_RESPAWN = 8
        local function suspendGuards()
            if _antiDieEnabled then state.wantAntiDie = true; pcall(function() _antiDieSetEnabled(false) end) end
            if AntiDieModule and AntiDieModule.enabled then state.wantAntiDie = true; pcall(function() AntiDieModule.stop() end) end
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
        end
        local function holdCamera(oldChar)
            local cam = workspace.CurrentCamera; if not cam then return end
            if state.cameraHeld and (os.clock() - (state.cameraHeldAt or 0)) < 5 then return end
            state.cameraHeld = true
            state.cameraHeldAt = os.clock()
            local heldCFrame, heldFocus = cam.CFrame, cam.Focus
            pcall(function() cam.CameraType = Enum.CameraType.Scriptable; cam.CFrame = heldCFrame; cam.Focus = heldFocus end)
            state.cameraConn = _LustOn(RunService.RenderStepped, function()
                if workspace.CurrentCamera ~= cam then return end
                cam.CameraType = Enum.CameraType.Scriptable
                cam.CFrame = heldCFrame
                cam.Focus = heldFocus
            end)
            task.spawn(function()
                local elapsed = 0
                while LP.Character == oldChar and elapsed < 3 do elapsed = elapsed + task.wait() end
                if state.cameraConn then pcall(function() state.cameraConn:Disconnect() end); state.cameraConn = nil end
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
            local hum = character and character:FindFirstChildOfClass("Humanoid"); if not hum then return end
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
            Config._instaResetInProgress = true
            suspendGuards()
            task.spawn(function()
                holdCamera(character)
                if not flingUp(character) then hardKill(character) end
                local elapsed = 0
                while LP.Character == character and elapsed < FALLBACK do elapsed = elapsed + task.wait() end
                if LP.Character == character then
                    local hum2 = character:FindFirstChildOfClass("Humanoid")
                    if hum2 and hum2.Health > 0 then hardKill(character) end
                end
                local waited = 0
                while LP.Character == character and waited < WAIT_RESPAWN do waited = waited + task.wait() end
                if state.token ~= myToken then return end
                state.busy = false
                restoreGuards()
                Config._instaResetInProgress = false
            end)
        end
        _LustOn(RunService.Heartbeat, function()
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
        _LustOn(LP.CharacterAdded, function()
            state.cameraHeld = false
            if state.cameraConn then pcall(function() state.cameraConn:Disconnect() end); state.cameraConn = nil end
        end)
        local _lastRequest = 0
        _G.LustInstaReset = {
            Trigger = function()
                local now = os.clock()
                if now - _lastRequest < 0.15 then return end
                _lastRequest = now
                doReset()
            end,
        }
        _G.VynxDoInstaReset = _G.LustInstaReset.Trigger
    end
end

_G.LustMirrorTPDownEnabled = _G.LustMirrorTPDownEnabled == true

do
    local yMap = {}
    local lastFire = 0
    local COOLDOWN = 0.3

    local function mirrorShouldRun()
        return autoBatEnabled == true or autoPlayEnabled == true or _apFlag11 == true
    end

    local function doMirrorTPDown()
        if _tick() - lastFire < COOLDOWN then return end
        lastFire = _tick()
        local ch = LP.Character
        local hrp = ch and ch:FindFirstChild("HumanoidRootPart")
        local hum = ch and ch:FindFirstChildOfClass("Humanoid")
        if not hrp or not hum or hum.Health <= 0 then return end
        local _, yaw = hrp.CFrame:ToEulerAnglesYXZ()
        hrp.CFrame = CFrame.new(hrp.Position.X, -7, hrp.Position.Z) * CFrame.Angles(0, yaw, 0)
        hrp.Velocity = Vector3.zero
        hrp.AssemblyLinearVelocity = Vector3.zero
        if _lustAimbot and _lustAimbot.onTeleport then pcall(_lustAimbot.onTeleport) end
    end

    _LustOn(RunService.Heartbeat, function()
        if not _G.LustMirrorTPDownEnabled or not mirrorShouldRun() then
            table.clear(yMap)
            return
        end
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LP and plr.Character then
                local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local y = hrp.Position.Y
                    local prev = yMap[plr.UserId]
                    if prev and prev - y >= 3 then
                        doMirrorTPDown()
                        table.clear(yMap)
                        return
                    end
                    yMap[plr.UserId] = y
                end
            end
        end
    end)

    _G.LustSetMirrorTPDown = function(on)
        _G.LustMirrorTPDownEnabled = on == true
        mirrorTPEnabled = _G.LustMirrorTPDownEnabled
        if not on then table.clear(yMap) end
    end
end

function buildGui()
    local ROW_BG = Color3.fromRGB(10,10,10)
    local ROW_BORDER = Color3.fromRGB(50,50,50)
    local WHITE = Color3.fromRGB(255,255,255)
    local INP = Color3.fromRGB(15,15,15)
    local GUI_W, GUI_H = 330, 480

    local GUI_NAMES = {"Lust Hub", "LustMobilePanel", "InstaResetButton", "LustSpeedIndicator", "LustBootErrors"}

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
    gui.Name = "Lust Hub"
    gui.ResetOnSpawn = false
    gui.DisplayOrder = 10
    gui.IgnoreGuiInset = true
    pcall(function() if syn and syn.protect_gui then syn.protect_gui(gui) end end)
    local guiOk = pcall(function() gui.Parent = game:GetService("CoreGui") end)
    if not guiOk then gui.Parent = LP:WaitForChild("PlayerGui") end

    main = Instance.new("Frame", gui)
    main.Size = UDim2.new(0, GUI_W, 0, GUI_H)
    main.Position = UDim2.new(0, 20, 0, 2)
    if savedMainMenuPos then main.Position = UDim2.new(0, savedMainMenuPos.X, 0, savedMainMenuPos.Y) end
    main.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    main.BackgroundTransparency = 0
    main.BorderSizePixel = 0
    main.ClipsDescendants = true
    Instance.new("UICorner", main).CornerRadius = UDim.new(0, 14)
    local mainStroke = Instance.new("UIStroke", main)
    mainStroke.Color = Color3.fromRGB(30, 30, 30)
    mainStroke.Thickness = 1
    local hubTitle = Instance.new("TextLabel", main)
    hubTitle.Name = "HubTitle"
    hubTitle.Size = UDim2.new(1, -70, 0, 24)
    hubTitle.Position = UDim2.new(0, 18, 0, 10)
    hubTitle.BackgroundTransparency = 1
    hubTitle.Text = "LUST HUB"
    hubTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    hubTitle.Font = Enum.Font.GothamBlack
    hubTitle.TextSize = 15
    hubTitle.TextXAlignment = Enum.TextXAlignment.Left
    hubTitle.ZIndex = 20

    local scriptHeader = Instance.new("Frame", main)
    scriptHeader.Name = "ScriptHeader"
    scriptHeader.Size = UDim2.new(1, -20, 0, 8)
    scriptHeader.Position = UDim2.new(0, 10, 0, 0)
    scriptHeader.BackgroundTransparency = 1
    scriptHeader.BorderSizePixel = 0
    scriptHeader.ZIndex = 8
    Instance.new("UICorner", scriptHeader).CornerRadius = UDim.new(0, 13)

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
    closeBtn.TextSize = 26
    closeBtn.AutoButtonColor = false
    closeBtn.ZIndex = 200

    closeBtn.MouseEnter:Connect(function() TS:Create(closeBtn, TweenInfo.new(0.06), {TextColor3 = getThemeColor()}):Play() end)
    closeBtn.MouseLeave:Connect(function() TS:Create(closeBtn, TweenInfo.new(0.06), {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play() end)

    miniBtn = Instance.new("TextButton", gui)
    miniBtn.Name = "MinimizedFrame"
    miniBtn.Size = UDim2.fromOffset(58, 58)
    miniBtn.Position = UDim2.new(0, 18, 0, 60)
    miniBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    miniBtn.BackgroundTransparency = 0
    miniBtn.BorderSizePixel = 0
    miniBtn.Text = ""
    miniBtn.AutoButtonColor = false
    miniBtn.ZIndex = 20
    miniBtn.Visible = false
    miniBtn.ClipsDescendants = true
    Instance.new("UICorner", miniBtn).CornerRadius = UDim.new(1, 0)

    -- Sin sombras: se conserva una referencia invisible para compatibilidad con el toggle.
    local miniShadow = Instance.new("Frame", gui)
    miniShadow.Name = "MinimizedButtonShadow"
    miniShadow.Size = UDim2.fromOffset(1, 1)
    miniShadow.Position = UDim2.new(0, 0, 0, 0)
    miniShadow.BackgroundTransparency = 1
    miniShadow.BorderSizePixel = 0
    miniShadow.Visible = false

    local minGrad = Instance.new("UIGradient", miniBtn)
    minGrad.Name = "MinGrad"
    minGrad.Rotation = 90
    minGrad.Color = ColorSequence.new(Color3.fromRGB(0, 0, 0), Color3.fromRGB(0, 0, 0))

    local minLogo = Instance.new("Frame", miniBtn)
    minLogo.Name = "MinLogo"
    minLogo.Size = UDim2.fromOffset(42, 42)
    minLogo.Position = UDim2.new(0.5, -21, 0.5, -21)
    minLogo.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    minLogo.BackgroundTransparency = 0
    minLogo.BorderSizePixel = 0
    minLogo.ZIndex = 22
    Instance.new("UICorner", minLogo).CornerRadius = UDim.new(1, 0)

    local minLogoText = Instance.new("TextLabel", minLogo)
    minLogoText.Size = UDim2.fromScale(1, 1)
    minLogoText.BackgroundTransparency = 1
    minLogoText.Text = "V"
    minLogoText.TextColor3 = Color3.fromRGB(0, 0, 0)
    minLogoText.Font = Enum.Font.GothamBlack
    minLogoText.TextSize = 18
    minLogoText.ZIndex = 23

    -- El destello queda DETRÁS del círculo blanco: solo se ve en el aro negro exterior.
    local lightSweep = Instance.new("Frame", miniBtn)
    lightSweep.Name = "LightSweep"
    lightSweep.AnchorPoint = Vector2.new(0.5, 0.5)
    lightSweep.Size = UDim2.new(0, 15, 1.6, 0)
    lightSweep.Position = UDim2.new(-0.35, 0, 0.5, 0)
    lightSweep.Rotation = 25
    lightSweep.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    lightSweep.BackgroundTransparency = 0.15
    lightSweep.BorderSizePixel = 0
    lightSweep.ZIndex = 21
    local lightGradient = Instance.new("UIGradient", lightSweep)
    lightGradient.Rotation = 0
    lightGradient.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(0.5, 0.12),
        NumberSequenceKeypoint.new(1, 1),
    })
    local lightTween = TS:Create(lightSweep, TweenInfo.new(3.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, false, 0.7), {
        Position = UDim2.new(1.35, 0, 0.5, 0)
    })
    lightTween:Play()

    local minTitle = Instance.new("TextLabel", miniBtn)
    minTitle.Name = "MinTitle"
    minTitle.Size = UDim2.new(1, -56, 0, 18)
    minTitle.Position = UDim2.new(0, 50, 0, 6)
    minTitle.BackgroundTransparency = 1
    minTitle.Text = "VLEXUS HUB"
    minTitle.Visible = false
    minTitle.TextColor3 = Color3.fromRGB(240, 240, 250)
    minTitle.Font = Enum.Font.GothamBlack
    minTitle.TextSize = 13
    minTitle.TextXAlignment = Enum.TextXAlignment.Left
    minTitle.ZIndex = 22

    local minSub = Instance.new("TextLabel", miniBtn)
    minSub.Name = "MinSub"
    minSub.Size = UDim2.new(1, -56, 0, 14)
    minSub.Position = UDim2.new(0, 50, 0, 25)
    minSub.BackgroundTransparency = 1
    minSub.Text = "CLICK TO OPEN"
    minSub.Visible = false
    minSub.TextColor3 = Color3.fromRGB(150, 150, 165)
    minSub.Font = Enum.Font.GothamMedium
    minSub.TextSize = 8
    minSub.TextXAlignment = Enum.TextXAlignment.Left
    minSub.ZIndex = 22

    miniBtn.MouseEnter:Connect(function() TS:Create(miniBtn, TweenInfo.new(0.06), {BackgroundColor3 = Color3.fromRGB(0, 0, 0)}):Play() end)
    miniBtn.MouseLeave:Connect(function() TS:Create(miniBtn, TweenInfo.new(0.06), {BackgroundColor3 = Color3.fromRGB(0, 0, 0)}):Play() end)

    local _mainAnimating = false
    local mainOriginalPos = main.Position
    _G.__LustMainOriginalPos = mainOriginalPos
    main:GetPropertyChangedSignal("Position"):Connect(function()
        if not _mainAnimating then
            mainOriginalPos = main.Position
            _G.__LustMainOriginalPos = mainOriginalPos
        end
    end)

    -- Menu principal movible (arrastrando la barra del titulo). Respeta "Lock UI".
    drag(main, function() return 52 * (mainUIScale and mainUIScale.Scale or 1) end)
    do
        local _clamping = false
        main:GetPropertyChangedSignal("Position"):Connect(function()
            if _mainAnimating or _clamping then return end
            local pos = main.Position
            if pos.X.Scale ~= 0 or pos.Y.Scale ~= 0 then return end
            local vp = gui.AbsoluteSize
            local s = (mainUIScale and mainUIScale.Scale or 1)
            local x = _clamp(pos.X.Offset, -(GUI_W * s - 90), vp.X - 90)
            local y = _clamp(pos.Y.Offset, 0, vp.Y - 50)
            if x ~= pos.X.Offset or y ~= pos.Y.Offset then
                _clamping = true
                main.Position = UDim2.new(0, x, 0, y)
                _clamping = false
            end
        end)
    end

    local animScale = Instance.new("UIScale", main)
    animScale.Scale = 1
    local _openTween, _closeTween = nil, nil

    showGui = function()
        if not main then return end
        if _openTween then _openTween:Cancel(); _openTween = nil end
        if _closeTween then _closeTween:Cancel(); _closeTween = nil end
        _mainAnimating = true
        main.Visible = true
        miniBtn.Visible = false
        miniShadow.Visible = false
        main.Position = UDim2.new(mainOriginalPos.X.Scale, mainOriginalPos.X.Offset - 40, mainOriginalPos.Y.Scale, mainOriginalPos.Y.Offset)
        animScale.Scale = 0.72
        local info = TweenInfo.new(0.20, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        _openTween = TS:Create(main, info, {Position = mainOriginalPos})
        TS:Create(animScale, info, {Scale = 1}):Play()
        _openTween:Play()
        _openTween.Completed:Connect(function() _openTween = nil; _mainAnimating = false end)
    end

    hideGui = function()
        if not main or not main.Visible then return end
        if _openTween then _openTween:Cancel(); _openTween = nil end
        if _closeTween then _closeTween:Cancel(); _closeTween = nil end
        _mainAnimating = true
        local targetPos = UDim2.new(mainOriginalPos.X.Scale, mainOriginalPos.X.Offset - 40, mainOriginalPos.Y.Scale, mainOriginalPos.Y.Offset)
        local info = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
        _closeTween = TS:Create(main, info, {Position = targetPos})
        TS:Create(animScale, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Scale = 0.72}):Play()
        _closeTween:Play()
        _closeTween.Completed:Connect(function()
            main.Visible = false
            miniBtn.Visible = true
            miniShadow.Visible = true
            _closeTween = nil
            _mainAnimating = false
        end)
    end

    closeBtn.MouseButton1Click:Connect(hideGui)
    miniBtn.MouseButton1Click:Connect(showGui)

    local tabBar = Instance.new("Frame", main)
    tabBar.Size = UDim2.new(1, -8, 0, 40)
    tabBar.Position = UDim2.new(0, 4, 0, 50)
    tabBar.BackgroundTransparency = 1
    tabBar.ZIndex = 10

    local tabLayout = Instance.new("UIListLayout", tabBar)
    tabLayout.FillDirection = Enum.FillDirection.Horizontal
    tabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    tabLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    tabLayout.Padding = UDim.new(0, 3)

    local tabContent = Instance.new("Frame", main)
    tabContent.Size = UDim2.new(1, 0, 1, -96)
    tabContent.Position = UDim2.new(0, 0, 0, 96)
    tabContent.BackgroundTransparency = 1
    tabContent.ClipsDescendants = true
    tabContent.ZIndex = 5

    local tabs = {"Movement", "Combat", "Visuals", "Settings"}
    tabButtons = {}
    local contentPages = {}

    local TAB_MUTED = Color3.fromRGB(122, 122, 130)
    local function setTabActive(tab, active)
        local ul = tab:FindFirstChild("Underline")
        if ul then ul.Visible = active and true or false end
        TS:Create(tab, TweenInfo.new(0.06, Enum.EasingStyle.Quad), { TextColor3 = active and Color3.fromRGB(255, 255, 255) or TAB_MUTED }):Play()
    end

    local tabDivider = Instance.new("Frame", main)
    tabDivider.Name = "TabDivider"
    tabDivider.Size = UDim2.new(1, -24, 0, 1)
    tabDivider.Position = UDim2.new(0, 12, 0, 91)
    tabDivider.BackgroundColor3 = Color3.fromRGB(30, 30, 34)
    tabDivider.BorderSizePixel = 0
    tabDivider.ZIndex = 10

    for i, name in ipairs(tabs) do
        local btn = Instance.new("TextButton", tabBar)
        btn.Size = UDim2.new(0.25, -3, 1, -6)
        btn.BackgroundTransparency = 1
        btn.BorderSizePixel = 0
        btn.Text = name
        btn.TextColor3 = TAB_MUTED
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 12
        btn.AutoButtonColor = false
        btn.ZIndex = 11

        local underline = Instance.new("Frame", btn)
        underline.Name = "Underline"
        underline.Size = UDim2.new(1, -24, 0, 2)
        underline.Position = UDim2.new(0.5, 0, 1, -2)
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
        page.ScrollBarImageColor3 = Color3.fromRGB(70, 70, 76)
        page.ScrollBarImageTransparency = 0.2
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
        padding.PaddingLeft = UDim.new(0, 10)
        padding.PaddingRight = UDim.new(0, 10)
        padding.PaddingTop = UDim.new(0, 8)
        padding.PaddingBottom = UDim.new(0, 20)

        contentPages[name] = page

        btn.MouseButton1Click:Connect(function()
            for _, pg2 in pairs(contentPages) do pg2.Visible = false end
            page.Visible = true
            for _, b in ipairs(tabButtons) do setTabActive(b, false) end
            setTabActive(btn, true)
        end)
        btn.MouseEnter:Connect(function()
            if underline.Visible then return end
            TS:Create(btn, TweenInfo.new(0.06), {TextColor3 = Color3.fromRGB(200, 200, 206)}):Play()
        end)
        btn.MouseLeave:Connect(function()
            if underline.Visible then return end
            TS:Create(btn, TweenInfo.new(0.06), {TextColor3 = TAB_MUTED}):Play()
        end)

        table.insert(tabButtons, btn)
    end

    if tabButtons[1] then setTabActive(tabButtons[1], true) end

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
        l.Size = UDim2.new(1, -8, 1, -6)
        l.Position = UDim2.new(0, 4, 0, 0)
        l.BackgroundTransparency = 1
        l.Text = txt:upper()
        l.TextColor3 = Color3.fromRGB(235, 235, 245)
        l.Font = Enum.Font.GothamBold
        l.TextSize = 10
        l.TextXAlignment = Enum.TextXAlignment.Left
        l.TextYAlignment = Enum.TextYAlignment.Bottom
        l.ZIndex = 8
        local line = Instance.new("Frame", f)
        line.Name = "SectLine"
        line.Size = UDim2.new(1, -8, 0, 1)
        line.Position = UDim2.new(0, 4, 1, -1)
        line.BackgroundColor3 = Color3.fromRGB(30, 30, 34)
        line.BorderSizePixel = 0
        line.ZIndex = 8
        return f
    end

    _G.__LustRowHover = setmetatable({}, {__mode = "k"})
    _G.__LustVisualGet = setmetatable({}, {__mode = "k"})
    local function mkRow(page, h)
        local f = Instance.new("Frame", page)
        f.Size = UDim2.new(1, -4, 0, h or 42)
        f.BackgroundColor3 = ROW_BG
        f.BackgroundTransparency = 0.7
        f.BorderSizePixel = 0
        f.LayoutOrder = getNextOrder(page)
        f.ZIndex = 7
        Instance.new("UICorner", f).CornerRadius = UDim.new(0, 11)
        local rowGrad = Instance.new("UIGradient", f)
        rowGrad.Name = "RowGrad"
        rowGrad.Rotation = 90
        rowGrad.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0.00, 0.00),
            NumberSequenceKeypoint.new(1.00, 0.30),
        })
        local rowStroke = Instance.new("UIStroke", f)
        rowStroke.Color = ROW_BORDER
        rowStroke.Thickness = 1
        rowStroke.Transparency = 0.55
        local function hoverIn()
            TS:Create(f, TweenInfo.new(0.06), {BackgroundColor3 = Color3.fromRGB(22,22,26)}):Play()
            TS:Create(rowStroke, TweenInfo.new(0.06), {Color = getThemeColor(), Transparency = 0.35}):Play()
        end
        local function hoverOut()
            TS:Create(f, TweenInfo.new(0.06), {BackgroundColor3 = ROW_BG}):Play()
            TS:Create(rowStroke, TweenInfo.new(0.06), {Color = ROW_BORDER, Transparency = 0.55}):Play()
        end
        f.MouseEnter:Connect(hoverIn)
        f.MouseLeave:Connect(hoverOut)
        _G.__LustRowHover[f] = { hoverIn, hoverOut }
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

    -- Toggle estilo Lust Hub: bolita con gradiente + gloss + "pop" con UIScale.
    local _TG = {}
    _TG.OFF_SEQ = ColorSequence.new({
        ColorSequenceKeypoint.new(0,   Color3.fromRGB(235, 232, 248)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(128, 124, 150)),
        ColorSequenceKeypoint.new(1,   Color3.fromRGB(48, 48, 58)),
    })
    _TG.OFF_COLOR = Color3.fromRGB(92, 92, 104)
    _TG.POP_INFO = TweenInfo.new(0.28, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    _TG.COLOR_INFO = TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

    local function mkPill(row, offset)
        local pill = Instance.new("Frame", row)
        pill.Name = "Track"
        pill.Size = UDim2.new(0, 22, 0, 22)
        pill.AnchorPoint = Vector2.new(1, 0.5)
        pill.Position = UDim2.new(1, -16, 0.5, 0)
        pill.BackgroundTransparency = 1
        pill.BorderSizePixel = 0
        pill.ZIndex = 8

        local back = Instance.new("Frame", pill)
        back.Name = "Back"
        back.AnchorPoint = Vector2.new(0.5, 0.5)
        back.Position = UDim2.new(0.5, 0, 0.5, 1)
        back.Size = UDim2.new(0, 17, 0, 17)
        back.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        back.BackgroundTransparency = 0.55
        back.BorderSizePixel = 0
        back.ZIndex = 8
        Instance.new("UICorner", back).CornerRadius = UDim.new(1, 0)

        local dot = Instance.new("Frame", pill)
        dot.Name = "Knob"
        dot.AnchorPoint = Vector2.new(0.5, 0.5)
        dot.Position = UDim2.new(0.5, 0, 0.5, 0)
        dot.Size = UDim2.new(0, 14, 0, 14)
        dot.BackgroundColor3 = _TG.OFF_COLOR
        dot.BorderSizePixel = 0
        dot.ClipsDescendants = true
        dot.ZIndex = 9
        Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)
        local grad = Instance.new("UIGradient", dot)
        grad.Name = "KnobGrad"
        grad.Color = _TG.OFF_SEQ
        grad.Rotation = 90
        local sc = Instance.new("UIScale", dot)
        sc.Name = "KnobScale"
        sc.Scale = 1
        local shine = Instance.new("Frame", dot)
        shine.Name = "Shine"
        shine.Size = UDim2.new(0.46, 0, 0.24, 0)
        shine.Position = UDim2.new(0.22, 0, 0.11, 0)
        shine.BackgroundColor3 = WHITE
        shine.BackgroundTransparency = 0.62
        shine.BorderSizePixel = 0
        shine.ZIndex = 10
        Instance.new("UICorner", shine).CornerRadius = UDim.new(1, 0)
        return pill, dot
    end

    local function animPill(pill, dot, on)
        local grad  = dot:FindFirstChild("KnobGrad")
        local shine = dot:FindFirstChild("Shine")
        local sc    = dot:FindFirstChild("KnobScale")
        local theme = getThemeColor()
        if grad then
            -- ColorSequence no se tweenea: se asigna directo (es instantaneo y barato).
            grad.Color = on and ColorSequence.new({
                ColorSequenceKeypoint.new(0,    Color3.fromRGB(255, 240, 255)),
                ColorSequenceKeypoint.new(0.46, theme),
                ColorSequenceKeypoint.new(1,    theme:Lerp(Color3.fromRGB(0, 0, 0), 0.35)),
            }) or _TG.OFF_SEQ
        end
        if shine then shine.BackgroundTransparency = on and 0.5 or 0.62 end
        if sc then
            sc.Scale = on and 1.08 or 0.92
            TS:Create(sc, _TG.POP_INFO, { Scale = 1 }):Play()
        end
        TS:Create(dot, _TG.COLOR_INFO, { BackgroundColor3 = on and theme or _TG.OFF_COLOR }):Play()
    end

    -- Guardado con debounce: antes cada click escribia el archivo entero
    -- (encode + leer backup + escribir 2 veces + releer) y eso causaba el lag.
    _TG.token = 0
    function _TG.save()
        _TG.token = _TG.token + 1
        local my = _TG.token
        task.delay(0.8, function()
            if my ~= _TG.token then return end
            pcall(saveAllSettings)
        end)
    end

    local function mkToggle(page, txt, cb)
        local row = mkRow(page, 42)
        mkLabel(row, txt)
        local pill, dot = mkPill(row, 62)
        local on = false
        local function sv(s) on = (s == true); animPill(pill, dot, on) end
        _G.__LustVisualGet[sv] = function() return on end
        local clk = Instance.new("TextButton", row)
        clk.Name = "HitArea"
        clk.Size = UDim2.new(1,0,1,0)
        clk.BackgroundTransparency = 1
        clk.Text = ""
        clk.AutoButtonColor = false
        clk.ZIndex = 12
        local hv = _G.__LustRowHover[row]
        if hv then
            clk.MouseEnter:Connect(hv[1])
            clk.MouseLeave:Connect(hv[2])
        end
        clk.Activated:Connect(function()
            _G.__LustLastTap = _tick()
            on = not on
            sv(on)                 -- 1) primero la animacion (respuesta inmediata)
            task.defer(function()  -- 2) el callback pesado despues, sin bloquear el frame
                pcall(cb, on)
            end)
            _TG.save()         -- 3) guardado diferido y agrupado
        end)
        return sv, row
    end

    local function mkPillSelector(parent, getValue, options, onChange, customWidth)
        local w = customWidth or 98
        local pill = Instance.new("Frame", parent)
        pill.Name = "PillSelector"
        pill.Size = UDim2.new(0, w, 0, 24)
        pill.Position = UDim2.new(1, -(w + 6), 0.5, -12)
        pill.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
        pill.BackgroundTransparency = 0.7
        pill.BorderSizePixel = 0
        pill.ZIndex = 30
        Instance.new("UICorner", pill).CornerRadius = UDim.new(1, 0)
        local pillStroke = Instance.new("UIStroke", pill)
        pillStroke.Color = Color3.fromRGB(50, 50, 50)
        pillStroke.Thickness = 1
        pillStroke.Transparency = 0.15

        local leftBtn = Instance.new("TextButton", pill)
        leftBtn.Name = "Prev"
        leftBtn.Size = UDim2.new(0, 24, 1, 0)
        leftBtn.Position = UDim2.new(0, 1, 0, 0)
        leftBtn.BackgroundTransparency = 1
        leftBtn.BorderSizePixel = 0
        leftBtn.Text = "<"
        leftBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        leftBtn.Font = Enum.Font.GothamBlack
        leftBtn.TextSize = 12
        leftBtn.AutoButtonColor = false
        leftBtn.ZIndex = 31

        local valueLbl = Instance.new("TextLabel", pill)
        valueLbl.Name = "Value"
        valueLbl.Size = UDim2.new(0, w - 50, 1, 0)
        valueLbl.Position = UDim2.new(0, 25, 0, 0)
        valueLbl.BackgroundTransparency = 1
        valueLbl.Text = tostring(getValue())
        valueLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
        valueLbl.Font = Enum.Font.GothamBlack
        valueLbl.TextSize = 12
        valueLbl.TextXAlignment = Enum.TextXAlignment.Center
        valueLbl.TextYAlignment = Enum.TextYAlignment.Center
        valueLbl.TextTruncate = Enum.TextTruncate.AtEnd
        valueLbl.ZIndex = 31

        local rightBtn = Instance.new("TextButton", pill)
        rightBtn.Name = "Next"
        rightBtn.Size = UDim2.new(0, 24, 1, 0)
        rightBtn.Position = UDim2.new(1, -25, 0, 0)
        rightBtn.BackgroundTransparency = 1
        rightBtn.BorderSizePixel = 0
        rightBtn.Text = ">"
        rightBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        rightBtn.Font = Enum.Font.GothamBlack
        rightBtn.TextSize = 12
        rightBtn.AutoButtonColor = false
        rightBtn.ZIndex = 31

        local idx = 1
        for i, opt in ipairs(options) do
            if opt == getValue() then idx = i; break end
        end

        local function apply(newIdx, skipSave)
            if newIdx < 1 then newIdx = #options end
            if newIdx > #options then newIdx = 1 end
            idx = newIdx
            onChange(options[idx])
            valueLbl.Text = tostring(options[idx])
            if not skipSave then
                task.defer(function() pcall(saveAllSettings) end)
            end
        end

        leftBtn.MouseButton1Click:Connect(function() apply(idx - 1) end)
        rightBtn.MouseButton1Click:Connect(function() apply(idx + 1) end)
        valueLbl.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1
               or input.UserInputType == Enum.UserInputType.Touch then
                apply(idx + 1)
            end
        end)

        return {
            pill = pill,
            valueLbl = valueLbl,
            setIndex = function(newIdx, skipSave) apply(newIdx, skipSave) end,
            setByValue = function(val, skipSave)
                for i, opt in ipairs(options) do
                    if opt == val then apply(i, skipSave); return end
                end
            end,
        }
    end

    -- Toggle con flechita (▼) que abre un mini menu de opciones.
    -- options = { {key, "Etiqueta"}, ... } | getKey() -> key actual | onSelect(key)
    local function mkToggleSelector(page, txt, cb, options, getKey, onSelect)
        local sv, row = mkToggle(page, txt, cb)
        local n = #options

        local arrow = Instance.new("TextButton", row)
        arrow.Name = "SelectorArrow"
        arrow.Size = UDim2.new(0, 32, 0, 26)
        arrow.AnchorPoint = Vector2.new(1, 0.5)
        arrow.Position = UDim2.new(1, -50, 0.5, 0)
        arrow.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
        arrow.BackgroundTransparency = 0.1
        arrow.BorderSizePixel = 0
        arrow.Text = "▼"
        arrow.Font = Enum.Font.GothamBlack
        arrow.TextSize = 11
        arrow.AutoButtonColor = false
        arrow.ZIndex = 14
        Instance.new("UICorner", arrow).CornerRadius = UDim.new(0, 8)
        local arrowStroke = Instance.new("UIStroke", arrow)
        arrowStroke.Thickness = 1.2
        arrowStroke.Transparency = 0.25

        local dd = Instance.new("Frame", page)
        dd.Name = "SelectorOptions"
        dd.Size = UDim2.new(1, -4, 0, 0)
        dd.BackgroundColor3 = Color3.fromRGB(12, 12, 17)
        dd.BackgroundTransparency = 0.1
        dd.BorderSizePixel = 0
        dd.LayoutOrder = getNextOrder(page)
        dd.Visible = false
        dd.ClipsDescendants = true
        dd.ZIndex = 7
        Instance.new("UICorner", dd).CornerRadius = UDim.new(0, 11)
        local ddStroke = Instance.new("UIStroke", dd)
        ddStroke.Thickness = 1.2
        ddStroke.Transparency = 0.35

        local slider = Instance.new("Frame", dd)
        slider.Size = UDim2.new(1 / n, -6, 1, -8)
        slider.BackgroundTransparency = 0.05
        slider.BorderSizePixel = 0
        slider.ZIndex = 8
        Instance.new("UICorner", slider).CornerRadius = UDim.new(0, 9)
        local sliderGrad = Instance.new("UIGradient", slider)
        sliderGrad.Rotation = 90
        sliderGrad.Color = ColorSequence.new(Color3.fromRGB(255, 255, 255), Color3.fromRGB(205, 205, 215))
        local sliderStroke = Instance.new("UIStroke", slider)
        sliderStroke.Thickness = 1
        sliderStroke.Transparency = 0.2

        local labels = {}
        local function selIndex()
            local cur = getKey()
            for i, o in ipairs(options) do
                if o[1] == cur then return i end
            end
            return 1
        end

        local function paint(animate)
            local th = getThemeColor()
            local lum = 0.299 * th.R + 0.587 * th.G + 0.114 * th.B
            local selTxt = (lum > 0.55) and Color3.fromRGB(14, 14, 20) or Color3.fromRGB(255, 255, 255)
            local idx = selIndex()
            local pos = UDim2.new((idx - 1) / n, 3, 0, 4)
            slider.BackgroundColor3 = th
            sliderStroke.Color = th
            ddStroke.Color = th
            arrowStroke.Color = th
            arrow.TextColor3 = th
            if animate then
                TS:Create(slider, TweenInfo.new(0.18, Enum.EasingStyle.Quad), { Position = pos }):Play()
            else
                slider.Position = pos
            end
            for i, l in ipairs(labels) do
                if i == idx then
                    l.TextColor3 = selTxt
                    l.TextTransparency = 0
                    l.TextStrokeTransparency = 1
                else
                    l.TextColor3 = Color3.fromRGB(215, 215, 230)
                    l.TextTransparency = 0.25
                    l.TextStrokeTransparency = 0.6
                end
            end
        end

        for i, o in ipairs(options) do
            local lbl = Instance.new("TextLabel", dd)
            lbl.Size = UDim2.new(1 / n, 0, 1, 0)
            lbl.Position = UDim2.new((i - 1) / n, 0, 0, 0)
            lbl.BackgroundTransparency = 1
            lbl.Text = string.upper(tostring(o[2]))
            lbl.Font = Enum.Font.GothamBlack
            lbl.TextSize = 12
            lbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
            lbl.ZIndex = 9
            labels[i] = lbl
            local b = Instance.new("TextButton", dd)
            b.Size = UDim2.new(1 / n, 0, 1, 0)
            b.Position = UDim2.new((i - 1) / n, 0, 0, 0)
            b.BackgroundTransparency = 1
            b.Text = ""
            b.AutoButtonColor = false
            b.ZIndex = 11
            b.Activated:Connect(function()
                pcall(onSelect, o[1])
                paint(true)
                task.defer(function() pcall(saveAllSettings) end)
            end)
        end
        paint(false)

        local open, tw = false, nil
        arrow.Activated:Connect(function()
            open = not open
            if tw then tw:Cancel() end
            if open then
                paint(false)
                dd.Visible = true
                arrow.Text = "▲"
                arrowStroke.Transparency = 0
                tw = TS:Create(dd, TweenInfo.new(0.24, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), { Size = UDim2.new(1, -4, 0, 40) })
                tw:Play()
            else
                arrow.Text = "▼"
                arrowStroke.Transparency = 0.25
                tw = TS:Create(dd, TweenInfo.new(0.2, Enum.EasingStyle.Quint, Enum.EasingDirection.In), { Size = UDim2.new(1, -4, 0, 0) })
                tw.Completed:Connect(function() if not open then dd.Visible = false end end)
                tw:Play()
            end
        end)

        return sv, function() paint(false) end
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
        tb.Focused:Connect(function() TS:Create(bs, TweenInfo.new(0.06), {Color = getThemeColor(), Transparency = 0}):Play() end)
        tb.FocusLost:Connect(function()
            TS:Create(bs, TweenInfo.new(0.06), {Color = ROW_BORDER, Transparency = 0.25}):Play()
            if cb then
                local n = tonumber(tb.Text)
                if n then cb(n) else tb.Text = tostring(default) end
                task.defer(function() saveAllSettings() end)
            end
        end)
        return tb
    end

    local function mkStepper(parent, default, minV, maxV, step, cb)
        local cur = _clamp(tonumber(default) or minV, minV, maxV)
        local function mkArrow(txt, xOff)
            local b = Instance.new("TextButton", parent)
            b.Size = UDim2.new(0, 28, 0, 25)
            b.Position = UDim2.new(1, xOff, 0.5, -12)
            b.BackgroundColor3 = INP
            b.BackgroundTransparency = 0.7
            b.BorderSizePixel = 0
            b.Text = txt
            b.TextColor3 = WHITE
            b.Font = Enum.Font.GothamBlack
            b.TextSize = 13
            b.AutoButtonColor = false
            b.ZIndex = 9
            Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
            return b
        end
        local minus = mkArrow("<", -126)
        local plus = mkArrow(">", -32)
        local tb = Instance.new("TextBox", parent)
        tb.Name = "StepperValue"
        tb.Size = UDim2.new(0, 58, 0, 25)
        tb.Position = UDim2.new(1, -94, 0.5, -12)
        tb.BackgroundColor3 = INP
        tb.BackgroundTransparency = 0.7
        tb.BorderSizePixel = 0
        tb.Text = tostring(cur)
        tb.TextColor3 = WHITE
        tb.Font = Enum.Font.GothamBlack
        tb.TextSize = 12
        tb.ClearTextOnFocus = false
        tb.ZIndex = 9
        Instance.new("UICorner", tb).CornerRadius = UDim.new(0, 6)
        local bs = Instance.new("UIStroke", tb)
        bs.Color = ROW_BORDER
        bs.Thickness = 1
        bs.Transparency = 0.25
        local function commit(v)
            cur = _clamp(_floor((tonumber(v) or cur) + 0.5), minV, maxV)
            tb.Text = tostring(cur)
            if cb then pcall(cb, cur) end
            task.defer(function() pcall(saveAllSettings) end)
        end
        minus.Activated:Connect(function() commit((tonumber(tb.Text) or cur) - step) end)
        plus.Activated:Connect(function() commit((tonumber(tb.Text) or cur) + step) end)
        tb.FocusLost:Connect(function() commit(tb.Text) end)
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
            lc = _LustOn(UIS.InputBegan, function(inp)
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

    local movementPage = contentPages["Movement"]
    mkSect(movementPage, "Speeds")
    do local row = mkRow(movementPage, 42); mkLabel(row, "Normal Speed"); normalBox = mkBox(row, NS, 50, 56, function(v) if v > 0 and v <= 500 then NS = v; if _G.__LustApplySpeedNow then pcall(_G.__LustApplySpeedNow) end end end) end
    do local row = mkRow(movementPage, 42); mkLabel(row, "Carry Speed"); carryBox = mkBox(row, CS, 50, 56, function(v) if v > 0 and v <= 500 then CS = v; if _G.__LustApplySpeedNow then pcall(_G.__LustApplySpeedNow) end end end) end
    do local row = mkRow(movementPage, 42); mkLabel(row, "Lagger Normal Speed"); laggerBox = mkBox(row, LAGGER_SPEED, 50, 56, function(v) if v > 0 and v <= 500 then LAGGER_SPEED = v; if _G.__LustApplySpeedNow then pcall(_G.__LustApplySpeedNow) end end end) end
    do local row = mkRow(movementPage, 42); mkLabel(row, "Lagger Carry Speed"); lagger2Box = mkBox(row, LAGGER_CARRY_SPEED, 50, 56, function(v) if v > 0 and v <= 500 then LAGGER_CARRY_SPEED = v; if _G.__LustApplySpeedNow then pcall(_G.__LustApplySpeedNow) end end end) end
    do
        local row = mkRow(movementPage, 42)
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
    mkSect(movementPage, "Auto Carry")
    do
        local sv, refresh = mkToggleSelector(movementPage, "Auto Carry",
            function(on)
                autoCarryEnabled = on
                if not on and _G.__LustAutoCarryRestore then pcall(_G.__LustAutoCarryRestore) end
            end,
            { { "Normal", "Normal" }, { "Lagger", "Lagger" } },
            function() return autoCarryMode end,
            function(key)
                autoCarryMode = key
                if _G.__LustAutoCarryReapply then pcall(_G.__LustAutoCarryReapply) end
            end)
        sv(autoCarryEnabled == true)
        _G.__LustAutoCarrySetVisual = sv
        _G.__LustAutoCarryRefresh = function() sv(autoCarryEnabled == true); refresh() end
    end
    mkSect(movementPage, "Auto Play")
    do
        local apSv, apRefresh = mkToggleSelector(movementPage, "Auto Play",
            function(on)
                if on then startAutoPlay() else stopAutoPlay() end
            end,
            { { "full", "Full" }, { "semi", "Semi" } },
            function() return (Config.autoPlayMode == "semi" or Config.autoPlayMode == "half") and "semi" or "full" end,
            function(key)
                Config.autoPlayMode = key
                if Config.autoPlayRestart then pcall(Config.autoPlayRestart) end
            end)
        autoPlaySetVisual = apSv
        _G.__LustAutoPlayRefresh = function() apRefresh() end
    end
    mkSect(movementPage, "Float")
    _G.__LustFloatSetVisual = mkToggle(movementPage, "Float", function(on)
        if on then
            _G.__LustFloat.enable()
        else
            _G.__LustFloat.disable()
        end
        if mobSetFloat then mobSetFloat(on) end
    end)
    if _G.__LustFloat.running and _G.__LustFloatSetVisual then
        task.defer(function() _G.__LustFloatSetVisual(true) end)
    end

    mkSect(movementPage, "TP Down")
    do
        local tpSv = mkToggle(movementPage, "Auto TP Down", function(on)
            tpDownAutoEnabled = on
            if on then startTpDownAuto() else stopTpDownAuto() end
            if mobSetTpDown then mobSetTpDown(on) end
        end)
        tpSv(tpDownAutoEnabled == true)
        _G.__LustTpDownSetVisual = tpSv
    end
    do
        local row = mkRow(movementPage, 42)
        mkLabel(row, "Auto TP Height")
        mkBox(row, tpDownAutoHeight, 50, 56, function(v)
            if v and v >= 5 and v <= 500 then tpDownAutoHeight = _floor(v) end
        end)
    end
    mkSect(movementPage, "Drop Brainrot")
    dropBrainrotSetVisual = mkToggle(movementPage, "Drop Brainrot", function(on)
        if on then
            executeDropWithToggle(function(v)
                dropBrainrotSetVisual(v)
                if mobSetDropBR then mobSetDropBR(v) end
            end)
        end
    end)
    setDropVisual = dropBrainrotSetVisual
    do
        local row = mkRow(movementPage, 42)
        mkLabel(row, "Drop Mode")
        _dropModeSel = mkPillSelector(row,
            function() return dropMode == 1 and "Fling" or "Jump Drop" end,
            { "Fling", "Jump Drop" },
            function(val)
                if _dropSyncing then return end
                if dropActive then stopDropBrainrot() end
                dropMode = (val == "Fling") and 1 or 2
            end,
            130
        )
        dropModeBtnRef = _dropModeSel.valueLbl
    end

    mkSect(movementPage, "Auto Steal")
    setInstaGrab = mkToggle(movementPage, "Auto Steal", function(on)
        CONFIG.AUTO_STEAL_ENABLED = on
        if on then
            pcall(startAutoSteal)
        else
            stopAutoSteal()
        end
        updateProgressBarVisibility()
    end)
    do
        local row = mkRow(movementPage, 42)
        mkLabel(row, "Steal Radius")
        radInput = mkBox(row, CONFIG.STEAL_RANGE, 50, 56, function(v)
            if v and v >= 5 and v <= 300 then
                CONFIG.STEAL_RANGE = _floor(v+0.5)
                LustSteal.StealRadius = CONFIG.STEAL_RANGE
                radInput.Text = tostring(CONFIG.STEAL_RANGE)
                saveAllSettings()
            end
        end)
    end

    do
        local row = mkRow(movementPage, 42)
        mkLabel(row, "Pause Mode")

        local pauseLabels = {}
        for i, v in ipairs(NormalPauseOptions) do pauseLabels[i] = v .. "%" end

        local sel
        sel = mkPillSelector(row,
            function() return LustSteal.NormalStealPausePercent .. "%" end,
            pauseLabels,
            function(val)
                local num = tonumber((val:gsub("%%", "")))
                if num then
                    LustSteal.NormalStealPausePercent = num
                    if _G.__LustApplySpeedNow then pcall(_G.__LustApplySpeedNow) end
                end
            end,
            98
        )

        _G.__LustSetNormalPauseSelector = function(val, skipSave)
            local num = tonumber(val) or LustSteal.NormalStealPausePercent
            local best, bestDiff = NormalPauseOptions[1], math.huge
            for _, opt in ipairs(NormalPauseOptions) do
                local d = math.abs(opt - num)
                if d < bestDiff then bestDiff = d; best = opt end
            end
            LustSteal.NormalStealPausePercent = best
            sel.setByValue(best .. "%", skipSave)
        end
    end


    local combatPage = contentPages["Combat"]
    mkSect(combatPage, "Aimbot")
    autoBatSetVisual = mkToggle(combatPage, "Auto Bat", function(on)
        if on then enableAutoBat() else disableAutoBat() end
    end)
    do local row = mkRow(combatPage, 42); mkLabel(row, "Bat Aimbot Speed"); batSpeedBox = mkBox(row, BAT_AIMBOT_SPEED, 50, 56, function(v) if v > 0 and v <= 200 then BAT_AIMBOT_SPEED = v end end) end
    _G.__LustSwingSetVisual = mkToggle(combatPage, "Auto Swing", function(on) autoSwingEnabled = on end)
    _G.__LustSwingSetVisual(autoSwingEnabled ~= false)
    mirrorTPSetVisual = mkToggle(combatPage, "Mirror TP", function(on)
        if _G.LustSetMirrorTPDown then _G.LustSetMirrorTPDown(on) end
    end)
    if mirrorTPSetVisual then mirrorTPSetVisual(_G.LustMirrorTPDownEnabled == true) end
    mkSect(combatPage, "Targeting")
    bodyLockSetVisual = mkToggle(combatPage, "Lock Enemy", function(on)
        bodyLockEnabled = on
        if on then if _blSuppressCount == 0 then startBodyLock() end else stopBodyLock() end
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
        else stopMedusaCounter() end
        if setMedusaVisual then setMedusaVisual(on) end
    end)
    mkSect(combatPage, "Defense")
    setAntiDieVisual = mkToggle(combatPage, "Anti Die", function(on)
        _antiDieUserPref = on
        antiDieEnabled = on
        if on then AntiDieModule.start() else AntiDieModule.stop() end
        saveAllSettings()
    end)
    if setAntiDieVisual then setAntiDieVisual(antiDieEnabled) end
    do
        local sv, refresh = mkToggleSelector(combatPage, "Anti Ragdoll",
            function(on)
                if on then
                    setAntiRagdollMode((antiRagdollMode ~= "off") and antiRagdollMode or (_antiRagLastOn or "v2"))
                else
                    setAntiRagdollMode("off")
                end
            end,
            { { "v1", ANTIRAG_NAMES.v1 }, { "v2", ANTIRAG_NAMES.v2 } },
            function() return _antiRagLastOn or "v2" end,
            function(mode)
                _antiRagLastOn = mode
                if antiRagdollMode ~= "off" and antiRagdollMode ~= mode then
                    setAntiRagdollMode(mode)
                end
            end)
        setAntiRagVisual = sv
        _antiRagSel = { setByValue = function() refresh() end }
    end
    antiRagdollSyncUI()
    setUnwalkVisual = mkToggle(combatPage, "Unwalk", function(on)
        unwalkEnabled = on
        if on then startUnwalk() else stopUnwalk() end
    end)

    local visualsPage = contentPages["Visuals"]
    mkSect(visualsPage, "Interface")
    setLockUIVisual = mkToggle(visualsPage, "Lock UI", function(on) toggleLockUI(on) end)
    local hideSv, hideRow = mkToggle(visualsPage, "Hide Button", function(on) toggleHideButtons(on) end)
    setHideButtonsVisual = hideSv
    if setHideButtonsVisual then setHideButtonsVisual(hideButtonsEnabled) end
    do
        -- Activo = ese boton se oculta cuando Hide Button esta encendido. Apagado = se queda visible.
        local ITEMS = {
            { "DropBR", "Drop BR" }, { "AutoPlay", "Auto Play" }, { "AutoBat", "Bat Aimbot" },
            { "TpDown", "TP Down" }, { "Carry", "Carry Speed" }, { "Lagger1", "Lagger Normal" },
            { "Lagger2", "Lagger Carry" }, { "Float", "Float" }, { "InstaReset", "Insta Reset" },
        }
        local ROW_H, GAP, PAD = 34, 4, 6
        local totalH = #ITEMS * ROW_H + (#ITEMS - 1) * GAP + PAD * 2

        local arrow = Instance.new("TextButton", hideRow)
        arrow.Name = "SelectorArrow"
        arrow.Size = UDim2.new(0, 32, 0, 26)
        arrow.AnchorPoint = Vector2.new(1, 0.5)
        arrow.Position = UDim2.new(1, -50, 0.5, 0)
        arrow.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
        arrow.BackgroundTransparency = 0.1
        arrow.BorderSizePixel = 0
        arrow.Text = "▼"
        arrow.Font = Enum.Font.GothamBlack
        arrow.TextSize = 11
        arrow.AutoButtonColor = false
        arrow.ZIndex = 14
        Instance.new("UICorner", arrow).CornerRadius = UDim.new(0, 8)
        local arrowStroke = Instance.new("UIStroke", arrow)
        arrowStroke.Thickness = 1.2
        arrowStroke.Transparency = 0.25

        local dd = Instance.new("Frame", visualsPage)
        dd.Name = "HideButtonsList"
        dd.Size = UDim2.new(1, -4, 0, 0)
        dd.BackgroundColor3 = Color3.fromRGB(12, 12, 17)
        dd.BackgroundTransparency = 0.1
        dd.BorderSizePixel = 0
        dd.LayoutOrder = getNextOrder(visualsPage)
        dd.Visible = false
        dd.ClipsDescendants = true
        dd.ZIndex = 7
        Instance.new("UICorner", dd).CornerRadius = UDim.new(0, 11)
        local ddStroke = Instance.new("UIStroke", dd)
        ddStroke.Thickness = 1.2
        ddStroke.Transparency = 0.35
        local ddList = Instance.new("UIListLayout", dd)
        ddList.Padding = UDim.new(0, GAP)
        ddList.SortOrder = Enum.SortOrder.LayoutOrder
        local ddPad = Instance.new("UIPadding", dd)
        ddPad.PaddingTop = UDim.new(0, PAD); ddPad.PaddingBottom = UDim.new(0, PAD)
        ddPad.PaddingLeft = UDim.new(0, 8);  ddPad.PaddingRight = UDim.new(0, 8)

        local pills = {}
        for i, it in ipairs(ITEMS) do
            local key, text = it[1], it[2]
            local r = Instance.new("Frame", dd)
            r.Size = UDim2.new(1, 0, 0, ROW_H)
            r.LayoutOrder = i
            r.BackgroundColor3 = ROW_BG
            r.BackgroundTransparency = 0.35
            r.BorderSizePixel = 0
            r.ZIndex = 8
            Instance.new("UICorner", r).CornerRadius = UDim.new(0, 9)
            local rs = Instance.new("UIStroke", r)
            rs.Color = ROW_BORDER; rs.Thickness = 1; rs.Transparency = 0.6
            local lbl = Instance.new("TextLabel", r)
            lbl.Size = UDim2.new(0.65, 0, 1, 0)
            lbl.Position = UDim2.new(0, 12, 0, 0)
            lbl.BackgroundTransparency = 1
            lbl.Text = text
            lbl.TextColor3 = Color3.fromRGB(240, 240, 250)
            lbl.Font = Enum.Font.GothamBold
            lbl.TextSize = 12
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.ZIndex = 9
            local pill, dot = mkPill(r, 62)
            animPill(pill, dot, hideButtonFlags[key] ~= false)
            pills[key] = { pill = pill, dot = dot }
            local hit = Instance.new("TextButton", r)
            hit.Size = UDim2.new(1, 0, 1, 0)
            hit.BackgroundTransparency = 1
            hit.Text = ""
            hit.AutoButtonColor = false
            hit.ZIndex = 12
            hit.Activated:Connect(function()
                local nowOn = not (hideButtonFlags[key] ~= false)
                if nowOn then hideButtonFlags[key] = nil else hideButtonFlags[key] = false end
                animPill(pill, dot, nowOn)
                applyHideButtons()
                _TG.save()
            end)
        end

        _G.__LustHideFlagsRefresh = function()
            for key, pd in pairs(pills) do
                animPill(pd.pill, pd.dot, hideButtonFlags[key] ~= false)
            end
            applyHideButtons()
        end

        local open, tw = false, nil
        arrow.TextColor3 = getThemeColor()
        arrowStroke.Color = getThemeColor()
        ddStroke.Color = getThemeColor()
        arrow.Activated:Connect(function()
            open = not open
            if tw then tw:Cancel() end
            local th = getThemeColor()
            arrow.TextColor3 = th; arrowStroke.Color = th; ddStroke.Color = th
            if open then
                dd.Visible = true
                arrow.Text = "▲"
                arrowStroke.Transparency = 0
                tw = TS:Create(dd, TweenInfo.new(0.26, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), { Size = UDim2.new(1, -4, 0, totalH) })
                tw:Play()
            else
                arrow.Text = "▼"
                arrowStroke.Transparency = 0.25
                tw = TS:Create(dd, TweenInfo.new(0.2, Enum.EasingStyle.Quint, Enum.EasingDirection.In), { Size = UDim2.new(1, -4, 0, 0) })
                tw.Completed:Connect(function() if not open then dd.Visible = false end end)
                tw:Play()
            end
        end)
    end
    do
        local row = mkRow(visualsPage, 42)
        mkLabel(row, "UI Scale")
        uiScaleBox = mkStepper(row, uiScaleValue, 50, 150, 5, function(v)
            local n = _clamp(_floor(v+0.5), 50, 150)
            uiScaleValue = n
            if mainUIScale then mainUIScale.Scale = n/100 end
            if stealBarScaleObj then stealBarScaleObj.Scale = n/100 end
        end)
    end
    do
        local row = mkRow(visualsPage, 42)
        mkLabel(row, "Button Scale")
        buttonScaleBox = mkStepper(row, _floor(floatingButtonScale * 100 + 0.5), 40, 250, 5, function(v)
            local val = _clamp(v, 40, 250)
            floatingButtonScale = val / 100
            applyFloatingButtonScale()
        end)
    end
    mkSect(visualsPage, "Character")

    do
        local row = mkRow(visualsPage, 42)
        mkLabel(row, "Anim Pack")

        local labels = {}
        for i, e in ipairs(ANIM_PACK_ORDER) do labels[i] = e[2] end

        local sel
        sel = mkPillSelector(row,
            function() return currentAnimPack end,
            labels,
            function(val)
                if val == "Off" then stopAnimPack() else startAnimPack(val) end
            end,
            130
        )

        animSelectorLabel = sel.valueLbl
    end

    do
        local row = mkRow(visualsPage, 42)
        mkLabel(row, "Outfit")

        local labels = {}
        for i, o in ipairs(OUTFITS) do labels[i] = o.label end

        local sel
        sel = mkPillSelector(row,
            function() return OUTFITS[currentOutfitIndex].label end,
            labels,
            function(val)
                for i, o in ipairs(OUTFITS) do
                    if o.label == val then
                        currentOutfitIndex = i
                        pcall(function() applyOutfitByIndex(currentOutfitIndex) end)
                        break
                    end
                end
            end,
            130
        )

        outfitSelectorLabel = sel.valueLbl
    end

    mkSect(visualsPage, "World")
    do
        local row = mkRow(visualsPage, 42)
        mkLabel(row, "Sky Theme")

        local sel
        sel = mkPillSelector(row,
            function() return skyTheme end,
            SKY_PRESETS_LIST,
            function(val)
                skyTheme = val
                pcall(applyCustomSky, val)
            end,
            130
        )

        skySelectorLabel = sel.valueLbl
    end

    setSaturationVisual = mkToggle(visualsPage, "Saturation", function(on)
        applySaturation(on)
    end)
    if setSaturationVisual then setSaturationVisual(saturationEnabled) end

    _G.__LustXRaySetVisual = mkToggle(visualsPage, "Base X-Ray", function(on)
        if _G.LustSetBaseXRay then _G.LustSetBaseXRay(on) else _G.LustBaseXRayEnabled = (on == true) end
    end)
    _G.__LustXRaySetVisual(_G.LustBaseXRayEnabled == true)

    mkSect(visualsPage, "Performance")
    do
        local function applyStretch(s)
            s = (s == true)
            if s then enableStretch() else disableStretch() end
            stretchEnabled = s
        end
        local stretchSv = mkToggle(visualsPage, "Stretch Rez", applyStretch)
        _G.__LustStretchSetVisual = stretchSv
        _G.stretchToggleSetter = function(s)
            stretchSv(s == true)
            applyStretch(s)
        end
    end
    setAntiLagVisual = mkToggle(visualsPage, "Anti Lag", function(on)
        if on then enableAntiLag() else disableAntiLag() end
    end)

    mkSect(visualsPage, "ESP")
    setESPVIsual = mkToggle(visualsPage, "Player ESP", function(on) toggleESP(on) end)
    setESPLineVisual = mkToggle(visualsPage, "ESP Line", function(on)
        if on then startESPLine() else stopESPLine() end
    end)


    local settingsPage = contentPages["Settings"]
    mkSect(settingsPage, "Management")
    do
        local row = mkRow(settingsPage, 44)
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
            TS:Create(resetPosBtn, TweenInfo.new(0.05), {BackgroundColor3 = getThemeColor()}):Play()
            TS:Create(resetPosBtn, TweenInfo.new(0.05), {TextColor3 = Color3.fromRGB(255,255,255)}):Play()
        end)
        resetPosBtn.MouseLeave:Connect(function()
            TS:Create(resetPosBtn, TweenInfo.new(0.05), {BackgroundColor3 = Color3.fromRGB(245, 245, 250)}):Play()
            TS:Create(resetPosBtn, TweenInfo.new(0.05), {TextColor3 = Color3.fromRGB(20, 20, 25)}):Play()
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
        local row = mkRow(settingsPage, 44)
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
            TS:Create(delBtn, TweenInfo.new(0.05), {BackgroundColor3 = Color3.fromRGB(200, 50, 70)}):Play()
            TS:Create(delBtn, TweenInfo.new(0.05), {TextColor3 = Color3.fromRGB(255,255,255)}):Play()
        end)
        delBtn.MouseLeave:Connect(function()
            TS:Create(delBtn, TweenInfo.new(0.05), {BackgroundColor3 = Color3.fromRGB(245, 245, 250)}):Play()
            TS:Create(delBtn, TweenInfo.new(0.05), {TextColor3 = Color3.fromRGB(170, 30, 50)}):Play()
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
    mkSect(settingsPage, "Keybinds")
    do
        local resetRow = mkRow(settingsPage, 40)
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
        end)
    end
    mkSect(settingsPage, "Movement")
    addKeybindRow(settingsPage, "Carry Mode", KB.CarryToggle)
    addKeybindRow(settingsPage, "Lagger Mode", KB.LaggerMode)
    addKeybindRow(settingsPage, "Auto Play", KB.AutoPlay)
    addKeybindRow(settingsPage, "Float", KB.Float)
    addKeybindRow(settingsPage, "TP Down", KB.TPFloor)
    mkSect(settingsPage, "Combat")
    addKeybindRow(settingsPage, "Auto Bat", KB.AutoBat)
    mkSect(settingsPage, "Utility")
    addKeybindRow(settingsPage, "Drop Brainrot", KB.DropBrainrot)
    addKeybindRow(settingsPage, "Insta Reset", KB.InstaReset)
    local spacer = Instance.new("Frame", settingsPage)
    spacer.Size = UDim2.new(1, 0, 0, 16)
    spacer.BackgroundTransparency = 1
    spacer.LayoutOrder = getNextOrder(settingsPage)
    spacer.ZIndex = 7

    pbFrame = Instance.new("Frame", gui)
    pbFrame.Name = "LustAutoGrabBar"
    pbFrame.Size = UDim2.fromOffset(372, 42)
    pbFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    pbFrame.Position = UDim2.new(0.5, 0, 1, -52)
    pbFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    pbFrame.BackgroundTransparency = 1
    pbFrame.BorderSizePixel = 0
    pbFrame.Active = true
    pbFrame.ClipsDescendants = true
    pbFrame.Visible = CONFIG.AUTO_STEAL_ENABLED
    pbFrame.ZIndex = 300
    Instance.new("UICorner", pbFrame).CornerRadius = UDim.new(1, 0)

    local pbOuterStroke = Instance.new("UIStroke", pbFrame)
    pbOuterStroke.Name = "OuterStroke"
    pbOuterStroke.Color = Color3.fromRGB(220,220,220)
    pbOuterStroke.Thickness = 1.6
    pbOuterStroke.Transparency = 0.05
    pbOuterStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    local pbOuterGrad = Instance.new("UIGradient", pbOuterStroke)
    pbOuterGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0.00, Color3.fromRGB(55,55,55)),
        ColorSequenceKeypoint.new(0.42, Color3.fromRGB(190,190,190)),
        ColorSequenceKeypoint.new(0.50, Color3.fromRGB(255,255,255)),
        ColorSequenceKeypoint.new(0.58, Color3.fromRGB(190,190,190)),
        ColorSequenceKeypoint.new(1.00, Color3.fromRGB(55,55,55)),
    })
    task.spawn(function()
        while pbOuterGrad and pbOuterGrad.Parent do
            pbOuterGrad.Rotation = (pbOuterGrad.Rotation + 2) % 360
            task.wait(0.05)
        end
    end)

    stealBarScaleObj = Instance.new("UIScale", pbFrame)
    stealBarScaleObj.Name = "LustStealBarScale"
    stealBarScaleObj.Scale = uiScaleValue / 100
    if savedProgressBarPos then
        pbFrame.Position = UDim2.new(savedProgressBarPos.XScale or 0.5, savedProgressBarPos.XOffset or 0, savedProgressBarPos.YScale or 1, savedProgressBarPos.YOffset or -52)
    end

    local pbWallpaperLayer = Instance.new("Frame", pbFrame)
    pbWallpaperLayer.Name = "WallpaperLayer"
    pbWallpaperLayer.Size = UDim2.fromScale(1, 1)
    pbWallpaperLayer.Position = UDim2.fromScale(0, 0)
    pbWallpaperLayer.BackgroundTransparency = 1
    pbWallpaperLayer.BorderSizePixel = 0
    pbWallpaperLayer.ZIndex = 0
    pbWallpaperLayer.ClipsDescendants = true
    Instance.new("UICorner", pbWallpaperLayer).CornerRadius = UDim.new(1, 0)

    local pbWallpaper = Instance.new("ImageLabel", pbWallpaperLayer)
    pbWallpaper.Name = "Wallpaper"
    pbWallpaper.Size = UDim2.fromScale(1, 1)
    pbWallpaper.Position = UDim2.fromScale(0, 0)
    pbWallpaper.BackgroundTransparency = 1
    pbWallpaper.ImageTransparency = 0
    pbWallpaper.ScaleType = Enum.ScaleType.Crop
    pbWallpaper.ZIndex = 1
    pbWallpaper.Visible = true
    Instance.new("UICorner", pbWallpaper).CornerRadius = UDim.new(1, 0)

    local pbWallpaperOverlay = Instance.new("Frame", pbWallpaperLayer)
    pbWallpaperOverlay.Name = "WallpaperOverlay"
    pbWallpaperOverlay.Size = UDim2.fromScale(1, 1)
    pbWallpaperOverlay.Position = UDim2.fromScale(0, 0)
    pbWallpaperOverlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    pbWallpaperOverlay.BackgroundTransparency = 0.68
    pbWallpaperOverlay.BorderSizePixel = 0
    pbWallpaperOverlay.ZIndex = 2
    pbWallpaperOverlay.Visible = true
    Instance.new("UICorner", pbWallpaperOverlay).CornerRadius = UDim.new(1, 0)

    task.spawn(function()
        local imgId = "107957242975210"
        local ok, real = pcall(function()
            if getRealImage then return getRealImage(imgId) end
            return imgId
        end)
        real = ok and real or imgId
        if tostring(real):sub(1, 4) == "http" then
            pbWallpaper.Image = real
        else
            pbWallpaper.Image = "rbxassetid://" .. real
        end
    end)

    local pbTrack = Instance.new("Frame", pbFrame)
    pbTrack.Name = "LustStealTrack"
    pbTrack.Size = UDim2.new(0, 214, 1, -10)
    pbTrack.Position = UDim2.new(0, 6, 0, 5)
    pbTrack.BackgroundColor3 = Color3.fromRGB(8,8,8)
    pbTrack.BackgroundTransparency = 0.62
    pbTrack.BorderSizePixel = 0
    pbTrack.ClipsDescendants = true
    pbTrack.ZIndex = 3
    Instance.new("UICorner", pbTrack).CornerRadius = UDim.new(1, 0)

    progressFill = Instance.new("Frame", pbTrack)
    progressFill.Name = "Fill"
    progressFill.Size = UDim2.new(0, 0, 1, 0)
    progressFill.BackgroundColor3 = Color3.fromRGB(220,220,220)
    progressFill.BackgroundTransparency = 0.08
    progressFill.BorderSizePixel = 0
    progressFill.ZIndex = 4
    Instance.new("UICorner", progressFill).CornerRadius = UDim.new(1, 0)

    local pbFillGrad = Instance.new("UIGradient", progressFill)
    pbFillGrad.Name = "LustStealFillGradient"
    pbFillGrad.Rotation = 0
    pbFillGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0.00, Color3.fromRGB(55,55,55)),
        ColorSequenceKeypoint.new(0.34, Color3.fromRGB(190,190,190)),
        ColorSequenceKeypoint.new(0.47, Color3.fromRGB(235,235,235)),
        ColorSequenceKeypoint.new(0.50, Color3.fromRGB(255,255,255)),
        ColorSequenceKeypoint.new(0.53, Color3.fromRGB(235,235,235)),
        ColorSequenceKeypoint.new(0.66, Color3.fromRGB(190,190,190)),
        ColorSequenceKeypoint.new(1.00, Color3.fromRGB(55,55,55)),
    })
    task.spawn(function()
        while pbFillGrad and pbFillGrad.Parent do
            pbFillGrad.Offset = Vector2.new(-1, 0)
            local t = TS:Create(pbFillGrad, TweenInfo.new(1.15, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), {Offset = Vector2.new(1,0)})
            t:Play(); t.Completed:Wait()
            task.wait(0.03)
        end
    end)

    local pbBadge = Instance.new("Frame", pbTrack)
    pbBadge.Name = "AvatarBadge"
    pbBadge.Size = UDim2.fromOffset(28, 28)
    pbBadge.Position = UDim2.fromOffset(8, 2)
    pbBadge.BackgroundColor3 = Color3.fromRGB(10,10,14)
    pbBadge.BackgroundTransparency = 0.08
    pbBadge.BorderSizePixel = 0
    pbBadge.ZIndex = 7
    Instance.new("UICorner", pbBadge).CornerRadius = UDim.new(1, 0)

    local pbAvatar = Instance.new("ImageLabel", pbBadge)
    pbAvatar.Name = "Avatar"
    pbAvatar.Size = UDim2.fromOffset(18, 24)
    pbAvatar.Position = UDim2.fromOffset(2, 2)
    pbAvatar.BackgroundTransparency = 1
    pbAvatar.ScaleType = Enum.ScaleType.Crop
    pbAvatar.ZIndex = 8
    Instance.new("UICorner", pbAvatar).CornerRadius = UDim.new(1, 0)

    local pbBadgeStroke = Instance.new("UIStroke", pbBadge)
    pbBadgeStroke.Color = Color3.fromRGB(230,230,230)
    pbBadgeStroke.Thickness = 1.5
    pbBadgeStroke.Transparency = 0.02
    local pbBadgeGrad = Instance.new("UIGradient", pbBadgeStroke)
    pbBadgeGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0.00, Color3.fromRGB(55,55,55)),
        ColorSequenceKeypoint.new(0.42, Color3.fromRGB(190,190,190)),
        ColorSequenceKeypoint.new(0.50, Color3.fromRGB(255,255,255)),
        ColorSequenceKeypoint.new(0.58, Color3.fromRGB(190,190,190)),
        ColorSequenceKeypoint.new(1.00, Color3.fromRGB(55,55,55)),
    })
    task.spawn(function()
        while pbBadgeGrad and pbBadgeGrad.Parent do
            pbBadgeGrad.Rotation = (pbBadgeGrad.Rotation + 3) % 360
            task.wait(0.025)
        end
    end)

    task.spawn(function()
        local ok, img = pcall(function()
            return Players:GetUserThumbnailAsync(LP.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
        end)
        if ok and img and pbAvatar and pbAvatar.Parent then pbAvatar.Image = img end
    end)

    progressPct = Instance.new("TextLabel", pbTrack)
    progressPct.Size = UDim2.new(0, 50, 1, 0)
    progressPct.Position = UDim2.new(1, -55, 0, 0)
    progressPct.BackgroundTransparency = 1
    progressPct.Text = "0%"
    progressPct.TextColor3 = Color3.fromRGB(230,230,230)
    progressPct.Font = Enum.Font.GothamSemibold
    progressPct.TextSize = 12
    progressPct.TextXAlignment = Enum.TextXAlignment.Right
    progressPct.ZIndex = 6

    local pbFpsLabel = Instance.new("TextLabel", pbFrame)
    pbFpsLabel.Name = "FPSPING"
    pbFpsLabel.Size = UDim2.new(0, 144, 0, 18)
    pbFpsLabel.Position = UDim2.fromOffset(222, 2)
    pbFpsLabel.BackgroundTransparency = 1
    pbFpsLabel.Text = "FPS 0  ·  0ms"
    pbFpsLabel.TextColor3 = Color3.fromRGB(230,230,230)
    pbFpsLabel.Font = Enum.Font.GothamSemibold
    pbFpsLabel.TextSize = 11
    pbFpsLabel.TextXAlignment = Enum.TextXAlignment.Center
    pbFpsLabel.ZIndex = 6

    local pbClock = Instance.new("TextLabel", pbFrame)
    pbClock.Name = "Clock"
    pbClock.Size = UDim2.new(0, 144, 0, 16)
    pbClock.Position = UDim2.fromOffset(222, 22)
    pbClock.BackgroundTransparency = 1
    pbClock.Text = "8:00 PM"
    pbClock.TextColor3 = Color3.fromRGB(255,255,255)
    pbClock.Font = Enum.Font.GothamSemibold
    pbClock.TextSize = 10
    pbClock.TextXAlignment = Enum.TextXAlignment.Center
    pbClock.ZIndex = 50

    task.spawn(function()
        local frameCount = 0
        local windowStart = tick()
        local fpsAvg = 60
        local lastPing = 0
        local fpsTickConn = _LustOn(RunService.RenderStepped, function()
            frameCount = frameCount + 1
        end)
        local function readPing()
            -- Ping de red del jugador (segundos -> ms)
            local ok, v = pcall(function() return LP:GetNetworkPing() * 1000 end)
            if ok and type(v) == "number" and v == v and v >= 0 and v < 5000 then return v end
            -- Respaldo: estadistica "Data Ping" de Roblox
            local ok2, v2 = pcall(function()
                return game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue()
            end)
            if ok2 and type(v2) == "number" and v2 >= 0 then return v2 end
            return nil
        end
        while pbFrame and pbFrame.Parent do
            local now = tick()
            local elapsed = now - windowStart
            if elapsed > 0.05 then
                local instantFps = frameCount / elapsed
                fpsAvg = fpsAvg + (instantFps - fpsAvg) * 0.5
                frameCount = 0
                windowStart = now
            end
            local p = readPing()
            if p then lastPing = _floor(p + 0.5) end   -- si falla, conserva el ultimo valor (ya no cae a 0)
            pbFpsLabel.Text = string.format("FPS %d  ·  %dms", _floor(fpsAvg + 0.5), lastPing)
            pbClock.Text = os.date("%I:%M %p"):gsub("^0", "")
            task.wait(0.25)
        end
        if fpsTickConn then fpsTickConn:Disconnect() end
    end)

    local pbStatusLabel = Instance.new("TextLabel", pbFrame)
    pbStatusLabel.Name = "StatusLabel"
    pbStatusLabel.Size = UDim2.fromOffset(0, 0)
    pbStatusLabel.Position = UDim2.fromOffset(0, 0)
    pbStatusLabel.BackgroundTransparency = 1
    pbStatusLabel.Text = ""
    pbStatusLabel.Visible = false

    _G.__LustSetStealStatus = function(text, success) end

    drag(pbFrame)
end

function createMobilePanel()
    local panel = Instance.new("ScreenGui")
    panel.Name = "LustMobilePanel"
    panel.ResetOnSpawn = false
    panel.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    pcall(function() if syn and syn.protect_gui then syn.protect_gui(panel) end end)
    local okPanel = pcall(function() panel.Parent = game:GetService("CoreGui") end)
    if not okPanel then panel.Parent = LP:WaitForChild("PlayerGui") end

    local BTN_SIZE = 52
    local BTN_CORNER = 10

    local buttons = {}
    local buttonNames = {"DropBR", "AutoPlay", "AutoBat", "TpDown", "Carry", "Lagger1", "Lagger2", "Float"}
    local buttonTexts = {"DROP BR", "AUTO PLAY", "BAT AIMBOT", "TP DOWN", "CARRY SPD", "LAGGER NORM", "LAGGER CARRY", "FLOAT"}

    local function paintBtnVisual(btn, isActive)
        local bg     = btn:FindFirstChild("BtnBG", true)
        local glow   = btn:FindFirstChild("BtnGlow", true)
        local shine  = btn:FindFirstChild("BtnShine", true)
        local stroke = btn:FindFirstChildOfClass("UIStroke")
        local label  = btn:FindFirstChild("BtnLabel", true)
        if not bg then return end

        local tint = Color3.fromRGB(255, 255, 255)

        if isActive then
            bg.BackgroundColor3 = tint
            bg.BackgroundTransparency = 0
            bg.ImageColor3 = tint
            local grad = bg:FindFirstChild("ButtonNoneGradient")
            if grad then
                grad.Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0.00, Color3.fromRGB(245, 245, 250)),
                    ColorSequenceKeypoint.new(0.45, Color3.fromRGB(200, 200, 210)),
                    ColorSequenceKeypoint.new(1.00, Color3.fromRGB(150, 150, 165)),
                })
            end
            if glow then
                glow.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                glow.BackgroundTransparency = 0
                glow.ImageTransparency = 1
                glow.ImageColor3 = tint
            end
            if shine then
                shine.Enabled = true
                shine.Rotation = 90
                shine.Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 255, 255)),
                    ColorSequenceKeypoint.new(0.32, Color3.fromRGB(240, 240, 245)),
                    ColorSequenceKeypoint.new(0.68, Color3.fromRGB(210, 210, 218)),
                    ColorSequenceKeypoint.new(1.00, Color3.fromRGB(150, 150, 165)),
                })
            end
            if stroke then
                stroke.Transparency = 1
            end
            if label then
                label.TextColor3 = Color3.fromRGB(20, 20, 30)
                label.TextTransparency = 0
            end
        else
            bg.BackgroundColor3 = tint
            bg.BackgroundTransparency = 0
            bg.ImageColor3 = tint
            local grad = bg:FindFirstChild("ButtonNoneGradient")
            if grad then
                grad.Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(2, 2, 3)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(2, 2, 10)),
                })
            end
            if glow then
                glow.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                glow.BackgroundTransparency = 1
                glow.ImageTransparency = 1
            end
            if shine then
                shine.Enabled = false
            end
            if stroke then
                stroke.Transparency = 1
                stroke.Thickness = 1.1
                stroke.Color = Color3.fromRGB(255, 255, 255)
            end
            if label then
                label.TextColor3 = Color3.fromRGB(255, 255, 255)
                label.TextTransparency = 0
            end
        end
    end

    local function createButton(name, text, order, isToggle, callback)
        local btn = Instance.new("TextButton", panel)
        btn.Name = name
        btn.Size = UDim2.new(0, BTN_SIZE, 0, BTN_SIZE)
        btn.BackgroundColor3 = Color3.fromRGB(2, 2, 10)
        btn.BorderSizePixel = 0
        btn.Text = ""
        btn.AutoButtonColor = false
        btn.ClipsDescendants = true
        btn.ZIndex = 10
        local savedPos = savedButtonPositions[name]
        if savedPos then btn.Position = UDim2.new(0, savedPos.X or 0, 0, savedPos.Y or 0)
        else
            local defX, defY = getDefaultButtonPosition(name)
            btn.Position = UDim2.new(0, defX, 0, defY)
        end
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, BTN_CORNER)

        local mask = Instance.new("CanvasGroup", btn)
        mask.Name = "RoundedVisualMask"
        mask.BackgroundColor3 = Color3.fromRGB(2, 2, 10)
        mask.BackgroundTransparency = 0
        mask.BorderSizePixel = 0
        mask.Size = UDim2.fromScale(1, 1)
        mask.ClipsDescendants = true
        mask.ZIndex = 1
        Instance.new("UICorner", mask).CornerRadius = UDim.new(0, BTN_CORNER)

        local bg = Instance.new("ImageLabel", mask)
        bg.Name = "BtnBG"
        bg.BackgroundTransparency = 1
        bg.Image = ""
        bg.ScaleType = Enum.ScaleType.Stretch
        bg.ImageRectSize = Vector2.zero
        bg.ImageRectOffset = Vector2.zero
        bg.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        bg.BackgroundTransparency = 0
        bg.ImageColor3 = Color3.fromRGB(255, 255, 255)
        bg.Size = UDim2.fromScale(1, 1)
        bg.ZIndex = 1
        Instance.new("UICorner", bg).CornerRadius = UDim.new(0, BTN_CORNER)

        local bgGrad = Instance.new("UIGradient", bg)
        bgGrad.Name = "ButtonNoneGradient"
        bgGrad.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(2, 2, 3)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(2, 2, 10)),
        })
        bgGrad.Rotation = 25

        local glow = Instance.new("ImageLabel", mask)
        glow.Name = "BtnGlow"
        glow.BackgroundTransparency = 1
        glow.Image = ""
        glow.ScaleType = Enum.ScaleType.Stretch
        glow.ImageRectSize = Vector2.zero
        glow.ImageRectOffset = Vector2.zero
        glow.ImageColor3 = Color3.fromRGB(255, 255, 255)
        glow.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        glow.BackgroundTransparency = 1
        glow.BorderSizePixel = 0
        glow.Size = UDim2.fromScale(1, 1)
        glow.ZIndex = 2
        Instance.new("UICorner", glow).CornerRadius = UDim.new(0, BTN_CORNER)

        local shine = Instance.new("UIGradient", glow)
        shine.Name = "BtnShine"
        shine.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 255, 255)),
            ColorSequenceKeypoint.new(0.32, Color3.fromRGB(238, 238, 244)),
            ColorSequenceKeypoint.new(0.68, Color3.fromRGB(184, 184, 194)),
            ColorSequenceKeypoint.new(1.00, Color3.fromRGB(82,  82,  92)),
        })
        shine.Rotation = 90
        shine.Enabled = false

        local label = Instance.new("TextLabel", mask)
        label.Name = "BtnLabel"
        label.BackgroundTransparency = 1
        label.Position = UDim2.new(0, 2, 0, 0)
        label.Size = UDim2.new(1, -4, 1, 0)
        label.Text = text
        label.TextColor3 = Color3.fromRGB(255, 255, 255)
        label.Font = Enum.Font.GothamBlack
        label.TextSize = 9
        label.TextWrapped = true
        label.TextXAlignment = Enum.TextXAlignment.Center
        label.TextYAlignment = Enum.TextYAlignment.Center
        label.TextTransparency = 0
        label.ZIndex = 3
        local lblStroke = Instance.new("UIStroke", label)
        lblStroke.Color = Color3.fromRGB(0, 0, 0)
        lblStroke.Thickness = 1
        lblStroke.Transparency = 1

        local stroke = Instance.new("UIStroke", btn)
        stroke.Color = Color3.fromRGB(255, 255, 255)
        stroke.Thickness = 1.1
        stroke.Transparency = 1
        stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

        local uiScale = Instance.new("UIScale", btn)
        uiScale.Scale = floatingButtonScale
        table.insert(_floatingUIScales, uiScale)

        local active = false
        local function setActive(state)
            local isActive = state == true or state == "secondary"
            local wasActive = active
            active = isActive
            btn:SetAttribute("MobActive", isActive and true or false)
            paintBtnVisual(btn, isActive)
            if isActive and not wasActive then
                local targetScale = floatingButtonScale * 1.08
                TS:Create(uiScale, TweenInfo.new(0.1, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Scale = targetScale}):Play()
                task.delay(0.11, function()
                    TS:Create(uiScale, TweenInfo.new(0.14, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Scale = floatingButtonScale}):Play()
                end)
            end
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
        _LustOn(UIS.InputEnded, function(inp)
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
                executeDropWithToggle(function(v)
                    if dropBrainrotSetVisual then dropBrainrotSetVisual(v) end
                end)
            end
        elseif name == "AutoPlay" then
            callback = function(setActive)
                if Config._isAutoplayActive and Config._isAutoplayActive() then
                    stopAutoPlay()
                else
                    startAutoPlay()
                end
                setActive(Config._isAutoplayActive and Config._isAutoplayActive() or false)
            end
        elseif name == "AutoBat" then
            callback = function(setActive)
                if not autoBatEnabled then enableAutoBat() else disableAutoBat() end
                setActive(autoBatEnabled)
            end
        elseif name == "TpDown" then
            callback = function(setActive)
                doTpDown()
                setActive(true)
                task.delay(0.2, function() setActive(false) end)
            end
        elseif name == "Carry" then
            callback = function() toggleCarryMode() end
        elseif name == "Lagger1" then
            callback = function() toggleLaggerMode() end
        elseif name == "Lagger2" then
            callback = function() toggleLaggerCarryMode() end
        elseif name == "Float" then
            callback = function(setActive)
                if _G.__LustFloatToggle then _G.__LustFloatToggle() end
                setActive(_G.__LustFloatIsRunning and _G.__LustFloatIsRunning() or false)
            end
        end
        local setActive = createButton(name, text, i-1, true, callback)
        if name == "AutoBat" then mobSetAutoBat = setActive end
        if name == "AutoPlay" then mobSetAutoPlay = setActive end
        if name == "TpDown" then mobSetTpDown = setActive end
        if name == "Carry" then mobSetCarry = setActive end
        if name == "Lagger1" then mobSetLagger1 = setActive end
        if name == "Lagger2" then mobSetLagger2 = setActive end
        if name == "Float" then mobSetFloat = setActive end
    end
    if buttons.AutoBat and buttons.AutoBat.setActive then buttons.AutoBat.setActive(autoBatEnabled) end
    if buttons.AutoPlay and buttons.AutoPlay.setActive then buttons.AutoPlay.setActive(Config._isAutoplayActive and Config._isAutoplayActive() or false) end
    if buttons.Carry and buttons.Carry.setActive then buttons.Carry.setActive(speedMode) end
    if buttons.Lagger1 and buttons.Lagger1.setActive then buttons.Lagger1.setActive(laggerToggled) end
    if buttons.Lagger2 and buttons.Lagger2.setActive then buttons.Lagger2.setActive(laggerCarryToggled) end
    if buttons.Float and buttons.Float.setActive then buttons.Float.setActive(_G.__LustFloatIsRunning and _G.__LustFloatIsRunning() or false) end
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
    btnFrame.Size = UDim2.new(0, 52, 0, 52)
    btnFrame.Name = "Frame"
    local cam = workspace.CurrentCamera
    local vpW = (cam and cam.ViewportSize.X) or 1920
    if instaResetFloatingPos then
        btnFrame.Position = UDim2.new(
            instaResetFloatingPos.XScale or 0,
            instaResetFloatingPos.XOffset or (vpW - 72),
            instaResetFloatingPos.YScale or 0,
            instaResetFloatingPos.YOffset or 6
        )
    else
        btnFrame.Position = UDim2.new(0, vpW - 72, 0, 6)
    end
    btnFrame.BackgroundColor3 = Color3.fromRGB(2, 2, 10)
    btnFrame.BorderSizePixel = 0
    btnFrame.ZIndex = 20
    btnFrame.ClipsDescendants = true
    Instance.new("UICorner", btnFrame).CornerRadius = UDim.new(0, 10)

    local mask = Instance.new("CanvasGroup", btnFrame)
    mask.Name = "RoundedVisualMask"
    mask.BackgroundColor3 = Color3.fromRGB(2, 2, 10)
    mask.BackgroundTransparency = 0
    mask.BorderSizePixel = 0
    mask.Size = UDim2.fromScale(1, 1)
    mask.ClipsDescendants = true
    mask.ZIndex = 21
    Instance.new("UICorner", mask).CornerRadius = UDim.new(0, 10)

    local bg = Instance.new("ImageLabel", mask)
    bg.Name = "BtnBG"
    bg.BackgroundTransparency = 1
    bg.Image = ""
    bg.ScaleType = Enum.ScaleType.Stretch
    bg.ImageRectSize = Vector2.zero
    bg.ImageRectOffset = Vector2.zero
    bg.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    bg.BackgroundTransparency = 0
    bg.ImageColor3 = Color3.fromRGB(255, 255, 255)
    bg.Size = UDim2.fromScale(1, 1)
    bg.ZIndex = 1
    Instance.new("UICorner", bg).CornerRadius = UDim.new(0, 10)

    local bgGrad = Instance.new("UIGradient", bg)
    bgGrad.Name = "ButtonNoneGradient"
    bgGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(2, 2, 3)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(2, 2, 10)),
    })
    bgGrad.Rotation = 25

    local glow = Instance.new("ImageLabel", mask)
    glow.Name = "BtnGlow"
    glow.BackgroundTransparency = 1
    glow.Image = ""
    glow.ScaleType = Enum.ScaleType.Stretch
    glow.ImageRectSize = Vector2.zero
    glow.ImageRectOffset = Vector2.zero
    glow.ImageColor3 = Color3.fromRGB(255, 255, 255)
    glow.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    glow.BackgroundTransparency = 1
    glow.BorderSizePixel = 0
    glow.Size = UDim2.fromScale(1, 1)
    glow.ZIndex = 2
    Instance.new("UICorner", glow).CornerRadius = UDim.new(0, 10)

    local shine = Instance.new("UIGradient", glow)
    shine.Name = "BtnShine"
    shine.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(0.32, Color3.fromRGB(238, 238, 244)),
        ColorSequenceKeypoint.new(0.68, Color3.fromRGB(184, 184, 194)),
        ColorSequenceKeypoint.new(1.00, Color3.fromRGB(82,  82,  92)),
    })
    shine.Rotation = 90
    shine.Enabled = false

    local label = Instance.new("TextLabel", mask)
    label.Name = "BtnLabel"
    label.BackgroundTransparency = 1
    label.Position = UDim2.new(0, 2, 0, 0)
    label.Size = UDim2.new(1, -4, 1, 0)
    label.Text = "INSTA\nRESET"
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.Font = Enum.Font.GothamBlack
    label.TextSize = 9
    label.TextWrapped = true
    label.TextXAlignment = Enum.TextXAlignment.Center
    label.TextYAlignment = Enum.TextYAlignment.Center
    label.TextTransparency = 0
    label.ZIndex = 3
    local lblStroke = Instance.new("UIStroke", label)
    lblStroke.Color = Color3.fromRGB(0, 0, 0)
    lblStroke.Thickness = 1
    lblStroke.Transparency = 1

    local stroke = Instance.new("UIStroke", btnFrame)
    stroke.Color = Color3.fromRGB(255, 255, 255)
    stroke.Thickness = 1.1
    stroke.Transparency = 1
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

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
        local isActive = state == true
        local tint = Color3.fromRGB(255, 255, 255)
        if isActive then
            bg.BackgroundColor3 = tint
            bg.BackgroundTransparency = 0
            bg.ImageColor3 = tint
            bgGrad.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0.00, Color3.fromRGB(245, 245, 250)),
                ColorSequenceKeypoint.new(0.45, Color3.fromRGB(200, 200, 210)),
                ColorSequenceKeypoint.new(1.00, Color3.fromRGB(150, 150, 165)),
            })
            glow.BackgroundTransparency = 0
            glow.ImageTransparency = 1
            shine.Enabled = true
            shine.Rotation = 90
            stroke.Transparency = 1
            label.TextColor3 = Color3.fromRGB(20, 20, 30)
            label.TextTransparency = 0
        else
            bg.BackgroundColor3 = tint
            bg.BackgroundTransparency = 0
            bg.ImageColor3 = tint
            bgGrad.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(2, 2, 3)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(2, 2, 10)),
            })
            glow.BackgroundTransparency = 1
            shine.Enabled = false
            stroke.Transparency = 1
            label.TextColor3 = Color3.fromRGB(255, 255, 255)
            label.TextTransparency = 0
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
    _LustOn(UIS.InputChanged, function(inp)
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
    _LustOn(UIS.InputEnded, function(inp)
        if inp ~= activeInput then return end
        if inp.UserInputType ~= Enum.UserInputType.MouseButton1 and inp.UserInputType ~= Enum.UserInputType.Touch then return end
        if dragging then
            local delta = inp.Position - dragStart
            local validTap = not hasMoved and delta.Magnitude <= RESET_TAP_THRESHOLD and pointInside(inp.Position)
            if validTap then
                setActive(true)
                if _G.LustInstaReset and _G.LustInstaReset.Trigger then _G.LustInstaReset.Trigger() end
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
    if normalBox then normalBox.Text = tostring(NS) end
    if carryBox then carryBox.Text = tostring(CS) end
    if radInput then radInput.Text = tostring(CONFIG.STEAL_RANGE) end
    if laggerBox then laggerBox.Text = tostring(LAGGER_SPEED) end
    if lagger2Box then lagger2Box.Text = tostring(LAGGER_CARRY_SPEED) end
    if batSpeedBox then batSpeedBox.Text = tostring(BAT_AIMBOT_SPEED) end
    if uiScaleBox then uiScaleBox.Text = tostring(uiScaleValue) end
    if buttonScaleBox then buttonScaleBox.Text = tostring(_floor(floatingButtonScale * 100 + 0.5)) end
    if syncDropModeUI then syncDropModeUI() end
    if bodyLockRangeBox then bodyLockRangeBox.Text = tostring(bodyLockRange) end
    refreshSpeedModeLabel()
    for _, ref in ipairs(keyButtonRefs) do
        local entry = ref.entry
        local label = (entry.gp and entry.gp.Name) or (entry.kb and entry.kb.Name) or "None"
        ref.btn.Text = label
    end
    if savedProgressBarPos and pbFrame then
        pbFrame.Position = UDim2.new(savedProgressBarPos.XScale or 0.5, savedProgressBarPos.XOffset or 0, savedProgressBarPos.YScale or 1, savedProgressBarPos.YOffset or -52)
    end
    applyFloatingButtonScale()
    if uiLocked and setLockUIVisual then setLockUIVisual(true) end
    applyAntiRagdollMode(antiRagdollMode)
    antiRagdollSyncUI()
    if antiDieEnabled then
        if setAntiDieVisual then setAntiDieVisual(true) end
        AntiDieModule.start()
    else
        if setAntiDieVisual then setAntiDieVisual(false) end
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
        task.defer(function()
            task.wait(0.1)
            stopBatCounter()
            task.wait(0.05)
            startBatCounter()
        end)
    end
    if unwalkEnabled and setUnwalkVisual then
        setUnwalkVisual(true)
        task.spawn(function() task.wait(0.5); startUnwalk() end)
    end
    if antiLagEnabled then
        if setAntiLagVisual then setAntiLagVisual(true) end
        task.spawn(enableAntiLag)
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
    if saturationEnabled then
        applySaturation(true)
        if setSaturationVisual then setSaturationVisual(true) end
    else
        applySaturation(false)
        if setSaturationVisual then setSaturationVisual(false) end
    end
    if stretchEnabled then
        enableStretch()
        if _G.stretchToggleSetter then _G.stretchToggleSetter(true) end
    else
        if _G.stretchToggleSetter then _G.stretchToggleSetter(false) end
    end
    if mobSetAutoBat then mobSetAutoBat(autoBatEnabled) end
    if mobSetAutoPlay then mobSetAutoPlay(Config._isAutoplayActive and Config._isAutoplayActive() or false) end
    if mobSetCarry then mobSetCarry(speedMode) end
    if mobSetLagger1 then mobSetLagger1(laggerToggled) end
    if mobSetLagger2 then mobSetLagger2(laggerCarryToggled) end
    if mobSetFloat then mobSetFloat(_G.__LustFloatIsRunning and _G.__LustFloatIsRunning() or false) end
    if bodyLockEnabled and bodyLockSetVisual then
        if _blSuppressCount == 0 then
            bodyLockSetVisual(true)
            startBodyLock()
        else bodyLockSetVisual(false) end
    end
    if mirrorTPSetVisual then
        mirrorTPSetVisual(_G.LustMirrorTPDownEnabled == true)
    end
    if _G.LustSetMirrorTPDown then pcall(_G.LustSetMirrorTPDown, _G.LustMirrorTPDownEnabled == true) end
    updateProgressBarVisibility()
    startEnemySpeed()
    toggleLockUI(uiLocked)
    if outfitSelectorLabel then outfitSelectorLabel.Text = OUTFITS[currentOutfitIndex].label end
    if _G.__LustTpDownSetVisual then _G.__LustTpDownSetVisual(tpDownAutoEnabled) end
    if _G.__LustSwingSetVisual then _G.__LustSwingSetVisual(autoSwingEnabled ~= false) end
    if tpDownAutoEnabled then
        startTpDownAuto()
        if mobSetTpDown then mobSetTpDown(true) end
    end

    if _G.LustBaseXRayEnabled and _G.LustSetBaseXRay then
        task.defer(function() pcall(_G.LustSetBaseXRay, true) end)
    end
    pcall(_lustSyncToggleVisuals, true)
end

_lustToggleBindings = {
    { function() return setAntiDieVisual end,            function() return _antiDieUserPref == true end },
    { function() return setUnwalkVisual end,             function() return unwalkEnabled == true end },
    { function() return mirrorTPSetVisual end,           function() return _G.LustMirrorTPDownEnabled == true end },
    { function() return _G.__LustSwingSetVisual end,     function() return autoSwingEnabled ~= false end },
    { function() return setBatCounterVisual end,         function() return batCounterEnabled == true end },
    { function() return setMedusaVisual end,             function() return medusaCounterEnabled == true end },
    { function() return setInstaGrab end,                function() return CONFIG.AUTO_STEAL_ENABLED == true end },
    { function() return setLockUIVisual end,             function() return uiLocked == true end },
    { function() return setHideButtonsVisual end,        function() return hideButtonsEnabled == true end },
    { function() return setSaturationVisual end,         function() return saturationEnabled == true end },
    { function() return _G.__LustXRaySetVisual end,      function() return _G.LustBaseXRayEnabled == true end },
    { function() return _G.__LustStretchSetVisual end,   function() return stretchEnabled == true end },
    { function() return setAntiLagVisual end,            function() return antiLagEnabled == true end },
    { function() return setESPVIsual end,                function() return espEnabled == true end },
    { function() return setESPLineVisual end,            function() return espLineEnabled == true end },
    { function() return _G.__LustTpDownSetVisual end,    function() return tpDownAutoEnabled == true end },
    { function() return _G.__LustAutoCarrySetVisual end, function() return autoCarryEnabled == true end },
}
_lustDriftCount = {}

function _lustSyncToggleVisuals(force)
    local vg = _G.__LustVisualGet
    if not vg then return end
    for i, b in ipairs(_lustToggleBindings) do
        pcall(function()
            local sv = b[1]()
            local get = sv and vg[sv]
            if not get then return end
            local want = b[2]() == true
            if get() ~= want then
                _lustDriftCount[i] = (_lustDriftCount[i] or 0) + 1
                if force or _lustDriftCount[i] >= 2 then
                    sv(want)
                    _lustDriftCount[i] = 0
                end
            else
                _lustDriftCount[i] = 0
            end
        end)
    end
end

function _bootSection(name, fn)
    return (pcall(fn))
end

_G.__LustUninstall = function()
    pcall(function() saveAllSettings(true) end)
    pcall(function()
        local ge = (type(getgenv) == "function" and getgenv()) or _G
        ge.__LustSessionId = (ge.__LustSessionId or 0) + 1
    end)
    _lustBootDone = false
    pcall(stopAntiRagdollAll)
    pcall(function()
        local F = _G.__LustFloat
        if type(F) == "table" then
            local wasOn = F.running == true or F.conn ~= nil
            F.running = false
            if F.thread then pcall(task.cancel, F.thread); F.thread = nil end
            if F.conn then pcall(function() F.conn:Disconnect() end); F.conn = nil end
            if wasOn and type(doTpDown) == "function" then pcall(doTpDown) end
        end
    end)
    pcall(function()
        autoBatEnabled = false
        local AB = _lustAimbot
        if AB then
            AB.suppressed = false
            if AB.watchdog then pcall(function() AB.watchdog:Disconnect() end); AB.watchdog = nil end
        end
        if stopAimbotLust then stopAimbotLust() end
        if stopFastAutoSwing then stopFastAutoSwing() end
        if AB and AB.clearMover then AB.clearMover() end
    end)
    pcall(stopAllBackgroundTasks)
    pcall(stopTpDownAuto)
    pcall(disableVividGraphics)
    pcall(_v4mpClearSky)
    pcall(stopAnimPack)
    pcall(function()
        if _G.LustSetBaseXRay then _G.LustSetBaseXRay(false) end
    end)
    for _, c in ipairs(_G.__LustConns or {}) do pcall(function() c:Disconnect() end) end
    _G.__LustConns = {}
    for _, parent in ipairs({ game:GetService("CoreGui"), LP:FindFirstChild("PlayerGui") }) do
        for _, n in ipairs({ "Lust Hub", "LustMobilePanel", "InstaResetButton", "LustESPLine", "LustBootErrors" }) do
            local o = parent:FindFirstChild(n)
            if o then pcall(function() o:Destroy() end) end
        end
    end
    local hd = LP.Character and LP.Character:FindFirstChild("Head")
    local bb = hd and hd:FindFirstChild("LustSpeedIndicator")
    if bb then pcall(function() bb:Destroy() end) end
    _G.LustRunning = false
end
pcall(function()
    local ge = (type(getgenv) == "function" and getgenv()) or _G
    ge.__LustUninstall = _G.__LustUninstall
end)

_bootSection("buildGui", function() buildGui() end)

if gui and main then
    if LP.Character then pcall(captureOriginalAppearance, LP.Character) end
    local loaded = false
    _bootSection("loadAllSettings", function() loaded = loadAllSettings() end)
    _isLoading = false
    _lastSavedJSON = nil
    _lustBootDone = true
    task.defer(function() pcall(saveAllSettings, true) end)
    _bootSection("createMobilePanel", function() MobilePanel = createMobilePanel() end)
    _bootSection("createInstaResetFloatingButton", function() instaResetFloatingButton = createInstaResetFloatingButton() end)
    if hideButtonsEnabled then
        _bootSection("applyHideButtons", function()
            applyHideButtons(true)
            if setHideButtonsVisual then setHideButtonsVisual(true) end
        end)
    end
    _bootSection("localizeLustInterface", function()
        if gui then localizeLustInterface(gui) end
        if MobilePanel then localizeLustInterface(MobilePanel) end
        if instaResetFloatingButton then localizeLustInterface(instaResetFloatingButton) end
    end)
    if LP.Character then
        task.spawn(function() pcall(setupMovementAndIndicators, LP.Character) end)
    end
    if loaded then
        task.spawn(function() _bootSection("updateUIFromLoaded", updateUIFromLoaded) end)
    end
else
    warn("[Lust Hub] Fatal: buildGui falló. El script no puede continuar.")
end

-- ═══════════════════════════════════════════════════════════════════
-- RESPAWN HANDLER + INSTA RESET TOOL RESTORE
-- ═══════════════════════════════════════════════════════════════════
if LP and LP.CharacterAdded then
    pcall(function()
        local _respawnQueue = 0

        _G.__LustLastEquippedTool = _G.__LustLastEquippedTool or nil
        local function _watchToolsFor(char)
            if not char then return end
            if not char:GetAttribute("_LustToolWatch") then
                char:SetAttribute("_LustToolWatch", true)
                _LustOn(char.ChildAdded, function(ch)
                    if ch:IsA("Tool") then
                        _G.__LustLastEquippedTool = ch.Name
                    end
                end)
            end
        end

        if LP.Character then
            _watchToolsFor(LP.Character)
        end

        _LustOn(LP.CharacterAdded, function(char)
            pcall(function()
                _respawnQueue = _respawnQueue + 1
                local myId = _respawnQueue
                isStealing = false
                if stopAutoPlay and _apFlag11 then stopAutoPlay() end
                local _wasBat = batCounterEnabled
                if stopBatCounter then stopBatCounter() end
                batCounterEnabled = _wasBat
                if stopMedusaCounter then stopMedusaCounter() end
                if stopUnwalk then stopUnwalk() end
                if stopDropBrainrot then stopDropBrainrot() end
                if autoBatEnabled and disableAutoBat then disableAutoBat() end
                if bodyLockEnabled and stopBodyLock then stopBodyLock() end

                _watchToolsFor(char)

                local deadline = _tick() + 5
                while (not char.Parent) or (not char:FindFirstChild("HumanoidRootPart")) or (not char:FindFirstChildOfClass("Humanoid")) do
                    if _tick() > deadline then return end
                    if myId ~= _respawnQueue then return end
                    task.wait(0.05)
                end

                local savedToolName = _G.__LustLastEquippedTool
                if savedToolName then
                    task.delay(0.6, function()
                        if LP.Character ~= char then return end
                        if char:FindFirstChildOfClass("Tool") then return end
                        local bp = LP:FindFirstChildOfClass("Backpack")
                        if not bp then return end
                        local tool = bp:FindFirstChild(savedToolName)
                        if not tool or not tool:IsA("Tool") then
                            for _, t in ipairs(bp:GetChildren()) do
                                if t:IsA("Tool") and (t.Name:lower():find("bat") or t.Name:lower():find("slap") or isBatTool(t)) then
                                    tool = t; break
                                end
                            end
                        end
                        if tool and tool:IsA("Tool") then
                            local hum = char:FindFirstChildOfClass("Humanoid")
                            if hum then pcall(function() hum:EquipTool(tool) end) end
                        end
                    end)
                end

                _hookedVelParts = {}
                local _hrpRespawn = _setupVelChecked(char)
                _hookVelHRP(_hrpRespawn)
                if not _originalAppearance then task.defer(function() captureOriginalAppearance(char) end) end
                if setupMovementAndIndicators then setupMovementAndIndicators(char) end
                if antiRagdollMode ~= "off" and not antiRagdollIsRunning() then applyAntiRagdollMode(antiRagdollMode) end
                if AntiDieModule.enabled then task.defer(function() activateOnCharacter(char) end) end
                if CONFIG.AUTO_STEAL_ENABLED then pcall(startAutoSteal) end
                if bodyLockEnabled and _blSuppressCount == 0 then startBodyLock() end
                if medusaCounterEnabled then
                    setupMedusaCounter(char)
                    if setMedusaVisual then setMedusaVisual(true) end
                else
                    stopMedusaCounter()
                    if setMedusaVisual then setMedusaVisual(false) end
                end
                if batCounterEnabled then startBatCounter() end
                if unwalkEnabled then startUnwalk() end
                if currentAnimPack ~= "Off" then startAnimPack(currentAnimPack) end
                updateProgressBarVisibility()
                refreshSpeedModeLabel()
                pcall(function() applyOutfitByIndex(currentOutfitIndex) end)
                if outfitSelectorLabel then outfitSelectorLabel.Text = OUTFITS[currentOutfitIndex].label end
                if _G.LustBaseXRayEnabled and _G.LustSetBaseXRay then
                    task.defer(function() pcall(_G.LustSetBaseXRay, true) end)
                end
            end)
        end)
    end)
end

lastLaggerToggle = 0
LAGGER_COOLDOWN = 0.3

_LustOn(UIS.InputBegan, function(input, gpe)
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
        if _G.LustInstaReset and _G.LustInstaReset.Trigger then _G.LustInstaReset.Trigger() end
        return
    end
    if kbMatch(KB.AutoPlay, kc) then
        if Config._isAutoplayActive and Config._isAutoplayActive() then
            stopAutoPlay()
        else
            startAutoPlay()
        end
        return
    end
    if kbMatch(KB.AutoBat, kc) then
        if autoBatEnabled then disableAutoBat() else enableAutoBat() end
        return
    end
    if kbMatch(KB.Float, kc) then
        if _G.__LustFloatToggle then _G.__LustFloatToggle() end
        return
    end
end)

task.spawn(function()
    while _G.LustRunning and _lustSessionAlive() do
        task.wait(0.5)
        if _lustBootDone and _tick() - (_G.__LustLastTap or 0) > 1 then
            pcall(_lustSyncToggleVisuals)
        end
    end
end)

task.spawn(function()
    while _G.LustRunning and _lustSessionAlive() do
        task.wait(6)
        if not _lustSessionAlive() then break end
        pcall(function() saveAllSettings() end)
    end
end)