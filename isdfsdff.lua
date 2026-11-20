local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- SETTINGS
local MUSIC_URL = "https://files.catbox.moe/odzm9m.mp3"
local MUSIC_FILE = "haz_duels_track.mp3"
local LOGO_URL = "https://files.catbox.moe/896zew.png"
local LOGO_FILE = "haz_duels_spinner_logo.png"

-- CLEANUP
local previous = playerGui:FindFirstChild("LocalCinematic")
if previous then previous:Destroy() end

-- LOAD AUDIO AND LOGO USING THE SAME EXECUTOR ASSET METHOD
local music
local musicOK, musicError = pcall(function()
    if not isfile(MUSIC_FILE) then
        writefile(MUSIC_FILE, game:HttpGet(MUSIC_URL))
    end

    music = Instance.new("Sound")
    music.Name = "HazDuelsMusic"
    music.SoundId = getcustomasset(MUSIC_FILE)
    music.Volume = 1
    music.Looped = false
    music.Parent = workspace
end)

if not musicOK then
    warn("HAZ DUELS music could not be loaded:", musicError)
end

local logoAsset
local logoOK, logoError = pcall(function()
    if not isfile(LOGO_FILE) then
        writefile(LOGO_FILE, game:HttpGet(LOGO_URL))
    end
    logoAsset = getcustomasset(LOGO_FILE)
end)

if not logoOK then
    warn("HAZ DUELS logo could not be loaded:", logoError)
end

-- GUI / VIEWPORT
local gui = Instance.new("ScreenGui")
gui.Name = "LocalCinematic"
gui.IgnoreGuiInset = true
gui.DisplayOrder = 999999
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Global
gui.Parent = playerGui

local background = Instance.new("Frame")
background.Name = "Background"
background.Size = UDim2.fromScale(1, 1)
background.BackgroundColor3 = Color3.fromRGB(3, 3, 7)
background.BorderSizePixel = 0
background.Parent = gui

local viewport = Instance.new("ViewportFrame")
viewport.Name = "Scene"
viewport.Size = UDim2.fromScale(1, 1)
viewport.BackgroundTransparency = 1
viewport.Ambient = Color3.fromRGB(150, 135, 145)
viewport.LightColor = Color3.fromRGB(255, 225, 210)
viewport.LightDirection = Vector3.new(-1, -2, -1)
viewport.Parent = background

local world = Instance.new("WorldModel")
world.Parent = viewport

local camera = Instance.new("Camera")
camera.FieldOfView = 45
camera.Parent = viewport
viewport.CurrentCamera = camera

local function makePart(name, size, position, color, parent)
    local p = Instance.new("Part")
    p.Name = name
    p.Size = size
    p.Position = position
    p.Anchored = true
    p.CanCollide = false
    p.Color = color
    p.Material = Enum.Material.SmoothPlastic
    p.TopSurface = Enum.SurfaceType.Smooth
    p.BottomSurface = Enum.SurfaceType.Smooth
    p.Parent = parent or world
    return p
end

local function tween(object, duration, properties, style)
    local t = TweenService:Create(
        object,
        TweenInfo.new(duration, style or Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        properties
    )
    t:Play()
    return t
end

local finished = false
local function finish()
    if finished then return end
    finished = true
    if music then
        tween(music, 0.5, {Volume = 0})
        task.wait(0.55)
        music:Stop()
        music:Destroy()
    end
    gui:Destroy()
end

-- CHESS SCENE
makePart("Floor", Vector3.new(200, 1, 200), Vector3.new(0, -0.7, 0), Color3.fromRGB(12, 9, 15))
makePart("ChessTable", Vector3.new(11, 0.7, 8), Vector3.new(0, 2, 0), Color3.fromRGB(35, 20, 23))

for x = 1, 8 do
    for z = 1, 8 do
        local light = (x + z) % 2 == 0
        makePart(
            "Square",
            Vector3.new(1, 0.12, 1),
            Vector3.new(x - 4.5, 2.42, z - 4.5),
            light and Color3.fromRGB(220, 195, 175) or Color3.fromRGB(55, 30, 38)
        )
    end
end

local function makePiece(name, x, z, color)
    local px, pz = x - 4.5, z - 4.5
    local model = {}
    model.Base = makePart(name .. "Base", Vector3.new(0.65, 0.2, 0.65), Vector3.new(px, 2.58, pz), color)
    model.Stem = makePart(name .. "Stem", Vector3.new(0.32, 0.65, 0.32), Vector3.new(px, 3, pz), color)
    model.Top = makePart(name .. "Top", Vector3.new(0.55, 0.3, 0.55), Vector3.new(px, 3.45, pz), color)
    return model
end

local white = Color3.fromRGB(235, 220, 205)
local black = Color3.fromRGB(20, 15, 20)
for x = 1, 8 do
    makePiece("WhitePawn" .. x, x, 7, white)
    makePiece("BlackPawn" .. x, x, 2, black)
end
local whiteQueen = makePiece("WhiteQueen", 4, 8, white)
local blackKing = makePiece("BlackKing", 5, 1, black)

-- Letterbox bars
local topBar = Instance.new("Frame")
topBar.Size = UDim2.fromScale(1, 0.085)
topBar.BackgroundColor3 = Color3.new(0, 0, 0)
topBar.BorderSizePixel = 0
topBar.ZIndex = 5
topBar.Parent = background

local bottomBar = Instance.new("Frame")
bottomBar.Position = UDim2.fromScale(0, 0.915)
bottomBar.Size = UDim2.fromScale(1, 0.085)
bottomBar.BackgroundColor3 = Color3.new(0, 0, 0)
bottomBar.BorderSizePixel = 0
bottomBar.ZIndex = 5
bottomBar.Parent = background

-- The only text shown during the entire intro.
local checkmate = Instance.new("TextLabel")
checkmate.Name = "Checkmate"
checkmate.AnchorPoint = Vector2.new(0.5, 0.5)
checkmate.Position = UDim2.fromScale(0.5, 0.5)
checkmate.Size = UDim2.fromScale(0.8, 0.18)
checkmate.BackgroundTransparency = 1
checkmate.Text = "CHECKMATE"
checkmate.TextColor3 = Color3.fromRGB(255, 242, 232)
checkmate.TextTransparency = 1
checkmate.TextScaled = true
checkmate.Font = Enum.Font.GothamBlack
checkmate.TextStrokeColor3 = Color3.fromRGB(70, 8, 18)
checkmate.TextStrokeTransparency = 1
checkmate.ZIndex = 100
checkmate.Visible = true
checkmate.Parent = background

local function cameraTo(position, target, duration)
    if finished then return end
    local t = tween(camera, duration, {CFrame = CFrame.lookAt(position, target)}, Enum.EasingStyle.Sine)
    t.Completed:Wait()
end

local function movePiece(piece, offset, duration)
    for _, part in pairs(piece) do
        tween(part, duration, {Position = part.Position + offset}, Enum.EasingStyle.Back)
    end
end

-- SEQUENCE
task.spawn(function()
    task.wait(0.5)
    if finished then return end

    camera.CFrame = CFrame.lookAt(Vector3.new(0, 8, 18), Vector3.new(0, 2.5, 0))
    cameraTo(Vector3.new(0, 6, 13), Vector3.new(0, 2.5, 0), 2)
    if finished then return end

    cameraTo(Vector3.new(-5, 5, 7), Vector3.new(-1, 3, 0), 1.5)
    movePiece(whiteQueen, Vector3.new(3, 0, -5), 1.1)
    task.wait(1.2)
    if finished then return end

    cameraTo(Vector3.new(0, 4, 8), Vector3.new(0, 3, 0), 0.8)

    -- Tip the king over as the checkmate moment lands.
    for _, part in pairs(blackKing) do
        tween(part, 0.5, {
            CFrame = part.CFrame * CFrame.Angles(0, 0, math.rad(80))
        })
    end

    checkmate.TextTransparency = 1
    checkmate.TextStrokeTransparency = 1
    checkmate.Visible = true
    checkmate.TextTransparency = 0
    checkmate.TextStrokeTransparency = 0.15
    task.wait(2.0)
    if finished then return end
    tween(checkmate, 0.35, {TextTransparency = 1, TextStrokeTransparency = 1})

    -- Transition to the avatar montage.
    local flash = Instance.new("Frame")
    flash.Size = UDim2.fromScale(1, 1)
    flash.BackgroundColor3 = Color3.fromRGB(180, 0, 25)
    flash.BorderSizePixel = 0
    flash.ZIndex = 30
    flash.Parent = background
    tween(flash, 0.8, {BackgroundTransparency = 1})
    task.wait(0.8)
    flash:Destroy()
    if finished then return end

    -- Hide the chess scene before showing the HAZ DUELS loading screen.
    for _, object in ipairs(world:GetDescendants()) do
        if object:IsA("BasePart") then
            object.Transparency = 1
        end
    end
    viewport.Visible = false

    local loading = Instance.new("Frame")
    loading.Name = "HazDuelsLoading"
    loading.Size = UDim2.fromScale(1, 1)
    loading.BackgroundColor3 = Color3.fromRGB(7, 6, 12)
    loading.BackgroundTransparency = 1
    loading.BorderSizePixel = 0
    loading.ZIndex = 200
    loading.Parent = background
    tween(loading, 0.45, {BackgroundTransparency = 0})

    -- Centered logo: approximately 30% of the screen width.
    local logo = Instance.new("ImageLabel")
    logo.Name = "Logo"
    logo.AnchorPoint = Vector2.new(0.5, 0.5)
    logo.Position = UDim2.fromScale(0.5, 0.39)
    logo.Size = UDim2.fromScale(0.30, 0.30)
    logo.BackgroundTransparency = 1
    logo.ScaleType = Enum.ScaleType.Fit
    logo.ZIndex = 202
    if logoAsset then
        logo.Image = logoAsset
    end
    logo.Parent = loading


    -- Circular crop and continuous spin for the loading logo.
    local logoCorner = Instance.new("UICorner")
    logoCorner.CornerRadius = UDim.new(1, 0)
    logoCorner.Parent = logo

    -- Purple circular outline around the spinning logo.
    local logoOutline = Instance.new("UIStroke")
    logoOutline.Color = Color3.fromRGB(160, 70, 255)
    logoOutline.Thickness = 3
    logoOutline.Transparency = 0
    logoOutline.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    logoOutline.Parent = logo


    task.spawn(function()
        while logo.Parent do
            local spin = tween(logo, 1.8, {Rotation = logo.Rotation + 360})
            spin.Completed:Wait()
        end
    end)


    local title = Instance.new("TextLabel")
    title.Name = "HazDuelsTitle"
    title.AnchorPoint = Vector2.new(0.5, 0.5)
    title.Position = UDim2.fromScale(0.5, 0.64)
    title.Size = UDim2.fromScale(0.62, 0.10)
    title.BackgroundTransparency = 1
    title.Text = "HAZ DUELS"
    title.Font = Enum.Font.GothamBlack
    title.TextScaled = true
    title.TextColor3 = Color3.new(1, 1, 1)
    title.ZIndex = 203
    title.Parent = loading

    local rainbow = Instance.new("UIGradient")
    rainbow.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 55, 85)),
        ColorSequenceKeypoint.new(0.17, Color3.fromRGB(255, 170, 55)),
        ColorSequenceKeypoint.new(0.34, Color3.fromRGB(245, 240, 70)),
        ColorSequenceKeypoint.new(0.51, Color3.fromRGB(65, 235, 130)),
        ColorSequenceKeypoint.new(0.68, Color3.fromRGB(65, 175, 255)),
        ColorSequenceKeypoint.new(0.84, Color3.fromRGB(160, 90, 255)),
        ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 75, 190))
    })
    rainbow.Parent = title

    local percent = Instance.new("TextLabel")
    percent.Name = "Percent"
    percent.AnchorPoint = Vector2.new(0.5, 0.5)
    percent.Position = UDim2.fromScale(0.5, 0.77)
    percent.Size = UDim2.fromScale(0.22, 0.045)
    percent.BackgroundTransparency = 1
    percent.Text = "1%"
    percent.TextColor3 = Color3.fromRGB(235, 230, 245)
    percent.TextScaled = true
    percent.Font = Enum.Font.GothamMedium
    percent.ZIndex = 203
    percent.Parent = loading

    local barBack = Instance.new("Frame")
    barBack.Name = "ProgressBarBackground"
    barBack.AnchorPoint = Vector2.new(0.5, 0.5)
    barBack.Position = UDim2.fromScale(0.5, 0.825)
    barBack.Size = UDim2.fromScale(0.34, 0.012)
    barBack.BackgroundColor3 = Color3.fromRGB(48, 43, 58)
    barBack.BorderSizePixel = 0
    barBack.ZIndex = 203
    barBack.Parent = loading

    local barCorner = Instance.new("UICorner")
    barCorner.CornerRadius = UDim.new(1, 0)
    barCorner.Parent = barBack

    local barFill = Instance.new("Frame")
    barFill.Name = "Progress"
    barFill.Size = UDim2.fromScale(0.01, 1)
    barFill.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    barFill.BorderSizePixel = 0
    barFill.ZIndex = 204
    barFill.Parent = barBack

    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(1, 0)
    fillCorner.Parent = barFill

    local fillGradient = Instance.new("UIGradient")
    fillGradient.Color = rainbow.Color
    fillGradient.Parent = barFill

    -- Music begins as the loading screen appears.
    if music then
        music:Play()
    end

    -- Animate progress from 1% to 100% over 20 seconds.
    -- If the song is longer, the screen stays at 100% until it finishes.
    local loadDuration = 20
    local startTime = os.clock()
    local progress = 1

    while progress < 100 and not finished do
        local alpha = math.clamp((os.clock() - startTime) / loadDuration, 0, 1)
        progress = math.clamp(math.floor(1 + alpha * 99), 1, 100)
        percent.Text = tostring(progress) .. "%"
        tween(barFill, 0.12, {Size = UDim2.fromScale(progress / 100, 1)})
        task.wait(0.12)
    end

    percent.Text = "100%"
    barFill.Size = UDim2.fromScale(1, 1)

    if music and music.IsPlaying then
        music.Ended:Wait()
    else
        task.wait(1.5)
    end

    finish()
end)