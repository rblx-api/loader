if not game:IsLoaded() then
    pcall(function() game.Loaded:Wait() end)
    repeat task.wait() until game:IsLoaded()
end

local function __KyzDuelsMain()
    local Players = game:GetService("Players")
    local TweenService = game:GetService("TweenService")
    local UIS = game:GetService("UserInputService")
    local CoreGui = game:GetService("CoreGui")
    local RunService = game:GetService("RunService")
    local HttpService = game:GetService("HttpService")
    local Lighting = game:GetService("Lighting")

local function detectIsMobile()
    local touch, kb, mouse, gyro = false, false, false, false
    pcall(function() touch = UIS.TouchEnabled == true end)
    pcall(function() kb = UIS.KeyboardEnabled == true end)
    pcall(function() mouse = UIS.MouseEnabled == true end)
    pcall(function() gyro = UIS.GyroscopeEnabled == true end)
    if kb or mouse then return false end
    if touch and not kb then return true end
    if touch and gyro then return true end
    return false
end
local isMobileDevice = detectIsMobile()
_G.__KyzDuelsIsMobile = isMobileDevice
local function _safeType(v)
        local t = type(v)
        if t == "function" then return true end
        return false
    end

    local function _pick(...)
        for i = 1, select("#", ...) do
            local v = select(i, ...)
            if _safeType(v) then return v end
        end
        return nil
    end

    local _executorName = "Unknown"
    pcall(function()
        if identifyexecutor then
            _executorName = tostring(identifyexecutor() or "Unknown")
        elseif getexecutorname then
            _executorName = tostring(getexecutorname() or "Unknown")
        elseif syn and syn.secure_call then
            _executorName = "Synapse"
        end
    end)
    do
        local low = string.lower(tostring(_executorName))
        if low:find("madium", 1, true) or low:find("medium", 1, true) then
            _executorName = "Madium"
        elseif low:find("volt", 1, true) then
            _executorName = "Volt"
        elseif low:find("wave", 1, true) then
            _executorName = "Wave"
        elseif low:find("solara", 1, true) then
            _executorName = "Solara"
        elseif low:find("xeno", 1, true) then
            _executorName = "Xeno"
        elseif low:find("macsploit", 1, true) or low:find("mac sploit", 1, true) then
            _executorName = "MacSploit"
        end
    end
    _G.__KyzDuelsExecutor = _executorName
    _G.__KyzDuelsIsMadium = (string.lower(tostring(_executorName)) == "madium")

    local _genv = (typeof(getgenv) == "function" and getgenv()) or _G

    isfile = _pick(
        isfile,
        syn and syn.isfile,
        fluxus and fluxus.isfile,
        _genv.isfile,
        (crypt and crypt.isfile)
    ) or function(_) return false end
    readfile = _pick(
        readfile,
        syn and syn.readfile,
        fluxus and fluxus.readfile,
        _genv.readfile
    ) or function(_) return nil end
    writefile = _pick(
        writefile,
        syn and syn.writefile,
        fluxus and fluxus.writefile,
        _genv.writefile
    ) or function(_, __) end
    appendfile = _pick(appendfile, syn and syn.appendfile, _genv.appendfile)
        or function(path, data)
            local old = ""
            pcall(function() old = readfile(path) or "" end)
            writefile(path, old .. tostring(data or ""))
        end
    listfiles = _pick(listfiles, syn and syn.listfiles, _genv.listfiles)
        or function(_) return {} end
    makefolder = _pick(makefolder, syn and syn.makefolder, _genv.makefolder)
        or function(_) end
    isfolder = _pick(isfolder, syn and syn.isfolder, _genv.isfolder)
        or function(_) return false end
    delfile = _pick(delfile, syn and syn.delfile, _genv.delfile)
        or function(_) end

    local _isfile   = isfile
    local _readfile = readfile
    local _writefile = writefile

    getcustomasset = _pick(getcustomasset, getsynasset, syn and syn.getcustomasset, _genv.getcustomasset)

    local _http_request = _pick(
        (syn and syn.request),
        (http and http.request),
        http_request,
        request,
        (fluxus and fluxus.request),
        _genv.request
    )
    request = _http_request
    http_request = _http_request

    local function httpGet(url, useCache)
        url = tostring(url or "")
        if url == "" then return nil end
        local ok, data = pcall(function()
            if game and game.HttpGet then
                return game:HttpGet(url, useCache ~= false)
            end
            return nil
        end)
        if ok and data then return data end
        ok, data = pcall(function()
            if typeof(HttpGet) == "function" then
                return HttpGet(url)
            end
            return nil
        end)
        if ok and data then return data end
        if _http_request then
            ok, data = pcall(function()
                local res = _http_request({ Url = url, Method = "GET" })
                if type(res) == "table" then
                    return res.Body or res.body or res.Data or res.data
                end
                return res
            end)
            if ok and data then return data end
        end
        return nil
    end
    HttpGet = HttpGet or httpGet
    if game and not game.HttpGet then
        end
    _G.__KyzDuelsHttpGet = httpGet

    gethui = _pick(
        gethui,
        get_hidden_gui,
        (syn and syn.protect_gui and function()
            return game:GetService("CoreGui")
        end),
        _genv.gethui,
        _genv.get_hidden_gui
    )

    newcclosure = _pick(newcclosure, protect_function, _genv.newcclosure)
        or function(f) return f end
    checkcaller = _pick(checkcaller, _genv.checkcaller)
        or function() return false end
    clonefunction = _pick(clonefunction, _genv.clonefunction)
        or function(f) return f end
    hookmetamethod = _pick(hookmetamethod, _genv.hookmetamethod)
    hookfunction = _pick(hookfunction, replaceclosure, _genv.hookfunction)

    getconnections = _pick(
        getconnections,
        get_signal_cons,
        getconnects,
        (syn and syn.get_signal_cons),
        _genv.getconnections
    )

    setclipboard = _pick(setclipboard, toclipboard, set_clipboard, (Clipboard and Clipboard.set), _genv.setclipboard)
        or function(_) end

    if not Drawing and _genv.Drawing then
        Drawing = _genv.Drawing
    end

    local function protectGuiInstance(gui)
        if not gui then return end
        pcall(function()
            if syn and syn.protect_gui then
                syn.protect_gui(gui)
            elseif protect_gui then
                protect_gui(gui)
            elseif gethui then
            end
        end)
    end
    _G.__KyzDuelsProtectGui = protectGuiInstance

    local function parentGui(gui)
        if not gui then return false end
        local ok = false
        pcall(function()
            if type(protectGuiInstance) == "function" then
                protectGuiInstance(gui)
            elseif _G.__KyzDuelsProtectGui then
                _G.__KyzDuelsProtectGui(gui)
            end
        end)
        pcall(function()
            if type(gethui) == "function" then
                local host = gethui()
                if host then
                    gui.Parent = host
                    ok = gui.Parent ~= nil
                end
            end
        end)
        if ok then return true end
        pcall(function()
            if type(get_hidden_gui) == "function" then
                local host = get_hidden_gui()
                if host then
                    gui.Parent = host
                    ok = gui.Parent ~= nil
                end
            end
        end)
        if ok then return true end
        pcall(function()
            gui.Parent = CoreGui
            ok = gui.Parent ~= nil
        end)
        if ok then return true end
        pcall(function()
            local pg = LP:FindFirstChild("PlayerGui") or LP:WaitForChild("PlayerGui", 5)
            if pg then
                gui.Parent = pg
                ok = gui.Parent ~= nil
            end
        end)
        return ok
    end

    local CONFIG_FILE = "KyzDuelsConfig.json"
    local LP = Players.LocalPlayer
    if not LP then
        repeat task.wait(0.1) until Players.LocalPlayer
        LP = Players.LocalPlayer
    end

    local spoofedVelocity = Vector3.zero
    local oldIndex, oldNewIndex
    local _hooksOk = false
    pcall(function()
        if true then
            return
        end
        if type(hookmetamethod) ~= "function" then return end
        local nc = newcclosure or function(f) return f end
        local cc = checkcaller or function() return false end
        oldIndex = hookmetamethod(game, "__index", nc(function(self, key)
            if not cc() and (key == "AssemblyLinearVelocity" or key == "Velocity") then
                if typeof(self) == "Instance" and self:IsA("BasePart") and self.Name == "HumanoidRootPart" and self:IsDescendantOf(LP.Character) then
                    return spoofedVelocity
                end
            end
            return oldIndex(self, key)
        end))
        oldNewIndex = hookmetamethod(game, "__newindex", nc(function(self, key, value)
            if not cc() and (key == "AssemblyLinearVelocity" or key == "Velocity") then
                if typeof(self) == "Instance" and self:IsA("BasePart") and self.Name == "HumanoidRootPart" and self:IsDescendantOf(LP.Character) then
                    spoofedVelocity = value
                    return
                end
            end
            return oldNewIndex(self, key, value)
        end))
        _hooksOk = true
    end)
    if not _hooksOk then
        oldIndex = function(self, key)
            return self[key]
        end
        oldNewIndex = function(self, key, value)
            self[key] = value
        end
    end

    do
        -- OLD LinearVelocity speed system DISABLED — May.VS engine owns movement
        local SL = {
            MOVE_KEYS = {
                [Enum.KeyCode.W]=true,[Enum.KeyCode.A]=true,[Enum.KeyCode.S]=true,[Enum.KeyCode.D]=true,
                [Enum.KeyCode.Up]=true,[Enum.KeyCode.Down]=true,[Enum.KeyCode.Left]=true,[Enum.KeyCode.Right]=true,
            },
        }
        _G.__KyzDuelsSpeedLV = SL

        function SL.getOrMake(hrp)
            -- never create LV; only strip leftovers
            if not hrp then return nil end
            for _, n in ipairs({"_RHSpeedLV", "AdaptHorizontalSpeed", "AdaptSpeedAttachment", "MuzanBoostLV"}) do
                local o = hrp:FindFirstChild(n)
                if o then pcall(function() o:Destroy() end) end
            end
            return nil
        end

        function SL.set(hrp, x, z)
            -- no-op (May.VS handles velocity)
        end

        function SL.clear(hrp)
            if not hrp then return end
            for _, n in ipairs({"_RHSpeedLV", "AdaptHorizontalSpeed", "AdaptSpeedAttachment", "MuzanBoostLV"}) do
                local o = hrp:FindFirstChild(n)
                if o then pcall(function() o:Destroy() end) end
            end
        end
    end

    function getMoveDirectionForSpeed(humanoid)
        if not humanoid then return nil end
        local st = State or _G.State
        local dir = humanoid.MoveDirection
        if dir.Magnitude > 0.05 then
            if st then st.lastMoveDir = dir end
            return dir.Unit
        end
        local last = st and st.lastMoveDir
        if last and last.Magnitude > 0.05 then
            local held = false
            if UIS:IsKeyDown(Enum.KeyCode.W) then held = true end
            if UIS:IsKeyDown(Enum.KeyCode.A) then held = true end
            if UIS:IsKeyDown(Enum.KeyCode.S) then held = true end
            if UIS:IsKeyDown(Enum.KeyCode.D) then held = true end
            if UIS:IsKeyDown(Enum.KeyCode.Up) then held = true end
            if UIS:IsKeyDown(Enum.KeyCode.Left) then held = true end
            if UIS:IsKeyDown(Enum.KeyCode.Down) then held = true end
            if UIS:IsKeyDown(Enum.KeyCode.Right) then held = true end
            if held then return last.Unit end
        end
        return nil
    end

    function applyVelocitySpeed(speed)
        local char = LP.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if not hum or hum.Health <= 0 then return end
        pcall(function()
            hum.WalkSpeed = math.clamp(tonumber(speed) or 16, 0, 500)
        end)
    end

    local introFinishedEvent = Instance.new("BindableEvent")
    local SoundService = game:GetService("SoundService")

    selectedIntroMusic = tonumber(selectedIntroMusic) or 1
    _introEnabled = (_introEnabled ~= false)
    setIntroVisual = nil
    setIntroSongVisual = nil
    -- always refresh list (executor globals can keep a stale table)
    INTRO_MUSIC_OPTIONS = {
        {name = "Song 1", url = "https://files.catbox.moe/eyx9v8.mp3", file = "KyzDuelsIntroSong_1.mp3", startTime = 8},
        {name = "Song 2", url = "https://files.catbox.moe/p2qhls.mp3", file = "KyzDuelsIntroSong_2.mp3", startTime = 0},
        {name = "Song 3", url = "https://files.catbox.moe/iyw1cb.mp3", file = "KyzDuelsIntroSong_3.mp3", startTime = 0},
    }

    function getIntroSongName()
        local opt = INTRO_MUSIC_OPTIONS[selectedIntroMusic]
        return opt and opt.name or "No Songs Added"
    end

    local function _normalizeIntroMusicIndex(v)
        if type(v) == "number" and v == v and v >= 1 then
            local n = math.floor(v)
            if n > #INTRO_MUSIC_OPTIONS then n = #INTRO_MUSIC_OPTIONS end
            return n
        end
        local s = tostring(v or "")
        local n = tonumber(s)
        if not n then
            n = tonumber(s:match("(%d+)"))
        end
        if not n or n < 1 then n = 1 end
        if n > #INTRO_MUSIC_OPTIONS then n = #INTRO_MUSIC_OPTIONS end
        return math.floor(n)
    end

    local function _introParentGui(gui)
        if not gui then return end
        pcall(function()
            if type(parentGui) == "function" then
                parentGui(gui)
            elseif type(gethui) == "function" then
                gui.Parent = gethui()
            else
                gui.Parent = CoreGui
            end
        end)
        if not gui.Parent then
            pcall(function() gui.Parent = CoreGui end)
        end
        if not gui.Parent then
            pcall(function()
                local pg = LP:FindFirstChild("PlayerGui") or LP:WaitForChild("PlayerGui", 3)
                if pg then gui.Parent = pg end
            end)
        end
    end

    local function _httpGetBinary(url)
        local data = nil
        local ok, res = pcall(function()
            if type(request) == "function" then
                return request({Url = url, Method = "GET"})
            end
            if type(http_request) == "function" then
                return http_request({Url = url, Method = "GET"})
            end
            if syn and type(syn.request) == "function" then
                return syn.request({Url = url, Method = "GET"})
            end
            if http and type(http.request) == "function" then
                return http.request({Url = url, Method = "GET"})
            end
            return nil
        end)
        if ok and res then
            if type(res) == "table" then
                data = res.Body or res.body or res.Data or res.data
            elseif type(res) == "string" then
                data = res
            end
        end
        if (not data or #tostring(data) < 1000) then
            pcall(function()
                if game and game.HttpGet then
                    data = game:HttpGet(url)
                elseif type(HttpGet) == "function" then
                    data = HttpGet(url)
                end
            end)
        end
        if type(data) == "string" and #data > 1000 then
            return data
        end
        return nil
    end

    local function _playIntroMusic(sound, opt)
        if not sound then return end
        opt = opt or INTRO_MUSIC_OPTIONS[selectedIntroMusic or 1] or INTRO_MUSIC_OPTIONS[1]
        if not opt then return end
        local soundUrl = tostring(opt.url or "")
        local fileName = tostring(opt.file or "KyzDuelsIntroSong.mp3")
        local startTime = tonumber(opt.startTime) or 0

        local function applyAndPlay(assetId)
            if not assetId or tostring(assetId) == "" then return false end
            local ok = false
            pcall(function()
                sound.SoundId = assetId
                sound.Volume = 1.5
                sound.TimePosition = 0
                sound:Play()
                -- seek after play starts (Song 1 → 8s)
                if startTime > 0 then
                    sound.TimePosition = startTime
                    -- some executors need a tiny delay before seek sticks
                    task.defer(function()
                        pcall(function()
                            if sound and sound.Parent then
                                sound.TimePosition = startTime
                            end
                        end)
                    end)
                end
                ok = true
            end)
            return ok
        end

        local function tryFromFile()
            local okFile = false
            pcall(function()
                if isfile and isfile(fileName) then okFile = true end
            end)
            if not okFile or not getcustomasset then return false end
            local ok, assetId = pcall(getcustomasset, fileName)
            if ok then
                return applyAndPlay(assetId)
            end
            return false
        end

        -- instant path: cached file
        if tryFromFile() then return true end

        -- download then play
        local data = _httpGetBinary(soundUrl)
        if data and #data > 5000 then
            pcall(function()
                if delfile and isfile and isfile(fileName) then delfile(fileName) end
            end)
            pcall(function()
                if writefile then writefile(fileName, data) end
            end)
            task.wait(0.12)
            if tryFromFile() then return true end
        end

        -- direct url fallback
        pcall(function()
            sound.SoundId = soundUrl
            sound.Volume = 1.5
            sound:Play()
            if startTime > 0 then
                sound.TimePosition = startTime
                task.defer(function()
                    pcall(function()
                        if sound and sound.Parent then sound.TimePosition = startTime end
                    end)
                end)
            end
        end)
        return false
    end


    -- preload intro songs in background so playback is instant with UI
    task.spawn(function()
        for _, opt in ipairs(INTRO_MUSIC_OPTIONS) do
            pcall(function()
                if not opt or not opt.file or not opt.url then return end
                local has = false
                pcall(function()
                    if isfile and isfile(opt.file) then has = true end
                end)
                if has then return end
                local data = _httpGetBinary(opt.url)
                if data and #data > 5000 and writefile then
                    pcall(writefile, opt.file, data)
                end
            end)
            task.wait(0.05)
        end
    end)

    -- Single intro visual; music from INTRO_MUSIC_OPTIONS[selectedIntroMusic]
    function playIntroAnimation()
        if _introEnabled == false then
            pcall(function() introFinishedEvent:Fire() end)
            return
        end

        selectedIntroMusic = _normalizeIntroMusicIndex(
            (State and State.introMode) or (State and State.selectedIntroMusic) or selectedIntroMusic or 1
        )
        if State then
            State.introMode = tostring(selectedIntroMusic)
            State.selectedIntroMusic = selectedIntroMusic
        end

        local track = INTRO_MUSIC_OPTIONS[selectedIntroMusic] or INTRO_MUSIC_OPTIONS[1]
        local skipped = false

        local sound = Instance.new("Sound")
        sound.Name = "KyzDuelsIntroSong"
        sound.Volume = 1.5
        sound.Looped = false
        sound.PlaybackSpeed = 1
        pcall(function() sound.Parent = SoundService end)
        if not sound.Parent then
            pcall(function() sound.Parent = workspace end)
        end
        if not sound.Parent then
            pcall(function()
                local pg = LP:FindFirstChild("PlayerGui")
                sound.Parent = pg or LP
            end)
        end

        pcall(function()
            if type(setIntroSongVisual) == "function" then
                setIntroSongVisual(getIntroSongName())
            end
        end)
        pcall(function()
            if type(setIntroVisual) == "function" then
                setIntroVisual()
            end
        end)

        local intro = Instance.new("ScreenGui")
        intro.Name = "KyzDuels_Intro"
        intro.IgnoreGuiInset = true
        intro.DisplayOrder = 999999
        intro.ZIndexBehavior = Enum.ZIndexBehavior.Global
        _introParentGui(intro)

        -- music starts the same moment the intro UI is on screen
        -- prefer cached file (preloaded); if missing, fetch without blocking UI via spawn
        local played = false
        pcall(function()
            local fileName = track.file
            local has = false
            pcall(function()
                if isfile and isfile(fileName) and getcustomasset then has = true end
            end)
            if has then
                played = _playIntroMusic(sound, track) and true or false
            end
        end)
        if not played then
            task.spawn(function()
                pcall(function()
                    _playIntroMusic(sound, track)
                end)
            end)
        end

        local blur = Instance.new("BlurEffect")
        blur.Name = "KyzIntroBlur"
        blur.Size = 0
        blur.Parent = Lighting
        TweenService:Create(blur, TweenInfo.new(0.55, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = 22}):Play()

        local dark = Instance.new("Frame", intro)
        dark.Name = "DarkOverlay"
        dark.Size = UDim2.new(1, 0, 1, 0)
        dark.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        dark.BackgroundTransparency = 1
        dark.BorderSizePixel = 0
        dark.ZIndex = 1
        TweenService:Create(dark, TweenInfo.new(0.55, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0.38}):Play()

        local skipBtn = Instance.new("TextButton", intro)
        skipBtn.Name = "SkipButton"
        skipBtn.Size = UDim2.new(1, 0, 1, 0)
        skipBtn.BackgroundTransparency = 1
        skipBtn.Text = ""
        skipBtn.ZIndex = 10

        local skipText = Instance.new("TextLabel", intro)
        skipText.Name = "SkipText"
        skipText.Size = UDim2.new(0, 260, 0, 24)
        skipText.Position = UDim2.new(0.5, 0, 0.5, 155)
        skipText.AnchorPoint = Vector2.new(0.5, 0.5)
        skipText.BackgroundTransparency = 1
        skipText.Text = "Tap the screen to skip."
        skipText.TextColor3 = Color3.fromRGB(220, 220, 220)
        skipText.TextTransparency = 1
        skipText.Font = Enum.Font.GothamMedium
        skipText.TextSize = 13
        skipText.ZIndex = 6
        TweenService:Create(skipText, TweenInfo.new(0.9, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 0.25}):Play()

        local mScale = 0.52
        local kyzY, duelsY = -70, 70
        local kyzSize, duelsSize = math.floor(260 * mScale), math.floor(190 * mScale)
        local kyzGap, duelsGap = 95, 72
        local lettersData = {
            {name = "KyzLetter1", id = "rbxassetid://89514740068244", basePos = UDim2.new(0.5, -kyzGap, 0.5, kyzY), size = UDim2.new(0, kyzSize, 0, kyzSize)},
            {name = "KyzLetter2", id = "rbxassetid://80304635899116", basePos = UDim2.new(0.5, 0, 0.5, kyzY), size = UDim2.new(0, kyzSize, 0, kyzSize)},
            {name = "KyzLetter3", id = "rbxassetid://103371531737702", basePos = UDim2.new(0.5, kyzGap, 0.5, kyzY), size = UDim2.new(0, kyzSize, 0, kyzSize)},
            {name = "DuelsLetter1", id = "rbxassetid://135491935105785", basePos = UDim2.new(0.5, -duelsGap * 2, 0.5, duelsY), size = UDim2.new(0, duelsSize, 0, duelsSize)},
            {name = "DuelsLetter2", id = "rbxassetid://128808712780546", basePos = UDim2.new(0.5, -duelsGap, 0.5, duelsY), size = UDim2.new(0, duelsSize, 0, duelsSize)},
            {name = "DuelsLetter3", id = "rbxassetid://79556969285274", basePos = UDim2.new(0.5, 0, 0.5, duelsY), size = UDim2.new(0, duelsSize, 0, duelsSize)},
            {name = "DuelsLetter4", id = "rbxassetid://75397848373510", basePos = UDim2.new(0.5, duelsGap, 0.5, duelsY), size = UDim2.new(0, duelsSize, 0, duelsSize)},
            {name = "DuelsLetter5", id = "rbxassetid://86833743553586", basePos = UDim2.new(0.5, duelsGap * 2, 0.5, duelsY), size = UDim2.new(0, duelsSize, 0, duelsSize)},
        }
        local letters = {}
        local connections = {}
        for i, data in ipairs(lettersData) do
            local img = Instance.new("ImageLabel")
            img.Name = data.name
            img.Size = UDim2.new(0, data.size.X.Offset * 0.25, 0, data.size.Y.Offset * 0.25)
            img.Position = data.basePos
            img.AnchorPoint = Vector2.new(0.5, 0.5)
            img.BackgroundTransparency = 1
            img.Image = data.id
            img.ScaleType = Enum.ScaleType.Fit
            img.ImageTransparency = 1
            img.ZIndex = 5
            img.Parent = intro
            table.insert(letters, {
                img = img,
                finalSize = data.size,
                basePos = data.basePos,
                phase = (i - 1) * 0.55,
                amp = 6 + (i % 2) * 2
            })
            task.delay((i - 1) * 0.07, function()
                if skipped then return end
                TweenService:Create(img, TweenInfo.new(0.65, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                    Size = data.size,
                    ImageTransparency = 0
                }):Play()
            end)
        end

        local startTime = tick()
        local waveConn = RunService.RenderStepped:Connect(function()
            if skipped then return end
            local t = tick() - startTime
            for _, letter in ipairs(letters) do
                local img = letter.img
                if img and img.Parent then
                    local offsetY = math.sin(t * 2.1 + letter.phase) * letter.amp
                    img.Position = UDim2.new(
                        letter.basePos.X.Scale,
                        letter.basePos.X.Offset,
                        letter.basePos.Y.Scale,
                        letter.basePos.Y.Offset + offsetY
                    )
                end
            end
        end)
        table.insert(connections, waveConn)

        local function cleanup()
            if skipped then return end
            skipped = true
            for _, c in ipairs(connections) do
                pcall(function() c:Disconnect() end)
            end
            for _, letter in ipairs(letters) do
                if letter.img and letter.img.Parent then
                    TweenService:Create(letter.img, TweenInfo.new(0.38, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
                        Size = UDim2.new(0, letter.finalSize.X.Offset * 0.2, 0, letter.finalSize.Y.Offset * 0.2),
                        ImageTransparency = 1
                    }):Play()
                end
            end
            TweenService:Create(skipText, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
            TweenService:Create(dark, TweenInfo.new(0.35), {BackgroundTransparency = 1}):Play()
            TweenService:Create(blur, TweenInfo.new(0.35), {Size = 0}):Play()
            pcall(function()
                sound:Stop()
                sound:Destroy()
            end)
            task.delay(0.4, function()
                pcall(function() blur:Destroy() end)
                pcall(function() intro:Destroy() end)
                pcall(function() introFinishedEvent:Fire() end)
            end)
        end
        skipBtn.MouseButton1Click:Connect(cleanup)
        pcall(function() skipBtn.TouchTap:Connect(cleanup) end)
        local inputConn
        inputConn = UIS.InputBegan:Connect(function(input, gp)
            if gp then return end
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                cleanup()
                if inputConn then inputConn:Disconnect() end
            end
        end)
        table.insert(connections, inputConn)
        task.delay(5.9, function()
            if skipped then return end
            cleanup()
        end)
    end




    local h, hrp
    local bodyForce = nil
    local antiRagdollConn = nil
    local speedBoxRefs = {}
    local keybindBtnRefs = {}
    local toggleRefs = {}
    local activeKeybindListener = nil
    local activeKeybindBtn = nil
    local activeKeybindKeyRef = nil
    local activeKeybindPrevText = nil

    local isCurrentlyStealing = false
    local autoGrabStopEnabled = false
    local autoGrabStopTime = 1.29
    local autoGrabDelayRadius = 8
    local autoStealConnection = nil
    local barResetTween = nil
    local progressPct, progressFill

    local Steal = {
        AutoStealEnabled = false,
        StealRadius = 60,
        StealDuration = 1.3,
        Data = {},
        AutoGrabStopEnabled = false,
        AutoGrabStopTime = 1.29,
        AutoGrabDelayRadius = 8,
    }

    FILL_LIGHT = Color3.fromRGB(255, 255, 255)
    FILL_DARK  = Color3.fromRGB(230, 230, 235)

    function syncStealAliases()
        Steal.AutoGrabStopEnabled = autoGrabStopEnabled
        Steal.AutoGrabStopTime = autoGrabStopTime
        Steal.AutoGrabDelayRadius = autoGrabDelayRadius
    end

    function setupChar(char)
        h = char:WaitForChild("Humanoid", 5)
        hrp = char:WaitForChild("HumanoidRootPart", 5)
        if bodyForce then
            pcall(function() bodyForce:Destroy() end)
        end
        bodyForce = Instance.new("BodyForce")
        bodyForce.Force = Vector3.new(0, 0, 0)
        pcall(function() bodyForce.Parent = hrp end)
        pcall(handleRagdollCountdown, char)
    end

    function applyBodyForceVelocity(targetVel, deltaTime)
        if not (hrp and bodyForce and h) then return end
        currentVel = hrp.AssemblyLinearVelocity
        diff = targetVel - currentVel
        mass = hrp:GetMass() or 2
        forceAmount = diff * mass / deltaTime
        forceAmount = Vector3.new(forceAmount.X, 0, forceAmount.Z)
        bodyForce.Force = forceAmount
    end

    function clearBodyForce()
        if bodyForce then
            bodyForce.Force = Vector3.new(0, 0, 0)
        end
    end

    LP.CharacterAdded:Connect(function(char)
        setupChar(char)
        if State and State.autoStealEnabled then
            task.defer(function()
                task.wait(0.6)
                pcall(restartAutoStealForMode)
            end)
        end
    end)
    if LP.Character then
        task.spawn(function() setupChar(LP.Character) end)
    end

    State = {
        normalSpeed = 59.5, carrySpeed = 28.8, laggerSpeed = 29, normalLaggerSpeed = 45, laggerCarrySpeed = 15,
        speedMode = 0, laggerMode = 0, lastLaggerMode = 1,
        infJumpEnabled = false, antiRagdollEnabled = true, antiDropSpoof = true, antiLagEnabled = false, transparentMapEnabled = false, xrayEnabled = false,
        batMedusaTransparent = false,
        batMedusaRainbow = false,
        batCustomEnabled = false,
        batCustomKey = "diamond",
        batNoSound = false, -- only kills custom swing SFX; skins stay
        skullCustomEnabled = false,
        skullCustomKey = "evil",
        guiVisible = true, uiLocked = false,
        isStealing = false, stealStartTime = nil, lastStealTick = 0,
        medusaLastUsed = 0, medusaDebounce = false, medusaCounterEnabled = false, antiMedusaEnabled = false,
        noCollideEnabled = false,
        batCounterEnabled = false, batCounterDebounce = false,
        dropEnabled = false,
        dropMode = 0,
        dropAfterAction = "off",
        lastMoveDir = Vector3.new(0,0,0),
        unwalkEnabled = false,
        autoStealEnabled = false,
        autoStealMode = "V3",
        syncStealRagdoll = false,
        stealRadiusNormal = 60,
        countdownActive = false,
        stretchRezEnabled = true,
        fovEnabled = false,
        zombieAnimsEnabled = false,
        ragdollCountdownEnabled = true,
        tryhardAnimEnabled = false,
        tryhardAnimMode = 0,
        customAnimPack = {
            idle = nil,
            walk = nil,
            run = nil,
            jump = nil,
            fall = nil,
            climb = nil,
        },
        nightModeEnabled = true,
        autoLeftEnabled = false, autoRightEnabled = false,
        autoLeftPhase = 1, autoRightPhase = 1,
        gameTheme = "Off",
        removeAccEnabled = false,
        autoSwingEnabled = true,
        hittingCooldown = false,
        stealsCount = 0,
        guiPosition = {X = {Scale = 0, Offset = 8}, Y = {Scale = 0, Offset = 8}},
        stealBarPosition = {X = {Scale = 0.5, Offset = -160}, Y = {Scale = 0, Offset = 6}},
        hideMobileButtons = false, lockMobileButtons = false,
        mobileButtonSize = 56,
        skipIntroEnabled = false,
        introMode = "1",
        selectedIntroMusic = 1,
        keyboardEnabled = false, -- removed
        noCamCollisionEnabled = false,
        shinyGraphicsEnabled = false,
        antiVoidEnabled = false,
        customFontEnabled = false,
        customFontName = "Base",
        customFontAuto = false,
        espEnabled = false,
        espMode = "noLine", espBoxEnabled = false,
        autoCarrySpeedEnabled = false,
        safeModeEnabled = false,
        kickWarningEnabled = false,
        highPingWarnEnabled = false,
        skinKorblox = false,
        skinHeadless = false,
        customSkins = {}, -- { {key,name,assetId,cat,gender,image}, ... }
        skinFireHead = false,
        skinHornWhite = false,
        antiDieEnabled = true, -- internal always-on
        antiFlingEnabled = false,
        backgroundIndex = 0,
        batAimbotToggled = false,
        aimbotMode = "normal",
        tpBatEnabled = false,
        playerPosMarker = false, -- removed
        tpBatMode = "V1", -- V1 mwvane | V2 behind
        antiBatTpEnabled = false,
        antiBatTpMode = "V1", -- V1 hub | V2 Fake Y=-1000 | V3 Desync extreme Y
        HitDistance = 5,
        SwingCooldown = 0.08,
        AimbotSpeed = 62,
        autoTPEnabled = false,
        autoTPHeight = 20,
        autoTPConn = nil,
    }
    _G.State = State

    do
        local _wsDestroyed = {}
        local _wsWatch = {}
        local _wsPatterns = {
            "websocket", "ws_", "_ws", "wss", "socket",
            "zl", "ace", "realtime", "bridge",
            "gateway", "tunnel", "relay", "handshake",
            "protocol", "wschannel", "socketio", "socket_io",
        }
        local function _wsMatch(name)
            local l = string.lower(tostring(name or ""))
            for _, p in ipairs(_wsPatterns) do
                if string.find(l, p, 1, true) then return true end
            end
            return false
        end
        local function _wsKill(obj)
            if not obj or _wsDestroyed[obj] then return end
            _wsDestroyed[obj] = true
            pcall(function() obj:Destroy() end)
        end
        local function _wsScan(root)
            if not root then return end
            for _, obj in ipairs(root:GetDescendants()) do
                if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction")
                    or obj:IsA("BindableEvent") or obj:IsA("BindableFunction") then
                    if _wsMatch(obj.Name) then _wsKill(obj) end
                end
            end
        end
        local function _wsWatchRoot(root)
            if not root then return end
            local c = root.DescendantAdded:Connect(function(obj)
                if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction")
                    or obj:IsA("BindableEvent") or obj:IsA("BindableFunction") then
                    if _wsMatch(obj.Name) then
                        task.defer(function() _wsKill(obj) end)
                    end
                end
            end)
            table.insert(_wsWatch, c)
        end
        pcall(function()
            local rs = game:GetService("ReplicatedStorage")
            local rf = game:GetService("ReplicatedFirst")
            _wsScan(rs); _wsScan(rf); _wsScan(workspace)
            _wsWatchRoot(rs); _wsWatchRoot(rf); _wsWatchRoot(workspace)
        end)
        _G.__VioletInternalAntiCrash = true
    end

    Keys = {
        speed = Enum.KeyCode.Q,
        normalSpeed = Enum.KeyCode.Z,
        lagger = Enum.KeyCode.R,
        drop = Enum.KeyCode.H,
        tpDown = Enum.KeyCode.V,
        unwalk = Enum.KeyCode.U,
        autoLeft = Enum.KeyCode.L,
        autoRight = Enum.KeyCode.R,
        guiHide = Enum.KeyCode.LeftControl,
        instaReset = Enum.KeyCode.G,
        aimbot = Enum.KeyCode.E,
        tpBat = Enum.KeyCode.T,
        antiBatTp = Enum.KeyCode.Y,
    }

    function getKeyName(kc)
        n = kc.Name
        if n == "Unknown" then return "-" end
        if n == "LeftControl" then return "CTRL" end
        if n == "RightControl" then return "RCTL" end
        if n == "LeftShift" then return "SHFT" end
        if n == "Space" then return "SPC" end
        if n == "ButtonA" then return "A" end
        if n == "ButtonB" then return "B" end
        if n == "ButtonX" then return "X" end
        if n == "ButtonY" then return "Y" end
        if n == "ButtonL1" then return "LB" end
        if n == "ButtonR1" then return "RB" end
        if n == "ButtonL2" then return "LT" end
        if n == "ButtonR2" then return "RT" end
        if n == "ButtonL3" then return "LS" end
        if n == "ButtonR3" then return "RS" end
        if n == "ButtonSelect" then return "SEL" end
        if n == "ButtonStart" then return "STA" end
        if n == "DPadUp" then return "DU" end
        if n == "DPadDown" then return "DD" end
        if n == "DPadLeft" then return "DL" end
        if n == "DPadRight" then return "DR" end
        return n:sub(1, 4):upper()
    end
    function trackConn(c) return c end

    Conns = {
        aimbot = nil,
        batCounter = nil,
        noCollideLoop = nil,
        antiRagdoll = nil,
        unwalk = nil,
        anchor = {},
    }

    speedModeNames = {
        [0] = "Normal Speed",
        [1] = "Carry Speed",
        [2] = "Normal Lagger Speed",
        [3] = "Carry Lagger Speed"
    }
    laggerModeNames = {[1] = "Carry Speed", [2] = "Normal Speed"}
    dropModeNames = {[0] = "Stand Drop", [1] = "Jump Drop"}
    tryhardAnimModeNames = {[0] = "V1", [1] = "V2", [2] = "V3", [3] = "V4", [4] = "CUSTOM"}


    SKY_PRESETS_LIST = {"Off", "Night"}
    SKY_PRESETS = {
        ["Off"] = {kind = "off"},
        ["Night"] = {
            clock = 22,
            brightness = 2,
            ambient = {110, 100, 130},
            outAmb = {120, 110, 140},
            sky = {stars = 4000, moon = 18, sun = 0, moonTex = true},
            atm = {dens = 0.45, color = {120, 60, 180}, decay = {60, 20, 100}, glare = 0.5, haze = 1.2},
        },
    }

    Lighting = game:GetService("Lighting")
    function _vC3(t) return Color3.fromRGB(t[1], t[2], t[3]) end

    local _skyEventConnections = {}
    local _skyApplyToken = 0

    function _v4mpClearSky()
        for _, v in ipairs(Lighting:GetChildren()) do
            if v:GetAttribute("_V4MPSky") then pcall(function() v:Destroy() end) end
        end
        local terrain = workspace:FindFirstChildOfClass("Terrain")
        if terrain then
            for _, v in ipairs(terrain:GetChildren()) do
                if v:GetAttribute("_V4MPSky") then pcall(function() v:Destroy() end) end
            end
        end
    end

    local function clearSkyConnections()
        for _, conn in ipairs(_skyEventConnections) do
            pcall(function() conn:Disconnect() end)
        end
        _skyEventConnections = {}
    end

    local function _isProtectedLightingObj(obj)
        if not obj then return false end
        if obj:GetAttribute("_V4MPSky") then return true end
        if obj:GetAttribute("_KyzShiny") then return true end
        if obj:GetAttribute("_AmbitiousVivid") then return true end
        return false
    end

    local function createNightSkyObjects()
        -- only recreate our Night objects; leave Shiny alone
        local hasSky = false
        for _, v in ipairs(Lighting:GetChildren()) do
            if v:IsA("Sky") and v:GetAttribute("_V4MPSky") then hasSky = true break end
        end
        if not hasSky then
            local sky = Instance.new("Sky")
            sky:SetAttribute("_V4MPSky", true)
            sky.StarCount = 4000
            sky.MoonAngularSize = 18
            sky.SunAngularSize = 0
            sky.MoonTextureId = "rbxasset://sky/moon.jpg"
            sky.Parent = Lighting
        end
        local hasAtm = false
        for _, v in ipairs(Lighting:GetChildren()) do
            if v:IsA("Atmosphere") and v:GetAttribute("_V4MPSky") then hasAtm = true break end
        end
        if not hasAtm then
            -- if Shiny already owns an Atmosphere, still add Night atm only when shiny is off
            local atm = Instance.new("Atmosphere")
            atm:SetAttribute("_V4MPSky", true)
            atm.Density = 0.45
            atm.Color = Color3.fromRGB(120, 60, 180)
            atm.Decay = Color3.fromRGB(60, 20, 100)
            atm.Glare = 0.5
            atm.Haze = 1.2
            atm.Parent = Lighting
        end
    end

    local function lockNightLightingValues()
        pcall(function()
            if Lighting.ClockTime ~= 22 then Lighting.ClockTime = 22 end
            if Lighting.Brightness ~= 2 then Lighting.Brightness = 2 end
            local amb = Color3.fromRGB(110, 100, 130)
            local out = Color3.fromRGB(120, 110, 140)
            if Lighting.Ambient ~= amb then Lighting.Ambient = amb end
            if Lighting.OutdoorAmbient ~= out then Lighting.OutdoorAmbient = out end
        end)
    end

    function applyCustomSky(mode)
        clearSkyConnections()
        _skyApplyToken = _skyApplyToken + 1
        local myToken = _skyApplyToken

        _v4mpClearSky()
        local preset = SKY_PRESETS[mode]
        if not preset or preset.kind == "off" or mode == "Off" or mode == nil then
            Lighting.FogEnd = 100000
            Lighting.FogStart = 0
            Lighting.FogColor = Color3.fromRGB(192, 192, 192)
            Lighting.Brightness = 2
            Lighting.ClockTime = 14
            Lighting.GlobalShadows = true
            State.gameTheme = "Off"
            State.nightModeEnabled = false
            return
        end

        -- Apply Night once
        Lighting.FogEnd = 100000
        Lighting.FogStart = 0
        Lighting.FogColor = Color3.fromRGB(200, 200, 200)
        Lighting.GlobalShadows = true
        Lighting.ClockTime = preset.clock or 22
        Lighting.Brightness = preset.brightness or 2
        if preset.outAmb then Lighting.OutdoorAmbient = _vC3(preset.outAmb) end
        if preset.ambient then Lighting.Ambient = _vC3(preset.ambient) end

        createNightSkyObjects()

        State.gameTheme = "Night"
        State.nightModeEnabled = true

        -- 1) Force Lighting props back when the game overwrites them
        local function onLightingPropChanged(prop)
            return function()
                if myToken ~= _skyApplyToken then return end
                if not State or State.gameTheme ~= "Night" then return end
                lockNightLightingValues()
            end
        end
        for _, prop in ipairs({"ClockTime", "Brightness", "OutdoorAmbient", "Ambient"}) do
            local conn = Lighting:GetPropertyChangedSignal(prop):Connect(onLightingPropChanged(prop))
            table.insert(_skyEventConnections, conn)
        end

        -- 2) Destroy foreign Sky/Atmosphere the game injects; recreate ours
        local function onForeignObjectAdded(obj)
            if myToken ~= _skyApplyToken then return end
            if not State or State.gameTheme ~= "Night" then return end
            if _isProtectedLightingObj(obj) then return end
            if obj:IsA("Sky") or obj:IsA("Atmosphere") then
                pcall(function() obj:Destroy() end)
                task.defer(function()
                    if myToken == _skyApplyToken and State and State.gameTheme == "Night" then
                        createNightSkyObjects()
                        lockNightLightingValues()
                    end
                end)
            end
        end
        table.insert(_skyEventConnections, Lighting.ChildAdded:Connect(onForeignObjectAdded))

        -- 3) If our Night objects get destroyed, recreate them
        local function attachAncestry(obj)
            if not obj then return end
            local conn = obj.AncestryChanged:Connect(function(_, parent)
                if parent then return end
                if myToken ~= _skyApplyToken then return end
                if not State or State.gameTheme ~= "Night" then return end
                task.defer(function()
                    if myToken == _skyApplyToken and State and State.gameTheme == "Night" then
                        createNightSkyObjects()
                        lockNightLightingValues()
                    end
                end)
            end)
            table.insert(_skyEventConnections, conn)
        end
        for _, v in ipairs(Lighting:GetChildren()) do
            if v:GetAttribute("_V4MPSky") then attachAncestry(v) end
        end

        -- 4) Soft heartbeat lock (game scripts often write ClockTime every frame)
        local hb = RunService.Heartbeat:Connect(function()
            if myToken ~= _skyApplyToken then return end
            if not State or State.gameTheme ~= "Night" then return end
            lockNightLightingValues()
        end)
        table.insert(_skyEventConnections, hb)
    end

    function applyTheme()
        applyCustomSky(State.gameTheme)
    end

    function updateThemeUI()
        if toggleRefs.themeCycleLabel then
            toggleRefs.themeCycleLabel.Text = State.gameTheme
        end
    end

    _ragCdActive = false
    _ragCdLast = 0
    _ragCdReadyAt = os.clock() + 2.5

    pcall(function()
        old = CoreGui:FindFirstChild("KyzDuelsRagdollCountdown")
        if old then old:Destroy() end
    end)
    pcall(function()
        pg = LP:FindFirstChild("PlayerGui")
        if pg then
            old = pg:FindFirstChild("KyzDuelsRagdollCountdown")
            if old then old:Destroy() end
        end
    end)

    function showRagdollCountdownUI()
        if not State or not State.ragdollCountdownEnabled then return end
        if os.clock() < _ragCdReadyAt then return end
        now = os.clock()
        if _ragCdActive or (now - _ragCdLast) < 1.5 then return end
        _ragCdLast = now
        _ragCdActive = true

        pcall(function()
            old = CoreGui:FindFirstChild("KyzDuelsRagdollCountdown")
            if old then old:Destroy() end
        end)
        pcall(function()
            pg = LP:FindFirstChild("PlayerGui")
            if pg then
                old = pg:FindFirstChild("KyzDuelsRagdollCountdown")
                if old then old:Destroy() end
            end
        end)

        gui = Instance.new("ScreenGui")
        gui.Name = "KyzDuelsRagdollCountdown"
        gui.IgnoreGuiInset = true
        gui.ResetOnSpawn = false
        gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        gui.DisplayOrder = 100000
        gui.Enabled = true

        if not parentGui(gui) then
            _ragCdActive = false
            return
        end

        frame = Instance.new("Frame")
        frame.Name = "CountdownFrame"
        frame.AnchorPoint = Vector2.new(1, 1)
        frame.Size = UDim2.fromOffset(96, 40)
        ragY = -130
        pcall(function()
            if UIS.TouchEnabled then
                ragY = -145
            end
        end)
        frame.Position = UDim2.new(1, 160, 1, ragY)
        frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        frame.BackgroundTransparency = 0
        frame.BorderSizePixel = 0
        frame.ZIndex = 500
        frame.Visible = true
        frame.Parent = gui

        corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 9)
        corner.Parent = frame

        stroke = Instance.new("UIStroke")
        stroke.Color = Color3.fromRGB(90, 90, 100)
        stroke.Thickness = 1.4
        stroke.Transparency = 0.2
        stroke.Parent = frame

        lbl = Instance.new("TextLabel")
        lbl.Name = "Timer"
        lbl.Size = UDim2.fromScale(1, 1)
        lbl.BackgroundTransparency = 1
        lbl.Text = "2.5"
        lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
        lbl.Font = Enum.Font.GothamBlack
        lbl.TextSize = 22
        lbl.TextStrokeTransparency = 0.35
        lbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        lbl.ZIndex = 501
        lbl.Parent = frame

        targetPos = UDim2.new(1, -14, 1, ragY)
        TweenService:Create(
            frame,
            TweenInfo.new(0.35, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
            { Position = targetPos }
        ):Play()

        startClock = os.clock()
        finished = false
        local conn
        conn = RunService.RenderStepped:Connect(function()
            if finished or not (frame and frame.Parent) then
                if conn then pcall(function() conn:Disconnect() end) end
                return
            end
            timeLeft = math.max(0, 2.5 - (os.clock() - startClock))
            if lbl and lbl.Parent then
                lbl.Text = string.format("%.1f", timeLeft)
            end
            if timeLeft <= 0 and not finished then
                finished = true
                if conn then pcall(function() conn:Disconnect() end) end
                exitTween = TweenService:Create(
                    frame,
                    TweenInfo.new(1.15, Enum.EasingStyle.Quint, Enum.EasingDirection.In),
                    { Position = UDim2.new(1, 180, 1, ragY) }
                )
                exitTween:Play()
                exitTween.Completed:Connect(function()
                    pcall(function() if gui then gui:Destroy() end end)
                    _ragCdActive = false
                end)
            end
        end)
    end

    _G.__KyzDuelsShowRagdollCountdown = showRagdollCountdownUI


    -- ============================================================
    -- SYNCHRONIZE AFTER HIT (from Ambitious)
    -- On rising edge of Physics/Ragdoll while auto-steal is on:
    --   1) stop steal loop immediately + reset bar
    --   2) wait 1.45s
    --   3) restart auto-steal if still enabled
    -- Generation token cancels older scheduled restarts.
    -- ============================================================
    _G._KyzSyncAfterHit = _G._KyzSyncAfterHit or {
        enabled = false,
        conn = nil,
        gen = 0,
        wasRagdoll = false,
    }

    function _doSyncAfterHit()
        pcall(function()
            if type(stopAutoSteal) == "function" then stopAutoSteal() end
        end)
        pcall(function()
            if type(stopV3AutoSteal) == "function" then stopV3AutoSteal() end
        end)
        pcall(function()
            if _G.StealBar and _G.StealBar.Reset then _G.StealBar.Reset() end
        end)
        pcall(function()
            if type(resetStealBarToZero) == "function" then resetStealBarToZero() end
        end)

        local myGen = _G._KyzSyncAfterHit.gen
        local syncDelay = 1.45
        task.delay(syncDelay, function()
            if myGen ~= _G._KyzSyncAfterHit.gen then return end
            _G._KyzSyncAfterHit.wasRagdoll = false
            if State and State.syncStealRagdoll and State.autoStealEnabled then
                pcall(function()
                    if type(restartAutoStealForMode) == "function" then
                        restartAutoStealForMode()
                    end
                end)
            end
        end)
    end

    function _startSyncAfterHitWatcher()
        local S = _G._KyzSyncAfterHit
        if S.conn then
            pcall(function() S.conn:Disconnect() end)
            S.conn = nil
        end
        S.wasRagdoll = false
        S.conn = RunService.Heartbeat:Connect(function()
            if not State or not State.syncStealRagdoll then return end
            if not State.autoStealEnabled then return end
            local char = LP.Character
            if not char then return end
            local hum = char:FindFirstChildOfClass("Humanoid")
            if not hum or hum.Health <= 0 then return end
            local st = hum:GetState()
            -- Solo Physics e Ragdoll; FallingDown escluso intenzionalmente (Ambitious)
            local isRagdolled = (st == Enum.HumanoidStateType.Physics
                or st == Enum.HumanoidStateType.Ragdoll)
            if isRagdolled and not S.wasRagdoll then
                S.wasRagdoll = true
                S.gen = (S.gen or 0) + 1
                _doSyncAfterHit()
            elseif not isRagdolled then
                S.wasRagdoll = false
            end
        end)
    end

    function _stopSyncAfterHitWatcher()
        local S = _G._KyzSyncAfterHit
        if S.conn then
            pcall(function() S.conn:Disconnect() end)
            S.conn = nil
        end
        S.wasRagdoll = false
    end

    -- Old gate becomes no-op: Ambitious style stops+restarts instead of blocking
    function isStealBlockedByRagdoll()
        return false
    end

    function waitStealRagdollGate()
        return false
    end

    _startSyncAfterHitWatcher()

    function noteStealRagdollHit()
        -- kept for ragdoll countdown compatibility; sync is handled by Sync After Hit
    end

    function resetStealBarToZero()
        pcall(function()
            if progressFill then
                progressFill.Size = UDim2.new(0, 0, 1, 0)
                if FILL_LIGHT then progressFill.BackgroundColor3 = FILL_LIGHT end
            end
            if progressPct then
                progressPct.Text = "0%"
            end
            if resetProgressVisuals then resetProgressVisuals() end
        end)
    end

    function handleRagdollCountdown(char)
        _ragCdReadyAt = math.max(_ragCdReadyAt, os.clock() + 2.0)
        task.delay(2.0, function()
        end)
    end

    function isMyPlot(plotName)
        local plotsFolder = workspace:FindFirstChild("Plots")
        if not plotsFolder or typeof(plotsFolder) ~= "Instance" then return false end
        local plot = plotsFolder:FindFirstChild(tostring(plotName or ""))
        if not plot or typeof(plot) ~= "Instance" then return false end
        local sign = plot:FindFirstChild("PlotSign")
        if sign and typeof(sign) == "Instance" then
            local yourBase = sign:FindFirstChild("YourBase")
            if yourBase and typeof(yourBase) == "Instance" and yourBase:IsA("BillboardGui") then
                return yourBase.Enabled == true
            end
        end
        return false
    end

    function findNearestStealPrompt()
        local character = LP.Character
        if not character then return nil, nil end
        local root = character:FindFirstChild("HumanoidRootPart")
        if not root then return nil, nil end
        
        local plotsFolder = workspace:FindFirstChild("Plots")
        if not plotsFolder or typeof(plotsFolder) ~= "Instance" then return nil, nil end
        
        local nearestPrompt = nil
        local nearestDistance = math.huge
        local nearestPodName = nil
        
        for _, plot in ipairs(plotsFolder:GetChildren()) do
            if typeof(plot) == "Instance" and not isMyPlot(plot.Name) then
                local pods = plot:FindFirstChild("AnimalPodiums")
                if pods and typeof(pods) == "Instance" then
                    for _, pod in ipairs(pods:GetChildren()) do
                        if typeof(pod) == "Instance" then
                            pcall(function()
                                local base = pod:FindFirstChild("Base")
                                local spawnPart = base and base:FindFirstChild("Spawn")
                                if spawnPart and typeof(spawnPart) == "Instance" then
                                    local distance = (spawnPart.Position - root.Position).Magnitude
                                    if distance < nearestDistance and distance <= (Steal.StealRadius or 60) then
                                        local attachment = spawnPart:FindFirstChild("PromptAttachment")
                                        if attachment and typeof(attachment) == "Instance" then
                                            for _, child in ipairs(attachment:GetChildren()) do
                                                if child:IsA("ProximityPrompt") and child.ActionText and tostring(child.ActionText):find("Steal") then
                                                    nearestPrompt = child
                                                    nearestDistance = distance
                                                    nearestPodName = pod.Name
                                                    break
                                                end
                                            end
                                        end
                                    end
                                end
                            end)
                        end
                    end
                end
            end
        end

        return nearestPrompt, nearestPodName
    end

    function resetProgressVisuals()
        if progressPct then
            progressPct.Text = "0%"
        end
        if progressFill then
            progressFill.Size = UDim2.new(0, 0, 1, 0)
            progressFill.BackgroundColor3 = FILL_LIGHT
        end
    end
    resetProgressBar = resetProgressVisuals

    Steal.updateProgress = function(elapsed, duration)
        if progressFill then
            progress = math.clamp(elapsed / duration, 0, 1)
            progressFill.Size = UDim2.new(progress, 0, 1, 0)
            progressFill.BackgroundColor3 = FILL_LIGHT:Lerp(FILL_DARK, progress)
        end
        if progressPct then
            progressPct.Text = string.format("%d%%", math.floor(math.clamp(elapsed / duration, 0, 1) * 100))
        end
    end

    Steal.checkCancelled = function(prompt)
        char = LP.Character
        hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not prompt.Parent or not prompt.Parent.Parent then return true end
        if hrp and (hrp.Position - prompt.Parent.Parent.Position).Magnitude > Steal.StealRadius then return true end
        return false
    end

    Steal.runPhase1 = function(data, prompt, duration, startTime)
        while isCurrentlyStealing do
            if isStealBlockedByRagdoll and isStealBlockedByRagdoll() then
                return "ragdoll"
            end
            elapsed = tick() - startTime
            if elapsed >= autoGrabStopTime then break end
            Steal.updateProgress(elapsed, duration)
            if Steal.checkCancelled(prompt) then break end
            task.wait()
        end
        return math.clamp(autoGrabStopTime / duration, 0, 1)
    end

    Steal.runPhase2 = function(data, prompt, stopProgress, duration, startTime)
        phase2Timeout = math.max(2.99 - autoGrabStopTime - math.max(duration - autoGrabStopTime, 0), 0.05)
        phase2Start = tick()
        
        while isCurrentlyStealing do
            if isStealBlockedByRagdoll and isStealBlockedByRagdoll() then
                return "ragdoll"
            end
            if tick() - phase2Start >= phase2Timeout then
                return "restart"
            end
            
            if Steal.checkCancelled(prompt) then
                return "cancel"
            end
            
            char = LP.Character
            hrp = char and char:FindFirstChild("HumanoidRootPart")
            if hrp then
                dist = (hrp.Position - prompt.Parent.Parent.Position).Magnitude
                if dist <= autoGrabDelayRadius then
                    if progressPct then
                        progressPct.Text = string.format("%d%%", math.floor(stopProgress * 100))
                    end
                    break
                elseif dist > Steal.StealRadius then
                    return "cancel"
                end
            end
            task.wait()
        end
        return "continue"
    end

    Steal.finish = function(data, stopProgress, duration)
        fillStart = tick()
        fillDuration = math.max(duration - autoGrabStopTime, 0.05)
        while true do
            fp = math.clamp((tick() - fillStart) / fillDuration, 0, 1)
            totalProgress = stopProgress + fp * (1 - stopProgress)
            if progressFill then
                progressFill.Size = UDim2.new(totalProgress, 0, 1, 0)
                progressFill.BackgroundColor3 = FILL_LIGHT:Lerp(FILL_DARK, totalProgress)
            end
            if progressPct then
                progressPct.Text = string.format("%d%%", math.floor(totalProgress * 100))
            end
            if fp >= 1 then break end
            task.wait()
        end
        local triggers = (data and data.TriggerConnections) or {}
        if type(triggers) == "table" then
            for _, func in ipairs(triggers) do
                if type(func) == "function" then task.spawn(func) end
            end
        end
        if data and data.useFallback and data.prompt then
            pcall(function()
                if type(fireproximityprompt) == "function" then fireproximityprompt(data.prompt) end
            end)
        end
        State.stealsCount = (State.stealsCount or 0) + 1
    end

    Steal.runNormal = function(data, prompt, duration, startTime)
        while isCurrentlyStealing do
            if isStealBlockedByRagdoll and isStealBlockedByRagdoll() then
                return "ragdoll"
            end
            elapsed = tick() - startTime
            progress = math.clamp(elapsed / duration, 0, 1)
            
            if progressFill then
                progressFill.Size = UDim2.new(progress, 0, 1, 0)
                progressFill.BackgroundColor3 = FILL_LIGHT:Lerp(FILL_DARK, progress)
            end
            if progressPct then
                progressPct.Text = string.format("%d%%", math.floor(progress * 100))
            end
            
            if Steal.checkCancelled(prompt) then break end
            
            if elapsed >= duration then
                local triggers = (data and data.TriggerConnections) or {}
                if type(triggers) == "table" then
                    for _, func in ipairs(triggers) do
                        if type(func) == "function" then task.spawn(func) end
                    end
                end
                if data and data.useFallback then
                    pcall(function()
                        if type(fireproximityprompt) == "function" then fireproximityprompt(prompt) end
                    end)
                end
                State.stealsCount = (State.stealsCount or 0) + 1
                b