-- [[ HAVEN HUB - PARTE 1 DE 3 ]]
if _G.HavenHubRunning then return end
_G.HavenHubRunning = true

repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local TS = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local HS = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local LP = Players.LocalPlayer
local camera = workspace.CurrentCamera

-- CACHÉ DE SERVICIOS
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

local _GetPlayersCached
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

-- CONFIGURACIÓN DE APARIENCIA
NS = 60
CS = 29
LAGGER_SPEED = 15
LAGGER_CARRY_SPEED = 24.5
CONFIG_FILE = "HavenHub.json"

BACKGROUND_COLOR = Color3.fromRGB(0, 0, 0) -- Fondo Negro
DEFAULT_THEME_COLOR = Color3.fromRGB(160, 100, 220) -- Morado Neón

-- ESTILO DE LETRA NEÓN HUECA (HAVEN HUB)
function applyHavenHubTextStyle(textLabel, textString, fontSize, strokeColor)
    if not textLabel or (not textLabel:IsA("TextLabel") and not textLabel:IsA("TextButton")) then return end

    if textString then textLabel.Text = textString end
    textLabel.Font = Enum.Font.Michroma
    if fontSize then textLabel.TextSize = fontSize end
    textLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
    textLabel.TextTransparency = 0.85
    textLabel.BackgroundTransparency = 1

    local oldStroke = textLabel:FindFirstChild("HavenHubStroke")
    if oldStroke then oldStroke:Destroy() end

    local stroke = Instance.new("UIStroke")
    stroke.Name = "HavenHubStroke"
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual
    stroke.Color = strokeColor or DEFAULT_THEME_COLOR
    stroke.Thickness = 2
    stroke.LineJoinMode = Enum.LineJoinMode.Round
    stroke.Transparency = 0
    stroke.Parent = textLabel

    local oldGrad = stroke:FindFirstChild("HavenHubGrad")
    if oldGrad then oldGrad:Destroy() end

    local gradient = Instance.new("UIGradient")
    gradient.Name = "HavenHubGrad"
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0.00, strokeColor or DEFAULT_THEME_COLOR),
        ColorSequenceKeypoint.new(0.50, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(1.00, strokeColor or DEFAULT_THEME_COLOR)
    })
    gradient.Parent = stroke
end

-- MOTOR DE MOVIMIENTO Y CARRY
CarrySystem = {
    normalSpeed = NS,
    carrySpeed = CS,
    laggerSpeed = LAGGER_SPEED,
    laggerCarrySpeed = LAGGER_CARRY_SPEED,
    speedToggled = false,
    laggerMode = 0,
    softStealEnabled = false,
    softStealRadius = 10,
    softStealSpeed = 30,
    _isCarrying = false,
    _lvBoost = nil,
    _lvAtt = nil,
    _heartbeatConn = nil,
    _rayParams = nil,
    _rayFilter = nil,
    _rayFilterTime = 0
}

function CarrySystem:destroyLV()
    if self._lvBoost then pcall(function() self._lvBoost:Destroy() end) end
    if self._lvAtt then pcall(function() self._lvAtt:Destroy() end) end
    self._lvBoost = nil; self._lvAtt = nil
end

function CarrySystem:setupLV(hrp)
    if self._lvBoost and self._lvBoost.Parent == hrp then return end
    self:destroyLV()
    local att = Instance.new("Attachment"); att.Parent = hrp
    local lv = Instance.new("LinearVelocity")
    lv.Name = "HavenBoostLV"
    lv.Attachment0 = att
    lv.VelocityConstraintMode = Enum.VelocityConstraintMode.Plane
    lv.PrimaryTangentAxis = _V3new(1,0,0)
    lv.SecondaryTangentAxis = _V3new(0,0,1)
    lv.MaxForce = 2200
    lv.PlaneVelocity = Vector2.zero
    lv.RelativeTo = Enum.ActuatorRelativeTo.World
    lv.Parent = hrp
    self._lvAtt = att
    self._lvBoost = lv
end

function CarrySystem:getActiveSpeed()
    if self.laggerMode == 1 then return self.laggerSpeed end
    if self.laggerMode == 2 then return self.laggerCarrySpeed end
    if self.speedToggled then return self.carrySpeed end
    return self.normalSpeed
end

function CarrySystem:updateMovement(dt)
    local char = LP.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum then return end

    local speed = self:getActiveSpeed()
    local moveDir = hum.MoveDirection

    if not self._lvBoost or self._lvBoost.Parent ~= hrp then
        self:setupLV(hrp)
    end

    if self._lvBoost then
        if moveDir.Magnitude > 0.1 then
            local flat = _V3new(moveDir.X, 0, moveDir.Z).Unit
            self._lvBoost.PlaneVelocity = Vector2.new(flat.X * speed, flat.Z * speed)
        else
            self._lvBoost.PlaneVelocity = Vector2.zero
        end
    end
end

function CarrySystem:start()
    if self._heartbeatConn then return end
    self._heartbeatConn = RunService.Heartbeat:Connect(function(dt) self:updateMovement(dt) end)
end

CarrySystem:start() 

-- [[ HAVEN HUB - PARTE 2 DE 3 ]]

-- ============================================================
-- CREACIÓN DE LA INTERFAZ GRÁFICA (HAVEN HUB)
-- ============================================================
local gui = Instance.new("ScreenGui")
gui.Name = "HavenHubGUI"
gui.ResetOnSpawn = false

if gethui then
    gui.Parent = gethui()
elseif syn and syn.protect_gui then
    syn.protect_gui(gui)
    gui.Parent = game:GetService("CoreGui")
else
    gui.Parent = LP:WaitForChild("PlayerGui")
end

-- MARCO PRINCIPAL
local main = Instance.new("Frame")
main.Name = "MainFrame"
main.Size = UDim2.new(0, 580, 0, 380)
main.Position = UDim2.new(0.5, -290, 0.5, -190)
main.BackgroundColor3 = BACKGROUND_COLOR
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true
main.Parent = gui

local mainStroke = Instance.new("UIStroke")
mainStroke.Name = "MainBorderStroke"
mainStroke.Color = DEFAULT_THEME_COLOR
mainStroke.Thickness = 2
mainStroke.Parent = main

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 8)
mainCorner.Parent = main

-- BARRA DE TÍTULO
local titleFrame = Instance.new("Frame")
titleFrame.Name = "TitleFrame"
titleFrame.Size = UDim2.new(1, 0, 0, 50)
titleFrame.BackgroundTransparency = 1
titleFrame.Parent = main

local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "HavenTitle"
titleLabel.Size = UDim2.new(0, 300, 1, 0)
titleLabel.Position = UDim2.new(0, 15, 0, 0)
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = titleFrame
applyHavenHubTextStyle(titleLabel, "HAVEN HUB", 28, DEFAULT_THEME_COLOR)

-- PANEL LATERAL (MENÚ DE NAVEGACIÓN)
local sidebarFrame = Instance.new("Frame")
sidebarFrame.Name = "SidebarFrame"
sidebarFrame.Size = UDim2.new(0, 140, 1, -60)
sidebarFrame.Position = UDim2.new(0, 10, 0, 50)
sidebarFrame.BackgroundColor3 = BACKGROUND_COLOR
sidebarFrame.Parent = main

local sidebarStroke = Instance.new("UIStroke")
sidebarStroke.Color = Color3.fromRGB(40, 40, 40)
sidebarStroke.Thickness = 1
sidebarStroke.Parent = sidebarFrame

local sidebarList = Instance.new("UIListLayout")
sidebarList.SortOrder = Enum.SortOrder.LayoutOrder
sidebarList.Padding = UDim.new(0, 5)
sidebarList.Parent = sidebarFrame

-- CONTENEDOR DE PÁGINAS
local pagesFrame = Instance.new("Frame")
pagesFrame.Name = "PagesFrame"
pagesFrame.Size = UDim2.new(1, -165, 1, -60)
pagesFrame.Position = UDim2.new(0, 155, 0, 50)
pagesFrame.BackgroundColor3 = BACKGROUND_COLOR
pagesFrame.Parent = main

local pagesStroke = Instance.new("UIStroke")
pagesStroke.Color = Color3.fromRGB(40, 40, 40)
pagesStroke.Thickness = 1
pagesStroke.Parent = pagesFrame

-- CREACIÓN DE PESTAÑAS Y PÁGINAS
local pages = {}
tabButtons = {}

local function createTab(tabName, layoutOrder)
    local btn = Instance.new("TextButton")
    btn.Name = tabName .. "TabBtn"
    btn.Size = UDim2.new(1, 0, 0, 35)
    btn.LayoutOrder = layoutOrder
    btn.BackgroundColor3 = BACKGROUND_COLOR
    btn.Parent = sidebarFrame
    applyHavenHubTextStyle(btn, tabName, 14, DEFAULT_THEME_COLOR)

    local page = Instance.new("ScrollingFrame")
    page.Name = tabName .. "Page"
    page.Size = UDim2.new(1, -10, 1, -10)
    page.Position = UDim2.new(0, 5, 0, 5)
    page.BackgroundTransparency = 1
    page.ScrollBarThickness = 4
    page.ScrollBarImageColor3 = DEFAULT_THEME_COLOR
    page.Visible = (layoutOrder == 1)
    page.Parent = pagesFrame

    local pageList = Instance.new("UIListLayout")
    pageList.SortOrder = Enum.SortOrder.LayoutOrder
    pageList.Padding = UDim.new(0, 8)
    pageList.Parent = page

    pages[tabName] = page
    table.insert(tabButtons, btn)

    btn.MouseButton1Click:Connect(function()
        for name, p in pairs(pages) do
            p.Visible = (name == tabName)
        end
    end)

    return page
end

local mainPage = createTab("MAIN", 1)
local movementPage = createTab("MOVEMENT", 2)
local visualPage = createTab("VISUALS", 3)
local settingsPage = createTab("SETTINGS", 4)

-- ============================================================
-- ELEMENTOS DE LA PÁGINA MAIN
-- ============================================================
local function createToggleOption(parent, text, defaultState, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 36)
    btn.BackgroundColor3 = BACKGROUND_COLOR
    btn.Parent = parent
    
    local state = defaultState or false
    local labelText = text .. ": " .. (state and "ON" or "OFF")
    local color = state and Color3.fromRGB(100, 255, 100) or DEFAULT_THEME_COLOR
    applyHavenHubTextStyle(btn, labelText, 13, color)

    local stroke = Instance.new("UIStroke")
    stroke.Color = color
    stroke.Thickness = 1.5
    stroke.Parent = btn

    btn.MouseButton1Click:Connect(function()
        state = not state
        local newColor = state and Color3.fromRGB(100, 255, 100) or DEFAULT_THEME_COLOR
        applyHavenHubTextStyle(btn, text .. ": " .. (state and "ON" or "OFF"), 13, newColor)
        stroke.Color = newColor
        if callback then callback(state) end
    end)
    return btn
end

createToggleOption(mainPage, "CARRY SPEED", false, function(active)
    CarrySystem.speedToggled = active
end)

createToggleOption(mainPage, "SOFT STEAL", false, function(active)
    CarrySystem:setSoftStealEnabled(active)
end)

createToggleOption(movementPage, "LAGGER MODE", false, function(active)
    CarrySystem:setLaggerMode(active and 1 or 0)
end)

-- [[ HAVEN HUB - PARTE 3 DE 3 ]]

-- ============================================================
-- SISTEMA ESP / VISUALES
-- ============================================================
local espEnabled = false
local espHighlightCache = {}
local espBillboardCache = {}

local function removeESP(player)
    if espHighlightCache[player] then
        espHighlightCache[player]:Destroy()
        espHighlightCache[player] = nil
    end
    if espBillboardCache[player] then
        espBillboardCache[player]:Destroy()
        espBillboardCache[player] = nil
    end
end

local function applyESP(player)
    if player == LP or not player.Character then return end
    removeESP(player)

    local char = player.Character
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    -- Highlight (Borde brillante neón)
    local hl = Instance.new("Highlight")
    hl.Name = "HavenESP"
    hl.Adornee = char
    hl.FillColor = DEFAULT_THEME_COLOR
    hl.FillTransparency = 0.6
    hl.OutlineColor = DEFAULT_THEME_COLOR
    hl.OutlineTransparency = 0
    hl.Parent = char
    espHighlightCache[player] = hl

    -- Tag con Nombre
    local bb = Instance.new("BillboardGui")
    bb.Name = "HavenNameTag"
    bb.Adornee = hrp
    bb.Size = UDim2.new(0, 150, 0, 30)
    bb.StudsOffset = Vector3.new(0, 3, 0)
    bb.AlwaysOnTop = true

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, 0, 1, 0)
    lbl.Parent = bb
    applyHavenHubTextStyle(lbl, player.Name, 14, DEFAULT_THEME_COLOR)

    bb.Parent = char
    espBillboardCache[player] = bb
end

local function toggleESP(active)
    espEnabled = active
    if not espEnabled then
        for p, _ in pairs(espHighlightCache) do
            removeESP(p)
        end
    else
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LP then applyESP(p) end
        end
    end
end

createToggleOption(visualPage, "PLAYER ESP", false, function(active)
    toggleESP(active)
end)

Players.PlayerAdded:Connect(function(p)
    p.CharacterAdded:Connect(function()
        if espEnabled then
            task.wait(0.5)
            applyESP(p)
        end
    end)
end)

Players.PlayerRemoving:Connect(function(p)
    removeESP(p)
end)

-- ============================================================
-- PÁGINA SETTINGS & CAMBIO DE TEMAS
-- ============================================================
local function createColorSelector(parent)
    local themeNames = {"Morado", "Azul", "Verde", "Rosado", "Gris"}
    local colors = {
        ["Morado"] = Color3.fromRGB(160, 100, 220),
        ["Azul"]   = Color3.fromRGB(80, 150, 255),
        ["Verde"]  = Color3.fromRGB(80, 220, 120),
        ["Rosado"] = Color3.fromRGB(255, 120, 180),
        ["Gris"]   = Color3.fromRGB(180, 180, 190)
    }

    for _, name in ipairs(themeNames) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, -10, 0, 32)
        btn.BackgroundColor3 = BACKGROUND_COLOR
        btn.Parent = parent

        local color = colors[name]
        applyHavenHubTextStyle(btn, "TEMA: " .. string.upper(name), 12, color)

        local stroke = Instance.new("UIStroke")
        stroke.Color = color
        stroke.Thickness = 1.5
        stroke.Parent = btn

        btn.MouseButton1Click:Connect(function()
            DEFAULT_THEME_COLOR = color
            applyHavenHubTextStyle(titleLabel, "HAVEN HUB", 28, color)
            mainStroke.Color = color

            for _, tabBtn in ipairs(tabButtons) do
                applyHavenHubTextStyle(tabBtn, nil, 14, color)
            end

            for p, hl in pairs(espHighlightCache) do
                if hl then
                    hl.FillColor = color
                    hl.OutlineColor = color
                end
            end
        end)
    end
end

createColorSelector(settingsPage)

-- ============================================================
-- GUARDADO Y CARGA DE CONFIGURACIÓN
-- ============================================================
function saveAllSettings()
    local data = {
        ThemeColor = {DEFAULT_THEME_COLOR.R, DEFAULT_THEME_COLOR.G, DEFAULT_THEME_COLOR.B},
        NormalSpeed = CarrySystem.normalSpeed,
        CarrySpeed = CarrySystem.carrySpeed
    }
    pcall(function()
        if writefile then
            writefile(CONFIG_FILE, HS:JSONEncode(data))
        end
    end)
end

function loadAllSettings()
    pcall(function()
        if readfile and isfile and isfile(CONFIG_FILE) then
            local data = HS:JSONDecode(readfile(CONFIG_FILE))
            if data and data.ThemeColor then
                DEFAULT_THEME_COLOR = Color3.new(data.ThemeColor[1], data.ThemeColor[2], data.ThemeColor[3])
                applyHavenHubTextStyle(titleLabel, "HAVEN HUB", 28, DEFAULT_THEME_COLOR)
                mainStroke.Color = DEFAULT_THEME_COLOR
            end
        end
    end)
end

loadAllSettings()

print("[HAVEN HUB] Carga completa exitosa.")