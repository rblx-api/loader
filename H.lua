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
                break
            end
            task.wait()
        end
    end

    Steal.resetAfter = function(data)
        if barResetTween and progressFill then
            barResetTween = TweenService:Create(progressFill, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {
                Size = UDim2.new(0, 0, 1, 0),
                BackgroundColor3 = FILL_LIGHT
            })
            barResetTween:Play()
        elseif progressFill then
            progressFill.Size = UDim2.new(0, 0, 1, 0)
            progressFill.BackgroundColor3 = FILL_LIGHT
        end
        resetProgressVisuals()
        data.Ready = true
        isCurrentlyStealing = false
        State.isStealing = false
    end

    local function stealSafeConnFns(signal)
        local out = {}
        if not signal or type(getconnections) ~= "function" then return out end
        local ok, cons = pcall(getconnections, signal)
        if not ok or type(cons) ~= "table" then return out end
        for _, conn in ipairs(cons) do
            if conn and type(conn.Function) == "function" then
                table.insert(out, conn.Function)
            end
        end
        return out
    end

    local function stealFirePromptFallback(prompt)
        if not prompt then return end
        pcall(function()
            if type(fireproximityprompt) == "function" then
                fireproximityprompt(prompt)
                return
            end
        end)
        pcall(function() prompt:InputHoldBegin() end)
        task.delay(0.08, function()
            pcall(function() prompt:InputHoldEnd() end)
        end)
    end

    function executeSteal(prompt, podName)
        if isCurrentlyStealing then return end
        if isStealBlockedByRagdoll and isStealBlockedByRagdoll() then return end
        
        if not Steal.Data[prompt] then
            local hold = stealSafeConnFns(prompt.PromptButtonHoldBegan)
            local trigger = stealSafeConnFns(prompt.Triggered)
            Steal.Data[prompt] = {
                HoldConnections = hold,
                TriggerConnections = trigger,
                Ready = true,
                prompt = prompt,
                useFallback = (#hold == 0 and #trigger == 0),
            }
        end
        
        data = Steal.Data[prompt]
        if not data then return end
        data.HoldConnections = data.HoldConnections or {}
        data.TriggerConnections = data.TriggerConnections or {}
        if not data.Ready then return end
        
        data.Ready = false
        isCurrentlyStealing = true
        State.isStealing = true
        
        if barResetTween then
            barResetTween:Cancel()
            barResetTween = nil
        end
        resetProgressVisuals()
        if progressFill then
            progressFill.BackgroundColor3 = FILL_LIGHT
        end
        
        task.spawn(function()
            function fullRestartAfterRagdoll()
                if waitStealRagdollGate then waitStealRagdollGate() end
                resetStealBarToZero()
                data.Ready = true
                isCurrentlyStealing = false
                State.isStealing = false
                task.wait()
                if State and State.autoStealEnabled and prompt and prompt.Parent then
                    executeSteal(prompt, podName)
                end
            end

            if isStealBlockedByRagdoll and isStealBlockedByRagdoll() then
                fullRestartAfterRagdoll()
                return
            end

            local holds = data.HoldConnections or {}
            if type(holds) == "table" then
                for _, func in ipairs(holds) do
                    if type(func) == "function" then task.spawn(func) end
                end
            end
            if data.useFallback then
                pcall(stealFirePromptFallback, prompt)
            end
            
            startTime = tick()
            duration = Steal.StealDuration
            
            if autoGrabStopEnabled then
                stopProgress = Steal.runPhase1(data, prompt, duration, startTime)
                if stopProgress == "ragdoll" then
                    fullRestartAfterRagdoll()
                    return
                end
                if progressFill then
                    progressFill.Size = UDim2.new(stopProgress, 0, 1, 0)
                end
                if progressPct then
                    progressPct.Text = "Ready"
                end
                
                phase2Result = Steal.runPhase2(data, prompt, stopProgress, duration, startTime)
                if phase2Result == "ragdoll" then
                    fullRestartAfterRagdoll()
                    return
                elseif phase2Result == "restart" then
                    resetProgressVisuals()
                    data.Ready = true
                    isCurrentlyStealing = false
                    State.isStealing = false
                    task.wait()
                    executeSteal(prompt, podName)
                    return
                elseif phase2Result == "cancel" then
                    Steal.resetAfter(data)
                    return
                end
                
                if isCurrentlyStealing then
                    Steal.finish(data, stopProgress, duration)
                end
            else
                normalResult = Steal.runNormal(data, prompt, duration, startTime)
                if normalResult == "ragdoll" then
                    fullRestartAfterRagdoll()
                    return
                end
            end
            
            Steal.resetAfter(data)
        end)
    end

    startAutoSteal = function()
        if autoStealConnection then return end
        applyAutoStealModeConfig()
        autoStealConnection = RunService.Heartbeat:Connect(function()
            if not State or not State.autoStealEnabled then return end
            if State.autoStealMode == "V3" then return end
            if isCurrentlyStealing then return end
            if isStealBlockedByRagdoll and isStealBlockedByRagdoll() then return end
            local prompt, podName = findNearestStealPrompt()
            if prompt then
                executeSteal(prompt, podName)
            end
        end)
    end

    stopAutoSteal = function()
        if autoStealConnection then
            autoStealConnection:Disconnect()
            autoStealConnection = nil
        end
        task.spawn(function()
            waitStart = tick()
            while isCurrentlyStealing and (tick() - waitStart) < 5 do
                task.wait(0.05)
            end
            State.isStealing = false
            if progressFill then
                TweenService:Create(progressFill, TweenInfo.new(0.2), {
                    Size = UDim2.new(0, 0, 1, 0),
                    BackgroundColor3 = FILL_LIGHT
                }):Play()
            end
            resetProgressVisuals()
        end)
    end

    stretchRezConn = nil
    STRETCH_NAME = "KyzDuels_Stretch"

    function applyAutoStealModeConfig()
        mode = (State and State.autoStealMode) or "V1"
        State.stealRadiusNormal = 60
        if mode == "V1" then
            autoGrabStopEnabled = false
            Steal.StealDuration = 1.3
            Steal.StealRadius = 60
        elseif mode == "V2" then
            autoGrabStopEnabled = true
            autoGrabStopTime = 1
            autoGrabDelayRadius = 8
            Steal.StealDuration = 1.3
            Steal.StealRadius = 60
        elseif mode == "V3" then
            autoGrabStopEnabled = false
            Steal.StealDuration = 1.3
            Steal.StealRadius = 8
        end
        syncStealAliases()
        pcall(function()
            if UI and UI.stealRadiusBox then
                UI.stealRadiusBox.Text = tostring(Steal.StealRadius)
            end
        end)
        pcall(updateStealRadiusRowLock)
    end

    V3 = {
        enabled = false,
        conn = nil,
        active = false,
        holdMin = 1.3,
        holdMax = 2.6,
        entryDelay = 0.3,
        cooldown = 0.05,
        primeRange = 80,
        radius = 8,
        cache = {},
    }

    function v3SetBar(p)
        p = math.clamp(tonumber(p) or 0, 0, 1)
        if progressFill then
            progressFill.Size = UDim2.new(p, 0, 1, 0)
            progressFill.BackgroundColor3 = FILL_LIGHT:Lerp(FILL_DARK, p)
        end
        if progressPct then
            progressPct.Text = string.format("%d%%", math.floor(p * 100 + 0.5))
        end
    end

    function v3ResetBar()
        if progressFill then
            progressFill.Size = UDim2.new(0, 0, 1, 0)
            progressFill.BackgroundColor3 = FILL_LIGHT
        end
        if progressPct then
            progressPct.Text = "0%"
        end
    end

    function v3FindNearestPrompt()
        local char = LP.Character
        local root = char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("UpperTorso"))
        if not root then return nil end
        local plotsFolder = workspace:FindFirstChild("Plots")
        if not plotsFolder or typeof(plotsFolder) ~= "Instance" then return nil end
        local best, bestDist = nil, math.huge
        for _, plot in ipairs(plotsFolder:GetChildren()) do
            if typeof(plot) ~= "Instance" then continue end
            local sign = plot:FindFirstChild("PlotSign")
            local yourBase = sign and sign:FindFirstChild("YourBase")
            local isMine = yourBase and typeof(yourBase) == "Instance" and yourBase:IsA("BillboardGui") and yourBase.Enabled == true
            if not isMine then
                local pods = plot:FindFirstChild("AnimalPodiums")
                if pods and typeof(pods) == "Instance" then
                    for _, pod in ipairs(pods:GetChildren()) do
                        if typeof(pod) ~= "Instance" then continue end
                        local base = pod:FindFirstChild("Base")
                        local spawn = base and base:FindFirstChild("Spawn")
                        if spawn and typeof(spawn) == "Instance" then
                            local d = (spawn.Position - root.Position).Magnitude
                            if d < bestDist and d <= (V3.primeRange or 60) then
                                local att = spawn:FindFirstChild("PromptAttachment")
                                if att and typeof(att) == "Instance" then
                                    for _, ch in ipairs(att:GetChildren()) do
                                        if ch:IsA("ProximityPrompt") then
                                            local at = tostring(ch.ActionText or "")
                                            if at:find("Steal") or at:find("steal") then
                                                best, bestDist = ch, d
                                                break
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
        return best
    end

    function v3BuildCallbacks(prompt)
        if V3.cache[prompt] then return V3.cache[prompt] end
        local hold = stealSafeConnFns(prompt.PromptButtonHoldBegan)
        local trigger = stealSafeConnFns(prompt.Triggered)
        data = {
            hold = hold,
            trigger = trigger,
            ready = true,
            useFallback = (#hold == 0 and #trigger == 0),
            prompt = prompt,
        }
        V3.cache[prompt] = data
        return data
    end

    function v3Execute(prompt)
        if not prompt or not prompt.Parent or V3.active then return end
        if isStealBlockedByRagdoll and isStealBlockedByRagdoll() then return end
        data = v3BuildCallbacks(prompt)
        if not data or not data.ready then return end
        data.hold = data.hold or {}
        data.trigger = data.trigger or {}
        data.ready = false
        V3.active = true
        v3ResetBar()
        task.spawn(function()
            function v3RagdollRestart()
                if waitStealRagdollGate then waitStealRagdollGate() end
                resetStealBarToZero()
                data.ready = true
                V3.active = false
                task.wait()
                if V3.enabled and State.autoStealEnabled and State.autoStealMode == "V3" and prompt and prompt.Parent then
                    v3Execute(prompt)
                end
            end

            if isStealBlockedByRagdoll and isStealBlockedByRagdoll() then
                v3RagdollRestart()
                return
            end

            startTime = tick()
            radius = 8
            for _, fn in ipairs(data.hold or {}) do
                if type(fn) == "function" then task.spawn(function() pcall(fn) end) end
            end
            if data.useFallback then
                pcall(stealFirePromptFallback, prompt)
            end

            while V3.enabled and State.autoStealMode == "V3" and State.autoStealEnabled and (tick() - startTime) < V3.holdMin do
                if isStealBlockedByRagdoll and isStealBlockedByRagdoll() then
                    v3RagdollRestart()
                    return
                end
                elapsed = tick() - startTime
                v3SetBar(elapsed / V3.holdMax)
                task.wait()
            end

            spawnPart = prompt.Parent and prompt.Parent.Parent
            alreadyInRange = false
            pcall(function()
                char = LP.Character
                root = char and char:FindFirstChild("HumanoidRootPart")
                if root and spawnPart and spawnPart:IsA("BasePart") then
                    alreadyInRange = (root.Position - spawnPart.Position).Magnitude <= radius
                end
            end)

            fired = false
            while V3.enabled and State.autoStealMode == "V3" and State.autoStealEnabled and prompt.Parent do
                elapsed = tick() - startTime
                if elapsed > V3.holdMax then break end
                v3SetBar(elapsed / V3.holdMax)

                char = LP.Character
                root = char and char:FindFirstChild("HumanoidRootPart")
                spawn = prompt.Parent and prompt.Parent.Parent
                if root and spawn and spawn:IsA("BasePart") then
                    dist = (root.Position - spawn.Position).Magnitude
                    if dist <= radius then
                        if not alreadyInRange then
                            task.wait(V3.entryDelay)
                        end
                        if V3.enabled and State.autoStealMode == "V3" and State.autoStealEnabled then
                            for _, fn in ipairs(data.trigger or {}) do
                                if type(fn) == "function" then
                                    task.spawn(function() pcall(fn) end)
                                end
                            end
                            if data.useFallback then
                                pcall(stealFirePromptFallback, prompt)
                            end
                            fired = true
                            v3SetBar(1)
                        end
                        break
                    end
                else
                    break
                end
                task.wait()
            end

            if fired then
                v3SetBar(1)
                task.wait(0.12)
            end
            task.wait(V3.cooldown)
            data.ready = true
            V3.active = false
            v3ResetBar()
        end)
    end

    function startV3AutoSteal()
        V3.enabled = true
        V3.radius = 8
        Steal.StealRadius = 8
        if V3.conn then pcall(function() V3.conn:Disconnect() end); V3.conn = nil end
        V3.conn = RunService.Heartbeat:Connect(function()
            if not State or not State.autoStealEnabled or State.autoStealMode ~= "V3" then return end
            if V3.active then return end
            if isStealBlockedByRagdoll and isStealBlockedByRagdoll() then return end
            prompt = v3FindNearestPrompt()
            if prompt then v3Execute(prompt) end
        end)
    end

    function stopV3AutoSteal()
        V3.enabled = false
        V3.active = false
        if V3.conn then pcall(function() V3.conn:Disconnect() end); V3.conn = nil end
        v3ResetBar()
    end

    function restartAutoStealForMode()
        pcall(stopAutoSteal)
        pcall(stopV3AutoSteal)
        applyAutoStealModeConfig()
        if not State or not State.autoStealEnabled then return end
        if State.autoStealMode == "V3" then
            startV3AutoSteal()
        else
            startAutoSteal()
        end
    end

    function updateStealRadiusRowLock()
        pcall(function()
            if not UI then return end
            box = UI.stealRadiusBox
            if not box then return end
            locked = (State.autoStealMode == "V3")
            box.TextEditable = not locked
            box.Text = tostring(Steal.StealRadius or (locked and 8 or 20))
            if locked then
                box.TextColor3 = Color3.fromRGB(140, 140, 145)
            else
                box.TextColor3 = C.white
            end
        end)
    end

    function enableStretchRez()
        State.stretchRezEnabled = true
        pcall(function() RunService:UnbindFromRenderStep(STRETCH_NAME) end)
        pcall(function()
            RunService:BindToRenderStep(STRETCH_NAME, Enum.RenderPriority.Last.Value - 1, function()
                cam = workspace.CurrentCamera
                if cam then
                    cam.CFrame = cam.CFrame * CFrame.new(0, 0, 0, 1, 0, 0, 0, 0.8, 0, 0, 0, 1)
                end
            end)
        end)
    end

    function disableStretchRez()
        State.stretchRezEnabled = false
        pcall(function() RunService:UnbindFromRenderStep(STRETCH_NAME) end)
    end

    FOV_NAME = "KyzDuels_FOV"
    FOV_VALUE = 120
    FOV_DEFAULT = 70
    fovCamConn = nil
    fovPropConn = nil
    fovHeartbeat = nil

    function _clearFovHooks()
        pcall(function() RunService:UnbindFromRenderStep(FOV_NAME) end)
        if fovCamConn then
            pcall(function() fovCamConn:Disconnect() end)
            fovCamConn = nil
        end
        if fovPropConn then
            pcall(function() fovPropConn:Disconnect() end)
            fovPropConn = nil
        end
        if fovHeartbeat then
            pcall(function() fovHeartbeat:Disconnect() end)
            fovHeartbeat = nil
        end
    end

    function forceFov()
        if not State.fovEnabled then return end
        cam = workspace.CurrentCamera
        if cam and math.abs((cam.FieldOfView or 0) - FOV_VALUE) > 0.05 then
            cam.FieldOfView = FOV_VALUE
        end
    end

    function bindFovProp(cam)
        if fovPropConn then
            pcall(function() fovPropConn:Disconnect() end)
            fovPropConn = nil
        end
        if not cam then return end
        fovPropConn = cam:GetPropertyChangedSignal("FieldOfView"):Connect(function()
            if not State.fovEnabled then return end
            if math.abs((cam.FieldOfView or 0) - FOV_VALUE) > 0.05 then
                cam.FieldOfView = FOV_VALUE
            end
        end)
    end

    function stopFov()
        State.fovEnabled = false
        _clearFovHooks()
        pcall(function()
            cam = workspace.CurrentCamera
            if cam then
                cam.FieldOfView = FOV_DEFAULT
            end
        end)
    end

    function startFov()
        State.fovEnabled = true
        _clearFovHooks()

        pcall(function()
            RunService:BindToRenderStep(FOV_NAME, Enum.RenderPriority.Last.Value, forceFov)
        end)

        fovHeartbeat = RunService.Heartbeat:Connect(forceFov)

        fovCamConn = workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
            if not State.fovEnabled then return end
            cam = workspace.CurrentCamera
            bindFovProp(cam)
            task.defer(forceFov)
            task.delay(0.05, forceFov)
            task.delay(0.2, forceFov)
        end)

        bindFovProp(workspace.CurrentCamera)
        forceFov()
    end

    antiLagDescConn = nil
    antiLagActive = false
    local antiLagDefBrightness, antiLagDefFog, antiLagDefDiffuse, antiLagDefSpecular

    function _applyAntiLagObj(obj)
        pcall(function()
            if obj:IsA("Fire") and (obj.Name == "Custom_HeadFire" or (LP.Character and obj:IsDescendantOf(LP.Character))) then
                return
            end
            if obj:IsA("BasePart") then
                obj.Material = Enum.Material.Plastic; obj.Reflectance = 0; obj.CastShadow = false
            elseif obj:IsA("Decal") or obj:IsA("Texture") then
                obj.Transparency = 1
            elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam")
            or obj:IsA("Fire") or obj:IsA("Smoke") or obj:IsA("Sparkles") then
                obj.Enabled = false
            elseif obj:IsA("AnimationController") or obj:IsA("Animator") then
                for _,t in ipairs(obj:GetPlayingAnimationTracks()) do pcall(function() t:Stop(0) end) end
            end
        end)
    end

    local function _isProtectedLightingFx(e)
        if not e then return false end
        if e:GetAttribute("_KyzShiny") then return true end
        if e:GetAttribute("_AmbitiousVivid") then return true end
        if e:GetAttribute("_V4MPSky") then return true end
        return false
    end

    function enableAntiLag()
        antiLagActive = true
        antiLagDefBrightness = antiLagDefBrightness or Lighting.Brightness
        antiLagDefFog        = antiLagDefFog        or Lighting.FogEnd
        antiLagDefDiffuse    = antiLagDefDiffuse    or Lighting.EnvironmentDiffuseScale
        antiLagDefSpecular   = antiLagDefSpecular   or Lighting.EnvironmentSpecularScale
        Lighting.GlobalShadows = false
        Lighting.FogEnd = 1e10
        Lighting.EnvironmentDiffuseScale = 0
        Lighting.EnvironmentSpecularScale = 0
        for _,e in pairs(Lighting:GetChildren()) do
            pcall(function()
                if _isProtectedLightingFx(e) then
                    -- keep Shiny / Night / Vivid alive
                    if e:IsA("BlurEffect") or e:IsA("SunRaysEffect") or e:IsA("ColorCorrectionEffect")
                    or e:IsA("BloomEffect") or e:IsA("DepthOfFieldEffect") then
                        e.Enabled = true
                    end
                    return
                end
                if e:IsA("BlurEffect") or e:IsA("SunRaysEffect") or e:IsA("ColorCorrectionEffect")
                or e:IsA("BloomEffect") or e:IsA("DepthOfFieldEffect") then e.Enabled = false end
            end)
        end
        -- if Shiny is on, force re-enable (Anti Lag used to kill it)
        if State and State.shinyGraphicsEnabled then
            task.defer(function()
                pcall(function()
                    if type(enableShinyGraphics) == "function" then enableShinyGraphics() end
                end)
            end)
        end
        for _,obj in ipairs(workspace:GetDescendants()) do _applyAntiLagObj(obj) end
        if antiLagDescConn then antiLagDescConn:Disconnect() end
        antiLagDescConn = workspace.DescendantAdded:Connect(function(obj)
            if antiLagActive then _applyAntiLagObj(obj) end
        end)
        if State.skinFireHead and LP.Character then
            pcall(function()
                head = LP.Character:FindFirstChild("Head")
                f = head and head:FindFirstChild("Custom_HeadFire")
                if f and f:IsA("Fire") then
                    f.Enabled = true
                elseif head then
                    applyFireHead(LP.Character)
                end
            end)
        end
    end

    function disableAntiLag()
        antiLagActive = false
        if antiLagDescConn then antiLagDescConn:Disconnect(); antiLagDescConn = nil end
        pcall(function()
            Lighting.GlobalShadows = true
            if antiLagDefBrightness then Lighting.Brightness = antiLagDefBrightness end
            if antiLagDefFog        then Lighting.FogEnd = antiLagDefFog end
            if antiLagDefDiffuse    then Lighting.EnvironmentDiffuseScale = antiLagDefDiffuse end
            if antiLagDefSpecular   then Lighting.EnvironmentSpecularScale = antiLagDefSpecular end
            for _,e in pairs(Lighting:GetChildren()) do
                pcall(function()
                    if e:IsA("BlurEffect") or e:IsA("SunRaysEffect") or e:IsA("ColorCorrectionEffect")
                    or e:IsA("BloomEffect") or e:IsA("DepthOfFieldEffect") then
                        e.Enabled = true
                    end
                end)
            end
            if State and State.shinyGraphicsEnabled and type(enableShinyGraphics) == "function" then
                pcall(enableShinyGraphics)
            end
        end)
    end

    BRAINROT_LOCAL_TRANS = 0.40
    MAP_LOCAL_TRANS = 0.88
    MAX_PARTS_TM = 5000
    _tm = {
        entries = {},
        conn = nil,
        redConnections = {},
        savedTransparency = setmetatable({}, { __mode = "k" }),
        savedEnabled = setmetatable({}, { __mode = "k" }),
        savedVisible = setmetatable({}, { __mode = "k" }),
        animals = nil,
        promptGui = nil,
    }

    function _tmRemember(inst, prop, old)
        table.insert(_tm.entries, { inst = inst, prop = prop, old = old })
    end

    function _tmIsCharacterPart(obj)
        m = obj
        for _ = 1, 10 do
            if not m then break end
            if m:IsA("Model") and Players:GetPlayerFromCharacter(m) then return true end
            m = m.Parent
        end
        return false
    end

    function _tmIsProtected(obj)
        n = string.lower(tostring(obj.Name or ""))
        if n:find("anti", 1, true) or n:find("cheat", 1, true) or n:find("hitbox", 1, true)
            or n:find("kill", 1, true) or n:find("barrier", 1, true) or n:find("boundary", 1, true)
            or n:find("zone", 1, true) or n:find("spawn", 1, true) or n:find("remote", 1, true)
            or n:find("ac_", 1, true) or n:find("security", 1, true) or n:find("server", 1, true) then
            return true
        end
        p = obj.Parent
        for _ = 1, 8 do
            if not p or p == workspace then break end
            pn = string.lower(tostring(p.Name or ""))
            if pn:find("anti", 1, true) or pn:find("cheat", 1, true) or pn:find("security", 1, true) then
                return true
            end
            p = p.Parent
        end
        return false
    end

    function _tmIsPlotOrBase(obj)
        p = obj
        for _ = 1, 14 do
            if not p then break end
            if p.Parent and p.Parent.Name == "Plots" then return true end
            if p.Name == "Plots" then return true end
            if p:IsA("Model") or p:IsA("Folder") then
                n = string.lower(tostring(p.Name or ""))
                if n:find("plot", 1, true) or n == "base" or n:find("yard", 1, true)
                    or n:find("baseplate", 1, true) or n:find("mybase", 1, true) then
                    return true
                end
            end
            p = p.Parent
        end
        return false
    end

    function _tmIsBrainrot(obj)
        n = string.lower(tostring(obj.Name or ""))
        if n:find("brainrot", 1, true) or n:find("animal", 1, true) then return true end
        if obj:GetAttribute("Brainrot") or obj:GetAttribute("IsAnimal") or obj:GetAttribute("Animal") then return true end
        p = obj.Parent
        for _ = 1, 8 do
            if not p or p == workspace then break end
            pn = string.lower(tostring(p.Name or ""))
            if pn:find("brainrot", 1, true) or pn:find("animalpodium", 1, true) or pn:find("animals", 1, true) then
                return true
            end
            if p:GetAttribute("Brainrot") then return true end
            p = p.Parent
        end
        return false
    end

    function _tmSetLocalTrans(inst, target)
        if not inst or not inst.Parent then return end
        if not inst:IsA("BasePart") then return end
        if _tmIsCharacterPart(inst) or _tmIsProtected(inst) or _tmIsPlotOrBase(inst) then return end
        pcall(function()
            old = inst.LocalTransparencyModifier
            if type(old) ~= "number" then old = 0 end
            if old >= target then return end
            _tmRemember(inst, "LocalTransparencyModifier", old)
            inst.LocalTransparencyModifier = target
        end)
    end

    function _tmForceHide(inst)
        if not inst or not inst.Parent then return end
        pcall(function()
            if inst:IsA("BasePart") then
                old = inst.LocalTransparencyModifier
                if type(old) ~= "number" then old = 0 end
                _tmRemember(inst, "LocalTransparencyModifier", old)
                inst.LocalTransparencyModifier = 1
            elseif inst:IsA("Model") or inst:IsA("Folder") then
                for _, d in ipairs(inst:GetDescendants()) do
                    if d:IsA("BasePart") then
                        old = d.LocalTransparencyModifier
                        if type(old) ~= "number" then old = 0 end
                        _tmRemember(d, "LocalTransparencyModifier", old)
                        d.LocalTransparencyModifier = 1
                    end
                end
            end
        end)
    end

    function _tmScanApply()
        _tm.entries = {}
        budget = 0
        map = workspace:FindFirstChild("Map")
        if map then
            left = map:FindFirstChild("Ground_Left")
            right = map:FindFirstChild("Ground_Right")
            if left then _tmForceHide(left) end
            if right then _tmForceHide(right) end
        end
        pcall(function()
            for _, d in ipairs(workspace:GetDescendants()) do
                if budget >= MAX_PARTS_TM then break end
                if d:IsA("BasePart") and _tmIsBrainrot(d)
                    and not _tmIsCharacterPart(d)
                    and not _tmIsProtected(d)
                    and not _tmIsPlotOrBase(d) then
                    _tmSetLocalTrans(d, BRAINROT_LOCAL_TRANS)
                    budget = budget + 1
                end
            end
        end)
        mapRoots = {}
        for _, name in ipairs({
            "Map", "Arena", "Duels", "Lobby", "Island", "Islands", "World",
            "MapFolder", "Environment", "Props", "Buildings", "Decor", "Trees",
            "Terrain", "Obstacles", "Walls", "Floors", "Ground", "Platforms"
        }) do
            f = workspace:FindFirstChild(name)
            if f then table.insert(mapRoots, f) end
        end
        if #mapRoots == 0 then
            table.insert(mapRoots, workspace)
        end
        for _, root in ipairs(mapRoots) do
            if budget >= MAX_PARTS_TM then break end
            pcall(function()
                for _, d in ipairs(root:GetDescendants()) do
                    if budget >= MAX_PARTS_TM then break end
                    if d:IsA("BasePart")
                        and not _tmIsBrainrot(d)
                        and not _tmIsCharacterPart(d)
                        and not _tmIsProtected(d)
                        and not _tmIsPlotOrBase(d) then
                        _tmSetLocalTrans(d, MAP_LOCAL_TRANS)
                        budget = budget + 1
                    end
                end
            end)
        end
    end

    function _tmSave(map, object, value)
        if map[object] == nil then
            map[object] = value
        end
    end

    function _tmHideVisual(object)
        if not object or not object.Parent then return end
        if object:IsA("BasePart") then
            _tmSave(_tm.savedTransparency, object, object.LocalTransparencyModifier)
            object.LocalTransparencyModifier = 1
        elseif object:IsA("Decal") or object:IsA("Texture") then
            _tmSave(_tm.savedTransparency, object, object.Transparency)
            object.Transparency = 1
        elseif object:IsA("ParticleEmitter")
            or object:IsA("Trail")
            or object:IsA("Beam")
            or object:IsA("Highlight")
            or object:IsA("BillboardGui")
            or object:IsA("SurfaceGui")
            or object:IsA("ProximityPrompt")
            or object:IsA("PointLight")
            or object:IsA("SpotLight")
            or object:IsA("SurfaceLight") then
            _tmSave(_tm.savedEnabled, object, object.Enabled)
            object.Enabled = false
        elseif object:IsA("GuiObject") then
            _tmSave(_tm.savedVisible, object, object.Visible)
            object.Visible = false
        end
    end

    function _tmHideAnimal(model)
        if not model then return end
        for _, object in ipairs(model:GetDescendants()) do
            _tmHideVisual(object)
        end
        _tmHideVisual(model)
    end

    function _tmIsPurchaseWidget(object)
        value = string.lower(object.Name or "")
        if object:IsA("TextLabel") or object:IsA("TextButton") or object:IsA("TextBox") then
            value = value .. " " .. string.lower(object.Text or "")
        end
        return string.find(value, "purchase", 1, true) ~= nil
            or string.find(value, "buy", 1, true) ~= nil
            or string.find(value, "steal", 1, true) ~= nil
            or string.find(value, "comprar", 1, true) ~= nil
    end

    function _tmHidePurchaseWidget(object)
        if not _tm.promptGui or not _tmIsPurchaseWidget(object) then return end
        holder = object
        frame = nil
        while holder and holder ~= _tm.promptGui do
            if holder:IsA("GuiObject") then
                frame = holder
            end
            holder = holder.Parent
        end
        if frame then
            _tmSave(_tm.savedVisible, frame, frame.Visible)
            frame.Visible = false
        end
    end

    function _tmWatchPromptObject(object)
        _tmHidePurchaseWidget(object)
        if object:IsA("TextLabel") or object:IsA("TextButton") or object:IsA("TextBox") then
            table.insert(_tm.redConnections, object:GetPropertyChangedSignal("Text"):Connect(function()
                if State.transparentMapEnabled then
                    _tmHidePurchaseWidget(object)
                end
            end))
        end
    end

    function _tmApplyRedCarpet()
        _tm.animals = workspace:FindFirstChild("RenderedMovingAnimals")
        if not _tm.promptGui then
            pg = LP:FindFirstChild("PlayerGui")
            _tm.promptGui = pg and pg:FindFirstChild("ProximityPrompts")
        end
        if _tm.animals then
            for _, model in ipairs(_tm.animals:GetChildren()) do
                _tmHideAnimal(model)
            end
        end
        if _tm.promptGui then
            for _, object in ipairs(_tm.promptGui:GetDescendants()) do
                _tmWatchPromptObject(object)
            end
        end
    end

    function _tmRestoreRedCarpet()
        for object, value in pairs(_tm.savedTransparency) do
            if object and object.Parent then
                pcall(function()
                    if object:IsA("BasePart") then
                        object.LocalTransparencyModifier = value
                    elseif object:IsA("Decal") or object:IsA("Texture") then
                        object.Transparency = value
                    end
                end)
            end
        end
        for object, value in pairs(_tm.savedEnabled) do
            if object and object.Parent then
                pcall(function() object.Enabled = value end)
            end
        end
        for object, value in pairs(_tm.savedVisible) do
            if object and object.Parent then
                pcall(function() object.Visible = value end)
            end
        end
        table.clear(_tm.savedTransparency)
        table.clear(_tm.savedEnabled)
        table.clear(_tm.savedVisible)
    end

    function enableTransparentMap()
        if not State then return end
        State.transparentMapEnabled = true
        task.spawn(function()
            task.wait(0.1)
            pcall(_tmScanApply)
        end)
        if _tm.conn then
            pcall(function() _tm.conn:Disconnect() end)
        end
        _tm.conn = workspace.DescendantAdded:Connect(function(d)
            if not State.transparentMapEnabled then return end
            if not d:IsA("BasePart") then return end
            task.defer(function()
                if not State.transparentMapEnabled then return end
                if _tmIsBrainrot(d) and not _tmIsCharacterPart(d) and not _tmIsProtected(d) and not _tmIsPlotOrBase(d) then
                    _tmSetLocalTrans(d, BRAINROT_LOCAL_TRANS)
                elseif not _tmIsCharacterPart(d) and not _tmIsProtected(d) and not _tmIsPlotOrBase(d) then
                    _tmSetLocalTrans(d, MAP_LOCAL_TRANS)
                end
            end)
        end)
        _tmApplyRedCarpet()
        _tm.animals = workspace:FindFirstChild("RenderedMovingAnimals")
        if _tm.animals then
            table.insert(_tm.redConnections, _tm.animals.ChildAdded:Connect(function(model)
                if State.transparentMapEnabled then task.defer(function() _tmHideAnimal(model) end) end
            end))
            table.insert(_tm.redConnections, _tm.animals.DescendantAdded:Connect(function(obj)
                if State.transparentMapEnabled then task.defer(function() _tmHideVisual(obj) end) end
            end))
        end
        ProximityPromptService = game:GetService("ProximityPromptService")
        table.insert(_tm.redConnections, ProximityPromptService.PromptShown:Connect(function(prompt)
            if State.transparentMapEnabled and _tm.animals and prompt:IsDescendantOf(_tm.animals) then
                _tmHideVisual(prompt)
            end
        end))
        if not _tm.promptGui then
            pg = LP:FindFirstChild("PlayerGui")
            _tm.promptGui = pg and pg:FindFirstChild("ProximityPrompts")
        end
        if _tm.promptGui then
            table.insert(_tm.redConnections, _tm.promptGui.DescendantAdded:Connect(function(obj)
                if State.transparentMapEnabled then _tmWatchPromptObject(obj) end
            end))
        end
    end

    function disableTransparentMap()
        if not State then return end
        State.transparentMapEnabled = false
        if _tm.conn then
            pcall(function() _tm.conn:Disconnect() end)
            _tm.conn = nil
        end
        for _, e in ipairs(_tm.entries) do
            pcall(function()
                if e.inst and e.inst.Parent and e.prop == "LocalTransparencyModifier" then
                    e.inst.LocalTransparencyModifier = e.old or 0
                end
            end)
        end
        _tm.entries = {}
        for _, conn in ipairs(_tm.redConnections) do
            pcall(function() conn:Disconnect() end)
        end
        table.clear(_tm.redConnections)
        _tmRestoreRedCarpet()
    end

    -- Bat + Medusa: same path for both effects
    -- workspace[LocalPlayer.Name].Bat
    -- workspace[LocalPlayer.Name]["Medusa's Head"]
    _batMedusa = {
        enabled = false,
        originals = {},
        conn = nil,
        poll = nil,
        TARGET_T = 0.65,
    }

    _batMedusaRain = {
        enabled = false,
        originals = {},
        conn = nil,
        hue = 0,
        SPEED = 0.45,
    }

    function _bmPlayerFolder()
        plr = LP or Players.LocalPlayer
        if not plr then return nil end
        return workspace:FindFirstChild(plr.Name)
    end

    function _bmGetTools()
        local bat, med = nil, nil
        local folder = _bmPlayerFolder()
        if folder then
            bat = folder:FindFirstChild("Bat")
            med = folder:FindFirstChild("Medusa's Head")
        end
        -- also check character + backpack (equipped / inventory)
        local char = LP and LP.Character
        if not bat and char then
            bat = char:FindFirstChild("Bat")
        end
        if not med and char then
            med = char:FindFirstChild("Medusa's Head")
        end
        local bp = LP and LP:FindFirstChild("Backpack")
        if not bat and bp then
            bat = bp:FindFirstChild("Bat")
        end
        if not med and bp then
            med = bp:FindFirstChild("Medusa's Head")
        end
        return bat, med
    end

    function _bmForEachPart(model, fn)
        if not model then return end
        if model:IsA("BasePart") then fn(model) end
        for _, d in ipairs(model:GetDescendants()) do
            if d:IsA("BasePart") then
                fn(d)
            elseif d:IsA("Decal") or d:IsA("Texture") then
                fn(d)
            end
        end
    end

    function _bmApplyTransparent(model)
        _bmForEachPart(model, function(d)
            if d:IsA("BasePart") or d:IsA("Decal") or d:IsA("Texture") then
                if _batMedusa.originals[d] == nil then
                    pcall(function() _batMedusa.originals[d] = d.Transparency end)
                end
                pcall(function() d.Transparency = math.max(d.Transparency, _batMedusa.TARGET_T) end)
            end
        end)
    end

    function _bmScanTransparent()
        local bat, med = _bmGetTools()
        if bat then _bmApplyTransparent(bat) end
        if med then _bmApplyTransparent(med) end
    end

    function enableBatMedusaTransparent()
        if not State then return end
        State.batMedusaTransparent = true
        _batMedusa.enabled = true
        _bmScanTransparent()

        if _batMedusa.conn then pcall(function() _batMedusa.conn:Disconnect() end) end
        if _batMedusa.poll then pcall(function() _batMedusa.poll:Disconnect() end) end

        folder = _bmPlayerFolder()
        if folder then
            _batMedusa.conn = folder.DescendantAdded:Connect(function()
                if _batMedusa.enabled then task.defer(_bmScanTransparent) end
            end)
        end
        -- poll so equip/respawn still gets caught
        _batMedusa.poll = RunService.Heartbeat:Connect(function()
            if not _batMedusa.enabled then return end
            if (tick() % 0.5) < 0.03 then
                _bmScanTransparent()
            end
        end)
    end

    function disableBatMedusaTransparent()
        if not State then return end
        State.batMedusaTransparent = false
        _batMedusa.enabled = false
        if _batMedusa.conn then pcall(function() _batMedusa.conn:Disconnect() end) _batMedusa.conn = nil end
        if _batMedusa.poll then pcall(function() _batMedusa.poll:Disconnect() end) _batMedusa.poll = nil end
        for inst, old in pairs(_batMedusa.originals) do
            pcall(function()
                if inst and inst.Parent and typeof(old) == "number" then
                    inst.Transparency = old
                end
            end)
        end
        table.clear(_batMedusa.originals)
    end

    function _bmEnsureRainbowHighlight(model)
        if not model then return nil end
        h = model:FindFirstChild("_KyzDuelsRainbowHL")
        if not h then
            h = Instance.new("Highlight")
            h.Name = "_KyzDuelsRainbowHL"
            h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            h.FillTransparency = 0.4
            h.OutlineTransparency = 0.15
            h.Parent = model
        end
        return h
    end

    function _bmPaintRainbow(model, color)
        if not model then return end
        hl = _bmEnsureRainbowHighlight(model)
        if hl then
            pcall(function()
                hl.FillColor = color
                hl.OutlineColor = color
            end)
        end
        _bmForEachPart(model, function(d)
            if d:IsA("BasePart") then
                if _batMedusaRain.originals[d] == nil then
                    pcall(function()
                        _batMedusaRain.originals[d] = {
                            Color = d.Color,
                            TextureID = (d:IsA("MeshPart") and d.TextureID) or nil,
                        }
                    end)
                end
                pcall(function()
                    if d:IsA("MeshPart") and d.TextureID ~= "" then
                        d.TextureID = ""
                    end
                    d.Color = color
                end)
            end
        end)
    end

    function enableBatMedusaRainbow()
        if not State then return end
        State.batMedusaRainbow = true
        _batMedusaRain.enabled = true
        _batMedusaRain.hue = 0
        if _batMedusaRain.conn then pcall(function() _batMedusaRain.conn:Disconnect() end) end

        _batMedusaRain.conn = RunService.Heartbeat:Connect(function(dt)
            if not _batMedusaRain.enabled then return end
            _batMedusaRain.hue = (_batMedusaRain.hue + (dt or 0.016) * _batMedusaRain.SPEED) % 1
            color = Color3.fromHSV(_batMedusaRain.hue, 1, 1)
            local bat, med = _bmGetTools()
            if bat then _bmPaintRainbow(bat, color) end
            if med then _bmPaintRainbow(med, color) end
        end)
    end

    function disableBatMedusaRainbow()
        if not State then return end
        State.batMedusaRainbow = false
        _batMedusaRain.enabled = false
        if _batMedusaRain.conn then pcall(function() _batMedusaRain.conn:Disconnect() end) _batMedusaRain.conn = nil end

        local bat, med = _bmGetTools()
        for _, model in ipairs({ bat, med }) do
            if model then
                h = model:FindFirstChild("_KyzDuelsRainbowHL")
                if h then pcall(function() h:Destroy() end) end
            end
        end

        for inst, old in pairs(_batMedusaRain.originals) do
            pcall(function()
                if inst and inst.Parent and type(old) == "table" then
                    if old.Color then inst.Color = old.Color end
                    if old.TextureID ~= nil and inst:IsA("MeshPart") then
                        inst.TextureID = old.TextureID
                    end
                elseif inst and inst.Parent and typeof(old) == "Color3" then
                    inst.Color = old
                end
            end)
        end
        table.clear(_batMedusaRain.originals)
    end

    -- Bat Custom: overlay catalog visual on Bat (supports multiple skins)
    BAT_CUSTOMS = {
        {
            key = "diamond",
            name = "Minecraft diamond sword",
            -- Ambitious DiamondSword mesh + coords (sound kept)
            mesh = "rbxassetid://8827558932",
            tex = "rbxassetid://8827558969",
            scale = Vector3.new(0.2, 0.2, 0.2),
            grip = CFrame.new(-0.05, -0.1, -0.12) * CFrame.Angles(math.rad(90), math.rad(180), 300),
            id = 8827558932,
            swingSound = 83467757893556, -- minecraftswordswing (kept)
        },
        {
            key = "scythe_bear",
            name = "Scythe with Bear",
            id = 110490360258502,
            -- hold near the tip of the shaft
            grip = CFrame.new(0, -0.05, -1.35) * CFrame.Angles(math.rad(20), math.rad(90), math.rad(0)),
            swingSound = 93468677306378, -- hornet-sword-4
        },
        {
            key = "scythe_white",
            name = "Scythe White",
            id = 103142722866846,
            -- position from your preferred version (full grip)
            grip = CFrame.new(0, -0.05, -1.35) * CFrame.Angles(math.rad(-12), math.rad(-88), math.rad(325)),
            swingSound = 83288683119028, -- seedgespecialh0308
        },
        {
            key = "black_hammer",
            name = "Black Hammer",
            id = 114452163024876,
            grip = CFrame.Angles(math.rad(-87), math.rad(170), 0),
            swingSound = 85272437084466,
        },
    }
    BAT_CUSTOM_BY_KEY = {}
    for _, entry in ipairs(BAT_CUSTOMS) do
        BAT_CUSTOM_BY_KEY[entry.key] = entry
    end

    _batCustom = {
        enabled = false,
        template = nil,
        currentKey = "diamond",
        currentId = 96153431717396,
        originals = {},
        visuals = {},
        poll = nil,
        resolved = false,
        resolvedId = nil,
    }

    function _batCustomGetEntry()
        key = (State and State.batCustomKey) or _batCustom.currentKey or "diamond"
        entry = BAT_CUSTOM_BY_KEY[key] or BAT_CUSTOMS[1]
        return entry
    end

    function _batCustomResolveTemplate(force)
        entry = _batCustomGetEntry()
        if not entry then return false end
        -- Mesh-based skins (Ambitious DiamondSword style): no external model needed
        if entry.mesh then
            local mid = entry.id or entry.mesh
            if not force and _batCustom.resolved and _batCustom.resolvedId == mid and _batCustom.templateIsMesh then
                return true
            end
            _batCustom.template = nil
            _batCustom.templateIsModel = false
            _batCustom.templateIsMesh = true
            _batCustom.resolved = true
            _batCustom.resolvedId = mid
            _batCustom.currentKey = entry.key
            _batCustom.currentId = mid
            return true
        end
        _batCustom.templateIsMesh = false
        if not force and _batCustom.resolved and _batCustom.template and _batCustom.resolvedId == entry.id then
            return true
        end
        if _batCustom.template then
            pcall(function() _batCustom.template:Destroy() end)
            _batCustom.template = nil
        end
        _batCustom.resolved = false
        _batCustom.resolvedId = nil

        assetId = entry.id
        model = nil
        pcall(function()
            if game.GetObjects then
                objs = game:GetObjects("rbxassetid://" .. tostring(assetId))
                if objs and objs[1] then model = objs[1] end
            end
        end)
        if not model then
            pcall(function()
                is = game:GetService("InsertService")
                model = is:LoadAsset(assetId)
            end)
        end
        if not model then return false end

        -- Prefer full model if it has multiple visual parts (scythe + bear etc.)
        src = nil
        handlePart = model:FindFirstChild("Handle", true)
        meshCount = 0
        for _, d in ipairs(model:GetDescendants()) do
            if d:IsA("MeshPart") or (d:IsA("BasePart") and d:FindFirstChildOfClass("SpecialMesh")) then
                meshCount = meshCount + 1
            end
        end

        if meshCount >= 2 and (model:IsA("Model") or model:IsA("Tool") or model:IsA("Folder")) then
            -- clone whole model as a container Model, primary = Handle or first BasePart
            tpl = Instance.new("Model")
            tpl.Name = "_KyzDuelsBatCustomVisual"
            primary = nil
            for _, ch in ipairs(model:GetChildren()) do
                if ch:IsA("BasePart") or ch:IsA("MeshPart") or ch:IsA("Model") or ch:IsA("Folder") or ch:IsA("Accessory") then
                    cl = ch:Clone()
                    cl.Parent = tpl
                    if not primary then
                        if cl:IsA("BasePart") then primary = cl
                        else
                            primary = cl:FindFirstChildWhichIsA("BasePart", true)
                        end
                    end
                end
            end
            if not primary then
                primary = tpl:FindFirstChildWhichIsA("BasePart", true)
            end
            if primary then
                pcall(function() tpl.PrimaryPart = primary end)
            end
            for _, d in ipairs(tpl:GetDescendants()) do
                if d:IsA("BasePart") then
                    d.Anchored = false
                    d.CanCollide = false
                    d.CanQuery = false
                    d.CanTouch = false
                    d.Massless = true
                    pcall(function() d.CastShadow = true end)
                elseif d:IsA("Weld") or d:IsA("WeldConstraint") or d:IsA("Motor6D") or d:IsA("Script") or d:IsA("LocalScript") then
                    -- keep internal welds between scythe parts; strip scripts only
                    if d:IsA("Script") or d:IsA("LocalScript") then
                        pcall(function() d:Destroy() end)
                    end
                end
            end
            if not primary then
                pcall(function() tpl:Destroy() end)
                pcall(function() model:Destroy() end)
                return false
            end
            _batCustom.templateIsModel = true
            _batCustom.templatePrimary = primary
        else
            src = model:FindFirstChildWhichIsA("MeshPart", true)
            if not src then
                h = model:FindFirstChild("Handle", true)
                if h and h:IsA("BasePart") then src = h end
            end
            if not src then
                src = model:FindFirstChildWhichIsA("BasePart", true)
            end
            if not src then
                pcall(function() model:Destroy() end)
                return false
            end
            tpl = src:Clone()
            tpl.Name = "_KyzDuelsBatCustomVisual"
            tpl.Anchored = false
            tpl.CanCollide = false
            tpl.CanQuery = false
            tpl.CanTouch = false
            tpl.Massless = true
            pcall(function() tpl.CastShadow = true end)
            for _, d in ipairs(tpl:GetDescendants()) do
                if d:IsA("Weld") or d:IsA("WeldConstraint") or d:IsA("Motor6D") or d:IsA("Script") or d:IsA("LocalScript") then
                    pcall(function() d:Destroy() end)
                end
            end
            for _, d in ipairs(tpl:GetChildren()) do
                if d:IsA("Weld") or d:IsA("WeldConstraint") or d:IsA("Motor6D") then
                    pcall(function() d:Destroy() end)
                end
            end
            _batCustom.templateIsModel = false
            _batCustom.templatePrimary = tpl
        end

        _batCustom.template = tpl
        _batCustom.resolved = true
        _batCustom.resolvedId = assetId
        _batCustom.currentKey = entry.key
        _batCustom.currentId = assetId
        pcall(function() model:Destroy() end)
        return true
    end

    function _batCustomClearVisual(bat)
        if not bat then return end
        vis = bat:FindFirstChild("_KyzDuelsBatCustomVisual")
        if vis then pcall(function() vis:Destroy() end) end
        if _batCustom.visuals[bat] then
            pcall(function()
                if _batCustom.visuals[bat].Parent then _batCustom.visuals[bat]:Destroy() end
            end)
            _batCustom.visuals[bat] = nil
        end
    end

    function _batCustomHideOriginal(part)
        if not part or not part:IsA("BasePart") then return end
        if _batCustom.originals[part] == nil then
            _batCustom.originals[part] = {
                Transparency = part.Transparency,
                LTM = part.LocalTransparencyModifier,
            }
        end
        pcall(function()
            part.LocalTransparencyModifier = 1
            part.Transparency = 1
        end)
        -- hide meshes/decals under handle
        for _, d in ipairs(part:GetChildren()) do
            if d:IsA("SpecialMesh") or d:IsA("Decal") or d:IsA("Texture") then
                if _batCustom.originals[d] == nil then
                    pcall(function()
                        if d:IsA("SpecialMesh") then
                            _batCustom.originals[d] = { Scale = d.Scale }
                        else
                            _batCustom.originals[d] = { Transparency = d.Transparency }
                        end
                    end)
                end
                pcall(function()
                    if d:IsA("SpecialMesh") then d.Scale = Vector3.zero
                    else d.Transparency = 1 end
                end)
            end
        end
    end

    -- Only stop the swing whoosh — do NOT lock Volume=0 (that killed hit SFX)
    _batCustom.mutedSounds = _batCustom.mutedSounds or {}

    function _batCustomMuteOriginalSounds(bat)
        if not bat then return end
        pcall(function()
            for _, d in ipairs(bat:GetDescendants()) do
                if d:IsA("Sound") and d.Name ~= "_KyzDuelsBatSwingSound" then
                    local n = string.lower(tostring(d.Name or ""))
                    local isHit = n:find("hit", 1, true) or n:find("impact", 1, true) or n:find("slap", 1, true)
                    if not isHit then
                        if d.Playing then pcall(function() d:Stop() end) end
                        if _batCustom.mutedSounds[d] == nil then
                            _batCustom.mutedSounds[d] = d.Volume
                        end
                        pcall(function() d.Volume = 0 end)
                    end
                end
            end
            for _, d in ipairs(bat:GetChildren()) do
                if d:IsA("Sound") and d.Name ~= "_KyzDuelsBatSwingSound" then
                    local n = string.lower(tostring(d.Name or ""))
                    local isHit = n:find("hit", 1, true) or n:find("impact", 1, true) or n:find("slap", 1, true)
                    if not isHit then
                        if d.Playing then pcall(function() d:Stop() end) end
                        if _batCustom.mutedSounds[d] == nil then
                            _batCustom.mutedSounds[d] = d.Volume
                        end
                        pcall(function() d.Volume = 0 end)
                    end
                end
            end
            task.delay(0.2, function()
                pcall(_batCustomRestoreOriginalSounds)
            end)
        end)
    end

    function _batCustomRestoreOriginalSounds()
        pcall(function()
            for snd, vol in pairs(_batCustom.mutedSounds or {}) do
                if snd and snd.Parent then
                    pcall(function() snd.Volume = typeof(vol) == "number" and vol or 1 end)
                end
            end
            table.clear(_batCustom.mutedSounds)
        end)
    end

    _batCustom.lastSwingSoundAt = 0

    function _batCustomPlaySwingSound(parent)
        if State and State.batNoSound then return end
        if not (_batCustom and _batCustom.enabled) and not (State and State.batCustomEnabled) then return end
        local entry = _batCustomGetEntry()
        if not entry or not entry.swingSound then return end
        if not parent then
            local bat0 = nil
            pcall(function() if type(findBat) == "function" then bat0 = findBat() end end)
            parent = bat0 and (bat0:FindFirstChild("Handle") or bat0) or nil
        end
        if not parent then return end
        local cd = 0.7
        local now = os.clock()
        if (now - (_batCustom.lastSwingSoundAt or 0)) < cd then
            return
        end
        _batCustom.lastSwingSoundAt = now
        local bat = parent:IsA("Tool") and parent or parent.Parent
        if bat and bat:IsA("Tool") then pcall(_batCustomMuteOriginalSounds, bat) end
        pcall(function()
            local oldS = parent:FindFirstChild("_KyzDuelsBatSwingSound")
            if oldS then pcall(function() oldS:Destroy() end) end
            local s = Instance.new("Sound")
            s.Name = "_KyzDuelsBatSwingSound"
            s.SoundId = "rbxassetid://" .. tostring(entry.swingSound)
            s.Volume = 1
            s.PlaybackSpeed = 1
            s.RollOffMaxDistance = 100
            s.Parent = parent
            s:Play()
            s.Ended:Connect(function()
                pcall(function() s:Destroy() end)
            end)
            task.delay(4, function()
                if s and s.Parent then pcall(function() s:Destroy() end) end
            end)
        end)
    end

    function _batCustomEnsureSwingOnHit()
        if State and State.batNoSound then return end
        if not (State and State.batCustomEnabled) and not (_batCustom and _batCustom.enabled) then return end
        local bat = nil
        pcall(function()
            if type(findBat) == "function" then bat = findBat() end
        end)
        if not bat then
            pcall(function()
                local c = LP.Character
                if c then
                    for _, t in ipairs(c:GetChildren()) do
                        if t:IsA("Tool") then bat = t; break end
                    end
                end
            end)
        end
        if not bat then return end
        local handle = bat:FindFirstChild("Handle")
        if not (handle and handle:IsA("BasePart")) then
            handle = bat:FindFirstChildWhichIsA("BasePart", true)
        end
        pcall(_batCustomPlaySwingSound, handle or bat)
    end

    function _batCustomHookSwing(bat)
        if not bat then return end
        if bat:GetAttribute("_KyzDuelsSwingHooked") then return end
        bat:SetAttribute("_KyzDuelsSwingHooked", true)
        bat.Activated:Connect(function()
            if not _batCustom.enabled then return end
            local entry = _batCustomGetEntry()
            if not entry or not entry.swingSound then return end
            -- No Sound: leave original bat audio alone
            if State and State.batNoSound then
                return
            end
            -- same logic as other customs: mute original whoosh, play entry.swingSound
            _batCustomMuteOriginalSounds(bat)
            task.defer(function()
                _batCustomMuteOriginalSounds(bat)
            end)
            task.delay(0.05, function()
                if _batCustom.enabled then
                    pcall(_batCustomMuteOriginalSounds, bat)
                end
            end)
            local handle = bat:FindFirstChild("Handle")
            if not (handle and handle:IsA("BasePart")) then
                handle = bat:FindFirstChildWhichIsA("BasePart", true)
            end
            _batCustomPlaySwingSound(handle or bat)
        end)
        -- do NOT mute every new Sound — hit impact SFX must stay audible
    end

    function _batCustomApplyToBat()
        if not _batCustomResolveTemplate() then return end
        bat = select(1, _bmGetTools())
        if not bat then return end

        handle = bat:FindFirstChild("Handle")
        if not (handle and handle:IsA("BasePart")) then
            handle = bat:FindFirstChildWhichIsA("BasePart", true)
        end
        if not handle then return end

        entry = _batCustomGetEntry()
        GRIP_CF = (entry and entry.grip) or CFrame.Angles(math.rad(30), math.rad(170), 0)

        existing = bat:FindFirstChild("_KyzDuelsBatCustomVisual")
        if existing then
            needRebuild = false
            pcall(function()
                if _batCustom.resolvedId and existing:GetAttribute("_KyzDuelsCustomId") ~= _batCustom.resolvedId then
                    needRebuild = true
                end
            end)
            if needRebuild then
                pcall(function() existing:Destroy() end)
            else
                -- keep grip updated
                weld = existing:FindFirstChild("_KyzDuelsBatCustomWeld", true)
                if weld and (weld:IsA("Weld") or weld:IsA("Motor6D")) then
                    pcall(function()
                        weld.C0 = GRIP_CF
                        weld.C1 = CFrame.new()
                    end)
                end
                _batCustomHideOriginal(handle)
                pcall(function() _batCustomHookSwing(bat) end)
                return
            end
        end

        _batCustomHideOriginal(handle)

        local weldPart = nil
        local vis = nil

        -- Ambitious-style mesh replica (DiamondSword)
        if entry and entry.mesh then
            vis = Instance.new("Model")
            vis.Name = "_KyzDuelsBatCustomVisual"
            pcall(function() vis:SetAttribute("_KyzDuelsCustomId", _batCustom.resolvedId) end)

            local p = Instance.new("Part")
            p.Name = "MainPart"
            p.CanCollide = false
            p.CanQuery = false
            p.CanTouch = false
            p.Massless = true
            p.Size = Vector3.new(1, 1, 1)
            p.Transparency = 0
            p.Anchored = false
            p.Parent = vis

            local mesh = Instance.new("SpecialMesh")
            mesh.MeshType = Enum.MeshType.FileMesh
            mesh.MeshId = entry.mesh
            mesh.TextureId = entry.tex or ""
            mesh.Scale = entry.scale or Vector3.new(0.2, 0.2, 0.2)
            mesh.Parent = p

            local w = Instance.new("Motor6D")
            w.Name = "_KyzDuelsBatCustomWeld"
            w.Part0 = handle
            w.Part1 = p
            w.C0 = GRIP_CF
            w.C1 = CFrame.new()
            w.Parent = p

            vis.Parent = bat
            weldPart = p
            _batCustom.visuals[bat] = vis
            pcall(function() _batCustomHookSwing(bat) end)
            return
        end

        if not _batCustom.template then return end
        vis = _batCustom.template:Clone()
        vis.Name = "_KyzDuelsBatCustomVisual"
        pcall(function() vis:SetAttribute("_KyzDuelsCustomId", _batCustom.resolvedId) end)
        vis.Parent = bat

        -- resolve part to weld (single BasePart or Model.PrimaryPart)
        weldPart = nil
        if vis:IsA("BasePart") then
            weldPart = vis
            vis.Anchored = false
            vis.CanCollide = false
            vis.CanQuery = false
            vis.CanTouch = false
            vis.Massless = true
        elseif vis:IsA("Model") then
            weldPart = vis.PrimaryPart or vis:FindFirstChildWhichIsA("BasePart", true)
            for _, d in ipairs(vis:GetDescendants()) do
                if d:IsA("BasePart") then
                    d.Anchored = false
                    d.CanCollide = false
                    d.CanQuery = false
                    d.CanTouch = false
                    d.Massless = true
                end
            end
            if weldPart then
                pcall(function()
                    vis:PivotTo(handle.CFrame * GRIP_CF)
                end)
            end
        end

        if not weldPart then
            pcall(function() vis:Destroy() end)
            return
        end

        pcall(function()
            if vis:IsA("BasePart") then
                vis.CFrame = handle.CFrame * GRIP_CF
            end
        end)

        weld = Instance.new("Weld")
        weld.Name = "_KyzDuelsBatCustomWeld"
        weld.Part0 = handle
        weld.Part1 = weldPart
        weld.C0 = GRIP_CF
        weld.C1 = CFrame.new()
        weld.Parent = vis

        _batCustom.visuals[bat] = vis
        pcall(function() _batCustomHookSwing(bat) end)
    end

    function enableBatCustom(key)
        if not State then return end
        if type(key) == "string" and BAT_CUSTOM_BY_KEY[key] then
            State.batCustomKey = key
            _batCustom.currentKey = key
        end
        State.batCustomEnabled = true
        _batCustom.enabled = true
        task.spawn(function()
            _batCustom.resolved = false
            _batCustom.resolvedId = nil
            if _batCustom.template then
                pcall(function() _batCustom.template:Destroy() end)
                _batCustom.template = nil
            end
            -- try a few times in case Bat isn't spawned yet
            for attempt = 1, 8 do
                local bat = select(1, _bmGetTools())
                if bat then
                    local old = bat:FindFirstChild("_KyzDuelsBatCustomVisual")
                    if old then pcall(function() old:Destroy() end) end
                    if _batCustomResolveTemplate(true) then
                        _batCustomApplyToBat()
                        if bat:FindFirstChild("_KyzDuelsBatCustomVisual") then
                            break
                        end
                    end
                end
                task.wait(0.35)
            end
        end)
        if _batCustom.poll then pcall(function() _batCustom.poll:Disconnect() end) end
        _batCustom.poll = RunService.Heartbeat:Connect(function()
            if not _batCustom.enabled then return end
            if (tick() % 0.75) < 0.03 then
                _batCustomApplyToBat()
            end
        end)
    end

    function disableBatCustom()
        if not State then return end
        State.batCustomEnabled = false
        _batCustom.enabled = false
        if _batCustom.poll then pcall(function() _batCustom.poll:Disconnect() end) _batCustom.poll = nil end
        pcall(_batCustomRestoreOriginalSounds)

        bat = select(1, _bmGetTools())
        if bat then _batCustomClearVisual(bat) end
        for b, _ in pairs(_batCustom.visuals) do
            _batCustomClearVisual(b)
        end
        table.clear(_batCustom.visuals)

        for inst, old in pairs(_batCustom.originals) do
            pcall(function()
                if not (inst and inst.Parent) or type(old) ~= "table" then return end
                if inst:IsA("BasePart") then
                    if old.Transparency ~= nil then inst.Transparency = old.Transparency end
                    if old.LTM ~= nil then inst.LocalTransparencyModifier = old.LTM end
                elseif inst:IsA("SpecialMesh") then
                    if old.Scale then inst.Scale = old.Scale end
                elseif inst:IsA("Decal") or inst:IsA("Texture") then
                    if old.Transparency ~= nil then inst.Transparency = old.Transparency end
                end
            end)
        end
        table.clear(_batCustom.originals)
    end

    -- ============================================================
    -- MEDUSE CUSTOM — same method as Bat Custom, targets Medusa's Head
    -- Path: workspace[LocalPlayer.Name]["Medusa's Head"] (auto-detect)
    -- ============================================================
    MEDUSA_CUSTOMS = {
        {
            key = "evil",
            name = "Evil Skull",
            id = 7855324601,
            -- flipped: was facing opposite
            grip = CFrame.new(0, 0, 0) * CFrame.Angles(0, math.rad(180), 0),
        },
        {
            key = "ominous",
            name = "Ominous Skull",
            id = 11983700343,
            grip = CFrame.new(0, 0, 0),
            swingSound = 129030117458818, -- Kratos-Medusa
            soundCooldown = 25, -- only every 25 seconds
        },
        {
            key = "cone",
            name = "Skull Cone",
            id = 88582363429320,
            -- flipped: was facing opposite
            grip = CFrame.new(0, 0, 0) * CFrame.Angles(0, math.rad(180), 0),
        },
        {
            key = "kamehameha",
            name = "Kamehameha",
            id = 134121959707227, -- Gogeta DBS Kamehameha Energy Beam
            grip = CFrame.new(0, 0, 0),
            swingSound = 138517216516736, -- DRAGON BALL FighterZ Selection
            soundCooldown = 25, -- same as Ominous
        },
        {
            key = "fireball",
            name = "Fire Ball",
            id = 83021250, -- The Fiery Sun
            grip = CFrame.new(0, 0, 0),
            swingSound = 90228815682492, -- fire-ball
            soundCooldown = 25,
        },
        {
            key = "rasengan",
            name = "Rasengan",
            id = 131058442581341, -- Rasengan
            grip = CFrame.new(0, 0, 0),
            swingSound = 125531138027447, -- Naruto-rasengan
            soundCooldown = 25,
        },
    }
    MEDUSA_CUSTOM_BY_KEY = {}
    for _, entry in ipairs(MEDUSA_CUSTOMS) do
        MEDUSA_CUSTOM_BY_KEY[entry.key] = entry
    end

    _medusaCustom = {
        enabled = false,
        template = nil,
        currentKey = "evil",
        currentId = 7855324601,
        originals = {},
        visuals = {},
        poll = nil,
        resolved = false,
        resolvedId = nil,
        lastSwingSoundAt = 0,
        mutedSounds = {},
        soundWatchConn = nil,
    }

    function _medusaCustomGetEntry()
        local key = (State and State.skullCustomKey) or _medusaCustom.currentKey or "evil"
        return MEDUSA_CUSTOM_BY_KEY[key] or MEDUSA_CUSTOMS[1]
    end

    function _medusaCustomGetTool()
        -- same detection as _bmGetTools, but only Medusa's Head
        -- workspace[LocalPlayer.Name]["Medusa's Head"]
        local med = nil
        local plr = LP or Players.LocalPlayer
        if not plr then return nil end
        local folder = workspace:FindFirstChild(plr.Name)
        if folder then
            med = folder:FindFirstChild("Medusa's Head")
        end
        local char = plr.Character
        if not med and char then
            med = char:FindFirstChild("Medusa's Head")
        end
        local bp = plr:FindFirstChild("Backpack")
        if not med and bp then
            med = bp:FindFirstChild("Medusa's Head")
        end
        -- also try via _bmGetTools if available
        if not med and type(_bmGetTools) == "function" then
            local _, m = _bmGetTools()
            med = m
        end
        return med
    end

    function _medusaCustomResolveTemplate(force)
        local entry = _medusaCustomGetEntry()
        if not entry then return false end
        if not force and _medusaCustom.resolved and _medusaCustom.template and _medusaCustom.resolvedId == entry.id then
            return true
        end
        if _medusaCustom.template then
            pcall(function() _medusaCustom.template:Destroy() end)
            _medusaCustom.template = nil
        end
        _medusaCustom.resolved = false
        _medusaCustom.resolvedId = nil

        local assetId = entry.id
        local model = nil
        pcall(function()
            if game.GetObjects then
                local objs = game:GetObjects("rbxassetid://" .. tostring(assetId))
                if objs and objs[1] then model = objs[1] end
            end
        end)
        if not model then
            pcall(function()
                local isv = game:GetService("InsertService")
                model = isv:LoadAsset(assetId)
            end)
        end
        if not model then return false end

        local src = nil
        local meshCount = 0
        for _, d in ipairs(model:GetDescendants()) do
            if d:IsA("MeshPart") or (d:IsA("BasePart") and d:FindFirstChildOfClass("SpecialMesh")) then
                meshCount = meshCount + 1
            end
        end

        local tpl
        if meshCount >= 2 and (model:IsA("Model") or model:IsA("Tool") or model:IsA("Folder") or model:IsA("Accessory")) then
            tpl = Instance.new("Model")
            tpl.Name = "_KyzDuelsMedusaCustomVisual"
            local primary = nil
            for _, ch in ipairs(model:GetChildren()) do
                if ch:IsA("BasePart") or ch:IsA("MeshPart") or ch:IsA("Model") or ch:IsA("Folder") or ch:IsA("Accessory") then
                    local cl = ch:Clone()
                    cl.Parent = tpl
                    if not primary then
                        if cl:IsA("BasePart") then primary = cl
                        else primary = cl:FindFirstChildWhichIsA("BasePart", true) end
                    end
                end
            end
            if not primary then
                primary = tpl:FindFirstChildWhichIsA("BasePart", true)
            end
            if primary then
                pcall(function() tpl.PrimaryPart = primary end)
            end
            for _, d in ipairs(tpl:GetDescendants()) do
                if d:IsA("BasePart") then
                    d.Anchored = false
                    d.CanCollide = false
                    d.CanQuery = false
                    d.CanTouch = false
                    d.Massless = true
                elseif d:IsA("Script") or d:IsA("LocalScript") then
                    pcall(function() d:Destroy() end)
                end
            end
            if not primary then
                pcall(function() tpl:Destroy() end)
                pcall(function() model:Destroy() end)
                return false
            end
        else
            src = model:FindFirstChildWhichIsA("MeshPart", true)
            if not src then
                local h = model:FindFirstChild("Handle", true)
                if h and h:IsA("BasePart") then src = h end
            end
            if not src then
                src = model:FindFirstChildWhichIsA("BasePart", true)
            end
            if not src then
                -- accessory fallback: take the accessory itself / handle
                if model:IsA("Accessory") then
                    src = model:FindFirstChild("Handle") or model:FindFirstChildWhichIsA("BasePart", true)
                end
            end
            if not src then
                pcall(function() model:Destroy() end)
                return false
            end
            tpl = src:Clone()
            tpl.Name = "_KyzDuelsMedusaCustomVisual"
            tpl.Anchored = false
            tpl.CanCollide = false
            tpl.CanQuery = false
            tpl.CanTouch = false
            tpl.Massless = true
            for _, d in ipairs(tpl:GetDescendants()) do
                if d:IsA("Weld") or d:IsA("WeldConstraint") or d:IsA("Motor6D") or d:IsA("Script") or d:IsA("LocalScript") then
                    pcall(function() d:Destroy() end)
                end
            end
        end

        _medusaCustom.template = tpl
        _medusaCustom.resolved = true
        _medusaCustom.resolvedId = assetId
        _medusaCustom.currentKey = entry.key
        _medusaCustom.currentId = assetId
        pcall(function() model:Destroy() end)
        return true
    end

    function _medusaCustomClearVisual(tool)
        if not tool then return end
        local vis = tool:FindFirstChild("_KyzDuelsMedusaCustomVisual")
        if vis then pcall(function() vis:Destroy() end) end
        if _medusaCustom.visuals[tool] then
            pcall(function()
                if _medusaCustom.visuals[tool].Parent then _medusaCustom.visuals[tool]:Destroy() end
            end)
            _medusaCustom.visuals[tool] = nil
        end
    end

    function _medusaCustomHideOriginal(part)
        if not part or not part:IsA("BasePart") then return end
        if _medusaCustom.originals[part] == nil then
            _medusaCustom.originals[part] = {
                Transparency = part.Transparency,
                LTM = part.LocalTransparencyModifier,
            }
        end
        pcall(function()
            part.LocalTransparencyModifier = 1
            part.Transparency = 1
        end)
        for _, d in ipairs(part:GetChildren()) do
            if d:IsA("SpecialMesh") or d:IsA("Decal") or d:IsA("Texture") then
                if _medusaCustom.originals[d] == nil then
                    pcall(function()
                        if d:IsA("SpecialMesh") then
                            _medusaCustom.originals[d] = { Scale = d.Scale }
                        else
                            _medusaCustom.originals[d] = { Transparency = d.Transparency }
                        end
                    end)
                end
                pcall(function()
                    if d:IsA("SpecialMesh") then d.Scale = Vector3.zero
                    else d.Transparency = 1 end
                end)
            end
        end
    end

    function _medusaCustomApplyToTool()
        if not _medusaCustomResolveTemplate() then return end
        local tool = _medusaCustomGetTool()
        if not tool then return end

        local handle = tool:FindFirstChild("Handle")
        if not (handle and handle:IsA("BasePart")) then
            handle = tool:FindFirstChildWhichIsA("BasePart", true)
        end
        if not handle then return end

        local entry = _medusaCustomGetEntry()
        local GRIP_CF = (entry and entry.grip) or CFrame.new()

        local existing = tool:FindFirstChild("_KyzDuelsMedusaCustomVisual")
        if existing then
            local needRebuild = false
            pcall(function()
                if _medusaCustom.resolvedId and existing:GetAttribute("_KyzDuelsCustomId") ~= _medusaCustom.resolvedId then
                    needRebuild = true
                end
            end)
            if needRebuild then
                pcall(function() existing:Destroy() end)
            else
                local weld = existing:FindFirstChild("_KyzDuelsMedusaCustomWeld", true)
                if weld and weld:IsA("Weld") then
                    pcall(function()
                        weld.C0 = GRIP_CF
                        weld.C1 = CFrame.new()
                    end)
                end
                _medusaCustomHideOriginal(handle)
                pcall(function() _medusaCustomHookSwing(tool) end)
                return
            end
        end

        _medusaCustomHideOriginal(handle)

        local vis = _medusaCustom.template:Clone()
        vis.Name = "_KyzDuelsMedusaCustomVisual"
        pcall(function() vis:SetAttribute("_KyzDuelsCustomId", _medusaCustom.resolvedId) end)
        vis.Parent = tool

        local weldPart = nil
        if vis:IsA("BasePart") then
            weldPart = vis
            vis.Anchored = false
            vis.CanCollide = false
            vis.CanQuery = false
            vis.CanTouch = false
            vis.Massless = true
        elseif vis:IsA("Model") then
            weldPart = vis.PrimaryPart or vis:FindFirstChildWhichIsA("BasePart", true)
            for _, d in ipairs(vis:GetDescendants()) do
                if d:IsA("BasePart") then
                    d.Anchored = false
                    d.CanCollide = false
                    d.CanQuery = false
                    d.CanTouch = false
                    d.Massless = true
                end
            end
            if weldPart then
                pcall(function()
                    vis:PivotTo(handle.CFrame * GRIP_CF)
                end)
            end
        end

        if not weldPart then
            pcall(function() vis:Destroy() end)
            return
        end

        pcall(function()
            if vis:IsA("BasePart") then
                vis.CFrame = handle.CFrame * GRIP_CF
            end
        end)

        local weld = Instance.new("Weld")
        weld.Name = "_KyzDuelsMedusaCustomWeld"
        weld.Part0 = handle
        weld.Part1 = weldPart
        weld.C0 = GRIP_CF
        weld.C1 = CFrame.new()
        weld.Parent = vis

        _medusaCustom.visuals[tool] = vis
        pcall(function() _medusaCustomHookSwing(tool) end)
    end

    function _medusaCustomMuteOriginalSounds(tool)
        if not tool then return end
        pcall(function()
            for _, d in ipairs(tool:GetDescendants()) do
                if d:IsA("Sound") and d.Name ~= "_KyzDuelsMedusaSwingSound" then
                    if _medusaCustom.mutedSounds[d] == nil then
                        _medusaCustom.mutedSounds[d] = { Volume = d.Volume }
                    end
                    d.Volume = 0
                    pcall(function() d:Stop() end)
                end
            end
            for _, d in ipairs(tool:GetChildren()) do
                if d:IsA("Sound") and d.Name ~= "_KyzDuelsMedusaSwingSound" then
                    if _medusaCustom.mutedSounds[d] == nil then
                        _medusaCustom.mutedSounds[d] = { Volume = d.Volume }
                    end
                    d.Volume = 0
                    pcall(function() d:Stop() end)
                end
            end
        end)
    end

    function _medusaCustomRestoreOriginalSounds()
        pcall(function()
            for snd, old in pairs(_medusaCustom.mutedSounds) do
                if snd and snd.Parent and type(old) == "table" then
                    pcall(function()
                        snd.Volume = old.Volume or 1
                    end)
                end
            end
            table.clear(_medusaCustom.mutedSounds)
        end)
    end

    function _medusaCustomPlaySwingSound(parent)
        local entry = _medusaCustomGetEntry()
        if not entry or not entry.swingSound then return end
        if not parent then return end
        local cd = tonumber(entry.soundCooldown) or 25
        if cd < 0.5 then cd = 0.5 end
        local now = os.clock()
        if (now - (_medusaCustom.lastSwingSoundAt or 0)) < cd then
            -- still mute original even if custom is on cooldown
            local tool = parent:IsA("Tool") and parent or parent.Parent
            if tool then _medusaCustomMuteOriginalSounds(tool) end
            return
        end
        _medusaCustom.lastSwingSoundAt = now
        -- kill original medusa SFX at the exact same moment
        local tool = parent:IsA("Tool") and parent or parent.Parent
        if tool then
            _medusaCustomMuteOriginalSounds(tool)
            task.defer(function()
                _medusaCustomMuteOriginalSounds(tool)
            end)
            task.delay(0.05, function()
                if _medusaCustom.enabled then _medusaCustomMuteOriginalSounds(tool) end
            end)
            task.delay(0.15, function()
                if _medusaCustom.enabled then _medusaCustomMuteOriginalSounds(tool) end
            end)
        end
        pcall(function()
            if parent then
                local oldS = parent:FindFirstChild("_KyzDuelsMedusaSwingSound")
                if oldS then pcall(function() oldS:Destroy() end) end
            end
            local s = Instance.new("Sound")
            s.Name = "_KyzDuelsMedusaSwingSound"
            s.SoundId = "rbxassetid://" .. tostring(entry.swingSound)
            s.Volume = 1
            s.PlaybackSpeed = 1
            s.RollOffMaxDistance = 120
            s.Parent = parent
            s:Play()
            s.Ended:Connect(function()
                pcall(function() s:Destroy() end)
            end)
            task.delay(30, function()
                if s and s.Parent then pcall(function() s:Destroy() end) end
            end)
        end)
    end

    function _medusaCustomHookSwing(tool)
        if not tool then return end
        local entry = _medusaCustomGetEntry()
        if not entry or not entry.swingSound then return end

        -- keep original medusa sounds muted while custom is active
        _medusaCustomMuteOriginalSounds(tool)

        -- watch for any new/playing original sounds and silence them instantly
        if not tool:GetAttribute("_KyzDuelsMedusaSoundWatch") then
            tool:SetAttribute("_KyzDuelsMedusaSoundWatch", true)
            tool.DescendantAdded:Connect(function(d)
                if not _medusaCustom.enabled then return end
                local e = _medusaCustomGetEntry()
                if not e or not e.swingSound then return end
                if d:IsA("Sound") and d.Name ~= "_KyzDuelsMedusaSwingSound" then
                    if _medusaCustom.mutedSounds[d] == nil then
                        _medusaCustom.mutedSounds[d] = { Volume = d.Volume }
                    end
                    d.Volume = 0
                    pcall(function() d:Stop() end)
                end
            end)
        end

        if tool:GetAttribute("_KyzDuelsMedusaSwingHooked") then return end
        tool:SetAttribute("_KyzDuelsMedusaSwingHooked", true)

        -- fire custom sound at the exact moment Medusa is used
        tool.Activated:Connect(function()
            if not _medusaCustom.enabled then return end
            local e = _medusaCustomGetEntry()
            if not e or not e.swingSound then return end
            _medusaCustomMuteOriginalSounds(tool)
            local handle = tool:FindFirstChild("Handle")
            if not (handle and handle:IsA("BasePart")) then
                handle = tool:FindFirstChildWhichIsA("BasePart", true)
            end
            _medusaCustomPlaySwingSound(handle or tool)
        end)
    end

    function enableSkullCustom(key)
        if not State then return end
        if type(key) == "string" and MEDUSA_CUSTOM_BY_KEY[key] then
            State.skullCustomKey = key
            _medusaCustom.currentKey = key
        end
        State.skullCustomEnabled = true
        _medusaCustom.enabled = true
        task.spawn(function()
            _medusaCustom.resolved = false
            _medusaCustom.resolvedId = nil
            if _medusaCustom.template then
                pcall(function() _medusaCustom.template:Destroy() end)
                _medusaCustom.template = nil
            end
            for attempt = 1, 10 do
                local tool = _medusaCustomGetTool()
                if tool then
                    local old = tool:FindFirstChild("_KyzDuelsMedusaCustomVisual")
                    if old then pcall(function() old:Destroy() end) end
                    if _medusaCustomResolveTemplate(true) then
                        _medusaCustomApplyToTool()
                        if tool:FindFirstChild("_KyzDuelsMedusaCustomVisual") then
                            break
                        end
                    end
                end
                task.wait(0.4)
            end
        end)
        if _medusaCustom.poll then pcall(function() _medusaCustom.poll:Disconnect() end) end
        _medusaCustom.poll = RunService.Heartbeat:Connect(function()
            if not _medusaCustom.enabled then return end
            if (tick() % 0.75) < 0.03 then
                _medusaCustomApplyToTool()
            end
        end)
    end

    function disableSkullCustom()
        if not State then return end
        State.skullCustomEnabled = false
        _medusaCustom.enabled = false
        if _medusaCustom.poll then pcall(function() _medusaCustom.poll:Disconnect() end) _medusaCustom.poll = nil end
        pcall(_medusaCustomRestoreOriginalSounds)

        local tool = _medusaCustomGetTool()
        if tool then _medusaCustomClearVisual(tool) end
        for t, _ in pairs(_medusaCustom.visuals) do
            _medusaCustomClearVisual(t)
        end
        table.clear(_medusaCustom.visuals)

        for inst, old in pairs(_medusaCustom.originals) do
            pcall(function()
                if not (inst and inst.Parent) or type(old) ~= "table" then return end
                if inst:IsA("BasePart") then
                    if old.Transparency ~= nil then inst.Transparency = old.Transparency end
                    if old.LTM ~= nil then inst.LocalTransparencyModifier = old.LTM end
                elseif inst:IsA("SpecialMesh") then
                    if old.Scale then inst.Scale = old.Scale end
                elseif inst:IsA("Decal") or inst:IsA("Texture") then
                    if old.Transparency ~= nil then inst.Transparency = old.Transparency end
                end
            end)
        end
        table.clear(_medusaCustom.originals)
    end

    noCamCollisionConn = nil
    noCamCollisionParts = {}
    _G._AmbitiousNC = _G._AmbitiousNC or {targetZoom=10, currentZoom=10, zoomConn=nil, watchConns={}, resync=true}

    function enableNoCamCollision()
        State.noCamCollisionEnabled = true
        local NC = _G._AmbitiousNC
        local cam0 = workspace.CurrentCamera
        NC.targetZoom  = math.clamp(10, LP.CameraMinZoomDistance, LP.CameraMaxZoomDistance)
        NC.currentZoom = NC.targetZoom
        NC.resync = true   -- al primo frame utile si riallinea alla camera vera

        if NC.zoomConn then NC.zoomConn:Disconnect() end
        NC.zoomConn = UIS.InputChanged:Connect(function(input, gameProcessed)
            if not State.noCamCollisionEnabled then return end
            if gameProcessed then return end
            if input.UserInputType == Enum.UserInputType.MouseWheel then
                local curMin = LP.CameraMinZoomDistance
                local curMax = LP.CameraMaxZoomDistance
                NC.targetZoom = math.clamp(NC.targetZoom - (input.Position.Z * 4), curMin, curMax)
            end
        end)

        -- WATCHER: se il gioco cambia la camera da solo (limiti di zoom, prima
        -- persona forzata, cambio di camera al respawn) si chiede un riallineamento
        -- invece di continuare a imporre il nostro zoom.
        for _, c in ipairs(NC.watchConns or {}) do pcall(function() c:Disconnect() end) end
        NC.watchConns = {}
        local function askResync() NC.resync = true end
        table.insert(NC.watchConns, LP:GetPropertyChangedSignal("CameraMinZoomDistance"):Connect(askResync))
        table.insert(NC.watchConns, LP:GetPropertyChangedSignal("CameraMaxZoomDistance"):Connect(askResync))
        table.insert(NC.watchConns, workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(askResync))
        table.insert(NC.watchConns, LP.CharacterAdded:Connect(askResync))
        if cam0 then
            table.insert(NC.watchConns, cam0:GetPropertyChangedSignal("CameraType"):Connect(askResync))
            table.insert(NC.watchConns, cam0:GetPropertyChangedSignal("CameraSubject"):Connect(askResync))
        end

        pcall(function() RunService:UnbindFromRenderStep("AmbitiousNoCamCollision") end)
        RunService:BindToRenderStep("AmbitiousNoCamCollision", Enum.RenderPriority.Camera.Value + 1, function(deltaTime)
            if not State.noCamCollisionEnabled then return end

            -- la camera si rilegge ogni frame: dopo un respawn quella vecchia e' morta
            local cam = workspace.CurrentCamera
            if not cam then return end
            if cam.CameraType == Enum.CameraType.Scriptable then NC.resync = true return end
            if cam.CameraSubject == nil then NC.resync = true return end

            local char = LP.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if not hrp then NC.resync = true return end

            local curMin = LP.CameraMinZoomDistance
            local curMax = LP.CameraMaxZoomDistance

            -- il gioco sta forzando la prima persona: non si scrive nulla, altrimenti
            -- si resta incastrati in prima persona anche dopo che la rilascia
            if curMax <= 1 then
                NC.resync = true
                return
            end

            local realZoom = (cam.CFrame.Position - cam.Focus.Position).Magnitude

            if realZoom < 0.6 then
                -- prima persona non decisa da noi: ci si adegua e si aspetta
                NC.resync = true
                return
            end

            -- Riallineamento: al primo frame buono dopo un cambio del gioco, oppure
            -- se la camera si e' allontanata piu' di quanto avessimo imposto noi
            -- (solo il gioco puo' farlo: la collisione avvicina, non allontana).
            if NC.resync or realZoom > NC.currentZoom + 0.5 then
                NC.targetZoom  = math.clamp(realZoom, curMin, curMax)
                NC.currentZoom = NC.targetZoom
                NC.resync = false
            end

            NC.targetZoom  = math.clamp(NC.targetZoom, curMin, curMax)
            NC.currentZoom = NC.currentZoom + (NC.targetZoom - NC.currentZoom) * math.min(deltaTime * 15, 1)
            cam.CFrame = cam.Focus * cam.CFrame.Rotation * CFrame.new(0, 0, NC.currentZoom)
        end)
    end

    function disableNoCamCollision()
        State.noCamCollisionEnabled = false
        pcall(function() RunService:UnbindFromRenderStep("AmbitiousNoCamCollision") end)
        if _G._AmbitiousNC.zoomConn then _G._AmbitiousNC.zoomConn:Disconnect(); _G._AmbitiousNC.zoomConn = nil end
        for _, c in ipairs(_G._AmbitiousNC.watchConns or {}) do pcall(function() c:Disconnect() end) end
        _G._AmbitiousNC.watchConns = {}
        noCamCollisionParts = {}
    end

    function applyNoCamCollision(on)
        if on then
            enableNoCamCollision()
        else
            disableNoCamCollision()
        end
    end

    -- ============================================================
    -- SHINY GRAPHICS (Vivid Graphics from Ambitious — fixed configs)
    -- Saturation 2.0 | Bloom Intensity 0.8 | Bloom Size 50
    -- Sun Rays 0.50 | DOF Focus Dist 50
    -- ============================================================
    local _shinyContrastConn = nil

    function enableShinyGraphics()
        State.shinyGraphicsEnabled = true
        for _, child in ipairs(Lighting:GetChildren()) do
            if child:GetAttribute("_KyzShiny") or child:GetAttribute("_AmbitiousVivid") then
                pcall(function() child:Destroy() end)
            end
        end
        local color = Instance.new("ColorCorrectionEffect")
        color:SetAttribute("_KyzShiny", true)
        color.Parent = Lighting
        color.Enabled = true
        color.Saturation = 2.0
        color.Contrast = 0.4
        color.Brightness = 0.05
        color.TintColor = Color3.fromRGB(255, 240, 220)

        local bloom = Instance.new("BloomEffect")
        bloom:SetAttribute("_KyzShiny", true)
        bloom.Parent = Lighting
        bloom.Enabled = true
        bloom.Intensity = 0.8
        bloom.Size = 50
        bloom.Threshold = 1

        local atmosphere = Instance.new("Atmosphere")
        atmosphere:SetAttribute("_KyzShiny", true)
        atmosphere.Parent = Lighting
        atmosphere.Density = 0.3
        atmosphere.Offset = 0.25
        atmosphere.Color = Color3.fromRGB(199, 199, 255)
        atmosphere.Decay = Color3.fromRGB(106, 112, 125)
        atmosphere.Glare = 0.2
        atmosphere.Haze = 1

        local sun = Instance.new("SunRaysEffect")
        sun:SetAttribute("_KyzShiny", true)
        sun.Parent = Lighting
        sun.Enabled = true
        sun.Intensity = 0.50
        sun.Spread = 0.8

        local dof = Instance.new("DepthOfFieldEffect")
        dof:SetAttribute("_KyzShiny", true)
        dof.Parent = Lighting
        dof.Enabled = true
        dof.FocusDistance = 50
        dof.InFocusRadius = 10
        dof.NearIntensity = 0.2
        dof.FarIntensity = 0.4

        if _shinyContrastConn then
            pcall(function() task.cancel(_shinyContrastConn) end)
            _shinyContrastConn = nil
        end
        _shinyContrastConn = task.spawn(function()
            while State and State.shinyGraphicsEnabled do
                if color and color.Parent then
                    color.Contrast = 0.35 + math.sin(tick() * 2) * 0.05
                end
                task.wait(0.03)
            end
        end)
    end

    function disableShinyGraphics()
        State.shinyGraphicsEnabled = false
        if _shinyContrastConn then
            pcall(function() task.cancel(_shinyContrastConn) end)
            _shinyContrastConn = nil
        end
        for _, child in ipairs(Lighting:GetChildren()) do
            if child:GetAttribute("_KyzShiny") or child:GetAttribute("_AmbitiousVivid") then
                pcall(function() child:Destroy() end)
            end
        end
    end

    function applyShinyGraphics(on)
        if on then enableShinyGraphics() else disableShinyGraphics() end
    end

    -- Keep Shiny Graphics alive across reset / lighting wipe
    local _shinyGuardConn = nil
    local _shinyCharConn = nil
    local _shinyReapplyBusy = false

    local function _shinyHasEffects()
        for _, child in ipairs(Lighting:GetChildren()) do
            if child:GetAttribute("_KyzShiny") then
                return true
            end
        end
        return false
    end

    local function _shinyReapplyIfNeeded()
        if not State or not State.shinyGraphicsEnabled then return end
        if _shinyReapplyBusy then return end
        if _shinyHasEffects() then return end
        _shinyReapplyBusy = true
        pcall(enableShinyGraphics)
        _shinyReapplyBusy = false
    end

    local function _startShinyGuard()
        if _shinyGuardConn then
            pcall(function() _shinyGuardConn:Disconnect() end)
            _shinyGuardConn = nil
        end
        _shinyGuardConn = Lighting.ChildRemoved:Connect(function(child)
            if not State or not State.shinyGraphicsEnabled then return end
            if child and child:GetAttribute("_KyzShiny") then
                task.defer(_shinyReapplyIfNeeded)
            end
        end)
        if not _shinyCharConn then
            _shinyCharConn = LP.CharacterAdded:Connect(function()
                if not State or not State.shinyGraphicsEnabled then return end
                task.delay(0.2, _shinyReapplyIfNeeded)
                task.delay(0.8, _shinyReapplyIfNeeded)
            end)
        end
        -- soft poll: games sometimes wipe lighting without ChildRemoved firing cleanly
        task.spawn(function()
            while true do
                task.wait(1.5)
                if State and State.shinyGraphicsEnabled then
                    pcall(_shinyReapplyIfNeeded)
                end
            end
        end)
    end
    _startShinyGuard()



    ESP = {
        Objects = {},
        Connection = nil,
    }

    ESP.removeForPlayer = function(p)
        if ESP.Objects[p] then
            pcall(function()
                d = ESP.Objects[p]
                if d.highlight and d.highlight.Parent then d.highlight:Destroy() end
                if d.box and d.box.Parent then d.box:Destroy() end
                if d.line then pcall(function() d.line:Remove() end) end
                if d.beamData then
                    pcall(function() if d.beamData.beam then d.beamData.beam:Destroy() end end)
                    pcall(function() if d.beamData.att0 then d.beamData.att0:Destroy() end end)
                    pcall(function() if d.beamData.att1 then d.beamData.att1:Destroy() end end)
                end
            end)
            ESP.Objects[p] = nil
        end
    end

    ESP.createForPlayer = function(p)
        if p == LP then return end
        ESP.removeForPlayer(p)
        char = p.Character
        if not char then return end
        hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end

        mode = State.espMode or "noLine"
        local hl, box, line = nil, nil, nil

        hl = Instance.new("Highlight")
        hl.Name = "KyzDuelsESP_HL"
        hl.Adornee = char
        hl.FillColor = Color3.fromRGB(0, 0, 0)
        hl.FillTransparency = 1
        hl.OutlineColor = Color3.fromRGB(255, 255, 255)
        hl.OutlineTransparency = 0
        hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        hl.Parent = workspace

        box = nil
        if State.espBoxEnabled then
            box = Instance.new("SelectionBox")
            box.Name = "KyzDuelsESP_Hitbox"
            box.Adornee = char
            box.LineThickness = 0.15
            box.SurfaceTransparency = 1
            box.Color3 = Color3.fromRGB(255, 255, 255)
            box.Parent = char
        end

        beamData = nil
        if mode == "withLine" then
            hasDrawing = false
            pcall(function()
                if Drawing and type(Drawing.new) == "function" then
                    line = Drawing.new("Line")
                    line.Visible = false
                    line.Color = Color3.fromRGB(255, 255, 255)
                    line.Thickness = 2
                    line.Transparency = 0.8
                    hasDrawing = true
                end
            end)
            if not hasDrawing then
                att0 = Instance.new("Attachment")
                att0.Name = "KyzDuelsESP_Att0"
                att0.Parent = hrp
                myChar = LP.Character
                myHrp = myChar and myChar:FindFirstChild("HumanoidRootPart")
                att1 = Instance.new("Attachment")
                att1.Name = "KyzDuelsESP_Att1"
                if myHrp then
                    att1.Parent = myHrp
                else
                    att1.Parent = hrp
                end
                beam = Instance.new("Beam")
                beam.Name = "KyzDuelsESP_Beam"
                beam.Attachment0 = att1
                beam.Attachment1 = att0
                beam.FaceCamera = true
                beam.Width0 = 0.15
                beam.Width1 = 0.15
                beam.Color = ColorSequence.new(Color3.fromRGB(255, 255, 255))
                beam.Transparency = NumberSequence.new(0.25)
                beam.LightEmission = 1
                beam.Segments = 1
                beam.Enabled = true
                beam.Parent = hrp
                beamData = { beam = beam, att0 = att0, att1 = att1 }
            end
        end

        ESP.Objects[p] = { highlight = hl, box = box, char = char, line = line, beamData = beamData }
    end

    ESP.start = function()
        if ESP.Connection then return end
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LP then ESP.createForPlayer(p) end
        end
        ESP.Connection = RunService.Heartbeat:Connect(function()
            if not State.espEnabled then return end
            cam = workspace.CurrentCamera
            if not cam then return end
            myChar = LP.Character
            myHrp = myChar and myChar:FindFirstChild("HumanoidRootPart")
            if not myHrp then
                for p, data in pairs(ESP.Objects) do
                    if data.line then data.line.Visible = false end
                    if data.beamData and data.beamData.beam then
                        data.beamData.beam.Enabled = false
                    end
                end
                return
            end
            closestPlayer = nil
            closestDistance = math.huge
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= LP then
                    targetChar = p.Character
                    targetHrp = targetChar and targetChar:FindFirstChild("HumanoidRootPart")
                    if targetHrp then
                        distance = (myHrp.Position - targetHrp.Position).Magnitude
                        if distance < closestDistance then
                            closestDistance = distance
                            closestPlayer = p
                        end
                    end
                end
            end
            for p, data in pairs(ESP.Objects) do
                skipRest = false
                if not p or not p.Parent then
                    ESP.removeForPlayer(p)
                    skipRest = true
                elseif p.Character ~= data.char then
                    ESP.removeForPlayer(p)
                    ESP.createForPlayer(p)
                    skipRest = true
                end
                if not skipRest then
                    if State.espMode == "withLine" and p == closestPlayer then
                        targetChar = p.Character
                        targetHrp = targetChar and targetChar:FindFirstChild("HumanoidRootPart")
                        if data.line then
                            if not targetHrp then
                                data.line.Visible = false
                            else
                                targetPoint3D = targetHrp.Position
                                local screenPoint, onScreen = cam:WorldToViewportPoint(targetPoint3D)
                                if onScreen and screenPoint.Z > 0 then
                                    data.line.Visible = true
                                    myScreenPoint = cam:WorldToViewportPoint(myHrp.Position)
                                    data.line.From = Vector2.new(myScreenPoint.X, myScreenPoint.Y)
                                    data.line.To = Vector2.new(screenPoint.X, screenPoint.Y)
                                else
                                    data.line.Visible = false
                                end
                            end
                        elseif data.beamData and data.beamData.beam then
                            if not targetHrp then
                                data.beamData.beam.Enabled = false
                            else
                                pcall(function()
                                    if data.beamData.att0 and data.beamData.att0.Parent ~= targetHrp then
                                        data.beamData.att0.Parent = targetHrp
                                    end
                                    if data.beamData.att1 and data.beamData.att1.Parent ~= myHrp then
                                        data.beamData.att1.Parent = myHrp
                                    end
                                    data.beamData.beam.Enabled = true
                                end)
                            end
                        else
                            ESP.removeForPlayer(p)
                            ESP.createForPlayer(p)
                        end
                    elseif data.line then
                        data.line.Visible = false
                    end
                    if data.beamData and data.beamData.beam and not (State.espMode == "withLine" and p == closestPlayer) then
                        data.beamData.beam.Enabled = false
                    end
                end
            end
        end)
    end

    ESP.stop = function()
        if ESP.Connection then
            ESP.Connection:Disconnect()
            ESP.Connection = nil
        end
        for p in pairs(ESP.Objects) do
            ESP.removeForPlayer(p)
        end
        ESP.Objects = {}
    end

    Players.PlayerAdded:Connect(function(p)
        p.CharacterAdded:Connect(function(char)
            task.wait(0.5)
            if State.espEnabled then ESP.createForPlayer(p) end
        end)
    end)
    Players.PlayerRemoving:Connect(function(p) ESP.removeForPlayer(p) end)

    function saveConfig()
        local cfg = {}

        -- Serialize every simple State field (bool / number / string)
        local skip = {
            lastMoveDir = true,
            autoTPConn = true,
            isStealing = true,
            stealStartTime = true,
            lastStealTick = true,
            medusaLastUsed = true,
            medusaDebounce = true,
            batCounterDebounce = true,
            hittingCooldown = true,
            countdownActive = true,
            autoLeftPhase = true, -- still saved below intentionally
            autoRightPhase = true,
        }
        for k, v in pairs(State) do
            if not skip[k] then
                local t = type(v)
                if t == "boolean" or t == "number" or t == "string" then
                    cfg[k] = v
                elseif t == "table" then
                    -- shallow-copy plain tables (gui pos, anim pack, etc.)
                    if k == "guiPosition" or k == "stealBarPosition" or k == "customAnimPack"
                        or k == "customSkins" or k == "skinGallery" then
                        cfg[k] = v
                    end
                end
            end
        end

        -- Explicit critical fields (always present even if nil-ish)
        cfg.normalSpeed = State.normalSpeed
        cfg.carrySpeed = State.carrySpeed
        cfg.laggerSpeed = State.laggerSpeed
        cfg.normalLaggerSpeed = State.normalLaggerSpeed
        cfg.laggerCarrySpeed = State.laggerCarrySpeed
        cfg.speedMode = State.speedMode
        cfg.laggerMode = State.laggerMode
        cfg.lastLaggerMode = State.lastLaggerMode
        cfg.stealRadiusNormal = State.stealRadiusNormal or 60
        cfg.stealRadius = State.stealRadiusNormal or 60
        cfg.dropEnabled = State.dropEnabled == true
        cfg.zombieAnimsEnabled = State.zombieAnimsEnabled == true
        cfg.autoLeftPhase = State.autoLeftPhase or 1
        cfg.autoRightPhase = State.autoRightPhase or 1
        cfg.syncStealRagdoll = State.syncStealRagdoll == true
        cfg.noCamCollisionEnabled = State.noCamCollisionEnabled == true
        cfg.shinyGraphicsEnabled = State.shinyGraphicsEnabled == true
        cfg.antiVoidEnabled = State.antiVoidEnabled == true
        cfg.nightModeEnabled = State.nightModeEnabled == true
        cfg.gameTheme = State.gameTheme or "Off"
        cfg.tpBatMode = (State.tpBatMode == "V2") and "V2" or "V1"
        cfg.playerPosMarker = State.playerPosMarker == true
        cfg.AimbotSpeed = tonumber(State.AimbotSpeed) or 62
        cfg.batCustomKey = State.batCustomKey or "diamond"
        cfg.skullCustomKey = State.skullCustomKey or "evil"
        cfg.dropAfterAction = State.dropAfterAction or "off"

        -- Keybinds
        if Keys then
            cfg.speedKey = Keys.speed and Keys.speed.Name or "Q"
            cfg.normalSpeedKey = Keys.normalSpeed and Keys.normalSpeed.Name or "Z"
            cfg.laggerKey = Keys.lagger and Keys.lagger.Name or "R"
            cfg.dropKey = Keys.drop and Keys.drop.Name or "H"
            cfg.tpDownKey = Keys.tpDown and Keys.tpDown.Name or "V"
            cfg.unwalkKey = Keys.unwalk and Keys.unwalk.Name or "U"
            cfg.autoLeftKey = Keys.autoLeft and Keys.autoLeft.Name or "L"
            cfg.autoRightKey = Keys.autoRight and Keys.autoRight.Name or "R"
            cfg.guiHideKey = Keys.guiHide and Keys.guiHide.Name or "LeftControl"
            cfg.instaResetKey = Keys.instaReset and Keys.instaReset.Name or "G"
            cfg.aimbotKey = Keys.aimbot and Keys.aimbot.Name or "E"
            cfg.tpBatKey = Keys.tpBat and Keys.tpBat.Name or "Y"
        end

        -- Steal helpers
        cfg.autoStealEnabled = State.autoStealEnabled == true
        cfg.autoStealMode = State.autoStealMode or "V3"
        cfg.stealDuration = Steal and Steal.StealDuration or nil
        cfg.autoGrabStopEnabled = autoGrabStopEnabled
        cfg.autoGrabStopTime = autoGrabStopTime
        cfg.autoGrabDelayRadius = autoGrabDelayRadius

        -- Intro
        cfg.introMode = tostring(_normalizeIntroMusicIndex(State.introMode or State.selectedIntroMusic or selectedIntroMusic or 1))
        cfg.selectedIntroMusic = _normalizeIntroMusicIndex(State.introMode or State.selectedIntroMusic or selectedIntroMusic or 1)
        cfg.skipIntroEnabled = State.skipIntroEnabled == true

        -- Background
        cfg.backgroundIndex = (type(backgroundIndex) == "number" and backgroundIndex) or (State.backgroundIndex or 0)

        -- Skin gallery snapshot
        cfg.skinGallery = (function()
            if type(_skinGallery) == "table" then
                return {
                    gender = _skinGallery.gender,
                    pending = _skinGallery.pending,
                    selected = _skinGallery.selected,
                    byGender = _skinGallery.byGender,
                }
            end
            if State and type(State.skinGallery) == "table" then return State.skinGallery end
            if State and type(State._pendingSkinGallery) == "table" then return State._pendingSkinGallery end
            return nil
        end)()
        cfg.customSkins = State.customSkins or {}

        -- User custom backgrounds
        cfg.bgCustom = (function()
            local arr = {}
            if type(_bgCustom) == "table" then
                for _, def in ipairs(_bgCustom) do
                    if def and def.url then
                        table.insert(arr, { url = def.url, file = def.file, rbxId = def.rbxId })
                    end
                end
            end
            return arr
        end)()

        -- User custom skins catalog
        cfg.skinCustom = (function()
            local out = { Male = {}, Female = {}, Effects = {} }
            local function packList(list)
                local arr = {}
                if type(list) ~= "table" then return arr end
                for _, it in ipairs(list) do
                    if it and it.custom and it.assetId then
                        table.insert(arr, {
                            key = it.key,
                            name = it.name,
                            assetId = tonumber(it.assetId),
                        })
                    end
                end
                return arr
            end
            if type(_skinCustom) == "table" then
                for _, g in ipairs({ "Male", "Female" }) do
                    out[g] = {}
                    local bag = _skinCustom[g]
                    if type(bag) == "table" then
                        for _, cat in ipairs({ "Head", "Hair", "Blouses", "Pants", "Accessories" }) do
                            out[g][cat] = packList(bag[cat])
                        end
                    end
                end
                out.Effects = packList(_skinCustom.Effects)
            end
            return out
        end)()

        local ok, enc = pcall(function() return HttpService:JSONEncode(cfg) end)
        if ok and enc then pcall(function() _writefile(CONFIG_FILE, enc) end) end
    end

    -- Auto-save (debounced) for all UI/state changes
    local _autoSaveQueued = false
    local _autoSaveLast = 0
    function autoSave(force)
        if force then
            pcall(saveConfig)
            _autoSaveLast = tick()
            return
        end
        if _autoSaveQueued then return end
        _autoSaveQueued = true
        task.delay(0.4, function()
            _autoSaveQueued = false
            pcall(saveConfig)
            _autoSaveLast = tick()
        end)
    end
    _G.__KyzDuelsAutoSave = autoSave

    -- background periodic autosave (safety net)
    task.spawn(function()
        while true do
            task.wait(6)
            if tick() - (_autoSaveLast or 0) > 4 then
                pcall(saveConfig)
                _autoSaveLast = tick()
            end
        end
    end)

    function loadConfig()
        has = false
        pcall(function() has = _isfile(CONFIG_FILE) end)
        if not has then return end
        local raw
        pcall(function() raw = _readfile(CONFIG_FILE) end)
        if not raw then return end
        local cfg
        local ok = pcall(function() cfg = HttpService:JSONDecode(raw) end)
        if not ok or type(cfg) ~= "table" then return end

        function setNum(dst, key, minv, maxv)
            if cfg[key] == nil then return end
            v = tonumber(cfg[key])
            if not v then return end
            if minv then v = math.max(minv, v) end
            if maxv then v = math.min(maxv, v) end
            State[dst] = v
        end
        function setBool(dst, key)
            if cfg[key] ~= nil then State[dst] = cfg[key] and true or false end
        end
        function setStr(dst, key)
            if type(cfg[key]) == "string" then State[dst] = cfg[key] end
        end

        setNum("normalSpeed", "normalSpeed", 1, 500)
        setNum("carrySpeed", "carrySpeed", 0.5, 100)
        setNum("laggerSpeed", "laggerSpeed", 0.5, 100)
        setNum("normalLaggerSpeed", "normalLaggerSpeed", 1, 500)
        setNum("laggerCarrySpeed", "laggerCarrySpeed", 0.5, 100)

        -- Extra fields (full autosave coverage)
                setNum("stealRadiusNormal", "stealRadiusNormal", 1, 500)
        if cfg.stealRadius ~= nil and cfg.stealRadiusNormal == nil then
            setNum("stealRadiusNormal", "stealRadius", 1, 500)
        end
        setBool("dropEnabled", "dropEnabled")
        setBool("zombieAnimsEnabled", "zombieAnimsEnabled")
        if cfg.autoLeftPhase ~= nil then State.autoLeftPhase = tonumber(cfg.autoLeftPhase) or State.autoLeftPhase end
        if cfg.autoRightPhase ~= nil then State.autoRightPhase = tonumber(cfg.autoRightPhase) or State.autoRightPhase end
        if cfg.stealRadiusNormal ~= nil and Steal then
            pcall(function() Steal.StealRadius = State.stealRadiusNormal end)
        end

        if cfg.speedMode ~= nil then State.speedMode = math.floor(tonumber(cfg.speedMode) or State.speedMode) end
        if cfg.laggerMode ~= nil then State.laggerMode = math.floor(tonumber(cfg.laggerMode) or State.laggerMode) end
        if cfg.lastLaggerMode ~= nil then State.lastLaggerMode = math.floor(tonumber(cfg.lastLaggerMode) or State.lastLaggerMode) end
        -- sanitize mutually exclusive speed modes
        if State.laggerMode ~= 0 and State.laggerMode ~= 1 and State.laggerMode ~= 2 then
            State.laggerMode = 0
        end
        if State.speedMode ~= 0 and State.speedMode ~= 1 then
            State.speedMode = 0
        end
        if State.laggerMode ~= 0 then
            State.speedMode = 0
        end

        setBool("batAimbotToggled", "batAimbotToggled")
        if cfg.aimbotMode == "normal" or cfg.aimbotMode == "antiBatBypass" then
            State.aimbotMode = cfg.aimbotMode
        end
        setBool("tpBatEnabled", "tpBatEnabled")
        setBool("playerPosMarker", "playerPosMarker")
        do
            local m = cfg.tpBatMode
            if m == "V1" or m == "V2" or m == "V3" then
                State.tpBatMode = m
            elseif m == "V4" then
                State.tpBatMode = "V1"
            end
        end
        setNum("HitDistance", "HitDistance", 1, 50)
        setNum("SwingCooldown", "SwingCooldown", 0.01, 2)
        setNum("AimbotSpeed", "AimbotSpeed", 1, 200)
        setBool("batCounterEnabled", "batCounterEnabled")
        setBool("autoSwingEnabled", "autoSwingEnabled")

        setBool("antiBatTpEnabled", "antiBatTpEnabled")
        if cfg.antiBatTpMode == "V1" or cfg.antiBatTpMode == "V2" or cfg.antiBatTpMode == "V3" then
            State.antiBatTpMode = cfg.antiBatTpMode
        end
        setBool("antiRagdollEnabled", "antiRagdollEnabled")
        setBool("infJumpEnabled", "infJumpEnabled")
        setBool("unwalkEnabled", "unwalkEnabled")
        setBool("noCollideEnabled", "noCollideEnabled")
        setBool("antiDieEnabled", "antiDieEnabled")
        setBool("antiFlingEnabled", "antiFlingEnabled")
        setBool("autoTPEnabled", "autoTPEnabled")
        setNum("autoTPHeight", "autoTPHeight", 1, 500)
        setBool("autoLeftEnabled", "autoLeftEnabled")
        setBool("autoRightEnabled", "autoRightEnabled")
        if cfg.dropMode ~= nil then
            dm = tonumber(cfg.dropMode)
            if dm == 0 or dm == 1 then State.dropMode = dm end
        end
        if cfg.dropAfterAction == "tpBat" or cfg.dropAfterAction == "aimbot" or cfg.dropAfterAction == "off" then
            State.dropAfterAction = cfg.dropAfterAction
        end
        setBool("autoCarrySpeedEnabled", "autoCarrySpeedEnabled")
        setBool("safeModeEnabled", "safeModeEnabled")
        setBool("kickWarningEnabled", "kickWarningEnabled")
        setBool("highPingWarnEnabled", "highPingWarnEnabled")
        do
            local idx = _normalizeIntroMusicIndex(cfg.selectedIntroMusic or cfg.introMode or State.selectedIntroMusic or State.introMode or selectedIntroMusic or 1)
            selectedIntroMusic = idx
            State.introMode = tostring(idx)
            State.selectedIntroMusic = idx
        end

        if cfg.autoStealEnabled ~= nil then
            State.autoStealEnabled = cfg.autoStealEnabled and true or false
            if Steal then Steal.AutoStealEnabled = State.autoStealEnabled end
        end
        if cfg.autoStealMode == "V1" or cfg.autoStealMode == "V2" or cfg.autoStealMode == "V3" then
            State.autoStealMode = cfg.autoStealMode
        end
        if cfg.syncStealRagdoll ~= nil then
            State.syncStealRagdoll = cfg.syncStealRagdoll and true or false
        end
        if cfg.stealRadius then
            r = tonumber(cfg.stealRadius)
            if r and r >= 5 and r <= 300 then
                State.stealRadiusNormal = r
                if Steal and State.autoStealMode ~= "V3" then
                    Steal.StealRadius = r
                end
            end
        end
        pcall(function() applyAutoStealModeConfig() end)
        if cfg.stealDuration and Steal then Steal.StealDuration = tonumber(cfg.stealDuration) or Steal.StealDuration end
        if cfg.autoGrabStopEnabled ~= nil then autoGrabStopEnabled = cfg.autoGrabStopEnabled and true or false end
        if cfg.autoGrabStopTime then autoGrabStopTime = tonumber(cfg.autoGrabStopTime) or autoGrabStopTime end
        if cfg.autoGrabDelayRadius then autoGrabDelayRadius = tonumber(cfg.autoGrabDelayRadius) or autoGrabDelayRadius end
        pcall(syncStealAliases)

        setBool("xrayEnabled", "xrayEnabled")
        setBool("antiLagEnabled", "antiLagEnabled")
        setBool("transparentMapEnabled", "transparentMapEnabled")
        setBool("batMedusaTransparent", "batMedusaTransparent")
        setBool("batMedusaRainbow", "batMedusaRainbow")
        setBool("batCustomEnabled", "batCustomEnabled")
        if cfg.batCustomKey and type(cfg.batCustomKey) == "string" then
            State.batCustomKey = cfg.batCustomKey
        end
        setBool("batNoSound", "batNoSound")
        setBool("skullCustomEnabled", "skullCustomEnabled")
        if cfg.skullCustomKey and type(cfg.skullCustomKey) == "string" then
            State.skullCustomKey = cfg.skullCustomKey
        end
        setBool("stretchRezEnabled", "stretchRezEnabled")
        setBool("fovEnabled", "fovEnabled")
        setBool("espEnabled", "espEnabled")
        if cfg.espMode == "noLine" or cfg.espMode == "withLine" then
            State.espMode = cfg.espMode
        elseif cfg.espMode == "withBox" then
            State.espBoxEnabled = true
            if State.espMode ~= "withLine" then State.espMode = "noLine" end
        end
        setBool("espBoxEnabled", "espBoxEnabled")
        setBool("tryhardAnimEnabled", "tryhardAnimEnabled")
        if cfg.tryhardAnimMode ~= nil then
            if cfg.tryhardAnimMode == "V1" or cfg.tryhardAnimMode == 0 then
                State.tryhardAnimMode = 0
            elseif cfg.tryhardAnimMode == "V2" or cfg.tryhardAnimMode == 1 then
                State.tryhardAnimMode = 1
            elseif cfg.tryhardAnimMode == "V3" or cfg.tryhardAnimMode == 2 then
                State.tryhardAnimMode = 2
            elseif cfg.tryhardAnimMode == "V4" or cfg.tryhardAnimMode == 3 then
                State.tryhardAnimMode = 3
            elseif cfg.tryhardAnimMode == "CUSTOM" or cfg.tryhardAnimMode == 4 then
                State.tryhardAnimMode = 4
            else
                tm = tonumber(cfg.tryhardAnimMode)
                if tm == 0 or tm == 1 or tm == 2 or tm == 3 or tm == 4 then State.tryhardAnimMode = tm end
            end
        end
        if type(cfg.customAnimPack) == "table" then
            State.customAnimPack = State.customAnimPack or {}
            for _, k in ipairs({ "idle", "walk", "run", "jump", "fall", "climb" }) do
                local v = tonumber(cfg.customAnimPack[k])
                State.customAnimPack[k] = (v and v > 0) and v or nil
            end
        end
        setBool("nightModeEnabled", "nightModeEnabled")
        setBool("removeAccEnabled", "removeAccEnabled")
        setBool("noCamCollisionEnabled", "noCamCollisionEnabled")
        setBool("shinyGraphicsEnabled", "shinyGraphicsEnabled")
        setBool("antiVoidEnabled", "antiVoidEnabled")
        setBool("ragdollCountdownEnabled", "ragdollCountdownEnabled")
        setBool("medusaCounterEnabled", "medusaCounterEnabled")
        setBool("antiMedusaEnabled", "antiMedusaEnabled")

        if type(cfg.gameTheme) == "string" then
            themeMap = {
                ["Desligado"] = "Off", ["Noite"] = "Night", ["Aurora"] = "Aurora",
                ["Pôr do Sol"] = "Sunset", ["Galáxia"] = "Galaxy", ["Cyber"] = "Cyber",
                ["Sakura"] = "Sakura", ["Noite Rosa"] = "Pink Night",
                ["Lua de Sangue"] = "Blood Moon", ["Amanhecer Esmeralda"] = "Emerald Dawn",
                ["Vulcânico"] = "Volcanic", ["Ártico"] = "Arctic",
                ["Oceano da Meia-Noite"] = "Midnight Ocean", ["Vaporwave"] = "Vaporwave",
                ["Tóxico"] = "Toxic", ["Eclipse Solar"] = "Solar Eclipse",
                ["Paisagem Infernal"] = "Hellscape", ["Paraíso"] = "Heaven",
                ["Tempestade"] = "Storm", ["Nascer do Sol"] = "Sunrise",
                ["Espaço Profundo"] = "Deep Space", ["Sonho Lavanda"] = "Lavender Dream",
                ["Inferno"] = "Inferno",
            }
            State.gameTheme = themeMap[cfg.gameTheme] or cfg.gameTheme
            if State.gameTheme ~= "Night" and State.gameTheme ~= "Off" then State.gameTheme = "Off" end
        end

        setBool("skinKorblox", "skinKorblox")
        setBool("skinHeadless", "skinHeadless")
        setBool("skinFireHead", "skinFireHead")
        setBool("skinHornWhite", "skinHornWhite")

        if type(cfg.skinGallery) == "table" then
            State._pendingSkinGallery = cfg.skinGallery
            State.skinGallery = cfg.skinGallery
        end
        if type(cfg.customSkins) == "table" then
            State.customSkins = cfg.customSkins
        end
        if type(cfg.skinCustom) == "table" then
            _G.__KyzDuelsPendingSkinCustom = cfg.skinCustom
        end
        if type(cfg.bgCustom) == "table" then
            _G.__KyzDuelsPendingBgCustom = cfg.bgCustom
        end

        setBool("uiLocked", "uiLocked")
        setBool("guiVisible", "guiVisible")
        setBool("skipIntroEnabled", "skipIntroEnabled")
        setBool("keyboardEnabled", "keyboardEnabled")
        setBool("customFontEnabled", "customFontEnabled")
        setStr("customFontName", "customFontName")
        setBool("customFontAuto", "customFontAuto")
        setBool("hideMobileButtons", "hideMobileButtons")
        setBool("lockMobileButtons", "lockMobileButtons")

        if type(cfg.guiPosition) == "table" then
            gp = cfg.guiPosition
            function axis(a, fallback)
                if type(a) ~= "table" then return fallback end
                return {
                    Scale = tonumber(a.Scale) or fallback.Scale,
                    Offset = tonumber(a.Offset) or fallback.Offset,
                }
            end
            State.guiPosition = {
                X = axis(gp.X, { Scale = 0, Offset = 8 }),
                Y = axis(gp.Y, { Scale = 0, Offset = 8 }),
            }
        end

        if type(cfg.stealBarPosition) == "table" then
            sp = cfg.stealBarPosition
            function axis2(a, fallback)
                if type(a) ~= "table" then return fallback end
                return {
                    Scale = tonumber(a.Scale) or fallback.Scale,
                    Offset = tonumber(a.Offset) or fallback.Offset,
                }
            end
            State.stealBarPosition = {
                X = axis2(sp.X, { Scale = 0.5, Offset = -150 }),
                Y = axis2(sp.Y, { Scale = 0, Offset = 16 }),
            }
        end

        if cfg.backgroundIndex ~= nil then
            bi = tonumber(cfg.backgroundIndex) or 0
            State.backgroundIndex = bi
            _G.__KyzDuelsPendingBG = bi
        end

        function tryKey(field, kt)
            if cfg[field] and Enum.KeyCode[cfg[field]] then
                Keys[kt] = Enum.KeyCode[cfg[field]]
            end
        end
        tryKey("speedKey", "speed")
        tryKey("normalSpeedKey", "normalSpeed")
        tryKey("laggerKey", "lagger")
        tryKey("guiHideKey", "guiHide")
        tryKey("dropKey", "drop")
        tryKey("tpDownKey", "tpDown")
        tryKey("instaResetKey", "instaReset")
        tryKey("autoLeftKey", "autoLeft")
        tryKey("autoRightKey", "autoRight")
        tryKey("aimbotKey", "aimbot")
        tryKey("tpBatKey", "tpBat")
        tryKey("antiBatTpKey", "antiBatTp")
        tryKey("unwalkKey", "unwalk")

        task.defer(function()
            if not keybindBtnRefs then return end
            for keyRef, btn in pairs(keybindBtnRefs) do
                if btn and Keys[keyRef] then
                    btn.Text = getKeyName(Keys[keyRef] or Enum.KeyCode.Unknown)
                end
            end
        end)
    end

    function startEnabledFeatures()
        char = LP.Character
        if not char then
            char = LP.CharacterAdded:Wait()
        end
        if char then
            hum = char:FindFirstChildOfClass("Humanoid") or char:WaitForChild("Humanoid", 3)
            root = char:FindFirstChild("HumanoidRootPart") or char:WaitForChild("HumanoidRootPart", 3)
        end
        if not workspace.CurrentCamera then
            pcall(function()
                workspace:GetPropertyChangedSignal("CurrentCamera"):Wait()
            end)
        end

        if State.medusaCounterEnabled and LP.Character then
            pcall(setupMedusaCounter, LP.Character)
        end
        if State.batCounterEnabled then
            pcall(startBatCounter)
        end
        if State.batAimbotToggled then
            pcall(startBatAimbot)
        end
        if type(setPlayerPosMarker) == "function" then State.playerPosMarker = false; pcall(setPlayerPosMarker, false) end
        if State.tpBatEnabled then
            pcall(startTpBat)
        end
        if State.kickWarningEnabled then
            pcall(startKickWarning)
        end
        if State.highPingWarnEnabled then
            pcall(startHighPingWarn)
        end
        -- antiBatTp removed

        if State.antiRagdollEnabled then
            pcall(startAntiRagdoll)
        end
        if State.xrayEnabled then
            pcall(enableXray)
        end
        if State.noCollideEnabled then
            pcall(startNoCollide)
        end
        if State.unwalkEnabled then
            pcall(startUnwalk)
        end
        if State.tryhardAnimEnabled then
            pcall(setCustomAnims)
        end
        if State.autoLeftEnabled then
            pcall(startAutoLeft)
        end
        if State.autoRightEnabled then
            pcall(startAutoRight)
        end
        if State.stretchRezEnabled then
            pcall(enableStretchRez)
        end
        if State.fovEnabled then
            pcall(startFov)
        end
        if State.espEnabled then
            pcall(ESP.start)
        end
        if State.skinHeadless or State.skinFireHead or State.skinHornWhite or State.skinKorblox then
            pcall(applyAllActiveSkins, LP.Character)
        end
        -- reapply full gallery pending (hair + accessories + effects)
        task.defer(function()
            task.wait(0.6)
            if _skinApplyAllPending then
                pcall(_skinApplyAllPending)
            end
        end)
        if State.noCamCollisionEnabled then
            pcall(applyNoCamCollision, true)
        end
        if State.antiLagEnabled then
            pcall(enableAntiLag)
        end
        if State.transparentMapEnabled then
            pcall(enableTransparentMap)
        end
        if State.batMedusaTransparent then
            pcall(enableBatMedusaTransparent)
        end
        if State.batMedusaRainbow then
            pcall(enableBatMedusaRainbow)
        end
        if State.batCustomEnabled then
            pcall(function() enableBatCustom(State.batCustomKey or "diamond") end)
        end
        if State.skullCustomEnabled then
            pcall(function() enableSkullCustom(State.skullCustomKey or "evil") end)
        end
        if State.autoStealEnabled then
            Steal.AutoStealEnabled = true
            task.defer(function()
                task.wait(0.8)
                pcall(restartAutoStealForMode)
            end)
        end
        if State.autoTPEnabled then
            pcall(startAutoTP)
        end
        -- keyboard removed
        if State.infJumpEnabled then
        end
        if State.autoCarrySpeedEnabled then
        end
        applyTheme()
        refreshStealBarVisible()
        pcall(function()
            c = LP.Character
            r = c and c:FindFirstChild("HumanoidRootPart")
            if r and setupSpeedVelocity then
                setupSpeedVelocity(r)
            end
            if setBoostVelocityEnabled then
                setBoostVelocityEnabled(true)
            end
        end)
    end

    loadConfig()

    task.defer(function()
        task.wait(0.5)
        if State.customFontName and State.customFontName ~= "Base" then
            pcall(applySelectedCustomFont)
            if State.customFontAuto then
                pcall(startFontAutoApply)
            end
        end
    end)

    -- Speed modes (MAY / Prodigy motor):
    --   Normal Speed        -> velocity  (normalSpeed)
    --   Carry Speed         -> CFrame    (carrySpeed)          [speedMode == 1]
    --   Lagger Mode         -> velocity  (laggerSpeed)         [laggerMode == 1]
    --   Lagger Carry        -> CFrame    (laggerCarrySpeed)    [laggerMode == 2]
    function getActiveMoveSpeed()
        local st = State or _G.State
        if not st then return 16 end
        -- exclusive priority: laggerMode > speedMode > normal
        -- laggerMode 1 = Carry Lagger  -> laggerSpeed
        -- laggerMode 2 = Normal Lagger -> normalLaggerSpeed
        -- speedMode 1  = Carry Speed   -> carrySpeed
        if st.laggerMode == 1 then
            return tonumber(st.laggerSpeed) or 29
        end
        if st.laggerMode == 2 then
            return tonumber(st.normalLaggerSpeed) or 45
        end
        if st.speedMode == 1 or st.speedToggled == true then
            return tonumber(st.carrySpeed) or 28.8
        end
        return tonumber(st.normalSpeed) or 59.5
    end

    function isCarryModeActive()
        local st = State or _G.State
        if not st then return false end
        -- Carry + Carry Lagger use CFrame (keep anim)
        return st.speedMode == 1 or st.laggerMode == 1 or st.speedToggled == true
    end

    function isHubSpeedActive()
        if State.laggerMode and State.laggerMode ~= 0 then return true end
        spd = getActiveMoveSpeed()
        return type(spd) == "number" and spd > 20
    end

    function isAirborneJumpState(hum)
        if not hum then return false end
        st = hum:GetState()
        if st == Enum.HumanoidStateType.Jumping
            or st == Enum.HumanoidStateType.Freefall
            or st == Enum.HumanoidStateType.FallingDown
            or st == Enum.HumanoidStateType.Landed then
            return true
        end
        if st == Enum.HumanoidStateType.Physics then
            local ok, mat = pcall(function() return hum.FloorMaterial end)
            if ok and mat == Enum.Material.Air then
                return true
            end
        end
        return false
    end

    function isHighOrFalling(root, hum)
        if isAirborneJumpState(hum) then return true end
        if not root then return false end
        vel = root.AssemblyLinearVelocity
        if math.abs(vel.Y) > 35 then return true end
        local ok, hit = pcall(function()
            params = RaycastParams.new()
            params.FilterType = Enum.RaycastFilterType.Exclude
            params.FilterDescendantsInstances = { LP.Character }
            return workspace:Raycast(root.Position, Vector3.new(0, -25, 0), params)
        end)
        if ok and hit == nil then
            return true
        end
        return false
    end

    Drop = {
        AUTO_OFF_DELAY = 0.1,
        TYPES = {
            STAND = "Stand Drop",
            JUMP = "Jump Drop"
        },
        currentType = nil,
        wfConns = {},
        active = false,
        ASCEND_DURATION = 0.2,
        ASCEND_SPEED = 150,
        conn = nil
    }

    KyzDuelsAnims = {
        WalkAnim  = 73718308412641,
        RunAnim   = 135515454877967,
        JumpAnim  = 78508480717326,
        FallAnim  = 78147885297412,
        SwimIdle  = 129183123083281,
        Swim      = 110657013921774,
        ClimbAnim = 129447497744818,
        Animation1= 92849173543269,
        Animation2= 132238900951109,
    }

    VampireAnims = {
        WalkAnim  = 10921326949,
        RunAnim   = 10921320299,
        JumpAnim  = 10921322186,
        FallAnim  = 10921321317,
        SwimIdle  = 10921325443,
        Swim      = 10921324408,
        ClimbAnim = 10921314188,
        Animation1= 10921315373,
        Animation2= 10921315373,
    }

    AmazonAnims = {
        WalkAnim  = 90478085024465,
        RunAnim   = 134824450619865,
        JumpAnim  = 121454505477205,
        FallAnim  = 94788218468396,
        SwimIdle  = 129126268464847,
        Swim      = 105962919001086,
        ClimbAnim = 121145883950231,
        Animation1= 98281136301627,
        Animation2= 98281136301627,
    }

    _spaceDown = false
    _lastHop = 0
    HOP_POWER = 55
    HOP_COOLDOWN = 0.05

    AP_L1     = Vector3.new(-476.47, -6.28, 92.73)
    AP_L2     = Vector3.new(-483.12, -4.95, 94.81)
    AP_L_FACE = Vector3.new(-482.25, -4.96, 92.09)
    AP_R1     = Vector3.new(-476.16, -6.52, 25.62)
    AP_R2     = Vector3.new(-483.06, -5.03, 25.48)
    AP_R_FACE = Vector3.new(-482.06, -6.93, 35.47)

    local alConn, arConn = nil, nil
    local alPhase, arPhase = 1, 1

    moveProxy = nil
    function ensureMoveProxy()
        c = LP.Character
        if not c then return nil end
        root = c:FindFirstChild("HumanoidRootPart")
        if not root then return nil end
        if moveProxy and moveProxy.Parent == c then return moveProxy end
        if moveProxy then pcall(function() moveProxy:Destroy() end) end
        moveProxy = Instance.new("Part")
        moveProxy.Name = "KyzDuels_MoveProxy"
        moveProxy.Size = Vector3.new(1, 1, 1)
        moveProxy.Transparency = 1
        moveProxy.CanCollide = false
        moveProxy.Massless = true
        moveProxy.Anchored = false
        moveProxy.Parent = c
        weld = Instance.new("WeldConstraint")
        weld.Part0 = root
        weld.Part1 = moveProxy
        weld.Parent = moveProxy
        return moveProxy
    end
    function destroyMoveProxy()
        if moveProxy then
            pcall(function() moveProxy:Destroy() end)
            moveProxy = nil
        end
    end
    function getAutoPathSpeed()
        if State.laggerMode == 1 then
            return State.laggerSpeed or 22
        elseif State.laggerMode == 2 then
            return State.normalLaggerSpeed or 45
        end
        return State.normalSpeed or 59
    end
    function isRagdollState(hum)
        if not hum then return true end
        st = hum:GetState()
        return hum.PlatformStand
            or st == Enum.HumanoidStateType.Physics
            or st == Enum.HumanoidStateType.Ragdoll
            or st == Enum.HumanoidStateType.FallingDown
    end

    function setBoostVelocityEnabled(on)
        -- always strip old movers; May.VS does not use LinearVelocity boost
        pcall(function()
            local char = LP.Character
            if not char then return end
            local root = char:FindFirstChild("HumanoidRootPart")
            if not root then return end
            local SL = _G.__KyzDuelsSpeedLV
            if SL and SL.clear then SL.clear(root) end
            for _, n in ipairs({"_RHSpeedLV", "AdaptHorizontalSpeed", "AdaptSpeedAttachment", "MuzanBoostLV"}) do
                local o = root:FindFirstChild(n)
                if o then pcall(function() o:Destroy() end) end
            end
        end)
    end

    function drivePathVelocity(hrp, hum, mv, spd)
        setBoostVelocityEnabled(false)
        vy = hrp.AssemblyLinearVelocity.Y
        vel = Vector3.new(mv.X * spd, vy, mv.Z * spd)
        if mv.Magnitude > 0.05 then
            unit = mv.Unit
            spoofedVelocity = Vector3.new(unit.X * 16, vy, unit.Z * 16)
        else
            spoofedVelocity = Vector3.new(0, vy, 0)
        end
        hrp.AssemblyLinearVelocity = vel
        proxy = ensureMoveProxy()
        if proxy then
            proxy.AssemblyLinearVelocity = vel
        end
        pcall(function()
            hum.WalkSpeed = spd
            hum:Move(mv, false)
        end)
        if bodyForce then
            bodyForce.Force = Vector3.new(0, 0, 0)
        end
    end

    InstaReset = {
        debounce = false,
        resetting = false,
        bypassAnti = false,
    }

    RESET_COOLDOWN = 0.55

    -- Fallbacks
    _G._AmbitiousWaitCharReady = _G._AmbitiousWaitCharReady or function(ch, t)
        ch = ch or LP.Character
        if not ch then return false end
        local deadline = os.clock() + (tonumber(t) or 5)
        while os.clock() < deadline do
            if not ch.Parent then return false end
            if LP.Character and LP.Character ~= ch then return false end
            if ch:FindFirstChild("Head") and ch:FindFirstChild("HumanoidRootPart") and ch:FindFirstChildOfClass("Humanoid") then
                return true
            end
            task.wait(0.05)
        end
        return false
    end
    _G._AmbitiousAntiVoidPaused = _G._AmbitiousAntiVoidPaused or false

    -- >>> ANTI VOID BEGIN
    -- ============================================================
    -- ANTI VOID
    -- Sempre attivo dall'esecuzione. Un thread per giocatore tiene 0.07s
    -- di storico dei CFrame: se in quella finestra copre 150 stud totali
    -- oppure 100 stud di sola Y, e' un teletrasporto. La posizione buona e'
    -- quella del campione piu' vecchio dello storico, e il TP viene contato
    -- solo se partiva dalla Safe Zone. Da li' in poi TP Bat, aimbot V1/V2,
    -- Bat Counter, Look At Enemy, ESP e tracker puntano al punto d'origine.
    -- ============================================================
    do
      -- Limiti di coordinate della Safe Zone
      local MAP_BOUNDS = {
        MinX = -535.7,
        MaxX = -422.0,
        MinY = -7.9,
        MaxY = 115.0,
        MinZ = -72.0,
        MaxZ = 193.3,
      }

      -- Finestra UNICA da 0.07s per tutti gli assi:
      --   150 stud di distanza totale (X/Z/Y)  oppure  100 stud di sola Y
      local TP_TOTAL   = 150
      local TP_DELTA_Y = 100
      local WINDOW     = 0.07
      -- Il fantasma non sparisce rientrando nella zona: sparisce quando il
      -- giocatore ha camminato WALK_CLEAR stud ORIZZONTALI dentro la zona.
      -- La Y e' esclusa dal conteggio: cadere o salire non lo cancella.
      local WALK_CLEAR = 15
      local STEP_MAX   = 50   -- oltre questo non e' camminata, non si accumula

      local function enabled() return _G.AmbitiousAntiVoidEnabled == true end

      local ghost   = setmetatable({}, { __mode = "k" })  -- [player] = posizione d'origine
      local ghostCF = setmetatable({}, { __mode = "k" })  -- [player] = CFrame d'origine
      local isOutOf = setmetatable({}, { __mode = "k" })  -- [player] = bool
      local tracked = setmetatable({}, { __mode = "k" })  -- [player] = true (thread gia' avviato)

      local function isWithinBounds(pos)
        if typeof(pos) ~= "Vector3" then return false end
        return pos.X >= MAP_BOUNDS.MinX and pos.X <= MAP_BOUNDS.MaxX
           and pos.Y >= MAP_BOUNDS.MinY and pos.Y <= MAP_BOUNDS.MaxY
           and pos.Z >= MAP_BOUNDS.MinZ and pos.Z <= MAP_BOUNDS.MaxZ
      end

      -- Richiamata SOLO quando un teleport viene confermato
      local function onTeleportDetected(player, originCFrame)
        isOutOf[player] = true
        ghostCF[player] = originCFrame
        ghost[player]   = originCFrame.Position
      end


      -- ============================================================
      -- RESCUE (rete di sicurezza per LP)
      -- Se LP finisce fuori dalla Safe Zone (void part assente, fling,
      -- micro-bug) viene riportato all'ultima posizione sicura a terra.
      -- Attivo solo quando Anti Void e' acceso. Cooldown zero: interviene
      -- ad ogni Heartbeat finche' LP non e' rientrato nella zona.
      -- ============================================================
      local _rescueLastSafePos = nil   -- ultima pos a terra dentro la zona
      local _rescueSpawnOrigin = nil   -- prima pos sicura rilevata all'accensione
      local _rescueLastRescue  = 0     -- os.clock() dell'ultimo rescue
      local RESCUE_COOLDOWN    = 0     -- istantaneo (come in Ambitious_2_)
      local RESCUE_UPDATE_INT  = 0.1   -- ogni quanto aggiornare il checkpoint
      local _rescueLastUpdate  = 0

      local function _rescueUpdateCheckpoint()
        local c   = LP.Character
        local hrp = c and c:FindFirstChild("HumanoidRootPart")
        local hum = c and c:FindFirstChildOfClass("Humanoid")
        if not (hrp and hum) then return end
        local now = os.clock()
        if now - _rescueLastUpdate < RESCUE_UPDATE_INT then return end
        _rescueLastUpdate = now
        local pos = hrp.Position
        if not _rescueSpawnOrigin and isWithinBounds(pos) then
          _rescueSpawnOrigin = pos
        end
        -- salva checkpoint solo se e' a terra (non in aria) e dentro la zona
        if hum.FloorMaterial ~= Enum.Material.Air and isWithinBounds(pos) then
          _rescueLastSafePos = pos
        end
      end

      local function _rescueTryRescue()
        local c   = LP.Character
        local hrp = c and c:FindFirstChild("HumanoidRootPart")
        if not (hrp and hrp.Parent) then return end
        if isWithinBounds(hrp.Position) then return end
        local now = os.clock()
        if now - _rescueLastRescue < RESCUE_COOLDOWN then return end
        _rescueLastRescue = now
        local dest = _rescueLastSafePos or _rescueSpawnOrigin
        if dest and isWithinBounds(dest) then
          pcall(function()
            hrp.AssemblyLinearVelocity  = Vector3.zero
            hrp.AssemblyAngularVelocity = Vector3.zero
            hrp.CFrame = CFrame.new(dest + Vector3.new(0, 3, 0))
          end)
        end
      end

      -- Heartbeat dedicato al rescue LP. Si registra una sola volta
      -- e controlla enabled() ogni frame: zero overhead quando spento.
      RunService.Heartbeat:Connect(function()
        if not enabled() then return end
        _rescueUpdateCheckpoint()
        _rescueTryRescue()
      end)

      -- Resetta il checkpoint al respawn di LP: la nuova vita riparte da zero
      LP.CharacterAdded:Connect(function()
        _rescueLastSafePos = nil
        _rescueSpawnOrigin = nil
        _rescueLastRescue  = 0
        _rescueLastUpdate  = 0
      end)
      -- ============================================================
      -- FINE RESCUE
      -- ============================================================

      local function trackPlayer(player)
        if player == LP then return end
        if tracked[player] then return end
        tracked[player] = true

        local history      = {}
        local walkedXZ     = 0     -- spostamento orizzontale accumulato a piedi
        local lastCheckPos = nil

        task.spawn(function()
          while player and player.Parent do
            -- Poll passivo finche' l'Anti Void e' spento: nessun overhead.
            -- Il giocatore e' gia' in tracked, quindi se viene acceso basta
            -- uscire dal poll e il ciclo attivo riparte immediatamente.
            if not enabled() then
              -- Resetta lo stato in modo che la prima rilevazione sia pulita
              isOutOf[player] = false
              history      = {}
              walkedXZ     = 0
              lastCheckPos = nil
              task.wait(0.5)
            else
              local char = player.Character
              local hrp  = char and char:FindFirstChild("HumanoidRootPart")
              local hum  = char and char:FindFirstChildOfClass("Humanoid")

              if hrp and hum and hum.Health > 0 then
                local now = tick()
                local currentCFrame = hrp.CFrame
                local currentPos = currentCFrame.Position

                if isOutOf[player] then
                  -- FASE 1: fantasma attivo, si misura solo la camminata X/Z
                  if lastCheckPos then
                    local moveVector = currentPos - lastCheckPos
                    local moveXZ = Vector3.new(moveVector.X, 0, moveVector.Z).Magnitude
                    if moveXZ < STEP_MAX and isWithinBounds(currentPos) then
                      walkedXZ = walkedXZ + moveXZ
                    end
                  end
                  lastCheckPos = currentPos

                  if walkedXZ >= WALK_CLEAR then
                    isOutOf[player] = false
                    ghost[player]   = currentPos
                    ghostCF[player] = currentCFrame
                    history      = {}
                    walkedXZ     = 0
                    lastCheckPos = nil
                  end
                else
                  -- FASE 2: nessun fantasma, si cerca il teletrasporto
                  walkedXZ     = 0
                  lastCheckPos = currentPos
                  ghost[player]   = currentPos
                  ghostCF[player] = currentCFrame

                  table.insert(history, {time = now, cframe = currentCFrame})
                  while #history > 0 and (now - history[1].time) > WINDOW do
                    table.remove(history, 1)
                  end

                  local oldest = history[1]
                  if oldest then
                    local totalDistance = (currentPos - oldest.cframe.Position).Magnitude
                    local deltaY = math.abs(currentPos.Y - oldest.cframe.Position.Y)

                    if totalDistance >= TP_TOTAL or deltaY >= TP_DELTA_Y then
                      local refCFrame = oldest.cframe
                      local refPos = refCFrame.Position
                      local studsTraveledVector = currentPos - refPos
                      local exactOriginPos = currentPos - studsTraveledVector
                      local exactCFrame = CFrame.new(exactOriginPos) * (refCFrame - refCFrame.Position)

                      if isWithinBounds(exactOriginPos) then
                        onTeleportDetected(player, exactCFrame)
                      end
                      history = {}
                    end
                  end
                end
              else
                -- morto o senza character: niente fantasma
                isOutOf[player] = false
                history      = {}
                walkedXZ     = 0
                lastCheckPos = nil
              end
              RunService.Heartbeat:Wait()
            end
          end
          tracked[player] = nil
        end)
      end

      Players.PlayerAdded:Connect(trackPlayer)

      -- I thread partono all'accensione e muoiono allo spegnimento: da spento
      -- il modulo non tiene niente in esecuzione.
      local function startAll()
        for _, plr in ipairs(Players:GetPlayers()) do trackPlayer(plr) end
      end

      local function stopAll()
        for plr in pairs(isOutOf) do isOutOf[plr] = false end
      end

      local function posFor(player, rawPos)
        if not player or not enabled() then return rawPos, false end
        if isOutOf[player] then
          local g = ghost[player]
          if g then return g, true end
        end
        return rawPos, false
      end

      -- Come sopra ma partendo da una BasePart del nemico
      local function posForPart(part, rawPos)
        if not part then return rawPos, false end
        local model = part:FindFirstAncestorOfClass("Model")
        local player = model and Players:GetPlayerFromCharacter(model)
        return posFor(player, rawPos or part.Position)
      end

      _G.AmbitiousAntiVoidEnabled = _G.AmbitiousAntiVoidEnabled == true

      -- Avvia subito un thread per ogni giocatore gia' presente.
      -- I thread fanno poll passivo se Anti Void e' spento, tracking attivo
      -- se e' acceso: nessun giocatore viene perso indipendentemente dallo stato.
      startAll()

      _G.AmbitiousAntiVoid = {
        setEnabled = function(on)
          on = on and true or false
          local was = _G.AmbitiousAntiVoidEnabled == true
          _G.AmbitiousAntiVoidEnabled = on
          if on and not was then
            -- Per sicurezza: aggiunge thread per giocatori entrati nel frattempo
            startAll()
          elseif (not on) and was then
            stopAll()
          end
        end,
        isEnabled  = function() return _G.AmbitiousAntiVoidEnabled == true end,
        bounds     = MAP_BOUNDS,
        posFor     = posFor,
        posForPart = posForPart,
        isOut      = function(player) return player and isOutOf[player] == true end,
        ghostOf    = function(player) return player and ghost[player] or nil end,
      }

      -- ---------- REPLICA ESP SULLA POSIZIONE FANTASMA ----------
      -- Al TP si congela una copia del corpo sul CFrame d'origine calcolato
      -- dal tracker, con lo stesso contorno e overhead dell'ESP. L'ESP vero
      -- viene nascosto, cosi' non lo segue nel void.
      -- NB: ghostCF e' quello dichiarato sopra dal tracker, non ridichiararlo
      -- qui o la replica leggerebbe una tabella sempre vuota.
      local replicas   = {}
      local ghostFolder = nil

      local function ensureFolder()
        if ghostFolder and ghostFolder.Parent then return ghostFolder end
        ghostFolder = Instance.new("Folder")
        ghostFolder.Name = "AmbitiousAntiVoid"
        ghostFolder.Parent = workspace
        return ghostFolder
      end

      -- Mostra o nasconde l'ESP reale del nemico
      local function setRealESP(char, visible)
        if not char then return end
        local hl = char:FindFirstChild("AmbitiousHubESP")
        if hl then pcall(function() hl.Enabled = visible end) end
        local head = char:FindFirstChild("Head")
        local tag = head and head:FindFirstChild("AmbitiousHubESPTag")
        if tag then pcall(function() tag.Enabled = visible end) end
      end

      local function clearReplica(plr)
        local r = replicas[plr]
        if r then pcall(function() r:Destroy() end) end
        replicas[plr] = nil
      end

      local function buildReplica(plr, char, cf)
        clearReplica(plr)
        -- ESP spento: non si crea niente. Il resto (TP Bat, aimbot, tracker,
        -- Look At Enemy) continua a funzionare sulla posizione fantasma.
        if not char:FindFirstChild("AmbitiousHubESP") then return end
        local ok, clone = pcall(function()
          char.Archivable = true
          return char:Clone()
        end)
        if not ok or not clone then return end

        -- Congela la copia: niente script, niente fisica, niente collisioni
        for _, d in ipairs(clone:GetDescendants()) do
          if d:IsA("Script") or d:IsA("LocalScript") or d:IsA("Humanoid") then
            pcall(function() d:Destroy() end)
          elseif d:IsA("BasePart") then
            d.Anchored   = true
            d.CanCollide = false
            d.CanQuery   = false
            d.CanTouch   = false
          end
        end
        clone.Name = "GhostReplica_" .. tostring(plr.Name)
        clone.Parent = ensureFolder()
        pcall(function() clone:PivotTo(cf) end)

        -- L'ESP e il suo overhead sono figli del personaggio, quindi la copia
        -- se li porta dietro identici e congelati sull'ultimo valore.
        local hl = clone:FindFirstChild("AmbitiousHubESP")
        if hl then pcall(function() hl.Enabled = true end) end

        local cloneHead = clone:FindFirstChild("Head")
        local tag = cloneHead and cloneHead:FindFirstChild("AmbitiousHubESPTag")
        if tag then
          pcall(function() tag.Enabled = true end)
          -- scritta VOID sotto la velocita', al posto dove stava il nome
          local box = tag:FindFirstChildOfClass("Frame") or tag
          local vl = Instance.new("TextLabel")
          vl.Name = "VoidTag"
          vl.Size = UDim2.new(1, -10, 0, 16)
          vl.Position = UDim2.new(0, 5, 0, 19)
          vl.BackgroundTransparency = 1
          vl.TextColor3 = Color3.fromRGB(255, 255, 255)
          vl.Font = Enum.Font.GothamBlack
          vl.TextSize = 16
          vl.TextStrokeTransparency = 0.4
          vl.Text = "VOID"
          vl.Parent = box
        end

        replicas[plr] = clone
      end

      -- Repliche ESP: lo stato lo tiene gia' il thread di tracciamento
      local lastMarkerTick = 0
      RunService.Heartbeat:Connect(function()
        local now = os.clock()
        if now - lastMarkerTick < 0.1 then return end
        lastMarkerTick = now

        for _, plr in ipairs(Players:GetPlayers()) do
          if plr ~= LP then
            local c   = plr.Character
            local hrp = c and c:FindFirstChild("HumanoidRootPart")
            local hum = c and c:FindFirstChildOfClass("Humanoid")
            local out = enabled() and (hrp ~= nil) and (hum ~= nil) and hum.Health > 0 and isOutOf[plr] == true
            if out and ghostCF[plr] then
              setRealESP(c, false)
              if not replicas[plr] or not replicas[plr].Parent then
                buildReplica(plr, c, ghostCF[plr])
              end
            else
              if replicas[plr] then
                clearReplica(plr)
                setRealESP(c, true)
              end
            end
          end
        end
      end)

      Players.PlayerRemoving:Connect(function(plr)
        ghost[plr] = nil
        isOutOf[plr] = nil
        ghostCF[plr] = nil
        tracked[plr] = nil
        clearReplica(plr)
      end)
    end
    -- <<< ANTI VOID END

    -- Sync State with Anti Void after module load
    if State and State.antiVoidEnabled then
        pcall(function()
            if _G.AmbitiousAntiVoid then _G.AmbitiousAntiVoid.setEnabled(true) end
        end)
    end

    _G._AmbitiousInstantResetBusy = false
    _G.AmbitiousInstantResetVersion = 2

    _G._AmbitiousWaitCharReady = _G._AmbitiousWaitCharReady or function(ch, t) end
    _G._AmbitiousAntiVoidPaused = _G._AmbitiousAntiVoidPaused or false
    local _SV_fb = {
        setAntiDieVisual = function() end,
        setAntiVoidVisual = function() end,
    }
    local _SV = _G._SV or _SV_fb

    _G._AmbitiousResetGaveUp = false
    _G._AmbitiousResetOldChar = nil
    _G._AmbitiousResetCamConn = nil
    _G._AmbitiousResetCamSaved = nil

    _G._AmbitiousDoInstantResetV2 = function()
        _G._AmbitiousResetGaveUp = false
        local character = LP.Character
        if not character then _G._AmbitiousResetGaveUp = true return end
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        local root = character:FindFirstChild("HumanoidRootPart")
        if not humanoid or not root then _G._AmbitiousResetGaveUp = true return end

        local savedPlatform = humanoid.PlatformStand
        local savedBreak    = humanoid.BreakJointsOnDeath

        local BURST, WINDOW = 500, 0.3
        local FLING = 1e9

        local function applyFling(hum, r)
            hum.BreakJointsOnDeath = true
            hum.PlatformStand = true
            hum:ChangeState(Enum.HumanoidStateType.Physics)
            r.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
            r.AssemblyLinearVelocity = Vector3.new(0, FLING, 0)
        end

        local function attempt()
            local ch = LP.Character
            if ch ~= character or not character.Parent then return false end
            local hum = ch and ch:FindFirstChildOfClass("Humanoid")
            if not hum or hum.Health <= 0 then return false end
            local r = ch:FindFirstChild("HumanoidRootPart")
            if r then pcall(applyFling, hum, r) end
            return true
        end

        local t0 = os.clock()
        for _ = 1, BURST do
            if not attempt() then return end
        end

        while (os.clock() - t0) < WINDOW do
            RunService.Heartbeat:Wait()
            if not attempt() then return end
        end

        if not character.Parent or LP.Character ~= character then return end
        if humanoid.Health <= 0 then return end

        _G._AmbitiousResetGaveUp = true
        pcall(function()
            humanoid.PlatformStand = savedPlatform
            humanoid.BreakJointsOnDeath = savedBreak
            humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
            root.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
        end)
    end

    _G._AmbitiousDoInstantResetV1 = function()
        _G._AmbitiousResetGaveUp = false
        local character = LP.Character
        if not character then _G._AmbitiousResetGaveUp = true return end
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if not humanoid then _G._AmbitiousResetGaveUp = true return end
        local originalHipHeight = humanoid.HipHeight
        local attempts, done = 0, false
        while character and character.Parent and humanoid
              and humanoid.Health > 0 and LP.Character == character
              and attempts < 40 do
            pcall(function()
                humanoid.HipHeight = 1e30
                humanoid.AutoRotate = true
                for _, part in ipairs(character:GetChildren()) do
                    if part:IsA("BasePart") then part.CanCollide = false end
                end
            end)
            if not character.Parent or humanoid.Health <= 0 or LP.Character ~= character then
                done = true
                break
            end
            attempts = attempts + 1
            task.wait(0.05)
        end
        if not done and character and character.Parent and humanoid and humanoid.Health > 0 then
            pcall(function() humanoid.Health = 0 end)
            task.wait(0.1)
            if not character.Parent or humanoid.Health <= 0 then done = true end
        end
        if not done then
            _G._AmbitiousResetGaveUp = true
            if character and character.Parent and humanoid then
                pcall(function()
                    humanoid.HipHeight = originalHipHeight
                    for _, part in ipairs(character:GetChildren()) do
                        if part:IsA("BasePart") then part.CanCollide = true end
                    end
                end)
            end
        end
    end

    _G._AmbitiousDoInstantReset = function()
        if (tonumber(_G.AmbitiousInstantResetVersion) or 1) == 2 then
            _G._AmbitiousDoInstantResetV2()
        else
            _G._AmbitiousDoInstantResetV1()
        end
    end

    _G._AmbitiousLockResetCamera = function()
        local cam = workspace.CurrentCamera
        if not cam then return end
        _G._AmbitiousUnlockResetCamera()
        _G._AmbitiousResetCamSaved = {
            cframe  = cam.CFrame,
            type    = cam.CameraType,
            subject = cam.CameraSubject,
        }
        cam.CameraType = Enum.CameraType.Scriptable
        _G._AmbitiousResetCamConn = RunService.RenderStepped:Connect(function()
            local c = workspace.CurrentCamera
            local saved = _G._AmbitiousResetCamSaved
            if not c or not saved then return end
            if c.CameraType ~= Enum.CameraType.Scriptable then
                c.CameraType = Enum.CameraType.Scriptable
            end
            c.CFrame = saved.cframe
        end)
    end

    _G._AmbitiousUnlockResetCamera = function()
        if _G._AmbitiousResetCamConn then
            pcall(function() _G._AmbitiousResetCamConn:Disconnect() end)
            _G._AmbitiousResetCamConn = nil
        end
        local saved = _G._AmbitiousResetCamSaved
        _G._AmbitiousResetCamSaved = nil
        if not saved then return end
        local cam = workspace.CurrentCamera
        if not cam then return end
        pcall(function()
            local char = LP.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            cam.CameraType = (saved.type == Enum.CameraType.Scriptable)
                and Enum.CameraType.Custom or saved.type
            cam.CameraSubject = hum or saved.subject
        end)
    end

    _G.AmbitiousInstantReset = function()
        if _G._AmbitiousInstantResetBusy then return end
        _G._AmbitiousInstantResetBusy = true
        InstaReset.resetting = true
        InstaReset.bypassAnti = true

        local wasAntiDie = (antiDieEnabled == true)
        local wasAntiVoid = (_G.AmbitiousAntiVoidEnabled == true)
        _G._AmbitiousResetOldChar = LP.Character
        _G._AmbitiousResetGaveUp = false

        if wasAntiVoid then
            _G._AmbitiousAntiVoidPaused = true
            if _G.AmbitiousAntiVoid then
                pcall(_G.AmbitiousAntiVoid.setEnabled, false)
            end
            if _SV.setAntiVoidVisual then pcall(_SV.setAntiVoidVisual, true) end
        end

        if wasAntiDie then
            pcall(stopAntiDie, true)
            antiDieEnabled = true
            if _SV.setAntiDieVisual then pcall(_SV.setAntiDieVisual, true) end
        end

        pcall(_G._AmbitiousLockResetCamera)
        task.spawn(function() pcall(_G._AmbitiousDoInstantReset) end)

        task.spawn(function()
            local oldChar = _G._AmbitiousResetOldChar
            local deadline = tick() + 25
            while tick() < deadline do
                if _G._AmbitiousResetGaveUp then break end
                local ch = LP.Character
                if ch and ch.Parent and ch ~= oldChar then
                    if _G._AmbitiousWaitCharReady then
                        pcall(_G._AmbitiousWaitCharReady, ch, 10)
                    end
                    local hum = ch:FindFirstChildOfClass("Humanoid")
                    local hrp = ch:FindFirstChild("HumanoidRootPart")
                    if hum and hrp and hum.Health > 0 then break end
                end
                task.wait(0.05)
            end
            pcall(_G._AmbitiousUnlockResetCamera)
            if wasAntiVoid then
                if _G.AmbitiousAntiVoid then
                    pcall(_G.AmbitiousAntiVoid.setEnabled, true)
                end
                _G._AmbitiousAntiVoidPaused = false
                if _SV.setAntiVoidVisual then pcall(_SV.setAntiVoidVisual, true) end
            end
        end)

        task.delay(0.5, function()
            if not wasAntiDie then
                _G._AmbitiousInstantResetBusy = false
                InstaReset.resetting = false
                InstaReset.bypassAnti = false
                return
            end
            task.spawn(function()
                local deadline = tick() + 20
                while tick() < deadline do
                    local ch = LP.Character
                    local hum = ch and ch:FindFirstChildOfClass("Humanoid")
                    if ch and ch.Parent and hum and hum.Health > 0 then break end
                    task.wait(0.1)
                end
                antiDieEnabled = false
                pcall(startAntiDie)
                if _SV.setAntiDieVisual then pcall(_SV.setAntiDieVisual, true) end
                _G._AmbitiousInstantResetBusy = false
                InstaReset.resetting = false
                InstaReset.bypassAnti = false
            end)
        end)
    end

    function StopResetSequence()
        InstaReset.debounce = false
        InstaReset.resetting = false
        InstaReset.bypassAnti = false
        _G._AmbitiousInstantResetBusy = false
        pcall(_G._AmbitiousUnlockResetCamera)
    end

    function insta_reset(force)
        if _G._AmbitiousInstantResetBusy and not force then return end
        pcall(_G.AmbitiousInstantReset)
    end

    if not _G.__KyzDuelsResetCharConn then
        _G.__KyzDuelsResetCharConn = true
        LP.CharacterAdded:Connect(function()
            StopResetSequence()
            InstaReset.debounce = false
            InstaReset.currentCharacter = nil
            InstaReset.resetSuccessful = false
            InstaReset.stopResetSequence = false
        end)
    end

    function resetCharacter(char)
        hum = char:FindFirstChildOfClass("Humanoid")
        root = char:FindFirstChild("HumanoidRootPart")
        if not hum or not root or hum.Health <= 0 then return end
        if isHubSpeedActive() or isHighOrFalling(root, hum) then
            pcall(function()
                hum.PlatformStand = false
                hum.Sit = false
                root.AssemblyAngularVelocity = Vector3.zero
            end)
            return
        end

        pcall(function()
            keepSpeed = isHubSpeedActive()
            keepVel = root.AssemblyLinearVelocity

            hum:ChangeState(Enum.HumanoidStateType.GettingUp)
            hum:ChangeState(Enum.HumanoidStateType.Running)
            
            if not keepSpeed then
                root.Velocity = Vector3.zero
                root.RotVelocity = Vector3.zero
                root.AssemblyLinearVelocity = Vector3.zero
                root.AssemblyAngularVelocity = Vector3.zero
            else
                root.AssemblyAngularVelocity = Vector3.zero
                root.AssemblyLinearVelocity = Vector3.new(keepVel.X, keepVel.Y, keepVel.Z)
            end
            
            hum.PlatformStand = false
            hum.Sit = false
            hum.AutoRotate = true
            hum.JumpPower = hum.JumpPower > 0 and hum.JumpPower or 50
            if not keepSpeed then
                hum.WalkSpeed = hum.WalkSpeed > 0 and hum.WalkSpeed or 16
            end
            
            for _, obj in ipairs(char:GetDescendants()) do
                if obj:IsA("Motor6D") then
                    obj.Enabled = true
                elseif obj:IsA("Constraint") or obj:IsA("BallSocketConstraint") or obj:IsA("HingeConstraint") then
                    obj.Enabled = true
                elseif obj:IsA("BasePart") then
                    obj.CanCollide = true
                    if not keepSpeed then
                        obj.AssemblyLinearVelocity = Vector3.zero
                        obj.AssemblyAngularVelocity = Vector3.zero
                    end
                end
            end
            
            workspace.CurrentCamera.CameraSubject = hum
            
            PM = LP.PlayerScripts:FindFirstChild("PlayerModule")
            if PM then
                CM = PM:FindFirstChild("ControlModule")
                if CM then
                    local success, module = pcall(require, CM)
                    if success and module and module.Enable then
                        module:Enable()
                    end
                end
            end
        end)
    end

    AntiRagdollConnV2 = nil
    antiRagResetCooldown = 0

    function antiRagBatBusy()
        return (State.batAimbotToggled == true) or (State.tpBatEnabled == true)
    end

    function antiRagEnableControls()
        pcall(function()
            pm = LP.PlayerScripts:FindFirstChild("PlayerModule")
            if pm then
                cm = pm:FindFirstChild("ControlModule")
                if cm then
                    local ok, m = pcall(require, cm)
                    if ok and m and m.Enable then
                        m:Enable()
                    end
                end
            end
        end)
    end

    function antiRagV2ResetChar(char)
        hum  = char:FindFirstChildOfClass("Humanoid")
        root = char:FindFirstChild("HumanoidRootPart")
        if not hum or not root or hum.Health <= 0 then return end

        pcall(function()
            hum:ChangeState(Enum.HumanoidStateType.GettingUp)
            hum:ChangeState(Enum.HumanoidStateType.Running)
            root.Velocity = Vector3.zero
            root.RotVelocity = Vector3.zero
            root.AssemblyLinearVelocity = Vector3.zero
            root.AssemblyAngularVelocity = Vector3.zero
            hum.PlatformStand = false
            hum.Sit = false
            hum.AutoRotate = true
            hum.JumpPower = hum.JumpPower > 0 and hum.JumpPower or 50

            for _, obj in ipairs(char:GetDescendants()) do
                if obj:IsA("Motor6D") then
                    obj.Enabled = true
                elseif obj:IsA("BallSocketConstraint")
                    or (obj:IsA("Attachment") and obj.Name == "RagdollAttachment") then
                    pcall(function() obj:Destroy() end)
                elseif obj:IsA("Constraint") or obj:IsA("HingeConstraint") then
                    obj.Enabled = true
                elseif obj:IsA("BasePart") and obj.Name ~= "HumanoidRootPart" then
                    obj.CanCollide = true
                end
            end

            if workspace.CurrentCamera then
                workspace.CurrentCamera.CameraSubject = hum
            end
        end)

        antiRagEnableControls()
    end

    function startAntiRagdoll()
        if AntiRagdollConnV2 then return end

        AntiRagdollConnV2 = RunService.Heartbeat:Connect(function()
            if not State.antiRagdollEnabled then return end

            char = LP.Character
            if not char then return end
            hum = char:FindFirstChildOfClass("Humanoid")
            if not hum then return end

            hasRagdollConstraints = false
            for _, obj in ipairs(char:GetDescendants()) do
                if obj:IsA("BallSocketConstraint")
                    or (obj:IsA("Attachment") and obj.Name == "RagdollAttachment") then
                    hasRagdollConstraints = true
                    break
                end
            end
            if hasRagdollConstraints then
                pcall(showRagdollCountdownUI)
                antiRagV2ResetChar(char)
                return
            end

            st = hum:GetState()
            stateRagdoll = st == Enum.HumanoidStateType.Ragdoll
                or st == Enum.HumanoidStateType.FallingDown
                or st == Enum.HumanoidStateType.Dead
                or hum.PlatformStand == true

            statePhysics = (not antiRagBatBusy()) and (st == Enum.HumanoidStateType.Physics)

            if stateRagdoll or statePhysics then
                if st == Enum.HumanoidStateType.Ragdoll
                    or st == Enum.HumanoidStateType.FallingDown
                    or hum.PlatformStand == true then
                    pcall(showRagdollCountdownUI)
                end
                antiRagV2ResetChar(char)
            end
        end)
    end

    function stopAntiRagdoll()
        if AntiRagdollConnV2 then
            AntiRagdollConnV2:Disconnect()
            AntiRagdollConnV2 = nil
        end
        antiRagResetCooldown = 0

        char = LP.Character
        if not char then return end
        hum = char:FindFirstChildOfClass("Humanoid")
        if not hum then return end
        pcall(function()
            hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, true)
            hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
            hum:SetStateEnabled(Enum.HumanoidStateType.Physics, true)
        end)
    end

    function syncDropMode()
        Drop.currentType = State.dropMode == 1 and Drop.TYPES.JUMP or Drop.TYPES.STAND
    end
    syncDropMode()

    function doAutoTPDown(force)
        char = LP.Character
        if not char then return end
        hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        hum2 = char:FindFirstChildOfClass("Humanoid")
        if not hum2 then return end
        if not force then
            if hum2.FloorMaterial ~= Enum.Material.Air then return end
            if hrp.Position.Y < (State.autoTPHeight or 20) then return end
        end
        hrp.CFrame = CFrame.new(hrp.Position.X, -7.00, hrp.Position.Z)
            * CFrame.Angles(0, select(2, hrp.CFrame:ToEulerAnglesYXZ()), 0)
        hrp.AssemblyLinearVelocity = Vector3.zero
    end

    function startAutoTP()
        if State.autoTPConn then
            pcall(function() task.cancel(State.autoTPConn) end)
            State.autoTPConn = nil
        end
        State.autoTPEnabled = true
        State.autoTPConn = task.spawn(function()
            while State.autoTPEnabled do
                task.wait(0.1)
                pcall(function() doAutoTPDown(false) end)
            end
        end)
    end

    function stopAutoTP()
        State.autoTPEnabled = false
        if State.autoTPConn then
            pcall(function() task.cancel(State.autoTPConn) end)
            State.autoTPConn = nil
        end
    end

    function runTPFloor()
        pcall(function() doAutoTPDown(true) end)
    end

    function doTpDown()
        runTPFloor()
    end

    function disableOtherCollisions()
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LP and p.Character then
                for _, part in ipairs(p.Character:GetChildren()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end
    end

    local dropBrainrotActive = false
    local DROP_ASCEND_DURATION = 0.2
    local DROP_ASCEND_SPEED = 150
    local dropActive = false
    local _wfConns = {}

    _G._jumpEnsureProxy = _G._jumpEnsureProxy or function() return nil end
    if not _G.AmbitiousRunTPDown then
        _G.AmbitiousRunTPDown = function(forceNormal)
            pcall(function() doAutoTPDown(true) end)
        end
    end

    _G.AmbitiousAfterDrop = _G.AmbitiousAfterDrop or {}
    _G.AmbitiousAfterDrop.enabled = _G.AmbitiousAfterDrop.enabled == true
    _G.AmbitiousAfterDrop.action  = _G.AmbitiousAfterDrop.action or "AIMBOT"
    _G.AmbitiousAfterDrop.THRESHOLD = 25
    _G.AmbitiousAfterDrop.SETTLE    = 0.15
    _G.AmbitiousAfterDrop.TIMEOUT   = 3

    function _G.AmbitiousAfterDrop.walkSpeed()
        local c = LP.Character
        local h = c and c:FindFirstChildOfClass("Humanoid")
        return h and h.WalkSpeed or nil
    end

    function _G.AmbitiousAfterDrop.fire()
        local act = State and State.dropAfterAction or "off"
        if act == "tpBat" then
            if State.tpBatEnabled then return end
            State.tpBatEnabled = true
            if State.batAimbotToggled then
                State.batAimbotToggled = false
                pcall(stopBatAimbot)
                if toggleRefs.aimbot then pcall(function() toggleRefs.aimbot(false, true) end) end
            end
            pcall(startTpBat)
            if toggleRefs.tpBat then pcall(function() toggleRefs.tpBat(true, true) end) end
            if kyzDuelsMobBtnRefs and kyzDuelsMobBtnRefs.tpBat then pcall(kyzDuelsMobBtnRefs.tpBat, true) end
            if kyzDuelsMobBtnRefs and kyzDuelsMobBtnRefs.aimbot then pcall(kyzDuelsMobBtnRefs.aimbot, false) end
            return
        elseif act == "aimbot" then
            if State.batAimbotToggled then return end
            State.batAimbotToggled = true
            if State.tpBatEnabled then
                State.tpBatEnabled = false
                pcall(stopTpBat)
                if toggleRefs.tpBat then pcall(function() toggleRefs.tpBat(false, true) end) end
            end
            pcall(startBatAimbot)
            if toggleRefs.aimbot then pcall(function() toggleRefs.aimbot(true, true) end) end
            if kyzDuelsMobBtnRefs and kyzDuelsMobBtnRefs.aimbot then pcall(kyzDuelsMobBtnRefs.aimbot, true) end
            if kyzDuelsMobBtnRefs and kyzDuelsMobBtnRefs.tpBat then pcall(kyzDuelsMobBtnRefs.tpBat, false) end
        end
    end

    function _G.AmbitiousAfterDrop.onDrop(isBusy, waitGround)
        local AD = _G.AmbitiousAfterDrop
        local act = State and State.dropAfterAction or "off"
        if act == "off" then return end
        local before = AD.walkSpeed()
        if not before then return end
        if before >= AD.THRESHOLD then return end
        task.spawn(function()
            local deadline = os.clock() + AD.TIMEOUT
            while os.clock() < deadline do
                if type(isBusy) ~= "function" or not isBusy() then break end
                RunService.Heartbeat:Wait()
            end
            if waitGround then
                local groundDeadline = os.clock() + AD.TIMEOUT
                while os.clock() < groundDeadline do
                    local c = LP.Character
                    local h = c and c:FindFirstChildOfClass("Humanoid")
                    if not h or h.Health <= 0 then break end
                    if h.FloorMaterial ~= Enum.Material.Air then break end
                    RunService.Heartbeat:Wait()
                end
            end
            task.wait(AD.SETTLE)
            local after = AD.walkSpeed()
            if not after then return end
            if after < AD.THRESHOLD then return end
            AD.fire()
        end)
    end

    local function runDropBrainrot()
        if dropBrainrotActive then return end
        if Drop.active then return end
        if _G.AmbitiousStopAutoTPForAction then pcall(_G.AmbitiousStopAutoTPForAction) end
        Drop.active = true
        dropBrainrotActive = true
        if State then State._dropInProgress = true end
        _G._7VYAllowVelWrite = true
        local char = LP.Character
        if not char then
            Drop.active = false; dropBrainrotActive = false
            if State then State._dropInProgress = false end
            _G._7VYAllowVelWrite = false
            return
        end
        local root = char:FindFirstChild("HumanoidRootPart")
        if not root then
            Drop.active = false; dropBrainrotActive = false
            if State then State._dropInProgress = false end
            _G._7VYAllowVelWrite = false
            return
        end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            pcall(function()
                hum.MaxHealth = math.max(hum.MaxHealth or 100, 100)
                hum.Health = hum.MaxHealth
                hum.BreakJointsOnDeath = false
                hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
            end)
        end
        if not char:FindFirstChild("K7TPBatFF") then
            pcall(function()
                local ff = Instance.new("ForceField")
                ff.Name = "K7TPBatFF"
                ff.Visible = false
                ff.Parent = char
            end)
        end
        if _G.AmbitiousAfterDrop then
            _G.AmbitiousAfterDrop.onDrop(function() return dropBrainrotActive end, true)
        end
        local startTime = tick()
        local ascendDur = DROP_ASCEND_DURATION
        local ascendSpd = DROP_ASCEND_SPEED
        local dropConn
        if Drop.conn then pcall(function() Drop.conn:Disconnect() end); Drop.conn = nil end
        dropConn = RunService.Heartbeat:Connect(function()
            local currentChar = LP.Character
            local currentRoot = currentChar and currentChar:FindFirstChild("HumanoidRootPart")
            if not currentChar or not currentRoot then
                if dropConn then dropConn:Disconnect() end
                if Drop.conn == dropConn then Drop.conn = nil end
                dropBrainrotActive = false; Drop.active = false
                if State then State._dropInProgress = false end
                _G._7VYAllowVelWrite = false
                return
            end
            if not Drop.active or not dropBrainrotActive then
                if dropConn then dropConn:Disconnect() end
                if Drop.conn == dropConn then Drop.conn = nil end
                dropBrainrotActive = false; Drop.active = false
                if State then State._dropInProgress = false end
                _G._7VYAllowVelWrite = false
                return
            end
            if tick() - startTime >= ascendDur then
                if dropConn then dropConn:Disconnect() end
                if Drop.conn == dropConn then Drop.conn = nil end
                pcall(function()
                    currentRoot.AssemblyLinearVelocity = Vector3.zero
                    currentRoot.AssemblyAngularVelocity = Vector3.zero
                end)
                if _G.AmbitiousRunTPDown then
                    pcall(_G.AmbitiousRunTPDown, true)
                else
                    pcall(function() doAutoTPDown(true) end)
                end
                task.spawn(function()
                    RunService.Heartbeat:Wait()
                    local c2 = LP.Character
                    local r2 = c2 and c2:FindFirstChild("HumanoidRootPart")
                    if not r2 then return end
                    local vel = r2.Velocity
                    r2.Velocity = vel * 10000 + Vector3.new(0, 10000, 0)
                    RunService.RenderStepped:Wait()
                    if r2 and r2.Parent then r2.Velocity = vel end
                    RunService.Stepped:Wait()
                    if r2 and r2.Parent then r2.Velocity = vel + Vector3.new(0, 0.1, 0) end
                end)
                dropBrainrotActive = false; Drop.active = false
                if State then State._dropInProgress = false end
                _G._7VYAllowVelWrite = false
                return
            end
            local proxy = _G._jumpEnsureProxy and _G._jumpEnsureProxy() or currentRoot
            if proxy then
                local curVel = proxy.Velocity
                proxy.Velocity = Vector3.new(curVel.X, ascendSpd, curVel.Z)
            else
                currentRoot.Velocity = Vector3.new(currentRoot.Velocity.X, ascendSpd, currentRoot.Velocity.Z)
            end
        end)
        Drop.conn = dropConn
    end

    local function runDropStandStill()
        if dropActive then return end
        if Drop.active then return end
        if _G.AmbitiousStopAutoTPForAction then pcall(_G.AmbitiousStopAutoTPForAction) end
        Drop.active = true
        dropActive = true
        if State then State._dropInProgress = true end
        _G._7VYAllowVelWrite = true
        local char = LP.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if not char or not root then
            Drop.active = false
            dropActive = false
            if State then State._dropInProgress = false end
            _G._7VYAllowVelWrite = false
            return
        end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            pcall(function()
                hum.MaxHealth = math.max(hum.MaxHealth or 100, 100)
                hum.Health = hum.MaxHealth
                hum.BreakJointsOnDeath = false
                hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
            end)
        end
        if not char:FindFirstChild("K7TPBatFF") then
            pcall(function()
                local ff = Instance.new("ForceField")
                ff.Name = "K7TPBatFF"
                ff.Visible = false
                ff.Parent = char
            end)
        end
        if _G.AmbitiousAfterDrop then
            _G.AmbitiousAfterDrop.onDrop(function() return dropActive end)
        end

        local colConn = RunService.Stepped:Connect(function()
            if not dropActive then return end
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= LP and p.Character then
                    for _, part in ipairs(p.Character:GetChildren()) do
                        if part:IsA("BasePart") then part.CanCollide = false end
                    end
                end
            end
        end)
        table.insert(_wfConns, colConn)
        Drop.wfConns = _wfConns

        local flingThread = coroutine.create(function()
            while dropActive do
                RunService.Heartbeat:Wait()
                local c = LP.Character
                local r = c and c:FindFirstChild("HumanoidRootPart")
                if not r then break end
                local vel = r.Velocity
                r.Velocity = vel * 10000 + Vector3.new(0, 10000, 0)
                RunService.RenderStepped:Wait()
                if r and r.Parent then r.Velocity = vel end
                RunService.Stepped:Wait()
                if r and r.Parent then r.Velocity = vel + Vector3.new(0, 0.1, 0) end
            end
        end)
        table.insert(_wfConns, flingThread)
        Drop.wfConns = _wfConns
        coroutine.resume(flingThread)

        task.delay(0.1, function()
            dropActive = false
            Drop.active = false
            if State then State._dropInProgress = false end
            _G._7VYAllowVelWrite = false
            for _, c in ipairs(_wfConns) do
                if typeof(c) == "RBXScriptConnection" then
                    pcall(function() c:Disconnect() end)
                elseif type(c) == "thread" then
                    pcall(coroutine.close, c)
                end
            end
            _wfConns = {}
            Drop.wfConns = {}
        end)
    end

    local _implRunDropBrainrot = runDropBrainrot
    local _implRunDropStandStill = runDropStandStill

    function runStandDrop()
        _implRunDropStandStill()
    end

    function runJumpDrop()
        _implRunDropBrainrot()
    end

    function applyDropAfterAction()
        local act = State and State.dropAfterAction or "off"
        if act == "tpBat" then
            State.tpBatEnabled = true
            if State.batAimbotToggled then
                State.batAimbotToggled = false
                pcall(stopBatAimbot)
                if toggleRefs.aimbot then pcall(function() toggleRefs.aimbot(false, true) end) end
            end
            pcall(startTpBat)
            if toggleRefs.tpBat then pcall(function() toggleRefs.tpBat(true, true) end) end
            if kyzDuelsMobBtnRefs and kyzDuelsMobBtnRefs.tpBat then pcall(kyzDuelsMobBtnRefs.tpBat, true) end
            if kyzDuelsMobBtnRefs and kyzDuelsMobBtnRefs.aimbot then pcall(kyzDuelsMobBtnRefs.aimbot, false) end
        elseif act == "aimbot" then
            State.batAimbotToggled = true
            if State.tpBatEnabled then
                State.tpBatEnabled = false
                pcall(stopTpBat)
                if toggleRefs.tpBat then pcall(function() toggleRefs.tpBat(false, true) end) end
            end
            pcall(startBatAimbot)
            if toggleRefs.aimbot then pcall(function() toggleRefs.aimbot(true, true) end) end
            if kyzDuelsMobBtnRefs and kyzDuelsMobBtnRefs.aimbot then pcall(kyzDuelsMobBtnRefs.aimbot, true) end
            if kyzDuelsMobBtnRefs and kyzDuelsMobBtnRefs.tpBat then pcall(kyzDuelsMobBtnRefs.tpBat, false) end
        end
    end

    function runSelectedDrop()
        if State.dropMode == 1 then
            runJumpDrop()
        else
            runStandDrop()
        end
        task.delay(0.55, function()
            if State and State.dropAfterAction and State.dropAfterAction ~= "off" then
                local AD = _G.AmbitiousAfterDrop
                local ws = AD and AD.walkSpeed()
                if ws and ws < 25 then return end
                pcall(applyDropAfterAction)
            end
        end)
    end

    function stopDrop()
        Drop.active = false
        dropActive = false
        dropBrainrotActive = false
        if State then State._dropInProgress = false end
        _G._7VYAllowVelWrite = false
        if Drop.conn then Drop.conn:Disconnect(); Drop.conn = nil end
        for _, conn in ipairs(_wfConns) do
            if typeof(conn) == "RBXScriptConnection" then conn:Disconnect()
            elseif type(conn) == "thread" then pcall(coroutine.close, conn) end
        end
        _wfConns = {}
        Drop.wfConns = {}
    end

    runDropBrainrot = runSelectedDrop

    function startNoCollide()
        if Conns.noCollideLoop then return end
        Conns.noCollideLoop = RunService.Stepped:Connect(function()
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LP and player.Character then
                    for _, part in ipairs(player.Character:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                        end
                    end
                end
            end
        end)
    end

    function stopNoCollide()
        if Conns.noCollideLoop then
            Conns.noCollideLoop:Disconnect()
            Conns.noCollideLoop = nil
        end
    end

    _unwalkAnimations={}
    function _disableAnimations()
        char=LP.Character; if not char then return end
        hum2=char:FindFirstChildOfClass("Humanoid"); if not hum2 then return end
        for _,track in pairs(_unwalkAnimations) do pcall(function() track:Stop() end) end
        _unwalkAnimations={}
        animator=hum2:FindFirstChildOfClass("Animator")
        if animator then for _,track in pairs(animator:GetPlayingAnimationTracks()) do track:Stop(); table.insert(_unwalkAnimations,track) end end
    end
    function startUnwalk()
        _disableAnimations()
        if Conns.unwalk then Conns.unwalk:Disconnect() end
        Conns.unwalk=RunService.Heartbeat:Connect(function() if State.unwalkEnabled then _disableAnimations() end end)
    end
    function stopUnwalk()
        if Conns.unwalk then Conns.unwalk:Disconnect(); Conns.unwalk=nil end; _unwalkAnimations={}
    end

    function openKyzDuelsCustomAnimation()
        pcall(function()
            local old = CoreGui:FindFirstChild("KyzDuelsCustomAnimLayer")
            if old then old:Destroy() end
        end)
        pcall(function()
            local pg = LP:FindFirstChild("PlayerGui")
            if pg then
                local o = pg:FindFirstChild("KyzDuelsCustomAnimLayer")
                if o then o:Destroy() end
            end
        end)

        State.customAnimPack = State.customAnimPack or {
            idle = nil, walk = nil, run = nil, jump = nil, fall = nil, climb = nil,
        }

        local modalGui = Instance.new("ScreenGui")
        modalGui.Name = "KyzDuelsCustomAnimLayer"
        modalGui.ResetOnSpawn = false
        modalGui.IgnoreGuiInset = true
        modalGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        modalGui.DisplayOrder = 1000
        parentGui(modalGui)

        local overlay = Instance.new("TextButton")
        overlay.Name = "Overlay"
        overlay.Size = UDim2.fromScale(1, 1)
        overlay.BackgroundColor3 = Color3.fromRGB(2, 3, 8)
        overlay.BackgroundTransparency = 0.4
        overlay.BorderSizePixel = 0
        overlay.Text = ""
        overlay.AutoButtonColor = false
        overlay.ZIndex = 100
        overlay.Parent = modalGui

        local popup = Instance.new("CanvasGroup")
        popup.Name = "CustomAnimPanel"
        popup.AnchorPoint = Vector2.new(0.5, 0.5)
        popup.Position = UDim2.fromScale(0.5, 0.5)
        popup.Size = UDim2.fromOffset(isMobileDevice and 300 or 360, isMobileDevice and 360 or 400)
        popup.BackgroundColor3 = Color3.fromRGB(10, 10, 14)
        popup.BackgroundTransparency = 1
        popup.BorderSizePixel = 0
        popup.ClipsDescendants = true
        popup.GroupTransparency = 0
        popup.ZIndex = 101
        popup.Parent = overlay
        Instance.new("UICorner", popup).CornerRadius = UDim.new(0, 18)

        local BORDER_PX = 8
        local BORDER_URL = "https://happy-image-link.lovable.app/api/public/f/kx7m2a112.png"
        local BORDER_FILE = "kyzDuels_panel_border.png"

        local panelBorderImg = Instance.new("ImageLabel", popup)
        panelBorderImg.Name = "PanelBorderImage"
        panelBorderImg.Size = UDim2.fromScale(1, 1)
        panelBorderImg.BackgroundTransparency = 1
        panelBorderImg.BorderSizePixel = 0
        panelBorderImg.Image = BORDER_URL
        panelBorderImg.ScaleType = Enum.ScaleType.Crop
        panelBorderImg.ImageTransparency = 0.05
        panelBorderImg.ZIndex = 101
        Instance.new("UICorner", panelBorderImg).CornerRadius = UDim.new(0, 18)

        task.spawn(function()
            local asset = ""
            pcall(function()
                if writefile and (game.HttpGet or HttpGet) then
                    local need = true
                    pcall(function()
                        if isfile and isfile(BORDER_FILE) then need = false end
                    end)
                    if need then
                        local data = (_G.__KyzDuelsHttpGet and _G.__KyzDuelsHttpGet(BORDER_URL, true))
                            or (game.HttpGet and game:HttpGet(BORDER_URL, true))
                            or (HttpGet and HttpGet(BORDER_URL))
                        if data then writefile(BORDER_FILE, data) end
                    end
                end
            end)
            pcall(function()
                if getcustomasset and isfile and isfile(BORDER_FILE) then
                    asset = getcustomasset(BORDER_FILE)
                end
            end)
            if asset == "" then asset = BORDER_URL end
            if panelBorderImg and panelBorderImg.Parent then
                panelBorderImg.Image = asset
                panelBorderImg.ImageTransparency = 0.05
            end
        end)

        local panelInner = Instance.new("Frame", popup)
        panelInner.Name = "PanelInnerFill"
        panelInner.Position = UDim2.fromOffset(BORDER_PX, BORDER_PX)
        panelInner.Size = UDim2.new(1, -BORDER_PX * 2, 1, -BORDER_PX * 2)
        panelInner.BackgroundColor3 = Color3.fromRGB(12, 12, 16)
        panelInner.BackgroundTransparency = 0.05
        panelInner.BorderSizePixel = 0
        panelInner.ZIndex = 102
        Instance.new("UICorner", panelInner).CornerRadius = UDim.new(0, 12)

        -- if hub has custom background image, mirror it inside the panel
        pcall(function()
            if backgroundIndex and backgroundIndex > 0 and type(getBgAsset) == "function" then
                local src = getBgAsset(backgroundIndex)
                if src and src ~= "" then
                    local bgFill = Instance.new("ImageLabel", panelInner)
                    bgFill.Name = "BgMirror"
                    bgFill.Size = UDim2.fromScale(1, 1)
                    bgFill.BackgroundTransparency = 1
                    bgFill.Image = src
                    bgFill.ScaleType = Enum.ScaleType.Crop
                    bgFill.ImageTransparency = 0.35
                    bgFill.ZIndex = 102
                    Instance.new("UICorner", bgFill).CornerRadius = UDim.new(0, 12)
                end
            end
        end)

        local popupStroke = Instance.new("UIStroke", popup)
        popupStroke.Color = Color3.fromRGB(210, 210, 220)
        popupStroke.Thickness = 1.2
        popupStroke.Transparency = 0.3

        local title = Instance.new("TextLabel")
        title.Size = UDim2.new(1, -56, 0, 28)
        title.Position = UDim2.new(0, 18, 0, 14)
        title.BackgroundTransparency = 1
        title.Text = "KYZ DUELS CUSTOM ANIMATION"
        title.TextColor3 = Color3.fromRGB(245, 245, 250)
        title.Font = Enum.Font.GothamBlack
        title.TextSize = isMobileDevice and 13 or 15
        title.TextXAlignment = Enum.TextXAlignment.Left
        title.ZIndex = 110
        title.Parent = panelInner

        local closeBtn = Instance.new("TextButton")
        closeBtn.Size = UDim2.fromOffset(28, 28)
        closeBtn.Position = UDim2.new(1, -40, 0, 10)
        closeBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 34)
        closeBtn.BorderSizePixel = 0
        closeBtn.Text = "X"
        closeBtn.TextColor3 = Color3.fromRGB(220, 220, 230)
        closeBtn.Font = Enum.Font.GothamBold
        closeBtn.TextSize = 13
        closeBtn.AutoButtonColor = false
        closeBtn.ZIndex = 110
        closeBtn.Parent = panelInner
        Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(1, 0)

        local grid = Instance.new("Frame")
        grid.Size = UDim2.new(1, -16, 1, -56)
        grid.Position = UDim2.new(0, 8, 0, 48)
        grid.BackgroundTransparency = 1
        grid.ZIndex = 105
        grid.Parent = panelInner

        local lay = Instance.new("UIGridLayout", grid)
        lay.CellSize = UDim2.fromOffset(isMobileDevice and 126 or 150, isMobileDevice and 70 or 78)
        lay.CellPadding = UDim2.fromOffset(10, 10)
        lay.FillDirection = Enum.FillDirection.Horizontal
        lay.HorizontalAlignment = Enum.HorizontalAlignment.Center
        lay.SortOrder = Enum.SortOrder.LayoutOrder

        local slots = {
            { key = "idle",  label = "IDLE" },
            { key = "walk",  label = "WALK" },
            { key = "run",   label = "RUN" },
            { key = "jump",  label = "JUMP" },
            { key = "fall",  label = "FALL" },
            { key = "climb", label = "CLIMB" },
        }

        local function openIdPrompt(slotKey, slotLabel, cardLbl)
            pcall(function()
                local old = panelInner:FindFirstChild("AnimIdPrompt")
                if old then old:Destroy() end
            end)
            local prompt = Instance.new("Frame")
            prompt.Name = "AnimIdPrompt"
            prompt.AnchorPoint = Vector2.new(0.5, 0.5)
            prompt.Position = UDim2.fromScale(0.5, 0.5)
            prompt.Size = UDim2.fromOffset(isMobileDevice and 250 or 280, 150)
            prompt.BackgroundColor3 = Color3.fromRGB(14, 14, 18)
            prompt.BorderSizePixel = 0
            prompt.ZIndex = 200
            prompt.Parent = panelInner
            Instance.new("UICorner", prompt).CornerRadius = UDim.new(0, 12)
            local ppst = Instance.new("UIStroke", prompt)
            ppst.Color = Color3.fromRGB(210, 210, 220)
            ppst.Thickness = 1.2
            ppst.Transparency = 0.35

            local pTitle = Instance.new("TextLabel")
            pTitle.Size = UDim2.new(1, -48, 0, 22)
            pTitle.Position = UDim2.new(0, 12, 0, 10)
            pTitle.BackgroundTransparency = 1
            pTitle.Text = "ASSET ID — " .. slotLabel
            pTitle.TextColor3 = Color3.fromRGB(235, 235, 245)
            pTitle.Font = Enum.Font.GothamBold
            pTitle.TextSize = 12
            pTitle.TextXAlignment = Enum.TextXAlignment.Left
            pTitle.ZIndex = 201
            pTitle.Parent = prompt

            local clearBtn = Instance.new("TextButton")
            clearBtn.Size = UDim2.fromOffset(26, 26)
            clearBtn.Position = UDim2.new(1, -36, 0, 8)
            clearBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 34)
            clearBtn.BorderSizePixel = 0
            clearBtn.Text = "—"
            clearBtn.TextColor3 = Color3.fromRGB(200, 200, 210)
            clearBtn.Font = Enum.Font.GothamBold
            clearBtn.TextSize = 14
            clearBtn.AutoButtonColor = false
            clearBtn.ZIndex = 201
            clearBtn.Parent = prompt
            Instance.new("UICorner", clearBtn).CornerRadius = UDim.new(1, 0)

            local idBox = Instance.new("TextBox")
            idBox.Size = UDim2.new(1, -24, 0, 34)
            idBox.Position = UDim2.new(0, 12, 0, 44)
            idBox.BackgroundColor3 = Color3.fromRGB(10, 10, 14)
            idBox.BorderSizePixel = 0
            idBox.PlaceholderText = "Insert The Asset ID"
            idBox.Text = State.customAnimPack[slotKey] and tostring(State.customAnimPack[slotKey]) or ""
            idBox.TextColor3 = Color3.fromRGB(240, 240, 250)
            idBox.PlaceholderColor3 = Color3.fromRGB(100, 100, 120)
            idBox.Font = Enum.Font.GothamMedium
            idBox.TextSize = 13
            idBox.ClearTextOnFocus = false
            idBox.ZIndex = 201
            idBox.Parent = prompt
            Instance.new("UICorner", idBox).CornerRadius = UDim.new(0, 8)
            local idPad = Instance.new("UIPadding", idBox)
            idPad.PaddingLeft = UDim.new(0, 10)

            local confirm = Instance.new("TextButton")
            confirm.Size = UDim2.new(1, -24, 0, 34)
            confirm.Position = UDim2.new(0, 12, 1, -46)
            confirm.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
            confirm.BorderSizePixel = 0
            confirm.Text = "CONFIRM"
            confirm.TextColor3 = Color3.fromRGB(240, 240, 245)
            confirm.Font = Enum.Font.GothamBlack
            confirm.TextSize = 13
            confirm.AutoButtonColor = false
            confirm.ZIndex = 201
            confirm.Parent = prompt
            Instance.new("UICorner", confirm).CornerRadius = UDim.new(0, 9)
            local cst = Instance.new("UIStroke", confirm)
            cst.Color = Color3.fromRGB(80, 80, 90)
            cst.Thickness = 1

            clearBtn.MouseButton1Click:Connect(function()
                State.customAnimPack[slotKey] = nil
                if cardLbl then cardLbl.Text = "+  ADD" end
                pcall(function() prompt:Destroy() end)
                task.spawn(saveConfig)
                if State.tryhardAnimEnabled and State.tryhardAnimMode == 4 then
                    pcall(setCustomAnims)
                end
            end)

            confirm.MouseButton1Click:Connect(function()
                local raw = tostring(idBox.Text or ""):gsub("%s+", "")
                local id = tonumber(raw)
                if not id or id <= 0 then
                    idBox.Text = ""
                    idBox.PlaceholderText = "Invalid ID"
                    return
                end
                State.customAnimPack[slotKey] = id
                if cardLbl then cardLbl.Text = tostring(id) end
                pcall(function() prompt:Destroy() end)
                task.spawn(saveConfig)
                if State.tryhardAnimEnabled and State.tryhardAnimMode == 4 then
                    pcall(setCustomAnims)
                end
            end)

            task.defer(function()
                pcall(function() idBox:CaptureFocus() end)
            end)
        end

        for i, slot in ipairs(slots) do
            local card = Instance.new("TextButton")
            card.Name = "Slot_" .. slot.key
            card.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
            card.BackgroundTransparency = 0.15
            card.BorderSizePixel = 0
            card.Text = ""
            card.AutoButtonColor = false
            card.LayoutOrder = i
            card.ZIndex = 106
            card.Parent = grid
            Instance.new("UICorner", card).CornerRadius = UDim.new(0, 12)
            local cst = Instance.new("UIStroke", card)
            cst.Color = Color3.fromRGB(55, 55, 65)
            cst.Thickness = 1.2
            cst.Transparency = 0.35

            local lbl = Instance.new("TextLabel")
            lbl.Size = UDim2.new(1, -12, 0, 16)
            lbl.Position = UDim2.new(0, 8, 0, 8)
            lbl.BackgroundTransparency = 1
            lbl.Text = slot.label
            lbl.TextColor3 = Color3.fromRGB(200, 200, 210)
            lbl.Font = Enum.Font.GothamBold
            lbl.TextSize = 11
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.ZIndex = 107
            lbl.Parent = card

            local addLbl = Instance.new("TextLabel")
            addLbl.Name = "AddLbl"
            addLbl.Size = UDim2.new(1, -12, 0, 18)
            addLbl.Position = UDim2.new(0, 8, 1, -28)
            addLbl.BackgroundTransparency = 1
            local cur = State.customAnimPack[slot.key]
            addLbl.Text = (cur and tostring(cur)) or "+  ADD"
            addLbl.TextColor3 = Color3.fromRGB(170, 175, 190)
            addLbl.Font = Enum.Font.GothamMedium
            addLbl.TextSize = 12
            addLbl.TextXAlignment = Enum.TextXAlignment.Left
            addLbl.ZIndex = 107
            addLbl.Parent = card

            card.MouseButton1Click:Connect(function()
                openIdPrompt(slot.key, slot.label, addLbl)
            end)
        end

        local function closeAll()
            pcall(function() modalGui:Destroy() end)
        end
        closeBtn.MouseButton1Click:Connect(closeAll)
        overlay.MouseButton1Click:Connect(closeAll)
    end

    function setCustomAnims()
        char = LP.Character or LP.CharacterAdded:Wait()
        local animate
        mode = State.tryhardAnimMode or 0

        for _ = 1, 40 do
            animate = char:FindFirstChild("Animate")
            if animate and animate:FindFirstChild("run") and animate:FindFirstChild("walk") then break end
            task.wait(0.1)
        end
        if not animate then return end

        function setAnim(folder, childName, id)
            if not folder then return end
            for _, child in ipairs(folder:GetChildren()) do
                if child:IsA("Animation") then child:Destroy() end
            end
            a = Instance.new("Animation")
            a.Name = childName
            a.AnimationId = "rbxassetid://" .. tostring(id)
            a.Parent = folder
        end

        if State.tryhardAnimEnabled then
            if mode == 1 then
                setAnim(animate:FindFirstChild("run"),  "RunAnim",  KyzDuelsAnims.RunAnim)
                setAnim(animate:FindFirstChild("jump"), "JumpAnim", KyzDuelsAnims.JumpAnim)
                setAnim(animate:FindFirstChild("walk"), "WalkAnim", KyzDuelsAnims.WalkAnim)
                setAnim(animate:FindFirstChild("fall"), "FallAnim", KyzDuelsAnims.FallAnim)
                setAnim(animate:FindFirstChild("climb"), "ClimbAnim", KyzDuelsAnims.ClimbAnim)
                setAnim(animate:FindFirstChild("swim"), "Swim", KyzDuelsAnims.Swim)
                setAnim(animate:FindFirstChild("swimidle"), "SwimIdle", KyzDuelsAnims.SwimIdle)

                idleFolder = animate:FindFirstChild("idle")
                setAnim(idleFolder, "Animation1", KyzDuelsAnims.Animation1)
                setAnim(idleFolder, "Animation2", KyzDuelsAnims.Animation2)
            elseif mode == 2 then
                setAnim(animate:FindFirstChild("run"),  "RunAnim",  VampireAnims.RunAnim)
                setAnim(animate:FindFirstChild("jump"), "JumpAnim", VampireAnims.JumpAnim)
                setAnim(animate:FindFirstChild("walk"), "WalkAnim", VampireAnims.WalkAnim)
                setAnim(animate:FindFirstChild("fall"), "FallAnim", VampireAnims.FallAnim)
                setAnim(animate:FindFirstChild("climb"), "ClimbAnim", VampireAnims.ClimbAnim)
                setAnim(animate:FindFirstChild("swim"), "Swim", VampireAnims.Swim)
                setAnim(animate:FindFirstChild("swimidle"), "SwimIdle", VampireAnims.SwimIdle)

                idleFolder = animate:FindFirstChild("idle")
                setAnim(idleFolder, "Animation1", VampireAnims.Animation1)
                setAnim(idleFolder, "Animation2", VampireAnims.Animation2)
            elseif mode == 3 then
                setAnim(animate:FindFirstChild("run"),  "RunAnim",  AmazonAnims.RunAnim)
                setAnim(animate:FindFirstChild("jump"), "JumpAnim", AmazonAnims.JumpAnim)
                setAnim(animate:FindFirstChild("walk"), "WalkAnim", AmazonAnims.WalkAnim)
                setAnim(animate:FindFirstChild("fall"), "FallAnim", AmazonAnims.FallAnim)
                setAnim(animate:FindFirstChild("climb"), "ClimbAnim", AmazonAnims.ClimbAnim)
                setAnim(animate:FindFirstChild("swim"), "Swim", AmazonAnims.Swim)
                setAnim(animate:FindFirstChild("swimidle"), "SwimIdle", AmazonAnims.SwimIdle)

                idleFolder = animate:FindFirstChild("idle")
                setAnim(idleFolder, "Animation1", AmazonAnims.Animation1)
                setAnim(idleFolder, "Animation2", AmazonAnims.Animation2)
            elseif mode == 4 then
                -- CUSTOM pack (user rbx ids)
                local pack = State.customAnimPack or {}
                local function idOr(v, fallback)
                    local n = tonumber(v)
                    if n and n > 0 then return n end
                    return fallback
                end
                setAnim(animate:FindFirstChild("run"),  "RunAnim",  idOr(pack.run, 507767714))
                setAnim(animate:FindFirstChild("jump"), "JumpAnim", idOr(pack.jump, 507765049))
                setAnim(animate:FindFirstChild("walk"), "WalkAnim", idOr(pack.walk, 507777826))
                setAnim(animate:FindFirstChild("fall"), "FallAnim", idOr(pack.fall, 507767968))
                setAnim(animate:FindFirstChild("climb"), "ClimbAnim", idOr(pack.climb, 507765644))
                setAnim(animate:FindFirstChild("swim"), "Swim", 507784897)
                setAnim(animate:FindFirstChild("swimidle"), "SwimIdle", 507785072)

                idleFolder = animate:FindFirstChild("idle")
                local idleId = idOr(pack.idle, 507766388)
                setAnim(idleFolder, "Animation1", idleId)
                setAnim(idleFolder, "Animation2", idleId)
            else
                setAnim(animate:FindFirstChild("run"),  "RunAnim",  616163682)
                setAnim(animate:FindFirstChild("jump"), "JumpAnim", 116936326516985)
                setAnim(animate:FindFirstChild("walk"), "WalkAnim", 109168724482748)
                setAnim(animate:FindFirstChild("fall"), "FallAnim", 92294537340807)
                setAnim(animate:FindFirstChild("climb"), "ClimbAnim", 507765644)
                setAnim(animate:FindFirstChild("swim"), "Swim", 507784897)
                setAnim(animate:FindFirstChild("swimidle"), "SwimIdle", 507785072)

                idleFolder = animate:FindFirstChild("idle")
                setAnim(idleFolder, "Animation1", 133806214992291)
                setAnim(idleFolder, "Animation2", 94970088341563)
            end
        else
            setAnim(animate:FindFirstChild("run"),  "RunAnim",  507767714)
            setAnim(animate:FindFirstChild("jump"), "JumpAnim", 507765049)
            setAnim(animate:FindFirstChild("walk"), "WalkAnim", 507777826)
            setAnim(animate:FindFirstChild("fall"), "FallAnim", 507767968)
            setAnim(animate:FindFirstChild("climb"), "ClimbAnim", 507765644)
            setAnim(animate:FindFirstChild("swim"), "Swim", 507784897)
            setAnim(animate:FindFirstChild("swimidle"), "SwimIdle", 507785072)

            idleFolder = animate:FindFirstChild("idle")
            setAnim(idleFolder, "Animation1", 507766388)
            setAnim(idleFolder, "Animation2", 507766666)
        end

        animate.Disabled = true
        task.wait(0.06)
        animate.Disabled = false

        hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            pcall(function()
                hum:ChangeState(Enum.HumanoidStateType.Landed)
                task.wait(0.03)
                hum:ChangeState(Enum.HumanoidStateType.Running)
            end)
        end
    end

    InfJumpState = { enabled = false, mode = "hold" }
    _lastInfJump = 0
    _gamepadBtnHeld = false
    _activeTouches = {}
    _lastTouchStart = nil
    _holdTouch = nil
    _infJumpLV = nil
    _infJumpAtt = nil
    _jumpWasHeld = false

    function _clearInfJumpForce()
        -- only strip constraints; leave natural Y velocity (no mid-air snap)
        _infJumpLV = nil
        _infJumpAtt = nil
        pcall(function()
            local c = LP and LP.Character
            local root = c and c:FindFirstChild("HumanoidRootPart")
            if root then
                for _, ch in ipairs(root:GetChildren()) do
                    if ch.Name == "InfJumpVelocity" or ch.Name == "InfJumpAttachment" then
                        pcall(function() ch:Destroy() end)
                    end
                end
            end
        end)
    end

    function applyInfImpulse(root, hum, yVel)
        if not root then return end
        local targetY = yVel or 50
        -- Y-only boost: never lock X/Z so May.VS speed / WASD still work mid-air
        pcall(function()
            -- strip any leftover full-axis InfJumpVelocity that blocks movement
            for _, ch in ipairs(root:GetChildren()) do
                if ch.Name == "InfJumpVelocity" or ch.Name == "InfJumpAttachment" then
                    pcall(function() ch:Destroy() end)
                end
            end
            local v = root.AssemblyLinearVelocity
            root.AssemblyLinearVelocity = Vector3.new(v.X, targetY, v.Z)
            pcall(function()
                root.Velocity = Vector3.new(root.Velocity.X, targetY, root.Velocity.Z)
            end)
        end)
        _infJumpLV = nil
        _infJumpAtt = nil
    end

    function _doInfJump()
        local now = os.clock()
        if now - _lastInfJump < 0.12 then return end
        _lastInfJump = now
        local c = LP.Character
        if not c then return end
        local hum = c:FindFirstChildOfClass("Humanoid")
        if not hum or hum.Health <= 0 then return end
        local root = c:FindFirstChild("HumanoidRootPart")
        if not root then return end
        hum.Jump = true
        applyInfImpulse(root, hum, 50)
    end

    function applyJumpBoost()
        if not State.infJumpEnabled then return end
        _doInfJump()
    end

    function startInfJump()
        InfJumpState.enabled = true
        State.infJumpEnabled = true
    end

    function stopInfJump()
        InfJumpState.enabled = false
        State.infJumpEnabled = false
        _spaceDown = false
        _gamepadBtnHeld = false
        _holdTouch = nil
        _jumpWasHeld = false
        _clearInfJumpForce()
    end

    function setInfJumpMode(mode)
        m = (mode == "Manual" or mode == "manual") and "manual" or "hold"
        InfJumpState.mode = m
    end

    UIS.JumpRequest:Connect(function()
        if not InfJumpState.enabled and not State.infJumpEnabled then return end
        InfJumpState.enabled = true
        if InfJumpState.mode == "hold" then
            if _holdTouch == nil and _lastTouchStart ~= nil and _activeTouches[_lastTouchStart] then
                _holdTouch = _lastTouchStart
            end
            return
        end
        _doInfJump()
    end)

    function _isGamepadInput(input)
        uit = input.UserInputType
        return uit == Enum.UserInputType.Gamepad1 or uit == Enum.UserInputType.Gamepad2
            or uit == Enum.UserInputType.Gamepad3 or uit == Enum.UserInputType.Gamepad4
            or uit == Enum.UserInputType.Gamepad5 or uit == Enum.UserInputType.Gamepad6
            or uit == Enum.UserInputType.Gamepad7 or uit == Enum.UserInputType.Gamepad8
    end

    UIS.InputBegan:Connect(function(inp)
        if inp.KeyCode ~= Enum.KeyCode.ButtonA or not _isGamepadInput(inp) then return end
        _gamepadBtnHeld = true
        if (InfJumpState.enabled or State.infJumpEnabled) and InfJumpState.mode == "manual" then
            _doInfJump()
        end
    end)
    UIS.InputEnded:Connect(function(inp)
        if inp.KeyCode ~= Enum.KeyCode.ButtonA or not _isGamepadInput(inp) then return end
        _gamepadBtnHeld = false
    end)

    UIS.TouchStarted:Connect(function(touch)
        if not (InfJumpState.enabled or State.infJumpEnabled) or InfJumpState.mode ~= "hold" then return end
        _activeTouches[touch] = true
        _lastTouchStart = touch
    end)
    UIS.TouchEnded:Connect(function(touch)
        _activeTouches[touch] = nil
        if _lastTouchStart == touch then _lastTouchStart = nil end
        if _holdTouch == touch then _holdTouch = nil end
    end)

    RunService.Heartbeat:Connect(function()
        if not (InfJumpState.enabled or State.infJumpEnabled) then
            if _jumpWasHeld then
                _jumpWasHeld = false
                _clearInfJumpForce()
            end
            return
        end
        if InfJumpState.mode ~= "hold" then return end
        local c = LP.Character
        if not c then return end
        local root = c:FindFirstChild("HumanoidRootPart")
        if not root then return end
        local hum = c:FindFirstChildOfClass("Humanoid")
        if not hum or hum.Health <= 0 then return end
        local jumpHeld = UIS:IsKeyDown(Enum.KeyCode.Space) or _gamepadBtnHeld or (_holdTouch ~= nil) or _spaceDown
        if jumpHeld then
            _jumpWasHeld = true
            if root.AssemblyLinearVelocity.Y < 35 then
                hum.Jump = true
                applyInfImpulse(root, hum, 52)
            end
        else
            -- released: stop upward force immediately so you don't keep floating up
            if _jumpWasHeld then
                _jumpWasHeld = false
                _clearInfJumpForce()
            end
        end
        if root.AssemblyLinearVelocity.Y < -120 then
            applyInfImpulse(root, hum, -120)
        end
    end)

    function stopAutoLeft()
        State.autoLeftEnabled = false
        if alConn then alConn:Disconnect(); alConn = nil end
        alPhase = 1
        pcall(function()
            char = LP.Character
            hum2 = char and char:FindFirstChildOfClass("Humanoid")
            hrp2 = char and char:FindFirstChild("HumanoidRootPart")
            if hum2 then hum2:Move(Vector3.zero, false) end
            if hrp2 then
                v = hrp2.AssemblyLinearVelocity
                hrp2.AssemblyLinearVelocity = Vector3.new(0, v.Y, 0)
            end
            if moveProxy then moveProxy.AssemblyLinearVelocity = Vector3.zero end
        end)
        destroyMoveProxy()
        pcall(function() setBoostVelocityEnabled(true) end)
        if kyzDuelsMobBtnRefs and kyzDuelsMobBtnRefs.autoLeft then
            pcall(function() kyzDuelsMobBtnRefs.autoLeft(false) end)
        end
    end
    function stopAutoRight()
        State.autoRightEnabled = false
        if arConn then arConn:Disconnect(); arConn = nil end
        arPhase = 1
        pcall(function()
            char = LP.Character
            hum2 = char and char:FindFirstChildOfClass("Humanoid")
            hrp2 = char and char:FindFirstChild("HumanoidRootPart")
            if hum2 then hum2:Move(Vector3.zero, false) end
            if hrp2 then
                v = hrp2.AssemblyLinearVelocity
                hrp2.AssemblyLinearVelocity = Vector3.new(0, v.Y, 0)
            end
            if moveProxy then moveProxy.AssemblyLinearVelocity = Vector3.zero end
        end)
        destroyMoveProxy()
        pcall(function() setBoostVelocityEnabled(true) end)
        if kyzDuelsMobBtnRefs and kyzDuelsMobBtnRefs.autoRight then
            pcall(function() kyzDuelsMobBtnRefs.autoRight(false) end)
        end
    end

    _autoCarryFromSteal = false
    _autoCarryWaitingPickup = false
    _autoCarryGraceUntil = 0
    _autoCarryPickupUntil = 0
    _autoCarryReturnMode = nil
    _stealAttrWasActive = false

    function isCarryName(name)
        n = tostring(name or ""):lower()
        return n:find("brainrot") or n:find("animal") or n:find("carry")
            or n:find("grab") or n:find("steal") or n:find("hold")
    end

    function isIgnoredCarryTool(name)
        n = tostring(name or ""):lower()
        return n:find("bat") or n:find("slap") or n:find("medusa")
            or n:find("head") or n:find("stone")
    end

    function isCarryingBrainrot(char)
        if not char then return false end
        for _, name in ipairs({"Carrying", "IsCarrying", "Grabbed", "Holding", "StealHold", "HasGrab"}) do
            v = char:FindFirstChild(name, true)
            if v then
                if v:IsA("BoolValue") and v.Value then return true end
                if v:IsA("ObjectValue") and v.Value then return true end
                if v:IsA("StringValue") and v.Value ~= "" then return true end
            end
        end
        for _, child in ipairs(char:GetChildren()) do
            if child:IsA("Model") and child:FindFirstChildWhichIsA("BasePart", true) then
                if child:FindFirstChildOfClass("Humanoid") and child:FindFirstChild("HumanoidRootPart") then
                    return true
                end
                if isCarryName(child.Name) then return true end
            elseif child:IsA("Tool") and not isIgnoredCarryTool(child.Name) then
                return true
            end
        end
        return false
    end

    function enableCarrySpeedForSteal()
        _autoCarryWaitingPickup = false
        _autoCarryPickupUntil = 0
        if not _autoCarryFromSteal then
            _autoCarryReturnMode = { speedMode = State.speedMode, laggerMode = State.laggerMode }
        end
        _autoCarryFromSteal = true
        _autoCarryGraceUntil = tick() + 0.75
        wasLagger = (State.laggerMode ~= 0) or (_autoCarryReturnMode and _autoCarryReturnMode.laggerMode ~= 0)
        if wasLagger then
            State.laggerMode = 1
            State.speedMode = 1
        else
            State.laggerMode = 0
            State.speedMode = 1
        end
        pcall(updateSpeedUI)
    end

    function disableAutoCarrySpeed()
        if not _autoCarryFromSteal and not _autoCarryWaitingPickup then return end
        wasAuto = _autoCarryFromSteal == true
        returnMode = _autoCarryReturnMode
        _autoCarryFromSteal = false
        _autoCarryWaitingPickup = false
        _autoCarryGraceUntil = 0
        _autoCarryPickupUntil = 0
        _autoCarryReturnMode = nil
        if not wasAuto then return end
        if returnMode then
            State.speedMode = returnMode.speedMode or 0
            State.laggerMode = returnMode.laggerMode or 0
        else
            State.speedMode = 0
            State.laggerMode = 0
        end
        pcall(updateSpeedUI)
    end

    RunService.RenderStepped:Connect(function()
        if not State.autoCarrySpeedEnabled then
            if _autoCarryFromSteal or _autoCarryWaitingPickup then
                disableAutoCarrySpeed()
            end
            return
        end
        char = LP.Character
        hum = char and char:FindFirstChildOfClass("Humanoid")
        root = char and char:FindFirstChild("HumanoidRootPart")
        if not char or not hum or not root then
            disableAutoCarrySpeed()
            _stealAttrWasActive = false
            return
        end
        st = hum:GetState()
        gotHit = st == Enum.HumanoidStateType.Physics
            or st == Enum.HumanoidStateType.Ragdoll
            or st == Enum.HumanoidStateType.FallingDown
        stealingAttr = false
        pcall(function() stealingAttr = (LP:GetAttribute("Stealing") == true) end)
        carryingBrainrot = isCarryingBrainrot(char)
        if stealingAttr and not _stealAttrWasActive then
            _stealAttrWasActive = true
            enableCarrySpeedForSteal()
        elseif not stealingAttr then
            _stealAttrWasActive = false
        end
        if _autoCarryWaitingPickup then
            if gotHit or tick() > (_autoCarryPickupUntil or 0) then
                _autoCarryWaitingPickup = false
                _autoCarryPickupUntil = 0
            elseif carryingBrainrot then
                enableCarrySpeedForSteal()
            end
        end
        if carryingBrainrot and not _autoCarryFromSteal then
            enableCarrySpeedForSteal()
        end
        if _autoCarryFromSteal then
            graceDone = tick() > (_autoCarryGraceUntil or 0)
            if gotHit or (graceDone and not carryingBrainrot and not stealingAttr) then
                disableAutoCarrySpeed()
            end
        end
    end)

    function safeModeGetCountdownLabel()
        local ok, label = pcall(function()
            pg = LP:FindFirstChild("PlayerGui")
            if not pg then return nil end
            a = pg:FindFirstChild("DuelsMachineTopFrame")
            b = a and a:FindFirstChild("DuelsMachineTopFrame")
            t = b and b:FindFirstChild("Timer")
            return t and t:FindFirstChild("Label")
        end)
        return (ok and label) or nil
    end
    function safeModeCountdownNumber(txt)
        t = tostring(txt or ""):upper():gsub("^%s+", ""):gsub("%s+$", "")
        if t == "GO" or t == "START" or t == "READY" then return true end
        n = tonumber(t)
        return n ~= nil and n >= 0 and n <= 10
    end
    function safeModeInDuelCountdown()
        label = safeModeGetCountdownLabel()
        return label and safeModeCountdownNumber(label.Text) or false
    end
    function safeModeHoldingBrainrot()
        local ok, val = pcall(function() return LP:GetAttribute("Stealing") end)
        if ok and val == true then return true end
        char = LP.Character
        if not char then return false end
        local ok3, val3 = pcall(function() return char:GetAttribute("Stealing") end)
        if ok3 and val3 == true then return true end
        if isCarryingBrainrot(char) then return true end
        return false
    end
    function safeModeIsLocked()
        if not State.safeModeEnabled then return false end
        return safeModeInDuelCountdown() or safeModeHoldingBrainrot()
    end
    function safeModeForceStop(reason)
        stopped = false
        if State.autoLeftEnabled then
            State.autoLeftEnabled = false
            pcall(stopAutoLeft)
            stopped = true
        end
        if State.autoRightEnabled then
            State.autoRightEnabled = false
            pcall(stopAutoRight)
            stopped = true
        end
        if State.batCounterEnabled then
            pcall(stopBatCounter)
            stopped = true
        end
        if stopped then
        end
    end
    function safeModeTryStart()
        if safeModeIsLocked() then
            safeModeForceStop("SAFE MODE LOCK")
            return false
        end
        return true
    end
    RunService.Heartbeat:Connect(function()
        if State.safeModeEnabled and safeModeIsLocked() then
            safeModeForceStop("SAFE MODE LOCK")
        end
    end)

    function startAutoLeft()
        State.autoLeftEnabled = true
        State.autoRightEnabled = false
        pcall(stopAutoRight)
        if safeModeTryStart and not safeModeTryStart() then
            State.autoLeftEnabled = false
            return
        end
        if alConn then alConn:Disconnect() end
        alPhase = 1
        setBoostVelocityEnabled(false)
        alConn = RunService.Heartbeat:Connect(function()
            if not State.autoLeftEnabled then return end
            char = LP.Character
            if not char then return end
            hrp = char:FindFirstChild("HumanoidRootPart")
            hum = char:FindFirstChildOfClass("Humanoid")
            if not hrp or not hum or hum.Health <= 0 then return end
            if isRagdollState(hum) then
                hum:Move(Vector3.zero, false)
                return
            end
            spd = getAutoPathSpeed()
            if type(spd) ~= "number" or spd ~= spd then spd = 59 end
            spd = math.clamp(spd, 16, 200)

            function toward(point)
                flat = Vector3.new(point.X - hrp.Position.X, 0, point.Z - hrp.Position.Z)
                dist = flat.Magnitude
                if dist < 1.5 then
                    return true, nil
                end
                return false, flat.Unit
            end

            if alPhase == 1 then
                local done, mv = toward(AP_L1)
                if done then
                    alPhase = 2
                    local _, mv2 = toward(AP_L2)
                    if mv2 then drivePathVelocity(hrp, hum, mv2, spd) end
                    return
                end
                if mv then drivePathVelocity(hrp, hum, mv, spd) end
            elseif alPhase == 2 then
                local done, mv = toward(AP_L2)
                if done then
                    pcall(function() hum:Move(Vector3.zero, false) end)
                    v = hrp.AssemblyLinearVelocity
                    hrp.AssemblyLinearVelocity = Vector3.new(0, v.Y, 0)
                    if (AP_L_FACE - hrp.Position).Magnitude > 0.01 then
                        hrp.CFrame = CFrame.new(hrp.Position, Vector3.new(AP_L_FACE.X, hrp.Position.Y, AP_L_FACE.Z))
                    end
                    State.autoLeftEnabled = false
                    if alConn then alConn:Disconnect(); alConn = nil end
                    alPhase = 1
                    destroyMoveProxy()
                    setBoostVelocityEnabled(true)
                    if kyzDuelsMobBtnRefs and kyzDuelsMobBtnRefs.autoLeft then
                        pcall(function() kyzDuelsMobBtnRefs.autoLeft(false) end)
                    end
                    return
                end
                if mv then drivePathVelocity(hrp, hum, mv, spd) end
            end
        end)
    end

    function startAutoRight()
        State.autoRightEnabled = true
        State.autoLeftEnabled = false
        pcall(stopAutoLeft)
        if safeModeTryStart and not safeModeTryStart() then
            State.autoRightEnabled = false
            return
        end
        if arConn then arConn:Disconnect() end
        arPhase = 1
        setBoostVelocityEnabled(false)
        arConn = RunService.Heartbeat:Connect(function()
            if not State.autoRightEnabled then return end
            char = LP.Character
            if not char then return end
            hrp = char:FindFirstChild("HumanoidRootPart")
            hum = char:FindFirstChildOfClass("Humanoid")
            if not hrp or not hum or hum.Health <= 0 then return end
            if isRagdollState(hum) then
                hum:Move(Vector3.zero, false)
                return
            end
            spd = getAutoPathSpeed()
            if type(spd) ~= "number" or spd ~= spd then spd = 59 end
            spd = math.clamp(spd, 16, 200)

            function toward(point)
                flat = Vector3.new(point.X - hrp.Position.X, 0, point.Z - hrp.Position.Z)
                dist = flat.Magnitude
                if dist < 1.5 then
                    return true, nil
                end
                return false, flat.Unit
            end

            if arPhase == 1 then
                local done, mv = toward(AP_R1)
                if done then
                    arPhase = 2
                    local _, mv2 = toward(AP_R2)
                    if mv2 then drivePathVelocity(hrp, hum, mv2, spd) end
                    return
                end
                if mv then drivePathVelocity(hrp, hum, mv, spd) end
            elseif arPhase == 2 then
                local done, mv = toward(AP_R2)
                if done then
                    pcall(function() hum:Move(Vector3.zero, false) end)
                    v = hrp.AssemblyLinearVelocity
                    hrp.AssemblyLinearVelocity = Vector3.new(0, v.Y, 0)
                    if (AP_R_FACE - hrp.Position).Magnitude > 0.01 then
                        hrp.CFrame = CFrame.new(hrp.Position, Vector3.new(AP_R_FACE.X, hrp.Position.Y, AP_R_FACE.Z))
                    end
                    State.autoRightEnabled = false
                    if arConn then arConn:Disconnect(); arConn = nil end
                    arPhase = 1
                    destroyMoveProxy()
                    setBoostVelocityEnabled(true)
                    if kyzDuelsMobBtnRefs and kyzDuelsMobBtnRefs.autoRight then
                        pcall(function() kyzDuelsMobBtnRefs.autoRight(false) end)
                    end
                    return
                end
                if mv then drivePathVelocity(hrp, hum, mv, spd) end
            end
        end)
    end

    BAT_SLAP_LIST = {"Bat","Slap","Iron Slap","Gold Slap","Diamond Slap","Emerald Slap","Ruby Slap","Dark Matter Slap","Flame Slap","Nuclear Slap","Galaxy Slap","Glitched Slap"}

    function findBatForCounter()
        c=LP.Character; if not c then return nil end
        bp=LP:FindFirstChildOfClass("Backpack")
        if not BAT_SLAP_LIST then return nil end
        for _,name in ipairs(BAT_SLAP_LIST) do local t=c:FindFirstChild(name) or (bp and bp:FindFirstChild(name)); if t then return t end end
        return nil
    end

    function startBatCounter()
        if Conns.batCounter then return end
        Conns.batCounter=RunService.Heartbeat:Connect(function()
            if not State.batCounterEnabled or State.batCounterDebounce then return end
            char=LP.Character; if not char then return end
            hum2=char:FindFirstChildOfClass("Humanoid"); if not hum2 then return end
            st=hum2:GetState()
            if st==Enum.HumanoidStateType.Physics or st==Enum.HumanoidStateType.Ragdoll or st==Enum.HumanoidStateType.FallingDown then
                State.batCounterDebounce=true
                task.spawn(function()
                    bat=findBatForCounter()
                    if bat then
                        hum3=char:FindFirstChildOfClass("Humanoid")
                        if bat.Parent~=char and hum3 then pcall(function() hum3:EquipTool(bat) end); task.wait(0.05) end
                        pcall(function() bat:Activate() end); task.wait(0.15); pcall(function() bat:Activate() end)
                    end
                    task.wait(0.6); State.batCounterDebounce=false
                end)
            end
        end)
    end

    function stopBatCounter()
        if Conns.batCounter then Conns.batCounter:Disconnect(); Conns.batCounter=nil end
        State.batCounterDebounce=false
    end

    MEDUSA_COOLDOWN = 0
    function findMedusa()
        c=LP.Character; if not c then return nil end
        for _,t in ipairs(c:GetChildren()) do if t:IsA("Tool") then local n=t.Name:lower(); if n:find("medusa") or n:find("head") or n:find("stone") then return t end end end
        bp=LP:FindFirstChild("Backpack")
        if bp then for _,t in ipairs(bp:GetChildren()) do if t:IsA("Tool") then local n=t.Name:lower(); if n:find("medusa") then return t end end end end
        return nil
    end

    function useMedusaCounter()
        if State.medusaDebounce or tick()-State.medusaLastUsed<MEDUSA_COOLDOWN then return end
        c=LP.Character; if not c then return end
        State.medusaDebounce=true
        med=findMedusa(); if not med then State.medusaDebounce=false; return end
        if med.Parent~=c then local hum2=c:FindFirstChildOfClass("Humanoid"); if hum2 then hum2:EquipTool(med) end end
        pcall(function() med:Activate() end); State.medusaLastUsed=tick(); State.medusaDebounce=false
    end

    function setupMedusaCounter(char)
        for _,c2 in pairs(Conns.anchor) do pcall(function() c2:Disconnect() end) end; Conns.anchor={}
        if not char then return end
        
        bodyParts = {"HumanoidRootPart", "Head", "UpperTorso", "LowerTorso", "Torso"}
        for _, partName in ipairs(bodyParts) do
            part = char:FindFirstChild(partName)
            if part and part:IsA("BasePart") then
                table.insert(Conns.anchor, part:GetPropertyChangedSignal("Anchored"):Connect(function()
                    if part.Anchored and part.Transparency >= 0.9 then
                        med = findMedusa()
                        if med then
                            useMedusaCounter()
                        end
                    end
                end))
            end
        end
    end

    function stopMedusaCounter()
        for _,c2 in pairs(Conns.anchor) do pcall(function() c2:Disconnect() end) end; Conns.anchor={}
    end

    if not _G.__KyzDuelsResetFeaturesCharConn then
        _G.__KyzDuelsResetFeaturesCharConn = true
        LP.CharacterAdded:Connect(function(char)
            task.wait(0.15)
            if State.medusaCounterEnabled then
                setupMedusaCounter(char)
            end
        end)
    end

    function hookMedusa(tool)
        if not tool:IsA("Tool") then return end
        n = tool.Name:lower()
        if n:find("medusa") or n:find("head") or n:find("stone") then
            tool.Activated:Connect(function()
                if State.antiMedusaEnabled then
                    task.wait(0.12)
                    insta_reset()
                end
            end)
        end
    end

    LP.CharacterAdded:Connect(function(char)
        char.ChildAdded:Connect(hookMedusa)
        for _, t in ipairs(char:GetChildren()) do hookMedusa(t) end
    end)
    if LP.Character then
        for _, t in ipairs(LP.Character:GetChildren()) do hookMedusa(t) end
        LP.Character.ChildAdded:Connect(hookMedusa)
    end

    dropModeNames = {[0] = "Standing Drop", [1] = "Jump Drop"}

    BG_BASE_DEFS = {
        { url = "https://happy-image-link.lovable.app/api/public/f/kx7m2a128.png", file = "kyzDuels_hub_bg1_v2.png" },
        { url = "https://happy-image-link.lovable.app/api/public/f/kx7m2a94.png", file = "kyzDuels_hub_bg2.png" },
        { url = "https://happy-image-link.lovable.app/api/public/f/kx7m2a129.png", file = "kyzDuels_hub_bg3_v2.png" },
        { url = "https://happy-image-link.lovable.app/api/public/f/kx7m2a130.png", file = "kyzDuels_hub_bg4_v2.png" },
        { url = "https://happy-image-link.lovable.app/api/public/f/kx7m2a131.png", file = "kyzDuels_hub_bg5_v2.png" },
    }
    _bgCustom = {}
    BG_DEFS = {}
    BG_ASSETS = {}
    BG_IMAGES = {}

    local function _bgRebuildDefs()
        local oldAssets = BG_ASSETS
        local oldByUrl = {}
        if type(oldAssets) == "table" and type(BG_DEFS) == "table" then
            for i, def in ipairs(BG_DEFS) do
                if def and def.url and oldAssets[i] and oldAssets[i] ~= "" then
                    oldByUrl[def.url] = oldAssets[i]
                end
            end
        end
        BG_DEFS = {}
        BG_ASSETS = {}
        BG_IMAGES = {}
        for i, def in ipairs(BG_BASE_DEFS) do
            BG_DEFS[i] = def
            BG_IMAGES[i] = def.url
            BG_ASSETS[i] = oldByUrl[def.url] or ""
        end
        for _, def in ipairs(_bgCustom) do
            local i = #BG_DEFS + 1
            BG_DEFS[i] = def
            BG_IMAGES[i] = def.url
            BG_ASSETS[i] = oldByUrl[def.url] or ""
        end
    end
    function _bgNormalizeInput(raw)
        raw = tostring(raw or ""):gsub("^%s+", ""):gsub("%s+$", "")
        if raw == "" then return nil, "empty" end
        -- plain Roblox asset id
        local id = tonumber(raw)
        if id and id > 0 then
            return {
                url = "rbxassetid://" .. tostring(id),
                file = "kyzDuels_hub_bg_custom_" .. tostring(id) .. ".png",
                custom = true,
                rbxId = id,
            }
        end
        -- rbxassetid://123 or http://www.roblox.com/asset/?id=123 or rbxthumb
        local rid = raw:match("rbxassetid://(%d+)")
            or raw:match("rbxthumb://[^%s]*id=(%d+)")
            or raw:match("[?&]id=(%d+)")
            or raw:match("/asset/%?id=(%d+)")
        if rid then
            id = tonumber(rid)
            return {
                url = "rbxassetid://" .. tostring(id),
                file = "kyzDuels_hub_bg_custom_" .. tostring(id) .. ".png",
                custom = true,
                rbxId = id,
            }
        end
        -- http(s) link (Lovable / CDN / etc.)
        if raw:sub(1, 4):lower() == "http" then
            local h = 0
            for i = 1, math.min(#raw, 80) do
                h = (h * 33 + string.byte(raw, i)) % 1000000007
            end
            return {
                url = raw,
                file = "kyzDuels_hub_bg_custom_" .. tostring(h) .. ".png",
                custom = true,
            }
        end
        return nil, "use Lovable link or Rbx id"
    end
    function _bgAddCustom(raw)
        local def, err = _bgNormalizeInput(raw)
        if not def then return false, err end
        for _, cur in ipairs(_bgCustom) do
            if cur.url == def.url or (def.rbxId and cur.rbxId == def.rbxId) then
                return false, "already exists"
            end
        end
        table.insert(_bgCustom, def)
        _bgRebuildDefs()
        return true, #BG_DEFS
    end

    function _bgRemoveCustom(idx)
        idx = tonumber(idx)
        if not idx or idx < 1 or not BG_DEFS[idx] or not BG_DEFS[idx].custom then
            return false
        end
        local url = BG_DEFS[idx].url
        for i = #_bgCustom, 1, -1 do
            if _bgCustom[i].url == url then
                table.remove(_bgCustom, i)
                break
            end
        end
        local wasSelected = (backgroundIndex == idx)
        _bgRebuildDefs()
        if wasSelected or backgroundIndex > #BG_DEFS then
            backgroundIndex = 0
            if State then State.backgroundIndex = 0 end
            pcall(applyBackgroundImage, 0)
        end
        return true
    end

    -- restore custom backgrounds from config stash
    pcall(function()
        local pending = _G.__KyzDuelsPendingBgCustom
        if type(pending) ~= "table" then return end
        for _, it in ipairs(pending) do
            if type(it) == "table" and it.url then
                local exists = false
                for _, cur in ipairs(_bgCustom) do
                    if cur.url == it.url or (it.rbxId and cur.rbxId == tonumber(it.rbxId)) then
                        exists = true
                        break
                    end
                end
                if not exists then
                    table.insert(_bgCustom, {
                        url = tostring(it.url),
                        file = it.file or ("kyzDuels_hub_bg_custom_" .. tostring(#_bgCustom + 1) .. ".png"),
                        custom = true,
                        rbxId = tonumber(it.rbxId),
                    })
                end
            end
        end
        _bgRebuildDefs()
        _G.__KyzDuelsPendingBgCustom = nil
    end)

    backgroundIndex = 0
    backgroundEnabled = false
    bgImageRef = nil
    bgGradRef = nil
    bgStrokeRefs = {}
    bgInnerRef = nil
    bgThumbRefs = {}

    local C

    function resolveBgImageSource(entry)
        if not entry then return "" end
        local s = tostring(entry)
        local lower = s:lower()
        if lower:sub(1, 4) == "http"
            or lower:sub(1, 11) == "rbxassetid:"
            or lower:sub(1, 11) == "rbxasset://"
            or lower:sub(1, 9) == "rbxthumb"
            or lower:sub(1, 13) == "getcustomasset" then
            return s
        end
        -- bare numeric id
        if tonumber(s) then
            return "rbxassetid://" .. s
        end
        return s
    end
    function getBgAsset(idx)
        if BG_ASSETS[idx] and BG_ASSETS[idx] ~= "" then
            return BG_ASSETS[idx]
        end
        def = BG_DEFS[idx]
        if not def then return "" end
        return resolveBgImageSource(def.url)
    end

    function updateBackgroundSelection(idx)
        for i, stroke in pairs(bgStrokeRefs) do
            if stroke and stroke.Parent then
                stroke.Color = (i == idx) and C.blue or C.divider
            end
        end
    end

    function applyBackgroundImage(index)
        idx = tonumber(index) or 0
        if idx ~= 0 and not BG_DEFS[idx] then
            idx = 0
        end
        backgroundIndex = idx
        State.backgroundIndex = backgroundIndex
        if not bgImageRef then return end
        if backgroundIndex == 0 then
            bgImageRef.Visible = false
            backgroundEnabled = false
            if bgGradRef then
                bgGradRef.Visible = true
                bgGradRef.BackgroundTransparency = 0.38
                bgGradRef.BackgroundColor3 = Color3.fromRGB(12, 12, 14)
                grad = bgGradRef:FindFirstChildOfClass("UIGradient")
                if grad then
                    grad.Color = ColorSequence.new({
                        ColorSequenceKeypoint.new(0, Color3.fromRGB(28, 28, 30)),
                        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(18, 18, 20)),
                        ColorSequenceKeypoint.new(1, Color3.fromRGB(12, 12, 14)),
                    })
                    grad.Transparency = NumberSequence.new(0.38)
                end
            end
            if bgInnerRef then bgInnerRef.BackgroundTransparency = 0.38 end
        else
            asset = getBgAsset(backgroundIndex)
            if (not asset or asset == "") and BG_DEFS[backgroundIndex] then
                asset = resolveBgImageSource(BG_DEFS[backgroundIndex].url)
            end
            if asset and asset ~= "" then
                bgImageRef.Image = asset
                bgImageRef.ScaleType = Enum.ScaleType.Crop
                bgImageRef.Visible = true
                backgroundEnabled = true
                if bgGradRef then
                    bgGradRef.Visible = false
                    bgGradRef.BackgroundTransparency = 1
                    grad = bgGradRef:FindFirstChildOfClass("UIGradient")
                    if grad then grad.Transparency = NumberSequence.new(1) end
                end
                if bgInnerRef then bgInnerRef.BackgroundTransparency = 0.55 end
            else
                -- keep index; just hide image until asset loads
                bgImageRef.Visible = false
                backgroundEnabled = false
            end
        end
        pcall(updateBackgroundSelection, backgroundIndex)
        pcall(updateTitleForBackground, backgroundIndex)
        task.spawn(saveConfig)
    end
    function startBgLoad()
        task.spawn(function()
            for i, def in ipairs(BG_DEFS) do
                asset = ""
                pcall(function()
                    if writefile and (game.HttpGet or HttpGet) then
                        need = true
                        pcall(function()
                            if isfile and isfile(def.file) then need = false end
                        end)
                        if need then
                            data = (_G.__KyzDuelsHttpGet and _G.__KyzDuelsHttpGet(def.url, true)) or (game.HttpGet and game:HttpGet(def.url, true)) or (HttpGet and HttpGet(def.url))
                            if data then writefile(def.file, data) end
                        end
                    end
                end)
                pcall(function()
                    if getcustomasset and isfile and isfile(def.file) then
                        asset = getcustomasset(def.file)
                    end
                end)
                if asset == "" then
                    pcall(function()
                        if writefile and (game.HttpGet or HttpGet) then
                            data = (_G.__KyzDuelsHttpGet and _G.__KyzDuelsHttpGet(def.url, true)) or (game.HttpGet and game:HttpGet(def.url, true)) or (HttpGet and HttpGet(def.url))
                            if data then writefile(def.file, data) end
                        end
                        if getcustomasset and isfile and isfile(def.file) then
                            asset = getcustomasset(def.file)
                        end
                    end)
                end
                if asset == "" then
                    asset = resolveBgImageSource(def.url)
                end
                BG_ASSETS[i] = asset
                pcall(function()
                    if bgThumbRefs[i] then bgThumbRefs[i].Image = asset end
                end)
                if backgroundIndex == i then
                    pcall(applyBackgroundImage, i)
                end
            end
        end)
    end

    function openBackgroundGallery()
        if not BG_DEFS or #BG_DEFS == 0 then
            warn("[Kyz Duels] BG_DEFS vazio")
            return
        end

        PlayerGui = LP:FindFirstChild("PlayerGui") or LP:WaitForChild("PlayerGui", 5)
        if not PlayerGui then return end
        if PlayerGui:FindFirstChild("KyzDuelsBackgroundGalleryLayer") then return end
        pcall(function()
            old = game:GetService("CoreGui"):FindFirstChild("KyzDuelsBackgroundGalleryLayer")
            if old then old:Destroy() end
        end)

        selectedIndex = backgroundIndex or 0
        closing = false
        cardRefs = {}

        modalGui = Instance.new("ScreenGui")
        modalGui.Name = "KyzDuelsBackgroundGalleryLayer"
        modalGui.ResetOnSpawn = false
        modalGui.IgnoreGuiInset = true
        modalGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        modalGui.DisplayOrder = 999
        parentGui(modalGui)

        blur = Instance.new("BlurEffect")
        blur.Name = "KyzDuelsBGGalleryBlur"
        blur.Size = 0
        blur.Parent = Lighting

        overlay = Instance.new("TextButton")
        overlay.Name = "Overlay"
        overlay.Size = UDim2.fromScale(1, 1)
        overlay.BackgroundColor3 = Color3.fromRGB(2, 3, 8)
        overlay.BackgroundTransparency = 1
        overlay.BorderSizePixel = 0
        overlay.Text = ""
        overlay.AutoButtonColor = false
        overlay.ZIndex = 100
        overlay.Parent = modalGui

        popup = Instance.new("CanvasGroup")
        popup.Name = "Gallery"
        popup.AnchorPoint = Vector2.new(0.5, 0.5)
        popup.Position = UDim2.fromScale(0.5, 0.5)
        popup.Size = UDim2.fromOffset((isMobileDevice and 300) or 420, (isMobileDevice and 360) or 440)
        popup.BackgroundColor3 = Color3.fromRGB(10, 10, 14)
        popup.BackgroundTransparency = 1
        popup.BorderSizePixel = 0
        popup.ClipsDescendants = true
        popup.GroupTransparency = 1
        popup.Rotation = -2
        popup.ZIndex = 101
        popup.Parent = overlay
        Instance.new("UICorner", popup).CornerRadius = UDim.new(0, 18)

        BORDER_PX = 8
        BORDER_URL = "https://happy-image-link.lovable.app/api/public/f/kx7m2a112.png"
        BORDER_FILE = "kyzDuels_panel_border.png"

        panelBorderImg = Instance.new("ImageLabel", popup)
        panelBorderImg.Name = "PanelBorderImage"
        panelBorderImg.Size = UDim2.fromScale(1, 1)
        panelBorderImg.Position = UDim2.fromScale(0, 0)
        panelBorderImg.BackgroundTransparency = 1
        panelBorderImg.BorderSizePixel = 0
        panelBorderImg.Image = BORDER_URL
        panelBorderImg.ScaleType = Enum.ScaleType.Crop
        panelBorderImg.ImageTransparency = 0.05
        panelBorderImg.ZIndex = 101
        Instance.new("UICorner", panelBorderImg).CornerRadius = UDim.new(0, 18)

        task.spawn(function()
            asset = ""
            pcall(function()
                if writefile and (game.HttpGet or HttpGet) then
                    need = true
                    pcall(function()
                        if isfile and isfile(BORDER_FILE) then need = false end
                    end)
                    if need then
                        data = (_G.__KyzDuelsHttpGet and _G.__KyzDuelsHttpGet(BORDER_URL, true)) or (game.HttpGet and game:HttpGet(BORDER_URL, true)) or (HttpGet and HttpGet(BORDER_URL))
                        if data then writefile(BORDER_FILE, data) end
                    end
                end
            end)
            pcall(function()
                if getcustomasset and isfile and isfile(BORDER_FILE) then
                    asset = getcustomasset(BORDER_FILE)
                end
            end)
            if asset == "" then
                asset = BORDER_URL
            end
            if panelBorderImg and panelBorderImg.Parent then
                panelBorderImg.Image = asset
                panelBorderImg.ImageTransparency = 0.05
            end
        end)

        panelInner = Instance.new("Frame", popup)
        panelInner.Name = "PanelInnerFill"
        panelInner.Position = UDim2.fromOffset(BORDER_PX, BORDER_PX)
        panelInner.Size = UDim2.new(1, -BORDER_PX * 2, 1, -BORDER_PX * 2)
        panelInner.BackgroundColor3 = Color3.fromRGB(12, 12, 16)
        panelInner.BackgroundTransparency = 0.05
        panelInner.BorderSizePixel = 0
        panelInner.ZIndex = 102
        Instance.new("UICorner", panelInner).CornerRadius = UDim.new(0, 12)

        popupStroke = Instance.new("UIStroke", popup)
        popupStroke.Color = Color3.fromRGB(210, 210, 220)
        popupStroke.Thickness = 1.2
        popupStroke.Transparency = 0.3

        popupScale = Instance.new("UIScale", popup)
        function getTargetScale()
            cam = workspace.CurrentCamera
            vp = cam and cam.ViewportSize or Vector2.new(1280, 720)
            return math.clamp(math.min((vp.X - 40) / 560, (vp.Y - 40) / 540), 0.5, 1)
        end
        targetScale = getTargetScale()
        popupScale.Scale = targetScale * 0.82

        accent     = (C and C.blue) or Color3.fromRGB(210, 210, 215)
        accentDark = (C and C.blueDark) or Color3.fromRGB(40, 40, 44)
        accentBg   = Color3.fromRGB(28, 28, 32)

        title = Instance.new("TextLabel", popup)
        title.AnchorPoint = Vector2.new(0.5, 0)
        title.Position = UDim2.new(0.5, 0, 0, isMobileDevice and 10 or 16)
        title.Size = UDim2.new(1, -32, 0, isMobileDevice and 22 or 28)
        title.BackgroundTransparency = 1
        title.Text = isMobileDevice and "BACKGROUNDS" or "KYZ DUELS BACKGROUNDS"
        title.TextColor3 = Color3.fromRGB(255, 255, 255)
        title.Font = Enum.Font.GothamBold
        title.TextSize = isMobileDevice and 14 or 20
        title.TextXAlignment = Enum.TextXAlignment.Center
        title.ZIndex = 104

        headerDivider = Instance.new("Frame", popup)
        headerDivider.Position = UDim2.fromOffset(20, isMobileDevice and 36 or 52)
        headerDivider.Size = UDim2.new(1, -40, 0, 1)
        headerDivider.BackgroundColor3 = Color3.fromRGB(50, 50, 58)
        headerDivider.BackgroundTransparency = 0.35
        headerDivider.BorderSizePixel = 0
        headerDivider.ZIndex = 103

        previewPanel = Instance.new("Frame", popup)
        previewPanel.Position = UDim2.fromOffset(16, isMobileDevice and 44 or 64)
        previewPanel.Size = UDim2.new(1, -32, 0, isMobileDevice and 180 or 260)
        previewPanel.BackgroundColor3 = Color3.fromRGB(14, 14, 18)
        previewPanel.BackgroundTransparency = 0.2
        previewPanel.BorderSizePixel = 0
        previewPanel.ZIndex = 103
        Instance.new("UICorner", previewPanel).CornerRadius = UDim.new(0, 14)

        hero = Instance.new("ImageLabel", previewPanel)
        hero.Position = UDim2.fromOffset(8, 8)
        hero.Size = UDim2.new(1, -16, 1, -16)
        hero.BackgroundColor3 = Color3.fromRGB(8, 8, 10)
        hero.BackgroundTransparency = 0
        hero.BorderSizePixel = 0
        hero.ScaleType = Enum.ScaleType.Crop
        hero.ZIndex = 104
        Instance.new("UICorner", hero).CornerRadius = UDim.new(0, 10)

        selectedTitle = Instance.new("TextLabel", popup)
        selectedTitle.Position = UDim2.fromOffset(16, isMobileDevice and 250 or 300)
        selectedTitle.Size = UDim2.fromOffset(180, 20)
        selectedTitle.BackgroundTransparency = 1
        selectedTitle.TextColor3 = Color3.fromRGB(200, 200, 210)
        selectedTitle.Font = Enum.Font.GothamBold
        selectedTitle.TextSize = 12
        selectedTitle.TextXAlignment = Enum.TextXAlignment.Left
        selectedTitle.ZIndex = 108

        applyBtn = Instance.new("TextButton", popup)
        applyBtn.AnchorPoint = Vector2.new(1, 0)
        applyBtn.Position = UDim2.new(1, isMobileDevice and -14 or -24, 0, isMobileDevice and 246 or 296)
        applyBtn.Size = UDim2.fromOffset(isMobileDevice and 110 or 150, isMobileDevice and 30 or 36)
        applyBtn.BackgroundColor3 = accentBg
        applyBtn.BackgroundTransparency = 0.05
        applyBtn.BorderSizePixel = 0
        applyBtn.Text = "APPLY BACKGROUND"
        applyBtn.TextColor3 = accent
        applyBtn.Font = Enum.Font.GothamBlack
        applyBtn.TextSize = 11
        applyBtn.AutoButtonColor = false
        applyBtn.ZIndex = 109
        Instance.new("UICorner", applyBtn).CornerRadius = UDim.new(0, 10)
        applyStroke = Instance.new("UIStroke", applyBtn)
        applyStroke.Color = accentDark
        applyStroke.Thickness = 1.1
        applyScale = Instance.new("UIScale", applyBtn)

        stripWrap = Instance.new("Frame", popup)
        stripWrap.Name = "BgStripWrap"
        stripWrap.Position = UDim2.fromOffset(12, isMobileDevice and 290 or 360)
        stripWrap.Size = UDim2.new(1, -24, 0, isMobileDevice and 52 or 64)
        stripWrap.BackgroundTransparency = 1
        stripWrap.BorderSizePixel = 0
        stripWrap.ClipsDescendants = true
        stripWrap.ZIndex = 104

        scroll = Instance.new("ScrollingFrame", stripWrap)
        scroll.Name = "BgStrip"
        scroll.Size = UDim2.fromScale(1, 1)
        scroll.BackgroundTransparency = 1
        scroll.BorderSizePixel = 0
        scroll.ScrollBarThickness = 3
        scroll.ScrollBarImageColor3 = Color3.fromRGB(120, 120, 130)
        scroll.ScrollingDirection = Enum.ScrollingDirection.X
        scroll.ElasticBehavior = Enum.ElasticBehavior.Always
        scroll.CanvasSize = UDim2.fromOffset(0, 0)
        scroll.ZIndex = 105

        list = Instance.new("UIListLayout", scroll)
        list.FillDirection = Enum.FillDirection.Horizontal
        list.HorizontalAlignment = Enum.HorizontalAlignment.Left
        list.VerticalAlignment = Enum.VerticalAlignment.Center
        list.Padding = UDim.new(0, 10)
        list.SortOrder = Enum.SortOrder.LayoutOrder

        pad = Instance.new("UIPadding", scroll)
        pad.PaddingLeft = UDim.new(0, 4)
        pad.PaddingRight = UDim.new(0, 4)

        local ITEM_W, ITEM_H, GAP = (isMobileDevice and 64 or 88), (isMobileDevice and 42 or 54), (isMobileDevice and 6 or 10)

        function getAsset(idx)
            if idx == 0 then return "" end
            if getBgAsset then
                a = getBgAsset(idx)
                if a and a ~= "" then return a end
            end
            if BG_IMAGES and BG_IMAGES[idx] then return tostring(BG_IMAGES[idx]) end
            if BG_DEFS[idx] then
                if resolveBgImageSource then
                    return resolveBgImageSource(BG_DEFS[idx].url)
                end
                return BG_DEFS[idx].url
            end
            return ""
        end

        function refreshSelection()
            selectedIndex = math.clamp(selectedIndex, 0, #BG_DEFS)
            hero.Image = getAsset(selectedIndex)
            selectedTitle.Text = selectedIndex == 0 and "NONE" or string.format("IMAGE %02d", selectedIndex)

            active = selectedIndex == (backgroundIndex or 0)
            applyBtn.Text = active and "APPLIED" or "APPLY BACKGROUND"
            applyBtn.BackgroundColor3 = accentBg
            applyBtn.TextColor3 = accent
            applyStroke.Color = accentDark

            for index, ref in pairs(cardRefs) do
                selected = index == selectedIndex
                current = index == (backgroundIndex or 0)
                if ref.stroke then
                    if selected then
                        ref.stroke.Color = Color3.fromRGB(230, 230, 235)
                        ref.stroke.Thickness = 2
                        ref.stroke.Transparency = 0.05
                    elseif current then
                        ref.stroke.Color = Color3.fromRGB(160, 160, 170)
                        ref.stroke.Thickness = 1.5
                        ref.stroke.Transparency = 0.2
                    else
                        ref.stroke.Color = Color3.fromRGB(48, 51, 66)
                        ref.stroke.Thickness = 1
                        ref.stroke.Transparency = 0.3
                    end
                end
                if ref.badge and index ~= 0 then
                    ref.badge.Text = string.format("%02d", index)
                    ref.badge.TextColor3 = current and Color3.fromRGB(235, 235, 240) or Color3.fromRGB(190, 190, 200)
                end
            end
        end

        function closeGallery()
            if closing then return end
            closing = true
            TweenService:Create(blur, TweenInfo.new(0.22), {Size = 0}):Play()
            TweenService:Create(overlay, TweenInfo.new(0.24), {BackgroundTransparency = 1}):Play()
            TweenService:Create(popup, TweenInfo.new(0.26, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
                GroupTransparency = 1, Rotation = 2
            }):Play()
            TweenService:Create(popupScale, TweenInfo.new(0.26, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
                Scale = targetScale * 0.8
            }):Play()
            task.delay(0.28, function()
                pcall(function() if blur then blur:Destroy() end end)
                pcall(function() if modalGui then modalGui:Destroy() end end)
            end)
        end

        local function rebuildBgStrip()
            for _, ch in ipairs(scroll:GetChildren()) do
                if ch:IsA("ImageButton") or ch:IsA("TextButton") then
                    pcall(function() ch:Destroy() end)
                end
            end
            table.clear(cardRefs)

            for idx = 0, #BG_DEFS do
                local card = Instance.new("ImageButton", scroll)
                card.Name = "BG" .. idx
                card.LayoutOrder = idx
                card.Size = UDim2.fromOffset(ITEM_W, ITEM_H)
                card.BackgroundColor3 = Color3.fromRGB(16, 16, 20)
                card.BackgroundTransparency = 0.1
                card.BorderSizePixel = 0
                card.Image = idx == 0 and "" or getAsset(idx)
                card.ImageTransparency = idx == 0 and 1 or 0
                card.ScaleType = Enum.ScaleType.Crop
                card.AutoButtonColor = false
                card.ZIndex = 106
                Instance.new("UICorner", card).CornerRadius = UDim.new(0, 10)

                local cardStroke = Instance.new("UIStroke", card)
                cardStroke.Color = Color3.fromRGB(48, 51, 66)
                cardStroke.Thickness = 1
                cardStroke.Transparency = 0.3

                if idx == 0 then
                    local noneLbl = Instance.new("TextLabel", card)
                    noneLbl.Size = UDim2.fromScale(1, 1)
                    noneLbl.BackgroundTransparency = 1
                    noneLbl.Text = "NONE"
                    noneLbl.TextColor3 = Color3.fromRGB(190, 190, 200)
                    noneLbl.Font = Enum.Font.GothamBold
                    noneLbl.TextSize = 13
                    noneLbl.ZIndex = 107
                    cardRefs[idx] = {stroke = cardStroke}
                else
                    local badge = Instance.new("TextLabel", card)
                    badge.AnchorPoint = Vector2.new(1, 1)
                    badge.Position = UDim2.new(1, -5, 1, -4)
                    badge.Size = UDim2.fromOffset(28, 16)
                    badge.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
                    badge.BackgroundTransparency = 0.45
                    badge.BorderSizePixel = 0
                    badge.Text = string.format("%02d", idx)
                    badge.TextColor3 = Color3.fromRGB(210, 210, 220)
                    badge.Font = Enum.Font.GothamBlack
                    badge.TextSize = 9
                    badge.ZIndex = 108
                    Instance.new("UICorner", badge).CornerRadius = UDim.new(0, 5)
                    cardRefs[idx] = {stroke = cardStroke, badge = badge}

                    if BG_DEFS[idx] and BG_DEFS[idx].custom then
                        local trash = Instance.new("TextButton")
                        trash.Name = "TrashBtn"
                        trash.Size = UDim2.fromOffset(18, 18)
                        trash.Position = UDim2.new(0, 4, 0, 4)
                        trash.BackgroundColor3 = Color3.fromRGB(40, 18, 22)
                        trash.BorderSizePixel = 0
                        trash.Text = "🗑"
                        trash.TextSize = 10
                        trash.TextColor3 = Color3.fromRGB(255, 120, 130)
                        trash.Font = Enum.Font.GothamBold
                        trash.AutoButtonColor = false
                        trash.ZIndex = 110
                        trash.Parent = card
                        Instance.new("UICorner", trash).CornerRadius = UDim.new(1, 0)
                        trash.MouseButton1Click:Connect(function()
                            local removeIdx = idx
                            if selectedIndex == removeIdx then selectedIndex = 0 end
                            _bgRemoveCustom(removeIdx)
                            pcall(saveConfig)
                            rebuildBgStrip()
                            refreshSelection()
                        end)
                    end
                end

                card.MouseButton1Click:Connect(function()
                    selectedIndex = idx
                    refreshSelection()
                    hero.ImageTransparency = 0.25
                    TweenService:Create(hero, TweenInfo.new(0.2, Enum.EasingStyle.Quint), {ImageTransparency = 0}):Play()
                end)
            end

            -- + ADD card (Lovable link or Rbx id)
            do
                local plusCard = Instance.new("TextButton", scroll)
                plusCard.Name = "BGPlus"
                plusCard.LayoutOrder = #BG_DEFS + 1
                plusCard.Size = UDim2.fromOffset(ITEM_W, ITEM_H)
                plusCard.BackgroundColor3 = Color3.fromRGB(14, 18, 24)
                plusCard.BorderSizePixel = 0
                plusCard.Text = ""
                plusCard.AutoButtonColor = false
                plusCard.ZIndex = 106
                Instance.new("UICorner", plusCard).CornerRadius = UDim.new(0, 10)
                local plusStroke = Instance.new("UIStroke", plusCard)
                plusStroke.Color = Color3.fromRGB(70, 90, 120)
                plusStroke.Thickness = 1.4
                plusStroke.Transparency = 0.35

                local plusLbl = Instance.new("TextLabel", plusCard)
                plusLbl.Size = UDim2.new(1, 0, 1, -14)
                plusLbl.Position = UDim2.new(0, 0, 0, 2)
                plusLbl.BackgroundTransparency = 1
                plusLbl.Text = "+"
                plusLbl.TextColor3 = Color3.fromRGB(160, 190, 255)
                plusLbl.Font = Enum.Font.GothamBlack
                plusLbl.TextSize = 26
                plusLbl.ZIndex = 107

                local plusSub = Instance.new("TextLabel", plusCard)
                plusSub.Size = UDim2.new(1, -4, 0, 12)
                plusSub.Position = UDim2.new(0, 2, 1, -14)
                plusSub.BackgroundTransparency = 1
                plusSub.Text = "ADD"
                plusSub.TextColor3 = Color3.fromRGB(140, 160, 190)
                plusSub.Font = Enum.Font.GothamBold
                plusSub.TextSize = 9
                plusSub.ZIndex = 107

                plusCard.MouseEnter:Connect(function()
                    plusCard.BackgroundColor3 = Color3.fromRGB(22, 28, 38)
                    plusStroke.Transparency = 0.15
                end)
                plusCard.MouseLeave:Connect(function()
                    plusCard.BackgroundColor3 = Color3.fromRGB(14, 18, 24)
                    plusStroke.Transparency = 0.35
                end)

                plusCard.MouseButton1Click:Connect(function()
                    pcall(function()
                        local old = modalGui:FindFirstChild("AddBgPrompt")
                        if old then old:Destroy() end
                    end)

                    local prompt = Instance.new("Frame")
                    prompt.Name = "AddBgPrompt"
                    prompt.AnchorPoint = Vector2.new(0.5, 0.5)
                    prompt.Position = UDim2.fromScale(0.5, 0.5)
                    prompt.Size = UDim2.fromOffset(isMobileDevice and 260 or 300, 140)
                    prompt.BackgroundColor3 = Color3.fromRGB(16, 16, 22)
                    prompt.BorderSizePixel = 0
                    prompt.ZIndex = 200
                    prompt.Parent = popup
                    Instance.new("UICorner", prompt).CornerRadius = UDim.new(0, 12)
                    local pst = Instance.new("UIStroke", prompt)
                    pst.Color = Color3.fromRGB(80, 90, 110)
                    pst.Thickness = 1.4

                    local pTitle = Instance.new("TextLabel")
                    pTitle.Size = UDim2.new(1, -20, 0, 20)
                    pTitle.Position = UDim2.new(0, 12, 0, 10)
                    pTitle.BackgroundTransparency = 1
                    pTitle.Text = "ADD BACKGROUND"
                    pTitle.TextColor3 = Color3.fromRGB(230, 230, 240)
                    pTitle.Font = Enum.Font.GothamBold
                    pTitle.TextSize = 12
                    pTitle.TextXAlignment = Enum.TextXAlignment.Left
                    pTitle.ZIndex = 201
                    pTitle.Parent = prompt

                    local pHint = Instance.new("TextLabel")
                    pHint.Size = UDim2.new(1, -20, 0, 14)
                    pHint.Position = UDim2.new(0, 12, 0, 30)
                    pHint.BackgroundTransparency = 1
                    pHint.Text = "obs: Lovable or Rbx id"
                    pHint.TextColor3 = Color3.fromRGB(140, 150, 170)
                    pHint.Font = Enum.Font.GothamMedium
                    pHint.TextSize = 10
                    pHint.TextXAlignment = Enum.TextXAlignment.Left
                    pHint.ZIndex = 201
                    pHint.Parent = prompt

                    local idBox = Instance.new("TextBox")
                    idBox.Size = UDim2.new(1, -24, 0, 32)
                    idBox.Position = UDim2.new(0, 12, 0, 50)
                    idBox.BackgroundColor3 = Color3.fromRGB(8, 8, 12)
                    idBox.BorderSizePixel = 0
                    idBox.PlaceholderText = "https://...lovable...  or  123456789"
                    idBox.Text = ""
                    idBox.TextColor3 = Color3.fromRGB(235, 235, 245)
                    idBox.PlaceholderColor3 = Color3.fromRGB(100, 100, 120)
                    idBox.Font = Enum.Font.GothamMedium
                    idBox.TextSize = 12
                    idBox.ClearTextOnFocus = false
                    idBox.ZIndex = 201
                    idBox.Parent = prompt
                    Instance.new("UICorner", idBox).CornerRadius = UDim.new(0, 8)
                    local idPad = Instance.new("UIPadding", idBox)
                    idPad.PaddingLeft = UDim.new(0, 10)

                    local cancelBtn = Instance.new("TextButton")
                    cancelBtn.Size = UDim2.new(0, 90, 0, 28)
                    cancelBtn.Position = UDim2.new(0, 12, 1, -38)
                    cancelBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
                    cancelBtn.BorderSizePixel = 0
                    cancelBtn.Text = "CANCEL"
                    cancelBtn.TextColor3 = Color3.fromRGB(180, 180, 190)
                    cancelBtn.Font = Enum.Font.GothamBold
                    cancelBtn.TextSize = 11
                    cancelBtn.AutoButtonColor = false
                    cancelBtn.ZIndex = 201
                    cancelBtn.Parent = prompt
                    Instance.new("UICorner", cancelBtn).CornerRadius = UDim.new(0, 7)

                    local addBtn = Instance.new("TextButton")
                    addBtn.Size = UDim2.new(0, 100, 0, 28)
                    addBtn.Position = UDim2.new(1, -112, 1, -38)
                    addBtn.BackgroundColor3 = Color3.fromRGB(40, 55, 90)
                    addBtn.BorderSizePixel = 0
                    addBtn.Text = "ADD"
                    addBtn.TextColor3 = Color3.fromRGB(230, 235, 255)
                    addBtn.Font = Enum.Font.GothamBold
                    addBtn.TextSize = 11
                    addBtn.AutoButtonColor = false
                    addBtn.ZIndex = 201
                    addBtn.Parent = prompt
                    Instance.new("UICorner", addBtn).CornerRadius = UDim.new(0, 7)

                    cancelBtn.MouseButton1Click:Connect(function()
                        pcall(function() prompt:Destroy() end)
                    end)

                    local function doAdd()
                        local okAdd, result = _bgAddCustom(idBox.Text)
                        if not okAdd then
                            idBox.Text = ""
                            idBox.PlaceholderText = tostring(result or "failed")
                            return
                        end
                        selectedIndex = tonumber(result) or selectedIndex
                        pcall(saveConfig)
                        task.spawn(function()
                            local idx = tonumber(result)
                            if idx and BG_DEFS[idx] then
                                pcall(function()
                                    if startBgLoad then startBgLoad() end
                                end)
                                task.wait(0.15)
                                pcall(applyBackgroundImage, idx)
                            end
                        end)
                        pcall(function() prompt:Destroy() end)
                        pcall(rebuildBgStrip)
                        pcall(refreshSelection)
                        if selectedIndex and selectedIndex > 0 then
                            pcall(applyBackgroundImage, selectedIndex)
                        end
                    end

                    addBtn.MouseButton1Click:Connect(doAdd)
                    idBox.FocusLost:Connect(function(enter)
                        if enter then doAdd() end
                    end)
                    task.defer(function()
                        pcall(function() idBox:CaptureFocus() end)
                    end)
                end)
            end

            local total = #BG_DEFS + 2
            scroll.CanvasSize = UDim2.fromOffset(total * ITEM_W + math.max(0, total - 1) * GAP + 12, ITEM_H)
        end

        rebuildBgStrip()

        applyBtn.MouseEnter:Connect(function()
            TweenService:Create(applyScale, TweenInfo.new(0.12), {Scale = 1.03}):Play()
        end)
        applyBtn.MouseLeave:Connect(function()
            TweenService:Create(applyScale, TweenInfo.new(0.12), {Scale = 1}):Play()
        end)

        applyBtn.MouseButton1Click:Connect(function()
            if applyBackgroundImage then
                applyBackgroundImage(selectedIndex)
            end
            applyScale.Scale = 0.94
            TweenService:Create(applyScale, TweenInfo.new(0.18, Enum.EasingStyle.Back), {Scale = 1}):Play()
            task.delay(0.12, closeGallery)
        end)

        overlay.MouseButton1Click:Connect(closeGallery)
        popup.InputBegan:Connect(function() end)

        refreshSelection()

        TweenService:Create(blur, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {Size = 12}):Play()
        TweenService:Create(overlay, TweenInfo.new(0.28), {BackgroundTransparency = 0.35}):Play()
        TweenService:Create(popup, TweenInfo.new(0.4, Enum.EasingStyle.Back), {
            GroupTransparency = 0, Rotation = 0
        }):Play()
        TweenService:Create(popupScale, TweenInfo.new(0.4, Enum.EasingStyle.Back), {Scale = targetScale}):Play()
    end

    function resolveBackgroundRefs()
        if gui and gui:FindFirstChild("MainOuter") then
            inner = gui.MainOuter:FindFirstChild("Inner")
            if inner then
                bgInnerRef = inner
                bgCont = inner:FindFirstChild("BackgroundContainer")
                if bgCont then
                    bgGradRef = bgCont:FindFirstChild("BgGrad")
                    bgImageRef = bgCont:FindFirstChild("BackgroundImage")
                end
            end
        end
    end

    function cancelActiveKeybind()
        if activeKeybindListener then
            pcall(function() activeKeybindListener:Disconnect() end)
            activeKeybindListener = nil
        end
        if activeKeybindBtn and activeKeybindKeyRef then
            activeKeybindBtn.Text = getKeyName(Keys[activeKeybindKeyRef] or Enum.KeyCode.Unknown)
        end
        activeKeybindBtn = nil
        activeKeybindKeyRef = nil
        activeKeybindPrevText = nil
    end

    function getSpeedModeDisplayName()
        if State.laggerMode == 1 then
            return "Carry Lagger Speed"
        elseif State.laggerMode == 2 then
            return "Normal Lagger Speed"
        elseif State.speedMode == 1 then
            return "Carry Speed"
        else
            return "Normal Speed"
        end
    end

    function updateSpeedUI()
        modeText = getSpeedModeDisplayName()
        if toggleRefs.speedCycleLabel then
            toggleRefs.speedCycleLabel.Text = modeText
            toggleRefs.speedCycleLabel.TextColor3 = (State.laggerMode == 0) and C.text or C.textSub
        end
        if _G.__KyzDuelsSpeedHudLabel then
            _G.__KyzDuelsSpeedHudLabel.Text = modeText
        end
        -- keep floating mobile speed buttons in sync (keybind / UI / auto-carry)
        pcall(function()
            if type(syncMobileSpeedButtons) == "function" then
                syncMobileSpeedButtons()
            end
        end)
    end
    function updateThemeUI()
        if toggleRefs.themeCycleLabel then
            displayName = State.gameTheme
            found = false
            for _, name in ipairs(SKY_PRESETS_LIST) do
                if name == State.gameTheme then
                    found = true
                    break
                end
            end
            if not found then
                displayName = "Default"
            end
            toggleRefs.themeCycleLabel.Text = displayName
        end
    end
    function updateTryhardAnimModeUI()
        ref = toggleRefs.tryhardAnimModeLabel
        if type(ref) == "function" then
            pcall(ref, State.tryhardAnimMode, true)
        elseif ref and ref.Text then
            ref.Text = tryhardAnimModeNames[State.tryhardAnimMode] or "V1"
        end
    end
    function updateDropUI()
        ref = toggleRefs.dropCycleLabel
        if type(ref) == "function" then
            pcall(ref, State.dropMode, true)
        elseif ref and ref.Text then
            ref.Text = (dropModeNames and dropModeNames[State.dropMode]) or "Single"
        end
    end
    function syncDropMode()
        Drop.currentType = State.dropMode == 1 and Drop.TYPES.JUMP or Drop.TYPES.STAND
    end
    function syncStealAliases()
        Steal.AutoGrabStopEnabled = autoGrabStopEnabled
        Steal.AutoGrabStopTime = autoGrabStopTime
        Steal.AutoGrabDelayRadius = autoGrabDelayRadius
    end

    for _, name in pairs({"KyzDuels","violetVs","VioletVs","VioletHubOld1","VioletHubOld2"}) do
        pcall(function() local o=CoreGui:FindFirstChild(name); if o then o:Destroy() end end)
        pcall(function() local o=LP:WaitForChild("PlayerGui"):FindFirstChild(name); if o then o:Destroy() end end)
    end

    gui = Instance.new("ScreenGui")
    gui.Name = "KyzDuels"
    gui.ResetOnSpawn = false
    gui.DisplayOrder = 999
    gui.IgnoreGuiInset = true
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Global

    do
        local finished = false
        local function markDone()
            if finished then return end
            finished = true
            pcall(function() introFinishedEvent:Fire() end)
        end
        task.spawn(function()
            local ok, err = pcall(playIntroAnimation)
            if not ok then
                warn("[KyzDuels] intro error:", err)
                markDone()
            end
        end)
        task.delay(7, markDone)
        introFinishedEvent.Event:Wait()
    end

    parentGui(gui)

    C = {
        bg = Color3.fromRGB(12, 12, 14),
        bgDark = Color3.fromRGB(10, 10, 12),
        row = Color3.fromRGB(22, 22, 24),
        input = Color3.fromRGB(18, 18, 20),
        blue = Color3.fromRGB(210, 210, 215),
        blueDim = Color3.fromRGB(90, 90, 95),
        blueDark = Color3.fromRGB(40, 40, 44),
        text = Color3.fromRGB(245, 245, 247),
        textDim = Color3.fromRGB(150, 150, 155),
        textMuted = Color3.fromRGB(120, 120, 125),
        white = Color3.fromRGB(255, 255, 255),
        divider = Color3.fromRGB(90, 90, 95),
        green = Color3.fromRGB(80, 220, 120),
        panel = Color3.fromRGB(16, 16, 18),
        card = Color3.fromRGB(22, 22, 24),
        cardHov = Color3.fromRGB(32, 32, 36),
        border = Color3.fromRGB(180, 180, 185),
        borderDim = Color3.fromRGB(90, 90, 95),
        textSub = Color3.fromRGB(150, 150, 155),
        accent = Color3.fromRGB(210, 210, 215),
        pillOff = Color3.fromRGB(40, 40, 44),
        pillOn = Color3.fromRGB(230, 230, 235),
        dotOff = Color3.fromRGB(150, 150, 155),
        dotOn = Color3.fromRGB(245, 245, 247),
        header = Color3.fromRGB(12, 12, 14),
        chipBg = Color3.fromRGB(28, 28, 30),
        chipText = Color3.fromRGB(245, 245, 247),
    }

    function mkCorner(p,r) local c=Instance.new("UICorner",p); c.CornerRadius=UDim.new(0,r or 10); return c end
    function mkStroke(p,col,th,transp)
        s=Instance.new("UIStroke",p); s.Color=col or C.border; s.Thickness=th or 1
        s.Transparency = transp or 0.72
        s.ApplyStrokeMode=Enum.ApplyStrokeMode.Border; return s
    end
    function tw(obj, props, ti) TweenService:Create(obj, ti or TweenInfo.new(0.12), props):Play() end

    function makeDraggable(frame, handle, force)
        Dragger = {
            src = handle or frame,
            dragging = false,
            dragInput = nil,
            dragStart = nil,
            startPos = nil
        }
        Dragger.src.InputBegan:Connect(function(inp)
            if State.uiLocked and not force then return end
            if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
                Dragger.dragging=true; Dragger.dragStart=inp.Position; Dragger.startPos=frame.Position
            end
        end)
        Dragger.src.InputEnded:Connect(function(inp)
            if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
                Dragger.dragging=false
            end
        end)
        Dragger.src.InputChanged:Connect(function(inp)
            if inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch then Dragger.dragInput = inp end
        end)
        UIS.InputChanged:Connect(function(inp)
            if inp == Dragger.dragInput and Dragger.dragging and (force or not State.uiLocked) then
                dx=inp.Position.X-Dragger.dragStart.X; local dy=inp.Position.Y-Dragger.dragStart.Y
                frame.Position=UDim2.new(
                    Dragger.startPos.X.Scale,
                    Dragger.startPos.X.Offset+dx,
                    Dragger.startPos.Y.Scale,
                    Dragger.startPos.Y.Offset+dy
                )
                State.guiPosition = {
                    X = {Scale = frame.Position.X.Scale, Offset = frame.Position.X.Offset},
                    Y = {Scale = frame.Position.Y.Scale, Offset = frame.Position.Y.Offset}
                }
                task.spawn(saveConfig)
            end
        end)
    end

    isMobileDevice = detectIsMobile()
    _G.__KyzDuelsIsMobile = isMobileDevice
    -- Original size; header shortened (less empty top space)
    WIN_W = isMobileDevice and 240 or 300
    WIN_H = isMobileDevice and 380 or 520
    HEADER_H = isMobileDevice and 44 or 60
    CAT_BAR_H = isMobileDevice and 44 or 36
    mainOuter, miniBtn, contentFrame, dropdownsOverlay = nil, nil, nil, nil
    mobileUIScale = nil

    function createInnerFrame(mainOuter)
        inner = Instance.new("Frame", mainOuter)
        inner.Name = "Inner"
        inner.Size = UDim2.new(1, 0, 1, 0)
        inner.BackgroundColor3 = C.bg
        inner.BackgroundTransparency = 0.25
        inner.BorderSizePixel = 0
        inner.ClipsDescendants = true
        mkCorner(inner, 16)
        mkStroke(inner, C.border, 1, 0.72)
        bgInnerRef = inner
        return inner
    end

    function createBackgroundContainer(inner)
        bgCont = Instance.new("Frame", inner)
        bgCont.Name = "BackgroundContainer"
        bgCont.Size = UDim2.new(1, 0, 1, 0)
        bgCont.BackgroundTransparency = 1
        bgCont.ZIndex = 0

        bgGrad = Instance.new("Frame", bgCont)
        bgGrad.Name = "BgGrad"
        bgGrad.Size = UDim2.new(1, 0, 1, 0)
        bgGrad.BackgroundColor3 = Color3.fromRGB(12, 12, 14)
        bgGrad.BackgroundTransparency = 0.35
        bgGrad.BorderSizePixel = 0
        bgGrad.ZIndex = 0
        mkCorner(bgGrad, 16)
        grad = Instance.new("UIGradient", bgGrad)
        grad.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(18, 18, 20)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(14, 14, 16)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(12, 12, 14)),
        })
        grad.Transparency = NumberSequence.new(0.35)
        grad.Rotation = 135
        bgGradRef = bgGrad

        bgImg = Instance.new("ImageLabel", bgCont)
        bgImg.Name = "BackgroundImage"
        bgImg.Size = UDim2.new(1, 0, 1, 0)
        bgImg.BackgroundTransparency = 1
        bgImg.Image = ""
        bgImg.ScaleType = Enum.ScaleType.Crop
        bgImg.ZIndex = 1
        bgImg.Visible = false
        mkCorner(bgImg, 16)
        bgImageRef = bgImg
        return bgCont
    end

    do
        T = {
            urlDefault = "https://happy-image-link.lovable.app/api/public/f/kx7m2a133.png",
            urlBg03 = "https://happy-image-link.lovable.app/api/public/f/kx7m2a133.png",
            fileDefault = "KyzDuelsTitle_v133.png",
            fileBg03 = "KyzDuelsTitle_v133_bg03.png",
            assetDefault = nil,
            assetBg03 = nil,
        }
        _G.__KyzDuelsTitleAssets = T

        function _loadTitleAsset(url, file)
            asset = nil
            pcall(function()
                if writefile and (game.HttpGet or HttpGet) then
                    need = true
                    pcall(function()
                        if isfile and isfile(file) then need = false end
                    end)
                    if need then
                        data = (_G.__KyzDuelsHttpGet and _G.__KyzDuelsHttpGet(url)) or (game.HttpGet and game:HttpGet(url)) or (HttpGet and HttpGet(url))
                        if data then writefile(file, data) end
                    end
                end
            end)
            pcall(function()
                if getcustomasset and isfile and isfile(file) then
                    asset = getcustomasset(file)
                end
            end)
            return asset or url
        end

        function updateTitleForBackground(index)
            img = _G.__KyzDuelsTitleImg
            if not img or not img.Parent then return end
            idx = tonumber(index) or 0
            if idx == 3 then
                img.Image = T.assetBg03 or T.urlBg03
            else
                img.Image = T.assetDefault or T.urlDefault
            end
        end

        function createTitleLabel(headerFrame)
            local parent = mainOuter or headerFrame
            titleImg = Instance.new("ImageLabel", parent)
            titleImg.Name = "KyzDuelsTitleImg"
            titleImg.AnchorPoint = Vector2.new(0.5, 0)
            titleImg.Position = UDim2.new(0.5, 0, 0, isMobileDevice and -4 or -6)
            local tw = isMobileDevice and 240 or 300
            local th = isMobileDevice and 72 or 90
            titleImg.Size = UDim2.new(0, tw, 0, th)
            titleImg.BackgroundTransparency = 1
            titleImg.Image = ""
            titleImg.ScaleType = Enum.ScaleType.Fit
            titleImg.ZIndex = 25
            titleImg.ClipsDescendants = false
            _G.__KyzDuelsTitleImg = titleImg

            task.spawn(function()
                T.assetDefault = _loadTitleAsset(T.urlDefault, T.fileDefault)
                T.assetBg03 = _loadTitleAsset(T.urlBg03, T.fileBg03)
                bi = (type(backgroundIndex) == "number" and backgroundIndex) or (State and State.backgroundIndex) or 0
                updateTitleForBackground(bi)
            end)

            return titleImg
        end
    end

    function createMinimizeButton(headerFrame)
        minimizeBtn = Instance.new("TextButton", headerFrame)
        minimizeBtn.Size = UDim2.new(0, isMobileDevice and 22 or 26, 0, isMobileDevice and 22 or 26)
        minimizeBtn.Position = UDim2.new(1, isMobileDevice and -28 or -38, 0, isMobileDevice and 6 or 16)
        minimizeBtn.BackgroundColor3 = Color3.fromRGB(22, 22, 24)
        minimizeBtn.BorderSizePixel = 0
        minimizeBtn.Text = "−"
        minimizeBtn.TextColor3 = C.accent
        minimizeBtn.Font = Enum.Font.GothamBold
        minimizeBtn.TextSize = 16
        minimizeBtn.ZIndex = 5
        mkCorner(minimizeBtn, 7)
        mkStroke(minimizeBtn, C.borderDim, 1, 0.45)
        minimizeBtn.MouseEnter:Connect(function() tw(minimizeBtn, {BackgroundColor3 = Color3.fromRGB(32, 32, 36), TextColor3 = C.white}) end)
        minimizeBtn.MouseLeave:Connect(function() tw(minimizeBtn, {BackgroundColor3 = Color3.fromRGB(22, 22, 24), TextColor3 = C.accent}) end)
        return minimizeBtn
    end

    function createMiniButton(mainOuter)
        miniBtn = Instance.new("TextButton", gui)
        miniBtn.Size = UDim2.new(0, 110, 0, 30)
        miniBtn.Position = mainOuter.Position
        miniBtn.BackgroundColor3 = Color3.fromRGB(12, 12, 14)
        miniBtn.BorderSizePixel = 0
        miniBtn.Text = "Kyz Duels"
        miniBtn.TextColor3 = Color3.fromRGB(190, 190, 195)
        miniBtn.Font = Enum.Font.GothamBlack
        miniBtn.TextSize = 14
        miniBtn.ZIndex = 20
        miniBtn.Visible = false
        mkCorner(miniBtn, 10)
        mkStroke(miniBtn, C.border, 1, 0.7)
        makeDraggable(miniBtn, nil, true)
        miniBtn.MouseEnter:Connect(function() tw(miniBtn, {BackgroundColor3 = Color3.fromRGB(22, 22, 24)}) end)
        miniBtn.MouseLeave:Connect(function() tw(miniBtn, {BackgroundColor3 = Color3.fromRGB(12, 12, 14)}) end)
        return miniBtn
    end

    function createHorizontalSeparator(inner)
        hSep = Instance.new("Frame", inner)
        hSep.Name = "HeaderSep"
        hSep.Position = UDim2.new(0, 14, 0, HEADER_H)
        hSep.Size = UDim2.new(1, -28, 0, 1)
        hSep.BackgroundColor3 = C.border
        hSep.BackgroundTransparency = 0.55
        hSep.BorderSizePixel = 0
        hSep.ZIndex = 2
        _G.__KyzDuelsHeaderSep = hSep
        return hSep
    end

    function createContentFrame(inner)
        contentFrame = Instance.new("ScrollingFrame", inner)
        contentFrame.Name = "ContentFrame"
        contentFrame.Size = UDim2.new(1, 0, 1, -(HEADER_H + CAT_BAR_H + 18))
        contentFrame.Position = UDim2.new(0, 0, 0, HEADER_H + 1)
        contentFrame.BackgroundTransparency = 1
        contentFrame.BorderSizePixel = 0
        -- MOBILE: clearer slide so Skin/Player content is easy to drag
        contentFrame.ScrollBarThickness = isMobileDevice and 5 or 6
        contentFrame.ScrollBarImageColor3 = C.accent
        contentFrame.ScrollBarImageTransparency = isMobileDevice and 0.15 or 0.2
        contentFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
        contentFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
        contentFrame.ScrollingDirection = Enum.ScrollingDirection.Y
        contentFrame.ScrollingEnabled = true
        contentFrame.Active = true
        contentFrame.ElasticBehavior = isMobileDevice and Enum.ElasticBehavior.Always or Enum.ElasticBehavior.Never
        contentFrame.VerticalScrollBarInset = Enum.ScrollBarInset.Always
        contentFrame.ZIndex = 2
        contentFrame.ClipsDescendants = true
        return contentFrame
    end

    function createBottomSeparator(inner)
        botSep = Instance.new("Frame", inner)
        botSep.Name = "BottomSep"
        botSep.Position = UDim2.new(0, 8, 1, -(CAT_BAR_H + 10))
        botSep.Size = UDim2.new(1, -16, 0, 1)
        botSep.BackgroundColor3 = C.border
        botSep.BackgroundTransparency = 0.55
        botSep.BorderSizePixel = 0
        botSep.ZIndex = 2
        _G.__KyzDuelsBottomSep = botSep
        return botSep
    end

    CAT_SIDE_W = isMobileDevice and 44 or 50

    function createCategoryBar(inner)
        catBar = Instance.new("Frame", inner)
        catBar.Name = "CategoryBar"
        catBar.Size = UDim2.new(1, -16, 0, CAT_BAR_H)
        catBar.Position = UDim2.new(0, 8, 1, -(CAT_BAR_H + 6))
        catBar.BackgroundColor3 = Color3.fromRGB(32, 32, 38)
        catBar.BackgroundTransparency = 0.55
        catBar.BorderSizePixel = 0
        catBar.ZIndex = 10
        catBar.Active = true
        catBar.ClipsDescendants = true
        mkCorner(catBar, 12)
        -- no heavy dark fill — keep bar light/transparent so hub bg shows through
        mkStroke(catBar, Color3.fromRGB(160, 160, 170), 1, 0.55)
        _G.__KyzDuelsCatBar = catBar
        _G.__KyzDuelsInner = inner

        -- MOBILE ONLY: horizontal ScrollingFrame so categories never overflow the bar
        if isMobileDevice then
            catList = Instance.new("ScrollingFrame", catBar)
            catList.Name = "CategoryList"
            catList.Size = UDim2.new(1, -4, 1, 0)
            catList.Position = UDim2.new(0, 2, 0, 0)
            catList.BackgroundTransparency = 1
            catList.BorderSizePixel = 0
            catList.ScrollBarThickness = 3
            catList.ScrollBarImageColor3 = Color3.fromRGB(200, 200, 210)
            catList.ScrollBarImageTransparency = 0.35
            catList.ScrollingDirection = Enum.ScrollingDirection.X
            catList.CanvasSize = UDim2.new(0, 0, 0, 0)
            catList.AutomaticCanvasSize = Enum.AutomaticSize.X
            catList.ElasticBehavior = Enum.ElasticBehavior.Never
            catList.ScrollingEnabled = true
            catList.Active = true
            catList.Selectable = false
            catList.ClipsDescendants = true
            catList.ZIndex = 10
        else
            catList = Instance.new("Frame", catBar)
            catList.Name = "CategoryList"
            catList.Size = UDim2.new(1, 0, 1, 0)
            catList.BackgroundTransparency = 1
            catList.BorderSizePixel = 0
        end
        _G.__KyzDuelsCatList = catList

        catLay = Instance.new("UIListLayout", catList)
        catLay.Name = "CatLayout"
        catLay.FillDirection = Enum.FillDirection.Horizontal
        catLay.HorizontalAlignment = isMobileDevice and Enum.HorizontalAlignment.Left or Enum.HorizontalAlignment.Center
        catLay.VerticalAlignment = Enum.VerticalAlignment.Center
        catLay.SortOrder = Enum.SortOrder.LayoutOrder
        catLay.Padding = UDim.new(0, isMobileDevice and 4 or 3)
        _G.__KyzDuelsCatLayout = catLay

        catPad = Instance.new("UIPadding", catList)
        catPad.Name = "CatPad"
        catPad.PaddingLeft = UDim.new(0, isMobileDevice and 3 or 4)
        catPad.PaddingRight = UDim.new(0, isMobileDevice and 3 or 4)
        catPad.PaddingTop = UDim.new(0, isMobileDevice and 3 or 4)
        catPad.PaddingBottom = UDim.new(0, isMobileDevice and 3 or 4)
        _G.__KyzDuelsCatPad = catPad
        
        return catList
    end

    function createMainWindow()
        mainOuter = Instance.new("Frame", gui)
        mainOuter.Name = "MainOuter"
        mainOuter.Size = UDim2.new(0, WIN_W, 0, WIN_H)
        mainOuter.Position = UDim2.new(State.guiPosition.X.Scale, State.guiPosition.X.Offset, State.guiPosition.Y.Scale, State.guiPosition.Y.Offset)
        mainOuter.BackgroundTransparency = 1
        mainOuter.BorderSizePixel = 0
        mainOuter.ClipsDescendants = false
        if isMobileDevice then
            mobileUIScale = Instance.new("UIScale")
            mobileUIScale.Scale = 0.90
            mobileUIScale.Parent = mainOuter
        end

        inner = createInnerFrame(mainOuter)
        createBackgroundContainer(inner)
        
        headerFrame = Instance.new("Frame", inner)
        headerFrame.Name = "HeaderFrame"
        headerFrame.Size = UDim2.new(1, 0, 0, HEADER_H)
        headerFrame.BackgroundTransparency = 1
        headerFrame.BorderSizePixel = 0
        headerFrame.ZIndex = 2
        makeDraggable(mainOuter, headerFrame)

        createTitleLabel(headerFrame)
        minimizeBtn = createMinimizeButton(headerFrame)
        createMiniButton(mainOuter)
        createHorizontalSeparator(inner)
        createContentFrame(inner)
        createBottomSeparator(inner)
        catList = createCategoryBar(inner)

        dropdownsOverlay = Instance.new("Frame", mainOuter)
        dropdownsOverlay.Name = "DropdownsOverlay"
        dropdownsOverlay.Size = UDim2.new(1, 0, 1, 0)
        dropdownsOverlay.Position = UDim2.new(0, 0, 0, 0)
        dropdownsOverlay.BackgroundTransparency = 1
        dropdownsOverlay.BorderSizePixel = 0
        dropdownsOverlay.ClipsDescendants = false
        dropdownsOverlay.ZIndex = 999

        return minimizeBtn, catList
    end

    function createSpeedDiscordHud(char)
        char = char or LP.Character
        if not char then return end
        head = char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart")
        if not head then return end

        old = head:FindFirstChild("KyzDuelsSpeedDiscordBillboard")
        if old then old:Destroy() end
        if _G.__KyzDuelsSpeedHudBB and _G.__KyzDuelsSpeedHudBB.Parent then
            pcall(function() _G.__KyzDuelsSpeedHudBB:Destroy() end)
        end

        bb = Instance.new("BillboardGui")
        bb.Name = "KyzDuelsSpeedDiscordBillboard"
        bb.Adornee = head
        bb.Size = UDim2.new(0, 220, 0, 56)
        bb.StudsOffset = Vector3.new(0, 2.6, 0)
        bb.AlwaysOnTop = true
        bb.MaxDistance = 120
        bb.LightInfluence = 0
        bb.Parent = head
        _G.__KyzDuelsSpeedHudBB = bb

        holder = Instance.new("Frame")
        holder.Size = UDim2.new(1, 0, 1, 0)
        holder.BackgroundTransparency = 1
        holder.Parent = bb

        speedLbl = Instance.new("TextLabel")
        speedLbl.Name = "SpeedMode"
        speedLbl.Size = UDim2.new(1, 0, 0, 18)
        speedLbl.Position = UDim2.new(0, 0, 0, 0)
        speedLbl.BackgroundTransparency = 1
        speedLbl.Text = (getSpeedModeDisplayName and getSpeedModeDisplayName()) or "Normal Speed"
        speedLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
        speedLbl.Font = Enum.Font.GothamBlack
        speedLbl.TextSize = 15
        speedLbl.TextXAlignment = Enum.TextXAlignment.Center
        speedLbl.TextStrokeTransparency = 0.35
        speedLbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        speedLbl.Parent = holder
        _G.__KyzDuelsSpeedHudLabel = speedLbl

        line = Instance.new("Frame")
        line.Name = "Sep"
        line.AnchorPoint = Vector2.new(0.5, 0)
        line.Position = UDim2.new(0.5, 0, 0, 22)
        line.Size = UDim2.new(0, 140, 0, 1)
        line.BackgroundColor3 = Color3.fromRGB(220, 220, 225)
        line.BackgroundTransparency = 0.25
        line.BorderSizePixel = 0
        line.Parent = holder

        disc = Instance.new("TextLabel")
        disc.Name = "Discord"
        disc.Size = UDim2.new(1, 0, 0, 16)
        disc.Position = UDim2.new(0, 0, 0, 28)
        disc.BackgroundTransparency = 1
        disc.Text = "discord.gg/pauTcg8prH"
        disc.TextColor3 = Color3.fromRGB(200, 200, 205)
        disc.Font = Enum.Font.GothamMedium
        disc.TextSize = 12
        disc.TextXAlignment = Enum.TextXAlignment.Center
        disc.TextStrokeTransparency = 0.4
        disc.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        disc.Parent = holder
    end

    function setupSpeedDiscordHudOnCharacter()
        pcall(function() createSpeedDiscordHud(LP.Character) end)
        LP.CharacterAdded:Connect(function(char)
            task.wait(0.35)
            pcall(function() createSpeedDiscordHud(char) end)
            pcall(updateSpeedUI)
        end)
    end

    minimizeBtn, categoryList = createMainWindow()
    pcall(setupSpeedDiscordHudOnCharacter)

    function showGui()
        mainOuter.Visible = true
        miniBtn.Visible = false
    end

    function hideGui()
        mainOuter.Visible = false
        miniBtn.Visible = true
        miniBtn.Position = mainOuter.Position
    end

    minimizeBtn.MouseButton1Click:Connect(hideGui)
    miniBtn.MouseButton1Click:Connect(showGui)

    function getDisplayText(value, names)
        if names[value] then
            return names[value]
        end
        for _, name in ipairs(names) do
            if name == value then
                return name
            end
        end
        return "Default"
    end

    StealProgressBar = {
        pbFrame = nil,
        progressPct = nil,
        progressFill = nil,
        dragger = {
            isDragging = false,
            dragStartPos = nil,
            startPos = nil
        }
    }

    function refreshStealBarVisible()
        pcall(function()
            on = (State and State.autoStealEnabled == true)
            if StealProgressBar and StealProgressBar.holder then
                StealProgressBar.holder.Visible = on
            elseif StealProgressBar and StealProgressBar.pbFrame then
                StealProgressBar.pbFrame.Visible = on
            end
            if StealProgressBar and StealProgressBar.statsFrame then
                StealProgressBar.statsFrame.Visible = true
            end
        end)
    end

    function InitUI()
    loCount = 0
    function LO() loCount = loCount + 1; return loCount end
    categoryButtons = {}
    categoryPages = {}
    activeCategoryName = "MAIN"

    function refreshContentCanvas(page)
        lay = page and page:FindFirstChildOfClass("UIListLayout")
        if lay then
            contentFrame.CanvasSize = UDim2.new(0, 0, 0, lay.AbsoluteContentSize.Y + 25)
        end
    end

    function createCategoryButton(name, displayName)
        btn = Instance.new("TextButton", categoryList)
        -- MOBILE: larger touch targets so categories are actually clickable
        local btnW = isMobileDevice and 56 or 52
        local btnTextSz = isMobileDevice and 11 or 9
        btn.Size = UDim2.new(0, btnW, 1, isMobileDevice and -6 or -4)
        btn.BackgroundColor3 = (name == activeCategoryName) and Color3.fromRGB(55, 55, 62) or Color3.fromRGB(42, 42, 48)
        btn.BackgroundTransparency = 0.25
        btn.Text = displayName
        btn.TextColor3 = (name == activeCategoryName) and C.white or C.textDim
        btn.TextSize = btnTextSz
        btn.Font = Enum.Font.GothamBold
        btn.BorderSizePixel = 0
        btn.AutoButtonColor = false
        btn.Active = true
        btn.Selectable = true
        btn.ZIndex = 12
        btn.LayoutOrder = LO()
        mkCorner(btn, isMobileDevice and 8 or 6)

        ind = Instance.new("Frame", btn)
        ind.Name = "indicator"
        ind.Size = UDim2.new(1, -8, 0, 2)
        ind.Position = UDim2.new(0, 4, 1, -3)
        ind.BackgroundColor3 = C.white
        ind.BackgroundTransparency = (name == activeCategoryName) and 0.15 or 1
        ind.BorderSizePixel = 0
        ind.ZIndex = 13
        return btn
    end

    function createCategoryPage(name)
        page = Instance.new("Frame", contentFrame)
        page.Name = "CategoryPage_" .. name
        page.Size = UDim2.new(1, 0, 0, 0)
        page.AutomaticSize = Enum.AutomaticSize.Y
        page.BackgroundTransparency = 1
        page.BorderSizePixel = 0
        page.Visible = (name == activeCategoryName)
        page.ZIndex = 2

        pageLL = Instance.new("UIListLayout", page)
        pageLL.SortOrder = Enum.SortOrder.LayoutOrder
        pageLL.Padding = UDim.new(0, 6)

        pagePad = Instance.new("UIPadding", page)
        pagePad.PaddingLeft = UDim.new(0, 10)
        pagePad.PaddingRight = UDim.new(0, 10)
        pagePad.PaddingTop = UDim.new(0, 10)
        pagePad.PaddingBottom = UDim.new(0, 8)

        pageLL:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            if page.Visible then refreshContentCanvas(page) end
        end)
        return page
    end

    function setupCategoryButtonEvents(btn, name)
        local function activateCategory()
            if activeCategoryName == name then return end
            activeCategoryName = name
            for catName, catPage in pairs(categoryPages) do
                catPage.Visible = (catName == name)
            end
            for catName, catBtn in pairs(categoryButtons) do
                local active = (catName == name)
                catBtn.TextColor3 = active and C.white or C.textDim
                catBtn.BackgroundTransparency = 0.25
                catBtn.BackgroundColor3 = active and Color3.fromRGB(55, 55, 62) or Color3.fromRGB(42, 42, 48)
                local indicator = catBtn:FindFirstChild("indicator")
                if indicator then indicator.BackgroundTransparency = active and 0.1 or 1 end
            end
            refreshContentCanvas(categoryPages[name])
            contentFrame.CanvasPosition = Vector2.new(0, 0)
            pcall(function()
                setPlayerVisualExpanded(name == "PLAYER_VISUAL")
            end)
        end

        -- Mouse + touch (Activated is more reliable on mobile)
        btn.MouseButton1Click:Connect(activateCategory)
        btn.Activated:Connect(activateCategory)

        -- Extra mobile touch fallback (ScrollingFrame sometimes eats MouseButton1Click)
        if isMobileDevice then
            local touchStart = nil
            btn.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.Touch
                    or input.UserInputType == Enum.UserInputType.MouseButton1 then
                    touchStart = input.Position
                end
            end)
            btn.InputEnded:Connect(function(input)
                if not touchStart then return end
                if input.UserInputType == Enum.UserInputType.Touch
                    or input.UserInputType == Enum.UserInputType.MouseButton1 then
                    local delta = (input.Position - touchStart).Magnitude
                    touchStart = nil
                    if delta < 18 then
                        activateCategory()
                    end
                end
            end)
        end

        btn.MouseEnter:Connect(function()
            if activeCategoryName ~= name then
                btn.TextColor3 = C.white
                btn.BackgroundColor3 = Color3.fromRGB(52, 52, 58)
                btn.BackgroundTransparency = 0.15
            end
        end)
        btn.MouseLeave:Connect(function()
            if activeCategoryName ~= name then
                btn.TextColor3 = C.textDim
                btn.BackgroundColor3 = Color3.fromRGB(42, 42, 48)
                btn.BackgroundTransparency = 0.25
            end
        end)
    end

    function createCategory(name, displayName)
        btn = createCategoryButton(name, displayName)
        page = createCategoryPage(name)

        categoryButtons[name] = btn
        categoryPages[name] = page

        setupCategoryButtonEvents(btn, name)

        return page
    end

    tabMain = createCategory("MAIN", "Main")
    tabVisuals = createCategory("VISUALS", "Visuals")
    tabPlayerVisual = createCategory("PLAYER_VISUAL", "Skins")
    tabMobile = createCategory("MOBILE", "Mobile")
    tabSettings = createCategory("SETTINGS", "Settings")
    tabOthers = nil

    tabSpeed = tabMain
    tabCombat = tabMain
    tabSteal = tabMain
    tabMech = tabMain
    tabVis = tabMech
    tabPVis = tabPlayerVisual
    tabTheme = tabVisuals
    -- tabMobile already set above

    mainBtn = categoryButtons["MAIN"]
    if mainBtn then
        mainBtn.TextColor3 = C.white
        mainBtn.BackgroundTransparency = 0.25
        mainBtn.BackgroundColor3 = Color3.fromRGB(55, 55, 62)
        mainInd = mainBtn:FindFirstChild("indicator")
        if mainInd then mainInd.BackgroundTransparency = 0.1 end
    end
    refreshContentCanvas(categoryPages["MAIN"])

    if backgroundIndex > 0 then
        applyBackgroundImage(backgroundIndex)
    else
        updateBackgroundSelection(0)
    end

    function makeSectionHeader(text, parent)
        lbl = Instance.new("TextLabel", parent)
        lbl.Size = UDim2.new(1, 0, 0, 22)
        lbl.BackgroundTransparency = 1
        lbl.Text = text:upper()
        lbl.TextColor3 = C.white
        lbl.Font = Enum.Font.GothamBlack
        lbl.TextSize = 11
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.LayoutOrder = LO()
        lbl.ZIndex = 7
        return lbl
    end

    function createKeybindButtonBase(row, keyRef, options)
        btn = Instance.new("TextButton", row)
        btn.Size = options and options.size or UDim2.new(0, 32, 0, 16)
        btn.Position = options and options.position or UDim2.new(0, 10, 1, -20)
        btn.BackgroundColor3 = Color3.fromRGB(18, 18, 20)
        btn.BackgroundTransparency = 0.15
        btn.BorderSizePixel = 0
        btn.AutoButtonColor = false
        btn.Active = true
        btn.Text = getKeyName(Keys[keyRef] or Enum.KeyCode.Unknown)
        btn.TextColor3 = C.white
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 9
        btn.ZIndex = 10
        mkCorner(btn, 5)
        keybindBtnRefs[keyRef] = btn
        return btn
    end

    function setupKeybindButtonListener(btn, keyRef)
        activeKeybindListener = trackConn(UIS.InputBegan:Connect(function(inp)
            uit = inp.UserInputType
            isPad = uit == Enum.UserInputType.Gamepad1 or uit == Enum.UserInputType.Gamepad2
                or uit == Enum.UserInputType.Gamepad3 or uit == Enum.UserInputType.Gamepad4
                or uit == Enum.UserInputType.Gamepad5 or uit == Enum.UserInputType.Gamepad6
                or uit == Enum.UserInputType.Gamepad7 or uit == Enum.UserInputType.Gamepad8
            if uit == Enum.UserInputType.Keyboard or isPad then
                if inp.KeyCode == Enum.KeyCode.Escape or inp.KeyCode == Enum.KeyCode.ButtonB then
                    cancelActiveKeybind()
                    return
                end
                if inp.KeyCode ~= Enum.KeyCode.Unknown then
                    Keys[keyRef] = inp.KeyCode
                    btn.Text = getKeyName(inp.KeyCode)
                    activeKeybindListener:Disconnect()
                    activeKeybindListener = nil
                    activeKeybindBtn = nil
                    activeKeybindKeyRef = nil
                    task.spawn(saveConfig)
                end
            end
        end))
    end

    function setupKeybindButtonClick(btn, keyRef)
        btn.MouseButton1Click:Connect(function()
            if activeKeybindKeyRef == keyRef then
                cancelActiveKeybind()
                return
            end
            cancelActiveKeybind()
            activeKeybindBtn = btn
            activeKeybindKeyRef = keyRef
            btn.Text = "..."
            setupKeybindButtonListener(btn, keyRef)
        end)
    end

    function createKeybindButton(row, keyRef, options)
        btn = createKeybindButtonBase(row, keyRef, options)
        setupKeybindButtonClick(btn, keyRef)
        return btn
    end

    function addRowHover(row)
        hov = Instance.new("TextButton", row)
        hov.Size = UDim2.new(1, 0, 1, 0)
        hov.BackgroundTransparency = 1
        hov.Text = ""
        hov.ZIndex = 0
        hov.Active = false
        hov.MouseEnter:Connect(function() tw(row, {BackgroundTransparency = 0.08, BackgroundColor3 = C.cardHov}) end)
        hov.MouseLeave:Connect(function() tw(row, {BackgroundTransparency = 0.22, BackgroundColor3 = C.row}) end)
    end

    function makeSpeedRowSetup(label, parent, keyRef)
        row = Instance.new("Frame", parent)
        row.Size = UDim2.new(1, 0, 0, 34)
        row.BackgroundColor3 = C.row
        row.BackgroundTransparency = 0.22
        row.BorderSizePixel = 0
        row.LayoutOrder = LO()
        row.ZIndex = 7
        mkCorner(row, 10)
        mkStroke(row, C.border, 1, 0.82)

        labelX = 10
        if keyRef and Keys[keyRef] then
            createKeybindButton(row, keyRef, {
                size = UDim2.new(0, 34, 0, 20),
                position = UDim2.new(0, 8, 0.5, -10)
            })
            labelX = 48
        end
        return row, labelX
    end

    function makeSpeedRowLabel(row, label, labelX)
        lbl = Instance.new("TextLabel", row)
        lbl.Size = UDim2.new(0.6, 0, 0, 16)
        lbl.Position = UDim2.new(0, labelX, 0.5, -8)
        lbl.BackgroundTransparency = 1
        lbl.Text = label
        lbl.TextColor3 = C.text
        lbl.Font = Enum.Font.GothamBold
        lbl.TextSize = 10
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.ZIndex = 8
        return lbl
    end

    function makeSpeedRowValWrap(row)
        valWrap = Instance.new("Frame", row)
        valWrap.Size = UDim2.new(0, 44, 0, 20)
        valWrap.Position = UDim2.new(1, -52, 0.5, -10)
        valWrap.BackgroundColor3 = Color3.fromRGB(18, 18, 20)
        valWrap.BackgroundTransparency = 0.15
        valWrap.BorderSizePixel = 0
        valWrap.ZIndex = 8
        mkCorner(valWrap, 6)
        mkStroke(valWrap, C.borderDim, 1)
        return valWrap
    end

    function makeSpeedRowValBox(valWrap, stateKey)
        valBox = Instance.new("TextBox", valWrap)
        valBox.Size = UDim2.new(1, 0, 1, 0)
        valBox.BackgroundTransparency = 1
        valBox.Text = tostring(State[stateKey])
        valBox.TextColor3 = C.text
        valBox.Font = Enum.Font.GothamBold
        valBox.TextSize = 10
        valBox.ClearTextOnFocus = false
        valBox.ZIndex = 9
        return valBox
    end

    function setupSpeedRowValBoxFocus(valBox, stateKey)
        function commit()
            n = tonumber(valBox.Text)
            if n and n >= 0.1 and n <= 500 then
                State[stateKey] = n
                if _G.State then _G.State[stateKey] = n end
                valBox.Text = tostring(n)
                _lastWalkSpeedApplied = -1
                task.spawn(saveConfig)
                return true
            end
            return false
        end
        valBox.FocusLost:Connect(function()
            if not commit() then
                valBox.Text = tostring(State[stateKey])
            end
        end)
        valBox:GetPropertyChangedSignal("Text"):Connect(function()
            n = tonumber(valBox.Text)
            if n and n >= 0.1 and n <= 500 then
                State[stateKey] = n
                if _G.State then _G.State[stateKey] = n end
            end
        end)
        speedBoxRefs[stateKey] = valBox
    end

    function makeSpeedRow(label, stateKey, parent, keyRef)
        local row, labelX = makeSpeedRowSetup(label, parent, keyRef)
        makeSpeedRowLabel(row, label, labelX)
        valWrap = makeSpeedRowValWrap(row)
        valBox = makeSpeedRowValBox(valWrap, stateKey)
        setupSpeedRowValBoxFocus(valBox, stateKey)
        addRowHover(row)
        return valBox
    end

    function makeKeybindRowSetup(label, parent)
        row = Instance.new("Frame", parent)
        row.Size = UDim2.new(1, 0, 0, 40)
        row.BackgroundColor3 = C.row
        row.BackgroundTransparency = 0.22
        row.BorderSizePixel = 0
        row.LayoutOrder = LO()
        row.ZIndex = 7
        mkCorner(row, 10)
        mkStroke(row, C.border, 1, 0.82)

        lbl = Instance.new("TextLabel", row)
        lbl.Size = UDim2.new(0.55, 0, 0, 16)
        lbl.Position = UDim2.new(0, 10, 0, 8)
        lbl.BackgroundTransparency = 1
        lbl.Text = label
        lbl.TextColor3 = C.text
        lbl.Font = Enum.Font.GothamBold
        lbl.TextSize = 10
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.ZIndex = 8
        return row
    end

    function makeKeybindRow(label, keyRef, parent)
        row = makeKeybindRowSetup(label, parent)
        btn = createKeybindButton(row, keyRef, {
            size = UDim2.new(0, 38, 0, 22),
            position = UDim2.new(1, -46, 0.5, -11)
        })
        addRowHover(row)
        return btn
    end

    panelsRegistry = {}

    function closeAllDropdownPanels(except)
        for _, p in ipairs(panelsRegistry) do
            if p and p.panel and p.panel ~= except then
                p.panel.Visible = false
                if p.arrow then
                    p.arrow.Text = "▼"
                    p.arrow.TextColor3 = C.textDim
                end
            end
        end
    end

    function makeCycleRow(label, stateKey, names, onCycle, parent, valueMap, readOnly)
        row = Instance.new("Frame", parent)
        row.Size = UDim2.new(1, 0, 0, 36)
        row.BackgroundColor3 = C.row
        row.BackgroundTransparency = 0.22
        row.BorderSizePixel = 0
        row.LayoutOrder = LO()
        row.ZIndex = 7
        mkCorner(row, 10)
        mkStroke(row, C.border, 1, 0.82)

        lbl = Instance.new("TextLabel", row)
        lbl.Size = UDim2.new(0.42, 0, 0, 16)
        lbl.Position = UDim2.new(0, 10, 0, 10)
        lbl.BackgroundTransparency = 1
        lbl.Text = label
        lbl.TextColor3 = C.text
        lbl.Font = Enum.Font.GothamBold
        lbl.TextSize = 10
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.ZIndex = 8

        local trigger
        if readOnly then
            trigger = Instance.new("TextLabel", row)
            trigger.Name = "Trigger"
            trigger.Active = false
            trigger.Text = ""
        else
            trigger = Instance.new("TextButton", row)
            trigger.Name = "Trigger"
            trigger.AutoButtonColor = false
            trigger.Text = ""
        end
        trigger.Size = UDim2.new(0, 150, 0, 22)
        trigger.Position = UDim2.new(1, -158, 0.5, -11)
        trigger.BackgroundColor3 = Color3.fromRGB(18, 18, 20)
        trigger.BackgroundTransparency = 0.05
        trigger.BorderSizePixel = 0
        trigger.ZIndex = 10
        mkCorner(trigger, 10)
        mkStroke(trigger, C.borderDim, 1)

        valText = Instance.new("TextLabel", trigger)
        valText.Name = "Val"
        valText.Size = UDim2.new(1, readOnly and -16 or -28, 1, 0)
        valText.Position = UDim2.new(0, 8, 0, 0)
        valText.BackgroundTransparency = 1
        valText.Text = ""
        valText.TextColor3 = C.white
        valText.Font = Enum.Font.GothamBold
        valText.TextSize = 10
        valText.TextXAlignment = Enum.TextXAlignment.Center
        valText.TextTruncate = Enum.TextTruncate.AtEnd
        valText.ZIndex = 11

        local arrow
        if not readOnly then
            arrow = Instance.new("TextLabel", trigger)
            arrow.Name = "Arrow"
            arrow.Size = UDim2.new(0, 14, 0, 14)
            arrow.Position = UDim2.new(1, -16, 0.5, -7)
            arrow.BackgroundTransparency = 1
            arrow.Text = "▼"
            arrow.TextColor3 = C.textDim
            arrow.Font = Enum.Font.GothamBold
            arrow.TextSize = 9
            arrow.ZIndex = 11
        end

        function findCurrentIdx()
            if valueMap then
                for i, v in ipairs(valueMap) do
                    if State[stateKey] == v then return i end
                end
                return 1
            else
                n = State[stateKey]
                if type(n) == "number" and n >= 1 and n <= #names then return n end
                if type(n) == "number" and n >= 0 and n < #names then return n + 1 end
                for i, nm in ipairs(names) do
                    if nm == State[stateKey] then return i end
                end
                return 1
            end
        end

        function getValue(idx)
            if valueMap then return valueMap[idx] end
            cur = State[stateKey]
            if type(cur) == "number" and cur >= 0 and cur < #names and not (cur >= 1 and cur <= #names and names[cur] and cur == findCurrentIdx()) then
            end
            if type(State[stateKey]) == "number" and State[stateKey] >= 0 and State[stateKey] < #names then
                zeroBased = false
                for _, k in ipairs({"tryhardAnimMode", "dropMode", "speedMode", "laggerMode"}) do
                    if stateKey == k then zeroBased = true break end
                end
                if zeroBased then return idx - 1 end
            end
            return idx
        end

        selectedIdx = findCurrentIdx()
        valText.Text = names[selectedIdx] or "Default"

        local panel
        if not readOnly then
            host = gui or dropdownsOverlay or mainOuter
            panel = Instance.new("Frame")
            panel.Name = "DropdownPanel_" .. tostring(stateKey)
            panel.BackgroundColor3 = Color3.fromRGB(16, 16, 18)
            panel.BackgroundTransparency = 0
            panel.BorderSizePixel = 0
            panel.Visible = false
            panel.ZIndex = 5000
            panel.ClipsDescendants = false
            panel.Parent = host
            mkCorner(panel, 10)
            mkStroke(panel, C.accent or Color3.fromRGB(180, 180, 185), 1, 0.5)

            pad = Instance.new("UIPadding", panel)
            pad.PaddingLeft = UDim.new(0, 6)
            pad.PaddingRight = UDim.new(0, 6)
            pad.PaddingTop = UDim.new(0, 6)
            pad.PaddingBottom = UDim.new(0, 6)

            panelList = Instance.new("UIListLayout", panel)
            panelList.SortOrder = Enum.SortOrder.LayoutOrder
            panelList.Padding = UDim.new(0, 4)
            panelList.HorizontalAlignment = Enum.HorizontalAlignment.Center

            panelsRegistry[#panelsRegistry + 1] = { panel = panel, arrow = arrow, trigger = trigger }

            optionBtns = {}
            optH = 24
            for i = 1, #names do
                displayName = names[i]
                btn = Instance.new("TextButton", panel)
                btn.Name = "Opt" .. i
                btn.AutoButtonColor = false
                btn.Text = displayName
                btn.BorderSizePixel = 0
                btn.LayoutOrder = i
                btn.ZIndex = 5001
                btn.Size = UDim2.new(1, 0, 0, optH)
                btn.Font = Enum.Font.GothamBold
                btn.TextSize = 11
                btn.TextColor3 = (i == selectedIdx) and (C.accent or Color3.fromRGB(210, 210, 215)) or Color3.fromRGB(245, 245, 247)
                btn.BackgroundColor3 = Color3.fromRGB(28, 28, 32)
                btn.BackgroundTransparency = 0.1
                mkCorner(btn, 8)

                btn.MouseButton1Click:Connect(function()
                    selectedIdx = i
                    val = getValue(i)
                    if valueMap then
                        State[stateKey] = valueMap[i]
                    else
                        zeroBased = false
                        for _, k in ipairs({"tryhardAnimMode", "dropMode", "speedMode", "laggerMode"}) do
                            if stateKey == k then zeroBased = true break end
                        end
                        if zeroBased then
                            State[stateKey] = i - 1
                        else
                            State[stateKey] = i
                        end
                    end
                    valText.Text = names[i] or "Default"
                    for j, b in ipairs(optionBtns) do
                        b.TextColor3 = (j == i) and (C.accent or Color3.fromRGB(210, 210, 215)) or Color3.fromRGB(245, 245, 247)
                    end
                    panel.Visible = false
                    if arrow then
                        arrow.Text = "▼"
                        arrow.TextColor3 = C.textDim
                    end
                    if type(onCycle) == "function" then
                        task.spawn(onCycle)
                    end
                    task.spawn(saveConfig)
                end)

                btn.MouseEnter:Connect(function()
                    btn.BackgroundTransparency = 0
                end)
                btn.MouseLeave:Connect(function()
                    btn.BackgroundTransparency = 0.1
                end)
                optionBtns[i] = btn
            end

            function positionPanelUnderTrigger()
                trgAbs = trigger.AbsolutePosition
                trgSz = trigger.AbsoluteSize
                width = math.max(trgSz.X, 140)
                height = (#names * (optH + 4)) + 8
                panel.Size = UDim2.fromOffset(width, height)
                x = trgAbs.X
                y = trgAbs.Y + trgSz.Y + 4
                if panel.Parent == mainOuter then
                    o = mainOuter.AbsolutePosition
                    x = trgAbs.X - o.X
                    y = trgAbs.Y - o.Y + trgSz.Y + 4
                elseif panel.Parent == dropdownsOverlay and mainOuter then
                    o = mainOuter.AbsolutePosition
                    x = trgAbs.X - o.X
                    y = trgAbs.Y - o.Y + trgSz.Y + 4
                end
                panel.Position = UDim2.fromOffset(x, y)
                panel.ZIndex = 5000
            end

            trigger.MouseButton1Click:Connect(function()
                open = not panel.Visible
                closeAllDropdownPanels(panel)
                panel.Visible = open
                if arrow then
                    arrow.Text = open and "▲" or "▼"
                    arrow.TextColor3 = open and C.white or C.textDim
                end
                if open then
                    positionPanelUnderTrigger()
                    task.defer(positionPanelUnderTrigger)
                end
            end)

            UIS.InputBegan:Connect(function(input)
                if not panel.Visible then return end
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    local ix, iy = input.Position.X, input.Position.Y
                    local tp, ts = trigger.AbsolutePosition, trigger.AbsoluteSize
                    local pp, ps = panel.AbsolutePosition, panel.AbsoluteSize
                    function inr(px, py, r, s)
                        return px >= r.X and px <= r.X + s.X and py >= r.Y and py <= r.Y + s.Y
                    end
                    if not inr(ix, iy, tp, ts) and not inr(ix, iy, pp, ps) then
                        panel.Visible = false
                        if arrow then
                            arrow.Text = "▼"
                            arrow.TextColor3 = C.textDim
                        end
                    end
                end
            end)
        end

        addRowHover(row)
        return valText
    end

    function makeToggleRowSetup(label, parent, hasKB)
        row = Instance.new("Frame", parent)
        row.Size = UDim2.new(1, 0, 0, 34)
        row.BackgroundColor3 = C.row
        row.BackgroundTransparency = 0.22
        row.BorderSizePixel = 0
        row.LayoutOrder = LO()
        row.ZIndex = 7
        mkCorner(row, 10)
        mkStroke(row, C.border, 1, 0.82)

        labelX = hasKB and 48 or 12
        lbl = Instance.new("TextLabel", row)
        lbl.Size = UDim2.new(0.58, 0, 1, 0)
        lbl.Position = UDim2.new(0, labelX, 0, 0)
        lbl.BackgroundTransparency = 1
        lbl.Text = label
        lbl.TextColor3 = C.white
        lbl.Font = Enum.Font.GothamBold
        lbl.TextSize = 12
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.ZIndex = 8

        return row, lbl
    end

    function makeToggleRowToggle(row, defaultOn, hasKB)
        local track = Instance.new("Frame", row)
        track.Size = UDim2.new(0, 40, 0, 20)
        track.Position = UDim2.new(1, -52, 0.5, -10)
        track.BackgroundColor3 = defaultOn and Color3.fromRGB(235, 235, 240) or Color3.fromRGB(40, 40, 44)
        track.BackgroundTransparency = 0
        track.BorderSizePixel = 0
        track.ZIndex = 8
        mkCorner(track, 10)

        local knob = Instance.new("Frame", track)
        knob.Size = UDim2.new(0, 14, 0, 14)
        knob.Position = defaultOn and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7)
        knob.BackgroundColor3 = defaultOn and Color3.fromRGB(20, 20, 22) or C.textDim
        knob.BackgroundTransparency = 0
        knob.BorderSizePixel = 0
        knob.ZIndex = 9
        mkCorner(knob, 7)
        return knob, track
    end

    function makeToggleSetFunction(knob, onToggle, state, track)
        return function(on, isSync)
            state.toggled = on and true or false
            local targetPos = state.toggled and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7)
            local knobCol = state.toggled and Color3.fromRGB(20, 20, 22) or Color3.fromRGB(150, 150, 155)
            local trackCol = state.toggled and Color3.fromRGB(235, 235, 240) or Color3.fromRGB(40, 40, 44)
            if track then
                track.BackgroundTransparency = 0
                track.BackgroundColor3 = trackCol
            end
            if knob then
                knob.BackgroundTransparency = 0
                knob.BackgroundColor3 = knobCol
                knob.Position = targetPos
            end
            pcall(onToggle, state.toggled, isSync == true)
            -- Always autosave on user toggle (covers every option)
            if not isSync then
                pcall(function()
                    if type(autoSave) == "function" then
                        autoSave()
                    elseif type(saveConfig) == "function" then
                        saveConfig()
                    end
                end)
            end
        end
    end


    function makeToggleButton(row, hasKB, set, state)
        local toggleBtn = Instance.new("TextButton", row)
        toggleBtn.Size = UDim2.new(0, 40, 0, 20)
        toggleBtn.Position = UDim2.new(1, -52, 0.5, -10)
        toggleBtn.BackgroundTransparency = 1
        toggleBtn.Text = ""
        toggleBtn.ZIndex = 10
        toggleBtn.MouseButton1Click:Connect(function()
            set(not state.toggled)
        end)
        return toggleBtn
    end

    function makeToggleRowBtn(row, knob, onToggle, defaultOn, hasKB, track)
        local state = { toggled = defaultOn and true or false }
        local set = makeToggleSetFunction(knob, onToggle, state, track)
        local toggleBtn = makeToggleButton(row, hasKB, set, state)
        return set, toggleBtn
    end

    function makeToggleRow(label, defaultOn, onToggle, keyRef, parent)
        hasKB = keyRef ~= nil and Keys[keyRef] ~= nil
        local row, lbl = makeToggleRowSetup(label, parent, hasKB)
        local knob, track = makeToggleRowToggle(row, defaultOn, hasKB)
        if hasKB then
            createKeybindButton(row, keyRef, {
                size = UDim2.new(0, 34, 0, 20),
                position = UDim2.new(0, 8, 0.5, -10)
            })
        end
        local set, toggleBtn = makeToggleRowBtn(row, knob, onToggle, defaultOn, hasKB, track)
        addRowHover(row)
        return set, lbl
    end

    function makeMomentaryRowSetup(label, parent)
        row = Instance.new("Frame", parent)
        row.Size = UDim2.new(1, 0, 0, 40)
        row.BackgroundColor3 = C.row
        row.BackgroundTransparency = 0.22
        row.BorderSizePixel = 0
        row.LayoutOrder = LO()
        row.ZIndex = 7
        mkCorner(row, 10)
        mkStroke(row, C.border, 1, 0.82)

        lbl = Instance.new("TextLabel", row)
        lbl.Size = UDim2.new(0.55, 0, 0, 16)
        lbl.Position = UDim2.new(0, 10, 0, 8)
        lbl.BackgroundTransparency = 1
        lbl.Text = label
        lbl.TextColor3 = C.text
        lbl.Font = Enum.Font.GothamBold
        lbl.TextSize = 10
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.ZIndex = 8
        return row
    end

    function makeMomentaryTrigger(row, onTrigger)
        return function()
            tw(row, {BackgroundTransparency = 0.1}, TweenInfo.new(0.08))
            onTrigger()
            task.delay(0.12, function() tw(row, {BackgroundTransparency = 0.18}, TweenInfo.new(0.08)) end)
        end
    end

    function makeMomentaryRowAction(row, onTrigger)
        actionBtn = Instance.new("TextButton", row)
        actionBtn.Size = UDim2.new(0.55, 0, 1, 0)
        actionBtn.BackgroundTransparency = 1
        actionBtn.Text = ""
        actionBtn.ZIndex = 9

        trigger = makeMomentaryTrigger(row, onTrigger)
        actionBtn.MouseButton1Click:Connect(trigger)
        return trigger
    end

    function makeMomentaryRow(label, onTrigger, keyRef, parent)
        row = makeMomentaryRowSetup(label, parent)
        if keyRef and Keys[keyRef] then
            createKeybindButton(row, keyRef, {
                size = UDim2.new(0, 38, 0, 22),
                position = UDim2.new(1, -46, 0.5, -11)
            })
        end
        trigger = makeMomentaryRowAction(row, onTrigger)
        addRowHover(row)
        return trigger
    end

    function makeInputRowSetup(label, parent)
        row = Instance.new("Frame", parent)
        row.Size = UDim2.new(1, 0, 0, 34)
        row.BackgroundColor3 = C.row
        row.BackgroundTransparency = 0.4
        row.BorderSizePixel = 0
        row.LayoutOrder = LO()
        row.ZIndex = 7
        mkCorner(row, 10)
        mkStroke(row, C.border, 1, 0.82)

        title = Instance.new("TextLabel", row)
        title.Size = UDim2.new(0.6, 0, 0, 16)
        title.Position = UDim2.new(0, 10, 0, 5)
        title.BackgroundTransparency = 1
        title.Text = label
        title.TextColor3 = C.text
        title.Font = Enum.Font.GothamBold
        title.TextSize = 10
        title.TextXAlignment = Enum.TextXAlignment.Left
        title.ZIndex = 8
        return row, title
    end

    function makeInputRowVal(row, defaultVal, onEnter)
        valWrap = Instance.new("Frame", row)
        valWrap.Size = UDim2.new(0, 44, 0, 20)
        valWrap.Position = UDim2.new(1, -52, 0.5, -10)
        valWrap.BackgroundColor3 = Color3.fromRGB(18, 18, 20)
        valWrap.BackgroundTransparency = 0.15
        valWrap.BorderSizePixel = 0
        valWrap.ZIndex = 8
        mkCorner(valWrap, 6)
        mkStroke(valWrap, C.borderDim, 1)

        valBox = Instance.new("TextBox", valWrap)
        valBox.Size = UDim2.new(1, 0, 1, 0)
        valBox.BackgroundTransparency = 1
        valBox.Text = tostring(defaultVal)
        valBox.TextColor3 = C.text
        valBox.Font = Enum.Font.GothamBold
        valBox.TextSize = 10
        valBox.ClearTextOnFocus = false
        valBox.ZIndex = 9
        valBox.FocusLost:Connect(function()
            n = tonumber(valBox.Text)
            if n then onEnter(n) end
        end)
        return valBox
    end

    function makeInputRow(label, defaultVal, onEnter, parent)
        local row, title = makeInputRowSetup(label, parent)
        valBox = makeInputRowVal(row, defaultVal, onEnter)
        addRowHover(row)
        return valBox
    end

    function makeLine(parent)
        line = Instance.new("Frame", parent)
        line.Size = UDim2.new(1, 0, 0, 1)
        line.BackgroundColor3 = C.border
        line.BackgroundTransparency = 0.65
        line.BorderSizePixel = 0
        line.LayoutOrder = LO()
        line.ZIndex = 7
    end

    function setupSpeedTabRow1()
        makeSpeedRow("Normal Speed", "normalSpeed", tabSpeed, "speed")
    end
    function setupSpeedTabRow2()
        makeSpeedRow("Carry Speed", "carrySpeed", tabSpeed)
    end
    function setupSpeedTabRow3()
        makeSpeedRow("Normal Lagger Speed", "normalLaggerSpeed", tabSpeed, "lagger")
    end
    function setupSpeedTabRow4()
        makeSpeedRow("Carry Lagger Speed", "laggerSpeed", tabSpeed)
    end
    function setupSpeedTabCycle()
    end
    function setupSpeedTab()
        makeSectionHeader("SPEED", tabSpeed)
        setupSpeedTabRow1()
        setupSpeedTabRow2()
        setupSpeedTabRow3()
        setupSpeedTabRow4()
        toggleRefs.autoCarrySpeed = makeToggleRow("Auto Carry On Steal", State.autoCarrySpeedEnabled, function(on, isSync)
            State.autoCarrySpeedEnabled = on
            if not on then
                pcall(disableAutoCarrySpeed)
            end
            if not isSync then task.spawn(saveConfig) end
        end, nil, tabSpeed)
        makeLine(tabSpeed)
    end

    _aimbotTarget = nil
    tpBatConn = nil

    BAT_SLAP_LIST = {"Bat","Slap","Iron Slap","Gold Slap","Diamond Slap","Emerald Slap","Ruby Slap","Dark Matter Slap","Flame Slap","Nuclear Slap","Galaxy Slap","Glitched Slap"}

    function findAnyTool()
        c = LP.Character
        if c then
            for _, v in ipairs(c:GetChildren()) do
                if v:IsA("Tool") then return v end
            end
        end
        bp = LP:FindFirstChildOfClass("Backpack")
        if bp then
            for _, v in ipairs(bp:GetChildren()) do
                if v:IsA("Tool") then return v end
            end
        end
        return nil
    end

    function findBat()
        char = LP.Character
        if not char then return nil end
        for _, name in ipairs(BAT_SLAP_LIST) do
            t = char:FindFirstChild(name)
            if t and t:IsA("Tool") then return t end
        end
        bp = LP:FindFirstChildOfClass("Backpack")
        if bp then
            for _, name in ipairs(BAT_SLAP_LIST) do
                t = bp:FindFirstChild(name)
                if t and t:IsA("Tool") then return t end
            end
        end
        for _, ch in ipairs(char:GetChildren()) do
            if ch:IsA("Tool") then
                n = ch.Name:lower()
                if n:find("bat") or n:find("slap") then return ch end
            end
        end
        return nil
    end

    function swingCurrentBat()
        if not State.autoSwingEnabled then return end
        bat = findBat()
        if bat and bat.Parent == LP.Character and bat:IsA("Tool") then
            pcall(function() bat:Activate() end)
            pcall(_batCustomEnsureSwingOnHit)
        end
    end

    function trySwing()
        if not State.autoSwingEnabled then return end
        bat = findBat()
        if bat and bat.Parent == LP.Character and bat:IsA("Tool") then
            pcall(function() bat:Activate() end)
            pcall(_batCustomEnsureSwingOnHit)
        end
    end



    -- ============================================================
    -- Player Position Marker (standalone logic, always on)
    -- rangeUp 60 / rangeSide 65
    -- ============================================================
    -- Player Pos Marker REMOVED (ghost doll / pos mark on players)
    local _ppm = { enabled = false, track = {}, folder = nil }
    local function ppmWipeFolder()
        pcall(function()
            local old = workspace:FindFirstChild("VioletPlayerPosMarks")
            if old then old:Destroy() end
        end)
        _ppm.folder = nil
        _ppm.track = {}
    end
    ppmWipeFolder()

    function setPlayerPosMarker(on)
        _ppm.enabled = false
        if State then State.playerPosMarker = false end
        ppmWipeFolder()
    end

    function getPlayerMarkPos(plr)
        return nil
    end

    function getPlayerCombatPos(plr)
        -- real character position only (no ghost mark)
        if not plr then return nil, false end
        local c = plr.Character
        local hrp = c and c:FindFirstChild("HumanoidRootPart")
        if hrp then return hrp.Position, false end
        return nil, false
    end

    _G.__VioletPlayerPosMarker = {
        setEnabled = setPlayerPosMarker,
        getMarkPos = getPlayerMarkPos,
        getCombatPos = getPlayerCombatPos,
        State = _ppm,
        destroy = function()
            setPlayerPosMarker(false)
        end,
    }


    function getClosestTarget()
        root = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
        if not root then return nil, math.huge, nil, nil end
        local closest, minDist, closestPlr, combatPos = nil, math.huge, nil, nil
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LP then
                local hum = plr.Character and plr.Character:FindFirstChildOfClass("Humanoid")
                local tRoot = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
                -- allow mark even if char is desynced / dead-looking
                local cpos, isMark = nil, false
                if type(getPlayerCombatPos) == "function" then
                    cpos, isMark = getPlayerCombatPos(plr)
                end
                if not cpos and tRoot then cpos = tRoot.Position end
                if cpos and (isMark or (hum and hum.Health > 0 and tRoot)) then
                    local dist = (cpos - root.Position).Magnitude
                    if dist < minDist then
                        minDist = dist
                        closest = tRoot
                        closestPlr = plr
                        combatPos = cpos
                    end
                end
            end
        end
        return closest, minDist, combatPos, closestPlr
    end

    function tryHitBat()
        if State.hittingCooldown then return end
        State.hittingCooldown = true
        pcall(function()
            c = LP.Character
            if not c then return end
            hum2 = c:FindFirstChildOfClass("Humanoid")
            tool = findAnyTool()
            if tool then
                if tool.Parent ~= c and hum2 then
                    pcall(function() hum2:EquipTool(tool) end)
                end
                remote = tool:FindFirstChildOfClass("RemoteEvent")
                if remote then
                    pcall(function() remote:FireServer() end)
                end
                pcall(function() tool:Activate() end)
                pcall(_batCustomEnsureSwingOnHit)
            end
        end)
        task.delay(State.SwingCooldown or 0.08, function()
            State.hittingCooldown = false
        end)
    end

    function getExactBat()
        char = LP.Character
        if not char then return nil end
        tool = char:FindFirstChild("Bat")
        if tool and tool:IsA("Tool") then return tool end
        bp = LP:FindFirstChild("Backpack") or LP:FindFirstChildOfClass("Backpack")
        if bp then
            tool = bp:FindFirstChild("Bat")
            if tool and tool:IsA("Tool") then return tool end
        end
        return nil
    end

    function tryHitExactBat()
        if State.hittingCooldown then return end
        State.hittingCooldown = true
        pcall(function()
            c = LP.Character
            if not c then return end
            hum2 = c:FindFirstChildOfClass("Humanoid")
            bat = getExactBat()
            if not bat then return end
            if bat.Parent ~= c and hum2 then
                pcall(function() hum2:EquipTool(bat) end)
            end
            for _, t in ipairs(c:GetChildren()) do
                if t:IsA("Tool") and t ~= bat then
                    pcall(function()
                        bp = LP:FindFirstChild("Backpack") or LP:FindFirstChildOfClass("Backpack")
                        if bp then t.Parent = bp end
                    end)
                end
            end
            if bat.Parent ~= c and hum2 then
                pcall(function() hum2:EquipTool(bat) end)
            end
            pcall(function() bat:Activate() end)
            ev = bat:FindFirstChildWhichIsA("RemoteEvent")
            if ev then pcall(function() ev:FireServer() end) end
        end)
        task.delay(State.SwingCooldown or 0.08, function()
            State.hittingCooldown = false
        end)
    end

    do
        V = {
            on = false, conn = nil, h = nil, hrp = nil, hittingCooldown = false,
            tools = {"Bat","Slap","Iron Slap","Gold Slap","Diamond Slap","Emerald Slap","Ruby Slap","Dark Matter Slap","Flame Slap","Nuclear Slap","Galaxy Slap","Glitched Slap"},
            antiOn = false, antiHRP = nil, antiFake = nil, antiConn = nil, antiY = -9999,
        }
        _G.__KyzDuelsBatV3 = V

        function getBat()
            char = LP.Character
            if not char then return nil end
            for i = 1, #V.tools do
                tool = char:FindFirstChild(V.tools[i])
                if tool and tool:IsA("Tool") then return tool end
            end
            bp = LP:FindFirstChildOfClass("Backpack")
            if bp then
                for i = 1, #V.tools do
                    tool = bp:FindFirstChild(V.tools[i])
                    if tool and tool:IsA("Tool") then
                        tool.Parent = char
                        return tool
                    end
                end
            end
            for _, t in ipairs(char:GetChildren()) do
                if t:IsA("Tool") then
                    n = t.Name:lower()
                    if n:find("bat") or n:find("slap") then return t end
                end
            end
            return nil
        end

        -- Vision-style bat hit (always swings when Tp Bat is on)
        function trySwing()
            if V.hittingCooldown then return end
            if not State.tpBatEnabled and not State.autoSwingEnabled then return end
            V.hittingCooldown = true
            pcall(function()
                local bat = getBat()
                if not bat then return end
                bat:Activate()
                local ev = bat:FindFirstChildWhichIsA("RemoteEvent")
                if ev then ev:FireServer() end
                pcall(_batCustomEnsureSwingOnHit)
            end)
            task.delay(State.SwingCooldown or 0.08, function() V.hittingCooldown = false end)
        end

        function closest()
            local root = V.hrp
            if not root then return nil, math.huge end
            local best, bestD = nil, math.huge
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= LP then
                    local cpos, isMark = nil, false
                    if type(getPlayerCombatPos) == "function" then
                        cpos, isMark = getPlayerCombatPos(p)
                    end
                    local r = p.Character and p.Character:FindFirstChild("HumanoidRootPart")
                    local hum = p.Character and p.Character:FindFirstChildOfClass("Humanoid")
                    if not cpos and r then cpos = r.Position end
                    if cpos and (isMark or (r and hum and hum.Health > 0)) then
                        local d = (root.Position - cpos).Magnitude
                        if d < bestD then bestD = d; best = p end
                    end
                end
            end
            return best, bestD
        end

        local function tpBatTargetPos(target)
            if not target then return nil, nil end
            local mark = type(getPlayerMarkPos) == "function" and getPlayerMarkPos(target) or nil
            if mark then return mark, true end
            local tr = target.Character and target.Character:FindFirstChild("HumanoidRootPart")
            if tr then return tr.Position, false end
            return nil, false
        end

        -- ============================================================


        -- ============================================================
        -- ============================================================
        -- Tp Bat modes: V1 hub | V2 Classic (standalone) | V3 Mwvane
        -- ============================================================
        local function tpBatEnsureChar()
            local c = LP.Character
            if not c then return nil, nil end
            local hum = c:FindFirstChildOfClass("Humanoid")
            local root = c:FindFirstChild("HumanoidRootPart")
            V.h = hum
            V.hrp = root
            return hum, root
        end

        local function tpBatLoopV1Hub()
            -- V1 hub: soft TP, no PhysicsRep desync
            return RunService.Heartbeat:Connect(function()
                if not V.on or not State.tpBatEnabled then return end
                if (State.tpBatMode or "V1") ~= "V1" then return end
                local hum, root = V.h, V.hrp
                if not hum or not root or not root.Parent then
                    hum, root = tpBatEnsureChar()
                    if not hum or not root then return end
                end
                local target = closest()
                if not target then return end
                local tr = target.Character and target.Character:FindFirstChild("HumanoidRootPart")
                local aimPos, isMark = tpBatTargetPos(target)
                if not aimPos then return end
                if not tr and not isMark then return end
                local targetPos = (aimPos or tr.Position) + Vector3.new(0, 0.9, 0)
                if (root.Position - targetPos).Magnitude > 8 then
                    root.CFrame = CFrame.new(targetPos)
                end
                local cam = workspace.CurrentCamera
                if cam then
                    cam.CFrame = CFrame.new(cam.CFrame.Position, aimPos or tr.Position)
                end
                trySwing()
            end)
        end

        -- V2 = Classic TP Bat (standalone / Versicn hub style)
        local function findBatToolV2()
            local char = LP.Character
            if not char then return nil end
            for _, t in ipairs(char:GetChildren()) do
                if t:IsA("Tool") then
                    local n = t.Name:lower()
                    if n:find("bat") or n:find("slap") or n:find("glove") then
                        return t
                    end
                end
            end
            local bp = LP:FindFirstChildOfClass("Backpack") or LP:FindFirstChild("Backpack")
            if bp then
                for _, t in ipairs(bp:GetChildren()) do
                    if t:IsA("Tool") then
                        local n = t.Name:lower()
                        if n:find("bat") or n:find("slap") or n:find("glove") then
                            return t
                        end
                    end
                end
            end
            return nil
        end

        local _closestCacheV2, _closestCacheAtV2 = nil, 0
        local function getClosestAliveRootV2()
            local now = os.clock()
            if _closestCacheV2 and (now - _closestCacheAtV2) < 0.03 then
                if _closestCacheV2.Parent then
                    return _closestCacheV2
                end
            end
            local root = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
            if not root then return nil end
            local closest, minDist = nil, math.huge
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= LP and plr.Character then
                    local tRoot = plr.Character:FindFirstChild("HumanoidRootPart")
                    local hum = plr.Character:FindFirstChildOfClass("Humanoid")
                    if tRoot and hum and hum.Health > 0 then
                        local d = (tRoot.Position - root.Position).Magnitude
                        if d < minDist then
                            minDist = d
                            closest = tRoot
                        end
                    end
                end
            end
            _closestCacheV2, _closestCacheAtV2 = closest, now
            return closest
        end

        local function tpBatAntiDieV2(char, hum)
            pcall(function()
                hum.MaxHealth = math.max(hum.MaxHealth, 100)
                hum.Health = hum.MaxHealth
                hum.BreakJointsOnDeath = false
                hum.RequiresNeck = false
                hum.PlatformStand = false
                hum.Sit = false
                pcall(function()
                    hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
                    hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
                    hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
                    hum:SetStateEnabled(Enum.HumanoidStateType.Physics, false)
                end)
                local st = hum:GetState()
                if st == Enum.HumanoidStateType.Dead
                    or st == Enum.HumanoidStateType.Physics
                    or st == Enum.HumanoidStateType.Ragdoll
                    or st == Enum.HumanoidStateType.FallingDown then
                    hum:ChangeState(Enum.HumanoidStateType.Running)
                end
                if not char:FindFirstChild("K7TPBatFF") then
                    local ff = Instance.new("ForceField")
                    ff.Name = "K7TPBatFF"
                    ff.Visible = false
                    ff.Parent = char
                end
            end)
        end

        local function tpBatAntiFlingV2(char, root)
            pcall(function()
                local maxLin, maxAng = 85, 15
                local v = root.AssemblyLinearVelocity
                if v.Magnitude > maxLin then
                    root.AssemblyLinearVelocity = v.Unit * maxLin
                end
                if root.AssemblyAngularVelocity.Magnitude > maxAng then
                    root.AssemblyAngularVelocity = Vector3.zero
                end
                for _, p in ipairs(char:GetChildren()) do
                    if p:IsA("BasePart") and p ~= root then
                        if p.AssemblyLinearVelocity.Magnitude > maxLin * 1.1 then
                            p.AssemblyLinearVelocity = p.AssemblyLinearVelocity.Unit * maxLin
                        end
                        if p.AssemblyAngularVelocity.Magnitude > maxAng then
                            p.AssemblyAngularVelocity = Vector3.zero
                        end
                    end
                end
            end)
        end

        local function tpBatLoopV2Classic()
            -- V2: same go-to-body lock as V1/V3 + anti-die/anti-fling
            return RunService.Heartbeat:Connect(function()
                if not V.on or not State.tpBatEnabled then return end
                if (State.tpBatMode or "V1") ~= "V2" then return end
                local char = LP.Character
                if not char then return end
                local root = char:FindFirstChild("HumanoidRootPart")
                local hum = char:FindFirstChildOfClass("Humanoid")
                if not root or not hum or hum.Health <= 0 then
                    hum, root = tpBatEnsureChar()
                    if not root or not hum then return end
                    char = LP.Character
                    if not char then return end
                end

                pcall(function()
                    local bat = findBatToolV2()
                    if bat and bat.Parent ~= char then
                        hum:EquipTool(bat)
                    end
                end)

                pcall(tpBatAntiDieV2, char, hum)

                local target = closest()
                if not target then return end
                local tr = target.Character and target.Character:FindFirstChild("HumanoidRootPart")
                local aimPos, isMark = tpBatTargetPos(target)
                if not aimPos then return end
                if not tr and not isMark then return end

                if tr and sethiddenproperty then
                    pcall(function() sethiddenproperty(root, "PhysicsRepRootPart", tr) end)
                end

                local lockPos = aimPos or (tr and tr.Position)
                if not lockPos then return end
                local targetPos = lockPos + Vector3.new(0, 0.9, 0)
                local dist = (root.Position - targetPos).Magnitude
                if dist > 8 then
                    root.CFrame = CFrame.new(targetPos)
                    root.AssemblyLinearVelocity = Vector3.zero
                    root.AssemblyAngularVelocity = Vector3.zero
                else
                    -- near target: keep chasing with velocity (don't freeze)
                    local flat = Vector3.new(targetPos.X - root.Position.X, 0, targetPos.Z - root.Position.Z)
                    local spd = tonumber(State.AimbotSpeed) or 62
                    if flat.Magnitude > 0.15 then
                        local dir = flat.Unit
                        local yVel = (targetPos.Y - root.Position.Y) * 16
                        yVel = math.clamp(yVel, -60, 90)
                        root.AssemblyLinearVelocity = Vector3.new(dir.X * spd, yVel, dir.Z * spd)
                        pcall(function()
                            hum.WalkSpeed = spd
                            hum.PlatformStand = false
                            hum:Move(dir, false)
                        end)
                    end
                end

                pcall(function()
                    local cam = workspace.CurrentCamera
                    if cam then
                        cam.CFrame = CFrame.new(cam.CFrame.Position, lockPos)
                    end
                end)

                if type(trySwing) == "function" then
                    pcall(trySwing)
                else
                    pcall(function()
                        local bat = findBatToolV2()
                        if bat then
                            bat:Activate()
                            local remote = bat:FindFirstChildOfClass("RemoteEvent") or bat:FindFirstChildWhichIsA("RemoteEvent")
                            if remote then remote:FireServer() end
                        end
                    end)
                end
                pcall(tpBatAntiFlingV2, char, root)
            end)
        end

        local function tpBatLoopV3Mwvane()
            -- V1 mwvane (kept as function name for compat)
            return RunService.Heartbeat:Connect(function()
                if not V.on or not State.tpBatEnabled then return end
                if tostring(State.tpBatMode or "V1") ~= "V1" then return end
                local hum, root = V.h, V.hrp
                if not hum or not root or not root.Parent then
                    hum, root = tpBatEnsureChar()
                    if not hum or not root then return end
                end
                local target = closest()
                if not target or not target.Character then return end
                local tr = target.Character:FindFirstChild("HumanoidRootPart")
                if not tr then return end
                if sethiddenproperty then
                    pcall(function() sethiddenproperty(root, "PhysicsRepRootPart", tr) end)
                end
                local targetPos = tr.Position + Vector3.new(0, 0.9, 0)
                if (root.Position - targetPos).Magnitude > 8 then
                    root.CFrame = CFrame.new(targetPos)
                end
                local cam = workspace.CurrentCamera
                if cam then
                    cam.CFrame = CFrame.new(cam.CFrame.Position, tr.Position)
                end
                if type(tryHitBat) == "function" then
                    pcall(tryHitBat)
                else
                    pcall(trySwing)
                end
            end)
        end


        local function tpBatLoopV2Behind()
            -- V2: TP BAT V2 standalone — cola ATRÁS do alvo + trava velocidade
            local BEHIND = 3.2
            local SNAP = 4
            return RunService.Heartbeat:Connect(function()
                if not V.on or not State.tpBatEnabled then return end
                if tostring(State.tpBatMode or "V1") ~= "V2" then return end
                local char = LP.Character
                if not char then return end
                local root = char:FindFirstChild("HumanoidRootPart")
                local hum = char:FindFirstChildOfClass("Humanoid")
                if not root or not hum or hum.Health <= 0 then return end
                V.h, V.hrp = hum, root
                _G._7VYAllowVelWrite = true

                pcall(function()
                    local bat = (type(findBatToolTP) == "function" and findBatToolTP())
                        or (type(findBatToolV2) == "function" and findBatToolV2())
                        or (type(findAnyTool) == "function" and findAnyTool())
                    if bat and bat.Parent ~= char and hum then
                        pcall(function() hum:EquipTool(bat) end)
                    end
                end)

                local targetRoot = nil
                if type(getClosestAliveRootTP) == "function" then
                    targetRoot = getClosestAliveRootTP()
                else
                    local best, bestD = nil, math.huge
                    for _, p in ipairs(Players:GetPlayers()) do
                        if p ~= LP and p.Character then
                            local tr = p.Character:FindFirstChild("HumanoidRootPart")
                            local th = p.Character:FindFirstChildOfClass("Humanoid")
                            if tr and th and th.Health > 0 then
                                local d = (root.Position - tr.Position).Magnitude
                                if d < bestD then bestD = d; best = tr end
                            end
                        end
                    end
                    targetRoot = best
                end
                if not targetRoot or not targetRoot.Parent then return end

                local behind = targetRoot.CFrame * CFrame.new(0, 0, BEHIND)
                if (root.Position - behind.Position).Magnitude > SNAP then
                    root.CFrame = CFrame.new(behind.Position, targetRoot.Position)
                end
                root.AssemblyLinearVelocity = Vector3.new(0, root.AssemblyLinearVelocity.Y, 0)
                root.AssemblyAngularVelocity = Vector3.zero

                pcall(function()
                    local cam = workspace.CurrentCamera
                    if cam then
                        cam.CFrame = CFrame.new(cam.CFrame.Position, targetRoot.Position)
                    end
                end)

                if type(tryHitBat) == "function" then
                    pcall(tryHitBat)
                elseif type(trySwing) == "function" then
                    pcall(trySwing)
                elseif type(tpBatSwingClassic) == "function" then
                    pcall(tpBatSwingClassic)
                end
            end)
        end

        local function disconnectTpBatLoops()
            V.on = false
            if V.conn then pcall(function() V.conn:Disconnect() end); V.conn = nil end
            if tpBatConn then pcall(function() tpBatConn:Disconnect() end); tpBatConn = nil end
        end

        function startTpBat()
            disconnectTpBatLoops()
            V.on = true
            State.tpBatEnabled = true
            V.hittingCooldown = false
            pcall(setBoostVelocityEnabled, false)
            pcall(startAntiFling)
            tpBatEnsureChar()

            local hum0 = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
            if hum0 then
                hum0.AutoRotate = false
                pcall(function()
                    hum0.BreakJointsOnDeath = false
                    hum0:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
                end)
            end

            local mode = tostring(State.tpBatMode or "V1")
            if mode ~= "V1" and mode ~= "V2" then
                mode = "V1"
                State.tpBatMode = "V1"
            end
            if mode == "V2" then
                V.conn = tpBatLoopV2Behind()
            else
                V.conn = tpBatLoopV3Mwvane() -- V1 mwvane
            end
            tpBatConn = V.conn
            V.on = true
            State.tpBatEnabled = true
        end

        function stopTpBat()
            disconnectTpBatLoops()
            State.tpBatEnabled = false
            if V.conn then pcall(function() V.conn:Disconnect() end); V.conn = nil end
            if tpBatConn then pcall(function() tpBatConn:Disconnect() end); tpBatConn = nil end
            local char = LP.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            if root then
                root.AssemblyLinearVelocity = Vector3.zero
                root.AssemblyAngularVelocity = Vector3.zero
                if sethiddenproperty then
                    pcall(function() sethiddenproperty(root, "PhysicsRepRootPart", root) end)
                end
            end
            pcall(function()
                if char then
                    local ff = char:FindFirstChild("K7TPBatFF")
                    if ff then ff:Destroy() end
                end
            end)
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if hum then
                hum.AutoRotate = true
                pcall(function()
                    hum.BreakJointsOnDeath = true
                    hum.RequiresNeck = true
                    hum:SetStateEnabled(Enum.HumanoidStateType.Dead, true)
                    hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
                    hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, true)
                    hum:SetStateEnabled(Enum.HumanoidStateType.Physics, true)
                    hum:ChangeState(Enum.HumanoidStateType.GettingUp)
                end)
            end
            V.hittingCooldown = false
            pcall(stopAntiFling)
            if not State.autoLeftEnabled and not State.autoRightEnabled and not State.batAimbotToggled then
                pcall(setBoostVelocityEnabled, true)
            end
        end


                -- ============================================================
        -- 73 Anti Anti Desync + Anti Tp (V1) - integrated + godmode
        -- V1: PhysicsRepRootPart -> fake at Y-9999 (void), clamp fall
        -- ============================================================
        local V1_VOID_OFFSET = -9999
        local SAFE_FALL_SPEED = 50
        V.antiY = V1_VOID_OFFSET
        V.antiNoCol = nil
        V.antiAtt = nil
        V.antiGodConns = V.antiGodConns or {}

        local function antiApplyGodmode(state, charOverride)
            for _, conn in ipairs(V.antiGodConns) do
                pcall(function() conn:Disconnect() end)
            end
            V.antiGodConns = {}
            local char = charOverride or LP.Character
            if not char then return end
            local hum = char:FindFirstChildOfClass("Humanoid")
            if not hum then return end
            if state then
                table.insert(V.antiGodConns, RunService.Heartbeat:Connect(function()
                    if not State.antiBatTpEnabled then return end
                    local c = LP.Character
                    if not c or not c.Parent then return end
                    local h = c:FindFirstChildOfClass("Humanoid")
                    local root = c:FindFirstChild("HumanoidRootPart")
                    if h and root then
                        pcall(function()
                            h.BreakJointsOnDeath = false
                            h.RequiresNeck = false
                            h:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
                            h:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
                            h:SetStateEnabled(Enum.HumanoidStateType.Physics, false)
                            h:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
                            if h.MaxHealth ~= 1000 then h.MaxHealth = 1000 end
                            if h.Health < 999 then h.Health = 1000 end
                        end)
                    end
                end))
                table.insert(V.antiGodConns, hum.StateChanged:Connect(function(_, newState)
                    if not State.antiBatTpEnabled then return end
                    if newState == Enum.HumanoidStateType.Dead then
                        pcall(function()
                            hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
                            hum:ChangeState(Enum.HumanoidStateType.GettingUp)
                            hum.Health = 1000
                        end)
                    end
                end))
            else
                pcall(function()
                    hum:SetStateEnabled(Enum.HumanoidStateType.Dead, true)
                    hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
                    hum:SetStateEnabled(Enum.HumanoidStateType.Physics, true)
                    hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, true)
                    if hum.MaxHealth > 100 then
                        hum.MaxHealth = 100
                        hum.Health = math.min(hum.Health, 100)
                    end
                end)
            end
        end

        function antiStop()
            if V.antiConn then pcall(function() V.antiConn:Disconnect() end); V.antiConn = nil end
            if V.antiNoCol then pcall(function() V.antiNoCol:Destroy() end); V.antiNoCol = nil end
            if V.antiAtt then pcall(function() V.antiAtt:Destroy() end); V.antiAtt = nil end
            if V.antiFake then pcall(function() V.antiFake:Destroy() end); V.antiFake = nil end
            pcall(function()
                if sethiddenproperty and V.antiHRP and V.antiHRP.Parent then
                    sethiddenproperty(V.antiHRP, "PhysicsRepRootPart", V.antiHRP)
                end
            end)
        end

        function antiStart()
            antiStop()
            local char = LP.Character
            if not char then return end
            local hrp = char:FindFirstChild("HumanoidRootPart")
            local hum = char:FindFirstChildOfClass("Humanoid")
            if not hrp then return end
            V.antiHRP = hrp

            pcall(function()
                if hrp.AssemblyLinearVelocity.Magnitude > SAFE_FALL_SPEED then
                    hrp.AssemblyLinearVelocity = Vector3.zero
                end
            end)

            local fake = Instance.new("Part")
            fake.Name = "FakeHitbox_73"
            fake.Size = Vector3.new(2, 2, 1)
            fake.Transparency = 1
            fake.CanCollide = false
            fake.CanQuery = false
            fake.CanTouch = false
            fake.Anchored = false
            fake.Massless = true
            fake.Parent = char
            fake.CFrame = CFrame.new(0, V1_VOID_OFFSET, 0)
            pcall(function() fake:SetNetworkOwner(LP) end)
            V.antiFake = fake

            local noCol = Instance.new("NoCollisionConstraint")
            noCol.Name = "NoCol_73"
            noCol.Part0 = hrp
            noCol.Part1 = fake
            noCol.Parent = hrp
            V.antiNoCol = noCol

            local att = Instance.new("Attachment")
            att.Name = "Att1_73"
            att.Position = Vector3.new(0, 2.5, 0)
            att.Parent = hrp
            V.antiAtt = att

            V.antiConn = RunService.Heartbeat:Connect(function()
                if not V.antiOn or not State.antiBatTpEnabled then return end
                local my = V.antiHRP
                local fk = V.antiFake
                if not my or not my.Parent then return end

                my.AssemblyAngularVelocity = Vector3.zero
                if my.AssemblyLinearVelocity.Magnitude > 50 then
                    my.AssemblyLinearVelocity = Vector3.zero
                end

                if hum and hum.Parent and hum.FloorMaterial == Enum.Material.Air then
                    local vel = my.AssemblyLinearVelocity
                    if vel.Y < -SAFE_FALL_SPEED then
                        my.AssemblyLinearVelocity = Vector3.new(vel.X, -SAFE_FALL_SPEED, vel.Z)
                    end
                end

                local voidPos = my.Position + Vector3.new(0, V1_VOID_OFFSET, 0)
                if fk and fk.Parent then
                    fk.CFrame = CFrame.new(voidPos)
                    fk.AssemblyLinearVelocity = Vector3.zero
                    fk.AssemblyAngularVelocity = Vector3.zero
                end

                if sethiddenproperty then
                    pcall(function() sethiddenproperty(my, "PhysicsRepRootPart", fk) end)
                end
            end)
        end


        -- ============================================================
        -- Anti Bat TP V2 — Fake HRP + PhysicsRepRootPart (Y=-1000)
        -- ============================================================
        local V2_FAKE_Y = -1000
        V.antiV2 = V.antiV2 or { fake = nil, conn = nil, hrp = nil, headGui = nil }


        local function updateAntiAntiHeadLabel(on)
            pcall(function()
                -- destroy any old warn labels (ours or leftover standalone)
                local char = LP.Character
                if char then
                    for _, d in ipairs(char:GetDescendants()) do
                        if d.Name == "AntiTPBatWarn" or d.Name == "KyzAntiAntiHead" then
                            pcall(function() d:Destroy() end)
                        end
                    end
                end
                if V.antiV2 and V.antiV2.headGui then
                    pcall(function() V.antiV2.headGui:Destroy() end)
                    V.antiV2.headGui = nil
                end
                if V.antiHeadGui then
                    pcall(function() V.antiHeadGui:Destroy() end)
                    V.antiHeadGui = nil
                end
                if not on then return end
                if not char then return end
                local head = char:FindFirstChild("Head")
                if not head then return end
                local mode = tostring(State.antiBatTpMode or "V1")
                local bb = Instance.new("BillboardGui")
                bb.Name = "KyzAntiAntiHead"
                bb.Size = UDim2.new(0, 220, 0, 32)
                bb.StudsOffset = Vector3.new(0, 5.4, 0)
                bb.AlwaysOnTop = true
                bb.MaxDistance = 120
                bb.Parent = head
                local lbl = Instance.new("TextLabel")
                lbl.Size = UDim2.new(1, 0, 1, 0)
                lbl.BackgroundTransparency = 1
                lbl.Text = "ANTI TP " .. mode
                lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
                lbl.Font = Enum.Font.GothamBlack
                lbl.TextSize = 15
                lbl.TextStrokeTransparency = 0.3
                lbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                lbl.Parent = bb
                V.antiHeadGui = bb
                if V.antiV2 then V.antiV2.headGui = bb end
            end)
        end

        local function antiV2UpdateHeadWarn(on)
            updateAntiAntiHeadLabel(on)
        end


        local function antiV2Stop()
            if V.antiV2.conn then
                pcall(function() V.antiV2.conn:Disconnect() end)
                V.antiV2.conn = nil
            end
            if V.antiV2.fake then
                pcall(function() V.antiV2.fake:Destroy() end)
                V.antiV2.fake = nil
            end
            pcall(function()
                if typeof(sethiddenproperty) == "function" and V.antiV2.hrp and V.antiV2.hrp.Parent then
                    sethiddenproperty(V.antiV2.hrp, "PhysicsRepRootPart", V.antiV2.hrp)
                end
            end)
            antiV2UpdateHeadWarn(false)
        end

        local function antiV2Start()
            antiV2Stop()
            local char = LP.Character
            if not char then return false end
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if not hrp then return false end
            if typeof(sethiddenproperty) ~= "function" then
                warn("[Anti Bat TP V2] executor without sethiddenproperty")
                return false
            end
            V.antiV2.hrp = hrp
            local fake = Instance.new("Part")
            fake.Name = "AntiTPBat_FakeHRP_V2"
            fake.Size = Vector3.new(2, 2, 1)
            fake.Anchored = true
            fake.CanCollide = false
            fake.Transparency = 1
            fake.CFrame = CFrame.new(hrp.Position.X, V2_FAKE_Y, hrp.Position.Z)
            fake.Parent = workspace
            V.antiV2.fake = fake
            V.antiV2.conn = RunService.Heartbeat:Connect(function()
                if not State.antiBatTpEnabled then return end
                if (State.antiBatTpMode or "V1") ~= "V2" then return end
                local myHRP, fakeHRP = V.antiV2.hrp, V.antiV2.fake
                if not myHRP or not myHRP.Parent then return end
                if not fakeHRP or not fakeHRP.Parent then return end
                fakeHRP.CFrame = CFrame.new(myHRP.Position.X, V2_FAKE_Y, myHRP.Position.Z)
                pcall(function()
                    sethiddenproperty(myHRP, "PhysicsRepRootPart", fakeHRP)
                end)
            end)
            antiV2UpdateHeadWarn(true)
            return true
        end

        local function antiV1Start()
            V.antiOn = true
            local ch = LP.Character
            if ch then
                V.antiHRP = ch:FindFirstChild("HumanoidRootPart")
                antiApplyGodmode(true, ch)
            end
            antiStart()
            updateAntiAntiHeadLabel(true)
        end

        local function antiV1Stop()
            V.antiOn = false
            local char = LP.Character
            if char then
                antiApplyGodmode(true, char)
            end
            antiStop()
            if char then
                local hrp = char:FindFirstChild("HumanoidRootPart")
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hrp and hum and hum.FloorMaterial == Enum.Material.Air then
                    local rayParams = RaycastParams.new()
                    rayParams.FilterType = Enum.RaycastFilterType.Exclude
                    rayParams.FilterDescendantsInstances = {char}
                    local result = workspace:Raycast(hrp.Position, Vector3.new(0, -500, 0), rayParams)
                    if result then
                        hrp.CFrame = CFrame.new(result.Position + Vector3.new(0, 3, 0))
                        hrp.AssemblyLinearVelocity = Vector3.zero
                        hrp.AssemblyAngularVelocity = Vector3.zero
                    end
                end
                task.delay(0.15, function()
                    if not State.antiBatTpEnabled then
                        antiApplyGodmode(false, LP.Character)
                    end
                end)
            else
                antiApplyGodmode(false, nil)
            end
        end


        -- ============================================================
        -- Anti Bat TP V3 — original desync source (FAKE_ROOT_Y extreme)
        -- ============================================================
        local V3_FAKE_Y = -9999999999999999999
        local V3_FAKE_VEL = Vector3.new(0, -9999, 0)
        V.antiV3 = V.antiV3 or { fake = nil, stepConn = nil, hrp = nil }

        local function antiV3Stop()
            if V.antiV3.stepConn then
                pcall(function() V.antiV3.stepConn:Disconnect() end)
                V.antiV3.stepConn = nil
            end
            local hrp = V.antiV3.hrp
            if hrp and hrp.Parent and typeof(sethiddenproperty) == "function" then
                pcall(function() sethiddenproperty(hrp, "PhysicsRepRootPart", hrp) end)
            end
            if V.antiV3.fake then
                pcall(function() V.antiV3.fake:Destroy() end)
                V.antiV3.fake = nil
            end
            V.antiV3.hrp = nil
            pcall(updateAntiAntiHeadLabel, false)
        end

        local function antiV3CreateFake(basePos)
            if V.antiV3.fake then
                pcall(function() V.antiV3.fake:Destroy() end)
                V.antiV3.fake = nil
            end
            local fake = Instance.new("Part")
            fake.Name = "AntiTPBat_DesyncRoot"
            fake.Size = Vector3.new(2, 2, 1)
            fake.Anchored = true
            fake.CanCollide = false
            fake.CanTouch = false
            fake.CanQuery = false
            fake.Transparency = 1
            fake.CFrame = CFrame.new(basePos.X, V3_FAKE_Y, basePos.Z)
            pcall(function() fake.AssemblyLinearVelocity = V3_FAKE_VEL end)
            fake.Parent = workspace
            V.antiV3.fake = fake
            return fake
        end

        local function antiV3Step()
            if not State.antiBatTpEnabled then return end
            if (State.antiBatTpMode or "V1") ~= "V3" then return end
            local hrp = V.antiV3.hrp
            if not hrp or not hrp.Parent then
                local char = LP.Character
                hrp = char and char:FindFirstChild("HumanoidRootPart")
                V.antiV3.hrp = hrp
            end
            if not hrp then return end
            local fake = V.antiV3.fake
            if not fake or not fake.Parent then
                fake = antiV3CreateFake(hrp.Position)
                if typeof(sethiddenproperty) == "function" then
                    pcall(function() sethiddenproperty(hrp, "PhysicsRepRootPart", fake) end)
                end
                return
            end
            pcall(function()
                fake.Anchored = true
                fake.AssemblyLinearVelocity = V3_FAKE_VEL
                -- keep extreme Y (original source)
                fake.CFrame = CFrame.new(hrp.Position.X, V3_FAKE_Y, hrp.Position.Z)
            end)
            if typeof(sethiddenproperty) == "function" then
                pcall(function()
                    sethiddenproperty(hrp, "PhysicsRepRootPart", fake)
                end)
            end
        end

        local function antiV3Start()
            antiV3Stop()
            local char = LP.Character
            if not char then return false end
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if not hrp then return false end
            if typeof(sethiddenproperty) ~= "function" then
                warn("[Anti Bat TP V3] executor without sethiddenproperty")
                return false
            end
            -- physics radius helpers from original source
            pcall(function()
                if typeof(sethiddenproperty) == "function" then
                    sethiddenproperty(LP, "MaximumSimulationRadius", math.huge)
                    sethiddenproperty(LP, "SimulationRadius", math.huge)
                end
            end)
            V.antiV3.hrp = hrp
            local fake = antiV3CreateFake(hrp.Position)
            pcall(function() sethiddenproperty(hrp, "PhysicsRepRootPart", fake) end)
            V.antiV3.stepConn = RunService.Stepped:Connect(antiV3Step)
            pcall(updateAntiAntiHeadLabel, true)
            return true
        end


        function startAntiBatTp()
            -- removed
            State.antiBatTpEnabled = false
        end

        function stopAntiBatTp()
            State.antiBatTpEnabled = false
        end

        local function cleanupAntiBatWorld()
            -- destroy leftover fakes from previous life (V2/V3)
            pcall(function()
                for _, inst in ipairs(workspace:GetChildren()) do
                    if inst:IsA("BasePart") then
                        local n = inst.Name
                        if n == "AntiTPBat_FakeHRP_V2"
                            or n == "AntiTPBat_DesyncRoot"
                            or n == "FakeHitbox_73"
                            or n == "AntiTPBat_FakeHRP" then
                            pcall(function() inst:Destroy() end)
                        end
                    end
                end
            end)
        end

        local function resetCharPhysics(char)
            if not char then return end
            local hrp = char:FindFirstChild("HumanoidRootPart")
            local hum = char:FindFirstChildOfClass("Humanoid")
            -- restore replication root on NEW character
            if hrp and typeof(sethiddenproperty) == "function" then
                pcall(function() sethiddenproperty(hrp, "PhysicsRepRootPart", hrp) end)
            end
            if hum then
                pcall(function()
                    hum.AutoRotate = true
                    hum.PlatformStand = false
                    hum.Sit = false
                    hum.BreakJointsOnDeath = true
                    hum.RequiresNeck = true
                    hum:SetStateEnabled(Enum.HumanoidStateType.Dead, true)
                    hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
                    hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, true)
                    hum:SetStateEnabled(Enum.HumanoidStateType.Physics, true)
                    local st = hum:GetState()
                    if st == Enum.HumanoidStateType.Physics
                        or st == Enum.HumanoidStateType.Ragdoll
                        or st == Enum.HumanoidStateType.FallingDown
                        or st == Enum.HumanoidStateType.Dead then
                        hum:ChangeState(Enum.HumanoidStateType.Running)
                    end
                end)
            end
            if hrp then
                pcall(function()
                    hrp.Anchored = false
                    hrp.AssemblyLinearVelocity = Vector3.zero
                    hrp.AssemblyAngularVelocity = Vector3.zero
                end)
            end
            -- un-anchor any body parts left from anti push / old systems
            pcall(function()
                for _, p in ipairs(char:GetDescendants()) do
                    if p:IsA("BasePart") and p.Anchored and p.Name ~= "HumanoidRootPart" then
                        -- only clear if it looks like a leftover freeze (transparent tools excluded)
                        if p.Transparency < 1 then
                            -- do not touch accessories; only base R15/R6 parts
                            local n = p.Name
                            if n == "Head" or n == "Torso" or n == "UpperTorso" or n == "LowerTorso"
                                or n:find("Arm") or n:find("Leg") or n:find("Hand") or n:find("Foot") then
                                p.Anchored = false
                            end
                        end
                    end
                end
            end)
            pcall(function()
                local ff = char:FindFirstChild("K7TPBatFF")
                if ff then ff:Destroy() end
            end)
        end

        LP.CharacterAdded:Connect(function(char)
            -- FULL cleanup first (all anti modes + world fakes)
            pcall(function()
                local wasOn = State.antiBatTpEnabled == true
                State.antiBatTpEnabled = false
                pcall(antiV3Stop)
                pcall(antiV2Stop)
                pcall(antiV1Stop)
                pcall(antiStop)
                pcall(antiApplyGodmode, false, nil)
                pcall(cleanupAntiBatWorld)
                pcall(updateAntiAntiHeadLabel, false)
                -- wait a frame for new HRP
                task.wait(0.05)
                pcall(resetCharPhysics, char)
                if wasOn then
                    State.antiBatTpEnabled = true
                end
            end)

            if State.tpBatEnabled or V.on then
                task.spawn(function()
                    task.wait(0.45)
                    if State.tpBatEnabled then
                        pcall(stopTpBat)
                        task.wait(0.05)
                        pcall(startTpBat)
                    end
                end)
            end

            task.spawn(function()
                task.wait(0.35)
                local hrp = char:FindFirstChild("HumanoidRootPart") or char:WaitForChild("HumanoidRootPart", 5)
                V.antiHRP = hrp
                pcall(resetCharPhysics, char)
                if State.antiBatTpEnabled and hrp then
                    -- clean start on new body
                    pcall(stopAntiBatTp)
                    task.wait(0.08)
                    State.antiBatTpEnabled = true
                    pcall(startAntiBatTp)
                end
            end)
        end)
        if LP.Character then
            task.spawn(function()
                task.wait(0.25)
                local char = LP.Character
                if char then
                    pcall(resetCharPhysics, char)
                    V.antiHRP = char:FindFirstChild("HumanoidRootPart") or char:WaitForChild("HumanoidRootPart", 5)
                    if State.antiBatTpEnabled and V.antiHRP then
                        pcall(stopAntiBatTp)
                        task.wait(0.05)
                        State.antiBatTpEnabled = true
                        pcall(startAntiBatTp)
                    end
                end
            end)
        end
    end

    startBatAimbot = function()
        if Conns.aimbot then
            pcall(function() Conns.aimbot:Disconnect() end)
            Conns.aimbot = nil
        end
        if State.tpBatEnabled then return end
        State.batAimbotToggled = true
        pcall(destroyMoveProxy)
        pcall(setBoostVelocityEnabled, false)
        if bodyForce then
            pcall(function() bodyForce.Force = Vector3.new(0, 0, 0) end)
        end

        hum0 = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
        if hum0 then hum0.AutoRotate = false end

        aimbotSwingCd = false
        AIMBOT_HEIGHT = 3.6
        AIMBOT_SWING_DIST = 5.5

        function swingBatTool()
            if aimbotSwingCd then return end
            if not State.autoSwingEnabled then return end
            aimbotSwingCd = true
            pcall(function()
                bat = findBat()
                char = LP.Character
                if not bat or not char then return end
                hum = char:FindFirstChildOfClass("Humanoid")
                if bat.Parent ~= char and hum then
                    pcall(function() hum:EquipTool(bat) end)
                end
                remote = bat:FindFirstChildOfClass("RemoteEvent")
                if remote then
                    pcall(function() remote:FireServer() end)
                end
                pcall(function() bat:Activate() end)
                pcall(_batCustomEnsureSwingOnHit)
            end)
            task.delay(0.09, function() aimbotSwingCd = false end)
        end

        function trySwingBypass()
            if aimbotSwingCd then return end
            if not State.autoSwingEnabled then return end
            aimbotSwingCd = true
            pcall(function()
                bat = findBat()
                char = LP.Character
                if not bat or not char then return end
                hum = char:FindFirstChildOfClass("Humanoid")
                if bat.Parent ~= char and hum then
                    pcall(function() hum:EquipTool(bat) end)
                end
                pcall(function() bat:Activate() end)
                remote = bat:FindFirstChildOfClass("RemoteEvent")
                if remote then pcall(function() remote:FireServer() end) end
                pcall(_batCustomEnsureSwingOnHit)
            end)
            task.delay(State.SwingCooldown or 0.08, function() aimbotSwingCd = false end)
        end

        Conns.aimbot = RunService.RenderStepped:Connect(function()
            if not State.batAimbotToggled then return end
            if State.tpBatEnabled then return end
            char = LP.Character
            if not char then return end
            root = char:FindFirstChild("HumanoidRootPart")
            hum = char:FindFirstChildOfClass("Humanoid")
            if not root or not hum or hum.Health <= 0 then return end

            pcall(setBoostVelocityEnabled, false)
            if bodyForce then bodyForce.Force = Vector3.new(0, 0, 0) end

            mode = State.aimbotMode or "normal"
            aimSpd = tonumber(State.AimbotSpeed) or 62

            if mode == "normal" then
                if not char:FindFirstChildOfClass("Tool") then
                    bat = findBat()
                    if bat then pcall(function() hum:EquipTool(bat) end) end
                end

                local target, dist, combatPos, combatPlr = getClosestTarget()
                if not target and not combatPos then return end
                _aimbotTarget = target

                targetVel = (target and target.AssemblyLinearVelocity) or Vector3.zero
                myPos = root.Position
                targetPos = combatPos or (target and target.Position)
                if not targetPos then return end
                local look = Vector3.new(0, 0, -1)
                if target and target.CFrame then
                    look = target.CFrame.LookVector
                end
                predictPos = targetPos + targetVel * 0.13 + look * 0.25

                direction = predictPos - myPos
                flatDir = Vector3.new(direction.X, 0, direction.Z)
                if flatDir.Magnitude > 0.1 then
                    flatDir = flatDir.Unit
                else
                    flatDir = Vector3.new(0, 0, -1)
                end

                desiredHeight = targetPos.Y + AIMBOT_HEIGHT
                yOff = desiredHeight - myPos.Y
                aimSpd = math.clamp(tonumber(State.AimbotSpeed) or 62, 1, 200)
                local yVel = yOff * 18 + targetVel.Y * 0.75
                if hum.FloorMaterial ~= Enum.Material.Air then
                    yVel = math.max(yVel, 12)
                end
                yVel = math.clamp(yVel, -75, 115)
                local desiredVel = Vector3.new(flatDir.X * aimSpd, yVel, flatDir.Z * aimSpd)
                -- PC speed mechanism: smooth Lerp (same as Violet PC)
                pcall(setBoostVelocityEnabled, false)
                root.AssemblyLinearVelocity = root.AssemblyLinearVelocity:Lerp(desiredVel, 0.85)
                pcall(function()
                    hum.WalkSpeed = aimSpd
                end)

                speed3 = targetVel.Magnitude
                predictTime = math.clamp(speed3 / 140, 0.04, 0.18)
                predictedPos = targetPos + targetVel * predictTime
                toPredict = predictedPos - myPos
                if toPredict.Magnitude > 0.15 then
                    goalCF = CFrame.lookAt(myPos, predictedPos)
                    curCF = root.CFrame
                    diffCF = curCF:Inverse() * goalCF
                    local rx, ry, rz = diffCF:ToEulerAnglesXYZ()
                    rx = math.clamp(rx, -2.4, 2.4)
                    ry = math.clamp(ry, -2.4, 2.4)
                    rz = math.clamp(rz, -2.4, 2.4)
                    tiltSpeed = 40
                    root.AssemblyAngularVelocity = root.CFrame:VectorToWorldSpace(
                        Vector3.new(rx * tiltSpeed, ry * tiltSpeed, rz * tiltSpeed)
                    )
                end

                if (targetPos - myPos).Magnitude <= AIMBOT_SWING_DIST then
                    swingBatTool()
                end
            else
                if not char:FindFirstChildOfClass("Tool") then
                    bat = findBat()
                    if bat then pcall(function() hum:EquipTool(bat) end) end
                end

                local target, targetDist, combatPos = getClosestTarget()
                if not target and not combatPos then
                    trySwingBypass()
                    return
                end
                _aimbotTarget = target

                myPos = root.Position
                targetPos = combatPos or (target and target.Position)
                if not targetPos then
                    trySwingBypass()
                    return
                end
                direction = targetPos - myPos
                flatDir = Vector3.new(direction.X, 0, direction.Z)
                if flatDir.Magnitude > 0.05 then
                    flatDir = flatDir.Unit
                else
                    flatDir = Vector3.zero
                end

                aimSpd = math.clamp(tonumber(State.AimbotSpeed) or 62, 1, 200)
                chaseSpeed = aimSpd
                desiredHeight = targetPos.Y + 3.7
                yOff = desiredHeight - myPos.Y
                local yVel = yOff * 19.5
                if hum.FloorMaterial ~= Enum.Material.Air then
                    yVel = math.max(yVel, 13)
                end
                yVel = math.clamp(yVel, -70, 110)
                local desiredVel = Vector3.new(flatDir.X * chaseSpeed, yVel, flatDir.Z * chaseSpeed)
                -- PC speed mechanism: smooth Lerp (same as Violet PC)
                pcall(setBoostVelocityEnabled, false)
                root.AssemblyLinearVelocity = root.AssemblyLinearVelocity:Lerp(desiredVel, 0.8)
                pcall(function()
                    hum.WalkSpeed = chaseSpeed
                end)

                toTarget = targetPos - myPos
                if toTarget.Magnitude > 0.1 then
                    goalCF = CFrame.lookAt(myPos, targetPos)
                    diffCF = root.CFrame:Inverse() * goalCF
                    local rx, ry, rz = diffCF:ToEulerAnglesXYZ()
                    rx = math.clamp(rx, -2.5, 2.5)
                    ry = math.clamp(ry, -2.5, 2.5)
                    rz = math.clamp(rz, -2.5, 2.5)
                    root.AssemblyAngularVelocity = root.CFrame:VectorToWorldSpace(
                        Vector3.new(rx * 42, ry * 42, rz * 42)
                    )
                end

                if targetDist <= 8 then
                    trySwingBypass()
                end
            end
        end)
    end

    stopBatAimbot = function()
        State.batAimbotToggled = false
        if Conns.aimbot then
            pcall(function() Conns.aimbot:Disconnect() end)
            Conns.aimbot = nil
        end
        _aimbotTarget = nil
        if not State.tpBatEnabled then
            c = LP.Character
            root = c and c:FindFirstChild("HumanoidRootPart")
            if root then
                root.AssemblyAngularVelocity = Vector3.zero
            end
            hum2 = c and c:FindFirstChildOfClass("Humanoid")
            if hum2 then hum2.AutoRotate = true end
        end
        State.hittingCooldown = false
        if not State.autoLeftEnabled and not State.autoRightEnabled and not State.tpBatEnabled then
            pcall(setBoostVelocityEnabled, true)
        end
        if kyzDuelsMobBtnRefs and kyzDuelsMobBtnRefs.aimbot then
            pcall(function() kyzDuelsMobBtnRefs.aimbot(false) end)
        end
    end

    function setupCombatTabToggle1()
        toggleRefs.medusaCounter = makeToggleRow("Medusa Counter", State.medusaCounterEnabled, function(on, isSync)
            State.medusaCounterEnabled = on
            if on then
                if LP.Character then setupMedusaCounter(LP.Character) end
            else
                stopMedusaCounter()
            end
            if not isSync then task.spawn(saveConfig) end
        end, nil, tabCombat)
    end

    function setupCombatTabToggle2()
        toggleRefs.batCounter = makeToggleRow("Bat Counter", State.batCounterEnabled, function(on, isSync)
            State.batCounterEnabled = on
            if on then
                startBatCounter()
            else
                stopBatCounter()
            end
            if not isSync then task.spawn(saveConfig) end
        end, nil, tabCombat)
    end

    function setupCombatTabToggles()
        setupCombatTabToggle1()
        setupCombatTabToggle2()
    end

    function setupCombatTab()
        makeSectionHeader("COMBAT", tabCombat)

        do
            local aimExpanded = false
            local host = tabCombat
            local mainRow = Instance.new("Frame", host)
            mainRow.Name = "AimbotMainRow"
            mainRow.Size = UDim2.new(1, 0, 0, 34)
            mainRow.BackgroundColor3 = C.row
            mainRow.BackgroundTransparency = 0.22
            mainRow.BorderSizePixel = 0
            mainRow.LayoutOrder = LO()
            mainRow.ZIndex = 7
            mkCorner(mainRow, 10)
            mkStroke(mainRow, C.border, 1, 0.82)

            local arrowBtn = Instance.new("TextButton", mainRow)
            arrowBtn.Name = "AimbotArrow"
            arrowBtn.Size = UDim2.new(0, 22, 0, 22)
            arrowBtn.Position = UDim2.new(0, 6, 0.5, -11)
            arrowBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 32)
            arrowBtn.BackgroundTransparency = 0.15
            arrowBtn.BorderSizePixel = 0
            arrowBtn.Text = "▲"
            arrowBtn.TextColor3 = C.white
            arrowBtn.Font = Enum.Font.GothamBold
            arrowBtn.TextSize = 11
            arrowBtn.AutoButtonColor = false
            arrowBtn.ZIndex = 10
            mkCorner(arrowBtn, 11)

            local lbl = Instance.new("TextLabel", mainRow)
            lbl.Size = UDim2.new(0.45, 0, 1, 0)
            lbl.Position = UDim2.new(0, 34, 0, 0)
            lbl.BackgroundTransparency = 1
            lbl.Text = "Aimbot"
            lbl.TextColor3 = C.white
            lbl.Font = Enum.Font.GothamBold
            lbl.TextSize = 12
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.ZIndex = 8

            local aimKbBtn = Instance.new("TextButton", mainRow)
            aimKbBtn.Size = UDim2.new(0, 36, 0, 20)
            aimKbBtn.Position = UDim2.new(1, -98, 0.5, -10)
            aimKbBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 32)
            aimKbBtn.BackgroundTransparency = 0.1
            aimKbBtn.BorderSizePixel = 0
            aimKbBtn.Text = getKeyName(Keys.aimbot or Enum.KeyCode.E)
            aimKbBtn.TextColor3 = C.text
            aimKbBtn.Font = Enum.Font.GothamBold
            aimKbBtn.TextSize = 10
            aimKbBtn.AutoButtonColor = false
            aimKbBtn.ZIndex = 10
            mkCorner(aimKbBtn, 6)
            keybindBtnRefs.aimbot = aimKbBtn
            aimKbBtn.MouseButton1Click:Connect(function()
                if activeKeybindKeyRef == "aimbot" and activeKeybindListener then
                    cancelActiveKeybind()
                    return
                end
                cancelActiveKeybind()
                activeKeybindBtn = aimKbBtn
                activeKeybindKeyRef = "aimbot"
                activeKeybindPrevText = aimKbBtn.Text
                aimKbBtn.Text = "..."
                activeKeybindListener = UIS.InputBegan:Connect(function(inp, gp)
                    if gp then return end
                    if inp.UserInputType ~= Enum.UserInputType.Keyboard and inp.UserInputType ~= Enum.UserInputType.Gamepad1 then return end
                    if inp.KeyCode == Enum.KeyCode.Unknown then return end
                    if inp.KeyCode == Enum.KeyCode.Escape then
                        cancelActiveKeybind()
                        return
                    end
                    Keys.aimbot = inp.KeyCode
                    aimKbBtn.Text = getKeyName(inp.KeyCode)
                    if activeKeybindListener then pcall(function() activeKeybindListener:Disconnect() end); activeKeybindListener = nil end
                    activeKeybindBtn = nil
                    activeKeybindKeyRef = nil
                    task.spawn(saveConfig)
                end)
            end)

            local track = Instance.new("Frame", mainRow)
            track.Size = UDim2.new(0, 40, 0, 20)
            track.Position = UDim2.new(1, -52, 0.5, -10)
            track.BackgroundColor3 = State.batAimbotToggled and Color3.fromRGB(220, 220, 225) or C.pillOff
            track.BorderSizePixel = 0
            track.ZIndex = 8
            mkCorner(track, 10)

            local knob = Instance.new("Frame", track)
            knob.Size = UDim2.new(0, 14, 0, 14)
            knob.Position = State.batAimbotToggled and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7)
            knob.BackgroundColor3 = State.batAimbotToggled and Color3.fromRGB(20, 20, 22) or C.textDim
            knob.BorderSizePixel = 0
            knob.ZIndex = 9
            mkCorner(knob, 7)

            local toggleBtn = Instance.new("TextButton", mainRow)
            toggleBtn.Size = UDim2.new(0, 40, 0, 20)
            toggleBtn.Position = UDim2.new(1, -52, 0.5, -10)
            toggleBtn.BackgroundTransparency = 1
            toggleBtn.Text = ""
            toggleBtn.ZIndex = 11

            local function setAimbotToggleVisual(on, noAnim)
                targetPos = on and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7)
                knobCol = on and Color3.fromRGB(20, 20, 22) or C.textDim
                trackCol = on and Color3.fromRGB(220, 220, 225) or C.pillOff
                if noAnim then
                    knob.Position = targetPos
                    knob.BackgroundColor3 = knobCol
                    track.BackgroundColor3 = trackCol
                else
                    tw(knob, {Position = targetPos, BackgroundColor3 = knobCol}, TweenInfo.new(0.22, Enum.EasingStyle.Quart, Enum.EasingDirection.Out))
                    tw(track, {BackgroundColor3 = trackCol}, TweenInfo.new(0.22, Enum.EasingStyle.Quart, Enum.EasingDirection.Out))
                end
            end

            toggleBtn.MouseButton1Click:Connect(function()
                State.batAimbotToggled = not State.batAimbotToggled
                setAimbotToggleVisual(State.batAimbotToggled, false)
                if State.batAimbotToggled then pcall(startBatAimbot) else pcall(stopBatAimbot) end
                task.spawn(saveConfig)
            end)
            toggleRefs.aimbot = function(on, isSync)
                State.batAimbotToggled = on and true or false
                setAimbotToggleVisual(State.batAimbotToggled, isSync == true)
                if State.batAimbotToggled then pcall(startBatAimbot) else pcall(stopBatAimbot) end
                if not isSync then task.spawn(saveConfig) end
            end

            local optionsFrame = Instance.new("Frame", host)
            optionsFrame.Name = "AimbotOptions"
            optionsFrame.Size = UDim2.new(1, 0, 0, 0)
            optionsFrame.AutomaticSize = Enum.AutomaticSize.Y
            optionsFrame.BackgroundTransparency = 1
            optionsFrame.BorderSizePixel = 0
            optionsFrame.Visible = false
            optionsFrame.LayoutOrder = LO()
            optionsFrame.ZIndex = 7

            optLayout = Instance.new("UIListLayout", optionsFrame)
            optLayout.SortOrder = Enum.SortOrder.LayoutOrder
            optLayout.Padding = UDim.new(0, 4)

            optPad = Instance.new("UIPadding", optionsFrame)
            optPad.PaddingLeft = UDim.new(0, 10)
            optPad.PaddingRight = UDim.new(0, 4)
            optPad.PaddingTop = UDim.new(0, 2)
            optPad.PaddingBottom = UDim.new(0, 2)

            setAimbotMode = makeSlideSelector(
                optionsFrame,
                { "Normal", "Aimbot Bypass" },
                "aimbotMode",
                { "normal", "antiBatBypass" },
                function(mode, isSync)
                    State.aimbotMode = mode
                    if State.batAimbotToggled then
                        pcall(stopBatAimbot)
                        pcall(startBatAimbot)
                    end
                    if not isSync then task.spawn(saveConfig) end
                end
            )
            toggleRefs.aimbotModeLabel = setAimbotMode

            -- same speed box system as Normal Speed / Lagger
            local aimSpdBox = makeSpeedRow("Aimbot Speed", "AimbotSpeed", optionsFrame)
            toggleRefs.aimbotSpeedBox = aimSpdBox
            if aimSpdBox then
                aimSpdBox.Text = tostring(tonumber(State.AimbotSpeed) or 62)
            end

            arrowBtn.MouseButton1Click:Connect(function()
                aimExpanded = not aimExpanded
                arrowBtn.Text = aimExpanded and "▼" or "▲"
                optionsFrame.Visible = aimExpanded
                pcall(function()
                    if refreshContentCanvas and categoryPages and categoryPages["MAIN"] then
                        refreshContentCanvas(categoryPages["MAIN"])
                    end
                end)
            end)
        end

        toggleRefs.tpBat = makeToggleRow("Tp Bat", State.tpBatEnabled, function(on, isSync)
            State.tpBatEnabled = on
            if on then
                pcall(startTpBat)
            else
                pcall(stopTpBat)
            end
            if not isSync then task.spawn(saveConfig) end
        end, "tpBat", tabCombat)

        -- Tp Bat mode cycle (V1-V3)
        do
            local mode = State.tpBatMode or "V1"
            local row = nil
            pcall(function()
                local kids = tabCombat:GetChildren()
                for i = #kids, 1, -1 do
                    if kids[i]:IsA("Frame") then
                        local lbl = kids[i]:FindFirstChildWhichIsA("TextLabel")
                        if lbl and tostring(lbl.Text) == "Tp Bat" then
                            row = kids[i]
                            break
                        end
                    end
                end
            end)
            if row then
                local verBtn = Instance.new("TextButton", row)
                verBtn.Name = "TpBatModePill"
                verBtn.Size = UDim2.new(0, 34, 0, 20)
                verBtn.Position = UDim2.new(1, -94, 0.5, -10)
                verBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 32)
                verBtn.BackgroundTransparency = 0.1
                verBtn.BorderSizePixel = 0
                verBtn.AutoButtonColor = false
                verBtn.Text = mode
                verBtn.TextColor3 = C.white
                verBtn.Font = Enum.Font.GothamBlack
                verBtn.TextSize = 10
                verBtn.ZIndex = 12
                mkCorner(verBtn, 6)
                mkStroke(verBtn, C.border, 1, 0.55)
                toggleRefs.tpBatModeLabel = verBtn
                local order = { "V1", "V2" }
                local lastCycleAt = 0
                local function cycleTpBatMode()
                    local now = os.clock()
                    if (now - lastCycleAt) < 0.18 then return end
                    lastCycleAt = now
                    local cur = tostring(State.tpBatMode or "V1")
                    if cur ~= "V1" and cur ~= "V2" then cur = "V1" end
                    local nxt = (cur == "V1") and "V2" or "V1"
                    State.tpBatMode = nxt
                    verBtn.Text = nxt
                    local wasOn = State.tpBatEnabled == true
                    if wasOn then
                        pcall(startTpBat)
                    end
                    task.spawn(saveConfig)
                end
                verBtn.Activated:Connect(cycleTpBatMode)
            end
        end

        makeLine(tabCombat)
        setupCombatTabToggles()
    end

    function setupStealTab1()
        do
            stealExpanded = false
            host = tabSteal
            mainRow = Instance.new("Frame", host)
            mainRow.Name = "AutoStealMainRow"
            mainRow.Size = UDim2.new(1, 0, 0, 34)
            mainRow.BackgroundColor3 = C.row
            mainRow.BackgroundTransparency = 0.22
            mainRow.BorderSizePixel = 0
            mainRow.LayoutOrder = LO()
            mainRow.ZIndex = 7
            mkCorner(mainRow, 10)
            mkStroke(mainRow, C.border, 1, 0.82)

            arrowBtn = Instance.new("TextButton", mainRow)
            arrowBtn.Name = "AutoStealArrow"
            arrowBtn.Size = UDim2.new(0, 22, 0, 22)
            arrowBtn.Position = UDim2.new(0, 6, 0.5, -11)
            arrowBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 32)
            arrowBtn.BackgroundTransparency = 0.15
            arrowBtn.BorderSizePixel = 0
            arrowBtn.Text = "▲"
            arrowBtn.TextColor3 = C.white
            arrowBtn.Font = Enum.Font.GothamBold
            arrowBtn.TextSize = 11
            arrowBtn.AutoButtonColor = false
            arrowBtn.ZIndex = 10
            mkCorner(arrowBtn, 11)

            lbl = Instance.new("TextLabel", mainRow)
            lbl.Size = UDim2.new(0.55, 0, 1, 0)
            lbl.Position = UDim2.new(0, 34, 0, 0)
            lbl.BackgroundTransparency = 1
            lbl.Text = "Auto Steal"
            lbl.TextColor3 = C.white
            lbl.Font = Enum.Font.GothamBold
            lbl.TextSize = 12
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.ZIndex = 8

            track = Instance.new("Frame", mainRow)
            track.Size = UDim2.new(0, 40, 0, 20)
            track.Position = UDim2.new(1, -52, 0.5, -10)
            track.BackgroundColor3 = State.autoStealEnabled and Color3.fromRGB(220, 220, 225) or C.pillOff
            track.BorderSizePixel = 0
            track.ZIndex = 8
            mkCorner(track, 10)

            knob = Instance.new("Frame", track)
            knob.Size = UDim2.new(0, 14, 0, 14)
            knob.Position = State.autoStealEnabled and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7)
            knob.BackgroundColor3 = State.autoStealEnabled and Color3.fromRGB(20, 20, 22) or C.textDim
            knob.BorderSizePixel = 0
            knob.ZIndex = 9
            mkCorner(knob, 7)

            toggleBtn = Instance.new("TextButton", mainRow)
            toggleBtn.Size = UDim2.new(0, 40, 0, 20)
            toggleBtn.Position = UDim2.new(1, -52, 0.5, -10)
            toggleBtn.BackgroundTransparency = 1
            toggleBtn.Text = ""
            toggleBtn.ZIndex = 11

            function setStealToggleVisual(on, noAnim)
                targetPos = on and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7)
                knobCol = on and Color3.fromRGB(20, 20, 22) or C.textDim
                trackCol = on and Color3.fromRGB(220, 220, 225) or C.pillOff
                if noAnim then
                    knob.Position = targetPos
                    knob.BackgroundColor3 = knobCol
                    track.BackgroundColor3 = trackCol
                else
                    tw(knob, {Position = targetPos, BackgroundColor3 = knobCol}, TweenInfo.new(0.22, Enum.EasingStyle.Quart, Enum.EasingDirection.Out))
                    tw(track, {BackgroundColor3 = trackCol}, TweenInfo.new(0.22, Enum.EasingStyle.Quart, Enum.EasingDirection.Out))
                end
            end

            toggleBtn.MouseButton1Click:Connect(function()
                State.autoStealEnabled = not State.autoStealEnabled
                Steal.AutoStealEnabled = State.autoStealEnabled
                setStealToggleVisual(State.autoStealEnabled, false)
                refreshStealBarVisible()
                if State.autoStealEnabled then
                    pcall(restartAutoStealForMode)
                else
                    pcall(stopAutoSteal)
                    pcall(stopV3AutoSteal)
                end
                task.spawn(saveConfig)
            end)
            toggleRefs.autoSteal = function(on, isSync)
                State.autoStealEnabled = on and true or false
                Steal.AutoStealEnabled = State.autoStealEnabled
                setStealToggleVisual(State.autoStealEnabled, isSync == true)
                refreshStealBarVisible()
                if State.autoStealEnabled then
                    pcall(restartAutoStealForMode)
                else
                    pcall(stopAutoSteal)
                    pcall(stopV3AutoSteal)
                end
                if not isSync then task.spawn(saveConfig) end
            end

            local optionsFrame = Instance.new("Frame", host)
            optionsFrame.Name = "AutoStealOptions"
            optionsFrame.Size = UDim2.new(1, 0, 0, 0)
            optionsFrame.AutomaticSize = Enum.AutomaticSize.Y
            optionsFrame.BackgroundTransparency = 1
            optionsFrame.BorderSizePixel = 0
            optionsFrame.Visible = false
            optionsFrame.LayoutOrder = LO()
            optionsFrame.ZIndex = 7

            optLayout = Instance.new("UIListLayout", optionsFrame)
            optLayout.SortOrder = Enum.SortOrder.LayoutOrder
            optLayout.Padding = UDim.new(0, 4)

            optPad = Instance.new("UIPadding", optionsFrame)
            optPad.PaddingLeft = UDim.new(0, 10)
            optPad.PaddingRight = UDim.new(0, 4)
            optPad.PaddingTop = UDim.new(0, 2)
            optPad.PaddingBottom = UDim.new(0, 2)

            _G.__KyzDuelsAutoStealOptions = optionsFrame

            arrowBtn.MouseButton1Click:Connect(function()
                stealExpanded = not stealExpanded
                arrowBtn.Text = stealExpanded and "▼" or "▲"
                optionsFrame.Visible = stealExpanded
                pcall(function()
                    if refreshContentCanvas and categoryPages and categoryPages["MAIN"] then
                        refreshContentCanvas(categoryPages["MAIN"])
                    end
                end)
            end)
        end
    end

    function makeSlideSelector(parent, names, stateKey, valueMap, onChange)
        local n = #(names or {})
        if n < 1 then n = 1 end
        local holder = Instance.new("Frame")
        holder.Name = "SlideSelector_" .. tostring(stateKey)
        holder.BackgroundColor3 = C.row
        holder.BackgroundTransparency = 0.22
        holder.Size = UDim2.new(1, 0, 0, 42)
        holder.BorderSizePixel = 0
        holder.LayoutOrder = LO()
        holder.ZIndex = 7
        holder.ClipsDescendants = true
        holder.Active = false
        holder.Parent = parent
        mkCorner(holder, 10)
        mkStroke(holder, C.border, 1, 0.82)

        local slide = Instance.new("Frame")
        slide.Name = "SelectedSlide"
        slide.BackgroundTransparency = 1
        slide.Size = UDim2.new(1 / n, -5, 1, -8)
        slide.Position = UDim2.new(0, 4, 0, 4)
        slide.BorderSizePixel = 0
        slide.ZIndex = 8
        slide.Visible = true
        slide.Parent = holder
        mkCorner(slide, 9)
        local slideStroke = Instance.new("UIStroke")
        slideStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        slideStroke.Color = Color3.fromRGB(240, 240, 245)
        slideStroke.Thickness = 1.4
        slideStroke.Transparency = 0.05
        slideStroke.Parent = slide

        local labels, clicks = {}, {}
        for i, name in ipairs(names) do
            local lbl = Instance.new("TextLabel")
            lbl.Name = name .. "Text"
            lbl.BackgroundTransparency = 1
            lbl.Text = name
            lbl.TextColor3 = C.white
            lbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
            lbl.TextStrokeTransparency = 0.2
            lbl.TextSize = 11
            lbl.Font = Enum.Font.GothamBold
            lbl.TextXAlignment = Enum.TextXAlignment.Center
            lbl.Size = UDim2.new(1 / n, 0, 1, 0)
            lbl.Position = UDim2.new((i - 1) / n, 0, 0, 0)
            lbl.ZIndex = 10
            lbl.Parent = holder
            labels[i] = lbl

            local btn = Instance.new("TextButton")
            btn.Name = name .. "Click"
            btn.BackgroundTransparency = 1
            btn.Text = ""
            btn.AutoButtonColor = false
            btn.Active = true
            btn.Selectable = true
            btn.Size = UDim2.new(1 / n, 0, 1, 0)
            btn.Position = UDim2.new((i - 1) / n, 0, 0, 0)
            btn.ZIndex = 20
            btn.Parent = holder
            clicks[i] = btn
        end

        local function findIdx()
            local cur = State[stateKey]
            if valueMap then
                for i, v in ipairs(valueMap) do
                    if v == cur then return i end
                end
                if type(cur) == "number" and cur >= 1 and cur <= #valueMap then
                    return cur
                end
                return 1
            end
            for i, nm in ipairs(names) do
                if nm == cur then return i end
            end
            return 1
        end

        local function applyVisual(idx)
            idx = tonumber(idx) or 1
            if idx < 1 then idx = 1 end
            if idx > n then idx = n end
            local xScale = (idx - 1) / n
            tw(slide, {
                Position = UDim2.new(xScale, 4, 0, 4)
            }, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out))
            for i, lbl in ipairs(labels) do
                local on = (i == idx)
                lbl.TextTransparency = on and 0 or 0.45
                lbl.TextStrokeTransparency = on and 0.25 or 0.6
                lbl.TextColor3 = on and C.white or Color3.fromRGB(160, 160, 165)
            end
        end

        local function setMode(idxOrValue, isSync)
            local idx
            if not isSync and type(idxOrValue) == "number" and idxOrValue >= 1 and idxOrValue <= n then
                idx = idxOrValue
            else
                if valueMap then
                    for i, v in ipairs(valueMap) do
                        if v == idxOrValue then
                            idx = i
                            break
                        end
                    end
                end
                if not idx then
                    for i, nm in ipairs(names) do
                        if nm == idxOrValue then
                            idx = i
                            break
                        end
                    end
                end
                if not idx and type(idxOrValue) == "number" and idxOrValue >= 1 and idxOrValue <= n then
                    idx = idxOrValue
                end
                idx = idx or findIdx()
            end
            idx = tonumber(idx) or 1
            if idx < 1 then idx = 1 end
            if idx > n then idx = n end
            local value = valueMap and valueMap[idx] or names[idx]
            State[stateKey] = value
            applyVisual(idx)
            if onChange and not isSync then
                pcall(onChange, value, false)
            end
            if not isSync then task.spawn(saveConfig) end
        end

        for i, btn in ipairs(clicks) do
            btn.MouseButton1Click:Connect(function()
                setMode(i, false)
            end)
        end

        initIdx = findIdx()
        slide.Position = UDim2.new((initIdx - 1) / n, 4, 0, 4)
        for i, lbl in ipairs(labels) do
            on = (i == initIdx)
            lbl.TextTransparency = on and 0 or 0.45
            lbl.TextStrokeTransparency = on and 0.25 or 0.6
            lbl.TextColor3 = on and C.white or Color3.fromRGB(160, 160, 165)
        end

        return setMode, holder
    end

    function setupStealTab2()
        parent = _G.__KyzDuelsAutoStealOptions or tabSteal
        local setMode = makeSlideSelector(parent, {"V1", "V2", "V3"}, "autoStealMode", {"V1", "V2", "V3"}, function(mode, isSync)
            applyAutoStealModeConfig()
            if State.autoStealEnabled then
                pcall(restartAutoStealForMode)
            end
        end)
        toggleRefs.autoStealMode = setMode
    end

    function setupStealTab3()
    end

    function setupStealTabSyncRagdoll()
        parent = _G.__KyzDuelsAutoStealOptions or tabSteal
        toggleRefs.syncStealRagdoll = makeToggleRow("Synchronize After Ragdol", State.syncStealRagdoll, function(on, isSync)
            State.syncStealRagdoll = on and true or false
            if on then
                pcall(_startSyncAfterHitWatcher)
            end
            if not isSync then task.spawn(saveConfig) end
        end, nil, parent)
    end

    function setupStealTab()
        makeSectionHeader("STEAL", tabSteal)
        setupStealTab1()
        setupStealTab2()
        setupStealTabSyncRagdoll()
        makeLine(tabSteal)
    end

    function setupMechTab1Part1()
        do
            dropExpanded = false
            host = tabMech
            mainRow = Instance.new("Frame", host)
            mainRow.Name = "DropMainRow"
            mainRow.Size = UDim2.new(1, 0, 0, 34)
            mainRow.BackgroundColor3 = C.row
            mainRow.BackgroundTransparency = 0.22
            mainRow.BorderSizePixel = 0
            mainRow.LayoutOrder = LO()
            mainRow.ZIndex = 7
            mkCorner(mainRow, 10)
            mkStroke(mainRow, C.border, 1, 0.82)

            arrowBtn = Instance.new("TextButton", mainRow)
            arrowBtn.Name = "DropArrow"
            arrowBtn.Size = UDim2.new(0, 22, 0, 22)
            arrowBtn.Position = UDim2.new(0, 6, 0.5, -11)
            arrowBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 32)
            arrowBtn.BackgroundTransparency = 0.15
            arrowBtn.BorderSizePixel = 0
            arrowBtn.Text = "▲"
            arrowBtn.TextColor3 = C.white
            arrowBtn.Font = Enum.Font.GothamBold
            arrowBtn.TextSize = 11
            arrowBtn.AutoButtonColor = false
            arrowBtn.ZIndex = 10
            mkCorner(arrowBtn, 11)

            lbl = Instance.new("TextLabel", mainRow)
            lbl.Size = UDim2.new(0.5, 0, 1, 0)
            lbl.Position = UDim2.new(0, 34, 0, 0)
            lbl.BackgroundTransparency = 1
            lbl.Text = "Drop Brainrot"
            lbl.TextColor3 = C.white
            lbl.Font = Enum.Font.GothamBold
            lbl.TextSize = 12
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.ZIndex = 8

            local dropKbBtn = Instance.new("TextButton", mainRow)
            dropKbBtn.Size = UDim2.new(0, 36, 0, 20)
            dropKbBtn.Position = UDim2.new(1, -48, 0.5, -10)
            dropKbBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 32)
            dropKbBtn.BackgroundTransparency = 0.1
            dropKbBtn.BorderSizePixel = 0
            dropKbBtn.Text = getKeyName(Keys.drop or Enum.KeyCode.H)
            dropKbBtn.TextColor3 = C.text
            dropKbBtn.Font = Enum.Font.GothamBold
            dropKbBtn.TextSize = 10
            dropKbBtn.AutoButtonColor = false
            dropKbBtn.ZIndex = 10
            mkCorner(dropKbBtn, 6)
            keybindBtnRefs.drop = dropKbBtn
            dropKbBtn.MouseButton1Click:Connect(function()
                if activeKeybindKeyRef == "drop" and activeKeybindListener then
                    cancelActiveKeybind()
                    return
                end
                cancelActiveKeybind()
                activeKeybindBtn = dropKbBtn
                activeKeybindKeyRef = "drop"
                activeKeybindPrevText = dropKbBtn.Text
                dropKbBtn.Text = "..."
                activeKeybindListener = UIS.InputBegan:Connect(function(inp, gp)
                    if gp then return end
                    if inp.UserInputType ~= Enum.UserInputType.Keyboard and inp.UserInputType ~= Enum.UserInputType.Gamepad1 then return end
                    if inp.KeyCode == Enum.KeyCode.Unknown then return end
                    if inp.KeyCode == Enum.KeyCode.Escape then
                        cancelActiveKeybind()
                        return
                    end
                    Keys.drop = inp.KeyCode
                    dropKbBtn.Text = getKeyName(inp.KeyCode)
                    if activeKeybindListener then pcall(function() activeKeybindListener:Disconnect() end); activeKeybindListener = nil end
                    activeKeybindBtn = nil
                    activeKeybindKeyRef = nil
                    task.spawn(saveConfig)
                end)
            end)

            local optionsFrame = Instance.new("Frame", host)
            optionsFrame.Name = "DropOptions"
            optionsFrame.Size = UDim2.new(1, 0, 0, 0)
            optionsFrame.AutomaticSize = Enum.AutomaticSize.Y
            optionsFrame.BackgroundTransparency = 1
            optionsFrame.BorderSizePixel = 0
            optionsFrame.Visible = false
            optionsFrame.LayoutOrder = LO()
            optionsFrame.ZIndex = 7

            optLayout = Instance.new("UIListLayout", optionsFrame)
            optLayout.SortOrder = Enum.SortOrder.LayoutOrder
            optLayout.Padding = UDim.new(0, 4)

            optPad = Instance.new("UIPadding", optionsFrame)
            optPad.PaddingLeft = UDim.new(0, 10)
            optPad.PaddingRight = UDim.new(0, 4)
            optPad.PaddingTop = UDim.new(0, 2)
            optPad.PaddingBottom = UDim.new(0, 2)

            local setDropMode = makeSlideSelector(optionsFrame, {"Single", "Jump"}, "dropMode", {0, 1}, function(mode, isSync)
                syncDropMode()
            end)
            toggleRefs.dropCycleLabel = setDropMode

            local dropAfterTpBatRef, dropAfterAimbotRef
            dropAfterTpBatRef = makeToggleRow("Active TP Bat after Drop", State.dropAfterAction == "tpBat", function(on, isSync)
                if on then
                    State.dropAfterAction = "tpBat"
                    if dropAfterAimbotRef then pcall(function() dropAfterAimbotRef(false, true) end) end
                else
                    if State.dropAfterAction == "tpBat" then State.dropAfterAction = "off" end
                end
                if not isSync then task.spawn(saveConfig) end
            end, nil, optionsFrame)

            dropAfterAimbotRef = makeToggleRow("Active Aimbot after Drop", State.dropAfterAction == "aimbot", function(on, isSync)
                if on then
                    State.dropAfterAction = "aimbot"
                    if dropAfterTpBatRef then pcall(function() dropAfterTpBatRef(false, true) end) end
                else
                    if State.dropAfterAction == "aimbot" then State.dropAfterAction = "off" end
                end
                if not isSync then task.spawn(saveConfig) end
            end, nil, optionsFrame)

            arrowBtn.MouseButton1Click:Connect(function()
                dropExpanded = not dropExpanded
                arrowBtn.Text = dropExpanded and "▼" or "▲"
                optionsFrame.Visible = dropExpanded
                pcall(function()
                    if refreshContentCanvas and categoryPages and categoryPages["MAIN"] then
                        refreshContentCanvas(categoryPages["MAIN"])
                    end
                end)
            end)
        end
    end

    function setupMechTab1Part2()
        makeMomentaryRow("TP Down", function() doTpDown() end, "tpDown", tabMech)

        makeMomentaryRow("Insta Reset", function() insta_reset() end, "instaReset", tabMech)
    end

    function setupMechTab1Part3()
        makeMomentaryRow("Auto Left", function() 
            State.autoLeftEnabled = not State.autoLeftEnabled
            if State.autoLeftEnabled then
                startAutoLeft()
            else
                stopAutoLeft()
            end
        end, "autoLeft", tabMech)
        makeMomentaryRow("Auto Right", function() 
            State.autoRightEnabled = not State.autoRightEnabled
            if State.autoRightEnabled then
                startAutoRight()
            else
                stopAutoRight()
            end
        end, "autoRight", tabMech)
    end

    
    -- =====================================================
    -- BRAINROT ANTI DROP (velocity spoof) — Kyz compact
    -- =====================================================
    State.antiDropSpoof = true
    local _adMt = nil
    local _adOldIdx, _adOldNewIdx = nil, nil
    local _adSpoofVel = Vector3.zero
    local _adActive = false
    pcall(function()
        _adMt = getrawmetatable(game)
    end)

    -- ALWAYS-ON: Anti Drop stays enabled internally (no UI toggle)
    local function startBrainrotAntiDrop()
        if _adActive then return end
        if not _adMt then return end
        if type(newcclosure) ~= "function" then return end
        local cc = checkcaller or function() return false end
        _adOldIdx = _adMt.__index
        _adOldNewIdx = _adMt.__newindex
        pcall(function() setreadonly(_adMt, false) end)
        _adMt.__index = newcclosure(function(self, key)
            if not cc()
                and (key == "AssemblyLinearVelocity" or key == "Velocity")
                and typeof(self) == "Instance"
                and self:IsA("BasePart")
                and self.Name == "HumanoidRootPart"
                and LP.Character and self:IsDescendantOf(LP.Character)
            then
                if (Drop and Drop.active) or (State and State._dropInProgress) or _G._7VYAllowVelWrite then
                    return _adOldIdx(self, key)
                end
                return _adSpoofVel
            end
            return _adOldIdx(self, key)
        end)
        _adMt.__newindex = newcclosure(function(self, key, value)
            if not cc()
                and (key == "AssemblyLinearVelocity" or key == "Velocity")
                and typeof(self) == "Instance"
                and self:IsA("BasePart")
                and self.Name == "HumanoidRootPart"
                and LP.Character and self:IsDescendantOf(LP.Character)
            then
                if (Drop and Drop.active) or (State and State._dropInProgress) or _G._7VYAllowVelWrite then
                    return _adOldNewIdx(self, key, value)
                end
                _adSpoofVel = value
                return
            end
            return _adOldNewIdx(self, key, value)
        end)
        pcall(function() setreadonly(_adMt, true) end)
        _adActive = true
        State.antiDropSpoof = true
    end

    local function stopBrainrotAntiDrop()
        if not _adActive then return end
        if _adMt and _adOldIdx then
            pcall(function() setreadonly(_adMt, false) end)
            _adMt.__index = _adOldIdx
            _adMt.__newindex = _adOldNewIdx
            pcall(function() setreadonly(_adMt, true) end)
            _adOldIdx, _adOldNewIdx = nil, nil
        end
        _adActive = false
        State.antiDropSpoof = false
    end

    -- always enable anti drop (internal)
    task.defer(function()
        pcall(startBrainrotAntiDrop)
    end)


    function setupMechTab2Part1()
        toggleRefs.antiRagdoll = makeToggleRow("Anti Ragdoll", State.antiRagdollEnabled, function(on, isSync)
            State.antiRagdollEnabled = on
            if on then
                startAntiRagdoll()
            else
                stopAntiRagdoll()
            end
            if not isSync then task.spawn(saveConfig) end
        end, nil, tabMech)


        toggleRefs.infJump = makeToggleRow("Infinite Jump", State.infJumpEnabled, function(on, isSync)
            State.infJumpEnabled = on
            if on then
                startInfJump()
            else
                stopInfJump()
            end
            if not isSync then task.spawn(saveConfig) end
        end, nil, tabMech)

        do
            local autoTPExpanded = false
            local host = tabMech
            local mainRow = Instance.new("Frame", host)
            mainRow.Name = "AutoTPMainRow"
            mainRow.Size = UDim2.new(1, 0, 0, 34)
            mainRow.BackgroundColor3 = C.row
            mainRow.BackgroundTransparency = 0.22
            mainRow.BorderSizePixel = 0
            mainRow.LayoutOrder = LO()
            mainRow.ZIndex = 7
            mkCorner(mainRow, 10)
            mkStroke(mainRow, C.border, 1, 0.82)

            local arrowBtn = Instance.new("TextButton", mainRow)
            arrowBtn.Name = "AutoTPArrow"
            arrowBtn.Size = UDim2.new(0, 22, 0, 22)
            arrowBtn.Position = UDim2.new(0, 6, 0.5, -11)
            arrowBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 32)
            arrowBtn.BackgroundTransparency = 0.15
            arrowBtn.BorderSizePixel = 0
            arrowBtn.Text = "▲"
            arrowBtn.TextColor3 = C.white
            arrowBtn.Font = Enum.Font.GothamBold
            arrowBtn.TextSize = 11
            arrowBtn.AutoButtonColor = false
            arrowBtn.ZIndex = 10
            mkCorner(arrowBtn, 11)

            local lbl = Instance.new("TextLabel", mainRow)
            lbl.Size = UDim2.new(0.55, 0, 1, 0)
            lbl.Position = UDim2.new(0, 34, 0, 0)
            lbl.BackgroundTransparency = 1
            lbl.Text = "Auto TP Down"
            lbl.TextColor3 = C.white
            lbl.Font = Enum.Font.GothamBold
            lbl.TextSize = 12
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.ZIndex = 8

            local track = Instance.new("Frame", mainRow)
            track.Size = UDim2.new(0, 40, 0, 20)
            track.Position = UDim2.new(1, -52, 0.5, -10)
            track.BackgroundColor3 = State.autoTPEnabled and Color3.fromRGB(220, 220, 225) or C.pillOff
            track.BorderSizePixel = 0
            track.ZIndex = 8
            mkCorner(track, 10)

            local knob = Instance.new("Frame", track)
            knob.Size = UDim2.new(0, 14, 0, 14)
            knob.Position = State.autoTPEnabled and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7)
            knob.BackgroundColor3 = State.autoTPEnabled and Color3.fromRGB(20, 20, 22) or C.textDim
            knob.BorderSizePixel = 0
            knob.ZIndex = 9
            mkCorner(knob, 7)

            local toggleBtn = Instance.new("TextButton", mainRow)
            toggleBtn.Size = UDim2.new(0, 40, 0, 20)
            toggleBtn.Position = UDim2.new(1, -52, 0.5, -10)
            toggleBtn.BackgroundTransparency = 1
            toggleBtn.Text = ""
            toggleBtn.ZIndex = 11

            local function setAutoTPToggleVisual(on, noAnim)
                targetPos = on and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7)
                knobCol = on and Color3.fromRGB(20, 20, 22) or C.textDim
                trackCol = on and Color3.fromRGB(220, 220, 225) or C.pillOff
                if noAnim then
                    knob.Position = targetPos
                    knob.BackgroundColor3 = knobCol
                    track.BackgroundColor3 = trackCol
                else
                    tw(knob, {Position = targetPos, BackgroundColor3 = knobCol}, TweenInfo.new(0.22, Enum.EasingStyle.Quart, Enum.EasingDirection.Out))
                    tw(track, {BackgroundColor3 = trackCol}, TweenInfo.new(0.22, Enum.EasingStyle.Quart, Enum.EasingDirection.Out))
                end
            end

            toggleBtn.MouseButton1Click:Connect(function()
                State.autoTPEnabled = not State.autoTPEnabled
                setAutoTPToggleVisual(State.autoTPEnabled, false)
                if State.autoTPEnabled then startAutoTP() else stopAutoTP() end
                task.spawn(saveConfig)
            end)
            toggleRefs.autoTP = function(on, isSync)
                State.autoTPEnabled = on and true or false
                setAutoTPToggleVisual(State.autoTPEnabled, isSync == true)
                if State.autoTPEnabled then startAutoTP() else stopAutoTP() end
                if not isSync then task.spawn(saveConfig) end
            end

            local optionsFrame = Instance.new("Frame", host)
            optionsFrame.Name = "AutoTPOptions"
            optionsFrame.Size = UDim2.new(1, 0, 0, 0)
            optionsFrame.AutomaticSize = Enum.AutomaticSize.Y
            optionsFrame.BackgroundTransparency = 1
            optionsFrame.BorderSizePixel = 0
            optionsFrame.Visible = false
            optionsFrame.LayoutOrder = LO()
            optionsFrame.ZIndex = 7

            optLayout = Instance.new("UIListLayout", optionsFrame)
            optLayout.SortOrder = Enum.SortOrder.LayoutOrder
            optLayout.Padding = UDim.new(0, 4)

            optPad = Instance.new("UIPadding", optionsFrame)
            optPad.PaddingLeft = UDim.new(0, 10)
            optPad.PaddingRight = UDim.new(0, 4)
            optPad.PaddingTop = UDim.new(0, 2)
            optPad.PaddingBottom = UDim.new(0, 2)

            makeInputRow("Y Limit", State.autoTPHeight or 20, function(n)
                v = tonumber(n)
                if v and v >= 1 and v <= 500 then
                    State.autoTPHeight = v
                    task.spawn(saveConfig)
                end
            end, optionsFrame)

            arrowBtn.MouseButton1Click:Connect(function()
                autoTPExpanded = not autoTPExpanded
                arrowBtn.Text = autoTPExpanded and "▼" or "▲"
                optionsFrame.Visible = autoTPExpanded
                pcall(function()
                    if refreshContentCanvas and categoryPages and categoryPages["MAIN"] then
                        refreshContentCanvas(categoryPages["MAIN"])
                    end
                end)
            end)
        end
    end

    function setupMechTab2Part2()
        toggleRefs.unwalk = makeToggleRow("Unwalk", State.unwalkEnabled, function(on, isSync)
            State.unwalkEnabled = on
            if on then
                startUnwalk()
            else
                stopUnwalk()
            end
            if not isSync then task.spawn(saveConfig) end
        end, nil, tabMech)

        toggleRefs.noCollide = makeToggleRow("No Collide", State.noCollideEnabled, function(on, isSync)
            State.noCollideEnabled = on
            if on then
                startNoCollide()
            else
                stopNoCollide()
            end
            if not isSync then task.spawn(saveConfig) end
        end, nil, tabMech)
    end

    -- ============================================================
    -- Kick Warning — UI: rope drop bar (logic unchanged)
    -- ============================================================
    local KickWarning = {
        sg = nil,
        root = nil,
        label = nil,
        sub = nil,
        warn = nil,
        rope = nil,
        ropeAccent = nil,
        active = false,
        startT = 0,
        timerConn = nil,
        wasCarrying = false,
        lastTriggered = -math.huge,
        generation = 0,
        loopConn = nil,
        DURATION = 2.5,
    }
    local KW_ROPE_COLOR = Color3.fromRGB(18, 18, 18)
    local KW_ROPE_ACCENT = Color3.fromRGB(240, 240, 240)

    local function kickWarningGetHui()
        local h
        pcall(function()
            if type(gethui) == "function" then
                h = gethui()
            end
        end)
        if h then return h end
        if type(parentGui) == "function" then
            -- parentGui expects instance; just return PlayerGui fallback host
        end
        return LP:FindFirstChild("PlayerGui") or LP:WaitForChild("PlayerGui", 5)
    end

    local function kickWarningDestroyGui()
        KickWarning.generation = KickWarning.generation + 1
        if KickWarning.timerConn then
            pcall(function() KickWarning.timerConn:Disconnect() end)
            KickWarning.timerConn = nil
        end
        if KickWarning.sg then
            pcall(function() KickWarning.sg:Destroy() end)
        end
        KickWarning.sg = nil
        KickWarning.root = nil
        KickWarning.label = nil
        KickWarning.sub = nil
        KickWarning.warn = nil
        KickWarning.rope = nil
        KickWarning.ropeAccent = nil
        KickWarning.active = false
    end

    local function kickWarningBuildGui()
        kickWarningDestroyGui()
        local parent = kickWarningGetHui()
        if not parent then return end
        pcall(function()
            local old = parent:FindFirstChild("KyzKickWarn")
            if old then old:Destroy() end
            local old2 = parent:FindFirstChild("Violet_KickWarning")
            if old2 then old2:Destroy() end
        end)

        local sg = Instance.new("ScreenGui")
        sg.Name = "KyzKickWarn"
        sg.ResetOnSpawn = false
        sg.IgnoreGuiInset = true
        sg.DisplayOrder = 80
        sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        pcall(function()
            if type(parentGui) == "function" then
                parentGui(sg)
            else
                sg.Parent = parent
            end
        end)
        if not sg.Parent then
            sg.Parent = parent
        end

        local rope = Instance.new("Frame")
        rope.Name = "Rope"
        rope.AnchorPoint = Vector2.new(0.5, 0)
        rope.Position = UDim2.new(0.5, 0, 0, -80)
        rope.Size = UDim2.new(0, 3, 0, 0)
        rope.BackgroundColor3 = KW_ROPE_COLOR
        rope.BorderSizePixel = 0
        rope.ZIndex = 4
        rope.Parent = sg

        local ropeAccent = Instance.new("Frame")
        ropeAccent.Name = "RopeAccent"
        ropeAccent.Size = UDim2.new(1, 0, 1, 0)
        ropeAccent.BackgroundColor3 = KW_ROPE_ACCENT
        ropeAccent.BackgroundTransparency = 0.75
        ropeAccent.BorderSizePixel = 0
        ropeAccent.ZIndex = 5
        ropeAccent.Parent = rope

        local root = Instance.new("Frame")
        root.Name = "KickBar"
        root.AnchorPoint = Vector2.new(0.5, 0)
        root.Position = UDim2.new(0.5, 0, 0, -100)
        root.Size = UDim2.new(0, 240, 0, 56)
        root.BackgroundColor3 = Color3.fromRGB(12, 12, 16)
        root.BackgroundTransparency = 0.08
        root.BorderSizePixel = 0
        root.Visible = false
        root.ZIndex = 6
        root.Parent = sg
        Instance.new("UICorner", root).CornerRadius = UDim.new(0, 8)

        local st = Instance.new("UIStroke")
        st.Thickness = 1.4
        st.Transparency = 0.25
        st.Color = Color3.fromRGB(255, 255, 255)
        st.Parent = root

        local label = Instance.new("TextLabel")
        label.BackgroundTransparency = 1
        label.Position = UDim2.new(0, 0, 0, 4)
        label.Size = UDim2.new(1, 0, 0, 14)
        label.Font = Enum.Font.GothamBlack
        label.Text = "Time to Steal - Kyz Duels"
        label.TextSize = 11
        label.TextColor3 = Color3.fromRGB(255, 255, 255)
        label.TextXAlignment = Enum.TextXAlignment.Center
        label.ZIndex = 8
        label.Parent = root

        local sub = Instance.new("TextLabel")
        sub.BackgroundTransparency = 1
        sub.Position = UDim2.new(0, 0, 0, 18)
        sub.Size = UDim2.new(1, 0, 0, 22)
        sub.Font = Enum.Font.GothamBlack
        sub.Text = "2.5s"
        sub.TextSize = 18
        sub.TextColor3 = Color3.fromRGB(255, 255, 255)
        sub.TextXAlignment = Enum.TextXAlignment.Center
        sub.ZIndex = 8
        sub.Parent = root

        local warn = Instance.new("TextLabel")
        warn.BackgroundTransparency = 1
        warn.Position = UDim2.new(0, 0, 0, 40)
        warn.Size = UDim2.new(1, 0, 0, 12)
        warn.Font = Enum.Font.Gotham
        warn.Text = "Do Not Steal!!"
        warn.TextSize = 10
        warn.TextColor3 = Color3.fromRGB(255, 255, 255)
        warn.TextXAlignment = Enum.TextXAlignment.Center
        warn.ZIndex = 8
        warn.Parent = root

        KickWarning.sg = sg
        KickWarning.root = root
        KickWarning.label = label
        KickWarning.sub = sub
        KickWarning.warn = warn
        KickWarning.rope = rope
        KickWarning.ropeAccent = ropeAccent
    end

    local function kickWarningPlayDrop()
        if not KickWarning.root or not KickWarning.rope then return end
        local finalY = 12
        local ropeHeight = finalY + 8
        KickWarning.root.Visible = true
        KickWarning.rope.Visible = true
        KickWarning.root.Position = UDim2.new(0.5, 0, 0, -100)
        KickWarning.rope.Size = UDim2.new(0, 3, 0, 0)
        KickWarning.rope.Position = UDim2.new(0.5, 0, 0, -80)
        local ropeTween = TweenService:Create(KickWarning.rope, TweenInfo.new(0.55, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Position = UDim2.new(0.5, 0, 0, 0),
            Size = UDim2.new(0, 3, 0, ropeHeight)
        })
        local barTween = TweenService:Create(KickWarning.root, TweenInfo.new(0.65, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Position = UDim2.new(0.5, 0, 0, finalY)
        })
        ropeTween:Play()
        barTween:Play()
    end

    local function kickWarningHideUI()
        if not KickWarning.root then return end
        local gen = KickWarning.generation
        local hide = TweenService:Create(KickWarning.root, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {
            Position = UDim2.new(0.5, 0, 0, -110)
        })
        local hideRope = nil
        if KickWarning.rope then
            hideRope = TweenService:Create(KickWarning.rope, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
                Size = UDim2.new(0, 3, 0, 0)
            })
            hideRope:Play()
        end
        hide:Play()
        hide.Completed:Connect(function()
            if gen ~= KickWarning.generation then return end
            if KickWarning.root then
                KickWarning.root.Visible = false
            end
            KickWarning.active = false
        end)
    end

    local function kickWarningClear()
        kickWarningDestroyGui()
    end

    local function kickWarningIsCarrying()
        local char = LP.Character
        if not char then return false end
        if type(isCarryingBrainrot) == "function" then
            local ok, res = pcall(isCarryingBrainrot, char)
            if ok and res then return true end
        end
        for _, child in ipairs(char:GetChildren()) do
            local lower = child.Name:lower()
            if lower:find("brainrot", 1, true) or lower:find("brain", 1, true)
                or lower:find("animal", 1, true) or lower:find("carry", 1, true)
                or lower:find("stolen", 1, true) or lower:find("held", 1, true)
                or lower:find("steal", 1, true) then
                if not (lower:find("bat") or lower:find("slap") or lower:find("medusa")) then
                    return true
                end
            end
        end
        for attributeName, attributeValue in pairs(char:GetAttributes()) do
            local lower = tostring(attributeName):lower()
            if attributeValue == true and (lower:find("carrying", 1, true)
                or lower:find("carry", 1, true) or lower:find("stealing", 1, true)
                or lower:find("isstealing", 1, true) or lower:find("hasbrainrot", 1, true)) then
                return true
            end
        end
        pcall(function()
            if LP:GetAttribute("Stealing") == true or LP:GetAttribute("HasBrainrot") == true then
                return true
            end
        end)
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        return humanoid ~= nil and humanoid.WalkSpeed > 0 and humanoid.WalkSpeed <= 25 and humanoid.WalkSpeed ~= 16
    end

    local function kickWarningStartCountdown()
        if not KickWarning.sg or not KickWarning.sg.Parent then
            kickWarningBuildGui()
        end
        if not KickWarning.root then return end
        local generation = KickWarning.generation
        local duration = tonumber(KickWarning.DURATION) or 2.5
        KickWarning.active = true
        KickWarning.startT = os.clock()
        if KickWarning.sub then
            KickWarning.sub.Text = string.format("%.1fs", duration)
        end
        if KickWarning.warn then
            KickWarning.warn.Text = "Do Not Steal!!"
        end
        kickWarningPlayDrop()

        if KickWarning.timerConn then
            pcall(function() KickWarning.timerConn:Disconnect() end)
            KickWarning.timerConn = nil
        end
        KickWarning.timerConn = RunService.Heartbeat:Connect(function()
            if generation ~= KickWarning.generation then
                if KickWarning.timerConn then
                    pcall(function() KickWarning.timerConn:Disconnect() end)
                    KickWarning.timerConn = nil
                end
                return
            end
            if not KickWarning.active then return end
            local elapsed = os.clock() - KickWarning.startT
            local left = math.max(0, duration - elapsed)
            if KickWarning.sub then
                KickWarning.sub.Text = string.format("%.1fs", left)
            end
            if KickWarning.warn then
                if left > 0 then
                    KickWarning.warn.Text = "Do Not Steal!!"
                else
                    KickWarning.warn.Text = "You can steal it!!!"
                end
            end
            if left <= 0 then
                if KickWarning.sub then
                    KickWarning.sub.Text = "0.0s"
                end
                KickWarning.active = false
                if KickWarning.timerConn then
                    pcall(function() KickWarning.timerConn:Disconnect() end)
                    KickWarning.timerConn = nil
                end
                task.delay(0.18, function()
                    if generation == KickWarning.generation then
                        kickWarningHideUI()
                    end
                end)
            end
        end)
    end

    function startKickWarning()
        State.kickWarningEnabled = true
        if KickWarning.loopConn then return end
        KickWarning.wasCarrying = false
        if not KickWarning.sg then
            pcall(kickWarningBuildGui)
        end
        KickWarning.loopConn = task.spawn(function()
            while State.kickWarningEnabled do
                task.wait(0.08)
                if not State.kickWarningEnabled then break end
                local carrying = kickWarningIsCarrying()
                -- dropped brainrot while timer/UI active → play exit animation
                if KickWarning.wasCarrying and not carrying then
                    if KickWarning.active or (KickWarning.root and KickWarning.root.Visible) then
                        KickWarning.active = false
                        if KickWarning.timerConn then
                            pcall(function() KickWarning.timerConn:Disconnect() end)
                            KickWarning.timerConn = nil
                        end
                        pcall(kickWarningHideUI)
                    end
                    KickWarning.wasCarrying = false
                elseif carrying and not KickWarning.wasCarrying and (os.clock() - KickWarning.lastTriggered) > 3.25 then
                    KickWarning.lastTriggered = os.clock()
                    pcall(kickWarningStartCountdown)
                    KickWarning.wasCarrying = true
                elseif carrying then
                    KickWarning.wasCarrying = true
                else
                    KickWarning.wasCarrying = false
                end
            end
            KickWarning.loopConn = nil
        end)
    end

    function stopKickWarning()
        State.kickWarningEnabled = false
        KickWarning.wasCarrying = false
        kickWarningClear()
    end

    LP.CharacterAdded:Connect(function()
        KickWarning.wasCarrying = false
        kickWarningClear()
    end)

    -- ============================================================
    -- High Ping Warn (Anti-Sammy style, black & white)
    -- ============================================================
    local HighPingWarn = {
        shownOnce = false,
        gui = nil,
        pingLbl = nil,
        bars = nil,
        loop = nil,
        threshold = 100,
        lastShown = 0,
    }

    local function highPingDestroy()
        if HighPingWarn.gui then
            pcall(function() HighPingWarn.gui:Destroy() end)
            HighPingWarn.gui = nil
            HighPingWarn.pingLbl = nil
            HighPingWarn.bars = nil
        end
    end

    local function highPingCreate(pingMs)
        highPingDestroy()
        local sg = Instance.new("ScreenGui")
        sg.Name = "Violet_HighPingWarn"
        sg.ResetOnSpawn = false
        sg.IgnoreGuiInset = true
        sg.DisplayOrder = 999
        sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        pcall(function()
            if type(parentGui) == "function" then
                parentGui(sg)
            elseif type(gethui) == "function" then
                sg.Parent = gethui()
            else
                sg.Parent = game:GetService("CoreGui")
            end
        end)
        if not sg.Parent then
            pcall(function()
                sg.Parent = LP:FindFirstChild("PlayerGui") or LP:WaitForChild("PlayerGui", 2)
            end)
        end

        local shadow = Instance.new("Frame", sg)
        shadow.Size = UDim2.fromOffset(210, 62)
        shadow.Position = UDim2.new(1, 14, 0, 18)
        shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        shadow.BackgroundTransparency = 0.55
        shadow.BorderSizePixel = 0
        shadow.ZIndex = 8
        Instance.new("UICorner", shadow).CornerRadius = UDim.new(0, 14)

        local card = Instance.new("Frame", sg)
        card.Size = UDim2.fromOffset(210, 62)
        card.Position = UDim2.new(1, 10, 0, 14)
        card.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
        card.BackgroundTransparency = 0.04
        card.BorderSizePixel = 0
        card.ZIndex = 10
        card.ClipsDescendants = true
        Instance.new("UICorner", card).CornerRadius = UDim.new(0, 14)

        local cStroke = Instance.new("UIStroke", card)
        cStroke.Color = Color3.fromRGB(220, 220, 220)
        cStroke.Thickness = 1
        cStroke.Transparency = 0.35

        local grad = Instance.new("UIGradient", card)
        grad.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(22, 22, 22)),
            ColorSequenceKeypoint.new(0.55, Color3.fromRGB(10, 10, 10)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(16, 16, 16)),
        })
        grad.Rotation = 12

        local rail = Instance.new("Frame", card)
        rail.Size = UDim2.new(0, 3, 1, -12)
        rail.Position = UDim2.fromOffset(0, 8)
        rail.BackgroundColor3 = Color3.fromRGB(240, 240, 240)
        rail.BorderSizePixel = 0
        rail.ZIndex = 12
        Instance.new("UICorner", rail).CornerRadius = UDim.new(1, 0)

        local badge = Instance.new("Frame", card)
        badge.Size = UDim2.fromOffset(36, 36)
        badge.Position = UDim2.fromOffset(12, 13)
        badge.BackgroundColor3 = Color3.fromRGB(245, 245, 245)
        badge.BorderSizePixel = 0
        badge.ZIndex = 12
        badge.Rotation = -6
        Instance.new("UICorner", badge).CornerRadius = UDim.new(0, 12)

        local badgeStroke = Instance.new("UIStroke", badge)
        badgeStroke.Color = Color3.fromRGB(180, 180, 180)
        badgeStroke.Thickness = 1.5
        badgeStroke.Transparency = 0.15

        local badgeTxt = Instance.new("TextLabel", badge)
        badgeTxt.Size = UDim2.fromScale(1, 1)
        badgeTxt.BackgroundTransparency = 1
        badgeTxt.Text = "!"
        badgeTxt.TextColor3 = Color3.fromRGB(10, 10, 10)
        badgeTxt.Font = Enum.Font.GothamBlack
        badgeTxt.TextSize = 18
        badgeTxt.ZIndex = 13

        local warnLbl = Instance.new("TextLabel", card)
        warnLbl.Size = UDim2.fromOffset(130, 14)
        warnLbl.Position = UDim2.fromOffset(56, 10)
        warnLbl.BackgroundTransparency = 1
        warnLbl.Text = "HIGH PING"
        warnLbl.TextColor3 = Color3.fromRGB(245, 245, 245)
        warnLbl.Font = Enum.Font.GothamBlack
        warnLbl.TextSize = 11
        warnLbl.TextXAlignment = Enum.TextXAlignment.Left
        warnLbl.ZIndex = 12

        local pingLbl = Instance.new("TextLabel", card)
        pingLbl.Size = UDim2.fromOffset(130, 22)
        pingLbl.Position = UDim2.fromOffset(56, 24)
        pingLbl.BackgroundTransparency = 1
        pingLbl.Text = tostring(pingMs or "--") .. " ms"
        pingLbl.TextColor3 = Color3.fromRGB(230, 230, 230)
        pingLbl.Font = Enum.Font.GothamBold
        pingLbl.TextSize = 16
        pingLbl.TextXAlignment = Enum.TextXAlignment.Left
        pingLbl.ZIndex = 12

        local bars = {}
        local barHost = Instance.new("Frame", card)
        barHost.Size = UDim2.fromOffset(52, 14)
        barHost.Position = UDim2.fromOffset(56, 44)
        barHost.BackgroundTransparency = 1
        barHost.ZIndex = 12
        for i = 1, 4 do
            local bar = Instance.new("Frame", barHost)
            bar.Size = UDim2.fromOffset(9, 4 + i * 2)
            bar.Position = UDim2.fromOffset((i - 1) * 12, 14 - (4 + i * 2))
            bar.BackgroundColor3 = Color3.fromRGB(235, 235, 235)
            bar.BackgroundTransparency = 0.7
            bar.BorderSizePixel = 0
            bar.ZIndex = 13
            Instance.new("UICorner", bar).CornerRadius = UDim.new(0, 2)
            bars[i] = bar
        end

        -- slide in
        card.Position = UDim2.new(1, 24, 0, 14)
        shadow.Position = UDim2.new(1, 28, 0, 18)
        TweenService:Create(card, TweenInfo.new(0.35, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
            Position = UDim2.new(1, -222, 0, 14)
        }):Play()
        TweenService:Create(shadow, TweenInfo.new(0.35, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
            Position = UDim2.new(1, -218, 0, 18)
        }):Play()

        HighPingWarn.gui = sg
        HighPingWarn.pingLbl = pingLbl
        HighPingWarn.bars = bars
        HighPingWarn.rail = rail

        local active = math.clamp(math.ceil((tonumber(pingMs) or 100) / 70), 1, 4)
        for i, bar in ipairs(bars) do
            bar.BackgroundTransparency = i <= active and 0.06 or 0.72
        end
        return sg
    end

    local function highPingUpdate(pingMs)
        if not HighPingWarn.gui or not HighPingWarn.gui.Parent then
            highPingCreate(pingMs)
            return
        end
        if HighPingWarn.pingLbl then
            HighPingWarn.pingLbl.Text = tostring(pingMs) .. " ms"
        end
        if HighPingWarn.bars then
            local active = math.clamp(math.ceil(pingMs / 70), 1, 4)
            for i, bar in ipairs(HighPingWarn.bars) do
                bar.BackgroundTransparency = i <= active and 0.06 or 0.72
            end
        end
    end

    function startHighPingWarn()
        State.highPingWarnEnabled = true
        if HighPingWarn.shownOnce then return end
        if HighPingWarn.loop then return end
        HighPingWarn.loop = task.spawn(function()
            while State.highPingWarnEnabled and not HighPingWarn.shownOnce do
                task.wait(0.35)
                if not State.highPingWarnEnabled then break end
                local ok, ping = pcall(function() return LP:GetNetworkPing() * 1000 end)
                if ok and type(ping) == "number" and ping > (HighPingWarn.threshold or 100) then
                    HighPingWarn.shownOnce = true
                    highPingCreate(math.floor(ping + 0.5))
                    task.wait(3)
                    highPingDestroy()
                    break
                end
            end
            HighPingWarn.loop = nil
        end)
    end

    function stopHighPingWarn()
        State.highPingWarnEnabled = false
        highPingDestroy()
    end


function setupMechTab2Part3()
        toggleRefs.noCamCollision = makeToggleRow("No Cam Collision", State.noCamCollisionEnabled, function(on, isSync)
            State.noCamCollisionEnabled = on
            applyNoCamCollision(on)
            if not isSync then task.spawn(saveConfig) end
        end, nil, tabMech)

        toggleRefs.shinyGraphics = makeToggleRow("Shiny Graphics", State.shinyGraphicsEnabled, function(on, isSync)
            State.shinyGraphicsEnabled = on and true or false
            applyShinyGraphics(on)
            if not isSync then task.spawn(saveConfig) end
        end, nil, tabMech)

        toggleRefs.antiVoid = makeToggleRow("Anti Void", State.antiVoidEnabled, function(on, isSync)
            State.antiVoidEnabled = on and true or false
            _G.AmbitiousAntiVoidEnabled = State.antiVoidEnabled
            if _G.AmbitiousAntiVoid and _G.AmbitiousAntiVoid.setEnabled then
                pcall(_G.AmbitiousAntiVoid.setEnabled, State.antiVoidEnabled)
            end
            if not isSync then task.spawn(saveConfig) end
        end, nil, tabMech)

        toggleRefs.uiLocked = makeToggleRow("Lock UI", State.uiLocked, function(on, isSync)
            State.uiLocked = on
            if not isSync then task.spawn(saveConfig) end
        end, nil, tabMech)

        toggleRefs.safeMode = makeToggleRow("Safe Mode", State.safeModeEnabled, function(on, isSync)
            State.safeModeEnabled = on
            if not isSync then task.spawn(saveConfig) end
        end, nil, tabMech)

        toggleRefs.kickWarning = makeToggleRow("Kick Warning", State.kickWarningEnabled, function(on, isSync)
            State.kickWarningEnabled = on
            if on then pcall(startKickWarning) else pcall(stopKickWarning) end
            if not isSync then task.spawn(saveConfig) end
        end, nil, tabMech)

        toggleRefs.highPingWarn = makeToggleRow("High Ping Warn", State.highPingWarnEnabled, function(on, isSync)
            State.highPingWarnEnabled = on
            if on then pcall(startHighPingWarn) else pcall(stopHighPingWarn) end
            if not isSync then task.spawn(saveConfig) end
        end, nil, tabMech)

        -- Night Mode above Tryhard (MECH)
        pcall(setupNightModeMech)

        do
            local thExpanded = false
            local host = tabMech
            local mainRow = Instance.new("Frame", host)
            mainRow.Name = "TryhardMainRow"
            mainRow.Size = UDim2.new(1, 0, 0, 34)
            mainRow.BackgroundColor3 = C.row
            mainRow.BackgroundTransparency = 0.22
            mainRow.BorderSizePixel = 0
            mainRow.LayoutOrder = LO()
            mainRow.ZIndex = 7
            mkCorner(mainRow, 10)
            mkStroke(mainRow, C.border, 1, 0.82)

            local arrowBtn = Instance.new("TextButton", mainRow)
            arrowBtn.Name = "TryhardArrow"
            arrowBtn.Size = UDim2.new(0, 22, 0, 22)
            arrowBtn.Position = UDim2.new(0, 6, 0.5, -11)
            arrowBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 32)
            arrowBtn.BackgroundTransparency = 0.15
            arrowBtn.BorderSizePixel = 0
            arrowBtn.Text = "▲"
            arrowBtn.TextColor3 = C.white
            arrowBtn.Font = Enum.Font.GothamBold
            arrowBtn.TextSize = 11
            arrowBtn.AutoButtonColor = false
            arrowBtn.ZIndex = 10
            mkCorner(arrowBtn, 11)

            local lbl = Instance.new("TextLabel", mainRow)
            lbl.Size = UDim2.new(0.55, 0, 1, 0)
            lbl.Position = UDim2.new(0, 34, 0, 0)
            lbl.BackgroundTransparency = 1
            lbl.Text = "Tryhard Animation"
            lbl.TextColor3 = C.white
            lbl.Font = Enum.Font.GothamBold
            lbl.TextSize = 12
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.ZIndex = 8

            local track = Instance.new("Frame", mainRow)
            track.Size = UDim2.new(0, 40, 0, 20)
            track.Position = UDim2.new(1, -52, 0.5, -10)
            track.BackgroundColor3 = State.tryhardAnimEnabled and Color3.fromRGB(235, 235, 240) or Color3.fromRGB(40, 40, 44)
            track.BackgroundTransparency = 0
            track.BorderSizePixel = 0
            track.ZIndex = 8
            mkCorner(track, 10)

            local knob = Instance.new("Frame", track)
            knob.Size = UDim2.new(0, 14, 0, 14)
            knob.Position = State.tryhardAnimEnabled and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7)
            knob.BackgroundColor3 = State.tryhardAnimEnabled and Color3.fromRGB(20, 20, 22) or Color3.fromRGB(150, 150, 155)
            knob.BackgroundTransparency = 0
            knob.BorderSizePixel = 0
            knob.ZIndex = 9
            mkCorner(knob, 7)

            local toggleBtn = Instance.new("TextButton", mainRow)
            toggleBtn.Size = UDim2.new(0, 40, 0, 20)
            toggleBtn.Position = UDim2.new(1, -52, 0.5, -10)
            toggleBtn.BackgroundTransparency = 1
            toggleBtn.Text = ""
            toggleBtn.ZIndex = 11

            local function setTryhardToggleVisual(on, noAnim)
                on = on and true or false
                local targetPos = on and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7)
                local knobCol = on and Color3.fromRGB(20, 20, 22) or Color3.fromRGB(150, 150, 155)
                local trackCol = on and Color3.fromRGB(235, 235, 240) or Color3.fromRGB(40, 40, 44)
                track.BackgroundTransparency = 0
                knob.BackgroundTransparency = 0
                track.BackgroundColor3 = trackCol
                knob.BackgroundColor3 = knobCol
                knob.Position = targetPos
            end

            toggleBtn.MouseButton1Click:Connect(function()
                State.tryhardAnimEnabled = not State.tryhardAnimEnabled
                setTryhardToggleVisual(State.tryhardAnimEnabled, false)
                setCustomAnims()
                task.spawn(saveConfig)
            end)
            toggleRefs.tryhardAnim = function(on, isSync)
                State.tryhardAnimEnabled = on and true or false
                setTryhardToggleVisual(State.tryhardAnimEnabled, isSync == true)
                if not isSync then
                    setCustomAnims()
                    task.spawn(saveConfig)
                end
            end

            local optionsFrame = Instance.new("Frame", host)
            optionsFrame.Name = "TryhardOptions"
            optionsFrame.Size = UDim2.new(1, 0, 0, 0)
            optionsFrame.AutomaticSize = Enum.AutomaticSize.Y
            optionsFrame.BackgroundTransparency = 1
            optionsFrame.BorderSizePixel = 0
            optionsFrame.Visible = false
            optionsFrame.LayoutOrder = LO()
            optionsFrame.ZIndex = 7

            optLayout = Instance.new("UIListLayout", optionsFrame)
            optLayout.SortOrder = Enum.SortOrder.LayoutOrder
            optLayout.Padding = UDim.new(0, 4)

            optPad = Instance.new("UIPadding", optionsFrame)
            optPad.PaddingLeft = UDim.new(0, 10)
            optPad.PaddingRight = UDim.new(0, 4)
            optPad.PaddingTop = UDim.new(0, 2)
            optPad.PaddingBottom = UDim.new(0, 2)

            local setTryhardMode = makeSlideSelector(optionsFrame, {"V1", "V2", "V3", "V4", "CUSTOM"}, "tryhardAnimMode", {0, 1, 2, 3, 4}, function(mode, isSync)
                if mode == 4 and not isSync then
                    pcall(openKyzDuelsCustomAnimation)
                end
                if State.tryhardAnimEnabled then
                    setCustomAnims()
                end
            end)
            toggleRefs.tryhardAnimModeLabel = setTryhardMode

            arrowBtn.MouseButton1Click:Connect(function()
                thExpanded = not thExpanded
                arrowBtn.Text = thExpanded and "▼" or "▲"
                optionsFrame.Visible = thExpanded
                pcall(function()
                    if refreshContentCanvas and categoryPages and categoryPages["MAIN"] then
                        refreshContentCanvas(categoryPages["MAIN"])
                    end
                end)
            end)
        end

        makeLine(tabMech)
        makeLine(tabMech)
    end

    antiFlingCfg = {
        maxLinearVelocity = 80,
        maxAngularVelocity = 15,
    }
    antiFlingStepped = nil

    antiDieConns = {}
    antiDieHeartConn = nil
    antiDieCharAddedConn = nil
    antiDieEnabled = false
    _G._AmbitiousAntiDieUserWanted = _G._AmbitiousAntiDieUserWanted or false
    antiDieConnections = {}
    local _SV_fb = { setAntiDieVisual = function() end }
    local _SV = _G._SV or _SV_fb

    local function applyGodMode(character)
        if not character or not character.Parent then return end
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        local root = character:FindFirstChild("HumanoidRootPart")
        if not humanoid then return end

        pcall(function()
            humanoid.MaxHealth = math.max(humanoid.MaxHealth or 100, 100)
            humanoid.Health = humanoid.MaxHealth
            humanoid.BreakJointsOnDeath = false
            humanoid.RequiresNeck = false
            humanoid.PlatformStand = false
            humanoid.Sit = false
            pcall(function()
                humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
                humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
                humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
                humanoid:SetStateEnabled(Enum.HumanoidStateType.Physics, false)
            end)
            local st = humanoid:GetState()
            if st == Enum.HumanoidStateType.Dead
                or st == Enum.HumanoidStateType.Physics
                or st == Enum.HumanoidStateType.Ragdoll
                or st == Enum.HumanoidStateType.FallingDown then
                humanoid:ChangeState(Enum.HumanoidStateType.Running)
            end
            if not character:FindFirstChild("K7TPBatFF") then
                local ff = Instance.new("ForceField")
                ff.Name = "K7TPBatFF"
                ff.Visible = false
                ff.Parent = character
            end
        end)

        antiDieConnections[character] = {conns = {}, tasks = {}}
    end

    function startAntiDie(silent)
        antiDieEnabled = true
        _G._AmbitiousAntiDieUserWanted = true
        State.antiDieEnabled = true
        if not silent and _SV.setAntiDieVisual then pcall(_SV.setAntiDieVisual, true) end

        if not antiDieHeartConn then
            antiDieHeartConn = RunService.Heartbeat:Connect(function()
                if not antiDieEnabled then return end
                if _G._AmbitiousInstantResetBusy or (InstaReset and InstaReset.bypassAnti) then return end
                local char = LP.Character
                if not char then return end
                local hum = char:FindFirstChildOfClass("Humanoid")
                if not hum then return end
                pcall(function()
                    if hum.BreakJointsOnDeath == true then hum.BreakJointsOnDeath = false end
                    if hum.RequiresNeck == true then hum.RequiresNeck = false end
                    if hum.Health < hum.MaxHealth then hum.Health = hum.MaxHealth end
                    local st = hum:GetState()
                    if st == Enum.HumanoidStateType.Dead
                        or st == Enum.HumanoidStateType.Physics
                        or st == Enum.HumanoidStateType.Ragdoll
                        or st == Enum.HumanoidStateType.FallingDown then
                        hum:ChangeState(Enum.HumanoidStateType.Running)
                    end
                    if not char:FindFirstChild("K7TPBatFF") then
                        local ff = Instance.new("ForceField")
                        ff.Name = "K7TPBatFF"
                        ff.Visible = false
                        ff.Parent = char
                    end
                end)
            end)
        end

        local char = LP.Character
        if char then
            applyGodMode(char)
        end
        if not antiDieCharAddedConn then
            antiDieCharAddedConn = LP.CharacterAdded:Connect(function(newChar)
                task.wait(0.2)
                if antiDieEnabled then
                    applyGodMode(newChar)
                end
            end)
        end
    end

    function stopAntiDie(silent)
        antiDieEnabled = false
        _G._AmbitiousAntiDieUserWanted = false
        State.antiDieEnabled = false
        if not silent and _SV.setAntiDieVisual then pcall(_SV.setAntiDieVisual, false) end

        if antiDieHeartConn then
            pcall(function() antiDieHeartConn:Disconnect() end)
            antiDieHeartConn = nil
        end

        for character, entry in pairs(antiDieConnections) do
            pcall(function()
                local hum = character:FindFirstChildOfClass("Humanoid")
                if hum then
                    hum:SetStateEnabled(Enum.HumanoidStateType.Dead, true)
                    hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, true)
                    hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
                    pcall(function() hum:SetStateEnabled(Enum.HumanoidStateType.Physics, true) end)
                    hum.BreakJointsOnDeath = true
                    hum.RequiresNeck       = true
                end
                local ff = character:FindFirstChild("K7TPBatFF")
                if ff then ff:Destroy() end
            end)
        end
        antiDieConnections = {}

        if antiDieCharAddedConn then
            pcall(function() antiDieCharAddedConn:Disconnect() end)
            antiDieCharAddedConn = nil
        end

        local char = LP.Character
        if char then
            pcall(function()
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum then
                    hum:SetStateEnabled(Enum.HumanoidStateType.Dead, true)
                    hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, true)
                    hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
                    pcall(function() hum:SetStateEnabled(Enum.HumanoidStateType.Physics, true) end)
                    hum.BreakJointsOnDeath = true
                    hum.RequiresNeck       = true
                end
                local ff = char:FindFirstChild("K7TPBatFF")
                if ff then ff:Destroy() end
            end)
        end
    end

    local function setAntiDie(on)
        if _G.AmbitiousAntiDieUserOverride then pcall(_G.AmbitiousAntiDieUserOverride) end
        antiDieEnabled = on and true or false
        _G._AmbitiousAntiDieUserWanted = antiDieEnabled
        if antiDieEnabled then
            startAntiDie()
        else
            stopAntiDie()
        end
    end

    _G.AmbitiousAntiDieArmNow = function()
        if not antiDieEnabled then
            startAntiDie(true)
        end
    end

    function clearAntiDieConns()
        stopAntiDie(true)
    end

    function activateAntiDie(char)
        if not char then return end
        if _G._AmbitiousInstantResetBusy or (InstaReset and InstaReset.bypassAnti) then return end
        if not antiDieEnabled then
            antiDieEnabled = true
            State.antiDieEnabled = true
            _G._AmbitiousAntiDieUserWanted = true
        end
        applyGodMode(char)
    end

    _antiFlingLastCollide = 0
    function antiFlingHandler()
        if not State.antiFlingEnabled then return end
        if InstaReset and InstaReset.bypassAnti then return end
        if Drop and Drop.active then return end
        if State and State._dropInProgress then return end
        character = LP.Character
        if not character then return end
        rootPart = character:FindFirstChild("HumanoidRootPart")
        if not rootPart then return end

        linVel = rootPart.AssemblyLinearVelocity
        if linVel and linVel.Magnitude > antiFlingCfg.maxLinearVelocity then
            m = antiFlingCfg.maxLinearVelocity
            rootPart.AssemblyLinearVelocity = Vector3.new(
                math.clamp(linVel.X, -m, m),
                math.clamp(linVel.Y, -m, m),
                math.clamp(linVel.Z, -m, m)
            )
        end

        ang = rootPart.AssemblyAngularVelocity
        if ang and ang.Magnitude > antiFlingCfg.maxAngularVelocity then
            rootPart.AssemblyAngularVelocity = Vector3.zero
        end

        now = os.clock()
        if now - _antiFlingLastCollide < 1.5 then return end
        _antiFlingLastCollide = now
        for _, otherPlayer in ipairs(Players:GetPlayers()) do
            if otherPlayer ~= LP then
                otherChar = otherPlayer.Character
                if otherChar then
                    for _, part in ipairs(otherChar:GetChildren()) do
                        if part:IsA("BasePart") then
                            pcall(function()
                                part.CanCollide = false
                                part.CanTouch = false
                                part.CanQuery = false
                            end)
                        end
                    end
                end
            end
        end
    end

    function startAntiFling()
        State.antiFlingEnabled = true
        if antiFlingStepped then
            pcall(function() antiFlingStepped:Disconnect() end)
            antiFlingStepped = nil
        end
        antiFlingStepped = RunService.Heartbeat:Connect(antiFlingHandler)
    end

    function stopAntiFling()
        State.antiFlingEnabled = false
        if antiFlingStepped then
            pcall(function() antiFlingStepped:Disconnect() end)
            antiFlingStepped = nil
        end
    end

    if not _G.__KyzDuelsAntiDieCharConn then
        _G.__KyzDuelsAntiDieCharConn = true
        LP.CharacterAdded:Connect(function(char)
            task.wait(0.15)
            clearAntiDieConns()
            activateAntiDie(char)
        end)
    end

    
State.antiDieEnabled = true
task.defer(function()
    task.wait(0.3)
    pcall(startAntiDie)
end)

function setupMechTab1()
        makeSectionHeader("MECH", tabMech)
        setupMechTab1Part1()
        setupMechTab1Part2()
        setupMechTab1Part3()
    end

    function setupMechTab2()
        setupMechTab2Part1()
        setupMechTab2Part2()
        setupMechTab2Part3()
    end

    function setupMechTab()
        setupMechTab1()
        setupMechTab2()
        -- Night Mode is placed above Tryhard inside setupMechTab2Part3
    end

    xrayCache = {}

    -- ============================================================
    -- X-RAY COMPLETO (from ambitious.txt)
    -- ============================================================
    _G._AmbitiousXRayFolders = _G._AmbitiousXRayFolders or {
        "Base", "PlotSign", "FriendPanel", "Cash", "Laser",
        "Decorations", "Skin", "Unlock", "Purchases"
    }
    _G._AmbitiousXRayOrigTrans = _G._AmbitiousXRayOrigTrans or {}
    _G._AmbitiousXRayConns = _G._AmbitiousXRayConns or {}
    _G._AmbitiousXRayLoopId = _G._AmbitiousXRayLoopId or 0

    local function setXRayTargetTransparency(inst, targetTrans, targetStudsPerTileU, targetStudsPerTileV)
        if inst:IsA("BasePart") then
            if not _G._AmbitiousXRayOrigTrans[inst] then
                _G._AmbitiousXRayOrigTrans[inst] = {
                    Transparency = inst.Transparency,
                    LocalTransparencyModifier = inst.LocalTransparencyModifier
                }
            end
            local orig = _G._AmbitiousXRayOrigTrans[inst].Transparency or 0
            inst.Transparency = orig + (1 - orig) * targetTrans
            inst.LocalTransparencyModifier = targetTrans

        elseif inst:IsA("TextLabel") or inst:IsA("TextButton") then
            if not _G._AmbitiousXRayOrigTrans[inst] then
                _G._AmbitiousXRayOrigTrans[inst] = {TextTransparency = inst.TextTransparency}
            end
            local orig = _G._AmbitiousXRayOrigTrans[inst].TextTransparency or 0
            inst.TextTransparency = orig + (1 - orig) * targetTrans

        elseif inst:IsA("Frame") or inst:IsA("ScrollingFrame") then
            if not _G._AmbitiousXRayOrigTrans[inst] then
                _G._AmbitiousXRayOrigTrans[inst] = {BackgroundTransparency = inst.BackgroundTransparency}
            end
            local orig = _G._AmbitiousXRayOrigTrans[inst].BackgroundTransparency or 0
            inst.BackgroundTransparency = orig + (1 - orig) * targetTrans

        elseif inst:IsA("ImageLabel") or inst:IsA("ImageButton") then
            if not _G._AmbitiousXRayOrigTrans[inst] then
                _G._AmbitiousXRayOrigTrans[inst] = {ImageTransparency = inst.ImageTransparency}
            end
            local orig = _G._AmbitiousXRayOrigTrans[inst].ImageTransparency or 0
            inst.ImageTransparency = orig + (1 - orig) * targetTrans

        elseif inst:IsA("Texture") then
            if not _G._AmbitiousXRayOrigTrans[inst] then
                _G._AmbitiousXRayOrigTrans[inst] = {
                    Transparency = inst.Transparency,
                    StudsPerTileU = inst.StudsPerTileU,
                    StudsPerTileV = inst.StudsPerTileV
                }
            end
            local orig = _G._AmbitiousXRayOrigTrans[inst].Transparency or 0
            inst.Transparency = orig + (1 - orig) * targetTrans
            inst.StudsPerTileU = targetStudsPerTileU or inst.StudsPerTileU
            inst.StudsPerTileV = targetStudsPerTileV or inst.StudsPerTileV
        end
    end

    local function trackXRaySubtree(folder, targetTrans, loopId)
        if not folder then return end
        local function processXRayInstance(inst)
            if _G._AmbitiousXRayLoopId ~= loopId then return end
            setXRayTargetTransparency(inst, targetTrans)
        end
        for _, desc in ipairs(folder:GetDescendants()) do
            task.spawn(processXRayInstance, desc)
        end
        local conn = folder.DescendantAdded:Connect(function(inst)
            if _G._AmbitiousXRayLoopId ~= loopId then
                pcall(function() conn:Disconnect() end)
                return
            end
            setXRayTargetTransparency(inst, targetTrans)
        end)
        table.insert(_G._AmbitiousXRayConns, conn)
    end

    local function processPlotXRay(plot, targetTrans, loopId)
        if not plot then return end
        for _, folderName in ipairs(_G._AmbitiousXRayFolders) do
            if _G._AmbitiousXRayLoopId ~= loopId then return end
            local folder = plot:FindFirstChild(folderName)
            if folder then
                task.spawn(trackXRaySubtree, folder, targetTrans, loopId)
            end
        end
        local podiums = plot:FindFirstChild("AnimalPodiums")
        if podiums then
            local function processPodium(pod)
                if _G._AmbitiousXRayLoopId ~= loopId or not pod then return end
                local claim = pod:FindFirstChild("Claim")
                if claim then
                    for _, d in ipairs(claim:GetDescendants()) do
                        task.spawn(function()
                            if _G._AmbitiousXRayLoopId == loopId then
                                setXRayTargetTransparency(d, targetTrans)
                            end
                        end)
                    end
                    local cConn = claim.DescendantAdded:Connect(function(d)
                        if _G._AmbitiousXRayLoopId == loopId then
                            setXRayTargetTransparency(d, targetTrans)
                        end
                    end)
                    table.insert(_G._AmbitiousXRayConns, cConn)
                end
                local decorations = pod:FindFirstChild("Decorations")
                if decorations then
                    task.spawn(trackXRaySubtree, decorations, targetTrans, loopId)
                end
                local model = pod:FindFirstChild("Model")
                if model then
                    for _, child in ipairs(model:GetChildren()) do
                        if child:IsA("Folder") then
                            task.spawn(trackXRaySubtree, child, targetTrans, loopId)
                        else
                            setXRayTargetTransparency(child, targetTrans)
                            local cdConn = child.DescendantAdded:Connect(function(d)
                                if _G._AmbitiousXRayLoopId == loopId then
                                    setXRayTargetTransparency(d, targetTrans)
                                end
                            end)
                            table.insert(_G._AmbitiousXRayConns, cdConn)
                        end
                    end
                end
            end
            for _, child in ipairs(podiums:GetChildren()) do
                task.spawn(processPodium, child)
            end
            local podiumConn = podiums.ChildAdded:Connect(function(child)
                task.spawn(processPodium, child)
            end)
            table.insert(_G._AmbitiousXRayConns, podiumConn)
        end
        for _, inst in ipairs(plot:GetChildren()) do
            if not table.find(_G._AmbitiousXRayFolders, inst.Name) and inst.Name ~= "AnimalPodiums" then
                if inst:IsA("Folder") or inst:IsA("Model") then
                    task.spawn(trackXRaySubtree, inst, targetTrans, loopId)
                end
            end
        end
    end

    local function applyTransparencyToAllPlotsXRay(targetTrans)
        local plots = workspace:FindFirstChild("Plots")
        if not plots then
            task.spawn(function()
                local tries = 0
                while not plots and tries < 40 do
                    task.wait(0.25)
                    plots = workspace:FindFirstChild("Plots")
                    tries = tries + 1
                end
                if plots then applyTransparencyToAllPlotsXRay(targetTrans) end
            end)
            return
        end
        _G._AmbitiousXRayLoopId = _G._AmbitiousXRayLoopId + 1
        local loopId = _G._AmbitiousXRayLoopId
        if targetTrans <= 0 then
            for inst, orig in pairs(_G._AmbitiousXRayOrigTrans) do
                task.spawn(function()
                    if inst and inst.Parent then
                        if orig.Transparency ~= nil and (inst:IsA("BasePart") or inst:IsA("Texture")) then
                            inst.Transparency = orig.Transparency
                        end
                        if orig.LocalTransparencyModifier ~= nil and inst:IsA("BasePart") then
                            inst.LocalTransparencyModifier = orig.LocalTransparencyModifier
                        end
                        if orig.TextTransparency ~= nil then
                            pcall(function() inst.TextTransparency = orig.TextTransparency end)
                        end
                        if orig.BackgroundTransparency ~= nil then
                            pcall(function() inst.BackgroundTransparency = orig.BackgroundTransparency end)
                        end
                        if orig.ImageTransparency ~= nil then
                            pcall(function() inst.ImageTransparency = orig.ImageTransparency end)
                        end
                        if orig.StudsPerTileU ~= nil and inst:IsA("Texture") then
                            inst.StudsPerTileU = orig.StudsPerTileU
                            inst.StudsPerTileV = orig.StudsPerTileV or inst.StudsPerTileV
                        end
                    end
                end)
            end
            _G._AmbitiousXRayOrigTrans = {}
            for _, conn in ipairs(_G._AmbitiousXRayConns) do
                pcall(function() conn:Disconnect() end)
            end
            _G._AmbitiousXRayConns = {}
            return
        end
        for _, plot in ipairs(plots:GetChildren()) do
            task.spawn(processPlotXRay, plot, targetTrans, loopId)
        end
        local plotsConn = plots.ChildAdded:Connect(function(plot)
            if _G._AmbitiousXRayLoopId == loopId then
                task.spawn(processPlotXRay, plot, targetTrans, loopId)
            end
        end)
        table.insert(_G._AmbitiousXRayConns, plotsConn)
    end

    function setXRay(bool)
        if bool then
            applyTransparencyToAllPlotsXRay(0.55)
        else
            applyTransparencyToAllPlotsXRay(0)
        end
    end
    _G.AmbitiousSetXRay = setXRay

    function enableXray()
        State.xrayEnabled = true
        pcall(setXRay, true)
    end

    function disableXray()
        State.xrayEnabled = false
        pcall(setXRay, false)
        xrayCache = {}
    end

    function setupVisualTabMainToggles()
        toggleRefs.xray = makeToggleRow("Xray", State.xrayEnabled, function(on, isSync)
            State.xrayEnabled = on
            if on then enableXray() else disableXray() end
            if not isSync then task.spawn(saveConfig) end
        end, nil, tabVis)

        toggleRefs.stretchRez = makeToggleRow("Stretch Rez", State.stretchRezEnabled, function(on, isSync)
            State.stretchRezEnabled = on
            if on then enableStretchRez() else disableStretchRez() end
            if not isSync then task.spawn(saveConfig) end
        end, nil, tabVis)

        toggleRefs.fov = makeToggleRow("Fov", State.fovEnabled, function(on, isSync)
            State.fovEnabled = on
            if on then
                startFov()
            else
                stopFov()
            end
            if not isSync then task.spawn(saveConfig) end
        end, nil, tabVis)

        do
            local espExpanded = false
            local host = tabVis
            local mainRow = Instance.new("Frame", host)
            mainRow.Name = "EspMainRow"
            mainRow.Size = UDim2.new(1, 0, 0, 34)
            mainRow.BackgroundColor3 = C.row
            mainRow.BackgroundTransparency = 0.22
            mainRow.BorderSizePixel = 0
            mainRow.LayoutOrder = LO()
            mainRow.ZIndex = 7
            mkCorner(mainRow, 10)
            mkStroke(mainRow, C.border, 1, 0.82)

            local arrowBtn = Instance.new("TextButton", mainRow)
            arrowBtn.Name = "EspArrow"
            arrowBtn.Size = UDim2.new(0, 22, 0, 22)
            arrowBtn.Position = UDim2.new(0, 6, 0.5, -11)
            arrowBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 32)
            arrowBtn.BackgroundTransparency = 0.15
            arrowBtn.BorderSizePixel = 0
            arrowBtn.Text = "▲"
            arrowBtn.TextColor3 = C.white
            arrowBtn.Font = Enum.Font.GothamBold
            arrowBtn.TextSize = 11
            arrowBtn.AutoButtonColor = false
            arrowBtn.ZIndex = 10
            mkCorner(arrowBtn, 11)

            local lbl = Instance.new("TextLabel", mainRow)
            lbl.Size = UDim2.new(0.55, 0, 1, 0)
            lbl.Position = UDim2.new(0, 34, 0, 0)
            lbl.BackgroundTransparency = 1
            lbl.Text = "Esp"
            lbl.TextColor3 = C.white
            lbl.Font = Enum.Font.GothamBold
            lbl.TextSize = 12
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.ZIndex = 8

            local track = Instance.new("Frame", mainRow)
            track.Size = UDim2.new(0, 40, 0, 20)
            track.Position = UDim2.new(1, -52, 0.5, -10)
            track.BackgroundColor3 = State.espEnabled and Color3.fromRGB(220, 220, 225) or C.pillOff
            track.BorderSizePixel = 0
            track.ZIndex = 8
            mkCorner(track, 10)

            local knob = Instance.new("Frame", track)
            knob.Size = UDim2.new(0, 14, 0, 14)
            knob.Position = State.espEnabled and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7)
            knob.BackgroundColor3 = State.espEnabled and Color3.fromRGB(20, 20, 22) or C.textDim
            knob.BorderSizePixel = 0
            knob.ZIndex = 9
            mkCorner(knob, 7)

            local toggleBtn = Instance.new("TextButton", mainRow)
            toggleBtn.Size = UDim2.new(0, 40, 0, 20)
            toggleBtn.Position = UDim2.new(1, -52, 0.5, -10)
            toggleBtn.BackgroundTransparency = 1
            toggleBtn.Text = ""
            toggleBtn.ZIndex = 11

            local function setEspToggleVisual(on, noAnim)
                targetPos = on and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7)
                knobCol = on and Color3.fromRGB(20, 20, 22) or C.textDim
                trackCol = on and Color3.fromRGB(220, 220, 225) or C.pillOff
                if noAnim then
                    knob.Position = targetPos
                    knob.BackgroundColor3 = knobCol
                    track.BackgroundColor3 = trackCol
                else
                    tw(knob, {Position = targetPos, BackgroundColor3 = knobCol}, TweenInfo.new(0.22, Enum.EasingStyle.Quart, Enum.EasingDirection.Out))
                    tw(track, {BackgroundColor3 = trackCol}, TweenInfo.new(0.22, Enum.EasingStyle.Quart, Enum.EasingDirection.Out))
                end
            end

            toggleBtn.MouseButton1Click:Connect(function()
                State.espEnabled = not State.espEnabled
                setEspToggleVisual(State.espEnabled, false)
                if State.espEnabled then ESP.start() else ESP.stop() end
                task.spawn(saveConfig)
            end)
            toggleRefs.esp = function(on, isSync)
                State.espEnabled = on and true or false
                setEspToggleVisual(State.espEnabled, isSync == true)
                if State.espEnabled then ESP.start() else ESP.stop() end
                if not isSync then task.spawn(saveConfig) end
            end

            local optionsFrame = Instance.new("Frame", host)
            optionsFrame.Name = "EspOptions"
            optionsFrame.Size = UDim2.new(1, 0, 0, 0)
            optionsFrame.AutomaticSize = Enum.AutomaticSize.Y
            optionsFrame.BackgroundTransparency = 1
            optionsFrame.BorderSizePixel = 0
            optionsFrame.Visible = false
            optionsFrame.LayoutOrder = LO()
            optionsFrame.ZIndex = 7
            optLay = Instance.new("UIListLayout", optionsFrame)
            optLay.SortOrder = Enum.SortOrder.LayoutOrder
            optLay.Padding = UDim.new(0, 4)
            optPad = Instance.new("UIPadding", optionsFrame)
            optPad.PaddingLeft = UDim.new(0, 12)
            optPad.PaddingRight = UDim.new(0, 4)
            optPad.PaddingTop = UDim.new(0, 2)
            optPad.PaddingBottom = UDim.new(0, 4)

            modeLabels = {
                { key = "noLine", text = "No Line", kind = "line" },
                { key = "withLine", text = "With Line", kind = "line" },
                { key = "withBox", text = "With Box", kind = "box" },
            }
            modeKnobs = {}
            TI_SLIDE = TweenInfo.new(0.22, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)

            function animKnob(refs, on, noAnim)
                targetPos = on and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7)
                if refs.small then
                    targetPos = on and UDim2.new(1, -15, 0.5, -6) or UDim2.new(0, 3, 0.5, -6)
                end
                knobCol = on and Color3.fromRGB(20, 20, 22) or C.textDim
                trackCol = on and Color3.fromRGB(220, 220, 225) or C.pillOff
                if noAnim then
                    refs.knob.Position = targetPos
                    refs.knob.BackgroundColor3 = knobCol
                    refs.track.BackgroundColor3 = trackCol
                else
                    tw(refs.knob, {Position = targetPos, BackgroundColor3 = knobCol}, TI_SLIDE)
                    tw(refs.track, {BackgroundColor3 = trackCol}, TI_SLIDE)
                end
            end

            function refreshModeVisuals(noAnim)
                cur = State.espMode or "noLine"
                for key, refs in pairs(modeKnobs) do
                    local on
                    if key == "withBox" then
                        on = State.espBoxEnabled == true
                    else
                        on = (cur == key)
                    end
                    animKnob(refs, on, noAnim)
                end
            end

            function restartEsp()
                if State.espEnabled then
                    pcall(ESP.stop)
                    pcall(ESP.start)
                end
            end

            function setEspLineMode(mode)
                if mode ~= "noLine" and mode ~= "withLine" then return end
                if State.espMode == mode then return end
                State.espMode = mode
                refreshModeVisuals(false)
                restartEsp()
                task.spawn(saveConfig)
            end

            function setEspBox(on)
                State.espBoxEnabled = on and true or false
                refreshModeVisuals(false)
                restartEsp()
                task.spawn(saveConfig)
            end

            for i, def in ipairs(modeLabels) do
                row = Instance.new("Frame", optionsFrame)
                row.Size = UDim2.new(1, 0, 0, 30)
                row.BackgroundColor3 = C.row
                row.BackgroundTransparency = 0.35
                row.BorderSizePixel = 0
                row.LayoutOrder = i
                row.ZIndex = 7
                mkCorner(row, 8)
                mkStroke(row, C.border, 1, 0.88)

                t = Instance.new("TextLabel", row)
                t.Size = UDim2.new(0.7, 0, 1, 0)
                t.Position = UDim2.new(0, 10, 0, 0)
                t.BackgroundTransparency = 1
                t.Text = def.text
                t.TextColor3 = C.text
                t.Font = Enum.Font.GothamBold
                t.TextSize = 11
                t.TextXAlignment = Enum.TextXAlignment.Left
                t.ZIndex = 8

                tr = Instance.new("Frame", row)
                tr.Size = UDim2.new(0, 36, 0, 18)
                tr.Position = UDim2.new(1, -46, 0.5, -9)
                tr.BackgroundColor3 = C.pillOff
                tr.BorderSizePixel = 0
                tr.ZIndex = 8
                mkCorner(tr, 9)

                kn = Instance.new("Frame", tr)
                kn.Size = UDim2.new(0, 12, 0, 12)
                kn.Position = UDim2.new(0, 3, 0.5, -6)
                kn.BackgroundColor3 = C.textDim
                kn.BorderSizePixel = 0
                kn.ZIndex = 9
                mkCorner(kn, 6)

                btn = Instance.new("TextButton", row)
                btn.Size = UDim2.new(1, 0, 1, 0)
                btn.BackgroundTransparency = 1
                btn.Text = ""
                btn.ZIndex = 10
                btn.MouseButton1Click:Connect(function()
                    if def.kind == "box" then
                        setEspBox(not State.espBoxEnabled)
                    else
                        setEspLineMode(def.key)
                    end
                end)
                modeKnobs[def.key] = { track = tr, knob = kn, small = true }
            end
            refreshModeVisuals(true)

            arrowBtn.MouseButton1Click:Connect(function()
                espExpanded = not espExpanded
                arrowBtn.Text = espExpanded and "▼" or "▲"
                optionsFrame.Visible = espExpanded
                pcall(function()
                    if refreshContentCanvas and categoryPages and categoryPages["MAIN"] then
                        refreshContentCanvas(categoryPages["MAIN"])
                    end
                end)
            end)
        end
    end

    function setupVisualTabEspMode()
    end

    function setupVisualTabToggle1()
        -- No Cam Collision moved to MECH tab
    end

    function setupVisualTabToggle2()
        toggleRefs.antiLag = makeToggleRow("Fps Booster", State.antiLagEnabled, function(on, isSync)
            State.antiLagEnabled = on
            if on then enableAntiLag() else disableAntiLag() end
            if not isSync then task.spawn(saveConfig) end
        end, nil, tabVis)
    end

    function setupVisualTabToggleTransparentMap()
        toggleRefs.transparentMap = makeToggleRow("Transparent map", State.transparentMapEnabled, function(on, isSync)
            State.transparentMapEnabled = on
            if on then
                pcall(enableTransparentMap)
            else
                pcall(disableTransparentMap)
            end
            if not isSync then task.spawn(saveConfig) end
        end, nil, tabVis)
    end

    function setupVisualTabToggle3()
        toggleRefs.ragdollCountdown = makeToggleRow("Ragdoll Countdown", State.ragdollCountdownEnabled, function(on, isSync)
            State.ragdollCountdownEnabled = on
            if not isSync then task.spawn(saveConfig) end
        end, nil, tabVis)
    end

    function setupVisualTabToggle4()
        toggleRefs.removeAcc = makeToggleRow("Remove Accessories", State.removeAccEnabled, function(on, isSync)
            State.removeAccEnabled = on and true or false
            if on then
                pcall(function()
                    for _, p in pairs(Players:GetPlayers()) do
                        if p.Character then
                            if type(stripRemoveAccessories) == "function" then
                                pcall(stripRemoveAccessories, p.Character)
                            else
                                for _, obj in ipairs(p.Character:GetChildren()) do
                                    local tag = nil
                                    pcall(function() tag = obj:GetAttribute("_KyzDuelsSkinTag") end)
                                    local name = tostring(obj.Name or "")
                                    if tag or name:find("KyzDuelsSkin_", 1, true) then
                                    elseif obj:IsA("Accessory") or obj:IsA("Hat") then
                                        pcall(function() obj:Destroy() end)
                                    end
                                end
                            end
                        end
                    end
                end)
            end
            -- always autosave (including sync off paths still persist when user toggles)
            if not isSync then
                task.spawn(saveConfig)
            else
                -- even on sync load, ensure state is written once
                task.defer(function()
                    pcall(saveConfig)
                end)
            end
        end, nil, tabVis)
    end

    function setupVisualTabToggle5()
    end

    function setupVisualTabToggle6()
        -- Color Mode removed (useless)
    end

    function setupVisualTabCycle()
        -- Theme Color removed. Night Mode lives in Mech only.
    end

    function setupNightModeMech()
        local host = tabMech or tabMain
        if not host then return end
        makeToggleRow("Night Mode", State.gameTheme == "Night", function(on, isSync)
            State.gameTheme = on and "Night" or "Off"
            pcall(applyCustomSky, State.gameTheme)
            pcall(applyTheme)
            if not isSync then task.spawn(saveConfig) end
        end, nil, host)
    end

    function setupVisualTabSecondaryToggles()
        setupVisualTabToggle1()
        setupVisualTabToggle2()
        setupVisualTabToggleTransparentMap()
        setupVisualTabToggle3()
        setupVisualTabToggle4()
        setupVisualTabToggle5()
        -- Color Mode removed
        -- Theme Color lives in Visuals category
    end

    function makePreviewFrame(layoutOrder, idx)
        isNone = (idx == 0)
        prev = Instance.new("Frame")
        prev.LayoutOrder = layoutOrder
        prev.Size = UDim2.new(0, 72, 0, 44)
        prev.BackgroundColor3 = C.blueDark
        prev.BorderSizePixel = 0
        if isNone then
            prev.BackgroundTransparency = 1
        else
            prev.BackgroundTransparency = 1
        end
        mkCorner(prev, 7)
        bgStrokeRefs[idx] = mkStroke(prev, backgroundIndex == idx and C.blue or C.divider, 1.5)

        if isNone then
            noneLbl = Instance.new("TextLabel", prev)
            noneLbl.Size = UDim2.new(1, 0, 1, 0)
            noneLbl.BackgroundTransparency = 1
            noneLbl.Text = "None"
            noneLbl.TextColor3 = C.textDim
            noneLbl.Font = Enum.Font.GothamBold
            noneLbl.TextSize = 10
        else
            img = Instance.new("ImageLabel", prev)
            img.Size = UDim2.new(1, 0, 1, 0)
            img.BackgroundTransparency = 1
            img.Image = (getBgAsset and getBgAsset(idx)) or (BG_IMAGES[idx] and tostring(BG_IMAGES[idx])) or ""
            img.ScaleType = Enum.ScaleType.Crop
            mkCorner(img, 7)
            bgThumbRefs = bgThumbRefs or {}
            bgThumbRefs[idx] = img
        end

        btn = Instance.new("TextButton", prev)
        btn.Size = UDim2.new(1, 0, 1, 0)
        btn.BackgroundTransparency = 1
        btn.Text = ""
        btn.ZIndex = 10
        btn.MouseButton1Click:Connect(function()
            applyBackgroundImage(idx)
        end)

        return prev
    end

    bgCarouselOffset = 0
    bgCarouselRefs = {}

    function rebuildCarousel(carouselFrame)
        if bgCarouselRefs and bgCarouselRefs.build then
            pcall(bgCarouselRefs.build)
        end
    end

    function setupVisualTabBackgroundSetup(bgRow)
        for _, ch in ipairs(bgRow:GetChildren()) do
            if ch.Name == "BgStripWrap" or ch.Name == "OpenFullGallery" then
                pcall(function() ch:Destroy() end)
            end
        end

        galleryOpenBtn = Instance.new("TextButton", bgRow)
        galleryOpenBtn.Name = "OpenFullGallery"
        galleryOpenBtn.Size = UDim2.new(1, -20, 0, 40)
        galleryOpenBtn.Position = UDim2.new(0, 10, 0.5, -20)
        galleryOpenBtn.BackgroundColor3 = C.row
        galleryOpenBtn.BackgroundTransparency = 0.15
        galleryOpenBtn.BorderSizePixel = 0
        galleryOpenBtn.Text = "Backgrounds"
        galleryOpenBtn.TextColor3 = C.text
        galleryOpenBtn.Font = Enum.Font.GothamBold
        galleryOpenBtn.TextSize = 13
        galleryOpenBtn.AutoButtonColor = false
        galleryOpenBtn.ZIndex = 12
        mkCorner(galleryOpenBtn, 8)
        gStroke = mkStroke(galleryOpenBtn, C.divider, 1)
        gStroke.Transparency = 0.55

        galleryOpenBtn.MouseEnter:Connect(function()
            tw(galleryOpenBtn, {BackgroundColor3 = C.cardHov, BackgroundTransparency = 0.05})
            tw(gStroke, {Color = C.border, Transparency = 0.35})
        end)
        galleryOpenBtn.MouseLeave:Connect(function()
            tw(galleryOpenBtn, {BackgroundColor3 = C.row, BackgroundTransparency = 0.15})
            tw(gStroke, {Color = C.divider, Transparency = 0.55})
        end)
        galleryOpenBtn.MouseButton1Click:Connect(function()
            pcall(openBackgroundGallery)
        end)

        bgCarouselRefs = bgCarouselRefs or {}
        bgCarouselRefs.build = function() end
        bgCarouselRefs.carousel = nil
        bgCarouselRefs.wrap = nil
        bgCarouselRefs.scroll = nil
        return nil
    end

    function setupVisualTabBackgroundNone(imgContainer) end
    function setupVisualTabBackgroundImages(imgContainer) end

    function setupVisualTabBackground(parent)
        parent = parent or tabVis
        makeSectionHeader("BACKGROUND IMAGE", parent)

        bgRow = Instance.new("Frame", parent)
        bgRow.Size = UDim2.new(1, 0, 0, 56)
        bgRow.BackgroundColor3 = C.row
        bgRow.BackgroundTransparency = 0.72
        bgRow.BorderSizePixel = 0
        bgRow.LayoutOrder = LO()
        bgRow.ZIndex = 7
        mkCorner(bgRow, 10)
        mkStroke(bgRow, C.divider, 1)

        do
            hov = Instance.new("TextButton", bgRow)
            hov.Size = UDim2.new(1, 0, 1, 0)
            hov.BackgroundTransparency = 1
            hov.Text = ""
            hov.ZIndex = 0
            hov.Active = false
            hov.MouseEnter:Connect(function()
                tw(bgRow, {BackgroundTransparency = 0.78, BackgroundColor3 = C.row})
            end)
            hov.MouseLeave:Connect(function()
                tw(bgRow, {BackgroundTransparency = 0.72, BackgroundColor3 = C.row})
            end)
        end

        carousel = setupVisualTabBackgroundSetup(bgRow)
        bgCarouselOffset = 0
        rebuildCarousel(carousel)

        resolveBackgroundRefs()
        applyBackgroundImage(backgroundIndex)
        if startBgLoad then startBgLoad() end
    end

    function setupVisualTab()
        -- visual toggles now live under Mech (tabVis == tabMech)
        makeSectionHeader("VISUAL", tabMech)
        setupVisualTabMainToggles()
        setupVisualTabEspMode()
        setupVisualTabSecondaryToggles()

        -- Visuals category options (Theme always last)
        visParent = tabTheme or tabVisuals
        makeSectionHeader("VISUALS", visParent)

        toggleRefs.batMedusaTransparent = makeToggleRow("Bat and Meduse Transparent", State.batMedusaTransparent, function(on, isSync)
            State.batMedusaTransparent = on
            if on then
                pcall(enableBatMedusaTransparent)
            else
                pcall(disableBatMedusaTransparent)
            end
            if not isSync then task.spawn(saveConfig) end
        end, nil, visParent)

        toggleRefs.batMedusaRainbow = makeToggleRow("Bat and Meduse Rainbow", State.batMedusaRainbow, function(on, isSync)
            State.batMedusaRainbow = on
            if on then
                pcall(enableBatMedusaRainbow)
            else
                pcall(disableBatMedusaRainbow)
            end
            if not isSync then task.spawn(saveConfig) end
        end, nil, visParent)

        -- Bat Custom (expandable) — isolated names so arrows/toggles don't clash
        do
            local batCustomExpanded = false
            local bcMainRow = Instance.new("Frame", visParent)
            bcMainRow.Name = "BatCustomMainRow"
            bcMainRow.Size = UDim2.new(1, 0, 0, 34)
            bcMainRow.BackgroundColor3 = C.row
            bcMainRow.BackgroundTransparency = 0.22
            bcMainRow.BorderSizePixel = 0
            bcMainRow.LayoutOrder = LO()
            bcMainRow.ZIndex = 7
            mkCorner(bcMainRow, 10)
            mkStroke(bcMainRow, C.border, 1, 0.82)

            local bcArrowBtn = Instance.new("TextButton", bcMainRow)
            bcArrowBtn.Name = "BatCustomArrow"
            bcArrowBtn.Size = UDim2.new(0, 22, 0, 22)
            bcArrowBtn.Position = UDim2.new(0, 6, 0.5, -11)
            bcArrowBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 32)
            bcArrowBtn.BackgroundTransparency = 0.15
            bcArrowBtn.BorderSizePixel = 0
            bcArrowBtn.Text = "▲"
            bcArrowBtn.TextColor3 = C.white
            bcArrowBtn.Font = Enum.Font.GothamBold
            bcArrowBtn.TextSize = 11
            bcArrowBtn.AutoButtonColor = false
            bcArrowBtn.ZIndex = 10
            mkCorner(bcArrowBtn, 11)

            local bcLbl = Instance.new("TextLabel", bcMainRow)
            bcLbl.Size = UDim2.new(1, -40, 1, 0)
            bcLbl.Position = UDim2.new(0, 34, 0, 0)
            bcLbl.BackgroundTransparency = 1
            bcLbl.Text = "Bat Custom"
            bcLbl.TextColor3 = C.white
            bcLbl.Font = Enum.Font.GothamBold
            bcLbl.TextSize = 12
            bcLbl.TextXAlignment = Enum.TextXAlignment.Left
            bcLbl.ZIndex = 8

            local bcOptionsFrame = Instance.new("Frame", visParent)
            bcOptionsFrame.Name = "BatCustomOptions"
            bcOptionsFrame.Size = UDim2.new(1, 0, 0, 0)
            bcOptionsFrame.AutomaticSize = Enum.AutomaticSize.Y
            bcOptionsFrame.BackgroundTransparency = 1
            bcOptionsFrame.BorderSizePixel = 0
            bcOptionsFrame.Visible = false
            bcOptionsFrame.LayoutOrder = LO()
            bcOptionsFrame.ZIndex = 7

            local bcOptLayout = Instance.new("UIListLayout", bcOptionsFrame)
            bcOptLayout.SortOrder = Enum.SortOrder.LayoutOrder
            bcOptLayout.Padding = UDim.new(0, 4)

            local bcOptPad = Instance.new("UIPadding", bcOptionsFrame)
            bcOptPad.PaddingLeft = UDim.new(0, 10)
            bcOptPad.PaddingRight = UDim.new(0, 4)
            bcOptPad.PaddingTop = UDim.new(0, 2)
            bcOptPad.PaddingBottom = UDim.new(0, 2)

            local function selectBatCustom(key, on, isSync)
                -- skins only (No Sound is independent)
                local all = {
                    diamond = "batCustom",
                    scythe_bear = "batCustomScythe",
                    scythe_white = "batCustomScytheWhite",
                    black_hammer = "batCustomBlackHammer",
                }
                if on then
                    State.batCustomKey = key
                    State.batCustomEnabled = true
                    pcall(function() enableBatCustom(key) end)
                    for k, refName in pairs(all) do
                        if k ~= key and type(toggleRefs[refName]) == "function" then
                            pcall(function() toggleRefs[refName](false, true) end)
                        end
                    end
                else
                    if (State.batCustomKey == key) or (not State.batCustomKey and key == "diamond") then
                        State.batCustomEnabled = false
                        pcall(disableBatCustom)
                    end
                end
                if not isSync then task.spawn(saveConfig) end
            end

            toggleRefs.batCustom = makeToggleRow(
                "Minecraft diamond sword",
                State.batCustomEnabled and (State.batCustomKey or "diamond") == "diamond",
                function(on, isSync)
                    selectBatCustom("diamond", on, isSync)
                end,
                nil,
                bcOptionsFrame
            )

            toggleRefs.batCustomScythe = makeToggleRow(
                "Scythe with Bear",
                State.batCustomEnabled and State.batCustomKey == "scythe_bear",
                function(on, isSync)
                    selectBatCustom("scythe_bear", on, isSync)
                end,
                nil,
                bcOptionsFrame
            )

            toggleRefs.batCustomScytheWhite = makeToggleRow(
                "Scythe White",
                State.batCustomEnabled and State.batCustomKey == "scythe_white",
                function(on, isSync)
                    selectBatCustom("scythe_white", on, isSync)
                end,
                nil,
                bcOptionsFrame
            )

            toggleRefs.batCustomBlackHammer = makeToggleRow(
                "Black Hammer",
                State.batCustomEnabled and State.batCustomKey == "black_hammer",
                function(on, isSync)
                    selectBatCustom("black_hammer", on, isSync)
                end,
                nil,
                bcOptionsFrame
            )

            -- independent: only removes custom swing SFX, skins stay active
            toggleRefs.batCustomNoSound = makeToggleRow(
                "No Sound",
                State.batNoSound == true,
                function(on, isSync)
                    State.batNoSound = on and true or false
                    if on then
                        pcall(_batCustomRestoreOriginalSounds)
                    else
                        -- re-mute original if a custom-sound skin is active
                        local entry = _batCustomGetEntry and _batCustomGetEntry()
                        if State.batCustomEnabled and entry and entry.swingSound then
                            local bat = select(1, _bmGetTools())
                            if bat then pcall(_batCustomMuteOriginalSounds, bat) end
                        end
                    end
                    if not isSync then task.spawn(saveConfig) end
                end,
                nil,
                bcOptionsFrame
            )

            bcArrowBtn.MouseButton1Click:Connect(function()
                batCustomExpanded = not batCustomExpanded
                bcArrowBtn.Text = batCustomExpanded and "▼" or "▲"
                bcOptionsFrame.Visible = batCustomExpanded
                pcall(function()
                    if contentFrame and contentFrame.Parent then
                        local page = categoryPages and categoryPages[activeCategoryName]
                        if page then refreshContentCanvas(page) end
                    end
                end)
            end)
        end

        -- Meduse Custom (below Bat Custom — same method as Bat, targets Medusa's Head)
        do
            local skullExpanded = false
            local skMainRow = Instance.new("Frame", visParent)
            skMainRow.Name = "MeduseCustomMainRow"
            skMainRow.Size = UDim2.new(1, 0, 0, 34)
            skMainRow.BackgroundColor3 = C.row
            skMainRow.BackgroundTransparency = 0.22
            skMainRow.BorderSizePixel = 0
            skMainRow.LayoutOrder = LO()
            skMainRow.ZIndex = 7
            mkCorner(skMainRow, 10)
            mkStroke(skMainRow, C.border, 1, 0.82)

            local skArrowBtn = Instance.new("TextButton", skMainRow)
            skArrowBtn.Name = "MeduseCustomArrow"
            skArrowBtn.Size = UDim2.new(0, 22, 0, 22)
            skArrowBtn.Position = UDim2.new(0, 6, 0.5, -11)
            skArrowBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 32)
            skArrowBtn.BackgroundTransparency = 0.15
            skArrowBtn.BorderSizePixel = 0
            skArrowBtn.Text = "▲"
            skArrowBtn.TextColor3 = C.white
            skArrowBtn.Font = Enum.Font.GothamBold
            skArrowBtn.TextSize = 11
            skArrowBtn.AutoButtonColor = false
            skArrowBtn.ZIndex = 10
            mkCorner(skArrowBtn, 11)

            local skLbl = Instance.new("TextLabel", skMainRow)
            skLbl.Size = UDim2.new(1, -40, 1, 0)
            skLbl.Position = UDim2.new(0, 34, 0, 0)
            skLbl.BackgroundTransparency = 1
            skLbl.Text = "Meduse Custom"
            skLbl.TextColor3 = C.white
            skLbl.Font = Enum.Font.GothamBold
            skLbl.TextSize = 12
            skLbl.TextXAlignment = Enum.TextXAlignment.Left
            skLbl.ZIndex = 8

            local skOptionsFrame = Instance.new("Frame", visParent)
            skOptionsFrame.Name = "MeduseCustomOptions"
            skOptionsFrame.Size = UDim2.new(1, 0, 0, 0)
            skOptionsFrame.AutomaticSize = Enum.AutomaticSize.Y
            skOptionsFrame.BackgroundTransparency = 1
            skOptionsFrame.BorderSizePixel = 0
            skOptionsFrame.Visible = false
            skOptionsFrame.LayoutOrder = LO()
            skOptionsFrame.ZIndex = 7

            local skOptLayout = Instance.new("UIListLayout", skOptionsFrame)
            skOptLayout.SortOrder = Enum.SortOrder.LayoutOrder
            skOptLayout.Padding = UDim.new(0, 4)

            local skOptPad = Instance.new("UIPadding", skOptionsFrame)
            skOptPad.PaddingLeft = UDim.new(0, 10)
            skOptPad.PaddingRight = UDim.new(0, 4)
            skOptPad.PaddingTop = UDim.new(0, 2)
            skOptPad.PaddingBottom = UDim.new(0, 2)

            local function selectSkullCustom(key, on, isSync)
                if on then
                    State.skullCustomKey = key
                    State.skullCustomEnabled = true
                    pcall(function() enableSkullCustom(key) end)
                    local all = {
                        evil = "skullEvil",
                        ominous = "skullOminous",
                        cone = "skullCone",
                        kamehameha = "skullKamehameha",
                        fireball = "skullFireball",
                        rasengan = "skullRasengan",
                    }
                    for k, refName in pairs(all) do
                        if k ~= key and type(toggleRefs[refName]) == "function" then
                            pcall(function() toggleRefs[refName](false, true) end)
                        end
                    end
                else
                    if (State.skullCustomKey == key) or (not State.skullCustomKey and key == "evil") then
                        State.skullCustomEnabled = false
                        pcall(disableSkullCustom)
                    end
                end
                if not isSync then task.spawn(saveConfig) end
            end

            toggleRefs.skullEvil = makeToggleRow(
                "Evil Skull",
                State.skullCustomEnabled and (State.skullCustomKey or "evil") == "evil",
                function(on, isSync)
                    selectSkullCustom("evil", on, isSync)
                end,
                nil,
                skOptionsFrame
            )

            toggleRefs.skullOminous = makeToggleRow(
                "Ominous Skull",
                State.skullCustomEnabled and State.skullCustomKey == "ominous",
                function(on, isSync)
                    selectSkullCustom("ominous", on, isSync)
                end,
                nil,
                skOptionsFrame
            )

            toggleRefs.skullCone = makeToggleRow(
                "Skull Cone",
                State.skullCustomEnabled and State.skullCustomKey == "cone",
                function(on, isSync)
                    selectSkullCustom("cone", on, isSync)
                end,
                nil,
                skOptionsFrame
            )

            toggleRefs.skullKamehameha = makeToggleRow(
                "Kamehameha",
                State.skullCustomEnabled and State.skullCustomKey == "kamehameha",
                function(on, isSync)
                    selectSkullCustom("kamehameha", on, isSync)
                end,
                nil,
                skOptionsFrame
            )

            toggleRefs.skullFireball = makeToggleRow(
                "Fire Ball",
                State.skullCustomEnabled and State.skullCustomKey == "fireball",
                function(on, isSync)
                    selectSkullCustom("fireball", on, isSync)
                end,
                nil,
                skOptionsFrame
            )

            toggleRefs.skullRasengan = makeToggleRow(
                "Rasengan",
                State.skullCustomEnabled and State.skullCustomKey == "rasengan",
                function(on, isSync)
                    selectSkullCustom("rasengan", on, isSync)
                end,
                nil,
                skOptionsFrame
            )

            skArrowBtn.MouseButton1Click:Connect(function()
                skullExpanded = not skullExpanded
                skArrowBtn.Text = skullExpanded and "▼" or "▲"
                skOptionsFrame.Visible = skullExpanded
                pcall(function()
                    if contentFrame and contentFrame.Parent then
                        local page = categoryPages and categoryPages[activeCategoryName]
                        if page then refreshContentCanvas(page) end
                    end
                end)
            end)
        end

        -- THEME section removed
    end

    FONT_OPTION_NAMES = {
        "Base",
        "Michroma",
        "Antique",
        "Sarpanch",
        "Creepster",
        "RobotoCondensed",
        "PermanentMarker",
        "Oswald",
        "IndieFlower",
    }

    FONT_ENUMS = { Base = nil }
    for _, name in ipairs(FONT_OPTION_NAMES) do
        if name ~= "Base" then
            local ok, f = pcall(function() return Enum.Font[name] end)
            if ok and f then FONT_ENUMS[name] = f end
        end
    end

    fontAppliedOriginals = {}
    fontAutoConn = nil
    fontCurrentIndex = 1

    function getFontIndexByName(name)
        for i, n in ipairs(FONT_OPTION_NAMES) do
            if n == name then return i end
        end
        return 1
    end

    function getSelectedFontEnum()
        name = State.customFontName or "Base"
        if name == "Base" then return nil end
        return FONT_ENUMS[name]
    end

    function applyFontToObject(obj, font)
        if not obj then return end
        if obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox") then
            if fontAppliedOriginals[obj] == nil then
                fontAppliedOriginals[obj] = obj.Font
            end
            if font then
                pcall(function() obj.Font = font end)
            end
        end
    end

    function restoreFontObject(obj)
        if not obj then return end
        orig = fontAppliedOriginals[obj]
        if orig and (obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox")) then
            pcall(function() obj.Font = orig end)
        end
    end

    function scanAndApplyCustomFont(font)
        if not font then return end
        if gui then
            for _, obj in ipairs(gui:GetDescendants()) do
                applyFontToObject(obj, font)
            end
        end
        pg = LP:FindFirstChild("PlayerGui")
        if pg then
            for _, child in ipairs(pg:GetChildren()) do
                if child ~= gui then
                    for _, obj in ipairs(child:GetDescendants()) do
                        applyFontToObject(obj, font)
                    end
                end
            end
        end
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj:IsA("BillboardGui") or obj:IsA("SurfaceGui") then
                for _, inner in ipairs(obj:GetDescendants()) do
                    applyFontToObject(inner, font)
                end
            end
        end
    end

    function restoreAllCustomFonts()
        for obj, orig in pairs(fontAppliedOriginals) do
            if obj and obj.Parent then
                pcall(function() obj.Font = orig end)
            end
        end
        fontAppliedOriginals = {}
    end

    function stopFontAutoApply()
        if fontAutoConn then
            pcall(function() fontAutoConn:Disconnect() end)
            fontAutoConn = nil
        end
        State.customFontAuto = false
    end

    function startFontAutoApply()
        stopFontAutoApply()
        State.customFontAuto = true
        font = getSelectedFontEnum()
        if font then scanAndApplyCustomFont(font) end
        pg = LP:FindFirstChild("PlayerGui")
        local guiConn, worldConn
        if pg then
            guiConn = pg.DescendantAdded:Connect(function(obj)
                if not State.customFontAuto then return end
                f = getSelectedFontEnum()
                if not f then return end
                task.defer(function() applyFontToObject(obj, f) end)
            end)
        end
        worldConn = workspace.DescendantAdded:Connect(function(obj)
            if not State.customFontAuto then return end
            f = getSelectedFontEnum()
            if not f then return end
            task.defer(function()
                if obj:IsA("BillboardGui") or obj:IsA("SurfaceGui") then
                    for _, inner in ipairs(obj:GetDescendants()) do
                        applyFontToObject(inner, f)
                    end
                elseif obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox") then
                    parentGui = obj:FindFirstAncestorWhichIsA("BillboardGui") or obj:FindFirstAncestorWhichIsA("SurfaceGui")
                    if parentGui then applyFontToObject(obj, f) end
                end
            end)
        end)
        fontAutoConn = {
            Disconnect = function()
                if guiConn then pcall(function() guiConn:Disconnect() end) end
                if worldConn then pcall(function() worldConn:Disconnect() end) end
            end
        }
    end

    function applySelectedCustomFont()
        name = State.customFontName or "Base"
        if name == "Base" then
            restoreAllCustomFonts()
            stopFontAutoApply()
            return
        end
        font = FONT_ENUMS[name]
        if font then
            scanAndApplyCustomFont(font)
        end
    end

    function setupFontCustomizer(parent)
        makeSectionHeader("FONT CUSTOMIZER", parent)

        local row = Instance.new("Frame", parent)
        row.Size = UDim2.new(1, 0, 0, 40)
        row.BackgroundColor3 = C.row
        row.BackgroundTransparency = 0.22
        row.BorderSizePixel = 0
        row.LayoutOrder = LO()
        row.ZIndex = 7
        mkCorner(row, 10)
        mkStroke(row, C.border, 1, 0.82)

        local prevBtn = Instance.new("TextButton", row)
        prevBtn.Size = UDim2.fromOffset(28, 24)
        prevBtn.Position = UDim2.new(0, 8, 0.5, -12)
        prevBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 48)
        prevBtn.Text = "◀"
        prevBtn.TextColor3 = C.white
        prevBtn.Font = Enum.Font.GothamBold
        prevBtn.TextSize = 12
        prevBtn.AutoButtonColor = false
        prevBtn.ZIndex = 8
        mkCorner(prevBtn, 6)

        local nameLbl = Instance.new("TextLabel", row)
        nameLbl.Size = UDim2.new(1, -120, 0, 24)
        nameLbl.Position = UDim2.new(0, 40, 0.5, -12)
        nameLbl.BackgroundTransparency = 1
        nameLbl.Text = "Base"
        nameLbl.TextColor3 = C.white
        nameLbl.Font = Enum.Font.GothamBold
        nameLbl.TextSize = 12
        nameLbl.TextXAlignment = Enum.TextXAlignment.Center
        nameLbl.ZIndex = 8

        local nextBtn = Instance.new("TextButton", row)
        nextBtn.Size = UDim2.fromOffset(28, 24)
        nextBtn.Position = UDim2.new(1, -36, 0.5, -12)
        nextBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 48)
        nextBtn.Text = "▶"
        nextBtn.TextColor3 = C.white
        nextBtn.Font = Enum.Font.GothamBold
        nextBtn.TextSize = 12
        nextBtn.AutoButtonColor = false
        nextBtn.ZIndex = 8
        mkCorner(nextBtn, 6)

        local fontCurrentIndex = getFontIndexByName(State.customFontName or "Base")
        local function refreshLabel()
            local name = FONT_OPTION_NAMES[fontCurrentIndex] or "Base"
            State.customFontName = name
            nameLbl.Text = name .. "  (" .. fontCurrentIndex .. "/" .. #FONT_OPTION_NAMES .. ")"
            local f = FONT_ENUMS[name]
            if f then
                nameLbl.Font = f
            else
                nameLbl.Font = Enum.Font.GothamBold
            end
        end
        refreshLabel()

        prevBtn.MouseButton1Click:Connect(function()
            fontCurrentIndex = fontCurrentIndex - 1
            if fontCurrentIndex < 1 then fontCurrentIndex = #FONT_OPTION_NAMES end
            refreshLabel()
            if State.customFontAuto then
                applySelectedCustomFont()
                if State.customFontName ~= "Base" then
                    startFontAutoApply()
                else
                    stopFontAutoApply()
                end
            end
            task.spawn(saveConfig)
        end)
        nextBtn.MouseButton1Click:Connect(function()
            fontCurrentIndex = fontCurrentIndex + 1
            if fontCurrentIndex > #FONT_OPTION_NAMES then fontCurrentIndex = 1 end
            refreshLabel()
            if State.customFontAuto then
                applySelectedCustomFont()
                if State.customFontName ~= "Base" then
                    startFontAutoApply()
                else
                    stopFontAutoApply()
                end
            end
            task.spawn(saveConfig)
        end)

        local row2 = Instance.new("Frame", parent)
        row2.Size = UDim2.new(1, 0, 0, 36)
        row2.BackgroundTransparency = 1
        row2.LayoutOrder = LO()
        row2.ZIndex = 7

        local applyBtn = Instance.new("TextButton", row2)
        applyBtn.Size = UDim2.new(0.48, -4, 0, 28)
        applyBtn.Position = UDim2.new(0, 0, 0, 4)
        applyBtn.BackgroundColor3 = C.row
        applyBtn.BackgroundTransparency = 0.22
        applyBtn.Text = "Apply"
        applyBtn.TextColor3 = C.text
        applyBtn.Font = Enum.Font.GothamBold
        applyBtn.TextSize = 11
        applyBtn.AutoButtonColor = false
        applyBtn.ZIndex = 8
        mkCorner(applyBtn, 8)
        mkStroke(applyBtn, C.border, 1, 0.82)
        applyBtn.MouseButton1Click:Connect(function()
            applySelectedCustomFont()
            if State.customFontAuto and State.customFontName ~= "Base" then
                startFontAutoApply()
            end
            task.spawn(saveConfig)
        end)

        local restoreBtn = Instance.new("TextButton", row2)
        restoreBtn.Size = UDim2.new(0.48, -4, 0, 28)
        restoreBtn.Position = UDim2.new(0.52, 4, 0, 4)
        restoreBtn.BackgroundColor3 = C.row
        restoreBtn.BackgroundTransparency = 0.22
        restoreBtn.Text = "Restore Base"
        restoreBtn.TextColor3 = C.text
        restoreBtn.Font = Enum.Font.GothamBold
        restoreBtn.TextSize = 11
        restoreBtn.AutoButtonColor = false
        restoreBtn.ZIndex = 8
        mkCorner(restoreBtn, 8)
        mkStroke(restoreBtn, C.border, 1, 0.82)
        restoreBtn.MouseButton1Click:Connect(function()
            fontCurrentIndex = 1
            State.customFontName = "Base"
            refreshLabel()
            restoreAllCustomFonts()
            stopFontAutoApply()
            task.spawn(saveConfig)
        end)
        -- Auto Apply Font removed
    end

    function setupOthersTab()
    end

    _kbOverlay = {
        screen = nil,
        connections = {},
        running = false,
    }

    function _kbDestroy()
        for _, conn in ipairs(_kbOverlay.connections) do
            pcall(function() conn:Disconnect() end)
        end
        table.clear(_kbOverlay.connections)
        if _kbOverlay.screen then
            pcall(function() _kbOverlay.screen:Destroy() end)
            _kbOverlay.screen = nil
        end
        _kbOverlay.running = false
        local ENV = (typeof(getgenv) == "function" and getgenv()) or _G
        if type(ENV.__LiveKeyboardOverlay) == "table" then
            ENV.__LiveKeyboardOverlay = nil
        end
    end

    function _kbTrack(conn)
        table.insert(_kbOverlay.connections, conn)
        return conn
    end

    function startKeyboardOverlay()
        -- keyboard removed / disabled
    end

    function stopKeyboardOverlay()
        _kbDestroy()
    end

    function setupSettingsTab()
        loCount = 0
        setupVisualTabBackground(tabSettings)
        setupFontCustomizer(tabSettings)
makeSectionHeader("INTRO SOUND", tabSettings)
        makeCycleRow("Intro Sound", "introMode", {"Song 1", "Song 2", "Song 3"}, function()
            local idx = _normalizeIntroMusicIndex(State.introMode or State.selectedIntroMusic or selectedIntroMusic or 1)
            selectedIntroMusic = idx
            State.introMode = tostring(idx)
            State.selectedIntroMusic = idx
            -- persist immediately (makeCycleRow also saves; this keeps global in sync first)
            pcall(saveConfig)
        end, tabSettings, {"1", "2", "3"})

        -- Test Sound: preview currently selected intro track
        do
            local row = Instance.new("Frame", tabSettings)
            row.Size = UDim2.new(1, 0, 0, 36)
            row.BackgroundColor3 = C.row
            row.BackgroundTransparency = 0.22
            row.BorderSizePixel = 0
            row.LayoutOrder = LO()
            row.ZIndex = 7
            pcall(function() mkCorner(row, 10) end)
            pcall(function() mkStroke(row, C.border, 1, 0.82) end)

            local lbl = Instance.new("TextLabel", row)
            lbl.Size = UDim2.new(0.42, 0, 0, 16)
            lbl.Position = UDim2.new(0, 10, 0, 10)
            lbl.BackgroundTransparency = 1
            lbl.Text = "Test Sound"
            lbl.TextColor3 = C.text
            lbl.Font = Enum.Font.GothamBold
            lbl.TextSize = 10
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.ZIndex = 8

            local btn = Instance.new("TextButton", row)
            btn.Name = "TestSoundBtn"
            btn.Size = UDim2.new(0, 150, 0, 22)
            btn.Position = UDim2.new(1, -158, 0.5, -11)
            btn.BackgroundColor3 = Color3.fromRGB(18, 18, 20)
            btn.BackgroundTransparency = 0.05
            btn.BorderSizePixel = 0
            btn.AutoButtonColor = false
            btn.Text = ""
            btn.ZIndex = 10
            pcall(function() mkCorner(btn, 10) end)
            pcall(function() mkStroke(btn, C.borderDim, 1) end)

            local valText = Instance.new("TextLabel", btn)
            valText.Size = UDim2.new(1, -8, 1, 0)
            valText.Position = UDim2.new(0, 4, 0, 0)
            valText.BackgroundTransparency = 1
            valText.Text = "Play"
            valText.TextColor3 = C.white
            valText.Font = Enum.Font.GothamBold
            valText.TextSize = 10
            valText.TextXAlignment = Enum.TextXAlignment.Center
            valText.ZIndex = 11

            local testSoundObj = nil
            local testing = false

            local function stopTest()
                testing = false
                if testSoundObj then
                    pcall(function()
                        testSoundObj:Stop()
                        testSoundObj:Destroy()
                    end)
                    testSoundObj = nil
                end
                valText.Text = "Play"
            end

            btn.MouseButton1Click:Connect(function()
                if testing then
                    stopTest()
                    return
                end
                local idx = _normalizeIntroMusicIndex(
                    (State and State.introMode) or (State and State.selectedIntroMusic) or selectedIntroMusic or 1
                )
                selectedIntroMusic = idx
                local track = INTRO_MUSIC_OPTIONS[idx] or INTRO_MUSIC_OPTIONS[1]
                if not track then return end

                stopTest()
                testing = true
                valText.Text = "Stop · " .. (track.name or ("Song " .. tostring(idx)))

                local sound = Instance.new("Sound")
                sound.Name = "KyzDuels_TestIntroSound"
                sound.Volume = 1.5
                sound.Looped = false
                sound.PlaybackSpeed = 1
                pcall(function() sound.Parent = SoundService end)
                if not sound.Parent then
                    pcall(function() sound.Parent = workspace end)
                end
                testSoundObj = sound

                task.spawn(function()
                    pcall(function()
                        _playIntroMusic(sound, track)
                    end)
                    -- auto-stop after ~12s so it doesn't hang forever
                    local t0 = os.clock()
                    while testing and testSoundObj == sound and (os.clock() - t0) < 12 do
                        task.wait(0.25)
                        local playing = false
                        pcall(function() playing = sound.IsPlaying end)
                        if not playing and (os.clock() - t0) > 1.5 then
                            break
                        end
                    end
                    if testSoundObj == sound then
                        stopTest()
                    end
                end)
            end)

            btn.MouseEnter:Connect(function()
                btn.BackgroundTransparency = 0
            end)
            btn.MouseLeave:Connect(function()
                btn.BackgroundTransparency = 0.05
            end)
        end

    end

    function refreshPlayerViewport()
        if not _G.__KyzDuelsPlayerViewport then return end
        vp = _G.__KyzDuelsPlayerViewport
        world = vp:FindFirstChild("WorldModel")
        if not world then
            world = Instance.new("WorldModel")
            world.Parent = vp
        end
        for _, ch in ipairs(world:GetChildren()) do
            pcall(function() ch:Destroy() end)
        end
        oldCam = vp:FindFirstChildOfClass("Camera")
        if oldCam then pcall(function() oldCam:Destroy() end) end

        char = LP.Character
        if not char then return end

        archRestore = {}
        pcall(function()
            char.Archivable = true
            for _, d in ipairs(char:GetDescendants()) do
                local okA, was = pcall(function() return d.Archivable end)
                if okA then
                    archRestore[d] = was
                    pcall(function() d.Archivable = true end)
                end
            end
        end)

        local ok, clone = pcall(function()
            return char:Clone()
        end)

        pcall(function()
            char.Archivable = false
            for d, was in pairs(archRestore) do
                pcall(function() if d and d.Parent then d.Archivable = was end end)
            end
        end)

        if not ok or not clone then return end

        for _, d in ipairs(clone:GetDescendants()) do
            if d:IsA("Script") or d:IsA("LocalScript") or d:IsA("ModuleScript") then
                pcall(function() d:Destroy() end)
            elseif d:IsA("BasePart") then
                pcall(function()
                    d.Anchored = true
                    d.CanCollide = false
                    d.LocalTransparencyModifier = 0
                    if d.Transparency < 1 then
                        d.Transparency = math.min(d.Transparency, 0)
                    end
                end)
            elseif d:IsA("Decal") or d:IsA("Texture") then
                pcall(function()
                    if d.Transparency < 1 then d.Transparency = 0 end
                end)
            end
        end

        hum = clone:FindFirstChildOfClass("Humanoid")
        if hum then
            pcall(function()
                hum.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
                hum.HealthDisplayType = Enum.HumanoidHealthDisplayType.AlwaysOff
            end)
        end
        clone.Parent = world

        -- Fire Head often missing in ViewportFrame clone → re-create on clone
        pcall(function()
            local wantFire = (State and State.skinFireHead) or false
            local srcHead = char:FindFirstChild("Head")
            if srcHead and srcHead:FindFirstChild("Custom_HeadFire") then
                wantFire = true
            end
            if wantFire then
                local cHead = clone:FindFirstChild("Head")
                if cHead then
                    for _, n in ipairs({"Custom_HeadFire", "Custom_HeadFireAtt", "Custom_HeadFireParticles"}) do
                local o = cHead:FindFirstChild(n, true)
                if o then pcall(function() o:Destroy() end) end
                    end
                    local fire = Instance.new("Fire")
                    fire.Name = "Custom_HeadFire"
                    fire.Size = 10
                    fire.Heat = 14
                    fire.Color = Color3.fromRGB(255, 90, 0)
                    fire.SecondaryColor = Color3.fromRGB(255, 200, 40)
                    fire.Enabled = true
                    fire.Parent = cHead
                    local att = Instance.new("Attachment")
                    att.Name = "Custom_HeadFireAtt"
                    att.Parent = cHead
                    local pe = Instance.new("ParticleEmitter")
                    pe.Name = "Custom_HeadFireParticles"
                    pe.Texture = "rbxasset://textures/particles/fire_main.dds"
                    pe.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 200, 40)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 60, 0)),
                    })
                    pe.Size = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 1.2),
                NumberSequenceKeypoint.new(1, 0.2),
                    })
                    pe.Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0.15),
                NumberSequenceKeypoint.new(1, 1),
                    })
                    pe.Lifetime = NumberSequence.new(0.15)
                    pe.Speed = NumberRange.new(2, 5)
                    pe.SpreadAngle = Vector2.new(25, 25)
                    pe.Acceleration = Vector3.new(0, 6, 0)
                    pe.Rate = 40
                    pe.LightEmission = 0.8
                    pe.LightInfluence = 0
                    pe.Parent = att
                end
            end
        end)

        function centerCloneOnHRP()
            hrp = clone:FindFirstChild("HumanoidRootPart") or clone:FindFirstChild("UpperTorso")
            if not hrp then
                clone:PivotTo(CFrame.new(0, 0, 0) * CFrame.Angles(0, math.rad(180), 0))
                return
            end
            yaw = CFrame.Angles(0, math.rad(180), 0)
            hrpCF = hrp.CFrame
            modelCF = clone:GetPivot()
            relative = hrpCF:ToObjectSpace(modelCF)
            clone:PivotTo(yaw * relative)
            hrp = clone:FindFirstChild("HumanoidRootPart") or clone:FindFirstChild("UpperTorso")
            if hrp then
                p = hrp.Position
                clone:PivotTo(clone:GetPivot() - Vector3.new(p.X, p.Y, p.Z))
            end
        end
        pcall(centerCloneOnHRP)

        pcall(function()
            if clone.ScaleTo then
                clone:ScaleTo(0.72)
                centerCloneOnHRP()
            end
        end)

        focusY = 1.05
        pcall(function()
            hrp = clone:FindFirstChild("HumanoidRootPart")
            head = clone:FindFirstChild("Head")
            upper = clone:FindFirstChild("UpperTorso") or clone:FindFirstChild("Torso")
            if head and hrp then
                focusY = hrp.Position.Y * 0.55 + head.Position.Y * 0.45
            elseif head then
                focusY = head.Position.Y - 0.85
            elseif upper then
                focusY = upper.Position.Y
            elseif hrp then
                focusY = hrp.Position.Y + 0.9
            end
            if focusY ~= focusY then focusY = 1.05 end
        end)

        dist = 9.5
        pcall(function()
            local cf, sz = clone:GetBoundingBox()
            if sz and sz.Magnitude > 0.1 and sz.Magnitude < 80 then
                w = math.max(sz.X, sz.Z, 1.2)
                dist = math.clamp(math.max(sz.Y * 1.95, w * 2.6, 8.5), 8, 16)
            end
        end)

        cam = Instance.new("Camera")
        cam.FieldOfView = 28
        cam.Parent = vp
        vp.CurrentCamera = cam
        lookAt = Vector3.new(0, focusY, 0)
        camPos = Vector3.new(0, focusY, dist)
        cam.CFrame = CFrame.new(camPos, lookAt)
    end

    function updateCharPreviewLayout()
        panel = _G.__KyzDuelsCharPreview
        if not panel or not mainOuter then return end
        if panel.Parent ~= mainOuter then
            panel.Parent = mainOuter
        end
        panel.AnchorPoint = Vector2.new(0, 0)
        panel.Position = UDim2.new(1, 0, 0, 0)
        panel.Size = UDim2.new(0, 150, 1, 0)
        mainOuter.ClipsDescendants = false
    end

    function setPlayerVisualExpanded(on)
        -- old hub side preview removed (preview lives only inside Skin Gallery modal)
        if _G.__KyzDuelsCharPreview then
            pcall(function() _G.__KyzDuelsCharPreview:Destroy() end)
            _G.__KyzDuelsCharPreview = nil
        end
        if _G.__KyzDuelsPlayerViewport then
            _G.__KyzDuelsPlayerViewport = nil
        end
    end

    function ensureCharPreviewPanel()
        -- disabled: no more side PLAYER panel on hub
        if _G.__KyzDuelsCharPreview then
            pcall(function() _G.__KyzDuelsCharPreview:Destroy() end)
            _G.__KyzDuelsCharPreview = nil
        end
        if _G.__KyzDuelsPlayerViewport then
            _G.__KyzDuelsPlayerViewport = nil
        end
    end


    SKIN_ASSETS = {
        korblox   = { id = "rbxassetid://139607718" },
    }

    function clearCustomSkinPart(character, name)
        old = character:FindFirstChild(name)
        if old then pcall(function() old:Destroy() end) end
    end

    function applyHeadless(character)
        if not character then return end
        -- hide original hair/face accessories (don't always destroy — some games re-load)
        for _, child in ipairs(character:GetChildren()) do
            if child:IsA("Accessory") or child:IsA("Hat") then
                local tag = nil
                pcall(function() tag = child:GetAttribute("_KyzDuelsSkinTag") end)
                local name = tostring(child.Name or "")
                if tag or name:find("KyzDuelsSkin_", 1, true) then
                    -- keep kyzDuels skins
                else
                    -- prefer hide over destroy so rejoin/respawn is cleaner
                    for _, d in ipairs(child:GetDescendants()) do
                        if d:IsA("BasePart") then
                            pcall(function()
                                d.Transparency = 1
                                d.LocalTransparencyModifier = 1
                            end)
                        elseif d:IsA("Decal") or d:IsA("Texture") then
                            pcall(function() d.Transparency = 1 end)
                        end
                    end
                end
            end
        end
        pcall(clearCustomSkinPart, character, "Custom_Head")
        -- do NOT clear Custom_HeadFire — Fire Head can stack with Headless
        local head = character:FindFirstChild("Head")
        if head then
            for _, desc in ipairs(head:GetDescendants()) do
                if desc:IsA("Decal") or desc:IsA("Texture") then
                    pcall(function()
                        if desc:GetAttribute("_KyzDuelsHeadDecalSaved") == nil then
                            desc:SetAttribute("_KyzDuelsHeadDecalSaved", desc.Transparency)
                        end
                        desc.Transparency = 1
                    end)
                elseif desc:IsA("SpecialMesh") then
                    pcall(function()
                        if desc:GetAttribute("_KyzDuelsHeadMeshSaved") == nil then
                            desc:SetAttribute("_KyzDuelsHeadMeshSaved", desc.Scale)
                        end
                        desc.Scale = Vector3.new(0, 0, 0)
                    end)
                end
            end
            pcall(function()
                head.Transparency = 1
                head.LocalTransparencyModifier = 1
                head.CanCollide = false
            end)
        end
        -- also hide face on R15 layered clothing / wraps if present
        for _, n in ipairs({ "Face", "face", "Head" }) do
            local f = character:FindFirstChild(n, true)
            if f and f:IsA("Decal") then
                pcall(function() f.Transparency = 1 end)
            end
        end
    end

    function removeHeadless(character)
        if not character then return end
        local head = character:FindFirstChild("Head")
        if head then
            pcall(function()
                head.Transparency = 0
                head.LocalTransparencyModifier = 0
            end)
            for _, desc in ipairs(head:GetDescendants()) do
                if desc:IsA("Decal") or desc:IsA("Texture") then
                    pcall(function()
                        local saved = desc:GetAttribute("_KyzDuelsHeadDecalSaved")
                        desc.Transparency = (typeof(saved) == "number") and saved or 0
                    end)
                elseif desc:IsA("SpecialMesh") then
                    pcall(function()
                        local s = desc:GetAttribute("_KyzDuelsHeadMeshSaved")
                        if typeof(s) == "Vector3" then desc.Scale = s end
                    end)
                end
            end
        end
    end

    function _skinResolveHeadAndFire(character)
        character = character or (LP and LP.Character)
        if not character then return end
        local head = character:FindFirstChild("Head")
        if not head then return end
        local wantHeadless = State and State.skinHeadless == true
        local wantFire = State and State.skinFireHead == true

        if wantHeadless then
            pcall(applyHeadless, character)
            pcall(function()
                head.Transparency = 1
                head.LocalTransparencyModifier = 1
            end)
        else
            -- only restore head if not headless (fire alone keeps head visible)
            pcall(function()
                -- do not force visible if a custom KyzDuelsSkin_Head mesh is equipped
                local hasCustomHead = false
                for _, ch in ipairs(character:GetChildren()) do
                    local tag = nil
                    pcall(function() tag = ch:GetAttribute("_KyzDuelsSkinTag") end)
                    if tag == "KyzDuelsSkin_Head" or tostring(ch.Name or ""):find("KyzDuelsSkin_Head", 1, true) then
                        hasCustomHead = true
                        break
                    end
                end
                if not hasCustomHead then
                    head.Transparency = 0
                    head.LocalTransparencyModifier = 0
                else
                    head.Transparency = 1
                    head.LocalTransparencyModifier = 1
                end
            end)
        end

        if wantFire then
            -- ensure fire exists without undoing headless
            local fire = head:FindFirstChild("Custom_HeadFire")
            if not fire then
                pcall(applyFireHead, character)
            else
                pcall(function()
                    fire.Enabled = true
                    if wantHeadless then
                        head.Transparency = 1
                        head.LocalTransparencyModifier = 1
                    end
                end)
            end
        else
            pcall(removeFireHead, character)
        end
    end

    function applyFireHead(character)
        if not character then return end
        local head = character:FindFirstChild("Head")
        if not head then return end
        -- remove only previous fire instances, never touch headless state
        pcall(function()
            local old = head:FindFirstChild("Custom_HeadFire")
            if old then old:Destroy() end
            local att = head:FindFirstChild("Custom_HeadFireAtt")
            if att then
                for _, ch in ipairs(att:GetChildren()) do
                    if ch:IsA("ParticleEmitter") then pcall(function() ch:Destroy() end) end
                end
            end
            local pe = head:FindFirstChild("Custom_HeadFireParticles", true)
            if pe then pe:Destroy() end
        end)
        pcall(clearCustomSkinPart, character, "Custom_HeadFire")
        -- NEVER un-hide head here — headless owns visibility
        if State and State.skinHeadless then
            pcall(function()
                head.Transparency = 1
                head.LocalTransparencyModifier = 1
            end)
        end
        local fire = Instance.new("Fire")
        fire.Name = "Custom_HeadFire"
        fire.Size = 12
        fire.Heat = 16
        fire.Color = Color3.fromRGB(255, 90, 0)
        fire.SecondaryColor = Color3.fromRGB(255, 200, 40)
        fire.Enabled = true
        fire.Parent = head
        -- Particle backup (ViewportFrame shows particles more reliably than Fire)
        pcall(function()
            local old = head:FindFirstChild("Custom_HeadFireParticles")
            if old then old:Destroy() end
            local att = head:FindFirstChild("Custom_HeadFireAtt")
            if not att then
                att = Instance.new("Attachment")
                att.Name = "Custom_HeadFireAtt"
                att.Parent = head
            end
            local pe = Instance.new("ParticleEmitter")
            pe.Name = "Custom_HeadFireParticles"
            pe.Texture = "rbxasset://textures/particles/fire_main.dds"
            pe.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 200, 40)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 60, 0)),
            })
            pe.Size = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 1.4),
                NumberSequenceKeypoint.new(1, 0.25),
            })
            pe.Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0.1),
                NumberSequenceKeypoint.new(1, 1),
            })
            pe.Lifetime = NumberSequence.new(0.12)
            pe.Speed = NumberRange.new(2, 6)
            pe.SpreadAngle = Vector2.new(28, 28)
            pe.Acceleration = Vector3.new(0, 7, 0)
            pe.Rate = 55
            pe.LightEmission = 1
            pe.LightInfluence = 0
            pe.Enabled = true
            pe.Parent = att
        end)
    end

    function removeFireHead(character)
        if not character then return end
        clearCustomSkinPart(character, "Custom_HeadFire")
        local head = character and character:FindFirstChild("Head")
        if head then
            pcall(function()
                local att = head:FindFirstChild("Custom_HeadFireAtt")
                if att then att:Destroy() end
                local pe = head:FindFirstChild("Custom_HeadFireParticles", true)
                if pe then pe:Destroy() end
            end)
        end
    end

    function attachAssetToPart(character, assetId, name, targetPartName, offset, hideParts)
        if not character then return false end
        clearCustomSkinPart(character, name)
        targetPart = character:FindFirstChild(targetPartName)
        if not targetPart then return false end
        if hideParts then
            for _, partName in ipairs(hideParts) do
                limb = character:FindFirstChild(partName)
                if limb and limb:IsA("BasePart") then
                    limb.Transparency = 1
                    for _, child in ipairs(limb:GetDescendants()) do
                        if child:IsA("Decal") or child:IsA("Texture") then
                            child.Transparency = 1
                        end
                    end
                end
            end
        end
        local success, objects = pcall(function()
            return game:GetObjects(assetId)
        end)
        if not success or not objects or #objects == 0 then
            return false
        end
        asset = objects[1]
        asset.Name = name
        mainMesh = asset:IsA("BasePart") and asset or asset:FindFirstChildWhichIsA("BasePart", true)
        if mainMesh then
            mainMesh.CanCollide = false
            mainMesh.Massless = true
            mainMesh.Anchored = false
            mainMesh.CFrame = targetPart.CFrame * (offset or CFrame.new())
            weld = Instance.new("WeldConstraint")
            weld.Part0 = targetPart
            weld.Part1 = mainMesh
            weld.Parent = mainMesh
            asset.Parent = character
            return true
        end
        humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid and (asset:IsA("Accessory") or asset:FindFirstChildWhichIsA("Accessory", true)) then
            acc = asset:IsA("Accessory") and asset or asset:FindFirstChildWhichIsA("Accessory", true)
            acc.Name = name
            pcall(function() humanoid:AddAccessory(acc) end)
            return true
        end
        return false
    end

    function applyHornWhite(character)
        -- Horn White removed from gallery; keep safe no-op for old configs
        a = SKIN_ASSETS and SKIN_ASSETS.hornWhite
        if not a or not a.id then
            pcall(removeHornWhite, character)
            return false
        end
        return attachAssetToPart(character, a.id, "Custom_HornWhite", "Head", a.offset, nil)
    end

    function removeHornWhite(character)
        clearCustomSkinPart(character, "Custom_HornWhite")
    end

    function applyKorblox(character)
        if not character then return false end
        clearCustomSkinPart(character, "Custom_Korblox")

        hideNames = {"RightUpperLeg", "RightLowerLeg", "RightFoot", "Right Leg"}
        for _, partName in ipairs(hideNames) do
            limb = character:FindFirstChild(partName)
            if limb and limb:IsA("BasePart") then
                limb.Transparency = 1
                for _, child in ipairs(limb:GetDescendants()) do
                    if child:IsA("Decal") or child:IsA("Texture") then
                        child.Transparency = 1
                    end
                end
            end
        end

        assetId = (SKIN_ASSETS.korblox and SKIN_ASSETS.korblox.id) or "rbxassetid://139607718"
        local success, objects = pcall(function()
            return game:GetObjects(assetId)
        end)
        if not success or not objects or #objects == 0 then
            success, objects = pcall(function()
                isv = game:GetService("InsertService")
                numId = tonumber((tostring(assetId):gsub("%D", ""))) or 139607718
                model = isv:LoadAsset(numId)
                kids = model and model:GetChildren() or {}
                return kids
            end)
        end
        if not success or not objects or #objects == 0 then
            return false
        end

        asset = objects[1]
        asset.Name = "Custom_Korblox"
        pcall(function() asset.Archivable = true end)

        if asset:IsA("CharacterMesh") then
            asset.Parent = character
            return true
        end

        humanoid = character:FindFirstChildOfClass("Humanoid")
        target = character:FindFirstChild("RightUpperLeg")
            or character:FindFirstChild("Right Leg")
            or character:FindFirstChild("HumanoidRootPart")

        if asset:IsA("Accessory") and humanoid then
            pcall(function() humanoid:AddAccessory(asset) end)
            return true
        end

        acc = asset:FindFirstChildWhichIsA("Accessory", true)
        if acc and humanoid then
            acc.Name = "Custom_Korblox"
            pcall(function() humanoid:AddAccessory(acc) end)
            return true
        end

        mainMesh = asset:IsA("BasePart") and asset or asset:FindFirstChildWhichIsA("BasePart", true)
        if mainMesh and target then
            for _, p in ipairs(asset:IsA("BasePart") and {asset} or asset:GetDescendants()) do
                if p:IsA("BasePart") then
                    p.CanCollide = false
                    p.Massless = true
                    p.Anchored = false
                    pcall(function() p.Archivable = true end)
                end
            end
            asset.Parent = character
            pcall(function()
                if asset:IsA("Model") then
                    asset:PivotTo(target.CFrame)
                else
                    mainMesh.CFrame = target.CFrame
                end
            end)
            weld = Instance.new("WeldConstraint")
            weld.Part0 = target
            weld.Part1 = mainMesh
            weld.Parent = mainMesh
            return true
        end

        pcall(function() asset.Parent = character end)
        return asset.Parent == character
    end

    function removeKorblox(character)
        if not character then return end
        clearCustomSkinPart(character, "Custom_Korblox")
        for _, partName in ipairs({"RightUpperLeg", "RightLowerLeg", "RightFoot", "Right Leg"}) do
            limb = character:FindFirstChild(partName)
            if limb and limb:IsA("BasePart") then
                limb.Transparency = 0
                for _, child in ipairs(limb:GetDescendants()) do
                    if child:IsA("Decal") or child:IsA("Texture") then
                        child.Transparency = 0
                    end
                end
            end
        end
    end

    function applyAllActiveSkins(character)
        character = character or LP.Character
        if not character then return end
        task.defer(function()
            task.wait(0.35)
            if not character.Parent then return end
            if State.skinHeadless then
                pcall(applyHeadless, character)
            end
            if State.skinFireHead then
                pcall(applyFireHead, character)
            end
            if State.skinHornWhite then
                pcall(applyHornWhite, character)
            end
            if State.skinKorblox then
                pcall(applyKorblox, character)
            end
            if _G.__KyzDuelsCharPreview and _G.__KyzDuelsCharPreview.Visible then
                pcall(refreshPlayerViewport)
            end
        end)
    end


    function stripRemoveAccessories(char)
        if not (State and State.removeAccEnabled) then return end
        if not char then return end
        for _, obj in ipairs(char:GetChildren()) do
            local tag = nil
            pcall(function() tag = obj:GetAttribute("_KyzDuelsSkinTag") end)
            local name = tostring(obj.Name or "")
            if tag or name:find("KyzDuelsSkin_", 1, true) then
                -- keep gallery skins
            elseif obj:IsA("Accessory") or obj:IsA("Hat") then
                pcall(function() obj:Destroy() end)
            end
        end
    end
    _G.__KyzDuelsStripRemoveAccessories = stripRemoveAccessories

    if not _G.__KyzDuelsRemoveAccConn then
        _G.__KyzDuelsRemoveAccConn = true
        local function hookCharForRemoveAcc(char)
            if not char then return end
            -- continuous: accessories often load after CharacterAdded
            local childConn
            childConn = char.ChildAdded:Connect(function(obj)
                if not (State and State.removeAccEnabled) then return end
                task.defer(function()
                    if not obj or not obj.Parent then return end
                    local tag = nil
                    pcall(function() tag = obj:GetAttribute("_KyzDuelsSkinTag") end)
                    local name = tostring(obj.Name or "")
                    if tag or name:find("KyzDuelsSkin_", 1, true) then return end
                    if obj:IsA("Accessory") or obj:IsA("Hat") then
                        pcall(function() obj:Destroy() end)
                    end
                end)
            end)
            task.defer(function()
                for _, d in ipairs({0.15, 0.45, 0.9, 1.5, 2.5, 4.0}) do
                    task.wait(d)
                    if not (State and State.removeAccEnabled) then break end
                    if not char or not char.Parent then break end
                    pcall(stripRemoveAccessories, char)
                end
            end)
        end
        LP.CharacterAdded:Connect(hookCharForRemoveAcc)
        if LP.Character then
            task.defer(function() hookCharForRemoveAcc(LP.Character) end)
        end
    end


    if not _G.__KyzDuelsSkinCharConn then
        _G.__KyzDuelsSkinCharConn = true
        LP.CharacterAdded:Connect(function(char)
            applyAllActiveSkins(char)
        end)
        if LP.Character then
            applyAllActiveSkins(LP.Character)
        end
    end

    -- ========== SKIN PLAYER GALLERY (modal like Backgrounds) ==========
    SKIN_CAT_ORDER = { "Head", "Hair", "Blouses", "Pants", "Accessories", "Effects" }
    SKIN_GENDER_CATS = { Head = true, Hair = true, Blouses = true, Pants = true, Accessories = true }

    -- Gender-separated catalogs for Head / Hair / Blouses / Pants / Accessories
    -- Effects stays shared (not gender-specific)
    -- External images: use url + file so we can HttpGet + writefile + getcustomasset
    local _noneItem = { key = "none", name = "None", color = Color3.fromRGB(40, 40, 48) }
    SKIN_ITEMS = {
        Male = {
            Head = {
                { key = "none", name = "None", color = Color3.fromRGB(40, 40, 48) },
                { key = "headless", name = "Headless", color = Color3.fromRGB(70, 70, 80),
                  url = "https://happy-image-link.lovable.app/api/public/f/kx7m2a116.png",
                  file = "kyzDuels_skin_headless.png" },
                { key = "patrick_mentalista", name = "Patrick Mentalista", color = Color3.fromRGB(70, 90, 60),
                  assetId = 93880996730302,
                  image = "rbxthumb://type=Asset&id=93880996730302&w=150&h=150",
                  offset = Vector3.new(0, 0, 0),
                  rot = Vector3.new(0, 0, 0) },
                { key = "rosto_fantasma", name = "Rosto Fantasma", color = Color3.fromRGB(180, 180, 190),
                  assetId = 77369459392942,
                  image = "rbxthumb://type=Asset&id=77369459392942&w=150&h=150",
                  offset = Vector3.new(0, 0, 0),
                  rot = Vector3.new(0, 0, 0) },
                { key = "woody_woodpecker", name = "Woody Woodpecker", color = Color3.fromRGB(220, 80, 60),
                  assetId = 18107984381,
                  image = "rbxthumb://type=Asset&id=18107984381&w=150&h=150",
                  offset = Vector3.new(0, 0, 0),
                  rot = Vector3.new(0, 0, 0) },
                { key = "tim_cheese", name = "Tim Cheese", color = Color3.fromRGB(230, 200, 120),
                  assetId = 138738046486673,
                  image = "rbxthumb://type=Asset&id=138738046486673&w=150&h=150",
                  offset = Vector3.new(0, 0, 0),
                  rot = Vector3.new(0, 0, 0) },
            },
            Hair = {
                { key = "none", name = "None", color = Color3.fromRGB(40, 40, 48) },
            },
            Blouses = {
                { key = "none", name = "None", color = Color3.fromRGB(40, 40, 48) },
            },
            Pants = {
                { key = "none", name = "None", color = Color3.fromRGB(40, 40, 48) },
            },
            Accessories = {
                { key = "none", name = "None", color = Color3.fromRGB(40, 40, 48) },
                { key = "black_cap_back", name = "Black Cap Back", color = Color3.fromRGB(25, 25, 30),
                  assetId = 125892049886895,
                  image = "rbxthumb://type=Asset&id=125892049886895&w=150&h=150",
                  offset = Vector3.new(0, 0, 0),
                  rot = Vector3.new(0, 0, 0) },
                { key = "silver_star_crown", name = "Silver Star Crown", color = Color3.fromRGB(200, 200, 210),
                  assetId = 18419951631,
                  image = "rbxthumb://type=Asset&id=18419951631&w=150&h=150",
                  offset = Vector3.new(0, 0.15, 0),
                  rot = Vector3.new(0, 0, 0) },
                { key = "grunge_cat_cap", name = "Grunge Cat Cap", color = Color3.fromRGB(50, 45, 40),
                  assetId = 105268898990071,
                  image = "rbxthumb://type=Asset&id=105268898990071&w=150&h=150",
                  offset = Vector3.new(0, 0, 0),
                  rot = Vector3.new(0, 0, 0) },
                { key = "birthday_fedora", name = "Birthday Fedora", color = Color3.fromRGB(40, 40, 48),
                  assetId = 116109904627748,
                  image = "rbxthumb://type=Asset&id=116109904627748&w=150&h=150",
                  offset = Vector3.new(0, 0.1, 0),
                  rot = Vector3.new(0, 0, 0) },
                { key = "triciclo_vermelho", name = "Triciclo Vermelho", color = Color3.fromRGB(200, 40, 40),
                  assetId = 114443891211093,
                  image = "rbxthumb://type=Asset&id=114443891211093&w=150&h=150",
                  offset = Vector3.new(0, -1.2, -0.6),
                  rot = Vector3.new(0, 0, 0),
                  attach = "LowerTorso" },
                { key = "mascara_palhaco", name = "Máscara Palhaço", color = Color3.fromRGB(240, 180, 60),
                  assetId = 91001713768399,
                  image = "rbxthumb://type=Asset&id=91001713768399&w=150&h=150",
                  offset = Vector3.new(0, 0, 0),
                  rot = Vector3.new(0, 0, 0) },
                { key = "valkyrie", name = "Valkyrie", color = Color3.fromRGB(180, 160, 220),
                  assetId = 93103883598254,
                  image = "rbxthumb://type=Asset&id=93103883598254&w=150&h=150",
                  offset = Vector3.new(0, 0, 0),
                  rot = Vector3.new(0, 0, 0) },
                { key = "purple_chifres_tempestade", name = "Purple Chifres Tempestade", color = Color3.fromRGB(140, 80, 200),
                  assetId = 132631477100005,
                  image = "rbxthumb://type=Asset&id=132631477100005&w=150&h=150",
                  offset = Vector3.new(0, 0, 0),
                  rot = Vector3.new(0, 0, 0) },
                { key = "expressao_anime_irritada", name = "Expressão Anime Irritada", color = Color3.fromRGB(220, 100, 100),
                  assetId = 128019192988283,
                  image = "rbxthumb://type=Asset&id=128019192988283&w=150&h=150",
                  offset = Vector3.new(0, 0, 0),
                  rot = Vector3.new(0, 0, 0) },
                { key = "angelic_crown", name = "Angelic Crown", color = Color3.fromRGB(240, 230, 180),
                  assetId = 118035446358036,
                  image = "rbxthumb://type=Asset&id=118035446358036&w=150&h=150",
                  offset = Vector3.new(0, 0, 0),
                  rot = Vector3.new(0, 0, 0) },
                { key = "pink_valk", name = "Pink Valk", color = Color3.fromRGB(240, 140, 180),
                  assetId = 102752833871217,
                  image = "rbxthumb://type=Asset&id=102752833871217&w=150&h=150",
                  offset = Vector3.new(0, 0, 0),
                  rot = Vector3.new(0, 0, 0) },
                { key = "viscount_federatlonn", name = "Viscount Federatlonn", color = Color3.fromRGB(60, 60, 80),
                  assetId = 106097361972499,
                  image = "rbxthumb://type=Asset&id=106097361972499&w=150&h=150",
                  offset = Vector3.new(0, 0, 0),
                  rot = Vector3.new(0, 0, 0) },
                { key = "capa_aranha_branca", name = "Capa Aranha Branca Y2K", color = Color3.fromRGB(230, 230, 240),
                  assetId = 78101762559284,
                  image = "rbxthumb://type=Asset&id=78101762559284&w=150&h=150",
                  offset = Vector3.new(0, 0, 0),
                  rot = Vector3.new(0, 0, 0) },
                { key = "sleepy_kitten_pink", name = "Sleepy Kitten Pink", color = Color3.fromRGB(250, 160, 190),
                  assetId = 77246916068441,
                  image = "rbxthumb://type=Asset&id=77246916068441&w=150&h=150",
                  offset = Vector3.new(0, 0, 0),
                  rot = Vector3.new(0, 0, 0) },
                { key = "cadeia_cranio_branco", name = "Cadeia Crânio Branco", color = Color3.fromRGB(230, 230, 235),
                  assetId = 101595301225197,
                  image = "rbxthumb://type=Asset&id=101595301225197&w=150&h=150",
                  offset = Vector3.new(0, 0, 0),
                  rot = Vector3.new(0, 0, 0) },
                { key = "kawaii_grunge_cross_clips", name = "Kawaii Grunge Cross Clips", color = Color3.fromRGB(30, 30, 35),
                  assetId = 122858102532546,
                  image = "rbxthumb://type=Asset&id=122858102532546&w=150&h=150",
                  offset = Vector3.new(0, 0, 0),
                  rot = Vector3.new(0, 0, 0) },
                { key = "mask_103965", name = "Mask", color = Color3.fromRGB(40, 40, 48),
                  assetId = 103965615084984,
                  image = "rbxthumb://type=Asset&id=103965615084984&w=150&h=150",
                  offset = Vector3.new(0, 0, 0),
                  rot = Vector3.new(0, 0, 0) },
                { key = "skelehands_see_no_evil", name = "Skelehands See No Evil", color = Color3.fromRGB(200, 200, 210),
                  assetId = 88989010919868,
                  image = "rbxthumb://type=Asset&id=88989010919868&w=150&h=150",
                  offset = Vector3.new(0, 0, 0),
                  rot = Vector3.new(0, 0, 0) },
                { key = "pink_nurse_eyepatch", name = "Pink Nurse Eyepatch", color = Color3.fromRGB(250, 140, 180),
                  assetId = 16234549573,
                  image = "rbxthumb://type=Asset&id=16234549573&w=150&h=150",
                  offset = Vector3.new(0, 0, 0),
                  rot = Vector3.new(0, 0, 0) },
            },
        },
        Female = {
            Head = {
                { key = "none", name = "None", color = Color3.fromRGB(40, 40, 48) },
                { key = "headless", name = "Headless", color = Color3.fromRGB(70, 70, 80),
                  url = "https://happy-image-link.lovable.app/api/public/f/kx7m2a116.png",
                  file = "kyzDuels_skin_headless.png" },
                { key = "shy_cat_girl", name = "Shy Cat Girl", color = Color3.fromRGB(40, 40, 50),
                  assetId = 130023971256267,
                  image = "rbxthumb://type=Asset&id=130023971256267&w=150&h=150" },
                { key = "moe_cat_glasses", name = "Moe Cat Glasses", color = Color3.fromRGB(40, 40, 50),
                  assetId = 84159657297259,
                  image = "rbxthumb://type=Asset&id=84159657297259&w=150&h=150" },
                { key = "kawaii_pink_cat", name = "Kawaii Pink Cat", color = Color3.fromRGB(220, 140, 180),
                  assetId = 95037324715463,
                  image = "rbxthumb://type=Asset&id=95037324715463&w=150&h=150" },
            },
            Hair = {
                { key = "none", name = "None", color = Color3.fromRGB(40, 40, 48) },
                { key = "igari_beret", name = "Igari Beret", color = Color3.fromRGB(30, 30, 35),
                  assetId = 96663516178704,
                  image = "rbxthumb://type=Asset&id=96663516178704&w=150&h=150" },
                { key = "dark_bob", name = "Dark Bob", color = Color3.fromRGB(230, 230, 235),
                  assetId = 72525903095118,
                  image = "rbxthumb://type=Asset&id=72525903095118&w=150&h=150" },
                { key = "long_black", name = "Long Black", color = Color3.fromRGB(20, 20, 25),
                  assetId = 128883646508213,
                  image = "rbxthumb://type=Asset&id=128883646508213&w=150&h=150" },
                { key = "gothic_blonde", name = "Gothic Blonde", color = Color3.fromRGB(240, 220, 170),
                  assetId = 125156358558270,
                  image = "rbxthumb://type=Asset&id=125156358558270&w=150&h=150" },
            },
            Blouses = {
                { key = "none", name = "None", color = Color3.fromRGB(40, 40, 48) },
            },
            Pants = {
                { key = "none", name = "None", color = Color3.fromRGB(40, 40, 48) },
            },
            Accessories = {
                { key = "none", name = "None", color = Color3.fromRGB(40, 40, 48) },
                { key = "triciclo_vermelho", name = "Triciclo Vermelho", color = Color3.fromRGB(200, 40, 40),
                  assetId = 114443891211093,
                  image = "rbxthumb://type=Asset&id=114443891211093&w=150&h=150",
                  offset = Vector3.new(0, -1.2, -0.6),
                  rot = Vector3.new(0, 0, 0),
                  attach = "LowerTorso" },
                { key = "mascara_palhaco", name = "Máscara Palhaço", color = Color3.fromRGB(240, 180, 60),
                  assetId = 91001713768399,
                  image = "rbxthumb://type=Asset&id=91001713768399&w=150&h=150",
                  offset = Vector3.new(0, 0, 0),
                  rot = Vector3.new(0, 0, 0) },
                { key = "valkyrie", name = "Valkyrie", color = Color3.fromRGB(180, 160, 220),
                  assetId = 93103883598254,
                  image = "rbxthumb://type=Asset&id=93103883598254&w=150&h=150",
                  offset = Vector3.new(0, 0, 0),
                  rot = Vector3.new(0, 0, 0) },
                { key = "purple_chifres_tempestade", name = "Purple Chifres Tempestade", color = Color3.fromRGB(140, 80, 200),
                  assetId = 132631477100005,
                  image = "rbxthumb://type=Asset&id=132631477100005&w=150&h=150",
                  offset = Vector3.new(0, 0, 0),
                  rot = Vector3.new(0, 0, 0) },
                { key = "expressao_anime_irritada", name = "Expressão Anime Irritada", color = Color3.fromRGB(220, 100, 100),
                  assetId = 128019192988283,
                  image = "rbxthumb://type=Asset&id=128019192988283&w=150&h=150",
                  offset = Vector3.new(0, 0, 0),
                  rot = Vector3.new(0, 0, 0) },
                { key = "angelic_crown", name = "Angelic Crown", color = Color3.fromRGB(240, 230, 180),
                  assetId = 118035446358036,
                  image = "rbxthumb://type=Asset&id=118035446358036&w=150&h=150",
                  offset = Vector3.new(0, 0, 0),
                  rot = Vector3.new(0, 0, 0) },
                { key = "pink_valk", name = "Pink Valk", color = Color3.fromRGB(240, 140, 180),
                  assetId = 102752833871217,
                  image = "rbxthumb://type=Asset&id=102752833871217&w=150&h=150",
                  offset = Vector3.new(0, 0, 0),
                  rot = Vector3.new(0, 0, 0) },
                { key = "viscount_federatlonn", name = "Viscount Federatlonn", color = Color3.fromRGB(60, 60, 80),
                  assetId = 106097361972499,
                  image = "rbxthumb://type=Asset&id=106097361972499&w=150&h=150",
                  offset = Vector3.new(0, 0, 0),
                  rot = Vector3.new(0, 0, 0) },
                { key = "capa_aranha_branca", name = "Capa Aranha Branca Y2K", color = Color3.fromRGB(230, 230, 240),
                  assetId = 78101762559284,
                  image = "rbxthumb://type=Asset&id=78101762559284&w=150&h=150",
                  offset = Vector3.new(0, 0, 0),
                  rot = Vector3.new(0, 0, 0) },
                { key = "sleepy_kitten_pink", name = "Sleepy Kitten Pink", color = Color3.fromRGB(250, 160, 190),
                  assetId = 77246916068441,
                  image = "rbxthumb://type=Asset&id=77246916068441&w=150&h=150",
                  offset = Vector3.new(0, 0, 0),
                  rot = Vector3.new(0, 0, 0) },
                { key = "cadeia_cranio_branco", name = "Cadeia Crânio Branco", color = Color3.fromRGB(230, 230, 235),
                  assetId = 101595301225197,
                  image = "rbxthumb://type=Asset&id=101595301225197&w=150&h=150",
                  offset = Vector3.new(0, 0, 0),
                  rot = Vector3.new(0, 0, 0) },
                { key = "kawaii_unicorn_trike", name = "Kawaii Unicorn Trike", color = Color3.fromRGB(255, 160, 210),
                  assetId = 93921071499513,
                  image = "rbxthumb://type=Asset&id=93921071499513&w=150&h=150",
                  offset = Vector3.new(0, -1.2, -0.6),
                  rot = Vector3.new(0, 0, 0),
                  attach = "LowerTorso" },
                { key = "kawaii_grunge_cross_clips", name = "Kawaii Grunge Cross Clips", color = Color3.fromRGB(30, 30, 35),
                  assetId = 122858102532546,
                  image = "rbxthumb://type=Asset&id=122858102532546&w=150&h=150",
                  offset = Vector3.new(0, 0, 0),
                  rot = Vector3.new(0, 0, 0) },
                { key = "mask_103965", name = "Mask", color = Color3.fromRGB(40, 40, 48),
                  assetId = 103965615084984,
                  image = "rbxthumb://type=Asset&id=103965615084984&w=150&h=150",
                  offset = Vector3.new(0, 0, 0),
                  rot = Vector3.new(0, 0, 0) },
                { key = "skelehands_see_no_evil", name = "Skelehands See No Evil", color = Color3.fromRGB(200, 200, 210),
                  assetId = 88989010919868,
                  image = "rbxthumb://type=Asset&id=88989010919868&w=150&h=150",
                  offset = Vector3.new(0, 0, 0),
                  rot = Vector3.new(0, 0, 0) },
                { key = "pink_nurse_eyepatch", name = "Pink Nurse Eyepatch", color = Color3.fromRGB(250, 140, 180),
                  assetId = 16234549573,
                  image = "rbxthumb://type=Asset&id=16234549573&w=150&h=150",
                  offset = Vector3.new(0, 0, 0),
                  rot = Vector3.new(0, 0, 0) },
            },
        },
        -- Shared (no gender split)
        Effects = {
            { key = "none", name = "None", color = Color3.fromRGB(40, 40, 48) },
            { key = "fireHead", name = "Fire Head", color = Color3.fromRGB(255, 140, 40),
              url = "https://happy-image-link.lovable.app/api/public/f/kx7m2a115.png",
              file = "kyzDuels_skin_firehead.png" },
            { key = "korblox", name = "Korblox", color = Color3.fromRGB(90, 60, 140),
              image = "rbxthumb://type=Asset&id=139607718&w=150&h=150" },
            { key = "spring_fairy", name = "Spring Fairy", color = Color3.fromRGB(180, 220, 160),
              assetId = 150381051,
              image = "rbxthumb://type=Asset&id=150381051&w=150&h=150",
              offset = Vector3.new(0, 0, 0),
              rot = Vector3.new(0, 0, 0) },
        },
    }

    -- Cache resolved custom assets for skin thumbs
    local _skinImageCache = {}

    function _skinResolveImage(item)
        if not item then return "" end
        -- already a rbx / rbxthumb path
        if type(item.image) == "string" and item.image ~= "" then
            return item.image
        end
        local url = item.url
        local file = item.file
        if type(url) ~= "string" or url == "" then return "" end
        if _skinImageCache[url] and _skinImageCache[url] ~= "" then
            return _skinImageCache[url]
        end
        if type(file) ~= "string" or file == "" then
            file = "kyzDuels_skin_" .. tostring(item.key or "img") .. ".png"
        end
        local asset = ""
        pcall(function()
            if writefile and (game.HttpGet or HttpGet or _G.__KyzDuelsHttpGet) then
                local need = true
                pcall(function()
                    if isfile and isfile(file) then need = false end
                end)
                if need then
                    local data = (_G.__KyzDuelsHttpGet and _G.__KyzDuelsHttpGet(url, true))
                        or (game.HttpGet and game:HttpGet(url, true))
                        or (HttpGet and HttpGet(url))
                    if data and #tostring(data) > 32 then
                        writefile(file, data)
                    end
                end
            end
        end)
        pcall(function()
            if getcustomasset and isfile and isfile(file) then
                asset = getcustomasset(file)
            end
        end)
        if asset == "" then
            -- last resort: some executors accept the raw url
            asset = url
        end
        _skinImageCache[url] = asset
        return asset
    end

    function _skinPreloadAllImages()
        task.spawn(function()
            local function walk(list)
                if type(list) ~= "table" then return end
                for _, it in ipairs(list) do
                    if it and (it.url or it.image) then
                        pcall(_skinResolveImage, it)
                    end
                end
            end
            for _, g in ipairs({ "Male", "Female" }) do
                local bag = SKIN_ITEMS[g]
                if bag then
                    for _, cat in ipairs({ "Head", "Hair", "Blouses", "Pants", "Accessories" }) do
                        walk(bag[cat])
                    end
                end
            end
            walk(SKIN_ITEMS.Effects)
        end)
    end

    function _getSkinItemList(cat)
        local list = {}
        if cat == "Effects" then
            for _, it in ipairs(SKIN_ITEMS.Effects or { _noneItem }) do
                table.insert(list, it)
            end
        else
            local g = (_skinGallery and _skinGallery.gender) or "Male"
            local bag = SKIN_ITEMS[g]
            if bag and bag[cat] then
                for _, it in ipairs(bag[cat]) do
                    table.insert(list, it)
                end
            else
                table.insert(list, _noneItem)
            end
        end
        -- append user custom skins for this category (+ gender when relevant)
        local customs = (State and State.customSkins) or {}
        local gNow = (_skinGallery and _skinGallery.gender) or "Male"
        for _, it in ipairs(customs) do
            if type(it) == "table" and it.cat == cat then
                if cat == "Effects" or it.gender == nil or it.gender == gNow or it.gender == "All" then
                    table.insert(list, {
                        key = tostring(it.key or ("custom_" .. tostring(it.assetId))),
                        name = tostring(it.name or ("ID " .. tostring(it.assetId))),
                        color = Color3.fromRGB(60, 60, 70),
                        assetId = tonumber(it.assetId),
                        image = it.image or (it.assetId and ("rbxthumb://type=Asset&id=" .. tostring(it.assetId) .. "&w=150&h=150") or ""),
                        offset = Vector3.new(0, 0, 0),
                        rot = Vector3.new(0, 0, 0),
                        custom = true,
                    })
                end
            end
        end
        if #list == 0 then
            table.insert(list, _noneItem)
        end
        return list
    end

    _skinGallery = {
        gender = "Male", -- "Male" | "Female"
        activeCat = "Head",
        selected = {
            Head = "none",
            Hair = "none",
            Blouses = "none",
            Pants = "none",
            Accessories = "none",
            Effects = "none",
        },
        pending = {
            Head = "none",
            Hair = "none",
            Blouses = "none",
            Pants = "none",
            Accessories = "none",
            Effects = "none",
        },
        -- keep last pick per gender so switching Male/Female remembers
        byGender = {
            Male = { Head = "none", Hair = "none", Blouses = "none", Pants = "none", Accessories = "none" },
            Female = { Head = "none", Hair = "none", Blouses = "none", Pants = "none", Accessories = "none" },
        },
    }
    -- restore saved gallery picks
    pcall(function()
        local sg = State and State._pendingSkinGallery
        if type(sg) ~= "table" then return end
        if type(sg.gender) == "string" then _skinGallery.gender = sg.gender end
        if type(sg.pending) == "table" then
            for k, v in pairs(sg.pending) do _skinGallery.pending[k] = v end
        end
        if type(sg.selected) == "table" then
            for k, v in pairs(sg.selected) do _skinGallery.selected[k] = v end
        end
        if type(sg.byGender) == "table" then
            for g, bag in pairs(sg.byGender) do
                if type(bag) == "table" then
                    _skinGallery.byGender[g] = _skinGallery.byGender[g] or {}
                    for k, v in pairs(bag) do _skinGallery.byGender[g][k] = v end
                end
            end
        end
        -- map bool effects into pending if needed
        if State.skinHeadless then _skinGallery.pending.Head = "headless" end
        if State.skinFireHead or State.skinKorblox then
            local fx = type(_skinGallery.pending.Effects) == "table" and _skinGallery.pending.Effects or {}
            if State.skinFireHead then fx.fireHead = true end
            if State.skinKorblox then fx.korblox = true end
            fx.none = nil
            _skinGallery.pending.Effects = fx
        end
        -- keep a durable mirror for autosave even if _skinGallery gets shadowed
        State.skinGallery = {
            gender = _skinGallery.gender,
            pending = _skinGallery.pending,
            selected = _skinGallery.selected,
            byGender = _skinGallery.byGender,
        }
    end)

    -- Apply restored skins to current character (rejoin / first load)
    task.defer(function()
        task.wait(0.8)
        pcall(function()
            if _skinApplyAllPending then
                _skinApplyAllPending()
            end
        end)
        task.wait(0.6)
        pcall(function()
            if _skinApplyAllPending then
                _skinApplyAllPending()
            end
        end)
        pcall(function()
            if autoSave then autoSave(true) elseif saveConfig then saveConfig() end
        end)
    end)

    -- ========== Flow.VS-style accessory loader for Skin Gallery ==========
    -- IMPORTANT: never destroy the player's original accessories.
    -- Only touch instances tagged with _KyzDuelsSkinTag / named KyzDuelsSkin_*.

    function _skinFindItem(cat, key)
        for _, it in ipairs(_getSkinItemList(cat)) do
            if it.key == key then return it end
        end
        return nil
    end

    function _skinLoadAssetObjects(assetId)
        assetId = tonumber(assetId) or assetId
        local ok, res = pcall(function()
            return game:GetObjects("rbxassetid://" .. tostring(assetId))
        end)
        if ok and typeof(res) == "table" and #res > 0 then
            return res
        end
        ok, res = pcall(function()
            return game:GetService("InsertService"):LoadAsset(tonumber(assetId))
        end)
        if ok and res then
            return { res }
        end
        ok, res = pcall(function()
            return game:GetObjects("http://www.roblox.com/asset/?id=" .. tostring(assetId))
        end)
        if ok and typeof(res) == "table" and #res > 0 then
            return res
        end
        return nil
    end

    function _skinClearTaggedAccessories(character, tag)
        if not character then return end
        tag = tostring(tag or "")
        -- ONLY destroy kyzDuels-tagged / kyzDuels-named pieces — never originals
        local toKill = {}
        for _, ch in ipairs(character:GetChildren()) do
            local chTag = nil
            pcall(function() chTag = ch:GetAttribute("_KyzDuelsSkinTag") end)
            local name = tostring(ch.Name or "")
            if chTag == tag or name == tag then
                table.insert(toKill, ch)
            elseif type(chTag) == "string" and chTag:find("KyzDuelsSkin_", 1, true) and (tag == "" or chTag == tag) then
                if tag == "" or chTag == tag then
                    table.insert(toKill, ch)
                end
            end
        end
        for _, ch in ipairs(toKill) do
            pcall(function() ch:Destroy() end)
        end
    end

    function _skinClearCategoryAccessories(character, cat)
        if not character then return end
        local prefix = "KyzDuelsSkin_" .. tostring(cat)
        -- clear exact tag and any unique per-key tags (KyzDuelsSkin_Accessories_xxx)
        local toKill = {}
        for _, ch in ipairs(character:GetChildren()) do
            local chTag = nil
            pcall(function() chTag = ch:GetAttribute("_KyzDuelsSkinTag") end)
            local name = tostring(ch.Name or "")
            if chTag == prefix or name == prefix then
                table.insert(toKill, ch)
            elseif type(chTag) == "string" and (chTag == prefix or chTag:sub(1, #prefix + 1) == prefix .. "_") then
                table.insert(toKill, ch)
            elseif name:sub(1, #prefix + 1) == prefix .. "_" or name == prefix then
                table.insert(toKill, ch)
            end
        end
        for _, ch in ipairs(toKill) do
            pcall(function() ch:Destroy() end)
        end
        -- also run legacy exact clear
        pcall(_skinClearTaggedAccessories, character, prefix)
    end

    local function _skinPrepPart(p)
        if not (p and p:IsA("BasePart")) then return end
        p.CanCollide = false
        p.Anchored = false
        p.Massless = true
        pcall(function()
            p.CanQuery = false
            p.CanTouch = false
        end)
    end

    -- Visible mesh path: clone Handle + Attachment weld (AddAccessory often OK but invisible)
    function _skinApplyCatalogAsset(character, assetId, tag, offset, rot, attachPartName)
        if not character or not assetId then
            warn("[Kyz Duels] apply failed: no character/assetId")
            return false
        end
        tag = tostring(tag or ("KyzDuelsSkin_" .. tostring(assetId)))
        if typeof(offset) ~= "Vector3" then offset = Vector3.new(0, 0, 0) end
        if typeof(rot) ~= "Vector3" then rot = Vector3.new(0, 0, 0) end

        _skinClearTaggedAccessories(character, tag)

        local head = character:FindFirstChild("Head") or character:WaitForChild("Head", 8)
        if not head then
            warn("[Kyz Duels] no Head")
            return false
        end
        local humanoid = character:FindFirstChildOfClass("Humanoid")

        local objs = _skinLoadAssetObjects(assetId)
        if not objs or #objs == 0 then
            warn("[Kyz Duels] load failed", tostring(assetId))
            return false
        end

        local function prep(p)
            if not (p and p:IsA("BasePart")) then return end
            p.CanCollide = false
            p.Anchored = false
            p.Massless = true
            p.Transparency = 0
            pcall(function()
                p.LocalTransparencyModifier = 0
                p.CastShadow = true
            end)
        end

        local function stripScripts(inst)
            for _, d in ipairs(inst:GetDescendants()) do
                if d:IsA("Script") or d:IsA("LocalScript") then
                    pcall(function() d:Destroy() end)
                end
            end
        end

        -- Find best Handle + its Attachment name
        local srcHandle = nil
        local srcAcc = nil
        for _, o in ipairs(objs) do
            if o:IsA("Accessory") or o:IsA("Hat") then
                srcAcc = o
                srcHandle = o:FindFirstChild("Handle")
                if srcHandle then break end
            end
            local a = o:FindFirstChildWhichIsA("Accessory", true) or o:FindFirstChildWhichIsA("Hat", true)
            if a then
                srcAcc = a
                srcHandle = a:FindFirstChild("Handle")
                if srcHandle then break end
            end
        end
        if not srcHandle then
            for _, o in ipairs(objs) do
                if o:IsA("BasePart") then
                    srcHandle = o
                    break
                end
                local h = o:FindFirstChild("Handle") or o:FindFirstChildWhichIsA("BasePart", true)
                if h then
                    srcHandle = h
                    break
                end
            end
        end

        if not srcHandle then
            warn("[Kyz Duels] no Handle in asset", tostring(assetId))
            for _, o in ipairs(objs) do pcall(function() o:Destroy() end) end
            return false
        end

        -- Clone FULL accessory when possible (keeps mesh, specialmesh, textures)
        local container = nil
        local handle = nil
        if srcAcc then
            container = srcAcc:Clone()
            container.Name = tag
            pcall(function() container:SetAttribute("_KyzDuelsSkinTag", tag) end)
            stripScripts(container)
            handle = container:FindFirstChild("Handle")
            if not handle then
                handle = container:FindFirstChildWhichIsA("BasePart", true)
            end
        else
            handle = srcHandle:Clone()
            handle.Name = tag
            pcall(function() handle:SetAttribute("_KyzDuelsSkinTag", tag) end)
            container = handle
        end

        if not handle then
            warn("[Kyz Duels] clone has no handle", tostring(assetId))
            pcall(function() if container then container:Destroy() end end)
            for _, o in ipairs(objs) do pcall(function() o:Destroy() end) end
            return false
        end

        -- Force every part visible
        if container:IsA("BasePart") then
            prep(container)
        end
        for _, d in ipairs(container:GetDescendants()) do
            if d:IsA("BasePart") then
                prep(d)
            elseif d:IsA("Decal") or d:IsA("Texture") then
                pcall(function() d.Transparency = 0 end)
            end
        end
        prep(handle)

        -- Parent under character first
        container.Parent = character

        -- Resolve attach part (Head default, or LowerTorso / legs for ground props)
        local attachPart = nil
        if type(attachPartName) == "string" and attachPartName ~= "" then
            attachPart = character:FindFirstChild(attachPartName)
        end
        if not attachPart then
            attachPart = character:FindFirstChild("Head") or head
        end
        -- prefer body for explicit lower slots
        if type(attachPartName) == "string" then
            local low = string.lower(attachPartName)
            if low:find("torso") or low:find("root") or low:find("leg") or low:find("foot") or low:find("hip") then
                attachPart = character:FindFirstChild(attachPartName)
                    or character:FindFirstChild("LowerTorso")
                    or character:FindFirstChild("Torso")
                    or character:FindFirstChild("HumanoidRootPart")
                    or attachPart
            end
        end

        local accAtt = handle:FindFirstChildWhichIsA("Attachment")
        local bodyAtt = nil
        -- only match same-name attachment on the chosen part (not force head hats)
        if accAtt and attachPart then
            bodyAtt = attachPart:FindFirstChild(accAtt.Name)
        end

        -- Destroy any existing welds on handle that might fight us
        for _, w in ipairs(handle:GetChildren()) do
            if w:IsA("Weld") or w:IsA("WeldConstraint") or w:IsA("Motor6D") then
                pcall(function() w:Destroy() end)
            end
        end

        local rotCF = CFrame.Angles(math.rad(rot.X), math.rad(rot.Y), math.rad(rot.Z))
        local weld = Instance.new("Weld")
        weld.Name = "_KyzDuelsSkinWeld"
        weld.Part0 = attachPart
        weld.Part1 = handle
        if bodyAtt and accAtt and attachPart == head then
            -- head-style accessory: keep attachment alignment, still honor user offset
            weld.C0 = bodyAtt.CFrame * CFrame.new(offset) * rotCF
            weld.C1 = accAtt.CFrame
        else
            -- body / custom attach: place by offset from part center
            weld.C0 = CFrame.new(offset) * rotCF
            if accAtt then
                weld.C1 = accAtt.CFrame
            else
                weld.C1 = CFrame.new()
            end
        end
        weld.Parent = handle

        -- Also try native AddAccessory AFTER weld as secondary (some games prefer it)
        -- Skip - causes invisible duplicates. Weld path is what shows.

        for _, o in ipairs(objs) do
            pcall(function() o:Destroy() end)
        end

        return true
    end

    function _skinApplyHeadMesh(character, meshId, textureId)
        if not character then return end
        local head = character:FindFirstChild("Head")
        if not head then return end
        for _, d in ipairs(character:GetChildren()) do
            if d:IsA("CharacterMesh") and d.BodyPart == Enum.BodyPart.Head then
                pcall(function() d:Destroy() end)
            end
        end
        local done = false
        if head:IsA("MeshPart") and meshId then
            done = pcall(function()
                head.MeshId = meshId
                if textureId then head.TextureID = textureId end
            end)
        end
        if not done and meshId then
            local sm = head:FindFirstChildWhichIsA("SpecialMesh") or Instance.new("SpecialMesh")
            sm.Parent = head
            sm.MeshType = Enum.MeshType.FileMesh
            sm.MeshId = meshId
            sm.TextureId = textureId or ""
        end
    end

    function _skinApplyShirtPants(character, shirtId, pantsId)
        if not character then return end
        if shirtId then
            local s = character:FindFirstChildWhichIsA("Shirt") or Instance.new("Shirt")
            s.Name = "Shirt"
            s.ShirtTemplate = shirtId
            s.Parent = character
        end
        if pantsId then
            local p = character:FindFirstChildWhichIsA("Pants") or Instance.new("Pants")
            p.Name = "Pants"
            p.PantsTemplate = pantsId
            p.Parent = character
        end
    end

    function _skinRestoreHeadVisibility(char)
        local head = char and char:FindFirstChild("Head")
        if not head then return end
        pcall(function()
            head.Transparency = 0
            head.LocalTransparencyModifier = 0
        end)
        for _, d in ipairs(head:GetDescendants()) do
            if d:IsA("Decal") or d:IsA("Texture") then
                pcall(function()
                    local saved = d:GetAttribute("_KyzDuelsHeadDecalSaved")
                    d.Transparency = (typeof(saved) == "number") and saved or 0
                end)
            end
        end
    end

    function _skinHideHeadVisibility(char)
        local head = char and char:FindFirstChild("Head")
        if not head then return end
        pcall(function()
            head.Transparency = 1
            head.LocalTransparencyModifier = 1
        end)
        for _, d in ipairs(head:GetDescendants()) do
            if d:IsA("Decal") or d:IsA("Texture") then
                pcall(function()
                    if d:GetAttribute("_KyzDuelsHeadDecalSaved") == nil then
                        d:SetAttribute("_KyzDuelsHeadDecalSaved", d.Transparency)
                    end
                    d.Transparency = 1
                end)
            end
        end
    end

    function _skinSetOriginalHairVisible(char, visible)
        if not char then return end
        for _, ch in ipairs(char:GetChildren()) do
            if ch:IsA("Accessory") or ch:IsA("Hat") then
                local tag = nil
                pcall(function() tag = ch:GetAttribute("_KyzDuelsSkinTag") end)
                local nm = tostring(ch.Name or "")
                -- never touch our gallery skins (Hair OR Accessories OR Effects)
                if (type(tag) == "string" and tag:find("KyzDuelsSkin_", 1, true)) or nm:find("KyzDuelsSkin_", 1, true) then
                    -- leave our skins alone
                else
                    -- hide/show original hair-like accessories (not destroy)
                    for _, d in ipairs(ch:GetDescendants()) do
                        if d:IsA("BasePart") then
                            pcall(function()
                                if not visible then
                                    if d:GetAttribute("_KyzDuelsHairSavedT") == nil then
                                        d:SetAttribute("_KyzDuelsHairSavedT", d.Transparency)
                                    end
                                    d.Transparency = 1
                                    d.LocalTransparencyModifier = 1
                                else
                                    local s = d:GetAttribute("_KyzDuelsHairSavedT")
                                    d.Transparency = (typeof(s) == "number") and s or 0
                                    d.LocalTransparencyModifier = 0
                                end
                            end)
                        elseif d:IsA("Decal") or d:IsA("Texture") then
                            pcall(function()
                                if not visible then
                                    if d:GetAttribute("_KyzDuelsHairSavedT") == nil then
                                        d:SetAttribute("_KyzDuelsHairSavedT", d.Transparency)
                                    end
                                    d.Transparency = 1
                                else
                                    local s = d:GetAttribute("_KyzDuelsHairSavedT")
                                    d.Transparency = (typeof(s) == "number") and s or 0
                                end
                            end)
                        end
                    end
                end
            end
        end
    end

    function _skinApplyKey(cat, key, multi)
        local char = LP.Character
        if not char then return end
        pcall(function() char:WaitForChild("Head", 5) end)
        pcall(function() char:WaitForChild("Humanoid", 5) end)

        if cat == "Head" then
            State.skinHeadless = (key == "headless")
            _skinClearCategoryAccessories(char, "Head")
            if key == "headless" then
                -- hide head fully (do NOT restore first)
                pcall(_skinHideHeadVisibility, char)
                pcall(applyHeadless, char)
                -- restack fire on invisible head
                if State.skinFireHead then
                    pcall(applyFireHead, char)
                end
                -- force again after a tick (some games push face back)
                task.defer(function()
                    task.wait(0.05)
                    if LP.Character == char and State.skinHeadless then
                        pcall(applyHeadless, char)
                        pcall(_skinHideHeadVisibility, char)
                        if State.skinFireHead then
                            pcall(applyFireHead, char)
                        end
                    end
                end)
            elseif key == "none" or key == nil or key == "" then
                pcall(removeHeadless, char)
                -- only restore head mesh if fire is off OR we want visible head under fire
                if not State.skinFireHead then
                    _skinRestoreHeadVisibility(char)
                else
                    _skinRestoreHeadVisibility(char)
                    pcall(applyFireHead, char)
                end
            else
                pcall(removeHeadless, char)
                local item = _skinFindItem("Head", key)
                if item and item.assetId then
                    local off = item.offset or Vector3.new(0, 0, 0)
                    local rot = item.rot or Vector3.new(0, 0, 0)
                    local ok = _skinApplyCatalogAsset(char, item.assetId, "KyzDuelsSkin_Head", off, rot)
                    if ok then
                        _skinHideHeadVisibility(char)
                    else
                        _skinRestoreHeadVisibility(char)
                    end
                else
                    _skinRestoreHeadVisibility(char)
                end
            end

        elseif cat == "Hair" then
            _skinClearCategoryAccessories(char, "Hair")
            if key and key ~= "none" then
                local item = _skinFindItem("Hair", key)
                if item and item.assetId then
                    local off = item.offset or Vector3.new(0, 0, 0)
                    local rot = item.rot or Vector3.new(0, 0, 0)
                    local ok = _skinApplyCatalogAsset(char, item.assetId, "KyzDuelsSkin_Hair", off, rot)
                    if ok then
                        _skinSetOriginalHairVisible(char, false)
                    else
                        _skinSetOriginalHairVisible(char, true)
                    end
                end
            else
                -- None: show original hair again
                _skinSetOriginalHairVisible(char, true)
            end

        elseif cat == "Blouses" then
            if key and key ~= "none" then
                local item = _skinFindItem("Blouses", key)
                if item and item.shirt then
                    pcall(_skinApplyShirtPants, char, item.shirt, nil)
                elseif item and item.assetId then
                    _skinClearCategoryAccessories(char, "Blouses")
                    pcall(_skinApplyCatalogAsset, char, item.assetId, "KyzDuelsSkin_Blouses", item.offset or Vector3.zero, item.rot or Vector3.zero)
                end
            end

        elseif cat == "Pants" then
            if key and key ~= "none" then
                local item = _skinFindItem("Pants", key)
                if item and item.pants then
                    pcall(_skinApplyShirtPants, char, nil, item.pants)
                elseif item and item.assetId then
                    _skinClearCategoryAccessories(char, "Pants")
                    pcall(_skinApplyCatalogAsset, char, item.assetId, "KyzDuelsSkin_Pants", item.offset or Vector3.zero, item.rot or Vector3.zero)
                end
            end

        elseif cat == "Accessories" then
            -- multi flag passed as 3rd arg — allow stacking multiple accessories
            if not multi then
                _skinClearCategoryAccessories(char, "Accessories")
            end
            if key and key ~= "none" then
                local item = _skinFindItem("Accessories", key)
                if item and item.assetId then
                    local off = item.offset or Vector3.new(0, 0, 0)
                    local rot = item.rot or Vector3.new(0, 0, 0)
                    -- unique tag per accessory key so multiple can coexist
                    local uniqueTag = "KyzDuelsSkin_Accessories_" .. tostring(key)
                    pcall(_skinApplyCatalogAsset, char, item.assetId, uniqueTag, off, rot, item.attach)
                end
            end

        elseif cat == "Effects" then
            -- multi flag passed as 3rd arg
            if not multi then
                _skinClearCategoryAccessories(char, "Effects")
            end
            if key == "fireHead" then
                State.skinFireHead = true
                pcall(applyFireHead, char)
                -- keep headless if it was already on
                if State.skinHeadless then
                    pcall(applyHeadless, char)
                    pcall(_skinHideHeadVisibility, char)
                end
            elseif key == "korblox" then
                State.skinKorblox = true
                pcall(applyKorblox, char)
            elseif key == "none" or key == nil or key == "" then
                State.skinFireHead = false
                State.skinKorblox = false
                pcall(removeFireHead, char)
                pcall(removeKorblox, char)
                _skinClearCategoryAccessories(char, "Effects")
                -- restore headless visual if still wanted
                if State.skinHeadless then
                    pcall(applyHeadless, char)
                    pcall(_skinHideHeadVisibility, char)
                end
            else
                local item = _skinFindItem("Effects", key)
                if item and item.assetId then
                    local off = item.offset or Vector3.new(0, 0, 0)
                    local rot = item.rot or Vector3.new(0, 0, 0)
                    pcall(_skinApplyCatalogAsset, char, item.assetId, "KyzDuelsSkin_Effects", off, rot)
                end
            end
        end

        pcall(refreshPlayerViewport)
    end

    if not _G.__KyzDuelsSkinReapplyConn then
        _G.__KyzDuelsSkinReapplyConn = true
        LP.CharacterAdded:Connect(function(char)
            task.defer(function()
                for _, delaySec in ipairs({ 0.4, 1.0, 2.0 }) do
                    task.wait(delaySec)
                    if not char or not char.Parent then return end
                    pcall(function()
                        if _skinApplyAllPending then
                            _skinApplyAllPending()
                        elseif _skinGallery and _skinGallery.pending then
                            local multiCats = { Effects = true, Accessories = true }
                            for cat, val in pairs(_skinGallery.pending) do
                                if type(val) == "table" and multiCats[cat] then
                                    pcall(_skinApplyKey, cat, "none")
                                    for key, on in pairs(val) do
                                        if on and key ~= "none" then
                                            pcall(_skinApplyKey, cat, key, true)
                                        end
                                    end
                                elseif val and val ~= "none" then
                                    pcall(_skinApplyKey, cat, val)
                                end
                            end
                        end
                    end)
                end
            end)
        end)
    end

    function _skinSyncFromState()
        -- Only merge legacy bool skins; never wipe gallery pending/selected
        if not _skinGallery then return end
        if State.skinHeadless then
            _skinGallery.pending.Head = "headless"
            _skinGallery.selected.Head = "headless"
        end
        local fx = type(_skinGallery.pending.Effects) == "table" and _skinGallery.pending.Effects or {}
        if type(fx) ~= "table" then fx = {} end
        if State.skinFireHead then fx.fireHead = true; fx.none = nil end
        if State.skinKorblox then fx.korblox = true; fx.none = nil end
        if next(fx) ~= nil then
            _skinGallery.pending.Effects = fx
            _skinGallery.selected.Effects = fx
        end
        -- durable mirror for autosave
        State.skinGallery = {
            gender = _skinGallery.gender,
            pending = _skinGallery.pending,
            selected = _skinGallery.selected,
            byGender = _skinGallery.byGender,
        }
    end

    function _skinMirrorToState()
        if not _skinGallery then return end
        State.skinGallery = {
            gender = _skinGallery.gender,
            pending = _skinGallery.pending,
            selected = _skinGallery.selected,
            byGender = _skinGallery.byGender,
        }
    end

    function _skinApplyAllPending()
        pcall(_skinMirrorToState)
        -- Apply every category from pending
        -- Effects + Accessories support multi-select (table of keys)
        local order = { "Head", "Hair", "Blouses", "Pants", "Accessories", "Effects" }
        local multiCats = { Effects = true, Accessories = true }

        for _, cat in ipairs(order) do
            local val = _skinGallery.pending and _skinGallery.pending[cat]
            if val == nil then
                -- skip
            elseif multiCats[cat] and type(val) == "table" then
                _skinGallery.selected[cat] = val
                -- clear category first then apply all selected
                pcall(_skinApplyKey, cat, "none")
                for key, on in pairs(val) do
                    if on and key ~= "none" then
                        pcall(_skinApplyKey, cat, key, true) -- true = multi, don't clear others
                    end
                end
            else
                -- single select (Head/Hair/Blouses/Pants/Accessories)
                if type(val) == "table" then
                    -- migrate leftover multi format → pick first active
                    local first = "none"
                    for k, on in pairs(val) do
                        if on and k ~= "none" then first = k break end
                    end
                    if first == "none" then
                        for k, on in pairs(val) do
                            if on then first = k break end
                        end
                    end
                    val = first
                    _skinGallery.pending[cat] = val
                end
                _skinGallery.selected[cat] = val
                -- always apply, including "none" so category can clear cleanly
                pcall(_skinApplyKey, cat, val)
            end
        end
        -- final pass: headless + fire head stack cleanly
        if LP.Character then
            pcall(_skinResolveHeadAndFire, LP.Character)
        end
        pcall(refreshPlayerViewport)
        task.spawn(saveConfig)
    end


    function openSkinAddPanel(defaultCat)
        local cat0 = defaultCat or (_skinGallery and _skinGallery.activeCat) or "Accessories"
        local PlayerGui = LP:FindFirstChild("PlayerGui") or LP:WaitForChild("PlayerGui", 3)
        if not PlayerGui then return end
        pcall(function()
            local old = CoreGui:FindFirstChild("KyzDuelsSkinAddLayer")
            if old then old:Destroy() end
            local o2 = PlayerGui:FindFirstChild("KyzDuelsSkinAddLayer")
            if o2 then o2:Destroy() end
        end)

        local gui = Instance.new("ScreenGui")
        gui.Name = "KyzDuelsSkinAddLayer"
        gui.ResetOnSpawn = false
        gui.IgnoreGuiInset = true
        gui.DisplayOrder = 1005
        gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        pcall(parentGui, gui)
        if not gui.Parent then gui.Parent = PlayerGui end

        local overlay = Instance.new("TextButton")
        overlay.Size = UDim2.fromScale(1, 1)
        overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        overlay.BackgroundTransparency = 0.45
        overlay.Text = ""
        overlay.AutoButtonColor = false
        overlay.ZIndex = 100
        overlay.Parent = gui

        local panel = Instance.new("Frame")
        panel.AnchorPoint = Vector2.new(0.5, 0.5)
        panel.Position = UDim2.fromScale(0.5, 0.5)
        panel.Size = UDim2.fromOffset(isMobileDevice and 280 or 340, isMobileDevice and 250 or 280)
        panel.BackgroundColor3 = Color3.fromRGB(14, 14, 18)
        panel.BorderSizePixel = 0
        panel.ZIndex = 101
        panel.Parent = overlay
        Instance.new("UICorner", panel).CornerRadius = UDim.new(0, 14)
        local pst = Instance.new("UIStroke", panel)
        pst.Color = Color3.fromRGB(80, 80, 90)
        pst.Thickness = 1.2
        pst.Transparency = 0.35

        local title = Instance.new("TextLabel")
        title.Size = UDim2.new(1, -20, 0, 28)
        title.Position = UDim2.new(0, 10, 0, 12)
        title.BackgroundTransparency = 1
        title.Text = "ADD CUSTOM SKIN"
        title.TextColor3 = Color3.fromRGB(245, 245, 250)
        title.Font = Enum.Font.GothamBlack
        title.TextSize = isMobileDevice and 14 or 16
        title.ZIndex = 102
        title.Parent = panel

        local sub = Instance.new("TextLabel")
        sub.Size = UDim2.new(1, -20, 0, 18)
        sub.Position = UDim2.new(0, 10, 0, 40)
        sub.BackgroundTransparency = 1
        sub.Text = "Category: " .. tostring(cat0)
        sub.TextColor3 = Color3.fromRGB(140, 140, 155)
        sub.Font = Enum.Font.Gotham
        sub.TextSize = 11
        sub.TextXAlignment = Enum.TextXAlignment.Left
        sub.ZIndex = 102
        sub.Parent = panel

        local idBox = Instance.new("TextBox")
        idBox.Size = UDim2.new(1, -24, 0, isMobileDevice and 34 or 38)
        idBox.Position = UDim2.new(0, 12, 0, 64)
        idBox.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
        idBox.BorderSizePixel = 0
        idBox.Text = ""
        idBox.PlaceholderText = "Asset ID (ex: 123456789)"
        idBox.PlaceholderColor3 = Color3.fromRGB(100, 100, 110)
        idBox.TextColor3 = Color3.fromRGB(240, 240, 245)
        idBox.Font = Enum.Font.GothamBold
        idBox.TextSize = 13
        idBox.ClearTextOnFocus = false
        idBox.ZIndex = 102
        idBox.Parent = panel
        Instance.new("UICorner", idBox).CornerRadius = UDim.new(0, 8)
        local idPad = Instance.new("UIPadding", idBox)
        idPad.PaddingLeft = UDim.new(0, 10)

        local nameBox = Instance.new("TextBox")
        nameBox.Size = UDim2.new(1, -24, 0, isMobileDevice and 34 or 38)
        nameBox.Position = UDim2.new(0, 12, 0, isMobileDevice and 106 or 112)
        nameBox.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
        nameBox.BorderSizePixel = 0
        nameBox.Text = ""
        nameBox.PlaceholderText = "Name (optional)"
        nameBox.PlaceholderColor3 = Color3.fromRGB(100, 100, 110)
        nameBox.TextColor3 = Color3.fromRGB(240, 240, 245)
        nameBox.Font = Enum.Font.GothamMedium
        nameBox.TextSize = 13
        nameBox.ClearTextOnFocus = false
        nameBox.ZIndex = 102
        nameBox.Parent = panel
        Instance.new("UICorner", nameBox).CornerRadius = UDim.new(0, 8)
        local namePad = Instance.new("UIPadding", nameBox)
        namePad.PaddingLeft = UDim.new(0, 10)

        local status = Instance.new("TextLabel")
        status.Size = UDim2.new(1, -24, 0, 16)
        status.Position = UDim2.new(0, 12, 0, isMobileDevice and 146 or 156)
        status.BackgroundTransparency = 1
        status.Text = ""
        status.TextColor3 = Color3.fromRGB(255, 120, 120)
        status.Font = Enum.Font.Gotham
        status.TextSize = 11
        status.TextXAlignment = Enum.TextXAlignment.Left
        status.ZIndex = 102
        status.Parent = panel

        local confirm = Instance.new("TextButton")
        confirm.Size = UDim2.new(1, -24, 0, isMobileDevice and 34 or 38)
        confirm.Position = UDim2.new(0, 12, 1, isMobileDevice and -48 or -52)
        confirm.BackgroundColor3 = Color3.fromRGB(235, 235, 240)
        confirm.BorderSizePixel = 0
        confirm.Text = "CONFIRM"
        confirm.TextColor3 = Color3.fromRGB(18, 18, 22)
        confirm.Font = Enum.Font.GothamBlack
        confirm.TextSize = 13
        confirm.AutoButtonColor = false
        confirm.ZIndex = 102
        confirm.Parent = panel
        Instance.new("UICorner", confirm).CornerRadius = UDim.new(0, 9)

        local function closeAdd()
            pcall(function() gui:Destroy() end)
        end
        overlay.MouseButton1Click:Connect(closeAdd)

        confirm.MouseButton1Click:Connect(function()
            local raw = tostring(idBox.Text or ""):gsub("%s+", "")
            local id = tonumber(raw)
            if not id or id <= 0 then
                status.Text = "Invalid ID"
                status.TextColor3 = Color3.fromRGB(255, 120, 120)
                return
            end
            State.customSkins = State.customSkins or {}
            local key = "custom_" .. tostring(id)
            for _, it in ipairs(State.customSkins) do
                if tostring(it.key) == key and it.cat == cat0 then
                    status.Text = "Already added"
                    status.TextColor3 = Color3.fromRGB(255, 180, 80)
                    return
                end
            end
            local dispName = tostring(nameBox.Text or ""):gsub("^%s+", ""):gsub("%s+$", "")
            if dispName == "" then
                dispName = "ID " .. tostring(id)
            end
            local entry = {
                key = key,
                name = dispName,
                assetId = id,
                cat = cat0,
                gender = (cat0 == "Effects") and "All" or ((_skinGallery and _skinGallery.gender) or "Male"),
                image = "rbxthumb://type=Asset&id=" .. tostring(id) .. "&w=150&h=150",
            }
            table.insert(State.customSkins, entry)
            status.Text = "Added!"
            status.TextColor3 = Color3.fromRGB(120, 220, 140)
            task.spawn(saveConfig)
            -- refresh open gallery items if present
            pcall(function()
                local layer = CoreGui:FindFirstChild("KyzDuelsSkinGalleryLayer") or (PlayerGui and PlayerGui:FindFirstChild("KyzDuelsSkinGalleryLayer"))
                -- rebuild via pending flag
                if _G.__KyzDuelsRebuildSkinItems then
                    _G.__KyzDuelsRebuildSkinItems()
                end
            end)
            task.delay(0.35, closeAdd)
        end)
    end


    function openSkinGallery()
        -- prevent double open
        pcall(function()
            local old = CoreGui:FindFirstChild("KyzDuelsSkinGalleryLayer")
            if old then old:Destroy() end
        end)
        pcall(function()
            local pg = LP:FindFirstChild("PlayerGui")
            if pg then
                local o = pg:FindFirstChild("KyzDuelsSkinGalleryLayer")
                if o then o:Destroy() end
            end
        end)

        _skinSyncFromState()
        pcall(_skinPreloadAllImages)

        local selectedCat = _skinGallery.activeCat or "Head"
        local closing = false
        local cardRefs = {}
        local catBtnRefs = {}
        local heroTitle, heroSub, heroIcon, applyBtn, itemsList, itemsScroll

        local modalGui = Instance.new("ScreenGui")
        modalGui.Name = "KyzDuelsSkinGalleryLayer"
        modalGui.ResetOnSpawn = false
        modalGui.IgnoreGuiInset = true
        modalGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        modalGui.DisplayOrder = 999
        parentGui(modalGui)

        local blur = Instance.new("BlurEffect")
        blur.Name = "KyzDuelsSkinGalleryBlur"
        blur.Size = 0
        blur.Parent = Lighting

        local overlay = Instance.new("TextButton")
        overlay.Name = "Overlay"
        overlay.Size = UDim2.fromScale(1, 1)
        overlay.BackgroundColor3 = Color3.fromRGB(2, 3, 8)
        overlay.BackgroundTransparency = 1
        overlay.BorderSizePixel = 0
        overlay.Text = ""
        overlay.AutoButtonColor = false
        overlay.ZIndex = 100
        overlay.Parent = modalGui

        local popup = Instance.new("CanvasGroup")
        popup.Name = "Gallery"
        popup.AnchorPoint = Vector2.new(0.5, 0.5)
        popup.Position = UDim2.fromScale(0.5, 0.5)
        popup.Size = UDim2.fromOffset((isMobileDevice and 340) or 500, (isMobileDevice and 420) or 520)
        popup.BackgroundColor3 = Color3.fromRGB(10, 10, 14)
        popup.BackgroundTransparency = 0
        popup.BorderSizePixel = 0
        popup.ClipsDescendants = true
        popup.GroupTransparency = 1
        popup.Rotation = -2
        popup.ZIndex = 101
        popup.Parent = overlay
        Instance.new("UICorner", popup).CornerRadius = UDim.new(0, 18)
        local popupScale = Instance.new("UIScale", popup)
        popupScale.Scale = 0.92

        local function closeGallery()
            if closing then return end
            closing = true
            TweenService:Create(blur, TweenInfo.new(0.25), {Size = 0}):Play()
            TweenService:Create(overlay, TweenInfo.new(0.22), {BackgroundTransparency = 1}):Play()
            TweenService:Create(popup, TweenInfo.new(0.28, Enum.EasingStyle.Quint), {
                GroupTransparency = 1, Rotation = 2
            }):Play()
            TweenService:Create(popupScale, TweenInfo.new(0.28), {Scale = 0.9}):Play()
            task.delay(0.32, function()
                pcall(function() blur:Destroy() end)
                pcall(function() modalGui:Destroy() end)
            end)
        end

        -- TITLE
        local title = Instance.new("TextLabel")
        title.Size = UDim2.new(1, -24, 0, isMobileDevice and 22 or 28)
        title.Position = UDim2.new(0, isMobileDevice and 12 or 18, 0, isMobileDevice and 8 or 14)
        title.BackgroundTransparency = 1
        title.Text = isMobileDevice and "SKINS" or "KYZ DUELS SKINS PLAYER"
        title.TextColor3 = Color3.fromRGB(245, 245, 250)
        title.Font = Enum.Font.GothamBlack
        title.TextSize = isMobileDevice and 13 or 16
        title.TextXAlignment = Enum.TextXAlignment.Left
        title.ZIndex = 105
        title.Parent = popup

        -- LEFT content + RIGHT player preview
        local leftCol = Instance.new("Frame")
        leftCol.Name = "LeftCol"
        leftCol.Size = UDim2.new(1, isMobileDevice and -130 or -180, 1, isMobileDevice and -44 or -56)
        leftCol.Position = UDim2.new(0, isMobileDevice and 10 or 14, 0, isMobileDevice and 32 or 44)
        leftCol.ClipsDescendants = true
        leftCol.BackgroundTransparency = 1
        leftCol.ZIndex = 102
        leftCol.Parent = popup

        -- HERO
        local hero = Instance.new("Frame")
        hero.Name = "Hero"
        hero.Size = UDim2.new(1, 0, 0, isMobileDevice and 72 or 120)
        hero.Position = UDim2.new(0, 0, 0, 0)
        hero.BackgroundColor3 = Color3.fromRGB(6, 6, 10)
        hero.BorderSizePixel = 0
        hero.ZIndex = 103
        hero.Parent = leftCol
        Instance.new("UICorner", hero).CornerRadius = UDim.new(0, 14)
        local heroStroke = Instance.new("UIStroke", hero)
        heroStroke.Color = Color3.fromRGB(60, 60, 70)
        heroStroke.Thickness = 1.2
        heroStroke.Transparency = 0.4

        heroIcon = Instance.new("Frame")
        heroIcon.Name = "HeroIcon"
        heroIcon.Size = UDim2.fromOffset(isMobileDevice and 48 or 72, isMobileDevice and 48 or 72)
        heroIcon.Position = UDim2.new(0, isMobileDevice and 10 or 18, 0.5, isMobileDevice and -24 or -36)
        heroIcon.BackgroundColor3 = Color3.fromRGB(40, 40, 48)
        heroIcon.BorderSizePixel = 0
        heroIcon.ClipsDescendants = true
        heroIcon.ZIndex = 104
        heroIcon.Parent = hero
        Instance.new("UICorner", heroIcon).CornerRadius = UDim.new(0, 14)

        local heroImg = Instance.new("ImageLabel")
        heroImg.Name = "HeroImg"
        heroImg.Size = UDim2.fromScale(1, 1)
        heroImg.BackgroundTransparency = 1
        heroImg.Image = ""
        heroImg.ScaleType = Enum.ScaleType.Crop
        heroImg.ZIndex = 105
        heroImg.Parent = heroIcon
        Instance.new("UICorner", heroImg).CornerRadius = UDim.new(0, 14)

        heroTitle = Instance.new("TextLabel")
        heroTitle.Size = UDim2.new(1, -110, 0, 26)
        heroTitle.Position = UDim2.new(0, 106, 0.5, -24)
        heroTitle.BackgroundTransparency = 1
        heroTitle.Text = "NONE"
        heroTitle.TextColor3 = Color3.fromRGB(245, 245, 250)
        heroTitle.Font = Enum.Font.GothamBlack
        heroTitle.TextSize = 20
        heroTitle.TextXAlignment = Enum.TextXAlignment.Left
        heroTitle.ZIndex = 104
        heroTitle.Parent = hero

        heroSub = Instance.new("TextLabel")
        heroSub.Size = UDim2.new(1, -110, 0, 18)
        heroSub.Position = UDim2.new(0, 106, 0.5, 6)
        heroSub.BackgroundTransparency = 1
        heroSub.Text = "HEAD"
        heroSub.TextColor3 = Color3.fromRGB(140, 140, 150)
        heroSub.Font = Enum.Font.GothamMedium
        heroSub.TextSize = 12
        heroSub.TextXAlignment = Enum.TextXAlignment.Left
        heroSub.ZIndex = 104
        heroSub.Parent = hero

        -- ITEMS strip
        itemsScroll = Instance.new("ScrollingFrame")
        itemsScroll.Name = "ItemsStrip"
        itemsScroll.Size = UDim2.new(1, 0, 0, isMobileDevice and 78 or 92)
        itemsScroll.Position = UDim2.new(0, 0, 0, isMobileDevice and 80 or 130)
        itemsScroll.BackgroundTransparency = 1
        itemsScroll.BorderSizePixel = 0
        itemsScroll.ScrollBarThickness = 3
        itemsScroll.ScrollBarImageColor3 = Color3.fromRGB(120, 120, 130)
        itemsScroll.ScrollingDirection = Enum.ScrollingDirection.X
        itemsScroll.CanvasSize = UDim2.fromOffset(0, 0)
        itemsScroll.ZIndex = 103
        itemsScroll.Parent = leftCol

        itemsList = Instance.new("Frame")
        itemsList.Name = "ItemsList"
        itemsList.Size = UDim2.new(0, 0, 1, 0)
        itemsList.AutomaticSize = Enum.AutomaticSize.X
        itemsList.BackgroundTransparency = 1
        itemsList.Parent = itemsScroll

        local itemsLay = Instance.new("UIListLayout", itemsList)
        itemsLay.FillDirection = Enum.FillDirection.Horizontal
        itemsLay.SortOrder = Enum.SortOrder.LayoutOrder
        itemsLay.Padding = UDim.new(0, 10)
        itemsLay.VerticalAlignment = Enum.VerticalAlignment.Center

        local itemsPad = Instance.new("UIPadding", itemsList)
        itemsPad.PaddingLeft = UDim.new(0, 2)
        itemsPad.PaddingRight = UDim.new(0, 4)

        -- GENDER bar (Male / Female) — only affects Head, Hair, Blouses, Pants, Accessories
        local genderBar = Instance.new("Frame")
        genderBar.Name = "GenderBar"
        genderBar.Size = UDim2.new(1, 0, 0, isMobileDevice and 26 or 32)
        genderBar.Position = UDim2.new(0, 0, 0, isMobileDevice and 164 or 232)
        genderBar.BackgroundColor3 = Color3.fromRGB(14, 14, 18)
        genderBar.BorderSizePixel = 0
        genderBar.ZIndex = 103
        genderBar.Parent = leftCol
        Instance.new("UICorner", genderBar).CornerRadius = UDim.new(0, 10)

        local genderLay = Instance.new("UIListLayout", genderBar)
        genderLay.FillDirection = Enum.FillDirection.Horizontal
        genderLay.SortOrder = Enum.SortOrder.LayoutOrder
        genderLay.Padding = UDim.new(0, 6)
        genderLay.HorizontalAlignment = Enum.HorizontalAlignment.Center
        genderLay.VerticalAlignment = Enum.VerticalAlignment.Center

        local genderPad = Instance.new("UIPadding", genderBar)
        genderPad.PaddingLeft = UDim.new(0, 8)
        genderPad.PaddingRight = UDim.new(0, 8)

        local genderBtnRefs = {}
        -- setGender is defined later (after rebuildItems / refreshHero)

        for gi, gName in ipairs({ "Male", "Female" }) do
            local gbtn = Instance.new("TextButton")
            gbtn.Name = "Gender_" .. gName
            gbtn.Size = UDim2.new(0.5, -10, 0, 26)
            gbtn.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
            gbtn.BorderSizePixel = 0
            gbtn.Text = gName
            gbtn.TextColor3 = Color3.fromRGB(140, 140, 150)
            gbtn.Font = Enum.Font.GothamBold
            gbtn.TextSize = isMobileDevice and 10 or 12
            gbtn.AutoButtonColor = false
            gbtn.LayoutOrder = gi
            gbtn.ZIndex = 105
            gbtn.Parent = genderBar
            Instance.new("UICorner", gbtn).CornerRadius = UDim.new(0, 7)
            local gind = Instance.new("Frame")
            gind.Name = "ind"
            gind.Size = UDim2.new(1, -8, 0, 2)
            gind.Position = UDim2.new(0, 4, 1, -3)
            gind.BackgroundColor3 = Color3.fromRGB(245, 245, 250)
            gind.BackgroundTransparency = 1
            gind.BorderSizePixel = 0
            gind.ZIndex = 106
            gind.Parent = gbtn
            genderBtnRefs[gName] = gbtn
        end

        -- CATEGORY bar
        local catBar = Instance.new("Frame")
        catBar.Name = "CategoryBar"
        catBar.Size = UDim2.new(1, 0, 0, isMobileDevice and 34 or 36)
        catBar.Position = UDim2.new(0, 0, 0, isMobileDevice and 196 or 270)
        catBar.BackgroundColor3 = Color3.fromRGB(14, 14, 18)
        catBar.BorderSizePixel = 0
        catBar.ZIndex = 103
        catBar.ClipsDescendants = true
        catBar.Active = true
        catBar.Parent = leftCol
        Instance.new("UICorner", catBar).CornerRadius = UDim.new(0, 10)

        -- horizontal slider for Head / Hair / Blouses / Pants / Accessories / Effects
        local catScroll = Instance.new("ScrollingFrame")
        catScroll.Name = "CatScroll"
        catScroll.Size = UDim2.new(1, -4, 1, 0)
        catScroll.Position = UDim2.new(0, 2, 0, 0)
        catScroll.BackgroundTransparency = 1
        catScroll.BorderSizePixel = 0
        catScroll.ScrollBarThickness = isMobileDevice and 3 or 4
        catScroll.ScrollBarImageColor3 = Color3.fromRGB(200, 200, 210)
        catScroll.ScrollBarImageTransparency = 0.3
        catScroll.ScrollingDirection = Enum.ScrollingDirection.X
        catScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
        catScroll.AutomaticCanvasSize = Enum.AutomaticSize.X
        catScroll.ElasticBehavior = Enum.ElasticBehavior.Never
        catScroll.ScrollingEnabled = true
        catScroll.Active = true
        catScroll.Selectable = false
        catScroll.ClipsDescendants = true
        catScroll.ZIndex = 104
        catScroll.Parent = catBar

        local catLay = Instance.new("UIListLayout", catScroll)
        catLay.FillDirection = Enum.FillDirection.Horizontal
        catLay.SortOrder = Enum.SortOrder.LayoutOrder
        catLay.Padding = UDim.new(0, isMobileDevice and 4 or 4)
        catLay.HorizontalAlignment = Enum.HorizontalAlignment.Left
        catLay.VerticalAlignment = Enum.VerticalAlignment.Center

        local catPad = Instance.new("UIPadding", catScroll)
        catPad.PaddingLeft = UDim.new(0, isMobileDevice and 4 or 6)
        catPad.PaddingRight = UDim.new(0, isMobileDevice and 8 or 6)
        catPad.PaddingTop = UDim.new(0, 2)
        catPad.PaddingBottom = UDim.new(0, 2)

        -- APPLY button
        applyBtn = Instance.new("TextButton")
        applyBtn.Name = "ApplyBtn"
        applyBtn.Size = UDim2.new(1, 0, 0, isMobileDevice and 32 or 42)
        applyBtn.Position = UDim2.new(0, 0, 1, isMobileDevice and -36 or -48)
        applyBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 34)
        applyBtn.BorderSizePixel = 0
        applyBtn.Text = "CLOSE"
        applyBtn.TextColor3 = Color3.fromRGB(235, 235, 240)
        applyBtn.Font = Enum.Font.GothamBold
        applyBtn.TextSize = 13
        applyBtn.AutoButtonColor = false
        applyBtn.ZIndex = 104
        applyBtn.Parent = leftCol
        Instance.new("UICorner", applyBtn).CornerRadius = UDim.new(0, 10)
        local applyStroke = Instance.new("UIStroke", applyBtn)
        applyStroke.Color = Color3.fromRGB(80, 80, 90)
        applyStroke.Thickness = 1.2
        applyStroke.Transparency = 0.4
        local applyScale = Instance.new("UIScale", applyBtn)

        -- RIGHT: player preview panel
        local rightCol = Instance.new("Frame")
        rightCol.Name = "PlayerPreview"
        rightCol.Size = UDim2.new(0, isMobileDevice and 112 or 160, 1, isMobileDevice and -24 or -28)
        rightCol.Position = UDim2.new(1, isMobileDevice and -120 or -172, 0, isMobileDevice and 12 or 14)
        rightCol.BackgroundColor3 = Color3.fromRGB(8, 8, 12)
        rightCol.BorderSizePixel = 0
        rightCol.ZIndex = 103
        rightCol.ClipsDescendants = true
        rightCol.Parent = popup
        Instance.new("UICorner", rightCol).CornerRadius = UDim.new(0, 14)
        local rpStroke = Instance.new("UIStroke", rightCol)
        rpStroke.Color = Color3.fromRGB(60, 60, 70)
        rpStroke.Thickness = 1
        rpStroke.Transparency = 0.45

        local rpTitle = Instance.new("TextLabel")
        rpTitle.Size = UDim2.new(1, -8, 0, 18)
        rpTitle.Position = UDim2.new(0, 4, 0, 6)
        rpTitle.BackgroundTransparency = 1
        rpTitle.Text = "PLAYER"
        rpTitle.TextColor3 = Color3.fromRGB(200, 200, 210)
        rpTitle.Font = Enum.Font.GothamBlack
        rpTitle.TextSize = 11
        rpTitle.ZIndex = 104
        rpTitle.Parent = rightCol

        local vp = Instance.new("ViewportFrame")
        vp.Name = "SkinGalleryViewport"
        vp.Size = UDim2.new(1, -10, 1, -28)
        vp.Position = UDim2.new(0, 5, 0, 24)
        vp.BackgroundColor3 = Color3.fromRGB(6, 6, 8)
        vp.BorderSizePixel = 0
        vp.ZIndex = 104
        vp.Ambient = Color3.fromRGB(200, 200, 205)
        vp.LightColor = Color3.fromRGB(255, 255, 255)
        vp.LightDirection = Vector3.new(-0.4, -1, -0.5)
        vp.Parent = rightCol
        Instance.new("UICorner", vp).CornerRadius = UDim.new(0, 10)

        local function refreshModalViewport()
            pcall(function()
                local world = vp:FindFirstChild("WorldModel")
                if world then
                    for _, ch in ipairs(world:GetChildren()) do
                        pcall(function() ch:Destroy() end)
                    end
                else
                    world = Instance.new("WorldModel")
                    world.Parent = vp
                end
                local oldCam = vp:FindFirstChildOfClass("Camera")
                if oldCam then pcall(function() oldCam:Destroy() end) end

                local char = LP.Character
                if not char then return end

                local archRestore = {}
                pcall(function()
                    char.Archivable = true
                    for _, d in ipairs(char:GetDescendants()) do
                        local okA, was = pcall(function() return d.Archivable end)
                        if okA then
                            archRestore[d] = was
                            pcall(function() d.Archivable = true end)
                        end
                    end
                end)

                local ok, clone = pcall(function() return char:Clone() end)

                pcall(function()
                    char.Archivable = false
                    for d, was in pairs(archRestore) do
                        pcall(function() if d and d.Parent then d.Archivable = was end end)
                    end
                end)

                if not ok or not clone then return end

                for _, d in ipairs(clone:GetDescendants()) do
                    if d:IsA("Script") or d:IsA("LocalScript") or d:IsA("ModuleScript") then
                        pcall(function() d:Destroy() end)
                    elseif d:IsA("BasePart") then
                        pcall(function()
                            d.Anchored = true
                            d.CanCollide = false
                            -- keep Transparency / LocalTransparencyModifier from live char
                            -- (headless needs LTM=1 on Head)
                        end)
                    end
                end

                -- force headless / fire state on clone to match State (clone can miss Fire/LTM)
                pcall(function()
                    local cHead = clone:FindFirstChild("Head")
                    if not cHead then return end
                    if State and State.skinHeadless then
                        cHead.Transparency = 1
                        cHead.LocalTransparencyModifier = 1
                        for _, desc in ipairs(cHead:GetDescendants()) do
                            if desc:IsA("Decal") or desc:IsA("Texture") then
                                pcall(function() desc.Transparency = 1 end)
                            elseif desc:IsA("SpecialMesh") then
                                pcall(function() desc.Scale = Vector3.new(0, 0, 0) end)
                            end
                        end
                        -- hide non-kyzDuels accessories on clone
                        for _, ch in ipairs(clone:GetChildren()) do
                            if ch:IsA("Accessory") or ch:IsA("Hat") then
                                local tag = nil
                                pcall(function() tag = ch:GetAttribute("_KyzDuelsSkinTag") end)
                                local name = tostring(ch.Name or "")
                                if not (tag or name:find("KyzDuelsSkin_", 1, true)) then
                                    for _, d in ipairs(ch:GetDescendants()) do
                                        if d:IsA("BasePart") then
                                            pcall(function()
                                                d.Transparency = 1
                                                d.LocalTransparencyModifier = 1
                                            end)
                                        elseif d:IsA("Decal") or d:IsA("Texture") then
                                            pcall(function() d.Transparency = 1 end)
                                        end
                                    end
                                end
                            end
                        end
                    end
                end)

                local hum = clone:FindFirstChildOfClass("Humanoid")
                if hum then
                    pcall(function()
                        hum.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
                        hum.HealthDisplayType = Enum.HumanoidHealthDisplayType.AlwaysOff
                    end)
                end
                clone.Parent = world

                -- Fire Head often missing in ViewportFrame clone → re-create on clone
                pcall(function()
                    local wantFire = (State and State.skinFireHead) or false
                    local srcHead = char:FindFirstChild("Head")
                    if srcHead and srcHead:FindFirstChild("Custom_HeadFire") then
                        wantFire = true
                    end
                    if wantFire then
                        local cHead = clone:FindFirstChild("Head")
                        if cHead then
                            for _, n in ipairs({"Custom_HeadFire", "Custom_HeadFireAtt", "Custom_HeadFireParticles"}) do
                                local o = cHead:FindFirstChild(n, true)
                                if o then pcall(function() o:Destroy() end) end
                            end
                            local fire = Instance.new("Fire")
                            fire.Name = "Custom_HeadFire"
                            fire.Size = 14
                            fire.Heat = 18
                            fire.Color = Color3.fromRGB(255, 90, 0)
                            fire.SecondaryColor = Color3.fromRGB(255, 200, 40)
                            fire.Enabled = true
                            fire.Parent = cHead
                            local att = Instance.new("Attachment")
                            att.Name = "Custom_HeadFireAtt"
                            att.Parent = cHead
                            local pe = Instance.new("ParticleEmitter")
                            pe.Name = "Custom_HeadFireParticles"
                            pe.Texture = "rbxasset://textures/particles/fire_main.dds"
                            pe.Color = ColorSequence.new({
                                ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 220, 60)),
                                ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 40, 0)),
                            })
                            pe.Size = NumberSequence.new({
                                NumberSequenceKeypoint.new(0, 1.8),
                                NumberSequenceKeypoint.new(1, 0.3),
                            })
                            pe.Transparency = NumberSequence.new({
                                NumberSequenceKeypoint.new(0, 0.05),
                                NumberSequenceKeypoint.new(1, 1),
                            })
                            pe.Lifetime = NumberSequence.new(0.2)
                            pe.Speed = NumberRange.new(3, 7)
                            pe.SpreadAngle = Vector2.new(30, 30)
                            pe.Acceleration = Vector3.new(0, 8, 0)
                            pe.Rate = 70
                            pe.LightEmission = 1
                            pe.LightInfluence = 0
                            pe.Enabled = true
                            pe.Parent = att
                        end
                    end
                end)

                pcall(function()
                    local hrp = clone:FindFirstChild("HumanoidRootPart") or clone:FindFirstChild("UpperTorso")
                    if hrp then
                        local yaw = CFrame.Angles(0, math.rad(180), 0)
                        local relative = hrp.CFrame:ToObjectSpace(clone:GetPivot())
                        clone:PivotTo(yaw * relative)
                        hrp = clone:FindFirstChild("HumanoidRootPart") or clone:FindFirstChild("UpperTorso")
                        if hrp then
                            local p = hrp.Position
                            clone:PivotTo(clone:GetPivot() - Vector3.new(p.X, p.Y, p.Z))
                        end
                    end
                    if clone.ScaleTo then
                        clone:ScaleTo(0.7)
                    end
                end)

                local focusY = 1.05
                pcall(function()
                    local hrp = clone:FindFirstChild("HumanoidRootPart")
                    local head = clone:FindFirstChild("Head")
                    if head and hrp then
                        focusY = hrp.Position.Y * 0.55 + head.Position.Y * 0.45
                    elseif head then
                        focusY = head.Position.Y - 0.85
                    elseif hrp then
                        focusY = hrp.Position.Y + 0.9
                    end
                end)

                local cam = Instance.new("Camera")
                cam.FieldOfView = isMobileDevice and 32 or 28
                cam.Parent = vp
                vp.CurrentCamera = cam
                cam.CFrame = CFrame.new(Vector3.new(0, focusY, isMobileDevice and 8.2 or 9.5), Vector3.new(0, focusY, 0))
            end)
        end

        local function getItem(cat, key)
            local list = _getSkinItemList(cat)
            for _, it in ipairs(list) do
                if it.key == key then return it end
            end
            return list[1]
        end

        local lastHeroKey = nil -- last clicked item key for hero display

        local function refreshHero(forceKey)
            local cat = selectedCat
            local pending = _skinGallery.pending[cat]
            local key = forceKey or lastHeroKey

            -- resolve key from pending (string or multi table)
            if key == nil then
                if type(pending) == "table" then
                    -- prefer last non-none active
                    for k, on in pairs(pending) do
                        if on and k ~= "none" then key = k break end
                    end
                    if key == nil then key = "none" end
                else
                    key = pending or "none"
                end
            end

            local item = getItem(cat, key)
            if heroTitle then
                heroTitle.Text = (item and item.name or "None"):upper()
            end
            if heroSub then
                heroSub.Text = tostring(cat or ""):upper()
            end
            if heroIcon then
                heroIcon.BackgroundColor3 = (item and item.color) or Color3.fromRGB(40, 40, 48)
                local img = heroIcon:FindFirstChild("HeroImg")
                if img then
                    local src = item and _skinResolveImage(item) or ""
                    if src ~= "" then
                        img.Image = src
                        img.Visible = true
                    else
                        -- fallback: solid color block still shows selection
                        img.Image = ""
                        img.Visible = false
                    end
                end
            end
            lastHeroKey = key
        end

        local function rebuildItems()
            for _, ch in ipairs(itemsList:GetChildren()) do
                if not ch:IsA("UIListLayout") and not ch:IsA("UIPadding") then
                    pcall(function() ch:Destroy() end)
                end
            end
            table.clear(cardRefs)

            local items = _getSkinItemList(selectedCat)
            local pendingKey = _skinGallery.pending[selectedCat] or "none"

            -- + ADD card (first, in front of None)
            do
                local addCard = Instance.new("TextButton")
                addCard.Name = "SkinCard_Add"
                addCard.Size = UDim2.fromOffset(isMobileDevice and 64 or 78, isMobileDevice and 64 or 78)
                addCard.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
                addCard.BorderSizePixel = 0
                addCard.Text = ""
                addCard.AutoButtonColor = false
                addCard.LayoutOrder = 0
                addCard.ZIndex = 105
                addCard.Parent = itemsList
                Instance.new("UICorner", addCard).CornerRadius = UDim.new(0, 12)
                local addStroke = Instance.new("UIStroke", addCard)
                addStroke.Color = Color3.fromRGB(90, 90, 105)
                addStroke.Thickness = 1.4
                addStroke.Transparency = 0.35
                local plus = Instance.new("TextLabel")
                plus.Size = UDim2.new(1, 0, 1, -18)
                plus.Position = UDim2.new(0, 0, 0, 2)
                plus.BackgroundTransparency = 1
                plus.Text = "+"
                plus.TextColor3 = Color3.fromRGB(230, 230, 240)
                plus.Font = Enum.Font.GothamBlack
                plus.TextSize = isMobileDevice and 28 or 34
                plus.ZIndex = 106
                plus.Parent = addCard
                local plusLbl = Instance.new("TextLabel")
                plusLbl.Size = UDim2.new(1, -4, 0, 16)
                plusLbl.Position = UDim2.new(0, 2, 1, -18)
                plusLbl.BackgroundTransparency = 1
                plusLbl.Text = "Add"
                plusLbl.TextColor3 = Color3.fromRGB(180, 180, 195)
                plusLbl.Font = Enum.Font.GothamBold
                plusLbl.TextSize = 10
                plusLbl.ZIndex = 106
                plusLbl.Parent = addCard
                addCard.MouseButton1Click:Connect(function()
                    pcall(openSkinAddPanel, selectedCat)
                end)
            end

            for i, item in ipairs(items) do
                local card = Instance.new("TextButton")
                card.Name = "SkinCard_" .. item.key
                card.Size = UDim2.fromOffset(isMobileDevice and 64 or 78, isMobileDevice and 64 or 78)
                card.BackgroundColor3 = Color3.fromRGB(16, 16, 20)
                card.BorderSizePixel = 0
                card.Text = ""
                card.AutoButtonColor = false
                card.LayoutOrder = i + 1
                card.ZIndex = 105
                card.Parent = itemsList
                Instance.new("UICorner", card).CornerRadius = UDim.new(0, 12)

                local stroke = Instance.new("UIStroke", card)
                stroke.Color = Color3.fromRGB(55, 55, 65)
                stroke.Thickness = 1.5
                stroke.Transparency = 0.5

                local icon = Instance.new("Frame")
                icon.Size = UDim2.new(1, -14, 1, -30)
                icon.Position = UDim2.new(0, 7, 0, 6)
                icon.BackgroundColor3 = item.color or Color3.fromRGB(40, 40, 48)
                icon.BorderSizePixel = 0
                icon.ClipsDescendants = true
                icon.ZIndex = 106
                icon.Parent = card
                Instance.new("UICorner", icon).CornerRadius = UDim.new(0, 9)

                local thumbSrc = _skinResolveImage(item)
                if thumbSrc ~= "" then
                    local img = Instance.new("ImageLabel")
                    img.Name = "Thumb"
                    img.Size = UDim2.fromScale(1, 1)
                    img.BackgroundTransparency = 1
                    img.Image = thumbSrc
                    img.ScaleType = Enum.ScaleType.Crop
                    img.ZIndex = 107
                    img.Parent = icon
                    Instance.new("UICorner", img).CornerRadius = UDim.new(0, 9)
                    -- if still downloading, refresh once resolved
                    if item.url and (_skinImageCache[item.url] == item.url or not _skinImageCache[item.url]) then
                        task.spawn(function()
                            task.wait(0.35)
                            local again = _skinResolveImage(item)
                            if img and img.Parent and again ~= "" then
                                img.Image = again
                            end
                        end)
                    end
                end

                local lbl = Instance.new("TextLabel")
                lbl.Size = UDim2.new(1, -4, 0, 16)
                lbl.Position = UDim2.new(0, 2, 1, -18)
                lbl.BackgroundTransparency = 1
                lbl.Text = item.name
                lbl.TextColor3 = Color3.fromRGB(220, 220, 230)
                lbl.Font = Enum.Font.GothamBold
                lbl.TextSize = 10
                lbl.TextTruncate = Enum.TextTruncate.AtEnd
                lbl.ZIndex = 106
                lbl.Parent = card

                -- trash on custom skins (top-right)
                if item.custom then
                    local trash = Instance.new("TextButton")
                    trash.Name = "TrashBtn"
                    trash.Size = UDim2.fromOffset(18, 18)
                    trash.Position = UDim2.new(1, -20, 0, 2)
                    trash.BackgroundColor3 = Color3.fromRGB(28, 12, 14)
                    trash.BackgroundTransparency = 0.15
                    trash.BorderSizePixel = 0
                    trash.Text = "🗑"
                    trash.TextSize = 11
                    trash.TextColor3 = Color3.fromRGB(255, 120, 120)
                    trash.Font = Enum.Font.GothamBold
                    trash.AutoButtonColor = false
                    trash.ZIndex = 110
                    trash.Parent = card
                    Instance.new("UICorner", trash).CornerRadius = UDim.new(0, 5)
                    trash.MouseButton1Click:Connect(function()
                        State.customSkins = State.customSkins or {}
                        local key = tostring(item.key)
                        local cat = selectedCat
                        for idx = #State.customSkins, 1, -1 do
                            local it = State.customSkins[idx]
                            if type(it) == "table" and tostring(it.key) == key and it.cat == cat then
                                table.remove(State.customSkins, idx)
                            end
                        end
                        -- clear pending if this was selected
                        local pend = _skinGallery.pending[cat]
                        if type(pend) == "string" and pend == key then
                            _skinGallery.pending[cat] = "none"
                        elseif type(pend) == "table" then
                            pend[key] = nil
                        end
                        task.spawn(saveConfig)
                        pcall(_skinApplyAllPending)
                        rebuildItems()
                        refreshHero()
                    end)
                end

                local isActive = false
                if type(pendingKey) == "table" then
                    isActive = pendingKey[item.key] == true
                else
                    isActive = (item.key == pendingKey)
                end
                if isActive then
                    stroke.Color = Color3.fromRGB(230, 230, 240)
                    stroke.Transparency = 0.08
                    card.BackgroundColor3 = Color3.fromRGB(28, 28, 34)
                end

                card.MouseButton1Click:Connect(function()
                    -- Effects + Accessories = multi-select (toggle)
                    -- other categories = single select
                    local multiCats = { Effects = true, Accessories = true }
                    if multiCats[selectedCat] then
                        local cur = _skinGallery.pending[selectedCat]
                        if type(cur) ~= "table" then
                            cur = {}
                            if type(_skinGallery.pending[selectedCat]) == "string"
                                and _skinGallery.pending[selectedCat] ~= "none" then
                                cur[_skinGallery.pending[selectedCat]] = true
                            end
                        end
                        if item.key == "none" then
                            cur = { none = true }
                        else
                            cur["none"] = nil
                            if cur[item.key] then
                                cur[item.key] = nil
                            else
                                cur[item.key] = true
                            end
                            -- if nothing left, set none
                            local any = false
                            for k, v in pairs(cur) do
                                if v and k ~= "none" then any = true break end
                            end
                            if not any then cur = { none = true } end
                        end
                        _skinGallery.pending[selectedCat] = cur
                    else
                        _skinGallery.pending[selectedCat] = item.key
                        if SKIN_GENDER_CATS[selectedCat] then
                            local g = _skinGallery.gender or "Male"
                            if not _skinGallery.byGender[g] then
                                _skinGallery.byGender[g] = {}
                            end
                            _skinGallery.byGender[g][selectedCat] = item.key
                        end
                    end
                    -- apply immediately on click, then refresh preview after character updates
                    lastHeroKey = item.key
                    pcall(_skinApplyAllPending)
                    pcall(autoSave)
                    task.defer(function()
                        task.wait(0.08)
                        pcall(refreshModalViewport)
                    end)
                    refreshHero(item.key)
                    rebuildItems()
                end)

                cardRefs[item.key] = { card = card, stroke = stroke }
            end

            local n = #items
            local cw = isMobileDevice and 72 or 88
            itemsScroll.CanvasSize = UDim2.fromOffset(math.max((n + 1) * cw + 10, 0), 0)
            _G.__KyzDuelsRebuildSkinItems = rebuildItems
        end

        local function setCategory(cat)
            selectedCat = cat
            _skinGallery.activeCat = cat
            for name, btn in pairs(catBtnRefs) do
                local active = (name == cat)
                btn.BackgroundColor3 = active and Color3.fromRGB(50, 50, 58) or Color3.fromRGB(22, 22, 28)
                btn.TextColor3 = active and Color3.fromRGB(245, 245, 250) or Color3.fromRGB(140, 140, 150)
                local ind = btn:FindFirstChild("ind")
                if ind then ind.BackgroundTransparency = active and 0.05 or 1 end
            end
            refreshHero()
            rebuildItems()
        end

        local function setGender(g)
            if g ~= "Male" and g ~= "Female" then return end
            _skinGallery.gender = g
            local bag = _skinGallery.byGender[g] or {}
            for catName, _ in pairs(SKIN_GENDER_CATS) do
                local k = bag[catName] or "none"
                _skinGallery.pending[catName] = k
            end
            for name, btn in pairs(genderBtnRefs) do
                local active = (name == g)
                btn.BackgroundColor3 = active and Color3.fromRGB(55, 55, 65) or Color3.fromRGB(22, 22, 28)
                btn.TextColor3 = active and Color3.fromRGB(245, 245, 250) or Color3.fromRGB(140, 140, 150)
                local ind = btn:FindFirstChild("ind")
                if ind then ind.BackgroundTransparency = active and 0.05 or 1 end
            end
            refreshHero()
            rebuildItems()
            task.defer(refreshModalViewport)
            pcall(autoSave)
        end

        for gName, gbtn in pairs(genderBtnRefs) do
            gbtn.MouseButton1Click:Connect(function()
                setGender(gName)
            end)
        end

        for i, catName in ipairs(SKIN_CAT_ORDER) do
            local btn = Instance.new("TextButton")
            btn.Name = "Cat_" .. catName
            btn.Size = UDim2.new(0, 0, 0, isMobileDevice and 28 or 28)
            btn.AutomaticSize = Enum.AutomaticSize.X
            btn.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
            btn.BorderSizePixel = 0
            btn.Text = catName
            btn.TextColor3 = Color3.fromRGB(140, 140, 150)
            btn.Font = Enum.Font.GothamBold
            btn.TextSize = isMobileDevice and 11 or 11
            btn.AutoButtonColor = false
            btn.Active = true
            btn.Selectable = true
            btn.LayoutOrder = i
            btn.ZIndex = 106
            btn.Parent = catScroll
            Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 7)
            local pad = Instance.new("UIPadding", btn)
            pad.PaddingLeft = UDim.new(0, isMobileDevice and 10 or 10)
            pad.PaddingRight = UDim.new(0, isMobileDevice and 10 or 10)

            local ind = Instance.new("Frame")
            ind.Name = "ind"
            ind.Size = UDim2.new(1, -6, 0, 2)
            ind.Position = UDim2.new(0, 3, 1, -3)
            ind.BackgroundColor3 = Color3.fromRGB(245, 245, 250)
            ind.BackgroundTransparency = 1
            ind.BorderSizePixel = 0
            ind.ZIndex = 107
            ind.Parent = btn

            local function onCat()
                setCategory(catName)
            end
            btn.MouseButton1Click:Connect(onCat)
            btn.Activated:Connect(onCat)
            if isMobileDevice then
                local touchStart = nil
                btn.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.Touch
                        or input.UserInputType == Enum.UserInputType.MouseButton1 then
                        touchStart = input.Position
                    end
                end)
                btn.InputEnded:Connect(function(input)
                    if not touchStart then return end
                    if input.UserInputType == Enum.UserInputType.Touch
                        or input.UserInputType == Enum.UserInputType.MouseButton1 then
                        local delta = (input.Position - touchStart).Magnitude
                        touchStart = nil
                        if delta < 18 then onCat() end
                    end
                end)
            end
            catBtnRefs[catName] = btn
        end

        -- keep selected category visible in the slider
        task.defer(function()
            local activeBtn = catBtnRefs[selectedCat]
            if activeBtn and catScroll then
                pcall(function()
                    local x = math.max(0, activeBtn.AbsolutePosition.X - catScroll.AbsolutePosition.X - 20)
                    catScroll.CanvasPosition = Vector2.new(x, 0)
                end)
            end
        end)

        applyBtn.MouseEnter:Connect(function()
            TweenService:Create(applyScale, TweenInfo.new(0.12), {Scale = 1.03}):Play()
            TweenService:Create(applyBtn, TweenInfo.new(0.12), {BackgroundColor3 = Color3.fromRGB(40, 40, 48)}):Play()
        end)
        applyBtn.MouseLeave:Connect(function()
            TweenService:Create(applyScale, TweenInfo.new(0.12), {Scale = 1}):Play()
            TweenService:Create(applyBtn, TweenInfo.new(0.12), {BackgroundColor3 = Color3.fromRGB(28, 28, 34)}):Play()
        end)
        applyBtn.MouseButton1Click:Connect(function()
            pcall(autoSave or saveConfig)
            pcall(closeGallery)
        end)

        overlay.MouseButton1Click:Connect(function()
            pcall(autoSave or saveConfig)
            pcall(closeGallery)
        end)

        setCategory(selectedCat)
        setGender(_skinGallery.gender or "Male")
        task.defer(refreshModalViewport)
        task.delay(0.15, refreshModalViewport)

        -- open anim
        TweenService:Create(blur, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {Size = 12}):Play()
        TweenService:Create(overlay, TweenInfo.new(0.28), {BackgroundTransparency = 0.35}):Play()
        TweenService:Create(popup, TweenInfo.new(0.4, Enum.EasingStyle.Back), {
            GroupTransparency = 0, Rotation = 0
        }):Play()
        TweenService:Create(popupScale, TweenInfo.new(0.4, Enum.EasingStyle.Back), {Scale = 1}):Play()
    end

    function setupPlayerVisualTab()
        ensureCharPreviewPanel() -- cleans up old side preview if any

        makeSectionHeader("SKINS PLAYER", tabPVis)

        local skinRow = Instance.new("Frame", tabPVis)
        skinRow.Name = "SkinsPlayerRow"
        skinRow.Size = UDim2.new(1, 0, 0, 56)
        skinRow.BackgroundColor3 = C.row
        skinRow.BackgroundTransparency = 0.72
        skinRow.BorderSizePixel = 0
        skinRow.LayoutOrder = LO()
        skinRow.ZIndex = 7
        mkCorner(skinRow, 10)
        mkStroke(skinRow, C.divider, 1)

        local openBtn = Instance.new("TextButton", skinRow)
        openBtn.Name = "OpenSkinGallery"
        openBtn.Size = UDim2.new(1, -20, 0, 40)
        openBtn.Position = UDim2.new(0, 10, 0.5, -20)
        openBtn.BackgroundColor3 = C.row
        openBtn.BackgroundTransparency = 0.15
        openBtn.BorderSizePixel = 0
        openBtn.Text = "SKINS PLAYER"
        openBtn.TextColor3 = C.text
        openBtn.Font = Enum.Font.GothamBold
        openBtn.TextSize = 13
        openBtn.AutoButtonColor = false
        openBtn.ZIndex = 12
        mkCorner(openBtn, 8)
        local gStroke = mkStroke(openBtn, C.divider, 1)
        gStroke.Transparency = 0.55

        openBtn.MouseEnter:Connect(function()
            tw(openBtn, {BackgroundColor3 = C.cardHov, BackgroundTransparency = 0.05})
            tw(gStroke, {Color = C.border, Transparency = 0.35})
        end)
        openBtn.MouseLeave:Connect(function()
            tw(openBtn, {BackgroundColor3 = C.row, BackgroundTransparency = 0.15})
            tw(gStroke, {Color = C.divider, Transparency = 0.55})
        end)
        openBtn.MouseButton1Click:Connect(function()
            pcall(openSkinGallery)
        end)

        -- keep toggleRefs for config sync compatibility
        toggleRefs.skinHeadless = toggleRefs.skinHeadless or function() end
        toggleRefs.skinFireHead = toggleRefs.skinFireHead or function() end
        toggleRefs.skinHornWhite = toggleRefs.skinHornWhite or function() end
        toggleRefs.skinKorblox = toggleRefs.skinKorblox or function() end
    end


    function setupMobileOptionsTab()
        if not tabMobile then return end
        loCount = 0
        makeSectionHeader("MOBILE OPTIONS", tabMobile)

        if makeToggleRow then
            toggleRefs.mobileButtons = makeToggleRow("Mobile Buttons", not (State and State.hideMobileButtons), function(on, isSync)
                State.hideMobileButtons = not on
                if on then
                    pcall(function()
                        if buildKyzDuelsMobileButtons then buildKyzDuelsMobileButtons()
                        elseif MobileAPI and MobileAPI.build then MobileAPI.build() end
                    end)
                else
                    pcall(function()
                        if destroyKyzDuelsMobileButtons then destroyKyzDuelsMobileButtons()
                        elseif MobileAPI and MobileAPI.destroy then MobileAPI.destroy() end
                    end)
                end
                if not isSync then task.spawn(saveConfig) end
            end, nil, tabMobile)

            toggleRefs.lockMobileButtons = makeToggleRow("Lock Mobile Buttons", State and State.lockMobileButtons, function(on, isSync)
                State.lockMobileButtons = on and true or false
                if not isSync then task.spawn(saveConfig) end
            end, nil, tabMobile)
        end

        -- Button Size Slider
        do
            local row = Instance.new("Frame", tabMobile)
            row.Size = UDim2.new(1, 0, 0, 52)
            row.BackgroundColor3 = C.row
            row.BackgroundTransparency = 0.4
            row.BorderSizePixel = 0
            row.LayoutOrder = LO()
            row.ZIndex = 7
            if mkCorner then mkCorner(row, 10) end
            if mkStroke then mkStroke(row, C.border or Color3.fromRGB(60,60,70), 1, 0.82) end

            local title = Instance.new("TextLabel", row)
            title.Size = UDim2.new(0.55, 0, 0, 16)
            title.Position = UDim2.new(0, 10, 0, 6)
            title.BackgroundTransparency = 1
            title.Text = "Button Size"
            title.TextColor3 = C.text or Color3.fromRGB(230,230,240)
            title.Font = Enum.Font.GothamBold
            title.TextSize = 11
            title.TextXAlignment = Enum.TextXAlignment.Left
            title.ZIndex = 8

            local valLbl = Instance.new("TextLabel", row)
            valLbl.Size = UDim2.new(0, 40, 0, 16)
            valLbl.Position = UDim2.new(1, -48, 0, 6)
            valLbl.BackgroundTransparency = 1
            valLbl.Text = tostring(math.floor((State and State.mobileButtonSize) or 56))
            valLbl.TextColor3 = Color3.fromRGB(255,255,255)
            valLbl.Font = Enum.Font.GothamBold
            valLbl.TextSize = 12
            valLbl.TextXAlignment = Enum.TextXAlignment.Right
            valLbl.ZIndex = 8

            local track = Instance.new("Frame", row)
            track.Size = UDim2.new(1, -24, 0, 8)
            track.Position = UDim2.new(0, 12, 0, 32)
            track.BackgroundColor3 = Color3.fromRGB(40, 40, 48)
            track.BorderSizePixel = 0
            track.ZIndex = 8
            if mkCorner then mkCorner(track, 4) end

            local fill = Instance.new("Frame", track)
            fill.Size = UDim2.new(0, 0, 1, 0)
            fill.BackgroundColor3 = Color3.fromRGB(200, 200, 210)
            fill.BorderSizePixel = 0
            fill.ZIndex = 9
            if mkCorner then mkCorner(fill, 4) end

            local knob = Instance.new("Frame", track)
            knob.Size = UDim2.fromOffset(18, 18)
            knob.AnchorPoint = Vector2.new(0.5, 0.5)
            knob.Position = UDim2.new(0, 0, 0.5, 0)
            knob.BackgroundColor3 = Color3.fromRGB(245, 245, 250)
            knob.BorderSizePixel = 0
            knob.ZIndex = 10
            if mkCorner then mkCorner(knob, 9) end

            local minS, maxS = 36, 90
            local function setSlider(val, noSave)
                val = math.clamp(math.floor(val + 0.5), minS, maxS)
                if State then State.mobileButtonSize = val end
                valLbl.Text = tostring(val)
                local pct = (val - minS) / (maxS - minS)
                fill.Size = UDim2.new(pct, 0, 1, 0)
                knob.Position = UDim2.new(pct, 0, 0.5, 0)
                if not noSave then
                    task.spawn(saveConfig)
                    if not (State and State.hideMobileButtons) then
                        pcall(function()
                            if buildKyzDuelsMobileButtons then buildKyzDuelsMobileButtons(true) end
                        end)
                    end
                end
            end
            setSlider((State and State.mobileButtonSize) or 56, true)

            local dragging = false
            local function updateFromX(x)
                local absPos = track.AbsolutePosition.X
                local absSize = track.AbsoluteSize.X
                if absSize <= 0 then return end
                local pct = math.clamp((x - absPos) / absSize, 0, 1)
                local val = minS + pct * (maxS - minS)
                setSlider(val, false)
            end

            track.InputBegan:Connect(function(inp)
                if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
                    dragging = true
                    updateFromX(inp.Position.X)
                end
            end)
            knob.InputBegan:Connect(function(inp)
                if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
                    dragging = true
                end
            end)
            UIS.InputChanged:Connect(function(inp)
                if not dragging then return end
                if inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch then
                    updateFromX(inp.Position.X)
                end
            end)
            UIS.InputEnded:Connect(function(inp)
                if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
                    dragging = false
                end
            end)
        end

        if makeMomentaryRow then
            makeMomentaryRow("Reset Mobile Positions", function()
                pcall(function()
                    if resetKyzDuelsMobilePositions then
                        resetKyzDuelsMobilePositions()
                    elseif MobileAPI and MobileAPI.resetPositions then
                        MobileAPI.resetPositions()
                    end
                end)
            end, nil, tabMobile)
        end
    end


    function createAllUILayout()
        loCount = 0
        setupSpeedTab()
        setupCombatTab()
        setupStealTab()
        setupMechTab()
        setupVisualTab()
        setupPlayerVisualTab()
        setupMobileOptionsTab()
        setupSettingsTab()
    end

    createAllUILayout()
    end

    InitUI()

    task.defer(function()
        task.wait(0.25)
        pcall(function()
        end)
        pcall(function()
            bi = _G.__KyzDuelsPendingBG
            if bi == nil then bi = State.backgroundIndex end
            bi = tonumber(bi) or 0
            if bi and bi > 0 then
                backgroundIndex = bi
                State.backgroundIndex = bi
                resolveBackgroundRefs()
                applyBackgroundImage(bi)
            end
        end)

        pcall(function()
            if State.customFontName and State.customFontName ~= "Base" then
                if applySelectedCustomFont then
                    applySelectedCustomFont()
                end
                if State.customFontAuto and startFontAutoApply then
                    startFontAutoApply()
                end
            elseif State.customFontEnabled and applySelectedCustomFont then
                applySelectedCustomFont()
            end
        end)

        -- keyboard removed

        pcall(function()
            for keyRef, btn in pairs(keybindBtnRefs or {}) do
                if btn and Keys[keyRef] then
                    btn.Text = getKeyName(Keys[keyRef] or Enum.KeyCode.Unknown)
                end
            end
        end)

        pcall(function()
            function syncT(ref, val)
                if toggleRefs[ref] then pcall(function() toggleRefs[ref](val, true) end) end
            end
                    syncT("antiRagdoll", State.antiRagdollEnabled)
            syncT("infJump", State.infJumpEnabled)
            syncT("autoTP", State.autoTPEnabled)
            syncT("unwalk", State.unwalkEnabled)
            syncT("noCollide", State.noCollideEnabled)
            syncT("xray", State.xrayEnabled)
            syncT("esp", State.espEnabled)
            syncT("fov", State.fovEnabled)
            syncT("stretchRez", State.stretchRezEnabled)
            syncT("safeMode", State.safeModeEnabled)
            syncT("kickWarning", State.kickWarningEnabled)
            syncT("highPingWarn", State.highPingWarnEnabled)
            syncT("uiLocked", State.uiLocked)
            syncT("tryhardAnim", State.tryhardAnimEnabled)
            syncT("aimbot", State.batAimbotToggled)
            syncT("tpBat", State.tpBatEnabled)
            syncT(State.antiBatTpEnabled)
            syncT("autoSteal", State.autoStealEnabled)
            syncT("syncStealRagdoll", State.syncStealRagdoll)
            syncT("autoCarrySpeed", State.autoCarrySpeedEnabled)
            syncT("noCamCollision", State.noCamCollisionEnabled)
            syncT("shinyGraphics", State.shinyGraphicsEnabled)
            if State.shinyGraphicsEnabled then pcall(enableShinyGraphics) end
            syncT("antiVoid", State.antiVoidEnabled)
            if State.antiVoidEnabled and _G.AmbitiousAntiVoid then
                pcall(_G.AmbitiousAntiVoid.setEnabled, true)
            end
            syncT("antiLag", State.antiLagEnabled)
            syncT("transparentMap", State.transparentMapEnabled)
            syncT("batMedusaTransparent", State.batMedusaTransparent)
            syncT("batMedusaRainbow", State.batMedusaRainbow)
            syncT("batCustom", State.batCustomEnabled and (State.batCustomKey or "diamond") == "diamond")
            if toggleRefs.batCustomScythe then
                pcall(function() toggleRefs.batCustomScythe(State.batCustomEnabled and State.batCustomKey == "scythe_bear", true) end)
            end
            if toggleRefs.batCustomScytheWhite then
                pcall(function() toggleRefs.batCustomScytheWhite(State.batCustomEnabled and State.batCustomKey == "scythe_white", true) end)
            end
            if toggleRefs.batCustomBlackHammer then
                pcall(function() toggleRefs.batCustomBlackHammer(State.batCustomEnabled and State.batCustomKey == "black_hammer", true) end)
            end
            if toggleRefs.batCustomNoSound then
                pcall(function()
                    toggleRefs.batCustomNoSound(State.batNoSound == true, true)
                end)
            end
            if toggleRefs.skullEvil then
                pcall(function() toggleRefs.skullEvil(State.skullCustomEnabled and (State.skullCustomKey or "evil") == "evil", true) end)
            end
            if toggleRefs.skullOminous then
                pcall(function() toggleRefs.skullOminous(State.skullCustomEnabled and State.skullCustomKey == "ominous", true) end)
            end
            if toggleRefs.skullCone then
                pcall(function() toggleRefs.skullCone(State.skullCustomEnabled and State.skullCustomKey == "cone", true) end)
            end
            if toggleRefs.skullKamehameha then
                pcall(function() toggleRefs.skullKamehameha(State.skullCustomEnabled and State.skullCustomKey == "kamehameha", true) end)
            end
            if toggleRefs.skullFireball then
                pcall(function() toggleRefs.skullFireball(State.skullCustomEnabled and State.skullCustomKey == "fireball", true) end)
            end
            if toggleRefs.skullRasengan then
                pcall(function() toggleRefs.skullRasengan(State.skullCustomEnabled and State.skullCustomKey == "rasengan", true) end)
            end
            syncT("ragdollCountdown", State.ragdollCountdownEnabled)
            syncT("removeAcc", State.removeAccEnabled)
                        syncT("medusaCounter", State.medusaCounterEnabled)
            syncT("batCounter", State.batCounterEnabled)
            syncT("antiMedusa", State.antiMedusaEnabled)
            syncT("autoLeft", State.autoLeftEnabled)
            syncT("autoRight", State.autoRightEnabled)
            syncT("autoSwing", State.autoSwingEnabled)
            syncT("skinHeadless", State.skinHeadless)
            syncT("skinFireHead", State.skinFireHead)
            syncT("skinHornWhite", State.skinHornWhite)
            syncT("skinKorblox", State.skinKorblox)
            pcall(function()
                if updateDropUI then updateDropUI() end
                if syncDropMode then syncDropMode() end
                if updateTryhardAnimModeUI then updateTryhardAnimModeUI() end
                if updateSpeedUI then updateSpeedUI() end
            end)
            if type(toggleRefs.dropCycleLabel) == "function" then
                pcall(toggleRefs.dropCycleLabel, State.dropMode, true)
            elseif toggleRefs.dropCycleLabel and toggleRefs.dropCycleLabel.Text then
                names = {[0]="Single",[1]="Jump"}
                toggleRefs.dropCycleLabel.Text = names[State.dropMode] or "Single"
            end
            if type(toggleRefs.tryhardAnimModeLabel) == "function" then
                pcall(toggleRefs.tryhardAnimModeLabel, State.tryhardAnimMode, true)
            end
            if type(toggleRefs.autoStealMode) == "function" then
                pcall(toggleRefs.autoStealMode, State.autoStealMode, true)
            end
            if type(toggleRefs.aimbotModeLabel) == "function" then
                pcall(toggleRefs.aimbotModeLabel, State.aimbotMode or "normal", true)
            end
            pcall(function()
                if LP.Character and applyAllActiveSkins then applyAllActiveSkins(LP.Character) end
            end)
        end)

        task.spawn(function()
            for attempt = 1, 8 do
                char = LP.Character
                cam = workspace.CurrentCamera
                ready = char
                    and char:FindFirstChild("HumanoidRootPart")
                    and char:FindFirstChildOfClass("Humanoid")
                    and cam ~= nil
                if ready then
                    pcall(startEnabledFeatures)
        State.antiDieEnabled = true
        pcall(startAntiDie)
                    task.wait(0.75)
                    pcall(startEnabledFeatures)
                    break
                end
                task.wait(0.4)
            end
        end)
    end)

    function createStealProgressBar()
        pcall(function()
            pg = LP:FindFirstChild("PlayerGui")
            if pg then
                old = pg:FindFirstChild("KyzDuelsStealBarGui")
                if old then old:Destroy() end
            end
        end)

        barGui = Instance.new("ScreenGui")
        barGui.Name = "KyzDuelsStealBarGui"
        barGui.ResetOnSpawn = false
        barGui.IgnoreGuiInset = true
        barGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        barGui.DisplayOrder = 80
        if not parentGui(barGui) then return end

        ACCENT = Color3.fromRGB(200, 200, 210)
        ACCENT_BRIGHT = Color3.fromRGB(235, 235, 240)
        ACCENT_DIM = Color3.fromRGB(120, 120, 130)

        pbFrame = Instance.new("Frame")
        pbFrame.Name = "StealBar"
        pbFrame.Size = UDim2.new(0, 320, 0, 36)
        do
            sp = (State and State.stealBarPosition) or {X = {Scale = 0.5, Offset = -160}, Y = {Scale = 0, Offset = 6}}
            xs = (sp.X and sp.X.Scale) or 0.5
            xo = (sp.X and sp.X.Offset) or -150
            ys = (sp.Y and sp.Y.Scale) or 0
            yo = (sp.Y and sp.Y.Offset) or 16
            pbFrame.Position = UDim2.new(xs, xo, ys, yo)
        end
        pbFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        pbFrame.BorderSizePixel = 0
        pbFrame.Active = true
        pbFrame.ClipsDescendants = true
        pbFrame.ZIndex = 50
        pbFrame.Parent = barGui
        Instance.new("UICorner", pbFrame).CornerRadius = UDim.new(1, 0)
        pbSt = Instance.new("UIStroke", pbFrame)
        pbSt.Color = ACCENT
        pbSt.Thickness = 1.4
        pbSt.Transparency = 0.25

        local dragging, dragStart, startPos = false, nil, nil
        pbFrame.InputBegan:Connect(function(input)
            if State and State.uiLocked then return end
            if input.UserInputType == Enum.UserInputType.MouseButton1
                or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                dragStart = input.Position
                startPos = pbFrame.Position
            end
        end)
        UIS.InputChanged:Connect(function(input)
            if not dragging then return end
            if input.UserInputType ~= Enum.UserInputType.MouseMovement
                and input.UserInputType ~= Enum.UserInputType.Touch then return end
            delta = input.Position - dragStart
            pbFrame.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end)
        UIS.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1
                or input.UserInputType == Enum.UserInputType.Touch then
                if dragging and pbFrame and State then
                    p = pbFrame.Position
                    State.stealBarPosition = {
                        X = { Scale = p.X.Scale, Offset = p.X.Offset },
                        Y = { Scale = p.Y.Scale, Offset = p.Y.Offset },
                    }
                    task.spawn(saveConfig)
                end
                dragging = false
            end
        end)

        -- Solid black + rectangular with soft corners (like reference)
        local BAR_W = 320
        local BAR_H = 36
        pbFrame.Size = UDim2.new(0, BAR_W, 0, BAR_H)
        pbFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        pbFrame.BackgroundTransparency = 1
        pbFrame.ClipsDescendants = true
        pcall(function()
            if pbSt then
                pbSt.Color = Color3.fromRGB(40, 40, 48)
                pbSt.Thickness = 1.4
                pbSt.Transparency = 0.15
            end
        end)
        local outerCorner = pbFrame:FindFirstChildOfClass("UICorner")
        if outerCorner then
            outerCorner.CornerRadius = UDim.new(0, 10)
        else
            Instance.new("UICorner", pbFrame).CornerRadius = UDim.new(0, 10)
        end

        -- background image for auto steal bar (download + getcustomasset)
        local bgImg = Instance.new("ImageLabel")
        bgImg.Name = "BarBackground"
        bgImg.Size = UDim2.new(1, 0, 1, 0)
        bgImg.Position = UDim2.new(0, 0, 0, 0)
        bgImg.BackgroundTransparency = 1
        bgImg.ScaleType = Enum.ScaleType.Crop
        bgImg.ZIndex = 50
        bgImg.Parent = pbFrame
        Instance.new("UICorner", bgImg).CornerRadius = UDim.new(0, 10)

        local BAR_BG_URL = "https://happy-image-link.lovable.app/api/public/f/kx7m2a134.png"
        local BAR_BG_FILE = "KyzDuelsStealBarBg.png"

        local function applyBarBg(assetId)
            if not assetId or tostring(assetId) == "" then return end
            pcall(function()
                bgImg.Image = tostring(assetId)
            end)
        end

        task.spawn(function()
            -- try cached file first
            local has = false
            pcall(function()
                if isfile and isfile(BAR_BG_FILE) then has = true end
            end)
            if has and getcustomasset then
                local ok, assetId = pcall(getcustomasset, BAR_BG_FILE)
                if ok and assetId then
                    applyBarBg(assetId)
                    return
                end
            end
            -- download
            local data = nil
            pcall(function()
                if type(_httpGetBinary) == "function" then
                    data = _httpGetBinary(BAR_BG_URL)
                elseif type(httpGet) == "function" then
                    data = httpGet(BAR_BG_URL)
                elseif game and game.HttpGet then
                    data = game:HttpGet(BAR_BG_URL)
                end
            end)
            if data and #tostring(data) > 500 and writefile then
                pcall(function()
                    if delfile and isfile and isfile(BAR_BG_FILE) then delfile(BAR_BG_FILE) end
                end)
                pcall(writefile, BAR_BG_FILE, data)
                task.wait(0.08)
                if getcustomasset then
                    local ok, assetId = pcall(getcustomasset, BAR_BG_FILE)
                    if ok and assetId then
                        applyBarBg(assetId)
                        return
                    end
                end
            end
            -- last fallback: direct url (some executors allow it)
            pcall(function()
                bgImg.Image = BAR_BG_URL
            end)
        end)

        -- slight dark overlay so text stays readable
        local bgDark = Instance.new("Frame")
        bgDark.Name = "BarBgDark"
        bgDark.Size = UDim2.new(1, 0, 1, 0)
        bgDark.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        bgDark.BackgroundTransparency = 0.55
        bgDark.BorderSizePixel = 0
        bgDark.ZIndex = 51
        bgDark.Parent = pbFrame
        Instance.new("UICorner", bgDark).CornerRadius = UDim.new(0, 10)

        -- top row: % | discord | fps|ping
        topRow = Instance.new("Frame", pbFrame)
        topRow.Name = "TopLabels"
        topRow.Size = UDim2.new(1, 0, 0, 13)
        topRow.Position = UDim2.new(0, 0, 0, 2)
        topRow.BackgroundTransparency = 1
        topRow.ZIndex = 60

        pct = Instance.new("TextLabel", topRow)
        pct.Name = "Percent"
        pct.Size = UDim2.new(0, 42, 1, 0)
        pct.Position = UDim2.new(0, 10, 0, 0)
        pct.BackgroundTransparency = 1
        pct.Text = "0%"
        pct.TextColor3 = Color3.fromRGB(255, 255, 255)
        pct.Font = Enum.Font.GothamBold
        pct.TextSize = 11
        pct.TextXAlignment = Enum.TextXAlignment.Left
        pct.TextStrokeTransparency = 0.55
        pct.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        pct.ZIndex = 61

        stealLbl = Instance.new("TextLabel", topRow)
        stealLbl.Name = "DiscordLabel"
        stealLbl.Size = UDim2.new(0, 160, 1, 0)
        stealLbl.Position = UDim2.new(0.5, -80, 0, 0)
        stealLbl.BackgroundTransparency = 1
        stealLbl.Text = "discord.gg/pauTcg8prH"
        stealLbl.TextColor3 = Color3.fromRGB(200, 200, 210)
        stealLbl.Font = Enum.Font.GothamBold
        stealLbl.TextSize = 10
        stealLbl.TextXAlignment = Enum.TextXAlignment.Center
        stealLbl.TextTruncate = Enum.TextTruncate.AtEnd
        stealLbl.TextStrokeTransparency = 0.55
        stealLbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        stealLbl.ZIndex = 61

        statsLbl = Instance.new("TextLabel", topRow)
        statsLbl.Name = "NetStats"
        statsLbl.Size = UDim2.new(0, 78, 1, 0)
        statsLbl.Position = UDim2.new(1, -86, 0, 0)
        statsLbl.BackgroundTransparency = 1
        statsLbl.Text = "0 | 0ms"
        statsLbl.TextColor3 = Color3.fromRGB(170, 170, 180)
        statsLbl.Font = Enum.Font.GothamBold
        statsLbl.TextSize = 11
        statsLbl.TextXAlignment = Enum.TextXAlignment.Right
        statsLbl.TextStrokeTransparency = 0.65
        statsLbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        statsLbl.ZIndex = 61

        -- solid black track (soft rectangular)
        fillRegion = Instance.new("Frame", pbFrame)
        fillRegion.Name = "FillRegion"
        fillRegion.Size = UDim2.new(1, -16, 0, 11)
        fillRegion.Position = UDim2.new(0, 8, 0, 18)
        fillRegion.BackgroundColor3 = Color3.fromRGB(14, 14, 18)
        fillRegion.BorderSizePixel = 0
        fillRegion.ClipsDescendants = true
        fillRegion.ZIndex = 55
        Instance.new("UICorner", fillRegion).CornerRadius = UDim.new(0, 6)
        local trackStroke = Instance.new("UIStroke", fillRegion)
        trackStroke.Color = Color3.fromRGB(50, 50, 58)
        trackStroke.Thickness = 1.1
        trackStroke.Transparency = 0.25

        -- pure white fill
        fill = Instance.new("Frame", fillRegion)
        fill.Name = "Fill"
        fill.Size = UDim2.new(0, 0, 1, 0)
        fill.Position = UDim2.new(0, 0, 0, 0)
        fill.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        fill.BorderSizePixel = 0
        fill.ZIndex = 56
        Instance.new("UICorner", fill).CornerRadius = UDim.new(0, 6)

        progressFill = fill
        progressPct = pct
        StealProgressBar.pbFrame = pbFrame
        StealProgressBar.holder = pbFrame
        StealProgressBar.progressFill = fill
        StealProgressBar.progressPct = pct
        StealProgressBar.statsFrame = statsLbl
        StealProgressBar.fpsLbl = statsLbl
        StealProgressBar.pingLbl = statsLbl

        barState = "IDLE"
        function setBarState(state)
            barState = state
            if state == "STEALING" then
                TweenService:Create(stealLbl, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(245, 245, 250)}):Play()
                TweenService:Create(fillRegion, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(8, 8, 10)}):Play()
            elseif state == "READY" then
                TweenService:Create(stealLbl, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(220, 220, 230)}):Play()
                TweenService:Create(fillRegion, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(12, 12, 14)}):Play()
                pct.Text = "0%"
                pct.TextColor3 = Color3.fromRGB(255, 255, 255)
            else
                TweenService:Create(stealLbl, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(160, 160, 170)}):Play()
                TweenService:Create(fillRegion, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(12, 12, 14)}):Play()
                pct.Text = "0%"
                pct.TextColor3 = Color3.fromRGB(180, 180, 190)
            end
        end
        setBarState("IDLE")

        _G.StealBar = {
            SetProgress = function(p)
                p = math.clamp(tonumber(p) or 0, 0, 1)
                if progressFill then progressFill.Size = UDim2.new(p, 0, 1, 0) end
                if progressPct then progressPct.Text = math.floor(p * 100 + 0.5) .. "%" end
            end,
            Reset = function()
                if progressFill then progressFill.Size = UDim2.new(0, 0, 1, 0) end
                if progressPct then progressPct.Text = "0%" end
                setBarState("IDLE")
            end,
            SetState = function(state)
                setBarState(state)
            end,
        }

        task.spawn(function()
            Stats = game:GetService("Stats")
            lastFrame = tick()
            fpsSamples = {}
            fpsAvg = 60
            local fpsConn = RunService.RenderStepped:Connect(function()
                now = tick()
                dt = now - lastFrame
                lastFrame = now
                if dt > 0 and dt < 1 then
                    table.insert(fpsSamples, 1 / dt)
                    if #fpsSamples > 30 then table.remove(fpsSamples, 1) end
                    sum = 0
                    for _, v in ipairs(fpsSamples) do sum = sum + v end
                    fpsAvg = sum / math.max(#fpsSamples, 1)
                end
            end)
            while pbFrame and pbFrame.Parent do
                ping = 0
                pcall(function()
                    ms = LP:GetNetworkPing()
                    if ms then ping = ms * 1000 end
                end)
                if ping <= 0 then
                    pcall(function()
                        item = Stats.Network.ServerStatsItem["Data Ping"]
                        if item then ping = item:GetValue() or 0 end
                    end)
                end
                if statsLbl and statsLbl.Parent then
                    statsLbl.Text = string.format("%d | %dms",
                        math.floor(fpsAvg + 0.5), math.floor(ping + 0.5))
                end
                task.wait(0.5)
            end
            pcall(function() fpsConn:Disconnect() end)
        end)

        task.spawn(function()
            pulse = 0
            while pbFrame and pbFrame.Parent do
                pulse = pulse + 0.05
                alpha = (math.sin(pulse) + 1) / 2
                pbSt.Transparency = 0.15 + (alpha * 0.35)
                RunService.RenderStepped:Wait()
            end
        end)

        pbFrame.Visible = false
        refreshStealBarVisible()
        task.spawn(function()
            while task.wait(0.05) do
                if not (pbFrame and pbFrame.Parent) then break end
                refreshStealBarVisible()
            end
        end)
    end

    KyzDuelsMobileGui = nil
    kyzDuelsMobBtnRefs = {}
    kyzDuelsMobilePositions = {}
    KYZ_DUELS_MOBILE_CFG = "KyzDuelsMobileButtons.json"

    local function findKyzDuelsMobileGui()
        if KyzDuelsMobileGui and KyzDuelsMobileGui.Parent then return KyzDuelsMobileGui end
        local found = nil
        pcall(function()
            if type(gethui) == "function" then
                found = gethui():FindFirstChild("KyzDuelsMobileButtons")
            end
        end)
        if found then return found end
        pcall(function()
            found = CoreGui:FindFirstChild("KyzDuelsMobileButtons")
        end)
        if found then return found end
        pcall(function()
            local pg = LP:FindFirstChild("PlayerGui")
            if pg then found = pg:FindFirstChild("KyzDuelsMobileButtons") end
        end)
        return found
    end

    local function getDefaultMobileLayout()
        local size = math.clamp(tonumber(State and State.mobileButtonSize) or 56, 36, 90)
        local gap = math.max(5, math.floor(size * 0.12))
        local vp = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(800, 600)
        local cols = 3
        local n = 11
        local rows = math.ceil(n / cols)
        local totalW = size * cols + gap * (cols - 1)
        local totalH = rows * (size + gap) - gap
        local startX = math.max(8, vp.X - totalW - 12)
        local startY = math.clamp(math.floor(vp.Y * 0.18), 70, math.max(70, vp.Y - totalH - 120))
        local keys = {
            "tpDown", "drop", "instaReset", "autoLeft", "autoRight", "aimbot", "tpBat",
            "carrySpeed", "normalLagger", "carryLagger",
        }
        local defaults = {}
        for i, key in ipairs(keys) do
            local col = (i - 1) % cols
            local row = math.floor((i - 1) / cols)
            defaults[key] = {
                xo = startX + col * (size + gap),
                yo = startY + row * (size + gap),
            }
        end
        return defaults
    end

    function loadKyzDuelsMobilePositions()
        pcall(function()
            if isfile and isfile(KYZ_DUELS_MOBILE_CFG) then
                local ok, data = pcall(function()
                    return HttpService:JSONDecode(readfile(KYZ_DUELS_MOBILE_CFG))
                end)
                if ok and type(data) == "table" and type(data.positions) == "table" then
                    kyzDuelsMobilePositions = data.positions
                end
            end
        end)
    end

    function saveKyzDuelsMobilePositions()
        pcall(function()
            if not writefile then return end
            local gui = findKyzDuelsMobileGui()
            if gui then
                for _, child in ipairs(gui:GetChildren()) do
                    if child:IsA("Frame") and child:GetAttribute("BtnKey") then
                        local key = child:GetAttribute("BtnKey")
                        kyzDuelsMobilePositions[key] = {
                            xo = child.Position.X.Offset,
                            yo = child.Position.Y.Offset,
                        }
                    end
                end
            end
            writefile(KYZ_DUELS_MOBILE_CFG, HttpService:JSONEncode({ positions = kyzDuelsMobilePositions }))
        end)
    end

    function resetKyzDuelsMobilePositions()
        local defaults = getDefaultMobileLayout()
        kyzDuelsMobilePositions = defaults
        pcall(function()
            if writefile then
                writefile(KYZ_DUELS_MOBILE_CFG, HttpService:JSONEncode({ positions = defaults }))
            end
        end)
        if State and State.hideMobileButtons then return end
        pcall(function()
            buildKyzDuelsMobileButtons(true)
        end)
        pcall(function()
            local gui = findKyzDuelsMobileGui()
            if not gui then return end
            for _, child in ipairs(gui:GetChildren()) do
                if child:IsA("Frame") then
                    local key = child:GetAttribute("BtnKey")
                    local sp = key and defaults[key]
                    if sp then
                        child.Position = UDim2.fromOffset(sp.xo, sp.yo)
                    end
                end
            end
        end)
    end

    function destroyKyzDuelsMobileButtons()
        pcall(function()
            local gui = findKyzDuelsMobileGui and findKyzDuelsMobileGui()
            if gui then gui:Destroy() end
        end)
        pcall(function()
            local pg = LP:FindFirstChild("PlayerGui")
            if pg then
                local old = pg:FindFirstChild("KyzDuelsMobileButtons")
                if old then old:Destroy() end
            end
        end)
        pcall(function()
            local old2 = CoreGui:FindFirstChild("KyzDuelsMobileButtons")
            if old2 then old2:Destroy() end
        end)
        pcall(function()
            if type(gethui) == "function" then
                local old3 = gethui():FindFirstChild("KyzDuelsMobileButtons")
                if old3 then old3:Destroy() end
            end
        end)
        KyzDuelsMobileGui = nil
        kyzDuelsMobBtnRefs = {}
    end

    function buildKyzDuelsMobileButtons(skipLoad)
        if State and State.hideMobileButtons then
            destroyKyzDuelsMobileButtons()
            return
        end
        destroyKyzDuelsMobileButtons()
        if not skipLoad then
            loadKyzDuelsMobilePositions()
        end

        local C_OFF = Color3.fromRGB(12, 12, 14)
        local C_ON  = Color3.fromRGB(245, 245, 250)
        local T_OFF = Color3.fromRGB(220, 220, 230)
        local T_ON  = Color3.fromRGB(15, 15, 18)

        local gui = Instance.new("ScreenGui")
        gui.Name = "KyzDuelsMobileButtons"
        gui.ResetOnSpawn = false
        gui.DisplayOrder = 40
        gui.IgnoreGuiInset = true
        gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        if not parentGui(gui) then return end
        KyzDuelsMobileGui = gui

        local buttons = {
            { key = "tpDown",        label = "TP\nDOWN",      toggle = false },
            { key = "drop",          label = "DROP",         toggle = false },
            { key = "instaReset",    label = "INSTA\nRESET",  toggle = false },
            { key = "autoLeft",      label = "AUTO\nLEFT",    toggle = true  },
            { key = "autoRight",     label = "AUTO\nRIGHT",   toggle = true  },
            { key = "aimbot",        label = "BAT\nAIMBOT",   toggle = true  },
            { key = "tpBat",         label = "TP\nBAT",       toggle = true  },
                        { key = "carrySpeed",    label = "SPEED\nMODE",   toggle = true  },
            { key = "normalLagger",  label = "LAGGER\nV1",    toggle = true  },
            { key = "carryLagger",   label = "LAGGER\nV2",    toggle = true  },
        }

        local size = math.clamp(tonumber(State and State.mobileButtonSize) or 56, 36, 90)
        local gap = math.max(5, math.floor(size * 0.12))
        local vp = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(800, 600)
        local cols = 3
        local rows = math.ceil(#buttons / cols)
        local totalW = size * cols + gap * (cols - 1)
        local totalH = rows * (size + gap) - gap
        local startX = math.max(8, vp.X - totalW - 12)
        local startY = math.clamp(math.floor(vp.Y * 0.18), 70, math.max(70, vp.Y - totalH - 120))

        kyzDuelsMobBtnRefs = {}

        local textSize = math.clamp(math.floor(size * 0.20), 9, 16)
        local cornerR = math.clamp(math.floor(size * 0.21), 8, 16)

        for i, def in ipairs(buttons) do
            local col = (i - 1) % cols
            local row = math.floor((i - 1) / cols)
            local sp = kyzDuelsMobilePositions[def.key]
            local xo = sp and sp.xo or (startX + col * (size + gap))
            local yo = sp and sp.yo or (startY + row * (size + gap))

            local frame = Instance.new("Frame", gui)
            frame.Size = UDim2.fromOffset(size, size)
            frame.Position = UDim2.fromOffset(xo, yo)
            frame.BackgroundColor3 = C_OFF
            frame.BorderSizePixel = 0
            frame.Active = true
            frame.ZIndex = 50
            frame:SetAttribute("BtnKey", def.key)
            Instance.new("UICorner", frame).CornerRadius = UDim.new(0, cornerR)
            local stroke = Instance.new("UIStroke", frame)
            stroke.Color = Color3.fromRGB(80, 80, 90)
            stroke.Thickness = 1.2
            stroke.Transparency = 0.35

            local btn = Instance.new("TextButton", frame)
            btn.Size = UDim2.fromScale(1, 1)
            btn.BackgroundTransparency = 1
            btn.Text = def.label
            btn.TextColor3 = T_OFF
            btn.Font = Enum.Font.GothamBlack
            btn.TextSize = textSize
            btn.TextWrapped = true
            btn.AutoButtonColor = false
            btn.ZIndex = 51

            local on = false
            local function setOn(v)
                on = v and true or false
                frame.BackgroundColor3 = on and C_ON or C_OFF
                btn.TextColor3 = on and T_ON or T_OFF
                stroke.Color = on and Color3.fromRGB(200, 200, 210) or Color3.fromRGB(80, 80, 90)
            end
            kyzDuelsMobBtnRefs[def.key] = setOn

            if def.key == "autoLeft" and State and State.autoLeftEnabled then setOn(true) end
            if def.key == "autoRight" and State and State.autoRightEnabled then setOn(true) end
            if def.key == "aimbot" and State and State.batAimbotToggled then setOn(true) end
            if def.key == "tpBat" and State and State.tpBatEnabled then setOn(true) end
                        -- keep MobileAPI.refs live for drop-after sync
            if MobileAPI then MobileAPI.refs = kyzDuelsMobBtnRefs end
            if _G.__KyzDuelsMobileAPI then _G.__KyzDuelsMobileAPI.refs = kyzDuelsMobBtnRefs end
            if State then
                local lm = State.laggerMode or 0
                local sm = State.speedMode or 0
                if def.key == "carryLagger" and lm == 1 then setOn(true) end
                if def.key == "normalLagger" and lm == 2 then setOn(true) end
                if def.key == "carrySpeed" and lm == 0 and sm == 1 then setOn(true) end
            end

            local function flash()
                setOn(true)
                task.delay(0.15, function()
                    if not def.toggle then setOn(false) end
                end)
            end

            local dragStart, dragPos, moved, down = nil, nil, false, false
            btn.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1
                    or input.UserInputType == Enum.UserInputType.Touch then
                    if State and State.lockMobileButtons then return end
                    moved, down = false, true
                    dragStart, dragPos = input.Position, frame.Position
                    input.Changed:Connect(function()
                        if input.UserInputState == Enum.UserInputState.End then
                            down = false
                            if moved then
                                saveKyzDuelsMobilePositions()
                            end
                        end
                    end)
                end
            end)
            btn.InputChanged:Connect(function(input)
                if not down then return end
                if input.UserInputType ~= Enum.UserInputType.MouseMovement
                    and input.UserInputType ~= Enum.UserInputType.Touch then
                    return
                end
                local d = input.Position - dragStart
                if d.Magnitude > 6 then moved = true end
                if moved then
                    frame.Position = UDim2.new(
                        dragPos.X.Scale, dragPos.X.Offset + d.X,
                        dragPos.Y.Scale, dragPos.Y.Offset + d.Y
                    )
                end
            end)

            btn.MouseButton1Click:Connect(function()
                if moved then return end
                local key = def.key
                if key == "tpDown" then
                    pcall(doTpDown)
                    flash()
                elseif key == "drop" then
                    pcall(function()
                        if type(runDropBrainrot) == "function" then
                            runDropBrainrot()
                        elseif type(runSelectedDrop) == "function" then
                            runSelectedDrop()
                        end
                    end)
                    flash()
                elseif key == "instaReset" then
                    pcall(insta_reset)
                    flash()
                elseif key == "autoLeft" then
                    local nextOn = not on
                    if State then State.autoLeftEnabled = nextOn end
                    if nextOn then
                        if State then State.autoRightEnabled = false end
                        pcall(stopAutoRight)
                        if kyzDuelsMobBtnRefs.autoRight then kyzDuelsMobBtnRefs.autoRight(false) end
                        setOn(true)
                        pcall(startAutoLeft)
                    else
                        setOn(false)
                        pcall(stopAutoLeft)
                        if State then State.autoLeftEnabled = false end
                    end
                    task.spawn(saveConfig)
                elseif key == "autoRight" then
                    local nextOn = not on
                    if State then State.autoRightEnabled = nextOn end
                    if nextOn then
                        if State then State.autoLeftEnabled = false end
                        pcall(stopAutoLeft)
                        if kyzDuelsMobBtnRefs.autoLeft then kyzDuelsMobBtnRefs.autoLeft(false) end
                        setOn(true)
                        pcall(startAutoRight)
                    else
                        setOn(false)
                        pcall(stopAutoRight)
                        if State then State.autoRightEnabled = false end
                    end
                    task.spawn(saveConfig)
                elseif key == "aimbot" then
                    local nextOn = not on
                    setOn(nextOn)
                    if State then State.batAimbotToggled = nextOn end
                    if toggleRefs and toggleRefs.aimbot then
                        pcall(function() toggleRefs.aimbot(nextOn, true) end)
                    end
                    if nextOn then pcall(startBatAimbot) else pcall(stopBatAimbot) end
                    task.spawn(saveConfig)
                elseif key == "tpBat" then
                    local nextOn = not on
                    setOn(nextOn)
                    if State then State.tpBatEnabled = nextOn end
                    if toggleRefs and toggleRefs.tpBat then
                        pcall(function() toggleRefs.tpBat(nextOn, true) end)
                    end
                    if nextOn then pcall(startTpBat) else pcall(stopTpBat) end
                    task.spawn(saveConfig)
                    if key == "carrySpeed" then
                        if State then
                            local lm = State.laggerMode or 0
                            local sm = State.speedMode or 0
                            if lm == 0 and sm == 1 then
                                -- toggle OFF -> normal
                                State.speedMode = 0
                                State.laggerMode = 0
                            else
                                -- exclusive: Carry only
                                State.speedMode = 1
                                State.laggerMode = 0
                            end
                        end
                    elseif key == "normalLagger" then
                        if State then
                            if State.laggerMode == 2 then
                                State.laggerMode = 0
                                State.speedMode = 0
                            else
                                -- exclusive: Normal Lagger only
                                State.laggerMode = 2
                                State.lastLaggerMode = 2
                                State.speedMode = 0
                            end
                        end
                    elseif key == "carryLagger" then
                        if State then
                            if State.laggerMode == 1 then
                                State.laggerMode = 0
                                State.speedMode = 0
                            else
                                -- exclusive: Carry Lagger only
                                State.laggerMode = 1
                                State.lastLaggerMode = 1
                                State.speedMode = 0
                            end
                        end
                    end
                    syncSpeedBtns()
                    pcall(updateSpeedUI)
                    -- force immediate save so rejoin keeps the same mode + speed value
                    pcall(function()
                        if type(autoSave) == "function" then autoSave(true) else saveConfig() end
                    end)
                end
            end)
        end
    end

    MobileAPI = MobileAPI or _G.__KyzDuelsMobileAPI or {}
    MobileAPI.build = buildKyzDuelsMobileButtons
    MobileAPI.destroy = destroyKyzDuelsMobileButtons
    MobileAPI.resetPositions = resetKyzDuelsMobilePositions
    MobileAPI.savePositions = saveKyzDuelsMobilePositions
    MobileAPI.refs = kyzDuelsMobBtnRefs
    MobileAPI.syncCombat = function()
        if type(syncMobileCombatButtons) == "function" then
            return syncMobileCombatButtons()
        end
    end
    _G.__KyzDuelsMobileAPI = MobileAPI

    createStealProgressBar()
    refreshStealBarVisible()
    task.defer(function()
        task.wait(0.45)
        pcall(function()
            if not (State and State.hideMobileButtons) then
                if buildKyzDuelsMobileButtons then
                    buildKyzDuelsMobileButtons()
                elseif MobileAPI and MobileAPI.build then
                    MobileAPI.build()
                end
            end
        end)
        -- re-apply saved speed mode visuals after buttons exist
        task.wait(0.1)
        pcall(syncMobileSpeedButtons)
        pcall(syncMobileCombatButtons)
        pcall(updateSpeedUI)
        task.delay(0.5, function()
            pcall(syncMobileSpeedButtons)
            pcall(updateSpeedUI)
        end)
    end)

    function destroySpeedVelocity()
        char = LP.Character
        root = char and char:FindFirstChild("HumanoidRootPart")
        if root then
            lv = root:FindFirstChild("_RHSpeedLV")
            if lv then pcall(function() lv:Destroy() end) end
        end
    end

    function setupSpeedVelocity(root)
        -- May.VS: do not create LV movers
        local SL = _G.__KyzDuelsSpeedLV
        if SL and root and SL.clear then SL.clear(root) end
    end

    LP.CharacterAdded:Connect(function(char)
        destroySpeedVelocity()
        task.defer(function()
            root = char and char:FindFirstChild("HumanoidRootPart")
            if root then
                setupSpeedVelocity(root)
            end
        end)
    end)

    -- ============================================================
    -- SPEED SYSTEM = speed.vs NO DROP LOGIC (exact)
    -- Dual-att OrvynLinVel + velocity spoof (hookmetamethod)
    -- ============================================================
    local SpeedSys = {
        enabled = true,
        conn = nil,
        clampConn = nil,
        lastMoveDir = Vector3.zero,
        carryActive = false,
    }

    pcall(function()
        RunService:UnbindFromRenderStep("KyzDuelsCarryCFrame")
    end)

    local function speedGetTarget()
        local st = State or _G.State
        if not st then return 16 end
        if st.autoLeftEnabled or st.autoRightEnabled then
            return tonumber(st.normalSpeed) or 60
        end
        if st.laggerMode == 2 then
            return tonumber(st.laggerCarrySpeed) or 20
        elseif st.laggerMode == 1 then
            return tonumber(st.laggerSpeed) or 40
        elseif st.speedMode == 1 or st.speedToggled or st.softStealLatched then
            return tonumber(st.carrySpeed) or 30
        end
        return tonumber(st.normalSpeed) or 60
    end

    function getActiveMoveSpeed()
        return speedGetTarget()
    end

    function isCarryModeActive()
        local st = State or _G.State
        if not st then return false end
        return st.laggerMode == 2 or st.speedMode == 1 or st.speedToggled == true
    end

    _G._AmbitiousAntiBatSpiking = _G._AmbitiousAntiBatSpiking or false
    _G._AmbitiousZigZagFalling = _G._AmbitiousZigZagFalling or false
    _G._AmbitiousAntiBatDesiredXZ = _G._AmbitiousAntiBatDesiredXZ or nil

    do
        local _sbConn  = nil
        local _sbActive = false
        local lastMoveDir = Vector3.new(0, 0, 0)

        local function _sbStart()
            if _sbConn then _sbConn:Disconnect(); _sbConn = nil end
            _sbActive = true
            SpeedSys.enabled = true
            if State then State.antiDropEnabled = true end
            _sbConn = RunService.Heartbeat:Connect(function()
                if not _sbActive then
                    _sbConn:Disconnect(); _sbConn = nil
                    return
                end
                local st = State or _G.State
                if st and (st._dropInProgress) then return end
                if st and (st.batAimbotToggled or st.tpBatEnabled or st.batDesyncTpEnabled) then
                    return
                end

                local char = LP.Character
                if not char then return end
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if not hrp then return end
                local hum = char:FindFirstChildOfClass("Humanoid")
                if not hum then return end
                local state = hum:GetState()
                if hum.PlatformStand
                    or state == Enum.HumanoidStateType.Physics
                    or state == Enum.HumanoidStateType.Ragdoll
                    or state == Enum.HumanoidStateType.FallingDown then
                    lastMoveDir = Vector3.new(0, 0, 0)
                    SpeedSys.lastMoveDir = Vector3.zero
                    return
                end
                local md = hum.MoveDirection
                local spd = math.clamp(tonumber(speedGetTarget()) or 16, 1, 500)
                if (not st or (not st.autoLeftEnabled and not st.autoRightEnabled)) and md.Magnitude > 0 then
                    lastMoveDir = md
                    SpeedSys.lastMoveDir = md
                    if st then st.lastMoveDir = md end
                    if _G._AmbitiousZigZagFalling then
                        _G._AmbitiousAntiBatDesiredXZ = nil
                    else
                        _G._AmbitiousAntiBatDesiredXZ = Vector3.new(md.X * spd, 0, md.Z * spd)
                    end
                    if not _G._AmbitiousAntiBatSpiking and not _G._AmbitiousZigZagFalling then
                        local curVel = hrp.Velocity
                        hrp.Velocity = Vector3.new(md.X * spd, curVel.Y, md.Z * spd)
                    end
                end
                if md.Magnitude <= 0 or (st and (st.autoLeftEnabled or st.autoRightEnabled)) then
                    _G._AmbitiousAntiBatDesiredXZ = nil
                end
            end)
        end

        local function _sbStop()
            _sbActive = false
            SpeedSys.enabled = false
            SpeedSys.carryActive = false
            if State then State.antiDropEnabled = false end
            if _sbConn then _sbConn:Disconnect(); _sbConn = nil end
            local ch = LP.Character
            local hrp = ch and ch:FindFirstChild("HumanoidRootPart")
            if hrp then
                pcall(function()
                    local v = hrp.Velocity
                    hrp.Velocity = Vector3.new(0, v.Y, 0)
                end)
            end
            _G._AmbitiousAntiBatDesiredXZ = nil
        end

        local function _antiFling()
            if not SpeedSys.enabled then return end
            if SpeedSys.carryActive then return end
            if Drop and Drop.active then return end
            local st = State or _G.State
            if st and (st.batAimbotToggled or st.tpBatEnabled or st.autoLeftEnabled or st.autoRightEnabled or st._dropInProgress) then return end
            local char = LP.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if not hum or not hrp then return end
            local humState = hum:GetState()
            if hum.PlatformStand or humState == Enum.HumanoidStateType.Physics or humState == Enum.HumanoidStateType.Ragdoll then return end
            local cap = speedGetTarget()
            local ok, v = pcall(function() return hrp.AssemblyLinearVelocity end)
            if not ok or typeof(v) ~= "Vector3" then return end
            local flat = Vector3.new(v.X, 0, v.Z)
            local m = flat.Magnitude
            local newY = v.Y
            if newY > 95 then newY = 95 end
            if m > cap * 1.6 and m > 0.01 then
                local u = flat / m
                pcall(function()
                    hrp.AssemblyLinearVelocity = Vector3.new(u.X * cap, newY, u.Z * cap)
                end)
            elseif newY ~= v.Y then
                pcall(function()
                    hrp.AssemblyLinearVelocity = Vector3.new(v.X, newY, v.Z)
                end)
            end
        end

        SpeedSys.antiFling = _antiFling

        function startAntiDrop()
            if SpeedSys.clampConn then SpeedSys.clampConn:Disconnect(); SpeedSys.clampConn = nil end
            _sbStart()
            SpeedSys.clampConn = RunService.Heartbeat:Connect(_antiFling)
        end

        function stopAntiDrop()
            if SpeedSys.clampConn then SpeedSys.clampConn:Disconnect(); SpeedSys.clampConn = nil end
            _sbStop()
        end

        _G.__KyzDestroySpeedObjects = function() end
        _G.__K7CleanupSpeedPhysics = function() end
        _G.__K7SpeedFlush = function() end

        if LP.Character then
            task.wait(0.1)
            startAntiDrop()
        else
            LP.CharacterAdded:Wait()
            task.wait(0.1)
            startAntiDrop()
        end
        task.defer(function()
            pcall(startBrainrotAntiDrop)
        end)
    end


    UIS.InputBegan:Connect(function(inp, gp)
        if activeKeybindListener then return end
        if gp then return end
        uit = inp.UserInputType
        isPad = uit == Enum.UserInputType.Gamepad1 or uit == Enum.UserInputType.Gamepad2
            or uit == Enum.UserInputType.Gamepad3 or uit == Enum.UserInputType.Gamepad4
            or uit == Enum.UserInputType.Gamepad5 or uit == Enum.UserInputType.Gamepad6
            or uit == Enum.UserInputType.Gamepad7 or uit == Enum.UserInputType.Gamepad8
        if uit ~= Enum.UserInputType.Keyboard and not isPad then return end
        kc = inp.KeyCode

        if kc == Enum.KeyCode.Space then
            _spaceDown = true
            applyJumpBoost()
        end

        if Keys.speed == Keys.lagger and kc == Keys.speed then
            if State.laggerMode == 0 then
                State.laggerMode = (State.speedMode == 0) and 2 or 1
                State.lastLaggerMode = State.laggerMode
                State.speedMode = 0
            else
                State.laggerMode = 0
            end
            updateSpeedUI()
            pcall(function() if type(autoSave) == "function" then autoSave(true) else saveConfig() end end)
            return
        end

        if kc == Keys.speed then
            State.speedMode = (State.speedMode + 1) % 2
            State.laggerMode = 0
            updateSpeedUI()
            pcall(function() if type(autoSave) == "function" then autoSave(true) else saveConfig() end end)
        elseif kc == Keys.lagger then
            if State.laggerMode == 0 then
                State.laggerMode = (State.speedMode == 0) and 2 or 1
                State.lastLaggerMode = State.laggerMode
                State.speedMode = 0
            else
                State.laggerMode = (State.laggerMode == 1 and 2 or 1)
                State.lastLaggerMode = State.laggerMode
                State.speedMode = 0
            end
            updateSpeedUI()
            pcall(function() if type(autoSave) == "function" then autoSave(true) else saveConfig() end end)
        elseif kc == Keys.instaReset then
            insta_reset()
        elseif kc == Keys.autoLeft then
            if State.autoLeftEnabled then
                State.autoLeftEnabled = false
                stopAutoLeft()
            else
                State.autoLeftEnabled = true
                startAutoLeft()
            end
            task.spawn(saveConfig)
        elseif kc == Keys.autoRight then
            if State.autoRightEnabled then
                State.autoRightEnabled = false
                stopAutoRight()
            else
                State.autoRightEnabled = true
                startAutoRight()
            end
            task.spawn(saveConfig)
        elseif kc == Keys.tpDown then
            doTpDown()
        elseif kc == Keys.drop then
            runDropBrainrot()

        elseif kc == Keys.aimbot then
            State.batAimbotToggled = not State.batAimbotToggled
            if toggleRefs.aimbot then toggleRefs.aimbot(State.batAimbotToggled) end
            if State.batAimbotToggled then pcall(startBatAimbot) else pcall(stopBatAimbot) end
            pcall(function() if type(syncMobileCombatButtons) == "function" then syncMobileCombatButtons() end end)
            task.spawn(saveConfig)
        elseif kc == Keys.tpBat then
            State.tpBatEnabled = not State.tpBatEnabled
            if toggleRefs.tpBat then toggleRefs.tpBat(State.tpBatEnabled) end
            if State.tpBatEnabled then pcall(startTpBat) else pcall(stopTpBat) end
            pcall(function() if type(syncMobileCombatButtons) == "function" then syncMobileCombatButtons() end end)
            task.spawn(saveConfig)
        elseif kc == Keys.antiBatTp then
            -- antiBatTp removed
        elseif kc == Keys.guiHide then
            State.guiVisible = not State.guiVisible
            if mainOuter then
                mainOuter.Visible = State.guiVisible
            end
            if miniBtn then
                miniBtn.Visible = not State.guiVisible
            end
            task.spawn(saveConfig)
        end
    end)

    UIS.InputEnded:Connect(function(inp)
        if inp.KeyCode == Enum.KeyCode.Space then
            _spaceDown = false
            if _jumpWasHeld then
                _jumpWasHeld = false
                pcall(_clearInfJumpForce)
            end
        end
    end)

    LP.CharacterAdded:Connect(function(char)
        task.wait(0.5)
        pcall(startEnabledFeatures)
        if State.antiRagdollEnabled then
            startAntiRagdoll()
        end
        if State.medusaCounterEnabled then
            setupMedusaCounter(char)
        end
        if State.tryhardAnimEnabled then
            setCustomAnims()
        end
        if State.batAimbotToggled then
            task.defer(function()
                task.wait(0.4)
                pcall(stopBatAimbot)
                pcall(startBatAimbot)
            end)
        end
        if State.tpBatEnabled then
            task.defer(function()
                task.wait(0.4)
                pcall(stopTpBat)
                pcall(startTpBat)
            end)
        end

    end)

    if State.antiRagdollEnabled then
        startAntiRagdoll()
    end
    if LP.Character then
        if State.medusaCounterEnabled then
            setupMedusaCounter(LP.Character)
        end
        if State.tryhardAnimEnabled then
            setCustomAnims()
        end
    end


end
__KyzDuelsMain()