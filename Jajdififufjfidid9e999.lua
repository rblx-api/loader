---- leaked by .gg/source

if _G.RivalHubRunning then
    warn("[KANZ HUB] Instancia previa detectada. Se recomienda rejoin si hay comportamiento errático.")
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
    warn("[KANZ HUB] LocalPlayer no disponible en 15s. Abortando.")
    return
end

local pgui = LP:WaitForChild("PlayerGui", 20)
if not pgui then
    warn("[KANZ HUB] PlayerGui no cargó en 20s. Abortando.")
    return
end

local camera = Workspace.CurrentCamera

local SoundService = game:GetService("SoundService")

local MVP_REDRUM_URL = "https://file.garden/algLafWA1jk8WMfK/redrum_spotdown.org%202.mp3"
local MVP_REDRUM_FILE = "mvp_redrum.mp3"
local mvpRedrumAsset = nil
local mvpFullRedrumSound = nil
local mvpMusicRequest = 0
local mvpMusicRefreshers = {}

local function getMVPRedrumAsset()
    if mvpRedrumAsset then return mvpRedrumAsset end

    local assetLoader = getcustomasset or getsynasset
    if type(assetLoader) ~= "function" or type(writefile) ~= "function" then
        return nil, "custom asset functions unavailable"
    end

    local exists = false
    if type(isfile) == "function" then
        local okExists, result = pcall(isfile, MVP_REDRUM_FILE)
        exists = okExists and result == true
    end

    if not exists then
        local okDownload, data = pcall(function()
            return game:HttpGet(MVP_REDRUM_URL)
        end)
        if not okDownload or type(data) ~= "string" or #data < 256 then
            return nil, "could not download redrum"
        end

        local okWrite = pcall(writefile, MVP_REDRUM_FILE, data)
        if not okWrite then
            return nil, "could not save redrum"
        end
    end

    local okAsset, asset = pcall(assetLoader, MVP_REDRUM_FILE)
    if not okAsset or type(asset) ~= "string" or asset == "" then
        return nil, "could not create redrum asset"
    end

    mvpRedrumAsset = asset
    return asset
end

local function makeMVPRedrumSound(startAt, name)
    local asset, err = getMVPRedrumAsset()
    if not asset then
        warn("[KANZ HUB Music] " .. tostring(err))
        return nil
    end

    local sound = Instance.new("Sound")
    sound.Name = name or "MVPRedrum"
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

local function stopMVPFullRedrum()
    mvpMusicRequest = mvpMusicRequest + 1
    if mvpFullRedrumSound then
        pcall(function() mvpFullRedrumSound:Stop() end)
        pcall(function() mvpFullRedrumSound:Destroy() end)
        mvpFullRedrumSound = nil
    end
end


_G.RivalHubRunning = true
_G.RivalHubSession = (_G.RivalHubSession or 0) + 1
local _mySession = _G.RivalHubSession

do
    -- ============ INTRO KANZ HUB V1 (intro Fira/Rival Hub dipindahkan persis; intro lama Kanz sudah dihapus) ============
    -- layar 1: "clean ontop?"  ->  layar 2: "NO LOL HAHA"  ->  layar 3: "KANZ HUB V1" + link discord
    local skipIntroNow = false
    local introThemeKey = nil
    pcall(function()
        local fileName = "MVP_" .. tostring(LP.UserId) .. ".json"
        if type(isfile) == "function" and type(readfile) == "function" and isfile(fileName) then
            local data = HS:JSONDecode(readfile(fileName))
            if type(data) == "table" and data.skipIntro == true then skipIntroNow = true end
            if type(data) == "table" and type(data.themeColor) == "string" then introThemeKey = data.themeColor end
        end
    end)
    local okIntro, errIntro = pcall(function()
        if skipIntroNow then return end
        local TweenService = game:GetService("TweenService")
        local CoreGui = game:GetService("CoreGui")
        local SoundService = game:GetService("SoundService")
        local UserInputService = game:GetService("UserInputService")
        local Players = game:GetService("Players")

        local HOLD_TO_SKIP = 1
        local INTRO_DURATION = 6.35
        local SONG_URL = "https://files.catbox.moe/4inuat.mp3"
        local SONG_FILE = "M4LWARE_Intro_Song1.mp3"

        -- ===== warna intro mengikuti Theme Color di Settings > Misc (tersimpan di config); bentuk intro tetap sama =====
        local INTRO_THEMES = {
            ["Gray"] = {c = Color3.fromRGB(215, 215, 220)},
            ["Red+Purple"] = {c = Color3.fromRGB(255, 25, 40), s = Color3.fromRGB(185, 60, 255)},
            ["Yellow+Black"] = {c = Color3.fromRGB(255, 232, 0)},
            ["Green+White"] = {c = Color3.fromRGB(0, 255, 110), s = Color3.fromRGB(255, 255, 255)},
        }
        local ITH = (introThemeKey and INTRO_THEMES[introThemeKey]) or {c = Color3.fromRGB(200, 40, 255)} -- default = tema "Purple"
        local W, K = Color3.new(1, 1, 1), Color3.new(0, 0, 0)
        local TC = ITH.c
        local TA = TC
        if ITH.s and (ITH.s.R + ITH.s.G + ITH.s.B) / 3 >= 0.25 then TA = ITH.s end
        local ORANGE_NEON_LIGHT = TC:Lerp(W, 0.5)
        local ORANGE_NEON_MID   = TC
        local ORANGE_NEON_DEEP  = TC:Lerp(K, 0.45)
        local ORANGE_BORDER     = TC:Lerp(W, 0.3)
        local SILVER_GLOW       = Color3.fromRGB(240, 245, 255)
        local SILVER_BRIGHT     = Color3.fromRGB(225, 232, 242)
        local T_BG1   = TC:Lerp(K, 0.95)
        local T_BG2   = TC:Lerp(K, 0.90)
        local T_CREAM = W:Lerp(TC, 0.12)
        local T_TEXT1 = W:Lerp(TC, 0.05)
        local T_TEXT2 = W:Lerp(TC, 0.03)
        local T_DARK1 = TC:Lerp(K, 0.93)
        local T_DARK2 = TC:Lerp(K, 0.96)

        pcall(function()
            local old = CoreGui:FindFirstChild("M4LWARE_Intro")
            if old then old:Destroy() end
        end)

        pcall(function()
            local pg = Players.LocalPlayer and Players.LocalPlayer:FindFirstChild("PlayerGui")
            local old = pg and pg:FindFirstChild("M4LWARE_Intro")
            if old then old:Destroy() end
        end)

        local intro = Instance.new("ScreenGui")
        intro.Name = "M4LWARE_Intro"
        intro.IgnoreGuiInset = true
        intro.ResetOnSpawn = false
        intro.DisplayOrder = 999999
        intro.ZIndexBehavior = Enum.ZIndexBehavior.Global

        if not pcall(function()
            intro.Parent = CoreGui
        end) or not intro.Parent then
            intro.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
        end

        local bg = Instance.new("Frame")
        bg.Size = UDim2.fromScale(1,1)
        bg.BackgroundColor3 = Color3.fromRGB(0,0,0)
        bg.BorderSizePixel = 0
        bg.Parent = intro

        local bgGrad = Instance.new("UIGradient", bg)
        bgGrad.Rotation = 90
        bgGrad.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0.00, Color3.fromRGB(0,0,0)),
            ColorSequenceKeypoint.new(0.48, T_BG1),
            ColorSequenceKeypoint.new(0.52, T_BG2),
            ColorSequenceKeypoint.new(1.00, Color3.fromRGB(0,0,0))
        })

        local center = Instance.new("Frame")
        center.AnchorPoint = Vector2.new(0.5,0.5)
        center.Position = UDim2.fromScale(0.5,0.5)
        center.Size = UDim2.new(0.88,0,0,240)
        center.BackgroundTransparency = 1
        center.Parent = intro

        local centerLimit = Instance.new("UISizeConstraint", center)
        centerLimit.MaxSize = Vector2.new(760,260)
        centerLimit.MinSize = Vector2.new(280,200)

        local topLine = Instance.new("Frame")
        topLine.AnchorPoint = Vector2.new(0.5,0.5)
        topLine.Position = UDim2.new(0.5,0,0.18,0)
        topLine.Size = UDim2.fromOffset(0,1)
        topLine.BackgroundColor3 = ORANGE_NEON_MID
        topLine.BackgroundTransparency = 0.18
        topLine.BorderSizePixel = 0
        topLine.Parent = center

        local topGrad = Instance.new("UIGradient", topLine)
        topGrad.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0,Color3.fromRGB(0,0,0)),
            ColorSequenceKeypoint.new(0.5,T_CREAM),
            ColorSequenceKeypoint.new(1,Color3.fromRGB(0,0,0))
        })

        local function makeCenterText(name, text, sizeY, font, color, z)
            local t = Instance.new("TextLabel")
            t.Name = name
            t.AnchorPoint = Vector2.new(0.5,0.5)
            t.Position = UDim2.fromScale(0.5,0.49)
            t.Size = UDim2.new(0.92,0,0,sizeY)
            t.BackgroundTransparency = 1
            t.Text = text
            t.Font = font
            t.TextScaled = true
            t.TextColor3 = color
            t.TextTransparency = 1
            t.TextStrokeColor3 = Color3.fromRGB(0,0,0)
            t.TextStrokeTransparency = 1
            t.ZIndex = z or 10
            t.Parent = center
            return t
        end

        local symbolGlow = makeCenterText("SymbolGlow", "clean ontop?", 88, Enum.Font.GothamBlack, ORANGE_NEON_MID, 9)
        local symbolStroke = Instance.new("UIStroke", symbolGlow)
        symbolStroke.Color = ORANGE_NEON_DEEP
        symbolStroke.Thickness = 10
        symbolStroke.Transparency = 1

        local symbol = makeCenterText("Symbol", "clean ontop?", 82, Enum.Font.GothamBlack, T_TEXT1, 11)
        local symbolScale = Instance.new("UIScale", symbol)
        symbolScale.Scale = 0.72

        local noGlow = makeCenterText("NoGlow", "NO LOL NIGGER", 102, Enum.Font.GothamBlack, ORANGE_NEON_MID, 12)
        local noStroke = Instance.new("UIStroke", noGlow)
        noStroke.Color = ORANGE_NEON_DEEP
        noStroke.Thickness = 9
        noStroke.Transparency = 1

        local noText = makeCenterText("NoText", "NO LOL NIGGER", 96, Enum.Font.GothamBlack, T_TEXT2, 13)
        noText.Rotation = -2

        local noScale = Instance.new("UIScale", noText)
        noScale.Scale = 1.22

        local sureGlow = makeCenterText("SureGlow", "KANZ HUB V1", 90, Enum.Font.GothamBlack, ORANGE_NEON_MID, 14)
        local sureStroke = Instance.new("UIStroke", sureGlow)
        sureStroke.Color = ORANGE_NEON_DEEP
        sureStroke.Thickness = 10
        sureStroke.Transparency = 1

        local sure = makeCenterText("Sure", "KANZ HUB V1", 86, Enum.Font.GothamBlack, Color3.fromRGB(255,255,255), 16)
        sure.Position = UDim2.new(0.5,0,0.46,24)
        sureGlow.Position = UDim2.new(0.5,0,0.46,24)

        local sureGrad = Instance.new("UIGradient", sure)
        sureGrad.Rotation = 0
        sureGrad.Offset = Vector2.new(-0.72,0)
        sureGrad.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0.00, TC:Lerp(K,0.25)),
            ColorSequenceKeypoint.new(0.28, TA:Lerp(W,0.35)),
            ColorSequenceKeypoint.new(0.50, Color3.fromRGB(255,255,255)),
            ColorSequenceKeypoint.new(0.72, TA:Lerp(W,0.35)),
            ColorSequenceKeypoint.new(1.00, TC:Lerp(K,0.35))
        })

        local sureScale = Instance.new("UIScale", sure)
        sureScale.Scale = 0.90

        local link = Instance.new("TextLabel")
        link.AnchorPoint = Vector2.new(0.5,0.5)
        link.Position = UDim2.new(0.5,0,0.71,18)
        link.Size = UDim2.new(0.72,0,0,28)
        link.BackgroundTransparency = 1
        link.Text = "https://discord.gg/zBaW2FVry"
        link.Font = Enum.Font.GothamMedium
        link.TextScaled = true
        link.TextColor3 = ORANGE_NEON_LIGHT
        link.TextTransparency = 1
        link.TextStrokeColor3 = Color3.fromRGB(0,0,0)
        link.TextStrokeTransparency = 1
        link.ZIndex = 16
        link.Parent = center

        local under = Instance.new("Frame")
        under.AnchorPoint = Vector2.new(0.5,0.5)
        under.Position = UDim2.new(0.5,0,0.62,13)
        under.Size = UDim2.fromOffset(0,2)
        under.BackgroundColor3 = ORANGE_NEON_MID
        under.BackgroundTransparency = 0.10
        under.BorderSizePixel = 0
        under.ZIndex = 15
        under.Parent = center

        local underGrad = Instance.new("UIGradient", under)
        underGrad.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0,T_DARK1),
            ColorSequenceKeypoint.new(0.5,T_CREAM),
            ColorSequenceKeypoint.new(1,T_DARK1)
        })

        local glitchLeft = Instance.new("Frame")
        glitchLeft.AnchorPoint = Vector2.new(1,0.5)
        glitchLeft.Position = UDim2.new(0.5,-5,0.5,0)
        glitchLeft.Size = UDim2.fromOffset(0,2)
        glitchLeft.BackgroundColor3 = ORANGE_NEON_MID
        glitchLeft.BorderSizePixel = 0
        glitchLeft.BackgroundTransparency = 0.08
        glitchLeft.ZIndex = 7
        glitchLeft.Parent = intro

        local glitchRight = glitchLeft:Clone()
        glitchRight.AnchorPoint = Vector2.new(0,0.5)
        glitchRight.Position = UDim2.new(0.5,5,0.5,0)
        glitchRight.Parent = intro

        local glitchLayer = Instance.new("Frame")
        glitchLayer.Size = UDim2.fromScale(1,1)
        glitchLayer.BackgroundTransparency = 1
        glitchLayer.BorderSizePixel = 0
        glitchLayer.ZIndex = 8
        glitchLayer.Parent = intro

        local glitchColors = {
            ORANGE_NEON_MID,
            Color3.fromRGB(255,255,255),
            Color3.fromRGB(0,0,0)
        }

        task.spawn(function()
            while glitchLayer.Parent do
                task.wait(math.random(7,18)/100)
                for _ = 1, math.random(1,4) do
                    local slice = Instance.new("Frame")
                    slice.BorderSizePixel = 0
                    slice.BackgroundColor3 = glitchColors[math.random(1,#glitchColors)]
                    slice.BackgroundTransparency = math.random(5,45)/100
                    slice.Size = UDim2.new(math.random(12,72)/100,0,0,math.random(1,4))
                    slice.Position = UDim2.new(math.random(0,88)/100,0,math.random(18,82)/100,0)
                    slice.ZIndex = 8
                    slice.Parent = glitchLayer
                    task.delay(math.random(3,10)/100,function()
                        if slice then slice:Destroy() end
                    end)
                end
            end
        end)

        local skipLabel = Instance.new("TextLabel")
        skipLabel.AnchorPoint = Vector2.new(0.5,1)
        skipLabel.Position = UDim2.new(0.5,0,0.965,0)
        skipLabel.Size = UDim2.fromOffset(270,24)
        skipLabel.BackgroundTransparency = 1
        skipLabel.Text = ""
        skipLabel.Font = Enum.Font.GothamMedium
        skipLabel.TextSize = 12
        skipLabel.TextColor3 = ORANGE_NEON_LIGHT
        skipLabel.TextTransparency = 0.12
        skipLabel.Visible = false
        skipLabel.ZIndex = 50
        skipLabel.Parent = intro

        local overlay = Instance.new("Frame")
        overlay.Size = UDim2.fromScale(1,1)
        overlay.BackgroundColor3 = Color3.fromRGB(0,0,0)
        overlay.BackgroundTransparency = 1
        overlay.BorderSizePixel = 0
        overlay.ZIndex = 100
        overlay.Parent = intro

        local flash = Instance.new("Frame")
        flash.Size = UDim2.fromScale(1,1)
        flash.BackgroundColor3 = ORANGE_NEON_MID
        flash.BackgroundTransparency = 1
        flash.BorderSizePixel = 0
        flash.ZIndex = 40
        flash.Parent = intro

        local sound = Instance.new("Sound")
        sound.Name = "M4LWAREIntroMusic"
        sound.Volume = 0.68
        sound.Looped = false
        sound.Parent = SoundService

        task.spawn(function()
            pcall(function()
                local asset = getcustomasset or getsynasset
                if type(asset) ~= "function" or type(writefile) ~= "function" then return end
                local exists = false
                if type(isfile) == "function" then
                    local ok, value = pcall(isfile, SONG_FILE)
                    exists = ok and value == true
                end
                if not exists then
                    local ok, body = pcall(function()
                        return game:HttpGet(SONG_URL)
                    end)
                    if not ok or type(body) ~= "string" or #body == 0 then return end
                    if not pcall(writefile, SONG_FILE, body) then return end
                end
                local ok, id = pcall(asset, SONG_FILE)
                if ok and id and sound.Parent then
                    sound.SoundId = id
                    sound:Play()
                end
            end)
        end)

        local finished = false
        local introDone = false
        local heldInput = nil
        local holdStarted = nil
        local holdGeneration = 0
        local connections = {}
        local startTime = os.clock()

        local function cleanup()
            for _, c in ipairs(connections) do
                pcall(function()
                    c:Disconnect()
                end)
            end
            pcall(function()
                sound:Stop()
                sound:Destroy()
            end)
            pcall(function()
                intro:Destroy()
            end)
            introDone = true
        end

        local function finishIntro(fast)
            if finished then return end
            finished = true
            holdGeneration += 1
            local d = fast and 0.14 or 0.34
            pcall(function()
                TweenService:Create(
                    overlay,
                    TweenInfo.new(d,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),
                    {BackgroundTransparency = 0}
                ):Play()
            end)
            pcall(function()
                TweenService:Create(
                    sound,
                    TweenInfo.new(d,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),
                    {Volume = 0}
                ):Play()
            end)
            task.delay(d + 0.04, cleanup)
        end

        local skipButton = Instance.new("TextButton")
        skipButton.Name = "SkipButton"
        skipButton.AnchorPoint = Vector2.new(1,0)
        skipButton.Position = UDim2.new(1,-16,0,18)
        skipButton.Size = UDim2.fromOffset(88,38)
        skipButton.BackgroundColor3 = T_DARK2
        skipButton.BackgroundTransparency = 0.15
        skipButton.BorderSizePixel = 0
        skipButton.AutoButtonColor = false
        skipButton.Text = "SKIP"
        skipButton.Font = Enum.Font.GothamBold
        skipButton.TextSize = 14
        skipButton.TextColor3 = T_CREAM
        skipButton.ZIndex = 60
        skipButton.Parent = intro
        Instance.new("UICorner", skipButton).CornerRadius = UDim.new(0,8)

        local skipStroke = Instance.new("UIStroke", skipButton)
        skipStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        skipStroke.Color = ORANGE_NEON_MID
        skipStroke.Thickness = 1.5
        skipStroke.Transparency = 0.2

        table.insert(connections, skipButton.Activated:Connect(function()
            finishIntro(true)
        end))

        table.insert(connections, UserInputService.InputBegan:Connect(function(input)
            if finished then return end
            local kind = in