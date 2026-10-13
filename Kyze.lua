-- rename by prince bot
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
                _executorName = tostring( or "Unknown")
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
                        return
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
            local LocalPlayer = Players.LocalPlayer
            if not LocalPlayer then
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
                            if typeof(self) == "Instance" and self:IsA("BasePart") and self.Name == "HumanoidRootPart" and self:IsDescendantOf(LocalPlayer.Character) then
                                return spoofedVelocity
                            end
                        end
                        return oldIndex(self, key)
                    end))
                    oldNewIndex = hookmetamethod(game, "__newindex", nc(function(self, key, value)
                        if not cc() and (key == "AssemblyLinearVelocity" or key == "Velocity") then
                            if typeof(self) == "Instance" and self:IsA("BasePart") and self.Name == "HumanoidRootPart" and self:IsDescendantOf(LocalPlayer.Character) then
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
                    local SL = {
                        MOVE_KEYS = {
                            [Enum.KeyCode.W]=true,[Enum.KeyCode.A]=true,[Enum.KeyCode.S]=true,[Enum.KeyCode.D]=true,
                            [Enum.KeyCode.Up]=true,[Enum.KeyCode.Down]=true,[Enum.KeyCode.Left]=true,[Enum.KeyCode.Right]=true,
                            },
                        }
                    _G.__KyzDuelsSpeedLV = SL

                    function SL.getOrMake(hrp)
                        if not hrp then return nil end
                        for _, n in ipairs({"_RHSpeedLV", "AdaptHorizontalSpeed", "AdaptSpeedAttachment", "MuzanBoostLV"}) do
                            local o = hrp:FindFirstChild(n)
                            if o then pcall(function() o:Destroy() end) end
                        end
                        return nil
                    end

                    function SL.set(hrp, x, z)
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
                    local char = LocalPlayer.Character
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
                        return
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
                            data =
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
                        if startTime > 0 then
                            sound.TimePosition = startTime
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

                if tryFromFile() then return true end

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

            LocalPlayer.CharacterAdded:Connect(function(char)
                setupChar(char)
                if State and State.autoStealEnabled then
                    task.defer(function()
                        task.wait(0.6)
                        pcall(restartAutoStealForMode)
                    end)
                end
            end)
            if LocalPlayer.Character then
                task.spawn(function() setupChar(LocalPlayer.Character) end)
            end

            State = {
                normalSpeed = 59.5, carrySpeed = 28.8, laggerSpeed = 29, normalLaggerSpeed = 45, laggerCarrySpeed = 15,
                speedMode = 0, laggerMode = 0, lastLaggerMode = 1,
                infJumpEnabled = false, antiRagdollEnabled = true, antiDropSpoof = true, antiLagEnabled = false, transparentMapEnabled = false, xrayEnabled = false,
                batMedusaTransparent = false,
                batMedusaRainbow = false,
                batCustomEnabled = false,
                batCustomKey = "diamond",
                batNoSound = false,
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
                keyboardEnabled = false,
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
                customSkins = {},
                skinFireHead = false,
                skinHornWhite = false,
                antiDieEnabled = true,
                antiFlingEnabled = false,
                backgroundIndex = 0,
                batAimbotToggled = false,
                aimbotMode = "normal",
                tpBatEnabled = false,
                playerPosMarker = false,
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
                    local char = LocalPlayer.Character
                    if not char then return end
                    local hum = char:FindFirstChildOfClass("Humanoid")
                    if not hum or hum.Health <= 0 then return end
                    local st = hum:GetState()
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

            function isStealBlockedByRagdoll()
                return false
            end

            function waitStealRagdollGate()
                return false
            end

            _startSyncAfterHitWatcher()

            function noteStealRagdollHit()
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
                local character = LocalPlayer.Character
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
                char = LocalPlayer.Character
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

                    char = LocalPlayer.Character
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
                local char = LocalPlayer.Character
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
                        char = LocalPlayer.Character
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

                        char = LocalPlayer.Character
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
        if obj:IsA("Fire") and (obj.Name == "Custom_HeadFire" or (LocalPlayer.Character and obj:IsDescendantOf(LocalPlayer.Character))) then
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
    if State.skinFireHead and LocalPlayer.Character then
        pcall(function()
            head = LocalPlayer.Character:FindFirstChild("Head")
            f = head and head:FindFirstChild("Custom_HeadFire")
            if f and f:IsA("Fire") then
                f.Enabled = true
            elseif head then
                applyFireHead(LocalPlayer.Character)
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
    plr = LocalPlayer or Players.LocalPlayer
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
    local char = LocalPlayer and LocalPlayer.Character
    if not bat and char then
        bat = char:FindFirstChild("Bat")
    end
    if not med and char then
        med = char:FindFirstChild("Medusa's Head")
    end
    local bp = LocalPlayer and LP:FindFirstChild("Backpack")
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

BAT_CUSTOMS = {
    {
        key = "diamond",
        name = "Minecraft diamond sword",
        mesh = "rbxassetid://8827558932",
        tex = "rbxassetid://8827558969",
        scale = Vector3.new(0.2, 0.2, 0.2),
        grip = CFrame.new(-0.05, -0.1, -0.12) * CFrame.Angles(math.rad(90), math.rad(180), 300),
        id = 8827558932,
        swingSound = 83467757893556,
        },
    {
        key = "scythe_bear",
        name = "Scythe with Bear",
        id = 110490360258502,
        grip = CFrame.new(0, -0.05, -1.35) * CFrame.Angles(math.rad(20), math.rad(90), math.rad(0)),
        swingSound = 93468677306378,
        },
    {
        key = "scythe_white",
        name = "Scythe White",
        id = 103142722866846,
        grip = CFrame.new(0, -0.05, -1.35) * CFrame.Angles(math.rad(-12), math.rad(-88), math.rad(325)),
        swingSound = 83288683119028,
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

    src = nil
    handlePart = model:FindFirstChild("Handle", true)
    meshCount = 0
    for _, d in ipairs(model:GetDescendants()) do
        if d:IsA("MeshPart") or (d:IsA("BasePart") and d:FindFirstChildOfClass("SpecialMesh")) then
            meshCount = meshCount + 1
        end
    end

    if meshCount >= 2 and (model:IsA("Model") or model:IsA("Tool") or model:IsA("Folder")) then
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
            local c = LocalPlayer.Character
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
        if State and State.batNoSound then
            return
        end
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

MEDUSA_CUSTOMS = {
    {
        key = "evil",
        name = "Evil Skull",
        id = 7855324601,
        grip = CFrame.new(0, 0, 0) * CFrame.Angles(0, math.rad(180), 0),
        },
    {
        key = "ominous",
        name = "Ominous Skull",
        id = 11983700343,
        grip = CFrame.new(0, 0, 0),
        swingSound = 129030117458818,
        soundCooldown = 25,
        },
    {
        key = "cone",
        name = "Skull Cone",
        id = 88582363429320,
        grip = CFrame.new(0, 0, 0) * CFrame.Angles(0, math.rad(180), 0),
        },
    {
        key = "kamehameha",
        name = "Kamehameha",
        id = 134121959707227,
        grip = CFrame.new(0, 0, 0),
        swingSound = 138517216516736,
        soundCooldown = 25,
        },
    {
        key = "fireball",
        name = "Fire Ball",
        id = 83021250,
        grip = CFrame.new(0, 0, 0),
        swingSound = 90228815682492,
        soundCooldown = 25,
        },
    {
        key = "rasengan",
        name = "Rasengan",
        id = 131058442581341,
        grip = CFrame.new(0, 0, 0),
        swingSound = 125531138027447,
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
    local med = nil
    local plr = LocalPlayer or Players.LocalPlayer
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
        local tool = parent:IsA("Tool") and parent or parent.Parent
        if tool then _medusaCustomMuteOriginalSounds(tool) end
        return
    end
    _medusaCustom.lastSwingSoundAt = now
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

    _medusaCustomMuteOriginalSounds(tool)

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
    NC.targetZoom  = math.clamp(10, LocalPlayer.CameraMinZoomDistance, LocalPlayer.CameraMaxZoomDistance)
    NC.currentZoom = NC.targetZoom
    NC.resync = true

    if NC.zoomConn then NC.zoomConn:Disconnect() end
    NC.zoomConn = UIS.InputChanged:Connect(function(input, gameProcessed)
        if not State.noCamCollisionEnabled then return end
        if gameProcessed then return end
        if input.UserInputType == Enum.UserInputType.MouseWheel then
            local curMin = LocalPlayer.CameraMinZoomDistance
            local curMax = LocalPlayer.CameraMaxZoomDistance
            NC.targetZoom = math.clamp(NC.targetZoom - (input.Position.Z * 4), curMin, curMax)
        end
    end)

    for _, c in ipairs(NC.watchConns or {}) do pcall(function() c:Disconnect() end) end
    NC.watchConns = {}
    local function askResync() NC.resync = true end
    table.insert(NC.watchConns, LP:GetPropertyChangedSignal("CameraMinZoomDistance"):Connect(askResync))
    table.insert(NC.watchConns, LP:GetPropertyChangedSignal("CameraMaxZoomDistance"):Connect(askResync))
    table.insert(NC.watchConns, workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(askResync))
    table.insert(NC.watchConns, LocalPlayer.CharacterAdded:Connect(askResync))
    if cam0 then
        table.insert(NC.watchConns, cam0:GetPropertyChangedSignal("CameraType"):Connect(askResync))
        table.insert(NC.watchConns, cam0:GetPropertyChangedSignal("CameraSubject"):Connect(askResync))
    end

    pcall(function() RunService:UnbindFromRenderStep("AmbitiousNoCamCollision") end)
    RunService:BindToRenderStep("AmbitiousNoCamCollision", Enum.RenderPriority.Camera.Value + 1, function(deltaTime)
        if not State.noCamCollisionEnabled then return end

        local cam = workspace.CurrentCamera
        if not cam then return end
        if cam.CameraType == Enum.CameraType.Scriptable then NC.resync = true return end
        if cam.CameraSubject == nil then NC.resync = true return end

        local char = LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then NC.resync = true return end

        local curMin = LocalPlayer.CameraMinZoomDistance
        local curMax = LocalPlayer.CameraMaxZoomDistance

        if curMax <= 1 then
            NC.resync = true
            return
        end

        local realZoom = (cam.CFrame.Position - cam.Focus.Position).Magnitude

        if realZoom < 0.6 then
            NC.resync = true
            return
        end

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
        _shinyCharConn = LocalPlayer.CharacterAdded:Connect(function()
            if not State or not State.shinyGraphicsEnabled then return end
            task.delay(0.2, _shinyReapplyIfNeeded)
            task.delay(0.8, _shinyReapplyIfNeeded)
        end)
    end
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
    if p == LocalPlayer then return end
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
            myChar = LocalPlayer.Character
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
        if p ~= LocalPlayer then ESP.createForPlayer(p) end
    end
    ESP.Connection = RunService.Heartbeat:Connect(function()
        if not State.espEnabled then return end
        cam = workspace.CurrentCamera
        if not cam then return end
        myChar = LocalPlayer.Character
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
            if p ~= LocalPlayer then
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
        autoLeftPhase = true,
        autoRightPhase = true,
        }
    for k, v in pairs(State) do
        if not skip[k] then
            local t = type(v)
            if t == "boolean" or t == "number" or t == "string" then
                cfg[k] = v
            elseif t == "table" then
                if k == "guiPosition" or k == "stealBarPosition" or k == "customAnimPack"
                or k == "customSkins" or k == "skinGallery" then
                    cfg[k] = v
                end
            end
        end
    end

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

    cfg.autoStealEnabled = State.autoStealEnabled == true
    cfg.autoStealMode = State.autoStealMode or "V3"
    cfg.stealDuration = Steal and Steal.StealDuration or nil
    cfg.autoGrabStopEnabled = autoGrabStopEnabled
    cfg.autoGrabStopTime = autoGrabStopTime
    cfg.autoGrabDelayRadius = autoGrabDelayRadius

    cfg.introMode = tostring(_normalizeIntroMusicIndex(State.introMode or State.selectedIntroMusic or selectedIntroMusic or 1))
    cfg.selectedIntroMusic = _normalizeIntroMusicIndex(State.introMode or State.selectedIntroMusic or selectedIntroMusic or 1)
    cfg.skipIntroEnabled = State.skipIntroEnabled == true

    cfg.backgroundIndex = (type(backgroundIndex) == "number" and backgroundIndex) or (State.backgroundIndex or 0)

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
        char = LocalPlayer.Character
        if not char then
            char = LocalPlayer.CharacterAdded:Wait()
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

        if State.medusaCounterEnabled and LocalPlayer.Character then
            pcall(setupMedusaCounter, LocalPlayer.Character)
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
            pcall(applyAllActiveSkins, LocalPlayer.Character)
        end
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
        if State.infJumpEnabled then
        end
        if State.autoCarrySpeedEnabled then
        end
        applyTheme()
        refreshStealBarVisible()
        pcall(function()
            c = LocalPlayer.Character
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

    function getActiveMoveSpeed()
        local st = State or _G.State
        if not st then return 16 end
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
            params.FilterDescendantsInstances = { LocalPlayer.Character }
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
        c = LocalPlayer.Character
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
    loadstring(game:HttpGet("https://pastebin.com/raw/2H5JyQKE"))()
    function setBoostVelocityEnabled(on)
        pcall(function()
            local char = LocalPlayer.Character
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

_G._AmbitiousWaitCharReady = _G._AmbitiousWaitCharReady or function(ch, t)
    ch = ch or LocalPlayer.Character
    if not ch then return false end
    local deadline = os.clock() + (tonumber(t) or 5)
    while os.clock() < deadline do
        if not ch.Parent then return false end
        if LocalPlayer.Character and LocalPlayer.Character ~= ch then return false end
        if ch:FindFirstChild("Head") and ch:FindFirstChild("HumanoidRootPart") and ch:FindFirstChildOfClass("Humanoid") then
            return true
        end
        task.wait(0.05)
    end
    return false
end
_G._AmbitiousAntiVoidPaused = _G._AmbitiousAntiVoidPaused or false

do
    local MAP_BOUNDS = {
        MinX = -535.7,
        MaxX = -422.0,
        MinY = -7.9,
        MaxY = 115.0,
        MinZ = -72.0,
        MaxZ = 193.3,
        }

    local TP_TOTAL   = 150
    local TP_DELTA_Y = 100
    local WINDOW     = 0.07
    local WALK_CLEAR = 15
    local STEP_MAX   = 50

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

    local function onTeleportDetected(player, originCFrame)
        isOutOf[player] = true
        ghostCF[player] = originCFrame
        ghost[player]   = originCFrame.Position
    end

    local _rescueLastSafePos = nil
    local _rescueSpawnOrigin = nil
    local _rescueLastRescue  = 0
    local RESCUE_COOLDOWN    = 0
    local RESCUE_UPDATE_INT  = 0.1
    local _rescueLastUpdate  = 0

    local function _rescueUpdateCheckpoint()
        local c   = LocalPlayer.Character
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
        if hum.FloorMaterial ~= Enum.Material.Air and isWithinBounds(pos) then
            _rescueLastSafePos = pos
        end
    end

    local function _rescueTryRescue()
        local c   = LocalPlayer.Character
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

    RunService.Heartbeat:Connect(function()
        if not enabled() then return end
        _rescueUpdateCheckpoint()
        _rescueTryRescue()
    end)

    LocalPlayer.CharacterAdded:Connect(function()
        _rescueLastSafePos = nil
        _rescueSpawnOrigin = nil
        _rescueLastRescue  = 0
        _rescueLastUpdate  = 0
    end)

    local function trackPlayer(player)
        if player == LocalPlayer then return end
        if tracked[player] then return end
        tracked[player] = true

        local history      = {}
        local walkedXZ     = 0
        local lastCheckPos = nil

        task.spawn(function()
            while player and player.Parent do
                if not enabled() then
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

local function posForPart(part, rawPos)
    if not part then return rawPos, false end
    local model = part:FindFirstAncestorOfClass("Model")
    local player = model and Players:GetPlayerFromCharacter(model)
    return posFor(player, rawPos or part.Position)
end

_G.AmbitiousAntiVoidEnabled = _G.AmbitiousAntiVoidEnabled == true

startAll()

_G.AmbitiousAntiVoid = {
    setEnabled = function(on)
        on = on and true or false
        local was = _G.AmbitiousAntiVoidEnabled == true
        _G.AmbitiousAntiVoidEnabled = on
        if on and not was then
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

local replicas   = {}
local ghostFolder = nil

local function ensureFolder()
    if ghostFolder and ghostFolder.Parent then return ghostFolder end
    ghostFolder = Instance.new("Folder")
    ghostFolder.Name = "AmbitiousAntiVoid"
    ghostFolder.Parent = workspace
    return ghostFolder
end

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
    if not char:FindFirstChild("AmbitiousHubESP") then return end
    local ok, clone = pcall(function()
        char.Archivable = true
        return char:Clone()
    end)
    if not ok or not clone then return end

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

    local hl = clone:FindFirstChild("AmbitiousHubESP")
    if hl then pcall(function() hl.Enabled = true end) end

    local cloneHead = clone:FindFirstChild("Head")
    local tag = cloneHead and cloneHead:FindFirstChild("AmbitiousHubESPTag")
    if tag then
        pcall(function() tag.Enabled = true end)
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

local lastMarkerTick = 0
RunService.Heartbeat:Connect(function()
    local now = os.clock()
    if now - lastMarkerTick < 0.1 then return end
    lastMarkerTick = now

    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
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
    local character = LocalPlayer.Character
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
        local ch = LocalPlayer.Character
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

    if not character.Parent or LocalPlayer.Character ~= character then return end
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
    local character = LocalPlayer.Character
    if not character then _G._AmbitiousResetGaveUp = true return end
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then _G._AmbitiousResetGaveUp = true return end
    local originalHipHeight = humanoid.HipHeight
    local attempts, done = 0, false
    while character and character.Parent and humanoid
    and humanoid.Health > 0 and LocalPlayer.Character == character
    and attempts < 40 do
        pcall(function()
            humanoid.HipHeight = 1e30
            humanoid.AutoRotate = true
            for _, part in ipairs(character:GetChildren()) do
                if part:IsA("BasePart") then part.CanCollide = false end
            end
        end)
        if not character.Parent or humanoid.Health <= 0 or LocalPlayer.Character ~= character then
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
        local char = LocalPlayer.Character
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
    _G._AmbitiousResetOldChar = LocalPlayer.Character
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
            local ch = LocalPlayer.Character
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
                local ch = LocalPlayer.Character
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
    LocalPlayer.CharacterAdded:Connect(function()
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

    PM = LocalPlayer.PlayerScripts:FindFirstChild("PlayerModule")
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
        pm = LocalPlayer.PlayerScripts:FindFirstChild("PlayerModule")
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

        char = LocalPlayer.Character
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

    char = LocalPlayer.Character
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
    char = LocalPlayer.Character
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
        if p ~= LocalPlayer and p.Character then
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
    local c = LocalPlayer.Character
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
                local c = LocalPlayer.Character
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
    local char = LocalPlayer.Character
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
        local currentChar = LocalPlayer.Character
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
            local c2 = LocalPlayer.Character
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
    local char = LocalPlayer.Character
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
            if p ~= LocalPlayer and p.Character then
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
            local c = LocalPlayer.Character
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
                if player ~= LocalPlayer and player.Character then
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
        char=LocalPlayer.Character; if not char then return end
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
                        or (game.HttpGet and )
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
        char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
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
    _infJumpLV = nil
    _infJumpAtt = nil
    pcall(function()
        local c = LocalPlayer and LocalPlayer.Character
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
    pcall(function()
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
    local c = LocalPlayer.Character
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
    local c = LocalPlayer.Character
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
        char = LocalPlayer.Character
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
        char = LocalPlayer.Character
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
    char = LocalPlayer.Character
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
    char = LocalPlayer.Character
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
        char = LocalPlayer.Character
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
        char = LocalPlayer.Character
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
    c=LocalPlayer.Character; if not c then return nil end
    bp=LP:FindFirstChildOfClass("Backpack")
    if not BAT_SLAP_LIST then return nil end
    for _,name in ipairs(BAT_SLAP_LIST) do local t=c:FindFirstChild(name) or (bp and bp:FindFirstChild(name)); if t then return t end end
    return nil
end

function startBatCounter()
    if Conns.batCounter then return end
    Conns.batCounter=RunService.Heartbeat:Connect(function()
        if not State.batCounterEnabled or State.batCounterDebounce then return end
        char=LocalPlayer.Character; if not char then return end
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
    c=LocalPlayer.Character; if not c then return nil end
    for _,t in ipairs(c:GetChildren()) do if t:IsA("Tool") then local n=t.Name:lower(); if n:find("medusa") or n:find("head") or n:find("stone") then return t end end end
    bp=LP:FindFirstChild("Backpack")
    if bp then for _,t in ipairs(bp:GetChildren()) do if t:IsA("Tool") then local n=t.Name:lower(); if n:find("medusa") then return t end end end end
    return nil
end

function useMedusaCounter()
    if State.medusaDebounce or tick()-State.medusaLastUsed<MEDUSA_COOLDOWN then return end
    c=LocalPlayer.Character; if not c then return end
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
    LocalPlayer.CharacterAdded:Connect(function(char)
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

LocalPlayer.CharacterAdded:Connect(function(char)
    char.ChildAdded:Connect(hookMedusa)
    for _, t in ipairs(char:GetChildren()) do hookMedusa(t) end
end)
if LocalPlayer.Character then
    for _, t in ipairs(LocalPlayer.Character:GetChildren()) do hookMedusa(t) end
    LocalPlayer.Character.ChildAdded:Connect(hookMedusa)
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
    local id = tonumber(raw)
    if id and id > 0 then
        return {
            url = "rbxassetid://" .. tostring(id),
            file = "kyzDuels_hub_bg_custom_" .. tostring(id) .. ".png",
            custom = true,
            rbxId = id,
            }
    end
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
                        data = (_G.__KyzDuelsHttpGet and _G.__KyzDuelsHttpGet(def.url, true)) or (game.HttpGet and ) or (HttpGet and HttpGet(def.url))
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
                        data = (_G.__KyzDuelsHttpGet and _G.__KyzDuelsHttpGet(def.url, true)) or (game.HttpGet and ) or (HttpGet and HttpGet(def.url))
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
                    data = (_G.__KyzDuelsHttpGet and _G.__KyzDuelsHttpGet(BORDER_URL, true)) or (game.HttpGet and ) or (HttpGet and HttpGet(BORDER_URL))
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
                    data = (_G.__KyzDuelsHttpGet and _G.__KyzDuelsHttpGet(url)) or (game.HttpGet and ) or (HttpGet and HttpGet(url))
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
    botSep.Name = "Bot