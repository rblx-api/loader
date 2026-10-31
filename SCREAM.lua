if _G.RivalHubRunning then
    warn("[Rival Hub] Instancia previa detectada. Se recomienda rejoin si hay comportamiento errático.")
end
_G.RivalHubRunning = false
_G.__RivalHubMainOriginalPos = nil

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local TS = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local HS = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local LP = Players.LocalPlayer
if not LP then
    local _lpConn
    _lpConn = Players.PlayerAdded:Connect(function(p) LP = p end)
    local _t0 = tick()
    while not LP and tick() - _t0 < 15 do task.wait(0.1) end
    if _lpConn then _lpConn:Disconnect() end
end
if not LP then
    warn("[Rival Hub] LocalPlayer no disponible en 15s. Abortando.")
    return
end

local pgui = LP:WaitForChild("PlayerGui", 20)
if not pgui then
    warn("[Rival Hub] PlayerGui no cargó en 20s. Abortando.")
    return
end

local camera = Workspace.CurrentCamera

_G.RivalHubRunning = true
_G.RivalHubSession = (_G.RivalHubSession or 0) + 1
local _mySession = _G.RivalHubSession

-- SCREAMHUB cinematic intro — max effects, wave, sound, click to skip
task.spawn(function()
    local introGui = Instance.new("ScreenGui")
    introGui.Name = "ScreamHubIntro"
    introGui.IgnoreGuiInset = true
    introGui.ResetOnSpawn = false
    introGui.DisplayOrder = 100000
    introGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    introGui.Parent = pgui

    local skipped = false
    local waveRunning = true
    local particlesAlive = true
    local introSound = nil

    local function destroyIntro()
        if skipped then return end
        skipped = true
        waveRunning = false
        particlesAlive = false
        pcall(function()
            if introSound then
                introSound:Stop()
                introSound:Destroy()
                introSound = nil
            end
        end)
        if introGui and introGui.Parent then
            introGui:Destroy()
        end
    end

    -- Fullscreen click catcher (skip anywhere)
    local clickCatch = Instance.new("TextButton")
    clickCatch.Name = "SkipCatcher"
    clickCatch.Size = UDim2.fromScale(1, 1)
    clickCatch.BackgroundTransparency = 1
    clickCatch.Text = ""
    clickCatch.ZIndex = 50
    clickCatch.Parent = introGui
    clickCatch.MouseButton1Click:Connect(function()
        destroyIntro()
    end)
    -- Also support touch
    clickCatch.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch
            or input.UserInputType == Enum.UserInputType.MouseButton1 then
            destroyIntro()
        end
    end)

    local shade = Instance.new("Frame")
    shade.Name = "IntroShade"
    shade.Size = UDim2.fromScale(1, 1)
    shade.BackgroundColor3 = Color3.fromRGB(3, 3, 5)
    shade.BackgroundTransparency = 1
    shade.BorderSizePixel = 0
    shade.ClipsDescendants = true
    shade.ZIndex = 1
    shade.Parent = introGui

    local vignette = Instance.new("UIGradient")
    vignette.Rotation = 90
    vignette.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(22, 22, 28)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0)),
    })
    vignette.Parent = shade

    -- Intro sound
    pcall(function()
        introSound = Instance.new("Sound")
        introSound.Name = "ScreamHubIntroSound"
        introSound.SoundId = "rbxassetid://113111119641714"
        introSound.Volume = 1
        introSound.Looped = false
        introSound.PlayOnRemove = false
        introSound.Parent = introGui
        introSound:Play()
    end)

    local function makeGlow(name, size, color, z)
        local g = Instance.new("Frame")
        g.Name = name
        g.AnchorPoint = Vector2.new(0.5, 0.5)
        g.Position = UDim2.fromScale(0.5, 0.5)
        g.Size = size
        g.BackgroundColor3 = color
        g.BackgroundTransparency = 1
        g.BorderSizePixel = 0
        g.ZIndex = z
        g.Parent = shade
        Instance.new("UICorner", g).CornerRadius = UDim.new(1, 0)
        local gr = Instance.new("UIGradient")
        gr.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.25),
            NumberSequenceKeypoint.new(0.5, 0.7),
            NumberSequenceKeypoint.new(1, 1),
        })
        gr.Parent = g
        return g
    end
    local glowA = makeGlow("GlowA", UDim2.fromOffset(620, 220), Color3.fromRGB(200, 200, 215), 1)
    local glowB = makeGlow("GlowB", UDim2.fromOffset(340, 120), Color3.fromRGB(255, 255, 255), 2)

    local particleLayer = Instance.new("Frame")
    particleLayer.Name = "Particles"
    particleLayer.Size = UDim2.fromScale(1, 1)
    particleLayer.BackgroundTransparency = 1
    particleLayer.ZIndex = 2
    particleLayer.ClipsDescendants = true
    particleLayer.Parent = shade

    task.spawn(function()
        while particlesAlive and introGui.Parent and not skipped do
            for _ = 1, 3 do
                if skipped then break end
                local p = Instance.new("Frame")
                local s = math.random(2, 5)
                p.Size = UDim2.fromOffset(s, s)
                p.Position = UDim2.new(math.random(), 0, 1.05, 0)
                p.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                p.BackgroundTransparency = math.random(40, 75) / 100
                p.BorderSizePixel = 0
                p.ZIndex = 2
                p.Parent = particleLayer
                Instance.new("UICorner", p).CornerRadius = UDim.new(1, 0)
                local dur = math.random(18, 32) / 10
                local drift = (math.random() - 0.5) * 0.25
                TS:Create(p, TweenInfo.new(dur, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    Position = UDim2.new(math.clamp(p.Position.X.Scale + drift, 0, 1), 0, -0.1, 0),
                    BackgroundTransparency = 1,
                }):Play()
                task.delay(dur + 0.05, function()
                    if p.Parent then p:Destroy() end
                end)
            end
            task.wait(0.12)
        end
    end)

    local ring = Instance.new("Frame")
    ring.Name = "Ring"
    ring.AnchorPoint = Vector2.new(0.5, 0.5)
    ring.Position = UDim2.fromScale(0.5, 0.5)
    ring.Size = UDim2.fromOffset(20, 20)
    ring.BackgroundTransparency = 1
    ring.BorderSizePixel = 0
    ring.ZIndex = 2
    ring.Parent = shade
    Instance.new("UICorner", ring).CornerRadius = UDim.new(1, 0)
    local ringStroke = Instance.new("UIStroke")
    ringStroke.Color = Color3.fromRGB(255, 255, 255)
    ringStroke.Thickness = 2
    ringStroke.Transparency = 1
    ringStroke.Parent = ring

    local scans = {}
    for i = 1, 3 do
        local scan = Instance.new("Frame")
        scan.Size = UDim2.new(1, 0, 0, (i == 2) and 2 or 1)
        scan.Position = UDim2.new(0, 0, -0.05 * i, 0)
        scan.BackgroundColor3 = Color3.fromRGB(230, 230, 240)
        scan.BackgroundTransparency = 0.5 + i * 0.1
        scan.BorderSizePixel = 0
        scan.ZIndex = 6
        scan.Parent = shade
        local sg = Instance.new("UIGradient")
        sg.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 1),
            NumberSequenceKeypoint.new(0.5, 0.15),
            NumberSequenceKeypoint.new(1, 1),
        })
        sg.Parent = scan
        scans[i] = scan
    end

    local letters = {"S", "C", "R", "E", "A", "M", "H", "U", "B"}
    local letterLabels = {}
    local container = Instance.new("Frame")
    container.Name = "TitleWave"
    container.AnchorPoint = Vector2.new(0.5, 0.5)
    container.Position = UDim2.fromScale(0.5, 0.5)
    container.Size = UDim2.new(0.95, 0, 0, 96)
    container.BackgroundTransparency = 1
    container.ZIndex = 4
    container.Parent = shade

    local layout = Instance.new("UIListLayout")
    layout.FillDirection = Enum.FillDirection.Horizontal
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    layout.VerticalAlignment = Enum.VerticalAlignment.Center
    layout.Padding = UDim.new(0, 1)
    layout.Parent = container

    local ghostLayers = {}
    for gi = 1, 2 do
        local ghost = Instance.new("Frame")
        ghost.Name = "Ghost" .. gi
        ghost.AnchorPoint = Vector2.new(0.5, 0.5)
        ghost.Position = UDim2.fromScale(0.5, 0.5)
        ghost.Size = UDim2.new(0.95, 0, 0, 96)
        ghost.BackgroundTransparency = 1
        ghost.ZIndex = 3
        ghost.Parent = shade
        local gl = Instance.new("UIListLayout")
        gl.FillDirection = Enum.FillDirection.Horizontal
        gl.HorizontalAlignment = Enum.HorizontalAlignment.Center
        gl.VerticalAlignment = Enum.VerticalAlignment.Center
        gl.Padding = UDim.new(0, 1)
        gl.Parent = ghost
        ghostLayers[gi] = {frame = ghost, labels = {}}
        for i, ch in ipairs(letters) do
            local lbl = Instance.new("TextLabel")
            lbl.Size = UDim2.new(0, 46, 0, 86)
            lbl.BackgroundTransparency = 1
            lbl.Text = ch
            lbl.TextColor3 = (gi == 1) and Color3.fromRGB(180, 180, 255) or Color3.fromRGB(255, 160, 160)
            lbl.TextTransparency = 1
            lbl.TextScaled = true
            lbl.Font = Enum.Font.GothamBlack
            lbl.Parent = ghost
            local lim = Instance.new("UITextSizeConstraint")
            lim.MinTextSize = 30
            lim.MaxTextSize = 68
            lim.Parent = lbl
            ghostLayers[gi].labels[i] = lbl
        end
    end

    for i, ch in ipairs(letters) do
        local lbl = Instance.new("TextLabel")
        lbl.Name = "L" .. i
        lbl.Size = UDim2.new(0, 46, 0, 86)
        lbl.BackgroundTransparency = 1
        lbl.Text = ch
        lbl.TextColor3 = Color3.fromRGB(240, 240, 245)
        lbl.TextTransparency = 1
        lbl.TextScaled = true
        lbl.Font = Enum.Font.GothamBlack
        lbl.ZIndex = 4
        lbl.Parent = container

        local lim = Instance.new("UITextSizeConstraint")
        lim.MinTextSize = 30
        lim.MaxTextSize = 68
        lim.Parent = lbl

        local st = Instance.new("UIStroke")
        st.Name = "Stroke"
        st.Color = Color3.fromRGB(255, 255, 255)
        st.Thickness = 1.6
        st.Transparency = 1
        st.Parent = lbl

        local gr = Instance.new("UIGradient")
        gr.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
            ColorSequenceKeypoint.new(0.4, Color3.fromRGB(210, 210, 220)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(110, 110, 125)),
        })
        gr.Rotation = 90
        gr.Parent = lbl

        letterLabels[i] = lbl
    end

    local sub = Instance.new("TextLabel")
    sub.AnchorPoint = Vector2.new(0.5, 0)
    sub.Position = UDim2.new(0.5, 0, 0.5, 54)
    sub.Size = UDim2.new(0.8, 0, 0, 20)
    sub.BackgroundTransparency = 1
    sub.Text = "●  SYSTEM ONLINE  ●"
    sub.TextColor3 = Color3.fromRGB(170, 170, 180)
    sub.TextTransparency = 1
    sub.TextSize = 11
    sub.Font = Enum.Font.GothamBold
    sub.ZIndex = 4
    sub.Parent = shade

    local line = Instance.new("Frame")
    line.AnchorPoint = Vector2.new(0.5, 0)
    line.Position = UDim2.new(0.5, 0, 0.5, 44)
    line.Size = UDim2.new(0, 0, 0, 1)
    line.BackgroundColor3 = Color3.fromRGB(230, 230, 240)
    line.BackgroundTransparency = 0.2
    line.BorderSizePixel = 0
    line.ZIndex = 4
    line.Parent = shade

    -- Click to skip hint
    local skipHint = Instance.new("TextLabel")
    skipHint.Name = "SkipHint"
    skipHint.AnchorPoint = Vector2.new(0.5, 1)
    skipHint.Position = UDim2.new(0.5, 0, 1, -28)
    skipHint.Size = UDim2.new(0.8, 0, 0, 20)
    skipHint.BackgroundTransparency = 1
    skipHint.Text = "click to skip"
    skipHint.TextColor3 = Color3.fromRGB(140, 140, 150)
    skipHint.TextTransparency = 1
    skipHint.TextSize = 12
    skipHint.Font = Enum.Font.GothamBold
    skipHint.ZIndex = 8
    skipHint.Parent = shade

    local flash = Instance.new("Frame")
    flash.Size = UDim2.fromScale(1, 1)
    flash.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    flash.BackgroundTransparency = 1
    flash.BorderSizePixel = 0
    flash.ZIndex = 10
    flash.Parent = shade

    local function stillActive()
        return not skipped and introGui.Parent
    end

    -- PHASE 1
    TS:Create(shade, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        BackgroundTransparency = 0.06,
    }):Play()
    TS:Create(glowA, TweenInfo.new(0.65), {BackgroundTransparency = 0.84}):Play()
    TS:Create(glowB, TweenInfo.new(0.65), {BackgroundTransparency = 0.88}):Play()
    TS:Create(skipHint, TweenInfo.new(0.6), {TextTransparency = 0.25}):Play()
    -- pulse skip hint
    task.spawn(function()
        while stillActive() do
            TS:Create(skipHint, TweenInfo.new(0.7, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
                TextTransparency = 0.55,
            }):Play()
            task.wait(0.7)
            if not stillActive() then break end
            TS:Create(skipHint, TweenInfo.new(0.7, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
                TextTransparency = 0.15,
            }):Play()
            task.wait(0.7)
        end
    end)
    task.wait(0.22)
    if not stillActive() then return end

    ringStroke.Transparency = 0.3
    TS:Create(ring, TweenInfo.new(0.7, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
        Size = UDim2.fromOffset(900, 900),
    }):Play()
    TS:Create(ringStroke, TweenInfo.new(0.7, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Transparency = 1,
        Thickness = 0.5,
    }):Play()

    -- PHASE 2 letters
    for i, lbl in ipairs(letterLabels) do
        task.delay((i - 1) * 0.04, function()
            if not stillActive() or not lbl.Parent then return end
            lbl.Position = UDim2.new(0, 0, 0, 28)
            lbl.TextTransparency = 1
            TS:Create(lbl, TweenInfo.new(0.38, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                TextTransparency = 0,
                Position = UDim2.new(0, 0, 0, 0),
            }):Play()
            local st = lbl:FindFirstChild("Stroke")
            if st then TS:Create(st, TweenInfo.new(0.35), {Transparency = 0.4}):Play() end
            for gi = 1, 2 do
                local gl = ghostLayers[gi].labels[i]
                if gl then TS:Create(gl, TweenInfo.new(0.25), {TextTransparency = 0.72}):Play() end
            end
        end)
    end
    task.wait(0.1 + #letters * 0.04)
    if not stillActive() then return end

    -- PHASE 3 wave
    task.spawn(function()
        local t0 = tick()
        while waveRunning and stillActive() do
            local t = tick() - t0
            for i, lbl in ipairs(letterLabels) do
                if lbl.Parent then
                    local y = math.sin(t * 3.8 + (i - 1) * 0.42) * 11
                    local scale = 1 + math.sin(t * 3.8 + (i - 1) * 0.42) * 0.04
                    lbl.Position = UDim2.new(0, 0, 0, y)
                    lbl.Size = UDim2.new(0, 46 * scale, 0, 86 * scale)
                end
            end
            ghostLayers[1].frame.Position = UDim2.new(0.5, math.sin(t * 9) * 3, 0.5, 0)
            ghostLayers[2].frame.Position = UDim2.new(0.5, -math.sin(t * 9) * 3, 0.5, 0)
            for gi = 1, 2 do
                for i, gl in ipairs(ghostLayers[gi].labels) do
                    if gl.Parent then
                        local y = math.sin(t * 3.8 + (i - 1) * 0.42) * 11
                        gl.Position = UDim2.new(0, 0, 0, y)
                    end
                end
            end
            task.wait()
        end
    end)

    task.spawn(function()
        local t0 = tick()
        while waveRunning and stillActive() do
            local t = tick() - t0
            for i, lbl in ipairs(letterLabels) do
                local gr = lbl:FindFirstChildOfClass("UIGradient")
                if gr then gr.Offset = Vector2.new(math.sin(t * 2.6 + i * 0.4) * 0.45, 0) end
            end
            task.wait(0.03)
        end
    end)

    for i, scan in ipairs(scans) do
        task.delay(i * 0.12, function()
            if stillActive() and scan.Parent then
                TS:Create(scan, TweenInfo.new(0.95 + i * 0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {
                    Position = UDim2.new(0, 0, 1.05, 0),
                    BackgroundTransparency = 0.9,
                }):Play()
            end
        end)
    end

    TS:Create(line, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 240, 0, 1),
    }):Play()
    TS:Create(sub, TweenInfo.new(0.4), {TextTransparency = 0.1}):Play()

    task.spawn(function()
        for _ = 1, 4 do
            if not stillActive() then break end
            TS:Create(glowA, TweenInfo.new(0.32, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
                BackgroundTransparency = 0.7, Size = UDim2.fromOffset(680, 240),
            }):Play()
            TS:Create(glowB, TweenInfo.new(0.32, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
                BackgroundTransparency = 0.78, Size = UDim2.fromOffset(380, 140),
            }):Play()
            task.wait(0.32)
            if not stillActive() then break end
            TS:Create(glowA, TweenInfo.new(0.32, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
                BackgroundTransparency = 0.88, Size = UDim2.fromOffset(580, 200),
            }):Play()
            TS:Create(glowB, TweenInfo.new(0.32, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
                BackgroundTransparency = 0.9, Size = UDim2.fromOffset(300, 110),
            }):Play()
            task.wait(0.32)
        end
    end)

    local function glitchBurst()
        if not stillActive() then return end
        flash.BackgroundTransparency = 0.85
        TS:Create(flash, TweenInfo.new(0.12), {BackgroundTransparency = 1}):Play()
        for i, lbl in ipairs(letterLabels) do
            if lbl.Parent then
                local ox = math.random(-5, 5)
                lbl.Position = UDim2.new(0, ox, 0, lbl.Position.Y.Offset + math.random(-3, 3))
                if math.random() > 0.6 then
                    lbl.TextTransparency = 0.35
                    task.delay(0.05, function()
                        if lbl.Parent then lbl.TextTransparency = 0 end
                    end)
                end
            end
        end
        ghostLayers[1].frame.Position = UDim2.new(0.5, math.random(4, 8), 0.5, 0)
        ghostLayers[2].frame.Position = UDim2.new(0.5, -math.random(4, 8), 0.5, 0)
    end

    task.wait(0.45)
    if not stillActive() then return end
    glitchBurst()
    task.wait(0.35)
    if not stillActive() then return end
    glitchBurst()
    task.wait(0.5)
    if not stillActive() then return end
    glitchBurst()

    task.wait(1.15)
    if not stillActive() then return end

    -- PHASE 4 natural exit
    waveRunning = false
    particlesAlive = false
    local fadeInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In)

    flash.BackgroundTransparency = 0.7
    TS:Create(flash, TweenInfo.new(0.45), {BackgroundTransparency = 1}):Play()

    for i, lbl in ipairs(letterLabels) do
        task.delay((i - 1) * 0.025, function()
            if skipped or not lbl.Parent then return end
            TS:Create(lbl, TweenInfo.new(0.38, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                TextTransparency = 1,
                Position = UDim2.new(0, 0, 0, -28),
            }):Play()
            local st = lbl:FindFirstChild("Stroke")
            if st then TS:Create(st, TweenInfo.new(0.3), {Transparency = 1}):Play() end
        end)
    end
    for gi = 1, 2 do
        for _, gl in ipairs(ghostLayers[gi].labels) do
            if gl.Parent then TS:Create(gl, fadeInfo, {TextTransparency = 1}):Play() end
        end
    end
    TS:Create(sub, fadeInfo, {TextTransparency = 1}):Play()
    TS:Create(skipHint, fadeInfo, {TextTransparency = 1}):Play()
    TS:Create(line, TweenInfo.new(0.35), {Size = UDim2.new(0, 0, 0, 1), BackgroundTransparency = 1}):Play()
    TS:Create(glowA, fadeInfo, {BackgroundTransparency = 1}):Play()
    TS:Create(glowB, fadeInfo, {BackgroundTransparency = 1}):Play()
    TS:Create(shade, fadeInfo, {BackgroundTransparency = 1}):Play()

    -- Fade sound out then stop
    if introSound then
        pcall(function()
            TS:Create(introSound, TweenInfo.new(0.45), {Volume = 0}):Play()
        end)
    end

    task.wait(0.7)
    if not skipped then
        pcall(function()
            if introSound then
                introSound:Stop()
                introSound:Destroy()
                introSound = nil
            end
        end)
        if introGui.Parent then introGui:Destroy() end
    end
end)


local RIVALHUB_LANGUAGE = "en"

local RIVALHUB_TRANSLATIONS = {
    es = { ["RESET ALL SETTINGS"]="RESTABLECER TODO", ["SETTINGS RESET"]="AJUSTES RESTABLECIDOS", ["CONFIRM?"]="¿CONFIRMAR?", ["ERROR"]="ERROR", ["RESET"]="RESTABLECER", ["Keybinds"]="TECLAS", ["Carry Mode"]="MODO CARGAR", ["Lagger Mode"]="MODO LAG", ["Auto Left"]="AUTO IZQUIERDA", ["Auto Right"]="AUTO DERECHA", ["Auto Bat"]="AUTO BATE", ["TP Down"]="TP ABAJO", ["Drop Brainrot"]="SOLTAR BRAINROT", ["Hide GUI"]="OCULTAR MENÚ", ["Normal Speed"]="VELOCIDAD NORMAL", ["Carry Speed"]="VELOCIDAD CARGAR", ["Current Mode"]="MODO ACTUAL", ["ACTIVATE"]="ACTIVAR" },
    pt = { ["RESET ALL SETTINGS"]="REDEFINIR TUDO", ["SETTINGS RESET"]="CONFIGURAÇÕES REDEFINIDAS", ["CONFIRM?"]="CONFIRMAR?", ["ERROR"]="ERRO", ["RESET"]="REDEFINIR", ["Keybinds"]="TECLAS", ["Carry Mode"]="MODO CARREGAR", ["Auto Left"]="AUTO ESQUERDA", ["Auto Right"]="AUTO DIREITA", ["Hide GUI"]="OCULTAR MENU", ["Normal Speed"]="VELOCIDADE NORMAL", ["Carry Speed"]="VELOCIDADE CARREGAR", ["ACTIVATE"]="ATIVAR" },
    fr = { ["RESET ALL SETTINGS"]="RÉINITIALISER", ["SETTINGS RESET"]="PARAMÈTRES RÉINITIALISÉS", ["CONFIRM?"]="CONFIRMER ?", ["ERROR"]="ERREUR", ["RESET"]="RÉINITIALISER", ["Keybinds"]="RACCOURCIS", ["Carry Mode"]="MODE PORTER", ["Auto Left"]="AUTO GAUCHE", ["Auto Right"]="AUTO DROITE", ["Hide GUI"]="MASQUER LE MENU", ["Normal Speed"]="VITESSE NORMALE", ["Carry Speed"]="VITESSE PORTER", ["ACTIVATE"]="ACTIVER" },
    de = { ["RESET ALL SETTINGS"]="ALLES ZURÜCKSETZEN", ["SETTINGS RESET"]="EINSTELLUNGEN ZURÜCKGESETZT", ["CONFIRM?"]="BESTÄTIGEN?", ["ERROR"]="FEHLER", ["RESET"]="ZURÜCKSETZEN", ["Keybinds"]="TASTEN", ["Carry Mode"]="TRAGEMODUS", ["Auto Left"]="AUTO LINKS", ["Auto Right"]="AUTO RECHTS", ["Hide GUI"]="MENÜ AUSBLENDEN", ["Normal Speed"]="NORMALE GESCHWINDIGKEIT", ["Carry Speed"]="TRAGEGESCHWINDIGKEIT", ["ACTIVATE"]="AKTIVIEREN" },
}

local function localizeRivalHubInterface(root)
    local dictionary = RIVALHUB_TRANSLATIONS[RIVALHUB_LANGUAGE]
    if not dictionary or not root then return end
    for _, object in ipairs(root:GetDescendants()) do
        if object:IsA("TextLabel") or object:IsA("TextButton") then
            local source = object:GetAttribute("RivalHubSourceText") or object.Text
            object:SetAttribute("RivalHubSourceText", source)
            local translated = dictionary[source]
            if translated then object.Text = translated end
        end
    end
end

local function rivalHubTranslate(source)
    local dictionary = RIVALHUB_TRANSLATIONS[RIVALHUB_LANGUAGE]
    return (dictionary and dictionary[source]) or source
end

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

local function waitForCharReady(char, timeout)
    timeout = timeout or 5
    local deadline = _tick() + timeout
    while (not char) or (not char.Parent)
          or (not char:FindFirstChild("HumanoidRootPart"))
          or (not char:FindFirstChildOfClass("Humanoid")) do
        if _tick() > deadline then return false end
        task.wait(0.05)
    end
    return true
end

NS = 59
CS = 29
LAGGER_SPEED = 40
LAGGER_CARRY_SPEED = 20
MEDUSA_COOLDOWN = 25
BAT_AIMBOT_SPEED = 55
BYPASS_AIMBOT_SPEED = 55
local State = {
    bypassBatEnabled = false,
    bypassBatSpeed = BYPASS_AIMBOT_SPEED,
}
CONFIG_FILE = "SCREAMHUB_" .. tostring(LP.UserId) .. ".json"
BAT_V2_HIT_DIST = 4.5
_isDraggingButton = false

backgroundIndex = 1
-- 3 backgrounds Ghostface / Scream
backgroundImages = {"118091463452609", "78348128982741", "135417991017029"}
ScreamUI = {effects = true, animated = {}, cards = {}, tweens = {}, backgroundRevision = 0}
useVenixCarryEngine = false

backgroundImageTransparency = 0
backgroundMode = "Background 1"
backgroundSelectorLabel = nil
miniBackgroundImage = nil
floatingButtonScale = 1
_floatingUIScales = {}

TPBatState = TPBatState or {
    enabled = false,
    connection = nil,
    hitCooldown = false,
    antiDieConnections = {},
}
TPBatState.enabled = false

function applyBackgroundMode(mode)
    if mode == "None" then
        backgroundMode = "None"
    else
        local n = tonumber(string.match(tostring(mode), "^Background%s+(%d+)$")) or backgroundIndex
        backgroundIndex = _clamp(_floor(n), 1, #backgroundImages)
        backgroundMode = "Background " .. backgroundIndex
    end
    ScreamUI.backgroundRevision = ScreamUI.backgroundRevision + 1
    local revision = ScreamUI.backgroundRevision
    if main then
        main.BackgroundColor3 = Color3.fromRGB(9, 7, 14)
        main.BackgroundTransparency = 0
        local bg = main:FindFirstChild("BackgroundImage")
        local overlay = main:FindFirstChild("BackgroundIncoming")
        if overlay then overlay:Destroy() end
        if ScreamUI.backgroundTween then ScreamUI.backgroundTween:Cancel() end
        if bg then
            local asset = "rbxassetid://" .. backgroundImages[backgroundIndex]
            local opacity = backgroundMode == "None" and 1 or backgroundImageTransparency
            if backgroundMode == "None" or not ScreamUI.effects or bg.Image == asset then
                bg.Image = asset
                bg.ImageTransparency = opacity
            else
                local incoming = bg:Clone()
                incoming.Name = "BackgroundIncoming"
                incoming.Image = asset
                incoming.ImageTransparency = 1
                incoming.ZIndex = 1
                incoming.Parent = main
                ScreamUI.backgroundTween = TS:Create(incoming, TweenInfo.new(0.28, Enum.EasingStyle.Quad), {ImageTransparency = opacity})
                ScreamUI.backgroundTween.Completed:Connect(function()
                    if revision == ScreamUI.backgroundRevision and bg.Parent then
                        bg.Image = asset
                        bg.ImageTransparency = opacity
                    end
                    if incoming.Parent then incoming:Destroy() end
                end)
                ScreamUI.backgroundTween:Play()
            end
        end
    end
    if ScreamUI.art and ScreamUI.art.Parent then
        ScreamUI.art.Image = "rbxassetid://" .. backgroundImages[backgroundIndex]
        ScreamUI.art.Visible = backgroundMode ~= "None"
    end
    if miniBackgroundImage then miniBackgroundImage.Visible = false end
    if backgroundSelectorLabel then backgroundSelectorLabel.Text = backgroundMode end
    for i, card in ipairs(ScreamUI.cards) do
        if card.Parent then
            local stroke = card:FindFirstChildOfClass("UIStroke")
            if stroke then stroke.Transparency = backgroundMode ~= "None" and i == backgroundIndex and 0 or 0.72 end
            local badge = card:FindFirstChild("Selected")
            if badge then badge.Visible = backgroundMode ~= "None" and i == backgroundIndex end
        end
    end
end

local COLOR_THEMES = {
    ["Orange"] = Color3.fromRGB(170, 170, 170),
    ["Pink"]   = Color3.fromRGB(255, 62, 176),
    ["Blue"]   = Color3.fromRGB(62, 151, 232),
    ["Cyan"]   = Color3.fromRGB(24, 224, 241),
    ["Green"]  = Color3.fromRGB(105, 244, 153),
    ["Purple"] = Color3.fromRGB(157, 92, 255),
    ["Red"]    = Color3.fromRGB(255, 79, 163),
    ["Neon"]   = Color3.fromRGB(53, 224, 255),
    ["Gold"]   = Color3.fromRGB(255, 221, 132),
    ["Gray"]   = Color3.fromRGB(170, 170, 170),
    ["White"]  = Color3.fromRGB(235, 235, 240),
}
COLOR_THEME_LIST = { "Purple", "Gray", "Pink", "Blue", "Cyan", "Green", "Red", "Neon", "Gold", "White" }

RIVAL_TITLE_THEMES = {
    ["Purple"] = { top = Color3.fromRGB(228, 205, 255), bottom = Color3.fromRGB(138, 78, 240) },
    ["Orange"] = { top = Color3.fromRGB(225, 225, 225), bottom = Color3.fromRGB(125, 125, 130) },
    ["Blue"]  = { top = Color3.fromRGB(60, 130, 255),  bottom = Color3.fromRGB(210, 220, 235) },
    ["Red"]   = { top = Color3.fromRGB(255, 70, 70),   bottom = Color3.fromRGB(215, 215, 215) },
    ["Green"] = { top = Color3.fromRGB(50, 220, 110),  bottom = Color3.fromRGB(200, 240, 210) },
    ["Black"] = { top = Color3.fromRGB(35, 35, 40),    bottom = Color3.fromRGB(115, 115, 125) },
    ["Gray"]  = { top = Color3.fromRGB(200, 200, 200), bottom = Color3.fromRGB(120, 120, 130) },
}
currentRivalTitleTheme = "Purple"
scriptLogoRef = nil
rivalTitleSelectorLabel = nil

function applyRivalTitleTheme(themeName)
    local t = RIVAL_TITLE_THEMES[themeName]
    if not t then return end
    currentRivalTitleTheme = themeName
    if scriptLogoRef then
        local grad = scriptLogoRef:FindFirstChildOfClass("UIGradient")
        if grad then
            grad.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, t.top),
                ColorSequenceKeypoint.new(1, t.bottom),
            })
        end
    end
    if rivalTitleSelectorLabel then
        rivalTitleSelectorLabel.Text = themeName
    end
    if saveAllSettings then pcall(saveAllSettings) end
end

currentColorTheme = "Purple"
selectedColor = COLOR_THEMES["Purple"]

function getThemeColor() return selectedColor end

function rivalHubGradient(c)
    return ColorSequence.new({
        ColorSequenceKeypoint.new(0.00, c:Lerp(Color3.new(1,1,1), 0.55)),
        ColorSequenceKeypoint.new(0.45, c),
        ColorSequenceKeypoint.new(1.00, c:Lerp(Color3.new(0,0,0), 0.35)),
    })
end

function rivalHubGradientSoft(c)
    return ColorSequence.new({
        ColorSequenceKeypoint.new(0.00, c:Lerp(Color3.new(1,1,1), 0.75)),
        ColorSequenceKeypoint.new(0.50, c:Lerp(Color3.new(1,1,1), 0.25)),
        ColorSequenceKeypoint.new(1.00, c:Lerp(Color3.new(0,0,0), 0.15)),
    })
end

function rivalHubGradientDark(c)
    return ColorSequence.new({
        ColorSequenceKeypoint.new(0.00, c:Lerp(Color3.fromRGB(0,0,0), 0.35)),
        ColorSequenceKeypoint.new(0.55, c:Lerp(Color3.fromRGB(0,0,0), 0.65)),
        ColorSequenceKeypoint.new(1.00, c:Lerp(Color3.fromRGB(0,0,0), 0.80)),
    })
end

function applyRivalHubGradientToLabel(label, c)
    if not label then return end
    local grad = label:FindFirstChildOfClass("UIGradient")
    if not grad then
        grad = Instance.new("UIGradient", label)
    end
    grad.Rotation = 0
    grad.Color = rivalHubGradient(c)
end

local _lastThemeUpdate = 0
local _lastThemeColor = nil

function applyColorTheme(themeName)
    local color = COLOR_THEMES[themeName]
    if not color then return end
    currentColorTheme = themeName
    selectedColor = color
    updateAllUIThemeColors(color)
    saveAllSettings()
end

_uicStroke = nil
_uicAvatarStroke = nil
_uicHandle = nil
_uicLine = nil

function updateAllUIThemeColors(color)
    local now = _tick()
    if color == _lastThemeColor and now - _lastThemeUpdate < 0.1 then return end
    _lastThemeUpdate = now
    _lastThemeColor = color

    if main then
        local mb = main:FindFirstChild("MainBorder")
        if mb and mb:IsA("UIStroke") then mb.Color = color end
    end

    if progressFill then
        local dim = Color3.new(color.R * 0.55, color.G * 0.55, color.B * 0.55)
        progressFill.BackgroundColor3 = color
        local grad = progressFill:FindFirstChildOfClass("UIGradient")
        if grad then
            grad.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, dim),
                ColorSequenceKeypoint.new(0.38, color),
                ColorSequenceKeypoint.new(0.68, color:Lerp(Color3.new(1, 1, 1), 0.34)),
                ColorSequenceKeypoint.new(1, dim),
            })
            grad.Rotation = -10
        end
    end
    if pbFrame then
        local border = pbFrame:FindFirstChild("OuterStroke")
        if border then border.Color = color end
        local fpsNeon = pbFrame:FindFirstChild("FPSNeon", true)
        if fpsNeon then fpsNeon.TextColor3 = Color3.fromRGB(255, 255, 255) end
        local pingNeon = pbFrame:FindFirstChild("PingNeon", true)
        if pingNeon then pingNeon.TextColor3 = Color3.fromRGB(255, 255, 255) end
        local divider = pbFrame:FindFirstChild("Divider", true)
        if divider and divider:IsA("Frame") then
            divider.BackgroundColor3 = Color3.fromRGB(200, 200, 210)
        end
        pbFrame.BackgroundColor3 = Color3.fromRGB(14, 10, 22)
    end

    if ScreamUI.speedStroke and ScreamUI.speedStroke.Parent then ScreamUI.speedStroke.Color = color end
    if ScreamUI.discordLabel and ScreamUI.discordLabel.Parent then ScreamUI.discordLabel.TextColor3 = color end

    if _uicStroke then _uicStroke.Color = color end
    if _uicAvatarStroke then _uicAvatarStroke.Color = color end
    if _uicHandle then _uicHandle.TextColor3 = Color3.fromRGB(180, 180, 188) end
    if _uicLine then _uicLine.BackgroundColor3 = color end

    local function searchAndUpdateText(parent)
        for _, child in ipairs(parent:GetDescendants()) do
            if child:IsA("TextLabel") then
                if child.Name == "DiscordText" then
                    child.TextColor3 = color
                    local grad = child:FindFirstChildOfClass("UIGradient")
                    if grad then
                        grad.Color = ColorSequence.new({
                            ColorSequenceKeypoint.new(0.00, color),
                            ColorSequenceKeypoint.new(0.30, Color3.fromRGB(200,200,200)),
                            ColorSequenceKeypoint.new(0.50, Color3.fromRGB(255,255,255)),
                            ColorSequenceKeypoint.new(0.70, Color3.fromRGB(200,200,200)),
                            ColorSequenceKeypoint.new(1.00, color),
                        })
                    end
                elseif child.Name == "SpeedLabel" then
                    local blue = Color3.fromRGB(180, 180, 188)
                    child.TextColor3 = blue
                    local grad = child:FindFirstChildOfClass("UIGradient")
                    if grad then
                        grad.Color = ColorSequence.new({
                            ColorSequenceKeypoint.new(0.00, blue),
                            ColorSequenceKeypoint.new(0.30, blue:Lerp(Color3.new(0.15,0.15,0.15), 0.25)),
                            ColorSequenceKeypoint.new(0.50, blue:Lerp(Color3.new(1,1,1), 0.55)),
                            ColorSequenceKeypoint.new(0.70, blue:Lerp(Color3.new(0.15,0.15,0.15), 0.25)),
                            ColorSequenceKeypoint.new(1.00, blue),
                        })
                    end
                end
            end
            if child:IsA("UIStroke") then
                if child.Color == Color3.fromRGB(180, 180, 190) then child.Color = color end
            end
        end
    end
    if gui then searchAndUpdateText(gui) end
    for _, tab in ipairs(tabButtons or {}) do
        local active = tab:GetAttribute("TabActive") == true
        local underline = tab:FindFirstChild("Underline")
        if underline then underline.BackgroundColor3 = color end
        local stroke = tab:FindFirstChild("TabStroke")
        if stroke then stroke.Color = color; stroke.Transparency = 1 end
        tab.BackgroundTransparency = 1
        local caption = tab:FindFirstChild("Caption")
        if caption then caption.TextColor3 = active and Color3.fromRGB(242, 238, 252) or Color3.fromRGB(98, 88, 120) end
    end
    if ScreamFX and ScreamFX.refreshAccent then pcall(ScreamFX.refreshAccent, color) end
    if _G.__RivalHubRefreshESPTheme then pcall(_G.__RivalHubRefreshESPTheme, color) end
    if main then
        local titleFrame = main:FindFirstChild("Frame")
        if titleFrame then
            for _, child in ipairs(titleFrame:GetDescendants()) do
                if child:IsA("UIStroke") and child.Color == Color3.fromRGB(180, 180, 190) then
                    child.Color = color
                end
            end
        end
    end
    if colorSelectorLabel then
        colorSelectorLabel.Text = currentColorTheme
        colorSelectorLabel.TextColor3 = color
    end

    if _G._rivalHubStealSlide then
        _G._rivalHubStealSlide.BackgroundColor3 = color
        local sg = _G._rivalHubStealSlide:FindFirstChildOfClass("UIGradient")
        if sg then sg.Color = rivalHubGradient(color) end
        local ss = _G._rivalHubStealSlide:FindFirstChildOfClass("UIStroke")
        if ss then ss.Color = color end
    end

    if miniBtn then
        
        local stroke = miniBtn:FindFirstChildOfClass("UIStroke")
        if stroke then stroke.Color = color end
    end

    if MobilePanel then
        for _, btn in ipairs(MobilePanel:GetChildren()) do
            if btn:IsA("TextButton") and btn:FindFirstChild("BtnGrad") then
                paintFloatingBtn(btn, btn:GetAttribute("MobActive") == true)
            end
        end
    end
end

local HOMERO_CFG = {
    body = { 10725826963, 86500008, 86500054, 86500036, 86500064, 86500078 },
    aplicarCuerpo = true,
    items = {
        { id = 103227700418, offset = _CFnew(0,0,0) },
        { id = 84952305140948,   offset = _CFnew(0,0,0) },
        { id = 122465238537030,  offset = _CFnew(0,0,0) },
    },
    shirt = nil,
    pants = "rbxassetid://78591690208112",
    skinColor = Color3.fromRGB(234,184,146),
    headColor = Color3.fromRGB(0,0,0),
}

local TAG = "LocalOutfit_"

local function loadObjects(id)
    local ok, res = pcall(function()
        return game:GetObjects("rbxassetid://" .. tostring(id))
    end)
    if ok and typeof(res) == "table" and #res > 0 then return res end
    ok, res = pcall(function()
        return game:GetService("InsertService"):LoadAsset(id)
    end)
    if ok and res then return { res } end
    return nil
end

local function collectParts(objs)
    local out = {}
    for _, o in ipairs(objs) do
        if o:IsA("BasePart") then out[#out + 1] = o end
        for _, d in ipairs(o:GetDescendants()) do
            if d:IsA("BasePart") then out[#out + 1] = d end
        end
    end
    return out
end

local function findAtt(char, name)
    for _, p in ipairs(char:GetDescendants()) do
        if p:IsA("Attachment") and p.Name == name and p.Parent:IsA("BasePart") then
            return p
        end
    end
end

local function applyBody(char)
    local total = 0
    for _, id in ipairs(HOMERO_CFG.body) do
        local objs = loadObjects(id)
        if objs then
            for _, mp in ipairs(collectParts(objs)) do
                local orig = char:FindFirstChild(mp.Name)
                if orig and orig:IsA("BasePart") then
                    local c = mp:Clone()
                    c.Name = TAG .. "body_" .. mp.Name
                    c.CanCollide = false
                    c.Anchored = false
                    c.Massless = true
                    c.Size = orig.Size
                    c.CFrame = orig.CFrame
                    c.Parent = char
                    local w = Instance.new("WeldConstraint")
                    w.Part0 = orig
                    w.Part1 = c
                    w.Parent = c
                    if orig:GetAttribute("RivalHubOutfitOriginalTransparency") == nil then
                        orig:SetAttribute("RivalHubOutfitOriginalTransparency", orig.Transparency)
                    end
                    orig.Transparency = 1
                    total = total + 1
                end
            end
            for _, o in ipairs(objs) do pcall(function() o:Destroy() end) end
        end
    end
    return total
end

local function attachItem(char, entry)
    local objs = loadObjects(entry.id)
    if not objs then return false end

    local handle
    for _, p in ipairs(collectParts(objs)) do
        if p.Name == "Handle" then handle = p; break end
        if not handle then handle = p end
    end
    if not handle then
        for _, o in ipairs(objs) do pcall(function() o:Destroy() end) end
        return false
    end

    local H = handle:Clone()
    for _, o in ipairs(objs) do pcall(function() o:Destroy() end) end

    H.Name = TAG .. "item_" .. tostring(entry.id)
    H.CanCollide = false
    H.Anchored = false
    H.Massless = true

    local wrap = H:FindFirstChildWhichIsA("WrapLayer")
    local target, c0, c1

    if wrap then
        target = char:FindFirstChild("UpperTorso")
              or char:FindFirstChild("Torso")
              or char:FindFirstChild("HumanoidRootPart")
        c0 = entry.offset or _CFnew()
        c1 = _CFnew()
    else
        local hAtt = H:FindFirstChildOfClass("Attachment")
        local bAtt = hAtt and findAtt(char, hAtt.Name)
        if bAtt then
            target = bAtt.Parent
            c0 = bAtt.CFrame * (entry.offset or _CFnew())
            c1 = hAtt.CFrame
        else
            target = char:FindFirstChild("Head")
            c0 = entry.offset or _CFnew(0, 1.4, 0)
            c1 = _CFnew()
        end
    end

    if not target then H:Destroy(); return false end

    H.CFrame = target.CFrame * c0 * c1:Inverse()
    H.Parent = char

    local w = Instance.new("Weld")
    w.Part0 = target
    w.Part1 = H
    w.C0 = c0
    w.C1 = c1
    w.Parent = H
    return true
end

function applyHomeroOutfit(char)
    if not char then char = LP.Character end
    if not char then return end
    char:WaitForChild("Humanoid", 10)
    char:WaitForChild("Head", 10)
    task.wait(0.4)

    for _, d in ipairs(char:GetChildren()) do
        if d.Name:sub(1, #TAG) == TAG then pcall(function() d:Destroy() end) end
    end

    if HOMERO_CFG.skinColor then
        local bc = char:FindFirstChildWhichIsA("BodyColors") or Instance.new("BodyColors")
        bc.HeadColor3 = HOMERO_CFG.headColor or HOMERO_CFG.skinColor
        bc.TorsoColor3 = HOMERO_CFG.skinColor
        bc.LeftArmColor3, bc.RightArmColor3 = HOMERO_CFG.skinColor, HOMERO_CFG.skinColor
        bc.LeftLegColor3, bc.RightLegColor3 = HOMERO_CFG.skinColor, HOMERO_CFG.skinColor
        bc.Parent = char
    end

    for _, a in ipairs(char:GetChildren()) do
        if a:IsA("Accessory") then
            local h = a:FindFirstChild("Handle")
            if h then h.Transparency = 1 end
        end
    end

    if HOMERO_CFG.shirt then
        local s = char:FindFirstChildWhichIsA("Shirt") or Instance.new("Shirt")
        s.Name = "Shirt"
        s.ShirtTemplate = HOMERO_CFG.shirt
        s.Parent = char
    end
    if HOMERO_CFG.pants then
        local p = char:FindFirstChildWhichIsA("Pants") or Instance.new("Pants")
        p.Name = "Pants"
        p.PantsTemplate = HOMERO_CFG.pants
        p.Parent = char
    end
    if HOMERO_CFG.aplicarCuerpo then applyBody(char) end
    for _, e in ipairs(HOMERO_CFG.items) do attachItem(char, e) end
end

local _originalAppearance = nil

local function captureOriginalAppearance(char)
    if not char or _originalAppearance then return end
    local data = {
        bodyColors = nil,
        shirt = nil,
        pants = nil,
        headMesh = nil,
        headTexture = nil,
    }
    local bc = char:FindFirstChildWhichIsA("BodyColors")
    if bc then
        data.bodyColors = {
            head = bc.HeadColor3,
            torso = bc.TorsoColor3,
            leftArm = bc.LeftArmColor3,
            rightArm = bc.RightArmColor3,
            leftLeg = bc.LeftLegColor3,
            rightLeg = bc.RightLegColor3,
        }
    end
    local sh = char:FindFirstChildWhichIsA("Shirt")
    if sh then data.shirt = sh.ShirtTemplate end
    local pa = char:FindFirstChildWhichIsA("Pants")
    if pa then data.pants = pa.PantsTemplate end
    local head = char:FindFirstChild("Head")
    if head then
        local sm = head:FindFirstChildWhichIsA("SpecialMesh")
        if sm and sm.MeshType == Enum.MeshType.FileMesh then
            data.headMesh = sm.MeshId
            data.headTexture = sm.TextureId
        end
    end
    _originalAppearance = data
end

local function clearPreviousOutfitAssets(char)
    if not char then return end
    for _, child in ipairs(char:GetChildren()) do
        if child.Name:sub(1, #TAG) == TAG
        or child.Name == "AuFfitAccessory"
        or child.Name == "BubbleSkinChanger_Hair"
        or child.Name == "Korblox_RightLeg" then
            pcall(function() child:Destroy() end)
        elseif child:IsA("CharacterMesh") and child.BodyPart == Enum.BodyPart.Head then
            pcall(function() child:Destroy() end)
        end
    end
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            local originalTransparency = part:GetAttribute("RivalHubOutfitOriginalTransparency")
            if originalTransparency ~= nil then
                part.Transparency = originalTransparency
                part:SetAttribute("RivalHubOutfitOriginalTransparency", nil)
            end
            local originalLocalTransparency = part:GetAttribute("RivalHubOutfitOriginalLocalTransparency")
            if originalLocalTransparency ~= nil then
                part.LocalTransparencyModifier = originalLocalTransparency
                part:SetAttribute("RivalHubOutfitOriginalLocalTransparency", nil)
            end
        end
    end
    if _originalAppearance and _originalAppearance.bodyColors then
        local bc = char:FindFirstChildWhichIsA("BodyColors") or Instance.new("BodyColors")
        local o = _originalAppearance.bodyColors
        bc.HeadColor3, bc.TorsoColor3 = o.head, o.torso
        bc.LeftArmColor3, bc.RightArmColor3 = o.leftArm, o.rightArm
        bc.LeftLegColor3, bc.RightLegColor3 = o.leftLeg, o.rightLeg
        bc.Parent = char
    end
    local head = char:FindFirstChild("Head")
    if head and head:IsA("MeshPart") and head:GetAttribute("RivalHubOutfitModifiedMeshPart") then
        pcall(function()
            head.MeshId = head:GetAttribute("RivalHubOutfitOriginalMeshId") or ""
            head.TextureID = head:GetAttribute("RivalHubOutfitOriginalTextureId") or ""
        end)
        head:SetAttribute("RivalHubOutfitModifiedMeshPart", nil)
        head:SetAttribute("RivalHubOutfitOriginalMeshId", nil)
        head:SetAttribute("RivalHubOutfitOriginalTextureId", nil)
    elseif head then
        local specialMesh = head:FindFirstChildWhichIsA("SpecialMesh")
        if specialMesh and specialMesh:GetAttribute("RivalHubOutfitCreatedMesh") then
            specialMesh:Destroy()
        elseif specialMesh and specialMesh:GetAttribute("RivalHubOutfitModifiedMesh") then
            specialMesh.MeshId = specialMesh:GetAttribute("RivalHubOutfitOriginalMeshId") or ""
            specialMesh.TextureId = specialMesh:GetAttribute("RivalHubOutfitOriginalTextureId") or ""
            specialMesh:SetAttribute("RivalHubOutfitModifiedMesh", nil)
            specialMesh:SetAttribute("RivalHubOutfitOriginalMeshId", nil)
            specialMesh:SetAttribute("RivalHubOutfitOriginalTextureId", nil)
        end
    end
end

local function applyNoOutfit(char)
    if not char then char = LP.Character end
    if not char then return end
    for _, d in ipairs(char:GetChildren()) do
        if d.Name:sub(1, #TAG) == TAG then pcall(function() d:Destroy() end) end
    end
    local oldAcc = char:FindFirstChild("AuFfitAccessory")
    if oldAcc then pcall(function() oldAcc:Destroy() end) end
    local oldKorblox = char:FindFirstChild("Korblox_RightLeg")
    if oldKorblox then pcall(function() oldKorblox:Destroy() end) end
    for _, d in ipairs(char:GetChildren()) do
        if d:IsA("CharacterMesh") and d.BodyPart == Enum.BodyPart.Head then
            pcall(function() d:Destroy() end)
        end
    end
    local head = char:FindFirstChild("Head")
    if head then
        head.Transparency = 0
        head.CanCollide = true
        head.LocalTransparencyModifier = 0
        local face = head:FindFirstChild("face")
        if face then face.Transparency = 0 end
        local sm = head:FindFirstChildWhichIsA("SpecialMesh")
        if sm then
            if _originalAppearance and _originalAppearance.headMesh then
                sm.MeshId = _originalAppearance.headMesh
                sm.TextureId = _originalAppearance.headTexture or ""
            else
                pcall(function() sm:Destroy() end)
            end
        end
    end
    pcall(function()
        local neck = char:FindFirstChild("Neck")
        if neck then neck.Enabled = true end
    end)
    for _, partName in ipairs({"RightUpperLeg", "RightLowerLeg", "RightFoot"}) do
        local limb = char:FindFirstChild(partName)
        if limb then limb.Transparency = 0 end
    end
    if _originalAppearance and _originalAppearance.bodyColors then
        local bc = char:FindFirstChildWhichIsA("BodyColors") or Instance.new("BodyColors")
        local o = _originalAppearance.bodyColors
        bc.HeadColor3 = o.head
        bc.TorsoColor3 = o.torso
        bc.LeftArmColor3 = o.leftArm
        bc.RightArmColor3 = o.rightArm
        bc.LeftLegColor3 = o.leftLeg
        bc.RightLegColor3 = o.rightLeg
        bc.Parent = char
    end
    if _originalAppearance and _originalAppearance.shirt then
        local s = char:FindFirstChildWhichIsA("Shirt") or Instance.new("Shirt")
        s.ShirtTemplate = _originalAppearance.shirt
        s.Parent = char
    end
    if _originalAppearance and _originalAppearance.pants then
        local p = char:FindFirstChildWhichIsA("Pants") or Instance.new("Pants")
        p.PantsTemplate = _originalAppearance.pants
        p.Parent = char
    end
    for _, a in ipairs(char:GetChildren()) do
        if a:IsA("Accessory") then
            local h = a:FindFirstChild("Handle")
            if h then h.Transparency = 0 end
        end
    end
    for _, item in ipairs(char:GetChildren()) do
        if item:IsA("Accessory") then
            for _, part in ipairs(item:GetDescendants()) do
                if part:IsA("BasePart") then
                    local original = part:GetAttribute("RivalHubOriginalTransparency")
                    if original ~= nil then part.Transparency = original; part:SetAttribute("RivalHubOriginalTransparency", nil) end
                    local originalLocal = part:GetAttribute("RivalHubOriginalLocalTransparency")
                    if originalLocal ~= nil then part.LocalTransparencyModifier = originalLocal; part:SetAttribute("RivalHubOriginalLocalTransparency", nil) end
                end
            end
        elseif item:IsA("Shirt") then
            local original = item:GetAttribute("RivalHubOriginalTemplate")
            if original ~= nil then item.ShirtTemplate = original; item:SetAttribute("RivalHubOriginalTemplate", nil) end
        elseif item:IsA("Pants") then
            local original = item:GetAttribute("RivalHubOriginalTemplate")
            if original ~= nil then item.PantsTemplate = original; item:SetAttribute("RivalHubOriginalTemplate", nil) end
        elseif item:IsA("ShirtGraphic") then
            local original = item:GetAttribute("RivalHubOriginalGraphic")
            if original ~= nil then item.Graphic = original; item:SetAttribute("RivalHubOriginalGraphic", nil) end
        end
    end
end

local OUTFITS = {
    { label = "OFF", customApply = applyNoOutfit },
    { accessory = 10159600649, offset = _V3new(0, 1, -0.2), shirt = "http://www.roblox.com/asset/?id=9683332638", pants = "http://www.roblox.com/asset/?id=93182020184041", headMesh = "http://www.roblox.com/asset/?id=134079402", headTexture = "http://www.roblox.com/asset/?id=133940918 ", korblox = "none", label = "Outfit 1", headlessKorblox = true },
    { accessory = 1744060292, offset = _V3new(0, 1.3, -0.2), shirt = "http://www.roblox.com/asset/?id=9683332638", pants = "http://www.roblox.com/asset/?id=93182020184041", headMesh = "http://www.roblox.com/asset/?id=134079402", headTexture = "http://www.roblox.com/asset/?id=133940918 ", korblox = "none", label = "Outfit 2", headlessKorblox = true },
    { bubbleShirt = 18552805597, bubblePants = 5414143509, bubbleHair = 84008082880128, label = "Outfit 5", headlessKorblox = false },
}
local currentOutfitIndex = 1
local outfitSelectorLabel = nil

VX7A = {
    index = 0, mod = nil, loading = false, busy = false, pending = nil, label = nil,
    labels = {"OFF", "ALIEN", "OUTFIT", "OUTFIT 2", "OUTFIT 3", "OUTFIT 4", "OUTFIT 5", "OUTFIT 6", "SCREAM", "NEW SKIN"},
}
VX7A.src = [==[
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local InsertService = game:GetService("InsertService")
local MarketplaceService = game:GetService("MarketplaceService")
local HttpService = game:GetService("HttpService")
local huiOk, huiResult = pcall(function() return gethui and gethui() end)
local CoreGui = huiOk and huiResult or game:GetService("CoreGui")
local LP = Players.LocalPlayer
local OUTFITS = {
{
id = 10997283529,
label = "ALIEN",
hideOriginal = false,
hideOriginalHead = true,
clearOriginalWearables = true,
bodyItems = {115566893133129, 103980259507115, 109790632200416, 112532740065682, 120301257476322},
items = {10997283529, 125085889448130},
},
{
label = "OUTFIT",
hideOriginal = false,
clearOriginalWearables = true,
bodyItems = {115566893133129, 103980259507115, 109790632200416, 112532740065682, 120301257476322},
items = {125157548394108, 123231522991173, 74827642361405},
},
{
label = "OUTFIT 2",
hideOriginal = false,
clearOriginalWearables = true,
bodyItems = {115566893133129, 103980259507115, 109790632200416, 112532740065682, 120301257476322},
scales = {HeightScale = 1, WidthScale = 0.85, DepthScale = 0.88, HeadScale = 0.95, BodyTypeScale = 1, ProportionScale = 0.85},
face = 86109936998865,
faceMode = "decal",
items = {136644276218918, 132022106987543, 131740907052260},
},
{
label = "OUTFIT 3",
hideOriginal = false,
headless = true,
clearOriginalWearables = true,
bodyItems = {115566893133129, 103980259507115, 109790632200416, 112532740065682, 120301257476322},
scales = {HeightScale = 1, WidthScale = 0.82, DepthScale = 0.85, HeadScale = 0.95, BodyTypeScale = 1, ProportionScale = 0.9},
layeredPuffiness = 0,
items = {119331031817124, 84952305140948},
},
{
label = "OUTFIT 4",
hideOriginal = false,
headless = true,
clearOriginalWearables = true,
bodyItems = {115566893133129, 103980259507115, 109790632200416, 112532740065682, 120301257476322},
scales = {HeightScale = 1, WidthScale = 0.82, DepthScale = 0.85, HeadScale = 0.95, BodyTypeScale = 1, ProportionScale = 0.9},
layeredPuffiness = 0,
items = {18902416696, 17739456422, 116750288839357, 12842417046, 122223069519702},
},
{
label = "OUTFIT 5",
hideOriginal = false,
clearOriginalWearables = true,
items = {13935333090, 16110951997, 10632503818},
},
{
label = "OUTFIT 6",
hideOriginal = false,
headless = true,
clearOriginalWearables = true,
items = {74891470, 4390891467, 91274263831244, 128424248603010, 91151766440767, 17044638424},
},
{
label = "SCREAM",
hideOriginal = false,
headless = true,
hideRightLeg = true,
localOnly = true,
clearOriginalWearables = true,
items = {76479271580913, 1402432199, 140627490971265, 128912609563885, 17449551560, 5796531729, 139607718},
},
{
label = "NEW SKIN",
localOnly = true,
preserveRig = true,
hideOriginal = false,
hideLeftLeg = true,
hideRightLeg = true,
clearOriginalWearables = true,
items = {70414871864071,14863917259,133498027006138,82277826177074},
accessorySlots = {[70414871864071]=Enum.AccessoryType.Waist,[14863917259]=Enum.AccessoryType.Neck,
[133498027006138]=Enum.AccessoryType.Shoulder,[82277826177074]=Enum.AccessoryType.Sweater},
},
}
local BODY_PART_NAMES = {
Head = true, UpperTorso = true, LowerTorso = true, Torso = true,
LeftUpperArm = true, LeftLowerArm = true, LeftHand = true,
RightUpperArm = true, RightLowerArm = true, RightHand = true,
LeftUpperLeg = true, LeftLowerLeg = true, LeftFoot = true,
RightUpperLeg = true, RightLowerLeg = true, RightFoot = true,
["Left Arm"] = true, ["Right Arm"] = true,
["Left Leg"] = true, ["Right Leg"] = true,
}
local PART_NAME_ALIASES = {
["Korblox-Deathspeaker-Right-Leg"] = "RightUpperLeg",
}
local state = {
enabled = false,
selected = 1,
visuals = {},
hidden = {},
wearableConn = nil,
headlessConn = nil,
headlessLoop = nil,
statsLoop = nil,
savedWalkSpeed = nil,
savedJumpPower = nil,
originalDescription = nil,
descriptionCharacter = nil,
connections = {},
}
local function currentCharacter()
local character = LP.Character or LP.CharacterAdded:Wait()
local humanoid = character:FindFirstChildOfClass("Humanoid") or character:WaitForChild("Humanoid", 8)
local root = character:FindFirstChild("HumanoidRootPart") or character:WaitForChild("HumanoidRootPart", 8)
return character, humanoid, root
end
local function restoreOriginalBody()
for object, saved in pairs(state.hidden) do
if object and object.Parent then
pcall(function()
if type(saved) == "table" and saved.basePart then
object.LocalTransparencyModifier = saved.localTransparency
object.Transparency = saved.transparency
elseif type(saved) == "table" and saved.properties then
for property, value in pairs(saved.properties) do object[property] = value end
elseif type(saved) == "table" and saved.property then
object[saved.property] = saved.value
elseif object:IsA("BasePart") then
object.LocalTransparencyModifier = saved
elseif object:IsA("Decal") or object:IsA("Texture") then
object.Transparency = saved
end
end)
end
end
state.hidden = {}
end
local stopHeadless
local enforceHeadless
local enforceStats
local function clearVisuals()
stopHeadless()
if state.wearableConn then
state.wearableConn:Disconnect()
state.wearableConn = nil
end
for _, object in ipairs(state.visuals) do
if object and object.Parent then pcall(function() object:Destroy() end) end
end
state.visuals = {}
restoreOriginalBody()
end
local function belongsToLocalVisual(object)
for _, visual in ipairs(state.visuals) do
if object == visual or object:IsDescendantOf(visual) then return true end
end
return false
end
local function hideOriginalBody(character)
restoreOriginalBody()
for _, object in ipairs(character:GetDescendants()) do
if not belongsToLocalVisual(object) then
if object:IsA("BasePart") then
state.hidden[object] = object.LocalTransparencyModifier
object.LocalTransparencyModifier = 1
elseif object:IsA("Decal") or object:IsA("Texture") then
state.hidden[object] = object.Transparency
object.Transparency = 1
end
end
end
end
local function hideOriginalHead(character)
local head = character:FindFirstChild("Head")
if not head or not head:IsA("BasePart") then return end
if state.hidden[head] == nil then
state.hidden[head] = {
basePart = true,
localTransparency = head.LocalTransparencyModifier,
transparency = head.Transparency,
}
elseif type(state.hidden[head]) ~= "table" then
state.hidden[head] = {
basePart = true,
localTransparency = state.hidden[head],
transparency = head.Transparency,
}
end
head.LocalTransparencyModifier = 1
head.Transparency = 1
for _, object in ipairs(head:GetDescendants()) do
if (object:IsA("Decal") or object:IsA("Texture")) and state.hidden[object] == nil then
state.hidden[object] = object.Transparency
object.Transparency = 1
end
end
end
local function hideLegSide(character, side)
local names = {side .. "UpperLeg", side .. "LowerLeg", side .. "Foot", side .. " Leg", side .. "Toe"}
for _, name in ipairs(names) do
local part = character:FindFirstChild(name)
if part and part:IsA("BasePart") then
if state.hidden[part] == nil then
state.hidden[part] = {
basePart = true,
localTransparency = part.LocalTransparencyModifier,
transparency = part.Transparency,
}
elseif type(state.hidden[part]) ~= "table" then
state.hidden[part] = {
basePart = true,
localTransparency = state.hidden[part],
transparency = part.Transparency,
}
end
part.LocalTransparencyModifier = 1
part.Transparency = 1
end
end
end
local function hideLeftLeg(character)
hideLegSide(character, "Left")
end
local function hideRightLeg(character)
hideLegSide(character, "Right")
end
stopHeadless = function()
if state.headlessConn then
pcall(state.headlessConn.Disconnect, state.headlessConn)
state.headlessConn = nil
end
if state.headlessLoop then
pcall(task.cancel, state.headlessLoop)
state.headlessLoop = nil
end
if state.statsLoop then
pcall(task.cancel, state.statsLoop)
state.statsLoop = nil
end
end
enforceHeadless = function(character, option)
stopHeadless()
if not option or not character or not (option.headless or option.hideLeftLeg or option.hideRightLeg) then return end
if option.headless then hideOriginalHead(character) end
if option.hideLeftLeg then hideLeftLeg(character) end
if option.hideRightLeg then hideRightLeg(character) end
state.headlessConn = character.ChildAdded:Connect(function(child)
if child:IsA("BasePart") and (option.hideLeftLeg or option.hideRightLeg) then
task.defer(function()
if state.enabled and LP.Character==character then
local active=OUTFITS[state.selected]
if active.hideLeftLeg then hideLeftLeg(character) end
if active.hideRightLeg then hideRightLeg(character) end end end) end
if child.Name == "Head" and child:IsA("BasePart") and OUTFITS[state.selected].headless then
task.defer(function()
if state.enabled and LP.Character == character and OUTFITS[state.selected].headless then
pcall(hideOriginalHead, character)
end
end)
end
end)
state.headlessLoop = task.spawn(function()
while state.enabled and LP.Character == character do
local opt = OUTFITS[state.selected]
if opt and opt.headless then
local head = character:FindFirstChild("Head")
if head and head:IsA("BasePart") and head.LocalTransparencyModifier < 1 then
pcall(hideOriginalHead, character)
end
end
if opt and opt.hideLeftLeg then
pcall(hideLeftLeg, character)
end
if opt and opt.hideRightLeg then
pcall(hideRightLeg, character)
end
task.wait(0.6)
end
end)
end
enforceStats = function(character)
if state.statsLoop then
pcall(task.cancel, state.statsLoop)
state.statsLoop = nil
end
state.statsLoop = task.spawn(function()
while state.enabled and LP.Character == character do
local humanoid = character:FindFirstChildOfClass("Humanoid")
if humanoid then
if state.savedWalkSpeed ~= nil and humanoid.WalkSpeed ~= state.savedWalkSpeed then
humanoid.WalkSpeed = state.savedWalkSpeed
end
if state.savedJumpPower ~= nil and humanoid.JumpPower ~= state.savedJumpPower then
humanoid.JumpPower = state.savedJumpPower
end
end
task.wait(0.4)
end
end)
end
local function hideOriginalWearables(character, watchForNew)
for _, child in ipairs(character:GetChildren()) do
if child:IsA("Shirt") or child:IsA("Pants") or child:IsA("ShirtGraphic") then
if not child:GetAttribute("VX7LocalOnly") and state.hidden[child] == nil then
local property = child:IsA("Shirt") and "ShirtTemplate"
or child:IsA("Pants") and "PantsTemplate"
or "Graphic"
state.hidden[child] = {property = property, value = child[property]}
child[property] = ""
end
end
end
for _, child in ipairs(character:GetDescendants()) do
if (child:IsA("Accessory") or child:IsA("Accoutrement")) and not child:GetAttribute("VX7LocalOnly") then
local objects = child:GetDescendants()
if child:IsA("BasePart") then table.insert(objects, child) end
for _, object in ipairs(objects) do
if object:IsA("BasePart") then
local saved = state.hidden[object]
if saved == nil then
state.hidden[object] = {
basePart = true,
localTransparency = object.LocalTransparencyModifier,
transparency = object.Transparency,
}
elseif type(saved) ~= "table" then
state.hidden[object] = {
basePart = true,
localTransparency = saved,
transparency = object.Transparency,
}
end
object.LocalTransparencyModifier = 1
object.Transparency = 1
elseif (object:IsA("Decal") or object:IsA("Texture")) and state.hidden[object] == nil then
state.hidden[object] = object.Transparency
object.Transparency = 1
elseif (object:IsA("ParticleEmitter") or object:IsA("Trail") or object:IsA("Beam")) and state.hidden[object] == nil then
state.hidden[object] = {property = "Enabled", value = object.Enabled}
object.Enabled = false
end
end
end
end
if watchForNew and not state.wearableConn then
state.wearableConn = character.DescendantAdded:Connect(function(object)
if not state.enabled or not OUTFITS[state.selected].clearOriginalWearables then return end
if object:IsA("Accessory") or object:IsA("Accoutrement")
or object:FindFirstAncestorWhichIsA("Accessory")
or object:FindFirstAncestorWhichIsA("Accoutrement") then
task.defer(function()
if state.enabled and character.Parent then hideOriginalWearables(character, false) end
end)
end
end)
end
end
local function loadAssetObjects(assetId)
local insertOk, inserted = pcall(function() return InsertService:LoadAsset(assetId) end)
if insertOk and inserted then return {inserted}, "InsertService" end
local objectOk, objects = pcall(function() return game:GetObjects("rbxassetid://" .. assetId) end)
if objectOk and objects and #objects > 0 then return objects, "GetObjects" end
return nil, tostring(inserted or objects or "unknown loading error")
end
local faceTextureCache = {}
local function resolveFaceTexture(faceId)
if faceTextureCache[faceId] then return faceTextureCache[faceId] end
local objects = loadAssetObjects(faceId)
if objects then
local texture
for _, root in ipairs(objects) do
local candidates = {root}
for _, object in ipairs(root:GetDescendants()) do table.insert(candidates, object) end
for _, object in ipairs(candidates) do
if object:IsA("Decal") or object:IsA("Texture") then
texture = object.Texture
if texture and texture ~= "" then break end
end
end
pcall(function() root:Destroy() end)
if texture and texture ~= "" then break end
end
if texture and texture ~= "" then
faceTextureCache[faceId] = texture
return texture
end
end
return "rbxassetid://" .. tostring(faceId)
end
local function applyLocalFace(character, faceId)
local head = character:FindFirstChild("Head")
if not head then return false end
local face = head:FindFirstChild("face") or head:FindFirstChildWhichIsA("Decal")
if face and not face:IsA("Decal") then face = nil end
if face then
if state.hidden[face] == nil then
state.hidden[face] = {
properties = {Texture = face.Texture, Transparency = face.Transparency},
}
end
else
face = Instance.new("Decal")
face.Name = "face"
face.Face = Enum.NormalId.Front
face:SetAttribute("VX7LocalOnly", true)
face.Parent = head
table.insert(state.visuals, face)
end
face.Texture = resolveFaceTexture(faceId)
face.Transparency = 0
return true
end
local function applyLocalFaceStable(character, faceId)
pcall(applyLocalFace, character, faceId)
for _, delayTime in ipairs({0.2, 0.8}) do
task.delay(delayTime, function()
local option = OUTFITS[state.selected]
if state.enabled and LP.Character == character and option and option.face == faceId then
pcall(applyLocalFace, character, faceId)
end
end)
end
end
local function findCharacterAttachment(character, name)
for _, object in ipairs(character:GetDescendants()) do
if object:IsA("Attachment") and object.Name == name and not object:FindFirstAncestorWhichIsA("Accessory") then
return object
end
end
end
local function sanitizeVisual(container)
local objects = container:GetDescendants()
if container:IsA("BasePart") then table.insert(objects, container) end
for _, object in ipairs(objects) do
if object:IsA("LuaSourceContainer") then
object:Destroy()
elseif object:IsA("BasePart") then
object.Anchored = false
object.CanCollide = false
object.CanTouch = false
object.CanQuery = false
object.Massless = true
object.CastShadow = false
elseif object:IsA("JointInstance") and object.Name == "AccessoryWeld" then
object:Destroy()
end
end
end
local function weldPart(part, target)
local weld = Instance.new("WeldConstraint")
weld.Name = "VX7LocalVisualWeld"
weld.Part0 = target
weld.Part1 = part
weld.Parent = part
end
local function countStackedAccessories(character, attachmentName)
local count = 0
for _, visual in ipairs(state.visuals) do
if visual:IsA("Accessory") then
local h = visual:FindFirstChild("Handle") or visual:FindFirstChildWhichIsA("BasePart", true)
if h then
for _, child in ipairs(h:GetChildren()) do
if child:IsA("Attachment") and child.Name == attachmentName then
count = count + 1
break
end
end
end
end
end
return count
end
local function attachAccessoryLocal(accessory, character, rootPart, assetId)
local handle = accessory:FindFirstChild("Handle") or accessory:FindFirstChildWhichIsA("BasePart", true)
if not handle then return false end
sanitizeVisual(accessory)
accessory.Name = "VX7_LocalOutfit_" .. tostring(assetId)
accessory:SetAttribute("VX7AssetId", assetId)
accessory:SetAttribute("VX7LocalOnly", true)
local option=OUTFITS[state.selected]
local slot=option and option.accessorySlots and option.accessorySlots[assetId]
if slot then pcall(function() accessory.AccessoryType=slot end) end
accessory.Parent = character
local sourceAttachment
for _, child in ipairs(handle:GetChildren()) do
if child:IsA("Attachment") and findCharacterAttachment(character, child.Name) then
sourceAttachment = child
break
end
end
local targetAttachment = sourceAttachment and findCharacterAttachment(character, sourceAttachment.Name)
local targetPart = targetAttachment and targetAttachment.Parent
if targetAttachment and targetPart and targetPart:IsA("BasePart") then
handle.CFrame = targetAttachment.WorldCFrame * sourceAttachment.CFrame:Inverse()
local stacked = countStackedAccessories(character, sourceAttachment.Name)
if stacked > 0 then
handle.CFrame = handle.CFrame * CFrame.new(0, stacked * 0.15, 0)
end
else
targetPart = character:FindFirstChild("LowerTorso")
or character:FindFirstChild("Torso")
or rootPart
if not targetPart then accessory:Destroy(); return false end
handle.CFrame = rootPart.CFrame
end
weldPart(handle, targetPart)
table.insert(state.visuals, accessory)
return true
end
local function attachLooseVisual(rootObject, character, rootPart, assetId, textureId, targetPart)
local clone = rootObject:Clone()
sanitizeVisual(clone)
clone.Name = "VX7_LocalOutfit_" .. tostring(assetId)
clone:SetAttribute("VX7AssetId", assetId)
clone.Parent = character
local parts = {}
if clone:IsA("BasePart") then table.insert(parts, clone) end
for _, object in ipairs(clone:GetDescendants()) do
if object:IsA("BasePart") then table.insert(parts, object) end
end
if #parts == 0 then clone:Destroy(); return false end
local anchor = targetPart or rootPart
if textureId then
for _, part in ipairs(parts) do
if part:IsA("MeshPart") then
pcall(function() part.TextureID = "rbxassetid://" .. tostring(textureId) end)
end
end
end
local pivot = clone:IsA("Model") and clone:GetPivot() or parts[1].CFrame
for _, part in ipairs(parts) do
local offset = pivot:ToObjectSpace(part.CFrame)
part.CFrame = anchor.CFrame * offset
weldPart(part, anchor)
end
table.insert(state.visuals, clone)
return true
end
local function attachClassicClothingLocal(rootObject, character, assetId)
local candidates = {}
if rootObject:IsA("Shirt") or rootObject:IsA("Pants") or rootObject:IsA("ShirtGraphic") then
table.insert(candidates, rootObject)
end
for _, object in ipairs(rootObject:GetDescendants()) do
if object:IsA("Shirt") or object:IsA("Pants") or object:IsA("ShirtGraphic") then
table.insert(candidates, object)
end
end
local added = 0
for _, source in ipairs(candidates) do
for _, existing in ipairs(character:GetChildren()) do
if existing.ClassName == source.ClassName and not existing:GetAttribute("VX7LocalOnly") then
local property = existing:IsA("Shirt") and "ShirtTemplate"
or existing:IsA("Pants") and "PantsTemplate"
or "Graphic"
state.hidden[existing] = {property = property, value = existing[property]}
existing[property] = ""
end
end
local clone = source:Clone()
clone.Name = "VX7_LocalClothing_" .. tostring(assetId)
clone:SetAttribute("VX7AssetId", assetId)
clone:SetAttribute("VX7LocalOnly", true)
clone.Parent = character
table.insert(state.visuals, clone)
added = added + 1
end
return added
end
local function attachBodyPartsLocal(rootObject, character, assetId, textureId)
local holder = Instance.new("Model")
holder.Name = "VX7_LocalBody_" .. tostring(assetId)
holder:SetAttribute("VX7AssetId", assetId)
holder:SetAttribute("VX7LocalOnly", true)
holder.Parent = character
local bodyColors = rootObject:FindFirstChildOfClass("BodyColors")
local colorProperties = {
Head = "HeadColor", UpperTorso = "TorsoColor", LowerTorso = "TorsoColor", Torso = "TorsoColor",
LeftUpperArm = "LeftArmColor", LeftLowerArm = "LeftArmColor", LeftHand = "LeftArmColor", ["Left Arm"] = "LeftArmColor",
RightUpperArm = "RightArmColor", RightLowerArm = "RightArmColor", RightHand = "RightArmColor", ["Right Arm"] = "RightArmColor",
LeftUpperLeg = "LeftLegColor", LeftLowerLeg = "LeftLegColor", LeftFoot = "LeftLegColor", ["Left Leg"] = "LeftLegColor",
RightUpperLeg = "RightLegColor", RightLowerLeg = "RightLegColor", RightFoot = "RightLegColor", ["Right Leg"] = "RightLegColor",
}
local added = 0
local candidates = {}
if rootObject:IsA("BasePart") then table.insert(candidates, rootObject) end
for _, object in ipairs(rootObject:GetDescendants()) do
if object:IsA("BasePart") and not object:FindFirstAncestorWhichIsA("Accessory") then
table.insert(candidates, object)
end
end
for _, source in ipairs(candidates) do
local partName = source.Name
if BODY_PART_NAMES[partName] then
local target = character:FindFirstChild(partName)
if not target then
local alias = PART_NAME_ALIASES[partName]
if alias then target = character:FindFirstChild(alias) end
end
if target and target:IsA("BasePart") then
local clone = source:Clone()
for _, child in ipairs(clone:GetDescendants()) do
if child:IsA("JointInstance") or child:IsA("Constraint") or child:IsA("LuaSourceContainer") then
child:Destroy()
end
end
sanitizeVisual(clone)
clone.Name = source.Name
if clone:IsA("MeshPart") and textureId then
pcall(function() clone.TextureID = "rbxassetid://" .. tostring(textureId) end)
end
if bodyColors and colorProperties[source.Name] then
pcall(function() clone.Color = bodyColors[colorProperties[source.Name]].Color end)
end
clone.CFrame = target.CFrame
clone.Parent = holder
weldPart(clone, target)
added = added + 1
end
end
end
if added == 0 then holder:Destroy(); return 0 end
table.insert(state.visuals, holder)
return added
end
local assetInfoCache = {}
local ASSET_INFO_CACHE_FILE="RivalHubAvatarAssets.json"
pcall(function()
if isfile and readfile and isfile(ASSET_INFO_CACHE_FILE) then
local decoded=HttpService:JSONDecode(readfile(ASSET_INFO_CACHE_FILE))
if type(decoded)=="table" then for id,assetType in pairs(decoded) do
local numericId=tonumber(id);local numericType=tonumber(assetType)
if numericId and numericType then assetInfoCache[numericId]=numericType end end end end end)
local assetInfoSaveQueued=false
local function saveAssetInfoCache()
if assetInfoSaveQueued or not writefile then return end
assetInfoSaveQueued=true;task.delay(.4,function()
assetInfoSaveQueued=false;pcall(function()
local encoded={};for id,assetType in pairs(assetInfoCache) do encoded[tostring(id)]=assetType end
writefile(ASSET_INFO_CACHE_FILE,HttpService:JSONEncode(encoded)) end) end) end
local bodyPropertyByType = {
[17] = "Head", [27] = "Torso", [28] = "RightArm",
[29] = "LeftArm", [30] = "LeftLeg", [31] = "RightLeg", [79] = "Head",
}
local bodyPartAnchorNames = {
[17] = {"Head"}, [79] = {"Head"},
[27] = {"UpperTorso", "Torso"},
[28] = {"RightUpperArm", "Right Arm"},
[29] = {"LeftUpperArm", "Left Arm"},
[30] = {"LeftUpperLeg", "Left Leg"},
[31] = {"RightUpperLeg", "Right Leg"},
}
local accessoryTypeByAssetType = {
[8] = Enum.AccessoryType.Hat,
[41] = Enum.AccessoryType.Hair,
[42] = Enum.AccessoryType.Face,
[43] = Enum.AccessoryType.Neck,
[44] = Enum.AccessoryType.Shoulder,
[45] = Enum.AccessoryType.Front,
[46] = Enum.AccessoryType.Back,
[47] = Enum.AccessoryType.Waist,
[64] = Enum.AccessoryType.TShirt,
[65] = Enum.AccessoryType.Shirt,
[66] = Enum.AccessoryType.Pants,
[67] = Enum.AccessoryType.Jacket,
[68] = Enum.AccessoryType.Sweater,
[69] = Enum.AccessoryType.Shorts,
[70] = Enum.AccessoryType.LeftShoe,
[71] = Enum.AccessoryType.RightShoe,
[72] = Enum.AccessoryType.DressSkirt,
[76] = Enum.AccessoryType.Eyebrow,
[77] = Enum.AccessoryType.Eyelash,
}
local function getAssetTypeId(assetId)
if assetInfoCache[assetId] then return assetInfoCache[assetId] end
local ok, info = pcall(MarketplaceService.GetProductInfo, MarketplaceService, assetId, Enum.InfoType.Asset)
if ok and info and info.AssetTypeId then
assetInfoCache[assetId] = info.AssetTypeId
saveAssetInfoCache()
return info.AssetTypeId
end
end
local accessoryDescriptionProperties = {
"BackAccessory", "FaceAccessory", "FrontAccessory", "HairAccessory",
"HatAccessory", "NeckAccessory", "ShouldersAccessory", "WaistAccessory",
"TShirtAccessory", "ShirtAccessory", "PantsAccessory", "JacketAccessory",
"SweaterAccessory", "ShortsAccessory", "DressSkirtAccessory",
"EyebrowAccessory", "EyelashAccessory",
}
local function createDirectDescription(option, humanoid)
local directOutfitId = option.outfitId
local completeOutfitDescription
if directOutfitId then
local ok, outfitDescription = pcall(
Players.GetHumanoidDescriptionFromOutfitId,
Players,
directOutfitId
)
if not ok or not outfitDescription then return nil end
completeOutfitDescription = outfitDescription
if not option.items and not option.face and not option.head then return outfitDescription end
end
local source = completeOutfitDescription or state.originalDescription
if not source then
local ok, applied = pcall(function() return humanoid:GetAppliedDescription() end)
if not ok or not applied then return nil end
source = applied
end
local description = source:Clone()
if completeOutfitDescription then completeOutfitDescription:Destroy() end
if not directOutfitId then
description.Shirt = 0
description.Pants = 0
description.GraphicTShirt = 0
for _, property in ipairs(accessoryDescriptionProperties) do
pcall(function() description[property] = "" end)
end
pcall(function() description:SetAccessories({}, true) end)
end
local accessories = {}
if directOutfitId then
pcall(function() accessories = description:GetAccessories(true) end)
end
local allItems = {}
for _, id in ipairs(option.bodyItems or {}) do table.insert(allItems, id) end
for _, id in ipairs(option.items or {}) do table.insert(allItems, id) end
for _, id in ipairs(allItems) do
local assetTypeId = getAssetTypeId(id)
if not assetTypeId then description:Destroy(); return nil end
local bodyProperty = bodyPropertyByType[assetTypeId]
local accessoryType = accessoryTypeByAssetType[assetTypeId]
if bodyProperty then
description[bodyProperty] = id
elseif assetTypeId == 11 then
description.Shirt = id
elseif assetTypeId == 12 then
description.Pants = id
elseif assetTypeId == 1 then
description.GraphicTShirt = id
elseif assetTypeId == 18 then
description.Face = id
elseif accessoryType then
local accessory = {
AssetId = id,
AccessoryType = accessoryType,
Order = #accessories + 1,
}
if assetTypeId >= 64 and assetTypeId <= 72 then
accessory.IsLayered = true
accessory.Puffiness = option.layeredPuffiness or 0
end
table.insert(accessories, accessory)
else
description:Destroy()
return nil
end
end
if option.face then
local faceTypeId = getAssetTypeId(option.face)
local faceBodyProperty = faceTypeId and bodyPropertyByType[faceTypeId]
local faceAccessoryType = faceTypeId and accessoryTypeByAssetType[faceTypeId]
if option.faceMode == "decal" then
if faceTypeId == 18 then description.Face = option.face end
elseif faceBodyProperty then
description[faceBodyProperty] = option.face
elseif faceAccessoryType then
table.insert(accessories, {
AssetId = option.face,
AccessoryType = faceAccessoryType,
Order = #accessories + 1,
})
elseif faceTypeId == 18 then
description.Face = option.face
end
end
if option.head then description.Head = option.head end
for property, value in pairs(option.scales or {}) do
pcall(function() description[property] = value end)
end
if option.skinColor then
for _, property in ipairs({"HeadColor", "LeftArmColor", "RightArmColor", "LeftLegColor", "RightLegColor", "TorsoColor"}) do
description[property] = option.skinColor
end
end
if #accessories > 0 then
local ok = pcall(function() description:SetAccessories(accessories, true) end)
if not ok then description:Destroy(); return nil end
end
return description
end
local statusText
local function setStatus(text, good)
if not statusText or not statusText.Parent then return end
statusText.Text = text
statusText.TextColor3 = good and Color3.fromRGB(215, 255, 222) or Color3.fromRGB(190, 190, 198)
end
local function applyOutfit()
local character, humanoid, rootPart = currentCharacter()
if not character or not humanoid or not rootPart then setStatus("Character not found", false); return false end
if state.descriptionCharacter ~= character or not state.originalDescription then
state.descriptionCharacter = character
state.originalDescription = nil
local ok, applied = pcall(function() return humanoid:GetAppliedDescription() end)
if ok and applied then state.originalDescription = applied:Clone() end
end
clearVisuals()
setStatus("Loading local visual...", false)
local option = OUTFITS[state.selected]
local assetId = option.id or option.outfitId
state.skipDescriptionRestore=option.preserveRig==true
if option.forceBodyParts or option.localOnly then
setStatus("Local visual only (no rig change)...", false)
end
if (option.bodyItems or option.items or option.outfitId) and not option.forceBodyParts and not option.localOnly then
setStatus(option.outfitId and "Loading complete outfit..." or "Applying outfit and complexion...", false)
local description = createDirectDescription(option, humanoid)
if description then
local savedHead = character:FindFirstChild("Head")
local savedHealth = humanoid.Health
state.savedWalkSpeed = humanoid.WalkSpeed
state.savedJumpPower = humanoid.JumpPower
local savedCFrame = rootPart.CFrame
local savedVelocity = rootPart.AssemblyLinearVelocity
local ok = pcall(function() humanoid:ApplyDescription(description) end)
if not ok then ok = pcall(function() humanoid:ApplyDescriptionReset(description) end) end
description:Destroy()
if ok then
local currentHumanoid = character:FindFirstChildOfClass("Humanoid")
local currentRoot = character:FindFirstChild("HumanoidRootPart")
if currentHumanoid and savedHealth > 0 then
currentHumanoid.Health = math.min(savedHealth, currentHumanoid.MaxHealth)
end
if currentRoot then
currentRoot.CFrame = savedCFrame
currentRoot.AssemblyLinearVelocity = savedVelocity
currentRoot.AssemblyAngularVelocity = Vector3.zero
end
if option.face then
local faceTypeId = getAssetTypeId(option.face)
if option.faceMode == "decal" or not faceTypeId or faceTypeId == 18 then
applyLocalFaceStable(character, option.face)
end
end
state.enabled = true
enforceStats(character)
enforceHeadless(character, option)
if option.hideLeftLeg then hideLeftLeg(character) end
if option.hideRightLeg then hideRightLeg(character) end
if option.head and character:FindFirstChild("Head") == savedHead then
hideOriginalHead(character)
end
setStatus(option.label .. " applied - native avatar method", true)
return true
end
end
setStatus("Native apply failed; using visual fallback...", false)
end
local assetIds = {}
for _, id in ipairs(option.items or {}) do table.insert(assetIds, id) end
if option.head then table.insert(assetIds, option.head) end
if #assetIds == 0 and assetId and not option.outfitId then table.insert(assetIds, assetId) end
local fallbackFaceType = option.face and getAssetTypeId(option.face)
local faceIsAccessory = option.faceMode ~= "decal"
and fallbackFaceType
and accessoryTypeByAssetType[fallbackFaceType] ~= nil
if faceIsAccessory then table.insert(assetIds, option.face) end
local attached, expected = 0, 0
local lastError
expected = expected + (option.face and not faceIsAccessory and 1 or 0)
for _, currentAssetId in ipairs(assetIds) do
local objects, method = loadAssetObjects(currentAssetId)
if objects then
for _, loadedRoot in ipairs(objects) do
local rootAttached = false
local bodyPartsAttached = false
local classics = {}
if loadedRoot:IsA("Shirt") or loadedRoot:IsA("Pants") or loadedRoot:IsA("ShirtGraphic") then
table.insert(classics, loadedRoot)
end
for _, object in ipairs(loadedRoot:GetDescendants()) do
if object:IsA("Shirt") or object:IsA("Pants") or object:IsA("ShirtGraphic") then
table.insert(classics, object)
end
end
local accessories = {}
if loadedRoot:IsA("Accessory") then
table.insert(accessories, loadedRoot)
else
for _, object in ipairs(loadedRoot:GetDescendants()) do
if object:IsA("Accessory") then table.insert(accessories, object:Clone()) end
end
end
local assetTypeId = getAssetTypeId(currentAssetId)
local isBodyPartAsset = assetTypeId ~= nil and bodyPropertyByType[assetTypeId] ~= nil
local bodyCandidates = 0
local wantsBodyParts = not loadedRoot:IsA("Accessory")
and (option.hideOriginal or option.hideOriginalHead or currentAssetId == option.head or (option.forceBodyParts and isBodyPartAsset))
if wantsBodyParts then
local candidates = {}
if loadedRoot:IsA("BasePart") then table.insert(candidates, loadedRoot) end
for _, object in ipairs(loadedRoot:GetDescendants()) do
if object:IsA("BasePart") and not object:FindFirstAncestorWhichIsA("Accessory") then
table.insert(candidates, object)
end
end
for _, object in ipairs(candidates) do
if BODY_PART_NAMES[object.Name] or PART_NAME_ALIASES[object.Name] then bodyCandidates = bodyCandidates + 1 end
end
end
expected = expected + #classics + #accessories + bodyCandidates
if #accessories == 0 and #classics == 0 and bodyCandidates == 0 then expected = expected + 1 end
if #classics > 0 then
local ok, result = pcall(attachClassicClothingLocal, loadedRoot, character, currentAssetId)
if ok and result and result > 0 then attached = attached + result; rootAttached = true end
end
if wantsBodyParts and bodyCandidates > 0 then
local ok, result = pcall(attachBodyPartsLocal, loadedRoot, character, currentAssetId, option.headTexture)
if ok and result and result > 0 then
attached = attached + result
rootAttached = true
bodyPartsAttached = true
end
end
for _, accessory in ipairs(accessories) do
local ok, result = pcall(attachAccessoryLocal, accessory, character, rootPart, currentAssetId)
if ok and result then
attached = attached + 1
rootAttached = true
else
pcall(function() accessory:Destroy() end)
end
end
if not rootAttached and not bodyPartsAttached and #accessories == 0 and #classics == 0 then
local headAnchor = character:FindFirstChild("Head")
local anchor = rootPart
if currentAssetId == option.head then
anchor = headAnchor
elseif isBodyPartAsset then
local anchorNames = bodyPartAnchorNames[assetTypeId]
if anchorNames then
for _, name in ipairs(anchorNames) do
local target = character:FindFirstChild(name)
if target and target:IsA("BasePart") then anchor = target; break end
end
end
end
local ok, result = pcall(attachLooseVisual, loadedRoot, character, rootPart, currentAssetId, option.headTexture, anchor)
if ok and result then attached = attached + 1 end
end
if loadedRoot.Parent == nil and not table.find(state.visuals, loadedRoot) then
pcall(function() loadedRoot:Destroy() end)
end
end
else
lastError = method
end
end
local faceApplied = false
if option.face and not faceIsAccessory then
local ok, result = pcall(applyLocalFace, character, option.face)
faceApplied = ok and result == true
end
local headlessApplied = false
if option.headless then
enforceHeadless(character, option)
headlessApplied = true
end
local legApplied = false
if option.hideLeftLeg then
hideLeftLeg(character)
legApplied = true
end
if option.hideRightLeg then
hideRightLeg(character)
legApplied = true
end
local totalItems = expected
local loadedItems = attached + (faceApplied and 1 or 0)
state.enabled = attached > 0 or faceApplied or headlessApplied or legApplied
if state.enabled then
if option.preserveRig and (option.hideLeftLeg or option.hideRightLeg) then enforceHeadless(character,option) end
if option.hideOriginal then hideOriginalBody(character) end
if option.hideOriginalHead then hideOriginalHead(character) end
if option.head then hideOriginalHead(character) end
if option.clearOriginalWearables then hideOriginalWearables(character, true) end
setStatus(string.format("%s fallback - %d/%d items", option.label, loadedItems, totalItems), loadedItems == totalItems)
else
setStatus("Could not attach outfit - " .. tostring(lastError or "no 3D parts"), false)
end
return state.enabled
end
local function restoreOriginalDescription()
local description = state.originalDescription
local character = LP.Character
local humanoid = character and character:FindFirstChildOfClass("Humanoid")
if description and humanoid and character == state.descriptionCharacter and not state.skipDescriptionRestore then
local clone = description:Clone()
local ok = pcall(function() humanoid:ApplyDescription(clone) end)
if not ok then pcall(function() humanoid:ApplyDescriptionReset(clone) end) end
clone:Destroy()
end
if state.originalDescription then state.originalDescription:Destroy() end
state.originalDescription = nil
state.descriptionCharacter = nil
state.skipDescriptionRestore=false
end
local function removeOutfit()
state.enabled = false
clearVisuals()
restoreOriginalDescription()
setStatus("Local visual removed", true)
end
return {
outfits = OUTFITS,
apply = function(index)
state.selected = math.clamp(math.floor(tonumber(index) or 1), 1, #OUTFITS)
return applyOutfit()
end,
remove = removeOutfit,
description = function(index)
local character = LP.Character
local humanoid = character and character:FindFirstChildOfClass("Humanoid")
local option = OUTFITS[math.clamp(math.floor(tonumber(index) or 1), 1, #OUTFITS)]
if not humanoid or not option then return nil end
local strict = createDirectDescription(option, humanoid)
if strict then return strict end
local ok, applied = pcall(function() return humanoid:GetAppliedDescription() end)
if not ok or not applied then return nil end
local description = applied:Clone(); applied:Destroy()
description.Shirt=0; description.Pants=0; description.GraphicTShirt=0
for _,property in ipairs(accessoryDescriptionProperties) do pcall(function() description[property]="" end) end
pcall(function() description:SetAccessories({},true) end)
local accessories={}; local all={}
for _,id in ipairs(option.bodyItems or {}) do table.insert(all,id) end
for _,id in ipairs(option.items or {}) do table.insert(all,id) end
for _,id in ipairs(all) do
local assetTypeId=getAssetTypeId(id); local bodyProperty=assetTypeId and bodyPropertyByType[assetTypeId]; local accessoryType=assetTypeId and accessoryTypeByAssetType[assetTypeId]
if bodyProperty then description[bodyProperty]=id elseif assetTypeId==11 then description.Shirt=id elseif assetTypeId==12 then description.Pants=id elseif assetTypeId==1 then description.GraphicTShirt=id elseif assetTypeId==18 then description.Face=id elseif accessoryType then
table.insert(accessories,{AssetId=id,AccessoryType=accessoryType,Order=#accessories+1,IsLayered=assetTypeId>=64 and assetTypeId<=72,Puffiness=option.layeredPuffiness or 0}) end
end
if option.face then local faceType=getAssetTypeId(option.face); if faceType==18 then description.Face=option.face elseif faceType and bodyPropertyByType[faceType] then description[bodyPropertyByType[faceType]]=option.face elseif faceType and accessoryTypeByAssetType[faceType] then table.insert(accessories,{AssetId=option.face,AccessoryType=accessoryTypeByAssetType[faceType],Order=#accessories+1}) end end
if option.head then description.Head=option.head end
for property,value in pairs(option.scales or {}) do pcall(function() description[property]=value end) end
if #accessories>0 then pcall(function() description:SetAccessories(accessories,true) end) end
return description
end,
previewModel = function(index)
local option=OUTFITS[math.clamp(math.floor(tonumber(index) or 1),1,#OUTFITS)]; local character=LP.Character
if not option or not character then return nil end
local oldArchivable=character.Archivable; character.Archivable=true; local ok,clone=pcall(function() return character:Clone() end); character.Archivable=oldArchivable
if not ok or not clone then return nil end
for _,child in ipairs(clone:GetChildren()) do
if child:IsA("Accessory") or child:IsA("Accoutrement") or child:IsA("Shirt") or child:IsA("Pants") or child:IsA("ShirtGraphic") or child:IsA("CharacterMesh") or child:IsA("Tool") then child:Destroy() end
end
for _,object in ipairs(clone:GetDescendants()) do if object:IsA("LuaSourceContainer") then object:Destroy() elseif object:IsA("BasePart") then object.Transparency=object.Name=="HumanoidRootPart" and 1 or 0; object.LocalTransparencyModifier=0 end end
local root=clone:FindFirstChild("HumanoidRootPart") or clone:FindFirstChild("LowerTorso") or clone:FindFirstChild("Torso")
if not root then clone:Destroy(); return nil end
local savedVisuals,savedHidden,savedWearable=state.visuals,state.hidden,state.wearableConn; state.visuals={}; state.hidden={}; state.wearableConn=nil
local ids={}; for _,id in ipairs(option.bodyItems or {}) do table.insert(ids,id) end; for _,id in ipairs(option.items or {}) do table.insert(ids,id) end
if option.head then table.insert(ids,option.head) end; if option.face and option.faceMode~="decal" then table.insert(ids,option.face) end
for _,id in ipairs(ids) do
local objects=loadAssetObjects(id)
if objects then for _,loadedRoot in ipairs(objects) do
pcall(attachClassicClothingLocal,loadedRoot,clone,id)
local accessories={}; if loadedRoot:IsA("Accessory") then table.insert(accessories,loadedRoot) else for _,object in ipairs(loadedRoot:GetDescendants()) do if object:IsA("Accessory") then table.insert(accessories,object:Clone()) end end end
for _,accessory in ipairs(accessories) do pcall(attachAccessoryLocal,accessory,clone,root,id) end
local isBody=table.find(option.bodyItems or {},id)~=nil or id==option.head
if isBody then pcall(attachBodyPartsLocal,loadedRoot,clone,id,option.headTexture) end
if loadedRoot.Parent and not table.find(state.visuals,loadedRoot) then pcall(function() loadedRoot:Destroy() end) end
end end
end
state.visuals,state.hidden,state.wearableConn=savedVisuals,savedHidden,savedWearable
if option.face and option.faceMode=="decal" then local head=clone:FindFirstChild("Head"); if head then local face=head:FindFirstChild("face") or head:FindFirstChildWhichIsA("Decal"); if not face then face=Instance.new("Decal"); face.Name="face"; face.Face=Enum.NormalId.Front; face.Parent=head end; face.Texture=resolveFaceTexture(option.face); face.Transparency=0 end end
if option.headless or option.hideOriginalHead then local head=clone:FindFirstChild("Head"); if head then head.Transparency=1; for _,v in ipairs(head:GetDescendants()) do if v:IsA("Decal") or v:IsA("Texture") then v.Transparency=1 end end end end
if option.hideRightLeg then for _,name in ipairs({"RightUpperLeg","RightLowerLeg","RightFoot","Right Leg"}) do local part=clone:FindFirstChild(name); if part then part.Transparency=1 end end end
return clone
end,
cleanup = function()
state.enabled = false
clearVisuals()
restoreOriginalDescription()
end,
}
]==]

function VX7A.load()
    if VX7A.mod then return VX7A.mod end
    if VX7A.loading or type(loadstring) ~= "function" then return nil end
    VX7A.loading = true
    local ok, fn = pcall(loadstring, VX7A.src)
    if ok and type(fn) == "function" then
        local ok2, res = pcall(fn)
        if ok2 and type(res) == "table" then VX7A.mod = res end
    end
    VX7A.loading = false
    return VX7A.mod
end

function VX7A.setLabel()
    if VX7A.label and VX7A.label.Parent then
        VX7A.label.Text = VX7A.labels[VX7A.index + 1] or "OFF"
    end
end

function VX7A.stop()
    VX7A.pending = nil
    if VX7A.index ~= 0 then
        VX7A.index = 0
        local m = VX7A.mod
        if m and m.remove then pcall(m.remove) end
    end
    VX7A.setLabel()
end

function VX7A.apply(index)
    index = math.clamp(math.floor(tonumber(index) or 0), 0, #VX7A.labels - 1)
    if index == 0 then VX7A.stop() return end
    local m = VX7A.load()
    if not m or type(m.apply) ~= "function" then
        warn("[Rival Hub] No se pudo cargar el modulo de avatares VX7 (loadstring no disponible).")
        VX7A.setLabel()
        return
    end
    if VX7A.busy then VX7A.pending = index; VX7A.index = index; VX7A.setLabel() return end
    if currentOutfitIndex ~= 1 then
        currentOutfitIndex = 1
        pcall(function() applyOutfitByIndex(1) end)
        if outfitSelectorLabel then outfitSelectorLabel.Text = OUTFITS[1].label end
    end
    VX7A.index = index
    VX7A.setLabel()
    VX7A.busy = true
    task.spawn(function()
        pcall(m.apply, index)
        VX7A.busy = false
        local nxt = VX7A.pending
        VX7A.pending = nil
        if nxt and nxt ~= 0 and VX7A.index == nxt then VX7A.apply(nxt) end
    end)
end

pcall(function()
    LP.CharacterAdded:Connect(function()
        if _G.RivalHubSession ~= _mySession or VX7A.index == 0 then return end
        task.delay(1.5, function()
            if _G.RivalHubSession == _mySession and VX7A.index ~= 0 then VX7A.apply(VX7A.index) end
        end)
    end)
end)

local function loadObjectsStd(id)
    local ok, res = pcall(function() return game:GetObjects("rbxassetid://" .. tostring(id)) end)
    if ok and typeof(res) == "table" and #res > 0 then return res end
    ok, res = pcall(function() return game:GetService("InsertService"):LoadAsset(id) end)
    if ok and res then return {res} end
    return nil
end
local function resolveBubbleTemplate(id, className, propertyName)
    local fallback = "rbxassetid://" .. tostring(id)
    local ok, objects = pcall(function() return game:GetObjects(fallback) end)
    if ok and objects and objects[1] then
        local item = objects[1]
        local obj = item:IsA(className) and item or item:FindFirstChildWhichIsA(className, true)
        if obj and obj[propertyName] and obj[propertyName] ~= "" then fallback = obj[propertyName] end
        for _, v in ipairs(objects) do pcall(function() v:Destroy() end) end
    end
    return fallback
end
local function addBubbleHair(char, assetId)
    local head = char and char:FindFirstChild("Head")
    if not head then return false end
    local objects = loadObjectsStd(assetId)
    if not objects or not objects[1] then return false end
    local source = objects[1]
    local accessory = source:IsA("Accessory") and source or source:FindFirstChildWhichIsA("Accessory", true)
    if not accessory then
        for _, v in ipairs(objects) do pcall(function() v:Destroy() end) end
        return false
    end
    local hair = accessory:Clone()
    hair.Name = "BubbleSkinChanger_Hair"
    for _, part in ipairs(hair:GetDescendants()) do
        if part:IsA("BasePart") then part.Anchored = false; part.CanCollide = false; part.Massless = true; part.LocalTransparencyModifier = 0 end
    end
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    local ok = pcall(function() if humanoid then humanoid:AddAccessory(hair) else hair.Parent = char end end)
    if not ok then pcall(function() hair:Destroy() end) end
    for _, v in ipairs(objects) do pcall(function() v:Destroy() end) end
    return ok
end
local function applyHeadlessKorblox(char)
    if not char then return end
    pcall(function() LP.CharacterAvatarType = Enum.AvatarType.R6 end)
    local head = char:FindFirstChild("Head")
    if head then
        if head:GetAttribute("RivalHubOutfitOriginalTransparency") == nil then
            head:SetAttribute("RivalHubOutfitOriginalTransparency", head.Transparency)
            head:SetAttribute("RivalHubOutfitOriginalLocalTransparency", head.LocalTransparencyModifier)
        end
        head.Transparency = 1
        head.CanCollide = false
        head.LocalTransparencyModifier = 1
        local face = head:FindFirstChild("face")
        if face then face.Transparency = 1 end
    end
    pcall(function()
        local neck = char:FindFirstChild("Neck")
        if neck then neck.Enabled = false end
    end)
    for _, v in pairs(char:GetChildren()) do
        if v:IsA("Accessory") then
            local w = v:FindFirstChildWhichIsA("Weld") or v:FindFirstChildWhichIsA("WeldConstraint") or v:FindFirstChildWhichIsA("Motor6D")
            if w then
                local p0, p1 = w.Part0, w.Part1
                if (p0 and p0.Name == "Head") or (p1 and p1.Name == "Head") then
                    for _, part in ipairs(v:GetDescendants()) do
                        if part:IsA("BasePart") then
                            if part:GetAttribute("RivalHubOutfitOriginalTransparency") == nil then
                                part:SetAttribute("RivalHubOutfitOriginalTransparency", part.Transparency)
                                part:SetAttribute("RivalHubOutfitOriginalLocalTransparency", part.LocalTransparencyModifier)
                            end
                            part.Transparency = 1
                            part.LocalTransparencyModifier = 1
                        end
                    end
                end
            end
        end
    end
    local rightLegConfig = { id = "rbxassetid://139607718", targetBodyPart = "RightUpperLeg", partsToHide = {"RightUpperLeg", "RightLowerLeg", "RightFoot"}, scale = _V3new(1, 1, 1), offset = _CFnew(0, 0, 0) }
    local targetPart = char:FindFirstChild(rightLegConfig.targetBodyPart)
    if targetPart then
        local oldAsset = char:FindFirstChild("Korblox_RightLeg")
        if oldAsset then oldAsset:Destroy() end
        for _, partName in ipairs(rightLegConfig.partsToHide) do
            local limb = char:FindFirstChild(partName)
            if limb and limb:IsA("BasePart") then
                if limb:GetAttribute("RivalHubOutfitOriginalTransparency") == nil then
                    limb:SetAttribute("RivalHubOutfitOriginalTransparency", limb.Transparency)
                end
                limb.Transparency = 1
            end
        end
        local success, objects = pcall(function() return game:GetObjects(rightLegConfig.id) end)
        if success and objects and #objects > 0 then
            local assetModel = objects[1]
            assetModel.Name = "Korblox_RightLeg"
            local mainMesh = assetModel:IsA("BasePart") and assetModel or assetModel:FindFirstChildWhichIsA("BasePart", true)
            if mainMesh then
                mainMesh.Size = mainMesh.Size * rightLegConfig.scale
                mainMesh.CanCollide = false
                mainMesh.CFrame = targetPart.CFrame * rightLegConfig.offset
                local weld = Instance.new("WeldConstraint")
                weld.Part0 = targetPart
                weld.Part1 = mainMesh
                weld.Parent = mainMesh
                assetModel.Parent = char
            end
        end
    end
end

function applyOutfitByIndex(index)
    local cfg = OUTFITS[index]
    if not cfg then return end
    local char = LP.Character
    if not char then return end
    clearPreviousOutfitAssets(char)
    for _, item in ipairs(char:GetChildren()) do
        if item:IsA("Accessory") and item.Name:sub(1, #TAG) ~= TAG then
            for _, part in ipairs(item:GetDescendants()) do
                if part:IsA("BasePart") then
                    if part:GetAttribute("RivalHubOriginalTransparency") == nil then
                        part:SetAttribute("RivalHubOriginalTransparency", part.Transparency)
                        part:SetAttribute("RivalHubOriginalLocalTransparency", part.LocalTransparencyModifier)
                    end
                    part.Transparency = 1
                    part.LocalTransparencyModifier = 1
                end
            end
        elseif item:IsA("Shirt") then
            if item:GetAttribute("RivalHubOriginalTemplate") == nil then item:SetAttribute("RivalHubOriginalTemplate", item.ShirtTemplate) end
            item.ShirtTemplate = ""
        elseif item:IsA("Pants") then
            if item:GetAttribute("RivalHubOriginalTemplate") == nil then item:SetAttribute("RivalHubOriginalTemplate", item.PantsTemplate) end
            item.PantsTemplate = ""
        elseif item:IsA("ShirtGraphic") then
            if item:GetAttribute("RivalHubOriginalGraphic") == nil then item:SetAttribute("RivalHubOriginalGraphic", item.Graphic) end
            item.Graphic = ""
        end
    end

    if cfg.customApply then
        cfg.customApply(char)
        if outfitSelectorLabel then outfitSelectorLabel.Text = cfg.label end
        return
    end
    if cfg.bubbleShirt then
        local s = char:FindFirstChildWhichIsA("Shirt") or Instance.new("Shirt")
        s.Name = "BubbleSkinChanger_Shirt"
        s.ShirtTemplate = resolveBubbleTemplate(cfg.bubbleShirt, "Shirt", "ShirtTemplate")
        s.Parent = char
        local p = char:FindFirstChildWhichIsA("Pants") or Instance.new("Pants")
        p.Name = "BubbleSkinChanger_Pants"
        p.PantsTemplate = resolveBubbleTemplate(cfg.bubblePants, "Pants", "PantsTemplate")
        p.Parent = char
        addBubbleHair(char, cfg.bubbleHair)
        if outfitSelectorLabel then outfitSelectorLabel.Text = cfg.label end
        return
    end
    char:WaitForChild("Head", 5)
    local head = char:FindFirstChild("Head")
    if not head then return end
    for _, d in ipairs(char:GetChildren()) do
        if d:IsA("CharacterMesh") and d.BodyPart == Enum.BodyPart.Head then
            pcall(function() d:Destroy() end)
        end
    end
    local done = false
    if head:IsA("MeshPart") then
        done = pcall(function()
            if not head:GetAttribute("RivalHubOutfitModifiedMeshPart") then
                head:SetAttribute("RivalHubOutfitOriginalMeshId", head.MeshId)
                head:SetAttribute("RivalHubOutfitOriginalTextureId", head.TextureID)
                head:SetAttribute("RivalHubOutfitModifiedMeshPart", true)
            end
            head.MeshId = cfg.headMesh
            head.TextureID = cfg.headTexture or ""
        end)
    end
    if not done then
        local sm = head:FindFirstChildWhichIsA("SpecialMesh")
        if not sm then
            sm = Instance.new("SpecialMesh")
            sm:SetAttribute("RivalHubOutfitCreatedMesh", true)
        elseif not sm:GetAttribute("RivalHubOutfitModifiedMesh") then
            sm:SetAttribute("RivalHubOutfitOriginalMeshId", sm.MeshId)
            sm:SetAttribute("RivalHubOutfitOriginalTextureId", sm.TextureId)
            sm:SetAttribute("RivalHubOutfitModifiedMesh", true)
        end
        sm.Parent = head
        sm.MeshType = Enum.MeshType.FileMesh
        sm.MeshId = cfg.headMesh
        sm.TextureId = cfg.headTexture or ""
    end
    if cfg.shirt then
        local s = char:FindFirstChildWhichIsA("Shirt") or Instance.new("Shirt")
        s.Name = "Shirt"
        s.ShirtTemplate = cfg.shirt
        s.Parent = char
    end
    if cfg.pants then
        local p = char:FindFirstChildWhichIsA("Pants") or Instance.new("Pants")
        p.Name = "Pants"
        p.PantsTemplate = cfg.pants
        p.Parent = char
    end
    local old = char:FindFirstChild("AuFfitAccessory")
    if old then old:Destroy() end
    if cfg.accessory and head then
        local objs = loadObjectsStd(cfg.accessory)
        if objs then
            local handle
            for _, o in ipairs(objs) do
                if o:IsA("BasePart") then handle = o; break end
                local f = o:FindFirstChildWhichIsA("BasePart", true)
                if f then handle = f; break end
            end
            if handle then
                local h = handle:Clone()
                h.Name = "AuFfitAccessory"
                h.CanCollide = false
                h.Anchored = false
                h.Massless = true
                h.Parent = char
                local weld = Instance.new("Weld")
                weld.Part0 = head
                weld.Part1 = h
                weld.C0 = _CFnew(cfg.offset)
                weld.Parent = h
            end
            for _, o in ipairs(objs) do pcall(function() o:Destroy() end) end
        end
    end
    if cfg.headlessKorblox then
        applyHeadlessKorblox(char)
    else
        if char then
            local head2 = char:FindFirstChild("Head")
            if head2 then
                head2.Transparency = 0
                head2.CanCollide = true
                head2.LocalTransparencyModifier = 0
                local face2 = head2:FindFirstChild("face")
                if face2 then face2.Transparency = 0 end
            end
            pcall(function()
                local neck = char:FindFirstChild("Neck")
                if neck then neck.Enabled = true end
            end)
            for _, partName in ipairs({"RightUpperLeg", "RightLowerLeg", "RightFoot"}) do
                local limb = char:FindFirstChild(partName)
                if limb then limb.Transparency = 0 end
            end
            local oldKorblox = char:FindFirstChild("Korblox_RightLeg")
            if oldKorblox then oldKorblox:Destroy() end
        end
    end
    if outfitSelectorLabel then outfitSelectorLabel.Text = cfg.label end
end

speedMode = false
antiRagdollMode = "off"
antiDieEnabled = false
antiBatEnabled = false
antiFlingEnabled = false
jumpEnabled = false
laggerToggled = false
laggerCarryToggled = false
medusaCounterEnabled = false
batCounterEnabled = false
unwalkEnabled = false
autoLeftEnabled = false
autoRightEnabled = false
autoBatEnabled = false
batBypassVersion = "V1"  -- "V1" = hub RotVelocity, "V2" = Akatsuki Cypher predictive bypass
dropMode = 1
antiLagEnabled = false
removeAccessoriesEnabled = false
stretchEnabled = false
stretchFOV = 120
uiLocked = false
mobileButtonsLocked = false
uiScaleValue = 90
espEnabled = false
espLineEnabled = false

vividGraphicsEnabled = false
_vividEffects = {}
setVividVisual = nil

hideButtonsEnabled = false
setHideButtonsVisual = nil

katanaSkinEnabled = false
katanaSkinSetVisual = nil

local KatanaSkin = (function()
    local Players       = game:GetService("Players")
    local InsertService = game:GetService("InsertService")
    local Lighting2     = game:GetService("Lighting")
    local ReplicatedStorage2 = game:GetService("ReplicatedStorage")
    local LocalPlayer   = Players.LocalPlayer

    local KC = {
        red  = Color3.new(0.784314, 0, 0),
        red2 = Color3.new(1, 0.392157, 0.392157),
        gold = Color3.new(1, 0.72549, 0.196078),
    }

    local State = {
        Skin = "KATANA",
        SkinOrder = { "KATANA", "NONE" },
        LastBat = nil,
        LastAppliedSkin = nil,
        OriginalKatanaTemplate = nil,
        ExactTemplates = {},
        ExactTemplateSearched = {},
        ExactAssetIds = { KATANA = "" },
        Original = {},
    }

    local function findBatForKatanaSkin()
        local char = LocalPlayer.Character
        if char then
            local t = char:FindFirstChild("Bat")
            if t and t:IsA("Tool") then return t end
        end
        local bp = LocalPlayer:FindFirstChildOfClass("Backpack")
        if bp then
            local t = bp:FindFirstChild("Bat")
            if t and t:IsA("Tool") then return t end
        end
        return nil
    end

    local function setPartSafe(part)
        if not part or not part:IsA("BasePart") then return end
        part.Anchored    = false
        part.CanCollide  = false
        part.CanTouch    = false
        part.CanQuery    = false
        part.Massless    = true
    end

    local function weldToHandle(part, handle)
        if not part or not handle or not part:IsA("BasePart") or not handle:IsA("BasePart") then return end
        setPartSafe(part)
        local w = Instance.new("WeldConstraint")
        w.Name   = "FlowerSkin_AssetWeld"
        w.Part0  = handle
        w.Part1  = part
        w.Parent = part
    end

    local function rememberOriginal(tool)
        if not tool then return end
        local handle = tool:FindFirstChild("Handle")
        local slash  = tool:FindFirstChild("Slash")
        State.Original[tool] = State.Original[tool] or {}
        local o = State.Original[tool]
        if handle and handle:IsA("BasePart") and not o.Handle then
            o.Handle = {
                Transparency = handle.Transparency,
                LocalTransparencyModifier = handle.LocalTransparencyModifier,
                CastShadow = handle.CastShadow,
            }
        end
        if slash and slash:IsA("Sound") and not o.SlashSoundId then
            o.SlashSoundId = slash.SoundId
        end
    end

    local function captureKatanaTemplate()
        if State.OriginalKatanaTemplate then return end
        local function scan(container)
            if not container then return end
            local bat = container:FindFirstChild("Bat")
            if not bat then return end
            local folder = bat:FindFirstChild("FlowerSkin_KatanaRealistic")
            local asset  = folder and folder:FindFirstChild("FlowerSkin_AssetKatana")
            if asset then State.OriginalKatanaTemplate = asset:Clone() end
        end
        scan(LocalPlayer:FindFirstChildOfClass("Backpack"))
        scan(LocalPlayer.Character)
    end

    local function hideOriginalHandle(tool, hidden)
        local handle = tool and tool:FindFirstChild("Handle")
        if not handle or not handle:IsA("BasePart") then return end
        rememberOriginal(tool)
        if hidden then
            handle.LocalTransparencyModifier = 1
            handle.Transparency = 1
            handle.CastShadow = false
        else
            local o = State.Original[tool] and State.Original[tool].Handle
            handle.LocalTransparencyModifier = o and o.LocalTransparencyModifier or 0
            handle.Transparency = o and o.Transparency or 0
            handle.CastShadow = o and o.CastShadow
            if handle.CastShadow == nil then handle.CastShadow = true end
        end
    end

    local function setSlashSound(tool, soundId)
        rememberOriginal(tool)
        local slash = tool and tool:FindFirstChild("Slash")
        if slash and slash:IsA("Sound") then
            slash.SoundId = soundId or ((State.Original[tool] and State.Original[tool].SlashSoundId) or slash.SoundId)
        end
    end

    local function removeSkin(tool)
        if not tool then return end
        local oldFolder = tool:FindFirstChild("FlowerSkin_KatanaRealistic")
        if oldFolder then oldFolder:Destroy() end
        local oldLoose = tool:FindFirstChild("FlowerSkin_AssetKatana")
        if oldLoose then oldLoose:Destroy() end
        hideOriginalHandle(tool, false)
        setSlashSound(tool, nil)
    end

    local function addRedVFX(parentPart)
        if not parentPart or not parentPart:IsA("BasePart") then return end
        local existing = parentPart:FindFirstChild("FlowerSkin_ExtraRedVFX")
        if existing then existing:Destroy() end

        local top = Instance.new("Attachment")
        top.Name = "FlowerSkin_ExtraRedVFX"
        top.Position = Vector3.new(0, parentPart.Size.Y * 0.5, 0)
        top.Parent = parentPart

        local bottom = Instance.new("Attachment")
        bottom.Name = "FlowerSkin_ExtraRedVFX_End"
        bottom.Position = Vector3.new(0, -parentPart.Size.Y * 0.5, 0)
        bottom.Parent = parentPart

        local trail = Instance.new("Trail")
        trail.Name = "FlowerSkin_ExtraRedVFX"
        trail.Attachment0 = top
        trail.Attachment1 = bottom
        trail.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, KC.red2),
            ColorSequenceKeypoint.new(1, Color3.new(0.54902, 0, 0)),
        })
        trail.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.35),
            NumberSequenceKeypoint.new(1, 1),
        })
        trail.Lifetime = 0.18
        trail.LightEmission = 0.55
        trail.Parent = parentPart

        local emitter = Instance.new("ParticleEmitter")
        emitter.Name = "FlowerSkin_ExtraRedVFX"
        emitter.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.new(0.784314, 0, 0)),
            ColorSequenceKeypoint.new(1, KC.red2),
        })
        emitter.LightEmission = 0.55
        emitter.Rate = 14
        emitter.Lifetime = NumberRange.new(0.25, 0.45)
        emitter.Speed = NumberRange.new(0.2, 0.7)
        emitter.SpreadAngle = Vector2.new(12, 12)
        emitter.Size = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.08),
            NumberSequenceKeypoint.new(1, 0),
        })
        emitter.Texture = "rbxasset://textures/particles/sparkles_main.dds"
        emitter.Parent = parentPart
    end

    local function newPart(parent, name, size, offset, color, material)
        local p = Instance.new("Part")
        p.Name = name
        p.Size = size
        p.Color = color
        p.Material = material or Enum.Material.Neon
        p.TopSurface = Enum.SurfaceType.Smooth
        p.BottomSurface = Enum.SurfaceType.Smooth
        setPartSafe(p)
        p.Parent = parent
        return p, offset or CFrame.identity
    end

    local EXACT_TEMPLATE_NAMES = {
        KATANA = { "FlowerSkin_AssetKatana", "Katana", "FlowerSkin_KatanaRealistic" },
    }

    local function isScriptObject(inst)
        return inst:IsA("Script") or inst:IsA("LocalScript") or inst:IsA("ModuleScript")
    end

    local function stripScripts(root)
        if not root then return end
        if isScriptObject(root) then root:Destroy(); return end
        for _, inst in ipairs(root:GetDescendants()) do
            if isScriptObject(inst) then inst:Destroy() end
        end
    end

    local function hasAnyBasePart(root)
        if not root then return false end
        if root:IsA("BasePart") then return true end
        return root:FindFirstChildWhichIsA("BasePart", true) ~= nil
    end

    local function isGeneratedProxy(root)
        local ok, v = pcall(function() return root:GetAttribute("CursedBatSkinsGenerated") end)
        return ok and v == true
    end

    local function usableTemplate(root)
        if not root or isGeneratedProxy(root) then return nil end
        if root:IsA("Model") or root:IsA("Tool") or root:IsA("Folder") or root:IsA("BasePart") then
            if hasAnyBasePart(root) then return root end
        end
        return nil
    end

    local function findUsableNamed(root, names)
        if not root then return nil end
        for _, name in ipairs(names) do
            if root.Name == name then
                local d = usableTemplate(root)
                if d then return d end
            end
        end
        for _, name in ipairs(names) do
            local found = root:FindFirstChild(name, true)
            local u = usableTemplate(found)
            if u then return u end
        end
        return nil
    end

    local function assetTextFromId(assetId)
        local raw = tostring(assetId or ""):gsub("%s+", "")
        if raw == "" then return nil end
        if raw:match("^rbxassetid://") or raw:match("^rbxasset://") then return raw end
        if raw:match("^%d+$") then return "rbxassetid://" .. raw end
        return raw
    end

    local function loadExactTemplateFromAssetId(skinName)
        local assetText = assetTextFromId(State.ExactAssetIds[skinName])
        if not assetText then return nil end
        local loaded = {}
        pcall(function() loaded = game:GetObjects(assetText) end)
        if #loaded == 0 then
            local id = tostring(assetText):match("(%d+)")
            if id then
                pcall(function()
                    table.insert(loaded, InsertService:LoadAsset(tonumber(id)))
                end)
            end
        end
        local names = EXACT_TEMPLATE_NAMES[skinName] or {}
        for _, root in ipairs(loaded) do
            local exact = findUsableNamed(root, names) or usableTemplate(root)
            if exact then
                local clone = exact:Clone()
                stripScripts(clone)
                return clone
            end
        end
        return nil
    end

    local function findExactTemplateInGame(skinName)
        local names = EXACT_TEMPLATE_NAMES[skinName]
        if not names then return nil end
        local containers = {
            LocalPlayer.Character,
            LocalPlayer:FindFirstChildOfClass("Backpack"),
            ReplicatedStorage2,
            Lighting2,
            workspace,
        }
        for _, container in ipairs(containers) do
            local source = findUsableNamed(container, names)
            if source then
                local clone = source:Clone()
                stripScripts(clone)
                return clone
            end
        end
        return nil
    end

    local function getExactTemplate(skinName)
        if skinName == "KATANA" and State.OriginalKatanaTemplate then
            return State.OriginalKatanaTemplate
        end
        if State.ExactTemplates[skinName] then return State.ExactTemplates[skinName] end
        if State.ExactTemplateSearched[skinName] then return nil end
        State.ExactTemplateSearched[skinName] = true
        local loaded = loadExactTemplateFromAssetId(skinName) or findExactTemplateInGame(skinName)
        if loaded then State.ExactTemplates[skinName] = loaded end
        return loaded
    end

    local function containerToModel(clone, folder)
        if clone:IsA("Model") then
            clone.Name = "FlowerSkin_AssetKatana"
            clone.Parent = folder
            return clone
        end
        if clone:IsA("BasePart") then
            local model = Instance.new("Model")
            model.Name = "FlowerSkin_AssetKatana"
            model.Parent = folder
            clone.Parent = model
            return model
        end
        if clone:IsA("Tool") or clone:IsA("Folder") then
            local nested = clone:FindFirstChild("FlowerSkin_AssetKatana")
                or clone:FindFirstChildWhichIsA("Model")
                or clone:FindFirstChildWhichIsA("BasePart")
            if nested and nested.Parent == clone then
                nested.Parent = nil
                clone:Destroy()
                return containerToModel(nested, folder)
            end
            local model = Instance.new("Model")
            model.Name = "FlowerSkin_AssetKatana"
            model.Parent = folder
            for _, child in ipairs(clone:GetChildren()) do
                if not isScriptObject(child) then child.Parent = model end
            end
            clone:Destroy()
            return model
        end
        return nil
    end

    local function applyExactMesh(tool, skinName)
        local handle = tool and tool:FindFirstChild("Handle")
        if not handle or not handle:IsA("BasePart") then return false end
        local template = getExactTemplate(skinName)
        if not template then return false end

        local folder = Instance.new("Folder")
        folder.Name = "FlowerSkin_KatanaRealistic"
        folder.Parent = tool

        local model = containerToModel(template:Clone(), folder)
        if not model or not hasAnyBasePart(model) then
            folder:Destroy()
            return false
        end
        stripScripts(model)
        pcall(function() model:SetAttribute("CursedBatSkinsExactMesh", true) end)

        local firstPart
        for _, inst in ipairs(model:GetDescendants()) do
            if inst:IsA("BasePart") then
                firstPart = firstPart or inst
                setPartSafe(inst)
            end
        end
        if not firstPart then folder:Destroy(); return false end

        if model:IsA("Model") then
            model.PrimaryPart = model.PrimaryPart or firstPart
            pcall(function() model:PivotTo(handle.CFrame) end)
        end
        for _, inst in ipairs(model:GetDescendants()) do
            if inst:IsA("BasePart") then weldToHandle(inst, handle) end
        end

        local vfxPart = model:FindFirstChild("SharpParts", true)
            or model:FindFirstChild("WeaponPart", true)
            or model:FindFirstChild("Handle", true)
            or firstPart
        if vfxPart and not vfxPart:FindFirstChild("FlowerSkin_ExtraRedVFX") then
            addRedVFX(vfxPart)
        end
        return true
    end

    local function buildProxyModel(tool, skinName)
        local handle = tool and tool:FindFirstChild("Handle")
        if not handle or not handle:IsA("BasePart") then return nil end

        local folder = Instance.new("Folder")
        folder.Name = "FlowerSkin_KatanaRealistic"
        folder.Parent = tool

        local model = Instance.new("Model")
        model.Name = "FlowerSkin_AssetKatana"
        model:SetAttribute("CursedBatSkinsGenerated", true)
        model.Parent = folder

        local parts = {}
        local function add(name, size, offset, color, material)
            local part, cfOffset = newPart(model, name, size, offset, color, material)
            part.CFrame = handle.CFrame * cfOffset
            weldToHandle(part, handle)
            table.insert(parts, part)
            return part
        end

        if skinName == "KATANA" then
            add("Handle2", Vector3.new(0.22, 1.0, 0.22), CFrame.new(0, -0.85, 0), Color3.new(0.04, 0.04, 0.045), Enum.Material.Metal)
            local sharp = add("SharpParts", Vector3.new(0.22, 3.35, 0.12), CFrame.new(0, 1.05, 0), KC.red2, Enum.Material.Neon)
            add("WeaponPart", Vector3.new(0.3, 2.7, 0.08), CFrame.new(0.08, 1.15, 0), KC.red, Enum.Material.Neon)
            add("NeonAccent", Vector3.new(0.75, 0.12, 0.42), CFrame.new(0, -0.28, 0), KC.gold, Enum.Material.Neon)
            addRedVFX(sharp)
        end
        model.PrimaryPart = parts[1]
        return model
    end

    local SKIN_SOUND_IDS = {
        KATANA = "rbxassetid://111808555599832",
    }

    local function applySkin(skinName)
        captureKatanaTemplate()
        local tool = findBatForKatanaSkin()
        if not tool then
            State.LastBat = nil
            State.LastAppliedSkin = nil
            return false
        end
        rememberOriginal(tool)
        removeSkin(tool)
        if skinName == "NONE" then
            State.LastBat = tool
            State.LastAppliedSkin = skinName
            return true
        end
        hideOriginalHandle(tool, true)
        setSlashSound(tool, SKIN_SOUND_IDS[skinName])
        if not applyExactMesh(tool, skinName) then
            buildProxyModel(tool, skinName)
        end
        local handle = tool:FindFirstChild("Handle")
        if handle then
            local fire = handle:FindFirstChildOfClass("Fire") or handle:FindFirstChild("Fire")
            if fire and fire:IsA("Fire") then
                fire.Enabled = true
                fire.Color = KC.red
                fire.SecondaryColor = KC.red2
            end
        end
        State.LastBat = tool
        State.LastAppliedSkin = skinName
        return true
    end

    return {
        State = State,
        ApplySkin = applySkin,
        SetExactAssetId = function(assetId)
            State.ExactAssetIds.KATANA = tostring(assetId or "")
            State.ExactTemplateSearched.KATANA = nil
            State.ExactTemplates.KATANA = nil
        end,
    }
end)()

_G.CursedBatKatana = KatanaSkin

task.spawn(function()
    while true do
        if katanaSkinEnabled then
            local bat
            local c = LP.Character
            if c then
                local t = c:FindFirstChild("Bat")
                if t and t:IsA("Tool") then bat = t end
            end
            if not bat then
                local bp = LP:FindFirstChildOfClass("Backpack")
                if bp then
                    local t = bp:FindFirstChild("Bat")
                    if t and t:IsA("Tool") then bat = t end
                end
            end
            if bat and (bat ~= KatanaSkin.State.LastBat or KatanaSkin.State.LastAppliedSkin ~= "KATANA") then
                pcall(function() KatanaSkin.ApplySkin("KATANA") end)
            end
        end
        task.wait(0.5)
    end
end)


minecraftBatSkinEnabled = false
minecraftBatSkinColorMode = "Default"
MinecraftBatSetVisual = nil
MinecraftBatColorSelector = nil

local MinecraftBatSkin = (function()
    local MB_ASSET_ID = "rbxassetid://18566246244"
    local MB_POS_OFFSET = _CFnew(-0.02, -0.52, -0.2)
    local MB_ROT_OFFSET = CFrame.Angles(math.rad(45), math.rad(0), math.rad(5))
    local MB_SCALE = 2

    local MB_COLORS = {
        ["Default"]       = nil,
        ["Abyss Blue"]    = Color3.fromRGB(0, 40, 150),
        ["Venom Green"]   = Color3.fromRGB(20, 255, 50),
        ["Royal Gold"]    = Color3.fromRGB(255, 200, 0),
        ["Velvet Rose"]   = Color3.fromRGB(220, 20, 100),
        ["Crimson Night"] = Color3.fromRGB(90, 0, 20),
    }

    local State = {
        enabled = false,
        colorMode = "Default",
        cachedVisualPart = nil,
        rgbConnection = nil,
    }

    local okLoad, objects = pcall(function() return game:GetObjects(MB_ASSET_ID) end)
    if okLoad and objects and #objects > 0 then
        local model = objects[1]
        State.cachedVisualPart = model:IsA("BasePart") and model
            or model:FindFirstChildWhichIsA("BasePart", true)
    end

    local function mbSetColor(visual, color)
        if not visual or not color then return end
        visual.Color = color
        if visual:IsA("UnionOperation") then
            pcall(function() visual.UsePartColor = true end)
        end
        local sm = visual:FindFirstChildWhichIsA("SpecialMesh")
        if sm then
            sm.VertexColor = Vector3.new(color.R, color.G, color.B)
        end
    end

    local function mbFindBat()
        local char = LP.Character
        if char then
            local t = char:FindFirstChild("Bat")
            if t and t:IsA("Tool") then return t end
            for _, c in ipairs(char:GetChildren()) do
                if c:IsA("Tool") then
                    local n = c.Name:lower()
                    if n:find("bat") or n:find("slap") then return c end
                end
            end
        end
        local bp = LP:FindFirstChildOfClass("Backpack")
        if bp then
            local t = bp:FindFirstChild("Bat")
            if t and t:IsA("Tool") then return t end
            for _, c in ipairs(bp:GetChildren()) do
                if c:IsA("Tool") then
                    local n = c.Name:lower()
                    if n:find("bat") or n:find("slap") then return c end
                end
            end
        end
        return nil
    end

    local function mbRemoveVisual(tool)
        if not tool then return end
        local old = tool:FindFirstChild("CustomUnionVisual")
        if old then pcall(function() old:Destroy() end) end
        local handle = tool:FindFirstChild("Handle")
        if handle then
            handle.Transparency = 0
            for _, child in ipairs(handle:GetChildren()) do
                if child:IsA("SpecialMesh") or child:IsA("Mesh") or child:IsA("Decal") then
                    pcall(function() child.Transparency = 0 end)
                end
            end
        end
    end

    local function mbApplyVisual(tool)
        if not tool or not State.cachedVisualPart then return end
        local handle = tool:FindFirstChild("Handle") or tool:WaitForChild("Handle", 2)
        if not handle then return end

        local oldVisual = tool:FindFirstChild("CustomUnionVisual")
        if oldVisual then oldVisual:Destroy() end

        handle.Transparency = 1
        for _, child in ipairs(handle:GetChildren()) do
            if child:IsA("SpecialMesh") or child:IsA("Mesh") or child:IsA("Decal") then
                pcall(function() child.Transparency = 1 end)
            end
        end

        local newVisual = State.cachedVisualPart:Clone()
        newVisual.Name = "CustomUnionVisual"
        newVisual.CanCollide = false
        newVisual.Massless = true
        newVisual.Anchored = false

        local tempModel = Instance.new("Model")
        newVisual.Parent = tempModel
        tempModel.PrimaryPart = newVisual
        pcall(function() tempModel:ScaleTo(MB_SCALE) end)
        newVisual.Parent = nil
        tempModel:Destroy()

        if State.colorMode == "RGB" then
            mbSetColor(newVisual, Color3.fromHSV(tick() % 3 / 3, 1, 1))
        elseif MB_COLORS[State.colorMode] then
            mbSetColor(newVisual, MB_COLORS[State.colorMode])
        end

        for _, child in ipairs(newVisual:GetChildren()) do
            if child:IsA("Weld") or child:IsA("WeldConstraint") then child:Destroy() end
        end

        newVisual.CFrame = handle.CFrame * MB_POS_OFFSET * MB_ROT_OFFSET
        newVisual.Parent = tool

        local weld = Instance.new("WeldConstraint")
        weld.Part0 = handle
        weld.Part1 = newVisual
        weld.Parent = newVisual
    end

    local function mbStartRGB()
        if State.rgbConnection then return end
        State.rgbConnection = RunService.RenderStepped:Connect(function()
            if not State.enabled or State.colorMode ~= "RGB" then return end
            local tool = mbFindBat()
            if not tool then return end
            local visual = tool:FindFirstChild("CustomUnionVisual")
            if visual then
                mbSetColor(visual, Color3.fromHSV(tick() % 3 / 3, 1, 1))
            end
        end)
    end

    local function mbStopRGB()
        if State.rgbConnection then
            State.rgbConnection:Disconnect()
            State.rgbConnection = nil
        end
    end

    return {
        State   = State,
        Colors  = MB_COLORS,
        FindBat = mbFindBat,
        Apply   = function()
            if not State.enabled then return end
            local tool = mbFindBat()
            if tool then mbApplyVisual(tool) end
            if State.colorMode == "RGB" then mbStartRGB() end
        end,
        Remove  = function()
            mbStopRGB()
            local char = LP.Character
            if char then
                for _, t in ipairs(char:GetChildren()) do
                    if t:IsA("Tool") then mbRemoveVisual(t) end
                end
            end
            local bp = LP:FindFirstChildOfClass("Backpack")
            if bp then
                for _, t in ipairs(bp:GetChildren()) do
                    if t:IsA("Tool") then mbRemoveVisual(t) end
                end
            end
        end,
        SetColorMode = function(mode)
            State.colorMode = mode
            if not State.enabled then return end
            if mode == "RGB" then mbStartRGB() else mbStopRGB() end
            local tool = mbFindBat()
            if tool then mbApplyVisual(tool) end
        end,
    }
end)()

task.spawn(function()
    while true do
        if minecraftBatSkinEnabled then
            MinecraftBatSkin.State.enabled = true
            local tool = MinecraftBatSkin.FindBat()
            if tool and not tool:FindFirstChild("CustomUnionVisual") then
                pcall(MinecraftBatSkin.Apply)
            end
        else
            MinecraftBatSkin.State.enabled = false
        end
        task.wait(0.5)
    end
end)


bodyLockEnabled = false
bodyLockRange = 20
bodyLockRangeBox = nil
_bodyLockConn = nil
_blSuppressCount = 0
_blWasEnabled = false
_blRestoreTimer = nil
_blSmoothRestore = false

savedProgressBarPos = nil
savedButtonPositions = {}
savedMobilePanelPos = nil

neonWeatherEnabled = false
skyTheme = "Off"
skySelectorLabel = nil
_originalLighting = nil
setNeonWeatherVisual = nil

currentAnimPack = "Off"
originalTryardAnims = nil
tryardHeartbeatConn = nil
animSelectorLabel = nil

lastMoveDir = _V3zero

local CoreGui = game:GetService("CoreGui")

local InfiniteJump = {
    enabled = false,
    mode = "hold",
    jumpPower = 55,
    minVelocity = 35,
    fallClamp = -120,
    jumpConn = nil,
    heartbeatConn = nil,
    presimConn = nil,
}

local function applyInfJumpBoost(root)
    if not root then return end
    local velocity = root.AssemblyLinearVelocity
    if velocity.Y < InfiniteJump.minVelocity then
        root.AssemblyLinearVelocity = _V3new(velocity.X, InfiniteJump.jumpPower, velocity.Z)
    end
    if velocity.Y < InfiniteJump.fallClamp then
        root.AssemblyLinearVelocity = _V3new(velocity.X, InfiniteJump.fallClamp, velocity.Z)
    end
end

local function onJumpRequest()
    if not InfiniteJump.enabled then return end
    local char = LP.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if root then
        pcall(function()
            root.AssemblyLinearVelocity = _V3new(
                root.AssemblyLinearVelocity.X,
                InfiniteJump.jumpPower,
                root.AssemblyLinearVelocity.Z
            )
        end)
    end
end

local function onPreSimulation()
    if not InfiniteJump.enabled then return end
    if InfiniteJump.mode ~= "hold" then return end
    local char = LP.Character
    if not char then return end
    local hum  = char:FindFirstChildOfClass("Humanoid")
    local root = char:FindFirstChild("HumanoidRootPart")
    if not hum or not root then return end

    local held = UIS:IsKeyDown(Enum.KeyCode.Space)
        or UIS:IsKeyDown(Enum.KeyCode.ButtonA)
        or (hum.Jump == true)

    if held then
        applyInfJumpBoost(root)
    else
        local v = root.AssemblyLinearVelocity
        if v.Y < InfiniteJump.fallClamp then
            root.AssemblyLinearVelocity = _V3new(v.X, InfiniteJump.fallClamp, v.Z)
        end
    end
end

local function connectEvents()
    if InfiniteJump.jumpConn then InfiniteJump.jumpConn:Disconnect() end
    if InfiniteJump.heartbeatConn then InfiniteJump.heartbeatConn:Disconnect() end
    if InfiniteJump.presimConn then InfiniteJump.presimConn:Disconnect() end
    InfiniteJump.jumpConn = UIS.JumpRequest:Connect(onJumpRequest)
    InfiniteJump.presimConn = RunService.PreSimulation:Connect(onPreSimulation)
end

function InfiniteJump.start()
    if InfiniteJump.enabled then return end
    InfiniteJump.enabled = true
    connectEvents()
end

function InfiniteJump.stop()
    InfiniteJump.enabled = false
    if InfiniteJump.jumpConn then InfiniteJump.jumpConn:Disconnect(); InfiniteJump.jumpConn = nil end
    if InfiniteJump.heartbeatConn then InfiniteJump.heartbeatConn:Disconnect(); InfiniteJump.heartbeatConn = nil end
    if InfiniteJump.presimConn then InfiniteJump.presimConn:Disconnect(); InfiniteJump.presimConn = nil end
end

function InfiniteJump.setJumpPower(power)
    power = tonumber(power) or 55
    InfiniteJump.jumpPower = _clamp(power, 10, 200)
end

function InfiniteJump.setMode(mode)
    InfiniteJump.mode = mode == "manual" and "manual" or "hold"
end

function InfiniteJump.isRunning() return InfiniteJump.enabled == true end

InfiniteJump.stop()

function getActiveMoveSpeed()
    if useVenixCarryEngine and ScreamVenixCarry and ScreamVenixCarry:isRunning() then
        return ScreamVenixCarry:getActiveSpeed()
    end
    -- Source speedundetect: steal speed when Carry toggled OR player is Stealing
    local isStealing = false
    pcall(function()
        if LP:GetAttribute("Stealing") == true then isStealing = true end
    end)
    if not isStealing then
        pcall(function()
            local ch = LP.Character
            if ch and ch:GetAttribute("Stealing") == true then isStealing = true end
        end)
    end
    local useSteal = speedMode or isStealing
    if laggerCarryToggled then
        return LAGGER_CARRY_SPEED
    elseif laggerToggled then
        -- Lagger mode: steal speed while carrying / Stealing attribute
        return useSteal and LAGGER_CARRY_SPEED or LAGGER_SPEED
    elseif useSteal then
        return CS
    else
        return NS
    end
end

function getSpeedModeName()
    if laggerToggled or laggerCarryToggled then return "LAGGER"
    elseif speedMode then return "CARRY"
    else return "NORMAL" end
end

local _s2VelState = {root = nil, v = _V3zero}
local _velChecked = setmetatable({}, {__mode = "k"})
local _hookedVelParts = {}
local _velocityHook = _G.__ScreamVelocityHook or {hooked = false, roots = setmetatable({}, {__mode = "k"})}
_G.__ScreamVelocityHook = _velocityHook
local function _hookVelHRP(root)
    if not root then return end
    _s2VelState.root = root
    _velChecked[root] = true
    _velocityHook.roots[root] = true
    if _velocityHook.hooked then return end
    -- Source speedundetect: spoof AssemblyLinearVelocity / Velocity to unit*20 via game metatable
    if type(getrawmetatable) ~= "function" or type(setreadonly) ~= "function"
        or type(newcclosure) ~= "function" or type(checkcaller) ~= "function" then return end
    pcall(function()
        local mt = getrawmetatable(game)
        if not mt then
            mt = getrawmetatable(root)
        end
        if not mt then return end
        local originalIndex = rawget(mt, "__index")
        if type(originalIndex) ~= "function" and type(originalIndex) ~= "table" then return end
        local replacementIndex = newcclosure(function(self, key)
            local value
            if type(originalIndex) == "function" then
                value = originalIndex(self, key)
            else
                value = originalIndex[key]
            end
            if not checkcaller() and _velocityHook.roots[self]
                and (key == "AssemblyLinearVelocity" or key == "Velocity")
                and typeof(value) == "Vector3" and value.Magnitude > 20 then
                return value.Unit * 20
            end
            return value
        end)
        setreadonly(mt, false)
        mt.__index = replacementIndex
        _velocityHook.hooked = true
        setreadonly(mt, true)
    end)
end
local function _setupVelChecked(character)
    _velocityHook.roots = setmetatable({}, {__mode = "k"})
    _velChecked = setmetatable({}, {__mode = "k"})
    if not character then _s2VelState.root = nil; return nil end
    local root = character:WaitForChild("HumanoidRootPart", 5)
    if root then _s2VelState.root = root; _velChecked[root] = true; _velocityHook.roots[root] = true end
    return root
end
if LP.Character then _hookVelHRP(_setupVelChecked(LP.Character)) end
local function _isRagdollState(hum)
    if not hum then return true end
    local state = hum:GetState()
    return hum.PlatformStand or state == Enum.HumanoidStateType.Physics
        or state == Enum.HumanoidStateType.Ragdoll or state == Enum.HumanoidStateType.FallingDown
end
local function _applyVelocitySpeed(direction, speed, root)
    if not root or not root.Parent then return end
    -- Don't fight bat / path systems
    if autoBatEnabled or TPBatState.enabled or (_G.__RivalHubIsBatV2 and _G.__RivalHubIsBatV2()) then return end
    if autoLeftEnabled or autoRightEnabled or dropActive or _G.IsDropping then return end
    if type(speed) ~= "number" or speed ~= speed or speed <= 0 or speed == math.huge then return end

    -- Source speedundetect: preserve true vertical velocity (read may be spoofed — use raw if possible)
    local verticalVelocity = root.AssemblyLinearVelocity.Y
    if _G._ZurichHub_MovementBlocked == true or _G._CrystalHub_MovementBlocked == true or _G._SpeedModule_Blocked == true then
        root.AssemblyLinearVelocity = _V3new(0, math.min(verticalVelocity, 0), 0)
        return
    end
    if direction and direction.Magnitude > 0.05 then
        pcall(function()
            if root.SetNetworkOwner then root:SetNetworkOwner(LP) end
        end)
        local unit = direction.Unit
        root.AssemblyLinearVelocity = _V3new(unit.X * speed, verticalVelocity, unit.Z * speed)
    else
        root.AssemblyLinearVelocity = _V3new(0, verticalVelocity, 0)
    end
    _G.__RivalHubLiveSpeed = {t = os.clock(), v = speed}
end
function getAutoPathSpeed()
    if laggerCarryToggled or laggerToggled then return LAGGER_SPEED end
    return NS
end

        ScreamVenixCarry = {
            normalSpeed = NS,
            carrySpeed = CS,
            laggerSpeed = LAGGER_SPEED,
            laggerCarrySpeed = LAGGER_CARRY_SPEED,
            speedToggled = false,
            laggerMode = 0,
            softStealEnabled = false,
            softStealRadius = 10,
            softStealSpeed = 30,
            softStealLatched = false,
            _isCarrying = false,
            _lastCarryCheck = 0,
            _lvBoost = nil,
            _lvAtt = nil,
            _blockedTime = 0,
            _maxForce = 2200,
            _freeForce = 500,
            _heartbeatConn = nil,
            _softStealScanner = nil,
            _softStealAnimals = {},
            _softStealScanning = false,
            _state = nil,
            _dropInProgress = false,
            _batAimbotToggled = false,
            _rayParams = nil,
            _rayFilter = nil,
            _rayFilterTime = 0,
            isCarrying = function(self)
                local now = _tick()
                if now - (self._lastCarryCheck or 0) < 0.1 then
                    return self._isCarrying
                end
                self._lastCarryCheck = now
                local character = LP.Character
                if not character then
                    self._isCarrying = false
                    return false
                end
                local humanoid = character:FindFirstChildOfClass("Humanoid")
                local walkSpeed = humanoid and humanoid.WalkSpeed or 16
                local isCarrying = walkSpeed < 25 and walkSpeed > 0
                local ok, result = pcall(function()
                    return LP:GetAttribute("Stealing")
                end)
                ok = ok and result == true
                local isEnabled = false
                if ok then
                    isEnabled = true
                end
                local ok2, result2 = pcall(function()
                    return character:GetAttribute("Stealing")
                end)
                if ok2 and result2 == true then
                    isEnabled = true
                end
                if not isEnabled then
                    for _, name in ipairs({
                        "Carrying",
                        "IsCarrying",
                        "Grabbed",
                        "Holding",
                        "StealHold",
                        "HasGrab",
                    }) do
                        local instance = character:FindFirstChild(name)
                        if instance then
                            if
                                instance:IsA("BoolValue") and instance.Value
                                or instance:IsA("ObjectValue") and instance.Value
                                or instance:IsA("StringValue") and instance.Value ~= ""
                            then
                                isEnabled = true
                                break
                            end
                        end
                    end
                end
                self._isCarrying = isCarrying or isEnabled
                return self._isCarrying
            end,
            getActiveSpeed = function(self)
                if self._state and (self._state.autoLeftEnabled or self._state.autoRightEnabled) then
                    return self.normalSpeed
                end
                if self.laggerMode == 1 then
                    return self.laggerSpeed
                end
                if self.laggerMode == 2 then
                    return self.laggerCarrySpeed
                end
                if self.softStealEnabled then
                    local carrying = false
                    local okCarry, carryResult = pcall(function()
                        return self:isCarrying()
                    end)
                    if okCarry and carryResult then
                        carrying = true
                    end
                    if carrying then
                        self.softStealLatched = true
                        return self.softStealSpeed
                    end
                    local animal, dist = self:getNearestSoftStealAnimal(self.softStealRadius)
                    if animal and dist and dist <= (self.softStealRadius or 10) then
                        self.softStealLatched = true
                        return self.softStealSpeed
                    end
                    self.softStealLatched = false
                else
                    self.softStealLatched = false
                end
                if self.speedToggled then
                    return self.carrySpeed
                end
                return self.normalSpeed
            end,
            getStatus = function(self)
                if not (self._state and (self._state.autoLeftEnabled or self._state.autoRightEnabled)) then
                    if self.laggerMode == 1 then
                        return "LAGGER", self.laggerSpeed
                    end
                    if self.laggerMode == 2 then
                        return "LAGGER CARRY", self.laggerCarrySpeed
                    end
                    if self.speedToggled then
                        return "CARRY", self.carrySpeed
                    end
                    return "NORMAL", self.normalSpeed
                end
                return "NORMAL", self.normalSpeed
            end,
        }
        do
            local function destroyLV()
                if ScreamVenixCarry._lvBoost and ScreamVenixCarry._lvBoost.Parent then
                    pcall(function()
                        ScreamVenixCarry._lvBoost:Destroy()
                    end)
                end
                if ScreamVenixCarry._lvAtt and ScreamVenixCarry._lvAtt.Parent then
                    pcall(function()
                        ScreamVenixCarry._lvAtt:Destroy()
                    end)
                end
                ScreamVenixCarry._lvBoost = nil
                ScreamVenixCarry._lvAtt = nil
            end
            local function setupLV(parent)
                if ScreamVenixCarry._lvBoost and ScreamVenixCarry._lvBoost.Parent == parent then
                    return
                end
                destroyLV()
                local attachment = Instance.new("Attachment")
                attachment.Parent = parent
                local linearVelocity = Instance.new("LinearVelocity")
                linearVelocity.Name = "ScreamCarryBoost"
                attachment.Name = "ScreamCarryAttachment"
                linearVelocity.Attachment0 = attachment
                linearVelocity.VelocityConstraintMode = Enum.VelocityConstraintMode.Plane
                linearVelocity.PrimaryTangentAxis = _V3new(1, 0, 0)
                linearVelocity.SecondaryTangentAxis = _V3new(0, 0, 1)
                linearVelocity.MaxForce = ScreamVenixCarry._maxForce
                linearVelocity.PlaneVelocity = Vector2.zero
                linearVelocity.RelativeTo = Enum.ActuatorRelativeTo.World
                linearVelocity.Parent = parent
                ScreamVenixCarry._lvAtt = attachment
                ScreamVenixCarry._lvBoost = linearVelocity
                pcall(function()
                    parent:SetNetworkOwner(LP)
                end)
            end
            ScreamVenixCarry.scanSoftStealAnimals = function(self)
                self._softStealAnimals = {}
                local plots = Workspace:FindFirstChild("Plots")
                if not plots then
                    return
                end
                for _, child in ipairs(plots:GetChildren()) do
                    if child:IsA("Model") then
                        local animalPodiums = child:FindFirstChild("AnimalPodiums")
                        if animalPodiums then
                            for _, child2 in ipairs(animalPodiums:GetChildren()) do
                                if child2:IsA("Model") then
                                    local base = child2:FindFirstChild("Base")
                                    base = base and base:FindFirstChild("Spawn")
                                    if base then
                                        table.insert(self._softStealAnimals, {
                                            plot = child.Name,
                                            slot = child2.Name,
                                            worldPosition = base.Position,
                                            uid = child.Name .. "_" .. child2.Name,
                                        })
                                    end
                                end
                            end
                        end
                    end
                end
            end
            ScreamVenixCarry.startSoftStealScanner = function(callback)
                if callback._softStealScanner then
                    return
                end
                callback._softStealScanning = true
                callback:scanSoftStealAnimals()
                local accumulator = 0
                callback._softStealScanner = RunService.Heartbeat:Connect(function(dt)
                    accumulator = accumulator + dt
                    if accumulator < 0.2 then return end
                    accumulator = 0
                    if not callback._softStealScanning then
                        return
                    end
                    callback:scanSoftStealAnimals()
                end)
            end
            ScreamVenixCarry.stopSoftStealScanner = function(self)
                self._softStealScanning = false
                if self._softStealScanner then
                    self._softStealScanner:Disconnect()
                    self._softStealScanner = nil
                end
            end
            ScreamVenixCarry.getNearestSoftStealAnimal = function(self, radius)
                local character = LP.Character
                if character then
                    character = character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("UpperTorso")
                end
                if not character then
                    return nil, _huge
                end
                local softStealAnimals = self._softStealAnimals
                local position = character.Position
                local bestDistance = _huge
                local animals = nil
                for i = 1, #softStealAnimals do
                    local rootPart = softStealAnimals[i]
                    if rootPart.worldPosition then
                        local dx = position.X - rootPart.worldPosition.X
                        local dy = position.Y - rootPart.worldPosition.Y
                        local dz = position.Z - rootPart.worldPosition.Z
                        local distance = _sqrt(dx * dx + dy * dy + dz * dz)
                        if distance < bestDistance then
                            bestDistance = distance
                            animals = rootPart
                        end
                    end
                end
                if radius and bestDistance > radius then
                    return nil, bestDistance
                end
                return animals, bestDistance
            end
            ScreamVenixCarry.updateMovement = function(self, deltaTime)
                local character = LP.Character
                if not character then
                    return
                end
                local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
                local humanoid = character:FindFirstChildOfClass("Humanoid")
                if not humanoidRootPart or not humanoid or humanoid.Health <= 0 then
                    return
                end
                local speed = self:getActiveSpeed()
                local moveDirection = humanoid.MoveDirection
                local moving = moveDirection.Magnitude > 0.1
                local unit = nil
                if moving then
                    if not self._rayParams then
                        self._rayParams = _RayParams_new()
                        self._rayParams.FilterType = Enum.RaycastFilterType.Exclude
                        self._rayFilter = {}
                        self._rayFilterTime = 0
                    end
                    local now = _tick()
                    if now - self._rayFilterTime > 1 then
                        self._rayFilterTime = now
                        local rayFilter = self._rayFilter
                        while #rayFilter > 0 do
                            rayFilter[#rayFilter] = nil
                        end
                        rayFilter[1] = character
                        local plist = _GetPlayersCached()
                        for i = 1, #plist do
                            local p = plist[i]
                            if p.Character then
                                rayFilter[#rayFilter + 1] = p.Character
                            end
                        end
                        self._rayParams.FilterDescendantsInstances = rayFilter
                    else
                        local rayFilter = self._rayFilter
                        local found = false
                        for i = 1, #rayFilter do
                            if rayFilter[i] == character then
                                found = true
                                break
                            end
                        end
                        if not found then
                            rayFilter[1] = character
                            self._rayParams.FilterDescendantsInstances = rayFilter
                        end
                    end
                    local unit2 = _V3new(moveDirection.X, 0, moveDirection.Z).Unit
                    local rayParams = self._rayParams
                    local hit =
                        Workspace:Raycast(humanoidRootPart.Position + _V3new(0, 1, 0), unit2 * 2.5, rayParams)
                    local canCollide = hit and hit.Instance and hit.Instance.CanCollide
                    unit = nil
                    if canCollide then
                        local nf = _V3new(hit.Normal.X, 0, hit.Normal.Z)
                        unit = nil
                        if nf.Magnitude > 0.7 then
                            unit = nf.Unit
                        end
                    end
                end
                local hVelocity =
                    _V3new(humanoidRootPart.AssemblyLinearVelocity.X, 0, humanoidRootPart.AssemblyLinearVelocity.Z)
                local blocked = unit ~= nil or moving and hVelocity.Magnitude < 2
                if blocked then
                    for _, child in ipairs(character:GetChildren()) do
                        if child:IsA("Model") then
                            for _, descendant in ipairs(child:GetDescendants()) do
                                if descendant:IsA("BasePart") and descendant.CanCollide then
                                    descendant.CanCollide = false
                                end
                            end
                        end
                    end
                    for _, name in ipairs({
                        "Carrying",
                        "IsCarrying",
                        "Grabbed",
                        "Holding",
                        "StealHold",
                        "HasGrab",
                    }) do
                        local instance = character:FindFirstChild(name)
                        if
                            instance
                            and instance:IsA("ObjectValue")
                            and instance.Value
                            and instance.Value:IsA("Model")
                        then
                            for _, descendant in ipairs(instance.Value:GetDescendants()) do
                                if descendant:IsA("BasePart") and descendant.CanCollide then
                                    descendant.CanCollide = false
                                end
                            end
                        end
                    end
                end
                local state = humanoid:GetState()
                if
                    not (
                        state == Enum.HumanoidStateType.Physics
                        or state == Enum.HumanoidStateType.Ragdoll
                        or state == Enum.HumanoidStateType.FallingDown
                        or self._dropInProgress
                        or self._batAimbotToggled
                    )
                then
                    if not ScreamVenixCarry._lvBoost or ScreamVenixCarry._lvBoost.Parent ~= humanoidRootPart then
                        setupLV(humanoidRootPart)
                    end
                    local lvBoost = ScreamVenixCarry._lvBoost
                    if lvBoost then
                        if not lvBoost.Enabled then
                            lvBoost.Enabled = true
                        end
                        if 0.1 < moveDirection.Magnitude then
                            local unit2 = _V3new(moveDirection.X, 0, moveDirection.Z).Unit
                            if unit then
                                local wanted = unit2 * speed
                                local along = wanted - unit * wanted:Dot(unit)
                                if along.Magnitude < 0.5 then
                                    lvBoost.PlaneVelocity = Vector2.zero
                                else
                                    lvBoost.PlaneVelocity = Vector2.new(along.X, along.Z)
                                end
                            else
                                lvBoost.PlaneVelocity = Vector2.new(unit2.X * speed, unit2.Z * speed)
                            end
                        else
                            lvBoost.PlaneVelocity = Vector2.zero
                        end
                        if blocked then
                            self._blockedTime = self._blockedTime + (deltaTime or 0.016)
                        else
                            self._blockedTime = 0
                        end
                        if self._blockedTime > 0.35 then
                            if lvBoost.MaxForce ~= self._freeForce then
                                lvBoost.MaxForce = self._freeForce
                            end
                        elseif lvBoost.MaxForce ~= self._maxForce then
                            lvBoost.MaxForce = self._maxForce
                        end
                    end
                elseif ScreamVenixCarry._lvBoost then
                    ScreamVenixCarry._lvBoost.PlaneVelocity = Vector2.zero
                    if ScreamVenixCarry._lvBoost.Enabled then
                        ScreamVenixCarry._lvBoost.Enabled = false
                    end
                end
            end
            ScreamVenixCarry.start = function(deltaTime236)
                if deltaTime236._heartbeatConn then
                    return
                end
                deltaTime236._heartbeatConn = RunService.Heartbeat:Connect(function(deltaTime)
                    if _mySession ~= _G.RivalHubSession then deltaTime236:stop(); return end
                    deltaTime236.normalSpeed = NS
                    deltaTime236.carrySpeed = CS
                    deltaTime236.laggerSpeed = LAGGER_SPEED
                    deltaTime236.laggerCarrySpeed = LAGGER_CARRY_SPEED
                    deltaTime236.speedToggled = speedMode
                    deltaTime236.laggerMode = laggerCarryToggled and 2 or (laggerToggled and 1 or 0)
                    deltaTime236._state = {autoLeftEnabled = autoLeftEnabled, autoRightEnabled = autoRightEnabled}
                    deltaTime236._dropInProgress = dropActive or _G.IsDropping or autoLeftEnabled or autoRightEnabled
                    deltaTime236._batAimbotToggled = autoBatEnabled or TPBatState.enabled
                        or (_G.__RivalHubIsBatV2 and _G.__RivalHubIsBatV2())
                    deltaTime236:updateMovement(deltaTime)
                end)
                if deltaTime236.softStealEnabled then
                    deltaTime236:startSoftStealScanner()
                end
                print("[CarrySystem] Activado")
            end
            ScreamVenixCarry.stop = function(self)
                if self._heartbeatConn then
                    self._heartbeatConn:Disconnect()
                    self._heartbeatConn = nil
                end
                self:stopSoftStealScanner()
                destroyLV()
                self.softStealLatched = false
                print("[CarrySystem] Desactivado")
            end
        end
    ScreamVenixCarry.setNormalSpeed = function(self, value)
        self.normalSpeed = _clamp(value, 1, 500)
    end
    ScreamVenixCarry.setCarrySpeed = function(self, value)
        self.carrySpeed = _clamp(value, 1, 500)
    end
    ScreamVenixCarry.setLaggerSpeed = function(self, value)
        self.laggerSpeed = _clamp(value, 0.1, 500)
    end
    ScreamVenixCarry.setLaggerCarrySpeed = function(self, value)
        self.laggerCarrySpeed = _clamp(value, 0.1, 500)
    end
    ScreamVenixCarry.setSoftStealSpeed = function(self, value)
        self.softStealSpeed = _clamp(value, 1, 500)
    end
    ScreamVenixCarry.setSoftStealRadius = function(self, value)
        self.softStealRadius = _clamp(value, 1, 200)
    end
    ScreamVenixCarry.toggleCarryMode = function(self)
        self.speedToggled = not self.speedToggled
    end
    ScreamVenixCarry.setLaggerMode = function(self, mode)
        if mode == 0 then
            self.laggerMode = 0
        elseif mode == 1 then
            self.laggerMode = 1
        elseif mode == 2 then
            self.laggerMode = 2
        end
    end
    ScreamVenixCarry.toggleLaggerMode = function(self)
        if self.laggerMode == 0 then
            self.laggerMode = 1
        elseif self.laggerMode == 1 then
            self.laggerMode = 2
        else
            self.laggerMode = 0
        end
    end
    ScreamVenixCarry.setSoftStealEnabled = function(self, softStealEnabled)
        self.softStealEnabled = softStealEnabled
        if softStealEnabled then
            self:startSoftStealScanner()
        else
            self:stopSoftStealScanner()
            self.softStealLatched = false
        end
    end
    ScreamVenixCarry.toggleSoftSteal = function(self)
        self:setSoftStealEnabled(not self.softStealEnabled)
    end
    ScreamVenixCarry.isRunning = function(self)
        return self._heartbeatConn ~= nil
    end
    ScreamVenixCarry.getCurrentSpeed = function(self)
        return self:getActiveSpeed()
    end

ANIM_PACKS = {
    ["Zombie"] = { idle1="rbxassetid://616158929", idle2="rbxassetid://616160636", walk="rbxassetid://616168032", run="rbxassetid://616163682", jump="rbxassetid://616161997", fall="rbxassetid://616157476", climb="rbxassetid://616156119", swim="rbxassetid://616165109", swimidle="rbxassetid://616166655" },
    ["Ninja"] = { idle1="rbxassetid://656117400", idle2="rbxassetid://656117400", walk="rbxassetid://656121766", run="rbxassetid://656118852", jump="rbxassetid://656117878", fall="rbxassetid://656115606", climb="rbxassetid://656114359", swim="rbxassetid://656117400", swimidle="rbxassetid://656117400" },
    ["Knight"] = { idle1="rbxassetid://657595757", idle2="rbxassetid://657595757", walk="rbxassetid://657552124", run="rbxassetid://657564596", jump="rbxassetid://658409194", fall="rbxassetid://657600338", climb="rbxassetid://658360781", swim="rbxassetid://657595757", swimidle="rbxassetid://657595757" },
    ["Elder"] = { idle1="rbxassetid://845397899", idle2="rbxassetid://845397899", walk="rbxassetid://845403856", run="rbxassetid://845386501", jump="rbxassetid://845398858", fall="rbxassetid://845397673", climb="rbxassetid://845392038", swim="rbxassetid://845397899", swimidle="rbxassetid://845397899" },
    ["Levitate"] = { idle1="rbxassetid://616006778", idle2="rbxassetid://616006778", walk="rbxassetid://616013216", run="rbxassetid://616013216", jump="rbxassetid://616008936", fall="rbxassetid://616005863", climb="rbxassetid://616003713", swim="rbxassetid://616006778", swimidle="rbxassetid://616006778" },
    ["Astronaut"] = { idle1="rbxassetid://891621366", idle2="rbxassetid://891621366", walk="rbxassetid://891636393", run="rbxassetid://891636393", jump="rbxassetid://891627522", fall="rbxassetid://891617961", climb="rbxassetid://891609353", swim="rbxassetid://891621366", swimidle="rbxassetid://891621366" },
    ["Pirate"] = { idle1="rbxassetid://750781874", idle2="rbxassetid://750781874", walk="rbxassetid://750785693", run="rbxassetid://750783738", jump="rbxassetid://750782230", fall="rbxassetid://750780242", climb="rbxassetid://750779899", swim="rbxassetid://750781874", swimidle="rbxassetid://750781874" },
    ["Toy"] = { idle1="rbxassetid://782841498", idle2="rbxassetid://782841498", walk="rbxassetid://782843345", run="rbxassetid://782842708", jump="rbxassetid://782847020", fall="rbxassetid://782846423", climb="rbxassetid://782843869", swim="rbxassetid://782841498", swimidle="rbxassetid://782841498" },
    ["Vampire"] = { idle1="rbxassetid://1083445855", idle2="rbxassetid://1083445855", walk="rbxassetid://1083473930", run="rbxassetid://1083462077", jump="rbxassetid://1083455352", fall="rbxassetid://1083443587", climb="rbxassetid://1083439238", swim="rbxassetid://1083445855", swimidle="rbxassetid://1083445855" },
    ["Werewolf"] = { idle1="rbxassetid://1083195517", idle2="rbxassetid://1083195517", walk="rbxassetid://1083178339", run="rbxassetid://1083216690", jump="rbxassetid://1083218792", fall="rbxassetid://1083189019", climb="rbxassetid://1083182000", swim="rbxassetid://1083195517", swimidle="rbxassetid://1083195517" },
    ["Rthro"] = { idle1="rbxassetid://2510196951", idle2="rbxassetid://2510196951", walk="rbxassetid://2510202577", run="rbxassetid://2510198475", jump="rbxassetid://2510197830", fall="rbxassetid://2510195892", climb="rbxassetid://2510192778", swim="rbxassetid://2510196951", swimidle="rbxassetid://2510196951" },
    ["Stylish"] = { idle1="rbxassetid://616136790", idle2="rbxassetid://616136790", walk="rbxassetid://616146177", run="rbxassetid://616140816", jump="rbxassetid://616139451", fall="rbxassetid://616134815", climb="rbxassetid://616133594", swim="rbxassetid://616136790", swimidle="rbxassetid://616136790" },
}

ANIM_PACK_ORDER = {{"Off", "Off"}, {"Zombie", "Zombie"}, {"Ninja", "Ninja"}, {"Knight", "Knight"}, {"Elder", "Elder"}, {"Levitate", "Levitate"}, {"Astronaut", "Astronaut"}, {"Pirate", "Pirate"}, {"Toy", "Toy"}, {"Vampire", "Vampire"}, {"Werewolf", "Werewolf"}, {"Rthro", "Rthro"}, {"Stylish", "Stylish"}}

local function isPackAnim(id)
    for _, pack in pairs(ANIM_PACKS) do
        for _, v in pairs(pack) do
            if v == id then return true end
        end
    end
    return false
end

local function saveOriginalAnims(char)
    local animate = char:FindFirstChild("Animate")
    if not animate then return end
    local function g(obj) return obj and obj.AnimationId or nil end
    local ids = {
        idle1 = g(animate.idle and animate.idle.Animation1),
        idle2 = g(animate.idle and animate.idle.Animation2),
        walk  = g(animate.walk and animate.walk.WalkAnim),
        run   = g(animate.run  and animate.run.RunAnim),
        jump  = g(animate.jump and animate.jump.JumpAnim),
        fall  = g(animate.fall and animate.fall.FallAnim),
        climb = g(animate.climb and animate.climb.ClimbAnim),
        swim  = g(animate.swim and animate.swim.Swim),
        swimidle = g(animate.swimidle and animate.swimidle.SwimIdle),
    }
    if not isPackAnim(ids.walk) then originalTryardAnims = ids end
end

local function applyAnimPack(packName)
    currentAnimPack = packName
    if animSelectorLabel then animSelectorLabel.Text = packName end
    if packName == "Off" then
        if originalTryardAnims and LP.Character then
            local animate = LP.Character:FindFirstChild("Animate")
            if animate then
                local function s(obj,id) if obj then obj.AnimationId = id end end
                s(animate.idle and animate.idle.Animation1, originalTryardAnims.idle1)
                s(animate.idle and animate.idle.Animation2, originalTryardAnims.idle2)
                s(animate.walk and animate.walk.WalkAnim, originalTryardAnims.walk)
                s(animate.run  and animate.run.RunAnim,   originalTryardAnims.run)
                s(animate.jump and animate.jump.JumpAnim, originalTryardAnims.jump)
                s(animate.fall and animate.fall.FallAnim, originalTryardAnims.fall)
                s(animate.climb and animate.climb.ClimbAnim, originalTryardAnims.climb)
                s(animate.swim and animate.swim.Swim, originalTryardAnims.swim)
                s(animate.swimidle and animate.swimidle.SwimIdle, originalTryardAnims.swimidle)
            end
        end
        if tryardHeartbeatConn then tryardHeartbeatConn:Disconnect(); tryardHeartbeatConn = nil end
        return
    end
    local pack = ANIM_PACKS[packName]
    if not pack then return end
    if tryardHeartbeatConn then tryardHeartbeatConn:Disconnect() end
    tryardHeartbeatConn = RunService.Heartbeat:Connect(function()
        local c = LP.Character
        if not c then return end
        local animate = c:FindFirstChild("Animate")
        if not animate then return end
        local function s(obj,id) if obj then obj.AnimationId = id end end
        s(animate.idle and animate.idle.Animation1, pack.idle1)
        s(animate.idle and animate.idle.Animation2, pack.idle2)
        s(animate.walk and animate.walk.WalkAnim, pack.walk)
        s(animate.run  and animate.run.RunAnim,   pack.run)
        s(animate.jump and animate.jump.JumpAnim, pack.jump)
        s(animate.fall and animate.fall.FallAnim, pack.fall)
        s(animate.climb and animate.climb.ClimbAnim, pack.climb)
        s(animate.swim and animate.swim.Swim, pack.swim)
        s(animate.swimidle and animate.swimidle.SwimIdle, pack.swimidle)
    end)
end

local function startAnimPack(packName)
    local char = LP.Character
    if char then
        saveOriginalAnims(char)
        applyAnimPack(packName)
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            for _, track in ipairs(hum:GetPlayingAnimationTracks()) do track:Stop(0) end
            hum:ChangeState(Enum.HumanoidStateType.Running)
        end
    else
        applyAnimPack(packName)
    end
    currentAnimPack = packName
end

local function stopAnimPack()
    currentAnimPack = "Off"
    if animSelectorLabel then animSelectorLabel.Text = "Off" end
    applyAnimPack("Off")
end

DEFAULT_KB = {
    DropBrainrot = {kb = Enum.KeyCode.X, gp = nil},
    AutoLeft     = {kb = Enum.KeyCode.Z, gp = nil},
    AutoRight    = {kb = Enum.KeyCode.C, gp = nil},
    AutoBat      = {kb = Enum.KeyCode.E, gp = nil},
    TPFloor      = {kb = Enum.KeyCode.F, gp = nil},
    GuiHide      = {kb = Enum.KeyCode.LeftControl, gp = nil},
    CarryToggle  = {kb = Enum.KeyCode.Q, gp = nil},
    LaggerMode   = {kb = Enum.KeyCode.R, gp = nil},
    BatV2        = {kb = Enum.KeyCode.V, gp = nil},
    InstaReset   = {kb = Enum.KeyCode.T, gp = nil},
}

KB = {
    DropBrainrot = {kb = DEFAULT_KB.DropBrainrot.kb, gp = DEFAULT_KB.DropBrainrot.gp},
    AutoLeft     = {kb = DEFAULT_KB.AutoLeft.kb, gp = DEFAULT_KB.AutoLeft.gp},
    AutoRight    = {kb = DEFAULT_KB.AutoRight.kb, gp = DEFAULT_KB.AutoRight.gp},
    AutoBat      = {kb = DEFAULT_KB.AutoBat.kb, gp = DEFAULT_KB.AutoBat.gp},
    TPFloor      = {kb = DEFAULT_KB.TPFloor.kb, gp = DEFAULT_KB.TPFloor.gp},
    GuiHide      = {kb = DEFAULT_KB.GuiHide.kb, gp = DEFAULT_KB.GuiHide.gp},
    CarryToggle  = {kb = DEFAULT_KB.CarryToggle.kb, gp = DEFAULT_KB.CarryToggle.gp},
    LaggerMode   = {kb = DEFAULT_KB.LaggerMode.kb, gp = DEFAULT_KB.LaggerMode.gp},
    BatV2        = {kb = DEFAULT_KB.BatV2.kb, gp = DEFAULT_KB.BatV2.gp},
    InstaReset   = {kb = DEFAULT_KB.InstaReset.kb, gp = DEFAULT_KB.InstaReset.gp},
}

_isResetting = false
_lastSavedJSON = nil
_isLoading = false

CONFIG = {
    AUTO_STEAL_ENABLED = false,
    STEAL_RANGE = 61,
    HOLD_MIN = 0.05,
    HOLD_MAX = 0.15,
    ENTRY_DELAY = 0.1,
    COOLDOWN = 0.2,
    PRIME_RANGE = 60,
}

local plots = workspace:FindFirstChild("Plots")
local stealConnection = nil

local Steal = {
    AutoStealEnabled = false,
    StealRadius = CONFIG.STEAL_RANGE,
    StealDuration = 1.3,
    StealDelay = 0.25,
    Data = {}
}

local isStealing = false
local autoStealMode = "75"
local autoStealVariant = 1
local autoStealGeneration = 0
autoStealStartedAt = 0
autoStealLastActivity = _tick()
autoStealSupervisorConn = nil
-- Only: 75 | 80 (VX7 freeze 80%) | 85 (VX7 freeze 85%)
local AUTO_STEAL_VARIANT_NAMES = {"75", "80", "85"}
local function setAutoStealMode(mode)
    mode = tostring(mode or "75")
    -- migrate old saved modes
    if mode == "VX71" then mode = "80"
    elseif mode == "VX72" then mode = "85"
    elseif mode == "V1" or mode == "V2" or mode == "90" or mode == "V3" or mode == "Semi" or mode == "V4" then
        mode = "75"
    end
    autoStealVariant = 1
    for i, name in ipairs(AUTO_STEAL_VARIANT_NAMES) do
        if name == mode then autoStealVariant = i; break end
    end
    autoStealMode = AUTO_STEAL_VARIANT_NAMES[autoStealVariant]
    if autoStealMode == "80" then
        Steal.StealRadius = 63
    else
        -- Mode 85 uses Monolith radius (CONFIG.STEAL_RANGE / 61)
        Steal.StealRadius = CONFIG.STEAL_RANGE
    end
end
local function isVx7AutoStealMode()
    -- Only mode 80 keeps the old VX7 freeze logic
    return autoStealMode == "80" or autoStealVariant == 2
end
local function isMonolithV85Mode()
    -- Mode 85 uses Monolith V-steal system (source autograbv2)
    return autoStealMode == "85" or autoStealVariant == 3
end
local function getVx7FreezePercent()
    return 0.80 -- mode 80 only
end
local function getAutoStealDuration()
    -- Mode 85 (Monolith): hold = duration * 0.85
    if isMonolithV85Mode() then
        return Steal.StealDuration * 0.85
    end
    -- Mode 80: VX7 freeze timing (base hold 1.35s * 80%)
    if isVx7AutoStealMode() then
        return 1.35 * getVx7FreezePercent()
    end
    -- 75%
    return Steal.StealDuration * 0.75
end
local autoGrabSetDelayRadius = 9  -- Monolith delayRadius for mode 85
local autoGrabStopTime = 0.96
local autoGrabStopEnabled = true

local _plotsCache = nil
local _plotsCacheTime = 0
local function getPlotsRoot()
    local now = _tick()
    if _plotsCache and now - _plotsCacheTime < 2 and _plotsCache.Parent then
        return _plotsCache
    end
    _plotsCache = workspace:FindFirstChild("Plots")
    _plotsCacheTime = now
    return _plotsCache
end

local function isMyPlotByName(plotName)
    local plotsRoot = getPlotsRoot()
    if not plotsRoot then return false end
    local plot = plotsRoot:FindFirstChild(plotName)
    if not plot then return false end
    local sign = plot:FindFirstChild("PlotSign")
    if sign then
        local yb = sign:FindFirstChild("YourBase")
        if yb and yb:IsA("BillboardGui") then
            return yb.Enabled == true
        end
    end
    return false
end

local function findNearestPrompt()
    local char = LP.Character
    if not char then return nil, nil end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return nil, nil end
    local plotsRoot = getPlotsRoot()
    if not plotsRoot then return nil, nil end
    local nearestPrompt, nearestDist, nearestName = nil, _huge, nil
    local rpos = root.Position
    for _, plot in ipairs(plotsRoot:GetChildren()) do
        if isMyPlotByName(plot.Name) then continue end
        local pods = plot:FindFirstChild("AnimalPodiums")
        if not pods then continue end
        for _, pod in ipairs(pods:GetChildren()) do
            pcall(function()
                local base = pod:FindFirstChild("Base")
                local spawn = base and base:FindFirstChild("Spawn")
                if spawn then
                    local sp = spawn.Position
                    local dx = sp.X - rpos.X
                    local dy = sp.Y - rpos.Y
                    local dz = sp.Z - rpos.Z
                    local dist = _sqrt(dx*dx + dy*dy + dz*dz)
                    if dist < nearestDist and dist <= Steal.StealRadius then
                        local att = spawn:FindFirstChild("PromptAttachment")
                        if att then
                            for _, child in ipairs(att:GetChildren()) do
                                if child:IsA("ProximityPrompt") and child.ActionText and child.ActionText:find("Steal") then
                                    nearestPrompt = child
                                    nearestDist = dist
                                    nearestName = pod.Name
                                    break
                                end
                            end
                        end
                    end
                end
            end)
        end
    end
    return nearestPrompt, nearestName
end

local function executeSteal(prompt, podName)
    if isStealing or not prompt or not prompt.Parent then return end
    for old in pairs(Steal.Data) do if not old.Parent then Steal.Data[old] = nil end end
    local data = Steal.Data[prompt]
    if not data then
        data = {hold = {}, trigger = {}, ready = true}
        Steal.Data[prompt] = data
        pcall(function()
            if type(getconnections) ~= "function" then return end
            for _, c in ipairs(getconnections(prompt.PromptButtonHoldBegan)) do
                if c.Function then table.insert(data.hold, c.Function) end
            end
            for _, c in ipairs(getconnections(prompt.Triggered)) do
                if c.Function then table.insert(data.trigger, c.Function) end
            end
        end)
    end
    if not data.ready then return end
    local generation = autoStealGeneration
    data.ready = false
    isStealing = true
    autoStealStartedAt = _tick()
    autoStealLastActivity = autoStealStartedAt
    local function active()
        return generation == autoStealGeneration and isStealing and Steal.AutoStealEnabled
            and _mySession == _G.RivalHubSession
    end
    local function distance()
        if not prompt.Parent or not prompt.Parent.Parent then return nil end
        local char = LP.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if not root or not hum or hum.Health <= 0 then return nil end
        local parent = prompt.Parent
        local part = parent:IsA("BasePart") and parent or parent.Parent
        if not part or not part:IsA("BasePart") then return nil end
        return (root.Position - part.Position).Magnitude
    end
    local function valid()
        if not active() then return false end
        local d = distance()
        return d ~= nil and d <= Steal.StealRadius
    end
    task.spawn(function()
        local success, err = pcall(function()
            updateStealProgress(0, "STEALING")
            for _, fn in ipairs(data.hold) do task.spawn(fn) end
            local started = _tick()
            local vx7 = isVx7AutoStealMode()
            local monolith85 = isMonolithV85Mode()
            local freezePct = vx7 and getVx7FreezePercent() or (monolith85 and 0.85 or nil)
            -- Mode 85 = Monolith V-steal (duration 1.3 * 0.85). Mode 80 = old VX7 (1.35). Mode 75 = classic.
            local duration = vx7 and 1.35 or Steal.StealDuration
            local stopTime = getAutoStealDuration()
            while valid() and _tick() - started < stopTime do
                local prog
                if monolith85 then
                    -- Monolith: progress goes to freezePct over holdTime
                    prog = freezePct * math.clamp((_tick() - started) / stopTime, 0, 1)
                elseif vx7 then
                    prog = freezePct * math.clamp((_tick() - started) / stopTime, 0, 1)
                else
                    prog = (_tick() - started) / duration
                end
                updateStealProgress(prog, "STEALING")
                task.wait()
            end
            if not valid() then return end
            local stopProgress = (vx7 or monolith85) and freezePct or _clamp(stopTime / duration, 0, 1)
            updateStealProgress(stopProgress, "APPROACH")

            if monolith85 then
                -- ===== MONOLITH V3 (0.85) SYSTEM =====
                -- After hold: wait until player enters delayRadius (9), with maxWait, then fill remaining and trigger
                local delayRadius = autoGrabSetDelayRadius or 9
                local maxWait = math.max(2.99 - stopTime - math.max(duration - stopTime, 0), 0.05)
                local delayStart = _tick()
                local enteredRange = false
                while valid() and (_tick() - delayStart) < maxWait do
                    local d = distance()
                    if d and d <= delayRadius then
                        enteredRange = true
                        break
                    end
                    task.wait()
                end
                if not enteredRange or not valid() then return end
                local fillStart = _tick()
                local fillDuration = math.max(duration - stopTime, 0.05)
                while valid() do
                    local fp = _clamp((_tick() - fillStart) / fillDuration, 0, 1)
                    updateStealProgress(stopProgress + fp * (1 - stopProgress), "STEALING")
                    if fp >= 1 then break end
                    task.wait()
                end
                if not valid() then return end
            else
                -- Mode 80 (VX7) or 75 (classic)
                local completeRadius = vx7 and 7 or 9
                local deadline = _tick() + math.max(2.99 - stopTime - math.max(duration - stopTime, 0), 0.05)
                while valid() do
                    local d = distance()
                    if d and d <= completeRadius then break end
                    if _tick() >= deadline then return end
                    task.wait()
                end
                if not valid() then return end
                local fillStart = _tick()
                local fillDuration = math.max(duration - stopTime, 0.05)
                while valid() do
                    local fp = _clamp((_tick() - fillStart) / fillDuration, 0, 1)
                    updateStealProgress(stopProgress + fp * (1 - stopProgress), "STEALING")
                    if fp >= 1 then break end
                    task.wait()
                end
                if not valid() then return end
            end

            for _, fn in ipairs(data.trigger) do task.spawn(fn) end
            local remote = ReplicatedStorage:FindFirstChild("StealAnimal")
            if remote and remote:IsA("RemoteEvent") and podName then pcall(function() remote:FireServer(podName) end) end
            if #data.trigger == 0 then
                if type(fireproximityprompt) == "function" then pcall(fireproximityprompt, prompt)
                else pcall(function() prompt:InputHoldBegin(); prompt:InputHoldEnd() end) end
            end
            updateStealProgress(1, "COMPLETE")
            task.wait(0.12)
        end)
        data.ready = true
        if generation == autoStealGeneration then
            isStealing = false
            autoStealStartedAt = 0
            autoStealLastActivity = _tick()
            updateStealProgress(0, "READY")
        end
        if not success then warn("[Screamhub Auto Steal] " .. tostring(err)) end
    end)
end
function startAutoSteal()
    Steal.StealRadius = (autoStealMode == "80" or autoStealVariant == 2) and 63 or CONFIG.STEAL_RANGE
    Steal.AutoStealEnabled = true
    CONFIG.AUTO_STEAL_ENABLED = true
    autoStealLastActivity = _tick()

    if stealConnection and not stealConnection.Connected then
        stealConnection = nil
    end
    if stealConnection then return true end

    stealConnection = RunService.Heartbeat:Connect(function()
        if _mySession ~= _G.RivalHubSession then
            stopAutoSteal()
            return
        end
        if not CONFIG.AUTO_STEAL_ENABLED then return end

        if not Steal.AutoStealEnabled then
            Steal.AutoStealEnabled = true
        end

        if isStealing then
            if autoStealStartedAt > 0 and (_tick() - autoStealStartedAt) > 6 then
                autoStealGeneration = autoStealGeneration + 1
                isStealing = false
                autoStealStartedAt = 0
                for _, data in pairs(Steal.Data) do
                    data.ready = true
                end
                updateStealProgress(0, "READY")
            end
            return
        end

        local p, name = findNearestPrompt()
        if p then
            autoStealLastActivity = _tick()
            executeSteal(p, name)
        end
    end)
    return true
end

function stopAutoSteal()
    autoStealGeneration = autoStealGeneration + 1
    if stealConnection then
        pcall(function() stealConnection:Disconnect() end)
        stealConnection = nil
    end
    isStealing = false
    autoStealStartedAt = 0
    autoStealLastActivity = _tick()
    Steal.AutoStealEnabled = false
    CONFIG.AUTO_STEAL_ENABLED = false
    for _, data in pairs(Steal.Data) do data.ready = true end
    updateStealProgress(0, "READY")
end

if autoStealSupervisorConn then
    pcall(function() autoStealSupervisorConn:Disconnect() end)
end
autoStealSupervisorElapsed = 0
do
    autoStealSupervisorConn = RunService.Heartbeat:Connect(function(dt)
        if _mySession ~= _G.RivalHubSession then
            if autoStealSupervisorConn then
                pcall(function() autoStealSupervisorConn:Disconnect() end)
                autoStealSupervisorConn = nil
            end
            return
        end

        autoStealSupervisorElapsed = autoStealSupervisorElapsed + dt
        if autoStealSupervisorElapsed < 0.5 then return end
        autoStealSupervisorElapsed = 0

        if CONFIG.AUTO_STEAL_ENABLED then
            local alive = stealConnection and stealConnection.Connected
            if not alive or not Steal.AutoStealEnabled then
                pcall(startAutoSteal)
            elseif isStealing and autoStealStartedAt > 0 and (_tick() - autoStealStartedAt) > 6 then
                autoStealGeneration = autoStealGeneration + 1
                isStealing = false
                autoStealStartedAt = 0
                for _, data in pairs(Steal.Data) do
                    data.ready = true
                end
                updateStealProgress(0, "READY")
            end
        end
    end)
end

medusaDebounce = false
medusaLastUsed = 0
dropActive = false
lastDropTime = 0
lastMoveDir = _V3new(0,0,0)
origFOV = nil
fovEnabled = false
fovValue = 70
customFovConn = nil

_anyKeyListening = false
_aimbotConn = nil
_prevAutoRotate = nil
tpBatConn = nil
tpBatPrevAutoRotate = nil
tpBatHitCD = false
TP_BAT_SWING_CD = 0.08

enemySpeedConn = nil
movementLoop = nil
steppedConn = nil
alConn = nil
arConn = nil
infJumpConn = nil
stretchConn = nil
stretchFovConn = nil
antiLagDescConn = nil
medusaResetConns = {}
dropConnections = {}
enemySpeedLabels = {}
Conns = {autoSteal = nil, batCounter = nil, anchor = {}, progress = nil, autoLeft = nil, autoRight = nil}
keyButtonRefs = {}
progressFill = nil
progressPct = nil
progressStatus = nil
progressTween = nil
pbFrame = nil
stealHud = {value = 0, state = "READY", statsText = "-- FPS  ·  PING: -- MS"}
speedLabel = nil
modeValLbl = nil
normalBox, carryBox, laggerBox, lagger2Box, radInput, batSpeedBox, uiScaleBox = nil, nil, nil, nil, nil, nil, nil
modeSelectBtn, dropModeBtnRef = nil, nil
autoBatSetVisual, autoLeftSetVisual, autoRightSetVisual, setBatCounterVisual, setMedusaVisual = nil, nil, nil, nil, nil
setAntiRagVisual, setUnwalkVisual, setAntiLagVisual, setLockUIVisual, setInstaGrab = nil, nil, nil, nil, nil
infJumpSetVisual = nil
infJumpModeBtn = nil
autoStealModeBtn = nil
setAntiDieVisual = nil
setAntiBatVisual = nil
setAntiFlingVisual = nil
setESPVIsual = nil
setESPLineVisual = nil
mobSetAutoBat, mobSetAutoLeft, mobSetAutoRight, mobSetDropBR, mobSetTpDown, mobSetCarry, mobSetLagger1, mobSetLagger2, mobSetBatV2 = nil, nil, nil, nil, nil, nil, nil, nil, nil
miniBtn, main, gui = nil, nil, nil
MobilePanel = nil
showGui = nil
hideGui = nil
mainUIScale = nil
animSelectorLabel = nil
pbScale = nil
tabButtons = nil
colorSelectorLabel = nil

GAMEPAD_KEYS = {
    [Enum.KeyCode.ButtonA] = true, [Enum.KeyCode.ButtonB] = true,
    [Enum.KeyCode.ButtonX] = true, [Enum.KeyCode.ButtonY] = true,
    [Enum.KeyCode.ButtonL1] = true, [Enum.KeyCode.ButtonR1] = true,
    [Enum.KeyCode.ButtonL2] = true, [Enum.KeyCode.ButtonR2] = true,
    [Enum.KeyCode.ButtonL3] = true, [Enum.KeyCode.ButtonR3] = true,
    [Enum.KeyCode.ButtonStart] = true, [Enum.KeyCode.ButtonSelect] = true,
    [Enum.KeyCode.DPadUp] = true, [Enum.KeyCode.DPadDown] = true,
    [Enum.KeyCode.DPadLeft] = true, [Enum.KeyCode.DPadRight] = true,
}

MOVE_KEYS = {
    [Enum.KeyCode.W] = true, [Enum.KeyCode.A] = true,
    [Enum.KeyCode.S] = true, [Enum.KeyCode.D] = true,
    [Enum.KeyCode.Up] = true, [Enum.KeyCode.Left] = true,
    [Enum.KeyCode.Down] = true, [Enum.KeyCode.Right] = true,
}

BAT_COUNTER_SLAP_LIST = {
    "Bat", "Slap", "Iron Slap", "Gold Slap", "Diamond Slap",
    "Emerald Slap", "Ruby Slap", "Dark Matter Slap", "Flame Slap",
    "Nuclear Slap", "Galaxy Slap", "Glitched Slap"
}

AP = {
    L1 = _V3new(-476.48, -6.28, 92.73),
    L2 = _V3new(-483.12, -4.95, 94.80),
    L_FACE = _V3new(-482.25, -4.96, 92.09),
    R1 = _V3new(-476.16, -6.52, 25.62),
    R2 = _V3new(-483.06, -5.03, 25.48),
    R_FACE = _V3new(-482.06, -6.93, 35.47),
}

function isGamepadInput(inp)
    return inp and inp.UserInputType and inp.UserInputType.Name:match("^Gamepad") ~= nil
end

function isBindableInput(inp)
    if not inp or inp.KeyCode == Enum.KeyCode.Unknown then return false end
    if inp.UserInputType == Enum.UserInputType.Keyboard then return true end
    return isGamepadInput(inp) and GAMEPAD_KEYS[inp.KeyCode] == true
end

function kbMatch(entry, kc)
    return kc and (kc == entry.kb or (entry.gp and kc == entry.gp))
end


-- ============================================================
-- INSTA RESET — HipHeight method (Source-du-Insta-Reset)
-- ============================================================
setInstaResetVisual = nil

local _irResetCooldown = false
local _irResetThread = nil
local _irCurrentCharacter = nil
local _irResetSuccessful = false
local _irStopSequence = false
local RESET_MAX_DURATION = 0.05

local function stopInstaReset()
    _irStopSequence = true
    if _irResetThread then
        pcall(function() task.cancel(_irResetThread) end)
        _irResetThread = nil
    end
    _irResetCooldown = false
    _irCurrentCharacter = nil
    _G.__ScreamInstaResetInProgress = false
    if setInstaResetVisual then pcall(setInstaResetVisual, false) end
end

function doInstaReset()
    if _irResetCooldown then return end
    _irResetCooldown = true
    _irResetSuccessful = false
    _irStopSequence = false
    _G.__ScreamInstaResetInProgress = true
    if setInstaResetVisual then pcall(setInstaResetVisual, true) end

    local character = LP.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    if not character or not humanoid then
        _irResetCooldown = false
        _G.__ScreamInstaResetInProgress = false
        if setInstaResetVisual then pcall(setInstaResetVisual, false) end
        return
    end

    _irCurrentCharacter = character
    _irResetThread = task.spawn(function()
        local attempts = 0
        local maxAttempts = 40
        local originalHipHeight = humanoid.HipHeight

        while character and character.Parent and humanoid and humanoid.Health > 0
            and LP.Character == character and not _irStopSequence do
            pcall(function()
                humanoid.HipHeight = 1e30
                humanoid.AutoRotate = true

                local rootPart = character:FindFirstChild("HumanoidRootPart")
                if rootPart then rootPart.CanCollide = false end
                for _, part in ipairs(character:GetChildren()) do
                    if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                        part.CanCollide = false
                    end
                end
            end)

            if not character.Parent or humanoid.Health <= 0 or LP.Character ~= character then
                _irResetSuccessful = true
                break
            end

            attempts = attempts + 1
            if attempts >= maxAttempts then break end
            task.wait(RESET_MAX_DURATION)
        end

        -- Fallback: force death if still alive
        if not _irResetSuccessful and character and character.Parent and humanoid.Health > 0
            and LP.Character == character then
            pcall(function() humanoid.Health = 0 end)
            task.wait(0.1)
            if not character.Parent or humanoid.Health <= 0 then
                _irResetSuccessful = true
            end
        end

        -- Restore if failed
        if not _irResetSuccessful and character and character.Parent and humanoid then
            pcall(function()
                humanoid.HipHeight = originalHipHeight
                local rootPart = character:FindFirstChild("HumanoidRootPart")
                if rootPart then rootPart.CanCollide = true end
                for _, part in ipairs(character:GetChildren()) do
                    if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                        part.CanCollide = true
                    end
                end
            end)
        end

        _irResetCooldown = false
        _irResetThread = nil
        _irCurrentCharacter = nil
        _irStopSequence = false
        _G.__ScreamInstaResetInProgress = false
        if setInstaResetVisual then pcall(setInstaResetVisual, false) end
    end)
end

_G.doInstaReset = doInstaReset
_G.stopInstaReset = stopInstaReset

-- Cleanup on respawn
LP.CharacterAdded:Connect(function()
    stopInstaReset()
    _irResetSuccessful = false
    _irStopSequence = false
end)

-- Watcher: clear state when character dies / changes
task.spawn(function()
    local session = _G.RivalHubSession
    while session == _G.RivalHubSession do
        task.wait(0.2)
        local character = LP.Character
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        if (humanoid and humanoid.Health <= 0)
            or (_irCurrentCharacter and character ~= _irCurrentCharacter) then
            _irResetSuccessful = true
            if _irResetThread then
                pcall(function() task.cancel(_irResetThread) end)
                _irResetThread = nil
            end
            _irResetCooldown = false
            _irCurrentCharacter = nil
            _G.__ScreamInstaResetInProgress = false
            if setInstaResetVisual then pcall(setInstaResetVisual, false) end
        end
    end
end)

function updateStealProgress(value, state)
    value = _clamp(tonumber(value) or 0, 0, 1)
    state = state or "READY"
    stealHud.value, stealHud.state = value, state
    if progressFill then
        progressFill.Size = UDim2.new(value, 0, 1, 0)
        local accent = getThemeColor and getThemeColor() or Color3.fromRGB(90, 140, 255)
        local dim = Color3.new(accent.R * 0.55, accent.G * 0.55, accent.B * 0.55)
        if state == "STEALING" or state == "APPROACH" or state == "COMPLETE" then
            progressFill.BackgroundColor3 = accent
        else
            progressFill.BackgroundColor3 = dim
        end
        local grad = progressFill:FindFirstChildOfClass("UIGradient")
        if grad then
            grad.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, dim),
                ColorSequenceKeypoint.new(0.38, accent),
                ColorSequenceKeypoint.new(0.68, accent:Lerp(Color3.new(1, 1, 1), 0.34)),
                ColorSequenceKeypoint.new(1, dim),
            })
        end
    end
    if progressPct then progressPct.Text = _floor(value * 100 + 0.5) .. "%" end
    if progressStatus then
        local label = state == "APPROACH" and "GET CLOSER"
            or state == "STEALING" and "STEALING"
            or state == "COMPLETE" and "DONE"
            or state == "READY" and "STEAL"
            or state
        progressStatus.Text = label
        if state == "STEALING" or state == "COMPLETE" then
            progressStatus.TextColor3 = Color3.fromRGB(255, 255, 255)
        elseif state == "APPROACH" then
            progressStatus.TextColor3 = Color3.fromRGB(255, 200, 120)
        else
            progressStatus.TextColor3 = Color3.fromRGB(205, 205, 214)
        end
    end
end

function resetProgressBar()
    updateStealProgress(0, "READY")
end

local function doTpDown()
    pcall(function()
        local char = LP.Character
        if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        if not root then return end
        local _, yaw = root.CFrame:ToEulerAnglesYXZ()
        root.CFrame = _CFnew(root.Position.X, -7, root.Position.Z) * CFrame.Angles(0, yaw, 0)
        root.AssemblyLinearVelocity = _V3zero
        root.AssemblyAngularVelocity = _V3zero
    end)
end

_G._VynxRunTPDown = doTpDown
_G._VynxTPDownIsAutoOn = function() return false end

local AntiRagdollV1 = {}
AntiRagdollV1.__index = AntiRagdollV1

local BOOST_SPEED = 400
local AR_DEFAULT_SPEED = 16

local stateV1 = {
    active = false,
    isBoosting = false,
    cachedChar = nil,
    ragdollConnections = {},
}

local function disconnectAllV1()
    for _, conn in ipairs(stateV1.ragdollConnections) do
        pcall(function() conn:Disconnect() end)
    end
    stateV1.ragdollConnections = {}
end

local function cacheCharacterV1()
    local char = LP.Character
    if not char then return false end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local root = char:FindFirstChild("HumanoidRootPart")
    if not hum or not root then return false end
    stateV1.cachedChar = { character = char, humanoid = hum, root = root }
    return true
end

local function isRagdolledV1()
    if not stateV1.cachedChar or not stateV1.cachedChar.humanoid then return false end
    local hum = stateV1.cachedChar.humanoid
    local st = hum:GetState()
    local ragdollStates = {
        [Enum.HumanoidStateType.Physics] = true,
        [Enum.HumanoidStateType.Ragdoll] = true,
        [Enum.HumanoidStateType.FallingDown] = true,
    }
    return ragdollStates[st] or false
end

local function forceExitRagdollV1()
    if not stateV1.cachedChar or not stateV1.cachedChar.humanoid or not stateV1.cachedChar.root then return end
    local hum = stateV1.cachedChar.humanoid
    local root = stateV1.cachedChar.root
    pcall(function()
        LP:SetAttribute("RagdollEndTime", workspace:GetServerTimeNow())
    end)
    for _, descendant in ipairs(stateV1.cachedChar.character:GetDescendants()) do
        if descendant:IsA("BallSocketConstraint") or
           (descendant:IsA("Attachment") and descendant.Name:find("RagdollAttachment")) then
            descendant:Destroy()
        end
    end
    if not stateV1.isBoosting then
        stateV1.isBoosting = true
        hum.WalkSpeed = BOOST_SPEED
    end
    if hum.Health > 0 then
        hum:ChangeState(Enum.HumanoidStateType.Running)
    end
    root.Anchored = false
end

local function heartbeatLoopV1()
    while stateV1.active do
        task.wait()
        if isRagdolledV1() then
            forceExitRagdollV1()
        elseif stateV1.isBoosting and not isRagdolledV1() then
            stateV1.isBoosting = false
            if stateV1.cachedChar and stateV1.cachedChar.humanoid then
                stateV1.cachedChar.humanoid.WalkSpeed = AR_DEFAULT_SPEED
            end
        end
    end
end

function AntiRagdollV1.start()
    if stateV1.active then return end
    AntiRagdollV1.stop()
    if not cacheCharacterV1() then
        warn("[AntiRagdollV1] No se pudo cachear el personaje")
        return
    end
    stateV1.active = true
    stateV1.isBoosting = false
    local camConn = RunService.RenderStepped:Connect(function()
        local cam = workspace.CurrentCamera
        if cam and stateV1.cachedChar and stateV1.cachedChar.humanoid then
            cam.CameraSubject = stateV1.cachedChar.humanoid
        end
    end)
    table.insert(stateV1.ragdollConnections, camConn)
    local respawnConn = LP.CharacterAdded:Connect(function()
        stateV1.isBoosting = false
        task.wait(0.5)
        cacheCharacterV1()
    end)
    table.insert(stateV1.ragdollConnections, respawnConn)
    task.spawn(heartbeatLoopV1)
    print("[AntiRagdollV1] Activado")
end

function AntiRagdollV1.stop()
    stateV1.active = false
    if stateV1.isBoosting and stateV1.cachedChar and stateV1.cachedChar.humanoid then
        stateV1.cachedChar.humanoid.WalkSpeed = AR_DEFAULT_SPEED
    end
    stateV1.isBoosting = false
    disconnectAllV1()
    stateV1.cachedChar = nil
    print("[AntiRagdollV1] Desactivado")
end

function AntiRagdollV1.isRunning() return stateV1.active end

local AntiRagdollV2 = {
    Enabled = false,
    Connection = nil,
    ResetCooldown = 0,
}

local function startAntiRagdollV2()
    if AntiRagdollV2.Connection then return end
    AntiRagdollV2.Enabled = true
    AntiRagdollV2.Connection = RunService.Heartbeat:Connect(function()
        if not AntiRagdollV2.Enabled then return end
        local char = LP.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        local root = char:FindFirstChild("HumanoidRootPart")
        if not hum or not root then return end
        if hum.Health <= 0 or hum:GetState() == Enum.HumanoidStateType.Dead then return end
        local state = hum:GetState()
        local now = _tick()
        if state == Enum.HumanoidStateType.Physics or
           state == Enum.HumanoidStateType.Ragdoll or
           state == Enum.HumanoidStateType.FallingDown then
            if now - AntiRagdollV2.ResetCooldown > 0.15 then
                AntiRagdollV2.ResetCooldown = now
                pcall(function()
                    if hum:GetState() == Enum.HumanoidStateType.GettingUp then return end
                    if hum.Health <= 0 or hum:GetState() == Enum.HumanoidStateType.Dead then return end
                    hum:ChangeState(Enum.HumanoidStateType.GettingUp)
                    root.Velocity = _V3zero
                    root.RotVelocity = _V3zero
                    -- Kill launch velocity from bat hits (especially upward)
                    local v = root.AssemblyLinearVelocity
                    root.AssemblyLinearVelocity = _V3new(
                        v.X * 0.15,
                        math.clamp(v.Y, -25, 8),
                        v.Z * 0.15
                    )
                    root.AssemblyAngularVelocity = _V3zero
                    for _, obj in ipairs(char:GetDescendants()) do
                        if obj:IsA("Motor6D") then obj.Enabled = true end
                        if obj:IsA("Constraint") then obj.Enabled = true end
                    end
                    workspace.CurrentCamera.CameraSubject = hum
                    local PM = LP.PlayerScripts:FindFirstChild("PlayerModule")
                    if PM then
                        local CM = require(PM:FindFirstChild("ControlModule"))
                        if CM then CM:Enable() end
                    end
                    hum.AutoRotate = true
                    hum.PlatformStand = false
                    hum.Sit = false
                end)
            end
        end
    end)
end

local function stopAntiRagdollV2()
    AntiRagdollV2.Enabled = false
    if AntiRagdollV2.Connection then
        AntiRagdollV2.Connection:Disconnect()
        AntiRagdollV2.Connection = nil
    end
    AntiRagdollV2.ResetCooldown = 0
end

function setAntiRagdollMode(mode)
    if AntiRagdollV1.isRunning() then AntiRagdollV1.stop() end
    if AntiRagdollV2.Enabled then stopAntiRagdollV2() end
    antiRagdollMode = mode
    if mode == "v1" then AntiRagdollV1.start()
    elseif mode == "v2" then startAntiRagdollV2() end
    if _G.updateAntiRagdollUI then _G.updateAntiRagdollUI(mode) end
    saveAllSettings()
end

_antiDieEnabled = false
_antiDieStopped = false
_antiDieSources = { toggle = false, autobat = false }

_antiDie = {
    enabled = false, loop = nil, healthConn = nil, charConn = nil,
    lastHealTime = 0, invincibleUntil = 0,
    config = {
        healthThreshold = 50,
        invincibilityFrames = 0.75,
        fallDamageProtection = false,
        ragdollProtection = true,
        autoRevive = true,
    },
}

function _antiDie.SuperHeal(hum)
    if not hum or not hum.Parent then return end
    local maxHealth = hum.MaxHealth or 100
    if maxHealth <= 0 or maxHealth == math.huge then maxHealth = 100 end
    pcall(function()
        hum.Health = maxHealth
        if hum.MaxHealth < maxHealth then hum.MaxHealth = maxHealth end
    end)
    _antiDie.invincibleUntil = _tick() + _antiDie.config.invincibilityFrames
    _antiDie.lastHealTime = _tick()
    pcall(function()
        local char = hum.Parent
        if not char then return end
        for _, child in ipairs(char:GetChildren()) do
            if child:IsA("NumberValue") then
                local name = child.Name:lower()
                if name:find("health") or name:find("hp") or name:find("life") then
                    child.Value = maxHealth
                end
            end
            if child:IsA("BoolValue") and child.Name:lower():find("dead") then
                child.Value = false
            end
        end
    end)
end

function _antiDie.PreventDamage(root, hum)
    if not hum then return end
    if hum.Health < (hum.MaxHealth or 100) then _antiDie.SuperHeal(hum) end
    if _tick() < _antiDie.invincibleUntil then
        if hum.Health < (hum.MaxHealth or 100) then
            hum.Health = hum.MaxHealth or 100
        end
    end
    if _antiDie.config.ragdollProtection then
        local state = hum:GetState()
        if state == Enum.HumanoidStateType.Physics or
           state == Enum.HumanoidStateType.Ragdoll or
           state == Enum.HumanoidStateType.FallingDown or
           state == Enum.HumanoidStateType.Dead then
            pcall(function()
                hum:ChangeState(Enum.HumanoidStateType.GettingUp)
                hum:ChangeState(Enum.HumanoidStateType.Running)
            end)
            _antiDie.SuperHeal(hum)
            if root then
                pcall(function() root.AssemblyAngularVelocity = Vector3.zero end)
            end
        end
    end
    if hum.Health <= 0 then
        _antiDie.SuperHeal(hum)
        pcall(function()
            hum:ChangeState(Enum.HumanoidStateType.GettingUp)
            hum:ChangeState(Enum.HumanoidStateType.Running)
        end)
        if root then
            pcall(function()
                root.CFrame = CFrame.new(root.Position + Vector3.new(0, 2, 0))
                root.AssemblyLinearVelocity = Vector3.zero
            end)
        end
    end
end

function _antiDie.AutoRevive()
    if not _antiDie.config.autoRevive then return end
    local char = LP.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local root = char:FindFirstChild("HumanoidRootPart")
    if not hum then return end
    if hum.Health <= 0 then
        _antiDie.SuperHeal(hum)
        pcall(function()
            hum:ChangeState(Enum.HumanoidStateType.GettingUp)
            hum:ChangeState(Enum.HumanoidStateType.Running)
        end)
        if root then
            pcall(function()
                root.CFrame = CFrame.new(root.Position + Vector3.new(0, 3, 0))
                root.AssemblyLinearVelocity = Vector3.zero
            end)
        end
    end
end

function _antiDie.AttachHealth(char)
    if _antiDie.healthConn then _antiDie.healthConn:Disconnect(); _antiDie.healthConn = nil end
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not hum then hum = char and char:WaitForChild("Humanoid", 3) end
    if not hum then return end
    _antiDie.healthConn = hum:GetPropertyChangedSignal("Health"):Connect(function()
        if not _antiDie.enabled then return end
        if hum.Health < (hum.MaxHealth or 100) then _antiDie.SuperHeal(hum) end
        if hum.Health <= 0 then _antiDie.AutoRevive() end
    end)
    if hum.Health < (hum.MaxHealth or 100) then _antiDie.SuperHeal(hum) end
end

function _antiDie.StartEngine()
    if _antiDie.enabled and _antiDie.loop then return end
    _antiDie.enabled = true
    _antiDieEnabled = true
    antiDieEnabled = true
    if _antiDie.loop then _antiDie.loop:Disconnect(); _antiDie.loop = nil end
    if _antiDie.healthConn then _antiDie.healthConn:Disconnect(); _antiDie.healthConn = nil end
    _antiDie.loop = RunService.Heartbeat:Connect(function()
        if not _antiDie.enabled then return end
        local char = LP.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        local root = char:FindFirstChild("HumanoidRootPart")
        if not hum then return end
        if hum.Health <= 0 then _antiDie.AutoRevive()
        elseif hum.Health <= _antiDie.config.healthThreshold then _antiDie.SuperHeal(hum)
        elseif hum.Health < (hum.MaxHealth or 100) then _antiDie.SuperHeal(hum) end
        _antiDie.PreventDamage(root, hum)
    end)
    if LP.Character then _antiDie.AttachHealth(LP.Character) end
    if _antiDie.charConn then _antiDie.charConn:Disconnect(); _antiDie.charConn = nil end
    _antiDie.charConn = LP.CharacterAdded:Connect(function(char)
        if not _antiDie.enabled then return end
        task.wait(0.05)
        _antiDie.AttachHealth(char)
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then _antiDie.SuperHeal(hum) end
    end)
end

function _antiDie.StopEngine()
    _antiDie.enabled = false
    _antiDieEnabled = false
    antiDieEnabled = false
    if _antiDie.loop then _antiDie.loop:Disconnect(); _antiDie.loop = nil end
    if _antiDie.healthConn then _antiDie.healthConn:Disconnect(); _antiDie.healthConn = nil end
    if _antiDie.charConn then _antiDie.charConn:Disconnect(); _antiDie.charConn = nil end
    pcall(function()
        local char = LP.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if not hum then return end
        hum:SetStateEnabled(Enum.HumanoidStateType.Dead, true)
        hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, true)
        hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
        hum.BreakJointsOnDeath = true
        if hum.MaxHealth == math.huge or hum.MaxHealth <= 0 then
            hum.MaxHealth = 100
            hum.Health = math.min(hum.Health, 100)
        end
    end)
end

function _antiDieSetEnabled(enabled)
    enabled = enabled == true
    if enabled == _antiDieEnabled then return end
    if enabled then
        _antiDie.StartEngine()
    else
        _antiDie.StopEngine()
    end
end

function _antiDieRefresh()
    if _antiDieStopped then return end
    local manual = _antiDieSources.toggle
    _antiDieSetEnabled(manual or _antiDieSources.autobat)
end

_G.__CrystalAntiDieSource = function(source, enabled)
    if _antiDieStopped or _antiDieSources[source] == nil then return end
    _antiDieSources[source] = enabled == true
    _antiDieRefresh()
end

_G.__CrystalAntiDieSet = function(enabled)
    _G.__CrystalAntiDieSource("autobat", enabled)
end

_G.__CrystalAntiDieIsEnabled = function() return _antiDieEnabled end
_G.__CrystalAntiDieStop = function()
    _antiDieStopped = true
    _antiDieSources.toggle = false
    _antiDieSources.autobat = false
    _antiDieSetEnabled(false)
end

function activateOnCharacter(char)
    if not _antiDieEnabled then return end
    _antiDie.AttachHealth(char)
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if hum then _antiDie.SuperHeal(hum) end
end

AntiDieModule = {
    enabled = false,
    start = function()
        AntiDieModule.enabled = true
        antiDieEnabled = true
        _antiDieStopped = false
        _G.__CrystalAntiDieSource("toggle", true)
    end,
    stop = function()
        AntiDieModule.enabled = false
        antiDieEnabled = false
        _G.__CrystalAntiDieSource("toggle", false)
    end,
}
_G.AntiDie = AntiDieModule

local AntiBat = { Connection = nil }
local ANTIBAT_RANGE = 4000

function stopAntiBat()
    antiBatEnabled = false
    if AntiBat.Connection then
        AntiBat.Connection:Disconnect()
        AntiBat.Connection = nil
    end
    -- Desactivar source autobat del anti-die cuando se apaga el anti bate
    if _G.__CrystalAntiDieSource then
        pcall(_G.__CrystalAntiDieSource, "autobat", false)
    end
    -- Restaurar estados normales si el anti-die manual no está activo
    pcall(function()
        if _antiDieSources and not _antiDieSources.toggle then
            local char = LP and LP.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if hum then
                hum:SetStateEnabled(Enum.HumanoidStateType.Dead, true)
                hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, true)
                hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
                hum.BreakJointsOnDeath = true
            end
        end
    end)
end

function startAntiBat()
    stopAntiBat()
    antiBatEnabled = true
    -- Activar anti-die automáticamente cuando anti bate está prendido
    if _G.__CrystalAntiDieSource then
        pcall(_G.__CrystalAntiDieSource, "autobat", true)
    end

    AntiBat.Connection = RunService.Heartbeat:Connect(function()
        if not antiBatEnabled then return end
        local character = LP.Character
        if not character then return end
        local hrp = character:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        -- Proteger health antes de aplicar velocidades para evitar reset
        local hum = character:FindFirstChildOfClass("Humanoid")
        if hum then
            if hum.Health <= 0 then
                pcall(function()
                    hum.Health = hum.MaxHealth or 100
                    hum:ChangeState(Enum.HumanoidStateType.GettingUp)
                end)
                return
            end
            pcall(function()
                hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
                hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
                hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
                hum.BreakJointsOnDeath = false
            end)
        end
        local v = hrp.Velocity
        hrp.Velocity = Vector3.new(
            math.random(-ANTIBAT_RANGE, ANTIBAT_RANGE),
            v.Y,
            math.random(-ANTIBAT_RANGE, ANTIBAT_RANGE)
        )
        RunService.RenderStepped:Wait()
        if hrp and hrp.Parent then
            hrp.Velocity = v
        end
        -- Verificar health después de aplicar velocidades
        if hum and hum.Parent and hum.Health <= 0 then
            pcall(function()
                hum.Health = hum.MaxHealth or 100
                hum:ChangeState(Enum.HumanoidStateType.GettingUp)
            end)
        end
    end)
end

LP.CharacterAdded:Connect(function()
    task.wait(0.3)
    if antiBatEnabled then startAntiBat() end
end)

setAntiFlingVisual = nil

local _antiFlingState = {
    connection    = nil,
    threshold     = 80,
    spinThreshold = 40,
    maxUpSpeed    = 55,   -- clamp sky launches when hit
    maxDownSpeed  = 90,
}
local _ANTI_FLING_DRIVE_GRACE = 0.3

local function _afHubSpeedLive()
    local live = _G.__RivalHubLiveSpeed
    if type(live) ~= "table" then return false end
    local stamp, speed = tonumber(live.t), tonumber(live.v)
    if not stamp or not speed or speed <= 0 then return false end
    return (os.clock() - stamp) <= _ANTI_FLING_DRIVE_GRACE
end

local function _afOwnMoverActive()
    -- Own movers: only skip horizontal clamp, still clamp insane vertical launches
    if autoBatEnabled then return true end
    if autoLeftEnabled or autoRightEnabled then return true end
    return false
end

local function _afClampVelocity(root, preserveHorizontalDrive)
    local velocity = root.AssemblyLinearVelocity
    local y = velocity.Y
    local flat = Vector3.new(velocity.X, 0, velocity.Z)
    local changed = false

    -- Always kill sky-launch / extreme fall from bat hits
    if y > _antiFlingState.maxUpSpeed then
        y = _antiFlingState.maxUpSpeed * 0.35
        changed = true
    elseif y < -_antiFlingState.maxDownSpeed then
        y = -_antiFlingState.maxDownSpeed
        changed = true
    end

    if not preserveHorizontalDrive and flat.Magnitude > _antiFlingState.threshold then
        flat = Vector3.zero
        changed = true
    end

    if changed then
        pcall(function()
            root.AssemblyLinearVelocity = Vector3.new(flat.X, y, flat.Z)
            if root.AssemblyAngularVelocity.Magnitude > _antiFlingState.spinThreshold then
                root.AssemblyAngularVelocity = Vector3.zero
            end
        end)
        return true
    end

    if root.AssemblyAngularVelocity.Magnitude > _antiFlingState.spinThreshold then
        pcall(function() root.AssemblyAngularVelocity = Vector3.zero end)
    end
    return false
end

function startAntiFling()
    if _antiFlingState.connection then return end
    antiFlingEnabled = true
    _antiFlingState.connection = RunService.Heartbeat:Connect(function()
        if not antiFlingEnabled then return end
        local character = LP.Character
        if not character then return end
        local root = character:FindFirstChild("HumanoidRootPart")
        if not root then return end
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid and (humanoid.Health <= 0 or humanoid.SeatPart) then return end

        if dropActive or _G.IsDropping then return end
        if _afHubSpeedLive() then return end

        local ownDrive = _afOwnMoverActive()
        -- Even while bat aimbot is on: still clamp vertical launches from being hit
        _afClampVelocity(root, ownDrive)
    end)
end

function stopAntiFling()
    antiFlingEnabled = false
    if _antiFlingState.connection then
        _antiFlingState.connection:Disconnect()
        _antiFlingState.connection = nil
    end
end


-- Lightweight always-on sky-launch dampener (works even if Anti Fling toggle is off)
do
    local _skyConn = nil
    local function _startSkyDampener()
        if _skyConn then return end
        _skyConn = RunService.Heartbeat:Connect(function()
            local char = LP.Character
            if not char then return end
            local root = char:FindFirstChild("HumanoidRootPart")
            local hum = char:FindFirstChildOfClass("Humanoid")
            if not root or not hum or hum.Health <= 0 then return end
            if dropActive or _G.IsDropping then return end
            local v = root.AssemblyLinearVelocity
            -- Only intervene on extreme upward launches (typical bat fling)
            if v.Y > 70 then
                root.AssemblyLinearVelocity = Vector3.new(v.X * 0.35, math.clamp(v.Y * 0.25, -20, 28), v.Z * 0.35)
                if root.AssemblyAngularVelocity.Magnitude > 25 then
                    root.AssemblyAngularVelocity = Vector3.zero
                end
            end
        end)
    end
    _startSkyDampener()
    LP.CharacterAdded:Connect(function()
        task.wait(0.2)
        _startSkyDampener()
    end)
end

LP.CharacterAdded:Connect(function()
    task.wait(0.3)
    if antiFlingEnabled then startAntiFling() end
end)

local espEnabled = espEnabled or false
local espActivePlayers = {}
local espLoopConn = nil
local Camera = workspace.CurrentCamera
local GUI2_ESP_COLOR = Color3.fromRGB(139, 72, 246)
local GUI2_ESP_TEXT_STROKE = Color3.fromRGB(48, 16, 92)

local function getESPThemeColors(accent)
    local c = getThemeColor() or accent or Color3.fromRGB(245, 245, 250)
    return c, Color3.fromRGB(0, 0, 0)
end

local function createESP()
    local currentFill, currentLine = getESPThemeColors()
    local esp = {
        Tracer = Drawing and Drawing.new("Line") or nil,
        Highlight = Instance.new("Highlight"),
        Lines = {},
    }
    if esp.Tracer then
        esp.Tracer.Color = currentLine
        esp.Tracer.Thickness = 3
        esp.Tracer.Transparency = 1
        esp.Tracer.ZIndex = 2
    end

    esp.Highlight.Name = "RivalHubESP_Highlight"
    esp.Highlight.FillColor = currentFill
    esp.Highlight.OutlineColor = Color3.fromRGB(0, 0, 0)
    esp.Highlight.FillTransparency = 0.12
    esp.Highlight.OutlineTransparency = 0.18
    esp.Highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop

    local parentGui
    local ok, robGui = pcall(function() return game:GetService("CoreGui"):FindFirstChild("RobloxGui") end)
    if ok and robGui then parentGui = robGui else parentGui = LP:FindFirstChildOfClass("PlayerGui") end
    if not parentGui then parentGui = game:GetService("CoreGui") end
    pcall(function() esp.Highlight.Parent = parentGui end)

    local nameBillboard = Instance.new("BillboardGui")
    nameBillboard.Name = "RivalHubESP_Name"
    nameBillboard.Size = UDim2.new(0, 170, 0, 28)
    nameBillboard.StudsOffset = Vector3.new(0, 1.3, 0)
    nameBillboard.AlwaysOnTop = true
    nameBillboard.Parent = parentGui

    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(0, 170, 0, 28)
    nameLabel.AnchorPoint = Vector2.new(0.5, 0)
    nameLabel.Position = UDim2.new(0.5, 0, 0, 2)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = ""
    nameLabel.TextColor3 = getThemeColor()
    nameLabel.TextSize = 15
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    nameLabel.TextStrokeTransparency = 0
    nameLabel.TextXAlignment = Enum.TextXAlignment.Center
    nameLabel.TextYAlignment = Enum.TextYAlignment.Center
    nameLabel.ZIndex = 5
    nameLabel.Parent = nameBillboard

    local nameOutline = Instance.new("UIStroke")
    nameOutline.Color = Color3.fromRGB(0, 0, 0)
    nameOutline.Thickness = 2.2
    nameOutline.Transparency = 0.12
    nameOutline.Parent = nameLabel

    if Drawing then
        for i = 1, 14 do
            local line = Drawing.new("Line")
            line.Color = currentLine
            line.Thickness = 2
            line.Transparency = 1
            line.ZIndex = 3
            table.insert(esp.Lines, line)
        end
    end

    esp.NameTag = nameBillboard
    esp.NameLabel = nameLabel
    esp.NameOutline = nameOutline
    return esp
end

_G.__RivalHubRefreshESPTheme = function(accent, outlineColor)
    local fillColor, lineColor = getESPThemeColors(accent)
    for _, data in pairs(espActivePlayers) do
        if type(data) == "table" and data.esp then
            local esp = data.esp
            if esp.Tracer then pcall(function() esp.Tracer.Color = lineColor end) end
            if esp.Highlight then
                esp.Highlight.FillColor = fillColor
                esp.Highlight.OutlineColor = Color3.fromRGB(0, 0, 0)
            end
            if esp.NameLabel then
                esp.NameLabel.TextColor3 = getThemeColor()
                esp.NameLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
            end
            if esp.NameOutline then esp.NameOutline.Color = Color3.fromRGB(0, 0, 0) end
            for _, line in ipairs(esp.Lines or {}) do pcall(function() line.Color = lineColor end) end
        end
    end
end

local function removeESP(plr)
    local data = espActivePlayers[plr]
    if data then
        if data.esp.Tracer then pcall(function() data.esp.Tracer:Remove() end) end
        if data.esp.Highlight then pcall(function() data.esp.Highlight:Destroy() end) end
        if data.esp.NameTag then pcall(function() data.esp.NameTag:Destroy() end) end
        for _, line in ipairs(data.esp.Lines) do
            pcall(function() line:Remove() end)
        end
        espActivePlayers[plr] = nil
    end
end

local function updateESP(plr, esp)
    if not espEnabled then
        if esp.Tracer then esp.Tracer.Visible = false end
        esp.Highlight.Enabled = false
        for _, line in ipairs(esp.Lines) do line.Visible = false end
        if esp.NameTag then esp.NameTag.Enabled = false end
        return
    end

    local character = plr.Character
    local hum = character and character:FindFirstChildOfClass("Humanoid")
    local trackPart = character and (
        character:FindFirstChild("HumanoidRootPart")
        or character.PrimaryPart
        or character:FindFirstChild("UpperTorso")
        or character:FindFirstChild("Torso")
        or character:FindFirstChild("Head")
    )

    if character and trackPart and (not hum or hum.Health > 0) then
        esp.Highlight.Adornee = character
        esp.Highlight.Enabled = espEnabled
        if esp.Tracer then esp.Tracer.Visible = false end
        for _, line in ipairs(esp.Lines) do line.Visible = false end

        if esp.NameTag and esp.NameLabel then
            pcall(function()
                esp.NameTag.Adornee = trackPart
                esp.NameTag.Enabled = espEnabled
                esp.NameLabel.Text = plr.Name or plr.DisplayName or ""
                esp.NameLabel.TextColor3 = getThemeColor()
            end)
        end
    else
        if esp.Tracer then esp.Tracer.Visible = false end
        esp.Highlight.Enabled = false
        esp.Highlight.Adornee = nil
        for _, line in ipairs(esp.Lines) do line.Visible = false end
        if esp.NameTag then esp.NameTag.Enabled = false end
    end
end

local function createESPForPlayer(plr)
    if plr == LP then return end
    if espActivePlayers[plr] and espActivePlayers[plr].esp then
        if espActivePlayers[plr].esp.NameTag then
            pcall(function() espActivePlayers[plr].esp.NameTag.Enabled = espEnabled end)
        end
        return
    end
    removeESP(plr)
    local esp = createESP()
    espActivePlayers[plr] = { esp = esp }
end

local espJoinConn, espLeaveConn
local function enableESP()
    if espEnabled then return end
    espEnabled = true
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LP then task.spawn(function() createESPForPlayer(plr) end) end
    end
    local espAccumulator = 0
    if espLoopConn then espLoopConn:Disconnect() end
    espLoopConn = RunService.Heartbeat:Connect(function(dt)
        espAccumulator = espAccumulator + (dt or 0)
        if espAccumulator < 0.15 then return end
        espAccumulator = 0
        for plr, data in pairs(espActivePlayers) do
            if typeof(plr) == "Instance" and plr:IsA("Player") and data and data.esp then
                pcall(function() updateESP(plr, data.esp) end)
            end
        end
    end)
    espJoinConn = Players.PlayerAdded:Connect(function(plr)
        if not espEnabled or plr == LP then return end
        task.wait(0.3)
        createESPForPlayer(plr)
    end)
    espLeaveConn = Players.PlayerRemoving:Connect(function(plr) removeESP(plr) end)
end

local function disableESP()
    espEnabled = false
    if espLoopConn then espLoopConn:Disconnect(); espLoopConn = nil end
    if espJoinConn then pcall(function() espJoinConn:Disconnect() end); espJoinConn = nil end
    if espLeaveConn then pcall(function() espLeaveConn:Disconnect() end); espLeaveConn = nil end
    for plr in pairs(espActivePlayers) do
        if typeof(plr) == "Instance" and plr:IsA("Player") and plr ~= LP then removeESP(plr) end
    end
end

function toggleESP(on)
    if on then enableESP() else disableESP() end
    if setESPVIsual then setESPVIsual(on) end
end

local _espLineGui = nil
local _espLineFrame = nil
local _espLineOutline = nil
local _espLineConn = nil
local _espLineState = { scanElapsed = math.huge, targetRoot = nil }

local function ensureESPLineGui()
    if _espLineGui and _espLineGui.Parent then return end
    _espLineGui = Instance.new("ScreenGui")
    _espLineGui.Name = "RivalHubESPLine"
    _espLineGui.IgnoreGuiInset = true
    _espLineGui.ResetOnSpawn = false
    _espLineGui.DisplayOrder = 1000
    _espLineGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    local okP = pcall(function() _espLineGui.Parent = game:GetService("CoreGui") end)
    if not okP then _espLineGui.Parent = LP:WaitForChild("PlayerGui") end

    _espLineFrame = Instance.new("Frame")
    _espLineFrame.Name = "ESPLine"
    _espLineFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    _espLineFrame.BorderSizePixel = 0
    _espLineFrame.Active = false
    _espLineFrame.Visible = false
    _espLineFrame.BackgroundColor3 = getThemeColor()
    _espLineFrame.ZIndex = 1
    _espLineFrame.Parent = _espLineGui

    _espLineOutline = Instance.new("UIStroke", _espLineFrame)
    _espLineOutline.Color = Color3.fromRGB(255, 255, 255)
    _espLineOutline.Thickness = 0.7
    _espLineOutline.Transparency = 0.45
end

function stopESPLine()
    espLineEnabled = false
    if _espLineConn then _espLineConn:Disconnect(); _espLineConn = nil end
    if _espLineFrame then _espLineFrame.Visible = false end
    _espLineState.targetRoot = nil
    _espLineState.scanElapsed = math.huge
    if _espLineGui and _espLineGui.Parent then
        pcall(function() _espLineGui:Destroy() end)
    end
    _espLineGui = nil
    _espLineFrame = nil
    _espLineOutline = nil
end

function startESPLine()
    espLineEnabled = true
    ensureESPLineGui()
    if _espLineConn then _espLineConn:Disconnect() end
    _espLineState.scanElapsed = math.huge
    _espLineState.targetRoot = nil

    _espLineConn = RunService.RenderStepped:Connect(function(dt)
        if not espLineEnabled then
            if _espLineFrame then _espLineFrame.Visible = false end
            return
        end
        local ok = pcall(function()
            local activeCamera = workspace.CurrentCamera
            local myChar = LP.Character
            local myRoot = myChar and (myChar:FindFirstChild("LowerTorso") or myChar:FindFirstChild("HumanoidRootPart") or myChar:FindFirstChild("Torso"))
            if not activeCamera or not myRoot then
                if _espLineFrame then _espLineFrame.Visible = false end
                return
            end

            local myPosition = myRoot.Position
            _espLineState.scanElapsed = _espLineState.scanElapsed + (dt or 0)
            local cachedRoot = _espLineState.targetRoot
            local cachedCharacter = cachedRoot and cachedRoot.Parent
            local cachedHumanoid = cachedCharacter and cachedCharacter:FindFirstChildOfClass("Humanoid")
            local cachedValid = cachedRoot and cachedRoot.Parent and (not cachedHumanoid or cachedHumanoid.Health > 0)
            if _espLineState.scanElapsed >= 0.12 or not cachedValid then
                _espLineState.scanElapsed = 0
                local closestRoot, closestDistanceSq = nil, math.huge
                for _, otherPlayer in ipairs(Players:GetPlayers()) do
                    if otherPlayer ~= LP then
                        local character = otherPlayer.Character
                        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
                        local root = character and (character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("LowerTorso") or character:FindFirstChild("Torso"))
                        if root and root:IsA("BasePart") and (not humanoid or humanoid.Health > 0) then
                            local delta = root.Position - myPosition
                            local distanceSq = delta:Dot(delta)
                            if distanceSq < closestDistanceSq then
                                closestRoot, closestDistanceSq = root, distanceSq
                            end
                        end
                    end
                end
                _espLineState.targetRoot = closestRoot
            end

            local closestRoot = _espLineState.targetRoot
            if not closestRoot or not closestRoot.Parent then
                if _espLineFrame then _espLineFrame.Visible = false end
                return
            end
            local closestPosition = closestRoot.Position

            local from = activeCamera:WorldToViewportPoint(myPosition - Vector3.new(0, myRoot.Size.Y * 0.35, 0))
            local to, targetOnScreen = activeCamera:WorldToViewportPoint(closestPosition)
            local viewport = activeCamera.ViewportSize
            local fromPoint = Vector2.new(from.X, from.Y)
            local targetPoint = Vector2.new(to.X, to.Y)

            if not targetOnScreen or to.Z <= 0 then
                local center = viewport * 0.5
                local direction = targetPoint - center
                if to.Z <= 0 then direction = -direction end
                if direction.Magnitude < 0.001 then direction = Vector2.new(0, -1) end
                local limit = Vector2.new(math.max(8, center.X - 8), math.max(8, center.Y - 8))
                local scaleX = limit.X / math.max(math.abs(direction.X), 0.001)
                local scaleY = limit.Y / math.max(math.abs(direction.Y), 0.001)
                targetPoint = center + direction * math.min(scaleX, scaleY)
            end

            if from.Z <= 0 or fromPoint.X < 0 or fromPoint.X > viewport.X or fromPoint.Y < 0 or fromPoint.Y > viewport.Y then
                fromPoint = Vector2.new(viewport.X * 0.5, viewport.Y - 8)
            end

            local delta = targetPoint - fromPoint
            local midpoint = (fromPoint + targetPoint) * 0.5
            _espLineFrame.Position = UDim2.fromOffset(midpoint.X, midpoint.Y)
            _espLineFrame.Size = UDim2.fromOffset(math.max(delta.Magnitude, 1), 2)
            _espLineFrame.Rotation = math.deg(math.atan2(delta.Y, delta.X))
            _espLineFrame.BackgroundColor3 = getThemeColor()
            _espLineFrame.Visible = true
        end)
        if not ok and _espLineFrame then
            pcall(function() _espLineFrame.Visible = false end)
        end
    end)
end

local _enemySpeedAcc = 0
function updateEnemySpeedLabels()
    _enemySpeedAcc = _enemySpeedAcc + 1
    if _enemySpeedAcc < 6 then return end
    _enemySpeedAcc = 0
    local color = getThemeColor()
    local players = _GetPlayersCached()
    for i = 1, #players do
        local player = players[i]
        if player ~= LP then
            local char = player.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if hrp and hum and hum.Health > 0 then
                local v = hrp.AssemblyLinearVelocity
                local speed = _sqrt(v.X*v.X + v.Z*v.Z)
                local label = enemySpeedLabels[player]
                if not label then
                    local head = char:FindFirstChild("Head")
                    if head then
                        local bb = Instance.new("BillboardGui")
                        bb.Size = UDim2.new(0, 100, 0, 25)
                        bb.StudsOffset = _V3new(0, 5.5, 0)
                        bb.AlwaysOnTop = true
                        bb.Name = "EnemySpeedGui"
                        bb.Parent = head
                        local tl = Instance.new("TextLabel", bb)
                        tl.Size = UDim2.new(1, 0, 1, 0)
                        tl.BackgroundTransparency = 1
                        tl.TextColor3 = color
                        tl.Font = Enum.Font.GothamBold
                        tl.TextScaled = true
                        tl.TextStrokeTransparency = 0
                        tl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                        enemySpeedLabels[player] = tl
                        label = tl
                    end
                elseif label.Parent and label.Parent.Parent ~= char then
                    local head = char:FindFirstChild("Head")
                    if head then label.Parent.Parent = head end
                end
                if label then
                    label.Text = string.format("%.1f", speed)
                    if label.TextColor3 ~= color then label.TextColor3 = color end
                end
            else
                local label = enemySpeedLabels[player]
                if label and label.Parent and label.Parent.Parent then label.Parent.Parent = nil end
                enemySpeedLabels[player] = nil
            end
        end
    end
end

function startEnemySpeed()
    if enemySpeedConn then enemySpeedConn:Disconnect() end
    enemySpeedConn = RunService.Heartbeat:Connect(updateEnemySpeedLabels)
end

function stopEnemySpeed()
    if enemySpeedConn then enemySpeedConn:Disconnect(); enemySpeedConn = nil end
end

local function getClosestTargetBody()
    local char = LP.Character
    if not char then return nil end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return nil end
    local rpos = root.Position
    local closest, minDist = nil, _huge
    local plist = _GetPlayersCached()
    for i = 1, #plist do
        local plr = plist[i]
        if plr ~= LP then
            local c = plr.Character
            if c then
                local tRoot = c:FindFirstChild("HumanoidRootPart")
                if tRoot then
                    local hum = c:FindFirstChildOfClass("Humanoid")
                    if hum and hum.Health > 0 then
                        local dx = tRoot.Position.X - rpos.X
                        local dy = tRoot.Position.Y - rpos.Y
                        local dz = tRoot.Position.Z - rpos.Z
                        local d = dx*dx + dy*dy + dz*dz
                        if d < minDist then minDist = d; closest = tRoot end
                    end
                end
            end
        end
    end
    return closest
end

local function _bodyLockTick()
    local char = LP.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    local target = getClosestTargetBody()
    if not target then
        if not hum.AutoRotate then hum.AutoRotate = true end
        return
    end
    local dist = (target.Position - root.Position).Magnitude
    if dist > bodyLockRange then
        if not hum.AutoRotate then hum.AutoRotate = true end
        return
    end
    if hum.AutoRotate then hum.AutoRotate = false end
    local targetVel = target.AssemblyLinearVelocity
    local speed3 = targetVel.Magnitude
    local predictTime = _clamp(speed3 / 80, 0.08, 0.35)
    local predictedPos = target.Position + targetVel * predictTime
    local targetHead = target.Parent and target.Parent:FindFirstChild("Head")
    local targetHeight = targetHead and targetHead.Position.Y or target.Position.Y
    local myHeight = root.Position.Y + (hum.HipHeight or 0)
    local heightDiff = targetHeight - myHeight
    local verticalCorrection = _clamp(heightDiff * 0.15, -1.5, 1.5)
    local flatTarget = _V3new(predictedPos.X, root.Position.Y + verticalCorrection, predictedPos.Z)
    local toPredict = flatTarget - root.Position
    if toPredict.Magnitude > 0.1 then
        local goalCF = _CFlookAt(root.Position, flatTarget)
        local diffCF = root.CFrame:Inverse() * goalCF
        local _, ry, _ = diffCF:ToEulerAnglesXYZ()
        ry = _clamp(ry, -2.5, 2.5)
        root.AssemblyAngularVelocity = root.CFrame:VectorToWorldSpace(_V3new(0, ry * 42, 0))
    end
end

function startBodyLock()
    if _bodyLockConn then _bodyLockConn:Disconnect() end
    local acc = 0
    _bodyLockConn = RunService.Heartbeat:Connect(function(dt)
        if not bodyLockEnabled then return end
        if _blSuppressCount > 0 then return end
        acc = acc + dt
        if acc < 0.033 then return end
        acc = 0
        _bodyLockTick()
    end)
end

function stopBodyLock()
    if _bodyLockConn then
        _bodyLockConn:Disconnect()
        _bodyLockConn = nil
    end
    local c = LP.Character
    local root = c and c:FindFirstChild("HumanoidRootPart")
    if root then
        root.AssemblyAngularVelocity = _V3zero
        root.AssemblyLinearVelocity = _V3new(root.AssemblyLinearVelocity.X, -0.1, root.AssemblyLinearVelocity.Z)
    end
    local hum2 = c and c:FindFirstChildOfClass("Humanoid")
    if hum2 then hum2.AutoRotate = true end
end

function _suppressBodyLock()
    _blSuppressCount = _blSuppressCount + 1
    if _blSuppressCount == 1 and bodyLockEnabled then
        _blWasEnabled = true
        stopBodyLock()
        if bodyLockSetVisual then bodyLockSetVisual(false) end
        if _blRestoreTimer then
            task.cancel(_blRestoreTimer)
            _blRestoreTimer = nil
        end
        _blSmoothRestore = false
    end
end

function _unsuppressBodyLock(delayed)
    if _blSuppressCount > 0 then
        _blSuppressCount = _blSuppressCount - 1
    end
    if _blSuppressCount == 0 and _blWasEnabled then
        _blWasEnabled = false
        if _blRestoreTimer then
            pcall(task.cancel, _blRestoreTimer)
            _blRestoreTimer = nil
        end
        local function restore()
            _blRestoreTimer = nil
            if bodyLockEnabled then
                _blSmoothRestore = true
                startBodyLock()
                if bodyLockSetVisual then bodyLockSetVisual(true) end
                task.delay(0.5, function() _blSmoothRestore = false end)
            end
        end
        if delayed then
            _blRestoreTimer = task.delay(1, restore)
        else
            restore()
        end
    end
end

function setupSpeedIndicator(char)
    local head = char:WaitForChild("Head", 5)
    if not head then return end
    for _, name in ipairs({"RivalHubSpeedIndicator", "DiscordText", "RivalHubDiscordTag"}) do
        local old = head:FindFirstChild(name)
        if old then old:Destroy() end
    end
    speedLabel = nil
    local bb = Instance.new("BillboardGui", head)
    bb.Name = "RivalHubSpeedIndicator"
    bb.Size = UDim2.fromOffset(136, 28)
    bb.StudsOffset = Vector3.new(0, 3.5, 0)
    bb.AlwaysOnTop = true
    bb.LightInfluence = 0
    bb.MaxDistance = 0
    bb.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    local card = Instance.new("Frame", bb)
    card.Name = "SpeedCard"
    card.Size = UDim2.fromScale(1, 1)
    card.BackgroundColor3 = Color3.fromRGB(10, 14, 19)
    card.BackgroundTransparency = 0.2
    card.BorderSizePixel = 0
    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 8)
    local border = Instance.new("UIStroke", card)
    border.Color = getThemeColor()
    border.Transparency = 0.62
    border.Thickness = 1
    ScreamUI.speedStroke = border
    speedLabel = Instance.new("TextLabel", card)
    speedLabel.Name = "SpeedLabel"
    speedLabel.Size = UDim2.new(1, -12, 1, 0)
    speedLabel.Position = UDim2.fromOffset(6, 0)
    speedLabel.BackgroundTransparency = 1
    speedLabel.Text = string.format("VELOCIDAD: %.1f", getActiveMoveSpeed())
    speedLabel.TextColor3 = Color3.fromRGB(190, 190, 198)
    speedLabel.TextStrokeColor3 = Color3.fromRGB(15, 13, 13)
    speedLabel.TextStrokeTransparency = 0.4
    speedLabel.Font = Enum.Font.GothamMedium
    speedLabel.TextSize = 11
    speedLabel.TextXAlignment = Enum.TextXAlignment.Center
    speedLabel.ZIndex = 3
    local tag = Instance.new("BillboardGui", head)
    tag.Name = "RivalHubDiscordTag"
    tag.Size = UDim2.fromOffset(210, 24)
    tag.StudsOffset = Vector3.new(0, 5.1, 0)
    tag.AlwaysOnTop = true
    tag.LightInfluence = 0
    tag.MaxDistance = 0
    local text = Instance.new("TextLabel", tag)
    text.Size = UDim2.fromScale(1, 1)
    text.BackgroundTransparency = 1
    text.Text = "discord.gg/RY84KrvjtY"
    text.TextColor3 = getThemeColor()
    text.TextStrokeColor3 = Color3.fromRGB(5, 7, 10)
    text.TextStrokeTransparency = 0.2
    text.Font = Enum.Font.GothamBold
    text.TextSize = 15
    ScreamUI.discordLabel = text

end

local unwalkSavedAnimate = nil

function startUnwalk()
    local c = LP.Character
    if not c then return end
    local hum = c:FindFirstChildOfClass("Humanoid")
    if hum then
        for _, t in ipairs(hum:GetPlayingAnimationTracks()) do pcall(function() t:Stop() end) end
    end
    local anim = c:FindFirstChild("Animate")
    if anim then
        unwalkSavedAnimate = anim:Clone()
        anim:Destroy()
    end
end

function stopUnwalk()
    local c = LP.Character
    if c then
        local existing = c:FindFirstChild("Animate")
        if not existing then
            local src = game:GetService("StarterPlayer"):FindFirstChildOfClass("StarterCharacterScripts")
            local starterAnim = src and src:FindFirstChild("Animate")
            if starterAnim then
                starterAnim:Clone().Parent = c
            elseif unwalkSavedAnimate then
                unwalkSavedAnimate:Clone().Parent = c
            end
        end
    end
    unwalkSavedAnimate = nil
end

function refreshSpeedModeLabel()
    if modeValLbl then
        if laggerCarryToggled then modeValLbl.Text = "Lagger Carry"
        elseif laggerToggled then modeValLbl.Text = "Lagger Normal"
        elseif speedMode then modeValLbl.Text = "Carry"
        else modeValLbl.Text = "Normal" end
    end
    if setCarryModeVisual then setCarryModeVisual(speedMode) end
    if setLaggerModeVisual then setLaggerModeVisual(laggerToggled) end
    if setLaggerCarryVisual then setLaggerCarryVisual(laggerCarryToggled) end
end

function resetMovementState()
    refreshSpeedModeLabel()
    if mobSetCarry then mobSetCarry(speedMode) end
    if mobSetLagger1 then mobSetLagger1(laggerToggled) end
    if mobSetLagger2 then mobSetLagger2(laggerCarryToggled) end
    if setLaggerModeVisual then setLaggerModeVisual(laggerToggled) end
    if setLaggerCarryVisual then setLaggerCarryVisual(laggerCarryToggled) end
end

function toggleCarryMode()
    if laggerToggled or laggerCarryToggled then
        laggerToggled = false; laggerCarryToggled = false; speedMode = true
    else speedMode = not speedMode end
    resetMovementState()
    if _G.__RivalHubApplySpeedNow then pcall(_G.__RivalHubApplySpeedNow) end
end

function toggleLaggerMode()
    if laggerCarryToggled then laggerCarryToggled = false end
    speedMode = false; laggerToggled = not laggerToggled
    resetMovementState()
    if _G.__RivalHubApplySpeedNow then pcall(_G.__RivalHubApplySpeedNow) end
end
function toggleLaggerCarryMode()
    if laggerToggled then laggerToggled = false end
    speedMode = false; laggerCarryToggled = not laggerCarryToggled
    resetMovementState()
    if _G.__RivalHubApplySpeedNow then pcall(_G.__RivalHubApplySpeedNow) end
end

function toggleLaggerCycle()
    if speedMode then
        speedMode = false
        laggerToggled = true
        laggerCarryToggled = false
    elseif laggerToggled then
        speedMode = false
        laggerToggled = false
        laggerCarryToggled = true
    else
        speedMode = true
        laggerToggled = false
        laggerCarryToggled = false
    end
    resetMovementState()
    if _G.__RivalHubApplySpeedNow then pcall(_G.__RivalHubApplySpeedNow) end
end

function stopAutoLeft()
    if alConn then alConn:Disconnect(); alConn = nil end
    alPhase = 1
    local char = LP.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then hum:Move(_V3zero, false) end
    end
    if autoLeftSetVisual then autoLeftSetVisual(false) end
    if mobSetAutoLeft then mobSetAutoLeft(false) end
    _unsuppressBodyLock(true)
end

function startAutoLeft()
    if autoRightEnabled then
        autoRightEnabled = false
        stopAutoRight()
        if autoRightSetVisual then autoRightSetVisual(false) end
        if mobSetAutoRight then mobSetAutoRight(false) end
    end
    -- Do not kill bat aimbot / other features
    _suppressBodyLock()
    if alConn then alConn:Disconnect() end
    alPhase = 1
    alConn = RunService.Heartbeat:Connect(function()
        if not autoLeftEnabled then return end
        local char = LP.Character
        if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not root or not hum then return end
        local spd = NS
        if alPhase == 1 then
            local tgt = _V3new(AP.L1.X, root.Position.Y, AP.L1.Z)
            if (tgt - root.Position).Magnitude < 1 then
                alPhase = 2
                local d = AP.L2 - root.Position
                local mv = _V3new(d.X, 0, d.Z).Unit
                hum:Move(mv, false)
                root.AssemblyLinearVelocity = _V3new(mv.X * spd, root.AssemblyLinearVelocity.Y, mv.Z * spd)
                return
            end
            local d = AP.L1 - root.Position
            local mv = _V3new(d.X, 0, d.Z).Unit
            hum:Move(mv, false)
            root.AssemblyLinearVelocity = _V3new(mv.X * spd, root.AssemblyLinearVelocity.Y, mv.Z * spd)
        elseif alPhase == 2 then
            local tgt = _V3new(AP.L2.X, root.Position.Y, AP.L2.Z)
            if (tgt - root.Position).Magnitude < 1 then
                hum:Move(_V3zero, false)
                root.AssemblyLinearVelocity = _V3zero
                autoLeftEnabled = false
                if alConn then alConn:Disconnect(); alConn = nil end
                alPhase = 1
                if autoLeftSetVisual then autoLeftSetVisual(false) end
                if mobSetAutoLeft then mobSetAutoLeft(false) end
                _unsuppressBodyLock(true)
                local facePos = _V3new(AP.L_FACE.X, root.Position.Y, AP.L_FACE.Z)
                if (facePos - root.Position).Magnitude > 0.01 then
                    root.CFrame = _CFnew(root.Position, facePos)
                end
                return
            end
            local d = AP.L2 - root.Position
            local mv = _V3new(d.X, 0, d.Z).Unit
            hum:Move(mv, false)
            root.AssemblyLinearVelocity = _V3new(mv.X * spd, root.AssemblyLinearVelocity.Y, mv.Z * spd)
        end
    end)
end

function stopAutoRight()
    if arConn then arConn:Disconnect(); arConn = nil end
    arPhase = 1
    local char = LP.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then hum:Move(_V3zero, false) end
    end
    if autoRightSetVisual then autoRightSetVisual(false) end
    if mobSetAutoRight then mobSetAutoRight(false) end
    _unsuppressBodyLock(true)
end

function startAutoRight()
    if autoLeftEnabled then
        autoLeftEnabled = false
        stopAutoLeft()
        if autoLeftSetVisual then autoLeftSetVisual(false) end
        if mobSetAutoLeft then mobSetAutoLeft(false) end
    end
    -- Do not kill bat aimbot / other features
    _suppressBodyLock()
    if arConn then arConn:Disconnect() end
    arPhase = 1
    arConn = RunService.Heartbeat:Connect(function()
        if not autoRightEnabled then return end
        local char = LP.Character
        if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not root or not hum then return end
        local spd = NS
        if arPhase == 1 then
            local tgt = _V3new(AP.R1.X, root.Position.Y, AP.R1.Z)
            if (tgt - root.Position).Magnitude < 1 then
                arPhase = 2
                local d = AP.R2 - root.Position
                local mv = _V3new(d.X, 0, d.Z).Unit
                hum:Move(mv, false)
                root.AssemblyLinearVelocity = _V3new(mv.X * spd, root.AssemblyLinearVelocity.Y, mv.Z * spd)
                return
            end
            local d = AP.R1 - root.Position
            local mv = _V3new(d.X, 0, d.Z).Unit
            hum:Move(mv, false)
            root.AssemblyLinearVelocity = _V3new(mv.X * spd, root.AssemblyLinearVelocity.Y, mv.Z * spd)
        elseif arPhase == 2 then
            local tgt = _V3new(AP.R2.X, root.Position.Y, AP.R2.Z)
            if (tgt - root.Position).Magnitude < 1 then
                hum:Move(_V3zero, false)
                root.AssemblyLinearVelocity = _V3zero
                autoRightEnabled = false
                if arConn then arConn:Disconnect(); arConn = nil end
                arPhase = 1
                if autoRightSetVisual then autoRightSetVisual(false) end
                if mobSetAutoRight then mobSetAutoRight(false) end
                _unsuppressBodyLock(true)
                local facePos = _V3new(AP.R_FACE.X, root.Position.Y, AP.R_FACE.Z)
                if (facePos - root.Position).Magnitude > 0.01 then
                    root.CFrame = _CFnew(root.Position, facePos)
                end
                return
            end
            local d = AP.R2 - root.Position
            local mv = _V3new(d.X, 0, d.Z).Unit
            hum:Move(mv, false)
            root.AssemblyLinearVelocity = _V3new(mv.X * spd, root.AssemblyLinearVelocity.Y, mv.Z * spd)
        end
    end)
end

function getClosestTarget()
    local char = LP.Character
    if not char then return nil end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return nil end
    local rpos = root.Position
    local closest, minDist = nil, _huge
    local plist = _GetPlayersCached()
    for i = 1, #plist do
        local plr = plist[i]
        if plr ~= LP then
            local c = plr.Character
            if c then
                local tRoot = c:FindFirstChild("HumanoidRootPart")
                if tRoot then
                    local hum = c:FindFirstChildOfClass("Humanoid")
                    if hum and hum.Health > 0 then
                        local dx = tRoot.Position.X - rpos.X
                        local dy = tRoot.Position.Y - rpos.Y
                        local dz = tRoot.Position.Z - rpos.Z
                        local d = dx*dx + dy*dy + dz*dz
                        if d < minDist then minDist = d; closest = tRoot end
                    end
                end
            end
        end
    end
    return closest
end

function trySwing()
    pcall(function()
        local char = LP.Character
        if not char then return end
        local currentTool = char:FindFirstChildOfClass("Tool")
        if currentTool and not isBatTool(currentTool) then return end
        local bat = findBat()
        if bat then
            if bat.Parent ~= char then
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum then pcall(function() hum:EquipTool(bat) end) end
            end
            pcall(function() bat:Activate() end)
        end
    end)
end

-- ==================== BAT AIMBOT (Cypher predictive) ====================
do
    local CypherCircleTable = {
    predictionSphere = nil,
    targetPlayer = nil,
    lastTargetPos = nil,
    targetVelocity = Vector3.new(0,0,0),
    smoothedVelocity = Vector3.new(0,0,0),
    velocityHistory = {},
    MAX_HISTORY = 8,
    airborneTime = 0,
    lastActivationTime = 0,
    highYVelocityTime = 0,
    pingHistory = {},
    currentPing = 0.1,
    accelerationHistory = {},
    MAX_ACCEL_HISTORY = 4,
    lastDirectionChangeTime = 0,
    previousDirection = nil,
    wasAirborne = false,
    aerialVelocityHistory = {},
    MAX_AERIAL_HISTORY = 6,
    aerialSmoothVelocity = Vector3.new(0,0,0),
    lastYVelocity = 0,
    peakHeight = 0,
    groundHeight = 0,
    lastJumpTime = 0,
    isMultiJumping = false,
    verticalVelocityHistory = {},
    MAX_VERTICAL_HISTORY = 5,
    lastGroundedPosition = nil,
    realPingMs = 0,
    }
    local CypherConfig = {
    FOLLOW_SPEED = 55,
    ACTIVATE_DISTANCE = 13,
    MIN_FOLLOW_DISTANCE = 1,
    PREDICTION_TIME = 0.22,
    PREDICT_AHEAD = 3,
    JUMP_SPEED_BOOST = 1.5,
    JUMP_THRESHOLD = 8,
    MAX_SPEED = 59,
    ACTIVATION_DELAY = 0.2,
    AIRBORNE_THRESHOLD = 0.15,
    FLOAT_Y_THRESHOLD = 3,
    FALLING_THRESHOLD = -8,
    RISING_THRESHOLD = 8,
    VERTICAL_OFFSET_MULTIPLIER = 0.15,
    JUMPBOOST_Y_THRESHOLD = 35,
    EXTREME_JUMPBOOST_THRESHOLD = 50,
    JUMPBOOST_SUSTAINED_TIME = 0.15,
    MAX_VELOCITY_CHANGE = 150,
    VELOCITY_SMOOTHING = 0.2,
    MAX_HORIZONTAL_VELOCITY = 80,
    ERRATIC_MOVEMENT_THRESHOLD = 3,
    SERVER_TICKRATE = 1/60,
    PING_SAMPLE_SIZE = 10,
    MIN_PING_COMPENSATION = 0.03,
    MAX_PING_COMPENSATION = 0.25,
    ACCELERATION_PREDICTION_WEIGHT = 0.3,
    DIRECTION_CHANGE_DETECTION_TIME = 0.12,
    QUICK_DIRECTION_CHANGE_MULTIPLIER = 1.5,
    GRAVITY = 196.2,
    AIR_CONTROL_FACTOR = 0.8,
    AERIAL_VELOCITY_DECAY = 0.95,
    AERIAL_DIRECTION_CHANGE_WEIGHT = 0.6,
    MIN_AIRBORNE_TIME = 0.08,
    AERIAL_SMOOTHING = 0.15,
    PEAK_JUMP_THRESHOLD = 3,
    AERIAL_PREDICTION_BOOST = 1.2,
    STRAFE_DETECTION_THRESHOLD = 0.7,
    HIGH_JUMP_THRESHOLD = 20,
    FALLING_SPEED_THRESHOLD = -15,
    GRAVITY_PREDICTION_WEIGHT = 1.0,
    MULTI_JUMP_DETECTION_WINDOW = 0.2,
    UPWARD_VELOCITY_RESET_THRESHOLD = 10,
    VERTICAL_POSITION_LEAD = 2.5,
    FALLING_VERTICAL_LEAD = 3.5,
    SPHERE_SMOOTH_SPEED = 15,
    }
    local CFG = CypherConfig
    local C = CypherCircleTable
    local Player = LP
    local Stats = game:GetService("Stats")
    local aimbotEnabled = false
    local _pingRun = 0
    local function getBatSpeed()
        return tonumber(State and State.bypassBatSpeed) or tonumber(BYPASS_AIMBOT_SPEED) or CFG.FOLLOW_SPEED
    end

    local function sampleRealPing()
    local ok,val = pcall(function() return Player.Ping end)
    if ok and type(val)=="number" and val>0 then C.realPingMs = val; return end
    local ok2,val2 = pcall(function() return Stats.Network.ServerStatsItem["Data Ping"]:GetValue() end)
    if ok2 and type(val2)=="number" then C.realPingMs = math.floor(val2); return end
    end
    local function updatePing()
    local pingSeconds = C.realPingMs/1000
    table.insert(C.pingHistory, pingSeconds)
    if #C.pingHistory > CFG.PING_SAMPLE_SIZE then table.remove(C.pingHistory,1) end
    local sum = 0; for _,p in ipairs(C.pingHistory) do sum = sum + p end
    C.currentPing = sum / #C.pingHistory
    C.currentPing = math.clamp(C.currentPing, CFG.MIN_PING_COMPENSATION, CFG.MAX_PING_COMPENSATION)
    end

    local function getNearestPlayer()
    local char = Player.Character; if not char then return nil end
    local root = char:FindFirstChild("HumanoidRootPart"); if not root then return nil end
    local myPos = root.Position; local nearestDist = math.huge; local nearestPlayer = nil
    for _,p in ipairs(Players:GetPlayers()) do
    if p ~= LP and p.Character then
    local otherRoot = p.Character:FindFirstChild("HumanoidRootPart")
    if otherRoot then local dist = (myPos - otherRoot.Position).Magnitude; if dist < nearestDist then nearestDist = dist; nearestPlayer = p end end
    end
    end
    return nearestPlayer
    end

    local function getAverageVelocity()
    if #C.velocityHistory == 0 then return Vector3.new(0,0,0) end
    local sum = Vector3.new(0,0,0)
    for _,vel in ipairs(C.velocityHistory) do sum = sum + vel end
    return sum / #C.velocityHistory
    end

    local function getAverageAcceleration()
    if #C.accelerationHistory == 0 then return Vector3.new(0,0,0) end
    local sum = Vector3.new(0,0,0)
    for _,a in ipairs(C.accelerationHistory) do sum = sum + a end
    return sum / #C.accelerationHistory
    end

    local function getAverageAerialVelocity()
    if #C.aerialVelocityHistory == 0 then return Vector3.new(0,0,0) end
    local sum = Vector3.new(0,0,0)
    for _,vel in ipairs(C.aerialVelocityHistory) do
    sum = sum + Vector3.new(vel.X, 0, vel.Z)
    end
    return sum / #C.aerialVelocityHistory
    end

    local function getAverageVerticalVelocity()
    if #C.verticalVelocityHistory == 0 then return 0 end
    local sum = 0
    for _,y in ipairs(C.verticalVelocityHistory) do sum = sum + y end
    return sum / #C.verticalVelocityHistory
    end

    local function detectMultiJump(currentYVel, wasRising)
    local t = tick()
    if C.lastYVelocity < -5 and currentYVel > CFG.UPWARD_VELOCITY_RESET_THRESHOLD then
    if t - C.lastJumpTime < CFG.MULTI_JUMP_DETECTION_WINDOW then return true end
    C.lastJumpTime = t; return true
    end
    return false
    end

    local function isFallingFromHeight(currentPos, yVel)
    return (currentPos.Y - C.groundHeight > CFG.HIGH_JUMP_THRESHOLD) and yVel < CFG.FALLING_SPEED_THRESHOLD
    end

    local function isAerialStrafing()
    if #C.aerialVelocityHistory < 3 then return false end
    local dc = 0
    for i = 2, #C.aerialVelocityHistory do
    local v1 = Vector3.new(C.aerialVelocityHistory[i-1].X, 0, C.aerialVelocityHistory[i-1].Z)
    local v2 = Vector3.new(C.aerialVelocityHistory[i].X, 0, C.aerialVelocityHistory[i].Z)
    if v1.Magnitude > 3 and v2.Magnitude > 3 then
    if v1.Unit:Dot(v2.Unit) < CFG.STRAFE_DETECTION_THRESHOLD then dc = dc + 1 end
    end
    end
    return dc >= 2
    end

    local function detectDirectionChange(currentVel)
    local horizontal = Vector3.new(currentVel.X, 0, currentVel.Z)
    if horizontal.Magnitude < 5 then return false end
    if C.previousDirection then
    local dot = C.previousDirection:Dot(horizontal.Unit)
    if dot < 0.5 then
    local t = tick()
    if t - C.lastDirectionChangeTime < CFG.DIRECTION_CHANGE_DETECTION_TIME then
    C.previousDirection = horizontal.Unit
    C.lastDirectionChangeTime = t
    return true
    end
    C.lastDirectionChangeTime = t
    end
    end
    C.previousDirection = horizontal.Unit
    return false
    end

    local function isErraticMovement()
    if #C.velocityHistory < 3 then return false end
    local changes = 0
    for i = 2, #C.velocityHistory do
    local v1 = Vector3.new(C.velocityHistory[i-1].X, 0, C.velocityHistory[i-1].Z)
    local v2 = Vector3.new(C.velocityHistory[i].X, 0, C.velocityHistory[i].Z)
    if v1.Magnitude > 5 and v2.Magnitude > 5 then
    if v1.Unit:Dot(v2.Unit) < 0.3 then changes = changes + 1 end
    end
    end
    return changes >= CFG.ERRATIC_MOVEMENT_THRESHOLD
    end

    local function isInfiniteJumping()
    if #C.velocityHistory < 3 then return false end
    local yc = 0
    for i = 2, #C.velocityHistory do
    if math.abs(C.velocityHistory[i].Y - C.velocityHistory[i-1].Y) > 15 then yc = yc + 1 end
    end
    return yc >= 2
    end

    local function isJumpBoostCheat()
    return math.abs(C.targetVelocity.Y) > CFG.JUMPBOOST_Y_THRESHOLD and C.highYVelocityTime > CFG.JUMPBOOST_SUSTAINED_TIME
    end

    local function isExtremeJumpBoost()
    return math.abs(C.targetVelocity.Y) > CFG.EXTREME_JUMPBOOST_THRESHOLD
    end

    local function isFloating()
    return C.airborneTime > CFG.AIRBORNE_THRESHOLD and math.abs(C.targetVelocity.Y) > CFG.FLOAT_Y_THRESHOLD
    end

    local function checkAirborne(targetRoot)
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    params.FilterDescendantsInstances = {C.targetPlayer.Character, Player.Character}
    local rayResult = workspace:Raycast(targetRoot.Position, Vector3.new(0,-100,0), params)
    if rayResult then C.groundHeight = rayResult.Position.Y; return false end
    return true
    end

    local function clampVelocityChange(newVel, oldVel, maxChange)
    local delta = newVel - oldVel
    if delta.Magnitude > maxChange then return oldVel + (delta.Unit * maxChange) end
    return newVel
    end

    local function smoothVelocity(current, target, alpha)
    return current:Lerp(target, alpha)
    end

    local function predictAerialPosition(currentPos, velocity, dt, isStrafing, isFastFalling, isMultiJump)
    local horizVel = Vector3.new(velocity.X, 0, velocity.Z)
    local vertVel = velocity.Y
    if isStrafing then
    local avgAerial = getAverageAerialVelocity()
    horizVel = Vector3.new(avgAerial.X, 0, avgAerial.Z) * CFG.AIR_CONTROL_FACTOR
    else
    horizVel = horizVel * CFG.AIR_CONTROL_FACTOR
    end
    horizVel = horizVel * CFG.AERIAL_VELOCITY_DECAY
    local gravityEffect = CFG.GRAVITY * CFG.GRAVITY_PREDICTION_WEIGHT
    if isMultiJump then gravityEffect = gravityEffect * 0.3; vertVel = vertVel * 0.9 end
    local verticalDisplacement
    if isFastFalling then
    verticalDisplacement = (vertVel * dt) - (0.5 * gravityEffect * 1.2 * dt * dt) - (CFG.FALLING_VERTICAL_LEAD * dt)
    else
    verticalDisplacement = (vertVel * dt) - (0.5 * gravityEffect * dt * dt)
    end
    if vertVel > CFG.RISING_THRESHOLD and not isMultiJump then
    verticalDisplacement = verticalDisplacement + (CFG.VERTICAL_POSITION_LEAD * dt)
    end
    return currentPos + horizVel * dt + Vector3.new(0, verticalDisplacement, 0)
    end

    local function predictServerPosition(currentPos, velocity, acceleration, ping, isQuickTurn, isAerial, isStrafing, isFastFalling, isMultiJump)
    local serverDelay = ping + CFG.SERVER_TICKRATE
    if isQuickTurn then serverDelay = serverDelay * CFG.QUICK_DIRECTION_CHANGE_MULTIPLIER end
    if isAerial then
    return predictAerialPosition(currentPos, velocity, serverDelay, isStrafing, isFastFalling, isMultiJump)
    end
    local predictedPos = currentPos + velocity * serverDelay
    if acceleration.Magnitude > 1 then
    predictedPos = predictedPos + (acceleration * CFG.ACCELERATION_PREDICTION_WEIGHT) * (serverDelay * serverDelay * 0.5)
    end
    return predictedPos
    end

    local function createPredictionSphere()
    if C.predictionSphere then C.predictionSphere:Destroy() end
    C.predictionSphere = Instance.new("Part")
    C.predictionSphere.Name = "PredictionSphere"
    C.predictionSphere.Shape = Enum.PartType.Ball
    C.predictionSphere.Size = Vector3.new(2,2,2)
    C.predictionSphere.Anchored = true
    C.predictionSphere.CanCollide = false
    C.predictionSphere.Material = Enum.Material.Neon
    local visualAccent = _G.__ZurichThemeAccent or Color3.fromRGB(0,120,240)
    local visualOutline = _G.__ZurichThemePrimaryColor or Color3.fromRGB(245,248,255)
    C.predictionSphere.Color = visualAccent
    C.predictionSphere.Transparency = 0.4
    local light = Instance.new("PointLight")
    light.Color = visualAccent
    light.Range = 8
    light.Brightness = 2
    light.Parent = C.predictionSphere
    local outline = Instance.new("Highlight")
    outline.FillTransparency = 1
    outline.OutlineColor = visualOutline
    outline.OutlineTransparency = 0
    outline.Parent = C.predictionSphere
    C.predictionSphere.Parent = workspace
    _G.__ZurichPredictionSphere = C.predictionSphere
    return C.predictionSphere
    end

    local function updatePredictionSphere(targetPosition, dt)
    if not C.predictionSphere then return end
    local alpha = math.min(1, dt * CFG.SPHERE_SMOOTH_SPEED)
    C.predictionSphere.CFrame = C.predictionSphere.CFrame:Lerp(CFrame.new(targetPosition), alpha)
    end

    local function updateRotationAngular(lookDirection, rootPart)
    if not rootPart then return end
    if lookDirection.Magnitude < 0.01 then return end
    local currentLook = rootPart.CFrame.LookVector
    local targetDir = lookDirection.Unit
    local axis = currentLook:Cross(targetDir)
    local angle = math.asin(math.clamp(axis.Magnitude, -1, 1))
    if axis.Magnitude > 0.01 then
    local rotSpeed = 80
    rootPart.AssemblyAngularVelocity = axis.Unit * angle * rotSpeed
    else
    rootPart.AssemblyAngularVelocity = Vector3.zero
    end
    end

    local _cypherConn = nil

    local function _cypherGetBat()
    local char = Player.Character
    if char then
    local equippedTool = char:FindFirstChildOfClass("Tool")
    if equippedTool then return equippedTool end
    for _, tool in ipairs(Player.Backpack:GetChildren()) do
    if tool:IsA("Tool") and tool.Name:lower():find("bat") then return tool end
    end
    for _, tool in ipairs(Player.Backpack:GetChildren()) do
    if tool:IsA("Tool") then return tool end
    end
    end
    return nil
    end

    local function _cypherStartFollowing(char)
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    local rootPart = char:FindFirstChild("HumanoidRootPart")
    if not humanoid or not rootPart then return end
    humanoid.AutoRotate = false
    local bat = _cypherGetBat()
    if bat and bat.Parent ~= char then humanoid:EquipTool(bat) end
    if not C.predictionSphere then createPredictionSphere() end
    if _cypherConn then _cypherConn:Disconnect() end
    _cypherConn = RunService.RenderStepped:Connect(function(dt)
    if not aimbotEnabled then
    if _cypherConn then _cypherConn:Disconnect(); _cypherConn = nil end
    return
    end
    local markedPosition = _G.__abatV2MarkedPosition
    if markedPosition then
    local markedDirection = markedPosition - rootPart.Position
    if C.predictionSphere then C.predictionSphere.Transparency = 0.4 end
    if markedDirection.Magnitude > 0.1 then updateRotationAngular(markedDirection, rootPart) end
    if markedDirection.Magnitude > CFG.MIN_FOLLOW_DISTANCE then
    local markedSpeed = getBatSpeed()
    rootPart.AssemblyLinearVelocity = markedDirection.Unit * math.clamp(markedSpeed, 1, 120)
    else
    rootPart.AssemblyLinearVelocity = Vector3.zero
    end
    return
    end
    C.targetPlayer = getNearestPlayer()
    if not C.targetPlayer or not C.targetPlayer.Character then
    if C.predictionSphere then C.predictionSphere.Transparency = 0.4 end
    C.targetPlayer = nil
    C.lastTargetPos = nil
    C.targetVelocity = Vector3.zero
    C.smoothedVelocity = Vector3.zero
    C.velocityHistory = {}
    C.accelerationHistory = {}
    C.aerialVelocityHistory = {}
    C.verticalVelocityHistory = {}
    C.aerialSmoothVelocity = Vector3.zero
    C.airborneTime = 0
    C.highYVelocityTime = 0
    C.previousDirection = nil
    C.wasAirborne = false
    C.lastYVelocity = 0
    C.peakHeight = 0
    C.isMultiJumping = false
    return
    end
    local targetRoot = C.targetPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not targetRoot then
    if C.predictionSphere then C.predictionSphere.Transparency = 0.4 end
    return
    end
    if C.predictionSphere then C.predictionSphere.Transparency = 0.4 end
    local targetPos = targetRoot.Position
    local myPos = rootPart.Position
    if C.lastTargetPos then
    local deltaPos = targetPos - C.lastTargetPos
    local rawVelocity = deltaPos / dt
    rawVelocity = clampVelocityChange(rawVelocity, C.targetVelocity, CFG.MAX_VELOCITY_CHANGE)
    local horizontalVel = Vector3.new(rawVelocity.X, 0, rawVelocity.Z)
    if horizontalVel.Magnitude > CFG.MAX_HORIZONTAL_VELOCITY then
    horizontalVel = horizontalVel.Unit * CFG.MAX_HORIZONTAL_VELOCITY
    rawVelocity = Vector3.new(horizontalVel.X, rawVelocity.Y, horizontalVel.Z)
    end
    local currentAcceleration = (rawVelocity - C.targetVelocity) / dt
    table.insert(C.accelerationHistory, currentAcceleration)
    if #C.accelerationHistory > C.MAX_ACCEL_HISTORY then table.remove(C.accelerationHistory, 1) end
    table.insert(C.verticalVelocityHistory, rawVelocity.Y)
    if #C.verticalVelocityHistory > C.MAX_VERTICAL_HISTORY then table.remove(C.verticalVelocityHistory, 1) end
    C.targetVelocity = rawVelocity
    C.smoothedVelocity = smoothVelocity(C.smoothedVelocity, C.targetVelocity, CFG.VELOCITY_SMOOTHING)
    table.insert(C.velocityHistory, C.targetVelocity)
    if #C.velocityHistory > C.MAX_HISTORY then table.remove(C.velocityHistory, 1) end
    end
    C.lastTargetPos = targetPos
    if math.abs(C.targetVelocity.Y) > CFG.JUMPBOOST_Y_THRESHOLD then
    C.highYVelocityTime = C.highYVelocityTime + dt
    else
    C.highYVelocityTime = 0
    end
    local isAirborne = checkAirborne(targetRoot)
    if isAirborne then
    C.airborneTime = C.airborneTime + dt
    if targetPos.Y > C.peakHeight then C.peakHeight = targetPos.Y end
    if C.airborneTime >= CFG.MIN_AIRBORNE_TIME then
    table.insert(C.aerialVelocityHistory, C.targetVelocity)
    if #C.aerialVelocityHistory > C.MAX_AERIAL_HISTORY then table.remove(C.aerialVelocityHistory, 1) end
    C.aerialSmoothVelocity = smoothVelocity(C.aerialSmoothVelocity, C.targetVelocity, CFG.AERIAL_SMOOTHING)
    end
    C.wasAirborne = true
    else
    C.airborneTime = 0
    C.wasAirborne = false
    C.aerialVelocityHistory = {}
    C.aerialSmoothVelocity = Vector3.zero
    C.lastGroundedPosition = targetPos
    C.peakHeight = 0
    end
    local isJumping = math.abs(C.targetVelocity.Y) > CFG.JUMP_THRESHOLD
    local isInfJump = isInfiniteJumping()
    local isFloater = isFloating()
    local isJumpBoost = isJumpBoostCheat()
    local isExtremeBoost = isExtremeJumpBoost()
    local isErratic = isErraticMovement()
    local avgVelocity = getAverageVelocity()
    local avgAcceleration = getAverageAcceleration()
    local isQuickTurn = detectDirectionChange(C.targetVelocity)
    local isStrafing = isAerialStrafing()
    local isTrulyAirborne = isAirborne and C.airborneTime >= CFG.MIN_AIRBORNE_TIME
    local wasRising = C.lastYVelocity > CFG.RISING_THRESHOLD
    C.isMultiJumping = detectMultiJump(C.targetVelocity.Y, wasRising)
    local isFastFalling = isFallingFromHeight(targetPos, C.targetVelocity.Y)
    local avgYVel = getAverageVerticalVelocity()
    C.lastYVelocity = C.targetVelocity.Y
    local predictionVel = C.targetVelocity
    local predictionAccel = avgAcceleration
    local useCurrentPos = false
    if isExtremeBoost then
    useCurrentPos = true
    predictionVel = Vector3.new(avgVelocity.X, 0, avgVelocity.Z)
    predictionAccel = Vector3.zero
    elseif isJumpBoost then
    local avgH = Vector3.new(avgVelocity.X, 0, avgVelocity.Z)
    predictionVel = Vector3.new(avgH.X, C.targetVelocity.Y * 0.15, avgH.Z)
    predictionAccel = Vector3.new(avgAcceleration.X, 0, avgAcceleration.Z)
    elseif isInfJump or isFloater then
    local avgH = Vector3.new(avgVelocity.X, 0, avgVelocity.Z)
    predictionVel = Vector3.new(avgH.X, C.targetVelocity.Y * 0.5, avgH.Z)
    predictionAccel = Vector3.new(avgAcceleration.X * 0.5, 0, avgAcceleration.Z * 0.5)
    elseif isTrulyAirborne and isStrafing then
    local avgAerial = getAverageAerialVelocity()
    predictionVel = Vector3.new(
    C.aerialSmoothVelocity.X * CFG.AERIAL_DIRECTION_CHANGE_WEIGHT + avgAerial.X * (1 - CFG.AERIAL_DIRECTION_CHANGE_WEIGHT),
    avgYVel,
    C.aerialSmoothVelocity.Z * CFG.AERIAL_DIRECTION_CHANGE_WEIGHT + avgAerial.Z * (1 - CFG.AERIAL_DIRECTION_CHANGE_WEIGHT)
    )
    predictionAccel = Vector3.new(avgAcceleration.X * 0.3, 0, avgAcceleration.Z * 0.3)
    elseif isTrulyAirborne then
    predictionVel = Vector3.new(C.aerialSmoothVelocity.X, avgYVel, C.aerialSmoothVelocity.Z)
    predictionAccel = Vector3.zero
    elseif isErratic then
    predictionVel = Vector3.new(C.smoothedVelocity.X, C.targetVelocity.Y, C.smoothedVelocity.Z)
    predictionAccel = Vector3.new(avgAcceleration.X * 0.7, 0, avgAcceleration.Z * 0.7)
    end
    local serverPredictedPos
    if useCurrentPos then
    serverPredictedPos = targetPos
    else
    serverPredictedPos = predictServerPosition(targetPos, predictionVel, predictionAccel, C.currentPing, isQuickTurn, isTrulyAirborne, isStrafing, isFastFalling, C.isMultiJumping)
    end
    local predTime = CFG.PREDICTION_TIME * 1.1
    if isErratic then predTime = predTime * 0.6
    elseif isQuickTurn then predTime = predTime * 1.2
    elseif isTrulyAirborne and isStrafing then predTime = predTime * 0.7
    elseif isTrulyAirborne and isFastFalling then predTime = predTime * 1.3
    elseif isTrulyAirborne then predTime = predTime * 0.85 end
    local predictedPos
    if isTrulyAirborne then
    predictedPos = predictAerialPosition(serverPredictedPos, predictionVel, predTime, isStrafing, isFastFalling, C.isMultiJumping)
    else
    predictedPos = serverPredictedPos + predictionVel * predTime
    end
    local verticalOffset = Vector3.new(0,0,0)
    if not isTrulyAirborne and not isExtremeBoost and not isJumpBoost and not isInfJump then
    if C.targetVelocity.Y < CFG.FALLING_THRESHOLD then
    verticalOffset = Vector3.new(0, C.targetVelocity.Y * CFG.VERTICAL_OFFSET_MULTIPLIER, 0)
    elseif C.targetVelocity.Y > CFG.RISING_THRESHOLD then
    verticalOffset = Vector3.new(0, C.targetVelocity.Y * CFG.VERTICAL_OFFSET_MULTIPLIER, 0)
    end
    end
    predictedPos = predictedPos + verticalOffset
    local interceptOffset = Vector3.new(0,0,0)
    local horizontalVel = Vector3.new(predictionVel.X, 0, predictionVel.Z)
    if horizontalVel.Magnitude > 1 and not useCurrentPos then
    interceptOffset = horizontalVel.Unit * CFG.PREDICT_AHEAD
    end
    local interceptPoint = predictedPos + interceptOffset
    updatePredictionSphere(interceptPoint, dt)
    local toTarget = interceptPoint - myPos
    if toTarget.Magnitude > 0.1 then updateRotationAngular(toTarget, rootPart) end
    local actualDistance = (targetPos - myPos).Magnitude
    if actualDistance <= CFG.ACTIVATE_DISTANCE then
    local currentTime = tick()
    if currentTime - C.lastActivationTime >= 0.3 then
    if useCurrentPos or (isErratic and not isTrulyAirborne) then
    interceptPoint = serverPredictedPos
    elseif isTrulyAirborne then
    interceptPoint = predictAerialPosition(serverPredictedPos, predictionVel, CFG.ACTIVATION_DELAY, isStrafing, isFastFalling, C.isMultiJumping)
    else
    interceptPoint = serverPredictedPos + predictionVel * CFG.ACTIVATION_DELAY
    end
    local tool = char:FindFirstChildOfClass("Tool")
    if tool then tool:Activate() end
    C.lastActivationTime = currentTime
    end
    end
    local direction = interceptPoint - myPos
    if direction.Magnitude > CFG.MIN_FOLLOW_DISTANCE then
    local dirUnit = direction.Unit
    local currentSpeed = getBatSpeed()
    currentSpeed = math.clamp(currentSpeed, 1, 120)
    rootPart.AssemblyLinearVelocity = dirUnit * currentSpeed
    else
    rootPart.AssemblyLinearVelocity = Vector3.new(0, rootPart.AssemblyLinearVelocity.Y * 0.5, 0)
    end
    end)
    end

    local function _cypherStop()
    if _cypherConn then _cypherConn:Disconnect(); _cypherConn = nil end
    if C.predictionSphere then C.predictionSphere:Destroy(); C.predictionSphere = nil end
    local char = Player.Character
    if char then
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then hum.AutoRotate = true end
    local root = char:FindFirstChild("HumanoidRootPart")
    if root then root.AssemblyAngularVelocity = Vector3.zero end
    end
    C.targetPlayer = nil
    C.lastTargetPos = nil
    C.targetVelocity = Vector3.zero
    C.smoothedVelocity = Vector3.zero
    C.velocityHistory = {}
    C.accelerationHistory = {}
    C.aerialVelocityHistory = {}
    C.verticalVelocityHistory = {}
    C.aerialSmoothVelocity = Vector3.zero
    C.airborneTime = 0
    C.highYVelocityTime = 0
    C.previousDirection = nil
    C.wasAirborne = false
    C.lastYVelocity = 0
    C.peakHeight = 0
    C.groundHeight = 0
    C.isMultiJumping = false
    C.lastActivationTime = 0
    end

    local _cypherCharConn = nil
    local _prevModes = nil       -- carry / lagger modes saved while the aimbot is on
    local _enableToken = 0       -- invalidates a pending start (drop in progress) if disabled meanwhile

    local function startBatAimbot()
    if aimbotEnabled then return end
    aimbotEnabled = true
    if State then State.bypassBatEnabled = true end
    _pingRun = _pingRun + 1
    local myRun = _pingRun
    task.spawn(function()
    while aimbotEnabled and myRun == _pingRun do
    pcall(sampleRealPing)
    pcall(updatePing)
    task.wait(0.5)
    end
    end)
    if not _cypherCharConn then
    _cypherCharConn = Player.CharacterAdded:Connect(function(char)
    task.wait(0.5)
    if aimbotEnabled then _cypherStartFollowing(char) end
    end)
    end
    local char = Player.Character
    if char then _cypherStartFollowing(char) end
    end

    local function stopBatAimbot()
    aimbotEnabled = false
    _pingRun = _pingRun + 1
    if State then State.bypassBatEnabled = false end
    _cypherStop()
    end

    -- Zurich __stopSpeedBoost / __refreshSpeedBoost : carry + lagger speed modes are paused while aiming
    local function pauseSpeedModes()
    if _prevModes == nil then
    _prevModes = { carry = speedMode, lagger = laggerToggled, laggerCarry = laggerCarryToggled }
    end
    speedMode = false; laggerToggled = false; laggerCarryToggled = false
    if resetMovementState then resetMovementState() end
    if _G.__RivalHubApplySpeedNow then pcall(_G.__RivalHubApplySpeedNow) end
    end

    local function resumeSpeedModes()
    local p = _prevModes
    _prevModes = nil
    if not p then return end
    if speedMode or laggerToggled or laggerCarryToggled then return end -- user picked a mode meanwhile
    speedMode, laggerToggled, laggerCarryToggled = p.carry, p.lagger, p.laggerCarry
    if resetMovementState then resetMovementState() end
    if _G.__RivalHubApplySpeedNow then pcall(_G.__RivalHubApplySpeedNow) end
    end

    -- Zurich __stopAutoplay : Auto Left / Auto Right are stopped when the aimbot starts
    local function stopAutoMovement()
    if autoLeftEnabled then
    autoLeftEnabled = false
    pcall(stopAutoLeft)
    if autoLeftSetVisual then autoLeftSetVisual(false) end
    if mobSetAutoLeft then mobSetAutoLeft(false) end
    end
    if autoRightEnabled then
    autoRightEnabled = false
    pcall(stopAutoRight)
    if autoRightSetVisual then autoRightSetVisual(false) end
    if mobSetAutoRight then mobSetAutoRight(false) end
    end
    end

    -- Zurich __checkAndAutoDrop : drop the carried brainrot first, then start
    local function checkAndAutoDrop(callback)
    if LP:GetAttribute("Stealing") and runDropBrainrot then
    local wasOn = autoBatEnabled
    autoBatEnabled = false           -- so Drop Brainrot does not toggle the aimbot itself
    pcall(runDropBrainrot)
    local t0 = tick()
    while LP:GetAttribute("Stealing") and tick() - t0 < 5 do task.wait() end
    autoBatEnabled = wasOn
    end
    if callback then callback() end
    end

    startAimbotAdapt = startBatAimbot
    stopAimbotAdapt  = stopBatAimbot

    disableAutoBat = function()
    _enableToken = _enableToken + 1
    autoBatEnabled = false
    stopBatAimbot()
    resumeSpeedModes()
    if autoBatSetVisual then autoBatSetVisual(false) end
    if mobSetAutoBat then mobSetAutoBat(false) end
    if saveAllSettings then pcall(saveAllSettings, true) end
    end

    enableAutoBat = function()
    if _G.__RivalHubIsBatV2 and _G.__RivalHubIsBatV2() then
    _G.__RivalHubStopBatV2()
    if mobSetBatV2 then mobSetBatV2(false) end
    end
    _enableToken = _enableToken + 1
    local token = _enableToken
    autoBatEnabled = true
    pauseSpeedModes()
    stopAutoMovement()
    if autoBatSetVisual then autoBatSetVisual(true) end
    if mobSetAutoBat then mobSetAutoBat(true) end
    if saveAllSettings then pcall(saveAllSettings, true) end
    task.spawn(checkAndAutoDrop, function()
    if token ~= _enableToken then return end   -- disabled while dropping
    autoBatEnabled = true
    startBatAimbot()
    end)
    end

    _G.enableAutoBat  = enableAutoBat
    _G.disableAutoBat = disableAutoBat
end








function findBat()
    local char = LP.Character
    if not char then return nil end
    for _, name in ipairs(BAT_COUNTER_SLAP_LIST) do
        local t = char:FindFirstChild(name)
        if t and t:IsA("Tool") then return t end
    end
    local bp = LP:FindFirstChildOfClass("Backpack")
    if bp then
        for _, name in ipairs(BAT_COUNTER_SLAP_LIST) do
            local t = bp:FindFirstChild(name)
            if t and t:IsA("Tool") then
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum then pcall(function() hum:EquipTool(t) end) end
                return t
            end
        end
    end
    for _, ch in ipairs(char:GetChildren()) do
        if ch:IsA("Tool") and (ch.Name:lower():find("bat") or ch.Name:lower():find("slap")) then
            return ch
        end
    end
    return nil
end

function isBatTool(tool)
    if not tool then return false end
    for _, name in ipairs(BAT_COUNTER_SLAP_LIST) do
        if tool.Name == name then return true end
    end
    return tool.Name:lower():find("bat") or tool.Name:lower():find("slap")
end

function findBatForCounter()
    local char = LP.Character
    if not char then return nil end
    local backpack = LP:FindFirstChildOfClass("Backpack")
    for _, name in ipairs(BAT_COUNTER_SLAP_LIST) do
        local tool = char:FindFirstChild(name) or (backpack and backpack:FindFirstChild(name))
        if tool then return tool end
    end
    for _, child in ipairs(char:GetChildren()) do
        if child:IsA("Tool") and (child.Name:lower():find("bat") or child.Name:lower():find("slap")) then
            return child
        end
    end
    if backpack then
        for _, child in ipairs(backpack:GetChildren()) do
            if child:IsA("Tool") and (child.Name:lower():find("bat") or child.Name:lower():find("slap")) then
                return child
            end
        end
    end
    return nil
end

function swingBatForCounter(bat, character)
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if bat.Parent ~= character and humanoid then
        pcall(function() humanoid:EquipTool(bat) end)
        task.wait(0.05)
    end
    local remote = bat:FindFirstChildOfClass("RemoteEvent") or bat:FindFirstChildOfClass("RemoteFunction")
    if remote and remote:IsA("RemoteEvent") then
        pcall(function() remote:FireServer() end)
        task.wait(0.1)
        pcall(function() remote:FireServer() end)
    else
        pcall(function() bat:Activate() end)
        task.wait(0.1)
        pcall(function() bat:Activate() end)
    end
end

batCounterDebounce = false

function stopBatCounter()
    if Conns.batCounter then
        Conns.batCounter:Disconnect()
        Conns.batCounter = nil
    end
    batCounterDebounce = false
end

function startBatCounter()
    if Conns.batCounter then return end
    Conns.batCounter = RunService.Heartbeat:Connect(function()
        if not batCounterEnabled then return end
        if batCounterDebounce then return end
        local character = LP.Character
        if not character then return end
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if not humanoid then return end
        local state = humanoid:GetState()
        if state == Enum.HumanoidStateType.Physics or state == Enum.HumanoidStateType.Ragdoll or state == Enum.HumanoidStateType.FallingDown then
            batCounterDebounce = true
            _suppressBodyLock()
            task.spawn(function()
                task.wait(0.15)
                local bat = findBatForCounter()
                if bat then swingBatForCounter(bat, character) end
                task.wait(0.3)
                batCounterDebounce = false
                _unsuppressBodyLock(true)
            end)
        end
    end)
end

function findMedusa()
    local c = LP.Character
    if not c then return nil end
    for _, t in ipairs(c:GetChildren()) do
        if t:IsA("Tool") then
            local n = t.Name:lower()
            if n:find("medusa") or n:find("head") or n:find("stone") then return t end
        end
    end
    local bp = LP:FindFirstChild("Backpack")
    if bp then
        for _, t in ipairs(bp:GetChildren()) do
            if t:IsA("Tool") then
                local n = t.Name:lower()
                if n:find("medusa") or n:find("head") or n:find("stone") then return t end
            end
        end
    end
    return nil
end

function useMedusaCounter()
    if medusaDebounce then return end
    if _tick() - medusaLastUsed < MEDUSA_COOLDOWN then return end
    local c = LP.Character
    if not c then return end
    medusaDebounce = true
    local med = findMedusa()
    if not med then medusaDebounce = false; return end
    if med.Parent ~= c then
        local hum2 = c:FindFirstChildOfClass("Humanoid")
        if hum2 then hum2:EquipTool(med) end
    end
    pcall(function() med:Activate() end)
    medusaLastUsed = _tick()
    medusaDebounce = false
end

function onAnchorChanged(part)
    return part:GetPropertyChangedSignal("Anchored"):Connect(function()
        if medusaCounterEnabled and part.Anchored and part.Transparency == 1 then useMedusaCounter() end
    end)
end

function setupMedusaCounter(char)
    for _, c in pairs(Conns.anchor) do pcall(function() c:Disconnect() end) end
    Conns.anchor = {}
    if not char or not medusaCounterEnabled then return end
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            table.insert(Conns.anchor, onAnchorChanged(part))
        end
    end
    table.insert(Conns.anchor, char.DescendantAdded:Connect(function(part)
        if part:IsA("BasePart") then
            table.insert(Conns.anchor, onAnchorChanged(part))
        end
    end))
end

function stopMedusaCounter()
    for _, c in pairs(Conns.anchor) do pcall(function() c:Disconnect() end) end
    Conns.anchor = {}
end

local DROP_ASCEND_DURATION = 0.2
local DROP_ASCEND_SPEED = 150
local _dropConn = nil

function stopDropBrainrot()
    dropActive = false
    if _dropConn then
        _dropConn:Disconnect()
        _dropConn = nil
    end
    for _, t in ipairs(dropConnections) do
        if type(t) == "thread" then pcall(task.cancel, t)
        elseif type(t) == "RBXScriptConnection" then pcall(t.Disconnect, t) end
    end
    dropConnections = {}
    local c = LP.Character
    if c then
        local root = c:FindFirstChild("HumanoidRootPart")
        if root then root.AssemblyLinearVelocity = _V3zero end
    end
    if dropBrainrotSetVisual then dropBrainrotSetVisual(false) end
    if mobSetDropBR then mobSetDropBR(false) end
end

function runDropBrainrot()
    if dropActive then return end
    local char = LP.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not root or not hum then return end
    if dropMode == 1 then
        local speedH = 0
        if root then
            local vel = root.AssemblyLinearVelocity
            speedH = _V3new(vel.X, 0, vel.Z).Magnitude
        end
        local cooldown = (speedH > 5) and 0.6 or 0.25
        if _tick() - lastDropTime < cooldown then return end
        lastDropTime = _tick()
        dropActive = true
        if dropBrainrotSetVisual then dropBrainrotSetVisual(true) end
        if mobSetDropBR then mobSetDropBR(true) end
        local wasAutoBat = false
        if autoBatEnabled then
            wasAutoBat = true
            disableAutoBat()
        end
        local function finishDrop(threadRef)
            if threadRef and dropConnections then
                for i = #dropConnections, 1, -1 do
                    if dropConnections[i] == threadRef then
                        table.remove(dropConnections, i)
                        break
                    end
                end
            end
            dropActive = false
            local c = LP.Character
            if c then
                local r = c:FindFirstChild("HumanoidRootPart")
                local h = c:FindFirstChildOfClass("Humanoid")
                if r then
                    r.AssemblyLinearVelocity = _V3zero
                    r.AssemblyAngularVelocity = _V3zero
                    if r.Position.Y < -100 then
                        r.CFrame = _CFnew(r.Position.X, 5, r.Position.Z)
                    end
                    local rp = RaycastParams.new()
                    rp.FilterDescendantsInstances = {c}
                    rp.FilterType = Enum.RaycastFilterType.Exclude
                    local rr = workspace:Raycast(r.Position, _V3new(0, -2000, 0), rp)
                    if rr then
                        local off = (h and h.HipHeight or 2) + (r.Size.Y / 2)
                        r.CFrame = _CFnew(r.Position.X, rr.Position.Y + off, r.Position.Z)
                    end
                    if h and h.Health > 0 then h:ChangeState(Enum.HumanoidStateType.Running) end
                end
            end
            if wasAutoBat then
                enableAutoBat()
            end
            if dropBrainrotSetVisual then dropBrainrotSetVisual(false) end
            if mobSetDropBR then mobSetDropBR(false) end
        end
        local flingThread = nil
        flingThread = task.spawn(function()
            local startTime = _tick()
            while dropActive and (_tick() - startTime) < 0.25 do
                RunService.Heartbeat:Wait()
                local c = LP.Character
                local r = c and c:FindFirstChild("HumanoidRootPart")
                if not r then break end
                local vel = r.AssemblyLinearVelocity
                vel = _V3new(0, vel.Y, 0)
                r.AssemblyLinearVelocity = vel * 10000 + _V3new(0, 10000, 0)
                RunService.RenderStepped:Wait()
                if r and r.Parent then r.AssemblyLinearVelocity = vel end
                RunService.Stepped:Wait()
                if r and r.Parent then r.AssemblyLinearVelocity = vel + _V3new(0, 0.1, 0) end
            end
            finishDrop(flingThread)
        end)
        table.insert(dropConnections, flingThread)
        task.delay(0.35, function()
            if dropActive then finishDrop(flingThread) end
        end)
        return
    end

    if autoBatEnabled then disableAutoBat() end
    dropActive = true
    if dropBrainrotSetVisual then dropBrainrotSetVisual(true) end
    if mobSetDropBR then mobSetDropBR(false) end
    local t0 = _tick()
    if _dropConn then _dropConn:Disconnect() end
    _dropConn = RunService.Heartbeat:Connect(function()
        local r = char and char:FindFirstChild("HumanoidRootPart")
        if not r then
            if _dropConn then _dropConn:Disconnect(); _dropConn = nil end
            dropActive = false
            if dropBrainrotSetVisual then dropBrainrotSetVisual(false) end
            if mobSetDropBR then mobSetDropBR(false) end
            return
        end
        if _tick() - t0 >= DROP_ASCEND_DURATION then
            if _dropConn then _dropConn:Disconnect(); _dropConn = nil end
            local rp = _RayParams_new()
            rp.FilterDescendantsInstances = {char}
            rp.FilterType = Enum.RaycastFilterType.Exclude
            local rr = workspace:Raycast(r.Position, _V3new(0, -2000, 0), rp)
            if rr then
                local hum2 = char:FindFirstChildOfClass("Humanoid")
                local off = ((hum2 and hum2.HipHeight) or 2) + (r.Size.Y / 2)
                r.CFrame = _CFnew(r.Position.X, rr.Position.Y + off, r.Position.Z)
                r.AssemblyLinearVelocity = _V3zero
            end
            dropActive = false
            if dropBrainrotSetVisual then dropBrainrotSetVisual(false) end
            if mobSetDropBR then mobSetDropBR(false) end
            return
        end
        r.Velocity = _V3new(r.Velocity.X, DROP_ASCEND_SPEED, r.Velocity.Z)
    end)
end

function executeDropWithToggle(setVisual)
    if dropActive then return end
    task.spawn(function()
        if setVisual then setVisual(true) end
        runDropBrainrot()
        while dropActive do task.wait() end
        task.wait(0.1)
        if setVisual then setVisual(false) end
    end)
end

local _alSaved = setmetatable({}, { __mode = "k" })
local _alDetached = {}
local _alAnimators = setmetatable({}, { __mode = "k" })
local _alStoppedTracks = setmetatable({}, { __mode = "k" })
local _alGeneration = 0
local _alScanCancel = nil
local _alConns = {}
local _alLightOrig = nil
local _alRunning = false

local AL_LOW_FLAGS = {
    {"DFIntClusterSenderMaxJoinBandwidthBps", "2100000000"},
    {"DFIntClusterSenderMaxUpdateBandwidthBps", "2100000000"},
    {"DFIntServerFramesBetweenJoins", "1"},
    {"DFIntRaknetBandwidthInfluxHundredthsPercentageV2", "10000"},
    {"DFIntConnectionMTUSize", "1400"},
    {"FIntRakNetResendBufferArrayLength", "1024"},
    {"DFIntRakNetNakResendDelayMsMax", "1"},
    {"DFIntWaitOnUpdateNetworkLoopEndedMS", "100"},
    {"DFIntWaitOnRecvFromLoopEndedMS", "100"},
    {"DFIntLargePacketQueueSizeCutoffMB", "1000"},
    {"DFIntSendRakNetStatsInterval", "2147483647"},
    {"DFIntRakNetLoopMs", "1"},
    {"DFIntRakNetSelectTimeoutMs", "1"},
    {"DFIntNetworkClusterPacketCacheNumParallelTasks", "8"},
    {"DFIntReplicationDataCacheNumParallelTasks", "8"},
    {"DFIntMegaReplicatorNumParallelTasks", "16"},
    {"DFIntMaxProcessPacketsStepsPerCyclic", "512"},
    {"DFIntMaxProcessPacketsStepsAccumulated", "0"},
    {"DFIntMaxProcessPacketsJobScaling", "1000"},
    {"DFIntClientPacketMaxFrameMicroseconds", "200000"},
    {"DFIntClientPacketExcessMicroseconds", "10000"},
    {"DFIntClientPacketMinMicroseconds", "1"},
    {"DFIntClientPacketMaxDelayMs", "1"},
    {"DFIntMaxWaitTimeBeforeForcePacketProcessMS", "1"},
    {"DFIntMaxFrameBufferSize", "4"},
    {"DFIntBufferCompressionThreshold", "100"},
    {"DFIntOverrideISRReplicatorStepBandwidthBytes", "131072"},
    {"DFIntTaskSchedulerJobInitThreads", "8"},
    {"DFIntTaskSchedulerJobInGameThreads", "8"},
    {"FIntTaskSchedulerAutoThreadLimit", "16"},
    {"FIntTaskSchedulerAsyncTasksMinimumThreadCount", "4"},
    {"DFIntRuntimeConcurrency", "16"},
    {"FIntSimWorldTaskQueueParallelTasks", "20"},
    {"DFIntHttpBatchLimit", "256"},
    {"FIntHttpBatchLimit", "256"},
    {"DFIntHttpCurlConnectionCacheSize", "512"},
    {"FIntDefaultMeshCacheSizeMB", "512"},
    {"DFIntMemCacheMaxCapacityMB", "256"},
    {"DFIntNumAssetsMaxToPreload", "1"},
    {"DFFlagEnableSoundPreloading", "false"},
    {"FFlagSlimContentProvider", "true"},
    {"DFFlagDebugSkipMeshVoxelizer", "true"},
    {"DFFlagTextureQualityOverrideEnabled", "true"},
    {"DFIntTextureQualityOverride", "0"},
    {"FIntDebugTextureManagerSkipMips", "7"},
    {"DFIntDebugLimitMinTextureResolutionWhenSkipMips", "8"},
    {"FFlagTM2SkipMipsForUnstreamable2", "true"},
    {"DFFlagDoNotSkipMipsBasedOnSystemMemoryPS", "true"},
    {"FFlagRenderUseTextureManager224", "false"},
    {"DFIntDebugFRMQualityLevelOverride", "1"},
    {"DFFlagDebugPauseVoxelizer", "true"},
    {"FFlagFastGPULightCulling3", "true"},
    {"FIntRenderLocalLightFadeInMs", "0"},
    {"FIntRenderLocalLightUpdatesMax", "1"},
    {"FIntRenderShadowmapBias", "0"},
    {"FIntSSAOMipLevels", "0"},
    {"FIntDebugForceMSAASamples", "1"},
    {"FIntDebugFRMOptionalMSAALevelOverride", "0"},
    {"FIntRobloxGuiBlurIntensity", "0"},
    {"FIntFRMMinGrassDistance", "0"},
    {"FIntFRMMaxGrassDistance", "0"},
    {"DFFlagCoreScriptTelemetry2", "false"},
    {"DFFlagBrowserTrackerIdTelemetryEnabled", "false"},
    {"FFlagPerfDataOnTelemetryV2", "false"},
    {"FFlagSendRenderFidelityTelemetry2", "false"},
    {"FFlagEnableTelemetryServiceMemoryCPUInfo", "false"},
    {"DFIntTelemetryProfilerHundredthsPercentage", "0"},
    {"FIntTelemetryProfilerFrequency", "0"},
    {"FIntPerformanceTelemetryQueueProcessLimit", "0"},
    {"DFIntContentProviderPreloadHangTelemetryHundredthsPercentage", "0"},
}

local function _alApplyLowFlags()
    local env = (getgenv and getgenv()) or _G
    local setter = rawget(env, "setfflag") or rawget(_G, "set_fflag")
    local getter = rawget(env, "getfflag") or rawget(_G, "get_fflag")
    if type(setter) ~= "function" then return end
    for _, flag in ipairs(AL_LOW_FLAGS) do
        local canSet = true
        if type(getter) == "function" then
            local ok, current = pcall(getter, flag[1])
            canSet = ok and current ~= nil
        end
        if canSet then pcall(setter, flag[1], tostring(flag[2])) end
    end
end

local function _alSaveLighting()
    if _alLightOrig then return end
    _alLightOrig = {
        Brightness = Lighting.Brightness,
        ClockTime = Lighting.ClockTime,
        OutdoorAmbient = Lighting.OutdoorAmbient,
        Ambient = Lighting.Ambient,
        GlobalShadows = Lighting.GlobalShadows,
        EnvironmentDiffuseScale = Lighting.EnvironmentDiffuseScale,
        EnvironmentSpecularScale = Lighting.EnvironmentSpecularScale,
        FogStart = Lighting.FogStart,
        FogEnd = Lighting.FogEnd,
    }
end

local function _alApplyLowPermanentSettings()
    pcall(function() settings().Rendering.QualityLevel = Enum.QualityLevel.Level01 end)
    pcall(function()
        UserSettings():GetService("UserGameSettings").SavedQualityLevel = Enum.SavedQualitySetting.QualityLevel1
    end)
    pcall(function()
        Lighting.GlobalShadows = false
        Lighting.EnvironmentDiffuseScale = 0.35
        Lighting.EnvironmentSpecularScale = 0.35
        Lighting.FogStart = 0
        Lighting.FogEnd = 1e10
        Lighting.Brightness = math.max(tonumber(Lighting.Brightness) or 2, 2.5)
        local amb = Lighting.Ambient
        local out = Lighting.OutdoorAmbient
        Lighting.Ambient = Color3.fromRGB(math.max(amb.R * 255, 145), math.max(amb.G * 255, 145), math.max(amb.B * 255, 145))
        Lighting.OutdoorAmbient = Color3.fromRGB(math.max(out.R * 255, 155), math.max(out.G * 255, 155), math.max(out.B * 255, 155))
    end)
    pcall(function()
        local atmosphere = Lighting:FindFirstChildOfClass("Atmosphere")
        if atmosphere then
            atmosphere.Density = 0
            atmosphere.Glare = 0
            atmosphere.Haze = 0
        end
    end)
    pcall(function()
        local terrain = workspace:FindFirstChildOfClass("Terrain")
        if terrain then
            terrain.Decoration = false
            terrain.WaterWaveSize = 0
            terrain.WaterWaveSpeed = 0
            terrain.WaterReflectance = 0
            local clouds = terrain:FindFirstChildOfClass("Clouds")
            if clouds then clouds.Enabled = false end
        end
    end)
end

local function _alChange(object, property, value)
    pcall(function()
        local original = object[property]
        if original == value then return end
        object[property] = value
        local bucket = _alSaved[object]
        if not bucket then bucket = {}; _alSaved[object] = bucket end
        if not bucket[property] then bucket[property] = { value = original } end
    end)
end

local function _alIsProtectedVisual(object)
    local char = LP.Character
    if char and (object == char or object:IsDescendantOf(char)) then return true end
    if object:GetAttribute("_AdaptDuelsSky") == true then return true end
    local parent = object
    while parent and parent ~= workspace do
        if parent:IsA("LayerCollector") or parent:IsA("GuiObject") or parent:IsA("GuiBase2d") then
            return true
        end
        local name = parent.Name or ""
        if name:match("^Crystal") or name:match("^Eclipse") or name:match("^ESP_")
            or name:match("^BloodHounds") or name:match("^RivalHub") then
            return true
        end
        parent = parent.Parent
    end
    return false
end

function applyAntiLagDerender(obj)
    pcall(function()
        if not _alRunning then return end
        if _alIsProtectedVisual(obj) then return end

        if obj:IsA("Terrain") then
            _alChange(obj, "Decoration", false)
            _alChange(obj, "WaterWaveSize", 0)
            _alChange(obj, "WaterWaveSpeed", 0)
            _alChange(obj, "WaterReflectance", 0)
            _alChange(obj, "WaterTransparency", 1)
        end
        if obj:IsA("BasePart") then
            _alChange(obj, "Material", Enum.Material.Plastic)
            _alChange(obj, "MaterialVariant", "")
            _alChange(obj, "Reflectance", 0)
            _alChange(obj, "CastShadow", false)
            if obj:IsA("MeshPart") then
                _alChange(obj, "TextureID", "")
                _alChange(obj, "RenderFidelity", Enum.RenderFidelity.Performance)
                _alChange(obj, "DoubleSided", false)
            elseif obj:IsA("PartOperation") then
                _alChange(obj, "RenderFidelity", Enum.RenderFidelity.Performance)
            end
        elseif obj:IsA("SpecialMesh") then
            _alChange(obj, "TextureId", "")
        elseif obj:IsA("SurfaceAppearance") then
            _alDetached[obj] = true
            _alChange(obj, "Parent", nil)
        elseif obj:IsA("Decal") or obj:IsA("Texture") then
            _alChange(obj, "Transparency", 1)
            _alChange(obj, "Texture", "")
        elseif obj:IsA("ParticleEmitter") then
            _alChange(obj, "Enabled", false)
            _alChange(obj, "Rate", 0)
            pcall(function() obj:Clear() end)
        elseif obj:IsA("Trail") then
            _alChange(obj, "Enabled", false)
            pcall(function() obj:Clear() end)
        elseif obj:IsA("Beam") or obj:IsA("Fire") or obj:IsA("Smoke")
            or obj:IsA("Sparkles") or obj:IsA("Light") or obj:IsA("PostEffect")
            or obj:IsA("Clouds") then
            _alChange(obj, "Enabled", false)
        elseif obj:IsA("Atmosphere") then
            _alChange(obj, "Density", 0)
            _alChange(obj, "Haze", 0)
            _alChange(obj, "Glare", 0)
        elseif obj:IsA("Sky") then
            for _, face in ipairs({"SkyboxBk","SkyboxDn","SkyboxFt","SkyboxLf","SkyboxRt","SkyboxUp","SunTextureId","MoonTextureId"}) do
                _alChange(obj, face, "")
            end
            _alChange(obj, "StarCount", 0)
            _alChange(obj, "CelestialBodiesShown", false)
        elseif obj:IsA("Shirt") then
            _alChange(obj, "ShirtTemplate", "")
        elseif obj:IsA("Pants") then
            _alChange(obj, "PantsTemplate", "")
        elseif obj:IsA("ShirtGraphic") then
            _alChange(obj, "Graphic", "")
        elseif obj:IsA("Animator") then
            if not _alAnimators[obj] then
                local char = LP.Character
                if not (char and obj:IsDescendantOf(char)) then
                    _alAnimators[obj] = true
                    local token = _alGeneration
                    local ok, conn = pcall(function()
                        return obj.AnimationPlayed:Connect(function(track)
                            if not _alRunning or _alGeneration ~= token then return end
                            task.defer(function()
                                if _alRunning and _alGeneration == token then
                                    pcall(function() track:Stop(0) end)
                                end
                            end)
                        end)
                    end)
                    if ok then table.insert(_alConns, conn) end
                    pcall(function()
                        for _, track in ipairs(obj:GetPlayingAnimationTracks()) do
                            if track.IsPlaying then
                                _alStoppedTracks[track] = {
                                    animator = obj,
                                    time = track.TimePosition,
                                    speed = track.Speed,
                                }
                                track:Stop(0)
                            end
                        end
                    end)
                end
            end
        end
    end)
end

function enableAntiLag()
    if _alRunning then return end
    _alRunning = true
    antiLagEnabled = true
    _alGeneration = _alGeneration + 1
    local token = _alGeneration

    _alSaveLighting()
    _alApplyLowFlags()
    _alApplyLowPermanentSettings()

    for _, delaySeconds in ipairs({2, 6, 12, 20}) do
        task.delay(delaySeconds, function()
            if _alRunning and _alGeneration == token then
                _alApplyLowFlags()
            end
        end)
    end

    pcall(function() game:GetService("ReplicatedFirst"):RemoveDefaultLoadingScreen() end)

    table.insert(_alConns, workspace.DescendantAdded:Connect(function(obj)
        task.defer(function()
            if _alRunning and _alGeneration == token then
                pcall(applyAntiLagDerender, obj)
            end
        end)
    end))
    table.insert(_alConns, Lighting.DescendantAdded:Connect(function(obj)
        task.defer(function()
            if _alRunning and _alGeneration == token then
                pcall(applyAntiLagDerender, obj)
            end
        end)
    end))

    local function walkBatched(roots, apply, shouldContinue)
        task.spawn(function()
            local pending = {}
            for _, root in ipairs(roots) do
                if root then
                    local ok, children = pcall(function() return root:GetChildren() end)
                    if ok then for _, c in ipairs(children) do table.insert(pending, c) end end
                end
            end
            while #pending > 0 and _alRunning and _alGeneration == token and shouldContinue() do
                local deadline = os.clock() + 0.0008
                while #pending > 0 and os.clock() < deadline do
                    local obj = table.remove(pending)
                    pcall(apply, obj)
                    local ok, children = pcall(function() return obj:GetChildren() end)
                    if ok then for _, c in ipairs(children) do table.insert(pending, c) end end
                end
                RunService.Heartbeat:Wait()
            end
        end)
    end

    walkBatched({workspace, Lighting}, applyAntiLagDerender, function()
        return _alRunning and _alGeneration == token
    end)
end

function disableAntiLag()
    if not _alRunning then
        antiLagEnabled = false
        return
    end
    _alRunning = false
    antiLagEnabled = false
    _alGeneration = _alGeneration + 1

    if _alScanCancel then pcall(_alScanCancel); _alScanCancel = nil end

    for _, conn in ipairs(_alConns) do pcall(function() conn:Disconnect() end) end
    _alConns = {}

    for object, properties in pairs(_alSaved) do
        for property, original in pairs(properties) do
            pcall(function() object[property] = original.value end)
        end
    end
    _alSaved = setmetatable({}, { __mode = "k" })
    _alDetached = {}
    _alAnimators = setmetatable({}, { __mode = "k" })

    for track, state in pairs(_alStoppedTracks) do
        pcall(function()
            if state.animator.Parent and not track.IsPlaying then
                track:Play(0, 1, state.speed)
                track.TimePosition = state.time
            end
        end)
    end
    _alStoppedTracks = setmetatable({}, { __mode = "k" })

    if _alLightOrig then
        pcall(function()
            Lighting.Brightness = _alLightOrig.Brightness
            Lighting.ClockTime = _alLightOrig.ClockTime
            Lighting.OutdoorAmbient = _alLightOrig.OutdoorAmbient
            Lighting.Ambient = _alLightOrig.Ambient
            Lighting.GlobalShadows = _alLightOrig.GlobalShadows
            Lighting.EnvironmentDiffuseScale = _alLightOrig.EnvironmentDiffuseScale
            Lighting.EnvironmentSpecularScale = _alLightOrig.EnvironmentSpecularScale
            Lighting.FogStart = _alLightOrig.FogStart
            Lighting.FogEnd = _alLightOrig.FogEnd
        end)
        _alLightOrig = nil
    end
end

function applyStretchFOV(val)
    local cam = workspace.CurrentCamera
    if cam then pcall(function() cam.FieldOfView = val end) end
end

function enableStretch()
    if stretchConn then return end
    stretchEnabled = true
    local cam = workspace.CurrentCamera
    if not cam then return end
    origFOV = cam.FieldOfView or 70
    applyStretchFOV(stretchFOV)
    stretchConn = RunService.RenderStepped:Connect(function()
        if not stretchEnabled then
            stretchConn:Disconnect()
            stretchConn = nil
            return
        end
        local c = workspace.CurrentCamera
        if c then c.CFrame = c.CFrame * _CFnew(0,0,0,1,0,0,0,0.7,0,0,0,1) end
    end)
    if stretchFovConn then stretchFovConn:Disconnect() end
    stretchFovConn = RunService.RenderStepped:Connect(function()
        if stretchEnabled then applyStretchFOV(stretchFOV)
        else stretchFovConn:Disconnect(); stretchFovConn = nil end
    end)
end

function disableStretch()
    stretchEnabled = false
    if stretchConn then stretchConn:Disconnect(); stretchConn = nil end
    if stretchFovConn then stretchFovConn:Disconnect(); stretchFovConn = nil end
    local cam = workspace.CurrentCamera
    if cam then pcall(function() cam.FieldOfView = origFOV or 70 end) end
end

local function saveLightingState()
    if _originalLighting then return end
    _originalLighting = {
        Brightness = Lighting.Brightness, ClockTime = Lighting.ClockTime,
        OutdoorAmbient = Lighting.OutdoorAmbient, GlobalShadows = Lighting.GlobalShadows,
        FogEnd = Lighting.FogEnd, FogStart = Lighting.FogStart,
        FogColor = Lighting.FogColor, Ambient = Lighting.Ambient,
        ColorCorrection = nil, Bloom = nil,
    }
    for _, e in ipairs(Lighting:GetChildren()) do
        if e:IsA("ColorCorrectionEffect") then
            _originalLighting.ColorCorrection = { Enabled = e.Enabled, Brightness = e.Brightness, Contrast = e.Contrast, Saturation = e.Saturation, TintColor = e.TintColor }
        elseif e:IsA("BloomEffect") then
            _originalLighting.Bloom = { Enabled = e.Enabled, Intensity = e.Intensity, Size = e.Size, Threshold = e.Threshold }
        end
    end
end

local function restoreLightingState()
    if not _originalLighting then return end
    local old = _originalLighting
    Lighting.Brightness = old.Brightness
    Lighting.ClockTime = old.ClockTime
    Lighting.OutdoorAmbient = old.OutdoorAmbient
    Lighting.GlobalShadows = old.GlobalShadows
    Lighting.FogEnd = old.FogEnd
    Lighting.FogStart = old.FogStart
    Lighting.FogColor = old.FogColor
    Lighting.Ambient = old.Ambient
    if old.ColorCorrection then
        local cc = Lighting:FindFirstChildOfClass("ColorCorrectionEffect")
        if cc then
            cc.Enabled = old.ColorCorrection.Enabled; cc.Brightness = old.ColorCorrection.Brightness
            cc.Contrast = old.ColorCorrection.Contrast; cc.Saturation = old.ColorCorrection.Saturation
            cc.TintColor = old.ColorCorrection.TintColor
        end
    end
    if old.Bloom then
        local bloom = Lighting:FindFirstChildOfClass("BloomEffect")
        if bloom then
            bloom.Enabled = old.Bloom.Enabled; bloom.Intensity = old.Bloom.Intensity
            bloom.Size = old.Bloom.Size; bloom.Threshold = old.Bloom.Threshold
        end
    end
end

SKY_PRESETS_LIST = {"Off","Night","Aurora","Sunset","Galaxy","Cyber","Sakura","Pink Night","Blood Moon","Emerald Dawn","Volcanic","Arctic","Midnight Ocean","Vaporwave","Toxic","Solar Eclipse","Hellscape","Heaven","Storm","Sunrise","Deep Space","Lavender Dream","Inferno","Mint Sky"}

SKY_PRESETS = {
    ["Off"]={kind="off"},
    ["Night"]={clock=22,brightness=2,ambient={110,100,130},outAmb={120,110,140},sky={stars=4000,moon=18,sun=0,moonTex=true},atm={dens=0.45,color={120,60,180},decay={60,20,100},glare=0.5,haze=1.2}},
    ["Aurora"]={clock=14,brightness=3,ambient={150,120,150},outAmb={160,130,150},atm={dens=0.55,color={255,80,200},decay={255,20,150},glare=2.5,haze=3},clouds={cover=0.7,dens=0.7,color={255,240,250}}},
    ["Sunset"]={clock=17.2,brightness=2.5,ambient={170,120,100},outAmb={180,130,110},sky={stars=0,sun=25,moon=0},atm={dens=0.5,color={255,130,60},decay={255,80,30},glare=2,haze=2.5},clouds={cover=0.55,dens=0.55,color={255,200,140}}},
    ["Galaxy"]={clock=0,brightness=1.5,ambient={70,60,100},outAmb={80,70,110},sky={stars=10000,moon=30,sun=0},atm={dens=0.15,color={40,20,80},decay={20,10,50},glare=0.3,haze=0.5}},
    ["Cyber"]={clock=21,brightness=2.2,ambient={90,130,170},outAmb={100,140,180},sky={stars=2000,moon=12},atm={dens=0.4,color={0,200,255},decay={150,0,255},glare=2,haze=2},clouds={cover=0.4,dens=0.6,color={100,200,255}}},
    ["Sakura"]={clock=11,brightness=3.5,ambient={170,150,160},outAmb={180,160,170},sky={sun=8},atm={dens=0.3,color={255,200,220},decay={255,170,200},glare=1,haze=1.5},clouds={cover=0.6,dens=0.4,color={255,250,252}}},
    ["Pink Night"]={clock=23,brightness=2.2,ambient={120,60,110},outAmb={140,70,120},sky={stars=5000,moon=22,sun=0,moonTex=true},atm={dens=0.5,color={255,80,180},decay={140,30,100},glare=0.7,haze=1.4},clouds={cover=0.3,dens=0.5,color={180,90,150}}},
    ["Blood Moon"]={clock=22.5,brightness=1.6,ambient={130,40,40},outAmb={150,50,50},sky={stars=1500,moon=28,sun=0,moonTex=true},atm={dens=0.6,color={220,30,30},decay={120,10,10},glare=1.4,haze=2},clouds={cover=0.5,dens=0.7,color={120,30,30}}},
    ["Emerald Dawn"]={clock=6.5,brightness=2.8,ambient={130,170,140},outAmb={140,180,150},sky={sun=18,moon=0,stars=0},atm={dens=0.4,color={80,200,140},decay={40,150,90},glare=1.8,haze=2.2},clouds={cover=0.5,dens=0.5,color={200,255,220}}},
    ["Volcanic"]={clock=19,brightness=2,ambient={180,80,40},outAmb={200,90,50},sky={stars=200,sun=12,moon=0},atm={dens=0.75,color={255,60,0},decay={180,20,0},glare=3,haze=3.5},clouds={cover=0.8,dens=0.9,color={120,40,20}}},
    ["Arctic"]={clock=9,brightness=3.2,ambient={200,220,235},outAmb={210,230,245},sky={sun=10,stars=0,moon=0},atm={dens=0.3,color={180,220,255},decay={140,200,240},glare=1.5,haze=1.8},clouds={cover=0.7,dens=0.6,color={250,253,255}}},
    ["Midnight Ocean"]={clock=1.5,brightness=1.7,ambient={60,90,130},outAmb={70,100,140},sky={stars=6000,moon=24,sun=0,moonTex=true},atm={dens=0.5,color={20,60,140},decay={10,30,90},glare=0.6,haze=1.5}},
    ["Vaporwave"]={clock=19.5,brightness=2.4,ambient={180,120,200},outAmb={190,130,210},sky={stars=1000,moon=14},atm={dens=0.45,color={255,100,220},decay={120,60,255},glare=2.2,haze=2.4},clouds={cover=0.55,dens=0.55,color={200,150,255}}},
    ["Toxic"]={clock=13,brightness=2.5,ambient={140,180,80},outAmb={150,190,90},atm={dens=0.55,color={100,220,40},decay={60,150,20},glare=1.8,haze=2.6},clouds={cover=0.65,dens=0.7,color={180,255,120}}},
    ["Solar Eclipse"]={clock=12,brightness=0.9,ambient={50,40,60},outAmb={60,50,70},sky={stars=3500,sun=22,moon=0},atm={dens=0.5,color={255,140,40},decay={30,20,40},glare=2.8,haze=1.8}},
    ["Hellscape"]={clock=18,brightness=1.8,ambient={200,60,30},outAmb={220,70,40},sky={stars=100,sun=30,moon=0},atm={dens=0.85,color={255,30,0},decay={120,0,0},glare=3.5,haze=4},clouds={cover=0.95,dens=0.95,color={80,20,10}}},
    ["Heaven"]={clock=12,brightness=4,ambient={240,235,210},outAmb={250,245,220},sky={sun=16,moon=0,stars=0},atm={dens=0.25,color={255,250,220},decay={255,240,200},glare=3,haze=1.5},clouds={cover=0.85,dens=0.5,color={255,255,255}}},
    ["Storm"]={clock=15,brightness=1.4,ambient={90,90,110},outAmb={100,100,120},sky={stars=0,sun=6,moon=0},atm={dens=0.65,color={80,90,120},decay={40,50,80},glare=0.5,haze=3},clouds={cover=0.95,dens=0.95,color={60,65,80}}},
    ["Sunrise"]={clock=6.2,brightness=2.8,ambient={220,180,130},outAmb={230,190,140},sky={sun=22,stars=0,moon=0},atm={dens=0.45,color={255,180,100},decay={255,140,80},glare=2.4,haze=2.2},clouds={cover=0.4,dens=0.4,color={255,220,180}}},
    ["Deep Space"]={clock=0,brightness=1,ambient={30,25,50},outAmb={40,35,60},sky={stars=15000,moon=0,sun=0},atm={dens=0.08,color={15,5,40},decay={5,0,20},glare=0.2,haze=0.3}},
    ["Lavender Dream"]={clock=18.5,brightness=2.6,ambient={180,160,220},outAmb={190,170,230},sky={stars=800,moon=16,sun=0},atm={dens=0.4,color={200,160,255},decay={160,120,220},glare=1.4,haze=1.8},clouds={cover=0.55,dens=0.5,color={220,200,255}}},
    ["Inferno"]={clock=17.5,brightness=2.2,ambient={220,100,40},outAmb={235,110,50},sky={sun=26,moon=0,stars=0},atm={dens=0.6,color={255,90,20},decay={200,40,0},glare=3,haze=3.2},clouds={cover=0.7,dens=0.7,color={200,80,40}}},
    ["Mint Sky"]={clock=10,brightness=3.2,ambient={180,230,210},outAmb={190,240,220},sky={sun=10},atm={dens=0.32,color={150,255,210},decay={100,220,180},glare=1.6,haze=1.6},clouds={cover=0.55,dens=0.45,color={240,255,250}}},
}

local function _vC3(t) return Color3.fromRGB(t[1], t[2], t[3]) end

function _v4mpClearSky()
    for _, child in ipairs(Lighting:GetChildren()) do
        if child:GetAttribute("_AdaptDuelsSky") then
            pcall(function() child:Destroy() end)
        end
    end
    local terrain = workspace:FindFirstChildOfClass("Terrain")
    if terrain then
        for _, child in ipairs(terrain:GetChildren()) do
            if child:GetAttribute("_AdaptDuelsSky") then
                pcall(function() child:Destroy() end)
            end
        end
    end
end

function applyCustomSky(mode)
    _v4mpClearSky()
    local preset = SKY_PRESETS[mode]
    if not preset or preset.kind == "off" then
        Lighting.ClockTime = 14
        Lighting.Brightness = 2
        Lighting.OutdoorAmbient = Color3.fromRGB(127,127,127)
        Lighting.Ambient = Color3.fromRGB(127,127,127)
        Lighting.FogEnd = 100000
        Lighting.GlobalShadows = true
        skyTheme = "Off"
        return
    end
    Lighting.FogStart = 0
    Lighting.FogEnd = 100000
    Lighting.FogColor = Color3.fromRGB(200,200,200)
    Lighting.ColorShift_Top = Color3.fromRGB(0,0,0)
    Lighting.ColorShift_Bottom = Color3.fromRGB(0,0,0)
    Lighting.GlobalShadows = true
    Lighting.ClockTime = preset.clock or 14
    Lighting.Brightness = math.max(tonumber(preset.brightness) or 2, 2.5)
    if preset.outAmb then Lighting.OutdoorAmbient = _vC3(preset.outAmb) end
    if preset.ambient then Lighting.Ambient = _vC3(preset.ambient) end
    local amb = Lighting.Ambient
    local out = Lighting.OutdoorAmbient
    Lighting.Ambient = Color3.fromRGB(math.max(amb.R * 255, 135), math.max(amb.G * 255, 135), math.max(amb.B * 255, 135))
    Lighting.OutdoorAmbient = Color3.fromRGB(math.max(out.R * 255, 145), math.max(out.G * 255, 145), math.max(out.B * 255, 145))
    if preset.sky then
        local skyInst = Instance.new("Sky")
        skyInst:SetAttribute("_AdaptDuelsSky", true)
        if preset.sky.stars then skyInst.StarCount = preset.sky.stars end
        if preset.sky.moon then skyInst.MoonAngularSize = preset.sky.moon end
        if preset.sky.sun then skyInst.SunAngularSize = preset.sky.sun end
        if preset.sky.moonTex then skyInst.MoonTextureId = "rbxasset://sky/moon.jpg" end
        skyInst.Parent = Lighting
    end
    if preset.atm then
        local atm = Instance.new("Atmosphere")
        atm:SetAttribute("_AdaptDuelsSky", true)
        atm.Density = preset.atm.dens or 0.3
        atm.Color = _vC3(preset.atm.color)
        atm.Decay = _vC3(preset.atm.decay)
        atm.Glare = preset.atm.glare or 1
        atm.Haze = preset.atm.haze or 1
        atm.Parent = Lighting
    end
    local terrain = workspace:FindFirstChildOfClass("Terrain")
    if preset.clouds and terrain then
        local clouds = Instance.new("Clouds")
        clouds:SetAttribute("_AdaptDuelsSky", true)
        clouds.Cover = preset.clouds.cover or 0.5
        clouds.Density = preset.clouds.dens or 0.5
        clouds.Color = _vC3(preset.clouds.color)
        clouds.Parent = terrain
    end
    skyTheme = mode
end

function enableVividGraphics()
    if vividGraphicsEnabled and #_vividEffects > 0 then return end
    vividGraphicsEnabled = true
    for _, eff in ipairs(_vividEffects) do
        pcall(function() eff:Destroy() end)
    end
    _vividEffects = {}
    local color = Instance.new("ColorCorrectionEffect")
    color.Parent = Lighting
    color.Saturation = 0.6; color.Contrast = 0.4; color.Brightness = 0.05
    color.TintColor = Color3.fromRGB(255, 240, 220)
    table.insert(_vividEffects, color)
    local bloom = Instance.new("BloomEffect")
    bloom.Parent = Lighting
    bloom.Intensity = 0.8; bloom.Size = 24; bloom.Threshold = 1
    table.insert(_vividEffects, bloom)
    local atmosphere = Instance.new("Atmosphere")
    atmosphere.Parent = Lighting
    atmosphere.Density = 0.3; atmosphere.Offset = 0.25
    atmosphere.Color = Color3.fromRGB(199, 199, 255)
    atmosphere.Decay = Color3.fromRGB(106, 112, 125)
    atmosphere.Glare = 0.2; atmosphere.Haze = 1
    table.insert(_vividEffects, atmosphere)
    local sun = Instance.new("SunRaysEffect")
    sun.Parent = Lighting
    sun.Intensity = 0.2; sun.Spread = 0.8
    table.insert(_vividEffects, sun)
    local dof = Instance.new("DepthOfFieldEffect")
    dof.Parent = Lighting
    dof.FocusDistance = 25; dof.InFocusRadius = 10
    dof.NearIntensity = 0.2; dof.FarIntensity = 0.4
    table.insert(_vividEffects, dof)
    task.spawn(function()
        while vividGraphicsEnabled and color and color.Parent do
            color.Contrast = 0.35 + math.sin(tick() * 2) * 0.05
            task.wait(0.03)
        end
    end)
end

function disableVividGraphics()
    vividGraphicsEnabled = false
    for _, eff in ipairs(_vividEffects) do
        pcall(function() eff:Destroy() end)
    end
    _vividEffects = {}
end

function toggleVividGraphics(on)
    if on then enableVividGraphics() else disableVividGraphics() end
    saveAllSettings(true)
end

function applyHideButtons(state)
    hideButtonsEnabled = state
    if MobilePanel then
        for _, child in ipairs(MobilePanel:GetChildren()) do
            if child:IsA("TextButton") then
                local scale = child:FindFirstChildOfClass("UIScale")
                local gen = (child:GetAttribute("FXHideGen") or 0) + 1
                child:SetAttribute("FXHideGen", gen)
                if scale and ScreamFX and ScreamFX.enabled() then
                    if state then
                        local shrink = TS:Create(scale, TweenInfo.new(0.2, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {Scale = 0})
                        shrink.Completed:Connect(function()
                            if child:GetAttribute("FXHideGen") == gen then
                                child.Visible = false
                                scale.Scale = floatingButtonScale
                            end
                        end)
                        shrink:Play()
                    else
                        if not child.Visible then scale.Scale = 0 end
                        child.Visible = true
                        TS:Create(scale, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Scale = floatingButtonScale}):Play()
                    end
                else
                    child.Visible = not state
                end
            end
        end
    end
end

function toggleHideButtons(on)
    applyHideButtons(on)
    if setHideButtonsVisual then setHideButtonsVisual(on) end
    saveAllSettings(true)
end

function ScreamUI.new(class, parent, props)
    local object = Instance.new(class)
    for key, value in pairs(props or {}) do object[key] = value end
    object.Parent = parent
    return object
end
function ScreamUI.round(object, radius)
    local corner = object:FindFirstChildOfClass("UICorner") or Instance.new("UICorner", object)
    corner.CornerRadius = UDim.new(0, radius or 12)
    return corner
end
function ScreamUI.stroke(object, color, transparency, thickness)
    return ScreamUI.new("UIStroke", object, {Color = color, Transparency = transparency or 0,
        Thickness = thickness or 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border})
end
function ScreamUI.text(parent, text, position, size, fontSize, color, z)
    return ScreamUI.new("TextLabel", parent, {Text = text, Position = position, Size = size,
        BackgroundTransparency = 1, TextColor3 = color or Color3.fromRGB(245, 241, 235),
        Font = Enum.Font.GothamMedium, TextSize = fontSize or 12, ZIndex = z or 8,
        TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd})
end
function ScreamUI.sectionIcon(parent, name, position, size, color, z)
    local root = ScreamUI.new("Frame", parent, {Name = "SectionIcon", Position = position,
        Size = UDim2.fromOffset(size, size), BackgroundTransparency = 1, ZIndex = z})
    local function line(x1, y1, x2, y2, thickness)
        local dx, dy = x2 - x1, y2 - y1
        local ink = ScreamUI.new("Frame", root, {Name = "IconInk", AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale((x1 + x2) / 2, (y1 + y2) / 2),
            Size = UDim2.fromOffset(math.sqrt(dx * dx + dy * dy) * size, thickness or 1.6),
            BackgroundColor3 = color, BorderSizePixel = 0, Rotation = math.deg(math.atan2(dy, dx)), ZIndex = z})
        ScreamUI.round(ink, 2)
    end
    local function box(x, y, w, h, radius, solid)
        local object = ScreamUI.new("Frame", root, {Name = "IconInk", Position = UDim2.fromScale(x, y),
            Size = UDim2.fromScale(w, h), BackgroundColor3 = color, BackgroundTransparency = solid and 0 or 1,
            BorderSizePixel = 0, ZIndex = z})
        ScreamUI.round(object, radius)
        if not solid then ScreamUI.stroke(object, color, 0, 1.4) end
        return object
    end
    if name == "Speed" then
        line(0.18, 0.22, 0.44, 0.5); line(0.44, 0.5, 0.18, 0.78)
        line(0.52, 0.22, 0.79, 0.5); line(0.79, 0.5, 0.52, 0.78)
    elseif name == "Custom" then
        line(0.5, 0.1, 0.83, 0.24); line(0.83, 0.24, 0.78, 0.62)
        line(0.78, 0.62, 0.5, 0.88); line(0.5, 0.88, 0.22, 0.62)
        line(0.22, 0.62, 0.17, 0.24); line(0.17, 0.24, 0.5, 0.1)
        line(0.36, 0.47, 0.47, 0.58); line(0.47, 0.58, 0.66, 0.37)
    elseif name == "Visual" then
        box(0.15, 0.15, 0.27, 0.27, 2, false)
        box(0.58, 0.15, 0.27, 0.27, 2, true)
        box(0.15, 0.58, 0.27, 0.27, 2, true)
        box(0.58, 0.58, 0.27, 0.27, 2, false)
    elseif name == "Settings" then
        line(0.5, 0.13, 0.82, 0.3); line(0.82, 0.3, 0.82, 0.77)
        line(0.82, 0.77, 0.18, 0.77); line(0.18, 0.77, 0.18, 0.3)
        line(0.18, 0.3, 0.5, 0.13); line(0.18, 0.3, 0.82, 0.3)
        line(0.5, 0.39, 0.5, 0.67); line(0.37, 0.54, 0.5, 0.67); line(0.63, 0.54, 0.5, 0.67)
    elseif name == "Keybinds" then
        box(0.08, 0.22, 0.84, 0.56, 3, false)
        box(0.2, 0.37, 0.12, 0.12, 1, true)
        box(0.44, 0.37, 0.12, 0.12, 1, true)
        box(0.68, 0.37, 0.12, 0.12, 1, true)
        line(0.29, 0.64, 0.71, 0.64)
    end
    return root
end
function ScreamUI.colorSectionIcon(root, color)
    if not root then return end
    for _, object in ipairs(root:GetDescendants()) do
        if object:IsA("Frame") and object.Name == "IconInk" then object.BackgroundColor3 = color end
        if object:IsA("UIStroke") then object.Color = color end
    end
end

function ScreamUI.fit()
    if not mainUIScale or not main or not main.Parent then return end
    local cam = Workspace.CurrentCamera
    if not cam then return end
    local viewport = cam.ViewportSize
    local width = 350
    local scale = math.max(0.25, math.min(uiScaleValue / 100, (viewport.X - 24) / width, (viewport.Y - 24) / 460))
    local height = math.min(570, math.floor((viewport.Y - 24) / scale))
    ScreamUI.targetScale = scale
    ScreamUI.width, ScreamUI.height = width, height
    if ScreamUI.mainAnimating then ScreamUI.animBaseScale = scale end
    if not ScreamUI.mainAnimating then
        mainUIScale.Scale = scale
        main.Size = UDim2.fromOffset(width, height)
        local size = Vector2.new(width * mainUIScale.Scale, height * mainUIScale.Scale)
        local point = main.AbsolutePosition
        main.Position = UDim2.fromOffset(_clamp(point.X, 8, math.max(8, viewport.X - size.X - 8)),
            _clamp(point.Y, 8, math.max(8, viewport.Y - size.Y - 8)))
    end
    if pbFrame and pbFrame.Parent and ScreamUI.hudScale then
        local hudScale = math.min(1, (viewport.X - 24) / 300)
        ScreamUI.hudScale.Scale = hudScale
        local hudWidth, hudHeight = 300 * hudScale, 78 * hudScale
        if not savedProgressBarPos then
            -- bottom center (Scream style)
            pbFrame.Position = UDim2.fromOffset(
                (viewport.X - hudWidth) / 2,
                viewport.Y - hudHeight - 24
            )
        else
            local point = pbFrame.AbsolutePosition
            pbFrame.Position = UDim2.fromOffset(math.clamp(point.X, 6, math.max(6, viewport.X - hudWidth - 6)),
                math.clamp(point.Y, 6, math.max(6, viewport.Y - hudHeight - 6)))
        end
    end

end
function ScreamUI.effectsLoop(root)
    local state = ScreamUI
    if state.effectConn then state.effectConn:Disconnect() end
    local accumulator, elapsed = 0, 0
    local connection
    connection = RunService.Heartbeat:Connect(function(dt)
        if not root.Parent or _mySession ~= _G.RivalHubSession then
            connection:Disconnect()
            if state.effectConn == connection then state.effectConn = nil end
            return
        end
        accumulator = accumulator + dt
        elapsed = elapsed + dt
        if accumulator < 1 / 24 then return end
        accumulator = 0
        local panel = root:FindFirstChild("Main")
        if not state.effects or not panel or not panel.Visible then return end
        for i, item in ipairs(state.animated) do
            if item.object.Parent then
                item.object.Position = item.position + UDim2.fromOffset(math.sin(elapsed * 0.6 + i) * (item.x or 0),
                    math.sin(elapsed * 1.1 + i) * (item.y or 4))
                if item.rotate then item.object.Rotation = math.sin(elapsed * 0.7 + i) * item.rotate end
            end
        end
        if state.titleGradient and state.titleGradient.Parent then
            state.titleGradient.Offset = Vector2.new(math.sin(elapsed * 0.45) * 0.28, 0)
        end
        if state.borderGrad and state.borderGrad.Parent then
            state.borderGrad.Rotation = (elapsed * 45) % 360
        end
        if state.glowStroke and state.glowStroke.Parent then
            local glowA = math.clamp(state.glowAlpha or 1, 0, 1)
            state.glowStroke.Transparency = 1 - (0.3 + math.sin(elapsed * 1.8) * 0.1) * glowA
        end
    end)
    state.effectConn = connection
    root.Destroying:Connect(function()
        connection:Disconnect()
        if state.effectConn == connection then state.effectConn = nil end
        for _, tween in pairs(state.tweens) do pcall(function() tween:Cancel() end) end
        if state.backgroundTween then pcall(function() state.backgroundTween:Cancel() end) end
        state.animated, state.cards, state.tweens = {}, {}, {}
    end)
end

-- ============================================================
-- SCREAM FX — moteur d'animations UI (refonte violet / noir)
-- Toutes les animations respectent le toggle "UI Effects" (ScreamUI.effects)
-- ============================================================
ScreamFX = {
    accentRefs = {},
    serial = 0,
    fadeCache = setmetatable({}, {__mode = "k"}),
    popGen = setmetatable({}, {__mode = "k"}),
    pills = setmetatable({}, {__mode = "k"}),
    BG = Color3.fromRGB(9, 7, 14),
    PANEL = Color3.fromRGB(15, 11, 23),
    ROW = Color3.fromRGB(19, 14, 29),
    ROW_HOVER = Color3.fromRGB(28, 20, 43),
    BORDER = Color3.fromRGB(66, 48, 98),
    INPUT = Color3.fromRGB(11, 8, 18),
    TEXT = Color3.fromRGB(242, 238, 252),
    MUTED = Color3.fromRGB(150, 138, 176),
    DIM = Color3.fromRGB(98, 88, 120),
}

function ScreamFX.enabled()
    return ScreamUI.effects ~= false
end

function ScreamFX.tween(object, duration, props, style, direction, delayTime)
    if not object then return nil end
    local ok, tween = pcall(function()
        return TS:Create(object, TweenInfo.new(ScreamFX.enabled() and duration or 0.01,
            style or Enum.EasingStyle.Quint, direction or Enum.EasingDirection.Out, 0, false,
            ScreamFX.enabled() and (delayTime or 0) or 0), props)
    end)
    if ok and tween then
        tween:Play()
        return tween
    end
    return nil
end

-- Couleur d'accent enregistrée : se met à jour toute seule quand le thème change
function ScreamFX.accent(object, apply)
    if not object then return end
    local ref = {object = object, apply = apply}
    table.insert(ScreamFX.accentRefs, ref)
    pcall(apply, object, getThemeColor())
    return ref
end

function ScreamFX.refreshAccent(color)
    local refs = ScreamFX.accentRefs
    for i = #refs, 1, -1 do
        local ref = refs[i]
        if not ref.object or not ref.object.Parent then
            table.remove(refs, i)
        else
            pcall(ref.apply, ref.object, color)
        end
    end
    for pill in pairs(ScreamFX.pills) do
        if pill.Parent and pill:GetAttribute("FXOn") == true then
            pill.BackgroundColor3 = color
            local stroke = pill:FindFirstChildOfClass("UIStroke")
            if stroke then stroke.Color = color:Lerp(Color3.new(1, 1, 1), 0.25) end
        end
    end
end

function ScreamFX.pointer(input)
    if input and input.UserInputType == Enum.UserInputType.Touch then
        local inset = Vector2.new(0, 0)
        pcall(function() inset = game:GetService("GuiService"):GetGuiInset() end)
        return Vector2.new(input.Position.X, input.Position.Y) + inset
    end
    local ok, pos = pcall(function() return UIS:GetMouseLocation() end)
    if ok then return pos end
    return nil
end

-- Onde de clic (ripple) à l'endroit touché
function ScreamFX.ripple(host, screenPos, color)
    if not ScreamFX.enabled() or not host or not host.Parent then return end
    local abs, size = host.AbsolutePosition, host.AbsoluteSize
    if size.X < 2 or size.Y < 2 then return end
    local rx, ry = 0.5, 0.5
    if screenPos then
        rx = math.clamp((screenPos.X - abs.X) / size.X, 0, 1)
        ry = math.clamp((screenPos.Y - abs.Y) / size.Y, 0, 1)
    end
    local circle = Instance.new("Frame")
    circle.Name = "FXRipple"
    circle.AnchorPoint = Vector2.new(0.5, 0.5)
    circle.Position = UDim2.fromScale(rx, ry)
    circle.Size = UDim2.fromScale(0, 0)
    circle.SizeConstraint = Enum.SizeConstraint.RelativeXX
    circle.BackgroundColor3 = color or getThemeColor()
    circle.BackgroundTransparency = 0.7
    circle.BorderSizePixel = 0
    circle.ZIndex = (host.ZIndex or 1) + 1
    Instance.new("UICorner", circle).CornerRadius = UDim.new(1, 0)
    circle.Parent = host
    local tween = TS:Create(circle, TweenInfo.new(0.55, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
        {Size = UDim2.fromScale(2.2, 2.2), BackgroundTransparency = 1})
    tween.Completed:Connect(function() if circle.Parent then circle:Destroy() end end)
    tween:Play()
end

-- Effet "appui" (le bouton doit avoir AnchorPoint 0.5 pour rétrécir vers son centre)
function ScreamFX.press(button, target)
    target = target or button
    local scale = target:FindFirstChild("FXPress")
    if not scale then
        scale = Instance.new("UIScale")
        scale.Name = "FXPress"
        scale.Parent = target
    end
    local function release()
        ScreamFX.tween(scale, 0.38, {Scale = 1}, Enum.EasingStyle.Back)
    end
    button.MouseButton1Down:Connect(function()
        ScreamFX.tween(scale, 0.08, {Scale = 0.94}, Enum.EasingStyle.Quad)
    end)
    button.MouseButton1Up:Connect(release)
    button.MouseLeave:Connect(release)
    return scale
end

local function _fxFadeProps(object)
    local props = nil
    if object:IsA("GuiObject") then props = {"BackgroundTransparency"} end
    if object:IsA("TextLabel") or object:IsA("TextButton") or object:IsA("TextBox") then
        table.insert(props, "TextTransparency")
    elseif object:IsA("ImageLabel") or object:IsA("ImageButton") then
        table.insert(props, "ImageTransparency")
    elseif object:IsA("UIStroke") then
        props = {"Transparency"}
    end
    return props
end

-- Fondu d'un arbre d'objets (show = apparition, sinon disparition puis restauration)
function ScreamFX.fade(root, show, duration, delayTime, onDone)
    if not root then return end
    if not ScreamFX.enabled() then
        if onDone then onDone() end
        return
    end
    ScreamFX.serial = ScreamFX.serial + 1
    local serial = ScreamFX.serial
    local entries = {}
    local objects = root:GetDescendants()
    table.insert(objects, 1, root)
    for _, object in ipairs(objects) do
        if string.sub(object.Name, 1, 2) ~= "FX" then
            local props = _fxFadeProps(object)
            if props then
                local record = ScreamFX.fadeCache[object]
                local targets = record and record.targets
                if not targets then
                    targets = {}
                    for _, prop in ipairs(props) do targets[prop] = object[prop] end
                end
                ScreamFX.fadeCache[object] = {targets = targets, serial = serial}
                if show then
                    for prop, value in pairs(targets) do
                        if value < 1 then object[prop] = 1 end
                    end
                end
                table.insert(entries, {object = object, targets = targets})
            end
        end
    end
    local function run()
        for _, entry in ipairs(entries) do
            local record = ScreamFX.fadeCache[entry.object]
            if record and record.serial == serial and entry.object.Parent then
                local goal = {}
                for prop, value in pairs(entry.targets) do goal[prop] = show and value or 1 end
                ScreamFX.tween(entry.object, duration, goal, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            end
        end
    end
    if delayTime and delayTime > 0 then task.delay(delayTime, run) else run() end
    task.delay((delayTime or 0) + duration + 0.03, function()
        if not show and onDone then pcall(onDone) end
        for _, entry in ipairs(entries) do
            local record = ScreamFX.fadeCache[entry.object]
            if record and record.serial == serial then
                if not show and entry.object.Parent then
                    for prop, value in pairs(entry.targets) do entry.object[prop] = value end
                end
                ScreamFX.fadeCache[entry.object] = nil
            end
        end
        if show and onDone then pcall(onDone) end
    end)
end

-- Ouverture / fermeture "pop" d'un panneau (échelle + fondu)
function ScreamFX.pop(frame, open, onDone)
    if not frame then return end
    local scale = frame:FindFirstChild("FXScale")
    if not scale then
        scale = Instance.new("UIScale")
        scale.Name = "FXScale"
        scale.Parent = frame
    end
    ScreamFX.popGen[frame] = (ScreamFX.popGen[frame] or 0) + 1
    local gen = ScreamFX.popGen[frame]
    if not ScreamFX.enabled() then
        scale.Scale = 1
        if onDone then onDone() end
        return
    end
    if open then
        scale.Scale = 0.86
        ScreamFX.tween(scale, 0.42, {Scale = 1}, Enum.EasingStyle.Back)
        ScreamFX.fade(frame, true, 0.22, 0, function()
            if ScreamFX.popGen[frame] == gen and onDone then onDone() end
        end)
    else
        ScreamFX.tween(scale, 0.2, {Scale = 0.9}, Enum.EasingStyle.Quint, Enum.EasingDirection.In)
        ScreamFX.fade(frame, false, 0.18, 0, function()
            if ScreamFX.popGen[frame] ~= gen then return end
            if onDone then onDone() end
            scale.Scale = 1
        end)
    end
end

-- Apparition en cascade des lignes visibles d'une page
function ScreamFX.staggerPage(page)
    if not ScreamFX.enabled() or not page then return end
    local rows = {}
    for _, child in ipairs(page:GetChildren()) do
        if child:IsA("GuiObject") and child.Visible then table.insert(rows, child) end
    end
    table.sort(rows, function(a, b) return a.LayoutOrder < b.LayoutOrder end)
    local top, bottom = page.AbsolutePosition.Y, page.AbsolutePosition.Y + page.AbsoluteSize.Y
    local visible = {}
    if page.AbsoluteSize.Y > 0 then
        for _, row in ipairs(rows) do
            local y = row.AbsolutePosition.Y
            if row.AbsoluteSize.Y > 0 and y + row.AbsoluteSize.Y >= top and y <= bottom then
                table.insert(visible, row)
            end
        end
    end
    if #visible == 0 then
        for i = 1, math.min(14, #rows) do visible[i] = rows[i] end
    end
    for i, row in ipairs(visible) do
        if i > 16 then break end
        ScreamFX.fade(row, true, 0.26, (i - 1) * 0.022)
    end
end

-- Notifications (toasts) en bas à droite
function ScreamFX.notify(title, text, kind, duration)
    duration = duration or 2.6
    local holderGui = ScreamFX.notifyGui
    if not holderGui or not holderGui.Parent then
        holderGui = Instance.new("ScreenGui")
        holderGui.Name = "ScreamHubNotify"
        holderGui.ResetOnSpawn = false
        holderGui.IgnoreGuiInset = true
        holderGui.DisplayOrder = 250
        holderGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        local ok = pcall(function() holderGui.Parent = game:GetService("CoreGui") end)
        if not ok or not holderGui.Parent then holderGui.Parent = pgui end
        local list = Instance.new("Frame")
        list.Name = "List"
        list.AnchorPoint = Vector2.new(1, 1)
        list.Position = UDim2.new(1, -16, 1, -16)
        list.Size = UDim2.fromOffset(250, 400)
        list.BackgroundTransparency = 1
        list.Parent = holderGui
        local layout = Instance.new("UIListLayout", list)
        layout.SortOrder = Enum.SortOrder.LayoutOrder
        layout.VerticalAlignment = Enum.VerticalAlignment.Bottom
        layout.Padding = UDim.new(0, 8)
        ScreamFX.notifyGui = holderGui
        ScreamFX.notifyOrder = 0
    end
    local list = holderGui:FindFirstChild("List")
    if not list then return end
    ScreamFX.notifyOrder = (ScreamFX.notifyOrder or 0) + 1
    local accent = getThemeColor()
    if kind == "error" then accent = Color3.fromRGB(255, 84, 112)
    elseif kind == "success" then accent = Color3.fromRGB(120, 235, 170) end
    local slot = Instance.new("Frame")
    slot.Name = "Toast"
    slot.Size = UDim2.new(1, 0, 0, 0)
    slot.BackgroundTransparency = 1
    slot.ClipsDescendants = false
    slot.LayoutOrder = ScreamFX.notifyOrder
    slot.Parent = list
    local card = Instance.new("Frame")
    card.Name = "Card"
    card.Size = UDim2.new(1, 0, 0, 58)
    card.Position = UDim2.new(1.15, 0, 0, 0)
    card.BackgroundColor3 = ScreamFX.PANEL
    card.BorderSizePixel = 0
    card.ClipsDescendants = true
    card.Parent = slot
    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 10)
    local stroke = Instance.new("UIStroke", card)
    stroke.Color = accent
    stroke.Transparency = 0.45
    stroke.Thickness = 1.2
    local grad = Instance.new("UIGradient", card)
    grad.Rotation = 0
    grad.Color = ColorSequence.new(accent:Lerp(ScreamFX.PANEL, 0.82), ScreamFX.PANEL)
    local bar = Instance.new("Frame", card)
    bar.Size = UDim2.new(0, 3, 1, -16)
    bar.Position = UDim2.fromOffset(8, 8)
    bar.BackgroundColor3 = accent
    bar.BorderSizePixel = 0
    Instance.new("UICorner", bar).CornerRadius = UDim.new(1, 0)
    local titleLabel = Instance.new("TextLabel", card)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Position = UDim2.fromOffset(20, 8)
    titleLabel.Size = UDim2.new(1, -28, 0, 18)
    titleLabel.Font = Enum.Font.GothamBlack
    titleLabel.TextSize = 12
    titleLabel.TextColor3 = ScreamFX.TEXT
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.TextTruncate = Enum.TextTruncate.AtEnd
    titleLabel.Text = tostring(title or "SCREAMHUB")
    local bodyLabel = Instance.new("TextLabel", card)
    bodyLabel.BackgroundTransparency = 1
    bodyLabel.Position = UDim2.fromOffset(20, 26)
    bodyLabel.Size = UDim2.new(1, -28, 0, 22)
    bodyLabel.Font = Enum.Font.GothamMedium
    bodyLabel.TextSize = 11
    bodyLabel.TextColor3 = ScreamFX.MUTED
    bodyLabel.TextXAlignment = Enum.TextXAlignment.Left
    bodyLabel.TextYAlignment = Enum.TextYAlignment.Top
    bodyLabel.TextWrapped = true
    bodyLabel.Text = tostring(text or "")
    local timer = Instance.new("Frame", card)
    timer.Name = "Timer"
    timer.AnchorPoint = Vector2.new(0, 1)
    timer.Position = UDim2.new(0, 0, 1, 0)
    timer.Size = UDim2.new(1, 0, 0, 2)
    timer.BackgroundColor3 = accent
    timer.BackgroundTransparency = 0.25
    timer.BorderSizePixel = 0
    local fast = not ScreamFX.enabled()
    TS:Create(slot, TweenInfo.new(fast and 0.01 or 0.3, Enum.EasingStyle.Quint), {Size = UDim2.new(1, 0, 0, 58)}):Play()
    TS:Create(card, TweenInfo.new(fast and 0.01 or 0.45, Enum.EasingStyle.Back), {Position = UDim2.new(0, 0, 0, 0)}):Play()
    TS:Create(timer, TweenInfo.new(duration, Enum.EasingStyle.Linear), {Size = UDim2.new(0, 0, 0, 2)}):Play()
    task.delay(duration, function()
        if not slot.Parent then return end
        TS:Create(card, TweenInfo.new(fast and 0.01 or 0.28, Enum.EasingStyle.Quint, Enum.EasingDirection.In),
            {Position = UDim2.new(1.15, 0, 0, 0)}):Play()
        local shrink = TS:Create(slot, TweenInfo.new(fast and 0.01 or 0.26, Enum.EasingStyle.Quint, Enum.EasingDirection.In, 0, false, fast and 0 or 0.2),
            {Size = UDim2.new(1, 0, 0, 0)})
        shrink.Completed:Connect(function() if slot.Parent then slot:Destroy() end end)
        shrink:Play()
    end)
end
_G.__ScreamNotify = ScreamFX.notify

function paintFloatingBtn(button, active)
    if not button or not button.Parent then return end
    local accent = getThemeColor()
    button.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    local gradient = button:FindFirstChild("BtnGrad")
    if gradient then
        gradient.Color = active
            and ColorSequence.new(accent:Lerp(Color3.fromRGB(20, 10, 36), 0.5), Color3.fromRGB(16, 9, 28))
            or ColorSequence.new(Color3.fromRGB(26, 19, 40), Color3.fromRGB(10, 8, 16))
    end
    local stroke = button:FindFirstChildOfClass("UIStroke")
    if stroke then
        stroke.Color = active and accent or Color3.fromRGB(74, 56, 110)
        stroke.Thickness = active and 1.6 or 1.2
        stroke.Transparency = active and 0.05 or 0.35
    end
    local label = button:FindFirstChild("TextLabel")
    if label then label.TextColor3 = active and Color3.fromRGB(250, 244, 255) or Color3.fromRGB(226, 220, 240) end
    local status = button:FindFirstChild("Status")
    if status then
        status.Text = active and "ON" or "OFF"
        status.TextColor3 = active and accent:Lerp(Color3.new(1, 1, 1), 0.35) or Color3.fromRGB(120, 108, 145)
    end
    local dot = button:FindFirstChild("StatusDot")
    if dot then
        dot.BackgroundColor3 = active and accent or Color3.fromRGB(70, 58, 92)
    end
    local edge = button:FindFirstChild("AccentEdge")
    if edge then
        edge.BackgroundColor3 = accent
        edge.BackgroundTransparency = active and 0.15 or 0.55
    end
end

function applyFloatingButtonScale()
    for _, uiScale in ipairs(_floatingUIScales) do
        if uiScale and uiScale.Parent then
            uiScale.Scale = floatingButtonScale
            local button = uiScale.Parent
            if button:IsA("GuiObject") and Workspace.CurrentCamera then
                local viewport = Workspace.CurrentCamera.ViewportSize
                local size = 64 * floatingButtonScale
                button.Position = UDim2.fromOffset(_clamp(button.Position.X.Offset, 6, math.max(6, viewport.X - size - 6)),
                    _clamp(button.Position.Y.Offset, 6, math.max(6, viewport.Y - size - 6)))
            end
        end
    end
end

local function drag(f, dragZoneHeight)
    local dn, ds, sp, di = false, nil, nil, nil
    local endConn = nil
    local zone = dragZoneHeight or 99999
    local function stopDrag()
        local wasDragging = dn
        dn = false
        di = nil
        if endConn then
            endConn:Disconnect()
            endConn = nil
        end
        if wasDragging then task.defer(function() pcall(saveAllSettings) end) end
    end
    f.InputBegan:Connect(function(i)
        if uiLocked then return end
        if _isDraggingButton then return end
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            local framePos = f.AbsolutePosition
            if i.Position.Y > framePos.Y + zone then return end
            dn = true; ds = i.Position; sp = f.Position
            if endConn then endConn:Disconnect() end
            endConn = i.Changed:Connect(function()
                if i.UserInputState == Enum.UserInputState.End then stopDrag() end
            end)
        end
    end)
    f.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            stopDrag()
        end
    end)
    UIS.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            stopDrag()
        end
    end)
    f.InputChanged:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch then di = i end
    end)
    UIS.InputChanged:Connect(function(i)
        if i == di and dn then
            if uiLocked then stopDrag(); return end
            if _isDraggingButton then return end
            if not ds or not sp then return end
            local nX = sp.X.Offset + (i.Position.X - ds.X)
            local nY = sp.Y.Offset + (i.Position.Y - ds.Y)
            f.Position = UDim2.new(sp.X.Scale, nX, sp.Y.Scale, nY)
        end
    end)
end

_G.__RivalHubSpeedEngine = _G.__RivalHubSpeedEngine or {}
do
    -- Speed system from speedundetect (Katana) integrated into Scream Hub
    local function blocked(hum)
        if not hum or hum.Health <= 0 then return true end
        if _isRagdollState(hum) then return true end
        if autoBatEnabled or TPBatState.enabled or (_G.__RivalHubIsBatV2 and _G.__RivalHubIsBatV2()) then return true end
        if autoLeftEnabled or autoRightEnabled or dropActive or _G.IsDropping then return true end
        if _G._SpeedModule_Blocked == true then return true end
        return false
    end
    local function applyNow()
        local char = LP.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if not root or blocked(hum) then lastMoveDir = _V3zero; return end
        if useVenixCarryEngine then return end

        -- Ensure velocity spoof is hooked on current HRP
        if _s2VelState.root ~= root or not _velChecked[root] then
            lastMoveDir = _V3zero
            _hookVelHRP(_setupVelChecked(char))
        end

        local direction
        if hum.MoveDirection.Magnitude > 0 then
            lastMoveDir = hum.MoveDirection
            direction = hum.MoveDirection
        elseif lastMoveDir.Magnitude > 0 then
            for key in pairs(MOVE_KEYS) do
                if UIS:IsKeyDown(key) then
                    direction = lastMoveDir
                    break
                end
            end
        end

        local selectedSpeed = getActiveMoveSpeed()
        _applyVelocitySpeed(direction, tonumber(selectedSpeed) or 16, root)
    end
    local function stop()
        if _G.__RivalHubSpeedEngine.conn then _G.__RivalHubSpeedEngine.conn:Disconnect(); _G.__RivalHubSpeedEngine.conn = nil end
        ScreamVenixCarry:stop()
        lastMoveDir = _V3zero
    end
    local function start()
        stop()
        if useVenixCarryEngine then ScreamVenixCarry:start() end
        _G.__RivalHubSpeedEngine.conn = RunService.RenderStepped:Connect(function()
            if _mySession ~= _G.RivalHubSession then stop(); return end
            applyNow()
        end)
    end
    _G.__RivalHubRefreshSpeedEngine = start
    _G.__RivalHubStopSpeedEngine = stop
    _G.__RivalHubApplySpeedNow = applyNow
    pcall(start)
    LP.CharacterRemoving:Connect(function() stop(); _s2VelState.root = nil end)
    LP.CharacterAdded:Connect(function(char)
        task.wait(0.5)
        if _mySession ~= _G.RivalHubSession then return end
        _hookVelHRP(_setupVelChecked(char))
        start()
    end)
end

function setupMovementAndIndicators(char)
    if steppedConn then steppedConn:Disconnect(); steppedConn = nil end
    if movementLoop then movementLoop:Disconnect(); movementLoop = nil end

    local ccAcc = 0
    steppedConn = RunService.Heartbeat:Connect(function(dt)
        ccAcc = ccAcc + dt
        if ccAcc < 0.05 then return end
        ccAcc = 0
        local plist = _GetPlayersCached()
        for i = 1, #plist do
            local p = plist[i]
            if p ~= LP then
                local ch = p.Character
                if ch then
                    local parts = ch:GetChildren()
                    for j = 1, #parts do
                        local part = parts[j]
                        if part:IsA("BasePart") and part.CanCollide then
                            part.CanCollide = false
                        end
                    end
                end
            end
        end
    end)

    local frameCount, lastStats, statAccumulator = 0, _tick(), 0
    movementLoop = RunService.RenderStepped:Connect(function(dt)
        frameCount = frameCount + 1
        statAccumulator = statAccumulator + dt
        if statAccumulator >= 0.5 then
            local now = _tick()
            local fps = _floor(frameCount / math.max(now - lastStats, 0.01) + 0.5)
            frameCount, statAccumulator, lastStats = 0, 0, now
            local ping
            pcall(function() ping = game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue() end)
            if type(ping) ~= "number" then pcall(function() ping = LP:GetNetworkPing() * 1000 end) end
            local pingText = type(ping) == "number" and tostring(_floor(ping + 0.5)) or "--"
            stealHud.statsText = tostring(fps) .. " FPS  ·  PING: " .. pingText .. " MS"
            if stealHud.stats and stealHud.stats.Parent then stealHud.stats.Text = stealHud.statsText end
            if stealHud.fpsVal and stealHud.fpsVal.Parent then stealHud.fpsVal.Text = tostring(fps) end
            if stealHud.pingVal and stealHud.pingVal.Parent then stealHud.pingVal.Text = pingText .. "ms" end
            if stealHud.mode and stealHud.mode.Parent then stealHud.mode.Text = autoStealMode end
            if ScreamUI.footerStats and ScreamUI.footerStats.Parent then ScreamUI.footerStats.Text = stealHud.statsText end
        end
        local char2 = LP.Character
        if not char2 then return end
        local hum = char2:FindFirstChildOfClass("Humanoid")
        local hrp = char2:FindFirstChild("HumanoidRootPart")
        if not hum or not hrp then return end
        if not autoBatEnabled and not autoLeftEnabled and not autoRightEnabled then
            if _isRagdollState(hum) then
                lastMoveDir = _V3zero
            else
                local md = hum.MoveDirection
                if md.Magnitude > 0 then
                    lastMoveDir = md
                end
            end
        end
        if speedLabel and speedLabel.Parent then
            local displaySpeed = getActiveMoveSpeed()
            speedLabel.Text = string.format("VELOCIDAD: %.1f", displaySpeed)
        end
    end)
    setupSpeedIndicator(char)
    startEnemySpeed()
end

function toggleLockUI(state)
    if state == nil then uiLocked = not uiLocked else uiLocked = state end
    if setLockUIVisual then setLockUIVisual(uiLocked) end
end

function disableAllAimbots()
    if autoBatEnabled then
        disableAutoBat()
    end
end

function stopAllBackgroundTasks()
    if movementLoop then movementLoop:Disconnect(); movementLoop = nil end
    if steppedConn then steppedConn:Disconnect(); steppedConn = nil end
    stopEnemySpeed()
    if stretchEnabled then disableStretch() end
    if stretchConn then stretchConn:Disconnect(); stretchConn = nil end
    if stretchFovConn then stretchFovConn:Disconnect(); stretchFovConn = nil end
    if AntiRagdollV1.isRunning() then AntiRagdollV1.stop() end
    if AntiRagdollV2.Enabled then stopAntiRagdollV2() end
    if antiDieEnabled then AntiDieModule.stop() end
    if antiBatEnabled then stopAntiBat() end
    if antiFlingEnabled then stopAntiFling() end
    stopBatCounter()
    if stopBatCounterV2 then stopBatCounterV2() end
    stopMedusaCounter()
    stopAutoSteal()
    disableAutoBat()
    stopAutoLeft()
    stopAutoRight()
    if _G.__RivalHubStopBatV2 then pcall(_G.__RivalHubStopBatV2) end
    if TPBatState and TPBatState.enabled and tpBatSetEnabled then pcall(tpBatSetEnabled, false) end
    if unwalkEnabled then stopUnwalk() end
    if antiLagEnabled then disableAntiLag() end
    if espEnabled then toggleESP(false) end
    if espLineEnabled then stopESPLine() end
    if dropActive then stopDropBrainrot() end
    if bodyLockEnabled then stopBodyLock() end
    _blSuppressCount = 0
    _blWasEnabled = false
    if _blRestoreTimer then pcall(task.cancel, _blRestoreTimer); _blRestoreTimer = nil end
    if _bodyLockConn then _bodyLockConn:Disconnect(); _bodyLockConn = nil end
    for _, t in ipairs(dropConnections) do
        if type(t) == "thread" then pcall(task.cancel, t)
        elseif type(t) == "RBXScriptConnection" then pcall(t.Disconnect, t) end
    end
    dropConnections = {}
    dropActive = false
    alPhase = 1
    arPhase = 1
    lastDropTime = 0
    medusaDebounce = false
    medusaLastUsed = 0
    if _G.__RivalHubStopSpeedEngine then pcall(_G.__RivalHubStopSpeedEngine) end
end

local _rivalHubSaveState = {
    lastAt = 0,
    queued = false,
    writing = false,
    dirty = false,
    revision = 0,
    retryCount = 0,
}
local function resolveRivalHubFileApi()
    local env = (type(getgenv) == "function" and getgenv()) or _G
    local synApi = rawget(env, "syn") or rawget(_G, "syn")
    local readCandidates = {rawget(env, "readfile"), synApi and synApi.readfile, rawget(_G, "readfile")}
    local writeCandidates = {rawget(env, "writefile"), synApi and synApi.writefile, rawget(_G, "writefile")}
    local readFn, writeFn
    for _, fn in ipairs(readCandidates) do if type(fn) == "function" then readFn = fn; break end end
    for _, fn in ipairs(writeCandidates) do if type(fn) == "function" then writeFn = fn; break end end
    return readFn, writeFn
end

local function rivalHubFileExists(path)
    local readFn = resolveRivalHubFileApi()
    if not readFn then return false end
    local ok, data = pcall(readFn, path)
    return ok and type(data) == "string"
end

function buildConfigTable()
    local config = {
        normalSpeed = NS, carrySpeed = CS,
        laggerSpeed1 = LAGGER_SPEED, laggerSpeed2 = LAGGER_CARRY_SPEED,
        stealRadius = CONFIG.STEAL_RANGE,
        holdMin = CONFIG.HOLD_MIN, holdMax = CONFIG.HOLD_MAX, entryDelay = CONFIG.ENTRY_DELAY, cooldown = CONFIG.COOLDOWN, primeRange = CONFIG.PRIME_RANGE,
        antiRagdollMode = antiRagdollMode, antiDieEnabled = antiDieEnabled,
        antiBat = antiBatEnabled,
        antiFling = antiFlingEnabled,
        autoSteal = CONFIG.AUTO_STEAL_ENABLED,
        autoBat = autoBatEnabled, batBypassVersion = batBypassVersion, autoLeft = autoLeftEnabled, autoRight = autoRightEnabled,
        medusaCounter = medusaCounterEnabled, batCounter = batCounterEnabled,
        batCounterV2 = batCounterV2Enabled, unwalkEnabled = unwalkEnabled,
        laggerToggled = laggerToggled, laggerCarryToggled = laggerCarryToggled,
        carryMode = speedMode, batAimbotSpeed = BAT_AIMBOT_SPEED,
        dropMode = dropMode, stretchEnabled = stretchEnabled, stretchFOV = stretchFOV,
        uiScale = uiScaleValue, animPack = currentAnimPack,
        espEnabled = espEnabled,
        espLineEnabled = espLineEnabled,
        vividGraphics = vividGraphicsEnabled,
        hideButtons = hideButtonsEnabled,
        katanaSkinEnabled = katanaSkinEnabled,
        minecraftBatSkinEnabled = minecraftBatSkinEnabled,
        minecraftBatSkinColorMode = minecraftBatSkinColorMode,
        antiLag = antiLagEnabled,
        skyTheme = skyTheme, mobileButtonPositions = savedButtonPositions,
        dropBrainrotKey = {kb = KB.DropBrainrot.kb and KB.DropBrainrot.kb.Name, gp = KB.DropBrainrot.gp and KB.DropBrainrot.gp.Name},
        autoLeftKey = {kb = KB.AutoLeft.kb and KB.AutoLeft.kb.Name, gp = KB.AutoLeft.gp and KB.AutoLeft.gp.Name},
        autoRightKey = {kb = KB.AutoRight.kb and KB.AutoRight.kb.Name, gp = KB.AutoRight.gp and KB.AutoRight.gp.Name},
        autoBatKey = {kb = KB.AutoBat.kb and KB.AutoBat.kb.Name, gp = KB.AutoBat.gp and KB.AutoBat.gp.Name},
        tpFloorKey = {kb = KB.TPFloor.kb and KB.TPFloor.kb.Name, gp = KB.TPFloor.gp and KB.TPFloor.gp.Name},
        guiHideKey = {kb = KB.GuiHide.kb and KB.GuiHide.kb.Name, gp = KB.GuiHide.gp and KB.GuiHide.gp.Name},
        carryToggleKey = {kb = KB.CarryToggle.kb and KB.CarryToggle.kb.Name, gp = KB.CarryToggle.gp and KB.CarryToggle.gp.Name},
        laggerModeKey = {kb = KB.LaggerMode.kb and KB.LaggerMode.kb.Name, gp = KB.LaggerMode.gp and KB.LaggerMode.gp.Name},
        batV2Key = {kb = KB.BatV2.kb and KB.BatV2.kb.Name, gp = KB.BatV2.gp and KB.BatV2.gp.Name},
        instaResetKey = {kb = KB.InstaReset.kb and KB.InstaReset.kb.Name, gp = KB.InstaReset.gp and KB.InstaReset.gp.Name},
        bodyLockEnabled = bodyLockEnabled, bodyLockRange = bodyLockRange,
        progressBarPos = savedProgressBarPos, lockUI = uiLocked,
        backgroundIndex = backgroundIndex,
        backgroundImageTransparency = backgroundImageTransparency,
        backgroundMode = backgroundMode, floatingButtonScale = floatingButtonScale,
        outfitIndex = currentOutfitIndex, vx7AvatarIndex = VX7A.index, themeColor = currentColorTheme,
        rivalTitleTheme = currentRivalTitleTheme,
        infiniteJumpEnabled = InfiniteJump.enabled == true,
        infiniteJumpMode = InfiniteJump.mode == "manual" and "manual" or "hold",
        autoStealMode = autoStealMode,
        useVenixCarryEngine = useVenixCarryEngine,
        softCarry = ScreamVenixCarry.softStealEnabled,
        softCarrySpeed = ScreamVenixCarry.softStealSpeed,
        softCarryRadius = ScreamVenixCarry.softStealRadius,
        uiEffects = ScreamUI.effects,
        mobileButtonsLocked = mobileButtonsLocked,
        batV2 = _G.__RivalHubIsBatV2 and _G.__RivalHubIsBatV2() or false,
    }
    if main then
        local basePos = _G.__RivalHubMainOriginalPos or main.Position
        config.mainPosition = {
            XScale = basePos.X.Scale,
            XOffset = basePos.X.Offset,
            YScale = basePos.Y.Scale,
            YOffset = basePos.Y.Offset,
        }
    end
    if pbFrame then
        config.progressBarPos = {XScale = pbFrame.Position.X.Scale, XOffset = pbFrame.Position.X.Offset, YScale = pbFrame.Position.Y.Scale, YOffset = pbFrame.Position.Y.Offset}
    end
    if MobilePanel then
        config.mobilePanelPos = {XScale = 0, XOffset = 10, YScale = 0, YOffset = 0}
        for _, btn in ipairs(MobilePanel:GetChildren()) do
            if btn:IsA("TextButton") then
                savedButtonPositions[btn.Name] = {X = btn.Position.X.Offset, Y = btn.Position.Y.Offset}
            end
        end
        config.mobileButtonPositions = savedButtonPositions
    end
    return config
end

local function scheduleRivalHubSave(delaySeconds)
    if _rivalHubSaveState.queued then return end
    _rivalHubSaveState.queued = true
    task.delay(delaySeconds or 0.25, function()
        _rivalHubSaveState.queued = false
        if _G.RivalHubRunning and not _isResetting and not _isLoading then
            pcall(saveAllSettings, true)
        end
    end)
end

function saveAllSettings(force)
    if _isResetting or _isLoading then return true end

    local config = buildConfigTable()
    config.configVersion = 2
    config.userId = LP.UserId
    local encodedOk, canonicalJSON = pcall(function() return HS:JSONEncode(config) end)
    if not encodedOk then
        warn("[Rival Hub Save] Could not encode settings.")
        return false
    end
    if not force and canonicalJSON == _lastSavedJSON and not _rivalHubSaveState.dirty then
        return true
    end
    _rivalHubSaveState.dirty = true

    if _rivalHubSaveState.writing then
        scheduleRivalHubSave(0.25)
        return true
    end
    if not force and _tick() - _rivalHubSaveState.lastAt < 0.25 then
        scheduleRivalHubSave(0.25)
        return true
    end

    local readFn, writeFn = resolveRivalHubFileApi()
    if not readFn or not writeFn then
        warn("[Rival Hub Save] Executor file API is unavailable.")
        scheduleRivalHubSave(1)
        return false
    end

    _rivalHubSaveState.writing = true
    _rivalHubSaveState.revision = _rivalHubSaveState.revision + 1
    local writeConfig = config
    writeConfig.revision = _rivalHubSaveState.revision
    writeConfig.savedAt = os.time()
    local json = HS:JSONEncode(writeConfig)
    local ok = false

    for attempt = 1, 3 do
        local attemptOk = pcall(function()
            if rivalHubFileExists(CONFIG_FILE) then
                local previous = readFn(CONFIG_FILE)
                if type(previous) == "string" then writeFn(CONFIG_FILE .. ".backup", previous) end
            end
            writeFn(CONFIG_FILE, json)
            local readBack = readFn(CONFIG_FILE)
            if readBack ~= json then error("save verification failed") end
            HS:JSONDecode(readBack)
        end)
        if attemptOk then
            ok = true
            break
        end
        if attempt < 3 then task.wait(0.1 * attempt) end
    end

    _rivalHubSaveState.writing = false
    if ok then
        _rivalHubSaveState.lastAt = _tick()
        _rivalHubSaveState.retryCount = 0
        _lastSavedJSON = canonicalJSON
        _rivalHubSaveState.dirty = false
        local latestOk, latest = pcall(function()
            local latestConfig = buildConfigTable()
            latestConfig.configVersion = 2
            latestConfig.userId = LP.UserId
            return HS:JSONEncode(latestConfig)
        end)
        if not latestOk or latest ~= _lastSavedJSON then
            _rivalHubSaveState.dirty = true
            scheduleRivalHubSave(0.25)
        end
    else
        _rivalHubSaveState.retryCount = _rivalHubSaveState.retryCount + 1
        warn("[Rival Hub Save] Write or verification failed; will retry.")
        scheduleRivalHubSave(math.min(2, 0.5 * _rivalHubSaveState.retryCount))
    end
    return ok
end

task.spawn(function()
    task.wait(5)
    while _G.RivalHubRunning do
        task.wait(2)
        if gui and main and not _isLoading then pcall(saveAllSettings) end
    end
end)
pcall(function()
    game:BindToClose(function()
        pcall(saveAllSettings, true)
    end)
end)

do
    local readFn, writeFn = resolveRivalHubFileApi()
    if readFn and writeFn then
        local legacyPaths = {"SCREAMHUB.json"}

        local okNew, _ = pcall(readFn, CONFIG_FILE)
        if not okNew then
            for _, oldPath in ipairs(legacyPaths) do
                local okOld, old = pcall(readFn, oldPath)
                if okOld and type(old) == "string" and #old > 0 then
                    pcall(writeFn, CONFIG_FILE, old)
                    warn("[Rival Hub] Config migrada de " .. oldPath .. " a " .. CONFIG_FILE)
                    break
                end
            end
        end
    end
end

function loadAllSettings()
    local readFn = resolveRivalHubFileApi()
    if not readFn or not rivalHubFileExists(CONFIG_FILE) then return false end
    local success, data = pcall(function() return HS:JSONDecode(readFn(CONFIG_FILE)) end)
    if not success or type(data) ~= "table" then return false end
    _isLoading = true

    local function num(v, fallback)
        local n = tonumber(v)
        if n == nil or n ~= n or n == math.huge or n == -math.huge then
            return fallback
        end
        return n
    end
    local function boolOr(v, fallback)
        if v == nil then return fallback end
        return v == true
    end

    NS                  = num(data.normalSpeed,       NS)
    CS                  = num(data.carrySpeed,        CS)
    LAGGER_SPEED        = num(data.laggerSpeed1,      LAGGER_SPEED)
    LAGGER_CARRY_SPEED  = num(data.laggerSpeed2,      LAGGER_CARRY_SPEED)
    CONFIG.STEAL_RANGE  = num(data.stealRadius,       CONFIG.STEAL_RANGE)
    CONFIG.HOLD_MIN     = num(data.holdMin,           CONFIG.HOLD_MIN)
    CONFIG.HOLD_MAX     = num(data.holdMax,           CONFIG.HOLD_MAX)
    CONFIG.ENTRY_DELAY  = num(data.entryDelay,        CONFIG.ENTRY_DELAY)
    CONFIG.COOLDOWN     = num(data.cooldown,          CONFIG.COOLDOWN)
    CONFIG.PRIME_RANGE  = num(data.primeRange,        CONFIG.PRIME_RANGE)

    if radInput then radInput.Text = tostring(CONFIG.STEAL_RANGE) end

    if num(data.configVersion, 1) >= 2 and data.lockUI ~= nil then
        uiLocked = boolOr(data.lockUI, false)
    else
        uiLocked = false
    end
    mobileButtonsLocked = false

    if data.antiRagdollMode then
        antiRagdollMode = tostring(data.antiRagdollMode)
    else
        antiRagdollMode = data.antiRagdoll and "v2" or "off"
    end
    antiDieEnabled = boolOr(data.antiDieEnabled, false)
    antiBatEnabled = boolOr(data.antiBat, false)
    antiFlingEnabled = boolOr(data.antiFling, false)
    CONFIG.AUTO_STEAL_ENABLED = boolOr(data.autoSteal, false)
    autoBatEnabled = boolOr(data.autoBat, false)
    do
        local v = tostring(data.batBypassVersion or ""):upper()
        if v == "V2" or v == "2" then
            batBypassVersion = "V2"
        else
            -- keep previous default only if missing; otherwise force V1 when explicitly saved as V1
            if data.batBypassVersion ~= nil then
                batBypassVersion = "V1"
            end
        end
        if batVersionLabel then
            batVersionLabel.Text = batBypassVersion
        end
    end
    autoLeftEnabled = boolOr(data.autoLeft, false)
    autoRightEnabled = boolOr(data.autoRight, false)
    setAutoStealMode(data.autoStealMode or "75")
    useVenixCarryEngine = boolOr(data.useVenixCarryEngine, false)
    ScreamVenixCarry.softStealSpeed = _clamp(num(data.softCarrySpeed, 30), 1, 500)
    ScreamVenixCarry.softStealRadius = _clamp(num(data.softCarryRadius, 10), 1, 200)
    ScreamVenixCarry:setSoftStealEnabled(boolOr(data.softCarry, false))
    ScreamUI.effects = boolOr(data.uiEffects, true)
    mobileButtonsLocked = boolOr(data.mobileButtonsLocked, false)
    if _G.__RivalHubRefreshSpeedEngine then pcall(_G.__RivalHubRefreshSpeedEngine) end
    InfiniteJump.mode = data.infiniteJumpMode == "manual" and "manual" or "hold"
    InfiniteJump.enabled = boolOr(data.infiniteJumpEnabled, false)
    medusaCounterEnabled = boolOr(data.medusaCounter, false)
    batCounterEnabled = boolOr(data.batCounter, false)
    batCounterV2Enabled = boolOr(data.batCounterV2, false)
    unwalkEnabled = boolOr(data.unwalkEnabled, boolOr(data.unwalk, false))
    antiLagEnabled = boolOr(data.antiLag, false)
    laggerToggled = boolOr(data.laggerToggled, false)
    speedMode = boolOr(data.carryMode, false)
    laggerCarryToggled = boolOr(data.laggerCarryToggled, false)
    uiScaleValue = _clamp(num(data.uiScale, 90), 50, 150)
    if mainUIScale then mainUIScale.Scale = uiScaleValue / 100 end
    if pbScale then pbScale.Scale = uiScaleValue / 100 end
    espEnabled = boolOr(data.espEnabled, false)
    espLineEnabled = boolOr(data.espLineEnabled, false)
    if espEnabled then pcall(toggleESP, true) else pcall(toggleESP, false) end

    vividGraphicsEnabled = boolOr(data.vividGraphics, false)
    hideButtonsEnabled = boolOr(data.hideButtons, false)
    katanaSkinEnabled = data.katanaSkinEnabled == true
    if katanaSkinSetVisual then katanaSkinSetVisual(katanaSkinEnabled) end
    if katanaSkinEnabled then
        task.defer(function() pcall(function() KatanaSkin.ApplySkin("KATANA") end) end)
    else
        -- ensure skin is off at boot unless user enabled it
        task.defer(function()
            pcall(function() KatanaSkin.ApplySkin("NONE") end)
            if _G.ShelSwordVisual and _G.ShelSwordVisual.clear then
                pcall(_G.ShelSwordVisual.clear)
            end
        end)
    end
    minecraftBatSkinEnabled = boolOr(data.minecraftBatSkinEnabled, false)
    minecraftBatSkinColorMode = tostring(data.minecraftBatSkinColorMode or "Default")
    if MinecraftBatColorSelector then MinecraftBatColorSelector.Text = minecraftBatSkinColorMode end
    if MinecraftBatSetVisual then MinecraftBatSetVisual(minecraftBatSkinEnabled) end
    if minecraftBatSkinEnabled then
        MinecraftBatSkin.State.enabled = true
        MinecraftBatSkin.SetColorMode(minecraftBatSkinColorMode)
        task.defer(function() pcall(MinecraftBatSkin.Apply) end)
    else
        MinecraftBatSkin.State.enabled = false
        task.defer(function() pcall(MinecraftBatSkin.Remove) end)
    end

    TPBatState.enabled = false

    currentColorTheme = COLOR_THEMES[data.themeColor] and data.themeColor or "Gray"
    selectedColor = COLOR_THEMES[currentColorTheme]
    task.defer(function() updateAllUIThemeColors(selectedColor) end)

    if data.rivalTitleTheme and RIVAL_TITLE_THEMES[data.rivalTitleTheme] then
        task.defer(function() applyRivalTitleTheme(data.rivalTitleTheme) end)
    end

    skyTheme = data.skyTheme or "Off"
    if skyTheme ~= "Off" then pcall(applyCustomSky, skyTheme) end
    if skySelectorLabel then skySelectorLabel.Text = skyTheme end
    if data.animPack and ANIM_PACKS[data.animPack] then
        pcall(startAnimPack, data.animPack)
    else
        currentAnimPack = "Off"
        stopAnimPack()
    end
    local function lk(e, d)
        if not d then return end
        e.kb = d.kb and Enum.KeyCode[d.kb] or nil
        e.gp = d.gp and Enum.KeyCode[d.gp] or nil
    end
    lk(KB.DropBrainrot, data.dropBrainrotKey)
    lk(KB.AutoLeft, data.autoLeftKey)
    lk(KB.AutoRight, data.autoRightKey)
    lk(KB.AutoBat, data.autoBatKey)
    lk(KB.TPFloor, data.tpFloorKey)
    lk(KB.GuiHide, data.guiHideKey)
    lk(KB.CarryToggle, data.carryToggleKey)
    lk(KB.LaggerMode, data.laggerModeKey)
    lk(KB.BatV2, data.batV2Key)
    lk(KB.InstaReset, data.instaResetKey)
    if data.mobileButtonPositions then savedButtonPositions = data.mobileButtonPositions end
    if data.mobilePanelPos then savedMobilePanelPos = data.mobilePanelPos end
    if data.mainPosition and main and type(data.mainPosition) == "table" then
        main.Position = UDim2.new(
            num(data.mainPosition.XScale, 0),
            num(data.mainPosition.XOffset, 20),
            num(data.mainPosition.YScale, 0),
            num(data.mainPosition.YOffset, 2)
        )
    end
    if data.progressBarPos and type(data.progressBarPos) == "table" then
        savedProgressBarPos = data.progressBarPos
    end
    if data.bodyLockEnabled ~= nil then
        bodyLockEnabled = boolOr(data.bodyLockEnabled, false)
        if bodyLockEnabled then
            task.defer(function()
                if bodyLockSetVisual then bodyLockSetVisual(true) end
                startBodyLock()
            end)
        end
    end
    if data.bodyLockRange ~= nil then
        bodyLockRange = _clamp(num(data.bodyLockRange, 20), 5, 200)
        if bodyLockRangeBox then bodyLockRangeBox.Text = tostring(bodyLockRange) end
    end
    dropMode = num(data.dropMode, 1)
    stretchEnabled = boolOr(data.stretchEnabled, false)
    stretchFOV = num(data.stretchFOV, 120)
    BAT_AIMBOT_SPEED = num(data.batAimbotSpeed, BAT_AIMBOT_SPEED)
    BYPASS_AIMBOT_SPEED = BAT_AIMBOT_SPEED
    if State then State.bypassBatSpeed = BYPASS_AIMBOT_SPEED end

    backgroundIndex = _clamp(_floor(num(data.backgroundIndex, 1)), 1, #backgroundImages)
    backgroundImageTransparency = _clamp(num(data.backgroundImageTransparency, 0), 0, 1)

    if data.backgroundMode == "None" then
        backgroundMode = "None"
    else
        local savedN = nil
        if type(data.backgroundMode) == "string" then
            savedN = tonumber(string.match(data.backgroundMode, "^Background%s+(%d+)$"))
        end
        if type(savedN) == "number" and savedN >= 1 and savedN <= #backgroundImages then
            backgroundIndex = savedN
        end
        backgroundMode = "Background " .. backgroundIndex
    end

    floatingButtonScale = _clamp(num(data.floatingButtonScale, 1), 0.5, 2)

    if type(data.outfitIndex) == "number"
       and type(OUTFITS) == "table"
       and #OUTFITS > 0
       and data.outfitIndex >= 1
       and data.outfitIndex <= #OUTFITS then
        currentOutfitIndex = data.outfitIndex
        task.defer(function()
            pcall(function() applyOutfitByIndex(currentOutfitIndex) end)
            if outfitSelectorLabel and OUTFITS[currentOutfitIndex] then
                outfitSelectorLabel.Text = OUTFITS[currentOutfitIndex].label
            end
        end)
    end

    if type(data.vx7AvatarIndex) == "number"
       and data.vx7AvatarIndex >= 1
       and data.vx7AvatarIndex <= #VX7A.labels - 1 then
        local _vx7Saved = data.vx7AvatarIndex
        task.defer(function()
            task.wait(1.5)
            pcall(VX7A.apply, _vx7Saved)
        end)
    end

    if vividGraphicsEnabled then
        task.defer(function() pcall(enableVividGraphics) end)
    else
        task.defer(function() pcall(disableVividGraphics) end)
    end
    if dropModeBtnRef then dropModeBtnRef.Text = dropMode == 1 and "Fling" or "Jump Drop" end
    refreshSpeedModeLabel()
    _lastSavedJSON = HS:JSONEncode(buildConfigTable())
    _isLoading = false

    if data.batV2 == true and _G.__RivalHubStartBatV2 then
        task.defer(function()
            pcall(_G.__RivalHubStartBatV2)
            if mobSetBatV2 then mobSetBatV2(true) end
        end)
    end

    return true
end

function forceResetUI()
    if normalBox then normalBox.Text = tostring(NS) end
    if carryBox then carryBox.Text = tostring(CS) end
    if radInput then radInput.Text = tostring(CONFIG.STEAL_RANGE) end
    if laggerBox then laggerBox.Text = tostring(LAGGER_SPEED) end
    if lagger2Box then lagger2Box.Text = tostring(LAGGER_CARRY_SPEED) end
    if batSpeedBox then batSpeedBox.Text = tostring(BYPASS_AIMBOT_SPEED) end
    if uiScaleBox then uiScaleBox.Text = tostring(uiScaleValue) end
    if dropModeBtnRef then dropModeBtnRef.Text = dropMode == 1 and "Fling" or "Jump Drop" end
    if bodyLockRangeBox then bodyLockRangeBox.Text = tostring(bodyLockRange) end
    local function safeSet(fn, val) if fn then fn(val) end end
    safeSet(autoBatSetVisual, false)
    safeSet(autoLeftSetVisual, false)
    safeSet(autoRightSetVisual, false)
    safeSet(setBatCounterVisual, false)
    safeSet(setBatCounterV2Visual, false)
    safeSet(setMedusaVisual, false)
    safeSet(setUnwalkVisual, false)
    safeSet(setAntiLagVisual, false)
    safeSet(setLockUIVisual, false)
    safeSet(setInstaGrab, false)
    safeSet(setESPVIsual, false)
    safeSet(setESPLineVisual, false)
    safeSet(setVividVisual, false)
    safeSet(setHideButtonsVisual, false)
    safeSet(bodyLockSetVisual, false)
    safeSet(setAntiDieVisual, false)
    safeSet(setAntiBatVisual, false)
    safeSet(setAntiFlingVisual, false)
    safeSet(setAntiRagVisual, false)
    safeSet(infJumpSetVisual, false)
    if autoStealModeBtn then autoStealModeBtn.Text = autoStealMode end
    if ScreamUI.motorLabel then ScreamUI.motorLabel.Text = "Direct" end
    if ScreamUI.carrySetter then ScreamUI.carrySetter(false) end
    if ScreamUI.effectsSetter then ScreamUI.effectsSetter(ScreamUI.effects) end
    if ScreamUI.lockButtonsSetter then ScreamUI.lockButtonsSetter(false) end
    applyBackgroundMode(backgroundMode)
    if _G.__RivalHubRefreshSpeedEngine then pcall(_G.__RivalHubRefreshSpeedEngine) end
    safeSet(mobSetBatV2, false)
    if _G.__RivalHubStopBatV2 then pcall(_G.__RivalHubStopBatV2) end
    disableVividGraphics()
    applyHideButtons(false)
    if _G.stretchToggleSetter then _G.stretchToggleSetter(false) end
    safeSet(mobSetAutoBat, false)
    safeSet(mobSetAutoLeft, false)
    safeSet(mobSetAutoRight, false)
    safeSet(mobSetDropBR, false)
    safeSet(mobSetTpDown, false)
    safeSet(mobSetCarry, false)
    safeSet(mobSetLagger1, false)
    safeSet(mobSetLagger2, false)
    refreshSpeedModeLabel()
    updateProgressBarVisibility()
    disableAntiLag()
    if stopAntiBat then stopAntiBat() end
    if stopAntiFling then stopAntiFling() end
    if stopESPLine then stopESPLine() end
    skyTheme = "Off"
    pcall(applyCustomSky, "Off")
    if skySelectorLabel then skySelectorLabel.Text = "Off" end
    if antiDieEnabled then
        AntiDieModule.stop()
        antiDieEnabled = false
    end
    for _, ref in ipairs(keyButtonRefs) do
        local entry = ref.entry
        local label = (entry.gp and entry.gp.Name) or (entry.kb and entry.kb.Name) or "None"
        ref.btn.Text = label
    end
    currentColorTheme = "Purple"
    selectedColor = COLOR_THEMES["Purple"]
    updateAllUIThemeColors(selectedColor)
    if miniBtn then
        local stroke = miniBtn:FindFirstChildOfClass("UIStroke")
        if stroke then stroke.Color = selectedColor end
    end
    if MobilePanel then
        for _, btn in ipairs(MobilePanel:GetChildren()) do
            if btn:IsA("TextButton") then
                local label = btn:FindFirstChildOfClass("TextLabel")
                if label then
                    local isActive = btn.BackgroundColor3 == selectedColor
                    if not isActive then label.TextColor3 = selectedColor end
                end
            end
        end
    end
    saveAllSettings()
end

function resetFloatingPositions()
    if MobilePanel then
        savedButtonPositions = {}
        for _, btn in ipairs(MobilePanel:GetChildren()) do
            if btn:IsA("TextButton") and btn.Name then
                local defX, defY = getDefaultButtonPosition(btn.Name)
                btn.Position = UDim2.new(0, defX, 0, defY)
            end
        end
    end
    if pbFrame then
        pbFrame.Position = UDim2.new(0.5, -186, 1, -134)
        savedProgressBarPos = nil
    end
    savedMobilePanelPos = nil
    if ScreamUI.fit then ScreamUI.fit() end
end

function resetToFactoryDefaults()
    _isResetting = true
    local ok, err = pcall(function()
        stopAutoSteal()
        stopBatCounter()
        if stopBatCounterV2 then stopBatCounterV2() end
        stopMedusaCounter()
        if AntiRagdollV2.Enabled then stopAntiRagdollV2() end
        if antiDieEnabled then AntiDieModule.stop() end
        if antiBatEnabled and stopAntiBat then stopAntiBat() end
        if antiFlingEnabled and stopAntiFling then stopAntiFling() end
        if _G.__RivalHubStopBatV2 then pcall(_G.__RivalHubStopBatV2) end
        stopUnwalk()
        InfiniteJump.stop()
        InfiniteJump.setMode("hold")
        disableAutoBat()
        stopBodyLock()
        if espEnabled then toggleESP(false) end
        if espLineEnabled and stopESPLine then stopESPLine() end
        if stretchEnabled then disableStretch() end
        if antiLagEnabled then disableAntiLag() end
        if vividGraphicsEnabled then disableVividGraphics() end
        if hideButtonsEnabled then applyHideButtons(false) end
        if dropActive then stopDropBrainrot() end
        skyTheme = "Off"
        pcall(applyCustomSky, "Off")
        if skySelectorLabel then skySelectorLabel.Text = "Off" end
        if antiDieEnabled then AntiDieModule.stop(); antiDieEnabled = false end
        NS = 60; CS = 29; LAGGER_SPEED = 15; LAGGER_CARRY_SPEED = 24.5
        CONFIG.STEAL_RANGE = 61
        CONFIG.HOLD_MIN = 0.05
        CONFIG.HOLD_MAX = 0.15
        CONFIG.ENTRY_DELAY = 0.1
        CONFIG.COOLDOWN = 0.2
        CONFIG.PRIME_RANGE = 60
        speedMode = false; laggerToggled = false; laggerCarryToggled = false
        antiRagdollMode = "off"; antiDieEnabled = false
        antiBatEnabled = false
        antiFlingEnabled = false
        medusaCounterEnabled = false; batCounterEnabled = false; batCounterV2Enabled = false
        autoBatEnabled = false; autoLeftEnabled = false; autoRightEnabled = false
        unwalkEnabled = false; antiLagEnabled = false
        uiLocked = false; mobileButtonsLocked = false
        CONFIG.AUTO_STEAL_ENABLED = false
        setAutoStealMode("75")
        useVenixCarryEngine = false
        ScreamVenixCarry:stop()
        ScreamVenixCarry.softStealEnabled = false
        ScreamVenixCarry.softStealSpeed = 30
        ScreamVenixCarry.softStealRadius = 10
        ScreamUI.effects = true
        if _G._rivalHubStealModeSetter then pcall(_G._rivalHubStealModeSetter, "V1") end
        BAT_AIMBOT_SPEED = 55
        BYPASS_AIMBOT_SPEED = BAT_AIMBOT_SPEED
        if State then State.bypassBatSpeed = BYPASS_AIMBOT_SPEED end
        batBypassVersion = "V1"
        if batVersionLabel then batVersionLabel.Text = "V1" end
        dropMode = 1; stretchEnabled = false; stretchFOV = 120
        uiScaleValue = 90
        if ScreamUI.fit then ScreamUI.fit() end
        if pbScale then pbScale.Scale = 1 end
        espEnabled = false; espLineEnabled = false; vividGraphicsEnabled = false; hideButtonsEnabled = false
        katanaSkinEnabled = false
        if katanaSkinSetVisual then katanaSkinSetVisual(false) end
        pcall(function() KatanaSkin.ApplySkin("NONE") end)
        minecraftBatSkinEnabled = false; minecraftBatSkinColorMode = "Default"
        if MinecraftBatSkin then
            MinecraftBatSkin.State.enabled = false
            MinecraftBatSkin.State.colorMode = "Default"
            pcall(MinecraftBatSkin.Remove)
        end
        if MinecraftBatSetVisual then MinecraftBatSetVisual(false) end
        if MinecraftBatColorSelector then MinecraftBatColorSelector.Text = "Default" end
        bodyLockEnabled = false; bodyLockRange = 20
        backgroundIndex = 1; backgroundImageTransparency = 0; backgroundMode = "Background 1"
        floatingButtonScale = 1
        currentAnimPack = "Off"; stopAnimPack()
        currentOutfitIndex = 1
        pcall(VX7A.stop)
        currentColorTheme = "Purple"; selectedColor = COLOR_THEMES["Purple"]
        currentRivalTitleTheme = "Purple"
        applyRivalTitleTheme("Purple")
        if main then main.Position = UDim2.new(0, 20, 0, 2); _G.__RivalHubMainOriginalPos = main.Position end
        for key, val in pairs(DEFAULT_KB) do
            if KB[key] then KB[key].kb = val.kb; KB[key].gp = val.gp end
        end
        resetFloatingPositions()
        forceResetUI()
        updateProgressBarVisibility()
        refreshSpeedModeLabel()
        _lastSavedJSON = nil
    end)
    _isResetting = false
    if not ok then warn("[resetToFactoryDefaults]", err) end
    if ok then saveAllSettings(true) end
    return ok
end

function updateProgressBarVisibility()
    if pbFrame then pbFrame.Visible = true end
end

function applyShimmerToText(obj, speed, baseColor)
    speed = speed or 0.8
    local color = baseColor or Color3.fromRGB(215, 215, 225)
    local grad = Instance.new("UIGradient", obj)
    grad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, color),
        ColorSequenceKeypoint.new(0.3, color:Lerp(Color3.new(0.15,0.15,0.15), 0.25)),
        ColorSequenceKeypoint.new(0.5, color:Lerp(Color3.new(1,1,1), 0.55)),
        ColorSequenceKeypoint.new(0.7, color:Lerp(Color3.new(0.15,0.15,0.15), 0.25)),
        ColorSequenceKeypoint.new(1, color),
    })
    grad.Rotation = 45
    grad.Offset = Vector2.new(0,0)
    task.spawn(function()
        local t = 0
        while grad and grad.Parent do
            t = t + 0.02
            grad.Offset = Vector2.new(math.sin(t * speed) * 0.4, 0)
            grad.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0.00, color),
                ColorSequenceKeypoint.new(0.30, color:Lerp(Color3.new(0.15,0.15,0.15), 0.25)),
                ColorSequenceKeypoint.new(0.50, color:Lerp(Color3.new(1,1,1), 0.55)),
                ColorSequenceKeypoint.new(0.70, color:Lerp(Color3.new(0.15,0.15,0.15), 0.25)),
                ColorSequenceKeypoint.new(1.00, color),
            })
            task.wait(0.04)
        end
    end)
    return grad
end

function getDefaultButtonPosition(name)
    -- 3x3 grid, far LEFT, above cash HUD + steal bar
    local map = {DropBR = 0, AutoLeft = 1, AutoBat = 2, AutoRight = 3, TpDown = 4, Carry = 5, Lagger1 = 6, Lagger2 = 7, BatV2 = 8}
    local index = map[name] or 0
    local cam = Workspace.CurrentCamera
    local size = cam and cam.ViewportSize or Vector2.new(844, 390)
    local btn = 64 * (floatingButtonScale or 1)
    local gap = 6
    local spacing = btn + gap
    local cols = 3
    local rows = 3
    -- far left edge
    local startX = 6
    -- sit above bottom cash / steal bar zone
    local bottomClear = 170
    local startY = math.max(90, size.Y - spacing * rows - bottomClear)
    return startX + (index % cols) * spacing, startY + _floor(index / cols) * spacing
end

local function tpBatDisconnectAntiDie()
    for _, conn in ipairs(TPBatState.antiDieConnections) do
        pcall(function() conn:Disconnect() end)
    end
    TPBatState.antiDieConnections = {}
end

local function tpBatHookAntiDie(character)
    tpBatDisconnectAntiDie()
    if not TPBatState.enabled or not character then return end
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end
    pcall(function()
        humanoid.BreakJointsOnDeath = false
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Dying, false)
    end)
    local _antiDieCooldown = false
    table.insert(TPBatState.antiDieConnections,
        humanoid:GetPropertyChangedSignal("Health"):Connect(function()
            if _antiDieCooldown then return end
            if TPBatState.enabled and humanoid.Parent and humanoid.Health <= 0 then
                _antiDieCooldown = true
                task.defer(function()
                    pcall(function()
                        if humanoid and humanoid.Parent then
                            humanoid.Health = humanoid.MaxHealth
                            humanoid:ChangeState(Enum.HumanoidStateType.Running)
                        end
                    end)
                    task.wait(0.5)
                    _antiDieCooldown = false
                end)
            end
        end)
    )
end

local function tpBatFindBat()
    local character = LP.Character
    if not character then return nil end
    local function isBat(tool)
        if not tool:IsA("Tool") then return false end
        local name = tool.Name:lower()
        return name:find("bat") ~= nil or name:find("slap") ~= nil
    end
    for _, child in ipairs(character:GetChildren()) do
        if isBat(child) then return child end
    end
    local backpack = LP:FindFirstChildOfClass("Backpack")
    if not backpack then return nil end
    for _, child in ipairs(backpack:GetChildren()) do
        if isBat(child) then
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                pcall(function() humanoid:EquipTool(child) end)
            end
            return child
        end
    end
    return nil
end

local function tpBatSwing()
    if TPBatState.hitCooldown then return end
    TPBatState.hitCooldown = true
    pcall(function()
        local bat = tpBatFindBat()
        if not bat then return end
        bat:Activate()
        local ev = bat:FindFirstChildWhichIsA("RemoteEvent", true)
        if ev then pcall(function() ev:FireServer() end) end
    end)
    task.delay(0.05, function()
        TPBatState.hitCooldown = false
    end)
end

local function tpBatTick()
    if not TPBatState.enabled then return end
    local character = LP.Character
    if not character then return end
    local root = character:FindFirstChild("HumanoidRootPart")
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not root or not humanoid or humanoid.Health <= 0 then return end

    local closestPlayer, closestDistance = nil, math.huge
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LP and player.Character then
            local targetRoot = player.Character:FindFirstChild("HumanoidRootPart")
            local targetHumanoid = player.Character:FindFirstChildOfClass("Humanoid")
            if targetRoot and targetHumanoid and targetHumanoid.Health > 0 then
                local distance = (root.Position - targetRoot.Position).Magnitude
                if distance < closestDistance then
                    closestDistance = distance
                    closestPlayer = player
                end
            end
        end
    end

    if not closestPlayer or closestDistance > 100 then return end
    local targetRoot = closestPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not targetRoot then return end

    -- TP suave con Lerp + zerear velocidad en cada frame para no salir volando
    local targetPos = targetRoot.Position + Vector3.new(0, 0.9, 0)
    if closestDistance > 5 then
        root.CFrame = CFrame.new(targetPos, targetRoot.Position)
    elseif closestDistance > 2 then
        root.CFrame = CFrame.new(root.Position:Lerp(targetPos, 0.35), targetRoot.Position)
    end

    pcall(function()
        root.AssemblyLinearVelocity = Vector3.zero
        root.AssemblyAngularVelocity = Vector3.zero
    end)

    local cam = workspace.CurrentCamera
    if cam then
        cam.CFrame = CFrame.new(cam.CFrame.Position, targetRoot.Position + Vector3.new(0, 0.5, 0))
    end

    tpBatSwing()
end

function tpBatSetEnabled(value)
    TPBatState.enabled = value == true
    if TPBatState.enabled then
        tpBatHookAntiDie(LP.Character)
        if TPBatState.connection then
            TPBatState.connection:Disconnect()
            TPBatState.connection = nil
        end
        TPBatState.connection = RunService.Heartbeat:Connect(tpBatTick)
    else
        if TPBatState.connection then
            TPBatState.connection:Disconnect()
            TPBatState.connection = nil
        end
        tpBatDisconnectAntiDie()
        local character = LP.Character
        local root = character and character:FindFirstChild("HumanoidRootPart")
        if root then
            pcall(function()
                if root.SetNetworkOwner then root:SetNetworkOwner(LP) end
            end)
        end
    end
end

LP.CharacterAdded:Connect(function(character)
    if TPBatState.enabled then
        task.wait(0.1)
        tpBatHookAntiDie(character)
    end
end)



function buildGui()
    local SoundService = game:GetService("SoundService")
    -- Sons UI préchargés (style hub) — ON = aigu, OFF = grave
    local UI_SOUND_IDS = {
        click  = "rbxassetid://6042053626",
        on     = "rbxassetid://9125713900",
        off    = "rbxassetid://9119713951",
        select = "rbxassetid://6895079853",
        tab    = "rbxassetid://6042053626",
    }
    local _uiSoundPool = {}
    local function getUiSound(kind)
        local id = UI_SOUND_IDS[kind] or UI_SOUND_IDS.click
        local s = _uiSoundPool[kind]
        if not s or not s.Parent then
            s = Instance.new("Sound")
            s.Name = "ScreamUI_" .. tostring(kind)
            s.SoundId = id
            s.Volume = 0.55
            s.RollOffMaxDistance = 10000
            s.Parent = SoundService
            _uiSoundPool[kind] = s
            pcall(function() s:Load() end)
        end
        return s
    end
    local function playUiSound(kind, onState)
        -- kind: "click" | "toggle" | "select" | "tab"
        -- onState: true/false for toggle (optional)
        local k = kind
        local speed = 1
        local vol = 0.55
        if kind == "toggle" then
            if onState == true then
                k = "on"
                speed = 1.05
                vol = 0.65
            elseif onState == false then
                k = "off"
                speed = 0.9
                vol = 0.5
            else
                k = "on"
            end
        elseif kind == "select" then
            k = "select"
            speed = 1.1
            vol = 0.5
        elseif kind == "tab" then
            k = "tab"
            speed = 1.2
            vol = 0.4
        else
            k = "click"
            speed = 1
            vol = 0.45
        end
        local ok, err = pcall(function()
            local s = getUiSound(k)
            s.PlaybackSpeed = speed
            s.Volume = vol
            s.TimePosition = 0
            if s.IsPlaying then s:Stop() end
            s:Play()
        end)
        if not ok then
            -- fallback one-shot
            pcall(function()
                local s = Instance.new("Sound")
                s.SoundId = UI_SOUND_IDS[k] or UI_SOUND_IDS.click
                s.Volume = vol
                s.PlaybackSpeed = speed
                s.Parent = SoundService
                s:Play()
                task.delay(1.5, function() pcall(function() s:Destroy() end) end)
            end)
        end
    end
    _G.__ScreamPlayUiSound = playUiSound

    local ROW_BG = ScreamFX.ROW
    local ROW_BORDER = ScreamFX.BORDER
    local WHITE = ScreamFX.TEXT
    local INP = ScreamFX.INPUT
    local GRAY = ScreamFX.MUTED
    local GRAY_ACTIVE = Color3.fromRGB(40, 28, 62)
    local GUI_W, GUI_H = 470, 570
    for _, parent in ipairs({CoreGui, pgui}) do
        for _, name in ipairs({"RivalHub", "RivalHubMobilePanel", "RivalHubSpeedIndicator", "RivalHubBootErrors"}) do
            pcall(function() local old = parent:FindFirstChild(name); if old then old:Destroy() end end)
        end
    end
    gui = ScreamUI.new("ScreenGui", nil, {Name = "RivalHub", ResetOnSpawn = false,
        IgnoreGuiInset = true, DisplayOrder = 30, ZIndexBehavior = Enum.ZIndexBehavior.Sibling})
    pcall(function() if syn and syn.protect_gui then syn.protect_gui(gui) end end)
    local ok = pcall(function() gui.Parent = CoreGui end)
    if not ok then gui.Parent = pgui end

    -- Halo lumineux derrière la fenêtre (suit sa position / taille)
    local glow = ScreamUI.new("Frame", gui, {Name = "FXMainGlow", BackgroundTransparency = 1,
        BorderSizePixel = 0, Active = false, ZIndex = 0})
    ScreamUI.round(glow, 24)
    ScreamUI.glowStroke = ScreamUI.stroke(glow, getThemeColor(), 0.62, 6)
    ScreamFX.accent(ScreamUI.glowStroke, function(o, c) o.Color = c end)
    local glowInner = ScreamUI.new("Frame", glow, {Name = "FXGlowInner", Position = UDim2.fromOffset(4, 4),
        Size = UDim2.new(1, -8, 1, -8), BackgroundTransparency = 1, BorderSizePixel = 0, ZIndex = 0})
    ScreamUI.round(glowInner, 20)
    ScreamUI.glowInnerStroke = ScreamUI.stroke(glowInner, getThemeColor(), 0.4, 2)
    ScreamFX.accent(ScreamUI.glowInnerStroke, function(o, c) o.Color = c end)
    ScreamUI.glowAlpha = 1

    main = ScreamUI.new("Frame", gui, {Name = "Main", Size = UDim2.fromOffset(GUI_W, GUI_H),
        Position = UDim2.fromOffset(18, 16), BackgroundColor3 = ScreamFX.BG,
        BorderSizePixel = 0, ClipsDescendants = true, Active = true, ZIndex = 1})
    ScreamUI.round(main, 18)
    local border = ScreamUI.stroke(main, getThemeColor(), 0.2, 1.4)
    border.Name = "MainBorder"
    ScreamUI.borderGrad = ScreamUI.new("UIGradient", border, {Name = "BorderShine", Rotation = 0,
        Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(0.35, 0.7),
            NumberSequenceKeypoint.new(0.65, 0.7), NumberSequenceKeypoint.new(1, 0)})})
    mainUIScale = ScreamUI.new("UIScale", main, {Scale = uiScaleValue / 100})
    local bg = ScreamUI.new("ImageLabel", main, {Name = "BackgroundImage", Size = UDim2.fromScale(1, 1),
        Image = "rbxassetid://" .. backgroundImages[backgroundIndex], ImageTransparency = backgroundImageTransparency,
        BackgroundTransparency = 1, ScaleType = Enum.ScaleType.Crop, ZIndex = 0})
    ScreamUI.round(bg, 18)
    local veil = ScreamUI.new("Frame", main, {Name = "BackgroundVeil", Size = UDim2.fromScale(1, 1),
        BackgroundColor3 = Color3.fromRGB(8, 6, 14), BackgroundTransparency = 0.16, BorderSizePixel = 0, ZIndex = 2})
    ScreamUI.new("UIGradient", veil, {Rotation = 35, Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.02), NumberSequenceKeypoint.new(0.6, 0.18), NumberSequenceKeypoint.new(1, 0.06)})})
    ScreamUI.round(veil, 18)
    local tint = ScreamUI.new("Frame", main, {Name = "AccentTint", Size = UDim2.fromScale(1, 1),
        BackgroundColor3 = getThemeColor(), BackgroundTransparency = 0.9, BorderSizePixel = 0, ZIndex = 2})
    ScreamUI.round(tint, 18)
    ScreamUI.new("UIGradient", tint, {Rotation = 90, Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.55), NumberSequenceKeypoint.new(0.5, 1), NumberSequenceKeypoint.new(1, 0.4)})})
    ScreamFX.accent(tint, function(o, c) o.BackgroundColor3 = c end)
    local innerBorder = ScreamUI.new("Frame", main, {Name = "PanelInset", Position = UDim2.fromOffset(3, 3),
        Size = UDim2.new(1, -6, 1, -6), BackgroundTransparency = 1, BorderSizePixel = 0, ZIndex = 3})
    ScreamUI.round(innerBorder, 15)
    ScreamUI.stroke(innerBorder, Color3.fromRGB(150, 120, 210), 0.9, 1)
    local topLight = ScreamUI.new("Frame", main, {Name = "TopLight", Position = UDim2.fromOffset(28, 1),
        Size = UDim2.new(1, -56, 0, 1), BackgroundColor3 = getThemeColor(), BorderSizePixel = 0, ZIndex = 4})
    ScreamUI.new("UIGradient", topLight, {Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.5, 0.1), NumberSequenceKeypoint.new(1, 1)})})
    ScreamFX.accent(topLight, function(o, c) o.BackgroundColor3 = c end)
    local header = ScreamUI.new("Frame", main, {Name = "ScriptHeader", Position = UDim2.fromOffset(14, 8),
        Size = UDim2.new(1, -28, 0, 68), BackgroundColor3 = ScreamFX.PANEL,
        BorderSizePixel = 0, ClipsDescendants = true, ZIndex = 5})
    ScreamUI.round(header, 14)
    local headerStroke = ScreamUI.stroke(header, getThemeColor(), 0.6, 1)
    ScreamFX.accent(headerStroke, function(o, c) o.Color = c end)
    ScreamUI.art = ScreamUI.new("ImageLabel", header, {Name = "Scene", Size = UDim2.fromScale(1, 1),
        Image = bg.Image, ImageTransparency = 0.28, BackgroundTransparency = 1, ScaleType = Enum.ScaleType.Crop, ZIndex = 5})
    local shade = ScreamUI.new("Frame", header, {Name = "ArtworkShade", Size = UDim2.fromScale(1, 1), BorderSizePixel = 0,
        BackgroundColor3 = Color3.fromRGB(10, 6, 18), BackgroundTransparency = 0.08, ZIndex = 6})
    ScreamUI.new("UIGradient", shade, {Rotation = 0, Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.02), NumberSequenceKeypoint.new(0.55, 0.25), NumberSequenceKeypoint.new(1, 0.75)})})
    scriptLogoRef = ScreamUI.text(header, "SCREAMHUB", UDim2.fromOffset(14, 8), UDim2.fromOffset(280, 40), 30, WHITE, 8)
    scriptLogoRef.Font = Enum.Font.GothamBlack
    scriptLogoRef.TextTruncate = Enum.TextTruncate.None
    scriptLogoRef.TextScaled = false
    ScreamUI.titleGradient = ScreamUI.new("UIGradient", scriptLogoRef, {Rotation = 90,
        Color = ColorSequence.new(Color3.fromRGB(225, 200, 255), Color3.fromRGB(140, 80, 240))})
    local titleLine = ScreamUI.new("Frame", header, {Name = "TitleLine", Position = UDim2.fromOffset(16, 48),
        Size = UDim2.fromOffset(54, 2), BackgroundColor3 = getThemeColor(), BorderSizePixel = 0, ZIndex = 8})
    ScreamUI.round(titleLine, 2)
    ScreamUI.new("UIGradient", titleLine, {Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(1, 1)})})
    ScreamFX.accent(titleLine, function(o, c) o.BackgroundColor3 = c end)
    local subtitle = ScreamUI.text(header, "PREMIUM HUB", UDim2.fromOffset(78, 42), UDim2.fromOffset(120, 14), 8,
        Color3.fromRGB(176, 158, 214), 8)
    subtitle.Name = "Subtitle"
    subtitle.Font = Enum.Font.GothamBold

    local close = ScreamUI.new("TextButton", main, {Name = "Close", Size = UDim2.fromOffset(28, 28),
        AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(1, -34, 0, 42), Text = "−", TextSize = 20,
        Font = Enum.Font.GothamMedium, TextColor3 = WHITE, BackgroundColor3 = INP, BackgroundTransparency = 0.05,
        BorderSizePixel = 0, AutoButtonColor = false, ZIndex = 18})
    ScreamUI.round(close, 9)
    local closeStroke = ScreamUI.stroke(close, ROW_BORDER, 0.3, 1)
    ScreamFX.press(close)
    close.MouseEnter:Connect(function()
        ScreamFX.tween(close, 0.16, {BackgroundColor3 = getThemeColor()})
        ScreamFX.tween(closeStroke, 0.16, {Color = getThemeColor(), Transparency = 0})
    end)
    close.MouseLeave:Connect(function()
        ScreamFX.tween(close, 0.2, {BackgroundColor3 = INP})
        ScreamFX.tween(closeStroke, 0.2, {Color = ROW_BORDER, Transparency = 0.3})
    end)
    miniBtn = ScreamUI.new("TextButton", gui, {Name = "MinimizedFrame", Size = UDim2.fromOffset(150, 46),
        Position = UDim2.fromOffset(16, 58), Text = "", BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BorderSizePixel = 0, AutoButtonColor = false, Visible = false, ZIndex = 25})
    ScreamUI.round(miniBtn, 12)
    local miniStroke = ScreamUI.stroke(miniBtn, getThemeColor(), 0.25, 1.3)
    ScreamUI.new("UIGradient", miniBtn, {Rotation = 0, Color = ColorSequence.new(Color3.fromRGB(34, 22, 56), Color3.fromRGB(11, 8, 18))})
    local miniAccent = ScreamUI.new("Frame", miniBtn, {Name = "Accent", Position = UDim2.fromOffset(10, 10),
        Size = UDim2.fromOffset(4, 26), BackgroundColor3 = getThemeColor(), BorderSizePixel = 0, ZIndex = 26})
    ScreamUI.round(miniAccent, 2)
    ScreamFX.accent(miniAccent, function(o, c) o.BackgroundColor3 = c end)
    local miniTitle = ScreamUI.text(miniBtn, "SCREAMHUB", UDim2.fromOffset(22, 7), UDim2.fromOffset(100, 22), 14, WHITE, 28)
    miniTitle.Font = Enum.Font.GothamBlack
    miniTitle.TextTruncate = Enum.TextTruncate.None
    local miniHint = ScreamUI.text(miniBtn, "TAP TO OPEN", UDim2.fromOffset(22, 25), UDim2.fromOffset(100, 14), 8,
        Color3.fromRGB(170, 150, 210), 28)
    miniHint.Font = Enum.Font.GothamBold
    local miniArrow = ScreamUI.text(miniBtn, "›", UDim2.new(1, -24, 0, 8), UDim2.fromOffset(17, 30), 22, WHITE, 28)
    miniArrow.Name = "Arrow"
    miniBtn.MouseEnter:Connect(function()
        ScreamFX.tween(miniArrow, 0.25, {Position = UDim2.new(1, -19, 0, 8)}, Enum.EasingStyle.Back)
        ScreamFX.tween(miniStroke, 0.2, {Transparency = 0})
    end)
    miniBtn.MouseLeave:Connect(function()
        ScreamFX.tween(miniArrow, 0.25, {Position = UDim2.new(1, -24, 0, 8)})
        ScreamFX.tween(miniStroke, 0.2, {Transparency = 0.25})
    end)
    miniBackgroundImage = nil

    -- Rideau utilisé pendant l'animation d'ouverture / fermeture de la fenêtre
    local curtain = ScreamUI.new("Frame", main, {Name = "FXCurtain", Size = UDim2.fromScale(1, 1),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255), BackgroundTransparency = 1, BorderSizePixel = 0,
        Visible = false, Active = false, ZIndex = 200})
    ScreamUI.round(curtain, 18)
    ScreamUI.new("UIGradient", curtain, {Rotation = 90, Color = ColorSequence.new(Color3.fromRGB(34, 18, 60), Color3.fromRGB(8, 6, 14))})
    local fxAlpha = ScreamUI.new("NumberValue", main, {Name = "FXAlpha", Value = 1})

    local function syncGlow()
        if not glow.Parent or not main.Parent then return end
        glow.Visible = main.Visible
        local p, s = main.AbsolutePosition, main.AbsoluteSize
        glow.Position = UDim2.fromOffset(p.X - 5, p.Y - 5)
        glow.Size = UDim2.fromOffset(s.X + 10, s.Y + 10)
        local a = math.clamp(ScreamUI.glowAlpha or 1, 0, 1)
        if ScreamUI.glowInnerStroke then ScreamUI.glowInnerStroke.Transparency = 1 - 0.6 * a end
        if ScreamUI.glowStroke and not ScreamUI.effects then ScreamUI.glowStroke.Transparency = 1 - 0.38 * a end
    end
    main:GetPropertyChangedSignal("AbsolutePosition"):Connect(syncGlow)
    main:GetPropertyChangedSignal("AbsoluteSize"):Connect(syncGlow)
    main:GetPropertyChangedSignal("Visible"):Connect(syncGlow)
    task.defer(syncGlow)

    local animating, animationId, tween = false, 0, nil
    local function applyAlpha(a)
        local target = ScreamUI.animBaseScale or mainUIScale.Scale
        local k = 0.9 + 0.1 * a
        mainUIScale.Scale = target * k
        local base = _G.__RivalHubMainOriginalPos or main.Position
        local w, h = (ScreamUI.width or GUI_W) * target, (ScreamUI.height or GUI_H) * target
        local lift = (1 - math.clamp(a, 0, 1)) * 12
        main.Position = UDim2.new(base.X.Scale, base.X.Offset + w * (1 - k) / 2,
            base.Y.Scale, base.Y.Offset + h * (1 - k) / 2 + lift)
        curtain.BackgroundTransparency = math.clamp(a, 0, 1)
        ScreamUI.glowAlpha = math.clamp(a, 0, 1)
        syncGlow()
    end
    fxAlpha.Changed:Connect(function(value)
        if animating then applyAlpha(value) end
    end)
    local function finishAnim(open)
        animating = false
        ScreamUI.mainAnimating = false
        curtain.Visible = false
        curtain.BackgroundTransparency = 1
        fxAlpha.Value = open and 1 or 0
        if ScreamUI.animBaseScale then mainUIScale.Scale = ScreamUI.animBaseScale end
        if _G.__RivalHubMainOriginalPos then main.Position = _G.__RivalHubMainOriginalPos end
        main.Size = UDim2.fromOffset(ScreamUI.width or GUI_W, ScreamUI.height or GUI_H)
        ScreamUI.glowAlpha = open and 1 or 0
        main.Visible = open
        syncGlow()
        if not open then
            miniBtn.Visible = true
            ScreamFX.pop(miniBtn, true)
        end
    end
    local function animate(open)
        animationId = animationId + 1
        local thisId = animationId
        if tween then tween:Cancel() end
        ScreamUI.guiOpen = open
        if not animating then
            ScreamUI.animBaseScale = mainUIScale.Scale
            animating = true
            fxAlpha.Value = open and 0 or 1
        end
        animating = true
        ScreamUI.mainAnimating = true
        curtain.Visible = true
        main.Visible = true
        if open and miniBtn.Visible then
            ScreamFX.pop(miniBtn, false, function()
                if ScreamUI.guiOpen then miniBtn.Visible = false end
            end)
            if not ScreamFX.enabled() then miniBtn.Visible = false end
        end
        applyAlpha(fxAlpha.Value)
        if not ScreamFX.enabled() then
            finishAnim(open)
            return
        end
        tween = TS:Create(fxAlpha, open and TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
            or TweenInfo.new(0.24, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {Value = open and 1 or 0})
        tween.Completed:Connect(function()
            if thisId ~= animationId or not main.Parent then return end
            finishAnim(open)
        end)
        tween:Play()
        if open and ScreamUI.activeTab and ScreamUI.pages then
            local page = ScreamUI.pages[ScreamUI.activeTab]
            if page then task.delay(0.08, function() ScreamFX.staggerPage(page) end) end
        end
    end
    showGui = function() animate(true) end
    hideGui = function() animate(false) end
    ScreamUI.guiOpen = true
    close.Activated:Connect(hideGui)
    miniBtn.Activated:Connect(showGui)
    _G.__RivalHubMainOriginalPos = main.Position
    main:GetPropertyChangedSignal("Position"):Connect(function()
        if not animating then _G.__RivalHubMainOriginalPos = main.Position end
    end)
    drag(main, 80)

    -- Barre d'onglets : indicateur glissant + liste des boutons
    local tabBar = ScreamUI.new("Frame", main, {Name = "Navigation", Size = UDim2.new(0, 68, 0, 326),
        Position = UDim2.fromOffset(14, 120), BackgroundColor3 = ScreamFX.PANEL,
        BackgroundTransparency = 0.08, BorderSizePixel = 0, ZIndex = 14})
    ScreamUI.round(tabBar, 16)
    ScreamUI.stroke(tabBar, ROW_BORDER, 0.45, 1)
    local tabIndicator = ScreamUI.new("Frame", tabBar, {Name = "FXTabIndicator", Size = UDim2.fromOffset(56, 48),
        Position = UDim2.fromOffset(6, 6), BackgroundColor3 = getThemeColor(), BackgroundTransparency = 0.8,
        BorderSizePixel = 0, ZIndex = 15})
    ScreamUI.round(tabIndicator, 11)
    local indicatorStroke = ScreamUI.stroke(tabIndicator, getThemeColor(), 0.3, 1.2)
    ScreamUI.new("UIGradient", tabIndicator, {Rotation = 90, Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(1, 0.6)})})
    local indicatorBar = ScreamUI.new("Frame", tabIndicator, {Name = "FXBar", AnchorPoint = Vector2.new(0, 0.5),
        Position = UDim2.new(0, 0, 0.5, 0), Size = UDim2.fromOffset(3, 22), BackgroundColor3 = getThemeColor(),
        BorderSizePixel = 0, ZIndex = 16})
    ScreamUI.round(indicatorBar, 2)
    ScreamFX.accent(tabIndicator, function(o, c)
        o.BackgroundColor3 = c
        indicatorStroke.Color = c
        indicatorBar.BackgroundColor3 = c
    end)
    local tabList = ScreamUI.new("Frame", tabBar, {Name = "TabList", Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1, BorderSizePixel = 0, ZIndex = 16})
    ScreamUI.new("UIListLayout", tabList, {FillDirection = Enum.FillDirection.Vertical,
        HorizontalAlignment = Enum.HorizontalAlignment.Center, VerticalAlignment = Enum.VerticalAlignment.Top,
        Padding = UDim.new(0, 5), SortOrder = Enum.SortOrder.LayoutOrder})
    ScreamUI.new("UIPadding", tabList, {PaddingTop = UDim.new(0, 6), PaddingBottom = UDim.new(0, 6), PaddingLeft = UDim.new(0, 5), PaddingRight = UDim.new(0, 5)})
    local headingPanel = ScreamUI.new("Frame", main, {Name = "SectionPanel", Position = UDim2.fromOffset(92, 85),
        Size = UDim2.new(1, -106, 0, 27), BackgroundColor3 = ScreamFX.PANEL,
        BackgroundTransparency = 0.12, BorderSizePixel = 0, ZIndex = 6})
    ScreamUI.round(headingPanel, 8)
    ScreamUI.stroke(headingPanel, ROW_BORDER, 0.82, 1)
    local pageHeading = ScreamUI.text(main, "01   /   MOVEMENT", UDim2.fromOffset(103, 87), UDim2.new(1, -122, 0, 23), 11, WHITE, 8)
    pageHeading.Name = "SectionHeading"
    pageHeading.Font = Enum.Font.GothamBold
    local headingRule = ScreamUI.new("Frame", main, {Position = UDim2.fromOffset(98, 114),
        Size = UDim2.new(1, -112, 0, 1), BackgroundColor3 = ROW_BORDER, BackgroundTransparency = 0.48, BorderSizePixel = 0, ZIndex = 7})
    local tabContent = ScreamUI.new("Frame", main, {Name = "Content", Size = UDim2.new(1, -108, 1, -160),
        Position = UDim2.fromOffset(94, 120), BackgroundTransparency = 1, ClipsDescendants = true, ZIndex = 6})
    local footer = ScreamUI.new("Frame", main, {Name = "Footer", Position = UDim2.new(0, 14, 1, -34),
        Size = UDim2.new(1, -28, 0, 25), BackgroundTransparency = 1, ZIndex = 8})
    local footerRule = ScreamUI.new("Frame", footer, {Size = UDim2.new(1, 0, 0, 1), BackgroundColor3 = getThemeColor(),
        BackgroundTransparency = 0.5, BorderSizePixel = 0, ZIndex = 8})
    ScreamUI.new("UIGradient", footerRule, {Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.5, 0.2), NumberSequenceKeypoint.new(1, 1)})})
    ScreamFX.accent(footerRule, function(o, c) o.BackgroundColor3 = c end)
    local avatar = ScreamUI.new("ImageLabel", footer, {Position = UDim2.fromOffset(2, 6), Size = UDim2.fromOffset(17, 17),
        Image = "rbxthumb://type=AvatarHeadShot&id=" .. LP.UserId .. "&w=150&h=150", BackgroundColor3 = INP, BorderSizePixel = 0, ZIndex = 8})
    ScreamUI.round(avatar, 9)
    local avatarStroke = ScreamUI.stroke(avatar, getThemeColor(), 0.2, 1)
    ScreamFX.accent(avatarStroke, function(o, c) o.Color = c end)
    ScreamUI.text(footer, "@" .. LP.Name, UDim2.fromOffset(27, 5), UDim2.new(0.5, -32, 0, 18), 9, Color3.fromRGB(190, 176, 220), 9)
    ScreamUI.footerStats = ScreamUI.text(footer, "SCREAMHUB", UDim2.new(0.5, 0, 0, 5), UDim2.new(0.5, -3, 0, 18), 8,
        Color3.fromRGB(150, 130, 190), 9)
    ScreamUI.footerStats.TextXAlignment = Enum.TextXAlignment.Right
    local tabs = {"Speed", "Custom", "Visual", "Settings", "Keybinds"}
    local titles = {"MOVE", "COMBAT", "VISUAL", "STEAL", "BINDS"}
    local headings = {"MOVEMENT", "COMBAT", "APPEARANCE", "AUTO STEAL", "KEYBINDS"}
    tabButtons = {}
    local contentPages = {}
    ScreamUI.pages = {}
    local tabSelectors = {}
    local function paintTabs(activeIndex, animated)
        for idx, b in ipairs(tabButtons) do
            local on = idx == activeIndex
            b:SetAttribute("TabActive", on)
            b.Underline.Visible = true
            b.TabBgGrad.Enabled = false
            b.TabStroke.Transparency = 1
            b.BackgroundTransparency = 1
            ScreamFX.tween(b.Caption, animated and 0.22 or 0.01, {TextColor3 = on and WHITE or ScreamFX.DIM})
            ScreamFX.tween(b.Underline, animated and 0.32 or 0.01, {Size = UDim2.fromOffset(on and 18 or 0, 2)}, Enum.EasingStyle.Back)
        end
        ScreamFX.tween(tabIndicator, animated and 0.38 or 0.01,
            {Position = UDim2.fromOffset(6, 6 + (activeIndex - 1) * 53)}, Enum.EasingStyle.Quint)
    end
    for i, name in ipairs(tabs) do
        local button = ScreamUI.new("TextButton", tabList, {Name = name, Text = "", Size = UDim2.fromOffset(56, 48),
            BackgroundColor3 = Color3.fromRGB(22, 16, 34), BackgroundTransparency = 1, BorderSizePixel = 0,
            Font = Enum.Font.GothamBold, TextSize = 9, TextColor3 = WHITE, ClipsDescendants = true,
            AutoButtonColor = false, ZIndex = 17, LayoutOrder = i})
        ScreamUI.round(button, 10)
        local stroke = ScreamUI.stroke(button, GRAY, 1, 1)
        stroke.Name = "TabStroke"
        ScreamUI.new("UIGradient", button, {Name = "TabBgGrad", Enabled = false,
            Color = ColorSequence.new(Color3.fromRGB(48, 36, 70), Color3.fromRGB(18, 14, 26)), Rotation = 90})
        -- texte seul, sans icône
        local caption = ScreamUI.text(button, titles[i], UDim2.fromOffset(0, 13), UDim2.fromOffset(56, 20), 9, ScreamFX.DIM, 18)
        caption.Name = "Caption"
        caption.TextXAlignment = Enum.TextXAlignment.Center
        caption.Font = Enum.Font.GothamBlack
        local underline = ScreamUI.new("Frame", button, {Name = "Underline", Size = UDim2.fromOffset(0, 2),
            AnchorPoint = Vector2.new(0.5, 0), Position = UDim2.new(0.5, 0, 0, 36), BackgroundColor3 = getThemeColor(),
            BorderSizePixel = 0, Visible = true, ZIndex = 18})
        ScreamUI.round(underline, 2)
        local page = ScreamUI.new("ScrollingFrame", tabContent, {Name = name, Size = UDim2.fromScale(1, 1),
            BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 3, ScrollBarImageColor3 = getThemeColor(),
            ScrollBarImageTransparency = 0.3, AutomaticCanvasSize = Enum.AutomaticSize.Y, CanvasSize = UDim2.new(),
            ScrollingDirection = Enum.ScrollingDirection.Y, ClipsDescendants = true, Visible = i == 1, ZIndex = 6})
        ScreamFX.accent(page, function(o, c) o.ScrollBarImageColor3 = c end)
        ScreamUI.new("UIListLayout", page, {Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder,
            HorizontalAlignment = Enum.HorizontalAlignment.Center})
        ScreamUI.new("UIPadding", page, {PaddingLeft = UDim.new(0, 12), PaddingRight = UDim.new(0, 12),
            PaddingTop = UDim.new(0, 3), PaddingBottom = UDim.new(0, 18)})
        contentPages[name] = page
        ScreamUI.pages[i] = page
        table.insert(tabButtons, button)
        local function select(silent)
            if not silent then
                if playUiSound then pcall(playUiSound, "tab") elseif _G.__ScreamPlayUiSound then pcall(_G.__ScreamPlayUiSound, "tab") end
            end
            pageHeading.Text = string.format("%02d   /   %s", i, headings[i])
            local previous = ScreamUI.activeTab
            for _, p in pairs(contentPages) do p.Visible = false end
            page.Visible = true
            ScreamUI.activeTab = i
            paintTabs(i, previous ~= nil)
            if previous ~= i then
                local direction = (previous and previous > i) and -1 or 1
                page.Position = UDim2.fromOffset(0, ScreamFX.enabled() and 16 * direction or 0)
                ScreamFX.tween(page, 0.34, {Position = UDim2.fromOffset(0, 0)}, Enum.EasingStyle.Quint)
                if previous ~= nil then ScreamFX.staggerPage(page) end
            end
        end
        tabSelectors[i] = select
        button.Activated:Connect(function() select(false) end)
        button.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                ScreamFX.ripple(button, ScreamFX.pointer(input))
            end
        end)
        button.MouseEnter:Connect(function()
            if ScreamUI.activeTab ~= i then ScreamFX.tween(caption, 0.15, {TextColor3 = GRAY}) end
        end)
        button.MouseLeave:Connect(function()
            if ScreamUI.activeTab ~= i then ScreamFX.tween(caption, 0.2, {TextColor3 = ScreamFX.DIM}) end
        end)
        button:SetAttribute("TabIndex", i)
        if i == 1 then select(true) end
    end
    ScreamFX.accent(tabBar, function()
        for _, b in ipairs(tabButtons) do
            local underlineRef = b:FindFirstChild("Underline")
            if underlineRef then underlineRef.BackgroundColor3 = getThemeColor() end
        end
    end)

    -- Search index + switch helper
    local searchIndex = {}
    local function switchToTab(tabName)
        for i, name in ipairs(tabs) do
            if name == tabName then
                if tabSelectors[i] then tabSelectors[i](true) end
                break
            end
        end
    end

    local function registerSearch(tabName, label, element)
        if not label or label == "" or not element then return end
        table.insert(searchIndex, {
            tab = tabName,
            label = tostring(label),
            key = string.lower(tostring(label)),
            element = element,
        })
    end

    local function performSearch(query)
        query = string.lower(tostring(query or "")):gsub("^%s+", ""):gsub("%s+$", "")
        if query == "" then return end
        local best = nil
        for _, entry in ipairs(searchIndex) do
            if entry.key == query then best = entry; break end
            if not best and string.find(entry.key, query, 1, true) then
                best = entry
            end
        end
        if not best then return end
        switchToTab(best.tab)
        local page = contentPages[best.tab]
        if page and best.element and best.element.Parent then
            task.defer(function()
                local y = best.element.AbsolutePosition.Y - page.AbsolutePosition.Y + page.CanvasPosition.Y - 8
                page.CanvasPosition = Vector2.new(0, math.max(0, y))
                -- flash highlight
                local stroke = best.element:FindFirstChildOfClass("UIStroke")
                if stroke then
                    local oldT = stroke.Transparency
                    local oldC = stroke.Color
                    stroke.Color = getThemeColor()
                    stroke.Transparency = 0.1
                    task.delay(0.9, function()
                        if stroke and stroke.Parent then
                            stroke.Transparency = oldT
                            stroke.Color = oldC
                        end
                    end)
                end
            end)
        end
    end

    -- Search bar FULL WIDTH under heading
    local searchFrame = Instance.new("Frame")
    searchFrame.Name = "SearchFrame"
    searchFrame.Size = UDim2.new(1, -108, 0, 30)
    searchFrame.Position = UDim2.fromOffset(94, 84)
    searchFrame.BackgroundColor3 = Color3.fromRGB(17, 12, 27)
    searchFrame.BackgroundTransparency = 0
    searchFrame.BorderSizePixel = 0
    searchFrame.ZIndex = 12
    searchFrame.Parent = main
    Instance.new("UICorner", searchFrame).CornerRadius = UDim.new(0, 10)
    local searchStroke = Instance.new("UIStroke", searchFrame)
    searchStroke.Color = getThemeColor()
    searchStroke.Transparency = 0.2
    searchStroke.Thickness = 1.5
    ScreamFX.accent(searchStroke, function(o, c) o.Color = c end)

    local searchIcon = Instance.new("TextLabel")
    searchIcon.Name = "Icon"
    searchIcon.Size = UDim2.fromOffset(28, 30)
    searchIcon.Position = UDim2.fromOffset(8, 0)
    searchIcon.BackgroundTransparency = 1
    searchIcon.Text = "⌕"
    searchIcon.TextColor3 = getThemeColor()
    searchIcon.Font = Enum.Font.GothamBold
    searchIcon.TextSize = 18
    searchIcon.ZIndex = 13
    searchIcon.Parent = searchFrame
    ScreamFX.accent(searchIcon, function(o, c) o.TextColor3 = c end)

    local searchBox = Instance.new("TextBox")
    searchBox.Name = "SearchBox"
    searchBox.Size = UDim2.new(1, -42, 1, 0)
    searchBox.Position = UDim2.fromOffset(36, 0)
    searchBox.BackgroundTransparency = 1
    searchBox.BorderSizePixel = 0
    searchBox.Text = ""
    searchBox.PlaceholderText = "Search feature..."
    searchBox.PlaceholderColor3 = Color3.fromRGB(130, 116, 160)
    searchBox.TextColor3 = WHITE
    searchBox.Font = Enum.Font.GothamBold
    searchBox.TextSize = 13
    searchBox.TextXAlignment = Enum.TextXAlignment.Left
    searchBox.ClearTextOnFocus = false
    searchBox.ZIndex = 13
    searchBox.Parent = searchFrame

    searchBox.Focused:Connect(function()
        searchStroke.Color = getThemeColor()
        searchStroke.Transparency = 0
        searchIcon.TextColor3 = getThemeColor()
        playUiSound("click")
        ScreamFX.tween(searchFrame, 0.18, {BackgroundColor3 = Color3.fromRGB(26, 18, 42)})
    end)
    searchBox.FocusLost:Connect(function(enter)
        ScreamFX.tween(searchStroke, 0.2, {Transparency = 0.2})
        ScreamFX.tween(searchFrame, 0.2, {BackgroundColor3 = Color3.fromRGB(17, 12, 27)})
        if enter then playUiSound("select"); performSearch(searchBox.Text) end
    end)
    searchBox:GetPropertyChangedSignal("Text"):Connect(function()
        local q = searchBox.Text
        if #q >= 2 then
            task.defer(function()
                if searchBox.Text == q then performSearch(q) end
            end)
        end
    end)

    -- Shift content down a bit so search doesn't overlap
    if tabContent then
        tabContent.Position = UDim2.fromOffset(94, 120)
        tabContent.Size = UDim2.new(1, -108, 1, -160)
    end
    if pageHeading then
        pageHeading.Visible = false
    end
    if headingRule then
        headingRule.Visible = false
    end
    if headingPanel then
        headingPanel.Visible = false
    end

    local pageCounters = {}
    local function getNextOrder(page)
        pageCounters[page] = (pageCounters[page] or 0) + 1
        return pageCounters[page]
    end
    local function pageTabName(page)
        for name, p in pairs(contentPages) do
            if p == page then return name end
        end
        return "Speed"
    end
    local function mkSect(page, text)
        local row = ScreamUI.new("Frame", page, {Name = "Section", Size = UDim2.new(1, -4, 0, 26), BackgroundTransparency = 1,
            LayoutOrder = getNextOrder(page), ZIndex = 7})
        registerSearch(pageTabName(page), text, row)
        local line = ScreamUI.new("Frame", row, {Name = "Accent", Position = UDim2.fromOffset(1, 9), Size = UDim2.fromOffset(4, 9),
            BackgroundColor3 = getThemeColor(), BorderSizePixel = 0, ZIndex = 8})
        ScreamUI.round(line, 2)
        ScreamFX.accent(line, function(o, c) o.BackgroundColor3 = c end)
        local label = ScreamUI.text(row, text:upper(), UDim2.fromOffset(13, 0), UDim2.new(1, -16, 1, -2),
            9, Color3.fromRGB(200, 186, 232), 8)
        label.Font = Enum.Font.GothamBlack
        local rule = ScreamUI.new("Frame", row, {Name = "Rule", Position = UDim2.new(0, 13, 1, -3),
            Size = UDim2.new(1, -13, 0, 1), BackgroundColor3 = getThemeColor(), BackgroundTransparency = 0.45,
            BorderSizePixel = 0, ZIndex = 8})
        ScreamUI.new("UIGradient", rule, {Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.1), NumberSequenceKeypoint.new(1, 1)})})
        ScreamFX.accent(rule, function(o, c) o.BackgroundColor3 = c end)
        return row
    end
    local function mkRow(page, height)
        local row = ScreamUI.new("Frame", page, {Name = "Control", Size = UDim2.new(1, -4, 0, math.max(height or 40, 40)),
            BackgroundColor3 = ROW_BG, BackgroundTransparency = 0.1, BorderSizePixel = 0, ClipsDescendants = true,
            LayoutOrder = getNextOrder(page), ZIndex = 7})
        ScreamUI.round(row, 10)
        local stroke = ScreamUI.stroke(row, ROW_BORDER, 0.6, 1)
        row.MouseEnter:Connect(function()
            ScreamFX.tween(row, 0.18, {BackgroundColor3 = ScreamFX.ROW_HOVER})
            ScreamFX.tween(stroke, 0.18, {Transparency = 0.2, Color = getThemeColor():Lerp(ROW_BORDER, 0.35)})
        end)
        row.MouseLeave:Connect(function()
            local active = row:GetAttribute("ScreamActive") == true
            ScreamFX.tween(row, 0.24, {BackgroundColor3 = ROW_BG})
            ScreamFX.tween(stroke, 0.24, {Transparency = active and 0.35 or 0.6,
                Color = active and getThemeColor():Lerp(ROW_BORDER, 0.45) or ROW_BORDER})
        end)
        return row
    end
    local function mkLabel(row, text)
        local lbl = ScreamUI.text(row, text, UDim2.fromOffset(14, 0), UDim2.new(0.48, -8, 1, 0), 12, WHITE, 8)
        -- register if parent page known
        local page = row and row.Parent
        if page and text and text ~= "" then
            registerSearch(pageTabName(page), text, row)
        end
        return lbl
    end
    local PILL_OFF = Color3.fromRGB(30, 22, 46)
    local KNOB_OFF = Color3.fromRGB(122, 108, 150)
    local function mkPill(row)
        local pill = ScreamUI.new("Frame", row, {Name = "Track", Size = UDim2.fromOffset(44, 24),
            AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -13, 0.5, 0),
            BackgroundColor3 = PILL_OFF, BorderSizePixel = 0, ZIndex = 8})
        ScreamUI.round(pill, 12)
        ScreamUI.stroke(pill, ROW_BORDER, 0.35, 1)
        local dot = ScreamUI.new("Frame", pill, {Name = "Knob", AnchorPoint = Vector2.new(0.5, 0.5),
            Size = UDim2.fromOffset(16, 16), Position = UDim2.new(0, 12, 0.5, 0),
            BackgroundColor3 = KNOB_OFF, BorderSizePixel = 0, ZIndex = 9})
        ScreamUI.round(dot, 8)
        pill:SetAttribute("FXOn", false)
        ScreamFX.pills[pill] = true
        return pill, dot
    end
    local function animPill(pill, dot, on)
        on = on == true
        local accent = getThemeColor()
        pill:SetAttribute("FXOn", on)
        ScreamFX.tween(pill, 0.22, {BackgroundColor3 = on and accent or PILL_OFF})
        ScreamFX.tween(dot, 0.38, {
            BackgroundColor3 = on and Color3.fromRGB(255, 255, 255) or KNOB_OFF,
            Position = on and UDim2.new(1, -12, 0.5, 0) or UDim2.new(0, 12, 0.5, 0),
        }, Enum.EasingStyle.Back)
        if ScreamFX.enabled() then
            dot.Size = UDim2.fromOffset(21, 14)
            ScreamFX.tween(dot, 0.34, {Size = UDim2.fromOffset(16, 16)}, Enum.EasingStyle.Back)
        end
        local stroke = pill:FindFirstChildOfClass("UIStroke")
        if stroke then
            ScreamFX.tween(stroke, 0.22, {Color = on and accent:Lerp(Color3.new(1, 1, 1), 0.25) or ROW_BORDER,
                Transparency = on and 0.1 or 0.35})
        end
    end
    local function mkToggle(page, text, callback)
        local row = mkRow(page, 46)
        local label = mkLabel(row, text)
        label.Size = UDim2.new(1, -86, 1, 0)
        registerSearch(pageTabName(page), text, row)
        local pill, dot = mkPill(row)
        local bar = ScreamUI.new("Frame", row, {Name = "ActiveBar", AnchorPoint = Vector2.new(0, 0.5),
            Position = UDim2.new(0, 0, 0.5, 0), Size = UDim2.fromOffset(3, 0), BackgroundColor3 = getThemeColor(),
            BorderSizePixel = 0, ZIndex = 9})
        ScreamUI.round(bar, 2)
        ScreamFX.accent(bar, function(o, c) o.BackgroundColor3 = c end)
        local on = false
        local function set(value)
            on = value == true
            row:SetAttribute("ScreamActive", on)
            animPill(pill, dot, on)
            local stroke = row:FindFirstChildOfClass("UIStroke")
            if stroke then
                ScreamFX.tween(stroke, 0.2, {Transparency = on and 0.35 or 0.6,
                    Color = on and getThemeColor():Lerp(ROW_BORDER, 0.45) or ROW_BORDER})
            end
            ScreamFX.tween(bar, 0.32, {Size = UDim2.fromOffset(3, on and 22 or 0)}, Enum.EasingStyle.Back)
            ScreamFX.tween(label, 0.2, {TextColor3 = on and getThemeColor():Lerp(Color3.new(1, 1, 1), 0.6) or WHITE})
        end
        local hit = ScreamUI.new("TextButton", row, {Name = "ToggleHit", Size = UDim2.fromScale(1, 1), Text = "",
            BackgroundTransparency = 1, AutoButtonColor = false, ZIndex = 10})
        hit.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                ScreamFX.ripple(row, ScreamFX.pointer(input))
            end
        end)
        hit.Activated:Connect(function()
            local previous = on
            set(not on)
            if playUiSound then playUiSound("toggle", on) end
            local ok, err = pcall(callback, on)
            if not ok then set(previous); warn("[Screamhub] " .. text .. ": " .. tostring(err)) end
            task.defer(function() pcall(saveAllSettings) end)
        end)
        return set
    end
    local function mkSelector(row, default, options, callback)
        local frame = ScreamUI.new("Frame", row, {Name = "Selector", Size = UDim2.fromOffset(146, 30),
            Position = UDim2.new(1, -156, 0.5, -15), BackgroundColor3 = INP, BorderSizePixel = 0, ZIndex = 8})
        ScreamUI.round(frame, 8)
        ScreamUI.stroke(frame, ROW_BORDER, 0.4, 1)
        local label = ScreamUI.text(frame, default, UDim2.fromOffset(30, 0), UDim2.fromOffset(86, 30), 10, WHITE, 9)
        label.Font = Enum.Font.GothamBold
        label.TextXAlignment = Enum.TextXAlignment.Center
        for i, direction in ipairs({-1, 1}) do
            local button = ScreamUI.new("TextButton", frame, {Size = UDim2.fromOffset(29, 30),
                Position = UDim2.fromOffset(i == 1 and 0 or 117, 0), BackgroundColor3 = INP,
                BorderSizePixel = 0, Text = direction == -1 and "‹" or "›", TextSize = 21,
                Font = Enum.Font.GothamMedium, TextColor3 = getThemeColor(), AutoButtonColor = false, ZIndex = 9})
            ScreamUI.round(button, 8)
            ScreamFX.accent(button, function(o, c) o.TextColor3 = c end)
            button.MouseEnter:Connect(function() ScreamFX.tween(button, 0.15, {BackgroundColor3 = GRAY_ACTIVE}) end)
            button.MouseLeave:Connect(function() ScreamFX.tween(button, 0.2, {BackgroundColor3 = INP}) end)
            button.Activated:Connect(function()
                callback(direction, function(text)
                    label.Text = text
                    if ScreamFX.enabled() then
                        label.TextTransparency = 0.8
                        label.Position = UDim2.fromOffset(30 + direction * 8, 0)
                        ScreamFX.tween(label, 0.26, {TextTransparency = 0, Position = UDim2.fromOffset(30, 0)})
                    end
                end)
                task.defer(function() pcall(saveAllSettings) end)
            end)
        end
        return label
    end
    local function mkDropdown(row, default, options, onSelect, width)
        local w = width or 130
        local frame = ScreamUI.new("Frame", row, {Name = "Dropdown", Size = UDim2.fromOffset(w, 30),
            Position = UDim2.new(1, -(w + 10), 0.5, -15), BackgroundColor3 = INP, BorderSizePixel = 0, ZIndex = 8})
        ScreamUI.round(frame, 8)
        local frameStroke = ScreamUI.stroke(frame, ROW_BORDER, 0.4, 1)

        local label = ScreamUI.text(frame, tostring(default), UDim2.fromOffset(10, 0), UDim2.fromOffset(w - 34, 30), 10, WHITE, 9)
        label.Font = Enum.Font.GothamBold
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.TextTruncate = Enum.TextTruncate.AtEnd

        local arrow = ScreamUI.new("TextLabel", frame, {
            Size = UDim2.fromOffset(24, 30), Position = UDim2.new(1, -26, 0, 0),
            BackgroundTransparency = 1, Text = "▼", TextSize = 9, Rotation = 0,
            Font = Enum.Font.GothamBold, TextColor3 = getThemeColor(), ZIndex = 9
        })
        ScreamFX.accent(arrow, function(o, c) o.TextColor3 = c end)

        local open = false
        local menu = nil
        local closeConn = nil

        local function closeMenu()
            open = false
            if closeConn then closeConn:Disconnect(); closeConn = nil end
            ScreamFX.tween(arrow, 0.25, {Rotation = 0})
            ScreamFX.tween(frameStroke, 0.2, {Color = ROW_BORDER, Transparency = 0.4})
            local closing = menu
            menu = nil
            if closing then
                if ScreamFX.enabled() and closing.Parent then
                    local shrink = TS:Create(closing, TweenInfo.new(0.16, Enum.EasingStyle.Quint, Enum.EasingDirection.In),
                        {Size = UDim2.fromOffset(closing.Size.X.Offset, 0)})
                    local closingStroke = closing:FindFirstChildOfClass("UIStroke")
                    if closingStroke then ScreamFX.tween(closingStroke, 0.16, {Transparency = 1}) end
                    shrink.Completed:Connect(function() pcall(function() closing:Destroy() end) end)
                    shrink:Play()
                else
                    pcall(function() closing:Destroy() end)
                end
            end
        end

        local function openMenu()
            if open then closeMenu(); return end
            open = true
            ScreamFX.tween(arrow, 0.3, {Rotation = 180}, Enum.EasingStyle.Back)
            ScreamFX.tween(frameStroke, 0.2, {Color = getThemeColor(), Transparency = 0.05})
            if playUiSound then playUiSound("click") end

            local itemH = 28
            local maxVisible = 8
            local totalH = #options * itemH + 6
            local menuH = math.min(totalH, maxVisible * itemH + 6)
            local menuW = math.max(w, 140)

            menu = Instance.new("Frame")
            menu.Name = "DropdownMenu"
            menu.Size = UDim2.fromOffset(menuW, ScreamFX.enabled() and 0 or menuH)
            menu.BackgroundColor3 = ScreamFX.PANEL
            menu.BorderSizePixel = 0
            menu.ZIndex = 50
            menu.ClipsDescendants = true
            Instance.new("UICorner", menu).CornerRadius = UDim.new(0, 9)
            local ms = Instance.new("UIStroke", menu)
            ms.Color = getThemeColor()
            ms.Thickness = 1.2
            ms.Transparency = 0.2
            local menuGrad = Instance.new("UIGradient", menu)
            menuGrad.Rotation = 90
            menuGrad.Color = ColorSequence.new(Color3.fromRGB(255, 255, 255), Color3.fromRGB(170, 160, 190))

            local abs = frame.AbsolutePosition
            local absSize = frame.AbsoluteSize
            local parentGui = frame
            while parentGui and not parentGui:IsA("ScreenGui") and parentGui.Parent do
                parentGui = parentGui.Parent
            end
            menu.Parent = parentGui or frame.Parent
            local viewportY = (Workspace.CurrentCamera and Workspace.CurrentCamera.ViewportSize.Y) or 9999
            if abs.Y + absSize.Y + 3 + menuH > viewportY - 6 and abs.Y - menuH - 3 > 6 then
                -- pas assez de place en bas : le menu s'ouvre vers le haut
                menu.AnchorPoint = Vector2.new(0, 1)
                menu.Position = UDim2.fromOffset(abs.X + absSize.X - menuW, abs.Y - 3)
            else
                menu.Position = UDim2.fromOffset(abs.X + absSize.X - menuW, abs.Y + absSize.Y + 3)
            end
            ScreamFX.tween(menu, 0.28, {Size = UDim2.fromOffset(menuW, menuH)}, Enum.EasingStyle.Quint)

            local holder = menu
            if #options > maxVisible then
                local scroll = Instance.new("ScrollingFrame", menu)
                scroll.Size = UDim2.new(1, 0, 1, 0)
                scroll.BackgroundTransparency = 1
                scroll.BorderSizePixel = 0
                scroll.ScrollBarThickness = 3
                scroll.ScrollBarImageColor3 = getThemeColor()
                scroll.CanvasSize = UDim2.fromOffset(0, totalH)
                scroll.ZIndex = 50
                holder = scroll
            end

            local ITEM_BG = Color3.fromRGB(24, 18, 37)
            for idx, opt in ipairs(options) do
                local isCurrent = tostring(opt) == label.Text
                local btn = Instance.new("TextButton", holder)
                btn.Size = UDim2.new(1, -8, 0, 26)
                btn.Position = UDim2.fromOffset(4, 3 + (idx - 1) * itemH)
                btn.BackgroundColor3 = isCurrent and Color3.fromRGB(44, 28, 72) or ITEM_BG
                btn.BorderSizePixel = 0
                btn.Text = "  " .. tostring(opt)
                btn.TextColor3 = isCurrent and getThemeColor():Lerp(Color3.new(1, 1, 1), 0.45) or WHITE
                btn.Font = Enum.Font.GothamBold
                btn.TextSize = 12
                btn.TextXAlignment = Enum.TextXAlignment.Left
                btn.AutoButtonColor = false
                btn.ZIndex = 51
                Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
                if isCurrent then
                    local mark = Instance.new("Frame", btn)
                    mark.Name = "Current"
                    mark.AnchorPoint = Vector2.new(1, 0.5)
                    mark.Position = UDim2.new(1, -8, 0.5, 0)
                    mark.Size = UDim2.fromOffset(6, 6)
                    mark.BackgroundColor3 = getThemeColor()
                    mark.BorderSizePixel = 0
                    mark.ZIndex = 52
                    Instance.new("UICorner", mark).CornerRadius = UDim.new(1, 0)
                end
                local restBg = btn.BackgroundColor3
                local restText = btn.TextColor3
                if ScreamFX.enabled() and idx <= 12 then
                    btn.TextTransparency = 1
                    btn.BackgroundTransparency = 1
                    ScreamFX.tween(btn, 0.22, {TextTransparency = 0, BackgroundTransparency = 0},
                        Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0.03 + idx * 0.018)
                end
                btn.MouseEnter:Connect(function()
                    ScreamFX.tween(btn, 0.14, {BackgroundColor3 = getThemeColor(), TextColor3 = Color3.fromRGB(255, 255, 255)})
                end)
                btn.MouseLeave:Connect(function()
                    ScreamFX.tween(btn, 0.18, {BackgroundColor3 = restBg, TextColor3 = restText})
                end)
                btn.MouseButton1Click:Connect(function()
                    label.Text = tostring(opt)
                    closeMenu()
                    if playUiSound then playUiSound("select") end
                    if onSelect then onSelect(opt, function(t) label.Text = t end) end
                    if ScreamFX.enabled() then
                        label.TextTransparency = 0.8
                        label.Position = UDim2.fromOffset(16, 0)
                        ScreamFX.tween(label, 0.26, {TextTransparency = 0, Position = UDim2.fromOffset(10, 0)})
                    end
                    task.defer(function() pcall(saveAllSettings) end)
                end)
            end

            task.defer(function()
                closeConn = UIS.InputBegan:Connect(function(input)
                    if not open or not menu then return end
                    if input.UserInputType == Enum.UserInputType.MouseButton1
                        or input.UserInputType == Enum.UserInputType.Touch then
                        local pos = input.Position
                        local mpos = menu.AbsolutePosition
                        local msize = menu.AbsoluteSize
                        local fpos = frame.AbsolutePosition
                        local fsize = frame.AbsoluteSize
                        local inMenu = pos.X >= mpos.X and pos.X <= mpos.X + msize.X
                            and pos.Y >= mpos.Y and pos.Y <= mpos.Y + msize.Y
                        local inBtn = pos.X >= fpos.X and pos.X <= fpos.X + fsize.X
                            and pos.Y >= fpos.Y and pos.Y <= fpos.Y + fsize.Y
                        if not inMenu and not inBtn then
                            closeMenu()
                        end
                    end
                end)
            end)
        end

        local hit = Instance.new("TextButton", frame)
        hit.Size = UDim2.new(1, 0, 1, 0)
        hit.BackgroundTransparency = 1
        hit.Text = ""
        hit.AutoButtonColor = false
        hit.ZIndex = 10
        hit.MouseButton1Click:Connect(openMenu)
        hit.MouseEnter:Connect(function()
            if not open then ScreamFX.tween(frame, 0.15, {BackgroundColor3 = Color3.fromRGB(22, 16, 34)}) end
        end)
        hit.MouseLeave:Connect(function()
            ScreamFX.tween(frame, 0.2, {BackgroundColor3 = INP})
        end)

        return label, closeMenu
    end

    local function mkBox(row, default, width, xoff, callback)
        local w = math.max(width or 56, 64)
        local box = ScreamUI.new("TextBox", row, {Size = UDim2.fromOffset(w, 30),
            Position = UDim2.new(1, -math.max(xoff or 76, w + 12), 0.5, -15), Text = tostring(default),
            BackgroundColor3 = INP, BorderSizePixel = 0, Font = Enum.Font.GothamBold, TextSize = 13,
            TextColor3 = Color3.fromRGB(206, 196, 228), ClearTextOnFocus = false, ZIndex = 9})
        ScreamUI.round(box, 8)
        local border = ScreamUI.stroke(box, ROW_BORDER, 0.4, 1)
        local lastValid = tostring(default)
        box.Focused:Connect(function()
            ScreamFX.tween(border, 0.18, {Color = getThemeColor(), Transparency = 0.05})
            ScreamFX.tween(box, 0.18, {BackgroundColor3 = Color3.fromRGB(24, 17, 38), TextColor3 = WHITE})
            if playUiSound then playUiSound("click") end
        end)
        box.FocusLost:Connect(function()
            ScreamFX.tween(border, 0.22, {Color = ROW_BORDER, Transparency = 0.4})
            ScreamFX.tween(box, 0.22, {BackgroundColor3 = INP, TextColor3 = Color3.fromRGB(206, 196, 228)})
            local value = tonumber(box.Text)
            if value and value == value and math.abs(value) < math.huge then
                local ok = pcall(callback, value)
                if ok then
                    lastValid = box.Text
                    if playUiSound then playUiSound("select") end
                else box.Text = lastValid end
            else box.Text = lastValid end
            task.defer(function() pcall(saveAllSettings) end)
        end)
        return box
    end
    local function mkKeyButton(row, entry)
        local function name() return (entry.gp and entry.gp.Name) or (entry.kb and entry.kb.Name) or "None" end
        local button = ScreamUI.new("TextButton", row, {Size = UDim2.fromOffset(116, 30),
            AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(1, -70, 0.5, 0), Text = name(), BackgroundColor3 = INP,
            TextSize = 11, Font = Enum.Font.GothamBold, TextColor3 = WHITE, BorderSizePixel = 0,
            AutoButtonColor = false, ZIndex = 9})
        ScreamUI.round(button, 8)
        local keyStroke = ScreamUI.stroke(button, ROW_BORDER, 0.35, 1)
        ScreamFX.press(button)
        local connection, axisConnection, timeout, listening = nil, nil, nil, false
        local pulse = nil
        local function stop()
            listening = false; _anyKeyListening = false
            if connection then connection:Disconnect(); connection = nil end
            if axisConnection then axisConnection:Disconnect(); axisConnection = nil end
            if timeout then pcall(task.cancel, timeout); timeout = nil end
            if pulse then pulse:Cancel(); pulse = nil end
            button.Text = name(); button.TextColor3 = WHITE
            ScreamFX.tween(keyStroke, 0.2, {Color = ROW_BORDER, Transparency = 0.35})
            ScreamFX.tween(button, 0.2, {BackgroundColor3 = INP})
        end
        button.Activated:Connect(function()
            if listening then stop(); return end
            if _anyKeyListening then return end
            if playUiSound then playUiSound("click") end
            listening = true; _anyKeyListening = true
            button.Text = "Press a key"; button.TextColor3 = getThemeColor():Lerp(Color3.new(1, 1, 1), 0.35)
            keyStroke.Color = getThemeColor(); keyStroke.Transparency = 0
            ScreamFX.tween(button, 0.2, {BackgroundColor3 = Color3.fromRGB(30, 20, 48)})
            if ScreamFX.enabled() then
                pulse = TS:Create(keyStroke, TweenInfo.new(0.55, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
                    {Transparency = 0.75})
                pulse:Play()
            end
            local started = _tick()
            local function accept(input)
                if not listening then return end
                if input.KeyCode == Enum.KeyCode.Escape then stop(); return end
                if not isBindableInput(input) then return end
                local controller = isGamepadInput(input)
                if controller and _tick() - started < 0.2 then return end
                if controller and (input.KeyCode == Enum.KeyCode.ButtonL2 or input.KeyCode == Enum.KeyCode.ButtonR2)
                    and input.Position.Z < 0.55 then return end
                if controller then entry.gp = input.KeyCode; entry.kb = nil
                else entry.kb = input.KeyCode; entry.gp = nil end
                stop(); pcall(saveAllSettings, true)
            end
            connection = UIS.InputBegan:Connect(accept)
            axisConnection = UIS.InputChanged:Connect(accept)
            timeout = task.delay(10, stop)
        end)
        table.insert(keyButtonRefs, {btn = button, entry = entry})
        return button
    end
    local function addKeybindRow(page, text, entry)
        local row = mkRow(page, 46)
        mkLabel(row, text)
        registerSearch(pageTabName(page), text, row)
        mkKeyButton(row, entry)
    end

    local speedPage = contentPages["Speed"]

    mkSect(speedPage, "Movement Speeds")
    do local row = mkRow(speedPage, 42); mkLabel(row, "Normal Speed"); normalBox = mkBox(row, NS, 50, 56, function(v) if v == v and v > 0 and v < math.huge then NS = v; if _G.__RivalHubApplySpeedNow then pcall(_G.__RivalHubApplySpeedNow) end end end) end
    do local row = mkRow(speedPage, 42); mkLabel(row, "Carry Speed"); carryBox = mkBox(row, CS, 50, 56, function(v) if v == v and v > 0 and v < math.huge then CS = v; if _G.__RivalHubApplySpeedNow then pcall(_G.__RivalHubApplySpeedNow) end end end) end
    do local row = mkRow(speedPage, 42); mkLabel(row, "Lagger Normal Speed"); laggerBox = mkBox(row, LAGGER_SPEED, 50, 56, function(v) if v == v and v > 0 and v < math.huge then LAGGER_SPEED = v; if _G.__RivalHubApplySpeedNow then pcall(_G.__RivalHubApplySpeedNow) end end end) end
    do local row = mkRow(speedPage, 42); mkLabel(row, "Lagger Carry Speed"); lagger2Box = mkBox(row, LAGGER_CARRY_SPEED, 50, 56, function(v) if v == v and v > 0 and v < math.huge then LAGGER_CARRY_SPEED = v; if _G.__RivalHubApplySpeedNow then pcall(_G.__RivalHubApplySpeedNow) end end end) end

    mkSect(speedPage, "Speed Engine")
    do
        local row = mkRow(speedPage, 46)
        mkLabel(row, "Speed Motor")
        ScreamUI.motorLabel = mkDropdown(row, useVenixCarryEngine and "Carry Boost" or "Direct", {"Direct", "Carry Boost"}, function(opt, update)
            useVenixCarryEngine = (opt == "Carry Boost")
            update(useVenixCarryEngine and "Carry Boost" or "Direct")
            if _G.__RivalHubRefreshSpeedEngine then _G.__RivalHubRefreshSpeedEngine() end
        end, 130)
    end
    ScreamUI.carrySetter = mkToggle(speedPage, "Auto Carry", function(on)
        ScreamVenixCarry:setSoftStealEnabled(on)
        if on then useVenixCarryEngine = true end
        if ScreamUI.motorLabel then ScreamUI.motorLabel.Text = useVenixCarryEngine and "Carry Boost" or "Direct" end
        if _G.__RivalHubRefreshSpeedEngine then _G.__RivalHubRefreshSpeedEngine() end
    end)
    do
        local row = mkRow(speedPage, 46); mkLabel(row, "Auto Carry Speed")
        ScreamUI.carrySpeedBox = mkBox(row, ScreamVenixCarry.softStealSpeed, 60, 72, function(v)
            ScreamVenixCarry:setSoftStealSpeed(v); ScreamUI.carrySpeedBox.Text = tostring(ScreamVenixCarry.softStealSpeed)
        end)
    end
    do
        local row = mkRow(speedPage, 46); mkLabel(row, "Auto Carry Radius")
        ScreamUI.carryRadiusBox = mkBox(row, ScreamVenixCarry.softStealRadius, 60, 72, function(v)
            ScreamVenixCarry:setSoftStealRadius(v); ScreamUI.carryRadiusBox.Text = tostring(ScreamVenixCarry.softStealRadius)
        end)
    end
    mkSect(speedPage, "Active Mode")
    do
        local row = mkRow(speedPage, 42)
        mkLabel(row, "Current Mode")
        modeValLbl = Instance.new("TextLabel", row)
        modeValLbl.Size = UDim2.new(0, 110, 1, 0)
        modeValLbl.Position = UDim2.new(1, -118, 0, 0)
        modeValLbl.BackgroundTransparency = 1
        modeValLbl.Text = "Normal"
        modeValLbl.TextColor3 = WHITE
        modeValLbl.Font = Enum.Font.GothamBold
        modeValLbl.TextSize = 12
        modeValLbl.TextXAlignment = Enum.TextXAlignment.Right
        modeValLbl.ZIndex = 8
        local clk = Instance.new("TextButton", row)
        clk.Size = UDim2.new(1,0,1,0)
        clk.BackgroundTransparency = 1
        clk.Text = ""
        clk.AutoButtonColor = false
        clk.ZIndex = 8
        clk.MouseButton1Click:Connect(function() toggleCarryMode() end)
    end

    mkSect(speedPage, "Auto Movement")
    autoLeftSetVisual = mkToggle(speedPage, "Auto Left", function(on)
        autoLeftEnabled = on
        if on then startAutoLeft() else stopAutoLeft() end
        if mobSetAutoLeft then mobSetAutoLeft(on) end
    end)
    autoRightSetVisual = mkToggle(speedPage, "Auto Right", function(on)
        autoRightEnabled = on
        if on then startAutoRight() else stopAutoRight() end
        if mobSetAutoRight then mobSetAutoRight(on) end
    end)

    mkSect(speedPage, "Infinite Jump")
    infJumpSetVisual = mkToggle(speedPage, "Infinite Jump", function(on)
        if on then InfiniteJump.start() else InfiniteJump.stop() end
    end)
    do
        local row = mkRow(speedPage, 42)
        mkLabel(row, "Jump Mode")
        local modeBtn = Instance.new("TextButton", row)
        modeBtn.Size = UDim2.new(0, 100, 0, 32)
        modeBtn.Position = UDim2.new(1, -108, 0.5, -16)
        modeBtn.BackgroundColor3 = INP
        modeBtn.BackgroundTransparency = 0.4
        modeBtn.BorderSizePixel = 0
        modeBtn.Text = "HOLD"
        modeBtn.TextColor3 = WHITE
        modeBtn.Font = Enum.Font.GothamBold
        modeBtn.TextSize = 11
        modeBtn.ZIndex = 8
        Instance.new("UICorner", modeBtn).CornerRadius = UDim.new(0, 6)
        infJumpModeBtn = modeBtn
        modeBtn.Activated:Connect(function()
            local nextMode = InfiniteJump.mode == "hold" and "manual" or "hold"
            InfiniteJump.setMode(nextMode)
            modeBtn.Text = string.upper(nextMode)
            if InfiniteJump.enabled then InfiniteJump.stop(); InfiniteJump.start() end
            pcall(saveAllSettings, true)
        end)
    end

    local combatPage = contentPages["Custom"]

    mkSect(combatPage, "Reset")
    setInstaResetVisual = mkToggle(combatPage, "Insta Reset", function(on)
        if on then
            pcall(doInstaReset)
        else
            pcall(stopInstaReset)
        end
    end)

    mkSect(combatPage, "Defense")
    setAntiBatVisual = mkToggle(combatPage, "Anti Bat", function(on)
        if on then startAntiBat() else stopAntiBat() end
    end)
    setAntiFlingVisual = mkToggle(combatPage, "Anti Fling", function(on)
        antiFlingEnabled = on
        if on then startAntiFling() else stopAntiFling() end
        saveAllSettings()
    end)
    if setAntiFlingVisual then setAntiFlingVisual(antiFlingEnabled) end
    mkSect(combatPage, "Anti Ragdoll")
    do
        local row = mkRow(combatPage, 46)
        mkLabel(row, "Anti Ragdoll")
        local modes = {"OFF", "V1", "V2"}
        local modeMap = { OFF = "off", V1 = "v1", V2 = "v2" }
        local reverseMap = { off = "OFF", v1 = "V1", v2 = "V2" }
        local currentDisplay = reverseMap[antiRagdollMode] or "OFF"
        local label = mkDropdown(row, currentDisplay, modes, function(opt, update)
            local mode = modeMap[opt] or "off"
            setAntiRagdollMode(mode)
            update(reverseMap[antiRagdollMode] or opt)
        end)
        _G.updateAntiRagdollUI = function(mode)
            label.Text = reverseMap[mode] or tostring(mode):upper()
        end
        setAntiRagVisual = function(on) if not on then setAntiRagdollMode("off") end end
    end


    setAntiDieVisual = mkToggle(combatPage, "Anti Die", function(on)
        antiDieEnabled = on
        if on then AntiDieModule.start() else AntiDieModule.stop() end
        saveAllSettings()
    end)
    if setAntiDieVisual then setAntiDieVisual(antiDieEnabled) end

    setUnwalkVisual = mkToggle(combatPage, "Unwalk", function(on)
        unwalkEnabled = on
        if on then startUnwalk() else stopUnwalk() end
    end)

    mkSect(combatPage, "Attack")
    autoBatSetVisual = mkToggle(combatPage, "BAT BYPASS • CLEAN UI", function(on)
        if on then enableAutoBat() else disableAutoBat() end
    end)
    do local row = mkRow(combatPage, 42); mkLabel(row, "Bypass Speed"); batSpeedBox = mkBox(row, BYPASS_AIMBOT_SPEED, 50, 56, function(v) if v == v and v > 0 and v < math.huge then BAT_AIMBOT_SPEED = v; BYPASS_AIMBOT_SPEED = v; State.bypassBatSpeed = v; saveAllSettings() end end) end

    mkSect(combatPage, "Targeting")
    bodyLockSetVisual = mkToggle(combatPage, "Lock Enemy", function(on)
        bodyLockEnabled = on
        if on then
            if _blSuppressCount == 0 then startBodyLock() end
        else
            stopBodyLock()
        end
    end)
    do
        local row = mkRow(combatPage, 42)
        mkLabel(row, "Lock Enemy Range")
        bodyLockRangeBox = mkBox(row, bodyLockRange, 50, 56, function(v)
            if v and v > 0 then
                bodyLockRange = _clamp(_floor(v), 5, 200)
                if bodyLockRangeBox then bodyLockRangeBox.Text = tostring(bodyLockRange) end
            end
        end)
    end

    mkSect(combatPage, "Counters")
    setBatCounterVisual = mkToggle(combatPage, "Bat Counter", function(on)
        batCounterEnabled = on
        if on then startBatCounter() else stopBatCounter() end
    end)
    setBatCounterV2Visual = mkToggle(combatPage, "Bat Counter V2", function(on)
        batCounterV2Enabled = on
        if on then startBatCounterV2() else stopBatCounterV2() end
    end)
    setMedusaVisual = mkToggle(combatPage, "Medusa Counter", function(on)
        medusaCounterEnabled = on
        if on then
            if LP.Character then setupMedusaCounter(LP.Character) else stopMedusaCounter() end
        else
            stopMedusaCounter()
        end
        if setMedusaVisual then setMedusaVisual(on) end
    end)

    mkSect(combatPage, "Drop")
    dropBrainrotSetVisual = mkToggle(combatPage, "Drop Brainrot", function(on)
        if on then
            executeDropWithToggle(function(v)
                dropBrainrotSetVisual(v)
                if mobSetDropBR then mobSetDropBR(v) end
            end)
        end
    end)
    setDropVisual = dropBrainrotSetVisual
    do
        local row = mkRow(combatPage, 42)
        mkLabel(row, "Drop Mode")
        dropModeBtnRef = mkDropdown(row, dropMode == 1 and "Fling" or "Jump Drop", {"Fling", "Jump Drop"}, function(opt, update)
            if dropActive then stopDropBrainrot() end
            dropMode = (opt == "Fling") and 1 or 2
            update(dropMode == 1 and "Fling" or "Jump Drop")
        end, 120)
    end

    local visualPage = contentPages["Visual"]

    mkSect(visualPage, "Interface")
    do
        local row = mkRow(visualPage, 42)
        mkLabel(row, "Background")

        local options = {"None"}
        for i = 1, #backgroundImages do
            table.insert(options, "Background " .. i)
        end

        local function currentOptionIndex()
            if backgroundMode == "None" then return 1 end
            local n = tonumber(string.match(backgroundMode, "^Background%s+(%d+)$")) or 1
            return _clamp(n + 1, 1, #options)
        end

        backgroundSelectorLabel = mkDropdown(row, backgroundMode, options, function(opt, updateLabel)
            applyBackgroundMode(opt)
            updateLabel(backgroundMode)
        end, 140)
        applyBackgroundMode(backgroundMode)
    end
    do
        local row = mkRow(visualPage, 95)
        row.BackgroundTransparency = 1
        local border = row:FindFirstChildOfClass("UIStroke"); if border then border:Destroy() end
        row.ClipsDescendants = false
        for i, asset in ipairs(backgroundImages) do
            local card = ScreamUI.new("ImageButton", row, {Size = UDim2.new(1 / 3, -6, 1, 0),
                Position = UDim2.new((i - 1) / 3, (i - 1) * 3, 0, 0), Image = "rbxassetid://" .. asset,
                ScaleType = Enum.ScaleType.Crop, BackgroundColor3 = Color3.fromRGB(14, 10, 22),
                BorderSizePixel = 0, AutoButtonColor = false, ClipsDescendants = true, ZIndex = 8})
            ScreamUI.round(card, 12)
            ScreamFX.accent(ScreamUI.stroke(card, getThemeColor(), 0.72, 1.7), function(o, c) o.Color = c end)
            local scrim = ScreamUI.new("Frame", card, {Size = UDim2.fromScale(1, 1), BackgroundColor3 = Color3.fromRGB(10, 6, 18),
                BackgroundTransparency = 0.6, BorderSizePixel = 0, ZIndex = 9})
            ScreamUI.round(scrim, 12)
            local badge = ScreamUI.new("Frame", card, {Name = "Selected", Size = UDim2.fromOffset(16, 16),
                Position = UDim2.new(1, -22, 0, 6), BackgroundColor3 = getThemeColor(), BorderSizePixel = 0,
                Visible = false, ZIndex = 10})
            ScreamUI.round(badge, 6)
            ScreamFX.accent(badge, function(o, c) o.BackgroundColor3 = c end)
            local check = ScreamUI.text(badge, "✓", UDim2.fromOffset(0, 0), UDim2.fromScale(1, 1), 11, WHITE, 11)
            check.TextXAlignment = Enum.TextXAlignment.Center
            local label = ScreamUI.text(card, "BACKGROUND " .. i,
                UDim2.new(0, 8, 1, -25), UDim2.new(1, -12, 0, 19), 9, WHITE, 10)
            label.Font = Enum.Font.GothamBold
            card.Activated:Connect(function() applyBackgroundMode("Background " .. i); pcall(saveAllSettings, true) end)
            card.MouseEnter:Connect(function() ScreamFX.tween(scrim, 0.2, {BackgroundTransparency = 0.85}) end)
            card.MouseLeave:Connect(function() ScreamFX.tween(scrim, 0.25, {BackgroundTransparency = 0.6}) end)
            ScreamUI.cards[i] = card
        end
        applyBackgroundMode(backgroundMode)
    end
    setLockUIVisual = mkToggle(visualPage, "Lock UI", function(on) toggleLockUI(on) end)
    setHideButtonsVisual = mkToggle(visualPage, "Hide Button", function(on) toggleHideButtons(on) end)
    if setHideButtonsVisual then setHideButtonsVisual(hideButtonsEnabled) end

    ScreamUI.lockButtonsSetter = mkToggle(visualPage, "Lock Mobile Buttons", function(on) mobileButtonsLocked = on end)
    ScreamUI.effectsSetter = mkToggle(visualPage, "UI Effects", function(on) ScreamUI.effects = on end)
    mkSect(visualPage, "Display")
    do
        local row = mkRow(visualPage, 42)
        mkLabel(row, "UI Scale")
        uiScaleBox = mkBox(row, uiScaleValue, 50, 56, function(v)
            local n = _clamp(_floor(v+0.5), 50, 150)
            uiScaleValue = n
            if ScreamUI.fit then ScreamUI.fit() end
            if pbScale then pbScale.Scale = n/100 end
        end)
    end
    do
        local row = mkRow(visualPage, 42)
        mkLabel(row, "Button Scale")
        local box = mkBox(row, _floor(floatingButtonScale * 100), 50, 56, function(v)
            local val = _clamp(v, 50, 200)
            floatingButtonScale = val / 100
            applyFloatingButtonScale()
            saveAllSettings()
        end)
    end

    mkSect(visualPage, "Character")
    do
        local row = mkRow(visualPage, 42)
        mkLabel(row, "Anim Pack")
        local animNames = {}
        for _, entry in ipairs(ANIM_PACK_ORDER) do
            table.insert(animNames, entry[2])
        end
        local currentLabel = currentAnimPack or "Off"
        for _, entry in ipairs(ANIM_PACK_ORDER) do
            if entry[2] == currentAnimPack then currentLabel = entry[2]; break end
        end
        animSelectorLabel = mkDropdown(row, currentLabel, animNames, function(opt, update)
            currentAnimPack = opt
            if opt == "Off" then
                pcall(stopAnimPack)
            else
                pcall(startAnimPack, opt)
            end
            update(opt)
            pcall(saveAllSettings, true)
        end, 130)
    end
    do
        local row = mkRow(visualPage, 42)
        mkLabel(row, "Outfit")
        local outfitNames = {}
        for i, o in ipairs(OUTFITS) do
            table.insert(outfitNames, o.label or ("Outfit " .. i))
        end
        local cur = (OUTFITS[currentOutfitIndex] and OUTFITS[currentOutfitIndex].label) or outfitNames[1] or "None"
        outfitSelectorLabel = mkDropdown(row, cur, outfitNames, function(opt, update)
            pcall(VX7A.stop)
            local newIdx = 1
            for i, o in ipairs(OUTFITS) do
                if (o.label or ("Outfit " .. i)) == opt then newIdx = i; break end
            end
            currentOutfitIndex = newIdx
            pcall(function() applyOutfitByIndex(currentOutfitIndex) end)
            update(opt)
            pcall(saveAllSettings, true)
        end, 130)
    end

    do
        local row = mkRow(visualPage, 42)
        mkLabel(row, "Best Avatars")
        local cur = VX7A.labels[VX7A.index + 1] or "OFF"
        VX7A.label = mkDropdown(row, cur, VX7A.labels, function(opt, update)
            local pos = 1
            for i, name in ipairs(VX7A.labels) do
                if name == opt then pos = i; break end
            end
            VX7A.apply(pos - 1)
            update(opt)
            task.defer(function() pcall(saveAllSettings) end)
        end, 130)
    end

    mkSect(visualPage, "Effects")
    do
        local row = mkRow(visualPage, 42)
        mkLabel(row, "Title Color")
        local RIVAL_THEME_LIST = { "Purple", "Orange", "Blue", "Red", "Green", "Black", "Gray" }
        rivalTitleSelectorLabel = mkDropdown(row, currentRivalTitleTheme, RIVAL_THEME_LIST, function(opt, update)
            applyRivalTitleTheme(opt)
            update(opt)
        end, 120)
    end

    -- UI Color Theme (recolors whole interface accent)
    do
        local row = mkRow(visualPage, 42)
        mkLabel(row, "UI Color")
        colorSelectorLabel = mkDropdown(row, currentColorTheme, COLOR_THEME_LIST, function(opt, update)
            applyColorTheme(opt)
            update(opt)
            if colorSelectorLabel then colorSelectorLabel.TextColor3 = selectedColor end
        end, 120)
    end


    setVividVisual = mkToggle(visualPage, "Vivid Graphics", function(on)
        toggleVividGraphics(on)
        if setVividVisual then setVividVisual(on) end
    end)
    if setVividVisual then setVividVisual(vividGraphicsEnabled) end
    do
        local row = mkRow(visualPage, 42)
        mkLabel(row, "Stretch Rez")
        local stretchPill, stretchDot = mkPill(row, 48)
        local stretchOn = false
        local function setStretch(s)
            stretchOn = s
            animPill(stretchPill, stretchDot, s)
            if s then enableStretch() else disableStretch() end
            stretchEnabled = s
        end
        local stretchClk = Instance.new("TextButton", stretchPill)
        stretchClk.Size = UDim2.new(1,0,1,0)
        stretchClk.BackgroundTransparency = 1
        stretchClk.Text = ""
        stretchClk.AutoButtonColor = false
        stretchClk.ZIndex = 10
        stretchClk.MouseButton1Click:Connect(function() setStretch(not stretchOn) end)
        _G.stretchToggleSetter = setStretch
    end
    setAntiLagVisual = mkToggle(visualPage, "Anti Lag", function(on)
        if on then enableAntiLag() else disableAntiLag() end
        antiLagEnabled = on == true
        pcall(saveAllSettings, true)
    end)
    do
        local row = mkRow(visualPage, 42)
        mkLabel(row, "Sky Theme")
        skySelectorLabel = mkDropdown(row, skyTheme, SKY_PRESETS_LIST, function(opt, update)
            skyTheme = opt
            pcall(applyCustomSky, opt)
            update(opt)
            pcall(saveAllSettings, true)
        end, 140)
    end

    mkSect(visualPage, "Overlays")
    setESPVIsual = mkToggle(visualPage, "Player ESP", function(on) toggleESP(on) end)
    setESPLineVisual = mkToggle(visualPage, "ESP Line", function(on)
        if on then startESPLine() else stopESPLine() end
    end)

    local configPage = contentPages["Settings"]

    mkSect(configPage, "Automation")

    local mkToggleOrange = mkToggle

    setInstaGrab = mkToggleOrange(configPage, "Auto Steal", function(on)
        CONFIG.AUTO_STEAL_ENABLED = on == true
        if on then pcall(startAutoSteal) else stopAutoSteal() end
        updateProgressBarVisibility()
        pcall(saveAllSettings, true)
    end)
    do
        local row = mkRow(configPage, 46)
        mkLabel(row, "Auto Steal Mode")
        autoStealModeBtn = mkDropdown(row, autoStealMode, AUTO_STEAL_VARIANT_NAMES, function(opt, update)
            local enabled = CONFIG.AUTO_STEAL_ENABLED
            if enabled then stopAutoSteal() end
            setAutoStealMode(opt)
            update(autoStealMode)
            if enabled then startAutoSteal() end
        end, 110)
    end

    do
        local row = mkRow(configPage, 42)
        mkLabel(row, "Steal Radius")
        radInput = mkBox(row, CONFIG.STEAL_RANGE, 50, 56, function(v)
            if v and v >= 5 and v <= 300 then
                CONFIG.STEAL_RANGE = _floor(v+0.5)
                Steal.StealRadius = (autoStealMode == "80" or autoStealVariant == 2) and 63 or CONFIG.STEAL_RANGE
                radInput.Text = tostring(CONFIG.STEAL_RANGE)
                saveAllSettings()
            end
        end)
    end

    mkSect(configPage, "Management")
    do
        local row = mkRow(configPage, 44)
        row.Size = UDim2.new(1, 0, 0, 44)
        local saveBtn = Instance.new("TextButton", row)
        saveBtn.Size = UDim2.new(1, -12, 0.8, 0)
        saveBtn.AnchorPoint = Vector2.new(0.5, 0.5)
        saveBtn.Position = UDim2.new(0.5, 0, 0.5, 0)
        saveBtn.BackgroundColor3 = Color3.fromRGB(26, 19, 40)
        saveBtn.BorderSizePixel = 0
        saveBtn.Text = "SAVE CONFIG"
        saveBtn.TextColor3 = Color3.fromRGB(214, 204, 236)
        saveBtn.Font = Enum.Font.GothamBold
        saveBtn.TextSize = 13
        saveBtn.AutoButtonColor = false
        saveBtn.ZIndex = 8
        Instance.new("UICorner", saveBtn).CornerRadius = UDim.new(0, 8)
        saveBtn.ClipsDescendants = true
        ScreamFX.press(saveBtn)
        saveBtn.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                ScreamFX.ripple(saveBtn, ScreamFX.pointer(input), Color3.fromRGB(255, 255, 255))
            end
        end)
        local saveStroke = Instance.new("UIStroke", saveBtn)
        saveStroke.Color = getThemeColor()
        saveStroke.Thickness = 1.5
        saveStroke.Transparency = 0.4
        ScreamFX.accent(saveStroke, function(o, c) o.Color = c end)
        saveBtn.MouseEnter:Connect(function()
            TS:Create(saveBtn, TweenInfo.new(0.15), {BackgroundColor3 = getThemeColor()}):Play()
            TS:Create(saveBtn, TweenInfo.new(0.15), {TextColor3 = Color3.fromRGB(255,255,255)}):Play()
        end)
        saveBtn.MouseLeave:Connect(function()
            TS:Create(saveBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(26, 19, 40)}):Play()
            TS:Create(saveBtn, TweenInfo.new(0.15), {TextColor3 = Color3.fromRGB(214, 204, 236)}):Play()
        end)
        saveBtn.MouseButton1Click:Connect(function()
            local ok = saveAllSettings(true)
            saveBtn.Text = ok and "SAVED" or "ERROR"
            ScreamFX.notify("CONFIG", ok and "Settings saved successfully." or "Could not save settings.", ok and "success" or "error")
            task.delay(1.2, function()
                if saveBtn and saveBtn.Parent then saveBtn.Text = "SAVE CONFIG" end
            end)
        end)
    end
    do
        local row = mkRow(configPage, 44)
        row.Size = UDim2.new(1, 0, 0, 44)
        local resetPosBtn = Instance.new("TextButton", row)
        resetPosBtn.Size = UDim2.new(1, -12, 0.8, 0)
        resetPosBtn.AnchorPoint = Vector2.new(0.5, 0.5)
        resetPosBtn.Position = UDim2.new(0.5, 0, 0.5, 0)
        resetPosBtn.BackgroundColor3 = Color3.fromRGB(26, 19, 40)
        resetPosBtn.BorderSizePixel = 0
        resetPosBtn.Text = "RESET POSITIONS"
        resetPosBtn.TextColor3 = Color3.fromRGB(214, 204, 236)
        resetPosBtn.Font = Enum.Font.GothamBold
        resetPosBtn.TextSize = 13
        resetPosBtn.AutoButtonColor = false
        resetPosBtn.ZIndex = 8
        Instance.new("UICorner", resetPosBtn).CornerRadius = UDim.new(0, 8)
        resetPosBtn.ClipsDescendants = true
        ScreamFX.press(resetPosBtn)
        resetPosBtn.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                ScreamFX.ripple(resetPosBtn, ScreamFX.pointer(input), Color3.fromRGB(255, 255, 255))
            end
        end)
        local resetStroke = Instance.new("UIStroke", resetPosBtn)
        resetStroke.Color = getThemeColor()
        resetStroke.Thickness = 1.5
        resetStroke.Transparency = 0.4
        ScreamFX.accent(resetStroke, function(o, c) o.Color = c end)
        resetPosBtn.MouseEnter:Connect(function()
            TS:Create(resetPosBtn, TweenInfo.new(0.15), {BackgroundColor3 = getThemeColor()}):Play()
            TS:Create(resetPosBtn, TweenInfo.new(0.15), {TextColor3 = Color3.fromRGB(255,255,255)}):Play()
        end)
        resetPosBtn.MouseLeave:Connect(function()
            TS:Create(resetPosBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(26, 19, 40)}):Play()
            TS:Create(resetPosBtn, TweenInfo.new(0.15), {TextColor3 = Color3.fromRGB(214, 204, 236)}):Play()
        end)
        local resetDebounce = false
        resetPosBtn.MouseButton1Click:Connect(function()
            if resetDebounce then return end
            resetDebounce = true
            resetFloatingPositions()
            resetPosBtn.Text = "RESET"
            ScreamFX.notify("POSITIONS", "Floating buttons and HUD were reset.", "success")
            task.delay(1.2, function()
                if resetPosBtn and resetPosBtn.Parent then
                    resetPosBtn.Text = "RESET POSITIONS"
                    resetDebounce = false
                end
            end)
        end)
    end
    do
        local row = mkRow(configPage, 44)
        row.Size = UDim2.new(1, 0, 0, 44)
        local delBtn = Instance.new("TextButton", row)
        delBtn.Size = UDim2.new(1, -12, 0.8, 0)
        delBtn.AnchorPoint = Vector2.new(0.5, 0.5)
        delBtn.Position = UDim2.new(0.5, 0, 0.5, 0)
        delBtn.BackgroundColor3 = Color3.fromRGB(26, 19, 40)
        delBtn.BorderSizePixel = 0
        delBtn.Text = "RESET ALL SETTINGS"
        delBtn.TextColor3 = Color3.fromRGB(170, 30, 50)
        delBtn.Font = Enum.Font.GothamBold
        delBtn.TextSize = 13
        delBtn.AutoButtonColor = false
        delBtn.ZIndex = 8
        Instance.new("UICorner", delBtn).CornerRadius = UDim.new(0, 8)
        delBtn.ClipsDescendants = true
        ScreamFX.press(delBtn)
        delBtn.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                ScreamFX.ripple(delBtn, ScreamFX.pointer(input), Color3.fromRGB(255, 255, 255))
            end
        end)
        local delStroke = Instance.new("UIStroke", delBtn)
        delStroke.Color = Color3.fromRGB(200, 60, 80)
        delStroke.Thickness = 1.5
        delStroke.Transparency = 0.4
        delBtn.MouseEnter:Connect(function()
            TS:Create(delBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(200, 50, 70)}):Play()
            TS:Create(delBtn, TweenInfo.new(0.15), {TextColor3 = Color3.fromRGB(255,255,255)}):Play()
        end)
        delBtn.MouseLeave:Connect(function()
            TS:Create(delBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(26, 19, 40)}):Play()
            TS:Create(delBtn, TweenInfo.new(0.15), {TextColor3 = Color3.fromRGB(170, 30, 50)}):Play()
        end)
        local deleteState = 0
        local originalDeleteText = "RESET ALL SETTINGS"
        local delDebounce = false
        delBtn.MouseButton1Click:Connect(function()
            if delDebounce then return end
            if deleteState == 0 then
                deleteState = 1
                delBtn.Text = "CONFIRM?"
                delBtn.BackgroundColor3 = Color3.fromRGB(255, 220, 220)
                delBtn.TextColor3 = Color3.fromRGB(160, 0, 0)
                task.delay(2, function()
                    if delBtn and delBtn.Parent and deleteState == 1 then
                        deleteState = 0
                        delBtn.Text = originalDeleteText
                        delBtn.BackgroundColor3 = Color3.fromRGB(26, 19, 40)
                        delBtn.TextColor3 = Color3.fromRGB(170, 30, 50)
                    end
                end)
            elseif deleteState == 1 then
                delDebounce = true
                local invoked, success = pcall(resetToFactoryDefaults)
                success = invoked and success
                delBtn.Text = success and "SETTINGS RESET" or "ERROR"
                ScreamFX.notify("RESET", success and "All settings restored to default." or "Reset failed.", success and "success" or "error")
                delBtn.BackgroundColor3 = Color3.fromRGB(26, 19, 40)
                delBtn.TextColor3 = Color3.fromRGB(170, 30, 50)
                deleteState = 0
                task.delay(1.5, function()
                    if delBtn and delBtn.Parent then
                        delBtn.Text = originalDeleteText
                        delBtn.BackgroundColor3 = Color3.fromRGB(26, 19, 40)
                        delBtn.TextColor3 = Color3.fromRGB(170, 30, 50)
                        delDebounce = false
                    end
                end)
            end
        end)
    end


    -- Music section (Insta Reset removed)
    do
        mkSect(visualPage, "MUSIC")
        local musicSound = Instance.new("Sound")
        musicSound.Name = "ScreamHubVX7Music"
        musicSound.Volume = 0.45
        musicSound.Looped = false
        musicSound.Parent = pgui
        local musicSongs = {
            {name="Laja-Setadora", id="https://files.catbox.moe/94olvv.mp3"},
            {name="DUKI, Myke Towers - Nueva", id="https://files.catbox.moe/cb88xa.mp3"},
            {name="Gra Gra Boom", id="https://files.catbox.moe/vy21x7.mp3"},
            {name="LAJA - NADIE TA FRIO", id="https://files.catbox.moe/ecc674.mp3"},
            {name="Katya Lel", id="https://files.catbox.moe/lg4en9.mp3"},
            {name="Montagem Supersonic", id="https://files.catbox.moe/rlykfl.mp3"},
            {name="NO ERA AMOR", id="https://files.catbox.moe/6x3ori.mp3"},
            {name="KING NASIR DANCE", id="https://files.catbox.moe/y62e3y.mp3"},
            {name="Pibble Song", id="https://files.catbox.moe/eixg9d.mp3"},
            {name="Esclava", id="https://files.catbox.moe/cdsh6o.mp3"},
            {name="I Will Survive", id="https://files.catbox.moe/65sjh6.mp3"},
            {name="siinamota", id="https://files.catbox.moe/8lnwtq.mp3"},
        }
        -- VX7-compatible audio loader: download each MP3 to executor storage and
        -- play it through getcustomasset, just like the original VX7 music player.
        local function resolveMusicAsset(url)
            local leaf = tostring(url):match("([^/]+)$")
            if not leaf then return nil end
            local cachePath = "vx7/vx7_music_" .. leaf
            local ok, result = pcall(function()
                if type(isfolder) == "function" and not isfolder("vx7") and type(makefolder) == "function" then
                    makefolder("vx7")
                end
                if type(isfile) ~= "function" or type(writefile) ~= "function" or type(getcustomasset) ~= "function" then
                    return nil
                end
                if not isfile(cachePath) then
                    local response = game:HttpGet(url)
                    if not response or #response == 0 then return nil end
                    writefile(cachePath, response)
                end
                return getcustomasset(cachePath)
            end)
            if ok and type(result) == "string" and result ~= "" then return result end
            return nil
        end
        local currentResolvedUrl = nil
        local currentSongIndex = 1
        local listOpen = false
        local musicRows = {}
        local musicPopup
        local nowPlayingLabel
        local playPauseButton
        local volumeFill
        local volumeValue = 0.45

        local soundToggle = mkToggle(visualPage, "MUSIC SOUND", function(on)
            musicEnabled = on
            if on then
                if musicSound.SoundId == "" then
                    musicSound.SoundId = resolveMusicAsset(musicSongs[currentSongIndex].id) or ""
                end
                if musicSound.SoundId ~= "" then pcall(function() musicSound:Play() end) end
                if playPauseButton then playPauseButton.Text = "Ⅱ" end
            else
                pcall(function() musicSound:Pause() end)
                if playPauseButton then playPauseButton.Text = "▶" end
            end
        end)
        local listRow = mkRow(visualPage, 42)
        mkLabel(listRow, "MUSIC LIST")
        local listBtn = ScreamUI.new("TextButton", listRow, {
            Name = "MusicListButton", Size = UDim2.fromOffset(32, 30),
            AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -10, 0.5, 0),
            BackgroundColor3 = Color3.fromRGB(30, 22, 46), BorderSizePixel = 0,
            Text = "+", TextSize = 18, Font = Enum.Font.GothamBold,
            TextColor3 = Color3.fromRGB(205, 207, 214), AutoButtonColor = false, ZIndex = 10
        })
        ScreamUI.round(listBtn, 15)
        ScreamFX.press(listBtn)
        ScreamUI.stroke(listBtn, ROW_BORDER, 0.45, 1)

        -- Floating VX7-style music player, modeled after the supplied reference image.
        local oldPopup = pgui:FindFirstChild("ScreamHubVX7MusicPlayer")
        if oldPopup then oldPopup:Destroy() end
        local popupGui = Instance.new("ScreenGui")
        popupGui.Name = "ScreamHubVX7MusicPlayer"
        popupGui.ResetOnSpawn = false
        popupGui.IgnoreGuiInset = true
        popupGui.DisplayOrder = 80
        popupGui.Enabled = false
        popupGui.Parent = pgui
        musicPopup = Instance.new("Frame")
        musicPopup.Name = "Player"
        musicPopup.Size = UDim2.fromOffset(270, 355)
        musicPopup.AnchorPoint = Vector2.new(1, 0.5)
        musicPopup.Position = UDim2.new(1, -14, 0.55, 0)
        musicPopup.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        musicPopup.BorderSizePixel = 0
        musicPopup.ClipsDescendants = true
        musicPopup.Parent = popupGui
        Instance.new("UICorner", musicPopup).CornerRadius = UDim.new(0, 13)
        local popupStroke = Instance.new("UIStroke", musicPopup)
        popupStroke.Color = getThemeColor()
        ScreamFX.accent(popupStroke, function(o, c) o.Color = c end)
        popupStroke.Thickness = 1.5
        local popupGradient = Instance.new("UIGradient", musicPopup)
        popupGradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(24, 18, 38)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(11, 8, 19))
        })
        popupGradient.Rotation = 90

        local header = Instance.new("Frame")
        header.Size = UDim2.new(1, 0, 0, 38)
        header.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        header.BorderSizePixel = 0
        header.Parent = musicPopup
        local headerGrad = Instance.new("UIGradient", header)
        headerGrad.Color = ColorSequence.new(getThemeColor():Lerp(Color3.new(0, 0, 0), 0.3), Color3.fromRGB(20, 14, 32))
        ScreamFX.accent(headerGrad, function(o, c) o.Color = ColorSequence.new(c:Lerp(Color3.new(0, 0, 0), 0.3), Color3.fromRGB(20, 14, 32)) end)
        headerGrad.Rotation = 0
        local title = Instance.new("TextLabel")
        title.BackgroundTransparency = 1
        title.Position = UDim2.new(0, 12, 0, 0)
        title.Size = UDim2.new(1, -48, 1, 0)
        title.Font = Enum.Font.GothamBlack
        title.Text = "SCREAM MUSIC"
        title.TextSize = 13
        title.TextColor3 = Color3.fromRGB(245, 245, 247)
        title.TextXAlignment = Enum.TextXAlignment.Left
        title.Parent = header
        local closeBtn = Instance.new("TextButton")
        closeBtn.Size = UDim2.fromOffset(23, 23)
        closeBtn.Position = UDim2.new(1, -29, 0, 7)
        closeBtn.BackgroundColor3 = Color3.fromRGB(40, 28, 62)
        closeBtn.TextColor3 = Color3.fromRGB(240, 236, 252)
        closeBtn.AutoButtonColor = false
        closeBtn.Text = "×"
        closeBtn.Font = Enum.Font.GothamBold
        closeBtn.TextSize = 18
        closeBtn.BorderSizePixel = 0
        closeBtn.Parent = header
        Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 6)
        closeBtn.MouseEnter:Connect(function() ScreamFX.tween(closeBtn, 0.15, {BackgroundColor3 = Color3.fromRGB(255, 84, 112)}) end)
        closeBtn.MouseLeave:Connect(function() ScreamFX.tween(closeBtn, 0.2, {BackgroundColor3 = Color3.fromRGB(40, 28, 62)}) end)

        -- Drag the player by holding its header (mouse or touch).
        header.Active = true
        local dragInput, dragStart, startPosition
        header.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragInput = input
                dragStart = input.Position
                startPosition = musicPopup.Position
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        dragInput = nil
                    end
                end)
            end
        end)
        UIS.InputChanged:Connect(function(input)
            if dragInput and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                local delta = input.Position - dragStart
                musicPopup.Position = UDim2.new(
                    startPosition.X.Scale, startPosition.X.Offset + delta.X,
                    startPosition.Y.Scale, startPosition.Y.Offset + delta.Y
                )
            end
        end)

        local songScroll = Instance.new("ScrollingFrame")
        songScroll.Name = "SongList"
        songScroll.Position = UDim2.new(0, 0, 0, 40)
        songScroll.Size = UDim2.new(1, 0, 1, -126)
        songScroll.BackgroundTransparency = 1
        songScroll.BorderSizePixel = 0
        songScroll.ScrollBarThickness = 3
        songScroll.ScrollBarImageColor3 = Color3.fromRGB(150, 100, 230)
        songScroll.CanvasSize = UDim2.new(0, 0, 0, #musicSongs * 31)
        songScroll.Parent = musicPopup
        local songLayout = Instance.new("UIListLayout", songScroll)
        songLayout.Padding = UDim.new(0, 1)
        songLayout.SortOrder = Enum.SortOrder.LayoutOrder

        local function setCurrentSong(index, startPlayback)
            currentSongIndex = ((index - 1) % #musicSongs) + 1
            local song = musicSongs[currentSongIndex]
            musicSound:Stop()
            currentResolvedUrl = song.id
            musicSound.SoundId = resolveMusicAsset(song.id) or ""
            musicSound.Volume = volumeValue
            for i, row in ipairs(musicRows) do
                ScreamFX.tween(row, 0.2, {BackgroundColor3 = (i == currentSongIndex) and Color3.fromRGB(52, 34, 84) or Color3.fromRGB(22, 16, 34)})
                local marker = row:FindFirstChild("PlayingMarker")
                if marker then marker.Text = (i == currentSongIndex and musicEnabled) and "Ⅱ" or "↵" end
            end
            if nowPlayingLabel then nowPlayingLabel.Text = "NOW: " .. string.upper(song.name) end
            if startPlayback then
                musicEnabled = true
                if musicSound.SoundId ~= "" then
                    pcall(function() musicSound.TimePosition = 0; musicSound:Play() end)
                else
                    musicEnabled = false
                    if nowPlayingLabel then nowPlayingLabel.Text = "AUDIO NON CHARGE - VERIFIE L'EXECUTEUR" end
                end
                if soundToggle then pcall(soundToggle, musicEnabled) end
                if playPauseButton then playPauseButton.Text = "Ⅱ" end
            end
        end

        for index, song in ipairs(musicSongs) do
            local row = Instance.new("TextButton")
            row.Name = "Song_" .. tostring(index)
            row.Size = UDim2.new(1, -4, 0, 30)
            row.BackgroundColor3 = Color3.fromRGB(22, 16, 34)
            row.BackgroundTransparency = 0.02
            row.AutoButtonColor = false
            row.BorderSizePixel = 0
            row.Text = ""
            row.LayoutOrder = index
            row.Parent = songScroll
            local rowLabel = Instance.new("TextLabel")
            rowLabel.BackgroundTransparency = 1
            rowLabel.Position = UDim2.new(0, 7, 0, 0)
            rowLabel.Size = UDim2.new(1, -33, 1, 0)
            rowLabel.Font = Enum.Font.GothamBold
            rowLabel.TextSize = 10
            rowLabel.TextColor3 = Color3.fromRGB(205, 205, 214)
            rowLabel.TextXAlignment = Enum.TextXAlignment.Left
            rowLabel.TextTruncate = Enum.TextTruncate.AtEnd
            rowLabel.Text = string.upper(song.name)
            rowLabel.Parent = row
            local marker = Instance.new("TextLabel")
            marker.Name = "PlayingMarker"
            marker.BackgroundTransparency = 1
            marker.Position = UDim2.new(1, -26, 0, 0)
            marker.Size = UDim2.fromOffset(22, 30)
            marker.Font = Enum.Font.GothamBold
            marker.TextSize = 11
            marker.TextColor3 = Color3.fromRGB(210, 210, 218)
            marker.Text = "↵"
            marker.Parent = row
            row.Activated:Connect(function() setCurrentSong(index, true) end)
            row.MouseEnter:Connect(function() ScreamFX.tween(rowLabel, 0.15, {TextColor3 = Color3.fromRGB(255, 255, 255)}) end)
            row.MouseLeave:Connect(function() ScreamFX.tween(rowLabel, 0.2, {TextColor3 = Color3.fromRGB(205, 205, 214)}) end)
            table.insert(musicRows, row)
        end

        local controls = Instance.new("Frame")
        controls.Position = UDim2.new(0, 0, 1, -83)
        controls.Size = UDim2.new(1, 0, 0, 83)
        controls.BackgroundColor3 = Color3.fromRGB(18, 13, 29)
        controls.BorderSizePixel = 0
        controls.Parent = musicPopup
        local function controlButton(text, x, width)
            local b = Instance.new("TextButton")
            b.Size = UDim2.fromOffset(width, 27)
            b.Position = UDim2.new(0, x, 0, 5)
            b.BackgroundColor3 = Color3.fromRGB(40, 28, 62)
            b.TextColor3 = Color3.fromRGB(240, 236, 252)
            b.AutoButtonColor = false
            b.Text = text
            b.Font = Enum.Font.GothamBold
            b.TextSize = 13
            b.BorderSizePixel = 0
            b.Parent = controls
            Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
            b.MouseEnter:Connect(function() ScreamFX.tween(b, 0.15, {BackgroundColor3 = getThemeColor()}) end)
            b.MouseLeave:Connect(function() ScreamFX.tween(b, 0.2, {BackgroundColor3 = Color3.fromRGB(40, 28, 62)}) end)
            return b
        end
        local previousButton = controlButton("≪", 5, 36)
        playPauseButton = controlButton("▶", 44, 36)
        local nextButton = controlButton("≫", 83, 36)
        local volLabel = Instance.new("TextLabel")
        volLabel.BackgroundTransparency = 1
        volLabel.Position = UDim2.new(0, 123, 0, 5)
        volLabel.Size = UDim2.fromOffset(25, 27)
        volLabel.Text = "VOL"
        volLabel.Font = Enum.Font.GothamBold
        volLabel.TextSize = 9
        volLabel.TextColor3 = Color3.fromRGB(190, 188, 202)
        volLabel.Parent = controls
        local volumeBar = Instance.new("TextButton")
        volumeBar.Position = UDim2.new(0, 151, 0, 15)
        volumeBar.Size = UDim2.new(1, -162, 0, 7)
        volumeBar.BackgroundColor3 = Color3.fromRGB(12, 9, 20)
        volumeBar.BorderSizePixel = 0
        volumeBar.Text = ""
        volumeBar.Parent = controls
        Instance.new("UICorner", volumeBar).CornerRadius = UDim.new(1, 0)
        volumeFill = Instance.new("Frame")
        volumeFill.Size = UDim2.new(volumeValue, 0, 1, 0)
        volumeFill.BackgroundColor3 = getThemeColor()
        ScreamFX.accent(volumeFill, function(o, c) o.BackgroundColor3 = c end)
        volumeFill.BorderSizePixel = 0
        volumeFill.Parent = volumeBar
        Instance.new("UICorner", volumeFill).CornerRadius = UDim.new(1, 0)
        local function updateVolume(inputX)
            local ratio = math.clamp((inputX - volumeBar.AbsolutePosition.X) / math.max(volumeBar.AbsoluteSize.X, 1), 0, 1)
            volumeValue = ratio
            musicSound.Volume = volumeValue
            volumeFill.Size = UDim2.new(volumeValue, 0, 1, 0)
        end
        volumeBar.Activated:Connect(function() updateVolume(UIS:GetMouseLocation().X) end)
        nowPlayingLabel = Instance.new("TextLabel")
        nowPlayingLabel.BackgroundTransparency = 1
        nowPlayingLabel.Position = UDim2.new(0, 5, 0, 36)
        nowPlayingLabel.Size = UDim2.new(1, -10, 0, 15)
        nowPlayingLabel.Font = Enum.Font.GothamBold
        nowPlayingLabel.TextSize = 9
        nowPlayingLabel.TextColor3 = Color3.fromRGB(210, 207, 220)
        nowPlayingLabel.Text = "NOW: " .. string.upper(musicSongs[1].name)
        nowPlayingLabel.Parent = controls
        local visualizer = Instance.new("Frame")
        visualizer.BackgroundTransparency = 1
        visualizer.Position = UDim2.new(0, 4, 0, 56)
        visualizer.Size = UDim2.new(1, -8, 0, 23)
        visualizer.Parent = controls
        local visualizerLayout = Instance.new("UIListLayout", visualizer)
        visualizerLayout.FillDirection = Enum.FillDirection.Horizontal
        visualizerLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        visualizerLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
        visualizerLayout.Padding = UDim.new(0, 2)
        local visualizerBars = {}
        for i = 1, 32 do
            local bar = Instance.new("Frame")
            bar.Size = UDim2.new(0, 5, 0, 4 + ((i * 7) % 13))
            bar.BackgroundColor3 = getThemeColor()
            ScreamFX.accent(bar, function(o, c) o.BackgroundColor3 = c end)
            table.insert(visualizerBars, bar)
            bar.BorderSizePixel = 0
            bar.Parent = visualizer
            Instance.new("UICorner", bar).CornerRadius = UDim.new(0, 1)
        end
        previousButton.Activated:Connect(function() setCurrentSong(currentSongIndex - 1, true) end)
        nextButton.Activated:Connect(function() setCurrentSong(currentSongIndex + 1, true) end)
        playPauseButton.Activated:Connect(function()
            if musicEnabled then
                musicEnabled = false
                pcall(function() musicSound:Pause() end)
                playPauseButton.Text = "▶"
                if soundToggle then pcall(soundToggle, false) end
            else
                musicEnabled = true
                if musicSound.SoundId == "" then
                    musicSound.SoundId = resolveMusicAsset(musicSongs[currentSongIndex].id) or ""
                end
                if musicSound.SoundId ~= "" then
                    pcall(function() musicSound:Play() end)
                    playPauseButton.Text = "Ⅱ"
                else
                    musicEnabled = false
                    playPauseButton.Text = "▶"
                    if nowPlayingLabel then nowPlayingLabel.Text = "AUDIO NON CHARGE - VERIFIE L'EXECUTEUR" end
                end
                if soundToggle then pcall(soundToggle, true) end
            end
        end)
        -- Visualiseur animé (uniquement quand le lecteur est ouvert)
        local visualizerConn = nil
        local function setVisualizer(active)
            if visualizerConn then visualizerConn:Disconnect(); visualizerConn = nil end
            if not active then return end
            local accumulator, elapsed = 0, 0
            visualizerConn = RunService.Heartbeat:Connect(function(dt)
                accumulator = accumulator + dt
                elapsed = elapsed + dt
                if accumulator < 1 / 20 then return end
                accumulator = 0
                if not popupGui.Parent then
                    if visualizerConn then visualizerConn:Disconnect(); visualizerConn = nil end
                    return
                end
                local loud = 0
                if musicEnabled and musicSound.IsPlaying then
                    loud = math.clamp((musicSound.PlaybackLoudness or 0) / 400, 0, 1)
                end
                for i, bar in ipairs(visualizerBars) do
                    local wave = (math.sin(elapsed * 7 + i * 0.55) + 1) / 2
                    local h = 4 + ((i * 7) % 13) * 0.35 + (loud > 0 and loud * 17 * (0.45 + 0.55 * wave) or wave * 2)
                    bar.Size = UDim2.new(0, 5, 0, math.floor(math.clamp(h, 3, 23)))
                end
            end)
        end
        local musicOpen = false
        local function setMusicOpen(state)
            musicOpen = state
            listBtn.Text = state and "−" or "+"
            if state then
                popupGui.Enabled = true
                setVisualizer(true)
                ScreamFX.pop(musicPopup, true)
            else
                ScreamFX.pop(musicPopup, false, function()
                    if not musicOpen then
                        popupGui.Enabled = false
                        setVisualizer(false)
                    end
                end)
            end
        end
        closeBtn.Activated:Connect(function() setMusicOpen(false) end)
        listBtn.Activated:Connect(function() setMusicOpen(not musicOpen) end)
        musicSound.Ended:Connect(function()
            if musicEnabled then setCurrentSong(currentSongIndex + 1, true) end
        end)
        setCurrentSong(1, false)
    end

    -- ===== BAT SKINS (Visual last) =====
    mkSect(visualPage, "Bat Skin")
    katanaSkinSetVisual = mkToggle(visualPage, "Katana", function(on)
        katanaSkinEnabled = on == true
        if katanaSkinEnabled then
            pcall(function() KatanaSkin.ApplySkin("KATANA") end)
            if _G.ShelSwordVisual and _G.ShelSwordVisual.apply then
                pcall(_G.ShelSwordVisual.apply)
            end
        else
            pcall(function() KatanaSkin.ApplySkin("NONE") end)
            if _G.ShelSwordVisual and _G.ShelSwordVisual.clear then
                pcall(_G.ShelSwordVisual.clear)
            end
        end
        pcall(saveAllSettings, true)
    end)
    if katanaSkinSetVisual then katanaSkinSetVisual(katanaSkinEnabled) end

    MinecraftBatSetVisual = mkToggle(visualPage, "Minecraft Bat", function(on)
        minecraftBatSkinEnabled = on == true
        MinecraftBatSkin.State.enabled = minecraftBatSkinEnabled
        if minecraftBatSkinEnabled then
            pcall(MinecraftBatSkin.Apply)
        else
            pcall(MinecraftBatSkin.Remove)
        end
        pcall(saveAllSettings, true)
    end)
    if MinecraftBatSetVisual then MinecraftBatSetVisual(minecraftBatSkinEnabled) end
    do
        local row = mkRow(visualPage, 42)
        mkLabel(row, "MC Bat Color")
        local mcColorOptions = {
            "Default", "Abyss Blue", "Venom Green",
            "Royal Gold", "Velvet Rose", "Crimson Night", "RGB"
        }
        MinecraftBatColorSelector = mkDropdown(row, minecraftBatSkinColorMode or "Default", mcColorOptions, function(opt, update)
            minecraftBatSkinColorMode = opt
            MinecraftBatSkin.SetColorMode(opt)
            update(opt)
            pcall(saveAllSettings, true)
        end, 130)
    end

    local keyPage = contentPages["Keybinds"]
    mkSect(keyPage, "Keybinds")
    mkSect(keyPage, "Movement")
    addKeybindRow(keyPage, "Carry Mode", KB.CarryToggle)
    addKeybindRow(keyPage, "Lagger Mode", KB.LaggerMode)
    addKeybindRow(keyPage, "Auto Left", KB.AutoLeft)
    addKeybindRow(keyPage, "Auto Right", KB.AutoRight)

    mkSect(keyPage, "Combat")
    addKeybindRow(keyPage, "Bat Bypass", KB.AutoBat)
    addKeybindRow(keyPage, "TP Bate", KB.BatV2)

    mkSect(keyPage, "Utility")
    addKeybindRow(keyPage, "Insta Reset", KB.InstaReset)
    addKeybindRow(keyPage, "Drop Brainrot", KB.DropBrainrot)
    addKeybindRow(keyPage, "TP Down", KB.TPFloor)
    addKeybindRow(keyPage, "Hide GUI", KB.GuiHide)

    local spacer = Instance.new("Frame", keyPage)
    spacer.Size = UDim2.new(1, 0, 0, 16)
    spacer.BackgroundTransparency = 1
    spacer.LayoutOrder = getNextOrder(keyPage)
    spacer.ZIndex = 7

    -- ===== VX7-STYLE STEAL HUD (Compact) =====
    pbFrame = ScreamUI.new("Frame", gui, {
        Name = "RivalHubAutoStealHud",
        Size = UDim2.fromOffset(372, 54),
        Position = UDim2.new(0.5, -186, 1, -134),
        BackgroundColor3 = Color3.fromRGB(14, 10, 22),
        BackgroundTransparency = 0.18,
        BorderSizePixel = 0,
        Active = true,
        ClipsDescendants = true,
        ZIndex = 50,
    })
    ScreamUI.hudScale = ScreamUI.new("UIScale", pbFrame, {Scale = 1})
    ScreamUI.round(pbFrame, 10)
    local hudStroke = ScreamUI.stroke(pbFrame, getThemeColor(), 0.45, 1)
    hudStroke.Name = "OuterStroke"

    -- Percent (bottom-left)
    progressPct = ScreamUI.text(pbFrame, "0%", UDim2.fromOffset(14, 24), UDim2.fromOffset(70, 22), 15,
        Color3.fromRGB(255, 255, 255), 55)
    progressPct.Name = "StealProgressPercent"
    progressPct.Font = Enum.Font.GothamBold
    progressPct.TextXAlignment = Enum.TextXAlignment.Left

    -- Status (top-left)
    progressStatus = ScreamUI.text(pbFrame, "STEAL", UDim2.fromOffset(14, 7), UDim2.fromOffset(70, 16), 8,
        Color3.fromRGB(205, 205, 214), 54)
    progressStatus.Name = "StealProgressStatus"
    progressStatus.Font = Enum.Font.GothamBold
    progressStatus.TextXAlignment = Enum.TextXAlignment.Left

    -- Vertical divider
    local divider = ScreamUI.new("Frame", pbFrame, {
        Name = "Divider",
        Size = UDim2.fromOffset(1, 34),
        Position = UDim2.fromOffset(88, 10),
        BackgroundColor3 = Color3.fromRGB(200, 200, 210),
        BackgroundTransparency = 0.62,
        BorderSizePixel = 0,
        ZIndex = 55,
    })

    -- Mode badge (top-right of track area)
    local modePill = ScreamUI.new("Frame", pbFrame, {
        Name = "ModeBadge",
        Size = UDim2.fromOffset(36, 14),
        Position = UDim2.fromOffset(320, 8),
        BackgroundColor3 = Color3.fromRGB(28, 20, 44),
        BorderSizePixel = 0,
        ZIndex = 55,
    })
    ScreamUI.round(modePill, 4)
    ScreamUI.stroke(modePill, Color3.fromRGB(110, 80, 160), 0.4, 1)
    stealHud.mode = ScreamUI.text(modePill, autoStealMode or "V4", UDim2.fromScale(0, 0), UDim2.fromScale(1, 1), 8,
        Color3.fromRGB(230, 230, 235), 56)
    stealHud.mode.Name = "StealMode"
    stealHud.mode.TextXAlignment = Enum.TextXAlignment.Center
    stealHud.mode.Font = Enum.Font.GothamBold

    -- FPS / PING row (bottom under track)
    local fpsLbl = ScreamUI.text(pbFrame, "FPS", UDim2.fromOffset(104, 28), UDim2.fromOffset(28, 18), 8,
        Color3.fromRGB(190, 190, 200), 55)
    fpsLbl.Font = Enum.Font.Gotham
    fpsLbl.TextXAlignment = Enum.TextXAlignment.Left
    local fpsVal = ScreamUI.text(pbFrame, "60", UDim2.fromOffset(134, 28), UDim2.fromOffset(42, 18), 10,
        Color3.fromRGB(255, 255, 255), 55)
    fpsVal.Name = "FPSNeon"
    fpsVal.Font = Enum.Font.GothamMedium
    fpsVal.TextXAlignment = Enum.TextXAlignment.Left
    local pingLbl = ScreamUI.text(pbFrame, "PING", UDim2.fromOffset(211, 28), UDim2.fromOffset(34, 18), 8,
        Color3.fromRGB(190, 190, 200), 55)
    pingLbl.Font = Enum.Font.Gotham
    pingLbl.TextXAlignment = Enum.TextXAlignment.Left
    local pingVal = ScreamUI.text(pbFrame, "0ms", UDim2.fromOffset(247, 28), UDim2.fromOffset(62, 18), 10,
        Color3.fromRGB(255, 255, 255), 55)
    pingVal.Name = "PingNeon"
    pingVal.Font = Enum.Font.GothamMedium
    pingVal.TextXAlignment = Enum.TextXAlignment.Left
    stealHud.fpsVal = fpsVal
    stealHud.pingVal = pingVal
    stealHud.stats = nil

    -- Progress track
    local track = ScreamUI.new("Frame", pbFrame, {
        Name = "StealProgressTrack",
        Size = UDim2.fromOffset(258, 15),
        Position = UDim2.fromOffset(101, 8),
        BackgroundColor3 = Color3.fromRGB(32, 24, 48),
        BackgroundTransparency = 0.08,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        ZIndex = 52,
    })
    ScreamUI.round(track, 100)
    progressFill = ScreamUI.new("Frame", track, {
        Name = "Fill",
        Size = UDim2.new(0, 0, 1, 0),
        BackgroundColor3 = getThemeColor(),
        BorderSizePixel = 0,
        ClipsDescendants = true,
        ZIndex = 53,
    })
    ScreamUI.round(progressFill, 100)
    local fillGrad = ScreamUI.new("UIGradient", progressFill, {
        Rotation = -10,
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.new(getThemeColor().R * 0.55, getThemeColor().G * 0.55, getThemeColor().B * 0.55)),
            ColorSequenceKeypoint.new(0.38, getThemeColor()),
            ColorSequenceKeypoint.new(0.68, getThemeColor():Lerp(Color3.new(1, 1, 1), 0.34)),
            ColorSequenceKeypoint.new(1, Color3.new(getThemeColor().R * 0.55, getThemeColor().G * 0.55, getThemeColor().B * 0.55)),
        }),
    })
    local gloss = ScreamUI.new("Frame", progressFill, {
        Name = "Shine",
        Size = UDim2.new(1, 0, 0.36, 0),
        BackgroundColor3 = Color3.new(1, 1, 1),
        BackgroundTransparency = 0.76,
        BorderSizePixel = 0,
        ZIndex = 54,
    })
    ScreamUI.round(gloss, 100)
    ScreamUI.new("UIGradient", gloss, {
        Rotation = 90,
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.18),
            NumberSequenceKeypoint.new(1, 1),
        }),
    })
    -- subtle animated gradient slide (VX7 style)
    task.spawn(function()
        while progressFill and progressFill.Parent and fillGrad and fillGrad.Parent do
            local t1 = TS:Create(fillGrad, TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
                {Offset = Vector2.new(0.5, 0)})
            t1:Play(); t1.Completed:Wait()
            if not (fillGrad and fillGrad.Parent) then break end
            local t2 = TS:Create(fillGrad, TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
                {Offset = Vector2.new(-0.5, 0)})
            t2:Play(); t2.Completed:Wait()
        end
    end)

    updateStealProgress(stealHud.value, stealHud.state)
    drag(pbFrame)
    ScreamUI.fit()
    do
        local viewConnection
        local function followCamera()
            if viewConnection then viewConnection:Disconnect() end
            local cam = Workspace.CurrentCamera
            if cam then viewConnection = cam:GetPropertyChangedSignal("ViewportSize"):Connect(ScreamUI.fit) end
            ScreamUI.fit()
        end
        local cameraConnection = Workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(followCamera)
        followCamera()
        gui.Destroying:Connect(function()
            cameraConnection:Disconnect()
            if viewConnection then viewConnection:Disconnect() end
        end)
    end
    ScreamUI.effectsLoop(gui)
    task.spawn(function() pcall(function() game:GetService("ContentProvider"):PreloadAsync({bg}) end) end)
end

do
    
    local function findGlobalFunc(...)
        local sources = {}
        pcall(function() if getgenv then table.insert(sources, getgenv()) end end)
        pcall(function() table.insert(sources, _G) end)
        pcall(function() if getfenv then table.insert(sources, getfenv()) end end)
        for i = 1, select("#", ...) do
            local name = select(i, ...)
            for _, env in ipairs(sources) do
                if type(env) == "table" then
                    local ok, val = pcall(function() return env[name] end)
                    if ok and type(val) == "function" then return val end
                end
            end
        end
        return nil
    end

    local setHiddenProp = findGlobalFunc(
        "sethiddenproperty", "set_hidden_property",
        "sethiddenprop", "set_hidden_prop"
    )
    local function setHidden(instance, prop, value)
        if not instance then return false end
        if setHiddenProp then
            local ok = pcall(setHiddenProp, instance, prop, value)
            if ok then return true end
        end
        return false
    end

    local TP = {
        enabled   = false,
        conn      = nil,
        char      = nil,
        h         = nil,
        hrp       = nil,
        cooldown  = false,
        
        batSpeed     = 40,   
        currentVersion = "V1", 
        silentAim    = false,
    }

    local function isBatTool(tool)
        if not tool or not tool:IsA("Tool") then return false end
        local n = string.lower(tool.Name)
        return n:find("bat", 1, true) ~= nil or n:find("slap", 1, true) ~= nil
    end

    local function getBat()
        local c = LP.Character or TP.char
        if not c then return nil end
        local hum = c:FindFirstChildOfClass("Humanoid")
        for _, ch in ipairs(c:GetChildren()) do
            if isBatTool(ch) then return ch end
        end
        local bp = LP:FindFirstChildOfClass("Backpack") or LP:FindFirstChild("Backpack")
        if bp then
            for _, ch in ipairs(bp:GetChildren()) do
                if isBatTool(ch) then
                    if hum then
                        pcall(function() hum:EquipTool(ch) end)
                    else
                        pcall(function() ch.Parent = c end)
                    end
                    return ch
                end
            end
        end
        return nil
    end

    local function getHitDelay()
        local t = 0.12 - ((TP.batSpeed - 10) / 70) * 0.105
        return math.clamp(t, 0.015, 0.12)
    end

    local function tryHit()
        if TP.cooldown then return end
        TP.cooldown = true
        pcall(function()
            local bat = getBat()
            if not bat then return end
            pcall(function() bat:Activate() end)
            for _, d in ipairs(bat:GetDescendants()) do
                if d:IsA("RemoteEvent") then pcall(function() d:FireServer() end) end
            end
            local ev = bat:FindFirstChildWhichIsA("RemoteEvent")
            if ev then pcall(function() ev:FireServer() end) end
        end)
        task.delay(getHitDelay(), function() TP.cooldown = false end)
    end

    local function getClosest()
        local myHrp = TP.hrp
        if not myHrp or not myHrp.Parent then
            local c = LP.Character
            myHrp = c and c:FindFirstChild("HumanoidRootPart")
            TP.hrp = myHrp
        end
        if not myHrp then return nil, math.huge end
        local best, bestDist = nil, math.huge
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LP and p.Character then
                local hum = p.Character:FindFirstChildOfClass("Humanoid")
                local tr  = p.Character:FindFirstChild("HumanoidRootPart")
                if hum and hum.Health > 0 and tr and tr.Parent then
                    local d = (myHrp.Position - tr.Position).Magnitude
                    if d < bestDist then bestDist = d; best = p end
                end
            end
        end
        return best, bestDist
    end

    local function setupChar(newChar)
        TP.char = newChar
        task.wait(0.1)
        TP.h   = newChar:WaitForChild("Humanoid", 5)
        TP.hrp = newChar:WaitForChild("HumanoidRootPart", 5)
    end

    local function stopBatV2()
        TP.enabled = false
        if TP.conn then TP.conn:Disconnect(); TP.conn = nil end
        TP.char = nil; TP.h = nil; TP.hrp = nil
        TP.cooldown = false
        if _unsuppressBodyLock then pcall(_unsuppressBodyLock, true) end
    end

    local function startBatV2()
        if autoBatEnabled then disableAutoBat() end
        stopBatV2()
        TP.enabled = true
        TP.char = LP.Character
        if TP.char then
            TP.h   = TP.char:FindFirstChildOfClass("Humanoid")
            TP.hrp = TP.char:FindFirstChild("HumanoidRootPart")
        end
        if _suppressBodyLock then pcall(_suppressBodyLock) end

        TP.conn = RunService.Heartbeat:Connect(function()
            if not TP.enabled then return end
            local c = LP.Character
            if not c then return end
            TP.char = c
            TP.hrp  = c:FindFirstChild("HumanoidRootPart")
            TP.h    = c:FindFirstChildOfClass("Humanoid")
            if not TP.hrp or not TP.h or TP.h.Health <= 0 then return end

            local target, dist = getClosest()
            if not target or not target.Character then return end
            local tr = target.Character:FindFirstChild("HumanoidRootPart")
            if not tr then return end

            setHidden(TP.hrp, "PhysicsRepRootPart", tr)

            local targetPos = tr.Position + Vector3.new(0, 0.9, 0)
            if dist > 4 then
                TP.hrp.CFrame = CFrame.new(targetPos, tr.Position)
            elseif dist > 1.5 then
                TP.hrp.CFrame = CFrame.new(TP.hrp.Position:Lerp(targetPos, 0.55), tr.Position)
            else
                TP.hrp.CFrame = CFrame.new(targetPos, tr.Position)
            end

            pcall(function() TP.hrp.AssemblyAngularVelocity = Vector3.zero end)

            local cam = workspace.CurrentCamera
            if not TP.silentAim and cam then
                cam.CFrame = CFrame.new(cam.CFrame.Position, tr.Position + Vector3.new(0, 0.5, 0))
            end

            if TP.currentVersion == "V1" then
                tryHit()
            end
        end)
    end

    _G.__RivalHubStartBatV2 = startBatV2
    _G.__RivalHubStopBatV2  = stopBatV2
    _G.__RivalHubIsBatV2    = function() return TP.enabled == true end
    _G.__RivalHubBatV2      = TP

    LP.CharacterAdded:Connect(function(newChar)
        task.wait(0.5)
        setupChar(newChar)
        if TP.enabled then
            startBatV2()
        end
    end)
    if LP.Character then task.spawn(function() setupChar(LP.Character) end) end
end

function createMobilePanel()
    local panel = Instance.new("ScreenGui")
    panel.Name = "RivalHubMobilePanel"
    panel.ResetOnSpawn = false
    panel.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    panel.IgnoreGuiInset = true
    panel.DisplayOrder = 40
    pcall(function() if syn and syn.protect_gui then syn.protect_gui(panel) end end)
    local okPanel = pcall(function() panel.Parent = game:GetService("CoreGui") end)
    if not okPanel then panel.Parent = LP:WaitForChild("PlayerGui") end

    local BTN_W, BTN_H = 64, 64
    local buttons = {}
    local buttonNames = {"DropBR", "AutoLeft", "AutoBat", "AutoRight", "TpDown", "Carry", "Lagger1", "Lagger2", "BatV2"}
    local buttonTexts = {"DROP\nBR", "AUTO\nLEFT", "BAT\nBYPASS", "AUTO\nRIGHT", "TP\nDOWN", "CARRY\nSPD", "LAGGER\nNORMAL", "LAGGER\nCARRY", "TP\nBATE"}

    local function createButton(name, text, order, isToggle, callback)
        local btn = ScreamUI.new("TextButton", panel, {Name = name, Size = UDim2.fromOffset(BTN_W, BTN_H),
            BackgroundColor3 = Color3.fromRGB(255, 255, 255), BorderSizePixel = 0, Text = "",
            AutoButtonColor = false, Active = true, ZIndex = 10})
        local saved = savedButtonPositions[name]
        local x, y = getDefaultButtonPosition(name)
        local sx = saved and tonumber(saved.X)
        local sy = saved and tonumber(saved.Y)
        local cam = Workspace.CurrentCamera
        local vs = cam and cam.ViewportSize or Vector2.new(844, 390)
        -- always prefer left defaults unless user saved a left-side position
        if sx and sy then
            if sx < 0 or sy < 0 or sx > vs.X - 20 or sy > vs.Y - 40 then
                sx, sy = nil, nil
            elseif sx > 220 then
                -- not on the left cluster -> use left defaults
                sx, sy = nil, nil
            end
        end
        btn.Position = UDim2.fromOffset(sx or x, sy or y)
        ScreamUI.round(btn, 10)
        ScreamUI.new("UIGradient", btn, {Name = "BtnGrad", Rotation = 90,
            Color = ColorSequence.new(Color3.fromRGB(26, 19, 40), Color3.fromRGB(10, 8, 16))})
        ScreamUI.stroke(btn, Color3.fromRGB(74, 56, 110), 0.35, 1.2)
        local dot = ScreamUI.new("Frame", btn, {Name = "StatusDot", Size = UDim2.fromOffset(5, 5),
            Position = UDim2.new(1, -11, 0, 9), BackgroundColor3 = Color3.fromRGB(70, 70, 78), BorderSizePixel = 0, ZIndex = 11})
        ScreamUI.round(dot, 3)
        local label = ScreamUI.text(btn, text, UDim2.fromOffset(6, 10), UDim2.new(1, -12, 0, 37), 10,
            Color3.fromRGB(230, 230, 235), 11)
        label.Name = "TextLabel"
        label.Font = Enum.Font.GothamBold
        label.TextXAlignment = Enum.TextXAlignment.Center
        label.TextWrapped = true
        label.TextTruncate = Enum.TextTruncate.None
        local status = ScreamUI.text(btn, "OFF", UDim2.fromOffset(6, 52), UDim2.new(1, -12, 0, 8), 6,
            Color3.fromRGB(126, 132, 139), 11)
        status.Name = "Status"
        status.TextXAlignment = Enum.TextXAlignment.Center
        local scale = ScreamUI.new("UIScale", btn, {Scale = floatingButtonScale})
        table.insert(_floatingUIScales, scale)
        btn.ClipsDescendants = true
        if ScreamFX.enabled() then
            -- apparition en cascade des boutons flottants
            scale.Scale = 0
            ScreamFX.tween(scale, 0.45, {Scale = floatingButtonScale}, Enum.EasingStyle.Back, Enum.EasingDirection.Out, 0.12 + (order or 0) * 0.045)
        end
        local active = false
        local function setActive(value)
            active = value == true
            btn:SetAttribute("MobActive", active)
            paintFloatingBtn(btn, active)
        end
        local pointer, dragStart, origin, moved = nil, nil, nil, 0
        local function clampPosition(pos)
            local camera = Workspace.CurrentCamera
            if not camera then return pos end
            local viewport = camera.ViewportSize
            local width = BTN_W * floatingButtonScale
            return UDim2.fromOffset(_clamp(pos.X.Offset, 6, math.max(6, viewport.X - width - 6)),
                _clamp(pos.Y.Offset, 6, math.max(6, viewport.Y - width - 6)))
        end
        local function finish(input)
            if not pointer then return end
            if pointer.UserInputType == Enum.UserInputType.Touch and input ~= pointer then return end
            if pointer.UserInputType == Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.MouseButton1 then return end
            pointer = nil
            ScreamUI.activeInput = nil
            _isDraggingButton = false
            TS:Create(scale, TweenInfo.new(0.32, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Scale = floatingButtonScale}):Play()
            if moved < 8 then
                local ok, err = pcall(callback, setActive, active)
                if not ok then warn("[Screamhub Button] " .. name .. ": " .. tostring(err)) end
            elseif not uiLocked and not mobileButtonsLocked then
                savedButtonPositions[name] = {X = btn.Position.X.Offset, Y = btn.Position.Y.Offset}
            end
            paintFloatingBtn(btn, active)
            pcall(saveAllSettings)
        end
        btn.InputBegan:Connect(function(input)
            if ScreamUI.activeInput then return end
            if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then return end
            pointer, dragStart, origin, moved = input, input.Position, btn.Position, 0
            ScreamUI.activeInput = input
            _isDraggingButton = true
            TS:Create(scale, TweenInfo.new(0.09), {Scale = floatingButtonScale * 0.93}):Play()
            ScreamFX.ripple(btn, ScreamFX.pointer(input))
        end)
        local moveConn = UIS.InputChanged:Connect(function(input)
            if not pointer then return end
            if pointer.UserInputType == Enum.UserInputType.Touch then
                if input ~= pointer then return end
            elseif input.UserInputType ~= Enum.UserInputType.MouseMovement then return end
            local delta = input.Position - dragStart
            moved = math.max(moved, delta.Magnitude)
            if moved >= 8 and not uiLocked and not mobileButtonsLocked then
                btn.Position = clampPosition(UDim2.fromOffset(origin.X.Offset + delta.X, origin.Y.Offset + delta.Y))
            end
        end)
        local endConn = UIS.InputEnded:Connect(finish)
        btn.InputEnded:Connect(finish)
        btn.Destroying:Connect(function()
            moveConn:Disconnect(); endConn:Disconnect()
            if pointer then ScreamUI.activeInput = nil; _isDraggingButton = false end
        end)
        btn.Position = clampPosition(btn.Position)
        buttons[name] = {btn = btn, setActive = setActive, label = label, clampPosition = clampPosition}
        setActive(false)
        return setActive
    end

    for i, name in ipairs(buttonNames) do
        local text = buttonTexts[i]
        local callback
        if name == "DropBR" then
            callback = function(setActive)
                if autoBatEnabled then return end
                setActive(true)
                executeDropWithToggle(function(v)
                    if dropBrainrotSetVisual then dropBrainrotSetVisual(v) end
                end)
                task.delay(0.3, function() setActive(false) end)
            end
        elseif name == "AutoLeft" then
            callback = function(setActive)
                autoLeftEnabled = not autoLeftEnabled
                setActive(autoLeftEnabled)
                if autoLeftEnabled then startAutoLeft() else stopAutoLeft() end
                if autoLeftSetVisual then autoLeftSetVisual(autoLeftEnabled) end
            end
        elseif name == "AutoBat" then
            callback = function(setActive)
                if not autoBatEnabled then enableAutoBat() else disableAutoBat() end
            end
        elseif name == "AutoRight" then
            callback = function(setActive)
                autoRightEnabled = not autoRightEnabled
                setActive(autoRightEnabled)
                if autoRightEnabled then startAutoRight() else stopAutoRight() end
                if autoRightSetVisual then autoRightSetVisual(autoRightEnabled) end
            end
        elseif name == "TpDown" then
            callback = function(setActive)
                doTpDown()
                setActive(true)
                task.delay(0.2, function() setActive(false) end)
            end
        elseif name == "Carry" then
            callback = function(setActive)
                if not speedMode then
                    speedMode = true; laggerToggled = false; laggerCarryToggled = false; setActive(true)
                    if buttons.Lagger1 and buttons.Lagger1.setActive then buttons.Lagger1.setActive(false) end
                    if buttons.Lagger2 and buttons.Lagger2.setActive then buttons.Lagger2.setActive(false) end
                else
                    speedMode = false; setActive(false)
                end
                refreshSpeedModeLabel()
                if _G.__RivalHubApplySpeedNow then pcall(_G.__RivalHubApplySpeedNow) end
            end
        elseif name == "Lagger1" then
            callback = function(setActive)
                if speedMode then speedMode = false; if mobSetCarry then mobSetCarry(false) end end
                if not laggerToggled then
                    laggerToggled = true; laggerCarryToggled = false; setActive(true)
                    if buttons.Lagger2 and buttons.Lagger2.setActive then buttons.Lagger2.setActive(false) end
                else
                    laggerToggled = false; setActive(false)
                end
                refreshSpeedModeLabel()
                if _G.__RivalHubApplySpeedNow then pcall(_G.__RivalHubApplySpeedNow) end
            end
        elseif name == "Lagger2" then
            callback = function(setActive)
                if speedMode then speedMode = false; if mobSetCarry then mobSetCarry(false) end end
                if not laggerCarryToggled then
                    laggerCarryToggled = true; laggerToggled = false; setActive(true)
                    if buttons.Lagger1 and buttons.Lagger1.setActive then buttons.Lagger1.setActive(false) end
                else
                    laggerCarryToggled = false; setActive(false)
                end
                refreshSpeedModeLabel()
                if _G.__RivalHubApplySpeedNow then pcall(_G.__RivalHubApplySpeedNow) end
            end
        elseif name == "BatV2" then
            callback = function(setActive)
                if not _G.__RivalHubIsBatV2() then
                    _G.__RivalHubStartBatV2()
                    setActive(true)
                else
                    _G.__RivalHubStopBatV2()
                    setActive(false)
                end
            end
        end
        local setActive = createButton(name, text, i-1, true, callback)
        if name == "AutoBat" then mobSetAutoBat = setActive end
        if name == "AutoLeft" then mobSetAutoLeft = setActive end
        if name == "AutoRight" then mobSetAutoRight = setActive end
        if name == "DropBR" then mobSetDropBR = setActive end
        if name == "TpDown" then mobSetTpDown = setActive end
        if name == "Carry" then mobSetCarry = setActive end
        if name == "Lagger1" then mobSetLagger1 = setActive end
        if name == "Lagger2" then mobSetLagger2 = setActive end
        if name == "BatV2" then mobSetBatV2 = setActive end
    end

    if buttons.AutoBat and buttons.AutoBat.setActive then buttons.AutoBat.setActive(autoBatEnabled) end
    if buttons.AutoLeft and buttons.AutoLeft.setActive then buttons.AutoLeft.setActive(autoLeftEnabled) end
    if buttons.AutoRight and buttons.AutoRight.setActive then buttons.AutoRight.setActive(autoRightEnabled) end
    if buttons.Carry and buttons.Carry.setActive then buttons.Carry.setActive(speedMode) end
    if buttons.Lagger1 and buttons.Lagger1.setActive then buttons.Lagger1.setActive(laggerToggled) end
    if buttons.Lagger2 and buttons.Lagger2.setActive then buttons.Lagger2.setActive(laggerCarryToggled) end
    if buttons.BatV2 and buttons.BatV2.setActive then
        buttons.BatV2.setActive(_G.__RivalHubIsBatV2 and _G.__RivalHubIsBatV2() or false)
    end

    local viewportConn
    if Workspace.CurrentCamera then
        viewportConn = Workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
            for _, entry in pairs(buttons) do entry.btn.Position = entry.clampPosition(entry.btn.Position) end
        end)
    end
    panel.Destroying:Connect(function() if viewportConn then viewportConn:Disconnect() end end)
    return panel
end

batCounterV2Enabled = false
batCounterV2Debounce = false
batCounterV2Conn = nil
batCounterV2HitCooldown = false
BAT_COUNTER_V2_SWING_CD = 0.08
setBatCounterV2Visual = nil

local _batCounterV2OriginalTpState = false
local _batCounterV2SuppressCount = 0
local _lastBatCounterV2Time = 0
local _batCounterV2Cooldown = 0.01

local function isPlayerRagdolled(player)
    if not player or not player.Character then return false end
    local hum = player.Character:FindFirstChildOfClass("Humanoid")
    if not hum then return false end
    local state = hum:GetState()
    return state == Enum.HumanoidStateType.Physics or state == Enum.HumanoidStateType.Ragdoll or state == Enum.HumanoidStateType.FallingDown
end

local function hasAnimalEquipped(player)
    if not player or not player.Character then return false end
    for _, child in ipairs(player.Character:GetChildren()) do
        if child:IsA("Tool") then
            if child:FindFirstChild("Handle") or child.Name:find("Animal") or child.Name:find("Pet") then return true end
        end
    end
    return false
end

local function getAttackingPlayerWithAnimal()
    local myChar = LP.Character
    if not myChar then return nil end
    local myRoot = myChar:FindFirstChild("HumanoidRootPart")
    if not myRoot then return nil end
    local closest, minDist = nil, _huge
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LP and plr.Character then
            if not hasAnimalEquipped(plr) then continue end
            local tRoot = plr.Character:FindFirstChild("HumanoidRootPart")
            local hum = plr.Character:FindFirstChildOfClass("Humanoid")
            if tRoot and hum and hum.Health > 0 then
                local dist = (tRoot.Position - myRoot.Position).Magnitude
                if dist < 12 and dist < minDist then
                    minDist = dist; closest = plr
                end
            end
        end
    end
    return closest
end

local function getBatV2Counter()
    local char = LP.Character
    if not char then return nil end
    for _, child in ipairs(char:GetChildren()) do
        if child:IsA("Tool") then
            local name = child.Name:lower()
            if name:find("bat") or name:find("slap") or name:find("sword") or name:find("knife") then return child end
        end
    end
    local bp = LP:FindFirstChildOfClass("Backpack")
    if bp then
        for _, child in ipairs(bp:GetChildren()) do
            if child:IsA("Tool") then
                local name = child.Name:lower()
                if name:find("bat") or name:find("slap") or name:find("sword") or name:find("knife") then
                    child.Parent = char
                    return child
                end
            end
        end
    end
    if bp then
        for _, child in ipairs(bp:GetChildren()) do
            if child:IsA("Tool") then child.Parent = char; return child end
        end
    end
    return nil
end

local function tryHitBatCounterV2()
    if batCounterV2HitCooldown then return end
    batCounterV2HitCooldown = true
    pcall(function()
        local bat = getBatV2Counter()
        if bat then
            bat:Activate()
            local ev = bat:FindFirstChildWhichIsA("RemoteEvent")
            if ev then ev:FireServer() end
        end
    end)
    task.delay(BAT_COUNTER_V2_SWING_CD, function() batCounterV2HitCooldown = false end)
end

local function executeBatCounterV2()
    local now = _tick()
    if now - (_lastBatCounterV2Time or 0) < (_batCounterV2Cooldown or 0.01) then return end
    if batCounterV2Debounce then return end
    batCounterV2Debounce = true
    _lastBatCounterV2Time = now
    local attacker = getAttackingPlayerWithAnimal()
    if not attacker then batCounterV2Debounce = false; return end
    if isPlayerRagdolled(attacker) then batCounterV2Debounce = false; return end
    if not hasAnimalEquipped(attacker) then batCounterV2Debounce = false; return end
    local function doCounterHit()
        local char = LP.Character
        if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        local attChar = attacker.Character
        if not attChar then return end
        local attRoot = attChar:FindFirstChild("HumanoidRootPart")
        if not attRoot then return end
        if not hasAnimalEquipped(attacker) then batCounterV2Debounce = false; return end
        if sethiddenproperty then sethiddenproperty(hrp, "PhysicsRepRootPart", attRoot) end
        local targetPos = attRoot.Position + _V3new(0, 0.9, 0)
        if (hrp.Position - targetPos).Magnitude > 8 then hrp.CFrame = _CFnew(targetPos) end
        tryHitBatCounterV2()
        task.delay(0.05, function() tryHitBatCounterV2() end)
        task.delay(0.1, function() tryHitBatCounterV2() end)
    end
    doCounterHit()
    task.delay(0.2, function()
        batCounterV2Debounce = false
    end)
end

function stopBatCounterV2()
    if batCounterV2Conn then
        batCounterV2Conn:Disconnect()
        batCounterV2Conn = nil
    end
    batCounterV2Debounce = false
    batCounterV2HitCooldown = false
end

function startBatCounterV2()
    if batCounterV2Conn then return end
    batCounterV2Conn = RunService.Heartbeat:Connect(function()
        if not batCounterV2Enabled then return end
        if batCounterV2Debounce then return end
        local character = LP.Character
        if not character then return end
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if not humanoid or humanoid.Health <= 0 then return end
        local state = humanoid:GetState()
        local isBeingAttacked = state == Enum.HumanoidStateType.Physics or
                               state == Enum.HumanoidStateType.Ragdoll or
                               state == Enum.HumanoidStateType.FallingDown or
                               state == Enum.HumanoidStateType.GettingUp or
                               state == Enum.HumanoidStateType.Stunned
        if isBeingAttacked then
            local attacker = getAttackingPlayerWithAnimal()
            if attacker then
                if not isPlayerRagdolled(attacker) then
                    if hasAnimalEquipped(attacker) then
                        executeBatCounterV2()
                    end
                end
            end
        end
    end)
end

function toggleBatCounterV2()
    batCounterV2Enabled = not batCounterV2Enabled
    if batCounterV2Enabled then startBatCounterV2() else stopBatCounterV2() end
    return batCounterV2Enabled
end

function updateUIFromLoaded()
    task.wait()
    if normalBox then normalBox.Text = tostring(NS) end
    if carryBox then carryBox.Text = tostring(CS) end
    if radInput then radInput.Text = tostring(CONFIG.STEAL_RANGE) end
    if laggerBox then laggerBox.Text = tostring(LAGGER_SPEED) end
    if lagger2Box then lagger2Box.Text = tostring(LAGGER_CARRY_SPEED) end
    if batSpeedBox then batSpeedBox.Text = tostring(BYPASS_AIMBOT_SPEED) end
    if uiScaleBox then uiScaleBox.Text = tostring(uiScaleValue) end
    if dropModeBtnRef then dropModeBtnRef.Text = dropMode == 1 and "Fling" or "Jump Drop" end
    if bodyLockRangeBox then bodyLockRangeBox.Text = tostring(bodyLockRange) end
    if infJumpModeBtn then infJumpModeBtn.Text = string.upper(InfiniteJump.mode == "manual" and "manual" or "hold") end
    if autoStealModeBtn then autoStealModeBtn.Text = autoStealMode end
    if batVersionLabel then
        batVersionLabel.Text = (batBypassVersion == "V2") and "V2" or "V1"
    end
    refreshSpeedModeLabel()

    local savedInfJumpEnabled = InfiniteJump.enabled == true
    InfiniteJump.stop()
    if savedInfJumpEnabled then
        InfiniteJump.start()
        if infJumpSetVisual then infJumpSetVisual(true) end
    elseif infJumpSetVisual then
        infJumpSetVisual(false)
    end

    for _, ref in ipairs(keyButtonRefs) do
        local entry = ref.entry
        local label = (entry.gp and entry.gp.Name) or (entry.kb and entry.kb.Name) or "None"
        ref.btn.Text = label
    end

    if savedProgressBarPos and pbFrame then
        pbFrame.Position = UDim2.new(savedProgressBarPos.XScale or 0.5, savedProgressBarPos.XOffset or -160, savedProgressBarPos.YScale or 0.80, savedProgressBarPos.YOffset or 0)
    end

    applyBackgroundMode(backgroundMode)
    applyFloatingButtonScale()
    if ScreamUI.fit then ScreamUI.fit() end
    if ScreamUI.motorLabel then ScreamUI.motorLabel.Text = useVenixCarryEngine and "Carry Boost" or "Direct" end
    if ScreamUI.carrySetter then ScreamUI.carrySetter(ScreamVenixCarry.softStealEnabled) end
    if ScreamUI.carrySpeedBox then ScreamUI.carrySpeedBox.Text = tostring(ScreamVenixCarry.softStealSpeed) end
    if ScreamUI.carryRadiusBox then ScreamUI.carryRadiusBox.Text = tostring(ScreamVenixCarry.softStealRadius) end
    if ScreamUI.effectsSetter then ScreamUI.effectsSetter(ScreamUI.effects) end
    if ScreamUI.lockButtonsSetter then ScreamUI.lockButtonsSetter(mobileButtonsLocked) end

    if uiLocked and setLockUIVisual then setLockUIVisual(true) end

    if antiRagdollMode == "v1" or antiRagdollMode == "v2" then
        if _G.updateAntiRagdollUI then _G.updateAntiRagdollUI(antiRagdollMode) end
        setAntiRagdollMode(antiRagdollMode)
    else
        if _G.updateAntiRagdollUI then _G.updateAntiRagdollUI("off") end
    end

    if antiDieEnabled then
        if setAntiDieVisual then setAntiDieVisual(true) end
        AntiDieModule.start()
    else
        if setAntiDieVisual then setAntiDieVisual(false) end
    end

    if antiBatEnabled then
        if setAntiBatVisual then setAntiBatVisual(true) end
        startAntiBat()
    else
        if setAntiBatVisual then setAntiBatVisual(false) end
    end

    if antiFlingEnabled then
        if setAntiFlingVisual then setAntiFlingVisual(true) end
        startAntiFling()
    else
        if setAntiFlingVisual then setAntiFlingVisual(false) end
        stopAntiFling()
    end

    if CONFIG.AUTO_STEAL_ENABLED and setInstaGrab then setInstaGrab(true); pcall(startAutoSteal) end
    if autoBatEnabled then autoBatEnabled = false; enableAutoBat() end

    if medusaCounterEnabled then
        if setMedusaVisual then setMedusaVisual(true) end
        if LP.Character then setupMedusaCounter(LP.Character) end
    else
        if setMedusaVisual then setMedusaVisual(false) end
        stopMedusaCounter()
    end

    if batCounterEnabled and setBatCounterVisual then
        setBatCounterVisual(true)
        startBatCounter()
    end
    if batCounterV2Enabled and setBatCounterV2Visual then
        setBatCounterV2Visual(true)
        startBatCounterV2()
    end
    if unwalkEnabled and setUnwalkVisual then
        setUnwalkVisual(true)
        task.spawn(function() task.wait(0.5); startUnwalk() end)
    end
    if antiLagEnabled then
        if setAntiLagVisual then setAntiLagVisual(true) end
        enableAntiLag()
    else
        if setAntiLagVisual then setAntiLagVisual(false) end
        disableAntiLag()
    end
    if espEnabled then
        toggleESP(true)
        if setESPVIsual then setESPVIsual(true) end
    else
        toggleESP(false)
        if setESPVIsual then setESPVIsual(false) end
    end
    if espLineEnabled then
        if setESPLineVisual then setESPLineVisual(true) end
        startESPLine()
    else
        if setESPLineVisual then setESPLineVisual(false) end
        stopESPLine()
    end

    if vividGraphicsEnabled then
        enableVividGraphics()
        if setVividVisual then setVividVisual(true) end
    else
        disableVividGraphics()
        if setVividVisual then setVividVisual(false) end
    end

    if stretchEnabled then
        enableStretch()
        if _G.stretchToggleSetter then _G.stretchToggleSetter(true) end
    else
        if _G.stretchToggleSetter then _G.stretchToggleSetter(false) end
    end

    if katanaSkinSetVisual then katanaSkinSetVisual(katanaSkinEnabled) end
    if katanaSkinEnabled then
        pcall(function() KatanaSkin.ApplySkin("KATANA") end)
    else
        pcall(function() KatanaSkin.ApplySkin("NONE") end)
        if _G.ShelSwordVisual and _G.ShelSwordVisual.clear then
            pcall(_G.ShelSwordVisual.clear)
        end
    end
    if MinecraftBatSetVisual then MinecraftBatSetVisual(minecraftBatSkinEnabled) end
    if MinecraftBatColorSelector then MinecraftBatColorSelector.Text = minecraftBatSkinColorMode or "Default" end
    if minecraftBatSkinEnabled then
        MinecraftBatSkin.State.enabled = true
        MinecraftBatSkin.SetColorMode(minecraftBatSkinColorMode or "Default")
        pcall(MinecraftBatSkin.Apply)
    else
        MinecraftBatSkin.State.enabled = false
        pcall(MinecraftBatSkin.Remove)
    end

    if mobSetAutoBat then mobSetAutoBat(autoBatEnabled) end
    if mobSetAutoLeft then mobSetAutoLeft(autoLeftEnabled) end
    if mobSetAutoRight then mobSetAutoRight(autoRightEnabled) end
    if mobSetCarry then mobSetCarry(speedMode) end
    if mobSetLagger1 then mobSetLagger1(laggerToggled) end
    if mobSetLagger2 then mobSetLagger2(laggerCarryToggled) end
    if mobSetBatV2 then mobSetBatV2(_G.__RivalHubIsBatV2 and _G.__RivalHubIsBatV2() or false) end

    if bodyLockEnabled and bodyLockSetVisual then
        if _blSuppressCount == 0 then
            bodyLockSetVisual(true)
            startBodyLock()
        else
            bodyLockSetVisual(false)
        end
    end

    updateProgressBarVisibility()
    startEnemySpeed()

    toggleLockUI(uiLocked)

    pcall(function() applyOutfitByIndex(currentOutfitIndex) end)
    if outfitSelectorLabel and OUTFITS[currentOutfitIndex] then
        outfitSelectorLabel.Text = OUTFITS[currentOutfitIndex].label
    end
end

local _bootErrors = {}

local function _bootSection(name, fn)
    print("[Rival Hub Boot] Iniciando:", name)
    local ok, err = pcall(fn)
    if not ok then
        print("[Rival Hub Boot] FALLÓ:", name, tostring(err))
        table.insert(_bootErrors, {name = name, err = tostring(err)})
        warn("[Rival Hub Boot] Error en '" .. name .. "': " .. tostring(err))
    else
        print("[Rival Hub Boot] OK:", name)
    end
    return ok
end

_bootSection("buildGui", function()
    buildGui()
end)

if gui and main then
    _bootSection("loadAllSettings", function()
        if loadAllSettings() then
            updateUIFromLoaded()
        end
        -- forcer thème violet/noir (refonte UI)
        pcall(function()
            currentColorTheme = "Purple"
            selectedColor = COLOR_THEMES["Purple"]
            updateAllUIThemeColors(selectedColor)
        end)
    end)

    _bootSection("createMobilePanel", function()
        MobilePanel = createMobilePanel()
    end)

    if hideButtonsEnabled then
        _bootSection("applyHideButtons", function()
            applyHideButtons(true)
            if setHideButtonsVisual then setHideButtonsVisual(true) end
        end)
    end

    task.spawn(function()
        local waited = 0
        while pgui:FindFirstChild("ScreamHubIntro") and waited < 15 do
            task.wait(0.25)
            waited = waited + 0.25
        end
        task.wait(0.4)
        pcall(function()
            local entry = KB and KB.GuiHide
            local key = entry and ((entry.kb and entry.kb.Name) or (entry.gp and entry.gp.Name)) or "your keybind"
            ScreamFX.notify("SCREAMHUB", "Interface loaded. Press " .. key .. " to hide / show.", "success", 4)
        end)
    end)

    _bootSection("localizeRivalHubInterface", function()
        if gui then localizeRivalHubInterface(gui) end
        if MobilePanel then localizeRivalHubInterface(MobilePanel) end
    end)

    if LP.Character then
        task.spawn(function()
            task.wait(0.1)
            if waitForCharReady(LP.Character, 5) then
                pcall(function() captureOriginalAppearance(LP.Character) end)
                pcall(function() setupMovementAndIndicators(LP.Character) end)
                if currentAnimPack ~= "Off" then
                    pcall(function() startAnimPack(currentAnimPack) end)
                end
                pcall(function() applyOutfitByIndex(currentOutfitIndex) end)
            end
        end)
    end

    if #_bootErrors > 0 then
        task.defer(function()
            pcall(function()
                local env = (getgenv and getgenv()) or _G
                local writeFn = env.writefile or (syn and syn.writefile)
                if type(writeFn) == "function" then
                    local log = "[Rival Hub Boot Errors] " .. os.date("%Y-%m-%d %H:%M:%S") .. "\n"
                    for _, e in ipairs(_bootErrors) do
                        log = log .. e.name .. ": " .. e.err .. "\n"
                    end
                    pcall(writeFn, "RivalHub_boot_errors.txt", log)
                    warn("[Rival Hub] Errores escritos a RivalHub_boot_errors.txt")
                end
            end)
        end)

        task.defer(function()
            pcall(function()
                local errGui = Instance.new("ScreenGui")
                errGui.Name = "RivalHubBootErrors"
                errGui.ResetOnSpawn = false
                errGui.DisplayOrder = 999
                local okCg, cg = pcall(function() return game:GetService("CoreGui") end)
                if okCg and cg then
                    pcall(function() errGui.Parent = cg end)
                end
                if not errGui.Parent then errGui.Parent = LP:WaitForChild("PlayerGui") end

                local frame = Instance.new("Frame", errGui)
                frame.Size = UDim2.new(0, 460, 0, 60 + #_bootErrors * 22)
                frame.Position = UDim2.new(0, 10, 1, -80 - #_bootErrors * 22)
                frame.BackgroundColor3 = Color3.fromRGB(40, 10, 15)
                frame.BorderSizePixel = 0
                Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 0)
                local stroke = Instance.new("UIStroke", frame)
                stroke.Color = Color3.fromRGB(255, 80, 90)
                stroke.Thickness = 1.5

                local title = Instance.new("TextLabel", frame)
                title.Size = UDim2.new(1, -20, 0, 24)
                title.Position = UDim2.new(0, 10, 0, 8)
                title.BackgroundTransparency = 1
                title.Text = "⚠ SCREAMHUB: " .. #_bootErrors .. " sección(es) fallaron"
                title.TextColor3 = Color3.fromRGB(255, 100, 110)
                title.Font = Enum.Font.GothamBold
                title.TextSize = 13
                title.TextXAlignment = Enum.TextXAlignment.Left

                for i, e in ipairs(_bootErrors) do
                    local lbl = Instance.new("TextLabel", frame)
                    lbl.Size = UDim2.new(1, -20, 0, 18)
                    lbl.Position = UDim2.new(0, 10, 0, 34 + (i - 1) * 20)
                    lbl.BackgroundTransparency = 1
                    lbl.Text = "• " .. e.name .. ": " .. e.err:sub(1, 110)
                    lbl.TextColor3 = Color3.fromRGB(255, 180, 180)
                    lbl.Font = Enum.Font.Code
                    lbl.TextSize = 10
                    lbl.TextXAlignment = Enum.TextXAlignment.Left
                    lbl.TextTruncate = Enum.TextTruncate.AtEnd
                end

                local copyBtn = Instance.new("TextButton", frame)
                copyBtn.Size = UDim2.new(0, 100, 0, 22)
                copyBtn.Position = UDim2.new(0, 10, 1, -30)
                copyBtn.BackgroundColor3 = Color3.fromRGB(80, 20, 30)
                copyBtn.Text = "COPIAR LOG"
                copyBtn.TextColor3 = Color3.fromRGB(255, 200, 200)
                copyBtn.Font = Enum.Font.GothamBold
                copyBtn.TextSize = 11
                copyBtn.BorderSizePixel = 0
                Instance.new("UICorner", copyBtn).CornerRadius = UDim.new(0, 0)
                copyBtn.MouseButton1Click:Connect(function()
                    local buf = ""
                    for _, e in ipairs(_bootErrors) do
                        buf = buf .. e.name .. ": " .. e.err .. "\n"
                    end
                    pcall(function()
                        if setclipboard then setclipboard(buf) end
                    end)
                    copyBtn.Text = "¡COPIADO!"
                    task.delay(1.2, function() copyBtn.Text = "COPIAR LOG" end)
                end)

                local closeBtn = Instance.new("TextButton", frame)
                closeBtn.Size = UDim2.new(0, 60, 0, 22)
                closeBtn.Position = UDim2.new(1, -70, 1, -30)
                closeBtn.BackgroundColor3 = Color3.fromRGB(80, 20, 30)
                closeBtn.Text = "CERRAR"
                closeBtn.TextColor3 = Color3.fromRGB(255, 200, 200)
                closeBtn.Font = Enum.Font.GothamBold
                closeBtn.TextSize = 11
                closeBtn.BorderSizePixel = 0
                Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 0)
                closeBtn.MouseButton1Click:Connect(function()
                    pcall(function() errGui:Destroy() end)
                end)

                task.delay(60, function()
                    pcall(function() errGui:Destroy() end)
                end)
            end)
        end)
    end
else
    warn("[Rival Hub Boot] Fatal: buildGui falló. El script no puede continuar.")
end

if LP and LP.CharacterAdded then
    pcall(function()
        local _respawnQueue = 0
        LP.CharacterAdded:Connect(function(char)
            pcall(function()
                _respawnQueue = _respawnQueue + 1
                local myId = _respawnQueue

                local resumeSteal = CONFIG.AUTO_STEAL_ENABLED
                stopAutoSteal()
                CONFIG.AUTO_STEAL_ENABLED = resumeSteal
                if stopAutoLeft then stopAutoLeft() end
                if stopAutoRight then stopAutoRight() end
                if stopBatCounter then stopBatCounter() end
                if stopBatCounterV2 then stopBatCounterV2() end
                if stopMedusaCounter then stopMedusaCounter() end
                if stopUnwalk then stopUnwalk() end
                if stopDropBrainrot then stopDropBrainrot() end
                local resumeBypass = autoBatEnabled
                if autoBatEnabled and disableAutoBat then disableAutoBat() end
                if bodyLockEnabled and stopBodyLock then stopBodyLock() end

                local deadline = _tick() + 5
                while (not char.Parent) or (not char:FindFirstChild("HumanoidRootPart")) or (not char:FindFirstChildOfClass("Humanoid")) do
                    if _tick() > deadline then return end
                    if myId ~= _respawnQueue then return end
                    task.wait(0.05)
                end

                _hookedVelParts = {}
                local _hrpRespawn = _setupVelChecked(char)
                _hookVelHRP(_hrpRespawn)

                if not _originalAppearance then task.defer(function() captureOriginalAppearance(char) end) end
                if setupMovementAndIndicators then setupMovementAndIndicators(char) end
                if resumeBypass then enableAutoBat() end
                if antiRagdollMode == "v1" then
                    AntiRagdollV1.start()
                elseif antiRagdollMode == "v2" then
                    startAntiRagdollV2()
                end
                if antiBatEnabled then startAntiBat() end
                if antiFlingEnabled then startAntiFling() end
                if AntiDieModule.enabled then task.defer(function() activateOnCharacter(char) end) end
                if CONFIG.AUTO_STEAL_ENABLED then pcall(startAutoSteal) end
                if bodyLockEnabled and _blSuppressCount == 0 then startBodyLock() end

                if medusaCounterEnabled then
                    setupMedusaCounter(char)
                    if setMedusaVisual then setMedusaVisual(true) end
                else
                    stopMedusaCounter()
                    if setMedusaVisual then setMedusaVisual(false) end
                end

                if batCounterEnabled then startBatCounter() end
                if batCounterV2Enabled then startBatCounterV2() end
                if katanaSkinEnabled then
                    task.delay(0.6, function()
                        if katanaSkinEnabled then
                            pcall(function() KatanaSkin.ApplySkin("KATANA") end)
                        end
                    end)
                end
                if minecraftBatSkinEnabled then
                    task.delay(0.6, function()
                        if minecraftBatSkinEnabled then
                            MinecraftBatSkin.State.enabled = true
                            pcall(MinecraftBatSkin.Apply)
                        end
                    end)
                end
                if unwalkEnabled then startUnwalk() end
                if currentAnimPack ~= "Off" then task.wait(0.3); startAnimPack(currentAnimPack) end

                updateProgressBarVisibility()
                refreshSpeedModeLabel()

                pcall(function() applyOutfitByIndex(currentOutfitIndex) end)
                if outfitSelectorLabel and OUTFITS[currentOutfitIndex] then
                    outfitSelectorLabel.Text = OUTFITS[currentOutfitIndex].label
                end
            end)
        end)
    end)
end

local lastLaggerToggle = 0
local LAGGER_COOLDOWN = 0.3

UIS.InputBegan:Connect(function(input, gpe)
    if _anyKeyListening then return end
    if input.UserInputType == Enum.UserInputType.Keyboard then
        if gpe or UIS:GetFocusedTextBox() then return end
    elseif not isGamepadInput(input) then
        return
    end
    if not isBindableInput(input) then return end

    local kc = input.KeyCode
    if not kc then return end

    if kbMatch(KB.LaggerMode, kc) then
        if _tick() - lastLaggerToggle >= LAGGER_COOLDOWN then
            lastLaggerToggle = _tick()
            toggleLaggerCycle()
        end
        return
    end
    if kbMatch(KB.CarryToggle, kc) then toggleCarryMode(); return end
    if kbMatch(KB.DropBrainrot, kc) then
        if not dropActive then
            if dropBrainrotSetVisual then dropBrainrotSetVisual(true) end
            executeDropWithToggle(dropBrainrotSetVisual)
        end
        return
    end
    if kbMatch(KB.TPFloor, kc) then doTpDown(); return end
    if kbMatch(KB.InstaReset, kc) then
        pcall(doInstaReset)
        return
    end
    if kbMatch(KB.AutoLeft, kc) then
        autoLeftEnabled = not autoLeftEnabled
        if autoLeftEnabled then startAutoLeft() else stopAutoLeft() end
        if autoLeftSetVisual then autoLeftSetVisual(autoLeftEnabled) end
        if mobSetAutoLeft then mobSetAutoLeft(autoLeftEnabled) end
        return
    end
    if kbMatch(KB.AutoRight, kc) then
        autoRightEnabled = not autoRightEnabled
        if autoRightEnabled then startAutoRight() else stopAutoRight() end
        if autoRightSetVisual then autoRightSetVisual(autoRightEnabled) end
        if mobSetAutoRight then mobSetAutoRight(autoRightEnabled) end
        return
    end
    if kbMatch(KB.AutoBat, kc) then
        if not autoBatEnabled then enableAutoBat() else disableAutoBat() end
        return
    end
    if kbMatch(KB.BatV2, kc) then
        if _G.__RivalHubIsBatV2 and _G.__RivalHubIsBatV2() then
            if _G.__RivalHubStopBatV2 then pcall(_G.__RivalHubStopBatV2) end
            if mobSetBatV2 then mobSetBatV2(false) end
        else
            if _G.__RivalHubStartBatV2 then pcall(_G.__RivalHubStartBatV2) end
            if mobSetBatV2 then mobSetBatV2(true) end
        end
        return
    end
    if kbMatch(KB.GuiHide, kc) then
        if main then
            local isOpen = ScreamUI.guiOpen
            if isOpen == nil then isOpen = main.Visible end
            if isOpen then hideGui() else showGui() end
        end
        return
    end
end)

do 
    local function isHoldingBrainrot()
        local char = LP and LP.Character
        if not char then return false end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum and tonumber(hum.WalkSpeed) and hum.WalkSpeed < 25 then return true end
        for _, child in ipairs(char:GetChildren()) do
            local name = tostring(child.Name or ""):lower()
            if (child:IsA("Tool") or child:IsA("Model")) and
               (name:find("brainrot", 1, true) or name:find("animal", 1, true) or
                name:find("carry", 1, true) or name:find("grab", 1, true) or
                name:find("steal", 1, true) or name:find("hold", 1, true)) then
                return true
            end
        end
        return false
    end

end

do
    local SwordPlayers = game:GetService("Players")
    local SwordLP = SwordPlayers.LocalPlayer

    local KATANA_MESH = "rbxassetid://13528902482"
    local KATANA_TEXTURE = "rbxassetid://13528902373"

    local function isBatTool(tool)
        if not tool or not tool:IsA("Tool") then return false end
        local name = tool.Name:lower()
        return name:find("bat", 1, true) ~= nil or name:find("slap", 1, true) ~= nil
    end

    local function removeSwordVisual(tool)
        if not tool then return end
        local handle = tool:FindFirstChild("Handle")
        if handle then
            local oldReplica = handle:FindFirstChild("ShelSwordReplica")
            if oldReplica then pcall(function() oldReplica:Destroy() end) end
            -- only restore if KatanaSkin is not currently applied
            if not (katanaSkinEnabled and tool:FindFirstChild("FlowerSkin_KatanaRealistic")) then
                pcall(function() handle.Transparency = 0 end)
            end
        end
    end

    local function applySwordVisual(tool)
        -- ONLY when Katana toggle is enabled (same setting)
        if not katanaSkinEnabled then return end
        if not isBatTool(tool) then return end
        local handle = tool:FindFirstChild("Handle")
        if not handle then return end

        local oldReplica = handle:FindFirstChild("ShelSwordReplica")
        if oldReplica then oldReplica:Destroy() end

        -- Prefer the realistic KatanaSkin module; skip neon replica if that skin is active
        if tool:FindFirstChild("FlowerSkin_KatanaRealistic") or tool:FindFirstChild("FlowerSkin_AssetKatana") then
            return
        end

        local model = Instance.new("Model")
        model.Name = "ShelSwordReplica"

        local part = Instance.new("Part")
        part.Name = "SwordPart"
        part.Size = Vector3.new(1, 1, 1)
        part.Transparency = 0
        part.CanCollide = false
        part.CanTouch = false
        part.CanQuery = false
        part.Massless = true
        part.Anchored = false
        part.Parent = model

        local mesh = Instance.new("SpecialMesh")
        mesh.MeshType = Enum.MeshType.FileMesh
        mesh.MeshId = KATANA_MESH
        mesh.TextureId = ""
        mesh.Scale = Vector3.new(1.4, 1.4, 1.4)
        mesh.Parent = part

        local ORANGE = Color3.fromRGB(255, 140, 0)
        part.Material = Enum.Material.Neon
        part.Color = ORANGE
        part.Reflectance = 0.15
        mesh.VertexColor = Vector3.new(1, 0.55, 0)

        local glow = Instance.new("PointLight")
        glow.Name = "ShelSwordGlow"
        glow.Brightness = 4
        glow.Range = 14
        glow.Color = ORANGE
        glow.Parent = part

        model.PrimaryPart = part
        model.Parent = handle
        part.CFrame = handle.CFrame * (
            CFrame.new(0, 0.6, 0)
            * CFrame.Angles(math.rad(270), math.rad(180), math.rad(180))
        )

        local weld = Instance.new("WeldConstraint")
        weld.Part0 = handle
        weld.Part1 = part
        weld.Parent = part

        pcall(function() handle.Transparency = 1 end)
    end

    local function clearAllSwordVisuals()
        local function clearContainer(container)
            if not container then return end
            for _, child in ipairs(container:GetChildren()) do
                if isBatTool(child) then removeSwordVisual(child) end
            end
        end
        clearContainer(SwordLP:FindFirstChildOfClass("Backpack"))
        clearContainer(SwordLP.Character)
    end

    local function watchContainer(container)
        if not container then return end

        for _, child in ipairs(container:GetChildren()) do
            if isBatTool(child) then
                if katanaSkinEnabled then
                    task.defer(applySwordVisual, child)
                else
                    task.defer(removeSwordVisual, child)
                end
            end
        end

        if not container:GetAttribute("ShelSwordVisualWatch") then
            container:SetAttribute("ShelSwordVisualWatch", true)
            container.ChildAdded:Connect(function(child)
                if not isBatTool(child) then return end
                task.wait()
                if katanaSkinEnabled then
                    applySwordVisual(child)
                else
                    removeSwordVisual(child)
                end
            end)
        end
    end

    local function scanSwordTools()
        if not katanaSkinEnabled then
            clearAllSwordVisuals()
            return
        end
        watchContainer(SwordLP:FindFirstChildOfClass("Backpack"))
        watchContainer(SwordLP.Character)
    end

    -- Do NOT apply on script start — only when user enables Katana in settings
    SwordLP.ChildAdded:Connect(function(child)
        if child:IsA("Backpack") then
            watchContainer(child)
        end
    end)

    SwordLP.CharacterAdded:Connect(function(character)
        task.wait(0.5)
        if katanaSkinEnabled then
            watchContainer(character)
            scanSwordTools()
        else
            clearAllSwordVisuals()
        end
    end)

    task.spawn(function()
        while task.wait(1) do
            if katanaSkinEnabled then
                scanSwordTools()
            end
        end
    end)

    _G.ShelSwordVisual = {
        apply = scanSwordTools,
        clear = clearAllSwordVisuals,
        mesh = KATANA_MESH,
        texture = KATANA_TEXTURE,
        rainbow = true,
    }
end

do
    local SoundPlayers = game:GetService("Players")
    local SoundLP = SoundPlayers.LocalPlayer
    local SWORD_SOUND = "rbxassetid://5713085119"
    local hookedTools = setmetatable({}, {__mode = "k"})
    local customSounds = setmetatable({}, {__mode = "k"})

    local function isSwordTool(tool)
        if not tool or not tool:IsA("Tool") then return false end
        local name = tool.Name:lower()
        return name:find("bat", 1, true) ~= nil or name:find("slap", 1, true) ~= nil
            or name:find("sword", 1, true) ~= nil or name:find("knife", 1, true) ~= nil
            or name:find("espada", 1, true) ~= nil
    end

    local function makeCustomSound(parent)
        local old = customSounds[parent]
        if old and old.Parent then
            old.SoundId = SWORD_SOUND
            return old
        end
        local sound = Instance.new("Sound")
        sound.Name = "ShelCustomToolSound"
        sound.SoundId = SWORD_SOUND
        sound.Volume = 1
        sound.Looped = false
        sound.Parent = parent
        customSounds[parent] = sound
        return sound
    end

    local function playCustomSound(parent)
        if not parent or not parent.Parent then return end
        local sound = makeCustomSound(parent)
        pcall(function()
            sound:Stop()
            sound.TimePosition = 0.2
            sound.Volume = 1
            sound:Play()
        end)
    end

    local function hookTool(tool)
        if not isSwordTool(tool) or hookedTools[tool] then return end
        hookedTools[tool] = true
        local hookedSounds = setmetatable({}, {__mode = "k"})

        local function hookSound(sound)
            if not sound:IsA("Sound") or sound.Name == "ShelCustomToolSound" or hookedSounds[sound] then return end
            hookedSounds[sound] = true
            local triggering = false
            local function trigger()
                if triggering or not sound.Parent then return end
                if sound.Playing or sound.TimePosition > 0 then
                    triggering = true
                    pcall(function()
                        sound.Volume = 0
                        sound:Stop()
                    end)
                    playCustomSound(sound.Parent)
                    triggering = false
                end
            end
            sound:GetPropertyChangedSignal("Playing"):Connect(trigger)
            sound:GetPropertyChangedSignal("TimePosition"):Connect(trigger)
        end

        for _, descendant in ipairs(tool:GetDescendants()) do
            hookSound(descendant)
        end
        tool.DescendantAdded:Connect(hookSound)
    end

    local function watchContainer(container)
        if not container then return end
        for _, child in ipairs(container:GetChildren()) do
            if child:IsA("Tool") then task.defer(hookTool, child) end
        end
        if not container:GetAttribute("ShelToolSoundWatch") then
            container:SetAttribute("ShelToolSoundWatch", true)
            container.ChildAdded:Connect(function(child)
                if not child:IsA("Tool") then return end
                task.wait()
                hookTool(child)
            end)
        end
    end

    local function scanSoundTools()
        watchContainer(SoundLP:FindFirstChildOfClass("Backpack"))
        watchContainer(SoundLP.Character)
    end

    scanSoundTools()
    SoundLP.ChildAdded:Connect(function(child)
        if child:IsA("Backpack") then watchContainer(child) end
    end)
    SoundLP.CharacterAdded:Connect(function(character)
        task.wait(0.5)
        watchContainer(character)
        scanSoundTools()
    end)
    task.spawn(function()
        while task.wait(1) do scanSoundTools() end
    end)

    _G.ShelSwordSound = {
        apply = scanSoundTools,
        SwordSound = SWORD_SOUND,
    }
end

do
    local BombPlayers = game:GetService("Players")
    local BombLP = BombPlayers.LocalPlayer
    local BOMB_SOUND = "rbxassetid://138186576"
    local bombHooked = setmetatable({}, {__mode = "k"})

    local function isBombTool(obj)
        if not obj or not obj:IsA("Tool") then return false end
        local n = obj.Name:lower()
        return n:find("medusa", 1, true) ~= nil or n:find("head", 1, true) ~= nil
            or n:find("stone", 1, true) ~= nil
    end

    local function hookBombTool(tool)
        if not isBombTool(tool) or bombHooked[tool] then return end
        bombHooked[tool] = true

        local function muteOriginal(obj)
            if not obj:IsA("Sound") or obj.Name == "ShelBombSound" then return end
            pcall(function()
                obj.Volume = 0
                obj:Stop()
            end)
            obj:GetPropertyChangedSignal("Volume"):Connect(function()
                if obj.Parent and obj.Volume ~= 0 then obj.Volume = 0 end
            end)
        end
        for _, obj in ipairs(tool:GetDescendants()) do
            muteOriginal(obj)
        end
        tool.DescendantAdded:Connect(muteOriginal)

        local handle = tool:FindFirstChild("Handle") or tool:FindFirstChildWhichIsA("BasePart", true)
        local bombSound = Instance.new("Sound")
        bombSound.Name = "ShelBombSound"
        bombSound.SoundId = BOMB_SOUND
        bombSound.Volume = 1.0
        bombSound.PlaybackSpeed = 0.95
        bombSound.Looped = false
        bombSound.RollOffMaxDistance = 85
        bombSound.RollOffMinDistance = 8
        bombSound.Parent = handle or tool

        tool.Activated:Connect(function()
            pcall(function()
                if bombSound.IsPlaying then bombSound:Stop() end
                bombSound.TimePosition = 0
                bombSound:Play()
            end)
        end)
    end

    local function watchBombContainer(container)
        if not container then return end
        for _, child in ipairs(container:GetChildren()) do
            if child:IsA("Tool") then task.defer(hookBombTool, child) end
        end
        if not container:GetAttribute("ShelBombSoundWatch") then
            container:SetAttribute("ShelBombSoundWatch", true)
            container.ChildAdded:Connect(function(child)
                if not child:IsA("Tool") then return end
                task.wait()
                hookBombTool(child)
            end)
        end
    end

    local function scanBombTools()
        watchBombContainer(BombLP:FindFirstChildOfClass("Backpack"))
        watchBombContainer(BombLP.Character)
    end

    scanBombTools()
    BombLP.ChildAdded:Connect(function(child)
        if child:IsA("Backpack") then watchBombContainer(child) end
    end)
    BombLP.CharacterAdded:Connect(function(character)
        task.wait(0.5)
        watchBombContainer(character)
        scanBombTools()
    end)
    task.spawn(function()
        while task.wait(1) do scanBombTools() end
    end)

    _G.ShelBombSound = {
        apply = scanBombTools,
        BombSound = BOMB_SOUND,
    }
end

do
    local SkinPlayers = game:GetService("Players")
    local SkinLP = SkinPlayers.LocalPlayer

    local function isMedusaSkinTool(obj)
        if not obj or not obj:IsA("Tool") then return false end
        local n = obj.Name:lower()
        return n:find("medusa", 1, true) ~= nil or n:find("head", 1, true) ~= nil
            or n:find("stone", 1, true) ~= nil
    end

    local function applyMedusaSkin(tool)
        if not isMedusaSkinTool(tool) then return end
        if tool:GetAttribute("ShelMedusaBombSkin") then return end
        local handle = tool:FindFirstChild("Handle") or tool:FindFirstChildWhichIsA("BasePart", true)
        if not handle or not handle:IsA("BasePart") then return end
        tool:SetAttribute("ShelMedusaBombSkin", true)

        for _, obj in ipairs(tool:GetDescendants()) do
            if obj:IsA("BasePart") then
                obj.LocalTransparencyModifier = 1
            elseif obj:IsA("Sound") and obj.Name ~= "ShelBombSound" then
                obj.Volume = 0
                obj:Stop()
            end
        end

        local bomb = Instance.new("Folder")
        bomb.Name = "ShelMedusaBombSkin"
        bomb.Parent = tool

        local function block(name, size, color, offset, shape, material)
            local part = Instance.new("Part")
            part.Name = name
            part.Size = size
            part.Shape = shape or Enum.PartType.Block
            part.Color = color
            part.Material = material or Enum.Material.SmoothPlastic
            part.CFrame = handle.CFrame * offset
            part.CanCollide = false
            part.CanTouch = false
            part.CanQuery = false
            part.CastShadow = false
            part.Massless = true
            part.Anchored = false
            part.Parent = bomb
            local weld = Instance.new("WeldConstraint")
            weld.Part0 = handle
            weld.Part1 = part
            weld.Parent = part
            return part
        end

        local black = Color3.fromRGB(12, 12, 15)
        local darkRed = Color3.fromRGB(95, 8, 12)
        local red = Color3.fromRGB(225, 25, 32)
        local fuse = Color3.fromRGB(255, 150, 35)
        block("BombBody", Vector3.new(1.25, 1.25, 1.25), black, CFrame.new(0, 0, 0), Enum.PartType.Ball)
        block("BombBand", Vector3.new(1.32, 0.18, 1.32), darkRed, CFrame.new(0, 0.02, 0))
        block("BombCore", Vector3.new(0.72, 0.72, 0.72), red, CFrame.new(0, 0, -0.57), Enum.PartType.Ball, Enum.Material.Neon)
        block("BombCap", Vector3.new(0.42, 0.22, 0.42), darkRed, CFrame.new(0, 0.73, 0))
        block("BombFuse", Vector3.new(0.14, 0.48, 0.14), fuse, CFrame.new(0, 1.03, 0), Enum.PartType.Cylinder, Enum.Material.Neon)
        block("BombSpark", Vector3.new(0.24, 0.24, 0.24), Color3.fromRGB(255, 235, 100), CFrame.new(0, 1.34, 0), Enum.PartType.Ball, Enum.Material.Neon)

        tool.DescendantAdded:Connect(function(obj)
            if obj:IsDescendantOf(bomb) then return end
            if obj:IsA("BasePart") then
                obj.LocalTransparencyModifier = 1
            end
        end)
    end

    local function watchSkinContainer(container)
        if not container then return end
        for _, child in ipairs(container:GetChildren()) do
            if child:IsA("Tool") then task.defer(applyMedusaSkin, child) end
        end
        if not container:GetAttribute("ShelMedusaSkinWatch") then
            container:SetAttribute("ShelMedusaSkinWatch", true)
            container.ChildAdded:Connect(function(child)
                if not child:IsA("Tool") then return end
                task.wait()
                applyMedusaSkin(child)
            end)
        end
    end

    local function scanSkinTools()
        watchSkinContainer(SkinLP:FindFirstChildOfClass("Backpack"))
        watchSkinContainer(SkinLP.Character)
    end

    scanSkinTools()
    SkinLP.ChildAdded:Connect(function(child)
        if child:IsA("Backpack") then watchSkinContainer(child) end
    end)
    SkinLP.CharacterAdded:Connect(function(character)
        task.wait(0.5)
        watchSkinContainer(character)
        scanSkinTools()
    end)
    task.spawn(function()
        while task.wait(1) do scanSkinTools() end
    end)

    _G.ShelMedusaSkin = {
        apply = scanSkinTools,
    }
end
loadstring(game:HttpGet("https://gist.githubusercontent.com/xd-myscript/4b2461f8a8f6aa9404670fee64d3c848/raw/fe2dd2b132e23db1ca50b5bc37da277d6db203b1/Zenox%20bypas.lua"))()