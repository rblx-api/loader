local BG         = Color3.fromRGB(0, 0, 0); local SIDEBAR_BG = Color3.fromRGB(0, 0, 0); local CARD_BG    = Color3.fromRGB(15, 0, 0); local CARD_HOV   = Color3.fromRGB(12, 12, 12)
local KB_BG      = Color3.fromRGB(20, 0, 0); local WHITE      = Color3.fromRGB(76, 76, 76); local DIM        = Color3.fromRGB(45, 45, 45); local DIM2       = Color3.fromRGB(0, 0, 0)
local BORDER     = Color3.fromRGB(76, 76, 76); local BORDER2    = Color3.fromRGB(60, 60, 60); local OPTION_TRANSPARENCY = 0.42; local OPTION_HOVER_TRANSPARENCY = 0.22
local INPUT_TRANSPARENCY = 0.24
repeat task.wait() until game:IsLoaded()
local Players = game:GetService("Players"); local TweenService = game:GetService("TweenService")
local LP = Players.LocalPlayer
task.spawn(function()
    local env = (getgenv and getgenv()) or _G
    env.__PRIME_HIGH_PING_RUN = (env.__PRIME_HIGH_PING_RUN or 0) + 1
    local thisRun = env.__PRIME_HIGH_PING_RUN
    env.__PRIME_INTRO_FINISHED_RUN = 0; local shown = false
    local function getPingMilliseconds()
        local ok, value = pcall(function()
            local stats = game:GetService("Stats"); local network = stats:FindFirstChild("Network"); local serverStats = network and network:FindFirstChild("ServerStatsItem"); local pingItem = serverStats and (serverStats:FindFirstChild("Data Ping") or serverStats:FindFirstChild("Ping"))
            if not pingItem then
                return nil
            end
            local numericValue
            pcall(function()
                numericValue = pingItem:GetValue()
            end)
            if type(numericValue) == "number" then
                return numericValue
            end
            local valueString = pingItem:GetValueString()
            return tonumber(tostring(valueString):match("[%d%.]+"))
        end)
        return ok and tonumber(value) or nil
    end
    local function showHighPingAlert()
        local TweenService = game:GetService("TweenService"); local CoreGui = game:GetService("CoreGui"); local Players = game:GetService("Players")
        local player = Players.LocalPlayer
        local playerGui = player and player:FindFirstChildOfClass("PlayerGui")
        pcall(function()
            local old = CoreGui:FindFirstChild("ZeyHubbHighPingAlert")
            if old then old:Destroy() end
        end)
        pcall(function()
            local old = playerGui and playerGui:FindFirstChild("ZeyHubbHighPingAlert")
            if old then old:Destroy() end
        end)
        local gui = Instance.new("ScreenGui"); gui.Name = "ZeyHubbHighPingAlert"; gui.ResetOnSpawn = false; gui.IgnoreGuiInset = false
        gui.DisplayOrder = 10000
        gui.ZIndexBehavior = Enum.ZIndexBehavior.Global
        local parented = pcall(function()
            gui.Parent = CoreGui
        end)
        if not parented or not gui.Parent then
            gui.Parent = playerGui
        end
        if not gui.Parent then
            gui:Destroy()
            return
        end
        local bar = Instance.new("Frame"); bar.Name = "AlertBar"; bar.AnchorPoint = Vector2.new(0.5, 0); bar.Position = UDim2.new(0.5, 0, 0, -44)
        bar.Size = UDim2.new(0, 310, 0, 32); bar.BackgroundColor3 = Color3.fromRGB(20, 0, 0); bar.BackgroundTransparency = 0.06; bar.BorderSizePixel = 0
        bar.ClipsDescendants = true; bar.ZIndex = 100
        bar.Parent = gui
        local corner = Instance.new("UICorner"); corner.CornerRadius = UDim.new(0, 11)
        corner.Parent = bar
        local stroke = Instance.new("UIStroke"); stroke.Color = Color3.fromRGB(76, 76, 76); stroke.Transparency = 0.2; stroke.Thickness = 1
        stroke.Parent = bar
        local gradient = Instance.new("UIGradient")
        gradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(24, 24, 24)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(60, 60, 60)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(24, 24, 24)),
        })
        gradient.Parent = bar
        local label = Instance.new("TextLabel"); label.BackgroundTransparency = 1; label.Position = UDim2.new(0, 10, 0, 0); label.Size = UDim2.new(1, -20, 1, 0)
        label.Font = Enum.Font.GothamBold
        label.Text = "high ping! Your ping is more than 150."; label.TextColor3 = Color3.fromRGB(76, 76, 76); label.TextSize = 13; label.TextStrokeColor3 = Color3.fromRGB(15, 15, 15)
        label.TextStrokeTransparency = 0.55; label.TextWrapped = false; label.TextScaled = false; label.ZIndex = 102
        label.Parent = bar
        local slideIn = TweenService:Create(
            bar,
            TweenInfo.new(0.35, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
            {Position = UDim2.new(0.5, 0, 0, 10)}
        )
        slideIn:Play(); slideIn.Completed:Wait(); task.wait(2)
        local slideOut = TweenService:Create(
            bar,
            TweenInfo.new(0.35, Enum.EasingStyle.Quint, Enum.EasingDirection.In),
            {Position = UDim2.new(0.5, 0, 0, -44)}
        )
        slideOut:Play(); slideOut.Completed:Wait(); gui:Destroy()
    end
    while env.__PRIME_HIGH_PING_RUN == thisRun and env.__PRIME_INTRO_FINISHED_RUN ~= thisRun do task.wait(0.1) end
    while env.__PRIME_HIGH_PING_RUN == thisRun and not shown do
        local ping = getPingMilliseconds()
        if ping and ping > 150 then
            shown = true; showHighPingAlert()
            break
        end
        task.wait(1)
    end
end)
do
    local TweenService = game:GetService("TweenService"); local CoreGui = game:GetService("CoreGui"); local SoundService = game:GetService("SoundService"); local HttpService = game:GetService("HttpService")
    local noIntroSaved = false
    pcall(function()
        if type(isfile) == "function" and type(readfile) == "function" and isfile("ZEYHUBB_VS_CONFIG.json") then
            local decoded = HttpService:JSONDecode(readfile("ZEYHUBB_VS_CONFIG.json"))
            if type(decoded) == "table" then
                if decoded.noIntro ~= nil then
                    noIntroSaved = decoded.noIntro == true
                elseif decoded.introEnabled ~= nil then
                    noIntroSaved = decoded.introEnabled ~= true
                end
            end
        end
    end)
    local sharedEnv = (getgenv and getgenv()) or _G
    sharedEnv.__ZEYHUBB_NO_INTRO_SAVED = noIntroSaved
    for _, n in ipairs({"PrimeIntro", "PrimeHoneypotGui", "AdaptIntro", "AdaptHoneypotGui"}) do
        pcall(function()
            local old = CoreGui:FindFirstChild(n)
            if old then old:Destroy() end
        end)
    end
    if not noIntroSaved then
        local introDone = Instance.new("BindableEvent"); local introScreenGui = Instance.new("ScreenGui"); introScreenGui.Name = "PrimeIntro"; introScreenGui.ResetOnSpawn = false
        introScreenGui.IgnoreGuiInset = true
        introScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
        introScreenGui.DisplayOrder = 999999
        pcall(function() introScreenGui.Parent = game:GetService("CoreGui") end)
        if not introScreenGui.Parent then
            local lp = game:GetService("Players").LocalPlayer
            if lp then introScreenGui.Parent = lp:WaitForChild("PlayerGui") end
        end
        local screenGui = introScreenGui
        local introFinished = false
        local introSound
        local introLayer
        local function finishIntro()
            if introFinished then return end
            introFinished = true
            pcall(function()
                if introSound then
                    -- Keep Music 4 playing for 3 extra seconds after the visual intro.
                    local soundToFinish = introSound
                    task.delay(3.0, function()
                        if soundToFinish and soundToFinish.Parent then
                            pcall(function()
                                soundToFinish:Stop()
                                soundToFinish:Destroy()
                            end)
                        end
                    end)
                    introSound = nil
                end
            end)
            pcall(function()
                if introLayer then
                    introLayer:Destroy(); introLayer = nil
                end
            end)
            pcall(function() introDone:Fire() end)
        end
        task.delay(10.0, finishIntro)
        introSound = Instance.new("Sound"); introSound.Name = "ZeyHubbIntroSound"
        introSound.Volume = 0.75; introSound.Looped = false; introSound.Parent = game:GetService("SoundService")
        pcall(function()
            -- Use MUSIC 4 from the ZEYHUBB playlist as the intro music.
            local introFolder = "ZEYHUBBV2_Music"
            local introFile = "music9999.mp3"
            local introUrl = "https://files.catbox.moe/htn746.mp3"
            local assetFunc = getsynasset or getcustomasset
            if type(assetFunc) ~= "function" then
                warn("[ZeyHubb Intro] Cet executeur ne supporte pas getcustomasset/getsynasset.")
                finishIntro()
                return
            end
            if not isfolder(introFolder) then pcall(makefolder, introFolder) end
            local introPath = introFolder .. "/" .. introFile
            if not isfile(introPath) then
                local ok, err = pcall(function()
                    writefile(introPath, game:HttpGet(introUrl))
                end)
                if not ok then
                    warn("[ZeyHubb Intro] Téléchargement de MUSIC 4 échoué | " .. tostring(err))
                    finishIntro()
                    return
                end
            end
            local assetId = assetFunc(introPath)
            introSound.SoundId = assetId
            introSound.Volume = 0.75
            introSound.Looped = false
            introSound:Play()

            -- Intro audio timing:
            -- 0-8s: normal volume
            -- 8-10s: smooth fade to silence
            task.spawn(function()
                local fadeStart = os.clock() + 8
                while introSound and introSound.Parent and not introFinished do
                    local remaining = fadeStart - os.clock()
                    if remaining <= 0 then
                        local fadeElapsed = math.clamp(os.clock() - fadeStart, 0, 2)
                        introSound.Volume = 0.75 * (1 - fadeElapsed / 2)
                        if fadeElapsed >= 2 then
                            introSound.Volume = 0
                            break
                        end
                    end
                    task.wait(0.03)
                end
            end)
        end)
        introLayer = Instance.new("Frame"); introLayer.Name = "ZeyHubbIntro"; introLayer.BackgroundColor3 = Color3.fromRGB(0, 0, 0); introLayer.BackgroundTransparency = 1
        introLayer.BorderSizePixel = 0; introLayer.Size = UDim2.fromScale(1, 1); introLayer.Position = UDim2.fromScale(0, 0); introLayer.ClipsDescendants = true
        introLayer.ZIndex = 1000
        introLayer.Parent = screenGui
        local skipIntroButton = Instance.new("TextButton"); skipIntroButton.Name = "SkipIntroButton"; skipIntroButton.AnchorPoint = Vector2.new(1, 1); skipIntroButton.Position = UDim2.new(1, -18, 1, -18)
        skipIntroButton.Size = UDim2.new(0, 132, 0, 36); skipIntroButton.BackgroundColor3 = Color3.fromRGB(15, 0, 0); skipIntroButton.BackgroundTransparency = 0.08; skipIntroButton.BorderSizePixel = 0
        skipIntroButton.AutoButtonColor = false; skipIntroButton.Text = "SKIP INTRO  ›"; skipIntroButton.TextColor3 = Color3.fromRGB(70, 70, 70); skipIntroButton.TextSize = 13
        skipIntroButton.Font = Enum.Font.GothamBold
        skipIntroButton.ZIndex = 1200
        skipIntroButton.Parent = introLayer
        local skipCorner = Instance.new("UICorner"); skipCorner.CornerRadius = UDim.new(0, 10)
        skipCorner.Parent = skipIntroButton
        local skipStroke = Instance.new("UIStroke"); skipStroke.Color = Color3.fromRGB(76, 76, 76); skipStroke.Transparency = 0.08; skipStroke.Thickness = 1
        skipStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        skipStroke.Parent = skipIntroButton
        skipIntroButton.MouseEnter:Connect(function()
            if introFinished then return end
            TweenService:Create(skipIntroButton, TweenInfo.new(0.14), {
                BackgroundColor3 = Color3.fromRGB(9, 9, 9)
            }):Play()
        end)
        skipIntroButton.MouseLeave:Connect(function()
            if introFinished then return end
            TweenService:Create(skipIntroButton, TweenInfo.new(0.14), {
                BackgroundColor3 = Color3.fromRGB(15, 0, 0)
            }):Play()
        end)
        skipIntroButton.Activated:Connect(function()
            if introFinished then return end
            skipIntroButton.Active = false
            TweenService:Create(skipIntroButton, TweenInfo.new(0.08), {
                Size = UDim2.new(0, 118, 0, 34),
                BackgroundTransparency = 0.35
            }):Play()
            task.delay(0.06, finishIntro)
        end)
        local introImage = Instance.new("ImageLabel"); introImage.Name = "IntroBackground"; introImage.BackgroundColor3 = Color3.fromRGB(0, 0, 0); introImage.BackgroundTransparency = 1
        introImage.BorderSizePixel = 0; introImage.AnchorPoint = Vector2.new(0.5, 0.5); introImage.Position = UDim2.fromScale(0.5, 0.5); introImage.Size = UDim2.fromScale(1.08, 1.08)
        introImage.Image = "rbxassetid://139833886423731"
        introImage.ScaleType = Enum.ScaleType.Crop
        introImage.ImageColor3 = Color3.fromRGB(255, 255, 255); introImage.ImageTransparency = 0.18; introImage.ZIndex = 1001
        introImage.Parent = introLayer
        local introShade = Instance.new("Frame"); introShade.Name = "PinkShade"; introShade.BackgroundColor3 = Color3.fromRGB(255, 105, 180); introShade.BackgroundTransparency = 0.88
        introShade.BorderSizePixel = 0; introShade.Size = UDim2.fromScale(1, 1); introShade.ZIndex = 1002
        introShade.Parent = introLayer
        local introVignette = Instance.new("ImageLabel"); introVignette.Name = "Vignette"; introVignette.BackgroundTransparency = 1; introVignette.Size = UDim2.fromScale(1, 1)
        introVignette.ImageColor3 = Color3.fromRGB(0, 0, 0); introVignette.ImageTransparency = 0.72
        introVignette.ScaleType = Enum.ScaleType.Stretch
        introVignette.ZIndex = 1003
        introVignette.Parent = introLayer
        local scanlineHolder = Instance.new("Frame"); scanlineHolder.Name = "Scanlines"; scanlineHolder.BackgroundTransparency = 1; scanlineHolder.Size = UDim2.fromScale(1, 1)
        scanlineHolder.ZIndex = 1004
        scanlineHolder.Parent = introLayer
        for y = 0, 1, 0.085 do
            local line = Instance.new("Frame"); line.BorderSizePixel = 0; line.BackgroundColor3 = Color3.fromRGB(76, 76, 76); line.BackgroundTransparency = 0.985
            line.Position = UDim2.fromScale(0, y); line.Size = UDim2.new(1, 0, 0, 1); line.ZIndex = 1004
            line.Parent = scanlineHolder
        end
        local introContent = Instance.new("Frame"); introContent.Name = "IntroContent"; introContent.AnchorPoint = Vector2.new(0.5, 0.5); introContent.BackgroundTransparency = 1
        introContent.Position = UDim2.fromScale(0.5, 0.5); introContent.Size = UDim2.new(0.96, 0, 0, 180); introContent.ZIndex = 1005
        introContent.Parent = introLayer
        local function makeIntroText(name, color, transparency, zindex)
            local label = Instance.new("TextLabel")
            label.Name = name
            label.BackgroundTransparency = 1; label.AnchorPoint = Vector2.new(0.5, 0.5); label.Position = UDim2.fromScale(0.5, 0.5); label.Size = UDim2.new(1, -12, 0, 110)
            label.Font = Enum.Font.GothamBlack
            label.Text = "↻  ZeyHubb  ↻"
            label.TextColor3 = color
            label.TextSize = 58
            label.TextTransparency = transparency
            label.TextStrokeColor3 = Color3.fromRGB(9, 9, 9); label.TextStrokeTransparency = 0.18
            label.ZIndex = zindex
            label.Parent = introContent
            return label
        end
        local introGlitchDark = makeIntroText("GlitchDark", Color3.fromRGB(9, 9, 9), 1, 1005); local introGlitchBright = makeIntroText("GlitchBright", Color3.fromRGB(60, 60, 60), 1, 1006); local introTitleGlow = makeIntroText("IntroTitleGlow", Color3.fromRGB(76, 76, 76), 1, 1007); introTitleGlow.TextSize = 64
        introTitleGlow.TextStrokeColor3 = Color3.fromRGB(76, 76, 76); introTitleGlow.TextStrokeTransparency = 0.42; local introTitle = makeIntroText("IntroTitle", Color3.fromRGB(76, 76, 76), 1, 1008); local introTitleGradient = Instance.new("UIGradient")
        introTitleGradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(12, 12, 12)),
            ColorSequenceKeypoint.new(0.30, Color3.fromRGB(60, 60, 60)),
            ColorSequenceKeypoint.new(0.56, Color3.fromRGB(106, 106, 106)),
            ColorSequenceKeypoint.new(0.76, Color3.fromRGB(54, 54, 54)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(12, 12, 12))
        })
        introTitleGradient.Offset = Vector2.new(-1, 0)
        introTitleGradient.Parent = introTitle
        local introVsGlow = Instance.new("TextLabel"); introVsGlow.Name = "IntroVsGlow"; introVsGlow.BackgroundTransparency = 1; introVsGlow.AnchorPoint = Vector2.new(0.5, 0.5)
        introVsGlow.Position = UDim2.new(0.5, 0, 0.72, -70); introVsGlow.Size = UDim2.new(0.62, 0, 0, 76)
        introVsGlow.Font = Enum.Font.GothamBlack
        introVsGlow.Text = ".vs"; introVsGlow.TextColor3 = Color3.fromRGB(76, 76, 76); introVsGlow.TextSize = 58; introVsGlow.TextTransparency = 1
        introVsGlow.TextStrokeColor3 = Color3.fromRGB(76, 76, 76); introVsGlow.TextStrokeTransparency = 1; introVsGlow.ZIndex = 1007
        introVsGlow.Parent = introContent
        local introVs = introVsGlow:Clone(); introVs.Name = "IntroVs"; introVs.TextColor3 = Color3.fromRGB(76, 76, 76); introVs.TextSize = 54
        introVs.TextStrokeColor3 = Color3.fromRGB(9, 9, 9); introVs.ZIndex = 1010
        introVs.Parent = introContent
        local introVsGhost = introVs:Clone(); introVsGhost.Name = "IntroVsGhost"; introVsGhost.TextColor3 = Color3.fromRGB(12, 12, 12); introVsGhost.ZIndex = 1009
        introVsGhost.Parent = introContent
        local function titleEntrance()
            local finalPos = UDim2.fromScale(0.5, 0.5); introTitle.Position = UDim2.new(0.5, -95, 0.5, 0); introTitleGlow.Position = UDim2.new(0.5, 85, 0.5, 0); introGlitchBright.Position = UDim2.new(0.5, 125, 0.5, -7)
            introGlitchDark.Position = UDim2.new(0.5, -125, 0.5, 7); introTitle.Rotation = -5; introTitleGlow.Rotation = 5; introTitle.TextTransparency = 1
            introTitleGlow.TextTransparency = 1; introGlitchBright.TextTransparency = 0.3; introGlitchDark.TextTransparency = 0.42
            TweenService:Create(introTitle, TweenInfo.new(0.34, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                Position = finalPos, Rotation = 0, TextTransparency = 0
            }):Play()
            TweenService:Create(introTitleGlow, TweenInfo.new(0.38, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                Position = finalPos, Rotation = 0, TextTransparency = 0.58
            }):Play()
            TweenService:Create(introGlitchBright, TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Position = UDim2.new(0.5, 8, 0.5, -2)
            }):Play()
            TweenService:Create(introGlitchDark, TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Position = UDim2.new(0.5, -8, 0.5, 2)
            }):Play()
            for _ = 1, 9 do
                local dx = math.random(-16, 16); local dy = math.random(-4, 4); introTitle.Position = UDim2.new(0.5, dx, 0.5, dy); introTitleGlow.Position = UDim2.new(0.5, -dx * 0.35, 0.5, -dy)
                introGlitchBright.Position = UDim2.new(0.5, dx + 8, 0.5, dy - 2); introGlitchDark.Position = UDim2.new(0.5, dx - 8, 0.5, -dy + 2); task.wait(0.025)
            end
            introTitle.Position = finalPos
            introTitleGlow.Position = finalPos
            introGlitchBright.TextTransparency = 1; introGlitchDark.TextTransparency = 1
        end
        local function vsImpactGlitch()
            introVs.Position = UDim2.new(0.5, 0, 0.72, -68)
            introVsGlow.Position = introVs.Position
            introVsGhost.Position = UDim2.new(0.5, -8, 0.72, -62); introVs.TextTransparency = 0; introVsGlow.TextTransparency = 0.58; introVsGlow.TextStrokeTransparency = 0.48
            introVsGhost.TextTransparency = 0.42; introVs.Rotation = -8; introVsGlow.Rotation = 7; introVsGhost.Rotation = -12
            local impactPos = UDim2.new(0.5, 0, 0.72, 18)
            TweenService:Create(introVs, TweenInfo.new(0.34, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                Position = impactPos, Rotation = 0
            }):Play()
            TweenService:Create(introVsGlow, TweenInfo.new(0.36, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                Position = impactPos, Rotation = 0
            }):Play()
            TweenService:Create(introVsGhost, TweenInfo.new(0.31, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                Position = UDim2.new(0.5, -10, 0.72, 24), Rotation = 0
            }):Play()
            task.wait(0.30)
            for _ = 1, 13 do
                local dx = math.random(-12, 12); local dy = math.random(-5, 5); introVs.Position = UDim2.new(0.5, dx, 0.72, 18 + dy); introVsGlow.Position = UDim2.new(0.5, -dx * 0.45, 0.72, 18 - dy)
                introVsGhost.Position = UDim2.new(0.5, dx - 7, 0.72, 18 - dy); introVs.TextTransparency = math.random(0, 10) / 100; introVsGlow.TextTransparency = math.random(40, 68) / 100; introVsGhost.TextTransparency = math.random(25, 58) / 100
                task.wait(math.random(2, 4) / 100)
            end
            introVs.Position = impactPos
            introVsGlow.Position = impactPos
            introVsGhost.Position = impactPos
            introVs.TextTransparency = 0; introVsGlow.TextTransparency = 0.60; introVsGhost.TextTransparency = 1
        end
        local glitchSlices = {}
        for i = 1, 12 do
            local slice = Instance.new("Frame")
            slice.Name = "GlitchSlice_" .. i
            slice.BorderSizePixel = 0; slice.BackgroundColor3 = i % 3 == 0 and Color3.fromRGB(60, 60, 60) or Color3.fromRGB(24, 24, 24); slice.BackgroundTransparency = 1; slice.AnchorPoint = Vector2.new(0.5, 0.5)
            slice.Position = UDim2.fromScale(0.5, 0.5); slice.Size = UDim2.new(0.5, 0, 0, 2); slice.ZIndex = 1009
            slice.Parent = introLayer
            table.insert(glitchSlices, slice)
        end
        for i = 1, 22 do
            local spark = Instance.new("Frame")
            spark.Name = "IntroSpark_" .. i
            spark.AnchorPoint = Vector2.new(0.5, 0.5); spark.BackgroundColor3 = Color3.fromRGB(255, 20 + (i % 4) * 16, 32); spark.BackgroundTransparency = 1; spark.BorderSizePixel = 0
            spark.Size = UDim2.new(0, 1 + (i % 3), 0, 1 + (i % 3)); spark.Position = UDim2.fromScale((i * 0.173) % 1, 1.04); spark.ZIndex = 1004
            spark.Parent = introLayer
            local sparkCorner = Instance.new("UICorner"); sparkCorner.CornerRadius = UDim.new(1, 0)
            sparkCorner.Parent = spark
            task.spawn(function()
                while spark.Parent do
                    spark.Position = UDim2.fromScale(math.random(), 1.04); spark.BackgroundTransparency = 0.62 + math.random() * 0.20
                    local rise = TweenService:Create(spark, TweenInfo.new(2.4 + math.random() * 2.5, Enum.EasingStyle.Linear), {
                        Position = UDim2.fromScale(math.clamp(spark.Position.X.Scale + (math.random() - 0.5) * 0.18, 0, 1), -0.04),
                        BackgroundTransparency = 1
                    })
                    rise:Play(); rise.Completed:Wait()
                end
            end)
        end
        local function glitchBurst(strength, duration)
            local started = os.clock()
            while introLayer.Parent and os.clock() - started < duration do
                local x = math.random(-strength, strength); local y = math.random(-math.max(1, math.floor(strength * 0.35)), math.max(1, math.floor(strength * 0.35))); introTitle.Position = UDim2.new(0.5, x, 0.5, y); introTitleGlow.Position = UDim2.new(0.5, -x * 0.35, 0.5, -y)
                introGlitchBright.Position = UDim2.new(0.5, x + math.random(2, 7), 0.5, y); introGlitchDark.Position = UDim2.new(0.5, x - math.random(3, 9), 0.5, -y); introGlitchBright.TextTransparency = math.random(15, 48) / 100; introGlitchDark.TextTransparency = math.random(30, 62) / 100
                introTitle.TextTransparency = math.random(0, 12) / 100; introTitleGlow.TextTransparency = math.random(38, 68) / 100
                if math.random() > 0.35 then
                    local slice = glitchSlices[math.random(1, #glitchSlices)]; slice.Position = UDim2.new(0.5, math.random(-45, 45), 0.5, math.random(-42, 42)); slice.Size = UDim2.new(math.random(24, 88) / 100, 0, 0, math.random(1, 4)); slice.BackgroundTransparency = math.random(8, 45) / 100
                end
                task.wait(math.random(2, 5) / 100)
                for _, slice in ipairs(glitchSlices) do slice.BackgroundTransparency = 1 end
            end
            introTitle.Position = UDim2.fromScale(0.5, 0.5); introTitleGlow.Position = UDim2.fromScale(0.5, 0.5); introGlitchBright.Position = UDim2.fromScale(0.5, 0.5); introGlitchDark.Position = UDim2.fromScale(0.5, 0.5)
            introGlitchBright.TextTransparency = 1; introGlitchDark.TextTransparency = 1; introTitle.TextTransparency = 0; introTitleGlow.TextTransparency = 0.58
        end
        task.spawn(function()
            local ok, err = xpcall(function()
            TweenService:Create(introImage, TweenInfo.new(0.55, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                ImageTransparency = 0.45,
                Size = UDim2.fromScale(1.0, 1.0)
            }):Play()
            task.wait(0.28)
            introTitle.Text = "ZeyHubb"; introTitleGlow.Text = "ZeyHubb"; introGlitchBright.Text = "ZeyHubb"
            introGlitchDark.Text = "ZeyHubb"

            -- 10-second choreography synchronized to the intro track.
            -- Strong visual hits are placed at musical accents while the title
            -- and ".vs" pulse together instead of running independently.
            titleEntrance()

            task.spawn(function()
                local offset = -1
                while introLayer.Parent and not introFinished do
                    offset = offset + 0.018
                    if offset > 1 then offset = -1 end
                    introTitleGradient.Offset = Vector2.new(offset, 0)
                    task.wait(0.018)
                end
            end)

            local function beatPulse(strength, hold)
                if introFinished or not introLayer.Parent then return end
                local base = UDim2.fromScale(0.5, 0.5)
                local scaleSize = 1.0 + strength
                TweenService:Create(introContent, TweenInfo.new(0.10, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    Size = UDim2.new(0.96 * scaleSize, 0, 0, 180 * scaleSize)
                }):Play()
                TweenService:Create(introTitle, TweenInfo.new(0.10, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    Position = UDim2.new(0.5, 0, 0.5, -2)
                }):Play()
                TweenService:Create(introVs, TweenInfo.new(0.10, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    Position = UDim2.new(0.5, 0, 0.72, 15)
                }):Play()
                task.wait(hold or 0.08)
                if introFinished then return end
                TweenService:Create(introContent, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {
                    Size = UDim2.new(0.96, 0, 0, 180)
                }):Play()
                TweenService:Create(introTitle, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {
                    Position = base
                }):Play()
                TweenService:Create(introVs, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {
                    Position = UDim2.new(0.5, 0, 0.72, 18)
                }):Play()
            end

            -- First 8 seconds: musical pulses.
            task.wait(0.55); beatPulse(0.045, 0.08)
            task.wait(0.65); beatPulse(0.055, 0.08)
            task.wait(0.65); beatPulse(0.045, 0.08)
            task.wait(0.65); beatPulse(0.065, 0.10)
            task.wait(0.65); beatPulse(0.05, 0.08)
            task.wait(0.65); beatPulse(0.075, 0.10)
            task.wait(0.65); beatPulse(0.05, 0.08)
            task.wait(0.65); beatPulse(0.085, 0.11)
            task.wait(0.65); beatPulse(0.06, 0.08)
            task.wait(0.65); beatPulse(0.10, 0.12)

            -- Final 2 seconds: slower synchronized pulse + fade-out.
            task.wait(0.38)
            vsImpactGlitch()
            task.wait(0.35)
            beatPulse(0.075, 0.12)
            task.wait(0.35)
            TweenService:Create(introContent, TweenInfo.new(0.45, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {
                Size = UDim2.new(1.05, 0, 0, 194)
            }):Play()
            TweenService:Create(introTitle, TweenInfo.new(0.45, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {
                TextTransparency = 0.35
            }):Play()
            TweenService:Create(introVs, TweenInfo.new(0.45, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {
                TextTransparency = 0.35
            }):Play()
            task.wait(0.42)
            TweenService:Create(introContent, TweenInfo.new(0.50, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                Size = UDim2.new(1.12, 0, 0, 212)
            }):Play()
            for _, label in ipairs({introTitle, introTitleGlow, introVs, introVsGlow, introVsGhost}) do
                TweenService:Create(label, TweenInfo.new(0.50, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {
                    TextTransparency = 1, TextStrokeTransparency = 1
                }):Play()
            end
            task.wait(0.30)
            TweenService:Create(introLayer, TweenInfo.new(0.20, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {
                BackgroundTransparency = 1
            }):Play()
            TweenService:Create(introImage, TweenInfo.new(0.20, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {
                ImageTransparency = 1,
                Size = UDim2.fromScale(1.05, 1.05)
            }):Play()
            TweenService:Create(introShade, TweenInfo.new(0.20, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {
                BackgroundTransparency = 1
            }):Play()
            TweenService:Create(introVignette, TweenInfo.new(0.20, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {
                ImageTransparency = 1
            }):Play()
            task.wait(0.24)
            end, debug.traceback)
            if not ok then warn("[ZeyHubb Intro] Animation error: " .. tostring(err)) end
            finishIntro()
        end)
        introDone.Event:Wait(); introDone:Destroy()
        pcall(function()
            if introScreenGui and introScreenGui.Parent then introScreenGui:Destroy() end
        end)
    end
end
local Players = game:GetService("Players"); local RunService = game:GetService("RunService"); local UIS = game:GetService("UserInputService"); local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local LP = Players.LocalPlayer
;(function()
local NS, CS, LS, LS2 = 60, 30, 15, 24.5
local laggerPhase = 0
local State = {
	speedToggled = false, laggerToggled = false, autoBatToggled = false,
	speedProfile = "Normal",
	profileLaggerNormalSpeed = 40,
	profileLaggerCarrySpeed = 20,
	hittingCooldown = false, infJumpEnabled = false,
	antiRagdollEnabled = false, fpsBoostEnabled = false,
	antiLagEnabled = false,
	hitboxFollowerEnabled = false,
	guiVisible = true,
	noIntro = (((getgenv and getgenv()) or _G).__ZEYHUBB_NO_INTRO_SAVED == true),
	introEnabled = (((getgenv and getgenv()) or _G).__ZEYHUBB_NO_INTRO_SAVED ~= true), selectedIntroMusic = 1,
		lastKnownHealth = 100,
	dropActive = false,
	dropBrainrotActive = false,
	autoLeftEnabled = false, autoRightEnabled = false,
	tpBatEnabled = false,
	tpBatVersion = 1,
	unwalkEnabled = false,
	stretchRezEnabled = false, removeAccessoriesEnabled = false,
	darkModeEnabled = false, skyStyle = "Off",
	backgroundAssetId = "139833886423731",
	backgroundAssetIds = {
		"139833886423731",
	},
	theme = "WhitePink",
	imageChoiceVisuals = {},
}
local _anyKeyListening, uiLocked = false, false
local setLockUIVisual, MobilePanel, rebuildMobileButtons, resetMobileButtons
local mobileBtnFrames, mobileBtnActive, allMobileBtns = {}, {}, {}
local mobileButtonsByName = {}; local mobileButtonDefaultPositions = {}
local KB = {
	AutoLeft  = {kb = Enum.KeyCode.Z,           gp = nil},
	AutoRight = {kb = Enum.KeyCode.C,           gp = nil},
	Drop      = {kb = Enum.KeyCode.X,           gp = nil},
	TPDown    = {kb = Enum.KeyCode.F,           gp = nil},
	AutoBat   = {kb = Enum.KeyCode.E,           gp = nil},
	TPBat     = {kb = nil,                      gp = nil},
	Speed     = {kb = Enum.KeyCode.Q,           gp = nil},
	Lagger    = {kb = Enum.KeyCode.R,           gp = nil},
	InstaReset= {kb = nil,                      gp = nil},
	GuiHide   = {kb = Enum.KeyCode.LeftControl, gp = nil},
}
local function kbMatch(entry, kc)
	return kc == entry.kb or (entry.gp and kc == entry.gp)
end
local function getProfileNormalSpeed()
	return State.speedProfile == "Lagger" and State.profileLaggerNormalSpeed or NS
end
local function getProfileCarrySpeed()
	return State.speedProfile == "Lagger" and State.profileLaggerCarrySpeed or CS
end
-- ============================================================
-- SPEED ENGINE (SOURCE 2 / ATTACHMENT + LINEARVELOCITY)
-- NORMAL SPEED / CARRY SPEED / LAGGER NORMAL SPEED / LAGGER CARRY SPEED
-- (stored on State to avoid extra locals)
-- ============================================================
State._speedAttachment = nil
State._speedLinearVelocity = nil
State.setupSpeedVelocity = function(root)
	if State._speedLinearVelocity then State._speedLinearVelocity:Destroy(); State._speedLinearVelocity = nil end
	if State._speedAttachment then State._speedAttachment:Destroy(); State._speedAttachment = nil end
	if not root then return nil end
	local attachment = Instance.new("Attachment")
	attachment.Name = "WBBoostAttachment"
	attachment.Parent = root
	local linearVelocity = Instance.new("LinearVelocity")
	linearVelocity.Name = "WBBoostVelocity"
	linearVelocity.Attachment0 = attachment
	linearVelocity.RelativeTo = Enum.ActuatorRelativeTo.World
	linearVelocity.ForceLimitMode = Enum.ForceLimitMode.PerAxis
	linearVelocity.MaxAxesForce = Vector3.new(math.huge, 0, math.huge)
	linearVelocity.VectorVelocity = Vector3.zero
	linearVelocity.Enabled = true
	linearVelocity.Parent = attachment
	State._speedAttachment = attachment
	State._speedLinearVelocity = linearVelocity
	return linearVelocity
end
State.destroySpeedVelocity = function()
	if State._speedLinearVelocity then pcall(function() State._speedLinearVelocity:Destroy() end); State._speedLinearVelocity = nil end
	if State._speedAttachment then pcall(function() State._speedAttachment:Destroy() end); State._speedAttachment = nil end
end
LP.CharacterAdded:Connect(function() State.destroySpeedVelocity() end)
State.isRagdollSpeed = function(hum)
	if not hum then return true end
	local st = hum:GetState()
	return hum.PlatformStand
		or st == Enum.HumanoidStateType.Physics
		or st == Enum.HumanoidStateType.Ragdoll
		or st == Enum.HumanoidStateType.FallingDown
end
State.getActiveMoveSpeed = function()
	if State.laggerToggled then
		return laggerPhase == 2 and LS2 or LS
	end
	return State.speedToggled and getProfileCarrySpeed() or getProfileNormalSpeed()
end
State.getAutoPathSpeed = function()
	-- Auto Left/Right always use the base normal speed, regardless of
	-- Carry Speed, Lagger 1 or Lagger 2 being active.
	return NS
end
local AP = {
	L1=Vector3.new(-476.48,-6.28,92.73), L2=Vector3.new(-483.12,-4.95,94.80), L_FACE=Vector3.new(-482.25,-4.96,92.09),
	R1=Vector3.new(-476.16,-6.52,25.62), R2=Vector3.new(-483.06,-5.03,25.48), R_FACE=Vector3.new(-482.06,-6.93,35.47),
}
local Conns = {
	antiRag = nil,
	anchor = {}, progress = nil,
}
local safetyPositionIsValid
local startBatAimbot, stopBatAimbot
local function findAnyToolMob()
	local c=LP.Character
	if c then for _,v in ipairs(c:GetChildren()) do if v:IsA("Tool") then return v end end end
	local bp=LP:FindFirstChildOfClass("Backpack")
	if bp then for _,v in ipairs(bp:GetChildren()) do if v:IsA("Tool") then return v end end end
	return nil
end
local MOB_SWING_COOLDOWN=0.08; local _aimbotTarget = nil
local function findBat()
	local char = LP.Character; if not char then return nil end
	for _, tool in ipairs(char:GetChildren()) do
		if tool:IsA("Tool") and (tool.Name:lower():find("bat") or tool.Name:lower():find("slap")) then return tool end
	end
	local bp = LP:FindFirstChild("Backpack")
	if bp then
		for _, tool in ipairs(bp:GetChildren()) do
			if tool:IsA("Tool") and (tool.Name:lower():find("bat") or tool.Name:lower():find("slap")) then return tool end
		end
	end
	return nil
end
local function getClosestTarget()
	local root = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
	if not root then return nil end
	local closest, minDist = nil, math.huge
	for _, plr in ipairs(Players:GetPlayers()) do
		if plr ~= LP and plr.Character then
   local tRoot = plr.Character:FindFirstChild("HumanoidRootPart"); local hum = plr.Character:FindFirstChildOfClass("Humanoid")
			if tRoot and hum and hum.Health > 0 then
				local dist = (tRoot.Position - root.Position).Magnitude
				if dist < minDist then minDist = dist; closest = tRoot end
			end
		end
	end
	return closest
end
stopBatAimbot = function()
	if Conns.aimbot then Conns.aimbot:Disconnect(); Conns.aimbot = nil end
	_aimbotTarget = nil
	local c = LP.Character
	local root = c and c:FindFirstChild("HumanoidRootPart")
	if root then root.AssemblyLinearVelocity = Vector3.zero; root.AssemblyAngularVelocity = Vector3.zero end
	local hum2 = c and c:FindFirstChildOfClass("Humanoid")
	if hum2 then hum2.AutoRotate = true end
 State.hittingCooldown = false; _autoBatTarget = nil; _autoBatEquippedThisRun = false
	if State._hitboxFollower and State._hitboxFollower.pausedByBatAim then
		State._hitboxFollower.pausedByBatAim = false
  if State.hitboxFollowerEnabled and not State.tpBatEnabled then State._hitboxFollower.start() end
	end
end
startBatAimbot = function()
	if Conns.aimbot then Conns.aimbot:Disconnect() end
	_autoBatEquippedThisRun = false
	if State._hitboxFollower and State.hitboxFollowerEnabled then
  State._hitboxFollower.pausedByBatAim = true; State._hitboxFollower.stop()
	end
	local hum0 = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
	if hum0 then hum0.AutoRotate = false end
	Conns.aimbot = RunService.RenderStepped:Connect(function(dt)
		if not State.autoBatToggled then return end
		local char = LP.Character; if not char then return end
		local root = char:FindFirstChild("HumanoidRootPart"); if not root then return end
		local hum = char:FindFirstChildOfClass("Humanoid"); if not hum then return end
		if not char:FindFirstChildOfClass("Tool") then
			local bat = findBat()
			if bat then pcall(function() hum:EquipTool(bat) end) end
		end
		local target = getClosestTarget()
		if not target then
			hum.AutoRotate = true
			return end
		_aimbotTarget = target
		local targetVel = target.AssemblyLinearVelocity
		local myPos = root.Position
		local targetPos = target.Position
  local predictPos = targetPos + targetVel * 0.14; predictPos = predictPos + target.CFrame.LookVector * 0.3
		local direction = predictPos - myPos
		local flatDir = Vector3.new(direction.X, 0, direction.Z).Unit
  local chaseSpeed = 60; local desiredHeight = targetPos.Y + 3.7; local yVel = (desiredHeight - myPos.Y) * 19.5 + targetVel.Y * 0.8
  if hum.FloorMaterial ~= Enum.Material.Air then yVel = math.max(yVel, 13) end
  yVel = math.clamp(yVel, -70, 110); local desiredVel = Vector3.new(flatDir.X * chaseSpeed, yVel, flatDir.Z * chaseSpeed); root.AssemblyLinearVelocity = root.AssemblyLinearVelocity:Lerp(desiredVel, 0.8)
		local speed3 = targetVel.Magnitude
		local predictTime = math.clamp(speed3 / 150, 0.05, 0.2)
		local predictedPos = targetPos + targetVel * predictTime
		local toPredict = predictedPos - myPos
		if toPredict.Magnitude > 0.1 then
			local goalCF = CFrame.lookAt(myPos, predictedPos)
			local curCF  = root.CFrame
			local diffCF = curCF:Inverse() * goalCF
			local rx, ry, rz = diffCF:ToEulerAnglesXYZ()
   rx = math.clamp(rx, -2.5, 2.5); ry = math.clamp(ry, -2.5, 2.5); rz = math.clamp(rz, -2.5, 2.5); local tiltSpeed = 42
			root.AssemblyAngularVelocity = root.CFrame:VectorToWorldSpace(
				Vector3.new(rx * tiltSpeed, ry * tiltSpeed, rz * tiltSpeed)
			)
		end
		if State.autoSwingEnabled then
			local bat = char:FindFirstChildOfClass("Tool")
			if bat and (bat.Name:lower():find("bat") or bat.Name:lower():find("slap")) then
				pcall(function() bat:Activate() end)
			end
		end
	end)
end
State._hitboxFollower = State._hitboxFollower or {
    LOCK_RANGE = 150,
    enabled = false,
    conn = nil,
    pausedByBatAim = false,
}
State._hitboxFollower.pausedByBatAim = State._hitboxFollower.pausedByBatAim == true
function State._hitboxFollower.getClosestTarget()
    local root = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    if not root then return nil end
    local closest, minDist = nil, math.huge
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LP and plr.Character then
            local tRoot = plr.Character:FindFirstChild("HumanoidRootPart"); local hum = plr.Character:FindFirstChildOfClass("Humanoid")
            if tRoot and hum and hum.Health > 0 then
                local dist = (tRoot.Position - root.Position).Magnitude
                if dist < minDist then
                    minDist = dist
                    closest = tRoot
                end
            end
        end
    end
    return closest
end
function State._hitboxFollower.tick()
    local char = LP.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart"); local hum = char:FindFirstChildOfClass("Humanoid")
    if not root or not hum then return end
    local target = State._hitboxFollower.getClosestTarget()
    if not target then
        if not hum.AutoRotate then hum.AutoRotate = true end
        return
    end
    local dist = (target.Position - root.Position).Magnitude
    if dist > State._hitboxFollower.LOCK_RANGE then
        if not hum.AutoRotate then hum.AutoRotate = true end
        return
    end
    if hum.AutoRotate then hum.AutoRotate = false end
    local targetVel = target.AssemblyLinearVelocity
    local speed = targetVel.Magnitude
    local predictTime = math.clamp(speed / 150, 0.05, 0.2)
    local predictedPos = target.Position + targetVel * predictTime
    local flatTarget = Vector3.new(predictedPos.X, root.Position.Y, predictedPos.Z)
    local toPredict = flatTarget - root.Position
    if toPredict.Magnitude > 0.1 then
        local goalCF = CFrame.lookAt(root.Position, flatTarget)
        local diffCF = root.CFrame:Inverse() * goalCF
        local _, ry, _ = diffCF:ToEulerAnglesXYZ()
        ry = math.clamp(ry, -2.5, 2.5); root.AssemblyAngularVelocity = root.CFrame:VectorToWorldSpace(Vector3.new(0, ry * 42, 0))
    end
end
function State._hitboxFollower.start()
    State._hitboxFollower.enabled = true
    if State._hitboxFollower.conn then State._hitboxFollower.conn:Disconnect() end
    State._hitboxFollower.conn = RunService.RenderStepped:Connect(function()
        if State._hitboxFollower.enabled and not State.autoBatToggled and not State.tpBatEnabled then State._hitboxFollower.tick() end
    end)
end
function State._hitboxFollower.stop()
    State._hitboxFollower.enabled = false
    if State._hitboxFollower.conn then
        State._hitboxFollower.conn:Disconnect(); State._hitboxFollower.conn = nil
    end
    local c = LP.Character
    local root = c and c:FindFirstChild("HumanoidRootPart")
    if root then root.AssemblyAngularVelocity = Vector3.zero end
    local hum = c and c:FindFirstChildOfClass("Humanoid")
    if hum then hum.AutoRotate = true end
end
LP.CharacterAdded:Connect(function()
    task.wait(0.5)
    if State.hitboxFollowerEnabled and not State.autoBatToggled and not State.tpBatEnabled then
        State._hitboxFollower.stop(); task.wait(0.2); State._hitboxFollower.start()
    elseif State.hitboxFollowerEnabled and (State.autoBatToggled or State.tpBatEnabled) then
        State._hitboxFollower.pausedByBatAim = State.autoBatToggled == true; State._hitboxFollower.stop()
    end
end)
local PLOT_CACHE_DURATION, PROMPT_CACHE_REFRESH, STEAL_COOLDOWN = 2, 0.15, 0.1
local h, hrp, speedLbl
local setAutoBat, setInfJump, setAntiRag, setFps, setUnwalkToggle, autoLeftSetVisual, autoRightSetVisual, autoBatSetVisual, setIntroToggle, setNoIntroToggle
local setAntiLag, setStretchRez, setRemoveAccessories, setDarkMode, setSkyStyle, setSkySelectorVisual
local setMedusaCounter, setMedusaReset, setBatCounter, setInstaGrab, setAutoSwingVisual
local startAntiRagdoll, stopAntiRagdoll, applyFPSBoost
local mobileSpeedSetActive, mobileLaggerSetActive, mobileLaggerCarrySetActive, saveConfig, loadConfig = nil, nil, nil, nil, nil
State._configLoading = false; State._configLoaded = false; State._saveAfterLoad = false; State._saveRequestId = 0
State._lastSaveError = nil; State._configDirty = false; State._positionDirty = false
State._resolveFileFunction = function(name)
	local direct = nil
	if name == "writefile" then direct = writefile
	elseif name == "readfile" then direct = readfile
	elseif name == "isfile" then direct = isfile
	elseif name == "delfile" then direct = delfile
	elseif name == "makefolder" then direct = makefolder
	elseif name == "isfolder" then direct = isfolder end
	if type(direct) == "function" then return direct end
	local environments = {}
	pcall(function()
		if getgenv then table.insert(environments, getgenv()) end
	end)
	pcall(function()
		if getrenv then table.insert(environments, getrenv()) end
	end)
	table.insert(environments, _G)
	for _, environment in ipairs(environments) do
		if type(environment) == "table" then
			local candidate = rawget(environment, name)
			if type(candidate) == "function" then return candidate end
			local synEnvironment = rawget(environment, "syn")
			if type(synEnvironment) == "table" then
				local synCandidate = rawget(synEnvironment, name)
				if type(synCandidate) == "function" then return synCandidate end
			end
		end
	end
	if type(syn) == "table" and type(syn[name]) == "function" then
		return syn[name]
	end
	return nil
end
State._safeWriteFile = function(path, data)
	local writer = State._resolveFileFunction("writefile")
	if type(writer) ~= "function" then
		return false, "writefile no disponible en este ejecutor"
	end
	local ok, err = pcall(writer, path, data)
	if not ok then return false, tostring(err) end
	return true
end
State._safeReadFile = function(path)
	local reader = State._resolveFileFunction("readfile")
	if type(reader) ~= "function" then
		return nil, "readfile no disponible en este ejecutor"
	end
	local ok, result = pcall(reader, path)
	if not ok or type(result) ~= "string" or result == "" then
		return nil, ok and "archivo vacío" or tostring(result)
	end
	return result
end
State._safeDeleteFile = function(path)
	local deleter = State._resolveFileFunction("delfile")
	if type(deleter) ~= "function" then return false end
	local ok = pcall(deleter, path)
	return ok
end
State._readValidJsonFile = function(path)
	local raw = State._safeReadFile(path)
	if type(raw) ~= "string" then return nil, nil end
	local ok, decoded = pcall(function() return HttpService:JSONDecode(raw) end)
	if not ok or type(decoded) ~= "table" then return nil, raw end
	return decoded, raw
end
State._writeVerifiedJson = function(path, encoded)
	local writeOk, writeErr = State._safeWriteFile(path, encoded)
	if not writeOk then return false, writeErr end
	local decoded, raw = State._readValidJsonFile(path)
	if type(decoded) ~= "table" or raw ~= encoded then
		return false, "la verificación del archivo falló: " .. tostring(path)
	end
	return true
end
State._atomicJsonSave = function(mainPath, backupPath, tempPath, encoded)
    -- IMPORTANT: the main config is the only required file.
    -- Some executors allow writefile but block readfile/extra files.
    -- Backups, temp files and read-back verification must NEVER make the
    -- Save Config button report Failed after a successful writefile call.
    local jsonOk, decoded = pcall(function() return HttpService:JSONDecode(encoded) end)
    if not jsonOk or type(decoded) ~= "table" then
        return false, "JSON inválido antes de guardar"
    end

    local currentData, currentRaw = State._readValidJsonFile(mainPath)
    if type(currentData) == "table" and currentRaw == encoded then
        return true
    end

    -- Best-effort backup only. Never return false because backup/temp failed.
    if type(currentRaw) == "string" and currentRaw ~= "" then
        pcall(function() State._safeWriteFile(backupPath, currentRaw) end)
    end

    -- THIS is the real save. Only this result decides success.
    local mainOk, mainErr = State._safeWriteFile(mainPath, encoded)
    if not mainOk then
        return false, mainErr or "writefile failed"
    end

    -- Best-effort extras. Do not verify with readfile because some executors
    -- expose writefile without a reliable readfile implementation.
    pcall(function() State._safeWriteFile(tempPath, encoded) end)
    pcall(function() State._safeWriteFile(backupPath, encoded) end)
    return true
end
State.requestConfigSave = function()
    -- INSTANT AUTO-SAVE: every control that calls requestConfigSave()
    -- writes the current configuration immediately. No debounce/delay.
    State._configDirty = true
    State._saveRequestId = State._saveRequestId + 1

    if State._configLoading or not State._configLoaded then
        State._saveAfterLoad = true
        return false
    end

    if type(saveConfig) ~= "function" then
        State._saveAfterLoad = true
        return false
    end

    if State._saveInProgress then
        State._saveQueued = true
        return false
    end

    local ok, result = pcall(saveConfig)
    if not ok then
        State._lastSaveError = tostring(result)
        warn("[ZeyHubb INSTANT AUTO SAVE] " .. State._lastSaveError)
        return false
    end
    return result == true
end
local normalBox, carryBox, laggerBox, laggerBox2, uiScaleBox
local alConn, arConn, alPhase, arPhase = nil, nil, 1, 1
local autoTPDownEnabled, autoTPDownConn, autoTPDownHeight = false, nil, 20
local startBatAimbotV2, stopBatAimbotV2
local _autoBatLastScan = 0; local _autoBatTarget = nil; local _autoBatEquippedThisRun = false
local autoBatV2SetVisual, setAutoBatV2, setHideButtonsVisual, setAutoTPDownVisual
local cursedResetRemote = nil; local CURSED_RESET_GUID = "f888ee6e-c86d-46e1-93d7-0639d6635d42"; State.buttonsSizeValue = State.buttonsSizeValue or 50
State.buttonsShape = State.buttonsShape or "Normal"
function getMobileButtonPixels(value)
	value = math.clamp(math.floor((tonumber(value) or 50) + 0.5), 0, 100)
	return math.floor(36 + (value * 0.48) + 0.5)
end
function normalizeMobileButtonsShape(shape)
	shape = tostring(shape or "Normal")
	if shape == "Circle" or shape == "Normal" or shape == "Square" or shape == "Rectangle" then
		return shape
	end
	return "Normal"
end
function applyShapeToMobileButton(button)
	if not button or not button.Parent then return end
 local pixels = getMobileButtonPixels(State.buttonsSizeValue); local textPixels = math.clamp(math.floor(8 + State.buttonsSizeValue * 0.07 + 0.5), 8, 15); local shape = normalizeMobileButtonsShape(State.buttonsShape)
	local width, height = pixels, pixels
	local radius = UDim.new(0, math.clamp(math.floor(pixels * 0.30 + 0.5), 8, math.floor(pixels / 2)))
	if shape == "Circle" then
		radius = UDim.new(1, 0)
	elseif shape == "Square" then
		radius = UDim.new(0, 0)
	elseif shape == "Rectangle" then
  width = math.floor(pixels * 1.55 + 0.5); height = math.max(28, math.floor(pixels * 0.75 + 0.5)); radius = UDim.new(0, math.max(5, math.floor(height * 0.18 + 0.5)))
	end
	button.Size = UDim2.new(0, width, 0, height)
	button.TextSize = textPixels
	local corner = button:FindFirstChild("ButtonShapeCorner")
 if not corner or not corner:IsA("UICorner") then corner = button:FindFirstChildOfClass("UICorner") end
	if not corner then
		corner = Instance.new("UICorner")
		corner.Parent = button
	end
	corner.Name = "ButtonShapeCorner"
	corner.CornerRadius = radius
end
function applyMobileButtonsShape(shape)
	State.buttonsShape = normalizeMobileButtonsShape(shape)
 for _, mobileBtn in pairs(mobileButtonsByName) do applyShapeToMobileButton(mobileBtn) end
	return State.buttonsShape
end
function applyMobileButtonsSize(value)
 State.buttonsSizeValue = math.clamp(math.floor((tonumber(value) or 50) + 0.5), 0, 100); applyMobileButtonsShape(State.buttonsShape)
end
local MedusaConfig = {
	Enabled = false,
	Radius = 15,
	Delay = 0.15,
	LastUsed = 0,
	RadiusPart = nil
}
local SAFETY_VOID_MARGIN = 18; local SAFETY_MAX_FLOOR_RAY = 4000; local safetyLastGroundedCFrame = nil; local safetyRestoring = false
local function safetyVoidY()
	local ok, value = pcall(function() return workspace.FallenPartsDestroyHeight end)
	if ok and type(value) == "number" then return value end
	return -500
end
local function safetyFiniteNumber(value)
	return type(value) == "number" and value == value and value > -math.huge and value < math.huge
end
safetyPositionIsValid = function(position)
	return typeof(position) == "Vector3"
		and safetyFiniteNumber(position.X)
		and safetyFiniteNumber(position.Y)
		and safetyFiniteNumber(position.Z)
		and position.Y > safetyVoidY() + SAFETY_VOID_MARGIN
end
local function safetyCharacterParts()
	local character = LP.Character
 local humanoid = character and character:FindFirstChildOfClass("Humanoid"); local root = character and character:FindFirstChild("HumanoidRootPart")
	if not character or not humanoid or humanoid.Health <= 0 or not root then
		return nil, nil, nil
	end
	return character, humanoid, root
end
local function safetyFloorPosition(root, character)
	if not root or not character or not safetyPositionIsValid(root.Position) then return nil end
	local ignore = {character}
 if MedusaConfig and MedusaConfig.RadiusPart then table.insert(ignore, MedusaConfig.RadiusPart) end
 local humanoid = character:FindFirstChildOfClass("Humanoid"); local offset = (humanoid and humanoid.HipHeight or 2) + (root.Size.Y / 2) + 0.05; local origin = root.Position + Vector3.new(0, 5, 0); local distanceToVoid = math.max(100, origin.Y - safetyVoidY() + 50)
 local rayDistance = math.min(SAFETY_MAX_FLOOR_RAY, distanceToVoid); local hitPosition = nil
	pcall(function()
		local params = RaycastParams.new()
		params.FilterDescendantsInstances = ignore
		params.FilterType = Enum.RaycastFilterType.Exclude
		pcall(function() params.RespectCanCollide = true end)
		local result = workspace:Raycast(origin, Vector3.new(0, -rayDistance, 0), params)
		if result and result.Instance and result.Position then
			hitPosition = result.Position
		end
	end)
	if not hitPosition then
		pcall(function()
			local ray = Ray.new(origin, Vector3.new(0, -rayDistance, 0))
			local part, position = workspace:FindPartOnRayWithIgnoreList(ray, ignore)
			if part and position then hitPosition = position end
		end)
	end
	if not hitPosition then return nil end
	local landing = Vector3.new(root.Position.X, hitPosition.Y + offset, root.Position.Z)
	if not safetyPositionIsValid(landing) then return nil end
	return landing
end
local function safetyTeleport(root, humanoid, destination, preserveYaw)
	if not root or not root.Parent or not humanoid or humanoid.Health <= 0 then return false end
	if not safetyPositionIsValid(destination) then return false end
	local yaw = 0
	if preserveYaw ~= false then
		local _, currentYaw, _ = root.CFrame:ToOrientation()
		yaw = currentYaw
	end
	root.AssemblyLinearVelocity = Vector3.zero
	root.AssemblyAngularVelocity = Vector3.zero
	root.CFrame = CFrame.new(destination) * CFrame.Angles(0, yaw, 0)
	root.AssemblyLinearVelocity = Vector3.zero
	root.AssemblyAngularVelocity = Vector3.zero
	pcall(function() humanoid.PlatformStand = false end)
	return true
end
local function safetyTeleportToFloor(character, humanoid, root)
	local landing = safetyFloorPosition(root, character)
	if not landing then
		root.AssemblyLinearVelocity = Vector3.zero
		root.AssemblyAngularVelocity = Vector3.zero
		return false
	end
	return safetyTeleport(root, humanoid, landing, true)
end
RunService.Heartbeat:Connect(function()
	local _now = os.clock()
	if _now - (State._safetyLastCheck or 0) < 0.1 then return end
	State._safetyLastCheck = _now
	local character, humanoid, root = safetyCharacterParts()
	if not character then return end
	if safetyPositionIsValid(root.Position)
		and humanoid.FloorMaterial ~= Enum.Material.Air
		and root.AssemblyLinearVelocity.Magnitude < 180 then
		safetyLastGroundedCFrame = root.CFrame
	end
	local riskyMovement = State.dropActive
		or State.dropBrainrotActive
		or autoTPDownEnabled
		or State.tpBatEnabled
		or State.autoBatToggled
		or State.autoBatV2Enabled
	if riskyMovement and not safetyPositionIsValid(root.Position) and not safetyRestoring then
		safetyRestoring = true
		root.AssemblyLinearVelocity = Vector3.zero
		root.AssemblyAngularVelocity = Vector3.zero
  if safetyLastGroundedCFrame and safetyPositionIsValid(safetyLastGroundedCFrame.Position) then root.CFrame = safetyLastGroundedCFrame + Vector3.new(0, 2, 0) end
		task.defer(function() safetyRestoring = false end)
	end
end)
local function stopAutoLeft()
	if alConn then alConn:Disconnect(); alConn = nil end
	alPhase = 1
	local char = LP.Character
	if char then local hum = char:FindFirstChildOfClass("Humanoid"); if hum then hum:Move(Vector3.zero, false) end end
end
local function stopAutoRight()
	if arConn then arConn:Disconnect(); arConn = nil end
	arPhase = 1
	local char = LP.Character
	if char then local hum = char:FindFirstChildOfClass("Humanoid"); if hum then hum:Move(Vector3.zero, false) end end
end
local function startAutoLeft()
	if alConn then alConn:Disconnect() end
	alPhase = 1
	alConn = RunService.Heartbeat:Connect(function()
		if not State.autoLeftEnabled then return end
		local char = LP.Character; if not char then return end
  local hrp2 = char:FindFirstChild("HumanoidRootPart"); local hum = char:FindFirstChildOfClass("Humanoid")
		if not hrp2 or not hum then return end
		local spd = State.getAutoPathSpeed()
		if alPhase == 1 then
			local tgt = Vector3.new(AP.L1.X, hrp2.Position.Y, AP.L1.Z)
			if (tgt - hrp2.Position).Magnitude < 1 then
				alPhase = 2
				local d = AP.L2 - hrp2.Position; local mv = Vector3.new(d.X,0,d.Z).Unit
				hum:Move(mv,false); hrp2.AssemblyLinearVelocity = Vector3.new(mv.X*spd, hrp2.AssemblyLinearVelocity.Y, mv.Z*spd); return
			end
			local d = AP.L1 - hrp2.Position; local mv = Vector3.new(d.X,0,d.Z).Unit
			hum:Move(mv,false); hrp2.AssemblyLinearVelocity = Vector3.new(mv.X*spd, hrp2.AssemblyLinearVelocity.Y, mv.Z*spd)
		elseif alPhase == 2 then
			local tgt = Vector3.new(AP.L2.X, hrp2.Position.Y, AP.L2.Z)
			if (tgt - hrp2.Position).Magnitude < 1 then
				hum:Move(Vector3.zero,false); hrp2.AssemblyLinearVelocity = Vector3.zero
				State.autoLeftEnabled = false
				if alConn then alConn:Disconnect(); alConn = nil end
				alPhase = 1
				if autoLeftSetVisual then autoLeftSetVisual(false) end
    if (AP.L_FACE - hrp2.Position).Magnitude > 0.01 then hrp2.CFrame = CFrame.new(hrp2.Position, Vector3.new(AP.L_FACE.X, hrp2.Position.Y, AP.L_FACE.Z)) end
				return
			end
			local d = AP.L2 - hrp2.Position; local mv = Vector3.new(d.X,0,d.Z).Unit
			hum:Move(mv,false); hrp2.AssemblyLinearVelocity = Vector3.new(mv.X*spd, hrp2.AssemblyLinearVelocity.Y, mv.Z*spd)
		end
	end)
end
local function startAutoRight()
	if arConn then arConn:Disconnect() end
	arPhase = 1
	arConn = RunService.Heartbeat:Connect(function()
		if not State.autoRightEnabled then return end
		local char = LP.Character; if not char then return end
  local hrp2 = char:FindFirstChild("HumanoidRootPart"); local hum = char:FindFirstChildOfClass("Humanoid")
		if not hrp2 or not hum then return end
		local spd = State.getAutoPathSpeed()
		if arPhase == 1 then
			local tgt = Vector3.new(AP.R1.X, hrp2.Position.Y, AP.R1.Z)
			if (tgt - hrp2.Position).Magnitude < 1 then
				arPhase = 2
				local d = AP.R2 - hrp2.Position; local mv = Vector3.new(d.X,0,d.Z).Unit
				hum:Move(mv,false); hrp2.AssemblyLinearVelocity = Vector3.new(mv.X*spd, hrp2.AssemblyLinearVelocity.Y, mv.Z*spd); return
			end
			local d = AP.R1 - hrp2.Position; local mv = Vector3.new(d.X,0,d.Z).Unit
			hum:Move(mv,false); hrp2.AssemblyLinearVelocity = Vector3.new(mv.X*spd, hrp2.AssemblyLinearVelocity.Y, mv.Z*spd)
		elseif arPhase == 2 then
			local tgt = Vector3.new(AP.R2.X, hrp2.Position.Y, AP.R2.Z)
			if (tgt - hrp2.Position).Magnitude < 1 then
				hum:Move(Vector3.zero,false); hrp2.AssemblyLinearVelocity = Vector3.zero
				State.autoRightEnabled = false
				if arConn then arConn:Disconnect(); arConn = nil end
				arPhase = 1
				if autoRightSetVisual then autoRightSetVisual(false) end
    if (AP.R_FACE - hrp2.Position).Magnitude > 0.01 then hrp2.CFrame = CFrame.new(hrp2.Position, Vector3.new(AP.R_FACE.X, hrp2.Position.Y, AP.R_FACE.Z)) end
				return
			end
			local d = AP.R2 - hrp2.Position; local mv = Vector3.new(d.X,0,d.Z).Unit
			hum:Move(mv,false); hrp2.AssemblyLinearVelocity = Vector3.new(mv.X*spd, hrp2.AssemblyLinearVelocity.Y, mv.Z*spd)
		end
	end)
end
local DROP_ASCEND_DURATION = 0.25; local DROP_ASCEND_SPEED = 240
local function runDrop()
        if State.dropActive then return end
        local char, hum, root = safetyCharacterParts()
        if not char then return end
        State.dropActive = true; local t0 = tick(); local dc
        dc = RunService.Heartbeat:Connect(function()
                local currentChar = LP.Character
                local r = currentChar and currentChar:FindFirstChild("HumanoidRootPart"); local currentHum = currentChar and currentChar:FindFirstChildOfClass("Humanoid")
                if not r or not currentHum or currentHum.Health <= 0 then
                        if dc then dc:Disconnect() end
                        State.dropActive = false
                        return
                end
                if tick() - t0 >= DROP_ASCEND_DURATION then
                        if dc then dc:Disconnect() end
                        r.AssemblyLinearVelocity = Vector3.zero
                        r.AssemblyAngularVelocity = Vector3.zero
                        safetyTeleportToFloor(currentChar, currentHum, r); State.dropActive = false
                        return
                end
                r.AssemblyLinearVelocity = Vector3.new(r.AssemblyLinearVelocity.X, DROP_ASCEND_SPEED, r.AssemblyLinearVelocity.Z)
        end)
end
local _tpDownActive = false
local function runTPDown()
	if _tpDownActive then return end
	_tpDownActive = true
	pcall(function()
		local character, humanoid, root = safetyCharacterParts()
		if character then safetyTeleportToFloor(character, humanoid, root) end
	end)
	_tpDownActive = false
end
State._tpBatHittingCooldown = false; State._tpBatHRP = nil; State._tpBatH = nil
State._tpBatGetTool = function()
	local char = LP.Character
	if not char then return nil end
	local bat = char:FindFirstChild("Bat")
	if bat then return bat end
	local backpack = LP:FindFirstChild("Backpack")
	if backpack then
		bat = backpack:FindFirstChild("Bat")
		if bat then
			bat.Parent = char
			return bat
		end
	end
	return nil
end
State._tpBatTryHit = function()
	if State._tpBatHittingCooldown then return end
	State._tpBatHittingCooldown = true
	pcall(function()
		local bat = State._tpBatGetTool()
		if bat then
   bat:Activate(); local remoteEvent = bat:FindFirstChildWhichIsA("RemoteEvent")
   if remoteEvent then remoteEvent:FireServer() end
			local remoteFunction = bat:FindFirstChildWhichIsA("RemoteFunction")
			if remoteFunction then
				pcall(function()
					remoteFunction:InvokeServer()
				end)
			end
		end
	end)
	task.delay(0.08, function()
		State._tpBatHittingCooldown = false
	end)
end
State._tpBatClosest = function()
	if not State._tpBatHRP then return nil, math.huge end
	local closest, closestDistance = nil, math.huge
	for _, player in pairs(Players:GetPlayers()) do
		if player ~= LP and player.Character then
			local targetRoot = player.Character:FindFirstChild("HumanoidRootPart")
			if targetRoot then
				local distance = (State._tpBatHRP.Position - targetRoot.Position).Magnitude
				if distance < closestDistance then
					closestDistance = distance
					closest = player
				end
			end
		end
	end
	return closest, closestDistance
end
RunService.Heartbeat:Connect(function()
	if not State.tpBatEnabled or State.tpBatVersion ~= 1 then return end
	if not State._tpBatH or not State._tpBatHRP
		or not State._tpBatH.Parent or not State._tpBatHRP.Parent then
		local char = LP.Character
		if char then
   State._tpBatH = char:FindFirstChildOfClass("Humanoid"); State._tpBatHRP = char:FindFirstChild("HumanoidRootPart")
		end
		if not State._tpBatH or not State._tpBatHRP then return end
	end
	local target = State._tpBatClosest()
	if target and target.Character then
		local targetRoot = target.Character:FindFirstChild("HumanoidRootPart")
		if targetRoot then
			if sethiddenproperty then
				pcall(function()
					sethiddenproperty(State._tpBatHRP, "PhysicsRepRootPart", targetRoot)
				end)
			end
			local targetPosition = targetRoot.Position + Vector3.new(0, 0.9, 0)
   if (State._tpBatHRP.Position - targetPosition).Magnitude > 5 then State._tpBatHRP.CFrame = CFrame.new(targetPosition) end
			local camera = workspace.CurrentCamera
   if camera then camera.CFrame = CFrame.new(camera.CFrame.Position, targetRoot.Position) end
			State._tpBatTryHit()
		end
	end
end)
RunService.Heartbeat:Connect(function()
	if not State.tpBatEnabled or State.tpBatVersion ~= 1 then return end
	if not State._tpBatH or not State._tpBatHRP then return end
	if not State._tpBatH.Parent or not State._tpBatHRP.Parent then return end
	local target = State._tpBatClosest()
	if target and target.Character then
		local targetRoot = target.Character:FindFirstChild("HumanoidRootPart")
		if targetRoot then
			local camera = workspace.CurrentCamera
   if camera then camera.CFrame = CFrame.new(camera.CFrame.Position, targetRoot.Position) end
			State._tpBatTryHit()
		end
	end
end)
State._tpBatV2HittingCooldown = false
State._tpBatV2GetTool = function()
	local char = LP.Character
	if not char then return nil end
	local tool = char:FindFirstChild("Bat")
	if tool then return tool end
	local backpack = LP:FindFirstChild("Backpack")
	if backpack then
		tool = backpack:FindFirstChild("Bat")
		if tool then
			tool.Parent = char
			return tool
		end
	end
	return nil
end
State._tpBatV2TryHit = function()
	if State._tpBatV2HittingCooldown then return end
	State._tpBatV2HittingCooldown = true
	pcall(function()
		local bat = State._tpBatV2GetTool()
		if bat then
   bat:Activate(); local ev = bat:FindFirstChildWhichIsA("RemoteEvent")
			if ev then ev:FireServer() end
		end
	end)
	task.delay(0.08, function()
		State._tpBatV2HittingCooldown = false
	end)
end
RunService.Heartbeat:Connect(function()
	if not State.tpBatEnabled or State.tpBatVersion ~= 2 then return end
	if not State._tpBatH or not State._tpBatHRP
		or not State._tpBatH.Parent or not State._tpBatHRP.Parent then
		local char = LP.Character
		if char then
   State._tpBatH = char:FindFirstChildOfClass("Humanoid"); State._tpBatHRP = char:FindFirstChild("HumanoidRootPart")
		end
		if not State._tpBatH or not State._tpBatHRP then return end
	end
	local target = State._tpBatClosest()
	if target and target.Character then
		local targetRoot = target.Character:FindFirstChild("HumanoidRootPart")
		if targetRoot then
			if sethiddenproperty then
				pcall(function()
					sethiddenproperty(State._tpBatHRP, "PhysicsRepRootPart", targetRoot)
				end)
			end
			local targetPosition = targetRoot.Position + Vector3.new(0, 0.9, 0)
   if (State._tpBatHRP.Position - targetPosition).Magnitude > 8 then State._tpBatHRP.CFrame = CFrame.new(targetPosition) end
			local camera = workspace.CurrentCamera
   if camera then camera.CFrame = CFrame.new(camera.CFrame.Position, targetRoot.Position) end
			State._tpBatV2TryHit()
		end
	end
end)
LP.CharacterAdded:Connect(function(character)
 task.wait(0.2); State._tpBatH = character:FindFirstChildOfClass("Humanoid"); State._tpBatHRP = character:FindFirstChild("HumanoidRootPart")
end)
if LP.Character then
	task.spawn(function()
  task.wait(0.2); State._tpBatH = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid"); State._tpBatHRP = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
	end)
end
local function startAutoTPDown()
	if autoTPDownConn then task.cancel(autoTPDownConn); autoTPDownConn = nil end
	autoTPDownConn = task.spawn(function()
		while autoTPDownEnabled do
			task.wait(0.1)
			pcall(function()
				local char = LP.Character; if not char then return end
				local root = char:FindFirstChild("HumanoidRootPart"); if not root then return end
				local hum = char:FindFirstChildOfClass("Humanoid"); if not hum then return end
				if hum.FloorMaterial ~= Enum.Material.Air then return end
				if root.Position.Y < autoTPDownHeight then return end
				safetyTeleportToFloor(char, hum, root)
			end)
		end
	end)
end
local function stopAutoTPDown()
	autoTPDownEnabled = false
	if autoTPDownConn then task.cancel(autoTPDownConn); autoTPDownConn = nil end
end
pcall(function()
	if hookfunction and newcclosure then
		local oldFire
		oldFire=hookfunction(Instance.new("RemoteEvent").FireServer,newcclosure(function(self,...)
			if not cursedResetRemote and typeof(self)=="Instance" and self:IsA("RemoteEvent") and self.Name:sub(1,3)=="RE/" then
				cursedResetRemote=self
			end
			return oldFire(self,...)
		end))
	end
end)
task.spawn(function()
	task.wait(2)
	if cursedResetRemote then return end
	for _,desc in ipairs(game:GetDescendants()) do
		if desc:IsA("RemoteEvent") and desc.Name:sub(1,3)=="RE/" then
			cursedResetRemote=desc
			break
		end
	end
end)
local function cursedInstaReset()
	if not cursedResetRemote then
		for _,desc in ipairs(game:GetDescendants()) do
			if desc:IsA("RemoteEvent") and desc.Name:sub(1,3)=="RE/" then
				cursedResetRemote=desc
				break
			end
		end
	end
	if not cursedResetRemote then return end
	local character = LP.Character
	local humanoid = character and character:FindFirstChildOfClass("Humanoid")
	if humanoid and humanoid.Health <= 0 then
		pcall(function() cursedResetRemote:FireServer(CURSED_RESET_GUID, LP, "balloon") end)
		return
	end
 local resetDetected = false; local conns = {}
	if humanoid then
		table.insert(conns, humanoid.Died:Connect(function() resetDetected = true end))
		table.insert(conns, humanoid:GetPropertyChangedSignal("Health"):Connect(function()
			if humanoid.Health <= 0 then resetDetected = true end
		end))
	end
	if character then
		table.insert(conns, character.AncestryChanged:Connect(function(_, parent)
			if not parent then resetDetected = true end
		end))
	end
	task.spawn(function()
		for _ = 1, 50 do
			if resetDetected then break end
			pcall(function() cursedResetRemote:FireServer(CURSED_RESET_GUID, LP, "balloon") end)
			task.wait()
		end
		for _, conn in ipairs(conns) do
			pcall(function() conn:Disconnect() end)
		end
	end)
end
for _, name in pairs({"PRIMEV2GUI"}) do
	local old = game:GetService("CoreGui"):FindFirstChild(name)
	if old then old:Destroy() end
	local pg = LP:FindFirstChild("PlayerGui")
	if pg then local o = pg:FindFirstChild(name); if o then o:Destroy() end end
end
local function makeDraggable(frame)
	local dragging, dragInput, dragStart, startPos = false, nil, nil, nil
 local moved = false; frame.Active = true
	local function finishDrag()
		if not dragging then return end
  dragging = false; dragInput = nil
		if moved then
			moved = false
			if State.requestPositionSave then State.requestPositionSave() end
			if State.requestConfigSave then State.requestConfigSave() end
		end
	end
	frame.InputBegan:Connect(function(inp)
		if uiLocked then return end
		if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
   dragging = true; moved = false; dragInput = inp.UserInputType == Enum.UserInputType.Touch and inp or nil
			dragStart = inp.Position
			startPos = frame.Position
			inp.Changed:Connect(function()
				if inp.UserInputState == Enum.UserInputState.End then finishDrag() end
			end)
		end
	end)
	frame.InputChanged:Connect(function(inp)
		if uiLocked then finishDrag(); return end
		if inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch then
			dragInput = inp
		end
	end)
	UIS.InputChanged:Connect(function(inp)
		if uiLocked then finishDrag(); return end
		if dragging and (inp == dragInput or inp.UserInputType == Enum.UserInputType.MouseMovement) then
			local d = inp.Position - dragStart
			if math.abs(d.X) > 1 or math.abs(d.Y) > 1 then moved = true end
			frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset+d.X, startPos.Y.Scale, startPos.Y.Offset+d.Y)
		end
	end)
	UIS.InputEnded:Connect(function(inp)
  if dragging and (inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch) then finishDrag() end
	end)
end
local gui = Instance.new("ScreenGui"); gui.Name = "PRIMEV2GUI"; gui.ResetOnSpawn = false; gui.DisplayOrder = 10
gui.IgnoreGuiInset = true
if not pcall(function() gui.Parent = game:GetService("CoreGui") end) then gui.Parent = LP:WaitForChild("PlayerGui") end
local _C={
	[1]=Color3.fromRGB(0, 0, 0),
	[2]=Color3.fromRGB(8, 0, 0),
	[3]=Color3.fromRGB(18, 0, 0),
	[4]=Color3.fromRGB(13, 13, 13),
	[5]=Color3.fromRGB(18, 18, 18),
	[6]=Color3.fromRGB(13, 13, 13),
	[7]=Color3.fromRGB(54, 54, 54),
	[8]=Color3.fromRGB(30, 30, 30),
	[9]=Color3.fromRGB(0, 0, 0),
	[10]=Color3.fromRGB(12, 0, 0),
}
local BG=_C[1];local SIDEBAR_BG=_C[2];local CARD_BG=_C[3];local CARD_HOV=_C[4]; local BORDER=_C[5];local BORDER2=_C[6];local WHITE=_C[7];local DIM=_C[8]; local DIM2=_C[9];local KB_BG=_C[10];local INPUT_BG=_C[10]
local W, H, SW = 356, 536, 112
local CORNER = 14; local uiScaleValue = 80; local mainUIScale = nil; local main = Instance.new("Frame", gui)
main.Name = "Main"; main.Size = UDim2.new(0, W, 0, H); main.Position = UDim2.new(0, 70, 0, 12)
main.BackgroundColor3 = BG
main.BorderSizePixel = 0; main.Active = true; main.ClipsDescendants = true; main.Visible = false
main.BackgroundTransparency = 0; local mainCorner = Instance.new("UICorner", main); mainCorner.CornerRadius = UDim.new(0, CORNER); local mainStroke = Instance.new("UIStroke", main)
mainStroke.Color = BORDER
mainStroke.Thickness = 1; mainStroke.Transparency = 0.25; local premiumInnerBorder = Instance.new("Frame", main); premiumInnerBorder.Name = "PremiumInnerBorder"
premiumInnerBorder.Size = UDim2.new(1, -8, 1, -8); premiumInnerBorder.Position = UDim2.new(0, 4, 0, 4); premiumInnerBorder.BackgroundTransparency = 1; premiumInnerBorder.BorderSizePixel = 0
premiumInnerBorder.ZIndex = 2; local premiumInnerCorner = Instance.new("UICorner", premiumInnerBorder); premiumInnerCorner.CornerRadius = UDim.new(0, math.max(CORNER - 4, 0)); local premiumInnerStroke = Instance.new("UIStroke", premiumInnerBorder)
premiumInnerStroke.Color = Color3.fromRGB(12, 12, 12); premiumInnerStroke.Thickness = 1; premiumInnerStroke.Transparency = 0.65; mainUIScale = Instance.new("UIScale", main)
mainUIScale.Scale = 0.80; local fullUIBackground = Instance.new("ImageLabel", main); fullUIBackground.Name = "FullUIBackground"; fullUIBackground.Size = UDim2.new(1, -2, 1, -2)
fullUIBackground.Position = UDim2.new(0, 1, 0, 1); fullUIBackground.BackgroundTransparency = 1; fullUIBackground.BorderSizePixel = 0; fullUIBackground.Image = "rbxassetid://" .. tostring(State.backgroundAssetId)
fullUIBackground.ImageTransparency = 0.18
fullUIBackground.ScaleType = Enum.ScaleType.Crop
fullUIBackground.ZIndex = 1; local fullUIBackgroundCorner = Instance.new("UICorner", fullUIBackground); fullUIBackgroundCorner.CornerRadius = UDim.new(0, math.max(CORNER - 1, 0))
State.applyBackgroundImage = function(assetId, shouldSave)
 assetId = tostring(assetId or ""); local valid = false
	for _, id in ipairs(State.backgroundAssetIds) do
		if id == assetId then valid = true; break end
	end
	if not valid then assetId = State.backgroundAssetIds[1] end
	State.backgroundAssetId = assetId
	if fullUIBackground and fullUIBackground.Parent then
		fullUIBackground.Image = "rbxassetid://" .. assetId
	end
	for id, visual in pairs(State.imageChoiceVisuals) do
		local selected = id == assetId
		if visual.stroke then
			visual.stroke.Color = selected and WHITE or BORDER
			visual.stroke.Thickness = selected and 2.2 or 1
		end
		if visual.badge then
   visual.badge.Text = selected and ("✓ " .. tostring(visual.index)) or tostring(visual.index); visual.badge.BackgroundColor3 = selected and WHITE or Color3.fromRGB(10, 0, 0)
			visual.badge.TextColor3 = selected and BG or WHITE
		end
	end
 if shouldSave and State.requestConfigSave then State.requestConfigSave() end
end
local topbar = Instance.new("Frame", main); topbar.Size = UDim2.new(1, 0, 0, 48)
topbar.BackgroundColor3 = SIDEBAR_BG
topbar.BackgroundTransparency = 1; topbar.BorderSizePixel = 0; topbar.ZIndex = 10; Instance.new("UICorner", topbar).CornerRadius = UDim.new(0, CORNER)
local topPatch = Instance.new("Frame", topbar); topPatch.Size = UDim2.new(1, 0, 0, CORNER); topPatch.Position = UDim2.new(0, 0, 1, -CORNER)
topPatch.BackgroundColor3 = SIDEBAR_BG
topPatch.BackgroundTransparency = 1; topPatch.BorderSizePixel = 0; topPatch.ZIndex = 9; local topDiv = Instance.new("Frame", topbar)
topDiv.Size = UDim2.new(1, 0, 0, 1); topDiv.Position = UDim2.new(0, 0, 1, -1)
topDiv.BackgroundColor3 = BORDER
topDiv.BorderSizePixel = 0; topDiv.BackgroundTransparency = 0.55; topDiv.ZIndex = 11; local premiumTopLine = Instance.new("Frame", topbar); premiumTopLine.Name = "PremiumTopLine"
premiumTopLine.Size = UDim2.new(1, -28, 0, 2); premiumTopLine.Position = UDim2.new(0, 14, 0, 3)
premiumTopLine.BackgroundColor3 = WHITE
premiumTopLine.BorderSizePixel = 0; premiumTopLine.ZIndex = 14; local premiumTopCorner = Instance.new("UICorner", premiumTopLine); premiumTopCorner.CornerRadius = UDim.new(1, 0)
local premiumTopGradient = Instance.new("UIGradient", premiumTopLine)
premiumTopGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(18, 18, 18)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(54, 54, 54)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(18, 18, 18))
})
premiumTopGradient.Transparency = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 0.55),
    NumberSequenceKeypoint.new(0.5, 0.02),
    NumberSequenceKeypoint.new(1, 0.55)
})
local titleLbl = Instance.new("TextLabel", topbar); titleLbl.Size = UDim2.new(0, 190, 1, 0); titleLbl.Position = UDim2.new(0, 17, 0, -3); titleLbl.BackgroundTransparency = 1
titleLbl.Text = " ZeyHubb.vs"
titleLbl.TextColor3 = WHITE
titleLbl.Font = Enum.Font.GothamBlack
titleLbl.TextSize = 15
titleLbl.TextXAlignment = Enum.TextXAlignment.Left
titleLbl.ZIndex = 12; local verLbl = Instance.new("TextLabel", topbar); verLbl.Size = UDim2.new(0, 240, 0, 14); verLbl.Position = UDim2.new(0, 18, 0, 28)
verLbl.BackgroundTransparency = 1; verLbl.Text = "ㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤZeyHubb.vs  ·  mogs"
verLbl.TextColor3 = DIM
verLbl.Font = Enum.Font.Gotham
verLbl.TextSize = 8
verLbl.TextXAlignment = Enum.TextXAlignment.Left
verLbl.ZIndex = 12; local minBtn = Instance.new("TextButton", topbar); minBtn.AutoButtonColor = false; minBtn.Size = UDim2.new(0, 26, 0, 26)
minBtn.Position = UDim2.new(1, -68, 0.5, -13)
minBtn.BackgroundColor3 = KB_BG
minBtn.BorderSizePixel = 0; minBtn.Text = "-"
minBtn.TextColor3 = DIM
minBtn.Font = Enum.Font.GothamBold
minBtn.TextSize = 22; minBtn.ZIndex = 13; minBtn.BackgroundTransparency = 0.8; Instance.new("UICorner", minBtn).CornerRadius = UDim.new(0, 6)
Instance.new("UIStroke", minBtn).Color = BORDER
local closeBtn = Instance.new("TextButton", topbar); closeBtn.Name = "CloseButton"; closeBtn.AutoButtonColor = false
closeBtn.Size = UDim2.new(0, 26, 0, 26); closeBtn.Position = UDim2.new(1, -8, 0.5, -13)
closeBtn.BackgroundColor3 = KB_BG; closeBtn.BorderSizePixel = 0; closeBtn.Text = "×"
closeBtn.TextColor3 = DIM; closeBtn.Font = Enum.Font.GothamBold; closeBtn.TextSize = 19; closeBtn.ZIndex = 14; closeBtn.BackgroundTransparency = 0.8
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 6); Instance.new("UIStroke", closeBtn).Color = BORDER

minBtn.MouseEnter:Connect(function() TweenService:Create(minBtn, TweenInfo.new(0.1), {BackgroundColor3=CARD_HOV}):Play() end)
minBtn.MouseLeave:Connect(function() TweenService:Create(minBtn, TweenInfo.new(0.1), {BackgroundColor3=KB_BG}):Play() end)
do
 local dragging = false; local dragInput = nil; local dragStart = nil; local startPosition = nil
 local moved = false; local dragZone = Instance.new("TextButton", topbar); dragZone.Name = "TopbarDragZone"; dragZone.Size = UDim2.new(1, -72, 1, 0)
 dragZone.Position = UDim2.new(0, 0, 0, 0); dragZone.BackgroundTransparency = 1; dragZone.BorderSizePixel = 0; dragZone.Text = ""
 dragZone.AutoButtonColor = false; dragZone.Active = true; dragZone.ZIndex = 13
	local function finishDrag()
		if not dragging then return end
  dragging = false; dragInput = nil
		if moved then
			moved = false
			if State.requestPositionSave then State.requestPositionSave() end
			if State.requestConfigSave then State.requestConfigSave() end
		end
	end
	dragZone.InputBegan:Connect(function(input)
		if uiLocked then return end
		if input.UserInputType ~= Enum.UserInputType.MouseButton1
		and input.UserInputType ~= Enum.UserInputType.Touch then return end
  dragging = true; moved = false; dragInput = input.UserInputType == Enum.UserInputType.Touch and input or nil
		dragStart = input.Position
		startPosition = main.Position
		input.Changed:Connect(function()
   if input.UserInputState == Enum.UserInputState.End then finishDrag() end
		end)
	end)
	dragZone.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement
		or input.UserInputType == Enum.UserInputType.Touch then
			dragInput = input
		end
	end)
	UIS.InputChanged:Connect(function(input)
		if uiLocked then finishDrag(); return end
		if not dragging then return end
		if input ~= dragInput and input.UserInputType ~= Enum.UserInputType.MouseMovement then return end
		local delta = input.Position - dragStart
		if math.abs(delta.X) > 1 or math.abs(delta.Y) > 1 then moved = true end
		main.Position = UDim2.new(
			startPosition.X.Scale, startPosition.X.Offset + delta.X,
			startPosition.Y.Scale, startPosition.Y.Offset + delta.Y
		)
	end)
	UIS.InputEnded:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch) then
			finishDrag()
		end
	end)
end
local TAB_BAR_H = 0; local TAB_BAR_Y = 48; local sidebar = Instance.new("Frame", main); sidebar.Name = "TabBar"
sidebar.Size = UDim2.new(1, 0, 0, TAB_BAR_H); sidebar.Position = UDim2.new(0, 0, 0, TAB_BAR_Y)
sidebar.BackgroundColor3 = SIDEBAR_BG
sidebar.BackgroundTransparency = 1; sidebar.BorderSizePixel = 0; sidebar.ZIndex = 6; sidebar.ClipsDescendants = true; sidebar.Visible = false
do local _sd=Instance.new("Frame",main); _sd.Size=UDim2.new(1,0,0,1); _sd.Position=UDim2.new(0,0,0,TAB_BAR_Y+TAB_BAR_H); _sd.BackgroundColor3=BORDER; _sd.BackgroundTransparency=0.55; _sd.BorderSizePixel=0; _sd.ZIndex=7; _sd.Visible=false end
local content = Instance.new("Frame", main); content.Name = "ContentArea"; content.Size = UDim2.new(1, 0, 1, -(TAB_BAR_Y + TAB_BAR_H + 2 + CORNER)); content.Position = UDim2.new(0, 0, 0, TAB_BAR_Y + TAB_BAR_H + 2)
content.BackgroundColor3 = BG
content.BackgroundTransparency = 1; content.BorderSizePixel = 0; content.ClipsDescendants = true; content.ZIndex = 100
local mini = Instance.new("TextButton", gui); mini.AutoButtonColor = false; mini.Name = "ZeyHubbMini"; mini.Size = UDim2.new(0, 110, 0, 32)
mini.Position = UDim2.new(0, 20, 0, 70)
mini.BackgroundColor3 = BG
mini.BorderSizePixel = 0; mini.Text = " ZeyHubb.vs"
mini.TextColor3 = WHITE
mini.Font = Enum.Font.GothamBold
mini.TextSize = 11
mini.TextXAlignment = Enum.TextXAlignment.Center
mini.ZIndex = 20; mini.Visible = true; mini.BackgroundTransparency = 0; Instance.new("UICorner", mini).CornerRadius = UDim.new(0, 8); local miniStroke = Instance.new("UIStroke", mini)
miniStroke.Color = BORDER
miniStroke.Thickness = 1; makeDraggable(mini)
mini.InputEnded:Connect(function(inp)
	if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
		if State.requestConfigSave then State.requestConfigSave() end
	end
end)
local function showGui()
    main.Visible = true; mini.Visible = false; State.guiVisible = true; main.BackgroundTransparency = 0
    mainUIScale.Scale = 0.85; TweenService:Create(main, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {BackgroundTransparency = 0}):Play(); TweenService:Create(mainUIScale, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Scale = uiScaleValue / 100}):Play()
end
local function hideGui()
    TweenService:Create(main, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {BackgroundTransparency = 1}):Play(); TweenService:Create(mainUIScale, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {Scale = 0.85}):Play()
    task.delay(0.2, function()
        main.Visible = false; mini.Visible = true; State.guiVisible = false
    end)
end
minBtn.MouseButton1Click:Connect(hideGui); mini.MouseButton1Click:Connect(showGui)
closeBtn.MouseButton1Click:Connect(function()
    State.guiVisible = false
    pcall(function() if musicStop then musicStop() end end)
    if gui then gui:Destroy() end
end)
mini.MouseEnter:Connect(function() TweenService:Create(mini,TweenInfo.new(0.1),{BackgroundColor3=CARD_HOV}):Play() end)
mini.MouseLeave:Connect(function() TweenService:Create(mini,TweenInfo.new(0.1),{BackgroundColor3=BG}):Play() end)
local tabs = {}; local tabPages = {}; local activeTabName = nil
local tabDefs = {
	{name="Speed"},
	{name="Bat Aimbot"},
	{name="Mechanics"},
	{name="Movement"},
	{name="Auto Farm"},
	{name="Animation"},
	{name="Performance"},
	{name="Settings"},
	{name="Background"},
	{name="Music"},
}
local switchTab
local pageLOs = {}
-- Lista unica: todas as opcoes numa pagina so, sem abas
local masterPage = Instance.new("ScrollingFrame", content)
masterPage.Name = "AllOptions"
masterPage.Size = UDim2.new(1, 0, 1, 0)
masterPage.BackgroundTransparency = 1
masterPage.BorderSizePixel = 0
masterPage.ScrollBarThickness = 0
masterPage.ScrollBarImageColor3 = BORDER
masterPage.AutomaticCanvasSize = Enum.AutomaticSize.Y
masterPage.CanvasSize = UDim2.new(0, 0, 0, 0)
masterPage.ZIndex = 3
local mLL = Instance.new("UIListLayout", masterPage)
mLL.SortOrder = Enum.SortOrder.LayoutOrder
mLL.Padding = UDim.new(0, 7)
local mPad = Instance.new("UIPadding", masterPage)
mPad.PaddingLeft = UDim.new(0, 13); mPad.PaddingRight = UDim.new(0, 13)
mPad.PaddingTop = UDim.new(0, 12); mPad.PaddingBottom = UDim.new(0, 12)
switchTab = function(name) activeTabName = name end
for i, td in ipairs(tabDefs) do
	local page = Instance.new("Frame", masterPage)
	page.Name = td.name
	page.Size = UDim2.new(1, 0, 0, 0)
	page.AutomaticSize = Enum.AutomaticSize.Y
	page.BackgroundTransparency = 1
	page.BorderSizePixel = 0
	page.LayoutOrder = i
	page.ZIndex = 3
	local pll = Instance.new("UIListLayout", page)
	pll.SortOrder = Enum.SortOrder.LayoutOrder
	pll.Padding = UDim.new(0, 7)
	tabs[td.name] = {frame=page}
	tabPages[td.name] = page
	pageLOs[td.name] = 0
end
local function lo(tabName) pageLOs[tabName] = pageLOs[tabName] + 1; return pageLOs[tabName] end
local function pg(tabName) return tabPages[tabName] end

-- ============================================================
-- AUTO STEAL CONTROLS — INSIDE ZEYHUBB UI / SETTINGS
-- ============================================================
do
    local c = Instance.new("Frame", pg("Settings"))
    c.Name = "AutoStealSettingsCard"
    c.Size = UDim2.new(1,0,0,92)
    c.BackgroundColor3 = CARD_BG
    c.BackgroundTransparency = OPTION_TRANSPARENCY
    c.BorderSizePixel = 0
    c.LayoutOrder = lo("Settings")
    c.ZIndex = 4
    Instance.new("UICorner",c).CornerRadius = UDim.new(0,12)

    local st = Instance.new("UIStroke",c)
    st.Color = BORDER
    st.Thickness = 1
    st.Transparency = 0.18

    local accent = Instance.new("Frame",c)
    accent.Size = UDim2.new(0,2,0.5,0)
    accent.Position = UDim2.new(0,1,0.25,0)
    accent.BackgroundColor3 = Color3.fromRGB(255,105,180)
    accent.BorderSizePixel = 0
    accent.ZIndex = 5
    Instance.new("UICorner",accent).CornerRadius = UDim.new(1,0)

    local title = Instance.new("TextLabel",c)
    title.BackgroundTransparency = 1
    title.Position = UDim2.new(0,13,0,9)
    title.Size = UDim2.new(1,-110,0,18)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 10
    title.TextColor3 = WHITE
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Text = "AUTO STEAL"
    title.ZIndex = 6

    local desc = Instance.new("TextLabel",c)
    desc.BackgroundTransparency = 1
    desc.Position = UDim2.new(0,13,0,27)
    desc.Size = UDim2.new(1,-110,0,15)
    desc.Font = Enum.Font.Gotham
    desc.TextSize = 8
    desc.TextColor3 = DIM2
    desc.TextXAlignment = Enum.TextXAlignment.Left
    desc.Text = "Activer ou désactiver l’Auto Steal"
    desc.ZIndex = 6

    local toggle = Instance.new("TextButton",c)
    toggle.Name = "AutoStealToggle"
    toggle.Size = UDim2.new(0,58,0,27)
    toggle.Position = UDim2.new(1,-70,0,12)
    toggle.AutoButtonColor = false
    toggle.BorderSizePixel = 0
    toggle.Font = Enum.Font.GothamBold
    toggle.TextSize = 9
    toggle.TextColor3 = WHITE
    toggle.ZIndex = 7
    toggle.Parent = c
    Instance.new("UICorner",toggle).CornerRadius = UDim.new(0,9)

    local sizeTitle = Instance.new("TextLabel",c)
    sizeTitle.BackgroundTransparency = 1
    sizeTitle.Position = UDim2.new(0,13,0,53)
    sizeTitle.Size = UDim2.new(0,105,0,16)
    sizeTitle.Font = Enum.Font.GothamBold
    sizeTitle.TextSize = 8
    sizeTitle.TextColor3 = DIM2
    sizeTitle.TextXAlignment = Enum.TextXAlignment.Left
    sizeTitle.Text = "TAILLE AUTO STEAL"
    sizeTitle.ZIndex = 6

    local minus = Instance.new("TextButton",c)
    minus.Size = UDim2.new(0,28,0,24)
    minus.Position = UDim2.new(1,-100,0,52)
    minus.Text = "−"
    minus.Font = Enum.Font.GothamBold
    minus.TextSize = 14
    minus.TextColor3 = WHITE
    minus.BackgroundColor3 = Color3.fromRGB(62,18,38)
    minus.BorderSizePixel = 0
    minus.AutoButtonColor = false
    minus.ZIndex = 7
    minus.Parent = c
    Instance.new("UICorner",minus).CornerRadius = UDim.new(0,7)

    local sizeValue = Instance.new("TextLabel",c)
    sizeValue.BackgroundTransparency = 1
    sizeValue.Size = UDim2.new(0,40,0,24)
    sizeValue.Position = UDim2.new(1,-70,0,52)
    sizeValue.Font = Enum.Font.GothamBold
    sizeValue.TextSize = 8
    sizeValue.TextColor3 = Color3.fromRGB(255,170,205)
    sizeValue.Text = "100%"
    sizeValue.TextXAlignment = Enum.TextXAlignment.Center
    sizeValue.ZIndex = 6
    sizeValue.Parent = c

    local plus = Instance.new("TextButton",c)
    plus.Size = UDim2.new(0,28,0,24)
    plus.Position = UDim2.new(1,-36,0,52)
    plus.Text = "+"
    plus.Font = Enum.Font.GothamBold
    plus.TextSize = 14
    plus.TextColor3 = WHITE
    plus.BackgroundColor3 = Color3.fromRGB(62,18,38)
    plus.BorderSizePixel = 0
    plus.AutoButtonColor = false
    plus.ZIndex = 7
    plus.Parent = c
    Instance.new("UICorner",plus).CornerRadius = UDim.new(0,7)

    local enabled = true
    local scale = 1

    local function stealState()
        local env = (getgenv and getgenv()) or _G
        return env.__ZeyHubbSteal
    end

    local function applyEnabled()
        local s = stealState()
        if s then s.AutoStealEnabled = enabled end
        toggle.Text = enabled and "ON" or "OFF"
        toggle.BackgroundColor3 = enabled
            and Color3.fromRGB(220,65,135)
            or Color3.fromRGB(55,18,34)
    end

    local function applyScale()
        local playerGui = LP:FindFirstChildOfClass("PlayerGui")
        local sg = playerGui and playerGui:FindFirstChild("StealProgressScreenGui")
        local bar = sg and sg:FindFirstChild("StealProgressGui")
        if bar then
            bar.Size = UDim2.new(0,math.floor(220*scale+0.5),0,18)
        end
        sizeValue.Text = tostring(math.floor(scale*100+0.5)).."%"
    end

    toggle.Activated:Connect(function()
        enabled = not enabled
        applyEnabled()
    end)

    minus.Activated:Connect(function()
        scale = math.clamp(scale-0.1,0.5,1.6)
        applyScale()
    end)

    plus.Activated:Connect(function()
        scale = math.clamp(scale+0.1,0.5,1.6)
        applyScale()
    end)

    applyEnabled()
    task.spawn(function()
        for _=1,20 do
            task.wait(0.25)
            if stealState() then
                applyEnabled()
                applyScale()
                break
            end
        end
    end)
end

local function makeSecHeader(tabName, text)
 local f = Instance.new("Frame", pg(tabName)); f.Size = UDim2.new(1, 0, 0, 24); f.BackgroundTransparency = 1; f.BorderSizePixel = 0
 f.LayoutOrder = lo(tabName); f.ZIndex = 4; local accent = Instance.new("Frame", f); accent.Size = UDim2.new(0, 3, 0, 12)
	accent.Position = UDim2.new(0, 0, 0.5, -6)
	accent.BackgroundColor3 = WHITE
 accent.BorderSizePixel = 0; accent.ZIndex = 5; Instance.new("UICorner", accent).CornerRadius = UDim.new(1, 0); local t = Instance.new("TextLabel", f)
 t.Size = UDim2.new(1, -12, 0, 16); t.Position = UDim2.new(0, 9, 0, 1); t.BackgroundTransparency = 1; t.Text = text:upper()
	t.TextColor3 = WHITE
	t.Font = Enum.Font.GothamBold
	t.TextSize = 8
	t.TextXAlignment = Enum.TextXAlignment.Left
	t.TextWrapped = false
	t.TextTruncate = Enum.TextTruncate.AtEnd
 t.ZIndex = 5; local line = Instance.new("Frame", f); line.Size = UDim2.new(1, -9, 0, 1); line.Position = UDim2.new(0, 9, 1, -2)
	line.BackgroundColor3 = BORDER
 line.BackgroundTransparency = 0.25; line.BorderSizePixel = 0; line.ZIndex = 4
end
local _unwalkSavedAnimate = nil
local function startUnwalk()
    local c = LP.Character; if not c then return end
    local hum = c:FindFirstChildOfClass("Humanoid")
    if hum then for _,t in ipairs(hum:GetPlayingAnimationTracks()) do pcall(function() t:Stop() end) end end
    local anim = c:FindFirstChild("Animate")
    if anim then _unwalkSavedAnimate = anim:Clone(); anim:Destroy() end
end
local function stopUnwalk()
    local c = LP.Character
    if c then
        local existing = c:FindFirstChild("Animate")
        if not existing then
            local src = game:GetService("StarterPlayer"):FindFirstChildOfClass("StarterCharacterScripts"); local starterAnim = src and src:FindFirstChild("Animate")
            if starterAnim then starterAnim:Clone().Parent = c
            elseif _unwalkSavedAnimate then _unwalkSavedAnimate:Clone().Parent = c end
        end
    end
    _unwalkSavedAnimate = nil
end
local function baseCard(tabName, h2)
 local c = Instance.new("Frame", pg(tabName)); c.Size = UDim2.new(1, 0, 0, h2 or 38)
	c.BackgroundColor3 = CARD_BG
	c.BackgroundTransparency = OPTION_TRANSPARENCY
 c.BorderSizePixel = 0; c.LayoutOrder = lo(tabName); c.ZIndex = 4; Instance.new("UICorner", c).CornerRadius = UDim.new(0, 12)
	local cSt = Instance.new("UIStroke", c)
	cSt.Color = BORDER
 cSt.Thickness = 1; cSt.Transparency = 0.18; local sideAccent = Instance.new("Frame", c); sideAccent.Name = "VisualAccent"
 sideAccent.Size = UDim2.new(0, 2, 0.54, 0); sideAccent.Position = UDim2.new(0, 1, 0.23, 0)
	sideAccent.BackgroundColor3 = BORDER
 sideAccent.BackgroundTransparency = 0.2; sideAccent.BorderSizePixel = 0; sideAccent.ZIndex = 5; Instance.new("UICorner", sideAccent).CornerRadius = UDim.new(1, 0)
 local bottomDetail = Instance.new("Frame", c); bottomDetail.Name = "BottomDetail"; bottomDetail.Size = UDim2.new(1, -24, 0, 1); bottomDetail.Position = UDim2.new(0, 12, 1, -1)
 bottomDetail.BackgroundColor3 = Color3.fromRGB(15, 15, 15); bottomDetail.BackgroundTransparency = 0.58; bottomDetail.BorderSizePixel = 0; bottomDetail.ZIndex = 5
	c.MouseEnter:Connect(function() TweenService:Create(c, TweenInfo.new(0.1), {BackgroundColor3=Color3.fromRGB(82,82,82), BackgroundTransparency=0.08}):Play() end)
	c.MouseLeave:Connect(function() TweenService:Create(c, TweenInfo.new(0.1), {BackgroundColor3=Color3.fromRGB(58,58,58), BackgroundTransparency=0.08}):Play() end)
	return c
end
local function cLabel(p, text, x, w, sz, col, font, xa)
 local l = Instance.new("TextLabel", p); l.Size = UDim2.new(0, w or 140, 1, 0); l.Position = UDim2.new(0, x or 10, 0, 0); l.BackgroundTransparency = 1
	l.Text = text
	l.TextColor3 = col or WHITE
	l.Font = font or Enum.Font.GothamBold
	l.TextSize = sz or 11
	l.TextXAlignment = xa or Enum.TextXAlignment.Left
	l.ZIndex = 10
	return l
end
local function makePillToggle(parent, defOn, onToggle, large)
	local PW, PH = large and 70 or 36, large and 34 or 19
 local pbg = Instance.new("Frame", parent); pbg.Size = UDim2.new(0, PW, 0, PH); pbg.Position = UDim2.new(1, -(PW+10), 0.5, -PH/2); pbg.BackgroundColor3 = defOn and WHITE or DIM2
 pbg.BorderSizePixel = 0; pbg.ZIndex = 8; Instance.new("UICorner", pbg).CornerRadius = UDim.new(0, 10); local ps = Instance.new("UIStroke", pbg); ps.Color = defOn and WHITE or BORDER2; ps.Thickness = 1
 local dot = Instance.new("Frame", pbg); dot.Size = large and UDim2.new(0, 24, 0, 24) or UDim2.new(0, 13, 0, 13); dot.Position = defOn and UDim2.new(1, large and -26 or -15, 0.5, large and -12 or -6) or UDim2.new(0, 3, 0.5, large and -12 or -6)
	dot.BackgroundColor3 = defOn and BG or BORDER
 dot.BorderSizePixel = 0; dot.ZIndex = 9; Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0); local isOn = defOn or false
	local function setV(on)
		isOn = on
  TweenService:Create(pbg, TweenInfo.new(0.18), {BackgroundColor3=on and WHITE or DIM2}):Play(); TweenService:Create(ps,  TweenInfo.new(0.18), {Color=on and WHITE or BORDER2}):Play()
		TweenService:Create(dot, TweenInfo.new(0.18, Enum.EasingStyle.Back), {
			Position = on and UDim2.new(1,large and -26 or -15,0.5,large and -12 or -6) or UDim2.new(0,3,0.5,large and -12 or -6),
			BackgroundColor3 = on and BG or BORDER
		}):Play()
	end
 local clk = Instance.new("TextButton", parent); clk.AutoButtonColor = false; clk.Size = UDim2.new(1, 0, 1, 0); clk.BackgroundTransparency = 1
 clk.Text = ""; clk.ZIndex = 6
	clk.MouseButton1Click:Connect(function()
		if _anyKeyListening then return end
		isOn = not isOn; setV(isOn); if onToggle then pcall(onToggle, isOn) end
		if State.requestConfigSave then State.requestConfigSave() end
	end)
	return setV
end

-- ============================================================
-- ZEYHUBB_MUSIC_PLAYER_V1
-- ZEYHUBB playlist imported into a dedicated ZeyHubb Music tab.
-- ============================================================
do
    local MUSIC_FOLDER = "ZEYHUBBV2_Music"
    local MUSIC_TRACKS = {
    {name="MUSIC 1", url="https://files.catbox.moe/1gnx94", file="music1.mp3"},
    {name="MUSIC 2", url="https://files.catbox.moe/deh4xy", file="music2.mp3"},
    {name="MUSIC 3", url="https://files.catbox.moe/e7vb4x", file="music3.mp3"},
    {name="MUSIC 4", url="https://files.catbox.moe/htn746.mp3", file="music9999.mp3"},
    {name="MUSIC 5", url="https://files.catbox.moe/licyuc", file="music5.mp3"},
    {name="MUSIC 6", url="https://files.catbox.moe/inw6gz", file="music6.mp3"},
    {name="MUSIC 7", url="https://files.catbox.moe/acr8rq.mp3", file="music77.mp3"},
    {name="MUSIC 8", url="https://files.catbox.moe/o2catb.mp3", file="music88.mp3"},
    {name="MUSIC 9", url="https://files.catbox.moe/wb4eso.mp3", file="music9.mp3"},
    {name="MUSIC 10", url="https://files.catbox.moe/unxh2x.mp3", file="music10.mp3"},
    {name="MUSIC 11", url="https://files.catbox.moe/2spai8.mp3", file="music11.mp3"},
    {name="MUSIC 12", url="https://files.catbox.moe/jqwicu.mp3", file="music12.mp3"},
    {name="MUSIC 13", url="https://files.catbox.moe/b5w9ij.mp3", file="music13.mp3"},
    {name="MUSIC 14", url="https://files.catbox.moe/le430v.mp3", file="music14.mp3"},
    {name="MUSIC 15", url="https://files.catbox.moe/5vwgq5.mp3", file="music15.mp3"},
    {name="MUSIC 16", url="https://files.catbox.moe/9xv9k3.mp3", file="music16.mp3"},
    {name="MUSIC 17", url="https://files.catbox.moe/derl1s.mp3", file="music17.mp3"},
    {name="MUSIC 18", url="https://files.catbox.moe/z54fyk.mp3", file="music18.mp3"},
    {name="MUSIC 19", url="https://files.catbox.moe/q59kbe.mp3", file="music19.mp3"},
    {name="MUSIC 20", url="https://files.catbox.moe/l555b9.mp3", file="music20.mp3"},
    {name="MUSIC 21", url="https://files.catbox.moe/az9duq.mp3", file="music21.mp3"},
    {name="MUSIC 22", url="https://files.catbox.moe/0ftuu3.mp3", file="music22.mp3"}
    }

    local MusicSound = nil
    local MusicActive = nil
    local MusicSetters = {}
    local MusicVolume = 1

    local function musicStop()
        MusicActive = nil
        if MusicSound then
            pcall(function()
                MusicSound:Stop()
                MusicSound:Destroy()
            end)
            MusicSound = nil
        end
        for _, setter in pairs(MusicSetters) do
            pcall(setter, false)
        end
    end

    local function musicPlay(idx)
        local previous = MusicActive
        musicStop()
        if previous == idx then return end

        local track = MUSIC_TRACKS[idx]
        if not track then return end
        MusicActive = idx

        if MusicSetters[idx] then
            pcall(MusicSetters[idx], true)
        end

        task.spawn(function()
            local assetFunc = getsynasset or getcustomasset
            if type(assetFunc) ~= "function" then
                warn("[ZeyHubb Music] Cet executeur ne supporte pas getcustomasset/getsynasset.")
                musicStop()
                return
            end

            if not isfolder(MUSIC_FOLDER) then
                local ok = pcall(makefolder, MUSIC_FOLDER)
                if not ok then
                    warn("[ZeyHubb Music] Impossible de créer le dossier musique.")
                    musicStop()
                    return
                end
            end

            local path = MUSIC_FOLDER .. "/" .. track.file

            if not isfile(path) then
                local ok, err = pcall(function()
                    writefile(path, game:HttpGet(track.url))
                end)
                if not ok then
                    warn("[ZeyHubb Music] Téléchargement échoué pour " .. track.name .. " | " .. tostring(err))
                    musicStop()
                    return
                end
            end

            if MusicActive ~= idx then return end

            local assetId
            local ok, err = pcall(function()
                assetId = assetFunc(path)
            end)
            if not ok or not assetId then
                warn("[ZeyHubb Music] Chargement échoué pour " .. track.name .. " | " .. tostring(err))
                musicStop()
                return
            end

            if MusicActive ~= idx then return end

            local sound = Instance.new("Sound")
            sound.Name = "ZeyHubbMusic"
            sound.Volume = MusicVolume
            sound.SoundId = assetId
            sound.Looped = true
            sound.Parent = game:GetService("SoundService")
            MusicSound = sound

            local played, playErr = pcall(function()
                sound:Play()
            end)

            if not played then
                warn("[ZeyHubb Music] Lecture échouée | " .. tostring(playErr))
                musicStop()
            end
        end)
    end

    local function musicSetVolume(value)
        MusicVolume = math.clamp(tonumber(value) or 1, 0, 1)
        if MusicSound then
            MusicSound.Volume = MusicVolume
        end
    end

    local musicHeader = makeSecHeader("Music", "ZEYHUBB MUSIC")
    local musicIntro = baseCard("Music", 64)
    cLabel(musicIntro, "ZEYHUBB PLAYLIST", 13, 180, 12, WHITE, Enum.Font.GothamBlack)
    cLabel(musicIntro, tostring(#MUSIC_TRACKS) .. " musiques importées • lecture locale", 13, 240, 8, DIM, Enum.Font.Gotham)
    local stopBtn = Instance.new("TextButton", musicIntro)
    stopBtn.Size = UDim2.new(0, 58, 0, 24)
    stopBtn.Position = UDim2.new(1, -68, 0.5, -12)
    stopBtn.Text = "STOP"
    stopBtn.Font = Enum.Font.GothamBold
    stopBtn.TextSize = 8
    stopBtn.TextColor3 = WHITE
    stopBtn.BackgroundColor3 = Color3.fromRGB(55,18,34)
    stopBtn.BorderSizePixel = 0
    stopBtn.AutoButtonColor = false
    stopBtn.ZIndex = 11
    Instance.new("UICorner", stopBtn).CornerRadius = UDim.new(0, 8)
    stopBtn.MouseButton1Click:Connect(musicStop)

    makeSecHeader("Music", "Volume")
    local volumeCard = baseCard("Music", 54)
    cLabel(volumeCard, "VOLUME", 13, 70, 9, WHITE, Enum.Font.GothamBold)

    local volumeMinus = Instance.new("TextButton", volumeCard)
    volumeMinus.Size = UDim2.new(0, 26, 0, 22)
    volumeMinus.Position = UDim2.new(1, -96, 0.5, -11)
    volumeMinus.Text = "−"
    volumeMinus.Font = Enum.Font.GothamBold
    volumeMinus.TextSize = 13
    volumeMinus.TextColor3 = WHITE
    volumeMinus.BackgroundColor3 = Color3.fromRGB(55,18,34)
    volumeMinus.BorderSizePixel = 0
    volumeMinus.AutoButtonColor = false
    volumeMinus.ZIndex = 11
    Instance.new("UICorner", volumeMinus).CornerRadius = UDim.new(0, 7)

    local volumeValue = cLabel(volumeCard, "100%", 0, 44, 8, WHITE, Enum.Font.GothamBold, Enum.TextXAlignment.Center)
    volumeValue.Position = UDim2.new(1, -70, 0, 0)
    volumeValue.ZIndex = 11

    local volumePlus = Instance.new("TextButton", volumeCard)
    volumePlus.Size = UDim2.new(0, 26, 0, 22)
    volumePlus.Position = UDim2.new(1, -36, 0.5, -11)
    volumePlus.Text = "+"
    volumePlus.Font = Enum.Font.GothamBold
    volumePlus.TextSize = 13
    volumePlus.TextColor3 = WHITE
    volumePlus.BackgroundColor3 = Color3.fromRGB(55,18,34)
    volumePlus.BorderSizePixel = 0
    volumePlus.AutoButtonColor = false
    volumePlus.ZIndex = 11
    Instance.new("UICorner", volumePlus).CornerRadius = UDim.new(0, 7)

    local function refreshVolume()
        local percent = math.floor(MusicVolume * 100 + 0.5)
        volumeValue.Text = tostring(percent) .. "%"
        musicSetVolume(MusicVolume)
    end

    volumeMinus.MouseButton1Click:Connect(function()
        musicSetVolume(MusicVolume - 0.1)
        refreshVolume()
    end)
    volumePlus.MouseButton1Click:Connect(function()
        musicSetVolume(MusicVolume + 0.1)
        refreshVolume()
    end)

    makeSecHeader("Music", "Songs")

    for i, track in ipairs(MUSIC_TRACKS) do
        local card = baseCard("Music", 42)
        card.Name = "MusicTrack_" .. i

        local number = cLabel(card, string.format("%02d", i), 12, 25, 8, DIM, Enum.Font.GothamBold)
        number.TextXAlignment = Enum.TextXAlignment.Center

        local title = cLabel(card, track.name, 46, 180, 9, WHITE, Enum.Font.GothamBold)

        local status = cLabel(card, "OFF", 0, 38, 7, DIM, Enum.Font.GothamBold, Enum.TextXAlignment.Center)
        status.Position = UDim2.new(1, -142, 0, 0)

        local play = Instance.new("TextButton", card)
        play.Size = UDim2.new(0, 82, 0, 24)
        play.Position = UDim2.new(1, -92, 0.5, -12)
        play.Text = "PLAY"
        play.Font = Enum.Font.GothamBold
        play.TextSize = 8
        play.TextColor3 = WHITE
        play.BackgroundColor3 = Color3.fromRGB(55,18,34)
        play.BorderSizePixel = 0
        play.AutoButtonColor = false
        play.ZIndex = 11
        Instance.new("UICorner", play).CornerRadius = UDim.new(0, 8)

        local setVisual
        setVisual = function(on)
            status.Text = on and "PLAYING" or "OFF"
            status.TextColor3 = on and Color3.fromRGB(255,170,205) or DIM
            play.Text = on and "PLAYING" or "PLAY"
            play.BackgroundColor3 = on and Color3.fromRGB(110,28,65) or Color3.fromRGB(55,18,34)
        end

        MusicSetters[i] = setVisual

        play.MouseButton1Click:Connect(function()
            if MusicActive == i then
                musicStop()
            else
                musicPlay(i)
            end
        end)
    end
end

local function makeKB(parent, kbEntry, onChange)
 local b = Instance.new("TextButton", parent); b.AutoButtonColor = false; b.Size = UDim2.new(0, 44, 0, 20)
	b.BackgroundColor3 = KB_BG
	b.BackgroundTransparency = INPUT_TRANSPARENCY
	b.BorderSizePixel = 0
	local function getDisplayText()
		if kbEntry.gp then return "GP:"..kbEntry.gp.Name
		elseif kbEntry.kb then return kbEntry.kb.Name
		else return "None" end
	end
 b.Text = getDisplayText(); State._bindButtons = State._bindButtons or {}
	State._bindButtons[kbEntry] = b
	b.TextColor3 = WHITE
	b.Font = Enum.Font.GothamBold
 b.TextSize = 8; b.ZIndex = 11; Instance.new("UICorner", b).CornerRadius = UDim.new(0, 10); local bs = Instance.new("UIStroke", b); bs.Color = BORDER; bs.Thickness = 1
	local li = false; local lc; local pv = b.Text
	b.MouseButton1Click:Connect(function()
		if li then li=false; _anyKeyListening=false; if lc then lc:Disconnect(); lc=nil end; b.Text=pv; b.TextColor3=WHITE; return end
		pv=b.Text; li=true; _anyKeyListening=true; b.Text="···"; b.TextColor3=DIM
		TweenService:Create(bs, TweenInfo.new(0.1), {Color=WHITE}):Play()
		lc = UIS.InputBegan:Connect(function(inp)
			if not li then return end
			local isKb = inp.UserInputType == Enum.UserInputType.Keyboard
			local isGp = string.sub(inp.UserInputType.Name, 1, 7) == "Gamepad"
			if not isKb and not isGp then return end
			if inp.KeyCode == Enum.KeyCode.Escape then
				li=false; _anyKeyListening=false; if lc then lc:Disconnect(); lc=nil end
				b.Text=pv; b.TextColor3=WHITE; TweenService:Create(bs,TweenInfo.new(0.1),{Color=BORDER}):Play(); return
			end
			if isGp then
				kbEntry.gp = inp.KeyCode; kbEntry.kb = nil
				b.Text = "GP:"..inp.KeyCode.Name; pv = b.Text
			else
				kbEntry.kb = inp.KeyCode; kbEntry.gp = nil
				b.Text = inp.KeyCode.Name; pv = b.Text
			end
			b.TextColor3=WHITE
			li=false; _anyKeyListening=false; if lc then lc:Disconnect(); lc=nil end
			TweenService:Create(bs, TweenInfo.new(0.1), {Color=BORDER}):Play()
			if onChange then onChange(inp.KeyCode) end
			if isGp then
				kbEntry.gp = inp.KeyCode; kbEntry.kb = nil
			else
				kbEntry.kb = inp.KeyCode; kbEntry.gp = nil
			end
			if State.requestConfigSave then State.requestConfigSave() end
		end)
	end)
	return b
end
local function rowToggle(tabName, label, sub, defOn, onToggle)
 local c = baseCard(tabName, sub and 58 or 38); local titleLabel = cLabel(c, label, 10, 160, 11, WHITE, Enum.Font.GothamBold)
	if sub then
  titleLabel.Size = UDim2.new(0, 160, 0, 18); titleLabel.Position = UDim2.new(0, 10, 0, 7); local sl = cLabel(c, sub, 10, 170, 9, DIM, Enum.Font.Gotham); sl.Size = UDim2.new(0, 170, 0, 13)
		sl.Position = UDim2.new(0, 10, 0, 35)
	end
	return makePillToggle(c, defOn, onToggle, false)
end
local function rowToggleKB(tabName, label, sub, kbEntry, defOn, onToggle, onKeyChange)
 local c = baseCard(tabName, sub and 58 or 38); local titleLabel = cLabel(c, label, 10, 120, 11, WHITE, Enum.Font.GothamBold)
	if sub then
  titleLabel.Size = UDim2.new(0, 120, 0, 18); titleLabel.Position = UDim2.new(0, 10, 0, 7); local sl = cLabel(c, sub, 10, 150, 9, DIM, Enum.Font.Gotham); sl.Size = UDim2.new(0, 150, 0, 13)
		sl.Position = UDim2.new(0, 10, 0, 35)
	end
	local kb = makeKB(c, kbEntry, function(k) if onKeyChange then onKeyChange(k) end end)
 kb.Position = UDim2.new(1, -(44+10+36+8+19), 0.5, -10); kb.ZIndex = 11
	local PW, PH = 36, 19
 local pbg = Instance.new("Frame", c); pbg.Size = UDim2.new(0, PW, 0, PH); pbg.Position = UDim2.new(1, -(PW+10), 0.5, -PH/2); pbg.BackgroundColor3 = defOn and WHITE or DIM2
 pbg.BorderSizePixel = 0; pbg.ZIndex = 8; Instance.new("UICorner", pbg).CornerRadius = UDim.new(0, 10); local ps = Instance.new("UIStroke", pbg); ps.Color = defOn and WHITE or BORDER2; ps.Thickness = 1
 local dot = Instance.new("Frame", pbg); dot.Size = large and UDim2.new(0, 17, 0, 17) or UDim2.new(0, 13, 0, 13); dot.Position = defOn and UDim2.new(1, large and -19 or -15, 0.5, large and -8 or -6) or UDim2.new(0, 2, 0.5, large and -8 or -6)
	dot.BackgroundColor3 = defOn and BG or BORDER
 dot.BorderSizePixel = 0; dot.ZIndex = 9; Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0); local isOn = defOn or false
	local function setV(on)
		isOn = on
  TweenService:Create(pbg, TweenInfo.new(0.18), {BackgroundColor3=on and WHITE or DIM2}):Play(); TweenService:Create(ps,  TweenInfo.new(0.18), {Color=on and WHITE or BORDER2}):Play()
		TweenService:Create(dot, TweenInfo.new(0.18, Enum.EasingStyle.Back), {
			Position = on and UDim2.new(1,large and -19 or -15,0.5,large and -8 or -6) or UDim2.new(0,2,0.5,large and -8 or -6),
			BackgroundColor3 = on and BG or BORDER
		}):Play()
	end
 local clk = Instance.new("TextButton", c); clk.AutoButtonColor = false; clk.Size = UDim2.new(1, 0, 1, 0); clk.BackgroundTransparency = 1
 clk.Text = ""; clk.ZIndex = 6
	clk.MouseButton1Click:Connect(function()
		if _anyKeyListening then return end
		isOn = not isOn; setV(isOn); if onToggle then pcall(onToggle, isOn) end
		if State.requestConfigSave then State.requestConfigSave() end
	end)
	return setV, kb
end
local function rowKBOnly(tabName, label, sub, kbEntry, onKeyChange)
 local c = baseCard(tabName, sub and 58 or 38); local titleLabel = cLabel(c, label, 10, 160, 11, WHITE, Enum.Font.GothamBold)
	if sub then
  titleLabel.Size = UDim2.new(0, 160, 0, 18); titleLabel.Position = UDim2.new(0, 10, 0, 7); local sl = cLabel(c, sub, 10, 170, 9, DIM, Enum.Font.Gotham); sl.Size = UDim2.new(0, 170, 0, 13)
		sl.Position = UDim2.new(0, 10, 0, 35)
	end
	local kb = makeKB(c, kbEntry, function(k) if onKeyChange then onKeyChange(k) end end)
 kb.Position = UDim2.new(1, -(44+10), 0.5, -10); kb.ZIndex = 11
	return kb
end
local function rowInput(tabName, label, sub, default, onChange)
 local c = baseCard(tabName, sub and 58 or 38); local titleLabel = cLabel(c, label, 10, 130, 11, WHITE, Enum.Font.GothamBold)
	if sub then
  titleLabel.Size = UDim2.new(0, 130, 0, 18); titleLabel.Position = UDim2.new(0, 10, 0, 7); local sl = cLabel(c, sub, 10, 160, 9, DIM, Enum.Font.Gotham); sl.Size = UDim2.new(0, 160, 0, 13)
		sl.Position = UDim2.new(0, 10, 0, 35)
	end
 local box = Instance.new("TextBox", c); box.Size = UDim2.new(0, 64, 0, 24); box.Position = UDim2.new(1, -74, 0.5, -12)
	box.BackgroundColor3 = INPUT_BG
	box.BackgroundTransparency = INPUT_TRANSPARENCY
 box.BorderSizePixel = 0; box.Text = tostring(default)
	box.TextColor3 = WHITE
	box.Font = Enum.Font.GothamBold
 box.TextSize = 11; box.ClearTextOnFocus = false; box.ZIndex = 11; Instance.new("UICorner", box).CornerRadius = UDim.new(0, 12)
	local bs = Instance.new("UIStroke", box); bs.Color = BORDER; bs.Thickness = 1; bs.ZIndex = 12
	box.Focused:Connect(function() TweenService:Create(bs, TweenInfo.new(0.1), {Color=WHITE}):Play() end)
	box.FocusLost:Connect(function()
		TweenService:Create(bs, TweenInfo.new(0.1), {Color=BORDER}):Play()
		if onChange then local n = tonumber(box.Text); if n then onChange(n) else box.Text = tostring(default) end end
		if State.requestConfigSave then State.requestConfigSave() end
	end)
	return box
end
local function rowActionBtn(tabName, label, onClick)
 local b = Instance.new("TextButton", pg(tabName)); b.AutoButtonColor = false; b.Size = UDim2.new(1, 0, 0, 36)
	b.BackgroundColor3 = Color3.fromRGB(58, 58, 58)
	b.BackgroundTransparency = OPTION_TRANSPARENCY
	b.BorderSizePixel = 0
	b.Text = label
	b.TextColor3 = Color3.fromRGB(255, 255, 255)
	b.TextStrokeColor3 = Color3.fromRGB(255, 255, 255)
	b.TextStrokeTransparency = 0.45
	b.Font = Enum.Font.GothamBold
 b.TextSize = 11; b.LayoutOrder = lo(tabName); b.ZIndex = 5; Instance.new("UICorner", b).CornerRadius = UDim.new(0, 14)
	local bSt = Instance.new("UIStroke", b)
	bSt.Color = Color3.fromRGB(245, 245, 245)
 bSt.Thickness = 1.4; local glow = Instance.new("UIGradient", b)
 glow.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, Color3.fromRGB(45,45,45)), ColorSequenceKeypoint.new(0.5, Color3.fromRGB(115,115,115)), ColorSequenceKeypoint.new(1, Color3.fromRGB(45,45,45))}
 glow.Rotation = 0
 task.spawn(function() while b and b.Parent do TweenService:Create(glow, TweenInfo.new(1.25, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Offset=Vector2.new(1,0)}):Play(); task.wait(1.25); glow.Offset=Vector2.new(-1,0) end end)
 local pressScale = Instance.new("UIScale", b); pressScale.Scale = 1
	b.MouseButton1Click:Connect(function()
  TweenService:Create(pressScale, TweenInfo.new(0.06), {Scale=0.975}):Play(); TweenService:Create(b, TweenInfo.new(0.08), {BackgroundColor3=Color3.fromRGB(82,82,82), BackgroundTransparency=0.08}):Play()
		task.delay(0.08, function()
   if pressScale and pressScale.Parent then TweenService:Create(pressScale, TweenInfo.new(0.09, Enum.EasingStyle.Back), {Scale=1}):Play() end
		end)
		task.delay(0.15, function()
   if b and b.Parent then TweenService:Create(b, TweenInfo.new(0.1), {BackgroundColor3=Color3.fromRGB(58,58,58), BackgroundTransparency=0.08}):Play() end
		end)
		if onClick then pcall(onClick) end
	end)
	b.MouseEnter:Connect(function() TweenService:Create(b, TweenInfo.new(0.1), {BackgroundColor3=Color3.fromRGB(82,82,82), BackgroundTransparency=0.08}):Play() end)
	b.MouseLeave:Connect(function() TweenService:Create(b, TweenInfo.new(0.1), {BackgroundColor3=Color3.fromRGB(58,58,58), BackgroundTransparency=0.08}):Play() end)
	return b
end
local function rowCycleSelector(tabName, label, options, defaultValue, onChange)
 local c = baseCard(tabName, 40); cLabel(c, label, 10, 110, 11, WHITE, Enum.Font.GothamBold); local left = Instance.new("TextButton", c); left.AutoButtonColor = false
 left.Size = UDim2.new(0, 26, 0, 24); left.Position = UDim2.new(1, -142, 0.5, -12)
	left.BackgroundColor3 = INPUT_BG
	left.BackgroundTransparency = INPUT_TRANSPARENCY
 left.BorderSizePixel = 0; left.Text = "←"
	left.TextColor3 = WHITE
	left.Font = Enum.Font.GothamBlack
 left.TextSize = 15; left.ZIndex = 12; Instance.new("UICorner", left).CornerRadius = UDim.new(0, 12); local leftStroke = Instance.new("UIStroke", left); leftStroke.Color = BORDER; leftStroke.Thickness = 1
 local valueLabel = Instance.new("TextLabel", c); valueLabel.Size = UDim2.new(0, 78, 0, 24); valueLabel.Position = UDim2.new(1, -112, 0.5, -12)
	valueLabel.BackgroundColor3 = INPUT_BG
	valueLabel.BackgroundTransparency = INPUT_TRANSPARENCY
	valueLabel.BorderSizePixel = 0
	valueLabel.TextColor3 = WHITE
	valueLabel.Font = Enum.Font.GothamBold
	valueLabel.TextSize = 9
	valueLabel.TextXAlignment = Enum.TextXAlignment.Center
 valueLabel.ZIndex = 11; Instance.new("UICorner", valueLabel).CornerRadius = UDim.new(0, 12); local valueStroke = Instance.new("UIStroke", valueLabel); valueStroke.Color = BORDER; valueStroke.Thickness = 1; local right = Instance.new("TextButton", c)
 right.AutoButtonColor = false; right.Size = UDim2.new(0, 26, 0, 24); right.Position = UDim2.new(1, -30, 0.5, -12)
	right.BackgroundColor3 = INPUT_BG
	right.BackgroundTransparency = INPUT_TRANSPARENCY
 right.BorderSizePixel = 0; right.Text = "→"
	right.TextColor3 = WHITE
	right.Font = Enum.Font.GothamBlack
 right.TextSize = 15; right.ZIndex = 12; Instance.new("UICorner", right).CornerRadius = UDim.new(0, 12); local rightStroke = Instance.new("UIStroke", right); rightStroke.Color = BORDER; rightStroke.Thickness = 1
	local index = 1
	for i, option in ipairs(options) do
		if option == defaultValue then index = i; break end
	end
	local function setValue(value, fireCallback)
		if type(value) == "number" then
			index = ((math.floor(value) - 1) % #options) + 1
		else
			for i, option in ipairs(options) do
				if option == value then index = i; break end
			end
		end
		valueLabel.Text = options[index]
		if fireCallback and onChange then pcall(onChange, options[index], index) end
		return options[index]
	end
	local function move(direction)
		setValue(index + direction, true)
		if State.requestConfigSave then State.requestConfigSave() end
	end
	left.Activated:Connect(function() move(-1) end)
	right.Activated:Connect(function() move(1) end)
	left.MouseEnter:Connect(function() TweenService:Create(left, TweenInfo.new(0.1), {BackgroundTransparency=0.05}):Play() end)
	left.MouseLeave:Connect(function() TweenService:Create(left, TweenInfo.new(0.1), {BackgroundTransparency=INPUT_TRANSPARENCY}):Play() end)
	right.MouseEnter:Connect(function() TweenService:Create(right, TweenInfo.new(0.1), {BackgroundTransparency=0.05}):Play() end)
	right.MouseLeave:Connect(function() TweenService:Create(right, TweenInfo.new(0.1), {BackgroundTransparency=INPUT_TRANSPARENCY}):Play() end)
	setValue(defaultValue, false)
	return setValue, function() return options[index] end
end
do
makeSecHeader("Speed", "Speed Configuration")
normalBox = rowInput("Speed", "Normal Speed", nil, NS, function(v)
	if v > 0 and v <= 500 then
		if State.speedProfile == "Lagger" then
			State.profileLaggerNormalSpeed = v
		else
			NS = v
		end
		if State.requestConfigSave then State.requestConfigSave() end
	end
end)
carryBox = rowInput("Speed", "Carry Speed", nil, CS, function(v)
	if v > 0 and v <= 500 then
		if State.speedProfile == "Lagger" then
			State.profileLaggerCarrySpeed = v
		else
			CS = v
			_G.CarrySpeedValue = v
		end
		if State.requestConfigSave then State.requestConfigSave() end
	end
end)
laggerBox = rowInput("Speed", "Lagger 1", nil, LS, function(v) if v>0 and v<=500 then LS=v end end)
laggerBox2 = rowInput("Speed", "Lagger 2", nil, LS2, function(v) if v>0 and v<=500 then LS2=v end end)
do
 local c = baseCard("Speed", 38); cLabel(c, "Mode", 10, 80, 11, WHITE, Enum.Font.GothamBold); modeValLbl = cLabel(c, "Normal", 88, 80, 10, DIM, Enum.Font.GothamBold, Enum.TextXAlignment.Center)
	local kb = makeKB(c, KB.Speed, function(k) end)
 kb.Position = UDim2.new(1, -(44+10), 0.5, -10); kb.ZIndex = 11; local clk = Instance.new("TextButton", c); clk.AutoButtonColor = false
 clk.Size = UDim2.new(0.65, 0, 1, 0); clk.BackgroundTransparency = 1; clk.Text = ""; clk.ZIndex = 6
	clk.Active = true
	clk.Activated:Connect(function()
		if _anyKeyListening then return end
		State.speedToggled = not State.speedToggled
		if State.speedToggled then
			State.laggerToggled = false
			if mobileLaggerSetActive then mobileLaggerSetActive(false) end
		end
		if mobileSpeedSetActive then mobileSpeedSetActive(State.speedToggled) end
		modeValLbl.Text = State.laggerToggled and "Lagger" or (State.speedToggled and (State.speedProfile == "Lagger" and ("Carry · " .. tostring(State.profileLaggerCarrySpeed)) or "Carry") or (State.speedProfile == "Lagger" and ("Lagger · " .. tostring(State.profileLaggerNormalSpeed)) or "Normal"))
		if State.requestConfigSave then State.requestConfigSave() end
	end)
end
do
 local c = baseCard("Speed", 38); cLabel(c, "Lagger Mode", 10, 120, 11, WHITE, Enum.Font.GothamBold)
	local kb = makeKB(c, KB.Lagger, function(k) KB.Lagger.kb = k end)
 kb.Position = UDim2.new(1, -(44+10), 0.5, -10); kb.ZIndex = 11; local clk = Instance.new("TextButton", c); clk.AutoButtonColor = false
 clk.Size = UDim2.new(0.65, 0, 1, 0); clk.BackgroundTransparency = 1; clk.Text = ""; clk.ZIndex = 6
	clk.Active = true
	clk.Activated:Connect(function()
		if _anyKeyListening then return end
		State.laggerToggled = not State.laggerToggled
		if State.laggerToggled then
			State.speedToggled = false
			if mobileSpeedSetActive then mobileSpeedSetActive(false) end
		end
		modeValLbl.Text = State.laggerToggled and "Lagger" or (State.speedToggled and (State.speedProfile == "Lagger" and ("Carry · " .. tostring(State.profileLaggerCarrySpeed)) or "Carry") or (State.speedProfile == "Lagger" and ("Lagger · " .. tostring(State.profileLaggerNormalSpeed)) or "Normal"))
		if mobileLaggerSetActive then mobileLaggerSetActive(State.laggerToggled) end
		if State.requestConfigSave then State.requestConfigSave() end
	end)
end
makeSecHeader("Bat Aimbot", "Bat Combat V1 & V2")
do
	local sv
	sv, _ = rowToggleKB("Bat Aimbot", "Auto Bat V1", "Modo predictivo", KB.AutoBat, false,
	function(on)
		State.autoBatToggled = on
		if on then
			if State.autoLeftEnabled then State.autoLeftEnabled = false; if autoLeftSetVisual then autoLeftSetVisual(false) end; stopAutoLeft() end
			if State.autoRightEnabled then State.autoRightEnabled = false; if autoRightSetVisual then autoRightSetVisual(false) end; stopAutoRight() end
			if State.autoBatV2Enabled then
				State.autoBatV2Enabled = false
				if autoBatV2SetVisual then autoBatV2SetVisual(false) end
				if mobileBatV2SetActive then mobileBatV2SetActive(false) end
				stopBatAimbotV2()
			end
			startBatAimbot()
		else
			stopBatAimbot()
		end
		if mobileBatV1SetActive then mobileBatV1SetActive(on) end
	end,
	function(k) KB.AutoBat.kb = k end)
	autoBatSetVisual = sv
	setAutoBat = sv
end
do
	local sv
end
State._setTPBatEnabled = function(on)
	State.tpBatEnabled = on == true
	if State._hitboxFollower then
		if State.tpBatEnabled then
   if State.hitboxFollowerEnabled then State._hitboxFollower.stop() end
		elseif State.hitboxFollowerEnabled and not State.autoBatToggled then
			State._hitboxFollower.start()
		end
	end
end
State._tpBatConfigSetVisual = rowToggleKB("Bat Aimbot", "TP BAT", "Teleport y golpe automático", KB.TPBat, false,
function(on)
	State._setTPBatEnabled(on)
	if State._tpBatSetter then State._tpBatSetter(on) end
	if State.requestConfigSave then State.requestConfigSave() end
end,
function() end)
State._tpBatVersionSetVisual = rowToggle("Bat Aimbot", "TP BAT V2", "Off = TP Bat V1 / On = TP Bat V2", false,
function(on)
 State.tpBatVersion = on and 2 or 1; State._tpBatV2HittingCooldown = false; State._tpBatHittingCooldown = false
 if State._updateTPBatButtonText then State._updateTPBatButtonText() end
 if State.requestConfigSave then State.requestConfigSave() end
end)
-- Hold Infinite Jump: maintenir Espace applique continuellement le boost.
State.infJumpMode = "hold"
State._holdInfJumpConn = State._holdInfJumpConn or nil

State.startHoldInfJump = function()
    if State._holdInfJumpConn then
        State._holdInfJumpConn:Disconnect()
        State._holdInfJumpConn = nil
    end
    State._holdInfJumpConn = RunService.Heartbeat:Connect(function()
        if not State.infJumpEnabled or State.infJumpMode ~= "hold" then return end
        local char = LP.Character
        if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not root or not hum then return end
        local jumpHeld = UIS:IsKeyDown(Enum.KeyCode.Space) or hum.Jump == true
        local cv = root.AssemblyLinearVelocity
        if jumpHeld and cv.Y < 35 then
            root.AssemblyLinearVelocity = Vector3.new(cv.X, 55, cv.Z)
        elseif cv.Y < -120 then
            root.AssemblyLinearVelocity = Vector3.new(cv.X, -120, cv.Z)
        end
    end)
end

State.stopHoldInfJump = function()
    if State._holdInfJumpConn then
        State._holdInfJumpConn:Disconnect()
        State._holdInfJumpConn = nil
    end
end

-- Keep Hold Infinite Jump active after character respawns.
if LP.CharacterAdded then
    LP.CharacterAdded:Connect(function()
        task.defer(function()
            if State.infJumpEnabled and State.infJumpMode == "hold" then
                State.startHoldInfJump()
            end
        end)
    end)
end

setInfJump = rowToggle("Mechanics", "Infinite Jump", "Hold = maintenir Espace", false, function(on)
    State.infJumpEnabled = (on == true)
    State.infJumpMode = "hold"

    if State.infJumpEnabled then
        State.startHoldInfJump()
    else
        State.stopHoldInfJump()
    end

    -- Save immediately when the Infinite Jump button changes.
    -- During startup loadConfig() this is safely queued until loading finishes.
    if type(requestConfigSave) == "function" then
        pcall(requestConfigSave)
    end
end)
setLinieVisual   = rowToggle("Mechanics", "Linia ESP", nil, false, function(on) State.linieEnabled = on end)
setAntiRag       = rowToggle("Mechanics", "Anti Ragdoll",   nil, false, function(on) State.antiRagdollEnabled=on; if on then startAntiRagdoll() else stopAntiRagdoll() end end)
setUnwalkToggle  = rowToggle("Mechanics", "Unwalk",         nil, false, function(on) State.unwalkEnabled=on; if on then startUnwalk() else stopUnwalk() end end)
setMedusaCounter = rowToggle("Mechanics", "Medusa Counter", nil, false, function(on) State.medusaCounterEnabled=on; refreshMedusaHooks() end)
setBatCounter = rowToggle("Mechanics", "Bat Counter",    nil, false, function(on) State.batCounterEnabled=on; if on then startBatCounter() else stopBatCounter() end end)
setAutoMedusaVisual = rowToggle("Mechanics", "Auto Medusa", "Uso automático y predictivo", false, function(on)
	MedusaConfig.Enabled = on
end)
rowInput("Mechanics", "Medusa Radius", "Rango de detección", MedusaConfig.Radius, function(v)
	MedusaConfig.Radius = v
 if MedusaConfig.RadiusPart then MedusaConfig.RadiusPart.Size = Vector3.new(0.2, MedusaConfig.Radius*2, MedusaConfig.Radius*2) end
end)
rowInput("Mechanics", "Medusa Delay", "Spam Delay", MedusaConfig.Delay, function(v)
	MedusaConfig.Delay = v
end)
-- ============================================================
makeSecHeader("Movement", "Movement & Teleport")
rowKBOnly("Movement", "TP Down", "Teleport to floor", KB.TPDown, function(k) KB.TPDown.kb=k end)
do
	local sv
	sv, _ = rowToggleKB("Movement", "Auto Left", nil, KB.AutoLeft, false,
	function(on)
		State.autoLeftEnabled = on
		if on then
			if State.autoRightEnabled then State.autoRightEnabled=false; if autoRightSetVisual then autoRightSetVisual(false) end; stopAutoRight() end
			if State.autoBatToggled then State.autoBatToggled=false; if autoBatSetVisual then autoBatSetVisual(false) end; stopBatAimbot() end
			if State.autoBatV2Enabled then
				State.autoBatV2Enabled = false
				if autoBatV2SetVisual then autoBatV2SetVisual(false) end
				if mobileBatV2SetActive then mobileBatV2SetActive(false) end
				stopBatAimbotV2()
			end
			local char = LP.Character
   local hum = char and char:FindFirstChild("Humanoid"); local hrp = char and char:FindFirstChild("HumanoidRootPart")
   if hum and hrp and hum.WalkSpeed > 0 and not hrp.Anchored then startAutoLeft() end
		else stopAutoLeft() end
		if mobileAutoLeftSetActive then mobileAutoLeftSetActive(on) end
	end, function(k) KB.AutoLeft.kb=k end)
	autoLeftSetVisual = sv
end
do
	local sv
	sv, _ = rowToggleKB("Movement", "Auto Right", nil, KB.AutoRight, false,
	function(on)
		State.autoRightEnabled = on
		if on then
			if State.autoLeftEnabled then State.autoLeftEnabled=false; if autoLeftSetVisual then autoLeftSetVisual(false) end; stopAutoLeft() end
			if State.autoBatToggled then State.autoBatToggled=false; if autoBatSetVisual then autoBatSetVisual(false) end; stopBatAimbot() end
			if State.autoBatV2Enabled then State.autoBatV2Enabled=false; if autoBatV2SetVisual then autoBatV2SetVisual(false) end; stopBatAimbotV2() end
			local char = LP.Character
   local hum = char and char:FindFirstChild("Humanoid"); local hrp = char and char:FindFirstChild("HumanoidRootPart")
   if hum and hrp and hum.WalkSpeed > 0 and not hrp.Anchored then startAutoRight() end
		else stopAutoRight() end
		if mobileAutoRightSetActive then mobileAutoRightSetActive(on) end
	end, function(k) KB.AutoRight.kb=k end)
	autoRightSetVisual = sv
end
rowKBOnly("Movement", "Drop",    nil, KB.Drop,   function(k) KB.Drop.kb=k end)
do
	setAutoTPDownVisual = rowToggle("Movement", "Auto TP Down", nil, false, function(on)
		autoTPDownEnabled = on
		if mobileAutoTPSetActive then mobileAutoTPSetActive(on) end
		if on then startAutoTPDown() else stopAutoTPDown() end
	end)
	rowInput("Movement", "TP Down Height", nil, autoTPDownHeight, function(v)
		autoTPDownHeight = math.clamp(v, 0, 500)
	end)
end
do
    local KORBLOX_ASSETS = {
        ["Left Leg"] = {
            id = "rbxassetid://139607673",
            targetBodyPart = "LeftUpperLeg",
            partsToHide = {"LeftUpperLeg","LeftLowerLeg","LeftFoot"},
            scale = Vector3.new(1,1,1),
            audio = "rbxassetid://87998522263554",
            offset = CFrame.new(0,0,0),
        },
        ["Right Leg"] = {
            id = "rbxassetid://139607718",
            targetBodyPart = "RightUpperLeg",
            partsToHide = {"RightUpperLeg","RightLowerLeg","RightFoot"},
            scale = Vector3.new(1,1,1),
            audio = "rbxassetid://135315310485417",
            offset = CFrame.new(0,0,0),
        },
        ["Headless"] = {
            id = "rbxassetid://134082579",
            targetBodyPart = "Head",
            partsToHide = {"Head"},
            scale = Vector3.new(1,1,1),
            audio = "rbxassetid://135315310485417",
            offset = CFrame.new(0,0,0),
            hideFace = true,
        },
    }
    local TAGS = { ["Left Leg"] = "Korblox_LeftLeg", ["Right Leg"] = "Korblox_RightLeg", ["Headless"] = "Korblox_Headless" }
    local KEYS = { ["Left Leg"] = "Left", ["Right Leg"] = "Right", ["Headless"] = "Headless" }
    local State_KX = { Left = false, Right = false, Headless = false }
    local _templates = {}

    -- Pre-download and cache the mesh once, so a respawn never waits on the
    -- asset fetch (that fetch was the 1-2s "legs disappear" gap).
    local function getTemplate(itemName, config)
        if _templates[itemName] then return _templates[itemName] end
        local ok, objects = pcall(function() return game:GetObjects(config.id) end)
        if not ok or not objects or #objects == 0 then return nil end
        local model = objects[1]
        model.Parent = nil
        _templates[itemName] = model
        return model
    end

    local function hideLimbs(character, config)
        for _, partName in ipairs(config.partsToHide) do
            local limb = character:FindFirstChild(partName)
            if limb and limb:IsA("BasePart") then limb.Transparency = 1 end
        end
        if config.hideFace then
            local head = character:FindFirstChild("Head")
            if head then
                for _, d in ipairs(head:GetDescendants()) do
                    if d:IsA("Decal") or d:IsA("Texture") then d.Transparency = 1 end
                end
            end
        end
    end

    local function showLimbs(character, config)
        for _, partName in ipairs(config.partsToHide) do
            local limb = character:FindFirstChild(partName)
            if limb and limb:IsA("BasePart") then limb.Transparency = 0 end
        end
        if config.hideFace then
            local head = character:FindFirstChild("Head")
            if head then
                for _, d in ipairs(head:GetDescendants()) do
                    if d:IsA("Decal") or d:IsA("Texture") then d.Transparency = 0 end
                end
            end
        end
    end

    local function attachKorblox(itemName, config, playAudio)
        local character = LP.Character
        if not character then return false, "No character" end
        local targetPart = character:FindFirstChild(config.targetBodyPart)
            or character:WaitForChild(config.targetBodyPart, 3)
        if not targetPart then return false, "Target part missing" end
        -- Hide the real limb FIRST so there is no frame with a normal leg/head.
        hideLimbs(character, config)
        local tag = TAGS[itemName] or ("Korblox_" .. itemName:gsub("%s+", ""))
        local template = getTemplate(itemName, config)
        if not template then return false, "Asset fetch failed" end
        local old = character:FindFirstChild(tag)
        if old then old:Destroy() end
        local assetModel = template:Clone()
        assetModel.Name = tag
        local mainMesh = assetModel:IsA("BasePart") and assetModel or assetModel:FindFirstChildWhichIsA("BasePart", true)
        if not mainMesh then assetModel:Destroy(); return false, "No MeshPart in asset" end
        mainMesh.Size = mainMesh.Size * config.scale
        mainMesh.CanCollide = false
        mainMesh.Anchored = false
        mainMesh.CFrame = targetPart.CFrame * config.offset
        local weld = Instance.new("WeldConstraint")
        weld.Part0 = targetPart
        weld.Part1 = mainMesh
        weld.Parent = mainMesh
        assetModel.Parent = character
        if playAudio and config.audio then
            local sound = Instance.new("Sound")
            sound.SoundId = config.audio
            sound.Volume = 0.5
            sound.Parent = mainMesh
            sound:Play(); game:GetService("Debris"):AddItem(sound, 3)
        end
        return true
    end

    local function anyEnabled()
        return State_KX.Left or State_KX.Right or State_KX.Headless
    end

    local function applyIfEnabled(playAudio)
        for itemName, key in pairs(KEYS) do
            if State_KX[key] then pcall(attachKorblox, itemName, KORBLOX_ASSETS[itemName], playAudio) end
        end
    end

    LP.CharacterAdded:Connect(function(char)
        if not anyEnabled() then return end
        -- Hide limbs on the very first frames of the new character, then weld.
        task.spawn(function()
            for _ = 1, 40 do
                for itemName, key in pairs(KEYS) do
                    if State_KX[key] then hideLimbs(char, KORBLOX_ASSETS[itemName]) end
                end
                if char.Parent == nil then return end
                task.wait(0.05)
            end
        end)
        applyIfEnabled(false)
    end)

    -- Watchdog: if the game strips the mesh (reset, ragdoll, respawn race),
    -- re-weld it right away instead of leaving the limb/head missing.
    task.spawn(function()
        while true do
            task.wait(0.4)
            local ch = LP.Character
            if ch and anyEnabled() then
                for itemName, key in pairs(KEYS) do
                    if State_KX[key] then
                        local cfgItem = KORBLOX_ASSETS[itemName]
                        if not ch:FindFirstChild(TAGS[itemName]) then
                            pcall(attachKorblox, itemName, cfgItem, false)
                        else
                            hideLimbs(ch, cfgItem)
                        end
                    end
                end
            end
        end
    end)

    local function setItem(itemName, on, playAudio)
        local key = KEYS[itemName]
        State_KX[key] = on
        State["korblox" .. key] = on
        if on then
            local ok, err = attachKorblox(itemName, KORBLOX_ASSETS[itemName], playAudio ~= false)
            if not ok then warn("[Korblox " .. itemName .. "] " .. tostring(err)) end
        else
            local ch = LP.Character
            if ch then
                local m = ch:FindFirstChild(TAGS[itemName])
                if m then m:Destroy() end
                showLimbs(ch, KORBLOX_ASSETS[itemName])
            end
        end
    end

    makeSecHeader("Animation", "Korblox Legs")
    local visLeft = rowToggle("Animation", "Left Korblox Leg", "Equip left korblox mesh", false, function(on)
        setItem("Left Leg", on, true)
        if State.requestConfigSave then State.requestConfigSave() end
    end)
    local visRight = rowToggle("Animation", "Right Korblox Leg", "Equip right korblox mesh", false, function(on)
        setItem("Right Leg", on, true)
        if State.requestConfigSave then State.requestConfigSave() end
    end)
    local visHeadless = rowToggle("Animation", "Headless", "Equip headless mesh", false, function(on)
        setItem("Headless", on, true)
        if State.requestConfigSave then State.requestConfigSave() end
    end)

    -- Restore from saved config (no audio, no extra save write)
    State._setKorbloxLeft = function(on)
        if visLeft then visLeft(on) end
        setItem("Left Leg", on == true, false)
    end
    State._setKorbloxRight = function(on)
        if visRight then visRight(on) end
        setItem("Right Leg", on == true, false)
    end
    State._setKorbloxHeadless = function(on)
        if visHeadless then visHeadless(on) end
        setItem("Headless", on == true, false)
    end
end
makeSecHeader("Performance", "Performance")
do
 local _Lighting = game:GetService("Lighting"); local _antiLagConn = nil
	local function applyAntiLag(instance)
		if instance:IsA("ParticleEmitter") then
			instance.Enabled = false
		elseif instance:IsA("Decal") then
			instance.Transparency = 1
		elseif instance:IsA("BasePart") then
			instance.Material = Enum.Material.Plastic
   instance.Reflectance = 0; instance.CastShadow = false
		end
	end
	local function optimizeLighting()
  _Lighting.GlobalShadows = false; _Lighting.FogEnd = 9e9; _Lighting.Brightness = 1; _Lighting.EnvironmentDiffuseScale = 0
		_Lighting.EnvironmentSpecularScale = 0
		for _, child in pairs(_Lighting:GetChildren()) do
   if child:IsA("BloomEffect") or child:IsA("BlurEffect") or child:IsA("SunRaysEffect") then child.Enabled = false end
		end
	end
	local function enableAntiLag()
		optimizeLighting()
		for _, desc in pairs(workspace:GetDescendants()) do
			applyAntiLag(desc)
			if desc:IsA("Accessory") then desc:Destroy() end
		end
		if _antiLagConn then _antiLagConn:Disconnect() end
		_antiLagConn = workspace.DescendantAdded:Connect(function(desc)
			applyAntiLag(desc)
			if desc:IsA("Accessory") then desc:Destroy() end
		end)
	end
	local function disableAntiLag()
		if _antiLagConn then _antiLagConn:Disconnect(); _antiLagConn = nil end
	end
	setAntiLag = function(on)
		State.antiLagEnabled = on
		if on then enableAntiLag() else disableAntiLag() end
	end
	local setAntiLagVisual = rowToggle("Performance", "Anti Lag", nil, false, function(on) setAntiLag(on) end)
	local rawSetAntiLag = setAntiLag
	setAntiLag = function(on) setAntiLagVisual(on); rawSetAntiLag(on) end
end
do
	local connection = nil
	local function rawSet(on)
		State.stretchRezEnabled = on
		if on then
			workspace.CurrentCamera.FieldOfView = 120
			if connection then connection:Disconnect() end
			connection = RunService.RenderStepped:Connect(function()
				if not State.stretchRezEnabled then
					if connection then connection:Disconnect(); connection = nil end
					return
				end
				workspace.CurrentCamera.FieldOfView = 120
			end)
		else
			if connection then connection:Disconnect(); connection = nil end
			workspace.CurrentCamera.FieldOfView = 70
		end
	end
	local visual = rowToggle("Performance", "Stretch Rez", nil, false, function(on) rawSet(on) end)
	setStretchRez = function(on) visual(on); rawSet(on) end
end
do
	local connection = nil
	local function removeFromCharacter(character)
		if not character then return end
		for _, obj in ipairs(character:GetDescendants()) do
			if obj:IsA("Accessory") or obj:IsA("Hat") then
				pcall(function() obj:Destroy() end)
			end
		end
	end
	local function rawSet(on)
		State.removeAccessoriesEnabled = on
		if on then
   for _, player in pairs(Players:GetPlayers()) do removeFromCharacter(player.Character) end
			if not connection then
				connection = Players.PlayerAdded:Connect(function(player)
					player.CharacterAdded:Connect(function(character)
						task.wait(0.5)
						if State.removeAccessoriesEnabled then removeFromCharacter(character) end
					end)
				end)
			end
		else
			if connection then connection:Disconnect(); connection = nil end
		end
	end
	local visual = rowToggle("Performance", "Remove Accessories", nil, false, function(on) rawSet(on) end)
	setRemoveAccessories = function(on) visual(on); rawSet(on) end
end
do
	local Lighting = game:GetService("Lighting")
	local defaults = {
		Brightness = Lighting.Brightness,
		ClockTime = Lighting.ClockTime,
		ExposureCompensation = Lighting.ExposureCompensation,
		OutdoorAmbient = Lighting.OutdoorAmbient,
		Ambient = Lighting.Ambient,
		FogColor = Lighting.FogColor,
	}
	-- tint = ColorCorrection TintColor (multiplicativo: manter perto do branco!)
	-- atmosphere/decay = cor do ceu/neblina | ambient = luz ambiente | clock = hora do dia
	local styles = {
		{name="Off"},
		{name="Galaxy", tint=Color3.fromRGB(226, 224, 255), ambient=Color3.fromRGB(88, 84, 130), atmosphere=Color3.fromRGB(150, 148, 210), decay=Color3.fromRGB(92, 80, 160), clock=0.4, brightness=2.2, density=0.32, glare=0.28, haze=1.1, bloom=0.5, stars=4500},
		{name="Aurora", tint=Color3.fromRGB(222, 255, 240), ambient=Color3.fromRGB(78, 122, 108), atmosphere=Color3.fromRGB(130, 235, 200), decay=Color3.fromRGB(90, 190, 165), clock=1.2, brightness=2.4, density=0.3, glare=0.4, haze=1.35, bloom=0.6, stars=4000},
		{name="Green",  tint=Color3.fromRGB(228, 255, 226), ambient=Color3.fromRGB(84, 122, 84),  atmosphere=Color3.fromRGB(150, 225, 150), decay=Color3.fromRGB(100, 175, 100), clock=6.6, brightness=2.5, density=0.26, glare=0.22, haze=0.95, bloom=0.42, stars=1200},
		{name="Blue",   tint=Color3.fromRGB(224, 238, 255), ambient=Color3.fromRGB(80, 104, 140), atmosphere=Color3.fromRGB(140, 190, 250), decay=Color3.fromRGB(90, 140, 210), clock=5.8, brightness=2.5, density=0.28, glare=0.24, haze=1.0, bloom=0.45, stars=2500},
		{name="Red",    tint=Color3.fromRGB(255, 228, 224), ambient=Color3.fromRGB(100, 100, 100),  atmosphere=Color3.fromRGB(160, 160, 160), decay=Color3.fromRGB(122, 122, 122),  clock=17.6, brightness=2.4, density=0.28, glare=0.26, haze=1.05, bloom=0.48, stars=1500},
		{name="Pink",   tint=Color3.fromRGB(255, 230, 244), ambient=Color3.fromRGB(132, 96, 118), atmosphere=Color3.fromRGB(191, 191, 191), decay=Color3.fromRGB(151, 151, 151), clock=17.0, brightness=2.4, density=0.26, glare=0.26, haze=1.0, bloom=0.5, stars=2000},
		{name="Orange", tint=Color3.fromRGB(255, 238, 220), ambient=Color3.fromRGB(136, 108, 78), atmosphere=Color3.fromRGB(193, 193, 193), decay=Color3.fromRGB(154, 154, 154),  clock=17.9, brightness=2.5, density=0.26, glare=0.3, haze=1.0, bloom=0.45, stars=1200},
		{name="Cyan",   tint=Color3.fromRGB(222, 250, 255), ambient=Color3.fromRGB(80, 122, 132), atmosphere=Color3.fromRGB(135, 225, 240), decay=Color3.fromRGB(90, 180, 200), clock=6.2, brightness=2.5, density=0.28, glare=0.26, haze=1.05, bloom=0.45, stars=1800},
	}
	local function findStyle(name)
		for _, style in ipairs(styles) do
			if style.name == name then return style end
		end
		return styles[1]
	end
	local function clearSky()
		for _, name in ipairs({"GalaxySky", "PrimeColorSky", "PrimeSkyTint", "PrimeSkyAtmosphere", "PrimeSkyBloom"}) do
			local object = Lighting:FindFirstChild(name)
			if object then object:Destroy() end
		end
	end
	local function apply(styleName)
  local style = findStyle(styleName); clearSky()
		State.skyStyle = style.name
		State.darkModeEnabled = style.name ~= "Off"
		if style.name == "Off" then
			Lighting.Brightness = defaults.Brightness
			Lighting.ClockTime = defaults.ClockTime
			Lighting.ExposureCompensation = defaults.ExposureCompensation
			Lighting.OutdoorAmbient = defaults.OutdoorAmbient
			Lighting.Ambient = defaults.Ambient
			Lighting.FogColor = defaults.FogColor
			return style.name
		end
  local sky = Instance.new("Sky"); sky.Name = "PrimeColorSky"; sky.SkyboxBk = "rbxassetid://159454299"; sky.SkyboxDn = "rbxassetid://159454296"
  sky.SkyboxFt = "rbxassetid://159454293"; sky.SkyboxLf = "rbxassetid://159454286"; sky.SkyboxRt = "rbxassetid://159454289"; sky.SkyboxUp = "rbxassetid://159454291"
		sky.StarCount = style.stars or 2000
		sky.Parent = Lighting
  local correction = Instance.new("ColorCorrectionEffect"); correction.Name = "PrimeSkyTint"
		correction.TintColor = style.tint
  correction.Brightness = 0.06; correction.Contrast = 0.08; correction.Saturation = 0.1
		correction.Parent = Lighting
  local atmosphere = Instance.new("Atmosphere"); atmosphere.Name = "PrimeSkyAtmosphere"
		atmosphere.Color = style.atmosphere
		atmosphere.Decay = style.decay
  atmosphere.Density = style.density or 0.28; atmosphere.Offset = 0.15; atmosphere.Glare = style.glare or 0.25; atmosphere.Haze = style.haze or 1
		atmosphere.Parent = Lighting
  local bloom = Instance.new("BloomEffect"); bloom.Name = "PrimeSkyBloom"; bloom.Intensity = style.bloom or 0.45; bloom.Size = 24
		bloom.Threshold = 1.2
		bloom.Parent = Lighting
  Lighting.Brightness = style.brightness or 2.4; Lighting.ClockTime = style.clock or 14; Lighting.ExposureCompensation = 0.25
		Lighting.OutdoorAmbient = style.ambient
  Lighting.Ambient = style.ambient:Lerp(Color3.fromRGB(76, 76, 76), 0.12); Lighting.FogColor = style.atmosphere:Lerp(Color3.fromRGB(76, 76, 76), 0.15)
		return style.name
	end
	local names = {}
	for _, style in ipairs(styles) do table.insert(names, style.name) end
	setSkySelectorVisual = rowCycleSelector("Performance", "Sky Color", names, State.skyStyle or "Off", function(styleName)
		apply(styleName)
	end)
	setSkyStyle = function(styleName)
		local applied = apply(styleName)
		if setSkySelectorVisual then setSkySelectorVisual(applied, false) end
		return applied
	end
	setDarkMode = function(on)
		return setSkyStyle(on and ((State.skyStyle and State.skyStyle ~= "Off") and State.skyStyle or "Galaxy") or "Off")
	end
end
setNoIntroToggle = rowToggle("Performance", "No Intro", "Desactiva la intro al volver a ejecutar", State.noIntro == true, function(on)
    State.noIntro = on == true
    State.introEnabled = not State.noIntro
    if State.requestConfigSave then State.requestConfigSave() else pcall(saveConfig) end
end)
makeSecHeader("Settings", "Interface & Binds")
buttonsSizeBox = rowInput("Settings", "Buttons Size", "0 = mínimo • 100 = máximo", State.buttonsSizeValue, function(v)
 local n = math.clamp(math.floor(v + 0.5), 0, 100); applyMobileButtonsSize(n)
	if buttonsSizeBox then buttonsSizeBox.Text = tostring(n) end
	if State.requestConfigSave then State.requestConfigSave() else pcall(saveConfig) end
end)
State._buttonsShapeSelectorVisual = rowCycleSelector(
	"Settings",
	"Buttons Shape",
	{"Circle", "Normal", "Square", "Rectangle"},
	State.buttonsShape,
	function(shapeName)
		applyMobileButtonsShape(shapeName)
	end
)
rowKBOnly("Settings", "Hide / Show GUI", nil, KB.GuiHide, function(k) KB.GuiHide.kb=k end)
setHideButtonsVisual = rowToggle("Settings", "Hide Buttons", "Oculta todos los botones flotantes", false, function(on)
	State.hideButtonsEnabled = on
	local visible = not on
	if MobilePanel then MobilePanel.Visible = visible end
	for _, mobileBtn in pairs(mobileButtonsByName) do
		if mobileBtn and mobileBtn.Parent then
			mobileBtn.Visible = visible
		end
	end
	if State.requestConfigSave then State.requestConfigSave() else pcall(saveConfig) end
end)
setLockUIVisual = rowToggle("Settings", "Lock UI", nil, false, function(on)
	uiLocked = on
	_G.AceGuiLocked = on and true or false
	if State.requestConfigSave then State.requestConfigSave() else pcall(saveConfig) end
end)
local saveBtn; saveBtn = rowActionBtn("Settings", "Save Config", function()
    if type(saveConfig) ~= "function" then
        if saveBtn and saveBtn.Parent then saveBtn.Text = "Failed!" end
        warn("[ZeyHubb SAVE CONFIG] saveConfig is not ready")
        return
    end
    saveBtn.Text = "Saving..."
    task.spawn(function()
        local deadline = os.clock() + 12
        while State._configLoading and os.clock() < deadline do task.wait(0.1) end
        -- Never block a manual save just because the previous config was
        -- missing/corrupt. The current in-memory settings are what we save.
        State._configLoaded = true
        State._configDirty = true
        local ok, saved = pcall(saveConfig, saveBtn)
        if not ok then
            State._lastSaveError = tostring(saved)
            saved = false
        end
        if not saved then
            warn("[ZeyHubb SAVE CONFIG] " .. tostring(State._lastSaveError or "unknown error"))
        end
    end)
end)
rowActionBtn("Settings", "Reset Mobile Buttons", function()
    if resetMobileButtons then resetMobileButtons() end
end)
end

-- ===== Sistema de Temas (Preto/Vermelho  x  Branco/Rosa estilo bloyd.vs) =====
local THEME_IMAGE = { GrayBlack = "139833886423731", WhitePink = "139833886423731" }
local _themeProps = {"BackgroundColor3","TextColor3","ImageColor3","PlaceholderColor3","ScrollBarImageColor3","Color","TextStrokeColor3"}
local _isTextProp = { TextColor3 = true, PlaceholderColor3 = true, TextStrokeColor3 = true }
local function _ckey(c) return math.floor(c.R*255+0.5) .. "," .. math.floor(c.G*255+0.5) .. "," .. math.floor(c.B*255+0.5) end
local PK = {
	BG     = Color3.fromRGB(255, 255, 255),
	PANEL  = Color3.fromRGB(255, 250, 252),
	BLOCK  = Color3.fromRGB(253, 245, 249),
	ROW    = Color3.fromRGB(252, 237, 245),
	ROWH   = Color3.fromRGB(250, 222, 236),
	BORDER = Color3.fromRGB(248, 196, 220),
	HEADER = Color3.fromRGB(255, 240, 247),
	PINK   = Color3.fromRGB(255, 105, 180),
	PINK_L = Color3.fromRGB(255, 170, 210),
	PINK_D = Color3.fromRGB(210, 55, 135),
	ACCENT = Color3.fromRGB(235, 70, 155),
	TEXT   = Color3.fromRGB(60, 18, 38),
	DIM    = Color3.fromRGB(148, 148, 148),
	BLBL   = Color3.fromRGB(135, 65, 95),
}
local function _mapColor(prop, c)
	local r, g, b = c.R*255, c.G*255, c.B*255
	local mx, mn = math.max(r, g, b), math.min(r, g, b)
	local isGrey = (mx - mn) <= 14
	local isRed  = (r >= g and r >= b) and (r - math.max(g, b)) >= 30
	if not (isGrey or isRed) then return nil end
	local v = isGrey and mx or r
	if _isTextProp[prop] then
		if isGrey and mx >= 235 then return nil end
		if v >= 225 then return PK.TEXT
		elseif v >= 170 then return PK.ACCENT
		elseif v >= 110 then return PK.DIM
		else return PK.BLBL end
	end
	if v <= 3 then return PK.BG
	elseif v <= 18 then return PK.PANEL
	elseif v <= 34 then return PK.BLOCK
	elseif v <= 55 then return PK.ROW
	elseif v <= 95 then return PK.ROWH
	elseif v <= 165 then return PK.BORDER
	elseif v <= 215 then return PK.PINK_L
	elseif isGrey then return PK.HEADER
	else return PK.PINK end
end
local _fwd, _rev = {}, {}
local function _pinkFor(prop, c)
	local k = _ckey(c)
	_fwd[prop] = _fwd[prop] or {}
	_rev[prop] = _rev[prop] or {}
	if _rev[prop][k] ~= nil then return nil end
	local cached = _fwd[prop][k]
	if cached == nil then
		local m = _mapColor(prop, c)
		if m == nil then
			_fwd[prop][k] = false
		else
			_fwd[prop][k] = m
			_rev[prop][_ckey(m)] = c
		end
		cached = _fwd[prop][k]
	end
	if cached == false then return nil end
	return cached
end
local function _baseFor(prop, c)
	local t = _rev[prop]
	if not t then return nil end
	return t[_ckey(c)]
end
local function _seqMap(seq, pink)
	local kps, changed = {}, false
	for _, kp in ipairs(seq.Keypoints) do
		local col = kp.Value
		if pink then
			local m = _pinkFor("BackgroundColor3", col)
			if m then col = m; changed = true end
		else
			local base = _baseFor("BackgroundColor3", col)
			if base then col = base; changed = true end
		end
		table.insert(kps, ColorSequenceKeypoint.new(kp.Time, col))
	end
	if not changed then return nil end
	return ColorSequence.new(kps)
end
local function _themeObject(obj, pink)
	if obj:IsA("UIGradient") then
		local ok, seq = pcall(function() return obj.Color end)
		if ok and typeof(seq) == "ColorSequence" then
			local ns = _seqMap(seq, pink)
			if ns then pcall(function() obj.Color = ns end) end
		end
		return
	end
	for _, prop in ipairs(_themeProps) do
		local ok, val = pcall(function() return obj[prop] end)
		if ok and typeof(val) == "Color3" then
			if pink then
				local m = _pinkFor(prop, val)
				if m then pcall(function() obj[prop] = m end) end
			else
				local base = _baseFor(prop, val)
				if base then pcall(function() obj[prop] = base end) end
			end
		end
	end
end
State.themeRoots = State.themeRoots or {}
State.registerThemeRoot = function(root)
	if not root then return end
	for _, r in ipairs(State.themeRoots) do if r == root then return end end
	table.insert(State.themeRoots, root)
	root.DescendantAdded:Connect(function(obj)
		if State.theme == "WhitePink" then task.defer(function() _themeObject(obj, true) end) end
	end)
	if State.theme == "WhitePink" then
		_themeObject(root, true)
		for _, obj in ipairs(root:GetDescendants()) do _themeObject(obj, true) end
	end
end
State.applyTheme = function(name, shouldSave)
	if name ~= "WhitePink" then name = "GrayBlack" end
	State.theme = name
	local pink = (name == "WhitePink")
	for _, root in ipairs(State.themeRoots) do
		if root and root.Parent then
			_themeObject(root, pink)
			for _, obj in ipairs(root:GetDescendants()) do _themeObject(obj, pink) end
		end
	end
	if State.applyBackgroundImage then State.applyBackgroundImage(THEME_IMAGE[name], false) end
	if State.themeVisuals then
		for themeName, v in pairs(State.themeVisuals) do
			local sel = (themeName == name)
			if v.stroke then v.stroke.Thickness = sel and 2.4 or 1 end
			if v.check then v.check.Text = sel and "SELECIONADO" or "" end
		end
	end
	if shouldSave and State.requestConfigSave then State.requestConfigSave() end
end
State.registerThemeRoot(gui)
-- Theme is applied once and to newly-created descendants only.
-- Do not repeatedly recolor the entire UI: that caused flicker and visual bugs.


State.buildBackgroundPage = function()
 makeSecHeader("Background", "Theme"); State.themeVisuals = {}
 do
  local themeDefs = { {key="WhitePink", label="Branco & Rosa"} }
  for _, def in ipairs(themeDefs) do
   local card = baseCard("Background", 40)
   local btn = Instance.new("TextButton", card); btn.AutoButtonColor = false; btn.Size = UDim2.new(1, -20, 1, -10); btn.Position = UDim2.new(0, 10, 0, 5)
   btn.BackgroundColor3 = CARD_HOV; btn.BorderSizePixel = 0; btn.Text = def.label; btn.TextColor3 = WHITE; btn.Font = Enum.Font.GothamBold; btn.TextSize = 11; btn.ZIndex = 7
   Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)
   local st = Instance.new("UIStroke", btn); st.Color = BORDER; st.Thickness = 1
   local check = Instance.new("TextLabel", btn); check.AnchorPoint = Vector2.new(1, 0.5); check.Position = UDim2.new(1, -10, 0.5, 0); check.Size = UDim2.new(0, 90, 1, 0)
   check.BackgroundTransparency = 1; check.Text = ""; check.TextColor3 = WHITE; check.Font = Enum.Font.GothamBlack; check.TextSize = 9; check.TextXAlignment = Enum.TextXAlignment.Right; check.ZIndex = 8
   State.themeVisuals[def.key] = {stroke = st, check = check}
   btn.Activated:Connect(function() State.applyTheme(def.key, true) end)
  end
 end
 makeSecHeader("Background", "Background Images"); local infoCard = baseCard("Background", 46); cLabel(infoCard, "Choose a background", 10, 250, 11, WHITE, Enum.Font.GothamBold); local infoSub = cLabel(infoCard, "Tap an image to apply and save it", 10, 280, 9, DIM, Enum.Font.Gotham)
 infoSub.Size = UDim2.new(1, -20, 0, 14); infoSub.Position = UDim2.new(0, 10, 0, 25); local grid = Instance.new("Frame", pg("Background")); grid.Name = "BackgroundImageGrid"
 grid.Size = UDim2.new(1, -4, 0, 266); grid.BackgroundTransparency = 1; grid.BorderSizePixel = 0; grid.ClipsDescendants = true
 grid.LayoutOrder = lo("Background"); grid.ZIndex = 4; local layout = Instance.new("UIGridLayout", grid)
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	layout.FillDirection = Enum.FillDirection.Horizontal
 layout.FillDirectionMaxCells = 2; layout.CellSize = UDim2.new(0.5, -5, 0, 80); layout.CellPadding = UDim2.new(0, 8, 0, 8)
	layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	layout.VerticalAlignment = Enum.VerticalAlignment.Top
	for index, assetId in ipairs(State.backgroundAssetIds) do
  local thumb = Instance.new("ImageButton", grid); thumb.Name = "BackgroundImage" .. tostring(index)
		thumb.LayoutOrder = index
  thumb.BackgroundColor3 = Color3.fromRGB(255, 105, 180); thumb.BackgroundTransparency = 0.05; thumb.BorderSizePixel = 0; thumb.AutoButtonColor = false
		thumb.ClipsDescendants = true
		thumb.Image = "rbxassetid://" .. assetId
		thumb.ImageTransparency = 0.08
		thumb.ScaleType = Enum.ScaleType.Crop
  thumb.ZIndex = 6; Instance.new("UICorner", thumb).CornerRadius = UDim.new(0, 12); local thumbStroke = Instance.new("UIStroke", thumb)
		thumbStroke.Color = BORDER
  thumbStroke.Thickness = 1; local badge = Instance.new("TextLabel", thumb); badge.AnchorPoint = Vector2.new(1, 1); badge.Size = UDim2.new(0, 28, 0, 18)
  badge.Position = UDim2.new(1, -5, 1, -5); badge.BackgroundColor3 = Color3.fromRGB(255, 105, 180); badge.BackgroundTransparency = 0.08; badge.BorderSizePixel = 0
		badge.Text = tostring(index)
		badge.TextColor3 = WHITE
		badge.Font = Enum.Font.GothamBlack
  badge.TextSize = 9; badge.ZIndex = 8; Instance.new("UICorner", badge).CornerRadius = UDim.new(1, 0); State.imageChoiceVisuals[assetId] = {stroke=thumbStroke, badge=badge, index=index}
		thumb.Activated:Connect(function()
			State.applyBackgroundImage(assetId, true)
		end)
	end
	State.applyBackgroundImage(State.backgroundAssetId, false)
end
State.buildBackgroundPage(); State.buildBackgroundPage = nil
State.applyTheme("WhitePink", false)
do
 local BTN_SIZE = 28; local BTN_GAP  = 12; local PADDING  = 6; MobilePanel = Instance.new("Frame")
 MobilePanel.Name = "MobileButtonsPanel"; MobilePanel.Size = UDim2.new(0, PADDING * 2 + 3 * BTN_SIZE + 2 * BTN_GAP, 0, PADDING * 2 + 4 * BTN_SIZE + 3 * BTN_GAP); MobilePanel.Position = UDim2.new(1, -140, 0, 10); MobilePanel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
 MobilePanel.BackgroundTransparency = 1; MobilePanel.BorderSizePixel = 0; MobilePanel.ZIndex = 95
	MobilePanel.Parent = gui
 local Q_OFF      = Color3.fromRGB(18, 18, 18); local Q_ON       = Color3.fromRGB(255, 105, 180); local Q_TEXT_OFF = Color3.fromRGB(255, 255, 255); State._purpleAnimatedButtons = State._purpleAnimatedButtons or {}
	State._purpleAnimationPeriod = 5.5
	local redTextPalette = {
		Color3.fromRGB(60, 60, 60),
		Color3.fromRGB(76, 76, 76),
		Color3.fromRGB(54, 54, 54),
		Color3.fromRGB(36, 36, 36),
		Color3.fromRGB(66, 66, 66),
		Color3.fromRGB(106, 106, 106),
	}
	local function paletteColor(palette, progress)
		local count = #palette
		if count == 0 then return Color3.fromRGB(76, 76, 76) end
		if count == 1 then return palette[1] end
		progress = progress % 1
		local scaled = progress * count
  local index = math.floor(scaled) + 1; local nextIndex = (index % count) + 1; local alpha = scaled - math.floor(scaled); alpha = alpha * alpha * (3 - 2 * alpha)
		return palette[index]:Lerp(palette[nextIndex], alpha)
	end
	State._registerPurpleAnimatedButton = function(button)
		if not button then return end
  button:SetAttribute("PurpleActive", false); button:SetAttribute("PurpleFlash", false)
		button.BackgroundColor3 = Q_OFF
		button.TextColor3 = Q_TEXT_OFF
		State._purpleAnimatedButtons[button] = {
			background = button.BackgroundColor3,
			text = button.TextColor3,
		}
	end
	if not State._purpleAnimationStarted then
		State._purpleAnimationStarted = true
		task.spawn(function()
			local lastClock = os.clock()
			while gui and gui.Parent do
    local now = os.clock(); local dt = math.min(now - lastClock, 0.1)
				lastClock = now
    local progress = (now / State._purpleAnimationPeriod) % 1; local blend = 1 - math.exp(-dt * 8)
				for button, visual in pairs(State._purpleAnimatedButtons) do
					if button and button.Parent then
      local active = button:GetAttribute("PurpleActive") == true; local flash = button:GetAttribute("PurpleFlash") == true
						local targetBackground
						local targetText
						if active or flash then
                            targetBackground = Color3.fromRGB(255, 105, 180)
                            targetText = Color3.fromRGB(255, 255, 255)
                        else
							targetBackground = Q_OFF
							targetText = Q_TEXT_OFF
						end
      visual.background = visual.background:Lerp(targetBackground, blend); visual.text = visual.text:Lerp(targetText, blend)
						button.BackgroundColor3 = visual.background
						button.TextColor3 = Color3.fromRGB(255, 255, 255)
					else
						State._purpleAnimatedButtons[button] = nil
					end
				end
				RunService.RenderStepped:Wait()
			end
		end)
	end
 State._blueShineLabels = State._blueShineLabels or {}; State._blueShineGradients = State._blueShineGradients or {}
	local function attachBlueTextShine(button)
		if not button or button:FindFirstChild("BlueTextShine") then return end
  button.TextTransparency = 1; local shineText = Instance.new("TextLabel"); shineText.Name = "BlueTextShine"; shineText.BackgroundTransparency = 1
  shineText.BorderSizePixel = 0; shineText.Size = UDim2.fromScale(1, 1); shineText.Position = UDim2.fromScale(0, 0)
		shineText.Text = button.Text
  shineText.TextColor3 = Color3.fromRGB(255, 255, 255); shineText.TextTransparency = 0
		shineText.TextScaled = button.TextScaled
		shineText.TextSize = button.TextSize
		shineText.Font = button.Font
		shineText.TextWrapped = button.TextWrapped
		shineText.LineHeight = button.LineHeight
		shineText.TextXAlignment = button.TextXAlignment
		shineText.TextYAlignment = button.TextYAlignment
  shineText.ZIndex = button.ZIndex + 1; shineText.Active = false; shineText.Selectable = false
		shineText.Parent = button
  local shineGradient = Instance.new("UIGradient"); shineGradient.Name = "CleanBlueShine"; shineGradient.Rotation = 0; shineGradient.Offset = Vector2.new(-1.25, 0)
		shineGradient.Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 255, 255)),
			ColorSequenceKeypoint.new(0.38, Color3.fromRGB(255, 255, 255)),
			ColorSequenceKeypoint.new(0.50, Color3.fromRGB(255, 255, 255)),
			ColorSequenceKeypoint.new(0.62, Color3.fromRGB(255, 255, 255)),
			ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 255, 255)),
		})
		shineGradient.Parent = shineText
		State._blueShineLabels[button] = shineText
		State._blueShineGradients[button] = shineGradient
		button:GetPropertyChangedSignal("Text"):Connect(function()
			if shineText.Parent then shineText.Text = button.Text end
		end)
		button:GetPropertyChangedSignal("Visible"):Connect(function()
			if shineText.Parent then shineText.Visible = button.Visible end
		end)
		button:GetPropertyChangedSignal("TextSize"):Connect(function()
			if shineText.Parent then shineText.TextSize = button.TextSize end
		end)
		button:GetPropertyChangedSignal("ZIndex"):Connect(function()
			if shineText.Parent then shineText.ZIndex = button.ZIndex + 1 end
		end)
	end
	if not State._blueShineSequenceStarted then
		State._blueShineSequenceStarted = true
		task.spawn(function()
			while gui and gui.Parent do
				local animatedAny = false
				for button, gradient in pairs(State._blueShineGradients) do
					if not (gui and gui.Parent) then break end
					if button and button.Parent and gradient and gradient.Parent and button.Visible then
      animatedAny = true; gradient.Offset = Vector2.new(-1.25, 0)
						local tween = TweenService:Create(
							gradient,
							TweenInfo.new(1.45, Enum.EasingStyle.Linear, Enum.EasingDirection.Out),
							{Offset = Vector2.new(1.25, 0)}
						)
      tween:Play(); tween.Completed:Wait(); task.wait(0.06)
					elseif button and not button.Parent then
      State._blueShineLabels[button] = nil; State._blueShineGradients[button] = nil
					end
				end
				if not animatedAny then task.wait(0.5) else task.wait(0.8) end
			end
		end)
	end
	
local function addActiveBadge(button)
    if not button or button:FindFirstChild("ZeyHubbActiveBadge") then return end
    local badge = Instance.new("TextLabel")
    badge.Name = "ZeyHubbActiveBadge"
    badge.AnchorPoint = Vector2.new(1, 0)
    badge.Position = UDim2.new(1, -2, 0, 2)
    badge.Size = UDim2.new(0, 24, 0, 14)
    badge.BackgroundColor3 = Color3.fromRGB(255, 105, 180)
    badge.BackgroundTransparency = 0.05
    badge.BorderSizePixel = 0
    badge.Text = "ON"
    badge.TextColor3 = Color3.fromRGB(255, 255, 255)
    badge.TextSize = 8
    badge.Font = Enum.Font.GothamBold
    badge.Visible = false
    badge.ZIndex = button.ZIndex + 5
    badge.Parent = button
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 5)
    c.Parent = badge
    button:GetAttributeChangedSignal("PurpleActive"):Connect(function()
        badge.Visible = button:GetAttribute("PurpleActive") == true
    end)
end

local function createMobileButton(name, displayText, col, row, isToggle, onAction)
  local xPos = PADDING + col * (BTN_SIZE + BTN_GAP); local yPos = PADDING + row * (BTN_SIZE + BTN_GAP); local btn = Instance.new("TextButton")
		btn.Name = "Btn_" .. name
  btn.Size = UDim2.new(0, BTN_SIZE, 0, BTN_SIZE); local defaultPos = UDim2.new(1, -140 + xPos, 0, 10 + yPos)
		btn.Position = defaultPos
		btn.BackgroundColor3 = Q_OFF
		btn.Text = displayText
		btn.TextColor3 = Q_TEXT_OFF
		btn.TextScaled = false; btn.TextSize = 11
		btn.Font = Enum.Font.GothamBold
  btn.TextWrapped = true; btn.LineHeight = 1.2; btn.BorderSizePixel = 0; btn.AutoButtonColor = false; btn.Active = true; btn.Selectable = false; btn.ZIndex = 99
		btn.Parent = gui

        -- Photo de l'UI comme fond des boutons
        local buttonImage = Instance.new("ImageLabel")
        buttonImage.Name = "UIPhoto"
        buttonImage.BackgroundTransparency = 1
        buttonImage.BorderSizePixel = 0
        buttonImage.Size = UDim2.fromScale(1, 1)
        buttonImage.Position = UDim2.fromScale(0, 0)
        buttonImage.Image = "rbxassetid://139833886423731"
        buttonImage.ImageTransparency = 0.18
        buttonImage.ScaleType = Enum.ScaleType.Crop
        buttonImage.ZIndex = btn.ZIndex
        buttonImage.Active = false
        buttonImage.Parent = btn
        local photoStroke = Instance.new("UIStroke")
        photoStroke.Name = "UIPhotoStroke"
        photoStroke.Color = Color3.fromRGB(255, 105, 180)
        photoStroke.Thickness = 2
        photoStroke.Transparency = 0.05
        photoStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        photoStroke.Parent = btn


        local imageCorner = Instance.new("UICorner")
        imageCorner.CornerRadius = UDim.new(0, 10)
        imageCorner.Parent = buttonImage

  State._registerPurpleAnimatedButton(btn); attachBlueTextShine(btn); addActiveBadge(btn)
		mobileButtonsByName[name] = btn
		mobileButtonDefaultPositions[name] = defaultPos
		makeDraggable(btn)
		btn.InputEnded:Connect(function(inp)
			if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
				if State.requestConfigSave then State.requestConfigSave() end
			end
		end)
  Instance.new("UICorner", btn).Name = "ButtonShapeCorner"; local mobileStroke = Instance.new("UIStroke"); mobileStroke.Name = "BlueOuterStroke"
		mobileStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
  mobileStroke.Color = Color3.fromRGB(255, 105, 180); mobileStroke.Thickness = 0.9; mobileStroke.Transparency = 0.22
		mobileStroke.LineJoinMode = Enum.LineJoinMode.Round
		mobileStroke.Parent = btn
  applyMobileButtonsSize(State.buttonsSizeValue); local isOn = false
		local function setter(s)
			isOn = s
			btn:SetAttribute("PurpleActive", s == true)
		end
		local function flash()
			btn:SetAttribute("PurpleFlash", true)
			task.delay(0.35, function()
    if btn and btn.Parent then btn:SetAttribute("PurpleFlash", false) end
			end)
		end
		btn.Activated:Connect(function()
			if isToggle then
				isOn = not isOn; setter(isOn)
				if onAction then onAction(isOn) end
			else
				flash()
				if onAction then onAction() end
			end
			if State.requestConfigSave then State.requestConfigSave() end
		end)
		return btn, setter
	end
	createMobileButton("Drop", "DROP\nBR", 0, 0, false, function() task.spawn(runDrop) end)
 
	resetMobileButtons = function()
		for name, btn in pairs(mobileButtonsByName) do
			local defaultPos = mobileButtonDefaultPositions[name]
			if btn and defaultPos then btn.Position = defaultPos end
		end
		if State.requestPositionSave then State.requestPositionSave() end
		if State.requestConfigSave then State.requestConfigSave() end
	end
	do
		local setter = select(2, createMobileButton("AutoLeft", "AUTO\nLEFT", 1, 0, true, function(on)
			State.autoLeftEnabled = on
			if on then
				if State.autoRightEnabled then State.autoRightEnabled=false; if autoRightSetVisual then autoRightSetVisual(false) end; stopAutoRight() end
				if State.autoBatToggled then State.autoBatToggled=false; if autoBatSetVisual then autoBatSetVisual(false) end; stopBatAimbot() end
				if State.autoBatV2Enabled then
					State.autoBatV2Enabled = false
					if autoBatV2SetVisual then autoBatV2SetVisual(false) end
					if mobileBatV2SetActive then mobileBatV2SetActive(false) end
					stopBatAimbotV2()
				end
				local char = LP.Character
    local hum = char and char:FindFirstChild("Humanoid"); local root = char and char:FindFirstChild("HumanoidRootPart")
				if hum and root and hum.WalkSpeed > 0 and not root.Anchored then startAutoLeft() end
			else
				stopAutoLeft()
			end
		end))
		local previous = autoLeftSetVisual
		autoLeftSetVisual = function(on)
			setter(on)
			if previous then previous(on) end
		end
		mobileAutoLeftSetActive = function(on) autoLeftSetVisual(on) end
		if mobileBtnActive then mobileBtnActive.AutoLeft = setter end
	end
	do
		local setter = select(2, createMobileButton("AutoBat", "BAT\nAIMBOT", 0, 1, true, function(on)
			State.autoBatToggled = on
			if on then
				if State.autoLeftEnabled then State.autoLeftEnabled=false; if autoLeftSetVisual then autoLeftSetVisual(false) end; stopAutoLeft() end
				if State.autoRightEnabled then State.autoRightEnabled=false; if autoRightSetVisual then autoRightSetVisual(false) end; stopAutoRight() end
				if State._batV2On then
     State._batV2On = false; State._setBatV2Visual(false); State.autoBatV2Enabled = false
					if autoBatV2SetVisual then autoBatV2SetVisual(false) end
					if stopBatAimbotV2 then stopBatAimbotV2() end
				end
				startBatAimbot()
			else
				stopBatAimbot()
			end
		end))
		local previous = autoBatSetVisual
		autoBatSetVisual = function(on)
			setter(on)
			if previous then previous(on) end
		end
		mobileBatV1SetActive = function(on) autoBatSetVisual(on) end
		if mobileBtnActive then mobileBtnActive.AutoBat = setter end
	end
	do
		local setter = select(2, createMobileButton("AutoRight", "AUTO\nRIGHT", 1, 1, true, function(on)
			State.autoRightEnabled = on
			if on then
				if State.autoLeftEnabled then State.autoLeftEnabled=false; if autoLeftSetVisual then autoLeftSetVisual(false) end; stopAutoLeft() end
				if State.autoBatToggled then State.autoBatToggled=false; if autoBatSetVisual then autoBatSetVisual(false) end; stopBatAimbot() end
				if State.autoBatV2Enabled then
					State.autoBatV2Enabled = false
					if autoBatV2SetVisual then autoBatV2SetVisual(false) end
					if mobileBatV2SetActive then mobileBatV2SetActive(false) end
					stopBatAimbotV2()
				end
				local char = LP.Character
    local hum = char and char:FindFirstChild("Humanoid"); local root = char and char:FindFirstChild("HumanoidRootPart")
				if hum and root and hum.WalkSpeed > 0 and not root.Anchored then startAutoRight() end
			else
				stopAutoRight()
			end
		end))
		local previous = autoRightSetVisual
		autoRightSetVisual = function(on)
			setter(on)
			if previous then previous(on) end
		end
		mobileAutoRightSetActive = function(on) autoRightSetVisual(on) end
		if mobileBtnActive then mobileBtnActive.AutoRight = setter end
	end
	createMobileButton("TPDown", "TP\nDOWN", 0, 2, false, function() task.spawn(runTPDown) end)
	State._tpBatButton, State._tpBatSetter = createMobileButton("TPBat", "TP\nBAT", 0, 4, true, function(on)
		State._setTPBatEnabled(on)
		if State._tpBatConfigSetVisual then State._tpBatConfigSetVisual(on) end
		if State._updateTPBatButtonText then State._updateTPBatButtonText() end
	end)
	State._updateTPBatButtonText = function()
		local btn = State._tpBatButton
		if not btn or not btn.Parent then return end
		btn.Text = "TP\nBAT " .. ((State.tpBatVersion == 2) and "2" or "1")
	end
	State._tpBatSetVisual = function(on)
		State._setTPBatEnabled(on)
		if State._tpBatSetter then State._tpBatSetter(on) end
		if State._tpBatConfigSetVisual then State._tpBatConfigSetVisual(on) end
		if State._updateTPBatButtonText then State._updateTPBatButtonText() end
	end
	State._updateTPBatButtonText()
	local function _forceWalkSpeed(v)
		pcall(function()
			local c = LP.Character
			local hum2 = c and c:FindFirstChildOfClass("Humanoid")
			if hum2 and v and v > 0 then hum2.WalkSpeed = v end
		end)
	end
	do
		local setter
		local _, s = createMobileButton("Speed", "CARRY\nSPD", 1, 2, true, function(on)
			State.speedToggled = on and true or false
			if on then
    State.laggerToggled = false; laggerPhase = 0
				if mobileLaggerSetActive then mobileLaggerSetActive(false) end
				_forceWalkSpeed(getProfileCarrySpeed())
				if modeValLbl then modeValLbl.Text = State.speedProfile == "Lagger" and ("Carry · " .. tostring(State.profileLaggerCarrySpeed)) or "Carry" end
				task.defer(function() if setter then setter(true) end end)
			else
				_forceWalkSpeed(getProfileNormalSpeed())
				if modeValLbl then modeValLbl.Text = State.speedProfile == "Lagger" and ("Lagger · " .. tostring(State.profileLaggerNormalSpeed)) or "Normal" end
			end
		end)
		setter = s
		mobileSpeedSetActive = function(on) if setter then setter(on) end end
	end
	do
		local set1, set2
		local _, s1 = createMobileButton("Lagger", "LAGGER\n1", 0, 3, true, function(on)
			if on then
    State.laggerToggled = true; laggerPhase = 1; State.speedToggled = false
				if mobileSpeedSetActive then mobileSpeedSetActive(false) end
				if set2 then set2(false) end
				_forceWalkSpeed(LS)
				if modeValLbl then modeValLbl.Text = "Lagger 1" end
				task.defer(function() if set1 then set1(true) end end)
			else
    State.laggerToggled = false; laggerPhase = 0; _forceWalkSpeed(getProfileNormalSpeed())
				if modeValLbl then modeValLbl.Text = State.speedProfile == "Lagger" and ("Lagger · " .. tostring(State.profileLaggerNormalSpeed)) or "Normal" end
			end
		end)
		set1 = s1
		local _, s2 = createMobileButton("Lagger2", "LAGGER\n2", 1, 3, true, function(on)
			if on then
    State.laggerToggled = true; laggerPhase = 2; State.speedToggled = false
				if mobileSpeedSetActive then mobileSpeedSetActive(false) end
				if set1 then set1(false) end
				_forceWalkSpeed(LS2)
				if modeValLbl then modeValLbl.Text = "Lagger 2" end
				task.defer(function() if set2 then set2(true) end end)
			else
    State.laggerToggled = false; laggerPhase = 0; _forceWalkSpeed(getProfileNormalSpeed())
				if modeValLbl then modeValLbl.Text = State.speedProfile == "Lagger" and ("Lagger · " .. tostring(State.profileLaggerNormalSpeed)) or "Normal" end
			end
		end)
		set2 = s2
		mobileLaggerSetActive = function(on)
			if on then
				State.laggerToggled = true
				if laggerPhase ~= 2 then laggerPhase = 1 end
				if laggerPhase == 2 then
					if set1 then set1(false) end
					if set2 then set2(true) end
					_forceWalkSpeed(LS2)
				else
					if set2 then set2(false) end
					if set1 then set1(true) end
					_forceWalkSpeed(LS)
				end
			else
    laggerPhase = 0; State.laggerToggled = false
				if set1 then set1(false) end
				if set2 then set2(false) end
			end
		end
	end
	do
  local wasFrozen = false; local _frozenLastCheck = 0
		RunService.Heartbeat:Connect(function()
		local _now = os.clock()
		if _now - _frozenLastCheck < 0.12 then return end
		_frozenLastCheck = _now
		local char = LP.Character
		if not char then return end
  local hrp = char:FindFirstChild("HumanoidRootPart"); local hum = char:FindFirstChild("Humanoid")
		if not hrp or not hum then return end
		local isCurrentlyFrozen = hrp.Anchored or hum.WalkSpeed == 0
		if isCurrentlyFrozen then
			if State.autoBatV2Enabled or State._batV2On then
    State._batV2On = false; State._setBatV2Visual(false); State.autoBatV2Enabled = false
				if autoBatV2SetVisual then autoBatV2SetVisual(false) end
				if stopBatAimbotV2 then stopBatAimbotV2() end
			end
			if State.autoBatToggled then
				State.autoBatToggled = false
				if autoBatSetVisual then autoBatSetVisual(false) end
				stopBatAimbot()
			end
			if not wasFrozen then
				wasFrozen = true
				if State.autoLeftEnabled then stopAutoLeft() end
				if State.autoRightEnabled then stopAutoRight() end
			end
		else
			if wasFrozen then
				wasFrozen = false
				if State.autoLeftEnabled then startAutoLeft() end
				if State.autoRightEnabled then startAutoRight() end
			end
		end
		end)
	end
end
local Players = game:GetService("Players"); local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local ESP = {}
local function CreateESP(player)
    if player == LocalPlayer then return end
    if ESP[player] then return end
    local Line = Drawing.new("Line"); Line.Color = Color3.fromRGB(76, 76, 76); Line.Thickness = 0.1; Line.Transparency = 0.7
    Line.Visible = false; local Distance = Drawing.new("Text"); Distance.Color = Color3.fromRGB(60, 60, 60); Distance.Size = 11
    Distance.Center = true; Distance.Outline = true; Distance.Visible = false; ESP[player] = {Line, Distance}
end
for _, v in ipairs(Players:GetPlayers()) do CreateESP(v) end
Players.PlayerAdded:Connect(CreateESP)
Players.PlayerRemoving:Connect(function(player)
    if ESP[player] then
        for _, obj in ipairs(ESP[player]) do obj:Remove() end
        ESP[player] = nil
    end
    if player.Character then
        local hl = player.Character:FindFirstChild("HologramRed")
        if hl then hl:Destroy() end
    end
end)
RunService.RenderStepped:Connect(function()
    if not State.linieEnabled then
        if not State._espCleaned then
            State._espCleaned = true
            for player, objs in pairs(ESP) do
                local char = player.Character
                if char then
                    local hl = char:FindFirstChild("HologramRed")
                    if hl then hl:Destroy() end
                end
                for _, obj in ipairs(objs) do obj.Visible = false end
            end
        end
        return
    end
    State._espCleaned = false; local _now = os.clock()
    if _now - (State._espLastUpdate or 0) < 0.0222 then return end
    State._espLastUpdate = _now
    Camera = workspace.CurrentCamera
    if not Camera then return end
    local _camPos = Camera.CFrame.Position
    local _vp = Camera.ViewportSize
    local _fromX, _fromY = _vp.X / 2, _vp.Y
    for player, objs in pairs(ESP) do
        local char = player.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart"); local hum = char and char:FindFirstChildOfClass("Humanoid"); local head = char and char:FindFirstChild("Head")
        if hrp and hum and head and hum.Health > 0 then
            local pos, visible = Camera:WorldToViewportPoint(hrp.Position)
            local holo = char:FindFirstChild("HologramRed")
            if not holo then
                holo = Instance.new("Highlight"); holo.Name = "HologramRed"; holo.FillColor = Color3.fromRGB(24, 24, 24); holo.FillTransparency = 0.5
                holo.OutlineColor = Color3.fromRGB(76, 76, 76); holo.OutlineTransparency = 0.2
                holo.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                holo.Parent = char
            end
            if visible then
                local distance = math.floor((hrp.Position - _camPos).Magnitude); local headPos = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.5, 0)); local feetPos = Camera:WorldToViewportPoint(hrp.Position - Vector3.new(0, 3, 0)); local height = math.abs(headPos.Y - feetPos.Y)
                objs[1].Visible = true; objs[1].From = Vector2.new(_fromX, _fromY); objs[1].To = Vector2.new(pos.X, pos.Y); objs[2].Visible = true
                objs[2].Position = Vector2.new(pos.X, pos.Y - height / 2 - 16); objs[2].Text = distance .. " Studs"
            else
                for _, obj in ipairs(objs) do obj.Visible = false end
            end
        else
            if char then
                local hl = char:FindFirstChild("HologramRed")
                if hl then hl:Destroy() end
            end
            for _, obj in ipairs(objs) do obj.Visible = false end
        end
    end
end)
State._positionConfigFile = "ZEYHUBB_VS_POSITIONS.json"; State._positionBackupFile = "ZEYHUBB_VS_POSITIONS.backup.json"; State._positionTempFile = "ZEYHUBB_VS_POSITIONS.tmp.json"; State._positionSaveRequestId = 0
State._positionSnapshot = function(guiObject)
    if not guiObject then return nil end
    local ok, position = pcall(function() return guiObject.Position end)
    if not ok or not position then return nil end
    return {xs=position.X.Scale, xo=position.X.Offset, ys=position.Y.Scale, yo=position.Y.Offset}
end
State._restoreSavedPosition = function(guiObject, data)
    if not guiObject or type(data) ~= "table" or data.xs == nil then return end
    pcall(function()
        guiObject.Position = UDim2.new(
            tonumber(data.xs) or 0,
            tonumber(data.xo) or 0,
            tonumber(data.ys) or 0,
            tonumber(data.yo) or 0
        )
    end)
end
State.savePositionBackup = function()
    local buttonPositions = {}
    for name, button in pairs(mobileButtonsByName) do buttonPositions[name] = State._positionSnapshot(button) end
    local payload = {
        version = 2,
        mainPos = State._positionSnapshot(main),
        miniPos = State._positionSnapshot(mini),
        panelPos = State._positionSnapshot(MobilePanel),
        instaResetPos = State._positionSnapshot(btnInstaReset),
        mobileButtonPositions = buttonPositions,
    }
    local encodedOk, encoded = pcall(function() return HttpService:JSONEncode(payload) end)
    if not encodedOk then return false end
    if encoded == State._lastPositionJson then
        State._positionDirty = false
        return true
    end
    local saved, err = State._atomicJsonSave(
        State._positionConfigFile,
        State._positionBackupFile,
        State._positionTempFile,
        encoded
    )
    if saved then
        State._lastPositionJson = encoded
        State._positionDirty = false
    else
        State._lastSaveError = err
    end
    return saved
end
State.loadPositionBackup = function()
    local mainData, mainRaw = State._readValidJsonFile(State._positionConfigFile)
    local tempData, tempRaw = State._readValidJsonFile(State._positionTempFile)
    local backupData, backupRaw = State._readValidJsonFile(State._positionBackupFile)
    local data, raw, recovered = nil, nil, false
    if type(tempData) == "table" and (type(mainData) ~= "table" or tempRaw ~= mainRaw) then
        data, raw, recovered = tempData, tempRaw, true
    elseif type(mainData) == "table" then
        data, raw = mainData, mainRaw
    elseif type(backupData) == "table" then
        data, raw, recovered = backupData, backupRaw, true
    end
    if type(data) ~= "table" then return false end
    State._lastPositionJson = raw
    State._positionDirty = false
    local function apply()
        State._restoreSavedPosition(main, data.mainPos); State._restoreSavedPosition(mini, data.miniPos); State._restoreSavedPosition(MobilePanel, data.panelPos) State._restoreSavedPosition(btnInstaReset, data.instaResetPos)
        if type(data.mobileButtonPositions) == "table" then
            for name, positionData in pairs(data.mobileButtonPositions) do State._restoreSavedPosition(mobileButtonsByName[name], positionData) end
        end
    end
    apply(); task.delay(0.45, apply); task.delay(1.2, apply)
    if recovered and type(raw) == "string" then
        task.defer(function()
            State._atomicJsonSave(
                State._positionConfigFile,
                State._positionBackupFile,
                State._positionTempFile,
                raw
            )
        end)
    end
    return true
end
State.requestPositionSave = function()
    State._positionDirty = true; State._positionSaveRequestId = State._positionSaveRequestId + 1
    local requestId = State._positionSaveRequestId
    task.delay(0.55, function()
        if requestId ~= State._positionSaveRequestId then return end
        if not State._positionDirty then return end
        local ok, result = pcall(State.savePositionBackup)
        if not ok then State._lastSaveError = tostring(result) end
    end)
end
task.spawn(function()
    task.wait(0.15); pcall(State.loadPositionBackup)
end)
local LUST_BYPASS_AIMBOT_SPEED = 60; local BAT_V2_FOLLOW_DIST = 1.0; local BAT_V2_HEIGHT_OFFSET = 1.5; local BAT_V2_VERTICAL_OFFSET = 0.0
local BAT_V2_HIT_DIST = 4.5; local BAT_V2_SWING_COOLDOWN = 0.1; local bypassHittingCooldown = false
local function getClosestPlayerV2()
    local char = LP.Character
    if not char then return nil, math.huge end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return nil, math.huge end
    local closest, bestDistance = nil, math.huge
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LP and player.Character then
            local targetRoot = player.Character:FindFirstChild("HumanoidRootPart"); local targetHumanoid = player.Character:FindFirstChildOfClass("Humanoid")
            if targetRoot and targetHumanoid and targetHumanoid.Health > 0 then
                local distance = (root.Position - targetRoot.Position).Magnitude
                if distance < bestDistance then
                    bestDistance = distance
                    closest = player
                end
            end
        end
    end
    return closest, bestDistance
end
local function tryHitBypassBat()
    if bypassHittingCooldown then return end
    bypassHittingCooldown = true
    pcall(function()
        local char = LP.Character
        if not char then return end
        local currentTool = char:FindFirstChildOfClass("Tool")
        if currentTool and not isBatToolLust(currentTool) then
            bypassHittingCooldown = false
            return
        end
        local bat = findBat()
        if bat then
            if bat.Parent ~= char then
                local humanoid = char:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    pcall(function() humanoid:EquipTool(bat) end)
                end
            end
            local remote = bat:FindFirstChildOfClass("RemoteEvent")
            if remote then
                pcall(function() remote:FireServer() end)
            else
                pcall(function() bat:Activate() end)
            end
        end
    end)
    task.delay(BAT_V2_SWING_COOLDOWN, function()
        bypassHittingCooldown = false
    end)
    task.delay(0.2, function()
        if bypassHittingCooldown then bypassHittingCooldown = false end
    end)
end
startBatAimbotV2 = function()
    if Conns.aimbotV2 then return end
    State.autoBatV2Enabled = true
    Conns.aimbotV2 = RunService.Heartbeat:Connect(function()
        if not State.autoBatV2Enabled then return end
        local char = LP.Character
        if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart"); local humanoid = char:FindFirstChildOfClass("Humanoid")
        if not root or not humanoid or humanoid.Health <= 0 then return end
        local humanoidState = humanoid:GetState()
        if humanoidState == Enum.HumanoidStateType.Physics
            or humanoidState == Enum.HumanoidStateType.Ragdoll
            or humanoidState == Enum.HumanoidStateType.FallingDown then
            return
        end
        if not char:FindFirstChildOfClass("Tool") then
            local bat = findBat()
            if bat then
                pcall(function() humanoid:EquipTool(bat) end)
            end
        end
        local target = getClosestPlayerV2()
        if target and target.Character then
            local targetRoot = target.Character:FindFirstChild("HumanoidRootPart")
            if targetRoot then
                local targetVelocity = targetRoot.AssemblyLinearVelocity
                local movementDirection = targetVelocity.Magnitude > 0.1
                    and targetVelocity.Unit
                    or targetRoot.CFrame.LookVector
                local offset = movementDirection * BAT_V2_FOLLOW_DIST
                    + Vector3.new(0, BAT_V2_HEIGHT_OFFSET + BAT_V2_VERTICAL_OFFSET, 0)
                local desiredPosition = targetRoot.Position + offset
                local directionToTarget = desiredPosition - root.Position
                if directionToTarget.Magnitude > 0.5 then
                    local movementVector = directionToTarget.Unit * LUST_BYPASS_AIMBOT_SPEED
                    root.AssemblyLinearVelocity = Vector3.new(
                        movementVector.X,
                        movementVector.Y,
                        movementVector.Z
                    )
                else
                    root.AssemblyLinearVelocity = root.AssemblyLinearVelocity * 0.95
                    if root.AssemblyLinearVelocity.Magnitude < 1 then
                        root.AssemblyLinearVelocity = Vector3.zero
                    end
                end
                if State.autoSwingEnabled
                    and (root.Position - targetRoot.Position).Magnitude <= BAT_V2_HIT_DIST then
                    tryHitBypassBat()
                end
            end
        else
            root.AssemblyLinearVelocity = root.AssemblyLinearVelocity * 0.9
            if root.AssemblyLinearVelocity.Magnitude < 1 then
                root.AssemblyLinearVelocity = Vector3.zero
            end
        end
    end)
end
stopBatAimbotV2 = function()
    State.autoBatV2Enabled = false
    if Conns.aimbotV2 then
        Conns.aimbotV2:Disconnect(); Conns.aimbotV2 = nil
    end
    local char = LP.Character
    local root = char and char:FindFirstChild("HumanoidRootPart"); local humanoid = char and char:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.AutoRotate = true; humanoid.PlatformStand = false
        pcall(function()
            humanoid:ChangeState(Enum.HumanoidStateType.Running)
        end)
    end
    if root then
        root.AssemblyLinearVelocity = Vector3.new(0, -0.1, 0)
        root.AssemblyAngularVelocity = Vector3.zero
        pcall(function()
            if sethiddenproperty then sethiddenproperty(root, "PhysicsRepRootPart", nil) end
        end)
    end
    bypassHittingCooldown = false
    State.lastMoveDir = Vector3.zero
end
;(function()
local function _isfile(path)
    local checker = State._resolveFileFunction("isfile")
    if type(checker) == "function" then
        local ok, exists = pcall(checker, path)
        if ok then return exists == true end
    end
    local raw = State._safeReadFile(path)
    return type(raw) == "string"
end
local function _readfile(path)
    local raw, err = State._safeReadFile(path)
    if type(raw) ~= "string" then error(err or "readfile failed", 0) end
    return raw
end
local function _writefile(path, data)
    local ok, err = State._safeWriteFile(path, data)
    if not ok then error(err or "writefile failed", 0) end
    return true
end
local getconnections = getconnections or get_signal_cons or getconnects or (syn and syn.get_signal_cons)
local MOVE_KEYS={[Enum.KeyCode.W]=true,[Enum.KeyCode.A]=true,[Enum.KeyCode.S]=true,[Enum.KeyCode.D]=true,
    [Enum.KeyCode.Up]=true,[Enum.KeyCode.Left]=true,[Enum.KeyCode.Down]=true,[Enum.KeyCode.Right]=true}
local PLOT_CACHE_DURATION=2; local PROMPT_CACHE_REFRESH=0.15; local STEAL_COOLDOWN=0.1; local MEDUSA_COOLDOWN=25; local DROP_AUTO_OFF_DELAY=0.15; local CONFIG_FILE="ZEYHUBB_VS_CONFIG.json"; State._configTempFile="ZEYHUBB_VS_CONFIG.tmp.json"
State._legacyConfigFile="ZEYHUBB_LEGACY_CONFIG.json"; State._configBackupFile="ZEYHUBB_VS_CONFIG.backup.json"; State._legacyConfigBackupFile="ZEYHUBB_LEGACY_CONFIG.backup.json"; State._legacyConfigTempFile="ZEYHUBB_LEGACY_CONFIG.tmp.json"
State.autoLeftPhase=1; State.autoRightPhase=1; State.medusaLastUsed=0; State.medusaDebounce=false; State.medusaCounterEnabled=false; State.medusaResetEnabled=false; State.batAimbotToggled=false; State.autoSwingEnabled=false; State.hittingCooldown=false
State.batCounterEnabled=false; State.batCounterDebounce=false; State.dropEnabled=false; State._tpInProgress=false; State.lastMoveDir=Vector3.new(0,0,0); State._prevCarry=CS; State._prevSpeed=false
State.laggerEnabled=false; Conns.autoLeft=nil; Conns.autoRight=nil; Conns.aimbot=nil; Conns.batCounter=nil; Conns.unwalk=nil; local Presets={}
local PRESET_FILE="ZEYHUBB_PRESETS.json"; local LAST_PRESET_FILE="ZEYHUBB_LAST_PRESET.json"
local function loadPresetsFile()
    local hasFile=false; pcall(function() hasFile=_isfile(PRESET_FILE) end)
    if not hasFile then return end
    local raw; pcall(function() raw=_readfile(PRESET_FILE) end)
    if not raw then return end
    local ok,dec=pcall(function() return HttpService:JSONDecode(raw) end)
    if ok and dec then Presets=dec end
end
local function loadLastPresetName()
    local hasFile=false; pcall(function() hasFile=_isfile(LAST_PRESET_FILE) end)
    if not hasFile then return nil end
    local raw; pcall(function() raw=_readfile(LAST_PRESET_FILE) end)
    if not raw then return nil end
    local ok,dec=pcall(function() return HttpService:JSONDecode(raw) end)
    if ok and dec then return dec.lastPreset end; return nil
end
local function createRadiusPart()
 local p = Instance.new("Part"); p.Name = "MedusaRadius"; p.Anchored = true; p.CanCollide = false
	pcall(function() p.CanQuery = false end)
	p.Transparency = 1
	p.Material = Enum.Material.Neon
	p.Color = Color3.fromRGB(24, 24, 24)
	p.Shape = Enum.PartType.Cylinder
	p.Size = Vector3.new(0.2, MedusaConfig.Radius*2, MedusaConfig.Radius*2)
	p.Parent = workspace
	MedusaConfig.RadiusPart = p
end
local function isMedusaEquipped()
	local char = LP.Character
	if not char then return nil end
	for _, tool in ipairs(char:GetChildren()) do
		if tool:IsA("Tool") and tool.Name == "Medusa's Head" then
			return tool
		end
	end
	return nil
end
RunService.Heartbeat:Connect(function()
	if not MedusaConfig.Enabled then
  if MedusaConfig.RadiusPart and MedusaConfig.RadiusPart.Transparency ~= 1 then MedusaConfig.RadiusPart.Transparency = 1 end
		return
	end
	local _now = os.clock()
	if _now - (State._medusaLast or 0) < 0.05 then return end
	State._medusaLast = _now
	local char = LP.Character
	local root = char and char:FindFirstChild("HumanoidRootPart")
	if not root then return end
	if not MedusaConfig.RadiusPart then createRadiusPart() end
 MedusaConfig.RadiusPart.Transparency = 0.7; MedusaConfig.RadiusPart.CFrame = CFrame.new(root.Position + Vector3.new(0, -2.5, 0)) * CFrame.Angles(0, 0, math.rad(90)); local tool = isMedusaEquipped()
	if tool and (tick() - MedusaConfig.LastUsed >= MedusaConfig.Delay) then
		for _, plr in ipairs(Players:GetPlayers()) do
			if plr ~= LP and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
				local pRoot = plr.Character.HumanoidRootPart
				if (pRoot.Position - root.Position).Magnitude <= MedusaConfig.Radius then
     tool:Activate(); MedusaConfig.LastUsed = tick()
					break
				end
			end
		end
	end
end)
local function doTpDown()
    pcall(function()
        local character, humanoid, root = safetyCharacterParts()
        if character then safetyTeleportToFloor(character, humanoid, root) end
    end)
end
local BAT_COUNTER_SLAP_LIST={"Bat","Slap","Iron Slap","Gold Slap","Diamond Slap","Emerald Slap","Ruby Slap","Dark Matter Slap","Flame Slap","Nuclear Slap","Galaxy Slap","Glitched Slap"}
local function findBatForCounter()
    local c=LP.Character; if not c then return nil end
    local bp=LP:FindFirstChildOfClass("Backpack")
    for _,name in ipairs(BAT_COUNTER_SLAP_LIST) do
        local t=c:FindFirstChild(name) or (bp and bp:FindFirstChild(name)); if t then return t end
    end
    for _,ch in ipairs(c:GetChildren()) do if ch:IsA("Tool") and ch.Name:lower():find("bat") then return ch end end
    if bp then for _,ch in ipairs(bp:GetChildren()) do if ch:IsA("Tool") and ch.Name:lower():find("bat") then return ch end end end
    return nil
end
local function swingBatForCounter(bat,char)
    local hum2=char:FindFirstChildOfClass("Humanoid")
    if bat.Parent~=char then if hum2 then pcall(function() hum2:EquipTool(bat) end) end; task.wait(0.05) end
    local remote=bat:FindFirstChildOfClass("RemoteEvent") or bat:FindFirstChildOfClass("RemoteFunction")
    if remote and remote:IsA("RemoteEvent") then
        pcall(function() remote:FireServer() end); task.wait(0.15); pcall(function() remote:FireServer() end)
    else pcall(function() bat:Activate() end); task.wait(0.15); pcall(function() bat:Activate() end) end
end
local function startBatCounter()
    if Conns.batCounter then return end
    Conns.batCounter=RunService.Heartbeat:Connect(function()
        if not State.batCounterEnabled then return end
        if State.batCounterDebounce then return end
        local char=LP.Character; if not char then return end
        local hum2=char:FindFirstChildOfClass("Humanoid"); if not hum2 then return end
        local st=hum2:GetState()
        if st==Enum.HumanoidStateType.Physics or st==Enum.HumanoidStateType.Ragdoll or st==Enum.HumanoidStateType.FallingDown then
            State.batCounterDebounce=true
            task.spawn(function()
                local bat=findBatForCounter()
                if bat then swingBatForCounter(bat,char) end
                task.wait(0.5); State.batCounterDebounce=false
            end)
        end
    end)
end
local function stopBatCounter()
    if Conns.batCounter then Conns.batCounter:Disconnect(); Conns.batCounter=nil end
    State.batCounterDebounce=false
end
local function findMedusa()
    local c=LP.Character; if not c then return nil end
    for _,t in ipairs(c:GetChildren()) do if t:IsA("Tool") then local n=t.Name:lower(); if n:find("medusa") or n:find("head") or n:find("stone") then return t end end end
    local bp=LP:FindFirstChild("Backpack")
    if bp then for _,t in ipairs(bp:GetChildren()) do if t:IsA("Tool") then local n=t.Name:lower(); if n:find("medusa") or n:find("head") or n:find("stone") then return t end end end end
    return nil
end
function useMedusaCounter()
    if State.medusaDebounce then return end; if tick()-State.medusaLastUsed<MEDUSA_COOLDOWN then return end
    local c=LP.Character; if not c then return end; State.medusaDebounce=true
    local med=findMedusa(); if not med then State.medusaDebounce=false; return end
    if med.Parent~=c then local hum2=c:FindFirstChildOfClass("Humanoid"); if hum2 then hum2:EquipTool(med) end end
    pcall(function() med:Activate() end); State.medusaLastUsed=tick(); State.medusaDebounce=false
end
local function onAnchorChanged(part) return part:GetPropertyChangedSignal("Anchored"):Connect(function()
    if part.Anchored and part.Transparency==1 then
        if State.medusaResetEnabled then task.spawn(cursedInstaReset)
        elseif State.medusaCounterEnabled then useMedusaCounter() end
    end
end) end
function setupMedusaCounter(char)
    for _,c2 in pairs(Conns.anchor) do pcall(function() c2:Disconnect() end) end; Conns.anchor={}
    if not char then return end
    for _,part in ipairs(char:GetDescendants()) do if part:IsA("BasePart") then table.insert(Conns.anchor,onAnchorChanged(part)) end end
    table.insert(Conns.anchor,char.DescendantAdded:Connect(function(part) if part:IsA("BasePart") then table.insert(Conns.anchor,onAnchorChanged(part)) end end))
end
function stopMedusaCounter() for _,c2 in pairs(Conns.anchor) do pcall(function() c2:Disconnect() end) end; Conns.anchor={} end
function refreshMedusaHooks()
    if State.medusaCounterEnabled or State.medusaResetEnabled then setupMedusaCounter(LP.Character) else stopMedusaCounter() end
end
local function faceSouth() pcall(function() local c=LP.Character; if not c then return end; local root=c:FindFirstChild("HumanoidRootPart"); if root then root.CFrame=CFrame.new(root.Position)*CFrame.Angles(0,0,0) end end) end
local function faceNorth() pcall(function() local c=LP.Character; if not c then return end; local root=c:FindFirstChild("HumanoidRootPart"); if root then root.CFrame=CFrame.new(root.Position)*CFrame.Angles(0,math.rad(180),0) end end) end
local function startAutoLeft()
    if Conns.autoLeft then Conns.autoLeft:Disconnect() end; State.autoLeftPhase=1
    Conns.autoLeft=RunService.Heartbeat:Connect(function()
        if not State.autoLeftEnabled then return end
        local c=LP.Character; if not c then return end
        local root=c:FindFirstChild("HumanoidRootPart"); local hum2=c:FindFirstChildOfClass("Humanoid"); if not root or not hum2 then return end
        local spd=State.getAutoPathSpeed()
        if State.autoLeftPhase==1 then
            local tgt=Vector3.new(AP.L1.X,root.Position.Y,AP.L1.Z); if (tgt-root.Position).Magnitude<1 then State.autoLeftPhase=2; local d=(AP.L2-root.Position); local mv=Vector3.new(d.X,0,d.Z).Unit; hum2:Move(mv,false); root.AssemblyLinearVelocity=Vector3.new(mv.X*spd,root.AssemblyLinearVelocity.Y,mv.Z*spd); return end
            local d=(AP.L1-root.Position); local mv=Vector3.new(d.X,0,d.Z).Unit; hum2:Move(mv,false); root.AssemblyLinearVelocity=Vector3.new(mv.X*spd,root.AssemblyLinearVelocity.Y,mv.Z*spd)
        elseif State.autoLeftPhase==2 then
            local tgt=Vector3.new(AP.L2.X,root.Position.Y,AP.L2.Z); if (tgt-root.Position).Magnitude<1 then hum2:Move(Vector3.zero,false); root.AssemblyLinearVelocity=Vector3.zero; State.autoLeftEnabled=false; if Conns.autoLeft then Conns.autoLeft:Disconnect(); Conns.autoLeft=nil end; State.autoLeftPhase=1; if autoLeftSetVisual then autoLeftSetVisual(false) end; faceSouth(); return end
            local d=(AP.L2-root.Position); local mv=Vector3.new(d.X,0,d.Z).Unit; hum2:Move(mv,false); root.AssemblyLinearVelocity=Vector3.new(mv.X*spd,root.AssemblyLinearVelocity.Y,mv.Z*spd)
        end
    end)
end
local function stopAutoLeft()
    if Conns.autoLeft then Conns.autoLeft:Disconnect(); Conns.autoLeft=nil end; State.autoLeftPhase=1
    local c=LP.Character; if c then local hum2=c:FindFirstChildOfClass("Humanoid"); if hum2 then hum2:Move(Vector3.zero,false) end end
end
local function startAutoRight()
    if Conns.autoRight then Conns.autoRight:Disconnect() end; State.autoRightPhase=1
    Conns.autoRight=RunService.Heartbeat:Connect(function()
        if not State.autoRightEnabled then return end
        local c=LP.Character; if not c then return end
        local root=c:FindFirstChild("HumanoidRootPart"); local hum2=c:FindFirstChildOfClass("Humanoid"); if not root or not hum2 then return end
        local spd=State.getAutoPathSpeed()
        if State.autoRightPhase==1 then
            local tgt=Vector3.new(AP.R1.X,root.Position.Y,AP.R1.Z); if (tgt-root.Position).Magnitude<1 then State.autoRightPhase=2; local d=(AP.R2-root.Position); local mv=Vector3.new(d.X,0,d.Z).Unit; hum2:Move(mv,false); root.AssemblyLinearVelocity=Vector3.new(mv.X*spd,root.AssemblyLinearVelocity.Y,mv.Z*spd); return end
            local d=(AP.R1-root.Position); local mv=Vector3.new(d.X,0,d.Z).Unit; hum2:Move(mv,false); root.AssemblyLinearVelocity=Vector3.new(mv.X*spd,root.AssemblyLinearVelocity.Y,mv.Z*spd)
        elseif State.autoRightPhase==2 then
            local tgt=Vector3.new(AP.R2.X,root.Position.Y,AP.R2.Z); if (tgt-root.Position).Magnitude<1 then hum2:Move(Vector3.zero,false); root.AssemblyLinearVelocity=Vector3.zero; State.autoRightEnabled=false; if Conns.autoRight then Conns.autoRight:Disconnect(); Conns.autoRight=nil end; State.autoRightPhase=1; if autoRightSetVisual then autoRightSetVisual(false) end; faceNorth(); return end
            local d=(AP.R2-root.Position); local mv=Vector3.new(d.X,0,d.Z).Unit; hum2:Move(mv,false); root.AssemblyLinearVelocity=Vector3.new(mv.X*spd,root.AssemblyLinearVelocity.Y,mv.Z*spd)
        end
    end)
end
local function stopAutoRight()
    if Conns.autoRight then Conns.autoRight:Disconnect(); Conns.autoRight=nil end; State.autoRightPhase=1
    local c=LP.Character; if c then local hum2=c:FindFirstChildOfClass("Humanoid"); if hum2 then hum2:Move(Vector3.zero,false) end end
end
local antiRagdollConn = nil
local function resetAntiRagdollCharacter(char)
    local hum = char and char:FindFirstChildOfClass("Humanoid"); local root = char and char:FindFirstChild("HumanoidRootPart")
    if not hum or not root or hum.Health <= 0 then return end
    pcall(function()
        hum:ChangeState(Enum.HumanoidStateType.GettingUp); hum:ChangeState(Enum.HumanoidStateType.Running)
        root.Velocity = Vector3.zero
        root.RotVelocity = Vector3.zero
        root.AssemblyLinearVelocity = Vector3.zero
        root.AssemblyAngularVelocity = Vector3.zero
        hum.PlatformStand = false; hum.Sit = false; hum.AutoRotate = true; hum.JumpPower = hum.JumpPower > 0 and hum.JumpPower or 50
        hum.WalkSpeed = hum.WalkSpeed > 0 and hum.WalkSpeed or 16
        for _, obj in ipairs(char:GetDescendants()) do
            if obj:IsA("Motor6D") then
                obj.Enabled = true
            elseif obj:IsA("Constraint")
                or obj:IsA("BallSocketConstraint")
                or obj:IsA("HingeConstraint") then
                obj.Enabled = true
            elseif obj:IsA("BasePart") then
                obj.CanCollide = true
                obj.AssemblyLinearVelocity = Vector3.zero
                obj.AssemblyAngularVelocity = Vector3.zero
            end
        end
        workspace.CurrentCamera.CameraSubject = hum
        local playerModule = LP.PlayerScripts:FindFirstChild("PlayerModule")
        if playerModule then
            local controlModule = playerModule:FindFirstChild("ControlModule")
            if controlModule then
                local success, module = pcall(require, controlModule)
                if success and module and module.Enable then module:Enable() end
            end
        end
    end)
end
startAntiRagdoll = function()
    if antiRagdollConn then return end
    antiRagdollConn = RunService.Heartbeat:Connect(function()
        if not State.antiRagdollEnabled then return end
        local char = LP.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hum then return end
        local state = hum:GetState()
        if state == Enum.HumanoidStateType.Physics
            or state == Enum.HumanoidStateType.Ragdoll
            or state == Enum.HumanoidStateType.FallingDown
            or state == Enum.HumanoidStateType.Dead
            or hum.PlatformStand == true
            or hum.Sit == true then
            resetAntiRagdollCharacter(char)
        end
    end)
end
stopAntiRagdoll = function()
    if antiRagdollConn then
        antiRagdollConn:Disconnect(); antiRagdollConn = nil
    end
end
local ContentProvider = game:GetService("ContentProvider")
local Anims = {
    idle1 = "rbxassetid://133806214992291",
    idle2 = "rbxassetid://94970088341563",
    walk = "rbxassetid://707897309",
    run = "rbxassetid://707861613",
    jump = "rbxassetid://116936326516985",
    fall = "rbxassetid://116936326516985",
    climb = "rbxassetid://116936326516985",
    swim = "rbxassetid://116936326516985",
    swimidle = "rbxassetid://116936326516985"
}
task.spawn(function() pcall(function() ContentProvider:PreloadAsync(Anims) end) end)
local function applyAnimPack(char)
    local a = char:FindFirstChild("Animate")
    if not a then return end
    local function s(o, id) if o then o.AnimationId = id end end
    s(a.idle and a.idle.Animation1, Anims.idle1); s(a.idle and a.idle.Animation2, Anims.idle2); s(a.walk and a.walk.WalkAnim, Anims.walk); s(a.run and a.run.RunAnim, Anims.run)
    s(a.jump and a.jump.JumpAnim, Anims.jump); s(a.fall and a.fall.FallAnim, Anims.fall); s(a.climb and a.climb.ClimbAnim, Anims.climb); s(a.swim and a.swim.Swim, Anims.swim)
    s(a.swimidle and a.swimidle.SwimIdle, Anims.swimidle)
end
local animHBConn
function startNuevaAnimacion()
    if animHBConn then animHBConn:Disconnect(); animHBConn = nil end
    local char = LP.Character
    if char then
        applyAnimPack(char); local hum2 = char:FindFirstChildOfClass("Humanoid")
        if hum2 then
            for _, t in ipairs(hum2:GetPlayingAnimationTracks()) do t:Stop(0) end
            hum2:ChangeState(Enum.HumanoidStateType.Running)
        end
    end
    local _animLast = 0
    animHBConn = RunService.Heartbeat:Connect(function()
        if not State.nuevaAnimacionEnabled then return end
        local _now = os.clock()
        if _now - _animLast < 0.25 then return end
        _animLast = _now
        local c = LP.Character
        if c then applyAnimPack(c) end
    end)
end
function stopNuevaAnimacion()
    if animHBConn then animHBConn:Disconnect(); animHBConn = nil end
end
local applyFPSBoost
applyFPSBoost=function()
    pcall(function() setfpscap(999999999) end)
    local function pO(v) pcall(function()
        if v:IsA("Model") then v.LevelOfDetail=Enum.ModelLevelOfDetail.Disabled; v.ModelStreamingMode=Enum.ModelStreamingMode.Nonatomic
        elseif v:IsA("MeshPart") then v.CastShadow=false; v.DoubleSided=false; v.RenderFidelity=Enum.RenderFidelity.Performance
        elseif v:IsA("BasePart") then v.CastShadow=false; v.Material=Enum.Material.Plastic; v.Reflectance=0
        elseif v:IsA("Decal") or v:IsA("Texture") then v.Transparency=1
        elseif v:IsA("SpecialMesh") then v.TextureId=""
        elseif v:IsA("Fire") or v:IsA("SpotLight") or v:IsA("Smoke") or v:IsA("Sparkles") or v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Beam") then v.Enabled=false
        elseif v:IsA("SurfaceAppearance") or v:IsA("MaterialVariant") then v:Destroy()
        elseif v:IsA("Attachment") then v.Visible=false end
    end) end
    for _,v in pairs(workspace:GetDescendants()) do pO(v) end
    pcall(function()
        local L=game:GetService("Lighting")
        for _,v in pairs(L:GetDescendants()) do pcall(function() if v:IsA("Sky") or v:IsA("Atmosphere") or v:IsA("BloomEffect") or v:IsA("BlurEffect") or v:IsA("SunRaysEffect") or v:IsA("DepthOfFieldEffect") or v:IsA("Clouds") or v:IsA("PostEffect") or v:IsA("ColorCorrectionEffect") then v:Destroy() end end) end
        pcall(function() sethiddenproperty(L,"Technology",Enum.Technology.Legacy) end)
        L.GlobalShadows=false; L.FogEnd=9e9; L.Brightness=0; local ter=workspace:FindFirstChildOfClass("Terrain")
        if ter then pcall(function() sethiddenproperty(ter,"Decoration",false) end); ter.WaterReflectance=0; ter.WaterTransparency=0.7; ter.WaterWaveSize=0; ter.WaterWaveSpeed=0 end
    end)
    if not State._fpsBoostConn then
        State._fpsBoostConn = workspace.DescendantAdded:Connect(function(v)
            if State.fpsBoostEnabled then pO(v) end
        end)
    end
end
RunService.Stepped:Connect(function()
    for _,p in ipairs(Players:GetPlayers()) do
        if p~=LP and p.Character then
            for _,part in ipairs(p.Character:GetChildren()) do
                if part:IsA("BasePart") and part.CanCollide then part.CanCollide = false end
            end
        end
    end
end)
saveConfig = function(btn)
    if State._configLoading then
        State._saveAfterLoad = true
        return false
    end
    -- A manual save must also work when no valid old config existed.
    State._configLoaded = true
    -- Manual/automatic save is allowed even when an old config was invalid.
    -- The atomic writer replaces it with the current valid configuration.
    if State._saveInProgress then
        State._saveQueued = true
        return false
    end
    State._saveInProgress = true
    local function keySnapshot(entry)
        return {
            kb = entry and entry.kb and entry.kb.Name or nil,
            gp = entry and entry.gp and entry.gp.Name or nil,
        }
    end
    local function positionSnapshot(guiObject)
        if not guiObject then return nil end
        local ok, p = pcall(function() return guiObject.Position end)
        if not ok or not p then return nil end
        return {
            xs = p.X.Scale,
            xo = p.X.Offset,
            ys = p.Y.Scale,
            yo = p.Y.Offset,
        }
    end
    local cfg = {
        configVersion = 9,
        normalSpeed = NS,
        carrySpeed = CS,
        profileLaggerNormalSpeed = State.profileLaggerNormalSpeed,
        profileLaggerCarrySpeed = State.profileLaggerCarrySpeed,
        speedProfile = State.speedProfile,
        laggerSpeed = LS,
        laggerCarrySpeed = LS2,
        uiScale = uiScaleValue,
        backgroundAssetId = State.backgroundAssetId,
        theme = State.theme,
        buttonsSize = State.buttonsSizeValue,
        buttonsShape = State.buttonsShape,
        uiLocked = uiLocked,
        guiVisible = State.guiVisible,
        autoLeftKey = keySnapshot(KB.AutoLeft),
        autoRightKey = keySnapshot(KB.AutoRight),
        dropKey = keySnapshot(KB.Drop),
        tpDownKey = keySnapshot(KB.TPDown),
        autoBatKey = keySnapshot(KB.AutoBat),
        autoBatV2Key = keySnapshot(KB.AutoBatV2),
        instaResetKey = keySnapshot(KB.InstaReset),
        tpBatKey = keySnapshot(KB.TPBat),
        speedKey = keySnapshot(KB.Speed),
        laggerKey = keySnapshot(KB.Lagger),
        guiHideKey = keySnapshot(KB.GuiHide),
        infJump = State.infJumpEnabled,
        antiRagdoll = State.antiRagdollEnabled,
        fpsBoost = State.fpsBoostEnabled,
        medusaCounter = State.medusaCounterEnabled,
        medusaReset = State.medusaResetEnabled,
        batCounter = State.batCounterEnabled,
        unwalkEnabled = State.unwalkEnabled,
        desyncEnabled = State.desyncEnabled,
        autoSwing = State.autoSwingEnabled,
        autoBatToggled = State.autoBatToggled,
        autoBatV2Toggled = State.autoBatV2Enabled,
        tpBatEnabled = State.tpBatEnabled,
        tpBatVersion = (State.tpBatVersion == 2) and 2 or 1,
        stretchRez = State.stretchRezEnabled,
        removeAccessories = State.removeAccessoriesEnabled,
        antiLag = State.antiLagEnabled,
        korbloxLeft = State.korbloxLeft == true,
        korbloxRight = State.korbloxRight == true,
        korbloxHeadless = State.korbloxHeadless == true,
        hitboxFollower = State.hitboxFollowerEnabled,
        darkMode = State.darkModeEnabled,
        skyStyle = State.skyStyle,
        noIntro = State.noIntro == true,
        introEnabled = State.noIntro ~= true,
        selectedIntroMusic = State.selectedIntroMusic,
        autoTPDown = autoTPDownEnabled,
        autoTPDownHeight = autoTPDownHeight,
        speedToggled = State.speedToggled,
        laggerMode = State.laggerToggled,
        laggerPhase = laggerPhase,
        linieEnabled = State.linieEnabled,
        autoMedusaEnabled = MedusaConfig and MedusaConfig.Enabled or nil,
        medusaRadius = MedusaConfig and MedusaConfig.Radius or nil,
        medusaDelay = MedusaConfig and MedusaConfig.Delay or nil,
        nuevaAnimacion = State.nuevaAnimacionEnabled,
        instaReset = State.instaResetEnabled,
        instaResetVisible = btnInstaReset and btnInstaReset.Visible or nil,
        hideButtons = State.hideButtonsEnabled,
        panelPos = positionSnapshot(MobilePanel),
        mobileButtonPositions = (function()
            local positions = {}
            for name, mobileBtn in pairs(mobileButtonsByName) do positions[name] = positionSnapshot(mobileBtn) end
            return positions
        end)(),
        mainPos = positionSnapshot(main),
        miniPos = positionSnapshot(mini),
        pbPos = positionSnapshot(pbFrame),
        instaResetPos = positionSnapshot(btnInstaReset),
    }
    local encodeOk, encoded = pcall(function()
        return HttpService:JSONEncode(cfg)
    end)
    local saved = false
    local saveError = nil

    if encodeOk and type(encoded) == "string" and #encoded > 0 then
        -- SAVE CONFIG v9: intentionally simple.
        -- The only required operation is writefile(CONFIG_FILE, encoded).
        -- No temp file, backup file, atomic rename, or read-back verification
        -- is allowed to decide whether the save succeeded.
        local writer = State._resolveFileFunction("writefile")
        if type(writer) ~= "function" then
            saveError = "writefile indisponible dans cet executer"
        else
            local ok, err = pcall(function()
                writer(CONFIG_FILE, encoded)
            end)
            if ok then
                saved = true
            else
                saveError = tostring(err or "writefile failed")
            end
        end

        if saved then
            State._lastConfigJson = encoded
            State._lastSaveError = nil
            State._configLoadFailed = false
            State._allowInitialConfigCreation = false
            State._configDirty = false
            -- Position backup is optional and can never make config saving fail.
            if State.savePositionBackup then pcall(State.savePositionBackup) end
        else
            State._lastConfigJson = nil
            State._lastSaveError = saveError or "Impossible d'ecrire la configuration"
            warn("[ZeyHubb SAVE CONFIG] " .. tostring(State._lastSaveError))
        end
    else
        State._lastSaveError = "JSON de configuration invalide"
        warn("[ZeyHubb SAVE CONFIG] " .. tostring(State._lastSaveError))
    end
    State._saveInProgress = false
    if btn and btn.Parent then
        local previousText = btn.Text
        btn.Text = saved and "Saved!" or "Failed!"
        task.delay(1.5, function()
            if btn and btn.Parent then btn.Text = previousText end
        end)
    end
    if State._saveQueued then
        State._saveQueued = false
        if State.requestConfigSave then State.requestConfigSave() end
    end
    return saved
end
loadConfig = function()
    local function readConfigFile(path)
        local decoded, raw = State._readValidJsonFile(path)
        if type(decoded) ~= "table" then return nil, raw end
        return decoded, raw
    end
    local mainCfg, mainRaw = readConfigFile(CONFIG_FILE)
    local tempCfg, tempRaw = readConfigFile(State._configTempFile)
    local backupCfg, backupRaw = readConfigFile(State._configBackupFile)
    local legacyCfg, legacyRaw = readConfigFile(State._legacyConfigFile)
    local legacyTempCfg, legacyTempRaw = readConfigFile(State._legacyConfigTempFile)
    local legacyBackupCfg, legacyBackupRaw = readConfigFile(State._legacyConfigBackupFile)
    local cfg, raw = nil, nil
    local loadedFromBackup = false; local loadedFromLegacy = false; local loadedFromTemp = false
    if type(tempCfg) == "table" and (type(mainCfg) ~= "table" or tempRaw ~= mainRaw) then
        cfg, raw = tempCfg, tempRaw
        loadedFromTemp = true
    elseif type(mainCfg) == "table" then
        cfg, raw = mainCfg, mainRaw
    elseif type(backupCfg) == "table" then
        cfg, raw = backupCfg, backupRaw
        loadedFromBackup = true
    elseif type(legacyTempCfg) == "table" and (type(legacyCfg) ~= "table" or legacyTempRaw ~= legacyRaw) then
        cfg, raw = legacyTempCfg, legacyTempRaw
        loadedFromLegacy = true; loadedFromTemp = true
    elseif type(legacyCfg) == "table" then
        cfg, raw = legacyCfg, legacyRaw
        loadedFromLegacy = true
    elseif type(legacyBackupCfg) == "table" then
        cfg, raw = legacyBackupCfg, legacyBackupRaw
        loadedFromLegacy = true; loadedFromBackup = true
    end
    local hadAnyConfigFile = false
    for _, path in ipairs({
        CONFIG_FILE,
        State._configTempFile,
        State._configBackupFile,
        State._legacyConfigFile,
        State._legacyConfigTempFile,
        State._legacyConfigBackupFile,
    }) do
        local exists = false
        pcall(function() exists = _isfile(path) end)
        if exists then hadAnyConfigFile = true break end
    end
    if not cfg then
        State._configLoaded = true
        State._configLoadFailed = hadAnyConfigFile
        State._allowInitialConfigCreation = not hadAnyConfigFile
        State._saveAfterLoad = false; State._lastSaveError = hadAnyConfigFile and "Se encontraron configuraciones dañadas; no se sobrescribieron" or nil
        if State.loadPositionBackup then pcall(State.loadPositionBackup) end
        return false
    end
    State._configLoading = true; State._configLoadFailed = false; State._allowInitialConfigCreation = false
    local applyOk = pcall(function()
        if type(cfg.normalSpeed) == "number" then
            NS = cfg.normalSpeed
            if normalBox then normalBox.Text = tostring(NS) end
        end
        if type(cfg.carrySpeed) == "number" then
            CS = cfg.carrySpeed
            if carryBox then carryBox.Text = tostring(CS) end
        end
        if type(cfg.profileLaggerNormalSpeed) == "number" then
            State.profileLaggerNormalSpeed = cfg.profileLaggerNormalSpeed
        end
        if type(cfg.profileLaggerCarrySpeed) == "number" then
            State.profileLaggerCarrySpeed = cfg.profileLaggerCarrySpeed
        end
        if type(cfg.laggerSpeed) == "number" then
            LS = cfg.laggerSpeed
            if laggerBox then laggerBox.Text = tostring(LS) end
        end
        if type(cfg.laggerCarrySpeed) == "number" then
            LS2 = cfg.laggerCarrySpeed
            if laggerBox2 then laggerBox2.Text = tostring(LS2) end
        end
        if type(cfg.uiScale) == "number" then
            uiScaleValue = math.clamp(math.floor(cfg.uiScale + 0.5), 50, 150)
            if mainUIScale then mainUIScale.Scale = uiScaleValue / 100 end
        end
        if cfg.theme and State.applyTheme then State.applyTheme(cfg.theme, false) end
        if cfg.backgroundAssetId and State.applyBackgroundImage then
            State.applyBackgroundImage(cfg.backgroundAssetId, false)
        elseif State.applyBackgroundImage then
            State.applyBackgroundImage(State.backgroundAssetId, false)
        end
        if type(cfg.buttonsSize) == "number" then State.buttonsSizeValue = math.clamp(math.floor(cfg.buttonsSize + 0.5), 0, 100) end
        if cfg.buttonsShape ~= nil then State.buttonsShape = normalizeMobileButtonsShape(cfg.buttonsShape) end
        applyMobileButtonsSize(State.buttonsSizeValue)
        if buttonsSizeBox then buttonsSizeBox.Text = tostring(State.buttonsSizeValue) end
        if State._buttonsShapeSelectorVisual then State._buttonsShapeSelectorVisual(State.buttonsShape, false) end
        if cfg.uiLocked ~= nil then
            uiLocked = cfg.uiLocked == true
            _G.AceGuiLocked = uiLocked
            if setLockUIVisual then setLockUIVisual(uiLocked) end
        end
        if cfg.guiVisible ~= nil then
            State.guiVisible = cfg.guiVisible == true
            if main then main.Visible = State.guiVisible end
            if mini then mini.Visible = not State.guiVisible end
        end
        if cfg.selectedIntroMusic ~= nil then
            State.selectedIntroMusic = cfg.selectedIntroMusic
            if getgenv and getgenv().FEARV2MusicBtn then getgenv().FEARV2MusicBtn.Text = "Music " .. tostring(State.selectedIntroMusic) end
        end
        if cfg.noIntro ~= nil then
            State.noIntro = cfg.noIntro == true
        elseif cfg.introEnabled ~= nil then
            State.noIntro = cfg.introEnabled ~= true
        end
        State.introEnabled = not State.noIntro
        if setNoIntroToggle then setNoIntroToggle(State.noIntro, false) end
        if setIntroToggle then setIntroToggle(State.introEnabled, false) end
        if type(cfg.autoTPDownHeight) == "number" then autoTPDownHeight = math.clamp(cfg.autoTPDownHeight, 0, 500) end
        if cfg.autoTPDown ~= nil then
            autoTPDownEnabled = cfg.autoTPDown == true
            if setAutoTPDownVisual then setAutoTPDownVisual(autoTPDownEnabled) end
            if autoTPDownEnabled then startAutoTPDown() else stopAutoTPDown() end
        end
        if MedusaConfig then
            if type(cfg.medusaRadius) == "number" then
                MedusaConfig.Radius = cfg.medusaRadius
                if MedusaConfig.RadiusPart then MedusaConfig.RadiusPart.Size = Vector3.new(0.2, MedusaConfig.Radius * 2, MedusaConfig.Radius * 2) end
            end
            if type(cfg.medusaDelay) == "number" then
                MedusaConfig.Delay = cfg.medusaDelay
            end
        end
        local function loadKey(entry, data)
            if not entry or type(data) ~= "table" then return end
            entry.kb = nil; entry.gp = nil
            if data.kb and Enum.KeyCode[data.kb] then entry.kb = Enum.KeyCode[data.kb] end
            if data.gp and Enum.KeyCode[data.gp] then entry.gp = Enum.KeyCode[data.gp] end
            if State._bindButtons and State._bindButtons[entry] then
                State._bindButtons[entry].Text =
                    entry.gp and ("GP:" .. entry.gp.Name)
                    or (entry.kb and entry.kb.Name or "None")
            end
        end
        loadKey(KB.AutoLeft, cfg.autoLeftKey); loadKey(KB.AutoRight, cfg.autoRightKey); loadKey(KB.Drop, cfg.dropKey); loadKey(KB.TPDown, cfg.tpDownKey)
        loadKey(KB.AutoBat, cfg.autoBatKey); loadKey(KB.AutoBatV2, cfg.autoBatV2Key); loadKey(KB.InstaReset, cfg.instaResetKey); loadKey(KB.TPBat, cfg.tpBatKey)
        loadKey(KB.Speed, cfg.speedKey); loadKey(KB.Lagger, cfg.laggerKey); loadKey(KB.GuiHide, cfg.guiHideKey)
        if cfg.infJump ~= nil then
            -- setInfJump is only the visual setter returned by makePillToggle;
            -- it does NOT execute the toggle callback. Start the actual Hold
            -- Infinite Jump engine explicitly after restoring the saved state.
            State.infJumpMode = "hold"
            State.infJumpEnabled = (cfg.infJump == true)

            if setInfJump then
                setInfJump(State.infJumpEnabled)
            end

            if State.infJumpEnabled and State.startHoldInfJump then
                task.defer(function()
                    if State.infJumpEnabled and State.infJumpMode == "hold" then
                        State.startHoldInfJump()
                    end
                end)
            else
                State.stopHoldInfJump()
            end
        end
        if cfg.antiRagdoll ~= nil then
            State.antiRagdollEnabled = cfg.antiRagdoll == true
            if setAntiRag then setAntiRag(State.antiRagdollEnabled) end
            if State.antiRagdollEnabled then startAntiRagdoll() else stopAntiRagdoll() end
        end
        if cfg.fpsBoost ~= nil then
            State.fpsBoostEnabled = cfg.fpsBoost == true
            if setFps then setFps(State.fpsBoostEnabled) end
            if State.fpsBoostEnabled then pcall(applyFPSBoost) end
        end
        if cfg.korbloxLeft ~= nil and State._setKorbloxLeft then
            State.korbloxLeft = cfg.korbloxLeft == true
            pcall(State._setKorbloxLeft, State.korbloxLeft)
        end
        if cfg.korbloxRight ~= nil and State._setKorbloxRight then
            State.korbloxRight = cfg.korbloxRight == true
            pcall(State._setKorbloxRight, State.korbloxRight)
        end
        if cfg.korbloxHeadless ~= nil and State._setKorbloxHeadless then
            State.korbloxHeadless = cfg.korbloxHeadless == true
            pcall(State._setKorbloxHeadless, State.korbloxHeadless)
        end
        if cfg.medusaCounter ~= nil then
            State.medusaCounterEnabled = cfg.medusaCounter == true
            if setMedusaCounter then setMedusaCounter(State.medusaCounterEnabled) end
        end
        if cfg.medusaReset ~= nil then
            State.medusaResetEnabled = cfg.medusaReset == true
            if setMedusaReset then setMedusaReset(State.medusaResetEnabled) end
        end
        refreshMedusaHooks()
        if cfg.batCounter ~= nil then
            State.batCounterEnabled = cfg.batCounter == true
            if setBatCounter then setBatCounter(State.batCounterEnabled) end
            if State.batCounterEnabled then startBatCounter() else stopBatCounter() end
        end
        if cfg.autoSwing ~= nil then
            State.autoSwingEnabled = cfg.autoSwing == true
            if setAutoSwingVisual then setAutoSwingVisual(State.autoSwingEnabled) end
        end
        if cfg.unwalkEnabled ~= nil then
            State.unwalkEnabled = cfg.unwalkEnabled == true
            if setUnwalkToggle then setUnwalkToggle(State.unwalkEnabled) end
            if State.unwalkEnabled then startUnwalk() else stopUnwalk() end
        end
        if cfg.stretchRez ~= nil and setStretchRez then
            State.stretchRezEnabled = cfg.stretchRez == true; setStretchRez(State.stretchRezEnabled)
        end
        if cfg.removeAccessories ~= nil and setRemoveAccessories then
            State.removeAccessoriesEnabled = cfg.removeAccessories == true; setRemoveAccessories(State.removeAccessoriesEnabled)
        end
        if cfg.antiLag ~= nil and setAntiLag then
            State.antiLagEnabled = cfg.antiLag == true; setAntiLag(State.antiLagEnabled)
        end
        if cfg.hitboxFollower ~= nil or cfg.hitboxFollowerEnabled ~= nil then
            State.hitboxFollowerEnabled = (cfg.hitboxFollower ~= nil and cfg.hitboxFollower == true)
                or (cfg.hitboxFollower == nil and cfg.hitboxFollowerEnabled == true)
            if State._setHitboxFollower then State._setHitboxFollower(State.hitboxFollowerEnabled) end
            if State.hitboxFollowerEnabled then
                State._hitboxFollower.start()
            else
                State._hitboxFollower.stop()
            end
        end
        if cfg.skyStyle ~= nil and setSkyStyle then
            setSkyStyle(cfg.skyStyle)
        elseif cfg.darkMode ~= nil and setDarkMode then
            setDarkMode(cfg.darkMode == true)
        end
        if cfg.desyncEnabled ~= nil then
            State.desyncEnabled = cfg.desyncEnabled == true
            task.defer(function()
                if setDesync then setDesync(State.desyncEnabled) end
                if saDesync then saDesync(State.desyncEnabled) end
                if State.desyncEnabled and startDesyncSession then startDesyncSession() end
            end)
        end
        if cfg.linieEnabled ~= nil then
            State.linieEnabled = cfg.linieEnabled == true
            if setLinieVisual then setLinieVisual(State.linieEnabled) end
        end
        if cfg.autoMedusaEnabled ~= nil then
            if MedusaConfig then MedusaConfig.Enabled = cfg.autoMedusaEnabled == true end
            if setAutoMedusaVisual then setAutoMedusaVisual(cfg.autoMedusaEnabled == true) end
        end
        if cfg.nuevaAnimacion ~= nil then
            State.nuevaAnimacionEnabled = cfg.nuevaAnimacion == true
            if setNuevaAnimacionVisual then setNuevaAnimacionVisual(State.nuevaAnimacionEnabled) end
            if State.nuevaAnimacionEnabled then
                task.defer(startNuevaAnimacion)
            else
                task.defer(stopNuevaAnimacion)
            end
        end
        local savedInstaReset = cfg.instaReset
        if savedInstaReset == nil then savedInstaReset = cfg.instaResetEnabled end
        if savedInstaReset ~= nil then
            State.instaResetEnabled = savedInstaReset == true
            if setInstaToggleVisual then setInstaToggleVisual(State.instaResetEnabled) end
        end
        if cfg.hideButtons ~= nil then
            State.hideButtonsEnabled = cfg.hideButtons == true
            if setHideButtonsVisual then setHideButtonsVisual(State.hideButtonsEnabled) end
            local visible = not State.hideButtonsEnabled
            if MobilePanel then MobilePanel.Visible = visible end
            for _, mobileBtn in pairs(mobileButtonsByName) do
                if mobileBtn then mobileBtn.Visible = visible end
            end
            if btnInstaReset then btnInstaReset.Visible = visible and (cfg.instaResetVisible ~= false) end
            if pbFrame then pbFrame.Visible = visible end
        elseif cfg.instaResetVisible ~= nil and btnInstaReset then
            btnInstaReset.Visible = cfg.instaResetVisible == true
        end
        State.speedProfile = "Normal"
        if State._refreshSpeedProfileVisual then State._refreshSpeedProfileVisual() end
        if normalBox then normalBox.Text = tostring(State.speedProfile == "Lagger" and State.profileLaggerNormalSpeed or NS) end
        if carryBox then carryBox.Text = tostring(State.speedProfile == "Lagger" and State.profileLaggerCarrySpeed or CS) end
        State.speedToggled = cfg.speedToggled == true; State.laggerToggled = cfg.laggerMode == true; laggerPhase = tonumber(cfg.laggerPhase) or (State.laggerToggled and 1 or 0); laggerPhase = math.clamp(math.floor(laggerPhase), 0, 2)
        if State.laggerToggled then
            State.speedToggled = false
        elseif laggerPhase ~= 0 then
            laggerPhase = 0
        end
        if mobileSpeedSetActive then mobileSpeedSetActive(State.speedToggled) end
        if mobileLaggerSetActive then mobileLaggerSetActive(State.laggerToggled) end
        if modeValLbl then
            modeValLbl.Text =
                laggerPhase == 2 and "Lagger Carry"
                or (State.laggerToggled and "Lagger")
                or (State.speedToggled and (State.speedProfile == "Lagger" and ("Carry · " .. tostring(State.profileLaggerCarrySpeed)) or "Carry"))
                or (State.speedProfile == "Lagger" and ("Lagger · " .. tostring(State.profileLaggerNormalSpeed)) or "Normal")
        end
        State._setTPBatEnabled(cfg.tpBatEnabled == true)
        if State._tpBatSetVisual then State._tpBatSetVisual(State.tpBatEnabled) end
        if State._tpBatConfigSetVisual then State._tpBatConfigSetVisual(State.tpBatEnabled) end
        State.tpBatVersion = (tonumber(cfg.tpBatVersion) == 2) and 2 or 1
        State._tpBatV2HittingCooldown = false; State._tpBatHittingCooldown = false
        if State._tpBatVersionSetVisual then State._tpBatVersionSetVisual(State.tpBatVersion == 2) end
        local autoBatV1 = cfg.autoBatToggled == true; local autoBatV2 = cfg.autoBatV2Toggled == true
        if autoBatV1 then autoBatV2 = false end
        State.autoBatToggled = autoBatV1; State.autoBatV2Enabled = autoBatV2
        if autoBatSetVisual then autoBatSetVisual(State.autoBatToggled) end
        if autoBatV2SetVisual then autoBatV2SetVisual(State.autoBatV2Enabled) end
        if State.autoBatToggled then
            task.defer(startBatAimbot)
        elseif State.autoBatV2Enabled then
            task.defer(startBatAimbotV2)
        else
            pcall(stopBatAimbot)
            if stopBatAimbotV2 then pcall(stopBatAimbotV2) end
        end
        local function restorePosition(guiObject, data)
            if guiObject and type(data) == "table" and data.xs ~= nil then
                guiObject.Position = UDim2.new(
                    data.xs,
                    data.xo or 0,
                    data.ys or 0,
                    data.yo or 0
                )
            end
        end
        local function restoreSavedPositions()
            restorePosition(main, cfg.mainPos); restorePosition(mini, cfg.miniPos); restorePosition(MobilePanel, cfg.panelPos)
            if type(cfg.mobileButtonPositions) == "table" then
                for name, positionData in pairs(cfg.mobileButtonPositions) do restorePosition(mobileButtonsByName[name], positionData) end
            end restorePosition(btnInstaReset, cfg.instaResetPos)
        end
        restoreSavedPositions(); task.delay(0.7, restoreSavedPositions)
        task.delay(1.35, function()
            restoreSavedPositions()
            task.defer(function()
                if State.loadPositionBackup and not State._positionDirty then pcall(State.loadPositionBackup) end
            end)
        end)
    end)
    State._configLoading = false; State._configLoaded = true
    State._configLoadFailed = not applyOk
    if applyOk then
        State._lastConfigJson = raw
        State._lastSaveError = nil; State._configDirty = false
    else
        State._lastSaveError = "La configuración se leyó, pero no se pudo aplicar; no será sobrescrita"
    end
    local pendingSave = State._saveAfterLoad
    State._saveAfterLoad = false
    if applyOk and (loadedFromBackup or loadedFromLegacy or loadedFromTemp or pendingSave) then
        if loadedFromBackup or loadedFromLegacy or loadedFromTemp then State._lastConfigJson = nil end
        State.requestConfigSave()
    end
    return applyOk
end
State._otherSpeedLabels = State._otherSpeedLabels or {}; State._otherSpeedConnections = State._otherSpeedConnections or {}
State._attachOtherSpeedBillboard = function(player, character)
    if not player or player == LP or not character then return end
    local head = character:FindFirstChild("Head")
    local old = head and head:FindFirstChild("PRIMEOtherSpeedBB")
    if old then old:Destroy() end
    State._otherSpeedLabels[player] = nil
end
State._setupOtherPlayerBillboard = function(player)
    if not player or player == LP then return end
    local previousConnection = State._otherSpeedConnections[player]
    if previousConnection then
        pcall(function() previousConnection:Disconnect() end)
    end
    State._otherSpeedConnections[player] = player.CharacterAdded:Connect(function(character)
        State._attachOtherSpeedBillboard(player, character)
    end)
    if player.Character then State._attachOtherSpeedBillboard(player, player.Character) end
end
task.spawn(function()
    for _, otherPlayer in ipairs(Players:GetPlayers()) do State._setupOtherPlayerBillboard(otherPlayer) end
end)
Players.PlayerAdded:Connect(function(player)
    State._setupOtherPlayerBillboard(player)
end)
Players.PlayerRemoving:Connect(function(player)
    local connection = State._otherSpeedConnections[player]
    if connection then pcall(function() connection:Disconnect() end) end
    State._otherSpeedConnections[player] = nil; State._otherSpeedLabels[player] = nil
end)
task.spawn(function()
    while gui and gui.Parent do
        for player, data in pairs(State._otherSpeedLabels) do
            local label = data and data.label
            local root = data and data.root
            local humanoid = data and data.humanoid
            if player.Parent and label and label.Parent and root and root.Parent and humanoid and humanoid.Health > 0 then
                local velocity = root.AssemblyLinearVelocity
                local horizontalSpeed = Vector3.new(velocity.X, 0, velocity.Z).Magnitude
                label.Text = string.format("%.1f", horizontalSpeed); label.Visible = true
            elseif label and label.Parent then
                label.Visible = false
            end
        end
        task.wait(0.08)
    end
end)
local h,hrp,speedLbl
local function setupChar(char)
    task.wait(0.1); h=char:WaitForChild("Humanoid",5); hrp=char:WaitForChild("HumanoidRootPart",5)
    if not h or not hrp then return end
    local head=char:FindFirstChild("Head")
    if head then
        local oldBB=head:FindFirstChild("ZeyHubbV2MobileBB"); if oldBB then oldBB:Destroy() end
        -- The unified PrimeBB below owns the single local speed counter.
        speedLbl=nil
    end
    if State.unwalkEnabled then task.wait(0.3); startUnwalk() end
    stopAntiRagdoll()
    if State.antiRagdollEnabled then task.wait(0.5); startAntiRagdoll() end
    if State.medusaCounterEnabled or State.medusaResetEnabled then setupMedusaCounter(char) end
    if State.autoBatToggled then stopBatAimbot(); task.wait(0.2); pcall(startBatAimbot) end
    if State.batCounterEnabled then task.wait(0.3); startBatCounter() end
end
LP.CharacterAdded:Connect(setupChar)
if LP.Character then task.spawn(function() setupChar(LP.Character) end) end
RunService.Stepped:Connect(function()
    for _,p in ipairs(Players:GetPlayers()) do
        if p~=LP and p.Character then
            for _,part in ipairs(p.Character:GetChildren()) do
                if part:IsA("BasePart") and part.CanCollide then part.CanCollide = false end
            end
        end
    end
end)
UIS.JumpRequest:Connect(function()
    if not State.infJumpEnabled or State.infJumpMode == "hold" then return end
    local c=LP.Character; if not c then return end
    local root=c:FindFirstChild("HumanoidRootPart")
    if root then root.AssemblyLinearVelocity=Vector3.new(root.AssemblyLinearVelocity.X,55,root.AssemblyLinearVelocity.Z) end
end)
RunService.RenderStepped:Connect(function()
    local _char = LP.Character
    if not _char then return end
    local _hum = _char:FindFirstChildOfClass("Humanoid")
    local _root = _char:FindFirstChild("HumanoidRootPart")
    if not _hum or not _root then return end
    h, hrp = _hum, _root
    if State._tpInProgress then State.destroySpeedVelocity(); return end
    if State.isRagdollSpeed(_hum) then State.lastMoveDir = Vector3.new(0,0,0); State.destroySpeedVelocity(); return end
    if State.autoBatToggled or State.autoLeftEnabled or State.autoRightEnabled then
        State.destroySpeedVelocity()
    else
        local linearVelocity = State._speedLinearVelocity
        if not linearVelocity or not State._speedAttachment or State._speedAttachment.Parent ~= _root then
            linearVelocity = State.setupSpeedVelocity(_root)
        end
        local md = _hum.MoveDirection
        local spd = State.getActiveMoveSpeed()
        local dir = nil
        if md.Magnitude > 0 then
            State.lastMoveDir = md
            dir = md
        elseif State.antiRagdollEnabled and State.lastMoveDir.Magnitude > 0 then
            for key in pairs(MOVE_KEYS) do if UIS:IsKeyDown(key) then dir = State.lastMoveDir; break end end
        end
        if linearVelocity then
            if dir then
                local flat = Vector3.new(dir.X, 0, dir.Z)
                if flat.Magnitude > 0 then
                    flat = flat.Unit
                    linearVelocity.VectorVelocity = Vector3.new(flat.X * spd, 0, flat.Z * spd)
                else
                    linearVelocity.VectorVelocity = Vector3.zero
                end
            else
                linearVelocity.VectorVelocity = Vector3.zero
            end
        end
    end
    local _now = os.clock()
    if _now - (State._speedLblLast or 0) >= 0.08 then
        State._speedLblLast = _now
        if speedLbl and speedLbl.Parent then
            local v = hrp.Velocity
            speedLbl.Text = string.format("%.1f", Vector3.new(v.X, 0, v.Z).Magnitude)
        end
    end
end)
UIS.InputBegan:Connect(function(inp,gp)
    if _anyKeyListening then return end
    if gp and string.sub(inp.UserInputType.Name, 1, 7) ~= "Gamepad" then return end
    local kc=inp.KeyCode; if kc==Enum.KeyCode.Unknown then return end
    if kbMatch(KB.Speed,kc) then
        State.laggerToggled = false; laggerPhase = 0
        State.speedToggled = not State.speedToggled
        if mobileLaggerSetActive then mobileLaggerSetActive(false) end
        if modeValLbl then modeValLbl.Text = State.speedToggled and "Carry" or "Normal" end
    elseif kbMatch(KB.AutoLeft,kc) then
        State.autoLeftEnabled=not State.autoLeftEnabled
        if State.autoLeftEnabled and State.autoBatToggled then State.autoBatToggled=false; stopBatAimbot(); if autoBatSetVisual then autoBatSetVisual(false) end end
        if State.autoLeftEnabled then startAutoLeft() else stopAutoLeft() end
        if autoLeftSetVisual then autoLeftSetVisual(State.autoLeftEnabled) end
    elseif kbMatch(KB.AutoRight,kc) then
        State.autoRightEnabled=not State.autoRightEnabled
        if State.autoRightEnabled and State.autoBatToggled then State.autoBatToggled=false; stopBatAimbot(); if autoBatSetVisual then autoBatSetVisual(false) end end
        if State.autoRightEnabled then startAutoRight() else stopAutoRight() end
        if autoRightSetVisual then autoRightSetVisual(State.autoRightEnabled) end
    elseif kbMatch(KB.Drop,kc) then
        if not State.dropActive then task.spawn(runDrop) end
    elseif kbMatch(KB.TPDown,kc) then
        task.spawn(doTpDown)
    elseif kbMatch(KB.Lagger,kc) then
        if laggerPhase == 1 then
            laggerPhase = 2; State.laggerToggled = true; State.speedToggled = false
            if mobileLaggerSetActive then mobileLaggerSetActive(true) end
            if modeValLbl then modeValLbl.Text = "Lagger 2" end
        else
            laggerPhase = 1; State.laggerToggled = true; State.speedToggled = false
            if mobileSpeedSetActive then mobileSpeedSetActive(false) end
            if mobileLaggerSetActive then mobileLaggerSetActive(true) end
            if modeValLbl then modeValLbl.Text = "Lagger 1" end
        end
    elseif kbMatch(KB.AutoBat,kc) then
        State.autoBatToggled=not State.autoBatToggled
        if State.autoBatToggled then
            if State.autoLeftEnabled then State.autoLeftEnabled=false; stopAutoLeft(); if autoLeftSetVisual then autoLeftSetVisual(false) end end
            if State.autoRightEnabled then State.autoRightEnabled=false; stopAutoRight(); if autoRightSetVisual then autoRightSetVisual(false) end end
            pcall(startBatAimbot)
        else stopBatAimbot() end
        if autoBatSetVisual then autoBatSetVisual(State.autoBatToggled) end
    elseif kbMatch(KB.AutoBatV2,kc) then
        State.autoBatV2Enabled = not State.autoBatV2Enabled
        if State.autoBatV2Enabled then
            if State.autoLeftEnabled then State.autoLeftEnabled=false; stopAutoLeft(); if autoLeftSetVisual then autoLeftSetVisual(false) end end
            if State.autoRightEnabled then State.autoRightEnabled=false; stopAutoRight(); if autoRightSetVisual then autoRightSetVisual(false) end end
            if State.autoBatToggled then State.autoBatToggled=false; stopBatAimbot(); if autoBatSetVisual then autoBatSetVisual(false) end end
            if startBatAimbotV2 then startBatAimbotV2() end
        else
            if stopBatAimbotV2 then stopBatAimbotV2() end
        end
        if autoBatV2SetVisual then autoBatV2SetVisual(State.autoBatV2Enabled) end
    elseif kbMatch(KB.TPBat,kc) then
        State._setTPBatEnabled(not State.tpBatEnabled)
        if State._tpBatSetVisual then State._tpBatSetVisual(State.tpBatEnabled) end
        if State._tpBatConfigSetVisual then State._tpBatConfigSetVisual(State.tpBatEnabled) end
        if State.requestConfigSave then State.requestConfigSave() end
    elseif kbMatch(KB.InstaReset,kc) then
        task.spawn(cursedInstaReset)
        if btnInstaReset and btnInstaReset.Parent then
            btnInstaReset:SetAttribute("PurpleFlash", true)
            task.delay(0.35, function() if btnInstaReset and btnInstaReset.Parent then btnInstaReset:SetAttribute("PurpleFlash", false) end end)
        end
        if setInstaToggleVisual then
            setInstaToggleVisual(true)
            task.delay(0.2, function() if setInstaToggleVisual then setInstaToggleVisual(false) end end)
        end
    elseif kbMatch(KB.GuiHide,kc) then
        State.guiVisible=not State.guiVisible
        pcall(function() main.Visible=State.guiVisible end)
        pcall(function() mini.Visible=not State.guiVisible end)
    end
    if State.requestConfigSave then State.requestConfigSave() end
end)
loadPresetsFile()
task.spawn(function()
    local lastPresetName = loadLastPresetName()
    if lastPresetName and lastPresetName ~= "" then
        for _, preset in ipairs(Presets) do
            if preset.name == lastPresetName then
                pcall(function() applyPreset(preset.data) end)
                break
            end
        end
    end
    task.wait(0.2); local loaded = loadConfig(); task.wait(0.5)
    if not loaded and State._allowInitialConfigCreation then pcall(saveConfig) end
end)
-- PERSISTENCE WATCH: save any changed state automatically, even if a control
-- forgot to call requestConfigSave(). This is deliberately short and only
-- writes when the config is marked dirty.
task.spawn(function()
    while task.wait(0.5) do
        if State._configLoaded and not State._configLoading and State._configDirty and not State._saveInProgress then
            pcall(saveConfig)
        end
    end
end)

Players.LocalPlayer.AncestryChanged:Connect(function(_, parent)
    if parent == nil and State._configLoaded and not State._configLoadFailed then
        if State._configDirty then pcall(saveConfig) end
        if State._positionDirty and State.savePositionBackup then pcall(State.savePositionBackup) end
    end
end)
pcall(function()
    game:BindToClose(function()
        if State._configLoaded and not State._configLoadFailed then
            if State._configDirty then pcall(saveConfig) end
            if State._positionDirty and State.savePositionBackup then pcall(State.savePositionBackup) end
        end
    end)
end)
print("[ ZeyHubb.vs] Loaded! SAVE CONFIG v9 = direct single-file save")
end)()
end)()
do
    local ok_env = pcall(function() return game and game.IsLoaded end)
    if not ok_env then return end
    repeat task.wait() until game:IsLoaded()
    local Players            = game:GetService("Players"); local UserInputService   = game:GetService("UserInputService"); local HttpService        = game:GetService("HttpService")
    local local_player = Players.LocalPlayer
    if not local_player then return end
    local CONFIG = {
        ConfigFile        = "FilthyHubInstaReset_Settings.json",
        AutoResetEnabled  = true,
    }
    local GUID                 = "f888ee6e-c86d-46e1-93d7-0639d6635d42"; local reset_remote         = nil; local insta_reset_cooldown = false; local CurrentKeybind       = nil
    -- Auto-reset on death/respawn disabled.
    -- Manual Instant Reset remains available from its existing keybind/button.
    local autoResetEnabled     = false
    local humConnections       = {}
    local function disconnectHumConnections()
        for _, conn in ipairs(humConnections) do
            pcall(function() conn:Disconnect() end)
        end
        table.clear(humConnections)
    end
    local function findResetRemote()
        if reset_remote and reset_remote.Parent then
            return reset_remote
        end
        for _, desc in ipairs(game:GetDescendants()) do
            if desc:IsA("RemoteEvent") and type(desc.Name) == "string" and desc.Name:sub(1, 3) == "RE/" then
                reset_remote = desc
                return reset_remote
            end
        end
        return nil
    end
    local orig_fire
    pcall(function()
        if hookfunction and newcclosure then
            orig_fire = hookfunction(Instance.new("RemoteEvent").FireServer, newcclosure(function(self, ...)
                if not reset_remote and type(self.Name) == "string" and self.Name:sub(1, 3) == "RE/" then
                    reset_remote = self
                end
                return orig_fire(self, ...)
            end))
        end
    end)
    task.spawn(function()
        task.wait(3); findResetRemote()
    end)
    local function insta_reset()
        if insta_reset_cooldown then return end
        local remote = findResetRemote()
        if not remote then return end
        local old_char = local_player.Character
        if not old_char then return end
        insta_reset_cooldown = true
        task.spawn(function()
            local startedAt = tick()
            while local_player.Character == old_char and tick() - startedAt < 3 do
                pcall(function()
                    remote:FireServer(GUID, local_player, "balloon")
                end)
                task.wait()
            end
            task.wait(0.15); insta_reset_cooldown = false
        end)
    end
    -- IMPORTANT: do not call Instant Reset when the character dies or respawns.
    -- The game handles the normal respawn; Instant Reset is manual only.
    local function tryAutoReset()
        return
    end

    local function loadSettings()
        if not (readfile and isfile and isfile(CONFIG.ConfigFile)) then return end
        local ok, decoded = pcall(function()
            return HttpService:JSONDecode(readfile(CONFIG.ConfigFile))
        end)
        if ok and type(decoded) == "table" then
            if decoded.Keybind then
                pcall(function()
                    CurrentKeybind = Enum.KeyCode[decoded.Keybind]
                end)
            end
            -- Ignore the old AutoResetEnabled setting: death/respawn auto-reset is disabled.
            autoResetEnabled = false
        end
    end
    local function saveSettings()
        if not writefile then return end
        local data = {
            Keybind          = CurrentKeybind and CurrentKeybind.Name or nil,
            AutoResetEnabled = autoResetEnabled,
        }
        pcall(function()
            writefile(CONFIG.ConfigFile, HttpService:JSONEncode(data))
        end)
    end
    loadSettings()
    local env = (getgenv and getgenv()) or _G
    env.FilthyInstaReset = {
        Fire = insta_reset,
        SetAuto = function(v)
            autoResetEnabled = v and true or false; saveSettings()
        end,
        GetAuto = function() return autoResetEnabled end,
        SetKeybind = function(kc)
            if typeof(kc) == "EnumItem" then
                CurrentKeybind = kc
                saveSettings()
            end
        end,
        GetKeybind = function() return CurrentKeybind end,
    }
    UserInputService.InputBegan:Connect(function(inp, gp)
        if gp then return end
        if CurrentKeybind
            and inp.UserInputType == Enum.UserInputType.Keyboard
            and inp.KeyCode == CurrentKeybind
        then
            insta_reset()
        end
    end)
    -- No death/respawn hooks here: they must never trigger Instant Reset.
    print("[FILTHY HUB] Insta Reset Auto carregado no ZeyHubb.vs v2")
end
do
    local Players       = game:GetService("Players"); local RunService    = game:GetService("RunService"); local HttpService   = game:GetService("HttpService")
    local LP            = Players.LocalPlayer
    local selectedAnimationPack = "OFF"; local unwalkEnabled         = false; local unwalkSavedAnimate    = nil; local hitHarderAnimEnabled  = false
    local OriginalAnims         = {}
    local AnimationPacks = {
        ["Zombie"]    = { idle = {{"rbxassetid://616158929",1},{"rbxassetid://616158929",1}}, walk="rbxassetid://616168032", run="rbxassetid://616163682", jump="rbxassetid://616161997", fall="rbxassetid://616157476", climb="rbxassetid://616156119" },
        ["Ninja"]     = { idle = {{"rbxassetid://656117400",1},{"rbxassetid://656117400",1}}, walk="rbxassetid://656121766", run="rbxassetid://656118852", jump="rbxassetid://656117878", fall="rbxassetid://656115606", climb="rbxassetid://656114359" },
        ["Knight"]    = { idle = {{"rbxassetid://657595757",1},{"rbxassetid://657595757",1}}, walk="rbxassetid://657552124", run="rbxassetid://657564596", jump="rbxassetid://658409194", fall="rbxassetid://657600338", climb="rbxassetid://658360781" },
        ["Elder"]     = { idle = {{"rbxassetid://845397899",1},{"rbxassetid://845397899",1}}, walk="rbxassetid://845403856", run="rbxassetid://845386501", jump="rbxassetid://845398858", fall="rbxassetid://845397673", climb="rbxassetid://845392038" },
        ["Levitate"]  = { idle = {{"rbxassetid://616006778",1},{"rbxassetid://616006778",1}}, walk="rbxassetid://616013216", run="rbxassetid://616013216", jump="rbxassetid://616008936", fall="rbxassetid://616005863", climb="rbxassetid://616003713" },
        ["Astronaut"] = { idle = {{"rbxassetid://891621366",1},{"rbxassetid://891621366",1}}, walk="rbxassetid://891636393", run="rbxassetid://891636393", jump="rbxassetid://891627522", fall="rbxassetid://891617961", climb="rbxassetid://891609353" },
        ["Pirate"]    = { idle = {{"rbxassetid://750781874",1},{"rbxassetid://750781874",1}}, walk="rbxassetid://750785693", run="rbxassetid://750783738", jump="rbxassetid://750782230", fall="rbxassetid://750780242", climb="rbxassetid://750779899" },
        ["Toy"]       = { idle = {{"rbxassetid://782841498",1},{"rbxassetid://782841498",1}}, walk="rbxassetid://782843345", run="rbxassetid://782842708", jump="rbxassetid://782847020", fall="rbxassetid://782846423", climb="rbxassetid://782843869" },
        ["Vampire"]   = { idle = {{"rbxassetid://1083445855",1},{"rbxassetid://1083445855",1}}, walk="rbxassetid://1083473930", run="rbxassetid://1083462077", jump="rbxassetid://1083455352", fall="rbxassetid://1083443587", climb="rbxassetid://1083439238" },
        ["Werewolf"]  = { idle = {{"rbxassetid://1083195517",1},{"rbxassetid://1083195517",1}}, walk="rbxassetid://1083178339", run="rbxassetid://1083216690", jump="rbxassetid://1083218792", fall="rbxassetid://1083189019", climb="rbxassetid://1083182000" },
        ["Rthro"]     = { idle = {{"rbxassetid://2510196951",1},{"rbxassetid://2510196951",1}}, walk="rbxassetid://2510202577", run="rbxassetid://2510198475", jump="rbxassetid://2510197830", fall="rbxassetid://2510195892", climb="rbxassetid://2510192778" },
        ["Stylish"]   = { idle = {{"rbxassetid://616136790",1},{"rbxassetid://616136790",1}}, walk="rbxassetid://616146177", run="rbxassetid://616140816", jump="rbxassetid://616139451", fall="rbxassetid://616134815", climb="rbxassetid://616133594" },
        ["Adidas Sports"] = { idle = {{"rbxassetid://18537376492",1},{"rbxassetid://18537371272",1}}, walk="rbxassetid://18537392113", run="rbxassetid://18537384940", jump="rbxassetid://18537380791", fall="rbxassetid://18537367238", climb="rbxassetid://18537363391" },
        ["Adidas Community"] = { idle = {{"rbxassetid://122257458498464",1},{"rbxassetid://102357151005774",1}}, walk="rbxassetid://122150855457006", run="rbxassetid://82598234841035", jump="rbxassetid://75290611992385", fall="rbxassetid://98600215928904", climb="rbxassetid://88763136693023" },
        ["Adidas Aura"] = { idle = {{"rbxassetid://110211186840347",1},{"rbxassetid://114191137265065",1}}, walk="rbxassetid://83842218823011", run="rbxassetid://118320322718866", jump="rbxassetid://109996626521204", fall="rbxassetid://95603166884636", climb="rbxassetid://97824616490448" },
        ["Wicked Popular"] = { idle = {{"rbxassetid://118832222982049",1},{"rbxassetid://76049494037641",1}}, walk="rbxassetid://92072849924640", run="rbxassetid://72301599441680", jump="rbxassetid://104325245285198", fall="rbxassetid://121152442762481", climb="rbxassetid://131326830509784" },
        ["Wicked Dancing"] = { idle = {{"rbxassetid://92849173543269",1},{"rbxassetid://132238900951109",1}}, walk="rbxassetid://73718308412641", run="rbxassetid://135515454877967", jump="rbxassetid://78508480717326", fall="rbxassetid://78147885297412", climb="rbxassetid://129447497744818" },
        ["Catwalk Glam"] = { idle = {{"rbxassetid://133806214992291",1},{"rbxassetid://94970088341563",1}}, walk="rbxassetid://109168724482748", run="rbxassetid://81024476153754", jump="rbxassetid://116936326516985", fall="rbxassetid://92294537340807", climb="rbxassetid://119377220967554" },
        ["Amazon Unboxed"] = { idle = {{"rbxassetid://98281136301627",1},{"rbxassetid://98281136301627",1}}, walk="rbxassetid://90478085024465", run="rbxassetid://134824450619865", jump="rbxassetid://121454505477205", fall="rbxassetid://94788218468396", climb="rbxassetid://121145883950231" },
        ["No Boundaries"] = { idle = {{"rbxassetid://18747067405",1},{"rbxassetid://18747063918",1}}, walk="rbxassetid://18747074203", run="rbxassetid://18747070484", jump="rbxassetid://18747069148", fall="rbxassetid://18747062535", climb="rbxassetid://18747060903" },
        ["NFL"]         = { idle = {{"rbxassetid://92080889861410",1},{"rbxassetid://74451233229259",1}}, walk="rbxassetid://110358958299415", run="rbxassetid://117333533048078", jump="rbxassetid://119846112151352", fall="rbxassetid://129773241321032", climb="rbxassetid://134630013742019" },
        ["Mage"]        = { idle = {{"rbxassetid://10921144709",1},{"rbxassetid://10921145797",1}}, walk="rbxassetid://10921152678", run="rbxassetid://10921148209", jump="rbxassetid://10921149743", fall="rbxassetid://10921148939", climb="rbxassetid://10921143404" },
        ["Superhero"]   = { idle = {{"rbxassetid://10921288909",1},{"rbxassetid://10921290167",1}}, walk="rbxassetid://10921298616", run="rbxassetid://10921291831", jump="rbxassetid://10921294559", fall="rbxassetid://10921293373", climb="rbxassetid://10921286911" },
        ["Robot"]       = { idle = {{"rbxassetid://616088211",1},{"rbxassetid://616089559",1}}, walk="rbxassetid://616095330", run="rbxassetid://616091570", jump="rbxassetid://616090535", fall="rbxassetid://616087089", climb="rbxassetid://616086039" },
        ["Bubbly"]      = { idle = {{"rbxassetid://910004836",1},{"rbxassetid://910009958",1}}, walk="rbxassetid://910034870", run="rbxassetid://910025107", jump="rbxassetid://910016857", fall="rbxassetid://910001910", climb="rbxassetid://909997997" },
        ["Cartoon"]     = { idle = {{"rbxassetid://742637544",1},{"rbxassetid://742638445",1}}, walk="rbxassetid://742640026", run="rbxassetid://742638842", jump="rbxassetid://742637942", fall="rbxassetid://742637151", climb="rbxassetid://742636889" },
        ["Normal"]      = { idle = {{"rbxassetid://507766388",1},{"rbxassetid://507766666",1}}, walk="rbxassetid://507777826", run="rbxassetid://507767714", jump="rbxassetid://507765000", fall="rbxassetid://507767968", climb="rbxassetid://507765644" },
    }
    local AnimationPackList = {"OFF","Unwalk","Hit Harder","Zombie","Ninja","Knight","Elder","Levitate","Astronaut","Pirate","Toy","Vampire","Werewolf","Rthro","Stylish","Adidas Sports","Adidas Community","Adidas Aura","Wicked Popular","Wicked Dancing","Catwalk Glam","Amazon Unboxed","No Boundaries","NFL","Mage","Superhero","Robot","Bubbly","Cartoon","Normal"}; local AnimationPackIndex = 1
    local HIT_HARDER_ANIMS = {
        idle1 = "rbxassetid://133806214992291",
        idle2 = "rbxassetid://94970088341563",
        walk  = "rbxassetid://707897309",
        run   = "rbxassetid://707861613",
        jump  = "rbxassetid://116936326516985",
        fall  = "rbxassetid://116936326516985",
    }
    local enableUnwalk, disableUnwalk, enableHitHarderAnim, disableHitHarderAnim, applyAnimationPack
    local function getAnimate(char)
        char = char or LP.Character
        return char and char:FindFirstChild("Animate") or nil
    end
    local function stopCurrentAnimations(char)
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if not hum then return end
        for _, track in ipairs(hum:GetPlayingAnimationTracks()) do
            pcall(function() track:Stop(0) end)
        end
    end
    local function backupAnimations(char)
        local animate = getAnimate(char)
        if not animate or next(OriginalAnims) ~= nil then return end
        local function getId(o) return o and o.AnimationId or nil end
        OriginalAnims = {
            idle1 = getId(animate.idle and animate.idle:FindFirstChild("Animation1")),
            idle2 = getId(animate.idle and animate.idle:FindFirstChild("Animation2")),
            walk  = getId(animate.walk and animate.walk:FindFirstChild("WalkAnim")),
            run   = getId(animate.run  and animate.run:FindFirstChild("RunAnim")),
            jump  = getId(animate.jump and animate.jump:FindFirstChild("JumpAnim")),
            fall  = getId(animate.fall and animate.fall:FindFirstChild("FallAnim")),
            climb = getId(animate.climb and animate.climb:FindFirstChild("ClimbAnim")),
        }
    end
    local function setAnimId(obj, id)
        if obj and id then pcall(function() obj.AnimationId = id end) end
    end
    local function reloadAnimate(animate)
        if not animate then return end
        pcall(function()
            animate.Disabled = true; task.wait(); animate.Disabled = false
        end)
    end
    local function resetAnimations()
        local char = LP.Character
        local animate = getAnimate(char)
        if not animate or next(OriginalAnims) == nil then return end
        stopCurrentAnimations(char); setAnimId(animate.idle and animate.idle:FindFirstChild("Animation1"), OriginalAnims.idle1); setAnimId(animate.idle and animate.idle:FindFirstChild("Animation2"), OriginalAnims.idle2); setAnimId(animate.walk and animate.walk:FindFirstChild("WalkAnim"),   OriginalAnims.walk)
        setAnimId(animate.run  and animate.run:FindFirstChild("RunAnim"),     OriginalAnims.run); setAnimId(animate.jump and animate.jump:FindFirstChild("JumpAnim"),   OriginalAnims.jump); setAnimId(animate.fall and animate.fall:FindFirstChild("FallAnim"),   OriginalAnims.fall); setAnimId(animate.climb and animate.climb:FindFirstChild("ClimbAnim"),OriginalAnims.climb)
        reloadAnimate(animate)
    end
    enableUnwalk = function()
        unwalkEnabled = true
        local char = LP.Character
        local animate = getAnimate(char)
        if animate then
            if not unwalkSavedAnimate then unwalkSavedAnimate = animate:Clone() end
            stopCurrentAnimations(char); animate:Destroy()
        end
    end
    disableUnwalk = function()
        unwalkEnabled = false
        local char = LP.Character
        if char and not char:FindFirstChild("Animate") and unwalkSavedAnimate then
            local newAnimate = unwalkSavedAnimate:Clone()
            newAnimate.Parent = char
        end
    end
    enableHitHarderAnim = function()
        hitHarderAnimEnabled = true
        local char = LP.Character
        local animate = getAnimate(char)
        if not animate then return end
        backupAnimations(char); stopCurrentAnimations(char); setAnimId(animate.idle and animate.idle:FindFirstChild("Animation1"), HIT_HARDER_ANIMS.idle1); setAnimId(animate.idle and animate.idle:FindFirstChild("Animation2"), HIT_HARDER_ANIMS.idle2)
        setAnimId(animate.walk and animate.walk:FindFirstChild("WalkAnim"),   HIT_HARDER_ANIMS.walk); setAnimId(animate.run  and animate.run:FindFirstChild("RunAnim"),     HIT_HARDER_ANIMS.run); setAnimId(animate.jump and animate.jump:FindFirstChild("JumpAnim"),   HIT_HARDER_ANIMS.jump); setAnimId(animate.fall and animate.fall:FindFirstChild("FallAnim"),   HIT_HARDER_ANIMS.fall)
        reloadAnimate(animate)
    end
    disableHitHarderAnim = function()
        hitHarderAnimEnabled = false; resetAnimations()
    end
    applyAnimationPack = function(packName)
        selectedAnimationPack = packName or "OFF"
        if selectedAnimationPack ~= "Unwalk" and unwalkEnabled then disableUnwalk() end
        if selectedAnimationPack ~= "Hit Harder" and hitHarderAnimEnabled then
            hitHarderAnimEnabled = false; resetAnimations()
        end
        if selectedAnimationPack == "Unwalk" then
            resetAnimations(); enableUnwalk()
            return
        end
        if selectedAnimationPack == "Hit Harder" then
            disableUnwalk(); enableHitHarderAnim()
            return
        end
        if selectedAnimationPack == "OFF" then
            resetAnimations()
            return
        end
        local pack = AnimationPacks[selectedAnimationPack]
        local char = LP.Character
        local animate = getAnimate(char)
        if not pack or not animate then return end
        backupAnimations(char); stopCurrentAnimations(char); setAnimId(animate.idle and animate.idle:FindFirstChild("Animation1"), pack.idle[1][1]); setAnimId(animate.idle and animate.idle:FindFirstChild("Animation2"), pack.idle[2][1])
        setAnimId(animate.walk and animate.walk:FindFirstChild("WalkAnim"),   pack.walk); setAnimId(animate.run  and animate.run:FindFirstChild("RunAnim"),     pack.run); setAnimId(animate.jump and animate.jump:FindFirstChild("JumpAnim"),   pack.jump); setAnimId(animate.fall and animate.fall:FindFirstChild("FallAnim"),   pack.fall)
        setAnimId(animate.climb and animate.climb:FindFirstChild("ClimbAnim"),pack.climb); reloadAnimate(animate)
    end
    local function syncIndex()
        for i, n in ipairs(AnimationPackList) do
            if n == selectedAnimationPack then AnimationPackIndex = i return end
        end
        AnimationPackIndex = 1
    end
    local SAVE_FILE = "PrimeAnimationPack.json"
    local function saveConfig()
        if not writefile then return end
        pcall(function()
            writefile(SAVE_FILE, HttpService:JSONEncode({ pack = selectedAnimationPack }))
        end)
    end
    local function loadConfig()
        if not (readfile and isfile and isfile(SAVE_FILE)) then return end
        pcall(function()
            local data = HttpService:JSONDecode(readfile(SAVE_FILE))
            if data and data.pack then selectedAnimationPack = data.pack end
        end)
    end
    loadConfig(); syncIndex()
    local function onCharacter(char)
        OriginalAnims = {}; unwalkSavedAnimate = nil; task.wait(0.5)
        if selectedAnimationPack ~= "OFF" then applyAnimationPack(selectedAnimationPack) end
    end
    LP.CharacterAdded:Connect(onCharacter)
    if LP.Character then task.spawn(onCharacter, LP.Character) end
    local api = {}
    function api:Set(name)
        applyAnimationPack(name); syncIndex(); saveConfig()
        return selectedAnimationPack
    end
    function api:Next()
        AnimationPackIndex = (AnimationPackIndex % #AnimationPackList) + 1
        return self:Set(AnimationPackList[AnimationPackIndex])
    end
    function api:Prev()
        AnimationPackIndex = AnimationPackIndex - 1
        if AnimationPackIndex < 1 then AnimationPackIndex = #AnimationPackList end
        return self:Set(AnimationPackList[AnimationPackIndex])
    end
    function api:Toggle()
        if selectedAnimationPack == "OFF" then
            return self:Set(AnimationPackList[2] or "Zombie")
        else
            return self:Set("OFF")
        end
    end
    function api:Get()  return selectedAnimationPack end
    function api:List() return table.clone(AnimationPackList) end
    local env = (getgenv and getgenv()) or _G
    env.PrimeAnimationPack = api
    env.applyAnimationPack = function(n) return api:Set(n) end
    env.nextAnimationPack  = function()  return api:Next() end
    env.prevAnimationPack  = function()  return api:Prev() end
    env.toggleAnimationPack= function()  return api:Toggle() end
end
do
    local Players     = game:GetService("Players"); local RunService  = game:GetService("RunService")
    local LP          = Players.LocalPlayer
    local RED         = Color3.fromRGB(76, 76, 76); local _ragCountdownRunning = false
    local function _getRagBillboard()
        local char = LP.Character
        if not char then return nil, nil end
        local head = char:FindFirstChild("Head")
        if not head then return nil, nil end
        local pGui = LP:FindFirstChildOfClass("PlayerGui") or LP.PlayerGui
        local existing = pGui:FindFirstChild("RagCountdownBillboard")
        if existing then existing:Destroy() end
        local bb = Instance.new("BillboardGui"); bb.Name = "RagCountdownBillboard"; bb.Size = UDim2.new(0, 84, 0, 42); bb.StudsOffset = Vector3.new(0, 0.5, 0)
        bb.AlwaysOnTop = true
        bb.Adornee = head
        bb.Parent = pGui
        local lbl = Instance.new("TextLabel"); lbl.Size = UDim2.new(1, 0, 1, 0); lbl.AnchorPoint = Vector2.new(0.5, 0.5); lbl.Position = UDim2.new(0.5, 0, 0.5, 0)
        lbl.BackgroundTransparency = 1
        lbl.Font = Enum.Font.GothamBlack
        lbl.TextScaled = true
        lbl.TextColor3 = RED
        lbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0); lbl.TextStrokeTransparency = 0; lbl.Text = ""
        lbl.Parent = bb
        return bb, lbl
    end
    local function _startRagCountdown()
        if _ragCountdownRunning then return end
        _ragCountdownRunning = true
        task.spawn(function()
            local bb, lbl = _getRagBillboard()
            if not bb then _ragCountdownRunning = false; return end
            local timeLeft = 2.5; local step     = 0.1
            while timeLeft > 0 and bb.Parent do
                if lbl and lbl.Parent then lbl.Text = string.format("%.1f", timeLeft) end
                task.wait(step)
                timeLeft = timeLeft - step
            end
            if bb and bb.Parent then
                if lbl and lbl.Parent then lbl.Text = "READY!" end
                task.wait(0.5)
                if bb and bb.Parent then bb:Destroy() end
            end
            _ragCountdownRunning = false
        end)
    end
    local _wasRagdolled = false
    local _humConn = nil
    local function _isRagState(st)
        return st == Enum.HumanoidStateType.Physics
            or st == Enum.HumanoidStateType.Ragdoll
            or st == Enum.HumanoidStateType.FallingDown
    end
    local function _hookCharacter(char)
        if _humConn then _humConn:Disconnect(); _humConn = nil end
        _wasRagdolled = false
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid") or char:WaitForChild("Humanoid", 5)
        if not hum then return end
        _humConn = hum.StateChanged:Connect(function(_, newState)
            if hum.Health <= 0 then _wasRagdolled = false; return end
            if _isRagState(newState) then
                if not _wasRagdolled then
                    _wasRagdolled = true
                    _startRagCountdown()
                end
            else
                _wasRagdolled = false
            end
        end)
        if _isRagState(hum:GetState()) and hum.Health > 0 then
            _wasRagdolled = true; _startRagCountdown()
        end
    end
    if LP.Character then _hookCharacter(LP.Character) end
    LP.CharacterAdded:Connect(_hookCharacter)
end

-- ============================================================
-- HEAD LABEL (DISCORD TAG)
-- ============================================================
do
    local _Players = game:GetService("Players")
    local _RunService = game:GetService("RunService")
    local _TweenService = game:GetService("TweenService")
    local DC_TAG = "FH2ONTOP"
    local TAG_COLOR = Color3.fromRGB(255, 255, 255)
    local _spdConns = {}

    -- Affiche le tag uniquement au-dessus du joueur local.
    local function setupHeadLabel(player, char)
        if player ~= _Players.LocalPlayer or not char then return end
        local head = char:WaitForChild("Head", 5)
        if not head then return end
        for _, v in ipairs(head:GetChildren()) do
            if v:IsA("BillboardGui") and v.Name == "PrimeBB" then v:Destroy() end
        end

        local bb = Instance.new("BillboardGui", head)
        bb.Name = "PrimeBB"
        bb.Size = UDim2.new(0, 180, 0, 46)
        bb.StudsOffset = Vector3.new(0, 3, 0)
        bb.AlwaysOnTop = true
        bb.ResetOnSpawn = false

        local spdLbl = Instance.new("TextLabel", bb)
        spdLbl.Name = "SpeedCounter"
        spdLbl.Size = UDim2.new(1, 0, 0.46, 0)
        spdLbl.Position = UDim2.new(0, 0, 0, -2)
        spdLbl.BackgroundTransparency = 1
        spdLbl.Text = "0"
        spdLbl.TextColor3 = TAG_COLOR
        spdLbl.Font = Enum.Font.GothamBlack
        spdLbl.TextScaled = true
        spdLbl.TextStrokeTransparency = 0.15
        spdLbl.TextStrokeColor3 = Color3.fromRGB(255, 255, 255)

        local tagLbl = Instance.new("TextLabel", bb)
        tagLbl.Name = "TagLabel"
        tagLbl.Size = UDim2.new(1, 0, 0.46, 0)
        tagLbl.Position = UDim2.new(0, 0, 0.54, 0)
        tagLbl.BackgroundTransparency = 1
        tagLbl.Text = DC_TAG
        tagLbl.TextColor3 = TAG_COLOR
        tagLbl.Font = Enum.Font.GothamBlack
        tagLbl.TextScaled = true
        tagLbl.TextStrokeTransparency = 0.05
        tagLbl.TextStrokeColor3 = Color3.fromRGB(255, 255, 255)

        -- Petit effet de brillance blanche pulsée.
        local glow = Instance.new("UIStroke")
        glow.Thickness = 1.5
        glow.Transparency = 0.15
        glow.Color = Color3.fromRGB(255, 255, 255)
        glow.Parent = tagLbl

        task.spawn(function()
            while tagLbl.Parent do
                local a = _TweenService:Create(tagLbl, TweenInfo.new(0.7, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
                    TextStrokeTransparency = 0.35
                })
                local b = _TweenService:Create(tagLbl, TweenInfo.new(0.7, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
                    TextStrokeTransparency = 0.02
                })
                a:Play(); a.Completed:Wait()
                if not tagLbl.Parent then break end
                b:Play(); b.Completed:Wait()
            end
        end)

        if _spdConns[player] then _spdConns[player]:Disconnect(); _spdConns[player] = nil end
        _spdConns[player] = _RunService.RenderStepped:Connect(function()
            if not spdLbl or not spdLbl.Parent then
                if _spdConns[player] then _spdConns[player]:Disconnect(); _spdConns[player] = nil end
                return
            end
            local c = player.Character
            local hrp = c and c:FindFirstChild("HumanoidRootPart")
            if not hrp then spdLbl.Text = "0"; return end
            spdLbl.Text = string.format("%.1f", Vector3.new(hrp.Velocity.X, 0, hrp.Velocity.Z).Magnitude)
        end)
    end

    local LP = _Players.LocalPlayer
    if LP.Character then task.spawn(setupHeadLabel, LP, LP.Character) end
    LP.CharacterAdded:Connect(function(char)
        task.wait(0.5)
        setupHeadLabel(LP, char)
    end)
end


-- WEEKLY AUTO GRAB — integrated into ZeyHubb
-- Uses the Auto Steal engine from the supplied weekly autograb file.
-- Starts automatically when ZeyHubb executes.

repeat task.wait() until game:IsLoaded()

-- MINIMAL STEAL STATE (from Done.lua, needed by the bar)
-- ============================================================
local Steal = {
	AutoStealEnabled=false, StealRadius=62, StealDuration=0.3,
	Mode="half", -- locked to half autograb
	HalfFireRange=10, HalfHoldMin=1.3, HalfHoldMax=2.6, HalfEntryDelay=0.3,
	Data={}
}

local _ZeyHubbEnv = (getgenv and getgenv()) or _G
_ZeyHubbEnv.__ZeyHubbSteal = Steal
local isStealing = false
local stealStartTime = nil
local autoConn = nil
local progressFill, progressPct

local function isMyPlotByName(plotName)
	local plots=workspace:FindFirstChild("Plots"); if not plots then return false end
	local plot=plots:FindFirstChild(plotName); if not plot then return false end
	local sign=plot:FindFirstChild("PlotSign")
	if sign then local yb=sign:FindFirstChild("YourBase"); if yb and yb:IsA("BillboardGui") then return yb.Enabled==true end end
	return false
end
local function findNearestPrompt()
	local char=LP.Character; if not char then return nil end
	local root=char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso")
	if not root then return nil end
	local plots=workspace:FindFirstChild("Plots"); if not plots then return nil end
	local nearest,dist=nil,math.huge
	for _,plot in ipairs(plots:GetChildren()) do
		if plot:IsA("Model") and not isMyPlotByName(plot.Name) then
			local pods=plot:FindFirstChild("AnimalPodiums")
			if pods then
				for _,pod in ipairs(pods:GetChildren()) do
					local base=pod:FindFirstChild("Base")
					local sp=base and base:FindFirstChild("Spawn")
					if sp then
						local d=(sp.Position-root.Position).Magnitude
						if d<=Steal.StealRadius and d<dist then
							local found=nil
							local att=sp:FindFirstChild("PromptAttachment")
							if att then for _,pr in ipairs(att:GetChildren()) do if pr:IsA("ProximityPrompt") and pr.ActionText and pr.ActionText:find("Steal") then found=pr end end end
							if not found then for _,pr in ipairs(sp:GetDescendants()) do if pr:IsA("ProximityPrompt") and pr.ActionText and pr.ActionText:find("Steal") then found=pr end end end
							if found then nearest,dist=found,d end
						end
					end
				end
			end
		end
	end
	return nearest
end
local function _promptDist(prompt)
	local char=LP.Character; if not char then return math.huge end
	local root=char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso")
	if not root then return math.huge end
	local part=prompt.Parent
	if part and part:IsA("Attachment") then part=part.Parent end
	if part and part:IsA("BasePart") then return (part.Position-root.Position).Magnitude end
	local ok,cf=pcall(function() return prompt.Parent and prompt.Parent.WorldPosition end)
	if ok and cf then return (cf-root.Position).Magnitude end
	return math.huge
end
local function executeSteal(prompt)
	if isStealing then return end
	if not Steal.Data[prompt] then
		Steal.Data[prompt]={hold={},trigger={},ready=true}
		if getconnections then
			for _,c in ipairs(getconnections(prompt.PromptButtonHoldBegan)) do if c.Function then table.insert(Steal.Data[prompt].hold,c.Function) end end
			for _,c in ipairs(getconnections(prompt.Triggered)) do if c.Function then table.insert(Steal.Data[prompt].trigger,c.Function) end end
		end
	end
	local data=Steal.Data[prompt]; if not data.ready then return end
	data.ready=false; isStealing=true; stealStartTime=tick()
	if Steal.Mode=="half" then
		task.spawn(function()
			for _,fn in ipairs(data.hold) do task.spawn(fn) end
			task.wait(Steal.HalfHoldMin)
			local inRange=_promptDist(prompt)<=Steal.HalfFireRange
			while true do
				local el=tick()-stealStartTime
				if el>Steal.HalfHoldMax or not prompt.Parent then break end
				if _promptDist(prompt)<=Steal.HalfFireRange then
					if not inRange then task.wait(Steal.HalfEntryDelay) end
					for _,fn in ipairs(data.trigger) do task.spawn(fn) end; break
				end
				task.wait()
			end
			task.wait(0.05); data.ready=true; isStealing=false
		end)
	else
		task.spawn(function()
			for _,fn in ipairs(data.hold) do task.spawn(fn) end
			local el=0; while el<Steal.StealDuration do el=el+task.wait() end
			for _,fn in ipairs(data.trigger) do task.spawn(fn) end
			task.wait(0.05); data.ready=true; isStealing=false
		end)
	end
end
local function startAutoSteal()
	if autoConn then return end
	autoConn=RunService.Heartbeat:Connect(function()
		if not Steal.AutoStealEnabled or isStealing then return end
		local p=findNearestPrompt(); if p then executeSteal(p) end
	end)
end
local function stopAutoSteal()
	if autoConn then autoConn:Disconnect(); autoConn=nil end
	isStealing=false
end
_G.AutoSteal = Steal

-- Start the weekly Auto Steal immediately alongside ZeyHubb.
Steal.AutoStealEnabled = true
pcall(startAutoSteal)

-- ============================================================
-- THE EXACT GUI (StealProgressGui from Done.lua)
-- ============================================================
do
	local _oldSPG = LP.PlayerGui:FindFirstChild("StealProgressScreenGui")
	if _oldSPG then _oldSPG:Destroy() end
	local spScreenGui=Instance.new("ScreenGui")
	spScreenGui.Name="StealProgressScreenGui";spScreenGui.ResetOnSpawn=false
	spScreenGui.DisplayOrder=200;spScreenGui.IgnoreGuiInset=true
	spScreenGui.ZIndexBehavior=Enum.ZIndexBehavior.Sibling
	spScreenGui.Parent=LP.PlayerGui

	local spFrame=Instance.new("Frame",spScreenGui)
	spFrame.Name="StealProgressGui"
	spFrame.Size=UDim2.new(0,220,0,18)
	spFrame.Position=UDim2.new(0.5,0,1,-90)
	spFrame.AnchorPoint=Vector2.new(0.5,1)
	spFrame.BackgroundColor3=Color3.fromRGB(45,12,30)
	spFrame.BorderSizePixel=0;spFrame.Active=true;spFrame.Visible=true
	spFrame.ZIndex=300;spFrame.ClipsDescendants=true

    local uiImage=Instance.new("ImageLabel",spFrame)
    uiImage.Name="ZeyHubbAutoStealImage"
    uiImage.BackgroundTransparency=1
    uiImage.Size=UDim2.new(1,0,1,0)
    uiImage.Position=UDim2.new(0,0,0,0)
    uiImage.Image="rbxassetid://139833886423731"
    uiImage.ScaleType=Enum.ScaleType.Crop
    uiImage.ImageTransparency=0.42
    uiImage.ZIndex=300
    Instance.new("UICorner",uiImage).CornerRadius=UDim.new(1,0)


    local statsLabel=Instance.new("TextLabel",spFrame)
    statsLabel.Name="FPSPing"
    statsLabel.BackgroundTransparency=1
    statsLabel.Size=UDim2.new(0,88,1,0)
    statsLabel.Position=UDim2.new(1,-94,0,0)
    statsLabel.Font=Enum.Font.GothamBold
    statsLabel.TextSize=8
    statsLabel.TextColor3=Color3.fromRGB(255,170,205)
    statsLabel.TextStrokeTransparency=0.55
    statsLabel.Text="FPS --  PING --ms"
    statsLabel.TextXAlignment=Enum.TextXAlignment.Right
    statsLabel.ZIndex=306

    task.spawn(function()
        local last=os.clock()
        local frames=0
        while statsLabel.Parent do
            frames=frames+1
            local now=os.clock()
            if now-last>=0.5 then
                local fps=math.floor(frames/(now-last)+0.5)
                frames=0
                last=now
                local ping="--"
                pcall(function()
                    local stats=game:GetService("Stats")
                    local network=stats:FindFirstChild("Network")
                    local serverStats=network and network:FindFirstChild("ServerStatsItem")
                    local item=serverStats and (serverStats:FindFirstChild("Data Ping") or serverStats:FindFirstChild("Ping"))
                    if item then
                        local ok,v=pcall(function() return item:GetValue() end)
                        if ok and type(v)=="number" then
                            ping=tostring(math.floor(v+0.5))
                        end
                    end
                end)
                statsLabel.Text="FPS "..fps.."  PING "..ping.."ms"
            end
            task.wait()
        end
    end)

	Instance.new("UICorner",spFrame).CornerRadius=UDim.new(1,0)
	local spBorder=Instance.new("UIStroke",spFrame)
	spBorder.Color=Color3.fromRGB(255,105,180);spBorder.Thickness=2;spBorder.ApplyStrokeMode=Enum.ApplyStrokeMode.Border

	local _spWasDragged=false
	local spToggleBtn=Instance.new("TextButton",spFrame)
	spToggleBtn.Name="ToggleGUIBtn";spToggleBtn.Size=UDim2.new(1,0,1,0)
	spToggleBtn.BackgroundTransparency=1;spToggleBtn.Text="";spToggleBtn.AutoButtonColor=false;spToggleBtn.ZIndex=310
	spToggleBtn.Activated:Connect(function()
		if _spWasDragged then return end
		local base=spFrame.Size
		TS:Create(spFrame,TweenInfo.new(0.08),{Size=UDim2.new(base.X.Scale,base.X.Offset*0.95,base.Y.Scale,base.Y.Offset*0.9)}):Play()
		task.delay(0.1,function() TS:Create(spFrame,TweenInfo.new(0.16,Enum.EasingStyle.Back),{Size=base}):Play() end)
		-- half autograb is always on; tap is cosmetic only
	end)

	-- whole-panel fill (the window IS the bar)
	local spFill=Instance.new("Frame",spFrame)
	spFill.Name="ProgressFill";spFill.Size=UDim2.new(0,0,1,-4);spFill.Position=UDim2.new(0,2,0,2)
	spFill.BackgroundColor3=Color3.fromRGB(255,105,180);spFill.BackgroundTransparency=0.15
	spFill.BorderSizePixel=0;spFill.ZIndex=301
	Instance.new("UICorner",spFill).CornerRadius=UDim.new(1,0)

	local spPct=Instance.new("TextLabel",spFrame)
	spPct.Size=UDim2.new(1,-100,1,0);spPct.Position=UDim2.new(0,8,0,0)
	spPct.BackgroundTransparency=1;spPct.Text="UNREADY";spPct.TextColor3=Color3.fromRGB(255,220,238)
	spPct.Font=Enum.Font.GothamBlack;spPct.TextSize=10;spPct.TextStrokeTransparency=0.15;spPct.TextStrokeColor3=Color3.fromRGB(75,10,45)
	spPct.TextXAlignment=Enum.TextXAlignment.Center;spPct.TextYAlignment=Enum.TextYAlignment.Center;spPct.ZIndex=304

	progressFill=spFill
	progressPct=spPct

	-- drive fill/label
	local _lastPct=0
	RunService.RenderStepped:Connect(function()
		if not spFrame.Visible then return end
		local pct=0
		if isStealing and stealStartTime then
			-- half mode fills over the hold-min window
			pct=math.clamp((tick()-stealStartTime)/math.max(Steal.HalfHoldMin,0.01),0,1)
		elseif Steal.AutoStealEnabled then
			pct=(findNearestPrompt() and 1 or 0)
		end
		_lastPct=_lastPct+(pct-_lastPct)*0.2
		local f=math.clamp(_lastPct,0,1)
		spFill.Size=UDim2.new(f,-4*f,1,-4)
		if _lastPct>=0.87 then spPct.Text="READY";spPct.TextColor3=Color3.fromRGB(255,150,205)
		else spPct.Text="UNREADY";spPct.TextColor3=Color3.fromRGB(255,220,238) end
	end)

	-- drag handling with off-screen clamp
	local dragging,dragStart,startPos=false,nil,nil
	spToggleBtn.InputBegan:Connect(function(inp)
		if inp.UserInputType==Enum.UserInputType.MouseButton1 or inp.UserInputType==Enum.UserInputType.Touch then
			dragging=true;_spWasDragged=false;dragStart=inp.Position;startPos=spFrame.Position
			inp.Changed:Connect(function() if inp.UserInputState==Enum.UserInputState.End then dragging=false end end)
		end
	end)
	UIS.InputChanged:Connect(function(inp)
		if not dragging then return end
		if inp.UserInputType==Enum.UserInputType.MouseMovement or inp.UserInputType==Enum.UserInputType.Touch then
			local dx=inp.Position.X-dragStart.X
			local dy=inp.Position.Y-dragStart.Y
			if math.abs(dx)>5 or math.abs(dy)>5 then _spWasDragged=true end
			local cam=workspace.CurrentCamera
			local vp=cam and cam.ViewportSize or Vector2.new(1000,1000)
			local sz=spFrame.AbsoluteSize
			local newXScalePx=startPos.X.Scale*vp.X
			local newX=math.clamp(newXScalePx+startPos.X.Offset+dx,sz.X/2,vp.X-sz.X/2)
			local newY=math.clamp(startPos.Y.Scale*vp.Y+startPos.Y.Offset+dy,sz.Y,vp.Y)
			spFrame.Position=UDim2.new(startPos.X.Scale,newX-newXScalePx,startPos.Y.Scale,newY-startPos.Y.Scale*vp.Y)
		end
	end)
	_G._CursedSetProgressBarVisible=function(v) spFrame.Visible=v end
end

-- half autograb always on
Steal.AutoStealEnabled=true
pcall(startAutoSteal)