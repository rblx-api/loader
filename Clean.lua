local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local NetworkClient = game:GetService("NetworkClient")
local Workspace = game:GetService("Workspace")
local HttpService = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer
local environment = if getgenv then getgenv() else _G
local RUNTIME_KEY = "__CLEAN_ANTI_ANTI_RECONSTRUCTION"
local ConfigFile = "CleanAntiAntiConfig.json"

-- Constantes para posiciones extremas
local LOCAL_Y_DEEP = -100000
local FRONT_DISTANCE = 10000
local LEFT_X = -10000
local ANTI_BAT_RANGE = 5

-- Reemplazar copia anterior
local previousRuntime = environment[RUNTIME_KEY]
if type(previousRuntime) == "table" and type(previousRuntime.destroy) == "function" then
    pcall(previousRuntime.destroy)
end

local runtime = {
    alive = true,
    enabled = false,
    awaitingKey = false,
    boundKey = Enum.KeyCode.Delete,
    character = nil,
    rootPart = nil,
    fakeRoot = nil,
    repRootOwner = nil,
    stepConnection = nil,
    connections = {},
    settingsRestore = {},
    captureGeneration = 0,
    selectedBackground = nil,
    bgPanelOpen = false,
    uiPanelOpen = false,
    currentBgIndex = 1,
    mode = "V1",
    configLoaded = false,
    -- Nuevas variables para anti‑bat / freeze / fling
    antiBatConn = nil,
    freezeConn = nil,
    flingConn = nil,
    lastSafeCFrame = nil,
    lastCheckTime = 0,
}
environment[RUNTIME_KEY] = runtime

-- IDs de fondos
local BACKGROUND_IDS = {
    "136544705293430",
    "115982469043714",
    "99984890349729",
    "72342324393354"
}

-- =================== AUTO SAVE ===================
local function SaveConfig()
    if not runtime.gui or not runtime.refs then return end
    local main = runtime.refs.main
    local mainScale = runtime.refs.mainScale
    if not main or not mainScale then return end

    local data = {
        Keybind = runtime.boundKey and runtime.boundKey.Name or "Delete",
        Nivel = runtime.mode or "V1",
        Bloqueado = runtime.bgPanelOpen or false,
        PanelHeight = main.Size.Y.Offset or 170,
        PanelWidth = main.Size.X.Offset or 330,
        PositionX = main.Position.X.Scale or 0.5,
        PositionY = main.Position.Y.Scale or 0.5,
        OffsetX = main.Position.X.Offset or -165,
        OffsetY = main.Position.Y.Offset or -85,
        Background = runtime.selectedBackground or BACKGROUND_IDS[1],
        BackgroundIndex = runtime.currentBgIndex or 1,
        Scale = mainScale.Scale or 1,
        ToggleEstado = runtime.enabled or false
    }
    local success, result = pcall(function() return HttpService:JSONEncode(data) end)
    if success then
        pcall(function() writefile(ConfigFile, result) end)
    end
end

local function LoadConfig()
    if not pcall(isfile, ConfigFile) or not isfile(ConfigFile) then
        return false
    end
    local success, data = pcall(function() return HttpService:JSONDecode(readfile(ConfigFile)) end)
    if not success or not data then return false end

    if data.Keybind then
        local key = Enum.KeyCode[data.Keybind]
        if key then runtime.boundKey = key end
    end
    if data.Nivel then runtime.mode = data.Nivel end
    if data.Background then
        runtime.selectedBackground = data.Background
        runtime.currentBgIndex = data.BackgroundIndex or 1
    end
    if data.ToggleEstado ~= nil then runtime.enabled = data.ToggleEstado end

    runtime._pendingConfig = {
        Scale = data.Scale,
        PositionX = data.PositionX,
        PositionY = data.PositionY,
        OffsetX = data.OffsetX,
        OffsetY = data.OffsetY,
    }
    runtime.configLoaded = true
    return true
end

-- ==================================================

-- Helpers generales ----------------------------------------------------------

local function connect(signal, callback)
    local connection = signal:Connect(callback)
    table.insert(runtime.connections, connection)
    return connection
end

local function disconnect(connection)
    if connection then
        pcall(function() connection:Disconnect() end)
    end
end

local function create(className, properties, parent)
    local object = Instance.new(className)
    for property, value in pairs(properties or {}) do
        object[property] = value
    end
    if parent then object.Parent = parent end
    return object
end

local function corner(parent, radius)
    return create("UICorner", { CornerRadius = typeof(radius) == "UDim" and radius or UDim.new(0, radius) }, parent)
end

local function stroke(parent, color, transparency, thickness)
    return create("UIStroke", {
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
        Color = color,
        Transparency = transparency,
        Thickness = thickness,
    }, parent)
end

local function isBasePart(instance)
    if not instance then return false end
    local ok, result = pcall(function() return instance:IsA("BasePart") end)
    return ok and result == true
end

local function getCurrentRoot(character)
    character = character or LocalPlayer.Character
    if not character then return nil end
    local ok, root = pcall(function() return character:FindFirstChild("HumanoidRootPart") end)
    if ok and isBasePart(root) then return root end
    return nil
end

-- Compatibilidad con ejecutores -----------------------------------------------

local function findGlobalFunction(...)
    for index = 1, select("#", ...) do
        local name = select(index, ...)
        local value = rawget(environment, name)
        if type(value) == "function" then return value end
    end
    return nil
end

local function setHidden(instance, property, value)
    if not instance then return false end
    local setter = findGlobalFunction("sethiddenproperty", "set_hidden_property", "sethiddenprop", "set_hidden_prop")
    if setter then
        local ok = pcall(setter, instance, property, value)
        if ok then return true end
    end
    return pcall(function() instance[property] = value end)
end

local function getHidden(instance, property)
    if not instance then return false, nil end
    local getter = findGlobalFunction("gethiddenproperty", "get_hidden_property", "gethiddenprop", "get_hidden_prop")
    if getter then
        local ok, value = pcall(getter, instance, property)
        if ok then return true, value end
    end
    local ok, value = pcall(function() return instance[property] end)
    return ok, value
end

-- Configuración de física / red ----------------------------------------------

local function rememberSetting(instance, property)
    local ok, value = pcall(function() return instance[property] end)
    if ok then
        table.insert(runtime.settingsRestore, { instance = instance, property = property, value = value })
    end
end

local function applyPublicSetting(instance, property, value)
    if not instance then return false end
    rememberSetting(instance, property)
    return pcall(function() instance[property] = value end)
end

local function configurePhysics()
    setHidden(LocalPlayer, "MaximumSimulationRadius", math.huge)
    setHidden(LocalPlayer, "SimulationRadius", math.huge)
    pcall(function()
        local networkSettings = settings().Network
        applyPublicSetting(networkSettings, "InterpolationThrottling", Enum.InterpolationThrottlingMode.Disabled)
    end)
    pcall(function()
        local physicsSettings = settings().Physics
        applyPublicSetting(physicsSettings, "PhysicsEnvironmentalThrottle", Enum.EnviromentalPhysicsThrottle.Disabled)
        applyPublicSetting(physicsSettings, "AllowSleep", false)
    end)
    pcall(function() NetworkClient:SetOutgoingKBPSLimit(math.huge) end)
end
configurePhysics()

-- Replication‑root runtime ---------------------------------------------------

local FAKE_ROOT_NAME = "DavidDesyncRoot"
local FAKE_ROOT_Y = -2500
local FAKE_ROOT_VELOCITY = Vector3.new(0, -1000, 0)

local function fakeRootIsUsable()
    local fake = runtime.fakeRoot
    if not isBasePart(fake) then return false end
    local ok, parent = pcall(function() return fake.Parent end)
    return ok and parent ~= nil
end

local function destroyFakeRoot()
    local fake = runtime.fakeRoot
    runtime.fakeRoot = nil
    if fake then pcall(function() fake:Destroy() end) end
end

local function restoreReplicationRoot()
    local owner = runtime.repRootOwner or runtime.rootPart
    if isBasePart(owner) then
        setHidden(owner, "PhysicsRepRootPart", owner)
    end
    runtime.repRootOwner = nil
end

local function createFakeRoot(rootPart)
    destroyFakeRoot()
    local fake = create("Part", {
        Name = FAKE_ROOT_NAME,
        Size = Vector3.new(2, 2, 1),
        Anchored = true,
        CanCollide = false,
        CanTouch = false,
        CanQuery = false,
        Transparency = 1,
        CFrame = CFrame.new(0, FAKE_ROOT_Y, 0),
        AssemblyLinearVelocity = FAKE_ROOT_VELOCITY,
    }, Workspace)
    local ok, position = pcall(function() return rootPart.Position end)
    if ok then
        fake.CFrame = CFrame.new(position.X, FAKE_ROOT_Y, position.Z)
    end
    runtime.fakeRoot = fake
    return fake
end

local function assignFakeReplicationRoot(rootPart, fake)
    if not isBasePart(rootPart) or not isBasePart(fake) then return false end
    setHidden(rootPart, "PhysicsRepRootPart", rootPart)
    runtime.repRootOwner = rootPart
    return setHidden(rootPart, "PhysicsRepRootPart", fake)
end

-- =========================== NUEVA LÓGICA ANTI‑BAT / FREEZE / FLING ===========================

local function stopAntiBat()
    if runtime.antiBatConn then
        runtime.antiBatConn:Disconnect()
        runtime.antiBatConn = nil
    end
    runtime.lastSafeCFrame = nil
end

local function startAntiBat()
    stopAntiBat()
    runtime.lastSafeCFrame, runtime.lastCheckTime = nil, 0
    runtime.antiBatConn = RunService.Heartbeat:Connect(function()
        if not runtime.enabled or not runtime.alive then return end
        local char = LocalPlayer.Character
        if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hrp or not hum or hum.Health <= 0 then return end

        local now = tick()
        local velocity = hrp.AssemblyLinearVelocity
        if velocity.Magnitude < 70 then
            runtime.lastSafeCFrame = hrp.CFrame
            runtime.lastCheckTime = now
        elseif velocity.Magnitude > 110 and runtime.lastSafeCFrame and (now - runtime.lastCheckTime) < 1.5 then
            hrp.CFrame = runtime.lastSafeCFrame * CFrame.new(0, 0.1, 0)
        end

        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character then
                local eHrp = plr.Character:FindFirstChild("HumanoidRootPart")
                local tool = plr.Character:FindFirstChildWhichIsA("Tool")
                if eHrp and tool and tool.Name:lower():find("bat") then
                    local dist = (hrp.Position - eHrp.Position).Magnitude
                    if dist < ANTI_BAT_RANGE then
                        local angle = math.rad(tick() * 500)
                        hrp.CFrame = hrp.CFrame * CFrame.new(math.sin(angle) * 3, 0, math.cos(angle) * 3)
                    end
                end
            end
        end
    end)
end

local function stopFreeze()
    if runtime.freezeConn then
        runtime.freezeConn:Disconnect()
        runtime.freezeConn = nil
    end
end

local function startFreeze()
    stopFreeze()
    runtime.freezeConn = RunService.Heartbeat:Connect(function()
        if not runtime.enabled or not runtime.alive then return end
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character then
                local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    hrp.AssemblyLinearVelocity = Vector3.zero
                    hrp.AssemblyAngularVelocity = Vector3.zero
                end
            end
        end
    end)
end

local function stopFling()
    if runtime.flingConn then
        runtime.flingConn:Disconnect()
        runtime.flingConn = nil
    end
end

local function startFling()
    stopFling()
    runtime.flingConn = RunService.Heartbeat:Connect(function()
        if not runtime.enabled or not runtime.alive then return end
        local myChar = LocalPlayer.Character
        if not myChar then return end
        local myHrp = myChar:FindFirstChild("HumanoidRootPart")
        if not myHrp then return end

        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character then
                local eHrp = plr.Character:FindFirstChild("HumanoidRootPart")
                if eHrp then
                    local dist = (myHrp.Position - eHrp.Position).Magnitude
                    if dist < ANTI_BAT_RANGE then
                        local dir = (eHrp.Position - myHrp.Position).Unit
                        eHrp.AssemblyLinearVelocity = dir * 150 + Vector3.new(0, 80, 0)
                    end
                end
            end
        end
    end)
end

-- =========================== MODIFICACIÓN PRINCIPAL DE DESYNC ===========================

local function stepDesync()
    if not runtime.alive or not runtime.enabled then return end

    local root = runtime.rootPart
    if not isBasePart(root) then
        root = getCurrentRoot(runtime.character)
        runtime.rootPart = root
    end
    if not root then return end

    if not fakeRootIsUsable() then
        local fake = createFakeRoot(root)
        assignFakeReplicationRoot(root, fake)
        return
    end

    local fake = runtime.fakeRoot
    local rootPos = root.Position
    local rootCFrame = root.CFrame

    -- Lógica según el modo
    if runtime.mode == "V1" or runtime.mode == "V2" then
        -- V1 y V2 usan el mismo posicionamiento simple (Y profunda)
        pcall(function()
            fake.CFrame = CFrame.new(rootPos.X, LOCAL_Y_DEEP, rootPos.Z)
        end)
    elseif runtime.mode == "V3" then
        pcall(function()
            fake.CFrame = CFrame.new(LEFT_X, LOCAL_Y_DEEP, rootPos.Z)
        end)
    end

    pcall(function()
        fake.Anchored = true
        fake.AssemblyLinearVelocity = FAKE_ROOT_VELOCITY
    end)

    local gotValue, current = getHidden(root, "PhysicsRepRootPart")
    if not gotValue or current ~= fake then
        setHidden(root, "PhysicsRepRootPart", fake)
    end
end

local function stopStepConnection()
    disconnect(runtime.stepConnection)
    runtime.stepConnection = nil
end

local function startStepConnection()
    stopStepConnection()
    runtime.stepConnection = RunService.Stepped:Connect(stepDesync)
end

-- =========================== INICIO / PARADA DE PROTECCIONES SEGÚN MODO ===========================

local function startProtections()
    -- Solo en modo V2 se activan las protecciones adicionales
    if runtime.mode == "V2" then
        startAntiBat()
        startFreeze()
        startFling()
    else
        stopAntiBat()
        stopFreeze()
        stopFling()
    end
end

local function stopProtections()
    stopAntiBat()
    stopFreeze()
    stopFling()
end

-- =========================== CICLO DE VIDA DEL PERSONAJE ===========================

local function bindCharacter(character)
    local oldRoot = runtime.rootPart
    runtime.character = character
    runtime.rootPart = getCurrentRoot(character)

    if runtime.enabled then
        if isBasePart(oldRoot) and oldRoot ~= runtime.rootPart then
            setHidden(oldRoot, "PhysicsRepRootPart", oldRoot)
        end
        destroyFakeRoot()

        local root = runtime.rootPart
        if not root and character then
            local ok, waitedRoot = pcall(function()
                return character:WaitForChild("HumanoidRootPart", 8)
            end)
            if ok and isBasePart(waitedRoot) then
                root = waitedRoot
                runtime.rootPart = root
            end
        end

        if root then
            local fake = createFakeRoot(root)
            assignFakeReplicationRoot(root, fake)
            startStepConnection()
            startProtections()  -- Inicia según el modo actual
        end
    end
end

bindCharacter(LocalPlayer.Character)
connect(LocalPlayer.CharacterAdded, function(character)
    task.defer(bindCharacter, character)
end)

-- =========================== INTERFAZ (sin cambios importantes) ===========================

local COLORS = {
    black = Color3.fromRGB(0, 0, 0),
    blackDeep = Color3.fromRGB(2, 2, 2),
    silverDark = Color3.fromRGB(60, 60, 65),
    silverMid = Color3.fromRGB(130, 130, 140),
    silverLight = Color3.fromRGB(190, 190, 200),
    silverBright = Color3.fromRGB(220, 220, 230),
    white = Color3.fromRGB(255, 255, 255),
    whitePure = Color3.fromRGB(255, 255, 255),
}

local uiParent = CoreGui
local oldGui = uiParent:FindFirstChild("CleanAntiAntiUI")
if oldGui then oldGui:Destroy() end

local screenGui = create("ScreenGui", {
    Name = "CleanAntiAntiUI",
    DisplayOrder = 999,
    ResetOnSpawn = false,
    IgnoreGuiInset = true,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
}, nil)

local parented = pcall(function() screenGui.Parent = uiParent end)
if not parented then
    local playerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui") or LocalPlayer:WaitForChild("PlayerGui")
    uiParent = playerGui
    local stale = uiParent:FindFirstChild("CleanAntiAntiUI")
    if stale then stale:Destroy() end
    screenGui.Parent = uiParent
end
runtime.gui = screenGui

local configLoaded = LoadConfig()

local main = create("Frame", {
    Name = "Main",
    Active = true,
    ClipsDescendants = true,
    BackgroundTransparency = 0,
    BackgroundColor3 = COLORS.black,
    BorderSizePixel = 0,
    Position = UDim2.new(0.5, -165, 0.5, -85),
    Size = UDim2.new(0, 330, 0, 170),
}, screenGui)
corner(main, 20)

main:GetPropertyChangedSignal("Position"):Connect(SaveConfig)

local mainScale = create("UIScale", { Scale = 1 }, main)
local mainStroke = stroke(main, Color3.fromRGB(20, 20, 20), 0.5, 2)
mainStroke.Transparency = 0.6

local bgOverlay = create("ImageLabel", {
    Name = "BgOverlay",
    BackgroundTransparency = 1,
    Image = "",
    ScaleType = Enum.ScaleType.Crop,
    Position = UDim2.new(0, 0, 0, 0),
    Size = UDim2.new(1, 0, 1, 0),
    ZIndex = 1,
}, main)
corner(bgOverlay, 20)

if runtime._pendingConfig then
    local cfg = runtime._pendingConfig
    if cfg.Scale then mainScale.Scale = math.clamp(cfg.Scale, 0.01, 2.0) end
    if cfg.PositionX and cfg.PositionY and cfg.OffsetX and cfg.OffsetY then
        main.Position = UDim2.new(cfg.PositionX, cfg.OffsetX, cfg.PositionY, cfg.OffsetY)
    end
    runtime._pendingConfig = nil
end

-- Header
local header = create("Frame", {
    Name = "Header",
    BackgroundTransparency = 0,
    BackgroundColor3 = Color3.fromRGB(5, 5, 5),
    BorderSizePixel = 0,
    Position = UDim2.new(0, 0, 0, 0),
    ZIndex = 10,
    Size = UDim2.new(1, 0, 0, 38),
}, main)
corner(header, 20)
header:FindFirstChild("UICorner").CornerRadius = UDim.new(0, 20)

local divider = create("Frame", {
    Name = "Divider",
    BackgroundColor3 = Color3.fromRGB(15, 15, 15),
    BackgroundTransparency = 0.7,
    BorderSizePixel = 0,
    Position = UDim2.new(0, 16, 1, -1),
    Size = UDim2.new(1, -32, 0, 1),
    ZIndex = 12,
}, header)

local title = create("TextLabel", {
    Name = "Title",
    BackgroundTransparency = 1,
    Text = "CLEAN ANTI ANTI",
    TextColor3 = COLORS.white,
    Font = Enum.Font.SourceSansBold,
    Position = UDim2.new(0, 14, 0, 2),
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 11,
    TextSize = 17,
    Size = UDim2.new(1, -200, 0, 20),
}, header)

local subtitle = create("TextLabel", {
    Name = "Subtitle",
    BackgroundTransparency = 1,
    Text = "discord.gg/cleanhub",
    TextColor3 = COLORS.silverMid,
    Font = Enum.Font.SourceSans,
    Position = UDim2.new(0, 14, 0, 20),
    TextXAlignment = Enum.TextXAlignment.Left,
    TextSize = 9,
    ZIndex = 11,
    Size = UDim2.new(1, -200, 0, 14),
}, header)

local function createTopButton(parent, position, text, color)
    local btn = create("TextButton", {
        AutoButtonColor = false,
        BackgroundColor3 = Color3.fromRGB(0, 0, 0),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Position = position,
        Size = UDim2.new(0, 24, 0, 28),
        Text = text,
        TextColor3 = color or COLORS.silverBright,
        Font = Enum.Font.SourceSansBold,
        TextSize = 16,
        ZIndex = 11,
    }, parent)
    return btn
end

local navUI = createTopButton(header, UDim2.new(1, -104, 0, 5), "UI", COLORS.white)
local navLeft = createTopButton(header, UDim2.new(1, -76, 0, 5), "◄")
local navCenter = createTopButton(header, UDim2.new(1, -48, 0, 5), "⚙️", COLORS.silverBright)
local navRight = createTopButton(header, UDim2.new(1, -20, 0, 5), "►")

-- Paneles de fondo y escala (sin cambios)
local bgPanel = create("Frame", {
    Name = "BgPanel",
    BackgroundTransparency = 0,
    BackgroundColor3 = COLORS.black,
    BorderSizePixel = 0,
    Position = UDim2.new(0.5, -120, 0.5, -60),
    Size = UDim2.new(0, 240, 0, 120),
    Visible = false,
    ZIndex = 50,
}, screenGui)
corner(bgPanel, 16)
stroke(bgPanel, Color3.fromRGB(20, 20, 20), 0.6, 2)

local bgPanelTitle = create("TextLabel", {
    Name = "Title",
    BackgroundTransparency = 1,
    Text = "IMAGES",
    TextColor3 = COLORS.white,
    Font = Enum.Font.SourceSansBold,
    Position = UDim2.new(0, 0, 0, 8),
    TextSize = 14,
    Size = UDim2.new(1, 0, 0, 24),
    ZIndex = 51,
}, bgPanel)

local bgGrid = create("Frame", {
    Name = "Grid",
    BackgroundTransparency = 1,
    Position = UDim2.new(0, 12, 0, 36),
    Size = UDim2.new(1, -24, 1, -48),
    ZIndex = 51,
}, bgPanel)
local gridLayout = create("UIGridLayout", {
    CellSize = UDim2.new(0, 48, 0, 48),
    CellPadding = UDim2.new(0, 8, 0, 8),
    FillDirection = Enum.FillDirection.Horizontal,
    HorizontalAlignment = Enum.HorizontalAlignment.Center,
    VerticalAlignment = Enum.VerticalAlignment.Center,
}, bgGrid)

local bgButtons = {}
for i, id in ipairs(BACKGROUND_IDS) do
    local btn = create("ImageButton", {
        Name = "BgBtn_" .. i,
        BackgroundColor3 = Color3.fromRGB(10, 10, 10),
        BackgroundTransparency = 0,
        BorderSizePixel = 0,
        Image = "rbxassetid://" .. id,
        ScaleType = Enum.ScaleType.Crop,
        ZIndex = 52,
    }, bgGrid)
    corner(btn, 8)
    stroke(btn, Color3.fromRGB(20, 20, 20), 0.6, 1.5)
    bgButtons[btn] = id
end

local closeBgPanel = create("TextButton", {
    Name = "Close",
    AutoButtonColor = false,
    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    Position = UDim2.new(1, -50, 0, 4),
    Size = UDim2.new(0, 45, 0, 24),
    Text = "Close",
    TextColor3 = COLORS.silverMid,
    Font = Enum.Font.SourceSansBold,
    TextSize = 12,
    ZIndex = 52,
}, bgPanel)

local uiPanel = create("Frame", {
    Name = "UIPanel",
    BackgroundTransparency = 0,
    BackgroundColor3 = COLORS.black,
    BorderSizePixel = 0,
    Position = UDim2.new(0.5, -60, 0.5, -60),
    Size = UDim2.new(0, 120, 0, 120),
    Visible = false,
    ZIndex = 100,
}, screenGui)
corner(uiPanel, 16)
stroke(uiPanel, Color3.fromRGB(20, 20, 20), 0.6, 2)

local uiPanelTitle = create("TextLabel", {
    Name = "Title",
    BackgroundTransparency = 1,
    Text = "SCALE",
    TextColor3 = COLORS.white,
    Font = Enum.Font.SourceSansBold,
    Position = UDim2.new(0, 0, 0, 6),
    TextSize = 12,
    Size = UDim2.new(1, 0, 0, 18),
    ZIndex = 51,
}, uiPanel)

local uiPercentLabel = create("TextLabel", {
    Name = "Percent",
    BackgroundTransparency = 1,
    Text = "100%",
    TextColor3 = COLORS.white,
    Font = Enum.Font.SourceSansBold,
    Position = UDim2.new(0, 0, 1, -22),
    TextSize = 14,
    Size = UDim2.new(1, 0, 0, 18),
    ZIndex = 51,
}, uiPanel)

local sliderBar = create("Frame", {
    Name = "SliderBar",
    BackgroundColor3 = COLORS.silverDark,
    BackgroundTransparency = 0,
    BorderSizePixel = 0,
    Position = UDim2.new(0.5, -4, 0, 28),
    Size = UDim2.new(0, 8, 0, 60),
    ZIndex = 51,
}, uiPanel)
corner(sliderBar, 4)

local sliderKnob = create("TextLabel", {
    Name = "SliderKnob",
    BackgroundTransparency = 1,
    Text = "▲",
    TextColor3 = COLORS.white,
    Font = Enum.Font.SourceSansBold,
    TextSize = 22,
    Position = UDim2.new(0.5, -12, 0.5, -12),
    Size = UDim2.new(0, 24, 0, 24),
    ZIndex = 52,
}, sliderBar)

local closeUiPanel = create("TextButton", {
    Name = "Close",
    AutoButtonColor = false,
    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    Position = UDim2.new(1, -50, 0, 4),
    Size = UDim2.new(0, 45, 0, 24),
    Text = "Close",
    TextColor3 = COLORS.silverMid,
    Font = Enum.Font.SourceSansBold,
    TextSize = 12,
    ZIndex = 52,
}, uiPanel)

-- Funciones del panel de escala (sin cambios)
local function updateKnobPosition()
    local scale = mainScale.Scale
    local minScale = 0.01
    local maxScale = 2.0
    local percent = (scale - minScale) / (maxScale - minScale)
    local barHeight = sliderBar.AbsoluteSize.Y - 24
    if barHeight <= 0 then barHeight = 36 end
    local knobY = (1 - percent) * barHeight
    sliderKnob.Position = UDim2.new(0.5, -12, 0, knobY - 12)
    uiPercentLabel.Text = string.format("%d%%", math.round(scale * 100))
end

local function toggleUiPanel()
    runtime.uiPanelOpen = not runtime.uiPanelOpen
    uiPanel.Visible = runtime.uiPanelOpen
    if runtime.uiPanelOpen then
        task.wait()
        updateKnobPosition()
    end
end

local function updateScaleFromKnob()
    local barHeight = sliderBar.AbsoluteSize.Y - 24
    if barHeight <= 0 then barHeight = 36 end
    local knobY = sliderKnob.Position.Y.Offset
    local percent = 1 - (knobY / barHeight)
    percent = math.clamp(percent, 0, 1)
    local scale = 0.01 + percent * (2.0 - 0.01)
    scale = math.round(scale * 100) / 100
    mainScale.Scale = scale
    uiPercentLabel.Text = string.format("%d%%", math.round(scale * 100))
    SaveConfig()
end

local draggingKnob = false
local function startKnobDrag(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        draggingKnob = true
        local connection
        connection = connect(UserInputService.InputChanged, function(input)
            if draggingKnob and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                local barAbsPos = sliderBar.AbsolutePosition
                local barHeight = sliderBar.AbsoluteSize.Y - 24
                if barHeight <= 0 then barHeight = 36 end
                local mouseY = input.Position.Y
                local newY = math.clamp(mouseY - barAbsPos.Y - 12, 0, barHeight)
                sliderKnob.Position = UDim2.new(0.5, -12, 0, newY - 12)
                updateScaleFromKnob()
            end
        end)
        local endedConnection
        endedConnection = connect(input.Changed, function()
            if input.UserInputState == Enum.UserInputState.End then
                draggingKnob = false
                disconnect(connection)
                disconnect(endedConnection)
            end
        end)
    end
end

connect(sliderKnob.InputBegan, startKnobDrag)
connect(sliderBar.InputBegan, function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        local barAbsPos = sliderBar.AbsolutePosition
        local barHeight = sliderBar.AbsoluteSize.Y - 24
        if barHeight <= 0 then barHeight = 36 end
        local mouseY = input.Position.Y
        local newY = math.clamp(mouseY - barAbsPos.Y - 12, 0, barHeight)
        sliderKnob.Position = UDim2.new(0.5, -12, 0, newY - 12)
        updateScaleFromKnob()
        draggingKnob = true
        local connection
        connection = connect(UserInputService.InputChanged, function(input)
            if draggingKnob and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                local barAbsPos = sliderBar.AbsolutePosition
                local barHeight = sliderBar.AbsoluteSize.Y - 24
                if barHeight <= 0 then barHeight = 36 end
                local mouseY = input.Position.Y
                local newY = math.clamp(mouseY - barAbsPos.Y - 12, 0, barHeight)
                sliderKnob.Position = UDim2.new(0.5, -12, 0, newY - 12)
                updateScaleFromKnob()
            end
        end)
        local endedConnection
        endedConnection = connect(input.Changed, function()
            if input.UserInputState == Enum.UserInputState.End then
                draggingKnob = false
                disconnect(connection)
                disconnect(endedConnection)
            end
        end)
    end
end)

-- Funciones de backgrounds (sin cambios)
local function toggleBgPanel()
    runtime.bgPanelOpen = not runtime.bgPanelOpen
    bgPanel.Visible = runtime.bgPanelOpen
end

local function setBackground(imageId)
    if imageId then
        bgOverlay.Image = "rbxassetid://" .. imageId
        runtime.selectedBackground = imageId
        SaveConfig()
    end
end

local function changeBackground(direction)
    local total = #BACKGROUND_IDS
    runtime.currentBgIndex = runtime.currentBgIndex + direction
    if runtime.currentBgIndex > total then runtime.currentBgIndex = 1
    elseif runtime.currentBgIndex < 1 then runtime.currentBgIndex = total end
    local id = BACKGROUND_IDS[runtime.currentBgIndex]
    setBackground(id)
end

-- Contenido
local content = create("Frame", {
    Name = "Content",
    BackgroundTransparency = 1,
    Position = UDim2.new(0, 16, 0, 46),
    ZIndex = 5,
    Size = UDim2.new(1, -32, 1, -54),
}, main)
create("UIListLayout", {
    Padding = UDim.new(0, 8),
    SortOrder = Enum.SortOrder.LayoutOrder,
}, content)

local function makeRow(name, layoutOrder)
    local row = create("Frame", {
        Name = name,
        BackgroundColor3 = Color3.fromRGB(5, 5, 5),
        BackgroundTransparency = 0,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 42),
        LayoutOrder = layoutOrder,
        ZIndex = 5,
    }, content)
    corner(row, 12)
    stroke(row, Color3.fromRGB(15, 15, 15), 0.5, 1.5)
    return row
end

local actionRow = makeRow("ActionRow", 1)
actionRow.Size = UDim2.new(1, 0, 0, 46)
actionRow.BackgroundTransparency = 0.8

local actionButton = create("TextButton", {
    Name = "ActionBtn",
    AutoButtonColor = false,
    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
    BackgroundTransparency = 0.9,
    BorderSizePixel = 0,
    Position = UDim2.new(0, 0, 0, 0),
    Size = UDim2.new(1, 0, 1, 0),
    Text = "ACTIVE",
    TextColor3 = COLORS.white,
    Font = Enum.Font.SourceSansBold,
    TextSize = 18,
    ZIndex = 6,
}, actionRow)
corner(actionButton, 999)
stroke(actionButton, Color3.fromRGB(30, 30, 30), 0.5, 1.5)

local keybindRow = makeRow("KeybindRow", 2)
keybindRow.Size = UDim2.new(1, 0, 0, 34)
keybindRow.BackgroundTransparency = 0.8

local keybindLabel = create("TextLabel", {
    Name = "Label",
    BackgroundTransparency = 1,
    Text = "KEYBIND",
    TextColor3 = COLORS.silverMid,
    Font = Enum.Font.SourceSansBold,
    Position = UDim2.new(0, 14, 0, 0),
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 6,
    TextSize = 11,
    Size = UDim2.new(0, 70, 1, 0),
}, keybindRow)

local keybindButton = create("TextButton", {
    Name = "KeybindBtn",
    AutoButtonColor = false,
    AnchorPoint = Vector2.new(1, 0.5),
    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
    BackgroundTransparency = 0.9,
    BorderSizePixel = 0,
    Position = UDim2.new(1, -12, 0.5, 0),
    Size = UDim2.new(0, 75, 0, 24),
    Text = "Delete",
    TextColor3 = COLORS.white,
    Font = Enum.Font.SourceSansBold,
    TextSize = 11,
    ZIndex = 7,
}, keybindRow)
corner(keybindButton, 8)
stroke(keybindButton, Color3.fromRGB(30, 30, 30), 0.5, 1.5)

local modeButton = create("TextButton", {
    Name = "ModeBtn",
    AutoButtonColor = false,
    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
    BackgroundTransparency = 0.9,
    BorderSizePixel = 0,
    Position = UDim2.new(0, 88, 0.5, 0),
    AnchorPoint = Vector2.new(0, 0.5),
    Size = UDim2.new(0, 55, 0, 24),
    Text = "V1",
    TextColor3 = COLORS.white,
    Font = Enum.Font.SourceSansBold,
    TextSize = 11,
    ZIndex = 7,
}, keybindRow)
corner(modeButton, 8)
stroke(modeButton, Color3.fromRGB(30, 30, 30), 0.5, 1.5)

runtime.refs = {
    screenGui = screenGui,
    main = main,
    mainScale = mainScale,
    mainStroke = mainStroke,
    bgOverlay = bgOverlay,
    header = header,
    divider = divider,
    title = title,
    subtitle = subtitle,
    navUI = navUI,
    navLeft = navLeft,
    navCenter = navCenter,
    navRight = navRight,
    bgPanel = bgPanel,
    bgPanelTitle = bgPanelTitle,
    bgGrid = bgGrid,
    closeBgPanel = closeBgPanel,
    uiPanel = uiPanel,
    uiPanelTitle = uiPanelTitle,
    uiPercentLabel = uiPercentLabel,
    sliderBar = sliderBar,
    sliderKnob = sliderKnob,
    closeUiPanel = closeUiPanel,
    content = content,
    actionRow = actionRow,
    actionButton = actionButton,
    keybindRow = keybindRow,
    keybindLabel = keybindLabel,
    keybindButton = keybindButton,
    modeButton = modeButton,
}

-- =========================== LÓGICA DE MODOS (con reinicio) ===========================

local function toggleMode()
    local modes = {"V1", "V2", "V3"}
    local idx = 1
    for i, m in ipairs(modes) do
        if m == runtime.mode then
            idx = i + 1
            if idx > #modes then idx = 1 end
            break
        end
    end
    runtime.mode = modes[idx]
    modeButton.Text = runtime.mode
    SaveConfig()

    -- Si está activo, reiniciar para aplicar nuevas protecciones
    if runtime.enabled then
        setEnabled(false)
        setEnabled(true)
    end
end

-- Enable/disable principal
local function applyEnabledVisual(value, instant)
    if value then
        actionButton.Text = "ACTIVE"
        actionButton.TextColor3 = COLORS.white
        actionButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        actionButton.BackgroundTransparency = 0.6
    else
        actionButton.Text = "INACTIVE"
        actionButton.TextColor3 = COLORS.white
        actionButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        actionButton.BackgroundTransparency = 0.9
    end
end

local function setEnabled(value)
    if not runtime.alive then return false end

    value = value == true
    if runtime.enabled == value then
        applyEnabledVisual(value, false)
        return value
    end

    runtime.enabled = value

    if value then
        local character = runtime.character or LocalPlayer.Character
        local root = getCurrentRoot(character)
        runtime.rootPart = root
        if not root then
            runtime.enabled = false
            applyEnabledVisual(false, false)
            return false
        end

        local fake = createFakeRoot(root)
        assignFakeReplicationRoot(root, fake)
        startStepConnection()
        startProtections()   -- Inicia anti‑bat/freeze/fling solo si modo V2
    else
        stopStepConnection()
        restoreReplicationRoot()
        destroyFakeRoot()
        stopProtections()
    end

    applyEnabledVisual(value, false)
    SaveConfig()
    return runtime.enabled
end

local function toggleEnabled()
    return setEnabled(not runtime.enabled)
end

-- Conexiones de botones
connect(actionButton.MouseButton1Click, function() toggleEnabled() end)
connect(modeButton.MouseButton1Click, function() toggleMode() end)
connect(navCenter.MouseButton1Click, function() toggleBgPanel() end)
connect(closeBgPanel.MouseButton1Click, function() toggleBgPanel() end)
connect(navUI.MouseButton1Click, function() toggleUiPanel() end)
connect(closeUiPanel.MouseButton1Click, function() toggleUiPanel() end)
connect(navLeft.MouseButton1Click, function() changeBackground(-1) end)
connect(navRight.MouseButton1Click, function() changeBackground(1) end)

for btn, id in pairs(bgButtons) do
    connect(btn.MouseButton1Click, function()
        setBackground(id)
        for i, bid in ipairs(BACKGROUND_IDS) do
            if bid == id then runtime.currentBgIndex = i break end
        end
        toggleBgPanel()
    end)
end

-- Keybind
connect(keybindButton.MouseButton1Click, function()
    if not runtime.alive or runtime.awaitingKey then return end
    runtime.awaitingKey = true
    runtime.captureGeneration += 1
    local generation = runtime.captureGeneration
    task.spawn(function()
        for _, text in ipairs({".", "..", "..."}) do
            if not runtime.alive or not runtime.awaitingKey or generation ~= runtime.captureGeneration then
                return
            end
            keybindButton.Text = text
            task.wait(0.15)
        end
    end)
end)

connect(UserInputService.InputBegan, function(input, gameProcessed)
    if not runtime.alive then return end

    if runtime.awaitingKey then
        local isGamepad = input.UserInputType == Enum.UserInputType.Gamepad1
            or input.UserInputType == Enum.UserInputType.Gamepad2
            or input.UserInputType == Enum.UserInputType.Gamepad3
            or input.UserInputType == Enum.UserInputType.Gamepad4
        if (input.UserInputType == Enum.UserInputType.Keyboard or isGamepad)
            and input.KeyCode ~= Enum.KeyCode.Unknown
        then
            if input.KeyCode ~= Enum.KeyCode.Escape then
                runtime.boundKey = input.KeyCode
            end
            runtime.awaitingKey = false
            runtime.captureGeneration += 1
            keybindButton.Text = runtime.boundKey.Name
            SaveConfig()
        end
        return
    end

    if not gameProcessed and input.KeyCode == runtime.boundKey then
        toggleEnabled()
    end
end)

-- Arrastre del panel
local dragging = false
local dragInput = nil
local dragStart = nil
local startPosition = nil

connect(main.InputBegan, function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch
    then
        dragging = true
        dragInput = input
        dragStart = input.Position
        startPosition = main.Position

        local changedConnection
        changedConnection = input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
                dragInput = nil
                disconnect(changedConnection)
                SaveConfig()
            end
        end)
    end
end)

connect(main.InputChanged, function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch
    then
        dragInput = input
    end
end)

connect(UserInputService.InputChanged, function(input)
    if not dragging or input ~= dragInput or not dragStart or not startPosition then return end
    local delta = input.Position - dragStart
    main.Position = UDim2.new(
        startPosition.X.Scale,
        startPosition.X.Offset + delta.X,
        startPosition.Y.Scale,
        startPosition.Y.Offset + delta.Y
    )
end)

-- Aplicar configuración guardada
if configLoaded then
    if runtime.boundKey then keybindButton.Text = runtime.boundKey.Name end
    if runtime.mode then modeButton.Text = runtime.mode end
    if runtime.selectedBackground then setBackground(runtime.selectedBackground) end
    if runtime.enabled then
        task.wait(0.1)
        setEnabled(true)
    end
end

-- Cleanup
local function destroy()
    if not runtime.alive then return end
    runtime.alive = false
    runtime.enabled = false
    runtime.awaitingKey = false
    runtime.captureGeneration += 1

    stopStepConnection()
    restoreReplicationRoot()
    destroyFakeRoot()
    stopProtections()

    for _, connection in ipairs(runtime.connections) do
        disconnect(connection)
    end
    table.clear(runtime.connections)

    for index = #runtime.settingsRestore, 1, -1 do
        local entry = runtime.settingsRestore[index]
        pcall(function() entry.instance[entry.property] = entry.value end)
    end
    table.clear(runtime.settingsRestore)

    if runtime.gui then pcall(function() runtime.gui:Destroy() end) end
    if environment[RUNTIME_KEY] == runtime then environment[RUNTIME_KEY] = nil end
end

runtime.setEnabled = setEnabled
runtime.toggle = toggleEnabled
runtime.step = stepDesync
runtime.bindCharacter = bindCharacter
runtime.setHidden = setHidden
runtime.getHidden = getHidden
runtime.destroy = destroy
runtime.getBoundKey = function() return runtime.boundKey end
runtime.setBoundKey = function(keyCode)
    if keyCode and keyCode ~= Enum.KeyCode.Unknown then
        runtime.boundKey = keyCode
        keybindButton.Text = keyCode.Name
        SaveConfig()
        return true
    end
    return false
end
runtime.setBackground = setBackground
runtime.changeBackground = changeBackground
runtime.SaveConfig = SaveConfig
runtime.LoadConfig = LoadConfig

applyEnabledVisual(false, true)
if not runtime.selectedBackground then
    setBackground(BACKGROUND_IDS[1])
end

print("Clean Anti-Anti con modo V2 mejorado cargado correctamente!")
print("Config guardada en: " .. ConfigFile)