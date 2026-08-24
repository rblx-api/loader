-- ==============================================
--  🎬 INTRO · NOXTRIXHUB DUEL
--  Discord: discord.gg/tvAkYe7Uq
--  ✅ SOLO INTRO — SIN PANEL
-- ==============================================

if _G.NoxtrixIntroLoaded then return end
_G.NoxtrixIntroLoaded = true

local TS = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

local C = {
    Purpura = Color3.fromRGB(140, 0, 255),
    Azul    = Color3.fromRGB(0, 180, 255),
}

local introGui = Instance.new("ScreenGui")
introGui.Name = "NOXTRIXHUB_INTRO"
introGui.Parent = CoreGui
introGui.ResetOnSpawn = false

local intro = Instance.new("Frame")
intro.Name = "IntroScreen"
intro.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
intro.Size = UDim2.new(1, 0, 1, 0)
intro.Parent = introGui

local fondo = Instance.new("ImageLabel")
fondo.BackgroundTransparency = 1
fondo.Size = UDim2.new(1, 0, 1, 0)
fondo.Position = UDim2.new(0, 0, 0, 0)
fondo.ScaleType = Enum.ScaleType.Fit
fondo.Image = "https://cdn.discordapp.com/attachments/1540625038368055367/1541307761713881188/842DA840-E58D-423C-B90C-F19FF3221320.gif?ex=6a8d1e36&is=6a8bccb6&hm=1ad53eb7ca5cb5092277fd58c01afbaa343deae92673b64493def48ea0bd03f6&"
fondo.Parent = intro

local titulo = Instance.new("TextLabel")
titulo.BackgroundTransparency = 1
titulo.Position = UDim2.new(0.5, 0, 0.75, 0)
titulo.AnchorPoint = Vector2.new(0.5, 0.5)
titulo.Size = UDim2.new(0, 420, 0, 70)
titulo.Font = Enum.Font.GothamBlack
titulo.Text = "NOXTRIXHUB DUEL"
titulo.TextColor3 = C.Purpura
titulo.TextSize = 42
titulo.TextTransparency = 1
titulo.TextStrokeTransparency = 0.4
titulo.Parent = intro

local discordIntro = Instance.new("TextLabel")
discordIntro.BackgroundTransparency = 1
discordIntro.Position = UDim2.new(0.5, 0, 0.85, 0)
discordIntro.AnchorPoint = Vector2.new(0.5, 0.5)
discordIntro.Size = UDim2.new(0, 320, 0, 28)
discordIntro.Font = Enum.Font.GothamBold
discordIntro.Text = "discord.gg/tvAkYe7Uq"
discordIntro.TextColor3 = C.Azul
discordIntro.TextSize = 16
discordIntro.TextTransparency = 1
discordIntro.Parent = intro

task.spawn(function()
    task.wait(0.5)
    TS:Create(titulo, TweenInfo.new(1.2), {TextTransparency = 0}):Play()
    TS:Create(discordIntro, TweenInfo.new(1.4), {TextTransparency = 0}):Play()

    task.wait(5)

    TS:Create(intro, TweenInfo.new(1.2), {BackgroundTransparency = 1}):Play()
    TS:Create(fondo, TweenInfo.new(1.2), {ImageTransparency = 1}):Play()
    TS:Create(titulo, TweenInfo.new(1), {TextTransparency = 1}):Play()
    TS:Create(discordIntro, TweenInfo.new(1), {TextTransparency = 1}):Play()

    task.wait(1.3)
    introGui:Destroy()
    _G.NoxtrixIntroLoaded = nil
end)