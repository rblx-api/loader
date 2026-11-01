CHOCOLA - SISTEMA COMPLETO PARA ROBLOX
======================================

Incluye:
- AutoBuy: compra automáticamente el ProximityPrompt válido más cercano.
- AntiMove: bloquea/restaura el movimiento local del personaje.
- AntiLag: desactiva/restaura efectos visuales localmente.
- UI moderna, arrastrable con ratón o dedo y minimizable.
- Validación de compras en servidor. No utiliza webhooks, loggers ni servicios externos.

IMPORTANTE
----------
Este sistema está preparado para una experiencia de Roblox que tú desarrollas en Roblox Studio.
No es un script para ejecutores ni para modificar juegos de otras personas.

INSTALACIÓN
-----------
1. En ServerScriptService crea un Script llamado ChocolaServer.
   Pega en él la sección "SCRIPT 1".

2. En StarterPlayer > StarterPlayerScripts crea un LocalScript llamado ChocolaClient.
   Pega en él la sección "SCRIPT 2".

3. Para cada objeto que quieras vender:
   - Debe tener un ProximityPrompt dentro de una BasePart o Attachment.
   - Al ProximityPrompt añádele estos Attributes:
       Price  -> Number (precio)
       ItemId -> String (nombre/identificador del objeto)
   - El jugador debe tener leaderstats con un IntValue llamado Coins o Cash.
   - Opcional: para entregar una Tool, coloca una Tool en
     ServerStorage > ShopItems y ponle el mismo nombre que ItemId.
   - Si no existe esa Tool, la compra se registra en
     player.ChocolaInventory como un IntValue.

No cambies los nombres de los scripts ni los nombres de los Attributes.

============================================================
SCRIPT 1 - ChocolaServer.server.lua
Ubicación: ServerScriptService > ChocolaServer
============================================================

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local Workspace = game:GetService("Workspace")

local REMOTE_NAME = "ChocolaRemote"
local SCAN_INTERVAL = 0.5
local PURCHASE_COOLDOWN = 1.25
local MAX_DISTANCE_BUFFER = 1.5

local remote = ReplicatedStorage:FindFirstChild(REMOTE_NAME)
if not remote then
    remote = Instance.new("RemoteEvent")
    remote.Name = REMOTE_NAME
    remote.Parent = ReplicatedStorage
end

local shopItems = ServerStorage:FindFirstChild("ShopItems")
local active = {}
local lastPurchase = {}

local function getPromptPosition(prompt)
    local parent = prompt.Parent
    if not parent then
        return nil
    end

    if parent:IsA("Attachment") then
        return parent.WorldPosition
    end

    if parent:IsA("BasePart") then
        return parent.Position
    end

    if parent:IsA("Model") then
        return parent:GetPivot().Position
    end

    return nil
end

local function getCurrency(player)
    local leaderstats = player:FindFirstChild("leaderstats")
    if not leaderstats then
        return nil
    end

    local coins = leaderstats:FindFirstChild("Coins")
    local cash = leaderstats:FindFirstChild("Cash")
    local currency = coins or cash

    if currency and (currency:IsA("IntValue") or currency:IsA("NumberValue")) then
        return currency
    end

    return nil
end

local function getInventory(player)
    local inventory = player:FindFirstChild("ChocolaInventory")
    if not inventory then
        inventory = Instance.new("Folder")
        inventory.Name = "ChocolaInventory"
        inventory.Parent = player
    end
    return inventory
end

local function registerItem(player, itemId)
    local inventory = getInventory(player)
    local itemValue = inventory:FindFirstChild(itemId)

    if not itemValue then
        itemValue = Instance.new("IntValue")
        itemValue.Name = itemId
        itemValue.Value = 0
        itemValue.Parent = inventory
    end

    itemValue.Value += 1
end

local function getNearestPrompt(player)
    local character = player.Character
    local root = character and character:FindFirstChild("HumanoidRootPart")
    if not root then
        return nil
    end

    local nearestPrompt = nil
    local nearestDistance = math.huge

    for _, instance in ipairs(Workspace:GetDescendants()) do
        if instance:IsA("ProximityPrompt") and instance.Enabled then
            local price = instance:GetAttribute("Price")
            local itemId = instance:GetAttribute("ItemId")
            local position = getPromptPosition(instance)

            if typeof(price) == "number"
                and price >= 0
                and typeof(itemId) == "string"
                and itemId ~= ""
                and position then

                local distance = (root.Position - position).Magnitude
                local allowedDistance = instance.MaxActivationDistance + MAX_DISTANCE_BUFFER

                if distance <= allowedDistance and distance < nearestDistance then
                    nearestDistance = distance
                    nearestPrompt = instance
                end
            end
        end
    end

    return nearestPrompt
end

local function purchase(player, prompt)
    if not prompt or not prompt.Parent or not prompt:IsDescendantOf(Workspace) then
        return
    end

    if not prompt:IsA("ProximityPrompt") or not prompt.Enabled then
        return
    end

    local price = prompt:GetAttribute("Price")
    local itemId = prompt:GetAttribute("ItemId")

    if typeof(price) ~= "number" or price < 0 or price ~= price then
        return
    end

    if typeof(itemId) ~= "string" or itemId == "" or #itemId > 80 then
        return
    end

    local character = player.Character
    local root = character and character:FindFirstChild("HumanoidRootPart")
    local position = getPromptPosition(prompt)

    if not root or not position then
        return
    end

    local distance = (root.Position - position).Magnitude
    if distance > prompt.MaxActivationDistance + MAX_DISTANCE_BUFFER then
        return
    end

    local playerPurchases = lastPurchase[player]
    if not playerPurchases then
        playerPurchases = {}
        lastPurchase[player] = playerPurchases
    end

    local now = os.clock()
    if playerPurchases[prompt] and now - playerPurchases[prompt] < PURCHASE_COOLDOWN then
        return
    end

    local currency = getCurrency(player)
    if not currency or currency.Value < price then
        return
    end

    playerPurchases[prompt] = now
    currency.Value -= price

    local tool = shopItems and shopItems:FindFirstChild(itemId)
    if tool and tool:IsA("Tool") then
        local backpack = player:FindFirstChildOfClass("Backpack")
        if backpack then
            tool:Clone().Parent = backpack
        else
            registerItem(player, itemId)
        end
    else
        registerItem(player, itemId)
    end
end

local function stopAutoBuy(player)
    active[player] = nil
end

remote.OnServerEvent:Connect(function(player, action, enabled)
    if action ~= "AutoBuy" or typeof(enabled) ~= "boolean" then
        return
    end

    if not enabled then
        stopAutoBuy(player)
        return
    end

    if active[player] then
        return
    end

    active[player] = true

    task.spawn(function()
        while active[player] and player.Parent == Players do
            local prompt = getNearestPrompt(player)
            if prompt then
                purchase(player, prompt)
            end
            task.wait(SCAN_INTERVAL)
        end
        active[player] = nil
    end)
end)

Players.PlayerRemoving:Connect(function(player)
    active[player] = nil
    lastPurchase[player] = nil
end)


============================================================
SCRIPT 2 - ChocolaClient.client.lua
Ubicación: StarterPlayer > StarterPlayerScripts > ChocolaClient
============================================================

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local remote = ReplicatedStorage:WaitForChild("ChocolaRemote")

local autoBuyEnabled = false
local antiMoveEnabled = false
local antiLagEnabled = false

local savedMovement = {}
local movementHumanoid = nil
local visualCache = {}

local function getHumanoid()
    local character = player.Character
    return character and character:FindFirstChildOfClass("Humanoid")
end

local function applyAntiMove()
    local humanoid = getHumanoid()
    if not humanoid then
        return
    end

    if movementHumanoid ~= humanoid then
        movementHumanoid = humanoid
        savedMovement = {
            WalkSpeed = humanoid.WalkSpeed,
            JumpPower = humanoid.JumpPower,
            JumpHeight = humanoid.JumpHeight,
            AutoRotate = humanoid.AutoRotate,
            UseJumpPower = humanoid.UseJumpPower
        }
    end

    if antiMoveEnabled then
        humanoid.WalkSpeed = 0
        humanoid.JumpPower = 0
        humanoid.JumpHeight = 0
        humanoid.AutoRotate = false
    end
end

local function restoreMovement()
    local humanoid = getHumanoid()
    if not humanoid or humanoid ~= movementHumanoid then
        return
    end

    if savedMovement.WalkSpeed ~= nil then
        humanoid.WalkSpeed = savedMovement.WalkSpeed
        humanoid.JumpPower = savedMovement.JumpPower
        humanoid.JumpHeight = savedMovement.JumpHeight
        humanoid.AutoRotate = savedMovement.AutoRotate
        humanoid.UseJumpPower = savedMovement.UseJumpPower
    end
end

local function isVisualEffect(instance)
    return instance:IsA("ParticleEmitter")
        or instance:IsA("Trail")
        or instance:IsA("Beam")
        or instance:IsA("Fire")
        or instance:IsA("Smoke")
        or instance:IsA("Sparkles")
        or instance:IsA("PostEffect")
        or instance:IsA("PointLight")
        or instance:IsA("SpotLight")
        or instance:IsA("SurfaceLight")
end

local function setEffect(instance, enabled)
    if not isVisualEffect(instance) then
        return
    end

    if enabled then
        if visualCache[instance] == nil then
            visualCache[instance] = instance.Enabled
        end
        instance.Enabled = false
    else
        local oldValue = visualCache[instance]
        if oldValue ~= nil and instance.Parent then
            instance.Enabled = oldValue
        end
        visualCache[instance] = nil
    end
end

local function applyAntiLag()
    if antiLagEnabled then
        for _, instance in ipairs(Workspace:GetDescendants()) do
            setEffect(instance, true)
        end
        for _, instance in ipairs(Lighting:GetDescendants()) do
            setEffect(instance, true)
        end
    else
        for instance, oldValue in pairs(visualCache) do
            if instance and instance.Parent then
                instance.Enabled = oldValue
            end
            visualCache[instance] = nil
        end
    end
end

Workspace.DescendantAdded:Connect(function(instance)
    if antiLagEnabled then
        task.defer(function()
            if instance.Parent then
                setEffect(instance, true)
            end
        end)
    end
end)

Lighting.DescendantAdded:Connect(function(instance)
    if antiLagEnabled then
        task.defer(function()
            if instance.Parent then
                setEffect(instance, true)
            end
        end)
    end
end)

player.CharacterAdded:Connect(function()
    task.wait(0.25)
    movementHumanoid = nil
    savedMovement = {}
    if antiMoveEnabled then
        applyAntiMove()
    end
end)

-- Interfaz
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ChocolaUI"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.Parent = player:WaitForChild("PlayerGui")

local main = Instance.new("Frame")
main.Name = "Main"
main.Size = UDim2.fromOffset(270, 220)
main.Position = UDim2.new(0.5, -135, 0.5, -110)
main.BackgroundColor3 = Color3.fromRGB(25, 25, 34)
main.BorderSizePixel = 0
main.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 12)
mainCorner.Parent = main

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(150, 105, 255)
stroke.Thickness = 1.5
stroke.Parent = main

local header = Instance.new("Frame")
header.Name = "Header"
header.Size = UDim2.new(1, 0, 0, 42)
header.BackgroundColor3 = Color3.fromRGB(42, 35, 58)
header.BorderSizePixel = 0
header.Parent = main

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 12)
headerCorner.Parent = header

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -55, 1, 0)
title.Position = UDim2.fromOffset(13, 0)
title.BackgroundTransparency = 1
title.Text = "CHOCola"
title.TextColor3 = Color3.fromRGB(245, 240, 255)
title.TextSize = 18
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = header

local minimize = Instance.new("TextButton")
minimize.Size = UDim2.fromOffset(32, 28)
minimize.Position = UDim2.new(1, -39, 0, 7)
minimize.BackgroundColor3 = Color3.fromRGB(100, 72, 150)
minimize.Text = "−"
minimize.TextColor3 = Color3.new(1, 1, 1)
minimize.TextSize = 22
minimize.Font = Enum.Font.GothamBold
minimize.Parent = header

local minCorner = Instance.new("UICorner")
minCorner.CornerRadius = UDim.new(0, 7)
minCorner.Parent = minimize

local buttonsFrame = Instance.new("Frame")
buttonsFrame.Name = "Buttons"
buttonsFrame.Size = UDim2.new(1, -24, 1, -58)
buttonsFrame.Position = UDim2.fromOffset(12, 50)
buttonsFrame.BackgroundTransparency = 1
buttonsFrame.Parent = main

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 9)
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Parent = buttonsFrame

local function createToggle(labelText, order, callback)
    local button = Instance.new("TextButton")
    button.Name = labelText:gsub("%s+", "") .. "Button"
    button.Size = UDim2.new(1, 0, 0, 43)
    button.BackgroundColor3 = Color3.fromRGB(53, 48, 66)
    button.BorderSizePixel = 0
    button.TextColor3 = Color3.fromRGB(240, 238, 248)
    button.TextSize = 14
    button.Font = Enum.Font.GothamSemibold
    button.LayoutOrder = order
    button.Parent = buttonsFrame

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = button

    local enabled = false

    local function update()
        button.Text = labelText .. ": " .. (enabled and "ON" or "OFF")
        button.BackgroundColor3 = enabled
            and Color3.fromRGB(92, 65, 145)
            or Color3.fromRGB(53, 48, 66)
    end

    button.Activated:Connect(function()
        enabled = not enabled
        update()
        callback(enabled)
    end)

    update()
    return button
end

createToggle("AutoBuy", 1, function(enabled)
    autoBuyEnabled = enabled
    remote:FireServer("AutoBuy", enabled)
end)

createToggle("AntiMove", 2, function(enabled)
    antiMoveEnabled = enabled
    if enabled then
        applyAntiMove()
    else
        restoreMovement()
    end
end)

createToggle("AntiLag", 3, function(enabled)
    antiLagEnabled = enabled
    applyAntiLag()
end)

local minimized = false
minimize.Activated:Connect(function()
    minimized = not minimized
    buttonsFrame.Visible = not minimized
    main.Size = minimized and UDim2.fromOffset(270, 42) or UDim2.fromOffset(270, 220)
    minimize.Text = minimized and "+" or "−"
end)

-- Arrastrar la ventana con ratón o pantalla táctil
local dragging = false
local dragInput = nil
local dragStart = nil
local startPosition = nil

header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPosition = main.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

header.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input == dragInput or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        main.Position = UDim2.new(
            startPosition.X.Scale,
            startPosition.X.Offset + delta.X,
            startPosition.Y.Scale,
            startPosition.Y.Offset + delta.Y
        )
    end
end)

-- Si el jugador activa AntiMove antes de que aparezca su personaje,
-- el bloqueo se aplica cuando el personaje esté listo.
if antiMoveEnabled then
    applyAntiMove()
end

print("[Chocola] UI cargada correctamente.")


============================================================
COMPROBACIONES Y LIMITACIONES
============================================================

- AutoBuy solo compra objetos que tengan los Attributes Price e ItemId configurados.
- La compra se valida en el servidor: distancia, prompt activo, precio y saldo.
- Si el juego usa otra moneda, cambia getCurrency en el Script 1 para usar el nombre real.
- AntiMove solo afecta al personaje local; no es un sistema de inmovilización de servidor.
- AntiLag desactiva efectos visuales localmente y restaura los valores que tenían al activarse.
- AntiLag no garantiza más FPS en todos los dispositivos; depende de qué esté causando el rendimiento bajo.
- El sistema no puede entregar una Tool si no existe en ServerStorage > ShopItems con el mismo nombre de ItemId.
- Prueba primero en una copia de tu experiencia y revisa la ventana Output de Roblox Studio si aparece algún error.

FIN