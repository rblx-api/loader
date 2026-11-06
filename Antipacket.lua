local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local previousGui = playerGui:FindFirstChild("AntiPackedLaggGui")
if previousGui then
    previousGui:Destroy()
end

local function create(className, properties, parent)
    local object = Instance.new(className)
    for property, value in pairs(properties) do
        object[property] = value
    end
    object.Parent = parent
    return object
end

local originalStates = setmetatable({}, { __mode = "k" })
local enabled = false
local scanVersion = 0

local function isVisualEffect(instance)
    return instance:IsA("ParticleEmitter")
        or instance:IsA("Trail")
        or instance:IsA("Beam")
        or instance:IsA("Smoke")
        or instance:IsA("Fire")
        or instance:IsA("Sparkles")
        or instance:IsA("Light")
        or instance:IsA("PostEffect")
        or instance:IsA("Highlight")
end

local function disableEffect(instance)
    if not isVisualEffect(instance) then
        return
    end

    local ok, oldValue = pcall(function()
        return instance.Enabled
    end)
    if not ok then
        return
    end

    if originalStates[instance] == nil then
        originalStates[instance] = oldValue
    end

    pcall(function()
        instance.Enabled = false
    end)
end

local function restoreEffects()
    for instance, oldValue in pairs(originalStates) do
        if instance and instance.Parent then
            pcall(function()
                instance.Enabled = oldValue
            end)
        end
        originalStates[instance] = nil
    end
end

local gui = create("ScreenGui", {
    Name = "AntiPackedLaggGui",
    ResetOnSpawn = false,
    IgnoreGuiInset = true,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
}, playerGui)

local panel = create("Frame", {
    Name = "Main",
    AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.fromScale(0.5, 0.5),
    Size = UDim2.fromOffset(340, 225),
    BackgroundColor3 = Color3.fromRGB(17, 20, 31),
    BorderSizePixel = 0,
}, gui)
create("UICorner", { CornerRadius = UDim.new(0, 15) }, panel)
create("UIStroke", {
    Color = Color3.fromRGB(91, 107, 160),
    Thickness = 1.2,
    Transparency = 0.15,
}, panel)
create("UISizeConstraint", {
    MinSize = Vector2.new(290, 210),
    MaxSize = Vector2.new(380, 225),
}, panel)

local topBar = create("Frame", {
    Name = "TopBar",
    Size = UDim2.new(1, 0, 0, 68),
    BackgroundColor3 = Color3.fromRGB(26, 31, 49),
    BorderSizePixel = 0,
}, panel)
create("UICorner", { CornerRadius = UDim.new(0, 15) }, topBar)

create("Frame", {
    Position = UDim2.new(0, 0, 1, -15),
    Size = UDim2.new(1, 0, 0, 15),
    BackgroundColor3 = topBar.BackgroundColor3,
    BorderSizePixel = 0,
}, topBar)

create("TextLabel", {
    Name = "Title",
    Position = UDim2.fromOffset(18, 12),
    Size = UDim2.new(1, -100, 0, 25),
    BackgroundTransparency = 1,
    Font = Enum.Font.GothamBold,
    Text = "ANTI PACKED LAGG",
    TextColor3 = Color3.fromRGB(240, 243, 255),
    TextSize = 17,
    TextXAlignment = Enum.TextXAlignment.Left,
}, topBar)

create("TextLabel", {
    Name = "Subtitle",
    Position = UDim2.fromOffset(19, 38),
    Size = UDim2.new(1, -105, 0, 17),
    BackgroundTransparency = 1,
    Font = Enum.Font.Gotham,
    Text = "CLIENT PERFORMANCE CONTROL",
    TextColor3 = Color3.fromRGB(150, 161, 190),
    TextSize = 9,
    TextXAlignment = Enum.TextXAlignment.Left,
}, topBar)

local closeButton = create("TextButton", {
    Name = "Close",
    AnchorPoint = Vector2.new(1, 0),
    Position = UDim2.new(1, -12, 0, 14),
    Size = UDim2.fromOffset(30, 30),
    BackgroundColor3 = Color3.fromRGB(54, 61, 84),
    BorderSizePixel = 0,
    AutoButtonColor = true,
    Font = Enum.Font.GothamBold,
    Text = "X",
    TextColor3 = Color3.fromRGB(235, 238, 250),
    TextSize = 12,
}, topBar)
create("UICorner", { CornerRadius = UDim.new(0, 9) }, closeButton)

local status = create("TextLabel", {
    Name = "Status",
    Position = UDim2.fromOffset(19, 84),
    Size = UDim2.fromOffset(105, 24),
    BackgroundColor3 = Color3.fromRGB(54, 57, 72),
    BorderSizePixel = 0,
    Font = Enum.Font.GothamBold,
    Text = "DESACTIVADO",
    TextColor3 = Color3.fromRGB(190, 195, 210),
    TextSize = 9,
}, panel)
create("UICorner", { CornerRadius = UDim.new(1, 0) }, status)

create("TextLabel", {
    Name = "Description",
    Position = UDim2.fromOffset(19, 116),
    Size = UDim2.new(1, -38, 0, 43),
    BackgroundTransparency = 1,
    Font = Enum.Font.Gotham,
    Text = "Reduce efectos visuales para aliviar el trabajo\nde renderizado de tu dispositivo.",
    TextColor3 = Color3.fromRGB(190, 198, 218),
    TextSize = 11,
    TextWrapped = true,
    TextXAlignment = Enum.TextXAlignment.Left,
    TextYAlignment = Enum.TextYAlignment.Top,
}, panel)

local toggleButton = create("TextButton", {
    Name = "Toggle",
    Position = UDim2.new(0, 19, 1, -57),
    Size = UDim2.new(1, -38, 0, 39),
    BackgroundColor3 = Color3.fromRGB(78, 96, 170),
    BorderSizePixel = 0,
    AutoButtonColor = true,
    Font = Enum.Font.GothamBold,
    Text = "ACTIVAR MODO RENDIMIENTO",
    TextColor3 = Color3.fromRGB(255, 255, 255),
    TextSize = 11,
}, panel)
create("UICorner", { CornerRadius = UDim.new(0, 10) }, toggleButton)

create("TextLabel", {
    Name = "Footer",
    Position = UDim2.new(0, 19, 1, -17),
    Size = UDim2.new(1, -38, 0, 12),
    BackgroundTransparency = 1,
    Font = Enum.Font.Gotham,
    Text = "Solo efectos visuales locales · No modifica la velocidad",
    TextColor3 = Color3.fromRGB(125, 136, 164),
    TextSize = 8,
    TextXAlignment = Enum.TextXAlignment.Center,
}, panel)

local function updateInterface()
    if enabled then
        status.Text = "ACTIVO"
        status.BackgroundColor3 = Color3.fromRGB(35, 103, 79)
        status.TextColor3 = Color3.fromRGB(180, 255, 218)
        toggleButton.Text = "DESACTIVAR MODO RENDIMIENTO"
        toggleButton.BackgroundColor3 = Color3.fromRGB(48, 126, 96)
    else
        status.Text = "DESACTIVADO"
        status.BackgroundColor3 = Color3.fromRGB(54, 57, 72)
        status.TextColor3 = Color3.fromRGB(190, 195, 210)
        toggleButton.Text = "ACTIVAR MODO RENDIMIENTO"
        toggleButton.BackgroundColor3 = Color3.fromRGB(78, 96, 170)
    end
end

local function setPerformanceMode(state)
    if enabled == state then
        return
    end

    enabled = state
    scanVersion += 1
    local thisScan = scanVersion
    updateInterface()

    if not enabled then
        restoreEffects()
        return
    end

    task.spawn(function()
        local processed = 0
        local roots = { Workspace, Lighting }

        for _, root in ipairs(roots) do
            local descendants = root:GetDescendants()
            for _, instance in ipairs(descendants) do
                if not enabled or scanVersion ~= thisScan then
                    return
                end

                disableEffect(instance)
                processed += 1
                if processed % 250 == 0 then
                    task.wait()
                end
            end
        end
    end)
end

Workspace.DescendantAdded:Connect(function(instance)
    if enabled then
        disableEffect(instance)
    end
end)

Lighting.DescendantAdded:Connect(function(instance)
    if enabled then
        disableEffect(instance)
    end
end)

toggleButton.Activated:Connect(function()
    setPerformanceMode(not enabled)
end)

closeButton.Activated:Connect(function()
    setPerformanceMode(false)
    gui:Destroy()
end)

local dragging = false
local dragInput = nil
local dragStart = nil
local startPosition = nil

topBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPosition = panel.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

topBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input == dragInput
        or input.UserInputType == Enum.UserInputType.MouseMovement) then
        local delta = input.Position - dragStart
        panel.Position = UDim2.new(
            startPosition.X.Scale,
            startPosition.X.Offset + delta.X,
            startPosition.Y.Scale,
            startPosition.Y.Offset + delta.Y
        )
    end
end)

updateInterface()