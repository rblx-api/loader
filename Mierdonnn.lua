if _G.K7DuelsRunning then
    warn("[K7 DUELS] Instancia previa detectada. Se recomienda rejoin si hay comportamiento errático.")
end
_G.K7DuelsRunning = false
_G.__K7DuelsMainOriginalPos = nil

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
    warn("[K7 DUELS] LocalPlayer no disponible en 15s. Abortando.")
    return
end

local pgui = LP:WaitForChild("PlayerGui", 20)
if not pgui then
    warn("[K7 DUELS] PlayerGui no cargó en 20s. Abortando.")
    return
end

local camera = Workspace.CurrentCamera

local SoundService = game:GetService("SoundService")

local K7Duels_REDRUM_URL = "https://file.garden/algLafWA1jk8WMfK/redrum_spotdown.org%202.mp3"
local K7Duels_REDRUM_FILE = "kryvox_redrum.mp3"
local K7Duels_INTRO_URL = "https://files.manuscdn.com/user_upload_by_module/session_file/310519663985446999/FCOFCJpdnOIMmXRC.mp3"
local K7Duels_INTRO_FILE = "hagalo_intro_phrase_start.mp3"
local kryvoxRedrumAsset = nil
local kryvoxFullRedrumSound = nil
local kryvoxMusicRequest = 0
local kryvoxMusicRefreshers = {}

local function getK7DuelsRedrumAsset()
    if kryvoxRedrumAsset then return kryvoxRedrumAsset end

    local assetLoader = getcustomasset or getsynasset
    if type(assetLoader) ~= "function" or type(writefile) ~= "function" then
        return nil, "custom asset functions unavailable"
    end

    local exists = false
    if type(isfile) == "function" then
        local okExists, result = pcall(isfile, K7Duels_REDRUM_FILE)
        exists = okExists and result == true
    end

    if not exists then
        local okDownload, data = pcall(function()
            return game:HttpGet(K7Duels_REDRUM_URL)
        end)
        if not okDownload or type(data) ~= "string" or #data < 256 then
            return nil, "could not download redrum"
        end

        local okWrite = pcall(writefile, K7Duels_REDRUM_FILE, data)
        if not okWrite then
            return nil, "could not save redrum"
        end
    end

    local okAsset, asset = pcall(assetLoader, K7Duels_REDRUM_FILE)
    if not okAsset or type(asset) ~= "string" or asset == "" then
        return nil, "could not create redrum asset"
    end

    kryvoxRedrumAsset = asset
    return asset
end

local function makeK7DuelsRedrumSound(startAt, name)
    local asset, err = getK7DuelsRedrumAsset()
    if not asset then
        warn("[K7 DUELS Music] " .. tostring(err))
        return nil
    end

    local sound = Instance.new("Sound")
    sound.Name = name or "K7DuelsRedrum"
    sound.SoundId = asset
    sound.Volume = 1
    sound.Looped = false
    sound.Parent = SoundService

    local startPosition = math.max(0, tonumber(startAt) or 0)
    pcall(function() sound.TimePosition = startPosition end)
    pcall(function() sound:Play() end)

    task.spawn(function()
        local startedWaiting = tick()
        while sound.Parent and not sound.IsLoaded and tick() - startedWaiting < 8 do
            task.wait(0.05)
        end
        if sound.Parent then
            pcall(function()
                sound.TimePosition = startPosition
                if not sound.Playing then sound:Play() end
            end)
        end
    end)

    return sound
end

local function makeK7DuelsIntroSound(name)
    local assetLoader = getcustomasset or getsynasset
    if type(assetLoader) ~= "function" or type(writefile) ~= "function" then
        warn("[K7 DUELS Music] El executor requiere getcustomasset/getsynasset y writefile para cargar el audio del intro")
        return nil
    end

    local exists = false
    if type(isfile) == "function" then
        local okExists, result = pcall(isfile, K7Duels_INTRO_FILE)
        exists = okExists and result == true
    end

    if not exists then
        local okDownload, data = pcall(function()
            return game:HttpGet(K7Duels_INTRO_URL)
        end)
        if not okDownload or type(data) ~= "string" or #data < 256 then
            warn("[K7 DUELS Music] No se pudo descargar FreshGoodIntro.mp3")
            return nil
        end

        local okWrite = pcall(writefile, K7Duels_INTRO_FILE, data)
        if not okWrite then
            warn("[K7 DUELS Music] No se pudo guardar el audio del intro")
            return nil
        end
    end

    local okAsset, asset = pcall(assetLoader, K7Duels_INTRO_FILE)
    if not okAsset or type(asset) ~= "string" or asset == "" then
        warn("[K7 DUELS Music] No se pudo convertir el audio del intro en un asset local")
        return nil
    end

    local sound = Instance.new("Sound")
    sound.Name = name or "K7DuelsFreshGoodIntro"
    sound.SoundId = asset
    sound.Volume = 1.35
    sound.Looped = false
    pcall(function() sound:SetAttribute('K7DuelsIntroSound', true) end)
    sound.Parent = SoundService
    task.spawn(function()
        local deadline = tick() + 12
        while sound.Parent and not sound.IsLoaded and tick() < deadline do
            task.wait(0.08)
        end
        if sound.Parent then
            pcall(function()
                sound.TimePosition = 0
                sound:Play()
            end)
        end
    end)
    return sound
end

local function stopK7DuelsFullRedrum()
    kryvoxMusicRequest = kryvoxMusicRequest + 1
    if kryvoxFullRedrumSound then
        pcall(function() kryvoxFullRedrumSound:Stop() end)
        pcall(function() kryvoxFullRedrumSound:Destroy() end)
        kryvoxFullRedrumSound = nil
    end
end


_G.K7DuelsRunning = true
_G.K7DuelsSession = (_G.K7DuelsSession or 0) + 1
local _mySession = _G.K7DuelsSession

-- K7 DUELS // cinematic intro
-- Solo sustituye la presentación inicial; conserva el flujo de salida del script.
do
    local screen, connections = nil, {}
    local introSound = nil
    local closed, leaving = false, nil
    local started = tick()
    local TOTAL_DURATION, FADE_DURATION = 7.4, 0.75

    local function connect(signal, callback)
        local c = signal:Connect(callback)
        connections[#connections + 1] = c
        return c
    end

    local function make(className, parent, properties)
        local object = Instance.new(className)
        if object:IsA("GuiObject") then object.BorderSizePixel = 0 end
        for key, value in pairs(properties or {}) do object[key] = value end
        object.Parent = parent
        return object
    end

    local function round(object, radius)
        make("UICorner", object, {CornerRadius = UDim.new(0, radius)})
        return object
    end

    local function stopIntroAudio()
        if introSound then
            pcall(function() introSound:Stop() end)
            pcall(function() introSound:Destroy() end)
            introSound = nil
        end
        pcall(function()
            for _, object in ipairs(game:GetDescendants()) do
                if object:IsA("Sound") and (object:GetAttribute("K7DuelsIntroSound") == true
                    or object.Name == "K7DuelsUserIntroMusic"
                    or object.Name == "K7DuelsIntroMusic"
                    or object.Name == "K7 DUELSPremiumIntroMusic"
                    or object.Name == "K7DuelsFreshGoodIntro") then
                    pcall(function() object:Stop() end)
                    pcall(function() object:Destroy() end)
                end
            end
        end)
    end

    local function cleanup()
        closed = true
        for _, c in ipairs(connections) do pcall(function() c:Disconnect() end) end
        stopIntroAudio()
        if screen then pcall(function() screen:Destroy() end) end
    end

    local function exitIntro()
        if not leaving then
            stopIntroAudio()
            leaving = tick()
        end
    end

    local ok, err = pcall(function()
        local core
        pcall(function() core = game:GetService("CoreGui") end)
        for _, parent in ipairs(core and {core, pgui} or {pgui}) do
            for _, oldName in ipairs({"BossHubIntro", "K7DuelsReviveIntro"}) do
                local old = parent:FindFirstChild(oldName)
                if old then old:Destroy() end
            end
        end

        screen = make("ScreenGui", nil, {
            Name = "K7DuelsReviveIntro", ResetOnSpawn = false, IgnoreGuiInset = true,
            DisplayOrder = 10000, ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        })
        pcall(function() if syn and syn.protect_gui then syn.protect_gui(screen) end end)
        if core then pcall(function() screen.Parent = core end) end
        if not screen.Parent then screen.Parent = pgui end
        connect(screen.Destroying, function() closed = true end)

        stopIntroAudio()
        introSound = makeK7DuelsIntroSound("K7DuelsIntroMusic")
        if introSound then
            introSound.Volume = 0
            task.spawn(function()
                local sound = introSound
                local deadline = tick() + 8
                while sound and sound.Parent and not sound.IsLoaded and tick() < deadline do
                    task.wait(0.05)
                end
                if sound and sound.Parent then
                    TS:Create(sound, TweenInfo.new(2.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Volume = 1.15}):Play()
                end
            end)
        end

        local BG = Color3.fromRGB(12, 5, 24)
        local CARD = Color3.fromRGB(24, 12, 42)
        local WHITE = Color3.fromRGB(255, 255, 255)
        local MUTED = Color3.fromRGB(196, 170, 230)
        local BRIGHT = Color3.fromRGB(245, 238, 255)
        local SILVER = Color3.fromRGB(180, 105, 255)
        local ACCENT = Color3.fromRGB(145, 65, 230)

        local backdrop = make("Frame", screen, {
            Name = "MidnightBackdrop", Size = UDim2.fromScale(1, 1),
            BackgroundColor3 = BG, BackgroundTransparency = 0, ZIndex = 1,
        })
        make("UIGradient", backdrop, {
            Rotation = 28,
            Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(18, 7, 35)),
                ColorSequenceKeypoint.new(0.45, Color3.fromRGB(45, 18, 78)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(27, 10, 52)),
            }),
        })
        local aurora = make("Frame", screen, {
            Name = "AuroraGlow", AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.new(0.5, 0, 0.12, 0), Size = UDim2.new(1.2, 0, 0, 230),
            Rotation = -7, BackgroundColor3 = SILVER, BackgroundTransparency = 0.78, ZIndex = 2,
        })
        make("UIGradient", aurora, {
            Rotation = 90, Color = ColorSequence.new(SILVER, BRIGHT),
            Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.5, 0.15),
                NumberSequenceKeypoint.new(1, 1),
            }),
        })

        local particleLayer = make("Frame", screen, {
            Name = "StarLayer", Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, ZIndex = 2,
        })
        for i = 1, 9 do
            local px, py = math.random(6, 94) / 100, math.random(8, 92) / 100
            local size = math.random(12, 18)
            local star = make("TextLabel", particleLayer, {
                Name = "Star" .. i, Position = UDim2.new(px, 0, py, 0),
                Size = UDim2.fromOffset(size, size), BackgroundTransparency = 1,
                Text = "✦", Font = Enum.Font.GothamBold, TextSize = math.random(10, 15),
                TextColor3 = (i % 3 == 0) and SILVER or WHITE,
                TextTransparency = 0.18, Rotation = math.random(-20, 20), ZIndex = 2,
            })
            local targetY = math.max(0.02, py - math.random(3, 7) / 100)
            TS:Create(star, TweenInfo.new(math.random(3, 5), Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
                Position = UDim2.new(px, 0, targetY, 0), TextTransparency = 0.9,
                Rotation = star.Rotation + math.random(20, 55),
            }):Play()
        end

        local rainLayer = make("Frame", screen, {
            Name = "LightTrailLayer", Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, ZIndex = 2,
        })
        for i = 1, 6 do
            local px = math.random(8, 92) / 100
            local drop = round(make("Frame", rainLayer, {
                Name = "LightTrail" .. i, Position = UDim2.new(px, 0, -0.08, 0),
                Size = UDim2.fromOffset(math.random(2, 3), math.random(14, 22)),
                BackgroundColor3 = BRIGHT, BackgroundTransparency = 0.15,
                Rotation = math.random(-8, 8), ZIndex = 2,
            }), 3)
            make("UIGradient", drop, {
                Rotation = 90,
                Color = ColorSequence.new(Color3.fromRGB(249, 249, 249), BRIGHT),
                Transparency = NumberSequence.new({
                    NumberSequenceKeypoint.new(0, 0.82), NumberSequenceKeypoint.new(0.25, 0.12),
                    NumberSequenceKeypoint.new(0.75, 0.12), NumberSequenceKeypoint.new(1, 0.82),
                }),
            })
            TS:Create(drop, TweenInfo.new(math.random(28, 42) / 10, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {
                Position = UDim2.new(math.clamp(px + math.random(-3, 3) / 100, 0.02, 0.98), 0, 1.08, 0),
                BackgroundTransparency = 0.5,
            }):Play()
        end

        local sweepLayer = make("Frame", screen, {
            Name = "SweepLayer", Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1,
            ClipsDescendants = true, ZIndex = 3,
        })
        local band = make("Frame", sweepLayer, {
            Name = "AuroraSweep", AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.new(-0.3, 0, 0.5, 0), Size = UDim2.new(0.13, 0, 1.6, 0),
            BackgroundColor3 = BRIGHT, BackgroundTransparency = 0.38, Rotation = 18, ZIndex = 3,
        })
        make("UIGradient", band, {
            Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.35, 0.25),
                NumberSequenceKeypoint.new(0.5, 0), NumberSequenceKeypoint.new(0.65, 0.25),
                NumberSequenceKeypoint.new(1, 1),
            }),
        })
        TS:Create(band, TweenInfo.new(4.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
            Position = UDim2.new(1.3, 0, 0.5, 0),
        }):Play()

        local stage = make("Frame", screen, {
            Name = "K7DuelsStage", AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.49), Size = UDim2.fromOffset(600, 320),
            BackgroundTransparency = 1, ZIndex = 10,
        })
        local stageScale = make("UIScale", stage, {Scale = 1})
        local function fit()
            local cam = Workspace.CurrentCamera
            local viewport = cam and cam.ViewportSize or Vector2.new(844, 390)
            stageScale.Scale = math.max(0.32, math.min((viewport.X - 32) / 600, (viewport.Y - 90) / 320, 1.05))
        end
        local cameraConnection
        local function followCamera()
            if cameraConnection then cameraConnection:Disconnect() end
            local cam = Workspace.CurrentCamera
            if cam then cameraConnection = connect(cam:GetPropertyChangedSignal("ViewportSize"), fit) end
            fit()
        end
        connect(Workspace:GetPropertyChangedSignal("CurrentCamera"), followCamera)
        followCamera()

        local cardGlow = round(make("Frame", stage, {
            Name = "CardHalo", AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.fromOffset(474, 246),
            BackgroundColor3 = BRIGHT, BackgroundTransparency = 0.84, ZIndex = 19,
        }), 24)
        local cardGlowStroke = make("UIStroke", cardGlow, {Color = SILVER, Transparency = 0.58, Thickness = 2})
        local card = round(make("Frame", stage, {
            Name = "K7DuelsCard", AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.56), Size = UDim2.fromOffset(460, 236),
            BackgroundColor3 = CARD, BackgroundTransparency = 1, ZIndex = 20,
        }), 20)
        local cardScale = make("UIScale", card, {Scale = 0.92})
        make("UIGradient", card, {
            Rotation = 120,
            Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(42, 20, 72)),
                ColorSequenceKeypoint.new(0.55, Color3.fromRGB(24, 12, 42)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(34, 16, 60)),
            }),
        })
        local cardStroke = make("UIStroke", card, {Color = BRIGHT, Transparency = 1, Thickness = 1.5})
        local topRule = make("Frame", card, {
            Name = "TopRule", Position = UDim2.fromOffset(24, 6), Size = UDim2.new(1, -48, 0, 1),
            BackgroundColor3 = BRIGHT, BackgroundTransparency = 0.2, ZIndex = 21,
        })
        make("UIGradient", topRule, {
            Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.5, 0.1),
                NumberSequenceKeypoint.new(1, 1),
            }),
        })

        -- Recortes de esquina en plata: hacen que la tarjeta se sienta más nítida y premium.
        local cornerMarks = {
            {x = 13, y = 13, w = 20, h = 2}, {x = 13, y = 13, w = 2, h = 20},
            {x = 427, y = 13, w = 20, h = 2}, {x = 445, y = 13, w = 2, h = 20},
            {x = 13, y = 221, w = 20, h = 2}, {x = 13, y = 203, w = 2, h = 20},
            {x = 427, y = 221, w = 20, h = 2}, {x = 445, y = 203, w = 2, h = 20},
        }
        for i, mark in ipairs(cornerMarks) do
            make("Frame", card, {
                Name = "SilverCorner" .. i, Position = UDim2.fromOffset(mark.x, mark.y),
                Size = UDim2.fromOffset(mark.w, mark.h), BackgroundColor3 = BRIGHT,
                BackgroundTransparency = 0.12, ZIndex = 22,
            })
        end

        local badge = round(make("Frame", card, {
            Name = "WelcomeBadge", Position = UDim2.fromOffset(26, 20), Size = UDim2.fromOffset(124, 24),
            BackgroundColor3 = Color3.fromRGB(26, 26, 26), BackgroundTransparency = 0.08, ZIndex = 21,
        }), 9)
        make("UIStroke", badge, {Color = BRIGHT, Transparency = 0.55, Thickness = 1})
        make("TextLabel", badge, {
            Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1,
            Text = "K7 DUELS", Font = Enum.Font.GothamBold, TextSize = 10,
            TextColor3 = BRIGHT, ZIndex = 22,
        })
        local edition = make("TextLabel", card, {
            Text = "discord.gg/HPRe6Mzsz", Position = UDim2.new(1, -190, 0, 25),
            Size = UDim2.fromOffset(164, 14), BackgroundTransparency = 1,
            TextColor3 = MUTED, Font = Enum.Font.Code, TextSize = 8,
            TextXAlignment = Enum.TextXAlignment.Right, ZIndex = 22,
        })

        local letterRow = make("Frame", card, {
            Name = "K7DuelsLetters", Position = UDim2.fromOffset(20, 56),
            Size = UDim2.fromOffset(420, 72), BackgroundTransparency = 1, ZIndex = 22,
        })
        local letters = {"K", "7", " ", "D", "U", "E", "L", "S"}
        local letterLabels = {}
        local letterWidth, letterGap = 36, 3
        local totalLetterWidth = (#letters * letterWidth) + ((#letters - 1) * letterGap)
        local firstX = (420 - totalLetterWidth) / 2
        for i, character in ipairs(letters) do
            local label = make("TextLabel", letterRow, {
                Name = "Letter" .. i, Text = character,
                Position = UDim2.fromOffset(firstX + (i - 1) * (letterWidth + letterGap), 28),
                Size = UDim2.fromOffset(letterWidth, 58), BackgroundTransparency = 1,
                TextColor3 = WHITE, Font = Enum.Font.GothamBlack, TextSize = 34,
                TextXAlignment = Enum.TextXAlignment.Center, TextYAlignment = Enum.TextYAlignment.Center,
                TextTransparency = 1, ZIndex = 23,
            })
            make("UIGradient", label, {
                Rotation = 90,
                Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, WHITE),
                    ColorSequenceKeypoint.new(0.55, BRIGHT),
                    ColorSequenceKeypoint.new(1, SILVER),
                }),
            })
            letterLabels[#letterLabels + 1] = label
        end

        -- Corona geométrica sobre la V: formas simples para que se renderice bien en móvil.
        local crown = make("Frame", letterRow, {
            Name = "K7DuelsCrown", AnchorPoint = Vector2.new(0.5, 1),
            Position = UDim2.fromOffset(firstX + letterWidth / 2, 24),
            Size = UDim2.fromOffset(36, 24), BackgroundTransparency = 1, ZIndex = 25,
        })
        local crownScale = make("UIScale", crown, {Scale = 1})
        local crownPoints = {
            {x = 3, y = 3, size = 7},
            {x = 14, y = 0, size = 8},
            {x = 26, y = 3, size = 7},
        }
        for i, point in ipairs(crownPoints) do
            make("Frame", crown, {
                Name = "CrownPeak" .. i, Position = UDim2.fromOffset(point.x, point.y),
                Size = UDim2.fromOffset(point.size, point.size), Rotation = 45,
                BackgroundColor3 = WHITE, BorderSizePixel = 0, ZIndex = 26,
            })
        end
        local crownBand = round(make("Frame", crown, {
            Name = "CrownBand", Position = UDim2.fromOffset(2, 9), Size = UDim2.fromOffset(32, 7),
            BackgroundColor3 = WHITE, BorderSizePixel = 0, ZIndex = 27,
        }), 2)
        make("UIGradient", crownBand, {Color = ColorSequence.new(WHITE, SILVER)})
        round(make("Frame", crown, {
            Name = "CrownBase", Position = UDim2.fromOffset(6, 17), Size = UDim2.fromOffset(24, 3),
            BackgroundColor3 = SILVER, BorderSizePixel = 0, ZIndex = 27,
        }), 2)
        round(make("Frame", crown, {
            Name = "CrownGem", AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromOffset(18, 12), Size = UDim2.fromOffset(4, 4),
            BackgroundColor3 = Color3.fromRGB(8, 8, 8), BorderSizePixel = 0, ZIndex = 28,
        }), 2)

        local subtitle = make("TextLabel", card, {
            Text = "discord.gg/HPRe6Mzsz", Position = UDim2.fromOffset(27, 136),
            Size = UDim2.fromOffset(406, 22), BackgroundTransparency = 1,
            TextColor3 = WHITE, Font = Enum.Font.GothamBold, TextSize = 13,
            TextTransparency = 1, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 22,
        })
        local hint = make("TextLabel", card, {
            Text = "LISTO PARA COMPETIR  ·  K7 DUELS", Position = UDim2.fromOffset(27, 164),
            Size = UDim2.fromOffset(406, 16), BackgroundTransparency = 1,
            TextColor3 = MUTED, Font = Enum.Font.Gotham, TextSize = 9,
            TextTransparency = 1, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 22,
        })
        local loadLabel = make("TextLabel", card, {
            Text = "INICIANDO", Position = UDim2.fromOffset(27, 190),
            Size = UDim2.fromOffset(350, 14), BackgroundTransparency = 1,
            TextColor3 = BRIGHT, Font = Enum.Font.GothamBold, TextSize = 9,
            TextTransparency = 0.15, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 22,
        })
        local progressPercent = make("TextLabel", card, {
            Name = "LoadPercent", Text = "00%", Position = UDim2.new(1, -71, 0, 190),
            Size = UDim2.fromOffset(44, 14), BackgroundTransparency = 1,
            TextColor3 = SILVER, Font = Enum.Font.Code, TextSize = 9,
            TextXAlignment = Enum.TextXAlignment.Right, ZIndex = 22,
        })
        local loadTrack = round(make("Frame", card, {
            Name = "LoadTrack", Position = UDim2.fromOffset(27, 212), Size = UDim2.fromOffset(406, 5),
            BackgroundColor3 = Color3.fromRGB(39, 39, 39), BackgroundTransparency = 0.1, ZIndex = 22,
        }), 3)
        local loadFill = round(make("Frame", loadTrack, {
            Name = "LoadFill", Size = UDim2.new(0, 0, 1, 0),
            BackgroundColor3 = BRIGHT, BackgroundTransparency = 0, ZIndex = 23,
        }), 3)
        make("UIGradient", loadFill, {Color = ColorSequence.new({ColorSequenceKeypoint.new(0, WHITE), ColorSequenceKeypoint.new(0.45, BRIGHT), ColorSequenceKeypoint.new(1, ACCENT)})})

        local enter = make("TextButton", screen, {
            Name = "SkipIntro", AnchorPoint = Vector2.new(1, 1),
            Position = UDim2.new(1, -20, 1, -20), Size = UDim2.fromOffset(112, 38),
            BackgroundColor3 = CARD, BackgroundTransparency = 0.08,
            Text = "OMITIR  →", Font = Enum.Font.GothamBold, TextSize = 12,
            TextColor3 = BRIGHT, TextTransparency = 0, AutoButtonColor = false,
            BorderSizePixel = 0, Active = true, ZIndex = 40,
        })
        round(enter, 12)
        make("UIStroke", enter, {Color = SILVER, Transparency = 0.28, Thickness = 1.4})
        connect(enter.Activated, exitIntro)
        connect(enter.MouseButton1Click, exitIntro)

        local fade = make("Frame", screen, {
            Name = "FadeOut", Size = UDim2.fromScale(1, 1),
            BackgroundColor3 = BG, BackgroundTransparency = 1, ZIndex = 50,
        })

        local fadeObjects = {}
        for _, object in ipairs(screen:GetDescendants()) do
            if object:IsA("GuiObject") then
                fadeObjects[#fadeObjects + 1] = {
                    object = object, background = object.BackgroundTransparency,
                    text = (object:IsA("TextLabel") or object:IsA("TextButton")) and object.TextTransparency or nil,
                }
            elseif object:IsA("UIStroke") then
                fadeObjects[#fadeObjects + 1] = {object = object, stroke = object.Transparency}
            end
        end

        TS:Create(card, TweenInfo.new(0.65, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
            Position = UDim2.fromScale(0.5, 0.5), BackgroundTransparency = 0.08,
        }):Play()
        TS:Create(cardScale, TweenInfo.new(0.72, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Scale = 1}):Play()
        TS:Create(cardStroke, TweenInfo.new(0.7, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Transparency = 0.28}):Play()
        TS:Create(cardGlow, TweenInfo.new(0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0.89}):Play()
        TS:Create(cardGlowStroke, TweenInfo.new(0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Transparency = 0.72}):Play()

        started = tick()
        local messages = {"CONECTANDO", "CARGANDO SISTEMA", "CALIBRANDO", "LISTO"}
        local messageStep = (TOTAL_DURATION - 0.8) / #messages
        local lastMessage = 0
        local function render()
            if closed then return end
            local now, elapsed = tick(), tick() - started
            if elapsed >= TOTAL_DURATION - FADE_DURATION then exitIntro() end
            if leaving then
                local alpha = math.clamp((now - leaving) / FADE_DURATION, 0, 1)
                for _, item in ipairs(fadeObjects) do
                    if item.object.Parent then
                        if item.background ~= nil then item.object.BackgroundTransparency = item.background + (1 - item.background) * alpha end
                        if item.text ~= nil then item.object.TextTransparency = item.text + (1 - item.text) * alpha end
                        if item.stroke ~= nil then item.object.Transparency = item.stroke + (1 - item.stroke) * alpha end
                    end
                end
                if alpha >= 1 then closed = true end
                return
            end
            local progress = math.clamp(elapsed / (TOTAL_DURATION - FADE_DURATION), 0, 1)
            loadFill.Size = UDim2.new(progress, 0, 1, 0)
            progressPercent.Text = string.format("%02d%%", math.floor(progress * 100 + 0.5))
            local messageIndex = math.clamp(math.floor(elapsed / messageStep) + 1, 1, #messages)
            if messageIndex ~= lastMessage then
                loadLabel.Text = messages[messageIndex]
                lastMessage = messageIndex
            end
            for i, label in ipairs(letterLabels) do
                local reveal = math.clamp((elapsed - 0.28 - (i - 1) * 0.07) / 0.55, 0, 1)
                local ease = 1 - (1 - reveal) ^ 3
                local baseY = 28
                label.Position = UDim2.fromOffset(label.Position.X.Offset, baseY + (1 - ease) * 16)
                label.Rotation = (1 - ease) * 10
                label.TextTransparency = 1 - ease
                label.TextSize = 34 + ease * 2
            end
            if crown and crown.Parent then
                crown.Rotation = math.sin(elapsed * 2.0) * 3
            end
            if crownScale then
                crownScale.Scale = 1 + math.sin(elapsed * 2.8) * 0.05
            end
            local pulse = 0.5 + 0.5 * math.sin(elapsed * 2.4)
            cardGlow.BackgroundTransparency = 0.88 - pulse * 0.04
            cardStroke.Transparency = 0.22 + pulse * 0.14
            if subtitle then
                local subReveal = math.clamp((elapsed - 1.1) / 0.6, 0, 1)
                subtitle.TextTransparency = 1 - (1 - (1 - subReveal) ^ 2)
            end
            if hint then
                local hintReveal = math.clamp((elapsed - 1.45) / 0.55, 0, 1)
                hint.TextTransparency = 1 - (1 - (1 - hintReveal) ^ 2)
            end
        end
        connect(RunService.RenderStepped, render)
        render()
        while not closed and _mySession == _G.K7DuelsSession do task.wait(0.05) end
    end)
    cleanup()
    if not ok then warn("[K7 DUELS] Intro no cargó: " .. tostring(err)) end
end

local K7DUELS_LANGUAGE = "en"

local K7DUELS_TRANSLATIONS = {
    es = { ["RESET ALL SETTINGS"]="RESTABLECER TODO", ["SETTINGS RESET"]="AJUSTES RESTABLECIDOS", ["CONFIRM?"]="¿CONFIRMAR?", ["ERROR"]="ERROR", ["RESET"]="RESTABLECER", ["Keybinds"]="TECLAS", ["Carry Mode"]="MODO CARGAR", ["Lagger Mode"]="MODO LAG", ["Auto Left"]="AUTO IZQUIERDA", ["Auto Right"]="AUTO DERECHA", ["Auto Bat"]="AUTO BATE", ["TP Down"]="TP ABAJO", ["Drop Brainrot"]="SOLTAR BRAINROT", ["Hide GUI"]="OCULTAR MENÚ", ["Normal Speed"]="VELOCIDAD NORMAL", ["Carry Speed"]="VELOCIDAD CARGAR", ["Current Mode"]="MODO ACTUAL", ["ACTIVATE"]="ACTIVAR" },
    pt = { ["RESET ALL SETTINGS"]="REDEFINIR TUDO", ["SETTINGS RESET"]="CONFIGURAÇÕES REDEFINIDAS", ["CONFIRM?"]="CONFIRMAR?", ["ERROR"]="ERRO", ["RESET"]="REDEFINIR", ["Keybinds"]="TECLAS", ["Carry Mode"]="MODO CARREGAR", ["Auto Left"]="AUTO ESQUERDA", ["Auto Right"]="AUTO DIREITA", ["Hide GUI"]="OCULTAR MENU", ["Normal Speed"]="VELOCIDADE NORMAL", ["Carry Speed"]="VELOCIDADE CARREGAR", ["ACTIVATE"]="ATIVAR" },
    fr = { ["RESET ALL SETTINGS"]="RÉINITIALISER", ["SETTINGS RESET"]="PARAMÈTRES RÉINITIALISÉS", ["CONFIRM?"]="CONFIRMER ?", ["ERROR"]="ERREUR", ["RESET"]="RÉINITIALISER", ["Keybinds"]="RACCOURCIS", ["Carry Mode"]="MODE PORTER", ["Auto Left"]="AUTO GAUCHE", ["Auto Right"]="AUTO DROITE", ["Hide GUI"]="MASQUER LE MENU", ["Normal Speed"]="VITESSE NORMALE", ["Carry Speed"]="VITESSE PORTER", ["ACTIVATE"]="ACTIVER" },
    de = { ["RESET ALL SETTINGS"]="ALLES ZURÜCKSETZEN", ["SETTINGS RESET"]="EINSTELLUNGEN ZURÜCKGESETZT", ["CONFIRM?"]="BESTÄTIGEN?", ["ERROR"]="FEHLER", ["RESET"]="ZURÜCKSETZEN", ["Keybinds"]="TASTEN", ["Carry Mode"]="TRAGEMODUS", ["Auto Left"]="AUTO LINKS", ["Auto Right"]="AUTO RECHTS", ["Hide GUI"]="MENÜ AUSBLENDEN", ["Normal Speed"]="NORMALE GESCHWINDIGKEIT", ["Carry Speed"]="TRAGEGESCHWINDIGKEIT", ["ACTIVATE"]="AKTIVIEREN" },
}

local function localizeK7DuelsInterface(root)
    local dictionary = K7DUELS_TRANSLATIONS[K7DUELS_LANGUAGE]
    if not dictionary or not root then return end
    for _, object in ipairs(root:GetDescendants()) do
        if object:IsA("TextLabel") or object:IsA("TextButton") then
            local source = object:GetAttribute("K7DuelsSourceText") or object.Text
            object:SetAttribute("K7DuelsSourceText", source)
            local translated = dictionary[source]
            if translated then object.Text = translated end
        end
    end
end

local function kryvoxHubTranslate(source)
    local dictionary = K7DUELS_TRANSLATIONS[K7DUELS_LANGUAGE]
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

-- Speeds aligned with NIGHT / fixed_by_migizin (Anti-Sammy carry system):
-- Normal 59.5 | Carry 28.8 | Lagger 24.5 | Lagger Carry 15
NS = 59.5
CS = 28.8
LAGGER_SPEED = 24.5
LAGGER_CARRY_SPEED = 15
MEDUSA_COOLDOWN = 25
BAT_AIMBOT_SPEED = 55
BYPASS_AIMBOT_SPEED = 55
BAT_BYPASS_VERSION = (_G.__RivalHubBatVersion == "v2") and "v2" or "v1"
local State = {
    bypassBatEnabled = false,
    bypassBatSpeed = BYPASS_AIMBOT_SPEED,
}
CONFIG_FILE = "K7Duels_" .. tostring(LP.UserId) .. ".json"
BAT_V2_HIT_DIST = 4.5
_isDraggingButton = false

backgroundIndex = 1
backgroundImages = {"114806479591771", "132822404154939", "116562846360846", "94752922027403", "98134268228198", "98440309875237", "128082700996978", "82803024171042", "109824715168696", "73000602979247", "107897579024922", "112704519678669", "132492375366497", "107098407367387"}
-- Each background image forces a matching UI accent color
BACKGROUND_COLOR_MAP = {
    -- White & purple theme.
    [1] = { theme = "WhitePurple", color = Color3.fromRGB(185, 110, 255), secondary = Color3.fromRGB(55, 20, 105) },
    [2] = { theme = "WhitePurple", color = Color3.fromRGB(185, 110, 255), secondary = Color3.fromRGB(55, 20, 105) },
    [3] = { theme = "WhitePurple", color = Color3.fromRGB(185, 110, 255), secondary = Color3.fromRGB(55, 20, 105) },
    [4] = { theme = "WhitePurple", color = Color3.fromRGB(185, 110, 255), secondary = Color3.fromRGB(55, 20, 105) },
    [5] = { theme = "WhitePurple", color = Color3.fromRGB(185, 110, 255), secondary = Color3.fromRGB(55, 20, 105) },
    [6] = { theme = "WhitePurple", color = Color3.fromRGB(185, 110, 255), secondary = Color3.fromRGB(55, 20, 105) },
    [7] = { theme = "WhitePurple", color = Color3.fromRGB(185, 110, 255), secondary = Color3.fromRGB(55, 20, 105) },
    [8] = { theme = "WhitePurple", color = Color3.fromRGB(185, 110, 255), secondary = Color3.fromRGB(55, 20, 105) },
    [9] = { theme = "WhitePurple", color = Color3.fromRGB(185, 110, 255), secondary = Color3.fromRGB(55, 20, 105) },
    [10] = { theme = "WhitePurple", color = Color3.fromRGB(185, 110, 255), secondary = Color3.fromRGB(55, 20, 105) },
    [11] = { theme = "WhitePurple", color = Color3.fromRGB(185, 110, 255), secondary = Color3.fromRGB(55, 20, 105) },
    [12] = { theme = "WhitePurple", color = Color3.fromRGB(185, 110, 255), secondary = Color3.fromRGB(55, 20, 105) },
    [13] = { theme = "WhitePurple", color = Color3.fromRGB(185, 110, 255), secondary = Color3.fromRGB(55, 20, 105) },
    [14] = { theme = "WhitePurple", color = Color3.fromRGB(185, 110, 255), secondary = Color3.fromRGB(55, 20, 105) }
}
K7DuelsUI = {effects = true, animated = {}, cards = {}, tweens = {}, backgroundRevision = 0}
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
    K7DuelsUI.backgroundRevision = K7DuelsUI.backgroundRevision + 1
    local revision = K7DuelsUI.backgroundRevision
    if main then
        main.BackgroundColor3 = Color3.fromRGB(9, 12, 16)
        main.BackgroundTransparency = 0
        local bg = main:FindFirstChild("BackgroundImage")
        local overlay = main:FindFirstChild("BackgroundIncoming")
        if overlay then overlay:Destroy() end
        if K7DuelsUI.backgroundTween then K7DuelsUI.backgroundTween:Cancel() end
        if bg then
            local asset = "rbxassetid://" .. backgroundImages[backgroundIndex]
            local opacity = backgroundMode == "None" and 1 or backgroundImageTransparency
            if backgroundMode == "None" or not K7DuelsUI.effects or bg.Image == asset then
                bg.Image = asset
                bg.ImageTransparency = opacity
                if backgroundMode == "None" then
                    bg.ImageColor3 = Color3.fromRGB(255, 255, 255)
                else
                    local mapTint = BACKGROUND_COLOR_MAP and BACKGROUND_COLOR_MAP[backgroundIndex]
                    if mapTint and mapTint.color then bg.ImageColor3 = mapTint.color end
                end
            else
                local incoming = bg:Clone()
                incoming.Name = "BackgroundIncoming"
                incoming.Image = asset
                incoming.ImageTransparency = 1
                local mapTint = BACKGROUND_COLOR_MAP and BACKGROUND_COLOR_MAP[backgroundIndex]
                if mapTint and mapTint.color then incoming.ImageColor3 = mapTint.color end
                incoming.ZIndex = 1
                incoming.Parent = main
                K7DuelsUI.backgroundTween = TS:Create(incoming, TweenInfo.new(0.28, Enum.EasingStyle.Quad), {ImageTransparency = opacity})
                K7DuelsUI.backgroundTween.Completed:Connect(function()
                    if revision == K7DuelsUI.backgroundRevision and bg.Parent then
                        bg.Image = asset
                        bg.ImageTransparency = opacity
                        local map = BACKGROUND_COLOR_MAP and BACKGROUND_COLOR_MAP[backgroundIndex]
                        if map and map.color then bg.ImageColor3 = map.color end
                    end
                    if incoming.Parent then incoming:Destroy() end
                end)
                K7DuelsUI.backgroundTween:Play()
            end
        end
    end
    if K7DuelsUI.art and K7DuelsUI.art.Parent then
        K7DuelsUI.art.Image = "rbxassetid://" .. backgroundImages[backgroundIndex]
        K7DuelsUI.art.Visible = backgroundMode ~= "None"
        K7DuelsUI.art.ImageTransparency = backgroundMode == "None" and 1 or 0.15
    end
    if miniBackgroundImage then miniBackgroundImage.Visible = false end
    if backgroundSelectorLabel then backgroundSelectorLabel.Text = backgroundMode end
    -- Tint background IMAGE + full UI accent to match the selected scene color
    local function tintBackgroundImages(tint)
        tint = tint or Color3.fromRGB(255, 255, 255)
        if main then
            local bg = main:FindFirstChild("BackgroundImage")
            if bg and bg:IsA("ImageLabel") then
                bg.ImageColor3 = tint
            end
            local incoming = main:FindFirstChild("BackgroundIncoming")
            if incoming and incoming:IsA("ImageLabel") then
                incoming.ImageColor3 = tint
            end
        end
        if K7DuelsUI.art and K7DuelsUI.art.Parent and K7DuelsUI.art:IsA("ImageLabel") then
            K7DuelsUI.art.ImageColor3 = tint
        end
        if miniBackgroundImage and miniBackgroundImage.Parent and miniBackgroundImage:IsA("ImageLabel") then
            miniBackgroundImage.ImageColor3 = tint
        end
        -- Preview cards also tinted so you see the color on the thumbnail
        for i, card in ipairs(K7DuelsUI.cards or {}) do
            if card and card:IsA("ImageButton") then
                local mapEntry = BACKGROUND_COLOR_MAP and BACKGROUND_COLOR_MAP[i]
                if mapEntry and mapEntry.color then
                    card.ImageColor3 = mapEntry.color
                else
                    card.ImageColor3 = Color3.fromRGB(255, 255, 255)
                end
            end
        end
    end

    -- Background image only (no theme/color change)
    if backgroundMode == "None" then
        tintBackgroundImages(Color3.fromRGB(255, 255, 255))
    else
        tintBackgroundImages(Color3.fromRGB(255, 255, 255))
    end
    -- Force purple & white theme regardless of background
    currentColorTheme = "WhitePurple"
    selectedColor = Color3.fromRGB(185, 110, 255)
    _G.__K7DuelsThemeSecondary = Color3.fromRGB(55, 20, 105)
    if type(updateAllUIThemeColors) == "function" then
        pcall(updateAllUIThemeColors, selectedColor)
    end
    if colorSelectorLabel then
        colorSelectorLabel.Text = "White + Purple"
        colorSelectorLabel.TextColor3 = selectedColor
    end
    if _G.__K7DuelsPingLaggerRefreshBackground then pcall(_G.__K7DuelsPingLaggerRefreshBackground) end
    for i, card in ipairs(K7DuelsUI.cards) do
        if card.Parent then
            local stroke = card:FindFirstChildOfClass("UIStroke")
            if stroke then stroke.Transparency = backgroundMode ~= "None" and i == backgroundIndex and 0 or 0.72 end
            local badge = card:FindFirstChild("Selected")
            if badge then badge.Visible = backgroundMode ~= "None" and i == backgroundIndex end
        end
    end
end

local COLOR_THEMES = {
    ["White"] = Color3.fromRGB(240, 248, 255),
    ["Pink"] = Color3.fromRGB(180, 220, 255),
    ["BlackWhite"] = Color3.fromRGB(200, 225, 255),
    ["WhitePurple"] = Color3.fromRGB(185, 110, 255),
    ["Green"] = Color3.fromRGB(140, 200, 255),
    ["Cyan"] = Color3.fromRGB(100, 210, 255),
    ["Orange"] = Color3.fromRGB(160, 210, 255),
    ["Red"] = Color3.fromRGB(180, 220, 255),
    ["RedWhite"] = Color3.fromRGB(230, 245, 255),
    ["Magenta"] = Color3.fromRGB(150, 200, 255),
    ["Gray"] = Color3.fromRGB(170, 200, 230),
}

K7DUELS_TITLE_THEMES = {
    ["Orange"] = { top = Color3.fromRGB(255, 255, 255), bottom = Color3.fromRGB(100, 170, 255) },
    ["Blue"]  = { top = Color3.fromRGB(255, 255, 255),  bottom = Color3.fromRGB(60, 140, 255) },
    ["Purple"] = { top = Color3.fromRGB(255, 255, 255), bottom = Color3.fromRGB(125, 55, 220) },
    ["Red"]   = { top = Color3.fromRGB(230, 245, 255),   bottom = Color3.fromRGB(40, 100, 200) },
    ["Green"] = { top = Color3.fromRGB(240, 250, 255),  bottom = Color3.fromRGB(80, 160, 240) },
    ["Black"] = { top = Color3.fromRGB(255, 255, 255),    bottom = Color3.fromRGB(30, 70, 140) },
    ["Gray"]  = { top = Color3.fromRGB(230, 240, 255), bottom = Color3.fromRGB(70, 120, 180) },
}
currentK7DuelsTitleTheme = "Purple"
scriptLogoRef = nil
kryvoxTitleSelectorLabel = nil

function applyK7DuelsTitleTheme(themeName)
    local t = K7DUELS_TITLE_THEMES[themeName]
    if not t then return end
    currentK7DuelsTitleTheme = themeName
    if scriptLogoRef then
        local grad = scriptLogoRef:FindFirstChildOfClass("UIGradient")
        if grad then
            grad.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, t.top),
                ColorSequenceKeypoint.new(1, t.bottom),
            })
        end
    end
    if kryvoxTitleSelectorLabel then
        kryvoxTitleSelectorLabel.Text = themeName
    end
    if saveAllSettings then pcall(saveAllSettings) end
end

currentColorTheme = "WhitePurple"
selectedColor = Color3.fromRGB(185, 110, 255)
_G.__K7DuelsThemeSecondary = Color3.fromRGB(55, 20, 105)

-- ============================================================
-- UI FONT SYSTEM (ported from Bless)
-- ============================================================
K7DuelsUI.fontName = "GothamBold"
K7DuelsUI.fontItems = {}
K7DuelsUI.fontSelectorLabel = nil
do
    local ok, items = pcall(function() return Enum.Font:GetEnumItems() end)
    if ok and type(items) == "table" then
        for _, item in ipairs(items) do
            if item and item.Name ~= "Unknown" then
                table.insert(K7DuelsUI.fontItems, item)
            end
        end
    end
    table.sort(K7DuelsUI.fontItems, function(a, b)
        return string.lower(a.Name) < string.lower(b.Name)
    end)
end

function K7DuelsUI.fontDisplayName(fontName)
    if fontName == "GothamBold" or fontName == "Original" then
        return "Original"
    end
    return tostring(fontName or "Original")
end

function K7DuelsUI.resolveFont(fontName)
    if fontName == "Original" then fontName = "GothamBold" end
    if type(fontName) ~= "string" or fontName == "" then return nil end
    for _, item in ipairs(K7DuelsUI.fontItems) do
        if item.Name == fontName then return item end
    end
    local ok, item = pcall(function() return Enum.Font[fontName] end)
    if ok and item and item.Name ~= "Unknown" then return item end
    return nil
end

function K7DuelsUI.applyFont(fontName, shouldSave)
    local font = K7DuelsUI.resolveFont(fontName) or Enum.Font.GothamBold
    K7DuelsUI.fontName = font.Name
    if K7DuelsUI.fontSelectorLabel and K7DuelsUI.fontSelectorLabel.Parent then
        K7DuelsUI.fontSelectorLabel.Text = K7DuelsUI.fontDisplayName(font.Name) .. "  ▼"
        K7DuelsUI.fontSelectorLabel.Font = font
    end
    local function applyObject(object)
        if not object or object:GetAttribute("K7DuelsFontPreview") == true then return end
        if object:IsA("TextLabel") or object:IsA("TextButton") or object:IsA("TextBox") then
            pcall(function() object.Font = font end)
        end
    end
    local seen = {}
    local function applyRoot(root)
        if not root or seen[root] then return end
        seen[root] = true
        applyObject(root)
        for _, object in ipairs(root:GetDescendants()) do
            applyObject(object)
        end
    end
    if gui then applyRoot(gui) end
    if MobilePanel then applyRoot(MobilePanel) end
    if pbFrame then applyRoot(pbFrame) end
    if main then applyRoot(main) end
    if shouldSave == true and type(saveAllSettings) == "function" then
        pcall(saveAllSettings)
    end
    return true
end


function getThemeColor() return selectedColor end

function kryvoxHubGradient(c, c2)
    local sec = c2 or _G.__K7DuelsThemeSecondary
    if typeof(sec) == "Color3" then
        -- Mix both theme colors across the gradient
        return ColorSequence.new({
            ColorSequenceKeypoint.new(0.00, sec),
            ColorSequenceKeypoint.new(0.35, c:Lerp(sec, 0.35)),
            ColorSequenceKeypoint.new(0.70, c),
            ColorSequenceKeypoint.new(1.00, c:Lerp(Color3.new(0,0,0), 0.25)),
        })
    end
    return ColorSequence.new({
        ColorSequenceKeypoint.new(0.00, c:Lerp(Color3.new(1,1,1), 0.55)),
        ColorSequenceKeypoint.new(0.45, c),
        ColorSequenceKeypoint.new(1.00, c:Lerp(Color3.new(0,0,0), 0.35)),
    })
end

function kryvoxHubGradientSoft(c)
    return ColorSequence.new({
        ColorSequenceKeypoint.new(0.00, c:Lerp(Color3.new(1,1,1), 0.75)),
        ColorSequenceKeypoint.new(0.50, c:Lerp(Color3.new(1,1,1), 0.25)),
        ColorSequenceKeypoint.new(1.00, c:Lerp(Color3.new(0,0,0), 0.15)),
    })
end

function kryvoxHubGradientDark(c)
    return ColorSequence.new({
        ColorSequenceKeypoint.new(0.00, c:Lerp(Color3.fromRGB(0,0,0), 0.35)),
        ColorSequenceKeypoint.new(0.55, c:Lerp(Color3.fromRGB(0,0,0), 0.65)),
        ColorSequenceKeypoint.new(1.00, c:Lerp(Color3.fromRGB(0,0,0), 0.80)),
    })
end

function applyK7DuelsGradientToLabel(label, c)
    if not label then return end
    local grad = label:FindFirstChildOfClass("UIGradient")
    if not grad then
        grad = Instance.new("UIGradient", label)
    end
    grad.Rotation = 0
    grad.Color = kryvoxHubGradient(c)
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
    if typeof(color) ~= "Color3" then return end
    local now = _tick()
    if color == _lastThemeColor and now - _lastThemeUpdate < 0.05 and not _G.__K7DuelsForceThemeRepaint then
        return
    end
    _G.__K7DuelsForceThemeRepaint = false

    local prev = _lastThemeColor
    _lastThemeUpdate = now
    _lastThemeColor = color
    selectedColor = color

    local secondary = _G.__K7DuelsThemeSecondary
    if typeof(secondary) ~= "Color3" then
        secondary = Color3.fromRGB(255, 255, 255)
    end
    local isRedWhite = (currentColorTheme == "RedWhite") or (backgroundIndex == 4 and backgroundMode ~= "None")

    -- Known fixed pinks / old accents that must always be replaced
    local PINK = Color3.fromRGB(255, 255, 255)
    local function sameColor(a, b)
        if typeof(a) ~= "Color3" or typeof(b) ~= "Color3" then return false end
        return math.abs(a.R - b.R) < 0.02 and math.abs(a.G - b.G) < 0.02 and math.abs(a.B - b.B) < 0.02
    end
    local function isOldAccent(c)
        if typeof(c) ~= "Color3" then return false end
        if sameColor(c, PINK) then return true end
        if prev and sameColor(c, prev) then return true end
        -- other hardcoded pink-ish leftovers
        if sameColor(c, Color3.fromRGB(220, 224, 230)) then return true end
        if sameColor(c, Color3.fromRGB(200, 204, 212)) then return true end
        if sameColor(c, Color3.fromRGB(180, 184, 192)) then return true end
        if sameColor(c, Color3.fromRGB(210, 214, 220)) then return true end
        if sameColor(c, Color3.fromRGB(230, 232, 236)) then return true end
        if sameColor(c, Color3.fromRGB(160, 164, 172)) then return true end
        if sameColor(c, Color3.fromRGB(170, 174, 182)) then return true end
        -- also replace any previous theme colors from the map
        if BACKGROUND_COLOR_MAP then
            for _, entry in pairs(BACKGROUND_COLOR_MAP) do
                if entry.color and sameColor(c, entry.color) and not sameColor(c, color) then
                    return true
                end
            end
        end
        if COLOR_THEMES then
            for _, tc in pairs(COLOR_THEMES) do
                if sameColor(c, tc) and not sameColor(c, color) then
                    return true
                end
            end
        end
        return false
    end

    local function paintGradOn(obj)
        if not obj then return end
        local grad = obj:FindFirstChildOfClass("UIGradient")
        if grad and type(kryvoxHubGradient) == "function" then
            pcall(function() grad.Color = kryvoxHubGradient(color) end)
        end
    end

    local function recolorObject(obj)
        if not obj or not obj.Parent then return end
        if obj:IsA("UIStroke") then
            if isOldAccent(obj.Color) or true then
                -- All UI strokes on hub follow theme
                obj.Color = color
            end
            return
        end
        if obj:IsA("ScrollingFrame") then
            obj.ScrollBarImageColor3 = color
            return
        end
        if obj:IsA("TextLabel") or obj:IsA("TextButton") then
            if isOldAccent(obj.TextColor3) then
                obj.TextColor3 = color
            end
            return
        end
        if obj:IsA("ImageLabel") or obj:IsA("ImageButton") then
            -- Las imágenes conservan siempre sus colores originales; el blanco no aplica tinte.
            obj.ImageColor3 = Color3.fromRGB(255, 255, 255)
            -- El fondo del botón sí puede seguir el tema, pero no la imagen que contiene.
            if isOldAccent(obj.BackgroundColor3) then
                obj.BackgroundColor3 = color
            end
            return
        end
        if obj:IsA("Frame") then
            local n = tostring(obj.Name or "")
            if n == "Underline" or n == "AccentBar" or n == "StatusDot" or n == "StatusGlow"
                or n == "Divider" or n == "Fill" or n == "StealProgressFill"
                or n == "Selected" or n == "ProgressHead" then
                obj.BackgroundColor3 = color
                paintGradOn(obj)
            elseif isOldAccent(obj.BackgroundColor3) then
                obj.BackgroundColor3 = color
                paintGradOn(obj)
            end
            return
        end
    end

    local function sweep(root)
        if not root then return end
        recolorObject(root)
        for _, d in ipairs(root:GetDescendants()) do
            recolorObject(d)
        end
    end

    -- Named roots
    if progressFill then
        progressFill.BackgroundColor3 = color
        paintGradOn(progressFill)
    end
    if progressPct then
        local st = progressPct:FindFirstChildOfClass("UIStroke")
        if st then st.Color = color end
    end
    if progressStatus and isOldAccent(progressStatus.TextColor3) then
        progressStatus.TextColor3 = color
    end
    if pbFrame then sweep(pbFrame) end

    if K7DuelsUI.speedStroke and K7DuelsUI.speedStroke.Parent then K7DuelsUI.speedStroke.Color = color end
    if K7DuelsUI.discordLabel and K7DuelsUI.discordLabel.Parent then K7DuelsUI.discordLabel.TextColor3 = color end
    if _uicStroke then _uicStroke.Color = color end
    if _uicAvatarStroke then _uicAvatarStroke.Color = color end
    if _uicHandle then _uicHandle.TextColor3 = color end
    if _uicLine then _uicLine.BackgroundColor3 = color end

    if gui then sweep(gui) end
    if main then sweep(main) end
    if MobilePanel then sweep(MobilePanel) end
    if tpBatFloatingButton then sweep(tpBatFloatingButton) end
    if instaResetFloatingButton then sweep(instaResetFloatingButton) end

    -- CoreGui / PlayerGui leftovers named K7Duels*
    pcall(function()
        local cg = game:GetService("CoreGui")
        for _, child in ipairs(cg:GetChildren()) do
            local n = tostring(child.Name or "")
            if n:find("Fear", 1, true) or n:find("K7Duels", 1, true) or n:find("Yout", 1, true) then
                sweep(child)
            end
        end
    end)
    pcall(function()
        if LP and LP:FindFirstChild("PlayerGui") then
            for _, child in ipairs(LP.PlayerGui:GetChildren()) do
                local n = tostring(child.Name or "")
                if n:find("Fear", 1, true) or n:find("K7Duels", 1, true) or n:find("CleanHub", 1, true) then
                    sweep(child)
                end
            end
        end
    end)

    for _, tab in ipairs(tabButtons or {}) do
        local active = tab:FindFirstChild("Underline") and tab.Underline.Visible
        local underline = tab:FindFirstChild("Underline")
        if underline then underline.BackgroundColor3 = color end
        local stroke = tab:FindFirstChild("TabStroke")
        if stroke then stroke.Color = color; stroke.Transparency = active and 0.42 or 1 end
        if K7DuelsUI.colorSectionIcon then
            K7DuelsUI.colorSectionIcon(tab:FindFirstChild("SectionIcon"), active and color or Color3.fromRGB(144, 147, 150))
        end
    end

    if _G.__K7DuelsRefreshESPTheme then pcall(_G.__K7DuelsRefreshESPTheme, color) end

    if colorSelectorLabel then
        colorSelectorLabel.Text = currentColorTheme
        colorSelectorLabel.TextColor3 = color
    end

    if _G._kryvoxHubStealSlide then
        _G._kryvoxHubStealSlide.BackgroundColor3 = color
        local sg = _G._kryvoxHubStealSlide:FindFirstChildOfClass("UIGradient")
        if sg and type(kryvoxHubGradient) == "function" then sg.Color = kryvoxHubGradient(color) end
        local ss = _G._kryvoxHubStealSlide:FindFirstChildOfClass("UIStroke")
        if ss then ss.Color = color end
    end

    if miniBtn then
        local stroke = miniBtn:FindFirstChildOfClass("UIStroke")
        if stroke then stroke.Color = color end
    end

    for i, card in ipairs(K7DuelsUI.cards or {}) do
        if card and card.Parent then
            local stroke = card:FindFirstChildOfClass("UIStroke")
            if stroke then stroke.Color = color end
            local badge = card:FindFirstChild("Selected")
            if badge then badge.BackgroundColor3 = color end
            if card:IsA("ImageButton") then
                local mapEntry = BACKGROUND_COLOR_MAP and BACKGROUND_COLOR_MAP[i]
                if mapEntry and mapEntry.color then
                    card.ImageColor3 = mapEntry.color
                end
            end
        end
    end

    -- Background image tint
    if main then
        local bg = main:FindFirstChild("BackgroundImage")
        if bg and bg:IsA("ImageLabel") and backgroundMode ~= "None" then
            bg.ImageColor3 = Color3.fromRGB(255, 255, 255)
        end
    end
    if K7DuelsUI.art and K7DuelsUI.art:IsA("ImageLabel") and backgroundMode ~= "None" then
        K7DuelsUI.art.ImageColor3 = Color3.fromRGB(255, 255, 255)
    end

    if MobilePanel then
        for _, btn in ipairs(MobilePanel:GetChildren()) do
            if btn:IsA("TextButton") then
                if type(paintFloatingBtn) == "function" then
                    pcall(paintFloatingBtn, btn, btn:GetAttribute("MobActive") == true)
                end
            end
        end
    end

    -- Toggle dots / ON states often stay pink — force via attribute scan
    if gui then
        for _, d in ipairs(gui:GetDescendants()) do
            if d:IsA("Frame") and (d.Name == "Dot" or d.Name == "Knob" or d.Name == "ToggleDot") then
                if d.BackgroundColor3.R > 0.5 then
                    d.BackgroundColor3 = color
                end
            end
        end
    end

    -- MIX primary + secondary across the whole hub (not a single flat color)
    do
        local A = color
        local B = secondary
        local mixMid = A:Lerp(B, 0.5)
        local mixSoft = A:Lerp(B, 0.72)

        local function applyMixGradient(obj, rotation)
            if not obj then return end
            local grad = obj:FindFirstChildOfClass("UIGradient")
            if not grad then
                grad = Instance.new("UIGradient")
                grad.Parent = obj
            end
            grad.Rotation = rotation or 90
            grad.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0.00, B),
                ColorSequenceKeypoint.new(0.40, mixMid),
                ColorSequenceKeypoint.new(0.75, A),
                ColorSequenceKeypoint.new(1.00, A:Lerp(Color3.new(0,0,0), 0.2)),
            })
        end

        local function mixSweep(root)
            if not root then return end
            for _, d in ipairs(root:GetDescendants()) do
                if d:IsA("UIStroke") then
                    -- alternate stroke tones for depth
                    d.Color = mixMid
                elseif d:IsA("Frame") then
                    local n = tostring(d.Name or "")
                    if n == "Underline" or n == "AccentBar" or n == "StatusDot"
                        or n == "StatusGlow" or n == "Selected" or n == "Divider" then
                        d.BackgroundColor3 = A
                    elseif n == "StealProgressFill" or n == "Fill" or n == "ProgressHead" then
                        d.BackgroundColor3 = A
                        applyMixGradient(d, 0)
                    elseif n == "Accent" or n == "TopLine" or n == "TopAccent" then
                        d.BackgroundColor3 = B
                        applyMixGradient(d, 0)
                    end
                elseif d:IsA("TextLabel") or d:IsA("TextButton") then
                    local n = string.lower(tostring(d.Name or ""))
                    if n:find("title", 1, true) or n:find("logo", 1, true) then
                        d.TextColor3 = B
                        applyMixGradient(d, 90)
                    elseif n:find("neon", 1, true) or n == "stealmode" or n:find("discord", 1, true)
                        or n:find("speed", 1, true) then
                        d.TextColor3 = A
                    elseif n:find("caption", 1, true) or n:find("subtitle", 1, true) then
                        d.TextColor3 = mixSoft
                    end
                elseif d:IsA("TextButton") then
                    local stroke = d:FindFirstChildOfClass("UIStroke")
                    if stroke then stroke.Color = A end
                end
            end
        end

        mixSweep(gui)
        mixSweep(main)
        mixSweep(MobilePanel)
        mixSweep(pbFrame)
        mixSweep(tpBatFloatingButton)
        mixSweep(instaResetFloatingButton)

        if progressFill then
            progressFill.BackgroundColor3 = A
            applyMixGradient(progressFill, 0)
        end
        if pbFrame then
            local accent = pbFrame:FindFirstChild("AccentBar")
            if accent then
                accent.BackgroundColor3 = A
                applyMixGradient(accent, 0)
            end
        end

        -- Las imágenes conservan sus colores originales; no aplicar gradiente de tema.
        if scriptLogoRef then
            local grad = scriptLogoRef:FindFirstChildOfClass("UIGradient")
            if grad then grad:Destroy() end
            scriptLogoRef.ImageColor3 = Color3.fromRGB(255, 255, 255)
        end

        if colorSelectorLabel then
            if currentColorTheme == "RedWhite" or isRedWhite then
                colorSelectorLabel.Text = "Red + White"
            elseif currentColorTheme == "WhitePurple" or currentColorTheme == "BlackWhite" then
                colorSelectorLabel.Text = "White + Purple"
            elseif currentColorTheme == "Green" then
                colorSelectorLabel.Text = "Green"
            end
            colorSelectorLabel.TextColor3 = A
            applyMixGradient(colorSelectorLabel, 0)
        end

        -- Floating buttons: estilo Lonely, con acento de tema solo en los estados activos.
        if MobilePanel and type(paintFloatingBtn) == "function" then
            for _, btn in ipairs(MobilePanel:GetChildren()) do
                if btn:IsA("TextButton") then
                    pcall(paintFloatingBtn, btn, btn:GetAttribute("MobActive") == true)
                end
            end
        end

        -- Background image: blend tint toward secondary slightly so it is not flat
        if main then
            local bg = main:FindFirstChild("BackgroundImage")
            if bg and bg:IsA("ImageLabel") and backgroundMode ~= "None" then
                bg.ImageColor3 = Color3.fromRGB(255, 255, 255)
            end
        end
        if K7DuelsUI.art and K7DuelsUI.art:IsA("ImageLabel") and backgroundMode ~= "None" then
            K7DuelsUI.art.ImageColor3 = Color3.fromRGB(255, 255, 255)
        end

        -- Steal slide
        if _G._kryvoxHubStealSlide then
            _G._kryvoxHubStealSlide.BackgroundColor3 = A
            applyMixGradient(_G._kryvoxHubStealSlide, 90)
            local ss = _G._kryvoxHubStealSlide:FindFirstChildOfClass("UIStroke")
            if ss then ss.Color = mixMid end
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
                    if orig:GetAttribute("K7DuelsOutfitOriginalTransparency") == nil then
                        orig:SetAttribute("K7DuelsOutfitOriginalTransparency", orig.Transparency)
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
            local originalTransparency = part:GetAttribute("K7DuelsOutfitOriginalTransparency")
            if originalTransparency ~= nil then
                part.Transparency = originalTransparency
                part:SetAttribute("K7DuelsOutfitOriginalTransparency", nil)
            end
            local originalLocalTransparency = part:GetAttribute("K7DuelsOutfitOriginalLocalTransparency")
            if originalLocalTransparency ~= nil then
                part.LocalTransparencyModifier = originalLocalTransparency
                part:SetAttribute("K7DuelsOutfitOriginalLocalTransparency", nil)
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
    if head and head:IsA("MeshPart") and head:GetAttribute("K7DuelsOutfitModifiedMeshPart") then
        pcall(function()
            head.MeshId = head:GetAttribute("K7DuelsOutfitOriginalMeshId") or ""
            head.TextureID = head:GetAttribute("K7DuelsOutfitOriginalTextureId") or ""
        end)
        head:SetAttribute("K7DuelsOutfitModifiedMeshPart", nil)
        head:SetAttribute("K7DuelsOutfitOriginalMeshId", nil)
        head:SetAttribute("K7DuelsOutfitOriginalTextureId", nil)
    elseif head then
        local specialMesh = head:FindFirstChildWhichIsA("SpecialMesh")
        if specialMesh and specialMesh:GetAttribute("K7DuelsOutfitCreatedMesh") then
            specialMesh:Destroy()
        elseif specialMesh and specialMesh:GetAttribute("K7DuelsOutfitModifiedMesh") then
            specialMesh.MeshId = specialMesh:GetAttribute("K7DuelsOutfitOriginalMeshId") or ""
            specialMesh.TextureId = specialMesh:GetAttribute("K7DuelsOutfitOriginalTextureId") or ""
            specialMesh:SetAttribute("K7DuelsOutfitModifiedMesh", nil)
            specialMesh:SetAttribute("K7DuelsOutfitOriginalMeshId", nil)
            specialMesh:SetAttribute("K7DuelsOutfitOriginalTextureId", nil)
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
                    local original = part:GetAttribute("K7DuelsOriginalTransparency")
                    if original ~= nil then part.Transparency = original; part:SetAttribute("K7DuelsOriginalTransparency", nil) end
                    local originalLocal = part:GetAttribute("K7DuelsOriginalLocalTransparency")
                    if originalLocal ~= nil then part.LocalTransparencyModifier = originalLocal; part:SetAttribute("K7DuelsOriginalLocalTransparency", nil) end
                end
            end
        elseif item:IsA("Shirt") then
            local original = item:GetAttribute("K7DuelsOriginalTemplate")
            if original ~= nil then item.ShirtTemplate = original; item:SetAttribute("K7DuelsOriginalTemplate", nil) end
        elseif item:IsA("Pants") then
            local original = item:GetAttribute("K7DuelsOriginalTemplate")
            if original ~= nil then item.PantsTemplate = original; item:SetAttribute("K7DuelsOriginalTemplate", nil) end
        elseif item:IsA("ShirtGraphic") then
            local original = item:GetAttribute("K7DuelsOriginalGraphic")
            if original ~= nil then item.Graphic = original; item:SetAttribute("K7DuelsOriginalGraphic", nil) end
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
    labels = {"OFF", "ALIEN", "OUTFIT", "OUTFIT 2", "OUTFIT 3", "OUTFIT 4", "OUTFIT 5", "OUTFIT 6", "NIGHT", "NEW SKIN", "BRUJA AMBAR", "CALABAZA NOCTURNA", "ESPANTAPAJAROS", "ESQUELETO HOMBRE", "VAMPIRO HOMBRE", "VAQUERO CALABAZA", "ZOMBIE HOMBRE", "REY CALABAZA"},
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
label = "NIGHT",
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
{
label = "BRUJA AMBAR",
clearOriginalWearables = true,
skinColor = Color3.fromRGB(236, 191, 143),
items = {14969599491, 122361157825498, 62234425, 124774402858872},
},
{
label = "CALABAZA NOCTURNA",
clearOriginalWearables = true,
skinColor = Color3.fromRGB(184, 103, 51),
items = {117848461472994, 134759794966135, 63690008, 103944012394680},
},
{
label = "ESPANTAPAJAROS",
clearOriginalWearables = true,
skinColor = Color3.fromRGB(176, 145, 101),
items = {133373434079601, 116430183541544, 62234425, 122711972928841},
},
{
label = "ESQUELETO HOMBRE",
outfitId = 131929496,
clearOriginalWearables = true,
skinColor = Color3.fromRGB(202, 202, 202),
scales = {HeightScale = 1.02, WidthScale = 0.93, DepthScale = 0.92, HeadScale = 0.95, BodyTypeScale = 0, ProportionScale = 0},
items = {113499282337185, 96226837634971, 63690008, 116457228458722},
},
{
label = "VAMPIRO HOMBRE",
outfitId = 131929496,
clearOriginalWearables = true,
skinColor = Color3.fromRGB(222, 213, 226),
scales = {HeightScale = 1.05, WidthScale = 0.90, DepthScale = 0.90, HeadScale = 0.95, BodyTypeScale = 0, ProportionScale = 0},
items = {80644348674014, 123927809639603, 376524487, 94423001457435},
},
{
label = "VAQUERO CALABAZA",
outfitId = 131929496,
clearOriginalWearables = true,
skinColor = Color3.fromRGB(184, 126, 83),
scales = {HeightScale = 0.98, WidthScale = 1.05, DepthScale = 1.03, HeadScale = 0.98, BodyTypeScale = 0, ProportionScale = 0},
items = {108557169498554, 72666241329412, 62234425, 94423001457435},
},
{
label = "ZOMBIE HOMBRE",
outfitId = 131929496,
clearOriginalWearables = true,
skinColor = Color3.fromRGB(227, 227, 232),
scales = {HeightScale = 0.98, WidthScale = 1.04, DepthScale = 1.02, HeadScale = 1, BodyTypeScale = 0, ProportionScale = 0},
items = {104795596165657, 106426161052915, 1103003368, 116457228458722},
},
{
label = "REY CALABAZA",
outfitId = 131929496,
clearOriginalWearables = true,
skinColor = Color3.fromRGB(226, 124, 47),
scales = {HeightScale = 1.04, WidthScale = 1.00, DepthScale = 1.00, HeadScale = 0.98, BodyTypeScale = 0, ProportionScale = 0},
items = {112891160477226, 72666241329412, 376524487, 94423001457435},
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
local ASSET_INFO_CACHE_FILE="K7DuelsAvatarAssets.json"
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
if not directOutfitId or option.clearOriginalWearables then
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
statusText.TextColor3 = good and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(190, 190, 198)
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
        warn("[K7 DUELS] No se pudo cargar el modulo de avatares VX7 (loadstring no disponible).")
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
        if _G.K7DuelsSession ~= _mySession or VX7A.index == 0 then return end
        task.delay(1.5, function()
            if _G.K7DuelsSession == _mySession and VX7A.index ~= 0 then VX7A.apply(VX7A.index) end
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
        if head:GetAttribute("K7DuelsOutfitOriginalTransparency") == nil then
            head:SetAttribute("K7DuelsOutfitOriginalTransparency", head.Transparency)
            head:SetAttribute("K7DuelsOutfitOriginalLocalTransparency", head.LocalTransparencyModifier)
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
                            if part:GetAttribute("K7DuelsOutfitOriginalTransparency") == nil then
                                part:SetAttribute("K7DuelsOutfitOriginalTransparency", part.Transparency)
                                part:SetAttribute("K7DuelsOutfitOriginalLocalTransparency", part.LocalTransparencyModifier)
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
                if limb:GetAttribute("K7DuelsOutfitOriginalTransparency") == nil then
                    limb:SetAttribute("K7DuelsOutfitOriginalTransparency", limb.Transparency)
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
                    if part:GetAttribute("K7DuelsOriginalTransparency") == nil then
                        part:SetAttribute("K7DuelsOriginalTransparency", part.Transparency)
                        part:SetAttribute("K7DuelsOriginalLocalTransparency", part.LocalTransparencyModifier)
                    end
                    part.Transparency = 1
                    part.LocalTransparencyModifier = 1
                end
            end
        elseif item:IsA("Shirt") then
            if item:GetAttribute("K7DuelsOriginalTemplate") == nil then item:SetAttribute("K7DuelsOriginalTemplate", item.ShirtTemplate) end
            item.ShirtTemplate = ""
        elseif item:IsA("Pants") then
            if item:GetAttribute("K7DuelsOriginalTemplate") == nil then item:SetAttribute("K7DuelsOriginalTemplate", item.PantsTemplate) end
            item.PantsTemplate = ""
        elseif item:IsA("ShirtGraphic") then
            if item:GetAttribute("K7DuelsOriginalGraphic") == nil then item:SetAttribute("K7DuelsOriginalGraphic", item.Graphic) end
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
            if not head:GetAttribute("K7DuelsOutfitModifiedMeshPart") then
                head:SetAttribute("K7DuelsOutfitOriginalMeshId", head.MeshId)
                head:SetAttribute("K7DuelsOutfitOriginalTextureId", head.TextureID)
                head:SetAttribute("K7DuelsOutfitModifiedMeshPart", true)
            end
            head.MeshId = cfg.headMesh
            head.TextureID = cfg.headTexture or ""
        end)
    end
    if not done then
        local sm = head:FindFirstChildWhichIsA("SpecialMesh")
        if not sm then
            sm = Instance.new("SpecialMesh")
            sm:SetAttribute("K7DuelsOutfitCreatedMesh", true)
        elseif not sm:GetAttribute("K7DuelsOutfitModifiedMesh") then
            sm:SetAttribute("K7DuelsOutfitOriginalMeshId", sm.MeshId)
            sm:SetAttribute("K7DuelsOutfitOriginalTextureId", sm.TextureId)
            sm:SetAttribute("K7DuelsOutfitModifiedMesh", true)
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
antiFlingEnabled = false
jumpEnabled = false
spinEnabled = false
spinBrainrotEnabled = false
-- SPIN DISABLED BY USER REQUEST
spinSpeed = 18
spinBrainrotSpeed = 20
_spinConn = nil
_spinBrainrotConn = nil
setSpinVisual = nil
setSpinBrainrotVisual = nil
laggerToggled = false
laggerCarryToggled = false
medusaCounterEnabled = false
batCounterEnabled = false
unwalkEnabled = false
autoLeftEnabled = false
autoRightEnabled = false
autoBatEnabled = false
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
hiddenButtons = {}
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
    if useVenixCarryEngine and K7DuelsVenixCarry and K7DuelsVenixCarry:isRunning() then return K7DuelsVenixCarry:getActiveSpeed() end
    if laggerCarryToggled then return LAGGER_CARRY_SPEED
    elseif laggerToggled then return LAGGER_SPEED
    elseif speedMode then return CS
    else return NS end
end

function getSpeedModeName()
    if useVenixCarryEngine and K7DuelsVenixCarry and K7DuelsVenixCarry.softStealEnabled and K7DuelsVenixCarry.softStealLatched then return "AUTO CARRY" end
    if laggerToggled or laggerCarryToggled then return "LAGGER"
    elseif speedMode then return "CARRY"
    else return "NORMAL" end
end

-- ============================================================
-- ANTI DROP / CARRY SPEED — lógica NIGHT (Valore / Ambitious)
-- El juego ve 16 studs/s; la velocidad real la escribe el hub
-- en HRP (Carry / Normal / Lagger). checkcaller() deja pasar
-- las escrituras del script.
-- ============================================================
local _s2VelState = {root = nil, v = _V3zero}
local _velChecked = setmetatable({}, {__mode = "k"})
local _hookedVelParts = {}
local _velocityHook = _G.__K7DuelsVelocityHook or {hooked = false, roots = setmetatable({}, {__mode = "k"})}
_G.__K7DuelsVelocityHook = _velocityHook

local VS_FAKE = 16
local spoofedVelocity = _V3zero
local SPOOF_NAMES = { HumanoidRootPart = true }

local function isSpoofTarget(self)
    if typeof(self) ~= "Instance" then return false end
    if not self:IsA("BasePart") then return false end
    if not SPOOF_NAMES[self.Name] then return false end
    local char = LP.Character
    return char ~= nil and self:IsDescendantOf(char)
end

local function _hookVelHRP(root)
    if not root then return end
    _s2VelState.root = root
    _velChecked[root] = true
    _velocityHook.roots[root] = true
    if _velocityHook.hooked then return end
    if type(getrawmetatable) ~= "function" or type(setreadonly) ~= "function"
        or type(newcclosure) ~= "function" or type(checkcaller) ~= "function" then return end
    pcall(function()
        local mt = getrawmetatable(game)
        if not mt then return end
        setreadonly(mt, false)
        local oldIndex = mt.__index
        mt.__index = newcclosure(function(self, key)
            if not checkcaller() and (key == "AssemblyLinearVelocity" or key == "Velocity") then
                if isSpoofTarget(self) then
                    return spoofedVelocity
                end
            end
            if type(oldIndex) == "function" then
                return oldIndex(self, key)
            end
            return oldIndex[key]
        end)
        local oldNewIndex = mt.__newindex
        mt.__newindex = newcclosure(function(self, key, value)
            if not checkcaller() and (key == "AssemblyLinearVelocity" or key == "Velocity") then
                if isSpoofTarget(self) then
                    spoofedVelocity = value
                    return
                end
            end
            if type(oldNewIndex) == "function" then
                return oldNewIndex(self, key, value)
            end
            oldNewIndex[key] = value
        end)
        setreadonly(mt, true)
        _velocityHook.hooked = true
    end)
end

local function _setupVelChecked(character)
    _velocityHook.roots = setmetatable({}, {__mode = "k"})
    _velChecked = setmetatable({}, {__mode = "k"})
    if not character then _s2VelState.root = nil; return nil end
    local root = character:WaitForChild("HumanoidRootPart", 5)
    if root then
        _s2VelState.root = root
        _velChecked[root] = true
        _velocityHook.roots[root] = true
    end
    return root
end

if LP.Character then _hookVelHRP(_setupVelChecked(LP.Character)) end

-- Actualiza la velocidad falsa que lee el juego (siempre ~16)
local function updateFakeVelocity()
    local char = LP.Character
    local hum  = char and char:FindFirstChildOfClass("Humanoid")
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not char or not hum or not root or hum.Health <= 0 then return end
    local dir = hum.MoveDirection
    if dir.Magnitude > 0.05 then
        pcall(function()
            if root.SetNetworkOwner then root:SetNetworkOwner(LP) end
        end)
        local unit = dir.Unit
        local y = root.AssemblyLinearVelocity.Y
        spoofedVelocity = _V3new(unit.X * VS_FAKE, y, unit.Z * VS_FAKE)
    else
        local y = root.AssemblyLinearVelocity.Y
        spoofedVelocity = _V3new(0, y, 0)
    end
end
do
    local sig = RunService.PreSimulation or RunService.Stepped
    sig:Connect(updateFakeVelocity)
end

local function _isRagdollState(hum)
    if not hum then return true end
    local state = hum:GetState()
    return hum.PlatformStand or state == Enum.HumanoidStateType.Physics
        or state == Enum.HumanoidStateType.Ragdoll or state == Enum.HumanoidStateType.FallingDown
end

-- Escritura real de velocidad (pasa checkcaller) — misma lógica NIGHT/Migizin
local function _applyVelocitySpeed(direction, speed, root)
    if not root or not root.Parent then return end
    if autoBatEnabled or TPBatState.enabled or (_G.__K7DuelsIsBatV2 and _G.__K7DuelsIsBatV2()) then return end
    if type(speed) ~= "number" or speed ~= speed or speed <= 0 or speed == math.huge then return end
    local y = root.AssemblyLinearVelocity.Y
    if direction and direction.Magnitude > 0.05 then
        pcall(function()
            if root.SetNetworkOwner then root:SetNetworkOwner(LP) end
        end)
        local unit = direction.Unit
        local vel = _V3new(unit.X * speed, y, unit.Z * speed)
        root.AssemblyLinearVelocity = vel
        pcall(function() root.Velocity = vel end)
    else
        local vel = _V3new(0, y, 0)
        root.AssemblyLinearVelocity = vel
        pcall(function() root.Velocity = vel end)
    end
    _G.__K7DuelsLiveSpeed = {t = os.clock(), v = speed}
end

function getAutoPathSpeed()
    if laggerCarryToggled then return LAGGER_CARRY_SPEED
    elseif laggerToggled then return LAGGER_SPEED end
    return NS
end

        K7DuelsVenixCarry = {
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
                if self.softStealEnabled then
                    local _, distance = self:getNearestSoftStealAnimal(self.softStealRadius)
                    if distance and distance <= self.softStealRadius then
                        self.softStealLatched = true
                        return self.softStealSpeed
                    end
                    if self.softStealLatched and self:isCarrying() then
                        return self.softStealSpeed
                    end
                    self.softStealLatched = false
                end
                if self.laggerMode == 1 then
                    return self.laggerSpeed
                end
                if self.laggerMode == 2 then
                    return self.laggerCarrySpeed
                end
                if self.speedToggled then
                    return self.carrySpeed
                end
                return self.normalSpeed
            end,
            getStatus = function(self)
                if not (self._state and (self._state.autoLeftEnabled or self._state.autoRightEnabled)) then
                    if self.softStealEnabled then
                        local _, distance = self:getNearestSoftStealAnimal(self.softStealRadius)
                        if
                            distance and distance <= self.softStealRadius
                            or self.softStealLatched and self:isCarrying()
                        then
                            return "AUTO CARRY", self.softStealSpeed
                        end
                    end
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
                if K7DuelsVenixCarry._lvBoost and K7DuelsVenixCarry._lvBoost.Parent then
                    pcall(function()
                        K7DuelsVenixCarry._lvBoost:Destroy()
                    end)
                end
                if K7DuelsVenixCarry._lvAtt and K7DuelsVenixCarry._lvAtt.Parent then
                    pcall(function()
                        K7DuelsVenixCarry._lvAtt:Destroy()
                    end)
                end
                K7DuelsVenixCarry._lvBoost = nil
                K7DuelsVenixCarry._lvAtt = nil
            end
            local function setupLV(parent)
                if K7DuelsVenixCarry._lvBoost and K7DuelsVenixCarry._lvBoost.Parent == parent then
                    return
                end
                destroyLV()
                local attachment = Instance.new("Attachment")
                attachment.Parent = parent
                local linearVelocity = Instance.new("LinearVelocity")
                linearVelocity.Name = "K7DuelsCarryBoost"
                attachment.Name = "K7DuelsCarryAttachment"
                linearVelocity.Attachment0 = attachment
                linearVelocity.VelocityConstraintMode = Enum.VelocityConstraintMode.Plane
                linearVelocity.PrimaryTangentAxis = _V3new(1, 0, 0)
                linearVelocity.SecondaryTangentAxis = _V3new(0, 0, 1)
                linearVelocity.MaxForce = K7DuelsVenixCarry._maxForce
                linearVelocity.PlaneVelocity = Vector2.zero
                linearVelocity.RelativeTo = Enum.ActuatorRelativeTo.World
                linearVelocity.Parent = parent
                K7DuelsVenixCarry._lvAtt = attachment
                K7DuelsVenixCarry._lvBoost = linearVelocity
                pcall(function()
                    parent:SetNetworkOwner(LP)
                end)
            end
            K7DuelsVenixCarry.scanSoftStealAnimals = function(self)
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
            K7DuelsVenixCarry.startSoftStealScanner = function(callback)
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
            K7DuelsVenixCarry.stopSoftStealScanner = function(self)
                self._softStealScanning = false
                if self._softStealScanner then
                    self._softStealScanner:Disconnect()
                    self._softStealScanner = nil
                end
            end
            K7DuelsVenixCarry.getNearestSoftStealAnimal = function(self, radius)
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
            K7DuelsVenixCarry.updateMovement = function(self, deltaTime)
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
                    if not K7DuelsVenixCarry._lvBoost or K7DuelsVenixCarry._lvBoost.Parent ~= humanoidRootPart then
                        setupLV(humanoidRootPart)
                    end
                    local lvBoost = K7DuelsVenixCarry._lvBoost
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
                elseif K7DuelsVenixCarry._lvBoost then
                    K7DuelsVenixCarry._lvBoost.PlaneVelocity = Vector2.zero
                    if K7DuelsVenixCarry._lvBoost.Enabled then
                        K7DuelsVenixCarry._lvBoost.Enabled = false
                    end
                end
            end
            K7DuelsVenixCarry.start = function(deltaTime236)
                if deltaTime236._heartbeatConn then
                    return
                end
                deltaTime236._heartbeatConn = RunService.Heartbeat:Connect(function(deltaTime)
                    if _mySession ~= _G.K7DuelsSession then deltaTime236:stop(); return end
                    deltaTime236.normalSpeed = NS
                    deltaTime236.carrySpeed = CS
                    deltaTime236.laggerSpeed = LAGGER_SPEED
                    deltaTime236.laggerCarrySpeed = LAGGER_CARRY_SPEED
                    deltaTime236.speedToggled = speedMode
                    deltaTime236.laggerMode = laggerCarryToggled and 2 or (laggerToggled and 1 or 0)
                    deltaTime236._state = {autoLeftEnabled = autoLeftEnabled, autoRightEnabled = autoRightEnabled}
                    deltaTime236._dropInProgress = dropActive or _G.IsDropping or autoLeftEnabled or autoRightEnabled
                    deltaTime236._batAimbotToggled = autoBatEnabled or TPBatState.enabled
                        or (_G.__K7DuelsIsBatV2 and _G.__K7DuelsIsBatV2())
                    deltaTime236:updateMovement(deltaTime)
                end)
                if deltaTime236.softStealEnabled then
                    deltaTime236:startSoftStealScanner()
                end
                print("[CarrySystem] Activado")
            end
            K7DuelsVenixCarry.stop = function(self)
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
    K7DuelsVenixCarry.setNormalSpeed = function(self, value)
        self.normalSpeed = _clamp(value, 1, 500)
    end
    K7DuelsVenixCarry.setCarrySpeed = function(self, value)
        self.carrySpeed = _clamp(value, 1, 500)
    end
    K7DuelsVenixCarry.setLaggerSpeed = function(self, value)
        self.laggerSpeed = _clamp(value, 0.1, 500)
    end
    K7DuelsVenixCarry.setLaggerCarrySpeed = function(self, value)
        self.laggerCarrySpeed = _clamp(value, 0.1, 500)
    end
    K7DuelsVenixCarry.setSoftStealSpeed = function(self, value)
        self.softStealSpeed = _clamp(value, 1, 500)
    end
    K7DuelsVenixCarry.setSoftStealRadius = function(self, value)
        self.softStealRadius = _clamp(value, 1, 200)
    end
    K7DuelsVenixCarry.toggleCarryMode = function(self)
        self.speedToggled = not self.speedToggled
    end
    K7DuelsVenixCarry.setLaggerMode = function(self, mode)
        if mode == 0 then
            self.laggerMode = 0
        elseif mode == 1 then
            self.laggerMode = 1
        elseif mode == 2 then
            self.laggerMode = 2
        end
    end
    K7DuelsVenixCarry.toggleLaggerMode = function(self)
        if self.laggerMode == 0 then
            self.laggerMode = 1
        elseif self.laggerMode == 1 then
            self.laggerMode = 2
        else
            self.laggerMode = 0
        end
    end
    K7DuelsVenixCarry.setSoftStealEnabled = function(self, softStealEnabled)
        self.softStealEnabled = softStealEnabled
        if softStealEnabled then
            self:startSoftStealScanner()
        else
            self:stopSoftStealScanner()
            self.softStealLatched = false
        end
    end
    K7DuelsVenixCarry.toggleSoftSteal = function(self)
        self:setSoftStealEnabled(not self.softStealEnabled)
    end
    K7DuelsVenixCarry.isRunning = function(self)
        return self._heartbeatConn ~= nil
    end
    K7DuelsVenixCarry.getCurrentSpeed = function(self)
        return self:getActiveSpeed()
    end

-- Auto Carry integrado desde BlessCalabaza (solo este motor).
;(function()local K7DuelsBlessCarryRT={active=false,previous=nil,conn=nil,spots={},nextScan=0,armed=true,latched=false,held=false,}local function blessk7BlessIgnoredTool(name)local n=tostring(name or""):lower()return n:find("bat")or n:find("slap")or n:find("medusa")or n:find("head")or n:find("stone")end local function blessk7BlessIsCarrying(char)if not char then return false end if LP:GetAttribute("Stealing")==true or LP:GetAttribute("AntiKick")==true or char:GetAttribute("Stealing")==true then return true end for _,child in ipairs(char:GetChildren())do if child:IsA("Tool")and not verueuxBlessIgnoredTool(child.Name)then return true end if child:IsA("Model")then local n=child.Name:lower()if n:find("brainrot")or n:find("animal")or n:find("carry")or n:find("grab")or n:find("steal")or n:find("hold")then return true end end end return false end local function refreshSpeed()resetMovementState()if refreshSpeedModeLabel then pcall(refreshSpeedModeLabel)end if mobSetCarry then pcall(mobSetCarry,speedMode==true)end end local function enableCarry()if K7DuelsBlessCarryRT.active then return end K7DuelsBlessCarryRT.previous={speedMode=speedMode,laggerToggled=laggerToggled,}K7DuelsBlessCarryRT.active=true laggerToggled=false speedMode=true refreshSpeed()end local function disableCarry()if not K7DuelsBlessCarryRT.active then return end local prev=K7DuelsBlessCarryRT.previous K7DuelsBlessCarryRT.active=false K7DuelsBlessCarryRT.previous=nil if prev then speedMode=prev.speedMode==true laggerToggled=prev.laggerToggled==true else speedMode=false end refreshSpeed()end local function scanSpots()local spots={}local plots=workspace:FindFirstChild("Plots")if plots then for _,plot in ipairs(plots:GetChildren())do local sign=plot:FindFirstChild("PlotSign")local yourBase=sign and sign:FindFirstChild("YourBase")local mine=yourBase and yourBase:IsA("BillboardGui")and yourBase.Enabled==true if not mine then local podiums=plot:FindFirstChild("AnimalPodiums")if podiums then for _,podium in ipairs(podiums:GetChildren())do local base=podium:FindFirstChild("Base")local spawnPart=base and base:FindFirstChild("Spawn")if spawnPart then table.insert(spots,spawnPart.Position)end end end end end end K7DuelsBlessCarryRT.spots=spots end local function inSoftRange(char)local root=char and char:FindFirstChild("HumanoidRootPart")if not root then return false end local now=tick()if now>=K7DuelsBlessCarryRT.nextScan then K7DuelsBlessCarryRT.nextScan=now+0.5 scanSpots()end local range=tonumber(_G.M4AutoSpeedRange) or (K7DuelsVenixCarry and K7DuelsVenixCarry.softStealRadius) or 15 for _,spot in ipairs(K7DuelsBlessCarryRT.spots)do if(root.Position-spot).Magnitude<=range then return true end end return false end _G.__K7DuelsBlessAutoCarryStart=function()if K7DuelsBlessCarryRT.conn then pcall(function()K7DuelsBlessCarryRT.conn:Disconnect()end)K7DuelsBlessCarryRT.conn=nil end K7DuelsBlessCarryRT.conn=RunService.RenderStepped:Connect(function()if _G.M4AutoSpeedEnabled~=true then disableCarry()return end if autoLeftEnabled or autoRightEnabled then disableCarry()speedMode=false laggerToggled=false refreshSpeed()return end local char=LP.Character local hum=char and char:FindFirstChildOfClass("Humanoid")if not char or not hum or hum.Health<=0 then disableCarry()return end if _G.M4AutoSpeedMode=="Soft Steal"then local inRange=inSoftRange(char)local carrying=verueuxBlessIsCarrying(char)if not inRange then K7DuelsBlessCarryRT.armed=true end if not inRange then K7DuelsBlessCarryRT.latched=false end if inRange and K7DuelsBlessCarryRT.armed and not K7DuelsBlessCarryRT.latched then K7DuelsBlessCarryRT.latched=true K7DuelsBlessCarryRT.held=false enableCarry()end if K7DuelsBlessCarryRT.active then if carrying then K7DuelsBlessCarryRT.held=true elseif K7DuelsBlessCarryRT.held then K7DuelsBlessCarryRT.held=false K7DuelsBlessCarryRT.armed=false K7DuelsBlessCarryRT.latched=false disableCarry()elseif not inRange then disableCarry()end end return end if verueuxBlessIsCarrying(char)then enableCarry()else disableCarry()end end)return true end _G.__K7DuelsBlessAutoCarryStop=function()if K7DuelsBlessCarryRT.conn then pcall(function()K7DuelsBlessCarryRT.conn:Disconnect()end)K7DuelsBlessCarryRT.conn=nil end K7DuelsBlessCarryRT.armed=true K7DuelsBlessCarryRT.latched=false K7DuelsBlessCarryRT.held=false disableCarry()end _G.M4AutoSpeedStart=_G.__K7DuelsBlessAutoCarryStart;_G.M4AutoSpeedStop=_G.__K7DuelsBlessAutoCarryStop;_G.M4LwareAutoCarrySpeed={Start=_G.__K7DuelsBlessAutoCarryStart,Stop=_G.__K7DuelsBlessAutoCarryStop,IsCarrying=verueuxBlessIsCarrying,}end)()
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
    ["Cartoony"] = { idle1="rbxassetid://742637544", idle2="rbxassetid://742638445", walk="rbxassetid://742640026", run="rbxassetid://742638842", jump="rbxassetid://742637942", fall="rbxassetid://742637151", climb="rbxassetid://742636889", swim="rbxassetid://742639220", swimidle="rbxassetid://742639812" },
    ["Bubbly"] = { idle1="rbxassetid://910004836", idle2="rbxassetid://910009958", walk="rbxassetid://910034870", run="rbxassetid://910025107", jump="rbxassetid://910016857", fall="rbxassetid://910001910", climb="rbxassetid://909997997", swim="rbxassetid://910028158", swimidle="rbxassetid://910030921" },
    ["Robot"] = { idle1="rbxassetid://616088211", idle2="rbxassetid://616089559", walk="rbxassetid://616095330", run="rbxassetid://616091570", jump="rbxassetid://616090535", fall="rbxassetid://616087089", climb="rbxassetid://616086039", swim="rbxassetid://616092998", swimidle="rbxassetid://616094091" },
    ["Oldschool"] = { idle1="rbxassetid://5319828216", idle2="rbxassetid://5319831086", walk="rbxassetid://5319847204", run="rbxassetid://5319844329", jump="rbxassetid://5319841935", fall="rbxassetid://5319839762", climb="rbxassetid://5319816685", swim="rbxassetid://5319850266", swimidle="rbxassetid://5319852613" },
    ["Confident"] = { idle1="rbxassetid://1069977950", idle2="rbxassetid://1069987858", walk="rbxassetid://1070017263", run="rbxassetid://1070001516", jump="rbxassetid://1069984524", fall="rbxassetid://1069973677", climb="rbxassetid://1069946257", swim="rbxassetid://1070009914", swimidle="rbxassetid://1070012133" },
    ["Sneaky"] = { idle1="rbxassetid://1132473842", idle2="rbxassetid://1132477671", walk="rbxassetid://1132510133", run="rbxassetid://1132494274", jump="rbxassetid://1132489853", fall="rbxassetid://1132469004", climb="rbxassetid://1132461372", swim="rbxassetid://1132500520", swimidle="rbxassetid://1132506407" },
    ["Cowboy"] = { idle1="rbxassetid://1014390418", idle2="rbxassetid://1014398616", walk="rbxassetid://1014421541", run="rbxassetid://1014401683", jump="rbxassetid://1014394726", fall="rbxassetid://1014384571", climb="rbxassetid://1014380606", swim="rbxassetid://1014406523", swimidle="rbxassetid://1014411816" },
    ["Mage"] = { idle1="rbxassetid://707742142", idle2="rbxassetid://707855907", walk="rbxassetid://707897309", run="rbxassetid://707861613", jump="rbxassetid://707853694", fall="rbxassetid://707829716", climb="rbxassetid://707826056", swim="rbxassetid://707876443", swimidle="rbxassetid://707894699" },
    ["Popstar"] = { idle1="rbxassetid://1212900985", idle2="rbxassetid://1212921803", walk="rbxassetid://1212980338", run="rbxassetid://1212980348", jump="rbxassetid://1212954642", fall="rbxassetid://1212900995", climb="rbxassetid://1213044953", swim="rbxassetid://1212852603", swimidle="rbxassetid://1212998578" },
    ["Princess"] = { idle1="rbxassetid://941003647", idle2="rbxassetid://941013098", walk="rbxassetid://941028902", run="rbxassetid://941015281", jump="rbxassetid://941008832", fall="rbxassetid://941000007", climb="rbxassetid://940996062", swim="rbxassetid://941025398", swimidle="rbxassetid://941018893" },
    ["Superhero"] = { idle1="rbxassetid://616111295", idle2="rbxassetid://616113536", walk="rbxassetid://616122287", run="rbxassetid://616117076", jump="rbxassetid://616115533", fall="rbxassetid://616108001", climb="rbxassetid://616104706", swim="rbxassetid://616119360", swimidle="rbxassetid://616120861" },
    ["Patrol"] = { idle1="rbxassetid://1149612882", idle2="rbxassetid://1150842221", walk="rbxassetid://1151231493", run="rbxassetid://1150967949", jump="rbxassetid://1150944216", fall="rbxassetid://1150938338", climb="rbxassetid://1150909457", swim="rbxassetid://1151204998", swimidle="rbxassetid://1151221899" },
    ["Glitch"] = { idle1="rbxassetid://616088211", idle2="rbxassetid://616089559", walk="rbxassetid://1132510133", run="rbxassetid://616117076", jump="rbxassetid://742637942", fall="rbxassetid://616005863", climb="rbxassetid://656114359", swim="rbxassetid://891621366", swimidle="rbxassetid://616094091" },
    ["Shadow"] = { idle1="rbxassetid://656117400", idle2="rbxassetid://1132477671", walk="rbxassetid://1132510133", run="rbxassetid://656118852", jump="rbxassetid://1083218792", fall="rbxassetid://1083443587", climb="rbxassetid://656114359", swim="rbxassetid://656117400", swimidle="rbxassetid://1132506407" },
    ["Speedster"] = { idle1="rbxassetid://616111295", idle2="rbxassetid://616113536", walk="rbxassetid://1014421541", run="rbxassetid://616117076", jump="rbxassetid://616115533", fall="rbxassetid://742637151", climb="rbxassetid://616086039", swim="rbxassetid://616119360", swimidle="rbxassetid://616120861" },
    ["Dreamy"] = { idle1="rbxassetid://910004836", idle2="rbxassetid://910009958", walk="rbxassetid://941028902", run="rbxassetid://910025107", jump="rbxassetid://616008936", fall="rbxassetid://616005863", climb="rbxassetid://707826056", swim="rbxassetid://910028158", swimidle="rbxassetid://910030921" },
    ["Acrobat"] = { idle1="rbxassetid://1212900985", idle2="rbxassetid://1212921803", walk="rbxassetid://742640026", run="rbxassetid://656118852", jump="rbxassetid://1212954642", fall="rbxassetid://616108001", climb="rbxassetid://1132461372", swim="rbxassetid://742639220", swimidle="rbxassetid://1212998578" },
    ["Titan"] = { idle1="rbxassetid://845397899", idle2="rbxassetid://845397899", walk="rbxassetid://1083178339", run="rbxassetid://616091570", jump="rbxassetid://658409194", fall="rbxassetid://657600338", climb="rbxassetid://891609353", swim="rbxassetid://616092998", swimidle="rbxassetid://845397899" },
    ["Rogue"] = { idle1="rbxassetid://1083445855", idle2="rbxassetid://1083445855", walk="rbxassetid://1132510133", run="rbxassetid://1014401683", jump="rbxassetid://656117878", fall="rbxassetid://1083443587", climb="rbxassetid://1132461372", swim="rbxassetid://750781874", swimidle="rbxassetid://1083445855" },
    ["Party"] = { idle1="rbxassetid://1212900985", idle2="rbxassetid://910009958", walk="rbxassetid://910034870", run="rbxassetid://742638842", jump="rbxassetid://1212954642", fall="rbxassetid://910001910", climb="rbxassetid://1213044953", swim="rbxassetid://1212852603", swimidle="rbxassetid://910030921" },
    -- Packs tomados de BlessCalabaza.lua.
    ["Tryhard"] = { idle1="rbxassetid://133806214992291", idle2="rbxassetid://94970088341563", walk="rbxassetid://707897309", run="rbxassetid://707861613", jump="rbxassetid://116936326516985", fall="rbxassetid://116936326516985", climb="rbxassetid://116936326516985", swim="rbxassetid://116936326516985", swimidle="rbxassetid://116936326516985" },
    ["Crazy"] = { idle1="rbxassetid://133806214992291", idle2="rbxassetid://94970088341563", walk="rbxassetid://134824450619865", run="rbxassetid://134824450619865", jump="rbxassetid://121454505477205", fall="rbxassetid://94788218468396", climb="rbxassetid://121454505477205", swim="rbxassetid://121454505477205", swimidle="rbxassetid://121454505477205" },
}

ANIM_PACK_ORDER = {{"Off", "Off"}, {"Tryhard", "Tryhard"}, {"Crazy", "Crazy"}, {"Zombie", "Zombie"}, {"Ninja", "Ninja"}, {"Knight", "Knight"}, {"Elder", "Elder"}, {"Levitate", "Levitate"}, {"Astronaut", "Astronaut"}, {"Pirate", "Pirate"}, {"Toy", "Toy"}, {"Vampire", "Vampire"}, {"Werewolf", "Werewolf"}, {"Rthro", "Rthro"}, {"Stylish", "Stylish"}, {"Cartoony", "Cartoony"}, {"Bubbly", "Bubbly"}, {"Robot", "Robot"}, {"Oldschool", "Oldschool"}, {"Confident", "Confident"}, {"Sneaky", "Sneaky"}, {"Cowboy", "Cowboy"}, {"Mage", "Mage"}, {"Popstar", "Popstar"}, {"Princess", "Princess"}, {"Superhero", "Superhero"}, {"Patrol", "Patrol"}, {"Glitch", "Glitch"}, {"Shadow", "Shadow"}, {"Speedster", "Speedster"}, {"Dreamy", "Dreamy"}, {"Acrobat", "Acrobat"}, {"Titan", "Titan"}, {"Rogue", "Rogue"}, {"Party", "Party"}}

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
    Float        = {kb = Enum.KeyCode.B, gp = nil},
    InstaReset   = {kb = Enum.KeyCode.H, gp = nil},
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
    Float        = {kb = DEFAULT_KB.Float.kb, gp = DEFAULT_KB.Float.gp},
    InstaReset   = {kb = DEFAULT_KB.InstaReset.kb, gp = DEFAULT_KB.InstaReset.gp},
}

_isResetting = false
_lastSavedJSON = nil
_isLoading = false

CONFIG = {
    AUTO_STEAL_ENABLED = false,
    STEAL_RANGE = 61,              -- Radio de cancelación (Auto Steal)
    STEAL_TRIGGER_RADIUS = 14,     -- Solo empieza si estás a ≤14 studs (Auto Steal)
    HOLD_MIN = 0.05,
    HOLD_MAX = 0.15,
    ENTRY_DELAY = 0.1,
    COOLDOWN = 0.2,
    PRIME_RANGE = 60,
}

local plots = workspace:FindFirstChild("Plots")
local stealConnection = nil

-- ============================================================
-- AUTO STEAL V1  (ported from AutoSteal_v2 / MVP HUB)
-- TriggerRadius 14 | Cancel 61 | Duration 1.3 | stopTime 0.96 | stopRadius 9
-- Mode NX1 = 90% hold before approach
-- ============================================================
local Steal = {
    AutoStealEnabled = false,
    StealRadius = CONFIG.STEAL_RANGE,                 -- cancel radius (61)
    TriggerRadius = CONFIG.STEAL_TRIGGER_RADIUS or 14, -- start radius (14)
    StealDuration = 1.3,
    StealDelay = 0.25,
    Mode = "NX1", -- NX1 = 90% | NX2 = 80%
    Data = {}
}

local isStealing = false
local autoStealMode = "V1"
local autoStealVariant = 1
local autoStealGeneration = 0
autoStealStartedAt = 0
autoStealLastActivity = _tick()
autoStealSupervisorConn = nil
local AUTO_STEAL_VARIANT_NAMES = {"V1", "V2"}
selectedStealMode = "V1"

-- Auto Steal timing constants
local autoGrabSetDelayRadius = 9   -- stopRadius: must be this close to finish
local autoGrabStopTime = 0.96      -- hold phase duration before approach wait
local autoGrabStopEnabled = true

local function setAutoStealMode(mode)
    mode = tostring(mode or "V1")
    if mode == "V2" then
        autoStealVariant = 2
    else
        autoStealVariant = 1
    end
    autoStealMode = AUTO_STEAL_VARIANT_NAMES[autoStealVariant] or "V1"
    selectedStealMode = autoStealMode
end

local function getAutoStealDuration()
    -- Kept for compatibility; V1 uses autoGrabStopTime directly in executeSteal
    if selectedStealMode == "V2" or autoStealMode == "V2" then
        return Steal.StealDuration
    end
    return tonumber(autoGrabStopTime) or 0.96
end

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

-- findNearest: ONLY within TriggerRadius (14), same as Auto Steal
local function findNearestPrompt()
    local char = LP.Character
    if not char then return nil, nil end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return nil, nil end
    local plotsRoot = getPlotsRoot()
    if not plotsRoot then return nil, nil end

    local nearestPrompt, nearestDist, nearestName = nil, _huge, nil
    local rpos = root.Position
    local triggerR = Steal.TriggerRadius or CONFIG.STEAL_TRIGGER_RADIUS or 14

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
                    local dist = _sqrt(dx * dx + dy * dy + dz * dz)
                    if dist < nearestDist and dist <= triggerR then
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

-- executeSteal: full Auto Steal V1 logic (doSteal port)
local function executeSteal(prompt, podName)
    if isStealing or not prompt or not prompt.Parent then return end

    -- prune dead prompts
    for old in pairs(Steal.Data) do
        if not old.Parent then Steal.Data[old] = nil end
    end

    local data = Steal.Data[prompt]
    if not data then
        data = { hold = {}, trigger = {}, ready = true }
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
    data.ready = false
    isStealing = true
    local generation = autoStealGeneration
    autoStealStartedAt = _tick()
    autoStealLastActivity = autoStealStartedAt

    local stopTime = tonumber(autoGrabStopTime) or 0.96
    local stopRadius = tonumber(autoGrabSetDelayRadius) or 9
    local cancelRadius = Steal.StealRadius or CONFIG.STEAL_RANGE or 61
    local duration = Steal.StealDuration or 1.3
    local stopAt = (Steal.Mode == "NX2") and 0.80 or 0.90

    local function stillActive()
        return generation == autoStealGeneration
            and isStealing
            and Steal.AutoStealEnabled
            and CONFIG.AUTO_STEAL_ENABLED
            and _mySession == _G.K7DuelsSession
    end

    local function promptDistance()
        if not prompt or not prompt.Parent then return nil end
        local char = LP.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if not hrp or not hum or hum.Health <= 0 then return nil end
        -- Auto Steal uses prompt.Parent.Parent (Spawn)
        local part = prompt.Parent
        if part and not part:IsA("BasePart") then part = part.Parent end
        if not part or not part:IsA("BasePart") then return nil end
        return (hrp.Position - part.Position).Magnitude
    end

    task.spawn(function()
        local ok, err = pcall(function()
            -- hold phase
            for _, fn in ipairs(data.hold) do task.spawn(fn) end
            local started = _tick()
            local fired = false

            while stillActive() do
                local t = _tick() - started
                if t >= stopTime then break end
                local p = _clamp(t / duration, 0, 1)
                updateStealProgress(p, "STEALING")
                if not prompt.Parent then break end
                local d = promptDistance()
                if d and d > cancelRadius then break end
                task.wait()
            end

            if not stillActive() then return end
            updateStealProgress(stopAt, "APPROACH")

            -- wait until close enough (stopRadius), or timeout / cancel
            local t2 = _tick()
            while stillActive() do
                if _tick() - t2 > 2.2 then
                    -- timeout: free and retry nearest (Auto Steal behavior)
                    data.ready = true
                    isStealing = false
                    autoStealStartedAt = 0
                    updateStealProgress(0, "READY")
                    local np, nn = findNearestPrompt()
                    if np then task.defer(executeSteal, np, nn) end
                    return
                end
                if not prompt.Parent then break end
                local d = promptDistance()
                if d then
                    if d <= stopRadius then break end
                    if d > cancelRadius then
                        data.ready = true
                        isStealing = false
                        autoStealStartedAt = 0
                        updateStealProgress(0, "READY")
                        return
                    end
                end
                task.wait()
            end

            -- final fill + fire
            if stillActive() then
                local fs = _tick()
                local fd = math.max(duration - stopTime, 0.05)
                while stillActive() do
                    local fp = _clamp((_tick() - fs) / fd, 0, 1)
                    updateStealProgress(stopAt + fp * (1 - stopAt), "STEALING")
                    if fp >= 1 and not fired then
                        fired = true
                        pcall(function()
                            for _, f in ipairs(data.trigger) do task.spawn(f) end
                            local r = ReplicatedStorage:FindFirstChild("StealAnimal")
                            if r and podName then
                                pcall(function() r:FireServer(podName) end)
                            end
                            if prompt and prompt.Parent then
                                if type(fireproximityprompt) == "function" then
                                    pcall(fireproximityprompt, prompt)
                                elseif prompt.Fire then
                                    pcall(function() prompt:Fire() end)
                                else
                                    pcall(function()
                                        prompt:InputHoldBegin()
                                        prompt:InputHoldEnd()
                                    end)
                                end
                            end
                        end)
                        break
                    end
                    task.wait()
                end
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
        if not ok then
            warn("[K7 DUELS Auto Steal V1] " .. tostring(err))
        end
    end)
end

-- AUTO GRAB V2 (from Y-out) — uses FEAR findNearestPrompt + hold/trigger
-- =====================================================================
_G.K7DuelsV2Steal = _G.K7DuelsV2Steal or {
    enabled = false,
    radius = 10,
    searchRange = 80,
    holdMin = 1.3,
    holdMax = 2.6,
    entryDelay = 0.2,
    cooldown = 0.05,
    conn = nil,
    active = false,
    lastFire = 0,
}

local function fearV2Dist(prompt)
    local char = LP and LP.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp or not prompt then return 1e9 end
    local n = prompt.Parent
    while n do
        if n:IsA("BasePart") then
            return (hrp.Position - n.Position).Magnitude
        end
        if n:IsA("Model") then
            local ok, p = pcall(function() return n:GetPivot().Position end)
            if ok and p then return (hrp.Position - p).Magnitude end
            return 1e9
        end
        n = n.Parent
    end
    return 1e9
end

local function fearV2Callbacks(prompt)
    local hold, trig = {}, {}
    if type(getconnections) == "function" then
        pcall(function()
            for _, key in ipairs({"PromptButtonHoldBegan", "HoldBegan"}) do
                local sig = prompt[key]
                if sig then
                    local conns = getconnections(sig)
                    if conns then
                        for _, c in ipairs(conns) do
                            if type(c.Function) == "function" then
                                hold[#hold + 1] = c.Function
                            end
                        end
                    end
                end
            end
            local conns = getconnections(prompt.Triggered)
            if conns then
                for _, c in ipairs(conns) do
                    if type(c.Function) == "function" then
                        trig[#trig + 1] = c.Function
                    end
                end
            end
        end)
    end
    return hold, trig
end

local function fearV2DoSteal(prompt, podName)
    local A = _G.K7DuelsV2Steal
    if A.active then return end
    if (_tick() - (A.lastFire or 0)) < (A.cooldown or 0.05) then return end
    if not prompt or not prompt.Parent then return end
    A.active = true
    A.lastFire = _tick()

    local hold, trig = fearV2Callbacks(prompt)
    local t0 = _tick()

    -- start hold
    if #hold > 0 then
        for _, fn in ipairs(hold) do
            task.spawn(function() pcall(fn) end)
        end
    else
        pcall(function()
            if prompt.InputHoldBegin then prompt:InputHoldBegin() end
        end)
    end

    -- hold phase
    while A.enabled and selectedStealMode == "V2" and CONFIG.AUTO_STEAL_ENABLED and prompt.Parent do
        local e = _tick() - t0
        if e >= (A.holdMin or 1.3) then break end
        if type(updateStealProgress) == "function" then
            pcall(updateStealProgress, math.min(e / (A.holdMax or 2.6), 0.9), "STEALING")
        end
        task.wait()
    end

    -- wait in range
    local radius = A.radius or 10
    local close = fearV2Dist(prompt) <= radius
    local deadline = t0 + (A.holdMax or 2.6)
    while A.enabled and selectedStealMode == "V2" and CONFIG.AUTO_STEAL_ENABLED and prompt.Parent do
        if _tick() >= deadline then break end
        if fearV2Dist(prompt) <= radius then
            if not close then task.wait(A.entryDelay or 0.2) end
            break
        end
        if type(updateStealProgress) == "function" then
            pcall(updateStealProgress, 0.9, "APPROACH")
        end
        task.wait()
    end

    local fired = false
    if A.enabled and selectedStealMode == "V2" and CONFIG.AUTO_STEAL_ENABLED and prompt.Parent and fearV2Dist(prompt) <= radius then
        if #trig > 0 then
            for _, fn in ipairs(trig) do
                task.spawn(function() pcall(fn) end)
            end
        else
            pcall(function()
                if type(fireproximityprompt) == "function" then
                    fireproximityprompt(prompt)
                elseif prompt.InputHoldEnd then
                    prompt:InputHoldEnd()
                end
            end)
        end
        local remote = ReplicatedStorage:FindFirstChild("StealAnimal")
        if remote and remote:IsA("RemoteEvent") and podName then
            pcall(function() remote:FireServer(podName) end)
        end
        fired = true
        if type(updateStealProgress) == "function" then
            pcall(updateStealProgress, 1, "COMPLETE")
        end
        task.wait(0.12)
    end

    A.active = false
    if type(updateStealProgress) == "function" then
        pcall(updateStealProgress, 0, "READY")
    end
    return fired
end

function stopAutoStealV2()
    local A = _G.K7DuelsV2Steal
    A.enabled = false
    A.active = false
    if A.conn then
        pcall(function() A.conn:Disconnect() end)
        A.conn = nil
    end
end

function startAutoStealV2()
    local A = _G.K7DuelsV2Steal
    stopAutoStealV2()
    A.enabled = true
    A.active = false
    A.radius = 10
    A.searchRange = math.max(tonumber(CONFIG.STEAL_RANGE) or 61, 50)
    selectedStealMode = "V2"

    local function fearV2FindPrompt()
        -- 1) temporarily widen TriggerRadius so V1 finder can serve V2 search
        local oldR = Steal.StealRadius
        local oldT = Steal.TriggerRadius
        Steal.StealRadius = A.searchRange or 80
        Steal.TriggerRadius = A.searchRange or 80
        local p, n = findNearestPrompt()
        Steal.StealRadius = oldR
        Steal.TriggerRadius = oldT
        if p then return p, n end

        -- 2) wider scan: any Steal ProximityPrompt under Plots
        local char = LP and LP.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then return nil, nil end
        local plots = workspace:FindFirstChild("Plots")
        if not plots then return nil, nil end
        local best, bestD, bestN = nil, 1e9, nil
        local range = A.searchRange or 80
        for _, plot in ipairs(plots:GetChildren()) do
            if isMyPlotByName and isMyPlotByName(plot.Name) then
                -- skip own base
            else
                for _, d in ipairs(plot:GetDescendants()) do
                    if d:IsA("ProximityPrompt") then
                        local at = tostring(d.ActionText or "")
                        local ot = tostring(d.ObjectText or "")
                        if at:lower():find("steal", 1, true) or ot:lower():find("steal", 1, true) or at == "" then
                            local part = d.Parent
                            local pos = nil
                            if part and part:IsA("Attachment") then part = part.Parent end
                            if part and part:IsA("BasePart") then
                                pos = part.Position
                            elseif part and part:IsA("Model") then
                                local ok, piv = pcall(function() return part:GetPivot().Position end)
                                if ok then pos = piv end
                            end
                            if pos then
                                local dist = (hrp.Position - pos).Magnitude
                                if dist < bestD and dist <= range then
                                    best, bestD, bestN = d, dist, plot.Name
                                end
                            end
                        end
                    end
                end
            end
        end
        return best, bestN
    end

    A.conn = RunService.Heartbeat:Connect(function()
        if _mySession ~= _G.K7DuelsSession then return end
        if not A.enabled or not CONFIG.AUTO_STEAL_ENABLED then return end
        if selectedStealMode ~= "V2" then return end
        if A.active then return end

        local p, n = fearV2FindPrompt()
        if p then
            task.spawn(fearV2DoSteal, p, n)
        end
    end)
end

function startAutoSteal()
    -- stop any previous runner
    if stealConnection then
        pcall(function() stealConnection:Disconnect() end)
        stealConnection = nil
    end
    if type(stopAutoStealV2) == "function" then pcall(stopAutoStealV2) end
    isStealing = false

    CONFIG.AUTO_STEAL_ENABLED = true
    Steal.AutoStealEnabled = true
    autoStealLastActivity = _tick()
    selectedStealMode = (tostring(autoStealMode) == "V2") and "V2" or "V1"

    if selectedStealMode == "V2" then
        Steal.StealRadius = 10
        pcall(startAutoStealV2)
        return true
    end

    -- V1 = Auto Steal port (trigger 14 / cancel 61 / hold 0.96 / NX1 90%)
    Steal.StealRadius = CONFIG.STEAL_RANGE or 61
    Steal.TriggerRadius = CONFIG.STEAL_TRIGGER_RADIUS or 14
    Steal.Mode = Steal.Mode or "NX1"

    stealConnection = RunService.Heartbeat:Connect(function()
        if _mySession ~= _G.K7DuelsSession then
            stopAutoSteal()
            return
        end
        if not CONFIG.AUTO_STEAL_ENABLED then return end
        if selectedStealMode == "V2" then return end
        if not Steal.AutoStealEnabled then
            Steal.AutoStealEnabled = true
        end
        -- Auto Steal: while already stealing, do nothing (executeSteal owns the flow)
        if isStealing then return end

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
    if type(stopAutoStealV2) == "function" then pcall(stopAutoStealV2) end
    for _, data in pairs(Steal.Data) do data.ready = true end
    updateStealProgress(0, "READY")
end

if autoStealSupervisorConn then
    pcall(function() autoStealSupervisorConn:Disconnect() end)
end
autoStealSupervisorElapsed = 0
do
    autoStealSupervisorConn = RunService.Heartbeat:Connect(function(dt)
        if _mySession ~= _G.K7DuelsSession then
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
            local alive
            if selectedStealMode == "V2" then
                local A = _G.K7DuelsV2Steal
                alive = A and A.enabled and A.conn ~= nil
            else
                alive = stealConnection and stealConnection.Connected
            end
            if not alive or not Steal.AutoStealEnabled then
                pcall(startAutoSteal)
            elseif selectedStealMode ~= "V2" and isStealing and autoStealStartedAt > 0 and (_tick() - autoStealStartedAt) > 6 then
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
floatRiseBox, floatPowerBox = nil, nil
modeSelectBtn, dropModeBtnRef = nil, nil
autoBatSetVisual, autoLeftSetVisual, autoRightSetVisual, setBatCounterVisual, setMedusaVisual = nil, nil, nil, nil, nil
setAntiRagVisual, setUnwalkVisual, setAntiLagVisual, setLockUIVisual, setInstaGrab = nil, nil, nil, nil, nil
infJumpSetVisual = nil
infJumpModeBtn = nil
autoStealModeBtn = nil
setAntiDieVisual = nil
setAntiFlingVisual = nil
setESPVIsual = nil
setESPLineVisual = nil
mobSetAutoBat, mobSetAutoLeft, mobSetAutoRight, mobSetDropBR, mobSetTpDown, mobSetCarry, mobSetLagger1, mobSetLagger2, mobSetBatV2 = nil, nil, nil, nil, nil, nil, nil, nil, nil
mobSetFloat = nil
mobSetInstaReset = nil
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

function updateStealProgress(value, state)
    value = _clamp(tonumber(value) or 0, 0, 1)
    state = state or "READY"
    stealHud.value, stealHud.state = value, state
    if progressFill then
        progressFill.Size = UDim2.new(value, 0, 1, 0)
        local accent = (type(getThemeColor) == "function" and getThemeColor()) or selectedColor or Color3.fromRGB(255, 255, 255)
        progressFill.BackgroundColor3 = accent
    end
    if progressPct then
        progressPct.Text = _floor(value * 100 + 0.5) .. "%"
        progressPct.TextColor3 = Color3.fromRGB(0, 0, 0)
    end
    if progressStatus then
        progressStatus.Text = state == "APPROACH" and "GET CLOSER" or state
        if state == "READY" or state == "CANCELLED" then
            progressStatus.TextColor3 = Color3.fromRGB(130, 150, 175)
        elseif state == "COMPLETE" then
            progressStatus.TextColor3 = (type(getThemeColor) == "function" and getThemeColor()) or selectedColor or Color3.fromRGB(255, 255, 255)
        elseif state == "APPROACH" then
            progressStatus.TextColor3 = Color3.fromRGB(255, 190, 80)
        else
            progressStatus.TextColor3 = getThemeColor()
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

--  FLOAT (portado de K7 DUELS)
--=========================================================
do
    local old = rawget(_G, "__RivalHubFloat")
    if type(old) == "table" then
        local wasOn = old.running == true or old.conn ~= nil
        old.running = false
        old.cycleToken = (old.cycleToken or 0) + 1
        if old.thread then pcall(task.cancel, old.thread); old.thread = nil end
        if old.conn then pcall(function() old.conn:Disconnect() end); old.conn = nil end
        if wasOn and type(old.groundTP) == "function" then pcall(old.groundTP) end
    end
end

_G.__RivalHubFloat = {
    RISE = 17, RATE = 55, CYCLE = 2.5, PAUSE = 0.5, SAMPLE = 0.08, PIT_MARGIN = 15,
    conn = nil, thread = nil, running = false, locked = false,
    targetY = nil, baseY = nil, baseGround = nil,
    safeValid = false, safeX = 0, safeZ = 0, safeY = 0,
    cycleToken = 0, _params = nil,
}

function _G.__RivalHubFloat.getHRP()
    local c = LP.Character
    if not c then return nil, nil end
    return c:FindFirstChild("HumanoidRootPart"), c:FindFirstChildOfClass("Humanoid")
end

function _G.__RivalHubFloat.arm()
    if _G.__CrystalAntiDieSource then pcall(_G.__CrystalAntiDieSource, "float", true) end
end
function _G.__RivalHubFloat.release()
    if _G.__CrystalAntiDieSource then pcall(_G.__CrystalAntiDieSource, "float", false) end
end

function _G.__RivalHubFloat.findGround(char, hrp)
    local FLOAT = _G.__RivalHubFloat
    local params = FLOAT._params
    if not params then
        params = RaycastParams.new()
        params.FilterType = Enum.RaycastFilterType.Exclude
        params.IgnoreWater = true
        pcall(function() params.RespectCanCollide = true end)
        FLOAT._params = params
    end
    local filter = { char }
    local plist = _GetPlayersCached()
    for i = 1, #plist do
        local plr = plist[i]
        if plr ~= LP and plr.Character then filter[#filter + 1] = plr.Character end
    end
    local half = hrp.Size.Y * 0.5
    if half <= 0 then half = 1 end
    local origin = hrp.Position
    local startY = origin.Y - half - 0.1
    for _ = 1, 6 do
        params.FilterDescendantsInstances = filter
        local res = Workspace:Raycast(Vector3.new(origin.X, startY, origin.Z), Vector3.new(0, -1000, 0), params)
        if not res then return nil, half end
        local part = res.Instance
        if part and part:IsA("BasePart") and part.CanCollide then
            local model = part:FindFirstAncestorOfClass("Model")
            if not (model and model:FindFirstChildOfClass("Humanoid")) then
                return res.Position.Y, half
            end
        end
        if part then filter[#filter + 1] = part end
        startY = res.Position.Y - 0.05
    end
    return nil, half
end

function _G.__RivalHubFloat.isSafeGround(g)
    local FLOAT = _G.__RivalHubFloat
    if not g then return false end
    if FLOAT.baseGround and g < FLOAT.baseGround - FLOAT.PIT_MARGIN then return false end
    return true
end

function _G.__RivalHubFloat.groundTP()
    local FLOAT = _G.__RivalHubFloat
    local char = LP.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum or hum.Health <= 0 then return end

    local pos = hrp.Position
    local x, z = pos.X, pos.Z
    local groundY, half
    pcall(function() groundY, half = FLOAT.findGround(char, hrp) end)

    local relocated = false
    if not FLOAT.isSafeGround(groundY) and FLOAT.safeValid then
        x, z, groundY = FLOAT.safeX, FLOAT.safeZ, FLOAT.safeY
        relocated = true
    end

    local targetY
    if groundY then
        half = half or math.max(hrp.Size.Y * 0.5, 1)
        local off = half * 3
        if hum.RigType ~= Enum.HumanoidRigType.R6 then
            off = half + (hum.HipHeight or (half * 2))
        end
        if off ~= off or off < 1 or off > 12 then off = half * 3 end
        targetY = groundY + off + 0.15
    elseif FLOAT.baseY then
        targetY = FLOAT.baseY
    end

    if targetY and targetY == targetY and targetY > -400 then
        pcall(function()
            if not relocated and pos.Y - targetY < 0.5 then
                hrp.AssemblyLinearVelocity = Vector3.zero
                return
            end
            hrp.CFrame = CFrame.new(x, targetY, z) * hrp.CFrame.Rotation
            hrp.AssemblyLinearVelocity = Vector3.zero
            hrp.AssemblyAngularVelocity = Vector3.zero
        end)
    end
end

function _G.__RivalHubFloat.startLoop()
    local FLOAT = _G.__RivalHubFloat
    if FLOAT.conn then return end
    FLOAT.locked = false
    FLOAT.targetY = nil

    local char0 = LP.Character
    local root0 = char0 and char0:FindFirstChild("HumanoidRootPart")
    local hum0 = char0 and char0:FindFirstChildOfClass("Humanoid")
    if hum0 then
        pcall(function() hum0:ChangeState(Enum.HumanoidStateType.Freefall) end)
    end

    FLOAT.safeValid = false
    FLOAT.baseGround = nil
    if char0 and root0 then
        local ok, g = pcall(FLOAT.findGround, char0, root0)
        if ok and g then
            FLOAT.baseGround = g
            FLOAT.safeX, FLOAT.safeZ, FLOAT.safeY = root0.Position.X, root0.Position.Z, g
            FLOAT.safeValid = true
        end
    end

    local cChar, cRoot, cHum = nil, nil, nil
    local sampleT = 0
    FLOAT.conn = RunService.Heartbeat:Connect(function(dt)
        local char = LP.Character
        if char ~= cChar or not cRoot or not cRoot.Parent then
            cChar = char
            cRoot = char and char:FindFirstChild("HumanoidRootPart") or nil
            cHum  = char and char:FindFirstChildOfClass("Humanoid") or nil
        end
        if not cRoot or not cHum or cHum.Health <= 0 then return end

        local cf  = cRoot.CFrame
        local pos = cf.Position
        local vel = cRoot.AssemblyLinearVelocity

        sampleT = sampleT + dt
        if sampleT >= FLOAT.SAMPLE then
            sampleT = 0
            local ok, g = pcall(FLOAT.findGround, cChar, cRoot)
            if ok and FLOAT.isSafeGround(g) then
                FLOAT.safeX, FLOAT.safeZ, FLOAT.safeY = pos.X, pos.Z, g
                FLOAT.safeValid = true
            elseif ok and FLOAT.safeValid then
                pos = Vector3.new(FLOAT.safeX, pos.Y, FLOAT.safeZ)
                vel = Vector3.new(0, vel.Y, 0)
            end
        end

        if not FLOAT.targetY then
            FLOAT.baseY   = pos.Y
            FLOAT.targetY = pos.Y + FLOAT.RISE
        end
        local y = FLOAT.targetY
        if not FLOAT.locked then
            y = math.min(pos.Y + FLOAT.RATE * dt, FLOAT.targetY)
            if y >= FLOAT.targetY then FLOAT.locked = true end
        end
        cRoot.CFrame = CFrame.new(pos.X, y, pos.Z) * cf.Rotation
        cRoot.AssemblyLinearVelocity = Vector3.new(vel.X, 0, vel.Z)
    end)
end

function _G.__RivalHubFloat.stopLoop(tpDown)
    local FLOAT = _G.__RivalHubFloat
    if FLOAT.conn then
        pcall(function() FLOAT.conn:Disconnect() end)
        FLOAT.conn = nil
    end
    if tpDown then pcall(FLOAT.groundTP) end
end

function _G.__RivalHubFloat.waitGrounded(timeout)
    local FLOAT = _G.__RivalHubFloat
    local deadline = os.clock() + (timeout or 3)
    while os.clock() < deadline do
        if not FLOAT.running then return end
        local hrp, hum = FLOAT.getHRP()
        if not hrp or not hum then return end
        if hum.Health <= 0 then return end
        if hum.FloorMaterial ~= Enum.Material.Air then
            task.wait(FLOAT.PAUSE)
            return
        end
        RunService.Heartbeat:Wait()
    end
end

function _G.__RivalHubFloat.spawnCycle()
    local FLOAT = _G.__RivalHubFloat
    if FLOAT.thread then pcall(task.cancel, FLOAT.thread); FLOAT.thread = nil end
    FLOAT.cycleToken = FLOAT.cycleToken + 1
    local token = FLOAT.cycleToken
    FLOAT.thread = task.spawn(function()
        while FLOAT.running and FLOAT.cycleToken == token do
            task.wait(FLOAT.CYCLE)
            if not FLOAT.running or FLOAT.cycleToken ~= token then break end
            FLOAT.stopLoop(true)
            FLOAT.waitGrounded(3)
            if not FLOAT.running or FLOAT.cycleToken ~= token then break end
            FLOAT.startLoop()
        end
    end)
end

function _G.__RivalHubFloat.enable()
    local FLOAT = _G.__RivalHubFloat
    if FLOAT.running then return end
    FLOAT.running = true
    FLOAT.arm()
    FLOAT.startLoop()
    FLOAT.spawnCycle()
end

function _G.__RivalHubFloat.disable()
    local FLOAT = _G.__RivalHubFloat
    if not FLOAT.running then return end
    FLOAT.running = false
    FLOAT.cycleToken = FLOAT.cycleToken + 1
    if FLOAT.thread then pcall(task.cancel, FLOAT.thread); FLOAT.thread = nil end
    FLOAT.stopLoop(true)
    FLOAT.safeValid = false
    FLOAT.baseGround = nil
    FLOAT.release()
end

function _G.__RivalHubFloatToggle()
    local F = _G.__RivalHubFloat
    if F.running then F.disable() else F.enable() end
    if _G.__RivalHubFloatSetVisual then pcall(_G.__RivalHubFloatSetVisual, F.running) end
    if mobSetFloat then pcall(mobSetFloat, F.running) end
end

function _G.__RivalHubFloatIsRunning()
    return _G.__RivalHubFloat.running == true
end

do

    if _G.InstaResetLoaded then
    else
        _G.InstaResetLoaded = true

        local resetCooldown          = false
        local resetThread            = nil
        local currentResetChar       = nil
        local resetSuccessful        = false
        local stopResetSequence      = false
        local cameraLocked           = false
        local lockedCameraCFrame     = nil
        local _lastInstaResetRequest = 0


        local function instaResetFast()
            if resetCooldown then return end
            resetCooldown     = true
            resetSuccessful   = false
            stopResetSequence = false
            cameraLocked      = false

            local character = LP.Character
            if not character then resetCooldown = false return end
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if not humanoid then resetCooldown = false return end

            local cam = workspace.CurrentCamera
            if cam then
                lockedCameraCFrame = cam.CFrame
                cameraLocked       = true
                cam.CFrame         = lockedCameraCFrame
            end

            currentResetChar = character
            local isRespawning = false

            resetThread = task.spawn(function()
                local attempts          = 0
                local maxAttempts       = 40
                local originalHipHeight = humanoid.HipHeight

                while character and character.Parent and humanoid and humanoid.Health > 0
                      and not isRespawning and not stopResetSequence do
                    if LP.Character ~= character then
                        isRespawning = true
                        break
                    end
                    pcall(function()
                        humanoid.HipHeight  = 1e30
                        humanoid.AutoRotate = true
                        local rootPart = character:FindFirstChild("HumanoidRootPart")
                        if rootPart then rootPart.CanCollide = false end
                        for _, part in ipairs(character:GetChildren()) do
                            if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                                part.CanCollide = false
                            end
                        end
                    end)

                    if not character or not character.Parent or not humanoid
                       or humanoid.Health <= 0 or LP.Character ~= character then
                        resetSuccessful = true
                        break
                    end

                    attempts = attempts + 1
                    if attempts >= maxAttempts then break end
                    task.wait(0.05)
                end

                if not resetSuccessful then
                    if character and character.Parent and humanoid
                       and humanoid.Health > 0 and not isRespawning then
                        pcall(function() humanoid.Health = 0 end)
                        task.wait(0.1)
                        if not character.Parent or humanoid.Health <= 0 then
                            resetSuccessful = true
                        end
                    end
                end

                if not resetSuccessful and character and character.Parent and humanoid then
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

                cameraLocked      = false
                resetCooldown     = false
                resetThread       = nil
                currentResetChar  = nil
                stopResetSequence = false
            end)
        end

        local function instaReset()
            local now = os.clock()
            if now - _lastInstaResetRequest < 0.75 then return end
            _lastInstaResetRequest = now
            instaResetFast()
        end


        LP.CharacterAdded:Connect(function()
            stopResetSequence = true
            if resetThread then pcall(task.cancel, resetThread); resetThread = nil end
            resetCooldown    = false
            currentResetChar = nil
            cameraLocked     = false
        end)

        task.spawn(function()
            while true do
                task.wait(0.016)
                local cam = workspace.CurrentCamera
                if cameraLocked and lockedCameraCFrame and cam then
                    cam.CFrame = lockedCameraCFrame
                end
            end
        end)


        _G.InstaReset = { Trigger = instaReset }
    end
end

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


setAntiFlingVisual = nil

local _antiFlingState = {
    connection    = nil,
    threshold     = 80,
    spinThreshold = 40,
}
local _ANTI_FLING_DRIVE_GRACE = 0.3

local function _afHubSpeedLive()
    local live = _G.__K7DuelsLiveSpeed
    if type(live) ~= "table" then return false end
    local stamp, speed = tonumber(live.t), tonumber(live.v)
    if not stamp or not speed or speed <= 0 then return false end
    return (os.clock() - stamp) <= _ANTI_FLING_DRIVE_GRACE
end

local function _afOwnMoverActive()
    if autoBatEnabled then return true end
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

    esp.Highlight.Name = "K7DuelsESP_Highlight"
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
    nameBillboard.Name = "K7DuelsESP_Name"
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

_G.__K7DuelsRefreshESPTheme = function(accent, outlineColor)
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
    _espLineGui.Name = "K7DuelsESPLine"
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
        if not (spinEnabled or spinBrainrotEnabled) then
            if not hum.AutoRotate then hum.AutoRotate = true end
        end
        return
    end
    local dist = (target.Position - root.Position).Magnitude
    if dist > bodyLockRange then
        if not (spinEnabled or spinBrainrotEnabled) then
            if not hum.AutoRotate then hum.AutoRotate = true end
        end
        return
    end
    if spinEnabled or (spinBrainrotEnabled and _fearSpinCarrying and _fearSpinCarrying()) then
        return -- let spin control rotation
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
    for _, name in ipairs({"K7DuelsSpeedIndicator", "DiscordText", "K7DuelsDiscordTag"}) do
        local old = head:FindFirstChild(name)
        if old then old:Destroy() end
    end
    speedLabel = nil
    local bb = Instance.new("BillboardGui", head)
    bb.Name = "K7DuelsSpeedIndicator"
    bb.Size = UDim2.fromOffset(92, 42)
    bb.StudsOffset = Vector3.new(0, 3.2, 0)
    bb.AlwaysOnTop = true
    bb.LightInfluence = 0
    bb.MaxDistance = 0
    bb.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    -- cuadro contenedor
    local card = Instance.new("Frame", bb)
    card.Name = "SpeedCard"
    card.Size = UDim2.fromScale(1, 1)
    card.BackgroundColor3 = Color3.fromRGB(8, 8, 12)
    card.BackgroundTransparency = 0.15
    card.BorderSizePixel = 0
    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 10)
    local border = Instance.new("UIStroke", card)
    border.Color = (type(getThemeColor) == "function" and getThemeColor()) or Color3.fromRGB(255, 255, 255)
    border.Transparency = 0.35
    border.Thickness = 1.5
    K7DuelsUI.speedStroke = border
    -- label pequeño arriba
    local title = Instance.new("TextLabel", card)
    title.Name = "SpeedTitle"
    title.Size = UDim2.new(1, -8, 0, 12)
    title.Position = UDim2.fromOffset(4, 3)
    title.BackgroundTransparency = 1
    title.Text = "SPEED"
    title.TextColor3 = Color3.fromRGB(180, 180, 190)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 9
    title.TextXAlignment = Enum.TextXAlignment.Center
    title.ZIndex = 3
    -- valor grande adentro del cuadro
    speedLabel = Instance.new("TextLabel", card)
    speedLabel.Name = "SpeedLabel"
    speedLabel.Size = UDim2.new(1, -8, 0, 22)
    speedLabel.Position = UDim2.fromOffset(4, 14)
    speedLabel.BackgroundTransparency = 1
    speedLabel.Text = string.format("%.1f", getActiveMoveSpeed())
    speedLabel.TextColor3 = (type(getThemeColor) == "function" and getThemeColor()) or Color3.fromRGB(255, 255, 255)
    speedLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    speedLabel.TextStrokeTransparency = 0.5
    speedLabel.Font = Enum.Font.GothamBlack
    speedLabel.TextSize = 16
    speedLabel.TextXAlignment = Enum.TextXAlignment.Center
    speedLabel.ZIndex = 3
    local tag = Instance.new("BillboardGui", head)
    tag.Name = "K7DuelsDiscordTag"
    tag.Size = UDim2.fromOffset(210, 24)
    tag.StudsOffset = Vector3.new(0, 5.1, 0)
    tag.AlwaysOnTop = true
    tag.LightInfluence = 0
    tag.MaxDistance = 0
    local text = Instance.new("TextLabel", tag)
    text.Size = UDim2.fromScale(1, 1)
    text.BackgroundTransparency = 1
    text.Text = ""
    text.TextColor3 = Color3.fromRGB(255, 255, 255)
    text.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    text.TextStrokeTransparency = 0.2
    text.Font = Enum.Font.GothamBold
    text.TextSize = 15
    K7DuelsUI.discordLabel = text

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
    if _G.__K7DuelsApplySpeedNow then pcall(_G.__K7DuelsApplySpeedNow) end
end

function toggleLaggerMode()
    if laggerCarryToggled then laggerCarryToggled = false end
    speedMode = false; laggerToggled = not laggerToggled
    resetMovementState()
    if _G.__K7DuelsApplySpeedNow then pcall(_G.__K7DuelsApplySpeedNow) end
end
function toggleLaggerCarryMode()
    if laggerToggled then laggerToggled = false end
    speedMode = false; laggerCarryToggled = not laggerCarryToggled
    resetMovementState()
    if _G.__K7DuelsApplySpeedNow then pcall(_G.__K7DuelsApplySpeedNow) end
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
    if _G.__K7DuelsApplySpeedNow then pcall(_G.__K7DuelsApplySpeedNow) end
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

do
    -- Bat Bypass V2: motor predictivo adaptado de TJNXTDOBFBY03-1.
_G.PhantomBatBypass = _G.PhantomBatBypass or {}
do
    local bypass = _G.PhantomBatBypass
    bypass.Enabled = bypass.Enabled == true
    bypass.Connection = bypass.Connection
    bypass.PreviousAutoRotate = nil
    bypass.Z = bypass.Z or {
        targetPlayer = nil,
        lastTargetPos = nil,
        targetVelocity = Vector3.zero,
        smoothedVelocity = Vector3.zero,
        velocityHistory = {},
        accelerationHistory = {},
        aerialVelocityHistory = {},
        previousDirection = nil,
        lastDirectionChangeTime = 0,
        airborneTime = 0,
        lastActivationTime = 0,
        currentPing = 0.1,
        realPingMs = 0,
    }
    bypass.Config = bypass.Config or {
        FOLLOW_SPEED = BYPASS_AIMBOT_SPEED,
        ACTIVATE_DISTANCE = 13,
        MIN_FOLLOW_DISTANCE = 1,
        PREDICTION_TIME = 0.22,
        PREDICT_AHEAD = 3,
        MAX_VELOCITY_CHANGE = 150,
        VELOCITY_SMOOTHING = 0.2,
        MAX_HORIZONTAL_VELOCITY = 80,
        SERVER_TICKRATE = 1 / 60,
        MIN_PING_COMPENSATION = 0.03,
        MAX_PING_COMPENSATION = 0.25,
        ACCELERATION_PREDICTION_WEIGHT = 0.3,
        DIRECTION_CHANGE_DETECTION_TIME = 0.12,
        QUICK_DIRECTION_CHANGE_MULTIPLIER = 1.5,
        GRAVITY = 196.2,
        AIR_CONTROL_FACTOR = 0.8,
        MIN_AIRBORNE_TIME = 0.08,
    }
    bypass.Config.FOLLOW_SPEED = _clamp(tonumber(BYPASS_AIMBOT_SPEED) or 60, 1, 200)

    bypass.AverageVectors = function(vectors)
        if #vectors == 0 then return Vector3.zero end
        local sum = Vector3.zero
        for _, entry in ipairs(vectors) do sum += entry end
        return sum / #vectors
    end
    bypass.PushBounded = function(history, entry, maxEntries)
        table.insert(history, entry)
        if #history > maxEntries then table.remove(history, 1) end
    end
    bypass.ResetPredictionState = function()
        local z = bypass.Z
        z.targetPlayer = nil
        z.lastTargetPos = nil
        z.targetVelocity = Vector3.zero
        z.smoothedVelocity = Vector3.zero
        z.velocityHistory = {}
        z.accelerationHistory = {}
        z.aerialVelocityHistory = {}
        z.previousDirection = nil
        z.airborneTime = 0
    end
    bypass.ApplyAngularAim = function(rootPart, direction)
        if direction.Magnitude < 0.01 then return end
        local crossVector = rootPart.CFrame.LookVector:Cross(direction.Unit)
        local angle = math.asin(_clamp(crossVector.Magnitude, -1, 1))
        rootPart.AssemblyAngularVelocity = crossVector.Magnitude > 0.1
            and crossVector.Unit * angle * 80 or Vector3.zero
    end
    bypass.UpdatePing = function()
        local ok, result = pcall(function()
            return game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue()
        end)
        local z = bypass.Z
        if ok and type(result) == "number" then z.realPingMs = math.floor(result) end
        z.currentPing = _clamp(
            z.realPingMs / 1000,
            bypass.Config.MIN_PING_COMPENSATION,
            bypass.Config.MAX_PING_COMPENSATION
        )
    end
    bypass.FindBat = function()
        return findBat()
    end

    if bypass.Connection then
        local connectionActive = false
        pcall(function() connectionActive = bypass.Connection.Connected == true end)
        if not connectionActive then
            pcall(function() bypass.Connection:Disconnect() end)
            bypass.Connection = nil
            bypass.Enabled = false
        end
    end

    bypass.Stop = function()
        local z = bypass.Z
        bypass.Enabled = false
        if bypass.Connection then
            pcall(function() bypass.Connection:Disconnect() end)
            bypass.Connection = nil
        end
        local character = LP.Character
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        local rootPart = character and character:FindFirstChild("HumanoidRootPart")
        if humanoid then
            humanoid.AutoRotate = bypass.PreviousAutoRotate == nil and true or bypass.PreviousAutoRotate
        end
        if rootPart then rootPart.AssemblyAngularVelocity = Vector3.zero end
        bypass.PreviousAutoRotate = nil
        bypass.ResetPredictionState()
        z.lastActivationTime = 0
        if type(_unsuppressBodyLock) == "function" then pcall(_unsuppressBodyLock, true) end
        if autoBatSetVisual then autoBatSetVisual(false) end
    end

    bypass.Start = function()
        if bypass.Connection then
            local connectionActive = false
            pcall(function() connectionActive = bypass.Connection.Connected == true end)
            if connectionActive and bypass.Enabled then return true end
            pcall(function() bypass.Connection:Disconnect() end)
            bypass.Connection = nil
            bypass.Enabled = false
        end
        local character = LP.Character
        local waitUntil = _tick() + 8
        while not character and _tick() < waitUntil do
            task.wait(0.05)
            character = LP.Character
        end
        if not waitForCharReady(character, 5) then
            warn("[TJ NXT] Bat Bypass: espera a que cargue tu personaje y vuelve a pulsar el botón.")
            return false
        end
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        local rootPart = character:FindFirstChild("HumanoidRootPart")
        if not humanoid or not rootPart then return false end
        bypass.PreviousAutoRotate = humanoid.AutoRotate
        humanoid.AutoRotate = false
        bypass.Enabled = true
        if type(_suppressBodyLock) == "function" then pcall(_suppressBodyLock) end
        local tool = bypass.FindBat()
        if tool and tool.Parent ~= character then pcall(function() humanoid:EquipTool(tool) end) end

        local connectOk, connection = pcall(function()
            return RunService.RenderStepped:Connect(function(deltaTime)
                if not bypass.Enabled then bypass.Stop(); return end
                local z = bypass.Z
                local cfg = bypass.Config
                cfg.FOLLOW_SPEED = _clamp(tonumber(BYPASS_AIMBOT_SPEED) or 60, 1, 200)
                local currentCharacter = LP.Character
                local currentRoot = currentCharacter and currentCharacter:FindFirstChild("HumanoidRootPart")
                local currentHumanoid = currentCharacter and currentCharacter:FindFirstChildOfClass("Humanoid")
                if not currentRoot or not currentHumanoid or currentHumanoid.Health <= 0 then return end
                currentHumanoid.AutoRotate = false
                rootPart = currentRoot
                humanoid = currentHumanoid
                tool = currentCharacter:FindFirstChildOfClass("Tool") or bypass.FindBat()
                if tool and tool.Parent ~= currentCharacter then
                    pcall(currentHumanoid.EquipTool, currentHumanoid, tool)
                end
                local targetRoot = getClosestTarget()
                local targetCharacter = targetRoot and targetRoot.Parent
                local targetHumanoid = targetCharacter and targetCharacter:FindFirstChildOfClass("Humanoid")
                if not targetRoot or not targetHumanoid or targetHumanoid.Health <= 0 then
                    bypass.ResetPredictionState()
                    return
                end
                if z.targetPlayer ~= targetCharacter then
                    bypass.ResetPredictionState()
                    z.targetPlayer = targetCharacter
                end
                local position = targetRoot.Position
                local sampleDeltaTime = math.max(deltaTime, 1 / 240)
                if z.lastTargetPos then
                    local targetVelocity = (position - z.lastTargetPos) / sampleDeltaTime
                    local change = targetVelocity - z.targetVelocity
                    if change.Magnitude > cfg.MAX_VELOCITY_CHANGE then
                        targetVelocity = z.targetVelocity + change.Unit * cfg.MAX_VELOCITY_CHANGE
                    end
                    local horizontal = Vector3.new(targetVelocity.X, 0, targetVelocity.Z)
                    if horizontal.Magnitude > cfg.MAX_HORIZONTAL_VELOCITY then
                        horizontal = horizontal.Unit * cfg.MAX_HORIZONTAL_VELOCITY
                        targetVelocity = Vector3.new(horizontal.X, targetVelocity.Y, horizontal.Z)
                    end
                    bypass.PushBounded(z.accelerationHistory, (targetVelocity - z.targetVelocity) / sampleDeltaTime, 4)
                    bypass.PushBounded(z.velocityHistory, targetVelocity, 8)
                    z.targetVelocity = targetVelocity
                    z.smoothedVelocity = z.smoothedVelocity:Lerp(targetVelocity, cfg.VELOCITY_SMOOTHING)
                end
                z.lastTargetPos = position
                local airborne = targetHumanoid.FloorMaterial == Enum.Material.Air
                z.airborneTime = airborne and z.airborneTime + sampleDeltaTime or 0
                if airborne and z.airborneTime >= cfg.MIN_AIRBORNE_TIME then
                    bypass.PushBounded(z.aerialVelocityHistory, z.targetVelocity, 6)
                elseif not airborne then
                    z.aerialVelocityHistory = {}
                end
                local smoothedVelocity = z.smoothedVelocity
                if airborne and #z.aerialVelocityHistory > 0 then
                    local aerial = bypass.AverageVectors(z.aerialVelocityHistory)
                    smoothedVelocity = Vector3.new(aerial.X, z.targetVelocity.Y, aerial.Z) * cfg.AIR_CONTROL_FACTOR
                end
                local quickTurn = false
                local horizontalVelocity = Vector3.new(z.targetVelocity.X, 0, z.targetVelocity.Z)
                if horizontalVelocity.Magnitude > 5 then
                    local direction = horizontalVelocity.Unit
                    if z.previousDirection and z.previousDirection:Dot(direction) < 0.5 then
                        quickTurn = _tick() - z.lastDirectionChangeTime < cfg.DIRECTION_CHANGE_DETECTION_TIME
                        z.lastDirectionChangeTime = _tick()
                    end
                    z.previousDirection = direction
                end
                local predictionTime = z.currentPing + cfg.SERVER_TICKRATE
                if quickTurn then predictionTime *= cfg.QUICK_DIRECTION_CHANGE_MULTIPLIER end
                local predictedPosition = position
                    + smoothedVelocity * predictionTime
                    + bypass.AverageVectors(z.accelerationHistory)
                        * cfg.ACCELERATION_PREDICTION_WEIGHT * predictionTime * predictionTime * 0.5
                local leadTime = cfg.PREDICTION_TIME * 1.1
                local leadPosition
                if airborne then
                    leadPosition = predictedPosition + smoothedVelocity * leadTime
                        + Vector3.new(0, -0.5 * cfg.GRAVITY * leadTime * leadTime, 0)
                else
                    leadPosition = predictedPosition + smoothedVelocity * leadTime
                end
                local flatVelocity = Vector3.new(smoothedVelocity.X, 0, smoothedVelocity.Z)
                if flatVelocity.Magnitude > 1 then leadPosition += flatVelocity.Unit * cfg.PREDICT_AHEAD end
                local targetDirection = leadPosition - rootPart.Position
                bypass.ApplyAngularAim(rootPart, targetDirection)
                local withinRange = (position - rootPart.Position).Magnitude <= cfg.ACTIVATE_DISTANCE
                if withinRange then withinRange = _tick() - z.lastActivationTime >= 0.3 end
                if withinRange then
                    if tool then pcall(tool.Activate, tool) end
                    z.lastActivationTime = _tick()
                end
                if targetDirection.Magnitude > cfg.MIN_FOLLOW_DISTANCE then
                    rootPart.AssemblyLinearVelocity = targetDirection.Unit * cfg.FOLLOW_SPEED
                else
                    rootPart.AssemblyLinearVelocity = Vector3.new(0, rootPart.AssemblyLinearVelocity.Y * 0.5, 0)
                end
            end)
        end)
        if not connectOk or not connection then
            bypass.Enabled = false
            humanoid.AutoRotate = bypass.PreviousAutoRotate == nil and true or bypass.PreviousAutoRotate
            bypass.PreviousAutoRotate = nil
            if type(_unsuppressBodyLock) == "function" then pcall(_unsuppressBodyLock, true) end
            if not connectOk then warn("[TJ NXT] Bat Bypass: " .. tostring(connection)) end
            return false
        end
        bypass.Connection = connection
        if autoBatSetVisual then autoBatSetVisual(true) end
        if not bypass.PingLoopStarted then
            bypass.PingLoopStarted = true
            task.spawn(function()
                while true do
                    pcall(bypass.UpdatePing)
                    task.wait(0.5)
                end
            end)
        end
        return true
    end

    bypass.Toggle = function()
        if bypass.Enabled then
            bypass.Stop()
        elseif bypass.Start() ~= true then
            if autoBatSetVisual then autoBatSetVisual(false) end
            return false
        end
        if autoBatSetVisual then autoBatSetVisual(bypass.Enabled) end
        if type(saveAllSettings) == "function" then pcall(saveAllSettings) end
        return bypass.Enabled
    end
end


    local BAV2_ANG = "_GB_AngV"
    local BAV2_ATT = "_GB_Att"
    local BAV2_CLEAN = {
        "LockBAV","LockAngVel","LockBodyAtt","BatLock","LockBAVAtt",
        "AutoBatAtt","AutoBatAV","AntiBatDet","AntiAim","VelocityLock"
    }

    local V2 = {
        enabled = false,
        conn = nil,
        safetyConn = nil,
        target = nil,
        equipped = false,
        intendedVelocity = Vector3.zero,
        attachment = nil,
        angularVelocity = nil,
        speed = 58,
        swingRange = 12,
    }
    _G.__RivalHubBatV2 = V2

    local function cleanMovers(root)
        if not root then return end
        pcall(function()
            for _, n in ipairs(BAV2_CLEAN) do
                local c = root:FindFirstChild(n)
                if c then c:Destroy() end
            end
            for _, child in ipairs(root:GetChildren()) do
                if child.Name ~= BAV2_ANG and child.Name ~= BAV2_ATT then
                    local ln = child.Name:lower()
                    if ln:find("lockb") or ln:find("lockangv")
                       or ln:find("batlock") or ln:find("antiaim")
                       or ln:find("velocitylock") then
                        child:Destroy()
                    end
                end
            end
        end)
    end

    local function ensureAngular(root)
        if not root then return end
        pcall(function()
            local a = root:FindFirstChild(BAV2_ANG); if a then a:Destroy() end
            local b = root:FindFirstChild(BAV2_ATT); if b then b:Destroy() end
        end)
        local att = Instance.new("Attachment")
        att.Name = BAV2_ATT
        att.Parent = root
        local angV = Instance.new("AngularVelocity")
        angV.Name = BAV2_ANG
        angV.Attachment0 = att
        angV.RelativeTo = Enum.ActuatorRelativeTo.World
        angV.MaxTorque = math.huge
        angV.AngularVelocity = Vector3.zero
        angV.Parent = root
        V2.attachment = att
        V2.angularVelocity = angV
    end

    local function removeAngular()
        pcall(function() if V2.angularVelocity and V2.angularVelocity.Parent then V2.angularVelocity:Destroy() end end)
        pcall(function() if V2.attachment and V2.attachment.Parent then V2.attachment:Destroy() end end)
        V2.angularVelocity = nil
        V2.attachment = nil
    end

    local function pickTarget(root)
        local best, bestD = nil, math.huge
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LP and p.Character then
                local hrp = p.Character:FindFirstChild("HumanoidRootPart")
                local hum = p.Character:FindFirstChildOfClass("Humanoid")
                if hrp and hum and hum.Health > 0 then
                    local d = (hrp.Position - root.Position).Magnitude
                    if d < bestD then bestD = d; best = hrp end
                end
            end
        end
        return best, bestD
    end

    local function getBat(char)
        local eq = char and char:FindFirstChildOfClass("Tool")
        if eq then
            local n = eq.Name:lower()
            if n:find("bat") or n:find("slap") then return eq end
        end
        local bp = LP:FindFirstChildOfClass("Backpack")
        if bp then
            for _, t in ipairs(bp:GetChildren()) do
                if t:IsA("Tool") then
                    local n = t.Name:lower()
                    if n:find("bat") or n:find("slap") then return t end
                end
            end
        end
        return nil
    end

    local function stopBatV2()
        V2.enabled = false
        V2.equipped = false
        V2.target = nil
        if V2.conn then V2.conn:Disconnect(); V2.conn = nil end
        if V2.safetyConn then V2.safetyConn:Disconnect(); V2.safetyConn = nil end
        local c = LP.Character
        local root = c and c:FindFirstChild("HumanoidRootPart")
        if root then pcall(function() root.Velocity = root.Velocity * 0.3 end) end
        local hum = c and c:FindFirstChildOfClass("Humanoid")
        if hum then hum.AutoRotate = true end
        if V2.angularVelocity then
            pcall(function() V2.angularVelocity.AngularVelocity = Vector3.zero end)
        end
        removeAngular()
        if _unsuppressBodyLock then pcall(_unsuppressBodyLock, true) end
    end

    local function startBatV2()
        stopBatV2()
        V2.enabled = true
        V2.equipped = false
        V2.target = nil
        V2.intendedVelocity = Vector3.zero
        V2.speed = tonumber(State and State.bypassBatSpeed) or 58
        if _suppressBodyLock then pcall(_suppressBodyLock) end

        local c = LP.Character
        local root = c and c:FindFirstChild("HumanoidRootPart")
        if root then
            cleanMovers(root)
            ensureAngular(root)
        end

        V2.conn = RunService.Heartbeat:Connect(function()
            if not V2.enabled then return end
            local char = LP.Character
            local hum  = char and char:FindFirstChildOfClass("Humanoid")
            local hrp  = char and char:FindFirstChild("HumanoidRootPart")
            if not hrp or not hum or hum.Health <= 0 then return end

            cleanMovers(hrp)
            if not V2.angularVelocity or not V2.angularVelocity.Parent then
                ensureAngular(hrp)
            end

            if not V2.equipped then
                V2.equipped = true
                if not char:FindFirstChildOfClass("Tool") then
                    local b = getBat(char)
                    if b then pcall(function() hum:EquipTool(b) end) end
                end
            end

            local target, dist = pickTarget(hrp)
            if not target then
                V2.target = nil
                hum.AutoRotate = true
                if V2.angularVelocity then
                    V2.angularVelocity.AngularVelocity = Vector3.zero
                end
                return
            end
            V2.target = target

            local aimPos = target.Position
                + target.CFrame.LookVector * (target.Velocity.Magnitude < 0.1 and 1.5 or 5)
            local delta = aimPos - hrp.Position
            local flat  = Vector3.new(delta.X, 0, delta.Z)
            hum.AutoRotate = false

            if delta.Magnitude > 0.01 and flat.Magnitude > 0.01 then
                local curY   = hrp.Orientation.Y
                local yawD   = (math.deg(math.atan2(-flat.X, -flat.Z)) - curY + 180) % 360 - 180
                local curX   = hrp.Orientation.X
                local pitchD = (math.deg(math.atan2(delta.Y, flat.Magnitude)) - curX + 180) % 360 - 180
                local rotY   = math.clamp(math.rad(yawD)   * 40, -28, 28)
                local rotX   = math.clamp(math.rad(pitchD) * 40, -28, 28)
                local yawR   = math.rad(hrp.Orientation.Y)
                local fwd    = Vector3.new(math.cos(yawR), 0, -math.sin(yawR))
                V2.angularVelocity.AngularVelocity = Vector3.new(0, rotY, 0) + fwd * rotX
            else
                V2.angularVelocity.AngularVelocity = Vector3.zero
            end

            local spd = tonumber(V2.speed) or 58
            V2.intendedVelocity =
                (flat.Magnitude > 0.1 and flat.Unit * spd or Vector3.zero)
                + (math.abs(delta.Y) > 0.8
                    and Vector3.new(0, math.sign(delta.Y) * spd, 0)
                    or  Vector3.new(0, -2, 0))
            hrp.AssemblyLinearVelocity = V2.intendedVelocity
            hrp.Velocity = V2.intendedVelocity

            if flat.Magnitude > 0.3 then
                pcall(function() hum:Move(flat.Unit, false) end)
            else
                pcall(function() hum:Move(Vector3.zero, false) end)
            end

            if dist <= V2.swingRange then
                local bat = char:FindFirstChildOfClass("Tool")
                if bat and (bat.Name:lower():find("bat") or bat.Name:lower():find("slap")) then
                    pcall(function()
                        bat:Activate()
                        local re = bat:FindFirstChildWhichIsA("RemoteEvent")
                        if re then re:FireServer() end
                    end)
                end
            end
        end)

        V2.safetyConn = RunService.RenderStepped:Connect(function()
            if not V2.enabled then return end
            local char = LP.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if not hrp or not hum then return end

            if V2.target and V2.target.Parent then
                local delta = V2.target.Position - hrp.Position
                local flat = Vector3.new(delta.X, 0, delta.Z)
                if flat.Magnitude > 0.3 then
                    pcall(function() hum:Move(flat.Unit, false) end)
                end
                if math.abs(hrp.AssemblyLinearVelocity.X - V2.intendedVelocity.X) > 30
                   or math.abs(hrp.AssemblyLinearVelocity.Z - V2.intendedVelocity.Z) > 30 then
                    hrp.AssemblyLinearVelocity = V2.intendedVelocity
                end
            end

            local v = hrp.Velocity
            if math.abs(v.X) > 350 or math.abs(v.Z) > 350 then
                hrp.Velocity = V2.intendedVelocity
            end
            cleanMovers(hrp)
        end)
    end

    -- ============================================================
    -- BAT V3: logica del bat aimbot de MVP
    -- ============================================================
    local V3 = {
        enabled = false, conn = nil,
        cfg = {
            FOLLOW_SPEED = 55, ACTIVATE_DISTANCE = 13, MIN_FOLLOW_DISTANCE = 1,
            PREDICTION_TIME = 0.22, PREDICT_AHEAD = 3, MAX_VELOCITY_CHANGE = 150,
            VELOCITY_SMOOTHING = 0.2, MAX_HORIZONTAL_VELOCITY = 80,
            SERVER_TICKRATE = 1/60, MIN_PING_COMPENSATION = 0.03, MAX_PING_COMPENSATION = 0.25,
            ACCELERATION_PREDICTION_WEIGHT = 0.3, DIRECTION_CHANGE_DETECTION_TIME = 0.12,
            QUICK_DIRECTION_CHANGE_MULTIPLIER = 1.5, GRAVITY = 196.2, AIR_CONTROL_FACTOR = 0.8,
            MIN_AIRBORNE_TIME = 0.08, SWING_COOLDOWN = 0.08,
        },
        st = {
            targetPlayer = nil, lastTargetPos = nil,
            targetVelocity = Vector3.zero, smoothedVelocity = Vector3.zero,
            velocityHistory = {}, accelerationHistory = {}, aerialVelocityHistory = {},
            verticalVelocityHistory = {}, previousDirection = nil,
            lastDirectionChangeTime = 0, airborneTime = 0, lastYVelocity = 0,
            lastActivationTime = 0, currentPing = 0.1, realPingMs = 0,
            previousAutoRotate = nil, previousHumanoid = nil,
            swingLocked = false, nextSwingAt = 0,
        },
    }

    function V3.avg(list)
        if #list == 0 then return Vector3.zero end
        local sum = Vector3.zero
        for _, v in ipairs(list) do sum = sum + v end
        return sum / #list
    end

    function V3.push(list, value, maxSize)
        table.insert(list, value)
        if #list > maxSize then table.remove(list, 1) end
    end

    function V3.reset()
        local s = V3.st
        s.targetPlayer = nil; s.lastTargetPos = nil
        s.targetVelocity = Vector3.zero; s.smoothedVelocity = Vector3.zero
        s.velocityHistory = {}; s.accelerationHistory = {}
        s.aerialVelocityHistory = {}; s.verticalVelocityHistory = {}
        s.previousDirection = nil; s.airborneTime = 0; s.lastYVelocity = 0
    end

    function V3.findBat()
        local char = LP.Character
        if not char then return nil end
        local equipped = char:FindFirstChildOfClass("Tool")
        if equipped then
            local n = equipped.Name:lower()
            if n:find("bat") or n:find("slap") then return equipped end
        end
        local bp = LP:FindFirstChildOfClass("Backpack")
        if bp then
            for _, tool in ipairs(bp:GetChildren()) do
                if tool:IsA("Tool") then
                    local n = tool.Name:lower()
                    if n:find("bat") or n:find("slap") then return tool end
                end
            end
        end
        return nil
    end

    function V3.nearest(myRoot)
        local nearest, nearestDist = nil, math.huge
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LP and player.Character then
                local tr = player.Character:FindFirstChild("HumanoidRootPart")
                local th = player.Character:FindFirstChildOfClass("Humanoid")
                if tr and th and th.Health > 0 then
                    local d = (tr.Position - myRoot.Position).Magnitude
                    if d < nearestDist then nearestDist = d; nearest = player end
                end
            end
        end
        return nearest, nearestDist
    end

    function V3.face(myRoot, direction)
        if direction.Magnitude < 0.01 then return end
        local cross = myRoot.CFrame.LookVector:Cross(direction.Unit)
        local angle = math.asin(math.clamp(cross.Magnitude, -1, 1))
        myRoot.AssemblyAngularVelocity = cross.Magnitude > 0.01
            and cross.Unit * angle * 80
            or Vector3.zero
    end

    function V3.updatePing()
        local ok, ping = pcall(function()
            return game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue()
        end)
        if ok and type(ping) == "number" then V3.st.realPingMs = math.floor(ping) end
        V3.st.currentPing = math.clamp(V3.st.realPingMs / 1000, V3.cfg.MIN_PING_COMPENSATION, V3.cfg.MAX_PING_COMPENSATION)
    end

    function V3.swing()
        local s, cfg = V3.st, V3.cfg
        local now = tick()
        if s.swingLocked or now < s.nextSwingAt then return end
        s.swingLocked = true
        s.nextSwingAt = now + cfg.SWING_COOLDOWN
        pcall(function()
            local char = LP.Character
            if not char then return end
            local bat = V3.findBat()
            if not bat then return end
            if bat.Parent ~= char then
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum then hum:EquipTool(bat) end
            end
            bat:Activate()
            local remote = bat:FindFirstChildWhichIsA("RemoteEvent")
            if remote then remote:FireServer() end
        end)
        task.delay(cfg.SWING_COOLDOWN, function() s.swingLocked = false end)
    end

    function V3.loop(dt)
        local s, cfg = V3.st, V3.cfg
        local spd = tonumber(State and State.bypassBatSpeed) or tonumber(BYPASS_AIMBOT_SPEED) or 55
        if spd ~= spd or spd <= 0 or spd == math.huge then spd = 55 end
        cfg.FOLLOW_SPEED = spd
        if not V3.enabled then return end

        local char = LP.Character
        if not char then return end
        local myRoot = char:FindFirstChild("HumanoidRootPart")
        local myHum = char:FindFirstChildOfClass("Humanoid")
        if not myRoot or not myHum or myHum.Health <= 0 then return end

        myHum.AutoRotate = false

        if not char:FindFirstChildOfClass("Tool") then
            local bat = V3.findBat()
            if bat and bat.Parent ~= char then
                pcall(function() myHum:EquipTool(bat) end)
            end
        end

        local target = V3.nearest(myRoot)
        if not target or not target.Character then V3.reset(); return end
        local targetRoot = target.Character:FindFirstChild("HumanoidRootPart")
        local targetHum = target.Character:FindFirstChildOfClass("Humanoid")
        if not targetRoot or not targetHum or targetHum.Health <= 0 then V3.reset(); return end

        if s.targetPlayer ~= target then V3.reset() end
        s.targetPlayer = target

        V3.updatePing()

        local targetPos = targetRoot.Position
        local dtc = math.max(dt, 1/240)

        if s.lastTargetPos then
            local instantVel = (targetPos - s.lastTargetPos) / dtc
            local accel = instantVel - s.targetVelocity
            if accel.Magnitude > cfg.MAX_VELOCITY_CHANGE then
                instantVel = s.targetVelocity + accel.Unit * cfg.MAX_VELOCITY_CHANGE
            end
            local hv = Vector3.new(instantVel.X, 0, instantVel.Z)
            if hv.Magnitude > cfg.MAX_HORIZONTAL_VELOCITY then
                hv = hv.Unit * cfg.MAX_HORIZONTAL_VELOCITY
                instantVel = Vector3.new(hv.X, instantVel.Y, hv.Z)
            end
            V3.push(s.accelerationHistory, (instantVel - s.targetVelocity) / dtc, 4)
            V3.push(s.velocityHistory, instantVel, 8)
            V3.push(s.verticalVelocityHistory, instantVel.Y, 5)
            s.targetVelocity = instantVel
            s.smoothedVelocity = s.smoothedVelocity:Lerp(instantVel, cfg.VELOCITY_SMOOTHING)
        end
        s.lastTargetPos = targetPos

        local isAirborne = targetHum.FloorMaterial == Enum.Material.Air
        s.airborneTime = isAirborne and (s.airborneTime + dtc) or 0
        if isAirborne and s.airborneTime >= cfg.MIN_AIRBORNE_TIME then
            V3.push(s.aerialVelocityHistory, s.targetVelocity, 6)
        elseif not isAirborne then
            s.aerialVelocityHistory = {}
        end

        local smoothedVel = s.smoothedVelocity
        if isAirborne and #s.aerialVelocityHistory > 0 then
            local avgAerial = V3.avg(s.aerialVelocityHistory)
            smoothedVel = Vector3.new(avgAerial.X, s.targetVelocity.Y, avgAerial.Z) * cfg.AIR_CONTROL_FACTOR
        end

        local isQuickTurn = false
        local htv = Vector3.new(s.targetVelocity.X, 0, s.targetVelocity.Z)
        if htv.Magnitude > 5 then
            local newDir = htv.Unit
            if s.previousDirection and s.previousDirection:Dot(newDir) < 0.5 then
                isQuickTurn = (tick() - s.lastDirectionChangeTime) < cfg.DIRECTION_CHANGE_DETECTION_TIME
                s.lastDirectionChangeTime = tick()
            end
            s.previousDirection = newDir
        end

        local serverDelay = s.currentPing + cfg.SERVER_TICKRATE
        local adjustedDelay = isQuickTurn and (serverDelay * cfg.QUICK_DIRECTION_CHANGE_MULTIPLIER) or serverDelay

        local avgAccel = V3.avg(s.accelerationHistory)
        local accelContribution = avgAccel * cfg.ACCELERATION_PREDICTION_WEIGHT * (adjustedDelay * adjustedDelay * 0.5)
        local predictedPos = targetPos + smoothedVel * adjustedDelay + accelContribution

        local predictionTime = cfg.PREDICTION_TIME * 1.1
        if isAirborne then
            predictedPos = predictedPos + smoothedVel * predictionTime
                + Vector3.new(0, -0.5 * cfg.GRAVITY * predictionTime * predictionTime, 0)
        else
            predictedPos = predictedPos + smoothedVel * predictionTime
        end

        local hs = Vector3.new(smoothedVel.X, 0, smoothedVel.Z)
        if hs.Magnitude > 1 then
            predictedPos = predictedPos + hs.Unit * cfg.PREDICT_AHEAD
        end

        local direction = predictedPos - myRoot.Position
        V3.face(myRoot, direction)

        if (targetPos - myRoot.Position).Magnitude <= cfg.ACTIVATE_DISTANCE then
            if tick() - s.lastActivationTime >= 0.3 then
                V3.swing()
                s.lastActivationTime = tick()
            end
        end

        if direction.Magnitude > cfg.MIN_FOLLOW_DISTANCE then
            myRoot.AssemblyLinearVelocity = direction.Unit * cfg.FOLLOW_SPEED
        else
            local cv = myRoot.AssemblyLinearVelocity
            myRoot.AssemblyLinearVelocity = Vector3.new(0, cv.Y * 0.5, 0)
        end
    end

    function V3.start()
        if V3.enabled then return end
        V3.enabled = true
        if _suppressBodyLock then pcall(_suppressBodyLock) end
        local char = LP.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum then
            V3.st.previousHumanoid = hum
            V3.st.previousAutoRotate = hum.AutoRotate
            hum.AutoRotate = false
        end
        V3.reset()
        V3.st.lastActivationTime = 0
        V3.conn = RunService.RenderStepped:Connect(function(dt)
            pcall(V3.loop, dt)
        end)
    end

    function V3.stop()
        if not V3.enabled then return end
        V3.enabled = false
        if V3.conn then V3.conn:Disconnect(); V3.conn = nil end
        local char = LP.Character
        if char then
            local myRoot = char:FindFirstChild("HumanoidRootPart")
            local hum = char:FindFirstChildOfClass("Humanoid")
            if myRoot then
                myRoot.AssemblyLinearVelocity = Vector3.zero
                myRoot.AssemblyAngularVelocity = Vector3.zero
            end
            local prev = V3.st.previousHumanoid
            if prev and prev.Parent then
                prev.AutoRotate = V3.st.previousAutoRotate == nil and true or V3.st.previousAutoRotate
            elseif hum then
                hum.AutoRotate = true
            end
        end
        V3.st.previousHumanoid = nil
        V3.st.previousAutoRotate = nil
        V3.reset()
        if _unsuppressBodyLock then pcall(_unsuppressBodyLock, true) end
    end

    -- ============================================================
    -- SELECTOR V1 / V2 (V1 = motor simple de K7; V2 = motor predictivo de TJ NXT)
    -- ============================================================
    _G.__RivalHubBatVersion = (_G.__RivalHubBatVersion == "v2" or BAT_BYPASS_VERSION == "v2") and "v2" or "v1"
    BAT_BYPASS_VERSION = _G.__RivalHubBatVersion
    local BatCtl = {}

    function BatCtl.isOn()
        return V2.enabled == true or V3.enabled == true
            or (_G.PhantomBatBypass and _G.PhantomBatBypass.Enabled == true)
    end
    function BatCtl.stop()
        if V3.enabled then V3.stop() end
        stopBatV2()
        if _G.PhantomBatBypass and _G.PhantomBatBypass.Enabled then
            pcall(_G.PhantomBatBypass.Stop)
        end
    end
    function BatCtl.start()
        BatCtl.stop()
        if _G.__RivalHubBatVersion == "v2" then
            if _G.PhantomBatBypass then pcall(_G.PhantomBatBypass.Start) end
        else
            startBatV2()
        end
        if BatCtl.isOn() and autoBatSetVisual then autoBatSetVisual(true) end
    end
    function BatCtl.setVersion(ver)
        ver = (ver == "v2") and "v2" or "v1"
        BAT_BYPASS_VERSION = ver
        local wasOn = BatCtl.isOn()
        if wasOn then BatCtl.stop() end
        _G.__RivalHubBatVersion = ver
        if _G.updateBatVersionUI then pcall(_G.updateBatVersionUI, ver) end
        if batBypassVersionBtn then pcall(function() batBypassVersionBtn.Text = (ver == "v2") and "V2" or "V1" end) end
        if _G.__RivalHubRefreshBatLabel then pcall(_G.__RivalHubRefreshBatLabel) end
        if wasOn then BatCtl.start() end
        if saveAllSettings then pcall(saveAllSettings) end
    end

    _G.__RivalHubStartBatV2 = BatCtl.start
    _G.__RivalHubStopBatV2  = BatCtl.stop
    _G.__RivalHubIsBatV2    = BatCtl.isOn
    _G.__RivalHubSetBatVersion = BatCtl.setVersion

    LP.CharacterAdded:Connect(function()
        task.wait(0.5)
        if V2.enabled then
            V2.equipped = false
            V2.target = nil
            local hrp = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                cleanMovers(hrp)
                ensureAngular(hrp)
            end
        end
    end)
end


-- NIGHT compatibility layer for Rival's V2/V3 engine.
_G.__K7DuelsStartBatV2 = _G.__RivalHubStartBatV2
_G.__K7DuelsStopBatV2 = _G.__RivalHubStopBatV2
_G.__K7DuelsIsBatV2 = _G.__RivalHubIsBatV2
_G.__K7DuelsBatV2 = _G.__RivalHubBatV2
_G.__K7DuelsSetBatVersion = _G.__RivalHubSetBatVersion
startAimbotAdapt = function()
    if _G.__RivalHubStartBatV2 then pcall(_G.__RivalHubStartBatV2) end
end
stopAimbotAdapt = function()
    if _G.__RivalHubStopBatV2 then pcall(_G.__RivalHubStopBatV2) end
end
disableAutoBat = function()
    autoBatEnabled = false
    stopAimbotAdapt()
    if autoBatSetVisual then autoBatSetVisual(false) end
    if mobSetAutoBat then mobSetAutoBat(false) end
    if saveAllSettings then pcall(saveAllSettings) end
end
enableAutoBat = function()
    if _G.__RivalHubIsBatV2 and _G.__RivalHubIsBatV2() then
        pcall(_G.__RivalHubStopBatV2)
    end
    if autoLeftEnabled then autoLeftEnabled = false; if stopAutoLeft then stopAutoLeft() end end
    if autoRightEnabled then autoRightEnabled = false; if stopAutoRight then stopAutoRight() end end
    autoBatEnabled = true
    startAimbotAdapt()
    if autoBatSetVisual then autoBatSetVisual(true) end
    if mobSetAutoBat then mobSetAutoBat(true) end
    if saveAllSettings then pcall(saveAllSettings) end
end
_G.__K7DuelsZ3kBypass = _G.__RivalHubBatV2
_G.__K7DuelsStartZ3k = startAimbotAdapt
_G.__K7DuelsStopZ3k = stopAimbotAdapt

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

-- ===== MEDUSA SKINS (portado de Rival Hub) =====
do
    _G.RivalMedusaSkinAssets = {
        Skull = {
            mesh = "rbxassetid://2050312704", tex = "rbxassetid://2050313393",
            scale = Vector3.new(1, 1, 1),
            c0 = CFrame.new(0, 0.65, -0.4) * CFrame.Angles(math.rad(330), 0, 0),
        },
        GoldenDesertEagle = {
            mesh = "rbxassetid://430251413", tex = "rbxassetid://435840335",
            scale = Vector3.new(0.01, 0.01, 0.01),
            c0 = CFrame.new(0, 0, -0.8) * CFrame.Angles(math.rad(330), math.rad(180), 0),
        },
    }
    _G.RivalMedusaSkin = _G.RivalMedusaSkin or "Default"

    local function isMedusaTool(tool)
        if not tool or not tool:IsA("Tool") then return false end
        local n = tool.Name:lower()
        return (n:find("medusa") or n:find("stone") or n:find("head")) and true or false
    end

    local function clearReplica(tool)
        local handle = tool and tool:FindFirstChild("Handle")
        if not handle then return end
        local rep = handle:FindFirstChild("RivalMedusaReplica")
        if rep then pcall(function() rep:Destroy() end) end
        for _, d in ipairs(tool:GetDescendants()) do
            if d:GetAttribute("RivalMedusaHidden") ~= nil then
                local orig = d:GetAttribute("RivalMedusaHidden")
                pcall(function() d.Transparency = orig end)
                pcall(function() d:SetAttribute("RivalMedusaHidden", nil) end)
            end
        end
    end

    local function hideOriginal(tool)
        for _, d in ipairs(tool:GetDescendants()) do
            if (d:IsA("BasePart") or d:IsA("Decal") or d:IsA("Texture"))
                and not d:FindFirstAncestor("RivalMedusaReplica")
                and not d:FindFirstAncestor("ShelMedusaBombSkin") then
                pcall(function()
                    if d:GetAttribute("RivalMedusaHidden") == nil then
                        d:SetAttribute("RivalMedusaHidden", d.Transparency)
                    end
                    d.Transparency = 1
                end)
            end
        end
    end

    local function buildReplica(tool, key)
        local data = _G.RivalMedusaSkinAssets[key]
        local handle = tool:FindFirstChild("Handle")
        if not data or not handle then return end
        local cur = handle:FindFirstChild("RivalMedusaReplica")
        if cur and cur:GetAttribute("SkinKey") == key then
            hideOriginal(tool)
            for _, d in ipairs(cur:GetDescendants()) do
                if d:IsA("BasePart") then
                    if d.Transparency ~= 0 then d.Transparency = 0 end
                    if d.LocalTransparencyModifier ~= 0 then d.LocalTransparencyModifier = 0 end
                end
            end
            return
        end
        clearReplica(tool)
        hideOriginal(tool)
        local m = Instance.new("Model")
        m.Name = "RivalMedusaReplica"
        m:SetAttribute("SkinKey", key)
        local p = Instance.new("Part")
        p.Name = "MainPart"
        p.CanCollide = false; p.CanQuery = false; p.CanTouch = false
        p.Massless = true; p.Anchored = false
        p.Size = Vector3.new(1, 1, 1)
        p.Transparency = 0
        p.Parent = m
        local mesh = Instance.new("SpecialMesh")
        mesh.MeshType = Enum.MeshType.FileMesh
        mesh.MeshId = data.mesh
        mesh.TextureId = data.tex
        mesh.Scale = data.scale
        mesh.Parent = p
        local w = Instance.new("Motor6D")
        w.Part0 = handle
        w.Part1 = p
        w.C0 = data.c0
        w.Parent = p
        m.Parent = handle
    end

    function _G.RivalApplyMedusaSkin()
        local sk = _G.RivalMedusaSkin or "Default"
        local containers = {}
        if LP.Character then table.insert(containers, LP.Character) end
        local bp = LP:FindFirstChildOfClass("Backpack")
        if bp then table.insert(containers, bp) end
        for _, container in ipairs(containers) do
            for _, tool in ipairs(container:GetChildren()) do
                if isMedusaTool(tool) then
                    if sk == "Default" then
                        clearReplica(tool)
                    else
                        buildReplica(tool, sk)
                    end
                end
            end
        end
    end

    function _G.RivalSetMedusaSkin(choice)
        if choice ~= "Default" and not _G.RivalMedusaSkinAssets[choice] then choice = "Default" end
        _G.RivalMedusaSkin = choice
        pcall(_G.RivalApplyMedusaSkin)
        if _G.ShelMedusaSkin and _G.ShelMedusaSkin.apply then
            pcall(_G.ShelMedusaSkin.apply)
        end
        if choice ~= "Default" then pcall(_G.RivalApplyMedusaSkin) end
        if _G.ShelBombSound and _G.ShelBombSound.refresh then
            pcall(_G.ShelBombSound.refresh)
        end
    end

    task.spawn(function()
        while true do
            if (_G.RivalMedusaSkin or "Default") ~= "Default" then
                pcall(_G.RivalApplyMedusaSkin)
            end
            task.wait(0.6)
        end
    end)
    LP.CharacterAdded:Connect(function()
        task.wait(0.8)
        pcall(_G.RivalApplyMedusaSkin)
    end)
end
-- ===== FIN MEDUSA SKINS =====

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
        local finished = false
        local function finishDrop(threadRef)
            if finished then return end
            finished = true
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
                local flat = _V3new(vel.X, 0, vel.Z)
                if flat.Magnitude > 120 then flat = flat.Unit * 120 end
                pcall(function() r:SetNetworkOwner(LP) end)
                r.AssemblyLinearVelocity = flat + _V3new(0, DROP_ASCEND_SPEED, 0)
                RunService.RenderStepped:Wait()
                if r and r.Parent then
                    local nowVel = r.AssemblyLinearVelocity
                    r.AssemblyLinearVelocity = _V3new(nowVel.X, DROP_ASCEND_SPEED, nowVel.Z)
                end
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
        r.AssemblyLinearVelocity = _V3new(r.AssemblyLinearVelocity.X, DROP_ASCEND_SPEED, r.AssemblyLinearVelocity.Z)
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
            or name:match("^BloodHounds") or name:match("^K7Duels") then
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
    hideButtonsEnabled = state == true
    if not MobilePanel then return end
    for _, child in ipairs(MobilePanel:GetChildren()) do
        if child:IsA("TextButton") then
            local force = hiddenButtons and hiddenButtons[child.Name] == true
            child.Visible = not (hideButtonsEnabled or force)
        end
    end
end

function setButtonHidden(name, hidden)
    hiddenButtons = hiddenButtons or {}
    hiddenButtons[tostring(name)] = hidden == true
    if MobilePanel then
        local btn = MobilePanel:FindFirstChild(name)
        if btn and btn:IsA("TextButton") then
            btn.Visible = not (hideButtonsEnabled or hiddenButtons[name] == true)
        end
    end
    if saveAllSettings then pcall(saveAllSettings) end
end

function applyPerButtonVisibility()
    if not MobilePanel then return end
    for _, child in ipairs(MobilePanel:GetChildren()) do
        if child:IsA("TextButton") then
            local force = hiddenButtons and hiddenButtons[child.Name] == true
            child.Visible = not (hideButtonsEnabled or force)
        end
    end
end

function toggleHideButtons(on)
    applyHideButtons(on)
    if setHideButtonsVisual then setHideButtonsVisual(on) end
    if saveAllSettings then pcall(saveAllSettings, true) end
end

function K7DuelsUI.new(class, parent, props)
    local object = Instance.new(class)
    for key, value in pairs(props or {}) do object[key] = value end
    object.Parent = parent
    return object
end
function K7DuelsUI.round(object, radius)
    local corner = object:FindFirstChildOfClass("UICorner") or Instance.new("UICorner", object)
    corner.CornerRadius = UDim.new(0, radius or 12)
    return corner
end
function K7DuelsUI.stroke(object, color, transparency, thickness)
    return K7DuelsUI.new("UIStroke", object, {Color = color, Transparency = transparency or 0,
        Thickness = thickness or 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border})
end
function K7DuelsUI.text(parent, text, position, size, fontSize, color, z)
    return K7DuelsUI.new("TextLabel", parent, {Text = text, Position = position, Size = size,
        BackgroundTransparency = 1, TextColor3 = color or Color3.fromRGB(245, 241, 235),
        Font = Enum.Font.GothamMedium, TextSize = fontSize or 12, ZIndex = z or 8,
        TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd})
end
function K7DuelsUI.pumpkin(parent, position, size, z)
    -- Murciélago Halloween (reemplaza calabaza)
    local root = K7DuelsUI.new("Frame", parent, {Name = "Bat", Size = UDim2.fromOffset(size, size),
        Position = position, BackgroundTransparency = 1, ZIndex = z, Active = false})
    local function part(x, y, w, h, color, radius, rotation)
        local object = K7DuelsUI.new("Frame", root, {Size = UDim2.fromScale(w, h), Position = UDim2.fromScale(x, y),
            BackgroundColor3 = color, BorderSizePixel = 0, Rotation = rotation or 0, ZIndex = z + 1})
        K7DuelsUI.round(object, radius)
        return object
    end
    local body = Color3.fromRGB(28, 22, 38)
    local wing = Color3.fromRGB(45, 30, 60)
    local accent = Color3.fromRGB(120, 50, 160)
    local eye = Color3.fromRGB(255, 255, 255)

    -- Cuerpo central
    part(0.32, 0.28, 0.36, 0.42, body, size)
    -- Cabeza
    part(0.36, 0.14, 0.28, 0.28, body, size)
    -- Orejas puntiagudas
    part(0.34, 0.04, 0.12, 0.18, body, 2, -18)
    part(0.54, 0.04, 0.12, 0.18, body, 2, 18)
    -- Ala izquierda (abierta)
    part(0.00, 0.30, 0.34, 0.18, wing, 4, -12)
    part(0.02, 0.40, 0.28, 0.14, wing, 3, -22)
    part(0.04, 0.48, 0.22, 0.12, wing, 3, -32)
    -- Ala derecha (abierta)
    part(0.66, 0.30, 0.34, 0.18, wing, 4, 12)
    part(0.70, 0.40, 0.28, 0.14, wing, 3, 22)
    part(0.74, 0.48, 0.22, 0.12, wing, 3, 32)
    -- Detalle de ala (accent)
    part(0.06, 0.34, 0.22, 0.06, accent, 2, -14)
    part(0.72, 0.34, 0.22, 0.06, accent, 2, 14)
    -- Ojos brillantes naranjas
    part(0.40, 0.22, 0.08, 0.08, eye, 4)
    part(0.52, 0.22, 0.08, 0.08, eye, 4)
    -- Colmillos
    part(0.44, 0.34, 0.05, 0.08, Color3.fromRGB(240, 230, 220), 1)
    part(0.51, 0.34, 0.05, 0.08, Color3.fromRGB(240, 230, 220), 1)
    -- Patitas
    part(0.38, 0.66, 0.08, 0.12, body, 2, -8)
    part(0.54, 0.66, 0.08, 0.12, body, 2, 8)
    return root
end
function K7DuelsUI.web(parent, position, size, z)
    local root = K7DuelsUI.new("Frame", parent, {Name = "Web", Position = position,
        Size = UDim2.fromOffset(size, size), BackgroundTransparency = 1, ZIndex = z})
    local function line(x1, y1, x2, y2)
        local dx, dy = x2 - x1, y2 - y1
        K7DuelsUI.new("Frame", root, {Size = UDim2.fromOffset(math.sqrt(dx * dx + dy * dy), 1),
            Position = UDim2.fromOffset((x1 + x2) / 2, (y1 + y2) / 2), AnchorPoint = Vector2.new(0.5, 0.5),
            Rotation = math.deg(math.atan2(dy, dx)), BackgroundColor3 = Color3.fromRGB(220, 174, 128),
            BackgroundTransparency = 0.84, BorderSizePixel = 0, ZIndex = z})
    end
    for i = 0, 4 do
        local a = math.pi * i / 8
        line(0, 0, math.cos(a) * size, math.sin(a) * size)
    end
    for ring = 1, 3 do
        local r = size * ring / 3
        for i = 0, 3 do
            local a, b = math.pi * i / 8, math.pi * (i + 1) / 8
            line(math.cos(a) * r, math.sin(a) * r, math.cos(b) * r, math.sin(b) * r)
        end
    end
    return root
end
function K7DuelsUI.sectionIcon(parent, name, position, size, color, z)
    local root = K7DuelsUI.new("Frame", parent, {Name = "SectionIcon", Position = position,
        Size = UDim2.fromOffset(size, size), BackgroundTransparency = 1, ZIndex = z})
    local function line(x1, y1, x2, y2, thickness)
        local dx, dy = x2 - x1, y2 - y1
        local ink = K7DuelsUI.new("Frame", root, {Name = "IconInk", AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale((x1 + x2) / 2, (y1 + y2) / 2),
            Size = UDim2.fromOffset(math.sqrt(dx * dx + dy * dy) * size, thickness or 1.6),
            BackgroundColor3 = color, BorderSizePixel = 0, Rotation = math.deg(math.atan2(dy, dx)), ZIndex = z})
        K7DuelsUI.round(ink, 2)
    end
    local function box(x, y, w, h, radius, solid)
        local object = K7DuelsUI.new("Frame", root, {Name = "IconInk", Position = UDim2.fromScale(x, y),
            Size = UDim2.fromScale(w, h), BackgroundColor3 = color, BackgroundTransparency = solid and 0 or 1,
            BorderSizePixel = 0, ZIndex = z})
        K7DuelsUI.round(object, radius)
        if not solid then K7DuelsUI.stroke(object, color, 0, 1.4) end
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
    elseif name == "Music" then
        box(0.19, 0.14, 0.16, 0.70, 2, true)
        box(0.65, 0.06, 0.16, 0.70, 2, true)
        line(0.32, 0.16, 0.78, 0.07, 2)
        line(0.27, 0.74, 0.18, 0.88, 2)
        line(0.73, 0.66, 0.64, 0.82, 2)
    elseif name == "AutoSteal" then
        line(0.59, 0.08, 0.27, 0.49, 2)
        line(0.27, 0.49, 0.51, 0.49, 2)
        line(0.51, 0.49, 0.34, 0.92, 2)
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
function K7DuelsUI.colorSectionIcon(root, color)
    if not root then return end
    for _, object in ipairs(root:GetDescendants()) do
        if object:IsA("Frame") and object.Name == "IconInk" then object.BackgroundColor3 = color end
        if object:IsA("UIStroke") then object.Color = color end
    end
end

function K7DuelsUI.fit()
    if not mainUIScale or not main or not main.Parent then return end
    local cam = Workspace.CurrentCamera
    if not cam then return end
    local viewport = cam.ViewportSize
    local width = 350
    local scale = math.max(0.25, math.min(uiScaleValue / 100, (viewport.X - 24) / width, (viewport.Y - 24) / 460))
    local height = math.min(570, math.floor((viewport.Y - 24) / scale))
    mainUIScale.Scale = scale
    K7DuelsUI.width, K7DuelsUI.height = width, height
    main.Size = UDim2.fromOffset(width, height)
    local size = Vector2.new(width * mainUIScale.Scale, height * mainUIScale.Scale)
    local point = main.AbsolutePosition
    main.Position = UDim2.fromOffset(_clamp(point.X, 8, math.max(8, viewport.X - size.X - 8)),
        _clamp(point.Y, 8, math.max(8, viewport.Y - size.Y - 8)))
    if pbFrame and pbFrame.Parent then
        -- Fija en el mismo sitio que 404 (centrada arriba), sin mover
        if K7DuelsUI.hudScale then K7DuelsUI.hudScale.Scale = 1 end
        pbFrame.Position = UDim2.new(0.5, -117.5, 0, 38)
        if K7DuelsUI.topBarHUD and K7DuelsUI.topBarHUD.Parent then
            K7DuelsUI.topBarHUD.Position = UDim2.new(0.5, -117.5, 0, 12)
        end
    end

end
function K7DuelsUI.effectsLoop(root)
    local state = K7DuelsUI
    if state.effectConn then state.effectConn:Disconnect() end
    local accumulator, elapsed = 0, 0
    local connection
    connection = RunService.Heartbeat:Connect(function(dt)
        if not root.Parent or _mySession ~= _G.K7DuelsSession then
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

function paintFloatingBtn(button, active)
    if not button or not button.Parent then return end
    local label = button:FindFirstChild("TextLabel")
    local stroke = button:FindFirstChild("BtnStroke") or button:FindFirstChildOfClass("UIStroke")
    local grad = button:FindFirstChild("BtnGrad")
    -- Estilo de la captura: botones negros, redondeados, texto blanco y solo el borde activo resaltado.
    local WHITE = Color3.fromRGB(255, 255, 255)
    local BTN_OFF = Color3.fromRGB(0, 0, 0)
    local BTN_ON = Color3.fromRGB(150, 150, 155)
    local STROKE_OFF = Color3.fromRGB(82, 82, 88)
    local STROKE_ON = Color3.fromRGB(180, 105, 220)
    local accent = (type(getThemeColor) == "function" and getThemeColor()) or selectedColor or BTN_ON

    -- Disable gradient (Clover uses solid colors)
    if grad and grad:IsA("UIGradient") then
        grad.Enabled = false
    end

    button.BackgroundColor3 = BTN_OFF
    button.BackgroundTransparency = 0.05

    if label then
        label.TextColor3 = WHITE
        label.Font = (K7DuelsUI.resolveFont and K7DuelsUI.resolveFont(K7DuelsUI.fontName)) or Enum.Font.GothamBlack
        label.TextStrokeTransparency = 1
        local ls = label:FindFirstChildOfClass("UIStroke")
        if ls then ls:Destroy() end
    end

    if stroke then
        if active then
            stroke.Color = accent or STROKE_ON
            stroke.Thickness = 1.3
            stroke.Transparency = 0
        else
            stroke.Color = STROKE_OFF
            stroke.Thickness = 1.2
            stroke.Transparency = 0
        end
    end

    -- Hide Bless-style active underline if present
    local line = button:FindFirstChild("ActiveLine")
    if line then
        line.Visible = false
    end
end
function applyFloatingButtonScale()
    for _, uiScale in ipairs(_floatingUIScales) do
        if uiScale and uiScale.Parent then
            uiScale.Scale = floatingButtonScale
            local button = uiScale.Parent
            if button:IsA("GuiObject") and Workspace.CurrentCamera then
                local viewport = Workspace.CurrentCamera.ViewportSize
                local size = 60 * floatingButtonScale
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

_G.__K7DuelsSpeedEngine = _G.__K7DuelsSpeedEngine or {}
do
    local function blocked(hum)
        return not hum or hum.Health <= 0 or _isRagdollState(hum) or autoBatEnabled
            or autoLeftEnabled or autoRightEnabled or dropActive or _G.IsDropping
            or TPBatState.enabled or (_G.__K7DuelsIsBatV2 and _G.__K7DuelsIsBatV2())
    end
    local function applyNow()
        local char = LP.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if not root or blocked(hum) then lastMoveDir = _V3zero; return end
        if useVenixCarryEngine then return end
        if _s2VelState.root ~= root then _hookVelHRP(_setupVelChecked(char)) end
        local direction = hum.MoveDirection
        if direction.Magnitude > 0 then lastMoveDir = direction
        else
            direction = nil
            if lastMoveDir.Magnitude > 0 then
                for key in pairs(MOVE_KEYS) do
                    if UIS:IsKeyDown(key) then direction = lastMoveDir; break end
                end
            end
        end
        _applyVelocitySpeed(direction, getActiveMoveSpeed(), root)
    end
    local function stop()
        if _G.__K7DuelsSpeedEngine.conn then _G.__K7DuelsSpeedEngine.conn:Disconnect(); _G.__K7DuelsSpeedEngine.conn = nil end
        K7DuelsVenixCarry:stop()
        lastMoveDir = _V3zero
    end
    local function start()
        stop()
        if useVenixCarryEngine then K7DuelsVenixCarry:start() end
        _G.__K7DuelsSpeedEngine.conn = RunService.RenderStepped:Connect(function()
            if _mySession ~= _G.K7DuelsSession then stop(); return end
            applyNow()
        end)
    end
    _G.__K7DuelsRefreshSpeedEngine = start
    _G.__K7DuelsStopSpeedEngine = stop
    _G.__K7DuelsApplySpeedNow = applyNow
    pcall(start)
    LP.CharacterRemoving:Connect(function() stop(); _s2VelState.root = nil end)
    LP.CharacterAdded:Connect(function(char)
        task.wait(0.5)
        if _mySession ~= _G.K7DuelsSession then return end
        _hookVelHRP(_setupVelChecked(char))
        start()
    end)
end


-- =====================================================================
-- CHARACTER SPIN — CFrame yaw suave + 1 solo loop (visible y sin fling)
-- =====================================================================
spinEnabled = spinEnabled == true
spinBrainrotEnabled = spinBrainrotEnabled == true
spinSpeed = tonumber(spinSpeed) or 18
spinBrainrotSpeed = tonumber(spinBrainrotSpeed) or 20
_spinConn = nil
_spinBrainrotConn = nil

function _fearSpinRoot()
    local c = LP and LP.Character
    if not c then return nil, nil end
    return c:FindFirstChild("HumanoidRootPart"), c:FindFirstChildOfClass("Humanoid")
end

function _fearSpinCarrying()
    local c = LP and LP.Character
    if not c then return false end
    if c:GetAttribute("Stealing") == true then return true end
    pcall(function()
        if LP:GetAttribute("Stealing") == true then return true end
    end)
    local h = c:FindFirstChildOfClass("Humanoid")
    if h then
        local ws = tonumber(h.WalkSpeed)
        if ws and ws > 0 and ws < 30 and math.abs(ws - 16) > 0.15 then return true end
    end
    for _, ch in ipairs(c:GetChildren()) do
        local n = string.lower(tostring(ch.Name or ""))
        if n:find("brain", 1, true) or n:find("animal", 1, true) or n:find("carry", 1, true)
            or n:find("steal", 1, true) or n:find("grab", 1, true) or n:find("hold", 1, true) then
            return true
        end
    end
    return false
end

local function _fearSpinYaw(root, hum, speed, dt)
    if not root or not root.Parent then return end
    if hum then pcall(function() hum.AutoRotate = false end) end
    local spd = tonumber(speed) or 18
    if not spd or spd ~= spd then spd = 18 end
    -- sin tope: el usuario elige el speed que quiera
    local add = math.rad(spd * 10) * math.max(dt or 0.016, 0.001)
    local pos = root.Position
    local look = root.CFrame.LookVector
    local yaw = math.atan2(-look.X, -look.Z) + add
    local vel = root.AssemblyLinearVelocity
    -- Solo cambia orientación Y; misma posición → menos chance de reset
    root.CFrame = CFrame.new(pos) * CFrame.Angles(0, yaw, 0)
    root.AssemblyLinearVelocity = Vector3.new(vel.X, vel.Y, vel.Z)
end

function stopSpin()
    spinEnabled = false
    if _spinConn then
        pcall(function() _spinConn:Disconnect() end)
        _spinConn = nil
    end
    if not spinBrainrotEnabled then
        local root, hum = _fearSpinRoot()
        if hum then pcall(function() hum.AutoRotate = true end) end
    end
    print("[K7 DUELS] Spin OFF")
end

function startSpin()
    if _spinConn then
        pcall(function() _spinConn:Disconnect() end)
        _spinConn = nil
    end
    spinEnabled = true
    local root, hum = _fearSpinRoot()
    if hum then pcall(function() hum.AutoRotate = false end) end
    _spinConn = RunService.RenderStepped:Connect(function(dt)
        if not spinEnabled then return end
        local r, h = _fearSpinRoot()
        if r then _fearSpinYaw(r, h, spinSpeed, dt) end
    end)
    print("[K7 DUELS] Spin ON speed=", spinSpeed)
end

function toggleSpin(on)
    if on == nil then on = not spinEnabled end
    if on then startSpin() else stopSpin() end
    if setSpinVisual then pcall(setSpinVisual, spinEnabled) end
    return spinEnabled
end

function stopSpinBrainrot()
    spinBrainrotEnabled = false
    if _spinBrainrotConn then
        pcall(function() _spinBrainrotConn:Disconnect() end)
        _spinBrainrotConn = nil
    end
    if not spinEnabled then
        local root, hum = _fearSpinRoot()
        if hum then pcall(function() hum.AutoRotate = true end) end
    end
    print("[K7 DUELS] Spin Brainrot OFF")
end

function startSpinBrainrot()
    if _spinBrainrotConn then
        pcall(function() _spinBrainrotConn:Disconnect() end)
        _spinBrainrotConn = nil
    end
    spinBrainrotEnabled = true
    _spinBrainrotConn = RunService.RenderStepped:Connect(function(dt)
        if not spinBrainrotEnabled then return end
        if not _fearSpinCarrying() then return end
        local r, h = _fearSpinRoot()
        if r then _fearSpinYaw(r, h, spinBrainrotSpeed, dt) end
    end)
    print("[K7 DUELS] Spin Brainrot ON speed=", spinBrainrotSpeed)
end

function toggleSpinBrainrot(on)
    if on == nil then on = not spinBrainrotEnabled end
    if on then startSpinBrainrot() else stopSpinBrainrot() end
    if setSpinBrainrotVisual then pcall(setSpinBrainrotVisual, spinBrainrotEnabled) end
    return spinBrainrotEnabled
end

_G.K7DuelsStartSpin = startSpin
_G.K7DuelsStopSpin = stopSpin
_G.K7DuelsStartSpinBrainrot = startSpinBrainrot
_G.K7DuelsStopSpinBrainrot = stopSpinBrainrot
_G.K7DuelsSpinStatus = function()
    return { normal = spinEnabled, brainrot = spinBrainrotEnabled, carrying = _fearSpinCarrying(), speed = spinSpeed }
end

-- ===== SPIN REMOVED: force disabled =====
spinEnabled = false
spinBrainrotEnabled = false
function startSpin() spinEnabled = false; if _spinConn then pcall(function() _spinConn:Disconnect() end); _spinConn = nil end end
function stopSpin() spinEnabled = false; if _spinConn then pcall(function() _spinConn:Disconnect() end); _spinConn = nil end end
function startSpinBrainrot() spinBrainrotEnabled = false; if _spinBrainrotConn then pcall(function() _spinBrainrotConn:Disconnect() end); _spinBrainrotConn = nil end end
function stopSpinBrainrot() spinBrainrotEnabled = false; if _spinBrainrotConn then pcall(function() _spinBrainrotConn:Disconnect() end); _spinBrainrotConn = nil end end
function toggleSpin() return false end
function toggleSpinBrainrot() return false end
_G.K7DuelsStartSpin = startSpin
_G.K7DuelsStopSpin = stopSpin
_G.K7DuelsStartSpinBrainrot = startSpinBrainrot
_G.K7DuelsStopSpinBrainrot = stopSpinBrainrot


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
            if stealHud.mode and stealHud.mode.Parent then stealHud.mode.Text = autoStealMode end
            if K7DuelsUI.footerStats and K7DuelsUI.footerStats.Parent then K7DuelsUI.footerStats.Text = stealHud.statsText end
        end
        local char2 = LP.Character
        if not char2 then return end
        local hum = char2:FindFirstChildOfClass("Humanoid")
        local hrp = char2:FindFirstChild("HumanoidRootPart")
        if not hum or not hrp then return end
        -- spin handled by startSpin RenderStepped

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
            speedLabel.Text = string.format("%.1f", displaySpeed)
        end
    end)
    setupSpeedIndicator(char)
    startEnemySpeed()
end

function toggleLockUI(state)
    if state == nil then uiLocked = not uiLocked else uiLocked = state end
    -- Lock also freezes floating/mobile button positions (same as Lock Mobile Buttons)
    mobileButtonsLocked = uiLocked == true
    if setLockUIVisual then setLockUIVisual(uiLocked) end
    if K7DuelsUI and K7DuelsUI.lockButtonsSetter then
        pcall(K7DuelsUI.lockButtonsSetter, mobileButtonsLocked)
    end
    if headerLock and headerLock.Parent then
        headerLock.Text = uiLocked and "🔒" or "🔓"
    end
end

function disableAllAimbots()
    if autoBatEnabled then
        disableAutoBat()
        if autoBatSetVisual then autoBatSetVisual(false) end
        if mobSetAutoBat then mobSetAutoBat(false) end
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
    if antiFlingEnabled then stopAntiFling() end
    stopBatCounter()
    if stopBatCounterV2 then stopBatCounterV2() end
    stopMedusaCounter()
    stopAutoSteal()
    disableAutoBat()
    stopAutoLeft()
    stopAutoRight()
    if _G.__K7DuelsStopBatV2 then pcall(_G.__K7DuelsStopBatV2) end
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
    if _G.__K7DuelsStopSpeedEngine then pcall(_G.__K7DuelsStopSpeedEngine) end
end

local _kryvoxHubSaveState = {
    lastAt = 0,
    queued = false,
    writing = false,
    dirty = false,
    revision = 0,
    retryCount = 0,
}
local function resolveK7DuelsFileApi()
    local env = (type(getgenv) == "function" and getgenv()) or _G
    local synApi = rawget(env, "syn") or rawget(_G, "syn")
    local readCandidates = {rawget(env, "readfile"), synApi and synApi.readfile, rawget(_G, "readfile")}
    local writeCandidates = {rawget(env, "writefile"), synApi and synApi.writefile, rawget(_G, "writefile")}
    local readFn, writeFn
    for _, fn in ipairs(readCandidates) do if type(fn) == "function" then readFn = fn; break end end
    for _, fn in ipairs(writeCandidates) do if type(fn) == "function" then writeFn = fn; break end end
    return readFn, writeFn
end

local function kryvoxHubFileExists(path)
    local readFn = resolveK7DuelsFileApi()
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
        antiFling = antiFlingEnabled,
        spinEnabled = spinEnabled,
        spinBrainrotEnabled = spinBrainrotEnabled,
        spinSpeed = spinSpeed,
        spinBrainrotSpeed = spinBrainrotSpeed,
        autoSteal = CONFIG.AUTO_STEAL_ENABLED,
        autoBat = autoBatEnabled, autoLeft = autoLeftEnabled, autoRight = autoRightEnabled,
        medusaCounter = medusaCounterEnabled, batCounter = batCounterEnabled,
        medusaSkin = _G.RivalMedusaSkin or "Default",
        batSkin = _G.K7DuelsBatSkin or "WitchBroom",
        batCounterV2 = batCounterV2Enabled, unwalkEnabled = unwalkEnabled,
        laggerToggled = laggerToggled, laggerCarryToggled = laggerCarryToggled,
        carryMode = speedMode, batAimbotSpeed = BAT_AIMBOT_SPEED,
        dropMode = dropMode,
        floatEnabled = _G.__RivalHubFloat and _G.__RivalHubFloat.running or false,
        floatRise = _G.__RivalHubFloat and _G.__RivalHubFloat.RISE or 17,
        floatPower = _G.__RivalHubFloat and _G.__RivalHubFloat.RATE or 55,
        stretchEnabled = stretchEnabled, stretchFOV = stretchFOV,
        uiScale = uiScaleValue, animPack = currentAnimPack,
        espEnabled = espEnabled,
        espLineEnabled = espLineEnabled,
        vividGraphics = vividGraphicsEnabled,
        hideButtons = hideButtonsEnabled,
        hiddenButtons = hiddenButtons or {},
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
        kryvoxTitleTheme = currentK7DuelsTitleTheme,
        infiniteJumpEnabled = InfiniteJump.enabled == true,
        infiniteJumpMode = InfiniteJump.mode == "manual" and "manual" or "hold",
        autoStealMode = autoStealMode,
        useVenixCarryEngine = useVenixCarryEngine,
        softCarry = K7DuelsVenixCarry.softStealEnabled,
        softCarrySpeed = K7DuelsVenixCarry.softStealSpeed,
        softCarryRadius = K7DuelsVenixCarry.softStealRadius,
        uiEffects = K7DuelsUI.effects,
        mobileButtonsLocked = mobileButtonsLocked,
        uiFont = K7DuelsUI.fontName or "GothamBold",
        batV2 = _G.__K7DuelsIsBatV2 and _G.__K7DuelsIsBatV2() or false,
        batBypassVersion = BAT_BYPASS_VERSION or "v1",
    }
    if main then
        local basePos = _G.__K7DuelsMainOriginalPos or main.Position
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
    config.introStyle = K7DuelsIntroStyle or 2
    return config
end

local function scheduleK7DuelsSave(delaySeconds)
    if _kryvoxHubSaveState.queued then return end
    _kryvoxHubSaveState.queued = true
    task.delay(delaySeconds or 0.25, function()
        _kryvoxHubSaveState.queued = false
        if _G.K7DuelsRunning and not _isResetting and not _isLoading then
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
        warn("[K7 DUELS Save] Could not encode settings.")
        return false
    end
    if not force and canonicalJSON == _lastSavedJSON and not _kryvoxHubSaveState.dirty then
        return true
    end
    _kryvoxHubSaveState.dirty = true

    if _kryvoxHubSaveState.writing then
        scheduleK7DuelsSave(0.25)
        return true
    end
    if not force and _tick() - _kryvoxHubSaveState.lastAt < 0.25 then
        scheduleK7DuelsSave(0.25)
        return true
    end

    local readFn, writeFn = resolveK7DuelsFileApi()
    if not readFn or not writeFn then
        warn("[K7 DUELS Save] Executor file API is unavailable.")
        scheduleK7DuelsSave(1)
        return false
    end

    _kryvoxHubSaveState.writing = true
    _kryvoxHubSaveState.revision = _kryvoxHubSaveState.revision + 1
    local writeConfig = config
    writeConfig.revision = _kryvoxHubSaveState.revision
    writeConfig.savedAt = os.time()
    local json = HS:JSONEncode(writeConfig)
    local ok = false

    for attempt = 1, 3 do
        local attemptOk = pcall(function()
            if kryvoxHubFileExists(CONFIG_FILE) then
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

    _kryvoxHubSaveState.writing = false
    if ok then
        _kryvoxHubSaveState.lastAt = _tick()
        _kryvoxHubSaveState.retryCount = 0
        _lastSavedJSON = canonicalJSON
        _kryvoxHubSaveState.dirty = false
        local latestOk, latest = pcall(function()
            local latestConfig = buildConfigTable()
            latestConfig.configVersion = 2
            latestConfig.userId = LP.UserId
            return HS:JSONEncode(latestConfig)
        end)
        if not latestOk or latest ~= _lastSavedJSON then
            _kryvoxHubSaveState.dirty = true
            scheduleK7DuelsSave(0.25)
        end
    else
        _kryvoxHubSaveState.retryCount = _kryvoxHubSaveState.retryCount + 1
        warn("[K7 DUELS Save] Write or verification failed; will retry.")
        scheduleK7DuelsSave(math.min(2, 0.5 * _kryvoxHubSaveState.retryCount))
    end
    return ok
end

task.spawn(function()
    task.wait(5)
    while _G.K7DuelsRunning do
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
    local readFn, writeFn = resolveK7DuelsFileApi()
    if readFn and writeFn then
        local legacyPaths = {"Kryvox.json", "NIGHT #3_" .. tostring(LP.UserId) .. ".json", "K7Duels.json", "K7 DUELS_" .. tostring(LP.UserId) .. ".json", "K7Dueles_" .. tostring(LP.UserId) .. ".json", "BlessK7_" .. tostring(LP.UserId) .. ".json", "Bless K7_" .. tostring(LP.UserId) .. ".json"}

        local okNew, _ = pcall(readFn, CONFIG_FILE)
        if not okNew then
            for _, oldPath in ipairs(legacyPaths) do
                local okOld, old = pcall(readFn, oldPath)
                if okOld and type(old) == "string" and #old > 0 then
                    pcall(writeFn, CONFIG_FILE, old)
                    warn("[K7 DUELS] Config migrada de " .. oldPath .. " a " .. CONFIG_FILE)
                    break
                end
            end
        end
    end
end

function loadAllSettings()
    local readFn = resolveK7DuelsFileApi()
    if not readFn or not kryvoxHubFileExists(CONFIG_FILE) then return false end
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
    if tonumber(data.introStyle) then
        K7DuelsIntroStyle = math.clamp(math.floor(tonumber(data.introStyle)), 1, 2)
    end
    mobileButtonsLocked = false

    if data.antiRagdollMode then
        antiRagdollMode = tostring(data.antiRagdollMode)
    else
        antiRagdollMode = data.antiRagdoll and "v2" or "off"
    end
    antiDieEnabled = boolOr(data.antiDieEnabled, false)
    antiFlingEnabled = boolOr(data.antiFling, false)
    spinEnabled = false -- spin removed
    spinBrainrotEnabled = false -- spin removed
    spinSpeed = num(data.spinSpeed, spinSpeed or 25)
    spinBrainrotSpeed = num(data.spinBrainrotSpeed, spinBrainrotSpeed or 32)
    CONFIG.AUTO_STEAL_ENABLED = boolOr(data.autoSteal, false)
    autoBatEnabled = boolOr(data.autoBat, false)
    autoLeftEnabled = boolOr(data.autoLeft, false)
    autoRightEnabled = boolOr(data.autoRight, false)
    setAutoStealMode(data.autoStealMode or "V1")
    BAT_BYPASS_VERSION = (data.batBypassVersion == "v2") and "v2" or "v1"
    _G.__RivalHubBatVersion = BAT_BYPASS_VERSION
    useVenixCarryEngine = boolOr(data.useVenixCarryEngine, false)
    K7DuelsVenixCarry.softStealSpeed = _clamp(num(data.softCarrySpeed, 30), 1, 500)
    K7DuelsVenixCarry.softStealRadius = _clamp(num(data.softCarryRadius, 10), 1, 200)
    K7DuelsVenixCarry:setSoftStealEnabled(false)
    _G.M4AutoSpeedEnabled = boolOr(data.softCarry, false)
    if _G.M4AutoSpeedEnabled and _G.M4AutoSpeedStart then pcall(_G.M4AutoSpeedStart) end
    K7DuelsUI.effects = boolOr(data.uiEffects, true)
    mobileButtonsLocked = boolOr(data.mobileButtonsLocked, false)
    if type(data.uiFont) == "string" and K7DuelsUI.resolveFont and K7DuelsUI.resolveFont(data.uiFont) then
        K7DuelsUI.fontName = data.uiFont
    end
    if _G.__K7DuelsRefreshSpeedEngine then pcall(_G.__K7DuelsRefreshSpeedEngine) end
    InfiniteJump.mode = data.infiniteJumpMode == "manual" and "manual" or "hold"
    InfiniteJump.enabled = boolOr(data.infiniteJumpEnabled, false)
    medusaCounterEnabled = boolOr(data.medusaCounter, false)
    if type(data.medusaSkin) == "string" and _G.RivalSetMedusaSkin then
        _G.RivalSetMedusaSkin(data.medusaSkin)
        if _G.RivalMedusaSkinRefreshUI then pcall(_G.RivalMedusaSkinRefreshUI) end
    end
    if type(data.batSkin) == "string" then
        -- Guardar siempre el valor; el módulo de bat skin puede inicializarse después del load.
        _G.K7DuelsBatSkin = data.batSkin
        if _G.K7DuelsSetBatSkin then
            _G.K7DuelsSetBatSkin(data.batSkin)
            if _G.K7DuelsBatSkinRefreshUI then pcall(_G.K7DuelsBatSkinRefreshUI) end
        end
    end
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
    if type(data.hiddenButtons) == "table" then hiddenButtons = data.hiddenButtons else hiddenButtons = hiddenButtons or {} end

    TPBatState.enabled = false

    currentColorTheme = "WhitePurple"
    selectedColor = Color3.fromRGB(185, 110, 255)
    _G.__K7DuelsThemeSecondary = Color3.fromRGB(55, 20, 105)
    task.defer(function() updateAllUIThemeColors(selectedColor) end)

    if data.kryvoxTitleTheme and K7DUELS_TITLE_THEMES[data.kryvoxTitleTheme] then
        task.defer(function() applyK7DuelsTitleTheme(data.kryvoxTitleTheme) end)
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
    if _G.__RivalHubFloat then
        _G.__RivalHubFloat.RISE = _clamp(num(data.floatRise, _G.__RivalHubFloat.RISE), 2, 100)
        _G.__RivalHubFloat.RATE = _clamp(num(data.floatPower, _G.__RivalHubFloat.RATE), 5, 300)
        if data.floatEnabled == true then task.defer(function() pcall(_G.__RivalHubFloat.enable) end) end
    end
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

    -- batV2 / TP Bat removed: never auto-start
    if _G.__K7DuelsStopBatV2 then pcall(_G.__K7DuelsStopBatV2) end

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
    if floatRiseBox and _G.__RivalHubFloat then floatRiseBox.Text = tostring(_G.__RivalHubFloat.RISE) end
    if floatPowerBox and _G.__RivalHubFloat then floatPowerBox.Text = tostring(_G.__RivalHubFloat.RATE) end
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
    safeSet(setAntiFlingVisual, false)
    safeSet(setAntiRagVisual, false)
    safeSet(infJumpSetVisual, false)
    if autoStealModeBtn then autoStealModeBtn.Text = autoStealMode end
    if K7DuelsUI.motorLabel then K7DuelsUI.motorLabel.Text = "Direct" end
    if K7DuelsUI.carrySetter then K7DuelsUI.carrySetter(false) end
    if K7DuelsUI.effectsSetter then K7DuelsUI.effectsSetter(K7DuelsUI.effects) end
    if K7DuelsUI.lockButtonsSetter then K7DuelsUI.lockButtonsSetter(false) end
    applyBackgroundMode(backgroundMode)
    if _G.__K7DuelsRefreshSpeedEngine then pcall(_G.__K7DuelsRefreshSpeedEngine) end
    safeSet(mobSetBatV2, false)
    if _G.__K7DuelsStopBatV2 then pcall(_G.__K7DuelsStopBatV2) end
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
    currentColorTheme = "WhitePurple"
    selectedColor = Color3.fromRGB(255, 255, 255)
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
        pbFrame.Position = UDim2.new(0.5, -117.5, 0, 38)
        savedProgressBarPos = nil
    end
    savedMobilePanelPos = nil
    if K7DuelsUI.fit then K7DuelsUI.fit() end
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
        if antiFlingEnabled and stopAntiFling then stopAntiFling() end
        if _G.__K7DuelsStopBatV2 then pcall(_G.__K7DuelsStopBatV2) end
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
        NS = 59.5; CS = 28.8; LAGGER_SPEED = 24.5; LAGGER_CARRY_SPEED = 15
        CONFIG.STEAL_RANGE = 61
        CONFIG.HOLD_MIN = 0.05
        CONFIG.HOLD_MAX = 0.15
        CONFIG.ENTRY_DELAY = 0.1
        CONFIG.COOLDOWN = 0.2
        CONFIG.PRIME_RANGE = 60
        speedMode = false; laggerToggled = false; laggerCarryToggled = false
        antiRagdollMode = "off"; antiDieEnabled = false
        antiFlingEnabled = false
        medusaCounterEnabled = false; batCounterEnabled = false; batCounterV2Enabled = false
        autoBatEnabled = false; autoLeftEnabled = false; autoRightEnabled = false
        unwalkEnabled = false; antiLagEnabled = false
        uiLocked = false; mobileButtonsLocked = false
        CONFIG.AUTO_STEAL_ENABLED = false
        setAutoStealMode("V1")
        useVenixCarryEngine = false
        K7DuelsVenixCarry:stop()
        K7DuelsVenixCarry.softStealEnabled = false
        K7DuelsVenixCarry.softStealSpeed = 30
        K7DuelsVenixCarry.softStealRadius = 10
        K7DuelsUI.effects = true
        if _G._kryvoxHubStealModeSetter then pcall(_G._kryvoxHubStealModeSetter, "V1") end
        BAT_AIMBOT_SPEED = 55
        BYPASS_AIMBOT_SPEED = BAT_AIMBOT_SPEED
        if State then State.bypassBatSpeed = BYPASS_AIMBOT_SPEED end
        dropMode = 1; stretchEnabled = false; stretchFOV = 120
        uiScaleValue = 90
        if K7DuelsUI.fit then K7DuelsUI.fit() end
        if pbScale then pbScale.Scale = 1 end
        espEnabled = false; espLineEnabled = false; vividGraphicsEnabled = false; hideButtonsEnabled = false
        bodyLockEnabled = false; bodyLockRange = 20
        backgroundIndex = 1; backgroundImageTransparency = 0; backgroundMode = "Background 1"
        floatingButtonScale = 1
        currentAnimPack = "Off"; stopAnimPack()
        currentOutfitIndex = 1
        pcall(VX7A.stop)
        currentColorTheme = "WhitePurple"; selectedColor = Color3.fromRGB(185, 110, 255); _G.__K7DuelsThemeSecondary = Color3.fromRGB(55, 20, 105)
        currentK7DuelsTitleTheme = "Purple"
        applyK7DuelsTitleTheme("Purple")
        if main then main.Position = UDim2.new(0, 20, 0, 2); _G.__K7DuelsMainOriginalPos = main.Position end
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
    local map = {DropBR = 0, AutoLeft = 1, AutoBat = 2, AutoRight = 3, TpDown = 4, Carry = 5, Lagger1 = 6, Lagger2 = 7, Float = 8, InstaReset = 9}
    local index = map[name] or 0
    local cam = Workspace.CurrentCamera
    local size = cam and cam.ViewportSize or Vector2.new(844, 390)
    local spacing = 60 * floatingButtonScale + 6
    local startX = math.max(8, size.X - spacing * 3 - 18)
    local startY = math.max(110, size.Y - spacing * 3 - 96)
    return startX + index % 3 * spacing, startY + _floor(index / 3) * spacing
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
    -- TP Bat removed: force disabled
    value = false
    TPBatState.enabled = false
    if false then
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


-- ========== NORTH MUSIC (replaces Ping Lagger) ==========
-- Cargado de forma segura: si falla, K7Duels sigue funcionando
local _northMusicLoadOk, _northMusicLoadErr = pcall(function()
if _G.__NorthMusicRunning then
    pcall(function() if _G.NorthCloseMusic then _G.NorthCloseMusic() end end)
    task.wait(0.3)
end
_G.__NorthMusicRunning = true

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TS = game:GetService("TweenService")
local HS = game:GetService("HttpService")
local SoundService = game:GetService("SoundService")
local CoreGui = game:GetService("CoreGui")
local LP = Players.LocalPlayer
local PGUI = LP:WaitForChild("PlayerGui")

local API = "https://ymp-api.ddns.net"
local API_KEY = "dfcb6d76f2f6a9894gjkege8a4ab232222"
local BASE_URL = "https://p.savenow.to"
local REFERER = "https://en.loader.to/"
local CACHE_FOLDER = "north_music"
local THUMB_FOLDER = CACHE_FOLDER .. "/thumbs"
local MUSIC_FOLDER = CACHE_FOLDER .. "/songs"
local FAV_FILE = CACHE_FOLDER .. "/favorites.json"
local SETTINGS_FILE = CACHE_FOLDER .. "/settings.json"
local BACKGROUND_ID = "119693301149628"

local request_ = request or http_request or syn_request or (syn and syn.request) or (fluxus and fluxus.request) or (getgenv and getgenv().request) or (http and http.request)

if not isfolder(CACHE_FOLDER) then makefolder(CACHE_FOLDER) end
if not isfolder(THUMB_FOLDER) then makefolder(THUMB_FOLDER) end
if not isfolder(MUSIC_FOLDER) then makefolder(MUSIC_FOLDER) end

local State = {
    currentId = nil,
    currentInfo = nil,
    playing = false,
    volume = 0.5,
    favorites = {},
    showingFavs = false,
    loop = "off",
    shuffle = false,
    miniPlayer = false,
    lastSearchResults = {},
    theme = "dark",
    quality = "320",
    crossfade = 0,
    showLyrics = false,
    currentLyrics = nil,
    queue = {},
    queueIndex = 0,
    queueOpen = false,
}

local sound = Instance.new("Sound")
sound.Parent = SoundService
sound.Volume = State.volume
sound.Looped = false

local soundFade = Instance.new("Sound")
soundFade.Parent = SoundService
soundFade.Volume = 0
soundFade.Looped = false

local function saveJSON(path, data) pcall(function() writefile(path, HS:JSONEncode(data)) end) end
local function loadJSON(path, default)
    if not isfile(path) then return default end
    local ok, data = pcall(function() return HS:JSONDecode(readfile(path)) end)
    if ok and type(data) == "table" then return data end
    return default
end

State.favorites = loadJSON(FAV_FILE, {})
local settings = loadJSON(SETTINGS_FILE, { volume = 0.5, loop = "off", shuffle = false, theme = "dark", quality = "320", crossfade = 0 })
State.volume = tonumber(settings.volume) or 0.5
State.loop = settings.loop or "off"
State.shuffle = settings.shuffle or false
State.theme = settings.theme or "dark"
State.quality = settings.quality or "320"
State.crossfade = tonumber(settings.crossfade) or 0
sound.Volume = State.volume

local function saveSettings()
    saveJSON(SETTINGS_FILE, {
        volume = State.volume, loop = State.loop, shuffle = State.shuffle,
        theme = State.theme, quality = State.quality, crossfade = State.crossfade,
    })
end
local function saveFavorites() saveJSON(FAV_FILE, State.favorites) end

local function isFavorite(videoId)
    for _, id in ipairs(State.favorites) do if id == videoId then return true end end
    return false
end

local function toggleFavorite(videoId)
    for i, id in ipairs(State.favorites) do
        if id == videoId then table.remove(State.favorites, i); saveFavorites(); return false end
    end
    table.insert(State.favorites, videoId); saveFavorites(); return true
end

local function getThumbnail(videoId)
    if not videoId or #videoId ~= 11 then return nil end
    local path = THUMB_FOLDER .. "/" .. videoId .. ".jpg"
    if isfile(path) then
        local ok, asset = pcall(getcustomasset, path)
        if ok then return asset end
    end
    local urls = {
        "https://img.youtube.com/vi/" .. videoId .. "/maxresdefault.jpg",
        "https://img.youtube.com/vi/" .. videoId .. "/hqdefault.jpg",
    }
    for _, url in ipairs(urls) do
        local ok, data = pcall(function() return game:HttpGet(url) end)
        if ok and data and #data > 1000 then
            pcall(function() writefile(path, data) end)
            local ok2, asset = pcall(getcustomasset, path)
            if ok2 then return asset end
        end
    end
    return nil
end

local function searchYouTube(query)
    local url = API .. "/search/youtube/free/" .. HS:UrlEncode(query)
    local ok, response = pcall(function() return game:HttpGet(url) end)
    if not ok or not response then return {} end
    local ok2, data = pcall(function() return HS:JSONDecode(response) end)
    if not ok2 or not data or not data.results then return {} end
    return data.results
end

local function getVideoInfo(videoId)
    local url = API .. "/info?url=https://youtu.be/" .. videoId
    local ok, response = pcall(function() return game:HttpGet(url) end)
    if not ok or not response then return nil end
    local ok2, data = pcall(function() return HS:JSONDecode(response) end)
    if not ok2 or not data then return nil end
    return { id = videoId, name = data.Name or "Unknown", author = data.Author or "" }
end

local function getLyrics(artist, title)
    if not artist or not title or artist == "" or title == "" then return nil end
    local cleanArtist = artist:gsub("%s*%-%s*Topic$", ""):gsub("[%(%)%[%]]", ""):match("^%s*(.-)%s*$")
    local cleanTitle = title:gsub("%(.*%)", ""):gsub("%[.*%]", ""):gsub("ft%.?.-$", ""):gsub("feat%.?.-$", ""):gsub("official.*$", ""):gsub("lyric.*$", ""):gsub("video.*$", ""):match("^%s*(.-)%s*$")
    local url = "https://api.lyrics.ovh/v1/" .. HS:UrlEncode(cleanArtist) .. "/" .. HS:UrlEncode(cleanTitle)
    local ok, response = pcall(function() return game:HttpGet(url) end)
    if not ok or not response then return nil end
    local ok2, data = pcall(function() return HS:JSONDecode(response) end)
    if not ok2 or not data or not data.lyrics then return nil end
    return data.lyrics
end

local bit32 = bit32

local function hash_sha256(str)
    local K = {
        1116352408, 1899447441, 3049323471, 3921009573, 961987163, 1508970993,
        2453635748, 2870763221, 3624381080, 310598401, 607225278, 1426881987,
        1925078388, 2162078206, 2614888103, 3248222580, 3835390401, 4022224774,
        264347078, 604807628, 770255983, 1249150122, 1555081692, 1996064986,
        2554220882, 2821834349, 2952996808, 3210313671, 3336571891, 3584528711,
        113926993, 338241895, 666307205, 773529912, 1294757372, 1396182291,
        1695183700, 1986661051, 2177026350, 2456956037, 2730485921, 2820302411,
        3259730800, 3345764771, 3516065817, 3600352804, 4094571909, 275423344,
        430227734, 506948616, 659060556, 883997877, 958139571, 1322822218,
        1537002063, 1747873779, 1955562222, 2024104815, 2227730452, 2361852424,
        2428436474, 2756734187, 3204031479, 3329325298,
    }
    local function add(...)
        local args = table.pack(...)
        local s = 0
        for i = 1, args.n do s = bit32.band(s + args[i], 0xFFFFFFFF) end
        return s
    end
    local bytes = {string.byte(str, 1, #str)}
    local bitlen = #str * 8
    bytes[#bytes + 1] = 128
    while #bytes % 64 ~= 56 do bytes[#bytes + 1] = 0 end
    for i = 24, 0, -8 do bytes[#bytes + 1] = bit32.band(bit32.rshift(math.floor(bitlen / 4294967296), i), 255) end
    for i = 24, 0, -8 do bytes[#bytes + 1] = bit32.band(bit32.rshift(bitlen % 4294967296, i), 255) end
    local h0, h1, h2, h3 = 1779033703, 3144134277, 1013904242, 2773480762
    local h4, h5, h6, h7 = 1359893119, 2600822924, 528734635, 1541459225
    for i = 1, #bytes, 64 do
        local w = {}
        for j = 0, 15 do
            local b = i + j * 4
            w[j + 1] = bit32.bor(bit32.lshift(bytes[b] or 0, 24), bit32.lshift(bytes[b+1] or 0, 16), bit32.lshift(bytes[b+2] or 0, 8), bytes[b+3] or 0)
        end
        for j = 17, 64 do
            local s0 = bit32.bxor(bit32.rrotate(w[j-15], 7), bit32.rrotate(w[j-15], 18), bit32.rshift(w[j-15], 3))
            local s1 = bit32.bxor(bit32.rrotate(w[j-2], 17), bit32.rrotate(w[j-2], 19), bit32.rshift(w[j-2], 10))
            w[j] = add(w[j-16], s0, w[j-7], s1)
        end
        local a, b, c, d = h0, h1, h2, h3
        local e, f, g, h = h4, h5, h6, h7
        for j = 1, 64 do
            local S1 = bit32.bxor(bit32.rrotate(e, 6), bit32.rrotate(e, 11), bit32.rrotate(e, 25))
            local ch = bit32.bxor(bit32.band(e, f), bit32.band(bit32.bnot(e), g))
            local temp1 = add(h, S1, ch, K[j], w[j])
            local S0 = bit32.bxor(bit32.rrotate(a, 2), bit32.rrotate(a, 13), bit32.rrotate(a, 22))
            local maj = bit32.bxor(bit32.band(a, b), bit32.band(a, c), bit32.band(b, c))
            local temp2 = add(S0, maj)
            h = g; g = f; f = e; e = add(d, temp1)
            d = c; c = b; b = a; a = add(temp1, temp2)
        end
        h0 = add(h0, a); h1 = add(h1, b); h2 = add(h2, c); h3 = add(h3, d)
        h4 = add(h4, e); h5 = add(h5, f); h6 = add(h6, g); h7 = add(h7, h)
    end
    return string.format("%08x%08x%08x%08x%08x%08x%08x%08x", h0, h1, h2, h3, h4, h5, h6, h7)
end

local function solve_pow(salt, difficulty)
    local target = string.rep("0", tonumber(difficulty))
    local n = 0
    local start = os.clock()
    while true do
        if hash_sha256(salt .. ":" .. tostring(n)):sub(1, #target) == target then return tostring(n) end
        n = n + 1
        if os.clock() - start > 0.003 then task.wait(); start = os.clock() end
    end
end

local function make_headers(token, jsonBody)
    local headers = {
        accept = "*/*",
        ["accept-language"] = "en-US,en;q=0.9",
        referer = REFERER,
        ["sec-ch-ua"] = '"Chromium";v="137", "Not/A)Brand";v="24"',
        ["sec-ch-ua-mobile"] = "?1",
        ["sec-ch-ua-platform"] = '"Android"',
        ["sec-fetch-dest"] = "empty",
        ["sec-fetch-mode"] = "cors",
        ["sec-fetch-site"] = "cross-site",
    }
    if jsonBody then headers["content-type"] = "application/json" end
    if token then headers.authorization = "Bearer " .. token end
    return headers
end

local function decode_body(resp)
    if not resp then return nil end
    local body = resp.Body or resp.body
    if type(body) ~= "string" then return nil end
    local ok, data = pcall(HS.JSONDecode, HS, body)
    if not ok or type(data) ~= "table" then return nil end
    return data
end

local _powCache = { token = nil, expires = 0 }
local _powLock = false

local function get_pow_token()
    local now = os.time()
    if _powCache.token and now < _powCache.expires - 30 then return _powCache.token end
    if _powLock then
        local t = os.clock()
        while _powLock do
            if os.clock() - t >= 10 then break end
            task.wait()
        end
        if _powCache.token and os.time() < _powCache.expires - 30 then return _powCache.token end
    end
    _powLock = true
    local ok, token, expires = pcall(function()
        local resp = request_({Url = BASE_URL .. "/api/pow/challenge", Method = "GET", Headers = make_headers()})
        local data = decode_body(resp)
        if not data or not data.salt or not data.difficulty or not data.expires_at or not data.signature then return nil end
        local nonce = solve_pow(data.salt, data.difficulty)
        local verify = request_({
            Url = BASE_URL .. "/api/pow/verify", Method = "POST",
            Headers = make_headers(nil, true),
            Body = HS:JSONEncode({salt = data.salt, difficulty = data.difficulty, expires_at = data.expires_at, signature = data.signature, nonce = nonce}),
        })
        local vdata = decode_body(verify)
        if not vdata or vdata.success ~= true or type(vdata.token) ~= "string" then return nil end
        return vdata.token, tonumber(vdata.expires_at) or os.time() + 300
    end)
    _powLock = false
    if not ok or type(token) ~= "string" then return nil end
    _powCache.token = token
    _powCache.expires = tonumber(expires) or os.time() + 300
    return token
end

local function downloadAudio(videoId, onProgress)
    if not request_ then return nil, "Executor sin request" end
    onProgress = onProgress or function() end
    onProgress("Preparando...", 0)
    local token = get_pow_token()
    if not token then return nil, "No token" end
    onProgress("Iniciando...", 5)
    local format = State.quality == "320" and "mp3" or (State.quality == "192" and "mp3" or "mp3")
    local url = BASE_URL .. "/api/v2/download?format=" .. format .. "&url=" .. HS:UrlEncode("https://youtu.be/" .. videoId) .. "&apikey=" .. API_KEY
    local resp = request_({Url = url, Method = "GET", Headers = make_headers(token)})
    local data = decode_body(resp)
    if not data or data.success == false or type(data.progress_url) ~= "string" then return nil, "Sin progress URL" end
    local progressUrl = data.progress_url
    local result = nil
    local start = os.clock()
    local TIMEOUT = 600
    task.wait(2)
    while os.clock() - start < TIMEOUT do
        local ok, presp = pcall(function()
            return request_({Url = progressUrl, Method = "GET", Headers = make_headers(token)})
        end)
        if ok then
            local pdata = decode_body(presp)
            if pdata then
                local prog = tonumber(pdata.progress) or 0
                local pct = math.floor((prog / 1000) * 100)
                onProgress(string.format("Convirtiendo %d%% (%s kbps)", pct, State.quality), 5 + (pct / 100) * 70)
                if prog == 1000 and type(pdata.download_url) == "string" then result = pdata; break end
            end
        end
        task.wait(2)
    end
    if not result then return nil, "Timeout" end
    onProgress("Descargando archivo...", 75)
    local urls = {}
    if type(result.download_url) == "string" then table.insert(urls, result.download_url) end
    if type(result.alternative_download_urls) == "table" then
        for _, alt in ipairs(result.alternative_download_urls) do
            if type(alt) == "table" and type(alt.url) == "string" and alt.url ~= result.download_url then table.insert(urls, alt.url) end
            if #urls >= 4 then break end
        end
    end
    if #urls == 0 then return nil, "Sin URLs" end
    for i, dlUrl in ipairs(urls) do
        onProgress(string.format("Descargando %d/%d", i, #urls), 80)
        local ok, audio = pcall(function() return game:HttpGet(dlUrl) end)
        if ok and audio and #audio > 1000 then
            onProgress("Guardando...", 95)
            return audio
        end
    end
    return nil, "Todos los intentos fallaron"
end

local THEMES = {
    dark = {
        bg = Color3.fromRGB(22, 22, 26),
        card = Color3.fromRGB(28, 28, 33),
        cardHover = Color3.fromRGB(38, 38, 44),
        grayDark = Color3.fromRGB(60, 60, 68),
        grayDeep = Color3.fromRGB(38, 38, 44),
        text = Color3.fromRGB(248, 248, 252),
        textDim = Color3.fromRGB(155, 155, 165),
        white = Color3.fromRGB(250, 250, 252),
        grayLight = Color3.fromRGB(200, 200, 208),
        grayMid = Color3.fromRGB(150, 150, 160),
        overlay = 0.45,
    },
    light = {
        bg = Color3.fromRGB(240, 240, 245),
        card = Color3.fromRGB(255, 255, 255),
        cardHover = Color3.fromRGB(245, 245, 250),
        grayDark = Color3.fromRGB(180, 180, 190),
        grayDeep = Color3.fromRGB(220, 220, 230),
        text = Color3.fromRGB(30, 30, 40),
        textDim = Color3.fromRGB(100, 100, 115),
        white = Color3.fromRGB(30, 30, 40),
        grayLight = Color3.fromRGB(120, 120, 135),
        grayMid = Color3.fromRGB(150, 150, 165),
        overlay = 0.75,
    },
}

local function getTheme()
    return THEMES[State.theme] or THEMES.dark
end

local GOLD = Color3.fromRGB(230, 185, 50)
local RED = Color3.fromRGB(200, 60, 60)

local _gui = nil
local _conns = {}
local _searchCache = {}
local _miniGui = nil
local _miniConns = {}
local _mainPanel = nil
local _miniPanel = nil
local _uiRefs = {}

local function cleanup()
    for _, c in ipairs(_conns) do pcall(function() c:Disconnect() end) end
    _conns = {}
    if _gui then pcall(function() _gui:Destroy() end) end
    _gui = nil
    _mainPanel = nil
    _uiRefs = {}
end

local function cleanupMini()
    for _, c in ipairs(_miniConns) do pcall(function() c:Disconnect() end) end
    _miniConns = {}
    if _miniGui then pcall(function() _miniGui:Destroy() end) end
    _miniGui = nil
    _miniPanel = nil
end

local function track(c) table.insert(_conns, c); return c end
local function trackMini(c) table.insert(_miniConns, c); return c end

local function formatTime(s)
    if not s or s ~= s then return "0:00" end
    return string.format("%d:%02d", math.floor(s / 60), math.floor(s % 60))
end

local fadeToken = 0

local function playWithCrossfade(soundId, isVideo)
    fadeToken = fadeToken + 1
    local myToken = fadeToken
    
    if State.crossfade <= 0 or not sound.Playing then
        sound:Stop()
        sound.SoundId = soundId
        sound.Volume = State.volume
        sound.Looped = (State.loop == "one")
        sound:Play()
        return
    end
    
    local fadeTime = State.crossfade
    
    task.spawn(function()
        local steps = 20
        local stepTime = fadeTime / steps
        for i = 1, steps do
            if fadeToken ~= myToken then return end
            local pct = i / steps
            sound.Volume = State.volume * (1 - pct)
            task.wait(stepTime)
        end
        
        if fadeToken ~= myToken then return end
        sound:Stop()
        sound.SoundId = soundId
        sound.Volume = 0
        sound.Looped = (State.loop == "one")
        sound:Play()
        
        for i = 1, steps do
            if fadeToken ~= myToken then return end
            local pct = i / steps
            sound.Volume = State.volume * pct
            task.wait(stepTime)
        end
    end)
end


function _G.NorthOpenMusic()
    if _gui and _gui.Parent then
        if _mainPanel then
            _mainPanel.Visible = true
            _mainPanel.Size = UDim2.new(0, 10, 0, 10)
            TS:Create(_mainPanel, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                Size = UDim2.new(0, 320, 0, 480),
            }):Play()
        end
        return
    end
    
    _gui = nil; _conns = {}
    local T = getTheme()
    
    local gui = Instance.new("ScreenGui")
    gui.Name = "NorthMusicPlayer"
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = false
    gui.DisplayOrder = 90
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    pcall(function() if syn and syn.protect_gui then syn.protect_gui(gui) end end)
    local parented = false
    pcall(function() gui.Parent = CoreGui; parented = (gui.Parent ~= nil) end)
    if not parented then pcall(function() gui.Parent = PGUI end) end
    if not gui.Parent then return end
    _gui = gui
    
    local panel = Instance.new("Frame", gui)
    panel.AnchorPoint = Vector2.new(0.5, 0.5)
    panel.Position = UDim2.new(0.5, 0, 0.5, 0)
    panel.Size = UDim2.new(0, 320, 0, 480)
    panel.BackgroundColor3 = T.bg
    panel.BorderSizePixel = 0
    panel.Active = true
    panel.ClipsDescendants = true
    panel.ZIndex = 1
    Instance.new("UICorner", panel).CornerRadius = UDim.new(0, 14)
    _mainPanel = panel
    
    local bgImage = Instance.new("ImageLabel", panel)
    bgImage.Size = UDim2.new(1, 0, 1, 0)
    bgImage.BackgroundColor3 = T.bg
    bgImage.BorderSizePixel = 0
    bgImage.Image = "rbxassetid://" .. BACKGROUND_ID
    bgImage.ImageTransparency = 0
    bgImage.ScaleType = Enum.ScaleType.Crop
    bgImage.ZIndex = 1
    Instance.new("UICorner", bgImage).CornerRadius = UDim.new(0, 14)
    
    local darkOverlay = Instance.new("Frame", panel)
    darkOverlay.Size = UDim2.new(1, 0, 1, 0)
    darkOverlay.BackgroundColor3 = State.theme == "dark" and Color3.fromRGB(0, 0, 0) or Color3.fromRGB(255, 255, 255)
    darkOverlay.BackgroundTransparency = T.overlay
    darkOverlay.BorderSizePixel = 0
    darkOverlay.ZIndex = 2
    Instance.new("UICorner", darkOverlay).CornerRadius = UDim.new(0, 14)
    _uiRefs.overlay = darkOverlay
    
    local overlayGrad = Instance.new("UIGradient", darkOverlay)
    overlayGrad.Rotation = 135
    overlayGrad.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, T.overlay - 0.2),
        NumberSequenceKeypoint.new(0.5, T.overlay),
        NumberSequenceKeypoint.new(1, T.overlay + 0.15),
    })
    _uiRefs.overlayGrad = overlayGrad
    
    local panelStroke = Instance.new("UIStroke", panel)
    panelStroke.Color = T.grayDark
    panelStroke.Thickness = 1.2
    panelStroke.Transparency = 0.3
    panelStroke.ZIndex = 10
    
    local shadow = Instance.new("ImageLabel", panel)
    shadow.AnchorPoint = Vector2.new(0.5, 0.5)
    shadow.Position = UDim2.new(0.5, 0, 0.5, 0)
    shadow.Size = UDim2.new(1, 20, 1, 20)
    shadow.BackgroundTransparency = 1
    shadow.Image = "rbxassetid://5028857084"
    shadow.ImageColor3 = Color3.fromRGB(0,0,0)
    shadow.ImageTransparency = 0.55
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(24, 24, 276, 276)
    shadow.ZIndex = 0

    local header = Instance.new("Frame", panel)
    header.Size = UDim2.new(1, 0, 0, 44)
    header.BackgroundColor3 = State.theme == "dark" and Color3.fromRGB(14, 14, 18) or Color3.fromRGB(230, 230, 238)
    header.BackgroundTransparency = 0.15
    header.BorderSizePixel = 0
    header.Active = true
    header.ZIndex = 5
    Instance.new("UICorner", header).CornerRadius = UDim.new(0, 14)
    _uiRefs.header = header
    
    local hGrad = Instance.new("UIGradient", header)
    hGrad.Rotation = 135
    hGrad.Color = State.theme == "dark" and ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(36, 36, 44)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(14, 14, 18)),
    }) or ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(245, 245, 250)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(215, 215, 225)),
    })
    
    local title = Instance.new("TextLabel", header)
    title.Size = UDim2.new(1, -150, 1, 0)
    title.Position = UDim2.new(0, 12, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = ""
    title.TextColor3 = T.text
    title.Font = Enum.Font.GothamBlack
    title.TextSize = 12
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.ZIndex = 6
        local byLabel = Instance.new("TextLabel", header)
    byLabel.Size = UDim2.new(1, -155, 0, 10)
    byLabel.Position = UDim2.new(0, 14, 0, 27)
    byLabel.BackgroundTransparency = 1
    byLabel.Text = "OPP!"
    byLabel.TextColor3 = T.textDim
    byLabel.Font = Enum.Font.GothamMedium
    byLabel.TextSize = 8
    byLabel.TextXAlignment = Enum.TextXAlignment.Left
    byLabel.ZIndex = 6
    local titleGrad = Instance.new("UIGradient", title)
    titleGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, T.white),
        ColorSequenceKeypoint.new(1, T.grayMid),
    })
    
    local function makeHeaderBtn(posX, text, color)
        local btn = Instance.new("TextButton", header)
        btn.Size = UDim2.new(0, 22, 0, 22)
        btn.Position = UDim2.new(1, posX, 0.5, -11)
        btn.BackgroundColor3 = T.grayDeep
        btn.BorderSizePixel = 0
        btn.Text = text
        btn.TextColor3 = color or T.text
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 12
        btn.AutoButtonColor = false
        btn.ZIndex = 7
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
        return btn
    end
    
    local themeBtn = makeHeaderBtn(-142, "☀", GOLD)
    local qualityBtn = makeHeaderBtn(-114, "HQ", GOLD)
    local lyricsBtn = makeHeaderBtn(-86, "♪", T.textDim)
    local queueBtn = makeHeaderBtn(-58, "☰", T.textDim)
    local minBtn = makeHeaderBtn(-30, "−", T.text)
    
    local favTabBtn = Instance.new("TextButton", header)
    favTabBtn.Size = UDim2.new(0, 22, 0, 22)
    favTabBtn.Position = UDim2.new(1, -2, 0.5, -11)
    favTabBtn.BackgroundColor3 = T.grayDeep
    favTabBtn.BorderSizePixel = 0
    favTabBtn.Text = "×"
    favTabBtn.TextColor3 = T.text
    favTabBtn.Font = Enum.Font.GothamBold
    favTabBtn.TextSize = 14
    favTabBtn.AutoButtonColor = false
    favTabBtn.ZIndex = 7
    Instance.new("UICorner", favTabBtn).CornerRadius = UDim.new(0, 6)
    

    local favHeaderBtn = Instance.new("TextButton", header)
    favHeaderBtn.Size = UDim2.new(0, 22, 0, 22)
    favHeaderBtn.Position = UDim2.new(1, -30, 0.5, -11)
    favHeaderBtn.BackgroundColor3 = T.grayDeep
    favHeaderBtn.BorderSizePixel = 0
    favHeaderBtn.Text = "★"
    favHeaderBtn.TextColor3 = GOLD
    favHeaderBtn.Font = Enum.Font.GothamBold
    favHeaderBtn.TextSize = 12
    favHeaderBtn.AutoButtonColor = false
    favHeaderBtn.ZIndex = 7
    Instance.new("UICorner", favHeaderBtn).CornerRadius = UDim.new(0, 6)
    
    qualityBtn.Position = UDim2.new(1, -86, 0.5, -11)
    lyricsBtn.Position = UDim2.new(1, -58, 0.5, -11)
    queueBtn.Position = UDim2.new(1, -58, 0.5, -11)
    themeBtn.Position = UDim2.new(1, -114, 0.5, -11)
    minBtn.Position = UDim2.new(1, -142, 0.5, -11)
    
    local function bindHover(btn, color)
        btn.MouseEnter:Connect(function() TS:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = color}):Play() end)
        btn.MouseLeave:Connect(function() TS:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = T.grayDeep}):Play() end)
    end
    bindHover(themeBtn, Color3.fromRGB(50, 45, 25))
    bindHover(qualityBtn, Color3.fromRGB(50, 45, 25))
    bindHover(lyricsBtn, Color3.fromRGB(40, 40, 50))
    bindHover(queueBtn, Color3.fromRGB(40, 40, 50))
    bindHover(minBtn, T.white)
    bindHover(favHeaderBtn, Color3.fromRGB(50, 45, 25))
    bindHover(favTabBtn, RED)
    
    local function updateThemeBtn()
        themeBtn.Text = State.theme == "dark" and "☀" or "🌙"
    end
    updateThemeBtn()
    
    local function updateQualityBtn()
        qualityBtn.Text = State.quality == "320" and "HQ" or (State.quality == "192" and "MQ" or "LQ")
    end
    updateQualityBtn()
    
    
    local thumb = Instance.new("ImageLabel", panel)
    thumb.Size = UDim2.new(1, -20, 0, 90)
    thumb.Position = UDim2.new(0, 10, 0, 52)
    thumb.BackgroundColor3 = T.card
    thumb.BackgroundTransparency = 0.15
    thumb.BorderSizePixel = 0
    thumb.Image = ""
    thumb.ScaleType = Enum.ScaleType.Crop
    thumb.ZIndex = 5
    Instance.new("UICorner", thumb).CornerRadius = UDim.new(0, 10)
    _uiRefs.thumb = thumb
    
    local thumbStroke = Instance.new("UIStroke", thumb)
    thumbStroke.Color = T.grayDark
    thumbStroke.Thickness = 1
    thumbStroke.Transparency = 0.4
    
    local songName = Instance.new("TextLabel", panel)
    songName.Size = UDim2.new(1, -60, 0, 20)
    songName.Position = UDim2.new(0, 10, 0, 148)
    songName.BackgroundTransparency = 1
    songName.Text = "Ninguna canción"
    songName.TextColor3 = T.text
    songName.Font = Enum.Font.GothamBold
    songName.TextSize = 11
    songName.TextXAlignment = Enum.TextXAlignment.Left
    songName.TextTruncate = Enum.TextTruncate.AtEnd
    songName.ZIndex = 5
    _uiRefs.songName = songName
    
    local favSongBtn = Instance.new("TextButton", panel)
    favSongBtn.Size = UDim2.new(0, 30, 0, 20)
    favSongBtn.Position = UDim2.new(1, -40, 0, 148)
    favSongBtn.BackgroundTransparency = 1
    favSongBtn.Text = "☆"
    favSongBtn.TextColor3 = T.textDim
    favSongBtn.Font = Enum.Font.GothamBold
    favSongBtn.TextSize = 16
    favSongBtn.AutoButtonColor = false
    favSongBtn.ZIndex = 6
    _uiRefs.favSongBtn = favSongBtn
    
    local songAuthor = Instance.new("TextLabel", panel)
    songAuthor.Size = UDim2.new(1, -20, 0, 14)
    songAuthor.Position = UDim2.new(0, 10, 0, 168)
    songAuthor.BackgroundTransparency = 1
    songAuthor.Text = ""
    songAuthor.TextColor3 = T.textDim
    songAuthor.Font = Enum.Font.GothamMedium
    songAuthor.TextSize = 9
    songAuthor.TextXAlignment = Enum.TextXAlignment.Left
    songAuthor.TextTruncate = Enum.TextTruncate.AtEnd
    songAuthor.ZIndex = 5
    _uiRefs.songAuthor = songAuthor
    
    
    local progressContainer = Instance.new("Frame", panel)
    progressContainer.Size = UDim2.new(1, -20, 0, 14)
    progressContainer.Position = UDim2.new(0, 10, 0, 186)
    progressContainer.BackgroundTransparency = 1
    progressContainer.ZIndex = 5
    
    local progressBar = Instance.new("Frame", progressContainer)
    progressBar.Size = UDim2.new(1, 0, 0, 4)
    progressBar.Position = UDim2.new(0, 0, 0, 5)
    progressBar.BackgroundColor3 = T.grayDeep
    progressBar.BorderSizePixel = 0
    progressBar.ZIndex = 5
    Instance.new("UICorner", progressBar).CornerRadius = UDim.new(1, 0)
    
    local progressFill = Instance.new("Frame", progressBar)
    progressFill.Size = UDim2.new(0, 0, 1, 0)
    progressFill.BackgroundColor3 = T.white
    progressFill.BorderSizePixel = 0
    progressFill.ZIndex = 6
    Instance.new("UICorner", progressFill).CornerRadius = UDim.new(1, 0)
    
    local progressClick = Instance.new("TextButton", progressBar)
    progressClick.Size = UDim2.new(1, 0, 3, 0)
    progressClick.Position = UDim2.new(0, 0, -1, 0)
    progressClick.BackgroundTransparency = 1
    progressClick.Text = ""
    progressClick.ZIndex = 7
    
    local timeCurrent = Instance.new("TextLabel", progressContainer)
    timeCurrent.Size = UDim2.new(0, 40, 0, 12)
    timeCurrent.Position = UDim2.new(0, 0, 0, -4)
    timeCurrent.BackgroundTransparency = 1
    timeCurrent.Text = "0:00"
    timeCurrent.TextColor3 = T.textDim
    timeCurrent.Font = Enum.Font.GothamBold
    timeCurrent.TextSize = 8
    timeCurrent.TextXAlignment = Enum.TextXAlignment.Left
    timeCurrent.ZIndex = 6
    
    local timeTotal = Instance.new("TextLabel", progressContainer)
    timeTotal.Size = UDim2.new(0, 40, 0, 12)
    timeTotal.Position = UDim2.new(1, -40, 0, -4)
    timeTotal.BackgroundTransparency = 1
    timeTotal.Text = "0:00"
    timeTotal.TextColor3 = T.textDim
    timeTotal.Font = Enum.Font.GothamBold
    timeTotal.TextSize = 8
    timeTotal.TextXAlignment = Enum.TextXAlignment.Right
    timeTotal.ZIndex = 6
    
    local controls = Instance.new("Frame", panel)
    controls.Size = UDim2.new(1, -20, 0, 30)
    controls.Position = UDim2.new(0, 10, 0, 204)
    controls.BackgroundTransparency = 1
    controls.ZIndex = 5
    
    local function makeBtn(parent, posX, text, size)
        local btn = Instance.new("TextButton", parent)
        btn.Size = UDim2.new(0, size or 26, 0, 26)
        btn.Position = UDim2.new(0.5, posX, 0.5, -13)
        btn.BackgroundColor3 = T.card
        btn.BackgroundTransparency = 0.15
        btn.BorderSizePixel = 0
        btn.Text = text
        btn.TextColor3 = T.text
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 12
        btn.AutoButtonColor = false
        btn.ZIndex = 6
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 7)
        local s = Instance.new("UIStroke", btn)
        s.Color = T.grayDark
        s.Thickness = 1
        s.Transparency = 0.4
        btn.MouseEnter:Connect(function()
            TS:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = T.white, BackgroundTransparency = 0}):Play()
            TS:Create(btn, TweenInfo.new(0.15), {TextColor3 = State.theme == "dark" and Color3.fromRGB(15,15,18) or Color3.fromRGB(255, 255, 255)}):Play()
        end)
        btn.MouseLeave:Connect(function()
            TS:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = T.card, BackgroundTransparency = 0.15}):Play()
            TS:Create(btn, TweenInfo.new(0.15), {TextColor3 = T.text}):Play()
        end)
        return btn
    end
    
    local shuffleBtn = makeBtn(controls, -70, "🔀", 24)
    local prevBtn = makeBtn(controls, -40, "⏮", 24)
    local playBtn = makeBtn(controls, 0, "▶", 30)
    local nextBtn = makeBtn(controls, 40, "⏭", 24)
    local loopBtn = makeBtn(controls, 70, "🔁", 24)
    
    playBtn.BackgroundColor3 = T.white
    playBtn.BackgroundTransparency = 0
    playBtn.TextColor3 = State.theme == "dark" and Color3.fromRGB(15,15,18) or Color3.fromRGB(255, 255, 255)
    
    local volumeRow = Instance.new("Frame", panel)
    volumeRow.Size = UDim2.new(1, -20, 0, 20)
    volumeRow.Position = UDim2.new(0, 10, 0, 238)
    volumeRow.BackgroundTransparency = 1
    volumeRow.ZIndex = 5
    
    local volumeIcon = Instance.new("TextLabel", volumeRow)
    volumeIcon.Size = UDim2.new(0, 20, 1, 0)
    volumeIcon.BackgroundTransparency = 1
    volumeIcon.Text = "🔊"
    volumeIcon.TextColor3 = T.textDim
    volumeIcon.Font = Enum.Font.GothamBold
    volumeIcon.TextSize = 12
    volumeIcon.ZIndex = 6
    
    local volumeBar = Instance.new("Frame", volumeRow)
    volumeBar.Size = UDim2.new(1, -28, 0, 4)
    volumeBar.Position = UDim2.new(0, 24, 0.5, -2)
    volumeBar.BackgroundColor3 = T.grayDeep
    volumeBar.BorderSizePixel = 0
    volumeBar.ZIndex = 5
    Instance.new("UICorner", volumeBar).CornerRadius = UDim.new(1, 0)
    
    local volumeFill = Instance.new("Frame", volumeBar)
    volumeFill.Size = UDim2.new(State.volume, 0, 1, 0)
    volumeFill.BackgroundColor3 = T.white
    volumeFill.BorderSizePixel = 0
    volumeFill.ZIndex = 6
    Instance.new("UICorner", volumeFill).CornerRadius = UDim.new(1, 0)
    
    local volumeClick = Instance.new("TextButton", volumeBar)
    volumeClick.Size = UDim2.new(1, 0, 3, 0)
    volumeClick.Position = UDim2.new(0, 0, -1, 0)
    volumeClick.BackgroundTransparency = 1
    volumeClick.Text = ""
    volumeClick.ZIndex = 7
    
    local searchBox = Instance.new("TextBox", panel)
    searchBox.Size = UDim2.new(1, -20, 0, 28)
    searchBox.Position = UDim2.new(0, 10, 0, 266)
    searchBox.BackgroundColor3 = T.card
    searchBox.BackgroundTransparency = 0.15
    searchBox.BorderSizePixel = 0
    searchBox.Text = ""
    searchBox.PlaceholderText = "Buscar en YouTube... (Enter)"
    searchBox.TextColor3 = T.text
    searchBox.PlaceholderColor3 = T.textDim
    searchBox.Font = Enum.Font.GothamMedium
    searchBox.TextSize = 11
    searchBox.ClearTextOnFocus = false
    searchBox.ZIndex = 5
    Instance.new("UICorner", searchBox).CornerRadius = UDim.new(0, 8)
    _uiRefs.searchBox = searchBox
    
    local searchStroke = Instance.new("UIStroke", searchBox)
    searchStroke.Color = T.grayDark
    searchStroke.Thickness = 1
    searchStroke.Transparency = 0.5
    
    searchBox.Focused:Connect(function() TS:Create(searchStroke, TweenInfo.new(0.15), {Color = T.white, Transparency = 0}):Play() end)
    searchBox.FocusLost:Connect(function() TS:Create(searchStroke, TweenInfo.new(0.15), {Color = T.grayDark, Transparency = 0.5}):Play() end)
    
    local listTitle = Instance.new("TextLabel", panel)
    listTitle.Size = UDim2.new(1, -20, 0, 12)
    listTitle.Position = UDim2.new(0, 10, 0, 298)
    listTitle.BackgroundTransparency = 1
    listTitle.Text = "RESULTADOS"
    listTitle.TextColor3 = T.textDim
    listTitle.Font = Enum.Font.GothamBold
    listTitle.TextSize = 8
    listTitle.TextXAlignment = Enum.TextXAlignment.Left
    listTitle.ZIndex = 5
    _uiRefs.listTitle = listTitle
    
    local results = Instance.new("ScrollingFrame", panel)
    results.Size = UDim2.new(1, -20, 1, -336)
    results.Position = UDim2.new(0, 10, 0, 314)
    results.BackgroundTransparency = 1
    results.BorderSizePixel = 0
    results.ScrollBarThickness = 2
    results.ScrollBarImageColor3 = T.white
    results.ScrollBarImageTransparency = 0.5
    results.CanvasSize = UDim2.new(0, 0, 0, 0)
    results.AutomaticCanvasSize = Enum.AutomaticSize.Y
    results.ZIndex = 5
    _uiRefs.results = results
    
    local rLayout = Instance.new("UIListLayout", results)
    rLayout.SortOrder = Enum.SortOrder.LayoutOrder
    rLayout.Padding = UDim.new(0, 4)
    
    local status = Instance.new("TextLabel", panel)
    status.Size = UDim2.new(1, -20, 0, 12)
    status.Position = UDim2.new(0, 10, 1, -18)
    status.BackgroundTransparency = 1
    status.Text = "Listo"
    status.TextColor3 = T.textDim
    status.Font = Enum.Font.GothamMedium
    status.TextSize = 8
    status.TextXAlignment = Enum.TextXAlignment.Left
    status.ZIndex = 5
    _uiRefs.status = status
    
    local function setStatus(text) status.Text = text end
    _uiRefs.setStatus = setStatus
    

    local lyricsPanel = Instance.new("Frame", panel)
    lyricsPanel.Size = UDim2.new(1, 0, 0, 0)
    lyricsPanel.Position = UDim2.new(0, 0, 0, 44)
    lyricsPanel.BackgroundColor3 = State.theme == "dark" and Color3.fromRGB(15, 15, 19) or Color3.fromRGB(245, 245, 250)
    lyricsPanel.BackgroundTransparency = 0.05
    lyricsPanel.BorderSizePixel = 0
    lyricsPanel.ClipsDescendants = true
    lyricsPanel.Visible = false
    lyricsPanel.ZIndex = 20
    _uiRefs.lyricsPanel = lyricsPanel
    
    local lyricsScroll = Instance.new("ScrollingFrame", lyricsPanel)
    lyricsScroll.Size = UDim2.new(1, -20, 1, -40)
    lyricsScroll.Position = UDim2.new(0, 10, 0, 10)
    lyricsScroll.BackgroundTransparency = 1
    lyricsScroll.BorderSizePixel = 0
    lyricsScroll.ScrollBarThickness = 2
    lyricsScroll.ScrollBarImageColor3 = T.white
    lyricsScroll.ScrollBarImageTransparency = 0.5
    lyricsScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    lyricsScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    lyricsScroll.ZIndex = 21
    _uiRefs.lyricsScroll = lyricsScroll
    
    local lyricsText = Instance.new("TextLabel", lyricsScroll)
    lyricsText.Size = UDim2.new(1, -4, 0, 0)
    lyricsText.Position = UDim2.new(0, 2, 0, 0)
    lyricsText.BackgroundTransparency = 1
    lyricsText.Text = ""
    lyricsText.TextColor3 = T.text
    lyricsText.Font = Enum.Font.GothamMedium
    lyricsText.TextSize = 11
    lyricsText.TextWrapped = true
    lyricsText.TextXAlignment = Enum.TextXAlignment.Center
    lyricsText.TextYAlignment = Enum.TextYAlignment.Top
    lyricsText.AutomaticSize = Enum.AutomaticSize.Y
    lyricsText.ZIndex = 22
    _uiRefs.lyricsText = lyricsText
    
    local lyricsClose = Instance.new("TextButton", lyricsPanel)
    lyricsClose.Size = UDim2.new(0, 60, 0, 20)
    lyricsClose.Position = UDim2.new(0.5, -30, 1, -26)
    lyricsClose.BackgroundColor3 = T.card
    lyricsClose.BorderSizePixel = 0
    lyricsClose.Text = "CERRAR"
    lyricsClose.TextColor3 = T.text
    lyricsClose.Font = Enum.Font.GothamBold
    lyricsClose.TextSize = 8
    lyricsClose.AutoButtonColor = false
    lyricsClose.ZIndex = 22
    Instance.new("UICorner", lyricsClose).CornerRadius = UDim.new(0, 6)
    
    local queuePanel = Instance.new("Frame", panel)
    queuePanel.Size = UDim2.new(1, 0, 0, 0)
    queuePanel.Position = UDim2.new(0, 0, 0, 44)
    queuePanel.BackgroundColor3 = State.theme == "dark" and Color3.fromRGB(15, 15, 19) or Color3.fromRGB(245, 245, 250)
    queuePanel.BackgroundTransparency = 0.05
    queuePanel.BorderSizePixel = 0
    queuePanel.ClipsDescendants = true
    queuePanel.Visible = false
    queuePanel.ZIndex = 20
    _uiRefs.queuePanel = queuePanel
    
    local queueTitle = Instance.new("TextLabel", queuePanel)
    queueTitle.Size = UDim2.new(1, -20, 0, 20)
    queueTitle.Position = UDim2.new(0, 10, 0, 6)
    queueTitle.BackgroundTransparency = 1
    queueTitle.Text = "COLA DE REPRODUCCIÓN"
    queueTitle.TextColor3 = T.textDim
    queueTitle.Font = Enum.Font.GothamBold
    queueTitle.TextSize = 9
    queueTitle.TextXAlignment = Enum.TextXAlignment.Left
    queueTitle.ZIndex = 21
    
    local queueClear = Instance.new("TextButton", queuePanel)
    queueClear.Size = UDim2.new(0, 50, 0, 16)
    queueClear.Position = UDim2.new(1, -60, 0, 8)
    queueClear.BackgroundColor3 = T.card
    queueClear.BorderSizePixel = 0
    queueClear.Text = "LIMPIAR"
    queueClear.TextColor3 = RED
    queueClear.Font = Enum.Font.GothamBold
    queueClear.TextSize = 7
    queueClear.AutoButtonColor = false
    queueClear.ZIndex = 21
    Instance.new("UICorner", queueClear).CornerRadius = UDim.new(0, 5)
    
    local queueScroll = Instance.new("ScrollingFrame", queuePanel)
    queueScroll.Size = UDim2.new(1, -20, 1, -50)
    queueScroll.Position = UDim2.new(0, 10, 0, 28)
    queueScroll.BackgroundTransparency = 1
    queueScroll.BorderSizePixel = 0
    queueScroll.ScrollBarThickness = 2
    queueScroll.ScrollBarImageColor3 = T.white
    queueScroll.ScrollBarImageTransparency = 0.5
    queueScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    queueScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    queueScroll.ZIndex = 21
    _uiRefs.queueScroll = queueScroll
    
    local queueLayout = Instance.new("UIListLayout", queueScroll)
    queueLayout.SortOrder = Enum.SortOrder.LayoutOrder
    queueLayout.Padding = UDim.new(0, 4)
    
    local queueClose = Instance.new("TextButton", queuePanel)
    queueClose.Size = UDim2.new(0, 60, 0, 20)
    queueClose.Position = UDim2.new(0.5, -30, 1, -26)
    queueClose.BackgroundColor3 = T.card
    queueClose.BorderSizePixel = 0
    queueClose.Text = "CERRAR"
    queueClose.TextColor3 = T.text
    queueClose.Font = Enum.Font.GothamBold
    queueClose.TextSize = 8
    queueClose.AutoButtonColor = false
    queueClose.ZIndex = 22
    Instance.new("UICorner", queueClose).CornerRadius = UDim.new(0, 6)

    local function buildMiniPlayer()
        if _miniGui and _miniGui.Parent then return end
        
        local mGui = Instance.new("ScreenGui")
        mGui.Name = "NorthMusicMini"
        mGui.ResetOnSpawn = false
        mGui.IgnoreGuiInset = false
        mGui.DisplayOrder = 91
        mGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        pcall(function() if syn and syn.protect_gui then syn.protect_gui(mGui) end end)
        local mParented = false
        pcall(function() mGui.Parent = CoreGui; mParented = (mGui.Parent ~= nil) end)
        if not mParented then pcall(function() mGui.Parent = PGUI end) end
        if not mGui.Parent then return end
        _miniGui = mGui
        
        local mini = Instance.new("Frame", mGui)
        mini.AnchorPoint = Vector2.new(1, 1)
        mini.Position = UDim2.new(1, -20, 1, -20)
        mini.Size = UDim2.new(0, 260, 0, 60)
        mini.BackgroundColor3 = T.bg
        mini.BorderSizePixel = 0
        mini.Active = true
        mini.ClipsDescendants = true
        mini.ZIndex = 1
        Instance.new("UICorner", mini).CornerRadius = UDim.new(0, 12)
        _miniPanel = mini
        
        local bgImg = Instance.new("ImageLabel", mini)
        bgImg.Size = UDim2.new(1, 0, 1, 0)
        bgImg.BackgroundColor3 = T.bg
        bgImg.BorderSizePixel = 0
        bgImg.Image = "rbxassetid://" .. BACKGROUND_ID
        bgImg.ImageTransparency = 0
        bgImg.ScaleType = Enum.ScaleType.Crop
        bgImg.ZIndex = 1
        Instance.new("UICorner", bgImg).CornerRadius = UDim.new(0, 12)
        
        local mOverlay = Instance.new("Frame", mini)
        mOverlay.Size = UDim2.new(1, 0, 1, 0)
        mOverlay.BackgroundColor3 = State.theme == "dark" and Color3.fromRGB(0, 0, 0) or Color3.fromRGB(255, 255, 255)
        mOverlay.BackgroundTransparency = T.overlay
        mOverlay.BorderSizePixel = 0
        mOverlay.ZIndex = 2
        Instance.new("UICorner", mOverlay).CornerRadius = UDim.new(0, 12)
        
        local mStroke = Instance.new("UIStroke", mini)
        mStroke.Color = T.grayDark
        mStroke.Thickness = 1.2
        mStroke.Transparency = 0.3
        mStroke.ZIndex = 10
        
        local mThumb = Instance.new("ImageLabel", mini)
        mThumb.Size = UDim2.new(0, 48, 0, 48)
        mThumb.Position = UDim2.new(0, 6, 0.5, -24)
        mThumb.BackgroundColor3 = T.card
        mThumb.BorderSizePixel = 0
        mThumb.Image = ""
        mThumb.ScaleType = Enum.ScaleType.Crop
        mThumb.ZIndex = 3
        Instance.new("UICorner", mThumb).CornerRadius = UDim.new(0, 8)
        
        local mName = Instance.new("TextLabel", mini)
        mName.Size = UDim2.new(1, -140, 0, 14)
        mName.Position = UDim2.new(0, 60, 0, 8)
        mName.BackgroundTransparency = 1
        mName.Text = "Sin música"
        mName.TextColor3 = T.text
        mName.Font = Enum.Font.GothamBold
        mName.TextSize = 10
        mName.TextXAlignment = Enum.TextXAlignment.Left
        mName.TextTruncate = Enum.TextTruncate.AtEnd
        mName.ZIndex = 3
        
        local mAuthor = Instance.new("TextLabel", mini)
        mAuthor.Size = UDim2.new(1, -140, 0, 10)
        mAuthor.Position = UDim2.new(0, 60, 0, 22)
        mAuthor.BackgroundTransparency = 1
        mAuthor.Text = ""
        mAuthor.TextColor3 = T.textDim
        mAuthor.Font = Enum.Font.GothamMedium
        mAuthor.TextSize = 8
        mAuthor.TextXAlignment = Enum.TextXAlignment.Left
        mAuthor.TextTruncate = Enum.TextTruncate.AtEnd
        mAuthor.ZIndex = 3
        
                local mByLabel = Instance.new("TextLabel", mini)
        mByLabel.Size = UDim2.new(1, -140, 0, 8)
        mByLabel.Position = UDim2.new(1, -140, 0, 50)
        mByLabel.BackgroundTransparency = 1
        mByLabel.Text = "OPP!"
        mByLabel.TextColor3 = T.textDim
        mByLabel.Font = Enum.Font.GothamMedium
        mByLabel.TextSize = 7
        mByLabel.TextXAlignment = Enum.TextXAlignment.Right
        mByLabel.ZIndex = 3
        
        local mProgress = Instance.new("Frame", mini)
        mProgress.Size = UDim2.new(1, -140, 0, 3)
        mProgress.Position = UDim2.new(0, 60, 0, 38)
        mProgress.BackgroundColor3 = T.grayDeep
        mProgress.BorderSizePixel = 0
        mProgress.ZIndex = 3
        Instance.new("UICorner", mProgress).CornerRadius = UDim.new(1, 0)
        
        local mProgressFill = Instance.new("Frame", mProgress)
        mProgressFill.Size = UDim2.new(0, 0, 1, 0)
        mProgressFill.BackgroundColor3 = T.white
        mProgressFill.BorderSizePixel = 0
        mProgressFill.ZIndex = 4
        Instance.new("UICorner", mProgressFill).CornerRadius = UDim.new(1, 0)
        
        local mPrevBtn = Instance.new("TextButton", mini)
        mPrevBtn.Size = UDim2.new(0, 22, 0, 22)
        mPrevBtn.Position = UDim2.new(1, -84, 0.5, -11)
        mPrevBtn.BackgroundColor3 = T.card
        mPrevBtn.BackgroundTransparency = 0.15
        mPrevBtn.BorderSizePixel = 0
        mPrevBtn.Text = "⏮"
        mPrevBtn.TextColor3 = T.text
        mPrevBtn.Font = Enum.Font.GothamBold
        mPrevBtn.TextSize = 10
        mPrevBtn.AutoButtonColor = false
        mPrevBtn.ZIndex = 4
        Instance.new("UICorner", mPrevBtn).CornerRadius = UDim.new(0, 6)
        
        local mPlayBtn = Instance.new("TextButton", mini)
        mPlayBtn.Size = UDim2.new(0, 22, 0, 22)
        mPlayBtn.Position = UDim2.new(1, -60, 0.5, -11)
        mPlayBtn.BackgroundColor3 = T.card
        mPlayBtn.BackgroundTransparency = 0.15
        mPlayBtn.BorderSizePixel = 0
        mPlayBtn.Text = "▶"
        mPlayBtn.TextColor3 = T.text
        mPlayBtn.Font = Enum.Font.GothamBold
        mPlayBtn.TextSize = 10
        mPlayBtn.AutoButtonColor = false
        mPlayBtn.ZIndex = 4
        Instance.new("UICorner", mPlayBtn).CornerRadius = UDim.new(0, 6)
        
        local mNextBtn = Instance.new("TextButton", mini)
        mNextBtn.Size = UDim2.new(0, 22, 0, 22)
        mNextBtn.Position = UDim2.new(1, -36, 0.5, -11)
        mNextBtn.BackgroundColor3 = T.card
        mNextBtn.BackgroundTransparency = 0.15
        mNextBtn.BorderSizePixel = 0
        mNextBtn.Text = "⏭"
        mNextBtn.TextColor3 = T.text
        mNextBtn.Font = Enum.Font.GothamBold
        mNextBtn.TextSize = 10
        mNextBtn.AutoButtonColor = false
        mNextBtn.ZIndex = 4
        Instance.new("UICorner", mNextBtn).CornerRadius = UDim.new(0, 6)
        
        local mOpenBtn = Instance.new("TextButton", mini)
        mOpenBtn.Size = UDim2.new(0, 22, 0, 22)
        mOpenBtn.Position = UDim2.new(1, -12, 0.5, -11)
        mOpenBtn.BackgroundColor3 = T.card
        mOpenBtn.BackgroundTransparency = 0.15
        mOpenBtn.BorderSizePixel = 0
        mOpenBtn.Text = "▲"
        mOpenBtn.TextColor3 = T.text
        mOpenBtn.Font = Enum.Font.GothamBold
        mOpenBtn.TextSize = 9
        mOpenBtn.AutoButtonColor = false
        mOpenBtn.ZIndex = 4
        Instance.new("UICorner", mOpenBtn).CornerRadius = UDim.new(0, 6)
        
        local mDrag = false
        local mDragStart, mStartPos
        mini.InputBegan:Connect(function(inp)
            if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
                mDrag = true; mDragStart = inp.Position; mStartPos = mini.Position
            end
        end)
        mini.InputChanged:Connect(function(inp)
            if mDrag and (inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch) then
                local d = inp.Position - mDragStart
                mini.Position = UDim2.new(mStartPos.X.Scale, mStartPos.X.Offset + d.X, mStartPos.Y.Scale, mStartPos.Y.Offset + d.Y)
            end
        end)
        UIS.InputEnded:Connect(function(inp)
            if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
                mDrag = false
            end
        end)
        
        trackMini(mPlayBtn.MouseButton1Click:Connect(function()
            if not sound.SoundId or sound.SoundId == "" then return end
            if sound.Playing then
                sound:Pause(); mPlayBtn.Text = "▶"; State.playing = false
            else
                sound:Resume(); mPlayBtn.Text = "⏸"; State.playing = true
            end
        end))
        
        trackMini(mPrevBtn.MouseButton1Click:Connect(function()
            if #_searchCache == 0 then return end
            local idx = 1
            for i, info in ipairs(_searchCache) do
                if info.id == State.currentId then idx = i; break end
            end
            local newIdx = idx - 1
            if newIdx < 1 then newIdx = #_searchCache end
            local info = _searchCache[newIdx]
            if info then _G.__NorthPlaySong(info.id, info) end
        end))
        
        trackMini(mNextBtn.MouseButton1Click:Connect(function()
            if #_searchCache == 0 then return end
            local idx = 1
            for i, info in ipairs(_searchCache) do
                if info.id == State.currentId then idx = i; break end
            end
            local newIdx = idx + 1
            if newIdx > #_searchCache then newIdx = 1 end
            local info = _searchCache[newIdx]
            if info then _G.__NorthPlaySong(info.id, info) end
        end))
        
        trackMini(mOpenBtn.MouseButton1Click:Connect(function()
            TS:Create(mini, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                Size = UDim2.new(0, 10, 0, 10), BackgroundTransparency = 1,
            }):Play()
            task.wait(0.25)
            cleanupMini()
            if not _gui or not _gui.Parent then
                _G.NorthOpenMusic()
            else
                _mainPanel.Visible = true
                _mainPanel.Size = UDim2.new(0, 10, 0, 10)
                TS:Create(_mainPanel, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                    Size = UDim2.new(0, 320, 0, 480),
                }):Play()
            end
        end))
        
        trackMini(task.spawn(function()
            while _miniGui and _miniGui.Parent do
                if sound.SoundId and sound.SoundId ~= "" and sound.TimeLength > 0 then
                    mProgressFill.Size = UDim2.new(sound.TimePosition / sound.TimeLength, 0, 1, 0)
                    mPlayBtn.Text = sound.Playing and "⏸" or "▶"
                end
                mName.Text = State.currentInfo and State.currentInfo.name or "Sin música"
                mAuthor.Text = State.currentInfo and State.currentInfo.author or ""
                if State.currentId then
                    local t = getThumbnail(State.currentId)
                    if t then mThumb.Image = t end
                end
                task.wait(0.3)
            end
        end))
    end

    local function updateFavSongBtn()
        if State.currentId and isFavorite(State.currentId) then
            favSongBtn.Text = "★"
            favSongBtn.TextColor3 = GOLD
        else
            favSongBtn.Text = "☆"
            favSongBtn.TextColor3 = T.textDim
        end
    end
    
    local function updatePlayBtn()
        playBtn.Text = State.playing and "⏸" or "▶"
    end
    
    local function updateQueue()
        for _, c in ipairs(queueScroll:GetChildren()) do
            if c:IsA("Frame") then c:Destroy() end
        end
        
        for i, info in ipairs(State.queue) do
            local isCurrent = (info.id == State.currentId)
            local card = Instance.new("Frame", queueScroll)
            card.Size = UDim2.new(1, -4, 0, 32)
            card.BackgroundColor3 = isCurrent and T.cardHover or T.card
            card.BackgroundTransparency = isCurrent and 0 or 0.2
            card.BorderSizePixel = 0
            card.LayoutOrder = i
            card.ZIndex = 22
            Instance.new("UICorner", card).CornerRadius = UDim.new(0, 6)
            
            local num = Instance.new("TextLabel", card)
            num.Size = UDim2.new(0, 20, 1, 0)
            num.Position = UDim2.new(0, 6, 0, 0)
            num.BackgroundTransparency = 1
            num.Text = tostring(i)
            num.TextColor3 = isCurrent and GOLD or T.textDim
            num.Font = Enum.Font.GothamBold
            num.TextSize = 9
            num.ZIndex = 23
            
            local name = Instance.new("TextLabel", card)
            name.Size = UDim2.new(1, -80, 1, 0)
            name.Position = UDim2.new(0, 30, 0, 0)
            name.BackgroundTransparency = 1
            name.Text = info.name or "Unknown"
            name.TextColor3 = isCurrent and GOLD or T.text
            name.Font = Enum.Font.GothamBold
            name.TextSize = 9
            name.TextXAlignment = Enum.TextXAlignment.Left
            name.TextTruncate = Enum.TextTruncate.AtEnd
            name.ZIndex = 23
            
            local playBtn2 = Instance.new("TextButton", card)
            playBtn2.Size = UDim2.new(0, 22, 0, 22)
            playBtn2.Position = UDim2.new(1, -52, 0.5, -11)
            playBtn2.BackgroundColor3 = T.card
            playBtn2.BorderSizePixel = 0
            playBtn2.Text = "▶"
            playBtn2.TextColor3 = T.text
            playBtn2.Font = Enum.Font.GothamBold
            playBtn2.TextSize = 9
            playBtn2.AutoButtonColor = false
            playBtn2.ZIndex = 24
            Instance.new("UICorner", playBtn2).CornerRadius = UDim.new(0, 5)
            
            local removeBtn = Instance.new("TextButton", card)
            removeBtn.Size = UDim2.new(0, 22, 0, 22)
            removeBtn.Position = UDim2.new(1, -28, 0.5, -11)
            removeBtn.BackgroundColor3 = T.card
            removeBtn.BorderSizePixel = 0
            removeBtn.Text = "×"
            removeBtn.TextColor3 = RED
            removeBtn.Font = Enum.Font.GothamBold
            removeBtn.TextSize = 11
            removeBtn.AutoButtonColor = false
            removeBtn.ZIndex = 24
            Instance.new("UICorner", removeBtn).CornerRadius = UDim.new(0, 5)
            
            playBtn2.MouseButton1Click:Connect(function()
                _G.__NorthPlaySong(info.id, info)
            end)
            removeBtn.MouseButton1Click:Connect(function()
                table.remove(State.queue, i)
                updateQueue()
            end)
        end
    end
    _uiRefs.updateQueue = updateQueue
    
    local function addToQueue(info)
        table.insert(State.queue, info)
        setStatus("Añadido a cola: " .. (info.name or ""))
        updateQueue()
    end
  
    local function playSong(videoId, info)
        setStatus("Cargando thumbnail...")
        songName.Text = info.name or "..."
        songAuthor.Text = info.author or ""
        State.currentId = videoId
        State.currentInfo = info
        updateFavSongBtn()
        
        task.spawn(function()
            local thumbAsset = getThumbnail(videoId)
            if thumbAsset and thumb.Parent then thumb.Image = thumbAsset end
            
            local path = MUSIC_FOLDER .. "/" .. videoId .. ".mp3"
            local songAsset = nil
            
            if isfile(path) then
                setStatus("Cargando caché...")
                local ok, asset = pcall(getcustomasset, path)
                if ok then songAsset = asset end
            end
            
            if not songAsset then
                local audio, err = downloadAudio(videoId, function(msg, prog)
                    setStatus(msg)
                    if prog then progressFill.Size = UDim2.new(prog/100, 0, 1, 0) end
                end)
                
                if not audio then
                    setStatus("Error: " .. tostring(err))
                    progressFill.Size = UDim2.new(0, 0, 1, 0)
                    return
                end
                
                local okW = pcall(function() writefile(path, audio) end)
                if not okW then setStatus("Error guardando"); return end
                
                local ok, asset = pcall(getcustomasset, path)
                if not ok then setStatus("Error asset"); return end
                songAsset = asset
            end
            
            playWithCrossfade(songAsset)
            
            State.playing = true
            updatePlayBtn()
            progressFill.Size = UDim2.new(0, 0, 1, 0)
            setStatus("Reproduciendo")
            
            if State.showLyrics and info.name then
                setStatus("Buscando letras...")
                local lyrics = getLyrics(info.author or "", info.name or "")
                if lyrics then
                    State.currentLyrics = lyrics
                    lyricsText.Text = lyrics
                    setStatus("Letras cargadas")
                else
                    lyricsText.Text = "No se encontraron letras para esta canción."
                    setStatus("Sin letras")
                end
            end
        end)
    end
    _G.__NorthPlaySong = playSong
    
    local function makeResultCard(info, order)
        local card = Instance.new("Frame", results)
        card.Size = UDim2.new(1, -4, 0, 50)
        card.BackgroundColor3 = T.card
        card.BackgroundTransparency = 0.15
        card.BorderSizePixel = 0
        card.LayoutOrder = order
        card.ZIndex = 5
        Instance.new("UICorner", card).CornerRadius = UDim.new(0, 8)
        
        local cardStroke = Instance.new("UIStroke", card)
        cardStroke.Color = T.grayDark
        cardStroke.Thickness = 1
        cardStroke.Transparency = 0.5
        
        local cardThumb = Instance.new("ImageLabel", card)
        cardThumb.Size = UDim2.new(0, 68, 0, 40)
        cardThumb.Position = UDim2.new(0, 5, 0.5, -20)
        cardThumb.BackgroundColor3 = T.grayDeep
        cardThumb.BorderSizePixel = 0
        cardThumb.Image = ""
        cardThumb.ScaleType = Enum.ScaleType.Crop
        cardThumb.ZIndex = 6
        Instance.new("UICorner", cardThumb).CornerRadius = UDim.new(0, 6)
        
        task.spawn(function()
            local t = getThumbnail(info.id)
            if t and card.Parent then cardThumb.Image = t end
        end)
        
        local cardName = Instance.new("TextLabel", card)
        cardName.Size = UDim2.new(1, -140, 0, 16)
        cardName.Position = UDim2.new(0, 78, 0, 8)
        cardName.BackgroundTransparency = 1
        cardName.Text = info.name or "Unknown"
        cardName.TextColor3 = T.text
        cardName.Font = Enum.Font.GothamBold
        cardName.TextSize = 10
        cardName.TextXAlignment = Enum.TextXAlignment.Left
        cardName.TextTruncate = Enum.TextTruncate.AtEnd
        cardName.ZIndex = 6
        
        local cardAuthor = Instance.new("TextLabel", card)
        cardAuthor.Size = UDim2.new(1, -140, 0, 12)
        cardAuthor.Position = UDim2.new(0, 78, 0, 26)
        cardAuthor.BackgroundTransparency = 1
        cardAuthor.Text = info.author or ""
        cardAuthor.TextColor3 = T.textDim
        cardAuthor.Font = Enum.Font.GothamMedium
        cardAuthor.TextSize = 8
        cardAuthor.TextXAlignment = Enum.TextXAlignment.Left
        cardAuthor.TextTruncate = Enum.TextTruncate.AtEnd
        cardAuthor.ZIndex = 6
        
        local cardAddQueue = Instance.new("TextButton", card)
        cardAddQueue.Size = UDim2.new(0, 22, 0, 22)
        cardAddQueue.Position = UDim2.new(1, -52, 0.5, -11)
        cardAddQueue.BackgroundColor3 = T.card
        cardAddQueue.BackgroundTransparency = 0.3
        cardAddQueue.BorderSizePixel = 0
        cardAddQueue.Text = "+"
        cardAddQueue.TextColor3 = T.text
        cardAddQueue.Font = Enum.Font.GothamBold
        cardAddQueue.TextSize = 12
        cardAddQueue.AutoButtonColor = false
        cardAddQueue.ZIndex = 8
        Instance.new("UICorner", cardAddQueue).CornerRadius = UDim.new(0, 5)
        
        cardAddQueue.MouseButton1Click:Connect(function()
            addToQueue(info)
        end)
        
        local cardFavBtn = Instance.new("TextButton", card)
        cardFavBtn.Size = UDim2.new(0, 22, 0, 22)
        cardFavBtn.Position = UDim2.new(1, -28, 0.5, -11)
        cardFavBtn.BackgroundColor3 = T.card
        cardFavBtn.BackgroundTransparency = 0.3
        cardFavBtn.BorderSizePixel = 0
        cardFavBtn.Text = isFavorite(info.id) and "★" or "☆"
        cardFavBtn.TextColor3 = isFavorite(info.id) and GOLD or T.textDim
        cardFavBtn.Font = Enum.Font.GothamBold
        cardFavBtn.TextSize = 13
        cardFavBtn.AutoButtonColor = false
        cardFavBtn.ZIndex = 8
        Instance.new("UICorner", cardFavBtn).CornerRadius = UDim.new(0, 5)
        
        cardFavBtn.MouseButton1Click:Connect(function()
            local nowFav = toggleFavorite(info.id)
            cardFavBtn.Text = nowFav and "★" or "☆"
            cardFavBtn.TextColor3 = nowFav and GOLD or T.textDim
            if State.currentId == info.id then updateFavSongBtn() end
            setStatus(nowFav and "★ Añadido" or "☆ Eliminado")
        end)
        
        local click = Instance.new("TextButton", card)
        click.Size = UDim2.new(1, -56, 1, 0)
        click.BackgroundTransparency = 1
        click.Text = ""
        click.AutoButtonColor = false
        click.ZIndex = 7
        
        click.MouseEnter:Connect(function()
            TS:Create(card, TweenInfo.new(0.15), {BackgroundColor3 = T.cardHover, BackgroundTransparency = 0}):Play()
            TS:Create(cardStroke, TweenInfo.new(0.15), {Color = T.white, Transparency = 0.3}):Play()
        end)
        click.MouseLeave:Connect(function()
            TS:Create(card, TweenInfo.new(0.15), {BackgroundColor3 = T.card, BackgroundTransparency = 0.15}):Play()
            TS:Create(cardStroke, TweenInfo.new(0.15), {Color = T.grayDark, Transparency = 0.5}):Play()
        end)
        
        click.MouseButton1Click:Connect(function()
            playSong(info.id, info)
        end)
    end
    
    local function clearResults()
        for _, c in ipairs(results:GetChildren()) do
            if c:IsA("Frame") then c:Destroy() end
        end
    end
    _uiRefs.clearResults = clearResults
    
    local function doSearch()
        local query = searchBox.Text
        if not query or query == "" then return end
        
        clearResults()
        State.showingFavs = false
        listTitle.Text = "RESULTADOS"
        setStatus("Buscando...")
        
        task.spawn(function()
            local res = searchYouTube(query)
            _searchCache = res
            State.lastSearchResults = res
            
            if #res == 0 then setStatus("Sin resultados"); return end
            setStatus(#res .. " resultados")
            for i, info in ipairs(res) do
                if info.id and info.name then makeResultCard(info, i) end
            end
        end)
    end
    _uiRefs.doSearch = doSearch
    
    local function showFavorites()
        clearResults()
        State.showingFavs = true
        listTitle.Text = "FAVORITOS (" .. #State.favorites .. ")"
        setStatus("Cargando favoritos...")
        
        task.spawn(function()
            local total = #State.favorites
            if total == 0 then setStatus("Sin favoritos"); return end
            for i, videoId in ipairs(State.favorites) do
                if not _gui or not _gui.Parent then return end
                local cached = nil
                for _, info in ipairs(_searchCache) do
                    if info.id == videoId then cached = info; break end
                end
                local info = cached or getVideoInfo(videoId) or {id = videoId, name = videoId, author = ""}
                makeResultCard(info, i)
            end
            setStatus(total .. " favoritos")
        end)
    end
    _uiRefs.showFavorites = showFavorites
    
    
    searchBox.FocusLost:Connect(function(enterPressed)
        if enterPressed then doSearch() end
    end)
    
    playBtn.MouseButton1Click:Connect(function()
        if not sound.SoundId or sound.SoundId == "" then return end
        if sound.Playing then
            sound:Pause(); State.playing = false; setStatus("Pausado")
        else
            sound:Resume(); State.playing = true; setStatus("Reproduciendo")
        end
        updatePlayBtn()
    end)
    
    prevBtn.MouseButton1Click:Connect(function()
        if #_searchCache == 0 then return end
        local idx = 1
        for i, info in ipairs(_searchCache) do
            if info.id == State.currentId then idx = i; break end
        end
        local newIdx = idx - 1
        if newIdx < 1 then newIdx = #_searchCache end
        local info = _searchCache[newIdx]
        if info then playSong(info.id, info) end
    end)
    
    nextBtn.MouseButton1Click:Connect(function()
        if #_searchCache == 0 then return end
        local idx = 1
        for i, info in ipairs(_searchCache) do
            if info.id == State.currentId then idx = i; break end
        end
        local newIdx = idx + 1
        if newIdx > #_searchCache then newIdx = 1 end
        local info = _searchCache[newIdx]
        if info then playSong(info.id, info) end
    end)
    
    loopBtn.MouseButton1Click:Connect(function()
        if State.loop == "off" then
            State.loop = "all"; loopBtn.Text = "🔁"; loopBtn.TextColor3 = T.white; setStatus("Loop: todo")
        elseif State.loop == "all" then
            State.loop = "one"; loopBtn.Text = "🔂"; loopBtn.TextColor3 = GOLD; setStatus("Loop: una")
        else
            State.loop = "off"; loopBtn.Text = "🔁"; loopBtn.TextColor3 = T.textDim; setStatus("Loop: off")
        end
        sound.Looped = (State.loop == "one")
        saveSettings()
    end)
    
    shuffleBtn.MouseButton1Click:Connect(function()
        State.shuffle = not State.shuffle
        shuffleBtn.TextColor3 = State.shuffle and T.white or T.textDim
        setStatus(State.shuffle and "Aleatorio: ON" or "Aleatorio: OFF")
        saveSettings()
    end)
    
    sound.Ended:Connect(function()
        if State.loop == "one" then
            sound.TimePosition = 0; sound:Play()
        elseif #State.queue > 0 then
            local nextInfo = table.remove(State.queue, 1)
            updateQueue()
            if nextInfo then playSong(nextInfo.id, nextInfo) end
        elseif State.loop == "all" and #_searchCache > 0 then
            nextBtn:Activate()
        elseif State.shuffle and #_searchCache > 0 then
            local rand = _searchCache[math.random(1, #_searchCache)]
            if rand then playSong(rand.id, rand) end
        else
            State.playing = false; updatePlayBtn(); setStatus("Terminó")
        end
    end)
    
    progressClick.MouseButton1Click:Connect(function()
        if not sound.SoundId or sound.SoundId == "" or sound.TimeLength <= 0 then return end
        local mouse = UIS:GetMouseLocation()
        local pct = math.clamp((mouse.X - progressBar.AbsolutePosition.X) / progressBar.AbsoluteSize.X, 0, 1)
        sound.TimePosition = pct * sound.TimeLength
    end)
    
    volumeClick.MouseButton1Click:Connect(function()
        local mouse = UIS:GetMouseLocation()
        local pct = math.clamp((mouse.X - volumeBar.AbsolutePosition.X) / volumeBar.AbsoluteSize.X, 0, 1)
        State.volume = pct; sound.Volume = pct
        volumeFill.Size = UDim2.new(pct, 0, 1, 0)
        saveSettings()
    end)
    
    favSongBtn.MouseButton1Click:Connect(function()
        if not State.currentId then return end
        toggleFavorite(State.currentId)
        updateFavSongBtn()
        setStatus(isFavorite(State.currentId) and "★ Añadido" or "☆ Eliminado")
    end)
    
    favHeaderBtn.MouseButton1Click:Connect(function()
        if State.showingFavs then
            State.showingFavs = false
            listTitle.Text = "RESULTADOS"
            clearResults()
            setStatus("Listo")
        else
            showFavorites()
        end
    end)
    
    themeBtn.MouseButton1Click:Connect(function()
        if State.theme == "dark" then
            State.theme = "light"
        else
            State.theme = "dark"
        end
        updateThemeBtn()
        saveSettings()
        setStatus("Tema: " .. State.theme)
        cleanup()
        _G.NorthOpenMusic()
    end)
    
    qualityBtn.MouseButton1Click:Connect(function()
        if State.quality == "320" then
            State.quality = "192"
        elseif State.quality == "192" then
            State.quality = "128"
        else
            State.quality = "320"
        end
        updateQualityBtn()
        saveSettings()
        setStatus("Calidad: " .. State.quality .. " kbps")
    end)
    
    lyricsBtn.MouseButton1Click:Connect(function()
        State.showLyrics = not State.showLyrics
        lyricsBtn.TextColor3 = State.showLyrics and GOLD or T.textDim
        if State.showLyrics then
            lyricsPanel.Visible = true
            lyricsPanel.Size = UDim2.new(1, 0, 0, 0)
            TS:Create(lyricsPanel, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {
                Size = UDim2.new(1, 0, 1, -44),
            }):Play()
            if State.currentInfo then
                setStatus("Buscando letras...")
                task.spawn(function()
                    local lyrics = getLyrics(State.currentInfo.author or "", State.currentInfo.name or "")
                    if lyrics then
                        State.currentLyrics = lyrics
                        lyricsText.Text = lyrics
                        setStatus("Letras cargadas")
                    else
                        lyricsText.Text = "No se encontraron letras para esta canción."
                        setStatus("Sin letras")
                    end
                end)
            else
                lyricsText.Text = "Reproduce una canción para ver las letras."
            end
        else
            TS:Create(lyricsPanel, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {
                Size = UDim2.new(1, 0, 0, 0),
            }):Play()
            task.delay(0.3, function() lyricsPanel.Visible = false end)
        end
    end)
    
    lyricsClose.MouseButton1Click:Connect(function()
        State.showLyrics = false
        lyricsBtn.TextColor3 = T.textDim
        TS:Create(lyricsPanel, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {
            Size = UDim2.new(1, 0, 0, 0),
        }):Play()
        task.delay(0.3, function() lyricsPanel.Visible = false end)
    end)
    
    queueBtn.MouseButton1Click:Connect(function()
        State.queueOpen = not State.queueOpen
        queueBtn.TextColor3 = State.queueOpen and GOLD or T.textDim
        if State.queueOpen then
            updateQueue()
            queuePanel.Visible = true
            queuePanel.Size = UDim2.new(1, 0, 0, 0)
            TS:Create(queuePanel, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {
                Size = UDim2.new(1, 0, 1, -44),
            }):Play()
        else
            TS:Create(queuePanel, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {
                Size = UDim2.new(1, 0, 0, 0),
            }):Play()
            task.delay(0.3, function() queuePanel.Visible = false end)
        end
    end)
    
    queueClose.MouseButton1Click:Connect(function()
        State.queueOpen = false
        queueBtn.TextColor3 = T.textDim
        TS:Create(queuePanel, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {
            Size = UDim2.new(1, 0, 0, 0),
        }):Play()
        task.delay(0.3, function() queuePanel.Visible = false end)
    end)
    
    queueClear.MouseButton1Click:Connect(function()
        State.queue = {}
        updateQueue()
        setStatus("Cola limpiada")
    end)
    
    track(task.spawn(function()
        while _gui and _gui.Parent do
            if sound.SoundId and sound.SoundId ~= "" and sound.TimeLength > 0 then
                progressFill.Size = UDim2.new(sound.TimePosition / sound.TimeLength, 0, 1, 0)
                timeCurrent.Text = formatTime(sound.TimePosition)
                timeTotal.Text = formatTime(sound.TimeLength)
            end
            task.wait(0.1)
        end
    end))
   
    local dragging = false
    local dragStart, startPos
    header.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
            dragging = true; dragStart = inp.Position; startPos = panel.Position
        end
    end)
    header.InputChanged:Connect(function(inp)
        if dragging and (inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch) then
            local d = inp.Position - dragStart
            panel.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
        end
    end)
    UIS.InputEnded:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
   
    minBtn.MouseButton1Click:Connect(function()
        TS:Create(panel, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 10, 0, 10), BackgroundTransparency = 0.4,
        }):Play()
        task.wait(0.25)
        panel.Visible = false
        buildMiniPlayer()
    end)
    
    favTabBtn.MouseButton1Click:Connect(function()
        cleanup()
        cleanupMini()
    end)
   
    if State.loop == "all" then
        loopBtn.Text = "🔁"; loopBtn.TextColor3 = T.white
    elseif State.loop == "one" then
        loopBtn.Text = "🔂"; loopBtn.TextColor3 = GOLD
    else
        loopBtn.TextColor3 = T.textDim
    end
    shuffleBtn.TextColor3 = State.shuffle and T.white or T.textDim
    volumeFill.Size = UDim2.new(State.volume, 0, 1, 0)
    lyricsBtn.TextColor3 = State.showLyrics and GOLD or T.textDim
    updateFavSongBtn()
    
    panel.Size = UDim2.new(0, 10, 0, 10)
    TS:Create(panel, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 320, 0, 480),
    }):Play()
    
    if State.currentInfo then
        songName.Text = State.currentInfo.name or "..."
        songAuthor.Text = State.currentInfo.author or ""
        updateFavSongBtn()
    end
    
    if State.lastSearchResults and #State.lastSearchResults > 0 and not State.showingFavs then
        for i, info in ipairs(State.lastSearchResults) do
            if info.id and info.name then makeResultCard(info, i) end
        end
        setStatus(#State.lastSearchResults .. " resultados")
    end
end

_G.NorthCloseMusic = function()
    cleanup()
    cleanupMini()
end

UIS.InputBegan:Connect(function(inp, gp)
    if gp then return end
    if UIS:GetFocusedTextBox() then return end
    
    if inp.KeyCode == Enum.KeyCode.M then
        if _gui and _gui.Parent then
            cleanup()
        else
            if _miniGui and _miniGui.Parent then cleanupMini() end
            _G.NorthOpenMusic()
        end
        return
    end
    
    if not (_gui and _gui.Parent) and not (_miniGui and _miniGui.Parent) then return end
    
    if inp.KeyCode == Enum.KeyCode.Space then
        if sound.SoundId and sound.SoundId ~= "" then
            if sound.Playing then
                sound:Pause(); State.playing = false
            else
                sound:Resume(); State.playing = true
            end
        end
    elseif inp.KeyCode == Enum.KeyCode.Right then
        if sound.TimeLength > 0 then
            sound.TimePosition = math.min(sound.TimePosition + 10, sound.TimeLength)
        end
    elseif inp.KeyCode == Enum.KeyCode.Left then
        if sound.TimeLength > 0 then
            sound.TimePosition = math.max(sound.TimePosition - 10, 0)
        end
    elseif inp.KeyCode == Enum.KeyCode.Up then
        State.volume = math.min(State.volume + 0.1, 1)
        sound.Volume = State.volume
        saveSettings()
    elseif inp.KeyCode == Enum.KeyCode.Down then
        State.volume = math.max(State.volume - 0.1, 0)
        sound.Volume = State.volume
        saveSettings()
    elseif inp.KeyCode == Enum.KeyCode.F then
        if State.currentId then
            toggleFavorite(State.currentId)
        end
    end
end)

end) -- pcall North Music load
if not _northMusicLoadOk then
    warn("[K7 DUELS] North Music no cargó: " .. tostring(_northMusicLoadErr))
else
    print("[K7 DUELS] North Music cargado OK")
end

-- North Music loaded; open via _G.NorthOpenMusic()

local _K7DuelsPingLaggerScreen = nil
function openK7DuelsPingLagger()
    -- Opens North Music player instead of Ping Lagger
    local ok, err = pcall(function()
        if _G.NorthOpenMusic then
            _G.NorthOpenMusic()
        else
            warn("[K7 DUELS] NorthOpenMusic not available - el modulo no cargo")
        end
    end)
    if not ok then
        warn("[K7Duels North Music] " .. tostring(err))
    end
    return nil
end

-- ========== K7 DUELS ANTI BAT (embedded) ==========
local _fearAntiBatLoadOk, _fearAntiBatLoadErr = pcall(function()
if _G.__FearAntiBatRunning then
	pcall(function()
		local pgui = game:GetService("Players").LocalPlayer:FindFirstChild("PlayerGui")
		if pgui then
			for _, n in ipairs({"K7DuelsAntiBat", "MainFrame"}) do
				local old = pgui:FindFirstChild(n)
				if old then old:Destroy() end
			end
		end
	end)
end
_G.__FearAntiBatRunning = true

function _G.FearOpenAntiBat()
	-- Destroy previous instance if any
	pcall(function()
		local LP = game:GetService("Players").LocalPlayer
		local pgui = LP and LP:FindFirstChild("PlayerGui")
		if pgui then
			for _, old in ipairs(pgui:GetChildren()) do
				if old.Name == "K7DuelsAntiBat" or old.Name == "MainFrame" or old.Name == "OrvynAntiBat"
					or old.Name == "EthernalHubAntiBat" or old.Name == "BananaHubAntiBat"
					or old.Name == "EternalHubAntiBat" or old.Name == "AntiBatFinnox"
					or old.Name == "AntiBatK7Duels" then
					old:Destroy()
				end
			end
		end
	end)
	-- Run Anti Bat GUI
	-- ============================================================
	-- K7 DUELS ANTI BAT  |  Black & Green
	-- ============================================================
	local Players = game:GetService("Players")
	local RunService = game:GetService("RunService")
	local UserInputService = game:GetService("UserInputService")
	local TweenService = game:GetService("TweenService")
	local LocalPlayer = Players.LocalPlayer

	local keybindFile = "K7DuelsAntiBat_Keybind.txt"

	local AntiBatEnabled = false
	local InfiniteJumpEnabled = false

	local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
	local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
	local Humanoid = Character:WaitForChild("Humanoid")
	local AntiBatConn = nil
	local AntiRagdollConn = nil
	local isMinimized = false

	local CurrentKeybind = Enum.KeyCode.K
	local WaitingForKeybind = false

	local function loadKeybind()
		if isfile and isfile(keybindFile) then
			local success, savedData = pcall(function()
				return readfile(keybindFile)
			end)
			if success and savedData then
				for _, enum in ipairs(Enum.KeyCode:GetEnumItems()) do
					if enum.Name == savedData then
						CurrentKeybind = enum
						break
					end
				end
			end
		end
	end

	local function saveKeybind()
		if writefile then
			pcall(function()
				writefile(keybindFile, CurrentKeybind.Name)
			end)
		end
	end

	loadKeybind()

	-- ==================== ANTI BAT CORE ====================
	local function startAntiBat()
		local char = LocalPlayer.Character
		if not char then return end
		local root = char:FindFirstChild("HumanoidRootPart")
		if not root then return end
		if AntiBatConn then AntiBatConn:Disconnect() end
		AntiBatConn = RunService.Heartbeat:Connect(function()
			if not root or not root.Parent then return end
			local origXZ = Vector3.new(root.Velocity.X, 0, root.Velocity.Z)
			root.Velocity = Vector3.new(1000, root.Velocity.Y, 1000)
			RunService.RenderStepped:Wait()
			root.Velocity = Vector3.new(origXZ.X, root.Velocity.Y, origXZ.Z)
		end)
	end

	local function stopAntiBat()
		if AntiBatConn then
			AntiBatConn:Disconnect()
			AntiBatConn = nil
		end
	end

	-- ==================== INFINITE JUMP ====================
	UserInputService.JumpRequest:Connect(function()
		if not InfiniteJumpEnabled then return end
		local char = LocalPlayer.Character
		if not char then return end
		local root = char:FindFirstChild("HumanoidRootPart")
		if root then
			root.Velocity = Vector3.new(root.Velocity.X, 55, root.Velocity.Z)
		end
	end)

	-- ==================== ANTI RAGDOLL ====================
	local function startAntiRagdoll()
		if AntiRagdollConn then return end
		AntiRagdollConn = RunService.Heartbeat:Connect(function()
			local char = LocalPlayer.Character
			if not char then return end
			local hum2 = char:FindFirstChildOfClass("Humanoid")
			local root = char:FindFirstChild("HumanoidRootPart")
			if hum2 then
				local st = hum2:GetState()
				if st == Enum.HumanoidStateType.Physics or st == Enum.HumanoidStateType.Ragdoll or st == Enum.HumanoidStateType.FallingDown then
					hum2:ChangeState(Enum.HumanoidStateType.Running)
					workspace.CurrentCamera.CameraSubject = hum2
					pcall(function()
						local pm = LocalPlayer.PlayerScripts:FindFirstChild("PlayerModule")
						if pm then require(pm:FindFirstChild("ControlModule")):Enable() end
					end)
					if root then
						root.Velocity = Vector3.new(0, 0, 0)
						root.RotVelocity = Vector3.new(0, 0, 0)
					end
				end
			end
			for _, obj in ipairs(char:GetDescendants()) do
				if obj:IsA("Motor6D") and not obj.Enabled then
					obj.Enabled = true
				end
			end
		end)
	end

	local function stopAntiRagdoll()
		if AntiRagdollConn then
			AntiRagdollConn:Disconnect()
			AntiRagdollConn = nil
		end
	end

	-- Cleanup
	pcall(function()
		for _, old in ipairs(LocalPlayer:WaitForChild("PlayerGui"):GetChildren()) do
			if old.Name == "MainFrame" or old.Name == "OrvynAntiBat" or old.Name == "EthernalHubAntiBat"
				or old.Name == "BananaHubAntiBat" or old.Name == "EternalHubAntiBat" or old.Name == "AntiBatFinnox"
				or old.Name == "AntiBatK7Duels" or old.Name == "K7DuelsAntiBat" then
				old:Destroy()
			end
		end
	end)

	-- ============================================================
	-- UI  |  Purple + White Decorated
	-- ============================================================
	local Gui = Instance.new("ScreenGui")
	Gui.Name = "K7DuelsAntiBat"
	Gui.DisplayOrder = 999999
	Gui.IgnoreGuiInset = true
	Gui.ResetOnSpawn = false
	Gui.ZIndexBehavior = Enum.ZIndexBehavior.Global
	Gui.Parent = LocalPlayer:WaitForChild("PlayerGui")

	local PW, PH = 240, 270
	local MINI_H = 50

	-- Main
	local Main = Instance.new("Frame")
	Main.Name = "MainFrame"
	Main.Active = true
	Main.BackgroundColor3 = Color3.fromRGB(18, 8, 28)
	Main.BackgroundTransparency = 0.03
	Main.BorderSizePixel = 0
	Main.ClipsDescendants = true
	Main.Position = UDim2.new(0.5, -PW/2, 0.5, -PH/2)
	Main.Size = UDim2.new(0, PW, 0, PH)
	Main.Parent = Gui

	local MainCorner = Instance.new("UICorner")
	MainCorner.CornerRadius = UDim.new(0, 16)
	MainCorner.Parent = Main

	local MainStroke = Instance.new("UIStroke")
	MainStroke.Color = Color3.fromRGB(100, 55, 130)
	MainStroke.Thickness = 2
	MainStroke.Parent = Main

	local MainGrad = Instance.new("UIGradient")
	MainGrad.Color = ColorSequence.new{
		ColorSequenceKeypoint.new(0, Color3.fromRGB(35, 18, 48)),
		ColorSequenceKeypoint.new(0.5, Color3.fromRGB(18, 8, 28)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 4, 16))
	}
	MainGrad.Rotation = 140
	MainGrad.Parent = Main

	-- Background image
	local BG = Instance.new("ImageLabel")
	BG.BackgroundTransparency = 1
	BG.Size = UDim2.new(1, 0, 1, 0)
	BG.Image = "rbxassetid://88773295034566"
	BG.ImageTransparency = 0.88
	BG.ScaleType = Enum.ScaleType.Crop
	BG.ZIndex = 0
	BG.Parent = Main

	local BGCorner = Instance.new("UICorner")
	BGCorner.CornerRadius = UDim.new(0, 16)
	BGCorner.Parent = BG

	-- Side purple accent bars
	local LeftBar = Instance.new("Frame")
	LeftBar.BackgroundColor3 = Color3.fromRGB(240, 240, 245)
	LeftBar.BackgroundTransparency = 0.3
	LeftBar.BorderSizePixel = 0
	LeftBar.Position = UDim2.new(0, 0, 0, 0)
	LeftBar.Size = UDim2.new(0, 3, 1, 0)
	LeftBar.ZIndex = 5
	LeftBar.Parent = Main

	local LeftBarGrad = Instance.new("UIGradient")
	LeftBarGrad.Color = ColorSequence.new{
		ColorSequenceKeypoint.new(0, Color3.fromRGB(180, 105, 220)),
		ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(180, 105, 220))
	}
	LeftBarGrad.Rotation = 90
	LeftBarGrad.Parent = LeftBar

	local RightBar = Instance.new("Frame")
	RightBar.BackgroundColor3 = Color3.fromRGB(240, 240, 245)
	RightBar.BackgroundTransparency = 0.3
	RightBar.BorderSizePixel = 0
	RightBar.Position = UDim2.new(1, -3, 0, 0)
	RightBar.Size = UDim2.new(0, 3, 1, 0)
	RightBar.ZIndex = 5
	RightBar.Parent = Main

	local RightBarGrad = Instance.new("UIGradient")
	RightBarGrad.Color = ColorSequence.new{
		ColorSequenceKeypoint.new(0, Color3.fromRGB(180, 105, 220)),
		ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(180, 105, 220))
	}
	RightBarGrad.Rotation = 90
	RightBarGrad.Parent = RightBar

	-- ==================== HEADER ====================
	local Header = Instance.new("Frame")
	Header.Name = "Header"
	Header.BackgroundTransparency = 1
	Header.Size = UDim2.new(1, 0, 0, 52)
	Header.ZIndex = 2
	Header.Parent = Main

	-- Top purple line
	local TopLine = Instance.new("Frame")
	TopLine.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	TopLine.BackgroundTransparency = 0.15
	TopLine.BorderSizePixel = 0
	TopLine.Size = UDim2.new(1, 0, 0, 2)
	TopLine.ZIndex = 3
	TopLine.Parent = Header

	local TopLineGrad = Instance.new("UIGradient")
	TopLineGrad.Color = ColorSequence.new{
		ColorSequenceKeypoint.new(0, Color3.fromRGB(100, 55, 130)),
		ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(100, 55, 130))
	}
	TopLineGrad.Parent = TopLine

	-- Bottom header accent
	local Accent = Instance.new("Frame")
	Accent.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Accent.BackgroundTransparency = 0.2
	Accent.BorderSizePixel = 0
	Accent.Position = UDim2.new(0, 16, 1, -2)
	Accent.Size = UDim2.new(1, -32, 0, 2)
	Accent.ZIndex = 3
	Accent.Parent = Header

	local AccentGrad = Instance.new("UIGradient")
	AccentGrad.Color = ColorSequence.new{
		ColorSequenceKeypoint.new(0, Color3.fromRGB(100, 55, 130)),
		ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(100, 55, 130))
	}
	AccentGrad.Parent = Accent

	-- Logo
	local Logo = Instance.new("ImageLabel")
	Logo.BackgroundTransparency = 1
	Logo.Position = UDim2.new(0, 14, 0.5, -12)
	Logo.Size = UDim2.new(0, 24, 0, 24)
	Logo.Image = "rbxassetid://88773295034566"
	Logo.ScaleType = Enum.ScaleType.Fit
	Logo.ZIndex = 3
	Logo.Parent = Header

	local LogoCorner = Instance.new("UICorner")
	LogoCorner.CornerRadius = UDim.new(1, 0)
	LogoCorner.Parent = Logo

	-- Title
	local Title = Instance.new("TextLabel")
	Title.BackgroundTransparency = 1
	Title.Position = UDim2.new(0, 46, 0, 4)
	Title.Size = UDim2.new(1, -90, 0, 22)
	Title.Font = Enum.Font.GothamBlack
	Title.Text = ""
	Title.TextColor3 = Color3.fromRGB(255, 255, 255)
	Title.TextSize = 16
	Title.TextXAlignment = Enum.TextXAlignment.Left
	Title.ZIndex = 3
	Title.TextStrokeColor3 = Color3.fromRGB(17, 17, 18)
	Title.TextStrokeTransparency = 0.5
	Title.Parent = Header

	-- Color cycle animation (Purple ↔ White)
	task.spawn(function()
		while Title and Title.Parent do
			TweenService:Create(Title, TweenInfo.new(1.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
				TextColor3 = Color3.fromRGB(185, 110, 255)
			}):Play()
			task.wait(1.25)
			if not Title or not Title.Parent then break end
			TweenService:Create(Title, TweenInfo.new(1.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
				TextColor3 = Color3.fromRGB(255, 255, 255)
			}):Play()
			task.wait(1.25)
		end
	end)

	local SubTitle = Instance.new("TextLabel")
	SubTitle.BackgroundTransparency = 1
	SubTitle.Position = UDim2.new(0, 46, 0, 26)
	SubTitle.Size = UDim2.new(1, -90, 0, 16)
	SubTitle.Font = Enum.Font.GothamBold
	SubTitle.Text = "ANTI BAT"
	SubTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
	SubTitle.TextSize = 11
	SubTitle.TextXAlignment = Enum.TextXAlignment.Left
	SubTitle.ZIndex = 3
	SubTitle.Parent = Header

	-- Minimize
	local MinBtn = Instance.new("TextButton")
	MinBtn.Size = UDim2.new(0, 28, 0, 28)
	MinBtn.Position = UDim2.new(1, -40, 0.5, -14)
	MinBtn.BackgroundColor3 = Color3.fromRGB(23, 23, 24)
	MinBtn.BackgroundTransparency = 0.15
	MinBtn.Text = "−"
	MinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	MinBtn.Font = Enum.Font.GothamBold
	MinBtn.TextSize = 18
	MinBtn.BorderSizePixel = 0
	MinBtn.ZIndex = 3
	MinBtn.Parent = Header

	local MinCorner = Instance.new("UICorner")
	MinCorner.CornerRadius = UDim.new(0, 8)
	MinCorner.Parent = MinBtn

	local MinStroke = Instance.new("UIStroke")
	MinStroke.Color = Color3.fromRGB(220, 205, 235)
	MinStroke.Thickness = 1.2
	MinStroke.Parent = MinBtn

	-- ==================== CONTENT ====================
	local Content = Instance.new("Frame")
	Content.Name = "Content"
	Content.BackgroundTransparency = 1
	Content.Position = UDim2.new(0, 16, 0, 58)
	Content.Size = UDim2.new(1, -32, 1, -72)
	Content.ZIndex = 2
	Content.Parent = Main

	local List = Instance.new("UIListLayout")
	List.FillDirection = Enum.FillDirection.Vertical
	List.Padding = UDim.new(0, 11)
	List.SortOrder = Enum.SortOrder.LayoutOrder
	List.Parent = Content

	-- ==================== STATUS ====================
	local StatusRow = Instance.new("Frame")
	StatusRow.LayoutOrder = 1
	StatusRow.BackgroundTransparency = 1
	StatusRow.Size = UDim2.new(1, 0, 0, 20)
	StatusRow.ZIndex = 2
	StatusRow.Parent = Content

	local StatusLabel = Instance.new("TextLabel")
	StatusLabel.BackgroundTransparency = 1
	StatusLabel.Size = UDim2.new(1, -18, 1, 0)
	StatusLabel.Font = Enum.Font.GothamBold
	StatusLabel.Text = "STATUS  •  OFF"
	StatusLabel.TextColor3 = Color3.fromRGB(240, 240, 245)
	StatusLabel.TextSize = 12
	StatusLabel.TextXAlignment = Enum.TextXAlignment.Left
	StatusLabel.ZIndex = 3
	StatusLabel.Parent = StatusRow

	local StatusDot = Instance.new("Frame")
	StatusDot.BackgroundColor3 = Color3.fromRGB(150, 110, 175)
	StatusDot.Position = UDim2.new(1, -10, 0.5, -4)
	StatusDot.Size = UDim2.new(0, 8, 0, 8)
	StatusDot.BorderSizePixel = 0
	StatusDot.ZIndex = 4
	StatusDot.Parent = StatusRow

	local StatusDotCorner = Instance.new("UICorner")
	StatusDotCorner.CornerRadius = UDim.new(1, 0)
	StatusDotCorner.Parent = StatusDot

	local StatusDotStroke = Instance.new("UIStroke")
	StatusDotStroke.Color = Color3.fromRGB(100, 55, 130)
	StatusDotStroke.Thickness = 1
	StatusDotStroke.Parent = StatusDot

	-- ==================== ACTIVATE ====================
	local ActFrame = Instance.new("Frame")
	ActFrame.LayoutOrder = 2
	ActFrame.BackgroundColor3 = Color3.fromRGB(25, 12, 35)
	ActFrame.BackgroundTransparency = 0.1
	ActFrame.Size = UDim2.new(1, 0, 0, 44)
	ActFrame.BorderSizePixel = 0
	ActFrame.ZIndex = 2
	ActFrame.Parent = Content

	local ActCorner = Instance.new("UICorner")
	ActCorner.CornerRadius = UDim.new(0, 12)
	ActCorner.Parent = ActFrame

	local ActStroke = Instance.new("UIStroke")
	ActStroke.Color = Color3.fromRGB(180, 105, 220)
	ActStroke.Thickness = 1.6
	ActStroke.Parent = ActFrame

	local ActGrad = Instance.new("UIGradient")
	ActGrad.Color = ColorSequence.new{
		ColorSequenceKeypoint.new(0, Color3.fromRGB(40, 20, 55)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(16, 7, 24))
	}
	ActGrad.Rotation = 20
	ActGrad.Parent = ActFrame

	local ActBtn = Instance.new("TextButton")
	ActBtn.BackgroundTransparency = 1
	ActBtn.Size = UDim2.new(1, 0, 1, 0)
	ActBtn.Font = Enum.Font.GothamBlack
	ActBtn.Text = "ACTIVATE ANTI BAT"
	ActBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	ActBtn.TextSize = 13
	ActBtn.ZIndex = 3
	ActBtn.Parent = ActFrame

	-- ==================== INF JUMP ====================
	local JumpFrame = Instance.new("Frame")
	JumpFrame.LayoutOrder = 3
	JumpFrame.BackgroundColor3 = Color3.fromRGB(25, 12, 35)
	JumpFrame.BackgroundTransparency = 0.1
	JumpFrame.Size = UDim2.new(1, 0, 0, 38)
	JumpFrame.BorderSizePixel = 0
	JumpFrame.ZIndex = 2
	JumpFrame.Parent = Content

	local JumpCorner = Instance.new("UICorner")
	JumpCorner.CornerRadius = UDim.new(0, 12)
	JumpCorner.Parent = JumpFrame

	local JumpStroke = Instance.new("UIStroke")
	JumpStroke.Color = Color3.fromRGB(180, 105, 220)
	JumpStroke.Thickness = 1.4
	JumpStroke.Parent = JumpFrame

	local JumpGrad = Instance.new("UIGradient")
	JumpGrad.Color = ColorSequence.new{
		ColorSequenceKeypoint.new(0, Color3.fromRGB(36, 18, 50)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(16, 7, 24))
	}
	JumpGrad.Rotation = 20
	JumpGrad.Parent = JumpFrame

	local JumpLabel = Instance.new("TextLabel")
	JumpLabel.BackgroundTransparency = 1
	JumpLabel.Position = UDim2.new(0, 16, 0, 0)
	JumpLabel.Size = UDim2.new(0.55, 0, 1, 0)
	JumpLabel.Font = Enum.Font.GothamBold
	JumpLabel.Text = "Infinite Jump"
	JumpLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	JumpLabel.TextSize = 12
	JumpLabel.TextXAlignment = Enum.TextXAlignment.Left
	JumpLabel.ZIndex = 3
	JumpLabel.Parent = JumpFrame

	-- Toggle
	local TogglePill = Instance.new("Frame")
	TogglePill.BackgroundColor3 = Color3.fromRGB(35, 18, 45)
	TogglePill.BackgroundTransparency = 0.1
	TogglePill.Position = UDim2.new(1, -56, 0.5, -10)
	TogglePill.Size = UDim2.new(0, 42, 0, 20)
	TogglePill.BorderSizePixel = 0
	TogglePill.ZIndex = 3
	TogglePill.Parent = JumpFrame

	local PillCorner = Instance.new("UICorner")
	PillCorner.CornerRadius = UDim.new(0, 10)
	PillCorner.Parent = TogglePill

	local PillStroke = Instance.new("UIStroke")
	PillStroke.Color = Color3.fromRGB(220, 205, 235)
	PillStroke.Thickness = 1.3
	PillStroke.Parent = TogglePill

	local Knob = Instance.new("Frame")
	Knob.BackgroundColor3 = Color3.fromRGB(240, 240, 245)
	Knob.Position = UDim2.new(0, 3, 0.5, -7)
	Knob.Size = UDim2.new(0, 14, 0, 14)
	Knob.BorderSizePixel = 0
	Knob.ZIndex = 4
	Knob.Parent = TogglePill

	local KnobCorner = Instance.new("UICorner")
	KnobCorner.CornerRadius = UDim.new(1, 0)
	KnobCorner.Parent = Knob

	local JumpClick = Instance.new("TextButton")
	JumpClick.BackgroundTransparency = 1
	JumpClick.Size = UDim2.new(1, 0, 1, 0)
	JumpClick.Text = ""
	JumpClick.ZIndex = 5
	JumpClick.Parent = JumpFrame

	-- ==================== KEYBIND ====================
	local KeyFrame = Instance.new("Frame")
	KeyFrame.LayoutOrder = 4
	KeyFrame.BackgroundColor3 = Color3.fromRGB(25, 12, 35)
	KeyFrame.BackgroundTransparency = 0.1
	KeyFrame.Size = UDim2.new(1, 0, 0, 38)
	KeyFrame.BorderSizePixel = 0
	KeyFrame.ZIndex = 2
	KeyFrame.Parent = Content

	local KeyCorner = Instance.new("UICorner")
	KeyCorner.CornerRadius = UDim.new(0, 12)
	KeyCorner.Parent = KeyFrame

	local KeyStroke = Instance.new("UIStroke")
	KeyStroke.Color = Color3.fromRGB(180, 105, 220)
	KeyStroke.Thickness = 1.4
	KeyStroke.Parent = KeyFrame

	local KeyGrad = Instance.new("UIGradient")
	KeyGrad.Color = ColorSequence.new{
		ColorSequenceKeypoint.new(0, Color3.fromRGB(36, 18, 50)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(16, 7, 24))
	}
	KeyGrad.Rotation = 20
	KeyGrad.Parent = KeyFrame

	local KeyLabel = Instance.new("TextLabel")
	KeyLabel.BackgroundTransparency = 1
	KeyLabel.Position = UDim2.new(0, 16, 0, 0)
	KeyLabel.Size = UDim2.new(0.48, 0, 1, 0)
	KeyLabel.Font = Enum.Font.GothamBold
	KeyLabel.Text = "Keybind"
	KeyLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	KeyLabel.TextSize = 12
	KeyLabel.TextXAlignment = Enum.TextXAlignment.Left
	KeyLabel.ZIndex = 3
	KeyLabel.Parent = KeyFrame

	local KeyBtn = Instance.new("TextButton")
	KeyBtn.Size = UDim2.new(0, 84, 0, 24)
	KeyBtn.Position = UDim2.new(1, -98, 0.5, -12)
	KeyBtn.BackgroundColor3 = Color3.fromRGB(42, 22, 52)
	KeyBtn.BackgroundTransparency = 0.1
	KeyBtn.Text = "[ " .. CurrentKeybind.Name .. " ]"
	KeyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	KeyBtn.Font = Enum.Font.GothamBlack
	KeyBtn.TextSize = 11
	KeyBtn.BorderSizePixel = 0
	KeyBtn.ZIndex = 3
	KeyBtn.Parent = KeyFrame

	local KeyBtnCorner = Instance.new("UICorner")
	KeyBtnCorner.CornerRadius = UDim.new(0, 7)
	KeyBtnCorner.Parent = KeyBtn

	local KeyBtnStroke = Instance.new("UIStroke")
	KeyBtnStroke.Color = Color3.fromRGB(225, 225, 230)
	KeyBtnStroke.Thickness = 1.2
	KeyBtnStroke.Parent = KeyBtn

	local KeyBtnGrad = Instance.new("UIGradient")
	KeyBtnGrad.Color = ColorSequence.new{
		ColorSequenceKeypoint.new(0, Color3.fromRGB(58, 30, 70)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(25, 12, 32))
	}
	KeyBtnGrad.Rotation = 90
	KeyBtnGrad.Parent = KeyBtn

	-- ==================== FOOTER ====================
	local Footer = Instance.new("TextLabel")
	Footer.LayoutOrder = 5
	Footer.BackgroundTransparency = 1
	Footer.Size = UDim2.new(1, 0, 0, 18)
	Footer.Font = Enum.Font.GothamBold
	Footer.Text = "K7 DUELS  •  ANTI BAT"
	Footer.TextColor3 = Color3.fromRGB(220, 205, 235)
	Footer.TextSize = 10
	Footer.ZIndex = 3
	Footer.Parent = Content

	-- ============================================================
	-- DRAG
	-- ============================================================
	local dragging, dragStart, startPos

	Header.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = Main.Position
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
			Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		end
	end)

	-- ============================================================
	-- MINIMIZE
	-- ============================================================
	local function toggleMinimize()
		isMinimized = not isMinimized
		local targetH = isMinimized and MINI_H or PH
		TweenService:Create(Main, TweenInfo.new(0.32, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
			Size = UDim2.new(0, PW, 0, targetH)
		}):Play()
		Content.Visible = not isMinimized
		MinBtn.Text = isMinimized and "+" or "−"
	end

	MinBtn.MouseButton1Click:Connect(toggleMinimize)

	-- ============================================================
	-- VISUALS
	-- ============================================================
	local function setToggleVisual(enabled)
		TweenService:Create(Knob, TweenInfo.new(0.22, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
			Position = enabled and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7),
			BackgroundColor3 = enabled and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(240, 240, 245)
		}):Play()
		TweenService:Create(PillStroke, TweenInfo.new(0.2), {
			Color = enabled and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(220, 205, 235)
		}):Play()
		TweenService:Create(TogglePill, TweenInfo.new(0.2), {
			BackgroundColor3 = enabled and Color3.fromRGB(70, 35, 85) or Color3.fromRGB(35, 18, 45)
		}):Play()
	end

	local function updateUI()
		if AntiBatEnabled then
			ActStroke.Color = Color3.fromRGB(255, 255, 255)
			ActBtn.Text = "DEACTIVATE ANTI BAT"
			ActBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
			StatusLabel.Text = "STATUS  •  ON"
			StatusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
			StatusDot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			StatusDotStroke.Color = Color3.fromRGB(240, 240, 245)
		else
			ActStroke.Color = Color3.fromRGB(180, 105, 220)
			ActBtn.Text = "ACTIVATE ANTI BAT"
			ActBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
			StatusLabel.Text = "STATUS  •  OFF"
			StatusLabel.TextColor3 = Color3.fromRGB(240, 240, 245)
			StatusDot.BackgroundColor3 = Color3.fromRGB(150, 110, 175)
			StatusDotStroke.Color = Color3.fromRGB(100, 55, 130)
		end
		KeyBtn.Text = WaitingForKeybind and "[ ... ]" or "[ " .. CurrentKeybind.Name .. " ]"
	end

	-- ============================================================
	-- CONNECTIONS
	-- ============================================================
	local function doubleResetThenStart()
		-- Reset character twice so Anti Bat sticks reliably
		task.spawn(function()
			local function waitNewCharacter(timeout)
				timeout = timeout or 10
				local done, result = false, nil
				local conn
				conn = LocalPlayer.CharacterAdded:Connect(function(c)
					done = true
					result = c
					if conn then conn:Disconnect() end
				end)
				local t0 = tick()
				while not done and tick() - t0 < timeout do
					task.wait(0.05)
				end
				if conn then pcall(function() conn:Disconnect() end) end
				if result then
					pcall(function()
						result:WaitForChild("HumanoidRootPart", 5)
						result:WaitForChild("Humanoid", 5)
					end)
					task.wait(0.3)
				end
				return result
			end
			local function doOneReset()
				local char = LocalPlayer.Character
				if not char then return end
				local hum = char:FindFirstChildOfClass("Humanoid")
				if not hum or hum.Health <= 0 then return end
				if _G.InstaReset and _G.InstaReset.Trigger then
					pcall(function() _G.InstaReset.Trigger() end)
				else
					pcall(function() hum.Health = 0 end)
				end
			end
			-- 1st reset
			doOneReset()
			waitNewCharacter(10)
			task.wait(0.2)
			-- 2nd reset
			doOneReset()
			waitNewCharacter(10)
			task.wait(0.35)
			if AntiBatEnabled then
				startAntiBat()
			end
		end)
	end

	local function setAntiBat(on)
		AntiBatEnabled = on == true
		if AntiBatEnabled then
			doubleResetThenStart()
		else
			stopAntiBat()
		end
		updateUI()
		saveKeybind()
	end

	ActBtn.MouseButton1Click:Connect(function()
		setAntiBat(not AntiBatEnabled)
	end)

	JumpClick.MouseButton1Click:Connect(function()
		InfiniteJumpEnabled = not InfiniteJumpEnabled
		setToggleVisual(InfiniteJumpEnabled)
	end)

	KeyBtn.MouseButton1Click:Connect(function()
		if WaitingForKeybind then return end
		WaitingForKeybind = true
		updateUI()
	end)

	UserInputService.InputBegan:Connect(function(inp, gp)
		if gp then return end
		if WaitingForKeybind and inp.UserInputType == Enum.UserInputType.Keyboard then
			CurrentKeybind = inp.KeyCode
			WaitingForKeybind = false
			updateUI()
			saveKeybind()
		elseif not WaitingForKeybind and inp.UserInputType == Enum.UserInputType.Keyboard then
			if inp.KeyCode == CurrentKeybind then
				setAntiBat(not AntiBatEnabled)
			end
		end
	end)

	LocalPlayer.CharacterAdded:Connect(function(newChar)
		Character = newChar
		HumanoidRootPart = newChar:WaitForChild("HumanoidRootPart")
		Humanoid = newChar:WaitForChild("Humanoid")
		if AntiBatEnabled then
			task.wait(0.3)
			startAntiBat()
		end
		task.wait(0.5)
		startAntiRagdoll()
	end)

	startAntiRagdoll()
	updateUI()
	setToggleVisual(InfiniteJumpEnabled)

	print("K7 DUELS ANTI BAT • Black & Green Loaded")
end
end) -- pcall Anti Bat load
if not _fearAntiBatLoadOk then
	warn("[K7 DUELS] Anti Bat no cargó: " .. tostring(_fearAntiBatLoadErr))
else
	print("[K7 DUELS] Anti Bat cargado OK (abre con _G.FearOpenAntiBat)")
end

function openFearAntiBat()
	local ok, err = pcall(function()
		if _G.FearOpenAntiBat then
			_G.FearOpenAntiBat()
		else
			warn("[K7 DUELS] FearOpenAntiBat not available")
		end
	end)
	if not ok then
		warn("[K7 DUELS Anti Bat] " .. tostring(err))
	end
end



function buildGui()
    local ROW_BG = Color3.fromRGB(14, 22, 16)
    local ROW_BORDER = Color3.fromRGB(234, 234, 239)
    local WHITE = Color3.fromRGB(255, 255, 255)
    local INP = Color3.fromRGB(8, 14, 10)
    local GUI_W, GUI_H = 300, 420
    for _, parent in ipairs({CoreGui, pgui}) do
        for _, name in ipairs({"K7Duels", "K7DuelsMobilePanel", "K7DuelsSpeedIndicator", "K7DuelsBootErrors"}) do
            pcall(function() local old = parent:FindFirstChild(name); if old then old:Destroy() end end)
        end
    end
    gui = K7DuelsUI.new("ScreenGui", nil, {Name = "K7Duels", ResetOnSpawn = false,
        IgnoreGuiInset = true, DisplayOrder = 30, ZIndexBehavior = Enum.ZIndexBehavior.Sibling})
    pcall(function() if syn and syn.protect_gui then syn.protect_gui(gui) end end)
    local ok = pcall(function() gui.Parent = CoreGui end)
    if not ok then gui.Parent = pgui end
    main = K7DuelsUI.new("Frame", gui, {Name = "Main", Size = UDim2.fromOffset(GUI_W, GUI_H),
        Position = UDim2.new(0.5, -GUI_W / 2, 0.5, -GUI_H / 2), BackgroundColor3 = Color3.fromRGB(0, 0, 0),
        BorderSizePixel = 0, ClipsDescendants = true, Active = true})
    K7DuelsUI.round(main, 8)
    local border = K7DuelsUI.stroke(main, Color3.fromRGB(240, 240, 245), 0.22, 1.4)
    border.Name = "MainBorder"
    mainUIScale = K7DuelsUI.new("UIScale", main, {Scale = uiScaleValue / 100})
    local bg = K7DuelsUI.new("ImageLabel", main, {Name = "BackgroundImage", Size = UDim2.fromScale(1, 1),
        Image = "rbxassetid://" .. backgroundImages[backgroundIndex], ImageTransparency = backgroundImageTransparency,
        BackgroundTransparency = 1, ScaleType = Enum.ScaleType.Crop, ZIndex = 0})
    K7DuelsUI.round(bg, 8)
    -- K7 DUELS overlay on every background image
    local nightMark = K7DuelsUI.new("TextLabel", main, {
        Name = "K7DuelsWatermark", Visible = false,
        Size = UDim2.new(1, -24, 0, 22),
        Position = UDim2.fromOffset(12, 8),
        BackgroundTransparency = 1,
        Text = "",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        Font = Enum.Font.GothamBlack,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTransparency = 0.15,
        ZIndex = 7,
    })
    local nightMarkStroke = Instance.new("UIStroke")
    nightMarkStroke.Color = Color3.fromRGB(0, 0, 0)
    nightMarkStroke.Thickness = 1.2
    nightMarkStroke.Transparency = 0.35
    nightMarkStroke.Parent = nightMark
    local veil = K7DuelsUI.new("Frame", main, {Name = "BackgroundVeil", Size = UDim2.fromScale(1, 1),
        BackgroundColor3 = Color3.fromRGB(13, 13, 14), BackgroundTransparency = 0.52, BorderSizePixel = 0, ZIndex = 2})
    K7DuelsUI.new("UIGradient", veil, {Rotation = 35, Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.04), NumberSequenceKeypoint.new(0.6, 0.22), NumberSequenceKeypoint.new(1, 0.10)})})
    K7DuelsUI.round(veil, 8)
    local innerBorder = K7DuelsUI.new("Frame", main, {Name = "PanelInset", Position = UDim2.fromOffset(3, 3),
        Size = UDim2.new(1, -6, 1, -6), BackgroundTransparency = 1, BorderSizePixel = 0, ZIndex = 3})
    K7DuelsUI.round(innerBorder, 15)
    K7DuelsUI.stroke(innerBorder, Color3.fromRGB(255, 255, 255), 0.91, 1)
    local topLight = K7DuelsUI.new("Frame", main, {Name = "TopLight", Position = UDim2.fromOffset(28, 1),
        Size = UDim2.new(1, -56, 0, 1), BackgroundColor3 = Color3.fromRGB(255, 255, 255), BorderSizePixel = 0, ZIndex = 4})
    K7DuelsUI.new("UIGradient", topLight, {Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.5, 0.25), NumberSequenceKeypoint.new(1, 1)})})
    local header = K7DuelsUI.new("Frame", main, {Name = "ScriptHeader", Position = UDim2.fromOffset(0, 0),
        Size = UDim2.new(1, 0, 0, 44), BackgroundTransparency = 1,
        BorderSizePixel = 0, ClipsDescendants = false, ZIndex = 5})
    K7DuelsUI.art = K7DuelsUI.new("ImageLabel", header, {Name = "Scene", Size = UDim2.fromScale(1, 1),
        Image = "rbxassetid://84231157369620", ImageTransparency = 0.02, BackgroundTransparency = 1, ScaleType = Enum.ScaleType.Crop, ZIndex = 5})
    K7DuelsUI.round(K7DuelsUI.art, 8)
    local shade = K7DuelsUI.new("Frame", header, {Name = "ArtworkShade", Size = UDim2.fromScale(1, 1), BorderSizePixel = 0,
        BackgroundColor3 = Color3.fromRGB(6, 6, 8), BackgroundTransparency = 0.35, ZIndex = 6})
    K7DuelsUI.round(shade, 8)
    K7DuelsUI.new("UIGradient", shade, {Rotation = 15, Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.00), NumberSequenceKeypoint.new(0.40, 0.12), NumberSequenceKeypoint.new(1, 0.78)})})
    -- Neblina púrpura a la derecha
    local haze = K7DuelsUI.new("Frame", header, {Name = "Haze", Size = UDim2.fromScale(0.50, 1),
        Position = UDim2.fromScale(0.50, 0), BackgroundColor3 = Color3.fromRGB(42, 42, 43),
        BackgroundTransparency = 1, BorderSizePixel = 0, ZIndex = 6})
    K7DuelsUI.new("UIGradient", haze, {Rotation = 0, Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.35, 0.55), NumberSequenceKeypoint.new(1, 0.10)})})

    -- Logo de K7 DUELS mediante asset
    scriptLogoRef = K7DuelsUI.new("ImageLabel", header, {Name = "BossHubLogo", Position = UDim2.fromOffset(6, -8),
        Size = UDim2.fromOffset(250, 60), Image = "rbxassetid://106625358412731",
        ImageTransparency = 0.08, BackgroundTransparency = 1, ScaleType = Enum.ScaleType.Fit, ZIndex = 8})
    local envyTitle = K7DuelsUI.new("TextLabel", header, {Name = "EnvyTitle", Position = UDim2.fromOffset(104, 17),
        Size = UDim2.fromOffset(220, 22), BackgroundTransparency = 1, Text = "",
        TextColor3 = Color3.fromRGB(255, 255, 255), Font = Enum.Font.GothamBlack, TextSize = 15,
        TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 10})
    local envySub = K7DuelsUI.new("TextLabel", header, {Name = "EnvySubtitle", Position = UDim2.fromOffset(105, 40),
        Size = UDim2.fromOffset(240, 16), BackgroundTransparency = 1, Text = "",
        TextColor3 = Color3.fromRGB(160, 160, 160), Font = Enum.Font.Gotham, TextSize = 9,
        TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 10})
    local close = K7DuelsUI.new("TextButton", main, {Name = "Close", Size = UDim2.fromOffset(26, 26),
        Position = UDim2.new(1, -34, 0, 9), Text = "−", TextSize = 20, Font = Enum.Font.GothamMedium,
        TextColor3 = WHITE, BackgroundColor3 = Color3.fromRGB(25, 12, 32), BackgroundTransparency = 0.02,
        BorderSizePixel = 0, AutoButtonColor = false, ZIndex = 18})
    K7DuelsUI.round(close, 13)
    local closeStroke = K7DuelsUI.stroke(close, Color3.fromRGB(240, 240, 245), 0.38, 1)
    close.MouseEnter:Connect(function()
        TS:Create(close, TweenInfo.new(0.12), {BackgroundColor3 = Color3.fromRGB(255, 255, 255), TextColor3 = Color3.fromRGB(0, 0, 0)}):Play()
        TS:Create(closeStroke, TweenInfo.new(0.12), {Color = Color3.fromRGB(255, 255, 255), Transparency = 0.05}):Play()
    end)
    close.MouseLeave:Connect(function()
        TS:Create(close, TweenInfo.new(0.12), {BackgroundColor3 = Color3.fromRGB(25, 12, 32), TextColor3 = WHITE}):Play()
        TS:Create(closeStroke, TweenInfo.new(0.12), {Color = Color3.fromRGB(240, 240, 245), Transparency = 0.38}):Play()
    end)
    -- Placa de apertura estilo referencia: negro, horizontal y con borde plateado.
    miniBtn = K7DuelsUI.new("TextButton", gui, {
        Name = "MinimizedFrame",
        Size = UDim2.fromOffset(150, 52),
        Position = UDim2.fromOffset(15, 60),
        Text = "K7 DUELS",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextTransparency = 0,
        TextSize = 16,
        Font = Enum.Font.GothamBlack,
        TextXAlignment = Enum.TextXAlignment.Center,
        TextYAlignment = Enum.TextYAlignment.Center,
        TextWrapped = false,
        BackgroundColor3 = Color3.fromRGB(0, 0, 0),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        AutoButtonColor = false,
        Visible = false,
        ZIndex = 30,
        ClipsDescendants = true,
    })
    K7DuelsUI.round(miniBtn, 16)
    local miniBtnScale = Instance.new("UIScale")
    miniBtnScale.Name = "MiniBtnScale"
    miniBtnScale.Scale = 1
    miniBtnScale.Parent = miniBtn
    local miniStroke = Instance.new("UIStroke")
    miniStroke.Name = "MiniStroke"
    miniStroke.Color = Color3.fromRGB(220, 222, 226)
    miniStroke.Thickness = 3
    miniStroke.Transparency = 0
    miniStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    miniStroke.Parent = miniBtn
    local minGlow = Instance.new("UIGradient")
    minGlow.Name = "MinGlow"
    minGlow.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0.00, Color3.fromRGB(115, 117, 122)),
        ColorSequenceKeypoint.new(0.42, Color3.fromRGB(220, 222, 226)),
        ColorSequenceKeypoint.new(0.50, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(0.58, Color3.fromRGB(220, 222, 226)),
        ColorSequenceKeypoint.new(1.00, Color3.fromRGB(115, 117, 122)),
    })
    minGlow.Parent = miniStroke
    TS:Create(minGlow, TweenInfo.new(5, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, -1), {Rotation = 360}):Play()
    do
        local dragging, dragStart, startPos
        miniBtn.InputBegan:Connect(function(input)
            if uiLocked then return end
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                dragStart = input.Position
                startPos = miniBtn.Position
                local conn
                conn = input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        dragging = false
                        if conn then conn:Disconnect() end
                    end
                end)
            end
        end)
        UIS.InputChanged:Connect(function(input)
            if uiLocked then dragging = false; return end
            if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                local delta = input.Position - dragStart
                miniBtn.Position = UDim2.fromOffset(startPos.X.Offset + delta.X, startPos.Y.Offset + delta.Y)
            end
        end)
    end
    miniBackgroundImage = nil
    -- Solo visible on/off: no toca Size ni UIScale (respeta UI Scale del usuario)
    local animating = false
    local function animate(open)
        animating = true
        if open then
            miniBtn.Visible = false
            miniBtn.BackgroundTransparency = 1
            miniBtn.TextTransparency = 0
            miniBtnScale.Scale = 1
            miniStroke.Transparency = 1
            miniStroke.Thickness = 0
            main.Visible = true
            -- reaplicar escala del usuario por si algo la movio
            if type(K7DuelsUI.fit) == "function" then
                pcall(K7DuelsUI.fit)
            elseif mainUIScale then
                mainUIScale.Scale = (uiScaleValue or 90) / 100
            end
            animating = false
        else
            miniBtn.Visible = true
            miniBtn.BackgroundTransparency = 1
            miniBtn.TextTransparency = 1
            miniBtnScale.Scale = 0.86
            miniStroke.Transparency = 1
            miniStroke.Thickness = 0
            TS:Create(miniBtn, TweenInfo.new(0.18, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {BackgroundTransparency = 0}):Play()
            TS:Create(miniBtn, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 0}):Play()
            TS:Create(miniBtnScale, TweenInfo.new(0.24, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Scale = 1}):Play()
            TS:Create(miniStroke, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Transparency = 0, Thickness = 2.5}):Play()
            main.Visible = false
            animating = false
        end
    end
    showGui = function() animate(true) end
    hideGui = function() animate(false) end
    close.Activated:Connect(hideGui)
    -- Lock under minimize (-)
    local headerLock = K7DuelsUI.new("TextButton", main, {
        Name = "HeaderLock",
        Size = UDim2.fromOffset(26, 26),
        Position = UDim2.new(1, -68, 0, 9),
        Text = uiLocked and "🔒" or "🔓",
        TextSize = 14,
        Font = Enum.Font.GothamBold,
        TextColor3 = WHITE,
        BackgroundColor3 = Color3.fromRGB(25, 12, 32),
        BackgroundTransparency = 0.02,
        BorderSizePixel = 0,
        AutoButtonColor = false,
        ZIndex = 18,
    })
    K7DuelsUI.round(headerLock, 13)
    local headerLockStroke = K7DuelsUI.stroke(headerLock, Color3.fromRGB(240, 240, 245), 0.38, 1)
    headerLock.Activated:Connect(function()
        toggleLockUI()
        headerLock.Text = uiLocked and "🔒" or "🔓"
        pcall(saveAllSettings)
    end)
    task.spawn(function()
        while headerLock and headerLock.Parent do
            headerLock.Text = uiLocked and "🔒" or "🔓"
            task.wait(0.5)
        end
    end)
    miniBtn.Activated:Connect(function()
        miniBtnScale.Scale = 0.9
        TS:Create(miniBtnScale, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Scale = 1}):Play()
        showGui()
    end)
    _G.__K7DuelsMainOriginalPos = main.Position
    main:GetPropertyChangedSignal("Position"):Connect(function()
        if not animating then _G.__K7DuelsMainOriginalPos = main.Position end
    end)
    drag(main, 44)
    -- Tabs abajo estilo Kosmos (horizontal pills)
    local tabBar = K7DuelsUI.new("Frame", main, {Name = "Navigation", Size = UDim2.new(1, 0, 0, 30),
        Position = UDim2.new(0, 0, 0, 44), BackgroundColor3 = Color3.fromRGB(0, 0, 0),
        BackgroundTransparency = 0.02, BorderSizePixel = 0, ZIndex = 14})
    -- Imagen de K7 DUELS detrás de las pestañas laterales.
    local tabBackdrop = K7DuelsUI.new("ImageLabel", main, {Name = "TabBackground",
        Size = UDim2.new(0, 90, 1, -114), Position = UDim2.new(0, 14, 0, 100),
        Image = "", ImageTransparency = 1, Visible = false,
        ImageColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 1, ScaleType = Enum.ScaleType.Stretch, ZIndex = 4,
        ClipsDescendants = true, Active = false})
    K7DuelsUI.round(tabBackdrop, 12)
    -- La barra queda transparente para que la imagen se vea detrás de los cinco tabs.
    tabBar.BackgroundTransparency = 1
    tabBar.BackgroundColor3 = Color3.fromRGB(18, 5, 14)
    tabBar.ClipsDescendants = true
    K7DuelsUI.round(tabBar, 0)
    K7DuelsUI.stroke(tabBar, Color3.fromRGB(220, 205, 235), 0.48, 1)
    K7DuelsUI.new("UIListLayout", tabBar, {FillDirection = Enum.FillDirection.Horizontal,
        HorizontalAlignment = Enum.HorizontalAlignment.Center, VerticalAlignment = Enum.VerticalAlignment.Top,
        Padding = UDim.new(0, 2), SortOrder = Enum.SortOrder.LayoutOrder})
    K7DuelsUI.new("UIPadding", tabBar, {PaddingTop = UDim.new(0, 1), PaddingBottom = UDim.new(0, 1), PaddingLeft = UDim.new(0, 1), PaddingRight = UDim.new(0, 1)})
    local headingPanel = K7DuelsUI.new("Frame", main, {Name = "SectionPanel", Position = UDim2.fromOffset(8, 76),
        Size = UDim2.new(1, -130, 0, 27), BackgroundColor3 = Color3.fromRGB(25, 12, 32),
        BackgroundTransparency = 0.12, BorderSizePixel = 0, ZIndex = 6})
    K7DuelsUI.round(headingPanel, 8)
    headingPanel.Visible = false
    K7DuelsUI.stroke(headingPanel, Color3.fromRGB(240, 240, 245), 0.68, 1)
    local pageHeading = K7DuelsUI.text(main, "01   /   MOVEMENT", UDim2.fromOffset(128, 87), UDim2.new(1, -158, 0, 23), 11, WHITE, 8)
    pageHeading.Name = "SectionHeading"
    pageHeading.Font = Enum.Font.GothamBold
    pageHeading.Visible = false
    local headingRule = K7DuelsUI.new("Frame", main, {Position = UDim2.fromOffset(8, 74),
        Size = UDim2.new(1, -144, 0, 1), BackgroundColor3 = ROW_BORDER, BackgroundTransparency = 0.48, BorderSizePixel = 0, ZIndex = 7, Visible = false})
    local tabContent = K7DuelsUI.new("Frame", main, {Name = "Content", Size = UDim2.new(1, 0, 1, -75),
        Position = UDim2.fromOffset(0, 75), BackgroundTransparency = 1, ClipsDescendants = true, ZIndex = 6})
    local footer = K7DuelsUI.new("Frame", main, {Name = "Footer", Position = UDim2.new(0, 14, 1, -34),
        Size = UDim2.new(1, -28, 0, 0), BackgroundTransparency = 1, Visible = false, ZIndex = 8})
    K7DuelsUI.new("Frame", footer, {Size = UDim2.new(1, 0, 0, 1), BackgroundColor3 = ROW_BORDER,
        BackgroundTransparency = 0.62, BorderSizePixel = 0, ZIndex = 8})
    local avatar = K7DuelsUI.new("ImageLabel", footer, {Position = UDim2.fromOffset(2, 6), Size = UDim2.fromOffset(17, 17),
        Image = "rbxthumb://type=AvatarHeadShot&id=" .. LP.UserId .. "&w=150&h=150", BackgroundColor3 = INP, BackgroundTransparency = 0.70, BorderSizePixel = 0, ZIndex = 8})
    K7DuelsUI.round(avatar, 5)
    K7DuelsUI.text(footer, "@" .. LP.Name, UDim2.fromOffset(27, 5), UDim2.new(0.5, -32, 0, 18), 9, Color3.fromRGB(255, 255, 255), 9)
    K7DuelsUI.footerStats = K7DuelsUI.text(footer, "", UDim2.new(0.5, 0, 0, 5), UDim2.new(0.5, -3, 0, 18), 8,
        Color3.fromRGB(255, 145, 64), 9)
    K7DuelsUI.footerStats.TextXAlignment = Enum.TextXAlignment.Right
    local tabs = {"Speed", "Custom", "Visual", "Music", "AutoSteal", "Settings", "Keybinds"}
    local titles = {"MOVE", "COMBAT", "LOOK", "MUSIC", "STEAL", "SETTINGS", "BINDS"}
    local headings = {"MOVEMENT", "COMBAT", "APPEARANCE", "MUSIC", "AUTO STEAL", "SETTINGS", "KEYBINDS"}
    tabButtons = {}
    local contentPages = {}
    for i, name in ipairs(tabs) do
        local button = K7DuelsUI.new("TextButton", tabBar, {Name = name, Text = "", Size = UDim2.new(1 / 7, -2, 0, 28),
            BackgroundColor3 = Color3.fromRGB(20, 20, 21), BackgroundTransparency = 0.65, BorderSizePixel = 0,
            Font = Enum.Font.GothamBold, TextSize = 9, TextColor3 = WHITE,
            AutoButtonColor = false, ZIndex = 15, LayoutOrder = i})
        K7DuelsUI.round(button, 3)
        local stroke = K7DuelsUI.stroke(button, getThemeColor(), 1, 1)
        stroke.Name = "TabStroke"
        K7DuelsUI.new("UIGradient", button, {Name = "TabBgGrad", Enabled = false,
            Color = ColorSequence.new(Color3.fromRGB(48, 48, 49), Color3.fromRGB(17, 17, 18)), Rotation = 90})
        K7DuelsUI.sectionIcon(button, name, UDim2.new(0.5, -7, 0, 1), 14, getThemeColor(), 16)
        local tabIcon = button:FindFirstChild("SectionIcon")
        if tabIcon then tabIcon.Visible = false end
        local caption = K7DuelsUI.text(button, titles[i], UDim2.new(0, 0, 0, 7), UDim2.new(1, 0, 0, 16), 8, WHITE, 16)
        caption.Name = "Caption"
        caption.TextXAlignment = Enum.TextXAlignment.Center
        local underline = K7DuelsUI.new("Frame", button, {Name = "Underline", Size = UDim2.fromOffset(30, 2),
            Position = UDim2.new(0.5, -15, 1, -2), BackgroundColor3 = getThemeColor(), BorderSizePixel = 0, Visible = i == 1, ZIndex = 16})
        K7DuelsUI.round(underline, 2)
        local page = K7DuelsUI.new("ScrollingFrame", tabContent, {Name = name, Size = UDim2.fromScale(1, 1),
            BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 2, ScrollBarImageColor3 = getThemeColor(),
            ScrollBarImageTransparency = 0.36, AutomaticCanvasSize = Enum.AutomaticSize.Y, CanvasSize = UDim2.new(),
            ScrollingDirection = Enum.ScrollingDirection.Y, ClipsDescendants = true, Visible = i == 1, ZIndex = 6})
        K7DuelsUI.new("UIListLayout", page, {Padding = UDim.new(0, 2), SortOrder = Enum.SortOrder.LayoutOrder,
            HorizontalAlignment = Enum.HorizontalAlignment.Center})
        K7DuelsUI.new("UIPadding", page, {PaddingLeft = UDim.new(0, 12), PaddingRight = UDim.new(0, 12),
            PaddingTop = UDim.new(0, 5), PaddingBottom = UDim.new(0, 10)})
        contentPages[name] = page
        table.insert(tabButtons, button)
        local function select()
            pageHeading.Text = string.format("%02d   /   %s", i, headings[i])
            for _, p in pairs(contentPages) do p.Visible = false end
            page.Visible = true
            page.Position = UDim2.fromOffset(K7DuelsUI.effects and 8 or 0, 0)
            TS:Create(page, TweenInfo.new(0.18), {Position = UDim2.fromOffset(0, 0)}):Play()
            for _, b in ipairs(tabButtons) do
                local on = b == button
                b.Underline.Visible = on
                b.TabBgGrad.Enabled = on
                b.TabStroke.Transparency = on and 0.24 or 1
                b.Caption.TextColor3 = on and WHITE or Color3.fromRGB(234, 234, 239)
                K7DuelsUI.colorSectionIcon(b:FindFirstChild("SectionIcon"), on and getThemeColor() or Color3.fromRGB(144, 147, 150))
                TS:Create(b, TweenInfo.new(0.16), {BackgroundTransparency = 0.65,
                    BackgroundColor3 = on and Color3.fromRGB(48, 48, 49) or Color3.fromRGB(20, 20, 21)}):Play()
            end
        end
        button.MouseEnter:Connect(function()
            if button ~= tabButtons[1] then
                TS:Create(button, TweenInfo.new(0.12), {BackgroundTransparency = 0.74, BackgroundColor3 = Color3.fromRGB(55, 20, 66)}):Play()
            end
        end)
        button.MouseLeave:Connect(function()
            if button ~= tabButtons[1] then
                TS:Create(button, TweenInfo.new(0.12), {BackgroundTransparency = 0.65, BackgroundColor3 = Color3.fromRGB(20, 20, 21)}):Play()
            end
        end)
        button.Activated:Connect(select)
        if i == 1 then select() end
    end
    local pageCounters = {}
    local function getNextOrder(page)
        pageCounters[page] = (pageCounters[page] or 0) + 1
        return pageCounters[page]
    end
    local function mkSect(page, text)
        local row = K7DuelsUI.new("Frame", page, {Name = "Section", Size = UDim2.new(1, -4, 0, 24), BackgroundTransparency = 1,
            LayoutOrder = getNextOrder(page), ZIndex = 7})
        local line = K7DuelsUI.new("Frame", row, {Position = UDim2.fromOffset(1, 12), Size = UDim2.fromOffset(10, 2),
            BackgroundColor3 = getThemeColor(), BorderSizePixel = 0, ZIndex = 8})
        local label = K7DuelsUI.text(row, text:upper(), UDim2.fromOffset(21, 0), UDim2.new(1, -24, 1, 0),
            9, Color3.fromRGB(255, 255, 255), 8)
        label.Font = Enum.Font.GothamBold
        return row
    end
    local function mkRow(page, height)
        local row = K7DuelsUI.new("Frame", page, {Name = "Control", Size = UDim2.new(1, -4, 0, math.max(height or 40, 40)),
            BackgroundColor3 = ROW_BG, BackgroundTransparency = 0.72, BorderSizePixel = 0,
            LayoutOrder = getNextOrder(page), ZIndex = 7})
        K7DuelsUI.round(row, 10)
        K7DuelsUI.new("UIGradient", row, {Rotation = 0, Color = ColorSequence.new(Color3.fromRGB(35, 18, 43), Color3.fromRGB(13, 9, 19))})
        local stroke = K7DuelsUI.stroke(row, ROW_BORDER, 0.73, 1)
        row.MouseEnter:Connect(function() TS:Create(stroke, TweenInfo.new(0.12), {Transparency = 0.34}):Play() end)
        row.MouseLeave:Connect(function() TS:Create(stroke, TweenInfo.new(0.12), {Transparency = 0.73}):Play() end)
        return row
    end
    local function mkLabel(row, text)
        return K7DuelsUI.text(row, text, UDim2.fromOffset(14, 0), UDim2.new(0.48, -8, 1, 0), 12, WHITE, 8)
    end
    local function mkPill(row)
        -- Switch rectangular estilo Envy: sin indicador circular ni texto ON/OFF.
        local pill = K7DuelsUI.new("Frame", row, {Name = "Track", Size = UDim2.fromOffset(36, 19),
            AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -13, 0.5, 0),
            BackgroundColor3 = Color3.fromRGB(16, 16, 16), BorderSizePixel = 0, ZIndex = 8})
        K7DuelsUI.round(pill, 10)
        K7DuelsUI.stroke(pill, ROW_BORDER, 0.48, 1.1)
        local state = K7DuelsUI.text(pill, "", UDim2.fromScale(0, 0), UDim2.fromScale(1, 1), 7,
            Color3.fromRGB(165, 151, 173), 9)
        state.Name = "State"
        state.TextXAlignment = Enum.TextXAlignment.Center
        state.TextYAlignment = Enum.TextYAlignment.Center
        local dot = K7DuelsUI.new("Frame", pill, {Name = "Knob", AnchorPoint = Vector2.new(0, 0.5),
            Size = UDim2.fromOffset(13, 13), Position = UDim2.new(0, 3, 0.5, 0),
            BackgroundColor3 = Color3.fromRGB(78, 78, 79), BorderSizePixel = 0, ZIndex = 10})
        K7DuelsUI.round(dot, 7)
        return pill, dot
    end
    local function animPill(pill, dot, on)
        local color = Color3.fromRGB(240, 240, 245)
        TS:Create(pill, TweenInfo.new(0.16), {BackgroundColor3 = on and color or Color3.fromRGB(24, 24, 25)}):Play()
        TS:Create(dot, TweenInfo.new(0.16, Enum.EasingStyle.Back), {
            Position = on and UDim2.new(1, -16, 0.5, 0) or UDim2.new(0, 3, 0.5, 0),
            BackgroundColor3 = on and Color3.fromRGB(0, 0, 0) or Color3.fromRGB(78, 78, 79)
        }):Play()
        local state = pill:FindFirstChild("State")
        if state then state.Text = "" end
        local stroke = pill:FindFirstChildOfClass("UIStroke")
        if stroke then stroke.Color = on and color or ROW_BORDER; stroke.Transparency = on and 0.08 or 0.48 end
    end
    local function mkToggle(page, text, callback)
        local row = mkRow(page, 46)
        local label = mkLabel(row, text)
        label.Size = UDim2.new(1, -86, 1, 0)
        local pill, dot = mkPill(row)
        local on = false
        local function set(value)
            on = value == true
            row:SetAttribute("K7DuelsActive", on)
            animPill(pill, dot, on)
            row:FindFirstChildOfClass("UIStroke").Transparency = on and 0.4 or 0.73
        end
        local hit = K7DuelsUI.new("TextButton", row, {Name = "ToggleHit", Size = UDim2.fromScale(1, 1), Text = "",
            BackgroundTransparency = 1, AutoButtonColor = false, ZIndex = 10})
        hit.Activated:Connect(function()
            local previous = on
            set(not on)
            local ok, err = pcall(callback, on)
            if not ok then set(previous); warn("[K7 DUELS] " .. text .. ": " .. tostring(err)) end
            task.defer(function() pcall(saveAllSettings) end)
        end)
        return set
    end
    local function mkSelector(row, default, options, callback)
        local frame = K7DuelsUI.new("Frame", row, {Name = "Selector", Size = UDim2.fromOffset(146, 32),
            Position = UDim2.new(1, -156, 0.5, -16), BackgroundColor3 = INP, BackgroundTransparency = 0.70, BorderSizePixel = 0, ZIndex = 8})
        K7DuelsUI.round(frame, 6)
        K7DuelsUI.stroke(frame, ROW_BORDER, 0.68, 1)
        local label = K7DuelsUI.text(frame, default, UDim2.fromOffset(30, 0), UDim2.fromOffset(86, 32), 10, WHITE, 9)
        label.Font = Enum.Font.GothamBold
        label.TextXAlignment = Enum.TextXAlignment.Center
        for i, direction in ipairs({-1, 1}) do
            local button = K7DuelsUI.new("TextButton", frame, {Size = UDim2.fromOffset(29, 32),
                Position = UDim2.fromOffset(i == 1 and 0 or 117, 0), BackgroundColor3 = INP,
                BorderSizePixel = 0, Text = direction == -1 and "‹" or "›", TextSize = 21,
                Font = Enum.Font.GothamMedium, TextColor3 = getThemeColor(), AutoButtonColor = false, ZIndex = 9})
            K7DuelsUI.round(button, 6)
            button.Activated:Connect(function()
                callback(direction, function(text) label.Text = text end)
                task.defer(function() pcall(saveAllSettings) end)
            end)
        end
        return label
    end
    local function mkBox(row, default, width, xoff, callback)
        local w = math.max(width or 56, 64)
        local box = K7DuelsUI.new("TextBox", row, {Size = UDim2.fromOffset(w, 32),
            Position = UDim2.new(1, -math.max(xoff or 76, w + 12), 0.5, -16), Text = tostring(default),
            BackgroundColor3 = INP, BorderSizePixel = 0, Font = Enum.Font.GothamBold, TextSize = 13,
            TextColor3 = Color3.fromRGB(255, 255, 255), ClearTextOnFocus = false, ZIndex = 9})
        K7DuelsUI.round(box, 9)
        local border = K7DuelsUI.stroke(box, ROW_BORDER, 0.58, 1)
        local lastValid = tostring(default)
        box.Focused:Connect(function() border.Color = getThemeColor(); border.Transparency = 0.10 end)
        box.FocusLost:Connect(function()
            border.Color = ROW_BORDER; border.Transparency = 0.58
            local value = tonumber(box.Text)
            if value and value == value and math.abs(value) < math.huge then
                local ok = pcall(callback, value)
                if ok then lastValid = box.Text else box.Text = lastValid end
            else box.Text = lastValid end
            task.defer(function() pcall(saveAllSettings) end)
        end)
        return box
    end

    -- Dual values like:  55  |  33
    local function mkDualBoxes(row, defA, defB, cbA, cbB)
        local w = 52
        local gap = 8
        local sepW = 12
        local total = w + gap + sepW + gap + w
        local right = 14
        local boxB = K7DuelsUI.new("TextBox", row, {
            Size = UDim2.fromOffset(w, 30),
            Position = UDim2.new(1, -(right + w), 0.5, -15),
            Text = tostring(defB), BackgroundColor3 = INP, BorderSizePixel = 0,
            Font = Enum.Font.GothamBold, TextSize = 13,
            TextColor3 = Color3.fromRGB(235, 235, 240), ClearTextOnFocus = false, ZIndex = 9,
            TextXAlignment = Enum.TextXAlignment.Center,
        })
        K7DuelsUI.round(boxB, 8)
        local borderB = K7DuelsUI.stroke(boxB, ROW_BORDER, 0.55, 1)
        local sep = K7DuelsUI.text(row, "|", UDim2.new(1, -(right + w + gap + sepW), 0.5, -15),
            UDim2.fromOffset(sepW, 30), 14, Color3.fromRGB(160, 160, 170), 9)
        sep.TextXAlignment = Enum.TextXAlignment.Center
        sep.Font = Enum.Font.GothamBold
        local boxA = K7DuelsUI.new("TextBox", row, {
            Size = UDim2.fromOffset(w, 30),
            Position = UDim2.new(1, -(right + total), 0.5, -15),
            Text = tostring(defA), BackgroundColor3 = INP, BorderSizePixel = 0,
            Font = Enum.Font.GothamBold, TextSize = 13,
            TextColor3 = Color3.fromRGB(235, 235, 240), ClearTextOnFocus = false, ZIndex = 9,
            TextXAlignment = Enum.TextXAlignment.Center,
        })
        K7DuelsUI.round(boxA, 8)
        local borderA = K7DuelsUI.stroke(boxA, ROW_BORDER, 0.55, 1)
        local function wire(box, border, cb)
            local lastValid = box.Text
            box.Focused:Connect(function()
                border.Color = getThemeColor(); border.Transparency = 0.1
            end)
            box.FocusLost:Connect(function()
                border.Color = ROW_BORDER; border.Transparency = 0.55
                local value = tonumber(box.Text)
                if value and value == value and math.abs(value) < math.huge then
                    local ok = pcall(cb, value)
                    if ok then lastValid = box.Text else box.Text = lastValid end
                else
                    box.Text = lastValid
                end
                task.defer(function() pcall(saveAllSettings) end)
            end)
        end
        wire(boxA, borderA, cbA)
        wire(boxB, borderB, cbB)
        return boxA, boxB
    end
    local function mkKeyButton(row, entry)
        local function name() return (entry.gp and entry.gp.Name) or (entry.kb and entry.kb.Name) or "None" end
        local button = K7DuelsUI.new("TextButton", row, {Size = UDim2.fromOffset(116, 32),
            Position = UDim2.new(1, -128, 0.5, -16), Text = name(), BackgroundColor3 = INP,
            TextSize = 11, Font = Enum.Font.GothamBold, TextColor3 = WHITE, BorderSizePixel = 0,
            AutoButtonColor = false, ZIndex = 9})
        K7DuelsUI.round(button, 9)
        K7DuelsUI.stroke(button, ROW_BORDER, 0.42, 1)
        local connection, axisConnection, timeout, listening = nil, nil, nil, false
        local function stop()
            listening = false; _anyKeyListening = false
            if connection then connection:Disconnect(); connection = nil end
            if axisConnection then axisConnection:Disconnect(); axisConnection = nil end
            if timeout then pcall(task.cancel, timeout); timeout = nil end
            button.Text = name(); button.TextColor3 = WHITE
        end
        button.Activated:Connect(function()
            if listening then stop(); return end
            if _anyKeyListening then return end
            listening = true; _anyKeyListening = true
            button.Text = "Press a key"; button.TextColor3 = getThemeColor()
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
        mkKeyButton(row, entry)
    end

    local speedPage = contentPages["Speed"]

    mkSect(speedPage, "Velocidad")
    -- Normal speed: NS | Carry (CS)   — como pediste, carry donde estaba lagger
    do
        local row = mkRow(speedPage, 48)
        mkLabel(row, "Normal speed")
        normalBox, carryBox = mkDualBoxes(row, NS, CS,
            function(v)
                if v == v and v > 0 and v < math.huge then
                    NS = v
                    if _G.__K7DuelsApplySpeedNow then pcall(_G.__K7DuelsApplySpeedNow) end
                end
            end,
            function(v)
                if v == v and v > 0 and v < math.huge then
                    CS = v
                    if _G.__K7DuelsApplySpeedNow then pcall(_G.__K7DuelsApplySpeedNow) end
                end
            end)
    end
    -- Custom speed: Lagger Normal | Lagger Carry
    do
        local row = mkRow(speedPage, 48)
        mkLabel(row, "Custom speed")
        laggerBox, lagger2Box = mkDualBoxes(row, LAGGER_SPEED, LAGGER_CARRY_SPEED,
            function(v)
                if v == v and v > 0 and v < math.huge then
                    LAGGER_SPEED = v
                    if _G.__K7DuelsApplySpeedNow then pcall(_G.__K7DuelsApplySpeedNow) end
                end
            end,
            function(v)
                if v == v and v > 0 and v < math.huge then
                    LAGGER_CARRY_SPEED = v
                    if _G.__K7DuelsApplySpeedNow then pcall(_G.__K7DuelsApplySpeedNow) end
                end
            end)
    end

    mkSect(speedPage, "Speed Engine")
    do
        local row = mkRow(speedPage, 46)
        mkLabel(row, "Speed Motor")
        K7DuelsUI.motorLabel = mkSelector(row, useVenixCarryEngine and "Carry Boost" or "Direct", {"Direct", "Carry Boost"}, function(direction, update)
            useVenixCarryEngine = not useVenixCarryEngine
            update(useVenixCarryEngine and "Carry Boost" or "Direct")
            if _G.__K7DuelsRefreshSpeedEngine then _G.__K7DuelsRefreshSpeedEngine() end
        end)
    end
    K7DuelsUI.carrySetter = mkToggle(speedPage, "Auto Carry", function(on)
        _G.M4AutoSpeedEnabled = on == true
        K7DuelsVenixCarry:setSoftStealEnabled(false)
        if on then
            useVenixCarryEngine = true
            if _G.M4AutoSpeedStart then pcall(_G.M4AutoSpeedStart) end
        elseif _G.M4AutoSpeedStop then
            pcall(_G.M4AutoSpeedStop)
        end
        if K7DuelsUI.motorLabel then K7DuelsUI.motorLabel.Text = useVenixCarryEngine and "Carry Boost" or "Direct" end
        if _G.__K7DuelsRefreshSpeedEngine then _G.__K7DuelsRefreshSpeedEngine() end
    end)
    do
        local row = mkRow(speedPage, 46); mkLabel(row, "Auto Carry Speed")
        K7DuelsUI.carrySpeedBox = mkBox(row, K7DuelsVenixCarry.softStealSpeed, 60, 72, function(v)
            K7DuelsVenixCarry:setSoftStealSpeed(v); K7DuelsUI.carrySpeedBox.Text = tostring(K7DuelsVenixCarry.softStealSpeed)
        end)
    end
    do
        local row = mkRow(speedPage, 46); mkLabel(row, "Auto Carry Radius")
        K7DuelsUI.carryRadiusBox = mkBox(row, K7DuelsVenixCarry.softStealRadius, 60, 72, function(v)
            K7DuelsVenixCarry:setSoftStealRadius(v); K7DuelsUI.carryRadiusBox.Text = tostring(K7DuelsVenixCarry.softStealRadius)
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

    -- Spin section removed

    mkSect(speedPage, "Float")
    _G.__RivalHubFloatSetVisual = mkToggle(speedPage, "Float", function(on)
        if _G.__RivalHubFloat then
            if on then _G.__RivalHubFloat.enable() else _G.__RivalHubFloat.disable() end
        end
        if mobSetFloat then mobSetFloat(on) end
        pcall(saveAllSettings, true)
    end)
    do
        local row = mkRow(speedPage, 42)
        mkLabel(row, "Float Height")
        local box = mkBox(row, _G.__RivalHubFloat and _G.__RivalHubFloat.RISE or 17, 50, 62, function(v)
            if _G.__RivalHubFloat and v == v and v >= 2 and v <= 100 then
                _G.__RivalHubFloat.RISE = v
                pcall(saveAllSettings, true)
            end
        end)
        floatRiseBox = box
    end
    do
        local row = mkRow(speedPage, 42)
        mkLabel(row, "Float Power")
        local box = mkBox(row, _G.__RivalHubFloat and _G.__RivalHubFloat.RATE or 55, 50, 62, function(v)
            if _G.__RivalHubFloat and v == v and v >= 5 and v <= 300 then
                _G.__RivalHubFloat.RATE = v
                pcall(saveAllSettings, true)
            end
        end)
        floatPowerBox = box
    end

    local combatPage = contentPages["Custom"]

    mkSect(combatPage, "Defense")
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
        local modes = {"off", "v1", "v2"}
        local label = mkSelector(row, antiRagdollMode:upper(), modes, function(direction, update)
            local index = antiRagdollMode == "v1" and 2 or (antiRagdollMode == "v2" and 3 or 1)
            index = (index - 1 + direction) % #modes + 1
            setAntiRagdollMode(modes[index])
            update(antiRagdollMode:upper())
        end)
        _G.updateAntiRagdollUI = function(mode) label.Text = mode:upper() end
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

    
-- ========== SPEED BYPASS (Bubble.VS panel) ==========
_G.__NightSpeedBypassOpen = _G.__NightSpeedBypassOpen or function()
    local CoreGui = game:GetService("CoreGui")
    local TweenService = game:GetService("TweenService")
    local UserInputService = game:GetService("UserInputService")
    local RunService = game:GetService("RunService")
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer

    local GUI_NAME = "NightSpeedBypassBubble"
    local parent
    pcall(function() parent = (gethui and gethui()) or CoreGui end)
    if not parent then parent = LocalPlayer:WaitForChild("PlayerGui") end

    local existing = parent:FindFirstChild(GUI_NAME)
    if existing then
        existing.Enabled = not existing.Enabled
        return existing
    end

    local C_BG = Color3.fromRGB(18, 8, 32)
    local C_PANEL = Color3.fromRGB(32, 14, 58)
    local C_ROW = Color3.fromRGB(65, 25, 110)
    local C_NEON = Color3.fromRGB(185, 110, 255)
    local C_MINT = Color3.fromRGB(245, 238, 255)
    local C_MID = Color3.fromRGB(170, 100, 220)
    local C_DIM = Color3.fromRGB(110, 55, 155)
    local C_EDGE = Color3.fromRGB(75, 30, 130)
    local C_EDGE2 = Color3.fromRGB(140, 70, 220)
    local S = 0.85

    local State = {
        Mode = "PC", Power = 97000, Active = false,
        Keybind = Enum.KeyCode.V, Binding = false,
        Hidden = false, Minimized = false, Locked = false,
    }
    local lagConn, lagAmount = nil, 0.15
    local function applyPower(val)
        State.Power = math.clamp(math.floor(val), 9000, 500000)
        local tt = math.clamp((State.Power - 10000) / 490000, 0, 1)
        lagAmount = tt * 0.2
    end
    applyPower(State.Power)
    local function startLag()
        if lagConn then lagConn:Disconnect() end
        lagConn = RunService.RenderStepped:Connect(function()
            if not State.Active then return end
            if lagAmount > 0 then
                local t0 = tick()
                while tick() - t0 < lagAmount do end
            end
        end)
    end
    local function stopLag()
        if lagConn then lagConn:Disconnect(); lagConn = nil end
    end

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = GUI_NAME
    ScreenGui.IgnoreGuiInset = true
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.DisplayOrder = 9999
    ScreenGui.Parent = parent

    local function corner(p, r)
        local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, r * S); c.Parent = p; return c
    end
    local function stroke(p, col, th)
        local s = Instance.new("UIStroke"); s.Color = col; s.Thickness = th * S; s.Parent = p; return s
    end

    local Main = Instance.new("Frame")
    Main.Name = "Main"
    Main.Active = true
    Main.ClipsDescendants = true
    Main.Position = UDim2.new(0.5, -165 * S, 0.5, -167 * S)
    Main.Size = UDim2.new(0, 330 * S, 0, 334 * S)
    Main.BackgroundColor3 = C_BG
    Main.BorderSizePixel = 0
    Main.Parent = ScreenGui
    corner(Main, 28)
    local MainScale = Instance.new("UIScale", Main)
    MainScale.Scale = 1
    local MainStroke = stroke(Main, C_NEON, 3.2)
    local MainGrad = Instance.new("UIGradient")
    MainGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0.00, Color3.fromRGB(28, 12, 55)),
        ColorSequenceKeypoint.new(0.25, C_NEON),
        ColorSequenceKeypoint.new(0.75, C_NEON),
        ColorSequenceKeypoint.new(1.00, Color3.fromRGB(28, 12, 55)),
    })
    MainGrad.Parent = MainStroke

    local Title = Instance.new("TextLabel")
    Title.BackgroundTransparency = 1
    Title.Text = "SPEED BYPASS"
    Title.TextSize = 18 * S
    Title.TextColor3 = C_MINT
    Title.Font = Enum.Font.GothamBlack
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.ZIndex = 10
    Title.Position = UDim2.new(0, 18 * S, 0, 12 * S)
    Title.Size = UDim2.new(1, -105 * S, 0, 26 * S)
    Title.Parent = Main

    local SubTitle = Instance.new("TextLabel")
    SubTitle.BackgroundTransparency = 1
    SubTitle.Text = "K7 DUELS · Bubble panel"
    SubTitle.TextSize = 10 * S
    SubTitle.TextColor3 = C_DIM
    SubTitle.Font = Enum.Font.Gotham
    SubTitle.TextXAlignment = Enum.TextXAlignment.Left
    SubTitle.ZIndex = 10
    SubTitle.Position = UDim2.new(0, 18 * S, 0, 38 * S)
    SubTitle.Size = UDim2.new(1, -105 * S, 0, 14 * S)
    SubTitle.Parent = Main

    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Position = UDim2.new(1, -42 * S, 0, 14 * S)
    CloseBtn.Size = UDim2.new(0, 28 * S, 0, 28 * S)
    CloseBtn.BackgroundColor3 = C_ROW
    CloseBtn.BorderSizePixel = 0
    CloseBtn.Text = "X"
    CloseBtn.TextColor3 = C_MID
    CloseBtn.TextSize = 14 * S
    CloseBtn.Font = Enum.Font.GothamBlack
    CloseBtn.AutoButtonColor = false
    CloseBtn.ZIndex = 10
    CloseBtn.Parent = Main
    corner(CloseBtn, 10)
    stroke(CloseBtn, C_EDGE, 1.5)
    CloseBtn.MouseButton1Click:Connect(function() ScreenGui.Enabled = false end)

    local MinBtn = Instance.new("TextButton")
    MinBtn.Position = UDim2.new(1, -74 * S, 0, 14 * S)
    MinBtn.Size = UDim2.new(0, 28 * S, 0, 28 * S)
    MinBtn.BackgroundColor3 = C_ROW
    MinBtn.BorderSizePixel = 0
    MinBtn.Text = "-"
    MinBtn.TextColor3 = C_MID
    MinBtn.TextSize = 14 * S
    MinBtn.Font = Enum.Font.GothamBlack
    MinBtn.AutoButtonColor = false
    MinBtn.ZIndex = 10
    MinBtn.Parent = Main
    corner(MinBtn, 10)

    local Divider = Instance.new("Frame")
    Divider.Position = UDim2.new(0, 14 * S, 0, 64 * S)
    Divider.Size = UDim2.new(1, -28 * S, 0, 1)
    Divider.BackgroundColor3 = C_NEON
    Divider.BorderSizePixel = 0
    Divider.ZIndex = 10
    Divider.Parent = Main

    local Body = Instance.new("Frame")
    Body.Position = UDim2.new(0, 14 * S, 0, 76 * S)
    Body.Size = UDim2.new(1, -28 * S, 0, 216 * S)
    Body.BackgroundTransparency = 1
    Body.ZIndex = 7
    Body.Parent = Main

    local function makeRow(y, height, labelText)
        local row = Instance.new("Frame")
        row.Position = UDim2.new(0, 0, 0, y * S)
        row.Size = UDim2.new(1, 0, 0, height * S)
        row.BackgroundColor3 = C_PANEL
        row.BackgroundTransparency = 0.18
        row.BorderSizePixel = 0
        row.ZIndex = 8
        row.Parent = Body
        corner(row, 14)
        stroke(row, C_EDGE, 1.2)
        local lbl = Instance.new("TextLabel")
        lbl.BackgroundTransparency = 1
        lbl.Text = labelText
        lbl.TextSize = 12 * S
        lbl.TextColor3 = C_MID
        lbl.Font = Enum.Font.GothamBold
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.ZIndex = 9
        lbl.Position = UDim2.new(0, 16 * S, 0, 0)
        lbl.Size = UDim2.new(0.42, 0, 1, 0)
        lbl.Parent = row
        return row
    end

    local ModeRow = makeRow(0, 44, "Mode")
    local PCBtn = Instance.new("TextButton")
    PCBtn.Position = UDim2.new(1, -186 * S, 0.5, -14 * S)
    PCBtn.Size = UDim2.new(0, 84 * S, 0, 28 * S)
    PCBtn.BackgroundColor3 = C_NEON
    PCBtn.BorderSizePixel = 0
    PCBtn.Text = "PC"
    PCBtn.TextColor3 = C_BG
    PCBtn.TextSize = 11 * S
    PCBtn.Font = Enum.Font.GothamBold
    PCBtn.AutoButtonColor = false
    PCBtn.ZIndex = 9
    PCBtn.Parent = ModeRow
    corner(PCBtn, 10)
    local MobileBtn = Instance.new("TextButton")
    MobileBtn.Position = UDim2.new(1, -96 * S, 0.5, -14 * S)
    MobileBtn.Size = UDim2.new(0, 88 * S, 0, 28 * S)
    MobileBtn.BackgroundColor3 = C_ROW
    MobileBtn.BorderSizePixel = 0
    MobileBtn.Text = "MOBILE"
    MobileBtn.TextColor3 = C_DIM
    MobileBtn.TextSize = 11 * S
    MobileBtn.Font = Enum.Font.GothamBold
    MobileBtn.AutoButtonColor = false
    MobileBtn.ZIndex = 9
    MobileBtn.Parent = ModeRow
    corner(MobileBtn, 10)

    local PowerRow = makeRow(54, 44, "Power")
    local PowerBox = Instance.new("TextBox")
    PowerBox.Position = UDim2.new(1, -112 * S, 0.5, -14 * S)
    PowerBox.Size = UDim2.new(0, 104 * S, 0, 28 * S)
    PowerBox.BackgroundColor3 = C_BG
    PowerBox.BorderSizePixel = 0
    PowerBox.Text = tostring(State.Power)
    PowerBox.TextColor3 = C_MINT
    PowerBox.TextSize = 12 * S
    PowerBox.Font = Enum.Font.GothamBold
    PowerBox.ClearTextOnFocus = false
    PowerBox.ZIndex = 9
    PowerBox.Parent = PowerRow
    corner(PowerBox, 10)
    stroke(PowerBox, C_EDGE2, 1.5)

    local BypassRow = makeRow(108, 56, "Bypass")
    local KeyBtn = Instance.new("TextButton")
    KeyBtn.Position = UDim2.new(1, -182 * S, 0.5, -18 * S)
    KeyBtn.Size = UDim2.new(0, 60 * S, 0, 36 * S)
    KeyBtn.BackgroundColor3 = C_ROW
    KeyBtn.BorderSizePixel = 0
    KeyBtn.Text = State.Keybind.Name
    KeyBtn.TextColor3 = C_MID
    KeyBtn.TextSize = 13 * S
    KeyBtn.Font = Enum.Font.GothamBold
    KeyBtn.AutoButtonColor = false
    KeyBtn.ZIndex = 9
    KeyBtn.Parent = BypassRow
    corner(KeyBtn, 12)
    local ToggleBtn = Instance.new("TextButton")
    ToggleBtn.Position = UDim2.new(1, -116 * S, 0.5, -18 * S)
    ToggleBtn.Size = UDim2.new(0, 108 * S, 0, 36 * S)
    ToggleBtn.BackgroundColor3 = C_ROW
    ToggleBtn.BorderSizePixel = 0
    ToggleBtn.Text = "OFF"
    ToggleBtn.TextColor3 = C_MID
    ToggleBtn.TextSize = 13 * S
    ToggleBtn.Font = Enum.Font.GothamBold
    ToggleBtn.AutoButtonColor = false
    ToggleBtn.ZIndex = 9
    ToggleBtn.Parent = BypassRow
    corner(ToggleBtn, 12)
    stroke(ToggleBtn, C_EDGE, 1.8)

    local PowerLevelRow = makeRow(172, 44, "Levels")
    local POWER_LEVELS = {
        {Name = "Low", Value = 100000},
        {Name = "Mid", Value = 150000},
        {Name = "High", Value = 230000},
        {Name = "Ultra", Value = 450000},
    }
    local powerLevelButtons = {}
    local function syncPowerLevelHighlight()
        for _, btn in ipairs(powerLevelButtons) do
            if btn:GetAttribute("PowerValue") == State.Power then
                btn.BackgroundColor3 = C_NEON; btn.TextColor3 = C_BG
            else
                btn.BackgroundColor3 = C_ROW; btn.TextColor3 = C_DIM
            end
        end
    end
    for i, info in ipairs(POWER_LEVELS) do
        local btn = Instance.new("TextButton")
        btn.Position = UDim2.new(1, -(155 - (i - 1) * 39) * S, 0.5, -14 * S)
        btn.Size = UDim2.new(0, 36 * S, 0, 28 * S)
        btn.BackgroundColor3 = C_ROW
        btn.BorderSizePixel = 0
        btn.Text = info.Name
        btn.TextColor3 = C_DIM
        btn.TextSize = 9 * S
        btn.Font = Enum.Font.GothamBold
        btn.AutoButtonColor = false
        btn.ZIndex = 9
        btn:SetAttribute("PowerValue", info.Value)
        btn.Parent = PowerLevelRow
        corner(btn, 9)
        table.insert(powerLevelButtons, btn)
        btn.MouseButton1Click:Connect(function()
            applyPower(info.Value)
            PowerBox.Text = tostring(State.Power)
            syncPowerLevelHighlight()
            if State.Active then stopLag(); startLag() end
        end)
    end

    local function setActive(on)
        State.Active = on
        if on then
            ToggleBtn.Text = "ACTIVE"
            ToggleBtn.BackgroundColor3 = C_NEON
            ToggleBtn.TextColor3 = C_BG
            startLag()
        else
            ToggleBtn.Text = "OFF"
            ToggleBtn.BackgroundColor3 = C_ROW
            ToggleBtn.TextColor3 = C_MID
            stopLag()
        end
    end

    local function setMode(mode)
        State.Mode = mode
        if mode == "PC" then
            PCBtn.BackgroundColor3 = C_NEON; PCBtn.TextColor3 = C_BG
            MobileBtn.BackgroundColor3 = C_ROW; MobileBtn.TextColor3 = C_DIM
            applyPower(97000)
        else
            MobileBtn.BackgroundColor3 = C_NEON; MobileBtn.TextColor3 = C_BG
            PCBtn.BackgroundColor3 = C_ROW; PCBtn.TextColor3 = C_DIM
            applyPower(72000)
        end
        PowerBox.Text = tostring(State.Power)
        syncPowerLevelHighlight()
        if State.Active then stopLag(); startLag() end
    end

    PCBtn.MouseButton1Click:Connect(function() setMode("PC") end)
    MobileBtn.MouseButton1Click:Connect(function() setMode("MOBILE") end)
    ToggleBtn.MouseButton1Click:Connect(function() setActive(not State.Active) end)
    PowerBox.FocusLost:Connect(function()
        local n = tonumber(PowerBox.Text)
        if n and n > 0 then applyPower(n) end
        PowerBox.Text = tostring(State.Power)
        syncPowerLevelHighlight()
        if State.Active then stopLag(); startLag() end
    end)
    KeyBtn.MouseButton1Click:Connect(function()
        State.Binding = true
        KeyBtn.Text = "..."
    end)

    local Mini = Instance.new("Frame")
    Mini.Name = "Mini"
    Mini.Visible = false
    Mini.Active = true
    Mini.Position = Main.Position
    Mini.Size = UDim2.new(0, 330 * S, 0, 66 * S)
    Mini.BackgroundColor3 = C_BG
    Mini.BorderSizePixel = 0
    Mini.Parent = ScreenGui
    corner(Mini, 20)
    stroke(Mini, C_NEON, 2)
    local MiniLbl = Instance.new("TextLabel")
    MiniLbl.BackgroundTransparency = 1
    MiniLbl.Text = "SPEED BYPASS · tap +"
    MiniLbl.TextSize = 13 * S
    MiniLbl.TextColor3 = C_MINT
    MiniLbl.Font = Enum.Font.GothamBlack
    MiniLbl.TextXAlignment = Enum.TextXAlignment.Left
    MiniLbl.Position = UDim2.new(0, 16 * S, 0, 0)
    MiniLbl.Size = UDim2.new(1, -60 * S, 1, 0)
    MiniLbl.Parent = Mini
    local MaxBtn = Instance.new("TextButton")
    MaxBtn.Position = UDim2.new(1, -42 * S, 0.5, -14 * S)
    MaxBtn.Size = UDim2.new(0, 28 * S, 0, 28 * S)
    MaxBtn.BackgroundColor3 = C_ROW
    MaxBtn.BorderSizePixel = 0
    MaxBtn.Text = "+"
    MaxBtn.TextColor3 = C_MID
    MaxBtn.TextSize = 16 * S
    MaxBtn.Font = Enum.Font.GothamBlack
    MaxBtn.AutoButtonColor = false
    MaxBtn.Parent = Mini
    corner(MaxBtn, 10)
    MinBtn.MouseButton1Click:Connect(function()
        Mini.Position = Main.Position
        Main.Visible = false
        Mini.Visible = true
    end)
    MaxBtn.MouseButton1Click:Connect(function()
        Main.Position = Mini.Position
        Mini.Visible = false
        Main.Visible = true
    end)

    local dragTarget, dragStart, dragOrigin
    local function hookDrag(frame, moveTarget)
        frame.InputBegan:Connect(function(input)
            if State.Locked then return end
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragTarget = moveTarget
                dragStart = Vector2.new(input.Position.X, input.Position.Y)
                dragOrigin = moveTarget.Position
            end
        end)
    end
    hookDrag(Main, Main)
    hookDrag(Mini, Mini)
    UserInputService.InputChanged:Connect(function(input)
        if not dragTarget then return end
        if input.UserInputType ~= Enum.UserInputType.MouseMovement and input.UserInputType ~= Enum.UserInputType.Touch then return end
        local delta = Vector2.new(input.Position.X, input.Position.Y) - dragStart
        dragTarget.Position = UDim2.new(dragOrigin.X.Scale, dragOrigin.X.Offset + delta.X, dragOrigin.Y.Scale, dragOrigin.Y.Offset + delta.Y)
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragTarget = nil
        end
    end)
    UserInputService.InputBegan:Connect(function(input, gpe)
        if input.UserInputType ~= Enum.UserInputType.Keyboard then return end
        if State.Binding then
            if input.KeyCode == Enum.KeyCode.Unknown then return end
            State.Binding = false
            if input.KeyCode ~= Enum.KeyCode.Escape then State.Keybind = input.KeyCode end
            KeyBtn.Text = State.Keybind.Name
            return
        end
        if gpe then return end
        if input.KeyCode == State.Keybind then setActive(not State.Active) end
    end)

    RunService.Heartbeat:Connect(function()
        if MainStroke and MainGrad then MainGrad.Rotation = (MainGrad.Rotation + 1.5) % 360 end
    end)

    setMode("PC")
    syncPowerLevelHighlight()
    MainScale.Scale = 0.92
    TweenService:Create(MainScale, TweenInfo.new(0.28, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Scale = 1}):Play()
    ScreenGui.Destroying:Connect(function() stopLag() end)
    return ScreenGui
end


    mkSect(combatPage, "Attack")
    
    mkSect(combatPage, "Bypass")
    -- Speed Bypass (OPEN) movido al tab LEFT

    autoBatSetVisual = mkToggle(combatPage, "Bat Bypass", function(on)
        if on then enableAutoBat() else disableAutoBat() end
        if mobSetAutoBat then mobSetAutoBat(on) end
        pcall(saveAllSettings, true)
    end)
    do local row = mkRow(combatPage, 42); mkLabel(row, "Bypass Speed"); batSpeedBox = mkBox(row, BYPASS_AIMBOT_SPEED, 50, 56, function(v) if v == v and v > 0 and v < math.huge then BAT_AIMBOT_SPEED = v; BYPASS_AIMBOT_SPEED = v; State.bypassBatSpeed = v; if _G.__K7DuelsZ3kBypass then _G.__K7DuelsZ3kBypass.speed = v end; saveAllSettings() end end) end
    do
        local row = mkRow(combatPage, 42)
        mkLabel(row, "Bypass Version")
        batBypassVersionBtn = mkSelector(row, (BAT_BYPASS_VERSION == "v2") and "V2" or "V1", {"V1", "V2"}, function(dir, update)
            local nextVersion = (BAT_BYPASS_VERSION == "v1") and "v2" or "v1"
            if _G.__K7DuelsSetBatVersion then pcall(_G.__K7DuelsSetBatVersion, nextVersion) else BAT_BYPASS_VERSION = nextVersion end
            update(nextVersion == "v2" and "V2" or "V1")
            pcall(saveAllSettings, true)
        end)
    end

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
        else
            stopDropBrainrot()
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
        local row = mkRow(visualPage, 42)
        mkLabel(row, "UI Transparency")
        local transparencyOptions = {"0%", "15%", "30%", "45%"}
        local function applyPanelTransparency(choice)
            local amount = tonumber(string.match(choice, "(%d+)")) or 0
            local value = _clamp(amount / 100, 0, 0.45)
            if main and main.Parent then main.BackgroundTransparency = value end
            if veil and veil.Parent then veil.BackgroundTransparency = math.min(0.92, 0.16 + value * 0.7) end
        end
        mkSelector(row, "0%", transparencyOptions, function(direction, updateLabel)
            local current = 1
            for i, option in ipairs(transparencyOptions) do if option == (row:GetAttribute("TransparencyChoice") or "0%") then current = i end end
            local nextIndex = current + direction
            if nextIndex < 1 then nextIndex = #transparencyOptions end
            if nextIndex > #transparencyOptions then nextIndex = 1 end
            row:SetAttribute("TransparencyChoice", transparencyOptions[nextIndex])
            applyPanelTransparency(transparencyOptions[nextIndex])
            updateLabel(transparencyOptions[nextIndex])
        end)
    end
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

        backgroundSelectorLabel = mkSelector(row, backgroundMode, options, function(direction, updateLabel)
            local idx = currentOptionIndex() + direction
            if idx < 1 then idx = #options end
            if idx > #options then idx = 1 end
            applyBackgroundMode(options[idx])
            updateLabel(backgroundMode)
        end)
        applyBackgroundMode(backgroundMode)
    end
    do
        local row = mkRow(visualPage, 95)
        row.BackgroundTransparency = 1
        local border = row:FindFirstChildOfClass("UIStroke"); if border then border:Destroy() end
        for i, asset in ipairs(backgroundImages) do
            local total = math.max(#backgroundImages, 1)
            local card = K7DuelsUI.new("ImageButton", row, {Size = UDim2.new(1 / total, -6, 1, 0),
                Position = UDim2.new((i - 1) / total, (i - 1) * 3, 0, 0), Image = "rbxassetid://" .. asset,
                ScaleType = Enum.ScaleType.Crop, BackgroundColor3 = Color3.fromRGB(12, 16, 21),
                BorderSizePixel = 0, AutoButtonColor = false, ClipsDescendants = true, ZIndex = 8})
            K7DuelsUI.round(card, 12)
            K7DuelsUI.stroke(card, getThemeColor(), 0.72, 1.7)
            local scrim = K7DuelsUI.new("Frame", card, {Size = UDim2.fromScale(1, 1), BackgroundColor3 = Color3.fromRGB(8, 12, 17),
                BackgroundTransparency = 0.6, BorderSizePixel = 0, ZIndex = 9})
            K7DuelsUI.round(scrim, 12)
            -- K7 DUELS label on every background preview
            local cardTitle = K7DuelsUI.new("TextLabel", card, {
                Name = "K7DuelsCardTitle",
                Size = UDim2.new(1, -6, 0, 14),
                Position = UDim2.fromOffset(3, 4),
                BackgroundTransparency = 1,
                Text = "",
                TextColor3 = Color3.fromRGB(255, 255, 255),
                Font = Enum.Font.GothamBlack,
                TextSize = 8,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextTransparency = 0.05,
                ZIndex = 12,
            })
            local cardStroke = Instance.new("UIStroke")
            cardStroke.Color = Color3.fromRGB(0, 0, 0)
            cardStroke.Thickness = 1
            cardStroke.Transparency = 0.4
            cardStroke.Parent = cardTitle
            local badge = K7DuelsUI.new("Frame", card, {Name = "Selected", Size = UDim2.fromOffset(16, 16),
                Position = UDim2.new(1, -22, 0, 6), BackgroundColor3 = getThemeColor(), BorderSizePixel = 0,
                Visible = false, ZIndex = 10})
            K7DuelsUI.round(badge, 6)
            local check = K7DuelsUI.text(badge, "✓", UDim2.fromOffset(0, 0), UDim2.fromScale(1, 1), 11, WHITE, 11)
            check.TextXAlignment = Enum.TextXAlignment.Center
            local label = K7DuelsUI.text(card, "SCENE 0" .. i,
                UDim2.new(0, 8, 1, -25), UDim2.new(1, -12, 0, 19), 9, WHITE, 10)
            label.Font = Enum.Font.GothamBold
            card.Activated:Connect(function() applyBackgroundMode("Background " .. i); pcall(saveAllSettings, true) end)
            K7DuelsUI.cards[i] = card
        end
        applyBackgroundMode(backgroundMode)
    end
    setLockUIVisual = mkToggle(visualPage, "Lock UI", function(on) toggleLockUI(on) end)
    setHideButtonsVisual = mkToggle(visualPage, "Hide All Buttons", function(on) toggleHideButtons(on) end)
    if setHideButtonsVisual and hideButtonsEnabled then setHideButtonsVisual(true) end

    mkSect(visualPage, "Hide Individual")
    do
        local hideLabels = {
            {"DropBR", "Drop BR"}, {"AutoLeft", "Auto Left"}, {"AutoBat", "Bat Bypass"},
            {"AutoRight", "Auto Right"}, {"TpDown", "TP Down"}, {"Carry", "Carry Speed"},
            {"Lagger1", "Lagger Normal"}, {"Lagger2", "Lagger Carry"},
            {"Float", "Float"}, {"InstaReset", "Insta Reset"},
        }
        for _, info in ipairs(hideLabels) do
            local btnName, label = info[1], info[2]
            local isOn = hiddenButtons and hiddenButtons[btnName] == true
            local setV = mkToggle(visualPage, "Hide " .. label, function(on)
                setButtonHidden(btnName, on)
            end)
            if setV and isOn then setV(true) end
        end
        task.defer(function()
            if applyPerButtonVisibility then pcall(applyPerButtonVisibility) end
        end)
    end

    -- Intro selector + Share Config
    mkSect(visualPage, "Intro & Config")
    do
        local row = mkRow(visualPage, 42)
        mkLabel(row, "Intro Style")
        local container = Instance.new("Frame", row)
        container.Size = UDim2.new(0, 160, 1, 0)
        container.Position = UDim2.new(1, -168, 0, 0)
        container.BackgroundTransparency = 1
        container.ZIndex = 8
        local labels = { "Normal", "K7 DUELS INTRO GOD" }
        local function refresh()
            for i, btn in ipairs(container:GetChildren()) do
                if btn:IsA("TextButton") then
                    local id = btn:GetAttribute("Id")
                    local on = (K7DuelsIntroStyle or 2) == id
                    btn.BackgroundColor3 = on and Color3.fromRGB(125, 55, 200) or INP
                    btn.TextColor3 = WHITE
                end
            end
        end
        for i, lab in ipairs(labels) do
            local btn = Instance.new("TextButton", container)
            btn.Size = UDim2.new(0, 74, 0, 26)
            btn.Position = UDim2.new(0, (i - 1) * 80, 0.5, -13)
            btn.BackgroundColor3 = INP
            btn.BackgroundTransparency = 0.1
            btn.BorderSizePixel = 0
            btn.Text = lab
            btn.TextColor3 = WHITE
            btn.Font = Enum.Font.GothamBold
            btn.TextSize = 11
            btn.AutoButtonColor = false
            btn.ZIndex = 9
            btn:SetAttribute("Id", i)
            Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 7)
            btn.MouseButton1Click:Connect(function()
                K7DuelsIntroStyle = i
                refresh()
                pcall(saveAllSettings)
            end)
        end
        refresh()
    end
    do
        local row = mkRow(visualPage, 42)
        mkLabel(row, "Share Config")
        local shareBtn = Instance.new("TextButton", row)
        shareBtn.Size = UDim2.new(0, 120, 0, 28)
        shareBtn.Position = UDim2.new(1, -128, 0.5, -14)
        shareBtn.BackgroundColor3 = INP
        shareBtn.BackgroundTransparency = 0.08
        shareBtn.BorderSizePixel = 0
        shareBtn.Text = "📋 Copy"
        shareBtn.TextColor3 = WHITE
        shareBtn.Font = Enum.Font.GothamBold
        shareBtn.TextSize = 12
        shareBtn.AutoButtonColor = false
        shareBtn.ZIndex = 9
        Instance.new("UICorner", shareBtn).CornerRadius = UDim.new(0, 8)
        shareBtn.MouseButton1Click:Connect(function()
            local ok, encoded = pcall(function()
                local c = buildConfigTable()
                c.introStyle = K7DuelsIntroStyle or 2
                return HS:JSONEncode(c)
            end)
            if ok and encoded then
                local payload = "NIGHT3:" .. encoded
                local copied = false
                pcall(function()
                    if setclipboard then setclipboard(payload) copied = true end
                end)
                pcall(function()
                    if not copied and toclipboard then toclipboard(payload) copied = true end
                end)
                shareBtn.Text = copied and "✓ Copied!" or "See F9"
                if not copied then print("[K7 DUELS] CONFIG:\n" .. payload) end
                task.delay(1.2, function() if shareBtn then shareBtn.Text = "📋 Copy" end end)
            end
        end)
    end
    do
        local row = mkRow(visualPage, 42)
        mkLabel(row, "Import Config")
        local impBtn = Instance.new("TextButton", row)
        impBtn.Size = UDim2.new(0, 120, 0, 28)
        impBtn.Position = UDim2.new(1, -128, 0.5, -14)
        impBtn.BackgroundColor3 = INP
        impBtn.BackgroundTransparency = 0.08
        impBtn.BorderSizePixel = 0
        impBtn.Text = "📥 Paste"
        impBtn.TextColor3 = WHITE
        impBtn.Font = Enum.Font.GothamBold
        impBtn.TextSize = 12
        impBtn.AutoButtonColor = false
        impBtn.ZIndex = 9
        Instance.new("UICorner", impBtn).CornerRadius = UDim.new(0, 8)
        impBtn.MouseButton1Click:Connect(function()
            local raw = nil
            pcall(function() if getclipboard then raw = getclipboard() end end)
            if type(raw) ~= "string" or raw == "" then
                impBtn.Text = "Empty"
                task.delay(1, function() if impBtn then impBtn.Text = "📥 Paste" end end)
                return
            end
            if raw:sub(1, 7) == "NIGHT3:" then raw = raw:sub(8) end
            local ok, data = pcall(function() return HS:JSONDecode(raw) end)
            if not ok or type(data) ~= "table" then
                impBtn.Text = "Invalid"
                task.delay(1, function() if impBtn then impBtn.Text = "📥 Paste" end end)
                return
            end
            -- write file then reload style note
            pcall(function()
                local writeFn = select(2, resolveK7DuelsFileApi())
                if writeFn then writeFn(CONFIG_FILE, HS:JSONEncode(data)) end
            end)
            if tonumber(data.introStyle) then
                K7DuelsIntroStyle = math.clamp(math.floor(tonumber(data.introStyle)), 1, 2)
            end
            pcall(loadAllSettings)
            impBtn.Text = "✓ Done"
            task.delay(1.2, function() if impBtn then impBtn.Text = "📥 Paste" end end)
        end)
    end

    if setHideButtonsVisual then setHideButtonsVisual(hideButtonsEnabled) end

    K7DuelsUI.lockButtonsSetter = mkToggle(visualPage, "Lock Mobile Buttons", function(on) mobileButtonsLocked = on end)
    K7DuelsUI.effectsSetter = mkToggle(visualPage, "K7 DUELS Effects", function(on) K7DuelsUI.effects = on end)
    mkSect(visualPage, "Display")
    do
        local row = mkRow(visualPage, 42)
        mkLabel(row, "UI Scale")
        uiScaleBox = mkBox(row, uiScaleValue, 50, 56, function(v)
            local n = _clamp(_floor(v+0.5), 50, 150)
            uiScaleValue = n
            if K7DuelsUI.fit then K7DuelsUI.fit() end
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
        leftBtn.BackgroundTransparency = 0.10
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
        rightBtn.BackgroundTransparency = 0.10
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
        container.Size = UDim2.new(0, 160, 1, 0)
        container.Position = UDim2.new(1, -168, 0, 0)
        container.BackgroundTransparency = 1
        container.ZIndex = 8
        local leftBtn = Instance.new("TextButton", container)
        leftBtn.Size = UDim2.new(0, 28, 0, 26)
        leftBtn.Position = UDim2.new(0, 0, 0.5, -13)
        leftBtn.BackgroundColor3 = INP
        leftBtn.BackgroundTransparency = 0.10
        leftBtn.BorderSizePixel = 0
        leftBtn.Text = "<"
        leftBtn.TextColor3 = WHITE
        leftBtn.Font = Enum.Font.GothamBold
        leftBtn.TextSize = 13
        leftBtn.AutoButtonColor = false
        leftBtn.ZIndex = 9
        Instance.new("UICorner", leftBtn).CornerRadius = UDim.new(0, 6)
        outfitSelectorLabel = Instance.new("TextLabel", container)
        outfitSelectorLabel.Size = UDim2.new(0, 80, 0, 26)
        outfitSelectorLabel.Position = UDim2.new(0.5, -40, 0.5, -13)
        outfitSelectorLabel.BackgroundTransparency = 1
        outfitSelectorLabel.Text = OUTFITS[currentOutfitIndex].label
        outfitSelectorLabel.TextColor3 = WHITE
        outfitSelectorLabel.Font = Enum.Font.GothamBold
        outfitSelectorLabel.TextSize = 12
        outfitSelectorLabel.TextXAlignment = Enum.TextXAlignment.Center
        outfitSelectorLabel.ZIndex = 9
        local rightBtn = Instance.new("TextButton", container)
        rightBtn.Size = UDim2.new(0, 28, 0, 26)
        rightBtn.Position = UDim2.new(1, -28, 0.5, -13)
        rightBtn.BackgroundColor3 = INP
        rightBtn.BackgroundTransparency = 0.10
        rightBtn.BorderSizePixel = 0
        rightBtn.Text = ">"
        rightBtn.TextColor3 = WHITE
        rightBtn.Font = Enum.Font.GothamBold
        rightBtn.TextSize = 13
        rightBtn.AutoButtonColor = false
        rightBtn.ZIndex = 9
        Instance.new("UICorner", rightBtn).CornerRadius = UDim.new(0, 6)
        local function updateOutfit(direction)
            pcall(VX7A.stop)
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

    do
        local row = mkRow(visualPage, 42)
        mkLabel(row, "Best Avatars")
        local container = Instance.new("Frame", row)
        container.Size = UDim2.new(0, 160, 1, 0)
        container.Position = UDim2.new(1, -168, 0, 0)
        container.BackgroundTransparency = 1
        container.ZIndex = 8
        local leftBtn = Instance.new("TextButton", container)
        leftBtn.Size = UDim2.new(0, 28, 0, 26)
        leftBtn.Position = UDim2.new(0, 0, 0.5, -13)
        leftBtn.BackgroundColor3 = INP
        leftBtn.BackgroundTransparency = 0.10
        leftBtn.BorderSizePixel = 0
        leftBtn.Text = "<"
        leftBtn.TextColor3 = WHITE
        leftBtn.Font = Enum.Font.GothamBold
        leftBtn.TextSize = 13
        leftBtn.AutoButtonColor = false
        leftBtn.ZIndex = 9
        Instance.new("UICorner", leftBtn).CornerRadius = UDim.new(0, 6)
        VX7A.label = Instance.new("TextLabel", container)
        VX7A.label.Size = UDim2.new(0, 80, 0, 26)
        VX7A.label.Position = UDim2.new(0.5, -40, 0.5, -13)
        VX7A.label.BackgroundTransparency = 1
        VX7A.label.Text = VX7A.labels[VX7A.index + 1] or "OFF"
        VX7A.label.TextColor3 = WHITE
        VX7A.label.Font = Enum.Font.GothamBold
        VX7A.label.TextSize = 12
        VX7A.label.TextXAlignment = Enum.TextXAlignment.Center
        VX7A.label.ZIndex = 9
        local rightBtn = Instance.new("TextButton", container)
        rightBtn.Size = UDim2.new(0, 28, 0, 26)
        rightBtn.Position = UDim2.new(1, -28, 0.5, -13)
        rightBtn.BackgroundColor3 = INP
        rightBtn.BackgroundTransparency = 0.10
        rightBtn.BorderSizePixel = 0
        rightBtn.Text = ">"
        rightBtn.TextColor3 = WHITE
        rightBtn.Font = Enum.Font.GothamBold
        rightBtn.TextSize = 13
        rightBtn.AutoButtonColor = false
        rightBtn.ZIndex = 9
        Instance.new("UICorner", rightBtn).CornerRadius = UDim.new(0, 6)
        local function stepVX7Avatar(direction)
            local pos = VX7A.index + 1 + direction
            if pos < 1 then pos = #VX7A.labels end
            if pos > #VX7A.labels then pos = 1 end
            VX7A.apply(pos - 1)
            task.defer(function() pcall(saveAllSettings) end)
        end
        leftBtn.MouseButton1Click:Connect(function() stepVX7Avatar(-1) end)
        rightBtn.MouseButton1Click:Connect(function() stepVX7Avatar(1) end)
    end

    do
        local row = mkRow(visualPage, 42)
        mkLabel(row, "Medusa Skin")
        local SKINS = {
            {id = "Default",           text = "Default"},
            {id = "Skull",             text = "Skull"},
            {id = "GoldenDesertEagle", text = "Golden Eagle"},
        }
        local function curIndex()
            local cur = _G.RivalMedusaSkin or "Default"
            for i, sk in ipairs(SKINS) do if sk.id == cur then return i end end
            return 1
        end
        local medusaLabel
        medusaLabel = mkSelector(row, SKINS[curIndex()].text, {}, function(direction, updateLabel)
            local idx = curIndex() + direction
            if idx < 1 then idx = #SKINS end
            if idx > #SKINS then idx = 1 end
            if _G.RivalSetMedusaSkin then _G.RivalSetMedusaSkin(SKINS[idx].id) end
            updateLabel(SKINS[idx].text)
        end)
        medusaLabel.Size = UDim2.new(0, 96, 0, 26)
        medusaLabel.Position = UDim2.new(0.5, -48, 0.5, -13)
        _G.RivalMedusaSkinRefreshUI = function()
            medusaLabel.Text = SKINS[curIndex()].text
        end
    end

    do
        local row = mkRow(visualPage, 42)
        mkLabel(row, "Bat Skin")
        local ORDER = _G.K7DuelsBatSkinOrder or {
            "None", "WitchBroom", "Katana", "Baseball", "NeonBlade",
            "Hammer", "Scythe", "BoneClub", "CrystalSword", "CandyCane",
            "BanHammer", "Axe", "Trident", "Lightning", "PixelSword",
        }
        local LABELS = _G.K7DuelsBatSkinLabels or {}
        local function labelOf(id) return LABELS[id] or id end
        local function curIndex()
            local cur = _G.K7DuelsBatSkin or "WitchBroom"
            for i, id in ipairs(ORDER) do if id == cur then return i end end
            return 1
        end
        local batLabel
        batLabel = mkSelector(row, labelOf(ORDER[curIndex()]), {}, function(direction, updateLabel)
            local idx = curIndex() + direction
            if idx < 1 then idx = #ORDER end
            if idx > #ORDER then idx = 1 end
            if _G.K7DuelsSetBatSkin then _G.K7DuelsSetBatSkin(ORDER[idx]) end
            updateLabel(labelOf(ORDER[idx]))
        end)
        batLabel.Size = UDim2.new(0, 96, 0, 26)
        batLabel.Position = UDim2.new(0.5, -48, 0.5, -13)
        _G.K7DuelsBatSkinRefreshUI = function()
            batLabel.Text = labelOf(ORDER[curIndex()])
        end
    end

    mkSect(visualPage, "Effects")
    do
        local row = mkRow(visualPage, 42)
        mkLabel(row, "K7Duels Title Color")
        local container = Instance.new("Frame", row)
        container.Size = UDim2.new(0, 160, 1, 0)
        container.Position = UDim2.new(1, -168, 0, 0)
        container.BackgroundTransparency = 1
        container.ZIndex = 8
        local leftBtn = Instance.new("TextButton", container)
        leftBtn.Size = UDim2.new(0, 28, 0, 26)
        leftBtn.Position = UDim2.new(0, 0, 0.5, -13)
        leftBtn.BackgroundColor3 = INP
        leftBtn.BackgroundTransparency = 0.10
        leftBtn.BorderSizePixel = 0
        leftBtn.Text = "<"
        leftBtn.TextColor3 = WHITE
        leftBtn.Font = Enum.Font.GothamBold
        leftBtn.TextSize = 13
        leftBtn.AutoButtonColor = false
        leftBtn.ZIndex = 9
        Instance.new("UICorner", leftBtn).CornerRadius = UDim.new(0, 6)
        kryvoxTitleSelectorLabel = Instance.new("TextLabel", container)
        kryvoxTitleSelectorLabel.Size = UDim2.new(0, 80, 0, 26)
        kryvoxTitleSelectorLabel.Position = UDim2.new(0.5, -40, 0.5, -13)
        kryvoxTitleSelectorLabel.BackgroundTransparency = 1
        kryvoxTitleSelectorLabel.Text = currentK7DuelsTitleTheme
        kryvoxTitleSelectorLabel.TextColor3 = WHITE
        kryvoxTitleSelectorLabel.Font = Enum.Font.GothamBold
        kryvoxTitleSelectorLabel.TextSize = 12
        kryvoxTitleSelectorLabel.TextXAlignment = Enum.TextXAlignment.Center
        kryvoxTitleSelectorLabel.ZIndex = 9
        local rightBtn = Instance.new("TextButton", container)
        rightBtn.Size = UDim2.new(0, 28, 0, 26)
        rightBtn.Position = UDim2.new(1, -28, 0.5, -13)
        rightBtn.BackgroundColor3 = INP
        rightBtn.BackgroundTransparency = 0.10
        rightBtn.BorderSizePixel = 0
        rightBtn.Text = ">"
        rightBtn.TextColor3 = WHITE
        rightBtn.Font = Enum.Font.GothamBold
        rightBtn.TextSize = 13
        rightBtn.AutoButtonColor = false
        rightBtn.ZIndex = 9
        Instance.new("UICorner", rightBtn).CornerRadius = UDim.new(0, 6)

        local K7DUELS_THEME_LIST = { "Orange", "Purple", "Blue", "Red", "Green", "Black", "Gray" }
        local function cycleK7DuelsTitle(dir)
            local idx = 1
            for i, name in ipairs(K7DUELS_THEME_LIST) do
                if name == currentK7DuelsTitleTheme then idx = i; break end
            end
            local newIdx = idx + dir
            if newIdx < 1 then newIdx = #K7DUELS_THEME_LIST end
            if newIdx > #K7DUELS_THEME_LIST then newIdx = 1 end
            applyK7DuelsTitleTheme(K7DUELS_THEME_LIST[newIdx])
        end
        leftBtn.MouseButton1Click:Connect(function() cycleK7DuelsTitle(-1) end)
        rightBtn.MouseButton1Click:Connect(function() cycleK7DuelsTitle(1) end)
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
        local container = Instance.new("Frame", row)
        container.Size = UDim2.new(0, 160, 1, 0)
        container.Position = UDim2.new(1, -168, 0, 0)
        container.BackgroundTransparency = 1
        container.ZIndex = 8
        local leftBtn = Instance.new("TextButton", container)
        leftBtn.Size = UDim2.new(0, 28, 0, 26)
        leftBtn.Position = UDim2.new(0, 0, 0.5, -13)
        leftBtn.BackgroundColor3 = INP
        leftBtn.BackgroundTransparency = 0.10
        leftBtn.BorderSizePixel = 0
        leftBtn.Text = "<"
        leftBtn.TextColor3 = WHITE
        leftBtn.Font = Enum.Font.GothamBold
        leftBtn.TextSize = 13
        leftBtn.AutoButtonColor = false
        leftBtn.ZIndex = 9
        Instance.new("UICorner", leftBtn).CornerRadius = UDim.new(0, 6)
        skySelectorLabel = Instance.new("TextLabel", container)
        skySelectorLabel.Size = UDim2.new(0, 96, 0, 26)
        skySelectorLabel.Position = UDim2.new(0.5, -48, 0.5, -13)
        skySelectorLabel.BackgroundTransparency = 1
        skySelectorLabel.Text = skyTheme
        skySelectorLabel.TextColor3 = WHITE
        skySelectorLabel.Font = Enum.Font.GothamBold
        skySelectorLabel.TextSize = 11
        skySelectorLabel.TextXAlignment = Enum.TextXAlignment.Center
        skySelectorLabel.ZIndex = 9
        local rightBtn = Instance.new("TextButton", container)
        rightBtn.Size = UDim2.new(0, 28, 0, 26)
        rightBtn.Position = UDim2.new(1, -28, 0.5, -13)
        rightBtn.BackgroundColor3 = INP
        rightBtn.BackgroundTransparency = 0.10
        rightBtn.BorderSizePixel = 0
        rightBtn.Text = ">"
        rightBtn.TextColor3 = WHITE
        rightBtn.Font = Enum.Font.GothamBold
        rightBtn.TextSize = 13
        rightBtn.AutoButtonColor = false
        rightBtn.ZIndex = 9
        Instance.new("UICorner", rightBtn).CornerRadius = UDim.new(0, 6)
        local function updateSkySelector(direction)
            local idx = 1
            for i, name in ipairs(SKY_PRESETS_LIST) do
                if name == skyTheme then idx = i; break end
            end
            local newIdx = idx + direction
            if newIdx < 1 then newIdx = #SKY_PRESETS_LIST end
            if newIdx > #SKY_PRESETS_LIST then newIdx = 1 end
            local name = SKY_PRESETS_LIST[newIdx]
            skyTheme = name
            pcall(applyCustomSky, name)
            if skySelectorLabel then skySelectorLabel.Text = name end
            pcall(saveAllSettings, true)
        end
        leftBtn.MouseButton1Click:Connect(function() updateSkySelector(-1) end)
        rightBtn.MouseButton1Click:Connect(function() updateSkySelector(1) end)
    end

    mkSect(visualPage, "Overlays")
    setESPVIsual = mkToggle(visualPage, "Player ESP", function(on) toggleESP(on) end)
    setESPLineVisual = mkToggle(visualPage, "ESP Line", function(on)
        if on then startESPLine() else stopESPLine() end
    end)

    local configPage = contentPages["Settings"]
    local musicPage = contentPages["Music"]
    local stealPage = contentPages["AutoSteal"]
    local stopCandyJukebox

    mkSect(stealPage, "Automation")

    local mkToggleOrange = mkToggle

    setInstaGrab = mkToggleOrange(stealPage, "Auto Steal", function(on)
        CONFIG.AUTO_STEAL_ENABLED = on == true
        if on then pcall(startAutoSteal) else stopAutoSteal() end
        updateProgressBarVisibility()
        pcall(saveAllSettings, true)
    end)
    do
        local row = mkRow(stealPage, 46)
        mkLabel(row, "Auto Steal Mode")
        autoStealModeBtn = mkSelector(row, autoStealMode, AUTO_STEAL_VARIANT_NAMES, function(direction, update)
            local index = (autoStealVariant - 1 + direction) % #AUTO_STEAL_VARIANT_NAMES + 1
            local enabled = CONFIG.AUTO_STEAL_ENABLED
            if enabled then stopAutoSteal() end
            setAutoStealMode(AUTO_STEAL_VARIANT_NAMES[index])
            update(autoStealMode)
            if enabled then startAutoSteal() end
        end)
    end

    do
        local row = mkRow(stealPage, 42)
        mkLabel(row, "Steal Radius")
        radInput = mkBox(row, CONFIG.STEAL_RANGE, 50, 56, function(v)
            if v and v >= 5 and v <= 300 then
                CONFIG.STEAL_RANGE = _floor(v+0.5)
                Steal.StealRadius = (autoStealMode == "V2") and 10 or CONFIG.STEAL_RANGE
                radInput.Text = tostring(CONFIG.STEAL_RANGE)
                saveAllSettings()
            end
        end)
    end


    -- UI Font selector (from Bless)
    do
        local collapsedHeight = 34
        local expandedHeight = 196
        local row = mkRow(configPage, collapsedHeight)
        mkLabel(row, "UI Font")
        local selectBtn = Instance.new("TextButton", row)
        selectBtn.Size = UDim2.new(0, 148, 0, 24)
        selectBtn.Position = UDim2.new(1, -156, 0, 5)
        selectBtn.BackgroundColor3 = INP
        selectBtn.BackgroundTransparency = 0.70
        selectBtn.BorderSizePixel = 0
        selectBtn.Text = K7DuelsUI.fontDisplayName(K7DuelsUI.fontName) .. "  ▼"
        selectBtn.TextColor3 = WHITE
        selectBtn.Font = K7DuelsUI.resolveFont(K7DuelsUI.fontName) or Enum.Font.GothamBold
        selectBtn.TextSize = 9
        selectBtn.TextTruncate = Enum.TextTruncate.AtEnd
        selectBtn.AutoButtonColor = false
        selectBtn.ZIndex = 11
        Instance.new("UICorner", selectBtn).CornerRadius = UDim.new(0, 7)
        local selectStroke = Instance.new("UIStroke", selectBtn)
        selectStroke.Color = ROW_BORDER
        selectStroke.Thickness = 1
        selectStroke.Transparency = 0.3
        local list = Instance.new("ScrollingFrame", row)
        list.Name = "FontList"
        list.Position = UDim2.new(0, 8, 0, 37)
        list.Size = UDim2.new(1, -16, 0, 151)
        list.BackgroundColor3 = Color3.fromRGB(8, 8, 10)
        list.BackgroundTransparency = 0.05
        list.BorderSizePixel = 0
        list.ScrollBarThickness = 3
        list.ScrollBarImageColor3 = getThemeColor()
        list.ScrollingDirection = Enum.ScrollingDirection.Y
        list.CanvasSize = UDim2.new(0, 0, 0, 0)
        list.Visible = false
        list.ZIndex = 20
        Instance.new("UICorner", list).CornerRadius = UDim.new(0, 8)
        local listStroke = Instance.new("UIStroke", list)
        listStroke.Color = ROW_BORDER
        listStroke.Thickness = 1
        listStroke.Transparency = 0.4
        local layout = Instance.new("UIListLayout", list)
        layout.SortOrder = Enum.SortOrder.LayoutOrder
        layout.Padding = UDim.new(0, 3)
        local padding = Instance.new("UIPadding", list)
        padding.PaddingTop = UDim.new(0, 5)
        padding.PaddingBottom = UDim.new(0, 5)
        padding.PaddingLeft = UDim.new(0, 5)
        padding.PaddingRight = UDim.new(0, 5)
        local open = false
        local function setOpen(state)
            open = state == true
            list.Visible = open
            row.Size = UDim2.new(1, -4, 0, open and expandedHeight or collapsedHeight)
            selectBtn.Text = K7DuelsUI.fontDisplayName(K7DuelsUI.fontName) .. (open and "  ▲" or "  ▼")
        end
        local function addFontOption(displayName, fontItem, order, fontName)
            local option = Instance.new("TextButton", list)
            option.Name = "Font_" .. tostring(fontName or displayName)
            option.Size = UDim2.new(1, -2, 0, 25)
            option.BackgroundColor3 = Color3.fromRGB(14, 14, 17)
            option.BackgroundTransparency = 0.08
            option.BorderSizePixel = 0
            option.Text = displayName
            option.TextColor3 = WHITE
            option.Font = fontItem
            option.TextSize = 11
            option.TextXAlignment = Enum.TextXAlignment.Left
            option.AutoButtonColor = false
            option.LayoutOrder = order
            option.ZIndex = 22
            option:SetAttribute("K7DuelsFontPreview", true)
            Instance.new("UICorner", option).CornerRadius = UDim.new(0, 6)
            local optionPadding = Instance.new("UIPadding", option)
            optionPadding.PaddingLeft = UDim.new(0, 9)
            option.Activated:Connect(function()
                K7DuelsUI.applyFont(fontName or fontItem.Name, true)
                selectBtn.Font = fontItem
                setOpen(false)
            end)
            return option
        end
        addFontOption("Original", Enum.Font.GothamBold, 1, "GothamBold")
        local fontOrder = 2
        for _, fontItem in ipairs(K7DuelsUI.fontItems) do
            if fontItem.Name ~= "GothamBold" then
                addFontOption(fontItem.Name, fontItem, fontOrder, fontItem.Name)
                fontOrder = fontOrder + 1
            end
        end
        layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            list.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 10)
        end)
        task.defer(function()
            if list and list.Parent then
                list.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 10)
            end
        end)
        selectBtn.Activated:Connect(function() setOpen(not open) end)
        K7DuelsUI.fontSelectorLabel = selectBtn
        setOpen(false)
    end

    mkSect(musicPage, "Music Player")
    do
        local row = mkRow(musicPage, 44)
        row.Size = UDim2.new(1, 0, 0, 44)
        local pingBtn = Instance.new("TextButton", row)
        pingBtn.Size = UDim2.new(1, -12, 0.8, 0)
        pingBtn.Position = UDim2.new(0, 6, 0.1, 0)
        pingBtn.BackgroundColor3 = Color3.fromRGB(27, 30, 33)
        pingBtn.BorderSizePixel = 0
        pingBtn.Text = "OPEN NORTH MUSIC"
        pingBtn.TextColor3 = Color3.fromRGB(235, 238, 242)
        pingBtn.Font = Enum.Font.GothamBold
        pingBtn.TextSize = 13
        pingBtn.AutoButtonColor = false
        pingBtn.ZIndex = 8
        Instance.new("UICorner", pingBtn).CornerRadius = UDim.new(0, 6)
        local pingStroke = Instance.new("UIStroke", pingBtn)
        pingStroke.Color = getThemeColor()
        pingStroke.Thickness = 1.5
        pingStroke.Transparency = 0.4
        pingBtn.MouseEnter:Connect(function()
            TS:Create(pingBtn, TweenInfo.new(0.15), {BackgroundColor3 = getThemeColor()}):Play()
            TS:Create(pingBtn, TweenInfo.new(0.15), {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
        end)
        pingBtn.MouseLeave:Connect(function()
            TS:Create(pingBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(27, 30, 33)}):Play()
            TS:Create(pingBtn, TweenInfo.new(0.15), {TextColor3 = Color3.fromRGB(235, 238, 242)}):Play()
        end)
        pingBtn.MouseButton1Click:Connect(function()
            if stopCandyJukebox then stopCandyJukebox() end
            local okPing, errPing = pcall(openK7DuelsPingLagger)
            if not okPing then warn("[K7Duels North Music] " .. tostring(errPing)) end
        end)
    end

    -- OPEN ANTI BAT movido al tab LEFT

    mkSect(musicPage, "Music")
    do
        local row = mkRow(musicPage, 44)
        row.Size = UDim2.new(1, 0, 0, 44)
        local musicBtn = Instance.new("TextButton", row)
        musicBtn.Size = UDim2.new(1, -12, 0.8, 0)
        musicBtn.Position = UDim2.new(0, 6, 0.1, 0)
        musicBtn.BackgroundColor3 = Color3.fromRGB(27, 30, 33)
        musicBtn.BorderSizePixel = 0
        musicBtn.Text = "REDRUM 0:00"
        musicBtn.TextColor3 = Color3.fromRGB(235, 238, 242)
        musicBtn.Font = Enum.Font.GothamBold
        musicBtn.TextSize = 13
        musicBtn.AutoButtonColor = false
        musicBtn.ZIndex = 8
        Instance.new("UICorner", musicBtn).CornerRadius = UDim.new(0, 6)

        local musicStroke = Instance.new("UIStroke", musicBtn)
        musicStroke.Color = getThemeColor()
        musicStroke.Thickness = 1.5
        musicStroke.Transparency = 0.4

        local function refreshMusicButton()
            local playing = kryvoxFullRedrumSound and kryvoxFullRedrumSound.Parent and kryvoxFullRedrumSound.Playing
            musicBtn.Text = playing and kryvoxFullRedrumSound.Name == "K7DuelsRedrumFull" and "STOP REDRUM" or "REDRUM 0:00"
        end

        table.insert(kryvoxMusicRefreshers, refreshMusicButton)

        musicBtn.MouseEnter:Connect(function()
            TS:Create(musicBtn, TweenInfo.new(0.15), {BackgroundColor3 = getThemeColor()}):Play()
            TS:Create(musicBtn, TweenInfo.new(0.15), {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
        end)
        musicBtn.MouseLeave:Connect(function()
            TS:Create(musicBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(27, 30, 33)}):Play()
            TS:Create(musicBtn, TweenInfo.new(0.15), {TextColor3 = Color3.fromRGB(235, 238, 242)}):Play()
        end)

        musicBtn.MouseButton1Click:Connect(function()
            if stopCandyJukebox then stopCandyJukebox() end
            local same = kryvoxFullRedrumSound and kryvoxFullRedrumSound.Name == "K7DuelsRedrumFull"
            stopK7DuelsFullRedrum()
            for _, refresh in ipairs(kryvoxMusicRefreshers) do refresh() end
            if same then return end

            local sound = makeK7DuelsRedrumSound(0, "K7DuelsRedrumFull")
            if sound then
                pcall(function()
                    sound.TimePosition = 0
                end)
                kryvoxFullRedrumSound = sound
                refreshMusicButton()
                sound.Ended:Connect(function()
                    if kryvoxFullRedrumSound == sound then
                        pcall(function() sound:Destroy() end)
                        kryvoxFullRedrumSound = nil
                        refreshMusicButton()
                    end
                end)
            end
        end)
    end

    do
        local songs = {
            {name="Gané",file="K7Duels_Gane.mp3",url="https://file.garden/algLafWA1jk8WMfK/Gane%CC%81_spotdown.org%202.mp3"},
            {name="CARNIVAL",file="K7Duels_Carnival.mp3",url="https://file.garden/algLafWA1jk8WMfK/CARNIVAL_spotdown.org.mp3"},
            {name="Type Shit",file="K7Duels_TypeShit.mp3",url="https://file.garden/algLafWA1jk8WMfK/Type%20Shit_spotdown.org.mp3"},
            {name="El Black",file="K7Duels_ElBlack.mp3",url="https://file.garden/algLafWA1jk8WMfK/El%20Black_spotdown.org.mp3"},
            {name="X.O.X.O",file="K7Duels_XOXO.mp3",url="https://files.catbox.moe/jghp0f.mp3",coverUrl="https://image-cdn-fa.spotifycdn.com/image/ab67616d00001e02b18c2edd559993b96a961ffc"},
            {name="Selfish",file="K7Duels_Selfish.mp3",url="https://file.garden/algLafWA1jk8WMfK/Selfish_spotdown.org.mp3"},
            {name="Me Paseo",file="K7Duels_MePaseo.mp3",url="https://file.garden/algLafWA1jk8WMfK/Me%20Paseo_spotdown.org.mp3"},
            {name="Gassed Up",file="K7Duels_GassedUp.mp3",url="https://file.garden/algLafWA1jk8WMfK/Gassed%20Up_spotdown.org.mp3"},
        }
        local function refreshAll()
            for _,refresh in ipairs(kryvoxMusicRefreshers) do refresh() end
        end
        for _,entry in ipairs(songs) do
            local song=entry
            local row=mkRow(musicPage,44)
            local button=K7DuelsUI.new("TextButton",row,{Size=UDim2.new(1,-12,1,-8),Position=UDim2.fromOffset(6,4),
                Text=song.name.." 0:00",TextSize=13,Font=Enum.Font.GothamBold,TextColor3=WHITE,
                BackgroundColor3=INP,BorderSizePixel=0,AutoButtonColor=false,ZIndex=8})
            if song.coverUrl then
                button.Position=UDim2.fromOffset(44,4)
                button.Size=UDim2.new(1,-50,1,-8)
                local cover=K7DuelsUI.new("ImageLabel",row,{Name="SongCover",Position=UDim2.fromOffset(6,6),
                    Size=UDim2.fromOffset(32,32),BackgroundTransparency=1,Image="",ScaleType=Enum.ScaleType.Fit,ZIndex=8})
                K7DuelsUI.round(cover,5)
                task.spawn(function()
                    pcall(function()
                        local loader=getcustomasset or getsynasset
                        if type(loader)~="function" or type(writefile)~="function"then return end
                        local file="K7Duels_XOXO_Cover.jpg"
                        if not (type(isfile)=="function" and isfile(file))then
                            local data=game:HttpGet(song.coverUrl)
                            if type(data)~="string" or #data<512 then return end
                            writefile(file,data)
                        end
                        local asset=loader(file)
                        if cover.Parent then cover.Image=asset end
                    end)
                end)
            end
            K7DuelsUI.round(button,6)
            K7DuelsUI.stroke(button,getThemeColor(),.4,1)
            local loading=false
            local function refresh()
                local current=kryvoxFullRedrumSound
                local playing=current and current.Parent and current.Playing and current.Name==song.file
                button.Text=loading and ("CARGANDO "..song.name) or (playing and "STOP " or "")..song.name..(playing and "" or " 0:00")
            end
            table.insert(kryvoxMusicRefreshers,refresh)
            button.Activated:Connect(function()
                if loading then return end
                if stopCandyJukebox then stopCandyJukebox() end
                local current=kryvoxFullRedrumSound
                local same=current and current.Name==song.file
                stopK7DuelsFullRedrum()
                refreshAll()
                if same then return end
                local token=kryvoxMusicRequest
                loading=true;refresh()
                task.spawn(function()
                    local ok,err=pcall(function()
                        local loader=getcustomasset or getsynasset
                        assert(type(loader)=="function" and type(writefile)=="function","custom assets unavailable")
                        local exists=type(isfile)=="function" and isfile(song.file)
                        if not exists then
                            local data=game:HttpGet(song.url)
                            assert(type(data)=="string" and #data>256,"audio download failed")
                            writefile(song.file,data)
                        end
                        local asset=loader(song.file)
                        if token~=kryvoxMusicRequest then return end
                        local sound=Instance.new("Sound")
                        sound.Name=song.file;sound.SoundId=asset;sound.Volume=.85;sound.Looped=false
                        sound.Parent=SoundService;sound.TimePosition=0
                        kryvoxFullRedrumSound=sound
                        sound.Ended:Connect(function()
                            if kryvoxFullRedrumSound==sound then kryvoxFullRedrumSound=nil;refreshAll() end
                            sound:Destroy()
                        end)
                        sound:Play()
                    end)
                    loading=false;refreshAll()
                    if not ok then warn("[K7 DUELS Music] "..tostring(err))end
                end)
            end)
        end
    end

    mkSect(musicPage, "Escuchar música")
    local candyJukeboxSongs = {
        {name="LAGUNAS", artist="Peso Pluma, Jasiel Nuñez", url="https://file.garden/algLafWA1jk8WMfK/LAGUNAS_spotdown.org.mp3", file="FearHubJukebox_01_Lagunas.mp3"},
        {name="Misery Slowed + Reverb", artist="A7AX", url="https://file.garden/algLafWA1jk8WMfK/Misery%20-%20Remix%20Slowed%2BReverb_spotdown.org.mp3", file="FearHubJukebox_02_Misery.mp3"},
        {name="Tusa", artist="KAROL G, Nicki Minaj", url="https://file.garden/algLafWA1jk8WMfK/Tusa_spotdown.org.mp3", file="FearHubJukebox_03_Tusa.mp3"},
        {name="Orula", artist="Victor Mendivil", url="https://files.catbox.moe/v20ko9.mp3", file="FearHubJukebox_04_Orula.mp3"},
        {name="X.O.X.O", artist="Pedro Calderón, D' La Crem", url="https://files.catbox.moe/jghp0f.mp3", file="M4LWAREJukebox_05_XOXO.mp3"},
        {name="Beretta", artist="El De Las R's", url="https://file.garden/algLafWA1jk8WMfK/Beretta%20-%20video%20oficial(MP3_160K).mp3", file="FearHubJukebox_06_Beretta.mp3", startAt=11},
        {name="Took Her To The O", artist="King Von", url="https://file.garden/algLafWA1jk8WMfK/King%20Von%20-%20Took%20Her%20To%20The%20O%20(Lyrics)(MP3_160K).mp3", file="FearHubJukebox_07_TookHerToTheO.mp3"},
        {name="LAJA - NADIE TA FRIO", artist="LAJA", url="https://file.garden/algLafWA1jk8WMfK/LAJA%20-%20NADIE%20TA%20FRIO%20(Letra)(MP3_160K).mp3", file="FearHubJukebox_08_Laja.mp3"},
        {name="HORA CERO", artist="Myke Towers", url="https://file.garden/algLafWA1jk8WMfK/Myke%20Towers%20-%20HORA%20CERO%20(Lyrics)(MP3_160K).mp3", file="FearHubJukebox_09_HoraCero.mp3"},
        {name="Bling Bling", artist="Grupo Marca Registrada, Octavio Cuadras", url="https://file.garden/algLafWA1jk8WMfK/Bling%20Bling_spotdown.org.mp3", file="FearHubJukebox_10_BlingBling.mp3"},
        {name="Lucid Dreams (Clean)", artist="Juice WRLD", url="https://file.garden/algLafWA1jk8WMfK/Lucid%20Dreams%20-%20Clean%20-%20Juice%20WRLD(MP3_160K).mp3", file="FearHubJukebox_11_LucidDreams.mp3"},
        {name="Un Pacto", artist="Victor Mendivil, El Padrinito Toys", url="https://file.garden/algLafWA1jk8WMfK/Un%20Pacto_spotdown.org.mp3", file="FearHubJukebox_12_UnPacto.mp3"},
        {name="La diabla", artist="Xavi", url="https://file.garden/algLafWA1jk8WMfK/La%20Diabla_spotdown.org.mp3", file="FearHubJukebox_13_LaDiabla.mp3"},
        {name="Kamikaze", artist="Natanael Cano, Uriel Gaxiola, Ganggy, Victor Mendivil", url="https://file.garden/algLafWA1jk8WMfK/Kamikaze%20(feat.%20Victor%20Mendivil)_spotdown.org.mp3", file="FearHubJukebox_14_Kamikaze.mp3"},
        {name="Triple lavada", artist="Esau Ortiz, Luis R Conriquez, Oscar Maydon, Alemán, Victor Mendivil", url="https://file.garden/algLafWA1jk8WMfK/Triple%20Lavada%20%28feat.%20Victor%20Mendivil%29%20-%20Remix_spotdown.org.mp3", file="FearHubJukebox_15_TripleLavada_v3.mp3"},
        {name="Dopamina", artist="Peso Pluma, Tito Double P", url="https://file.garden/algLafWA1jk8WMfK/dopamina_spotdown.org.mp3", file="FearHubJukebox_16_Dopamina.mp3"},
        {name="You", artist="Tiagz, Victor Mendivil", url="https://file.garden/algLafWA1jk8WMfK/You_spotdown.org.mp3", file="FearHubJukebox_17_You.mp3"},
        {name="PRESIDENTE", artist="Gabito Ballesteros, Natanael Cano, Luis R Conriquez, Neton Vega", url="https://file.garden/algLafWA1jk8WMfK/PRESIDENTE_spotdown.org.mp3", file="FearHubJukebox_18_Presidente.mp3"},
        {name="El Drip", artist="Natanael Cano", url="https://file.garden/algLafWA1jk8WMfK/El%20Drip_spotdown.org.mp3", file="FearHubJukebox_19_ElDrip.mp3"},
        {name="Por Mi Zona", artist="La Santa Grifa", url="https://file.garden/algLafWA1jk8WMfK/Por%20Mi%20Zona_spotdown.org.mp3", file="FearHubJukebox_20_PorMiZona.mp3"},
        {name="Cachondos Session #1", artist="Kevin AMF, Victor Mendivil, Dani Flow, Sebastian Esquivel, Eugenio Esquivel, Tiagz, Los Esquivel", url="https://file.garden/algLafWA1jk8WMfK/Cachondos%20Session%20%231%20(feat.%20Sebastian%20Esquivel%2C%20Eugenio%20Esquivel%2C%20Tiagz%20%26%20Los%20Esquivel)_spotdown.org.mp3", file="FearHubJukebox_21_CachondosSession1.mp3"},
        {name="Jacobo Grinberg", artist="Victor Mendivil", url="https://file.garden/algLafWA1jk8WMfK/Jacobo%20Grinberg_spotdown.org.mp3", file="FearHubJukebox_22_JacoboGrinberg.mp3"},
        {name="Punta Cana", artist="Victor Mendivil, Kevin AMF", url="https://file.garden/algLafWA1jk8WMfK/Punta%20Cana_spotdown.org.mp3", file="FearHubJukebox_23_PuntaCana.mp3"},
        {name="King of Watches", artist="Omar Camacho", url="https://file.garden/algLafWA1jk8WMfK/King%20of%20Watches_spotdown.org%202.mp3", file="FearHubJukebox_24_KingOfWatchesOmar.mp3"},
        {name="King of Watches", artist="Victor Mendivil, Neton Vega", url="https://file.garden/algLafWA1jk8WMfK/King%20of%20Watches_spotdown.org.mp3", file="FearHubJukebox_31_KingOfWatchesVictor.mp3"},
        {name="Don Dimadon", artist="Remp, Oscar Maydon, Victor Mendivil, Sintapia", url="https://file.garden/algLafWA1jk8WMfK/Don%20Dimadon_spotdown.org.mp3", file="FearHubJukebox_25_DonDimadon.mp3"},
        {name="Singapur (Remix)", artist="El Alfa, Chencho Corleone, Farruko, Justin Quiles, Myke Towers", url="https://file.garden/algLafWA1jk8WMfK/Singapur%20(Remix)_spotdown.org.mp3", file="FearHubJukebox_26_SingapurRemix.mp3"},
        {name="Without Me", artist="Eminem", url="https://file.garden/algLafWA1jk8WMfK/Without%20Me_spotdown.org.mp3", file="FearHubJukebox_27_WithoutMe.mp3"},
        {name="3 AM", artist="Jimmy Guzman, Omar Camacho", url="https://file.garden/algLafWA1jk8WMfK/3%20AM_spotdown.org.mp3", file="FearHubJukebox_28_3AM.mp3"},
        {name="STARGAZING", artist="Travis Scott", url="https://file.garden/algLafWA1jk8WMfK/STARGAZING_spotdown.org.mp3", file="FearHubJukebox_29_Stargazing.mp3"},
        {name="Gané", artist="Victor Mendivil, Gabito Ballesteros", url="https://file.garden/algLafWA1jk8WMfK/Gane%CC%81_spotdown.org.mp3", file="FearHubJukebox_30_Gane.mp3"},
        {name="Te Lo Doy", artist="Tiagz, El Malilla, El Bogueto", url="https://file.garden/algLafWA1jk8WMfK/Te%20Lo%20Doy_spotdown.org.mp3", file="FearHubJukebox_32_TeLoDoy.mp3"},
        {name="Gramos", artist="Jimmy Guzman", url="https://file.garden/algLafWA1jk8WMfK/Gramos_spotdown.org.mp3", file="FearHubJukebox_33_Gramos.mp3"},
        {name="GOET", artist="Victor Mendivil", url="https://file.garden/algLafWA1jk8WMfK/GOET_spotdown.org.mp3", file="FearHubJukebox_34_GOET.mp3"},
        {name="Mercenarios", artist="Capo, Victor Mendivil", url="https://file.garden/algLafWA1jk8WMfK/Mercenarios_spotdown.org.mp3", file="FearHubJukebox_35_Mercenarios.mp3"},
        {name="Emparejé", artist="Russo, Luis R Conriquez", url="https://file.garden/algLafWA1jk8WMfK/Empareje%CC%81_spotdown.org.mp3", file="FearHubJukebox_36_Empareje.mp3"},
        {name="squabble up", artist="Kendrick Lamar", url="https://file.garden/algLafWA1jk8WMfK/squabble%20up_spotdown.org.mp3", file="FearHubJukebox_37_SquabbleUp.mp3"},
        {name="ROSA PASTEL", artist="Peso Pluma, Jasiel Nuñez", url="https://file.garden/algLafWA1jk8WMfK/ROSA%20PASTEL_spotdown.org.mp3", file="FearHubJukebox_38_RosaPastel.mp3"},
        {name="LUNA", artist="Peso Pluma, Junior H", url="https://file.garden/algLafWA1jk8WMfK/LUNA_spotdown.org.mp3", file="FearHubJukebox_39_Luna.mp3"},
        {name="NUEVA VIDA", artist="Peso Pluma", url="https://file.garden/algLafWA1jk8WMfK/NUEVA%20VIDA_spotdown.org.mp3", file="FearHubJukebox_40_NuevaVida.mp3"},
        {name="Juan Martha", artist="La Original Banda El Limón de Salvador Lizárraga, Julio Preciado", url="https://file.garden/algLafWA1jk8WMfK/Juan%20Martha_spotdown.org.mp3", file="FearHubJukebox_41_JuanMartha.mp3"},
        {name="Rojo Vivo", artist="Jesus Parra", url="https://file.garden/algLafWA1jk8WMfK/Rojo%20Vivo_spotdown.org.mp3", file="FearHubJukebox_42_RojoVivo.mp3"},
        {name="Vuelvo Mejor - Remix", artist="NTG, Arcángel", url="https://file.garden/algLafWA1jk8WMfK/Vuelvo%20Mejor%20-%20Remix_spotdown.org.mp3", file="FearHubJukebox_43_VuelvoMejorRemix.mp3"},
        {name="DEMBOW BÉLICO", artist="Tito Double P, Joel De La P, Luis R Conriquez", url="https://file.garden/algLafWA1jk8WMfK/DEMBOW%20BE%CC%81LICO_spotdown.org.mp3", file="FearHubJukebox_44_DembowBelico.mp3"},
        {name="No Nací Para Caerle Bien", artist="La Santa Grifa", url="https://file.garden/algLafWA1jk8WMfK/No%20Naci%CC%81%20Para%20Caerle%20Bien_spotdown.org.mp3", file="FearHubJukebox_45_NoNaciParaCaerleBien.mp3"},
        {name="Alaska", artist="Victor Mendivil, Hades66", url="https://file.garden/algLafWA1jk8WMfK/Alaska_spotdown.org.mp3", file="FearHubJukebox_46_Alaska.mp3"},
        {name="Tony Montana", artist="Victor Mendivil, Yng Lvcas", url="https://file.garden/algLafWA1jk8WMfK/Tony%20Montana_spotdown.org.mp3", file="FearHubJukebox_47_TonyMontana.mp3"},
        {name="Amnesia", artist="La Santa Grifa", url="https://file.garden/algLafWA1jk8WMfK/Amnesia_spotdown.org.mp3", file="FearHubJukebox_48_Amnesia.mp3"},
        {name="Mal Ejemplo", artist="La Santa Grifa", url="https://file.garden/algLafWA1jk8WMfK/Mal%20Ejemplo_spotdown.org.mp3", file="FearHubJukebox_49_MalEjemplo.mp3"},
        {name="Cholo 2", artist="Victor Mendivil, Eladio Carrion", url="https://file.garden/algLafWA1jk8WMfK/Cholo%202_spotdown.org.mp3", file="FearHubJukebox_50_Cholo2.mp3"},
        {name="OLIVIA LA FLAKA", artist="Natanael Cano, Tito Double P, Victor Mendivil, Ovi", url="https://file.garden/algLafWA1jk8WMfK/SpotiDownloader.com%20-%20OLIVIA%20LA%20FLAKA%20-%20Natanael%20Cano.mp3", file="FearHubJukebox_51_OliviaLaFlaka.mp3"},
        {name="redrum", artist="21 Savage", url="https://file.garden/algLafWA1jk8WMfK/redrum_spotdown.org%202.mp3", file="Bless_Redrum.mp3"},
        {name="Paris Hilton", artist="$HUPE, Victor Mendivil", url="https://file.garden/algLafWA1jk8WMfK/Paris%20Hilton_spotdown.org.mp3", file="Bless_ParisHilton.mp3"},
        {name="Dandy Hats", artist="El Rabbanito", url="https://file.garden/algLafWA1jk8WMfK/Dandy%20Hats_spotdown.org.mp3", file="Bless_DandyHats.mp3"},
        {name="Mi Terre CLN", artist="Fuerza Regida, Juanpa Salazar", url="https://file.garden/algLafWA1jk8WMfK/Mi%20Terre%20CLN_spotdown.org.mp3", file="Bless_MiTerreCLN.mp3"},
        {name="NAQUETO", artist="Yng Lvcas", url="https://file.garden/algLafWA1jk8WMfK/NAQUETO_spotdown.org.mp3", file="Bless_Naqueto.mp3"},
    }
    local candyJukebox = {sound=nil, index=1, token=0, volume=0.85, loading=false, paused=false}
    local candyNowTitle, candyNowStatus, candyPlayButton, candyVolumeText
    local candySongRows = {}

    local function refreshCandyJukebox()
        local track = candyJukeboxSongs[candyJukebox.index]
        if candyNowTitle then candyNowTitle.Text = track and (track.name or "Canción") or "Elige una canción" end
        if candyNowStatus then
            if candyJukebox.loading then
                candyNowStatus.Text = "Cargando canción..."
            elseif candyJukebox.playing then
                candyNowStatus.Text = track and (track.artist or "Reproduciendo") or "Reproduciendo"
            elseif candyJukebox.paused then
                candyNowStatus.Text = "Pausado"
            else
                candyNowStatus.Text = track and (track.artist or "Lista de Candy") or "Lista de Candy"
            end
        end
        if candyPlayButton then candyPlayButton.Text = candyJukebox.playing and "Ⅱ" or "▶" end
        if candyVolumeText then candyVolumeText.Text = string.format("%d%%", math.floor(candyJukebox.volume * 100 + 0.5)) end
        for index, entry in ipairs(candySongRows) do
            local selected = index == candyJukebox.index
            if entry.title and entry.title.Parent then entry.title.TextColor3 = selected and getThemeColor() or WHITE end
            if entry.row and entry.row.Parent then entry.row.BackgroundTransparency = selected and 0 or 0.06 end
        end
    end

    stopCandyJukebox = function()
        candyJukebox.token = candyJukebox.token + 1
        local oldSound = candyJukebox.sound
        candyJukebox.sound = nil
        candyJukebox.playing = false
        candyJukebox.paused = false
        candyJukebox.loading = false
        if oldSound then
            pcall(function() oldSound:Stop() end)
            pcall(function() oldSound:Destroy() end)
        end
        refreshCandyJukebox()
    end

    local function playCandyJukebox(index)
        index = math.clamp(math.floor(tonumber(index) or 1), 1, #candyJukeboxSongs)
        local track = candyJukeboxSongs[index]
        if not track then return end
        stopK7DuelsFullRedrum()
        stopCandyJukebox()
        candyJukebox.index = index
        candyJukebox.loading = true
        local token = candyJukebox.token
        refreshCandyJukebox()
        task.spawn(function()
            local ok, result = pcall(function()
                local loader = getcustomasset or getsynasset
                assert(type(loader) == "function" and type(writefile) == "function", "El executor requiere getcustomasset/getsynasset y writefile")
                local file = track.file or ("K7Duels_Candy_" .. tostring(index) .. ".mp3")
                local exists = false
                if type(isfile) == "function" then
                    local okExists, hasFile = pcall(isfile, file)
                    exists = okExists and hasFile == true
                end
                if not exists then
                    local data = game:HttpGet(track.url, true)
                    assert(type(data) == "string" and #data > 256, "No se pudo descargar " .. tostring(track.name))
                    local okWrite, writeResult = pcall(writefile, file, data)
                    assert(okWrite and writeResult ~= false, "No se pudo guardar " .. tostring(track.name))
                end
                local okAsset, asset = pcall(loader, file)
                assert(okAsset and type(asset) == "string" and asset ~= "", "No se pudo cargar el audio local")
                local sound = Instance.new("Sound")
                sound.Name = "K7DuelsCandyJukebox"
                sound.SoundId = asset
                sound.Volume = candyJukebox.volume
                sound.Looped = false
                sound.Parent = SoundService
                if track.startAt then pcall(function() sound.TimePosition = track.startAt end) end
                return sound
            end)
            if token ~= candyJukebox.token then
                if ok and result then pcall(function() result:Destroy() end) end
                return
            end
            candyJukebox.loading = false
            if not ok or not result then
                refreshCandyJukebox()
                warn("[K7 DUELS Music] " .. tostring(result))
                return
            end
            local sound = result
            candyJukebox.sound = sound
            sound.Ended:Connect(function()
                if candyJukebox.sound ~= sound then return end
                candyJukebox.sound = nil
                candyJukebox.playing = false
                candyJukebox.paused = false
                pcall(function() sound:Destroy() end)
                local nextIndex = candyJukebox.index % #candyJukeboxSongs + 1
                task.defer(function() playCandyJukebox(nextIndex) end)
            end)
            pcall(function() sound:Play() end)
            candyJukebox.playing = true
            candyJukebox.paused = false
            refreshCandyJukebox()
        end)
    end

    local nowRow = mkRow(musicPage, 48)
    candyNowTitle = K7DuelsUI.text(nowRow, "Elige una canción", UDim2.fromOffset(10, 4), UDim2.new(1, -20, 0, 20), 11, WHITE, 9)
    candyNowTitle.Font = Enum.Font.GothamBold
    candyNowStatus = K7DuelsUI.text(nowRow, "Lista de Candy", UDim2.fromOffset(10, 25), UDim2.new(1, -20, 0, 16), 8, Color3.fromRGB(170, 173, 180), 9)

    local controlRow = mkRow(musicPage, 42)
    local function makeCandyControl(text, slot, callback)
        local button = K7DuelsUI.new("TextButton", controlRow, {Size = UDim2.new(0.25, -5, 1, -8),
            Position = UDim2.new((slot - 1) * 0.25, 4, 0, 4), Text = text, TextSize = 15,
            Font = Enum.Font.GothamBold, TextColor3 = WHITE, BackgroundColor3 = INP,
            BorderSizePixel = 0, AutoButtonColor = false, ZIndex = 9})
        K7DuelsUI.round(button, 8)
        K7DuelsUI.stroke(button, getThemeColor(), 0.55, 1)
        button.Activated:Connect(callback)
        return button
    end
    makeCandyControl("◀", 1, function()
        local index = candyJukebox.index - 1
        if index < 1 then index = #candyJukeboxSongs end
        playCandyJukebox(index)
    end)
    candyPlayButton = makeCandyControl("▶", 2, function()
        if candyJukebox.loading then return end
        local sound = candyJukebox.sound
        if not sound then
            playCandyJukebox(candyJukebox.index)
        elseif candyJukebox.playing then
            pcall(function() sound:Pause() end)
            candyJukebox.playing = false
            candyJukebox.paused = true
            refreshCandyJukebox()
        else
            local okResume = pcall(function() sound:Resume() end)
            if not okResume then pcall(function() sound:Play() end) end
            candyJukebox.playing = true
            candyJukebox.paused = false
            refreshCandyJukebox()
        end
    end)
    makeCandyControl("▶▶", 3, function()
        local index = candyJukebox.index % #candyJukeboxSongs + 1
        playCandyJukebox(index)
    end)
    makeCandyControl("■", 4, stopCandyJukebox)

    local volumeRow = mkRow(musicPage, 40)
    K7DuelsUI.text(volumeRow, "VOLUMEN", UDim2.fromOffset(10, 0), UDim2.new(0.48, -10, 1, 0), 9, WHITE, 8)
    candyVolumeText = K7DuelsUI.text(volumeRow, "85%", UDim2.new(0.50, -12, 0, 0), UDim2.new(0.20, 24, 1, 0), 9, WHITE, 8)
    candyVolumeText.TextXAlignment = Enum.TextXAlignment.Center
    local function makeVolumeButton(text, position, change)
        local button = K7DuelsUI.new("TextButton", volumeRow, {Size = UDim2.fromOffset(30, 28),
            Position = position, Text = text, TextSize = 16, Font = Enum.Font.GothamBold,
            TextColor3 = WHITE, BackgroundColor3 = INP, BorderSizePixel = 0, AutoButtonColor = false, ZIndex = 9})
        K7DuelsUI.round(button, 7)
        button.Activated:Connect(function()
            candyJukebox.volume = math.clamp(candyJukebox.volume + change, 0, 1.5)
            if candyJukebox.sound then candyJukebox.sound.Volume = candyJukebox.volume end
            refreshCandyJukebox()
        end)
    end
    makeVolumeButton("−", UDim2.new(1, -76, 0.5, -14), -0.1)
    makeVolumeButton("+", UDim2.new(1, -40, 0.5, -14), 0.1)

    local searchRow = mkRow(musicPage, 40)
    local candySearch = K7DuelsUI.new("TextBox", searchRow, {Size = UDim2.new(1, -12, 1, -8),
        Position = UDim2.fromOffset(6, 4), Text = "", PlaceholderText = "Buscar canción o artista",
        PlaceholderColor3 = Color3.fromRGB(150, 150, 158), TextColor3 = WHITE, TextSize = 10,
        Font = Enum.Font.Gotham, TextXAlignment = Enum.TextXAlignment.Left, ClearTextOnFocus = false,
        BackgroundColor3 = INP, BorderSizePixel = 0, ZIndex = 9})
    K7DuelsUI.round(candySearch, 7)
    K7DuelsUI.new("UIPadding", candySearch, {PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 8)})

    for index, track in ipairs(candyJukeboxSongs) do
        local row = mkRow(musicPage, 46)
        row.Name = "CandySong_" .. tostring(index)
        local title = K7DuelsUI.text(row, string.format("%02d  %s", index, track.name), UDim2.fromOffset(9, 3), UDim2.new(1, -18, 0, 20), 9, WHITE, 8)
        title.Font = Enum.Font.GothamBold
        local artist = K7DuelsUI.text(row, track.artist or "", UDim2.fromOffset(9, 23), UDim2.new(1, -18, 0, 16), 7, Color3.fromRGB(170, 173, 180), 8)
        local hit = K7DuelsUI.new("TextButton", row, {Size = UDim2.fromScale(1, 1), Text = "",
            BackgroundTransparency = 1, AutoButtonColor = false, ZIndex = 10})
        hit.Activated:Connect(function() playCandyJukebox(index) end)
        candySongRows[index] = {row=row, title=title, artist=artist, button=hit, data=track}
    end
    candySearch:GetPropertyChangedSignal("Text"):Connect(function()
        local query = string.lower(candySearch.Text or "")
        for _, entry in ipairs(candySongRows) do
            local haystack = string.lower(tostring(entry.data.name or "") .. " " .. tostring(entry.data.artist or ""))
            entry.row.Visible = query == "" or string.find(haystack, query, 1, true) ~= nil
        end
    end)
    refreshCandyJukebox()

    mkSect(configPage, "Management")
    do
        local row = mkRow(configPage, 44)
        row.Size = UDim2.new(1, 0, 0, 44)
        local saveBtn = Instance.new("TextButton", row)
        saveBtn.Size = UDim2.new(1, -12, 0.8, 0)
        saveBtn.Position = UDim2.new(0, 6, 0.1, 0)
        saveBtn.BackgroundColor3 = Color3.fromRGB(27, 30, 33)
        saveBtn.BorderSizePixel = 0
        saveBtn.Text = "SAVE CONFIG"
        saveBtn.TextColor3 = Color3.fromRGB(235, 238, 242)
        saveBtn.Font = Enum.Font.GothamBold
        saveBtn.TextSize = 13
        saveBtn.AutoButtonColor = false
        saveBtn.ZIndex = 8
        Instance.new("UICorner", saveBtn).CornerRadius = UDim.new(0, 6)
        local saveStroke = Instance.new("UIStroke", saveBtn)
        saveStroke.Color = getThemeColor()
        saveStroke.Thickness = 1.5
        saveStroke.Transparency = 0.4
        saveBtn.MouseEnter:Connect(function()
            TS:Create(saveBtn, TweenInfo.new(0.15), {BackgroundColor3 = getThemeColor()}):Play()
            TS:Create(saveBtn, TweenInfo.new(0.15), {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
        end)
        saveBtn.MouseLeave:Connect(function()
            TS:Create(saveBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(27, 30, 33)}):Play()
            TS:Create(saveBtn, TweenInfo.new(0.15), {TextColor3 = Color3.fromRGB(235, 238, 242)}):Play()
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
        local row = mkRow(configPage, 44)
        row.Size = UDim2.new(1, 0, 0, 44)
        local resetPosBtn = Instance.new("TextButton", row)
        resetPosBtn.Size = UDim2.new(1, -12, 0.8, 0)
        resetPosBtn.Position = UDim2.new(0, 6, 0.1, 0)
        resetPosBtn.BackgroundColor3 = Color3.fromRGB(27, 30, 33)
        resetPosBtn.BorderSizePixel = 0
        resetPosBtn.Text = "RESET POSITIONS"
        resetPosBtn.TextColor3 = Color3.fromRGB(235, 238, 242)
        resetPosBtn.Font = Enum.Font.GothamBold
        resetPosBtn.TextSize = 13
        resetPosBtn.AutoButtonColor = false
        resetPosBtn.ZIndex = 8
        Instance.new("UICorner", resetPosBtn).CornerRadius = UDim.new(0, 6)
        local resetStroke = Instance.new("UIStroke", resetPosBtn)
        resetStroke.Color = getThemeColor()
        resetStroke.Thickness = 1.5
        resetStroke.Transparency = 0.4
        resetPosBtn.MouseEnter:Connect(function()
            TS:Create(resetPosBtn, TweenInfo.new(0.15), {BackgroundColor3 = getThemeColor()}):Play()
            TS:Create(resetPosBtn, TweenInfo.new(0.15), {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
        end)
        resetPosBtn.MouseLeave:Connect(function()
            TS:Create(resetPosBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(27, 30, 33)}):Play()
            TS:Create(resetPosBtn, TweenInfo.new(0.15), {TextColor3 = Color3.fromRGB(235, 238, 242)}):Play()
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
    do
        local row = mkRow(configPage, 44)
        row.Size = UDim2.new(1, 0, 0, 44)
        local delBtn = Instance.new("TextButton", row)
        delBtn.Size = UDim2.new(1, -12, 0.8, 0)
        delBtn.Position = UDim2.new(0, 6, 0.1, 0)
        delBtn.BackgroundColor3 = Color3.fromRGB(27, 30, 33)
        delBtn.BorderSizePixel = 0
        delBtn.Text = "RESET ALL SETTINGS"
        delBtn.TextColor3 = Color3.fromRGB(220, 205, 235)
        delBtn.Font = Enum.Font.GothamBold
        delBtn.TextSize = 13
        delBtn.AutoButtonColor = false
        delBtn.ZIndex = 8
        Instance.new("UICorner", delBtn).CornerRadius = UDim.new(0, 6)
        local delStroke = Instance.new("UIStroke", delBtn)
        delStroke.Color = Color3.fromRGB(240, 240, 245)
        delStroke.Thickness = 1.5
        delStroke.Transparency = 0.4
        delBtn.MouseEnter:Connect(function()
            TS:Create(delBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(240, 240, 245)}):Play()
            TS:Create(delBtn, TweenInfo.new(0.15), {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
        end)
        delBtn.MouseLeave:Connect(function()
            TS:Create(delBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(27, 30, 33)}):Play()
            TS:Create(delBtn, TweenInfo.new(0.15), {TextColor3 = Color3.fromRGB(220, 205, 235)}):Play()
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
                delBtn.TextColor3 = Color3.fromRGB(48, 48, 49)
                task.delay(2, function()
                    if delBtn and delBtn.Parent and deleteState == 1 then
                        deleteState = 0
                        delBtn.Text = originalDeleteText
                        delBtn.BackgroundColor3 = Color3.fromRGB(27, 30, 33)
                        delBtn.TextColor3 = Color3.fromRGB(220, 205, 235)
                    end
                end)
            elseif deleteState == 1 then
                delDebounce = true
                local invoked, success = pcall(resetToFactoryDefaults)
                success = invoked and success
                delBtn.Text = success and "SETTINGS RESET" or "ERROR"
                delBtn.BackgroundColor3 = Color3.fromRGB(27, 30, 33)
                delBtn.TextColor3 = Color3.fromRGB(220, 205, 235)
                deleteState = 0
                task.delay(1.5, function()
                    if delBtn and delBtn.Parent then
                        delBtn.Text = originalDeleteText
                        delBtn.BackgroundColor3 = Color3.fromRGB(27, 30, 33)
                        delBtn.TextColor3 = Color3.fromRGB(220, 205, 235)
                        delDebounce = false
                    end
                end)
            end
        end)
    end

    local keyPage = contentPages["Keybinds"]
    mkSect(keyPage, "Keybinds")
    mkSect(keyPage, "Movement")
    addKeybindRow(keyPage, "Carry Mode", KB.CarryToggle)
    addKeybindRow(keyPage, "Lagger Mode", KB.LaggerMode)
    addKeybindRow(keyPage, "Auto Left", KB.AutoLeft)
    addKeybindRow(keyPage, "Auto Right", KB.AutoRight)
    addKeybindRow(keyPage, "Float", KB.Float)
    addKeybindRow(keyPage, "Insta Reset", KB.InstaReset)

    mkSect(keyPage, "Combat")
    addKeybindRow(keyPage, "Bat Bypass", KB.AutoBat)

    mkSect(keyPage, "Utility")
    addKeybindRow(keyPage, "Drop Brainrot", KB.DropBrainrot)
    addKeybindRow(keyPage, "TP Down", KB.TPFloor)
    addKeybindRow(keyPage, "Hide GUI", KB.GuiHide)

    local spacer = Instance.new("Frame", keyPage)
    spacer.Size = UDim2.new(1, 0, 0, 16)
    spacer.BackgroundTransparency = 1
    spacer.LayoutOrder = getNextOrder(keyPage)
    spacer.ZIndex = 7

    -- Auto Grab HUD · réplica exacta del HUD de 404 (top bar + barra de progreso)
    do
        local HudGui = Instance.new("ScreenGui")
        HudGui.Name = "K7Duels_404StyleHUD"
        HudGui.ResetOnSpawn = false
        HudGui.IgnoreGuiInset = true
        HudGui.DisplayOrder = 15
        HudGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        pcall(function() if syn and syn.protect_gui then syn.protect_gui(HudGui) end end)
        local okParent = pcall(function() HudGui.Parent = game:GetService("CoreGui") end)
        if not okParent then HudGui.Parent = gui end

        -- Top bar (FPS / PING) como 404
        local topBar = Instance.new("Frame")
        topBar.Name = "TopBarHUD"
        topBar.Size = UDim2.new(0, 235, 0, 29)
        topBar.Position = UDim2.new(0.5, -117.5, 0, 12)
        topBar.BackgroundColor3 = Color3.fromRGB(8, 8, 10)
        topBar.BackgroundTransparency = 0.25
        topBar.BorderSizePixel = 0
        topBar.Visible = true
        topBar.Parent = HudGui
        Instance.new("UICorner", topBar).CornerRadius = UDim.new(0, 9)
        local topStroke = Instance.new("UIStroke", topBar)
        topStroke.Thickness = 1.3
        topStroke.Color = Color3.fromRGB(255, 255, 255)
        topStroke.Transparency = 0.88
        local topLabel = Instance.new("TextLabel", topBar)
        topLabel.Size = UDim2.new(1, -10, 1, 0)
        topLabel.Position = UDim2.new(0, 5, 0, 0)
        topLabel.BackgroundTransparency = 1
        topLabel.Text = "K7 DUELS | FPS: 0 PING: 0ms"
        topLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        topLabel.Font = Enum.Font.GothamBold
        topLabel.TextSize = 12.5
        topLabel.TextStrokeTransparency = 0.6
        topLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        topLabel.TextScaled = false
        topLabel.ClipsDescendants = true
        topLabel.ZIndex = 2

        -- Barra de progreso auto grab (idéntica a 404)
        pbFrame = Instance.new("Frame")
        pbFrame.Name = "K7DuelsAutoStealHud"
        pbFrame.Size = UDim2.new(0, 235, 0, 15)
        pbFrame.Position = UDim2.new(0.5, -117.5, 0, 38)
        pbFrame.BackgroundColor3 = Color3.fromRGB(8, 8, 10)
        pbFrame.BackgroundTransparency = 0.35
        pbFrame.BorderSizePixel = 0
        pbFrame.Visible = true
        pbFrame.ClipsDescendants = true
        pbFrame.Active = false
        pbFrame.ZIndex = 50
        pbFrame.Parent = HudGui
        Instance.new("UICorner", pbFrame).CornerRadius = UDim.new(0, 6)
        local progStroke = Instance.new("UIStroke", pbFrame)
        progStroke.Name = "OuterStroke"
        progStroke.Thickness = 1.1
        progStroke.Color = Color3.fromRGB(255, 255, 255)
        progStroke.Transparency = 0.88

        progressFill = Instance.new("Frame", pbFrame)
        progressFill.Name = "StealProgressFill"
        progressFill.Size = UDim2.new(0, 0, 1, 0)
        progressFill.Position = UDim2.new(0, 0, 0, 0)
        progressFill.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        progressFill.BorderSizePixel = 0
        progressFill.ZIndex = 51
        Instance.new("UICorner", progressFill).CornerRadius = UDim.new(0, 4)

        progressPct = Instance.new("TextLabel", pbFrame)
        progressPct.Name = "StealProgressPercent"
        progressPct.Size = UDim2.new(1, 0, 1, 0)
        progressPct.BackgroundTransparency = 1
        progressPct.Text = "0%"
        progressPct.TextColor3 = Color3.fromRGB(0, 0, 0)
        progressPct.Font = Enum.Font.GothamBold
        progressPct.TextSize = 10.5
        progressPct.TextStrokeTransparency = 0.7
        progressPct.TextXAlignment = Enum.TextXAlignment.Center
        progressPct.TextYAlignment = Enum.TextYAlignment.Center
        progressPct.ZIndex = 52

        progressStatus = nil
        stealHud.mode = nil
        stealHud.stats = nil
        K7DuelsUI.hudScale = Instance.new("UIScale")
        K7DuelsUI.hudScale.Scale = 1
        K7DuelsUI.hudScale.Parent = pbFrame

        -- Actualizar FPS / PING en la top bar (como 404)
        do
            local frameCount, lastT, hudTimer = 0, tick(), 0
            RunService.RenderStepped:Connect(function()
                frameCount = frameCount + 1
            end)
            RunService.Heartbeat:Connect(function(dt)
                hudTimer = hudTimer + dt
                if hudTimer < 0.5 then return end
                hudTimer = 0
                local now = tick()
                local fps = math.floor(frameCount / math.max(now - lastT, 0.001) + 0.5)
                frameCount, lastT = 0, now
                local ping = 0
                pcall(function() ping = math.floor(LP:GetNetworkPing() * 1000) end)
                if topLabel and topLabel.Parent then
                    topLabel.Text = "K7 DUELS | FPS: " .. tostring(fps) .. " PING: " .. tostring(ping) .. "ms"
                end
            end)
        end

        updateStealProgress(stealHud.value, stealHud.state)
        -- Fija en posición 404; no se puede arrastrar
        topBar.Active = false
        pbFrame.Active = false
        K7DuelsUI.topBarHUD = topBar
    end
    K7DuelsUI.fit()
    do
        local viewConnection
        local function followCamera()
            if viewConnection then viewConnection:Disconnect() end
            local cam = Workspace.CurrentCamera
            if cam then viewConnection = cam:GetPropertyChangedSignal("ViewportSize"):Connect(K7DuelsUI.fit) end
            K7DuelsUI.fit()
        end
        local cameraConnection = Workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(followCamera)
        followCamera()
        gui.Destroying:Connect(function()
            cameraConnection:Disconnect()
            if viewConnection then viewConnection:Disconnect() end
        end)
    end
    K7DuelsUI.effectsLoop(gui)
    task.spawn(function() pcall(function() game:GetService("ContentProvider"):PreloadAsync({bg}) end) end)
end

function createMobilePanel()
    local panel = Instance.new("ScreenGui")
    panel.Name = "K7DuelsMobilePanel"
    panel.ResetOnSpawn = false
    panel.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    panel.IgnoreGuiInset = true
    panel.DisplayOrder = 40
    pcall(function() if syn and syn.protect_gui then syn.protect_gui(panel) end end)
    local okPanel = pcall(function() panel.Parent = game:GetService("CoreGui") end)
    if not okPanel then panel.Parent = LP:WaitForChild("PlayerGui") end

    local BTN_W, BTN_H = 60, 60
    local buttons = {}
    local buttonNames = {"DropBR", "AutoLeft", "AutoBat", "AutoRight", "TpDown", "Carry", "Lagger1", "Lagger2", "Float", "InstaReset"}
    local buttonTexts = {"DROP\nBR", "AUTO\nLEFT", "BAT\nBYPASS", "AUTO\nRIGHT", "TP\nDOWN", "CARRY\nSPD", "LAGGER\nNORMAL", "LAGGER\nCARRY", "FLOAT", "INSTA\nRESET"}

    local function createButton(name, text, order, isToggle, callback)
        local btn = K7DuelsUI.new("TextButton", panel, {Name = name, Size = UDim2.fromOffset(BTN_W, BTN_H),
            BackgroundColor3 = Color3.fromRGB(0, 0, 0), BorderSizePixel = 0, Text = "",
            AutoButtonColor = false, Active = true, ZIndex = 10})
        local saved = savedButtonPositions[name]
        local x, y = getDefaultButtonPosition(name)
        btn.Position = UDim2.fromOffset(saved and tonumber(saved.X) or x, saved and tonumber(saved.Y) or y)
-- Estilo Clover/Movee: botones negros sólidos, borde gris, activo plateado
        K7DuelsUI.round(btn, 18)
        btn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        btn.BackgroundTransparency = 0.05
        local bgGrad = Instance.new("UIGradient", btn)
        bgGrad.Name = "BtnGrad"
        bgGrad.Enabled = false
        bgGrad.Rotation = 90
        bgGrad.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0.00, Color3.fromRGB(0, 0, 0)),
            ColorSequenceKeypoint.new(1.00, Color3.fromRGB(0, 0, 0)),
        })
        local stroke = K7DuelsUI.stroke(btn, Color3.fromRGB(82, 82, 88), 0, 1.1)
        if stroke then
            stroke.Name = "BtnStroke"
            stroke.Transparency = 0
            stroke.Thickness = 1.1
            pcall(function() stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border end)
        end
        local label = K7DuelsUI.text(btn, text, UDim2.fromScale(0, 0), UDim2.fromScale(1, 1), 12,
            Color3.fromRGB(255, 255, 255), 10)
        label.Name = "TextLabel"
        label.Font = Enum.Font.GothamBlack
        label.TextXAlignment = Enum.TextXAlignment.Center
        label.TextYAlignment = Enum.TextYAlignment.Center
        label.TextWrapped = true
        label.TextStrokeTransparency = 1
        local scale = K7DuelsUI.new("UIScale", btn, {Scale = floatingButtonScale})
        table.insert(_floatingUIScales, scale)
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
            K7DuelsUI.activeInput = nil
            _isDraggingButton = false
            TS:Create(scale, TweenInfo.new(0.12), {Scale = floatingButtonScale}):Play()
            if moved < 8 then
                local ok, err = pcall(callback, setActive, active)
                if not ok then warn("[K7 DUELS Button] " .. name .. ": " .. tostring(err)) end
            elseif not uiLocked and not mobileButtonsLocked then
                savedButtonPositions[name] = {X = btn.Position.X.Offset, Y = btn.Position.Y.Offset}
            end
            paintFloatingBtn(btn, active)
            pcall(saveAllSettings)
        end
        btn.InputBegan:Connect(function(input)
            if K7DuelsUI.activeInput then return end
            if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then return end
            pointer, dragStart, origin, moved = input, input.Position, btn.Position, 0
            K7DuelsUI.activeInput = input
            _isDraggingButton = true
            TS:Create(scale, TweenInfo.new(0.09), {Scale = floatingButtonScale * 0.95}):Play()
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
            if pointer then K7DuelsUI.activeInput = nil; _isDraggingButton = false end
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
                setActive(autoBatEnabled)
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
                if _G.__K7DuelsApplySpeedNow then pcall(_G.__K7DuelsApplySpeedNow) end
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
                if _G.__K7DuelsApplySpeedNow then pcall(_G.__K7DuelsApplySpeedNow) end
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
                if _G.__K7DuelsApplySpeedNow then pcall(_G.__K7DuelsApplySpeedNow) end
            end
        elseif name == "Float" then
            callback = function(setActive)
                if _G.__RivalHubFloatToggle then
                    _G.__RivalHubFloatToggle()
                    setActive(_G.__RivalHubFloatIsRunning and _G.__RivalHubFloatIsRunning() or false)
                end
            end
        elseif name == "InstaReset" then
            callback = function(setActive)
                setActive(true)
                if _G.InstaReset and _G.InstaReset.Trigger then _G.InstaReset.Trigger() end
                task.delay(0.2, function() setActive(false) end)
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
        if name == "Float" then mobSetFloat = setActive end
        if name == "InstaReset" then mobSetInstaReset = setActive end
    end

    if buttons.AutoBat and buttons.AutoBat.setActive then buttons.AutoBat.setActive(autoBatEnabled) end
    if buttons.AutoLeft and buttons.AutoLeft.setActive then buttons.AutoLeft.setActive(autoLeftEnabled) end
    if buttons.AutoRight and buttons.AutoRight.setActive then buttons.AutoRight.setActive(autoRightEnabled) end
    if buttons.Carry and buttons.Carry.setActive then buttons.Carry.setActive(speedMode) end
    if buttons.Lagger1 and buttons.Lagger1.setActive then buttons.Lagger1.setActive(laggerToggled) end
    if buttons.Lagger2 and buttons.Lagger2.setActive then buttons.Lagger2.setActive(laggerCarryToggled) end
        if buttons.Float and buttons.Float.setActive then
        buttons.Float.setActive(_G.__RivalHubFloatIsRunning and _G.__RivalHubFloatIsRunning() or false)
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

    if pbFrame then
        -- Siempre fija como 404 (no se restaura posición guardada)
        pbFrame.Position = UDim2.new(0.5, -117.5, 0, 38)
        if K7DuelsUI.topBarHUD and K7DuelsUI.topBarHUD.Parent then
            K7DuelsUI.topBarHUD.Position = UDim2.new(0.5, -117.5, 0, 12)
        end
    end

    applyBackgroundMode(backgroundMode)
    applyFloatingButtonScale()
    if K7DuelsUI.fit then K7DuelsUI.fit() end
    if K7DuelsUI.motorLabel then K7DuelsUI.motorLabel.Text = useVenixCarryEngine and "Carry Boost" or "Direct" end
    if K7DuelsUI.carrySetter then K7DuelsUI.carrySetter(K7DuelsVenixCarry.softStealEnabled) end
    if K7DuelsUI.carrySpeedBox then K7DuelsUI.carrySpeedBox.Text = tostring(K7DuelsVenixCarry.softStealSpeed) end
    if K7DuelsUI.carryRadiusBox then K7DuelsUI.carryRadiusBox.Text = tostring(K7DuelsVenixCarry.softStealRadius) end
    if K7DuelsUI.effectsSetter then K7DuelsUI.effectsSetter(K7DuelsUI.effects) end
    if K7DuelsUI.lockButtonsSetter then K7DuelsUI.lockButtonsSetter(mobileButtonsLocked) end

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

    if false and spinEnabled then
        startSpin()
        if setSpinVisual then setSpinVisual(true) end
    else
        stopSpin()
        if setSpinVisual then setSpinVisual(false) end
    end
    if spinBrainrotEnabled then
        -- startSpinBrainrot() disabled
        if setSpinBrainrotVisual then setSpinBrainrotVisual(true) end
    else
        stopSpinBrainrot()
        if setSpinBrainrotVisual then setSpinBrainrotVisual(false) end
    end

    if mobSetAutoBat then mobSetAutoBat(autoBatEnabled) end
    if mobSetAutoLeft then mobSetAutoLeft(autoLeftEnabled) end
    if mobSetAutoRight then mobSetAutoRight(autoRightEnabled) end
    if mobSetCarry then mobSetCarry(speedMode) end
    if mobSetLagger1 then mobSetLagger1(laggerToggled) end
    if mobSetLagger2 then mobSetLagger2(laggerCarryToggled) end
    if mobSetBatV2 then mobSetBatV2(_G.__K7DuelsIsBatV2 and _G.__K7DuelsIsBatV2() or false) end
    if mobSetFloat then mobSetFloat(_G.__RivalHubFloatIsRunning and _G.__RivalHubFloatIsRunning() or false) end

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
    print("[K7 DUELS Boot] Iniciando:", name)
    local ok, err = pcall(fn)
    if not ok then
        print("[K7 DUELS Boot] FALLÓ:", name, tostring(err))
        table.insert(_bootErrors, {name = name, err = tostring(err)})
        warn("[K7 DUELS Boot] Error en '" .. name .. "': " .. tostring(err))
    else
        print("[K7 DUELS Boot] OK:", name)
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

    _bootSection("createMobilePanel", function()
        MobilePanel = createMobilePanel()
    if K7DuelsUI.applyFont then pcall(K7DuelsUI.applyFont, K7DuelsUI.fontName or "GothamBold", false) end
    if applyPerButtonVisibility then pcall(applyPerButtonVisibility) end
    end)

    if hideButtonsEnabled then
        _bootSection("applyHideButtons", function()
            applyHideButtons(true)
            if setHideButtonsVisual then setHideButtonsVisual(true) end
        end)
    end

    _bootSection("localizeK7DuelsInterface", function()
        if gui then localizeK7DuelsInterface(gui) end
        if MobilePanel then localizeK7DuelsInterface(MobilePanel) end
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
                    local log = "[K7Duels X Synlze Boot Errors] " .. os.date("%Y-%m-%d %H:%M:%S") .. "\n"
                    for _, e in ipairs(_bootErrors) do
                        log = log .. e.name .. ": " .. e.err .. "\n"
                    end
                    pcall(writeFn, "K7Duels_boot_errors.txt", log)
                    warn("[K7 DUELS] Errores escritos a K7Duels_boot_errors.txt")
                end
            end)
        end)

        task.defer(function()
            pcall(function()
                local errGui = Instance.new("ScreenGui")
                errGui.Name = "K7DuelsBootErrors"
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
                title.Text = "⚠ K7 DUELS: " .. #_bootErrors .. " sección(es) fallaron"
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
    warn("[K7 DUELS Boot] Fatal: buildGui falló. El script no puede continuar.")
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
    if kbMatch(KB.Float, kc) then
        if _G.__RivalHubFloatToggle then _G.__RivalHubFloatToggle() end
        return
    end
    if kbMatch(KB.InstaReset, kc) then
        if mobSetInstaReset then mobSetInstaReset(true) end
        if _G.InstaReset and _G.InstaReset.Trigger then _G.InstaReset.Trigger() end
        task.delay(0.2, function() if mobSetInstaReset then mobSetInstaReset(false) end end)
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
    -- TP Bat / BatV2 removed

    if kbMatch(KB.GuiHide, kc) then
        if main then
            if main.Visible then hideGui() else showGui() end
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
    local BatSkinPlayers = game:GetService("Players")
    local BatSkinLP = BatSkinPlayers.LocalPlayer

    -- Respeta la skin ya cargada desde el JSON (loadAllSettings corre antes que este módulo).
    _G.K7DuelsBatSkin = (type(_G.K7DuelsBatSkin) == "string" and _G.K7DuelsBatSkin ~= "") and _G.K7DuelsBatSkin or "WitchBroom"
    _G.K7DuelsBatSkinOrder = {
        "None", "WitchBroom", "Katana", "Baseball", "NeonBlade",
        "Hammer", "Scythe", "BoneClub", "CrystalSword", "CandyCane",
        "BanHammer", "Axe", "Trident", "Lightning", "PixelSword",
    }
    _G.K7DuelsBatSkinLabels = {
        None = "None",
        WitchBroom = "Witch Broom",
        Katana = "Katana",
        Baseball = "Baseball",
        NeonBlade = "Neon Blade",
        Hammer = "Hammer",
        Scythe = "Scythe",
        BoneClub = "Bone Club",
        CrystalSword = "Crystal",
        CandyCane = "Candy Cane",
        BanHammer = "Ban Hammer",
        Axe = "Axe",
        Trident = "Trident",
        Lightning = "Lightning",
        PixelSword = "Pixel Sword",
    }

    local function isBatTool(tool)
        if not tool or not tool:IsA("Tool") then return false end
        local name = tool.Name:lower()
        return name:find("bat", 1, true) ~= nil or name:find("slap", 1, true) ~= nil
            or name:find("sword", 1, true) ~= nil or name:find("espada", 1, true) ~= nil
    end

    local function clearBatSkin(tool)
        if not tool then return end
        local handle = tool:FindFirstChild("Handle")
        if handle then
            local old = handle:FindFirstChild("K7DuelsBatSkinReplica")
            if old then pcall(function() old:Destroy() end) end
            local old2 = handle:FindFirstChild("ShelSwordReplica")
            if old2 then pcall(function() old2:Destroy() end) end
        end
        for _, obj in ipairs(tool:GetDescendants()) do
            if obj:IsA("BasePart") then
                if obj:GetAttribute("K7DuelsBatOrigT") ~= nil then
                    pcall(function()
                        obj.Transparency = obj:GetAttribute("K7DuelsBatOrigT")
                        obj:SetAttribute("K7DuelsBatOrigT", nil)
                    end)
                end
                if obj:GetAttribute("K7DuelsBatOrigLTM") ~= nil then
                    pcall(function()
                        obj.LocalTransparencyModifier = obj:GetAttribute("K7DuelsBatOrigLTM")
                        obj:SetAttribute("K7DuelsBatOrigLTM", nil)
                    end)
                else
                    pcall(function() obj.LocalTransparencyModifier = 0 end)
                end
            end
        end
        local loose = tool:FindFirstChild("K7DuelsBatSkinReplica")
        if loose then pcall(function() loose:Destroy() end) end
    end

    local function hideOriginalParts(tool)
        if not tool then return end
        for _, obj in ipairs(tool:GetDescendants()) do
            if obj:IsA("BasePart") then
                if not (obj:FindFirstAncestor("K7DuelsBatSkinReplica") or obj:FindFirstAncestor("ShelSwordReplica")) then
                    if obj:GetAttribute("K7DuelsBatOrigT") == nil then
                        obj:SetAttribute("K7DuelsBatOrigT", obj.Transparency)
                    end
                    if obj:GetAttribute("K7DuelsBatOrigLTM") == nil then
                        obj:SetAttribute("K7DuelsBatOrigLTM", obj.LocalTransparencyModifier)
                    end
                    pcall(function()
                        obj.Transparency = 1
                        obj.LocalTransparencyModifier = 1
                    end)
                end
            end
        end
    end

    local CY = CFrame.Angles(0, 0, math.rad(90))
    local GRIP = CFrame.new()

    local function makePart(parent, handle, name, size, offsetCF, color, material, shape)
        local part = Instance.new("Part")
        part.Name = name
        part.Size = size
        part.Shape = shape or Enum.PartType.Block
        part.Color = color
        part.Material = material or Enum.Material.SmoothPlastic
        part.TopSurface = Enum.SurfaceType.Smooth
        part.BottomSurface = Enum.SurfaceType.Smooth
        part.Transparency = 0
        part.CanCollide = false
        part.CanTouch = false
        part.CanQuery = false
        part.CastShadow = false
        part.Massless = true
        part.Anchored = false
        part.Parent = parent
        local weld = Instance.new("Weld")
        weld.Name = "K7DuelsSkinWeld"
        weld.Part0 = handle
        weld.Part1 = part
        weld.C0 = GRIP * offsetCF
        weld.C1 = CFrame.new()
        weld.Parent = part
        return part
    end

    local function makeCyl(parent, handle, name, height, diameter, offsetCF, color, material)
        local size = Vector3.new(height, diameter, diameter)
        return makePart(parent, handle, name, size, offsetCF * CY, color, material, Enum.PartType.Cylinder)
    end

    local function makeBall(parent, handle, name, diameter, offsetCF, color, material)
        local d = diameter
        return makePart(parent, handle, name, Vector3.new(d, d, d), offsetCF, color, material, Enum.PartType.Ball)
    end

    local builders = {}

    builders.WitchBroom = function(model, handle)
        local base = CFrame.new(0, 0.55, 0) * CFrame.Angles(math.rad(270), math.rad(180), math.rad(180))
        local function bp(name, size, offset, rot, color, mat)
            local part = Instance.new("Part")
            part.Name = name
            part.Size = size
            part.Color = color
            part.Material = mat or Enum.Material.Wood
            part.Transparency = 0
            part.CanCollide = false
            part.CanTouch = false
            part.CanQuery = false
            part.CastShadow = false
            part.Massless = true
            part.Anchored = false
            part.Parent = model
            local weld = Instance.new("Weld")
            weld.Name = "K7DuelsSkinWeld"
            weld.Part0 = handle
            weld.Part1 = part
            weld.C0 = base * CFrame.new(offset) * CFrame.Angles(rot.X, rot.Y, rot.Z)
            weld.C1 = CFrame.new()
            weld.Parent = part
            return part
        end
        bp("BroomHandle", Vector3.new(0.14, 2.6, 0.14), Vector3.new(0, 0, 0), Vector3.new(0,0,0), Color3.fromRGB(92, 49, 24), Enum.Material.Wood)
        bp("BroomBinding", Vector3.new(0.26, 0.16, 0.26), Vector3.new(0, -1.15, 0), Vector3.new(0,0,0), Color3.fromRGB(65, 35, 20), Enum.Material.Wood)
        local strawColors = {
            Color3.fromRGB(168,112,47), Color3.fromRGB(190,132,58),
            Color3.fromRGB(145,91,37), Color3.fromRGB(205,151,72),
        }
        for i = -4, 4 do
            local spread, angle = i * 0.07, math.rad(i * 7)
            bp("StrawX"..i, Vector3.new(0.08, 0.85, 0.09), Vector3.new(spread, -1.6, 0), Vector3.new(0,0,angle), strawColors[(i+5)%#strawColors+1], Enum.Material.Wood)
        end
        for i = -2, 2 do
            bp("StrawZ"..i, Vector3.new(0.09, 0.8, 0.08), Vector3.new(0, -1.62, i*0.1), Vector3.new(math.rad(i*7),0,0), strawColors[(i+3)%#strawColors+1], Enum.Material.Wood)
        end
    end

    builders.Katana = function(model, handle)
        local green = Color3.fromRGB(255, 255, 255)
        local green2 = Color3.fromRGB(234, 234, 239)
        local gold = Color3.fromRGB(255, 210, 40)
        local dark = Color3.fromRGB(35, 35, 40)
        makeCyl(model, handle, "Hilt", 0.95, 0.18, CFrame.new(0, -0.35, 0), dark, Enum.Material.Metal)
        makePart(model, handle, "Blade", Vector3.new(0.12, 2.35, 0.05), CFrame.new(0, 1.15, 0), green, Enum.Material.Neon)
        makePart(model, handle, "Edge", Vector3.new(0.06, 2.3, 0.08), CFrame.new(0.06, 1.15, 0), green2, Enum.Material.Neon)
        makePart(model, handle, "Guard", Vector3.new(0.55, 0.1, 0.18), CFrame.new(0, 0.05, 0), gold, Enum.Material.Neon)
        makeBall(model, handle, "Pommel", 0.22, CFrame.new(0, -0.85, 0), gold, Enum.Material.Neon)
    end

    builders.Baseball = function(model, handle)
        local wood = Color3.fromRGB(165, 115, 55)
        local grip = Color3.fromRGB(35, 35, 40)
        makeCyl(model, handle, "Barrel", 1.35, 0.42, CFrame.new(0, 1.05, 0), wood, Enum.Material.Wood)
        makeCyl(model, handle, "Shaft", 1.05, 0.2, CFrame.new(0, -0.15, 0), wood, Enum.Material.Wood)
        makeCyl(model, handle, "Grip", 0.55, 0.24, CFrame.new(0, -0.75, 0), grip, Enum.Material.Fabric)
        makeBall(model, handle, "Knob", 0.28, CFrame.new(0, -1.1, 0), wood, Enum.Material.Wood)
    end

    builders.NeonBlade = function(model, handle)
        local cyan = Color3.fromRGB(255, 255, 255)
        local glow = Color3.fromRGB(180, 245, 255)
        local dark = Color3.fromRGB(18, 22, 32)
        makeCyl(model, handle, "Hilt", 0.85, 0.16, CFrame.new(0, -0.4, 0), dark, Enum.Material.Metal)
        makePart(model, handle, "Core", Vector3.new(0.1, 2.4, 0.05), CFrame.new(0, 1.1, 0), cyan, Enum.Material.Neon)
        makePart(model, handle, "Glow", Vector3.new(0.18, 2.3, 0.03), CFrame.new(0, 1.1, 0), glow, Enum.Material.Neon)
        makePart(model, handle, "Guard", Vector3.new(0.48, 0.08, 0.12), CFrame.new(0, 0.0, 0), cyan, Enum.Material.Neon)
        makeBall(model, handle, "Tip", 0.16, CFrame.new(0, 2.35, 0), cyan, Enum.Material.Neon)
        makeBall(model, handle, "Pommel", 0.2, CFrame.new(0, -0.85, 0), cyan, Enum.Material.Neon)
    end

    builders.Hammer = function(model, handle)
        local metal = Color3.fromRGB(95, 100, 110)
        local dark = Color3.fromRGB(55, 58, 65)
        local wood = Color3.fromRGB(115, 75, 40)
        makeCyl(model, handle, "Shaft", 2.0, 0.16, CFrame.new(0, 0.35, 0), wood, Enum.Material.Wood)
        makePart(model, handle, "Head", Vector3.new(0.95, 0.5, 0.5), CFrame.new(0, 1.45, 0), metal, Enum.Material.Metal)
        makePart(model, handle, "Face", Vector3.new(0.12, 0.48, 0.48), CFrame.new(0.5, 1.45, 0), dark, Enum.Material.Metal)
        makeBall(model, handle, "Peen", 0.32, CFrame.new(-0.42, 1.45, 0), metal, Enum.Material.Metal)
        makeCyl(model, handle, "Grip", 0.45, 0.2, CFrame.new(0, -0.7, 0), Color3.fromRGB(40,40,45), Enum.Material.Fabric)
    end

    builders.Scythe = function(model, handle)
        local dark = Color3.fromRGB(28, 28, 34)
        local blade = Color3.fromRGB(190, 35, 45)
        local bone = Color3.fromRGB(225, 215, 195)
        makeCyl(model, handle, "Pole", 2.7, 0.12, CFrame.new(0, 0.5, 0), dark, Enum.Material.Wood)
        makePart(model, handle, "Blade", Vector3.new(1.35, 0.1, 0.42), CFrame.new(0.55, 1.85, 0) * CFrame.Angles(0, 0, math.rad(-20)), blade, Enum.Material.Metal)
        makePart(model, handle, "Tip", Vector3.new(0.28, 0.08, 0.28), CFrame.new(1.15, 1.55, 0), blade, Enum.Material.Metal)
        makeBall(model, handle, "Skull", 0.3, CFrame.new(0, 1.95, 0), bone, Enum.Material.SmoothPlastic)
    end

    builders.BoneClub = function(model, handle)
        local bone = Color3.fromRGB(230, 220, 200)
        local dark = Color3.fromRGB(45, 40, 35)
        makeCyl(model, handle, "Shaft", 1.85, 0.26, CFrame.new(0, 0.35, 0), bone, Enum.Material.SmoothPlastic)
        makeBall(model, handle, "Head", 0.65, CFrame.new(0, 1.45, 0), bone, Enum.Material.SmoothPlastic)
        makePart(model, handle, "Spike1", Vector3.new(0.12, 0.38, 0.12), CFrame.new(0.22, 1.7, 0), dark, Enum.Material.Metal)
        makePart(model, handle, "Spike2", Vector3.new(0.12, 0.35, 0.12), CFrame.new(-0.18, 1.65, 0.12), dark, Enum.Material.Metal)
        makePart(model, handle, "Spike3", Vector3.new(0.12, 0.32, 0.12), CFrame.new(0.08, 1.72, -0.18), dark, Enum.Material.Metal)
        makeCyl(model, handle, "Grip", 0.45, 0.3, CFrame.new(0, -0.65, 0), dark, Enum.Material.Fabric)
    end

    builders.CrystalSword = function(model, handle)
        local crystal = Color3.fromRGB(155, 70, 255)
        local bright = Color3.fromRGB(215, 175, 255)
        local dark = Color3.fromRGB(35, 15, 55)
        makeCyl(model, handle, "Hilt", 0.8, 0.16, CFrame.new(0, -0.4, 0), dark, Enum.Material.Metal)
        makePart(model, handle, "Blade", Vector3.new(0.2, 2.25, 0.1), CFrame.new(0, 1.05, 0), crystal, Enum.Material.Glass)
        makePart(model, handle, "Core", Vector3.new(0.08, 2.15, 0.05), CFrame.new(0, 1.05, 0), bright, Enum.Material.Neon)
        makePart(model, handle, "Guard", Vector3.new(0.52, 0.1, 0.14), CFrame.new(0, 0.0, 0), crystal, Enum.Material.Neon)
        makeBall(model, handle, "Pommel", 0.26, CFrame.new(0, -0.85, 0), bright, Enum.Material.Neon)
    end

    builders.CandyCane = function(model, handle)
        local red = Color3.fromRGB(220, 40, 50)
        local white = Color3.fromRGB(245, 245, 245)
        makeCyl(model, handle, "Stick", 2.2, 0.2, CFrame.new(0, 0.4, 0), white, Enum.Material.SmoothPlastic)
        for i = 0, 5 do
            local y = -0.55 + i * 0.42
            makeCyl(model, handle, "Stripe"..i, 0.16, 0.22, CFrame.new(0, y, 0), red, Enum.Material.SmoothPlastic)
        end
        makeCyl(model, handle, "Hook1", 0.5, 0.2, CFrame.new(0.18, 1.55, 0) * CFrame.Angles(0, 0, math.rad(90)), red, Enum.Material.SmoothPlastic)
        makeBall(model, handle, "HookTip", 0.22, CFrame.new(0.42, 1.55, 0), white, Enum.Material.SmoothPlastic)
    end

    builders.BanHammer = function(model, handle)
        local black = Color3.fromRGB(22, 22, 28)
        local red = Color3.fromRGB(220, 30, 40)
        local gold = Color3.fromRGB(255, 200, 50)
        makeCyl(model, handle, "Shaft", 1.85, 0.18, CFrame.new(0, 0.25, 0), black, Enum.Material.Metal)
        makePart(model, handle, "Head", Vector3.new(1.05, 0.65, 0.65), CFrame.new(0, 1.35, 0), black, Enum.Material.Metal)
        makePart(model, handle, "Face", Vector3.new(0.1, 0.6, 0.6), CFrame.new(0.55, 1.35, 0), red, Enum.Material.Neon)
        makePart(model, handle, "Badge", Vector3.new(0.32, 0.32, 0.06), CFrame.new(0, 1.35, 0.36), gold, Enum.Material.Neon)
        makeCyl(model, handle, "Grip", 0.5, 0.24, CFrame.new(0, -0.7, 0), red, Enum.Material.Fabric)
    end

    builders.Axe = function(model, handle)
        local wood = Color3.fromRGB(105, 68, 32)
        local steel = Color3.fromRGB(145, 150, 160)
        local edge = Color3.fromRGB(210, 215, 225)
        makeCyl(model, handle, "Shaft", 2.15, 0.14, CFrame.new(0, 0.3, 0), wood, Enum.Material.Wood)
        makePart(model, handle, "Head", Vector3.new(0.85, 0.5, 0.16), CFrame.new(0.28, 1.4, 0), steel, Enum.Material.Metal)
        makePart(model, handle, "Edge", Vector3.new(0.12, 0.65, 0.06), CFrame.new(0.68, 1.4, 0), edge, Enum.Material.Metal)
        makeBall(model, handle, "Spike", 0.18, CFrame.new(-0.2, 1.4, 0), steel, Enum.Material.Metal)
        makeCyl(model, handle, "Grip", 0.4, 0.18, CFrame.new(0, -0.75, 0), Color3.fromRGB(50,50,55), Enum.Material.Fabric)
    end

    builders.Trident = function(model, handle)
        local gold = Color3.fromRGB(255, 195, 50)
        local teal = Color3.fromRGB(25, 170, 190)
        makeCyl(model, handle, "Pole", 2.35, 0.12, CFrame.new(0, 0.35, 0), teal, Enum.Material.Metal)
        makeCyl(model, handle, "Center", 0.85, 0.1, CFrame.new(0, 1.85, 0), gold, Enum.Material.Neon)
        makeCyl(model, handle, "Left", 0.7, 0.09, CFrame.new(-0.26, 1.75, 0) * CFrame.Angles(0, 0, math.rad(14)), gold, Enum.Material.Neon)
        makeCyl(model, handle, "Right", 0.7, 0.09, CFrame.new(0.26, 1.75, 0) * CFrame.Angles(0, 0, math.rad(-14)), gold, Enum.Material.Neon)
        makePart(model, handle, "Base", Vector3.new(0.55, 0.1, 0.1), CFrame.new(0, 1.4, 0), teal, Enum.Material.Metal)
        makeBall(model, handle, "TipC", 0.12, CFrame.new(0, 2.3, 0), gold, Enum.Material.Neon)
        makeBall(model, handle, "TipL", 0.1, CFrame.new(-0.32, 2.12, 0), gold, Enum.Material.Neon)
        makeBall(model, handle, "TipR", 0.1, CFrame.new(0.32, 2.12, 0), gold, Enum.Material.Neon)
    end

    builders.Lightning = function(model, handle)
        local yellow = Color3.fromRGB(255, 230, 40)
        local orange = Color3.fromRGB(255, 145, 25)
        local dark = Color3.fromRGB(28, 22, 40)
        makeCyl(model, handle, "Core", 2.3, 0.1, CFrame.new(0, 0.45, 0), yellow, Enum.Material.Neon)
        makePart(model, handle, "Bolt1", Vector3.new(0.55, 0.1, 0.1), CFrame.new(0.22, 0.9, 0) * CFrame.Angles(0, 0, math.rad(-32)), orange, Enum.Material.Neon)
        makePart(model, handle, "Bolt2", Vector3.new(0.45, 0.1, 0.1), CFrame.new(-0.18, 0.3, 0) * CFrame.Angles(0, 0, math.rad(38)), yellow, Enum.Material.Neon)
        makePart(model, handle, "Bolt3", Vector3.new(0.5, 0.1, 0.1), CFrame.new(0.2, 1.5, 0) * CFrame.Angles(0, 0, math.rad(-28)), orange, Enum.Material.Neon)
        makeCyl(model, handle, "Grip", 0.55, 0.2, CFrame.new(0, -0.75, 0), dark, Enum.Material.Metal)
        makeBall(model, handle, "Tip", 0.28, CFrame.new(0, 1.75, 0), yellow, Enum.Material.Neon)
    end

    builders.PixelSword = function(model, handle)
        local colors = {
            Color3.fromRGB(255, 60, 80), Color3.fromRGB(60, 200, 255),
            Color3.fromRGB(255, 255, 255), Color3.fromRGB(255, 220, 50),
            Color3.fromRGB(200, 80, 255),
        }
        makePart(model, handle, "Hilt", Vector3.new(0.26, 0.65, 0.26), CFrame.new(0, -0.5, 0), Color3.fromRGB(35, 35, 45), Enum.Material.SmoothPlastic)
        for i = 0, 7 do
            local c = colors[(i % #colors) + 1]
            makePart(model, handle, "Px"..i, Vector3.new(0.3, 0.26, 0.12), CFrame.new(0, 0.0 + i * 0.27, 0), c, Enum.Material.Neon)
        end
        makePart(model, handle, "Tip", Vector3.new(0.18, 0.18, 0.1), CFrame.new(0, 2.2, 0), colors[1], Enum.Material.Neon)
        makePart(model, handle, "Guard", Vector3.new(0.5, 0.1, 0.14), CFrame.new(0, -0.15, 0), Color3.fromRGB(255, 255, 255), Enum.Material.Neon)
    end

    local function applyBatSkin(tool)
        if not isBatTool(tool) then return end
        local handle = tool:FindFirstChild("Handle")
        if not handle or not handle:IsA("BasePart") then return end
        local skin = _G.K7DuelsBatSkin or "None"
        local existing = handle:FindFirstChild("K7DuelsBatSkinReplica")
        if skin == "None" or not builders[skin] then
            clearBatSkin(tool)
            return
        end
        if existing and existing:GetAttribute("SkinKey") == skin then
            hideOriginalParts(tool)
            return
        end
        clearBatSkin(tool)
        hideOriginalParts(tool)
        local model = Instance.new("Model")
        model.Name = "K7DuelsBatSkinReplica"
        model:SetAttribute("SkinKey", skin)
        model.Parent = handle
        local ok, err = pcall(builders[skin], model, handle)
        if not ok then
            warn("[K7 DUELS BatSkin] " .. tostring(skin) .. ": " .. tostring(err))
            clearBatSkin(tool)
        else
            hideOriginalParts(tool)
        end
    end

    local function scanBatTools()
        local function watch(container)
            if not container then return end
            for _, child in ipairs(container:GetChildren()) do
                if isBatTool(child) then task.defer(applyBatSkin, child) end
            end
            if not container:GetAttribute("K7DuelsBatSkinWatch") then
                container:SetAttribute("K7DuelsBatSkinWatch", true)
                container.ChildAdded:Connect(function(child)
                    if not isBatTool(child) then return end
                    task.wait()
                    applyBatSkin(child)
                end)
            end
        end
        watch(BatSkinLP:FindFirstChildOfClass("Backpack"))
        watch(BatSkinLP.Character)
    end

    function _G.K7DuelsSetBatSkin(choice)
        if not choice then choice = "None" end
        local valid = false
        for _, id in ipairs(_G.K7DuelsBatSkinOrder) do
            if id == choice then valid = true; break end
        end
        if not valid then choice = "None" end
        _G.K7DuelsBatSkin = choice
        pcall(scanBatTools)
        if _G.K7DuelsBatSkinRefreshUI then pcall(_G.K7DuelsBatSkinRefreshUI) end
        if type(saveAllSettings) == "function" then
            pcall(saveAllSettings)
        end
    end

    function _G.K7DuelsApplyBatSkin()
        pcall(scanBatTools)
    end

    pcall(function()
        _G.K7DuelsSetBatSkin(_G.K7DuelsBatSkin or "WitchBroom")
    end)

    scanBatTools()
    BatSkinLP.ChildAdded:Connect(function(child)
        if child:IsA("Backpack") then scanBatTools() end
    end)
    BatSkinLP.CharacterAdded:Connect(function()
        task.wait(0.5)
        scanBatTools()
    end)
    task.spawn(function()
        while task.wait(1.2) do
            if (_G.K7DuelsBatSkin or "None") ~= "None" then
                pcall(scanBatTools)
            end
        end
    end)

    _G.ShelSwordVisual = {
        apply = scanBatTools,
        visual = function() return _G.K7DuelsBatSkin end,
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
    local SoundService = game:GetService("SoundService")
    local ContentProvider = game:GetService("ContentProvider")

    -- Sonidos por skin (IDs públicos + fallbacks clásicos de Roblox)
    local MEDUSA_SKIN_SOUNDS = {
        Default = {
            ids = {
                "rbxassetid://9120386436", -- impacto / energía
                "rbxasset://sounds/electronicpingshort.wav",
            },
            volume = 2,
            speed = 1.2,
        },
        Skull = {
            ids = {
                "rbxassetid://9120705982", -- whoosh explosion
                "rbxasset://sounds/impact_explosion_03.mp3",
            },
            volume = 2,
            speed = 0.85,
        },
        GoldenDesertEagle = {
            ids = {
                "rbxasset://sounds/Rocket shot.wav", -- clásico Roblox (siempre carga)
                "rbxasset://sounds/Launching rocket.wav",
                "rbxassetid://9114221308",
                "rbxassetid://131523068",
            },
            volume = 2.5,
            speed = 1.05,
        },
    }

    local BOMB_SOUND = MEDUSA_SKIN_SOUNDS.Default.ids[1]
    local bombHooked = setmetatable({}, { __mode = "k" })
    local lastPlayAt = 0

    local function getMedusaSoundConfig()
        local sk = _G.RivalMedusaSkin or "Default"
        return MEDUSA_SKIN_SOUNDS[sk] or MEDUSA_SKIN_SOUNDS.Default
    end

    local function isBombTool(obj)
        if not obj or not obj:IsA("Tool") then return false end
        local n = obj.Name:lower()
        return n:find("medusa", 1, true) ~= nil
            or n:find("head", 1, true) ~= nil
            or n:find("stone", 1, true) ~= nil
    end

    -- Un Sound global en SoundService (2D, siempre audible)
    local globalSound = SoundService:FindFirstChild("K7DuelsMedusaSkinSound")
    if not globalSound then
        globalSound = Instance.new("Sound")
        globalSound.Name = "K7DuelsMedusaSkinSound"
        globalSound.Looped = false
        globalSound.RollOffMode = Enum.RollOffMode.InverseTapered
        globalSound.Parent = SoundService
    end

    local function playMedusaSkinSound()
        local now = tick()
        if now - lastPlayAt < 0.08 then return end
        lastPlayAt = now
        local cfg = getMedusaSoundConfig()
        local ids = cfg.ids or { cfg.id }
        task.spawn(function()
            for _, sid in ipairs(ids) do
                local ok = pcall(function()
                    globalSound:Stop()
                    globalSound.SoundId = sid
                    globalSound.Volume = cfg.volume or 2
                    globalSound.PlaybackSpeed = cfg.speed or 1
                    globalSound.TimePosition = 0
                    pcall(function() ContentProvider:PreloadAsync({ globalSound }) end)
                    globalSound:Play()
                end)
                if ok then
                    -- espera breve a ver si arrancó
                    local t0 = tick()
                    while tick() - t0 < 0.15 do
                        if globalSound.IsPlaying or globalSound.TimeLength > 0 then
                            return
                        end
                        task.wait(0.03)
                    end
                end
            end
        end)
    end

    local function muteOriginal(obj)
        if not obj:IsA("Sound") then return end
        if obj.Name == "ShelBombSound" or obj.Name == "K7DuelsMedusaSkinSound" then return end
        pcall(function()
            obj.Volume = 0
            obj:Stop()
        end)
        if not obj:GetAttribute("K7DuelsMuted") then
            obj:SetAttribute("K7DuelsMuted", true)
            obj:GetPropertyChangedSignal("Volume"):Connect(function()
                if obj.Parent and obj.Volume ~= 0 then
                    obj.Volume = 0
                end
            end)
            obj:GetPropertyChangedSignal("Playing"):Connect(function()
                if obj.Playing then
                    pcall(function() obj:Stop() end)
                    playMedusaSkinSound()
                end
            end)
        end
    end

    local function hookBombTool(tool)
        if not isBombTool(tool) or bombHooked[tool] then return end
        bombHooked[tool] = true

        for _, obj in ipairs(tool:GetDescendants()) do
            muteOriginal(obj)
        end
        tool.DescendantAdded:Connect(muteOriginal)

        -- Activación directa del tool
        tool.Activated:Connect(function()
            playMedusaSkinSound()
        end)

        -- Por si el juego usa RemoteEvent dentro del tool
        for _, d in ipairs(tool:GetDescendants()) do
            if d:IsA("RemoteEvent") then
                d.OnClientEvent:Connect(function()
                    playMedusaSkinSound()
                end)
            end
        end
        tool.DescendantAdded:Connect(function(d)
            if d:IsA("RemoteEvent") then
                d.OnClientEvent:Connect(function()
                    playMedusaSkinSound()
                end)
            end
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

    -- Preload de los IDs principales
    task.spawn(function()
        local preload = {}
        for _, cfg in pairs(MEDUSA_SKIN_SOUNDS) do
            for _, sid in ipairs(cfg.ids or {}) do
                local s = Instance.new("Sound")
                s.SoundId = sid
                table.insert(preload, s)
            end
        end
        pcall(function() ContentProvider:PreloadAsync(preload) end)
        for _, s in ipairs(preload) do pcall(function() s:Destroy() end) end
    end)

    _G.ShelBombSound = {
        apply = scanBombTools,
        BombSound = BOMB_SOUND,
        SkinSounds = MEDUSA_SKIN_SOUNDS,
        play = playMedusaSkinSound,
        refresh = function()
            -- solo fuerza rescan; el sonido se elige al reproducir
            pcall(scanBombTools)
        end,
    }
end

do
    local SkinPlayers = game:GetService("Players")
    local SkinLP = SkinPlayers.LocalPlayer

    local function isMedusaSkinTool(obj)
        if not obj or not obj:IsA("Tool") then return false end
        local n = obj.Name:lower()
        return n:find("medusa", 1, true) ~= nil or n:find("head", 1, true) ~= nil or n:find("stone", 1, true) ~= nil
    end

    local function removeBombSkin(tool)
        local f = tool:FindFirstChild("ShelMedusaBombSkin")
        if f then f:Destroy() end
        if tool:GetAttribute("ShelMedusaBombSkin") then
            tool:SetAttribute("ShelMedusaBombSkin", nil)
            for _, obj in ipairs(tool:GetDescendants()) do
                if obj:IsA("BasePart") then obj.LocalTransparencyModifier = 0 end
            end
        end
    end

    local function applyMedusaSkin(tool)
        if not isMedusaSkinTool(tool) then return end
        if (_G.RivalMedusaSkin or "Default") ~= "Default" then
            removeBombSkin(tool)
            return
        end
        if tool:GetAttribute("ShelMedusaBombSkin") and tool:FindFirstChild("ShelMedusaBombSkin") then return end
        local handle = tool:FindFirstChild("Handle") or tool:FindFirstChildWhichIsA("BasePart", true)
        if not handle or not handle:IsA("BasePart") then return end
        tool:SetAttribute("ShelMedusaBombSkin", true)

        for _, obj in ipairs(tool:GetDescendants()) do
            if obj:IsA("BasePart") then
                obj.LocalTransparencyModifier = 1
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

        -- Skin "F" (FEAR) en lugar de la bomba roja
        local pink = Color3.fromRGB(255, 255, 255)
        local pinkBright = Color3.fromRGB(255, 160, 210)
        local pinkDark = Color3.fromRGB(180, 40, 120)
        local ivory = Color3.fromRGB(255, 240, 250)
        -- Barra vertical de la F
        block("F_Stem", Vector3.new(0.28, 1.55, 0.22), pink, CFrame.new(-0.28, 0.05, 0), Enum.PartType.Block, Enum.Material.Neon)
        -- Barra superior
        block("F_Top", Vector3.new(0.95, 0.26, 0.22), pinkBright, CFrame.new(0.12, 0.72, 0), Enum.PartType.Block, Enum.Material.Neon)
        -- Barra media
        block("F_Mid", Vector3.new(0.72, 0.24, 0.22), pink, CFrame.new(0.02, 0.18, 0), Enum.PartType.Block, Enum.Material.Neon)
        -- Acentos / profundidad
        block("F_StemBack", Vector3.new(0.18, 1.45, 0.12), pinkDark, CFrame.new(-0.28, 0.05, 0.12), Enum.PartType.Block, Enum.Material.SmoothPlastic)
        block("F_TopEdge", Vector3.new(0.95, 0.08, 0.08), ivory, CFrame.new(0.12, 0.82, 0), Enum.PartType.Block, Enum.Material.Neon)
        block("F_MidEdge", Vector3.new(0.72, 0.07, 0.08), ivory, CFrame.new(0.02, 0.28, 0), Enum.PartType.Block, Enum.Material.Neon)
        -- Pequeño brillo central
        block("F_Glow", Vector3.new(0.14, 0.14, 0.14), pinkBright, CFrame.new(-0.28, 0.05, -0.12), Enum.PartType.Ball, Enum.Material.Neon)

        if not tool:GetAttribute("ShelMedusaDescHook") then
            tool:SetAttribute("ShelMedusaDescHook", true)
            tool.DescendantAdded:Connect(function(obj)
                if (_G.RivalMedusaSkin or "Default") ~= "Default" then return end
                if obj:FindFirstAncestor("ShelMedusaBombSkin") then return end
                if obj:IsA("BasePart") then obj.LocalTransparencyModifier = 1 end
            end)
        end
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

    _G.ShelMedusaSkin = {apply = scanSkinTools}
end

-- E01 NOTIFIER
local CleanHubE01StartedAt = nil
local CleanHubE01Gui = nil
local function CleanHubIsCarrying()
    local CleanHubCharacter = LP.Character
    if not CleanHubCharacter then return false end
    for _, CleanHubChild in ipairs(CleanHubCharacter:GetChildren()) do
        local CleanHubName = CleanHubChild.Name:lower()
        if CleanHubName:find("brain", 1, true) or CleanHubName:find("animal", 1, true) or CleanHubName:find("carry", 1, true) or CleanHubName:find("steal", 1, true) then return true end
    end
    local CleanHubHumanoid = CleanHubCharacter:FindFirstChildOfClass("Humanoid")
    return CleanHubHumanoid and CleanHubHumanoid.WalkSpeed > 0 and CleanHubHumanoid.WalkSpeed <= 25 and CleanHubHumanoid.WalkSpeed ~= 16
end

RunService.Heartbeat:Connect(function()
    if not CleanHubIsCarrying() then
        if CleanHubE01Gui then CleanHubE01Gui.Enabled = false end
        CleanHubE01StartedAt = nil
        return
    end
    CleanHubE01StartedAt = CleanHubE01StartedAt or tick()
    local CleanHubProgress = math.clamp((tick() - CleanHubE01StartedAt) / 2.6, 0, 1)
    if not CleanHubE01Gui then
        CleanHubE01Gui = Instance.new("ScreenGui")
        CleanHubE01Gui.Name = "CleanHubE01Warning"
        CleanHubE01Gui.ResetOnSpawn = false
        CleanHubE01Gui.IgnoreGuiInset = true
        CleanHubE01Gui.Parent = LP:WaitForChild("PlayerGui")
        local CleanHubBar = Instance.new("Frame", CleanHubE01Gui)
        CleanHubBar.Name = "Bar"
        CleanHubBar.AnchorPoint = Vector2.new(.5, 0)
        CleanHubBar.Position = UDim2.new(.5, 0, 0, 18)
        CleanHubBar.Size = UDim2.new(0, 300, 0, 36)
        CleanHubBar.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        CleanHubBar.BackgroundTransparency = .34
        CleanHubBar.BorderSizePixel = 0
        CleanHubBar.ClipsDescendants = true
        Instance.new("UICorner", CleanHubBar).CornerRadius = UDim.new(1, 0)
        local CleanHubTrack = Instance.new("Frame", CleanHubBar)
        CleanHubTrack.Name = "Track"
        CleanHubTrack.Position = UDim2.new(0, 3, 0, 3)
        CleanHubTrack.Size = UDim2.new(1, -6, 1, -6)
        CleanHubTrack.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        CleanHubTrack.BackgroundTransparency = .48
        CleanHubTrack.BorderSizePixel = 0
        CleanHubTrack.ClipsDescendants = true
        Instance.new("UICorner", CleanHubTrack).CornerRadius = UDim.new(1, 0)
        local CleanHubFill = Instance.new("Frame", CleanHubTrack)
        CleanHubFill.Name = "Fill"
        CleanHubFill.Size = UDim2.new(0, 0, 1, 0)
        CleanHubFill.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        CleanHubFill.BackgroundTransparency = .35
        CleanHubFill.BorderSizePixel = 0
        Instance.new("UICorner", CleanHubFill).CornerRadius = UDim.new(1, 0)
        local CleanHubLabel = Instance.new("TextLabel", CleanHubBar)
        CleanHubLabel.Name = "Label"
        CleanHubLabel.Size = UDim2.new(1, -16, 1, 0)
        CleanHubLabel.Position = UDim2.new(0, 8, 0, 0)
        CleanHubLabel.BackgroundTransparency = 1
        CleanHubLabel.Font = Enum.Font.GothamBlack
        CleanHubLabel.TextSize = 14
        CleanHubLabel.TextStrokeTransparency = .18
        CleanHubLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        CleanHubLabel.ZIndex = 2
    end
    CleanHubE01Gui.Enabled = true
    local CleanHubFinished = CleanHubProgress >= 1
    CleanHubE01Gui.Bar.Label.Text = CleanHubFinished and "STEAL" or "DONT STEAL"
    CleanHubE01Gui.Bar.Label.TextColor3 = CleanHubFinished and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(255, 75, 85)
    CleanHubE01Gui.Bar.Track.Fill.Size = UDim2.new(CleanHubProgress, 0, 1, 0)
end)


-- ============================================================
-- SPIN BOOTSTRAP: connections created by startSpin/startSpinBrainrot when toggled