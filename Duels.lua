-- =============================================
-- ðŸš€ INTRO DE LA OSTIA - GENERADA POR STICK HUB
-- ðŸ”¥ Efectos visuales de alto nivel
-- ðŸ’» Compatible con cualquier executor
-- =============================================

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")

local player = Players.LocalPlayer
if not player then
    player = Players.PlayerAdded:Wait()
end

-- ========== CONFIGURACIÃ“N ==========
local config = {
    -- Colores
    bgColor1 = Color3.fromRGB(10, 5, 30),      -- Color de fondo 1
    bgColor2 = Color3.fromRGB(30, 10, 50),      -- Color de fondo 2
    accentColor1 = Color3.fromRGB(255, 70, 130), -- Color acento principal
    accentColor2 = Color3.fromRGB(100, 200, 255), -- Color acento secundario
    accentColor3 = Color3.fromRGB(255, 200, 50),  -- Color acento terciario
    textColor = Color3.fromRGB(255, 255, 255),
    subTextColor = Color3.fromRGB(200, 200, 230),
    
    -- Textos
    welcomeText = "haz que la pantalla este en negro y q salga como un personaje de anime con una katana q haga algun movimiento con esa katana rapido y ponga stick hub",
    subText = "âœ¨ PrepÃ¡rate para la experiencia",
    buttonText = "â–¶ COMENZAR",
}

-- ========== CREAR GUI ==========
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "IntroGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

-- ðŸ“± FONDO PRINCIPAL CON GRADIENTE DINÃMICO
local background = Instance.new("Frame")
background.Size = UDim2.new(1, 0, 1, 0)
background.BackgroundColor3 = config.bgColor1
background.BorderSizePixel = 0
background.Parent = screenGui

-- Gradiente de fondo (aurora boreal animada)
local bgGradient = Instance.new("UIGradient")
bgGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, config.bgColor1),
    ColorSequenceKeypoint.new(0.5, config.bgColor2),
    ColorSequenceKeypoint.new(1, config.bgColor1)
})
bgGradient.Rotation = 45
bgGradient.Parent = background

-- ðŸŒŸ PARTÃCULAS ESTELARES
local particleContainer = Instance.new("Frame")
particleContainer.Size = UDim2.new(1, 0, 1, 0)
particleContainer.BackgroundTransparency = 1
particleContainer.Parent = background

local particles = {}
for i = 1, 50 do
    local dot = Instance.new("Frame")
    dot.Size = UDim2.new(0, math.random(2, 6), 0, math.random(2, 6))
    dot.Position = UDim2.new(math.random() * 0.95, 0, math.random() * 0.95, 0)
    dot.BackgroundColor3 = config.accentColor1
    dot.BackgroundTransparency = 0.5
    dot.BorderSizePixel = 0
    dot.Parent = particleContainer
    dot.AnchorPoint = Vector2.new(0.5, 0.5)
    table.insert(particles, {
        frame = dot,
        speedX = (math.random() - 0.5) * 0.3,
        speedY = (math.random() - 0.5) * 0.3,
        baseX = dot.Position.X.Scale,
        baseY = dot.Position.Y.Scale,
        size = dot.Size.X.Offset,
        phase = math.random() * 2 * math.pi
    })
end

-- ðŸ’Ž MARCO PRINCIPAL (Efecto glassmorphism)
local container = Instance.new("Frame")
container.Size = UDim2.new(0, 600, 0, 380)
container.Position = UDim2.new(0.5, -300, 0.5, -190)
container.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
container.BackgroundTransparency = 0.08
container.BorderSizePixel = 0
container.Parent = background
container.AnchorPoint = Vector2.new(0, 0)
container.ClipsDescendants = true

-- Efecto de vidrio (glassmorphism) - borde con glow
local glassBorder = Instance.new("Frame")
glassBorder.Size = UDim2.new(1, 2, 1, 2)
glassBorder.Position = UDim2.new(-0.002, 0, -0.002, 0)
glassBorder.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
glassBorder.BackgroundTransparency = 0.9
glassBorder.BorderSizePixel = 0
glassBorder.Parent = container

-- Borde RGB animado
local border = Instance.new("Frame")
border.Size = UDim2.new(1, 0, 1, 0)
border.BackgroundColor3 = config.accentColor1
border.BackgroundTransparency = 0.7
border.BorderSizePixel = 0
border.Parent = container

local borderGradient = Instance.new("UIGradient")
borderGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, config.accentColor1),
    ColorSequenceKeypoint.new(0.3, config.accentColor2),
    ColorSequenceKeypoint.new(0.6, config.accentColor3),
    ColorSequenceKeypoint.new(1, config.accentColor1)
})
borderGradient.Rotation = 0
borderGradient.Parent = border

-- ðŸŽ¨ LOGO/ICONO CENTRAL
local iconContainer = Instance.new("Frame")
iconContainer.Size = UDim2.new(0, 80, 0, 80)
iconContainer.Position = UDim2.new(0.5, -40, 0, 30)
iconContainer.BackgroundColor3 = config.accentColor1
iconContainer.BackgroundTransparency = 0.2
iconContainer.BorderSizePixel = 0
iconContainer.Parent = container
iconContainer.AnchorPoint = Vector2.new(0.5, 0)

-- Icono de estrella
local iconText = Instance.new("TextLabel")
iconText.Size = UDim2.new(1, 0, 1, 0)
iconText.BackgroundTransparency = 1
iconText.Text = "âœ¦"
iconText.TextColor3 = Color3.fromRGB(255, 255, 255)
iconText.TextSize = 50
iconText.TextFont = Enum.Font.GothamBold
iconText.TextXAlignment = Enum.TextXAlignment.Center
iconText.TextYAlignment = Enum.TextYAlignment.Center
iconText.Parent = iconContainer

-- ðŸ“ TÃTULO PRINCIPAL (con efecto de rebote)
local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -40, 0, 70)
titleLabel.Position = UDim2.new(0, 20, 0, 130)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = ""
titleLabel.TextColor3 = config.textColor
titleLabel.TextSize = 38
titleLabel.TextFont = Enum.Font.GothamBold
titleLabel.TextXAlignment = Enum.TextXAlignment.Center
titleLabel.TextYAlignment = Enum.TextYAlignment.Center
titleLabel.Parent = container

-- Efecto de sombra en el texto
local titleShadow = Instance.new("TextLabel")
titleShadow.Size = titleLabel.Size
titleShadow.Position = titleLabel.Position
titleShadow.BackgroundTransparency = 1
titleShadow.Text = config.welcomeText
titleShadow.TextColor3 = Color3.fromRGB(0, 0, 0)
titleShadow.TextSize = 38
titleShadow.TextFont = Enum.Font.GothamBold
titleShadow.TextXAlignment = Enum.TextXAlignment.Center
titleShadow.TextYAlignment = Enum.TextYAlignment.Center
titleShadow.Parent = container
titleShadow.TextTransparency = 0.7
titleShadow.Position = UDim2.new(0, 22, 0, 132)

-- ðŸ“ SUBTÃTULO
local subLabel = Instance.new("TextLabel")
subLabel.Size = UDim2.new(1, -40, 0, 30)
subLabel.Position = UDim2.new(0, 20, 0, 215)
subLabel.BackgroundTransparency = 1
subLabel.Text = config.subText
subLabel.TextColor3 = config.subTextColor
subLabel.TextSize = 18
subLabel.TextFont = Enum.Font.Gotham
subLabel.TextXAlignment = Enum.TextXAlignment.Center
subLabel.TextYAlignment = Enum.TextYAlignment.Center
subLabel.Parent = container
subLabel.TextTransparency = 1

-- ðŸ”˜ BOTÃ“N NEON
local continueButton = Instance.new("TextButton")
continueButton.Size = UDim2.new(0, 220, 0, 55)
continueButton.Position = UDim2.new(0.5, -110, 0, 280)
continueButton.BackgroundColor3 = config.accentColor1
continueButton.BackgroundTransparency = 0.15
continueButton.BorderSizePixel = 0
continueButton.Text = config.buttonText
continueButton.TextColor3 = Color3.fromRGB(255, 255, 255)
continueButton.TextSize = 20
continueButton.TextFont = Enum.Font.GothamBold
continueButton.Parent = container
continueButton.AnchorPoint = Vector2.new(0.5, 0.5)
continueButton.Visible = false

-- Efecto de brillo en el botÃ³n
local buttonGlow = Instance.new("Frame")
buttonGlow.Size = UDim2.new(1, 10, 1, 10)
buttonGlow.Position = UDim2.new(-0.02, 0, -0.02, 0)
buttonGlow.BackgroundColor3 = config.accentColor1
buttonGlow.BackgroundTransparency = 0.8
buttonGlow.BorderSizePixel = 0
buttonGlow.Parent = continueButton

-- Efectos hover del botÃ³n
local function onButtonEnter()
    TweenService:Create(continueButton, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        BackgroundTransparency = 0.05,
        Size = UDim2.new(0, 230, 0, 60)
    }):Play()
    TweenService:Create(buttonGlow, TweenInfo.new(0.3), {
        BackgroundTransparency = 0.5
    }):Play()
end

local function onButtonLeave()
    TweenService:Create(continueButton, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        BackgroundTransparency = 0.15,
        Size = UDim2.new(0, 220, 0, 55)
    }):Play()
    TweenService:Create(buttonGlow, TweenInfo.new(0.3), {
        BackgroundTransparency = 0.8
    }):Play()
end

continueButton.MouseEnter:Connect(onButtonEnter)
continueButton.MouseLeave:Connect(onButtonLeave)

-- ðŸŽ¬ FUNCIÃ“N PARA CERRAR LA INTRO (con efecto)
local function closeIntro()
    -- Efecto de cierre con explosiÃ³n de partÃ­culas
    TweenService:Create(container, TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 800, 0, 500)
    }):Play()
    
    TweenService:Create(background, TweenInfo.new(0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        BackgroundTransparency = 1
    }):Play()
    
    wait(0.8)
    screenGui:Destroy()
end

continueButton.MouseButton1Click:Connect(closeIntro)

-- Cerrar con Escape
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.Escape then
        closeIntro()
    end
end)

-- ========== ANIMACIONES ==========

-- 1. ESCRITURA CON EFECTO DE REBOTE
coroutine.wrap(function()
    local fullText = config.welcomeText
    local delay = 0.06
    for i = 1, #fullText do
        local currentText = fullText:sub(1, i)
        titleLabel.Text = currentText
        titleShadow.Text = currentText
        
        -- Efecto de rebote en cada letra
        TweenService:Create(titleLabel, TweenInfo.new(0.15, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            TextSize = 42
        }):Play()
        wait(0.05)
        TweenService:Create(titleLabel, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            TextSize = 38
        }):Play()
        wait(delay)
    end
    
    -- Mostrar subtÃ­tulo
    TweenService:Create(subLabel, TweenInfo.new(0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        TextTransparency = 0
    }):Play()
    
    -- Mostrar botÃ³n con efecto
    wait(0.5)
    continueButton.Visible = true
    TweenService:Create(continueButton, TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        BackgroundTransparency = 0.1
    }):Play()
    TweenService:Create(continueButton, TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 240, 0, 60)
    }):Play()
end)()

-- 2. ANIMACIÃ“N DE PARTÃCULAS
coroutine.wrap(function()
    local time = 0
    while screenGui.Parent do
        time = time + 0.02
        for _, p in ipairs(particles) do
            local x = p.baseX + math.sin(time * p.speedX + p.phase) * 0.03
            local y = p.baseY + math.cos(time * p.speedY + p.phase) * 0.03
            p.frame.Position = UDim2.new(x, 0, y, 0)
            
            -- Cambio de tamaÃ±o y opacidad
            local scale = 0.5 + math.sin(time * 2 + p.phase) * 0.5
            p.frame.Size = UDim2.new(0, p.size * (0.5 + scale * 0.5), 0, p.size * (0.5 + scale * 0.5))
            p.frame.BackgroundTransparency = 0.3 + (1 - scale) * 0.5
            
            -- Cambio de color segÃºn posiciÃ³n
            local colorBlend = (x + y) / 2
            p.frame.BackgroundColor3 = Color3.fromRGB(
                255 * (0.5 + math.sin(time + p.phase) * 0.3),
                150 * (0.5 + math.cos(time * 0.7 + p.phase) * 0.3),
                200 * (0.5 + math.sin(time * 0.5 + p.phase * 0.5) * 0.3)
            )
        end
        wait(0.03)
    end
end)()

-- 3. AURORA BOREAL (fondo animado)
coroutine.wrap(function()
    local rotation = 0
    while screenGui.Parent do
        rotation = rotation + 0.3
        bgGradient.Rotation = rotation
        wait(0.05)
    end
end)()

-- 4. BORDE RGB ANIMADO
coroutine.wrap(function()
    local rotation = 0
    while screenGui.Parent do
        rotation = rotation + 0.5
        borderGradient.Rotation = rotation
        wait(0.05)
    end
end)()

-- 5. PULSO DEL ICONO
coroutine.wrap(function()
    while screenGui.Parent do
        TweenService:Create(iconContainer, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
            BackgroundTransparency = 0.1,
            Size = UDim2.new(0, 85, 0, 85)
        }):Play()
        wait(1)
        TweenService:Create(iconContainer, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
            BackgroundTransparency = 0.3,
            Size = UDim2.new(0, 75, 0, 75)
        }):Play()
        wait(1)
    end
end)()

-- 6. EFECTO DE ONDA EN EL BOTÃ“N (cuando se hace clic)
continueButton.MouseButton1Down:Connect(function()
    local wave = Instance.new("Frame")
    wave.Size = UDim2.new(1, 0, 1, 0)
    wave.Position = UDim2.new(0.5, -0.5, 0.5, -0.5)
    wave.BackgroundColor3 = config.accentColor2
    wave.BackgroundTransparency = 0.5
    wave.BorderSizePixel = 0
    wave.Parent = continueButton
    wave.AnchorPoint = Vector2.new(0.5, 0.5)
    
    TweenService:Create(wave, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Size = UDim2.new(1.5, 0, 1.5, 0),
        BackgroundTransparency = 1
    }):Play()
    wait(0.4)
    wave:Destroy()
end)

-- ========== FIN ==========
print("ðŸŽ¬ Intro de la ostia generada por Stick Hub")
print("ðŸ”¥ Disfruta del espectÃ¡culo")