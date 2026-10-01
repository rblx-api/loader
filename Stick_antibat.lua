-- ============================================================
-- STICK ANTI TP BAT (UI Reconstruida)
-- Basado en la lógica de Orvyn Anti Bat
-- ============================================================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

-- Variables de Estado
local AntiTPBatEnabled = false
local InfiniteJumpHoldEnabled = false
local IsJumpingHold = false
local CurrentKeybind = Enum.KeyCode.T
local WaitingForKeybind = false
local isMinimized = false

-- Conexiones
local AntiTPConn = nil
local JumpHoldConn = nil

-- Referencias del Personaje
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
local Humanoid = Character:WaitForChild("Humanoid")

-- ==================== LÓGICA ANTI TP BAT ====================
local function startAntiTPBat()
    local char = LocalPlayer.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    
    if AntiTPConn then AntiTPConn:Disconnect() end
    
    AntiTPConn = RunService.Heartbeat:Connect(function()
        if not root or not root.Parent then return end
        -- Lógica de congelamiento de posición (Anti TP)
        local origXZ = Vector3.new(root.Velocity.X, 0, root.Velocity.Z)
        root.Velocity = Vector3.new(1000, root.Velocity.Y, 1000)
        RunService.RenderStepped:Wait()
        root.Velocity = Vector3.new(origXZ.X, root.Velocity.Y, origXZ.Z)
    end)
end

local function stopAntiTPBat()
    if AntiTPConn then
        AntiTPConn:Disconnect()
        AntiTPConn = nil
    end
end

-- ==================== LÓGICA INFINITE JUMP (HOLD) ====================
local function startJumpHoldLoop()
    if JumpHoldConn then JumpHoldConn:Disconnect() end
    JumpHoldConn = RunService.Heartbeat:Connect(function()
        if not InfiniteJumpHoldEnabled or not IsJumpingHold then return end
        local char = LocalPlayer.Character
        if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        if root then
            -- Fuerza hacia arriba mientras se mantiene presionado
            root.Velocity = Vector3.new(root.Velocity.X, 55, root.Velocity.Z)
        end
    end)
end

-- Detección de teclas para el Hold Jump
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.Space or input.UserInputType == Enum.UserInputType.Touch then
        IsJumpingHold = true
    end
end)

UserInputService.InputEnded:Connect(function(input, gp)
    if input.KeyCode == Enum.KeyCode.Space or input.UserInputType == Enum.UserInputType.Touch then
        IsJumpingHold = false
    end
end)

-- ==================== CONSTRUCCIÓN DE LA UI ====================

-- Limpieza de UI previa
pcall(function()
    for _, old in ipairs(LocalPlayer:WaitForChild("PlayerGui"):GetChildren()) do
        if old.Name == "StickAntiTPBatGui" then
            old:Destroy()
        end
    end
end)

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "StickAntiTPBatGui"
ScreenGui.DisplayOrder = 999999
ScreenGui.IgnoreGuiInset = true
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Medidas
local PW, PH = 220, 200 -- Altura ajustada para 3 filas
local MINI_H = 44

-- Frame Principal
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Active = true
MainFrame.AnchorPoint = Vector2.new(0, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(5, 10, 28)
MainFrame.BackgroundTransparency = 0.25
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Position = UDim2.new(0.5, -PW / 2, 0.5, -PH / 2)
MainFrame.Size = UDim2.new(0, PW, 0, PH)
MainFrame.Parent = ScreenGui

local UICorner_Main = Instance.new("UICorner")
UICorner_Main.CornerRadius = UDim.new(0, 16)
UICorner_Main.Parent = MainFrame

local UIStroke_Main = Instance.new("UIStroke")
UIStroke_Main.Color = Color3.fromRGB(200, 30, 30) -- Borde rojo como la imagen
UIStroke_Main.Thickness = 1.8
UIStroke_Main.Parent = MainFrame

-- ==================== HEADER ====================
local Header = Instance.new("Frame")
Header.Name = "Header"
Header.BackgroundTransparency = 1
Header.Size = UDim2.new(1, 0, 0, 44)
Header.Parent = MainFrame

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Name = "TitleLabel"
TitleLabel.BackgroundTransparency = 1
TitleLabel.Position = UDim2.new(0, 16, 0, 0)
TitleLabel.Size = UDim2.new(1, -50, 1, 0)
TitleLabel.Font = Enum.Font.GothamBlack
TitleLabel.Text = "STICK ANTI TP BAT" -- Título solicitado
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255) -- Blanco
TitleLabel.TextSize = 14
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = Header

-- Botón Minimizar
local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Name = "MinimizeBtn"
MinimizeBtn.Size = UDim2.new(0, 26, 0, 26)
MinimizeBtn.Position = UDim2.new(1, -36, 0.5, -13)
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(12, 8, 20)
MinimizeBtn.BackgroundTransparency = 0.5
MinimizeBtn.Text = "−"
MinimizeBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.TextSize = 16
MinimizeBtn.BorderSizePixel = 0
MinimizeBtn.Parent = Header

local UICorner_Min = Instance.new("UICorner")
UICorner_Min.CornerRadius = UDim.new(0, 6)
UICorner_Min.Parent = MinimizeBtn

local UIStroke_Min = Instance.new("UIStroke")
UIStroke_Min.Color = Color3.fromRGB(200, 30, 30)
UIStroke_Min.Thickness = 1
UIStroke_Min.Parent = MinimizeBtn

-- ==================== CONTENEDOR DE CONTENIDO ====================
local Content = Instance.new("Frame")
Content.Name = "Content"
Content.BackgroundTransparency = 1
Content.Position = UDim2.new(0, 16, 0, 44)
Content.Size = UDim2.new(1, -32, 1, -56)
Content.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.FillDirection = Enum.FillDirection.Vertical
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
UIListLayout.Padding = UDim.new(0, 10)
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Parent = Content

-- ==================== FILA 1: ANTI TP BAT ====================
local Row1 = Instance.new("Frame")
Row1.Name = "AntiTPBatRow"
Row1.LayoutOrder = 1
Row1.BackgroundColor3 = Color3.fromRGB(12, 8, 20)
Row1.BackgroundTransparency = 0.55
Row1.Size = UDim2.new(1, 0, 0, 38)
Row1.BorderSizePixel = 0
Row1.Parent = Content

local UICorner_R1 = Instance.new("UICorner")
UICorner_R1.CornerRadius = UDim.new(0, 8)
UICorner_R1.Parent = Row1

local UIStroke_R1 = Instance.new("UIStroke")
UIStroke_R1.Color = Color3.fromRGB(200, 30, 30)
UIStroke_R1.Thickness = 1.2
UIStroke_R1.Parent = Row1

local Label_R1 = Instance.new("TextLabel")
Label_R1.Name = "Label"
Label_R1.BackgroundTransparency = 1
Label_R1.Position = UDim2.new(0, 12, 0, 0)
Label_R1.Size = UDim2.new(0.6, 0, 1, 0)
Label_R1.Font = Enum.Font.GothamBold
Label_R1.Text = "Anti TP Bat"
Label_R1.TextColor3 = Color3.fromRGB(255, 255, 255)
Label_R1.TextSize = 12
Label_R1.TextXAlignment = Enum.TextXAlignment.Left
Label_R1.Parent = Row1

-- Toggle Visual (Píldora)
local TogglePill_R1 = Instance.new("Frame")
TogglePill_R1.Name = "TogglePill"
TogglePill_R1.BackgroundColor3 = Color3.fromRGB(5, 3, 10)
TogglePill_R1.BackgroundTransparency = 0.3
TogglePill_R1.Position = UDim2.new(1, -50, 0.5, -9)
TogglePill_R1.Size = UDim2.new(0, 38, 0, 18)
TogglePill_R1.BorderSizePixel = 0
TogglePill_R1.Parent = Row1

local UICorner_Pill1 = Instance.new("UICorner")
UICorner_Pill1.CornerRadius = UDim.new(0, 9)
UICorner_Pill1.Parent = TogglePill_R1

local UIStroke_Pill1 = Instance.new("UIStroke")
UIStroke_Pill1.Color = Color3.fromRGB(200, 30, 30)
UIStroke_Pill1.Thickness = 1.2
UIStroke_Pill1.Parent = TogglePill_R1

-- Toggle Knob (Círculo)
local ToggleKnob_R1 = Instance.new("Frame")
ToggleKnob_R1.Name = "ToggleKnob"
ToggleKnob_R1.BackgroundColor3 = Color3.fromRGB(220, 210, 240)
ToggleKnob_R1.Position = UDim2.new(0, 3, 0.5, -6)
ToggleKnob_R1.Size = UDim2.new(0, 12, 0, 12)
ToggleKnob_R1.BorderSizePixel = 0
ToggleKnob_R1.Parent = TogglePill_R1

local UICorner_Knob1 = Instance.new("UICorner")
UICorner_Knob1.CornerRadius = UDim.new(0, 6)
UICorner_Knob1.Parent = ToggleKnob_R1

-- Click Area
local Click_R1 = Instance.new("TextButton")
Click_R1.Name = "ClickArea"
Click_R1.BackgroundTransparency = 1
Click_R1.Size = UDim2.new(1, 0, 1, 0)
Click_R1.Text = ""
Click_R1.Parent = Row1

-- ==================== FILA 2: KEYBIND ====================
local Row2 = Instance.new("Frame")
Row2.Name = "KeybindRow"
Row2.LayoutOrder = 2
Row2.BackgroundColor3 = Color3.fromRGB(12, 8, 20)
Row2.BackgroundTransparency = 0.55
Row2.Size = UDim2.new(1, 0, 0, 38)
Row2.BorderSizePixel = 0
Row2.Parent = Content

local UICorner_R2 = Instance.new("UICorner")
UICorner_R2.CornerRadius = UDim.new(0, 8)
UICorner_R2.Parent = Row2

local UIStroke_R2 = Instance.new("UIStroke")
UIStroke_R2.Color = Color3.fromRGB(200, 30, 30)
UIStroke_R2.Thickness = 1.2
UIStroke_R2.Parent = Row2

local Label_R2 = Instance.new("TextLabel")
Label_R2.Name = "Label"
Label_R2.BackgroundTransparency = 1
Label_R2.Position = UDim2.new(0, 12, 0, 0)
Label_R2.Size = UDim2.new(0.5, 0, 1, 0)
Label_R2.Font = Enum.Font.GothamBold
Label_R2.Text = "Keybind"
Label_R2.TextColor3 = Color3.fromRGB(255, 255, 255)
Label_R2.TextSize = 12
Label_R2.TextXAlignment = Enum.TextXAlignment.Left
Label_R2.Parent = Row2

local KeybindBtn = Instance.new("TextButton")
KeybindBtn.Name = "KeybindBtn"
KeybindBtn.Size = UDim2.new(0, 75, 0, 22)
KeybindBtn.Position = UDim2.new(1, -87, 0.5, -11)
KeybindBtn.BackgroundColor3 = Color3.fromRGB(5, 3, 10)
KeybindBtn.BackgroundTransparency = 0.2
KeybindBtn.Text = "[ " .. CurrentKeybind.Name .. " ]"
KeybindBtn.TextColor3 = Color3.fromRGB(255, 70, 70)
KeybindBtn.Font = Enum.Font.GothamBlack
KeybindBtn.TextSize = 11
KeybindBtn.BorderSizePixel = 0
KeybindBtn.Parent = Row2

local UICorner_Btn = Instance.new("UICorner")
UICorner_Btn.CornerRadius = UDim.new(0, 5)
UICorner_Btn.Parent = KeybindBtn

local UIStroke_Btn = Instance.new("UIStroke")
UIStroke_Btn.Color = Color3.fromRGB(200, 30, 30)
UIStroke_Btn.Thickness = 1
UIStroke_Btn.Parent = KeybindBtn

-- ==================== FILA 3: INFINITY JUMP ====================
local Row3 = Instance.new("Frame")
Row3.Name = "InfJumpRow"
Row3.LayoutOrder = 3
Row3.BackgroundColor3 = Color3.fromRGB(12, 8, 20)
Row3.BackgroundTransparency = 0.55
Row3.Size = UDim2.new(1, 0, 0, 38)
Row3.BorderSizePixel = 0
Row3.Parent = Content

local UICorner_R3 = Instance.new("UICorner")
UICorner_R3.CornerRadius = UDim.new(0, 8)
UICorner_R3.Parent = Row3

local UIStroke_R3 = Instance.new("UIStroke")
UIStroke_R3.Color = Color3.fromRGB(200, 30, 30)
UIStroke_R3.Thickness = 1.2
UIStroke_R3.Parent = Row3

local Label_R3 = Instance.new("TextLabel")
Label_R3.Name = "Label"
Label_R3.BackgroundTransparency = 1
Label_R3.Position = UDim2.new(0, 12, 0, 0)
Label_R3.Size = UDim2.new(0.6, 0, 1, 0)
Label_R3.Font = Enum.Font.GothamBold
Label_R3.Text = "Infinity Jump"
Label_R3.TextColor3 = Color3.fromRGB(255, 255, 255)
Label_R3.TextSize = 12
Label_R3.TextXAlignment = Enum.TextXAlignment.Left
Label_R3.Parent = Row3

-- Toggle Visual (Píldora)
local TogglePill_R3 = Instance.new("Frame")
TogglePill_R3.Name = "TogglePill"
TogglePill_R3.BackgroundColor3 = Color3.fromRGB(5, 3, 10)
TogglePill_R3.BackgroundTransparency = 0.3
TogglePill_R3.Position = UDim2.new(1, -50, 0.5, -9)
TogglePill_R3.Size = UDim2.new(0, 38, 0, 18)
TogglePill_R3.BorderSizePixel = 0
TogglePill_R3.Parent = Row3

local UICorner_Pill3 = Instance.new("UICorner")
UICorner_Pill3.CornerRadius = UDim.new(0, 9)
UICorner_Pill3.Parent = TogglePill_R3

local UIStroke_Pill3 = Instance.new("UIStroke")
UIStroke_Pill3.Color = Color3.fromRGB(200, 30, 30)
UIStroke_Pill3.Thickness = 1.2
UIStroke_Pill3.Parent = TogglePill_R3

-- Toggle Knob (Círculo)
local ToggleKnob_R3 = Instance.new("Frame")
ToggleKnob_R3.Name = "ToggleKnob"
ToggleKnob_R3.BackgroundColor3 = Color3.fromRGB(220, 210, 240)
ToggleKnob_R3.Position = UDim2.new(0, 3, 0.5, -6)
ToggleKnob_R3.Size = UDim2.new(0, 12, 0, 12)
ToggleKnob_R3.BorderSizePixel = 0
ToggleKnob_R3.Parent = TogglePill_R3

local UICorner_Knob3 = Instance.new("UICorner")
UICorner_Knob3.CornerRadius = UDim.new(0, 6)
UICorner_Knob3.Parent = ToggleKnob_R3

-- Click Area
local Click_R3 = Instance.new("TextButton")
Click_R3.Name = "ClickArea"
Click_R3.BackgroundTransparency = 1
Click_R3.Size = UDim2.new(1, 0, 1, 0)
Click_R3.Text = ""
Click_R3.Parent = Row3

-- ==================== SISTEMA DE ARRASTRE ====================
local dragging, dragStart, startPos

Header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        local conn
        conn = input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
                conn:Disconnect()
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- ==================== MINIMIZAR ====================
local function toggleMinimize()
    isMinimized = not isMinimized
    local targetHeight = isMinimized and MINI_H or PH
    TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, PW, 0, targetHeight)
    }):Play()
    Content.Visible = not isMinimized
    MinimizeBtn.Text = isMinimized and "+" or "−"
end
MinimizeBtn.MouseButton1Click:Connect(toggleMinimize)

-- ==================== VISUAL TOGGLE LOGIC ====================
local function setVisuals(dot, pillStroke, enabled)
    TweenService:Create(dot, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Position = enabled and UDim2.new(1, -15, 0.5, -6) or UDim2.new(0, 3, 0.5, -6),
        BackgroundColor3 = enabled and Color3.fromRGB(0, 255, 140) or Color3.fromRGB(220, 210, 240)
    }):Play()
    TweenService:Create(pillStroke, TweenInfo.new(0.2), {
        Color = enabled and Color3.fromRGB(0, 255, 140) or Color3.fromRGB(200, 30, 30)
    }):Play()
end

-- ==================== CONEXIONES DE BOTONES ====================

-- 1. Anti TP Bat
Click_R1.MouseButton1Click:Connect(function()
    AntiTPBatEnabled = not AntiTPBatEnabled
    if AntiTPBatEnabled then startAntiTPBat() else stopAntiTPBat() end
    setVisuals(ToggleKnob_R1, UIStroke_Pill1, AntiTPBatEnabled)
end)

-- 2. Keybind
KeybindBtn.MouseButton1Click:Connect(function()
    if WaitingForKeybind then return end
    WaitingForKeybind = true
    KeybindBtn.Text = "[ ... ]"
end)

-- 3. Infinity Jump (Hold)
Click_R3.MouseButton1Click:Connect(function()
    InfiniteJumpHoldEnabled = not InfiniteJumpHoldEnabled
    setVisuals(ToggleKnob_R3, UIStroke_Pill3, InfiniteJumpHoldEnabled)
    if not InfiniteJumpHoldEnabled then
        IsJumpingHold = false
    end
end)

-- ==================== INPUT DE TECLADO ====================
UserInputService.InputBegan:Connect(function(inp, gp)
    if gp then return end
    
    -- Cambio de Keybind
    if WaitingForKeybind and inp.UserInputType == Enum.UserInputType.Keyboard then
        CurrentKeybind = inp.KeyCode
        WaitingForKeybind = false
        KeybindBtn.Text = "[ " .. CurrentKeybind.Name .. " ]"
    
    -- Uso del Keybind
    elseif not WaitingForKeybind and inp.UserInputType == Enum.UserInputType.Keyboard then
        if inp.KeyCode == CurrentKeybind then
            AntiTPBatEnabled = not AntiTPBatEnabled
            if AntiTPBatEnabled then startAntiTPBat() else stopAntiTPBat() end
            setVisuals(ToggleKnob_R1, UIStroke_Pill1, AntiTPBatEnabled)
        end
    end
end)

-- ==================== INICIALIZACIÓN ====================
startJumpHoldLoop() -- Inicia el bucle de salto
setVisuals(ToggleKnob_R1, UIStroke_Pill1, AntiTPBatEnabled)
setVisuals(ToggleKnob_R3, UIStroke_Pill3, InfiniteJumpHoldEnabled)

print("STICK ANTI TP BAT - Cargado correctamente")