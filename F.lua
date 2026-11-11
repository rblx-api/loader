local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local player = Players.LocalPlayer

local DEFAULT_SPEED = 21
local TAP_INTERVAL = 0.5
local CONFIG_FILE = "AutoSpd_" .. tostring(player.UserId) .. ".json"

-- Persiste datos en el almacenamiento local del executor, no solo en Attributes de la sesión.
local config = {}
if type(readfile) == "function" and type(isfile) == "function" then
    pcall(function()
        if isfile(CONFIG_FILE) then
            config = HttpService:JSONDecode(readfile(CONFIG_FILE))
        end
    end)
end
if type(config) ~= "table" then config = {} end

local function saveConfig()
    if type(writefile) ~= "function" then return end
    pcall(function()
        writefile(CONFIG_FILE, HttpService:JSONEncode(config))
    end)
end

local speed = math.clamp(tonumber(config.speed) or tonumber(player:GetAttribute("CarrySavedSpeed")) or DEFAULT_SPEED, 16, 30)
local enabled = player:GetAttribute("CarrySpeedEnabled") == true
local locked = true
local minimized = config.minimized == true

local originalSpeed = player:GetAttribute("CarryOriginalWalkSpeed") or 16

local taps = 0
local lastTap = 0

local gui = Instance.new("ScreenGui")
gui.Name = "CarrySpeedPanel"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local function corner(obj, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius)
    c.Parent = obj
end

local function makeButton(parent, text, size, pos)
    local b = Instance.new("TextButton")
    b.Size = size
    b.Position = pos
    b.Text = text
    b.TextSize = 12
    b.TextColor3 = Color3.new(1,1,1)
    b.BackgroundColor3 = Color3.fromRGB(48,48,58)
    b.BorderSizePixel = 0
    b.Parent = parent
    corner(b,5)
    return b
end

-- PANEL
local panel = Instance.new("Frame")
panel.Size = UDim2.fromOffset(150,60)
panel.AnchorPoint = Vector2.new(0.5,0.5)
panel.Position = UDim2.fromScale(0.5,0.5)
panel.BackgroundColor3 = Color3.fromRGB(25,25,30)
panel.BorderSizePixel = 0
panel.Parent = gui
panel.Visible = not minimized
corner(panel,8)

local savedPanelX = tonumber(config.panelX) or player:GetAttribute("CarryPanelX")
local savedPanelY = tonumber(config.panelY) or player:GetAttribute("CarryPanelY")

if savedPanelX and savedPanelY then
    panel.Position = UDim2.fromOffset(savedPanelX,savedPanelY)
end

local title = Instance.new("TextLabel")
title.Size = UDim2.fromOffset(60,22)
title.Position = UDim2.fromOffset(5,5)
title.BackgroundTransparency = 1
title.Text = "SPEED"
title.TextColor3 = Color3.new(1,1,1)
title.TextSize = 12
title.Parent = panel

local lockButton = makeButton(
    panel,"Lock",
    UDim2.fromOffset(48,20),
    UDim2.fromOffset(72,6)
)
lockButton.TextSize = 9

local minimize = makeButton(
    panel,"-",
    UDim2.fromOffset(20,20),
    UDim2.fromOffset(125,5)
)

local speedBox = Instance.new("TextBox")
speedBox.Size = UDim2.fromOffset(140,22)
speedBox.Position = UDim2.fromOffset(5,33)
speedBox.BackgroundColor3 = Color3.fromRGB(40,40,48)
speedBox.TextColor3 = Color3.new(1,1,1)
speedBox.Text = tostring(speed)
speedBox.TextSize = 12
speedBox.ClearTextOnFocus = false
speedBox.Parent = panel
corner(speedBox,5)

-- BOTÓN FLOTANTE
local toggle = Instance.new("TextButton")
toggle.Size = UDim2.fromOffset(30,30)
toggle.AnchorPoint = Vector2.new(0.5,0.5)
toggle.BackgroundTransparency = 1
toggle.BorderSizePixel = 0
toggle.TextSize = 9
toggle.Parent = gui
toggle.Visible = true
toggle.Active = true

local savedToggleX = tonumber(config.toggleX) or player:GetAttribute("CarryToggleX")
local savedToggleY = tonumber(config.toggleY) or player:GetAttribute("CarryToggleY")

if savedToggleX and savedToggleY then
    toggle.Position = UDim2.fromOffset(savedToggleX,savedToggleY)
else
    toggle.Position = UDim2.new(0.5,-15,0.5,-15)
end

local function updateToggle()
    toggle.Text = enabled and "ON" or "OFF"
    toggle.TextColor3 = enabled
        and Color3.fromRGB(0,255,100)
        or Color3.fromRGB(255,60,60)
end

updateToggle()

-- DETECCIÓN DE CARRY / STEAL (misma lógica de AumDuels)
local baselineHumanoid = nil
local baselineWalkSpeed = nil
local carryAttachment = nil
local carryVelocity = nil

local function readCarryFlag(container, name)
    if not container then return false end
    local ok, value = pcall(function() return container:GetAttribute(name) end)
    if ok and value == true then return true end

    local obj = container:FindFirstChild(name)
    if obj then
        if obj:IsA("BoolValue") then return obj.Value == true end
        if obj:IsA("ObjectValue") then return obj.Value ~= nil end
        if obj:IsA("StringValue") then return obj.Value ~= "" end
    end
    return false
end

local function isCarrying()
    local char = player.Character
    if not char then return false end

    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return false end

    local ws = hum.WalkSpeed
    if baselineHumanoid ~= hum then
        baselineHumanoid = hum
        baselineWalkSpeed = ws
    elseif not enabled and ws > (baselineWalkSpeed or ws) then
        baselineWalkSpeed = ws
    end

    local base = baselineWalkSpeed or ws
    local bySpeed = ws > 0 and base > 0
        and ws <= base * 0.95 and (base - ws) >= 1

    local byFlag = false
    for _, name in ipairs({
        "Stealing", "Carrying", "IsCarrying", "Grabbed",
        "Holding", "StealHold", "HasGrab"
    }) do
        if readCarryFlag(player, name) or readCarryFlag(char, name) then
            byFlag = true
            break
        end
    end

    return bySpeed or byFlag
end

local function destroyCarryVelocity()
    if carryVelocity then pcall(function() carryVelocity:Destroy() end) end
    if carryAttachment then pcall(function() carryAttachment:Destroy() end) end
    carryVelocity = nil
    carryAttachment = nil
end

local function applySpeed()
    local char = player.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    local root = char and char:FindFirstChild("HumanoidRootPart")

    if not hum or not root then
        destroyCarryVelocity()
        return
    end

    -- El botón ON arma el detector: al agarrar el objeto, Speed entra solo.
    local carrying = isCarrying()
    if not enabled or not carrying then
        if carryVelocity then
            carryVelocity.PlaneVelocity = Vector2.zero
            carryVelocity.Enabled = false
        end
        return
    end

    -- No interferir con estados de caída ni con Bat Bypass.
    local state = hum:GetState()
    local ragdolled = state == Enum.HumanoidStateType.Physics
        or state == Enum.HumanoidStateType.Ragdoll
        or state == Enum.HumanoidStateType.FallingDown
    local snowVS = _G.SnowVS
    local batBypassActive = snowVS and snowVS.BatBypass
        and snowVS.BatBypass.Enabled == true

    if ragdolled or batBypassActive then
        if carryVelocity then
            carryVelocity.PlaneVelocity = Vector2.zero
            carryVelocity.Enabled = false
        end
        return
    end

    if not carryVelocity or carryVelocity.Parent ~= root then
        destroyCarryVelocity()
        carryAttachment = Instance.new("Attachment")
        carryAttachment.Name = "SpeedCarryAttachment"
        carryAttachment.Parent = root

        carryVelocity = Instance.new("LinearVelocity")
        carryVelocity.Name = "SpeedCarryVelocity"
        carryVelocity.Attachment0 = carryAttachment
        carryVelocity.VelocityConstraintMode = Enum.VelocityConstraintMode.Plane
        carryVelocity.PrimaryTangentAxis = Vector3.new(1, 0, 0)
        carryVelocity.SecondaryTangentAxis = Vector3.new(0, 0, 1)
        carryVelocity.RelativeTo = Enum.ActuatorRelativeTo.World
        carryVelocity.MaxForce = 2200
        carryVelocity.PlaneVelocity = Vector2.zero
        carryVelocity.Parent = root
    end

    carryVelocity.Enabled = true
    local direction = hum.MoveDirection
    if direction.Magnitude > 0.1 then
        local flat = Vector3.new(direction.X, 0, direction.Z).Unit
        carryVelocity.PlaneVelocity = Vector2.new(flat.X * speed, flat.Z * speed)
    else
        carryVelocity.PlaneVelocity = Vector2.zero
    end
end

local function setEnabled(value)
    enabled = value
    player:SetAttribute("CarrySpeedEnabled", enabled)
    updateToggle()
    if not enabled then
        destroyCarryVelocity()
    else
        applySpeed()
    end
end

speedBox.FocusLost:Connect(function()
    local n = tonumber(speedBox.Text)

    if n then
        speed = math.clamp(n,16,30)
        speedBox.Text = tostring(speed)
        player:SetAttribute("CarrySavedSpeed",speed)
        config.speed = speed
        saveConfig()

        if enabled then
            applySpeed()
        end
    else
        speedBox.Text = tostring(speed)
    end
end)

-- LOCK / UNLOCK
lockButton.Activated:Connect(function()
    locked = not locked
    lockButton.Text = locked and "Lock" or "UnLock"
    lockButton.TextSize = locked and 9 or 7
end)

-- MINIMIZAR
minimize.Activated:Connect(function()
    minimized = true
    panel.Visible = false
    toggle.Visible = true
    config.minimized = true
    saveConfig()
end)

-- ARRASTRE DEL BOTÓN FLOTANTE
local dragging = false
local dragInput
local dragStart
local startPos
local moved = false
local suppressClick = false

toggle.InputBegan:Connect(function(input)
    if locked then return end

    if input.UserInputType == Enum.UserInputType.Touch
    or input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragInput = input
        dragStart = input.Position
        startPos = toggle.Position
        moved = false
    end
end)

UIS.InputChanged:Connect(function(input)
    if not dragging or locked then return end

    local valid =
        (dragInput.UserInputType == Enum.UserInputType.Touch and input == dragInput)
        or
        (dragInput.UserInputType == Enum.UserInputType.MouseButton1
        and input.UserInputType == Enum.UserInputType.MouseMovement)

    if not valid then return end

    local delta = input.Position - dragStart

    if delta.Magnitude > 5 then
        moved = true
    end

    if moved then
        toggle.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

UIS.InputEnded:Connect(function(input)
    if dragging and (
        input == dragInput or
        (dragInput.UserInputType == Enum.UserInputType.MouseButton1
        and input.UserInputType == Enum.UserInputType.MouseButton1)
    ) then
        dragging = false
        dragInput = nil

        if moved then
            local p = toggle.AbsolutePosition
            local s = toggle.AbsoluteSize

            player:SetAttribute("CarryToggleX",p.X + s.X/2)
            player:SetAttribute("CarryToggleY",p.Y + s.Y/2)
            config.toggleX = p.X + s.X/2
            config.toggleY = p.Y + s.Y/2
            saveConfig()

            suppressClick = true

            task.delay(0.2,function()
                suppressClick = false
                moved = false
            end)
        end
    end
end)

-- ARRASTRE DEL PANEL (DESDE EL TÍTULO)
local panelDragging = false
local panelInput
local panelDragStart
local panelStartPos
local panelMoved = false

title.InputBegan:Connect(function(input)
    if locked then return end

    if input.UserInputType == Enum.UserInputType.Touch
    or input.UserInputType == Enum.UserInputType.MouseButton1 then
        panelDragging = true
        panelInput = input
        panelDragStart = input.Position
        panelStartPos = panel.Position
        panelMoved = false
    end
end)

UIS.InputChanged:Connect(function(input)
    if not panelDragging or locked then return end

    local valid =
        (panelInput.UserInputType == Enum.UserInputType.Touch and input == panelInput)
        or
        (panelInput.UserInputType == Enum.UserInputType.MouseButton1
        and input.UserInputType == Enum.UserInputType.MouseMovement)

    if not valid then return end

    local delta = input.Position - panelDragStart

    if delta.Magnitude > 5 then
        panelMoved = true
    end

    if panelMoved then
        panel.Position = UDim2.new(
            panelStartPos.X.Scale,
            panelStartPos.X.Offset + delta.X,
            panelStartPos.Y.Scale,
            panelStartPos.Y.Offset + delta.Y
        )
    end
end)

UIS.InputEnded:Connect(function(input)
    if panelDragging and (
        input == panelInput or
        (panelInput.UserInputType == Enum.UserInputType.MouseButton1
        and input.UserInputType == Enum.UserInputType.MouseButton1)
    ) then
        panelDragging = false
        panelInput = nil

        if panelMoved then
            local p = panel.AbsolutePosition
            local s = panel.AbsoluteSize

            player:SetAttribute("CarryPanelX",p.X + s.X/2)
            player:SetAttribute("CarryPanelY",p.Y + s.Y/2)
            config.panelX = p.X + s.X/2
            config.panelY = p.Y + s.Y/2
            saveConfig()
        end

        panelMoved = false
    end
end)

-- TRIPLE TOQUE
toggle.Activated:Connect(function()
    if suppressClick or moved then return end

    local now = os.clock()

    if now - lastTap > TAP_INTERVAL then
        taps = 0
    end

    taps += 1
    lastTap = now

    if taps >= 3 then
        taps = 0
        panel.Visible = true
        toggle.Visible = true
        minimized = false
        config.minimized = false
        saveConfig()
        return
    end

    setEnabled(not enabled)
end)

-- REAPARICIÓN
local function setupCharacter(char)
    task.spawn(function()
        local hum = char:WaitForChild("Humanoid",0.2)

        if not hum then
            hum = char:WaitForChild("Humanoid")
        end

        baselineHumanoid = hum
        baselineWalkSpeed = hum.WalkSpeed
        if enabled then
            applySpeed()
        end
    end)
end

player.CharacterAdded:Connect(function(char)
    destroyCarryVelocity()
    baselineHumanoid = nil
    baselineWalkSpeed = nil
    setupCharacter(char)
end)

task.spawn(function()
    while gui.Parent do
        if enabled then
            applySpeed()
        elseif carryVelocity then
            destroyCarryVelocity()
        end
        task.wait(0.05)
    end
end)

if player.Character then
    setupCharacter(player.Character)
end