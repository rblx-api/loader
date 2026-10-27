-- ⏱ KEY CON EXPIRACIÓN
local keyExpiry = 1793135314099
local now = os.time() * 1000
if now > keyExpiry then
  pcall(function()
    game:GetService("Players").LocalPlayer:Kick("KEY EXPIRADA")
  end)
  return
end

-- 🔐 USUARIOS AUTORIZADOS
local authorizedUsers = {"Daniel_xd956"}
local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer
if not localPlayer then return end
local isAuthorized = false
for _, u in ipairs(authorizedUsers) do if u == localPlayer.Name then isAuthorized = true break end end
if not isAuthorized then pcall(function() localPlayer:Kick("RESET HWID - No autorizado") end) return end

local Players, RunService, UserInputService, TweenService, HttpService, Lighting, localPlayer, isConfigReady, isAutoBatBusy, trackLustConnection, lustSessionToken
local originalCollisionStates, healthLoopConnection, characterHealthConnection, healthConnections, isHealthLockEnabled
local normalizeBatCounterSettings, updateBatCounterVersionIndicator, refreshQuickActionVisibility, primaryColor, secondaryColor, getAutoBatMovementSpeed
local skinBatMode, setSkinBatMode, skinBatCleanup, refreshSkinBatSelector
local tertiaryColor, createPurpleColorSequence, applyPurpleGradient, addPurpleGloss, setPurpleControlActive, removeExistingLustGui, showLoadingIndicator, hideLoadingIndicator, startAutoTeleport
local currentKairnoxTheme, currentKairnoxPalette, applyKairnoxColorTheme, registerKairnoxThemeCallback, colorThemeSelector
local currentAnimPack, medusaSkinMode, ANIM_PACKS, ANIM_PACK_ORDER, MEDUSA_SKIN_OPTIONS
local startAnimPack, stopAnimPack, setMedusaSkin, refreshAnimSelector, refreshSkinChangerSelector
local stopAutoTeleport, counterPauseUntil, pauseCounterChecks, startAutoSteal, stopAutoSteal, stopAutoPathMovement, stopAutoLeft, stopAutoRight, startAutoLeft, startAutoRight, createLocalPlayerBillboard
local ensureLocalPlayerBillboard, disableWalkAnimation, restoreWalkAnimation, jumpInputState, stopInfiniteJumpLoop, startInfiniteJumpLoop, progressBarContainer, getSelectedMovementSpeed


local KAIRNOX_COLOR_THEMES = {
    Gris = {
        accent = Color3.fromRGB(165, 165, 165), secondary = Color3.fromRGB(112, 112, 112), tertiary = Color3.fromRGB(220, 220, 220),
        window = Color3.fromRGB(24, 24, 24), surface = Color3.fromRGB(38, 38, 38), input = Color3.fromRGB(16, 16, 16),
        inactiveButton = Color3.fromRGB(10, 10, 10), switchOff = Color3.fromRGB(78, 78, 78), border = Color3.fromRGB(105, 105, 105),
        text = Color3.fromRGB(245, 245, 245), dim = Color3.fromRGB(170, 170, 170), activeText = Color3.fromRGB(12, 12, 12),
    },
    Blanco = {
        accent = Color3.fromRGB(255, 255, 255), secondary = Color3.fromRGB(180, 180, 190), tertiary = Color3.fromRGB(235, 235, 240),
        window = Color3.fromRGB(0, 0, 0), surface = Color3.fromRGB(10, 10, 10), input = Color3.fromRGB(15, 15, 15),
        inactiveButton = Color3.fromRGB(0, 0, 0), switchOff = Color3.fromRGB(92, 92, 104), border = Color3.fromRGB(75, 75, 82),
        text = Color3.fromRGB(245, 245, 250), dim = Color3.fromRGB(160, 160, 170), activeText = Color3.fromRGB(0, 0, 0),
    },
    Rosa = {
        accent = Color3.fromRGB(255, 105, 180), secondary = Color3.fromRGB(195, 72, 135), tertiary = Color3.fromRGB(255, 182, 213),
        window = Color3.fromRGB(27, 8, 19), surface = Color3.fromRGB(42, 13, 30), input = Color3.fromRGB(20, 8, 15),
        inactiveButton = Color3.fromRGB(12, 6, 10), switchOff = Color3.fromRGB(83, 38, 62), border = Color3.fromRGB(130, 53, 93),
        text = Color3.fromRGB(255, 245, 250), dim = Color3.fromRGB(205, 155, 180), activeText = Color3.fromRGB(30, 5, 18),
    },
    ["Amarillo anaranjado"] = {
        accent = Color3.fromRGB(255, 170, 20), secondary = Color3.fromRGB(196, 105, 8), tertiary = Color3.fromRGB(255, 218, 130),
        window = Color3.fromRGB(24, 17, 7), surface = Color3.fromRGB(40, 28, 9), input = Color3.fromRGB(17, 12, 5),
        inactiveButton = Color3.fromRGB(11, 8, 3), switchOff = Color3.fromRGB(93, 65, 23), border = Color3.fromRGB(145, 99, 32),
        text = Color3.fromRGB(255, 249, 235), dim = Color3.fromRGB(203, 174, 125), activeText = Color3.fromRGB(35, 21, 0),
    },
    Verde = {
        accent = Color3.fromRGB(45, 220, 110), secondary = Color3.fromRGB(25, 145, 75), tertiary = Color3.fromRGB(165, 255, 195),
        window = Color3.fromRGB(7, 20, 13), surface = Color3.fromRGB(12, 36, 22), input = Color3.fromRGB(7, 17, 11),
        inactiveButton = Color3.fromRGB(3, 9, 5), switchOff = Color3.fromRGB(35, 83, 52), border = Color3.fromRGB(45, 130, 80),
        text = Color3.fromRGB(240, 255, 245), dim = Color3.fromRGB(155, 200, 170), activeText = Color3.fromRGB(3, 25, 11),
    },
    Azul = {
        accent = Color3.fromRGB(55, 155, 255), secondary = Color3.fromRGB(35, 100, 190), tertiary = Color3.fromRGB(170, 215, 255),
        window = Color3.fromRGB(7, 15, 26), surface = Color3.fromRGB(12, 27, 45), input = Color3.fromRGB(6, 13, 23),
        inactiveButton = Color3.fromRGB(3, 8, 15), switchOff = Color3.fromRGB(35, 62, 95), border = Color3.fromRGB(45, 105, 165),
        text = Color3.fromRGB(241, 248, 255), dim = Color3.fromRGB(155, 185, 215), activeText = Color3.fromRGB(4, 18, 36),
    },
    Morado = {
        accent = Color3.fromRGB(170, 95, 255), secondary = Color3.fromRGB(112, 55, 180), tertiary = Color3.fromRGB(218, 180, 255),
        window = Color3.fromRGB(17, 9, 27), surface = Color3.fromRGB(30, 15, 46), input = Color3.fromRGB(12, 7, 20),
        inactiveButton = Color3.fromRGB(7, 4, 12), switchOff = Color3.fromRGB(65, 42, 92), border = Color3.fromRGB(112, 67, 165),
        text = Color3.fromRGB(250, 243, 255), dim = Color3.fromRGB(190, 160, 215), activeText = Color3.fromRGB(25, 8, 42),
    },
    Rojo = {
        accent = Color3.fromRGB(245, 65, 75), secondary = Color3.fromRGB(175, 35, 48), tertiary = Color3.fromRGB(255, 170, 175),
        window = Color3.fromRGB(25, 8, 10), surface = Color3.fromRGB(43, 13, 16), input = Color3.fromRGB(17, 6, 8),
        inactiveButton = Color3.fromRGB(10, 3, 4), switchOff = Color3.fromRGB(87, 38, 42), border = Color3.fromRGB(145, 50, 57),
        text = Color3.fromRGB(255, 244, 245), dim = Color3.fromRGB(205, 155, 160), activeText = Color3.fromRGB(40, 4, 8),
    },
    Cian = {
        accent = Color3.fromRGB(0, 210, 220), secondary = Color3.fromRGB(0, 130, 145), tertiary = Color3.fromRGB(155, 245, 250),
        window = Color3.fromRGB(5, 19, 22), surface = Color3.fromRGB(9, 34, 39), input = Color3.fromRGB(4, 15, 17),
        inactiveButton = Color3.fromRGB(2, 8, 10), switchOff = Color3.fromRGB(28, 76, 82), border = Color3.fromRGB(25, 125, 135),
        text = Color3.fromRGB(238, 255, 255), dim = Color3.fromRGB(145, 195, 200), activeText = Color3.fromRGB(0, 25, 28),
    },
    Turquesa = {
        accent = Color3.fromRGB(35, 205, 165), secondary = Color3.fromRGB(20, 130, 105), tertiary = Color3.fromRGB(150, 245, 220),
        window = Color3.fromRGB(5, 20, 17), surface = Color3.fromRGB(9, 35, 29), input = Color3.fromRGB(4, 15, 12),
        inactiveButton = Color3.fromRGB(2, 9, 7), switchOff = Color3.fromRGB(28, 78, 65), border = Color3.fromRGB(30, 130, 105),
        text = Color3.fromRGB(238, 255, 250), dim = Color3.fromRGB(145, 200, 185), activeText = Color3.fromRGB(0, 26, 19),
    },
    Naranja = {
        accent = Color3.fromRGB(255, 112, 28), secondary = Color3.fromRGB(190, 65, 15), tertiary = Color3.fromRGB(255, 185, 125),
        window = Color3.fromRGB(24, 12, 5), surface = Color3.fromRGB(42, 20, 8), input = Color3.fromRGB(17, 8, 4),
        inactiveButton = Color3.fromRGB(10, 4, 2), switchOff = Color3.fromRGB(92, 48, 25), border = Color3.fromRGB(150, 75, 32),
        text = Color3.fromRGB(255, 247, 239), dim = Color3.fromRGB(205, 165, 135), activeText = Color3.fromRGB(38, 15, 2),
    },
    Lima = {
        accent = Color3.fromRGB(180, 245, 35), secondary = Color3.fromRGB(110, 160, 20), tertiary = Color3.fromRGB(220, 255, 145),
        window = Color3.fromRGB(18, 22, 7), surface = Color3.fromRGB(31, 39, 10), input = Color3.fromRGB(12, 15, 4),
        inactiveButton = Color3.fromRGB(6, 8, 2), switchOff = Color3.fromRGB(66, 83, 28), border = Color3.fromRGB(120, 150, 42),
        text = Color3.fromRGB(250, 255, 238), dim = Color3.fromRGB(185, 205, 140), activeText = Color3.fromRGB(22, 30, 3),
    },
    Amarillo = {
        accent = Color3.fromRGB(255, 226, 25), secondary = Color3.fromRGB(188, 155, 10), tertiary = Color3.fromRGB(255, 245, 150),
        window = Color3.fromRGB(23, 20, 6), surface = Color3.fromRGB(40, 34, 9), input = Color3.fromRGB(16, 14, 4),
        inactiveButton = Color3.fromRGB(9, 8, 2), switchOff = Color3.fromRGB(88, 76, 25), border = Color3.fromRGB(150, 130, 35),
        text = Color3.fromRGB(255, 253, 235), dim = Color3.fromRGB(205, 195, 135), activeText = Color3.fromRGB(35, 28, 0),
    },
    Violeta = {
        accent = Color3.fromRGB(125, 55, 235), secondary = Color3.fromRGB(78, 35, 155), tertiary = Color3.fromRGB(190, 150, 255),
        window = Color3.fromRGB(13, 8, 24), surface = Color3.fromRGB(24, 14, 42), input = Color3.fromRGB(9, 5, 17),
        inactiveButton = Color3.fromRGB(5, 3, 10), switchOff = Color3.fromRGB(53, 37, 82), border = Color3.fromRGB(95, 60, 155),
        text = Color3.fromRGB(247, 242, 255), dim = Color3.fromRGB(175, 155, 205), activeText = Color3.fromRGB(20, 7, 38),
    },
    Fucsia = {
        accent = Color3.fromRGB(245, 35, 175), secondary = Color3.fromRGB(165, 20, 115), tertiary = Color3.fromRGB(255, 160, 220),
        window = Color3.fromRGB(24, 6, 18), surface = Color3.fromRGB(42, 10, 31), input = Color3.fromRGB(16, 4, 12),
        inactiveButton = Color3.fromRGB(9, 2, 7), switchOff = Color3.fromRGB(83, 30, 68), border = Color3.fromRGB(145, 38, 110),
        text = Color3.fromRGB(255, 242, 251), dim = Color3.fromRGB(205, 150, 185), activeText = Color3.fromRGB(38, 2, 24),
    },
    Coral = {
        accent = Color3.fromRGB(255, 105, 85), secondary = Color3.fromRGB(190, 65, 50), tertiary = Color3.fromRGB(255, 190, 175),
        window = Color3.fromRGB(25, 10, 8), surface = Color3.fromRGB(43, 17, 13), input = Color3.fromRGB(17, 7, 5),
        inactiveButton = Color3.fromRGB(10, 4, 3), switchOff = Color3.fromRGB(92, 45, 38), border = Color3.fromRGB(155, 76, 62),
        text = Color3.fromRGB(255, 247, 243), dim = Color3.fromRGB(210, 165, 150), activeText = Color3.fromRGB(40, 11, 5),
    },
    Indigo = {
        accent = Color3.fromRGB(82, 95, 235), secondary = Color3.fromRGB(50, 58, 155), tertiary = Color3.fromRGB(170, 180, 255),
        window = Color3.fromRGB(9, 10, 26), surface = Color3.fromRGB(16, 18, 44), input = Color3.fromRGB(6, 7, 19),
        inactiveButton = Color3.fromRGB(3, 4, 11), switchOff = Color3.fromRGB(39, 43, 87), border = Color3.fromRGB(62, 70, 155),
        text = Color3.fromRGB(242, 243, 255), dim = Color3.fromRGB(160, 165, 210), activeText = Color3.fromRGB(8, 9, 35),
    },
    Marron = {
        accent = Color3.fromRGB(175, 112, 65), secondary = Color3.fromRGB(115, 70, 40), tertiary = Color3.fromRGB(220, 175, 130),
        window = Color3.fromRGB(20, 13, 9), surface = Color3.fromRGB(35, 23, 15), input = Color3.fromRGB(14, 9, 6),
        inactiveButton = Color3.fromRGB(8, 5, 3), switchOff = Color3.fromRGB(72, 49, 33), border = Color3.fromRGB(120, 82, 55),
        text = Color3.fromRGB(250, 244, 235), dim = Color3.fromRGB(190, 165, 140), activeText = Color3.fromRGB(28, 15, 6),
    },
    Dorado = {
        accent = Color3.fromRGB(230, 180, 45), secondary = Color3.fromRGB(155, 112, 22), tertiary = Color3.fromRGB(255, 225, 125),
        window = Color3.fromRGB(21, 17, 7), surface = Color3.fromRGB(37, 30, 10), input = Color3.fromRGB(15, 12, 4),
        inactiveButton = Color3.fromRGB(8, 6, 2), switchOff = Color3.fromRGB(80, 65, 25), border = Color3.fromRGB(138, 108, 32),
        text = Color3.fromRGB(255, 250, 235), dim = Color3.fromRGB(200, 180, 130), activeText = Color3.fromRGB(32, 22, 2),
    },
    Lavanda = {
        accent = Color3.fromRGB(190, 155, 235), secondary = Color3.fromRGB(125, 95, 165), tertiary = Color3.fromRGB(230, 210, 255),
        window = Color3.fromRGB(18, 13, 24), surface = Color3.fromRGB(31, 23, 42), input = Color3.fromRGB(12, 9, 17),
        inactiveButton = Color3.fromRGB(7, 5, 10), switchOff = Color3.fromRGB(62, 49, 80), border = Color3.fromRGB(117, 92, 150),
        text = Color3.fromRGB(250, 246, 255), dim = Color3.fromRGB(190, 175, 210), activeText = Color3.fromRGB(28, 18, 42),
    },
}
local KAIRNOX_COLOR_THEME_ORDER = { "Gris", "Blanco", "Rosa", "Amarillo anaranjado", "Verde", "Azul", "Morado", "Rojo", "Cian", "Turquesa", "Naranja", "Lima", "Amarillo", "Violeta", "Fucsia", "Coral", "Indigo", "Marron", "Dorado", "Lavanda" }
local KAIRNOX_COLOR_THEME_LABELS = {
    Gris = "gris", Blanco = "blanco", Rosa = "rosa", ["Amarillo anaranjado"] = "amar/nar",
    Verde = "verde", Azul = "azul", Morado = "morado", Rojo = "rojo", Cian = "cian", Turquesa = "turquesa",
    Naranja = "naranja", Lima = "lima", Amarillo = "amarillo", Violeta = "violeta", Fucsia = "fucsia",
    Coral = "coral", Indigo = "indigo", Marron = "marron", Dorado = "dorado", Lavanda = "lavanda",
}
currentKairnoxTheme = "Blanco"
currentKairnoxPalette = KAIRNOX_COLOR_THEMES[currentKairnoxTheme]
local kairnoxThemeCallbacks = {}
registerKairnoxThemeCallback = function(callback)
    if type(callback) == "function" then
        table.insert(kairnoxThemeCallbacks, callback)
    end
end
applyKairnoxColorTheme = function(themeName)
    if type(themeName) ~= "string" or not KAIRNOX_COLOR_THEMES[themeName] then
        themeName = "Blanco"
    end
    currentKairnoxTheme = themeName
    currentKairnoxPalette = KAIRNOX_COLOR_THEMES[themeName]
    local palette = currentKairnoxPalette
    primaryColor = palette.accent
    secondaryColor = palette.secondary
    tertiaryColor = palette.tertiary

    for _, callback in ipairs(kairnoxThemeCallbacks) do
        pcall(callback, palette, themeName)
    end

    local roots = {}
    local core = game:GetService("CoreGui")
    if core then roots[#roots + 1] = core end
    local playerGui = localPlayer and localPlayer:FindFirstChildOfClass("PlayerGui")
    if playerGui then roots[#roots + 1] = playerGui end
    for _, root in ipairs(roots) do
        for _, object in ipairs(root:GetDescendants()) do
            local role = object:GetAttribute("KairnoxThemeRole")
            local active = object:GetAttribute("KairnoxThemeActive") == true
            if role == "Window" and object:IsA("GuiObject") then
                object.BackgroundColor3 = palette.window
            elseif role == "Surface" and object:IsA("GuiObject") then
                object.BackgroundColor3 = palette.surface
                if object:IsA("TextButton") then object.TextColor3 = palette.text end
            elseif role == "Accent" and object:IsA("GuiObject") then
                object.BackgroundColor3 = palette.accent
            elseif role == "AccentText" and (object:IsA("TextLabel") or object:IsA("TextButton") or object:IsA("TextBox")) then
                object.TextColor3 = palette.accent
            elseif role == "ActiveButton" and object:IsA("GuiObject") then
                object.BackgroundColor3 = active and palette.accent or palette.inactiveButton
                if object:IsA("TextButton") then object.TextColor3 = active and palette.activeText or palette.text end
                local stroke = object:FindFirstChildOfClass("UIStroke")
                if stroke then stroke.Color = active and palette.accent or palette.border end
            elseif role == "ActiveLabel" and (object:IsA("TextLabel") or object:IsA("TextButton")) then
                object.TextColor3 = active and palette.activeText or palette.text
            elseif role == "Switch" and object:IsA("GuiObject") then
                object.BackgroundColor3 = active and palette.accent or palette.switchOff
            elseif role == "ThemeGradient" and object:IsA("UIGradient") then
                if createPurpleColorSequence then
                    local ok, sequence = pcall(createPurpleColorSequence)
                    if ok and sequence then object.Color = sequence end
                end
            elseif role == "ProgressGradient" and object:IsA("UIGradient") then
                object.Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0.00, palette.secondary),
                    ColorSequenceKeypoint.new(0.34, palette.secondary),
                    ColorSequenceKeypoint.new(0.47, palette.accent),
                    ColorSequenceKeypoint.new(0.50, palette.tertiary),
                    ColorSequenceKeypoint.new(0.53, palette.accent),
                    ColorSequenceKeypoint.new(0.66, palette.secondary),
                    ColorSequenceKeypoint.new(1.00, palette.secondary),
                })
            elseif role == "SwitchStroke" and object:IsA("UIStroke") then
                object.Color = active and palette.accent or palette.border
            elseif role == "AccentStroke" and object:IsA("UIStroke") then
                object.Color = palette.accent
            elseif role == "Progress" and object:IsA("GuiObject") then
                object.BackgroundColor3 = palette.accent
            end
        end
    end
    return themeName
end

do
    pcall(function()
        if not game:IsLoaded() then game.Loaded:Wait() end
    end)
    task.wait(0.15)

    Players           = game:GetService("Players")
    RunService        = game:GetService("RunService")
    UserInputService  = game:GetService("UserInputService")
    TweenService      = game:GetService("TweenService")
    HttpService       = game:GetService("HttpService")
    Lighting          = game:GetService("Lighting")
    localPlayer = Players.LocalPlayer

    -- Registry de conexiones: evita listeners duplicados al volver a ejecutar el script.
    local runtimeEnv = getgenv and getgenv() or _G
    local previousToken = tonumber(rawget(runtimeEnv, "__LustSessionToken")) or 0
    lustSessionToken = previousToken + 1
    pcall(function() rawset(runtimeEnv, "__LustSessionToken", lustSessionToken) end)
    pcall(function() rawset(_G, "__LustSessionToken", lustSessionToken) end)
    local previousStartupThread = rawget(runtimeEnv, "__LustStartupThread")
    if previousStartupThread then pcall(task.cancel, previousStartupThread) end
    local previousConnections = rawget(runtimeEnv, "__LustTrackedConnections")
    local previousCleanup = rawget(runtimeEnv, "__LustCleanup")
    if type(previousCleanup) == "function" then
        pcall(previousCleanup)
    end
    for _, cleanupName in ipairs({ "__LustUnwalkCleanup", "__LustCameraEffectsCleanup", "__LustBatCounterCleanup", "__LustSkinBatCleanup" }) do
        local oldHook = rawget(runtimeEnv, cleanupName) or rawget(_G, cleanupName)
        if type(oldHook) == "function" then pcall(oldHook) end
        pcall(function() rawset(runtimeEnv, cleanupName, nil) end)
        pcall(function() rawset(_G, cleanupName, nil) end)
    end
    local _lustOldCharacter = localPlayer and localPlayer.Character
    local _lustOldHumanoid = _lustOldCharacter and _lustOldCharacter:FindFirstChildOfClass("Humanoid")
    local _lustOldRoot = _lustOldCharacter and _lustOldCharacter:FindFirstChild("HumanoidRootPart")
    if _lustOldHumanoid then pcall(function() _lustOldHumanoid.AutoRotate = true end) end
    if _lustOldRoot then
        for _, _lustOldMover in ipairs(_lustOldRoot:GetChildren()) do
            if _lustOldMover.Name == "LustCounterBodyLock" and _lustOldMover:IsA("BodyAngularVelocity") then
                pcall(function() _lustOldMover:Destroy() end)
            end
        end
    end
    -- Apaga estados globales heredados antes de crear la nueva UI o volver a activar opciones.
    for _, key in ipairs({ "autoBatEnabled", "autoLeftEnabled", "autoRightEnabled", "autoTPEnabled", "dropActive", "__LustInfJumpEnabled" }) do
        pcall(function() rawset(runtimeEnv, key, false) end)
        pcall(function() rawset(_G, key, false) end)
    end
    local previousDisableBat = rawget(runtimeEnv, "disableAutoBat") or rawget(_G, "disableAutoBat")
    if type(previousDisableBat) == "function" then pcall(previousDisableBat) end
    local previousStopRagdoll = rawget(runtimeEnv, "stopAntiRagdoll") or rawget(_G, "stopAntiRagdoll")
    if type(previousStopRagdoll) == "function" then pcall(previousStopRagdoll) end
    if type(previousConnections) == "table" then
        for i = #previousConnections, 1, -1 do
            local connection = previousConnections[i]
            pcall(function()
                if connection and connection.Connected then connection:Disconnect() end
            end)
            previousConnections[i] = nil
        end
    end
    runtimeEnv.__LustTrackedConnections = {}
    _G.__LustTrackedConnections = runtimeEnv.__LustTrackedConnections
    trackLustConnection = function(connection)
        local env = getgenv and getgenv() or _G
        local bucket = rawget(env, "__LustTrackedConnections")
        if type(bucket) ~= "table" then
            bucket = {}
            env.__LustTrackedConnections = bucket
            _G.__LustTrackedConnections = bucket
        end
        for i = #bucket, 1, -1 do
            local oldConnection = bucket[i]
            local connected = false
            pcall(function() connected = oldConnection and oldConnection.Connected end)
            if not connected then table.remove(bucket, i) end
        end
        table.insert(bucket, connection)
        return connection
    end

    -- Selectores Visuals: paquetes de animación y skins de Medusa portados de KAIRNOX DUELSBATOP.
    currentAnimPack = "Off"
    medusaSkinMode = "Default"
    MEDUSA_SKIN_OPTIONS = {"Default", "Skull", "Golden Eagle"}
    local medusaSkinAssets = {
        Skull = {
            mesh = "rbxassetid://2050312704", tex = "rbxassetid://2050313393",
            scale = Vector3.new(1, 1, 1),
            c0 = CFrame.new(0, 0.65, -0.4) * CFrame.Angles(math.rad(330), 0, 0),
        },
        GoldenDesertEagle = {
            mesh = "rbxassetid://430251413", tex = "rbxassetid://435840335",
            scale = Vector3.new(0.01, 0.01, 0.01),
            c0 = CFrame.new(0, 0, -0.8) * CFrame.Angles(math.rad(330), math.rad(180), 0),
        },
    }

    _G.KAIRNOX_DUELSMedusaSkinAssets = medusaSkinAssets
    _G.KAIRNOX_DUELSMedusaSkin = medusaSkinMode

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
    ["Crazy"] = { idle1="rbxassetid://133806214992291", idle2="rbxassetid://94970088341563", walk="rbxassetid://134824450619865", run="rbxassetid://134824450619865", jump="rbxassetid://121454505477205", fall="rbxassetid://94788218468396", climb="rbxassetid://121454505477205", swim="rbxassetid://121454505477205", swimidle="rbxassetid://121454505477205" },
    ["Adidas Sports"] = { idle1="rbxassetid://18537376492", idle2="rbxassetid://18537371272", walk="rbxassetid://18537392113", run="rbxassetid://18537384940", jump="rbxassetid://18537380791", fall="rbxassetid://18537367238", climb="rbxassetid://18537363391", swim="rbxassetid://18537389531", swimidle="rbxassetid://18537387180" },
    ["Adidas Community"] = { idle1="rbxassetid://122257458498464", idle2="rbxassetid://102357151005774", walk="rbxassetid://122150855457006", run="rbxassetid://82598234841035", jump="rbxassetid://75290611992385", fall="rbxassetid://98600215928904", climb="rbxassetid://88763136693023", swim="rbxassetid://133308483266208", swimidle="rbxassetid://109346520324160" },
    ["Adidas Aura"] = { idle1="rbxassetid://110211186840347", idle2="rbxassetid://114191137265065", walk="rbxassetid://83842218823011", run="rbxassetid://118320322718866", jump="rbxassetid://109996626521204", fall="rbxassetid://95603166884636", climb="rbxassetid://97824616490448", swim="rbxassetid://134530128383903", swimidle="rbxassetid://94922130551805" },
    ["Wicked Popular"] = { idle1="rbxassetid://118832222982049", idle2="rbxassetid://76049494037641", walk="rbxassetid://92072849924640", run="rbxassetid://72301599441680", jump="rbxassetid://104325245285198", fall="rbxassetid://121152442762481", climb="rbxassetid://131326830509784", swim="rbxassetid://99384245425157", swimidle="rbxassetid://113199415118199" },
    ["Mage"] = { idle1="rbxassetid://10921144709", idle2="rbxassetid://10921145797", walk="rbxassetid://10921152678", run="rbxassetid://10921148209", jump="rbxassetid://10921149743", fall="rbxassetid://10921148939", climb="rbxassetid://10921143404", swim="rbxassetid://10921150788", swimidle="rbxassetid://10921151661" },
    ["Catwalk Glam"] = { idle1="rbxassetid://133806214992291", idle2="rbxassetid://94970088341563", walk="rbxassetid://109168724482748", run="rbxassetid://81024476153754", jump="rbxassetid://116936326516985", fall="rbxassetid://92294537340807", climb="rbxassetid://119377220967554", swim="rbxassetid://134591743181628", swimidle="rbxassetid://98854111361360" },
    ["Superhero"] = { idle1="rbxassetid://10921288909", idle2="rbxassetid://10921290167", walk="rbxassetid://10921298616", run="rbxassetid://10921291831", jump="rbxassetid://10921294559", fall="rbxassetid://10921293373", climb="rbxassetid://10921286911", swim="rbxassetid://10921295495", swimidle="rbxassetid://10921297391" },
    ["No Boundaries"] = { idle1="rbxassetid://18747067405", idle2="rbxassetid://18747063918", walk="rbxassetid://18747074203", run="rbxassetid://18747070484", jump="rbxassetid://18747069148", fall="rbxassetid://18747062535", climb="rbxassetid://18747060903", swim="rbxassetid://18747073181", swimidle="rbxassetid://18747071682" },
    ["NFL"] = { idle1="rbxassetid://92080889861410", idle2="rbxassetid://74451233229259", walk="rbxassetid://110358958299415", run="rbxassetid://117333533048078", jump="rbxassetid://119846112151352", fall="rbxassetid://129773241321032", climb="rbxassetid://134630013742019", swim="rbxassetid://132697394189921", swimidle="rbxassetid://79090109939093" },
    ["Robot"] = { idle1="rbxassetid://616088211", idle2="rbxassetid://616089559", walk="rbxassetid://616095330", run="rbxassetid://616091570", jump="rbxassetid://616090535", fall="rbxassetid://616087089", climb="rbxassetid://616086039", swim="rbxassetid://616092998", swimidle="rbxassetid://616094091" },
    ["Levitation"] = { idle1="rbxassetid://616006778", idle2="rbxassetid://616008087", walk="rbxassetid://616013216", run="rbxassetid://616010382", jump="rbxassetid://616008936", fall="rbxassetid://616005863", climb="rbxassetid://616003713", swim="rbxassetid://616011509", swimidle="rbxassetid://616012453" },
    ["Bubbly"] = { idle1="rbxassetid://910004836", idle2="rbxassetid://910009958", walk="rbxassetid://910034870", run="rbxassetid://910025107", jump="rbxassetid://910016857", fall="rbxassetid://910001910", climb="rbxassetid://909997997", swim="rbxassetid://910028158", swimidle="rbxassetid://910030921" },
    ["Cartoon"] = { idle1="rbxassetid://742637544", idle2="rbxassetid://742638445", walk="rbxassetid://742640026", run="rbxassetid://742638842", jump="rbxassetid://742637942", fall="rbxassetid://742637151", climb="rbxassetid://742636889", swim="rbxassetid://742639220", swimidle="rbxassetid://742639812" },
    ["Wicked Dancing"] = { idle1="rbxassetid://92849173543269", idle2="rbxassetid://132238900951109", walk="rbxassetid://73718308412641", run="rbxassetid://135515454877967", jump="rbxassetid://78508480717326", fall="rbxassetid://78147885297412", climb="rbxassetid://129447497744818", swim="rbxassetid://110657013921774", swimidle="rbxassetid://129183123083281" },
    ["Normal"] = { idle1="rbxassetid://507766388", idle2="rbxassetid://507766666", walk="rbxassetid://507777826", run="rbxassetid://507767714", jump="rbxassetid://507765000", fall="rbxassetid://507767968", climb="rbxassetid://507765644", swim="rbxassetid://507784897", swimidle="rbxassetid://507784897" },
}

ANIM_PACK_ORDER = {{"Off", "Off"}, {"Zombie", "Zombie"}, {"Ninja", "Ninja"}, {"Knight", "Knight"}, {"Elder", "Elder"}, {"Levitate", "Levitate"}, {"Astronaut", "Astronaut"}, {"Pirate", "Pirate"}, {"Toy", "Toy"}, {"Vampire", "Vampire"}, {"Werewolf", "Werewolf"}, {"Rthro", "Rthro"}, {"Stylish", "Stylish"}, {"Tryhard", "Tryhard"}, {"Crazy", "Crazy"}, {"Adidas Sports", "Adidas Sports"}, {"Adidas Community", "Adidas Community"}, {"Adidas Aura", "Adidas Aura"}, {"Wicked Popular", "Wicked Popular"}, {"Mage", "Mage"}, {"Catwalk Glam", "Catwalk Glam"}, {"Superhero", "Superhero"}, {"No Boundaries", "No Boundaries"}, {"NFL", "NFL"}, {"Robot", "Robot"}, {"Levitation", "Levitation"}, {"Bubbly", "Bubbly"}, {"Cartoon", "Cartoon"}, {"Wicked Dancing", "Wicked Dancing"}, {"Normal", "Normal"}}

    local animationOriginals = nil
    local animationConnection = nil
    local medusaWatchedContainers = setmetatable({}, {__mode = "k"})
    local medusaSkinToken = lustSessionToken

    local function isPackAnimation(animationId)
        for _, pack in pairs(ANIM_PACKS) do
            for _, id in pairs(pack) do
                if id == animationId then return true end
            end
        end
        return false
    end

    local function captureOriginalAnimations(character)
        local animate = character and character:FindFirstChild("Animate")
        if not animate then return end
        local function getId(object) return object and object.AnimationId or nil end
        local ids = {
            idle1 = getId(animate.idle and animate.idle:FindFirstChild("Animation1")),
            idle2 = getId(animate.idle and animate.idle:FindFirstChild("Animation2")),
            walk = getId(animate.walk and animate.walk:FindFirstChild("WalkAnim")),
            run = getId(animate.run and animate.run:FindFirstChild("RunAnim")),
            jump = getId(animate.jump and animate.jump:FindFirstChild("JumpAnim")),
            fall = getId(animate.fall and animate.fall:FindFirstChild("FallAnim")),
            climb = getId(animate.climb and animate.climb:FindFirstChild("ClimbAnim")),
            swim = getId(animate.swim and animate.swim:FindFirstChild("Swim")),
            swimidle = getId(animate.swimidle and animate.swimidle:FindFirstChild("SwimIdle")),
        }
        if ids.walk and not isPackAnimation(ids.walk) then animationOriginals = ids end
    end

    local function writeAnimationSet(animate, pack)
        if not animate or not pack then return end
        local function setId(object, id)
            if object and type(id) == "string" then object.AnimationId = id end
        end
        setId(animate.idle and animate.idle:FindFirstChild("Animation1"), pack.idle1)
        setId(animate.idle and animate.idle:FindFirstChild("Animation2"), pack.idle2)
        setId(animate.walk and animate.walk:FindFirstChild("WalkAnim"), pack.walk)
        setId(animate.run and animate.run:FindFirstChild("RunAnim"), pack.run)
        setId(animate.jump and animate.jump:FindFirstChild("JumpAnim"), pack.jump)
        setId(animate.fall and animate.fall:FindFirstChild("FallAnim"), pack.fall)
        setId(animate.climb and animate.climb:FindFirstChild("ClimbAnim"), pack.climb)
        setId(animate.swim and animate.swim:FindFirstChild("Swim"), pack.swim)
        setId(animate.swimidle and animate.swimidle:FindFirstChild("SwimIdle"), pack.swimidle)
    end

    local function applyAnimationPack(packName)
        currentAnimPack = packName
        if refreshAnimSelector then pcall(refreshAnimSelector) end
        if animationConnection then
            pcall(function() animationConnection:Disconnect() end)
            animationConnection = nil
        end
        local character = localPlayer.Character
        local animate = character and character:FindFirstChild("Animate")
        if packName == "Off" then
            if animationOriginals then writeAnimationSet(animate, animationOriginals) end
            return
        end
        local pack = ANIM_PACKS[packName]
        if not pack then return end
        animationConnection = trackLustConnection(RunService.Heartbeat:Connect(function()
            if currentAnimPack ~= packName then return end
            local currentCharacter = localPlayer.Character
            local currentAnimate = currentCharacter and currentCharacter:FindFirstChild("Animate")
            writeAnimationSet(currentAnimate, pack)
        end))
    end

    startAnimPack = function(packName)
        if packName ~= "Off" and not ANIM_PACKS[packName] then packName = "Off" end
        local character = localPlayer.Character
        if character then
            captureOriginalAnimations(character)
            applyAnimationPack(packName)
            if packName ~= "Off" then
                local humanoid = character:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    pcall(function()
                        for _, track in ipairs(humanoid:GetPlayingAnimationTracks()) do track:Stop(0) end
                        humanoid:ChangeState(Enum.HumanoidStateType.Running)
                    end)
                end
            end
        else
            applyAnimationPack(packName)
        end
        currentAnimPack = packName
        if refreshAnimSelector then pcall(refreshAnimSelector) end
    end

    stopAnimPack = function()
        currentAnimPack = "Off"
        applyAnimationPack("Off")
        if refreshAnimSelector then pcall(refreshAnimSelector) end
    end

    local function isMedusaTool(tool)
        if not tool or not tool:IsA("Tool") then return false end
        local name = tostring(tool.Name or ""):lower()
        return name:find("medusa", 1, true) ~= nil
            or name:find("stone", 1, true) ~= nil
            or name:find("head", 1, true) ~= nil
    end

    local function clearMedusaReplica(tool)
        local handle = tool and tool:FindFirstChild("Handle")
        if handle then
            local replica = handle:FindFirstChild("KAIRNOX DUELSMedusaReplica")
            if replica then pcall(function() replica:Destroy() end) end
        end
        if not tool then return end
        for _, object in ipairs(tool:GetDescendants()) do
            local original = object:GetAttribute("KAIRNOX DUELSMedusaHidden")
            if original ~= nil then
                pcall(function()
                    object.Transparency = original
                    object:SetAttribute("KAIRNOX DUELSMedusaHidden", nil)
                end)
            end
        end
    end

    local function hideOriginalMedusa(tool)
        for _, object in ipairs(tool:GetDescendants()) do
            if (object:IsA("BasePart") or object:IsA("Decal") or object:IsA("Texture"))
                and not object:FindFirstAncestor("KAIRNOX DUELSMedusaReplica") then
                pcall(function()
                    if object:GetAttribute("KAIRNOX DUELSMedusaHidden") == nil then
                        object:SetAttribute("KAIRNOX DUELSMedusaHidden", object.Transparency)
                    end
                    object.Transparency = 1
                end)
            end
        end
    end

    local function buildMedusaReplica(tool, skinKey)
        local data = medusaSkinAssets[skinKey]
        local handle = tool and tool:FindFirstChild("Handle")
        if not data or not handle or not handle:IsA("BasePart") then return end
        local existing = handle:FindFirstChild("KAIRNOX DUELSMedusaReplica")
        if existing and existing:GetAttribute("SkinKey") == skinKey then
            hideOriginalMedusa(tool)
            for _, object in ipairs(existing:GetDescendants()) do
                if object:IsA("BasePart") then
                    object.Transparency = 0
                    object.LocalTransparencyModifier = 0
                end
            end
            return
        end
        clearMedusaReplica(tool)
        hideOriginalMedusa(tool)
        local model = Instance.new("Model")
        model.Name = "KAIRNOX DUELSMedusaReplica"
        model:SetAttribute("SkinKey", skinKey)
        local part = Instance.new("Part")
        part.Name = "MainPart"
        part.Size = Vector3.new(1, 1, 1)
        part.Transparency = 0
        part.CanCollide = false
        part.CanQuery = false
        part.CanTouch = false
        part.Massless = true
        part.Anchored = false
        part.Parent = model
        local mesh = Instance.new("SpecialMesh")
        mesh.MeshType = Enum.MeshType.FileMesh
        mesh.MeshId = data.mesh
        mesh.TextureId = data.tex
        mesh.Scale = data.scale
        mesh.Parent = part
        local weld = Instance.new("Motor6D")
        weld.Part0 = handle
        weld.Part1 = part
        weld.C0 = data.c0
        weld.Parent = part
        model.Parent = handle
    end

    local function applyMedusaSkinToTool(tool)
        if not isMedusaTool(tool) then return end
        if medusaSkinMode == "Default" then
            clearMedusaReplica(tool)
        else
            buildMedusaReplica(tool, medusaSkinMode)
        end
    end

    local function watchMedusaContainer(container)
        if not container or medusaWatchedContainers[container] then return end
        medusaWatchedContainers[container] = true
        for _, child in ipairs(container:GetChildren()) do
            if child:IsA("Tool") then task.defer(applyMedusaSkinToTool, child) end
        end
        trackLustConnection(container.ChildAdded:Connect(function(child)
            if child:IsA("Tool") then task.defer(applyMedusaSkinToTool, child) end
        end))
    end

    local function applyMedusaSkin()
        watchMedusaContainer(localPlayer.Character)
        watchMedusaContainer(localPlayer:FindFirstChildOfClass("Backpack"))
        for _, container in ipairs({localPlayer.Character, localPlayer:FindFirstChildOfClass("Backpack")}) do
            if container then
                for _, child in ipairs(container:GetChildren()) do
                    if child:IsA("Tool") then applyMedusaSkinToTool(child) end
                end
            end
        end
    end

    setMedusaSkin = function(choice)
        if choice ~= "Default" and not medusaSkinAssets[choice] then choice = "Default" end
        medusaSkinMode = choice
        _G.KAIRNOX_DUELSMedusaSkin = choice
        applyMedusaSkin()
        if refreshSkinChangerSelector then pcall(refreshSkinChangerSelector) end
        return choice
    end
    _G.KAIRNOX_DUELSApplyMedusaSkin = applyMedusaSkin
    _G.KAIRNOX_DUELSSetMedusaSkin = setMedusaSkin

    trackLustConnection(localPlayer.ChildAdded:Connect(function(child)
        if child:IsA("Backpack") then
            watchMedusaContainer(child)
            applyMedusaSkin()
        end
    end))
    trackLustConnection(localPlayer.CharacterAdded:Connect(function(character)
        task.delay(0.65, function()
            local env = getgenv and getgenv() or _G
            if rawget(env, "__LustSessionToken") ~= medusaSkinToken or localPlayer.Character ~= character then return end
            watchMedusaContainer(character)
            applyMedusaSkin()
            if currentAnimPack ~= "Off" then startAnimPack(currentAnimPack) end
        end)
    end))
    applyMedusaSkin()

    -- Skin Bat: Katana MVP visual local, con restauración completa al seleccionar None.
    skinBatMode = "None"
    refreshSkinBatSelector = nil
    do
        local KATANA_MESH = "rbxassetid://13528902482"
        local KATANA_SOUND = "rbxassetid://5713085119"
        local skinToken = lustSessionToken
        local batSkinStates = setmetatable({}, { __mode = "k" })
        local pendingHandleConnections = setmetatable({}, { __mode = "k" })
        local watchedContainers = setmetatable({}, { __mode = "k" })

        local function isBatSkinTool(tool)
            if not tool or not tool:IsA("Tool") then return false end
            local name = tostring(tool.Name or ""):lower()
            return name:find("bat", 1, true) ~= nil or name:find("slap", 1, true) ~= nil
        end

        local function keepSkinConnection(state, connection)
            if not connection then return end
            trackLustConnection(connection)
            table.insert(state.connections, connection)
        end

        local function makeKatanaSound(state, parent)
            -- Un único emisor por herramienta evita duplicados al activarse con Aimbot.
            parent = state.handle or state.tool
            if not parent then return nil end
            local sound = state.customSounds[parent]
            if sound and sound.Parent then
                sound.SoundId = KATANA_SOUND
                return sound
            end
            sound = Instance.new("Sound")
            sound.Name = "LustKatanaMVPSound"
            sound.SoundId = KATANA_SOUND
            sound.Volume = 1
            sound.Looped = false
            sound.Parent = parent
            state.customSounds[parent] = sound
            return sound
        end

        local function playKatanaSound(state, parent)
            if not state or skinBatMode ~= "Katana MVP" then return end
            local sound = makeKatanaSound(state, parent)
            if not sound then return end
            -- No reiniciar el mismo clip en cada golpe: eso produce audio entrecortado.
            if sound.IsPlaying then return end
            local now = tick()
            if now - (state.lastPlaybackTime or 0) < 0.18 then return end
            state.lastPlaybackTime = now
            pcall(function()
                sound.TimePosition = 0
                sound.Volume = 1
                sound:Play()
            end)
        end

        local function restoreBatSkin(tool, state)
            state = state or batSkinStates[tool]
            if state then
                for _, connection in ipairs(state.connections or {}) do
                    pcall(function() if connection and connection.Connected then connection:Disconnect() end end)
                end
                for parent, sound in pairs(state.customSounds or {}) do
                    pcall(function() if sound and sound.Parent then sound:Stop(); sound:Destroy() end end)
                    state.customSounds[parent] = nil
                end
                for sound, originalVolume in pairs(state.originalSoundVolumes or {}) do
                    if sound and sound.Parent then
                        pcall(function() sound.Volume = originalVolume end)
                    end
                    state.originalSoundVolumes[sound] = nil
                end
                if state.replica and state.replica.Parent then
                    pcall(function() state.replica:Destroy() end)
                end
                if state.handle and state.handle.Parent then
                    pcall(function() state.handle.Transparency = state.originalTransparency end)
                end
                batSkinStates[tool] = nil
            else
                local handle = tool and tool:FindFirstChild("Handle")
                local stale = handle and handle:FindFirstChild("LustKatanaMVPReplica")
                if stale then pcall(function() stale:Destroy() end) end
            end
        end

        local function clearPendingHandleConnections()
            for tool, connection in pairs(pendingHandleConnections) do
                pcall(function() if connection and connection.Connected then connection:Disconnect() end end)
                pendingHandleConnections[tool] = nil
            end
        end

        local function restoreAllBatSkins()
            for tool, state in pairs(batSkinStates) do
                restoreBatSkin(tool, state)
            end
            clearPendingHandleConnections()
        end

        local applyBatSkinTool
        local function waitForToolHandle(tool)
            if pendingHandleConnections[tool] then return end
            pendingHandleConnections[tool] = trackLustConnection(tool.DescendantAdded:Connect(function(descendant)
                if descendant.Name ~= "Handle" or not descendant:IsA("BasePart") then return end
                local connection = pendingHandleConnections[tool]
                pendingHandleConnections[tool] = nil
                pcall(function() if connection and connection.Connected then connection:Disconnect() end end)
                task.defer(function()
                    local env = getgenv and getgenv() or _G
                    if rawget(env, "__LustSessionToken") == skinToken and skinBatMode == "Katana MVP" then
                        applyBatSkinTool(tool)
                    end
                end)
            end))
        end

        local hookKatanaOriginalSound
        hookKatanaOriginalSound = function(sound, state)
            if not sound or not sound:IsA("Sound") or sound.Name == "LustKatanaMVPSound"
                or state.hookedSounds[sound] then return end
            state.hookedSounds[sound] = true
            state.originalSoundVolumes[sound] = sound.Volume
            local triggering = false
            local function trigger()
                if triggering or skinBatMode ~= "Katana MVP" or not sound.Parent then return end
                if not sound.Playing and sound.TimePosition <= 0 then return end
                local now = tick()
                if now - (state.lastOriginalTrigger[sound] or 0) < 0.12 then return end
                state.lastOriginalTrigger[sound] = now
                triggering = true
                local parent = sound.Parent
                pcall(function()
                    sound.Volume = 0
                    sound:Stop()
                end)
                playKatanaSound(state, parent)
                triggering = false
            end
            keepSkinConnection(state, sound:GetPropertyChangedSignal("Playing"):Connect(trigger))
            keepSkinConnection(state, sound:GetPropertyChangedSignal("TimePosition"):Connect(trigger))
        end

        applyBatSkinTool = function(tool)
            if skinBatMode ~= "Katana MVP" or not isBatSkinTool(tool) then return end
            local handle = tool:FindFirstChild("Handle")
            if not handle or not handle:IsA("BasePart") then
                waitForToolHandle(tool)
                return
            end
            local oldState = batSkinStates[tool]
            if oldState and oldState.handle == handle and oldState.replica and oldState.replica.Parent then return end
            if oldState then restoreBatSkin(tool, oldState) end

            local state = {
                tool = tool,
                handle = handle,
                originalTransparency = handle.Transparency,
                replica = nil,
                connections = {},
                hookedSounds = setmetatable({}, { __mode = "k" }),
                originalSoundVolumes = setmetatable({}, { __mode = "k" }),
                lastOriginalTrigger = setmetatable({}, { __mode = "k" }),
                customSounds = setmetatable({}, { __mode = "k" }),
                lastPlaybackTime = 0,
            }
            batSkinStates[tool] = state
            local ok = pcall(function()
                for _, descendant in ipairs(tool:GetDescendants()) do
                    hookKatanaOriginalSound(descendant, state)
                end
                keepSkinConnection(state, tool.DescendantAdded:Connect(function(descendant)
                    hookKatanaOriginalSound(descendant, state)
                end))
                keepSkinConnection(state, tool.Activated:Connect(function()
                    if batSkinStates[tool] == state then playKatanaSound(state, handle) end
                end))
                keepSkinConnection(state, tool.Destroying:Connect(function()
                    restoreBatSkin(tool, state)
                end))

                local replica = Instance.new("Model")
                replica.Name = "LustKatanaMVPReplica"
                state.replica = replica

                local part = Instance.new("Part")
                part.Name = "SwordPart"
                part.Size = Vector3.new(1, 1, 1)
                part.Transparency = 0
                part.CanCollide = false
                part.CanTouch = false
                part.CanQuery = false
                part.Massless = true
                part.Anchored = false
                part.Material = Enum.Material.Neon
                part.Color = Color3.fromRGB(255, 140, 0)
                part.Reflectance = 0.15
                part.Parent = replica

                local mesh = Instance.new("SpecialMesh")
                mesh.MeshType = Enum.MeshType.FileMesh
                mesh.MeshId = KATANA_MESH
                mesh.TextureId = ""
                mesh.Scale = Vector3.new(1.4, 1.4, 1.4)
                mesh.VertexColor = Vector3.new(1, 0.55, 0)
                mesh.Parent = part

                local glow = Instance.new("PointLight")
                glow.Name = "LustKatanaMVPGlow"
                glow.Brightness = 4
                glow.Range = 14
                glow.Color = Color3.fromRGB(255, 140, 0)
                glow.Parent = part

                replica.PrimaryPart = part
                replica.Parent = handle
                part.CFrame = handle.CFrame * CFrame.new(0, 0.6, 0)
                    * CFrame.Angles(math.rad(270), math.rad(180), math.rad(180))

                local weld = Instance.new("WeldConstraint")
                weld.Part0 = handle
                weld.Part1 = part
                weld.Parent = part
                handle.Transparency = 1
            end)
            if not ok then restoreBatSkin(tool, state) end
        end

        local function watchBatSkinContainer(container)
            if not container or watchedContainers[container] then return end
            local childAddedConnection = trackLustConnection(container.ChildAdded:Connect(function(child)
                if not isBatSkinTool(child) then return end
                task.defer(function()
                    local env = getgenv and getgenv() or _G
                    if rawget(env, "__LustSessionToken") == skinToken and skinBatMode == "Katana MVP" then
                        applyBatSkinTool(child)
                    end
                end)
            end))
            watchedContainers[container] = childAddedConnection
            trackLustConnection(container.Destroying:Connect(function()
                if watchedContainers[container] == childAddedConnection then
                    watchedContainers[container] = nil
                end
                pcall(function()
                    if childAddedConnection.Connected then childAddedConnection:Disconnect() end
                end)
            end))
            for _, child in ipairs(container:GetChildren()) do
                if isBatSkinTool(child) then task.defer(applyBatSkinTool, child) end
            end
        end

        local function scanBatSkinTools()
            watchBatSkinContainer(localPlayer:FindFirstChildOfClass("Backpack"))
            watchBatSkinContainer(localPlayer.Character)
        end

        local function disconnectPendingAndRestore()
            restoreAllBatSkins()
        end

        setSkinBatMode = function(mode)
            skinBatMode = (mode == "Katana MVP") and "Katana MVP" or "None"
            if skinBatMode == "Katana MVP" then
                scanBatSkinTools()
            else
                disconnectPendingAndRestore()
            end
            if refreshSkinBatSelector then pcall(refreshSkinBatSelector) end
            return skinBatMode
        end

        trackLustConnection(localPlayer.ChildAdded:Connect(function(child)
            if child:IsA("Backpack") then watchBatSkinContainer(child) end
        end))
        trackLustConnection(localPlayer.CharacterAdded:Connect(function(character)
            task.defer(function()
                local env = getgenv and getgenv() or _G
                if rawget(env, "__LustSessionToken") ~= skinToken or localPlayer.Character ~= character then return end
                watchBatSkinContainer(character)
                scanBatSkinTools()
            end)
        end))
        scanBatSkinTools()

        skinBatCleanup = function()
            setSkinBatMode("None")
            local env = getgenv and getgenv() or _G
            pcall(function() rawset(env, "__LustSkinBatCleanup", nil) end)
            pcall(function() rawset(_G, "__LustSkinBatCleanup", nil) end)
        end
        local skinCleanupEnv = getgenv and getgenv() or _G
        pcall(function() rawset(skinCleanupEnv, "__LustSkinBatCleanup", skinBatCleanup) end)
        pcall(function() rawset(_G, "__LustSkinBatCleanup", skinBatCleanup) end)
    end

    -- La intro arranca desde el inicio, antes de la configuración/UI del resto del script.
    local function playLustHubIntro()
        local Players = game:GetService("Players")
        local TweenService = game:GetService("TweenService")
        local SoundService = game:GetService("SoundService")
        local player = Players.LocalPlayer
        local playerGui = player:WaitForChild("PlayerGui")
        local coreGui
        pcall(function() coreGui = game:GetService("CoreGui") end)
    
        local oldIntro = (coreGui and coreGui:FindFirstChild("LustHubIntro"))
            or playerGui:FindFirstChild("LustHubIntro")
        if oldIntro then oldIntro:Destroy() end
    
        local screenGui = Instance.new("ScreenGui")
        screenGui.Name = "LustHubIntro"
        screenGui.ResetOnSpawn = false
        screenGui.IgnoreGuiInset = true
        screenGui.DisplayOrder = 9999
        local parented = pcall(function() screenGui.Parent = coreGui end)
        if not parented or not screenGui.Parent then screenGui.Parent = playerGui end
    
        local background = Instance.new("Frame")
        background.Name = "Background"
        background.Size = UDim2.fromScale(1, 1)
        background.BackgroundColor3 = Color3.fromRGB(8, 8, 12)
        background.BackgroundTransparency = 1
        background.BorderSizePixel = 0
        background.Parent = screenGui
    
        local backgroundGradient = Instance.new("UIGradient", background)
        backgroundGradient.Rotation = 25
        backgroundGradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(9, 8, 14)),
            ColorSequenceKeypoint.new(0.52, Color3.fromRGB(20, 17, 27)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(9, 9, 13)),
        })
    
        local function addLustGradient(textLabel)
            local gradient = Instance.new("UIGradient", textLabel)
            gradient.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(187, 187, 195)),
                ColorSequenceKeypoint.new(0.45, Color3.fromRGB(245, 245, 252)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(177, 177, 185)),
            })
            gradient.Rotation = 135
            return gradient
        end
    
        local function animateGradient(gradient)
            gradient.Rotation = 135
            TweenService:Create(
                gradient,
                TweenInfo.new(8, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1),
                { Rotation = 495 }
            ):Play()
        end
    
        local mainText = Instance.new("TextLabel")
        mainText.Name = "LustTitle"
        mainText.Size = UDim2.fromOffset(340, 60)
        mainText.Position = UDim2.new(0.5, -170, 0.35, 0)
        mainText.BackgroundTransparency = 1
        mainText.Text = "KAIRNOX DUELS"
        mainText.TextColor3 = Color3.fromRGB(245, 245, 252)
        mainText.TextSize = 42
        mainText.Font = Enum.Font.Bangers
        mainText.TextScaled = false
        mainText.TextTransparency = 1
        mainText.Parent = background
        local mainGradient = addLustGradient(mainText)
    
        local discordText = Instance.new("TextLabel")
        discordText.Name = "LustDiscord"
        discordText.Size = UDim2.fromOffset(240, 40)
        discordText.Position = UDim2.new(0.5, -120, 0.5, 0)
        discordText.BackgroundTransparency = 1
        discordText.Text = ".gg/KAIRNOX DUELS"
        discordText.TextColor3 = Color3.fromRGB(245, 245, 252)
        discordText.TextSize = 20
        discordText.Font = Enum.Font.Bangers
        discordText.TextScaled = false
        discordText.TextTransparency = 1
        discordText.Parent = background
        local discordGradient = addLustGradient(discordText)

        local skipHint = Instance.new("TextLabel")
        skipHint.Name = "SkipHint"
        skipHint.Size = UDim2.fromOffset(340, 24)
        skipHint.Position = UDim2.new(0.5, -170, 1, -42)
        skipHint.BackgroundTransparency = 1
        skipHint.Text = "Toca dos veces para omitir"
        skipHint.TextColor3 = Color3.fromRGB(150, 145, 165)
        skipHint.TextSize = 13
        skipHint.Font = Enum.Font.Gotham
        skipHint.TextTransparency = 0.15
        skipHint.Parent = background
    
        for _, oldSound in ipairs(SoundService:GetChildren()) do
            if oldSound.Name == "LustHubIntroSound" then
                pcall(function() oldSound:Stop(); oldSound:Destroy() end)
            end
        end
    
        local sound = Instance.new("Sound")
        sound.Name = "LustHubIntroSound"
        sound.Volume = 1
        sound.Looped = false
        sound.Parent = SoundService
        local songLoaded = false
        local audioOk, audioErr = pcall(function()
            local runtimeEnv = getgenv and getgenv() or _G
            local getAsset = rawget(runtimeEnv, "getcustomasset") or rawget(runtimeEnv, "getsynasset")
            local isFile = rawget(runtimeEnv, "isfile")
            local songFile = "LustHubIntroSong.mp3"
            local encodedParts = {
                "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",
                "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",
                "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",
                "oJ5o4H49D0nD08ePimkHY9DgciUeL36LlKc+Nj4tQEmuqScYp5MqOFYCx2miuX+cVPqU6ccirYroEwI0h0enz1nLnzBKqha61CkAAFAAysigGZg5mRiY4cJSgpnM/jUUiqCjxWCghGI3cIBKC/APecAJ+COrio0oKQCFWvVwuRJ0OcDBB8E7L3I9IPk50JTiPF7GSYrhpDNKxcjxTq+Y1C+HgLYf839VIrNf6CIx5WTAiFMShwxkFDCorRvMGCgBHMwgRzDAOWCT6LOGBgMYGFRYBJgYAAoMt1QsXCOAQYIdL1AHme55n8eq5N9jM5Op6jpDTlUiFJk5R0ikIOCzuat/hNfT72JqIpW6AnTfVwuJlKyJMr5W27VmC+U0+kPgFXQRD2Mm2iAmERRRchJWCdRQHhLEuTFAGTDVKC0mxOsVtlUnRAehBIIKow8uvITF0qkKYOMmMWWjRKSkMZMmrKFINNIWS+dVWiiC7UQuZihRNRAUSimAMAK0yFyZgaRmbIOrCRVW47xAYNg0KRFCAQNDAkwakBxXBIgIIgcdOQmEXlmVzvPHEu1JL+aJQbx4LrJ5n6xKYTVQhNH4FqWjFBVHUUot7hJCjXWzkULLv/A7SF5QMeYox8jhCHzFAVKs9KoHADjgiRcYAKGLh4YmEYQ8a3KZsMGMDRhVFFclA5hwYJQbWAcMmxkD3NhwQ8sCOPw5WWycgERQhaZDjP/7smS4B1ZKXdSDj0xiXQRKMmsPZpjRcVCuaePZiBEolby9IneLAX0XI3k2rvAXbXthcHGkPTxWvBzH8cJGBiVXCHrXnvpEwZ3GWFHfP4SwsTPGaVgb2DwleyNG1qTapamRxck8rEe4syiQ1oPGj2BajE7fLjDjHa6u4jlGh2eO26PO+i7lpejp9Avvfh3l07guoNn2dzxcTSyxrRbTtw1aAEkVoDh0zNjcEw8EMQAzRhA2eQMdLDHoMltRxdBr0iyKIAdeYhoXcEYQYYFwl3rWQ7ilpAKkD8W9oKke5fB6VavQCajTISoQVkEFkuF2cwXA9J4v2xClQ1lQolLP/7H8dW5YEAI2bH4mTiZVGzMhgYHAw+MQHUMjEwYwEKQYMLAE8kQQSaIZobERGwhlagzgNAyUkfKqmNDKWcKoayM75CHNFJJ+vsrUeadcz7ZH0N5EhW+psSMUG23h/EexCfNqw/a743n5Y/OYKPOitUkaPa03Y36R5lNXtFZizqt2Xn6JoLExaYvOWuhsXSKj0yH0tQkyzh1zz64+MD5tSJdjoqPm7DiJfDN7fOOxwctgbRQtYorvdWquXIggiiFSYhjr0AFQO/jDiQzIVMo7zHBFIwqJSMYkGiiggKQbOlFpRgRIBAaUVjjwrN0WWlT4UOUYnbBIGjuXfht+aF8GcNKfh8w4xiBUETTlj4thk7XaaPM5H1Qw0ZP//CImsAAGO27DRCMwEbKwEwBUCxm1YWIQQLlgJKoaEBAKImdGHCqgZEJBCEZBJxSSbnAjyFSrpWHpFVbGyRcKZ65NjfVHHeaMx8kLO6ViZ8+BqPf5gPXt4znqKP/7smS4BPW2XlWzb2RgYcRKEW8pbBV5Y1RNvS/J0g9mwd3lGLkhzmj1d4s7Z82puacniBrEJQPsPiu+UdeozK4uEqopVEBo8mgiTnyNNnVLaSSppmWwlMiMEbU29iQyFDCbKzRwrnZT6JdT3v/KKrpFooYyZNjO7olBswAAUygRY0hF8xDOAyEM0wrIgw5CgyWmQweHEIlzJ/tRswFROSgzjSwQqpsTAbIkpwGhj5ggYbARgqjI4ykLLP2hxIpWvpAJ2IcyL5DZfqpIsnoFkwIIZ1wAADJAqKDshUpAIBjVeKBtWjj2td0y3BZUigRRs7ePMSYh0XMWH1RgpcKHjXUCKCQEqf1dsPlwYyXvFnVUS4dS9dOBJHHHsoWZw9IBMLRpyRHelicsaQhJSkwog2UuF5dRzLuxvs0uzZeYg1AOeGK0yQj5mdehT8odqTT3GrJXH4a/jtoJ9ynLLs2W8eQa3ZO40YvIquNRL1++U9s08hvKvq50d68Uo0Nx/TjjnLzV5b2/M69jlzpeq+c+Zg7NiMggwEGBeIeACRqM9mvAILM4z2GTjfXMVjw1olMDdjLWky1EO5GiUlMiVQXAmZjBjD6YEYA0tMyUUVNFoHNoDAsewxL1hJMaIQwY8X6ZtEUJ6HrXUkB6AGoKwlETtAVxX4gPA5Kd0is5XI1TU3cMtSy32pZjd8IAAElQ/ZUMtPysQMLIBhFBooDBQaBUAAIAQYIg0ERFCAcOWmcoOkw+wtOpa8KbGp00ODYzKGSQxJF47ND6h0ZiZJViq28yNCR3KtQqXIaZTrQM8e2OiyD5mgGLmw2mlrbduLRcyyhrUtmJo//7smTDBPUhW1WTeGFwdiRZsHN5RhUVeVTtsNWBqRFnQb1hGIc1y3wWf20Z28Ql8J/zrC6XwDJh2GlBLGWebPNOKPKYedVDNARiwkxBepkSF0BGpyv5Ex5SA/nr/1n/LdZATmFD5qfwaNxHCP5t7oCQAJBj7vQ0IbNiMM9LC40CKBCPMqZMBGPERN4jMjvOYAFDpbAxskqP4OIheCgBIFDUfxQ6I4qlR1NRjDersHkg0YsVDN22YoCGXoc4Sta9//////79WvjicrLOVQBAo66EDQwTGQ0IByQCcwmQxGMBh5oynCY4XUEgBGCDxDYBAB4dMMDuk/yQiyR0h8oAD9gExUGAJxE6Q5OjzhCVLwvVpKg4Xz5PbabVqLHL7BYuFUsnpbLJRZKR2hKT3M141XUvcdCcyaPPRqd2iqBlbjXP2z3W+LeMv/LkeMcxb38gsuWfkzM1hzrPxRIa0/iqstMU0c9StUXbsfvucqyd6rT+O3ycpMzCaeAI0xzDgNMWqk4lFTEwOMBHcRDUdFxu90mFSMZB2byEJJB52B4JlWRs1htCpOrNEDF3hqCoEqOHVTRxS1AQS04mQa0rYo8ARxd/7aW0EKYFvH5ByYCQGjgmiukCEIoqaMsin/////KFhcIcbBAjh8AE7AezLqKIgaY0Hxgw3DAILXlB/NJw/wAePbM1h5Bk2hACHmMgqkqpf5m6fCyERIkTj0nvOIZ6wPQRkkuCWrhWg3oTwUJpyIsSiUbMbdpWubGiZgjajPjo4TsNQQrmYqMseisZnZoVHly9hSjq3ezWzXG0+e8gMIVmIGneQcapB2a0iZVraW75ttNtvf/7smTTjPVqXVQTmWFibURZ0HNYRhVdgU4uYYdZyJFnAc1hUB+5Ly7pb3cyCJ280cie6D5/oplVk0/oHZmdrXJxwkFQ+YFD5lfAm1nMZTYBlghGAw6Dmoc8NBiYrGTSwYMQIMkHZJmbND3AyroDpzJFRqYABAkKDECsBQqa8BEVRShbpUCPbiFm2hp6BQYWIbSPYgFulzEq0BIOmbhg2Q2saMwyFxv/7rm/9TqCLLJ2wIPO1bUCQAQESSnT16wwF7JCEwcHMDLhQoa6e6EzQygQYOEHAYaGyUGIAprRlFF23MnW7qetNck7LHqkZOEyjIHOQrCM0WonKgiXAgAAJOVFS7WxMq36tEzlzkH9TIm2WZdODbS2SIDSs9UyfQS1n9E9V6m4+bltPrZeuZbztJMwbRahrJS/ubrdfc+Seqf0ntVNnGRtFHW8l+mpNPW2tWQ+Uv/8mSoE1HoRgTDF8x7lPL8SUfMtwDIEobIT94gAi5jRgbLHGKDg7eaZGLUSZ+DAQoUMScIwxjBJf5CMSCFYpyk1w1gQEI24JfpMISknA+z1JEqrI+l/lurULUEtWKgIJgCgOcB3mr9+YsV5Z/vVG51s0+zZZggAEAc7FzzGBsMNiMx4BTCJtMHHELF8DEQz3TZFPQ46nS8oCJI4ACQO1uCywDarCiEFnJVJU1QQLdeArFjj6SNujqNyYFE1pyPq07BwOUEtDyVwFpbqHXmXUGiW+Wx3X7J3UKkXnJq40wwsbsniKganpqY6uhQlfHEC",
                "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",
                "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",
                "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",
                "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",
                "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",
                "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",
                "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",
                "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",
                "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",
                "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",
                "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",
                "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",
                "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",
                "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",
                "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",
                "E1uyShhBoXypdjkUi4LL///oFTyv3Nak0HIwOCpkInmJR6Y2BpksKmbikZTGhkRNGqyIYPEIkKzbxPMGCsMCpiksi0UAo2BwdMnEA6yTAAEDxXAnWUUMMUwKhI4IYYglASACohCY1pZhszPEka3rTWnjgRCYqdWdYUKCtylierEpDB4BRQ1YgzVDpGIBWi990Sc/FtKq2OeLcsH/vRupV6b6YOU2EOVjXIhqEm+5qpuYokSfUVhPk8NoYyj/+7Jk5QbWVVvUu3ljcFZi+gNreUQehW9IDmXxQXWM5429YWCzExI9FHaeLULGXVD2keZ1kxMg7CtONPFcuUSdRoNj1PlUd0NTsO3d29z75iMiJVhjO3a7tDdsbtyZk+zJhUJx5uAx673/4ce4SfcAOH2Cw+YCPGUEpqbUaWAAY8Gms4xHNJSzCvUwIdBTY3I83IceHl0wHLMQEEYYhAAEqgAHYBiiBVVFYkRoxIAu0yJ1ggF4EOXMHPLVTJ1yBJIHYoBm8RJajrPOnt6KEgAAAACOLUg0oLgoKxwRGMA8QgUlABhEVGQSSQhMw6ijCwHJQOYVAhoMQAICmAweYNKprNimyXxq6FfheJI0FjEAL7vupQ8CZhVzS8hxhgkCpguqEJQXm7MyfuQBcYoCRXjJAFTXnjGg1g3BGC0T0R3hIAVruq+6YjTDmYaNlZHsN+8c5GqMc1E42EZVkY/kMX2Q3ZrR2LVHJuSkJzbk4oFk9zTLDof6ven6nGUyj/SRPUoS+VcafQIEGaG3MMBPMzhNDjSt2Y7G+XMrmzM+VwxOcaK45jRYsrheI+01JpY7F/8O6Pl1////7sdUYLJigYqggMRNpnLriQ839wYUGMw4KXgKSKwmFDSfRpGfQiagspI8RDR9MdRENBtZ7WUzy8BK9GhyXmUxf9G120MS3a/28ZzROJWs0MKaZxA3nmTK6BQxMDjwweQgQQiUihYAGWBkDRoQFIODYCJAkPDFxxEi4KimRZnhIiFQmQGFAPAJQ6W5ihoFClpyzbhxZDVPEiBMxX8Wnb9rUYJqNdqie6qpMVS1SSEBGqo+78YxGQK55Y/Jggn/+7Jk0wf3ZWFTS5l74k+jOhBreEIctYlMrmntwUWMqEGdYcCD7rRT6kb0I9jwEvt0YoIDg8jK98trSfjKBYVydOpFvFW4ItUp+ert+wKp1uDpxsnEJU5kC6HmN1jgoWn2hAItgcjjPJkZ3xOzRj7YnDFHsF3Aap6wWfLnqLO1yw5XTnh87vu14SlgyyzOLfmzuHmuv8barN+////22TbiSCgoQt6aHRwCnAwHPAtM/HQs6fRR5hjog0qVY2/FKzVJD1YgPICgUxVwPdQwCLD0lmFkFeodweAKUU+9jAg4bB2UwK4aY6gMvSKeRMpRBmzW6jg3OMmL5OUwOITK4OAIBEhSYUAZl8xmGgqYcTBngdGEwABhyBWwFAYCCWYRCBmclEoWMGgMw2FwNJEvkUjB5MQdfZIRepICBgC8JwhDIiTxFi7TKzDIMM1eawhclc6wjOVFQoM08UAVc1erABEm8xfQAmu20xH0iQbnIBw0eBIMyq5+hafOR5dtU7IhZcCWoe4J0lpPIzUg1fEU6lY5Yi6klqyLuMd55Ls9QzwGQHQMsxjDP8Pwv4RkYYsBVjrYl9KDFQ6c/kaxIpzclqEgT9Ur1iUzmvK10n12pFZZmjSKRduTBOkHqqeUiHWunr+BZrc4n8T/78LfyMKW8FGTbLHADjSAhIKqNjiBgIzOgHLnMQbNkJCMKjk1Yv+xgWLBzawg6OvsChukUBKbKwBQQuSSHOsy5VdlDqNytMmh5oEXdh1ZBA0Kf7oTK+BTBMhzAkLASIY6L5goCosSZAEwQTJj8FBhCYRksDpgeFZg+Api6QIIECo8ybATGloAVCMTvOf/+7JkwI7XyVxSA5l8wE7DOiBnWTIeoWNKLunt0SiNKQmcZKobLJsVJWLIQULLRBhkRBUzSF0LGi/7DAhFTF+HIDMzpI0LFkYQbSVSAYOpuqi4qrWXAgIr5pTyjyVk7JGHBAV0XaCAr/HAqmtgVE6ytYYF0pnI3C7HXCXaQSmV0jF0wqxQMjWhyLonEyplCqSrJknlsI4ImW84AkJ5luJQG2HE9F1QJzC+T6OOAsTE3rg+j9O9CHjConSjYp1e8qjHqnUiET+zp68b8N1r1cFMsodZgPGDHhIXAZ/I9ygwNgZiyBClhKIQhjBQQdg7bLrjsjEIKmTldZcIhWEGB6mStcABx5kKylvy9RdaAmcrJT0QjHSrEndN52ksXic8zlwtQxP01unpKG3vMiIIMaSOMuGDAlw1QrJTwCA4CbDcXsQGZmMW/hgIONC5rU0FQ8w9LAw8Ag8UDyEWMYewKeOZko5h6DgqzVh3TSfGuUWTxNFz1hiqQja4xYWA38OJgIps7CgbAS7yuEMHHXO9zKwsW58pR+AXl5gg4i2zPrQRPLIeZW6VNG5NKHt+TyLdJEHFpIDYFOyKmqRqPvVMTkCzMah915HC1g4MjERByDFomsMjJH1csuYem+vRn0+oMzFKmEWG5Su3G36daUszkkbkkVtwM+EcpqDb1SmVRipaqZ6sQuXSqGaTGG5LDkw6Enuxt25Nuknpymw/Xf//+5j2kgxQ1ngQ06h1LGCICyTHYiKGDuZeMKlC8pnXpxggcaiH3jADGkD19TBDBACKZJjO2Y2mVEJqVRCshNS6W23CG1NAa4r+B0a3PUCalQsSaK6zTIX/+7JkpI73tl1SA7vIcFTDShBneTIefXVKLunt0VqPaIGNZMhoPuCYRwOYgFKBgLMBQhC4sGK4CmAAuAIVDFQDRoiQQVph8BhMGgkLooJYk4MGFQqN2KMMIMAVMRbPOEBAgHBCwHCAwGBMREkqGAQXURMaUGgrK0TUSGBBckDpbU1vKNtwftd8OIiNAbAhGxZzU3mMOwXkAAGAF9J4I15xcACIUX+ptK8508c0+YS50oZyjQs5lQfq4ONQx1way3FiRVcpkw+L4lyKPVQEPISLwSYHCTFYJ6hR4HgQZhfFtLVzVjovx3HMjm1Urh2/VMOI8jPlZbDi9YI7Q4RGRojyvILjRcy2OJps8VW4Eu3sqpT+v//2OM3aQ1W1wwQjwICECT3IDNAKzQNysiaRUB1ZQQCBTraICBDGXWd8wiAWQemokfA5hkgKR9HwlYsAoDEEjUT2mqHKE4w8hLpo+nPHl2vdLWSqHqlX1l//8xjDl/EATC/GNhhAeDZjwimXSEY0KZhcDGHxGZ3K483zCyXMLiFNEWG5IQX2TTMo0NiiJARj1wqbPyeCoozQEyCxTZ8wsACAyZ4XDkgMxZssoYsSYkkGFUxkwg7dNLJZ2HC19lrEhl9KCMJCBTxIRIgK4WOu4woR/2/YOs6HkrGeIwhcNRDj0T3xrMXrznAZYjbEaVMaSWUMOAe7XpyaH792pE8bhvsgu5IVAewYiXI2uy4Mba4pdeTKpZkohhcHYxzpRSrbWZvcqKxdaeRFahCuet8RPwU8vNs1VvTldCkosnewM6qkSDM9mbGp8zb//v3FSUw+lxS4WwVQ4qLMC7YCgiMbScz/+7JkgQ/3jlzSi5p7dk9j2kBrLE4d6XFKDmsDwVyPKIGNZOAwdghoUTDgyelEQqFvK6AYAhEIFlTs/0Ap3iZczdu6pC2BKI3WCFesVoVhnBdO4yOWRvxyeHxqOKZ7RzMDYW+Zs+powWmHxCBTEYaKZxILFCdkA0hrCYN4nhPGVRhkY1tJGEgQmSPA7iygyqUxJs8cdRILCTJhVkJys7FpPwj4F0lTgjSZ2Cky2qPBacAEZc6a0WRLCK5T3WWw+bL+wa2FrMy2V4wAN/5SlusxnktY+mCkO0BLGkgXXP//muy3uNp5ndlUZtvy+9eIxihlm5S9Los6X6+8xJWls1ij/q+VbEmjOzHIm58OQCqnTUsOsBYm6cBRuOXJVDsN5ROI0tK80VhdSKS2tQU0Mvpl",
                "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",
                "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",
                "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",
                "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",
                "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",
                "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",
                "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",
                "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",
                "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",
                "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",
                "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",
                "NaCUbQcOGFnxlqGsC54IBwULRiBWMwTBztxis19o6tMGMPeVp+TxSShmnmeuEMMbvaVWbVoDH0EEZgVi9nFvvn5uasWn+fSGIjjG6m3+l0ewgtvYpS2ZVBZEZdMIWRBbUq09A0pvN9YiVK1+KUDAaOUPFSPbbbO/PaV3YVaeKKmCgXuvFQuPKS2UBLOkTaGqVoQnfmS2yTTxOtPY7RS7vsq09EJtpsiJrHJwfvkXe4cr12ktxEFAAAQDP1J4yvUcQ+BjOxlFRyFAZDAhRxs4kYdItC0zNbpMPGSmH8ftjOyHZbj0lGf8xjTCd///6j01nLERYQaDgFZheU87+obNGZAX///1KTMusWiUjQqEmXgpMnGDCBhQmKhJlRUCQ0zEkSACosVVMBDyAIIFzECQQgLDIIHhFgEhX0u9d9iVTLZmBoCVIu87BTJIeMjixwGRRE7VZLlwTQmQ1ziXj8Ms329QqRrYzsSr0/n6FOLPBZXq2YrDdudsJVqtJOQCAHFHNdIHJCOCdmgNxxyKVjblejsLtFFAXB6pEUaiGow8Yb6hw4hYFAMEi4hygUJhCw+kBQ5up866bkxUilbpEiaItNaZ5tCsoXT2MU2MSuX83LdQACAABABAAAMKg3UIDqC6QAGIyC+qsm5MkeXk4qDfAiba2E65Y2LCMGG94HLgtIjbHnV/oCwtEwy///+bjpQsaYaGxqxQ9//isX4hFZf///kRSSAJFsz/+7JkkIQGV1rVA29N0FCoOs09J4QYfX1bjb2RQT+bakWGHhCeKDGsIRwEOgwWIC1URloEQjDWR0RFpQGACRYY5jQmX4MDEQUnrkeFYcU06np5KtzZjNVLgoBBk0aTabS7VUJZY5GZ+iDnKFiT6tWlK4BiEebGkg+q6PhPK54jYq8ZsxH5ZWnKa6AHz0agGZEuvfMVp9OWOkh/HYnkYdH15XJBVOUqYWJ2UIdKn+sqywpddlpFpac2FU0eL1nGjH67SKzShOeKGastLMcPIlJxqmzf5Q5Limtk9KH7fzMznKLyCCagZntUOcQ5BoXsZwiSFTqIsjh4tcqVQ9eTWi71M0pxDbEnimehevwrDyVyYRhjnP+KC5sVJMZSf/q9G+nUMgkoRGEzD+p7n3Cp2Igv/+WVQAAJtHSZYUBwqTBZsKGdEaZZaswwS4wAHOqFFoLjgPkF/q/bucoaIYcGVRCoNZlDYVIaRTGmwCmoaEBK1PMYqqqJDIUJlcX58KcFwcygNNKz3JoY6vT6HzOOICj7esXeKiFdQKpfwo0+uHJQIl0W8LQDmR5bF2WNHK1wmYVYoVtXKRJKSAqGZhX0hEVVjjVCjjltQhwam8/oZ/ObUwvXkrCsplhbW/D6SAy/5qzMUFlb9uOX3ny3ssCajfD3PbPkeVpdqZ6SRrtX//ibrJmaBoLMBAAABgOTMdZmkychF3yKjxvIpyr5gLpuA1CAS/yFLsOk6ISCxcZ+yeOL2KuCPaEj/8kccXVUB7Knf+VaPt/4jj5IH8RDQ1qPONHicqMZT/pIJCQAc2vINDG1xEgsSBI4LFwCQGMBALhABFZw6qD/+7JkoAYmgmFVK3l48FOGurphh4QYTYVXLeWHwW6f6uGHnWiQAIQRtEJa3jA/DO09E5QiNUE7EZ2R0Ss7tthyTnbZZtUqrSmTB2Lx8Uh4LTJUCAKlYVxnhUJIBz88P6PmoumJxhHg7rAchRuZeCIeEdjYDpMK5+UB7IKOmQjud3TJGpYReTD27hocOiaW/YB1e3AglYuFIruL6Lo7specOGvYtM8vec11Y83G0rjvKG0v7W4lsVOgaMl6hEmVpFDm1nb4+fRLZRHPAQAAGGaPrgIsA1iSEOOarA6wOuJ5FHKdLGtADkRJoNYuaNmVH8Neg1VR0M9ZjTtD5UtHIVJhdFoLHUY/8qWilWb9FKFyJJ3ERFxo42aaPlcfG3//0JyfKFP//6UmAAAABI3irEBcmULDZlJiFS0UGwIDg4XMADQEAGbABUASsJMPDh4Hh0mFgUSJnNAdUUG6NqNMNI72k6UMOVCROh3i9eAjLA/T5PjIV+1euzTHihYPxck/Px8oSRkmUS4XLLEdI/UaAqIOYKPXTPnudGuGddVyjw6nb4oVY4K5KWbsPUtNsjAlJDaYOCAMITc2ZmRKyITY2Hg2KYGBAhZaZghRoCTstqPhsozXzmjVVE5Sm+C+VN1YzKvMNRkQrCpJEZ24W/9bTugOgDgAAWBbi0eLfhWMiUHvXedn1UGfO4KFJjmAiQmsOX88t1fce1R5+syYQiYNmo9H/T+ndIemYJcY6HZv/q2ULIQ/Eg05QOLSB6Y9wcgr/qPFH6nP///qyRATja4xEvlQiIUDDCBpyCZFQcIhsVBTOwtAgNBQ6ODw+LAYYNlUGHiYaGz/+7JkpoYGRV7Vy29M4lmGKttlJ5YXZXlWrbzT0XIg6uWEnli7aySgObDDIZ6EMEEgJGgdp8k8NV4NM1joVqcFA3q4vrsRdDhzGS/LiJVsXYipwMCNXLI3ViXlmlbqt7K3Hgl48BXMMZepiQNyM5HIp7J9mn3k5r42XdzgLiJTK4aYSMs6ZpWCdSvQtw5Ckw5vxb2C3kpaI5LrBFvjYhHe8JZFskHMRrSFTy8FkjEPUt7h/7RB0AACAAf2HY0ytPMO4LSAxwIBmrUznV+2mNefCDeq3K5h1nfHzpZtuba5hMaAGWNXYFfpGumf5N4ll0Rnv//+TGB4W/UdCagESMRh0YyrdCQ7///yjY8/Io///6EwAAABOKczCSAt0RAphwQHAyqACGkUwIHiIFNECmow+GAIkaEgKx4OIx5rDhNBIFwJNZ74kXGaVHocqROzzN9YORtDcRjCd4vNrt6tMCCDqfC0sIRV6MYeKyH6molp48ZwurdRMxV6sVSPIjO1vdYQb5XKqEdSumY49GuXUVEwWvDWvJ1inYGZuaH7lAneH6EoRKOKXHlde8QkvzTzCcr5Tx1v3+NQpt8dmj5mLMWiV3o+zZKXAGZjOCsqagFkZshsTHoAhg00eEMXZGRyjBRVMQmgFiV7KRd6Lx2AnSjcQj+WTxKdpLQnyo1acSjpykWgoNAHAmBd///qNSP/4kIVZLBA/aFCz+DQd/8GfiL///Y1IiLDAAABIBcO3SCwdCwxxImPhYay8YEoTAcRU7BwlWVbpgwKRrcVVlUxKdFoyMgHUt8eKntUtiJvY/bFq9K8COrgdH2+lUf0o8gNLA3IYin/+7BksQDVqFxWQ2808F1l+nFk6baacYlfrTH3gUwW6IWNNPnKJUHJucGsXqeXo2I9+M8Q2fa+yFRD9xeViWgmjpcXxkhKI/rPssajjVnFHz++N8pX8ysRLy3V2Chg9DdDg6Ktkw6OpWjg0P4FYvoXIpDka48qpHOfZfHqHl8Fsa1CXM7C8RlYrVG7VBdAHQmqiOA7zrWhD0KLgu4SfQ9QOoJ3ofCePIgv1XWIZLgHZoSJSAiMOPA1OZKqY44aQCMVDREyFCsIAiYY+URCEaBlI+LOEF5OuUCgnuUsSkR9EkScj/GyP/xBgiwLUCTgjSP////wip4WQwRSyhwwQAAfB+Y8UGDRYUCg4IAJBEIws+WRcVATNKPlqh5GIgL/EIkMfQ296XJpu64Q6DEbnzxD08kljoW/Z8KxwxDRCNb02zlc9U0exq1lE09F9nDz5WrX6nLMws26pdQE3arQo33YFpwESJDnz54foGjszo5r7seNLFxMsrPeWIdYfEptlUfRe5T+gxGtPHLpKro82YTZliAsNHZZbXs6qslwhxcdpGWs0+PYDksplVWD9Cjc2nvZjWfwqoH7mfEoXxRDG0A3wxBg4DYBajWATCVC0gUQmsagIuc0cOCTKDkhechhO1UYcGQYZciuVCSrxGJIBNIVIOOEAjCf4+cTAuKyZv////ocqEjwXgyIVAwQm6AhUDGyKKqphQAPFjZTEwhPd4wUkyyEZRRaDoSiBWThRCJMr6xOINnlkQf5",
                "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",
                "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",
                "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",
                "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",
                "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",
                "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",
                "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",
                "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",
                "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",
                "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",
                "0jW6pdtERuRphqs5/f5L0jxJiE2M681F48BJzLEcgqDUf1qf////IKKNrFrNVVrGeDVKItAsCZZJ9//9BBhCj6AAxAA9QGDTEUxUYaMGJMQUIXiYBy1ASBrDAxisGzujJQdC7DiqaEUiWAwUoeBpaTreTQFFSZO8BDW5hQQpWgFUrAUReT/S1IqEUdHCInbja+IupXSDAFf/+7Bku4P2aF/Vw082UFLHCkBl8KAZ7YVVDTzcwTOdqYGANwj0PPEBTC8b8EpkoS3mlcpCcfSPmtjankSe0VXM8edjV67YXI3lQvtbkhct2A/6ryCBXj8ZyWikk6ZSaiendqEwGPJi7hK9fHciKP3iPzAbnGDasBsVkm4tJ7hyqwwCInsmMM1esNzXZKizc2hMslQftysbVaVvnpZHYYEeYDWIbEoC3uLNv/ccrrc3ah+Xq0wfBsW//sA5jHanMVHL24s7cqb2WoW4f///6i82su8dhRHaBIlwvFMkhyjg//qmZUaE3rHuUAASAAE74VUBnB4Cpm9HGJSGVBsRESRxkZEoBG3GibAWyDKEDBHIg8VEDCGBUBymxthYcXHQFCz1hjLC7TVgABbuUFl4hCF/G+jq2WKwxOsLHgc9nHESloroXiUAGzuWlsRF08n9l7IoYlcSH8XjV7tSQQEN8i4MaE23rpC0Kjp5XmKt3P5KNziW46U4onzEG4mC7MZDDLVksZgjpl4yquGfCrhqWkzkultmcoS+xuXs+PrV6sOHu6mieVYWgsEDF6myCdveYzZyBDY/N3w6HLm6X/0QIwDADTIXyWurCVRMDew3FchIt79vGY5wkbBgz//AI2o29DnUV1DbTjMhNDANm/////6n6ux+RDUZArLKLzCMTCQgb/8qF6Ioi8lLeGIfh4AMAAHSMIsGKeAYuagQSrTBEE1gsdexACHCxWqNV12wOyE3gBlUWmDZvF2J8EAIRIiwCbm5rfo3o8RQvMn2uwaFwEMBSzc/DsRRovNRQF0L43FyEhM1IJQVgWae2TsKpJHkwoazNf/7smTEgjacYNVDTzcwT8dqqGHqPhoFfVUNPTkJLaHqoPAfCKtVOpbrlPNlW1QRYsiuVrMr0MRWZVI2Tu0NPw3KH6xKA5JmIMU7z7jqQsaCaW4xEYwLL5aTp0DAiOmF0weJrFVCqxSTsmREfJ2Iw7eIjKJeBuDJEnYfPtrNQuZ9daGdd6l//fPI+4ze/zrgDgBklwOAhQtom5fSwgKJSIWDFV6sL7HbXUlt/+EBkK5XwIaucW9eaXBxkja///8aZVxuNMfFoVFxsaMSFxYm3/6xqR8Rm/3bIPjSBAAR0UIUDBd8YgMaYqGFDLAXpMWMeRI5fwWkk4pm0LTcMUVl1p6THMUoGaJ+GCkpsJoPUvwxYSmiNcwQNj5QnVnc8MJwzArKUZWxoYlDsCtfog7TOBoSh+mATtEocFGTRlWz3UEq6gR5aq56pmR/d08we58Qoaqe94Z7etx0UqlQoG1+jDogrg6y3KgzlEizzbi/IYxub0rlIzqURKljsiaIRRIRVEqWYQgqAY+WRFU4obaMIliTtCoyRMowTIG1byT2IN+0Mt/rfGo56rJ5eJ5VXoOmY6PGTddYeqSIduLL2cZ4FftGjjaXpf//XehNZMJpdNC29uvi70piz3UkvpLH///oJ8TsDwScCMdItCZ1A4Wgt/////QLxZEaPxlwABQCqdSCcBhghzAueIRBMtOoylUKRV8uqOWhEUuo1lGCE1mHoDR2XpZjwFdAZj7I1uE2NwG4OKRDBcmKRAeLSBee0/MAxJIZj6AOZQKiGEI4CSXAHIRiHg80fJJHpSYOWQpSrijDg8UF3SUckrTospDr4yeCrhXMDv/7smTMhraJYVUrT05ATmiKcGAHwhh9hVmssTkJMaFqFYAXCZaVhDUEcTUJ05jJIdHpIiLTpRdoTCVJ7E5MhtYmHToImmWExQvP2jbGijROjJT9qMJTQybdZrbzY5W+kCP/yf5LIp/FjwgdiPi06OsvaelyhgOARCjpdef4pq8b8uJdeBPGFxqksZ4wMMHTXbnF5FBsOQTBUMQpguTi2d///+hnlKhszo9RF1EWEn//0ZTv/8EAw1QnEMYAIQAACAFDpnrAHERBmGMkeEKSAG/KfJSH+FCRJR5HKkpa5qcNP8DDQ4iRNJFQS6o0em09A8SSAiAFuiX48IjS7yt6nTZ21tO24jw0jxr8e90JPA8MtNdZg8490Wl1J2mgLLZhRnRyaL/QYjw6LKEfJRBHc/jDoYnp++OJ0vbXqcgMCECgrXpIyMpokHxYaM+1DxOd6Ccqi42udQvSWU6JGjUPKxBYoKm8JCQ5aSl0orJJ7f/X//LQ/6bX/YvJzYzNSSTVtQQl2rgXqVSM4UmDBQ+8TtKpwJLGvCJDePTDC5FwYPuyMxURHcluK0FRTMdcSpG2zv82qjVv///Qp///8uw0AqN/6hOEQdFBxMwAYAAABZxGBiAIETgI+CuAsFDFJQdERMSVCxEMACAUa0K4LrtxLOo5UzYi1SO8QbiYweYUSkOYIOYIItwiKCMIl2qsMtmdjQ4oKSIONOOqWG15MXddjS7VLoVGY+7T7GkSQQMnQwC3IptgITFlngTwlOvQ3zUq25ihmUrn78lYjUsQyUuuFIkGxWpmyEMZ0Jk5VoXoxTBgASjGdiGJFkaVTXxpirQqTc7iyf/7smTcAFYfYVZTLE8gSghqUGAKxBxBiVMtPTsBdiEo6Zw0+QWDDlDXTewvnr5dNtmJoep4lBoVEwDBUMozgw3MPHpliwEkqD+mX3PKbzYKq/pytykeTTTg2aczAAAOIMQIhSMtcbIoFXHkYeSTY+z2NYx1SSAcc8hes5lSHAi6upbKBR41ABf1g7Dl2YWlYb0ddQT00B3mz/9ZJjnNFq//+YIUG/MwPP///4mqYcAclv+qOMXqhlHhVQQACbOmnWaRYZcwY42KgBYKyUgECQZrDfioQxIBZ3YwBAsqmEtHmJj0bdBeS+QoNZEhMIgAceV+yJEodPoIztA/AgVfK6dEtLuoCUANJtpliYiEyl6Vh9EKI0NtCFc5HnWDpuxBhUUrHaM1PChaHrQUKiY0e+OhrKxXPkLHm2JxBIGqlL+mVMu1kqHN4loRP8pxvkjR4Z1HmxKrHiwiFZKMNowqQOJpvIhrBSbL29SGOrlSFlySOnpMznNKdZ+lmSg/yXT3O6CQlSIAAKqYyExCIpEGBV+3dG/bsRqUQ25EpLFFJwc/STg91Y8qWWhUJCgZX6ZCw8XuySeeFo4NecFzDw//UYjNkEB///wodCQoOH+FgI////jB44z//KXAVgARQKNhgtgYE0eBc7Li1EHgg+Glg1XCMN+4pdi7U5a7TPFDmDxTBGes8ccjREAzNvV9hxw8NJrMMMml9l3IvFKaHHOcqYmIVKZRN53qTTJmHQqnl9Jf+KrUFaplS+cy9V7TXEllSkGo+BgWS8Xx4aHpg9EpEXhogs8Z/n+6+9b6xMKK112CCrDi5s7WF9eWiw3f57iSFpkzYP/7smTchnZLXlSrT03QVqhKZWIlspZReVmMsNzJpJbowZ02IPuTkoR6SkF82zlGHHbnksYTVZrOSQbCx/j8CgkVoTJCwhLUUPrDlShX75pQFygEAwBkRLcn6+6hwJISuLwK3rbDTAObsEQkKZIFKTiSvkU23Xos1aAFCsdmMbdi7G43c5E5eiO87iC2TJhQHYORv/x+LI7ywJmPD0ByEgYkuh/89/ESAAcAABr9I6KCCRpkZuUDL4mY8EKBw4yIgoCIiASLU35U7Z+lnI36WwLBxkBElbSQEDAbG0iHChYqDZmAB6eYXFNNEJnNZxbiXDeZC2I9DkIXCTOJUCUcFChhVJokI8GxiTpwt9JX+o7dWzeyYa2ZER6NrOhbI46fnLGOYlRflOyqOYuqLPhnWso0OUnLWxNSOrpjoqGDTzWhpSQ6QMkSCiDCwYDq4c5pHC21mUmN",
                "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",
                "tNo1JPLTgZLdVVHNiCl4eUVOt4PsgkBwlrIdjKtWlra629dRoVfUDK1rrjLjNxSKfSQMJVSjbjRpg9LGalPVtdwovj+lV1XU4iL2kI+WrCWBlegis0gKhhHdcdLISoAUyK6gAYQAbvkRgyXKUDHVpUyaW9crWr615c0w9jdHMpD2txGw6UPTKOdQUJ6jOJm1ktNwwU2ZrF0uqpxHBVedwOR5szjEtxylBAIMASsAlCQtC1TcQFiiUIOQIeOQxxYs1MezNaiNMGR9EMMEj5PQHTgUL5KnBoXhGCpfq0m56oP/6dyzL5dznMQP9EqGBWC59geXRRw//obtCtndi3mUKdGL48AIWTLsGQQSQGFQYC0QgPLASApVBYKAa0ND0KAEq2hGAqc0t6AgGMGhOLQGBILDQimEMQSUOxTidEE1cs2IABuWC71TiAI5TwMuqs6UNi4MPN0LqCIWiSsDDANDiRWBZSXkSCeWhiVSFSG9uFU0g7i7U88060tbsSmJHTwCtN12SF9YeWym67CETN0ih0GWWULZlE1zNlorEbXjD88Vimdtov/7smTlgvZlYdRLmGNwVASaMGcPPh5Vh0YO6TPBlxJoAaw+EU6vR/X2kMlgVuDyz4qECKcuAJsCwbQAcViQmwUHQYNo21YmyZYTDgbFyISCSKrKrWKx5UFzSyCHoUx/Un9Y8FdaPdJ39GTpthnwCMgWQiOE/DHSDRiUB5ikjjJXFyTpCgEoLVILkoyBZW/gKqKnb1uK72JGwSIIyAmIganmCMuuWSCIGYYPkFyVYzodqUBDhrH0bIIYRYP0KGIucoMeEFwqnhsMl1czY/wno6hnAACITAAAgVmp4AYYE4ECZEIDBIKAIQDAgVQYIARCGrGQI4WhZaUQUAeMqAYq7MAreEQkvB1CJK2mdF7GnwVJKeAYblDRJdEIvaiTxUwm4B8GoerVSc11DFSh5Yxz0eVyV06l2tcNqzdmxdK7Z8Cg7l54kj9MBNM/bYyNiBGoCYvlxDLyC2ePoWOWjW4vl2CEuko5XvFbS4PZsdO0c9gq0spOqQriUU7vO9K2Yf1lyfPtnL/MtbRPHK5E1nTiOZyWfdAQAGYckFyQZiFSxIYWySEAxLrsaLNHGQUAM2ROJULEzXkVlaQlQvpWNLwDDlEw5gxxpi3GGIppSFC2QhhVvXKSYicxH3BkN2MNVVtboulsJ4VCJx2QoT/ox/ymdZwQABMfIZMdilMSxfBISAoxCEBxIJQMH4sEr+8Alhxx+nHUBcGHEyhIdeDP0GQwyMggAegJjhYEVqV0ADGQQ4hPRvZWLaXkTBxSJ4p8gZKFwW1Ln6b94SJgHKwDdgv2XyTQ65zX95NmrWoN9rVzZAEhN5vqMISdSqIzC5s7MT4+n7Cfj//7smTQgLYEYdXjmGJwXWS6RWcJbBjZbU6u5efBj5Logay9ONnXzqgM5/TkPgSocpbIYmrNkCErcx5ZmZSSN7W5SZbsxHUWJS7+PEmc7blklTtnmtfHg7pF3qBWn///7qkTER63UcEE6PJBlmSZRusCFoXGKWDzNiDBTPfNpQWoamCkVBloxxpqulSJ2LCqrphASlA1shc0LEAL8RBDoSeyJSrhoMCKK6kz1PhAkSQtfrRCwtKVH0T5Vq5LLxbS+x0ilvtqlxSi9fw2igKhAAEzFvAoiDHoHMAgYxYBVbkQiEBiMGBACQlCwUMJhN52bLQRRkMhBwKlMVlxIE4dZIIiGinVcfo1iaiRGeblwUhNhAXUYv6OfEuJWL461E3zNE5K0urSTEyZnP6eutQJhX8/E47RF2Lz0hj8fBKJkTg1APPUx8UTuykoNhyfap89XF1QRThMOz1xBOUR4tjNCmhGcTOpmjOJ262C26lVL77K+sBxCjRp+aM1c3xn86s/2zMzMzm3ixdmtOqPlwMAAABp4RHQyEVk8IQwhYEWjNHyUeXxi5ihRyQxRxZ0DTklUETvAUYAwhGZAAYywQIR6IIQHW2xgBl3xcOTGQBF+RJbIQuCRgcKGBJNsseW0j6zxlkMR0hBS2zCC8zE2AtOanF3BiEnl1JvlyBtPVOR6jiD7wcCmoADnf75l5oYcNEROBhMdBxoZfYEicVYY1cFCIsFwclWu9fsGIaxGDX7EQAozRLBhwuzpsENCMsCQN0exMNE1Tr5tiJxJOTnVqbZFQ1zv08zPxZ6adydsznMOA3+eJCrFY+t7Pd8t3UV3BgXb+ZhU//7smTTgnYAXFRDj2TAdiS6CGs7ZhZhh1UtvNWBqRLooay9qKgbrOCneWXHqrWfep2qeHSWJDftryJdIlCaCrT13+sg3zLJ4giNQ54PKlpksIr29/u2jP99lRfckTVgdCIkm47wdgAYMBhUgOHjISD1hS3YhBGHBAo4oas4KgDFbTAiWuNLSpIQUPiqCmaka+AXEHjzLFDPhecwBl1iGkVaEYVMYgQZ0Dh2/XWUIdet93+ToWCdPy4sIugcUIXw9CfR6SJMnHDOv/+xuvtMF/i1DSEAAAGPIgjKVkAAwwGg4YHQFk4gCwQAMkaUhOJBZdT/uCo/DLpe8a/5pYeTOA5AOBsVDFvlGkIDCJRbchbUczsEW7CXmB8WzVEd4dDrGYlg/tj+Ijud9vDxNWikmnCx4nuhRReqBnJe4nXlChJiEc1UKLtw8WC8oomY66VdGTH9ZKSlgwdekCh4ePrWz+UpLTn51TOc7WVb8eLC6pdfPVn0fWW5nsiSd8yvtzB5DGTCwshXt4+YL3nw0SzxNgYDjGLwJCgIMmSgJiIEGa1MllmTOmQCEZcrAmRFpGlsn9M+MVSR5Eh6lgUAk1Uz5w6wAwoUveIiZ0A5hBpCZJAZs0Bd8I4T8O5QHuFFRNDdP4CsG4uQ/BAtE/IEMRVD9fnOmv//+w6125vAjZBADwSUyYGE3CQCKCjyAYGLCDQMvdGwIO7cKNsfBuN8dGn8uTSZCwpwRA+hXiuP5bim4NFobkmhECG7V88NYjz3litFGTL6Ku211R7TTjTM0DbPed+tPoz2Opy4S6nYHi8wxmpucH6UOu68nE44o6CztyGG4YiPcv/7smTRAPXbYFXLb2USbOSqEG9PPhihiVkN4eFBlg8nwbzoSFXRuSihUaqQphX2uCdysIKmyqjk5YnEu+0iMdMszckULsqJY7hRkep040gx0ju7bjRfCgqyLjsklaave9/uWLFrLV7Dv9zsv3AtJp8B4WBAOYh3H2MQgC65ijHGbJrUp4pRnXwjEIikxVwC9KdplhjsAI6CkRMcMOFDx5z24aNGAxEaMqYOmzR5ViBsMxoxYoXMA04iKp66ibCa0dRJVypr1DlWpmFpnICKNBa8gyd+RTthgEA4opMDOAgBQpLxsjSMLOLCtxUvTfLmuvRNrNNHbyKMwdo7EUyJ0IimQgBmPiGrB4MoFBfcUZONPq9d+FpiI/OT4wupQyopUJfHt/j5a3CEqCSLCFsrmqFtCD1NhUmgoUW2HWpE4wHGaDWm3rYmlBcnj7rx8qF4fsE5EPHgpS5nIfBeFWi0QwKYupKYq4RM8Iuh7C7K5sibhIeeCFHi/VVDvfKR5HVTVjClW7T1ZNsvkfw4Pmcn3gPJXk8PWu2ZxHzuLEhVDwx8BwaTwqwDCAMBwWMsAQCCowOoR4aGKQ8ZPGpi+GgpGCgTM9AARLHC56ZQ8AFmgLQdSwULPjwwFVO1DVWAwTNDDjfQxIMLCAFBwcdtLiIVHC1Mm/HmseRJ3rdLYtPrR2K7OZNTLARhqsA7d4QoQYBkYeaVOqIBBmVTi8k6BGAeOfYvE1OqKw96/Jt+KegmrkEt2gdygxWR+qVe9ZVIe7AjFqPi8K0Bcx2BDFemM9WM92edFK1LuOEMe4YjVY2Rcn2Ey6QkmiBHMS86xJxWD0VVjRQvx//7smTPAdY+X9dDbHxQZyPJ0HM7ZFmlhV6NPZXJU4onTbztIIOlC2DreqBDVgdiKQSULgkWd86NNIHsoIqCWEqT01z0OVJF",
                "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",
                "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",
                "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",
                "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",
                "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",
                "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",
                "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",
                "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",
                "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",
                "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",
                "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",
                "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",
                "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",
                "ZZ06svY6/9RBR178ToIVEWy3/////+FhJQBOyxEzmYjFA3McCQOH4YjTDQFMBgwKi0wICwcHQYFgMAzGgFMJBJ/QMxhQAl3gUD0TmAmCgMt2HX/UhVXs0xLGnk8WfRyIzGocprIyBoOfUGA9IlNIEhFw06lXFtXiaVL0yf4YKrQxVKlyft7Z4NqTs8yva3ysXlDEpaSmELV0bw54N3ntHZrSWZ1hrihCFa1oVV9QtiHsqLV01BUET2CcP7k48pInImBpgofwRiY0YJ2GDhBLFaIFSC1OT0c0Z///+QUt+Nt0U7CAsHWwKHJvCCYwYUgGGytGNXqWRsAFC6wUdBkxaAoCFqbopvCg9MRWJLMtW1VTeWuczBKhhTVJfDby2GBTVHZwbknBCLqY9DArlWoJh61qaa9Pf////8IgVjsDSMSmUGAAy6EDBQjLA4MJjsxQAAUFzBQUMIhYxIARgzmBAOYAD4ULIQYmvITQPMHfBogqFSpbKyVhH8VonXHTkgWBmNQVuWQt/6ReLQXnVaqVAAFlkwU90oxuTC3JlkrgglA6UXpGmzNJZzpO//uyZMiP5jhe1AuPRrRcBqowaAXiGY1/UA5hj5FTjyiJnT2SsudPHFcUBimUH0LrS56BDRUhgWunkWx0Rk3TsXNEYSgkHolkdYVSRQ6ePh0Ck7Jpd6rC8xSu13Dz4FjJ7WWf1h2TpJvwf3uoXKGVy+VEzVnmp+ZmZmZmlmWJ34Zs5cYGhoEeaNLE1Lk7y/AVPMugwaTePLPgg8BGpamHiDR0SAppiNcvN1woKTHJh8jPI9FOuUUxogNITQDkErFdV6Eqlmh4HwIEeME5VQ4b//+EM1///1pVAAABcObnkxCWgsAzHRHLPgESkAMMUABDuYIAxgAEAIVmEh2RHIeMQgFZkAUAURgYDloEUU3S16V7dSoAG6NEeJrkXl1LA8RZRTQ7axeGM4MGSKa4npDDIX5dxIaMq86QwXEEdQnQMkxv3Ujyz7B2zFjbjTRzSI+5tY7z9H8ds66fNn+PcKSaDeBBfkRWgv8+OzI+MEaZ3bRV5atWXq8oWrrNTMNWu/8MjCVrZs4Py8RnFDtmVJK/G52P/nC1nLRarBAL6FgQiUvEFZt2G96a6wjHWDGSjqeC7iMwkSZQAGvHLjNGLiagVS0QDQnkTWbiSkcravVl8pCbBIlMihsEYYam0U9x5Jwm4s5eiVl6xSm6fBxOv/2rIAAICVOXHQKmcwsDjFJIBQ4MCB1rQQMRQPjQPC4NGQwVAxMWMoSFRJxB4sxL+GHEsAUCHRU/CFpQHE2l2G/gWalE00qd3UtU1KzmNP3Bs5J2WPQ5UcYzRRklGwYkJ1Dk0t7ZgrurIpNNWIFyhylY0aJIqMple3ZjQRbJlSVCwfDwXBh6//uyZM2EZiZhVJuMPtBSQ8ohZw9yl6mHUu5pK8FqlijVnSmwx0PE/UiWgFT4iLo31qEmUO01FpZ+ss+3Qrdg1OPSlGCZeSEsSsXJXFTOfeve3fhRdahiNIvtx6SDBAY3wvGZVppoHoCYpRmAlWQzJEBaggBfMskDCmKSBrJahhBSPjIXTFhBcxvnWqzud+W5RJvl2tZgeBGEU9xRZ79N6yeUOI2xIBa7m/dyfC/Kj4AKb////IBXLgBPkskyasjEoQM7qkCiQwyQjCI+CCUQB8oEJgwAGDAuJC4wWAjEQDMxszAgYkdhQGKJizANMQl7F0qGyhi7XXDRS48EPN1awyl+Hofx9XuhcbUpcCu2OPRp2WcNNbJKHkWLEn0i1ivSaqb4wa1U+hQuNUhqjBjXsELSAXaZIWHWuXGWFXSUYK6BoJvCRMKbEUdlRJcjyByJNRiWduF/P4b1/UFri5PYqxSqfyeZ+klfhvt7DcE0Tk1XU3ZNgAXgAVoJhAEQFmgdGX/EaMkIXwoqqqIIVqiAQLzHKItsYACBYoqQWcL9Qh1w1dBP5XKclRuJJfOJiTqvR6teHUkVtDVEc5fR8Hy2NVSyQweDR///0FpEHUioJUI8Dzt6y+byHjPvMowq2zJRMFEsYGFgOHYqCTO4CGReBAAAQOYzAYUBhcIxuE0OIiwBZD2xl4ioYROG3WFLMbBKqaCUJLEYdh+ed5S9W1+70Nu+0tXcdX62dp68XJhyFQWxBvmE2Ibls9O08p5f5SvO0ZTayqe9NYwOT1tg+AuxZuI7MXsb6GrmsHylo+WMlmotHZbz+p1mq6vwv2K6mGN/tvb4//uyZN2OxeFb0wuZS3RjxipTZfKIF7FrTC5hjdF+mSkFl54gfnJpO5MJzWnLGmSK24161p2Y9vT+yDIkrTVnXL7Ljnh/gsEH7ToP2M5AhQAQiBzYjGMQowjwUuIbgCICszY8HlC1YrAOFrvQ0BEEwDHLhGNJbUR+IhZXJfjaXlFEhG4YjQXtXmmyGOXsdyErD+A4gUDxw3//1ISgkjxfioVP+jypJwBBs+uxTHrYMXgk0SFzHo7MNEMwWLTE4YIBCYlMJbEBEgE8CrTboCiHACq0lWeAZQZBAAwF143CWoMtUTjTGIqlrWa2jTflUCxtr8+y8ZNFWzqzSh6X9a2XbdqBQGNXQzw+cxyhdx2Mrn8S84147/4WHYUusobLjS4+vMUC51lTZDfVNIzZMOIkjyV8y1sdQ/PTsyWRmYnqoNK8cfsNxpzu7WzBsJ+r55izC/IXzpajOsbRzHBWcQj87X19WjscIe3lbozcm44SlhaoxsrNGKTfg0woKMbAjQQIzwgFgwGlJYHTAF4116O4PhGEg0sOSeggIGRBebbBZqu0YmsBSalaXKkIyh8ARoYKwviXmcVrao2mpI3ZdOIBzMICuIfBDIfrbAXCEuUIBUJEP/+ofRcJAgiT0f8SB2LwX2IBpyY/CiHMKC4x0ETCgTMHjKlKxQJBEKC5oJICSWtpIa6/w+0s97gcqKgqXKBxHd2CnucN44hNtNcOgLhwS4tx/3Fqw9mlvCIozOVTj/QcwWmrsCWZuOTZfxyy7asVli2KXUI7k4TMup2166BpfeHLq8TRnjAF6oZRPGkzVW0pL+OkDiGvMMU6TIlWvct605BX//uyZOaO9itdUxOYYvJ2JknwbwqIF6GDUm5li8mumSiBrZXw+hazoH7l9tU2fwWjeu8ssw0km1u/PzlRxZiXDphoopHWlC46RqPgYq4AGb+UCIof8kcsmbU4dEKYgiY8AbyWChpd0QGwMPMkHMLvPcDSoGTIjGS+KFisSW9OgFCANe79SivSS6tEaW0xtlkufdUzQF55N3TBL6IoJeKZCRTB/KFrUqcOJQI3925f/8P9SxgGEhX/8Seok1UBgWP7aTA24QiRkpkOhwchjySNRgJCQEVlQMBwsKCQhGCzYwBBjOgKVWAISXORdJqgkLJgLmbaILshzMtpw3SXHSo1Kj0GXCCL9jhr5LTgc2IhBFqddJoL8uUBWtMNjWHjzQNDwSzARH0kEkF+WCGJAkc2OYl0rGxY7JZmOYhq29iRAumNIzzrKmY4j/CqfnZsPxDPDojnYkC0iSLHOfu2YTGftm+nY7F8sjocjmP5mPZ9e1nIsEAmHgNwbgmB8Sz/Fr/uBOH7zBmI5PA4p0nvmA4CIaVO0axiBYwwBPwBuCBlZnuYQAaBAQUWnkB8xWKF4AhPDqTBESgHiGECWUcFPtSZ9NrulT3MbnGh3//PfZ1//kq7XNeLB4n+ir2waygiRJ/u0kldzKU2Ypaoulbfs/rBggQC4bP8oMIrCo8RoxEAKLAJEkS9sMRsaYYZBESyRAABohRC0+LiIcS2EflHGNmKqIOLKlTJuyfftqj28YcKOErVvU5pI1aZF5bc3s8GEwvYsBsq4zOkxHT7vCNNJRGi4oa0OSNGkPM/nNKKhTqg9RnQTi8OJ47Cw3fMK25qmDMwQWVF//uyZNuA1tliVRNvZFJXJBpTYzgwGpmNXy1h4wFvEChJpmKIKFhYWViYVayMTI3zacG+8Sj9CYz6yKT7uEyLpSnp",
                "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",
                "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",
                "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",
                "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",
                "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",
                "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",
                "JKIQNBZSlJm6Kgar7cxDl6pbgtTYOFTBw6B+ONPV7b//jgiIACBAAAAAACYcjnmHnQEEQCUAUkMgFCQoTLZ0YKqmFqxhYM1ISdkgF1hgUAhlOF/RwCW0Abj1LaLJIsKE5igHcPoyjUPElDmTI4DJOIWRRv/7smS5APYIYlbLeGLwYkOJ8W9bFpnxi1etvZFBUpWpQZ0VsvDwUwakchbw3FCwk0NgmI6z8UjHOiVl/ApHas44mPJdw2aLqldYv2V3jS29O7BSh9y46ZdiYockQ/HwTQhB0DJLK5o/Gy6PicnMJ6S2u08pFbmna3Ucx2TM6t1r/5gm4kQnoYoMZYv0rWKNHj8CItscXWnjF2sReLZqzzxeKa8Sv7StUO+w3QTuQAkYGbDIAuOJIIIDGXCRS5YgIHVGEhQyBMEBxgYzaUxPt1wKRZMKwnCEYRAWlN0eX4Q2eo2CBHUdull7ikw9iUto8vqj////pgGIQ+oxAAAAmipj9WAqtBhMywcAkR0CDiQ8PaAMlww+kKieOghoyskYTtCgUw4gv6q2OxZybsYh1/o9ej8ZpHfjNflxkTTH+kjD4ehlYVdT3WHUppVE8y2qPSsqaSl0zWPQJ/3YlxfNHzpvVjXHJg3Dxy/EtWrnrF5DNmJutSnHuiCLzgTifJkdUWuRtDo59iQ4zczN+qpWvdLbP/3jpsWuRSaRRaImDioleUYiqdD42RMpEQ/Hmjxm8+JF1SxreRUxlAQAAAAcAJMtNOMymRiExQQoKBCkqREOpcRGrtb1ag6AqJDRlREMnxBirQy9Xqyj1tbgnMaDeX1LYYo0JROSfSUrkijGIdMqWnS4N///9cBBxLgCd/OpmwpN8Y4BwEMaFIWDZWKwoIDBJbDJcYvCBkyhwg5tR4ACmH7GJBjgg1VI1Q0omFgCnKtR2xGBcROVDgwNFNpZVDoloS3/YgXMYAhzcNpiKi3msJEJxJ1tzQGtdd1YJ0QWpClOiP/7smS8hFXzYtdTTE6wUkV6jGXiiBrxiU4uaevRQRWpSZeeImF1AVDW2wncjOwwIasQ1kUrM7cE5rK4OZtQ9fwr3GtHszkktWgvHFgNo8j5GsrUsxNpwl8VlYW4dNuUiFvWZtzDgxZI3n18xbxt2hW/+Mxq13iLe9qz601TR5n1YUtLuT+vfxvlspP//aFuSf+0KoBZTZfQKYCK0AAlqid1QtOEDTGCGviBAsAMlJXu+jKYLSKSoRujhcz0HQhwu7MXFYL+LqRLjX/nIaaXPuIzHWpSQxjwXZcJoxb///15IDkG1RAAAARHFA55GCAWZJEZjYTGOzIYTBAYCjB4TMSmQymFDBQwGIhgipkVgIIHQNgoyBIhnTKMoXAjA8VEtbAwNgyoW7OWW0RlRDS8SSL3o4MACiokANNXcHJFCE5QMDVG4wFDsrYGyFjzK7gwXxPNLfs6ia55dQpLDUOSoQXnRBKw4vGxCfKhxOK0A6Pi7QknKisQAY1jkFIlD2cLyabClMObgfXJ0dVh6ZPDgR87IY+x1nIKvvU/Pn56nTbJpDSZq11eeu0vevMkvXxIvLh3klHllgBwAAIYVUDCjBlCjwF2TsBgYsGIy23RsZSxQZBYiMnJ6gVZ3HfayMcnBF7J6nEOcSNMYnokeasH/JkozreNjxOG/klpKS/G/qpSm////ho4Az07YMlK8RA0FD0wKkjG4zMBDcBEAwsPAEijCI2BgBCh41QgNSojG9jhzRA4C5gNMbMzwqBxImmDPKqkpB1y16rSAyVlWaFzRISz0gVJyvw0wwJdyWhiSgoFLDLpKwskTTL7KNNGP9RsLm4Naf/7smTHhtaQWVOzmmL0T8VaU2XliBqdZUxOaevBRxVpDaSWyC02v2qioojn7UoFyTlUoetsJSoSqnrmXJJp9kUUKMxwY79WoUhlWhvQpeQ4ebKnToQ5SrRcVI9bIdGG75wfr2m+MrWOPSJLDhvY2deSFjc+vbGPTfh03rz38B/HfzQI8aeEp31svrM4AlUeQUd07ioxcAyYAxgpY5EgMkkCwYADULV4I7KwB0ACglRspBoVULcm8WtO1GBvGvSy6yHAiCNPqv/8+I0YMnDLYGQNNDINiD8MP///1bgCygAAADzmEBEaeMGgwKi4wuBjLgNMHgAOHhINDE4lM4AYwIAEljHhDQiS55kQhpAAKnmfKnKBBwgmLMyQiUVGhBfAhAw64DZgATQrCwAtIhITTEJoz4FWpXg6OTRRjMGSFAxaunRLWpGxoosV2QJISYqj84Ghm69HDx0YqEIliCJQ9ElBVjYzeLawRxmJS8l+hXVWPn3YT4bxA3Eg1TP+tWFQeyeDxdJN4rWPblWM2Mo6LbsYeOuXzqdP9Obec+bTNYodbysoUsJ33HW8WQG+fVDBIAHAAB4lSDBp3nGM6cWpZYWiQEmCtNgqZ02QFBKHBEN7lphzYjHQiaM3V+btuMsZfCXsoIDhAEmZOTWB2R0ksvsUuqJgvAsUSHMv///6uWgAwQYJ1/0GkzCYHBBgInmL0SIzEgjDByDQ8YSUZmQ2gZOGMAgYpHJikFCgPNUDEeICE09azthEjwRAochWk6JYsYBAAOPY+HrBQgCEJIszKJE3C5pnxNNcUgNcVpSXJNaPAKPtsXRh1obuw09RjLzUYIb5LP/7smTKjtaMWVObmmLwUoV6U2WCshrhZUouZe9RTRXoyaeeyKGZDS33ULirhbRaid5G0snqXc1LSGQN8mKZaoD5uZUmpVAp2FRqY70sXaO2H+1EIVS8hx2jwQt8jHJURFad7IbquWFOsnZ3jGqsR6RpIj3+v9c4+N+v+My+mrYzb1h0kh4y+3/8xQDnrIjEknUdVlVkWTNOKXUEPyIin6xtEAHDldBE5DFMURBHbaSwOGsOuZGWkSWVOuIQAcZTknH1SQfquWpqHAuh5rkzz9ONwZj832///9PGSwWDqgAAABzMKKzEYZTXpTAUjiZTyvTXRDXizGSCTabtYYs2aZGTnwdoEnB6dgKiBU0DaBnsREYZSY4zXHLUufwoIEQ4FBL0KPBjYOERsU3ZEXHENI0a36TosI4wVFRnWayASHd1grio+Q9Dk/Y7bdyK2IrlDMMxSMcdeGm6OM3NTaGpRVeRYsVi7tN5DbQ5nj7S12Jy2/kvgaEx1vGdwJKJxdjOIZkUoqvXEG5RmWTUZiGM7bbZ+GsvDKIvNSalqxil73LG3r+f//Yx//5//a3ex/v29X5NSQfejFJMvbavABUAATKCYIENPwCGHaILAsvEl0RQdusOXZCAVYyoSNxIPJADRAEMLri4SXsdUQ5Xi6OgWMBFHjH0YpcHFO5szlsQo3yenqcx8O2f9////XwhnDABmJMnGI52GBwEmFYcmFhCGBAnmFoChxNmAIHGIICmEI8mK4QEF8qBDKwUbDva0VDUnzIckfCUCsEY80TDIFeeHi1ZVFDQoEBV8gQKg+hNRYSNgtkzTocQAp+joJHxUSXiXyZQcP/7smTKjtbpV1KbushwUsV6U2XniBsdW0pO6evRQY1pAazgoEYq2qzbamfKW8BkZIKHKnCqQqEnGFHEERwWtdwFwsPSmXaXPNbHoZVtrVp/4jOT97EZFUQkgROUWzOEFzYjSY0OThLHTm3Q4WoxsqFXOKkXqbhSXjs2IGn083jf/3g/+b//xMef1hPGykm22A+TUJ+gTg+hsMlKpAQyxGSM5JHBw+lcwA0NEoCgteFqUBJBOW6EYI9cA3QEIgOmrfIuQy8zrtKf5TEYKkSz5ujKn+Rrn4lplFirKI9BrNZDWntFz//8OgrVAAAAOMq40wagQsElcGFx4YCKyIJgUAAQBkRlGSgJDlVEwSKy2RVARhUSGex+YkC4JBYsWQEFGIqteKRsqV4CAMnYuyJpcAAHJcrQXwx9eijju07cWbPWsdVaMEQEjypGvYunDxvrStiedPTxWJxZk6psKhsO5C1hLmqpGJGsEBybdP3kKC7iPJGurHEWnjaX",
                "QkSXNVyMx7o7VcrWarI+ZcOcyphYMwFdMihRTsvumUmMqP/6cf/nt2+P+/6htumkB1p2///+jBIwKCmLLHRIFEGsmAEKY5wOpg0CNCmN4DgQN4CiguabgRiAn5WEZyElAAqQKFFAuB11JmVgXidL2dwiolhwOy9rkYIghLVALWfJ9CbGGwn5F5fGPCTWyACC+aQjxlgLCwPMJiQAh8tClUYwBgNBpjsDmFCemGXuBgTMoBp/QuaCNh4GCXBnRYcAQnQyjizhNFrjIlSLYUuJgypYGUMbyNQKoKgniypUUkLWXLfgYYBNvBs3DDw0i65dNck1JFaeUUlFTv/7sGTFBvZbXdQbj06wUeOKMGsvOBnxd1NOaY3BQg4owYy8OMo4sKQcoySTiauZOlRBaHk6u8vpHjiFkrS1zV0yQjISxccnzLywirWimrOI7QG5OKhGEBcfqLnj8RvAqfbXcfZMzO7vzMw1PZ/JvOF8vDmNSg6aLig7qvP/bjn4DsciaDRciIQiKYETOXkL2i8wq4mEBAwom+x3uuiIAG4IKAkw24AEkbtgGUQQMY/yTToYsiFog9BAQcQhyEp0pI5yj6A5i4JE+lEP8jQ1yoIU8TprREim1QAAI4HVxU7GCASYcEZiA2mAieBgWChSW4BSfMNjMiJAiDJAAjG5DBgZMOEYKC82AMTBAfdZiAlp/13KnSvSVTGiyMj5EJR46grAVA2ZxkdeHeSulYNS1+QF8mKtAVE0hWqCLiekBNLoZbSRWjfSVUUASh57c3DdeZWu/EEwY/EFRZ105MLp+YlPmuQl65ZI9E9xbH1h7FoNibA/AdkZ1Youha+y6fGBRiODsroEaZp5jYNi5rLUnpprVPya/Z+/ze/5aNcUlv1fbshm0sxzOPbejPKlYOZc+GtU3wrdGQgTfMafOEuDywFeA1M5yjnLQEATMLyHOSDWDCRWELII6uPYlygDvJOuSuMRVNIRVh9TbJu6eRKQ3VPlfzJ2168J8iSckWmFlhfVIAIS5/1sYg5hCQOjRhAQYKhEA4LAZANGQhAokmCC4GAU6zDhoHA4WCjE1+Ljp4HIDGpltYbWtLocdVEYqEIwIoERz1UsPP4zsqDjQTLIcLsPfEEtlB6JsAiGna0lZScYRaWo1VNGv4xUtY4SUo8Gxb5A//uyZM0G1pVd05OYZGRVY5oQay9cGRV9U03lj0FLjWiFrODjX0O0QpRCFAno0kl3oKqG6zYxX1B+BurA5pHll3SvZ9dRseVQ6MIYYls2adR2tq3H1z7WOXeYvXHcysV1vLHVreVZqVi4lS/oSrBpKTgORzM52p1dNO1Aqcu8m8cWUIjwEeGLHib4y5zHuBex+Gjh4+gVUhkA2KQwwbXApJdMtcrlD6LSiJwE6icjxjyRCYaAn9JIfvNFHRLbY7dLAWgU2fyQvkmY+aQosNVQAAAALh9amaQRCQeKAJVPhI3MIAaQhKCItIjoSRxCIxo1R24DDg5iHXK1h2DY4hGp5PmZXSudq6wStAWIRGYHEH/5gQHKfVv45ao8Eqh4tIt7IvADZpat97LcNMlTbB86UIC8yyAFjELskeK0IpXaTYQqyWKSiqnrXderh8yOyUQ4hJ5GHLG5mNXGzRQUhFUIl0U2I965vs7HKZ1DJO4pOME59vrEppZlHJHZCkikywz21HT//7/B6XYwAL4ABhQj0CBBpNZkiRjWxqm4qOBjMMPGQFnHEKVmYHmGSg0UKDDS/gFwYTB+jj0TNH7hDGFzqqwWnoRDNBYURKo4rCR65OuHLYS+iulW2rOqjIkIHGxoyX+N9YIgJCfF0QycVQhLWFvjFBMdBEQxwGMEAgwBR9n1PBh5AiUwCCwfwBGAgkDL3ASyuYT+WIKLT5xGM3pspFe6BxKY8mUNYvq7SArUDDElQuCxJJohWiV3fd37++JNOm55qmtS7fttYrlKzw8X1XVcw429Z3XerVxE34O4996mf1klmjtcdabZ1znEB962iekP//uyZNKGxdZfVTt5SvBbY2oTY1kMFp19W7W3gAl2lWlKs0ADWb11D1jEXOs0rX3tvNs0m8HbXt3qvWk64L2veJpwvHcIWmLVoAgCAApGvI9EvzjgDUgHIsAYqZ5I1Sl8mAy421kuAKSFYACwIARwJCgRFh4E8pj8OeLGL8fxPhEEw6URyQAdhgRgoAcBoNQiIz5UlAgg+BjlFAnD7v/+pAwL7qb+svh6AAAwQAAQAAA4MH0dMWRVP0TsMZT4NvSDNNxdMqyqMBwUMCSCMbjfMaSQGQ4MUyoFAPMfydMfkVC6UmBJknvsR85kaoWm0Bxo4ICpQtGPHxjK4YENmDBJlisPERgxIOkBkIgDBQKhiE8w0VC4MGLZiYWSBwVARIaAwoYwLGNkAFAkfX5MJFTECoHADjT5kQ2mmYMAL3lq5ZK4bLF2PzGGoIc1KGciACbdkqCcv/Tug0tMiCI08LvrtSjRyfiKQuEsDlJfdZ6cLN4q/7X1XvJQqfZgo5NvWtVE+AS+TKYqpe11i5AAMEbsWXRpYchgvRTNwW0vO7HXZjVbN/5UhOemKuLdwt0nyiVPCxBn7SmWOwhW8cLCACCX+YcgsptFpLallWQv5Xv9+G0dkt2JOtDkPvBROzMyjvf6YWAsuc1/0v2nqaLkag5EORTphKMhwIW5UJ4irswpAM5NJIyjKs0wEY4pIMxkX0z2EsyvfYz5pM3EKw0NV00xnY00SY2hP85qJEKhwZrD4Y7i8aCA8IBCMIweAgbmG4TOYYgBeYyjwYUAiUBcYDBeZVCcKhgLBAYJgUYcCWBA8MTRBT3MMAcQBGCofJpGDwPCQ0BU//uyZOWACk1l0c53YADNZilwzvQAJXWVURnMgAJ6GGdXN6ACHUKvMKAsDkJMPAyDA/4YMAsYchiYCBKLAln+4AAAEFAAOL+2yIxjgA3PuL7EgbHgvceLCgBgII4/v/kLGg4H1xZf7rhUFxIB0I2v2wAAAK8VAADNU9ORow+lviLznU+6ZQLRkI7AAQGPgOYaARisWGEQMFggYpIJjU0CMkmPwAYuOIfWoIYsi4wOq08xBUIjRKLJs8NdAGAhHBZk2gTHHTiMc0CBMFS4TCATKEweNEhTLABhMByxfBgErqS+l0vMM4t9Gs1U1ZWnoCS7S8oU4kBPxEXZb+IqAQc09rKTzIS4yGAQGsgQjxhL591hlXvouaDZO4KtMD4QPUkCwDW0S5JTmEC3Fu7d1bYnQQ05MMzrqPDDTvJbVZVSuRC3IvOOLBuwnFJVluoieumHICepdrhNzjqlt2PwXJqeR0sce6G3bXI5DzFAxKAjk24qC3NDdINUisLW4ChO/dh7YhKGe0zwzMVoLMzj/vbGoyy6XSh6YzG4xGZJgAAIAAAY/SiL+MiZTdDUcLhI2N1AjOUUwwwMBKDDGs0lSM8VDK7URGRwECa+PGjGx4qZwQZmAgWkgQUb9GEDTFkwa8AIYFGTZIC4wqCHG0yFCQ8CCwgmuKBAAGmQUUQIEFkSrwgIaQwu1f/THCi4wYDad1ARPI5y7n/VAQRNeR/uCFVnEtf+SPTQPuJCL2JhU136URgEck+v/7URYNC+VTBs1OorA2mBC+IQdRAQTBoEDgoWBAAAqYDA4ACgQCx0FBCES9AILMZis6U0JSOIoU5DvqWrVZDK//uyZBwO1u1iVIdzIABXIzoy7OAAGPmLUi3li9FRjWhBjWQoGwxhYRWOOMye2/J3+jyVbuStBpdLotdFC46/CUioYm4NmB7WqR/qb5VFIen6lSJ8jOdyTTsvkdW1b3Vn7VHOTc/CJmCIjKc43MxDV976bkjjMTxwpp2HKaCHtfGWWJdlfiFLqWW56/SWpVbmqu92q9Wrev29WYxF8IYtzNPFLco1jWv17GNPjlSyibtY2uQzT5xmRdxs7tW8a/aljmGc1au9xzoIqBgAAwMhJMZM9xkFDTrMAFMkcPNB874QWwWkBQY7S76QplpmNKIogmo+",
                "28UYkygvypdBTgw6nIIDLVpcr6qSnTOW2mLMMseXwnchDAstuh46j+Ifg0DQdCeUgnovRhweYoLlg+MkJgcFkwwOkgBBgYLGHhoKCICDd7CoYEAAEpFGzheJhlskf1aKxJazV98UulZSqC050GxwxLZtPaisOUjhGYdHRk5i1qjTW33uRl71MSMyYZOzUziSSlc+iQuUB1EPVTE7XNriMnWFUxRVQ10tM4sfgeOSGyYnkCE8dHStaoTRPKl3KbK6mR04VH4b2SNQ2dbjeWRuz+1dlJaFdrRd9qnVUS8b1XP3h79LKg5dt9kpfJEdcumTv0nMyBrwEZL0KAjiRR5UGfUB5ErLIiIYbKOb4aIDw8sNxAUAC1QISHJj1DMkEhFTmjasAADf5frYk4ou9ZZZPB4YtKn+gBsqYD8QcKiLPi7/pDsnZvDjJIRWJiAgAJIp81+KNvEzLgIAggXIQSEGIBCsBIBEQsFxAwcgW3QhUgjAkEgEJDhBdDSHyEltGLi5//uyZBsE9eBi1tNvTEBWo3pAazgSVc2JWO2kewGzFWjBnb0wS3oTxIjMR6pkjTw1ZSfSHWjmQomgmRzWpM5H8SPtKHbHCkjBRSNn6J4icPmjSECLNFdKlGhEu1arlefZufDbgUgZpotbjcEXlfSpqS+GSLAsK5tRyjl+Llva3ZlGcoIXQtVmK03vOCm0k2n+DkJKAE6D3ZB0KMjMCIEkBQFyAFGJA2JQ+i2rUQaMzMgUkwIYVfucB3pDnpDcwA4gIogUTAmgJsMEamjr2gU6Q6i8XsUy/3xd5PVA9gCQkmmYmshZLIZxQ1f02sDK2XP8zxZ0Ir2DKWz/+BeIjSO+OHiAAkhOmVaxj4EBmEydDMYHQCMp8F6HCBRkMDAceKXyIwgPfAKhYCCxEHqVNoydWGGX5sxeHonVaK/KnnxfyJ5ynDOER2Cnyk8uV256/25Zyi1Uw5NE3baRp7lkBZiEEKAnQnzKw6khI24SfHob36xJiVsxGmyNEjq1l05vRpLnLurOEoycbKihIWKGIbW14/3HPKqlTfHaq9OCHtqktBBRgMPSF0gwRRceYUsOuKLGmZEYXYsoZLprengEiMaQ5MdgaZTfARgZOtsfIgUw6INJOAEWGJBJeh6RgCSKam97K1V1nsDHgchByYOL+vi0A6zwFEX2KWq5IIzk6FwLYA1m8XVZX3q9EzD21vlj/+RxlZ4rH2Tcis/+HOruAABzazA8AFDMkzK9MFGgACBgUZaKiETAWOgCAweZQFOUdgZoB7hjxwyJ1BAClDiIyqq2k0bdtqTsscAyLWVww/dg220dWZUvYYLAENJ0LrKFl5IWSOXy//uyZCuP9dJaVBN5YvBtBVowa292GHlxTg5ljYGMlWkBp5og2UomFjtKHtY2yEcq3UpYSnqCsLQXMk9KI49nSw/OFP2+nLF1EzKY5Lh0kCgfCUacrta6lomrj2/vw3izG1zjSH8L2ww0y+X/Ky3m9k33UUNaf/1cm/Z3/Mt3bmsyzYkV2GDyb1RsaXJfgwAEqhz7ABUCaEsZ6mkgBRTADN2C95lwYcOOaHkTAcOGNhhQUg0EpEJlagaQ3EuuPBycjDlmMPdMWQ72UnRUGgJ8wK1CRNCMkycy5aSMJ8rEeitNbI//+FIr29SKZfnYtXOn/yNMjsxVrTL5zMuCIxYTDNZ+MFkBAKCQwYDFI0SjBx6MECgt0scw4ejELOlwxejyjRTWFBIrHi3Kp4Xeac7j7pjKqKbo6pztcquY57c2sOAna3JkKPiXoXJACimgRC3b4w1wyTxxOsGyst3SS2hWeOiquOFRuoNEFBM6F5WO/Wt9uQXBT8CcIxAD0vAgo+hxQxKxUOjZ1SefKqnnCSA8s4pZiTmTamKlEf0lZRiFuuPvv25m78u22t6fAzO/MrIKfM5d6mWi5GtckpC4UwDsaPEJoEEjmAUHBIgOPUJiDymALmIJhABMYVPEhAo4FKF/E0N4TBweKVhH+bpbBHlAgVyQY6ZAbyCDROgpTCZ3E7k4I4PVFq1l7LMHAuOol/+ONTAJGA5uS2/0kUlVAgAAAEAF07j4NpIzVgcLWCFBjR6QDJgY6YIOgInJGYxADIoX0IWAfSJJh04IKLipqFuk36Rl0YY9TqZuC1iDIeXQ4Di3o+2RgKN99kD9uBKE/gMhHhoV//uyZCuE9dxc1NN5SvJdRUpQZeiIFb17Vk2w2tFrFmnBp4ogLRwJypHJNMwqLS0xEhWaQ3FVfosc2dQFWk4oiqbGdOxk+9RU2JRIK5BFQByY35YkLsDjEals1tagQp0RKmHojSibyRly1KuRovXQu7kmiQuGl8UzEknGJRntPba9ZJlpO23Rbbdl+XcMjgCAGCGIJjHFf86YgFqpEhDGZjplZAYJp0cF8SzyXhnjCYoogBvLzsSRKGM7CqJIyMAdGgQhfFOWEqzVutGnFHIX5RuuiFc8P/i9QtCCJD9AxZ5FfpbntmgFBs5k+NMNxY1MhDzIC0IFVzGFhAwDIxooGLgSHAtwCGlH560Vy0qXKBJOefXawZ9LM0uV/m6P473uVyB6jpSl5pFAkCPzTRijS7gRp85QzMHiKfMpHlt2TsxQtz86J23rTrDKim1P++9ON0O32qlyFOTw+gKGHLKJbq9965Mqsc+bbyx14BkUy1CQm8UnV8g8JHavwhBEESksip+SSInOSd9e4N7au+HQjCNllGOBCIqLW1CAsLQWKJxe8xoUVChB5ra8RMm25IBEAgWHJ2DIUBARJU+xvFMqkmlS6EFKssCEucHlE6NxGJuAZC0hx/Jhsb9ddRwMMP1BUBhQJ0QqCVEtxAIpwXBqEAACiFKY1pgFHL+mKPIXATDSQvQEGiUSQQNKAMIK1sNBikAfnCC3IcJiHSWBLEyVTqaVFH6rzxTbmoV2yR55o52nCP97MPSJCbw9BwQ4bxhBlaGSko6LvFQnqPhBolROc6UOiul6jnkzlskBhSMEl6MuNTsiRHg6lJHsvf6dcvqDstGs//uyZEIA1TZe1jtvS2BbZWphZeaIUpVtXu280UltFKnFp5YgOzZtl1wvZG0B5NTItlSqMuMG5Jax4/POp1GOfsbn+t/O9uwga+2lCdH5bsyCk9xuYYHByRnBiU6UKEtYR1ljiNUSbUENcJpA1iam1k31ctqZNKMkbIUEQ6nSJT7IhDkOqY0lKpT7Ictfr0dRsf/z2P52IskLIuC//oQjI34KgGACbTnMokjBReLmBFAFCACEpiIkkwKDgkWAxoFWi/IwUprNqQgbkLttMOMNDJ0/Fs/hVqhZzK6XcWdS95zclgF0LTbEn7T0frOo031mLjWJ3SHab7yNBiyyNkfZDf/dfYkpKEnPWlIdCtOY9Eqp1N5/xo+0lWmlNMs9bN7iqrwlzxWhZRDSV9eMve/r/3+ij2XDTpxMZpWHCNwYEOCjRCBUwFQJEmMJEQBCAAMAzBFkrFil9gVcY4l6OAmdJnJAUCMLNCRH4AU5YlCpV1EMxJoWlT2RCbuhSYFWOVDd+zmpS/5fqUIumrhMAHRCb//pABJBdOvXzPDsmYjKzglIgcagYKDAMWAgYAiA5EhtW5tzlob8yAzCjQGQlsy4WAv87r3ZT7i0zdHBgKGqCgwpJlRR9mrTYkTuKphq4blyAoI3EmbCNzMZdmLdrVXuH8k1cj7dXXWSbxZ0KQkSSFdkgMCtqK5NJDZ/Fn43jv9r/Op8/j0tm3u/x9Zjo386FrUDbdEk873ydQ/z5eMQ3bACIHAZjeZSY1ClSSIQoBDyhVcgw0DrRkRIyEBSEZ4wMYAISjjtAW4MKhKp1hYg9+nlitZxaFW0mHwDHJG4FkhQ1lCw//uyZHCGxOxRVZt5SvJpJ2pDaeWyEVlHVu29D0GqHemJl5YgqFzNuU/zXFlLp+vrpv/wswvqPA4uOsDBwDhRqCxH//+o30LGD0iAJ856zIhcWQguDmEDYgLE4Qg3lgYQrMVhZCzExAVb8DCo",
                "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",
                "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",
                "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",
                "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",
                "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",
                "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",
                "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",
                "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",
                "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",
                "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",
                "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",
                "EiRLg+MudAD9suf+s/MQt2HYX6wFaIhVRpOFtoWFoEw3OEIXsnFhYYdj0nQaD1msrlImYzKd0z1sTiKfLqE1xUzIyuTVHO9qUJcCdxkYoizLcyWqrVI3IYQw545TKCz1whq1WI9ugHIq8UtP4m7blzV7VnftkV2w//uyZOYANd5X1UtYYvBnJjqgYelsGVFhU01h68GGn6rhhgo4OvHi2eWh4tvL2rPmm4VpKyMmXH/yVgw10X14hii3UCvDiwBEUmx1bB0VBhDNVqPoy5P81QjSmgCbFIbXpzdnyGXqFN3LWuNI/qkRvriUoBO4IqQ6gCgtlxcenSGXmxFae56c0qPn7qZQnnXLMf1rWu7RlXlSE/f2XcatZkT//+xCP4gHABEVjBIWCwzU1FQYxgTIhgzh6A0CY2AiY0EiIOqoIakEgHYCjNswAMkIgBZQ76oX6gotzJIwuUqnX6+0te+Nw6wdTUcODisLMbEs4ZOrmvkiS0DCnYX8rAOwOK93Is0Ceq+4PEkuRilzRSkcXx3KtrXayuCeMi3EYnSnISu1SlzPExMYDY/2ny2spzpEux0D+whTgW4x8JE/TvOpCy9wl2o0s8so/iG/nka2+0qnnu3963NSvo3YzvGqH9JN/5HbY/lf7vvbtsu7u4vpWcphhRA0AAoqRYUiEwGLrMwISt447BZtQYJFGlH7d/vPxvUH/++1GYutWtSq2CRGDgsGhA9cuCaAKI0CFoNaHzYEnhAVPkxlhCgT0gFQrmRRRKZ+mBARJxYxDsEESI3//+GHDfHfBCaNOAKDAIUEoQapEABrgFimJOAIgYO4nOYg2YEKAgqNSSSE+CxwaiahOZQ2FIKKablAEORlhLlQmakb6M7XfBrWzACUb+BUExBfLLVAZtVj0tZexYLkjI5xoxOKKHEZ4bedV30rG4NTJHrQ/2KJVVRmZRbiNChX22Aei3tdxnSUP5dGGQ0nplLL5RbP9pUz9KMLetx556vm//uyZOYHNoRYUwN4evBiR/q4YSK2F5llUK08WwFxmCrhhhnw6RiiTpJjswqw+E8+W4M8aJbsLARCC9GG8MRVg6uGKJ5AKNmgwGAl1dRRbwXSOfdmG3phMkMxYShmIJtPX7JO5XKEfKZnTxtAaA4sP1UfNCAfFF+E9VnJ4OR2JBKYbONLKGnKph7LSJeciS2KHBytHD86X/U4DGluEe55Ql3/ktcAAHM0U4WQoMDcz+kBrRwgmECY1YFRJMNETeAAeuTKEkwsNMBGS05iYwKC6SxagDCaIRdhUAsKiksq6KE1yXOxfGvAQo/j/F6OIkIXINAoRyEcPwA4DjJYkRODdJ+zlCaxPxSlhkdOahjK47mosaHnW0qh+dDkXlzsS0YqFHtg5W+GqDpbihXMYx0OF+wODgrz+7kd2VpSncdNVMT0/ycnoLqcSiUli/xFFDbFyntR1HGTx0HWX5XsynnexfBqqWFxZ2b/ybVFN+7zTVZU+r9jUr1Yyq2Jl6E+FdzROoAAA81Ig04aqTSmnNehDqKxJbF3kAoo4+36HMMM2/CaXVMdOv9HSeOlesx4KuMAXU6zTQ5HGChzGSdNxSeKpVsSIQl4j0dN4apzRoB1k604lohFhvjt3MZ6Gzy6UvIUctJCHCgQcEEgCEjDKgbgMoAUyNW3MugVVPkpJCxp15p1iSbOTJgFcipR6gw2EfHg9H8ZKoHzKhRtog8RfISb8JFnKTsD8njFPAnkUthel0qWBEnSp4aRFLfkoYZ1McrMiUuu4SsViw5nAaJkQk8fagQkIog8VKnCciRJGiIwBAl15woFAFPEaRyI284KhSQCqA+K",
            }
            local writeFile = rawget(runtimeEnv, "writefile") or rawget(_G, "writefile")
            local writeSucceeded = false
            if type(writeFile) == "function" then
                local alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
                local charValues = {}
                for i = 1, #alphabet do charValues[alphabet:sub(i, i)] = i - 1 end
                local encodedSong = table.concat(encodedParts)
                local decodedBytes = {}
                local buffer, bitCount = 0, 0
                for i = 1, #encodedSong do
                    local char = encodedSong:sub(i, i)
                    if char ~= "=" then
                        local value = charValues[char]
                        if value then
                            buffer = buffer * 64 + value
                            bitCount = bitCount + 6
                            if bitCount >= 8 then
                                bitCount = bitCount - 8
                                decodedBytes[#decodedBytes + 1] = string.char(math.floor(buffer / (2 ^ bitCount)) % 256)
                                buffer = buffer % (2 ^ bitCount)
                            end
                        end
                    end
                end
                local writeOk = pcall(writeFile, songFile, table.concat(decodedBytes))
                writeSucceeded = writeOk
            end
            if type(getAsset) == "function"
                and (writeSucceeded or type(isFile) ~= "function" or isFile(songFile)) then
                local assetId = getAsset(songFile)
                if type(assetId) == "string" and assetId ~= "" then
                    sound.SoundId = assetId
                    trackLustConnection(sound.Ended:Connect(function()
                        pcall(function() sound:Destroy() end)
                    end))
                    sound:Play()
                    songLoaded = true
                end
            end
        end)
        if not audioOk then
            warn("[KAIRNOX DUELS audio] " .. tostring(audioErr))
        end
        if not songLoaded then
            sound:Destroy()
            warn("[KAIRNOX DUELS] No se pudo cargar la música; el executor debe soportar writefile y getcustomasset/getsynasset.")
        end
    
        local skipRequested = false
        local lastTouchAt = 0
        local touchConnection
        local function finishIntro()
            if touchConnection then
                pcall(function() touchConnection:Disconnect() end)
                touchConnection = nil
            end
            if screenGui.Parent then screenGui:Destroy() end
        end
        touchConnection = trackLustConnection(UserInputService.TouchTap:Connect(function(_, _gameProcessed)
            if not screenGui.Parent then return end
            local now = os.clock()
            -- Acepta dos toques en cualquier parte, incluso si la GUI del juego los marcó como procesados.
            if lastTouchAt > 0 and now - lastTouchAt <= 0.65 then
                skipRequested = true
                finishIntro()
                return
            end
            lastTouchAt = now
        end))
        local function waitIntro(seconds)
            local deadline = os.clock() + seconds
            while not skipRequested and screenGui.Parent and os.clock() < deadline do
                task.wait(math.min(0.05, math.max(0, deadline - os.clock())))
            end
            if skipRequested or not screenGui.Parent then
                finishIntro()
                return false
            end
            return true
        end

        TweenService:Create(background, TweenInfo.new(0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            BackgroundTransparency = 0.18,
        }):Play()
        if not waitIntro(0.3) then return end
    
        TweenService:Create(mainText, TweenInfo.new(0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            TextTransparency = 0,
        }):Play()
        TweenService:Create(mainText, TweenInfo.new(2.5, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {
            Position = UDim2.new(0.25, -170, 0.35, 0),
        }):Play()
        animateGradient(mainGradient)
        if not waitIntro(1.2) then return end
    
        TweenService:Create(discordText, TweenInfo.new(0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            TextTransparency = 0,
        }):Play()
        TweenService:Create(discordText, TweenInfo.new(2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {
            Position = UDim2.new(0.25, -120, 0.5, 0),
        }):Play()
        animateGradient(discordGradient)
        if not waitIntro(1.5) then return end
    
        local fadeOut = TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
        TweenService:Create(background, fadeOut, { BackgroundTransparency = 1 }):Play()
        TweenService:Create(mainText, fadeOut, { TextTransparency = 1 }):Play()
        TweenService:Create(discordText, fadeOut, { TextTransparency = 1 }):Play()
        if not waitIntro(1.1) then return end
    
        -- Al omitir la intro se destruye solo la GUI; la música sigue hasta Ended.
        finishIntro()
    end
    
    local introOk, introErr = pcall(playLustHubIntro)
    if not introOk then
        warn("[KAIRNOX DUELS intro] " .. tostring(introErr))
    end

    loadExternalUIImage = function(inputValue, secondaryInput)
        local genv = getgenv and getgenv() or _G
        local value = rawget(genv, "getcustomasset") or rawget(genv, "getsynasset")
        local value2 = rawget(genv, "isfile")
        local value3 = rawget(genv, "writefile")

        if type(value) == "function" and type(value3) == "function" then
            local isActive = type(value2) == "function" and value2(secondaryInput)

            if not isActive then
                local ok, result = pcall(function()
                    return game:HttpGet(inputValue)
                end)

                if ok and type(result) == "string" and #result > 0 then
                    isActive = pcall(value3, secondaryInput, result)
                end
            end

            if isActive then
                local ok, result = pcall(value, secondaryInput)
                if ok and result then
                    return result
                end
            end
        end

        return inputValue
    end

    LUST_HUB_IMAGE_URL = "https://files.catbox.moe/ewsprh.png"

    isConfigReady = false

    pcall(function()
        (getgenv and getgenv() or _G)._LustBootDone = false
    end)

    do
        local primaryValue = 45
        NS = 16
        CS = primaryValue
    end
end

uiScaleValue = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled and 75 or 100
floatingButtonsScale = 100
qaLocked = true
qaFrames = {}
qaDefaultPos = {}
showMobileButtons = true
LAGGER_SPEED = 30
LAGGER_CARRY_SPEED = 15
speedMode = false
antiRagdollEnabled = false
infJumpEnabled = false
laggerToggled = false
laggerPhase = 0
medusaCounterEnabled = false
medusaCounterBlocked = false
medusaCounterBlockToken = 0
batCounterEnabled = false
batCounterV3Enabled = false
batCounterVersion = "V1"
batCounterVersionHighlight = nil
batCounterArrowButton = nil
batCounterDetailsOpen = false
batCounterDetailsRows = {}
countdownSoundActive = false
countdownSoundConn = nil


-- [Speed Bypass visibility flag]
local showSpeedBypassPanel = false
local instaResetKeyConfigured = false
local instaResetKeyConflictDetected = false

-- [Auto Carry - ported from Yout]
autoCarryEnabled = false
autoCarryMode = "On Pick Up"
autoCarrySetVisual = nil
autoCarrySelector = nil
-- [Anti Ragdoll / Drop Brainrot selectors - ported from Yout v15]
antiRagdollMode = "Recover"   -- "Purge" | "Recover"
antiRagdollSelector = nil
dropBrainrotMode = "Jump Drop" -- "Fling" | "Jump Drop"
dropBrainrotSelector = nil
do
    local primaryValue = false
    espEnabled = false
    espTracersEnabled = false
    ragdollCountdownEnabled = primaryValue
end

do
    do
        do
            espArrowButton = nil
            setESPVisual = nil
            setESPTracersVisual = nil
            setRagdollCountdownVisual = nil
            espDetailsOpen = false
            espDetailsRows = {}
            espObjects = {}
            espConn = nil
            espGui = nil

            do
                local primaryValue = false
                medusaCounterDebounce = false
                medusaCounterLastUsed = 0
                dropActive = primaryValue
            end
        end

        autoLeftEnabled = false
        autoRightEnabled = false
        autoLeftSetVisual = nil
        autoRightSetVisual = nil
        speedLabel = nil
        ragdollCountdownLabel = nil
        autoBatEnabled = false
        autoBatConn = nil
        isAutoBatBusy = false
        autoSwingEnabled = true
        mirrorTPEnabled = true
        unwalkEnabled = false
        autoBatSetVisual = nil
        autoBatArrowButton = nil
        autoBatDetailsOpen = false
        autoBatDetailsRows = {}
        autoStealArrowButton = nil
        autoStealDetailsOpen = false
        autoStealDetailsRows = {}

        do
            local primaryValue = utf8.char(9650)
            local secondaryValue = utf8.char(9660)
            AUTO_BAT_ARROW_OPEN = primaryValue
            AUTO_BAT_ARROW_CLOSED = secondaryValue
        end
    end

    do
        originalCollisionStates = setmetatable({}, { __mode = "k" })
        healthLoopConnection = nil
        characterHealthConnection = nil
        healthConnections = {}
        isHealthLockEnabled = false
        showUIOnExecute = true
        setShowUIOnExecuteVisual = nil
        setShowSpeedBypassPanelVisual = nil
        isMobileDevice = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
        setShowMobileButtonsVisual = nil
        setLockMobileButtonsVisual = nil
        _autoBatHadTarget = false
        AUTO_BAT_SPEED = 58
        LAGGER_AUTO_BAT_SPEED = 45
        getAutoBatMovementSpeed = function()
            if laggerToggled and (laggerPhase == 1 or laggerPhase == 2) then
                return LAGGER_AUTO_BAT_SPEED
            end
            return AUTO_BAT_SPEED
        end

    do
        local function featureHelperB(inputValue, secondaryInput)
            if not inputValue then
                return
            end
            inputValue.Visible = true
            TweenService:Create(
                inputValue,
                TweenInfo.new(0.16, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                { Position = secondaryInput and UDim2.new(0.5, 4, 0, 2) or UDim2.new(0, 1, 0, 2) }
            ):Play()
        end


    end
end
end

do
    do
        normalizeBatCounterSettings = function()
            batCounterVersion = (batCounterVersion == "V3") and batCounterVersion or "V1"

            if batCounterVersion == "V1" then
                batCounterEnabled = batCounterEnabled or false
                batCounterV3Enabled = false
            else
                batCounterEnabled = false
                batCounterV3Enabled = batCounterV3Enabled or false
            end
        end

        updateBatCounterVersionIndicator = function()
            local amount = batCounterVersion == "V1" and 0 or 1

            if batCounterPillRefresh then
                batCounterPillRefresh()
            end

            if batCounterVersionHighlight then
                TweenService:Create(
                    batCounterVersionHighlight,
                    TweenInfo.new(0.16, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                    { Position = UDim2.new(amount / 2, amount * 2 + 1, 0, 2) }
                ):Play()
            end
        end

        refreshQuickActionVisibility = function()
            for _, primaryValue in ipairs(qaFrames) do
                if primaryValue then
                    primaryValue.Visible = showMobileButtons
                end
            end
        end

        primaryColor = currentKairnoxPalette.accent
        secondaryColor = currentKairnoxPalette.secondary
        tertiaryColor = currentKairnoxPalette.tertiary

        LustSync = { drop = {}, tpdown = {}, float = {} }
        LustSyncSet = function(kind, state)
            for _, fn in ipairs(LustSync[kind] or {}) do
                pcall(fn, state)
            end
        end
        LustFlash = function(kind, duration)
            LustSyncSet(kind, true)
            task.delay(duration or 0.22, function()
                LustSyncSet(kind, false)
            end)
        end

        createLustPillSelector = function(parent, width, options, getIndex, onSelect, displayOptions)
            local w = width or 98
            local pill = Instance.new("Frame", parent)
            pill.Name = "PillSelector"
            pill.Size = UDim2.new(0, w, 0, 24)
            pill.AnchorPoint = Vector2.new(1, 0.5)
            pill.Position = UDim2.new(1, -6, 0.5, 0)
            pill.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
            pill.BackgroundTransparency = 0.7
            pill.BorderSizePixel = 0
            pill.ZIndex = 30
            Instance.new("UICorner", pill).CornerRadius = UDim.new(1, 0)
            local pillStroke = Instance.new("UIStroke", pill)
            pillStroke.Color = Color3.fromRGB(50, 50, 50)
            pillStroke.Thickness = 1
            pillStroke.Transparency = 0.15

            local function mkArrow(text, pos)
                local b = Instance.new("TextButton", pill)
                b.Size = UDim2.new(0, 24, 1, 0)
                b.Position = pos
                b.BackgroundTransparency = 1
                b.BorderSizePixel = 0
                b.Text = text
                b.TextColor3 = Color3.fromRGB(255, 255, 255)
                b.Font = Enum.Font.GothamBlack
                b.TextSize = 12
                b.AutoButtonColor = false
                b.ZIndex = 31
                return b
            end

            local leftBtn = mkArrow("<", UDim2.new(0, 1, 0, 0))
            local rightBtn = mkArrow(">", UDim2.new(1, -25, 0, 0))

            local valueLbl = Instance.new("TextLabel", pill)
            valueLbl.Size = UDim2.new(0, w - 50, 1, 0)
            valueLbl.Position = UDim2.new(0, 25, 0, 0)
            valueLbl.BackgroundTransparency = 1
            valueLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
            valueLbl.Font = Enum.Font.GothamBlack
            valueLbl.TextSize = 12
            valueLbl.TextXAlignment = Enum.TextXAlignment.Center
            valueLbl.TextYAlignment = Enum.TextYAlignment.Center
            valueLbl.ZIndex = 31
            local function shownValue(index) return (displayOptions and displayOptions[index]) or options[index] end
            valueLbl.Text = tostring(shownValue(getIndex()) or shownValue(1))

            local function step(delta)
                local idx = getIndex() + delta
                if idx < 1 then idx = #options end
                if idx > #options then idx = 1 end
                onSelect(idx, options[idx])
                valueLbl.Text = tostring(shownValue(getIndex()) or shownValue(idx))
            end

            trackLustConnection(leftBtn.Activated:Connect(function() step(-1) end))
            trackLustConnection(rightBtn.Activated:Connect(function() step(1) end))
            trackLustConnection(valueLbl.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1
                    or input.UserInputType == Enum.UserInputType.Touch then
                    step(1)
                end
            end))

            return pill, function()
                    valueLbl.Text = tostring(shownValue(getIndex()) or shownValue(1))
            end
        end


        local antiDieState = {
            sources = { float = false },
            enabled = false,
            entries = {},
            hbConn = nil,
            charConn = nil,
            invincibleUntil = 0,
            releaseToken = 0,
            CFG = { healthThreshold = 25, floatHealthThreshold = 65, invincibilityFrames = 0.5, floatHealInterval = 0.04, floatTaskInterval = 0.04 },
        }

        antiDieState.getHealthThreshold = function()
            local AD = antiDieState
            if LustFloat and LustFloat.running then
                return math.max(AD.CFG.healthThreshold, AD.CFG.floatHealthThreshold)
            end
            return AD.CFG.healthThreshold
        end

        antiDieState.superHeal = function(hum)
            local AD = antiDieState
            if not hum or not hum.Parent then return end
            local floatActive = LustFloat and LustFloat.running == true
            local healInterval = floatActive and AD.CFG.floatHealInterval
                or AD.CFG.invincibilityFrames
            if tick() < AD.invincibleUntil then return end
            local maxHP = hum.MaxHealth or 100
            hum.Health = maxHP
            AD.invincibleUntil = tick() + healInterval
            pcall(function()
                local char = hum.Parent
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

        antiDieState.repairCharacter = function(char, entry)
            if not char or not char.Parent then return end
            local AD = antiDieState
            entry = entry or AD.entries[char]
            if entry and not entry.createdInstances then entry.createdInstances = {} end
            local hum = char:FindFirstChildOfClass("Humanoid")
            local root = char:FindFirstChild("HumanoidRootPart")
            if not hum or not root then return end
            if hum.RigType ~= Enum.HumanoidRigType.R6 then return end
            for _, partName in ipairs({ "Head", "Torso", "Left Arm", "Right Arm", "Left Leg", "Right Leg" }) do
                if not char:FindFirstChild(partName) then
                    local part = Instance.new("Part")
                    part.Name = partName
                    part.Size = Vector3.new(2, 1, 1)
                    part.Transparency = 1
                    part.CanCollide = false
                    part.CanTouch = false
                    part.CanQuery = false
                    part.Massless = true
                    part.Anchored = false
                    part.CFrame = root.CFrame + Vector3.new(0, 2, 0)
                    part.Parent = char
                    local motor = Instance.new("Motor6D")
                    motor.Part0 = root
                    motor.Part1 = part
                    motor.Parent = part
                    if entry then
                        table.insert(entry.createdInstances, part)
                        table.insert(entry.createdInstances, motor)
                    end
                end
            end
        end

        antiDieState.releaseCharacter = function(char, entry)
            if not entry then return end
            entry.active = false
            for _, conn in ipairs(entry.conns) do
                pcall(function() conn:Disconnect() end)
            end
            entry.conns = {}
            for _, thread in ipairs(entry.tasks) do
                pcall(task.cancel, thread)
            end
            entry.tasks = {}
            for part, wasCanTouch in pairs(entry.touchStates or {}) do
                pcall(function()
                    if part and part.Parent then part.CanTouch = wasCanTouch end
                end)
            end
            entry.touchStates = {}
            for touchInterest, part in pairs(entry.detachedTouches or {}) do
                pcall(function()
                    if touchInterest and not touchInterest.Parent and part and part.Parent
                        and not part:FindFirstChild("TouchInterest") then
                        touchInterest.Parent = part
                    elseif touchInterest then
                        touchInterest:Destroy()
                    end
                end)
            end
            entry.detachedTouches = {}
            local hum = entry.hum
            if hum and hum.Parent then
                pcall(function()
                    for stateType, wasEnabled in pairs(entry.prevStates) do
                        hum:SetStateEnabled(stateType, wasEnabled)
                    end
                    hum.BreakJointsOnDeath = entry.prevBreak
                    hum.RequiresNeck = entry.prevNeck
                end)
            end
            if entry.ff and entry.ff.Parent then
                pcall(function() entry.ff:Destroy() end)
            end
            entry.ff = nil
            local healthObject, healthParent = entry.healthObject, entry.healthParent
            if healthObject and healthParent and not healthObject.Parent then
                pcall(function()
                    if healthParent.Parent then healthObject.Parent = healthParent end
                end)
            end
            entry.healthObject, entry.healthParent = nil, nil
            for i = #(entry.createdInstances or {}), 1, -1 do
                local instance = entry.createdInstances[i]
                pcall(function()
                    if instance then instance:Destroy() end
                end)
                entry.createdInstances[i] = nil
            end
            antiDieState.entries[char] = nil
        end

        antiDieState.applyGodMode = function(character)
            local AD = antiDieState
            if not character or AD.entries[character] then return end
            local humanoid = character:FindFirstChildOfClass("Humanoid") or character:WaitForChild("Humanoid", 5)
            if not humanoid then return end
            if AD.entries[character] or not AD.enabled then return end

            local entry = {
                conns = {}, tasks = {}, createdInstances = {}, active = true, hum = humanoid,
                healthObject = nil, healthParent = nil,
                touchStates = {}, detachedTouches = {},
                prevStates = {}, prevBreak = humanoid.BreakJointsOnDeath, prevNeck = humanoid.RequiresNeck,
            }
            AD.entries[character] = entry

            local function addConn(conn)
                table.insert(entry.conns, conn)
                return conn
            end
            local function alive()
                return entry.active and AD.enabled and AD.entries[character] == entry
            end
            local function suppressTouch(part)
                if not part or not part:IsA("BasePart") then return end
                if entry.touchStates[part] == nil then
                    entry.touchStates[part] = part.CanTouch
                end
                pcall(function() part.CanTouch = false end)
                local touchInterest = part:FindFirstChild("TouchInterest")
                if touchInterest and not entry.detachedTouches[touchInterest] then
                    entry.detachedTouches[touchInterest] = part
                    pcall(function() touchInterest.Parent = nil end)
                end
            end

            for _, stateType in ipairs({
                Enum.HumanoidStateType.Dead,
                Enum.HumanoidStateType.Ragdoll,
                Enum.HumanoidStateType.FallingDown,
                Enum.HumanoidStateType.GettingUp,
            }) do
                pcall(function() entry.prevStates[stateType] = humanoid:GetStateEnabled(stateType) end)
            end

            local root = character:FindFirstChild("HumanoidRootPart")
            if not root then
                root = Instance.new("Part")
                root.Name = "HumanoidRootPart"
                root.Size = Vector3.new(2, 1, 1)
                root.Transparency = 1
                root.CanCollide = false
                root.Anchored = false
                root.Parent = character
                table.insert(entry.createdInstances, root)
                pcall(function() humanoid:SetRootPart(root) end)
            end

            humanoid.BreakJointsOnDeath = false
            humanoid.RequiresNeck = false

            local healthScript = character:FindFirstChild("Health")
            if healthScript then
                entry.healthObject = healthScript
                entry.healthParent = healthScript.Parent
                pcall(function() healthScript.Parent = nil end)
            end

            if not character:FindFirstChildOfClass("ForceField") then
                local ff = Instance.new("ForceField")
                ff.Visible = false
                ff.Parent = character
                entry.ff = ff
            end

            pcall(function()
                humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
                humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
                humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
                humanoid:SetStateEnabled(Enum.HumanoidStateType.GettingUp, false)
            end)

            addConn(trackLustConnection(humanoid.StateChanged:Connect(function(_, newState)
                if not alive() then return end
                if newState == Enum.HumanoidStateType.Dead
                    or newState == Enum.HumanoidStateType.Ragdoll
                    or newState == Enum.HumanoidStateType.FallingDown then
                    humanoid:ChangeState(Enum.HumanoidStateType.Running)
                end
            end)))

            addConn(trackLustConnection(humanoid:GetPropertyChangedSignal("Health"):Connect(function()
                if not alive() then return end
                if humanoid.Health <= 0 or humanoid.Health <= AD.getHealthThreshold() then
                    AD.superHeal(humanoid)
                end
                if humanoid.Health > humanoid.MaxHealth then
                    humanoid.Health = humanoid.MaxHealth
                end
            end)))

            addConn(trackLustConnection(humanoid.Died:Connect(function()
                task.wait(0.05)
                if alive() and humanoid.Parent then
                    AD.superHeal(humanoid)
                end
            end)))

            addConn(trackLustConnection(humanoid:GetPropertyChangedSignal("MaxHealth"):Connect(function()
                if not alive() then return end
                if humanoid.MaxHealth < 100 then
                    humanoid.MaxHealth = 100
                end
                if humanoid.Health > humanoid.MaxHealth then
                    humanoid.Health = humanoid.MaxHealth
                end
                if humanoid.Health <= 0 then
                    AD.superHeal(humanoid)
                end
            end)))

            addConn(trackLustConnection(humanoid:GetPropertyChangedSignal("BreakJointsOnDeath"):Connect(function()
                if alive() and humanoid.BreakJointsOnDeath == true then
                    humanoid.BreakJointsOnDeath = false
                end
            end)))

            local function protectJoint(desc)
                if not desc:IsA("Motor6D") then return end
                addConn(trackLustConnection(desc.AncestryChanged:Connect(function(_, parent)
                    if parent or not alive() then return end
                    if not character.Parent then return end
                    local hm = character:FindFirstChildOfClass("Humanoid")
                    if not hm or hm.Health <= 0 then return end
                    local p0, p1 = desc.Part0, desc.Part1
                    if not p0 or not p1 then return end
                    if not p0:IsDescendantOf(character) or not p1:IsDescendantOf(character) then return end
                    task.defer(function()
                        if not alive() or not character.Parent or not p0.Parent or not p1.Parent then return end
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
                            table.insert(entry.createdInstances, clone)
                            clone.Parent = p0
                        end)
                    end)
                end)))
            end
            for _, desc in ipairs(character:GetDescendants()) do
                protectJoint(desc)
            end
            addConn(trackLustConnection(character.DescendantAdded:Connect(function(desc)
                if alive() then protectJoint(desc) end
            end)))

            for _, part in ipairs(character:GetDescendants()) do
                if part:IsA("BasePart") then
                    addConn(trackLustConnection(part.Touched:Connect(function(hit)
                        if not alive() or not hit or not hit.Parent then return end
                        if Players:GetPlayerFromCharacter(hit.Parent) or Players:GetPlayerFromCharacter(hit.Parent.Parent) then
                            return
                        end
                        local hn = string.lower(hit.Name)
                        if hn:find("kill") or hn:find("damage") or hn:find("lava") or hn:find("fire") or hn:find("spike") then
                            suppressTouch(hit)
                        end
                    end)))
                end
            end

            addConn(trackLustConnection(character.ChildAdded:Connect(function(child)
                task.defer(function()
                    if not alive() or not child.Parent then return end
                    if child:IsA("Explosion") or child:IsA("Fire") or child:IsA("Smoke") then
                        child:Destroy()
                    end
                    if child:IsA("Tool") then
                        for _, descendant in ipairs(child:GetDescendants()) do
                            if descendant:IsA("BasePart") then
                                suppressTouch(descendant)
                            end
                        end
                    end
                end)
            end)))

            local criticalParts = {
                Head = true, UpperTorso = true, Torso = true, HumanoidRootPart = true,
                LeftArm = true, RightArm = true, LeftLeg = true, RightLeg = true,
                ["Left Arm"] = true, ["Right Arm"] = true, ["Left Leg"] = true, ["Right Leg"] = true,
            }
            addConn(trackLustConnection(character.ChildRemoved:Connect(function(child)
                if not alive() or not character.Parent then return end
                if child.Name == "HumanoidRootPart" and not character:FindFirstChild("HumanoidRootPart") then
                    local newRoot = Instance.new("Part")
                    newRoot.Name = "HumanoidRootPart"
                    newRoot.Size = Vector3.new(2, 1, 1)
                    newRoot.Transparency = 1
                    newRoot.CanCollide = false
                    newRoot.Anchored = false
                    newRoot.CFrame = CFrame.new(character:GetPivot().Position)
                    newRoot.Parent = character
                    table.insert(entry.createdInstances, newRoot)
                    pcall(function() humanoid.RootPart = newRoot end)
                end
                if criticalParts[child.Name] then
                    task.wait(0.05)
                    if alive() then
                        AD.superHeal(humanoid)
                        AD.repairCharacter(character, entry)
                    end
                end
            end)))

            AD.repairCharacter(character, entry)

            table.insert(entry.tasks, task.spawn(function()
                local counter = 0
                while alive() and character.Parent do
                    task.wait((LustFloat and LustFloat.running) and AD.CFG.floatTaskInterval or 0.1)
                    if not alive() then break end
                    pcall(function()
                        if humanoid.Health < humanoid.MaxHealth then
                            AD.superHeal(humanoid)
                        end
                        if humanoid.BreakJointsOnDeath == true then
                            humanoid.BreakJointsOnDeath = false
                        end
                        if humanoid.RequiresNeck == true then
                            humanoid.RequiresNeck = false
                        end
                        humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
                        if not character:FindFirstChildOfClass("ForceField") then
                            local nff = Instance.new("ForceField")
                            nff.Visible = false
                            nff.Parent = character
                            entry.ff = nff
                        end
                    end)
                    counter = counter + 1
                    if counter >= 20 then
                        counter = 0
                        pcall(function()
                            humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
                            humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
                            AD.repairCharacter(character, entry)
                        end)
                    end
                end
            end))

            AD.superHeal(humanoid)
        end

        antiDieState.start = function()
            local AD = antiDieState
            if AD.enabled then return end
            AD.enabled = true

            AD.hbConn = trackLustConnection(RunService.Heartbeat:Connect(function()
                if not AD.enabled then return end
                local char = localPlayer.Character
                local hum = char and char:FindFirstChildOfClass("Humanoid")
                if hum and (hum.Health <= 0 or hum.Health <= AD.getHealthThreshold()) then
                    AD.superHeal(hum)
                end
            end))

            AD.charConn = trackLustConnection(localPlayer.CharacterAdded:Connect(function(newChar)
                task.wait(0.1)
                for char, entry in pairs(AD.entries) do
                    if char ~= newChar and not char.Parent then
                        AD.releaseCharacter(char, entry)
                    end
                end
                if AD.enabled then
                    AD.applyGodMode(newChar)
                end
            end))

            if localPlayer.Character then
                AD.applyGodMode(localPlayer.Character)
            end
        end

        antiDieState.stop = function()
            local AD = antiDieState
            AD.enabled = false
            if AD.hbConn then
                pcall(function() AD.hbConn:Disconnect() end)
                AD.hbConn = nil
            end
            if AD.charConn then
                pcall(function() AD.charConn:Disconnect() end)
                AD.charConn = nil
            end
            local pending = {}
            for char, entry in pairs(AD.entries) do
                pending[char] = entry
            end
            for char, entry in pairs(pending) do
                AD.releaseCharacter(char, entry)
            end
            AD.entries = {}
            AD.invincibleUntil = 0
        end

        antiDieState.refresh = function()
            local AD = antiDieState
            local wanted = AD.sources.float == true
            if wanted and not AD.enabled then
                AD.start()
            elseif not wanted and AD.enabled then
                AD.stop()
            end
        end

        antiDieState.arm = function(timeout)
            local AD = antiDieState
            AD.releaseToken = AD.releaseToken + 1
            AD.sources.float = true
            AD.refresh()
            local function armed()
                if not AD.enabled then return false end
                local char = localPlayer.Character
                if not char then return true end
                return AD.entries[char] ~= nil
            end
            if armed() then return true end
            local deadline = os.clock() + (tonumber(timeout) or 0.5)
            while os.clock() < deadline do
                if armed() then return true end
                RunService.Heartbeat:Wait()
            end
            return armed()
        end

        antiDieState.release = function(delay)
            local AD = antiDieState
            AD.releaseToken = AD.releaseToken + 1
            local token = AD.releaseToken
            task.delay(tonumber(delay) or 1.5, function()
                if token ~= AD.releaseToken then return end
                if LustFloat and LustFloat.running then return end
                AD.sources.float = false
                AD.refresh()
            end)
        end

        LustAntiDie = antiDieState

        LustFloat = {
            RISE = 17, RATE = 55, CYCLE = 2.5, PAUSE = 0.5, SAMPLE = 0.08, PIT_MARGIN = 15,
            conn = nil, thread = nil, running = false, locked = false, targetY = nil,
            baseY = nil, baseGround = nil, safeValid = false, safeX = 0, safeZ = 0, safeY = 0,
            respawnToken = 0, cycleToken = 0, _params = nil,
        }

        LustFloat.getHRP = function()
            local c = localPlayer.Character
            if not c then return nil, nil end
            return c:FindFirstChild("HumanoidRootPart"), c:FindFirstChildOfClass("Humanoid")
        end

        LustFloat.findGround = function(char, hrp)
            local FLOAT = LustFloat
            local params = FLOAT._params
            if not params then
                params = RaycastParams.new()
                params.FilterType = Enum.RaycastFilterType.Exclude
                params.IgnoreWater = true
                pcall(function() params.RespectCanCollide = true end)
                FLOAT._params = params
            end
            local filter = { char }
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= localPlayer and plr.Character then filter[#filter + 1] = plr.Character end
            end
            local half = hrp.Size.Y * 0.5
            if half <= 0 then half = 1 end
            local origin = hrp.Position
            local startY = origin.Y - half - 0.1
            for _ = 1, 6 do
                params.FilterDescendantsInstances = filter
                local res = workspace:Raycast(Vector3.new(origin.X, startY, origin.Z), Vector3.new(0, -1000, 0), params)
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

        LustFloat.isSafeGround = function(g)
            local FLOAT = LustFloat
            if not g then return false end
            if FLOAT.baseGround and g < FLOAT.baseGround - FLOAT.PIT_MARGIN then return false end
            return true
        end

        LustFloat.groundTP = function()
            local FLOAT = LustFloat
            local char = localPlayer.Character
            if not char then return end
            local hrp = char:FindFirstChild("HumanoidRootPart")
            local hum = char:FindFirstChildOfClass("Humanoid")
            if not hrp or not hum or hum.Health <= 0 then return end

            local pos = hrp.Position
            local groundY, half
            pcall(function() groundY, half = FLOAT.findGround(char, hrp) end)
            if not FLOAT.isSafeGround(groundY) and FLOAT.safeValid then
                -- Keep current X/Z; use the saved safe floor only for vertical placement.
                groundY = FLOAT.safeY
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
                    if pos.Y - targetY < 0.5 then
                        hrp.AssemblyLinearVelocity = Vector3.zero
                        return
                    end
                    hrp.CFrame = CFrame.new(pos.X, targetY, pos.Z) * hrp.CFrame.Rotation
                    hrp.AssemblyLinearVelocity = Vector3.zero
                    hrp.AssemblyAngularVelocity = Vector3.zero
                end)
            end
        end

        LustFloat.startLoop = function()
            local FLOAT = LustFloat
            if FLOAT.conn then return end
            FLOAT.locked = false
            FLOAT.targetY = nil

            local char0 = localPlayer.Character
            local root0 = char0 and char0:FindFirstChild("HumanoidRootPart")
            local hum0 = char0 and char0:FindFirstChildOfClass("Humanoid")
            if hum0 and hum0.FloorMaterial ~= Enum.Material.Air then
                pcall(function() hum0:ChangeState(Enum.HumanoidStateType.Freefall) end)
            end

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
            FLOAT.conn = trackLustConnection(RunService.Heartbeat:Connect(function(dt)
                local char = localPlayer.Character
                if char ~= cChar or not cRoot or not cRoot.Parent then
                    cChar = char
                    cRoot = char and char:FindFirstChild("HumanoidRootPart") or nil
                    cHum = char and char:FindFirstChildOfClass("Humanoid") or nil
                end
                if not cRoot or not cHum or cHum.Health <= 0 then return end

                local cf = cRoot.CFrame
                local pos = cf.Position
                local vel = cRoot.AssemblyLinearVelocity

                sampleT = sampleT + dt
                if sampleT >= FLOAT.SAMPLE then
                    sampleT = 0
                    local ok, g = pcall(FLOAT.findGround, cChar, cRoot)
                    if ok and FLOAT.isSafeGround(g) then
                        FLOAT.safeX, FLOAT.safeZ, FLOAT.safeY = pos.X, pos.Z, g
                        FLOAT.safeValid = true
                    elseif ok and FLOAT.safeValid and FLOAT.baseGround
                        and pos.Y < FLOAT.baseGround - FLOAT.PIT_MARGIN and vel.Y < -8 then
                        -- Recover only after a clear fall below the safe level; don't snap back on a transient raycast miss.
                        pos = Vector3.new(FLOAT.safeX, pos.Y, FLOAT.safeZ)
                    end
                end

                if not FLOAT.targetY then
                    FLOAT.baseY = pos.Y
                    FLOAT.targetY = pos.Y + FLOAT.RISE
                end
                local y = FLOAT.targetY
                if not FLOAT.locked then
                    y = math.min(pos.Y + FLOAT.RATE * dt, FLOAT.targetY)
                    if y >= FLOAT.targetY then FLOAT.locked = true end
                end
                cRoot.CFrame = CFrame.new(pos.X, y, pos.Z) * cf.Rotation
                local horizontalX, horizontalZ = vel.X, vel.Z
                local moveDirection = cHum.MoveDirection
                if moveDirection.Magnitude > 0.05 and type(FLOAT.getSelectedSpeed) == "function" then
                    local speedOk, selectedSpeed = pcall(FLOAT.getSelectedSpeed)
                    if speedOk and type(selectedSpeed) == "number" then
                        selectedSpeed = math.clamp(selectedSpeed, 0, 250)
                        horizontalX = moveDirection.Unit.X * selectedSpeed
                        horizontalZ = moveDirection.Unit.Z * selectedSpeed
                    end
                end
                cRoot.AssemblyLinearVelocity = Vector3.new(horizontalX, 0, horizontalZ)
            end))
        end

        LustFloat.stopLoop = function(tpDown)
            local FLOAT = LustFloat
            if FLOAT.conn then
                pcall(function() FLOAT.conn:Disconnect() end)
                FLOAT.conn = nil
            end
            if tpDown then pcall(FLOAT.groundTP) end
        end

        LustFloat.waitGrounded = function(timeout)
            local FLOAT = LustFloat
            local deadline = os.clock() + (timeout or 3)
            while os.clock() < deadline do
                if not FLOAT.running then return end
                local hrp, hum = FLOAT.getHRP()
                if not hrp or not hum or hum.Health <= 0 then return end
                if hum.FloorMaterial ~= Enum.Material.Air then
                    task.wait(FLOAT.PAUSE)
                    return
                end
                RunService.Heartbeat:Wait()
            end
        end

        LustFloat.spawnCycle = function()
            local FLOAT = LustFloat
            if FLOAT.thread then pcall(task.cancel, FLOAT.thread); FLOAT.thread = nil end
            FLOAT.cycleToken = FLOAT.cycleToken + 1
            local token = FLOAT.cycleToken
            local runtimeEnv = getgenv and getgenv() or _G
            local session = rawget(runtimeEnv, "__LustSessionToken")
            FLOAT.thread = task.spawn(function()
                while FLOAT.running and FLOAT.cycleToken == token
                    and rawget(runtimeEnv, "__LustSessionToken") == session do
                    task.wait(FLOAT.CYCLE)
                    if not FLOAT.running or FLOAT.cycleToken ~= token
                        or rawget(runtimeEnv, "__LustSessionToken") ~= session then break end
                    FLOAT.stopLoop(true)
                    FLOAT.waitGrounded(3)
                    if not FLOAT.running or FLOAT.cycleToken ~= token
                        or rawget(runtimeEnv, "__LustSessionToken") ~= session then break end
                    FLOAT.startLoop()
                end
                if FLOAT.cycleToken == token then FLOAT.thread = nil end
            end)
        end

        LustFloat.enable = function()
            local FLOAT = LustFloat
            if FLOAT.running then return end
            FLOAT.running = true
            LustAntiDie.arm(1.0)
            if not FLOAT.running then return end
            FLOAT.startLoop()
            FLOAT.spawnCycle()
        end

        LustFloat.disable = function()
            local FLOAT = LustFloat
            if not FLOAT.running then return end
            FLOAT.running = false
            FLOAT.cycleToken = FLOAT.cycleToken + 1
            if FLOAT.thread then pcall(task.cancel, FLOAT.thread); FLOAT.thread = nil end
            FLOAT.stopLoop(true)
            FLOAT.safeValid = false
            FLOAT.baseGround = nil
            LustAntiDie.release(1.5)
        end

        LustFloatSet = function(state)
            if state then LustFloat.enable() else LustFloat.disable() end
            LustSyncSet("float", LustFloat.running)
        end

        LustFloatToggle = function()
            LustFloatSet(not LustFloat.running)
        end

        LustFloat.charConn = trackLustConnection(localPlayer.CharacterAdded:Connect(function(char)
            local FLOAT = LustFloat
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

            LustAntiDie.arm(1.0)
            local deadline = os.clock() + 3
            while os.clock() < deadline and FLOAT.running and FLOAT.respawnToken == token do
                if hum.Health <= 0 then return end
                if hum.FloorMaterial ~= Enum.Material.Air then break end
                RunService.Heartbeat:Wait()
            end
            if not FLOAT.running or FLOAT.respawnToken ~= token then return end
            if localPlayer.Character ~= char then return end
            FLOAT.startLoop()
            FLOAT.spawnCycle()
        end))

        do
            local FLOAT = LustFloat
            local AD = LustAntiDie
            local syncSet = LustSyncSet
            LustCleanup = function()
                local runtimeEnv = getgenv and getgenv() or _G
                if rawget(runtimeEnv, "__LustSessionToken") == lustSessionToken then
                    pcall(function() rawset(runtimeEnv, "__LustSessionToken", lustSessionToken + 1) end)
                    pcall(function() rawset(_G, "__LustSessionToken", lustSessionToken + 1) end)
                end
                if type(stopAutoSteal) == "function" then pcall(stopAutoSteal) end
                if type(stopAutoLeft) == "function" then pcall(stopAutoLeft) end
                if type(stopAutoRight) == "function" then pcall(stopAutoRight) end
                if type(stopAutoTeleport) == "function" then pcall(stopAutoTeleport) end
                local disableBat = rawget(runtimeEnv, "disableAutoBat") or rawget(_G, "disableAutoBat")
                if type(disableBat) == "function" then pcall(disableBat) end
                local stopBodyLock = rawget(runtimeEnv, "__LustBatCounterCleanup") or rawget(_G, "__LustBatCounterCleanup")
                if type(stopBodyLock) == "function" then pcall(stopBodyLock) end
                if type(skinBatCleanup) == "function" then pcall(skinBatCleanup) end
                pcall(function()
                    local character = localPlayer and localPlayer.Character
                    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
                    local root = character and character:FindFirstChild("HumanoidRootPart")
                    if humanoid then humanoid.AutoRotate = true end
                    if root then
                        for _, mover in ipairs(root:GetChildren()) do
                            if mover.Name == "LustCounterBodyLock" and mover:IsA("BodyAngularVelocity") then
                                mover:Destroy()
                            end
                        end
                    end
                end)
                pcall(function() rawset(runtimeEnv, "__LustBatCounterCleanup", nil) end)
                pcall(function() rawset(_G, "__LustBatCounterCleanup", nil) end)
                local stopRagdoll = rawget(runtimeEnv, "stopAntiRagdoll") or rawget(_G, "stopAntiRagdoll")
                if type(stopRagdoll) == "function" then pcall(stopRagdoll) end
                if type(stopInfiniteJumpLoop) == "function" then pcall(stopInfiniteJumpLoop) end
                local restoreUnwalk = rawget(runtimeEnv, "__LustUnwalkCleanup") or rawget(_G, "__LustUnwalkCleanup")
                if type(restoreUnwalk) == "function" then pcall(restoreUnwalk) end
                pcall(function() rawset(runtimeEnv, "__LustUnwalkCleanup", nil) end)
                pcall(function() rawset(_G, "__LustUnwalkCleanup", nil) end)
                local restoreCamera = rawget(runtimeEnv, "__LustCameraEffectsCleanup") or rawget(_G, "__LustCameraEffectsCleanup")
                if type(restoreCamera) == "function" then pcall(restoreCamera) end
                pcall(function() rawset(runtimeEnv, "__LustCameraEffectsCleanup", nil) end)
                pcall(function() rawset(_G, "__LustCameraEffectsCleanup", nil) end)
                local tracked = rawget(runtimeEnv, "__LustTrackedConnections")
                if type(tracked) == "table" then
                    for i = #tracked, 1, -1 do
                        local connection = tracked[i]
                        pcall(function()
                            if connection and connection.Connected then connection:Disconnect() end
                        end)
                        tracked[i] = nil
                    end
                end
                local stopCarry = _G.__LustAutoCarrySetEnabled
                if type(stopCarry) == "function" then pcall(stopCarry, false) end
                local resetCleanup = runtimeEnv.__LustInstaResetCleanup or _G.__LustInstaResetCleanup
                if type(resetCleanup) == "function" then pcall(resetCleanup) end
                local bypassCleanup = runtimeEnv.__LustSpeedBypassCleanup or _G.__LustSpeedBypassCleanup
                if type(bypassCleanup) == "function" then pcall(bypassCleanup) end
                local stopSpeed = runtimeEnv.__LustStopSpeedEngine or _G.__LustStopSpeedEngine
                if type(stopSpeed) == "function" then pcall(stopSpeed) end
                local clearSpeed = runtimeEnv.__LustResetSpeedMovement or _G.__LustResetSpeedMovement
                if type(clearSpeed) == "function" then pcall(clearSpeed) end
                FLOAT.running = false
                FLOAT.respawnToken = (FLOAT.respawnToken or 0) + 1
                FLOAT.cycleToken = (FLOAT.cycleToken or 0) + 1
                if FLOAT.thread then pcall(task.cancel, FLOAT.thread); FLOAT.thread = nil end
                if FLOAT.charConn then pcall(function() FLOAT.charConn:Disconnect() end); FLOAT.charConn = nil end
                local hadLoop = FLOAT.conn ~= nil
                FLOAT.stopLoop(hadLoop)
                AD.releaseToken = AD.releaseToken + 1
                AD.sources.float = false
                pcall(AD.stop)
                pcall(syncSet, "float", false)
            end
            local genv = getgenv and getgenv() or _G
            genv.__LustCleanup = LustCleanup
        end

        pcall(function()
            if getgenv then
                local genv = getgenv()

                if genv.__LustESPDrawings then
                    for _, lustESPDrawing in ipairs(genv.__LustESPDrawings) do
                        pcall(function()
                            lustESPDrawing:Remove()
                        end)
                    end

                    genv.__LustESPDrawings = nil
                end

                genv._AdaptESPEnabled = false
            end

            local findFirstChild = localPlayer.FindFirstChild

            for _, primaryValue in ipairs({ game:GetService("CoreGui"), findFirstChild(localPlayer, "PlayerGui") }) do
                if primaryValue then
                    local adaptESPVisual = primaryValue:FindFirstChild("AdaptESP_Visual")

                    if adaptESPVisual then
                        adaptESPVisual:Destroy()
                    end
                end
            end
        end)

        do
            local function featureHelperB()
                local colorSequence = ColorSequence.new
                local workingData = {}
                local primaryValue = ColorSequenceKeypoint.new(0, Color3.fromRGB(187, 187, 195))
                local secondaryValue = ColorSequenceKeypoint.new(0.55, primaryColor)
                local new = ColorSequenceKeypoint.new
                local foregroundColor = Color3.fromRGB
                local currentObject = 177
                local currentItem = 177
                local targetObject = 185
                workingData[1] = primaryValue
                workingData[2] = secondaryValue

                do
                    local values = table.pack(new(1, foregroundColor(currentObject, currentItem, targetObject)))
                    table.move(values, 1, values.n, 3, workingData)
                end

                return colorSequence(workingData)
            end

            createPurpleColorSequence = function()
                local colorSequence = ColorSequence.new
                local workingData = {}
                local primaryValue = ColorSequenceKeypoint.new(0, Color3.fromRGB(187, 187, 195))
                local secondaryValue = ColorSequenceKeypoint.new(0.45, Color3.fromRGB(245, 245, 252))
                local new = ColorSequenceKeypoint.new
                local foregroundColor = Color3.fromRGB
                workingData[1] = primaryValue
                workingData[2] = secondaryValue

                do
                    local values = table.pack(new(1, foregroundColor(177, 177, 185)))
                    table.move(values, 1, values.n, 3, workingData)
                end

                return colorSequence(workingData)
            end

            featureHelperA = function(inputValue, secondaryInput)
                if not inputValue then
                    return
                end

                for _, child in ipairs(inputValue:GetChildren()) do
                    if
                        not (
                            child == secondaryInput
                            or child:IsA("BillboardGui") and child.Name == "LustHubOtherSpeed"
                        )
                    then
                        if
                            child:IsA("BillboardGui")
                            and (
                                child.Name == "LustHubHeadTitle"
                                or child.Name == "VlonEHeadBB"
                                or child.Name == "RitualHeadBB"
                                or child.Name:lower():find("speed")
                            )
                        then
                            pcall(function()
                                child:Destroy()
                            end)
                        elseif child:IsA("BillboardGui") then
                            for _, descendant in ipairs(child:GetDescendants()) do
                                if descendant:IsA("TextLabel") then
                                    local primaryValue = string.lower(descendant.Text or "")

                                    if primaryValue:find("discord%.gg/") or primaryValue:find("speed:") then
                                        pcall(function()
                                            child:Destroy()
                                        end)

                                        break
                                    end
                                end
                            end
                        end
                    end
                end
            end

            applyPurpleGradient = function(parent, rotation, inputValue)
                local lustPurpleGradient = parent:FindFirstChild("LustPurpleGradient") or Instance.new("UIGradient")
                lustPurpleGradient.Name = "LustPurpleGradient"
                lustPurpleGradient:SetAttribute("KairnoxThemeRole", "ThemeGradient")
                lustPurpleGradient.Color = featureHelperB()
                lustPurpleGradient.Rotation = rotation or 90
                lustPurpleGradient.Enabled = inputValue == true
                lustPurpleGradient.Parent = parent
                return lustPurpleGradient
            end
        end
    end

    do
        addPurpleGloss = function(parent, zIndex)
            parent.ClipsDescendants = true
            local lustPurpleGloss = parent:FindFirstChild("LustPurpleGloss") or Instance.new("Frame")
            lustPurpleGloss.Name = "LustPurpleGloss"
            lustPurpleGloss.Size = UDim2.new(1, 0, 0.45, 0)
            lustPurpleGloss.Position = UDim2.new(0, 0, 0, 0)
            lustPurpleGloss.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            lustPurpleGloss.BackgroundTransparency = 0.72
            lustPurpleGloss.BorderSizePixel = 0
            lustPurpleGloss.Visible = false

            if not zIndex then
                zIndex = (parent.ZIndex or 1) + 1
            end

            lustPurpleGloss.ZIndex = zIndex

            lustPurpleGloss.Parent = parent;
            (lustPurpleGloss:FindFirstChildOfClass("UICorner") or Instance.new("UICorner", lustPurpleGloss)).CornerRadius =
                UDim.new(1, 0)
            local uiGradient = lustPurpleGloss:FindFirstChild("LustGlossGradient") or Instance.new("UIGradient")
            uiGradient.Name = "LustGlossGradient"
            local numberSequence = NumberSequence.new
            local workingData = {}
            local primaryValue = NumberSequenceKeypoint.new(0, 0.35)
            local secondaryValue = NumberSequenceKeypoint.new(0.6, 0.78)
            local new = NumberSequenceKeypoint.new
            local currentObject = 1
            workingData[1] = primaryValue
            workingData[2] = secondaryValue

            do
                local values = table.pack(new(1, currentObject))
                table.move(values, 1, values.n, 3, workingData)
            end

            uiGradient.Transparency = numberSequence(workingData)
            uiGradient.Rotation = 90
            uiGradient.Parent = lustPurpleGloss
            return lustPurpleGloss
        end

        setPurpleControlActive = function(inputValue, secondaryInput)
            if not inputValue then
                return
            end
            local primaryValue = inputValue:FindFirstChild("LustPurpleGradient")

            if primaryValue then
                primaryValue.Enabled = secondaryInput == true
            end

            local lustPurpleGloss = inputValue:FindFirstChild("LustPurpleGloss")

            if lustPurpleGloss then
                lustPurpleGloss.Visible = secondaryInput == true
            end

            local lustPurpleStroke = inputValue:FindFirstChild("LustPurpleStroke")

            if lustPurpleStroke then
                lustPurpleStroke:SetAttribute("KairnoxThemeRole", "SwitchStroke")
                lustPurpleStroke:SetAttribute("KairnoxThemeActive", secondaryInput == true)
                TweenService:Create(
                    lustPurpleStroke,
                    TweenInfo.new(0.16),
                    { Color = primaryColor, Transparency = secondaryInput and 0.18 or 0.72 }
                ):Play()
            end
        end

        do
            local function featureHelperB(inputValue)
                if not inputValue or not inputValue:IsA("ScreenGui") then
                    return false
                end
                local primaryValue = string.lower(inputValue.Name or "")
                if
                    primaryValue:find("lust") and primaryValue:find("hub")
                    or primaryValue == "lusthubmobile"
                    or primaryValue == "lusthub"
                    or primaryValue == "KAIRNOX DUELS"
                then
                    return true
                end
                return false
            end

            removeExistingLustGui = function()
                local findFirstChild = localPlayer.FindFirstChild
                local primaryValue = "PlayerGui"

                for _, secondaryValue in ipairs({
                    game:GetService("CoreGui"),
                    findFirstChild(localPlayer, primaryValue),
                }) do
                    if secondaryValue then
                        for _, child in ipairs(secondaryValue:GetChildren()) do
                            if featureHelperB(child) then
                                pcall(function()
                                    child:Destroy()
                                end)
                            end
                        end
                    end
                end
            end
        end
    end

    do
        local primaryValue = nil

        showLoadingIndicator = function()
            if primaryValue and primaryValue.Parent then
                return
            end
            local findFirstChild = localPlayer.FindFirstChild
            local secondaryValue = "PlayerGui"

            for _, currentObject in ipairs({ game:GetService("CoreGui"), findFirstChild(localPlayer, secondaryValue) }) do
                local vFastBoot = currentObject and currentObject:FindFirstChild("VFastBoot")

                if vFastBoot then
                    pcall(function()
                        vFastBoot:Destroy()
                    end)
                end
            end

            local screenGui = Instance.new("ScreenGui")
            screenGui.Name = "VFastBoot"
            screenGui.ResetOnSpawn = false
            screenGui.IgnoreGuiInset = true
            screenGui.DisplayOrder = 999

            if
                not pcall(function()
                    screenGui.Parent = game:GetService("CoreGui")
                end) or not screenGui.Parent
            then
                screenGui.Parent = localPlayer:WaitForChild("PlayerGui", 5)
            end

            local rowContainer = Instance.new("Frame", screenGui)
            rowContainer.Size = UDim2.new(0, 160, 0, 36)
            rowContainer.Position = UDim2.new(0, 18, 0, 18)
            rowContainer.BackgroundColor3 = Color3.fromRGB(10, 11, 16)
            rowContainer.BackgroundTransparency = 0.04
            rowContainer.BorderSizePixel = 0
            rowContainer.ZIndex = 999
            Instance.new("UICorner", rowContainer).CornerRadius = UDim.new(0, 8)
            local uiStroke = Instance.new("UIStroke", rowContainer)
            uiStroke.Color = primaryColor
            uiStroke.Thickness = 1
            uiStroke.Transparency = 0.28
            local label = Instance.new("TextLabel", rowContainer)
            label.Size = UDim2.new(1, -16, 1, 0)
            label.Position = UDim2.new(0, 8, 0, 0)
            label.BackgroundTransparency = 1
            label.Text = "Lust Loading..."
            label.TextColor3 = Color3.fromRGB(255, 255, 255)
            label.TextSize = 12
            label.Font = Enum.Font.GothamBold
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.ZIndex = 1000
            primaryValue = screenGui
        end

        hideLoadingIndicator = function()
            if primaryValue then
                pcall(function()
                    primaryValue:Destroy()
                end)

                primaryValue = nil
            end
        end
    end
end

do
    setBatCounterVisual = nil
    startBatCounter = nil
    stopBatCounter = nil
    fieldOfView = 70
    fieldOfViewEnabled = false
    setFovVisual = nil
    fieldOfViewConn = nil
    stretchRezEnabled = false
    stretchRezY = 0.7
    stretchRezConn1 = nil
    stretchRezConn2 = nil
    setStretchRezVisual = nil
    antiLagEnabled = false
    antiLagDescConn = nil
    setAntiLagVisual = nil
    _anyKeyListening = false
    _keyListenBlockUntil = 0
    autoTPEnabled = false
    autoTPHeight = 20
    autoTPConn = nil
    setAutoTPVisual = nil
    startAutoTeleport = nil
    stopAutoTeleport = nil
    counterStateGuard = false
    counterPauseUntil = 0

    pauseCounterChecks = function(inputValue)
        counterPauseUntil = math.max(counterPauseUntil, tick() + (inputValue or 2))
    end

    KB = {
        DropBrainrot = { kb = Enum.KeyCode.X, gp = nil },
        AutoLeft = { kb = Enum.KeyCode.Z, gp = nil },
        AutoRight = { kb = Enum.KeyCode.C, gp = nil },
        AutoBat = { kb = Enum.KeyCode.E, gp = nil },
        TPFloor = { kb = Enum.KeyCode.F, gp = nil },
        GuiHide = { kb = Enum.KeyCode.LeftControl, gp = nil },
        SpeedToggle = { kb = Enum.KeyCode.Q, gp = nil },
        LaggerToggle = { kb = Enum.KeyCode.R, gp = nil },
        InstaReset = { kb = nil, gp = nil },
        Float = { kb = Enum.KeyCode.G, gp = nil },
    }

    _vhKeyButtons = {}

    refreshAllKeyButtons = function()
        if not _vhKeyButtons then
            return
        end

        for k, primaryValue in pairs(_vhKeyButtons) do
            if primaryValue and primaryValue.Parent then
                primaryValue.Text = k.gp and k.gp.Name or k.kb and k.kb.Name or "None"
            end
        end
    end

    clearDuplicateKeybind = function(inputValue, secondaryInput, tertiaryInput)
        if not inputValue or inputValue == Enum.KeyCode.Unknown then
            return
        end

        for _, primaryValue in pairs(KB) do
            if primaryValue ~= tertiaryInput then
                do
                    if secondaryInput and primaryValue.gp == inputValue then
                        primaryValue.gp = nil
                    end

                    if not secondaryInput and primaryValue.kb == inputValue then
                        primaryValue.kb = nil
                    end
                end
            end
        end

        refreshAllKeyButtons()
    end

    isKeybindLocked = function()
        local isActive = _anyKeyListening

        if not isActive then
            isActive = tick() < (_keyListenBlockUntil or 0)
        end

        return isActive
    end

    do
        AP_L1 = Vector3.new(-476.48, -6.28, 92.73)
        AP_L2 = Vector3.new(-483.12, -4.95, 94.80)
        AP_L_FACE = Vector3.new(-482.25, -4.96, 92.09)
    end
end

do
    AP_R1 = Vector3.new(-476.16, -6.52, 25.62)
    AP_R2 = Vector3.new(-483.06, -5.03, 25.48)
    AP_R_FACE = Vector3.new(-482.06, -6.93, 35.47)
end

local featureHelperB, featureHelperC, featureHelperD, featureHelperE

do
    do
        local isActive, featureHelperF, featureHelperG, featureHelperH

        do
            featureHelperB = function()
                if laggerToggled and laggerPhase == 1 then
                    return LAGGER_SPEED
                end

                if laggerToggled and laggerPhase == 2 then
                    return LAGGER_CARRY_SPEED
                end
                return speedMode and CS or NS
            end

            featureHelperC = function()
                return laggerToggled and LAGGER_SPEED or NS
            end

            featureHelperD = function()
                return laggerToggled and LAGGER_SPEED or NS
            end

            featureHelperE = function(inputValue)
                if not inputValue then
                    return true
                end
                local state = inputValue:GetState()
                return state == Enum.HumanoidStateType.Physics or state == Enum.HumanoidStateType.Ragdoll
            end

            Steal = {
                AutoStealEnabled = false,
                StealRadius = 60,
                StealDuration = 1.8,
                StealDelay = 0.18,
                Data = {},
            }

            Conns = {
                autoSteal = nil,
                batCounter = nil,
                medusaCounter = {},
            }

            LustSteal = {
                StealRadius = 60,
                NormalStealPausePercent = 75,
                nextScan = 0,
                Data = setmetatable({}, { __mode = "k" }),
                StructureCache = { plots = {}, lastBuild = -math.huge, building = false, dirty = true },
                _lastPctShown = -1,
            }
            NormalPauseOptions = { 70, 75, 80, 85, 90, 95, 100 }

            HOLD_TIME     = 1.3
            NEAR_RADIUS   = 6
            RANGE_GRACE   = 0.35
            WAIT_TIMEOUT  = 4.0
            SCAN_INTERVAL = 0.06
            BUILD_CD      = 3.0
            -- Reintento inmediato: una sola comprobación tras el primer disparo.
            VERIFY_GAP    = 0.05
            MAX_FIRES     = 1
            MAX_ROUNDS    = 1
            STUCK_LIMIT   = 12
            MAX_DY        = 14

            LustStealState = { active = false, phase = "idle", label = "", lastResult = "" }
            LustIsStealing = false
            _LustRagdollPaused = false
            _LustStealConn = nil
            _LustRagdollPause = { token = 0, humConn = nil, charConn = nil }
            LustS = { phase = "idle" }

            MEDUSA_COUNTER_COOLDOWN = 25
            RAGDOLL_COUNTDOWN_SECONDS = 3
            MEDUSA_BLOCK_SECONDS = 6
            progressRadLbl = nil
            progressFill = nil
            progressPct = nil
            progressBarScale = nil
            isActive = false

            updateStealVersionUi = function() end

            featureHelperF = function()
                if progressPct then
                    progressPct.Text = "0%"
                end

                if progressFill then
                    progressFill.Size = UDim2.new(0, 0, 1, 0)
                    progressFill.BackgroundTransparency = 0.35
                end
            end

            featureHelperG = function(inputValue)
                local amount = math.clamp(tonumber(inputValue) or 0, 0, 1)

                if progressFill then
                    progressFill.BackgroundTransparency = 0.02
                    progressFill.Size = UDim2.new(amount, 0, 1, 0)
                end

                if progressPct then
                    progressPct.Text = math.floor(amount * 100 + 0.5) .. "%"
                end
            end

            updateStealRadiusUi = function()
                if radInput then
                    radInput.Text = tostring(LustSteal.StealRadius)
                end

                if progressRadLbl then
                    progressRadLbl.Text = string.format("Radius: %.2g", LustSteal.StealRadius)
                end
            end
        end

        do
            local function _LustNormalizePause(v)
                local n = tonumber(v) or 75
                local best, bestDiff = NormalPauseOptions[1], math.huge
                for _, opt in ipairs(NormalPauseOptions) do
                    local d = math.abs(n - opt)
                    if d < bestDiff then bestDiff = d; best = opt end
                end
                return best
            end

            local function _LustSetBar(frac, force)
                if not progressFill then return end
                frac = math.clamp(frac, 0, 1)
                local shown = math.floor(frac * 100 + 0.0001)
                if shown == LustSteal._lastPctShown and not force then return end
                LustSteal._lastPctShown = shown
                progressFill.Size = UDim2.new(frac, 0, 1, 0)
                if progressPct then progressPct.Text = shown .. "%" end
            end

            local function _LustCollectCallbacks(data, prompt)
                data.holdCallbacks, data.triggerCallbacks = {}, {}
                if getconnections then
                    local ok, res = pcall(getconnections, prompt.PromptButtonHoldBegan)
                    if ok and type(res) == "table" then
                        for _, c in ipairs(res) do
                            if type(c.Function) == "function" then
                                data.holdCallbacks[#data.holdCallbacks + 1] = c.Function
                            end
                        end
                    end
                    local ok2, res2 = pcall(getconnections, prompt.Triggered)
                    if ok2 and type(res2) == "table" then
                        for _, c in ipairs(res2) do
                            if type(c.Function) == "function" then
                                data.triggerCallbacks[#data.triggerCallbacks + 1] = c.Function
                            end
                        end
                    end
                end
                data.stamp = os.clock()
            end

            local function _LustPrepareData(prompt)
                local cached = LustSteal.Data[prompt]
                if cached then return cached end
                local data = { holdCallbacks = {}, triggerCallbacks = {}, cool = 0, stamp = 0 }
                _LustCollectCallbacks(data, prompt)
                LustSteal.Data[prompt] = data
                return data
            end

            local function _LustMarkDirty()
                LustSteal.StructureCache.dirty = true
            end

            local function _LustSBusy() return LustS.phase ~= "idle" end

            local function _LustRebuildCache(now)
                local cache = LustSteal.StructureCache
                if cache.building or _LustSBusy() then return end
                local since = now - cache.lastBuild
                if not ((cache.dirty and since >= 0.5) or since >= BUILD_CD) then return end
                cache.lastBuild = now
                cache.dirty = false

                local plotsRoot = workspace:FindFirstChild("Plots")
                if not plotsRoot then
                    cache.dirty = true
                    return
                end

                cache.building = true
                task.spawn(function()
                    local newPlots = {}
                    local ok = pcall(function()
                        for i, plot in ipairs(plotsRoot:GetChildren()) do
                            local entry = { isMine = false, name = plot.Name, podiums = {} }
                            local sign = plot:FindFirstChild("PlotSign")
                            local yb = sign and sign:FindFirstChild("YourBase")
                            if yb and yb:IsA("BillboardGui") and yb.Enabled then
                                entry.isMine = true
                            end
                            if not entry.isMine then
                                local pods = plot:FindFirstChild("AnimalPodiums")
                                if pods then
                                    for _, pod in ipairs(pods:GetChildren()) do
                                        local base = pod:FindFirstChild("Base")
                                        local spawn = base and base:FindFirstChild("Spawn")
                                        local att = spawn and spawn:FindFirstChild("PromptAttachment")
                                        if att then
                                            for _, c in ipairs(att:GetChildren()) do
                                                if c:IsA("ProximityPrompt") and tostring(c.ActionText):find("Steal") then
                                                    entry.podiums[#entry.podiums + 1] = {
                                                        podName = pod.Name,
                                                        plotName = plot.Name,
                                                        prompt = c,
                                                        pos = att.WorldPosition,
                                                        uid = plot.Name .. "_" .. pod.Name,
                                                    }
                                                    break
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                            newPlots[#newPlots + 1] = entry
                            if i % 3 == 0 then task.wait() end
                        end
                    end)
                    if ok then
                        cache.plots = newPlots
                        local n = 0
                        pcall(function()
                            for _, plot in ipairs(newPlots) do
                                for _, pod in ipairs(plot.podiums) do
                                    if pod.prompt.Parent and not LustSteal.Data[pod.prompt] then
                                        _LustPrepareData(pod.prompt)
                                        n = n + 1
                                        if n % 3 == 0 then task.wait() end
                                    end
                                end
                            end
                        end)
                    else
                        cache.dirty = true
                    end
                    cache.building = false
                end)
            end

            local function _LustFindTarget(rx, rz, now)
                local radius = LustSteal.StealRadius
                local bestSq, best = radius * radius, nil
                for _, plot in ipairs(LustSteal.StructureCache.plots) do
                    if not plot.isMine then
                        for _, pod in ipairs(plot.podiums) do
                            local p = pod.prompt
                            if not p.Parent then
                                _LustMarkDirty()
                            elseif p.Enabled then
                                local cfg = LustSteal.Data[p]
                                if not cfg or cfg.cool <= now then
                                    local dx, dz = pod.pos.X - rx, pod.pos.Z - rz
                                    local d = dx * dx + dz * dz
                                    if d < bestSq and tostring(p.ActionText):find("Steal") then
                                        bestSq = d
                                        best = pod
                                    end
                                end
                            end
                        end
                    end
                end
                return best
            end

            local function _LustStealAttrs()
                local t = {}
                pcall(function()
                    for k, v in pairs(localPlayer:GetAttributes()) do
                        local l = k:lower()
                        if l:find("steal") or l:find("carry") then t["p:" .. k] = v end
                    end
                    local c = localPlayer.Character
                    if c then
                        for k, v in pairs(c:GetAttributes()) do
                            local l = k:lower()
                            if l:find("steal") or l:find("carry") then t["c:" .. k] = v end
                        end
                    end
                end)
                return t
            end

            local function _LustAttrsChanged(a, b)
                for k, v in pairs(b) do if a[k] ~= v then return true end end
                for k, v in pairs(a) do if b[k] ~= v then return true end end
                return false
            end

            local function _LustPromptConsumed(p)
                if not p.Parent or not p.Enabled then return true end
                return not tostring(p.ActionText):find("Steal")
            end

            local function _LustEndSteal(result, ok)
                LustS.phase = "idle"
                LustStealState.active = false
                LustStealState.phase = "idle"
                LustStealState.lastResult = result
                LustIsStealing = false
                LustSteal.nextScan = 0
                if ok then
                    _LustMarkDirty()
                    _LustSetBar(1, true)
                    task.delay(0.2, function()
                        if LustS.phase == "idle" and LustSteal._lastPctShown == 100 then
                            _LustSetBar(0, true)
                        end
                    end)
                else
                    _LustSetBar(0, true)
                end
                LustS.prompt, LustS.pod, LustS.cfg = nil, nil, nil
            end

            local function _LustBeginSteal(pod, cfg, now)
                LustS.pod, LustS.prompt, LustS.cfg = pod, pod.prompt, cfg
                LustS.t0 = now
                LustS.outSince = nil
                LustS.fires = 0
                LustS.phase = "fill"
                LustS.pausePct = _LustNormalizePause(LustSteal.NormalStealPausePercent)
                LustS.pauseTime = HOLD_TIME * LustS.pausePct / 100
                LustS.remaining = HOLD_TIME - LustS.pauseTime
                local maxAct = tonumber(pod.prompt.MaxActivationDistance) or 10
                LustS.nearR = math.clamp(maxAct - 1, NEAR_RADIUS, 14)

                LustStealState.active = true
                LustStealState.phase = "filling"
                LustStealState.label = pod.podName
                LustStealState.startTime = now
                LustIsStealing = true

                LustS.rounds = 1
                if now - (cfg.stamp or 0) > 1 then _LustCollectCallbacks(cfg, LustS.prompt) end

                pcall(function() LustS.prompt.HoldDuration = 0 end)
                for _, f in ipairs(cfg.holdCallbacks) do task.spawn(f) end
                _LustSetBar(0, true)
            end

            local function _LustDoFire(n)
                local cfg, prompt, pod = LustS.cfg, LustS.prompt, LustS.pod
                pcall(function()
                    local cbs = cfg.triggerCallbacks
                    local hasCb  = #cbs > 0
                    local hasFpp = type(fireproximityprompt) == "function"
                    local useCb  = hasCb and (n % 2 == 1 or not hasFpp)
                    local useFpp = hasFpp and (n % 2 == 0 or not hasCb)
                    if useCb then
                        for _, f in ipairs(cbs) do task.spawn(f) end
                    end
                    if useFpp then
                        pcall(fireproximityprompt, prompt)
                    end
                    local remote = game:GetService("ReplicatedStorage"):FindFirstChild("StealAnimal")
                    if remote and pod.podName then remote:FireServer(pod.podName) end
                end)
            end

            local function _LustStep(now, rx, ry, rz)
                local prompt, pod = LustS.prompt, LustS.pod

                if LustS.phase == "verify" then
                    local attrHit = false
                    if now >= (LustS.nextAttr or 0) then
                        LustS.nextAttr = now + 0.05
                        attrHit = _LustAttrsChanged(LustS.attrSnap, _LustStealAttrs())
                    end
                    if _LustPromptConsumed(prompt) or attrHit then
                        return _LustEndSteal("Stole " .. tostring(LustStealState.label), true)
                    end
                    if now >= LustS.verifyAt then
                        if LustS.fires >= MAX_FIRES then
                            if LustS.rounds < MAX_ROUNDS and prompt.Parent and prompt.Enabled then
                                LustS.rounds = LustS.rounds + 1
                                LustS.fires = 0
                                _LustCollectCallbacks(LustS.cfg, prompt)
                                for _, f in ipairs(LustS.cfg.holdCallbacks) do task.spawn(f) end
                                LustS.verifyAt = now + 0.12
                                return
                            end
                            -- Libera el target casi de inmediato; el escaneo siguiente puede elegir otro.
                            LustS.cfg.cool = now + 0.04
                            LustS.cfg.stamp = 0
                            LustSteal.nextScan = 0
                            return _LustEndSteal("Failed: " .. tostring(LustStealState.label), false)
                        end
                        LustS.fires = LustS.fires + 1
                        _LustDoFire(LustS.fires + (LustS.rounds - 1))
                        LustS.verifyAt = now + VERIFY_GAP
                    end
                    return
                end

                if not prompt.Parent then
                    _LustMarkDirty()
                    return _LustEndSteal("Gone: " .. tostring(LustStealState.label), false)
                end

                if not prompt.Enabled then
                    return _LustEndSteal("Taken: " .. tostring(LustStealState.label), false)
                end

                local dx, dz = pod.pos.X - rx, pod.pos.Z - rz
                local dist = math.sqrt(dx * dx + dz * dz)
                if dist > LustSteal.StealRadius then
                    LustS.outSince = LustS.outSince or now
                    if now - LustS.outSince >= RANGE_GRACE then
                        return _LustEndSteal("Missed (far): " .. tostring(LustStealState.label), false)
                    end
                else
                    LustS.outSince = nil
                end

                local ph = LustS.phase

                if ph == "fill" then
                    local el = now - LustS.t0
                    if el >= LustS.pauseTime then
                        LustS.phase = "wait"; ph = "wait"
                        LustS.waitStart = now
                        LustStealState.phase = "waiting"
                        _LustSetBar(LustS.pausePct / 100)
                    else
                        _LustSetBar(el / HOLD_TIME)
                    end
                end

                if ph == "wait" then
                    local dy = math.abs(pod.pos.Y - ry)
                    if dist <= LustS.nearR and dy <= MAX_DY then
                        LustS.phase = "finish"; ph = "finish"
                        LustS.finishStart = now
                        LustStealState.phase = "finishing"
                    elseif now - LustS.waitStart >= WAIT_TIMEOUT then
                        local maxAct = tonumber(prompt.MaxActivationDistance) or NEAR_RADIUS
                        if dist <= math.max(NEAR_RADIUS, maxAct) and dy <= MAX_DY then
                            LustS.phase = "finish"; ph = "finish"
                            LustS.finishStart = now
                            LustStealState.phase = "finishing"
                        else
                            return _LustEndSteal("Missed (not near): " .. tostring(LustStealState.label), false)
                        end
                    end
                end

                if ph == "finish" then
                    local el = now - LustS.finishStart
                    if el >= LustS.remaining then
                        if LustS.outSince then return end
                        LustS.phase = "verify"
                        LustStealState.phase = "verifying"
                        LustS.fires = 1
                        LustS.attrSnap = _LustStealAttrs()
                        _LustDoFire(1)
                        LustS.verifyAt = now + VERIFY_GAP
                        _LustSetBar(1)
                    else
                        _LustSetBar(LustS.pausePct / 100 + el / HOLD_TIME)
                    end
                end
            end

            local function _LustOnHeartbeat()
                if not Steal.AutoStealEnabled then return end
                local now = os.clock()

                if _LustRagdollPaused then
                    if LustS.phase ~= "idle" then _LustEndSteal("Paused (ragdoll)", false) end
                    return
                end

                if _G.LustInstaResetInProgress then
                    if LustS.phase ~= "idle" then _LustEndSteal("Reset in progress", false) end
                    LustS.root = nil
                    return
                end

                local character = localPlayer.Character
                if not character or not character.Parent then
                    if LustS.phase ~= "idle" then _LustEndSteal("No character", false) end
                    LustS.root = nil
                    return
                end
                local humanoid = character:FindFirstChildOfClass("Humanoid")
                if not humanoid or humanoid.Health <= 0 then
                    if LustS.phase ~= "idle" then _LustEndSteal("Character unavailable", false) end
                    LustS.root = nil
                    return
                end

                local root = LustS.root
                if not root or not root.Parent or not root:IsDescendantOf(character) then
                    root = character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("Torso")
                    LustS.root = root
                end
                if not root then
                    if LustS.phase ~= "idle" then _LustEndSteal("No character", false) end
                    return
                end
                local pos = root.Position

                if LustS.phase ~= "idle" then
                    if now - LustS.t0 > STUCK_LIMIT then
                        _LustEndSteal("Timeout (reset)", false)
                        return
                    end
                    _LustStep(now, pos.X, pos.Y, pos.Z)
                    return
                end

                if now < LustSteal.nextScan then return end
                LustSteal.nextScan = now + SCAN_INTERVAL

                _LustRebuildCache(now)
                local cache = LustSteal.StructureCache
                if cache.building or cache.dirty then return end
                local pod = _LustFindTarget(pos.X, pos.Z, now)
                if not pod then return end
                local cfg = _LustPrepareData(pod.prompt)
                if cfg then _LustBeginSteal(pod, cfg, now) end
            end

            local function _LustOnRagdoll()
                if not Steal.AutoStealEnabled then return end
                _LustRagdollPause.token = _LustRagdollPause.token + 1
                local myToken = _LustRagdollPause.token
                _LustRagdollPaused = true
                if LustS.phase ~= "idle" then _LustEndSteal("Paused (ragdoll)", false) end
                task.delay(1.45, function()
                    if _LustRagdollPause.token ~= myToken then return end
                    _LustRagdollPaused = false
                    LustSteal.nextScan = 0
                end)
            end

            local function _LustStartRagdollWatcher()
                if _LustRagdollPause.charConn then
                    _LustRagdollPause.charConn:Disconnect(); _LustRagdollPause.charConn = nil
                end
                if _LustRagdollPause.humConn then
                    _LustRagdollPause.humConn:Disconnect(); _LustRagdollPause.humConn = nil
                end
                local function attachChar(char)
                    if not char then return end
                    if _LustRagdollPause.humConn then
                        _LustRagdollPause.humConn:Disconnect(); _LustRagdollPause.humConn = nil
                    end
                    local hum = char:FindFirstChildOfClass("Humanoid")
                    if not hum then return end
                    _LustRagdollPause.humConn = trackLustConnection(hum.StateChanged:Connect(function(_, newState)
                        if newState == Enum.HumanoidStateType.Physics or newState == Enum.HumanoidStateType.Ragdoll then
                            _LustOnRagdoll()
                        end
                    end))
                end
                if localPlayer.Character then attachChar(localPlayer.Character) end
                _LustRagdollPause.charConn = trackLustConnection(localPlayer.CharacterAdded:Connect(function(char)
                    task.wait(0.2); attachChar(char)
                end))
            end

            local function _LustStopRagdollWatcher()
                if _LustRagdollPause.humConn then _LustRagdollPause.humConn:Disconnect(); _LustRagdollPause.humConn = nil end
                if _LustRagdollPause.charConn then _LustRagdollPause.charConn:Disconnect(); _LustRagdollPause.charConn = nil end
                _LustRagdollPause.token = _LustRagdollPause.token + 1
                _LustRagdollPaused = false
            end

            setAutoStealRadius = function(inputValue)
                local numericValue = tonumber(inputValue)
                if not numericValue then return LustSteal.StealRadius end
                LustSteal.StealRadius = math.clamp(numericValue, 0.5, 300)
                Steal.StealRadius = LustSteal.StealRadius
                updateStealRadiusUi()
                return LustSteal.StealRadius
            end

            startAutoSteal = function()
                if _LustStealConn and _LustStealConn.Connected then
                    Steal.AutoStealEnabled = true
                    if progressBarContainer then progressBarContainer.Visible = true end
                    LustSteal.nextScan = 0
                    return
                end
                Steal.AutoStealEnabled = true
                if progressBarContainer then progressBarContainer.Visible = true end

                task.spawn(function()
                    local plotsRoot = workspace:FindFirstChild("Plots")
                    if not plotsRoot then return end
                    local n = 0
                    for _, d in ipairs(plotsRoot:GetDescendants()) do
                        if d:IsA("ProximityPrompt") then
                            pcall(function() d.HoldDuration = 0 end)
                        end
                        n = n + 1
                        if n % 400 == 0 then task.wait() end
                    end
                end)

                _LustMarkDirty()
                LustSteal.nextScan = 0
                _LustStealConn = trackLustConnection(RunService.Heartbeat:Connect(function()
                    local ok, err = pcall(_LustOnHeartbeat)
                    if not ok then
                        LustS.phase = "idle"
                        LustS.prompt, LustS.pod, LustS.cfg = nil, nil, nil
                        LustStealState.active = false
                        LustStealState.phase = "idle"
                        LustIsStealing = false
                        LustS.root = nil
                        LustSteal.StructureCache.dirty = true
                        LustSteal.StructureCache.lastBuild = -math.huge
                        LustStealState.lastResult = "Error: " .. tostring(err)
                        LustSteal.nextScan = os.clock() + 0.2
                    end
                end))
                _LustStartRagdollWatcher()
            end

            stopAutoSteal = function()
                if _LustStealConn then _LustStealConn:Disconnect(); _LustStealConn = nil end
                _LustStopRagdollWatcher()
                Steal.AutoStealEnabled = false
                LustS.phase = "idle"
                LustS.prompt, LustS.pod, LustS.cfg = nil, nil, nil
                LustStealState.active = false
                LustStealState.phase = "idle"
                LustIsStealing = false
                if progressFill then
                    LustSteal._lastPctShown = 0
                    TweenService:Create(progressFill, TweenInfo.new(0.2), { Size = UDim2.new(0, 0, 1, 0) }):Play()
                end
                if progressPct then progressPct.Text = "0%" end
                if progressBarContainer then progressBarContainer.Visible = false end
                LustS.root = nil
                LustSteal.nextScan = 0
                local cache = LustSteal.StructureCache
                cache.plots = {}
                cache.dirty = true
                cache.lastBuild = -math.huge
                LustSteal.Data = setmetatable({}, { __mode = "k" })
            end

            trackLustConnection(localPlayer.CharacterAdded:Connect(function(character)
                if LustS.phase ~= "idle" then
                    _LustEndSteal("Character changed", false)
                end
                LustS.root = nil
                LustS.phase = "idle"
                LustS.prompt, LustS.pod, LustS.cfg = nil, nil, nil
                LustStealState.active = false
                LustStealState.phase = "idle"
                LustStealState.label = ""
                LustIsStealing = false
                _LustRagdollPause.token = _LustRagdollPause.token + 1
                _LustRagdollPaused = false

                local cache = LustSteal.StructureCache
                cache.plots = {}
                cache.dirty = true
                cache.lastBuild = -math.huge
                LustSteal.Data = setmetatable({}, { __mode = "k" })
                LustSteal.nextScan = os.clock() + 0.5
                _LustSetBar(0, true)

                task.spawn(function()
                    local sessionEnv = getgenv and getgenv() or _G
                    local sessionToken = rawget(sessionEnv, "__LustSessionToken")
                    local humanoid = character:WaitForChild("Humanoid", 6)
                    local root = character:WaitForChild("HumanoidRootPart", 6)
                    if not humanoid or not root then return end
                    local waited = 0
                    while _G.LustInstaResetInProgress and waited < 12
                        and localPlayer.Character == character
                        and rawget(sessionEnv, "__LustSessionToken") == sessionToken do
                        waited = waited + task.wait(0.1)
                    end
                    if rawget(sessionEnv, "__LustSessionToken") ~= sessionToken
                        or localPlayer.Character ~= character or humanoid.Health <= 0
                        or _G.LustInstaResetInProgress then return end
                    task.wait(0.25)
                    if localPlayer.Character ~= character or humanoid.Health <= 0 then return end
                    if not Steal.AutoStealEnabled then return end
                    _LustMarkDirty()
                    cache.lastBuild = -math.huge
                    LustSteal.nextScan = 0
                    if not (_LustStealConn and _LustStealConn.Connected) then
                        startAutoSteal()
                    end
                end)
            end))
        end
    end

    do
        -- Barrido original: desactiva la colisión de las partes de personajes de otros jugadores.
        -- Se registra para desconectarlo al limpiar/re-ejecutar el script.
        trackLustConnection(RunService.Stepped:Connect(function()
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= localPlayer and player.Character then
                    for _, descendant in ipairs(player.Character:GetDescendants()) do
                        if descendant:IsA("BasePart") then
                            descendant.CanCollide = false
                        end
                    end
                end
            end
        end))

        local genv = getgenv and getgenv() or _G
        local V3new, V3zero = Vector3.new, Vector3.zero
        local velState = genv.__LustVelocitySpoofState

        if type(velState) ~= "table" or velState.v == nil then
            velState = { hooked = false, v = V3zero, root = nil }
            genv.__LustVelocitySpoofState = velState
        end

        local velChecked = setmetatable({}, { __mode = "k" })
        velState.velChecked = velChecked
        local lastMoveDir = V3zero
        local MOVE_KEYS = {
            [Enum.KeyCode.W] = true, [Enum.KeyCode.A] = true,
            [Enum.KeyCode.S] = true, [Enum.KeyCode.D] = true,
            [Enum.KeyCode.Up] = true, [Enum.KeyCode.Left] = true,
            [Enum.KeyCode.Down] = true, [Enum.KeyCode.Right] = true,
        }

        local function hookVelHRP(hrp)
            if not hrp then return end
            velState.root = hrp
            velChecked[hrp] = true
            if velState.hooked then return end
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
                    local char = localPlayer.Character
                    return char ~= nil and t:IsDescendantOf(char)
                end

                if type(originalIndex) == "function" or type(originalIndex) == "table" then
                    mt.__index = newcclosure(function(self, key)
                        if not checkcaller() then
                            local good, mine = pcall(isOurRoot, self, key)
                            if good and mine then return velState.v end
                        end
                        if type(originalIndex) == "function" then
                            return originalIndex(self, key)
                        else
                            return originalIndex[key]
                        end
                    end)
                end

                if type(originalNewIndex) == "function" then
                    mt.__newindex = newcclosure(function(self, key, value)
                        if not checkcaller() then
                            local good, mine = pcall(isOurRoot, self, key)
                            if good and mine then
                                velState.v = value
                                return
                            end
                        end
                        return originalNewIndex(self, key, value)
                    end)
                end

                setreadonly(mt, true)
                velState.hooked = true
            end)

            if not ok then velState.hooked = false end
        end

        local function setupVelChecked(char)
            velChecked = setmetatable({}, { __mode = "k" })
            velState.velChecked = velChecked

            if not char then
                velState.root = nil
                return nil
            end

            local hrp = char:WaitForChild("HumanoidRootPart", 5)
            if hrp then
                velState.root = hrp
                velChecked[hrp] = true
            end
            return hrp
        end

        local function isRagdollState(hum)
            if not hum then return true end
            local st = hum:GetState()
            return hum.PlatformStand
                or st == Enum.HumanoidStateType.Physics
                or st == Enum.HumanoidStateType.Ragdoll
                or st == Enum.HumanoidStateType.FallingDown
        end

        local function applyVelocitySpeed(dir, spd, hrp)
            if not hrp or not hrp.Parent then return end
            if autoBatEnabled then return end
            if type(spd) ~= "number" or spd ~= spd or spd <= 0 or spd == math.huge then return end

            local currentVelocity = hrp.AssemblyLinearVelocity
            if _G._ZurichHub_MovementBlocked == true or _G._CrystalHub_MovementBlocked == true then
                local blockedVelocity = V3new(0, math.min(currentVelocity.Y, 0), 0)
                hrp.AssemblyLinearVelocity = blockedVelocity
                if velState.root == hrp then velState.v = blockedVelocity end
                return
            end

            local flatDirection = dir and V3new(dir.X, 0, dir.Z) or nil
            if flatDirection and flatDirection.Magnitude > 0.05 then
                pcall(function()
                    if hrp.SetNetworkOwner then hrp:SetNetworkOwner(localPlayer) end
                end)
                local unit = flatDirection.Unit
                local targetVelocity = V3new(
                    unit.X * spd,
                    currentVelocity.Y,
                    unit.Z * spd
                )
                hrp.AssemblyLinearVelocity = targetVelocity
                local visibleSpeed = math.min(spd, 20)
                local visibleVelocity = V3new(
                    unit.X * visibleSpeed,
                    currentVelocity.Y,
                    unit.Z * visibleSpeed
                )
                if velState.root == hrp then velState.v = visibleVelocity end
                _G.__LustLiveSpeed = { t = os.clock(), v = spd }
            else
                local stoppedVelocity = V3new(0, currentVelocity.Y, 0)
                hrp.AssemblyLinearVelocity = stoppedVelocity
                if velState.root == hrp then velState.v = stoppedVelocity end
            end
        end

        getSelectedMovementSpeed = function()
            local selectedSpeed
            if laggerToggled then
                local carrying = false
                local detector = _G.__LustAutoCarryIsCarrying
                if type(detector) == "function" then
                    local ok, result = pcall(detector, localPlayer.Character)
                    carrying = ok and result == true
                end
                if laggerPhase == 2 or carrying then
                    selectedSpeed = LAGGER_CARRY_SPEED
                else
                    selectedSpeed = LAGGER_SPEED
                end
            elseif speedMode then
                selectedSpeed = CS
            else
                selectedSpeed = NS
            end
            return math.clamp(tonumber(selectedSpeed) or 16, 0, 250)
        end

        if type(LustFloat) == "table" then
            LustFloat.getSelectedSpeed = function()
                if autoBatEnabled or autoLeftEnabled or autoRightEnabled or dropActive
                    or _G.LustInstaResetInProgress then
                    return nil
                end
                return getSelectedMovementSpeed()
            end
        end

        local function resetMovement()
            lastMoveDir = V3zero
        end

        local function clearPreviousSpeedState()
            resetMovement()
            local character = localPlayer and localPlayer.Character
            local root = character and character:FindFirstChild("HumanoidRootPart")
            if root then
                pcall(function()
                    local velocity = root.AssemblyLinearVelocity
                    root.AssemblyLinearVelocity = V3new(0, velocity.Y, 0)
                    if type(velState) == "table" and typeof(velState.v) == "Vector3" then
                        velState.v = V3new(0, velState.v.Y, 0)
                    end
                end)
            end
        end
        genv.__LustResetSpeedMovement = clearPreviousSpeedState
        _G.__LustResetSpeedMovement = clearPreviousSpeedState

        local engine = genv.__LustSpeedEngine
        if type(engine) ~= "table" then
            engine = { conn = nil }
            genv.__LustSpeedEngine = engine
        end

        local engineSignal
        do
            -- Aplicar la velocidad seleccionada al final del frame de entrada.
            engineSignal = RunService.RenderStepped
        end

        local function stopEngine()
            if engine.conn then
                pcall(function() engine.conn:Disconnect() end)
                engine.conn = nil
            end
            resetMovement()
        end

        local function startEngine()
            stopEngine()
            engine.acc = 0

            engine.conn = trackLustConnection(engineSignal:Connect(function(deltaTime)
                if _G.LustInstaResetInProgress then return end
                engine.acc = (engine.acc or 0) + (deltaTime or 0)
                if engine.acc < 0.016 then return end
                engine.acc = 0
                local character = localPlayer.Character
                local humanoid = character and character:FindFirstChildOfClass("Humanoid")
                local root = character and character:FindFirstChild("HumanoidRootPart")
                if not humanoid or not root or humanoid.Health <= 0 then return end

                if autoBatEnabled or autoLeftEnabled or autoRightEnabled or dropActive
                    or autoTPEnabled or _G.IsDropping
                    or _G.LustInstaResetInProgress
                    or (type(LustFloat) == "table" and LustFloat.running == true) then
                    resetMovement()
                    return
                end

                if isRagdollState(humanoid) then
                    lastMoveDir = V3zero
                    return
                end

                if velState.root ~= root or not velChecked[root] then
                    lastMoveDir = V3zero
                    setupVelChecked(character)
                    hookVelHRP(root)
                end

                local direction
                if humanoid.MoveDirection.Magnitude > 0 then
                    lastMoveDir = humanoid.MoveDirection
                    direction = humanoid.MoveDirection
                elseif lastMoveDir.Magnitude > 0 then
                    for key in pairs(MOVE_KEYS) do
                        if UserInputService:IsKeyDown(key) then
                            direction = lastMoveDir
                            break
                        end
                    end
                end

                local selectedSpeed = getSelectedMovementSpeed()
                applyVelocitySpeed(direction, selectedSpeed, root)
            end))
        end

        local function applySpeedNow()
            local character = localPlayer.Character
            local humanoid = character and character:FindFirstChildOfClass("Humanoid")
            local root = character and character:FindFirstChild("HumanoidRootPart")
            if not humanoid or not root or humanoid.Health <= 0 or isRagdollState(humanoid) then return end
            local direction = humanoid.MoveDirection.Magnitude > 0.05 and humanoid.MoveDirection or nil
            applyVelocitySpeed(direction, getSelectedMovementSpeed(), root)
        end

        genv.__LustApplySpeedNow = applySpeedNow
        _G.__LustApplySpeedNow = applySpeedNow
        genv.__LustStopSpeedEngine = stopEngine
        genv.__LustRefreshSpeedEngine = startEngine

        if localPlayer.Character then
            local hrp0 = setupVelChecked(localPlayer.Character)
            hookVelHRP(hrp0)
        end

        pcall(startEngine)

        -- Mantener un único par de conexiones de ciclo de vida entre recargas.
        for _, key in ipairs({ "charAddedConn", "charRemovingConn" }) do
            local oldConn = engine[key]
            if oldConn then pcall(function() oldConn:Disconnect() end); engine[key] = nil end
        end
        local engineSessionToken = lustSessionToken
        engine.charAddedConn = trackLustConnection(localPlayer.CharacterAdded:Connect(function(character)
            local humanoid = character:WaitForChild("Humanoid", 5)
            local root = character:WaitForChild("HumanoidRootPart", 5)
            if not humanoid or not root then return end
            if rawget(genv, "__LustSessionToken") ~= engineSessionToken or localPlayer.Character ~= character then return end
            resetMovement()
            velState.v = V3zero
            setupVelChecked(character)
            hookVelHRP(root)
            startEngine()
        end))

        engine.charRemovingConn = trackLustConnection(localPlayer.CharacterRemoving:Connect(function()
            stopEngine()
            velState.root = nil
            velState.v = V3zero
        end))
    end
end

do
    do
        local primaryValue = 0
        local secondaryValue = nil

        trackLustConnection(RunService.RenderStepped:Connect(function()
            local startTime = tick()
            if startTime - primaryValue < 0.08 then
                return
            end
            primaryValue = startTime

            if speedLabel and speedLabel.Parent then
                local character = localPlayer.Character
                local currentObject = character and character:FindFirstChildOfClass("Humanoid")
                local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
                character = character and character:FindFirstChild("Head")

                if character then
                    featureHelperA(character, speedLabel.Parent)
                end

                if currentObject and humanoidRootPart then
                    local labelText

                    if
                        currentObject.MoveDirection.Magnitude > 0
                        or Vector3.new(humanoidRootPart.Velocity.X, 0, humanoidRootPart.Velocity.Z).Magnitude > 1
                        or autoLeftEnabled
                        or autoRightEnabled
                    then
                        labelText = string.format(
                            "Speed: %.1f",
                            autoBatEnabled and _autoBatHadTarget and getAutoBatMovementSpeed()
                                or (autoLeftEnabled or autoRightEnabled) and NS
                                or getSelectedMovementSpeed()
                        )
                    else
                        labelText = "Speed: 0.0"
                    end

                    if secondaryValue ~= labelText then
                        secondaryValue = labelText
                        speedLabel.Text = labelText
                    end
                end
            end

            for _, player in ipairs(Players:GetPlayers()) do
                local character = player.Character
                character = character and character:FindFirstChild("Head")

                if player ~= localPlayer and character then
                    featureHelperA(character)
                end
            end
        end))
    end

    do
        local featureHelperF

        do
            trackLustConnection(Players.PlayerAdded:Connect(function(player)
                if player == localPlayer then
                    return
                end

                trackLustConnection(player.CharacterAdded:Connect(function(character)
                    task.wait(0.3)
                    character = character and character:FindFirstChild("Head")

                    if character then
                        featureHelperA(character)
                    end
                end))
            end))

            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= localPlayer then
                    trackLustConnection(player.CharacterAdded:Connect(function(character)
                        task.wait(0.3)
                        character = character and character:FindFirstChild("Head")

                        if character then
                            featureHelperA(character)
                        end
                    end))

                    if player.Character then
                        task.spawn(function()
                            local head = player.Character and player.Character:FindFirstChild("Head")

                            if head then
                                featureHelperA(head)
                            end
                        end)
                    end
                end
            end

            alConn = nil
            arConn = nil
            alCharacter = nil
            arCharacter = nil
            alPhase = 1
            arPhase = 1
            autoPathProxy = nil

            do
                local function featureHelperG()
                    local character = localPlayer.Character
                    local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
                    if not character or not humanoidRootPart then
                        return nil
                    end

                    if not autoPathProxy or autoPathProxy.Parent ~= character then
                        if autoPathProxy then
                            autoPathProxy:Destroy()
                        end

                        autoPathProxy = Instance.new("Part")
                        autoPathProxy.Name = "LustAutoPathProxy"
                        autoPathProxy.Size = Vector3.new(1, 1, 1)
                        autoPathProxy.Transparency = 1
                        autoPathProxy.CanCollide = false
                        autoPathProxy.Massless = true
                        autoPathProxy.Parent = character
                        local primaryControl = Instance.new("Weld")
                        primaryControl.Part0 = humanoidRootPart
                        primaryControl.Part1 = autoPathProxy
                        primaryControl.C0 = CFrame.new(0, 0, 0)
                        primaryControl.Parent = autoPathProxy
                    end

                    return autoPathProxy
                end

                stopAutoPathMovement = function()
                    if autoPathProxy then
                        autoPathProxy.AssemblyLinearVelocity = Vector3.zero
                    end

                    local model = localPlayer.Character
                    local character = model and model:FindFirstChildOfClass("Humanoid")
                    local root = model and model:FindFirstChild("HumanoidRootPart")
                    if character then character:Move(Vector3.zero, false) end
                    if root and root.Parent then
                        pcall(function()
                            local velocity = root.AssemblyLinearVelocity
                            root.AssemblyLinearVelocity = Vector3.new(0, velocity.Y, 0)
                            root.AssemblyAngularVelocity = Vector3.zero
                        end)
                    end
                end

                featureHelperF = function(assemblyLinearVelocity, inputValue)
                    local character = localPlayer.Character
                    local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
                    character = character and character:FindFirstChildOfClass("Humanoid")
                    local primaryValue = featureHelperG()

                    if primaryValue then
                        primaryValue.AssemblyLinearVelocity = assemblyLinearVelocity
                    elseif humanoidRootPart then
                        humanoidRootPart.AssemblyLinearVelocity = assemblyLinearVelocity
                    end

                    if character then
                        if inputValue and inputValue.Magnitude > 0.05 then
                            character:Move(inputValue, false)
                        else
                            character:Move(Vector3.zero, false)
                        end
                    end
                end
            end
        end

        do
            stopAutoLeft = function()
                if alConn then
                    alConn:Disconnect()
                    alConn = nil
                end

                alPhase = 1
                local character = alCharacter
                local hum = character and character:FindFirstChildOfClass("Humanoid")
                local root = character and character:FindFirstChild("HumanoidRootPart")
                if hum and hum.Parent then hum:Move(Vector3.zero, false) end
                if root and root.Parent then
                    pcall(function()
                        local velocity = root.AssemblyLinearVelocity
                        root.AssemblyLinearVelocity = Vector3.new(0, velocity.Y, 0)
                    end)
                end
                alCharacter = nil

                if autoLeftSetVisual then
                    autoLeftSetVisual(false)
                end
            end

            startAutoLeft = function()
                if alConn then stopAutoLeft() end
                alPhase = 1
                local routeCharacter = localPlayer.Character
                local routeHumanoid = routeCharacter and routeCharacter:FindFirstChildOfClass("Humanoid")
                if not routeCharacter or not routeHumanoid or routeHumanoid.Health <= 0 then
                    autoLeftEnabled = false
                    if autoLeftSetVisual then autoLeftSetVisual(false) end
                    return
                end
                alCharacter = routeCharacter

                alConn = trackLustConnection(RunService.Heartbeat:Connect(function()
                    if not autoLeftEnabled then
                        stopAutoLeft()
                        return
                    end
                    if localPlayer.Character ~= routeCharacter or not routeCharacter.Parent
                        or not routeHumanoid.Parent or routeHumanoid.Health <= 0 then
                        autoLeftEnabled = false
                        stopAutoLeft()
                        return
                    end
                    local character = routeCharacter
                    local root = routeCharacter:FindFirstChild("HumanoidRootPart")
                    local hum = routeHumanoid
                    if not root or not hum then
                        autoLeftEnabled = false
                        stopAutoLeft()
                        return
                    end

                    local spd = math.clamp(tonumber(NS) or 16, 1, 250)

                    if alPhase == 1 then
                        local tgt = Vector3.new(AP_L1.X, root.Position.Y, AP_L1.Z)

                        if (tgt - root.Position).Magnitude < 1 then
                            alPhase = 2
                            local d = AP_L2 - root.Position
                            local mv = Vector3.new(d.X, 0, d.Z).Unit
                            hum:Move(mv, false)
                            root.AssemblyLinearVelocity = Vector3.new(mv.X * spd, root.AssemblyLinearVelocity.Y, mv.Z * spd)
                            return
                        end

                        local d = AP_L1 - root.Position
                        local mv = Vector3.new(d.X, 0, d.Z).Unit
                        hum:Move(mv, false)
                        root.AssemblyLinearVelocity = Vector3.new(mv.X * spd, root.AssemblyLinearVelocity.Y, mv.Z * spd)
                    elseif alPhase == 2 then
                        local tgt = Vector3.new(AP_L2.X, root.Position.Y, AP_L2.Z)

                        if (tgt - root.Position).Magnitude < 1 then
                            hum:Move(Vector3.zero, false)
                            root.AssemblyLinearVelocity = Vector3.zero
                            autoLeftEnabled = false

                            if alConn then
                                alConn:Disconnect()
                                alConn = nil
                            end

                            alPhase = 1
                            alCharacter = nil

                            if autoLeftSetVisual then
                                autoLeftSetVisual(false)
                            end

                            local facePos = Vector3.new(AP_L_FACE.X, root.Position.Y, AP_L_FACE.Z)
                            if (facePos - root.Position).Magnitude > 0.01 then
                                root.CFrame = CFrame.new(root.Position, facePos)
                            end
                            return
                        end

                        local d = AP_L2 - root.Position
                        local mv = Vector3.new(d.X, 0, d.Z).Unit
                        hum:Move(mv, false)
                        root.AssemblyLinearVelocity = Vector3.new(mv.X * spd, root.AssemblyLinearVelocity.Y, mv.Z * spd)
                    end
                end))
            end

            stopAutoRight = function()
                if arConn then
                    arConn:Disconnect()
                    arConn = nil
                end

                arPhase = 1
                local character = arCharacter
                local hum = character and character:FindFirstChildOfClass("Humanoid")
                local root = character and character:FindFirstChild("HumanoidRootPart")
                if hum and hum.Parent then hum:Move(Vector3.zero, false) end
                if root and root.Parent then
                    pcall(function()
                        local velocity = root.AssemblyLinearVelocity
                        root.AssemblyLinearVelocity = Vector3.new(0, velocity.Y, 0)
                    end)
                end
                arCharacter = nil

                if autoRightSetVisual then
                    autoRightSetVisual(false)
                end
            end

            startAutoRight = function()
                if arConn then stopAutoRight() end
                arPhase = 1
                local routeCharacter = localPlayer.Character
                local routeHumanoid = routeCharacter and routeCharacter:FindFirstChildOfClass("Humanoid")
                if not routeCharacter or not routeHumanoid or routeHumanoid.Health <= 0 then
                    autoRightEnabled = false
                    if autoRightSetVisual then autoRightSetVisual(false) end
                    return
                end
                arCharacter = routeCharacter

                arConn = trackLustConnection(RunService.Heartbeat:Connect(function()
                    if not autoRightEnabled then
                        stopAutoRight()
                        return
                    end
                    if localPlayer.Character ~= routeCharacter or not routeCharacter.Parent
                        or not routeHumanoid.Parent or routeHumanoid.Health <= 0 then
                        autoRightEnabled = false
                        stopAutoRight()
                        return
                    end
                    local character = routeCharacter
                    local root = routeCharacter:FindFirstChild("HumanoidRootPart")
                    local hum = routeHumanoid
                    if not root or not hum then
                        autoRightEnabled = false
                        stopAutoRight()
                        return
                    end

                    local spd = math.clamp(tonumber(NS) or 16, 1, 250)

                    if arPhase == 1 then
                        local tgt = Vector3.new(AP_R1.X, root.Position.Y, AP_R1.Z)

                        if (tgt - root.Position).Magnitude < 1 then
                            arPhase = 2
                            local d = AP_R2 - root.Position
                            local mv = Vector3.new(d.X, 0, d.Z).Unit
                            hum:Move(mv, false)
                            root.AssemblyLinearVelocity = Vector3.new(mv.X * spd, root.AssemblyLinearVelocity.Y, mv.Z * spd)
                            return
                        end

                        local d = AP_R1 - root.Position
                        local mv = Vector3.new(d.X, 0, d.Z).Unit
                        hum:Move(mv, false)
                        root.AssemblyLinearVelocity = Vector3.new(mv.X * spd, root.AssemblyLinearVelocity.Y, mv.Z * spd)
                    elseif arPhase == 2 then
                        local tgt = Vector3.new(AP_R2.X, root.Position.Y, AP_R2.Z)

                        if (tgt - root.Position).Magnitude < 1 then
                            hum:Move(Vector3.zero, false)
                            root.AssemblyLinearVelocity = Vector3.zero
                            autoRightEnabled = false

                            if arConn then
                                arConn:Disconnect()
                                arConn = nil
                            end

                            arPhase = 1
                            arCharacter = nil

                            if autoRightSetVisual then
                                autoRightSetVisual(false)
                            end

                            local facePos = Vector3.new(AP_R_FACE.X, root.Position.Y, AP_R_FACE.Z)
                            if (facePos - root.Position).Magnitude > 0.01 then
                                root.CFrame = CFrame.new(root.Position, facePos)
                            end
                            return
                        end

                        local d = AP_R2 - root.Position
                        local mv = Vector3.new(d.X, 0, d.Z).Unit
                        hum:Move(mv, false)
                        root.AssemblyLinearVelocity = Vector3.new(mv.X * spd, root.AssemblyLinearVelocity.Y, mv.Z * spd)
                    end
                end))
            end
        end
    end
end

do
    createLocalPlayerBillboard = function(inputValue)
        local head = inputValue:WaitForChild("Head", 5)
        if not head then
            return
        end
        featureHelperA(head)
        local primaryControl = Instance.new("BillboardGui", head)
        primaryControl.Name = "RitualHeadBB"
        primaryControl.Size = UDim2.new(0, 200, 0, 82)
        primaryControl.StudsOffset = Vector3.new(0, 2.65, 0)
        primaryControl.AlwaysOnTop = true
        primaryControl.ResetOnSpawn = false
        primaryControl.LightInfluence = 0
        ragdollCountdownLabel = Instance.new("TextLabel", primaryControl)
        ragdollCountdownLabel.Size = UDim2.new(1, 0, 0, 22)
        ragdollCountdownLabel.Position = UDim2.new(0, 0, 0, 0)
        ragdollCountdownLabel.BackgroundTransparency = 1
        ragdollCountdownLabel.Text = ""
        ragdollCountdownLabel.Visible = false
        ragdollCountdownLabel.TextColor3 = primaryColor
        ragdollCountdownLabel.Font = Enum.Font.GothamBlack
        ragdollCountdownLabel.TextScaled = true
        ragdollCountdownLabel.ZIndex = 10
        ragdollCountdownLabel.TextStrokeTransparency = 0
        ragdollCountdownLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        local ggLabel = Instance.new("TextLabel", primaryControl)
        ggLabel.Name = "LustGG"
        ggLabel.Size = UDim2.new(1, 0, 0, 28)
        ggLabel.Position = UDim2.new(0, 0, 0, 22)
        ggLabel.BackgroundTransparency = 1
        ggLabel.Text = ".gg/KAIRNOX DUELS"
        ggLabel.TextColor3 = primaryColor
        ggLabel.Font = Enum.Font.GothamBlack
        ggLabel.TextScaled = false
        ggLabel.TextSize = 19
        ggLabel.TextXAlignment = Enum.TextXAlignment.Center
        ggLabel.TextYAlignment = Enum.TextYAlignment.Center
        ggLabel.TextStrokeTransparency = 0
        ggLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        local ggStroke = Instance.new("UIStroke", ggLabel)
        ggStroke.Color = Color3.fromRGB(0, 0, 0)
        ggStroke.Thickness = 1.5
        ggStroke.Transparency = 0.2
        speedLabel = Instance.new("TextLabel", primaryControl)
        speedLabel.Size = UDim2.new(1, 0, 0, 30)
        speedLabel.Position = UDim2.new(0, 0, 0, 50)
        speedLabel.BackgroundTransparency = 1
        speedLabel.Text = "Speed: 0.0"
        speedLabel.TextColor3 = primaryColor
        speedLabel.Font = Enum.Font.GothamBlack
        speedLabel.TextScaled = false
        speedLabel.TextSize = 22
        speedLabel.TextXAlignment = Enum.TextXAlignment.Center
        speedLabel.TextYAlignment = Enum.TextYAlignment.Center
        speedLabel.TextStrokeTransparency = 0
        speedLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        local speedStroke = Instance.new("UIStroke", speedLabel)
        speedStroke.Color = Color3.fromRGB(0, 0, 0)
        speedStroke.Thickness = 1.5
        speedStroke.Transparency = 0.2
    end

    ensureLocalPlayerBillboard = function()
        local character = localPlayer.Character
        if not character then
            return
        end

        if
            ragdollCountdownLabel
            and ragdollCountdownLabel.Parent
            and ragdollCountdownLabel:IsDescendantOf(character)
        then
            return
        end
        createLocalPlayerBillboard(character)
    end

    AR2 = {
        Enabled = false,
        Connection = nil,
        ResetCooldown = 0,
        RagdollStart = nil,
        TimerActive = false,
        RagdollActive = false,
        CountersTriggered = false,
        StateConnection = nil,
        TrackedHumanoid = nil,
        LastMoveDirection = Vector3.zero,
        MovementResumeUntil = 0,
        ControlModule = nil,
    }

    setAntiRagdollTimerText = function(labelText, inputValue)
        ensureLocalPlayerBillboard()

        if ragdollCountdownLabel then
            ragdollCountdownLabel.Text = labelText
            ragdollCountdownLabel.Visible = inputValue == true and ragdollCountdownEnabled == true
        end
    end

    do
        local function featureHelperF()
            if not autoTPEnabled then
                return
            end
            counterStateGuard = true

            if stopAutoTeleport then
                stopAutoTeleport()
            else
                autoTPEnabled = false
            end

            if setAutoTPVisual then
                setAutoTPVisual(false)
            end

            if saveConfig then
                saveConfig()
            end
        end

        local function featureHelperG()
            if not counterStateGuard then
                return
            end

            if isCountdownCounterBlocked and isCountdownCounterBlocked() then
                return
            end
            counterStateGuard = false
            autoTPEnabled = true

            if setAutoTPVisual then
                setAutoTPVisual(true)
            end

            if startAutoTeleport then
                startAutoTeleport()
            end

            if saveConfig then
                saveConfig()
            end
        end

        clearRagdollCountdownTimer = function()
            AR2.TimerActive = false
            AR2.RagdollStart = nil
            AR2.TimerDuration = nil
            AR2.ForcedTimer = false
            AR2.RagdollLostAt = nil
            setAntiRagdollTimerText("", false)
            featureHelperG()
        end

        updateAntiRagdollTimer = function(ragdollStart, inputValue)
            if inputValue and AR2.RagdollCountdownDone and not AR2.ForcedTimer then
                setAntiRagdollTimerText("", false)
                return
            end

            if not inputValue then
                AR2.RagdollCountdownDone = false
            end

            if inputValue and not AR2.TimerActive then
                featureHelperF()
                AR2.RagdollStart = ragdollStart
                AR2.TimerActive = true
                AR2.TimerDuration = AR2.TimerDuration or RAGDOLL_COUNTDOWN_SECONDS
                AR2.ForcedTimer = AR2.ForcedTimer == true
                AR2.RagdollLostAt = nil
            elseif inputValue then
                AR2.RagdollLostAt = nil
            elseif not inputValue and not AR2.ForcedTimer and AR2.TimerActive then
                AR2.RagdollLostAt = AR2.RagdollLostAt or ragdollStart
                if not (ragdollStart - AR2.RagdollLostAt < 0.25) then
                    clearRagdollCountdownTimer()
                    return
                end
                inputValue = true
            elseif not inputValue and not AR2.ForcedTimer then
                clearRagdollCountdownTimer()
                return
            end

            if AR2.TimerActive and AR2.RagdollStart then
                local amount = ragdollStart - AR2.RagdollStart
                local timerDuration = AR2.TimerDuration or RAGDOLL_COUNTDOWN_SECONDS

                if amount < timerDuration then
                    setAntiRagdollTimerText(string.format("%.1f", math.max(0, timerDuration - amount)), true)
                else
                    AR2.TimerActive = false
                    AR2.RagdollStart = nil
                    AR2.TimerDuration = nil
                    AR2.ForcedTimer = false
                    AR2.RagdollLostAt = nil
                    AR2.RagdollCountdownDone = true
                    setAntiRagdollTimerText("", false)
                    featureHelperG()
                end
            elseif not inputValue then
                setAntiRagdollTimerText("", false)
            end
        end

        forceRagdollCountdownFor = function(timerDuration)
            if isCountdownCounterBlocked and isCountdownCounterBlocked() then
                clearRagdollCountdownTimer()
                return
            end
            AR2.TimerToken = (AR2.TimerToken or 0) + 1
            local timerToken = AR2.TimerToken
            AR2.RagdollStart = tick()
            AR2.TimerActive = true
            AR2.TimerDuration = timerDuration or RAGDOLL_COUNTDOWN_SECONDS
            AR2.ForcedTimer = true
            AR2.RagdollCountdownDone = false
            updateAntiRagdollTimer(tick(), true)

            task.spawn(function()
                while AR2.TimerActive and AR2.TimerToken == timerToken do
                    local primaryValue = true
                    updateAntiRagdollTimer(tick(), primaryValue)
                    task.wait(0.05)
                end
            end)
        end

        setCountdownSoundActive = function(inputValue)
            countdownSoundActive = inputValue == true

            if countdownSoundActive then
                if autoTPEnabled then
                    counterStateGuard = true
                end

                clearRagdollCountdownTimer()

                if autoBatEnabled and disableAutoBat then
                    disableAutoBat()

                    if autoBatSetVisual then
                        autoBatSetVisual(false)
                    end
                end

                if autoTPEnabled then
                    if stopAutoTeleport then
                        stopAutoTeleport()
                    else
                        autoTPEnabled = false
                    end

                    if setAutoTPVisual then
                        setAutoTPVisual(false)
                    end
                end
            else
                featureHelperG()
            end
        end
    end
end

do
    monitorCountdownSound = function(inputValue)
        if not inputValue or inputValue.Name ~= "Countdown" or not inputValue:IsA("Sound") then
            return
        end

        if countdownSoundConn then
            countdownSoundConn:Disconnect()
            countdownSoundConn = nil
        end

        setCountdownSoundActive(true)

        countdownSoundConn = trackLustConnection(RunService.Heartbeat:Connect(function()
            if not inputValue.Parent or not inputValue.Playing or inputValue.TimePosition >= 5 then
                setCountdownSoundActive(false)

                if countdownSoundConn then
                    countdownSoundConn:Disconnect()
                    countdownSoundConn = nil
                end
            end
        end))
    end

    trackLustConnection(workspace.ChildAdded:Connect(function(child)
        if child.Name == "Countdown" and child:IsA("Sound") then
            monitorCountdownSound(child)
        end
    end))

    do
        local countdown = workspace:FindFirstChild("Countdown")

        if countdown and countdown:IsA("Sound") then
            monitorCountdownSound(countdown)
        end
    end
end

do
    isCountdownCounterBlocked = function()
        return countdownSoundActive == true
    end

    triggerAntiRagdollCounters = function(inputValue)
        if tick() < (counterPauseUntil or 0) then
            return
        end
        local primaryValue = isCountdownCounterBlocked and isCountdownCounterBlocked()
        local secondaryValue = isMedusaCounterBlocked and isMedusaCounterBlocked()
        local humanoid = inputValue and inputValue:FindFirstChildOfClass("Humanoid")
        local isActive = not humanoid or humanoid.Health <= 0

        if not isActive then
            local dead = Enum.HumanoidStateType.Dead
            isActive = humanoid:GetState() == dead
        end

        if isActive then
            pauseCounterChecks(2)
            return
        end

        if primaryValue then
            clearRagdollCountdownTimer()
        elseif ragdollCountdownEnabled and not secondaryValue then
            forceRagdollCountdownFor(RAGDOLL_COUNTDOWN_SECONDS)
        end

        if not batCounterEnabled and not batCounterV3Enabled then
            return
        end

        if batCounterEnabled and findBatForCounter and swingBatForCounter then
            local currentObject = findBatForCounter()

            if currentObject then
                swingBatForCounter(currentObject, inputValue)
            end
        end

        if primaryValue then
            return
        end

        if secondaryValue then
            return
        end
    end

    isAntiRagdollState = function(inputValue)
        return inputValue == Enum.HumanoidStateType.Physics
            or inputValue == Enum.HumanoidStateType.Ragdoll
            or inputValue == Enum.HumanoidStateType.FallingDown
    end

    getAntiRagdollMoveDirection = function(inputValue)
        local currentCamera = workspace.CurrentCamera
        local direction = Vector3.zero
        local isActive = false

        if currentCamera then
            local secondaryDirection =
                Vector3.new(currentCamera.CFrame.LookVector.X, 0, currentCamera.CFrame.LookVector.Z)
            local thirdDirection =
                Vector3.new(currentCamera.CFrame.RightVector.X, 0, currentCamera.CFrame.RightVector.Z)

            if secondaryDirection.Magnitude > 0 then
                secondaryDirection = secondaryDirection.Unit
            end

            if thirdDirection.Magnitude > 0 then
                thirdDirection = thirdDirection.Unit
            end

            if UserInputService:IsKeyDown(Enum.KeyCode.W) or UserInputService:IsKeyDown(Enum.KeyCode.Up) then
                direction += secondaryDirection
                isActive = true
            end

            if UserInputService:IsKeyDown(Enum.KeyCode.S) or UserInputService:IsKeyDown(Enum.KeyCode.Down) then
                direction -= secondaryDirection
                isActive = true
            end

            if UserInputService:IsKeyDown(Enum.KeyCode.D) or UserInputService:IsKeyDown(Enum.KeyCode.Right) then
                direction += thirdDirection
                isActive = true
            end

            if UserInputService:IsKeyDown(Enum.KeyCode.A) or UserInputService:IsKeyDown(Enum.KeyCode.Left) then
                direction -= thirdDirection
                isActive = true
            end
        end

        if not isActive and (UserInputService.TouchEnabled or UserInputService.GamepadEnabled) then
            if not AR2.ControlModule then
                local playerModule = localPlayer:FindFirstChild("PlayerScripts")
                    and localPlayer.PlayerScripts:FindFirstChild("PlayerModule")
                playerModule = playerModule and playerModule:FindFirstChild("ControlModule")

                if playerModule then
                    local ok, controlModule = pcall(require, playerModule)

                    if ok then
                        AR2.ControlModule = controlModule
                    end
                end
            end

            local controlModule = AR2.ControlModule

            if controlModule and controlModule.GetMoveVector and currentCamera then
                local ok, result = pcall(function()
                    return controlModule:GetMoveVector()
                end)

                if ok and typeof(result) == "Vector3" and result.Magnitude > 0.05 then
                    local secondaryDirection =
                        Vector3.new(currentCamera.CFrame.LookVector.X, 0, currentCamera.CFrame.LookVector.Z)
                    local thirdDirection =
                        Vector3.new(currentCamera.CFrame.RightVector.X, 0, currentCamera.CFrame.RightVector.Z)

                    if secondaryDirection.Magnitude > 0 then
                        secondaryDirection = secondaryDirection.Unit
                    end

                    if thirdDirection.Magnitude > 0 then
                        thirdDirection = thirdDirection.Unit
                    end

                    direction = thirdDirection * result.X + secondaryDirection * -result.Z
                    isActive = direction.Magnitude > 0.05
                end
            end
        end

        if not isActive and inputValue then
            local secondaryDirection = Vector3.new(inputValue.MoveDirection.X, 0, inputValue.MoveDirection.Z)

            if secondaryDirection.Magnitude > 0.05 then
                isActive = true
                direction = secondaryDirection
            end
        end

        if isActive and direction.Magnitude > 0.05 then
            AR2.LastMoveDirection = direction.Unit
        end

        local touchEnabled = not isActive and (UserInputService.TouchEnabled or UserInputService.GamepadEnabled)

        if touchEnabled then
            touchEnabled = tick() < (AR2.MovementResumeUntil or 0)
        end

        if touchEnabled and AR2.LastMoveDirection.Magnitude > 0.05 then
            return AR2.LastMoveDirection
        end
        return isActive and AR2.LastMoveDirection or Vector3.zero
    end

    zeroAntiRagdollVelocity = function(inputValue, secondaryInput)
        local primaryValue = getAntiRagdollMoveDirection(secondaryInput)

        if primaryValue.Magnitude > 0.05 then
            local amount = primaryValue.Unit * getSelectedMovementSpeed()
            inputValue.Velocity = Vector3.new(amount.X, 0, amount.Z)
            inputValue.AssemblyLinearVelocity = Vector3.new(amount.X, 0, amount.Z)
        else
            inputValue.Velocity = Vector3.new()
            inputValue.AssemblyLinearVelocity = Vector3.new()
        end

        inputValue.RotVelocity = Vector3.new()
        inputValue.AssemblyAngularVelocity = Vector3.new()
    end

    handleAntiRagdollStarted = function(inputValue, secondaryInput, tertiaryInput, fourthInput)
        AR2.MovementResumeUntil = (tertiaryInput or tick()) + 1

        if not AR2.RagdollActive then
            AR2.RagdollActive = true
        end

        if fourthInput ~= Enum.HumanoidStateType.FallingDown and not AR2.CountersTriggered then
            AR2.CountersTriggered = true
            triggerAntiRagdollCounters(inputValue, tertiaryInput)
        end
    end

    startAntiRagdoll = function()
        if AR2.Connection then
            return
        end
        AR2.Enabled = true

        AR2.Connection = trackLustConnection(RunService.Heartbeat:Connect(function()
            if not AR2.Enabled then
                return
            end
            local character = localPlayer.Character
            if not character then
                return
            end
            local primaryValue = character:FindFirstChildOfClass("Humanoid")
            local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")

            if not primaryValue or not humanoidRootPart or primaryValue.Health <= 0 then
                pauseCounterChecks(2)
                AR2.RagdollActive = false
                AR2.CountersTriggered = false
                return
            end

            if AR2.TrackedHumanoid ~= primaryValue then
                if AR2.StateConnection then
                    AR2.StateConnection:Disconnect()
                    AR2.StateConnection = nil
                end

                AR2.TrackedHumanoid = primaryValue

                AR2.StateConnection = trackLustConnection(primaryValue.StateChanged:Connect(function(old, new)
                    if not AR2.Enabled then
                        return
                    end
                    local character2 = localPlayer.Character
                    local humanoidRootPart2 = character2 and character2:FindFirstChild("HumanoidRootPart")
                    local humanoid = character2 and character2:FindFirstChildOfClass("Humanoid")

                    if not humanoid or humanoid.Health <= 0 or new == Enum.HumanoidStateType.Dead then
                        pauseCounterChecks(2)
                        AR2.RagdollActive = false
                        AR2.CountersTriggered = false
                        return
                    end

                    if isAntiRagdollState(new) then
                        handleAntiRagdollStarted(character2, humanoidRootPart2, tick(), new)
                    else
                        AR2.RagdollActive = false
                        AR2.CountersTriggered = false
                    end
                end))
            end

            local state = primaryValue:GetState()
            local startTime = tick()

            if isAntiRagdollState(state) then
                handleAntiRagdollStarted(character, humanoidRootPart, startTime, state)

                if startTime - AR2.ResetCooldown > 0.15 then
                    AR2.ResetCooldown = startTime

                    pcall(function()
                        primaryValue:ChangeState(Enum.HumanoidStateType.GettingUp)
                        humanoidRootPart.Velocity = Vector3.zero
                        humanoidRootPart.RotVelocity = Vector3.zero
                        humanoidRootPart.AssemblyLinearVelocity = Vector3.zero
                        humanoidRootPart.AssemblyAngularVelocity = Vector3.zero

                        for _, descendant in ipairs(character:GetDescendants()) do
                            if descendant:IsA("Motor6D") then
                                descendant.Enabled = true
                            end

                            if descendant:IsA("Constraint") then
                                descendant.Enabled = true
                            end
                        end

                        workspace.CurrentCamera.CameraSubject = primaryValue
                        local secondaryValue = localPlayer.PlayerScripts:FindFirstChild("PlayerModule")

                        if secondaryValue then
                            local module = require(secondaryValue:FindFirstChild("ControlModule"))

                            if module then
                                module:Enable()
                            end
                        end

                        primaryValue.AutoRotate = true
                        primaryValue.PlatformStand = false
                        primaryValue.Sit = false
                    end)
                end
            else
                AR2.RagdollActive = false
                AR2.CountersTriggered = false
            end
        end))
    end

    stopAntiRagdoll = function()
        AR2.Enabled = false

        if AR2.Connection then
            AR2.Connection:Disconnect()
            AR2.Connection = nil
        end

        if AR2.StateConnection then
            AR2.StateConnection:Disconnect()
            AR2.StateConnection = nil
        end

        AR2.TrackedHumanoid = nil
        AR2.RagdollActive = false
        AR2.CountersTriggered = false
        AR2.LastMoveDirection = Vector3.zero
        AR2.MovementResumeUntil = 0
        AR2.ControlModule = nil
    end

    -- ===== Anti Ragdoll "Purge" (portado de Yout v15) =====
    antiRagdollPurge = {}
    do
        local data = {
            active = false,
            isBoosting = false,
            cachedChar = nil,
            conns = {},
            _lastBoostTime = 0,
            gen = 0,
        }

        local function disconnectAll()
            for _, c in ipairs(data.conns) do
                pcall(function() c:Disconnect() end)
            end
            data.conns = {}
        end

        local function cacheCharacter()
            local character = localPlayer.Character
            if not character then return false end
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            local hrp = character:FindFirstChild("HumanoidRootPart")
            if not humanoid or not hrp then return false end
            data.cachedChar = { character = character, humanoid = humanoid, root = hrp }
            return true
        end

        local function isRagdolled()
            local cc = data.cachedChar
            if not cc or not cc.humanoid or not cc.humanoid.Parent then return false end
            local st = cc.humanoid:GetState()
            return st == Enum.HumanoidStateType.Physics
                or st == Enum.HumanoidStateType.Ragdoll
                or st == Enum.HumanoidStateType.FallingDown
        end

        local function activeSpeed()
            local ok, v = pcall(function()
                if laggerToggled then
                    return laggerPhase == 2 and LAGGER_CARRY_SPEED or LAGGER_SPEED
                end
                if speedMode then return CS end
                return NS
            end)
            return (ok and type(v) == "number") and v or 16
        end

        local function forceExitRagdoll()
            local cc = data.cachedChar
            if not cc or not cc.humanoid or not cc.root then return end
            local humanoid, root = cc.humanoid, cc.root
            if not humanoid.Parent or not root.Parent then return end

            pcall(function() localPlayer:SetAttribute("RagdollEndTime", workspace:GetServerTimeNow()) end)

            for _, d in ipairs(cc.character:GetDescendants()) do
                local kill = d:IsA("BallSocketConstraint")
                    or (d:IsA("Attachment") and d.Name:find("RagdollAttachment") ~= nil)
                if kill then
                    pcall(function() d:Destroy() end)
                elseif d:IsA("BasePart") and d.Anchored then
                    -- desanclar cualquier parte que haya quedado anclada por el ragdoll
                    pcall(function() d.Anchored = false end)
                end
            end

            if not data.isBoosting then
                data.isBoosting = true
                data._lastBoostTime = tick()
            end
            pcall(function() humanoid.WalkSpeed = activeSpeed() end)
            if humanoid.Health > 0 then
                pcall(function() humanoid:ChangeState(Enum.HumanoidStateType.Running) end)
            end
            pcall(function() root.Anchored = false end)
        end

        local function loop(myGen)
            while data.active and data.gen == myGen do
                task.wait(0.05)
                if not (data.active and data.gen == myGen) then break end
                if dropActive or _G.IsDropping then
                    -- no interferir mientras el drop esta en curso
                elseif isRagdolled() then
                    forceExitRagdoll()
                elseif data.isBoosting then
                    if tick() - (data._lastBoostTime or 0) > 0.35 or not isRagdolled() then
                        data.isBoosting = false
                        if data.cachedChar and data.cachedChar.humanoid then
                            pcall(function() data.cachedChar.humanoid.WalkSpeed = activeSpeed() end)
                        end
                    end
                end
            end
        end

        antiRagdollPurge.start = function()
            if data.active then return true end
            antiRagdollPurge.stop()
            if not cacheCharacter() then return false end
            data.gen = data.gen + 1
            local myGen = data.gen
            data.active = true
            data.isBoosting = false

            table.insert(data.conns, trackLustConnection(RunService.RenderStepped:Connect(function()
                local cam = workspace.CurrentCamera
                if cam and data.cachedChar and data.cachedChar.humanoid and data.cachedChar.humanoid.Parent then
                    cam.CameraSubject = data.cachedChar.humanoid
                end
            end)))
            table.insert(data.conns, trackLustConnection(localPlayer.CharacterAdded:Connect(function()
                data.isBoosting = false
                task.wait(0.5)
                if data.active and data.gen == myGen then cacheCharacter() end
            end)))
            task.spawn(loop, myGen)
            return true
        end

        antiRagdollPurge.stop = function()
            data.gen = data.gen + 1
            data.active = false
            if data.isBoosting and data.cachedChar and data.cachedChar.humanoid then
                pcall(function() data.cachedChar.humanoid.WalkSpeed = activeSpeed() end)
            end
            data.isBoosting = false
            disconnectAll()
            data.cachedChar = nil
        end

        antiRagdollPurge.isRunning = function() return data.active end
    end

    -- start/stop ahora respetan el modo elegido (Purge / Recover)
    do
        local recoverStart, recoverStop = startAntiRagdoll, stopAntiRagdoll
        startAntiRagdoll = function()
            if antiRagdollMode == "Purge" then
                recoverStop()
                antiRagdollPurge.start()
            else
                antiRagdollPurge.stop()
                recoverStart()
            end
        end
        stopAntiRagdoll = function()
            antiRagdollPurge.stop()
            recoverStop()
        end
    end

    do
        local clone = nil

        disableWalkAnimation = function()
            local character = localPlayer.Character
            if not character then
                return
            end
            local humanoid = character:FindFirstChildOfClass("Humanoid")

            if humanoid then
                for _, primaryValue in ipairs(humanoid:GetPlayingAnimationTracks()) do
                    pcall(function()
                        primaryValue:Stop()
                    end)
                end
            end

            local animate = character:FindFirstChild("Animate")

            if animate then
                clone = animate:Clone()
                animate:Destroy()
            end
        end

        restoreWalkAnimation = function()
            unwalkEnabled = false
            local character = localPlayer.Character

            if character and clone then
                clone:Clone().Parent = character
                clone = nil
            end
        end
        local unwalkCleanupEnv = getgenv and getgenv() or _G
        pcall(function() rawset(unwalkCleanupEnv, "__LustUnwalkCleanup", restoreWalkAnimation) end)
        pcall(function() rawset(_G, "__LustUnwalkCleanup", restoreWalkAnimation) end)
    end
end

local unwalkSessionEnv = getgenv and getgenv() or _G
local unwalkSessionToken = lustSessionToken
trackLustConnection(localPlayer.CharacterAdded:Connect(function(character)
    task.wait(0.5)
    if rawget(unwalkSessionEnv, "__LustSessionToken") ~= unwalkSessionToken
        or localPlayer.Character ~= character then
        return
    end
    if unwalkEnabled then disableWalkAnimation() end
end))

clearESPPlayer = function(inputValue)
    local primaryValue = espObjects[inputValue]
    if not primaryValue then
        return
    end

    if primaryValue.box then
        pcall(function()
            primaryValue.box:Destroy()
        end)
    end

    if primaryValue.speedBillboard then
        pcall(function()
            primaryValue.speedBillboard:Destroy()
        end)
    end

    if primaryValue.tracer then
        pcall(function()
            primaryValue.tracer:Destroy()
        end)
    end

    espObjects[inputValue] = nil
end

clearESP = function()
    for k in pairs(espObjects) do
        clearESPPlayer(k)
    end
end

getESPViewportPoint = function(inputValue, secondaryInput)
    local viewportSize = inputValue.ViewportSize
    local secondaryDirection = Vector2.new(viewportSize.X / 2, viewportSize.Y / 2)
    local primaryValue = inputValue:WorldToViewportPoint(secondaryInput)
    local screenPoint = Vector2.new(primaryValue.X, primaryValue.Y)

    if primaryValue.Z < 0 then
        screenPoint = secondaryDirection - screenPoint - secondaryDirection
    end

    local y = screenPoint.Y
    return Vector2.new(math.clamp(screenPoint.X, 4, viewportSize.X - 4), math.clamp(y, 4, viewportSize.Y - 4))
end

ensureESPGui = function()
    if espGui and espGui.Parent then
        return espGui
    end
    espGui = Instance.new("ScreenGui")
    espGui.Name = "LustESP"
    espGui.ResetOnSpawn = false
    espGui.IgnoreGuiInset = true
    espGui.DisplayOrder = 5

    pcall(function()
        espGui.Parent = gethui and gethui() or game:GetService("CoreGui")
    end)

    if not espGui.Parent then
        espGui.Parent = localPlayer:WaitForChild("PlayerGui")
    end

    return espGui
end

ensureESPPlayer = function(inputValue)
    if inputValue == localPlayer then
        return nil
    end
    local character = inputValue.Character
    local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
    local head = character and character:FindFirstChild("Head")

    if not character or not humanoidRootPart then
        clearESPPlayer(inputValue)

        return nil
    end

    local workingData = espObjects[inputValue] or {}
    local primaryValue = ensureESPGui()

    if not workingData.box or workingData.box.Parent ~= primaryValue then
        if workingData.box then
            pcall(function()
                workingData.box:Destroy()
            end)
        end

        local primaryControl = Instance.new("Frame", primaryValue)
        primaryControl.Name = "LustESPBox_" .. inputValue.Name
        primaryControl.BackgroundTransparency = 1
        primaryControl.BorderSizePixel = 0
        primaryControl.Visible = false
        primaryControl.ZIndex = 2
        local gradientControl = Instance.new("UIStroke", primaryControl)
        gradientControl.Color = primaryColor
        gradientControl.Thickness = 1.6
        gradientControl.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        workingData.box = primaryControl
    end

    if head and (not workingData.speedBillboard or workingData.speedBillboard.Parent ~= head) then
        if workingData.speedBillboard then
            pcall(function()
                workingData.speedBillboard:Destroy()
            end)
        end

        local lustHubOtherSpeed = head:FindFirstChild("LustHubOtherSpeed")

        if lustHubOtherSpeed then
            pcall(function()
                lustHubOtherSpeed:Destroy()
            end)
        end

        local billboardGui = Instance.new("BillboardGui", head)
        billboardGui.Name = "LustHubOtherSpeed"
        billboardGui.Size = UDim2.new(0, 100, 0, 22)
        billboardGui.StudsOffset = Vector3.new(0, 3.1, 0)
        billboardGui.AlwaysOnTop = true
        billboardGui.ResetOnSpawn = false
        billboardGui.LightInfluence = 0
        billboardGui.Enabled = espEnabled
        local primaryControl = Instance.new("TextLabel", billboardGui)
        primaryControl.Size = UDim2.new(1, 0, 1, 0)
        primaryControl.BackgroundTransparency = 1
        primaryControl.Text = "Speed: 0.0"
        primaryControl.TextColor3 = primaryColor
        primaryControl.Font = Enum.Font.GothamBlack
        primaryControl.TextScaled = false
        primaryControl.TextSize = 18
        primaryControl.TextStrokeTransparency = 0
        primaryControl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        workingData.speedBillboard = billboardGui
        workingData.speedLbl = primaryControl
        workingData.speedDisplayed = 0
    end

    if espTracersEnabled and not workingData.tracer then
        local rowContainer = Instance.new("Frame", primaryValue)
        rowContainer.Name = "LustESPTracer_" .. inputValue.Name
        rowContainer.AnchorPoint = Vector2.new(0.5, 0.5)
        rowContainer.BackgroundColor3 = primaryColor
        rowContainer.BackgroundTransparency = 0
        rowContainer.BorderSizePixel = 0
        rowContainer.Visible = false
        rowContainer.ZIndex = 1
        workingData.tracer = rowContainer
    elseif not espTracersEnabled and workingData.tracer then
        pcall(function()
            workingData.tracer:Destroy()
        end)

        workingData.tracer = nil
    end

    espObjects[inputValue] = workingData
    return workingData, humanoidRootPart
end

updateESP = function()
    local currentCamera = workspace.CurrentCamera
    if not currentCamera then
        return
    end
    local humanoidRootPart = localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= localPlayer then
            local primaryValue, secondaryValue = ensureESPPlayer(player)

            if primaryValue then
                local character = player.Character
                local humanoid = character and character:FindFirstChildOfClass("Humanoid")

                if character then
                    character = character:FindFirstChild("UpperTorso") or character:FindFirstChild("Torso")
                end

                if not secondaryValue or not humanoid or humanoid.Health <= 0 then
                    if primaryValue.box then
                        primaryValue.box.Visible = false
                    end

                    if primaryValue.speedBillboard then
                        primaryValue.speedBillboard.Enabled = false
                    end

                    if primaryValue.tracer then
                        primaryValue.tracer.Visible = false
                    end
                else
                    local currentObject =
                        currentCamera:WorldToViewportPoint(secondaryValue.Position + Vector3.new(0, 3.2, 0))
                    local currentItem =
                        currentCamera:WorldToViewportPoint(secondaryValue.Position + Vector3.new(0, -3, 0))

                    if primaryValue.tracer then
                        local targetObject = espTracersEnabled and humanoidRootPart and character
                        local visible = false

                        if targetObject then
                            local uiElement = getESPViewportPoint(currentCamera, humanoidRootPart.Position)
                            local stateToken = getESPViewportPoint(currentCamera, character.Position)
                            local amount = stateToken - uiElement
                            primaryValue.tracer.Position =
                                UDim2.fromOffset((uiElement.X + stateToken.X) / 2, (uiElement.Y + stateToken.Y) / 2)
                            primaryValue.tracer.Size = UDim2.fromOffset(amount.Magnitude, 1.5)
                            primaryValue.tracer.Rotation = math.deg(math.atan2(amount.Y, amount.X))
                            primaryValue.tracer.BackgroundColor3 = primaryColor
                            visible = true
                        end

                        primaryValue.tracer.Visible = visible
                    end

                    if currentObject.Z > 0 and currentItem.Z > 0 then
                        local amount = math.abs(currentItem.Y - currentObject.Y)
                        local calculatedValue = amount * 0.55
                        local secondaryAmount = (currentObject.X + currentItem.X) / 2
                        local remainingAmount = (currentObject.Y + currentItem.Y) / 2

                        if primaryValue.box then
                            primaryValue.box.Position =
                                UDim2.new(0, secondaryAmount - calculatedValue / 2, 0, remainingAmount - amount / 2)
                            primaryValue.box.Size = UDim2.new(0, calculatedValue, 0, amount)
                            primaryValue.box.Visible = espEnabled
                        end

                        if primaryValue.speedLbl then
                            local assemblyLinearVelocity = secondaryValue.AssemblyLinearVelocity
                            local magnitude =
                                Vector3.new(assemblyLinearVelocity.X, 0, assemblyLinearVelocity.Z).Magnitude

                            if not (humanoid.MoveDirection.Magnitude > 0 or magnitude > 1) then
                                primaryValue.speedDisplayed = 0
                            else
                                primaryValue.speedDisplayed = math.floor(math.max(magnitude, humanoid.WalkSpeed) + 0.5)
                            end

                            primaryValue.speedLbl.Text = string.format("Speed: %.1f", primaryValue.speedDisplayed or 0)
                        end

                        if primaryValue.speedBillboard then
                            primaryValue.speedBillboard.Enabled = espEnabled
                        end
                    elseif primaryValue.box then
                        primaryValue.box.Visible = false
                    end
                end
            end
        end
    end

    for k in pairs(espObjects) do
        if not k.Parent or not espEnabled and not espTracersEnabled then
            clearESPPlayer(k)
        end
    end
end

refreshESP = function()
    if espEnabled or espTracersEnabled then
        if not espConn then
            espConn = trackLustConnection(RunService.RenderStepped:Connect(updateESP))
        end

        updateESP()
    else
        if espConn then
            espConn:Disconnect()
            espConn = nil
        end

        clearESP()
    end
end

clearESP()

-- =====================================================================
-- Infinite Jump
-- =====================================================================

local INF_JUMP_UP_SPEED = 55
local INF_JUMP_FALL_SPEED = -46
local INF_JUMP_HOLD_INTERVAL = 0.16
local lastKeyboardHoldPulse = 0

_G.__LustInfJumpEnabled = false
_G._LustInfJumpMode = "HOLD"

do
    trackLustConnection(UserInputService.JumpRequest:Connect(function()
        if not _G.__LustInfJumpEnabled then return end
        local character = localPlayer.Character
        local root = character and character:FindFirstChild("HumanoidRootPart")
        if not root then return end
        local velocity = root.AssemblyLinearVelocity
        root.AssemblyLinearVelocity = Vector3.new(velocity.X, INF_JUMP_UP_SPEED, velocity.Z)
    end))

    trackLustConnection(RunService.Heartbeat:Connect(function()
        if not _G.__LustInfJumpEnabled or _G._LustInfJumpMode ~= "HOLD" then return end
        local character = localPlayer.Character
        if not character then return end
        local root = character:FindFirstChild("HumanoidRootPart")
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if not root or not humanoid or humanoid.Health <= 0 then return end
        local velocity = root.AssemblyLinearVelocity
        local textFocused = UserInputService:GetFocusedTextBox() ~= nil
        local spaceHeld = not textFocused and UserInputService:IsKeyDown(Enum.KeyCode.Space)
        if spaceHeld then
            local now = os.clock()
            if now - lastKeyboardHoldPulse >= INF_JUMP_HOLD_INTERVAL then
                lastKeyboardHoldPulse = now
                if velocity.Y < INF_JUMP_UP_SPEED then
                    pcall(function() humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end)
                    root.AssemblyLinearVelocity = Vector3.new(velocity.X, INF_JUMP_UP_SPEED, velocity.Z)
                end
            end
        elseif not textFocused and humanoid.Jump == true and velocity.Y < 30 then
            root.AssemblyLinearVelocity = Vector3.new(velocity.X, INF_JUMP_UP_SPEED, velocity.Z)
        elseif velocity.Y < -120 then
            root.AssemblyLinearVelocity = Vector3.new(velocity.X, INF_JUMP_FALL_SPEED, velocity.Z)
        end
    end))
end

startInfiniteJumpLoop = function()
    lastKeyboardHoldPulse = 0
    _G.__LustInfJumpEnabled = true
    infJumpEnabled = true
end

stopInfiniteJumpLoop = function()
    _G.__LustInfJumpEnabled = false
    infJumpEnabled = false
end

local featureHelperA, featureHelperB, featureHelperC, featureHelperD, featureHelperE, featureHelperF, featureHelperG, featureHelperH, featureHelperI, featureHelperJ
local featureHelperK, featureHelperL, featureHelperM, counterStateGuard, featureHelperN, featureHelperO

do
    do
        local activeConnection, featureHelperP, featureHelperQ, featureHelperR
        local dropTempPurge = false

        -- Activa el anti ragdoll mientras dura el drop (si no estaba activo)
        local function dropAntiRagOn()
            if antiRagdollEnabled or dropTempPurge then
                return
            end
            if antiRagdollPurge and antiRagdollPurge.start then
                dropTempPurge = true
                antiRagdollPurge.start()
            end
        end

        local function dropAntiRagOff()
            if not dropTempPurge then
                return
            end
            dropTempPurge = false
            task.delay(2.5, function()
                if not antiRagdollEnabled and not dropActive and antiRagdollPurge then
                    antiRagdollPurge.stop()
                end
            end)
        end

        do
            do
                featureHelperA = function(inputValue)
                    infJumpEnabled = inputValue == true

                    if infJumpEnabled then
                        startInfiniteJumpLoop()
                    else
                        stopInfiniteJumpLoop()
                    end
                end
            end

            trackLustConnection(localPlayer.CharacterAdded:Connect(function()
                infJumpGeneration = infJumpGeneration + 1
                _G.__LustInfJumpEnabled = infJumpEnabled == true
            end))

            DROP_ASCEND_DURATION = 0.18
            DROP_ASCEND_SPEED = 150

            do
                local isActive = false
                activeConnection = nil
                featureHelperP = nil

                featureHelperQ = function()
                    if autoTPEnabled then
                        isActive = true

                        if stopAutoTeleport then
                            stopAutoTeleport()
                        else
                            autoTPEnabled = false

                            if autoTPConn then
                                if autoTPConn.Disconnect then
                                    autoTPConn:Disconnect()
                                else
                                    task.cancel(autoTPConn)
                                end

                                autoTPConn = nil
                            end
                        end

                        if setAutoTPVisual then
                            setAutoTPVisual(false)
                        end
                    else
                        isActive = false
                    end
                end

                featureHelperR = function()
                    dropActive = false
                    _G.IsDropping = false
                    dropAntiRagOff()

                    if activeConnection then
                        activeConnection:Disconnect()
                        activeConnection = nil
                    end

                    if isActive then
                        isActive = false
                        autoTPEnabled = true

                        if setAutoTPVisual then
                            setAutoTPVisual(true)
                        end

                        if startAutoTeleport then
                            startAutoTeleport()
                        end
                    end
                end
            end
        end

        do
            do
                local function featureHelperS()
                    if dropActive then
                        return
                    end
                    dropActive = true
                    dropAntiRagOn()
                    featureHelperQ()

                    if autoBatEnabled then
                        disableAutoBat()

                        if autoBatSetVisual then
                            autoBatSetVisual(false)
                        end
                    end

                    local character = localPlayer.Character
                    if not character then
                        featureHelperR()
                        return
                    end

                    if not character:FindFirstChild("HumanoidRootPart") then
                        featureHelperR()
                        return
                    end
                    local startTime = tick()

                    activeConnection = trackLustConnection(RunService.Heartbeat:Connect(function()
                        if not dropActive then
                            featureHelperR()
                            return
                        end
                        local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
                        if not humanoidRootPart then
                            featureHelperR()
                            return
                        end

                        if DROP_ASCEND_DURATION <= tick() - startTime then
                            if activeConnection then
                                activeConnection:Disconnect()
                                activeConnection = nil
                            end

                            local humanoid = character:FindFirstChildOfClass("Humanoid")
                            local primaryValue = humanoid
                                and featureHelperP
                                and featureHelperP(character, humanoidRootPart, humanoid)

                            if primaryValue then
                                humanoidRootPart.CFrame =
                                    CFrame.new(humanoidRootPart.Position.X, primaryValue, humanoidRootPart.Position.Z)
                                humanoidRootPart.AssemblyLinearVelocity = Vector3.zero
                            end

                            featureHelperR()
                            return
                        end

                        local velocity = humanoidRootPart.Velocity
                        humanoidRootPart.Velocity = Vector3.new(velocity.X, DROP_ASCEND_SPEED, velocity.Z)
                    end))
                end

                local lastFlingDrop = 0

                -- Drop "Fling" (portado de Yout v15)
                local function featureHelperFling()
                    local character = localPlayer.Character
                    local root = character and character:FindFirstChild("HumanoidRootPart")
                    local hum = character and character:FindFirstChildOfClass("Humanoid")
                    if not root or not hum or hum.Health <= 0 then
                        return
                    end

                    local vel0 = root.AssemblyLinearVelocity
                    local cooldown = Vector3.new(vel0.X, 0, vel0.Z).Magnitude > 5 and 0.6 or 0.25
                    if tick() - lastFlingDrop < cooldown then
                        return
                    end
                    lastFlingDrop = tick()

                    dropActive = true
                    _G.IsDropping = true
                    dropAntiRagOn()
                    featureHelperQ()

                    local wasAutoBat = false
                    if autoBatEnabled then
                        wasAutoBat = true
                        disableAutoBat()
                        if autoBatSetVisual then
                            autoBatSetVisual(false)
                        end
                    end

                    local finished = false
                    local function finish()
                        if finished then
                            return
                        end
                        finished = true

                        local c = localPlayer.Character
                        local r = c and c:FindFirstChild("HumanoidRootPart")
                        local h = c and c:FindFirstChildOfClass("Humanoid")
                        if r then
                            r.AssemblyLinearVelocity = Vector3.zero
                            r.AssemblyAngularVelocity = Vector3.zero
                            if h and featureHelperP then
                                local groundY = featureHelperP(c, r, h)
                                if groundY then
                                    r.CFrame = CFrame.new(r.Position.X, groundY, r.Position.Z)
                                end
                            end
                            if h and h.Health > 0 then
                                pcall(function()
                                    h:ChangeState(Enum.HumanoidStateType.Running)
                                end)
                            end
                        end

                        featureHelperR()

                        if wasAutoBat then
                            pcall(enableAutoBat)
                            if autoBatSetVisual then
                                autoBatSetVisual(true)
                            end
                        end
                    end

                    task.spawn(function()
                        local startTime = tick()
                        while dropActive and tick() - startTime < 0.25 do
                            RunService.Heartbeat:Wait()
                            local c = localPlayer.Character
                            local r = c and c:FindFirstChild("HumanoidRootPart")
                            if not r then
                                break
                            end
                            local vel = r.AssemblyLinearVelocity
                            vel = Vector3.new(0, vel.Y, 0)
                            r.AssemblyLinearVelocity = vel * 10000 + Vector3.new(0, 10000, 0)
                            RunService.RenderStepped:Wait()
                            if r.Parent then
                                r.AssemblyLinearVelocity = vel
                            end
                            RunService.Stepped:Wait()
                            if r.Parent then
                                r.AssemblyLinearVelocity = vel + Vector3.new(0, 0.1, 0)
                            end
                        end
                        finish()
                    end)
                    task.delay(0.35, finish)
                end

                featureHelperB = function()
                    if isCountdownCounterBlocked and isCountdownCounterBlocked() then
                        return
                    end

                    if dropActive then
                        return
                    end

                    if dropBrainrotMode == "Fling" then
                        featureHelperFling()
                    else
                        featureHelperS()
                    end
                end
            end
        end

        featureHelperP = function(inputValue, secondaryInput, tertiaryInput)
            local worldPosition = secondaryInput.Position
            if worldPosition.Y <= -7 then
                return -7
            end
            local amount = (tertiaryInput.HipHeight or 2) + secondaryInput.Size.Y * 0.5 + 0.2
            local workingData = { "invis", "wall", "trigger", "barrier", "clip", "ghost" }

            local function featureHelperS(fourthInput)
                while fourthInput and fourthInput ~= workspace do
                    local primaryValue = string.lower(fourthInput.Name or "")

                    for _, secondaryValue in ipairs(workingData) do
                        if primaryValue:find(secondaryValue, 1, true) then
                            return fourthInput, true
                        end
                    end

                    fourthInput = fourthInput.Parent
                end

                return nil, false
            end

            local function featureHelperT(fourthInput)
                if fourthInput == workspace.Terrain then
                    return false
                end

                if not fourthInput or not fourthInput:IsA("BasePart") then
                    return true
                end

                if not fourthInput.CanCollide then
                    return true
                end
                local isActive = (fourthInput.Transparency or 0) >= 0.75

                if not isActive then
                    isActive = (fourthInput.LocalTransparencyModifier or 0) >= 0.75
                end

                if isActive then
                    return true
                end
                local primaryValue, secondaryValue = featureHelperS(fourthInput)
                return secondaryValue
            end

            local function featureHelperU(fourthInput)
                local raycastParams = RaycastParams.new()
                raycastParams.FilterType = Enum.RaycastFilterType.Exclude
                raycastParams.IgnoreWater = true
                local filterDescendantsInstances = { inputValue }

                for i = 1, 80 do
                    raycastParams.FilterDescendantsInstances = filterDescendantsInstances
                    local hit = workspace:Raycast(fourthInput, Vector3.new(0, -7 - fourthInput.Y, 0), raycastParams)
                    if not hit then
                        return nil
                    end
                    local primaryControl = hit.Instance

                    if featureHelperT(primaryControl) then
                        local primaryValue, secondaryValue = featureHelperS(primaryControl)
                        table.insert(filterDescendantsInstances, secondaryValue and primaryValue or primaryControl)
                        continue
                    end

                    return hit.Position.Y
                end

                return nil
            end

            local calculatedValue =
                math.max(0.75, math.min(2, math.max(secondaryInput.Size.X, secondaryInput.Size.Z) * 0.55))
            local animationProperties = {}
            local direction = Vector3.zero
            local secondaryDirection = Vector3.new(calculatedValue, 0, 0)
            local thirdDirection = Vector3.new(-calculatedValue, 0, 0)
            local fourthDirection = Vector3.new(0, 0, calculatedValue)
            local fifthDirection = Vector3.new(0, 0, -calculatedValue)
            local sixthDirection = Vector3.new(calculatedValue * 0.7, 0, calculatedValue * 0.7)
            local seventhDirection = Vector3.new(-calculatedValue * 0.7, 0, calculatedValue * 0.7)
            local eighthDirection = Vector3.new
            local ninthDirection = Vector3.new(calculatedValue * 0.7, 0, -calculatedValue * 0.7)
            animationProperties[1] = direction
            animationProperties[2] = secondaryDirection
            animationProperties[3] = thirdDirection
            animationProperties[4] = fourthDirection
            animationProperties[5] = fifthDirection
            animationProperties[6] = sixthDirection
            animationProperties[7] = seventhDirection
            animationProperties[8] = ninthDirection

            do
                local values = table.pack(eighthDirection(-calculatedValue * 0.7, 0, -calculatedValue * 0.7))
                table.move(values, 1, values.n, 9, animationProperties)
            end

            local primaryValue = featureHelperU(worldPosition + Vector3.new(0, 0.25, 0))

            if not primaryValue then
                for i = 2, #animationProperties do
                    local secondaryValue =
                        featureHelperU(worldPosition + animationProperties[i] + Vector3.new(0, 0.25, 0))

                    if secondaryValue and (not primaryValue or secondaryValue > primaryValue) then
                        primaryValue = secondaryValue
                    end
                end
            end

            if primaryValue then
                local secondaryAmount = primaryValue + amount
                if worldPosition.Y - 0.35 <= secondaryAmount then
                    return nil
                end
                return math.max(secondaryAmount, -7)
            end

            return -7
        end

        do
            local function featureHelperS(inputValue)
                local character = localPlayer.Character
                if not character then
                    return
                end
                local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
                if not humanoidRootPart then
                    return
                end
                local primaryValue = character:FindFirstChildOfClass("Humanoid")
                if not primaryValue then
                    return
                end

                if not inputValue then
                    if primaryValue.FloorMaterial ~= Enum.Material.Air then
                        return
                    end

                    if humanoidRootPart.Position.Y < autoTPHeight then
                        return
                    end
                end

                local secondaryValue = featureHelperP(character, humanoidRootPart, primaryValue)
                if not secondaryValue then
                    return
                end
                local cframe = CFrame.Angles
                local cFrame = humanoidRootPart.CFrame
                humanoidRootPart.CFrame = CFrame.new(
                    humanoidRootPart.Position.X,
                    secondaryValue,
                    humanoidRootPart.Position.Z
                ) * cframe(0, select(2, cFrame:ToEulerAnglesYXZ()), 0)
                humanoidRootPart.AssemblyLinearVelocity = Vector3.zero
            end

            startAutoTeleport = function()
                if isCountdownCounterBlocked and isCountdownCounterBlocked() then
                    autoTPEnabled = false

                    if setAutoTPVisual then
                        setAutoTPVisual(false)
                    end

                    return false
                end

                if autoTPConn then
                    autoTPConn:Disconnect()
                    autoTPConn = nil
                end

                autoTPConn = trackLustConnection(RunService.Heartbeat:Connect(function()
                    if not autoTPEnabled then
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
                    local isActive = humanoid and featureHelperP(character, humanoidRootPart, humanoid)
                    isActive = isActive and humanoidRootPart.Position.Y - isActive > autoTPHeight

                    if
                        not isActive
                        and humanoid
                        and humanoid.FloorMaterial == Enum.Material.Air
                        and humanoidRootPart.Position.Y >= autoTPHeight
                    then
                        isActive = true
                    end

                    if isActive then
                        pcall(function()
                            featureHelperS(true)
                        end)
                    end
                end))
            end

            stopAutoTeleport = function()
                autoTPEnabled = false

                if autoTPConn then
                    autoTPConn:Disconnect()
                    autoTPConn = nil
                end
            end

            featureHelperC = function()
                if isCountdownCounterBlocked and isCountdownCounterBlocked() then
                    return
                end

                pcall(function()
                    featureHelperS(true)
                end)
            end
        end
    end

    do
        local cameraSnapshots = setmetatable({}, { __mode = "k" })
        local function captureCameraSnapshot(camera)
            if not camera or cameraSnapshots[camera] then return end
            local ok, originalFov, originalMode = pcall(function()
                return camera.FieldOfView, camera.FieldOfViewMode
            end)
            if ok then
                cameraSnapshots[camera] = { fov = originalFov, mode = originalMode }
            end
        end
        local function restoreCameraSnapshot(camera)
            local snapshot = camera and cameraSnapshots[camera]
            if not snapshot then return end
            pcall(function()
                camera.FieldOfViewMode = snapshot.mode
                camera.FieldOfView = snapshot.fov
            end)
            cameraSnapshots[camera] = nil
        end
        local function restoreAllCameraSnapshots()
            for camera in pairs(cameraSnapshots) do
                restoreCameraSnapshot(camera)
            end
        end

        applyFieldOfView = function()
            local currentCamera = workspace.CurrentCamera

            if currentCamera and fieldOfViewEnabled then
                captureCameraSnapshot(currentCamera)
            end
            if currentCamera and fieldOfViewEnabled and currentCamera.FieldOfView ~= fieldOfView then
                pcall(function()
                    currentCamera.FieldOfView = fieldOfView
                end)
            end
        end

        resetFieldOfView = function()
            restoreAllCameraSnapshots()
        end

        featureHelperD = function()
            fieldOfViewEnabled = true
            captureCameraSnapshot(workspace.CurrentCamera)

            if fieldOfViewConn then
                fieldOfViewConn:Disconnect()
            end

            fieldOfViewConn = trackLustConnection(RunService.RenderStepped:Connect(function()
                if not fieldOfViewEnabled then
                    return
                end
                local currentCamera = workspace.CurrentCamera

                if currentCamera and currentCamera.FieldOfView ~= fieldOfView then
                    pcall(function()
                        currentCamera.FieldOfView = fieldOfView
                    end)
                end
            end))
        end

        featureHelperE = function()
            fieldOfViewEnabled = false

            if fieldOfViewConn then
                fieldOfViewConn:Disconnect()
                fieldOfViewConn = nil
            end

            resetFieldOfView()
        end

        featureHelperF = function()
            if stretchRezEnabled then
                return
            end

            if fieldOfViewEnabled then
                featureHelperE()

                if setFovVisual then
                    setFovVisual(false)
                end
            end

            stretchRezEnabled = true
            local currentCamera = workspace.CurrentCamera
            captureCameraSnapshot(currentCamera)

            if currentCamera then
                pcall(function()
                    currentCamera.FieldOfViewMode = Enum.FieldOfViewMode.Vertical
                    currentCamera.FieldOfView = fieldOfView
                end)
            end

            if stretchRezConn1 then
                stretchRezConn1:Disconnect()
                stretchRezConn1 = nil
            end

            if stretchRezConn2 then
                stretchRezConn2:Disconnect()
                stretchRezConn2 = nil
            end

            stretchRezConn1 = trackLustConnection(RunService.RenderStepped:Connect(function()
                if not stretchRezEnabled then
                    return
                end
                local currentCamera2 = workspace.CurrentCamera

                if currentCamera2 and currentCamera2.FieldOfView ~= fieldOfView then
                    pcall(function()
                        currentCamera2.FieldOfView = fieldOfView
                    end)
                end
            end))

            stretchRezConn2 = trackLustConnection(RunService.RenderStepped:Connect(function()
                if not stretchRezEnabled then
                    return
                end
                local currentCamera2 = workspace.CurrentCamera

                if currentCamera2 then
                    currentCamera2.CFrame = currentCamera2.CFrame
                        * CFrame.new(0, 0, 0, 1, 0, 0, 0, stretchRezY, 0, 0, 0, 1)
                end
            end))
        end

        featureHelperG = function()
            stretchRezEnabled = false

            if stretchRezConn1 then
                stretchRezConn1:Disconnect()
                stretchRezConn1 = nil
            end

            if stretchRezConn2 then
                stretchRezConn2:Disconnect()
                stretchRezConn2 = nil
            end

            restoreAllCameraSnapshots()

            return
        end

        local function cleanupCameraEffects()
            if stretchRezEnabled then
                featureHelperG()
            elseif fieldOfViewEnabled then
                featureHelperE()
            end
        end
        local cameraCleanupEnv = getgenv and getgenv() or _G
        pcall(function() rawset(cameraCleanupEnv, "__LustCameraEffectsCleanup", cleanupCameraEffects) end)
        pcall(function() rawset(_G, "__LustCameraEffectsCleanup", cleanupCameraEffects) end)

        local cameraSessionEnv = getgenv and getgenv() or _G
        local cameraSessionToken = lustSessionToken
        trackLustConnection(workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
            if rawget(cameraSessionEnv, "__LustSessionToken") ~= cameraSessionToken then return end
            if stretchRezEnabled then
                stretchRezEnabled = false
                task.wait(0.1)
                if rawget(cameraSessionEnv, "__LustSessionToken") ~= cameraSessionToken then return end
                featureHelperF()
            end

            if fieldOfViewEnabled and rawget(cameraSessionEnv, "__LustSessionToken") == cameraSessionToken then
                featureHelperD()
            end
        end))

        do
            local function featureHelperP(inputValue)
                pcall(function()
                    local primaryValue = setfflag or set_fflag
                    if not primaryValue then
                        return
                    end
                    primaryValue(
                        UserInputService.TouchEnabled and "DebugSkyGray" or "DebugSkyGray",
                        inputValue and "True" or "False"
                    )
                end)
            end

            local function featureHelperQ()
                pcall(function()
                    local lustInstantGraySky = Lighting:FindFirstChild("LustInstantGraySky")

                    if not lustInstantGraySky then
                        lustInstantGraySky = Instance.new("Atmosphere")
                        lustInstantGraySky.Name = "LustInstantGraySky"
                        lustInstantGraySky.Parent = Lighting
                    end

                    lustInstantGraySky.Density = 0.45
                    lustInstantGraySky.Offset = 0.15
                    lustInstantGraySky.Color = Color3.fromRGB(145, 145, 145)
                    lustInstantGraySky.Decay = Color3.fromRGB(95, 95, 95)
                    lustInstantGraySky.Glare = 0
                    lustInstantGraySky.Haze = 2
                    Lighting.FogColor = Color3.fromRGB(95, 95, 128)
                end)
            end

            local function featureHelperR()
                featureHelperP(false)

                pcall(function()
                    local lustInstantGraySky = Lighting:FindFirstChild("LustInstantGraySky")

                    if lustInstantGraySky then
                        lustInstantGraySky:Destroy()
                    end
                end)
            end

            local function featureHelperS(inputValue)
                pcall(function()
                    if inputValue:IsA("BasePart") then
                        inputValue.Material = Enum.Material.Plastic
                        inputValue.Reflectance = 0
                    elseif inputValue:IsA("Decal") or inputValue:IsA("Texture") then
                        inputValue.Transparency = 1
                    end
                end)
            end

            local function featureHelperT()
                featureHelperP(true)

                pcall(function()
                    Lighting.GlobalShadows = false
                    Lighting.FogEnd = 100000
                    Lighting.Brightness = 1
                    Lighting.EnvironmentDiffuseScale = 0
                    Lighting.EnvironmentSpecularScale = 0

                    for _, child in pairs(Lighting:GetChildren()) do
                        if
                            child:IsA("BloomEffect")
                            or child:IsA("SunRaysEffect")
                            or child:IsA("ColorCorrectionEffect")
                            or child:IsA("BlurEffect")
                            or child:IsA("DepthOfFieldEffect")
                        then
                            child.Enabled = false
                        end
                    end
                end)

                featureHelperQ()
            end

            enableAntiLag = function()
                if antiLagEnabled then
                    return
                end
                antiLagEnabled = true
                featureHelperT()

                for _, descendant in pairs(workspace:GetDescendants()) do
                    featureHelperS(descendant)
                end

                if antiLagDescConn then
                    antiLagDescConn:Disconnect()
                end

                antiLagDescConn = trackLustConnection(workspace.DescendantAdded:Connect(function(descendant)
                    if not antiLagEnabled then
                        return
                    end
                    featureHelperS(descendant)
                end))
            end

            disableAntiLag = function()
                antiLagEnabled = false

                if antiLagDescConn then
                    antiLagDescConn:Disconnect()
                    antiLagDescConn = nil
                end

                featureHelperR()
            end
        end
    end

    do
        do
            findMedusaCounterTool = function()
                local character = localPlayer.Character
                if not character then
                    return nil
                end

                for _, child in ipairs(character:GetChildren()) do
                    if child:IsA("Tool") then
                        local normalizedName = child.Name:lower()
                        if
                            normalizedName:find("medusa")
                            or normalizedName:find("head")
                            or normalizedName:find("stone")
                        then
                            return child
                        end
                    end
                end

                local backpack = localPlayer:FindFirstChild("Backpack")

                if backpack then
                    for _, child in ipairs(backpack:GetChildren()) do
                        if child:IsA("Tool") then
                            local normalizedName = child.Name:lower()
                            if
                                normalizedName:find("medusa")
                                or normalizedName:find("petrif")
                                or normalizedName:find("stone")
                            then
                                return child
                            end
                        end
                    end
                end

                return nil
            end

            useMedusaCounter = function()
                local isActive = medusaCounterDebounce

                if not isActive then
                    local primaryValue = medusaCounterLastUsed
                    isActive = tick() - primaryValue < MEDUSA_COUNTER_COOLDOWN
                end

                if isActive then
                    return
                end
                local character = localPlayer.Character
                if not character then
                    return
                end
                medusaCounterDebounce = true
                local primaryValue = findMedusaCounterTool()
                if not primaryValue then
                    medusaCounterDebounce = false
                    return
                end

                if primaryValue.Parent ~= character then
                    local humanoid = character:FindFirstChildOfClass("Humanoid")

                    if humanoid then
                        humanoid:EquipTool(primaryValue)
                    end
                end

                pcall(function()
                    primaryValue:Activate()
                end)

                medusaCounterLastUsed = tick()
                medusaCounterDebounce = false
            end

            handleMedusaDetected = function()
                medusaCounterBlocked = true
                medusaCounterBlockToken = medusaCounterBlockToken + 1
                local primaryValue = medusaCounterBlockToken

                if ragdollCountdownEnabled then
                    forceRagdollCountdownFor(MEDUSA_BLOCK_SECONDS)
                end

                task.delay(MEDUSA_BLOCK_SECONDS, function()
                    if primaryValue == medusaCounterBlockToken then
                        medusaCounterBlocked = false
                    end
                end)

                if medusaCounterEnabled then
                    useMedusaCounter()
                end
            end

            needsMedusaDetector = function()
                return medusaCounterEnabled or batCounterEnabled or batCounterV3Enabled or ragdollCountdownEnabled
            end

            isMedusaCounterBlocked = function()
                return medusaCounterBlocked == true
            end

            checkMedusaCounterPart = function(inputValue)
                if
                    needsMedusaDetector()
                    and inputValue
                    and inputValue:IsA("BasePart")
                    and inputValue.Anchored
                    and inputValue.Transparency >= 0.95
                then
                    handleMedusaDetected()
                end
            end

            watchMedusaCounterPart = function(inputValue)
                local activeConnection = trackLustConnection(inputValue:GetPropertyChangedSignal("Anchored"):Connect(function()
                    checkMedusaCounterPart(inputValue)
                end))

                local propertyConnection = trackLustConnection(inputValue:GetPropertyChangedSignal("Transparency"):Connect(function()
                    checkMedusaCounterPart(inputValue)
                end))

                return {
                    Disconnect = function()
                        pcall(function()
                            activeConnection:Disconnect()
                        end)

                        pcall(function()
                            propertyConnection:Disconnect()
                        end)
                    end,
                }
            end

            setupMedusaCounter = function(inputValue)
                for _, primaryValue in pairs(Conns.medusaCounter) do
                    pcall(function()
                        primaryValue:Disconnect()
                    end)
                end

                Conns.medusaCounter = {}

                if not inputValue then
                    return
                end

                for _, descendant in ipairs(inputValue:GetDescendants()) do
                    if descendant:IsA("BasePart") then
                        table.insert(Conns.medusaCounter, watchMedusaCounterPart(descendant))
                        checkMedusaCounterPart(descendant)
                    end
                end

                table.insert(
                    Conns.medusaCounter,
                    trackLustConnection(inputValue.DescendantAdded:Connect(function(descendant)
                        if descendant:IsA("BasePart") then
                            table.insert(Conns.medusaCounter, watchMedusaCounterPart(descendant))
                            checkMedusaCounterPart(descendant)
                        end

                        return
                    end))
                )

                return
            end

            stopMedusaCounter = function()
                if needsMedusaDetector() then
                    return
                end

                for _, primaryValue in pairs(Conns.medusaCounter) do
                    pcall(function()
                        primaryValue:Disconnect()
                    end)
                end

                Conns.medusaCounter = {}
                medusaCounterDebounce = false
            end

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

            findBatForCounter = function()
                local character = localPlayer.Character

                if character then
                    local primaryValue = localPlayer:FindFirstChildOfClass("Backpack")

                    for _, secondaryValue in ipairs(BAT_COUNTER_SLAP_LIST) do
                        local currentObject = character:FindFirstChild(secondaryValue)
                            or primaryValue and primaryValue:FindFirstChild(secondaryValue)
                        if currentObject then
                            return currentObject
                        end
                    end

                    for _, child in ipairs(character:GetChildren()) do
                        if child:IsA("Tool") and child.Name:lower():find("bat") then
                            return child
                        end
                    end

                    if primaryValue then
                        for _, child in ipairs(primaryValue:GetChildren()) do
                            if child:IsA("Tool") and child.Name:lower():find("bat") then
                                return child
                            end
                        end
                    end

                    return nil
                end
            end

            getEquippedAutoBatTool = function(inputValue)
                if not inputValue then
                    return nil
                end

                for _, child in ipairs(inputValue:GetChildren()) do
                    local normalizedName = child.Name:lower()
                    if child:IsA("Tool") and normalizedName:find("bat") then
                        return child
                    end
                end

                return nil
            end

            featureHelperH = function()
                local character = localPlayer.Character
                if not character then
                    return nil
                end
                local bat = character:FindFirstChild("Bat")
                if bat and bat:IsA("Tool") then
                    return bat
                end
                local backpack = localPlayer:FindFirstChild("Backpack")

                if backpack then
                    local bat2 = backpack:FindFirstChild("Bat")

                    if bat2 and bat2:IsA("Tool") then
                        pcall(function()
                            bat2.Parent = character
                        end)

                        return bat2
                    end
                end

                return nil
            end

            do
                local function featureHelperP()
                    for _, primaryValue in ipairs(healthConnections) do
                        pcall(function()
                            primaryValue:Disconnect()
                        end)
                    end

                    healthConnections = {}

                    if healthLoopConnection then
                        healthLoopConnection:Disconnect()
                        healthLoopConnection = nil
                    end
                end

                local function featureHelperQ(inputValue)
                    featureHelperP()
                    local humanoid

                    if inputValue then
                        humanoid = inputValue:FindFirstChildOfClass("Humanoid")
                            or inputValue:WaitForChild("Humanoid", 5)
                    else
                        humanoid = inputValue
                    end

                    if not humanoid or not isHealthLockEnabled then
                        return
                    end

                    pcall(function()
                        humanoid.MaxHealth = math.huge
                        humanoid.Health = math.huge
                        humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
                    end)

                    table.insert(
                        healthConnections,
                        trackLustConnection(humanoid.StateChanged:Connect(function(old, new)
                            if not isHealthLockEnabled or not humanoid.Parent then
                                return
                            end

                            if new == Enum.HumanoidStateType.Dead then
                                pcall(function()
                                    humanoid.Health = math.huge
                                    humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
                                end)
                            end
                        end))
                    )

                    table.insert(
                        healthConnections,
                        trackLustConnection(humanoid:GetPropertyChangedSignal("Health"):Connect(function()
                            if isHealthLockEnabled and humanoid.Parent and humanoid.Health < humanoid.MaxHealth then
                                pcall(function()
                                    humanoid.Health = math.huge
                                end)
                            end
                        end))
                    )

                    healthLoopConnection = trackLustConnection(RunService.Heartbeat:Connect(function()
                        if isHealthLockEnabled and humanoid.Parent and humanoid.Health < humanoid.MaxHealth then
                            pcall(function()
                                humanoid.Health = math.huge
                            end)
                        end
                    end))
                end

                featureHelperI = function()
                    isHealthLockEnabled = true

                    if characterHealthConnection then
                        characterHealthConnection:Disconnect()
                    end

                    featureHelperQ(localPlayer.Character)

                    characterHealthConnection = trackLustConnection(localPlayer.CharacterAdded:Connect(function(character)
                        if not isHealthLockEnabled then
                            return
                        end
                        task.wait(0.1)
                        featureHelperQ(character)
                    end))
                end

                featureHelperJ = function()
                    isHealthLockEnabled = false
                    featureHelperP()

                    if characterHealthConnection then
                        characterHealthConnection:Disconnect()
                        characterHealthConnection = nil
                    end

                    local character = localPlayer.Character and localPlayer.Character:FindFirstChildOfClass("Humanoid")

                    if character then
                        pcall(function()
                            character:SetStateEnabled(Enum.HumanoidStateType.Dead, true)
                            character.MaxHealth = 100
                            character.Health = 100
                        end)
                    end
                end
            end
        end

        featureHelperK = function(inputValue, physicsRepRootPart)
            if not inputValue then
                return false
            end
            local genv = getgenv and getgenv() or _G

            for _, primaryValue in ipairs({
                "sethiddenproperty",
                "set_hidden_property",
                "sethiddenprop",
                "set_hidden_prop",
            }) do
                local value = rawget(genv, primaryValue)
                if type(value) == "function" and pcall(value, inputValue, "PhysicsRepRootPart", physicsRepRootPart) then
                    return true
                end
            end

            return pcall(function()
                inputValue.PhysicsRepRootPart = physicsRepRootPart
            end)
        end

        featureHelperL = function(inputValue)
            local primaryValue = inputValue and inputValue:FindFirstChildOfClass("Humanoid")
            if not primaryValue then
                return
            end

            pcall(function()
                local playingAnimationTracks = primaryValue:GetPlayingAnimationTracks()

                for i = #playingAnimationTracks, 1, -1 do
                    playingAnimationTracks[i]:Stop()
                end
            end)
        end
    end

    featureHelperM = function(inputValue)
        if not autoSwingEnabled then return end
        local tool = inputValue and inputValue:FindFirstChildOfClass("Tool")
        if not tool then return end
        local name = tostring(tool.Name or ""):lower()
        if not name:find("bat", 1, true) and not name:find("slap", 1, true) then return end
        pcall(function()
            tool:Activate()
            local remoteEvent = tool:FindFirstChildWhichIsA("RemoteEvent")
            if remoteEvent then remoteEvent:FireServer() end
        end)
    end

    swingBatForCounter = function(inputValue, secondaryInput)
        local primaryValue = secondaryInput:FindFirstChildOfClass("Humanoid")

        if inputValue.Parent ~= secondaryInput and primaryValue then
            pcall(function()
                primaryValue:EquipTool(inputValue)
            end)
        end

        local remoteEvent = inputValue:FindFirstChildOfClass("RemoteEvent")
            or inputValue:FindFirstChildOfClass("RemoteFunction")

        if remoteEvent and remoteEvent:IsA("RemoteEvent") then
            pcall(function()
                remoteEvent:FireServer()
            end)

            pcall(function()
                remoteEvent:FireServer()
            end)
        else
            pcall(function()
                inputValue:Activate()
            end)

            pcall(function()
                inputValue:Activate()
            end)
        end
    end

    do
        local activeConnection = nil
        local primaryValue = nil
        local secondaryValue = nil
        local previousAutoRotate = nil
        counterStateGuard = false

        local function featureHelperP()
            if primaryValue then
                pcall(function() primaryValue:Destroy() end)
                primaryValue = nil
            end
            if secondaryValue and secondaryValue.Parent then
                local restoreAutoRotate = previousAutoRotate
                if restoreAutoRotate == nil then restoreAutoRotate = true end
                pcall(function()
                    secondaryValue.AutoRotate = restoreAutoRotate
                    local character = secondaryValue.Parent
                    local root = character and character:FindFirstChild("HumanoidRootPart")
                    if root then root.AssemblyAngularVelocity = Vector3.zero end
                end)
            end
            secondaryValue = nil
            previousAutoRotate = nil
        end

        featureHelperN = function()
            if activeConnection then
                activeConnection:Disconnect()
                activeConnection = nil
            end
            featureHelperP()
        end

        featureHelperO = function()
            featureHelperN()
            local expiresAt = tick() + 0.5
            activeConnection = trackLustConnection(RunService.RenderStepped:Connect(function()
                if tick() >= expiresAt or not batCounterEnabled or batCounterVersion ~= "V1" then
                    featureHelperN()
                    return
                end
                local character = localPlayer.Character
                local root = character and character:FindFirstChild("HumanoidRootPart")
                local humanoid = character and character:FindFirstChildOfClass("Humanoid")
                if not root or not humanoid or humanoid.Health <= 0 then
                    featureHelperP()
                    return
                end

                local nearestDistance = 20
                local targetRoot = nil
                for _, player in ipairs(Players:GetPlayers()) do
                    if player ~= localPlayer and player.Character then
                        local otherRoot = player.Character:FindFirstChild("HumanoidRootPart")
                        local otherHumanoid = player.Character:FindFirstChildOfClass("Humanoid")
                        if otherRoot and otherHumanoid and otherHumanoid.Health > 0 then
                            local distance = (root.Position - otherRoot.Position).Magnitude
                            if distance <= nearestDistance then
                                nearestDistance = distance
                                targetRoot = otherRoot
                            end
                        end
                    end
                end
                if not targetRoot then
                    featureHelperP()
                    return
                end

                if not primaryValue or primaryValue.Parent ~= root then
                    if primaryValue then pcall(function() primaryValue:Destroy() end) end
                    if secondaryValue and secondaryValue ~= humanoid and secondaryValue.Parent then
                        local restoreAutoRotate = previousAutoRotate
                        if restoreAutoRotate == nil then restoreAutoRotate = true end
                        pcall(function()
                            secondaryValue.AutoRotate = restoreAutoRotate
                            local oldCharacter = secondaryValue.Parent
                            local oldRoot = oldCharacter and oldCharacter:FindFirstChild("HumanoidRootPart")
                            if oldRoot then oldRoot.AssemblyAngularVelocity = Vector3.zero end
                        end)
                    end
                    if secondaryValue ~= humanoid then
                        previousAutoRotate = humanoid.AutoRotate
                    end
                    secondaryValue = humanoid
                    local bodyAngularVelocity = Instance.new("BodyAngularVelocity")
                    bodyAngularVelocity.Name = "LustCounterBodyLock"
                    bodyAngularVelocity.MaxTorque = Vector3.new(0, math.huge, 0)
                    bodyAngularVelocity.P = 5000
                    bodyAngularVelocity.Parent = root
                    primaryValue = bodyAngularVelocity
                end

                humanoid.AutoRotate = false
                local offset = targetRoot.Position - root.Position
                local direction = Vector3.new(offset.X, 0, offset.Z)
                if direction.Magnitude > 0.01 then
                    local targetCFrame = CFrame.lookAt(root.Position, root.Position + direction.Unit)
                    local _, yaw, _ = (root.CFrame:Inverse() * targetCFrame):ToEulerAnglesXYZ()
                    primaryValue.AngularVelocity = root.CFrame:VectorToWorldSpace(
                        Vector3.new(0, math.clamp(yaw, -math.pi, math.pi) * 100, 0)
                    )
                end
            end))
        end
    end
end

do
    local featureHelperP, featureHelperQ

    do
        do
            local isActive = false

            triggerBatCounterV3 = function()
                if isCountdownCounterBlocked and isCountdownCounterBlocked() then
                    return
                end

                if isMedusaCounterBlocked and isMedusaCounterBlocked() then
                    return
                end

                if batCounterVersion == "V3" and autoSwingEnabled then
                    local character = localPlayer.Character
                    local primaryValue = findBatForCounter()

                    if character and primaryValue then
                        swingBatForCounter(primaryValue, character)
                    end
                end

                if autoBatEnabled then
                    return
                end

                if batCounterVersion == "V3" then
                    local primaryValue = queueAutoBatStart()

                    if autoBatSetVisual then
                        autoBatSetVisual(primaryValue == true)
                    end
                end
            end

            startBatCounter = function()
                if Conns.batCounter then
                    return
                end

                Conns.batCounter = trackLustConnection(RunService.Heartbeat:Connect(function()
                    if not batCounterEnabled and not batCounterV3Enabled and not ragdollCountdownEnabled then
                        return
                    end
                    local primaryValue = isCountdownCounterBlocked and isCountdownCounterBlocked()

                    if primaryValue then
                        clearRagdollCountdownTimer()
                    end

                    if tick() < (counterPauseUntil or 0) then
                        local secondaryValue = false
                        updateAntiRagdollTimer(tick(), secondaryValue)
                        return
                    end

                    local character = localPlayer.Character

                    if not character then
                        counterStateGuard = false
                        featureHelperN()
                        return
                    end

                    local humanoid = character:FindFirstChildOfClass("Humanoid")
                    if not humanoid then
                        counterStateGuard = false
                        featureHelperN()
                        return
                    end
                    local isReady = humanoid.Health <= 0

                    if not isReady then
                        local dead = Enum.HumanoidStateType.Dead
                        isReady = humanoid:GetState() == dead
                    end

                    if isReady then
                        counterStateGuard = false
                        featureHelperN()
                        pauseCounterChecks(2)
                        updateAntiRagdollTimer(tick(), false)
                        return
                    end

                    local state = humanoid:GetState()
                    local isComplete = state == Enum.HumanoidStateType.Physics
                        or state == Enum.HumanoidStateType.Ragdoll

                    if not primaryValue then
                        updateAntiRagdollTimer(tick(), isComplete)
                    end

                    if isComplete then
                        if not isActive then
                            isActive = true
                        end

                        if batCounterEnabled then
                            if batCounterVersion == "V1" and not counterStateGuard then
                                counterStateGuard = true
                                featureHelperO()
                            end
                            local batTool = findBatForCounter()
                            if batTool then
                                swingBatForCounter(batTool, character)
                            end
                        end

                        if batCounterV3Enabled and not primaryValue then
                            triggerBatCounterV3()
                        end
                    else
                        counterStateGuard = false
                        isActive = false
                    end
                end))
            end

            stopBatCounter = function()
                if Conns.batCounter then
                    Conns.batCounter:Disconnect()
                    Conns.batCounter = nil
                end

                counterStateGuard = false
                featureHelperN()
                isActive = false
            end
            local bodyLockCleanupEnv = getgenv and getgenv() or _G
            pcall(function() rawset(bodyLockCleanupEnv, "__LustBatCounterCleanup", stopBatCounter) end)
            pcall(function() rawset(_G, "__LustBatCounterCleanup", stopBatCounter) end)
        end

        findAutoBatTool = function()
            local character = localPlayer.Character
            if not character then
                return nil
            end

            for _, child in ipairs(character:GetChildren()) do
                local normalizedName = child.Name:lower()
                if child:IsA("Tool") and (normalizedName:find("bat", 1, true) or normalizedName:find("slap", 1, true)) then
                    return child
                end
            end

            local backpack = localPlayer:FindFirstChild("Backpack")

            if backpack then
                for _, child in ipairs(backpack:GetChildren()) do
                    local normalizedName = child.Name:lower()
                    if child:IsA("Tool") and (normalizedName:find("bat", 1, true) or normalizedName:find("slap", 1, true)) then
                        return child
                    end
                end
            end

            return nil
        end

        featureHelperP = function()
            if isAutoBatBusy then return end
            isAutoBatBusy = true
            local character = localPlayer.Character
            local humanoid = character and character:FindFirstChildOfClass("Humanoid")
            if not character or not humanoid then
                isAutoBatBusy = false
                return
            end
            local tool = findAutoBatTool()
            if tool then
                pcall(function()
                    if tool.Parent ~= character then humanoid:UnequipTools() end
                    humanoid:EquipTool(tool)
                end)
            end
            isAutoBatBusy = false
        end

        featureHelperQ = function()
            local root = localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")
            if not root then return nil end
            local nearestDistance = math.huge
            local nearestRoot = nil
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= localPlayer and player.Character then
                    local otherRoot = player.Character:FindFirstChild("HumanoidRootPart")
                    local otherHumanoid = player.Character:FindFirstChildOfClass("Humanoid")
                    if otherRoot and otherHumanoid and otherHumanoid.Health > 0 then
                        local distance = (otherRoot.Position - root.Position).Magnitude
                        if distance < nearestDistance then
                            nearestDistance = distance
                            nearestRoot = otherRoot
                        end
                    end
                end
            end
            return nearestRoot
        end

        do
            local workingData = {}

            local function featureHelperR(inputValue)
                if not (autoBatEnabled and mirrorTPEnabled and inputValue and inputValue.Parent) then
                    return
                end
                local primaryValue, secondaryValue = inputValue.CFrame:ToEulerAnglesYXZ()
                inputValue.CFrame = CFrame.new(inputValue.Position.X, -7, inputValue.Position.Z)
                    * CFrame.Angles(0, secondaryValue, 0)
                inputValue.Velocity = Vector3.zero

                pcall(function()
                    inputValue.AssemblyLinearVelocity = Vector3.zero
                end)
            end

            trackLustConnection(RunService.Heartbeat:Connect(function()
                if not (autoBatEnabled and mirrorTPEnabled) then
                    if next(workingData) then
                        workingData = {}
                    end

                    return
                end

                local character = localPlayer.Character
                character = character and character:FindFirstChild("HumanoidRootPart")
                if not character then
                    return
                end

                for _, player in ipairs(Players:GetPlayers()) do
                    if player ~= localPlayer and player.Character then
                        local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
                        local humanoid = player.Character:FindFirstChildOfClass("Humanoid")

                        if humanoidRootPart and humanoid and humanoid.Health > 0 then
                            local amount = humanoidRootPart.Position.X - character.Position.X
                            local calculatedValue = humanoidRootPart.Position.Z - character.Position.Z

                            if amount * amount + calculatedValue * calculatedValue <= 64 then
                                local y = humanoidRootPart.Position.Y
                                local primaryValue = workingData[humanoidRootPart]

                                if primaryValue then
                                    local secondaryAmount = primaryValue.prevY - y
                                    primaryValue.prevY = y

                                    if 3 <= secondaryAmount then
                                        featureHelperR(character)
                                    end
                                else
                                    workingData[humanoidRootPart] = { prevY = y }
                                end
                            else
                                workingData[humanoidRootPart] = nil
                            end
                        end
                    end
                end
            end))
        end
    end

    do
        -- BAT AIMBOT: motor de apuntado, movimiento y golpe basado en Bat V3 del source.
        local autoBatSafetyConn = nil
        local autoBatV3Target = nil
        local autoBatV3IntendedVelocity = Vector3.zero
        local autoBatV3Attachment = nil
        local autoBatV3AngularVelocity = nil
        local AUTO_BAT_V3_ANG = "_RaptureBypassAngV"
        local AUTO_BAT_V3_ATT = "_RaptureBypassAtt"
        local AUTO_BAT_V3_SWING_RANGE = 12
        local AUTO_BAT_V3_CLEAN = {
            "LockBAV", "LockAngVel", "LockBodyAtt", "BatLock", "LockBAVAtt",
            "AutoBatAtt", "AutoBatAV", "AntiBatDet", "AntiAim", "VelocityLock",
        }

        local function cleanAutoBatV3Movers(root)
            if not root then return end
            for _, name in ipairs(AUTO_BAT_V3_CLEAN) do
                local mover = root:FindFirstChild(name)
                if mover then pcall(function() mover:Destroy() end) end
            end
        end

        local function removeAutoBatV3Angular()
            pcall(function()
                if autoBatV3AngularVelocity then autoBatV3AngularVelocity:Destroy() end
            end)
            pcall(function()
                if autoBatV3Attachment then autoBatV3Attachment:Destroy() end
            end)
            autoBatV3AngularVelocity = nil
            autoBatV3Attachment = nil
        end

        local function ensureAutoBatV3Angular(root)
            if not root then return end
            if autoBatV3AngularVelocity and autoBatV3AngularVelocity.Parent == root
                and autoBatV3Attachment and autoBatV3Attachment.Parent == root then
                return
            end
            removeAutoBatV3Angular()
            pcall(function()
                local oldAngular = root:FindFirstChild(AUTO_BAT_V3_ANG)
                if oldAngular then oldAngular:Destroy() end
                local oldAttachment = root:FindFirstChild(AUTO_BAT_V3_ATT)
                if oldAttachment then oldAttachment:Destroy() end
            end)
            local attachment = Instance.new("Attachment")
            attachment.Name = AUTO_BAT_V3_ATT
            attachment.Parent = root
            local angularVelocity = Instance.new("AngularVelocity")
            angularVelocity.Name = AUTO_BAT_V3_ANG
            angularVelocity.Attachment0 = attachment
            angularVelocity.RelativeTo = Enum.ActuatorRelativeTo.World
            angularVelocity.MaxTorque = math.huge
            angularVelocity.AngularVelocity = Vector3.zero
            angularVelocity.Parent = root
            autoBatV3Attachment = attachment
            autoBatV3AngularVelocity = angularVelocity
        end

        local function isAutoBatTool(tool)
            if not tool or not tool:IsA("Tool") then return false end
            local name = tostring(tool.Name or ""):lower()
            return name:find("bat", 1, true) ~= nil or name:find("slap", 1, true) ~= nil
        end

        _autoTPWasEnabled = false

        enableAutoBat = function()
            if isCountdownCounterBlocked and isCountdownCounterBlocked() then
                autoBatEnabled = false

                if autoBatSetVisual then
                    autoBatSetVisual(false)
                end

                return false
            end

            if isHoldingBrainrot and isHoldingBrainrot() then
                autoBatEnabled = false

                if autoBatSetVisual then
                    autoBatSetVisual(false)
                end

                return false
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

            if autoTPEnabled then
                _autoTPWasEnabled = true
                stopAutoTeleport()

                if setAutoTPVisual then
                    setAutoTPVisual(false)
                end
            else
                _autoTPWasEnabled = false
            end

            _autoBatHadTarget = false
            autoBatEnabled = true
            featureHelperP()
            startAutoBatLoop()
            return true
        end

        disableAutoBat = function()
            autoBatEnabled = false
            isAutoBatBusy = false

            if autoBatConn then
                autoBatConn:Disconnect()
                autoBatConn = nil
            end
            if autoBatSafetyConn then
                autoBatSafetyConn:Disconnect()
                autoBatSafetyConn = nil
            end
            autoBatV3Target = nil
            autoBatV3IntendedVelocity = Vector3.zero
            removeAutoBatV3Angular()

            _autoBatHadTarget = false
            local character = localPlayer.Character

            if character then
                local humanoid = character:FindFirstChildOfClass("Humanoid")
                local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")

                if humanoid then
                    humanoid.AutoRotate = true
                    humanoid.PlatformStand = false
                    humanoid.Sit = false

                    pcall(function()
                        humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
                    end)

                    task.defer(function()
                        if autoBatEnabled or not humanoid.Parent or humanoid.Health <= 0
                            or localPlayer.Character ~= character then
                            return
                        end
                        local isActive = humanoid.FloorMaterial == Enum.Material.Air

                        pcall(function()
                            humanoid:ChangeState(
                                isActive and Enum.HumanoidStateType.Freefall or Enum.HumanoidStateType.Running
                            )
                        end)
                    end)
                end

                if humanoidRootPart then
                    cleanAutoBatV3Movers(humanoidRootPart)
                    humanoidRootPart.Anchored = false
                    pcall(function()
                        humanoidRootPart.AssemblyAngularVelocity = Vector3.zero
                        local currentVelocity = humanoidRootPart.AssemblyLinearVelocity
                        humanoidRootPart.AssemblyLinearVelocity = Vector3.new(0, currentVelocity.Y, 0)
                    end)
                end
            end

            if _autoTPWasEnabled then
                _autoTPWasEnabled = false
                autoTPEnabled = true

                if setAutoTPVisual then
                    setAutoTPVisual(true)
                end

                startAutoTeleport()
            end
        end

        isHoldingBrainrot = function()
            local character = localPlayer.Character
            if not character then
                return false
            end
            local isActive = localPlayer:GetAttribute("Stealing") == true
                or localPlayer:GetAttribute("AntiKick") == true

            if not isActive then
                local primaryValue = true
                isActive = character:GetAttribute("Stealing") == primaryValue
            end

            if isActive then
                return true
            end

            for _, primaryValue in ipairs({ "Carrying", "IsCarrying", "Carried", "Holding", "Grabbed", "HasGrab" }) do
                local isReady = character:FindFirstChild(primaryValue, true)

                if isReady then
                    local value = isReady:IsA("BoolValue") and isReady.Value
                        or isReady:IsA("ObjectValue") and isReady.Value

                    if value then
                        isReady = value
                    else
                        isReady = isReady:IsA("StringValue") and isReady.Value ~= ""
                    end
                end

                if isReady then
                    return true
                end
            end

            for _, child in ipairs(character:GetChildren()) do
                local normalizedName = child.Name:lower()
                local pos = normalizedName:find("bat")
                    or normalizedName:find("slap")
                    or normalizedName:find("medusa")
                    or normalizedName:find("head")
                    or normalizedName:find("stone")
                if child:IsA("Tool") and not pos then
                    return true
                end

                if
                    child:IsA("Model")
                    and child:FindFirstChildWhichIsA("BasePart", true)
                    and (
                        normalizedName:find("brainrot")
                        or normalizedName:find("animal")
                        or normalizedName:find("carry")
                        or normalizedName:find("grab")
                        or normalizedName:find("steal")
                        or normalizedName:find("hold")
                    )
                then
                    return true
                end
            end

            return false
        end

        queueAutoLeftStart = function()
            autoLeftEnabled = true

            if autoRightEnabled then
                autoRightEnabled = false

                if autoRightSetVisual then
                    autoRightSetVisual(false)
                end

                stopAutoRight()
            end

            if autoBatEnabled then
                disableAutoBat()

                if autoBatSetVisual then
                    autoBatSetVisual(false)
                end
            end

            startAutoLeft()
        end

        queueAutoRightStart = function()
            autoRightEnabled = true

            if autoLeftEnabled then
                autoLeftEnabled = false

                if autoLeftSetVisual then
                    autoLeftSetVisual(false)
                end

                stopAutoLeft()
            end

            if autoBatEnabled then
                disableAutoBat()

                if autoBatSetVisual then
                    autoBatSetVisual(false)
                end
            end

            startAutoRight()
        end

        queueAutoBatStart = function()
            if isCountdownCounterBlocked and isCountdownCounterBlocked() then
                if autoBatEnabled then
                    disableAutoBat()
                end

                if autoBatSetVisual then
                    autoBatSetVisual(false)
                end

                return false
            end

            if isHoldingBrainrot() then
                if autoBatEnabled then
                    disableAutoBat()
                end

                if autoBatSetVisual then
                    autoBatSetVisual(false)
                end

                return false
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

            return enableAutoBat() == true
        end

        trackLustConnection(RunService.Heartbeat:Connect(function()
            if
                autoBatEnabled and (isCountdownCounterBlocked and isCountdownCounterBlocked() or isHoldingBrainrot())
            then
                disableAutoBat()

                if autoBatSetVisual then
                    autoBatSetVisual(false)
                end
            end
        end))

        startAutoBatLoop = function()
            if autoBatConn then return end
            autoBatV3Target = nil
            autoBatV3IntendedVelocity = Vector3.zero
            local initialCharacter = localPlayer.Character
            local initialRoot = initialCharacter and initialCharacter:FindFirstChild("HumanoidRootPart")
            if initialRoot then
                cleanAutoBatV3Movers(initialRoot)
                ensureAutoBatV3Angular(initialRoot)
            end

            autoBatConn = trackLustConnection(RunService.Heartbeat:Connect(function()
                if not autoBatEnabled then return end
                if isHoldingBrainrot() then
                    disableAutoBat()
                    if autoBatSetVisual then autoBatSetVisual(false) end
                    return
                end

                local character = localPlayer.Character
                local humanoid = character and character:FindFirstChildOfClass("Humanoid")
                local root = character and character:FindFirstChild("HumanoidRootPart")
                if not character or not humanoid or humanoid.Health <= 0 or not root then return end

                cleanAutoBatV3Movers(root)
                if not autoBatV3AngularVelocity or autoBatV3AngularVelocity.Parent ~= root
                    or not autoBatV3Attachment or autoBatV3Attachment.Parent ~= root then
                    ensureAutoBatV3Angular(root)
                end

                local equippedTool = character:FindFirstChildOfClass("Tool")
                if not isAutoBatTool(equippedTool) then
                    local bat = findAutoBatTool()
                    if bat then
                        pcall(function()
                            humanoid:UnequipTools()
                            humanoid:EquipTool(bat)
                        end)
                    end
                end

                local targetRoot = featureHelperQ()
                if not targetRoot or not targetRoot.Parent then
                    autoBatV3Target = nil
                    humanoid.AutoRotate = true
                    if autoBatV3AngularVelocity then
                        autoBatV3AngularVelocity.AngularVelocity = Vector3.zero
                    end
                    return
                end

                autoBatV3Target = targetRoot
                local distance = (targetRoot.Position - root.Position).Magnitude
                local aimPosition = targetRoot.Position
                    + targetRoot.CFrame.LookVector * (targetRoot.Velocity.Magnitude < 0.1 and 1.5 or 5)
                local delta = aimPosition - root.Position
                local flat = Vector3.new(delta.X, 0, delta.Z)
                humanoid.AutoRotate = false

                if delta.Magnitude > 0.01 and flat.Magnitude > 0.01 and autoBatV3AngularVelocity then
                    local currentYaw = root.Orientation.Y
                    local yawDelta = (math.deg(math.atan2(-flat.X, -flat.Z)) - currentYaw + 180) % 360 - 180
                    local currentPitch = root.Orientation.X
                    local pitchDelta = (math.deg(math.atan2(delta.Y, flat.Magnitude)) - currentPitch + 180) % 360 - 180
                    local rotY = math.clamp(math.rad(yawDelta) * 40, -28, 28)
                    local rotX = math.clamp(math.rad(pitchDelta) * 40, -28, 28)
                    local yaw = math.rad(root.Orientation.Y)
                    local forward = Vector3.new(math.cos(yaw), 0, -math.sin(yaw))
                    autoBatV3AngularVelocity.AngularVelocity = Vector3.new(0, rotY, 0) + forward * rotX
                elseif autoBatV3AngularVelocity then
                    autoBatV3AngularVelocity.AngularVelocity = Vector3.zero
                end

                local speed = tonumber(getAutoBatMovementSpeed()) or 58
                autoBatV3IntendedVelocity = (flat.Magnitude > 0.1 and flat.Unit * speed or Vector3.zero)
                    + (math.abs(delta.Y) > 0.8 and Vector3.new(0, math.sign(delta.Y) * speed, 0)
                        or Vector3.new(0, -2, 0))
                root.AssemblyLinearVelocity = autoBatV3IntendedVelocity
                root.Velocity = autoBatV3IntendedVelocity
                if flat.Magnitude > 0.3 then
                    pcall(function() humanoid:Move(flat.Unit, false) end)
                else
                    pcall(function() humanoid:Move(Vector3.zero, false) end)
                end

                if distance <= AUTO_BAT_V3_SWING_RANGE then
                    featureHelperM(character)
                end
            end))

            autoBatSafetyConn = trackLustConnection(RunService.RenderStepped:Connect(function()
                if not autoBatEnabled then return end
                local character = localPlayer.Character
                local root = character and character:FindFirstChild("HumanoidRootPart")
                local humanoid = character and character:FindFirstChildOfClass("Humanoid")
                if not root or not humanoid then return end

                if autoBatV3Target and autoBatV3Target.Parent then
                    local delta = autoBatV3Target.Position - root.Position
                    local flat = Vector3.new(delta.X, 0, delta.Z)
                    if flat.Magnitude > 0.3 then
                        pcall(function() humanoid:Move(flat.Unit, false) end)
                    end
                    if math.abs(root.AssemblyLinearVelocity.X - autoBatV3IntendedVelocity.X) > 30
                        or math.abs(root.AssemblyLinearVelocity.Z - autoBatV3IntendedVelocity.Z) > 30 then
                        root.AssemblyLinearVelocity = autoBatV3IntendedVelocity
                    end
                end
                local velocity = root.Velocity
                if math.abs(velocity.X) > 350 or math.abs(velocity.Z) > 350 then
                    root.Velocity = autoBatV3IntendedVelocity
                end
                cleanAutoBatV3Movers(root)
            end))
        end
    end
end

-- ============================================================
-- [Auto Carry - ported from Yout v15] On Pick Up + Soft Steal
-- ============================================================
do
    _G._VynxAutoSpeedRange = tonumber(_G._VynxAutoSpeedRange) or 12
    local state = { active = false, previous = nil, graceUntil = 0, conn = nil, charConn = nil }
    local soft  = { spots = {}, nextScan = 0, latched = false, held = false, armed = true }

    local function getFamily()
        if laggerToggled then return "lagger" end
        return "normal"
    end
    local function getCarry()
        return (speedMode == true) or (laggerToggled and laggerPhase == 2)
    end
    local function setFamilyCarry(family, carry)
        carry = carry == true
        if family == "lagger" then
            laggerToggled = true
            laggerPhase   = carry and 2 or 1
            speedMode     = false
        else
            laggerToggled = false
            laggerPhase   = 0
            speedMode     = carry
        end
    end
    local function refresh()
        if refreshSpeedModeLabel then pcall(refreshSpeedModeLabel) end
        if _G.__LustApplySpeedNow then pcall(_G.__LustApplySpeedNow) end
    end

    local function isWeaponName(value)
        local n = tostring(value or ""):lower()
        return n:find("bat") or n:find("slap") or n:find("medusa")
            or n:find("head") or n:find("stone")
    end

    local function isCarrying(character)
        if not character then return false end
        if localPlayer:GetAttribute("Stealing") == true
            or localPlayer:GetAttribute("AntiKick") == true
            or character:GetAttribute("Stealing") == true then
            return true
        end
        for _, entry in ipairs({ "Carrying","IsCarrying","Grabbed","Holding","StealHold","HasGrab" }) do
            local inst = character:FindFirstChild(entry, true)
            if inst and (
                (inst:IsA("BoolValue")    and inst.Value)
                or (inst:IsA("ObjectValue") and inst.Value)
                or (inst:IsA("StringValue") and inst.Value ~= "")
            ) then return true end
        end
        for _, child in ipairs(character:GetChildren()) do
            local n = child.Name:lower()
            local carryName = n:find("brainrot") or n:find("animal") or n:find("carry")
                or n:find("grab") or n:find("steal") or n:find("hold")
            if child:IsA("Tool") and not isWeaponName(n) then
                return true
            end
            local bp = child:IsA("Model") and child:FindFirstChildWhichIsA("BasePart", true)
            if bp and carryName then return true end
        end
        return false
    end

    local function enable()
        if state.active then
            state.graceUntil = tick() + 0.75
            return
        end
        state.previous   = { family = getFamily(), carry = getCarry() }
        state.active     = true
        state.graceUntil = tick() + 0.75
        setFamilyCarry(getFamily(), true)
        refresh()
    end

    local function restore()
        if not state.active then return end
        local previous = state.previous
        state.active   = false
        state.previous = nil
        if previous then setFamilyCarry(previous.family, previous.carry) end
        refresh()
    end

    local function softEnable()
        if not state.active then
            state.previous = { family = getFamily(), carry = getCarry() }
            state.active   = true
        end
        state.graceUntil = tick() + 0.75
        setFamilyCarry(getFamily(), true)
        refresh()
    end

    local function scanSpots()
        local spots = {}
        local plots = workspace:FindFirstChild("Plots")
        if not plots then soft.spots = spots; return end
        for _, child in ipairs(plots:GetChildren()) do
            local sign = child:FindFirstChild("PlotSign")
            sign = sign and sign:FindFirstChild("YourBase")
            if not (sign and sign:IsA("BillboardGui") and sign.Enabled == true) then
                local pods = child:FindFirstChild("AnimalPodiums")
                if pods then
                    for _, pod in ipairs(pods:GetChildren()) do
                        local base = pod:FindFirstChild("Base")
                        base = base and base:FindFirstChild("Spawn")
                        if base then spots[#spots + 1] = base.Position end
                    end
                end
            end
        end
        soft.spots = spots
    end

    local function nearStealSpot(character)
        local root = character and character:FindFirstChild("HumanoidRootPart")
        if not root then return false end
        local range = tonumber(_G._VynxAutoSpeedRange) or 15
        local target = _G._VantaStealTargetPos or _G._RaVeStealTargetPos
        if typeof(target) == "Vector3" and (root.Position - target).Magnitude <= range then
            return true
        end
        local now = tick()
        if soft.nextScan <= now then
            soft.nextScan = now + 0.5
            scanSpots()
        end
        for _, spot in ipairs(soft.spots) do
            if (root.Position - spot).Magnitude <= range then return true end
        end
        return false
    end

    local function startAutoCarry()
        if state.conn then state.conn:Disconnect() end
        state.conn = trackLustConnection(RunService.RenderStepped:Connect(function()
            if not autoCarryEnabled then
                restore(); return
            end
            local character = localPlayer.Character
            local humanoid  = character and character:FindFirstChildOfClass("Humanoid")
            if not character or not humanoid or humanoid.Health <= 0 then
                restore(); return
            end

            if autoCarryMode == "Soft Steal" then
                local near     = nearStealSpot(character)
                local carrying = isCarrying(character)
                local away     = not near

                if away then soft.armed = true end
                if away or getCarry() ~= true then soft.latched = false end

                if near and soft.armed and not soft.latched then
                    soft.latched = true
                    soft.held    = false
                    softEnable()
                end

                if state.active then
                    if carrying then
                        soft.held = true
                        state.graceUntil = tick() + 0.75
                    elseif soft.held then
                        soft.held    = false
                        soft.latched = false
                        soft.armed   = false
                        restore()
                    else
                        local away2 = not near
                        if away2 then away2 = tick() > state.graceUntil end
                        if away2 then
                            soft.latched = false
                            restore()
                        end
                    end
                end
                return
            end

            if isCarrying(character) then
                enable()
            elseif state.active then
                restore()
            end
        end))
    end

    local function stopAutoCarry()
        if state.conn then
            state.conn:Disconnect()
            state.conn = nil
        end
        if state.charConn then
            state.charConn:Disconnect()
            state.charConn = nil
        end
        soft.latched = false
        soft.held    = false
        soft.armed   = true
        restore()
    end

    if state.charConn then state.charConn:Disconnect() end
    state.charConn = trackLustConnection(localPlayer.CharacterAdded:Connect(function()
        soft.latched = false
        soft.held    = false
        soft.armed   = true
    end))

    _G.__LustAutoCarryRestore = restore
    _G.__LustAutoCarryIsCarrying = isCarrying
    _G.__LustAutoCarrySetEnabled = function(on)
        autoCarryEnabled = on == true
        if on then startAutoCarry() else stopAutoCarry() end
    end

end

do
    trackLustConnection(localPlayer.CharacterAdded:Connect(function(character)
        if autoLeftEnabled then
            autoLeftEnabled = false
            stopAutoLeft()
        end
        if autoRightEnabled then
            autoRightEnabled = false
            stopAutoRight()
        end
        task.wait(0.15)
        local timerActive = AR2 and AR2.TimerActive

        if not timerActive then
            clearRagdollCountdownTimer()
        end

        -- Auto Left/Right remain off after a character replacement to avoid a fatal route loop.

        if autoBatEnabled then
            _autoBatHadTarget = false

            if autoBatSetVisual then
                autoBatSetVisual(true)
            end
        end

        if autoCarryEnabled and _G.__LustAutoCarrySetEnabled then
            _G.__LustAutoCarrySetEnabled(true)
        end

        createLocalPlayerBillboard(character)

        if timerActive then
            updateAntiRagdollTimer(tick(), true)
        end

        if needsMedusaDetector and needsMedusaDetector() then
            setupMedusaCounter(character)
        end

        if batCounterEnabled or batCounterV3Enabled then
            startBatCounter()
        end
    end))

    if localPlayer.Character then
        createLocalPlayerBillboard(localPlayer.Character)
    end
end

-- ============================================================
-- [Lust Insta Reset - portado de Yout v15]
-- ============================================================
do
    local oldCleanup = rawget(_G, "__LustInstaResetCleanup")
    local oldState = rawget(_G, "__LustInstaResetState")
    if type(oldState) == "table" then
        oldState.token = (oldState.token or 0) + 1
        oldState.wantAntiDie = false
        for _, thread in pairs(oldState.threads or {}) do pcall(task.cancel, thread) end
    end
    if type(oldCleanup) == "function" then pcall(oldCleanup) end

    if type(oldState) == "table" then
        for _, conn in ipairs(oldState.connections or {}) do pcall(function() conn:Disconnect() end) end
        for _, conn in ipairs(oldState.uiConnections or {}) do pcall(function() conn:Disconnect() end) end
        if oldState.cameraConn then pcall(function() oldState.cameraConn:Disconnect() end) end
    end

    local state = {
        busy = false, busyAt = 0, token = 0,
        cameraConn = nil, cameraHeld = false, cameraHeldAt = 0,
        queued = false, queuedUntil = 0, suspendAt = nil,
        wantAntiDie = false, connections = {}, uiConnections = {}, threads = {},
    }
    _G.__LustInstaResetState = state
    _G.LustInstaResetInProgress = false

    local HOLD_TIME, FALLBACK_TIME, WAIT_RESPAWN = 1.5, 1.2, 8

    local function cancelThread(key)
        local thread = state.threads[key]
        state.threads[key] = nil
        if thread then pcall(task.cancel, thread) end
    end

    local function cancelAllThreads()
        local pending = {}
        for key, thread in pairs(state.threads) do
            pending[#pending + 1] = { key, thread }
            state.threads[key] = nil
        end
        for _, item in ipairs(pending) do pcall(task.cancel, item[2]) end
    end

    local function spawnTrackedThread(key, callback)
        cancelThread(key)
        local thread
        thread = task.defer(function()
            local ok, err = pcall(callback)
            if state.threads[key] == thread then state.threads[key] = nil end
            if not ok then warn("[Lust Insta Reset] " .. tostring(err)) end
        end)
        state.threads[key] = thread
        return thread
    end

    local function suspendGuards()
        state.suspendAt = os.clock()
        if LustAntiDie and LustAntiDie.enabled then
            state.wantAntiDie = true
            pcall(function() LustAntiDie.stop() end)
        end
    end

    local function restoreGuards()
        state.suspendAt = nil
        if state.wantAntiDie then
            state.wantAntiDie = false
            pcall(function()
                if LustAntiDie then LustAntiDie.start() end
            end)
        end
    end

    local function releaseCamera(newChar)
        if state.cameraConn then
            pcall(function() state.cameraConn:Disconnect() end)
            state.cameraConn = nil
        end
        local cam = workspace.CurrentCamera
        if cam then
            pcall(function()
                cam.CameraType = Enum.CameraType.Custom
                local hum = newChar and newChar:FindFirstChildOfClass("Humanoid")
                if hum then cam.CameraSubject = hum end
            end)
        end
        state.cameraHeld = false
    end

    local function holdCamera(oldChar, token)
        token = token or state.token
        local cam = workspace.CurrentCamera
        if not cam then return end
        if state.cameraHeld and os.clock() - (state.cameraHeldAt or 0) < 5 then return end
        state.cameraHeld = true
        state.cameraHeldAt = os.clock()
        local heldCFrame, heldFocus = cam.CFrame, cam.Focus
        pcall(function()
            cam.CameraType = Enum.CameraType.Scriptable
            cam.CFrame = heldCFrame
            cam.Focus = heldFocus
        end)
        state.cameraConn = trackLustConnection(RunService.RenderStepped:Connect(function()
            if token ~= state.token or workspace.CurrentCamera ~= cam then return end
            pcall(function()
                cam.CameraType = Enum.CameraType.Scriptable
                cam.CFrame = heldCFrame
                cam.Focus = heldFocus
            end)
        end))
        spawnTrackedThread("camera", function()
            local elapsed = 0
            while token == state.token and localPlayer.Character == oldChar and elapsed < 3 do
                elapsed = elapsed + task.wait()
            end
            if token ~= state.token then return end
            local newChar = localPlayer.Character
            if newChar == oldChar then newChar = nil end
            releaseCamera(newChar)
            if newChar then
                local hum = newChar:FindFirstChildOfClass("Humanoid") or newChar:WaitForChild("Humanoid", 3)
                local currentCam = workspace.CurrentCamera
                if currentCam then
                    pcall(function()
                        currentCam.CameraType = Enum.CameraType.Custom
                        if hum then currentCam.CameraSubject = hum end
                    end)
                end
            end
        end)
    end

    local function flingUp(character, token)
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
        local velocity = Vector3.new(0, 1000000, 0)
        local function pulse()
            if not root.Parent or localPlayer.Character ~= character or token ~= state.token then return false end
            return pcall(function()
                root.AssemblyAngularVelocity = Vector3.zero
                root.AssemblyLinearVelocity = velocity
            end)
        end
        if not pulse() then return false end
        spawnTrackedThread("fling", function()
            local elapsed = 0
            while elapsed < HOLD_TIME and token == state.token do
                elapsed = elapsed + RunService.Heartbeat:Wait()
                if not root.Parent or localPlayer.Character ~= character or token ~= state.token then return end
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
        local character = localPlayer.Character
        local hum = character and character:FindFirstChildOfClass("Humanoid")
        local root = character and character:FindFirstChild("HumanoidRootPart")
        if not (character and hum and root and root:IsA("BasePart")) then
            state.queued = true
            state.queuedUntil = os.clock() + 12
            return
        end
        if state.busy and os.clock() - (state.busyAt or 0) < 5 then return end

        cancelThread("reset")
        cancelThread("fling")
        cancelThread("camera")
        releaseCamera(character)
        state.busy = true
        state.busyAt = os.clock()
        state.token = state.token + 1
        local myToken = state.token
        _G.LustInstaResetInProgress = true
        pcall(function()
            local mover = _G.__LustResetSpeedMovement
            if type(mover) == "function" then mover() end
        end)
        suspendGuards()

        spawnTrackedThread("reset", function()
            local ok, err = pcall(function()
                holdCamera(character, myToken)
                if state.token ~= myToken then return end
                if not flingUp(character, myToken) then hardKill(character) end
                local elapsed = 0
                while state.token == myToken and localPlayer.Character == character and elapsed < FALLBACK_TIME do
                    elapsed = elapsed + task.wait()
                end
                if state.token ~= myToken then return end
                if localPlayer.Character == character then
                    local currentHum = character:FindFirstChildOfClass("Humanoid")
                    if currentHum and currentHum.Health > 0 then hardKill(character) end
                end
                local waited = 0
                while state.token == myToken and localPlayer.Character == character and waited < WAIT_RESPAWN do
                    waited = waited + task.wait()
                end
            end)
            if state.token ~= myToken then return end
            cancelThread("fling")
            cancelThread("camera")
            releaseCamera(localPlayer.Character)
            state.busy = false
            _G.LustInstaResetInProgress = false
            restoreGuards()
            local env = getgenv and getgenv() or _G
            local refresh = rawget(env, "__LustRefreshSpeedEngine") or rawget(_G, "__LustRefreshSpeedEngine")
            local engine = rawget(env, "__LustSpeedEngine") or rawget(_G, "__LustSpeedEngine")
            local engineReady = false
            pcall(function() engineReady = engine and engine.conn and engine.conn.Connected end)
            if not engineReady and type(refresh) == "function" then pcall(refresh) end
            if not ok then warn("[Lust Insta Reset] " .. tostring(err)) end
        end)
    end

    local lastRequest = 0
    _G.LustInstaReset = {
        Trigger = function()
            local now = os.clock()
            if now - lastRequest < 0.15 then return end
            lastRequest = now
            doReset()
        end,
    }
    _G.LustDoInstaReset = _G.LustInstaReset.Trigger

    table.insert(state.connections, trackLustConnection(RunService.Heartbeat:Connect(function()
        if not state.wantAntiDie then return end
        if state.busy and os.clock() - (state.busyAt or 0) < 10 then return end
        if os.clock() - (state.suspendAt or 0) < 12 then return end
        state.busy = false
        _G.LustInstaResetInProgress = false
        restoreGuards()
    end)))

    table.insert(state.connections, trackLustConnection(localPlayer.CharacterAdded:Connect(function(newChar)
        cancelThread("fling")
        if state.cameraHeld then
            cancelThread("camera")
            releaseCamera(newChar)
        end
        if not state.queued then return end
        if os.clock() > (state.queuedUntil or 0) then state.queued = false; return end
        state.queued = false
        local queuedToken = state.token
        spawnTrackedThread("queued", function()
            local hum = newChar:FindFirstChildOfClass("Humanoid") or newChar:WaitForChild("Humanoid", 5)
            local root = newChar:FindFirstChild("HumanoidRootPart") or newChar:WaitForChild("HumanoidRootPart", 5)
            task.wait(0.15)
            if state.token == queuedToken and hum and root and hum.Health > 0 and localPlayer.Character == newChar then doReset() end
        end)
    end)))

    _G.__LustInstaResetCleanup = function()
        local wasInProgress = state.busy or _G.LustInstaResetInProgress == true
        state.token = state.token + 1
        state.busy = false
        _G.LustInstaResetInProgress = false
        cancelAllThreads()
        for _, conn in ipairs(state.connections or {}) do pcall(function() conn:Disconnect() end) end
        state.connections = {}
        for _, conn in ipairs(state.uiConnections or {}) do pcall(function() conn:Disconnect() end) end
        state.uiConnections = {}
        releaseCamera(localPlayer.Character)
        state.wantAntiDie = false
        state.suspendAt = nil
        if wasInProgress then
            local char = localPlayer.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            local humanoid = char and char:FindFirstChildOfClass("Humanoid")
            if root then pcall(function() root.AssemblyLinearVelocity = Vector3.zero; root.AssemblyAngularVelocity = Vector3.zero end) end
            if humanoid and humanoid.Health > 0 then
                pcall(function() humanoid.PlatformStand = false; humanoid:ChangeState(Enum.HumanoidStateType.Running) end)
            end
        end
        for _, parent in ipairs({ game:GetService("CoreGui"), localPlayer:FindFirstChild("PlayerGui") }) do
            if parent then
                local old = parent:FindFirstChild("LustInstaResetButton")
                if old then pcall(function() old:Destroy() end) end
            end
        end
            end


end

do
    saveConfig = function()
        if not isConfigReady then
            return false
        end

        if not writefile then
            return false
        end

        local function featureHelperV(inputValue)
            return { kb = inputValue.kb and inputValue.kb.Name or nil, gp = inputValue.gp and inputValue.gp.Name or nil }
        end

        local workingData = {
            normalSpeed = NS,
            carrySpeed = CS,
            dropBrainrotKey = featureHelperV(KB.DropBrainrot),
            autoLeftKey = featureHelperV(KB.AutoLeft),
            autoRightKey = featureHelperV(KB.AutoRight),
            autoBatKey = featureHelperV(KB.AutoBat),
            laggerToggleKey = featureHelperV(KB.LaggerToggle),
            tpFloorKey = featureHelperV(KB.TPFloor),
            guiHideKey = featureHelperV(KB.GuiHide),
            speedToggleKey = featureHelperV(KB.SpeedToggle),
            instaResetKey = featureHelperV(KB.InstaReset),
            floatKey = featureHelperV(KB.Float),
            instaResetKeyConfigured = instaResetKeyConfigured,
            autoStealRadius = LustSteal.StealRadius,
            autoStealBarPosition = progressBarContainer and {
                progressBarContainer.Position.X.Scale,
                progressBarContainer.Position.X.Offset,
                progressBarContainer.Position.Y.Scale,
                progressBarContainer.Position.Y.Offset,
            } or nil,
            antiRagdoll = antiRagdollEnabled,
            unwalk = unwalkEnabled,
            autoStealEnabled = Steal.AutoStealEnabled,
            infiniteJump = infJumpEnabled,
            medusaCounter = medusaCounterEnabled,
            batCounter = batCounterEnabled or batCounterV3Enabled,
            batCounterVersion = batCounterVersion,
            carryMode = speedMode,
            laggerMode = laggerToggled,
            laggerCarryMode = laggerPhase == 2,
            laggerSpeed = LAGGER_SPEED,
            laggerCarrySpeed = LAGGER_CARRY_SPEED,
            autoBat = autoBatEnabled,
            skinBat = skinBatMode,
            animPack = currentAnimPack,
            medusaSkin = medusaSkinMode,
            autoBatSpeed = AUTO_BAT_SPEED,
            laggerAutoBatSpeed = LAGGER_AUTO_BAT_SPEED,
            autoSwing = autoSwingEnabled,
            mirrorTP = mirrorTPEnabled,
            espEnabled = espEnabled,
            espTracersEnabled = espTracersEnabled,
            ragdollCountdownEnabled = ragdollCountdownEnabled,
            antiLag = antiLagEnabled,
            fieldOfView = fieldOfView,
            fieldOfViewEnabled = fieldOfViewEnabled,
            stretchRez = stretchRezEnabled,
            autoTPEnabled = autoTPEnabled,
            autoTPHeight = autoTPHeight,
            showUIOnExecute = showUIOnExecute,
            showMobileButtons = showMobileButtons,
            qaLocked = qaLocked,
            floatingButtonsScale = floatingButtonsScale,
            autoCarryEnabled = autoCarryEnabled,
            autoCarryMode = autoCarryMode,
            antiRagdollMode = antiRagdollMode,
            dropBrainrotMode = dropBrainrotMode,
            showSpeedBypassPanel = showSpeedBypassPanel,
            colorTheme = currentKairnoxTheme,
        }

        local function featureHelperW()
            local animationProperties = {}

            for i, primaryValue in ipairs(qaFrames) do
                animationProperties[i] = { primaryValue.Position.X.Offset, primaryValue.Position.Y.Offset }
            end

            return animationProperties
        end

        workingData.qaPositions = featureHelperW()
        workingData.uiScale = uiScaleValue
        local saveOk, saveErr = pcall(function()
            local encodedConfig = HttpService:JSONEncode(workingData)
            writefile("KAIRNOX DUELS.json", encodedConfig)
        end)
        if not saveOk then
            warn("[KAIRNOX DUELS] No se pudo guardar KAIRNOX DUELS.json: " .. tostring(saveErr))
            return false
        end
        return true
    end

    setInstaGrab = nil
    setInfJumpVisual = nil
    setAntiRagVisual = nil
    setMedusaVisual = nil
    setAutoSwingVisual = nil
    setMirrorTPVisual = nil
    normalBox = nil
    carryBox = nil
    laggerBox = nil
    laggerCarryBox = nil
    radInput = nil
    autoBatSpeedBox = nil
    laggerAutoBatSpeedBox = nil
    autoTPHeightBox = nil
    fieldOfViewBox = nil
    scaleBox = nil
    floatingScaleBox = nil
    mainGuiScale = nil
    modeValLbl = nil

    refreshSpeedModeLabel = function()
        if modeValLbl then
            modeValLbl.Text = laggerToggled and (laggerPhase == 2 and "Lagger Carry" or "Lagger")
                or speedMode and "Carry"
                or "Normal"
        end
        -- Descarta la dirección y velocidad horizontal del modo anterior al cambiar de estado.
        if _G.__LustResetSpeedMovement then
            pcall(_G.__LustResetSpeedMovement)
        end
    end

    toggleCarryMode = function()
        if laggerToggled then
            laggerToggled = false
            laggerPhase = 0
            speedMode = true
        else
            speedMode = not speedMode
        end

        refreshSpeedModeLabel()
    end

    toggleLaggerMode = function()
        if not laggerToggled then
            speedMode = false
            laggerToggled = true
            laggerPhase = 2
        elseif laggerPhase == 2 then
            laggerPhase = 1
        else
            laggerPhase = 2
        end

        refreshSpeedModeLabel()
    end

    local function featureHelperV(inputValue)
        if laggerToggled and laggerPhase == inputValue then
            laggerToggled = false
            laggerPhase = 0
        else
            speedMode = false
            laggerToggled = true
            laggerPhase = inputValue
        end

        refreshSpeedModeLabel()
    end

    buildGui = function()
        local foregroundColor
        foregroundColor = Color3.fromRGB(5, 5, 7)
        local borderColor
        borderColor = Color3.fromRGB(20, 20, 26)
        local panelColor
        panelColor = Color3.fromRGB(50, 50, 50)
        local textColor
        textColor = Color3.fromRGB(255, 255, 255)
        removeExistingLustGui()
        local screenGui
        screenGui = Instance.new("ScreenGui")
        screenGui.Name = "KAIRNOX DUELS"
        local setBuildTab
        do
            local boundCleanup = LustCleanup
            trackLustConnection(screenGui.Destroying:Connect(function()
                if boundCleanup then
                    pcall(boundCleanup)
                end
            end))
        end
        screenGui.ResetOnSpawn = false
        screenGui.DisplayOrder = 10
        screenGui.IgnoreGuiInset = true

        if not pcall(function()
            screenGui.Parent = game:GetService("CoreGui")
        end) then
            screenGui.Parent = localPlayer:WaitForChild("PlayerGui")
        end

        local featureHelperW

        featureHelperW = function(inputValue, secondaryInput, tertiaryInput, lockWithMobileButtons)
            local primaryValue = secondaryInput or inputValue
            local isActive = nil
            local worldPosition = nil
            local absolutePosition = nil
            local secondaryPosition = nil

            local function featureHelperX(fourthInput, fifthInput)
                local viewportSize = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize
                    or Vector2.new(1920, 1080)
                local absoluteSize = primaryValue.AbsoluteSize

                if absoluteSize.X <= 0 then
                    absoluteSize = Vector2.new(primaryValue.Size.X.Offset, absoluteSize.Y)
                end

                if absoluteSize.Y <= 0 then
                    absoluteSize = Vector2.new(absoluteSize.X, primaryValue.Size.Y.Offset)
                end

                return math.clamp(fourthInput, 0, math.max(0, viewportSize.X - absoluteSize.X)),
                    math.clamp(fifthInput, 0, math.max(0, viewportSize.Y - absoluteSize.Y))
            end

            local function featureHelperY(fourthInput, fifthInput)
                local secondaryValue, currentObject = featureHelperX(fourthInput, fifthInput)
                local absoluteSize = primaryValue.AbsoluteSize

                if absoluteSize.X <= 0 then
                    absoluteSize = Vector2.new(primaryValue.Size.X.Offset, absoluteSize.Y)
                end

                if absoluteSize.Y <= 0 then
                    absoluteSize = Vector2.new(absoluteSize.X, primaryValue.Size.Y.Offset)
                end

                local anchorPoint = primaryValue.AnchorPoint or Vector2.zero
                primaryValue.Position = UDim2.fromOffset(
                    secondaryValue + absoluteSize.X * anchorPoint.X,
                    currentObject + absoluteSize.Y * anchorPoint.Y
                )
            end

            local inputBeganConn = trackLustConnection(inputValue.InputBegan:Connect(function(input)
                if lockWithMobileButtons and qaLocked then
                    isActive = false
                    return
                end
                if
                    input.UserInputType == Enum.UserInputType.MouseButton1
                    or input.UserInputType == Enum.UserInputType.Touch
                then
                    isActive = true
                    worldPosition = input.Position
                    absolutePosition = primaryValue.AbsolutePosition
                    secondaryPosition = primaryValue.Position
                end
            end))

            local inputEndedConn = trackLustConnection(UserInputService.InputEnded:Connect(function(input)
                if
                    input.UserInputType == Enum.UserInputType.MouseButton1
                    or input.UserInputType == Enum.UserInputType.Touch
                then
                    isActive = false
                end
            end))

            local inputChangedConn = trackLustConnection(UserInputService.InputChanged:Connect(function(input)
                if lockWithMobileButtons and qaLocked then
                    isActive = false
                    return
                end
                if not isActive then
                    return
                end

                if
                    input.UserInputType == Enum.UserInputType.MouseMovement
                    or input.UserInputType == Enum.UserInputType.Touch
                then
                    local amount = input.Position - worldPosition

                    if tertiaryInput then
                        featureHelperY(absolutePosition.X + amount.X, absolutePosition.Y + amount.Y)
                    else
                        primaryValue.Position = UDim2.new(
                            secondaryPosition.X.Scale,
                            secondaryPosition.X.Offset + amount.X,
                            secondaryPosition.Y.Scale,
                            secondaryPosition.Y.Offset + amount.Y
                        )
                    end
                end
            end))

            trackLustConnection(inputValue.Destroying:Connect(function()
                isActive = false
                pcall(function() inputBeganConn:Disconnect() end)
                pcall(function() inputEndedConn:Disconnect() end)
                pcall(function() inputChangedConn:Disconnect() end)
            end))

            if tertiaryInput then
                task.defer(function()
                    featureHelperY(primaryValue.AbsolutePosition.X, primaryValue.AbsolutePosition.Y)
                end)
            end
        end

        local primaryControl
        primaryControl = Instance.new("Frame", screenGui)
        primaryControl.Size = UDim2.new(0, 330, 0, 480)
        primaryControl.AnchorPoint = Vector2.new(0, 0)
        primaryControl.Position = UDim2.new(0, 20, 0, 2)
        primaryControl.BackgroundColor3 = currentKairnoxPalette.window
        primaryControl:SetAttribute("KairnoxThemeRole", "Window")
        primaryControl.BackgroundTransparency = 0
        primaryControl.BorderSizePixel = 0
        primaryControl.ClipsDescendants = true
        Instance.new("UICorner", primaryControl).CornerRadius = UDim.new(0, 16)
        local guiBackground = Instance.new("ImageLabel", primaryControl)
        guiBackground.Name = "KAIRNOX DUELSBackground"
        guiBackground.Size = UDim2.fromScale(1, 1)
        guiBackground.Position = UDim2.fromScale(0, 0)
        guiBackground.BackgroundTransparency = 1
        guiBackground.Image = ""
        guiBackground.ImageTransparency = 1
        guiBackground.ScaleType = Enum.ScaleType.Crop
        guiBackground.ImageTransparency = 1
        guiBackground.ZIndex = 2
        guiBackground.Active = false
        Instance.new("UICorner", guiBackground).CornerRadius = UDim.new(0, 16)
        mainGuiScale = Instance.new("UIScale", primaryControl)
        mainGuiScale.Scale = uiScaleValue / 100
        primaryControl.Visible = false
        local floatingButton

        do
            local rowContainer = Instance.new("Frame", primaryControl)
            rowContainer.Size = UDim2.new(1, 0, 0, 40)
            rowContainer.Position = UDim2.new(0, 0, 0, 0)
            rowContainer.BackgroundTransparency = 1
            rowContainer.BorderSizePixel = 0
            rowContainer.ZIndex = 5
            featureHelperW(rowContainer, primaryControl)
            local label = Instance.new("TextLabel", rowContainer)
            label.Size = UDim2.new(1, -92, 0, 24)
            label.Position = UDim2.new(0, 18, 0, 8)
            label.BackgroundTransparency = 1
            label.Text = "KAIRNOX DUELS"
            label:SetAttribute("KairnoxThemeRole", "AccentText")
            label.TextColor3 = primaryColor
            label.Font = Enum.Font.GothamBlack
            label.TextSize = 18
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.TextStrokeTransparency = 1
            label.ZIndex = 6
            floatingButton = Instance.new("TextButton", rowContainer)
        end

        floatingButton.Size = UDim2.new(0, 28, 0, 28)
        floatingButton.Position = UDim2.new(1, -42, 0, 6)
        floatingButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        floatingButton.BackgroundTransparency = 1
        floatingButton.BorderSizePixel = 0
        floatingButton.Text = ""
        floatingButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        floatingButton.Font = Enum.Font.Gotham
        floatingButton.TextSize = 18
        floatingButton.AutoButtonColor = false
        floatingButton.ZIndex = 10
        local gradientControl = Instance.new("Frame", floatingButton)
        gradientControl.AnchorPoint = Vector2.new(0.5, 0.5)
        gradientControl.Size = UDim2.new(0, 12, 0, 2)
        gradientControl.Position = UDim2.new(0.5, 0, 0.5, 0)
        gradientControl.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        gradientControl.BackgroundTransparency = 0.04
        gradientControl.BorderSizePixel = 0
        gradientControl.ZIndex = 11
        Instance.new("UICorner", gradientControl).CornerRadius = UDim.new(1, 0)

        trackLustConnection(floatingButton.MouseEnter:Connect(function()
            TweenService:Create(gradientControl, TweenInfo.new(0.12), { BackgroundTransparency = 0.3 }):Play()
        end))

        trackLustConnection(floatingButton.MouseLeave:Connect(function()
            TweenService:Create(gradientControl, TweenInfo.new(0.12), { BackgroundTransparency = 0.04 }):Play()
        end))

        local headerButton
        headerButton = Instance.new("TextButton", screenGui)
        headerButton.Size = UDim2.fromOffset(54, 54)
        headerButton.AnchorPoint = Vector2.new(0, 0)
        headerButton.Position = UDim2.new(0, 15, 0, 60)
        headerButton.BackgroundColor3 = Color3.fromRGB(14, 14, 20)
        headerButton.BackgroundTransparency = 1
        headerButton.BorderSizePixel = 0
        headerButton.AutoButtonColor = false
        headerButton.ZIndex = 30
        headerButton.ClipsDescendants = true
        headerButton.Text = ""
        headerButton.Visible = false
        Instance.new("UICorner", headerButton).CornerRadius = UDim.new(1, 0)
        local strokeControl
        strokeControl = Instance.new("UIScale", headerButton)
        strokeControl.Scale = 1
        local imageLabel, overlayControl, primaryValue, featureHelperX, featureHelperY, featureHelperZ, createFrame

        do
            local uiGradient = Instance.new("UIGradient", headerButton)
            local colorSequence = ColorSequence.new
            local workingData = {}
            local secondaryValue = ColorSequenceKeypoint.new(0, Color3.fromRGB(18, 18, 22))
            local currentObject = ColorSequenceKeypoint.new(0.48, Color3.fromRGB(10, 10, 14))
            local new = ColorSequenceKeypoint.new
            local currentItem = 1
            local gradientColor = Color3.fromRGB
            workingData[1] = secondaryValue
            workingData[2] = currentObject

            do
                local values = table.pack(new(currentItem, gradientColor(28, 28, 34)))
                table.move(values, 1, values.n, 3, workingData)
            end

            uiGradient.Color = colorSequence(workingData)
            uiGradient.Rotation = 14
            uiGradient.Enabled = false

            local minLogo = Instance.new("Frame", headerButton)
            minLogo.Name = "MinLogo"
            minLogo.AnchorPoint = Vector2.new(0.5, 0.5)
            minLogo.Position = UDim2.fromScale(0.5, 0.5)
            minLogo.Size = UDim2.fromOffset(36, 36)
            minLogo.BackgroundColor3 = primaryColor
            minLogo.BorderSizePixel = 0
            minLogo.ZIndex = 33
            Instance.new("UICorner", minLogo).CornerRadius = UDim.new(1, 0)
            local minLogoGrad = Instance.new("UIGradient", minLogo)
            minLogoGrad.Rotation = 35
            minLogoGrad.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(150, 150, 165)),
            })

            imageLabel = Instance.new("TextLabel", minLogo)
            imageLabel.Name = "HeaderTitle"
            imageLabel.Size = UDim2.fromScale(1, 1)
            imageLabel.BackgroundTransparency = 1
            imageLabel.Text = "K"
            imageLabel.TextColor3 = Color3.fromRGB(16, 16, 22)
            imageLabel.Font = Enum.Font.GothamBlack
            imageLabel.TextSize = 21
            imageLabel.TextXAlignment = Enum.TextXAlignment.Center
            imageLabel.TextYAlignment = Enum.TextYAlignment.Center
            imageLabel.TextStrokeTransparency = 1
            imageLabel.TextTransparency = 0
            imageLabel.ZIndex = 34

            overlayControl = Instance.new("UIStroke", headerButton)
            overlayControl.Color = Color3.fromRGB(255, 255, 255)
            overlayControl.Thickness = 2.5
            overlayControl.Transparency = 0
            overlayControl.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            local minGlow = Instance.new("UIGradient", overlayControl)
            minGlow.Name = "MinGlow"
            minGlow.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0.00, Color3.fromRGB(55, 55, 55)),
                ColorSequenceKeypoint.new(0.42, Color3.fromRGB(190, 190, 190)),
                ColorSequenceKeypoint.new(0.50, Color3.fromRGB(255, 255, 255)),
                ColorSequenceKeypoint.new(0.58, Color3.fromRGB(190, 190, 190)),
                ColorSequenceKeypoint.new(1.00, Color3.fromRGB(55, 55, 55)),
            })
            TweenService:Create(
                minGlow,
                TweenInfo.new(5, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, -1),
                { Rotation = 360 }
            ):Play()
            featureHelperW(headerButton, nil, nil, true)
            primaryValue = showUIOnExecute
            local amount = 0
            local targetObject = nil
            local secondaryDirection = Vector2.zero
            local activeConnection = nil

            local function featureHelperAA(inputValue)
                if inputValue ~= amount or not primaryValue or not targetObject then
                    return
                end
                local calculatedValue =
                    math.max(0, targetObject.AbsoluteCanvasSize.Y - targetObject.AbsoluteWindowSize.Y)
                targetObject.CanvasPosition =
                    Vector2.new(secondaryDirection.X, math.clamp(secondaryDirection.Y, 0, calculatedValue))
            end

            featureHelperX = function(inputValue)
                amount += 1
                local uiElement = amount

                if activeConnection then
                    activeConnection:Disconnect()
                    activeConnection = nil
                end

                if not inputValue and targetObject then
                    secondaryDirection = targetObject.CanvasPosition
                end

                primaryValue = inputValue

                if inputValue then
                    headerButton.Visible = false
                    headerButton.BackgroundTransparency = 1
                    strokeControl.Scale = 1
                    imageLabel.TextTransparency = 0
                    overlayControl.Transparency = 1
                    overlayControl.Thickness = 0
                    primaryControl.AnchorPoint = Vector2.new(0, 0)
                    primaryControl.BackgroundTransparency = 0
                    mainGuiScale.Scale = uiScaleValue / 100 * 0.82
                    featureHelperAA(uiElement)
                    primaryControl.Visible = true

                    activeConnection = trackLustConnection(RunService.RenderStepped:Connect(function()
                        featureHelperAA(uiElement)
                    end))

                    local animationProperties = { Scale = uiScaleValue / 100 }
                    local tween = TweenService:Create(
                        mainGuiScale,
                        TweenInfo.new(0.26, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
                        animationProperties
                    )
                    tween:Play()

                    trackLustConnection(tween.Completed:Connect(function()
                        if uiElement ~= amount then
                            return
                        end
                        featureHelperAA(uiElement)

                        if activeConnection then
                            activeConnection:Disconnect()
                            activeConnection = nil
                        end
                    end))
                else
                    headerButton.Visible = true
                    headerButton.BackgroundTransparency = 1
                    imageLabel.TextTransparency = 1
                    strokeControl.Scale = 0.86
                    TweenService:Create(
                        headerButton,
                        TweenInfo.new(0.18, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
                        { BackgroundTransparency = 0 }
                    ):Play()
                    local animationProperties = { TextTransparency = 0 }
                    TweenService:Create(
                        imageLabel,
                        TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                        animationProperties
                    ):Play()
                    TweenService:Create(
                        strokeControl,
                        TweenInfo.new(0.24, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
                        { Scale = 1 }
                    ):Play()
                    TweenService:Create(
                        overlayControl,
                        TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                        { Transparency = 0, Thickness = 2.5 }
                    ):Play()
                    local scaleProperties = { Scale = uiScaleValue / 100 * 0.82 }
                    local tween = TweenService:Create(
                        mainGuiScale,
                        TweenInfo.new(0.16, Enum.EasingStyle.Quart, Enum.EasingDirection.In),
                        scaleProperties
                    )
                    tween:Play()

                    trackLustConnection(tween.Completed:Connect(function()
                        if uiElement == amount and not primaryValue then
                            primaryControl.Visible = false
                            mainGuiScale.Scale = uiScaleValue / 100
                        end
                    end))
                end

                TweenService:Create(uiGradient, TweenInfo.new(0.22), { Rotation = inputValue and 18 or -18 }):Play()
            end

            trackLustConnection(floatingButton.Activated:Connect(function()
                featureHelperX(false)
            end))

            local function featureHelperAB()
                strokeControl.Scale = 0.9
                TweenService:Create(
                    strokeControl,
                    TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
                    { Scale = 1 }
                ):Play()
            end

            trackLustConnection(headerButton.Activated:Connect(function()
                featureHelperX(not primaryValue)
                featureHelperAB()
            end))

            featureHelperY = function()
                amount += 1
                primaryControl.Visible = true
                headerButton.Visible = false
                headerButton.BackgroundTransparency = 1
                overlayControl.Transparency = 1
                overlayControl.Thickness = 0
                primaryControl.AnchorPoint = Vector2.new(0, 0)
                primaryControl.BackgroundTransparency = 0
                mainGuiScale.Scale = uiScaleValue / 100 * 0.82

                for _, uiElement in ipairs(qaFrames) do
                    local stateToken = uiElement:FindFirstChildOfClass("UIScale")

                    if stateToken then
                        stateToken.Scale = floatingButtonsScale / 100
                    end
                end

                local animationProperties = { Scale = uiScaleValue / 100 }
                TweenService:Create(
                    mainGuiScale,
                    TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
                    animationProperties
                ):Play()
            end

            local tabNames = { "Speed", "Steal", "Combat", "Visuals", "Extras", "Keybind" }
            local tabPages = {}
            local tabButtons = {}
            local activeBuildTab = "Speed"
            local activeContentFrame

            local function createTabPage(tabName)
                local page = Instance.new("ScrollingFrame", primaryControl)
                page.Name = "KAIRNOX DUELSContent" .. tabName
                page.Size = UDim2.new(1, -96, 1, -48)
                page.Position = UDim2.new(0, 92, 0, 44)
                page.BackgroundTransparency = 1
                page.BorderSizePixel = 0
                page.ClipsDescendants = true
                page.ScrollBarThickness = 2
                page.ScrollBarImageTransparency = 0.55
                page.CanvasSize = UDim2.new(0, 0, 0, 0)
                page.AutomaticCanvasSize = Enum.AutomaticSize.Y
                page.ZIndex = 5
                page.Visible = tabName == "Speed"

                local listLayout = Instance.new("UIListLayout", page)
                listLayout.SortOrder = Enum.SortOrder.LayoutOrder
                listLayout.Padding = UDim.new(0, 6)
                listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

                local padding = Instance.new("UIPadding", page)
                padding.PaddingLeft = UDim.new(0, 8)
                padding.PaddingRight = UDim.new(0, 8)
                padding.PaddingTop = UDim.new(0, 6)
                padding.PaddingBottom = UDim.new(0, 20)

                tabPages[tabName] = page
                return page
            end

            for _, tabName in ipairs(tabNames) do
                createTabPage(tabName)
            end
            activeContentFrame = tabPages[activeBuildTab]
            targetObject = activeContentFrame

            setBuildTab = function(tabName)
                if tabPages[tabName] then
                    activeBuildTab = tabName
                    activeContentFrame = tabPages[tabName]
                end
            end

            local function selectTab(tabName)
                for _, name in ipairs(tabNames) do
                    local page = tabPages[name]
                    local button = tabButtons[name]
                    page.Visible = name == tabName
                    if button then
                        local selected = name == tabName
                        button:SetAttribute("KairnoxThemeRole", "ActiveButton")
                        button:SetAttribute("KairnoxThemeActive", selected)
                        button.BackgroundColor3 = selected and primaryColor or Color3.fromRGB(8, 8, 12)
                        button.TextColor3 = selected and Color3.fromRGB(0, 0, 0) or Color3.fromRGB(175, 175, 185)
                        local outline = button:FindFirstChildOfClass("UIStroke")
                        if outline then
                            outline.Color = selected and primaryColor or Color3.fromRGB(50, 50, 58)
                            outline.Transparency = selected and 0.08 or 0.35
                        end
                    end
                end
            end

            for index, tabName in ipairs(tabNames) do
                local button = Instance.new("TextButton", primaryControl)
                button.Name = "KAIRNOX DUELSTab" .. tabName
                button:SetAttribute("KairnoxThemeRole", "ActiveButton")
                button:SetAttribute("KairnoxThemeActive", tabName == activeBuildTab)
                button.Size = UDim2.new(0, 78, 0, 42)
                button.Position = UDim2.new(0, 7, 0, 50 + (index - 1) * 48)
                button.BackgroundColor3 = Color3.fromRGB(8, 8, 12)
                button.BackgroundTransparency = 0.08
                button.BorderSizePixel = 0
                button.AutoButtonColor = false
                button.Text = tabName:upper()
                button.TextColor3 = Color3.fromRGB(175, 175, 185)
                button.Font = Enum.Font.GothamBlack
                button.TextSize = 9
                button.TextWrapped = true
                button.ZIndex = 20
                Instance.new("UICorner", button).CornerRadius = UDim.new(0, 9)
                local outline = Instance.new("UIStroke", button)
                outline.Color = Color3.fromRGB(50, 50, 58)
                outline.Thickness = 1.5
                outline.Transparency = 0.35
                tabButtons[tabName] = button
                trackLustConnection(button.Activated:Connect(function()
                    selectTab(tabName)
                end))
            end
            selectTab("Speed")

            local calculatedValue = 0
            local activeSectionOrder = 0
            local sectionMeta = {
                ["Normal Mode"] = { 10, "NORMAL MODE" },
                ["Lagger Mode"] = { 20, "LAGGER MODE" },
                ["Speed Mode"] = { 30, "SPEED MODE" },
                ["Automation"] = { 40, "AUTOMATION" },
                ["Auto Movement"] = { 50, "AUTO MOVEMENT" },
                ["Combat"] = { 60, "COMBAT" },
                ["Drop"] = { 70, "DROP" },
                ["Teleport"] = { 80, "TELEPORT" },
                ["Movement"] = { 85, "MOVEMENT" },
                ["Defense"] = { 90, "DEFENSE" },
                ["Counters"] = { 100, "COUNTERS" },
                ["Performance"] = { 110, "PERFORMANCE" },
                ["UI Settings"] = { 120, "UI SETTINGS" },
                ["Mobile UI Settings"] = { 130, "MOBILE UI SETTINGS" },
            }

            local sectionTabs = {
                ["Normal Mode"] = "Speed",
                ["Lagger Mode"] = "Speed",
                ["Speed Mode"] = "Speed",
                ["Automation"] = "Speed",
                ["Auto Movement"] = "Speed",
                ["Combat"] = "Combat",
                ["Drop"] = "Steal",
                ["Teleport"] = "Steal",
                ["Defense"] = "Combat",
                ["Counters"] = "Combat",
                ["Performance"] = "Visuals",
                ["UI Settings"] = "Combat",
                ["Mobile UI Settings"] = "Visuals",
            }

            local function featureHelperAC()
                calculatedValue += 1
                return activeSectionOrder * 10000 + calculatedValue
            end

            _G_LUST_ROW_ORDER = featureHelperAC

            featureHelperZ = function(inputValue, explicitTab)
                local section = sectionMeta[inputValue]
                activeSectionOrder = section and section[1] or (activeSectionOrder + 1)
                setBuildTab(explicitTab or sectionTabs[inputValue] or activeBuildTab)
                local rowContainer = Instance.new("Frame", activeContentFrame)
                rowContainer.Size = UDim2.new(1, 0, 0, 18)
                rowContainer.BackgroundTransparency = 1
                rowContainer.LayoutOrder = featureHelperAC()
                local label = Instance.new("TextLabel", rowContainer)
                label.Size = UDim2.new(1, -8, 1, 0)
                label.Position = UDim2.new(0, 12, 0, 2)
                label.BackgroundTransparency = 1
                local section = sectionMeta[inputValue]
                label.Text = (section and section[2] or inputValue):upper()
                label.TextColor3 = primaryColor
                label.Font = Enum.Font.GothamBlack
                label.TextSize = 10
                label.TextXAlignment = Enum.TextXAlignment.Left
            end

            createFrame = function(inputValue)
                local rowContainer = Instance.new("Frame", activeContentFrame)
                rowContainer.Size = UDim2.new(1, 0, 0, math.max(inputValue or 32, 32))
                rowContainer.BackgroundColor3 = borderColor
                rowContainer.BackgroundTransparency = 0.34
                rowContainer.BorderSizePixel = 0
                rowContainer.LayoutOrder = featureHelperAC()
                rowContainer.ClipsDescendants = true
                rowContainer.ZIndex = 4
                Instance.new("UICorner", rowContainer).CornerRadius = UDim.new(0, 8)
                local detailControl = Instance.new("UIStroke", rowContainer)
                detailControl.Color = panelColor
                detailControl.Thickness = 1
                detailControl.Transparency = 0.52
                local secondaryControl = Instance.new("UIGradient", rowContainer)

                secondaryControl.Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(18, 18, 22)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 10, 10)),
                })

                secondaryControl.Rotation = 0
                return rowContainer
            end
        end

        local featureHelperAA

        featureHelperAA = function(inputValue)
            inputValue.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
            inputValue.BackgroundTransparency = 0
            inputValue.BorderSizePixel = 0
            local uiStroke2 = inputValue:FindFirstChildOfClass("UIStroke") or Instance.new("UIStroke", inputValue)
            uiStroke2.Color = Color3.fromRGB(34, 34, 40)
            uiStroke2.Thickness = 1
            uiStroke2.Transparency = 0.08
            uiStroke2.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            return uiStroke2
        end

        local createTextLabel

        createTextLabel = function(inputValue, labelText)
            local label = Instance.new("TextLabel", inputValue)
            label.Size = UDim2.new(0.46, 0, 1, 0)
            label.Position = UDim2.new(0, 14, 0, 0)
            label.BackgroundTransparency = 1
            label.Text = tostring(labelText)
            label.TextColor3 = textColor
            label.Font = Enum.Font.GothamBold
            label.TextSize = 11
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.ZIndex = 5
            return label
        end

        local featureHelperAB

        featureHelperAB = function(inputValue, secondaryInput)
            local rowContainer = Instance.new("Frame", inputValue)
            rowContainer.Size = UDim2.new(0, 32, 1, -4)
            rowContainer.Position = UDim2.new(1, -46, 0, 2)
            rowContainer.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
            rowContainer.BackgroundTransparency = 1
            rowContainer.BorderSizePixel = 0
            rowContainer.ZIndex = 3
            rowContainer.ClipsDescendants = false
            Instance.new("UICorner", rowContainer).CornerRadius = UDim.new(1, 0)
            local detailControl = Instance.new("UIGradient", rowContainer)
            local colorSequence = ColorSequence.new
            local workingData = {}
            local secondaryValue = ColorSequenceKeypoint.new(0, Color3.fromRGB(44, 44, 54))
            local currentObject = ColorSequenceKeypoint.new(0.55, Color3.fromRGB(24, 24, 28))
            local new = ColorSequenceKeypoint.new
            local gradientColor = Color3.fromRGB
            local currentItem = 16
            workingData[1] = secondaryValue
            workingData[2] = currentObject

            do
                local values = table.pack(new(1, gradientColor(12, 12, 14)))
                table.move(values, 1, values.n, 3, workingData)
            end

            detailControl.Color = colorSequence(workingData)
            detailControl.Rotation = 90
            local uiStroke2 = Instance.new("UIStroke", rowContainer)
            uiStroke2.Color = primaryColor
            uiStroke2.Thickness = 0
            uiStroke2.Transparency = 1
            local innerContainer = Instance.new("Frame", rowContainer)
            innerContainer.AnchorPoint = Vector2.new(0.5, 0.5)
            innerContainer.Position = UDim2.new(0.5, 0, 0.5, 1)
            innerContainer.Size = UDim2.new(0, 13, 0, 13)
            innerContainer.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
            innerContainer.BackgroundTransparency = 0.55
            innerContainer.BorderSizePixel = 0
            innerContainer.ZIndex = 3
            Instance.new("UICorner", innerContainer).CornerRadius = UDim.new(1, 0)
            local controlContainer = Instance.new("Frame", rowContainer)
            controlContainer.AnchorPoint = Vector2.new(0.5, 0.5)
            controlContainer.Position = UDim2.new(0.5, 0, 0.5, 0)
            controlContainer:SetAttribute("LustLightPurple", true)
            controlContainer.Size = UDim2.new(0, 12, 0, 12)
            controlContainer.BackgroundColor3 = Color3.fromRGB(92, 92, 104)
            controlContainer.BorderSizePixel = 0
            controlContainer.ZIndex = 4
            controlContainer.ClipsDescendants = true
            controlContainer.Visible = true
            Instance.new("UICorner", controlContainer).CornerRadius = UDim.new(1, 0)
            local uiGradient = Instance.new("UIGradient", controlContainer)
            uiGradient.Name = "LustDotGradient"
            uiGradient:SetAttribute("KairnoxThemeRole", "ThemeGradient")
            local colorSequence2 = ColorSequence.new
            local animationProperties = {}
            local targetObject = ColorSequenceKeypoint.new(0, Color3.fromRGB(235, 235, 240))
            local uiElement = ColorSequenceKeypoint.new(0.5, Color3.fromRGB(128, 128, 136))
            local new2 = ColorSequenceKeypoint.new
            local finalColor = Color3.fromRGB
            local stateToken = 48
            animationProperties[1] = targetObject
            animationProperties[2] = uiElement

            do
                local values = table.pack(new2(1, finalColor(stateToken, 48, 58)))
                table.move(values, 1, values.n, 3, animationProperties)
            end

            uiGradient.Color = colorSequence2(animationProperties)
            uiGradient.Rotation = 90
            local glossOverlay = addPurpleGloss(controlContainer, 5)
            glossOverlay.Size = UDim2.new(0.46, 0, 0.24, 0)
            glossOverlay.Position = UDim2.new(0.22, 0, 0.11, 0)
            glossOverlay.BackgroundTransparency = 0.62
            glossOverlay.Visible = true
            Instance.new("UIScale", controlContainer).Scale = 1
            return rowContainer, controlContainer, uiStroke2
        end

        local featureHelperAC

        featureHelperAC = function(inputValue, secondaryInput, tertiaryInput)
            inputValue.Visible = true
            inputValue:SetAttribute("KairnoxThemeRole", "Switch")
            inputValue:SetAttribute("KairnoxThemeActive", tertiaryInput == true)
            if secondaryInput and secondaryInput:IsA("UIStroke") then
                secondaryInput:SetAttribute("KairnoxThemeRole", "SwitchStroke")
                secondaryInput:SetAttribute("KairnoxThemeActive", tertiaryInput == true)
            end
            inputValue.BackgroundColor3 = tertiaryInput and primaryColor or Color3.fromRGB(92, 92, 104)
            local lustDotGradient = inputValue:FindFirstChild("LustDotGradient")

            if lustDotGradient then
                local secondaryValue

                if tertiaryInput then
                    local colorSequence = ColorSequence.new
                    local workingData = {}
                    local currentObject = ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 240, 255))
                    local currentItem = ColorSequenceKeypoint.new(0.46, primaryColor)
                    workingData[1] = currentObject
                    workingData[2] = currentItem

                    do
                        local values = table.pack(ColorSequenceKeypoint.new(1, primaryColor:Lerp(Color3.fromRGB(0, 0, 0), 0.35)))
                        table.move(values, 1, values.n, 3, workingData)
                    end

                    secondaryValue = colorSequence(workingData)
                else
                    secondaryValue = tertiaryInput
                end

                if not secondaryValue then
                    local colorSequence = ColorSequence.new
                    local workingData = {}
                    local currentObject = ColorSequenceKeypoint.new(0, Color3.fromRGB(235, 235, 240))
                    local currentItem = ColorSequenceKeypoint.new(0.5, Color3.fromRGB(128, 128, 136))
                    workingData[1] = currentObject
                    workingData[2] = currentItem

                    do
                        local values = table.pack(ColorSequenceKeypoint.new(1, Color3.fromRGB(48, 48, 58)))
                        table.move(values, 1, values.n, 3, workingData)
                    end

                    secondaryValue = colorSequence(workingData)
                end

                lustDotGradient.Color = secondaryValue
                lustDotGradient.Rotation = 90
            end

            local lustPurpleGloss = inputValue:FindFirstChild("LustPurpleGloss")

            if lustPurpleGloss then
                lustPurpleGloss.Visible = true
                lustPurpleGloss.BackgroundTransparency = tertiaryInput and 0.5 or 0.62
            end

            local uiScale = inputValue:FindFirstChildOfClass("UIScale")

            if uiScale then
                uiScale.Scale = tertiaryInput and 1.08 or 0.92
                local workingData = { Scale = 1 }
                TweenService
                    :Create(uiScale, TweenInfo.new(0.28, Enum.EasingStyle.Back, Enum.EasingDirection.Out), workingData)
                    :Play()
            end

            TweenService:Create(inputValue, TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Size = UDim2.new(0, 12, 0, 13),
                BackgroundColor3 = tertiaryInput and primaryColor or Color3.fromRGB(92, 92, 104),
            }):Play()

            local workingData = { Color = primaryColor, Transparency = 1, Thickness = 0 }
            TweenService:Create(secondaryInput, TweenInfo.new(0.22), workingData):Play()
        end

        local function createToggleSelector(parentFrame, initialIndex, options, onSelect, rightOffset, displayOptions)
            local n = #options
            rightOffset = rightOffset or 50

            local arrow = Instance.new("TextButton", parentFrame)
            arrow.Name = "SelectorArrow"
            arrow.Size = UDim2.new(0, 30, 0, 22)
            arrow.AnchorPoint = Vector2.new(1, 0.5)
            arrow.Position = UDim2.new(1, -rightOffset, 0.5, 0)
            arrow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
            arrow.BackgroundTransparency = 0
            arrow.BorderSizePixel = 0
            arrow.Text = "▼"
            arrow.Font = Enum.Font.GothamBlack
            arrow.TextSize = 13
            arrow.AutoButtonColor = false
            arrow.TextColor3 = textColor
            arrow.ZIndex = 14
            Instance.new("UICorner", arrow).CornerRadius = UDim.new(0, 7)
            local arrowStroke = Instance.new("UIStroke", arrow)
            arrowStroke.Color = Color3.fromRGB(34, 34, 40)
            arrowStroke.Thickness = 1
            arrowStroke.Transparency = 0.08
            arrowStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

            local host = parentFrame.Parent or parentFrame
            local dd = Instance.new("Frame", host)
            dd.Name = "SelectorOptions"
            dd.Size = UDim2.new(1, -4, 0, 0)
            dd.BackgroundColor3 = Color3.fromRGB(12, 12, 17)
            dd.BackgroundTransparency = 0.1
            dd.BorderSizePixel = 0
            dd.Visible = false
            dd.ClipsDescendants = true
            dd.ZIndex = 7
            if _G_LUST_ROW_ORDER then
                dd.LayoutOrder = _G_LUST_ROW_ORDER()
            else
                dd.LayoutOrder = (parentFrame.LayoutOrder or 0) + 1
            end
            Instance.new("UICorner", dd).CornerRadius = UDim.new(0, 11)
            local ddStroke = Instance.new("UIStroke", dd)
            ddStroke:SetAttribute("KairnoxThemeRole", "AccentStroke")
            ddStroke.Color = primaryColor
            ddStroke.Thickness = 1.2
            ddStroke.Transparency = 0.35

            local slider = Instance.new("Frame", dd)
            slider:SetAttribute("KairnoxThemeRole", "Accent")
            slider.Size = UDim2.new(1 / n, -6, 1, -8)
            slider.BackgroundColor3 = primaryColor
            slider.BorderSizePixel = 0
            slider.ZIndex = 8
            Instance.new("UICorner", slider).CornerRadius = UDim.new(0, 9)
            local sliderStroke = Instance.new("UIStroke", slider)
            sliderStroke:SetAttribute("KairnoxThemeRole", "AccentStroke")
            sliderStroke.Color = primaryColor
            sliderStroke.Thickness = 1
            sliderStroke.Transparency = 0.2

            local labels = {}
            local idx = initialIndex

            local function paint(animate)
                local pos = UDim2.new((idx - 1) / n, 3, 0, 4)
                slider.BackgroundColor3 = primaryColor
                sliderStroke.Color = primaryColor
                ddStroke.Color = primaryColor
                if animate then
                    TweenService:Create(slider, TweenInfo.new(0.18, Enum.EasingStyle.Quad), { Position = pos }):Play()
                else
                    slider.Position = pos
                end
                for i, l in ipairs(labels) do
                    l:SetAttribute("KairnoxThemeRole", "ActiveLabel")
                    l:SetAttribute("KairnoxThemeActive", i == idx)
                    if i == idx then
                        l.TextColor3 = Color3.fromRGB(14, 14, 20)
                        l.TextTransparency = 0
                        l.TextStrokeTransparency = 1
                    else
                        l.TextColor3 = Color3.fromRGB(215, 215, 230)
                        l.TextTransparency = 0.25
                        l.TextStrokeTransparency = 0.6
                    end
                end
            end

            for i, opt in ipairs(options) do
                local lbl = Instance.new("TextLabel", dd)
                lbl.Size = UDim2.new(1 / n, 0, 1, 0)
                lbl.Position = UDim2.new((i - 1) / n, 0, 0, 0)
                lbl.BackgroundTransparency = 1
                lbl.Text = string.upper(tostring((displayOptions and displayOptions[i]) or opt))
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
                trackLustConnection(b.Activated:Connect(function()
                    idx = i
                    paint(true)
                    if onSelect then onSelect(i, options[i]) end
                    task.defer(function() pcall(saveConfig) end)
                end))
            end
            paint(false)

            local open, tw = false, nil
            trackLustConnection(arrow.Activated:Connect(function()
                open = not open
                if tw then tw:Cancel() end
                if open then
                    paint(false)
                    dd.Visible = true
                    arrow.Text = "▲"
                    tw = TweenService:Create(
                        dd,
                        TweenInfo.new(0.24, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
                        { Size = UDim2.new(1, -4, 0, 40) }
                    )
                    tw:Play()
                else
                    arrow.Text = "▼"
                    tw = TweenService:Create(
                        dd,
                        TweenInfo.new(0.2, Enum.EasingStyle.Quint, Enum.EasingDirection.In),
                        { Size = UDim2.new(1, -4, 0, 0) }
                    )
                    trackLustConnection(tw.Completed:Connect(function() if not open then dd.Visible = false end end))
                    tw:Play()
                end
            end))

            return {
                setIndex = function(newIdx, skipSave)
                    idx = math.clamp(newIdx, 1, n)
                    paint(true)
                    if not skipSave then task.defer(function() pcall(saveConfig) end) end
                end,
                setByValue = function(val, skipSave)
                    for i, opt in ipairs(options) do
                        if opt == val then
                            idx = i; paint(true)
                            if not skipSave then task.defer(function() pcall(saveConfig) end) end
                            return
                        end
                    end
                end,
            }
        end

        _G.__LustCreateToggleSelector = createToggleSelector

        local featureHelperAD

        featureHelperAD = function(inputValue, secondaryInput)
            local secondaryValue = createFrame(28)
            createTextLabel(secondaryValue, inputValue)
            local currentObject, currentItem, targetObject = featureHelperAB(secondaryValue, 28)
            local isActive = false

            local function featureHelperAE(tertiaryInput)
                isActive = tertiaryInput
                featureHelperAC(currentItem, targetObject, tertiaryInput)
            end

            local toggleButton = Instance.new("TextButton", currentObject)
            toggleButton.Size = UDim2.new(1, 0, 1, 0)
            toggleButton.BackgroundTransparency = 1
            toggleButton.Text = ""
            toggleButton.ZIndex = 5

            trackLustConnection(toggleButton.Activated:Connect(function()
                if isKeybindLocked() then
                    return
                end
                isActive = not isActive
                featureHelperAE(isActive)
                secondaryInput(isActive)
                saveConfig()
            end))

            return featureHelperAE, secondaryValue
        end

        local createTextBox

        createTextBox = function(inputValue, secondaryInput, tertiaryInput, fourthInput, fifthInput)
            local textBox = Instance.new("TextBox", inputValue)
            textBox.Size = UDim2.new(0, tertiaryInput or 50, 0, 22)
            textBox.Position = UDim2.new(1, -(fourthInput or 58), 0.5, -11)
            textBox.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
            textBox.BackgroundTransparency = 0
            textBox.BorderSizePixel = 0
            textBox.Text = tostring(secondaryInput)
            textBox.TextColor3 = textColor
            textBox.Font = Enum.Font.GothamBold
            textBox.TextSize = 11
            textBox.ClearTextOnFocus = false
            textBox.ZIndex = 5
            Instance.new("UICorner", textBox).CornerRadius = UDim.new(0, 7)
            local uiStroke2 = Instance.new("UIStroke", textBox)
            uiStroke2.Color = Color3.fromRGB(34, 34, 40)
            uiStroke2.Thickness = 1
            uiStroke2.Transparency = 0.52
            uiStroke2.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

            trackLustConnection(textBox.Focused:Connect(function()
                TweenService
                    :Create(uiStroke2, TweenInfo.new(0.1), { Color = Color3.fromRGB(34, 34, 40), Transparency = 0.08 })
                    :Play()
            end))

            trackLustConnection(textBox.FocusLost:Connect(function()
                TweenService
                    :Create(uiStroke2, TweenInfo.new(0.1), { Color = Color3.fromRGB(34, 34, 40), Transparency = 0.08 })
                    :Play()

                if fifthInput then
                    local numericValue = tonumber(textBox.Text)

                    if numericValue then
                        fifthInput(numericValue)
                    else
                        textBox.Text = tostring(secondaryInput)
                    end
                end
            end))

            return textBox
        end

        local featureHelperAE, featureHelperAF

        local workingData = {
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

        featureHelperAE = function(inputValue)
            return inputValue and inputValue.UserInputType and inputValue.UserInputType.Name:match("^Gamepad") ~= nil
        end

        featureHelperAF = function(inputValue)
            if not inputValue or inputValue.KeyCode == Enum.KeyCode.Unknown then
                return false
            end

            if inputValue.UserInputType == Enum.UserInputType.Keyboard then
                return true
            end
            return featureHelperAE(inputValue) and workingData[inputValue.KeyCode] == true
        end

        local featureHelperAG

        featureHelperAG = function(inputValue, secondaryInput)
            if secondaryInput then
                local isActive = secondaryInput == inputValue.kb

                if isActive then
                    secondaryInput = isActive
                else
                    secondaryInput = inputValue.gp and secondaryInput == inputValue.gp
                end
            end

            return secondaryInput
        end

        local createTextButton

        createTextButton = function(inputValue, secondaryInput, tertiaryInput)
            local toggleButton = Instance.new("TextButton", inputValue)
            toggleButton.Size = UDim2.new(0, 48, 1, -6)
            toggleButton.Position = UDim2.new(1, -98, 0, 3)
            toggleButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
            toggleButton.BackgroundTransparency = 0
            toggleButton.BorderSizePixel = 0

            local function featureHelperAH()
                return secondaryInput.gp and secondaryInput.gp.Name
                    or secondaryInput.kb and secondaryInput.kb.Name
                    or "None"
            end

            toggleButton.Text = featureHelperAH()
            toggleButton.TextColor3 = textColor
            toggleButton.Font = Enum.Font.GothamBold
            toggleButton.TextSize = 9
            toggleButton.ZIndex = 5
            Instance.new("UICorner", toggleButton).CornerRadius = UDim.new(0, 8)
            local uiStroke2 = Instance.new("UIStroke", toggleButton)
            uiStroke2.Color = Color3.fromRGB(34, 34, 40)
            uiStroke2.Thickness = 1
            uiStroke2.Transparency = 0.52
            uiStroke2.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            local isActive = false
            local activeConnection = nil
            local labelText = toggleButton.Text
            local amount = 0

            trackLustConnection(toggleButton.Activated:Connect(function()
                if isActive then
                    isActive = false
                    local secondaryValue = 0.25
                    _keyListenBlockUntil = tick() + secondaryValue
                    _anyKeyListening = false

                    if activeConnection then
                        activeConnection:Disconnect()
                        activeConnection = nil
                    end

                    toggleButton.Text = labelText
                    toggleButton.TextColor3 = textColor
                    TweenService
                        :Create(
                            uiStroke2,
                            TweenInfo.new(0.1),
                            { Color = Color3.fromRGB(34, 34, 40), Transparency = 0.08 }
                        )
                        :Play()
                    return
                end

                if isKeybindLocked() then
                    return
                end
                labelText = toggleButton.Text
                isActive = true
                _anyKeyListening = true
                local secondaryValue = 0.25
                _keyListenBlockUntil = tick() + secondaryValue
                amount = tick()
                toggleButton.Text = "..."
                toggleButton.TextColor3 = textColor
                TweenService
                    :Create(uiStroke2, TweenInfo.new(0.1), { Color = Color3.fromRGB(34, 34, 40), Transparency = 0.08 })
                    :Play()

                activeConnection = trackLustConnection(UserInputService.InputBegan:Connect(function(input)
                    if not isActive then
                        return
                    end

                    if input.KeyCode == Enum.KeyCode.Escape then
                        isActive = false
                        _keyListenBlockUntil = tick() + 0.25
                        _anyKeyListening = false

                        if activeConnection then
                            activeConnection:Disconnect()
                            activeConnection = nil
                        end

                        toggleButton.Text = labelText
                        toggleButton.TextColor3 = textColor
                        TweenService:Create(
                            uiStroke2,
                            TweenInfo.new(0.1),
                            { Color = Color3.fromRGB(34, 34, 40), Transparency = 0.08 }
                        ):Play()
                        return
                    end

                    local currentObject = featureHelperAE(input)
                    if currentObject and tick() - amount < 0.15 then
                        return
                    end

                    if not featureHelperAF(input) then
                        return
                    end
                    clearDuplicateKeybind(input.KeyCode, currentObject, secondaryInput)
                    toggleButton.Text = input.KeyCode.Name
                    labelText = input.KeyCode.Name
                    toggleButton.TextColor3 = textColor
                    TweenService
                        :Create(
                            uiStroke2,
                            TweenInfo.new(0.1),
                            { Color = Color3.fromRGB(34, 34, 40), Transparency = 0.08 }
                        )
                        :Play()
                    isActive = false
                    _keyListenBlockUntil = tick() + 0.25
                    _anyKeyListening = false

                    if activeConnection then
                        activeConnection:Disconnect()
                        activeConnection = nil
                    end

                    if tertiaryInput then
                        tertiaryInput(input.KeyCode, currentObject)
                    end

                    refreshAllKeyButtons()
                end))
            end))

            _vhKeyButtons[secondaryInput] = toggleButton
            return toggleButton
        end

        local featureHelperAH

        featureHelperAH = function(inputValue, secondaryInput, tertiaryInput, fourthInput)
            local secondaryValue = createFrame(28)
            createTextLabel(secondaryValue, inputValue)

            if secondaryInput then
                createTextButton(secondaryValue, secondaryInput, function(gp, fifthInput)
                    if fifthInput then
                        secondaryInput.gp = gp
                        secondaryInput.kb = nil
                    else
                        secondaryInput.kb = gp
                        secondaryInput.gp = nil
                    end

                    if fourthInput then
                        fourthInput(gp, fifthInput)
                    end
                end)
            end

            local currentObject = featureHelperAB
            secondaryInput = secondaryInput and 88 or 0
            local currentItem, targetObject, uiElement = currentObject(secondaryValue, secondaryInput)
            local isActive = false

            local function featureHelperAI(fifthInput)
                isActive = fifthInput
                featureHelperAC(targetObject, uiElement, fifthInput)
            end

            local detailControl = Instance.new("TextButton", currentItem)
            detailControl.Size = UDim2.new(1, 0, 1, 0)
            detailControl.BackgroundTransparency = 1
            detailControl.Text = ""
            detailControl.ZIndex = 5

            trackLustConnection(detailControl.Activated:Connect(function()
                if isKeybindLocked() then
                    return
                end
                isActive = not isActive
                featureHelperAI(isActive)

                if tertiaryInput then
                    tertiaryInput(isActive)
                end

                saveConfig()
            end))

            return featureHelperAI
        end

        local applyStealBarLockState
        do
            -- Barra de Auto Steal (estilo Yout v15)
            local isTouchOnly = UserInputService.TouchEnabled and not UserInputService.MouseEnabled
            local pbFrame = Instance.new("Frame", screenGui)
            pbFrame.Name = "StealBar"
            pbFrame.Size = UDim2.fromOffset(290, 32)
            pbFrame.AnchorPoint = Vector2.new(0.5, 0.5)
            pbFrame.Position = UDim2.new(0.5, 0, 1, isTouchOnly and -54 or -48)
            pbFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
            pbFrame.BackgroundTransparency = 1
            pbFrame.BorderSizePixel = 0
            pbFrame.Active = true
            pbFrame.ClipsDescendants = true
            pbFrame.Visible = false
            pbFrame.ZIndex = 50
            Instance.new("UICorner", pbFrame).CornerRadius = UDim.new(1, 0)
            progressBarContainer = pbFrame
            progressBarScale = Instance.new("UIScale", pbFrame)
            progressBarScale.Name = "LustStealBarScale"
            progressBarScale.Scale = uiScaleValue / 100

            -- Asa discreta: la barra solo se puede mover cuando Lock UI está desactivado.
            local pbDragHandle = Instance.new("TextButton", pbFrame)
            pbDragHandle.Name = "StealBarDragHandle"
            pbDragHandle.Size = UDim2.new(1, 0, 0, 12)
            pbDragHandle.Position = UDim2.new(0, 0, 0, 0)
            pbDragHandle.BackgroundTransparency = 1
            pbDragHandle.Text = ""
            pbDragHandle.Active = not qaLocked
            pbDragHandle.AutoButtonColor = false
            pbDragHandle.ZIndex = 60
            local barDragging, barDragStart, barCenterStart = false, nil, nil
            applyStealBarLockState = function(isLocked)
                if isLocked then
                    barDragging = false
                    barDragStart, barCenterStart = nil, nil
                end
                pbDragHandle.Active = not isLocked
            end
            applyStealBarLockState(qaLocked)
            trackLustConnection(pbDragHandle.InputBegan:Connect(function(input)
                if qaLocked then return end
                if input.UserInputType ~= Enum.UserInputType.MouseButton1
                    and input.UserInputType ~= Enum.UserInputType.Touch then return end
                local absolute = pbFrame.AbsolutePosition
                local size = pbFrame.AbsoluteSize
                barDragging = true
                barDragStart = input.Position
                barCenterStart = Vector2.new(
                    absolute.X + size.X * pbFrame.AnchorPoint.X,
                    absolute.Y + size.Y * pbFrame.AnchorPoint.Y
                )
            end))
            trackLustConnection(UserInputService.InputChanged:Connect(function(input)
                if not barDragging then return end
                if qaLocked then barDragging = false; return end
                if input.UserInputType ~= Enum.UserInputType.MouseMovement
                    and input.UserInputType ~= Enum.UserInputType.Touch then return end
                local viewport = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize
                if not viewport then return end
                local delta = input.Position - barDragStart
                local size = pbFrame.AbsoluteSize
                local centerX = math.clamp(barCenterStart.X + delta.X, size.X * 0.5, viewport.X - size.X * 0.5)
                local centerY = math.clamp(barCenterStart.Y + delta.Y, size.Y * 0.5, viewport.Y - size.Y * 0.5)
                pbFrame.Position = UDim2.new(0, centerX, 0, centerY)
            end))
            trackLustConnection(UserInputService.InputEnded:Connect(function(input)
                if not barDragging then return end
                if input.UserInputType == Enum.UserInputType.MouseButton1
                    or input.UserInputType == Enum.UserInputType.Touch then
                    barDragging = false
                    barDragStart, barCenterStart = nil, nil
                    saveConfig()
                end
            end))

            local metalSeq = ColorSequence.new({
                ColorSequenceKeypoint.new(0.00, Color3.fromRGB(25, 25, 30)),
                ColorSequenceKeypoint.new(0.42, Color3.fromRGB(155, 155, 165)),
                ColorSequenceKeypoint.new(0.50, Color3.fromRGB(255, 255, 255)),
                ColorSequenceKeypoint.new(0.58, Color3.fromRGB(155, 155, 165)),
                ColorSequenceKeypoint.new(1.00, Color3.fromRGB(25, 25, 30)),
            })

            local pbOuterStroke = Instance.new("UIStroke", pbFrame)
            pbOuterStroke.Name = "OuterStroke"
            pbOuterStroke:SetAttribute("KairnoxThemeRole", "AccentStroke")
            pbOuterStroke.Color = primaryColor
            pbOuterStroke.Thickness = 1.6
            pbOuterStroke.Transparency = 0.05
            pbOuterStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            local pbOuterGrad = Instance.new("UIGradient", pbOuterStroke)
            pbOuterGrad.Color = metalSeq
            local progressSessionEnv = getgenv and getgenv() or _G
            local progressSessionToken = rawget(progressSessionEnv, "__LustSessionToken")
            local function progressSessionActive()
                return rawget(progressSessionEnv, "__LustSessionToken") == progressSessionToken
            end
            task.spawn(function()
                while progressSessionActive() and pbOuterGrad and pbOuterGrad.Parent do
                    if pbFrame.Visible then
                        pbOuterGrad.Rotation = (pbOuterGrad.Rotation + 2) % 360
                        task.wait(0.05)
                    else
                        task.wait(0.5)
                    end
                end
            end)

            local pbWallpaperLayer = Instance.new("Frame", pbFrame)
            pbWallpaperLayer.Name = "WallpaperLayer"
            pbWallpaperLayer.Size = UDim2.fromScale(1, 1)
            pbWallpaperLayer.BackgroundTransparency = 1
            pbWallpaperLayer.BorderSizePixel = 0
            pbWallpaperLayer.ZIndex = 0
            pbWallpaperLayer.ClipsDescendants = true
            Instance.new("UICorner", pbWallpaperLayer).CornerRadius = UDim.new(1, 0)

            local pbWallpaper = Instance.new("ImageLabel", pbWallpaperLayer)
            pbWallpaper.Name = "Wallpaper"
            pbWallpaper.Size = UDim2.fromScale(1, 1)
            pbWallpaper.BackgroundTransparency = 1
            pbWallpaper.ImageTransparency = 0
            pbWallpaper.ScaleType = Enum.ScaleType.Crop
            pbWallpaper.Image = "rbxassetid://107957242975210"
            pbWallpaper.ZIndex = 1
            Instance.new("UICorner", pbWallpaper).CornerRadius = UDim.new(1, 0)

            local pbWallpaperOverlay = Instance.new("Frame", pbWallpaperLayer)
            pbWallpaperOverlay.Name = "WallpaperOverlay"
            pbWallpaperOverlay.Size = UDim2.fromScale(1, 1)
            pbWallpaperOverlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
            pbWallpaperOverlay.BackgroundTransparency = 0.68
            pbWallpaperOverlay.BorderSizePixel = 0
            pbWallpaperOverlay.ZIndex = 2
            Instance.new("UICorner", pbWallpaperOverlay).CornerRadius = UDim.new(1, 0)

            local pbTrack = Instance.new("Frame", pbFrame)
            pbTrack.Name = "LustStealTrack"
            pbTrack.Size = UDim2.new(0, 166, 1, -8)
            pbTrack.Position = UDim2.new(0, 5, 0, 4)
            pbTrack.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
            pbTrack.BackgroundTransparency = 0.62
            pbTrack.BorderSizePixel = 0
            pbTrack.ClipsDescendants = true
            pbTrack.ZIndex = 3
            Instance.new("UICorner", pbTrack).CornerRadius = UDim.new(1, 0)

            progressFill = Instance.new("Frame", pbTrack)
            progressFill.Name = "Fill"
            progressFill:SetAttribute("KairnoxThemeRole", "Progress")
            progressFill.Size = UDim2.new(0, 0, 1, 0)
            progressFill.BackgroundColor3 = primaryColor
            progressFill.BackgroundTransparency = 0.08
            progressFill.BorderSizePixel = 0
            progressFill.ZIndex = 4
            Instance.new("UICorner", progressFill).CornerRadius = UDim.new(1, 0)

            local pbFillGrad = Instance.new("UIGradient", progressFill)
            pbFillGrad.Name = "LustStealFillGradient"
            pbFillGrad:SetAttribute("KairnoxThemeRole", "ProgressGradient")
            pbFillGrad.Rotation = 0
            pbFillGrad.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0.00, Color3.fromRGB(25, 25, 30)),
                ColorSequenceKeypoint.new(0.34, Color3.fromRGB(155, 155, 165)),
                ColorSequenceKeypoint.new(0.47, Color3.fromRGB(190, 190, 198)),
                ColorSequenceKeypoint.new(0.50, Color3.fromRGB(255, 255, 255)),
                ColorSequenceKeypoint.new(0.53, Color3.fromRGB(190, 190, 198)),
                ColorSequenceKeypoint.new(0.66, Color3.fromRGB(155, 155, 165)),
                ColorSequenceKeypoint.new(1.00, Color3.fromRGB(25, 25, 30)),
            })
            task.spawn(function()
                while progressSessionActive() and pbFillGrad and pbFillGrad.Parent do
                    if pbFrame.Visible then
                        pbFillGrad.Offset = Vector2.new(-1, 0)
                        local t = TweenService:Create(
                            pbFillGrad,
                            TweenInfo.new(1.15, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut),
                            { Offset = Vector2.new(1, 0) }
                        )
                        t:Play()
                        t.Completed:Wait()
                        task.wait(0.03)
                    else
                        task.wait(0.5)
                    end
                end
            end)

            local pbBadge = Instance.new("Frame", pbTrack)
            pbBadge.Name = "AvatarBadge"
            pbBadge.Size = UDim2.fromOffset(20, 20)
            pbBadge.Position = UDim2.fromOffset(6, 2)
            pbBadge.BackgroundColor3 = Color3.fromRGB(10, 10, 14)
            pbBadge.BackgroundTransparency = 0.08
            pbBadge.BorderSizePixel = 0
            pbBadge.ZIndex = 7
            Instance.new("UICorner", pbBadge).CornerRadius = UDim.new(1, 0)

            local pbAvatar = Instance.new("ImageLabel", pbBadge)
            pbAvatar.Name = "Avatar"
            pbAvatar.Size = UDim2.fromOffset(13, 17)
            pbAvatar.Position = UDim2.fromOffset(1, 1)
            pbAvatar.BackgroundTransparency = 1
            pbAvatar.ScaleType = Enum.ScaleType.Crop
            pbAvatar.ZIndex = 8
            Instance.new("UICorner", pbAvatar).CornerRadius = UDim.new(1, 0)

            local pbBadgeStroke = Instance.new("UIStroke", pbBadge)
            pbBadgeStroke.Color = Color3.fromRGB(230, 230, 230)
            pbBadgeStroke.Thickness = 1.5
            pbBadgeStroke.Transparency = 0.02
            local pbBadgeGrad = Instance.new("UIGradient", pbBadgeStroke)
            pbBadgeGrad.Color = metalSeq
            task.spawn(function()
                while progressSessionActive() and pbBadgeGrad and pbBadgeGrad.Parent do
                    if pbFrame.Visible then
                        pbBadgeGrad.Rotation = (pbBadgeGrad.Rotation + 3) % 360
                        task.wait(0.05)
                    else
                        task.wait(0.5)
                    end
                end
            end)

            task.spawn(function()
                local ok, img = pcall(function()
                    return Players:GetUserThumbnailAsync(
                        localPlayer.UserId,
                        Enum.ThumbnailType.HeadShot,
                        Enum.ThumbnailSize.Size100x100
                    )
                end)
                if ok and img and progressSessionActive() and pbAvatar and pbAvatar.Parent then
                    pbAvatar.Image = img
                end
            end)

            progressPct = Instance.new("TextLabel", pbTrack)
            progressPct.Size = UDim2.new(0, 44, 1, 0)
            progressPct.Position = UDim2.new(1, -48, 0, 0)
            progressPct.BackgroundTransparency = 1
            progressPct.Text = "0%"
            progressPct.TextColor3 = Color3.fromRGB(230, 230, 230)
            progressPct.Font = Enum.Font.GothamSemibold
            progressPct.TextSize = 11
            progressPct.TextXAlignment = Enum.TextXAlignment.Right
            progressPct.ZIndex = 6

            local pbFpsLabel = Instance.new("TextLabel", pbFrame)
            pbFpsLabel.Name = "FPSLabel"
            pbFpsLabel.Size = UDim2.new(0, 112, 0, 14)
            pbFpsLabel.Position = UDim2.fromOffset(173, 2)
            pbFpsLabel.BackgroundTransparency = 1
            pbFpsLabel.Text = "FPS 0  ·  0ms"
            pbFpsLabel.TextColor3 = Color3.fromRGB(230, 230, 230)
            pbFpsLabel.Font = Enum.Font.GothamSemibold
            pbFpsLabel.TextSize = 10
            pbFpsLabel.TextXAlignment = Enum.TextXAlignment.Center
            pbFpsLabel.ZIndex = 6

            local pbClock = Instance.new("TextLabel", pbFrame)
            pbClock.Name = "Clock"
            pbClock.Size = UDim2.new(0, 112, 0, 13)
            pbClock.Position = UDim2.fromOffset(173, 16)
            pbClock.BackgroundTransparency = 1
            pbClock.Text = "8:00 PM"
            pbClock.TextColor3 = Color3.fromRGB(255, 255, 255)
            pbClock.Font = Enum.Font.GothamSemibold
            pbClock.TextSize = 9
            pbClock.TextXAlignment = Enum.TextXAlignment.Center
            pbClock.ZIndex = 50

            task.spawn(function()
                local frameCount = 0
                local windowStart = tick()
                local fpsAvg = 60
                local lastPing = 0
                local fpsTickConn = trackLustConnection(RunService.RenderStepped:Connect(function()
                    frameCount = frameCount + 1
                end))
                local function readPing()
                    local ok, v = pcall(function()
                        return localPlayer:GetNetworkPing() * 1000
                    end)
                    if ok and type(v) == "number" and v == v and v >= 0 and v < 5000 then
                        return v
                    end
                    local ok2, v2 = pcall(function()
                        return game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue()
                    end)
                    if ok2 and type(v2) == "number" and v2 >= 0 then
                        return v2
                    end
                    return nil
                end
                while progressSessionActive() and pbFrame and pbFrame.Parent do
                    if not pbFrame.Visible then
                        frameCount = 0
                        windowStart = tick()
                        task.wait(0.5)
                        continue
                    end
                    local now = tick()
                    local elapsed = now - windowStart
                    if elapsed > 0.05 then
                        local instantFps = frameCount / elapsed
                        fpsAvg = fpsAvg + (instantFps - fpsAvg) * 0.5
                        frameCount = 0
                        windowStart = now
                    end
                    local p = readPing()
                    if p then
                        lastPing = math.floor(p + 0.5)
                    end
                    pbFpsLabel.Text = string.format("FPS %d  ·  %dms", math.floor(fpsAvg + 0.5), lastPing)
                    pbClock.Text = (os.date("%I:%M %p"):gsub("^0", ""))
                    task.wait(0.25)
                end
                fpsTickConn:Disconnect()
            end)

            featureHelperW(pbFrame)
        end

        featureHelperZ("Normal Mode")
        local secondaryValue = createFrame(28)
        createTextLabel(secondaryValue, "Normal Speed")

        normalBox = createTextBox(secondaryValue, NS, 50, 58, function(inputValue)
            NS = math.clamp(inputValue, 1, 250)
            if normalBox then normalBox.Text = tostring(NS) end
            saveConfig()
        end)

        local currentObject = createFrame(28)
        createTextLabel(currentObject, "Carry Speed")

        carryBox = createTextBox(currentObject, CS, 50, 56, function(inputValue)
            CS = math.clamp(inputValue, 1, 250)
            if carryBox then carryBox.Text = tostring(CS) end
            saveConfig()
        end)

        setBuildTab("Keybind")
        local currentItem = createFrame(28)
        createTextLabel(currentItem, "Speed Key")

        local speedKeyBtn = createTextButton(currentItem, KB.SpeedToggle, function(gp, inputValue)
            if inputValue then
                KB.SpeedToggle.gp = gp
                KB.SpeedToggle.kb = nil
            else
                KB.SpeedToggle.kb = gp
                KB.SpeedToggle.gp = nil
            end

            saveConfig()
        end)
        speedKeyBtn.Size = UDim2.new(0, 54, 0, 28)
        speedKeyBtn.Position = UDim2.new(1, -58, 0.5, -14)
        setBuildTab("Speed")

        featureHelperZ("Lagger Mode")
        local targetObject = createFrame(28)
        createTextLabel(targetObject, "Lagger Normal Speed")

        laggerBox = createTextBox(targetObject, LAGGER_SPEED, 50, 58, function(inputValue)
            LAGGER_SPEED = math.clamp(inputValue, 1, 250)
            if laggerBox then laggerBox.Text = tostring(LAGGER_SPEED) end
            saveConfig()
        end)

        local uiElement = createFrame(28)
        createTextLabel(uiElement, "Lagger Carry Speed")

        laggerCarryBox = createTextBox(uiElement, LAGGER_CARRY_SPEED, 50, 58, function(inputValue)
            LAGGER_CARRY_SPEED = math.clamp(inputValue, 1, 250)
            if laggerCarryBox then laggerCarryBox.Text = tostring(LAGGER_CARRY_SPEED) end
            saveConfig()
        end)

        setBuildTab("Keybind")
        local stateToken = createFrame(28)
        createTextLabel(stateToken, "Lagger Key")

        local laggerKeyBtn = createTextButton(stateToken, KB.LaggerToggle, function(gp, inputValue)
            if inputValue then
                KB.LaggerToggle.gp = gp
                KB.LaggerToggle.kb = nil
            else
                KB.LaggerToggle.kb = gp
                KB.LaggerToggle.gp = nil
            end

            saveConfig()
        end)
        laggerKeyBtn.Size = UDim2.new(0, 54, 0, 28)
        laggerKeyBtn.Position = UDim2.new(1, -58, 0.5, -14)
        setBuildTab("Speed")

        featureHelperZ("Speed Mode")
        local glossOverlay = createFrame(28)
        createTextLabel(glossOverlay, "Mode")
        modeValLbl = Instance.new("TextLabel", glossOverlay)
        modeValLbl.Size = UDim2.new(0, 96, 1, 0)
        modeValLbl.Position = UDim2.new(1, -104, 0, 0)
        modeValLbl.BackgroundTransparency = 1
        modeValLbl.TextColor3 = primaryColor
        modeValLbl.Font = Enum.Font.GothamBlack
        modeValLbl.TextSize = 11
        modeValLbl.TextXAlignment = Enum.TextXAlignment.Right
        modeValLbl.TextStrokeTransparency = 1
        modeValLbl.ZIndex = 5
        refreshSpeedModeLabel()

        featureHelperZ("Automation", "Speed")

        do
            local acRow = createFrame(28)
            createTextLabel(acRow, "Auto Carry")

            local acToggleContainer, acDot, acStroke = featureHelperAB(acRow, 88)
            local acActive = false

            local function acSetVisual(v)
                acActive = v
                featureHelperAC(acDot, acStroke, v)
            end

            autoCarrySelector = createToggleSelector(
                acRow,
                (autoCarryMode == "Soft Steal") and 2 or 1,
                { "On Pick Up", "Soft Steal" },
                function(idx, value)
                    autoCarryMode = value
                    saveConfig()
                end,
                52,
                { "On Pick Up", "Soft Steal" }
            )

            local acToggleBtn = Instance.new("TextButton", acToggleContainer)
            acToggleBtn.Size = UDim2.new(1, 0, 1, 0)
            acToggleBtn.BackgroundTransparency = 1
            acToggleBtn.Text = ""
            acToggleBtn.ZIndex = 5

            trackLustConnection(acToggleBtn.Activated:Connect(function()
                if isKeybindLocked() then return end
                acActive = not acActive
                acSetVisual(acActive)
                if _G.__LustAutoCarrySetEnabled then
                    _G.__LustAutoCarrySetEnabled(acActive)
                end
                saveConfig()
            end))

            autoCarrySetVisual = acSetVisual
        end

        featureHelperZ("Steal", "Steal")
        do
            local detailsRow = createFrame(28)
            createTextLabel(detailsRow, "Auto Steal")
            autoStealArrowButton = Instance.new("TextButton", detailsRow)
            autoStealArrowButton.Size = UDim2.new(0, 30, 0, 22)
            autoStealArrowButton.Position = UDim2.new(1, -82, 0.5, -11)
            featureHelperAA(autoStealArrowButton)
            autoStealArrowButton.Text = autoStealDetailsOpen and AUTO_BAT_ARROW_OPEN or AUTO_BAT_ARROW_CLOSED
            autoStealArrowButton.TextColor3 = textColor
            autoStealArrowButton.Font = Enum.Font.GothamBlack
            autoStealArrowButton.TextSize = 13
            autoStealArrowButton.ZIndex = 6
            autoStealArrowButton.AutoButtonColor = false
            Instance.new("UICorner", autoStealArrowButton).CornerRadius = UDim.new(0, 7)
            local settingsRow, toggleContainer, optionRow = featureHelperAB(detailsRow, 28)
            local isActive = false

            local function featureHelperAI(inputValue)
                isActive = inputValue
                featureHelperAC(toggleContainer, optionRow, inputValue)
            end

            setInstaGrab = featureHelperAI
            local toggleButton = Instance.new("TextButton", settingsRow)
            toggleButton.Size = UDim2.new(1, 0, 1, 0)
            toggleButton.BackgroundTransparency = 1
            toggleButton.Text = ""
            toggleButton.ZIndex = 5

            trackLustConnection(toggleButton.Activated:Connect(function()
                isActive = not isActive
                featureHelperAI(isActive)

                if isActive then
                    if not pcall(startAutoSteal) then
                        Steal.AutoStealEnabled = false
                        featureHelperAI(false)
                    end
                else
                    stopAutoSteal()
                end

                saveConfig()
            end))
        end

        trackLustConnection(autoStealArrowButton.Activated:Connect(function()
            autoStealDetailsOpen = not autoStealDetailsOpen
            autoStealArrowButton.Text = autoStealDetailsOpen and AUTO_BAT_ARROW_OPEN or AUTO_BAT_ARROW_CLOSED

            for _, detailsRow in ipairs(autoStealDetailsRows) do
                local isActive = autoStealDetailsOpen

                if isActive then
                    detailsRow.Visible = true
                    detailsRow.Size = UDim2.new(1, 0, 0, 0)
                    detailsRow.BackgroundTransparency = 1
                    local amount = detailsRow:GetAttribute("AutoStealSelectorRow") and 1 or 0.34
                    TweenService:Create(
                        detailsRow,
                        TweenInfo.new(0.28, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                        { Size = UDim2.new(1, 0, 0, 28), BackgroundTransparency = amount }
                    ):Play()
                else
                    TweenService:Create(
                        detailsRow,
                        TweenInfo.new(0.14, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
                        { Size = UDim2.new(1, 0, 0, 0), BackgroundTransparency = 1 }
                    ):Play()

                    task.delay(0.15, function()
                        if not autoStealDetailsOpen and detailsRow.Parent then
                            detailsRow.Visible = false
                        end
                    end)
                end
            end
        end))

        local detailsRow = createFrame(28)
        detailsRow.Visible = autoStealDetailsOpen
        table.insert(autoStealDetailsRows, detailsRow)

        if not autoStealDetailsOpen then
            detailsRow.Size = UDim2.new(1, 0, 0, 0)
            detailsRow.BackgroundTransparency = 1
        end

        createTextLabel(detailsRow, "Radius")

        radInput = createTextBox(detailsRow, LustSteal.StealRadius, 50, 56, function(inputValue)
            if inputValue >= 0.5 and inputValue <= 300 then
                setAutoStealRadius(inputValue)
            else
                radInput.Text = tostring(LustSteal.StealRadius)
            end

            updateStealRadiusUi()
            saveConfig()
        end)

        updateStealRadiusUi()

        featureHelperZ("Combat")

        do
            local settingsRow = createFrame(32)
            createTextLabel(settingsRow, "BAT AIMBOT")
            autoBatArrowButton = Instance.new("TextButton", settingsRow)
            autoBatArrowButton.Size = UDim2.new(0, 30, 0, 22)
            autoBatArrowButton.Position = UDim2.new(1, -140, 0.5, -11)
            featureHelperAA(autoBatArrowButton)
            autoBatArrowButton.Text = autoBatDetailsOpen and AUTO_BAT_ARROW_OPEN or AUTO_BAT_ARROW_CLOSED
            autoBatArrowButton.TextColor3 = textColor
            autoBatArrowButton.Font = Enum.Font.GothamBlack
            autoBatArrowButton.TextSize = 14
            autoBatArrowButton.ZIndex = 6
            autoBatArrowButton.AutoButtonColor = false
            Instance.new("UICorner", autoBatArrowButton).CornerRadius = UDim.new(0, 7)

            createTextButton(settingsRow, KB.AutoBat, function(gp, inputValue)
                if inputValue then
                    KB.AutoBat.gp = gp
                    KB.AutoBat.kb = nil
                else
                    KB.AutoBat.kb = gp
                    KB.AutoBat.gp = nil
                end

                saveConfig()
            end)

            local toggleContainer, optionRow, toggleBorder = featureHelperAB(settingsRow, 88)
            local isActive = false

            local function featureHelperAI(inputValue)
                isActive = inputValue
                featureHelperAC(optionRow, toggleBorder, inputValue)
            end

            autoBatSetVisual = featureHelperAI
            local detailControl = Instance.new("TextButton", toggleContainer)
            detailControl.Size = UDim2.new(1, 0, 1, 0)
            detailControl.BackgroundTransparency = 1
            detailControl.Text = ""
            detailControl.ZIndex = 5

            trackLustConnection(detailControl.Activated:Connect(function()
                if isKeybindLocked() then
                    return
                end
                isActive = not isActive
                featureHelperAI(isActive)

                if isActive then
                    queueAutoBatStart()
                else
                    disableAutoBat()
                end

                saveConfig()
            end))
        end

        trackLustConnection(autoBatArrowButton.Activated:Connect(function()
            autoBatDetailsOpen = not autoBatDetailsOpen
            autoBatArrowButton.Text = autoBatDetailsOpen and AUTO_BAT_ARROW_OPEN or AUTO_BAT_ARROW_CLOSED

            for _, settingsRow in ipairs(autoBatDetailsRows) do
                if autoBatDetailsOpen then
                    settingsRow.Visible = true
                    settingsRow.Size = UDim2.new(1, 0, 0, 0)
                    settingsRow.BackgroundTransparency = 1
                    local amount = settingsRow:GetAttribute("AutoBatSelectorRow") and 1 or 0.34

                    TweenService
                        :Create(settingsRow, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                            Size = UDim2.new(1, 0, 0, 32),
                            BackgroundTransparency = amount,
                        })
                        :Play()
                else
                    TweenService:Create(
                        settingsRow,
                        TweenInfo.new(0.14, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
                        { Size = UDim2.new(1, 0, 0, 0), BackgroundTransparency = 1 }
                    ):Play()

                    task.delay(0.15, function()
                        if not autoBatDetailsOpen and settingsRow.Parent then
                            settingsRow.Visible = false
                        end
                    end)
                end
            end
        end))

        do
            local settingsRow = createFrame(28)
            settingsRow.Visible = autoBatDetailsOpen
            table.insert(autoBatDetailsRows, settingsRow)

            if not autoBatDetailsOpen then
                settingsRow.Size = UDim2.new(1, 0, 0, 0)
                settingsRow.BackgroundTransparency = 1
            end

            createTextLabel(settingsRow, "Mirror TP")
            local toggleContainer, optionRow, toggleBorder = featureHelperAB(settingsRow, 28)
            local isActive = false

            local function featureHelperAI(inputValue)
                isActive = inputValue
                mirrorTPEnabled = inputValue
                featureHelperAC(optionRow, toggleBorder, inputValue)
            end

            setMirrorTPVisual = featureHelperAI
            local toggleButton = Instance.new("TextButton", toggleContainer)
            toggleButton.Size = UDim2.new(1, 0, 1, 0)
            toggleButton.BackgroundTransparency = 1
            toggleButton.Text = ""
            toggleButton.ZIndex = 5

            trackLustConnection(toggleButton.Activated:Connect(function()
                if isKeybindLocked() then
                    return
                end
                isActive = not isActive
                featureHelperAI(isActive)
                saveConfig()
            end))
        end

        if setAutoSwingVisual then
            setAutoSwingVisual(autoSwingEnabled)
        end

        if setMirrorTPVisual then
            setMirrorTPVisual(mirrorTPEnabled)
        end

        do
            local settingsRow = createFrame(28)
            settingsRow.Visible = autoBatDetailsOpen
            table.insert(autoBatDetailsRows, settingsRow)
            if not autoBatDetailsOpen then
                settingsRow.Size = UDim2.new(1, 0, 0, 0)
                settingsRow.BackgroundTransparency = 1
            end
            createTextLabel(settingsRow, "BAT AIMBOT Speed")
            autoBatSpeedBox = createTextBox(settingsRow, AUTO_BAT_SPEED, 50, 56, function(inputValue)
                if inputValue >= 1 and inputValue <= 250 then
                    AUTO_BAT_SPEED = inputValue
                    saveConfig()
                elseif autoBatSpeedBox then
                    autoBatSpeedBox.Text = tostring(AUTO_BAT_SPEED)
                end
            end)
        end

        do
            local settingsRow = createFrame(28)
            settingsRow.Visible = autoBatDetailsOpen
            table.insert(autoBatDetailsRows, settingsRow)
            if not autoBatDetailsOpen then
                settingsRow.Size = UDim2.new(1, 0, 0, 0)
                settingsRow.BackgroundTransparency = 1
            end
            createTextLabel(settingsRow, "Lagger BAT AIMBOT Speed")
            laggerAutoBatSpeedBox = createTextBox(settingsRow, LAGGER_AUTO_BAT_SPEED, 50, 56, function(inputValue)
                if inputValue >= 1 and inputValue <= 250 then
                    LAGGER_AUTO_BAT_SPEED = inputValue
                    saveConfig()
                elseif laggerAutoBatSpeedBox then
                    laggerAutoBatSpeedBox.Text = tostring(LAGGER_AUTO_BAT_SPEED)
                end
            end)
        end

        featureHelperZ("Auto Movement")

        autoLeftSetVisual = featureHelperAH("Auto Left", KB.AutoLeft, function(inputValue)
            autoLeftEnabled = inputValue

            if inputValue then
                queueAutoLeftStart()
            else
                stopAutoLeft()
            end
        end, function(gp, inputValue)
            if inputValue then
                KB.AutoLeft.gp = gp
                KB.AutoLeft.kb = nil
            else
                KB.AutoLeft.kb = gp
                KB.AutoLeft.gp = nil
            end

            saveConfig()
        end)

        autoRightSetVisual = featureHelperAH("Auto Right", KB.AutoRight, function(inputValue)
            autoRightEnabled = inputValue

            if inputValue then
                queueAutoRightStart()
            else
                stopAutoRight()
            end
        end, function(gp, inputValue)
            if inputValue then
                KB.AutoRight.gp = gp
                KB.AutoRight.kb = nil
            else
                KB.AutoRight.kb = gp
                KB.AutoRight.gp = nil
            end

            saveConfig()
        end)

        featureHelperZ("Drop")
        local settingsSection = createFrame(28)
        createTextLabel(settingsSection, "Drop")

        createTextButton(settingsSection, KB.DropBrainrot, function(gp, inputValue)
            if inputValue then
                KB.DropBrainrot.gp = gp
                KB.DropBrainrot.kb = nil
            else
                KB.DropBrainrot.kb = gp
                KB.DropBrainrot.gp = nil
            end

            saveConfig()
        end)

        setBuildTab("Keybind")
        local instaResetKeyRow = createFrame(28)
        createTextLabel(instaResetKeyRow, "Insta Reset")
        createTextButton(instaResetKeyRow, KB.InstaReset, function(key, isGamepad)
            local conflictsWithRoute = isGamepad
                and (key == KB.AutoLeft.gp or key == KB.AutoRight.gp)
                or not isGamepad and (key == KB.AutoLeft.kb or key == KB.AutoRight.kb)
            if conflictsWithRoute then
                if refreshAllKeyButtons then refreshAllKeyButtons() end
                warn("KAIRNOX DUELS: Insta Reset cannot share a key with Auto Left/Right.")
                return
            end
            if isGamepad then
                KB.InstaReset.gp = key
                KB.InstaReset.kb = nil
            else
                KB.InstaReset.kb = key
                KB.InstaReset.gp = nil
            end
            instaResetKeyConfigured = true
            instaResetKeyConflictDetected = false
            saveConfig()
        end)

        local floatKeyRow = createFrame(28)
        createTextLabel(floatKeyRow, "Float Toggle")
        createTextButton(floatKeyRow, KB.Float, function(key, isGamepad)
            if isGamepad then
                KB.Float.gp = key
                KB.Float.kb = nil
            else
                KB.Float.kb = key
                KB.Float.gp = nil
            end
            saveConfig()
        end)
        setBuildTab("Steal")
        dropBrainrotSelector = _G.__LustCreateToggleSelector(
            settingsSection,
            (dropBrainrotMode == "Fling") and 1 or 2,
            { "Fling", "Jump Drop" },
            function(idx, value)
                dropBrainrotMode = value
                saveConfig()
            end,
            102,
            { "Fling", "Jump Drop" }
        )

        local dropContainer, dropDot, dropStroke = featureHelperAB(settingsSection, 28)
        local dropActionBtn = Instance.new("TextButton", dropContainer)
        dropActionBtn.Size = UDim2.new(1, 0, 1, 0)
        dropActionBtn.BackgroundTransparency = 1
        dropActionBtn.Text = ""
        dropActionBtn.ZIndex = 5

        trackLustConnection(dropActionBtn.Activated:Connect(function()
            if isKeybindLocked() then return end
            LustFlash("drop")
            featureHelperB()
        end))

        table.insert(LustSync.drop, function(state)
            featureHelperAC(dropDot, dropStroke, state)
        end)

        featureHelperZ("Teleport")

        setAutoTPVisual = featureHelperAD("Auto TP", function(inputValue)
            if inputValue and isCountdownCounterBlocked and isCountdownCounterBlocked() then
                autoTPEnabled = false

                task.defer(function()
                    if setAutoTPVisual then
                        setAutoTPVisual(false)
                    end
                end)

                return
            end

            autoTPEnabled = inputValue

            if inputValue then
                startAutoTeleport()
            else
                stopAutoTeleport()
            end

            saveConfig()
        end)

        local detailsPanel = createFrame(28)
        createTextLabel(detailsPanel, "Auto TP Height")

        autoTPHeightBox = createTextBox(detailsPanel, autoTPHeight, 50, 56, function(inputValue)
            if inputValue >= 0 and inputValue <= 50 then
                autoTPHeight = inputValue
            else
                autoTPHeightBox.Text = tostring(autoTPHeight)
            end

            saveConfig()
        end)

        local toggleIndicator = createFrame(28)
        createTextLabel(toggleIndicator, "TP Down")

        createTextButton(toggleIndicator, KB.TPFloor, function(gp, inputValue)
            if inputValue then
                KB.TPFloor.gp = gp
                KB.TPFloor.kb = nil
            else
                KB.TPFloor.kb = gp
                KB.TPFloor.gp = nil
            end

            saveConfig()
        end)

        local tpDownContainer, tpDownDot, tpDownStroke = featureHelperAB(toggleIndicator, 28)
        local tpDownActionBtn = Instance.new("TextButton", tpDownContainer)
        tpDownActionBtn.Size = UDim2.new(1, 0, 1, 0)
        tpDownActionBtn.BackgroundTransparency = 1
        tpDownActionBtn.Text = ""
        tpDownActionBtn.ZIndex = 5

        trackLustConnection(tpDownActionBtn.Activated:Connect(function()
            if isKeybindLocked() then return end
            LustFlash("tpdown")
            featureHelperC()
        end))

        table.insert(LustSync.tpdown, function(state)
            featureHelperAC(tpDownDot, tpDownStroke, state)
        end)

        featureHelperZ("Movement", "Speed")

        do
            local expandableSection = createFrame(28)
            createTextLabel(expandableSection, "Infinite Jump")
            local actionContainer, layoutValue, scaleController = featureHelperAB(expandableSection, 28)
            local isActive = false

            local function featureHelperAI(inputValue)
                isActive = inputValue
                featureHelperAC(layoutValue, scaleController, inputValue)
            end

            setInfJumpVisual = featureHelperAI
            local detailControl = Instance.new("TextButton", actionContainer)
            detailControl.Size = UDim2.new(1, 0, 1, 0)
            detailControl.BackgroundTransparency = 1
            detailControl.Text = ""
            detailControl.ZIndex = 5

            trackLustConnection(detailControl.Activated:Connect(function()
                if isKeybindLocked() then
                    return
                end
                isActive = not isActive
                featureHelperAI(isActive)
                featureHelperA(isActive)
            end))
        end

        featureHelperZ("Defense", "Visuals")
        setFloatVisual = featureHelperAD("Float", function(inputValue)
            LustFloatSet(inputValue)
        end)
        table.insert(LustSync.float, function(state)
            if setFloatVisual then
                setFloatVisual(state == true)
            end
        end)

        local antiRagRow
        setAntiRagVisual, antiRagRow = featureHelperAD("Anti Ragdoll", function(inputValue)
            antiRagdollEnabled = inputValue

            if inputValue then
                startAntiRagdoll()
            else
                stopAntiRagdoll()
            end
        end)

        antiRagdollSelector = _G.__LustCreateToggleSelector(
            antiRagRow,
            (antiRagdollMode == "Purge") and 1 or 2,
            { "Purge", "Recover" },
            function(idx, value)
                antiRagdollMode = value
                if antiRagdollEnabled then
                    stopAntiRagdoll()
                    startAntiRagdoll()
                end
                saveConfig()
            end,
            52,
            { "Purge", "Recover" }
        )

        setUnwalkVisual = featureHelperAD("Unwalk", function(inputValue)
            unwalkEnabled = inputValue

            if inputValue then
                pcall(disableWalkAnimation)
            else
                pcall(restoreWalkAnimation)
            end
        end)

        do
            local expandableSection = createFrame(32)
            createTextLabel(expandableSection, "ESP")
            espArrowButton = Instance.new("TextButton", expandableSection)
            espArrowButton.Size = UDim2.new(0, 30, 0, 22)
            espArrowButton.Position = UDim2.new(1, -84, 0.5, -11)
            featureHelperAA(espArrowButton)
            espArrowButton.Text = espDetailsOpen and AUTO_BAT_ARROW_OPEN or AUTO_BAT_ARROW_CLOSED
            espArrowButton.TextColor3 = textColor
            espArrowButton.Font = Enum.Font.GothamBlack
            espArrowButton.TextSize = 13
            espArrowButton.ZIndex = 6
            espArrowButton.AutoButtonColor = false
            Instance.new("UICorner", espArrowButton).CornerRadius = UDim.new(0, 7)
            local actionContainer, layoutValue, scaleController = featureHelperAB(expandableSection, 28)
            local isActive = false

            local function featureHelperAI(inputValue)
                isActive = inputValue
                espEnabled = inputValue
                featureHelperAC(layoutValue, scaleController, inputValue)
            end

            setESPVisual = featureHelperAI
            local toggleButton = Instance.new("TextButton", actionContainer)
            toggleButton.Size = UDim2.new(1, 0, 1, 0)
            toggleButton.BackgroundTransparency = 1
            toggleButton.Text = ""
            toggleButton.ZIndex = 5

            trackLustConnection(toggleButton.Activated:Connect(function()
                if isKeybindLocked() then
                    return
                end
                isActive = not isActive
                featureHelperAI(isActive)
                refreshESP()
                saveConfig()
            end))
        end

        trackLustConnection(espArrowButton.Activated:Connect(function()
            espDetailsOpen = not espDetailsOpen
            espArrowButton.Text = espDetailsOpen and AUTO_BAT_ARROW_OPEN or AUTO_BAT_ARROW_CLOSED

            for _, expandableSection in ipairs(espDetailsRows) do
                if espDetailsOpen then
                    expandableSection.Visible = true
                    expandableSection.Size = UDim2.new(1, 0, 0, 0)
                    expandableSection.BackgroundTransparency = 1
                    TweenService:Create(
                        expandableSection,
                        TweenInfo.new(0.28, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                        { Size = UDim2.new(1, 0, 0, 32), BackgroundTransparency = 0.34 }
                    ):Play()
                else
                    TweenService:Create(
                        expandableSection,
                        TweenInfo.new(0.14, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
                        { Size = UDim2.new(1, 0, 0, 0), BackgroundTransparency = 1 }
                    ):Play()

                    task.delay(0.15, function()
                        if not espDetailsOpen and expandableSection.Parent then
                            expandableSection.Visible = false
                        end
                    end)
                end
            end
        end))

        do
            local expandableSection = createFrame(28)
            expandableSection.Visible = espDetailsOpen
            table.insert(espDetailsRows, expandableSection)

            if not espDetailsOpen then
                expandableSection.Size = UDim2.new(1, 0, 0, 0)
                expandableSection.BackgroundTransparency = 1
            end

            createTextLabel(expandableSection, "Show Tracer")
            local actionContainer, layoutValue, scaleController = featureHelperAB(expandableSection, 28)
            local isActive = false

            local function featureHelperAI(inputValue)
                isActive = inputValue
                espTracersEnabled = inputValue
                featureHelperAC(layoutValue, scaleController, inputValue)
            end

            setESPTracersVisual = featureHelperAI
            local toggleButton = Instance.new("TextButton", actionContainer)
            toggleButton.Size = UDim2.new(1, 0, 1, 0)
            toggleButton.BackgroundTransparency = 1
            toggleButton.Text = ""
            toggleButton.ZIndex = 5

            trackLustConnection(toggleButton.Activated:Connect(function()
                if isKeybindLocked() then
                    return
                end
                isActive = not isActive
                featureHelperAI(isActive)
                refreshESP()
                saveConfig()
            end))
        end

        do
            local expandableSection = createFrame(28)
            expandableSection.Visible = espDetailsOpen
            table.insert(espDetailsRows, expandableSection)

            if not espDetailsOpen then
                expandableSection.Size = UDim2.new(1, 0, 0, 0)
                expandableSection.BackgroundTransparency = 1
            end

            createTextLabel(expandableSection, "Ragdoll Countdown")
            local actionContainer, layoutValue, scaleController = featureHelperAB(expandableSection, 28)
            local isActive = false

            local function featureHelperAI(inputValue)
                isActive = inputValue
                ragdollCountdownEnabled = inputValue
                featureHelperAC(layoutValue, scaleController, inputValue)

                if inputValue then
                    ensureLocalPlayerBillboard()
                    startBatCounter()
                    setupMedusaCounter(localPlayer.Character)
                elseif not batCounterEnabled and not batCounterV3Enabled then
                    stopBatCounter()
                end

                local isReady = not inputValue

                if isReady and ragdollCountdownLabel then
                    ragdollCountdownLabel.Visible = false
                    ragdollCountdownLabel.Text = ""
                end

                if isReady and not needsMedusaDetector() then
                    stopMedusaCounter()
                end
            end

            setRagdollCountdownVisual = featureHelperAI
            local detailControl = Instance.new("TextButton", actionContainer)
            detailControl.Size = UDim2.new(1, 0, 1, 0)
            detailControl.BackgroundTransparency = 1
            detailControl.Text = ""
            detailControl.ZIndex = 5

            trackLustConnection(detailControl.Activated:Connect(function()
                if isKeybindLocked() then
                    return
                end
                isActive = not isActive
                featureHelperAI(isActive)
                saveConfig()
            end))
        end

        featureHelperZ("Counters")

        setMedusaVisual = featureHelperAD("Medusa Counter", function(inputValue)
            medusaCounterEnabled = inputValue

            if inputValue then
                setupMedusaCounter(localPlayer.Character)
            elseif not needsMedusaDetector() then
                stopMedusaCounter()
            end

            saveConfig()
        end)

        do
            local expandableSection = createFrame(40)
            createTextLabel(expandableSection, "Bat Counter")

            batCounterArrowButton = Instance.new("TextButton", expandableSection)
            batCounterArrowButton.Size = UDim2.new(0, 32, 0, 24)
            batCounterArrowButton.Position = UDim2.new(1, -80, 0.5, -12)
            featureHelperAA(batCounterArrowButton)
            batCounterArrowButton.Text = batCounterDetailsOpen and AUTO_BAT_ARROW_OPEN or AUTO_BAT_ARROW_CLOSED
            batCounterArrowButton.TextColor3 = textColor
            batCounterArrowButton.Font = Enum.Font.GothamBlack
            batCounterArrowButton.TextSize = 14
            batCounterArrowButton.ZIndex = 6
            batCounterArrowButton.AutoButtonColor = false
            Instance.new("UICorner", batCounterArrowButton).CornerRadius = UDim.new(0, 7)

            local actionContainer, layoutValue, scaleController = featureHelperAB(expandableSection, 28)
            local isActive = false

            local function featureHelperAI(inputValue)
                isActive = inputValue

                if batCounterVersion == "V1" then
                    batCounterEnabled = inputValue
                    batCounterV3Enabled = false
                else
                    batCounterEnabled = false
                    batCounterV3Enabled = inputValue
                end

                normalizeBatCounterSettings()
                featureHelperAC(layoutValue, scaleController, inputValue)

                if inputValue then
                    startBatCounter()
                    setupMedusaCounter(localPlayer.Character)
                elseif not ragdollCountdownEnabled then
                    stopBatCounter()
                end

                if not inputValue and not needsMedusaDetector() then
                    stopMedusaCounter()
                end

                updateBatCounterVersionIndicator()
            end

            setBatCounterVisual = featureHelperAI
            local toggleButton = Instance.new("TextButton", actionContainer)
            toggleButton.Size = UDim2.new(1, 0, 1, 0)
            toggleButton.BackgroundTransparency = 1
            toggleButton.Text = ""
            toggleButton.ZIndex = 5

            trackLustConnection(toggleButton.Activated:Connect(function()
                if isKeybindLocked() then return end
                featureHelperAI(not isActive)
                saveConfig()
            end))

            trackLustConnection(batCounterArrowButton.Activated:Connect(function()
                batCounterDetailsOpen = not batCounterDetailsOpen
                batCounterArrowButton.Text = batCounterDetailsOpen and AUTO_BAT_ARROW_OPEN or AUTO_BAT_ARROW_CLOSED

                for _, detailsRow in ipairs(batCounterDetailsRows) do
                    if batCounterDetailsOpen then
                        detailsRow.Visible = true
                        detailsRow.Size = UDim2.new(1, 0, 0, 0)
                        detailsRow.BackgroundTransparency = 1
                        TweenService:Create(
                            detailsRow,
                            TweenInfo.new(0.28, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                            { Size = UDim2.new(1, 0, 0, 38), BackgroundTransparency = 0.34 }
                        ):Play()
                    else
                        TweenService:Create(
                            detailsRow,
                            TweenInfo.new(0.14, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
                            { Size = UDim2.new(1, 0, 0, 0), BackgroundTransparency = 1 }
                        ):Play()

                        task.delay(0.15, function()
                            if not batCounterDetailsOpen and detailsRow.Parent then
                                detailsRow.Visible = false
                            end
                        end)
                    end
                end
            end))

            local sectionContainer = createFrame(38)
            sectionContainer.Visible = batCounterDetailsOpen
            table.insert(batCounterDetailsRows, sectionContainer)

            if not batCounterDetailsOpen then
                sectionContainer.Size = UDim2.new(1, 0, 0, 0)
                sectionContainer.BackgroundTransparency = 1
            end

            createTextLabel(sectionContainer, "Counter Version")
            local detailControl = Instance.new("Frame", sectionContainer)
            detailControl.Size = UDim2.new(0, 130, 0, 24)
            detailControl.Position = UDim2.new(1, -138, 0.5, -12)
            detailControl.BackgroundTransparency = 1
            detailControl.BorderSizePixel = 0
            detailControl.ClipsDescendants = false
            detailControl.ZIndex = 5
            batCounterVersionHighlight = Instance.new("Frame", detailControl)
            local amount = batCounterVersion == "V1" and 0 or 1
            batCounterVersionHighlight.Size = UDim2.new(0.5, -6, 1, -4)
            batCounterVersionHighlight.Position = UDim2.new(amount / 2, amount * 2 + 1, 0, 2)
            batCounterVersionHighlight.BackgroundColor3 = tertiaryColor
            batCounterVersionHighlight.BackgroundTransparency = 0.08
            batCounterVersionHighlight.BorderSizePixel = 0
            batCounterVersionHighlight.ZIndex = 6
            Instance.new("UICorner", batCounterVersionHighlight).CornerRadius = UDim.new(0, 6)

            local function createTextButton2(labelText, inputValue, secondaryInput)
                local modeButton = Instance.new("TextButton", detailControl)
                modeButton.Size = UDim2.new(0.5, -4, 1, 0)
                modeButton.Position = UDim2.new(secondaryInput / 2, secondaryInput * 2, 0, 0)
                modeButton.BackgroundTransparency = 1
                modeButton.Text = labelText
                modeButton.TextColor3 = textColor
                modeButton.TextSize = 10
                modeButton.Font = Enum.Font.GothamBlack
                modeButton.ZIndex = 7
                modeButton.AutoButtonColor = false
                Instance.new("UICorner", modeButton).CornerRadius = UDim.new(0, 7)
                local secondaryControl = Instance.new("UIStroke", modeButton)
                secondaryControl.Color = panelColor
                secondaryControl.Thickness = 1
                secondaryControl.Transparency = 0.52
                secondaryControl.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

                trackLustConnection(modeButton.Activated:Connect(function()
                    batCounterVersion = inputValue

                    if isActive then
                        featureHelperAI(true)
                    else
                        normalizeBatCounterSettings()
                    end

                    updateBatCounterVersionIndicator()
                    saveConfig()
                end))
            end

            createTextButton2("V1", "V1", 0)
            createTextButton2("V2", "V3", 1)

            detailControl.Visible = false
            local _, refreshPill = createLustPillSelector(
                sectionContainer,
                98,
                { "V1", "V2" },
                function() return batCounterVersion == "V3" and 2 or 1 end,
                function(idx, value)
                    batCounterVersion = (idx == 2) and "V3" or "V1"

                    if isActive then
                        featureHelperAI(true)
                    else
                        normalizeBatCounterSettings()
                    end

                    updateBatCounterVersionIndicator()
                    saveConfig()
                end
            )
            batCounterPillRefresh = refreshPill
        end

        updateBatCounterVersionIndicator()

        do
            local skinBatRow = createFrame(38)
            createTextLabel(skinBatRow, "Skin Bat")
            local _, refreshSkinPill = createLustPillSelector(
                skinBatRow,
                132,
                { "None", "Katana MVP" },
                function() return skinBatMode == "Katana MVP" and 2 or 1 end,
                function(_, value)
                    setSkinBatMode(value)
                    saveConfig()
                end,
                { "None", "Katana MVP" }
            )
            refreshSkinBatSelector = refreshSkinPill
        end

        featureHelperZ("Visuals")

        do
            local skinChangerRow = createFrame(38)
            createTextLabel(skinChangerRow, "SKIN CHANGLER")
            local _, refreshSkin = createLustPillSelector(
                skinChangerRow,
                140,
                MEDUSA_SKIN_OPTIONS,
                function()
                    local shown = medusaSkinMode == "GoldenDesertEagle" and "Golden Eagle" or medusaSkinMode
                    for index, value in ipairs(MEDUSA_SKIN_OPTIONS) do
                        if value == shown then return index end
                    end
                    return 1
                end,
                function(_, value)
                    setMedusaSkin(value == "Golden Eagle" and "GoldenDesertEagle" or value)
                    saveConfig()
                end
            )
            refreshSkinChangerSelector = refreshSkin
        end

        do
            local animationsRow = createFrame(38)
            createTextLabel(animationsRow, "Animaciones")
            local animationOptions = {}
            for _, entry in ipairs(ANIM_PACK_ORDER) do
                table.insert(animationOptions, entry[2])
            end
            local animationPill, refreshAnimation = createLustPillSelector(
                animationsRow,
                174,
                animationOptions,
                function()
                    for index, name in ipairs(animationOptions) do
                        if name == currentAnimPack then return index end
                    end
                    return 1
                end,
                function(_, packName)
                    if packName == "Off" then stopAnimPack() else startAnimPack(packName) end
                    saveConfig()
                end
            )
            local animationLabel = animationPill:FindFirstChildWhichIsA("TextLabel")
            if animationLabel then animationLabel.TextSize = 9 end
            refreshAnimSelector = refreshAnimation
        end

        featureHelperZ("Performance")

        setAntiLagVisual = featureHelperAD("Anti Lag", function(inputValue)
            if inputValue then
                enableAntiLag()
            else
                disableAntiLag()
            end

            saveConfig()
        end)

        setStretchRezVisual = featureHelperAD("Strech Res", function(inputValue)
            if inputValue then
                featureHelperF()
            else
                featureHelperG()
            end

            saveConfig()
        end)

        setFovVisual = featureHelperAD("FOV Change", function(inputValue)
            if inputValue then
                if stretchRezEnabled then
                    featureHelperG()

                    if setStretchRezVisual then
                        setStretchRezVisual(false)
                    end
                end

                featureHelperD()
            else
                featureHelperE()
            end

            saveConfig()
        end)

        local expandableSection = createFrame(28)
        createTextLabel(expandableSection, "FOV Value")

        fieldOfViewBox = createTextBox(expandableSection, fieldOfView, 50, 56, function(inputValue)
            if inputValue >= 40 and inputValue <= 120 then
                fieldOfView = inputValue
                applyFieldOfView()

                if stretchRezEnabled and workspace.CurrentCamera then
                    workspace.CurrentCamera.FieldOfView = fieldOfView
                end
            else
                fieldOfViewBox.Text = tostring(fieldOfView)
            end

            saveConfig()
        end)

        do
            local amount = 65
            local actionContainer = 65
            local currentCamera = workspace.CurrentCamera
            currentCamera = currentCamera and currentCamera.ViewportSize or Vector2.new(1280, 720)
            local x = currentCamera.X
            local y = currentCamera.Y

            local function featureHelperAI()
                for _, layoutValue in ipairs(qaFrames) do
                    local uiScale = layoutValue:FindFirstChildOfClass("UIScale")

                    if uiScale then
                        uiScale.Scale = floatingButtonsScale / 100
                    end
                end
            end

            local function featureHelperAJ(inputValue, secondaryInput)
                local isActive = false
                local calculatedValue = 0
                local secondaryAmount = 0
                local remainingAmount = 0
                local progress = 0

                local function featureHelperAK()
                    if not isActive then
                        return
                    end
                    isActive = false
                    saveConfig()
                end

                local function featureHelperAL(input)
                    if qaLocked then
                        return
                    end

                    if
                        input.UserInputType ~= Enum.UserInputType.Touch
                        and input.UserInputType ~= Enum.UserInputType.MouseButton1
                    then
                        return
                    end
                    isActive = true
                    calculatedValue = input.Position.X
                    secondaryAmount = input.Position.Y
                    remainingAmount = inputValue.Position.X.Offset
                    progress = inputValue.Position.Y.Offset
                end

                local function featureHelperAM(input)
                    if not isActive or qaLocked then
                        return
                    end

                    if
                        input.UserInputType ~= Enum.UserInputType.Touch
                        and input.UserInputType ~= Enum.UserInputType.MouseMovement
                    then
                        return
                    end
                    local viewportSize = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize
                        or Vector2.new(x, y)
                    local absoluteSize = inputValue.AbsoluteSize
                    local horizontalAmount = math.clamp(
                        remainingAmount + input.Position.X - calculatedValue,
                        0,
                        viewportSize.X - absoluteSize.X
                    )
                    local verticalAmount =
                        math.clamp(progress + input.Position.Y - secondaryAmount, 0, viewportSize.Y - absoluteSize.Y)
                    inputValue.Position = UDim2.new(0, horizontalAmount, 0, verticalAmount)
                end

                local function featureHelperAN(input)
                    if
                        input.UserInputType ~= Enum.UserInputType.Touch
                        and input.UserInputType ~= Enum.UserInputType.MouseButton1
                    then
                        return
                    end
                    featureHelperAK()
                end

                trackLustConnection(inputValue.InputBegan:Connect(featureHelperAL))
                trackLustConnection(inputValue.InputChanged:Connect(featureHelperAM))
                trackLustConnection(inputValue.InputEnded:Connect(featureHelperAN))

                if secondaryInput then
                    trackLustConnection(secondaryInput.InputBegan:Connect(featureHelperAL))
                    trackLustConnection(secondaryInput.InputChanged:Connect(featureHelperAM))
                    trackLustConnection(secondaryInput.InputEnded:Connect(featureHelperAN))
                end

                trackLustConnection(UserInputService.InputChanged:Connect(function(input)
                    if isActive and not qaLocked then
                        featureHelperAM(input)
                    end
                end))

                trackLustConnection(UserInputService.InputEnded:Connect(function(input)
                    if
                        input.UserInputType == Enum.UserInputType.Touch
                        or input.UserInputType == Enum.UserInputType.MouseButton1
                    then
                        featureHelperAK()
                    end
                end))
            end

            local function featureHelperAK(labelText, inputValue, secondaryInput)
                local rowContainer = Instance.new("Frame", screenGui)
                rowContainer.AnchorPoint = Vector2.new(0.5, 0.5)
                rowContainer.Size = UDim2.new(0, amount, 0, actionContainer)
                rowContainer.Position = UDim2.new(0, inputValue + amount / 2, 0, secondaryInput + actionContainer / 2)
                rowContainer.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
                rowContainer.BackgroundTransparency = 0
                rowContainer.BorderSizePixel = 0
                rowContainer.ZIndex = 30
                rowContainer.Active = true
                rowContainer.ClipsDescendants = true
                rowContainer.Visible = showMobileButtons
                Instance.new("UICorner", rowContainer).CornerRadius = UDim.new(0, 18)

                -- Máscara redondeada para imitar los botones negros de la referencia.
                local roundedMask = Instance.new("CanvasGroup", rowContainer)
                roundedMask.Name = "RoundedVisualMask"
                roundedMask.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
                roundedMask.BackgroundTransparency = 1
                roundedMask.BorderSizePixel = 0
                roundedMask.Size = UDim2.fromScale(1, 1)
                roundedMask.ClipsDescendants = true
                roundedMask.ZIndex = 31
                Instance.new("UICorner", roundedMask).CornerRadius = UDim.new(0, 18)

                local uiScale = Instance.new("UIScale", rowContainer)
                uiScale.Scale = floatingButtonsScale / 100
                local layoutValue = applyPurpleGradient(rowContainer, 90, false)
                layoutValue.Color = ColorSequence.new(Color3.fromRGB(255, 255, 255), Color3.fromRGB(255, 255, 255))
                local toggleButton = Instance.new("TextButton", roundedMask)
                toggleButton.Size = UDim2.new(1, 0, 1, 0)
                toggleButton.BackgroundTransparency = 1
                toggleButton.Text = labelText
                toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
                toggleButton.Font = Enum.Font.GothamBlack
                toggleButton.TextSize = 9
                toggleButton.TextWrapped = true
                toggleButton.TextStrokeTransparency = 1
                toggleButton.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                toggleButton.ZIndex = 32
                toggleButton.AutoButtonColor = false

                trackLustConnection(toggleButton.InputBegan:Connect(function(input)
                    if
                        input.UserInputType == Enum.UserInputType.Touch
                        or input.UserInputType == Enum.UserInputType.MouseButton1
                    then
                        local animationProperties = { Scale = floatingButtonsScale / 100 * 0.92 }
                        TweenService:Create(
                            uiScale,
                            TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                            animationProperties
                        ):Play()
                    end
                end))

                trackLustConnection(toggleButton.InputEnded:Connect(function(input)
                    if
                        input.UserInputType == Enum.UserInputType.Touch
                        or input.UserInputType == Enum.UserInputType.MouseButton1
                    then
                        local animationProperties = { Scale = floatingButtonsScale / 100 }
                        TweenService:Create(
                            uiScale,
                            TweenInfo.new(0.16, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
                            animationProperties
                        ):Play()
                    end
                end))

                table.insert(qaFrames, rowContainer)
                table.insert(qaDefaultPos, { inputValue + amount / 2, secondaryInput + actionContainer / 2 })
                featureHelperAJ(rowContainer, toggleButton)
                return rowContainer, toggleButton, layoutValue
            end

            local calculatedValue = math.max(12, x - amount * 2 - 10 - 14)
            local secondaryAmount = math.floor(y / 2 - (actionContainer * 5 + 40) / 2)

            local function featureHelperAL(inputValue, secondaryInput, tertiaryInput)
                if not inputValue or not inputValue.Parent then
                    return
                end
                inputValue:SetAttribute("KairnoxThemeRole", "ActiveButton")
                inputValue:SetAttribute("KairnoxThemeActive", tertiaryInput == true)
                TweenService:Create(inputValue, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    BackgroundColor3 = tertiaryInput and currentKairnoxPalette.accent or currentKairnoxPalette.inactiveButton,
                    BackgroundTransparency = 0,
                }):Play()

                if secondaryInput then
                    secondaryInput.Enabled = tertiaryInput == true
                end

                setPurpleControlActive(inputValue, tertiaryInput)
                local toggleButton = inputValue:FindFirstChildWhichIsA("TextButton", true)

                -- pequeno "pop" al activarse (como en Yout v15)
                if tertiaryInput and not inputValue:GetAttribute("MobActive") then
                    local popScale = inputValue:FindFirstChildOfClass("UIScale")
                    if popScale then
                        local baseScale = floatingButtonsScale / 100
                        TweenService:Create(
                            popScale,
                            TweenInfo.new(0.1, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
                            { Scale = baseScale * 1.08 }
                        ):Play()
                        task.delay(0.11, function()
                            if popScale.Parent then
                                TweenService:Create(
                                    popScale,
                                    TweenInfo.new(0.14, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                                    { Scale = floatingButtonsScale / 100 }
                                ):Play()
                            end
                        end)
                    end
                end
                inputValue:SetAttribute("MobActive", tertiaryInput == true)

                if toggleButton then
                    toggleButton:SetAttribute("KairnoxThemeRole", "ActiveLabel")
                    toggleButton:SetAttribute("KairnoxThemeActive", tertiaryInput == true)
                    toggleButton.TextStrokeTransparency = 1
                    toggleButton.TextColor3 = tertiaryInput and currentKairnoxPalette.activeText or currentKairnoxPalette.text
                end
            end

            local layoutValue, scaleController, sectionContainer =
                featureHelperAK("DROP", calculatedValue, secondaryAmount)
            local configValue, statusValue, firstCandidate =
                featureHelperAK("AUTO\nLEFT", calculatedValue + amount + 10, secondaryAmount)
            local secondCandidate, thirdCandidate, fourthCandidate =
                featureHelperAK("BAT\nAIMBOT", calculatedValue, secondaryAmount + actionContainer + 10)
            local fifthCandidate, sixthCandidate, seventhCandidate =
                featureHelperAK("AUTO\nRIGHT", calculatedValue + amount + 10, secondaryAmount + actionContainer + 10)
            local eighthCandidate, ninthCandidate, tenthCandidate =
                featureHelperAK("TP\nDOWN", calculatedValue, secondaryAmount + (actionContainer + 10) * 2)
            local eleventhCandidate, twelfthCandidate, thirteenthCandidate = featureHelperAK(
                "CARRY\nSPD",
                calculatedValue + amount + 10,
                secondaryAmount + (actionContainer + 10) * 2
            )
            local fourteenthCandidate, fifteenthCandidate, sixteenthCandidate =
                featureHelperAK("LAGGER\nNORMAL", calculatedValue, secondaryAmount + (actionContainer + 10) * 3)
            local laggerButton, laggerButtonLabel, laggerButtonStroke = featureHelperAK(
                "LAGGER\nCARRY",
                calculatedValue + amount + 10,
                secondaryAmount + (actionContainer + 10) * 3
            )

            trackLustConnection(scaleController.Activated:Connect(function()
                if not qaLocked or dropActive then
                    return
                end
                LustFlash("drop")
                task.spawn(featureHelperB)
            end))

            table.insert(LustSync.drop, function(state)
                featureHelperAL(layoutValue, sectionContainer, state)
            end)

            trackLustConnection(statusValue.Activated:Connect(function()
                if not qaLocked then
                    return
                end
                local isActive = not autoLeftEnabled

                if isActive then
                    queueAutoLeftStart()
                else
                    autoLeftEnabled = false
                    stopAutoLeft()
                end

                autoLeftEnabled = isActive

                if autoLeftSetVisual then
                    autoLeftSetVisual(isActive)
                end
            end))

            trackLustConnection(thirdCandidate.Activated:Connect(function()
                if not qaLocked then
                    return
                end
                local isActive = not autoBatEnabled

                if isActive then
                    isActive = queueAutoBatStart() == true
                else
                    disableAutoBat()
                end

                if autoBatSetVisual then
                    autoBatSetVisual(isActive == true)
                end
            end))

            trackLustConnection(sixthCandidate.Activated:Connect(function()
                if not qaLocked then
                    return
                end
                local isActive = not autoRightEnabled

                if isActive then
                    queueAutoRightStart()
                else
                    autoRightEnabled = false
                    stopAutoRight()
                end

                autoRightEnabled = isActive

                if autoRightSetVisual then
                    autoRightSetVisual(isActive)
                end
            end))

            trackLustConnection(ninthCandidate.Activated:Connect(function()
                if not qaLocked then
                    return
                end
                LustFlash("tpdown")
                task.spawn(featureHelperC)
            end))

            table.insert(LustSync.tpdown, function(state)
                featureHelperAL(eighthCandidate, tenthCandidate, state)
            end)

            do
                local floatRow, floatBtn, floatGrad =
                    featureHelperAK("FLOAT", calculatedValue, secondaryAmount + (actionContainer + 10) * 4)
                trackLustConnection(floatBtn.Activated:Connect(function()
                    if not qaLocked then
                        return
                    end
                    LustFloatToggle()
                end))
                table.insert(LustSync.float, function(state)
                    featureHelperAL(floatRow, floatGrad, state == true)
                end)
            end

            do
                local instaResetRow, instaResetBtn, instaResetGrad = featureHelperAK(
                    "INSTA\nRESET",
                    calculatedValue + amount + 10,
                    secondaryAmount + (actionContainer + 10) * 4
                )
                trackLustConnection(instaResetBtn.Activated:Connect(function()
                    if not qaLocked or isKeybindLocked() then return end
                    local reset = _G.LustInstaReset
                    if not (reset and reset.Trigger) then return end
                    featureHelperAL(instaResetRow, instaResetGrad, true)
                    reset.Trigger()
                    task.delay(0.2, function()
                        if instaResetRow.Parent then featureHelperAL(instaResetRow, instaResetGrad, false) end
                    end)
                end))
            end

            trackLustConnection(twelfthCandidate.Activated:Connect(function()
                if not qaLocked then
                    return
                end
                toggleCarryMode()
                saveConfig()
            end))

            trackLustConnection(laggerButtonLabel.Activated:Connect(function()
                if not qaLocked then
                    return
                end
                featureHelperV(2)
                saveConfig()
            end))

            trackLustConnection(fifteenthCandidate.Activated:Connect(function()
                if not qaLocked then
                    return
                end
                featureHelperV(1)
                saveConfig()
            end))

            local isActive = false
            local isReady = false
            local isComplete = false
            local lastLaggerState = false
            local lastCarryState = false
            local lastSpeedState = false
            local isWaitingForInput = false

            trackLustConnection(RunService.Heartbeat:Connect(function()
                if autoLeftEnabled ~= isActive then
                    isActive = autoLeftEnabled
                    featureHelperAL(configValue, firstCandidate, isActive)
                end

                if autoRightEnabled ~= isReady then
                    isReady = autoRightEnabled
                    featureHelperAL(fifthCandidate, seventhCandidate, isReady)
                end

                if autoBatEnabled ~= isComplete then
                    isComplete = autoBatEnabled
                    featureHelperAL(secondCandidate, fourthCandidate, isComplete)
                end

                if dropActive ~= lastLaggerState then
                    lastLaggerState = dropActive
                    featureHelperAL(layoutValue, sectionContainer, lastLaggerState)
                end

                if speedMode ~= lastCarryState then
                    lastCarryState = speedMode
                    featureHelperAL(eleventhCandidate, thirteenthCandidate, lastCarryState)
                end

                local isControllerInput = laggerToggled and laggerPhase == 2
                local isCandidate = laggerToggled and laggerPhase == 1

                if isControllerInput ~= lastSpeedState then
                    lastSpeedState = isControllerInput
                    featureHelperAL(laggerButton, laggerButtonStroke, lastSpeedState)
                end

                if isCandidate ~= isWaitingForInput then
                    isWaitingForInput = isCandidate
                    featureHelperAL(fourteenthCandidate, sixteenthCandidate, isWaitingForInput)
                end
            end))

            featureHelperAI()
        end

        refreshQuickActionVisibility()
        featureHelperZ("UI Settings")
        setShowUIOnExecuteVisual = featureHelperAD("Show UI on Execute", function(inputValue)
            showUIOnExecute = inputValue
            saveConfig()
        end)

        if setShowUIOnExecuteVisual then
            setShowUIOnExecuteVisual(showUIOnExecute)
        end

        -- ===== Toggle para mostrar/ocultar el panel del Speed Bypass =====
        featureHelperZ("Speed Bypass", "Extras")
        setBuildTab("Extras")
        setShowSpeedBypassPanelVisual = featureHelperAD("Show Speed Bypass UI", function(inputValue)
            showSpeedBypassPanel = inputValue == true
            if _G.__LustSpeedBypassSetVisible then
                pcall(_G.__LustSpeedBypassSetVisible, showSpeedBypassPanel)
            end
            saveConfig()
        end)

        if setShowSpeedBypassPanelVisual then
            setShowSpeedBypassPanelVisual(showSpeedBypassPanel == true)
        end
        -- =================================================================

        featureHelperZ("Mobile UI Settings")
        colorThemeSelector = nil
        local themeRow = createFrame(28)
        local themeTitle = createTextLabel(themeRow, "Color Theme")
        themeTitle.Size = UDim2.new(0.42, 0, 1, 0)

        local themeIndex = 1
        for index, themeName in ipairs(KAIRNOX_COLOR_THEME_ORDER) do
            if themeName == currentKairnoxTheme then
                themeIndex = index
                break
            end
        end

        local themeNameLabel = Instance.new("TextLabel", themeRow)
        themeNameLabel.Name = "CurrentColorTheme"
        themeNameLabel:SetAttribute("KairnoxThemeRole", "AccentText")
        themeNameLabel.Position = UDim2.new(0.64, 0, 0, 0)
        themeNameLabel.Size = UDim2.new(0.25, 0, 1, 0)
        themeNameLabel.BackgroundTransparency = 1
        themeNameLabel.Text = KAIRNOX_COLOR_THEME_LABELS[currentKairnoxTheme] or string.upper(currentKairnoxTheme)
        themeNameLabel.TextColor3 = currentKairnoxPalette.accent
        themeNameLabel.Font = Enum.Font.GothamBlack
        themeNameLabel.TextSize = 9
        themeNameLabel.TextScaled = true
        themeNameLabel.TextXAlignment = Enum.TextXAlignment.Center
        themeNameLabel.ZIndex = 6

        local function setThemeIndexFromName(themeName)
            for index, orderedName in ipairs(KAIRNOX_COLOR_THEME_ORDER) do
                if orderedName == themeName then
                    themeIndex = index
                    themeNameLabel.Text = KAIRNOX_COLOR_THEME_LABELS[themeName] or string.upper(themeName)
                    themeNameLabel.TextColor3 = currentKairnoxPalette.accent
                    return true
                end
            end
            return false
        end

        local function createThemeArrow(buttonName, symbol, arrowPosition)
            local button = Instance.new("TextButton", themeRow)
            button.Name = buttonName
            button:SetAttribute("KairnoxThemeRole", "Surface")
            button.Size = UDim2.new(0, 22, 0, 22)
            button.AnchorPoint = Vector2.new(0.5, 0.5)
            button.Position = arrowPosition
            button.BackgroundColor3 = currentKairnoxPalette.surface
            button.BorderSizePixel = 0
            button.AutoButtonColor = false
            button.Text = symbol
            button.TextColor3 = currentKairnoxPalette.text
            button.Font = Enum.Font.GothamBlack
            button.TextSize = 14
            button.ZIndex = 8
            Instance.new("UICorner", button).CornerRadius = UDim.new(0, 6)
            local stroke = Instance.new("UIStroke", button)
            stroke:SetAttribute("KairnoxThemeRole", "AccentStroke")
            stroke.Color = currentKairnoxPalette.accent
            stroke.Transparency = 0.25
            stroke.Thickness = 1
            return button
        end

        local previousThemeButton = createThemeArrow("PreviousColorTheme", "<", UDim2.new(0.57, 0, 0.5, 0))
        local nextThemeButton = createThemeArrow("NextColorTheme", ">", UDim2.new(0.955, 0, 0.5, 0))

        local function changeColorTheme(direction)
            themeIndex = ((themeIndex - 1 + direction) % #KAIRNOX_COLOR_THEME_ORDER) + 1
            local selectedTheme = KAIRNOX_COLOR_THEME_ORDER[themeIndex]
            applyKairnoxColorTheme(selectedTheme)
            setThemeIndexFromName(selectedTheme)
            saveConfig()
        end

        trackLustConnection(previousThemeButton.MouseButton1Click:Connect(function()
            changeColorTheme(-1)
        end))
        trackLustConnection(nextThemeButton.MouseButton1Click:Connect(function()
            changeColorTheme(1)
        end))

        colorThemeSelector = {
            setByValue = function(selectedTheme)
                return setThemeIndexFromName(selectedTheme)
            end,
        }
        applyKairnoxColorTheme(currentKairnoxTheme)

        local layoutValue = createFrame(28)
        createTextLabel(layoutValue, "UI Size")

        scaleBox = createTextBox(layoutValue, uiScaleValue, 50, 56, function(inputValue)
            uiScaleValue = math.clamp(math.floor(inputValue + 0.5), 50, 125)

            if mainGuiScale then
                mainGuiScale.Scale = uiScaleValue / 100
            end

            if progressBarScale then
                progressBarScale.Scale = uiScaleValue / 100
            end

            if scaleBox then
                scaleBox.Text = tostring(uiScaleValue)
            end

            saveConfig()
        end)

        local floatingScaleRow = createFrame(28)
        createTextLabel(floatingScaleRow, "Button Scale")

        floatingScaleBox = createTextBox(floatingScaleRow, floatingButtonsScale, 50, 56, function(inputValue)
            floatingButtonsScale = math.clamp(math.floor(inputValue + 0.5), 50, 200)

            for _, scaleController in ipairs(qaFrames) do
                local sectionContainer = scaleController:FindFirstChildOfClass("UIScale")

                if sectionContainer then
                    sectionContainer.Scale = floatingButtonsScale / 100
                end
            end
            if floatingScaleBox then
                floatingScaleBox.Text = tostring(floatingButtonsScale)
            end

            saveConfig()
        end)

        setShowMobileButtonsVisual = featureHelperAD("Show Mobile Buttons", function(inputValue)
            showMobileButtons = inputValue
            refreshQuickActionVisibility()
            saveConfig()
        end)

        if setShowMobileButtonsVisual then
            setShowMobileButtonsVisual(showMobileButtons)
        end

        setLockMobileButtonsVisual = featureHelperAD("Lock Mobile Buttons", function(inputValue)
            qaLocked = inputValue == true
            if applyStealBarLockState then
                applyStealBarLockState(qaLocked)
            end
            saveConfig()
        end)

        if setLockMobileButtonsVisual then
            setLockMobileButtonsVisual(qaLocked)
        end
        if applyStealBarLockState then
            applyStealBarLockState(qaLocked)
        end

        do
            local scaleController = createFrame(28)
            local detailControl = Instance.new("TextLabel", scaleController)
            detailControl.Size = UDim2.new(1, 0, 1, 0)
            detailControl.BackgroundTransparency = 1
            detailControl.Text = "Reset Mobile Button Positions"
            detailControl.TextColor3 = Color3.fromRGB(255, 255, 255)
            detailControl.TextStrokeTransparency = 1
            detailControl.TextTransparency = 0
            detailControl.Font = Enum.Font.GothamBold
            detailControl.TextSize = 11
            detailControl.TextXAlignment = Enum.TextXAlignment.Center
            detailControl.ZIndex = 5
            detailControl.Active = false

            local toggleButton = Instance.new("TextButton", scaleController)
            toggleButton.Size = UDim2.new(1, 0, 1, 0)
            toggleButton.BackgroundTransparency = 1
            toggleButton.Text = ""
            toggleButton.ZIndex = 3
            toggleButton.Active = true
            toggleButton.AutoButtonColor = false

            local resetting = false
            trackLustConnection(toggleButton.MouseButton1Click:Connect(function()
                if resetting then return end
                resetting = true

                for i, sectionContainer in ipairs(qaFrames) do
                    if sectionContainer and sectionContainer.Parent and qaDefaultPos[i] then
                        sectionContainer.Position = UDim2.new(0, qaDefaultPos[i][1], 0, qaDefaultPos[i][2])
                    end
                end
                if progressBarContainer then
                    local touchOnly = UserInputService.TouchEnabled and not UserInputService.MouseEnabled
                    progressBarContainer.Position = UDim2.new(0.5, 0, 1, touchOnly and -54 or -48)
                end
                                local resetFrame = instaResetFloatingButton and instaResetFloatingButton:FindFirstChild("Frame")
                if resetFrame then
                    local camera = workspace.CurrentCamera
                    local width = camera and camera.ViewportSize.X or 1920
                    resetFrame.Position = UDim2.new(0, width - 70, 0, 70)
                end

                task.defer(function()
                    for i, sectionContainer in ipairs(qaFrames) do
                        if sectionContainer and sectionContainer.Parent and qaDefaultPos[i] then
                            sectionContainer.Position = UDim2.new(0, qaDefaultPos[i][1], 0, qaDefaultPos[i][2])
                        end
                    end
                    pcall(saveConfig)
                    resetting = false
                end)
            end))
        end

        trackLustConnection(UserInputService.InputBegan:Connect(function(input, gameProcessed)
            if isKeybindLocked() then
                return
            end

            if input.UserInputType == Enum.UserInputType.Keyboard then
                if UserInputService:GetFocusedTextBox() then
                    return
                end
            elseif not featureHelperAE(input) then
                return
            end

            if not featureHelperAF(input) then
                return
            end
            local keyCode = input.KeyCode
            if gameProcessed then
                return
            end
            if featureHelperAG(KB.GuiHide, keyCode) then
                featureHelperX(not primaryValue)
                return
            end

            if featureHelperAG(KB.InstaReset, keyCode) then
                if _G.LustInstaReset and _G.LustInstaReset.Trigger then _G.LustInstaReset.Trigger() end
                return
            elseif featureHelperAG(KB.Float, keyCode) then
                LustFloatToggle()
                saveConfig()
            elseif featureHelperAG(KB.LaggerToggle, keyCode) then
                toggleLaggerMode()
                saveConfig()
            elseif featureHelperAG(KB.SpeedToggle, keyCode) then
                toggleCarryMode()
                saveConfig()
            elseif featureHelperAG(KB.DropBrainrot, keyCode) then
                LustFlash("drop")
                featureHelperB()
            elseif featureHelperAG(KB.TPFloor, keyCode) then
                LustFlash("tpdown")
                featureHelperC()
            elseif featureHelperAG(KB.AutoLeft, keyCode) then
                autoLeftEnabled = not autoLeftEnabled

                if autoLeftEnabled then
                    queueAutoLeftStart()
                else
                    stopAutoLeft()
                end

                if autoLeftSetVisual then
                    autoLeftSetVisual(autoLeftEnabled)
                end
            elseif featureHelperAG(KB.AutoRight, keyCode) then
                autoRightEnabled = not autoRightEnabled

                if autoRightEnabled then
                    queueAutoRightStart()
                else
                    stopAutoRight()
                end

                if autoRightSetVisual then
                    autoRightSetVisual(autoRightEnabled)
                end
            elseif featureHelperAG(KB.AutoBat, keyCode) then
                if not autoBatEnabled then
                    local configValue = queueAutoBatStart()

                    if autoBatSetVisual then
                        autoBatSetVisual(configValue == true)
                    end
                else
                    disableAutoBat()

                    if autoBatSetVisual then
                        autoBatSetVisual(false)
                    end
                end
            end
        end))

        if primaryValue then
            featureHelperY()
        else
            primaryControl.Visible = false
            headerButton.Visible = true
            headerButton.BackgroundTransparency = 0.03
            imageLabel.TextTransparency = 0
            strokeControl.Scale = 1
            overlayControl.Transparency = 0.18
            overlayControl.Thickness = 2
        end
    end

    _savedCfg = nil

    loadConfigKeys = function()
        if not readfile then
            return
        end

        local result = nil
        local loadedLegacyConfig = false
        local configCandidates = {
            "KAIRNOX DUELS.json",
            "FR3SH.json",
            "BLEES.VS.json",
            string.char(83, 88, 55) .. ".json",
        }
        for index, configName in ipairs(configCandidates) do
            local fileExists = true
            if isfile then
                local checkOk, exists = pcall(isfile, configName)
                fileExists = checkOk and exists == true
            end
            if fileExists then
                local readOk, fileContents = pcall(readfile, configName)
                if readOk and type(fileContents) == "string" and fileContents ~= "" then
                    result = fileContents
                    loadedLegacyConfig = index > 1
                    break
                end
            end
        end
        if not result then return end

        local ok2, operationResult = pcall(function()
            return HttpService:JSONDecode(result)
        end)

        if not ok2 or type(operationResult) ~= "table" then
            return
        end
        _savedCfg = operationResult
        if loadedLegacyConfig and writefile then
            local migrationOk, migrationErr = pcall(function()
                writefile("KAIRNOX DUELS.json", HttpService:JSONEncode(operationResult))
            end)
            if not migrationOk then
                warn("[KAIRNOX DUELS] Se leyó la configuración anterior, pero no se pudo migrar: " .. tostring(migrationErr))
            end
        end
        if type(operationResult.animPack) == "string"
            and (operationResult.animPack == "Off" or ANIM_PACKS[operationResult.animPack]) then
            currentAnimPack = operationResult.animPack
        end
        if operationResult.showSpeedBypassPanel ~= nil then
            showSpeedBypassPanel = operationResult.showSpeedBypassPanel == true
        end

        local function featureHelperW(inputValue, secondaryInput)
            if type(secondaryInput) ~= "table" then
                return
            end
            inputValue.kb = nil
            inputValue.gp = nil

            if secondaryInput.kb and Enum.KeyCode[secondaryInput.kb] then
                inputValue.kb = Enum.KeyCode[secondaryInput.kb]
            end

            if secondaryInput.gp and Enum.KeyCode[secondaryInput.gp] then
                inputValue.gp = Enum.KeyCode[secondaryInput.gp]
            end
        end

        featureHelperW(KB.DropBrainrot, operationResult.dropBrainrotKey)
        featureHelperW(KB.AutoLeft, operationResult.autoLeftKey)
        featureHelperW(KB.AutoRight, operationResult.autoRightKey)
        featureHelperW(KB.AutoBat, operationResult.autoBatKey)
        featureHelperW(KB.LaggerToggle, operationResult.laggerToggleKey)
        featureHelperW(KB.TPFloor, operationResult.tpFloorKey)
        featureHelperW(KB.GuiHide, operationResult.guiHideKey)
        featureHelperW(KB.SpeedToggle, operationResult.speedToggleKey)
        featureHelperW(KB.Float, operationResult.floatKey)
        if operationResult.instaResetKeyConfigured == true then
            featureHelperW(KB.InstaReset, operationResult.instaResetKey)
            instaResetKeyConfigured = true
        else
            -- Legacy configs stored the former default H as though it were user-selected.
            KB.InstaReset.kb, KB.InstaReset.gp = nil, nil
            instaResetKeyConfigured = false
        end
        local resetKeyConflicts = (KB.InstaReset.kb ~= nil
                and (KB.InstaReset.kb == KB.AutoLeft.kb or KB.InstaReset.kb == KB.AutoRight.kb))
            or (KB.InstaReset.gp ~= nil
                and (KB.InstaReset.gp == KB.AutoLeft.gp or KB.InstaReset.gp == KB.AutoRight.gp))
        if resetKeyConflicts then
            KB.InstaReset.kb, KB.InstaReset.gp = nil, nil
            instaResetKeyConfigured = false
            instaResetKeyConflictDetected = true
            if refreshAllKeyButtons then refreshAllKeyButtons() end
        end

        local floatKeyConflicts = false
        if KB.Float.kb then
            for name, bind in pairs(KB) do
                if name ~= "Float" and bind.kb == KB.Float.kb then floatKeyConflicts = true; break end
            end
        elseif KB.Float.gp then
            for name, bind in pairs(KB) do
                if name ~= "Float" and bind.gp == KB.Float.gp then floatKeyConflicts = true; break end
            end
        end
        if floatKeyConflicts then
            KB.Float.kb, KB.Float.gp = nil, nil
            warn("KAIRNOX DUELS: Float keybind conflicted with another action and was cleared.")
        end

        if operationResult.normalSpeed then
            NS = math.clamp(tonumber(operationResult.normalSpeed) or NS, 1, 250)
        end

        if operationResult.carrySpeed then
            CS = math.clamp(tonumber(operationResult.carrySpeed) or CS, 1, 250)
        end

        local storedAutoBatSpeed = operationResult.autoBatSpeed
        if type(storedAutoBatSpeed) ~= "number" then storedAutoBatSpeed = operationResult.autoBatV2Speed end
        if type(storedAutoBatSpeed) == "number" then
            AUTO_BAT_SPEED = math.clamp(storedAutoBatSpeed, 1, 250)
        end
        local storedLaggerAutoBatSpeed = operationResult.laggerAutoBatSpeed
        if type(storedLaggerAutoBatSpeed) ~= "number" then
            storedLaggerAutoBatSpeed = operationResult.laggerAutoBatV2Speed
        end
        if type(storedLaggerAutoBatSpeed) == "number" then
            LAGGER_AUTO_BAT_SPEED = math.clamp(storedLaggerAutoBatSpeed, 1, 250)
        end

        if type(operationResult.autoStealRadius) == "number" then
            LustSteal.StealRadius = math.clamp(operationResult.autoStealRadius, 0.5, 300)
        end
        Steal.StealRadius = LustSteal.StealRadius
        updateStealRadiusUi()

        if operationResult.laggerSpeed and type(operationResult.laggerSpeed) == "number" then
            LAGGER_SPEED = math.clamp(operationResult.laggerSpeed, 1, 250)
        end

        if operationResult.laggerCarrySpeed and type(operationResult.laggerCarrySpeed) == "number" then
            LAGGER_CARRY_SPEED = math.clamp(operationResult.laggerCarrySpeed, 1, 250)
        end

        if operationResult.autoSwing ~= nil then
            autoSwingEnabled = operationResult.autoSwing == true
        else
            autoSwingEnabled = true
        end

        if operationResult.mirrorTP ~= nil then
            mirrorTPEnabled = operationResult.mirrorTP == true
        else
            mirrorTPEnabled = true
        end

        if operationResult.unwalk ~= nil then
            unwalkEnabled = operationResult.unwalk == true
        else
            unwalkEnabled = false
        end

        if operationResult.batCounterVersion == "V1" or operationResult.batCounterVersion == "V3" then
            batCounterVersion = operationResult.batCounterVersion
        else
            batCounterVersion = "V1"
        end

        normalizeBatCounterSettings()
        if operationResult.medusaSkin == "Skull" or operationResult.medusaSkin == "GoldenDesertEagle" then
            setMedusaSkin(operationResult.medusaSkin)
        else
            setMedusaSkin("Default")
        end
        if operationResult.skinBat == "Katana MVP" then
            setSkinBatMode("Katana MVP")
        else
            setSkinBatMode("None")
        end

        if operationResult.autoTPHeight and type(operationResult.autoTPHeight) == "number" then
            autoTPHeight = math.clamp(operationResult.autoTPHeight, 0, 50)
        end

        if operationResult.fieldOfView and type(operationResult.fieldOfView) == "number" then
            fieldOfView = math.clamp(operationResult.fieldOfView, 40, 120)
        end

        if operationResult.fieldOfViewEnabled ~= nil then
            fieldOfViewEnabled = operationResult.fieldOfViewEnabled == true
        end

        if operationResult.stretchRez ~= nil then
            stretchRezEnabled = operationResult.stretchRez == true
        end

        if stretchRezEnabled and fieldOfViewEnabled then
            fieldOfViewEnabled = false
        end

        if operationResult.showUIOnExecute ~= nil then
            showUIOnExecute = operationResult.showUIOnExecute == true
        else
            showUIOnExecute = true
        end

        if operationResult.showSpeedBypassPanel ~= nil then
            showSpeedBypassPanel = operationResult.showSpeedBypassPanel == true
        end

        if operationResult.showMobileButtons ~= nil then
            showMobileButtons = operationResult.showMobileButtons == true
        end

        if operationResult.qaLocked ~= nil then
            qaLocked = operationResult.qaLocked == true
            if applyStealBarLockState then
                applyStealBarLockState(qaLocked)
            end
        end

        if operationResult.uiScale and type(operationResult.uiScale) == "number" then
            uiScaleValue = math.clamp(math.floor(operationResult.uiScale + 0.5), 50, 125)
        end

        if operationResult.floatingButtonsScale and type(operationResult.floatingButtonsScale) == "number" then
            floatingButtonsScale = math.clamp(math.floor(operationResult.floatingButtonsScale + 0.5), 50, 200)
        else
            floatingButtonsScale = 100
        end

        if operationResult.espEnabled ~= nil then
            espEnabled = operationResult.espEnabled == true
        end

        if operationResult.espTracersEnabled ~= nil then
            espTracersEnabled = operationResult.espTracersEnabled == true
        end

        if operationResult.antiLag ~= nil then
            antiLagEnabled = operationResult.antiLag == true
        end

        if operationResult.ragdollCountdownEnabled ~= nil then
            ragdollCountdownEnabled = operationResult.ragdollCountdownEnabled == true
        end

        if operationResult.autoCarryEnabled ~= nil then
            autoCarryEnabled = operationResult.autoCarryEnabled == true
        end
        if operationResult.autoCarryMode == "Soft Steal" or operationResult.autoCarryMode == "On Pick Up" then
            autoCarryMode = operationResult.autoCarryMode
        end
        if operationResult.antiRagdollMode == "Purge" or operationResult.antiRagdollMode == "Recover" then
            antiRagdollMode = operationResult.antiRagdollMode
        end
        if operationResult.dropBrainrotMode == "Fling" or operationResult.dropBrainrotMode == "Jump Drop" then
            dropBrainrotMode = operationResult.dropBrainrotMode
        end
    end

    loadConfigState = function()
        local primaryValue = _savedCfg
        if not primaryValue then
            return
        end

        if type(primaryValue.colorTheme) == "string" then
            applyKairnoxColorTheme(primaryValue.colorTheme)
            if colorThemeSelector then
                colorThemeSelector.setByValue(currentKairnoxTheme, true)
            end
        end

        if normalBox then
            normalBox.Text = tostring(NS)
        end

        if carryBox then
            carryBox.Text = tostring(CS)
        end

        updateStealRadiusUi()

        if laggerBox then
            laggerBox.Text = tostring(LAGGER_SPEED)
        end

        if laggerCarryBox then
            laggerCarryBox.Text = tostring(LAGGER_CARRY_SPEED)
        end
        if autoBatSpeedBox then
            autoBatSpeedBox.Text = tostring(AUTO_BAT_SPEED)
        end
        if laggerAutoBatSpeedBox then
            laggerAutoBatSpeedBox.Text = tostring(LAGGER_AUTO_BAT_SPEED)
        end

        if setStretchRezVisual then
            setStretchRezVisual(stretchRezEnabled)
        end
        refreshAllKeyButtons()

        if setShowUIOnExecuteVisual then
            setShowUIOnExecuteVisual(showUIOnExecute)
        end

        -- Restaurar toggle Show Speed Bypass UI (persistido en KAIRNOX DUELS.json)
        if setShowSpeedBypassPanelVisual then
            setShowSpeedBypassPanelVisual(showSpeedBypassPanel == true)
        end
        if _G.__LustSpeedBypassSetVisible then
            pcall(_G.__LustSpeedBypassSetVisible, showSpeedBypassPanel == true)
        end

        if setShowMobileButtonsVisual then
            setShowMobileButtonsVisual(showMobileButtons)
        end

        if setLockMobileButtonsVisual then
            setLockMobileButtonsVisual(qaLocked)
        end
        if applyStealBarLockState then
            applyStealBarLockState(qaLocked)
        end

        refreshQuickActionVisibility()

        if autoTPHeightBox then
            autoTPHeightBox.Text = tostring(autoTPHeight)
        end

        if fieldOfViewBox then
            fieldOfViewBox.Text = tostring(fieldOfView)
        end

        if setFovVisual then
            setFovVisual(fieldOfViewEnabled)
        end

        if fieldOfViewEnabled then
            featureHelperD()
        else
            featureHelperE()
        end

        if setESPVisual then
            setESPVisual(espEnabled)
        end

        if setESPTracersVisual then
            setESPTracersVisual(espTracersEnabled)
        end

        if setRagdollCountdownVisual then
            setRagdollCountdownVisual(ragdollCountdownEnabled)
        end

        if currentAnimPack ~= "Off" then
            startAnimPack(currentAnimPack)
        end
        if refreshAnimSelector then pcall(refreshAnimSelector) end
        if refreshSkinChangerSelector then pcall(refreshSkinChangerSelector) end

        if setBatCounterVisual then
            setBatCounterVisual(primaryValue.batCounter == true)
        end

        refreshESP()

        if setAntiLagVisual then
            setAntiLagVisual(antiLagEnabled)
        end

        if antiLagEnabled then
            antiLagEnabled = false
            enableAntiLag()
        else
            disableAntiLag()
        end

        if scaleBox then
            scaleBox.Text = tostring(uiScaleValue)
        end

        if floatingScaleBox then
            floatingScaleBox.Text = tostring(floatingButtonsScale)
        end

        if mainGuiScale then
            mainGuiScale.Scale = uiScaleValue / 100
        end

        if progressBarScale then
            progressBarScale.Scale = uiScaleValue / 100
        end

        if primaryValue.qaPositions and type(primaryValue.qaPositions) == "table" then
            for i, qaPosition in ipairs(primaryValue.qaPositions) do
                if qaFrames[i] and type(qaPosition) == "table" and qaPosition[1] and qaPosition[2] then
                    qaFrames[i].Position = UDim2.new(0, qaPosition[1], 0, qaPosition[2])
                end
            end
        end

        local savedStealBarPosition = primaryValue.autoStealBarPosition
        if progressBarContainer and type(savedStealBarPosition) == "table"
            and type(savedStealBarPosition[1]) == "number"
            and type(savedStealBarPosition[2]) == "number"
            and type(savedStealBarPosition[3]) == "number"
            and type(savedStealBarPosition[4]) == "number" then
            progressBarContainer.Position = UDim2.new(
                savedStealBarPosition[1], savedStealBarPosition[2],
                savedStealBarPosition[3], savedStealBarPosition[4]
            )
        end

        for _, secondaryValue in ipairs(qaFrames) do
            local currentObject = secondaryValue:FindFirstChildOfClass("UIScale")

            if currentObject then
                currentObject.Scale = floatingButtonsScale / 100
            end
        end

        if batCounterEnabled or batCounterV3Enabled or ragdollCountdownEnabled then
            startBatCounter()
        end

        if needsMedusaDetector and needsMedusaDetector() then
            setupMedusaCounter(localPlayer.Character)
        end

        if autoCarrySetVisual then
            autoCarrySetVisual(autoCarryEnabled == true)
        end
        if autoCarrySelector then
            autoCarrySelector.setByValue(autoCarryMode, true)
        end
        if antiRagdollSelector then
            antiRagdollSelector.setByValue(antiRagdollMode, true)
        end
        if dropBrainrotSelector then
            dropBrainrotSelector.setByValue(dropBrainrotMode, true)
        end
        if autoCarryEnabled and _G.__LustAutoCarrySetEnabled then
            _G.__LustAutoCarrySetEnabled(true)
        end

        local configApplyEnv = getgenv and getgenv() or _G
        local configApplyToken = lustSessionToken
        local function configApplyActive()
            return rawget(configApplyEnv, "__LustSessionToken") == configApplyToken
        end
        task.spawn(function()
            if not configApplyActive() then return end
            local function featureHelperW(inputValue)
                if not configApplyActive() then return end
                pcall(inputValue)
            end

            featureHelperW(function()
                if primaryValue.antiRagdoll then
                    antiRagdollEnabled = true

                    if setAntiRagVisual then
                        setAntiRagVisual(true)
                    end

                    startAntiRagdoll()
                end
            end)

            if not configApplyActive() then return end
            if setUnwalkVisual then
                setUnwalkVisual(unwalkEnabled)
            end

            featureHelperW(function()
                if unwalkEnabled then
                    disableWalkAnimation()
                end
            end)

            featureHelperW(function()
                if primaryValue.infiniteJump then
                    featureHelperA(true)

                    if setInfJumpVisual then
                        setInfJumpVisual(true)
                    end
                end
            end)

            featureHelperW(function()
                if primaryValue.medusaCounter then
                    medusaCounterEnabled = true

                    if setMedusaVisual then
                        setMedusaVisual(true)
                    end

                    setupMedusaCounter(localPlayer.Character)
                end
            end)

            if not configApplyActive() then return end
            if primaryValue.laggerMode then
                laggerToggled = true
                speedMode = false
                laggerPhase = primaryValue.laggerCarryMode and 2 or 1
            elseif primaryValue.carryMode then
                speedMode = false
                toggleCarryMode()
            end

            if not configApplyActive() then return end
            refreshSpeedModeLabel()

            featureHelperW(function()
                if primaryValue.autoTPEnabled then
                    autoTPEnabled = true

                    if setAutoTPVisual then
                        setAutoTPVisual(true)
                    end

                    startAutoTeleport()
                end
            end)

            if not configApplyActive() then return end
            if setAutoSwingVisual then
                setAutoSwingVisual(autoSwingEnabled)
            end

            if setMirrorTPVisual then
                setMirrorTPVisual(mirrorTPEnabled)
            end

            featureHelperW(function()
                if primaryValue.autoBat then
                    autoBatEnabled = true

                    if autoBatSetVisual then
                        autoBatSetVisual(true)
                    end

                    queueAutoBatStart()
                end
            end)

            featureHelperW(function()
                if primaryValue.autoStealEnabled then
                    Steal.AutoStealEnabled = true

                    if setInstaGrab then
                        setInstaGrab(true)
                    end

                    startAutoSteal()
                end
            end)

            featureHelperW(function()
                if primaryValue.stretchRez then
                    stretchRezEnabled = false

                    if setStretchRezVisual then
                        setStretchRezVisual(true)
                    end

                    featureHelperF()
                end
            end)
        end)
    end
end

-- =====================================================================
-- SPEED BYPASS (KAIRNOX DUELS Bypass · visible desde UI Settings)
-- =====================================================================
do
    local oldSpeedBypassVisibility = rawget(_G, "__LustSpeedBypassSetVisible")
    if type(oldSpeedBypassVisibility) == "function" then pcall(oldSpeedBypassVisibility, false) end

    local SB = {
        enabled = false,
        autoBrainrot = false,
        power = 97000,
        mode = "PC",
        toggleKey = Enum.KeyCode.V,
        uiLocked = false,
        minimized = false,
        position = { X_Scale = 0.5, X_Offset = -100, Y_Scale = 0.5, Y_Offset = -110 },
        root = nil, frame = nil, content = nil, minimizeBtn = nil,
        enableBtn = nil, enableStroke = nil,
        autoBtn = nil, autoStroke = nil,
        pcBtn = nil, pcStroke = nil, mobileBtn = nil, mobileStroke = nil,
        powerInput = nil, keyBtn = nil, lockBtn = nil,
        lastStealState = nil,
        running = false, bomb = nil, spamThread = nil,
        connections = {},
    }

    local CONFIG_FILE = "LustBypass_Config.json"

    local C = {
        bg        = currentKairnoxPalette.window,
        rowBg     = currentKairnoxPalette.surface,
        rowBorder = currentKairnoxPalette.border,
        inputBg   = currentKairnoxPalette.input,
        button    = currentKairnoxPalette.surface,
        white     = currentKairnoxPalette.text,
        text      = currentKairnoxPalette.text,
        dim       = currentKairnoxPalette.dim,
        accent    = currentKairnoxPalette.accent,
        active    = currentKairnoxPalette.accent,
    }

    local function SaveSB()
        if not writefile then return end
        pcall(function()
            writefile(CONFIG_FILE, HttpService:JSONEncode({
                Position     = SB.position,
                PowerValue   = SB.power,
                Mode         = SB.mode,
                ToggleKey    = SB.toggleKey.Name,
                UILocked     = SB.uiLocked,
                AutoBrainrot = SB.autoBrainrot,
                Enabled      = SB.enabled,
            }))
        end)
    end

    local function LoadSB()
        if isfile and isfile(CONFIG_FILE) then
            local ok, data = pcall(function() return HttpService:JSONDecode(readfile(CONFIG_FILE)) end)
            if ok and data then
                if data.Position     then SB.position = data.Position end
                if data.PowerValue   then SB.power = data.PowerValue end
                if data.Mode         then SB.mode = data.Mode end
                if data.ToggleKey    then SB.toggleKey = Enum.KeyCode[data.ToggleKey] or Enum.KeyCode.V end
                if data.UILocked     ~= nil then SB.uiLocked = data.UILocked end
                if data.AutoBrainrot ~= nil then SB.autoBrainrot = data.AutoBrainrot end
                if data.Enabled      ~= nil then SB.enabled = data.Enabled end
            end
        end
    end
    LoadSB()

    local DEPTH = 296
    local SPAM_DELAY = 0.12

    local function buildBomb(power)
        local maintable    = {}
        local spammedtable = { {} }
        local z = spammedtable[1]
        for i = 1, DEPTH do
            local t = {}
            table.insert(z, t)
            z = t
        end
        local maxRep = math.floor(power / (DEPTH + 2))
        for i = 1, maxRep do
            table.insert(maintable, spammedtable)
        end
        return maintable
    end

    local function stopBypass()
        SB.running = false
        if SB.spamThread then
            pcall(task.cancel, SB.spamThread)
            SB.spamThread = nil
        end
        SB.bomb = nil
    end

    local function startBypass(power)
        stopBypass()
        -- El bypass solo funciona si el menu "Speed Bypass UI" esta visible
        if showSpeedBypassPanel ~= true then return end
        SB.running = true
        SB.bomb = buildBomb(power)
        SB.spamThread = task.spawn(function()
            while SB.running do
                if SB.bomb then
                    pcall(function()
                        game.RobloxReplicatedStorage.SetPlayerBlockList:FireServer(SB.bomb)
                    end)
                end
                task.wait(SPAM_DELAY)
            end
        end)
    end

    -- Limpieza de gui viejo del bypass (re-ejecución)
    for _, parent in ipairs({ game:GetService("CoreGui"), localPlayer:FindFirstChild("PlayerGui") }) do
        if parent then
            for _, child in ipairs(parent:GetChildren()) do
                if child:IsA("ScreenGui") and (child.Name == "KAIRNOX DUELS Bypass" or child.Name == "LustSpeedBypass") then
                    pcall(function() child:Destroy() end)
                end
            end
        end
    end

    local sbGui = Instance.new("ScreenGui")
    sbGui.Name = "KAIRNOX DUELS Bypass"
    sbGui.ResetOnSpawn = false
    sbGui.IgnoreGuiInset = true
    sbGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    sbGui.DisplayOrder = 900
    pcall(function() sbGui.Parent = game:GetService("CoreGui") end)
    if not sbGui.Parent then
        sbGui.Parent = localPlayer:WaitForChild("PlayerGui")
    end

    local Root = Instance.new("Frame")
    Root.Name = "Root"
    Root.Active = true
    Root.BackgroundTransparency = 1
    Root.BorderSizePixel = 0
    Root.Position = UDim2.new(SB.position.X_Scale, SB.position.X_Offset,
                              SB.position.Y_Scale, SB.position.Y_Offset)
    Root.Size = UDim2.new(0, 240, 0, 260)
    Root.ClipsDescendants = true
    Root.Visible = false
    Root.Parent = sbGui
    SB.root = Root

    local Frame = Instance.new("Frame")
    Frame.Name = "Panel"
    Frame:SetAttribute("KairnoxThemeRole", "Window")
    Frame.BackgroundColor3 = C.bg
    Frame.BackgroundTransparency = 0
    Frame.BorderSizePixel = 0
    Frame.ClipsDescendants = true
    Frame.Position = UDim2.new(0, 60, 0, 0)
    Frame.Size = UDim2.new(0, 180, 0, 260)
    Frame.Parent = Root
    SB.frame = Frame

    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 14)
    local MainStroke = Instance.new("UIStroke", Frame)
    MainStroke:SetAttribute("KairnoxThemeRole", "AccentStroke")
    MainStroke.Color = C.rowBorder
    MainStroke.Thickness = 1

    local Header = Instance.new("Frame")
    Header:SetAttribute("KairnoxThemeRole", "Surface")
    Header.Size = UDim2.new(1, 0, 0, 40)
    Header.BackgroundColor3 = C.rowBg
    Header.BackgroundTransparency = 0.35
    Header.BorderSizePixel = 0
    Header.ZIndex = 2
    Header.Parent = Frame
    Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 14)

    local HeaderGrad = Instance.new("UIGradient")
    HeaderGrad:SetAttribute("KairnoxThemeRole", "ThemeGradient")
    HeaderGrad.Rotation = 90
    HeaderGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0.00, Color3.fromRGB(34, 34, 44)),
        ColorSequenceKeypoint.new(0.55, Color3.fromRGB(20, 20, 26)),
        ColorSequenceKeypoint.new(1.00, Color3.fromRGB(12, 12, 18)),
    })
    HeaderGrad.Parent = Header

    local BrandDot = Instance.new("Frame")
    BrandDot.Size = UDim2.new(0, 8, 0, 8)
    BrandDot.Position = UDim2.new(0, 12, 0, 10)
    BrandDot:SetAttribute("KairnoxThemeRole", "Accent")
    BrandDot.BackgroundColor3 = C.accent
    BrandDot.BorderSizePixel = 0
    BrandDot.ZIndex = 5
    BrandDot.Parent = Header
    Instance.new("UICorner", BrandDot).CornerRadius = UDim.new(1, 0)
    local BrandDotStroke = Instance.new("UIStroke", BrandDot)
    BrandDotStroke.Color = Color3.fromRGB(180, 180, 200)
    BrandDotStroke.Thickness = 2
    BrandDotStroke.Transparency = 0.5

    local TitleLbl = Instance.new("TextLabel")
    TitleLbl.BackgroundTransparency = 1
    TitleLbl.Position = UDim2.new(0, 26, 0, 6)
    TitleLbl.Size = UDim2.new(1, -50, 0, 16)
    TitleLbl.ZIndex = 20
    TitleLbl.Font = Enum.Font.GothamBlack
    TitleLbl.Text = "KAIRNOX DUELS Bypass"
    TitleLbl.TextColor3 = C.white
    TitleLbl.TextSize = 12
    TitleLbl.TextXAlignment = Enum.TextXAlignment.Left
    TitleLbl.Parent = Header

    local SubLbl = Instance.new("TextLabel")
    SubLbl.BackgroundTransparency = 1
    SubLbl.Position = UDim2.new(0, 26, 0, 22)
    SubLbl.Size = UDim2.new(1, -50, 0, 12)
    SubLbl.ZIndex = 20
    SubLbl.Font = Enum.Font.GothamMedium
    SubLbl.Text = "SPEED BYPASS"
    SubLbl.TextColor3 = C.dim
    SubLbl.TextSize = 8
    SubLbl.TextXAlignment = Enum.TextXAlignment.Left
    SubLbl.Parent = Header

    local MinimizeBtn = Instance.new("TextButton")
    MinimizeBtn.BackgroundColor3 = C.button
    MinimizeBtn.BackgroundTransparency = 0.2
    MinimizeBtn.BorderSizePixel = 0
    MinimizeBtn.Position = UDim2.new(1, -30, 0, 10)
    MinimizeBtn.Size = UDim2.new(0, 20, 0, 20)
    MinimizeBtn.ZIndex = 30
    MinimizeBtn.AutoButtonColor = false
    MinimizeBtn.Font = Enum.Font.GothamBold
    MinimizeBtn.Text = "-"
    MinimizeBtn.TextColor3 = C.white
    MinimizeBtn.TextSize = 14
    MinimizeBtn.Parent = Header
    Instance.new("UICorner", MinimizeBtn).CornerRadius = UDim.new(1, 0)
    local MinStroke = Instance.new("UIStroke", MinimizeBtn)
    MinStroke.Color = C.rowBorder
    MinStroke.Thickness = 1
    MinStroke.Transparency = 0.4

    local Content = Instance.new("Frame")
    Content.BackgroundTransparency = 1
    Content.BorderSizePixel = 0
    Content.ClipsDescendants = true
    Content.Position = UDim2.new(0, 0, 0, 42)
    Content.Size = UDim2.new(1, 0, 1, -42)
    Content.ZIndex = 2
    Content.Parent = Frame
    SB.content = Content

    local function mkRow(height, yPos)
        local row = Instance.new("Frame")
        row.BackgroundColor3 = C.rowBg
        row.BackgroundTransparency = 0.70
        row.BorderSizePixel = 0
        row.Position = UDim2.new(0.05, 0, 0, yPos)
        row.Size = UDim2.new(0.9, 0, 0, height)
        row.ZIndex = 3
        row.Parent = Content
        Instance.new("UICorner", row).CornerRadius = UDim.new(0, 10)
        local s = Instance.new("UIStroke", row)
        s.Color = C.rowBorder
        s.Thickness = 1
        s.Transparency = 0.55
        return row
    end

    local function mkLabel(parent, text)
        local l = Instance.new("TextLabel")
        l.BackgroundTransparency = 1
        l.Size = UDim2.new(0.6, 0, 1, 0)
        l.Position = UDim2.new(0, 12, 0, 0)
        l.ZIndex = 4
        l.Font = Enum.Font.GothamBold
        l.Text = text
        l.TextColor3 = C.text
        l.TextSize = 10
        l.TextXAlignment = Enum.TextXAlignment.Left
        l.Parent = parent
        return l
    end

    local EnableBtn = Instance.new("TextButton")
    EnableBtn.BackgroundColor3 = C.rowBg
    EnableBtn.BackgroundTransparency = 0.70
    EnableBtn.BorderSizePixel = 0
    EnableBtn.Position = UDim2.new(0.05, 0, 0, 12)
    EnableBtn.Size = UDim2.new(0.9, 0, 0, 34)
    EnableBtn.ZIndex = 3
    EnableBtn.AutoButtonColor = false
    EnableBtn.Font = Enum.Font.GothamBold
    EnableBtn.Text = "ENABLE"
    EnableBtn.TextColor3 = C.white
    EnableBtn.TextSize = 12
    EnableBtn.Parent = Content
    Instance.new("UICorner", EnableBtn).CornerRadius = UDim.new(0, 10)
    local EnableStroke = Instance.new("UIStroke", EnableBtn)
    EnableStroke.Color = C.rowBorder
    EnableStroke.Thickness = 1
    EnableStroke.Transparency = 0.3

    local AutoRow = mkRow(30, 54)
    mkLabel(AutoRow, "Auto Brainrot")
    local AutoBtn = Instance.new("TextButton")
    AutoBtn.BackgroundColor3 = C.inputBg
    AutoBtn.BackgroundTransparency = 0.70
    AutoBtn.BorderSizePixel = 0
    AutoBtn.Position = UDim2.new(0.6, 0, 0.15, 0)
    AutoBtn.Size = UDim2.new(0.35, 0, 0.7, 0)
    AutoBtn.ZIndex = 4
    AutoBtn.AutoButtonColor = false
    AutoBtn.Font = Enum.Font.GothamBold
    AutoBtn.Text = "OFF"
    AutoBtn.TextColor3 = C.white
    AutoBtn.TextSize = 11
    AutoBtn.Parent = AutoRow
    Instance.new("UICorner", AutoBtn).CornerRadius = UDim.new(0, 6)
    local AutoStroke = Instance.new("UIStroke", AutoBtn)
    AutoStroke.Color = C.rowBorder
    AutoStroke.Thickness = 1
    AutoStroke.Transparency = 0.3

    local ModeRow = mkRow(30, 90)
    mkLabel(ModeRow, "Mode")
    local MobileBtn = Instance.new("TextButton")
    MobileBtn.BackgroundColor3 = C.inputBg
    MobileBtn.BackgroundTransparency = 0.70
    MobileBtn.BorderSizePixel = 0
    MobileBtn.Position = UDim2.new(0.6, 0, 0.15, 0)
    MobileBtn.Size = UDim2.new(0.18, 0, 0.7, 0)
    MobileBtn.ZIndex = 4
    MobileBtn.AutoButtonColor = false
    MobileBtn.Font = Enum.Font.GothamBold
    MobileBtn.Text = "Mobile"
    MobileBtn.TextColor3 = C.white
    MobileBtn.TextSize = 9
    MobileBtn.Parent = ModeRow
    Instance.new("UICorner", MobileBtn).CornerRadius = UDim.new(0, 6)
    local MobileStroke = Instance.new("UIStroke", MobileBtn)
    MobileStroke.Color = C.rowBorder
    MobileStroke.Thickness = 1
    MobileStroke.Transparency = 0.3

    local PCBtn = Instance.new("TextButton")
    PCBtn.BackgroundColor3 = C.inputBg
    PCBtn.BackgroundTransparency = 0.70
    PCBtn.BorderSizePixel = 0
    PCBtn.Position = UDim2.new(0.79, 0, 0.15, 0)
    PCBtn.Size = UDim2.new(0.18, 0, 0.7, 0)
    PCBtn.ZIndex = 4
    PCBtn.AutoButtonColor = false
    PCBtn.Font = Enum.Font.GothamBold
    PCBtn.Text = "PC"
    PCBtn.TextColor3 = C.white
    PCBtn.TextSize = 9
    PCBtn.Parent = ModeRow
    Instance.new("UICorner", PCBtn).CornerRadius = UDim.new(0, 6)
    local PCStroke = Instance.new("UIStroke", PCBtn)
    PCStroke.Color = C.rowBorder
    PCStroke.Thickness = 1
    PCStroke.Transparency = 0.3

    local PowerRow = mkRow(30, 126)
    mkLabel(PowerRow, "Power")
    local PowerInput = Instance.new("TextBox")
    PowerInput.BackgroundColor3 = C.inputBg
    PowerInput.BackgroundTransparency = 0.70
    PowerInput.BorderSizePixel = 0
    PowerInput.Position = UDim2.new(0.55, 0, 0.15, 0)
    PowerInput.Size = UDim2.new(0.4, 0, 0.7, 0)
    PowerInput.ZIndex = 4
    PowerInput.Font = Enum.Font.GothamBold
    PowerInput.Text = tostring(SB.power)
    PowerInput.TextColor3 = C.white
    PowerInput.TextSize = 12
    PowerInput.ClearTextOnFocus = false
    PowerInput.Parent = PowerRow
    Instance.new("UICorner", PowerInput).CornerRadius = UDim.new(0, 6)
    local PowerStroke = Instance.new("UIStroke", PowerInput)
    PowerStroke.Color = C.rowBorder
    PowerStroke.Thickness = 1
    PowerStroke.Transparency = 0.3

    local KeyRow = mkRow(30, 162)
    mkLabel(KeyRow, "Keybind")
    local KeyBtn = Instance.new("TextButton")
    KeyBtn.BackgroundColor3 = C.inputBg
    KeyBtn.BackgroundTransparency = 0.70
    KeyBtn.BorderSizePixel = 0
    KeyBtn.Position = UDim2.new(0.55, 0, 0.15, 0)
    KeyBtn.Size = UDim2.new(0.4, 0, 0.7, 0)
    KeyBtn.ZIndex = 4
    KeyBtn.AutoButtonColor = false
    KeyBtn.Font = Enum.Font.GothamBold
    KeyBtn.Text = SB.toggleKey.Name
    KeyBtn.TextColor3 = C.white
    KeyBtn.TextSize = 12
    KeyBtn.Parent = KeyRow
    Instance.new("UICorner", KeyBtn).CornerRadius = UDim.new(0, 6)
    local KeyStroke = Instance.new("UIStroke", KeyBtn)
    KeyStroke.Color = C.rowBorder
    KeyStroke.Thickness = 1
    KeyStroke.Transparency = 0.3

    local LockRow = mkRow(24, 198)
    LockRow.Size = UDim2.new(0.9, 0, 0, 24)
    mkLabel(LockRow, "Lock UI")
    local LockBtn = Instance.new("TextButton")
    LockBtn.BackgroundColor3 = C.inputBg
    LockBtn.BackgroundTransparency = 0.70
    LockBtn.BorderSizePixel = 0
    LockBtn.Position = UDim2.new(0.6, 0, 0.12, 0)
    LockBtn.Size = UDim2.new(0.35, 0, 0.76, 0)
    LockBtn.ZIndex = 4
    LockBtn.AutoButtonColor = false
    LockBtn.Font = Enum.Font.GothamBold
    LockBtn.Text = "UNLOCK"
    LockBtn.TextColor3 = C.white
    LockBtn.TextSize = 9
    LockBtn.Parent = LockRow
    Instance.new("UICorner", LockBtn).CornerRadius = UDim.new(0, 6)
    local LockStroke = Instance.new("UIStroke", LockBtn)
    LockStroke.Color = C.rowBorder
    LockStroke.Thickness = 1
    LockStroke.Transparency = 0.3

    local dragging, dragInput, dragStart, startPos
    trackLustConnection(Root.InputBegan:Connect(function(input)
        if SB.uiLocked then return end
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = Root.Position
            trackLustConnection(input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                    SB.position = {
                        X_Scale = Root.Position.X.Scale, X_Offset = Root.Position.X.Offset,
                        Y_Scale = Root.Position.Y.Scale, Y_Offset = Root.Position.Y.Offset
                    }
                    SaveSB()
                end
            end))
        end
    end))
    trackLustConnection(Root.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end))
    table.insert(SB.connections, trackLustConnection(UserInputService.InputChanged:Connect(function(input)
        if SB.uiLocked then return end
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            Root.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
                                      startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)))

    local function updateUIState()
        EnableBtn:SetAttribute("KairnoxThemeRole", "ActiveButton")
        EnableBtn:SetAttribute("KairnoxThemeActive", SB.enabled == true)
        AutoBtn:SetAttribute("KairnoxThemeRole", "ActiveButton")
        AutoBtn:SetAttribute("KairnoxThemeActive", SB.autoBrainrot == true)
        PCBtn:SetAttribute("KairnoxThemeRole", "ActiveButton")
        PCBtn:SetAttribute("KairnoxThemeActive", SB.mode == "PC")
        MobileBtn:SetAttribute("KairnoxThemeRole", "ActiveButton")
        MobileBtn:SetAttribute("KairnoxThemeActive", SB.mode ~= "PC")
        LockBtn:SetAttribute("KairnoxThemeRole", "ActiveButton")
        LockBtn:SetAttribute("KairnoxThemeActive", SB.uiLocked == true)
        if SB.enabled then
            EnableBtn.Text = "DISABLE"
            EnableBtn.BackgroundColor3 = C.active
            EnableBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
            EnableStroke.Color = C.active
            EnableStroke.Transparency = 0.2
        else
            EnableBtn.Text = "ENABLE"
            EnableBtn.BackgroundColor3 = C.rowBg
            EnableBtn.TextColor3 = C.white
            EnableStroke.Color = C.rowBorder
            EnableStroke.Transparency = 0.3
        end

        AutoBtn.Text = SB.autoBrainrot and "ON" or "OFF"
        if SB.autoBrainrot then
            AutoBtn.BackgroundColor3 = C.active
            AutoBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
            AutoStroke.Color = C.active
            AutoStroke.Transparency = 0.2
        else
            AutoBtn.BackgroundColor3 = C.inputBg
            AutoBtn.TextColor3 = C.white
            AutoStroke.Color = C.rowBorder
            AutoStroke.Transparency = 0.3
        end

        if SB.mode == "PC" then
            PCBtn.BackgroundColor3 = C.accent
            PCBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
            PCStroke.Color = C.accent
            PCStroke.Transparency = 0.2
            MobileBtn.BackgroundColor3 = C.inputBg
            MobileBtn.TextColor3 = C.white
            MobileStroke.Color = C.rowBorder
            MobileStroke.Transparency = 0.3
        else
            MobileBtn.BackgroundColor3 = C.accent
            MobileBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
            MobileStroke.Color = C.accent
            MobileStroke.Transparency = 0.2
            PCBtn.BackgroundColor3 = C.inputBg
            PCBtn.TextColor3 = C.white
            PCStroke.Color = C.rowBorder
            PCStroke.Transparency = 0.3
        end

        PowerInput.Text = tostring(SB.power)
        KeyBtn.Text = SB.toggleKey.Name
        LockBtn.Text = SB.uiLocked and "LOCKED" or "UNLOCK"
        if SB.uiLocked then
            LockBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 52)
            LockBtn.TextColor3 = C.accent
        else
            LockBtn.BackgroundColor3 = C.inputBg
            LockBtn.TextColor3 = C.white
        end
    end

    registerKairnoxThemeCallback(function(palette)
        C.bg = palette.window
        C.rowBg = palette.surface
        C.rowBorder = palette.border
        C.inputBg = palette.input
        C.button = palette.surface
        C.white = palette.text
        C.text = palette.text
        C.dim = palette.dim
        C.accent = palette.accent
        C.active = palette.accent
        Frame.BackgroundColor3 = C.bg
        Header.BackgroundColor3 = C.rowBg
        MainStroke.Color = palette.accent
        BrandDot.BackgroundColor3 = palette.accent
        updateUIState()
    end)

    local function setEnabled(state)
        if state and showSpeedBypassPanel ~= true then
            SB.enabled = false
            SB.autoBrainrot = false
            stopBypass()
            updateUIState()
            SaveSB()
            return false
        end
        SB.enabled = state == true
        if SB.enabled then
            startBypass(SB.power)
        else
            stopBypass()
        end
        updateUIState()
        return true
    end

    trackLustConnection(EnableBtn.MouseButton1Click:Connect(function()
        setEnabled(not SB.enabled)
        SaveSB()
    end))

    trackLustConnection(AutoBtn.MouseButton1Click:Connect(function()
        SB.autoBrainrot = not SB.autoBrainrot
        if not SB.autoBrainrot and SB.enabled then
            setEnabled(false)
        end
        updateUIState()
        SaveSB()
    end))

    trackLustConnection(PCBtn.MouseButton1Click:Connect(function()
        SB.mode = "PC"
        SB.power = 97000
        if SB.enabled then startBypass(SB.power) end
        updateUIState()
        SaveSB()
    end))

    trackLustConnection(MobileBtn.MouseButton1Click:Connect(function()
        SB.mode = "Mobile"
        SB.power = 65000
        if SB.enabled then startBypass(SB.power) end
        updateUIState()
        SaveSB()
    end))

    trackLustConnection(PowerInput.FocusLost:Connect(function()
        local val = tonumber(PowerInput.Text)
        if val then
            SB.power = math.clamp(math.floor(val + 0.5), 1, 999999)
            if SB.enabled then startBypass(SB.power) end
            SaveSB()
        end
        PowerInput.Text = tostring(SB.power)
    end))

    trackLustConnection(KeyBtn.MouseButton1Click:Connect(function()
        KeyBtn.Text = "..."
        KeyBtn.TextColor3 = Color3.fromRGB(255, 200, 100)
        local conn
        conn = trackLustConnection(UserInputService.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Keyboard then
                SB.toggleKey = input.KeyCode
                KeyBtn.Text = input.KeyCode.Name
                KeyBtn.TextColor3 = C.white
                conn:Disconnect()
                SaveSB()
            end
        end))
        table.insert(SB.connections, conn)
    end))

    trackLustConnection(LockBtn.MouseButton1Click:Connect(function()
        SB.uiLocked = not SB.uiLocked
        updateUIState()
        SaveSB()
    end))

    trackLustConnection(MinimizeBtn.MouseButton1Click:Connect(function()
        SB.minimized = not SB.minimized
        Content.Visible = not SB.minimized
        if SB.minimized then
            Root.Size  = UDim2.new(0, 240, 0, 42)
            Frame.Size = UDim2.new(0, 180, 0, 42)
            MinimizeBtn.Text = "+"
        else
            Root.Size  = UDim2.new(0, 240, 0, 260)
            Frame.Size = UDim2.new(0, 180, 0, 260)
            MinimizeBtn.Text = "-"
        end
    end))

    table.insert(SB.connections, trackLustConnection(RunService.Heartbeat:Connect(function()
        if not SB.autoBrainrot or showSpeedBypassPanel ~= true then
            SB.lastStealState = nil
            return
        end
        local char = localPlayer.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hum then return end

        local ws = hum.WalkSpeed
        local hasSteal = (ws >= 10 and ws < 25)

        if SB.lastStealState == nil then
            SB.lastStealState = hasSteal
            return
        end

        if hasSteal and not SB.lastStealState then
            SB.lastStealState = true
            if not SB.enabled then setEnabled(true) end
        elseif not hasSteal and SB.lastStealState then
            SB.lastStealState = false
            if SB.enabled then setEnabled(false) end
        end
    end)))

    table.insert(SB.connections, trackLustConnection(UserInputService.InputBegan:Connect(function(input, gp)
        if gp then return end
        if showSpeedBypassPanel ~= true then return end
        if UserInputService:GetFocusedTextBox() then return end
        if input.UserInputType == Enum.UserInputType.Keyboard then
            if input.KeyCode == SB.toggleKey then
                setEnabled(not SB.enabled)
                SaveSB()
            end
        end
    end)))

    _G.__LustSpeedBypassCleanup = function()
        SB.enabled = false
        SB.autoBrainrot = false
        stopBypass()
        for _, conn in ipairs(SB.connections) do pcall(function() conn:Disconnect() end) end
        SB.connections = {}
        for _, parent in ipairs({ game:GetService("CoreGui"), localPlayer:FindFirstChild("PlayerGui") }) do
            if parent then
                for _, name in ipairs({ "KAIRNOX DUELS Bypass", "LustSpeedBypass" }) do
                    local gui = parent:FindFirstChild(name)
                    if gui then pcall(function() gui:Destroy() end) end
                end
            end
        end
    end

    updateUIState()

    _G.__LustSpeedBypassSetVisible = function(state)
        showSpeedBypassPanel = state == true
        Root.Visible = showSpeedBypassPanel
        if showSpeedBypassPanel then
            -- al volver a mostrar el menu, reanuda el bypass si estaba activado
            if SB.enabled then startBypass(SB.power) end
        else
            -- Ocultar la UI también desactiva el bypass y la automatización para evitar estados pegados.
            SB.enabled = false
            SB.autoBrainrot = false
            stopBypass()
            SB.lastStealState = nil
            SaveSB()
        end
        updateUIState()
    end

    Root.Visible = showSpeedBypassPanel == true
    -- El estado se aplica al construir el toggle, después de cargar KAIRNOX DUELS.json.
    updateUIState()
end

showLoadingIndicator()
loadConfigKeys()

local startupEnv = getgenv and getgenv() or _G
local startupToken = lustSessionToken
local startupThread = task.spawn(function()
    if rawget(startupEnv, "__LustSessionToken") ~= startupToken then return end
    if not pcall(buildGui) then
        if rawget(startupEnv, "__LustSessionToken") == startupToken then
            hideLoadingIndicator()
        end
        return
    end
    task.wait(0.15)
    if rawget(startupEnv, "__LustSessionToken") ~= startupToken then return end
    pcall(loadConfigState)
    if rawget(startupEnv, "__LustSessionToken") ~= startupToken then return end
    isConfigReady = true
    if instaResetKeyConflictDetected then
        instaResetKeyConflictDetected = false
        pcall(saveConfig)
    end
    hideLoadingIndicator()
end)
pcall(function() rawset(startupEnv, "__LustStartupThread", startupThread) end)
pcall(function() rawset(_G, "__LustStartupThread", startupThread) end)
task.delay(8, function()
    if rawget(startupEnv, "__LustSessionToken") ~= startupToken then return end
    pcall(function()
        startupEnv._LustBootDone = true
    end)
end)