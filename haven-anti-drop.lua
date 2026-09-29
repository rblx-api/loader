-- Script decrypted by channel: https://discord.gg/76wNYBeDxR
-- =====================================================
--  404 | HAVEN ANTI DROP (Compact Edition) + WIN DETECT
--  Diseño minimalista: Fondo negro y bordes morados
-- =====================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local Workspace = game:GetService("Workspace")
local LP = Players.LocalPlayer
local HttpRequest = request or http_request or (syn and syn.request) or nil

-- // THEME (Estilo de la imagen: Fondo negro, bordes/detalles morados)
local C_BORDER = Color3.fromRGB(150, 80, 220)
local C_PANEL = Color3.fromRGB(18, 14, 25)
local C_TEXT_TITLE = Color3.fromRGB(255, 255, 255)
local C_TEXT_SUB = Color3.fromRGB(180, 150, 210)
local C_INACTIVE = Color3.fromRGB(255, 80, 100)
local C_ACTIVE = Color3.fromRGB(100, 255, 120)
local C_TOGGLE_ON = Color3.fromRGB(220, 180, 255)
local C_TOGGLE_OFF = Color3.fromRGB(35, 28, 45)

local GUI_WIDTH = 200
local GUI_EXPANDED_HEIGHT = 190   -- Altura ajustada al quitar un botón
local GUI_COLLAPSED_HEIGHT = 35

-- // CONFIGURACIÓN (persistente)
local ConfigFile = "404_HavenAntiDrop_Config.json"
local Config = {
    Position = { X_Scale = 0.5, X_Offset = -100, Y_Scale = 0.5, Y_Offset = -100 },
    AntiDrop = false,
    AntiDie = false,
    HoldJump = false,
    IsCollapsed = false,
    GuiVisible = true
}

local function SaveConfig()
    if writefile then
        pcall(function() writefile(ConfigFile, HttpService:JSONEncode(Config)) end)
    end
end

local function LoadConfig()
    if isfile and isfile(ConfigFile) then
        local success, data = pcall(function() return HttpService:JSONDecode(readfile(ConfigFile)) end)
        if success and data then
            for k, v in pairs(data) do Config[k] = v end
        end
    end
end
LoadConfig()

-- // KEYBINDS
local Keys = {
    antiDie = Enum.KeyCode.X,
    guiHide = Enum.KeyCode.RightControl
}

-- =====================================================
--  CARTEL FLOTANTE (activado por ANTI DROP) - Solo texto
-- =====================================================
local billboardGui = nil
local billboardFrame = nil
local billboardUpdater = nil
local billboardCharAddedConn = nil

local function createBillboard(char)
    if not char then return end
    local head = char:FindFirstChild("Head")
    if not head then return end

    if billboardGui then billboardGui:Destroy() end
    if billboardUpdater then billboardUpdater:Disconnect(); billboardUpdater = nil end

    billboardGui = Instance.new("ScreenGui")
    billboardGui.Name = "404HavenAntiDropBillboard"
    billboardGui.ResetOnSpawn = false
    billboardGui.IgnoreGuiInset = true
    billboardGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    billboardGui.Parent = game:GetService("CoreGui")

    billboardFrame = Instance.new("Frame", billboardGui)
    billboardFrame.Size = UDim2.new(0, 180, 0, 36)
    billboardFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    billboardFrame.BackgroundTransparency = 0.3
    billboardFrame.BorderSizePixel = 0
    Instance.new("UICorner", billboardFrame).CornerRadius = UDim.new(0, 8)
    billboardFrame.Position = UDim2.new(0.5, -90, 0.5, -18)

    local txt1 = Instance.new("TextLabel", billboardFrame)
    txt1.Size = UDim2.new(1, 0, 1, 0)
    txt1.Position = UDim2.new(0, 0, 0, 0)
    txt1.BackgroundTransparency = 1
    txt1.Text = "HAVEN ANTI DROP"
    txt1.TextColor3 = Color3.fromRGB(255, 255, 255)
    txt1.Font = Enum.Font.GothamBlack
    txt1.TextSize = 15
    txt1.TextXAlignment = Enum.TextXAlignment.Center
    txt1.TextYAlignment = Enum.TextYAlignment.Center

    local camera = Workspace.CurrentCamera
    billboardUpdater = RunService.Heartbeat:Connect(function()
        if not billboardGui or not billboardGui.Parent then
            if billboardUpdater then billboardUpdater:Disconnect(); billboardUpdater = nil end
            return
        end
        if not head or not head.Parent then
            billboardFrame.Visible = false
            return
        end
        local pos, onScreen = camera:WorldToScreenPoint(head.Position)
        if onScreen then
            billboardFrame.Position = UDim2.new(0, pos.X - 90, 0, pos.Y - 30)
            billboardFrame.Visible = true
        else
            billboardFrame.Visible = false
        end
    end)
end

local function destroyBillboard()
    if billboardUpdater then
        billboardUpdater:Disconnect()
        billboardUpdater = nil
    end
    if billboardGui then
        billboardGui:Destroy()
        billboardGui = nil
    end
    billboardFrame = nil
    if billboardCharAddedConn then
        billboardCharAddedConn:Disconnect()
        billboardCharAddedConn = nil
    end
end

-- // Eliminar GUI antigua
for _, name in pairs({"404UI", "AntiDieUI", "VioletteTPBat", "404HavenBgPicker"}) do
    local old = game:GetService("CoreGui"):FindFirstChild(name)
    if old then old:Destroy() end
end

local gui = Instance.new("ScreenGui")
gui.Name = "404UI"
gui.ResetOnSpawn = false
gui.DisplayOrder = 10
gui.IgnoreGuiInset = true
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

if not pcall(function() gui.Parent = game:GetService("CoreGui") end) then
    gui.Parent = LP:WaitForChild("PlayerGui")
end

local main = Instance.new("Frame", gui)
main.Name = "Main"
main.Size = UDim2.new(0, GUI_WIDTH, 0, GUI_EXPANDED_HEIGHT)
main.Position = UDim2.new(Config.Position.X_Scale, Config.Position.X_Offset,
                          Config.Position.Y_Scale, Config.Position.Y_Offset)
main.BackgroundColor3 = Color3.fromRGB(10, 8, 15)
main.BackgroundTransparency = 0
main.BorderSizePixel = 0
main.Active = true
main.ClipsDescendants = true
main.ZIndex = 1
local mainCorner = Instance.new("UICorner", main)
mainCorner.CornerRadius = UDim.new(0, 12)

local mainStroke = Instance.new("UIStroke", main)
mainStroke.Color = C_BORDER
mainStroke.Thickness = 1.5
mainStroke.Transparency = 0.2

-- Arrastre
local dragging, dragInput, dragStart, mainStart = false, nil, nil, nil
main.InputBegan:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
        dragging = true; dragStart = inp.Position; mainStart = main.Position
        inp.Changed:Connect(function()
            if inp.UserInputState == Enum.UserInputState.End then 
                dragging = false
                Config.Position = {X_Scale = main.Position.X.Scale, X_Offset = main.Position.X.Offset, Y_Scale = main.Position.Y.Scale, Y_Offset = main.Position.Y.Offset}
                SaveConfig()
            end
        end)
    end
end)
main.InputChanged:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch then dragInput = inp end
end)
UIS.InputChanged:Connect(function(inp)
    if inp == dragInput and dragging then
        local dx = inp.Position.X - dragStart.X
        local dy = inp.Position.Y - dragStart.Y
        main.Position = UDim2.new(mainStart.X.Scale, mainStart.X.Offset+dx, mainStart.Y.Scale, mainStart.Y.Offset+dy)
    end
end)

-- CABECERA
local titleDot = Instance.new("Frame", main)
titleDot.Size = UDim2.new(0, 8, 0, 8)
titleDot.Position = UDim2.new(0, 12, 0, 10)
titleDot.BackgroundColor3 = C_BORDER
titleDot.BorderSizePixel = 0
titleDot.ZIndex = 5
Instance.new("UICorner", titleDot).CornerRadius = UDim.new(1, 0)

local titleLbl = Instance.new("TextLabel", main)
titleLbl.Size = UDim2.new(0, 150, 0, 16)
titleLbl.Position = UDim2.new(0, 26, 0, 4)
titleLbl.BackgroundTransparency = 1
titleLbl.Text = "HAVEN HUB"
titleLbl.TextColor3 = C_TEXT_TITLE
titleLbl.Font = Enum.Font.GothamBlack
titleLbl.TextSize = 13
titleLbl.TextXAlignment = Enum.TextXAlignment.Left
titleLbl.ZIndex = 5

local minBtn = Instance.new("TextButton", main)
minBtn.Size = UDim2.new(0, 20, 0, 20)
minBtn.Position = UDim2.new(1, -28, 0, 6)
minBtn.BackgroundColor3 = Color3.fromRGB(30, 20, 40)
minBtn.BackgroundTransparency = 0.5
minBtn.Text = "-"
minBtn.TextColor3 = C_TEXT_TITLE
minBtn.Font = Enum.Font.GothamBlack
minBtn.TextSize = 14
minBtn.ZIndex = 5
Instance.new("UICorner", minBtn).CornerRadius = UDim.new(0, 6)
minBtn.MouseButton1Click:Connect(function()
    Config.IsCollapsed = not Config.IsCollapsed
    local targetHeight = Config.IsCollapsed and GUI_COLLAPSED_HEIGHT or GUI_EXPANDED_HEIGHT
    TweenService:Create(main, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {
        Size = UDim2.new(0, GUI_WIDTH, 0, targetHeight)
    }):Play()
    SaveConfig()
end)

local function CreatePanel(yPos, height)
    local p = Instance.new("Frame", main)
    p.Size = UDim2.new(1, -16, 0, height)
    p.Position = UDim2.new(0, 8, 0, yPos)
    p.BackgroundColor3 = C_PANEL
    p.BackgroundTransparency = 0.3
    p.ZIndex = 4
    Instance.new("UICorner", p).CornerRadius = UDim.new(0, 10)
    
    local stroke = Instance.new("UIStroke", p)
    stroke.Color = C_BORDER
    stroke.Thickness = 1
    stroke.Transparency = 0.4
    return p
end

-- PANEL DE ESTADO
local statusPanel = CreatePanel(30, 20)
local statusDot = Instance.new("Frame", statusPanel)
statusDot.Size = UDim2.new(0, 6, 0, 6)
statusDot.Position = UDim2.new(0, 8, 0.5, -3)
statusDot.BackgroundColor3 = C_INACTIVE
statusDot.BorderSizePixel = 0
statusDot.ZIndex = 6
Instance.new("UICorner", statusDot).CornerRadius = UDim.new(1, 0)

local statusTxt = Instance.new("TextLabel", statusPanel)
statusTxt.Size = UDim2.new(0, 40, 1, 0)
statusTxt.Position = UDim2.new(0, 18, 0, 0)
statusTxt.BackgroundTransparency = 1
statusTxt.Text = "Status"
statusTxt.TextColor3 = C_TEXT_TITLE
statusTxt.Font = Enum.Font.GothamBold
statusTxt.TextSize = 10
statusTxt.TextXAlignment = Enum.TextXAlignment.Left
statusTxt.ZIndex = 6

local statusVal = Instance.new("TextLabel", statusPanel)
statusVal.Size = UDim2.new(0, 110, 1, 0)
statusVal.Position = UDim2.new(1, -115, 0, 0)
statusVal.BackgroundTransparency = 1
statusVal.Text = "OFF"
statusVal.TextColor3 = C_INACTIVE
statusVal.Font = Enum.Font.GothamBlack
statusVal.TextSize = 10
statusVal.TextXAlignment = Enum.TextXAlignment.Right
statusVal.ZIndex = 6

local function updateStatusPanel()
    local activeList = {}
    if Config.AntiDrop then table.insert(activeList, "1") end
    if Config.AntiDie then table.insert(activeList, "2") end
    if Config.HoldJump then table.insert(activeList, "3") end

    local activeCount = #activeList
    if activeCount > 0 then
        statusVal.Text = table.concat(activeList, " | ")
        statusVal.TextColor3 = C_ACTIVE
        statusDot.BackgroundColor3 = C_ACTIVE
    else
        statusVal.Text = "OFF"
        statusVal.TextColor3 = C_INACTIVE
        statusDot.BackgroundColor3 = C_INACTIVE
    end
end

local function CreateTogglePanel(yPos, labelText, subText, keybindText)
    local panel = CreatePanel(yPos, 38)
    
    local title = Instance.new("TextLabel", panel)
    title.Size = UDim2.new(0, 120, 0, 16)
    title.Position = UDim2.new(0, 10, 0, 4)
    title.BackgroundTransparency = 1
    title.Text = labelText
    title.TextColor3 = C_TEXT_TITLE
    title.Font = Enum.Font.GothamBlack
    title.TextSize = 11
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.ZIndex = 6

    local sub = Instance.new("TextLabel", panel)
    sub.Size = UDim2.new(0, 120, 0, 12)
    sub.Position = UDim2.new(0, 10, 0, 20)
    sub.BackgroundTransparency = 1
    sub.Text = subText
    sub.TextColor3 = C_TEXT_SUB
    sub.Font = Enum.Font.Gotham
    sub.TextSize = 8
    sub.TextXAlignment = Enum.TextXAlignment.Left
    sub.ZIndex = 6

    local keyLbl = nil
    if keybindText then
        keyLbl = Instance.new("TextLabel", panel)
        keyLbl.Size = UDim2.new(0, 25, 0, 16)
        keyLbl.Position = UDim2.new(1, -75, 0.5, -8)
        keyLbl.BackgroundTransparency = 1
        keyLbl.Text = keybindText
        keyLbl.TextColor3 = C_BORDER
        keyLbl.Font = Enum.Font.GothamBlack
        keyLbl.TextSize = 10
        keyLbl.ZIndex = 6
    end

    local toggleBg = Instance.new("Frame", panel)
    toggleBg.Size = UDim2.new(0, 36, 0, 18)
    toggleBg.Position = UDim2.new(1, -44, 0.5, -9)
    toggleBg.BackgroundColor3 = C_TOGGLE_OFF
    toggleBg.BorderSizePixel = 0
    toggleBg.ZIndex = 6
    Instance.new("UICorner", toggleBg).CornerRadius = UDim.new(1, 0)

    local toggleDot = Instance.new("Frame", toggleBg)
    toggleDot.Size = UDim2.new(0, 12, 0, 12)
    toggleDot.Position = UDim2.new(0, 3, 0.5, -6)
    toggleDot.BackgroundColor3 = C_TOGGLE_ON
    toggleDot.BorderSizePixel = 0
    toggleDot.ZIndex = 7
    Instance.new("UICorner", toggleDot).CornerRadius = UDim.new(1, 0)

    local btn = Instance.new("TextButton", panel)
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.BackgroundTransparency = 1
    btn.Text = ""
    btn.ZIndex = 10

    local function updateVisuals(state)
        TweenService:Create(toggleDot, TweenInfo.new(0.2, Enum.EasingStyle.Back), {
            Position = state and UDim2.new(1, -15, 0.5, -6) or UDim2.new(0, 3, 0.5, -6)
        }):Play()
        updateStatusPanel()
    end

    return panel, btn, updateVisuals, toggleDot, keyLbl
end

-- LÓGICA: ANTI DROP
local mt = getrawmetatable(game)
local oldIdx, oldNewIdx
local spoofedVelocity = Vector3.zero
local antiDropActive = false

local function startAntiDrop()
    if antiDropActive then return end
    if not mt then return end
    oldIdx = mt.__index
    oldNewIdx = mt.__newindex
    setreadonly(mt, false)
    mt.__index = newcclosure(function(self, key)
        if not checkcaller() and (key == "AssemblyLinearVelocity" or key == "Velocity") and
           typeof(self) == "Instance" and self:IsA("BasePart") and self.Name == "HumanoidRootPart" and
           self:IsDescendantOf(LP.Character) then
            return spoofedVelocity
        end
        return oldIdx(self, key)
    end)
    mt.__newindex = newcclosure(function(self, key, value)
        if not checkcaller() and (key == "AssemblyLinearVelocity" or key == "Velocity") and
           typeof(self) == "Instance" and self:IsA("BasePart") and self.Name == "HumanoidRootPart" and
           self:IsDescendantOf(LP.Character) then
            spoofedVelocity = value
            return
        end
        return oldNewIdx(self, key, value)
    end)
    setreadonly(mt, true)
    antiDropActive = true

    local char = LP.Character
    if char then createBillboard(char) end

    if billboardCharAddedConn then billboardCharAddedConn:Disconnect() end
    billboardCharAddedConn = LP.CharacterAdded:Connect(function(c)
        if Config.AntiDrop then
            task.wait(0.1)
            createBillboard(c)
        end
    end)
end

local function stopAntiDrop()
    if not antiDropActive then return end
    if mt and oldIdx then
        setreadonly(mt, false)
        mt.__index = oldIdx
        mt.__newindex = oldNewIdx
        setreadonly(mt, true)
        oldIdx = nil
        oldNewIdx = nil
    end
    antiDropActive = false
    destroyBillboard()
end

-- LÓGICA: ANTI DIE
local heartConn, deathConns, charAddedConn = nil, {}, nil

local function protectChar(character)
    if not character then return end
    local hum = character:WaitForChild("Humanoid", 5)
    if not hum then return end

    hum.MaxHealth = math.huge
    hum.Health = math.huge

    local sc = hum.StateChanged:Connect(function(_, new)
        if not Config.AntiDie then return end
        if new == Enum.HumanoidStateType.Dead then
            hum.Health = math.huge
            hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
        end
    end)
    table.insert(deathConns, sc)
    hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)

    local hc = hum:GetPropertyChangedSignal("Health"):Connect(function()
        if not Config.AntiDie then return end
        if hum.Health < hum.MaxHealth then hum.Health = math.huge end
    end)
    table.insert(deathConns, hc)

    if heartConn then heartConn:Disconnect() end
    heartConn = RunService.Heartbeat:Connect(function()
        if not Config.AntiDie then return end
        if hum and hum.Parent and hum.Health < hum.MaxHealth then hum.Health = math.huge end
    end)
end

local function startAntiDie()
    for _, c in ipairs(deathConns) do pcall(function() c:Disconnect() end) end
    deathConns = {}
    if heartConn then heartConn:Disconnect(); heartConn = nil end
    if charAddedConn then charAddedConn:Disconnect(); charAddedConn = nil end
    protectChar(LP.Character)
    charAddedConn = LP.CharacterAdded:Connect(function(c)
        if not Config.AntiDie then return end
        task.wait(0.1)
        for _, c2 in ipairs(deathConns) do pcall(function() c2:Disconnect() end) end
        deathConns = {}
        protectChar(c)
    end)
end

local function stopAntiDie()
    for _, c in ipairs(deathConns) do pcall(function() c:Disconnect() end) end
    deathConns = {}
    if heartConn then heartConn:Disconnect(); heartConn = nil end
    if charAddedConn then charAddedConn:Disconnect(); charAddedConn = nil end
    local char = LP.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            hum:SetStateEnabled(Enum.HumanoidStateType.Dead, true)
            hum.MaxHealth = 100
            hum.Health = 100
        end
    end
end

RunService.Heartbeat:Connect(function()
    if not Config.HoldJump then return end
    local char = LP.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local root = char:FindFirstChild("HumanoidRootPart")
    if root and hum and hum.Jump then
        root.Velocity = Vector3.new(root.Velocity.X, 55, root.Velocity.Z)
    end
end)

-- CONSTRUCCIÓN DE LOS 3 TOGGLES RESTANTES
local yPos = 54

-- 1. ANTI DROP
local panel1, btn1, update1, dot1, key1 = CreateTogglePanel(yPos, "ANTI DROP", "Previene caidas", nil)
update1(Config.AntiDrop)
btn1.MouseButton1Click:Connect(function()
    Config.AntiDrop = not Config.AntiDrop
    update1(Config.AntiDrop)
    if Config.AntiDrop then startAntiDrop() else stopAntiDrop() end
    SaveConfig()
end)

-- 2. ANTI DIE
local panel2, btn2, update2, dot2, key2 = CreateTogglePanel(yPos + 42, "ANTI DIE", "Previene muerte", Keys.antiDie.Name)
update2(Config.AntiDie)
btn2.MouseButton1Click:Connect(function()
    Config.AntiDie = not Config.AntiDie
    update2(Config.AntiDie)
    if Config.AntiDie then startAntiDie() else stopAntiDie() end
    SaveConfig()
end)

-- 3. HOLD JUMP
local panel3, btn3, update3, dot3, key3 = CreateTogglePanel(yPos + 84, "HOLD JUMP", "Super Salto", nil)
update3(Config.HoldJump)
btn3.MouseButton1Click:Connect(function()
    Config.HoldJump = not Config.HoldJump
    update3(Config.HoldJump)
    SaveConfig()
end)

if Config.AntiDrop then startAntiDrop() end
if Config.AntiDie then startAntiDie() end

updateStatusPanel()

if Config.IsCollapsed then
    main.Size = UDim2.new(0, GUI_WIDTH, 0, GUI_COLLAPSED_HEIGHT)
end
if not Config.GuiVisible then
    main.Visible = false
end

UIS.InputBegan:Connect(function(inp, gp)
    if gp then return end
    if inp.UserInputType == Enum.UserInputType.Keyboard then
        if inp.KeyCode == Keys.antiDie then
            Config.AntiDie = not Config.AntiDie
            update2(Config.AntiDie)
            if Config.AntiDie then startAntiDie() else stopAntiDie() end
            SaveConfig()
        elseif inp.KeyCode == Keys.guiHide then
            Config.GuiVisible = not Config.GuiVisible
            main.Visible = Config.GuiVisible
            SaveConfig()
        end
    end
end)

local kListening = false
local kConn = nil
local invisibleKeyBtn = Instance.new("TextButton", panel2)
invisibleKeyBtn.Size = UDim2.new(0, 30, 1, 0)
invisibleKeyBtn.Position = UDim2.new(1, -75, 0, 0)
invisibleKeyBtn.BackgroundTransparency = 1
invisibleKeyBtn.Text = ""
invisibleKeyBtn.ZIndex = 10
invisibleKeyBtn.MouseButton1Click:Connect(function()
    if kListening then return end
    kListening = true
    if key2 then key2.Text = "..." end
    kConn = UIS.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.Keyboard then
            Keys.antiDie = inp.KeyCode
            if key2 then key2.Text = inp.KeyCode.Name end
            kListening = false
            kConn:Disconnect()
        end
    end)
end)

print("404 | HAVEN - Sin TP Bat aplicado correctamente.")