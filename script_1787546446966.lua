-- ==============================================
--  INTRO ANIMADA · NOXTRIXHUB DUEL
--  Discord: discord.gg/tvAkYe7Uq
--  ✅ CÓDIGO SEPARADO — SOLO LA INTRO
-- ==============================================

local Players = game:GetService("Players")
local TS = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")

-- 🎨 COLORES
local C = {
    Negro   = Color3.fromRGB(0, 0, 0),
    Purpura = Color3.fromRGB(130, 0, 230),
    Brillo  = Color3.fromRGB(180, 50, 255),
    Azul    = Color3.fromRGB(0, 170, 255),
    Blanco  = Color3.fromRGB(255, 255, 255),
}

-- 🖥️ GUI DE LA INTRO
local introGui = Instance.new("ScreenGui")
introGui.Name = "NOXTRIXHUB_INTRO"
introGui.Parent = CoreGui
introGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
introGui.ResetOnSpawn = false

-- ==============================================
-- 🌟 INTRO ANIMADA
-- ==============================================
local intro = Instance.new("Frame")
intro.Name = "IntroScreen"
intro.BackgroundColor3 = C.Negro
intro.Size = UDim2.new(1, 0, 1, 0)
intro.Position = UDim2.new(0, 0, 0, 0)
intro.Parent = introGui
intro.ZIndex = 999

-- ⚡ RAYOS DE LUZ ANIMADOS
local rayos = {}
for i = 1, 15 do
    local ray = Instance.new("Frame")
    ray.BackgroundColor3 = i % 2 == 0 and C.Purpura or C.Azul
    ray.BackgroundTransparency = 0.7
    ray.Size = UDim2.new(0, 2, 1, 0)
    ray.Position = UDim2.new(0.07 * i, 0, 0, 0)
    ray.Rotation = -30 + i * 5
    ray.Parent = intro
    table.insert(rayos, ray)
end

-- 💫 AURA CENTRAL
local aura = Instance.new("Frame")
aura.BackgroundTransparency = 0.4
aura.BackgroundColor3 = C.Brillo
aura.Size = UDim2.new(0, 0, 0, 0)
aura.Position = UDim2.new(0.5, 0, 0.5, 0)
aura.AnchorPoint = Vector2.new(0.5, 0.5)
aura.Parent = intro
Instance.new("UICorner", aura).CornerRadius = UDim.new(1, 0)

-- 📛 TÍTULO
local titulo = Instance.new("TextLabel")
titulo.BackgroundTransparency = 1
titulo.Position = UDim2.new(0.5, 0, 0.55, 0)
titulo.AnchorPoint = Vector2.new(0.5, 0.5)
titulo.Size = UDim2.new(0, 380, 0, 70)
titulo.Font = Enum.Font.GothamBlack
titulo.Text = "NOXTRIXHUB DUEL"
titulo.TextColor3 = C.Brillo
titulo.TextSize = 38
titulo.TextTransparency = 1
titulo.TextStrokeTransparency = 0.6
titulo.Parent = intro

-- 🔗 DISCORD
local discordIntro = Instance.new("TextLabel")
discordIntro.BackgroundTransparency = 1
discordIntro.Position = UDim2.new(0.5, 0, 0.72, 0)
discordIntro.AnchorPoint = Vector2.new(0.5, 0.5)
discordIntro.Size = UDim2.new(0, 300, 0, 28)
discordIntro.Font = Enum.Font.GothamBold
discordIntro.Text = "discord.gg/tvAkYe7Uq"
discordIntro.TextColor3 = C.Azul
discordIntro.TextSize = 16
discordIntro.TextTransparency = 1
discordIntro.Parent = intro

-- ==============================================
-- ▶️ ANIMACIÓN Y CIERRE AUTOMÁTICO
-- ==============================================
task.spawn(function()
    -- Expansión del aura
    TS:Create(aura, TweenInfo.new(1.5), {Size = UDim2.new(0, 250, 0, 250), BackgroundTransparency = 0.7}):Play()
    
    -- Aparece el texto
    task.wait(0.5)
    TS:Create(titulo, TweenInfo.new(1.2), {TextTransparency = 0}):Play()
    TS:Create(discordIntro, TweenInfo.new(1.4), {TextTransparency = 0}):Play()
    
    -- Animación de rayos
    local t = 0
    local conn = RunService.Heartbeat:Connect(function()
        t += 0.05
        for i, ray in ipairs(rayos) do
            ray.BackgroundTransparency = 0.5 + math.sin(t + i) * 0.3
        end
    end)
    
    -- Tiempo que dura la intro → cámbialo si quieres más tiempo
    task.wait(4) -- ⏱️ Duración: 4 segundos
    
    -- Desvanecer y cerrar
    conn:Disconnect()
    TS:Create(intro, TweenInfo.new(1.2), {BackgroundTransparency = 1}):Play()
    TS:Create(titulo, TweenInfo.new(1), {TextTransparency = 1}):Play()
    TS:Create(discordIntro, TweenInfo.new(1), {TextTransparency = 1}):Play()
    
    task.wait(1.3)
    introGui:Destroy()
end)