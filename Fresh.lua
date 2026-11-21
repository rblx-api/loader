-- ============================================================
-- INDICE DE SECCIONES (archivo reorganizado por funcionalidad)
--   1. SERVICIOS, ENTORNO COMPARTIDO Y CACHES LOCALES
--   2. INTRO MUSICAL Y SONIDO DE UI
--   3. TEMA Y COLORES
--   4. CONSTANTES Y ESTADO GLOBAL COMPARTIDO
--   5. COLISIONES ENTRE JUGADORES (NO PLAYER COLLISION)
--   6. SISTEMA CARRY / SOFT STEAL / LAGGER
--   7. APARIENCIA: OUTFITS, KATANA, HEADLESS Y KORBLOX
--   8. SKINS Y SONIDOS DEL BATE / MEDUSA
--   9. X-RAY (PLOTS Y BRAINROTS)
--  10. MOVIMIENTO: VELOCIDAD, SALTO INFINITO, AUTO LEFT/RIGHT Y UNWALK
--  11. PAQUETES DE ANIMACION
--  12. AUTO STEAL
--  13. ESP, VELOCIDAD ENEMIGA, BODY LOCK E INDICADOR DE VELOCIDAD
--  14. COMBATE: AIMBOT, AUTO BAT, ANTI BAT, CONTADORES, MEDUSA Y DROP
--  15. ANTI-RAGDOLL, ANTI-DIE Y ANTI-FLING
--  16. ANTI LAG
--  17. CAMARA: FOV Y STRETCH
--  18. GRAFICOS: CLIMA NEON, VIVID Y CIELO
--  19. INTERFAZ: PANEL, BOTONES FLOTANTES Y TECLAS
--  20. GUARDADO, CARGA Y RESET DE CONFIGURACION
--  21. ARRANQUE Y EVENTOS FINALES
-- ============================================================

-- ============================================================
-- 1. SERVICIOS, ENTORNO COMPARTIDO Y CACHES LOCALES
-- ============================================================
local _sharedEnv = (type(getgenv) == "function" and getgenv()) or _G

-- Limpiar el sonido de UI de la version anterior, si seguia en SoundService.
;(function()
    pcall(function()
        local soundService = game:GetService("SoundService")
        for _, soundName in ipairs({"FreshUISound", "FreshHubIntro", "FreshMusicPlayer"}) do
            local oldSound = soundService:FindFirstChild(soundName)
            if oldSound then oldSound:Stop(); oldSound:Destroy() end
        end
    end)
end)()

_freshBuildKey = "__FreshHubBuild_20261114_freshduels_slimmeter_r19"

if _sharedEnv[_freshBuildKey] then
    local existingPanelReady = false
    pcall(function()
        local coreGui = game:GetService("CoreGui")
        local existing = coreGui:FindFirstChild("HZ HUB") or coreGui:FindFirstChild("FRESH")
        if not existing then
            local playerGui = game:GetService("Players").LocalPlayer:FindFirstChild("PlayerGui")
            existing = playerGui and (playerGui:FindFirstChild("HZ HUB") or playerGui:FindFirstChild("FRESH"))
        end
        existingPanelReady = existing ~= nil and existing:FindFirstChild("PanelContent", true) ~= nil
    end)
    if existingPanelReady then
        warn("[HZ HUB] Esta version ya esta activa; no se inicio una segunda copia.")
        return
    end
    -- Si quedo el marcador pero alguien borro la GUI, permitir recuperar el arranque.
    _sharedEnv[_freshBuildKey] = nil
end

if not game:IsLoaded() then
    game.Loaded:Wait()
end

-- Limpieza de errores antiguos y del borde legado de la barra.
;(function()
    local roots = {game:GetService("CoreGui"), game:GetService("Players").LocalPlayer:FindFirstChild("PlayerGui")}
    for _, root in ipairs(roots) do
        if root then
            for _, name in ipairs({"FreshStartupError", "CuteStealBar", "StealBar", "AdaptStealBar", "AutoGrabBar", "BloodHoundsMobilePanel"}) do
                local oldGui = root:FindFirstChild(name, true)
                if oldGui then pcall(function() oldGui:Destroy() end) end
            end
        end
    end
    if _G.__FreshStealBarEdge then pcall(function() _G.__FreshStealBarEdge:Destroy() end) end
    _G.__FreshStealBarEdge = nil
end)()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local TS = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local HS = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
PhysicsService = game:GetService("PhysicsService")
local Workspace = game:GetService("Workspace")
local LP = Players.LocalPlayer
local camera = workspace.CurrentCamera

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

-- Shared UI/ESP caches must be declared before functions that reference them.
local espBoxCache = {}

local espLineCache = {}

-- Tipografia consistente: Gotham ofrece trazos limpios y alta legibilidad.
local function resolveFont(name, fallback)
    local ok, font = pcall(function() return Enum.Font[name] end)
    return (ok and font) or fallback
end

local UI_FONT       = resolveFont("Gotham", Enum.Font.Gotham)
local UI_FONT_BOLD  = resolveFont("GothamBold", Enum.Font.GothamBold)
local UI_FONT_HEAVY = resolveFont("GothamBlack", Enum.Font.GothamBlack)
local _GetPlayersCached

do
    local cache, cacheTime = nil, 0
    _GetPlayersCached = function()
        local now = _tick()
        -- La lista de jugadores cambia poco; cachearla 80 ms baja asignaciones
        -- en los recorridos por frame sin retrasar el seguimiento de posiciones.
        if cache and now - cacheTime < 0.08 then return cache end
        cache = Players:GetPlayers()
        cacheTime = now
        return cache
    end
end

local function waitForCharReady(char, timeout)
    if not char then return false end
    timeout = math.max(tonumber(timeout) or 5, 0)
    local deadline = _tick() + timeout
    if not char.Parent then
        local remaining = math.max(deadline - _tick(), 0)
        if remaining <= 0 then return false end
        local parentReady = Instance.new("BindableEvent")
        local parentConn = char.AncestryChanged:Connect(function(_, parent)
            if parent then parentReady:Fire() end
        end)
        local timeoutThread = task.delay(remaining, function() parentReady:Fire() end)
        if char.Parent then parentReady:Fire() end
        parentReady.Event:Wait()
        pcall(task.cancel, timeoutThread)
        parentConn:Disconnect()
        parentReady:Destroy()
        if not char.Parent then return false end
    end

    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then
        local remaining = math.max(deadline - _tick(), 0)
        if remaining <= 0 then return false end
        root = char:WaitForChild("HumanoidRootPart", remaining)
    end
    if not root then return false end

    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if not humanoid then
        local remaining = math.max(deadline - _tick(), 0)
        if remaining <= 0 then return false end
        local candidate = char:WaitForChild("Humanoid", remaining)
        if candidate and candidate:IsA("Humanoid") then humanoid = candidate end
    end
    return char.Parent ~= nil and root.Parent == char and humanoid ~= nil and humanoid.Parent == char
end

-- Remove old Insta Reset remnants when this build replaces a previous run.
pcall(function()
    local coreGui = game:GetService("CoreGui")
    local playerGui = LP:FindFirstChildOfClass("PlayerGui")
    for _, parent in ipairs({coreGui, playerGui}) do
        local oldButton = parent and parent:FindFirstChild("InstaResetButton")
        if oldButton then oldButton:Destroy() end
    end
end)

_G.InstaReset = nil
_G.InstaResetLoaded = nil
FRESH_NO_PLAYER_COLLISION_GROUP = "FreshNoPlayerCollision"
local CoreGui = game:GetService("CoreGui")

-- ============================================================
-- 2. INTRO MUSICAL Y SONIDO DE UI
-- ============================================================
_G.__FreshPlayUiSound = nil

-- Intro musical opcional: URL incluida por el usuario en el archivo de referencia.
_sharedEnv.__FreshIntroState = _sharedEnv.__FreshIntroState or {}

_sharedEnv.__FreshIntroState.Enabled = true
_sharedEnv.__FreshIntroState.Sound = nil
_sharedEnv.__FreshIntroState.Request = (tonumber(_sharedEnv.__FreshIntroState.Request) or 0) + 1
_sharedEnv.__FreshIntroState.Url = "https://file.garden/algLafWA1jk8WMfK/Type%20Shit_spotdown.org.mp3"
_sharedEnv.__FreshIntroState.File = "fresh_type_shit_intro.mp3"

_sharedEnv.__FreshStopIntro = function()
    local state = _sharedEnv.__FreshIntroState
    state.Request = state.Request + 1
    local sound = state.Sound
    state.Sound = nil
    if sound then
        pcall(function() sound:Stop() end)
        pcall(function() sound:Destroy() end)
    end
end

_sharedEnv.__FreshPlayIntro = function()
    local state = _sharedEnv.__FreshIntroState
    if not state.Enabled then return end
    _sharedEnv.__FreshStopIntro()
    state = _sharedEnv.__FreshIntroState
    local request = state.Request
    task.spawn(function()
        local ok, err = pcall(function()
            local assetLoader = getcustomasset or getsynasset
            assert(type(assetLoader) == "function" and type(writefile) == "function",
                "custom asset functions unavailable")
            local exists = false
            if type(isfile) == "function" then
                pcall(function() exists = isfile(state.File) == true end)
            end
            if not exists then
                local downloaded, data = pcall(function() return game:HttpGet(state.Url) end)
                assert(downloaded and type(data) == "string" and #data > 256, "intro audio download failed")
                if request ~= state.Request or not state.Enabled then return end
                local written = pcall(writefile, state.File, data)
                assert(written, "intro audio could not be saved")
            end
            if request ~= state.Request or not state.Enabled then return end
            local loaded, asset = pcall(assetLoader, state.File)
            assert(loaded and type(asset) == "string" and asset ~= "", "intro audio asset unavailable")
            if request ~= state.Request or not state.Enabled then return end

            local sound = Instance.new("Sound")
            sound.Name = "FreshHubIntro"
            sound.SoundId = asset
            sound.Volume = 0.55
            sound.Looped = false
            sound.Parent = game:GetService("SoundService")
            state.Sound = sound
            local loadStarted = os.clock()
            while sound.Parent and not sound.IsLoaded and os.clock() - loadStarted < 5 do
                if request ~= state.Request or not state.Enabled then break end
                task.wait(0.05)
            end
            if request ~= state.Request or not state.Enabled or not sound.Parent then
                if state.Sound == sound then state.Sound = nil end
                pcall(function() sound:Destroy() end)
                return
            end
            pcall(function() sound.TimePosition = 0; sound:Play() end)
            task.delay(10, function()
                if request == state.Request and state.Sound == sound then _sharedEnv.__FreshStopIntro() end
            end)
        end)
        if not ok and request == state.Request then
            warn("[FRESH Intro] No se pudo iniciar Type Shit: " .. tostring(err))
        end
    end)
end

-- ============================================================
-- 3. TEMA Y COLORES
-- ============================================================
local STEAL_BAR_COLORS = {
    WHITE = Color3.fromRGB(255, 255, 255),
    BLACK = Color3.fromRGB(8, 6, 13),
    DARK_YELLOW = Color3.fromRGB(88, 28, 135),
    LIGHT_YELLOW = Color3.fromRGB(216, 180, 254),
    TRACK = Color3.fromRGB(21, 14, 29),
    ACCENT = Color3.fromRGB(147, 51, 234),
    ACCENT_LIGHT = Color3.fromRGB(216, 180, 254),
    ACCENT_DARK = Color3.fromRGB(88, 28, 135),
    ACCENT_TEXT = Color3.fromRGB(255, 255, 255),
    WIN_BG = Color3.fromRGB(8, 6, 13),
    WIN_BG2 = Color3.fromRGB(17, 11, 24),
    TOP_BG = Color3.fromRGB(13, 9, 18),
    TOP_SUB = Color3.fromRGB(196, 181, 212),
    TAB_BG = Color3.fromRGB(16, 11, 22),
    TAB_DIV = Color3.fromRGB(54, 34, 67),
    TAB_IDLE = Color3.fromRGB(184, 169, 201),
    TAB_ACTIVE = Color3.fromRGB(255, 255, 255),
    TAB_ACTIVE_BG = Color3.fromRGB(42, 19, 58),
    TAB_UNDERLINE = Color3.fromRGB(147, 51, 234),
    SECTION_TEXT = Color3.fromRGB(192, 132, 252),
    ROW_BG = Color3.fromRGB(0, 0, 0),
    ROW_BORDER = Color3.fromRGB(67, 46, 80),
    ROW_HOVER = Color3.fromRGB(13, 8, 19),
    INPUT_BG = Color3.fromRGB(14, 10, 19),
    INPUT_BORDER = Color3.fromRGB(58, 40, 72),
    INPUT_FOCUS = Color3.fromRGB(147, 51, 234),
    INPUT_TEXT = Color3.fromRGB(255, 255, 255),
    PILL_OFF = Color3.fromRGB(43, 32, 53),
    PILL_ON = Color3.fromRGB(147, 51, 234),
    DOT_OFF = Color3.fromRGB(139, 122, 152),
    DOT_ON = Color3.fromRGB(255, 255, 255),
    PILL_BORDER = Color3.fromRGB(74, 53, 88),
    BUTTON_BG = Color3.fromRGB(27, 19, 33),
    BUTTON_HOVER = Color3.fromRGB(49, 28, 60),
    BUTTON_ACTIVE_TEXT = Color3.fromRGB(255, 255, 255),
    TEXT_MUTED = Color3.fromRGB(184, 169, 201),
    TEXT_PRIMARY = Color3.fromRGB(255, 255, 255),
}

FRESH_VX7_BAR_COLORS = {
    FRAME = Color3.fromRGB(8, 6, 13),
    SHADE = Color3.fromRGB(3, 2, 5),
    TRACK = Color3.fromRGB(34, 21, 43),
    BORDER = Color3.fromRGB(168, 85, 247),
    ACCENT = Color3.fromRGB(147, 51, 234),
    DARK_ACCENT = Color3.fromRGB(88, 28, 135),
    HIGHLIGHT = Color3.fromRGB(216, 180, 254),
    TEXT = Color3.fromRGB(255, 255, 255),
    MUTED = Color3.fromRGB(196, 181, 212),
    STATUS = Color3.fromRGB(255, 255, 255),
}

-- Restringe los colores dinamicos de presets configurables a la paleta del tema.
local function _freshPaletteColor3(color)
    local brightness = color.R * 0.2126 + color.G * 0.7152 + color.B * 0.0722
    if brightness >= 0.90 then return STEAL_BAR_COLORS.WHITE end
    if brightness >= 0.50 then return STEAL_BAR_COLORS.LIGHT_YELLOW end
    if brightness >= 0.20 then return STEAL_BAR_COLORS.DARK_YELLOW end
    return STEAL_BAR_COLORS.BLACK
end

-- Tema Fresh: morado, negro y blanco.
themePalette = {
    surface=STEAL_BAR_COLORS.WIN_BG, panel=STEAL_BAR_COLORS.WIN_BG2, rowFill=STEAL_BAR_COLORS.ROW_BG,
    accent=STEAL_BAR_COLORS.ACCENT, accentMid=STEAL_BAR_COLORS.ACCENT_LIGHT, accentDark=STEAL_BAR_COLORS.ACCENT_DARK,
    accentText=STEAL_BAR_COLORS.SECTION_TEXT, secondary=STEAL_BAR_COLORS.DARK_YELLOW,
    buttonBg=STEAL_BAR_COLORS.BUTTON_BG, buttonText=STEAL_BAR_COLORS.ACCENT_TEXT,
    buttonHoverBg=STEAL_BAR_COLORS.BUTTON_HOVER, buttonActiveText=STEAL_BAR_COLORS.BUTTON_ACTIVE_TEXT,
    toggleBg=STEAL_BAR_COLORS.PILL_OFF, pillOn=STEAL_BAR_COLORS.PILL_ON,
    knob=STEAL_BAR_COLORS.DOT_ON, dotOff=STEAL_BAR_COLORS.DOT_OFF, dotOn=STEAL_BAR_COLORS.DOT_ON,
    rowBorder=STEAL_BAR_COLORS.ROW_BORDER, rowSoftBorder=STEAL_BAR_COLORS.PILL_BORDER,
    mutedText=STEAL_BAR_COLORS.TEXT_MUTED, textPrimary=STEAL_BAR_COLORS.TEXT_PRIMARY,
    activeTab=STEAL_BAR_COLORS.TAB_ACTIVE_BG,
    topBg=STEAL_BAR_COLORS.TOP_BG, topTitle=STEAL_BAR_COLORS.WHITE, topSub=STEAL_BAR_COLORS.TOP_SUB,
    tabBarBg=STEAL_BAR_COLORS.TAB_BG, tabBarDiv=STEAL_BAR_COLORS.TAB_DIV,
    tabIdle=STEAL_BAR_COLORS.TAB_IDLE, tabActive=STEAL_BAR_COLORS.TAB_ACTIVE,
    tabActiveBg=STEAL_BAR_COLORS.TAB_ACTIVE_BG, tabUnderline=STEAL_BAR_COLORS.TAB_UNDERLINE,
    rowHover=STEAL_BAR_COLORS.ROW_HOVER, inputBg=STEAL_BAR_COLORS.INPUT_BG,
    inputBorder=STEAL_BAR_COLORS.INPUT_BORDER, inputFocus=STEAL_BAR_COLORS.INPUT_FOCUS,
    inputText=STEAL_BAR_COLORS.INPUT_TEXT,
}

selectedColor = themePalette.accent
function getThemeColor() return themePalette.accent end

function applyStealBarAccent(color)
    local fillColor = FRESH_VX7_BAR_COLORS.ACCENT
    local darkColor = FRESH_VX7_BAR_COLORS.DARK_ACCENT
    if progressFill and progressFill.Parent then progressFill.BackgroundColor3 = fillColor end
    local wash = _G.__FreshStealBarWash
    if wash and wash.Parent then wash.BackgroundColor3 = fillColor end
    local gradient = _G.__FreshStealBarGradient
    if gradient and gradient.Parent then
        gradient.Rotation = 0
        gradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, darkColor),
            ColorSequenceKeypoint.new(0.38, fillColor),
            ColorSequenceKeypoint.new(0.68, fillColor),
            ColorSequenceKeypoint.new(1, darkColor),
        })
    end
    if pbFrame and pbFrame.Parent then
        for _, object in ipairs(pbFrame:GetDescendants()) do
            if object:IsA("TextLabel") or object:IsA("TextButton") then
                if object:GetAttribute("FreshStealBarKeepTextColor") ~= true then
                    object.TextColor3 = fillColor
                end
            end
        end
    end
end

function updateAllUIColors(color)
    if typeof(color) ~= "Color3" then color = selectedColor end
    local palette = themePalette
    local accentPrimary = palette.accent
    local accentSecondary = palette.secondary
    local accentHighlight = palette.accentMid or palette.accent
    local accentGradientSequence = ColorSequence.new({
        ColorSequenceKeypoint.new(0.00, accentPrimary),
        ColorSequenceKeypoint.new(0.48, accentHighlight),
        ColorSequenceKeypoint.new(1.00, accentSecondary),
    })
    local function setAccentGradient(target, enabled)
        if not target or not target:IsA("GuiObject") then return end
        local gradient = target:FindFirstChild("FreshThemeAccentGradient")
        if enabled then
            if not gradient then
                gradient = Instance.new("UIGradient")
                gradient.Name = "FreshThemeAccentGradient"
                gradient.Parent = target
            end
            gradient.Color = accentGradientSequence
            gradient.Rotation = 0
        elseif gradient then
            gradient:Destroy()
        end
    end
    local barGradient = ColorSequence.new({
        ColorSequenceKeypoint.new(0, FRESH_VX7_BAR_COLORS.DARK_ACCENT),
        ColorSequenceKeypoint.new(0.5, FRESH_VX7_BAR_COLORS.ACCENT),
        ColorSequenceKeypoint.new(1, FRESH_VX7_BAR_COLORS.HIGHLIGHT),
    })
    if progressFill then
        progressFill.BackgroundColor3 = FRESH_VX7_BAR_COLORS.ACCENT
        local grad = progressFill:FindFirstChildOfClass("UIGradient")
        if grad then grad.Color = barGradient end
    end
    local stealWash = _G.__FreshStealBarWash
    if stealWash then stealWash.BackgroundColor3 = FRESH_VX7_BAR_COLORS.ACCENT end
    local stealGradient = _G.__FreshStealBarGradient
    if stealGradient then stealGradient.Color = barGradient end
    if pbFrame then
        pbFrame.BackgroundColor3 = FRESH_VX7_BAR_COLORS.FRAME
        local border = pbFrame:FindFirstChildOfClass("UIStroke")
        if border then border.Color = FRESH_VX7_BAR_COLORS.BORDER end
    end
    if gui then
        for _, object in ipairs(gui:GetDescendants()) do
            if object:IsA("TextLabel") and object:GetAttribute("FreshStealBarKeepTextColor") ~= true then
                local text = object.Text
                if object.Name == "StealStats" then
                    object.TextColor3 = palette.accentMid
                elseif string.find(text, "Spd:", 1, true) or string.find(text, "FPS", 1, true) then
                    object.TextColor3 = palette.mutedText
                end
            elseif object:IsA("UIStroke") and object.Color == Color3.fromRGB(210, 210, 210) then
                object.Color = palette.rowBorder
            end
            local role = object:GetAttribute("FreshThemeRole")
            if role == "rowFill" and object:IsA("GuiObject") then
                object.BackgroundColor3 = palette.rowFill
            elseif role == "mutedText" and (object:IsA("TextLabel") or object:IsA("TextButton") or object:IsA("TextBox")) then
                object.TextColor3 = palette.mutedText
            elseif role == "textPrimary" and (object:IsA("TextLabel") or object:IsA("TextButton") or object:IsA("TextBox")) then
                object.TextColor3 = palette.textPrimary
            elseif role == "inputBox" and object:IsA("TextBox") then
                object.BackgroundColor3 = palette.inputBg
                object.TextColor3 = palette.inputText
            elseif role == "sliderTrack" and object:IsA("GuiObject") then
                object.BackgroundColor3 = palette.inputBg
            elseif role == "contentSurface" and object:IsA("Frame") then
                object.BackgroundColor3 = palette.panel
            elseif role == "pageSurface" and (object:IsA("ScrollingFrame") or object:IsA("Frame")) then
                object.BackgroundColor3 = palette.panel
            elseif role == "neutralDivider" and object:IsA("GuiObject") then
                object.BackgroundColor3 = palette.rowBorder
            elseif role == "miniButton" and object:IsA("TextButton") then
                object.BackgroundColor3 = palette.buttonBg
                object.TextColor3 = palette.buttonText
                local stroke = object:FindFirstChildOfClass("UIStroke")
                if stroke then stroke.Color = palette.rowBorder end
            elseif role == "accentText" and (object:IsA("TextLabel") or object:IsA("TextButton") or object:IsA("TextBox")) then
                object.TextColor3 = palette.accentText
            elseif role == "selectorSurface" and object:IsA("Frame") then
                object.BackgroundColor3 = palette.inputBg
            elseif role == "selectorCycleButton" and object:IsA("TextButton") then
                object.BackgroundColor3 = palette.inputBg
                object.BackgroundTransparency = 1
                object.TextColor3 = palette.mutedText
                local stroke = object:FindFirstChildOfClass("UIStroke")
                if stroke then stroke.Color = palette.rowBorder end
            elseif role == "stealBarText" and (object:IsA("TextLabel") or object:IsA("TextButton")) then
                object.TextColor3 = palette.accent
            elseif role == "stealBarMetric" and object:IsA("TextLabel") then
                object.TextColor3 = palette.accent
            elseif role == "stealBarTrack" and object:IsA("GuiObject") then
                object.BackgroundColor3 = FRESH_VX7_BAR_COLORS.TRACK
            elseif role == "stealBarBorder" and object:IsA("UIStroke") then
                object.Color = FRESH_VX7_BAR_COLORS.BORDER
            elseif role == "stealBarAccent" and object:IsA("GuiObject") then
                object.BackgroundColor3 = FRESH_VX7_BAR_COLORS.ACCENT
            elseif role == "accentButton" and object:IsA("TextButton") then
                object.TextColor3 = palette.buttonText
            elseif role == "accentFill" and object:IsA("GuiObject") then
                object.BackgroundColor3 = palette.accent
                setAccentGradient(object, true)
            elseif role == "secondaryFill" and object:IsA("GuiObject") then
                object.BackgroundColor3 = palette.accent
                setAccentGradient(object, true)
            elseif role == "accentStroke" and object:IsA("UIStroke") then
                local parentRole = object.Parent and object.Parent:GetAttribute("FreshThemeRole")
                if parentRole ~= "actionButton" then object.Color = palette.accent end
            elseif role == "secondaryStroke" and object:IsA("UIStroke") then
                local parentRole = object.Parent and object.Parent:GetAttribute("FreshThemeRole")
                if parentRole == "inputBox" then
                    object.Color = palette.inputBorder
                elseif parentRole ~= "toggleTrack" and parentRole ~= "secondaryButton" and parentRole ~= "keybindButton" then
                    object.Color = palette.rowBorder
                end
            elseif role == "secondaryButton" and object:IsA("TextButton") then
                local pressed = object:GetAttribute("FreshButtonActive") == true
                object.BackgroundColor3 = pressed and palette.accent or palette.buttonBg
                setAccentGradient(object, pressed)
                object.TextColor3 = pressed and palette.buttonActiveText or palette.buttonText
                local stroke = object:FindFirstChildOfClass("UIStroke")
                if stroke then stroke.Color = pressed and palette.accentDark or palette.rowBorder end
            elseif role == "selectorGradient" and object:IsA("UIGradient") then
                object.Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, palette.surface),
                    ColorSequenceKeypoint.new(0.48, palette.panel),
                    ColorSequenceKeypoint.new(1, palette.surface),
                })
            elseif role == "rowStroke" and object:IsA("UIStroke") then
                object.Color = palette.rowBorder
            elseif role == "accentGradient" and object:IsA("UIGradient") then
                object.Color = accentGradientSequence
                object.Rotation = 0
            elseif role == "toggleTrack" and object:IsA("Frame") then
                local enabled = object:GetAttribute("FreshThemeOn") == true
                local knob = object:FindFirstChild("Knob")
                local knobColor = enabled and palette.accent or palette.toggleBg
                if knob and knob:IsA("GuiObject") then
                    knob.BackgroundColor3 = knobColor
                    knob.BackgroundTransparency = enabled and 0 or 0.1
                    local knobStroke = knob:FindFirstChild("KnobStroke")
                    if knobStroke then
                        knobStroke.Color = enabled and palette.accent or palette.rowSoftBorder
                        knobStroke.Transparency = enabled and 0.2 or 0.5
                    end
                end
            elseif role == "tabButton" and object:IsA("TextButton") then
                local active = object:GetAttribute("FreshTabActive") == true
                object.BackgroundColor3 = active and palette.tabActiveBg or palette.tabBarBg
                object.BackgroundTransparency = active and 0 or 0.18
                setAccentGradient(object, false)
                object.TextColor3 = active and palette.tabActive or palette.tabIdle
                local stroke = object:FindFirstChildOfClass("UIStroke")
                if stroke then
                    stroke.Color = active and palette.tabUnderline or palette.tabBarDiv
                    stroke.Transparency = active and 0.05 or 0.52
                end
                local marker = object:FindFirstChild("Marker")
                if marker then
                    marker.BackgroundColor3 = active and palette.tabUnderline or palette.tabBarDiv
                    marker.BackgroundTransparency = active and 0 or 1
                    marker.Size = active and UDim2.new(0, 3, 0, 26) or UDim2.new(0, 3, 0, 0)
                end
                local underline = object:FindFirstChild("FreshTabIndicator")
                if underline then
                    underline.BackgroundColor3 = active and palette.tabUnderline or palette.tabBarDiv
                    underline.BackgroundTransparency = active and 0 or 1
                end
            elseif role == "tabStroke" and object:IsA("UIStroke") then
                local tab = object.Parent
                local active = tab and tab:GetAttribute("FreshTabActive") == true
                object.Color = active and palette.tabUnderline or palette.tabBarDiv
                object.Transparency = active and 0.05 or 0.52
            elseif role == "scrollbar" and object:IsA("ScrollingFrame") then
                object.ScrollBarImageColor3 = palette.rowBorder
                object.BackgroundColor3 = palette.panel
                object.BackgroundTransparency = 1
            elseif role == "actionButton" and object:IsA("TextButton") then
                local hovered = object:GetAttribute("FreshActionHover") == true
                local active = object:GetAttribute("FreshActionActive") == true
                object.BackgroundColor3 = active and palette.accent or (hovered and palette.buttonHoverBg or palette.buttonBg)
                setAccentGradient(object, active or hovered)
                object.TextColor3 = (active or hovered) and palette.buttonActiveText or palette.buttonText
                local stroke = object:FindFirstChildOfClass("UIStroke")
                if stroke then stroke.Color = active and palette.accentDark or palette.rowBorder end
            elseif role == "keybindButton" and object:IsA("TextButton") then
                local active = object:GetAttribute("FreshButtonActive") == true
                object.BackgroundColor3 = active and palette.accent or palette.buttonBg
                setAccentGradient(object, active)
                object.TextColor3 = active and palette.buttonActiveText or palette.buttonText
                local stroke = object:FindFirstChildOfClass("UIStroke")
                if stroke then stroke.Color = active and palette.accentDark or palette.rowBorder end
            end
        end
    end
    applyStealBarAccent(color)
    for _, tab in ipairs(tabButtons or {}) do
        if tab.TextColor3 == Color3.fromRGB(210, 210, 210) then tab.TextColor3 = palette.mutedText end
    end
    for _, box in pairs(espBoxCache) do
        if box then
            pcall(function()
                box.BackgroundColor3 = palette.accent
                local stroke = box:FindFirstChild("VX7ESPStroke")
                if stroke and stroke:IsA("UIStroke") then
                    stroke.Color = palette.accent
                end
            end)
        end
    end
    if main then
        local titleFrame = main:FindFirstChild("Frame")
        if titleFrame then
            for _, child in ipairs(titleFrame:GetDescendants()) do
                if child:IsA("UIStroke") and child.Color == Color3.fromRGB(210, 210, 210) then
                    child.Color = palette.rowBorder
                end
            end
        end
    end
    if miniBtn then
        if miniBtn:IsA("TextButton") then
            miniBtn.BackgroundColor3 = palette.buttonBg
            miniBtn.TextColor3 = palette.buttonText
        end
        local grad = miniBtn:FindFirstChildOfClass("UIGradient")
        if grad then
            grad.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, palette.accentDark),
                ColorSequenceKeypoint.new(0.3, palette.accent),
                ColorSequenceKeypoint.new(0.5, palette.secondary),
                ColorSequenceKeypoint.new(0.7, palette.accent),
                ColorSequenceKeypoint.new(1, palette.accentDark),
            })
        end
    end

    if lockHeaderButton and lockHeaderButton.Parent then
        local locked = uiLocked == true
        lockHeaderButton.Text = locked and "UNLOCK" or "LOCK"
        lockHeaderButton.BackgroundColor3 = palette.buttonBg
        lockHeaderButton.BackgroundTransparency = locked and 0.08 or 0.28
        lockHeaderButton.TextColor3 = palette.buttonText
        local stroke = lockHeaderButton:FindFirstChildOfClass("UIStroke")
        if stroke then
            stroke.Color = locked and palette.buttonText or palette.rowBorder
            stroke.Transparency = locked and 0.08 or 0.35
        end
    end

    local pGui = LP:FindFirstChild("PlayerGui")
    if pGui then
        local bb = pGui:FindFirstChild("RagCountdownBillboard")
        if bb then
            local lbl = bb:FindFirstChildOfClass("TextLabel")
            if lbl then
                lbl.TextColor3 = palette.accent
                local grad = lbl:FindFirstChildOfClass("UIGradient")
                if grad then
                    grad.Color = ColorSequence.new({
                        ColorSequenceKeypoint.new(0, palette.accent),
                        ColorSequenceKeypoint.new(0.3, palette.accent),
                        ColorSequenceKeypoint.new(0.5, palette.accent),
                        ColorSequenceKeypoint.new(0.7, palette.accent),
                        ColorSequenceKeypoint.new(1, palette.accent),
                    })
                end
            end
        end
    end

    if type(styleFreshBubbleOverheadText) == "function" then
        local character = LP.Character
        local head = character and character:FindFirstChild("Head")
        local billboard = head and head:FindFirstChild("GreenDuelsBB")
        if billboard and billboard:IsA("BillboardGui") and billboard:GetAttribute("FreshHubOverhead") then
            local title = billboard:FindFirstChild("FreshHubLabel")
            if title and title:IsA("TextLabel") then styleFreshBubbleOverheadText(title, 1.75) end
            local speedText = billboard:FindFirstChild("SpeedBillLbl")
            if speedText and speedText:IsA("TextLabel") then styleFreshBubbleOverheadText(speedText, 2.25) end
        end
        for _, label in pairs(enemySpeedLabels or {}) do
            local labelBillboard = label and label.Parent
            if label and label:IsA("TextLabel") and labelBillboard and labelBillboard:IsA("BillboardGui")
                and labelBillboard:GetAttribute("FreshHubOverhead") then
                styleFreshBubbleOverheadText(label, 1.9)
            end
        end
    end

    if MobilePanel then
        local container = MobilePanel:FindFirstChild("FloatingPanel")
        if container then
            local btnContainer = container:FindFirstChild("ButtonsContainer")
            if btnContainer then
                for _, btn in ipairs(btnContainer:GetChildren()) do
                    if btn:IsA("TextButton") and btn:FindFirstChild("BtnGrad") then
                        paintFloatingBtn(btn, btn:GetAttribute("MobActive") == true)
                    end
                end
            end
        end
    end
    if type(applyStealBarStyle) == "function" then applyStealBarStyle() end
end

-- ============================================================
-- 4. CONSTANTES Y ESTADO GLOBAL COMPARTIDO
-- ============================================================
NS = 60
CS = 29
LAGGER_SPEED = 15
LAGGER_CARRY_SPEED = 24.5
MEDUSA_COOLDOWN = 25
BAT_AIMBOT_SPEED = 58
BAT_AIMBOT_VERSION = 1
_sharedEnv.__FreshHubAimbotVersion = 1
BYPASS_AIMBOT_SPEED = 60
MOBILE_PANEL_WIDTH = 128
MOBILE_PANEL_HEIGHT = 294
CONFIG_FILE = "freshduelsofficial.json"
local previousGravity = tonumber(_sharedEnv.__FreshOriginalGravity)

if previousGravity and previousGravity == previousGravity then
    pcall(function() Workspace.Gravity = previousGravity end)
end

_sharedEnv.__FreshOriginalGravity = nil
_isResetting = false
_lastSavedJSON = nil
_isLoading = false

CONFIG = {
    AUTO_STEAL_ENABLED = false,
    STEAL_RANGE = 61,
}

Conns = {autoSteal = nil, batCounter = nil, anchor = {}, progress = nil, autoLeft = nil, autoRight = nil}

-- ============================================================
-- 5. COLISIONES ENTRE JUGADORES (NO PLAYER COLLISION)
-- ============================================================
_freshNoPlayerCollisionConnections = {}
_freshNoPlayerCollisionPlayerAddedConn = nil
_freshNoPlayerCollisionPlayerRemovingConn = nil
_freshNoPlayerCollisionLocalCharacterAddedConn = nil
_freshNoPlayerCollisionGroupReady = false
_freshPairNoCollisionConstraints = {}
_freshPairNoCollisionRefreshPending = false

function clearFreshNoCollisionPairRecord(character)
    local record = _freshPairNoCollisionConstraints[character]
    if record then
        for _, parts in pairs(record.constraints or {}) do
            for _, constraint in pairs(parts) do
                if constraint then pcall(function() constraint:Destroy() end) end
            end
        end
        _freshPairNoCollisionConstraints[character] = nil
    end
end

function clearFreshNoCollisionPairsForCharacter(character)
    clearFreshNoCollisionPairRecord(character)
    for otherCharacter, record in pairs(_freshPairNoCollisionConstraints) do
        if record.localCharacter == character then
            clearFreshNoCollisionPairRecord(otherCharacter)
        end
    end
end

function refreshFreshNoPlayerPairConstraints()
    local localCharacter = LP.Character
    if not localCharacter or not localCharacter.Parent then return end
    local activeCharacters = {}
    local localParts = {}
    for _, part in ipairs(localCharacter:GetDescendants()) do
        if part:IsA("BasePart") and part.CanCollide then
            local ancestor = part.Parent
            local isToolPart = false
            while ancestor and ancestor ~= localCharacter do
                if ancestor:IsA("Tool") then isToolPart = true; break end
                ancestor = ancestor.Parent
            end
            if not isToolPart then table.insert(localParts, part) end
        end
    end

    for _, player in ipairs(Players:GetPlayers()) do
        local otherCharacter = player ~= LP and player.Character
        if otherCharacter and otherCharacter.Parent then
            activeCharacters[otherCharacter] = true
            local record = _freshPairNoCollisionConstraints[otherCharacter]
            if record and record.localCharacter ~= localCharacter then
                clearFreshNoCollisionPairRecord(otherCharacter)
                record = nil
            end
            if not record then
                record = {localCharacter = localCharacter, constraints = {}}
                _freshPairNoCollisionConstraints[otherCharacter] = record
            end

            local otherParts = {}
            for _, part in ipairs(otherCharacter:GetDescendants()) do
                if part:IsA("BasePart") and part.CanCollide then
                    local ancestor = part.Parent
                    local isToolPart = false
                    while ancestor and ancestor ~= otherCharacter do
                        if ancestor:IsA("Tool") then isToolPart = true; break end
                        ancestor = ancestor.Parent
                    end
                    if not isToolPart then table.insert(otherParts, part) end
                end
            end

            local count = 0
            for _, localPart in ipairs(localParts) do
                if count >= 400 then break end
                local parts = record.constraints[localPart]
                if not parts then parts = {}; record.constraints[localPart] = parts end
                for _, otherPart in ipairs(otherParts) do
                    if count >= 400 then break end
                    local constraint = parts[otherPart]
                    if not constraint or not constraint.Parent then
                        constraint = Instance.new("NoCollisionConstraint")
                        constraint.Name = "FreshNoPlayerContact"
                        constraint.Part0 = localPart
                        constraint.Part1 = otherPart
                        constraint.Parent = localPart
                        parts[otherPart] = constraint
                    end
                    count = count + 1
                end
            end

            for localPart, parts in pairs(record.constraints) do
                for otherPart, constraint in pairs(parts) do
                    if not localPart.Parent or not otherPart.Parent
                        or not localPart.CanCollide or not otherPart.CanCollide then
                        if constraint then pcall(function() constraint:Destroy() end) end
                        parts[otherPart] = nil
                    end
                end
                if next(parts) == nil then record.constraints[localPart] = nil end
            end
        end
    end

    for otherCharacter in pairs(_freshPairNoCollisionConstraints) do
        if not activeCharacters[otherCharacter] then clearFreshNoCollisionPairRecord(otherCharacter) end
    end
end

function scheduleFreshNoPlayerPairRefresh()
    if _freshPairNoCollisionRefreshPending then return end
    _freshPairNoCollisionRefreshPending = true
    task.defer(function()
        _freshPairNoCollisionRefreshPending = false
        pcall(refreshFreshNoPlayerPairConstraints)
    end)
end

function refreshFreshNoPlayerCollisionMatrix()
    pcall(function()
        if not PhysicsService:IsCollisionGroupRegistered(FRESH_NO_PLAYER_COLLISION_GROUP) then
            PhysicsService:RegisterCollisionGroup(FRESH_NO_PLAYER_COLLISION_GROUP)
        end
    end)

    local groupsOk, groups = pcall(function()
        return PhysicsService:GetRegisteredCollisionGroups()
    end)
    if not groupsOk or type(groups) ~= "table" then
        _freshNoPlayerCollisionGroupReady = false
        return false
    end

    -- Copia las relaciones de Default cada vez que se aplica a un personaje.
    -- Asi mantiene colisiones con mapa/grupos especiales incluso si el juego
    -- registra grupos nuevos despues del inicio; solo Fresh-Fresh queda apagado.
    for _, groupInfo in ipairs(groups) do
        local groupName = groupInfo.name or groupInfo.Name
        if type(groupName) == "string" then
            local collidesWithDefault = true
            pcall(function()
                collidesWithDefault = PhysicsService:CollisionGroupsAreCollidable("Default", groupName)
            end)
            pcall(function()
                PhysicsService:CollisionGroupSetCollidable(
                    FRESH_NO_PLAYER_COLLISION_GROUP,
                    groupName,
                    groupName ~= FRESH_NO_PLAYER_COLLISION_GROUP and collidesWithDefault
                )
            end)
        end
    end
    pcall(function()
        PhysicsService:CollisionGroupSetCollidable(
            FRESH_NO_PLAYER_COLLISION_GROUP,
            FRESH_NO_PLAYER_COLLISION_GROUP,
            false
        )
    end)

    local registered = false
    pcall(function() registered = PhysicsService:IsCollisionGroupRegistered(FRESH_NO_PLAYER_COLLISION_GROUP) end)
    _freshNoPlayerCollisionGroupReady = registered
    return registered
end

pcall(refreshFreshNoPlayerCollisionMatrix)

local function cleanupNoPlayerCollisionCharacter(character)
    if not character then return end
    clearFreshNoCollisionPairsForCharacter(character)
    local record = _freshNoPlayerCollisionConnections[character]
    if not record then return end
    if record.descendantConn then
        pcall(function() record.descendantConn:Disconnect() end)
        record.descendantConn = nil
    end
    if record.descendantRemovingConn then
        pcall(function() record.descendantRemovingConn:Disconnect() end)
        record.descendantRemovingConn = nil
    end
    for _, conn in pairs(record.partConns or {}) do
        pcall(function() conn:Disconnect() end)
    end
    for _, conn in pairs(record.canCollideConns or {}) do
        pcall(function() conn:Disconnect() end)
    end
    -- Devuelve cada pieza a su grupo previo cuando deja de ser un personaje activo.
    for part, originalGroup in pairs(record.originalGroups or {}) do
        if part and part.Parent and originalGroup ~= FRESH_NO_PLAYER_COLLISION_GROUP then
            pcall(function() part.CollisionGroup = originalGroup end)
        end
    end
    record.partConns = {}
    record.originalGroups = {}
    _freshNoPlayerCollisionConnections[character] = nil
end

function applyNoPlayerCollisionToCharacter(character)
    if not character then return end
    -- Reconcilia cambios tardios de grupos antes de reasignar las piezas.
    pcall(refreshFreshNoPlayerCollisionMatrix)
    local record = _freshNoPlayerCollisionConnections[character]
    if not record then
        record = {originalGroups = {}}
        _freshNoPlayerCollisionConnections[character] = record
    end
    record.originalGroups = record.originalGroups or {}
    record.partConns = record.partConns or {}
    record.canCollideConns = record.canCollideConns or {}
    record.reapplying = record.reapplying or {}

    local function getContainingTool(instance)
        local ancestor = instance and instance.Parent
        while ancestor and ancestor ~= character do
            if ancestor:IsA("Tool") then return ancestor end
            ancestor = ancestor.Parent
        end
        return nil
    end

    local function restoreToolPartCollision(instance)
        local conn = record.partConns[instance]
        if conn then
            pcall(function() conn:Disconnect() end)
            record.partConns[instance] = nil
        end
        local ok, currentGroup = pcall(function() return instance.CollisionGroup end)
        local originalGroup = record.originalGroups[instance]
        record.originalGroups[instance] = nil
        -- Si quedo en el grupo anticolision por una ejecucion anterior, devolver
        -- el arma a Default para que su Handle pueda registrar impactos normales.
        local targetGroup = originalGroup
        if not targetGroup and ok and currentGroup == FRESH_NO_PLAYER_COLLISION_GROUP then
            targetGroup = "Default"
        end
        if targetGroup and ok and currentGroup ~= targetGroup then
            record.reapplying[instance] = true
            pcall(function() instance.CollisionGroup = targetGroup end)
            record.reapplying[instance] = nil
        end
    end

    local function isolatePartCollision(instance)
        if not (instance and instance:IsA("BasePart")) then return end
        if not record.canCollideConns[instance] then
            local okCanCollide, canCollideConn = pcall(function()
                return instance:GetPropertyChangedSignal("CanCollide"):Connect(scheduleFreshNoPlayerPairRefresh)
            end)
            if okCanCollide and canCollideConn then record.canCollideConns[instance] = canCollideConn end
        end
        if not _freshNoPlayerCollisionGroupReady then return end
        local containingTool = getContainingTool(instance)
        if containingTool then
            local toolName = containingTool.Name:lower()
            local isLocalBat = character == LP.Character
                and (toolName:find("bat", 1, true) or toolName:find("slap", 1, true))
            if isLocalBat then
                -- Solo el bate propio conserva el contacto de hitbox contra los rivales.
                restoreToolPartCollision(instance)
                return
            end
            -- Herramientas de rivales y herramientas locales que no son el bate
            -- tambien quedan sin colision jugador-jugador.
        end
        local ok, currentGroup = pcall(function() return instance.CollisionGroup end)
        if not ok then return end
        if currentGroup ~= FRESH_NO_PLAYER_COLLISION_GROUP
           and record.originalGroups[instance] == nil then
            record.originalGroups[instance] = currentGroup
        end
        if currentGroup ~= FRESH_NO_PLAYER_COLLISION_GROUP then
            record.reapplying[instance] = true
            pcall(function() instance.CollisionGroup = FRESH_NO_PLAYER_COLLISION_GROUP end)
            record.reapplying[instance] = nil
        end
        -- Si otro script vuelve a mover una pieza a Default u otro grupo, la
        -- reasigna para que el jugador no rebote contra otros personajes.
        local partConn = record.partConns[instance]
        if not (partConn and partConn.Connected) then
            local okConn, conn = pcall(function()
                return instance:GetPropertyChangedSignal("CollisionGroup"):Connect(function()
                    if record.reapplying[instance] or not instance.Parent then return end
                    local okNow, newGroup = pcall(function() return instance.CollisionGroup end)
                    if okNow and newGroup ~= FRESH_NO_PLAYER_COLLISION_GROUP then
                        record.reapplying[instance] = true
                        pcall(function() instance.CollisionGroup = FRESH_NO_PLAYER_COLLISION_GROUP end)
                        record.reapplying[instance] = nil
                    end
                end)
            end)
            if okConn and conn then record.partConns[instance] = conn end
        end
    end

    for _, descendant in ipairs(character:GetDescendants()) do
        isolatePartCollision(descendant)
    end
    -- Cuerpo, accesorios y herramientas ajenas al bate local evitan el rebote;
    -- solo el bate propio conserva el contacto necesario para registrar impactos.
    -- Una sola conexion por personaje cubre piezas y accesorios anadidos despues.
    if not (record.descendantConn and record.descendantConn.Connected) then
        record.descendantConn = character.DescendantAdded:Connect(function(instance)
            isolatePartCollision(instance)
            scheduleFreshNoPlayerPairRefresh()
        end)
    end
    if not (record.descendantRemovingConn and record.descendantRemovingConn.Connected) then
        record.descendantRemovingConn = character.DescendantRemoving:Connect(function(removing)
            for part, conn in pairs(record.partConns) do
                if part == removing or removing:IsAncestorOf(part) then
                    pcall(function() conn:Disconnect() end)
                    record.partConns[part] = nil
                    local originalGroup = record.originalGroups[part]
                    record.originalGroups[part] = nil
                    if part.Parent and originalGroup and originalGroup ~= FRESH_NO_PLAYER_COLLISION_GROUP then
                        pcall(function() part.CollisionGroup = originalGroup end)
                    end
                end
            end
            for part, conn in pairs(record.canCollideConns) do
                if part == removing or removing:IsAncestorOf(part) then
                    pcall(function() conn:Disconnect() end)
                    record.canCollideConns[part] = nil
                end
            end
            scheduleFreshNoPlayerPairRefresh()
        end)
    end
    scheduleFreshNoPlayerPairRefresh()
end

-- El personaje local tambien usa el grupo dedicado; el entorno conserva las
-- reglas de Default, y los grupos de jugador dejan de colisionar entre si.
local previousLocalCharacter = _freshNoPlayerCollisionConnections.__localCharacter

if previousLocalCharacter and previousLocalCharacter ~= LP.Character then
    cleanupNoPlayerCollisionCharacter(previousLocalCharacter)
end

_freshNoPlayerCollisionConnections.__localCharacter = LP.Character
if LP.Character then applyNoPlayerCollisionToCharacter(LP.Character) end

_freshNoPlayerCollisionLocalCharacterAddedConn = LP.CharacterAdded:Connect(function(character)
    local previous = _freshNoPlayerCollisionConnections.__localCharacter
    if previous and previous ~= character then
        cleanupNoPlayerCollisionCharacter(previous)
    end
    _freshNoPlayerCollisionConnections.__localCharacter = character
    applyNoPlayerCollisionToCharacter(character)
end)

function watchOtherPlayer(player)
    if not player or player == LP or _freshNoPlayerCollisionConnections[player] then return end
    local record = {}
    _freshNoPlayerCollisionConnections[player] = record
    record.characterConn = player.CharacterAdded:Connect(function(character)
        if record.character and record.character ~= character then
            cleanupNoPlayerCollisionCharacter(record.character)
        end
        record.character = character
        applyNoPlayerCollisionToCharacter(character)
    end)
    if player.Character then
        record.character = player.Character
        applyNoPlayerCollisionToCharacter(player.Character)
    end
end

pcall(function()
    for _, otherPlayer in ipairs(Players:GetPlayers()) do
        if otherPlayer ~= LP then watchOtherPlayer(otherPlayer) end
    end
    _freshNoPlayerCollisionPlayerAddedConn = Players.PlayerAdded:Connect(watchOtherPlayer)
    _freshNoPlayerCollisionPlayerRemovingConn = Players.PlayerRemoving:Connect(function(player)
        if player.Character then clearFreshNoCollisionPairsForCharacter(player.Character) end
        local record = _freshNoPlayerCollisionConnections[player]
        if not record then return end
        if record.characterConn then pcall(function() record.characterConn:Disconnect() end) end
        if record.character then cleanupNoPlayerCollisionCharacter(record.character) end
        _freshNoPlayerCollisionConnections[player] = nil
    end)
end)

-- ============================================================
-- 6. SISTEMA CARRY / SOFT STEAL / LAGGER
-- ============================================================
local autoCarryEnabled = false
local autoCarrySetVisual = nil

local CarrySystem = {

    normalSpeed = NS,
    carrySpeed = CS,
    laggerSpeed = LAGGER_SPEED,
    laggerCarrySpeed = LAGGER_CARRY_SPEED,

    speedToggled = false,
    laggerMode = 0,

    softStealEnabled = false,
    softStealRadius = 10,
    softStealSpeed = 30,
    softStealLatched = false,

    _isCarrying = false,
    _lastCarryCheck = 0,

    _lvBoost = nil,
    _lvAtt = nil,
    _blockedTime = 0,
    _lastCollisionSweep = 0,
    _maxForce = 2200,
    _freeForce = 500,

    _heartbeatConn = nil,
    _softStealScanner = nil,
    _softStealAnimals = {},
    _softStealScanning = false,
    _softStealScanToken = 0,

    _state = nil,
    _dropInProgress = false,
    _batAimbotToggled = false,

    _rayParams = nil,
    _rayFilter = nil,
    _rayFilterTime = 0,
}

_sharedEnv.__FreshBrainrotStateNames = _sharedEnv.__FreshBrainrotStateNames or {
    "Stealing", "Carrying", "IsCarrying", "Grabbed", "Holding",
    "StealHold", "HasGrab", "HasBrainrot",
}

-- Detecta herramientas/cargas equipadas para el modo Auto Carry.
local function hasCarryItemInHands()
    local char = LP.Character
    if not char then return false end

    for _, child in ipairs(char:GetChildren()) do
        if child:IsA("Tool") then
            local name = child.Name:lower()
            if name:find("brainrot") or name:find("steal") or name:find("animal")
               or name:find("carry") or name:find("grab") or name:find("hold") then
                return true
            end
            for _, attributeName in ipairs(_sharedEnv.__FreshBrainrotStateNames) do
                if child:GetAttribute(attributeName) == true then return true end
            end
        end
    end

    for _, name in ipairs(_sharedEnv.__FreshBrainrotStateNames) do
        local okPlayer, playerValue = pcall(function() return LP:GetAttribute(name) end)
        local okChar, charValue = pcall(function() return char:GetAttribute(name) end)
        if (okPlayer and playerValue == true) or (okChar and charValue == true) then
            return true
        end
        local obj = char:FindFirstChild(name)
        if obj and ((obj:IsA("BoolValue") and obj.Value)
            or (obj:IsA("ObjectValue") and obj.Value)
            or (obj:IsA("StringValue") and obj.Value ~= "")) then
            return true
        end
    end

    -- No usar Humanoid.WalkSpeed como señal: la velocidad normal del juego
    -- también suele ser 16 y provocaría falsos positivos al detectar objetos.
    return false
end

local function setAutoCarryEnabled(enabled)
    autoCarryEnabled = enabled == true
    if autoCarrySetVisual then autoCarrySetVisual(autoCarryEnabled) end
    if type(saveAllSettings) == "function" then pcall(saveAllSettings) end
end

function CarrySystem:isCarrying()
    local now = _tick()
    if now - (self._lastCarryCheck or 0) < 0.1 then
        return self._isCarrying
    end
    self._lastCarryCheck = now
    local char = LP.Character
    if not char then self._isCarrying = false; return false end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local ws = hum and hum.WalkSpeed or 16
    local bySpeed = (ws < 25 and ws > 0)
    local byAttr = false
    local ok, v = pcall(function() return LP:GetAttribute("Stealing") end)
    if ok and v == true then byAttr = true end
    local ok2, v2 = pcall(function() return char:GetAttribute("Stealing") end)
    if ok2 and v2 == true then byAttr = true end
    if not byAttr then
        for _, name in ipairs({"Carrying","IsCarrying","Grabbed","Holding","StealHold","HasGrab"}) do
            local obj = char:FindFirstChild(name)
            if obj then
                if (obj:IsA("BoolValue") and obj.Value) or
                   (obj:IsA("ObjectValue") and obj.Value) or
                   (obj:IsA("StringValue") and obj.Value ~= "") then
                    byAttr = true; break
                end
            end
        end
    end
    self._isCarrying = bySpeed or byAttr
    return self._isCarrying
end

function CarrySystem:getActiveSpeed()
    if self._state and (self._state.autoLeftEnabled or self._state.autoRightEnabled) then
        return self.normalSpeed
    end
    if self.laggerMode == 1 then return self.laggerSpeed end
    if self.laggerMode == 2 then return self.laggerCarrySpeed end
    if autoCarryEnabled and hasCarryItemInHands() then return self.carrySpeed end
    if self.speedToggled then return self.carrySpeed end
    return self.normalSpeed
end

function CarrySystem:getStatus()
    if self._state and (self._state.autoLeftEnabled or self._state.autoRightEnabled) then
        return "NORMAL", self.normalSpeed
    end
    if self.laggerMode == 1 then return "LAGGER", self.laggerSpeed end
    if self.laggerMode == 2 then return "LAGGER CARRY", self.laggerCarrySpeed end
    if autoCarryEnabled and hasCarryItemInHands() then return "AUTO CARRY", self.carrySpeed end
    if self.speedToggled then return "CARRY", self.carrySpeed end
    return "NORMAL", self.normalSpeed
end

local function destroyLV()
    if CarrySystem._lvBoost and CarrySystem._lvBoost.Parent then pcall(function() CarrySystem._lvBoost:Destroy() end) end
    if CarrySystem._lvAtt and CarrySystem._lvAtt.Parent then pcall(function() CarrySystem._lvAtt:Destroy() end) end
    CarrySystem._lvBoost = nil; CarrySystem._lvAtt = nil
end

local function setupLV(hrp)
    if CarrySystem._lvBoost and CarrySystem._lvBoost.Parent == hrp then return end
    destroyLV()
    local att = Instance.new("Attachment"); att.Parent = hrp
    local lv = Instance.new("LinearVelocity")
    lv.Name = "CarryBoostLV"
    lv.Attachment0 = att
    lv.VelocityConstraintMode = Enum.VelocityConstraintMode.Plane
    lv.PrimaryTangentAxis = _V3new(1,0,0)
    lv.SecondaryTangentAxis = _V3new(0,0,1)
    lv.MaxForce = CarrySystem._maxForce
    lv.PlaneVelocity = Vector2.zero
    lv.RelativeTo = Enum.ActuatorRelativeTo.World
    lv.Parent = hrp
    CarrySystem._lvAtt = att
    CarrySystem._lvBoost = lv
    pcall(function() hrp:SetNetworkOwner(LP) end)
end

function CarrySystem:scanSoftStealAnimals()
    self._softStealAnimals = {}
    local plots = Workspace:FindFirstChild("Plots")
    if not plots then return end
    for _, plot in ipairs(plots:GetChildren()) do
        if plot:IsA("Model") then
            local podiums = plot:FindFirstChild("AnimalPodiums")
            if podiums then
                for _, podium in ipairs(podiums:GetChildren()) do
                    if podium:IsA("Model") then
                        local base = podium:FindFirstChild("Base")
                        local spawn = base and base:FindFirstChild("Spawn")
                        if spawn then
                            table.insert(self._softStealAnimals, {
                                plot = plot.Name,
                                slot = podium.Name,
                                worldPosition = spawn.Position,
                                uid = plot.Name .. "_" .. podium.Name,
                            })
                        end
                    end
                end
            end
        end
    end
end

function CarrySystem:startSoftStealScanner()
    if self._softStealScanner then return end
    self._softStealScanning = true
    self._softStealScanToken = (self._softStealScanToken or 0) + 1
    local token = self._softStealScanToken
    self:scanSoftStealAnimals()
    -- Los podiums no necesitan escanearse 60 veces por segundo.
    self._softStealScanner = task.spawn(function()
        while self._softStealScanning and self._softStealScanToken == token do
            task.wait(0.75)
            if self._softStealScanning and self._softStealScanToken == token then
                self:scanSoftStealAnimals()
            end
        end
    end)
end

function CarrySystem:stopSoftStealScanner()
    self._softStealScanning = false
    self._softStealScanToken = (self._softStealScanToken or 0) + 1
    if self._softStealScanner then
        pcall(task.cancel, self._softStealScanner)
        self._softStealScanner = nil
    end
end

function CarrySystem:getNearestSoftStealAnimal(radius)
    local char = LP.Character
    local root = char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("UpperTorso"))
    if not root then return nil, _huge end
    local best, bestDist = nil, _huge
    local animals = self._softStealAnimals
    local rpos = root.Position
    for i = 1, #animals do
        local data = animals[i]
        if data.worldPosition then
            local dx = rpos.X - data.worldPosition.X
            local dy = rpos.Y - data.worldPosition.Y
            local dz = rpos.Z - data.worldPosition.Z
            local dist = _sqrt(dx*dx + dy*dy + dz*dz)
            if dist < bestDist then
                best = data; bestDist = dist
            end
        end
    end
    if radius and bestDist > radius then return nil, bestDist end
    return best, bestDist
end

local function nowForCollisionSweep(system, now)
    if now - (system._lastCollisionSweep or 0) < 0.45 then return false end
    system._lastCollisionSweep = now
    return true
end

function CarrySystem:updateMovement(dt)
    local char = LP.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum then return end
    local speed = self:getActiveSpeed()
    local moveDir = hum.MoveDirection
    local moving = moveDir.Magnitude > 0.1

    local wallNormalFlat = nil
    if moving then
        if not self._rayParams then
            self._rayParams = _RayParams_new()
            self._rayParams.FilterType = Enum.RaycastFilterType.Exclude
            self._rayParams.RespectCanCollide = true
            self._rayFilter = {}
            self._rayFilterTime = 0
        end
        local now = _tick()
        if now - self._rayFilterTime > 1 then
            self._rayFilterTime = now
            local filter = self._rayFilter
            while #filter > 0 do filter[#filter] = nil end
            filter[1] = char
            local plist = _GetPlayersCached()
            for i = 1, #plist do
                local p = plist[i]
                if p.Character then
                    filter[#filter + 1] = p.Character
                end
            end
            self._rayParams.FilterDescendantsInstances = filter
        else
            local filter = self._rayFilter
            local found = false
            for i = 1, #filter do
                if filter[i] == char then found = true; break end
            end
            if not found then
                filter[1] = char
                self._rayParams.FilterDescendantsInstances = filter
            end
        end
        local flatDir = _V3new(moveDir.X, 0, moveDir.Z).Unit
        local hit = Workspace:Raycast(hrp.Position + _V3new(0,1,0), flatDir * 2.5, self._rayParams)
        if hit and hit.Instance and hit.Instance.CanCollide then
            local nf = _V3new(hit.Normal.X, 0, hit.Normal.Z)
            if nf.Magnitude > 0.7 then wallNormalFlat = nf.Unit end
        end
    end

    local hVel = _V3new(hrp.AssemblyLinearVelocity.X, 0, hrp.AssemblyLinearVelocity.Z)
    local blocked = wallNormalFlat ~= nil or (moving and hVel.Magnitude < 2)

    if blocked and nowForCollisionSweep(self, _tick()) then
        for _, model in ipairs(char:GetChildren()) do
            if model:IsA("Model") then
                for _, part in ipairs(model:GetDescendants()) do
                    if part:IsA("BasePart") and part.CanCollide then part.CanCollide = false end
                end
            end
        end
        for _, name in ipairs({"Carrying","IsCarrying","Grabbed","Holding","StealHold","HasGrab"}) do
            local v = char:FindFirstChild(name)
            if v and v:IsA("ObjectValue") and v.Value and v.Value:IsA("Model") then
                for _, part in ipairs(v.Value:GetDescendants()) do
                    if part:IsA("BasePart") and part.CanCollide then part.CanCollide = false end
                end
            end
        end
    end

    local state = hum:GetState()
    local ragdolled = state == Enum.HumanoidStateType.Physics
                   or state == Enum.HumanoidStateType.Ragdoll
                   or state == Enum.HumanoidStateType.FallingDown
    local moverBlocked = ragdolled or self._dropInProgress or self._batAimbotToggled

    if not moverBlocked then
        if not CarrySystem._lvBoost or CarrySystem._lvBoost.Parent ~= hrp then setupLV(hrp) end
        local lv = CarrySystem._lvBoost
        if lv then
            if not lv.Enabled then lv.Enabled = true end
            if moveDir.Magnitude > 0.1 then
                local flat = _V3new(moveDir.X, 0, moveDir.Z).Unit
                if wallNormalFlat then
                    local wanted = flat * speed
                    local along = wanted - wallNormalFlat * wanted:Dot(wallNormalFlat)
                    if along.Magnitude < 0.5 then
                        lv.PlaneVelocity = Vector2.zero
                    else
                        lv.PlaneVelocity = Vector2.new(along.X, along.Z)
                    end
                else
                    lv.PlaneVelocity = Vector2.new(flat.X * speed, flat.Z * speed)
                end
            else
                lv.PlaneVelocity = Vector2.zero
            end
            if blocked then
                self._blockedTime = self._blockedTime + (dt or 0.016)
            else
                self._blockedTime = 0
            end
            if self._blockedTime > 0.35 then
                if lv.MaxForce ~= self._freeForce then lv.MaxForce = self._freeForce end
            elseif lv.MaxForce ~= self._maxForce then
                lv.MaxForce = self._maxForce
            end
        end
    elseif CarrySystem._lvBoost then
        CarrySystem._lvBoost.PlaneVelocity = Vector2.zero
        if CarrySystem._lvBoost.Enabled then CarrySystem._lvBoost.Enabled = false end
    end
end

function CarrySystem:start()
    if self._heartbeatConn then return end
    self._heartbeatConn = RunService.Heartbeat:Connect(function(dt) self:updateMovement(dt) end)
    print("[CarrySystem] Activado")
end

function CarrySystem:stop()
    if self._heartbeatConn then
        self._heartbeatConn:Disconnect()
        self._heartbeatConn = nil
    end
    self:stopSoftStealScanner()
    destroyLV()
    self.softStealLatched = false
    print("[CarrySystem] Desactivado")
end

function CarrySystem:setNormalSpeed(v) v = tonumber(v); if v then self.normalSpeed = v end end
function CarrySystem:setCarrySpeed(v) v = tonumber(v); if v then self.carrySpeed = v end end
function CarrySystem:setLaggerSpeed(v) v = tonumber(v); if v then self.laggerSpeed = v end end
function CarrySystem:setLaggerCarrySpeed(v) v = tonumber(v); if v then self.laggerCarrySpeed = v end end
function CarrySystem:setSoftStealSpeed(v) v = tonumber(v); if v then self.softStealSpeed = v end end

function CarrySystem:setSoftStealRadius(v)
    v = tonumber(v)
    if v then self.softStealRadius = _clamp(v, 1, 200) end
end

function CarrySystem:toggleCarryMode() self.speedToggled = not self.speedToggled end

function CarrySystem:setLaggerMode(mode)
    if mode == 0 then self.laggerMode = 0
    elseif mode == 1 then self.laggerMode = 1
    elseif mode == 2 then self.laggerMode = 2 end
end

function CarrySystem:toggleLaggerMode()
    if self.laggerMode == 0 then self.laggerMode = 1
    elseif self.laggerMode == 1 then self.laggerMode = 2
    else self.laggerMode = 0 end
end

function CarrySystem:setSoftStealEnabled(enabled)
    self.softStealEnabled = enabled
    if enabled then self:startSoftStealScanner()
    else self:stopSoftStealScanner(); self.softStealLatched = false end
end

function CarrySystem:toggleSoftSteal() self:setSoftStealEnabled(not self.softStealEnabled) end
function CarrySystem:isRunning() return self._heartbeatConn ~= nil end
function CarrySystem:getCurrentSpeed() return self:getActiveSpeed() end
useCarrySystem = false
carrySystemToggleSetter = nil
carrySysNormalBox = nil
carrySysCarryBox = nil
carrySysLaggerBox = nil
carrySysLaggerCarryBox = nil
carrySysSoftStealSpeedBox = nil
carrySysSoftStealRadiusBox = nil

-- ============================================================
-- 7. APARIENCIA: OUTFITS, KATANA, HEADLESS Y KORBLOX
-- ============================================================
local katanaSkinEnabled = false
local katanaSkinSetVisual = nil
local katanaSkinStates = _sharedEnv.__FreshKatanaSkinStates or setmetatable({}, {__mode = "k"})
_sharedEnv.__FreshKatanaSkinStates = katanaSkinStates
local OUTFIT_TAG = "AuFfit"
local originalOutfitCache = setmetatable({}, {__mode = "k"})

local function cacheOriginalAppearance(char)
    if not char or originalOutfitCache[char] then return end
    local head = char:FindFirstChild("Head")
    local shirt = char:FindFirstChildWhichIsA("Shirt")
    local pants = char:FindFirstChildWhichIsA("Pants")
    local headMesh = head and head:FindFirstChildWhichIsA("SpecialMesh")
    local saved = {
        shirtTemplate = shirt and shirt.ShirtTemplate,
        hadShirt = shirt ~= nil,
        pantsTemplate = pants and pants.PantsTemplate,
        hadPants = pants ~= nil,
        headMeshId = head and head:IsA("MeshPart") and head.MeshId or nil,
        headTextureId = head and head:IsA("MeshPart") and head.TextureID or nil,
        hadSpecialMesh = headMesh ~= nil,
        specialMeshId = headMesh and headMesh.MeshId,
        specialTextureId = headMesh and headMesh.TextureId,
        accessories = {},
        bodyPartTransparency = {},
    }
    for _, child in ipairs(char:GetChildren()) do
        if child:IsA("Accessory") then table.insert(saved.accessories, child) end
        if child:IsA("BasePart") and child.Name ~= "HumanoidRootPart" then
            saved.bodyPartTransparency[child] = {
                transparency = child.Transparency,
                localTransparencyModifier = child.LocalTransparencyModifier,
            }
        end
    end
    pcall(function()
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        if humanoid then
            saved.humanoidDescription = humanoid:GetAppliedDescription()
        end
    end)
    originalOutfitCache[char] = saved
end

function _freshApplyHumanoidDescription(humanoid, description)
    if not humanoid or not description then return false, "Humanoid o HumanoidDescription ausente" end
    local ok, err = pcall(function()
        humanoid:ApplyDescriptionResetAsync(description)
    end)
    if not ok then
        ok, err = pcall(function()
            humanoid:ApplyDescriptionAsync(description)
        end)
    end
    return ok, ok and nil or tostring(err)
end

function _freshRestoreOriginalHumanoidDescription(char)
    local saved = char and originalOutfitCache[char]
    local humanoid = char and char:FindFirstChildOfClass("Humanoid")
    if saved and saved.humanoidDescription and humanoid then
        return _freshApplyHumanoidDescription(humanoid, saved.humanoidDescription)
    end
    return false
end

FullBody = {}

function FullBody.hide(char)
    local saved = originalOutfitCache[char]
    if not saved then return end
    for part in pairs(saved.bodyPartTransparency or {}) do
        if part and part.Parent then
            part.Transparency = 1
            part.LocalTransparencyModifier = 1
        end
    end
end

function FullBody.restore(char)
    local saved = originalOutfitCache[char]
    if not saved then return end
    for part, state in pairs(saved.bodyPartTransparency or {}) do
        if part and part.Parent and state then
            part.Transparency = state.transparency or 0
            part.LocalTransparencyModifier = state.localTransparencyModifier or 0
        end
    end
end

local function applyNoOutfit(char, restoreOriginal)
    if not char then char = LP.Character end
    if not char then return end
    for _, d in ipairs(char:GetChildren()) do
        if d.Name:sub(1, #OUTFIT_TAG) == OUTFIT_TAG or d.Name:sub(1, 14) == "OceanVX7Outfit" then
            pcall(function() d:Destroy() end)
        end
    end
    local oldAcc = char:FindFirstChild("AuFfitAccessory")
    if oldAcc then pcall(function() oldAcc:Destroy() end) end
    if restoreOriginal == false then
        for _, child in ipairs(char:GetChildren()) do
            if child:IsA("Accessory") then
                -- Desparentar los accesorios originales para poder restaurarlos al elegir Off.
                pcall(function() child.Parent = nil end)
            elseif child:IsA("Shirt") or child:IsA("Pants") or child:IsA("ShirtGraphic") or child:IsA("CharacterMesh") then
                pcall(function() child:Destroy() end)
            end
        end
    else
        FullBody.restore(char)
    end
    local oldKorblox = char:FindFirstChild("Korblox_RightLeg")
    if oldKorblox then pcall(function() oldKorblox:Destroy() end) end
    local oldZurichKorblox = char:FindFirstChild("ZurichKorbloxLeg")
    if oldZurichKorblox then pcall(function() oldZurichKorblox:Destroy() end) end
    for _, limb in ipairs({char:FindFirstChild("Right Leg"), char:FindFirstChild("RightUpperLeg")}) do
        local mesh = limb and limb:FindFirstChild("ZurichKorbloxMesh")
        if mesh then pcall(function() mesh:Destroy() end) end
    end
    for _, torso in ipairs({char:FindFirstChild("Torso"), char:FindFirstChild("UpperTorso")}) do
        local mesh = torso and torso:FindFirstChild("OceanZurichTorsoMesh")
        if mesh then pcall(function() mesh:Destroy() end) end
    end
    for _, d in ipairs(char:GetChildren()) do
        if d:IsA("CharacterMesh") and d.BodyPart == Enum.BodyPart.Head then
            pcall(function() d:Destroy() end)
        end
    end
    local head = char:FindFirstChild("Head")
    local saved = originalOutfitCache[char]
    if head then
        head.Transparency = 0
        head.CanCollide = true
        head.LocalTransparencyModifier = 0
        local face = head:FindFirstChild("face")
        if face then face.Transparency = 0 end
        local sm = head:FindFirstChildWhichIsA("SpecialMesh")
        if sm and (not saved or not saved.hadSpecialMesh) then pcall(function() sm:Destroy() end) end
        if saved and head:IsA("MeshPart") and saved.headMeshId then
            pcall(function()
                head.MeshId = saved.headMeshId
                head.TextureID = saved.headTextureId or ""
            end)
        elseif saved and saved.hadSpecialMesh and saved.specialMeshId then
            local restored = Instance.new("SpecialMesh")
            restored.MeshType = Enum.MeshType.FileMesh
            restored.MeshId = saved.specialMeshId
            restored.TextureId = saved.specialTextureId or ""
            restored.Parent = head
        end
    end
    pcall(function()
        local neck = char:FindFirstChild("Neck")
        if neck then neck.Enabled = true end
    end)
    for _, partName in ipairs({"RightUpperLeg", "RightLowerLeg", "RightFoot", "Right Leg", "LeftUpperLeg", "LeftLowerLeg", "LeftFoot", "Left Leg"}) do
        local limb = char:FindFirstChild(partName)
        if limb then
            limb.Transparency = 0
            limb.LocalTransparencyModifier = 0
        end
    end
    local shirt = char:FindFirstChildWhichIsA("Shirt")
    local pants = char:FindFirstChildWhichIsA("Pants")
    if saved and restoreOriginal ~= false then
        local restoredByDescription = _freshRestoreOriginalHumanoidDescription(char)
        if saved.hadShirt then
            shirt = shirt or Instance.new("Shirt", char)
            shirt.ShirtTemplate = saved.shirtTemplate or ""
        elseif shirt then shirt:Destroy() end
        if saved.hadPants then
            pants = pants or Instance.new("Pants", char)
            pants.PantsTemplate = saved.pantsTemplate or ""
        elseif pants then pants:Destroy() end
        if not restoredByDescription then
            for _, accessory in ipairs(saved.accessories) do
                if accessory and not accessory.Parent then
                    pcall(function() accessory.Parent = char end)
                end
            end
        end
    end
    for _, a in ipairs(char:GetChildren()) do
        if a:IsA("Accessory") then
            local h = a:FindFirstChild("Handle")
            if h then h.Transparency = 0 end
        end
    end
end

local OUTFITS = {
    {
        label = "Off",
        customApply = applyNoOutfit,
    },
    {
        label = "Chico Navidad",
        -- Accesorio de cabeza, camisa clasica y pantalones clasicos.
        items = {76463576032718},
        shirt = "http://www.roblox.com/asset/?id=120068444849388",
        pants = "http://www.roblox.com/asset/?id=4485911381",
        headlessOnly = true,
    },
    {
        label = "Papá Noel",
        -- Los tres IDs pedidos: accesorio de cabeza y ropa clásica 2D.
        items = {81788141904267},
        shirt = "http://www.roblox.com/asset/?id=4388183031",
        pants = "http://www.roblox.com/asset/?id=15718829956",
    },
    {
        label = "Grinch",
        -- Accesorio de cabeza, camisa clásica y pantalones clásicos.
        items = {121354733304545},
        shirt = "http://www.roblox.com/asset/?id=74526050770162",
        pants = "http://www.roblox.com/asset/?id=119203099863018",
    },

}

local currentOutfitIndex = 1
headlessIndependentEnabled = false
korbloxRightIndependentEnabled = false
headlessIndependentSetVisual = nil
korbloxRightIndependentSetVisual = nil
independentCosmeticSelector = nil
independentAppearanceCache = _sharedEnv.__HZIndependentAppearanceCache or independentAppearanceCache

if type(independentAppearanceCache) ~= "table" then
    independentAppearanceCache = setmetatable({}, {__mode = "k"})
end

_sharedEnv.__HZIndependentAppearanceCache = independentAppearanceCache
appearanceRecoveryConnections = setmetatable({}, {__mode = "k"})
appearanceRecoveryPending = setmetatable({}, {__mode = "k"})
appearanceRecoveryApplying = setmetatable({}, {__mode = "k"})
local appliedOutfitChar = nil
local appliedOutfitIndex = nil
local outfitAssetTemplateCache = {}
local outfitPreloadPauseUntil = 0

local function loadObjectsStd(id)
    id = tonumber(id) or id
    local cached = outfitAssetTemplateCache[id]
    if cached then
        local clones = {}
        for _, template in ipairs(cached) do
            local ok, clone = pcall(function() return template:Clone() end)
            if ok and clone then table.insert(clones, clone) end
        end
        if #clones > 0 then return clones end
    end
    local ok, res = pcall(function() return game:GetObjects("rbxassetid://" .. tostring(id)) end)
    if not ok or typeof(res) ~= "table" or #res == 0 then
        ok, res = pcall(function() return game:GetService("InsertService"):LoadAsset(id) end)
        if ok and res then res = {res} end
    end
    if not ok or not res or #res == 0 then return nil end
    local templates = {}
    for _, obj in ipairs(res) do
        local saved = obj
        local cloneOk, clone = pcall(function() return saved:Clone() end)
        if cloneOk and clone then table.insert(templates, clone) end
        pcall(function() saved:Destroy() end)
    end
    if #templates == 0 then return nil end
    outfitAssetTemplateCache[id] = templates
    local clones = {}
    for _, template in ipairs(templates) do
        local cloneOk, clone = pcall(function() return template:Clone() end)
        if cloneOk and clone then table.insert(clones, clone) end
    end
    return #clones > 0 and clones or nil
end

local classicClothingTemplateCache = {}

local function resolveClassicClothingTemplate(value, className, propertyName)
    if value == nil then return "" end
    local raw = tostring(value)
    local assetId = tonumber(raw:match("%d+"))
    if not assetId then return raw end
    local key = className .. ":" .. tostring(assetId)
    if classicClothingTemplateCache[key] then return classicClothingTemplateCache[key] end
    local objects = loadObjectsStd(assetId)
    if objects then
        local result
        for _, root in ipairs(objects) do
            local candidates = {root}
            for _, descendant in ipairs(root:GetDescendants()) do table.insert(candidates, descendant) end
            for _, candidate in ipairs(candidates) do
                if candidate:IsA(className) then
                    local ok, template = pcall(function() return candidate[propertyName] end)
                    if ok and template and template ~= "" then result = template; break end
                end
            end
            pcall(function() root:Destroy() end)
            if result then break end
        end
        if result then
            classicClothingTemplateCache[key] = result
            return result
        end
    end
    return raw
end

local function applyHeadlessKorblox(char)
    if not char then return end
    local head = char:FindFirstChild("Head")
    if head then
        head.Transparency = 1
        head.CanCollide = false
        head.LocalTransparencyModifier = 1
        local face = head:FindFirstChild("face")
        if face then face.Transparency = 1 end
    end
    -- Mantener el cuello conectado para que el rig y las animaciones no se desestabilicen.
    for _, v in pairs(char:GetChildren()) do
        if v:IsA("Accessory") then
            local w = v:FindFirstChildWhichIsA("Weld") or v:FindFirstChildWhichIsA("WeldConstraint") or v:FindFirstChildWhichIsA("Motor6D")
            if w then
                local p0, p1 = w.Part0, w.Part1
                if ((p0 and p0.Name == "Head") or (p1 and p1.Name == "Head"))
                    and v.Name:sub(1, #OUTFIT_TAG) ~= OUTFIT_TAG then
                    v.Parent = nil
                end
            end
        end
    end
    local rightLegConfig = {
        id = "rbxassetid://139607718",
        targetBodyPart = "RightUpperLeg",
        partsToHide = {"RightUpperLeg", "RightLowerLeg", "RightFoot"},
        scale = _V3new(1, 1, 1),
        offset = _CFnew(0, 0, 0)
    }
    local targetPart = char:FindFirstChild(rightLegConfig.targetBodyPart)
    if targetPart then
        local oldAsset = char:FindFirstChild("Korblox_RightLeg")
        if oldAsset then oldAsset:Destroy() end
        for _, partName in ipairs(rightLegConfig.partsToHide) do
            local limb = char:FindFirstChild(partName)
            if limb and limb:IsA("BasePart") then limb.Transparency = 1 end
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

local function attachVX7OutfitItems(char, items, bodyVisual)
    if not items then return end
    local head = char:FindFirstChild("Head")
    local root = char:FindFirstChild("HumanoidRootPart") or head
    local function findAttachment(name)
        for _, part in ipairs(char:GetChildren()) do
            if part:IsA("BasePart") then
                local a = part:FindFirstChild(name)
                if a and a:IsA("Attachment") then return a end
            end
        end
    end
    local function sanitize(obj)
        for _, d in ipairs(obj:GetDescendants()) do
            if d:IsA("LuaSourceContainer") then
                d:Destroy()
            elseif d:IsA("BasePart") then
                d.Anchored = false
                d.CanCollide = false
                d.CanTouch = false
                d.CanQuery = false
                d.Massless = true
            end
        end
    end
    for _, assetId in ipairs(items) do
        -- Ceder un frame entre assets evita congelar el render al cambiar de V.
        task.wait()
        local objects = loadObjectsStd(assetId)
        if objects then
            for _, sourceRoot in ipairs(objects) do
                local candidates = {sourceRoot}
                for _, descendant in ipairs(sourceRoot:GetDescendants()) do
                    table.insert(candidates, descendant)
                end
                for _, source in ipairs(candidates) do
                    if source:IsA("Shirt") or source:IsA("Pants") or source:IsA("ShirtGraphic") then
                        local old = char:FindFirstChildWhichIsA(source.ClassName)
                        if old then old:Destroy() end
                        local clothing = source:Clone()
                        clothing.Name = OUTFIT_TAG .. "VX7Clothing_" .. tostring(assetId)
                        clothing.Parent = char
                    elseif source:IsA("Accessory") then
                        local accessory = source:Clone()
                        local handle = accessory:FindFirstChild("Handle") or accessory:FindFirstChildWhichIsA("BasePart", true)
                        if handle and (head or root) then
                            sanitize(accessory)
                            accessory.Name = OUTFIT_TAG .. "VX7Accessory_" .. tostring(assetId)
                            accessory.Parent = char
                            local sourceAttachment
                            for _, child in ipairs(handle:GetChildren()) do
                                if child:IsA("Attachment") then
                                    sourceAttachment = child
                                    break
                                end
                            end
                            local targetAttachment = sourceAttachment and findAttachment(sourceAttachment.Name)
                            local targetPart = targetAttachment and targetAttachment.Parent or head or root
                            if targetAttachment and targetPart and targetPart:IsA("BasePart") then
                                handle.CFrame = targetAttachment.WorldCFrame * sourceAttachment.CFrame:Inverse()
                            else
                                handle.CFrame = targetPart.CFrame
                            end
                            local weld = Instance.new("WeldConstraint")
                            weld.Name = "OceanVX7OutfitWeld"
                            weld.Part0 = handle
                            weld.Part1 = targetPart
                            weld.Parent = handle
                        else
                            accessory:Destroy()
                        end
                    elseif bodyVisual and source:IsA("BasePart") and not source:FindFirstAncestorWhichIsA("Accessory") and root then
                        local partName = source.Name
                        local target = char:FindFirstChild(partName)
                        if target and target:IsA("BasePart") then
                            local visual = source:Clone()
                            sanitize(visual)
                            visual.Name = OUTFIT_TAG .. "VX7Body_" .. tostring(assetId)
                            visual.CFrame = target.CFrame
                            visual.Parent = char
                            local weld = Instance.new("WeldConstraint")
                            weld.Name = "OceanVX7OutfitWeld"
                            weld.Part0 = visual
                            weld.Part1 = target
                            weld.Parent = visual
                        end
                    end
                end
                pcall(function() sourceRoot:Destroy() end)
            end
        end
    end
end

function _freshAttachLocalOutfitAccessories(char, assetIds)
    local humanoid = char and char:FindFirstChildOfClass("Humanoid")
    if not char or not humanoid or type(assetIds) ~= "table" then return 0 end
    local added = 0
    local needsRigBuild = false
    for _, assetId in ipairs(assetIds) do
        task.wait()
        local objects = loadObjectsStd(assetId)
        local accessory = nil
        if objects then
            for _, root in ipairs(objects) do
                local candidates = {root}
                local descendantsOk, descendants = pcall(function() return root:GetDescendants() end)
                if descendantsOk and descendants then
                    for _, descendant in ipairs(descendants) do table.insert(candidates, descendant) end
                end
                for _, candidate in ipairs(candidates) do
                    if candidate:IsA("Accessory") then
                        local cloneOk, clone = pcall(function() return candidate:Clone() end)
                        if cloneOk and clone then accessory = clone; break end
                    end
                end
                if accessory then break end
            end
            for _, root in ipairs(objects) do pcall(function() root:Destroy() end) end
        end

        local handle = accessory and accessory:FindFirstChild("Handle")
        if not accessory or not handle or not handle:IsA("BasePart") then
            warn("[HZ HUB] No se pudo obtener un Accessory valido para el asset " .. tostring(assetId))
            if accessory then pcall(function() accessory:Destroy() end) end
        else
            accessory.Name = OUTFIT_TAG .. "Y2KAccessory_" .. tostring(assetId)
            for _, descendant in ipairs(accessory:GetDescendants()) do
                if descendant:IsA("LuaSourceContainer") then
                    pcall(function() descendant:Destroy() end)
                elseif descendant:IsA("BasePart") then
                    pcall(function()
                        descendant.Anchored = false
                        descendant.CanCollide = false
                        descendant.CanTouch = false
                        descendant.CanQuery = false
                        descendant.Massless = true
                    end)
                end
            end
            local addOk, addErr = pcall(function() humanoid:AddAccessory(accessory) end)
            if not addOk then
                warn("[HZ HUB] AddAccessory fallo para " .. tostring(assetId) .. ": " .. tostring(addErr))
                needsRigBuild = true
                pcall(function() accessory.Parent = char end)
            end
            if accessory.Parent ~= char then
                pcall(function() accessory.Parent = char end)
            end
            if accessory.Parent == char then
                added = added + 1
                local hasWeld = false
                for _, node in ipairs(handle:GetDescendants()) do
                    if node:IsA("Weld") or node:IsA("WeldConstraint") or node:IsA("Motor6D") then
                        hasWeld = true
                        break
                    end
                end
                if not hasWeld then needsRigBuild = true end
            else
                warn("[HZ HUB] Roblox no permitio parentar el asset " .. tostring(assetId) .. " al personaje")
                pcall(function() accessory:Destroy() end)
            end
        end
    end
    if needsRigBuild then
        local rigOk, rigErr = pcall(function() humanoid:BuildRigFromAttachments() end)
        if not rigOk then warn("[HZ HUB] BuildRigFromAttachments fallo: " .. tostring(rigErr)) end
    end
    if added < #assetIds then
        warn("[HZ HUB] Outfit incompleto: " .. tostring(added) .. "/" .. tostring(#assetIds) .. " accesorios anadidos. Revisa acceso de Roblox a los assets.")
    end
    return added
end

function applyKatanaSkin(char)
    if not char or not char.Parent then return end
    local state = katanaSkinStates[char]
    if not state then
        state = {colors = {}, decals = {}}
        katanaSkinStates[char] = state
    end
    local torsoNames = {"UpperTorso", "LowerTorso", "Torso"}
    for _, name in ipairs(torsoNames) do
        local part = char:FindFirstChild(name)
        if part and part:IsA("BasePart") then
            if state.colors[part] == nil then state.colors[part] = part.Color end
            part.Color = Color3.fromRGB(231, 226, 239)
            local hasFront, hasBack = false, false
            for _, child in ipairs(part:GetChildren()) do
                if child:IsA("Decal") and child.Name == "FreshKatanaSkin" then
                    if child.Face == Enum.NormalId.Front then hasFront = true end
                    if child.Face == Enum.NormalId.Back then hasBack = true end
                end
            end
            for _, face in ipairs({Enum.NormalId.Front, Enum.NormalId.Back}) do
                if (face == Enum.NormalId.Front and not hasFront) or (face == Enum.NormalId.Back and not hasBack) then
                    local decal = Instance.new("Decal")
                    decal.Name = "FreshKatanaSkin"
                    decal.Texture = "rbxassetid://159454286"
                    decal.Face = face
                    decal.Parent = part
                    table.insert(state.decals, decal)
                end
            end
        end
    end
end

function removeKatanaSkin(char)
    if not char then return end
    local state = katanaSkinStates[char]
    if not state then return end
    for _, decal in ipairs(state.decals) do
        if decal and decal.Parent then pcall(function() decal:Destroy() end) end
    end
    for part, color in pairs(state.colors) do
        if part and part.Parent then pcall(function() part.Color = color end) end
    end
    katanaSkinStates[char] = nil
end

function removeRetiredLocalAccessory(char)
    if not char then return end
    local retiredName = OUTFIT_TAG .. "Y2KAccessory_" .. "125896132362006"
    local retired = char:FindFirstChild(retiredName)
    if retired then pcall(function() retired:Destroy() end) end
end

local function applyVX7HeadlessOnly(char)
    local head = char:FindFirstChild("Head")
    if head then
        head.Transparency = 1
        head.CanCollide = false
        head.LocalTransparencyModifier = 1
        for _, d in ipairs(head:GetDescendants()) do
            if d:IsA("Decal") or d:IsA("Texture") then d.Transparency = 1 end
        end
    end
    -- Neck permanece habilitado para conservar la articulacion del personaje.
end

function applyOutfitByIndex(index)
    local cfg = OUTFITS[index]
    if not cfg then return end
    local char = LP.Character
    if not char then return end
    if appliedOutfitChar == char and appliedOutfitIndex == index then return end
    if appliedOutfitChar == char and appliedOutfitIndex and OUTFITS[appliedOutfitIndex]
        and OUTFITS[appliedOutfitIndex].dynamicHeadAsset
        and not cfg.dynamicHeadAsset and not cfg.customApply then
        _freshRestoreOriginalHumanoidDescription(char)
    end
    outfitPreloadPauseUntil = os.clock() + 2
    if clearIndependentAppearance then clearIndependentAppearance(char) end
    if cfg.customApply then
        cfg.customApply(char)
        if applyIndependentAppearance then applyIndependentAppearance(char) end
        appliedOutfitChar = char
        appliedOutfitIndex = index
        return
    end
    cacheOriginalAppearance(char)
    FullBody.restore(char)
    applyNoOutfit(char, false)
    if cfg.fullBody then
        FullBody.hide(char)
    end

    char:WaitForChild("Head", 5)
    local head = char:FindFirstChild("Head")
    if not head then return end
    if cfg.dynamicHeadAsset then
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        if humanoid then
            local description
            local fetched = pcall(function()
                description = humanoid:GetAppliedDescription()
            end)
            if fetched and description then
                if cfg.dynamicHeadAsset then
                    pcall(function() description.Head = cfg.dynamicHeadAsset end)
                    if cfg.dynamicHeadMood then
                        pcall(function() description.MoodAnimation = cfg.dynamicHeadMood end)
                    end
                end
                pcall(function() description.Shirt = 0 end)
                pcall(function() description.Pants = 0 end)
                pcall(function() description.GraphicTShirt = 0 end)
                pcall(function() description:SetAccessories({}, true) end)
                if _freshApplyHumanoidDescription(humanoid, description) then
                    head = char:WaitForChild("Head", 5) or char:FindFirstChild("Head") or head
                end
                pcall(function() description:Destroy() end)
            end
        end
    end
    if cfg.headMesh then
        for _, d in ipairs(char:GetChildren()) do
            if d:IsA("CharacterMesh") and d.BodyPart == Enum.BodyPart.Head then
                pcall(function() d:Destroy() end)
            end
        end
        local done = false
        if head:IsA("MeshPart") then
            done = pcall(function()
                head.MeshId = cfg.headMesh
                if cfg.headTexture then head.TextureID = cfg.headTexture end
            end)
        end
        if not done then
            local sm = head:FindFirstChildWhichIsA("SpecialMesh") or Instance.new("SpecialMesh")
            sm.Parent = head
            sm.MeshType = Enum.MeshType.FileMesh
            sm.MeshId = cfg.headMesh
            sm.TextureId = cfg.headTexture or ""
        end
    end
    if cfg.items then
        attachVX7OutfitItems(char, cfg.items, cfg.bodyVisual)
    end
    if cfg.localAccessoryIds then
        _freshAttachLocalOutfitAccessories(char, cfg.localAccessoryIds)
    end
    if cfg.torsoMesh then
        local torso = char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso")
        if torso then
            local oldTorsoMesh = torso:FindFirstChild("OceanZurichTorsoMesh")
            if oldTorsoMesh then oldTorsoMesh:Destroy() end
            local torsoMesh = Instance.new("SpecialMesh")
            torsoMesh.Name = "OceanZurichTorsoMesh"
            torsoMesh.MeshType = Enum.MeshType.FileMesh
            torsoMesh.MeshId = cfg.torsoMesh
            torsoMesh.Parent = torso
        end
    end
    if cfg.shirt then
        local s = char:FindFirstChildWhichIsA("Shirt") or Instance.new("Shirt")
        s.Name = "Shirt"
        s.ShirtTemplate = resolveClassicClothingTemplate(cfg.shirt, "Shirt", "ShirtTemplate")
        s.Parent = char
    end
    if cfg.pants then
        local p = char:FindFirstChildWhichIsA("Pants") or Instance.new("Pants")
        p.Name = "Pants"
        p.PantsTemplate = resolveClassicClothingTemplate(cfg.pants, "Pants", "PantsTemplate")
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
    if cfg.headlessOnly then
        applyVX7HeadlessOnly(char)
    elseif cfg.headlessKorblox then
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
    if cfg.hideLeft or cfg.hideRight then
        local leftParts = {"LeftUpperLeg", "LeftLowerLeg", "LeftFoot", "Left Leg"}
        local rightParts = {"RightUpperLeg", "RightLowerLeg", "RightFoot", "Right Leg"}
        if cfg.hideLeft then
            for _, name in ipairs(leftParts) do
                local part = char:FindFirstChild(name)
                if part then part.Transparency = 1 end
            end
        end
        if cfg.hideRight then
            for _, name in ipairs(rightParts) do
                local part = char:FindFirstChild(name)
                if part then part.Transparency = 1 end
            end
        end
    end
    if applyIndependentAppearance then applyIndependentAppearance(char) end
    appliedOutfitChar = char
    appliedOutfitIndex = index
end

-- Cola unica para cambios de skin; el evento de UI nunca hace la descarga directamente.
local _outfitApplyBusy = false

local _outfitApplyPending = nil

local function requestOutfitApply(index)
    _outfitApplyPending = index
    if _outfitApplyBusy then return end
    _outfitApplyBusy = true
    task.spawn(function()
        while _outfitApplyPending ~= nil do
            local nextIndex = _outfitApplyPending
            _outfitApplyPending = nil
            pcall(applyOutfitByIndex, nextIndex)
            task.wait()
        end
        _outfitApplyBusy = false
        if LP.Character then
            if selectedCosmeticsNeedRecovery and selectedCosmeticsNeedRecovery(LP.Character) then
                pcall(reapplySelectedCharacterCosmetics, LP.Character)
            end
            bindAppearanceRecovery(LP.Character)
        end
    end)
end

function clearIndependentAppearance(char)
    if not char then return end
    local saved = independentAppearanceCache[char]
    if not saved then
        local oldKorblox = char:FindFirstChild("FreshIndependentKorbloxRight")
        if oldKorblox then pcall(function() oldKorblox:Destroy() end) end
        return
    end
    if saved.korbloxModel and saved.korbloxModel.Parent then
        pcall(function() saved.korbloxModel:Destroy() end)
    end
    for instance, state in pairs(saved.transparency or {}) do
        if instance and instance.Parent then
            pcall(function()
                if state.transparency ~= nil then instance.Transparency = state.transparency end
                if state.localTransparencyModifier ~= nil then instance.LocalTransparencyModifier = state.localTransparencyModifier end
                if state.canCollide ~= nil then instance.CanCollide = state.canCollide end
            end)
        end
    end
    if saved.neck and saved.neck.Parent then
        pcall(function() saved.neck.Enabled = saved.neckEnabled end)
    end
    independentAppearanceCache[char] = nil
end

function applyIndependentAppearance(char)
    char = char or LP.Character
    if not char then return end
    clearIndependentAppearance(char)
    local selectedOutfit = OUTFITS[currentOutfitIndex]
    local independentKorbloxAllowed = not (selectedOutfit and selectedOutfit.noKorblox)
    if not headlessIndependentEnabled and not (korbloxRightIndependentEnabled and independentKorbloxAllowed) then return end

    local saved = {transparency = {}, korbloxModel = nil}
    independentAppearanceCache[char] = saved
    local function hideAndSave(instance)
        if not instance or not instance.Parent or saved.transparency[instance] then return end
        local state = {}
        pcall(function() state.transparency = instance.Transparency end)
        pcall(function() state.localTransparencyModifier = instance.LocalTransparencyModifier end)
        pcall(function() state.canCollide = instance.CanCollide end)
        saved.transparency[instance] = state
        pcall(function() instance.Transparency = 1 end)
        pcall(function() instance.LocalTransparencyModifier = 1 end)
    end

    if headlessIndependentEnabled then
        local head = char:FindFirstChild("Head")
        if head then
            hideAndSave(head)
            -- Oculta la cabeza y quita su colision, pero conserva el Neck Motor6D
            -- habilitado: desactivarlo puede romper animaciones y desestabilizar el rig.
            pcall(function() head.CanCollide = false end)
            for _, descendant in ipairs(head:GetDescendants()) do
                if descendant:IsA("Decal") or descendant:IsA("Texture") then hideAndSave(descendant) end
            end
        end
    end

    if korbloxRightIndependentEnabled and independentKorbloxAllowed then
        local target = char:FindFirstChild("RightUpperLeg") or char:FindFirstChild("Right Leg")
        if target and target:IsA("BasePart") then
            local objects = loadObjectsStd(139607718)
            if objects and #objects > 0 then
                local root = objects[1]
                local mesh = root:IsA("BasePart") and root or root:FindFirstChildWhichIsA("BasePart", true)
                if mesh then
                    for _, name in ipairs({"RightUpperLeg", "RightLowerLeg", "RightFoot", "Right Leg"}) do
                        local limb = char:FindFirstChild(name)
                        if limb and limb:IsA("BasePart") then hideAndSave(limb) end
                    end
                    root.Name = "FreshIndependentKorbloxRight"
                    pcall(function()
                        mesh.Anchored = false
                        mesh.CanCollide = false
                        mesh.CanTouch = false
                        mesh.CanQuery = false
                        mesh.Massless = true
                        mesh.CFrame = target.CFrame
                    end)
                    local weld = Instance.new("WeldConstraint")
                    weld.Part0 = target
                    weld.Part1 = mesh
                    weld.Parent = mesh
                    root.Parent = char
                    saved.korbloxModel = root
                else
                    pcall(function() root:Destroy() end)
                end
                for i = 2, #objects do pcall(function() objects[i]:Destroy() end) end
            end
        end
    end
end

function getIndependentCosmeticMode()
    if headlessIndependentEnabled and korbloxRightIndependentEnabled then return "Both" end
    if headlessIndependentEnabled then return "Headless" end
    if korbloxRightIndependentEnabled then return "Korblox" end
    return "Off"
end

function syncIndependentCosmeticSelector()
    if independentCosmeticSelector and independentCosmeticSelector.Parent then
        independentCosmeticSelector.Text = getIndependentCosmeticMode()
    end
end

function setIndependentHeadless(enabled)
    headlessIndependentEnabled = enabled == true
    applyIndependentAppearance(LP.Character)
    if headlessIndependentSetVisual then pcall(headlessIndependentSetVisual, headlessIndependentEnabled) end
    syncIndependentCosmeticSelector()
    if not _isLoading then pcall(saveAllSettings) end
end

function setIndependentKorbloxRight(enabled)
    korbloxRightIndependentEnabled = enabled == true
    applyIndependentAppearance(LP.Character)
    if korbloxRightIndependentSetVisual then pcall(korbloxRightIndependentSetVisual, korbloxRightIndependentEnabled) end
    syncIndependentCosmeticSelector()
    if not _isLoading then pcall(saveAllSettings) end
end

function reapplySelectedCharacterCosmetics(char)
    if not char or LP.Character ~= char then return end
    local cfg = OUTFITS[currentOutfitIndex]
    if cfg then
        if cfg.headlessOnly then
            applyVX7HeadlessOnly(char)
        elseif cfg.headlessKorblox then
            applyHeadlessKorblox(char)
        end
    end
    if headlessIndependentEnabled or korbloxRightIndependentEnabled then
        applyIndependentAppearance(char)
    end
    if katanaSkinEnabled then applyKatanaSkin(char) end
end

function selectedCosmeticsNeedRecovery(char)
    if not char then return false end
    local cfg = OUTFITS[currentOutfitIndex]
    local outfitHeadless = cfg and (cfg.headlessOnly or cfg.headlessKorblox)
    local outfitKorblox = cfg and cfg.headlessKorblox
    local wantHeadless = headlessIndependentEnabled or outfitHeadless
    local independentKorbloxAllowed = not (cfg and cfg.noKorblox)
    local wantKorblox = (korbloxRightIndependentEnabled and independentKorbloxAllowed) or outfitKorblox
    if not wantHeadless and not wantKorblox then return false end

    if wantHeadless then
        local head = char:FindFirstChild("Head")
        if not head or head.Transparency < 0.99 or head.CanCollide then
            return true
        end
        for _, decal in ipairs(head:GetDescendants()) do
            if (decal:IsA("Decal") or decal:IsA("Texture")) and decal.Transparency < 0.99 then
                return true
            end
        end
    end


    if wantKorblox then
        local limbNames = {"RightUpperLeg", "RightLowerLeg", "RightFoot", "Right Leg"}
        for _, name in ipairs(limbNames) do
            local limb = char:FindFirstChild(name)
            if limb and limb:IsA("BasePart") and limb.Transparency < 0.99 then return true end
        end
        if korbloxRightIndependentEnabled and independentKorbloxAllowed and not char:FindFirstChild("FreshIndependentKorbloxRight") then
            return true
        end
        if outfitKorblox and not char:FindFirstChild("Korblox_RightLeg") then
            return true
        end
    end
    return false
end

function scheduleAppearanceRecovery(char)
    if not char or LP.Character ~= char or appearanceRecoveryApplying[char] or appearanceRecoveryPending[char] then return end
    appearanceRecoveryPending[char] = true
    task.delay(0.45, function()
        appearanceRecoveryPending[char] = nil
        if not char.Parent or LP.Character ~= char then return end
        -- Medusa puede anclar y ocultar partes; esperar a que libere el rig.
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") and part.Anchored then return end
        end
        if not selectedCosmeticsNeedRecovery(char) then return end
        appearanceRecoveryApplying[char] = true
        pcall(reapplySelectedCharacterCosmetics, char)
        appearanceRecoveryApplying[char] = nil
    end)
end

function bindAppearanceRecovery(char)
    if not char then return end
    if appearanceRecoveryConnections[char] then return end
    local record = {parts = {}}
    appearanceRecoveryConnections[char] = record
    local function watchPart(part)
        if not part:IsA("BasePart") or record.parts[part] then return end
        local connections = {}
        for _, property in ipairs({"Transparency", "LocalTransparencyModifier", "Anchored"}) do
            local ok, conn = pcall(function()
                return part:GetPropertyChangedSignal(property):Connect(function()
                    scheduleAppearanceRecovery(char)
                end)
            end)
            if ok and conn then table.insert(connections, conn) end
        end
        record.parts[part] = connections
    end
    for _, descendant in ipairs(char:GetDescendants()) do watchPart(descendant) end
    record.added = char.DescendantAdded:Connect(function(instance)
        watchPart(instance)
        if instance.Name == "Head" or instance.Name == "Korblox_RightLeg"
            or instance.Name == "FreshIndependentKorbloxRight" then
            scheduleAppearanceRecovery(char)
        end
    end)
    record.removing = char.DescendantRemoving:Connect(function(instance)
        if instance.Name == "Korblox_RightLeg" or instance.Name == "FreshIndependentKorbloxRight" then
            scheduleAppearanceRecovery(char)
        end
    end)
end

removeAccessoriesEnabled = false

-- ============================================================
-- 8. SKINS Y SONIDOS DEL BATE / MEDUSA
-- ============================================================
-- Skin Minecraft estilo espada pixelada, integrada desde el modulo adjunto.
local BAT_SKIN_OPTIONS = {"Off", "Katana", "Minecraft Bat"}

local BAT_SKIN_DATA = {
    Katana = {
        mesh = "rbxassetid://13528902482",
        tex = "rbxassetid://13528902373",
        scale = Vector3.new(1.4, 1.4, 1.4),
        c0 = CFrame.new(0, 0.6, 0) * CFrame.Angles(math.rad(270), math.rad(180), math.rad(180)),
    },
}

local MEDUSA_SKIN_OPTIONS = {"Off", "GoldenDeagle", "Skull"}

local MEDUSA_SKIN_DATA = {
    GoldenDeagle = {
        mesh = "rbxassetid://430251413",
        tex = "rbxassetid://435840335",
        scale = Vector3.new(0.01, 0.01, 0.01),
        c0 = CFrame.new(0, 0, -0.8) * CFrame.Angles(math.rad(330), math.rad(180), 0),
    },
    Skull = {
        mesh = "rbxassetid://2050312704",
        tex = "rbxassetid://2050313393",
        scale = Vector3.new(1, 1, 1),
        c0 = CFrame.new(0, 0.65, -0.4) * CFrame.Angles(math.rad(330), 0, 0),
    },
}

local function getBatSkinIndex(skinName)
    for index, name in ipairs(BAT_SKIN_OPTIONS) do
        if name == skinName then return index end
    end
    return 1
end

local function getMedusaSkinIndex(skinName)
    for index, name in ipairs(MEDUSA_SKIN_OPTIONS) do
        if name == skinName then return index end
    end
    return 1
end

local currentBatSkin = "Off"
local batSkinIndex = 1
local batSkinState = setmetatable({}, {__mode = "k"})
local currentMedusaSkin = "Off"
local medusaSkinIndex = 1

local function isBatSkinTool(tool)
    if not tool or not tool:IsA("Tool") then return false end
    local name = tool.Name:lower()
    return name:find("bat") or name:find("slap") or name:find("sword")
end

local function restoreBatSkinTool(tool)
    local state = batSkinState[tool]
    if state and state.flashConn then
        pcall(function() state.flashConn:Disconnect() end)
    end
    if state and state.handle and state.handle.Parent then
        state.handle.Transparency = state.transparency
        state.handle.CanQuery = state.canQuery
        state.handle.CanTouch = state.canTouch
    end
    if state and state.replica and state.replica.Parent then
        state.replica:Destroy()
    end
    batSkinState[tool] = nil
end

local function beginBatSkinReplica(tool, replicaName)
    local handle = tool and tool:FindFirstChild("Handle")
    if not handle or not handle:IsA("BasePart") then return nil, nil end

    restoreBatSkinTool(tool)
    local state = {
        handle = handle,
        transparency = handle.Transparency,
        canQuery = handle.CanQuery,
        canTouch = handle.CanTouch,
    }
    batSkinState[tool] = state
                handle.Transparency = 1
                -- El Handle original debe seguir siendo detectable por el juego.
                -- Desactivar CanTouch puede impedir que el bate registre golpes.
                handle.CanQuery = true
                handle.CanTouch = true

    local model = Instance.new("Model")
    model.Name = replicaName
    model.Parent = handle
    state.replica = model
    return handle, model
end

local function addMinecraftBlock(model, handle, name, size, offset, color, material)
    local part = Instance.new("Part")
    part.Name = name
    part.Size = size
    part.CFrame = handle.CFrame * offset
    part.Color = color
    part.Material = material or Enum.Material.SmoothPlastic
    part.CanCollide = false
    part.CanQuery = false
    part.CanTouch = false
    part.Massless = true
    part.CastShadow = false
    part.Parent = model

    local weld = Instance.new("WeldConstraint")
    weld.Part0 = handle
    weld.Part1 = part
    weld.Parent = part
    return part
end

local function buildAssetBatSkin(tool, skinKey, dataSet)
    local data = (dataSet or BAT_SKIN_DATA)[skinKey]
    if not data then return end
    local handle, model = beginBatSkinReplica(tool, "VX7" .. skinKey .. "BatSkin")
    if not handle or not model then return end

    local part = Instance.new("Part")
    part.Name = "MainPart"
    part.Size = Vector3.new(1, 1, 1)
    part.Transparency = 0
    part.CanCollide = false
    part.CanQuery = false
    part.CanTouch = false
    part.Massless = true
    part.CastShadow = false
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
end

local function applyBatSkinToTool(tool)
    if not isBatSkinTool(tool) then return end
    if minecraftBatSkinEnabled == true then
        restoreBatSkinTool(tool)
        return
    end
    if BAT_SKIN_DATA[currentBatSkin] then
        buildAssetBatSkin(tool, currentBatSkin)
    else
        restoreBatSkinTool(tool)
    end
end

local function isMedusaSkinTool(tool)
    if not tool or not tool:IsA("Tool") then return false end
    local name = tool.Name:lower()
    return name:find("medusa") or name:find("head")
end

local function applyMedusaSkinToTool(tool)
    if not isMedusaSkinTool(tool) then return end
    if MEDUSA_SKIN_DATA[currentMedusaSkin] then
        buildAssetBatSkin(tool, currentMedusaSkin, MEDUSA_SKIN_DATA)
    else
        restoreBatSkinTool(tool)
    end
end

local function applyBatSkinToCharacter()
    local char = LP.Character
    local backpack = LP:FindFirstChildOfClass("Backpack")
    for _, container in ipairs({char, backpack}) do
        if container then
            for _, child in ipairs(container:GetChildren()) do
                if child:IsA("Tool") then
                    task.defer(applyBatSkinToTool, child)
                    task.defer(applyMedusaSkinToTool, child)
                end
            end
        end
    end
    if _G.__FreshRefreshCustomSounds then
        task.defer(_G.__FreshRefreshCustomSounds)
    end
end

local function scheduleBatSkinRefresh()
    -- Solo dos pasadas: evita tres escaneos completos al reaparecer.
    task.defer(applyBatSkinToCharacter)
    task.delay(0.35, applyBatSkinToCharacter)
end

local function hookBatSkinCharacter(char)
    for _, child in ipairs(char:GetChildren()) do
        if child:IsA("Tool") then
            task.defer(applyBatSkinToTool, child)
            task.defer(applyMedusaSkinToTool, child)
        end
    end
    char.ChildAdded:Connect(function(child)
        if child:IsA("Tool") then
            scheduleBatSkinRefresh()
            child.ChildAdded:Connect(function(descendant)
                if descendant.Name == "Handle" then
                    task.defer(applyBatSkinToTool, child)
                    task.defer(applyMedusaSkinToTool, child)
                end
            end)
        end
    end)
end

if LP.Character then hookBatSkinCharacter(LP.Character) end
LP.CharacterAdded:Connect(hookBatSkinCharacter)
local backpack = LP:FindFirstChildOfClass("Backpack")

if backpack then
    backpack.ChildAdded:Connect(function(child)
        if child:IsA("Tool") then
            scheduleBatSkinRefresh()
            child.ChildAdded:Connect(function(descendant)
                if descendant.Name == "Handle" then
                    task.defer(applyBatSkinToTool, child)
                    task.defer(applyMedusaSkinToTool, child)
                end
            end)
        end
    end)
end

-- Independiente de las skins; sustituye temporalmente solo el audio del bate.
local customSoundState = setmetatable({}, {__mode = "k"})

local customSoundHooked = setmetatable({}, {__mode = "k"})
local customSoundWatchers = setmetatable({}, {__mode = "k"})

local CUSTOM_SOUND_DATA = {
    Bat = {id = "rbxassetid://5713085119", skip = 0.2},
    -- Medusa no se reemplaza: conserva el audio predeterminado del juego.
}

local function getCustomSoundKind(tool)
    if not tool or not tool:IsA("Tool") then return nil end
    local name = tool.Name:lower()
    -- Excluir explicitamente Medusa para no silenciar ni sustituir su audio nativo.
    if name:find("medusa") or name:find("head") or name:find("stone")
       or name:find("eagle") or name:find("deagle") then
        return nil
    end
    if name:find("bat") or name:find("slap") then
        if currentBatSkin == "Katana" and minecraftBatSkinEnabled ~= true then
            return "Bat"
        end
    end
    return nil
end

local function teardownCustomSoundTool(tool)
    local state = customSoundState[tool]
    if not state then return end
    if state.timer then pcall(task.cancel, state.timer) end
    for _, conn in ipairs(state.conns or {}) do pcall(function() conn:Disconnect() end) end
    if state.custom and state.custom.Parent then pcall(function() state.custom:Destroy() end) end
    for snd, volume in pairs(state.muted or {}) do
        customSoundHooked[snd] = nil
        if snd and snd.Parent then pcall(function() snd.Volume = volume end) end
    end
    customSoundState[tool] = nil
end

local function playCustomToolSound(state, allowDouble)
    if not state or not state.custom or not state.custom.Parent then return end
    local data = state.data
    pcall(function()
        state.custom:Stop()
        state.custom.TimePosition = data.skip or 0
        state.custom.Volume = 1
        state.custom:Play()
    end)
    if allowDouble ~= false and data.doublePlay and data.delay then
        if state.timer then pcall(task.cancel, state.timer) end
        state.timer = task.delay(data.delay, function()
            state.timer = nil
            if customSoundsEnabled then playCustomToolSound(state, false) end
        end)
    end
end

local function hookCustomSound(state, snd)
    if not snd:IsA("Sound") or snd.Name == "CustomSound" then return end
    if customSoundHooked[snd] then return end
    state.muted[snd] = snd.Volume
    customSoundHooked[snd] = true
    local function trigger()
        if not customSoundsEnabled then return end
        if state.kind == "Bat" and currentBatSkin ~= "Katana" then return end
        if snd.Playing or snd.TimePosition > 0 then
            pcall(function() snd.Volume = 0; snd:Stop() end)
            playCustomToolSound(state)
        end
    end
    -- TimePosition cambia durante la reproduccion y podia disparar el reemplazo
    -- varias veces dentro de una sola ventana de impacto. Solo escuchamos Playing.
    local c1 = snd:GetPropertyChangedSignal("Playing"):Connect(trigger)
    table.insert(state.conns, c1)
    local c3
    c3 = snd.AncestryChanged:Connect(function(_, parent)
        if parent then return end
        customSoundHooked[snd] = nil
        state.muted[snd] = nil
        pcall(function() c1:Disconnect(); c3:Disconnect() end)
    end)
    table.insert(state.conns, c3)
    if snd.Playing then trigger() end
end

local function setupCustomSoundTool(tool)
    local kind = getCustomSoundKind(tool)
    if not kind or customSoundState[tool] then return end
    local handle = tool:FindFirstChild("Handle")
    if not handle then return end
    local data = CUSTOM_SOUND_DATA[kind]
    local custom = Instance.new("Sound")
    custom.Name = "CustomSound"
    custom.SoundId = data.id
    custom.Volume = 1
    custom.Looped = false
    custom.RollOffMode = Enum.RollOffMode.Inverse
    custom.MaxDistance = 1000
    custom.MinDistance = 1000
    custom.Parent = handle
    local state = {kind = kind, custom = custom, data = data, conns = {}, muted = {}, timer = nil}
    customSoundState[tool] = state
    for _, descendant in ipairs(tool:GetDescendants()) do hookCustomSound(state, descendant) end
    table.insert(state.conns, tool.DescendantAdded:Connect(function(descendant)
        if customSoundState[tool] then hookCustomSound(state, descendant) end
    end))
    table.insert(state.conns, tool.AncestryChanged:Connect(function(_, parent)
        if not parent then teardownCustomSoundTool(tool) end
    end))
end

local function refreshCustomSoundTools()
    if not customSoundsEnabled then return end
    for tool in pairs(customSoundState) do teardownCustomSoundTool(tool) end
    for _, container in ipairs({LP.Character, LP:FindFirstChildOfClass("Backpack")}) do
        if container then
            for _, child in ipairs(container:GetChildren()) do
                if child:IsA("Tool") then setupCustomSoundTool(child) end
            end
        end
    end
end

_G.__FreshRefreshCustomSounds = refreshCustomSoundTools

local function setCustomSoundsEnabled(on)
    customSoundsEnabled = on == true
    if customSoundsEnabled then
        refreshCustomSoundTools()
    else
        for tool in pairs(customSoundState) do teardownCustomSoundTool(tool) end
    end
end

local function watchCustomSoundContainer(container)
    if not container or customSoundWatchers[container] then return end
    local conns = {}
    table.insert(conns, container.ChildAdded:Connect(function(child)
        if customSoundsEnabled and child:IsA("Tool") then
            task.defer(setupCustomSoundTool, child)
        end
    end))
    customSoundWatchers[container] = conns
    for _, child in ipairs(container:GetChildren()) do
        if customSoundsEnabled and child:IsA("Tool") then setupCustomSoundTool(child) end
    end
end

if LP.Character then watchCustomSoundContainer(LP.Character) end
if backpack then watchCustomSoundContainer(backpack) end

LP.CharacterAdded:Connect(function(char)
    task.defer(function() watchCustomSoundContainer(char); refreshCustomSoundTools() end)
end)

LP.ChildAdded:Connect(function(child)
    if child:IsA("Backpack") then watchCustomSoundContainer(child) end
end)

minecraftBatSkinEnabled = false
minecraftBatSkinColorMode = "Default"
MinecraftBatSetVisual = nil

local MinecraftBatSkin = (function()
    local MB_ASSET_ID = "rbxassetid://18566246244"
    local MB_POS_OFFSET = _CFnew(-0.02, -0.52, -0.2)
    local MB_ROT_OFFSET = CFrame.Angles(math.rad(45), math.rad(0), math.rad(5))
    local MB_SCALE = 2

    local MB_COLORS = {
        ["Default"] = nil,
        ["Dark Yellow"] = STEAL_BAR_COLORS.DARK_YELLOW,
        ["Light Yellow"] = STEAL_BAR_COLORS.LIGHT_YELLOW,
        ["White"] = STEAL_BAR_COLORS.WHITE,
        ["Black"] = STEAL_BAR_COLORS.BLACK,
    }

    local State = {
        enabled = false,
        colorMode = "Default",
        cachedVisualPart = nil,
        rgbConnection = nil,
    }

    local okLoad, objects = pcall(function() return game:GetObjects(MB_ASSET_ID) end)
    if okLoad and objects and #objects > 0 then
        local model = objects[1]
        State.cachedVisualPart = model:IsA("BasePart") and model
            or model:FindFirstChildWhichIsA("BasePart", true)
    end

    local function mbSetColor(visual, color)
        if not visual or not color then return end
        visual.Color = color
        if visual:IsA("UnionOperation") then
            pcall(function() visual.UsePartColor = true end)
        end
        local sm = visual:FindFirstChildWhichIsA("SpecialMesh")
        if sm then
            sm.VertexColor = Vector3.new(color.R, color.G, color.B)
        end
    end

    local function mbFindBat()
        local char = LP.Character
        if char then
            local t = char:FindFirstChild("Bat")
            if t and t:IsA("Tool") then return t end
        end
        local bp = LP:FindFirstChildOfClass("Backpack")
        if bp then
            local t = bp:FindFirstChild("Bat")
            if t and t:IsA("Tool") then return t end
        end
        return nil
    end

    local function mbRemoveVisual(tool)
        if not tool then return end
        local old = tool:FindFirstChild("CustomUnionVisual")
        if old then pcall(function() old:Destroy() end) end
        local handle = tool:FindFirstChild("Handle")
        if handle then
            handle.Transparency = 0
            for _, child in ipairs(handle:GetChildren()) do
                if child:IsA("SpecialMesh") or child:IsA("Mesh") or child:IsA("Decal") then
                    pcall(function() child.Transparency = 0 end)
                end
            end
        end
    end

    local function mbApplyVisual(tool)
        if not tool or tool.Name ~= "Bat" or not State.cachedVisualPart then return end
        local handle = tool:WaitForChild("Handle", 2)
        if not handle then return end

        local oldVisual = tool:FindFirstChild("CustomUnionVisual")
        if oldVisual then oldVisual:Destroy() end

        handle.Transparency = 1
        for _, child in ipairs(handle:GetChildren()) do
            if child:IsA("SpecialMesh") or child:IsA("Mesh") or child:IsA("Decal") then
                pcall(function() child.Transparency = 1 end)
            end
        end

        local newVisual = State.cachedVisualPart:Clone()
        newVisual.Name = "CustomUnionVisual"
        newVisual.CanCollide = false
        newVisual.Massless = true
        newVisual.Anchored = false

        local tempModel = Instance.new("Model")
        newVisual.Parent = tempModel
        tempModel.PrimaryPart = newVisual
        pcall(function() tempModel:ScaleTo(MB_SCALE) end)
        newVisual.Parent = nil
        tempModel:Destroy()

        if State.colorMode == "RGB" then
            mbSetColor(newVisual, STEAL_BAR_COLORS.LIGHT_YELLOW)
        elseif MB_COLORS[State.colorMode] then
            mbSetColor(newVisual, MB_COLORS[State.colorMode])
        end

        for _, child in ipairs(newVisual:GetChildren()) do
            if child:IsA("Weld") or child:IsA("WeldConstraint") then child:Destroy() end
        end

        newVisual.CFrame = handle.CFrame * MB_POS_OFFSET * MB_ROT_OFFSET
        newVisual.Parent = tool

        local weld = Instance.new("WeldConstraint")
        weld.Part0 = handle
        weld.Part1 = newVisual
        weld.Parent = newVisual
    end

    local function mbStartRGB()
        if State.rgbConnection then return end
        State.rgbConnection = RunService.RenderStepped:Connect(function()
            if not State.enabled or State.colorMode ~= "RGB" then return end
            local tool = mbFindBat()
            if not tool then return end
            local visual = tool:FindFirstChild("CustomUnionVisual")
            if visual then
                mbSetColor(visual, STEAL_BAR_COLORS.LIGHT_YELLOW)
            end
        end)
    end

    local function mbStopRGB()
        if State.rgbConnection then
            State.rgbConnection:Disconnect()
            State.rgbConnection = nil
        end
    end

    return {
        State   = State,
        Colors  = MB_COLORS,
        FindBat = mbFindBat,
        Apply   = function()
            if not State.enabled then return end
            local tool = mbFindBat()
            if tool then mbApplyVisual(tool) end
            if State.colorMode == "RGB" then mbStartRGB() end
        end,
        Remove  = function()
            mbStopRGB()
            local char = LP.Character
            if char then
                local t = char:FindFirstChild("Bat")
                if t then mbRemoveVisual(t) end
            end
            local bp = LP:FindFirstChildOfClass("Backpack")
            if bp then
                local t = bp:FindFirstChild("Bat")
                if t then mbRemoveVisual(t) end
            end
        end,
        SetColorMode = function(mode)
            State.colorMode = mode
            if not State.enabled then return end
            if mode == "RGB" then mbStartRGB() else mbStopRGB() end
            local tool = mbFindBat()
            if tool then mbApplyVisual(tool) end
        end,
    }
end)()

function refreshExclusiveBatSkin()
    -- Limpia siempre el visual anterior y aplica solo una skin de arma.
    if minecraftBatSkinEnabled then
        currentBatSkin = "Off"
            pcall(MinecraftBatSkin.Remove)
        MinecraftBatSkin.State.enabled = true
        task.defer(function() pcall(MinecraftBatSkin.Apply) end)
    else
        pcall(MinecraftBatSkin.Remove)
        MinecraftBatSkin.State.enabled = false
        end
end

task.spawn(function()
    while true do
        if minecraftBatSkinEnabled then
            MinecraftBatSkin.State.enabled = true
            local tool = MinecraftBatSkin.FindBat()
            if tool and not tool:FindFirstChild("CustomUnionVisual") then
                pcall(MinecraftBatSkin.Apply)
            end
        else
            MinecraftBatSkin.State.enabled = false
        end
        task.wait(0.5)
    end
end)

-- Sonido personalizado del bate activo automaticamente.
customSoundsEnabled = true

customSoundsSetVisual, setXRayVisual = nil, nil

-- ============================================================
-- 9. X-RAY (PLOTS Y BRAINROTS)
-- ============================================================
-- X-RAY: transparencia reversible de los elementos de los plots.
_G.OceanXRayFolders = {"Base", "PlotSign", "FriendPanel", "Cash", "Laser", "Decorations", "Skin", "Unlock", "Purchases"}

;(function()
    local function disconnectAll(list)
        if type(list) == "table" then
            for _, connection in ipairs(list) do pcall(function() connection:Disconnect() end) end
        end
    end
    local function restoreSnapshot(snapshot, brainrot)
        if type(snapshot) ~= "table" then return end
        for object, original in pairs(snapshot) do
            pcall(function()
                if object:IsA("BasePart") then
                    if brainrot and _G.__OceanXRayBrainrotSnapshotProperty ~= "Transparency" then
                        object.LocalTransparencyModifier = original
                    else
                        object.Transparency = original
                    end
                elseif not brainrot and (object:IsA("TextLabel") or object:IsA("TextButton")) then
                    object.TextTransparency = original.text
                    object.BackgroundTransparency = original.bg
                elseif not brainrot and (object:IsA("Frame") or object:IsA("ScrollingFrame")) then
                    object.BackgroundTransparency = original
                elseif not brainrot and (object:IsA("ImageLabel") or object:IsA("ImageButton")) then
                    object.ImageTransparency = original.img
                    object.BackgroundTransparency = original.bg
                end
            end)
        end
    end
    disconnectAll(_G.OceanXRayConns)
    disconnectAll(_G.OceanXRayBrainrotConns)
    restoreSnapshot(_G.OceanXRayOrigTrans, false)
    restoreSnapshot(_G.OceanXRayBrainrotOrigTrans, true)
    if type(_G.OceanXRayBrainrotHighlights) == "table" then
        for _, marker in pairs(_G.OceanXRayBrainrotHighlights) do
            pcall(function() if marker and marker.Parent then marker:Destroy() end end)
        end
    end
    _G.setXRayBrainrotEnabled = nil
    _G.applyFreshBrainrotXRayInstance = nil
    _G.isFreshBrainrotXRayTarget = nil
    _G.addFreshBrainrotXRayHighlight = nil
    _G.setXRayBrainrotVisual = nil
    _G.xrayBrainrotEnabled = nil
end)()

_G.OceanXRayLoopId = (_G.OceanXRayLoopId or 0) + 1
_G.OceanXRayOrigTrans = {}
_G.OceanXRayConns = {}
_G.OceanXRayBrainrotOrigTrans = nil
_G.OceanXRayBrainrotConns = nil
_G.OceanXRayBrainrotLoopId = nil
_G.OceanXRayBrainrotHighlights = nil
_G.__OceanXRayBrainrotSnapshotProperty = nil

local function setOceanXRayTarget(instance, alphaPercent, loopId)
    local originals = _G.OceanXRayOrigTrans
    if not instance or loopId ~= _G.OceanXRayLoopId then return end
    local function apply(obj)
        if obj:IsA("BasePart") then
            if originals[obj] == nil then originals[obj] = obj.Transparency end
            local original = originals[obj]
            if original < 1 then obj.Transparency = original + (1 - original) * alphaPercent end
        elseif obj:IsA("TextLabel") or obj:IsA("TextButton") then
            if originals[obj] == nil then originals[obj] = {text = obj.TextTransparency, bg = obj.BackgroundTransparency} end
            local original = originals[obj]
            if original.text < 1 then obj.TextTransparency = original.text + (1 - original.text) * alphaPercent end
            if original.bg < 1 then obj.BackgroundTransparency = original.bg + (1 - original.bg) * alphaPercent end
        elseif obj:IsA("Frame") or obj:IsA("ScrollingFrame") then
            if originals[obj] == nil then originals[obj] = obj.BackgroundTransparency end
            local original = originals[obj]
            if original < 1 then obj.BackgroundTransparency = original + (1 - original) * alphaPercent end
        elseif obj:IsA("ImageLabel") or obj:IsA("ImageButton") then
            if originals[obj] == nil then originals[obj] = {img = obj.ImageTransparency, bg = obj.BackgroundTransparency} end
            local original = originals[obj]
            if original.img < 1 then obj.ImageTransparency = original.img + (1 - original.img) * alphaPercent end
            if original.bg < 1 then obj.BackgroundTransparency = original.bg + (1 - original.bg) * alphaPercent end
        end
    end
    apply(instance)
    for index, child in ipairs(instance:GetDescendants()) do
        apply(child)
        if index % 300 == 0 then
            task.wait()
            if loopId ~= _G.OceanXRayLoopId then return end
        end
    end
end

local function trackOceanXRaySubtree(root, alphaPercent, loopId)
    if not root or loopId ~= _G.OceanXRayLoopId then return end
    setOceanXRayTarget(root, alphaPercent, loopId)
    table.insert(_G.OceanXRayConns, root.DescendantAdded:Connect(function(object)
        if loopId == _G.OceanXRayLoopId then setOceanXRayTarget(object, alphaPercent, loopId) end
    end))
end

local function processOceanXRayPlot(plot, alphaPercent, loopId)
    if not plot or loopId ~= _G.OceanXRayLoopId then return end
    for _, folderName in ipairs(_G.OceanXRayFolders) do
        trackOceanXRaySubtree(plot:FindFirstChild(folderName), alphaPercent, loopId)
    end
    table.insert(_G.OceanXRayConns, plot.ChildAdded:Connect(function(child)
        if loopId ~= _G.OceanXRayLoopId then return end
        for _, folderName in ipairs(_G.OceanXRayFolders) do
            if child.Name == folderName then trackOceanXRaySubtree(child, alphaPercent, loopId); break end
        end
    end))
    local podiums = plot:FindFirstChild("AnimalPodiums")
    if podiums then
        local function processPodium(podium)
            for _, child in ipairs(podium:GetChildren()) do
                if child.Name == "Claim" then trackOceanXRaySubtree(child, alphaPercent, loopId)
                elseif child.Name == "Base" then trackOceanXRaySubtree(child:FindFirstChild("Decorations"), alphaPercent, loopId) end
            end
        end
        for _, podium in ipairs(podiums:GetChildren()) do processPodium(podium) end
        table.insert(_G.OceanXRayConns, podiums.ChildAdded:Connect(function(podium)
            if loopId == _G.OceanXRayLoopId then task.wait(0.1); processPodium(podium) end
        end))
    end
end

function restoreOceanXRaySnapshot()
    local originals = _G.OceanXRayOrigTrans
    _G.OceanXRayOrigTrans = {}
    for object, original in pairs(originals) do
        pcall(function()
            if object:IsA("BasePart") then object.Transparency = original
            elseif object:IsA("TextLabel") or object:IsA("TextButton") then object.TextTransparency = original.text; object.BackgroundTransparency = original.bg
            elseif object:IsA("Frame") or object:IsA("ScrollingFrame") then object.BackgroundTransparency = original
            elseif object:IsA("ImageLabel") or object:IsA("ImageButton") then object.ImageTransparency = original.img; object.BackgroundTransparency = original.bg end
        end)
    end
end

local function setXRayEnabled(on)
    xrayEnabled = on == true
    for _, connection in ipairs(_G.OceanXRayConns) do pcall(function() connection:Disconnect() end) end
    _G.OceanXRayConns = {}
    _G.OceanXRayLoopId = _G.OceanXRayLoopId + 1
    local loopId = _G.OceanXRayLoopId
    if xrayEnabled then
        task.spawn(function()
            while loopId == _G.OceanXRayLoopId and not Workspace:FindFirstChild("Plots") do task.wait(0.5) end
            if loopId ~= _G.OceanXRayLoopId then return end
            local plots = Workspace:FindFirstChild("Plots")
            if not plots then return end
            for _, plot in ipairs(plots:GetChildren()) do
                processOceanXRayPlot(plot, 0.5, loopId)
                task.wait()
            end
            table.insert(_G.OceanXRayConns, plots.ChildAdded:Connect(function(plot)
                if loopId == _G.OceanXRayLoopId then task.wait(0.2); processOceanXRayPlot(plot, 0.5, loopId) end
            end))
        end)
    else
        restoreOceanXRaySnapshot()
    end
end

;(function()
    local previous = _G.FreshHubBrainrotXRay
    if previous then
        previous.enabled = false
        previous.scanId = (tonumber(previous.scanId) or 0) + 1
        for _, connection in ipairs(previous.connections or {}) do
            pcall(function() connection:Disconnect() end)
        end
        local previousHasLocalSnapshot = type(previous.savedLocalTransparency) == "table"
        for object, original in pairs(previous.saved or {}) do
            pcall(function()
                if object and object.Parent and (not object:IsA("BasePart") or not previousHasLocalSnapshot) then
                    object.Transparency = original
                end
            end)
        end
        for object, original in pairs(previous.savedLocalTransparency or {}) do
            pcall(function() if object and object.Parent then object.LocalTransparencyModifier = original end end)
        end
    end
end)()

_G.FreshHubBrainrotXRay = {
    enabled = false,
    transparency = 0.85,
    saved = {},
    savedLocalTransparency = {},
    connections = {},
    watched = {},
    scanId = 0,
    names = nil,
    namesLoaded = false,
    lastNameAttempt = 0,
}

_G.FreshHubBrainrotXRay.loadNames = function()
    local state = _G.FreshHubBrainrotXRay
    if state.namesLoaded and state.names and next(state.names) ~= nil then return true end
    local now = _tick()
    if now - (tonumber(state.lastNameAttempt) or 0) < 1.25 then return false end
    state.lastNameAttempt = now
    state.names = state.names or {}
    local loaded = pcall(function()
        local replicated = game:GetService("ReplicatedStorage")
        local dataFolder = replicated:FindFirstChild("Datas") or replicated:FindFirstChild("Data")
        local animalFolder = dataFolder and (dataFolder:FindFirstChild("Animals") or dataFolder:FindFirstChild("Animal"))
        if animalFolder then
            for _, entry in ipairs(animalFolder:GetChildren()) do state.names[entry.Name] = true end
        end
        for _, candidate in ipairs(replicated:GetDescendants()) do
            if candidate:IsA("ModuleScript") and (candidate.Name == "Animals" or candidate.Name == "AnimalList") then
                local ok, values = pcall(require, candidate)
                if ok and type(values) == "table" then
                    for key, value in pairs(values) do
                        if type(key) == "string" then state.names[key] = true end
                        if type(value) == "table" and type(value.Name) == "string" then state.names[value.Name] = true end
                        if type(value) == "string" then state.names[value] = true end
                    end
                end
            end
        end
    end)
    state.namesLoaded = loaded and next(state.names) ~= nil
    return state.namesLoaded
end

_G.FreshHubBrainrotXRay.isHitbox = function(object)
    local name = string.lower(object.Name or "")
    return string.find(name, "hit", 1, true) or string.find(name, "target", 1, true)
        or string.find(name, "box", 1, true) or string.find(name, "root", 1, true)
        or string.find(name, "collect", 1, true) or string.find(name, "prompt", 1, true)
end

_G.FreshHubBrainrotXRay.applyOne = function(object)
    local state = _G.FreshHubBrainrotXRay
    if not object or not object.Parent then return end
    if not (object:IsA("BasePart") or object:IsA("Decal") or object:IsA("Texture")) then return end
    -- Evitar reescribir partes ya procesadas por el modelo y por DescendantAdded.
    if state.watched[object] then
        local activeValue = object:IsA("BasePart") and object.LocalTransparencyModifier or object.Transparency
        if activeValue == state.transparency then return end
    end
    local original = state.saved[object]
    if original == nil then
        original = object.Transparency
        state.saved[object] = original
    end
    if original > 0.5 and original < 0.99 and object:IsA("BasePart") and state.isHitbox(object) then return end
    if original >= 0.5 then return end

    local watchedProperty = "Transparency"
    if object:IsA("BasePart") then
        watchedProperty = "LocalTransparencyModifier"
        if state.savedLocalTransparency[object] == nil then
            state.savedLocalTransparency[object] = object.LocalTransparencyModifier
        end
        if object.LocalTransparencyModifier ~= state.transparency then
            object.LocalTransparencyModifier = state.transparency
        end
    elseif object.Transparency ~= state.transparency then
        object.Transparency = state.transparency
    end

    if not state.watched[object] then
        local ok, connection = pcall(function()
            return object:GetPropertyChangedSignal(watchedProperty):Connect(function()
                if not state.enabled or not object.Parent then return end
                local activeValue = object[watchedProperty]
                if activeValue ~= state.transparency then state.applyOne(object) end
            end)
        end)
        if ok and connection then
            state.watched[object] = connection
            table.insert(state.connections, connection)
        end
    end
end

_G.FreshHubBrainrotXRay.applyModel = function(model)
    local state = _G.FreshHubBrainrotXRay
    if not model or not model.Parent then return end
    local descendants = model:GetDescendants()
    for index, object in ipairs(descendants) do
        if not state.enabled then return end
        state.applyOne(object)
        if index % 200 == 0 then
            task.wait(0.03)
            if not state.enabled then return end
        end
    end
end

_G.FreshHubBrainrotXRay.isAnimal = function(model)
    local state = _G.FreshHubBrainrotXRay
    if not model or not model:IsA("Model") then return false end
    if not state.namesLoaded then state.loadNames() end
    return (state.names and state.names[model.Name] == true)
        or (model.Parent and model.Parent.Name == "AnimalPodiums" and model.Name ~= "Base" and model.Name ~= "Decorations")
end

_G.FreshHubBrainrotXRay.animalAncestor = function(instance)
    local state = _G.FreshHubBrainrotXRay
    local parent = instance and instance.Parent
    while parent and parent ~= workspace do
        if parent:IsA("Model") and state.isAnimal(parent) then return parent end
        parent = parent.Parent
    end
    return nil
end

_G.FreshHubBrainrotXRay.restoreAll = function()
    local state = _G.FreshHubBrainrotXRay
    local snapshot = state.saved
    local localSnapshot = state.savedLocalTransparency
    state.saved = {}
    state.savedLocalTransparency = {}
    state.watched = {}
    for object, original in pairs(snapshot) do
        pcall(function()
            if not object or not object.Parent then return end
            if object:IsA("BasePart") then
                local localOriginal = localSnapshot[object]
                if localOriginal ~= nil then object.LocalTransparencyModifier = localOriginal end
            else
                object.Transparency = original
            end
        end)
    end
end

_G.FreshHubSetBrainrotXRay = function(on)
    local state = _G.FreshHubBrainrotXRay
    state.enabled = on == true
    xrayBrainrotEnabled = state.enabled
    for _, connection in ipairs(state.connections) do pcall(function() connection:Disconnect() end) end
    state.connections = {}
    state.watched = {}
    state.scanId = state.scanId + 1
    if not state.enabled then state.restoreAll(); return end
    state.loadNames()
    local scanId = state.scanId
    task.spawn(function()
        local function scanWorkspace()
            local candidates, candidateSet = {}, {}
            local count = 0
            for _, object in ipairs(workspace:GetDescendants()) do
                if state.scanId ~= scanId or not state.enabled then return false end
                if object:IsA("Model") and (state.isAnimal(object)
                    or (object.Parent and object.Parent.Name == "AnimalPodiums"
                        and object.Name ~= "Base" and object.Name ~= "Decorations")) then
                    candidateSet[object] = true
                    candidates[#candidates + 1] = object
                end
                count = count + 1
                if count % 500 == 0 then task.wait(0.03) end
            end
            -- Solo aplicar los modelos animales raíz; los anidados ya quedan cubiertos.
            local applied = 0
            for _, model in ipairs(candidates) do
                if state.scanId ~= scanId or not state.enabled then return false end
                local parent, nested = model.Parent, false
                while parent and parent ~= workspace do
                    if candidateSet[parent] then nested = true; break end
                    parent = parent.Parent
                end
                if not nested then state.applyModel(model) end
                applied = applied + 1
                if applied % 12 == 0 then task.wait(0.03) end
            end
            return true
        end
        if not scanWorkspace() then return end
        while state.scanId == scanId and state.enabled and not state.namesLoaded do
            task.wait(1.25)
            if state.loadNames() then
                scanWorkspace()
                break
            end
        end
    end)
    table.insert(state.connections, workspace.DescendantAdded:Connect(function(object)
        if not state.enabled then return end
        if object:IsA("Model") then
            if state.isAnimal(object) then
                state.applyModel(object)
            elseif object.Parent and object.Parent.Name == "AnimalPodiums" and object.Name ~= "Base" then
                state.applyModel(object)
            end
        elseif object:IsA("BasePart") or object:IsA("Decal") or object:IsA("Texture") then
            if state.animalAncestor(object) then state.applyOne(object) end
        end
    end))
end

xrayEnabled = false
xrayBrainrotEnabled = false

-- ============================================================
-- 10. MOVIMIENTO: VELOCIDAD, SALTO INFINITO, AUTO LEFT/RIGHT Y UNWALK
-- ============================================================
speedMode = false
jumpEnabled = false
laggerToggled = false
laggerCarryToggled = false
unwalkEnabled = false
autoLeftEnabled = false
autoRightEnabled = false
lastMoveDir = _V3zero

local InfiniteJump = {
    enabled = false,
    jumpPower = 55,
    minVelocity = 30,
    jumpConn = nil,
    heartbeatConn = nil,
}

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
    print("[InfiniteJump] Activado")
end

function InfiniteJump.stop()
    InfiniteJump.enabled = false
    if InfiniteJump.jumpConn then InfiniteJump.jumpConn:Disconnect(); InfiniteJump.jumpConn = nil end
    if InfiniteJump.heartbeatConn then InfiniteJump.heartbeatConn:Disconnect(); InfiniteJump.heartbeatConn = nil end
    print("[InfiniteJump] Desactivado")
end

function InfiniteJump.setJumpPower(power)
    power = tonumber(power) or 55
    InfiniteJump.jumpPower = _clamp(power, 10, 200)
end

function InfiniteJump.isRunning() return InfiniteJump.enabled == true end

local function getCharParts()
    local char = LP.Character
    if not char then return nil, nil end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local root = char:FindFirstChild("HumanoidRootPart")
    if not hum or not root then return nil, nil end
    return hum, root
end

local function claimOwnership(root)
    pcall(function() root:SetNetworkOwner(LP) end)
end

function getActiveMoveSpeed()
    if laggerCarryToggled then return LAGGER_CARRY_SPEED
    elseif laggerToggled then return LAGGER_SPEED
    elseif autoCarryEnabled and hasCarryItemInHands() then return CS
    elseif speedMode then return CS
    else return NS end
end

local _velChecked = {}
local _hookedVelParts = {}

local function _setupVelChecked(char)
    _velChecked = {}
    if not char then return end
    local hrp = char:WaitForChild("HumanoidRootPart", 5)
    if hrp then _velChecked[hrp] = true end
    return hrp
end

local _hookVelSupported = nil

local function _hookVelHRP(hrp)
    if not hrp or _hookedVelParts[hrp] then return end
    if _hookVelSupported == false then return end
    if _hookVelSupported == nil then
        _hookVelSupported = (type(getrawmetatable) == "function")
            and (type(setreadonly) == "function")
            and (type(newcclosure) == "function")
            and (type(checkcaller) == "function")
    end
    if not _hookVelSupported then return end
    _hookedVelParts[hrp] = true
    local ok = pcall(function()
        local mt = getrawmetatable(hrp)
        if not mt then return end
        setreadonly(mt, false)
        local originalVelIndex = rawget(mt, "__index")
        mt.__index = newcclosure(function(self, key)
            if not checkcaller() and _velChecked[self]
               and (key == "AssemblyLinearVelocity" or key == "Velocity") then
                local real
                if type(originalVelIndex) == "function" then
                    real = originalVelIndex(self, key)
                elseif type(originalVelIndex) == "table" then
                    real = originalVelIndex[key]
                end
                if real and real.Magnitude > 20 then return real.Unit * 20 end
                return real
            end
            if type(originalVelIndex) == "function" then
                return originalVelIndex(self, key)
            elseif type(originalVelIndex) == "table" then
                return originalVelIndex[key]
            end
        end)
        setreadonly(mt, true)
    end)
    if not ok then _hookVelSupported = false end
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

local function _applyVelocitySpeed(dir, speed, hrp)
    if not hrp or not hrp.Parent then return end
    if autoBatEnabled then return end
    local velocity = hrp.AssemblyLinearVelocity
    if dir and dir.Magnitude > 0.05 then
        local unit = dir.Unit
        local targetX, targetZ = unit.X * speed, unit.Z * speed
        -- Evita escrituras fisicas redundantes si ya estamos a la velocidad deseada.
        if math.abs(velocity.X - targetX) > 1.25 or math.abs(velocity.Z - targetZ) > 1.25 then
            hrp.AssemblyLinearVelocity = _V3new(targetX, velocity.Y, targetZ)
        end
    elseif math.abs(velocity.X) > 0.5 or math.abs(velocity.Z) > 0.5 then
        hrp.AssemblyLinearVelocity = _V3new(0, velocity.Y, 0)
    end
end

function getAutoPathSpeed()
    if laggerCarryToggled then return LAGGER_CARRY_SPEED end
    if laggerToggled then return LAGGER_SPEED end
    if autoCarryEnabled and hasCarryItemInHands() then return CS end
    if speedMode then return CS end
    return NS
end

lastMoveDir = _V3new(0,0,0)
_prevAutoRotate = nil
movementLoop = nil
steppedConn = nil
alConn = nil
arConn = nil
infJumpConn = nil
speedLabel = nil
modeValLbl = nil
modeSelectBtn = nil
setJumpToggleState = nil

MOVE_KEYS = {
    [Enum.KeyCode.W] = true, [Enum.KeyCode.A] = true,
    [Enum.KeyCode.S] = true, [Enum.KeyCode.D] = true,
    [Enum.KeyCode.Up] = true, [Enum.KeyCode.Left] = true,
    [Enum.KeyCode.Down] = true, [Enum.KeyCode.Right] = true,
}

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
        elseif laggerToggled then modeValLbl.Text = "Lagger"
        elseif speedMode then modeValLbl.Text = "Carry"
        else modeValLbl.Text = "Normal" end
    end
    if setCarryModeVisual then setCarryModeVisual(speedMode) end
    if setLaggerModeVisual then setLaggerModeVisual(laggerToggled) end
    if setLaggerCarryVisual then setLaggerCarryVisual(laggerCarryToggled) end
end

function resetMovementState()
    -- Mantener sincronizados ambos motores de movimiento. Antes, al usar
    -- CarrySystem, los botones solo cambiaban la UI y el motor conservaba
    -- la velocidad/modo anterior.
    if useCarrySystem then
        CarrySystem.speedToggled = speedMode == true
        if laggerCarryToggled then
            CarrySystem:setLaggerMode(2)
        elseif laggerToggled then
            CarrySystem:setLaggerMode(1)
        else
            CarrySystem:setLaggerMode(0)
        end
    end
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
end

function toggleLaggerMode()
    if laggerCarryToggled then laggerCarryToggled = false end
    speedMode = false; laggerToggled = not laggerToggled
    resetMovementState()
end

function toggleLaggerCarryMode()
    if laggerToggled then laggerToggled = false end
    speedMode = false; laggerCarryToggled = not laggerCarryToggled
    resetMovementState()
end

function toggleLaggerCycle()
    if laggerToggled then
        -- Lagger 1 -> Lagger Carry.
        speedMode = false
        laggerToggled = false
        laggerCarryToggled = true
    elseif laggerCarryToggled then
        -- Lagger Carry -> Carry Speed.
        speedMode = true
        laggerToggled = false
        laggerCarryToggled = false
    else
        -- Normal or Carry Speed -> Lagger 1. Normal never falls through to Carry.
        speedMode = false
        laggerToggled = true
        laggerCarryToggled = false
    end
    resetMovementState()
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

function setupMovementAndIndicators(char)
    if steppedConn then steppedConn:Disconnect(); steppedConn = nil end
    if movementLoop then movementLoop:Disconnect(); movementLoop = nil end

    -- La colision de otros jugadores se gestiona por eventos, sin barridos Heartbeat.
    local moveHumanoid = char and char:FindFirstChildOfClass("Humanoid")
    local moveRoot = char and char:FindFirstChild("HumanoidRootPart")
    if moveRoot then claimOwnership(moveRoot) end
    local speedLabelElapsed = 0.1
    local lastSpeedLabelText = nil

    movementLoop = RunService.PreSimulation:Connect(function(dt)
        if LP.Character ~= char then return end
        if not moveHumanoid or not moveHumanoid.Parent then
            moveHumanoid = char:FindFirstChildOfClass("Humanoid")
        end
        if not moveRoot or not moveRoot.Parent then
            moveRoot = char:FindFirstChild("HumanoidRootPart")
        end
        local hum, hrp = moveHumanoid, moveRoot
        if not hum or not hrp then return end
        if not autoBatEnabled and not autoLeftEnabled and not autoRightEnabled then
            if _isRagdollState(hum) then
                lastMoveDir = _V3zero
            else
                local md = hum.MoveDirection
                local spd = getActiveMoveSpeed()
                local dir = nil
                if md.Magnitude > 0 then
                    lastMoveDir = md
                    dir = md
                elseif lastMoveDir.Magnitude > 0 then
                    for key in pairs(MOVE_KEYS) do
                        if UIS:IsKeyDown(key) then dir = lastMoveDir; break end
                    end
                end
                _applyVelocitySpeed(dir, spd, hrp)
            end
        end

        speedLabelElapsed = speedLabelElapsed + (dt or 0)
        if speedLabel and speedLabelElapsed >= 0.1 then
            speedLabelElapsed = speedLabelElapsed % 0.1
            local configuredSpeed = getActiveMoveSpeed()
            local currentVelocity = hrp.AssemblyLinearVelocity
            local actualSpeed = _sqrt(currentVelocity.X * currentVelocity.X + currentVelocity.Z * currentVelocity.Z)
            local displaySpeed = hum.MoveDirection.Magnitude > 0.05 and configuredSpeed or actualSpeed
            local displayText = string.format("%.1f", math.max(tonumber(displaySpeed) or 0, 0))
            local text = displayText
            if text ~= lastSpeedLabelText then
                speedLabel.Text = text
                lastSpeedLabelText = text
            end
        end
    end)
    setupSpeedIndicator(char)
    startEnemySpeed()
end

-- ============================================================
-- 11. PAQUETES DE ANIMACION
-- ============================================================
currentAnimPack = "Off"
originalTryardAnims = nil
tryardHeartbeatConn = nil
animSelectorLabel = nil

ANIM_PACKS = {
    ["Adidas Sports"] = { idle1="rbxassetid://18537376492", idle2="rbxassetid://18537371272", walk="rbxassetid://18537392113", run="rbxassetid://18537384940", jump="rbxassetid://18537380791", fall="rbxassetid://18537367238", climb="rbxassetid://18537363391", swim="rbxassetid://18537389531", swimidle="rbxassetid://18537387180" },
    ["Adidas Community"] = { idle1="rbxassetid://122257458498464", idle2="rbxassetid://102357151005774", walk="rbxassetid://122150855457006", run="rbxassetid://82598234841035", jump="rbxassetid://75290611992385", fall="rbxassetid://98600215928904", climb="rbxassetid://88763136693023", swim="rbxassetid://133308483266208", swimidle="rbxassetid://109346520324160" },
    ["Adidas Aura"] = { idle1="rbxassetid://110211186840347", idle2="rbxassetid://114191137265065", walk="rbxassetid://83842218823011", run="rbxassetid://118320322718866", jump="rbxassetid://109996626521204", fall="rbxassetid://95603166884636", climb="rbxassetid://97824616490448", swim="rbxassetid://134530128383903", swimidle="rbxassetid://94922130551805" },
    ["Wicked Popular"] = { idle1="rbxassetid://118832222982049", idle2="rbxassetid://76049494037641", walk="rbxassetid://92072849924640", run="rbxassetid://72301599441680", jump="rbxassetid://104325245285198", fall="rbxassetid://121152442762481", climb="rbxassetid://131326830509784", swim="rbxassetid://99384245425157", swimidle="rbxassetid://113199415118199" },
    ["Elder"] = { idle1="rbxassetid://10921101664", idle2="rbxassetid://10921102574", walk="rbxassetid://10921111375", run="rbxassetid://10921104374", jump="rbxassetid://10921107367", fall="rbxassetid://10921105765", climb="rbxassetid://10921100400", swim="rbxassetid://10921108971", swimidle="rbxassetid://10921110146" },
    ["Zombie"] = { idle1="rbxassetid://10921344533", idle2="rbxassetid://10921345304", walk="rbxassetid://10921355261", run="rbxassetid://616163682", jump="rbxassetid://10921351278", fall="rbxassetid://10921350320", climb="rbxassetid://10921343576", swim="rbxassetid://10921352344", swimidle="rbxassetid://10921353442" },
    ["Mage"] = { idle1="rbxassetid://10921144709", idle2="rbxassetid://10921145797", walk="rbxassetid://10921152678", run="rbxassetid://10921148209", jump="rbxassetid://10921149743", fall="rbxassetid://10921148939", climb="rbxassetid://10921143404", swim="rbxassetid://10921150788", swimidle="rbxassetid://10921151661" },
    ["Catwalk Glam"] = { idle1="rbxassetid://133806214992291", idle2="rbxassetid://94970088341563", walk="rbxassetid://109168724482748", run="rbxassetid://81024476153754", jump="rbxassetid://116936326516985", fall="rbxassetid://92294537340807", climb="rbxassetid://119377220967554", swim="rbxassetid://134591743181628", swimidle="rbxassetid://98854111361360" },
    ["Astronaut"] = { idle1="rbxassetid://10921034824", idle2="rbxassetid://10921036806", walk="rbxassetid://10921046031", run="rbxassetid://10921039308", jump="rbxassetid://10921042494", fall="rbxassetid://10921040576", climb="rbxassetid://10921032124", swim="rbxassetid://10921044000", swimidle="rbxassetid://10921045006" },
    ["Wicked \"Dancing Through Life\""] = { idle1="rbxassetid://92849173543269", idle2="rbxassetid://132238900951109", walk="rbxassetid://73718308412641", run="rbxassetid://135515454877967", jump="rbxassetid://78508480717326", fall="rbxassetid://78147885297412", climb="rbxassetid://129447497744818", swim="rbxassetid://110657013921774", swimidle="rbxassetid://129183123083281" },
    ["Werewolf"] = { idle1="rbxassetid://10921330408", idle2="rbxassetid://10921333667", walk="rbxassetid://10921342074", run="rbxassetid://10921336997", jump="rbxassetid://507765000", fall="rbxassetid://10921337907", climb="rbxassetid://10921329322", swim="rbxassetid://10921340419", swimidle="rbxassetid://10921341319" },
    ["Superhero"] = { idle1="rbxassetid://10921288909", idle2="rbxassetid://10921290167", walk="rbxassetid://10921298616", run="rbxassetid://10921291831", jump="rbxassetid://10921294559", fall="rbxassetid://10921293373", climb="rbxassetid://10921286911", swim="rbxassetid://10921295495", swimidle="rbxassetid://10921297391" },
    ["Toy"] = { idle1="rbxassetid://10921301576", idle2="rbxassetid://507766951", walk="rbxassetid://10921312010", run="rbxassetid://10921306285", jump="rbxassetid://10921308158", fall="rbxassetid://10921307241", climb="rbxassetid://10921300839", swim="rbxassetid://10921309319", swimidle="rbxassetid://10921310341" },
    ["No Boundaries"] = { idle1="rbxassetid://18747067405", idle2="rbxassetid://18747063918", walk="rbxassetid://18747074203", run="rbxassetid://18747070484", jump="rbxassetid://18747069148", fall="rbxassetid://18747062535", climb="rbxassetid://18747060903", swim="rbxassetid://18747073181", swimidle="rbxassetid://18747071682" },
    ["NFL"] = { idle1="rbxassetid://92080889861410", idle2="rbxassetid://74451233229259", walk="rbxassetid://110358958299415", run="rbxassetid://117333533048078", jump="rbxassetid://119846112151352", fall="rbxassetid://129773241321032", climb="rbxassetid://134630013742019", swim="rbxassetid://132697394189921", swimidle="rbxassetid://79090109939093" },
    ["Amazon Unboxed"] = { idle1="rbxassetid://98281136301627", idle2="rbxassetid://507766951", walk="rbxassetid://90478085024465", run="rbxassetid://134824450619865", jump="rbxassetid://121454505477205", fall="rbxassetid://94788218468396", climb="rbxassetid://121145883950231", swim="rbxassetid://105962919001086", swimidle="rbxassetid://129126268464847" },
    ["Vampire"] = { idle1="rbxassetid://10921315373", idle2="rbxassetid://507766951", walk="rbxassetid://10921326949", run="rbxassetid://10921320299", jump="rbxassetid://10921322186", fall="rbxassetid://10921321317", climb="rbxassetid://10921314188", swim="rbxassetid://10921324408", swimidle="rbxassetid://10921325443" },
    ["Ninja"] = { idle1="rbxassetid://656117400", idle2="rbxassetid://656118341", walk="rbxassetid://656121766", run="rbxassetid://656118852", jump="rbxassetid://656117878", fall="rbxassetid://656115606", climb="rbxassetid://656114359", swim="rbxassetid://656119721", swimidle="rbxassetid://656121397" },
    ["Robot"] = { idle1="rbxassetid://616088211", idle2="rbxassetid://616089559", walk="rbxassetid://616095330", run="rbxassetid://616091570", jump="rbxassetid://616090535", fall="rbxassetid://616087089", climb="rbxassetid://616086039", swim="rbxassetid://616092998", swimidle="rbxassetid://616094091" },
    ["Levitation"] = { idle1="rbxassetid://616006778", idle2="rbxassetid://616008087", walk="rbxassetid://616013216", run="rbxassetid://616010382", jump="rbxassetid://616008936", fall="rbxassetid://616005863", climb="rbxassetid://616003713", swim="rbxassetid://616011509", swimidle="rbxassetid://616012453" },
    ["Stylish"] = { idle1="rbxassetid://616136790", idle2="rbxassetid://616138447", walk="rbxassetid://616146177", run="rbxassetid://616140816", jump="rbxassetid://616139451", fall="rbxassetid://616134815", climb="rbxassetid://616133594", swim="rbxassetid://616143378", swimidle="rbxassetid://616144772" },
    ["Bubbly"] = { idle1="rbxassetid://910004836", idle2="rbxassetid://910009958", walk="rbxassetid://910034870", run="rbxassetid://910025107", jump="rbxassetid://910016857", fall="rbxassetid://910001910", climb="rbxassetid://909997997", swim="rbxassetid://910028158", swimidle="rbxassetid://910030921" },
    ["Cartoon"] = { idle1="rbxassetid://742637544", idle2="rbxassetid://742638445", walk="rbxassetid://742640026", run="rbxassetid://742638842", jump="rbxassetid://742637942", fall="rbxassetid://742637151", climb="rbxassetid://742636889", swim="rbxassetid://742639220", swimidle="rbxassetid://742639812" },
}

ANIM_PACK_ORDER = {{"Off", "Off"}, {"Adidas Sports", "Adidas Sports"}, {"Adidas Community", "Adidas Community"}, {"Adidas Aura", "Adidas Aura"}, {"Wicked Popular", "Wicked Popular"}, {"Elder", "Elder"}, {"Zombie", "Zombie"}, {"Mage", "Mage"}, {"Catwalk Glam", "Catwalk Glam"}, {"Astronaut", "Astronaut"}, {"Wicked \"Dancing Through Life\"", "Wicked \"Dancing Through Life\""}, {"Werewolf", "Werewolf"}, {"Superhero", "Superhero"}, {"Toy", "Toy"}, {"No Boundaries", "No Boundaries"}, {"NFL", "NFL"}, {"Amazon Unboxed", "Amazon Unboxed"}, {"Vampire", "Vampire"}, {"Ninja", "Ninja"}, {"Robot", "Robot"}, {"Levitation", "Levitation"}, {"Stylish", "Stylish"}, {"Bubbly", "Bubbly"}, {"Cartoon", "Cartoon"}}

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

local function refreshCharacterAnimationState(char, hum)
    char = char or LP.Character
    hum = hum or (char and char:FindFirstChildOfClass("Humanoid"))
    if not char or not hum or hum.Health <= 0 then return end
    local animate = char:FindFirstChild("Animate")
    if not animate then return end

    -- Evita que un cambio de pack deje las pistas detenidas hasta el siguiente movimiento.
    hum.PlatformStand = false
    hum.AutoRotate = true
    pcall(function() hum:ChangeState(Enum.HumanoidStateType.Running) end)
    for _, track in ipairs(hum:GetPlayingAnimationTracks()) do
        pcall(function() track:Stop(0.05) end)
    end

    local wasDisabled = animate.Disabled
    animate.Disabled = true
    task.defer(function()
        if not char.Parent or LP.Character ~= char then return end
        local currentHum = char:FindFirstChildOfClass("Humanoid")
        local currentAnimate = char:FindFirstChild("Animate")
        if not currentHum or not currentAnimate then return end
        currentAnimate.Disabled = false
        currentHum.PlatformStand = false
        currentHum.AutoRotate = true
        pcall(function() currentHum:ChangeState(Enum.HumanoidStateType.Running) end)
        -- Un pequeño Move nulo fuerza al Animate local a reevaluar idle/walk sin pedirle al usuario caminar.
        pcall(function() currentHum:Move(Vector3.zero, false) end)
    end)
end

function applyAnimPackIds(animate, pack)
    if not animate or not pack then return end
    local function setId(obj, id)
        if obj and id then obj.AnimationId = id end
    end
    setId(animate.idle and animate.idle.Animation1, pack.idle1)
    setId(animate.idle and animate.idle.Animation2, pack.idle2)
    setId(animate.walk and animate.walk.WalkAnim, pack.walk)
    setId(animate.run and animate.run.RunAnim, pack.run)
    setId(animate.jump and animate.jump.JumpAnim, pack.jump)
    setId(animate.fall and animate.fall.FallAnim, pack.fall)
    setId(animate.climb and animate.climb.ClimbAnim, pack.climb)
    setId(animate.swim and animate.swim.Swim, pack.swim)
    setId(animate.swimidle and animate.swimidle.SwimIdle, pack.swimidle)
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
        if LP.Character then refreshCharacterAnimationState(LP.Character, LP.Character:FindFirstChildOfClass("Humanoid")) end
        return
    end
    local pack = ANIM_PACKS[packName]
    if not pack then return end
    if tryardHeartbeatConn then tryardHeartbeatConn:Disconnect() end
    -- Aplicar el paquete inmediatamente antes de refrescar Animate; así el
    -- personaje no se queda con la pose anterior parecida a Unwalk.
    if LP.Character then
        local animate = LP.Character:FindFirstChild("Animate")
        if animate then applyAnimPackIds(animate, pack) end
    end
    local refreshAccumulator = 0
    tryardHeartbeatConn = RunService.Heartbeat:Connect(function(dt)
        refreshAccumulator = refreshAccumulator + (dt or 0.016)
        if refreshAccumulator < 0.50 then return end
        refreshAccumulator = 0
        local c = LP.Character
        if not c then return end
        local animate = c:FindFirstChild("Animate")
        if not animate then return end
        applyAnimPackIds(animate, pack)
    end)
end

local function startAnimPack(packName)
    if unwalkEnabled then
        pcall(stopUnwalk)
        unwalkEnabled = false
        if setUnwalkVisual then pcall(setUnwalkVisual, false) end
    end
    local char = LP.Character
    if char then
        saveOriginalAnims(char)
        applyAnimPack(packName)
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then refreshCharacterAnimationState(char, hum) end
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

animSelectorLabel = nil

-- ============================================================
-- 12. AUTO STEAL
-- ============================================================
-- Plots se consulta bajo demanda en getPlotsRoot(); no bloquear el inicio esperando el mapa.
local stealConnection = nil

local Steal = {
    AutoStealEnabled = false,
    StealRadius = CONFIG.STEAL_RANGE,
    StealDuration = 1.33,
    StealDelay = 0.25,
    Data = {}
}

local isStealing = false

-- Fresh Duels single Auto Steal timing profile; no legacy HZ variants remain.
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
        if not isMyPlotByName(plot.Name) then
            local pods = plot:FindFirstChild("AnimalPodiums")
            if pods then
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
                                        if child:IsA("ProximityPrompt") and type(child.ActionText) == "string"
                                           and child.ActionText:lower():find("steal", 1, true) then
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
        end
    end
    return nearestPrompt, nearestName
end

function getPromptWorldPosition(prompt)
    if not prompt or not prompt.Parent then return nil end
    local node = prompt.Parent
    for _ = 1, 5 do
        if not node then break end
        if node:IsA("BasePart") then return node.Position end
        if node:IsA("Attachment") and node.Parent and node.Parent:IsA("BasePart") then return node.WorldPosition end
        node = node.Parent
    end
    return nil
end

function setStealProgress(value)
    value = _clamp(tonumber(value) or 0, 0, 1)
    -- Theme accent is refreshed on theme changes, not on every progress tick.
    if progressFill then
        local track = _G.__FreshStealBarTrack
        local width = track and track.Parent and track.AbsoluteSize.X or 0
        progressFill.Visible = true
        if progressFill.ZIndex < 2 then progressFill.ZIndex = 2 end
        if value <= 0.0005 then
            progressFill.Position = UDim2.new(0, 0, 0, 0)
            progressFill.Size = UDim2.new(0, 0, 1, 0)
        elseif width > 0 then
            local actualWidth = math.clamp(value * width, 0, width)
            progressFill.Position = UDim2.new(0, 0, 0, 0)
            progressFill.Size = UDim2.new(0, actualWidth, 1, 0)
        else
            progressFill.Position = UDim2.new(0, 0, 0, 0)
            progressFill.Size = UDim2.new(value, 0, 1, 0)
        end
        progressFill.Visible = value > 0
    end
    if progressPct then progressPct.Text = tostring(_floor(value * 100 + 0.5)) .. "%" end
    if _G.__FreshStealBarStatus then
        local char = LP.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        local st = hum and hum:GetState()
        local rag = st == Enum.HumanoidStateType.Ragdoll or st == Enum.HumanoidStateType.Physics or st == Enum.HumanoidStateType.FallingDown
        local status = value >= 0.999 and "GRABBED!"
            or (value >= 0.90 and "GRABBING..."
            or (value >= 0.68 and "PREPARING GRAB"
            or (value > 0 and "LOCKING TARGET" or "WAITING")))
        _G.__FreshStealBarStatus.Text = rag and "RAGDOLL" or status
    end
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
    updateProgressBarVisibility()

    setStealProgress(0)

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
                setStealProgress(progress)
                if not prompt.Parent or not prompt.Parent.Parent then break end
                local char = LP.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                local targetPos = getPromptWorldPosition(prompt)
                if hrp and targetPos and (hrp.Position - targetPos).Magnitude > Steal.StealRadius then
                    break
                end
                task.wait()
            end

            local stopProgress = _clamp(autoGrabStopTime / duration, 0, 1)
            setStealProgress(stopProgress)

            local phase2Timeout = math.max(2.99 - autoGrabStopTime - math.max(duration - autoGrabStopTime, 0), 0.05)
            local phase2Start = _tick()

            while isStealing and Steal.AutoStealEnabled do
                if _tick() - phase2Start >= phase2Timeout then
                    if progressFill then progressFill.Size = UDim2.new(0, 0, 1, 0) end
                    if progressPct then progressPct.Text = "0%" end
                    if _G.__FreshStealBarStatus then _G.__FreshStealBarStatus.Text = "WAITING" end
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
                    if _G.__FreshStealBarStatus then _G.__FreshStealBarStatus.Text = "WAITING" end
                                    data.ready = true
                    return
                end
                local char = LP.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local targetPos = getPromptWorldPosition(prompt)
                    local dist = targetPos and (hrp.Position - targetPos).Magnitude or 0
                    if dist <= autoGrabSetDelayRadius then
                        break
                    elseif dist > Steal.StealRadius then
                        isStealing = false
                        if progressFill then progressFill.Size = UDim2.new(0, 0, 1, 0) end
                        if progressPct then progressPct.Text = "0%" end
                        if _G.__FreshStealBarStatus then _G.__FreshStealBarStatus.Text = "WAITING" end
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
                    setStealProgress(totalProgress)
                    if fp >= 1 and not promptFired then
                        promptFired = true
                        pcall(function()
                            for _, f in ipairs(data.trigger) do task.spawn(f) end
                            local remote = ReplicatedStorage:FindFirstChild("StealAnimal")
                            if remote and podName then remote:FireServer(podName) end
                            if prompt then prompt:Fire() end
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
                setStealProgress(progress)
                if not prompt.Parent or not prompt.Parent.Parent then break end
                local char = LP.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                local targetPos = getPromptWorldPosition(prompt)
                if hrp and targetPos and (hrp.Position - targetPos).Magnitude > Steal.StealRadius then break end
                if elapsed >= duration and not promptFired then
                    promptFired = true
                    pcall(function()
                        for _, f in ipairs(data.trigger) do task.spawn(f) end
                        local remote = ReplicatedStorage:FindFirstChild("StealAnimal")
                        if remote and podName then remote:FireServer(podName) end
                        if prompt then prompt:Fire() end
                    end)
                    break
                end
                task.wait()
            end
        end

        if promptFired then
            setStealProgress(1)
            task.wait(0.35)
        end
        setStealProgress(0)
        data.ready = true
        isStealing = false
    end)
end

function startAutoSteal()
    if stealConnection then
        local connected = false
        pcall(function() connected = stealConnection.Connected == true end)
        if connected then
            Steal.StealRadius = CONFIG.STEAL_RANGE
            Steal.AutoStealEnabled = true
            CONFIG.AUTO_STEAL_ENABLED = true
            return true
        end
        pcall(function() stealConnection:Disconnect() end)
        stealConnection = nil
    end
    Steal.StealRadius = CONFIG.STEAL_RANGE
    Steal.AutoStealEnabled = true
    CONFIG.AUTO_STEAL_ENABLED = true
    local scanAccumulator = 0
    stealConnection = RunService.Heartbeat:Connect(function(dt)
        if not Steal.AutoStealEnabled or isStealing then return end
        scanAccumulator = scanAccumulator + (dt or 0.016)
        -- Full plot scans run at 5 Hz to reduce CPU and frame-time spikes.
        if scanAccumulator < 0.20 then return end
        scanAccumulator = 0
        local p, n = findNearestPrompt()
        if p then executeSteal(p, n) end
    end)
    return true
end

function stopAutoSteal()
    if stealConnection then
        stealConnection:Disconnect()
        stealConnection = nil
    end
    isStealing = false
    Steal.AutoStealEnabled = false
    CONFIG.AUTO_STEAL_ENABLED = false
    if progressFill then
        TS:Create(progressFill, TweenInfo.new(0.2), { Size = UDim2.new(0, 0, 1, 0) }):Play()
    end
    if progressPct then progressPct.Text = "0%" end
    if _G.__FreshStealBarStatus then _G.__FreshStealBarStatus.Text = "WAITING" end
    updateProgressBarVisibility()
end

-- ============================================================
-- 13. ESP, VELOCIDAD ENEMIGA, BODY LOCK E INDICADOR DE VELOCIDAD
-- ============================================================
espEnabled = false
bodyLockEnabled = false
bodyLockRange = 20
bodyLockRangeBox = nil
_bodyLockConn = nil
_blSuppressCount = 0
_blWasEnabled = false
_blRestoreTimer = nil
_blSmoothRestore = false
enemySpeedConn = nil
enemySpeedLabels = {}
enemySpeedSamples = setmetatable({}, {__mode = "k"})
setESPVIsual = nil
local espConn = nil
local espRenderBound = false
local espAddedConn = nil
local espRemovingConn = nil
local espScreenGui = nil
local espLoopToken = 0
local _espInterval = 0.0

local function clearLegacyPlayerESPDecorations()
    for _, player in ipairs(Players:GetPlayers()) do
        local character = player.Character
        if character then
            for _, object in ipairs(character:GetDescendants()) do
                if (object:IsA("Highlight") and (object.Name == "BloodHoundsESP" or object.Name == "VX7_ESPPlayer"))
                    or (object:IsA("BillboardGui") and (object.Name == "ProfilePic" or object.Name == "FreshPlayerHitboxBox")) then
                    pcall(function() object:Destroy() end)
                end
            end
        end
    end
end

local function clearESP()
    for player, box in pairs(espBoxCache) do
        if box then pcall(function() box:Destroy() end) end
        espBoxCache[player] = nil
    end
    for player, line in pairs(espLineCache) do
        if line then pcall(function() line:Destroy() end) end
        espLineCache[player] = nil
    end
    if espScreenGui and espScreenGui.Parent then
        pcall(function() espScreenGui:Destroy() end)
    end
    espScreenGui = nil
    clearLegacyPlayerESPDecorations()
end

local function ensureESPBoxGui()
    if espScreenGui and espScreenGui.Parent then return espScreenGui end
    espScreenGui = Instance.new("ScreenGui")
    espScreenGui.Name = "VX7_ESPBox2D"
    espScreenGui.ResetOnSpawn = false
    espScreenGui.IgnoreGuiInset = true
    espScreenGui.DisplayOrder = 998
    espScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
    espScreenGui.Parent = LP:WaitForChild("PlayerGui")
    return espScreenGui
end

local function makeESPBox(player)
    if not player or player == LP then return nil end
    local existing = espBoxCache[player]
    if existing and existing.Parent then return existing end
    if not player.Character then return nil end
    local frame = Instance.new("Frame")
    frame.Name = "VX7_ESPBox_" .. tostring(player.UserId)
    frame.BackgroundColor3 = getThemeColor()
    frame.BackgroundTransparency = 0.78
    frame.BorderSizePixel = 0
    frame.Visible = false
    frame.ZIndex = 2
    frame.Parent = ensureESPBoxGui()
    local stroke = Instance.new("UIStroke")
    stroke.Name = "VX7ESPStroke"
    stroke.Color = getThemeColor()
    stroke.Thickness = 1.5
    stroke.Transparency = 0
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent = frame
    espBoxCache[player] = frame
    return frame
end

local function removeESPBox(player)
    local box = espBoxCache[player]
    if box then pcall(function() box:Destroy() end) end
    espBoxCache[player] = nil
    local line = espLineCache[player]
    if line then pcall(function() line:Destroy() end) end
    espLineCache[player] = nil
end

local ESP_LINE_COLOR = themePalette.accent

local function makeESPLine(player)
    if not player or player == LP then return nil end
    local existing = espLineCache[player]
    if existing and existing.Parent then return existing end
    local line = Instance.new("Frame")
    line.Name = "VX7_ESPLine_" .. tostring(player.UserId)
    -- Igual que VX7: la línea se posiciona por su punto medio.
    line.AnchorPoint = Vector2.new(0.5, 0.5)
    line.BackgroundColor3 = ESP_LINE_COLOR
    line.BackgroundTransparency = 0.05
    line.BorderSizePixel = 0
    line.Size = UDim2.fromOffset(0, 2)
    line.Visible = false
    line.ZIndex = 1
    line.Parent = ensureESPBoxGui()
    espLineCache[player] = line
    return line
end

local function updateESPLine(line, fromPoint, toPoint)
    local delta = toPoint - fromPoint
    local length = delta.Magnitude
    if length <= 0 or length ~= length then
        line.Visible = false
        return
    end
    line.Position = UDim2.fromOffset(
        (fromPoint.X + toPoint.X) * 0.5,
        (fromPoint.Y + toPoint.Y) * 0.5
    )
    line.Size = UDim2.fromOffset(math.max(length, 1), 2)
    line.Rotation = math.deg(math.atan2(delta.Y, delta.X))
    line.Visible = true
end

local function updateESP()
    if not espEnabled then return end
    local camera = workspace.CurrentCamera
    if not camera then return end
    local accent = getThemeColor()
    for _, player in ipairs(_GetPlayersCached()) do
        if player ~= LP then
            local box = makeESPBox(player)
            local line = makeESPLine(player)
            local character = player.Character
            local humanoid = character and character:FindFirstChildOfClass("Humanoid")
            local root = character and character:FindFirstChild("HumanoidRootPart")
            if box and line and character and humanoid and root and humanoid.Health > 0 then
                local head = character:FindFirstChild("Head")
                local topWorld = (head and head.Position or root.Position + Vector3.new(0, 1, 0)) + Vector3.new(0, 1.6, 0)
                local bottomWorld = root.Position - Vector3.new(0, 3, 0)
                local top, topVisible = camera:WorldToViewportPoint(topWorld)
                local bottom, bottomVisible = camera:WorldToViewportPoint(bottomWorld)
                -- Origen VX7: centro del HumanoidRootPart local; si no está
                -- proyectado, se usa el centro inferior de la pantalla.
                local targetPoint = camera:WorldToViewportPoint(root.Position)
                local viewport = camera.ViewportSize
                local originPoint = Vector2.new(viewport.X * 0.5, viewport.Y)
                local localCharacter = LP.Character
                local localRoot = localCharacter and localCharacter:FindFirstChild("HumanoidRootPart")
                if localRoot then
                    local projectedLocal = camera:WorldToViewportPoint(localRoot.Position)
                    if projectedLocal.Z > 0 then
                        originPoint = Vector2.new(projectedLocal.X, projectedLocal.Y)
                    end
                end
                local target2D = Vector2.new(targetPoint.X, targetPoint.Y)
                if targetPoint.Z < 0 then
                    target2D = Vector2.new(viewport.X - targetPoint.X, viewport.Y - targetPoint.Y)
                end
                if targetPoint.Z ~= 0 then
                    updateESPLine(line, originPoint, target2D)
                else
                    line.Visible = false
                end
                local height = math.abs(bottom.Y - top.Y)
                local width = height * 0.55
                local stroke = box:FindFirstChild("VX7ESPStroke")
                box.BackgroundColor3 = accent
                if stroke then stroke.Color = accent end
                if topVisible and bottomVisible and top.Z > 0 and bottom.Z > 0
                    and height == height and width == width and height > 0 then
                    box.Size = UDim2.fromOffset(width, height)
                    box.Position = UDim2.fromOffset((top.X + bottom.X) * 0.5 - width * 0.5, math.min(top.Y, bottom.Y))
                    box.Visible = true
                else
                    box.Visible = false
                end
            elseif box then
                box.Visible = false
                local line = espLineCache[player]
                if line then line.Visible = false end
            end
        end
    end
    for player, box in pairs(espBoxCache) do
        if player.Parent ~= Players then
            if box then pcall(function() box:Destroy() end) end
            espBoxCache[player] = nil
            local line = espLineCache[player]
            if line then pcall(function() line:Destroy() end) end
            espLineCache[player] = nil
        end
    end
end

local function startESPLoop()
    if espRenderBound then return end
    clearESP()
    espLoopToken = espLoopToken + 1
    local token = espLoopToken
    espRenderBound = true
    local espAccumulator = 0
    local function updateESPAt30Hz(dt)
        espAccumulator = espAccumulator + (dt or 0)
        if espAccumulator < (1 / 30) then return end
        espAccumulator = espAccumulator % (1 / 30)
        if espEnabled and token == espLoopToken then updateESP() end
    end
    espAddedConn = Players.PlayerAdded:Connect(function(player)
        if espEnabled and player ~= LP then pcall(function() makeESPBox(player) end) end
    end)
    espRemovingConn = Players.PlayerRemoving:Connect(function(player)
        removeESPBox(player)
    end)
    local ok = pcall(function()
        RunService:BindToRenderStep("FreshHubVX7ESP", Enum.RenderPriority.Camera.Value + 2, updateESPAt30Hz)
    end)
    if not ok then
        espConn = RunService.RenderStepped:Connect(updateESPAt30Hz)
    end
end

local function stopESPLoop()
    espLoopToken = espLoopToken + 1
    if espRenderBound then
        pcall(function() RunService:UnbindFromRenderStep("FreshHubVX7ESP") end)
    end
    if espConn then pcall(function() espConn:Disconnect() end); espConn = nil end
    if espAddedConn then pcall(function() espAddedConn:Disconnect() end); espAddedConn = nil end
    if espRemovingConn then pcall(function() espRemovingConn:Disconnect() end); espRemovingConn = nil end
    espRenderBound = false
    clearESP()
end

function toggleESP(on)
    espEnabled = on == true
    if espEnabled then startESPLoop() else stopESPLoop() end
    if setESPVIsual then setESPVIsual(espEnabled) end
end

function updateEnemySpeedLabels()
    local players = _GetPlayersCached()
    local color = FreshBubbleOverheadColor()
    for i = 1, #players do
        local player = players[i]
        if player ~= LP then
            local char = player.Character
            local head = char and char:FindFirstChild("Head")
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if head and hrp and hum and hum.Health > 0 then
                local previousLabel = enemySpeedLabels[player]
                if previousLabel and previousLabel.Parent and previousLabel.Parent.Parent ~= head then
                    pcall(function() previousLabel.Parent:Destroy() end)
                    previousLabel = nil
                end
                local billboard = head:FindFirstChild("GreenDuelsBB")
                local label = billboard and billboard:FindFirstChild("SpeedBillLbl")
                if not billboard or not billboard:IsA("BillboardGui") or not label or not label:IsA("TextLabel") then
                    local old = head:FindFirstChild("EnemySpeedGui")
                    if old then old:Destroy() end
                    if billboard then billboard:Destroy() end
                    billboard, label = createFreshBubbleSpeedBillboard(head, false)
                end
                enemySpeedLabels[player] = label
                if label then
                    local velocity = hrp.AssemblyLinearVelocity
                    local speed = Vector3.new(velocity.X, 0, velocity.Z).Magnitude
                    if speed < 0.5 then speed = 0 end
                    local speedText = tostring(math.floor(speed + 0.5))
                    if label.Text ~= speedText then label.Text = speedText end
                    if label.TextColor3 ~= color then styleFreshBubbleOverheadText(label, 1.9) end
                end
            else
                local label = enemySpeedLabels[player]
                if label and label.Parent then pcall(function() label.Parent:Destroy() end) end
                enemySpeedLabels[player] = nil
                enemySpeedSamples[player] = nil
            end
        end
    end
end

function startEnemySpeed()
    if enemySpeedConn then
        pcall(function() enemySpeedConn:Disconnect() end)
        pcall(function() enemySpeedConn.active = false end)
    end
    local worker = {active = true}
    enemySpeedConn = worker
    task.spawn(function()
        while worker.active and enemySpeedConn == worker do
            updateEnemySpeedLabels()
            local count = #_GetPlayersCached()
            -- El indicador no necesita 7 actualizaciones/s; reducir recorridos
            -- de jugadores baja trabajo de Lua y escrituras de UI.
            local interval = count > 35 and 0.75 or (count > 20 and 0.55 or 0.40)
            task.wait(interval)
        end
    end)
end

function stopEnemySpeed()
    if enemySpeedConn then
        pcall(function() enemySpeedConn:Disconnect() end)
        pcall(function() enemySpeedConn.active = false end)
        enemySpeedConn = nil
    end
    -- Eliminar tambien los BillboardGui creados para jugadores anteriores.
    for player, label in pairs(enemySpeedLabels) do
        pcall(function()
            local bb = label and label.Parent
            if bb then bb:Destroy() end
        end)
        enemySpeedLabels[player] = nil
    end
    enemySpeedSamples = setmetatable({}, {__mode = "k"})
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
        -- Keep the toggle/connection on. _bodyLockTick pauses only while a
        -- mutually exclusive movement controller (aimbot/auto-route) is active.
        _blWasEnabled = true
    end
end

function _unsuppressBodyLock(delayed)
    if _blSuppressCount > 0 then
        _blSuppressCount = _blSuppressCount - 1
    end
    if _blSuppressCount == 0 and _blWasEnabled then
        _blWasEnabled = false
        if bodyLockEnabled then
            if not _bodyLockConn then startBodyLock() end
            if bodyLockSetVisual then bodyLockSetVisual(true) end
        end
    end
end

function FreshBubbleOverheadColor()
    return Color3.fromRGB(192, 132, 252)
end

function styleFreshBubbleOverheadText(label, outlineThickness)
    if not label then return end
    local primaryColor = FreshBubbleOverheadColor()
    label.Font = Enum.Font.GothamBlack
    label.TextColor3 = primaryColor
    label.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    label.TextStrokeTransparency = 0
    local outline = label:FindFirstChild("FreshOverheadOutline")
    if not outline then
        outline = Instance.new("UIStroke")
        outline.Name = "FreshOverheadOutline"
        outline.Parent = label
    end
    outline.Color = Color3.fromRGB(0, 0, 0)
    outline.Thickness = outlineThickness or 2.25
    outline.Transparency = 0.2
    if label.RichText then
        local richGradient = label:FindFirstChild("FreshOverheadGradient")
        if richGradient then richGradient:Destroy() end
        label.TextColor3 = primaryColor
        return
    end
    local gradient = label:FindFirstChild("FreshOverheadGradient")
    if not gradient then
        gradient = Instance.new("UIGradient")
        gradient.Name = "FreshOverheadGradient"
        gradient.Parent = label
    end
    local palette = themePalette
    if label.Name == "SpeedBillLbl" then
        gradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, palette and palette.accentDark or Color3.fromRGB(88, 28, 135)),
            ColorSequenceKeypoint.new(0.34, palette and palette.accent or Color3.fromRGB(147, 51, 234)),
            ColorSequenceKeypoint.new(0.68, palette and palette.accentMid or Color3.fromRGB(216, 180, 254)),
            ColorSequenceKeypoint.new(1, palette and palette.accent or Color3.fromRGB(147, 51, 234)),
        })
    else
        gradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, palette and palette.accent or primaryColor),
            ColorSequenceKeypoint.new(0.48, palette and (palette.accentMid or palette.accent) or primaryColor),
            ColorSequenceKeypoint.new(1, palette and palette.secondary or primaryColor),
        })
    end
    gradient.Rotation = 0
end

function createFreshBubbleSpeedBillboard(head, isLocalPlayer)
    if not head then return nil, nil end
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "GreenDuelsBB"
    billboard:SetAttribute("FreshHubOverhead", true)
    billboard.Size = isLocalPlayer and UDim2.fromOffset(190, 60) or UDim2.fromOffset(130, 42)
    billboard.StudsOffset = isLocalPlayer and Vector3.new(0, 1.8, 0) or Vector3.new(0, 1.65, 0)
    billboard.AlwaysOnTop = true
    billboard.LightInfluence = 0
    billboard.MaxDistance = 0
    billboard.Parent = head

    local title = Instance.new("TextLabel")
    title.Name = "FreshHubLabel"
    title.Size = UDim2.new(1, 0, 0, isLocalPlayer and 28 or 22)
    title.Position = UDim2.new(0, 0, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = isLocalPlayer and ".gg/freshduels" or ""
    title.Visible = isLocalPlayer
    title.TextScaled = false
    title.TextSize = isLocalPlayer and 19 or 15
    title.Font = Enum.Font.GothamBlack
    title.TextColor3 = Color3.fromRGB(192, 132, 252)
    title.TextXAlignment = Enum.TextXAlignment.Center
    title.TextYAlignment = Enum.TextYAlignment.Center
    styleFreshBubbleOverheadText(title, isLocalPlayer and 1.75 or 2.25)
    title.Parent = billboard

    local speedText = Instance.new("TextLabel")
    speedText.Name = "SpeedBillLbl"
    speedText.Size = UDim2.new(1, 0, 0, isLocalPlayer and 29 or 20)
    speedText.Position = UDim2.new(0, 0, 0, isLocalPlayer and 30 or 22)
    speedText.BackgroundTransparency = 1
    speedText.Text = isLocalPlayer and "0.0" or "0"
    speedText.TextScaled = false
    speedText.TextSize = isLocalPlayer and 22 or 16
    speedText.Font = Enum.Font.GothamBlack
    speedText.TextColor3 = Color3.fromRGB(192, 132, 252)
    speedText.TextXAlignment = Enum.TextXAlignment.Center
    speedText.TextYAlignment = Enum.TextYAlignment.Center
    speedText.RichText = false
    styleFreshBubbleOverheadText(speedText, isLocalPlayer and 1.75 or 2.25)
    speedText.Parent = billboard
    return billboard, speedText
end

function setupSpeedIndicator(char)
    local head = char:WaitForChild("Head", 5)
    if not head then return end
    for _, name in ipairs({"BloodHoundsSpeedIndicator", "GreenDuelsBB", "BubbleSpeedBill", "BubbleHubOverhead"}) do
        local old = head:FindFirstChild(name)
        if old then old:Destroy() end
    end
    local _, label = createFreshBubbleSpeedBillboard(head, true)
    speedLabel = label
end

-- ============================================================
-- 14. COMBATE: AIMBOT, AUTO BAT, ANTI BAT, CONTADORES, MEDUSA Y DROP
-- ============================================================
medusaCounterEnabled = false
batCounterEnabled = false
autoBatEnabled = false
antiBatEnabled = false
dropMode = 2
AUTO_SWING_ENABLED = true
medusaDebounce = false
medusaLastUsed = 0
dropActive = false
lastDropTime = 0
_aimbotConn = nil
medusaResetConns = {}
dropConnections = {}
autoBatSetVisual, autoLeftSetVisual, autoRightSetVisual, setBatCounterVisual, setMedusaVisual = nil, nil, nil, nil, nil
setAntiBatVisual = nil
mobSetAutoBat, mobSetAutoLeft, mobSetAutoRight, mobSetDropBR, mobSetTpDown, mobSetCarry, mobSetLagger1, mobSetLagger2 = nil, nil, nil, nil, nil, nil, nil, nil

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

local function doTpDown()
    pcall(function()
        local char = LP.Character
        if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        if not root then return end
        root.CFrame = _CFnew(root.Position.X, -7, root.Position.Z) * CFrame.Angles(0, select(2, root.CFrame:ToEulerAnglesYXZ()), 0)
        root.Velocity = _V3zero
    end)
end

function trySwing()
    local char = LP.Character
    if not char then return false end
    local bat = findBat()
    if not bat then return false end
    if bat.Parent ~= char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hum then return false end
        pcall(function() hum:EquipTool(bat) end)
    end
    if bat.Parent ~= char then return false end
    local activated = pcall(function() bat:Activate() end)
    return activated
end

-- Bat Aimbot basado en el algoritmo de movimiento/prediccion VX7.
-- Se conservan las llamadas, toggles, velocidades y protecciones de Fresh Hub.
Vx7BatAimbot = {
    connection = nil,
    moverName = "VX7AimbotMoveVelocity",
    attachmentName = "VX7AimbotMoveAttachment",
    lastSwing = 0,
    swingInterval = 0.14,
    swingRange = 12.5,
    lockedTarget = nil,
    lockUntil = 0,
    targetLockDuration = 0.78,
    targetSwitchMargin = 4.5,
    swingFailures = 0,
}

_G._AdaptTPMirrorEnabled = false

function vx7BatAimbotClearMover(root)
    root = root or (LP.Character and LP.Character:FindFirstChild("HumanoidRootPart"))
    if not root then return end
    local mover = root:FindFirstChild(Vx7BatAimbot.moverName)
    local attachment = root:FindFirstChild(Vx7BatAimbot.attachmentName)
    if mover then pcall(function() mover:Destroy() end) end
    if attachment then pcall(function() attachment:Destroy() end) end
end

function vx7BatAimbotEnsureMover(root, speed)
    local attachment = root:FindFirstChild(Vx7BatAimbot.attachmentName)
    if attachment and not attachment:IsA("Attachment") then
        attachment:Destroy()
        attachment = nil
    end
    if not attachment then
        attachment = Instance.new("Attachment")
        attachment.Name = Vx7BatAimbot.attachmentName
        attachment.Parent = root
    end
    local mover = root:FindFirstChild(Vx7BatAimbot.moverName)
    if not mover or not mover:IsA("LinearVelocity") then
        if mover then mover:Destroy() end
        mover = Instance.new("LinearVelocity")
        mover.Name = Vx7BatAimbot.moverName
        mover.Attachment0 = attachment
        mover.RelativeTo = Enum.ActuatorRelativeTo.World
        mover.VelocityConstraintMode = Enum.VelocityConstraintMode.Vector
        mover.ForceLimitsEnabled = true
        mover.ForceLimitMode = Enum.ForceLimitMode.PerAxis
        mover.VectorVelocity = Vector3.zero
        mover.Parent = root
    else
        mover.Attachment0 = attachment
    end
    local force = math.clamp(root.AssemblyMass * math.max(speed * 220, 6000), 1000000, 50000000)
    mover.MaxAxesForce = Vector3.new(force, force, force)
    mover.Enabled = true
    return mover
end

function vx7BatAimbotCurrentSpeed()
    local configured = laggerCarryToggled and LAGGER_CARRY_SPEED
        or (laggerToggled and LAGGER_SPEED or BAT_AIMBOT_SPEED)
    return math.clamp(tonumber(configured) or 58, 1, 500)
end

function vx7BatAimbotNearestTarget(root)
    local nearestRoot, nearestDistance = nil, math.huge
    for _, player in ipairs(_GetPlayersCached()) do
        if player ~= LP then
            local character = player.Character
            local targetRoot = character and character:FindFirstChild("HumanoidRootPart")
            local targetHumanoid = character and character:FindFirstChildOfClass("Humanoid")
            if targetRoot and targetRoot.Parent and targetHumanoid and targetHumanoid.Health > 0 then
                local state = targetHumanoid:GetState()
                if state ~= Enum.HumanoidStateType.Dead then
                    local distance = (targetRoot.Position - root.Position).Magnitude
                    if distance < nearestDistance then
                        nearestRoot, nearestDistance = targetRoot, distance
                    end
                end
            end
        end
    end
    return nearestRoot
end

function vx7BatAimbotResetMotion()
    local character = LP.Character
    local root = character and character:FindFirstChild("HumanoidRootPart")
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    if root then
        vx7BatAimbotClearMover(root)
        root.Anchored = false
        root.AssemblyLinearVelocity = Vector3.zero
        root.AssemblyAngularVelocity = Vector3.zero
        local look = root.CFrame.LookVector
        local flatLook = Vector3.new(look.X, 0, look.Z)
        if flatLook.Magnitude > 0.01 then
            root.CFrame = CFrame.lookAt(root.Position, root.Position + flatLook.Unit)
        end
    end
    if humanoid then
        humanoid.AutoRotate = true
        humanoid.PlatformStand = false
        pcall(function() humanoid:Move(Vector3.zero, false) end)
        pcall(function() humanoid:ChangeState(Enum.HumanoidStateType.Running) end)
    end
end

function vx7BatAimbotUpdate(dt)
    if not autoBatEnabled then return end
    local character = LP.Character
    local root = character and character:FindFirstChild("HumanoidRootPart")
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    if not character or not root or not humanoid or humanoid.Health <= 0 then return end
    dt = math.clamp(tonumber(dt) or (1 / 60), 1 / 240, 0.25)
    local targetRoot = vx7BatAimbotNearestTarget(root)
    if not targetRoot then
        humanoid.AutoRotate = true
        root.AssemblyAngularVelocity = Vector3.zero
        vx7BatAimbotClearMover(root)
        return
    end
    humanoid.AutoRotate = false
    if type(_G._adaptBatPred) ~= "table" then _G._adaptBatPred = {} end
    local now = _tick()
    local prediction = _G._adaptBatPred[targetRoot]
    local targetVelocity = Vector3.zero
    if not prediction then
        prediction = {pos = targetRoot.Position, time = now, vel = Vector3.zero}
        _G._adaptBatPred[targetRoot] = prediction
    else
        local elapsed = math.clamp(now - prediction.time, 1 / 120, 0.25)
        local measured = (targetRoot.Position - prediction.pos) / elapsed
        if measured.Magnitude > 100 then measured = measured.Unit * 100 end
        prediction.vel = prediction.vel:Lerp(measured, 0.42)
        prediction.pos = targetRoot.Position
        prediction.time = now
        targetVelocity = prediction.vel
    end
    local aimPosition = targetRoot.Position
        + targetVelocity * math.clamp(targetVelocity.Magnitude / 130, 0.045, 0.14)
        + Vector3.new(0, 1, 0)
    local initialDelta = aimPosition - root.Position
    local aimDirection = initialDelta.Magnitude > 0.01 and initialDelta.Unit or Vector3.zero
    local horizontalDirection = Vector3.new(initialDelta.X, 0, initialDelta.Z)
    if aimDirection.Magnitude > 0.01 and horizontalDirection.Magnitude > 0.01 then
        local yaw = (math.deg(math.atan2(-horizontalDirection.X, -horizontalDirection.Z))
            - root.Orientation.Y + 180) % 360 - 180
        local pitch = (math.deg(math.atan2(initialDelta.Y, horizontalDirection.Magnitude))
            - root.Orientation.X + 180) % 360 - 180
        local yawVelocity = math.clamp(math.rad(yaw) * 330, -34, 34)
        local pitchVelocity = math.clamp(math.rad(pitch) * 330, -34, 34)
        local facing = math.rad(root.Orientation.Y)
        local pitchAxis = Vector3.new(math.cos(facing), 0, -math.sin(facing))
        root.AssemblyAngularVelocity = Vector3.new(0, yawVelocity, 0) + pitchAxis * pitchVelocity
    else
        root.AssemblyAngularVelocity = Vector3.zero
    end
    local targetOffset = aimPosition + aimDirection * 2.8 + Vector3.new(0, 4.75, 0)
    local delta = targetOffset - root.Position
    local horizontal = Vector3.new(delta.X, 0, delta.Z)
    local speed = vx7BatAimbotCurrentSpeed()
    local horizontalVelocity = horizontal.Magnitude > 0.1 and horizontal.Unit * speed or Vector3.zero
    local verticalVelocity = math.abs(delta.Y) > 0.1
        and Vector3.new(0, math.sign(delta.Y) * 52, 0)
        or Vector3.new(0, -2, 0)
    local mover = vx7BatAimbotEnsureMover(root, speed)
    local alpha = 1 - math.exp(-math.max(dt, 0) * 34)
    mover.VectorVelocity = mover.VectorVelocity:Lerp(horizontalVelocity + verticalVelocity, alpha)
    if horizontal.Magnitude > 0.5 then humanoid:Move(horizontal.Unit, false) end
    local targetDistance = (targetRoot.Position - root.Position).Magnitude
    if AUTO_SWING_ENABLED
        and targetDistance <= Vx7BatAimbot.swingRange
        and now - Vx7BatAimbot.lastSwing >= Vx7BatAimbot.swingInterval then
        Vx7BatAimbot.lastSwing = now
        local ok = false
        pcall(function() ok = trySwing() == true end)
        if ok then
            Vx7BatAimbot.swingFailures = 0
        else
            Vx7BatAimbot.swingFailures = math.min((Vx7BatAimbot.swingFailures or 0) + 1, 4)
            Vx7BatAimbot.lastSwing = now + math.min(Vx7BatAimbot.swingFailures * 0.04, 0.16)
        end
    end
end

function stopAimbotAdapt()
    if Vx7BatAimbot.connection then
        pcall(function() Vx7BatAimbot.connection:Disconnect() end)
        Vx7BatAimbot.connection = nil
    end
    Vx7BatAimbot.lastSwing = 0
    Vx7BatAimbot.lockedTarget = nil
    Vx7BatAimbot.lockUntil = 0
    Vx7BatAimbot.swingFailures = 0
    _G._AdaptTPMirrorEnabled = false
    _G._adaptBatPred = nil
    _G.__VX7ClearAimbotMover = nil
    vx7BatAimbotResetMotion()
    _unsuppressBodyLock(true)
    if type(_G.__refreshSpeedBoost) == "function" then pcall(_G.__refreshSpeedBoost) end
end

function startAimbotAdapt()
    if Vx7BatAimbot.connection then
        pcall(function() Vx7BatAimbot.connection:Disconnect() end)
        Vx7BatAimbot.connection = nil
    end
    if type(_G.__stopSpeedBoost) == "function" then pcall(_G.__stopSpeedBoost) end
    if type(_G.__deactivateBatExclusive) == "function" then
        pcall(_G.__deactivateBatExclusive, "Aimbot")
    end
    _suppressBodyLock()
    _G._AdaptTPMirrorEnabled = true
    _G._adaptBatPred = {}
    _G.__VX7ClearAimbotMover = function() vx7BatAimbotClearMover() end
    local function connectAimbot()
        if not autoBatEnabled or Vx7BatAimbot.connection then return end
        vx7BatAimbotResetMotion()
        local character = LP.Character
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        if not character or not humanoid then return end
        if not character:FindFirstChildOfClass("Tool") then
            local bat = findBat()
            if bat and bat.Parent ~= character then pcall(function() humanoid:EquipTool(bat) end) end
        end
        BAT_AIMBOT_VERSION = 1
        _sharedEnv.__FreshHubAimbotVersion = 1
        Vx7BatAimbot.connection = RunService.RenderStepped:Connect(vx7BatAimbotUpdate)
    end
    if type(_G.__checkAndAutoDrop) == "function" then
        local ok = pcall(_G.__checkAndAutoDrop, connectAimbot)
        if not ok then connectAimbot() end
    else
        connectAimbot()
    end
end

function disableAutoBat()
    autoBatEnabled = false
    CarrySystem._batAimbotToggled = false
    if autoBatSetVisual then autoBatSetVisual(false) end
    if mobSetAutoBat then mobSetAutoBat(false) end
    stopAimbotAdapt()
end

function enableAutoBat()
    autoBatEnabled = true
    CarrySystem._batAimbotToggled = true
    if autoBatSetVisual then autoBatSetVisual(true) end
    if mobSetAutoBat then mobSetAutoBat(true) end
    startAimbotAdapt()
end

-- El Infinite Jump propio de Fresh permanece como opcion independiente.
CleanAntiBatInfJump = {enabled = false, connection = nil}

function startCleanAntiBatInfJump()
    if CleanAntiBatInfJump.connection then return end
    CleanAntiBatInfJump.enabled = true
    CleanAntiBatInfJump.connection = RunService.PreSimulation:Connect(function()
        if not CleanAntiBatInfJump.enabled then return end
        local character = LP.Character
        if not character then return end
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        local root = character:FindFirstChild("HumanoidRootPart")
        if not humanoid or not root then return end

        local velocity = root.AssemblyLinearVelocity
        local jumpHeld = UIS:IsKeyDown(Enum.KeyCode.Space)
            or UIS:IsKeyDown(Enum.KeyCode.ButtonA)
            or (humanoid.Jump == true)
        if jumpHeld then
            if velocity.Y < 35 then
                root.AssemblyLinearVelocity = _V3new(velocity.X, 55, velocity.Z)
            end
            if velocity.Y < -120 then
                root.AssemblyLinearVelocity = _V3new(velocity.X, -120, velocity.Z)
            end
        elseif velocity.Y < -120 then
            root.AssemblyLinearVelocity = _V3new(velocity.X, -120, velocity.Z)
        end
    end)
end

function stopCleanAntiBatInfJump()
    CleanAntiBatInfJump.enabled = false
    if CleanAntiBatInfJump.connection then
        CleanAntiBatInfJump.connection:Disconnect()
        CleanAntiBatInfJump.connection = nil
    end
end

local AntiBat = {Connection = nil}

function stopAntiBat()
    antiBatEnabled = false
    if AntiBat.Connection then
        pcall(function() AntiBat.Connection:Disconnect() end)
        AntiBat.Connection = nil
    end
    stopCleanAntiBatInfJump()
end

function startAntiBat()
    stopAntiBat()
    antiBatEnabled = true
    startCleanAntiBatInfJump()

    AntiBat.Connection = RunService.Heartbeat:Connect(function()
        if not antiBatEnabled then return end
        local character = LP.Character
        if not character then return end
        local root = character:FindFirstChild("HumanoidRootPart")
        if not root then return end
        local velocity = root.Velocity
        root.Velocity = _V3new(
            math.random(-4000, 4000),
            velocity.Y,
            math.random(-4000, 4000)
        )
        RunService.RenderStepped:Wait()
        if root and root.Parent then
            root.Velocity = velocity
        end
    end)
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
    local bp = LP:FindFirstChildOfClass("Backpack")
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
        if not hum2 then medusaDebounce = false; return end
        pcall(function() hum2:EquipTool(med) end)
        local equipDeadline = _tick() + 0.75
        while med.Parent ~= c and _tick() < equipDeadline do
            task.wait(0.05)
        end
    end
    if med.Parent == c then
        -- Usar la activacion nativa del Tool conserva el sonido original del juego.
        pcall(function() med:Activate() end)
        medusaLastUsed = _tick()
    end
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

local DROP_ASCEND_DURATION = 0.22
local DROP_ASCEND_SPEED = 160
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
    dropActive = true
    if dropBrainrotSetVisual then dropBrainrotSetVisual(true) end
    if mobSetDropBR then mobSetDropBR(true) end
    local t0 = _tick()
    if _dropConn then _dropConn:Disconnect() end
    _dropConn = RunService.Heartbeat:Connect(function()
        local c = LP.Character
        local r = c and c:FindFirstChild("HumanoidRootPart")
        if not r then
            if _dropConn then _dropConn:Disconnect(); _dropConn = nil end
            dropActive = false
            if dropBrainrotSetVisual then dropBrainrotSetVisual(false) end
            if mobSetDropBR then mobSetDropBR(false) end
            return
        end
        if not dropActive then
            if _dropConn then _dropConn:Disconnect(); _dropConn = nil end
            if dropBrainrotSetVisual then dropBrainrotSetVisual(false) end
            if mobSetDropBR then mobSetDropBR(false) end
            return
        end
        if _tick() - t0 >= DROP_ASCEND_DURATION then
            if _dropConn then _dropConn:Disconnect(); _dropConn = nil end
            local hum2 = c:FindFirstChildOfClass("Humanoid")
            pcall(function()
                local rp = RaycastParams.new()
                rp.FilterDescendantsInstances = {c}
                rp.FilterType = Enum.RaycastFilterType.Exclude
                local rr = workspace:Raycast(r.Position, _V3new(0, -3000, 0), rp)
                if rr then
                    local off = ((hum2 and hum2.HipHeight) or 2) + (r.Size.Y / 2)
                    r.CFrame = _CFnew(r.Position.X, rr.Position.Y + off, r.Position.Z)
                    r.AssemblyLinearVelocity = _V3zero
                    r.AssemblyAngularVelocity = _V3zero
                end
                if hum2 and hum2.Health > 0 then hum2:ChangeState(Enum.HumanoidStateType.Running) end
            end)
            dropActive = false
            if dropBrainrotSetVisual then dropBrainrotSetVisual(false) end
            if mobSetDropBR then mobSetDropBR(false) end
            return
        end
        local lv = r.AssemblyLinearVelocity
        r.AssemblyLinearVelocity = _V3new(lv.X, DROP_ASCEND_SPEED, lv.Z)
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

function disableAllAimbots()
    if autoBatEnabled then
        disableAutoBat()
        if autoBatSetVisual then autoBatSetVisual(false) end
        if mobSetAutoBat then mobSetAutoBat(false) end
    end
end

-- ============================================================
-- 15. ANTI-RAGDOLL, ANTI-DIE Y ANTI-FLING
-- ============================================================
antiRagdollMode = "off"

-- Estado por defecto apagado; la preferencia guardada decide si se inicia.
antiDieEnabled = false

antiFlingEnabled = false
setAntiDieVisual = nil

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
        if not hum or not root then return end
        if hum.Health <= 0 or hum:GetState() == Enum.HumanoidStateType.Dead then return end
        local state = hum:GetState()
        local now = _tick()
        if state == Enum.HumanoidStateType.Physics or
           state == Enum.HumanoidStateType.Ragdoll or
           state == Enum.HumanoidStateType.FallingDown then
            if now - AntiRagdollV2.ResetCooldown > 0.15 then
                AntiRagdollV2.ResetCooldown = now
                pcall(function()
                    if hum:GetState() == Enum.HumanoidStateType.GettingUp then return end
                    if hum.Health <= 0 or hum:GetState() == Enum.HumanoidStateType.Dead then return end
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

function setAntiRagdollMode(enabled)
    enabled = enabled == true or enabled == "v2"
    antiRagdollMode = enabled and "v2" or "off"
    if enabled then startAntiRagdollV2() else stopAntiRagdollV2() end
    if _G.updateAntiRagdollUI then _G.updateAntiRagdollUI(enabled) end
    saveAllSettings()
end

local AntiDieModule = {
    enabled = false,
    healthConn = nil,
    diedConn = nil,
    charConn = nil,
    humanoid = nil,
    _reviving = false,
}

local function disconnectHumanoid()
    if AntiDieModule.healthConn then AntiDieModule.healthConn:Disconnect(); AntiDieModule.healthConn = nil end
    if AntiDieModule.diedConn then AntiDieModule.diedConn:Disconnect(); AntiDieModule.diedConn = nil end
    AntiDieModule.humanoid = nil
end

local function activateOnCharacter(char)
    if not AntiDieModule.enabled then return end
    char = char or LP.Character or LP.CharacterAdded:Wait()
    local hum = char:FindFirstChildOfClass("Humanoid") or char:WaitForChild("Humanoid", 3)
    if not hum or not AntiDieModule.enabled then return end
    disconnectHumanoid()
    AntiDieModule.humanoid = hum

    pcall(function()
        hum.BreakJointsOnDeath = false
        hum.RequiresNeck = false
        hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
        hum:SetStateEnabled(Enum.HumanoidStateType.Dying, false)
    end)

    AntiDieModule.healthConn = hum:GetPropertyChangedSignal("Health"):Connect(function()
        if not AntiDieModule.enabled or not hum.Parent then return end
        if hum.Health <= 0 and not AntiDieModule._reviving then
            AntiDieModule._reviving = true
            pcall(function()
                hum.Health = hum.MaxHealth
                hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
                if hum.Health > 0 then
                    hum:ChangeState(Enum.HumanoidStateType.Running)
                end
            end)
            task.delay(0.2, function() AntiDieModule._reviving = false end)
        end
    end)

    AntiDieModule.diedConn = hum.Died:Connect(function()
        if not AntiDieModule.enabled or not char.Parent then return end
        if AntiDieModule._reviving then return end
        AntiDieModule._reviving = true
        task.defer(function()
            if not AntiDieModule.enabled or not char.Parent or not hum.Parent then
                AntiDieModule._reviving = false
                return
            end
            pcall(function()
                hum.Health = hum.MaxHealth
                hum:ChangeState(Enum.HumanoidStateType.Running)
            end)
            AntiDieModule._reviving = false
        end)
    end)
end

function AntiDieModule.start()
    AntiDieModule.enabled = true
    if AntiDieModule.charConn then AntiDieModule.charConn:Disconnect() end
    AntiDieModule.charConn = LP.CharacterAdded:Connect(function(char)
        if AntiDieModule.enabled then task.defer(function() activateOnCharacter(char) end) end
    end)
    task.defer(function() activateOnCharacter(LP.Character) end)
    print("[AntiDie] Activado (interno)")
end

function AntiDieModule.stop()
    AntiDieModule.enabled = false
    if AntiDieModule.charConn then AntiDieModule.charConn:Disconnect(); AntiDieModule.charConn = nil end
    local hum = AntiDieModule.humanoid
    disconnectHumanoid()
    if hum and hum.Parent then
        pcall(function()
            hum.BreakJointsOnDeath = true
            hum.RequiresNeck = true
            hum:SetStateEnabled(Enum.HumanoidStateType.Dead, true)
        end)
    end
    print("[AntiDie] Desactivado (interno)")
end

_G.AntiDie = AntiDieModule

local AntiFlingShieldModule = {
    enabled = false,
    loop = nil,
    velocityThreshold = 80,
}

local function stabilizeRoot(root)
    if not root or not root.Parent then return end
    local velocity = root.AssemblyLinearVelocity
    if velocity.Magnitude <= AntiFlingShieldModule.velocityThreshold then return end
    local stabilized = _V3new(0, velocity.Y, 0)
    pcall(function() root.AssemblyLinearVelocity = stabilized end)
    pcall(function() root.AssemblyAngularVelocity = _V3zero end)
    pcall(function() root.Velocity = stabilized end)
    pcall(function() root.RotVelocity = _V3zero end)
end

function AntiFlingShieldModule.start()
    AntiFlingShieldModule.enabled = true
    if AntiFlingShieldModule.loop then AntiFlingShieldModule.loop:Disconnect() end
    AntiFlingShieldModule.loop = RunService.Heartbeat:Connect(function()
        if not AntiFlingShieldModule.enabled then return end
        local char = LP.Character
        stabilizeRoot(char and char:FindFirstChild("HumanoidRootPart"))
    end)
    print("[AntiFlingShield] Activado (interno)")
end

function AntiFlingShieldModule.stop()
    AntiFlingShieldModule.enabled = false
    if AntiFlingShieldModule.loop then
        AntiFlingShieldModule.loop:Disconnect()
        AntiFlingShieldModule.loop = nil
    end
    print("[AntiFlingShield] Desactivado (interno)")
end

_G.AntiFlingShield = AntiFlingShieldModule

do
    local _ragCountdownRunning = false
ragdollTimerEnabled = true
ragdollTimerSetVisual = nil
    local function _getRagBillboard()
        local char = LP.Character
        if not char then return nil, nil end
        local head = char:FindFirstChild("Head")
        if not head then return nil, nil end
        local pGui = LP.PlayerGui
        local existing = pGui:FindFirstChild("RagCountdownBillboard")
        if existing then existing:Destroy() end
        local bb = Instance.new("BillboardGui")
        bb.Name = "RagCountdownBillboard"
        bb.Size = UDim2.new(0, 84, 0, 42)
        bb.StudsOffset = _V3new(0, 4.5, 0)
        bb.AlwaysOnTop = true
        bb.Adornee = head
        bb.Parent = pGui
        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(1, 0, 1, 0)
        lbl.AnchorPoint = Vector2.new(0.5, 0.5)
        lbl.Position = UDim2.new(0.5, 0, 0.5, 0)
        lbl.BackgroundTransparency = 1
        lbl.Font = UI_FONT_HEAVY
        lbl.TextScaled = true
        lbl.TextColor3 = themePalette.accent
        lbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        lbl.TextStrokeTransparency = 0
        lbl.Text = ""
        lbl.Parent = bb
        local grad = Instance.new("UIGradient", lbl)
        grad.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, themePalette.accent),
            ColorSequenceKeypoint.new(0.3, themePalette.accent),
            ColorSequenceKeypoint.new(0.5, themePalette.accent),
            ColorSequenceKeypoint.new(0.7, themePalette.accent),
            ColorSequenceKeypoint.new(1, themePalette.accent),
        })
        grad.Rotation = 45
        grad.Offset = Vector2.new(0,0)
        return bb, lbl
    end

    local function _ragPunch(lbl, text)
        if not (lbl and lbl.Parent) then return end
        lbl.Text = text
    end

    local function _startRagCountdown()
        if not ragdollTimerEnabled then return end
        if _ragCountdownRunning then return end
        _ragCountdownRunning = true
        task.spawn(function()
            local bb, lbl = _getRagBillboard()
            if not bb then _ragCountdownRunning = false; return end
            local timeLeft = 2.5
            local step = 0.1
            while timeLeft > 0 and bb.Parent do
                _ragPunch(lbl, string.format("%.1f", timeLeft))
                task.wait(step)
                timeLeft = timeLeft - step
            end
            if bb and bb.Parent then
                _ragPunch(lbl, "READY!")
                task.wait(0.5)
                if bb and bb.Parent then bb:Destroy() end
            end
            _ragCountdownRunning = false
        end)
    end

    local _wasRagdolled = false
    RunService.Heartbeat:Connect(function()
        local char = LP.Character
        if not char then _wasRagdolled = false; return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hum or hum.Health <= 0 then _wasRagdolled = false; return end
        local st = hum:GetState()
        local inRag = st == Enum.HumanoidStateType.Physics
                   or st == Enum.HumanoidStateType.Ragdoll
                   or st == Enum.HumanoidStateType.FallingDown
        if inRag and not _wasRagdolled then
            _wasRagdolled = true
            _startRagCountdown()
        elseif not inRag then
            _wasRagdolled = false
        end
    end)
end

-- ============================================================
-- 16. ANTI LAG
-- ============================================================
antiLagEnabled = false
antiLagDescConn = nil
setAntiRagVisual, setJumpVisual, setUnwalkVisual, setAntiLagVisual, setLockUIVisual, setInstaGrab, setFreshIntroVisual = nil, nil, nil, nil, nil, nil, nil

-- Anti Lag de Bubble Hub integrado.
-- Procesa el mapa por lotes, reduce carga de render y restaura todas las
-- propiedades modificadas al desactivarse para evitar dejar el mapa roto.
local antiLagSaved = setmetatable({}, {__mode = "k"})

local antiLagAnimationSaved = setmetatable({}, {__mode = "k"})
local antiLagDetached = {}
local antiLagConnections = {}
local antiLagGeneration = 0
local antiLagWorker = nil
local antiLagApplied = false
local antiLagProcessed = setmetatable({}, {__mode = "k"})
local antiLagPendingQueue = {}
local antiLagPendingSet = setmetatable({}, {__mode = "k"})
local antiLagPendingHead, antiLagPendingTail = 1, 0
local antiLagPendingWorker = nil
local antiLagRestoreWorker = nil

local function antiLagSet(instance, property, value)
    if not instance then return end
    local saved = antiLagSaved[instance]
    if not saved then
        saved = {}
        antiLagSaved[instance] = saved
    end
    local ok, current = pcall(function() return instance[property] end)
    if not ok or current == value then return end
    if saved[property] == nil then saved[property] = current end
    pcall(function() instance[property] = value end)
end

local function antiLagIsRelevant(instance)
    if not instance then return false end
    if instance:IsA("BasePart") then return true end
    local className = instance.ClassName
    return className == "Terrain"
        or className == "SpecialMesh"
        or className == "SurfaceAppearance"
        or className == "Decal"
        or className == "Texture"
        or className == "ParticleEmitter"
        or className == "Trail"
        or className == "Beam"
        or className == "Fire"
        or className == "Smoke"
        or className == "Sparkles"
        or className == "PointLight"
        or className == "SpotLight"
        or className == "SurfaceLight"
        or className == "BloomEffect"
        or className == "BlurEffect"
        or className == "ColorCorrectionEffect"
        or className == "DepthOfFieldEffect"
        or className == "SunRaysEffect"
        or className == "Clouds"
        or className == "Atmosphere"
        or className == "Sky"
        or className == "Shirt"
        or className == "Pants"
        or className == "ShirtGraphic"
        or className == "Animator"
end

local function antiLagSkip(instance)
    if not instance then return true end
    -- Anti Lag no debe apagar ni neutralizar los efectos que controla Vivid Graphics.
    if instance.Name and instance.Name:match("^FreshVivid") then return true end
    local char = LP.Character
    if char and (instance == char or instance:IsDescendantOf(char)) then return true end
    local current = instance
    while current and current ~= workspace do
        local name = current.Name or ""
        if current:IsA("LayerCollector") or current:IsA("GuiObject") or current:IsA("GuiBase2d") then
            return true
        end
        if name:match("^Bubble") or name:match("^__Bubble")
            or name:match("^ESP_") or name:match("^SkinChanger_")
            or name:match("^Korblox_") or name == "Headless_Headless"
            or name == "GreenDuelsBB" or name == "PredictionSphere" then
            return true
        end
        current = current.Parent
    end
    return false
end

local function antiLagStopAnimator(animator)
    if not animator or antiLagSkip(animator) then return end
    local tracks = {}
    local ok = pcall(function()
        for _, track in ipairs(animator:GetPlayingAnimationTracks()) do
            if track.IsPlaying then
                tracks[track] = {
                    animator = animator,
                    time = track.TimePosition,
                    speed = track.Speed,
                }
                track:Stop(0)
            end
        end
    end)
    if ok and next(tracks) then
        for track, data in pairs(tracks) do antiLagAnimationSaved[track] = data end
    end
end

function applyAntiLagDerender(obj)
    if not obj then return end
    -- Anti-Lag must not strip the selected Fresh sky preset after its deferred Lighting scan.
    if obj.Name == "FreshSky" or obj.Name == "FreshSkyAtmosphere" or obj.Name == "FreshSkyClouds" then return end
    if not antiLagIsRelevant(obj) or antiLagSkip(obj) or antiLagProcessed[obj] then return end
    antiLagProcessed[obj] = true
    pcall(function()
        if obj:IsA("Terrain") then
            antiLagSet(obj, "Decoration", false)
            antiLagSet(obj, "WaterWaveSize", 0)
            antiLagSet(obj, "WaterWaveSpeed", 0)
            antiLagSet(obj, "WaterReflectance", 0)
            antiLagSet(obj, "WaterTransparency", 1)
        elseif obj:IsA("BasePart") then
            antiLagSet(obj, "Material", Enum.Material.Plastic)
            antiLagSet(obj, "MaterialVariant", "")
            antiLagSet(obj, "Reflectance", 0)
            antiLagSet(obj, "CastShadow", false)
            if obj:IsA("MeshPart") then
                antiLagSet(obj, "TextureID", "")
                antiLagSet(obj, "RenderFidelity", Enum.RenderFidelity.Performance)
                antiLagSet(obj, "DoubleSided", false)
            elseif obj:IsA("PartOperation") then
                antiLagSet(obj, "RenderFidelity", Enum.RenderFidelity.Performance)
            end
        elseif obj:IsA("SpecialMesh") then
            antiLagSet(obj, "TextureId", "")
        elseif obj:IsA("SurfaceAppearance") then
            if antiLagSaved[obj] == nil then table.insert(antiLagDetached, obj) end
            antiLagSet(obj, "Parent", nil)
        elseif obj:IsA("Decal") or obj:IsA("Texture") then
            antiLagSet(obj, "Transparency", 1)
            antiLagSet(obj, "Texture", "")
        elseif obj:IsA("ParticleEmitter") then
            antiLagSet(obj, "Enabled", false)
            antiLagSet(obj, "Rate", 0)
            pcall(function() obj:Clear() end)
        elseif obj:IsA("Trail") then
            antiLagSet(obj, "Enabled", false)
            pcall(function() obj:Clear() end)
        elseif obj:IsA("Beam") or obj:IsA("Fire") or obj:IsA("Smoke")
            or obj:IsA("Sparkles") or obj:IsA("Light")
            or obj:IsA("PostEffect") or obj:IsA("Clouds") then
            antiLagSet(obj, "Enabled", false)
        elseif obj:IsA("Atmosphere") then
            antiLagSet(obj, "Density", 0)
            antiLagSet(obj, "Haze", 0)
            antiLagSet(obj, "Glare", 0)
        elseif obj:IsA("Sky") then
            for _, property in ipairs({"SkyboxBk", "SkyboxDn", "SkyboxFt", "SkyboxLf", "SkyboxRt", "SkyboxUp", "SunTextureId", "MoonTextureId"}) do
                antiLagSet(obj, property, "")
            end
            antiLagSet(obj, "StarCount", 0)
            antiLagSet(obj, "CelestialBodiesShown", false)
        elseif obj:IsA("Shirt") then
            antiLagSet(obj, "ShirtTemplate", "")
        elseif obj:IsA("Pants") then
            antiLagSet(obj, "PantsTemplate", "")
        elseif obj:IsA("ShirtGraphic") then
            antiLagSet(obj, "Graphic", "")
        elseif obj:IsA("Animator") then
            antiLagStopAnimator(obj)
        end
    end)
end

local function applyAntiLagLighting()
    antiLagSet(Lighting, "GlobalShadows", false)
    antiLagSet(Lighting, "EnvironmentDiffuseScale", 0)
    antiLagSet(Lighting, "EnvironmentSpecularScale", 0)
    antiLagSet(Lighting, "FogStart", 0)
    antiLagSet(Lighting, "FogEnd", 10000000000)
    pcall(function() antiLagSet(settings().Rendering, "QualityLevel", Enum.QualityLevel.Level01) end)
    pcall(function()
        antiLagSet(UserSettings():GetService("UserGameSettings"), "SavedQualityLevel", Enum.SavedQualitySetting.QualityLevel1)
    end)
end

local function antiLagWalkBatch(root, callback, generation)
    if not root then return end
    local queue, head, tail = {}, 1, 0
    local okChildren, initialChildren = pcall(function() return root:GetChildren() end)
    if okChildren then
        for _, child in ipairs(initialChildren) do
            tail = tail + 1
            queue[tail] = child
        end
    end
    while head <= tail and antiLagEnabled and antiLagGeneration == generation do
        local processedThisBatch = 0
        local batchStartedAt = os.clock()
        -- Límite de ~3 ms por frame: se adapta al rendimiento disponible.
        while head <= tail and processedThisBatch < 256
            and (processedThisBatch == 0 or os.clock() - batchStartedAt < 0.003)
            and antiLagEnabled and antiLagGeneration == generation do
            local object = queue[head]
            queue[head] = nil
            head = head + 1
            processedThisBatch = processedThisBatch + 1
            if object then
                callback(object)
                local ok, children = pcall(function() return object:GetChildren() end)
                if ok then
                    for _, child in ipairs(children) do
                        tail = tail + 1
                        queue[tail] = child
                    end
                end
            end
        end
        if head <= tail then RunService.Heartbeat:Wait() end
    end
end

local function antiLagQueueAdded(object, generation)
    if not object or not antiLagEnabled or generation ~= antiLagGeneration or antiLagPendingSet[object] or not antiLagIsRelevant(object) then return end
    antiLagPendingSet[object] = true
    antiLagPendingTail = antiLagPendingTail + 1
    antiLagPendingQueue[antiLagPendingTail] = object
    if antiLagPendingWorker then return end
    antiLagPendingWorker = task.spawn(function()
        task.wait() -- Asegura que la referencia del worker ya quedó asignada antes de poder terminar.
        while antiLagEnabled and generation == antiLagGeneration and antiLagPendingHead <= antiLagPendingTail do
            local count = 0
            local batchStartedAt = os.clock()
            while antiLagPendingHead <= antiLagPendingTail and count < 64
                and (count == 0 or os.clock() - batchStartedAt < 0.0015)
                and antiLagEnabled and generation == antiLagGeneration do
                local item = antiLagPendingQueue[antiLagPendingHead]
                antiLagPendingQueue[antiLagPendingHead] = nil
                antiLagPendingHead = antiLagPendingHead + 1
                count = count + 1
                if item and item.Parent then applyAntiLagDerender(item) end
            end
            if antiLagPendingHead <= antiLagPendingTail then RunService.Heartbeat:Wait() end
        end
        if generation == antiLagGeneration then
            antiLagPendingWorker = nil
            antiLagPendingQueue = {}
            antiLagPendingSet = setmetatable({}, {__mode = "k"})
            antiLagPendingHead, antiLagPendingTail = 1, 0
        end
    end)
end

function enableAntiLag()
    -- Si una restauración está en curso, esperar a que termine antes de reaplicar.
    if antiLagRestoreWorker then
        antiLagEnabled = true
        return
    end
    -- Mantiene el ajuste global inmediato y procesa el mapa por lotes pequeños;
    -- la generación permite cancelar el trabajo y la restauración sigue siendo reversible.
    if antiLagApplied then
        antiLagEnabled = true
        return
    end
    antiLagEnabled = true
    antiLagApplied = true
    antiLagGeneration = antiLagGeneration + 1
    local generation = antiLagGeneration
    applyAntiLagLighting()
    antiLagWorker = task.spawn(function()
        task.wait()
        antiLagWalkBatch(workspace, applyAntiLagDerender, generation)
        antiLagWalkBatch(Lighting, applyAntiLagDerender, generation)
        if generation == antiLagGeneration then antiLagWorker = nil end
    end)
    antiLagDescConn = workspace.DescendantAdded:Connect(function(object)
        antiLagQueueAdded(object, generation)
    end)
    table.insert(antiLagConnections, Lighting.DescendantAdded:Connect(function(object)
        antiLagQueueAdded(object, generation)
    end))
end

function disableAntiLag()
    antiLagEnabled = false
    antiLagApplied = false
    antiLagGeneration = antiLagGeneration + 1
    if antiLagDescConn then antiLagDescConn:Disconnect(); antiLagDescConn = nil end
    for _, connection in ipairs(antiLagConnections) do
        pcall(function() connection:Disconnect() end)
    end
    antiLagConnections = {}
    if antiLagWorker then
        pcall(task.cancel, antiLagWorker)
        antiLagWorker = nil
    end
    if antiLagPendingWorker then
        pcall(task.cancel, antiLagPendingWorker)
        antiLagPendingWorker = nil
    end
    antiLagPendingQueue = {}
    antiLagPendingSet = setmetatable({}, {__mode = "k"})
    antiLagPendingHead, antiLagPendingTail = 1, 0
    antiLagProcessed = setmetatable({}, {__mode = "k"})
    if antiLagRestoreWorker then return end

    -- Restaurar en tandas evita congelar un frame al revertir miles de instancias.
    antiLagRestoreWorker = task.spawn(function()
        task.wait() -- Permite guardar la referencia del worker antes de que termine.
        local restoredProperties = 0
        for instance, properties in pairs(antiLagSaved) do
            for property, value in pairs(properties) do
                pcall(function() instance[property] = value end)
                restoredProperties = restoredProperties + 1
                if restoredProperties >= 64 then
                    restoredProperties = 0
                    RunService.Heartbeat:Wait()
                end
            end
            antiLagSaved[instance] = nil
        end
        table.clear(antiLagDetached)
        local restoredTracks = 0
        for track, data in pairs(antiLagAnimationSaved) do
            pcall(function()
                if data.animator and data.animator.Parent and not track.IsPlaying then
                    track:Play(0, 1, data.speed)
                    track.TimePosition = data.time
                end
            end)
            antiLagAnimationSaved[track] = nil
            restoredTracks = restoredTracks + 1
            if restoredTracks >= 8 then
                restoredTracks = 0
                RunService.Heartbeat:Wait()
            end
        end
        antiLagRestoreWorker = nil
        if antiLagEnabled then task.defer(enableAntiLag) end
    end)
end

function enableAntiLagVx7()
    -- Mantener todas las modificaciones dentro del sistema reversible.
    enableAntiLag()
end

function disableAntiLagVx7()
    disableAntiLag()
end

-- ============================================================
-- 17. CAMARA: FOV Y STRETCH
-- ============================================================
stretchEnabled = false
stretchFOV = 120
origFOV = nil
fovEnabled = false
fovValue = 70
customFovConn = nil
setFovVisual = nil
fovSliderSet = nil
stretchConn = nil
stretchFovConn = nil
CUSTOM_FOV_BIND = "OceanCustomFOV"

function enableCustomFov()
    local cam = workspace.CurrentCamera
    if cam and origFOV == nil then origFOV = cam.FieldOfView end
    fovEnabled = true
    if cam then
        pcall(function() cam.FieldOfViewMode = Enum.FieldOfViewMode.Diagonal end)
        pcall(function() cam.FieldOfView = fovValue end)
    end
    if customFovConn then customFovConn:Disconnect(); customFovConn = nil end
    pcall(function() RunService:UnbindFromRenderStep(CUSTOM_FOV_BIND) end)
    local prio = 200
    pcall(function() prio = Enum.RenderPriority.Camera.Value + 10 end)
    local ok = pcall(function()
        RunService:BindToRenderStep(CUSTOM_FOV_BIND, prio, function()
            if not fovEnabled then return end
            local c = workspace.CurrentCamera
            if c and c.FieldOfView ~= fovValue then
                c.FieldOfView = fovValue
            end
        end)
    end)
    if not ok then
        customFovConn = RunService.RenderStepped:Connect(function()
            if not fovEnabled then
                if customFovConn then customFovConn:Disconnect(); customFovConn = nil end
                return
            end
            local c = workspace.CurrentCamera
            if c then c.FieldOfView = fovValue end
        end)
    end
end

function disableCustomFov()
    fovEnabled = false
    pcall(function() RunService:UnbindFromRenderStep(CUSTOM_FOV_BIND) end)
    if customFovConn then customFovConn:Disconnect(); customFovConn = nil end
    local cam = workspace.CurrentCamera
    if cam then
        pcall(function() cam.FieldOfViewMode = Enum.FieldOfViewMode.Vertical end)
        pcall(function() cam.FieldOfView = origFOV or 70 end)
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

-- ============================================================
-- 18. GRAFICOS: CLIMA NEON, VIVID Y CIELO
-- ============================================================
neonWeatherEnabled = false
_originalLighting = nil
setNeonWeatherVisual = nil
vividGraphicsEnabled = false
_vividEffects = {}
_vividGeneration = 0
skyEnabled = false
skyMode = "Night"
skySetVisual = nil
skyModeBtnRef = nil
_skyOriginalLighting = nil
SKY_OPTIONS = {"Off", "Night", "Aurora", "Sunset", "Galaxy", "Cyber", "Sakura", "Pink Night", "Blood Moon", "Emerald Dawn", "Volcanic", "Arctic", "Midnight Ocean", "Vaporwave", "Toxic", "Solar Eclipse", "Hellscape", "Heaven", "Storm", "Sunrise", "Deep Space", "Lavender Dream", "Inferno", "Mint Sky"}

SKY_PRESETS = {
    ["Off"]={kind="off"},
    ["Night"]={clock=22,brightness=2,ambient={110,100,130},outAmb={120,110,140},sky={stars=4000,moon=18,sun=0,moonTex=true},atm={dens=0.45,color={120,60,180},decay={60,20,100},glare=0.5,haze=1.2}},
    ["Aurora"]={clock=14,brightness=3,ambient={150,120,150},outAmb={160,130,150},atm={dens=0.55,color={255,80,200},decay={255,20,150},glare=2.5,haze=3},clouds={cover=0.7,dens=0.7,color={255,240,250}}},
    ["Sunset"]={clock=17.2,brightness=2.5,ambient={170,120,100},outAmb={180,130,110},sky={stars=0,sun=25,moon=0},atm={dens=0.5,color={255,130,60},decay={255,80,30},glare=2,haze=2.5},clouds={cover=0.55,dens=0.55,color={255,200,140}}},
    ["Galaxy"]={clock=0,brightness=1.5,ambient={70,60,100},outAmb={80,70,110},sky={stars=10000,moon=30,sun=0},atm={dens=0.15,color={40,20,80},decay={20,10,50},glare=0.3,haze=0.5}},
    ["Cyber"]={clock=21,brightness=2.2,ambient={90,130,170},outAmb={100,140,180},sky={stars=2000,moon=12},atm={dens=0.4,color={0,200,255},decay={150,0,255},glare=2,haze=2},clouds={cover=0.4,dens=0.6,color={100,200,255}}},
    ["Sakura"]={clock=11,brightness=3.5,ambient={170,150,160},outAmb={180,160,170},sky={sun=8},atm={dens=0.3,color={255,200,220},decay={255,170,200},glare=1,haze=1.5},clouds={cover=0.6,dens=0.4,color={255,250,252}}},
    ["Pink Night"]={clock=23,brightness=2.2,ambient={120,60,110},outAmb={140,70,120},sky={stars=5000,moon=22,sun=0,moonTex=true},atm={dens=0.5,color={255,80,180},decay={140,30,100},glare=0.7,haze=1.4},clouds={cover=0.3,dens=0.5,color={180,90,150}}},
    ["Blood Moon"]={clock=22.5,brightness=1.8,ambient={130,70,70},outAmb={150,80,80},sky={stars=1500,moon=28,sun=0,moonTex=true},atm={dens=0.45,color={220,80,80},decay={120,40,40},glare=1.0,haze=1.5},clouds={cover=0.45,dens=0.55,color={120,60,60}}},
    ["Emerald Dawn"]={clock=6.5,brightness=2.8,ambient={130,170,140},outAmb={140,180,150},sky={sun=18,moon=0,stars=0},atm={dens=0.4,color={80,200,140},decay={40,150,90},glare=1.8,haze=2.2},clouds={cover=0.5,dens=0.5,color={200,255,220}}},
    ["Volcanic"]={clock=19,brightness=2.2,ambient={180,110,80},outAmb={200,120,90},sky={stars=200,sun=12,moon=0},atm={dens=0.55,color={255,110,60},decay={180,70,40},glare=2.0,haze=2.2},clouds={cover=0.65,dens=0.7,color={120,70,50}}},
    ["Arctic"]={clock=9,brightness=3.2,ambient={200,220,235},outAmb={210,230,245},sky={sun=10,stars=0,moon=0},atm={dens=0.3,color={180,220,255},decay={140,200,240},glare=1.5,haze=1.8},clouds={cover=0.7,dens=0.6,color={250,253,255}}},
    ["Midnight Ocean"]={clock=1.5,brightness=1.7,ambient={60,90,130},outAmb={70,100,140},sky={stars=6000,moon=24,sun=0,moonTex=true},atm={dens=0.5,color={20,60,140},decay={10,30,90},glare=0.6,haze=1.5}},
    ["Vaporwave"]={clock=19.5,brightness=2.4,ambient={180,120,200},outAmb={190,130,210},sky={stars=1000,moon=14},atm={dens=0.45,color={255,100,220},decay={120,60,255},glare=2.2,haze=2.4},clouds={cover=0.55,dens=0.55,color={200,150,255}}},
    ["Toxic"]={clock=13,brightness=2.5,ambient={140,180,80},outAmb={150,190,90},atm={dens=0.45,color={100,220,40},decay={60,150,20},glare=1.5,haze=1.8},clouds={cover=0.55,dens=0.55,color={180,255,120}}},
    ["Solar Eclipse"]={clock=12,brightness=1.2,ambient={70,60,80},outAmb={80,70,90},sky={stars=3500,sun=22,moon=0},atm={dens=0.4,color={255,180,90},decay={50,40,60},glare=2.0,haze=1.5}},
    ["Hellscape"]={clock=18,brightness=2.2,ambient={200,100,80},outAmb={220,110,90},sky={stars=100,sun=30,moon=0},atm={dens=0.6,color={255,90,60},decay={140,50,40},glare=2.2,haze=2.4},clouds={cover=0.8,dens=0.8,color={90,50,40}}},
    ["Heaven"]={clock=12,brightness=4,ambient={240,235,210},outAmb={250,245,220},sky={sun=16,moon=0,stars=0},atm={dens=0.25,color={255,250,220},decay={255,240,200},glare=3,haze=1.5},clouds={cover=0.85,dens=0.5,color={255,255,255}}},
    ["Storm"]={clock=15,brightness=1.6,ambient={105,105,125},outAmb={115,115,135},sky={stars=0,sun=6,moon=0},atm={dens=0.55,color={90,100,130},decay={55,65,90},glare=0.5,haze=2.2},clouds={cover=0.85,dens=0.75,color={70,75,90}}},
    ["Sunrise"]={clock=6.2,brightness=2.8,ambient={220,180,130},outAmb={230,190,140},sky={sun=22,stars=0,moon=0},atm={dens=0.45,color={255,180,100},decay={255,140,80},glare=2.4,haze=2.2},clouds={cover=0.4,dens=0.4,color={255,220,180}}},
    ["Deep Space"]={clock=0,brightness=1,ambient={30,25,50},outAmb={40,35,60},sky={stars=15000,moon=0,sun=0},atm={dens=0.08,color={15,5,40},decay={5,0,20},glare=0.2,haze=0.3}},
    ["Lavender Dream"]={clock=18.5,brightness=2.6,ambient={180,160,220},outAmb={190,170,230},sky={stars=800,moon=16,sun=0},atm={dens=0.4,color={200,160,255},decay={160,120,220},glare=1.4,haze=1.8},clouds={cover=0.55,dens=0.5,color={220,200,255}}},
    ["Inferno"]={clock=17.5,brightness=2.4,ambient={220,140,90},outAmb={235,150,100},sky={sun=26,moon=0,stars=0},atm={dens=0.5,color={255,130,70},decay={200,80,40},glare=2.2,haze=2.2},clouds={cover=0.6,dens=0.6,color={200,110,80}}},
    ["Mint Sky"]={clock=10,brightness=3.2,ambient={180,230,210},outAmb={190,240,220},sky={sun=10},atm={dens=0.32,color={150,255,210},decay={100,220,180},glare=1.6,haze=1.6},clouds={cover=0.55,dens=0.45,color={240,255,250}}},
}

local function saveLightingState()
    if _originalLighting then return end
    _originalLighting = {
        Brightness = Lighting.Brightness,
        ClockTime = Lighting.ClockTime,
        OutdoorAmbient = Lighting.OutdoorAmbient,
        GlobalShadows = Lighting.GlobalShadows,
        FogEnd = Lighting.FogEnd,
        FogStart = Lighting.FogStart,
        FogColor = Lighting.FogColor,
        Ambient = Lighting.Ambient,
        ColorShiftTop = Lighting.ColorShift_Top,
        ColorShiftBottom = Lighting.ColorShift_Bottom,
        ColorCorrection = nil,
        Bloom = nil,
    }
    for _, e in ipairs(Lighting:GetChildren()) do
        if e:IsA("ColorCorrectionEffect") then
            _originalLighting.ColorCorrection = {
                Enabled = e.Enabled,
                Brightness = e.Brightness,
                Contrast = e.Contrast,
                Saturation = e.Saturation,
                TintColor = e.TintColor,
            }
        elseif e:IsA("BloomEffect") then
            _originalLighting.Bloom = {
                Enabled = e.Enabled,
                Intensity = e.Intensity,
                Size = e.Size,
                Threshold = e.Threshold,
            }
        end
    end
end

local function restoreLightingState()
    if vividGraphicsEnabled then return end
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
    if old.ColorShiftTop then Lighting.ColorShift_Top = old.ColorShiftTop end
    if old.ColorShiftBottom then Lighting.ColorShift_Bottom = old.ColorShiftBottom end
    if old.ColorCorrection then
        local cc = Lighting:FindFirstChildOfClass("ColorCorrectionEffect")
        if cc then
            cc.Enabled = old.ColorCorrection.Enabled
            cc.Brightness = old.ColorCorrection.Brightness
            cc.Contrast = old.ColorCorrection.Contrast
            cc.Saturation = old.ColorCorrection.Saturation
            cc.TintColor = old.ColorCorrection.TintColor
        end
    end
    if old.Bloom then
        local bloom = Lighting:FindFirstChildOfClass("BloomEffect")
        if bloom then
            bloom.Enabled = old.Bloom.Enabled
            bloom.Intensity = old.Bloom.Intensity
            bloom.Size = old.Bloom.Size
            bloom.Threshold = old.Bloom.Threshold
        end
    end
end

local function applyNeonWeather()
    if not neonWeatherEnabled then
        restoreLightingState()
        return
    end
    if not _originalLighting then saveLightingState() end
    Lighting.Brightness = 3.5
    Lighting.ClockTime = 20
    Lighting.OutdoorAmbient = STEAL_BAR_COLORS.LIGHT_YELLOW
    Lighting.GlobalShadows = false
    Lighting.FogEnd = 300
    Lighting.FogStart = 0
    Lighting.FogColor = STEAL_BAR_COLORS.DARK_YELLOW
    Lighting.Ambient = STEAL_BAR_COLORS.BLACK
    local cc = Lighting:FindFirstChildOfClass("ColorCorrectionEffect")
    if not cc then
        cc = Instance.new("ColorCorrectionEffect")
        cc.Parent = Lighting
    end
    cc.Enabled = true
    cc.Brightness = 0.2
    cc.Contrast = 0.15
    cc.Saturation = 0.15
    cc.TintColor = STEAL_BAR_COLORS.LIGHT_YELLOW
    local bloom = Lighting:FindFirstChildOfClass("BloomEffect")
    if not bloom then
        bloom = Instance.new("BloomEffect")
        bloom.Parent = Lighting
    end
    bloom.Enabled = true
    bloom.Intensity = 0.6
    bloom.Size = 25
    bloom.Threshold = 0.8
end

function toggleNeonWeather(state)
    if state == nil then
        neonWeatherEnabled = not neonWeatherEnabled
    else
        neonWeatherEnabled = state
    end
    if neonWeatherEnabled and vividGraphicsEnabled then
        disableVividGraphics()
    end
    applyNeonWeather()
    if setNeonWeatherVisual then setNeonWeatherVisual(neonWeatherEnabled) end
end

function enableVividGraphics()
    if vividGraphicsEnabled and #_vividEffects > 0 then return end
    if neonWeatherEnabled then
        neonWeatherEnabled = false
        restoreLightingState()
        if setNeonWeatherVisual then pcall(setNeonWeatherVisual, false) end
    end
    vividGraphicsEnabled = true
    _vividGeneration = (_vividGeneration or 0) + 1
    for _, effect in ipairs(_vividEffects) do pcall(function() effect:Destroy() end) end
    _vividEffects = {}
    local ownedNames = {"FreshVividColorCorrection", "FreshVividBloom", "FreshVividAtmosphere", "FreshVividSunRays", "FreshVividDepthOfField"}
    for _, name in ipairs(ownedNames) do
        local stale = Lighting:FindFirstChild(name)
        if stale then pcall(function() stale:Destroy() end) end
    end
    local color = Instance.new("ColorCorrectionEffect")
    color.Name = "FreshVividColorCorrection"
    color.Enabled = true
    color.Saturation = 0.22
    color.Contrast = 0.12
    color.Brightness = 0.02
    color.TintColor = Color3.fromRGB(255, 255, 255)
    color.Parent = Lighting
    table.insert(_vividEffects, color)
end

function disableVividGraphics()
    vividGraphicsEnabled = false
    _vividGeneration = (_vividGeneration or 0) + 1
    for _, effect in ipairs(_vividEffects) do pcall(function() effect:Destroy() end) end
    _vividEffects = {}
    for _, name in ipairs({"FreshVividColorCorrection", "FreshVividBloom", "FreshVividAtmosphere", "FreshVividSunRays", "FreshVividDepthOfField"}) do
        local stale = Lighting:FindFirstChild(name)
        if stale then pcall(function() stale:Destroy() end) end
    end
end

function toggleVividGraphics(on)
    if on == true then enableVividGraphics() else disableVividGraphics() end
    if type(saveAllSettings) == "function" then pcall(saveAllSettings) end
end

local function destroyFreshSkyObjects()
    for _, parent in ipairs({Lighting, workspace:FindFirstChildOfClass("Terrain")}) do
        if parent then
            for _, name in ipairs({"FreshSky", "FreshSkyAtmosphere", "FreshSkyBloom", "FreshSkyCC", "FreshSkyClouds"}) do
                local obj = parent:FindFirstChild(name)
                if obj then pcall(function() obj:Destroy() end) end
            end
        end
    end
end

_sharedEnv.__FreshCaptureSkyLighting = function()
    if _skyOriginalLighting then return end
    _skyOriginalLighting = {}
    for _, property in ipairs({"Technology", "Brightness", "ClockTime", "ExposureCompensation", "Ambient", "OutdoorAmbient", "GlobalShadows", "FogStart", "FogEnd", "FogColor", "ColorShift_Top", "ColorShift_Bottom"}) do
        pcall(function() _skyOriginalLighting[property] = Lighting[property] end)
    end
end

_sharedEnv.__FreshRestoreSkyLighting = function()
    destroyFreshSkyObjects()
    if _skyOriginalLighting then
        for property, value in pairs(_skyOriginalLighting) do
            pcall(function() Lighting[property] = value end)
        end
    end
    _skyOriginalLighting = nil
end

function applyFreshSky(name)
    local preset = SKY_PRESETS[name]
    if not preset then return false end
    if preset.kind == "off" then
        if _sharedEnv.__FreshRestoreSkyLighting then _sharedEnv.__FreshRestoreSkyLighting() end
        return true
    end
    if _sharedEnv.__FreshCaptureSkyLighting then _sharedEnv.__FreshCaptureSkyLighting() end
    destroyFreshSkyObjects()
    Lighting.ClockTime = preset.clock or 14
    Lighting.Brightness = preset.brightness or 2
    Lighting.Ambient = Color3.fromRGB(table.unpack(preset.ambient or {128, 128, 128}))
    Lighting.OutdoorAmbient = Color3.fromRGB(table.unpack(preset.outAmb or {128, 128, 128}))
    Lighting.FogStart = 0
    Lighting.FogEnd = 100000
    Lighting.FogColor = Color3.fromRGB(200, 200, 200)
    Lighting.ColorShift_Top = Color3.fromRGB(0, 0, 0)
    Lighting.ColorShift_Bottom = Color3.fromRGB(0, 0, 0)
    Lighting.GlobalShadows = true

    if preset.sky then
        local sky = Instance.new("Sky")
        sky.Name = "FreshSky"
        pcall(function()
            if preset.sky.stars ~= nil then sky.StarCount = math.clamp(math.floor(tonumber(preset.sky.stars) or 0), 0, 5000) end
            if preset.sky.moon ~= nil then sky.MoonAngularSize = math.clamp(tonumber(preset.sky.moon) or 0, 0, 11) end
            if preset.sky.sun ~= nil then sky.SunAngularSize = math.clamp(tonumber(preset.sky.sun) or 0, 0, 21) end
            if preset.sky.moonTex then sky.MoonTextureId = "rbxasset://sky/moon.jpg" end
        end)
        sky.Parent = Lighting
    end
    if preset.atm then
        local atmosphere = Instance.new("Atmosphere")
        atmosphere.Name = "FreshSkyAtmosphere"
        pcall(function()
            atmosphere.Density = math.clamp(tonumber(preset.atm.dens) or 0.3, 0, 1)
            atmosphere.Color = Color3.fromRGB(table.unpack(preset.atm.color or {200, 200, 200}))
            atmosphere.Decay = Color3.fromRGB(table.unpack(preset.atm.decay or {100, 100, 100}))
            atmosphere.Glare = math.clamp(tonumber(preset.atm.glare) or 1, 0, 10)
            atmosphere.Haze = math.clamp(tonumber(preset.atm.haze) or 1, 0, 10)
            atmosphere.Parent = Lighting
        end)
    end
    local terrain = workspace:FindFirstChildOfClass("Terrain")
    if preset.clouds and terrain then
        local clouds = Instance.new("Clouds")
        clouds.Name = "FreshSkyClouds"
        pcall(function()
            clouds.Cover = math.clamp(tonumber(preset.clouds.cover) or 0.5, 0, 1)
            clouds.Density = math.clamp(tonumber(preset.clouds.dens) or 0.5, 0, 1)
            clouds.Color = Color3.fromRGB(table.unpack(preset.clouds.color or {230, 230, 230}))
            clouds.Parent = terrain
        end)
    end
    return true
end

function setFreshSkyEnabled(on)
    skyEnabled = on == true and skyMode ~= "Off"
    if skyEnabled then
        applyFreshSky(skyMode)
    elseif _sharedEnv.__FreshRestoreSkyLighting then
        _sharedEnv.__FreshRestoreSkyLighting()
    end
    if skySetVisual then skySetVisual(skyEnabled) end
    task.defer(function() pcall(saveAllSettings) end)
end

function setFreshSkyMode(name, update)
    for _, option in ipairs(SKY_OPTIONS) do
        if option == name then skyMode = name; break end
    end
    if skyMode == "Off" then
        skyEnabled = false
        if _sharedEnv.__FreshRestoreSkyLighting then _sharedEnv.__FreshRestoreSkyLighting() end
        if skySetVisual then skySetVisual(false) end
    elseif skyEnabled then
        applyFreshSky(skyMode)
    end
    if update then update(skyMode) end
    if skyModeBtnRef then skyModeBtnRef.Text = skyMode end
    task.defer(function() pcall(saveAllSettings) end)
end

-- ============================================================
-- 19. INTERFAZ: PANEL, BOTONES FLOTANTES Y TECLAS
-- ============================================================
_freshPanelBackgroundImage = nil
_freshPanelBackgroundSelectorLabel = nil
local _freshSideButtonBackgrounds = {}

function setPanelBackground(index)
    local count = #_freshBackgroundImages
    if count > 0 then
        backgroundIndex = ((_floor(tonumber(index) or 1) - 1) % count) + 1
    end
    if _freshPanelBackgroundImage and _freshPanelBackgroundImage.Parent then
        _freshPanelBackgroundImage.Image = ""
        _freshPanelBackgroundImage.ImageTransparency = 1
        _freshPanelBackgroundImage.Visible = false
    end
    if pbBackgroundImage and pbBackgroundImage.Parent then
        pbBackgroundImage.Image = ""
        pbBackgroundImage.ImageTransparency = 1
        pbBackgroundImage.Visible = false
    end
    if main and main.Parent then
        main.BackgroundColor3 = themePalette.surface
        main.BackgroundTransparency = 0
        local shade = main:FindFirstChild("FireShade")
        if shade then
            shade.Visible = false
            shade.BackgroundTransparency = 1
        end
    end
    if pbFrame and pbFrame.Parent then
        pbFrame.BackgroundColor3 = FRESH_VX7_BAR_COLORS.FRAME
        pbFrame.BackgroundTransparency = 0
        if pbShade then
            pbShade.Visible = false
            pbShade.BackgroundTransparency = 1
        end
        if type(applyStealBarStyle) == "function" then applyStealBarStyle() end
    end
    if bgFrame and bgFrame.Parent then
        bgFrame.BackgroundColor3 = themePalette.surface
        bgFrame.BackgroundTransparency = 1
    end
    for _, sideButtonBackground in ipairs(_freshSideButtonBackgrounds) do
        if sideButtonBackground and sideButtonBackground.Parent then
            sideButtonBackground.Image = ""
            sideButtonBackground.Visible = false
        end
    end
    if _freshPanelBackgroundSelectorLabel and _freshPanelBackgroundSelectorLabel.Parent then
        _freshPanelBackgroundSelectorLabel.Text = "none"
    end
end

_isDraggingButton = false
backgroundIndex = 1

_freshBackgroundImages = {
    "rbxassetid://114138477258742",
}

_freshBackgroundNames = {
    "HZ Yellow",
}

floatingButtonScale = 1
_floatingUIScales = {}
uiLocked = true
hideButtons = false
uiScaleValue = 65

DEFAULT_KB = {
    DropBrainrot = {kb = Enum.KeyCode.X, gp = nil},
    AutoLeft     = {kb = Enum.KeyCode.Z, gp = nil},
    AutoRight    = {kb = Enum.KeyCode.C, gp = nil},
    AutoBat      = {kb = Enum.KeyCode.E, gp = nil},
    TPFloor      = {kb = Enum.KeyCode.F, gp = nil},
    GuiHide      = {kb = Enum.KeyCode.LeftControl, gp = nil},
    CarryToggle  = {kb = Enum.KeyCode.Q, gp = nil},
    LaggerMode   = {kb = Enum.KeyCode.R, gp = nil},
    InstaReset   = {kb = Enum.KeyCode.T, gp = nil},
    AntiBat      = {kb = Enum.KeyCode.G, gp = nil},
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
    InstaReset   = {kb = DEFAULT_KB.InstaReset.kb, gp = DEFAULT_KB.InstaReset.gp},
    AntiBat      = {kb = DEFAULT_KB.AntiBat.kb, gp = DEFAULT_KB.AntiBat.gp},
}

_anyKeyListening = false
keyButtonRefs = {}
progressFill = nil
progressPct = nil
pbFpsPingLabel = nil
pbFrame = nil
stealBarV2Enabled = false
stealBarVersionSelector = nil
normalBox, carryBox, laggerBox, lagger2Box, radInput, batSpeedBox, uiScaleBox = nil, nil, nil, nil, nil, nil, nil
autoSwingSetVisual = nil
setHideButtonsVisual = nil
miniBtn, main, gui = nil, nil, nil
MobilePanel = nil
showGui = nil
hideGui = nil
panelOpen = true
mainUIScale = nil
pbScale = nil
pbBackgroundImage = nil
tabButtons = nil

function applyHideButtonsVisibility()
    local visible = hideButtons ~= true
    if MobilePanel then MobilePanel.Enabled = visible end
end

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
    if _G.__FreshStealBarStatus then _G.__FreshStealBarStatus.Text = "WAITING" end
end

function paintFloatingBtn(btnFrame, active)
    if not btnFrame then return end
    local bg = btnFrame:FindFirstChild("BtnGrad")
    local image = btnFrame:FindFirstChild("SideButtonBackground")
    local label = btnFrame:FindFirstChild("TextLabel")
    local stroke = btnFrame:FindFirstChildOfClass("UIStroke")
    local rail = btnFrame:FindFirstChild("ActiveRail")
    local blue = Color3.fromRGB(147, 51, 234)
    local brightBlue = Color3.fromRGB(216, 180, 254)
    local navy = Color3.fromRGB(15, 10, 20)
    btnFrame.BackgroundTransparency = active and 0.02 or 0.18
    btnFrame.BackgroundColor3 = active and blue or navy
    if image then image.Image = ""; image.Visible = false end
    if bg then
        bg.Color = active and ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(88, 28, 135)),
            ColorSequenceKeypoint.new(0.52, blue),
            ColorSequenceKeypoint.new(1, brightBlue),
        }) or ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(38, 23, 48)),
            ColorSequenceKeypoint.new(0.55, navy),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(12, 8, 17)),
        })
        bg.Transparency = NumberSequence.new(active and 0.02 or 0.18)
    end
    if label then
        label.TextColor3 = active and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(220, 230, 245)
        label.Font = UI_FONT_BOLD
        label.TextSize = 9
    end
    if stroke then
        stroke.Color = active and brightBlue or Color3.fromRGB(0, 0, 0)
        stroke.Thickness = active and 1.65 or 1
        stroke.Transparency = active and 0.04 or 0.15
    end
    if rail then
        rail.BackgroundTransparency = active and 0 or 1
        rail.BackgroundColor3 = brightBlue
    end
end

function applyFloatingButtonScale()
    for _, uiScale in ipairs(_floatingUIScales) do
        if uiScale and uiScale.Parent then
            uiScale.Scale = floatingButtonScale
        end
    end
end

local function drag(f)
    local dn, ds, sp, di = false, nil, nil, nil
    local endConn = nil
    local function stopDrag()
        local wasDragging = dn
        dn = false
        di = nil
        if endConn then
            endConn:Disconnect()
            endConn = nil
        end
        if wasDragging and f == main and main and main.Parent and not _isLoading then
            savedMainPanelPos = {
                XScale = main.Position.X.Scale,
                XOffset = math.floor(main.Position.X.Offset + 0.5),
                YScale = main.Position.Y.Scale,
                YOffset = math.floor(main.Position.Y.Offset + 0.5),
            }
            task.defer(function() pcall(saveAllSettings) end)
        elseif wasDragging and f == pbFrame and pbFrame and pbFrame.Parent and not _isLoading then
            -- Guardar también la posición personalizada de la barra de robo.
            savedProgressBarPos = {
                XScale = pbFrame.Position.X.Scale,
                XOffset = math.floor(pbFrame.Position.X.Offset + 0.5),
                YScale = pbFrame.Position.Y.Scale,
                YOffset = math.floor(pbFrame.Position.Y.Offset + 0.5),
            }
            task.defer(function() pcall(saveAllSettings) end)
        end
    end
    f.InputBegan:Connect(function(i)
        if uiLocked then return end
        if _isDraggingButton then return end
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
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

lockHeaderButton = nil

function toggleLockUI(state)
    if state == nil then uiLocked = not uiLocked else uiLocked = state end
    if setLockUIVisual then setLockUIVisual(uiLocked) end
    local button = lockHeaderButton
    if button and button.Parent and themePalette then
        button.Text = uiLocked and "UNLOCK" or "LOCK"
        button.BackgroundColor3 = themePalette.buttonBg
        button.BackgroundTransparency = uiLocked and 0.1 or 0.28
        button.TextColor3 = themePalette.buttonText
        local stroke = button:FindFirstChildOfClass("UIStroke")
        if stroke then
            stroke.Color = uiLocked and themePalette.buttonText or themePalette.rowBorder
            stroke.Transparency = uiLocked and 0.08 or 0.35
        end
    end
end

function syncFloatingControlPositions()
    -- Durante loadAllSettings se deben conservar las posiciones del JSON;
    -- de lo contrario los botones recien creados reemplazan el guardado.
    if _isLoading then return end
    if MobilePanel and MobilePanel:FindFirstChild("FloatingPanel") then
        local container = MobilePanel:FindFirstChild("FloatingPanel")
        local buttonsContainer = container and container:FindFirstChild("ButtonsContainer")
        if buttonsContainer then
            savedButtonPositions = savedButtonPositions or {}
            for _, button in ipairs(buttonsContainer:GetChildren()) do
                if button:IsA("TextButton") then
                    savedButtonPositions[button.Name] = {
                        X = button.Position.X.Offset,
                        Y = button.Position.Y.Offset,
                    }
                end
            end
        end
    end
end

-- Guarda posiciones absolutas relativas al contenedor, nunca durante el tween de soltado.
-- Se define sin `local` porque el bloque principal ya alcanzó el límite de
-- registros locales de Luau; la función sigue cerrando sobre las variables
-- del script y conserva el mismo comportamiento.
function saveStableButtonPosition(name, button)
    if not (button and button.Parent and button:IsA("TextButton")) then return end
    savedButtonPositions = savedButtonPositions or {}
    savedButtonPositions[name] = {
        X = math.floor(button.Position.X.Offset + 0.5),
        Y = math.floor(button.Position.Y.Offset + 0.5),
    }
    pcall(saveAllSettings)
    task.delay(0.18, function()
        if button and button.Parent then
            savedButtonPositions[name] = {
                X = math.floor(button.Position.X.Offset + 0.5),
                Y = math.floor(button.Position.Y.Offset + 0.5),
            }
            pcall(saveAllSettings)
        end
    end)
end

function buildGui()
    local BG = themePalette.surface
    local ROW_BG = themePalette.rowFill
    local WHITE = themePalette.textPrimary
    local INP = themePalette.buttonBg
    -- Ventana centrada con sidebar y tarjetas redondeadas estilo Ace.
    local GUI_W, GUI_H = 480, 520

    local coreGui = game:GetService("CoreGui")
    local old = coreGui:FindFirstChild("HZ HUB") or coreGui:FindFirstChild("FRESH") or coreGui:FindFirstChild("BloodHounds")
    if old then pcall(function() old:Destroy() end) end
    local pg = LP:FindFirstChild("PlayerGui")
    if pg then
        local oldPlayerGui = pg:FindFirstChild("HZ HUB") or pg:FindFirstChild("FRESH") or pg:FindFirstChild("BloodHounds")
        if oldPlayerGui then pcall(function() oldPlayerGui:Destroy() end) end
    end

    gui = Instance.new("ScreenGui")
    gui.Name = "FRESH"
    gui.ResetOnSpawn = false
    gui.DisplayOrder = 10
    gui.IgnoreGuiInset = true
    pcall(function() if syn and syn.protect_gui then syn.protect_gui(gui) end end)
    local guiOk = pcall(function() gui.Parent = game:GetService("CoreGui") end)
    if not guiOk then gui.Parent = LP:WaitForChild("PlayerGui") end

    main = Instance.new("Frame", gui)
    main.Size = UDim2.new(0, GUI_W, 0, GUI_H)
    main.AnchorPoint = Vector2.new(0.5, 0.5)
    main.Position = UDim2.new(0.5, 0, 0.5, 0)
    main.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    main.BackgroundTransparency = 0
    main.BorderSizePixel = 0
    main.ClipsDescendants = true
    main.Visible = false
    Instance.new("UICorner", main).CornerRadius = UDim.new(0, 30)
    local mainStroke = Instance.new("UIStroke", main)
    mainStroke.Color = themePalette.accentDark
    mainStroke.Thickness = 1.2
    mainStroke.Transparency = 0.55
    mainStroke:SetAttribute("FreshThemeRole", "secondaryStroke")

    local sidePanel = Instance.new("Frame", main)
    sidePanel.Name = "Sidebar"
    sidePanel.Size = UDim2.new(0, 195, 1, 0)
    sidePanel.BackgroundTransparency = 1
    sidePanel.BorderSizePixel = 0
    sidePanel.ClipsDescendants = true
    sidePanel.ZIndex = 2
    Instance.new("UICorner", sidePanel).CornerRadius = UDim.new(0, 30)
    local sideArt = Instance.new("ImageLabel", sidePanel)
    sideArt.Name = "SidebarArt"
    sideArt.Size = UDim2.new(1, 0, 1, 0)
    sideArt.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    sideArt.BackgroundTransparency = 0
    sideArt.BorderSizePixel = 0
    sideArt.Image = "rbxassetid://89206937009614"
    sideArt.ImageColor3 = Color3.fromRGB(255, 255, 255)
    sideArt.ScaleType = Enum.ScaleType.Crop
    sideArt.ZIndex = 2
    local sideScrim = Instance.new("Frame", sidePanel)
    sideScrim.Name = "SidebarScrim"
    sideScrim.Size = UDim2.new(1, 0, 1, 0)
    sideScrim.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
    sideScrim.BackgroundTransparency = 0.62
    sideScrim.BorderSizePixel = 0
    sideScrim.ZIndex = 3
    local contentSurface = Instance.new("Frame", main)
    contentSurface.Name = "ContentSurface"
    contentSurface.Position = UDim2.new(0, 187, 0, 0)
    contentSurface.Size = UDim2.new(1, -187, 1, 0)
    contentSurface.BackgroundColor3 = themePalette.panel
    contentSurface:SetAttribute("FreshThemeRole", "contentSurface")
    contentSurface.BorderSizePixel = 0
    contentSurface.ClipsDescendants = true
    contentSurface.ZIndex = 2
    Instance.new("UICorner", contentSurface).CornerRadius = UDim.new(0, 26)

    local bgImage = Instance.new("ImageLabel", main)
    bgImage.Name = "BackgroundImage"
    bgImage.Size = UDim2.new(1, 0, 1, 0)
    bgImage.Position = UDim2.new(0, 0, 0, 0)
    bgImage.BackgroundTransparency = 1
    _freshPanelBackgroundImage = bgImage
    bgImage.Image = ""
    bgImage.ImageTransparency = 1
    bgImage.Visible = false
    bgImage.ScaleType = Enum.ScaleType.Crop
    bgImage.ZIndex = 2
    bgImage.ClipsDescendants = true
    Instance.new("UICorner", bgImage).CornerRadius = UDim.new(0, 14)

    local bgShade = Instance.new("Frame", main)
    bgShade.Name = "FireShade"
    bgShade.Size = UDim2.new(1, 0, 1, 0)
    bgShade.Position = UDim2.new(0, 0, 0, 0)
    bgShade.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    bgShade.BackgroundTransparency = 0.28
    bgShade.Visible = false
    bgShade.BorderSizePixel = 0
    bgShade.ZIndex = 3
    Instance.new("UICorner", bgShade).CornerRadius = UDim.new(0, 14)

    mainUIScale = Instance.new("UIScale", main)
    mainUIScale.Scale = uiScaleValue / 100

    local headerFrame = Instance.new("Frame", main)
    headerFrame.Name = "HZHubHeader"
    headerFrame.BackgroundColor3 = themePalette.topBg
    headerFrame.BackgroundTransparency = 0.12
    headerFrame.BorderSizePixel = 0
    headerFrame.Size = UDim2.new(1, 0, 0, 96)
    headerFrame.ZIndex = 4
    Instance.new("UICorner", headerFrame).CornerRadius = UDim.new(0, 14)
    local headerStars = Instance.new("Frame", headerFrame)
    headerStars.Name = "HeaderStars"
    headerStars.Size = UDim2.new(1, 0, 1, 0)
    headerStars.BackgroundTransparency = 1
    headerStars.ZIndex = 5
    for i = 1, 8 do
        local star = Instance.new("Frame", headerStars)
        star.Name = "Star_" .. tostring(i)
        star.Size = UDim2.new(0, 2, 0, 2)
        star.Position = UDim2.new((i * 0.12) % 0.88 + 0.06, 0, 0.15 + (i * 0.1) % 0.65, 0)
        star.BackgroundColor3 = i % 2 == 0 and themePalette.accentMid or themePalette.textPrimary
        star.BackgroundTransparency = 0.58
        star.BorderSizePixel = 0
        star.ZIndex = 5
        Instance.new("UICorner", star).CornerRadius = UDim.new(1, 0)
    end
    local headerAccent = Instance.new("Frame", headerFrame)
    headerAccent.Name = "FreshHeaderAccent"
    headerAccent.Position = UDim2.new(0, 15, 0, 20)
    headerAccent.Size = UDim2.new(0, 3, 0, 38)
    headerAccent.BackgroundColor3 = themePalette.accent
    headerAccent.BorderSizePixel = 0
    headerAccent.ZIndex = 7
    headerAccent.Visible = false
    headerAccent:SetAttribute("FreshThemeRole", "accentFill")
    Instance.new("UICorner", headerAccent).CornerRadius = UDim.new(1, 0)
    local headerFill = Instance.new("Frame", headerFrame)
    headerFill.Name = "HeaderBottomFill"
    headerFill.BackgroundColor3 = themePalette.topBg
    headerFill.BackgroundTransparency = 0.12
    headerFill.BorderSizePixel = 0
    headerFill.Position = UDim2.new(0, 0, 1, -22)
    headerFill.Size = UDim2.new(1, 0, 0, 22)
    headerFill.ZIndex = 4

    local headerTitle = Instance.new("TextLabel", headerFrame)
    headerTitle.Name = "HZTitle"
    headerTitle.BackgroundTransparency = 1
    headerTitle.Position = UDim2.new(0, 16, 0, 18)
    headerTitle.Size = UDim2.new(1, -90, 0, 30)
    headerTitle.ZIndex = 7
    headerTitle.Font = UI_FONT_HEAVY
    headerTitle.Text = "FRESH"
    headerTitle.TextColor3 = themePalette.topTitle
    headerTitle.TextSize = 23
    headerTitle.TextXAlignment = Enum.TextXAlignment.Left
    local titleGradient = Instance.new("UIGradient", headerTitle)
    titleGradient.Color = ColorSequence.new(themePalette.textPrimary, themePalette.accentMid)
    local headerSubtitle = Instance.new("TextLabel", headerFrame)
    headerSubtitle.Name = "HZHubSubtitle"
    headerSubtitle.BackgroundTransparency = 1
    headerSubtitle.Position = UDim2.new(0, 16, 0, 52)
    headerSubtitle.Size = UDim2.new(0, 205, 0, 16)
    headerSubtitle.ZIndex = 7
    headerSubtitle.Font = UI_FONT_BOLD
    headerSubtitle.Text = "FRESH DUELS"
    headerSubtitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    headerSubtitle.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    headerSubtitle.TextStrokeTransparency = 0.25
    headerSubtitle.TextScaled = true
    headerSubtitle:SetAttribute("FreshThemeRole", "primaryText")
    headerSubtitle.TextSize = 11
    headerSubtitle.TextXAlignment = Enum.TextXAlignment.Left
    local subtitleConstraint = Instance.new("UITextSizeConstraint", headerSubtitle)
    subtitleConstraint.MinTextSize = 10
    subtitleConstraint.MaxTextSize = 12

    local headerDivider = Instance.new("Frame", headerFrame)
    headerDivider.Name = "HeaderDivider"
    headerDivider.BackgroundColor3 = themePalette.rowBorder
    headerDivider.BackgroundTransparency = 0.52
    headerDivider.BorderSizePixel = 0
    headerDivider.Position = UDim2.new(0, 0, 1, -1)
    headerDivider.Size = UDim2.new(1, 0, 0, 1)
    headerDivider.ZIndex = 7

    local searchFrame = Instance.new("Frame", main)
    searchFrame.Name = "SearchBar"
    searchFrame.Position = UDim2.new(0, 17, 0, 72)
    searchFrame.Size = UDim2.new(1, -34, 0, 20)
    searchFrame.BackgroundColor3 = themePalette.inputBg
    searchFrame.BackgroundTransparency = 0.18
    searchFrame.BorderSizePixel = 0
    searchFrame.ZIndex = 8
    Instance.new("UICorner", searchFrame).CornerRadius = UDim.new(0, 6)
    local searchStroke = Instance.new("UIStroke", searchFrame)
    searchStroke.Color = themePalette.inputBorder
    searchStroke.Thickness = 1
    searchStroke.Transparency = 0.4
    local searchIcon = Instance.new("TextLabel", searchFrame)
    searchIcon.Name = "SearchIcon"
    searchIcon.Size = UDim2.new(0, 20, 1, 0)
    searchIcon.Position = UDim2.new(0, 4, 0, 0)
    searchIcon.BackgroundTransparency = 1
    searchIcon.Text = ""
    searchIcon.TextColor3 = themePalette.accentMid
    searchIcon.Font = UI_FONT_BOLD
    searchIcon.TextSize = 14
    searchIcon.ZIndex = 9
    local searchLens = Instance.new("Frame", searchIcon)
    searchLens.Position = UDim2.new(0, 4, 0.5, -5)
    searchLens.Size = UDim2.new(0, 8, 0, 8)
    searchLens.BackgroundTransparency = 1
    searchLens.BorderSizePixel = 0
    searchLens.ZIndex = 10
    Instance.new("UICorner", searchLens).CornerRadius = UDim.new(1, 0)
    local searchLensStroke = Instance.new("UIStroke", searchLens)
    searchLensStroke.Color = themePalette.accentMid
    searchLensStroke.Thickness = 1.25
    local searchHandle = Instance.new("Frame", searchIcon)
    searchHandle.Position = UDim2.new(0, 12, 0.5, 3)
    searchHandle.Size = UDim2.new(0, 6, 0, 2)
    searchHandle.Rotation = 45
    searchHandle.BackgroundColor3 = themePalette.accentMid
    searchHandle.BorderSizePixel = 0
    searchHandle.ZIndex = 10
    local searchBox = Instance.new("TextBox", searchFrame)
    searchBox.Name = "Input"
    searchBox.Position = UDim2.new(0, 24, 0, 0)
    searchBox.Size = UDim2.new(1, -30, 1, 0)
    searchBox.BackgroundTransparency = 1
    searchBox.Text = ""
    searchBox.PlaceholderText = "Search features..."
    searchBox.PlaceholderColor3 = themePalette.mutedText
    searchBox.TextColor3 = themePalette.inputText
    searchBox.TextSize = 10
    searchBox.Font = UI_FONT
    searchBox.TextXAlignment = Enum.TextXAlignment.Left
    searchBox.ClearTextOnFocus = false
    searchBox.ZIndex = 9

    lockHeaderButton = Instance.new("TextButton", headerFrame)
    lockHeaderButton.Name = "LockUI"
    lockHeaderButton.Size = UDim2.new(0, 32, 0, 28)
    lockHeaderButton.Position = UDim2.new(1, -80, 0, 14)
    lockHeaderButton.BackgroundColor3 = themePalette.buttonBg
    lockHeaderButton.BackgroundTransparency = uiLocked and 0.08 or 0.28
    lockHeaderButton.BorderSizePixel = 0
    lockHeaderButton.Text = uiLocked and "UNLOCK" or "LOCK"
    lockHeaderButton.TextColor3 = themePalette.buttonText
    lockHeaderButton.Font = UI_FONT_BOLD
    lockHeaderButton.TextSize = 9
    lockHeaderButton.AutoButtonColor = false
    lockHeaderButton.ZIndex = 8
    Instance.new("UICorner", lockHeaderButton).CornerRadius = UDim.new(0, 7)
    local lockStroke = Instance.new("UIStroke", lockHeaderButton)
    lockStroke.Color = uiLocked and themePalette.buttonText or themePalette.rowBorder
    lockStroke.Thickness = 1
    lockStroke.Transparency = uiLocked and 0.08 or 0.35
    lockHeaderButton.MouseButton1Click:Connect(function()
        toggleLockUI()
        saveAllSettings()
    end)

    local closeBtn = Instance.new("TextButton", headerFrame)
    closeBtn.Name = "Close"
    closeBtn.Size = UDim2.new(0, 32, 0, 28)
    closeBtn.Position = UDim2.new(1, -42, 0, 14)
    closeBtn.BackgroundColor3 = themePalette.buttonBg
    closeBtn:SetAttribute("FreshThemeRole", "actionButton")
    closeBtn:SetAttribute("FreshActionHover", false)
    closeBtn:SetAttribute("FreshActionActive", false)
    closeBtn.BackgroundTransparency = 0.1
    closeBtn.BorderSizePixel = 0
    closeBtn.Text = "−"
    closeBtn.TextColor3 = themePalette.buttonText
    closeBtn.Font = UI_FONT_BOLD
    closeBtn.TextSize = 15
    closeBtn.AutoButtonColor = false
    closeBtn.ZIndex = 8
    Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 7)
    local closeStroke = Instance.new("UIStroke", closeBtn)
    closeStroke.Color = themePalette.rowBorder
    closeStroke.Thickness = 1
    closeStroke.Transparency = 0.25
    closeStroke:SetAttribute("FreshThemeRole", "secondaryStroke")
    closeBtn.MouseEnter:Connect(function()
        TS:Create(closeBtn, TweenInfo.new(0.12), {TextColor3 = themePalette.buttonActiveText, BackgroundColor3 = themePalette.buttonHoverBg}):Play()
    end)
    closeBtn.MouseLeave:Connect(function()
        TS:Create(closeBtn, TweenInfo.new(0.12), {TextColor3 = themePalette.buttonText, BackgroundColor3 = themePalette.buttonBg}):Play()
    end)

    miniBtn = Instance.new("TextButton", gui)
    miniBtn.Name = "HZHubCornerLauncher"
    miniBtn.Size = UDim2.new(0, 56, 0, 56)
    -- Launcher minimizado en la esquina superior izquierda.
    miniBtn.Position = UDim2.new(0, 18, 0, 20)
    miniBtn.BackgroundColor3 = themePalette.buttonBg
    miniBtn:SetAttribute("FreshThemeRole", "miniButton")
    miniBtn.BackgroundTransparency = 0
    miniBtn.BorderSizePixel = 0
    miniBtn.Text = ""
    miniBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    miniBtn.TextSize = 17
    miniBtn.TextScaled = false
    miniBtn.Font = UI_FONT_HEAVY
    miniBtn.AutoButtonColor = false
    miniBtn.Active = true
miniBtn.ZIndex = 20
miniBtn.Visible = false
Instance.new("UICorner", miniBtn).CornerRadius = UDim.new(0, 8)
local miniStroke = Instance.new("UIStroke", miniBtn)
    miniStroke.Color = themePalette.rowBorder
    miniStroke:SetAttribute("FreshThemeRole", "secondaryStroke")
    miniStroke.Thickness = 1
    miniStroke.Transparency = 0.22
    local miniLogo = Instance.new("ImageLabel", miniBtn)
    miniLogo.Name = "MiniLogo"
    miniLogo.AnchorPoint = Vector2.new(0.5, 0.5)
    miniLogo.Position = UDim2.new(0.5, 0, 0.5, 0)
    miniLogo.Size = UDim2.new(0, 46, 0, 46)
    miniLogo.BackgroundTransparency = 1
    miniLogo.BorderSizePixel = 0
    miniLogo.Image = "rbxassetid://80933500881945"
    miniLogo.ImageColor3 = Color3.fromRGB(255, 255, 255)
    miniLogo.ScaleType = Enum.ScaleType.Fit
    miniLogo.Active = false
    miniLogo.ZIndex = 22
    -- Launcher minimizado arriba a la izquierda; conserva el arrastre.
    drag(miniBtn)

    local slideTween = nil
    local slideToken = 0
    panelOpen = main.Visible == true
    local isPanelAnimating = false
    local mainOriginalPos = main.Position
    local offscreenPos = UDim2.new(0, -GUI_W - 20, 0.5, 0)
    main:GetPropertyChangedSignal("Position"):Connect(function()
        -- No reemplazar la posición visible guardada cuando se mueve hacia/desde
        -- fuera de pantalla durante las animaciones de ocultar/mostrar.
        if not isPanelAnimating then mainOriginalPos = main.Position end
    end)

    local function cancelPanelTween()
        slideToken = slideToken + 1
        local previous = slideTween
        slideTween = nil
        if previous then pcall(function() previous:Cancel() end) end
    end

    local function playPanelTween(targetPos, onCompleted)
        slideToken = slideToken + 1
        local myToken = slideToken
        local tween = TS:Create(main, TweenInfo.new(0.32, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Position = targetPos})
        slideTween = tween
        isPanelAnimating = true
        tween.Completed:Connect(function(playbackState)
            -- Cancelled tweens still fire Completed. Ignore stale callbacks so an
            -- old hide cannot close the panel after a newer show was requested.
            if myToken ~= slideToken or slideTween ~= tween then return end
            slideTween = nil
            isPanelAnimating = false
            if playbackState ~= Enum.PlaybackState.Completed then return end
            if onCompleted then onCompleted() end
        end)
        tween:Play()
    end

    showGui = function()
        if not main or not main.Parent then return end
        panelOpen = true
        cancelPanelTween()
        main.Visible = true
        if miniBtn then miniBtn.Visible = false end
        -- Keep the remembered on-screen location while moving from the edge.
        isPanelAnimating = true
        main.Position = offscreenPos
        playPanelTween(mainOriginalPos)
    end

    hideGui = function()
        if not main or not main.Parent then return end
        panelOpen = false
        if not main.Visible then
            if miniBtn then miniBtn.Visible = true end
            return
        end
        cancelPanelTween()
        playPanelTween(offscreenPos, function()
            if not main or not main.Parent then return end
            main.Visible = false
            if miniBtn then miniBtn.Visible = true end
        end)
    end

    closeBtn.Parent = main
    closeBtn.Position = UDim2.new(1, -34, 0, 16)
    closeBtn.Size = UDim2.new(0, 24, 0, 24)
    closeBtn.Text = "-"
    closeBtn.TextSize = 18
    closeBtn.BackgroundColor3 = Color3.fromRGB(14, 14, 14)
    closeBtn.BackgroundTransparency = 0.15
    closeBtn.ZIndex = 12
    headerFrame.Visible = false
    searchFrame.Visible = false
    lockHeaderButton.Visible = false
    closeBtn.MouseButton1Click:Connect(hideGui)
    miniBtn.MouseButton1Click:Connect(showGui)

    local contentPages = {}
    local pageCounters = {}
    tabButtons = {}
    local setActiveTabForSearch = nil
    local pageToTab = {}
    do
        -- Navegación lateral compacta, igualando la composición de la referencia.
        local tabsDivider = Instance.new("Frame", main)
        tabsDivider.Name = "TabsDivider"
        tabsDivider.Visible = false
        tabsDivider.Size = UDim2.new(0, 1, 1, -118)
        tabsDivider.Position = UDim2.new(0, 186, 0, 106)
        tabsDivider.BackgroundColor3 = themePalette.rowBorder
        tabsDivider.BackgroundTransparency = 0.45
        tabsDivider.BorderSizePixel = 0
        tabsDivider.ZIndex = 11
        tabsDivider:SetAttribute("FreshThemeRole", "neutralDivider")

        local tabBar = Instance.new("Frame", main)
        tabBar.Name = "TabBar"
        tabBar.Visible = true
        tabBar.Size = UDim2.new(0, 122, 0, 226)
        tabBar.Position = UDim2.new(0, 36, 0.54, -113)
        tabBar.BackgroundTransparency = 1
        tabBar.ZIndex = 10
        local tabLogo = Instance.new("ImageLabel", main)
        tabLogo.Name = "TabsHeaderImage"
        tabLogo.AnchorPoint = Vector2.new(0.5, 0)
        tabLogo.Position = UDim2.new(0, 97, 0, 14)
        tabLogo.Size = UDim2.new(0, 110, 0, 110)
        tabLogo.BackgroundTransparency = 1
        tabLogo.BorderSizePixel = 0
        tabLogo.Image = "rbxassetid://80933500881945"
        tabLogo.ImageColor3 = Color3.fromRGB(255, 255, 255)
        tabLogo.ScaleType = Enum.ScaleType.Fit
        tabLogo.ZIndex = 10
        local tabLayout = Instance.new("UIListLayout", tabBar)
        tabLayout.FillDirection = Enum.FillDirection.Vertical
        tabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        tabLayout.VerticalAlignment = Enum.VerticalAlignment.Center
        tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
        tabLayout.Padding = UDim.new(0, 40)

        local tabContent = Instance.new("ScrollingFrame", main)
        tabContent.Name = "PanelContent"
        tabContent.Size = UDim2.new(1, -197, 1, -24)
        tabContent.Position = UDim2.new(0, 192, 0, 12)
        tabContent.BackgroundTransparency = 1
        tabContent.BorderSizePixel = 0
        tabContent.ClipsDescendants = true
        tabContent.ScrollingDirection = Enum.ScrollingDirection.Y
        tabContent.ScrollingEnabled = true
        tabContent.ScrollBarThickness = 2
        tabContent.ScrollBarImageColor3 = themePalette.accent
        tabContent.ScrollBarImageTransparency = 0.35
       tabContent.AutomaticCanvasSize = Enum.AutomaticSize.Y
       tabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
       tabContent.ZIndex = 5
        -- Las pestañas comparten este espacio; no apilar páginas inactivas.
        local masterPadding = Instance.new("UIPadding", tabContent)
        masterPadding.PaddingBottom = UDim.new(0, 18)

        local pageDescriptors = {
            Speed = {"MOVEMENT", "Velocidad, desplazamiento y reinicio"},
            Combat = {"COMBAT", "Defensa, objetivos y herramientas de combate"},
            Steal = {"AUTO STEAL", "Control de alcance y estado de agarre"},
            Tools = {"TOOLS", "Visuals and appearance"},
            Settings = {"PREFERENCES", "Interfaz, controles y configuración"},
        }
        ;(function()
            local pageNames = {"Speed", "Combat", "Steal", "Tools", "Settings"}
            for _, pageName in ipairs(pageNames) do
                local page = Instance.new("Frame", tabContent)
                page.Name = pageName
                page.Size = UDim2.new(1, 0, 0, 0)
                page.AutomaticSize = Enum.AutomaticSize.Y
                page.Position = UDim2.new(0, 0, 0, 0)
                page.BackgroundColor3 = themePalette.panel
                page:SetAttribute("FreshThemeRole", "pageSurface")
                page.BackgroundTransparency = 1
                page.BorderSizePixel = 0
                page.ClipsDescendants = false
                page.ZIndex = 6
                page.Visible = false
                local layout = Instance.new("UIListLayout", page)
                layout.SortOrder = Enum.SortOrder.LayoutOrder
                layout.Padding = UDim.new(0, 7)
                layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

                local padding = Instance.new("UIPadding", page)
                padding.PaddingLeft = UDim.new(0, 0)
                padding.PaddingRight = UDim.new(0, 0)
                padding.PaddingTop = UDim.new(0, 0)
                padding.PaddingBottom = UDim.new(0, 12)
                local descriptor = pageDescriptors[pageName]
                local intro = Instance.new("Frame", page)
                intro.Name = "PageIntro"
                intro.Size = UDim2.new(1, -4, 0, 28)
                intro.BackgroundColor3 = Color3.fromRGB(38, 38, 38)
                intro.BackgroundTransparency = 1
                intro.BorderSizePixel = 0
                intro.LayoutOrder = 0
                intro.ZIndex = 7
                Instance.new("UICorner", intro).CornerRadius = UDim.new(0, 10)
                local introStroke = Instance.new("UIStroke", intro)
                introStroke.Color = themePalette.rowBorder
                introStroke.Thickness = 1
                introStroke.Transparency = 0.55
                introStroke:SetAttribute("FreshThemeRole", "secondaryStroke")
                local introAccent = Instance.new("Frame", intro)
                introAccent.Position = UDim2.new(0, 5, 0, 7)
                introAccent.Size = UDim2.new(0, 3, 1, -14)
                introAccent.BackgroundColor3 = themePalette.accent
                introAccent:SetAttribute("FreshThemeRole", "accentFill")
                introAccent.BorderSizePixel = 0
                introAccent.ZIndex = 8
                Instance.new("UICorner", introAccent).CornerRadius = UDim.new(1, 0)
                local introTitle = Instance.new("TextLabel", intro)
                introTitle.Position = UDim2.new(0, 16, 0, 3)
                introTitle.Size = UDim2.new(1, -22, 0, 21)
                introTitle.BackgroundTransparency = 1
                introTitle.Text = descriptor[1]
                introTitle.TextColor3 = themePalette.accent
                introTitle:SetAttribute("FreshThemeRole", "accentText")
                introTitle.Font = Enum.Font.GothamBold
                introTitle.TextSize = 14
                introTitle.TextXAlignment = Enum.TextXAlignment.Left
                introTitle.ZIndex = 8
                local introSubtitle = Instance.new("TextLabel", intro)
                introSubtitle.Position = UDim2.new(0, 16, 0, 20)
                introSubtitle.Size = UDim2.new(1, -22, 0, 12)
                introSubtitle.BackgroundTransparency = 1
                introSubtitle.Text = descriptor[2]
                introSubtitle.Visible = false
                introSubtitle.TextColor3 = themePalette.mutedText
                introSubtitle:SetAttribute("FreshThemeRole", "mutedText")
                introSubtitle.Font = Enum.Font.Gotham
                introSubtitle.TextSize = 12
                introSubtitle.TextXAlignment = Enum.TextXAlignment.Left
                introSubtitle.TextTruncate = Enum.TextTruncate.AtEnd
                introSubtitle.ZIndex = 8
                contentPages[pageName] = page
            end
        end)()

        local mainPageGroup = Instance.new("Frame", tabContent)
        mainPageGroup.Name = "MainPageGroup"
        mainPageGroup.Size = UDim2.new(1, 0, 0, 0)
        mainPageGroup.AutomaticSize = Enum.AutomaticSize.Y
        mainPageGroup.BackgroundTransparency = 1
        mainPageGroup.BorderSizePixel = 0
        mainPageGroup.Visible = false
        mainPageGroup.ZIndex = 6
        local mainGroupLayout = Instance.new("UIListLayout", mainPageGroup)
        mainGroupLayout.SortOrder = Enum.SortOrder.LayoutOrder
        mainGroupLayout.Padding = UDim.new(0, 8)
        mainGroupLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        for order, pageName in ipairs({"Combat", "Steal", "Tools"}) do
            local page = contentPages[pageName]
            page.Parent = mainPageGroup
            page.LayoutOrder = order
            page.Position = UDim2.new(0, 0, 0, 0)
            page.Size = UDim2.new(1, 0, 0, 0)
            page.Visible = true
        end
        local contentGroups = {
            Movement = contentPages.Speed,
            Main = mainPageGroup,
            Settings = contentPages.Settings,
        }
        pageToTab = {
            Speed = "Movement", Combat = "Main", Steal = "Main",
            Tools = "Main", Settings = "Settings",
        }

        ;(function()
            local tabDefinitions = {
                {page = "Movement", label = "Movement"},
                {page = "Main", label = "Main"},
                {page = "Settings", label = "Settings"},
            }
            local function setActiveTab(pageKey)
                local palette = themePalette
                for _, pageName in ipairs({"Speed", "Combat", "Steal", "Tools", "Settings"}) do
                    local page = contentPages[pageName]
                    if page then page.Visible = false end
                end
                mainPageGroup.Visible = false
                if pageKey == "Main" then
                    mainPageGroup.Visible = true
                    for _, pageName in ipairs({"Combat", "Steal", "Tools"}) do
                        contentPages[pageName].Visible = true
                    end
                elseif contentGroups[pageKey] then
                    contentGroups[pageKey].Visible = true
                end
                for _, button in ipairs(tabButtons) do
                    local active = button:GetAttribute("FreshPage") == pageKey
                    button:SetAttribute("FreshTabActive", active)
                    button.BackgroundColor3 = active and palette.tabActiveBg or palette.tabBarBg
                    button.BackgroundTransparency = active and 0 or 0.18
                    local gradient = button:FindFirstChild("FreshThemeAccentGradient")
                    if gradient then gradient:Destroy() end
                    button.TextColor3 = active and palette.tabActive or palette.tabIdle
                    local stroke = button:FindFirstChildOfClass("UIStroke")
                    if stroke then
                        stroke.Color = active and palette.tabUnderline or palette.tabBarDiv
                        stroke.Transparency = active and 0.05 or 0.52
                    end
                    local underline = button:FindFirstChild("FreshTabIndicator")
                    if underline then
                        underline.BackgroundColor3 = active and palette.tabUnderline or palette.tabBarDiv
                        underline.BackgroundTransparency = active and 0 or 1
                    end
                end
            end
            setActiveTabForSearch = setActiveTab
            for order, definition in ipairs(tabDefinitions) do
                local pageKey = definition.page
                local button = Instance.new("TextButton", tabBar)
                button.Name = "Tab_" .. pageKey
                button.LayoutOrder = order
                button.Size = UDim2.new(1, 0, 0, 43)
                button.BackgroundColor3 = themePalette.tabBarBg
                button.BackgroundTransparency = 0.18
                button.BorderSizePixel = 0
                button.Text = definition.label
                button.TextColor3 = themePalette.tabIdle
                button.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                button.TextStrokeTransparency = 1
                button.Font = Enum.Font.GothamBold
                button.TextSize = 12
                button.TextTruncate = Enum.TextTruncate.AtEnd
                button.AutoButtonColor = false
                button.ZIndex = 11
button:SetAttribute("FreshPage", pageKey)
button:SetAttribute("FreshThemeRole", "tabButton")
button:SetAttribute("FreshTabActive", false)
Instance.new("UICorner", button).CornerRadius = UDim.new(0, 14)
local underline = Instance.new("Frame", button)
underline.Name = "FreshTabIndicator"
underline.AnchorPoint = Vector2.new(0, 0.5)
underline.Position = UDim2.new(0, 0, 0.5, 0)
underline.Size = UDim2.new(0, 3, 0, 20)
underline.BackgroundColor3 = themePalette.tabBarDiv
underline.BackgroundTransparency = 0.18
underline.BorderSizePixel = 0
underline.ZIndex = 12
underline.Visible = false
Instance.new("UICorner", underline).CornerRadius = UDim.new(1, 0)
local stroke = Instance.new("UIStroke", button)
                stroke.Color = themePalette.tabBarDiv
                stroke:SetAttribute("FreshThemeRole", "tabStroke")
                stroke.Thickness = 1
                stroke.Transparency = 0.35
                table.insert(tabButtons, button)
                button.MouseEnter:Connect(function()
                    if button:GetAttribute("FreshTabActive") then return end
                    TS:Create(button, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                        BackgroundTransparency = 0,
                        TextColor3 = themePalette.tabActive,
                    }):Play()
                end)
                button.MouseLeave:Connect(function()
                    if button:GetAttribute("FreshTabActive") then return end
                    TS:Create(button, TweenInfo.new(0.14, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                        BackgroundTransparency = 0.18,
                        TextColor3 = themePalette.tabIdle,
                    }):Play()
                end)
                button.Activated:Connect(function() setActiveTab(pageKey) end)
            end
            setActiveTab("Movement")
        end)()
    end

    local function applyFeatureSearch(rawQuery)
        local query = string.lower(string.gsub(rawQuery or "", "^%s*(.-)%s*$", "%1"))
        local firstMatch = nil
        for pageName, page in pairs(contentPages) do
            local pageHasMatch = false
            for _, child in ipairs(page:GetChildren()) do
                if child:IsA("GuiObject") and child.Name ~= "PageIntro" then
                    local textParts = {child.Name}
                    for _, descendant in ipairs(child:GetDescendants()) do
                        if descendant:IsA("TextLabel") or descendant:IsA("TextButton") or descendant:IsA("TextBox") then
                            table.insert(textParts, descendant.Text)
                        end
                    end
                    local searchableText = string.lower(table.concat(textParts, " "))
                    local matches = query == "" or string.find(searchableText, query, 1, true) ~= nil
                    child.Visible = matches
                    if query ~= "" and matches then pageHasMatch = true end
                end
            end
            if query ~= "" and pageHasMatch and not firstMatch then firstMatch = pageToTab[pageName] or pageName end
        end
        if firstMatch and setActiveTabForSearch then setActiveTabForSearch(firstMatch) end
    end
    searchBox:GetPropertyChangedSignal("Text"):Connect(function()
        applyFeatureSearch(searchBox.Text)
    end)

    local sideIdentity = Instance.new("Frame", main)
    sideIdentity.Name = "SideIdentity"
    sideIdentity.Position = UDim2.new(0, 12, 1, -62)
    sideIdentity.Size = UDim2.new(0, 171, 0, 50)
    sideIdentity.BackgroundTransparency = 1
    sideIdentity.BorderSizePixel = 0
    sideIdentity.ZIndex = 6
    sideIdentity.Visible = false
    local sideAvatar = Instance.new("ImageLabel", sideIdentity)
    sideAvatar.Name = "AvatarImage"
    sideAvatar.AnchorPoint = Vector2.new(0, 0.5)
    sideAvatar.Position = UDim2.new(0, 0, 0.5, 0)
    sideAvatar.Size = UDim2.new(0, 38, 0, 38)
    sideAvatar.Visible = false
    sideAvatar.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
    sideAvatar.BorderSizePixel = 0
    sideAvatar.Image = "rbxthumb://type=AvatarHeadShot&id=" .. tostring(LP.UserId) .. "&w=150&h=150"
    sideAvatar.ScaleType = Enum.ScaleType.Crop
    sideAvatar.ZIndex = 7
    Instance.new("UICorner", sideAvatar).CornerRadius = UDim.new(1, 0)
    local avatarStroke = Instance.new("UIStroke", sideAvatar)
    avatarStroke.Color = themePalette.accent
    avatarStroke.Thickness = 2
    avatarStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    local sideCaption = Instance.new("TextLabel", sideIdentity)
    sideCaption.Name = "IdentityCaption"
    sideCaption.Position = UDim2.new(0, 0, 0, 2)
    sideCaption.Size = UDim2.new(1, 0, 0, 18)
    sideCaption.BackgroundTransparency = 1
    sideCaption.Text = "FRESH DUELS"
    sideCaption.TextColor3 = Color3.fromRGB(255, 255, 255)
    sideCaption.Font = UI_FONT_HEAVY
    sideCaption.TextSize = 13
    sideCaption.TextTruncate = Enum.TextTruncate.AtEnd
    sideCaption.TextXAlignment = Enum.TextXAlignment.Left
    sideCaption.ZIndex = 7
    local brandLine = Instance.new("Frame", sideIdentity)
    brandLine.Name = "BrandAccent"
    brandLine.Position = UDim2.new(0, 0, 0, 21)
    brandLine.Size = UDim2.new(0, 84, 0, 2)
    brandLine.BackgroundColor3 = themePalette.accent
    brandLine.BorderSizePixel = 0
    brandLine.ZIndex = 7
    Instance.new("UICorner", brandLine).CornerRadius = UDim.new(1, 0)
    local sideName = Instance.new("TextLabel", sideIdentity)
    sideName.Name = "DisplayName"
    sideName.Position = UDim2.new(0, 0, 0, 28)
    sideName.Size = UDim2.new(1, 0, 0, 14)
    sideName.BackgroundTransparency = 1
    sideName.Text = ""
    sideName.Visible = false
    sideName.TextColor3 = themePalette.mutedText
    sideName.Font = UI_FONT
    sideName.TextSize = 8
    sideName.TextTruncate = Enum.TextTruncate.AtEnd
    sideName.TextXAlignment = Enum.TextXAlignment.Left
    sideName.ZIndex = 7
    local sideStatus = Instance.new("TextLabel", sideIdentity)
    sideStatus.Name = "StatusLabel"
    sideStatus.Visible = false
    sideStatus.Position = UDim2.new(0, 47, 0, 38)
    sideStatus.Size = UDim2.new(1, -47, 0, 12)
    sideStatus.BackgroundTransparency = 1
    sideStatus.Text = "FRESH DUELS"
    sideStatus.TextColor3 = themePalette.accentMid
    sideStatus.Font = UI_FONT_BOLD
    sideStatus.TextSize = 8
    sideStatus.TextTruncate = Enum.TextTruncate.AtEnd
    sideStatus.TextXAlignment = Enum.TextXAlignment.Center
    sideStatus.ZIndex = 7

    local function getNextOrder(page)
        if not pageCounters[page] then pageCounters[page] = 0 end
        pageCounters[page] = pageCounters[page] + 1
        return pageCounters[page]
    end

    local function mkSect(page, txt)
        local f = Instance.new("Frame", page)
        f.Size = UDim2.new(1, -4, 0, 26)
        f.BackgroundTransparency = 1
        f.BorderSizePixel = 0
        f.LayoutOrder = getNextOrder(page)
        f.ZIndex = 7
        local l = Instance.new("TextLabel", f)
        l.Size = UDim2.new(1, -10, 1, -2)
        l.Position = UDim2.new(0, 14, 0, 0)
        l.Size = UDim2.new(1, -18, 1, -2)
        l.BackgroundTransparency = 1
        l.Text = txt:upper()
        l.TextColor3 = themePalette.accentText
        l:SetAttribute("FreshThemeRole", "accentText")
        l.Font = UI_FONT_HEAVY
        l.TextSize = 13
        l.TextXAlignment = Enum.TextXAlignment.Left
        l.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        l.TextStrokeTransparency = 1
        l.ZIndex = 8
        local sectionAccent = Instance.new("Frame", f)
        sectionAccent.Name = "EnvySectionAccent"
        sectionAccent.AnchorPoint = Vector2.new(0, 0.5)
        sectionAccent.Position = UDim2.new(0, 4, 0.5, 0)
        sectionAccent.Size = UDim2.new(0, 3, 0, 12)
        sectionAccent.BackgroundColor3 = themePalette.accent
        sectionAccent.BorderSizePixel = 0
        sectionAccent.ZIndex = 8
        Instance.new("UICorner", sectionAccent).CornerRadius = UDim.new(1, 0)
        local divider = Instance.new("Frame", f)
        divider.Name = "SectionDivider"
        divider.Size = UDim2.new(1, -14, 0, 1)
        divider.Position = UDim2.new(0, 7, 1, -1)
        divider.BackgroundColor3 = themePalette.rowBorder
        divider.BackgroundTransparency = 0.52
        divider.BorderSizePixel = 0
        divider:SetAttribute("FreshThemeRole", "neutralDivider")
        divider.ZIndex = 7
        return f
    end

    local function mkRow(page, h)
        local rowHeight = (h == nil or h == 38 or h == 36) and 40 or h
        local f = Instance.new("Frame", page)
        f.Size = UDim2.new(1, -4, 0, rowHeight or 40)
        f.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        f:SetAttribute("FreshThemeRole", "rowFill")
        f.BackgroundTransparency = 0
        f.BorderSizePixel = 0
        f.LayoutOrder = getNextOrder(page)
        f.ZIndex = 7
        Instance.new("UICorner", f).CornerRadius = UDim.new(0, 10)
        local rowStroke = Instance.new("UIStroke", f)
        rowStroke.Color = themePalette.rowBorder
        rowStroke:SetAttribute("FreshThemeRole", "rowStroke")
        rowStroke.Thickness = 1
        rowStroke.Transparency = 0.22
        f.MouseEnter:Connect(function()
            TS:Create(f, TweenInfo.new(0.14), {BackgroundColor3 = themePalette.rowHover, BackgroundTransparency = 0}):Play()
        end)
        f.MouseLeave:Connect(function()
            TS:Create(f, TweenInfo.new(0.14), {BackgroundColor3 = Color3.fromRGB(0, 0, 0), BackgroundTransparency = 0}):Play()
        end)
        return f
    end

    local function mkLabel(row, txt)
        local l = Instance.new("TextLabel", row)
        l.Size = UDim2.new(1, -132, 1, 0)
        l.Position = UDim2.new(0, 12, 0, 0)
        l.BackgroundTransparency = 1
        l.Text = txt
        l.TextColor3 = WHITE
        l:SetAttribute("FreshThemeRole", "textPrimary")
        l.Font = Enum.Font.GothamSemibold
        l.TextSize = 16
        l.TextXAlignment = Enum.TextXAlignment.Left
        l.TextTruncate = Enum.TextTruncate.AtEnd
        l.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        l.TextStrokeTransparency = 1
        l.ZIndex = 8
        return l
    end

    local function mkPill(row, offset)
        local pill = Instance.new("Frame", row)
        pill.Name = "Track"
        pill:SetAttribute("FreshThemeRole", "toggleTrack")
        pill:SetAttribute("FreshThemeOn", false)
        pill.Size = UDim2.new(0, 20, 0, 20)
        pill.AnchorPoint = Vector2.new(1, 0.5)
        pill.Position = UDim2.new(1, -18, 0.5, 0)
        pill.BackgroundTransparency = 1
        pill.BorderSizePixel = 0
        pill.ZIndex = 8

        local dot = Instance.new("Frame", pill)
        dot.Name = "Knob"
        dot.Size = UDim2.new(1, 0, 1, 0)
        dot.AnchorPoint = Vector2.new(0.5, 0.5)
        dot.Position = UDim2.new(0.5, 0, 0.5, 0)
        dot.BackgroundColor3 = themePalette.toggleBg
        dot.BackgroundTransparency = 0.1
        dot.BorderSizePixel = 0
        dot.ZIndex = 9
        Instance.new("UICorner", dot).CornerRadius = UDim.new(0, 10)

        local dotStroke = Instance.new("UIStroke", dot)
        dotStroke.Name = "KnobStroke"
        dotStroke.Color = themePalette.rowSoftBorder
        dotStroke.Thickness = 1
        dotStroke.Transparency = 0.5

        local shine = Instance.new("Frame", dot)
        shine.Name = "Shine"
        shine.Size = UDim2.new(1, -6, 0, 6)
        shine.Position = UDim2.new(0, 3, 0, 3)
        shine.BackgroundColor3 = WHITE
        shine.BackgroundTransparency = 0.65
        shine.BorderSizePixel = 0
        shine.ZIndex = 10
        Instance.new("UICorner", shine).CornerRadius = UDim.new(0, 3)

        return pill, dot
    end
    local function animPill(pill, dot, on)
        on = on == true
        pill:SetAttribute("FreshThemeOn", on)
        local dotStroke = dot:FindFirstChild("KnobStroke")
        local fadeInfo = TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        TS:Create(dot, fadeInfo, {
            BackgroundColor3 = on and themePalette.accent or themePalette.toggleBg,
            BackgroundTransparency = on and 0 or 0.1,
        }):Play()
        if dotStroke then
            TS:Create(dotStroke, fadeInfo, {
                Color = on and themePalette.accent or themePalette.rowSoftBorder,
                Transparency = on and 0.2 or 0.5,
            }):Play()
        end
        local rowStroke = pill.Parent and pill.Parent:FindFirstChildOfClass("UIStroke")
        if rowStroke then TS:Create(rowStroke, fadeInfo, {
            Color = on and themePalette.accent or themePalette.rowSoftBorder,
            Transparency = on and 0.08 or 0.38,
            Thickness = on and 1.25 or 1.15,
        }):Play() end
    end
    local function mkSlider(row, minV, maxV, default, cb)
        local W = 118
        local track = Instance.new("Frame", row)
        track.Size = UDim2.new(0, W, 0, 4)
        track.Position = UDim2.new(1, -(W + 44), 0.5, -2)
        track.BackgroundColor3 = themePalette.buttonBg
        track:SetAttribute("FreshThemeRole", "sliderTrack")
        track.BackgroundTransparency = 0.12
        track.BorderSizePixel = 0
        track.ZIndex = 8
        Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)

        local fill = Instance.new("Frame", track)
        fill.Size = UDim2.new(0, 0, 1, 0)
        fill.BackgroundColor3 = themePalette.accent
        fill:SetAttribute("FreshThemeRole", "secondaryFill")
        fill.BorderSizePixel = 0
        fill.ZIndex = 9
        Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)

        local knob = Instance.new("Frame", track)
        knob.Size = UDim2.new(0, 13, 0, 13)
        knob.AnchorPoint = Vector2.new(0.5, 0.5)
        knob.Position = UDim2.new(0, 0, 0.5, 0)
        knob.BackgroundColor3 = WHITE
        knob.BorderSizePixel = 0
        knob.ZIndex = 11
        Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)
        local kStroke = Instance.new("UIStroke", knob)
        kStroke.Color = themePalette.rowBorder
        kStroke:SetAttribute("FreshThemeRole", "accentStroke")
        kStroke.Thickness = 2

        local valLabel = Instance.new("TextLabel", row)
        valLabel.Size = UDim2.new(0, 34, 0, 20)
        valLabel.Position = UDim2.new(1, -38, 0.5, -10)
        valLabel.BackgroundTransparency = 1
        valLabel.Text = tostring(default)
        valLabel.TextColor3 = WHITE
        valLabel:SetAttribute("FreshThemeRole", "textPrimary")
        valLabel.Font = UI_FONT_BOLD
        valLabel.TextSize = 14
        valLabel.TextXAlignment = Enum.TextXAlignment.Right
        valLabel.ZIndex = 9

        local hit = Instance.new("TextButton", row)
        hit.Size = UDim2.new(0, W + 16, 0, 26)
        hit.Position = UDim2.new(1, -(W + 52), 0.5, -13)
        hit.BackgroundTransparency = 1
        hit.Text = ""
        hit.AutoButtonColor = false
        hit.ZIndex = 12

        local current = default

        local function render(a)
            a = _clamp(a, 0, 1)
            fill.Size = UDim2.new(a, 0, 1, 0)
            knob.Position = UDim2.new(a, 0, 0.5, 0)
            fill.BackgroundColor3 = themePalette.accent
            kStroke.Color = themePalette.rowBorder
        end

        local function applyFromX(px)
            local left = track.AbsolutePosition.X
            local width = track.AbsoluteSize.X
            if width <= 0 then width = W end
            if left <= 0 then return end
            local a = (px - left) / width
            a = _clamp(a, 0, 1)
            local v = _floor(minV + (maxV - minV) * a + 0.5)
            current = v
            valLabel.Text = tostring(v)
            render(a)
            if cb then pcall(cb, v) end
        end

        local dragging = false

        hit.InputBegan:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                _isDraggingButton = true
                applyFromX(i.Position.X)
            end
        end)

        hit.InputEnded:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                dragging = false
                _isDraggingButton = false
            end
        end)

        UIS.InputChanged:Connect(function(i)
            if not dragging then return end
            if i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch then
                applyFromX(i.Position.X)
            end
        end)

        UIS.InputEnded:Connect(function(i)
            if not dragging then return end
            if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                dragging = false
                _isDraggingButton = false
            end
        end)

        local function setValue(v)
            v = _clamp(tonumber(v) or minV, minV, maxV)
            current = v
            valLabel.Text = tostring(v)
            render((v - minV) / (maxV - minV))
        end

        setValue(default)
        return setValue
    end

    local mkKeyButton
    local function mkToggle(page, txt, cb, kbEntry)
        local row = mkRow(page, 32)
        local label = mkLabel(row, txt)
        label.Position = UDim2.new(0, 18, 0, 0)
        local marker = Instance.new("Frame", row)
        marker.Name = "ToggleLabelMarker"
        marker.AnchorPoint = Vector2.new(0, 0.5)
        marker.Position = UDim2.new(0, 8, 0.5, 0)
        marker.Size = UDim2.new(0, 2, 0, 12)
        marker.BackgroundColor3 = themePalette.accent
        marker.BackgroundTransparency = 0.1
        marker.BorderSizePixel = 0
        marker.Visible = false
        marker.ZIndex = 9
        Instance.new("UICorner", marker).CornerRadius = UDim.new(1, 0)
        local pill, dot = mkPill(row, 48)
        local on = false
        local function sv(s)
            on = s == true
            marker.Visible = on
            animPill(pill, dot, on)
        end
        local clk = Instance.new("TextButton", row)
        clk.Size = UDim2.new(0, 52, 1, 0)
        clk.AnchorPoint = Vector2.new(1, 0)
        clk.Position = UDim2.new(1, -4, 0, 0)
        clk.BackgroundTransparency = 1
        clk.Text = ""
        clk.AutoButtonColor = false
        clk.ZIndex = 11
        clk.MouseButton1Click:Connect(function()
            local nextState = not on
            sv(nextState)
            pcall(cb, nextState)
            pcall(saveAllSettings)
        end)
        if kbEntry and mkKeyButton then mkKeyButton(row, kbEntry, true) end
        return sv
    end

    local function mkSelector(parent, default, options, cb)
        options = options or {}
        local w, h = 142, 30
        local pill = Instance.new("Frame", parent)
        pill.Name = "FreshSelector"
        pill.Size = UDim2.new(0, w, 0, h)
        pill.Position = UDim2.new(1, -(w + 6), 0.5, -h / 2)
        pill.BackgroundColor3 = themePalette.inputBg
        pill.BackgroundTransparency = 0.04
        pill.BorderSizePixel = 0
        pill:SetAttribute("FreshThemeRole", "selectorSurface")
        pill.ZIndex = 30
        Instance.new("UICorner", pill).CornerRadius = UDim.new(0, 7)
        local pillStroke = Instance.new("UIStroke", pill)
        pillStroke.Color = themePalette.rowBorder
        pillStroke.Thickness = 1
        pillStroke.Transparency = 0.34
        pillStroke:SetAttribute("FreshThemeRole", "secondaryStroke")
        pill.MouseEnter:Connect(function()
            TS:Create(pillStroke, TweenInfo.new(0.12), {
                Color = themePalette.accent,
                Transparency = 0.12,
                Thickness = 1.25,
            }):Play()
        end)
        pill.MouseLeave:Connect(function()
            TS:Create(pillStroke, TweenInfo.new(0.14), {
                Color = themePalette.rowBorder,
                Transparency = 0.34,
                Thickness = 1,
            }):Play()
        end)

        local railTrack = Instance.new("Frame", pill)
        railTrack.Name = "OptionProgressTrack"
        railTrack.Size = UDim2.new(0, 42, 0, 2)
        railTrack.Position = UDim2.new(0.5, -21, 1, -4)
        railTrack.BackgroundColor3 = themePalette.rowBorder
        railTrack.BackgroundTransparency = 0.25
        railTrack.BorderSizePixel = 0
        railTrack:SetAttribute("FreshThemeRole", "neutralDivider")
        railTrack.ZIndex = 30
        Instance.new("UICorner", railTrack).CornerRadius = UDim.new(1, 0)
        local railFill = Instance.new("Frame", railTrack)
        railFill.Name = "OptionProgressValue"
        railFill.Size = UDim2.new(0.25, 0, 1, 0)
        railFill.BackgroundColor3 = themePalette.accent
        railFill.BorderSizePixel = 0
        railFill:SetAttribute("FreshThemeRole", "accentFill")
        railFill.ZIndex = 31
        Instance.new("UICorner", railFill).CornerRadius = UDim.new(1, 0)

        local function makeCycleButton(name, text, position)
            local button = Instance.new("TextButton", pill)
            button.Name = name
            button.Size = UDim2.new(0, 20, 0, 20)
            button.Position = position
            button.BackgroundColor3 = themePalette.inputBg
            button.BackgroundTransparency = 1
            button.BorderSizePixel = 0
            button.Text = text
            button.TextColor3 = themePalette.mutedText
            button.Font = Enum.Font.GothamBold
            button.TextSize = 14
            button.AutoButtonColor = false
            button:SetAttribute("FreshThemeRole", "selectorCycleButton")
            button.ZIndex = 32
            Instance.new("UICorner", button).CornerRadius = UDim.new(0, 5)
            button.MouseEnter:Connect(function()
                TS:Create(button, TweenInfo.new(0.1), {
                    BackgroundColor3 = themePalette.accentDark,
                    BackgroundTransparency = 0.24,
                    TextColor3 = themePalette.accent,
                }):Play()
            end)
            button.MouseLeave:Connect(function()
                TS:Create(button, TweenInfo.new(0.1), {
                    BackgroundColor3 = themePalette.inputBg,
                    BackgroundTransparency = 1,
                    TextColor3 = themePalette.mutedText,
                }):Play()
            end)
            return button
        end

        local leftBtn = makeCycleButton("Prev", "‹", UDim2.new(0, 4, 0.5, -10))
        local label = Instance.new("TextLabel", pill)
        label.Name = "Value"
        label.Size = UDim2.new(1, -54, 1, -3)
        label.Position = UDim2.new(0, 27, 0, 0)
        label.BackgroundTransparency = 1
        label.Text = tostring(default or "")
        label.TextColor3 = themePalette.textPrimary
        label:SetAttribute("FreshThemeRole", "textPrimary")
        label.Font = Enum.Font.GothamBold
        label.TextSize = 11
        label.TextXAlignment = Enum.TextXAlignment.Center
        label.TextYAlignment = Enum.TextYAlignment.Center
        label.TextTruncate = Enum.TextTruncate.AtEnd
        label.ZIndex = 31
        local rightBtn = makeCycleButton("Next", "›", UDim2.new(1, -24, 0.5, -10))

        local idx = 1
        for i, opt in ipairs(options) do
            if tostring(opt) == tostring(default) then idx = i; break end
        end
        local function updateIndicator()
            local count = #options
            local fraction = count > 0 and math.max(0.16, 1 / count) or 1
            local progress = count > 1 and (idx - 1) / (count - 1) or 0
            TS:Create(railFill, TweenInfo.new(0.16, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                Size = UDim2.new(fraction, 0, 1, 0),
                Position = UDim2.new(progress * (1 - fraction), 0, 0, 0),
            }):Play()
        end
        updateIndicator()
        local function cycle(direction)
            if #options <= 1 then return end
            idx = ((idx - 1 + direction) % #options) + 1
            label.Text = tostring(options[idx])
            pcall(cb, direction, function(v) label.Text = tostring(v) end)
            task.defer(function() pcall(saveAllSettings) end)
        end
        label:GetPropertyChangedSignal("Text"):Connect(function()
            for i, opt in ipairs(options) do
                if tostring(opt) == label.Text then idx = i; updateIndicator(); break end
            end
        end)
        leftBtn.Activated:Connect(function() cycle(-1) end)
        rightBtn.Activated:Connect(function() cycle(1) end)
        label.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                cycle(1)
            end
        end)
        return label
    end

    local function mkBox(parent, default, w, xOff, cb)
        local tb = Instance.new("TextBox", parent)
        local bw = w or 50
        local xo = math.max(xOff or 56, bw + 12)
        tb.Size = UDim2.new(0, bw, 0, 24)
        tb.Position = UDim2.new(1, -xo, 0.5, -12)
        tb.BackgroundColor3 = themePalette.inputBg
        tb:SetAttribute("FreshThemeRole", "inputBox")
        tb.BackgroundTransparency = 0
        tb.BorderSizePixel = 0
        tb.Text = tostring(default)
        tb.TextColor3 = themePalette.inputText
        tb.Font = UI_FONT_BOLD
        tb.TextSize = 12
        tb.ClearTextOnFocus = false
        tb.ZIndex = 8
        Instance.new("UICorner", tb).CornerRadius = UDim.new(0, 7)
        local bs = Instance.new("UIStroke", tb)
        bs.Color = themePalette.inputBorder
        bs:SetAttribute("FreshThemeRole", "secondaryStroke")
        bs.Thickness = 1
        bs.Transparency = 0.45
        tb.Focused:Connect(function() TS:Create(bs, TweenInfo.new(0.12), {Color = themePalette.inputFocus, Transparency = 0}):Play() end)
        tb.FocusLost:Connect(function()
            TS:Create(bs, TweenInfo.new(0.12), {Color = themePalette.inputBorder, Transparency = 0.35}):Play()
            if cb then local n = tonumber(tb.Text); if n then cb(n); pcall(saveAllSettings) else tb.Text = tostring(default) end end
        end)
        return tb
    end

    mkKeyButton = function(parent, kbEntry, inline)
        local btn = Instance.new("TextButton", parent)
        btn.Size = inline and UDim2.new(0, 52, 0, 20) or UDim2.new(0, 70, 0, 24)
        btn.Position = inline and UDim2.new(1, -114, 0.5, -10) or UDim2.new(1, -80, 0.5, -12)
        btn.BackgroundColor3 = themePalette.buttonBg
        btn.BackgroundTransparency = 0
        btn.BorderSizePixel = 0
        btn:SetAttribute("FreshThemeRole", "keybindButton")
        btn:SetAttribute("FreshButtonActive", false)
        local function getLabel() return (kbEntry.gp and kbEntry.gp.Name) or (kbEntry.kb and kbEntry.kb.Name) or "None" end
        btn.Text = getLabel()
btn.TextColor3 = themePalette.buttonText
btn.Font = UI_FONT_BOLD
btn.TextSize = 10
btn.ZIndex = 8
btn.AutoButtonColor = false
Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 7)
local bs = Instance.new("UIStroke", btn)
        bs.Color = themePalette.secondary
        bs:SetAttribute("FreshThemeRole", "secondaryStroke")
        bs.Thickness = 1
        local li = false; local lc; local pv = btn.Text; local listenStart = 0
        local function paintKeyButton(active)
            btn:SetAttribute("FreshButtonActive", active == true)
            btn.BackgroundColor3 = active and themePalette.accent or themePalette.buttonBg
            btn.TextColor3 = active and themePalette.buttonActiveText or themePalette.buttonText
            bs.Color = active and themePalette.accentDark or themePalette.rowBorder
        end
        btn.Activated:Connect(function()
            if li then
                li = false; _anyKeyListening = false
                if lc then lc:Disconnect(); lc = nil end
                btn.Text = pv; paintKeyButton(false); return
            end
            pv = btn.Text; li = true; _anyKeyListening = true; listenStart = _tick()
            btn.Text = "..."; paintKeyButton(true)
            lc = UIS.InputBegan:Connect(function(inp)
                if not li then return end
                if inp.KeyCode == Enum.KeyCode.Escape then
                    li = false; _anyKeyListening = false
                    if lc then lc:Disconnect(); lc = nil end
                    btn.Text = pv; paintKeyButton(false); return
                end
                local isGp = isGamepadInput(inp)
                if isGp and _tick()-listenStart < 0.15 then return end
                if not isBindableInput(inp) then return end
                btn.Text = inp.KeyCode.Name; pv = inp.KeyCode.Name
                li = false; _anyKeyListening = false; paintKeyButton(false)
                if lc then lc:Disconnect(); lc = nil end
                if isGp then kbEntry.gp = inp.KeyCode; kbEntry.kb = nil else kbEntry.kb = inp.KeyCode; kbEntry.gp = nil end
                pcall(saveAllSettings)
            end)
        end)
        table.insert(keyButtonRefs, {btn = btn, entry = kbEntry})
        return btn
    end

    local speedPage = contentPages["Speed"]
    mkSect(speedPage, "Speed Settings")
    do local row = mkRow(speedPage, 38); mkLabel(row, "Normal Speed"); normalBox = mkBox(row, NS, 58, 64, function(v) if v > 0 then NS = v; CarrySystem:setNormalSpeed(v) end end) end
    do local row = mkRow(speedPage, 38); mkLabel(row, "Carry Speed"); carryBox = mkBox(row, CS, 58, 64, function(v) if v > 0 then CS = v; CarrySystem:setCarrySpeed(v) end end) end
    autoCarrySetVisual = mkToggle(speedPage, "Auto Carry", function(on)
        setAutoCarryEnabled(on)
    end)
    do local row = mkRow(speedPage, 38); mkLabel(row, "Lagger 1 Speed"); laggerBox = mkBox(row, LAGGER_SPEED, 58, 64, function(v) if v > 0 then LAGGER_SPEED = v; CarrySystem:setLaggerSpeed(v) end end) end
    do local row = mkRow(speedPage, 38); mkLabel(row, "Lagger 2 Speed"); lagger2Box = mkBox(row, LAGGER_CARRY_SPEED, 58, 64, function(v) if v > 0 then LAGGER_CARRY_SPEED = v; CarrySystem:setLaggerCarrySpeed(v) end end) end
    do
        local row = mkRow(speedPage, 38)
        mkLabel(row, "Carry Toggle Key")
        mkKeyButton(row, KB.CarryToggle, false)
    end
    do
        local row = mkRow(speedPage, 38)
        mkLabel(row, "Current Mode")
        modeValLbl = Instance.new("TextLabel", row)
        modeValLbl.Size = UDim2.new(0, 110, 1, 0)
        modeValLbl.Position = UDim2.new(1, -118, 0, 0)
        modeValLbl.BackgroundTransparency = 1
        modeValLbl.Text = "Normal"
        modeValLbl.TextColor3 = WHITE
        modeValLbl:SetAttribute("FreshThemeRole", "textPrimary")
        modeValLbl.Font = UI_FONT_HEAVY
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
    do
        local row = mkRow(speedPage, 34)
        mkLabel(row, "Lagger Mode")
        mkKeyButton(row, KB.LaggerMode, false)
    end

    mkSect(speedPage, "Auto Movement")
    autoLeftSetVisual = mkToggle(speedPage, "Auto Left", function(on)
        autoLeftEnabled = on
        if on then startAutoLeft() else stopAutoLeft() end
        if mobSetAutoLeft then mobSetAutoLeft(on) end
    end, KB.AutoLeft)
    autoRightSetVisual = mkToggle(speedPage, "Auto Right", function(on)
        autoRightEnabled = on
        if on then startAutoRight() else stopAutoRight() end
        if mobSetAutoRight then mobSetAutoRight(on) end
    end, KB.AutoRight)

    mkSect(speedPage, "TP & Reset")
    do
        local row = mkRow(speedPage, 38)
        mkLabel(row, "TP Down")
        local clk = Instance.new("TextButton", row)
        clk.Size = UDim2.new(0.58, 0, 1, 0)
        clk.BackgroundTransparency = 1
        clk.Text = ""
        clk.AutoButtonColor = false
        clk.ZIndex = 8
        clk.MouseButton1Click:Connect(function() doTpDown() end)
        mkKeyButton(row, KB.TPFloor, true)
        local actLbl = Instance.new("TextLabel", row)
        actLbl.Size = UDim2.new(0, 50, 1, 0)
        actLbl.Position = UDim2.new(1, -58, 0, 0)
        actLbl.BackgroundTransparency = 1
        actLbl.Text = "ACTIVATE"
        actLbl.TextColor3 = WHITE
        actLbl:SetAttribute("FreshThemeRole", "textPrimary")
        actLbl.Font = UI_FONT_BOLD
        actLbl.TextSize = 11
        actLbl.TextXAlignment = Enum.TextXAlignment.Right
        actLbl.ZIndex = 8
    end
    do
        local row = mkRow(speedPage, 38)
        mkLabel(row, "Insta Reset")
        local resetButton = Instance.new("TextButton", row)
        resetButton.Size = UDim2.new(0, 52, 0, 26)
        resetButton.Position = UDim2.new(1, -172, 0.5, -13)
        resetButton.BackgroundColor3 = themePalette.buttonBg
        resetButton.BorderSizePixel = 0
        resetButton.Text = "RESET"
        resetButton.TextColor3 = themePalette.buttonText
        resetButton.Font = UI_FONT_HEAVY
        resetButton.TextSize = 11
        resetButton.AutoButtonColor = false
        resetButton.ZIndex = 9
        resetButton:SetAttribute("FreshThemeRole", "actionButton")
        Instance.new("UICorner", resetButton).CornerRadius = UDim.new(0, 8)
        local resetStroke = Instance.new("UIStroke", resetButton)
        resetStroke.Color = themePalette.accent
        resetStroke.Thickness = 1.2
        resetButton.MouseEnter:Connect(function()
            resetButton.BackgroundColor3 = themePalette.accent
            resetButton.TextColor3 = themePalette.buttonActiveText
        end)
        resetButton.MouseLeave:Connect(function()
            resetButton.BackgroundColor3 = themePalette.buttonBg
            resetButton.TextColor3 = themePalette.buttonText
        end)
        mkKeyButton(row, KB.InstaReset, true)
        resetButton.Activated:Connect(function()
            if performFreshInstaReset() then
                resetButton.Text = "RESETTING"
                task.delay(0.55, function()
                    if resetButton and resetButton.Parent then resetButton.Text = "RESET" end
                end)
            end
        end)
    end

    local combatPage = contentPages["Combat"]
    local stealPage = contentPages["Steal"]

    mkSect(combatPage, "Jump")
    setJumpVisual = mkToggle(combatPage, "Infinite Jump", function(on)
        jumpEnabled = on == true
        if jumpEnabled then InfiniteJump.start() else InfiniteJump.stop() end
        saveAllSettings()
    end)
    if setJumpVisual then setJumpVisual(jumpEnabled) end

    mkSect(combatPage, "Anti Ragdoll")
    local antiRagdollSetVisual
    antiRagdollSetVisual = mkToggle(combatPage, "Anti Ragdoll", function(on)
        setAntiRagdollMode(on)
    end)
    _G.updateAntiRagdollUI = function(enabled)
        if antiRagdollSetVisual then
            antiRagdollSetVisual(enabled == true or enabled == "v2")
        end
    end
    if antiRagdollSetVisual then antiRagdollSetVisual(antiRagdollMode == "v2") end
    ragdollTimerSetVisual = mkToggle(combatPage, "Ragdoll Timer", function(on)
        ragdollTimerEnabled = on == true
        if not ragdollTimerEnabled then
            _ragCountdownRunning = false
            local char = LP.Character
            local bb = char and char:FindFirstChild("FreshRagdollTimer")
            if bb then pcall(function() bb:Destroy() end) end
        end
        saveAllSettings()
    end)
    if ragdollTimerSetVisual then ragdollTimerSetVisual(ragdollTimerEnabled) end
    mkSect(combatPage, "Defense")
    setAntiBatVisual = mkToggle(combatPage, "Anti Bat", function(on)
        if on then startAntiBat() else stopAntiBat() end
        saveAllSettings()
    end, KB.AntiBat)
    if setAntiBatVisual then setAntiBatVisual(antiBatEnabled) end

    setUnwalkVisual = mkToggle(combatPage, "Unwalk", function(on)
        unwalkEnabled = on
        if on then startUnwalk() else stopUnwalk() end
    end)

    setAntiDieVisual = mkToggle(combatPage, "Anti Die", function(on)
        antiDieEnabled = on
        if on then AntiDieModule.start() else AntiDieModule.stop() end
        saveAllSettings()
    end)
    if setAntiDieVisual then setAntiDieVisual(antiDieEnabled) end

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

    mkSect(combatPage, "Targeting")
    bodyLockSetVisual = mkToggle(combatPage, "Body Lock", function(on)
        bodyLockEnabled = on
        if on then
            _blWasEnabled = _blSuppressCount > 0
            if not _bodyLockConn then startBodyLock() end
        else
            _blWasEnabled = false
            stopBodyLock()
        end
    end)
    do
        local row = mkRow(combatPage, 38)
        mkLabel(row, "Body Lock Range")
        bodyLockRangeBox = mkBox(row, bodyLockRange, 50, 56, function(v)
            if v and v > 0 then
                bodyLockRange = _clamp(_floor(v), 5, 200)
                if bodyLockRangeBox then bodyLockRangeBox.Text = tostring(bodyLockRange) end
            end
        end)
    end

    mkSect(combatPage, "Aimbots")
    autoBatSetVisual = mkToggle(combatPage, "Auto Bat", function(on)
        if on then enableAutoBat() else disableAutoBat() end
        if mobSetAutoBat then mobSetAutoBat(on) end
    end, KB.AutoBat)
    autoSwingSetVisual = mkToggle(combatPage, "Auto Swing", function(on)
        AUTO_SWING_ENABLED = on == true
        saveAllSettings()
    end)
    if autoSwingSetVisual then autoSwingSetVisual(AUTO_SWING_ENABLED) end
    do local row = mkRow(combatPage, 38); mkLabel(row, "Bat Aimbot Speed"); batSpeedBox = mkBox(row, BAT_AIMBOT_SPEED, 50, 56, function(v) if v > 0 and v <= 200 then BAT_AIMBOT_SPEED = v; saveAllSettings() end end) end

    mkSect(combatPage, "Utility")
    dropBrainrotSetVisual = mkToggle(combatPage, "Jump Drop", function(on)
        if on then
            executeDropWithToggle(function(v)
                dropBrainrotSetVisual(v)
                if mobSetDropBR then mobSetDropBR(v) end
            end)
        end
    end, KB.DropBrainrot)
    setDropVisual = dropBrainrotSetVisual

    mkSect(stealPage, "Steal")
    setInstaGrab = mkToggle(stealPage, "Auto Steal", function(on)
        CONFIG.AUTO_STEAL_ENABLED = on == true
        if on then pcall(startAutoSteal) else stopAutoSteal() end
        updateProgressBarVisibility()
        task.defer(function() pcall(saveAllSettings) end)
    end)

    do
        local row = mkRow(stealPage, 38)
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
    local visualPage = contentPages["Tools"]

    mkSect(visualPage, "VISUAL")

    setXRayVisual = mkToggle(visualPage, "X-Ray", function(on)
        setXRayEnabled(on)
        saveAllSettings()
    end)
    if setXRayVisual then setXRayVisual(xrayEnabled) end
    setXRayBrainrotVisual = mkToggle(visualPage, "X-Ray Brainrot", function(on)
        _G.FreshHubSetBrainrotXRay(on)
        saveAllSettings()
    end)
    if setXRayBrainrotVisual then setXRayBrainrotVisual(xrayBrainrotEnabled) end
    do
        local row = mkRow(visualPage, 38)
        mkLabel(row, "Anim Pack")
        local animOptions = {}
        for _, entry in ipairs(ANIM_PACK_ORDER) do table.insert(animOptions, entry[2]) end
        local animIndex = 1
        for i, name in ipairs(animOptions) do
            if name == currentAnimPack then animIndex = i; break end
        end
        animSelectorLabel = mkSelector(row, animOptions[animIndex], animOptions, function(direction, update)
            animIndex = ((animIndex - 1 + direction) % #animOptions) + 1
            local packName = animOptions[animIndex]
            update(packName)
            if packName == "Off" then stopAnimPack() else startAnimPack(packName) end
            saveAllSettings()
        end)
    end


    independentCosmeticOptions = {"Off", "Korblox", "Headless", "Both"}
    independentCosmeticRow = mkRow(visualPage, 38)
    mkLabel(independentCosmeticRow, "Korblox / Head")
    independentCosmeticSelector = mkSelector(independentCosmeticRow, getIndependentCosmeticMode(), independentCosmeticOptions, function(direction, update)
        local mode = independentCosmeticSelector and independentCosmeticSelector.Text or "Off"
        headlessIndependentEnabled = mode == "Headless" or mode == "Both"
        korbloxRightIndependentEnabled = mode == "Korblox" or mode == "Both"
        applyIndependentAppearance(LP.Character)
        syncIndependentCosmeticSelector()
        saveAllSettings()
    end)
    katanaSkinSetVisual = mkToggle(visualPage, "Skin", function(on)
        katanaSkinEnabled = on == true
        if katanaSkinEnabled then
            if LP.Character then applyKatanaSkin(LP.Character) end
        elseif LP.Character then
            removeKatanaSkin(LP.Character)
        end
        saveAllSettings()
    end)
    if katanaSkinSetVisual then katanaSkinSetVisual(katanaSkinEnabled) end

    setESPVIsual = mkToggle(visualPage, "Player ESP", function(on) toggleESP(on) end)
    do
        local row = mkRow(visualPage, 32)
        local stretchLabel = mkLabel(row, "Stretch Rez")
        stretchLabel.Position = UDim2.new(0, 18, 0, 0)
        local stretchMarker = Instance.new("Frame", row)
        stretchMarker.Name = "ToggleLabelMarker"
        stretchMarker.AnchorPoint = Vector2.new(0, 0.5)
        stretchMarker.Position = UDim2.new(0, 8, 0.5, 0)
        stretchMarker.Size = UDim2.new(0, 2, 0, 12)
        stretchMarker.BackgroundColor3 = themePalette.accent
        stretchMarker.BackgroundTransparency = 0.1
        stretchMarker.BorderSizePixel = 0
        stretchMarker.Visible = false
        stretchMarker.ZIndex = 9
        Instance.new("UICorner", stretchMarker).CornerRadius = UDim.new(1, 0)
        local stretchPill, stretchDot = mkPill(row, 48)
        local stretchOn = false
        local function setStretch(s)
            stretchOn = s == true
            stretchMarker.Visible = stretchOn
            animPill(stretchPill, stretchDot, stretchOn)
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

    setFovVisual = mkToggle(visualPage, "FOV", function(on)
        if on then enableCustomFov() else disableCustomFov() end
    end)
    if setFovVisual then setFovVisual(fovEnabled) end

    do
        local row = mkRow(visualPage, 38)
        mkLabel(row, "FOV Value")
        fovSliderSet = mkSlider(row, 20, 120, fovValue, function(v)
            fovValue = v
            if not fovEnabled then
                enableCustomFov()
                if setFovVisual then setFovVisual(true) end
            end
            local cam = workspace.CurrentCamera
            if cam then pcall(function() cam.FieldOfView = fovValue end) end
        end)
    end


    mkSect(visualPage, "Skys")
    skySetVisual = mkToggle(visualPage, "Sky", function(on)
        setFreshSkyEnabled(on)
        task.defer(function() pcall(saveAllSettings) end)
    end)
    do
        local row = mkRow(visualPage, 38)
        mkLabel(row, "Sky Style")
        skyModeBtnRef = mkSelector(row, skyMode, SKY_OPTIONS, function(direction, update)
            local idx = 1
            for i, option in ipairs(SKY_OPTIONS) do if option == skyMode then idx = i; break end end
            idx = ((idx - 1 + direction) % #SKY_OPTIONS) + 1
            setFreshSkyMode(SKY_OPTIONS[idx], update)
        end)
    end
    if skySetVisual then skySetVisual(skyEnabled) end
    local uiPage = contentPages["Settings"]
    mkSect(uiPage, "Interface")
    mkSect(uiPage, "Performance")
    setAntiLagVisual = mkToggle(uiPage, "Anti Lag", function(on)
        if on then enableAntiLagVx7() else disableAntiLagVx7() end
        saveAllSettings()
    end)
    mkSect(uiPage, "Audio")
    setFreshIntroVisual = mkToggle(uiPage, "Music Intro", function(on)
        _sharedEnv.__FreshIntroState.Enabled = on == true
        if _sharedEnv.__FreshIntroState.Enabled then _sharedEnv.__FreshPlayIntro() else _sharedEnv.__FreshStopIntro() end
        saveAllSettings()
    end)
    if setFreshIntroVisual then setFreshIntroVisual(_sharedEnv.__FreshIntroState.Enabled) end
    setLockUIVisual = mkToggle(uiPage, "Lock UI", function(on)
        toggleLockUI(on)
        saveAllSettings()
    end)
    if setLockUIVisual then pcall(setLockUIVisual, uiLocked) end

    setHideButtonsVisual = mkToggle(uiPage, "Hide Buttons", function(on)
        hideButtons = on == true
        applyHideButtonsVisibility()
        saveAllSettings()
    end, KB.GuiHide)
    if setHideButtonsVisual then setHideButtonsVisual(hideButtons) end

    do
        local row = mkRow(uiPage, 38)
        mkLabel(row, "UI Scale")
        uiScaleBox = mkBox(row, uiScaleValue, 50, 56, function(v)
            local n = _clamp(_floor(v+0.5), 50, 150)
            uiScaleValue = n
            if mainUIScale then mainUIScale.Scale = n/100 end
            if pbScale then pbScale.Scale = 1 end
        end)
    end

    mkSect(uiPage, "Configuration")
    do
        local function makeSettingsAction(labelText, successText, callback, requireConfirm)
            local row = mkRow(uiPage, 44)
            local button = Instance.new("TextButton", row)
            button.Size = UDim2.new(1, -16, 0, 36)
            button.Position = UDim2.new(0, 8, 0.5, -18)
            button.BackgroundColor3 = themePalette.buttonBg
            button.BorderSizePixel = 0
            button.Text = labelText
            button.TextColor3 = themePalette.buttonText
            button.Font = UI_FONT_HEAVY
            button.TextSize = 12
            button.AutoButtonColor = false
            button.ZIndex = 9
            button:SetAttribute("FreshThemeRole", "actionButton")
            button:SetAttribute("FreshActionHover", false)
            button:SetAttribute("FreshActionActive", false)
            Instance.new("UICorner", button).CornerRadius = UDim.new(0, 9)
            local stroke = Instance.new("UIStroke", button)
            stroke.Color = getThemeColor()
            stroke:SetAttribute("FreshThemeRole", "accentStroke")
            stroke.Thickness = 1.2
            stroke.Transparency = 0.16
            local busy, confirmArmed = false, false
            local confirmGeneration = 0
            button.MouseEnter:Connect(function()
                button:SetAttribute("FreshActionHover", true)
                button.BackgroundColor3 = themePalette.buttonHoverBg
                button.TextColor3 = themePalette.buttonActiveText
            end)
            button.MouseLeave:Connect(function()
                button:SetAttribute("FreshActionHover", false)
                local active = button:GetAttribute("FreshActionActive") == true or confirmArmed
                button.BackgroundColor3 = active and themePalette.accent or themePalette.buttonBg
                button.TextColor3 = active and themePalette.buttonActiveText or themePalette.buttonText
            end)
            button.Activated:Connect(function()
                if busy then return end
                if requireConfirm and not confirmArmed then
                    confirmArmed = true
                    confirmGeneration = confirmGeneration + 1
                    local generation = confirmGeneration
                    button.Text = "CONFIRM RESET?"
                    button:SetAttribute("FreshActionActive", true)
                    button.BackgroundColor3 = themePalette.accent
                    button.TextColor3 = themePalette.buttonActiveText
                    task.delay(2.5, function()
                        if button and button.Parent and confirmArmed and confirmGeneration == generation then
                            confirmArmed = false
                            button:SetAttribute("FreshActionActive", false)
                            button.Text = labelText
                            local hovered = button:GetAttribute("FreshActionHover") == true
                            button.BackgroundColor3 = hovered and themePalette.buttonHoverBg or themePalette.buttonBg
                            button.TextColor3 = hovered and themePalette.buttonActiveText or themePalette.buttonText
                        end
                    end)
                    return
                end
                busy = true
                if confirmArmed then
                    confirmArmed = false
                    confirmGeneration = confirmGeneration + 1
                end
                local ok, result = pcall(callback)
                local success = ok and result ~= false
                button.Text = success and successText or "ACTION FAILED"
                button:SetAttribute("FreshActionActive", success)
                button.BackgroundColor3 = success and themePalette.accent or themePalette.buttonBg
                button.TextColor3 = success and themePalette.buttonActiveText or themePalette.buttonText
                task.delay(1.35, function()
                    if button and button.Parent then
                        button.Text = labelText
                        button:SetAttribute("FreshActionActive", false)
                        local hovered = button:GetAttribute("FreshActionHover") == true
                        button.BackgroundColor3 = hovered and themePalette.buttonHoverBg or themePalette.buttonBg
                        button.TextColor3 = hovered and themePalette.buttonActiveText or themePalette.buttonText
                    end
                    busy = false
                end)
            end)
            return button
        end
        makeSettingsAction("RESET POSITIONS", "POSITIONS RESET", function()
            return resetFloatingPositions()
        end)
        makeSettingsAction("RESET ALL CONFIG", "ALL CONFIG RESET", function()
            return resetToFactoryDefaults()
        end, true)
    end

    -- New Auto Grab bar: full replacement of the old multi-metric bar.
    pbFrame = Instance.new("Frame", gui)
    pbFrame.Name = "AutoGrabBar"
    pbFrame.Size = UDim2.new(0, 430, 0, 88)
    pbFrame.Position = UDim2.new(0.5, -215, 1, -106)
    pbFrame.BackgroundColor3 = FRESH_VX7_BAR_COLORS.FRAME
    pbFrame.BackgroundTransparency = 0
    pbFrame.BorderSizePixel = 0
    pbFrame.Active = true
    pbFrame.ZIndex = 300
    pbFrame.Visible = false
    pbFrame.ClipsDescendants = true
    barCorner = Instance.new("UICorner", pbFrame)
    barCorner.CornerRadius = UDim.new(0, 12)
    border = Instance.new("UIStroke", pbFrame)
    border.Color = FRESH_VX7_BAR_COLORS.BORDER
    border.Thickness = 1.4
    border.Transparency = 0.12
    border.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

    pbScale = Instance.new("UIScale", pbFrame)
    pbScale.Scale = 1
    if savedProgressBarPos then
        local xScale = tonumber(savedProgressBarPos.XScale) or 0.5
        local xOffset = tonumber(savedProgressBarPos.XOffset) or -215
        local yScale = tonumber(savedProgressBarPos.YScale) or 1
        local yOffset = tonumber(savedProgressBarPos.YOffset) or -106
        local centered = math.abs(xScale - 0.5) < 0.001 and math.abs(yScale - 1) < 0.001
        local oldDefault = centered and (
            (xOffset == -170 and yOffset == -54) or
            (xOffset == -140 and yOffset == -62) or
            (xOffset == -140 and yOffset == -80) or
            (xOffset == -190 and yOffset == -56) or
            (xOffset == -120 and yOffset == -46) or
            (xOffset == -186 and yOffset == -134) or
            (xOffset == -220 and yOffset == -124) or
            (xOffset == -325 and yOffset == -150) or
            (xOffset == -220 and yOffset == -104) or
            (xOffset == -110 and yOffset == -52) or
            (xOffset == -170 and yOffset == -104) or
            (xOffset == -180 and yOffset == -76) or
            (xOffset == -180 and yOffset == -66) or
            (xOffset == -184 and yOffset == -58) or
            (xOffset == -160 and yOffset == -58) or
            (xOffset == -190 and yOffset == -90) or
            (xOffset == -180 and yOffset == -132) or
            (xOffset == -210 and yOffset == -124) or
            (xOffset == -215 and yOffset == -106)
        )
        if not oldDefault then pbFrame.Position = UDim2.new(xScale, xOffset, yScale, yOffset) end
    end

    local barLogo = Instance.new("ImageLabel", pbFrame)
    barLogo.Name = "AutoGrabLogo"
    barLogo.Size = UDim2.new(0, 48, 0, 32)
    barLogo.Position = UDim2.new(0, 14, 0, 7)
    barLogo.BackgroundTransparency = 1
    barLogo.BorderSizePixel = 0
    barLogo.Image = "rbxassetid://80933500881945"
    barLogo.ImageColor3 = Color3.fromRGB(255, 255, 255)
    barLogo.ScaleType = Enum.ScaleType.Fit
    barLogo.ZIndex = 302

    local headerDivider = Instance.new("Frame", pbFrame)
    headerDivider.Name = "HeaderDivider"
    headerDivider.Size = UDim2.new(0, 1, 0, 26)
    headerDivider.Position = UDim2.new(0, 79, 0, 10)
    headerDivider.BackgroundColor3 = FRESH_VX7_BAR_COLORS.BORDER
    headerDivider.BackgroundTransparency = 0.45
    headerDivider.BorderSizePixel = 0
    headerDivider.ZIndex = 302

    local barTitle = Instance.new("TextLabel", pbFrame)
    barTitle.Name = "AutoGrabTitle"
    barTitle.Size = UDim2.new(0, 104, 0, 18)
    barTitle.Position = UDim2.new(0, 94, 0, 10)
    barTitle.BackgroundTransparency = 1
    barTitle.Text = "AUTO GRAB"
    barTitle.TextColor3 = FRESH_VX7_BAR_COLORS.TEXT
    barTitle.Font = Enum.Font.GothamBold
    barTitle.TextSize = 12
    barTitle.TextXAlignment = Enum.TextXAlignment.Left
    barTitle.TextYAlignment = Enum.TextYAlignment.Center
    barTitle.ZIndex = 302
    barTitle:SetAttribute("FreshStealBarKeepTextColor", true)

    local statusLabel = Instance.new("TextLabel", pbFrame)
    statusLabel.Name = "StealStatus"
    statusLabel.Size = UDim2.new(0, 126, 0, 16)
    statusLabel.Position = UDim2.new(0, 202, 0, 11)
    statusLabel.BackgroundTransparency = 1
    statusLabel.Text = "WAITING"
    statusLabel.TextColor3 = FRESH_VX7_BAR_COLORS.MUTED
    statusLabel.Font = Enum.Font.GothamBold
    statusLabel.TextSize = 10
    statusLabel.TextXAlignment = Enum.TextXAlignment.Center
    statusLabel.TextYAlignment = Enum.TextYAlignment.Center
    statusLabel.TextTruncate = Enum.TextTruncate.AtEnd
    statusLabel.ZIndex = 302
    statusLabel:SetAttribute("FreshStealBarKeepTextColor", true)
    _G.__FreshStealBarStatus = statusLabel

    progressPct = Instance.new("TextLabel", pbFrame)
    progressPct.Name = "ProgressPercent"
    progressPct.Size = UDim2.new(0, 64, 0, 26)
    progressPct.Position = UDim2.new(1, -78, 0, 6)
    progressPct.BackgroundTransparency = 1
    progressPct.Text = "0%"
    progressPct.TextColor3 = FRESH_VX7_BAR_COLORS.TEXT
    progressPct.Font = Enum.Font.GothamBold
    progressPct.TextSize = 18
    progressPct.TextXAlignment = Enum.TextXAlignment.Right
    progressPct.TextYAlignment = Enum.TextYAlignment.Center
    progressPct.TextStrokeTransparency = 1
    progressPct.ZIndex = 302
    progressPct:SetAttribute("FreshStealBarKeepTextColor", true)

    local function makeBarMetric(name, x, width, text)
        local label = Instance.new("TextLabel", pbFrame)
        label.Name = name
        label.Size = UDim2.new(0, width, 0, 16)
        label.Position = UDim2.new(0, x, 0, 61)
        label.BackgroundTransparency = 1
        label.Text = text
        label.TextColor3 = FRESH_VX7_BAR_COLORS.MUTED
        label.Font = Enum.Font.GothamBold
        label.TextSize = 11
        label.TextXAlignment = Enum.TextXAlignment.Center
        label.TextYAlignment = Enum.TextYAlignment.Center
        label.TextStrokeTransparency = 1
        label.ZIndex = 302
        label:SetAttribute("FreshStealBarKeepTextColor", true)
        return label
    end
    local pbPingLabel = makeBarMetric("PingMetric", 16, 124, "PING --MS")
    local pbRadiusLabel = makeBarMetric("RadiusMetric", 153, 124, "RADIUS 60")
    pbFpsPingLabel = makeBarMetric("FpsMetric", 290, 124, "FPS --")

    local function makeStatDivider(name, x)
        local divider = Instance.new("Frame", pbFrame)
        divider.Name = name
        divider.Size = UDim2.new(0, 1, 0, 16)
        divider.Position = UDim2.new(0, x, 0, 61)
        divider.BackgroundColor3 = FRESH_VX7_BAR_COLORS.BORDER
        divider.BackgroundTransparency = 0.5
        divider.BorderSizePixel = 0
        divider.ZIndex = 302
        return divider
    end
    makeStatDivider("MetricDividerOne", 147)
    makeStatDivider("MetricDividerTwo", 284)

    local progressTrack = Instance.new("Frame", pbFrame)
    progressTrack.Name = "ProgressTrack"
    progressTrack.Size = UDim2.new(1, -32, 0, 7)
    progressTrack.Position = UDim2.new(0, 16, 0, 43)
    progressTrack.BackgroundColor3 = FRESH_VX7_BAR_COLORS.TRACK
    progressTrack.BackgroundTransparency = 0
    progressTrack.BorderSizePixel = 0
    progressTrack.ClipsDescendants = true
    progressTrack.ZIndex = 301
    progressTrack:SetAttribute("FreshThemeRole", "stealBarTrack")
    Instance.new("UICorner", progressTrack).CornerRadius = UDim.new(1, 0)
    _G.__FreshStealBarTrack = progressTrack

    local trackStroke = Instance.new("UIStroke", progressTrack)
    trackStroke.Color = FRESH_VX7_BAR_COLORS.BORDER
    trackStroke.Thickness = 0.8
    trackStroke.Transparency = 0.55
    trackStroke:SetAttribute("FreshThemeRole", "stealBarBorder")

    progressFill = Instance.new("Frame", progressTrack)
    progressFill.Name = "ProgressFill"
    progressFill.Size = UDim2.new(0, 0, 1, 0)
    progressFill.Position = UDim2.new(0, 0, 0, 0)
    progressFill.BackgroundColor3 = FRESH_VX7_BAR_COLORS.ACCENT
    progressFill.BackgroundTransparency = 0
    progressFill.BorderSizePixel = 0
    progressFill.ZIndex = 302
    progressFill.ClipsDescendants = true
    progressFill:SetAttribute("FreshThemeRole", "stealBarAccent")
    Instance.new("UICorner", progressFill).CornerRadius = UDim.new(1, 0)
    -- Cursor luminoso que recorre el riel; al ser hijo del relleno sigue el progreso sin loops extra.
    local lockTip = Instance.new("Frame", progressFill)
    lockTip.Name = "LockSignalTip"
    lockTip.AnchorPoint = Vector2.new(0.5, 0.5)
    lockTip.Position = UDim2.new(1, -3, 0.5, 0)
    lockTip.Size = UDim2.new(0, 8, 0, 8)
    lockTip.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    lockTip.BorderSizePixel = 0
    lockTip.ZIndex = 304
    Instance.new("UICorner", lockTip).CornerRadius = UDim.new(1, 0)
    local lockTipStroke = Instance.new("UIStroke", lockTip)
    lockTipStroke.Color = FRESH_VX7_BAR_COLORS.ACCENT
    lockTipStroke.Thickness = 1.5
    _G.__FreshStealBarWash = progressFill
    _G.__FreshStealBarGradient = Instance.new("UIGradient", progressFill)
    _G.__FreshStealBarGradient.Name = "ProgressFillBlueGradient"
    _G.__FreshStealBarGradient.Rotation = 0
    _G.__FreshStealBarGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, FRESH_VX7_BAR_COLORS.DARK_ACCENT),
        ColorSequenceKeypoint.new(0.55, FRESH_VX7_BAR_COLORS.ACCENT),
        ColorSequenceKeypoint.new(1, FRESH_VX7_BAR_COLORS.HIGHLIGHT),
    })

    function applyStealBarStyle()
        if not pbFrame or not pbFrame.Parent then return end
        pbFrame.Name = "AutoGrabBar"
        pbFrame.Size = UDim2.new(0, 430, 0, 88)
        pbFrame.BackgroundColor3 = FRESH_VX7_BAR_COLORS.FRAME
        pbFrame.BackgroundTransparency = 0
        pbFrame.ClipsDescendants = true
        if barCorner then barCorner.CornerRadius = UDim.new(0, 12) end
        if border then
            border.Color = FRESH_VX7_BAR_COLORS.BORDER
            border.Thickness = 1.4
            border.Transparency = 0.12
        end
        progressTrack.Size = UDim2.new(1, -32, 0, 7)
        progressTrack.Position = UDim2.new(0, 16, 0, 43)
        progressTrack.BackgroundColor3 = FRESH_VX7_BAR_COLORS.TRACK
        if trackStroke then trackStroke.Color = FRESH_VX7_BAR_COLORS.BORDER end
        if barTitle then
            barTitle.Size = UDim2.new(0, 104, 0, 18)
            barTitle.Position = UDim2.new(0, 94, 0, 10)
            barTitle.TextColor3 = FRESH_VX7_BAR_COLORS.TEXT
        end
        if statusLabel then
            statusLabel.Size = UDim2.new(0, 126, 0, 16)
            statusLabel.Position = UDim2.new(0, 202, 0, 11)
            statusLabel.TextColor3 = FRESH_VX7_BAR_COLORS.MUTED
        end
        if pbPingLabel then pbPingLabel.TextColor3 = FRESH_VX7_BAR_COLORS.MUTED end
        if pbRadiusLabel then pbRadiusLabel.TextColor3 = FRESH_VX7_BAR_COLORS.MUTED end
        if pbFpsPingLabel then pbFpsPingLabel.TextColor3 = FRESH_VX7_BAR_COLORS.MUTED end
        if progressPct then
            progressPct.Size = UDim2.new(0, 64, 0, 26)
            progressPct.Position = UDim2.new(1, -78, 0, 6)
            progressPct.TextSize = 18
            progressPct.TextColor3 = FRESH_VX7_BAR_COLORS.TEXT
        end
        applyStealBarAccent(FRESH_VX7_BAR_COLORS.ACCENT)
    end
    applyStealBarStyle()

    do
        local metricsGui = gui
        local fpsAverage = 60
        local displayTimer = 0
        local pingTimer = 0
        local pingMs = 0
        local fpsConnection
        fpsConnection = RunService.RenderStepped:Connect(function(dt)
            -- No recalcular métricas ni consultar ping cuando la barra no se muestra.
            if not pbFrame or not pbFrame.Visible then return end
            if dt > 0 then
                local currentFps = 1 / dt
                fpsAverage = fpsAverage * 0.82 + currentFps * 0.18
            end
            displayTimer = displayTimer + (dt or 0)
            pingTimer = pingTimer + (dt or 0)
            if pingTimer >= 1 then
                pingTimer = 0
                pcall(function() pingMs = LP:GetNetworkPing() * 1000 end)
            end
            if displayTimer >= 0.25 then
                displayTimer = 0
                local radius = math.floor(tonumber(CONFIG.STEAL_RANGE) or 60)
                if pbPingLabel and pbPingLabel.Parent then
                    pbPingLabel.Text = string.format("PING %dMS", _floor(pingMs + 0.5))
                end
                if pbRadiusLabel and pbRadiusLabel.Parent then
                    pbRadiusLabel.Text = string.format("RADIUS %d", radius)
                end
                if pbFpsPingLabel and pbFpsPingLabel.Parent then
                    pbFpsPingLabel.Text = string.format("FPS %d", _floor(fpsAverage + 0.5))
                end
            end
        end)
        metricsGui.Destroying:Connect(function()
            if fpsConnection and fpsConnection.Connected then fpsConnection:Disconnect() end
        end)
    end

    drag(pbFrame)
    -- Unificar todos los botones visibles del panel en el estilo de referencia.
    for _, obj in ipairs(gui:GetDescendants()) do
if obj:IsA("TextButton") and (obj.Text ~= "" or obj == closeBtn or obj == miniBtn) then
    obj.BackgroundColor3 = themePalette.buttonBg
    obj.BackgroundTransparency = 0
    obj.TextColor3 = obj == miniBtn and themePalette.accentText or themePalette.buttonText
            obj.AutoButtonColor = false
            local btnStroke = obj:FindFirstChildOfClass("UIStroke") or Instance.new("UIStroke", obj)
            if not btnStroke:GetAttribute("FreshThemeRole") then
                btnStroke.Color = themePalette.rowBorder
                btnStroke:SetAttribute("FreshThemeRole", "secondaryStroke")
            end
            btnStroke.Thickness = 1.1
            btnStroke.Transparency = 0.22
    if not obj:FindFirstChildOfClass("UICorner") then
        Instance.new("UICorner", obj).CornerRadius = UDim.new(0, 10)
    end
        end
    end

    updateAllUIColors(selectedColor)
    setPanelBackground(backgroundIndex)

    drag(main)
end

function createMobilePanel()
    local panel = Instance.new("ScreenGui")
    panel.Name = "BloodHoundsMobilePanel"
    panel.ResetOnSpawn = false
    panel.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    panel.Enabled = not hideButtons
    pcall(function() if syn and syn.protect_gui then syn.protect_gui(panel) end end)
    local okPanel = pcall(function() panel.Parent = game:GetService("CoreGui") end)
    if not okPanel then panel.Parent = LP:WaitForChild("PlayerGui") end

    local BTN_W, BTN_H = 60, 60
    local GAP = 8
    local COLUMNS = 2
    local ROWS = 5
    local GRID_W = BTN_W * COLUMNS + GAP * (COLUMNS - 1)
    local GRID_H = BTN_H * ROWS + (GAP + 10) * (ROWS - 1)
    local PANEL_W = GRID_W
    local PANEL_H = GRID_H

    local container = Instance.new("Frame", panel)
    container.Name = "FloatingPanel"
    container.Size = UDim2.new(0, PANEL_W, 0, PANEL_H)
    container.Position = UDim2.new(1, -(PANEL_W + 12), 0.5, -PANEL_H / 2)
    -- Contenedor transparente, sin marco ni encabezado; solo los botones reciben input.
    container.BackgroundTransparency = 1
    container.BorderSizePixel = 0
    container.Active = false
    container.Selectable = false
    container.ClipsDescendants = false

    local containerScale = Instance.new("UIScale", container)
    containerScale.Scale = floatingButtonScale
    table.insert(_floatingUIScales, containerScale)

    local btnContainer = Instance.new("Frame", container)
    btnContainer.Name = "ButtonsContainer"
    btnContainer.Size = UDim2.new(1, 0, 1, 0)
    btnContainer.Position = UDim2.new(0, 0, 0, 0)
    btnContainer.BackgroundTransparency = 1
    btnContainer.ClipsDescendants = false
    btnContainer.Active = false

    local INACTIVE_BG = themePalette.buttonBg
    local INACTIVE_TEXT = themePalette.buttonText
    local STROKE_COLOR = themePalette.rowBorder

    local buttons = {}
    local buttonNames = {"DropBR", "AutoLeft", "AutoBat", "AutoRight", "TpDown", "Carry", "Lagger1", "Lagger2", "InstaReset"}
    local buttonTexts = {"DROP\nBR", "AUTO\nLEFT", "BAT\nAIMBOT", "AUTO\nRIGHT", "TP\nDOWN", "CARRY\nSPD", "LAGGER\n1", "LAGGER\n2", "INSTA\nRESET"}

    local function createButton(name, text, order, isToggle, callback)
        local btn = Instance.new("TextButton", btnContainer)
        btn.Name = name
        btn.Size = UDim2.new(0, BTN_W, 0, BTN_H)
        btn.BackgroundColor3 = INACTIVE_BG
        btn.BackgroundTransparency = 1
        btn.BorderSizePixel = 0
        btn.Text = ""
        btn.AutoButtonColor = false
        btn.ZIndex = 10

        -- La versión de layout v3 ya migró una vez las posiciones antiguas;
        -- se conservan los ajustes manuales guardados después de esa migración.
        local savedPos = savedButtonPositions[name]
        if savedPos then
            btn.Position = UDim2.new(0, savedPos.X or 0, 0, savedPos.Y or 0)
        else
            local defX, defY = getDefaultButtonPosition(name)
            btn.Position = UDim2.new(0, defX, 0, defY)
        end

btn.BackgroundColor3 = INACTIVE_BG
btn.BackgroundTransparency = 1
Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)

local bgGrad = Instance.new("UIGradient", btn)
        bgGrad.Name = "BtnGrad"
        bgGrad.Rotation = 135
        bgGrad.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0.00, themePalette.accentDark),
            ColorSequenceKeypoint.new(0.45, themePalette.buttonBg),
            ColorSequenceKeypoint.new(1.00, themePalette.toggleBg),
        })
        bgGrad.Transparency = NumberSequence.new(0.12)

        local stroke = Instance.new("UIStroke", btn)
        stroke.Color = STROKE_COLOR
        stroke.Thickness = 1.25
        stroke.Transparency = 0.24
        stroke.Name = "NormalStroke"

        local activeRail = Instance.new("Frame", btn)
        activeRail.Name = "ActiveRail"
        activeRail.Size = UDim2.new(0, 3, 1, -18)
        activeRail.Position = UDim2.new(0, 5, 0, 9)
        activeRail.BackgroundColor3 = Color3.fromRGB(100, 190, 255)
        activeRail.BackgroundTransparency = 1
        activeRail.BorderSizePixel = 0
        activeRail.ZIndex = 12
        Instance.new("UICorner", activeRail).CornerRadius = UDim.new(1, 0)

        local label = Instance.new("TextLabel", btn)
        label.Name = "TextLabel"
        label.Size = UDim2.new(1, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.Text = text
        label.TextColor3 = INACTIVE_TEXT
        label.Font = UI_FONT_HEAVY
        label.TextSize = 12
        label.TextScaled = true
        label.TextWrapped = true
        label.TextColor3 = Color3.fromRGB(220, 230, 245)
        label.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        label.TextStrokeTransparency = 0.35
        label.ZIndex = 11
        local textConstraint = Instance.new("UITextSizeConstraint", label)
        textConstraint.MinTextSize = 8
        textConstraint.MaxTextSize = 12

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
        local activeInput = nil
        local movedDistance = 0
        local TAP_MOVE_THRESHOLD = 12

        local function onInputBegan(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                hasMoved = false
                movedDistance = 0
                dragStart = input.Position
                startPos = btn.Position
                activeInput = input
                _isDraggingButton = true
                TS:Create(btn, TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    Position = UDim2.new(0, startPos.X.Offset, 0, startPos.Y.Offset + 4),
                    Size = UDim2.new(0, BTN_W, 0, BTN_H - 4)
                }):Play()
            end
        end

        local function onInputChanged(input)
            if not dragging or not activeInput then return end
            local isTouchMove = activeInput.UserInputType == Enum.UserInputType.Touch
                                and input == activeInput
            local isMouseMove = activeInput.UserInputType == Enum.UserInputType.MouseButton1
                                and input.UserInputType == Enum.UserInputType.MouseMovement
            -- Ignorar el joystick y otros toques: solo cuenta el toque que inicio
            -- dentro de este boton.
            if not isTouchMove and not isMouseMove then return end
            local delta = input.Position - dragStart
                movedDistance = delta.Magnitude
                -- Un pequeno movimiento del dedo/raton no debe cancelar el toque.
                if not uiLocked and movedDistance > TAP_MOVE_THRESHOLD then
                    hasMoved = true
                    btn.Position = UDim2.new(0, startPos.X.Offset + delta.X, 0, startPos.Y.Offset + delta.Y)
                end
        end

        local function onInputEnded(input)
            if not activeInput or input ~= activeInput then return end
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                if dragging then
                    -- Capturar el estado antes de limpiarlo; antes siempre quedaba false
                    -- y el boton podia perder el toque o guardar una posicion incorrecta.
                    local wasMoved = hasMoved
                    local wasLocked = uiLocked
                    local releasePosition = wasMoved and btn.Position or startPos
                    if not wasMoved and movedDistance <= TAP_MOVE_THRESHOLD then
                        if isToggle then
                            if callback then callback(setActive) end
                        else
                            if callback then callback(setActive, active) end
                        end
                    elseif not wasLocked and wasMoved then
                        saveStableButtonPosition(name, btn)
                    end
                    dragging = false
                    hasMoved = false
                    dragStart = nil
                    startPos = nil
                    activeInput = nil
                    movedDistance = 0
                    _isDraggingButton = false
                    local releaseTween = TS:Create(btn, TweenInfo.new(0.10, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                        Position = releasePosition or btn.Position,
                        Size = UDim2.new(0, BTN_W, 0, BTN_H)
                    })
                    releaseTween:Play()
                    if not wasLocked and wasMoved then
                        releaseTween.Completed:Connect(function()
                            saveStableButtonPosition(name, btn)
                        end)
                    end
                end
            end
        end

        btn.InputBegan:Connect(onInputBegan)
        -- El movimiento debe escucharse globalmente: el cursor suele salir del boton al arrastrarlo.
        UIS.InputChanged:Connect(onInputChanged)
        UIS.InputEnded:Connect(onInputEnded)

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
                toggleCarryMode()
                setActive(speedMode)
            end
        elseif name == "Lagger1" then
            callback = function(setActive)
                toggleLaggerMode()
                setActive(laggerToggled)
            end
        elseif name == "Lagger2" then
            callback = function(setActive)
                toggleLaggerCarryMode()
                setActive(laggerCarryToggled)
            end
        elseif name == "InstaReset" then
            callback = function(setActive)
                local ok = performFreshInstaReset()
                setActive(ok)
                if ok then task.delay(0.55, function() setActive(false) end) end
            end
        end
        mobSetAutoBat = buttons.AutoBat and buttons.AutoBat.setActive
        mobSetAutoLeft = buttons.AutoLeft and buttons.AutoLeft.setActive
        mobSetAutoRight = buttons.AutoRight and buttons.AutoRight.setActive
        mobSetDropBR = buttons.DropBR and buttons.DropBR.setActive
        mobSetTpDown = buttons.TpDown and buttons.TpDown.setActive
        mobSetCarry = buttons.Carry and buttons.Carry.setActive
        mobSetLagger1 = buttons.Lagger1 and buttons.Lagger1.setActive
        mobSetLagger2 = buttons.Lagger2 and buttons.Lagger2.setActive

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

    if savedMobilePanelPos then
        container.Position = UDim2.new(
            savedMobilePanelPos.XScale or 0,
            savedMobilePanelPos.XOffset or -(PANEL_W + 12),
            savedMobilePanelPos.YScale or 0.5,
            savedMobilePanelPos.YOffset or -PANEL_H / 2
        )
    end
    return panel
end

-- ============================================================
-- 20. GUARDADO, CARGA Y RESET DE CONFIGURACION
-- ============================================================
savedProgressBarPos = nil
savedButtonPositions = {}
savedMobilePanelPos = nil
savedMainPanelPos = nil

function stopAllBackgroundTasks()
    if movementLoop then movementLoop:Disconnect(); movementLoop = nil end
    if steppedConn then steppedConn:Disconnect(); steppedConn = nil end
    stopEnemySpeed()
    if stretchEnabled then disableStretch() end
    if stretchConn then stretchConn:Disconnect(); stretchConn = nil end
    if stretchFovConn then stretchFovConn:Disconnect(); stretchFovConn = nil end
    if AntiRagdollV2.Enabled then stopAntiRagdollV2() end
    if antiDieEnabled then AntiDieModule.stop() end
    stopAntiBat()
    if antiFlingEnabled then AntiFlingShieldModule.stop() end
    stopBatCounter()
    stopMedusaCounter()
    stopAutoSteal()
    disableAutoBat()
    stopAutoLeft()
    stopAutoRight()
    if unwalkEnabled then stopUnwalk() end
    if antiLagEnabled then disableAntiLag() end
    disableVividGraphics()
    if espEnabled then toggleESP(false) end
    if dropActive then stopDropBrainrot() end
    setXRayEnabled(false)
    _G.FreshHubSetBrainrotXRay(false)
    if bodyLockEnabled then stopBodyLock() end
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
end

function buildConfigTable()
    syncFloatingControlPositions()
    local config = {
        configVersion = 5,
        normalSpeed = NS,
        carrySpeed = CS,
        laggerSpeed1 = LAGGER_SPEED,
        laggerSpeed2 = LAGGER_CARRY_SPEED,
        stealRadius = CONFIG.STEAL_RANGE,
        antiRagdollMode = antiRagdollMode == "v2" and "v2" or "off",
        antiRagdollEnabled = antiRagdollMode == "v2",
        ragdollTimerEnabled = ragdollTimerEnabled == true,
        antiDieEnabled = antiDieEnabled == true,
        antiBat = antiBatEnabled,
        -- Clave antigua conservada para compatibilidad con configuraciones previas.
        antiBatEnabled = antiBatEnabled,
        infiniteJump = jumpEnabled,
        xrayEnabled = xrayEnabled,
        xrayBrainrotEnabled = xrayBrainrotEnabled == true,
        autoSteal = CONFIG.AUTO_STEAL_ENABLED,
        autoCarryEnabled = autoCarryEnabled,
        medusaCounter = medusaCounterEnabled,
        batCounter = batCounterEnabled,
        laggerToggled = laggerToggled,
        laggerCarryToggled = laggerCarryToggled,
        carryMode = speedMode,
        batAimbotSpeed = BAT_AIMBOT_SPEED,
        autoSwingEnabled = AUTO_SWING_ENABLED,
        dropMode = dropMode,
        stretchEnabled = stretchEnabled,
        stretchFOV = stretchFOV,
        fovEnabled = fovEnabled,
        fovValue = fovValue,
        uiScale = uiScaleValue,
        uiScaleReadabilityVersion = 1,
        uiScaleDefaultVersion = 2,
        animPack = currentAnimPack,
        espEnabled = espEnabled,
        antiLag = antiLagEnabled,
        introMusicEnabled = _sharedEnv.__FreshIntroState.Enabled == true,
        autoBatEnabled = autoBatEnabled,
        autoLeftEnabled = autoLeftEnabled,
        autoRightEnabled = autoRightEnabled,
        unwalk = unwalkEnabled,
        neonWeather = neonWeatherEnabled,
        skyEnabled = skyEnabled,
        skyMode = skyMode,
        mobileButtonPositions = savedButtonPositions,
        atbDockLayoutVersion = 3,
        dropBrainrotKey = {kb = KB.DropBrainrot.kb and KB.DropBrainrot.kb.Name, gp = KB.DropBrainrot.gp and KB.DropBrainrot.gp.Name},
        autoLeftKey = {kb = KB.AutoLeft.kb and KB.AutoLeft.kb.Name, gp = KB.AutoLeft.gp and KB.AutoLeft.gp.Name},
        autoRightKey = {kb = KB.AutoRight.kb and KB.AutoRight.kb.Name, gp = KB.AutoRight.gp and KB.AutoRight.gp.Name},
        autoBatKey = {kb = KB.AutoBat.kb and KB.AutoBat.kb.Name, gp = KB.AutoBat.gp and KB.AutoBat.gp.Name},
        tpFloorKey = {kb = KB.TPFloor.kb and KB.TPFloor.kb.Name, gp = KB.TPFloor.gp and KB.TPFloor.gp.Name},
        carryToggleKey = {kb = KB.CarryToggle.kb and KB.CarryToggle.kb.Name, gp = KB.CarryToggle.gp and KB.CarryToggle.gp.Name},
        laggerModeKey = {kb = KB.LaggerMode.kb and KB.LaggerMode.kb.Name, gp = KB.LaggerMode.gp and KB.LaggerMode.gp.Name},
        instaResetKey = {kb = KB.InstaReset.kb and KB.InstaReset.kb.Name, gp = KB.InstaReset.gp and KB.InstaReset.gp.Name},
        antiBatKey = {kb = KB.AntiBat.kb and KB.AntiBat.kb.Name, gp = KB.AntiBat.gp and KB.AntiBat.gp.Name},
        bodyLockEnabled = bodyLockEnabled,
        bodyLockRange = bodyLockRange,
        progressBarPos = savedProgressBarPos,
        stealBarV2 = stealBarV2Enabled == true,
        lockUI = uiLocked,
        hideButtons = hideButtons,
        backgroundIndex = backgroundIndex,
        backgroundConfigVersion = 6,
        floatingButtonScale = floatingButtonScale,
        outfitConfigVersion = 6,
        independentHeadless = headlessIndependentEnabled,
        independentKorbloxRight = korbloxRightIndependentEnabled,
        katanaSkinEnabled = katanaSkinEnabled == true,
        useCarrySystem = useCarrySystem,
        carrySysNormal = CarrySystem.normalSpeed,
        carrySysCarry = CarrySystem.carrySpeed,
        carrySysLagger = CarrySystem.laggerSpeed,
        carrySysLaggerCarry = CarrySystem.laggerCarrySpeed,
    }
    if pbFrame then
        config.progressBarPos = {
            XScale = pbFrame.Position.X.Scale,
            XOffset = pbFrame.Position.X.Offset,
            YScale = pbFrame.Position.Y.Scale,
            YOffset = pbFrame.Position.Y.Offset
        }
    end
    if MobilePanel and MobilePanel:FindFirstChild("FloatingPanel") then
        local container = MobilePanel:FindFirstChild("FloatingPanel")
        config.mobilePanelPos = {
            XScale = container.Position.X.Scale,
            XOffset = container.Position.X.Offset,
            YScale = container.Position.Y.Scale,
            YOffset = container.Position.Y.Offset
        }
    end
    if main then
        local stable = savedMainPanelPos
        if type(stable) ~= "table" then
            stable = {
                XScale = main.Position.X.Scale,
                XOffset = main.Position.X.Offset,
                YScale = main.Position.Y.Scale,
                YOffset = main.Position.Y.Offset
            }
        end
        config.mainPanelPos = {
            XScale = tonumber(stable.XScale) or 0.5,
            XOffset = tonumber(stable.XOffset) or 0,
            YScale = tonumber(stable.YScale) or 0.5,
            YOffset = tonumber(stable.YOffset) or 0
        }
        config.mainPanelPosAnchor = "center-v1"
    end
    return config
end

function saveAllSettings()
    -- Durante la carga todavia existen las posiciones naturales de los botones;
    -- guardar en ese momento sobrescribe el JSON antes de restaurar la UI.
    if _isResetting or _isLoading then return true end
    local config = buildConfigTable()
    local json = HS:JSONEncode(config)
    if json == _lastSavedJSON then return true end
    local success, err = pcall(function() writefile(CONFIG_FILE, json) end)
    if success then _lastSavedJSON = json end
    return success
end

-- Guardado automatico periodico de estados, posiciones y valores.
do
    task.spawn(function()
        while task.wait(2.5) do
            if not _isLoading and not _isResetting then pcall(saveAllSettings) end
        end
    end)
end

function loadAllSettings()
    -- hzhub.json is intentionally a clean profile; old HZ/Fresh files are not imported.
    if not isfile or not isfile(CONFIG_FILE) then return false end
    local success, data = pcall(function() return HS:JSONDecode(readfile(CONFIG_FILE)) end)
    if not success or type(data) ~= "table" then return false end
    -- Perfil v5: descarta una sola vez el estado antiguo para volver a configurar
    -- desde los valores predeterminados; el guardado automático crea el perfil nuevo.
    if tonumber(data.configVersion) ~= 5 then return false end
    _isLoading = true
    -- Validar y acotar valores antes de usarlos en fisica/UI.
    local function positiveNumber(value, fallback, minValue, maxValue)
        value = tonumber(value)
        if not value or value ~= value then return fallback end
        return _clamp(value, minValue or 0.1, maxValue or 500)
    end
    NS = positiveNumber(data.normalSpeed, NS, 1, 500)
    CS = positiveNumber(data.carrySpeed, CS, 1, 500)
    LAGGER_SPEED = positiveNumber(data.laggerSpeed1, LAGGER_SPEED, 1, 500)
    LAGGER_CARRY_SPEED = positiveNumber(data.laggerSpeed2, LAGGER_CARRY_SPEED, 1, 500)
    CarrySystem:setNormalSpeed(NS)
    CarrySystem:setCarrySpeed(CS)
    CarrySystem:setLaggerSpeed(LAGGER_SPEED)
    CarrySystem:setLaggerCarrySpeed(LAGGER_CARRY_SPEED)
    CONFIG.STEAL_RANGE = _clamp(_floor(positiveNumber(data.stealRadius, CONFIG.STEAL_RANGE, 5, 300) + 0.5), 5, 300)
    if radInput then radInput.Text = tostring(CONFIG.STEAL_RANGE) end
    if data.lockUI ~= nil then
        uiLocked = data.lockUI == true
    end
    hideButtons = data.hideButtons == true
    applyHideButtonsVisibility()
    if data.ragdollTimerEnabled ~= nil then ragdollTimerEnabled = data.ragdollTimerEnabled == true end
    local savedAntiRagdollMode = type(data.antiRagdollMode) == "string" and string.lower(data.antiRagdollMode) or nil
    if data.antiRagdollEnabled ~= nil then
        antiRagdollMode = data.antiRagdollEnabled == true and "v2" or "off"
    elseif savedAntiRagdollMode == "v2" or savedAntiRagdollMode == "v1" then
        -- Migrar una preferencia V1 activa al único modo soportado: V2.
        antiRagdollMode = "v2"
    elseif savedAntiRagdollMode == "off" then
        antiRagdollMode = "off"
    elseif data.antiRagdoll ~= nil then
        antiRagdollMode = data.antiRagdoll == true and "v2" or "off"
    else
        antiRagdollMode = "off"
    end
    -- Respetar explícitamente true y false guardados; datos antiguos sin clave
    -- empiezan apagados para evitar que Anti Die se reactive inesperadamente.
    if data.antiDieEnabled ~= nil then
        antiDieEnabled = data.antiDieEnabled == true
    elseif data.antiDie ~= nil then
        antiDieEnabled = data.antiDie == true
    else
        antiDieEnabled = false
    end
    antiBatEnabled = data.antiBat == true or data.antiBatEnabled == true
    jumpEnabled = data.infiniteJump == true
    currentBatSkin = "Off"
    batSkinIndex = 1
    minecraftBatSkinEnabled = false
    minecraftBatSkinColorMode = "Default"
    if MinecraftBatSetVisual then MinecraftBatSetVisual(false) end
    MinecraftBatSkin.State.enabled = false
    MinecraftBatSkin.State.colorMode = "Default"
    pcall(MinecraftBatSkin.Remove)
    currentMedusaSkin = "Off"
    medusaSkinIndex = 1
    task.defer(function() pcall(setCustomSoundsEnabled, true) end)
    antiFlingEnabled = data.antiFlingEnabled or false
    CONFIG.AUTO_STEAL_ENABLED = data.autoSteal == true
    autoCarryEnabled = data.autoCarryEnabled == true
    medusaCounterEnabled = data.medusaCounter or false
    batCounterEnabled = data.batCounter or false
    unwalkEnabled = data.unwalk == true
    autoBatEnabled = data.autoBatEnabled == true
    autoLeftEnabled = data.autoLeftEnabled == true
    autoRightEnabled = data.autoRightEnabled == true
    antiLagEnabled = data.antiLag or false
    _sharedEnv.__FreshIntroState.Enabled = data.introMusicEnabled ~= false
    laggerToggled = data.laggerToggled or false
    speedMode = data.carryMode or false
    laggerCarryToggled = data.laggerCarryToggled or false

    local loadedUiScale = tonumber(data.uiScale)
    local scaleDefaultVersion = tonumber(data.uiScaleDefaultVersion) or 0
    if not loadedUiScale or loadedUiScale == 78 then
        loadedUiScale = 65
    elseif loadedUiScale == 85 and scaleDefaultVersion < 2 then
        -- 85 era el valor predeterminado anterior; llevarlo al nuevo 65.
        loadedUiScale = 65
    elseif loadedUiScale == 75 and data.uiScaleReadabilityVersion ~= 1 then
        loadedUiScale = 65
    end
    uiScaleValue = _clamp(loadedUiScale, 50, 150)
    if mainUIScale then mainUIScale.Scale = uiScaleValue / 100 end
    if pbScale then pbScale.Scale = 1 end
    espEnabled = data.espEnabled == true
    if espEnabled then toggleESP(true) else toggleESP(false) end
    xrayEnabled = data.xrayEnabled == true
    setXRayEnabled(xrayEnabled)
    if setXRayVisual then setXRayVisual(xrayEnabled) end
    xrayBrainrotEnabled = data.xrayBrainrotEnabled == true
    _G.FreshHubSetBrainrotXRay(xrayBrainrotEnabled)
    if setXRayBrainrotVisual then setXRayBrainrotVisual(xrayBrainrotEnabled) end
    neonWeatherEnabled = data.neonWeather == true
    vividGraphicsEnabled = false -- Retired graphics toggle; ignore the legacy saved value.
    if vividGraphicsEnabled and neonWeatherEnabled then neonWeatherEnabled = false end
    if neonWeatherEnabled then
        task.defer(function() toggleNeonWeather(true) end)
    else
        toggleNeonWeather(false)
    end
    vividGraphicsEnabled = false
    disableVividGraphics()
    local savedSkyMode = data.skyMode
    if savedSkyMode == "Moonlight" then savedSkyMode = "Blood Moon" end
    if savedSkyMode == "Tech" then savedSkyMode = "Cyber" end
    skyMode = SKY_PRESETS[savedSkyMode] and savedSkyMode or "Night"
    skyEnabled = data.skyEnabled == true and skyMode ~= "Off"
    if skyModeBtnRef then skyModeBtnRef.Text = skyMode end
    if data.animPack and ANIM_PACKS[data.animPack] then
        startAnimPack(data.animPack)
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
    lk(KB.CarryToggle, data.carryToggleKey)
    lk(KB.LaggerMode, data.laggerModeKey)
    lk(KB.InstaReset, data.instaResetKey)
    lk(KB.AntiBat, data.antiBatKey)
    if data.atbDockLayoutVersion ~= 3 then
        savedButtonPositions = {}
        savedMobilePanelPos = nil
    elseif data.mobileButtonPositions then
        savedButtonPositions = data.mobileButtonPositions
    end
    if data.mobilePanelPos and data.atbDockLayoutVersion == 3 then savedMobilePanelPos = data.mobilePanelPos end
    if data.mainPanelPos then
        local pos = data.mainPanelPos
        if data.mainPanelPosAnchor ~= "center-v1" then
            -- Migrar la coordenada de borde izquierdo usada por versiones anteriores
            -- a la coordenada central del nuevo panel, conservando la ubicación visual.
            savedMainPanelPos = {
                XScale = tonumber(pos.XScale) or 0,
                XOffset = (tonumber(pos.XOffset) or 0) + 210,
                YScale = tonumber(pos.YScale) or 0.5,
                YOffset = tonumber(pos.YOffset) or 0,
            }
        else
            savedMainPanelPos = pos
        end
    end
    if data.progressBarPos then savedProgressBarPos = data.progressBarPos end
    stealBarV2Enabled = data.stealBarV2 == true
    if stealBarVersionSelector then stealBarVersionSelector.Text = stealBarV2Enabled and "Cute" or "Original" end
    if type(applyStealBarStyle) == "function" then applyStealBarStyle() end
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
        bodyLockRange = _clamp(_floor(positiveNumber(data.bodyLockRange, bodyLockRange, 5, 200) + 0.5), 5, 200)
        if bodyLockRangeBox then bodyLockRangeBox.Text = tostring(bodyLockRange) end
    end
    dropMode = 2
    stretchEnabled = data.stretchEnabled == true
    fovValue = _clamp(_floor(positiveNumber(data.fovValue, 70, 20, 120) + 0.5), 20, 120)
    fovEnabled = data.fovEnabled or false
    if fovSliderSet then fovSliderSet(fovValue) end
    if fovEnabled then enableCustomFov() end
    if setFovVisual then setFovVisual(fovEnabled) end
    stretchFOV = _clamp(_floor(positiveNumber(data.stretchFOV, 120, 20, 180) + 0.5), 20, 180)
    local savedAimbotSpeed = positiveNumber(data.batAimbotSpeed, BAT_AIMBOT_SPEED, 1, 200)
    if savedAimbotSpeed == 78 then savedAimbotSpeed = 58 end -- migracion del default anterior
    BAT_AIMBOT_SPEED = _clamp(_floor(savedAimbotSpeed + 0.5), 1, 200)
    -- Las configuraciones antiguas pueden guardar V2; este script ya solo usa V1.
    BAT_AIMBOT_VERSION = 1
    _sharedEnv.__FreshHubAimbotVersion = 1
    AUTO_SWING_ENABLED = data.autoSwingEnabled ~= false
    if autoSwingSetVisual then autoSwingSetVisual(AUTO_SWING_ENABLED) end
    local savedBackgroundIndex = tonumber(data.backgroundIndex)
    local savedBackgroundConfigVersion = tonumber(data.backgroundConfigVersion) or 1
    if savedBackgroundIndex then
        if savedBackgroundConfigVersion < 4 then
            -- Las versiones antiguas usaban índices distintos; iniciar en Background 1.
            savedBackgroundIndex = 1
        elseif savedBackgroundConfigVersion < 5 then
            -- En v4: 1=Background 1, 2=Background 2, 3-5=Backgrounds 3-5.
            savedBackgroundIndex = math.max(1, savedBackgroundIndex - 1)
        end
    end
    backgroundIndex = savedBackgroundIndex and math.max(1, math.min(#_freshBackgroundImages, math.floor(savedBackgroundIndex))) or 1
    setPanelBackground(backgroundIndex)
    floatingButtonScale = 1
    headlessIndependentEnabled = data.independentHeadless == true
    korbloxRightIndependentEnabled = data.independentKorbloxRight == true
    if headlessIndependentSetVisual then pcall(headlessIndependentSetVisual, headlessIndependentEnabled) end
    if korbloxRightIndependentSetVisual then pcall(korbloxRightIndependentSetVisual, korbloxRightIndependentEnabled) end
    syncIndependentCosmeticSelector()
    katanaSkinEnabled = data.katanaSkinEnabled == true
    if katanaSkinSetVisual then pcall(katanaSkinSetVisual, katanaSkinEnabled) end
    if katanaSkinEnabled and LP.Character then task.defer(function() if LP.Character then pcall(applyKatanaSkin, LP.Character) end end) end
    currentOutfitIndex = 1

    useCarrySystem = data.useCarrySystem == true
    CarrySystem.normalSpeed = data.carrySysNormal or NS
    CarrySystem.carrySpeed = data.carrySysCarry or CS
    CarrySystem.laggerSpeed = data.carrySysLagger or LAGGER_SPEED
    CarrySystem.laggerCarrySpeed = data.carrySysLaggerCarry or LAGGER_CARRY_SPEED
    if useCarrySystem then
        CarrySystem:start()
        CarrySystem.speedToggled = speedMode
        if laggerCarryToggled then
            CarrySystem:setLaggerMode(2)
        elseif laggerToggled then
            CarrySystem:setLaggerMode(1)
        else
            CarrySystem:setLaggerMode(0)
        end
    else
        CarrySystem:stop()
    end
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
    if bodyLockRangeBox then bodyLockRangeBox.Text = tostring(bodyLockRange) end
    if carrySysNormalBox then carrySysNormalBox.Text = tostring(CarrySystem.normalSpeed) end
    if carrySysCarryBox then carrySysCarryBox.Text = tostring(CarrySystem.carrySpeed) end
    if carrySysLaggerBox then carrySysLaggerBox.Text = tostring(CarrySystem.laggerSpeed) end
    if carrySysLaggerCarryBox then carrySysLaggerCarryBox.Text = tostring(CarrySystem.laggerCarrySpeed) end
    if carrySystemToggleSetter then carrySystemToggleSetter(useCarrySystem) end
    local function safeSet(fn, val) if fn then fn(val) end end
    safeSet(autoBatSetVisual, false)
    safeSet(autoSwingSetVisual, false)
    safeSet(autoLeftSetVisual, false)
    safeSet(autoRightSetVisual, false)
    safeSet(setBatCounterVisual, false)
    safeSet(setMedusaVisual, false)
    safeSet(customSoundsSetVisual, false)
    safeSet(setXRayVisual, false)
    safeSet(setJumpVisual, false)
    safeSet(setUnwalkVisual, false)
    safeSet(setAntiLagVisual, false)
    safeSet(setLockUIVisual, false)
    safeSet(setHideButtonsVisual, false)
    safeSet(setInstaGrab, false)
    safeSet(setESPVIsual, false)
    safeSet(bodyLockSetVisual, false)
    safeSet(setNeonWeatherVisual, false)
    disableVividGraphics()
    safeSet(setAntiDieVisual, false)
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
    toggleNeonWeather(false)
    if antiDieEnabled then
        AntiDieModule.stop()
        antiDieEnabled = false
    end
    if antiFlingEnabled then
        AntiFlingShieldModule.stop()
        antiFlingEnabled = false
    end
    jumpEnabled = false
    InfiniteJump.stop()
    currentBatSkin = "Off"
    batSkinIndex = 1
    minecraftBatSkinEnabled = false
    minecraftBatSkinColorMode = "Default"
    MinecraftBatSkin.State.enabled = false
    MinecraftBatSkin.State.colorMode = "Default"
    pcall(MinecraftBatSkin.Remove)
    if MinecraftBatSetVisual then MinecraftBatSetVisual(false) end
    currentMedusaSkin = "Off"
    medusaSkinIndex = 1
    applyBatSkinToCharacter()
    setCustomSoundsEnabled(true)
    setXRayEnabled(false)
    _G.FreshHubSetBrainrotXRay(false)
    hideButtons = false
    applyHideButtonsVisibility()
    for _, ref in ipairs(keyButtonRefs) do
        local entry = ref.entry
        local label = (entry.gp and entry.gp.Name) or (entry.kb and entry.kb.Name) or "None"
        ref.btn.Text = label
    end
    updateAllUIColors(selectedColor)
    if miniBtn and miniBtn:IsA("TextButton") then
        miniBtn.TextColor3 = themePalette.accentText
    end
    local pGui = LP:FindFirstChild("PlayerGui")
    if pGui then
        local bb = pGui:FindFirstChild("RagCountdownBillboard")
        if bb then
            local lbl = bb:FindFirstChildOfClass("TextLabel")
            if lbl then lbl.TextColor3 = themePalette.mutedText end
        end
    end
    if MobilePanel then
        local container = MobilePanel:FindFirstChild("FloatingPanel")
        if container then
            local btnContainer = container:FindFirstChild("ButtonsContainer")
            if btnContainer then
                for _, btn in ipairs(btnContainer:GetChildren()) do
                    if btn:IsA("TextButton") then
                        local label = btn:FindFirstChildOfClass("TextLabel")
                        if label then
                            local isActive = btn:GetAttribute("MobActive") == true
                            label.TextColor3 = isActive and themePalette.buttonActiveText or themePalette.buttonText
                        end
                    end
                end
            end
        end
    end
    saveAllSettings()
end

function resetFloatingPositions()
    -- Estas dimensiones deben existir tambien fuera de createMobilePanel.
    local BTN_W, BTN_H = 60, 60
    local GAP = 8
    local COLUMNS, ROWS = 2, 5
    local PANEL_W = BTN_W * COLUMNS + GAP * (COLUMNS - 1)
    local PANEL_H = BTN_H * ROWS + (GAP + 10) * (ROWS - 1)

    if MobilePanel and MobilePanel:FindFirstChild("FloatingPanel") then
        local container = MobilePanel:FindFirstChild("FloatingPanel")
        container.Position = UDim2.new(1, -(PANEL_W + 12), 0.5, -PANEL_H / 2)
        savedButtonPositions = {}
        local btnContainer = container:FindFirstChild("ButtonsContainer")
        if btnContainer then
            for _, btn in ipairs(btnContainer:GetChildren()) do
                if btn:IsA("TextButton") and btn.Name then
                    local defX, defY = getDefaultButtonPosition(btn.Name)
                    btn.Position = UDim2.new(0, defX, 0, defY)
                    btn.Size = UDim2.new(0, BTN_W, 0, BTN_H)
                end
            end
        end
    end
    if pbFrame then
        pbFrame.Position = UDim2.new(0.5, -215, 1, -106)
        savedProgressBarPos = nil
    end
    savedMobilePanelPos = nil
    pcall(saveAllSettings)
end

function resetToFactoryDefaults()
    _isResetting = true
    local ok, err = pcall(function()
        stopAllBackgroundTasks()
        stopAutoSteal()
        stopBatCounter()
        stopMedusaCounter()
        if AntiRagdollV2.Enabled then stopAntiRagdollV2() end
        if antiDieEnabled then AntiDieModule.stop() end
        if antiFlingEnabled then AntiFlingShieldModule.stop() end
        stopUnwalk()
        disableAutoBat()
        stopBodyLock()
        if espEnabled then toggleESP(false) end
        if stretchEnabled then disableStretch() end
        if antiLagEnabled then disableAntiLag() end
            if dropActive then stopDropBrainrot() end
        disableVividGraphics()
        vividGraphicsEnabled = false
        toggleNeonWeather(false)
        AntiDieModule.stop()
        antiDieEnabled = false
        if antiFlingEnabled then
            AntiFlingShieldModule.stop()
            antiFlingEnabled = false
        end
        NS = 60
        CS = 29
        LAGGER_SPEED = 15
        LAGGER_CARRY_SPEED = 24.5
        CONFIG.STEAL_RANGE = 61
        speedMode = false
        autoCarryEnabled = false
        if autoCarrySetVisual then autoCarrySetVisual(false) end
        laggerToggled = false
        laggerCarryToggled = false
        antiRagdollMode = "off"
        if _G.updateAntiRagdollUI then _G.updateAntiRagdollUI(false) end
        antiDieEnabled = false
        antiBatEnabled = false
        antiFlingEnabled = false
        skyEnabled = false
        skyMode = "Off"
        if _sharedEnv.__FreshRestoreSkyLighting then pcall(_sharedEnv.__FreshRestoreSkyLighting) end
        if skySetVisual then pcall(skySetVisual, false) end
        if skyModeBtnRef then skyModeBtnRef.Text = "Off" end
        jumpEnabled = false
        currentBatSkin = "Off"
        batSkinIndex = 1
        minecraftBatSkinEnabled = false
        minecraftBatSkinColorMode = "Default"
        MinecraftBatSkin.State.enabled = false
        MinecraftBatSkin.State.colorMode = "Default"
        pcall(MinecraftBatSkin.Remove)
        currentMedusaSkin = "Off"
        medusaSkinIndex = 1
        hideButtons = false
        medusaCounterEnabled = false
        batCounterEnabled = false
        autoBatEnabled = false
                autoLeftEnabled = false
        autoRightEnabled = false
        unwalkEnabled = false
        antiLagEnabled = false
                uiLocked = true
        CONFIG.AUTO_STEAL_ENABLED = false
        BAT_AIMBOT_SPEED = 58
        BAT_AIMBOT_VERSION = 1
        dropMode = 2
        stretchEnabled = false
        stretchFOV = 120
        fovValue = 70
        disableCustomFov()
        if fovSliderSet then fovSliderSet(70) end
        if setFovVisual then setFovVisual(false) end
        uiScaleValue = 65
        if mainUIScale then mainUIScale.Scale = uiScaleValue / 100 end
        if pbScale then pbScale.Scale = 1 end
        espEnabled = false
        bodyLockEnabled = false
        bodyLockRange = 20
        backgroundIndex = 1
        setPanelBackground(1)
        stealBarV2Enabled = false
        if stealBarVersionSelector then stealBarVersionSelector.Text = "Original" end
        if type(applyStealBarStyle) == "function" then applyStealBarStyle() end
        floatingButtonScale = 1
        currentAnimPack = "Off"
        stopAnimPack()
        currentOutfitIndex = 1
        headlessIndependentEnabled = false
        korbloxRightIndependentEnabled = false
        katanaSkinEnabled = false
        if katanaSkinSetVisual then pcall(katanaSkinSetVisual, false) end
        syncIndependentCosmeticSelector()
        if LP.Character then removeKatanaSkin(LP.Character); clearIndependentAppearance(LP.Character) end
        if headlessIndependentSetVisual then pcall(headlessIndependentSetVisual, false) end
        if korbloxRightIndependentSetVisual then pcall(korbloxRightIndependentSetVisual, false) end
        for key, val in pairs(DEFAULT_KB) do
            if KB[key] then
                KB[key].kb = val.kb
                KB[key].gp = val.gp
            end
        end
        useCarrySystem = false
        CarrySystem:stop()
        CarrySystem.normalSpeed = NS
        CarrySystem.carrySpeed = CS
        CarrySystem.laggerSpeed = LAGGER_SPEED
        CarrySystem.laggerCarrySpeed = LAGGER_CARRY_SPEED
        CarrySystem.softStealSpeed = 30
        CarrySystem.softStealRadius = 10
        CarrySystem.speedToggled = false
        CarrySystem.laggerMode = 0
        CarrySystem.softStealEnabled = false
        CarrySystem.softStealLatched = false
        if isfile then
            if isfile(CONFIG_FILE) then pcall(delfile, CONFIG_FILE) end
            if isfile("HZ_Hub_Config_v3.json") then pcall(delfile, "HZ_Hub_Config_v3.json") end
            if isfile("HZ_Hub_Config_v2.json") then pcall(delfile, "HZ_Hub_Config_v2.json") end
            if isfile("HZ_Hub_Config.json") then pcall(delfile, "HZ_Hub_Config.json") end
            if isfile("Fresh_Config.json") then pcall(delfile, "Fresh_Config.json") end
        end
        resetFloatingPositions()
        savedMainPanelPos = nil
        if main then main.Position = UDim2.new(0.5, 0, 0.5, 0) end
        forceResetUI()
        updateProgressBarVisibility()
        refreshSpeedModeLabel()
        _lastSavedJSON = nil
        saveAllSettings()
    end)
    _isResetting = false
    if not ok then warn("[resetToFactoryDefaults]", err) end
    return ok
end

function updateProgressBarVisibility()
    -- Barra Auto Grab azul; visible solo durante Auto Steal o un robo activo.
    if pbFrame then
        pbFrame.Visible = (Steal and Steal.AutoStealEnabled == true) or isStealing == true
    end
end

function getDefaultButtonPosition(btnName)
    local BTN_W, BTN_H = 60, 60
    local GAP = 8
    -- Insta Reset queda inmediatamente a la izquierda de DropBR, en la fila superior.
    if btnName == "InstaReset" then return -BTN_W - GAP, 0 end
    local orderMap = {
        DropBR = 0, AutoLeft = 1, AutoBat = 2, AutoRight = 3,
        TpDown = 4, Carry = 5, Lagger1 = 6, Lagger2 = 7,
    }
    local order = orderMap[btnName] or 0
    local row = _floor(order / 2)
    local col = order % 2
    return col * (BTN_W + GAP), row * (BTN_H + GAP + 10)
end

-- Insta Reset Clean: bloque aislado, sin inicializadores globales ni loops extra.
local _cleanReset = {
    busy = false,
    thread = nil,
    stop = false,
    lastRequest = 0,
}

function performFreshInstaReset()
    local now = os.clock()
    if _cleanReset.busy or now - _cleanReset.lastRequest < 0.75 then return false end
    _cleanReset.lastRequest = now

    local character = LP and LP.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    if not character or not humanoid or humanoid.Health <= 0 then return false end

    _cleanReset.busy = true
    _cleanReset.stop = false
    local resetCharacter = character
    local resetHumanoid = humanoid

    _cleanReset.thread = task.spawn(function()
        local originalHipHeight = resetHumanoid.HipHeight
        local attempts = 0
        local success = false

        while resetCharacter.Parent and resetHumanoid.Health > 0
              and LP.Character == resetCharacter and not _cleanReset.stop do
            pcall(function()
                resetHumanoid.HipHeight = 1e30
                resetHumanoid.AutoRotate = true
                local root = resetCharacter:FindFirstChild("HumanoidRootPart")
                if root then root.CanCollide = false end
                for _, part in ipairs(resetCharacter:GetChildren()) do
                    if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                        part.CanCollide = false
                    end
                end
            end)
            attempts = attempts + 1
            if attempts >= 40 then break end
            task.wait(0.05)
        end

        if not _cleanReset.stop and resetCharacter.Parent
           and resetHumanoid.Health > 0 and LP.Character == resetCharacter then
            pcall(function() resetHumanoid.Health = 0 end)
            task.wait(0.1)
            success = not resetCharacter.Parent or resetHumanoid.Health <= 0
        else
            success = not resetCharacter.Parent or resetHumanoid.Health <= 0
        end

        if not success and resetCharacter.Parent and resetHumanoid.Health > 0 then
            pcall(function()
                resetHumanoid.HipHeight = originalHipHeight
                local root = resetCharacter:FindFirstChild("HumanoidRootPart")
                if root then root.CanCollide = true end
                for _, part in ipairs(resetCharacter:GetChildren()) do
                    if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                        part.CanCollide = true
                    end
                end
            end)
        end
        _cleanReset.busy = false
        _cleanReset.thread = nil
        _cleanReset.stop = false
    end)
    return true
end

LP.CharacterAdded:Connect(function()
    _cleanReset.stop = true
    if _cleanReset.thread then pcall(task.cancel, _cleanReset.thread) end
    _cleanReset.thread = nil
    _cleanReset.busy = false
end)

function updateUIFromLoaded()
    task.wait()
    if normalBox then normalBox.Text = tostring(NS) end
    if carryBox then carryBox.Text = tostring(CS) end
    if radInput then radInput.Text = tostring(CONFIG.STEAL_RANGE) end
    if laggerBox then laggerBox.Text = tostring(LAGGER_SPEED) end
    if lagger2Box then lagger2Box.Text = tostring(LAGGER_CARRY_SPEED) end
    if batSpeedBox then batSpeedBox.Text = tostring(BAT_AIMBOT_SPEED) end
    if uiScaleBox then uiScaleBox.Text = tostring(uiScaleValue) end
    if bodyLockRangeBox then bodyLockRangeBox.Text = tostring(bodyLockRange) end
    if carrySysNormalBox then carrySysNormalBox.Text = tostring(CarrySystem.normalSpeed) end
    if carrySysCarryBox then carrySysCarryBox.Text = tostring(CarrySystem.carrySpeed) end
    if carrySysLaggerBox then carrySysLaggerBox.Text = tostring(CarrySystem.laggerSpeed) end
    if carrySysLaggerCarryBox then carrySysLaggerCarryBox.Text = tostring(CarrySystem.laggerCarrySpeed) end
    if carrySystemToggleSetter then carrySystemToggleSetter(useCarrySystem) end
    refreshSpeedModeLabel()

    for _, ref in ipairs(keyButtonRefs) do
        local entry = ref.entry
        local label = (entry.gp and entry.gp.Name) or (entry.kb and entry.kb.Name) or "None"
        ref.btn.Text = label
    end

    if savedProgressBarPos and pbFrame then
        local xScale = tonumber(savedProgressBarPos.XScale) or 0.5
        local xOffset = tonumber(savedProgressBarPos.XOffset) or -215
        local yScale = tonumber(savedProgressBarPos.YScale) or 1
        local yOffset = tonumber(savedProgressBarPos.YOffset) or -106
        local centered = math.abs(xScale - 0.5) < 0.001 and math.abs(yScale - 1) < 0.001
        local isKnownDefault = centered and (
            (xOffset == -184 and yOffset == -58) or
            (xOffset == -160 and yOffset == -58) or
            (xOffset == -140 and yOffset == -62) or
            (xOffset == -140 and yOffset == -80) or
            (xOffset == -190 and yOffset == -56) or
            (xOffset == -120 and yOffset == -46) or
            (xOffset == -186 and yOffset == -134) or
            (xOffset == -220 and yOffset == -124) or
            (xOffset == -325 and yOffset == -150) or
            (xOffset == -220 and yOffset == -104) or
            (xOffset == -110 and yOffset == -52) or
            (xOffset == -170 and yOffset == -104) or
            (xOffset == -180 and yOffset == -132) or
            (xOffset == -210 and yOffset == -124) or
            (xOffset == -215 and yOffset == -106)
        )
        if not isKnownDefault then
            pbFrame.Position = UDim2.new(xScale, xOffset, yScale, yOffset)
        end
    end
    if savedMainPanelPos and main then
        local sx = tonumber(savedMainPanelPos.XScale) or 0.5
        local sy = tonumber(savedMainPanelPos.YScale) or 0.5
        local ox = tonumber(savedMainPanelPos.XOffset) or 0
        local oy = tonumber(savedMainPanelPos.YOffset) or 0
        -- Versiones anteriores podían guardar el punto fuera de pantalla usado
        -- por hideGui. En ese caso se recupera al centro y se vuelve a guardar.
        local wasMinimizedOffscreen = (sx == 0 and ox < -120) or (sy == 0 and oy < -120)
        if wasMinimizedOffscreen or (sx == 0.5 and ox == 0 and sy == 0.5 and oy == 0) then
            sx, ox, sy, oy = 0.5, 0, 0.5, 0
            savedMainPanelPos = {XScale = sx, XOffset = ox, YScale = sy, YOffset = oy}
        end
        main.Position = UDim2.new(sx, ox, sy, oy)
    else
        main.Position = UDim2.new(0.5, 0, 0.5, 0)
        savedMainPanelPos = {XScale = 0.5, XOffset = 0, YScale = 0.5, YOffset = 0}
    end
    main.Visible = false
    if miniBtn then miniBtn.Visible = false end
    -- Los controles se crean antes de cargar el JSON; aplicar sus posiciones aqui tambien.
    if MobilePanel then
        local container = MobilePanel:FindFirstChild("FloatingPanel")
        if container then
            if savedMobilePanelPos then
                container.Position = UDim2.new(
                    savedMobilePanelPos.XScale or 0,
                    savedMobilePanelPos.XOffset or -140,
                    savedMobilePanelPos.YScale or 0.5,
                    savedMobilePanelPos.YOffset or -160
                )
            end
            local buttonsContainer = container:FindFirstChild("ButtonsContainer")
            if buttonsContainer and type(savedButtonPositions) == "table" then
                for _, button in ipairs(buttonsContainer:GetChildren()) do
                    local saved = savedButtonPositions[button.Name]
                    if button:IsA("TextButton") and type(saved) == "table" then
                        button.Position = UDim2.new(0, tonumber(saved.X) or button.Position.X.Offset, 0, tonumber(saved.Y) or button.Position.Y.Offset)
                    end
                end
            end
        end
    end

    local bgImg = main and main:FindFirstChild("BackgroundImage")
    if bgImg then setPanelBackground(backgroundIndex) end
    if pbBackgroundImage then
        pbBackgroundImage.Image = ""
        pbBackgroundImage.ImageTransparency = 1
        pbBackgroundImage.Visible = false
    end
    if pbShade then
        pbShade.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        pbShade.BackgroundTransparency = 0.56
        pbShade.Visible = false
    end

    applyFloatingButtonScale()

    if uiLocked and setLockUIVisual then setLockUIVisual(true) end

    if _G.updateAntiRagdollUI then _G.updateAntiRagdollUI(antiRagdollMode == "v2") end
    if ragdollTimerSetVisual then ragdollTimerSetVisual(ragdollTimerEnabled) end
    if antiRagdollMode == "v2" then startAntiRagdollV2() end

    if jumpEnabled then
        InfiniteJump.start()
        if setJumpVisual then setJumpVisual(true) end
    else
        InfiniteJump.stop()
        if setJumpVisual then setJumpVisual(false) end
    end
    syncIndependentCosmeticSelector()
    applyBatSkinToCharacter()

    if antiDieEnabled then
        if setAntiDieVisual then setAntiDieVisual(true) end
        AntiDieModule.start()
    else
        if setAntiDieVisual then setAntiDieVisual(false) end
    end

    if antiBatEnabled then
        startAntiBat()
    else
        stopAntiBat()
    end
    if setAntiBatVisual then setAntiBatVisual(antiBatEnabled) end

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

    if neonWeatherEnabled then
        applyNeonWeather()
        if setNeonWeatherVisual then setNeonWeatherVisual(true) end
    else
        restoreLightingState()
        if setNeonWeatherVisual then setNeonWeatherVisual(false) end
    end
    vividGraphicsEnabled = false
    disableVividGraphics()

    if stretchEnabled then
        enableStretch()
        if _G.stretchToggleSetter then _G.stretchToggleSetter(true) end
    else
        if _G.stretchToggleSetter then _G.stretchToggleSetter(false) end
    end

    if setFovVisual then setFovVisual(fovEnabled) end
    if fovSliderSet then fovSliderSet(fovValue) end

    if autoBatEnabled then pcall(startAimbotAdapt) end
    if autoLeftEnabled then pcall(startAutoLeft) end
    if autoRightEnabled then pcall(startAutoRight) end
    if unwalkEnabled then pcall(startUnwalk) end
    if mobSetAutoBat then mobSetAutoBat(autoBatEnabled) end
    if mobSetAutoLeft then mobSetAutoLeft(autoLeftEnabled) end
    if mobSetAutoRight then mobSetAutoRight(autoRightEnabled) end
    if mobSetCarry then mobSetCarry(speedMode) end
    if mobSetLagger1 then mobSetLagger1(laggerToggled) end
    if mobSetLagger2 then mobSetLagger2(laggerCarryToggled) end

    if bodyLockEnabled and bodyLockSetVisual then
        bodyLockSetVisual(true)
        if not _bodyLockConn then startBodyLock() end
    end

    -- Los setters solo pintan el control; no vuelven a ejecutar sus callbacks.
    local function syncToggle(setter, state)
        if setter then pcall(setter, state == true) end
    end
    syncToggle(autoBatSetVisual, autoBatEnabled)
    syncToggle(autoLeftSetVisual, autoLeftEnabled)
    syncToggle(autoRightSetVisual, autoRightEnabled)
    syncToggle(autoSwingSetVisual, AUTO_SWING_ENABLED)
    syncToggle(autoCarrySetVisual, autoCarryEnabled)
    syncToggle(setAntiBatVisual, antiBatEnabled)
    syncToggle(setJumpVisual, jumpEnabled)
    syncToggle(setUnwalkVisual, unwalkEnabled)
    syncToggle(setAntiDieVisual, antiDieEnabled)
    syncToggle(dropBrainrotSetVisual, dropActive)
    syncToggle(setBatCounterVisual, batCounterEnabled)
    syncToggle(setMedusaVisual, medusaCounterEnabled)
    syncToggle(bodyLockSetVisual, bodyLockEnabled)
    syncToggle(setInstaGrab, CONFIG.AUTO_STEAL_ENABLED)
    syncToggle(setXRayVisual, xrayEnabled)
    syncToggle(setXRayBrainrotVisual, xrayBrainrotEnabled)
    syncIndependentCosmeticSelector()
    syncToggle(setESPVIsual, espEnabled)
    syncToggle(setFovVisual, fovEnabled)
    syncToggle(setAntiLagVisual, antiLagEnabled)
    syncToggle(setFreshIntroVisual, _sharedEnv.__FreshIntroState.Enabled)
    syncToggle(skySetVisual, skyEnabled)
    syncToggle(setNeonWeatherVisual, neonWeatherEnabled)
    syncToggle(setLockUIVisual, uiLocked)
    syncToggle(setHideButtonsVisual, hideButtons)

    updateProgressBarVisibility()
    startEnemySpeed()

    toggleLockUI(uiLocked)


end

-- Restore configuration without saving partial values during startup.
_isLoading = true

-- ============================================================
-- 21. ARRANQUE Y EVENTOS FINALES
-- ============================================================
_freshBootOK, _freshBootError = pcall(function()
    buildGui()
    MobilePanel = createMobilePanel()
    if setHideButtonsVisual then setHideButtonsVisual(hideButtons) end
    applyHideButtonsVisibility()
    updateAllUIColors(selectedColor)
end)

if not _freshBootOK then
    warn("[HZ HUB] Fallo el arranque de la interfaz: " .. tostring(_freshBootError))
    return
end

_sharedEnv[_freshBuildKey] = true
if miniBtn then miniBtn.Visible = false end

task.defer(function()
    -- Restore settings and initialize required services before revealing the panel.
    local ok, err = pcall(function()
        pcall(setCustomSoundsEnabled, true)
        if LP.Character then pcall(removeRetiredLocalAccessory, LP.Character) end
        local loaded = false
        pcall(function() loaded = loadAllSettings() == true end)
        if not loaded then _isLoading = false end
        if loaded then pcall(updateUIFromLoaded) end
        pcall(updateAllUIColors, selectedColor)
        if _sharedEnv.__FreshIntroState.Enabled then pcall(_sharedEnv.__FreshPlayIntro) else pcall(_sharedEnv.__FreshStopIntro) end
        if LP.Character then
            local appearanceCharacter = LP.Character
            task.spawn(function()
                if not waitForCharReady(appearanceCharacter, 5) or LP.Character ~= appearanceCharacter then return end
                if headlessIndependentEnabled or korbloxRightIndependentEnabled then
                    pcall(applyIndependentAppearance, appearanceCharacter)
                    pcall(bindAppearanceRecovery, appearanceCharacter)
                else
                    pcall(clearIndependentAppearance, appearanceCharacter)
                end
                if katanaSkinEnabled then pcall(applyKatanaSkin, appearanceCharacter) end
            end)
        end
        if skyEnabled then task.defer(function() pcall(applyFreshSky, skyMode) end) end
        if useCarrySystem then
            CarrySystem:start()
            CarrySystem.speedToggled = speedMode
            if laggerCarryToggled then
                CarrySystem:setLaggerMode(2)
            elseif laggerToggled then
                CarrySystem:setLaggerMode(1)
            else
                CarrySystem:setLaggerMode(0)
            end
        end
    end)
    if not ok then warn("[HZ HUB] Error al terminar la carga: " .. tostring(err)) end
    if main and main.Parent then
        main.Visible = true
        panelOpen = true
    end
    if miniBtn then miniBtn.Visible = false end
end)

-- Fase 3: el personaje se prepara cooperativamente, sin congelar el hilo principal.
task.defer(function()
    if not LP.Character then return end
    local initialCharacter = LP.Character
    if not waitForCharReady(initialCharacter, 5) then return end
    setupMovementAndIndicators(initialCharacter)
    if currentAnimPack ~= "Off" then
        task.defer(function() pcall(startAnimPack, currentAnimPack) end)
    end
end)

-- Se guarda en el entorno compartido para no exceder el limite de registros locales
-- de la funcion principal, que contiene gran parte del script.
_sharedEnv.__FreshHubRespawnQueue = 0

LP.CharacterAdded:Connect(function(char)
    _sharedEnv.__FreshHubRespawnQueue = _sharedEnv.__FreshHubRespawnQueue + 1
    local myId = _sharedEnv.__FreshHubRespawnQueue

    if stealConnection then stealConnection:Disconnect(); stealConnection = nil end
    isStealing = false
    stopAutoLeft()
    stopAutoRight()
    stopBatCounter()
    stopMedusaCounter()
    stopUnwalk()
    stopDropBrainrot()
    if autoBatEnabled then disableAutoBat() end
    if bodyLockEnabled then stopBodyLock() end

    -- Espera por eventos de insercion, en vez de sondear cada 50 ms.
    if not waitForCharReady(char, 5) or myId ~= _sharedEnv.__FreshHubRespawnQueue then return end

    pcall(reapplySelectedCharacterCosmetics, char)
    pcall(bindAppearanceRecovery, char)
    _hookedVelParts = {}
    local _hrpRespawn = _setupVelChecked(char)
    _hookVelHRP(_hrpRespawn)

    setupMovementAndIndicators(char)
    pcall(applyNoPlayerCollisionToCharacter, char)
    if bodyLockEnabled then
        if not _bodyLockConn then startBodyLock() end
        if bodyLockSetVisual then bodyLockSetVisual(true) end
    end
    if antiBatEnabled then startAntiBat() else stopAntiBat() end

    if antiRagdollMode == "v2" then startAntiRagdollV2() end

    if AntiDieModule.enabled then task.defer(function() activateOnCharacter(char) end) end
    if CONFIG.AUTO_STEAL_ENABLED then pcall(startAutoSteal) end

    if batCounterEnabled then startBatCounter() end
    if unwalkEnabled then startUnwalk() end

    if currentAnimPack ~= "Off" then
        task.wait(0.3)
        startAnimPack(currentAnimPack)
    end

    updateProgressBarVisibility()
    refreshSpeedModeLabel()

end)

-- Guardar el cooldown en el entorno compartido evita consumir registros locales
-- en el chunk raiz, que ya esta cerca del limite de Luau.
_sharedEnv.__FreshLastLaggerToggle = tonumber(_sharedEnv.__FreshLastLaggerToggle) or 0

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

    if kbMatch(KB.InstaReset, kc) then
        performFreshInstaReset()
        return
    end
    if kbMatch(KB.AntiBat, kc) then
        if antiBatEnabled then stopAntiBat() else startAntiBat() end
        if setAntiBatVisual then setAntiBatVisual(antiBatEnabled) end
        saveAllSettings()
        return
    end

    if kbMatch(KB.LaggerMode, kc) then
        if _tick() - _sharedEnv.__FreshLastLaggerToggle >= 0.3 then
            _sharedEnv.__FreshLastLaggerToggle = _tick()
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
    if kbMatch(KB.GuiHide, kc) then
        if main then
            -- Alternar el destino solicitado, no la visibilidad intermedia de un tween.
            if panelOpen then hideGui() else showGui() end
        end
        return
    end
end)