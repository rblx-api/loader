-- Phantom Hub (Versión Visual y Utilitarios)
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local espEnabled = false
local espConnections = {}
local allowEspEnabled = false
local allowEspConnections = {}
local baseLockEspEnabled = false
local baseLockEspInstances = {}
local baseLockEspConn = nil
local xrayEnabled = false
local xrayOriginalTrans = {}
local xrayDescAddedConn = nil

-- === ESP DE JUGADORES ===
local function createESP(plr)
    if plr == LocalPlayer or not plr.Character then return end
    local char = plr.Character
    if char:FindFirstChild("Phantom_ESP_Hitbox") then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local head = char:FindFirstChild("Head")
    if not (hrp and head) then return end

    local hitbox = Instance.new("BoxHandleAdornment")
    hitbox.Name = "Phantom_ESP_Hitbox"
    hitbox.Adornee = hrp
    hitbox.Size = Vector3.new(4, 6, 2)
    hitbox.Color3 = Color3.fromRGB(128, 0, 128)
    hitbox.Transparency = 0.6
    hitbox.ZIndex = 10
    hitbox.AlwaysOnTop = true
    hitbox.Parent = char

    local billboard = Instance.new("BillboardGui")
    billboard.Name = "Phantom_ESP_Name"
    billboard.Adornee = head
    billboard.Size = UDim2.new(0, 200, 0, 50)
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = char

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = plr.DisplayName or plr.Name
    label.TextColor3 = Color3.fromRGB(255, 0, 255)
    label.Font = Enum.Font.Arcade
    label.TextScaled = true
    label.Parent = billboard
end

local function removeESP(plr)
    if not plr.Character then return end
    local hitbox = plr.Character:FindFirstChild("Phantom_ESP_Hitbox")
    local nameGui = plr.Character:FindFirstChild("Phantom_ESP_Name")
    if hitbox then hitbox:Destroy() end
    if nameGui then nameGui:Destroy() end
end

local function enableESP()
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            if plr.Character then createESP(plr) end
            local conn = plr.CharacterAdded:Connect(function()
                task.wait(0.1)
                if espEnabled then createESP(plr) end
            end)
            table.insert(espConnections, conn)
        end
    end
end

local function disableESP()
    for _, plr in ipairs(Players:GetPlayers()) do removeESP(plr) end
    for _, conn in ipairs(espConnections) do if conn.Connected then conn:Disconnect() end end
    espConnections = {}
end

-- === X-RAY ===
local function applyXrayToObj(obj)
    if obj:IsA("BasePart") and obj.Anchored then
        if not xrayOriginalTrans[obj] then
            xrayOriginalTrans[obj] = obj.LocalTransparencyModifier
        end
        obj.LocalTransparencyModifier = 0.5
    end
end

local function enableXRay()
    xrayEnabled = true
    for _, obj in ipairs(workspace:GetDescendants()) do applyXrayToObj(obj) end
    xrayDescAddedConn = workspace.DescendantAdded:Connect(function(obj)
        if xrayEnabled then applyXrayToObj(obj) end
    end)
end

local function disableXRay()
    xrayEnabled = false
    if xrayDescAddedConn then xrayDescAddedConn:Disconnect() end
    for part, value in pairs(xrayOriginalTrans) do
        if part and part.Parent then pcall(function() part.LocalTransparencyModifier = value end) end
    end
    xrayOriginalTrans = {}
end

-- === INTERFAZ GRÁFICA (GUI) ===
if PlayerGui:FindFirstChild("PhantomUI") then
    PlayerGui:FindFirstChild("PhantomUI"):Destroy()
end

local sg = Instance.new("ScreenGui")
sg.Name = "PhantomUI"
sg.ResetOnSpawn = false
sg.Parent = PlayerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 250, 0, 200)
frame.Position = UDim2.new(0.8, 0, 0.4, 0)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.BorderSizePixel = 0
frame.Parent = sg

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = frame

local title = Instance.new("TextLabel")
title.Text = "👻 Phantom Hub (Safe)"
title.Size = UDim2.new(1, 0, 0, 35)
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 14
title.Parent = frame

local function createToggle(text, yPos, callback)
    local btn = Instance.new("TextButton")
    btn.Text = text .. ": OFF"
    btn.Size = UDim2.new(0.9, 0, 0, 35)
    btn.Position = UDim2.new(0.05, 0, 0, yPos)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 12
    btn.Parent = frame
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = btn

    local state = false
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.Text = text .. (state and ": ON" or ": OFF")
        btn.BackgroundColor3 = state and Color3.fromRGB(0, 150, 70) or Color3.fromRGB(40, 40, 40)
        callback(state)
    end)
end

createToggle("Player ESP", 45, function(on)
    espEnabled = on
    if on then enableESP() else disableESP() end
end)

createToggle("X-Ray Base", 90, function(on)
    if on then enableXRay() else disableXRay() end
end)