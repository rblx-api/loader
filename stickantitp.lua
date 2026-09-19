-- STICK ANTI TP BAT (fixed)
-- Bugs corrigés: disconnect(), restoreReplicationRoot(), destroy()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local NetworkClient = game:GetService("NetworkClient")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer

local environment = (getgenv and getgenv()) or _G
local RUNTIME_KEY = "__STICK_ANTI_TP_BAT_RECONSTRUCTION"
local previousRuntime = environment[RUNTIME_KEY]
if type(previousRuntime) == "table" and type(previousRuntime.destroy) == "function" then
    pcall(previousRuntime.destroy)
end

local runtime = {
    alive = true,
    enabled = false,
    awaitingKey = false,
    boundKey = Enum.KeyCode.T,
    character = nil,
    rootPart = nil,
    fakeRoot = nil,
    repRootOwner = nil,
    stepConnection = nil,
    connections = {},
    captureGeneration = 0,
}
environment[RUNTIME_KEY] = runtime

local function disconnect(conn)
    if conn then
        pcall(function() conn:Disconnect() end)
    end
end

local function connect(signal, callback)
    local connection = signal:Connect(callback)
    table.insert(runtime.connections, connection)
    return connection
end

local function createInstance(className, properties, parent)
    local object = Instance.new(className)
    for property, value in pairs(properties or {}) do
        object[property] = value
    end
    if parent then
        object.Parent = parent
    end
    return object
end

local function addCorner(parent, radius)
    return createInstance("UICorner", {
        CornerRadius = typeof(radius) == "UDim" and radius or UDim.new(0, radius),
    }, parent)
end

local function addStroke(parent, color, transparency, thickness)
    return createInstance("UIStroke", {
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
        Color = color,
        Transparency = transparency or 0,
        Thickness = thickness or 1,
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

local function findGlobalFunction(...)
    for index = 1, select("#", ...) do
        local name = select(index, ...)
        local value = rawget(environment, name)
        if type(value) == "function" then
            return value
        end
        value = rawget(_G, name)
        if type(value) == "function" then
            return value
        end
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

local function configurePhysics()
    pcall(function()
        setHidden(LocalPlayer, "MaximumSimulationRadius", math.huge)
        setHidden(LocalPlayer, "SimulationRadius", math.huge)
    end)
    pcall(function()
        local networkSettings = settings().Network
        networkSettings.InterpolationThrottling = Enum.InterpolationThrottlingMode.Disabled
    end)
    pcall(function()
        local physicsSettings = settings().Physics
        physicsSettings.PhysicsEnvironmentalThrottle = Enum.EnviromentalPhysicsThrottle.Disabled
        physicsSettings.AllowSleep = false
    end)
    pcall(function() NetworkClient:SetOutgoingKBPSLimit(math.huge) end)
end
configurePhysics()

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

local function createFakeRoot(rootPart)
    destroyFakeRoot()
    local fake = createInstance("Part", {
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
    if ok and position then
        fake.CFrame = CFrame.new(position.X, FAKE_ROOT_Y, position.Z)
    end
    runtime.fakeRoot = fake
    return fake
end

local function assignFakeReplicationRoot(rootPart, fake)
    if not isBasePart(rootPart) or not isBasePart(fake) then return false end
    runtime.repRootOwner = rootPart
    return setHidden(rootPart, "PhysicsRepRootPart", fake)
end

local function restoreReplicationRoot()
    local root = runtime.rootPart or getCurrentRoot()
    if isBasePart(root) then
        setHidden(root, "PhysicsRepRootPart", root)
    end
    if isBasePart(runtime.repRootOwner) and runtime.repRootOwner ~= root then
        setHidden(runtime.repRootOwner, "PhysicsRepRootPart", runtime.repRootOwner)
    end
    runtime.repRootOwner = nil
end

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
    local ok, rootPosition, fakePosition = pcall(function()
        return root.Position, fake.Position
    end)
    if ok and rootPosition and fakePosition then
        if math.abs(rootPosition.X - fakePosition.X) > 0.01
            or math.abs(rootPosition.Z - fakePosition.Z) > 0.01
            or math.abs(fakePosition.Y - FAKE_ROOT_Y) > 0.01 then
            pcall(function()
                fake.CFrame = CFrame.new(rootPosition.X, FAKE_ROOT_Y, rootPosition.Z)
            end)
        end
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
        end
    end
end

bindCharacter(LocalPlayer.Character)
connect(LocalPlayer.CharacterAdded, function(character)
    task.defer(bindCharacter, character)
end)

-- UI
local COLORS = {
    main = Color3.fromRGB(20, 0, 0),
    text = Color3.new(1, 1, 1), -- blanco
    accent = Color3.fromRGB(255, 0, 0),
    silver = Color3.fromRGB(192, 192, 192),
}

local uiParent = CoreGui
local oldGui = uiParent:FindFirstChild("Vx7AntiTpBatUI")
if oldGui then oldGui:Destroy() end

local screenGui = createInstance("ScreenGui", {
    Name = "Vx7AntiTpBatUI",
    DisplayOrder = 999,
    ResetOnSpawn = false,
    IgnoreGuiInset = true,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
}, nil)

local parented = pcall(function() screenGui.Parent = uiParent end)
if not parented then
    local playerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui") or LocalPlayer:WaitForChild("PlayerGui")
    uiParent = playerGui
    local stale = uiParent:FindFirstChild("Vx7AntiTpBatUI")
    if stale then stale:Destroy() end
    screenGui.Parent = uiParent
end
runtime.gui = screenGui

local main = createInstance("Frame", {
    Name = "Main",
    Active = true,
    Draggable = true,
    ClipsDescendants = true,
    BackgroundTransparency = 0.08,
    BackgroundColor3 = COLORS.main,
    BorderSizePixel = 0,
    Position = UDim2.new(0.5, -130, 0.5, -65),
    Size = UDim2.new(0, 260, 0, 130),
}, screenGui)
addCorner(main, 16)
addStroke(main, Color3.fromRGB(200, 0, 0), 0, 1.8)

local backdrop = createInstance("ImageLabel", {
    Name = "Backdrop",
    Active = false,
    ScaleType = Enum.ScaleType.Crop,
    ImageTransparency = 0.15,
    BackgroundTransparency = 1,
    Position = UDim2.new(0, 0, 0, 0),
    ZIndex = 1,
    Size = UDim2.new(1, 0, 1, 0),
    Image = "rbxassetid://120361169727304",
}, main)
addCorner(backdrop, 16)

local header = createInstance("Frame", {
    Name = "Header",
    Active = false,
    BackgroundTransparency = 1,
    Position = UDim2.new(0, 16, 0, 6),
    ZIndex = 10,
    Size = UDim2.new(1, -24, 0, 30),
}, main)

createInstance("Frame", {
    Name = "RedLine",
    Active = false,
    BackgroundColor3 = Color3.fromRGB(255, 0, 0),
    BorderSizePixel = 0,
    Position = UDim2.new(0, 8, 0, 5),
    Size = UDim2.new(0, 3, 1, -10),
    ZIndex = 11,
}, header)

createInstance("TextLabel", {
    Name = "Title",
    Active = false,
    BackgroundTransparency = 1,
    Text = "STICK ANTI TP BAT",
    TextColor3 = COLORS.text, -- blanco
    Font = Enum.Font.GothamBlack,
    Position = UDim2.new(0, 18, 0, 0),
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 11,
    TextSize = 14,
    Size = UDim2.new(1, -20, 1, 0),
}, header)

local content = createInstance("Frame", {
    Name = "Content",
    Active = false,
    BackgroundTransparency = 1,
    Position = UDim2.new(0, 18, 0, 36),
    ZIndex = 5,
    Size = UDim2.new(1, -28, 1, -42),
}, main)
createInstance("UIListLayout", {
    Padding = UDim.new(0, 10),
    SortOrder = Enum.SortOrder.LayoutOrder,
}, content)

local toggleBtn = createInstance("TextButton", {
    Name = "ToggleBtn",
    Active = true,
    AutoButtonColor = false,
    BackgroundColor3 = Color3.fromRGB(90, 0, 0),
    BackgroundTransparency = 0.35,
    BorderSizePixel = 0,
    Size = UDim2.new(1, 0, 0, 35),
    Text = "ACTIVATE",
    TextColor3 = Color3.new(1, 1, 1), -- blanco
    Font = Enum.Font.GothamBlack,
    TextSize = 12,
    ZIndex = 7,
    LayoutOrder = 1,
}, content)
addCorner(toggleBtn, 8)

local keybindFrame = createInstance("Frame", {
    Name = "KeybindFrame",
    Active = false,
    BackgroundTransparency = 1,
    Size = UDim2.new(1, 0, 0, 30),
    LayoutOrder = 2,
}, content)

createInstance("TextLabel", {
    Name = "Label",
    Active = false,
    BackgroundTransparency = 1,
    Text = "KEYBIND",
    TextColor3 = Color3.new(1, 1, 1), -- blanco
    Font = Enum.Font.GothamBold,
    Position = UDim2.new(0, 0, 0.5, -8),
    Size = UDim2.new(0, 100, 0, 16),
    TextSize = 12,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 6,
}, keybindFrame)

local keybindButton = createInstance("TextButton", {
    Name = "KeybindBtn",
    Active = true,
    AutoButtonColor = false,
    AnchorPoint = Vector2.new(1, 0.5),
    BackgroundColor3 = Color3.fromRGB(40, 0, 0),
    BorderSizePixel = 0,
    Position = UDim2.new(1, 0, 0.5, 0),
    Size = UDim2.new(0, 70, 0, 26),
    Text = runtime.boundKey.Name,
    TextColor3 = Color3.new(1, 1, 1), -- blanco
    Font = Enum.Font.GothamBlack,
    TextSize = 12,
    ZIndex = 7,
}, keybindFrame)
addCorner(keybindButton, 6)

local statusLbl = createInstance("TextLabel", {
    Name = "Status",
    Active = false,
    BackgroundTransparency = 1,
    Text = "Status: OFF",
    TextColor3 = Color3.new(1, 1, 1), -- blanco
    Font = Enum.Font.Gotham,
    Size = UDim2.new(1, 0, 0, 16),
    TextSize = 11,
    TextXAlignment = Enum.TextXAlignment.Left,
    LayoutOrder = 3,
    ZIndex = 6,
}, content)

local function applyEnabledVisual(value)
    toggleBtn.Text = value and "DEACTIVATE" or "ACTIVATE"
    toggleBtn.BackgroundColor3 = value and Color3.fromRGB(160, 0, 0) or Color3.fromRGB(90, 0, 0)
    statusLbl.Text = value and "Status: ON" or "Status: OFF"
    statusLbl.TextColor3 = value and Color3.fromRGB(0, 255, 120) or Color3.new(1, 1, 1)
end

local function setEnabled(value)
    if not runtime.alive then return false end
    value = value == true
    if runtime.enabled == value then
        applyEnabledVisual(value)
        return value
    end
    runtime.enabled = value
    applyEnabledVisual(value)
    if value then
        local root = getCurrentRoot(runtime.character or LocalPlayer.Character)
        runtime.rootPart = root
        runtime.character = LocalPlayer.Character
        if not root then
            runtime.enabled = false
            applyEnabledVisual(false)
            statusLbl.Text = "Status: NO ROOT"
            return false
        end
        local fake = createFakeRoot(root)
        local ok = assignFakeReplicationRoot(root, fake)
        if not ok then
            statusLbl.Text = "Status: NEED sethiddenproperty"
        end
        startStepConnection()
    else
        stopStepConnection()
        restoreReplicationRoot()
        destroyFakeRoot()
    end
    return runtime.enabled
end

local function toggleEnabled()
    return setEnabled(not runtime.enabled)
end

connect(toggleBtn.MouseButton1Click, function()
    toggleEnabled()
end)

connect(keybindButton.MouseButton1Click, function()
    if not runtime.alive or runtime.awaitingKey then return end
    runtime.awaitingKey = true
    runtime.captureGeneration = runtime.captureGeneration + 1
    local generation = runtime.captureGeneration
    keybindButton.Text = "..."
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
        if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode ~= Enum.KeyCode.Unknown then
            if input.KeyCode ~= Enum.KeyCode.Escape then
                runtime.boundKey = input.KeyCode
            end
            runtime.awaitingKey = false
            keybindButton.Text = runtime.boundKey.Name
            return
        end
    end
    if gameProcessed then return end
    if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == runtime.boundKey then
        toggleEnabled()
    end
end)

function runtime.destroy()
    runtime.alive = false
    runtime.enabled = false
    stopStepConnection()
    restoreReplicationRoot()
    destroyFakeRoot()
    for _, c in ipairs(runtime.connections) do
        disconnect(c)
    end
    table.clear(runtime.connections)
    if runtime.gui then
        pcall(function() runtime.gui:Destroy() end)
        runtime.gui = nil
    end
    if environment[RUNTIME_KEY] == runtime then
        environment[RUNTIME_KEY] = nil
    end
end

print("[STICK] Anti TP Bat loaded (fixed)")